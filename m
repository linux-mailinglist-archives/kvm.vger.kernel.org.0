Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE3E1B72D9
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgDXLN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgDXLN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:13:57 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654C6C09B045;
        Fri, 24 Apr 2020 04:13:57 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id hi11so3758729pjb.3;
        Fri, 24 Apr 2020 04:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b1T1Xbbxwp7Mhhuminkdo+c4NfQiwDLf5bBXBxIhDBc=;
        b=NIlYfM9nhgQhWEFgUw0oZ7ilMqqEfLIopcBHSQQTKcv0+UzhnKxtTvA96RIAgQqHGh
         ZxyOx0bcGxzXLOpyTe3VQjTnxen1A+yYMmEn1BcMF4lveElNsvIwKfOl7hnhNc3o91jc
         xES03iAIQQfGz8pN+rJeND5AFqt3rVSFu+x4UXk71ExwGSV6bQbaEqh9KdLM1CbvymTE
         LE6kAJikFV4BNC+24SeY5zYw7rAT+yjG1sdWoFG91IwxFnW4I/MSzILm8xuQ1Cl+w6im
         Vrb7YM/fjRz4b05HrFVE0/W5bljI6Ar4wb0vki6s1q9JGfsVmfj99KYlr39cV+5BYHgJ
         Hg8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=b1T1Xbbxwp7Mhhuminkdo+c4NfQiwDLf5bBXBxIhDBc=;
        b=Tl8u1eyFXmAq6xG6De1xS16hLezlg9o+mbhZBNmD0sMPyOhShaLd6l3NPX7W2Od3bt
         xaldRpOVlf6oxVCh8EUHHV6rr/qfBxDKj6yc8wmFse5H9gjNMmuntdRHxNzfbN7h0bVk
         V4L6JA979JorCtpY+PkZz8964AYeoESslTeXNrv7JaAeQXmEE6wUmQarol0z5RAq0ffC
         smKWQdFw77D08KjCwZdcnPxMhpy6VjRFwjAC15Ia0STT8rNYomEu4R/XGLlsJFBxbEWn
         gH4oN3Kv0tpJguTcsSplx4u/qulKvh9s9TjbBbz5e7ErxmI5lxB+cWesaO60IYyTVaM+
         mWNA==
X-Gm-Message-State: AGi0PuZlaoxU4JJ1w0DReguMW9wLbRIiAH2gaySD2kWMmDiAldGTiptg
        1goAaCGD4XOckbkJKk4s4bQ=
X-Google-Smtp-Source: APiQypL5JmFwTfZyP9w8FKToxXzu5qMKabSzngTcoE8/9o2T37K3Fnv4XKKG1luVhhCafP+x7uKkOA==
X-Received: by 2002:a17:902:d68d:: with SMTP id v13mr8647302ply.294.1587726836895;
        Fri, 24 Apr 2020 04:13:56 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id y10sm5470110pfb.53.2020.04.24.04.13.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 04:13:56 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 10/14] KVM: MIPS: Add Loongson-3 Virtual IPI interrupt support
Date:   Fri, 24 Apr 2020 19:15:29 +0800
Message-Id: <1587726933-31757-11-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
References: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch add Loongson-3 Virtual IPI interrupt support in the kernel,
because emulate it in QEMU is too expensive for performance.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/kvm_host.h |  32 ++++++
 arch/mips/kvm/Makefile           |   3 +
 arch/mips/kvm/emulate.c          |  21 +++-
 arch/mips/kvm/loongson_ipi.c     | 215 +++++++++++++++++++++++++++++++++++++++
 arch/mips/kvm/mips.c             |   6 ++
 5 files changed, 276 insertions(+), 1 deletion(-)
 create mode 100644 arch/mips/kvm/loongson_ipi.c

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index a7758c0..c98eb42 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -23,6 +23,8 @@
 #include <asm/inst.h>
 #include <asm/mipsregs.h>
 
+#include <kvm/iodev.h>
+
 /* MIPS KVM register ids */
 #define MIPS_CP0_32(_R, _S)					\
 	(KVM_REG_MIPS_CP0 | KVM_REG_SIZE_U32 | (8 * (_R) + (_S)))
@@ -181,11 +183,39 @@ struct kvm_vcpu_stat {
 struct kvm_arch_memory_slot {
 };
 
+#ifdef CONFIG_CPU_LOONGSON64
+typedef struct ipi_state {
+	uint32_t status;
+	uint32_t en;
+	uint32_t set;
+	uint32_t clear;
+	uint64_t buf[4];
+} ipi_state;
+
+struct loongson_kvm_ipi;
+
+typedef struct ipi_io_device {
+	int node_id;
+	struct loongson_kvm_ipi *ipi;
+	struct kvm_io_device device;
+} ipi_io_device;
+
+struct loongson_kvm_ipi {
+	spinlock_t lock;
+	struct kvm *kvm;
+	ipi_state ipistate[16];
+	ipi_io_device dev_ipi[4];
+};
+#endif
+
 struct kvm_arch {
 	/* Guest physical mm */
 	struct mm_struct gpa_mm;
 	/* Mask of CPUs needing GPA ASID flush */
 	cpumask_t asid_flush_mask;
+#ifdef CONFIG_CPU_LOONGSON64
+	struct loongson_kvm_ipi ipi;
+#endif
 };
 
 #define N_MIPS_COPROC_REGS	32
@@ -1133,6 +1163,8 @@ extern int kvm_mips_trans_mtc0(union mips_instruction inst, u32 *opc,
 /* Misc */
 extern void kvm_mips_dump_stats(struct kvm_vcpu *vcpu);
 extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
+extern int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
+			     struct kvm_mips_interrupt *irq);
 
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 0a3cef6..506c4ac 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -13,6 +13,9 @@ kvm-objs := $(common-objs-y) mips.o emulate.o entry.o \
 	    fpu.o
 kvm-objs += hypcall.o
 kvm-objs += mmu.o
+ifdef CONFIG_CPU_LOONGSON64
+kvm-objs += loongson_ipi.o
+endif
 
 ifdef CONFIG_KVM_MIPS_VZ
 kvm-objs		+= vz.o
diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index 754094b..aa2db51 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -1600,6 +1600,7 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 					     struct kvm_run *run,
 					     struct kvm_vcpu *vcpu)
 {
+	int r;
 	enum emulation_result er;
 	u32 rt;
 	void *data = run->mmio.data;
@@ -1666,9 +1667,17 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 		goto out_fail;
 	}
 
-	run->mmio.is_write = 1;
 	vcpu->mmio_needed = 1;
+	run->mmio.is_write = 1;
 	vcpu->mmio_is_write = 1;
+
+	r = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, run->mmio.phys_addr, run->mmio.len, data);
+
+	if (!r) {
+		vcpu->mmio_needed = 0;
+		return EMULATE_DONE;
+	}
+
 	return EMULATE_DO_MMIO;
 
 out_fail:
@@ -1681,6 +1690,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 					    u32 cause, struct kvm_run *run,
 					    struct kvm_vcpu *vcpu)
 {
+	int r;
 	enum emulation_result er;
 	unsigned long curr_pc;
 	u32 op, rt;
@@ -1745,6 +1755,15 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 
 	run->mmio.is_write = 0;
 	vcpu->mmio_is_write = 0;
+
+	r = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, run->mmio.phys_addr, run->mmio.len, run->mmio.data);
+
+	if (!r) {
+		kvm_mips_complete_mmio_load(vcpu, run);
+		vcpu->mmio_needed = 0;
+		return EMULATE_DONE;
+	}
+
 	return EMULATE_DO_MMIO;
 }
 
diff --git a/arch/mips/kvm/loongson_ipi.c b/arch/mips/kvm/loongson_ipi.c
new file mode 100644
index 00000000..3e22532
--- /dev/null
+++ b/arch/mips/kvm/loongson_ipi.c
@@ -0,0 +1,215 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Loongson-3 Virtual IPI interrupt support.
+ *
+ * Copyright (C) 2019  Loongson Technologies, Inc.  All rights reserved.
+ *
+ * Authors: Chen Zhu <zhuchen@loongson.cn>
+ * Authors: Huacai Chen <chenhc@lemote.com>
+ */
+
+#include <linux/kvm_host.h>
+
+#define IPI_BASE            0x3ff01000ULL
+
+#define CORE0_STATUS_OFF       0x000
+#define CORE0_EN_OFF           0x004
+#define CORE0_SET_OFF          0x008
+#define CORE0_CLEAR_OFF        0x00c
+#define CORE0_BUF_20           0x020
+#define CORE0_BUF_28           0x028
+#define CORE0_BUF_30           0x030
+#define CORE0_BUF_38           0x038
+
+#define CORE1_STATUS_OFF       0x100
+#define CORE1_EN_OFF           0x104
+#define CORE1_SET_OFF          0x108
+#define CORE1_CLEAR_OFF        0x10c
+#define CORE1_BUF_20           0x120
+#define CORE1_BUF_28           0x128
+#define CORE1_BUF_30           0x130
+#define CORE1_BUF_38           0x138
+
+#define CORE2_STATUS_OFF       0x200
+#define CORE2_EN_OFF           0x204
+#define CORE2_SET_OFF          0x208
+#define CORE2_CLEAR_OFF        0x20c
+#define CORE2_BUF_20           0x220
+#define CORE2_BUF_28           0x228
+#define CORE2_BUF_30           0x230
+#define CORE2_BUF_38           0x238
+
+#define CORE3_STATUS_OFF       0x300
+#define CORE3_EN_OFF           0x304
+#define CORE3_SET_OFF          0x308
+#define CORE3_CLEAR_OFF        0x30c
+#define CORE3_BUF_20           0x320
+#define CORE3_BUF_28           0x328
+#define CORE3_BUF_30           0x330
+#define CORE3_BUF_38           0x338
+
+static int loongson_vipi_read(struct loongson_kvm_ipi *ipi, gpa_t addr, int len, void *val)
+{
+	uint32_t core = (addr >> 8) & 3;
+	uint32_t node = (addr >> 44) & 3;
+	uint32_t id = core + node * 4;
+	uint64_t offset = addr & 0xff;
+	void *pbuf;
+	ipi_state *s = &(ipi->ipistate[id]);
+
+	BUG_ON(offset & (len - 1));
+
+	switch (offset) {
+	case CORE0_STATUS_OFF:
+		*(uint64_t *)val = s->status;
+		break;
+
+	case CORE0_EN_OFF:
+		*(uint64_t *)val = s->en;
+		break;
+
+	case CORE0_SET_OFF:
+		*(uint64_t *)val = 0;
+		break;
+
+	case CORE0_CLEAR_OFF:
+		*(uint64_t *)val = 0;
+		break;
+
+	case CORE0_BUF_20 ... CORE0_BUF_38:
+		pbuf = (void *)s->buf + (offset - 0x20);
+		if (len == 8)
+			*(uint64_t *)val = *(uint64_t *)pbuf;
+		else /* Assume len == 4 */
+			*(uint32_t *)val = *(uint32_t *)pbuf;
+		break;
+
+	default:
+		printk("loongson_vipi_read() with unknown addr %llx \n", addr);
+		break;
+	}
+
+	return 0;
+}
+
+static int loongson_vipi_write(struct loongson_kvm_ipi *ipi, gpa_t addr, int len, const void *val)
+{
+	uint32_t core = (addr >> 8) & 3;
+	uint32_t node = (addr >> 44) & 3;
+	uint32_t id = core + node * 4;
+	uint64_t data, offset = addr & 0xff;
+	void *pbuf;
+	struct kvm *kvm = ipi->kvm;
+	struct kvm_mips_interrupt irq;
+	ipi_state *s = &(ipi->ipistate[id]);
+
+	data = *(uint64_t *)val;
+	BUG_ON(offset & (len - 1));
+
+	switch (offset) {
+	case CORE0_STATUS_OFF:
+		break;
+
+	case CORE0_EN_OFF:
+		s->en = data;
+		break;
+
+	case CORE0_SET_OFF:
+		s->status |= data;
+		irq.cpu = id;
+		irq.irq = 6;
+		kvm_vcpu_ioctl_interrupt(kvm->vcpus[id], &irq);
+		break;
+
+	case CORE0_CLEAR_OFF:
+		s->status &= ~data;
+		if (!s->status) {
+			irq.cpu = id;
+			irq.irq = -6;
+			kvm_vcpu_ioctl_interrupt(kvm->vcpus[id],&irq);
+		}
+		break;
+
+	case CORE0_BUF_20 ... CORE0_BUF_38:
+		pbuf = (void *)s->buf + (offset - 0x20);
+		if (len == 8)
+			*(uint64_t *)pbuf = (uint64_t)data;
+		else /* Assume len == 4 */
+			*(uint32_t *)pbuf = (uint32_t)data;
+		break;
+
+	default:
+		printk("loongson_vipi_write() with unknown addr %llx \n", addr);
+		break;
+	}
+
+	return 0;
+}
+
+static int kvm_ipi_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+		gpa_t addr, int len, void *val)
+{
+	unsigned long flags;
+	ipi_io_device *ipi_device;
+	struct loongson_kvm_ipi *ipi;
+
+	ipi_device = container_of(dev, ipi_io_device, device);
+	ipi = ipi_device->ipi;
+
+	spin_lock_irqsave(&ipi->lock, flags);
+	loongson_vipi_read(ipi, addr, len, val);
+	spin_unlock_irqrestore(&ipi->lock, flags);
+
+	return 0;
+}
+
+static int kvm_ipi_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+		gpa_t addr, int len, const void *val)
+{
+	unsigned long flags;
+	ipi_io_device *ipi_device;
+	struct loongson_kvm_ipi *ipi;
+
+	ipi_device = container_of(dev, ipi_io_device, device);
+	ipi = ipi_device->ipi;
+
+	spin_lock_irqsave(&ipi->lock, flags);
+	loongson_vipi_write(ipi, addr, len, val);
+	spin_unlock_irqrestore(&ipi->lock, flags);
+
+	return 0;
+}
+
+static const struct kvm_io_device_ops kvm_ipi_ops = {
+	.read     = kvm_ipi_read,
+	.write    = kvm_ipi_write,
+};
+
+void kvm_init_loongson_ipi(struct kvm *kvm)
+{
+	int i;
+	unsigned long addr;
+	struct loongson_kvm_ipi *s;
+	struct kvm_io_device *device;
+
+	s = &kvm->arch.ipi;
+	s->kvm = kvm;
+	spin_lock_init(&s->lock);
+
+	/*
+	 * Initialize IPI device
+	 */
+	for (i = 0; i < 4; i++) {
+		device = &s->dev_ipi[i].device;
+		kvm_iodevice_init(device, &kvm_ipi_ops);
+		addr = (((unsigned long)i) << 44) + IPI_BASE;
+		mutex_lock(&kvm->slots_lock);
+		kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, addr, 0x400, device);
+		mutex_unlock(&kvm->slots_lock);
+		s->dev_ipi[i].ipi = s;
+		s->dev_ipi[i].node_id = i;
+	}
+}
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 5ca122c..ed989ef 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -128,6 +128,8 @@ int kvm_arch_check_processor_compat(void *opaque)
 	return 0;
 }
 
+extern void kvm_init_loongson_ipi(struct kvm *kvm);
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	switch (type) {
@@ -147,6 +149,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (!kvm->arch.gpa_mm.pgd)
 		return -ENOMEM;
 
+#ifdef CONFIG_CPU_LOONGSON64
+	kvm_init_loongson_ipi(kvm);
+#endif
+
 	return 0;
 }
 
-- 
2.7.0

