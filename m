Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55BE9185892
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 03:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbgCOCNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 22:13:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:41896 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727751AbgCOCNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 22:13:38 -0400
IronPort-SDR: qPqE0DsQzM48T3slRjEdVhjYWsJlNRUwp+vrd0E/xa7qe6TZJZRWNsKFZh6+roKkJUEB2dAiww
 BA5EupNJTUYQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 00:52:08 -0700
IronPort-SDR: W+uTITCYwRT4BUq7itpYFcStZgrU00B48B5pMT0zv7x7LiZwh44JOXWVD7LE56tMfqsvI9Mcno
 mPiCzBtgzs4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,551,1574150400"; 
   d="scan'208";a="416537597"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2020 00:52:04 -0700
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
Subject: [PATCH v4 05/10] x86/split_lock: Add and export several functions for KVM
Date:   Sat, 14 Mar 2020 15:34:09 +0800
Message-Id: <20200314073414.184213-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200314073414.184213-1-xiaoyao.li@intel.com>
References: <20200314073414.184213-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM will use split_lock_detect_disabled() and split_lock_detect_on()
in vmx_vcpu_run() to check whether split lock detect can be exposed to
guest and whether host has turned it on. Make them static inline to
avoid the extra CALL+RET in that path.

sld_msr_set() will be used when switching from/to guest.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  | 23 +++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c | 17 ++++++++---------
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index ff567afa6ee1..2e17315b1fed 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -41,15 +41,38 @@ unsigned int x86_family(unsigned int sig);
 unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
 #ifdef CONFIG_CPU_SUP_INTEL
+enum split_lock_detect_state {
+	sld_not_exist = 0,
+	sld_disable,
+	sld_kvm_only,
+	sld_warn,
+	sld_fatal,
+};
+extern enum split_lock_detect_state sld_state;
+
+static inline bool split_lock_detect_on(void)
+{
+	return (sld_state == sld_warn) || (sld_state == sld_fatal);
+}
+
+static inline bool split_lock_detect_disabled(void)
+{
+	return sld_state == sld_disable;
+}
+
 extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
 extern void switch_to_sld(unsigned long tifn);
 extern bool handle_user_split_lock(unsigned long ip);
+extern void sld_msr_set(bool on);
 #else
+static inline bool split_lock_detect_on(void) { return false; }
+static inline bool split_lock_detect_disabled(void) { return true; }
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
 static inline void switch_to_sld(unsigned long tifn) {}
 static inline bool handle_user_split_lock(unsigned long ip)
 {
 	return false;
 }
+static inline void sld_msr_set(bool on) {}
 #endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index c401d174c8db..8bfe8b07e06e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -33,19 +33,12 @@
 #include <asm/apic.h>
 #endif
 
-enum split_lock_detect_state {
-	sld_not_exist = 0,
-	sld_disable,
-	sld_kvm_only,
-	sld_warn,
-	sld_fatal,
-};
-
 /*
  * split_lock_setup() will switch this to sld_warn on systems that support
  * split lock detect, unless there is a command line override.
  */
-static enum split_lock_detect_state sld_state = sld_not_exist;
+enum split_lock_detect_state sld_state = sld_not_exist;
+EXPORT_SYMBOL_GPL(sld_state);
 
 /*
  * Processors which have self-snooping capability can handle conflicting
@@ -1121,6 +1114,12 @@ bool handle_user_split_lock(unsigned long ip)
 }
 EXPORT_SYMBOL_GPL(handle_user_split_lock);
 
+void sld_msr_set(bool on)
+{
+	__sld_msr_set(on);
+}
+EXPORT_SYMBOL_GPL(sld_msr_set);
+
 /*
  * This function is called only when switching between tasks with
  * different split-lock detection modes. It sets the MSR for the
-- 
2.20.1

