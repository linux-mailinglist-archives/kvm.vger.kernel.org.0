Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD0C7185897
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 03:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgCOCOQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 22:14:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:41896 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbgCOCNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 22:13:38 -0400
IronPort-SDR: ec91g7YqAudwWfp540QIr9XBcc6G58vomOvum3iIYQCHrz8CyxpLu9CnFPaN0M5l46M4ey16uq
 IPjZD04o5JMw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 00:52:04 -0700
IronPort-SDR: +7QhIa6OG5TdA+1pLZPBQIvwnIurqmL9c+HZwZqJV7JzM6sbE3EvuEnyngT79jQWYeu8C+nlDn
 Lv43KW7SkTjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,551,1574150400"; 
   d="scan'208";a="416537579"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2020 00:52:00 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com
Cc:     peterz@infradead.org, fenghua.yu@intel.com,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 04/10] x86/split_lock: Export handle_user_split_lock()
Date:   Sat, 14 Mar 2020 15:34:08 +0800
Message-Id: <20200314073414.184213-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200314073414.184213-1-xiaoyao.li@intel.com>
References: <20200314073414.184213-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the future, KVM will use handle_user_split_lock() to handle #AC
caused by split lock in guest. Due to the fact that KVM doesn't have
a @regs context and will pre-check EFLASG.AC, move the EFLAGS.AC check
to do_alignment_check().

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
index 3eeab717a0d0..c401d174c8db 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1102,13 +1102,13 @@ static void split_lock_init(struct cpuinfo_x86 *c)
 	sld_state = sld_disable;
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
@@ -1119,6 +1119,7 @@ bool handle_user_split_lock(struct pt_regs *regs, long error_code)
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
2.20.1

