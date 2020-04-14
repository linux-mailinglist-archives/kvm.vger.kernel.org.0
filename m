Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD4C1A73E6
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 08:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406130AbgDNGu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 02:50:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:58687 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406135AbgDNGuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 02:50:32 -0400
IronPort-SDR: HLywqpAtjln3ODpDTTfajLhWYAC4TFR77CZD94LVRasqz7Gq9tmuvOC11j6vn0GDosDUGxM+ee
 46kpPq0UiMBA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 23:50:31 -0700
IronPort-SDR: 1zX7xUoXY6F2Iske0khthpiXytW/LDuEgmESGtWbStn+66HlC04sNpprulO/8prq/aWE56W9/F
 BNhe8cZywDPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="277158378"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.132])
  by fmsmga004.fm.intel.com with ESMTP; 13 Apr 2020 23:50:29 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v8 3/4] x86/split_lock: Export sld_update_msr() and sld_state
Date:   Tue, 14 Apr 2020 14:31:28 +0800
Message-Id: <20200414063129.133630-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414063129.133630-1-xiaoyao.li@intel.com>
References: <20200414063129.133630-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sld_update_msr() and sld_state will be used in KVM in future patch
to add virtualization support of split lock detection.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  | 12 ++++++++++++
 arch/x86/kernel/cpu/intel.c | 13 +++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index dd17c2da1af5..6c6528b3153e 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -40,12 +40,23 @@ int mwait_usable(const struct cpuinfo_x86 *);
 unsigned int x86_family(unsigned int sig);
 unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
+enum split_lock_detect_state {
+	sld_off = 0,
+	sld_warn,
+	sld_fatal,
+};
+
 #ifdef CONFIG_CPU_SUP_INTEL
+extern enum split_lock_detect_state sld_state __ro_after_init;
+
 extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
 extern void switch_to_sld(unsigned long tifn);
 extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
 extern bool handle_guest_split_lock(unsigned long ip);
+extern void sld_update_msr(bool on);
 #else
+#define sld_state sld_off
+
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
 static inline void switch_to_sld(unsigned long tifn) {}
 static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
@@ -57,5 +68,6 @@ static inline bool handle_guest_split_lock(unsigned long ip)
 {
 	return false;
 }
+static inline void sld_update_msr(bool on) {}
 #endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index bf08d4508ecb..80d1c0c93c08 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -34,18 +34,14 @@
 #include <asm/apic.h>
 #endif
 
-enum split_lock_detect_state {
-	sld_off = 0,
-	sld_warn,
-	sld_fatal,
-};
-
 /*
  * Default to sld_off because most systems do not support split lock detection
  * split_lock_setup() will switch this to sld_warn on systems that support
  * split lock detect, unless there is a command line override.
  */
-static enum split_lock_detect_state sld_state __ro_after_init = sld_off;
+enum split_lock_detect_state sld_state __ro_after_init = sld_off;
+EXPORT_SYMBOL_GPL(sld_state);
+
 static u64 msr_test_ctrl_cache __ro_after_init;
 
 /*
@@ -1052,7 +1048,7 @@ static void __init split_lock_setup(void)
  * is not implemented as one thread could undo the setting of the other
  * thread immediately after dropping the lock anyway.
  */
-static void sld_update_msr(bool on)
+void sld_update_msr(bool on)
 {
 	u64 test_ctrl_val = msr_test_ctrl_cache;
 
@@ -1061,6 +1057,7 @@ static void sld_update_msr(bool on)
 
 	wrmsrl(MSR_TEST_CTRL, test_ctrl_val);
 }
+EXPORT_SYMBOL_GPL(sld_update_msr);
 
 static void split_lock_init(void)
 {
-- 
2.20.1

