Return-Path: <kvm+bounces-42670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD938A7C1CC
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 18:53:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 226B317A240
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE932135C9;
	Fri,  4 Apr 2025 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TDOlYQnF"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0DE20A5E1
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 16:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785577; cv=none; b=YM4d42yutvMoieJAj8z8fq/MozjqoYzB/a4roGKioxu/nUeldp9rjcUzHaUI2mEMhfmCCLfdsuO27ID0vqfMYEpMzIlgWkM+7J+ViDazaOqzBkfCnNk9a2i4Qw1zp2K5WCYpkLqDzEGh5AZWlTA0BoV8qtpakT7KaYIp/4APENo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785577; c=relaxed/simple;
	bh=HQb6+Spo/K/t5zYTs+4gNS6NNXX1DKGu+xqdD2+Ppbk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nRPP+d2Wd7lIsJnNZTRbfuDm+fro/WHN34AjamJA2RRt63zbET9HYeTxLuAr5rxQE6R1hpWL6Z3Z4LmH4i8VGfFuqFLYeTEoMRcI3aZJGTNkWCq+uJlDOYl8CWvSJUYAlp/cPlbyRj1OuM0+sgDMkiNdtqqE9ZxBavqpn1Qkfg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TDOlYQnF; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743785570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LyvwsaW6b6CV7yNMy0paAS69aYNtYFlcmjBAHpJg7Eg=;
	b=TDOlYQnF5KRUXtqNp2X2hMaZcT7JDEi0J5ywC823vBVe7rV/eagGnf3bTpfwTUGIf5UyQ9
	7E516QoxJmOIH+n+aNh8bbjkbFirpqn5oc4mTgTRXy2Q23X1pYYP9f2+43CPlX6mmcso5B
	IIzC++4u4zdsOiXv6MspiLhvR74srxk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v2 1/9] Drop support for 32-bit arm
Date: Fri,  4 Apr 2025 09:52:24 -0700
Message-Id: <20250404165233.3205127-2-oliver.upton@linux.dev>
In-Reply-To: <20250404165233.3205127-1-oliver.upton@linux.dev>
References: <20250404165233.3205127-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Linux dropped support for KVM in 32-bit arm kernels almost 5 years ago
in the 5.7 kernel release. In addition to that KVM/arm64 never had
32-bit compat support, so it is a safe assumption that usage of 32-bit
kvmtool is pretty much dead at this point.

Do not despair -- 32-bit guests are still supported with a 64-bit
userspace.

Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 INSTALL                                   |   9 +-
 Makefile                                  |  31 +--
 arm/aarch32/arm-cpu.c                     |  50 ----
 arm/aarch32/include/asm/kernel.h          |   8 -
 arm/aarch32/include/asm/kvm.h             | 311 ----------------------
 arm/aarch32/include/kvm/barrier.h         |  10 -
 arm/aarch32/include/kvm/fdt-arch.h        |   6 -
 arm/aarch32/include/kvm/kvm-arch.h        |  18 --
 arm/aarch32/include/kvm/kvm-config-arch.h |   8 -
 arm/aarch32/include/kvm/kvm-cpu-arch.h    |  24 --
 arm/aarch32/kvm-cpu.c                     | 132 ---------
 arm/aarch32/kvm.c                         |  14 -
 builtin-run.c                             |   2 +-
 hw/cfi_flash.c                            |   2 +-
 hw/rtc.c                                  |   2 +-
 hw/serial.c                               |   2 +-
 virtio/core.c                             |   2 +-
 17 files changed, 19 insertions(+), 612 deletions(-)
 delete mode 100644 arm/aarch32/arm-cpu.c
 delete mode 100644 arm/aarch32/include/asm/kernel.h
 delete mode 100644 arm/aarch32/include/asm/kvm.h
 delete mode 100644 arm/aarch32/include/kvm/barrier.h
 delete mode 100644 arm/aarch32/include/kvm/fdt-arch.h
 delete mode 100644 arm/aarch32/include/kvm/kvm-arch.h
 delete mode 100644 arm/aarch32/include/kvm/kvm-config-arch.h
 delete mode 100644 arm/aarch32/include/kvm/kvm-cpu-arch.h
 delete mode 100644 arm/aarch32/kvm-cpu.c
 delete mode 100644 arm/aarch32/kvm.c

diff --git a/INSTALL b/INSTALL
index 2a65735..0e1e63e 100644
--- a/INSTALL
+++ b/INSTALL
@@ -26,7 +26,7 @@ For Fedora based systems:
 For OpenSUSE based systems:
 	# zypper install glibc-devel-static
 
-Architectures which require device tree (PowerPC, ARM, ARM64, RISC-V) also
+Architectures which require device tree (PowerPC, ARM64, RISC-V) also
 require libfdt.
 	deb: $ sudo apt-get install libfdt-dev
 	Fedora: # yum install libfdt-devel
@@ -61,16 +61,15 @@ to the Linux name of the architecture. Architectures supported:
 - i386
 - x86_64
 - powerpc
-- arm
 - arm64
 - mips
 - riscv
 If ARCH is not provided, the target architecture will be automatically
 determined by running "uname -m" on your host, resulting in a native build.
 
-To cross-compile to ARM for instance, install a cross-compiler, put the
+To cross-compile to arm64 for instance, install a cross-compiler, put the
 required libraries in the cross-compiler's SYSROOT and type:
-$ make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm
+$ make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64
 
 Missing libraries when cross-compiling
 ---------------------------------------
@@ -82,7 +81,7 @@ On multiarch system you should be able to install those be appending
 the architecture name after the package (example for ARM64):
 $ sudo apt-get install libfdt-dev:arm64
 
-PowerPC, ARM/ARM64 and RISC-V require libfdt to be installed. If you cannot use
+PowerPC, ARM64 and RISC-V require libfdt to be installed. If you cannot use
 precompiled mulitarch packages, you could either copy the required header and
 library files from an installed target system into the SYSROOT (you will need
 /usr/include/*fdt*.h and /usr/lib64/libfdt-v.v.v.so and its symlinks), or you
diff --git a/Makefile b/Makefile
index d84dc8e..462659b 100644
--- a/Makefile
+++ b/Makefile
@@ -166,35 +166,24 @@ ifeq ($(ARCH), powerpc)
 	ARCH_WANT_LIBFDT := y
 endif
 
-# ARM
-OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
-			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
-			   hw/serial.o
-HDRS_ARM_COMMON		:= arm/include
-ifeq ($(ARCH), arm)
-	DEFINES		+= -DCONFIG_ARM
-	OBJS		+= $(OBJS_ARM_COMMON)
-	OBJS		+= arm/aarch32/arm-cpu.o
-	OBJS		+= arm/aarch32/kvm-cpu.o
-	OBJS		+= arm/aarch32/kvm.o
-	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
-	ARCH_INCLUDE	+= -Iarm/aarch32/include
-	CFLAGS		+= -march=armv7-a
-
-	ARCH_WANT_LIBFDT := y
-	ARCH_HAS_FLASH_MEM := y
-endif
-
 # ARM64
 ifeq ($(ARCH), arm64)
 	DEFINES		+= -DCONFIG_ARM64
-	OBJS		+= $(OBJS_ARM_COMMON)
+	OBJS		+= arm/fdt.o
+	OBJS		+= arm/gic.o
+	OBJS		+= arm/gicv2m.o
+	OBJS		+= arm/ioport.o
+	OBJS		+= arm/kvm.o
+	OBJS		+= arm/kvm-cpu.o
+	OBJS		+= arm/pci.o
+	OBJS		+= arm/timer.o
+	OBJS		+= hw/serial.o
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
 	OBJS		+= arm/aarch64/pvtime.o
 	OBJS		+= arm/aarch64/pmu.o
-	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
+	ARCH_INCLUDE	:= arm/include
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
 	ARCH_WANT_LIBFDT := y
diff --git a/arm/aarch32/arm-cpu.c b/arm/aarch32/arm-cpu.c
deleted file mode 100644
index 16bba55..0000000
--- a/arm/aarch32/arm-cpu.c
+++ /dev/null
@@ -1,50 +0,0 @@
-#include "kvm/kvm.h"
-#include "kvm/kvm-cpu.h"
-#include "kvm/util.h"
-
-#include "arm-common/gic.h"
-#include "arm-common/timer.h"
-
-#include <linux/byteorder.h>
-#include <linux/types.h>
-
-static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
-{
-	int timer_interrupts[4] = {13, 14, 11, 10};
-
-	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
-	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
-}
-
-static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
-{
-	vcpu->generate_fdt_nodes = generate_fdt_nodes;
-	return 0;
-}
-
-static struct kvm_arm_target target_generic_v7 = {
-	.id		= UINT_MAX,
-	.compatible	= "arm,arm-v7",
-	.init		= arm_cpu__vcpu_init,
-};
-
-static struct kvm_arm_target target_cortex_a15 = {
-	.id		= KVM_ARM_TARGET_CORTEX_A15,
-	.compatible	= "arm,cortex-a15",
-	.init		= arm_cpu__vcpu_init,
-};
-
-static struct kvm_arm_target target_cortex_a7 = {
-	.id		= KVM_ARM_TARGET_CORTEX_A7,
-	.compatible	= "arm,cortex-a7",
-	.init		= arm_cpu__vcpu_init,
-};
-
-static int arm_cpu__core_init(struct kvm *kvm)
-{
-	kvm_cpu__set_kvm_arm_generic_target(&target_generic_v7);
-
-	return (kvm_cpu__register_kvm_arm_target(&target_cortex_a15) ||
-		kvm_cpu__register_kvm_arm_target(&target_cortex_a7));
-}
-core_init(arm_cpu__core_init);
diff --git a/arm/aarch32/include/asm/kernel.h b/arm/aarch32/include/asm/kernel.h
deleted file mode 100644
index 6129609..0000000
--- a/arm/aarch32/include/asm/kernel.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-#ifndef __ASM_KERNEL_H
-#define __ASM_KERNEL_H
-
-#define NR_CPUS	32
-
-#endif /* __ASM_KERNEL_H */
diff --git a/arm/aarch32/include/asm/kvm.h b/arm/aarch32/include/asm/kvm.h
deleted file mode 100644
index a4217c1..0000000
--- a/arm/aarch32/include/asm/kvm.h
+++ /dev/null
@@ -1,311 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/*
- * Copyright (C) 2012 - Virtual Open Systems and Columbia University
- * Author: Christoffer Dall <c.dall@virtualopensystems.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, version 2, as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- */
-
-#ifndef __ARM_KVM_H__
-#define __ARM_KVM_H__
-
-#include <linux/types.h>
-#include <linux/psci.h>
-#include <asm/ptrace.h>
-
-#define __KVM_HAVE_GUEST_DEBUG
-#define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_READONLY_MEM
-#define __KVM_HAVE_VCPU_EVENTS
-
-#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
-
-#define KVM_REG_SIZE(id)						\
-	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
-
-/* Valid for svc_regs, abt_regs, und_regs, irq_regs in struct kvm_regs */
-#define KVM_ARM_SVC_sp		svc_regs[0]
-#define KVM_ARM_SVC_lr		svc_regs[1]
-#define KVM_ARM_SVC_spsr	svc_regs[2]
-#define KVM_ARM_ABT_sp		abt_regs[0]
-#define KVM_ARM_ABT_lr		abt_regs[1]
-#define KVM_ARM_ABT_spsr	abt_regs[2]
-#define KVM_ARM_UND_sp		und_regs[0]
-#define KVM_ARM_UND_lr		und_regs[1]
-#define KVM_ARM_UND_spsr	und_regs[2]
-#define KVM_ARM_IRQ_sp		irq_regs[0]
-#define KVM_ARM_IRQ_lr		irq_regs[1]
-#define KVM_ARM_IRQ_spsr	irq_regs[2]
-
-/* Valid only for fiq_regs in struct kvm_regs */
-#define KVM_ARM_FIQ_r8		fiq_regs[0]
-#define KVM_ARM_FIQ_r9		fiq_regs[1]
-#define KVM_ARM_FIQ_r10		fiq_regs[2]
-#define KVM_ARM_FIQ_fp		fiq_regs[3]
-#define KVM_ARM_FIQ_ip		fiq_regs[4]
-#define KVM_ARM_FIQ_sp		fiq_regs[5]
-#define KVM_ARM_FIQ_lr		fiq_regs[6]
-#define KVM_ARM_FIQ_spsr	fiq_regs[7]
-
-struct kvm_regs {
-	struct pt_regs usr_regs;	/* R0_usr - R14_usr, PC, CPSR */
-	unsigned long svc_regs[3];	/* SP_svc, LR_svc, SPSR_svc */
-	unsigned long abt_regs[3];	/* SP_abt, LR_abt, SPSR_abt */
-	unsigned long und_regs[3];	/* SP_und, LR_und, SPSR_und */
-	unsigned long irq_regs[3];	/* SP_irq, LR_irq, SPSR_irq */
-	unsigned long fiq_regs[8];	/* R8_fiq - R14_fiq, SPSR_fiq */
-};
-
-/* Supported Processor Types */
-#define KVM_ARM_TARGET_CORTEX_A15	0
-#define KVM_ARM_TARGET_CORTEX_A7	1
-#define KVM_ARM_NUM_TARGETS		2
-
-/* KVM_ARM_SET_DEVICE_ADDR ioctl id encoding */
-#define KVM_ARM_DEVICE_TYPE_SHIFT	0
-#define KVM_ARM_DEVICE_TYPE_MASK	(0xffff << KVM_ARM_DEVICE_TYPE_SHIFT)
-#define KVM_ARM_DEVICE_ID_SHIFT		16
-#define KVM_ARM_DEVICE_ID_MASK		(0xffff << KVM_ARM_DEVICE_ID_SHIFT)
-
-/* Supported device IDs */
-#define KVM_ARM_DEVICE_VGIC_V2		0
-
-/* Supported VGIC address types  */
-#define KVM_VGIC_V2_ADDR_TYPE_DIST	0
-#define KVM_VGIC_V2_ADDR_TYPE_CPU	1
-
-#define KVM_VGIC_V2_DIST_SIZE		0x1000
-#define KVM_VGIC_V2_CPU_SIZE		0x2000
-
-/* Supported VGICv3 address types  */
-#define KVM_VGIC_V3_ADDR_TYPE_DIST	2
-#define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
-#define KVM_VGIC_ITS_ADDR_TYPE		4
-#define KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION	5
-
-#define KVM_VGIC_V3_DIST_SIZE		SZ_64K
-#define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
-#define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
-
-#define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
-#define KVM_ARM_VCPU_PSCI_0_2		1 /* CPU uses PSCI v0.2 */
-
-struct kvm_vcpu_init {
-	__u32 target;
-	__u32 features[7];
-};
-
-struct kvm_sregs {
-};
-
-struct kvm_fpu {
-};
-
-struct kvm_guest_debug_arch {
-};
-
-struct kvm_debug_exit_arch {
-};
-
-struct kvm_sync_regs {
-	/* Used with KVM_CAP_ARM_USER_IRQ */
-	__u64 device_irq_level;
-};
-
-struct kvm_arch_memory_slot {
-};
-
-/* for KVM_GET/SET_VCPU_EVENTS */
-struct kvm_vcpu_events {
-	struct {
-		__u8 serror_pending;
-		__u8 serror_has_esr;
-		/* Align it to 8 bytes */
-		__u8 pad[6];
-		__u64 serror_esr;
-	} exception;
-	__u32 reserved[12];
-};
-
-/* If you need to interpret the index values, here is the key: */
-#define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
-#define KVM_REG_ARM_COPROC_SHIFT	16
-#define KVM_REG_ARM_32_OPC2_MASK	0x0000000000000007
-#define KVM_REG_ARM_32_OPC2_SHIFT	0
-#define KVM_REG_ARM_OPC1_MASK		0x0000000000000078
-#define KVM_REG_ARM_OPC1_SHIFT		3
-#define KVM_REG_ARM_CRM_MASK		0x0000000000000780
-#define KVM_REG_ARM_CRM_SHIFT		7
-#define KVM_REG_ARM_32_CRN_MASK		0x0000000000007800
-#define KVM_REG_ARM_32_CRN_SHIFT	11
-/*
- * For KVM currently all guest registers are nonsecure, but we reserve a bit
- * in the encoding to distinguish secure from nonsecure for AArch32 system
- * registers that are banked by security. This is 1 for the secure banked
- * register, and 0 for the nonsecure banked register or if the register is
- * not banked by security.
- */
-#define KVM_REG_ARM_SECURE_MASK	0x0000000010000000
-#define KVM_REG_ARM_SECURE_SHIFT	28
-
-#define ARM_CP15_REG_SHIFT_MASK(x,n) \
-	(((x) << KVM_REG_ARM_ ## n ## _SHIFT) & KVM_REG_ARM_ ## n ## _MASK)
-
-#define __ARM_CP15_REG(op1,crn,crm,op2) \
-	(KVM_REG_ARM | (15 << KVM_REG_ARM_COPROC_SHIFT) | \
-	ARM_CP15_REG_SHIFT_MASK(op1, OPC1) | \
-	ARM_CP15_REG_SHIFT_MASK(crn, 32_CRN) | \
-	ARM_CP15_REG_SHIFT_MASK(crm, CRM) | \
-	ARM_CP15_REG_SHIFT_MASK(op2, 32_OPC2))
-
-#define ARM_CP15_REG32(...) (__ARM_CP15_REG(__VA_ARGS__) | KVM_REG_SIZE_U32)
-
-#define __ARM_CP15_REG64(op1,crm) \
-	(__ARM_CP15_REG(op1, 0, crm, 0) | KVM_REG_SIZE_U64)
-#define ARM_CP15_REG64(...) __ARM_CP15_REG64(__VA_ARGS__)
-
-/* PL1 Physical Timer Registers */
-#define KVM_REG_ARM_PTIMER_CTL		ARM_CP15_REG32(0, 14, 2, 1)
-#define KVM_REG_ARM_PTIMER_CNT		ARM_CP15_REG64(0, 14)
-#define KVM_REG_ARM_PTIMER_CVAL		ARM_CP15_REG64(2, 14)
-
-/* Virtual Timer Registers */
-#define KVM_REG_ARM_TIMER_CTL		ARM_CP15_REG32(0, 14, 3, 1)
-#define KVM_REG_ARM_TIMER_CNT		ARM_CP15_REG64(1, 14)
-#define KVM_REG_ARM_TIMER_CVAL		ARM_CP15_REG64(3, 14)
-
-/* Normal registers are mapped as coprocessor 16. */
-#define KVM_REG_ARM_CORE		(0x0010 << KVM_REG_ARM_COPROC_SHIFT)
-#define KVM_REG_ARM_CORE_REG(name)	(offsetof(struct kvm_regs, name) / 4)
-
-/* Some registers need more space to represent values. */
-#define KVM_REG_ARM_DEMUX		(0x0011 << KVM_REG_ARM_COPROC_SHIFT)
-#define KVM_REG_ARM_DEMUX_ID_MASK	0x000000000000FF00
-#define KVM_REG_ARM_DEMUX_ID_SHIFT	8
-#define KVM_REG_ARM_DEMUX_ID_CCSIDR	(0x00 << KVM_REG_ARM_DEMUX_ID_SHIFT)
-#define KVM_REG_ARM_DEMUX_VAL_MASK	0x00000000000000FF
-#define KVM_REG_ARM_DEMUX_VAL_SHIFT	0
-
-/* VFP registers: we could overload CP10 like ARM does, but that's ugly. */
-#define KVM_REG_ARM_VFP			(0x0012 << KVM_REG_ARM_COPROC_SHIFT)
-#define KVM_REG_ARM_VFP_MASK		0x000000000000FFFF
-#define KVM_REG_ARM_VFP_BASE_REG	0x0
-#define KVM_REG_ARM_VFP_FPSID		0x1000
-#define KVM_REG_ARM_VFP_FPSCR		0x1001
-#define KVM_REG_ARM_VFP_MVFR1		0x1006
-#define KVM_REG_ARM_VFP_MVFR0		0x1007
-#define KVM_REG_ARM_VFP_FPEXC		0x1008
-#define KVM_REG_ARM_VFP_FPINST		0x1009
-#define KVM_REG_ARM_VFP_FPINST2		0x100A
-
-/* KVM-as-firmware specific pseudo-registers */
-#define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
-#define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM | KVM_REG_SIZE_U64 | \
-					 KVM_REG_ARM_FW | ((r) & 0xffff))
-#define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
-#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
-	/* Higher values mean better protection. */
-#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL		0
-#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL		1
-#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED	2
-#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
-	/* Higher values mean better protection. */
-#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL		0
-#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN		1
-#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL		2
-#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
-#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED	(1U << 4)
-
-/* Device Control API: ARM VGIC */
-#define KVM_DEV_ARM_VGIC_GRP_ADDR	0
-#define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
-#define KVM_DEV_ARM_VGIC_GRP_CPU_REGS	2
-#define   KVM_DEV_ARM_VGIC_CPUID_SHIFT	32
-#define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
-#define   KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT 32
-#define   KVM_DEV_ARM_VGIC_V3_MPIDR_MASK \
-			(0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
-#define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
-#define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
-#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
-#define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
-#define KVM_DEV_ARM_VGIC_GRP_CTRL       4
-#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
-#define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
-#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
-#define KVM_DEV_ARM_VGIC_GRP_ITS_REGS	8
-#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
-#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
-			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
-#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK 0x3ff
-#define VGIC_LEVEL_INFO_LINE_LEVEL	0
-
-/* Device Control API on vcpu fd */
-#define KVM_ARM_VCPU_PMU_V3_CTRL	0
-#define   KVM_ARM_VCPU_PMU_V3_IRQ	0
-#define   KVM_ARM_VCPU_PMU_V3_INIT	1
-#define KVM_ARM_VCPU_TIMER_CTRL		1
-#define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
-#define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
-
-#define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
-#define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
-#define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
-#define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
-#define   KVM_DEV_ARM_ITS_CTRL_RESET		4
-
-/* KVM_IRQ_LINE irq field index values */
-#define KVM_ARM_IRQ_TYPE_SHIFT		24
-#define KVM_ARM_IRQ_TYPE_MASK		0xff
-#define KVM_ARM_IRQ_VCPU_SHIFT		16
-#define KVM_ARM_IRQ_VCPU_MASK		0xff
-#define KVM_ARM_IRQ_NUM_SHIFT		0
-#define KVM_ARM_IRQ_NUM_MASK		0xffff
-
-/* irq_type field */
-#define KVM_ARM_IRQ_TYPE_CPU		0
-#define KVM_ARM_IRQ_TYPE_SPI		1
-#define KVM_ARM_IRQ_TYPE_PPI		2
-
-/* out-of-kernel GIC cpu interrupt injection irq_number field */
-#define KVM_ARM_IRQ_CPU_IRQ		0
-#define KVM_ARM_IRQ_CPU_FIQ		1
-
-/*
- * This used to hold the highest supported SPI, but it is now obsolete
- * and only here to provide source code level compatibility with older
- * userland. The highest SPI number can be set via KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
- */
-#ifndef __KERNEL__
-#define KVM_ARM_IRQ_GIC_MAX		127
-#endif
-
-/* One single KVM irqchip, ie. the VGIC */
-#define KVM_NR_IRQCHIPS          1
-
-/* PSCI interface */
-#define KVM_PSCI_FN_BASE		0x95c1ba5e
-#define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
-
-#define KVM_PSCI_FN_CPU_SUSPEND		KVM_PSCI_FN(0)
-#define KVM_PSCI_FN_CPU_OFF		KVM_PSCI_FN(1)
-#define KVM_PSCI_FN_CPU_ON		KVM_PSCI_FN(2)
-#define KVM_PSCI_FN_MIGRATE		KVM_PSCI_FN(3)
-
-#define KVM_PSCI_RET_SUCCESS		PSCI_RET_SUCCESS
-#define KVM_PSCI_RET_NI			PSCI_RET_NOT_SUPPORTED
-#define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
-#define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
-
-#endif /* __ARM_KVM_H__ */
diff --git a/arm/aarch32/include/kvm/barrier.h b/arm/aarch32/include/kvm/barrier.h
deleted file mode 100644
index 94913a9..0000000
--- a/arm/aarch32/include/kvm/barrier.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef KVM__KVM_BARRIER_H
-#define KVM__KVM_BARRIER_H
-
-#define dmb()	asm volatile ("dmb" : : : "memory")
-
-#define mb()	dmb()
-#define rmb()	dmb()
-#define wmb()	dmb()
-
-#endif /* KVM__KVM_BARRIER_H */
diff --git a/arm/aarch32/include/kvm/fdt-arch.h b/arm/aarch32/include/kvm/fdt-arch.h
deleted file mode 100644
index e448bf1..0000000
--- a/arm/aarch32/include/kvm/fdt-arch.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef KVM__KVM_FDT_H
-#define KVM__KVM_FDT_H
-
-#include "arm-common/fdt-arch.h"
-
-#endif /* KVM__KVM_FDT_H */
diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
deleted file mode 100644
index 0333cf4..0000000
--- a/arm/aarch32/include/kvm/kvm-arch.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef KVM__KVM_ARCH_H
-#define KVM__KVM_ARCH_H
-
-#include <linux/sizes.h>
-
-#define kvm__arch_get_kern_offset(...)		0x8000
-#define kvm__arch_get_kernel_size(...)		0
-#define kvm__arch_get_payload_region_size(...)	SZ_256M
-
-struct kvm;
-static inline void kvm__arch_read_kernel_header(struct kvm *kvm, int fd) {}
-static inline void kvm__arch_enable_mte(struct kvm *kvm) {}
-
-#define MAX_PAGE_SIZE	SZ_4K
-
-#include "arm-common/kvm-arch.h"
-
-#endif /* KVM__KVM_ARCH_H */
diff --git a/arm/aarch32/include/kvm/kvm-config-arch.h b/arm/aarch32/include/kvm/kvm-config-arch.h
deleted file mode 100644
index acf0d23..0000000
--- a/arm/aarch32/include/kvm/kvm-config-arch.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef KVM__KVM_CONFIG_ARCH_H
-#define KVM__KVM_CONFIG_ARCH_H
-
-#define ARM_OPT_ARCH_RUN(...)
-
-#include "arm-common/kvm-config-arch.h"
-
-#endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
deleted file mode 100644
index fd0b387..0000000
--- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
+++ /dev/null
@@ -1,24 +0,0 @@
-#ifndef KVM__KVM_CPU_ARCH_H
-#define KVM__KVM_CPU_ARCH_H
-
-#include "kvm/kvm.h"
-
-#include "arm-common/kvm-cpu-arch.h"
-
-#define ARM_MPIDR_HWID_BITMASK	0xFFFFFF
-#define ARM_CPU_ID		0, 0, 0
-#define ARM_CPU_ID_MPIDR	5
-
-static inline void kvm_cpu__select_features(struct kvm *kvm,
-					    struct kvm_vcpu_init *init) { }
-static inline int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
-{
-	return 0;
-}
-
-static inline int kvm_cpu__teardown_pvtime(struct kvm *kvm)
-{
-	return 0;
-}
-
-#endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch32/kvm-cpu.c b/arm/aarch32/kvm-cpu.c
deleted file mode 100644
index 95fb1da..0000000
--- a/arm/aarch32/kvm-cpu.c
+++ /dev/null
@@ -1,132 +0,0 @@
-#include "kvm/kvm-cpu.h"
-#include "kvm/kvm.h"
-#include "kvm/virtio.h"
-
-#include <asm/ptrace.h>
-
-#define ARM_CORE_REG(x)	(KVM_REG_ARM | KVM_REG_SIZE_U32 | KVM_REG_ARM_CORE | \
-			 KVM_REG_ARM_CORE_REG(x))
-
-unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu)
-{
-	struct kvm_one_reg reg;
-	u32 mpidr;
-
-	reg.id = ARM_CP15_REG32(ARM_CPU_ID, ARM_CPU_ID_MPIDR);
-	reg.addr = (u64)(unsigned long)&mpidr;
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (get_mpidr vcpu%ld", vcpu->cpu_id);
-
-	return mpidr;
-}
-
-void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
-{
-	struct kvm *kvm	= vcpu->kvm;
-	struct kvm_one_reg reg;
-	u32 data;
-
-	/* Who said future-proofing was a good idea? */
-	reg.addr = (u64)(unsigned long)&data;
-
-	/* cpsr = IRQs/FIQs masked */
-	data	= PSR_I_BIT | PSR_F_BIT | SVC_MODE;
-	reg.id	= ARM_CORE_REG(usr_regs.ARM_cpsr);
-	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
-		die_perror("KVM_SET_ONE_REG failed (cpsr)");
-
-	/* Secondary cores are stopped awaiting PSCI wakeup */
-	if (vcpu->cpu_id != 0)
-		return;
-
-	/* r0 = 0 */
-	data	= 0;
-	reg.id	= ARM_CORE_REG(usr_regs.ARM_r0);
-	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
-		die_perror("KVM_SET_ONE_REG failed (r0)");
-
-	/* r1 = machine type (-1) */
-	data	= -1;
-	reg.id	= ARM_CORE_REG(usr_regs.ARM_r1);
-	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
-		die_perror("KVM_SET_ONE_REG failed (r1)");
-
-	/* r2 = physical address of the device tree blob */
-	data	= kvm->arch.dtb_guest_start;
-	reg.id	= ARM_CORE_REG(usr_regs.ARM_r2);
-	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
-		die_perror("KVM_SET_ONE_REG failed (r2)");
-
-	/* pc = start of kernel image */
-	data	= kvm->arch.kern_guest_start;
-	reg.id	= ARM_CORE_REG(usr_regs.ARM_pc);
-	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
-		die_perror("KVM_SET_ONE_REG failed (pc)");
-}
-
-int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
-{
-	struct kvm_one_reg reg;
-	u32 data;
-
-	reg.id = ARM_CORE_REG(usr_regs.ARM_cpsr);
-	reg.addr = (u64)(unsigned long)&data;
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (cpsr)");
-
-	return (data & PSR_E_BIT) ? VIRTIO_ENDIAN_BE : VIRTIO_ENDIAN_LE;
-}
-
-void kvm_cpu__show_code(struct kvm_cpu *vcpu)
-{
-	struct kvm_one_reg reg;
-	u32 data;
-	int debug_fd = kvm_cpu__get_debug_fd();
-
-	reg.addr = (u64)(unsigned long)&data;
-
-	dprintf(debug_fd, "\n*pc:\n");
-	reg.id = ARM_CORE_REG(usr_regs.ARM_pc);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (show_code @ PC)");
-
-	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
-
-	dprintf(debug_fd, "\n*lr (svc):\n");
-	reg.id = ARM_CORE_REG(svc_regs[1]);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (show_code @ LR_svc)");
-	data &= ~0x1;
-
-	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
-}
-
-void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
-{
-	struct kvm_one_reg reg;
-	u32 data;
-	int debug_fd = kvm_cpu__get_debug_fd();
-
-	reg.addr	= (u64)(unsigned long)&data;
-	dprintf(debug_fd, "\n Registers:\n");
-
-	reg.id		= ARM_CORE_REG(usr_regs.ARM_pc);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (pc)");
-	dprintf(debug_fd, " PC:    0x%x\n", data);
-
-	reg.id		= ARM_CORE_REG(usr_regs.ARM_cpsr);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (cpsr)");
-	dprintf(debug_fd, " CPSR:  0x%x\n", data);
-
-	reg.id		= ARM_CORE_REG(svc_regs[0]);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (SP_svc)");
-	dprintf(debug_fd, " SP_svc:  0x%x\n", data);
-
-	reg.id		= ARM_CORE_REG(svc_regs[1]);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (LR_svc)");
-	dprintf(debug_fd, " LR_svc:  0x%x\n", data);
-}
diff --git a/arm/aarch32/kvm.c b/arm/aarch32/kvm.c
deleted file mode 100644
index 768a56b..0000000
--- a/arm/aarch32/kvm.c
+++ /dev/null
@@ -1,14 +0,0 @@
-#include "kvm/kvm.h"
-
-void kvm__arch_validate_cfg(struct kvm *kvm)
-{
-	if (kvm->cfg.ram_size > ARM_LOMAP_MAX_MEMORY) {
-		die("RAM size 0x%llx exceeds maximum allowed 0x%llx",
-		    kvm->cfg.ram_size, ARM_LOMAP_MAX_MEMORY);
-	}
-}
-
-u64 kvm__arch_default_ram_address(void)
-{
-	return ARM_MEMORY_AREA;
-}
diff --git a/builtin-run.c b/builtin-run.c
index 4b9a391..81f255f 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -182,7 +182,7 @@ static int loglevel_parser(const struct option *opt, const char *arg, int unset)
 	" in megabytes (M)"
 #endif
 
-#if defined(CONFIG_ARM) || defined(CONFIG_ARM64) || defined(CONFIG_RISCV)
+#if defined(CONFIG_ARM64) || defined(CONFIG_RISCV)
 #define VIRTIO_TRANS_OPT_HELP_SHORT    "[pci|pci-legacy|mmio|mmio-legacy]"
 #else
 #define VIRTIO_TRANS_OPT_HELP_SHORT    "[pci|pci-legacy]"
diff --git a/hw/cfi_flash.c b/hw/cfi_flash.c
index 7faecdf..b68d9e0 100644
--- a/hw/cfi_flash.c
+++ b/hw/cfi_flash.c
@@ -443,7 +443,7 @@ static void cfi_flash_write(struct cfi_flash_device *sfdev, u16 command,
  * If we are in ARRAY_READ mode, we can map the flash array directly
  * into the guest, just as read-only. This greatly improves read
  * performance, and avoids problems with exits due to accesses from
- * load instructions without syndrome information (on ARM).
+ * load instructions without syndrome information (on arm64).
  * Also it could allow code to be executed XIP in there.
  */
 static int map_flash_memory(struct kvm *kvm, struct cfi_flash_device *sfdev)
diff --git a/hw/rtc.c b/hw/rtc.c
index da696e1..e3523a1 100644
--- a/hw/rtc.c
+++ b/hw/rtc.c
@@ -6,7 +6,7 @@
 
 #include <time.h>
 
-#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
+#if defined(CONFIG_ARM64)
 #define RTC_BUS_TYPE		DEVICE_BUS_MMIO
 #define RTC_BASE_ADDRESS	ARM_RTC_MMIO_BASE
 #elif defined(CONFIG_RISCV)
diff --git a/hw/serial.c b/hw/serial.c
index b6263a0..68e6186 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -13,7 +13,7 @@
 
 #include <pthread.h>
 
-#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
+#if defined(CONFIG_ARM64)
 #define serial_iobase(nr)	(ARM_UART_MMIO_BASE + (nr) * 0x1000)
 #define serial_irq(nr)		(32 + (nr))
 #define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
diff --git a/virtio/core.c b/virtio/core.c
index b77e987..50c9ddd 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -31,7 +31,7 @@ int virtio_transport_parser(const struct option *opt, const char *arg, int unset
 			*type = VIRTIO_PCI;
 		} else if (!strcmp(arg, "pci-legacy")) {
 			*type = VIRTIO_PCI_LEGACY;
-#if defined(CONFIG_ARM) || defined(CONFIG_ARM64) || defined(CONFIG_RISCV)
+#if defined(CONFIG_ARM64) || defined(CONFIG_RISCV)
 		} else if (!strcmp(arg, "mmio")) {
 			*type = VIRTIO_MMIO;
 		} else if (!strcmp(arg, "mmio-legacy")) {
-- 
2.39.5


