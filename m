Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1825786A9
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 17:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiGRPro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 11:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGRPrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 11:47:43 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CD32980C;
        Mon, 18 Jul 2022 08:47:41 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1oDSxq-00049n-UZ; Mon, 18 Jul 2022 17:47:18 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nSVM: Pull CS.Base from actual VMCB12 for soft int/ex re-injection
Date:   Mon, 18 Jul 2022 17:47:13 +0200
Message-Id: <4caa0f67589ae3c22c311ee0e6139496902f2edc.1658159083.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

enter_svm_guest_mode() first calls nested_vmcb02_prepare_control() to copy
control fields from VMCB12 to the current VMCB, then
nested_vmcb02_prepare_save() to perform a similar copy of the save area.

This means that nested_vmcb02_prepare_control() still runs with the
previous save area values in the current VMCB so it shouldn't take the L2
guest CS.Base from this area.

Explicitly pull CS.Base from the actual VMCB12 instead in
enter_svm_guest_mode().

Granted, having a non-zero CS.Base is a very rare thing (and even
impossible in 64-bit mode), having it change between nested VMRUNs is
probably even rarer, but if it happens it would create a really subtle bug
so it's better to fix it upfront.

Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index adf4120b05d90..23252ab821941 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -639,7 +639,8 @@ static bool is_evtinj_nmi(u32 evtinj)
 }
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
-					  unsigned long vmcb12_rip)
+					  unsigned long vmcb12_rip,
+					  unsigned long vmcb12_csbase)
 {
 	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
 	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
@@ -711,7 +712,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
 		svm->soft_int_injected = true;
-		svm->soft_int_csbase = svm->vmcb->save.cs.base;
+		svm->soft_int_csbase = vmcb12_csbase;
 		svm->soft_int_old_rip = vmcb12_rip;
 		if (svm->nrips_enabled)
 			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
@@ -800,7 +801,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, vmcb12->save.rip);
+	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
@@ -1663,7 +1664,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip);
+	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
 
 	/*
 	 * While the nested guest CR3 is already checked and set by
