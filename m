Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1972C4CB7B2
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiCCH2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiCCH2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:11 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F533A70A
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292445; x=1677828445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C7MaZPwrtSUd56gxI3d1JMTZIsW8wktBIoCkdfZMe94=;
  b=A23kT/96ztvHNT2pAw3zbhzvspBAD3ik8Q0SYqvwzSBta8K3c3j8yYm8
   jZmg4TxAbL9kfvCyFG4xZ8/zAdc0gUfzBNf5Vrq3gLhyf1rex0uphK1sf
   8g5/9ONYRwURFMyzqSEtjEqgHr4IfcrSMDtOwkuPxp04Yj9Yt+I81gCLU
   +nVEmkArH47STnN7KjqjRWDbrutHT0eKwoYVi3otkedMz8Pac6p1lMDLO
   QNyCP39b0OdR9LVdOtssK0CypRjOvUABYa/ccQ0TTpAnZ7efXXHwEw4WS
   wEyHrXiawClKy7JdOge9nBcQ+4Gkf9go6BebvK21gHU8y49JMVfZZFHb8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="314317841"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="314317841"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:24 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631510"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:22 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 03/17] x86 TDX: Bypass APIC and enable x2APIC directly
Date:   Thu,  3 Mar 2022 15:18:53 +0800
Message-Id: <20220303071907.650203-4-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to TDX Architecture Specification, 9.8 Interrupt Handling
and APIC Virtualization:
1. Guest TDs must use virtualized x2APIC mode. xAPIC mode(using memory
mapped APIC access) is not allowed.
2. Guest TDs attempts to RDMSR or WRMSR the IA32_APIC_BASE MSR cause a
VE to the guest TD. The guest TD cannot disable the APIC.

Bypass xAPIC initialization and enable x2APIC directly. Set software
enable bit in x2APIC initializaion.

Use uid/apicid mapping to get apicid in setup_tss(). Initially I enabled
x2APIC early so apic_id() could be used. But that brings issue for
multiprocessor support as reading APIC_ID in AP triggers #VE and require
gdt/tss/idt to be initialized early, so setup_gdt_tss() early.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/x86/apic.c  |  4 ++++
 lib/x86/setup.c | 10 +++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index da8f30134b22..84bfe98c58ff 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -147,6 +147,10 @@ int enable_x2apic(void)
         asm ("rdmsr" : "=a"(a), "=d"(d) : "c"(MSR_IA32_APICBASE));
         a |= 1 << 10;
         asm ("wrmsr" : : "a"(a), "d"(d), "c"(MSR_IA32_APICBASE));
+
+        /* software APIC enabled bit is cleared after reset in TD-guest */
+        x2apic_write(APIC_SPIV, 0x1ff);
+
         apic_ops = &x2apic_ops;
         return 1;
     } else {
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index fbcd188ebb8f..e834fdfd290c 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -108,8 +108,9 @@ unsigned long setup_tss(u8 *stacktop)
 {
 	u32 id;
 	tss64_t *tss_entry;
+	static u32 cpus = 0;
 
-	id = apic_id();
+	id = is_tdx_guest() ? id_map[cpus++] : apic_id();
 
 	/* Runtime address of current TSS */
 	tss_entry = &tss[id];
@@ -327,12 +328,15 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 		return status;
 	}
 
-	reset_apic();
+	/* xAPIC mode isn't allowed in TDX */
+	if (!is_tdx_guest())
+		reset_apic();
 	setup_gdt_tss();
 	setup_idt();
 	load_idt();
 	mask_pic_interrupts();
-	enable_apic();
+	if (!is_tdx_guest())
+		enable_apic();
 	enable_x2apic();
 	smp_init();
 	setup_page_table();
-- 
2.25.1

