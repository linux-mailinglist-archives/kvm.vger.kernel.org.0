Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF381509AA
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 16:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgBCPVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 10:21:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:32939 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgBCPVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 10:21:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 07:21:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="429473347"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by fmsmga005.fm.intel.com with ESMTP; 03 Feb 2020 07:21:17 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 1/6] x86/split_lock: Add and export get_split_lock_detect_state()
Date:   Mon,  3 Feb 2020 23:16:03 +0800
Message-Id: <20200203151608.28053-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200203151608.28053-1-xiaoyao.li@intel.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

get_split_lock_detect_state() will be used by KVM module to get sld_state.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  | 12 ++++++++++++
 arch/x86/kernel/cpu/intel.c | 12 ++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index ff6f3ca649b3..167d0539e0ad 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -40,11 +40,23 @@ int mwait_usable(const struct cpuinfo_x86 *);
 unsigned int x86_family(unsigned int sig);
 unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
+
+enum split_lock_detect_state {
+	sld_off = 0,
+	sld_warn,
+	sld_fatal,
+};
+
 #ifdef CONFIG_CPU_SUP_INTEL
+extern enum split_lock_detect_state get_split_lock_detect_state(void);
 extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
 extern void switch_to_sld(unsigned long tifn);
 extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
 #else
+static inline enum split_lock_detect_state get_split_lock_detect_state(void)
+{
+	return sld_off;
+}
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
 static inline void switch_to_sld(unsigned long tifn) {}
 static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index db3e745e5d47..a810cd022db5 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -33,12 +33,6 @@
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
@@ -968,6 +962,12 @@ cpu_dev_register(intel_cpu_dev);
 #undef pr_fmt
 #define pr_fmt(fmt) "x86/split lock detection: " fmt
 
+enum split_lock_detect_state get_split_lock_detect_state(void)
+{
+	return sld_state;
+}
+EXPORT_SYMBOL_GPL(get_split_lock_detect_state);
+
 static const struct {
 	const char			*option;
 	enum split_lock_detect_state	state;
-- 
2.23.0

