Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271AA24952F
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 08:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgHSGrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 02:47:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:36140 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgHSGr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 02:47:28 -0400
IronPort-SDR: cceApgqYGCexDYCoIgKbXgh20dwTjeqVTGKKi/Ms2T48qulDAyde7mNGyQn8i1JTGL514v1wMq
 ua2E48XM2uzg==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142873185"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="142873185"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 23:47:23 -0700
IronPort-SDR: fbgy9USyRkF4iSkmgdfJnq9ehm1tczuo1AQZOrQIPj/Tj1GiAjiwnt7W10pa+H1GQOGJx+2qPK
 aKUj37RIj+EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="310679279"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2020 23:47:19 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v10 3/9] x86/split_lock: Introduce flag X86_FEATURE_SLD_FATAL and drop sld_state
Date:   Wed, 19 Aug 2020 14:47:01 +0800
Message-Id: <20200819064707.1033569-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200819064707.1033569-1-xiaoyao.li@intel.com>
References: <20200819064707.1033569-1-xiaoyao.li@intel.com>
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
index 2901d5df4366..caf9f4e3e876 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -288,6 +288,7 @@
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
+#define X86_FEATURE_SLD_FATAL		(11*32+ 7) /* split lock detection in fatal mode */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5dab842ba7e1..06de03974e66 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -42,12 +42,6 @@ enum split_lock_detect_state {
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
@@ -1058,8 +1052,9 @@ static void __init split_lock_setup(void)
 		return;
 	}
 
-	sld_state = state;
 	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
+	if (state == sld_fatal)
+		setup_force_cpu_cap(X86_FEATURE_SLD_FATAL);
 }
 
 /*
@@ -1080,7 +1075,7 @@ static void sld_update_msr(bool on)
 static void split_lock_init(void)
 {
 	if (cpu_model_supports_sld)
-		split_lock_verify_msr(sld_state != sld_off);
+		split_lock_verify_msr(boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT));
 }
 
 static void split_lock_warn(unsigned long ip)
@@ -1099,7 +1094,7 @@ static void split_lock_warn(unsigned long ip)
 
 bool handle_guest_split_lock(unsigned long ip)
 {
-	if (sld_state == sld_warn) {
+	if (!boot_cpu_has(X86_FEATURE_SLD_FATAL)) {
 		split_lock_warn(ip);
 		return true;
 	}
@@ -1116,7 +1111,8 @@ EXPORT_SYMBOL_GPL(handle_guest_split_lock);
 
 bool handle_user_split_lock(struct pt_regs *regs, long error_code)
 {
-	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
+	if ((regs->flags & X86_EFLAGS_AC) ||
+	    boot_cpu_has(X86_FEATURE_SLD_FATAL))
 		return false;
 	split_lock_warn(regs->ip);
 	return true;
-- 
2.18.4

