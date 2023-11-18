Return-Path: <kvm+bounces-1995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF1DE7EFFDC
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 14:29:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C7E81F2348A
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 13:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46ED418E11;
	Sat, 18 Nov 2023 13:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BZFbvBVO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3359131
	for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:21 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-5be24d41bb8so2100578a12.0
        for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1700314161; x=1700918961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQIUNoFHXkoxohBx9sysCPtH54xEjFNshRCdsHCALZQ=;
        b=BZFbvBVOCAXsBz8BW6rsgPCilU7apLc9I+V1C/kdu/x3FEF5XM2hBBeKooNz6EPLru
         +NqRRYVNw4SR7p1tqXuZFo/t82qiANzihXzO5/BI31PnR0tWiMPdRJANGgnYkptWc2NV
         vF8coAT9DDyY283YF4k1PNgubEe15QaxMTPpaAnYKtMwt1l8k4bo3eJ7f3ujcOPO3JUV
         0mNqtOWXHgHo4F5Kqh93gjcPwg4UT87IBy1/wtOMXtVhSIYi0NaqWGGIU+EdEt6GE6h1
         KXY3wsJKmVMs+S58MRrwR4m9+0jJeGxjDhyofCU+tlycnjLiHdHHZXqs+SrR7PB6fgHC
         yjvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700314161; x=1700918961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lQIUNoFHXkoxohBx9sysCPtH54xEjFNshRCdsHCALZQ=;
        b=hIFmc+Jh1XYSHnih3av5P/9vD/DFpuQfWTcee2c5GgX31eYC7rnC5ZnmzvUJWiO8K5
         zSLo8yVAJOf8TPzCKwsddRY2H7+UxwbDZadjBEYI1oX+X65FS9DVRfZqcbjhI1oZGCZv
         snvanjTRG/MHWSfgT9qanrR1ImaV6GWCnAWMwEziTZuX0LPE7U+332cFuBYCCYqzXUY5
         eLQb8+/orCS9I4Fp+ZCYtyIdEVsTRxzxPLsdj5kg2uMEhEQ2vU7ys7tUs9Ira7vW9ie8
         HZ1b0gSiESesa2O6LWVUz3wHVgHZrs/SZxJYg9wRlggIa5JytiSBTnCFhYAAa1AS0H0x
         X8eg==
X-Gm-Message-State: AOJu0Yx07LSgWNrPSZ7fK+fb4+SVUDcVKqQKQPIh+/T0izXdoOsJQGVq
	pcrplySp+2HHXawzgNd1uWlDLQ==
X-Google-Smtp-Source: AGHT+IE+lM7W+beDTUGtJQPqXPZevlj/FXKjnEJlJgCP8OmLHY4jkuS4ryfti7WGfwbrHZ0Po24Z+g==
X-Received: by 2002:a17:90a:e82:b0:280:982:aa9f with SMTP id 2-20020a17090a0e8200b002800982aa9fmr11330386pjx.7.1700314161089;
        Sat, 18 Nov 2023 05:29:21 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.80.108])
        by smtp.gmail.com with ESMTPSA id k25-20020a63ba19000000b005b944b20f34sm2627262pgf.85.2023.11.18.05.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Nov 2023 05:29:20 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 5/6] riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
Date: Sat, 18 Nov 2023 18:58:46 +0530
Message-Id: <20231118132847.758785-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231118132847.758785-1-apatel@ventanamicro.com>
References: <20231118132847.758785-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM RISC-V kernel module supports AIA in-kernel irqchip when
underlying host has AIA support. We detect and use AIA in-kernel
irqchip whenever possible otherwise we fallback to PLIC emulated
in user-space.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 Makefile                     |   1 +
 riscv/aia.c                  | 227 +++++++++++++++++++++++++++++++++++
 riscv/include/kvm/fdt-arch.h |   8 +-
 riscv/include/kvm/kvm-arch.h |   1 +
 riscv/irq.c                  |  20 ++-
 5 files changed, 251 insertions(+), 6 deletions(-)
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
index 0000000..fe9399a
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
+#define AIA_APLIC_ADDR			\
+	(AIA_IMSIC_BASE + AIA_IMSIC_SIZE)
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
+	sprintf(name, "aplic@%08x", (u32)AIA_APLIC_ADDR);
+	_FDT(fdt_begin_node(fdt, name));
+	_FDT(fdt_property_string(fdt, "compatible", "riscv,aplic"));
+	reg_cells[0] = 0;
+	reg_cells[1] = cpu_to_fdt32(AIA_APLIC_ADDR);
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
+	aia_addr = AIA_APLIC_ADDR;
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
index edff1ef..f0f469f 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -100,6 +100,7 @@ extern u32 riscv_irqchip_msi_phandle;
 extern bool riscv_irqchip_line_sensing;
 extern bool riscv_irqchip_irqfd_ready;
 
+void aia__create(struct kvm *kvm);
 void plic__create(struct kvm *kvm);
 
 void pci__generate_fdt_nodes(void *fdt);
diff --git a/riscv/irq.c b/riscv/irq.c
index b99a055..62dbaa8 100644
--- a/riscv/irq.c
+++ b/riscv/irq.c
@@ -133,12 +133,22 @@ void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
 	_FDT(fdt_property(fdt, "interrupts", prop, size));
 }
 
+static void (*riscv__irqchip_create_funcs[])(struct kvm *kvm) = {
+	aia__create,
+	plic__create,
+};
+
 void riscv__irqchip_create(struct kvm *kvm)
 {
-	/* Try PLIC irqchip */
-	plic__create(kvm);
+	unsigned int i;
+
+	/* Try irqchip.create function one after another */
+	for (i = 0; i < ARRAY_SIZE(riscv__irqchip_create_funcs); i++) {
+		riscv__irqchip_create_funcs[i](kvm);
+		if (riscv_irqchip != IRQCHIP_UNKNOWN)
+			return;
+	}
 
-	/* Fail if irqchip unknown */
-	if (riscv_irqchip == IRQCHIP_UNKNOWN)
-		die("No IRQCHIP found\n");
+	/* Fail since irqchip is unknown */
+	die("No IRQCHIP found\n");
 }
-- 
2.34.1


