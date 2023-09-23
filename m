Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A777AC007
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjIWKP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbjIWKPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:15:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B4E10C3;
        Sat, 23 Sep 2023 03:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463920; x=1726999920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kgfFMDbJiu5q1BDcTkBjlFfGWj3DWiVrEUdh+fgWCfs=;
  b=H0O7zSg5PdybzX4KB8gp+ZBCg9RyACeRGF/B1Z6MCM+97CyvlLpShiun
   vFu3n6WliTaurPp4cj7GOn+vX40BbB8O8d9JLEjAT+K+zef81AszW+LM9
   yMC7HL31mFFn7RvHZezYtiIZjNTQ497hmbOCjMgL3HW5bhwara4i7MUyZ
   8qEmGAMqAUr2YHrqH/hzJt6R5wDKZqKQiN2sQ0HX8nio3nAM7tMSGRutN
   InPTDs1KOktSNSLDvnrbFVUE9K3Ole40Abk3rOcs9xPamNokZXa7kQwn5
   NLqesP3aJruu2QA5Om5uOuyO/o993DRBPRcALi5g5+yzkdR8M2M3uhCJV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492497"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492497"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388236"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388236"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:53 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v11 35/37] x86/syscall: Split IDT syscall setup code into idt_syscall_init()
Date:   Sat, 23 Sep 2023 02:42:10 -0700
Message-Id: <20230923094212.26520-36-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230923094212.26520-1-xin3.li@intel.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because FRED uses the ring 3 FRED entrypoint for SYSCALL and SYSENTER and
ERETU is the only legit instruction to return to ring 3, there is NO need
to setup SYSCALL and SYSENTER MSRs for FRED, except the IA32_STAR MSR.

Split IDT syscall setup code into idt_syscall_init() to make it easy to
skip syscall setup code when FRED is enabled.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/cpu/common.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 20bbedbf6dcb..2ee4e7b597a3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2071,10 +2071,8 @@ static void wrmsrl_cstar(unsigned long val)
 		wrmsrl(MSR_CSTAR, val);
 }
 
-/* May not be marked __init: used by software suspend */
-void syscall_init(void)
+static inline void idt_syscall_init(void)
 {
-	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
 	wrmsrl(MSR_LSTAR, (unsigned long)entry_SYSCALL_64);
 
 	if (ia32_enabled()) {
@@ -2108,6 +2106,15 @@ void syscall_init(void)
 	       X86_EFLAGS_AC|X86_EFLAGS_ID);
 }
 
+/* May not be marked __init: used by software suspend */
+void syscall_init(void)
+{
+	/* The default user and kernel segments */
+	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
+
+	idt_syscall_init();
+}
+
 #else	/* CONFIG_X86_64 */
 
 #ifdef CONFIG_STACKPROTECTOR
-- 
2.34.1

