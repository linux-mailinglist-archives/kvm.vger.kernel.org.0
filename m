Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA82153F20
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 08:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgBFHJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 02:09:35 -0500
Received: from mga04.intel.com ([192.55.52.120]:56103 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbgBFHJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 02:09:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 23:09:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,408,1574150400"; 
   d="scan'208";a="231957234"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by orsmga003.jf.intel.com with ESMTP; 05 Feb 2020 23:09:29 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com
Cc:     peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 4/8] x86/split_lock: Add and export split_lock_detect_enabled() and split_lock_detect_fatal()
Date:   Thu,  6 Feb 2020 15:04:08 +0800
Message-Id: <20200206070412.17400-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206070412.17400-1-xiaoyao.li@intel.com>
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These two functions will be used by KVM to check whether host's
sld_state.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  |  4 ++++
 arch/x86/kernel/cpu/intel.c | 12 ++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 2b20829db450..f5172dbd3f01 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -46,6 +46,8 @@ unsigned int x86_stepping(unsigned int sig);
 extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
 extern void switch_to_sld(unsigned long tifn);
 extern bool handle_user_split_lock(unsigned long ip);
+extern bool split_lock_detect_enabled(void);
+extern bool split_lock_detect_fatal(void);
 #else
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
 static inline void switch_to_sld(unsigned long tifn) {}
@@ -53,5 +55,7 @@ static inline bool handle_user_split_lock(unsigned long ip)
 {
 	return false;
 }
+static inline bool split_lock_detect_enabled(void) { return false; }
+static inline bool split_lock_detect_fatal(void) { return false; }
 #endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ff27d026cb4a..b67b46ea66df 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1131,3 +1131,15 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 	if (ia32_core_caps & MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT)
 		split_lock_setup();
 }
+
+bool split_lock_detect_enabled(void)
+{
+	return sld_state != sld_off;
+}
+EXPORT_SYMBOL_GPL(split_lock_detect_enabled);
+
+bool split_lock_detect_fatal(void)
+{
+	return sld_state == sld_fatal;
+}
+EXPORT_SYMBOL_GPL(split_lock_detect_fatal);
-- 
2.23.0

