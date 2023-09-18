Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312307A4A51
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242029AbjIRM6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242041AbjIRM62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:58:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6531A0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:57:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-2746889aa89so2875852a91.2
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695041873; x=1695646673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GADi8i5jxLDcO7w7LbTQFEdECTqQ66iHwncyhBEzkYk=;
        b=X5C3EBM1wIctDff6FqErkD2dIww9KM2YnURRJLbebvtQNu7Fus0tbJw1VT3UtvrEC0
         iuGXGXWlpjz8S4oCdVFl1ZeIJ1FuHz60dKZ1xBAaihGb4O4Nam8fUe/WQm31rD5dYhrX
         FtJcYpUF+cNAJqY9++sj6XSMqvhDBXnoqegRvSFN9fOU3xGRIsv4fuHmVDycDcD5rX4Y
         5mbhVzidbecPtIDbT6ZUWHn77Sn4fn98u5g97WaS6GCXB87uPNR/Jj4qBjfICVC6uZ2W
         N14xN+tB76HJWcSvO3s7t72svaiOCP2MUG60oc7WChRhU/5J5p6AKxATnR0YzCF8Klnm
         YzNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695041873; x=1695646673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GADi8i5jxLDcO7w7LbTQFEdECTqQ66iHwncyhBEzkYk=;
        b=MF7hcoDXs6GOGQKM0B5ZawXYHXAgRpMepYc1QYBDpbrLuhGM8CPsfxL8WcG81D3mig
         uy5mqA5J6NmLn7t2ywK88PONjACpZMOvVo4snBRDPBdiPLNUgNic6FPjXLHQ7RuWUw5w
         +oPBO0vWvBDeGVGtO6Iis844pErRPh53YTiWno52LJvM4DgbJruyNGw1Wx9oQ+hHqzTu
         DBEYqG/QoAV00Z4bdTl/nZrtetidiaQYvgosV5dO7f/EmzES68MdQXhrOP4nJlB5MzpU
         xJaq147RnbYbZ87xjcdAuJ2FR8JcJ9ujtzQZxs33NmzdHDWCZjXAwnCdYmOGhoclbyah
         co5Q==
X-Gm-Message-State: AOJu0YyUaSp5i0Pj5CrOL9giW90xspZAFqi5IqjQ7UtXPg0GN5Nu06XG
        pxBe5glynHusJdwBg+GeuyMCnpGKAuc3S6oaCWbpQg==
X-Google-Smtp-Source: AGHT+IGZwnRshA83keHcP/M4OjHprsAmN2XUidx9r1AopM0DRLiIFpTOFiIMI2DgSQupY2yxPaYBkQ==
X-Received: by 2002:a17:90a:fe89:b0:267:f9ab:15bb with SMTP id co9-20020a17090afe8900b00267f9ab15bbmr6288257pjb.14.1695041873144;
        Mon, 18 Sep 2023 05:57:53 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n14-20020a17090ac68e00b002680b2d2ab6sm8890237pjt.19.2023.09.18.05.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 05:57:52 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 3/6] riscv: Make irqchip support pluggable
Date:   Mon, 18 Sep 2023 18:27:27 +0530
Message-Id: <20230918125730.1371985-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230918125730.1371985-1-apatel@ventanamicro.com>
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will be having different types of irqchip:
1) PLIC emulated by user-space
2) AIA APLIC and IMSIC provided by in-kernel KVM module

To support above, we de-couple PLIC specific code from generic
RISC-V code (such as FDT generation) so that we can easily add
other types of irqchip.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                  | 14 ++++++--
 riscv/include/kvm/kvm-arch.h | 25 ++++++++++++---
 riscv/irq.c                  | 62 ++++++++++++++++++++++++++++++++++--
 riscv/kvm.c                  |  2 ++
 riscv/pci.c                  | 32 +++++++++++++------
 riscv/plic.c                 | 61 +++++++++++++++++------------------
 6 files changed, 147 insertions(+), 49 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 2724c6e..9af71b5 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -209,19 +209,26 @@ static int setup_fdt(struct kvm *kvm)
 	/* CPUs */
 	generate_cpu_nodes(fdt, kvm);
 
+	/* IRQCHIP */
+	if (!riscv_irqchip_generate_fdt_node)
+		die("No way to generate IRQCHIP FDT node\n");
+	riscv_irqchip_generate_fdt_node(fdt, kvm);
+
 	/* Simple Bus */
 	_FDT(fdt_begin_node(fdt, "smb"));
 	_FDT(fdt_property_string(fdt, "compatible", "simple-bus"));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 0x2));
 	_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
-	_FDT(fdt_property_cell(fdt, "interrupt-parent", PHANDLE_PLIC));
+	_FDT(fdt_property_cell(fdt, "interrupt-parent",
+			       riscv_irqchip_phandle));
 	_FDT(fdt_property(fdt, "ranges", NULL, 0));
 
 	/* Virtio MMIO devices */
 	dev_hdr = device__first_dev(DEVICE_BUS_MMIO);
 	while (dev_hdr) {
 		generate_mmio_fdt_nodes = dev_hdr->data;
-		generate_mmio_fdt_nodes(fdt, dev_hdr, plic__generate_irq_prop);
+		generate_mmio_fdt_nodes(fdt, dev_hdr,
+					riscv__generate_irq_prop);
 		dev_hdr = device__next_dev(dev_hdr);
 	}
 
@@ -229,7 +236,8 @@ static int setup_fdt(struct kvm *kvm)
 	dev_hdr = device__first_dev(DEVICE_BUS_IOPORT);
 	while (dev_hdr) {
 		generate_mmio_fdt_nodes = dev_hdr->data;
-		generate_mmio_fdt_nodes(fdt, dev_hdr, plic__generate_irq_prop);
+		generate_mmio_fdt_nodes(fdt, dev_hdr,
+					riscv__generate_irq_prop);
 		dev_hdr = device__next_dev(dev_hdr);
 	}
 
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 660355b..cd37fc6 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -10,8 +10,8 @@
 
 #define RISCV_IOPORT		0x00000000ULL
 #define RISCV_IOPORT_SIZE	SZ_64K
-#define RISCV_PLIC		0x0c000000ULL
-#define RISCV_PLIC_SIZE		SZ_64M
+#define RISCV_IRQCHIP		0x08000000ULL
+#define RISCV_IRQCHIP_SIZE		SZ_128M
 #define RISCV_MMIO		0x10000000ULL
 #define RISCV_MMIO_SIZE		SZ_512M
 #define RISCV_PCI		0x30000000ULL
@@ -84,10 +84,27 @@ static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
 
 enum irq_type;
 
-void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type);
+enum irqchip_type {
+	IRQCHIP_UNKNOWN = 0,
+	IRQCHIP_PLIC,
+	IRQCHIP_AIA
+};
+
+extern enum irqchip_type riscv_irqchip;
+extern bool riscv_irqchip_inkernel;
+extern void (*riscv_irqchip_trigger)(struct kvm *kvm, int irq,
+				     int level, bool edge);
+extern void (*riscv_irqchip_generate_fdt_node)(void *fdt, struct kvm *kvm);
+extern u32 riscv_irqchip_phandle;
+extern u32 riscv_irqchip_msi_phandle;
+extern bool riscv_irqchip_line_sensing;
 
-void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge);
+void plic__create(struct kvm *kvm);
 
 void pci__generate_fdt_nodes(void *fdt);
 
+void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type);
+
+void riscv__irqchip_create(struct kvm *kvm);
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/riscv/irq.c b/riscv/irq.c
index 78a582d..b608a2f 100644
--- a/riscv/irq.c
+++ b/riscv/irq.c
@@ -1,13 +1,71 @@
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/irq.h"
+#include "kvm/fdt.h"
+#include "kvm/virtio.h"
+
+enum irqchip_type riscv_irqchip = IRQCHIP_UNKNOWN;
+bool riscv_irqchip_inkernel = false;
+void (*riscv_irqchip_trigger)(struct kvm *kvm, int irq, int level, bool edge)
+				= NULL;
+void (*riscv_irqchip_generate_fdt_node)(void *fdt, struct kvm *kvm) = NULL;
+u32 riscv_irqchip_phandle = PHANDLE_RESERVED;
+u32 riscv_irqchip_msi_phandle = PHANDLE_RESERVED;
+bool riscv_irqchip_line_sensing = false;
 
 void kvm__irq_line(struct kvm *kvm, int irq, int level)
 {
-	plic__irq_trig(kvm, irq, level, false);
+	struct kvm_irq_level irq_level;
+
+	if (riscv_irqchip_inkernel) {
+		irq_level.irq = irq;
+		irq_level.level = !!level;
+		if (ioctl(kvm->vm_fd, KVM_IRQ_LINE, &irq_level) < 0)
+			pr_warning("%s: Could not KVM_IRQ_LINE for irq %d\n",
+				   __func__, irq);
+	} else {
+		if (riscv_irqchip_trigger)
+			riscv_irqchip_trigger(kvm, irq, level, false);
+		else
+			pr_warning("%s: Can't change level for irq %d\n",
+				   __func__, irq);
+	}
 }
 
 void kvm__irq_trigger(struct kvm *kvm, int irq)
 {
-	plic__irq_trig(kvm, irq, 1, true);
+	if (riscv_irqchip_inkernel) {
+		kvm__irq_line(kvm, irq, VIRTIO_IRQ_HIGH);
+		kvm__irq_line(kvm, irq, VIRTIO_IRQ_LOW);
+	} else {
+		if (riscv_irqchip_trigger)
+			riscv_irqchip_trigger(kvm, irq, 1, true);
+		else
+			pr_warning("%s: Can't trigger irq %d\n",
+				   __func__, irq);
+	}
+}
+
+void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
+{
+	u32 prop[2], size;
+
+	prop[0] = cpu_to_fdt32(irq);
+	size = sizeof(u32);
+	if (riscv_irqchip_line_sensing) {
+		prop[1] = cpu_to_fdt32(irq_type);
+		size += sizeof(u32);
+	}
+
+	_FDT(fdt_property(fdt, "interrupts", prop, size));
+}
+
+void riscv__irqchip_create(struct kvm *kvm)
+{
+	/* Try PLIC irqchip */
+	plic__create(kvm);
+
+	/* Fail if irqchip unknown */
+	if (riscv_irqchip == IRQCHIP_UNKNOWN)
+		die("No IRQCHIP found\n");
 }
diff --git a/riscv/kvm.c b/riscv/kvm.c
index 8daad94..1d49479 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -96,6 +96,8 @@ void kvm__arch_init(struct kvm *kvm)
 
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
 		MADV_HUGEPAGE);
+
+	riscv__irqchip_create(kvm);
 }
 
 #define FDT_ALIGN	SZ_4M
diff --git a/riscv/pci.c b/riscv/pci.c
index 604fd20..61dee06 100644
--- a/riscv/pci.c
+++ b/riscv/pci.c
@@ -7,20 +7,21 @@
 
 /*
  * An entry in the interrupt-map table looks like:
- * <pci unit address> <pci interrupt pin> <plic phandle> <plic interrupt>
+ * <pci unit address> <pci interrupt pin> <irqchip phandle> <irqchip line>
  */
 
 struct of_interrupt_map_entry {
 	struct of_pci_irq_mask		pci_irq_mask;
-	u32				plic_phandle;
-	u32				plic_irq;
+	u32				irqchip_phandle;
+	u32				irqchip_line;
+	u32				irqchip_sense;
 } __attribute__((packed));
 
 void pci__generate_fdt_nodes(void *fdt)
 {
 	struct device_header *dev_hdr;
 	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
-	unsigned nentries = 0;
+	unsigned nentries = 0, nsize;
 	/* Bus range */
 	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(1), };
 	/* Configuration Space */
@@ -48,6 +49,11 @@ void pci__generate_fdt_nodes(void *fdt)
 		},
 	};
 
+	/* Find size of each interrupt map entery */
+	nsize = sizeof(struct of_interrupt_map_entry);
+	if (!riscv_irqchip_line_sensing)
+		nsize -= sizeof(u32);
+
 	/* Boilerplate PCI properties */
 	_FDT(fdt_begin_node(fdt, "pci"));
 	_FDT(fdt_property_string(fdt, "device_type", "pci"));
@@ -64,12 +70,13 @@ void pci__generate_fdt_nodes(void *fdt)
 	/* Generate the interrupt map ... */
 	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
 	while (dev_hdr && nentries < ARRAY_SIZE(irq_map)) {
-		struct of_interrupt_map_entry *entry = &irq_map[nentries];
+		struct of_interrupt_map_entry *entry;
 		struct pci_device_header *pci_hdr = dev_hdr->data;
 		u8 dev_num = dev_hdr->dev_num;
 		u8 pin = pci_hdr->irq_pin;
 		u8 irq = pci_hdr->irq_line;
 
+		entry = ((void *)irq_map) + (nsize * nentries);
 		*entry = (struct of_interrupt_map_entry) {
 			.pci_irq_mask = {
 				.pci_addr = {
@@ -79,16 +86,18 @@ void pci__generate_fdt_nodes(void *fdt)
 				},
 				.pci_pin	= cpu_to_fdt32(pin),
 			},
-			.plic_phandle	= cpu_to_fdt32(PHANDLE_PLIC),
-			.plic_irq	= cpu_to_fdt32(irq),
+			.irqchip_phandle	= cpu_to_fdt32(riscv_irqchip_phandle),
+			.irqchip_line		= cpu_to_fdt32(irq),
 		};
 
+		if (riscv_irqchip_line_sensing)
+			entry->irqchip_sense = cpu_to_fdt32(IRQ_TYPE_LEVEL_HIGH);
+
 		nentries++;
 		dev_hdr = device__next_dev(dev_hdr);
 	}
 
-	_FDT(fdt_property(fdt, "interrupt-map", irq_map,
-			  sizeof(struct of_interrupt_map_entry) * nentries));
+	_FDT(fdt_property(fdt, "interrupt-map", irq_map, nsize * nentries));
 
 	/* ... and the corresponding mask. */
 	if (nentries) {
@@ -105,5 +114,10 @@ void pci__generate_fdt_nodes(void *fdt)
 				  sizeof(irq_mask)));
 	}
 
+	/* Set MSI parent if available */
+	if (riscv_irqchip_msi_phandle != PHANDLE_RESERVED)
+		_FDT(fdt_property_cell(fdt, "msi-parent",
+				       riscv_irqchip_msi_phandle));
+
 	_FDT(fdt_end_node(fdt));
 }
diff --git a/riscv/plic.c b/riscv/plic.c
index 6242286..ab7c574 100644
--- a/riscv/plic.c
+++ b/riscv/plic.c
@@ -118,7 +118,6 @@ struct plic_context {
 struct plic_state {
 	bool ready;
 	struct kvm *kvm;
-	struct device_header dev_hdr;
 
 	/* Static Configuration */
 	u32 num_irq;
@@ -204,7 +203,7 @@ static u32 __plic_context_irq_claim(struct plic_state *s,
 	return best_irq;
 }
 
-void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge)
+static void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge)
 {
 	bool irq_marked = false;
 	u8 i, irq_prio, irq_word;
@@ -425,7 +424,7 @@ static void plic__mmio_callback(struct kvm_cpu *vcpu,
 		die("plic: invalid len=%d", len);
 
 	addr &= ~0x3;
-	addr -= RISCV_PLIC;
+	addr -= RISCV_IRQCHIP;
 
 	if (is_write) {
 		if (PRIORITY_BASE <= addr && addr < ENABLE_BASE) {
@@ -464,34 +463,23 @@ static void plic__mmio_callback(struct kvm_cpu *vcpu,
 	}
 }
 
-void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
-{
-	u32 irq_prop[] = {
-		cpu_to_fdt32(irq)
-	};
-
-	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
-}
-
-static void plic__generate_fdt_node(void *fdt,
-				    struct device_header *dev_hdr,
-				    void (*generate_irq_prop)(void *fdt,
-							      u8 irq,
-							      enum irq_type))
+static void plic__generate_fdt_node(void *fdt, struct kvm *kvm)
 {
 	u32 i;
+	char name[64];
 	u32 reg_cells[4], *irq_cells;
 
 	reg_cells[0] = 0;
-	reg_cells[1] = cpu_to_fdt32(RISCV_PLIC);
+	reg_cells[1] = cpu_to_fdt32(RISCV_IRQCHIP);
 	reg_cells[2] = 0;
-	reg_cells[3] = cpu_to_fdt32(RISCV_PLIC_SIZE);
+	reg_cells[3] = cpu_to_fdt32(RISCV_IRQCHIP_SIZE);
 
 	irq_cells = calloc(plic.num_context * 2, sizeof(u32));
 	if (!irq_cells)
 		die("Failed to alloc irq_cells");
 
-	_FDT(fdt_begin_node(fdt, "interrupt-controller@0c000000"));
+	sprintf(name, "interrupt-controller@%08x", (u32)RISCV_IRQCHIP);
+	_FDT(fdt_begin_node(fdt, name));
 	_FDT(fdt_property_string(fdt, "compatible", "riscv,plic0"));
 	_FDT(fdt_property(fdt, "reg", reg_cells, sizeof(reg_cells)));
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 1));
@@ -518,12 +506,10 @@ static int plic__init(struct kvm *kvm)
 	int ret;
 	struct plic_context *c;
 
-	plic.kvm = kvm;
-	plic.dev_hdr = (struct device_header) {
-		.bus_type	= DEVICE_BUS_MMIO,
-		.data		= plic__generate_fdt_node,
-	};
+	if (riscv_irqchip != IRQCHIP_PLIC)
+		return 0;
 
+	plic.kvm = kvm;
 	plic.num_irq = MAX_DEVICES;
 	plic.num_irq_word = plic.num_irq / 32;
 	if ((plic.num_irq_word * 32) < plic.num_irq)
@@ -544,15 +530,11 @@ static int plic__init(struct kvm *kvm)
 
 	mutex_init(&plic.irq_lock);
 
-	ret = kvm__register_mmio(kvm, RISCV_PLIC, RISCV_PLIC_SIZE,
+	ret = kvm__register_mmio(kvm, RISCV_IRQCHIP, RISCV_IRQCHIP_SIZE,
 				 false, plic__mmio_callback, &plic);
 	if (ret)
 		return ret;
 
-	ret = device__register(&plic.dev_hdr);
-	if (ret)
-		return ret;
-
 	plic.ready = true;
 
 	return 0;
@@ -562,10 +544,27 @@ dev_init(plic__init);
 
 static int plic__exit(struct kvm *kvm)
 {
+	if (riscv_irqchip != IRQCHIP_PLIC)
+		return 0;
+
 	plic.ready = false;
-	kvm__deregister_mmio(kvm, RISCV_PLIC);
+	kvm__deregister_mmio(kvm, RISCV_IRQCHIP);
 	free(plic.contexts);
 
 	return 0;
 }
 dev_exit(plic__exit);
+
+void plic__create(struct kvm *kvm)
+{
+	if (riscv_irqchip != IRQCHIP_UNKNOWN)
+		return;
+
+	riscv_irqchip = IRQCHIP_PLIC;
+	riscv_irqchip_inkernel = false;
+	riscv_irqchip_trigger = plic__irq_trig;
+	riscv_irqchip_generate_fdt_node = plic__generate_fdt_node;
+	riscv_irqchip_phandle = PHANDLE_PLIC;
+	riscv_irqchip_msi_phandle = PHANDLE_RESERVED;
+	riscv_irqchip_line_sensing = false;
+}
-- 
2.34.1

