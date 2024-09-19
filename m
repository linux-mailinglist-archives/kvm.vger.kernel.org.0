Return-Path: <kvm+bounces-27167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF91997C404
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 07:56:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51F2C1F21EA5
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 05:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76D47581D;
	Thu, 19 Sep 2024 05:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UG92vlR6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D1117BAF
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 05:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725403; cv=none; b=rBtjQtG3zBHQ5VDo4f7b1k940t7PsGMt5S9OCLV1KV6aWEIzQQ8phHS2GA6C9L6jM087mzoqGlUgorpGw5WpTkLvAWOKbZKVYLyWrHYO+jFS8h7GF30KUPJ/NVuLmaZDo5X1cntPMHDDDuUtWPlfwhi3H7UdVSZ8GTCUwGWPSPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725403; c=relaxed/simple;
	bh=85v++8FV1/OeoJfcfM2dF4Z0fvvP/1Y4odYjQpC249A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y30rWU+5GFxWIIdCMgp2ZCv7D00ruNYedmsgs2C/aaU+6boZbwHR5y6wRRsheiPcDDuDXgWQmWOjnP59w8hEzoGup8yNSgBv0YV2p7bBJW/9DvYYUJ5eqJeup5F498Llpl3YLRIu8injlFKeuDoLFu8Vty6CNQOP1zKGfWDgtUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UG92vlR6; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726725402; x=1758261402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=85v++8FV1/OeoJfcfM2dF4Z0fvvP/1Y4odYjQpC249A=;
  b=UG92vlR6rRguyl6jFXJGkkmfk4hkgdIF2Zp7u4F2gdDhWVm4x4zHbeRq
   0w7Mx+U2UcjPprdFmHnoAMVY8toaZnf1uobI9TStcNzUxe6l2Z/hmsaHW
   IfyVPvOZYv4Qmzq5yD1sx/OyTnl/biwAMmdKS4N/WEQYSoiujE4Gz341R
   gDtsv6wVh37NAo2u41BTVRIkkY1kgwGeSkqFgEQi5Q5JiWtvPinH3gg5R
   h3vwTlx0itA9R7+GyWZ9obDaLEFcDXsSFDHUSAirw4RIVNO5BloFg7Rsp
   QSMK/ZDq2K7sWhCv6m1yH5wbPT3TTc1PJOKyMLuVt8mxKyBiKQXXHGF+8
   Q==;
X-CSE-ConnectionGUID: YGSqAmaNQi2qYXKtLZMrFg==
X-CSE-MsgGUID: iVJknf+dSjCiB1fW+tW+GA==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25813761"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25813761"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 22:56:41 -0700
X-CSE-ConnectionGUID: UYayTWY+RcSOXbGe/lxomA==
X-CSE-MsgGUID: oSBDaJfESCymhB7De9E+LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="69418828"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2024 22:56:32 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 11/12] i386/machine: Split machine initialization after CPU creation into post_init()
Date: Thu, 19 Sep 2024 14:11:27 +0800
Message-Id: <20240919061128.769139-12-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919061128.769139-1-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Custom topology will allow machine to skip the default CPU creation and
accept user's CPU creation from CLI.

Therefore, for microvm, pc-i440fx and pc-q35, split machine
initialization from x86_cpus_init(), and place the remaining part into
post_init(), which can continue to run after CPU creation from CLI.

This addresses the CPU dependency for the remaining initialization steps
after x86_cpus_init().

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/microvm.c    |  7 +++++++
 hw/i386/pc_piix.c    | 40 +++++++++++++++++++++++++---------------
 hw/i386/pc_q35.c     | 36 ++++++++++++++++++++++--------------
 include/hw/i386/pc.h |  3 +++
 4 files changed, 57 insertions(+), 29 deletions(-)

diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index 49a897db50fc..dc9b21a34230 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -463,6 +463,11 @@ static void microvm_machine_state_init(MachineState *machine)
     microvm_memory_init(mms);
 
     x86_cpus_init(x86ms, CPU_VERSION_LATEST);
+}
+
+static void microvm_machine_state_post_init(MachineState *machine)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(machine);
 
     microvm_devices_init(mms);
 }
@@ -665,6 +670,8 @@ static void microvm_class_init(ObjectClass *oc, void *data)
     /* Machine class handlers */
     mc->reset = microvm_machine_reset;
 
+    mc->post_init = microvm_machine_state_post_init;
+
     /* hotplug (for cpu coldplug) */
     mc->get_hotplug_handler = microvm_get_hotplug_handler;
     hc->pre_plug = microvm_device_pre_plug_cb;
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 2bf6865d405e..c1db2f3129cf 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -105,19 +105,9 @@ static void pc_init1(MachineState *machine, const char *pci_type)
     PCMachineState *pcms = PC_MACHINE(machine);
     PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
     X86MachineState *x86ms = X86_MACHINE(machine);
-    MemoryRegion *system_memory = get_system_memory();
-    MemoryRegion *system_io = get_system_io();
-    Object *phb = NULL;
-    ISABus *isa_bus;
-    Object *piix4_pm = NULL;
-    qemu_irq smi_irq;
-    GSIState *gsi_state;
-    MemoryRegion *ram_memory;
-    MemoryRegion *pci_memory = NULL;
-    MemoryRegion *rom_memory = system_memory;
     ram_addr_t lowmem;
-    uint64_t hole64_size = 0;
 
+    pcms->pci_type = pci_type;
     /*
      * Calculate ram split, for memory below and above 4G.  It's a bit
      * complicated for backward compatibility reasons ...
@@ -150,9 +140,9 @@ static void pc_init1(MachineState *machine, const char *pci_type)
      *    qemu -M pc,max-ram-below-4g=4G -m 3968M  -> 3968M low (=4G-128M)
      */
     if (xen_enabled()) {
-        xen_hvm_init_pc(pcms, &ram_memory);
+        xen_hvm_init_pc(pcms, &pcms->pre_config_ram);
     } else {
-        ram_memory = machine->ram;
+        pcms->pre_config_ram = machine->ram;
         if (!pcms->max_ram_below_4g) {
             pcms->max_ram_below_4g = 0xe0000000; /* default: 3.5G */
         }
@@ -182,6 +172,23 @@ static void pc_init1(MachineState *machine, const char *pci_type)
 
     pc_machine_init_sgx_epc(pcms);
     x86_cpus_init(x86ms, pcmc->default_cpu_version);
+}
+
+static void pc_post_init1(MachineState *machine)
+{
+    PCMachineState *pcms = PC_MACHINE(machine);
+    PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
+    X86MachineState *x86ms = X86_MACHINE(machine);
+    MemoryRegion *system_memory = get_system_memory();
+    MemoryRegion *system_io = get_system_io();
+    Object *phb = NULL;
+    ISABus *isa_bus;
+    Object *piix4_pm = NULL;
+    qemu_irq smi_irq;
+    GSIState *gsi_state;
+    MemoryRegion *pci_memory = NULL;
+    MemoryRegion *rom_memory = system_memory;
+    uint64_t hole64_size = 0;
 
     if (kvm_enabled()) {
         kvmclock_create(pcmc->kvmclock_create_always);
@@ -195,7 +202,7 @@ static void pc_init1(MachineState *machine, const char *pci_type)
         phb = OBJECT(qdev_new(TYPE_I440FX_PCI_HOST_BRIDGE));
         object_property_add_child(OBJECT(machine), "i440fx", phb);
         object_property_set_link(phb, PCI_HOST_PROP_RAM_MEM,
-                                 OBJECT(ram_memory), &error_fatal);
+                                 OBJECT(pcms->pre_config_ram), &error_fatal);
         object_property_set_link(phb, PCI_HOST_PROP_PCI_MEM,
                                  OBJECT(pci_memory), &error_fatal);
         object_property_set_link(phb, PCI_HOST_PROP_SYSTEM_MEM,
@@ -206,7 +213,7 @@ static void pc_init1(MachineState *machine, const char *pci_type)
                                  x86ms->below_4g_mem_size, &error_fatal);
         object_property_set_uint(phb, PCI_HOST_ABOVE_4G_MEM_SIZE,
                                  x86ms->above_4g_mem_size, &error_fatal);
-        object_property_set_str(phb, I440FX_HOST_PROP_PCI_TYPE, pci_type,
+        object_property_set_str(phb, I440FX_HOST_PROP_PCI_TYPE, pcms->pci_type,
                                 &error_fatal);
         sysbus_realize_and_unref(SYS_BUS_DEVICE(phb), &error_fatal);
 
@@ -413,6 +420,7 @@ static void pc_set_south_bridge(Object *obj, int value, Error **errp)
 static void pc_init_isa(MachineState *machine)
 {
     pc_init1(machine, NULL);
+    pc_post_init1(machine);
 }
 #endif
 
@@ -423,6 +431,7 @@ static void pc_xen_hvm_init_pci(MachineState *machine)
                 TYPE_IGD_PASSTHROUGH_I440FX_PCI_DEVICE : TYPE_I440FX_PCI_DEVICE;
 
     pc_init1(machine, pci_type);
+    pc_post_init1(machine);
 }
 
 static void pc_xen_hvm_init(MachineState *machine)
@@ -463,6 +472,7 @@ static void pc_i440fx_machine_options(MachineClass *m)
     m->default_nic = "e1000";
     m->no_floppy = !module_object_class_by_name(TYPE_ISA_FDC);
     m->no_parallel = !module_object_class_by_name(TYPE_ISA_PARALLEL);
+    m->post_init = pc_post_init1;
     machine_class_allow_dynamic_sysbus_dev(m, TYPE_RAMFB_DEVICE);
     machine_class_allow_dynamic_sysbus_dev(m, TYPE_VMBUS_BRIDGE);
 
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 8319b6d45ee3..9ce3e65d7182 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -129,21 +129,7 @@ static void pc_q35_init(MachineState *machine)
     PCMachineState *pcms = PC_MACHINE(machine);
     PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
     X86MachineState *x86ms = X86_MACHINE(machine);
-    Object *phb;
-    PCIDevice *lpc;
-    DeviceState *lpc_dev;
-    MemoryRegion *system_memory = get_system_memory();
-    MemoryRegion *system_io = get_system_io();
-    MemoryRegion *pci_memory = g_new(MemoryRegion, 1);
-    GSIState *gsi_state;
-    ISABus *isa_bus;
-    int i;
     ram_addr_t lowmem;
-    DriveInfo *hd[MAX_SATA_PORTS];
-    MachineClass *mc = MACHINE_GET_CLASS(machine);
-    bool acpi_pcihp;
-    bool keep_pci_slot_hpc;
-    uint64_t pci_hole64_size = 0;
 
     assert(pcmc->pci_enabled);
 
@@ -188,6 +174,27 @@ static void pc_q35_init(MachineState *machine)
 
     pc_machine_init_sgx_epc(pcms);
     x86_cpus_init(x86ms, pcmc->default_cpu_version);
+}
+
+static void pc_q35_post_init(MachineState *machine)
+{
+    PCMachineState *pcms = PC_MACHINE(machine);
+    PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
+    X86MachineState *x86ms = X86_MACHINE(machine);
+    Object *phb;
+    PCIDevice *lpc;
+    DeviceState *lpc_dev;
+    MemoryRegion *system_memory = get_system_memory();
+    MemoryRegion *system_io = get_system_io();
+    MemoryRegion *pci_memory = g_new(MemoryRegion, 1);
+    GSIState *gsi_state;
+    ISABus *isa_bus;
+    int i;
+    DriveInfo *hd[MAX_SATA_PORTS];
+    MachineClass *mc = MACHINE_GET_CLASS(machine);
+    bool acpi_pcihp;
+    bool keep_pci_slot_hpc;
+    uint64_t pci_hole64_size = 0;
 
     if (kvm_enabled()) {
         kvmclock_create(pcmc->kvmclock_create_always);
@@ -348,6 +355,7 @@ static void pc_q35_machine_options(MachineClass *m)
     m->no_floppy = 1;
     m->max_cpus = 4096;
     m->no_parallel = !module_object_class_by_name(TYPE_ISA_PARALLEL);
+    m->post_init = pc_q35_post_init;
     machine_class_allow_dynamic_sysbus_dev(m, TYPE_AMD_IOMMU_DEVICE);
     machine_class_allow_dynamic_sysbus_dev(m, TYPE_INTEL_IOMMU_DEVICE);
     machine_class_allow_dynamic_sysbus_dev(m, TYPE_RAMFB_DEVICE);
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 14ee06287da3..14534781e8fb 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -58,6 +58,9 @@ typedef struct PCMachineState {
 
     SGXEPCState sgx_epc;
     CXLState cxl_devices_state;
+
+    MemoryRegion *pre_config_ram;
+    const char *pci_type;
 } PCMachineState;
 
 #define PC_MACHINE_ACPI_DEVICE_PROP "acpi-device"
-- 
2.34.1


