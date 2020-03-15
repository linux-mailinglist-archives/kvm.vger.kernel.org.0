Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E616B185A35
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 06:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgCOFXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Mar 2020 01:23:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:47872 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbgCOFXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Mar 2020 01:23:10 -0400
IronPort-SDR: M8wLh0PkbsrDMfXmxiC9M9v1o2qx55D7FNFQCRH61QtBpbjgZPXi22FDqFSBbbTx5oeaEJ8Ok/
 Qc08hbZ1QZDA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 22:23:10 -0700
IronPort-SDR: fKea1dvGBAMBVCZZshILki/T40YvFqjeQKMqXwGD1Ef9Ff69dkMLBhdMecbkabe/wMICLzMRy1
 D1QlGtvoHpSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,555,1574150400"; 
   d="scan'208";a="267194251"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by fmsmga004.fm.intel.com with ESMTP; 14 Mar 2020 22:23:06 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v5 5/9] kvm: x86: Emulate split-lock access as a write
Date:   Sun, 15 Mar 2020 13:05:13 +0800
Message-Id: <20200315050517.127446-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200315050517.127446-1-xiaoyao.li@intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If split lock detect is on (warn/fatal), #AC handler calls die() when
split lock happens in kernel.

Malicous guest can exploit the KVM emulator to trigger split lock #AC
in kernel[1]. So just emulating the access as a write if it's a
split-lock access (the same as access spans page) to avoid malicious
attacking kernel.

More discussion can be found [2][3].

[1] https://lore.kernel.org/lkml/8c5b11c9-58df-38e7-a514-dc12d687b198@redhat.com/
[2] https://lkml.kernel.org/r/20200131200134.GD18946@linux.intel.com
[3] https://lkml.kernel.org/r/20200227001117.GX9940@linux.intel.com

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  | 2 ++
 arch/x86/kernel/cpu/intel.c | 6 ++++++
 arch/x86/kvm/x86.c          | 7 ++++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index ff567afa6ee1..d2071f6a35ac 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -44,6 +44,7 @@ unsigned int x86_stepping(unsigned int sig);
 extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
 extern void switch_to_sld(unsigned long tifn);
 extern bool handle_user_split_lock(unsigned long ip);
+extern bool split_lock_detect_on(void);
 #else
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
 static inline void switch_to_sld(unsigned long tifn) {}
@@ -51,5 +52,6 @@ static inline bool handle_user_split_lock(unsigned long ip)
 {
 	return false;
 }
+static inline bool split_lock_detect_on(void) { return false; }
 #endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index c401d174c8db..de94957a11a4 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1102,6 +1102,12 @@ static void split_lock_init(struct cpuinfo_x86 *c)
 	sld_state = sld_disable;
 }
 
+bool split_lock_detect_on(void)
+{
+	return sld_state == sld_warn || sld_state == sld_fatal;
+}
+EXPORT_SYMBOL_GPL(split_lock_detect_on);
+
 bool handle_user_split_lock(unsigned long ip)
 {
 	if (sld_state == sld_fatal)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5de200663f51..1a0e6c0b1b39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5873,6 +5873,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 {
 	struct kvm_host_map map;
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	u64 page_line_mask = PAGE_MASK;
 	gpa_t gpa;
 	char *kaddr;
 	bool exchanged;
@@ -5887,7 +5888,11 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	    (gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
 		goto emul_write;
 
-	if (((gpa + bytes - 1) & PAGE_MASK) != (gpa & PAGE_MASK))
+	if (split_lock_detect_on())
+		page_line_mask = ~(cache_line_size() - 1);
+
+	/* when write spans page or spans cache when SLD enabled */
+	if (((gpa + bytes - 1) & page_line_mask) != (gpa & page_line_mask))
 		goto emul_write;
 
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(gpa), &map))
-- 
2.20.1

