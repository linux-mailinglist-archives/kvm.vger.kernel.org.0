Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB761CBCBD
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 05:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgEIDDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 23:03:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:55091 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbgEIDDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 23:03:52 -0400
IronPort-SDR: zL+JbQmzfdTfKk8nn3Ddi3jL6g9MXXYeVvnQbPQpr47Icd6XmYI0Ip5CziBlIA24iYJRpZGGmZ
 KJ7hoTfNFxTA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 20:03:48 -0700
IronPort-SDR: 8OhJwXpbyoeBle1+jQMFkSwIHy6Qoo5RYA1KJuUli6gd+rwJQNqP2nglitEJHCVI0wXGjDiCOf
 BaWfbn/wzMcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,370,1583222400"; 
   d="scan'208";a="408311046"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga004.jf.intel.com with ESMTP; 08 May 2020 20:03:44 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 3/8] x86/split_lock: Introduce flag X86_FEATURE_SLD_FATAL and drop sld_state
Date:   Sat,  9 May 2020 19:05:37 +0800
Message-Id: <20200509110542.8159-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200509110542.8159-1-xiaoyao.li@intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a synthetic feature flag X86_FEATURE_SLD_FATAL, which means
kernel is in sld_fatal mode if set.

Now sld_state is not needed any more that the state of SLD can be
inferred from X86_FEATURE_SPLIT_LOCK_DETECT and X86_FEATURE_SLD_FATAL.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/intel.c        | 16 ++++++----------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index db189945e9b0..260adfc6c61a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -286,6 +286,7 @@
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
+#define X86_FEATURE_SLD_FATAL		(11*32+ 7) /* split lock detection in fatal mode */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 4602dac14dcb..93b8ccf2fa11 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -40,12 +40,6 @@ enum split_lock_detect_state {
 	sld_fatal,
 };
 
-/*
- * Default to sld_off because most systems do not support split lock detection
- * split_lock_setup() will switch this to sld_warn on systems that support
- * split lock detect, unless there is a command line override.
- */
-static enum split_lock_detect_state sld_state __ro_after_init = sld_off;
 static u64 msr_test_ctrl_cache __ro_after_init;
 
 /*
@@ -1043,8 +1037,9 @@ static void __init split_lock_setup(void)
 		return;
 	}
 
-	sld_state = state;
 	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
+	if (state == sld_fatal)
+		setup_force_cpu_cap(X86_FEATURE_SLD_FATAL);
 }
 
 /*
@@ -1064,7 +1059,7 @@ static void sld_update_msr(bool on)
 
 static void split_lock_init(void)
 {
-	split_lock_verify_msr(sld_state != sld_off);
+	split_lock_verify_msr(boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT));
 }
 
 static void split_lock_warn(unsigned long ip)
@@ -1083,7 +1078,7 @@ static void split_lock_warn(unsigned long ip)
 
 bool handle_guest_split_lock(unsigned long ip)
 {
-	if (sld_state == sld_warn) {
+	if (!boot_cpu_has(X86_FEATURE_SLD_FATAL)) {
 		split_lock_warn(ip);
 		return true;
 	}
@@ -1100,7 +1095,8 @@ EXPORT_SYMBOL_GPL(handle_guest_split_lock);
 
 bool handle_user_split_lock(struct pt_regs *regs, long error_code)
 {
-	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
+	if ((regs->flags & X86_EFLAGS_AC) ||
+	    boot_cpu_has(X86_FEATURE_SLD_FATAL))
 		return false;
 	split_lock_warn(regs->ip);
 	return true;
-- 
2.18.2

