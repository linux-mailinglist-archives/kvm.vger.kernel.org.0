Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28836560E66
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 02:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiF3A6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 20:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiF3A6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 20:58:12 -0400
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 17:57:53 PDT
Received: from mout-u-204.mailbox.org (mout-u-204.mailbox.org [IPv6:2001:67c:2050:101:465::204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0013FDB1
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 17:57:52 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-204.mailbox.org (Postfix) with ESMTPS id 4LYKWv3T4sz9sWk;
        Thu, 30 Jun 2022 02:51:07 +0200 (CEST)
From:   Lev Kujawski <lkujaw@member.fsf.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Lev Kujawski <lkujaw@member.fsf.org>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH v4 1/3] hw/pci-host/pam.c: Fully support RE^WE semantics of i440FX PAM
Date:   Thu, 30 Jun 2022 00:50:56 +0000
Message-Id: <20220630005058.500449-2-lkujaw@member.fsf.org>
In-Reply-To: <20220630005058.500449-1-lkujaw@member.fsf.org>
References: <20220630005058.500449-1-lkujaw@member.fsf.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4LYKWv3T4sz9sWk
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Programmable Attribute Registers (PAM) of QEMU's emulated i440FX
chipset now fully support the exclusive Read Enable (RE) and Write
Enable (WE) modes by forwarding reads of the applicable PAM region to
RAM and writes to the bus or vice versa, respectively.  This chipset
functionality is often used by x86 firmware for shadowing ROM.

For the WE case, the prior behavior was to create a RAM alias, but
reads were not forwarded to the bus.  This prevents the classic BIOS
shadowing mechanism, which is executing from flash ROM while copying
the contents to the equivalent location in RAM.

Support for PAM_WE involved adding a ROMD mode to QEMU's Memory
Sections, similar to the existing support for read-only sections.
When a write is made to a read-only memory region within a ROMD
section, QEMU will conduct a downwards hierarchical search from the
root for a ROMD region that is marked read-only (unlike normal ROMD
regions); this region receives the write as an MMIO operation.

* accel/kvm/kvm-all.c
- kvm_set_phys_mem: Also ignore read-only memory regions that are not
  backed by RAM.

* accel/tcg/cputlb.c
- tlb_set_page_with_attrs: Handle the case of RAM regions within ROMD
  sections.
- io_writex: Search for the actual ROMD memory region when writing.

* hw/i386/pc.c
- Split the RAM into conventional and extended areas, so as to avoid
  double-aliasing with PAM.
- Create a new E820 entry to account for the resultant gap over the
  ISA MMIO area [0xA0000-0XFFFFF], which firmware or the operating
  system can fill with cache/shadow memory if desired.

* include/hw/pci-host/i440fx.h
* include/hw/pci-host/q35.h
- Add address spaces for both RAM and MMIO to the PCI host state.

* hw/pci-host/i440fx.c
* hw/pci-host/q35.c
- Initialize RAM and MMIO address spaces for use by pam.c.
- Adjust init_pam and pam_update calls for updated parameters.
- Now that RAM is not normally exposed within the ISA MMIO area,
  invert the logic of enabling/disabling the SMRAM region.

* hw/pci-host/pam.c
- pam_rmem_write: Write to the PCI address space to forward ISA area
  MMIO writes.
- pam_wmem_write: Write to the RAM address space, aborting when there
  are memory transaction errors.
- Make the PAM memory region a read-only ROMD container in the PAM_RE
  and PAM_WE modes.  Reads will pass through to any underlying ROMs,
  enabling the traditional execute-in-place behavior.
- Remove PAM aliases entirely when mode 0 (the default) is active, as
  it is no longer necessary to hide underlying RAM.

* include/exec/memory.h
- Add romd_mode to MemoryRegionSection, check when testing for
  equivalency.
- Add a prototype for the hierarchical search function
  memory_region_find_romd_container.

* softmmu/memory.c
- render_memory_region: Mark romd_mode when a read-only ROMD memory
  region container is encountered.
- Define the hierarchical search function
  memory_region_find_romd_container.

* softmmu/physmem.c
- flatview_translate: Search for the controlling ROMD memory region
  when writing to a read-only section marked for romd_mode.

Tested with SeaBIOS and AMIBIOS.

Signed-off-by: Lev Kujawski <lkujaw@member.fsf.org>
---
(v4) Revamp to support execution in place for PCI ROMs in WE mode (2)
     using the new romd memory section support in the QEMU MMU.

     The romd memory section support obviates the need for a ROMD
     region or the flushing in v3.
(v3) Relocate ownership of the RAM address space into the respective
     PAM-utilizing chipsets to reduce memory usage and eliminate mtree
     duplicates.
     Avoid changing the PAM region if possible.
     Flush ROM after writing.
(v2) Write to an AddressSpace mapped over ram_memory instead of using
     a pointer, as it suprisingly may not be backed by RAM on, e.g.,
     NUMA configurations.

 accel/kvm/kvm-all.c          |   2 +-
 accel/tcg/cputlb.c           |  14 ++-
 hw/i386/pc.c                 |  19 +++-
 hw/pci-host/i440fx.c         |  34 +++---
 hw/pci-host/pam.c            | 193 +++++++++++++++++++++++++++++------
 hw/pci-host/q35.c            |  50 +++++----
 include/exec/memory.h        |  19 ++++
 include/hw/pci-host/i440fx.h |   2 +
 include/hw/pci-host/pam.h    |  19 +++-
 include/hw/pci-host/q35.h    |   2 +
 softmmu/memory.c             |  58 ++++++++++-
 softmmu/physmem.c            |   5 +
 12 files changed, 336 insertions(+), 81 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index ba3210b1c1..a8ef0605a1 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1353,7 +1353,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
     void *ram;
 
     if (!memory_region_is_ram(mr)) {
-        if (writable || !kvm_readonly_mem_allowed) {
+        if (!mr->ram_block || writable || !kvm_readonly_mem_allowed) {
             return;
         } else if (!mr->romd_mode) {
             /* If the memory device is not in romd_mode, then we actually want
diff --git a/accel/tcg/cputlb.c b/accel/tcg/cputlb.c
index f90f4312ea..2e8df6a906 100644
--- a/accel/tcg/cputlb.c
+++ b/accel/tcg/cputlb.c
@@ -1161,7 +1161,7 @@ void tlb_set_page_with_attrs(CPUState *cpu, target_ulong vaddr,
     }
 
     write_address = address;
-    if (is_ram) {
+    if (!section->romd_mode && is_ram) {
         iotlb = memory_region_get_ram_addr(section->mr) + xlat;
         /*
          * Computing is_clean is expensive; avoid all that unless
@@ -1183,7 +1183,7 @@ void tlb_set_page_with_attrs(CPUState *cpu, target_ulong vaddr,
          * but of course reads to I/O must go through MMIO.
          */
         write_address |= TLB_MMIO;
-        if (!is_romd) {
+        if (!is_romd && !is_ram) {
             address = write_address;
         }
     }
@@ -1409,8 +1409,14 @@ static void io_writex(CPUArchState *env, CPUIOTLBEntry *iotlbentry,
     MemTxResult r;
 
     section = iotlb_to_section(cpu, iotlbentry->addr, iotlbentry->attrs);
-    mr = section->mr;
-    mr_offset = (iotlbentry->addr & TARGET_PAGE_MASK) + addr;
+    if (likely(!section->romd_mode)) {
+        mr = section->mr;
+        mr_offset = (iotlbentry->addr & TARGET_PAGE_MASK) + addr;
+    } else {
+        mr = memory_region_find_romd_container(section->fv->root,
+                                               addr, &mr_offset);
+        assert(mr != NULL);
+    }
     if (!cpu->can_do_io) {
         cpu_io_recompile(cpu, retaddr);
     }
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 774cb2bf07..6e56cb7595 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -808,11 +808,13 @@ void xen_load_linux(PCMachineState *pcms)
     x86ms->fw_cfg = fw_cfg;
 }
 
+#define PC_BUS_BASE        0xa0000
 #define PC_ROM_MIN_VGA     0xc0000
 #define PC_ROM_MIN_OPTION  0xc8000
 #define PC_ROM_MAX         0xe0000
 #define PC_ROM_ALIGN       0x800
 #define PC_ROM_SIZE        (PC_ROM_MAX - PC_ROM_MIN_VGA)
+#define PC_MEM_EXT_BASE    0x100000
 
 void pc_memory_init(PCMachineState *pcms,
                     MemoryRegion *system_memory,
@@ -821,7 +823,7 @@ void pc_memory_init(PCMachineState *pcms,
 {
     int linux_boot, i;
     MemoryRegion *option_rom_mr;
-    MemoryRegion *ram_below_4g, *ram_above_4g;
+    MemoryRegion *ram_conventional, *ram_below_4g, *ram_above_4g;
     FWCfgState *fw_cfg;
     MachineState *machine = MACHINE(pcms);
     MachineClass *mc = MACHINE_GET_CLASS(machine);
@@ -839,11 +841,20 @@ void pc_memory_init(PCMachineState *pcms,
      * done for backwards compatibility with older qemus.
      */
     *ram_memory = machine->ram;
+
+    ram_conventional = g_malloc(sizeof(*ram_conventional));
+    memory_region_init_alias(ram_conventional, NULL, "ram-conventional",
+                             machine->ram, 0, PC_BUS_BASE);
+    memory_region_add_subregion(system_memory, 0, ram_conventional);
+    e820_add_entry(0, PC_BUS_BASE, E820_RAM);
+
     ram_below_4g = g_malloc(sizeof(*ram_below_4g));
     memory_region_init_alias(ram_below_4g, NULL, "ram-below-4g", machine->ram,
-                             0, x86ms->below_4g_mem_size);
-    memory_region_add_subregion(system_memory, 0, ram_below_4g);
-    e820_add_entry(0, x86ms->below_4g_mem_size, E820_RAM);
+        PC_MEM_EXT_BASE, x86ms->below_4g_mem_size - PC_MEM_EXT_BASE);
+    memory_region_add_subregion(system_memory, PC_MEM_EXT_BASE, ram_below_4g);
+    e820_add_entry(PC_MEM_EXT_BASE,
+                   x86ms->below_4g_mem_size - PC_MEM_EXT_BASE, E820_RAM);
+
     if (x86ms->above_4g_mem_size > 0) {
         ram_above_4g = g_malloc(sizeof(*ram_above_4g));
         memory_region_init_alias(ram_above_4g, NULL, "ram-above-4g",
diff --git a/hw/pci-host/i440fx.c b/hw/pci-host/i440fx.c
index e08716142b..cdf92f0ab4 100644
--- a/hw/pci-host/i440fx.c
+++ b/hw/pci-host/i440fx.c
@@ -71,11 +71,11 @@ static void i440fx_update_memory_mappings(PCII440FXState *d)
 
     memory_region_transaction_begin();
     for (i = 0; i < ARRAY_SIZE(d->pam_regions); i++) {
-        pam_update(&d->pam_regions[i], i,
+        pam_update(&d->pam_regions[i], d->system_memory, i,
                    pd->config[I440FX_PAM + DIV_ROUND_UP(i, 2)]);
     }
     memory_region_set_enabled(&d->smram_region,
-                              !(pd->config[I440FX_SMRAM] & SMRAM_D_OPEN));
+                              pd->config[I440FX_SMRAM] & SMRAM_D_OPEN);
     memory_region_set_enabled(&d->smram,
                               pd->config[I440FX_SMRAM] & SMRAM_G_SMRAME);
     memory_region_transaction_commit();
@@ -278,13 +278,6 @@ PCIBus *i440fx_init(const char *host_type, const char *pci_type,
     pc_pci_as_mapping_init(OBJECT(f), f->system_memory,
                            f->pci_address_space);
 
-    /* if *disabled* show SMRAM to all CPUs */
-    memory_region_init_alias(&f->smram_region, OBJECT(d), "smram-region",
-                             f->pci_address_space, 0xa0000, 0x20000);
-    memory_region_add_subregion_overlap(f->system_memory, 0xa0000,
-                                        &f->smram_region, 1);
-    memory_region_set_enabled(&f->smram_region, true);
-
     /* smram, as seen by SMM CPUs */
     memory_region_init(&f->smram, OBJECT(d), "smram", 4 * GiB);
     memory_region_set_enabled(&f->smram, true);
@@ -295,12 +288,25 @@ PCIBus *i440fx_init(const char *host_type, const char *pci_type,
     object_property_add_const_link(qdev_get_machine(), "smram",
                                    OBJECT(&f->smram));
 
-    init_pam(dev, f->ram_memory, f->system_memory, f->pci_address_space,
-             &f->pam_regions[0], PAM_BIOS_BASE, PAM_BIOS_SIZE);
+    /* if enabled show SMRAM to all CPUs */
+    memory_region_init_alias(&f->smram_region, OBJECT(d), "smram-region",
+                             &f->low_smram, 0, 0x20000);
+    memory_region_set_enabled(&f->smram_region, false);
+    memory_region_add_subregion_overlap(f->system_memory, 0xa0000,
+                                        &f->smram_region, 1);
+
+    address_space_init(&f->address_space_ram, ram_memory,
+                       "i440FX-RAM");
+    address_space_init(&f->address_space_mmio, pci_address_space,
+                       "i440FX-MMIO");
+
+    init_pam(dev, &f->address_space_ram, &f->address_space_mmio,
+             f->ram_memory, f->pci_address_space, &f->pam_regions[0],
+             PAM_BIOS_BASE, PAM_BIOS_SIZE);
     for (i = 0; i < ARRAY_SIZE(f->pam_regions) - 1; ++i) {
-        init_pam(dev, f->ram_memory, f->system_memory, f->pci_address_space,
-                 &f->pam_regions[i+1], PAM_EXPAN_BASE + i * PAM_EXPAN_SIZE,
-                 PAM_EXPAN_SIZE);
+        init_pam(dev, &f->address_space_ram, &f->address_space_mmio,
+                 f->ram_memory, f->pci_address_space, &f->pam_regions[i + 1],
+                 PAM_EXPAN_BASE + i * PAM_EXPAN_SIZE, PAM_EXPAN_SIZE);
     }
 
     ram_size = ram_size / 8 / 1024 / 1024;
diff --git a/hw/pci-host/pam.c b/hw/pci-host/pam.c
index 454dd120db..30c0c8d76c 100644
--- a/hw/pci-host/pam.c
+++ b/hw/pci-host/pam.c
@@ -28,43 +28,178 @@
  */
 
 #include "qemu/osdep.h"
+#include "qapi/error.h"
 #include "hw/pci-host/pam.h"
 
-void init_pam(DeviceState *dev, MemoryRegion *ram_memory,
-              MemoryRegion *system_memory, MemoryRegion *pci_address_space,
-              PAMMemoryRegion *mem, uint32_t start, uint32_t size)
+static void
+pam_rmem_write(void *opaque, hwaddr addr, uint64_t val, unsigned int size)
 {
-    int i;
-
-    /* RAM */
-    memory_region_init_alias(&mem->alias[3], OBJECT(dev), "pam-ram", ram_memory,
-                             start, size);
-    /* ROM (XXX: not quite correct) */
-    memory_region_init_alias(&mem->alias[1], OBJECT(dev), "pam-rom", ram_memory,
-                             start, size);
-    memory_region_set_readonly(&mem->alias[1], true);
-
-    /* XXX: should distinguish read/write cases */
-    memory_region_init_alias(&mem->alias[0], OBJECT(dev), "pam-pci", pci_address_space,
-                             start, size);
-    memory_region_init_alias(&mem->alias[2], OBJECT(dev), "pam-pci", ram_memory,
-                             start, size);
+    PAMMemoryRegion * const pam = (PAMMemoryRegion *)opaque;
 
-    memory_region_transaction_begin();
-    for (i = 0; i < 4; ++i) {
-        memory_region_set_enabled(&mem->alias[i], false);
-        memory_region_add_subregion_overlap(system_memory, start,
-                                            &mem->alias[i], 1);
+    switch (size) {
+    case 1:
+        stb_phys(pam->pci_as, pam->offset + addr, val);
+        break;
+    case 2:
+        stw_le_phys(pam->pci_as, pam->offset + addr, val);
+        break;
+    case 4:
+        stl_le_phys(pam->pci_as, pam->offset + addr, val);
+        break;
+    case 8:
+        stq_le_phys(pam->pci_as, pam->offset + addr, val);
+        break;
+    default:
+        g_assert_not_reached();
     }
+}
+
+static const MemoryRegionOps pam_rmem_ops = {
+    .write = pam_rmem_write,
+    .endianness = DEVICE_LITTLE_ENDIAN,
+    .valid = {
+        .min_access_size = 1,
+        .max_access_size = 8,
+        .unaligned = true,
+    },
+    .impl = {
+        .min_access_size = 1,
+        .max_access_size = 8,
+        .unaligned = true,
+    },
+};
+
+static uint64_t
+pam_wmem_read(void *opaque, hwaddr addr, unsigned int size)
+{
+    uint64_t val = ~0;
+
+    return val;
+}
+
+static void
+pam_wmem_write(void *opaque, hwaddr addr, uint64_t val, unsigned int size)
+{
+    PAMMemoryRegion * const pam = (PAMMemoryRegion *)opaque;
+    MemTxResult result = MEMTX_ERROR;
+
+    switch (size) {
+    case 1:
+        address_space_stb(pam->ram_as, pam->offset + addr, val,
+                          MEMTXATTRS_UNSPECIFIED, &result);
+        break;
+    case 2:
+        address_space_stw_le(pam->ram_as, pam->offset + addr, val,
+                             MEMTXATTRS_UNSPECIFIED, &result);
+        break;
+    case 4:
+        address_space_stl_le(pam->ram_as, pam->offset + addr, val,
+                             MEMTXATTRS_UNSPECIFIED, &result);
+        break;
+    case 8:
+        address_space_stq_le(pam->ram_as, pam->offset + addr, val,
+                             MEMTXATTRS_UNSPECIFIED, &result);
+        break;
+    default:
+        g_assert_not_reached();
+    }
+
+    assert(result == MEMTX_OK);
+}
+
+static const MemoryRegionOps pam_wmem_ops = {
+    .read = pam_wmem_read,
+    .write = pam_wmem_write,
+    .endianness = DEVICE_LITTLE_ENDIAN,
+    .valid = {
+        .min_access_size = 1,
+        .max_access_size = 8,
+        .unaligned = true,
+    },
+    .impl = {
+        .min_access_size = 1,
+        .max_access_size = 8,
+        .unaligned = true,
+    },
+};
+
+void
+init_pam(DeviceState *dev, AddressSpace *ram_as, AddressSpace *pci_as,
+         MemoryRegion *ram_mr, MemoryRegion *pci_mr,
+         PAMMemoryRegion *pam, uint32_t start, uint32_t size)
+{
+    pam->ram_as = ram_as;
+    pam->pci_as = pci_as;
+    pam->offset = start;
+
+    memory_region_transaction_begin();
+
+    /* Split modes */
+    memory_region_init_io(&pam->mr, OBJECT(dev), &pam_wmem_ops,
+                          pam, "pam", size);
+    /* Make pam->mr a ROMD container.  */
+    memory_region_set_readonly(&pam->mr, true);
+    memory_region_set_enabled(&pam->mr, true);
+
+    /* Forward memory accesses to ram.  */
+    memory_region_init_alias(&pam->ram_mr, OBJECT(dev),
+                             "pam-ram", ram_mr, start, size);
+    memory_region_set_enabled(&pam->ram_mr, true);
+
+    /* Forward memory accesses to the bus.  */
+    memory_region_init_alias(&pam->pci_mr, OBJECT(dev),
+                             "pam-pci", pci_mr, start, size);
+    memory_region_set_enabled(&pam->pci_mr, true);
+
     memory_region_transaction_commit();
-    mem->current = 0;
+
+    pam->current = 0;
 }
 
-void pam_update(PAMMemoryRegion *pam, int idx, uint8_t val)
+void
+pam_update(PAMMemoryRegion *pam, MemoryRegion *system,
+           uint8_t idx, uint8_t val)
 {
-    assert(0 <= idx && idx < PAM_REGIONS_COUNT);
+    uint8_t ai;
+    assert(idx < PAM_REGIONS_COUNT);
 
-    memory_region_set_enabled(&pam->alias[pam->current], false);
-    pam->current = (val >> ((!(idx & 1)) * 4)) & PAM_ATTR_MASK;
-    memory_region_set_enabled(&pam->alias[pam->current], true);
+    ai = (val >> ((!(idx & 1)) * 4)) & PAM_ATTR_MASK;
+
+    if (ai != pam->current) {
+        switch (pam->current) {
+        case 1:
+            memory_region_del_subregion(&pam->mr, &pam->ram_mr);
+            memory_region_del_subregion(system, &pam->mr);
+            break;
+        case 2:
+            memory_region_del_subregion(&pam->mr, &pam->pci_mr);
+            memory_region_del_subregion(system, &pam->mr);
+            break;
+        case 3:
+            memory_region_del_subregion(system, &pam->ram_mr);
+            break;
+        }
+
+        switch (ai) {
+        case 1: /* PAM_RE */
+            pam->mr.ops = &pam_rmem_ops;
+            memory_region_add_subregion_overlap(system, pam->offset,
+                                                &pam->mr, 0);
+            memory_region_add_subregion_overlap(&pam->mr, 0,
+                                                &pam->ram_mr, 0);
+            break;
+        case 2: /* PAM_WE */
+            pam->mr.ops = &pam_wmem_ops;
+            memory_region_add_subregion_overlap(system, pam->offset,
+                                                &pam->mr, 0);
+            memory_region_add_subregion_overlap(&pam->mr, 0,
+                                                &pam->pci_mr, 0);
+            break;
+        case 3: /* PAM_RE | PAM_WE */
+            memory_region_add_subregion_overlap(system, pam->offset,
+                                                &pam->ram_mr, 0);
+            break;
+        }
+        pam->current = ai;
+    }
 }
diff --git a/hw/pci-host/q35.c b/hw/pci-host/q35.c
index 20da121374..1bc4750efb 100644
--- a/hw/pci-host/q35.c
+++ b/hw/pci-host/q35.c
@@ -338,7 +338,7 @@ static void mch_update_pam(MCHPCIState *mch)
 
     memory_region_transaction_begin();
     for (i = 0; i < 13; i++) {
-        pam_update(&mch->pam_regions[i], i,
+        pam_update(&mch->pam_regions[i], mch->system_memory, i,
                    pd->config[MCH_HOST_BRIDGE_PAM0 + DIV_ROUND_UP(i, 2)]);
     }
     memory_region_transaction_commit();
@@ -362,12 +362,12 @@ static void mch_update_smram(MCHPCIState *mch)
 
     if (pd->config[MCH_HOST_BRIDGE_SMRAM] & SMRAM_D_OPEN) {
         /* Hide (!) low SMRAM if H_SMRAME = 1 */
-        memory_region_set_enabled(&mch->smram_region, h_smrame);
+        memory_region_set_enabled(&mch->smram_region, !h_smrame);
         /* Show high SMRAM if H_SMRAME = 1 */
         memory_region_set_enabled(&mch->open_high_smram, h_smrame);
     } else {
         /* Hide high SMRAM and low SMRAM */
-        memory_region_set_enabled(&mch->smram_region, true);
+        memory_region_set_enabled(&mch->smram_region, false);
         memory_region_set_enabled(&mch->open_high_smram, false);
     }
 
@@ -577,21 +577,6 @@ static void mch_realize(PCIDevice *d, Error **errp)
     pc_pci_as_mapping_init(OBJECT(mch), mch->system_memory,
                            mch->pci_address_space);
 
-    /* if *disabled* show SMRAM to all CPUs */
-    memory_region_init_alias(&mch->smram_region, OBJECT(mch), "smram-region",
-                             mch->pci_address_space, MCH_HOST_BRIDGE_SMRAM_C_BASE,
-                             MCH_HOST_BRIDGE_SMRAM_C_SIZE);
-    memory_region_add_subregion_overlap(mch->system_memory, MCH_HOST_BRIDGE_SMRAM_C_BASE,
-                                        &mch->smram_region, 1);
-    memory_region_set_enabled(&mch->smram_region, true);
-
-    memory_region_init_alias(&mch->open_high_smram, OBJECT(mch), "smram-open-high",
-                             mch->ram_memory, MCH_HOST_BRIDGE_SMRAM_C_BASE,
-                             MCH_HOST_BRIDGE_SMRAM_C_SIZE);
-    memory_region_add_subregion_overlap(mch->system_memory, 0xfeda0000,
-                                        &mch->open_high_smram, 1);
-    memory_region_set_enabled(&mch->open_high_smram, false);
-
     /* smram, as seen by SMM CPUs */
     memory_region_init(&mch->smram, OBJECT(mch), "smram", 4 * GiB);
     memory_region_set_enabled(&mch->smram, true);
@@ -607,6 +592,22 @@ static void mch_realize(PCIDevice *d, Error **errp)
     memory_region_set_enabled(&mch->high_smram, true);
     memory_region_add_subregion(&mch->smram, 0xfeda0000, &mch->high_smram);
 
+    /* if enabled show SMRAM to all CPUs */
+    memory_region_init_alias(&mch->smram_region, OBJECT(mch),
+                             "smram-region", &mch->low_smram, 0,
+                             MCH_HOST_BRIDGE_SMRAM_C_SIZE);
+    memory_region_set_enabled(&mch->smram_region, false);
+    memory_region_add_subregion_overlap(mch->system_memory,
+                                        MCH_HOST_BRIDGE_SMRAM_C_BASE,
+                                        &mch->smram_region, 1);
+
+    memory_region_init_alias(&mch->open_high_smram, OBJECT(mch),
+                             "smram-open-high", &mch->low_smram, 0,
+                             MCH_HOST_BRIDGE_SMRAM_C_SIZE);
+    memory_region_set_enabled(&mch->open_high_smram, false);
+    memory_region_add_subregion_overlap(mch->system_memory, 0xfeda0000,
+                                        &mch->open_high_smram, 1);
+
     memory_region_init_io(&mch->tseg_blackhole, OBJECT(mch),
                           &blackhole_ops, NULL,
                           "tseg-blackhole", 0);
@@ -644,12 +645,19 @@ static void mch_realize(PCIDevice *d, Error **errp)
     object_property_add_const_link(qdev_get_machine(), "smram",
                                    OBJECT(&mch->smram));
 
-    init_pam(DEVICE(mch), mch->ram_memory, mch->system_memory,
+    address_space_init(&mch->address_space_ram, mch->ram_memory,
+                       "ich9-ram");
+    address_space_init(&mch->address_space_mmio, mch->pci_address_space,
+                       "ich9-mmio");
+
+    init_pam(DEVICE(mch), &mch->address_space_ram,
+             &mch->address_space_mmio, mch->ram_memory,
              mch->pci_address_space, &mch->pam_regions[0],
              PAM_BIOS_BASE, PAM_BIOS_SIZE);
     for (i = 0; i < ARRAY_SIZE(mch->pam_regions) - 1; ++i) {
-        init_pam(DEVICE(mch), mch->ram_memory, mch->system_memory,
-                 mch->pci_address_space, &mch->pam_regions[i+1],
+        init_pam(DEVICE(mch), &mch->address_space_ram,
+                 &mch->address_space_mmio, mch->ram_memory,
+                 mch->pci_address_space, &mch->pam_regions[i + 1],
                  PAM_EXPAN_BASE + i * PAM_EXPAN_SIZE, PAM_EXPAN_SIZE);
     }
 }
diff --git a/include/exec/memory.h b/include/exec/memory.h
index a6a0f4d8ad..500f8d9675 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -90,6 +90,7 @@ struct ReservedRegion {
  * @size: the size of the section; will not exceed @mr's boundaries
  * @offset_within_address_space: the address of the first byte of the section
  *     relative to the region's address space
+ * @romd_mode: writes to this section are forwarded to a container
  * @readonly: writes to this section are ignored
  * @nonvolatile: this section is non-volatile
  */
@@ -99,6 +100,7 @@ struct MemoryRegionSection {
     FlatView *fv;
     hwaddr offset_within_region;
     hwaddr offset_within_address_space;
+    bool romd_mode;
     bool readonly;
     bool nonvolatile;
 };
@@ -1105,6 +1107,7 @@ static inline bool MemoryRegionSection_eq(MemoryRegionSection *a,
            a->offset_within_region == b->offset_within_region &&
            a->offset_within_address_space == b->offset_within_address_space &&
            int128_eq(a->size, b->size) &&
+           a->romd_mode == b->romd_mode &&
            a->readonly == b->readonly &&
            a->nonvolatile == b->nonvolatile;
 }
@@ -2370,6 +2373,22 @@ void memory_region_set_ram_discard_manager(MemoryRegion *mr,
 MemoryRegionSection memory_region_find(MemoryRegion *mr,
                                        hwaddr addr, uint64_t size);
 
+/**
+ * memory_region_find_romd_container: Descends the region hierarchy
+ * within @mr to find the first read-only ROMD container, returning a
+ * pointer to the same or NULL if not found.
+ *
+ * The primary purpose of this function is to implement the romd_mode
+ * of #MemoryRegionSection.
+ *
+ * @mr: MemoryRegion root to search for the uppermost ROMD container
+ * @addr: Address of memory within romd_mode #MemoryRegionSection
+ * @xlat: @addr relative to the start of the ROMD container
+ */
+MemoryRegion *
+memory_region_find_romd_container(MemoryRegion *mr,
+                                  hwaddr addr, hwaddr *xlat);
+
 /**
  * memory_global_dirty_log_sync: synchronize the dirty log for all memory
  *
diff --git a/include/hw/pci-host/i440fx.h b/include/hw/pci-host/i440fx.h
index f068aaba8f..77457a1418 100644
--- a/include/hw/pci-host/i440fx.h
+++ b/include/hw/pci-host/i440fx.h
@@ -25,6 +25,8 @@ struct PCII440FXState {
     PCIDevice parent_obj;
     /*< public >*/
 
+    AddressSpace address_space_ram;
+    AddressSpace address_space_mmio;
     MemoryRegion *system_memory;
     MemoryRegion *pci_address_space;
     MemoryRegion *ram_memory;
diff --git a/include/hw/pci-host/pam.h b/include/hw/pci-host/pam.h
index c1fd06ba2a..3fe17f09d5 100644
--- a/include/hw/pci-host/pam.h
+++ b/include/hw/pci-host/pam.h
@@ -83,12 +83,21 @@
 #define PAM_REGIONS_COUNT       13
 
 typedef struct PAMMemoryRegion {
-    MemoryRegion alias[4];  /* index = PAM value */
-    unsigned current;
+    AddressSpace *ram_as;
+    AddressSpace *pci_as;
+    MemoryRegion mr;
+    MemoryRegion pci_mr;
+    MemoryRegion ram_mr;
+    ram_addr_t offset;
+    uint8_t current;
 } PAMMemoryRegion;
 
-void init_pam(DeviceState *dev, MemoryRegion *ram, MemoryRegion *system,
-              MemoryRegion *pci, PAMMemoryRegion *mem, uint32_t start, uint32_t size);
-void pam_update(PAMMemoryRegion *mem, int idx, uint8_t val);
+void init_pam(DeviceState *dev, AddressSpace *ram_as, AddressSpace *pci_as,
+              MemoryRegion *ram_mr, MemoryRegion *pci_mr,
+              PAMMemoryRegion *pam, uint32_t start, uint32_t size);
+
+/* The caller is responsible for setting up a memory transaction.  */
+void pam_update(PAMMemoryRegion *pam, MemoryRegion *system,
+                uint8_t idx, uint8_t val);
 
 #endif /* QEMU_PAM_H */
diff --git a/include/hw/pci-host/q35.h b/include/hw/pci-host/q35.h
index ab989698ef..6a4f9f4711 100644
--- a/include/hw/pci-host/q35.h
+++ b/include/hw/pci-host/q35.h
@@ -40,6 +40,8 @@ struct MCHPCIState {
     PCIDevice parent_obj;
     /*< public >*/
 
+    AddressSpace address_space_ram;
+    AddressSpace address_space_mmio;
     MemoryRegion *ram_memory;
     MemoryRegion *pci_address_space;
     MemoryRegion *system_memory;
diff --git a/softmmu/memory.c b/softmmu/memory.c
index 7ba2048836..773bd4eed2 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -220,6 +220,7 @@ struct FlatRange {
     hwaddr offset_in_region;
     AddrRange addr;
     uint8_t dirty_log_mask;
+    bool romd_section;
     bool romd_mode;
     bool readonly;
     bool nonvolatile;
@@ -237,6 +238,7 @@ section_from_flat_range(FlatRange *fr, FlatView *fv)
         .offset_within_region = fr->offset_in_region,
         .size = fr->addr.size,
         .offset_within_address_space = int128_get64(fr->addr.start),
+        .romd_mode = fr->romd_section,
         .readonly = fr->readonly,
         .nonvolatile = fr->nonvolatile,
     };
@@ -247,6 +249,7 @@ static bool flatrange_equal(FlatRange *a, FlatRange *b)
     return a->mr == b->mr
         && addrrange_equal(a->addr, b->addr)
         && a->offset_in_region == b->offset_in_region
+        && a->romd_section == b->romd_section
         && a->romd_mode == b->romd_mode
         && a->readonly == b->readonly
         && a->nonvolatile == b->nonvolatile;
@@ -320,6 +323,7 @@ static bool can_merge(FlatRange *r1, FlatRange *r2)
                                 r1->addr.size),
                      int128_make64(r2->offset_in_region))
         && r1->dirty_log_mask == r2->dirty_log_mask
+        && r1->romd_section == r2->romd_section
         && r1->romd_mode == r2->romd_mode
         && r1->readonly == r2->readonly
         && r1->nonvolatile == r2->nonvolatile;
@@ -580,6 +584,7 @@ static void render_memory_region(FlatView *view,
                                  MemoryRegion *mr,
                                  Int128 base,
                                  AddrRange clip,
+                                 bool romd_section,
                                  bool readonly,
                                  bool nonvolatile)
 {
@@ -596,6 +601,7 @@ static void render_memory_region(FlatView *view,
     }
 
     int128_addto(&base, int128_make64(mr->addr));
+    romd_section |= mr->readonly && mr->ops && mr->ops->write;
     readonly |= mr->readonly;
     nonvolatile |= mr->nonvolatile;
 
@@ -611,14 +617,14 @@ static void render_memory_region(FlatView *view,
         int128_subfrom(&base, int128_make64(mr->alias->addr));
         int128_subfrom(&base, int128_make64(mr->alias_offset));
         render_memory_region(view, mr->alias, base, clip,
-                             readonly, nonvolatile);
+                             romd_section, readonly, nonvolatile);
         return;
     }
 
     /* Render subregions in priority order. */
     QTAILQ_FOREACH(subregion, &mr->subregions, subregions_link) {
         render_memory_region(view, subregion, base, clip,
-                             readonly, nonvolatile);
+                             romd_section, readonly, nonvolatile);
     }
 
     if (!mr->terminates) {
@@ -631,6 +637,7 @@ static void render_memory_region(FlatView *view,
 
     fr.mr = mr;
     fr.dirty_log_mask = memory_region_get_dirty_log_mask(mr);
+    fr.romd_section = romd_section;
     fr.romd_mode = mr->romd_mode;
     fr.readonly = readonly;
     fr.nonvolatile = nonvolatile;
@@ -735,7 +742,7 @@ static FlatView *generate_memory_topology(MemoryRegion *mr)
     if (mr) {
         render_memory_region(view, mr, int128_zero(),
                              addrrange_make(int128_zero(), int128_2_64()),
-                             false, false);
+                             false, false, false);
     }
     flatview_simplify(view);
 
@@ -2726,6 +2733,7 @@ static MemoryRegionSection memory_region_find_rcu(MemoryRegion *mr,
                                                         fr->addr.start));
     ret.size = range.size;
     ret.offset_within_address_space = int128_get64(range.start);
+    ret.romd_mode = fr->romd_section;
     ret.readonly = fr->readonly;
     ret.nonvolatile = fr->nonvolatile;
     return ret;
@@ -3529,6 +3537,50 @@ void memory_region_init_rom_device(MemoryRegion *mr,
     vmstate_register_ram(mr, owner_dev);
 }
 
+MemoryRegion *
+memory_region_find_romd_container(MemoryRegion *mr,
+                                  hwaddr addr, hwaddr *xlat)
+{
+    AddrRange tmp;
+    Int128 base = int128_zero();
+    MemoryRegion *result = NULL;
+    MemoryRegion *subregion = NULL;
+
+    *xlat = 0;
+
+    while (mr->enabled) {
+        int128_addto(&base, int128_make64(mr->addr));
+        tmp = addrrange_make(base, mr->size);
+
+        if (!addrrange_contains(tmp, int128_make64(addr))) {
+            break;
+        }
+
+        if (mr->readonly && mr->ops && mr->ops->write) {
+            result = mr;
+            *xlat = int128_get64(int128_sub(int128_make64(addr), base));
+            break;
+        }
+
+        if (mr->alias) {
+            int128_subfrom(&base, int128_make64(mr->alias->addr));
+            int128_subfrom(&base, int128_make64(mr->alias_offset));
+            mr = mr->alias;
+        } else {
+            QTAILQ_FOREACH(subregion, &mr->subregions, subregions_link) {
+                result = memory_region_find_romd_container(subregion,
+                                                           addr, xlat);
+                if (result) {
+                    break;
+                }
+            }
+            break;
+        }
+    }
+
+    return result;
+}
+
 /*
  * Support softmmu builds with CONFIG_FUZZ using a weak symbol and a stub for
  * the fuzz_dma_read_cb callback
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index dc3c3e5f2e..5d4b0105cf 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -568,6 +568,11 @@ MemoryRegion *flatview_translate(FlatView *fv, hwaddr addr, hwaddr *xlat,
                                     is_write, true, &as, attrs);
     mr = section.mr;
 
+    if (is_write && unlikely(section.romd_mode)) {
+        mr = memory_region_find_romd_container(fv->root, addr, xlat);
+        assert(mr != NULL);
+    }
+
     if (xen_enabled() && memory_access_is_direct(mr, is_write)) {
         hwaddr page = ((addr & TARGET_PAGE_MASK) + TARGET_PAGE_SIZE) - addr;
         *plen = MIN(page, *plen);
-- 
2.34.1

