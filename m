Return-Path: <kvm+bounces-52027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67610AFFF2E
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 12:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26C741C26C3F
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 10:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81062DBF45;
	Thu, 10 Jul 2025 10:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d8o5C123"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7602DC32D
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 10:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752143137; cv=none; b=gx80KkuVDAMf8cIK1B7qN0hND/gBwQAFmTmWdqzmHus63cFa1+lEbYty+H+/TVQZfHyqw53qqJE9ZhKZ9+o88/FpsFQvzlhevMZa6aYMGHSBnKFxrqAU4qPnmPhnkDHrOwabn5zwjD7w/nliHnLAhO+HIHrHw2epYlNHxl9+eDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752143137; c=relaxed/simple;
	bh=NpChVXLz8XEfRZri8L+GwTlgyB0kP4u7xt9aa235MUc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n098fCjqyZLlAamKYpNX20aDWwtBCT9/ZxPARR4+U330RgEpR/gYJehTF/xB9I82LLYh8iAnmIiKrprlPmKntg5lEfLq497CrqAiSXmeDX/CnC9NtOtnDJ8g58sber7NST3SGIsJSyhPpDF9oaxpXyeC3LQ82mHf+8PKWlFvX2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d8o5C123; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752143134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S7T+HxZcCz41wajolk6kG3A2WGMHE5BRPocylx45st4=;
	b=d8o5C123C/rkIUaYbU+cTLNmEoDyETsO5ereBCKQ5jKOfgV/D2kuaFCtasTuI3/rJkMSJQ
	5I+bhp4XNnspRgMSF08/ykFofe1KHa6zBjAQDLYy5hYZ8a2FYzkEk20nXNRlDsLBb+F+/Q
	9L1REd6eNLrZ6bvKktIPft/gi6cXlbA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-zazAdKAdPNq6gPwMulh7eA-1; Thu,
 10 Jul 2025 06:25:31 -0400
X-MC-Unique: zazAdKAdPNq6gPwMulh7eA-1
X-Mimecast-MFC-AGG-ID: zazAdKAdPNq6gPwMulh7eA_1752143128
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B15DA19560AD;
	Thu, 10 Jul 2025 10:25:27 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.72])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BC56F19373D8;
	Thu, 10 Jul 2025 10:25:20 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Russell King <linux@armlinux.org.uk>,
	Marc Zyngier <maz@kernel.org>
Cc: linux-perf-users@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [RFC PATCH] tools: Remove obsolete 32-bit arm kvm.h header file
Date: Thu, 10 Jul 2025 12:25:19 +0200
Message-ID: <20250710102519.143429-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Thomas Huth <thuth@redhat.com>

The original 32-bit arm kvm.h header has been removed in commit
541ad0150ca4a ("arm: Remove 32bit KVM host support"), so we can
remove the copy in the tools folder now, too.

Fixes: 541ad0150ca4a ("arm: Remove 32bit KVM host support")
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Note: Marked as RFC since I currently don't have a 32-bit arm
       build environment around, so this has not been compile-tested.

 tools/arch/arm/include/uapi/asm/kvm.h | 315 --------------------------
 tools/perf/check-headers.sh           |   1 -
 2 files changed, 316 deletions(-)
 delete mode 100644 tools/arch/arm/include/uapi/asm/kvm.h

diff --git a/tools/arch/arm/include/uapi/asm/kvm.h b/tools/arch/arm/include/uapi/asm/kvm.h
deleted file mode 100644
index d5dd969028175..0000000000000
--- a/tools/arch/arm/include/uapi/asm/kvm.h
+++ /dev/null
@@ -1,315 +0,0 @@
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
-		__u8 ext_dabt_pending;
-		/* Align it to 8 bytes */
-		__u8 pad[5];
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
-#define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ	9
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
-#define KVM_ARM_IRQ_VCPU2_SHIFT		28
-#define KVM_ARM_IRQ_VCPU2_MASK		0xf
-#define KVM_ARM_IRQ_TYPE_SHIFT		24
-#define KVM_ARM_IRQ_TYPE_MASK		0xf
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
diff --git a/tools/perf/check-headers.sh b/tools/perf/check-headers.sh
index 8085e4d1d8af8..1fd995b6460bc 100755
--- a/tools/perf/check-headers.sh
+++ b/tools/perf/check-headers.sh
@@ -49,7 +49,6 @@ FILES=(
   "arch/s390/include/uapi/asm/kvm.h"
   "arch/s390/include/uapi/asm/kvm_perf.h"
   "arch/s390/include/uapi/asm/sie.h"
-  "arch/arm/include/uapi/asm/kvm.h"
   "arch/arm64/include/uapi/asm/kvm.h"
   "arch/arm64/include/uapi/asm/unistd.h"
   "arch/alpha/include/uapi/asm/errno.h"
-- 
2.50.0


