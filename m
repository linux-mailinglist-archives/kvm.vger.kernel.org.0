Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B7C761D51
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjGYPZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbjGYPZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:25:10 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD6A1FC9
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:25:05 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-267fc1d776eso1312282a91.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690298704; x=1690903504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2uIwk1dCARQ8lslGFCy5US3fYdtvyK5Wo6Ek7/wR5rA=;
        b=iFIF2VaBme+QRiIVvIzpVidv+8t6CIUImg70/wfYSSvDhO5YpfLAD4f/rzt1tY29kE
         YAVy1m8O8Dg+uBdZRMUASLZmnj6Rbt3fGCd90qNlzrSVxPtv1ZT2A8DvMLBmRn5939Lr
         ZJQDWPOrnVy2mIxmhVKEqi1nfZCFcB3yZlWLWRQ/IC4ctWM7VRZQjWwzNkLMnZezD6MO
         qeeRYzU+x9iLbxEi7W7a+tq/eFInZ6PJGqKJ3aXeT8AXM8DLAsRWHTRkHu5UmulbSLYs
         5KTjj/QcengG7xF69xOWnhQOD9mbna09ka+ORxjPD4Yh0em6QutJFdqAKBt626VdPWhN
         4b+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690298704; x=1690903504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2uIwk1dCARQ8lslGFCy5US3fYdtvyK5Wo6Ek7/wR5rA=;
        b=Cal9/f2cWBaZFkS2v3gVQrDEZJDy+6zsLHHbxauuqTXTW8V29Qi1zjjd0MfcJyjD2O
         mQz/YMzMCZ9twzOjSYDSZQmJiKOqtFCiDWG+7m4GbCwrTc1f5++XioQ6GoPykIWIT+6H
         ioQTMbLnZnTB+c8TUU4kJIeDV2pBMtEKYP/oHsoQ4KlCnliLrM0QlkDYVYnTndTWmqcg
         q97dGT59INkvhogQmQLqp1x0kPuIRpSw+6ve2gDl8KAacSFOmx5mBw6wXJkl8t+f/jso
         slHWXsBx4oZ33haIi4AfxtYZfDVKx1nwS9wHChdkCejRCiydR5zhPSmZh1vuvrkgSXR7
         XI3A==
X-Gm-Message-State: ABy/qLazIEcqOHeckkCxVBuA7ldM7ghB8e4uKzgcyjQjJdcceJVeUljp
        7gZE/nVUuEChZefjjXYV/RVRlg==
X-Google-Smtp-Source: APBJJlFR9l/3VLc66r0+SAtiDEAtUKl1ouJRFuIYCgZNDQnz4k0r1xNDHEtyLZeIdeEoLs52asgMrw==
X-Received: by 2002:a17:90a:5883:b0:267:de82:c37b with SMTP id j3-20020a17090a588300b00267de82c37bmr8343533pji.18.1690298704494;
        Tue, 25 Jul 2023 08:25:04 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id g11-20020a17090adb0b00b002683fd66663sm980372pjv.22.2023.07.25.08.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 08:25:04 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 5/6] riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
Date:   Tue, 25 Jul 2023 20:54:29 +0530
Message-Id: <20230725152430.3351564-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230725152430.3351564-1-apatel@ventanamicro.com>
References: <20230725152430.3351564-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM RISC-V kernel module supports AIA in-kernel irqchip when
underlying host has AIA support. We detect and use AIA in-kernel
irqchip whenever possible otherwise we fallback to PLIC emulated
in user-space.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 Makefile                     |   1 +
 riscv/aia.c                  | 227 +++++++++++++++++++++++++++++++++++
 riscv/include/kvm/fdt-arch.h |   8 +-
 riscv/include/kvm/kvm-arch.h |   2 +
 riscv/irq.c                  |   3 +
 5 files changed, 240 insertions(+), 1 deletion(-)
 create mode 100644 riscv/aia.c

diff --git a/Makefile b/Makefile
index e711670..acd5ffd 100644
--- a/Makefile
+++ b/Makefile
@@ -220,6 +220,7 @@ ifeq ($(ARCH),riscv)
 	OBJS		+= riscv/kvm-cpu.o
 	OBJS		+= riscv/pci.o
 	OBJS		+= riscv/plic.o
+	OBJS		+= riscv/aia.o
 	ifeq ($(RISCV_XLEN),32)
 		CFLAGS	+= -mabi=ilp32d -march=rv32gc
 	endif
diff --git a/riscv/aia.c b/riscv/aia.c
new file mode 100644
index 0000000..8c85b3f
--- /dev/null
+++ b/riscv/aia.c
@@ -0,0 +1,227 @@
+#include "kvm/devices.h"
+#include "kvm/fdt.h"
+#include "kvm/ioeventfd.h"
+#include "kvm/ioport.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/irq.h"
+#include "kvm/util.h"
+
+static int aia_fd = -1;
+
+static u32 aia_mode = KVM_DEV_RISCV_AIA_MODE_EMUL;
+static struct kvm_device_attr aia_mode_attr = {
+	.group	= KVM_DEV_RISCV_AIA_GRP_CONFIG,
+	.attr	= KVM_DEV_RISCV_AIA_CONFIG_MODE,
+};
+
+static u32 aia_nr_ids = 0;
+static struct kvm_device_attr aia_nr_ids_attr = {
+	.group	= KVM_DEV_RISCV_AIA_GRP_CONFIG,
+	.attr	= KVM_DEV_RISCV_AIA_CONFIG_IDS,
+};
+
+static u32 aia_nr_sources = 0;
+static struct kvm_device_attr aia_nr_sources_attr = {
+	.group	= KVM_DEV_RISCV_AIA_GRP_CONFIG,
+	.attr	= KVM_DEV_RISCV_AIA_CONFIG_SRCS,
+};
+
+static u32 aia_hart_bits = 0;
+static struct kvm_device_attr aia_hart_bits_attr = {
+	.group	= KVM_DEV_RISCV_AIA_GRP_CONFIG,
+	.attr	= KVM_DEV_RISCV_AIA_CONFIG_HART_BITS,
+};
+
+static u32 aia_nr_harts = 0;
+
+#define IRQCHIP_AIA_NR			0
+
+#define AIA_IMSIC_BASE			RISCV_IRQCHIP
+#define AIA_IMSIC_ADDR(__hart)		\
+	(AIA_IMSIC_BASE + (__hart) * KVM_DEV_RISCV_IMSIC_SIZE)
+#define AIA_IMSIC_SIZE			\
+	(aia_nr_harts * KVM_DEV_RISCV_IMSIC_SIZE)
+#define AIA_APLIC_ADDR(__nr_harts)	\
+	(AIA_IMSIC_BASE + (__nr_harts) * KVM_DEV_RISCV_IMSIC_SIZE)
+
+static void aia__generate_fdt_node(void *fdt, struct kvm *kvm)
+{
+	u32 i;
+	char name[64];
+	u32 reg_cells[4], *irq_cells;
+
+	irq_cells = calloc(aia_nr_harts * 2, sizeof(u32));
+	if (!irq_cells)
+		die("Failed to alloc irq_cells");
+
+	sprintf(name, "imsics@%08x", (u32)AIA_IMSIC_BASE);
+	_FDT(fdt_begin_node(fdt, name));
+	_FDT(fdt_property_string(fdt, "compatible", "riscv,imsics"));
+	reg_cells[0] = 0;
+	reg_cells[1] = cpu_to_fdt32(AIA_IMSIC_BASE);
+	reg_cells[2] = 0;
+	reg_cells[3] = cpu_to_fdt32(AIA_IMSIC_SIZE);
+	_FDT(fdt_property(fdt, "reg", reg_cells, sizeof(reg_cells)));
+	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 0));
+	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
+	_FDT(fdt_property(fdt, "msi-controller", NULL, 0));
+	_FDT(fdt_property_cell(fdt, "riscv,num-ids", aia_nr_ids));
+	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_AIA_IMSIC));
+	for (i = 0; i < aia_nr_harts; i++) {
+		irq_cells[2*i + 0] = cpu_to_fdt32(PHANDLE_CPU_INTC_BASE + i);
+		irq_cells[2*i + 1] = cpu_to_fdt32(9);
+	}
+	_FDT(fdt_property(fdt, "interrupts-extended", irq_cells,
+			  sizeof(u32) * aia_nr_harts * 2));
+	_FDT(fdt_end_node(fdt));
+
+	free(irq_cells);
+
+	/* Skip APLIC node if we have no interrupt sources */
+	if (!aia_nr_sources)
+		return;
+
+	sprintf(name, "aplic@%08x", (u32)AIA_APLIC_ADDR(aia_nr_harts));
+	_FDT(fdt_begin_node(fdt, name));
+	_FDT(fdt_property_string(fdt, "compatible", "riscv,aplic"));
+	reg_cells[0] = 0;
+	reg_cells[1] = cpu_to_fdt32(AIA_APLIC_ADDR(aia_nr_harts));
+	reg_cells[2] = 0;
+	reg_cells[3] = cpu_to_fdt32(KVM_DEV_RISCV_APLIC_SIZE);
+	_FDT(fdt_property(fdt, "reg", reg_cells, sizeof(reg_cells)));
+	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 2));
+	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
+	_FDT(fdt_property_cell(fdt, "riscv,num-sources", aia_nr_sources));
+	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_AIA_APLIC));
+	_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_AIA_IMSIC));
+	_FDT(fdt_end_node(fdt));
+}
+
+static int aia__irq_routing_init(struct kvm *kvm)
+{
+	int r;
+	int irqlines = aia_nr_sources + 1;
+
+	/* Skip this if we have no interrupt sources */
+	if (!aia_nr_sources)
+		return 0;
+
+	/*
+	 * This describes the default routing that the kernel uses without
+	 * any routing explicitly set up via KVM_SET_GSI_ROUTING. So we
+	 * don't need to commit these setting right now. The first actual
+	 * user (MSI routing) will engage these mappings then.
+	 */
+	for (next_gsi = 0; next_gsi < irqlines; next_gsi++) {
+		r = irq__allocate_routing_entry();
+		if (r)
+			return r;
+
+		irq_routing->entries[irq_routing->nr++] =
+			(struct kvm_irq_routing_entry) {
+				.gsi = next_gsi,
+				.type = KVM_IRQ_ROUTING_IRQCHIP,
+				.u.irqchip.irqchip = IRQCHIP_AIA_NR,
+				.u.irqchip.pin = next_gsi,
+		};
+	}
+
+	return 0;
+}
+
+static int aia__init(struct kvm *kvm)
+{
+	int i, ret;
+	u64 aia_addr = 0;
+	struct kvm_device_attr aia_addr_attr = {
+		.group	= KVM_DEV_RISCV_AIA_GRP_ADDR,
+		.addr	= (u64)(unsigned long)&aia_addr,
+	};
+	struct kvm_device_attr aia_init_attr = {
+		.group	= KVM_DEV_RISCV_AIA_GRP_CTRL,
+		.attr	= KVM_DEV_RISCV_AIA_CTRL_INIT,
+	};
+
+	/* Setup global device attribute variables */
+	aia_mode_attr.addr = (u64)(unsigned long)&aia_mode;
+	aia_nr_ids_attr.addr = (u64)(unsigned long)&aia_nr_ids;
+	aia_nr_sources_attr.addr = (u64)(unsigned long)&aia_nr_sources;
+	aia_hart_bits_attr.addr = (u64)(unsigned long)&aia_hart_bits;
+
+	/* Do nothing if AIA device not created */
+	if (aia_fd < 0)
+		return 0;
+
+	/* Set/Get AIA device config parameters */
+	ret = ioctl(aia_fd, KVM_GET_DEVICE_ATTR, &aia_mode_attr);
+	if (ret)
+		return ret;
+	ret = ioctl(aia_fd, KVM_GET_DEVICE_ATTR, &aia_nr_ids_attr);
+	if (ret)
+		return ret;
+	aia_nr_sources = irq__get_nr_allocated_lines();
+	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_nr_sources_attr);
+	if (ret)
+		return ret;
+	aia_hart_bits = fls_long(kvm->nrcpus);
+	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_hart_bits_attr);
+	if (ret)
+		return ret;
+
+	/* Save number of HARTs for FDT generation */
+	aia_nr_harts = kvm->nrcpus;
+
+	/* Set AIA device addresses */
+	aia_addr = AIA_APLIC_ADDR(aia_nr_harts);
+	aia_addr_attr.attr = KVM_DEV_RISCV_AIA_ADDR_APLIC;
+	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_addr_attr);
+	if (ret)
+		return ret;
+	for (i = 0; i < kvm->nrcpus; i++) {
+		aia_addr = AIA_IMSIC_ADDR(i);
+		aia_addr_attr.attr = KVM_DEV_RISCV_AIA_ADDR_IMSIC(i);
+		ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_addr_attr);
+		if (ret)
+			return ret;
+	}
+
+	/* Setup default IRQ routing */
+	aia__irq_routing_init(kvm);
+
+	/* Initialize the AIA device */
+	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_init_attr);
+	if (ret)
+		return ret;
+
+	/* Mark IRQFD as ready */
+	riscv_irqchip_irqfd_ready = true;
+
+	return 0;
+}
+late_init(aia__init);
+
+void aia__create(struct kvm *kvm)
+{
+	int err;
+	struct kvm_create_device aia_device = {
+		.type = KVM_DEV_TYPE_RISCV_AIA,
+		.flags = 0,
+	};
+
+	if (kvm->cfg.arch.ext_disabled[KVM_RISCV_ISA_EXT_SSAIA])
+		return;
+
+	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &aia_device);
+	if (err)
+		return;
+	aia_fd = aia_device.fd;
+
+	riscv_irqchip = IRQCHIP_AIA;
+	riscv_irqchip_inkernel = true;
+	riscv_irqchip_trigger = NULL;
+	riscv_irqchip_generate_fdt_node = aia__generate_fdt_node;
+	riscv_irqchip_phandle = PHANDLE_AIA_APLIC;
+	riscv_irqchip_msi_phandle = PHANDLE_AIA_IMSIC;
+	riscv_irqchip_line_sensing = true;
+}
diff --git a/riscv/include/kvm/fdt-arch.h b/riscv/include/kvm/fdt-arch.h
index f7548e8..d88b832 100644
--- a/riscv/include/kvm/fdt-arch.h
+++ b/riscv/include/kvm/fdt-arch.h
@@ -1,7 +1,13 @@
 #ifndef KVM__KVM_FDT_H
 #define KVM__KVM_FDT_H
 
-enum phandles {PHANDLE_RESERVED = 0, PHANDLE_PLIC, PHANDLES_MAX};
+enum phandles {
+	PHANDLE_RESERVED = 0,
+	PHANDLE_PLIC,
+	PHANDLE_AIA_APLIC,
+	PHANDLE_AIA_IMSIC,
+	PHANDLES_MAX
+};
 
 #define PHANDLE_CPU_INTC_BASE	PHANDLES_MAX
 
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 1a8af6a..9f2159f 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -100,6 +100,8 @@ extern u32 riscv_irqchip_msi_phandle;
 extern bool riscv_irqchip_line_sensing;
 extern bool riscv_irqchip_irqfd_ready;
 
+void aia__create(struct kvm *kvm);
+
 void plic__create(struct kvm *kvm);
 
 void pci__generate_fdt_nodes(void *fdt);
diff --git a/riscv/irq.c b/riscv/irq.c
index e6c0939..be3e7ac 100644
--- a/riscv/irq.c
+++ b/riscv/irq.c
@@ -135,6 +135,9 @@ void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
 
 void riscv__irqchip_create(struct kvm *kvm)
 {
+	/* Try AIA in-kernel irqchip. */
+	aia__create(kvm);
+
 	/* Try PLIC irqchip */
 	plic__create(kvm);
 
-- 
2.34.1

