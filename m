Return-Path: <kvm+bounces-4677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F480816715
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:11:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D11B5282BA6
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30403107B7;
	Mon, 18 Dec 2023 07:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KUk8YUtv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AF91079A
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883444; x=1734419444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rRqcyZr82B9E94/pSwiA0CDahJjHnPHqq64b0Pw4OT8=;
  b=KUk8YUtvkBZmSiRTmGiZvRm2tXePLtQLMWgdA3Aoe2/8+ZiXoUQxZpYF
   2zagPuqMIMZ0Fcwnjiz/OeeKiccLPZ87nyOQecfaxN5CtPr1ZS/1zLx6k
   qvEdYFlYBlNfI4juV+pczAByV6JoPWAxcnI5X2rndpslGddNWPL9QcD7u
   2tY2LJ6nPwFbM5KIKQoAZFym9ED4sflECi4UkoXZjyZxqTOhlg/gJbQsC
   0mybXiEQBBxgirg5xZLQwHVCUTWOwe78L+2DzB4oYW3TLBfPrarVLv07A
   RCcOjerRxgpmvv7fNy9Kn3NbwInPui4A7nAUlYYeADOAXigCV+b3CF/R7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667940"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667940"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824733"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824733"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:39 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 11/18] x86 TDX: Add multi processor support
Date: Mon, 18 Dec 2023 15:22:40 +0800
Message-Id: <20231218072247.2573516-12-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

In TD-guest, multiprocessor support is different from normal guest.

In normal guest, BSP send startup IPI to all APs to trigger APs starting
from 16bit real mode.

While in TD-guest, TDVF initializes APs into 64bit mode before pass to
OS/bootloader. OS enumerates uid/apicid mapping information through MADT
table and wake up APs one by one through MP wakeup mechanism. So the
entry code for APs is 64bit.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-11-zhenzhong.duan@intel.com
Co-developed-by: Qian Wen <qian.wen@intel.com>
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/x86/setup.c      | 16 +++++++++++----
 lib/x86/smp.c        | 26 +++++++++++++++++++++++++
 lib/x86/smp.h        |  2 ++
 x86/efi/efistart64.S | 46 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 406d04e3..82a563a3 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -407,17 +407,25 @@ void save_id(void)
 void ap_start64(void)
 {
 	setup_gdt_tss();
-	reset_apic();
 	load_idt();
-	save_id();
-	enable_apic();
+	if (!is_tdx_guest()) {
+		reset_apic();
+		save_id();
+		enable_apic();
+	}
 	enable_x2apic();
 	ap_online();
 }
 
+extern void tdx_ap_start64(void);
 void bsp_rest_init(void)
 {
-	bringup_aps();
+	if (!is_tdx_guest()) {
+		bringup_aps();
+	} else {
+		/* TDX uses ACPI WAKE UP mechanism to wake up APs instead of SIPI */
+		bringup_aps_acpi((u64)tdx_ap_start64);
+	}
 	enable_x2apic();
 	smp_init();
 	pmu_init();
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index e297016c..7147cf6b 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -11,6 +11,7 @@
 #include "desc.h"
 #include "alloc_page.h"
 #include "asm/page.h"
+#include "acpi.h"
 
 #define IPI_VECTOR 0x20
 
@@ -288,3 +289,28 @@ void bringup_aps(void)
 	while (_cpu_count != atomic_read(&cpu_online_count))
 		cpu_relax();
 }
+
+/* wakeup APs by sending the OS commands to ACPI mailbox. */
+efi_status_t bringup_aps_acpi(unsigned long start_ip)
+{
+	u32 i;
+	_cpu_count = fwcfg_get_nb_cpus();
+
+	/* BSP is already online */
+	set_bit(id_map[0], online_cpus);
+
+#ifdef CONFIG_EFI
+	smp_stacktop = ((u64) (&stacktop)) - PAGE_SIZE;
+#endif
+
+	for (i = 1; i < _cpu_count; i++) {
+		if (acpi_wakeup_cpu(id_map[i], start_ip, online_cpus))
+			return EFI_DEVICE_ERROR;
+		set_bit(id_map[i], online_cpus);
+	}
+
+	while (atomic_read(&cpu_online_count) != _cpu_count)
+		cpu_relax();
+
+	return EFI_SUCCESS;
+}
diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index 08a440b3..a0a6b3f6 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -6,6 +6,7 @@
 #include "libcflat.h"
 #include "atomic.h"
 #include "apic-defs.h"
+#include "efi.h"
 
 /* Address where to store the address of realmode GDT descriptor. */
 #define REALMODE_GDT_LOWMEM (PAGE_SIZE - 2)
@@ -86,6 +87,7 @@ void on_cpus(void (*function)(void *data), void *data);
 void smp_reset_apic(void);
 void bringup_aps(void);
 void ap_online(void);
+efi_status_t bringup_aps_acpi(unsigned long start_ip);
 
 extern atomic_t cpu_online_count;
 extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 3fc16016..e3add79a 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -35,6 +35,52 @@ ptl4:
 .code64
 .text
 
+.macro load_absolute_addr64, addr, reg
+	call 1f
+1:
+	popq \reg
+	addq \addr - 1b, \reg
+.endm
+
+MSR_GS_BASE = 0xc0000101
+
+.macro setup_percpu_area_64
+	lea -4096(%rsp), %rax
+	movq $0, %rdx
+	movq $MSR_GS_BASE, %rcx
+	wrmsr
+.endm
+
+.macro prepare_td
+	load_absolute_addr64 $gdt_descr, %rdx
+	lgdt (%rdx)
+
+	movq $MSR_GS_BASE, %rcx
+	rdmsr
+
+	/* Update data segments */
+	mov $0x10, %bx
+	mov %bx, %ds
+	mov %bx, %es
+	mov %bx, %fs
+	mov %bx, %gs
+	mov %bx, %ss
+
+	/* restore MSR_GS_BASE */
+	wrmsr
+.endm
+
+.globl tdx_ap_start64
+tdx_ap_start64:
+	movq $-PAGE_SIZE, %rsp
+	lock xadd %rsp, smp_stacktop(%rip)
+	setup_percpu_area_64
+	prepare_td
+	load_absolute_addr64 $ap_start64, %rdx
+	pushq $0x08
+	pushq %rdx
+	lretq
+
 .code16
 REALMODE_GDT_LOWMEM = PAGE_SIZE - 2
 
-- 
2.25.1


