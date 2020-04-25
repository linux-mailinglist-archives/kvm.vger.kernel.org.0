Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24D41B8417
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 09:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgDYHDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 03:03:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46163 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726179AbgDYHCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 03:02:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587798123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=xS3zfh8HUFB5rg6jSc/FF6GSS9oAePJV5pV8SbzL1TQ=;
        b=ZyI5MeAuc1MCMAj2Rgd2cVS49qAt1UMXUXn6xSZbF8XLTKY84qJ6wGEezkeaC6rKMO6U/e
        FeExkwKCz6ORcZsVbW36NqjqJk1+xgxrqEkt0kmvZUiXtR32lBKOAEEOs6bynu+HnQvDGn
        CqAu1J4gdCG9JoMzQeQUXi4Dp4Rz00U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-h5roe3JTPomdM8IER2MUyw-1; Sat, 25 Apr 2020 03:01:58 -0400
X-MC-Unique: h5roe3JTPomdM8IER2MUyw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E52041800D42;
        Sat, 25 Apr 2020 07:01:56 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BE635D9C5;
        Sat, 25 Apr 2020 07:01:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 11/22] KVM: nSVM: Report NMIs as allowed when in L2 and Exit-on-NMI is set
Date:   Sat, 25 Apr 2020 03:01:43 -0400
Message-Id: <20200425070154.251290-2-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Report NMIs as allowed when the vCPU is in L2 and L2 is being run with
Exit-on-NMI enabled, as NMIs are always unblocked from L1's perspective
in this case.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 5 -----
 arch/x86/kvm/svm/svm.c    | 3 +++
 arch/x86/kvm/svm/svm.h    | 5 +++++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c3650efd2e89..748b01220aac 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -776,11 +776,6 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 	return vmexit;
 }
 
-static bool nested_exit_on_nmi(struct vcpu_svm *svm)
-{
-	return (svm->nested.intercept & (1ULL << INTERCEPT_NMI));
-}
-
 static void nested_svm_nmi(struct vcpu_svm *svm)
 {
 	svm->vmcb->control.exit_code = SVM_EXIT_NMI;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 01ee1c3be25b..3f1f80737f9e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3068,6 +3068,9 @@ static bool svm_nmi_allowed(struct kvm_vcpu *vcpu)
 	struct vmcb *vmcb = svm->vmcb;
 	bool ret;
 
+	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
+		return true;
+
 	ret = !(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
 	      !(svm->vcpu.arch.hflags & HF_NMI_MASK);
 	ret = ret && gif_set(svm);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a2bc33aadb67..d8ae654340d4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -378,6 +378,11 @@ static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
 	return is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK);
 }
 
+static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
+{
+	return (svm->nested.intercept & (1ULL << INTERCEPT_NMI));
+}
+
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			  struct vmcb *nested_vmcb, struct kvm_host_map *map);
 int nested_svm_vmrun(struct vcpu_svm *svm);
-- 
2.18.2


