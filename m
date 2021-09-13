Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F754092AD
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241746AbhIMONk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:13:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32478 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344588AbhIMOLh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 10:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631542220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4k5B+XyGfsZlOtGFjHi0yr68XmGQs4cgQsZJdQ1hq64=;
        b=C2FnVfFfHDiIGHaqOliLIGNb/gDSyzB1vMB/gbfwPOzddY5gnAhRSS2Nq9Df6pt0qpW4Nk
        efCzUCD/iw8+5FxDMKSDfEQUsIace86VKZpGS7O90jX6Q70rNAL6XgbkyB7pgVRISMg0uC
        wXm0z4nZJ8YRK3bM/8UdKS+gVwXD5+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-cNXJ_0w5MnyKduD8nW3YPg-1; Mon, 13 Sep 2021 10:10:19 -0400
X-MC-Unique: cNXJ_0w5MnyKduD8nW3YPg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09FA9835DE0;
        Mon, 13 Sep 2021 14:10:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAAAD1972D;
        Mon, 13 Sep 2021 14:10:14 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 4/7] KVM: x86: SVM: call KVM_REQ_GET_NESTED_STATE_PAGES on exit from SMM mode
Date:   Mon, 13 Sep 2021 17:09:51 +0300
Message-Id: <20210913140954.165665-5-mlevitsk@redhat.com>
In-Reply-To: <20210913140954.165665-1-mlevitsk@redhat.com>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the KVM_REQ_GET_NESTED_STATE_PAGES on SVM only reloads PDPTRs,
and MSR bitmap, with former not really needed for SMM as SMM exit code
reloads them again from SMRAM'S CR3, and later happens to work
since MSR bitmap isn't modified while in SMM.

Still it is better to be consistient with VMX.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 9 ++++++---
 arch/x86/kvm/svm/svm.c    | 2 +-
 arch/x86/kvm/svm/svm.h    | 3 ++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e13357da21e..f8345701ce0e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -572,7 +572,7 @@ static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to
 }
 
 int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
-			 struct vmcb *vmcb12)
+			 struct vmcb *vmcb12, bool from_vmrun)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
@@ -602,13 +602,16 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
-				  nested_npt_enabled(svm), true);
+				  nested_npt_enabled(svm), from_vmrun);
 	if (ret)
 		return ret;
 
 	if (!npt_enabled)
 		vcpu->arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
 
+	if (!from_vmrun)
+		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+
 	svm_set_gif(svm, true);
 
 	return 0;
@@ -674,7 +677,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	svm->nested.nested_run_pending = 1;
 
-	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12))
+	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
 		goto out_exit_err;
 
 	if (nested_svm_vmrun_msrpm(svm))
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e3b092a3a2e1..5a8f70ab13c9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4371,7 +4371,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 
 	vmcb12 = map.hva;
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
-	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
+	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);
 
 unmap_save:
 	kvm_vcpu_unmap(vcpu, &map_save, true);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 524d943f3efc..128a54b1fbf1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -459,7 +459,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
 }
 
-int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb_gpa, struct vmcb *vmcb12);
+int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
+			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
 void svm_leave_nested(struct vcpu_svm *svm);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
-- 
2.26.3

