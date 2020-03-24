Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C27B91914E8
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 16:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgCXPis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 11:38:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:40198 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728578AbgCXPhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 11:37:22 -0400
IronPort-SDR: /PWu+NRHLT+nsJP9ML5iu+jNTbNbDuEt37AUMY6HQFI8EGl7Nx21IGMtVrDBIFpLwfhIYhtG7S
 hwlLjIVsCDnA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 08:37:22 -0700
IronPort-SDR: swOwUcfEpCUuLI0UDc+LHu7mQYvNa4cttF8ot7875qeFcoexFW5ObCVVZZy6Q1gdMX1gKzQZXu
 uc+1mXTzU6rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="393319725"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.39])
  by orsmga004.jf.intel.com with ESMTP; 24 Mar 2020 08:37:18 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 4/8] kvm: x86: Emulate split-lock access as a write in emulator
Date:   Tue, 24 Mar 2020 23:18:55 +0800
Message-Id: <20200324151859.31068-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324151859.31068-1-xiaoyao.li@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com>
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
guest attacking kernel.

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
index aed2b477e2ad..fd67be719284 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1070,6 +1070,12 @@ static void split_lock_init(void)
 		sld_update_msr(sld_state != sld_off);
 }
 
+bool split_lock_detect_on(void)
+{
+	return sld_state != sld_off;
+}
+EXPORT_SYMBOL_GPL(split_lock_detect_on);
+
 bool handle_user_split_lock(unsigned long ip)
 {
 	if (sld_state == sld_fatal)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ebd56aa10d9f..5ef57e3a315f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5831,6 +5831,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 {
 	struct kvm_host_map map;
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	u64 page_line_mask = PAGE_MASK;
 	gpa_t gpa;
 	char *kaddr;
 	bool exchanged;
@@ -5845,7 +5846,11 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
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

