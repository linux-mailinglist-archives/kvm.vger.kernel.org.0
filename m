Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1679B107AF7
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfKVW6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:58:34 -0500
Received: from mga06.intel.com ([134.134.136.31]:15520 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfKVW6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:58:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:58:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="382219004"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 22 Nov 2019 14:58:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86: Move #PF retry tracking variables into emulation context
Date:   Fri, 22 Nov 2019 14:58:32 -0800
Message-Id: <20191122225832.26684-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122225832.26684-1-sean.j.christopherson@intel.com>
References: <20191122225832.26684-1-sean.j.christopherson@intel.com>
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
index e81658a4ab9d..9c5db3b4120e 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -311,6 +311,10 @@ struct x86_emulate_ctxt {
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
index e434f4cfecd1..6c8bfebabc31 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -745,9 +745,6 @@ struct kvm_vcpu_arch {
 
 	cpumask_var_t wbinvd_dirty_mask;
 
-	unsigned long last_retry_eip;
-	unsigned long last_retry_addr;
-
 	struct {
 		bool halted;
 		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8adfdf1e0a..3aa2d7d98779 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6317,6 +6317,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 
 	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 
+	/* last_retry_{eip,addr} are persistent and must not be init'd here. */
 	ctxt->gpa_available = false;
 	ctxt->eflags = kvm_get_rflags(vcpu);
 	ctxt->tf = (ctxt->eflags & X86_EFLAGS_TF) != 0;
@@ -6467,8 +6468,8 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	unsigned long last_retry_eip, last_retry_addr, gpa = cr2;
 
-	last_retry_eip = vcpu->arch.last_retry_eip;
-	last_retry_addr = vcpu->arch.last_retry_addr;
+	last_retry_eip = ctxt->last_retry_eip;
+	last_retry_addr = ctxt->last_retry_addr;
 
 	/*
 	 * If the emulation is caused by #PF and it is non-page_table
@@ -6483,7 +6484,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	 * and the address again, we can break out of the potential infinite
 	 * loop.
 	 */
-	vcpu->arch.last_retry_eip = vcpu->arch.last_retry_addr = 0;
+	ctxt->last_retry_eip = ctxt->last_retry_addr = 0;
 
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
@@ -6498,8 +6499,8 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2)
 		return false;
 
-	vcpu->arch.last_retry_eip = ctxt->eip;
-	vcpu->arch.last_retry_addr = cr2;
+	ctxt->last_retry_eip = ctxt->eip;
+	ctxt->last_retry_addr = cr2;
 
 	if (!vcpu->arch.mmu->direct_map)
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
-- 
2.24.0

