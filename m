Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C4B1636C5
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgBRXDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:03:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:57150 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbgBRXDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:03:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:03:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="239504575"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 18 Feb 2020 15:03:11 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: x86: Move #PF retry tracking variables into emulation context
Date:   Tue, 18 Feb 2020 15:03:10 -0800
Message-Id: <20200218230310.29410-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218230310.29410-1-sean.j.christopherson@intel.com>
References: <20200218230310.29410-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move last_retry_eip and last_retry_addr into the emulation context as
they are specific to retrying an instruction after emulation failure.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_emulate.h |  4 ++++
 arch/x86/include/asm/kvm_host.h    |  3 ---
 arch/x86/kvm/x86.c                 | 11 ++++++-----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index a4ef19a6e612..a26c8de414e8 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -315,6 +315,10 @@ struct x86_emulate_ctxt {
 	bool gpa_available;
 	gpa_t gpa_val;
 
+	/* Track EIP and CR2/GPA when retrying faulting instruction on #PF. */
+	unsigned long last_retry_eip;
+	unsigned long last_retry_addr;
+
 	/*
 	 * decode cache
 	 */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9c79c41eb5f6..6312ea32bb41 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -752,9 +752,6 @@ struct kvm_vcpu_arch {
 
 	cpumask_var_t wbinvd_dirty_mask;
 
-	unsigned long last_retry_eip;
-	unsigned long last_retry_addr;
-
 	struct {
 		bool halted;
 		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f88b72932c35..d19eb776f297 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6407,6 +6407,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 
 	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 
+	/* last_retry_{eip,addr} are persistent and must not be init'd here. */
 	ctxt->gpa_available = false;
 	ctxt->eflags = kvm_get_rflags(vcpu);
 	ctxt->tf = (ctxt->eflags & X86_EFLAGS_TF) != 0;
@@ -6557,8 +6558,8 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	unsigned long last_retry_eip, last_retry_addr, gpa = cr2_or_gpa;
 
-	last_retry_eip = vcpu->arch.last_retry_eip;
-	last_retry_addr = vcpu->arch.last_retry_addr;
+	last_retry_eip = ctxt->last_retry_eip;
+	last_retry_addr = ctxt->last_retry_addr;
 
 	/*
 	 * If the emulation is caused by #PF and it is non-page_table
@@ -6573,7 +6574,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	 * and the address again, we can break out of the potential infinite
 	 * loop.
 	 */
-	vcpu->arch.last_retry_eip = vcpu->arch.last_retry_addr = 0;
+	ctxt->last_retry_eip = ctxt->last_retry_addr = 0;
 
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
@@ -6588,8 +6589,8 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2_or_gpa)
 		return false;
 
-	vcpu->arch.last_retry_eip = ctxt->eip;
-	vcpu->arch.last_retry_addr = cr2_or_gpa;
+	ctxt->last_retry_eip = ctxt->eip;
+	ctxt->last_retry_addr = cr2_or_gpa;
 
 	if (!vcpu->arch.mmu->direct_map)
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
-- 
2.24.1

