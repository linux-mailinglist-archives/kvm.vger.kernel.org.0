Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8F519C696
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 17:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389689AbgDBP5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 11:57:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:50591 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389318AbgDBP4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 11:56:50 -0400
IronPort-SDR: YfTEspLrUd9NC6Y5bg0S6asn26YdGedv+WaFPQPTI5YW2FFP75kA3l6iWiNGeN/qhc081Y6ckr
 l/+pXrycsejA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2020 08:56:49 -0700
IronPort-SDR: hOmnY10zsClqRvcXjfjp1LY7mswTggcs1bi9KCHgPjwwUa+iuvtVhFNa1fsTtWR6WUvHFiUNKF
 UBNwd/7pGtcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,336,1580803200"; 
   d="scan'208";a="396413085"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 02 Apr 2020 08:56:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86/split_lock: Refactor and export handle_user_split_lock() for KVM
Date:   Thu,  2 Apr 2020 08:55:53 -0700
Message-Id: <20200402155554.27705-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200402155554.27705-1-sean.j.christopherson@intel.com>
References: <20200402124205.334622628@linutronix.de>
 <20200402155554.27705-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

In the future, KVM will use handle_user_split_lock() to handle #AC
caused by split lock in guest. Due to the fact that KVM doesn't have
a @regs context and will pre-check EFLAGS.AC, move the EFLAGS.AC check
to do_alignment_check().

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/cpu.h  | 4 ++--
 arch/x86/kernel/cpu/intel.c | 7 ++++---
 arch/x86/kernel/traps.c     | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index ff6f3ca649b3..ff567afa6ee1 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -43,11 +43,11 @@ unsigned int x86_stepping(unsigned int sig);
 #ifdef CONFIG_CPU_SUP_INTEL
 extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
 extern void switch_to_sld(unsigned long tifn);
-extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
+extern bool handle_user_split_lock(unsigned long ip);
 #else
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
 static inline void switch_to_sld(unsigned long tifn) {}
-static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
+static inline bool handle_user_split_lock(unsigned long ip)
 {
 	return false;
 }
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 9a26e972cdea..7688f51aabdb 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1066,13 +1066,13 @@ static void split_lock_init(void)
 	split_lock_verify_msr(sld_state != sld_off);
 }
 
-bool handle_user_split_lock(struct pt_regs *regs, long error_code)
+bool handle_user_split_lock(unsigned long ip)
 {
-	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
+	if (sld_state == sld_fatal)
 		return false;
 
 	pr_warn_ratelimited("#AC: %s/%d took a split_lock trap at address: 0x%lx\n",
-			    current->comm, current->pid, regs->ip);
+			    current->comm, current->pid, ip);
 
 	/*
 	 * Disable the split lock detection for this task so it can make
@@ -1083,6 +1083,7 @@ bool handle_user_split_lock(struct pt_regs *regs, long error_code)
 	set_tsk_thread_flag(current, TIF_SLD);
 	return true;
 }
+EXPORT_SYMBOL_GPL(handle_user_split_lock);
 
 /*
  * This function is called only when switching between tasks with
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d54cffdc7cac..55902c5bf0aa 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -304,7 +304,7 @@ dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
 
 	local_irq_enable();
 
-	if (handle_user_split_lock(regs, error_code))
+	if (!(regs->flags & X86_EFLAGS_AC) && handle_user_split_lock(regs->ip))
 		return;
 
 	do_trap(X86_TRAP_AC, SIGBUS, "alignment check", regs,
-- 
2.24.1

