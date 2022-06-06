Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60AC553EDA7
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 20:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiFFSL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 14:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFFSL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 14:11:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87802168368
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 11:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654539116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8OoV43vL2FT0NRTiVxi+/RfFyzhXqUOu+4aucOWRN6s=;
        b=Meb/iNaaFplpcbmHneTamluyq/P2Ft9d+6OmsEdVggtLovW/lK4lV2WiwPazzpHC/JfSlZ
        iqXZl1kCr9BOWNu6mp2BBvLqYeY8RcqLgJIgDtL9F2DEEe2BlK8Qi6lg5h4S0xSbHj51Bs
        MENeTE8tvG857twb7+UZTtnzC5aKDVY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-3m-kRYCpOrW4bXRHHEjHcQ-1; Mon, 06 Jun 2022 14:11:54 -0400
X-MC-Unique: 3m-kRYCpOrW4bXRHHEjHcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E130B185A79C;
        Mon,  6 Jun 2022 18:11:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CA2D1410F39;
        Mon,  6 Jun 2022 18:11:50 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Ilias Stamatis <ilstam@amazon.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: SVM: fix tsc scaling cache logic
Date:   Mon,  6 Jun 2022 21:11:49 +0300
Message-Id: <20220606181149.103072-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SVM uses a per-cpu variable to cache the current value of the
tsc scaling multiplier msr on each cpu.

Commit 1ab9287add5e2
("KVM: X86: Add vendor callbacks for writing the TSC multiplier")
broke this caching logic.

Refactor the code so that all TSC scaling multiplier writes go through
a single function which checks and updates the cache.

This fixes the following scenario:

1. A CPU runs a guest with some tsc scaling ratio.

2. New guest with different tsc scaling ratio starts on this CPU
   and terminates almost immediately.

   This ensures that the short running guest had set the tsc scaling ratio just
   once when it was set via KVM_SET_TSC_KHZ. Due to the bug,
   the per-cpu cache is not updated.

3. The original guest continues to run, it doesn't restore the msr
   value back to its own value, because the cache matches,
   and thus continues to run with a wrong tsc scaling ratio.


Fixes: 1ab9287add5e2 ("KVM: X86: Add vendor callbacks for writing the TSC multiplier")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  4 ++--
 arch/x86/kvm/svm/svm.c    | 32 ++++++++++++++++++++------------
 arch/x86/kvm/svm/svm.h    |  2 +-
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 88da8edbe1e1f..83bae1f2eeb8a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1037,7 +1037,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio) {
 		WARN_ON(!svm->tsc_scaling_enabled);
 		vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
-		svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
+		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 	}
 
 	svm->nested.ctl.nested_cr3 = 0;
@@ -1442,7 +1442,7 @@ void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu)
 	vcpu->arch.tsc_scaling_ratio =
 		kvm_calc_nested_tsc_multiplier(vcpu->arch.l1_tsc_scaling_ratio,
 					       svm->tsc_ratio_msr);
-	svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
+	__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 }
 
 /* Inverse operation of nested_copy_vmcb_control_to_cache(). asid is copied too. */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4aea82f668fb1..5c873db9432e5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -512,11 +512,24 @@ static int has_svm(void)
 	return 1;
 }
 
+void __svm_write_tsc_multiplier(u64 multiplier)
+{
+	preempt_disable();
+
+	if (multiplier == __this_cpu_read(current_tsc_ratio))
+		goto out;
+
+	wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
+	__this_cpu_write(current_tsc_ratio, multiplier);
+out:
+	preempt_enable();
+}
+
 static void svm_hardware_disable(void)
 {
 	/* Make sure we clean up behind us */
 	if (tsc_scaling)
-		wrmsrl(MSR_AMD64_TSC_RATIO, SVM_TSC_RATIO_DEFAULT);
+		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
 
 	cpu_svm_disable();
 
@@ -562,8 +575,7 @@ static int svm_hardware_enable(void)
 		 * Set the default value, even if we don't use TSC scaling
 		 * to avoid having stale value in the msr
 		 */
-		wrmsrl(MSR_AMD64_TSC_RATIO, SVM_TSC_RATIO_DEFAULT);
-		__this_cpu_write(current_tsc_ratio, SVM_TSC_RATIO_DEFAULT);
+		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
 	}
 
 
@@ -1046,11 +1058,12 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }
 
-void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
+static void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
 {
-	wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
+	__svm_write_tsc_multiplier(multiplier);
 }
 
+
 /* Evaluate instruction intercepts that depend on guest CPUID features. */
 static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
 					      struct vcpu_svm *svm)
@@ -1410,13 +1423,8 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		sev_es_prepare_switch_to_guest(hostsa);
 	}
 
-	if (tsc_scaling) {
-		u64 tsc_ratio = vcpu->arch.tsc_scaling_ratio;
-		if (tsc_ratio != __this_cpu_read(current_tsc_ratio)) {
-			__this_cpu_write(current_tsc_ratio, tsc_ratio);
-			wrmsrl(MSR_AMD64_TSC_RATIO, tsc_ratio);
-		}
-	}
+	if (tsc_scaling)
+		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 
 	if (likely(tsc_aux_uret_slot >= 0))
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cd92f43437539..2495fe548b5e9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -594,7 +594,7 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
-void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
+void __svm_write_tsc_multiplier(u64 multiplier);
 void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 				       struct vmcb_control_area *control);
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
-- 
2.26.3

