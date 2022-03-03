Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BC04CB7BE
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiCCH2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiCCH2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:42 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520CF21810
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292465; x=1677828465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IDcjAjR45CZYQPp3bmPZspXevCk8rh2UmmPvZhgnrLI=;
  b=HEOgs6TzJCnDHcBHBAeTLm9G9rLsKc4ZakfibfwtXQ4SQXzBmfWCft+r
   bCKD3gXAyooTBaSR8W1yPhWXPYcqefdHdr2HLo/z9NHTJ/xtsIfcgcerF
   C6S1WWG/UVEvruHupetvn/OIZJDnZO8NxQO4Dn5i6bEsQlhScrL4kh5NC
   oD9ALCTQneZqy/h/cNaeuNjZ1yBjbv/hBkVz0HEMEJ1m6reQ5sFSY2tVz
   gEVcbueDZ4ArLvKPNaIQ0qszgLPUZGSIYnqEHIU9se8ee1bhJoW7AK+Lt
   lpKwwtjXLDld8/CwdWO+dnAq9XeOakYx2nlIPj+FQDrj46l7pdLfXLFNa
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251176996"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251176996"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:44 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631696"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:41 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 10/17] x86 TDX: Add multi processor support
Date:   Thu,  3 Mar 2022 15:19:00 +0800
Message-Id: <20220303071907.650203-11-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In TD-guest, multiprocessor support is different from normal guest.

In normal guest, BSP send startup IPI to all APs to trigger APs
starting from 16bit real mode.

While in TD-guest, TDVF initializes APs into 64bit mode before pass
to OS/bootloader. OS enumerates uid/apicid mapping information
through MADT table and wake up APs one by one through MP wakeup
mechanism. So the entry code for APs is 64bit.

Though it is targeting TDX MP support, there are consideration about
integration with normal UEFI MP support in the future.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/x86/asm/setup.h       |  1 +
 lib/x86/setup.c           | 31 +++++++++++++++++++++++++++++++
 lib/x86/tdx.c             | 33 +++++++++++++++++++++++++++++++++
 lib/x86/tdx.h             |  2 ++
 x86/efi/crt0-efi-x86_64.S | 12 +++++++++++-
 x86/efi/efistart64.S      |  5 +++++
 6 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index c467a2e94861..5e7aa2eb4332 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -14,6 +14,7 @@ unsigned long setup_tss(u8 *stacktop);
 
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
 void setup_5level_page_table(void);
+void secondary_startup_64(void);
 #endif /* TARGET_EFI */
 #include "x86/tdx.h"
 
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 63c4dbb25064..7bf5d431f2a8 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -279,6 +279,35 @@ static void setup_gdt_tss(void)
 	load_gdt_tss(tss_offset);
 }
 
+static void setup_percpu_area(void)
+{
+	u64 rsp;
+
+	asm volatile ("mov %%rsp, %0" : "=m"(rsp) :: "memory");
+
+	/* per cpu stack size is PAGE_SIZE */
+	rsp &= ~((u64)PAGE_SIZE - 1);
+	wrmsr(MSR_GS_BASE, rsp);
+}
+
+void secondary_startup_64(void)
+{
+	setup_gdt_tss();
+	load_idt();
+	setup_percpu_area();
+	enable_x2apic();
+	tdx_ap_init();
+
+	while (1)
+		safe_halt();
+}
+
+static void aps_init(void)
+{
+	if (is_tdx_guest())
+		tdx_aps_init();
+}
+
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
@@ -332,6 +361,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 		return status;
 	}
 
+	setup_percpu_area();
 	/* xAPIC mode isn't allowed in TDX */
 	if (!is_tdx_guest())
 		reset_apic();
@@ -342,6 +372,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	if (!is_tdx_guest())
 		enable_apic();
 	enable_x2apic();
+	aps_init();
 	smp_init();
 	setup_page_table();
 
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index b74c697353d9..4bd658b95028 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -12,9 +12,14 @@
 #include "tdx.h"
 #include "errno.h"
 #include "bitops.h"
+#include "atomic.h"
+#include "fwcfg.h"
+#include "x86/acpi.h"
 #include "x86/processor.h"
 #include "x86/smp.h"
+#include "x86/apic.h"
 #include "asm/page.h"
+#include "asm/barrier.h"
 
 #define VE_IS_IO_OUT(exit_qual)		(((exit_qual) & 8) ? 0 : 1)
 #define VE_GET_IO_SIZE(exit_qual)	(((exit_qual) & 7) + 1)
@@ -541,3 +546,31 @@ efi_status_t setup_tdx(efi_bootinfo_t *efi_bootinfo)
 
 	return EFI_SUCCESS;
 }
+
+static atomic_t cpu_online_count = {1};
+extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
+extern void ap_start64(void);
+
+/* TDX uses ACPI WAKE UP mechanism to wake up APs instead of SIPI */
+efi_status_t tdx_aps_init(void)
+{
+	u32 i, total_cpus = fwcfg_get_nb_cpus();
+
+	/* BSP is already online */
+	set_bit(id_map[0], online_cpus);
+
+	for (i = 1; i < total_cpus; i++) {
+		if (acpi_wakeup_cpu(id_map[i], (u64)ap_start64))
+			return EFI_DEVICE_ERROR;
+	}
+
+	while (atomic_read(&cpu_online_count) != total_cpus)
+		cpu_relax();
+
+	return EFI_SUCCESS;
+}
+
+void tdx_ap_init(void)
+{
+	atomic_inc(&cpu_online_count);
+}
diff --git a/lib/x86/tdx.h b/lib/x86/tdx.h
index 2f938038dc45..4b75fcec7367 100644
--- a/lib/x86/tdx.h
+++ b/lib/x86/tdx.h
@@ -96,6 +96,8 @@ int tdx_hcall_gpa_intent(phys_addr_t start, phys_addr_t end,
 			 enum tdx_map_type map_type);
 bool tdx_accept_memory(phys_addr_t start, phys_addr_t end);
 efi_status_t setup_tdx(efi_bootinfo_t *efi_bootinfo);
+efi_status_t tdx_aps_init(void);
+void tdx_ap_init(void);
 
 /* Helper function used to communicate with the TDX module */
 u64 __tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
diff --git a/x86/efi/crt0-efi-x86_64.S b/x86/efi/crt0-efi-x86_64.S
index eaf165649591..f3309f6e35ef 100644
--- a/x86/efi/crt0-efi-x86_64.S
+++ b/x86/efi/crt0-efi-x86_64.S
@@ -41,6 +41,8 @@
 
 	.globl _start
 _start:
+	lea stacktop(%rip), %rsp
+	add %rsp, smp_stacktop(%rip)
 	subq $8, %rsp
 	pushq %rcx
 	pushq %rdx
@@ -61,12 +63,20 @@ _start:
 	call efi_main
 	addq $8, %rsp
 
+	.globl ap_start64
+ap_start64:
+	mov $-PAGE_SIZE, %rsp
+	lock xadd %rsp, smp_stacktop(%rip)
+	call secondary_startup_64
+
 .exit:	
   	ret
 
+	.data
+smp_stacktop:  .quad	-PAGE_SIZE
+
  	// hand-craft a dummy .reloc section so EFI knows it's a relocatable executable:
  
- 	.data
 dummy:	.long	0
 
 #define IMAGE_REL_ABSOLUTE	0
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 017abba85a68..648d047febb5 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -22,6 +22,11 @@ ptl4:
 	. = . + PAGE_SIZE
 .align PAGE_SIZE
 
+.globl stacktop
+	. = . + PAGE_SIZE * MAX_TEST_CPUS
+stacktop:
+.align PAGE_SIZE
+
 .section .init
 .code64
 .text
-- 
2.25.1

