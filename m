Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9C9153F2B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 08:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgBFHJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 02:09:24 -0500
Received: from mga04.intel.com ([192.55.52.120]:56103 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgBFHJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 02:09:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 23:09:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,408,1574150400"; 
   d="scan'208";a="231957189"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by orsmga003.jf.intel.com with ESMTP; 05 Feb 2020 23:09:20 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com
Cc:     peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 1/8] x86/split_lock: Export handle_user_split_lock()
Date:   Thu,  6 Feb 2020 15:04:05 +0800
Message-Id: <20200206070412.17400-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206070412.17400-1-xiaoyao.li@intel.com>
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the EFLAGS.AC check to do_alignment_check() so that
handle_user_split_lock() can be used by KVM in the future to handle #AC
caused by split lock in guest.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
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
index db3e745e5d47..2b3874a96bd4 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1058,13 +1058,13 @@ static void split_lock_init(void)
 	sld_state = sld_off;
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
@@ -1075,6 +1075,7 @@ bool handle_user_split_lock(struct pt_regs *regs, long error_code)
 	set_tsk_thread_flag(current, TIF_SLD);
 	return true;
 }
+EXPORT_SYMBOL_GPL(handle_user_split_lock);
 
 /*
  * This function is called only when switching between tasks with
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 0ef5befaed7d..407ff9be610f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -304,7 +304,7 @@ dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
 
 	local_irq_enable();
 
-	if (handle_user_split_lock(regs, error_code))
+	if (!(regs->flags & X86_EFLAGS_AC) && handle_user_split_lock(regs->ip))
 		return;
 
 	do_trap(X86_TRAP_AC, SIGBUS, "alignment check", regs,
-- 
2.23.0

