Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70532B4F93
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732895AbgKPS17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:27:59 -0500
Received: from mga06.intel.com ([134.134.136.31]:20622 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732673AbgKPS1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:27:55 -0500
IronPort-SDR: 8vgkqNb5fQSiD6s3VwTzEpvMIg48lyvqtJmAhR1EPuMJAjfdC1yWnMz9N91NjMWObvUa1WQrmw
 K6O4rNY/Cu9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232409999"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232409999"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:55 -0800
IronPort-SDR: zcpRJgWgBFfVEbPO26jvGzKRs6bd8EAPdPmpoNz/U+K64YrNexf/67QR/+/V89LpQlTBrSwVMm
 Hy+TQHUSUmNQ==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527790"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:54 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 06/67] KVM: x86: Split core of hypercall emulation to helper function
Date:   Mon, 16 Nov 2020 10:25:51 -0800
Message-Id: <22558f45bbc04d0b491e11ea321dff0f146e43aa.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

By necessity, TDX will use a different register ABI for hypercalls.
Break out the core functionality so that it may be reused for TDX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +++
 arch/x86/kvm/x86.c              | 49 +++++++++++++++++++++------------
 2 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d44858b69353..c2639744ea09 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1549,6 +1549,10 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
 void kvm_request_apicv_update(struct kvm *kvm, bool activate,
 			      unsigned long bit);
 
+unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+				      unsigned long a0, unsigned long a1,
+				      unsigned long a2, unsigned long a3,
+				      int op_64_bit);
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5ede41bf9e6..0f67f762717a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8020,23 +8020,15 @@ static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
 		kvm_vcpu_yield_to(target);
 }
 
-int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
+unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+				      unsigned long a0, unsigned long a1,
+				      unsigned long a2, unsigned long a3,
+				      int op_64_bit)
 {
-	unsigned long nr, a0, a1, a2, a3, ret;
-	int op_64_bit;
-
-	if (kvm_hv_hypercall_enabled(vcpu->kvm))
-		return kvm_hv_hypercall(vcpu);
-
-	nr = kvm_rax_read(vcpu);
-	a0 = kvm_rbx_read(vcpu);
-	a1 = kvm_rcx_read(vcpu);
-	a2 = kvm_rdx_read(vcpu);
-	a3 = kvm_rsi_read(vcpu);
+	unsigned long ret;
 
 	trace_kvm_hypercall(nr, a0, a1, a2, a3);
 
-	op_64_bit = is_64_bit_mode(vcpu);
 	if (!op_64_bit) {
 		nr &= 0xFFFFFFFF;
 		a0 &= 0xFFFFFFFF;
@@ -8045,11 +8037,6 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
-	if (kvm_x86_ops.get_cpl(vcpu) != 0) {
-		ret = -KVM_EPERM;
-		goto out;
-	}
-
 	ret = -KVM_ENOSYS;
 
 	switch (nr) {
@@ -8086,6 +8073,32 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		ret = -KVM_ENOSYS;
 		break;
 	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
+
+int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
+{
+	unsigned long nr, a0, a1, a2, a3, ret;
+	int op_64_bit;
+
+	if (kvm_hv_hypercall_enabled(vcpu->kvm))
+		return kvm_hv_hypercall(vcpu);
+
+	op_64_bit = is_64_bit_mode(vcpu);
+
+	if (kvm_x86_ops.get_cpl(vcpu) != 0) {
+		ret = -KVM_EPERM;
+		goto out;
+	}
+
+	nr = kvm_rax_read(vcpu);
+	a0 = kvm_rbx_read(vcpu);
+	a1 = kvm_rcx_read(vcpu);
+	a2 = kvm_rdx_read(vcpu);
+	a3 = kvm_rsi_read(vcpu);
+
+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit);
 out:
 	if (!op_64_bit)
 		ret = (u32)ret;
-- 
2.17.1

