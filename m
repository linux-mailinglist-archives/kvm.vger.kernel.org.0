Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F574A6E29
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 10:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245616AbiBBJvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 04:51:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245605AbiBBJvg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 04:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643795495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UY84501MvomnFs5xyvNmmIsM6K/tjlv86HW1KV/TDi4=;
        b=YDFbLSeZ0VQFAMPaIe71OKclS2Y73qQpNN+zUxI5kPRMxQEyrP3VU+u0PzGV6Xdp7h4IzW
        kFNnk/rVt1oSQ5lIVj08m7SfMYVoEDPlv9KBDoxhg4T2rUtiwzyKFaPm8Zy8WkeT5YX02W
        zTl2CYT6UKRzHysTSJJVNe5LHSDXuvU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-2F5RkzrmPru3ciFRNJx4cw-1; Wed, 02 Feb 2022 04:51:30 -0500
X-MC-Unique: 2F5RkzrmPru3ciFRNJx4cw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 795CF8144E4;
        Wed,  2 Feb 2022 09:51:29 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FA50752AA;
        Wed,  2 Feb 2022 09:51:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] KVM: nSVM: Track whether changes in L0 require MSR bitmap for L2 to be rebuilt
Date:   Wed,  2 Feb 2022 10:50:57 +0100
Message-Id: <20220202095100.129834-2-vkuznets@redhat.com>
In-Reply-To: <20220202095100.129834-1-vkuznets@redhat.com>
References: <20220202095100.129834-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to nVMX commit ed2a4800ae9d ("KVM: nVMX: Track whether changes in
L0 require MSR bitmap for L2 to be rebuilt"), introduce a flag to keep
track of whether MSR bitmap for L2 needs to be rebuilt due to changes in
MSR bitmap for L1 or switching to a different L2.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 6 ++++++
 arch/x86/kvm/svm/svm.c    | 3 ++-
 arch/x86/kvm/svm/svm.h    | 9 +++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cf206855ebf0..f27323728be2 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -193,6 +193,8 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 		svm->nested.msrpm[p] = svm->msrpm[p] | value;
 	}
 
+	svm->nested.force_msr_bitmap_recalc = false;
+
 	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
 
 	return true;
@@ -494,6 +496,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {
 		new_vmcb12 = true;
 		svm->nested.last_vmcb12_gpa = svm->nested.vmcb12_gpa;
+		svm->nested.force_msr_bitmap_recalc = true;
 	}
 
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
@@ -1494,6 +1497,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm);
+
+	svm->nested.force_msr_bitmap_recalc = true;
+
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	ret = 0;
 out_free:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c99b18d76c0..6b5e2ebcf5d4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -664,6 +664,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 					u32 msr, int read, int write)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u8 bit_read, bit_write;
 	unsigned long tmp;
 	u32 offset;
@@ -694,7 +695,7 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	msrpm[offset] = tmp;
 
 	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
-
+	svm->nested.force_msr_bitmap_recalc = true;
 }
 
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 47ef8f4a9358..92fc4f554634 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -163,6 +163,15 @@ struct svm_nested_state {
 	struct vmcb_save_area_cached save;
 
 	bool initialized;
+
+	/*
+	 * Indicates whether MSR bitmap for L2 needs to be rebuilt due to
+	 * changes in MSR bitmap for L1 or switching to a different L2. Note,
+	 * this flag can only be used reliably in conjunction with a paravirt L1
+	 * which informs L0 whether any changes to MSR bitmap for L2 were done
+	 * on its side.
+	 */
+	bool force_msr_bitmap_recalc;
 };
 
 struct vcpu_sev_es_state {
-- 
2.34.1

