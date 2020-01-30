Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF44C14DA92
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 13:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgA3MYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 07:24:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:49436 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbgA3MYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 07:24:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 04:24:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,381,1574150400"; 
   d="scan'208";a="262155251"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2020 04:24:46 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: Emulate split-lock access as a write
Date:   Thu, 30 Jan 2020 20:19:38 +0800
Message-Id: <20200130121939.22383-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200130121939.22383-1-xiaoyao.li@intel.com>
References: <20200130121939.22383-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If split lock detect is enabled (warn/fatal), #AC handler calls die()
when split lock happens in kernel.

A sane guest should never tigger emulation on a split-lock access, but
it cannot prevent malicous guest from doing this. So just emulating the
access as a write if it's a split-lock access to avoid malicous guest
polluting the kernel log.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  | 12 ++++++++++++
 arch/x86/kernel/cpu/intel.c | 12 ++++++------
 arch/x86/kvm/x86.c          | 11 +++++++++++
 3 files changed, 29 insertions(+), 6 deletions(-)

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
index 5d92e381fd91..2f9c48e91caf 100644
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
@@ -1004,6 +998,12 @@ cpu_dev_register(intel_cpu_dev);
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e6d4e4dcd11c..7d9303c303d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5800,6 +5800,13 @@ static int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
 	(cmpxchg64((u64 *)(ptr), *(u64 *)(old), *(u64 *)(new)) == *(u64 *)(old))
 #endif
 
+static inline bool is_split_lock_access(gpa_t gpa, unsigned int bytes)
+{
+	unsigned int cache_line_size = cache_line_size();
+
+	return (gpa & (cache_line_size - 1)) + bytes > cache_line_size;
+}
+
 static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 				     unsigned long addr,
 				     const void *old,
@@ -5826,6 +5833,10 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (((gpa + bytes - 1) & PAGE_MASK) != (gpa & PAGE_MASK))
 		goto emul_write;
 
+	if (get_split_lock_detect_state() != sld_off &&
+	    is_split_lock_access(gpa, bytes))
+		goto emul_write;
+
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(gpa), &map))
 		goto emul_write;
 
-- 
2.23.0

