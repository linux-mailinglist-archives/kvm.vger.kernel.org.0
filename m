Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9AA1B8418
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 09:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgDYHCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 03:02:03 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21948 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgDYHCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 03:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587798121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=tQ0DnedDERp8UnEgcFBdDKx3t9qOBvJdAkWOzvyaHK4=;
        b=VneD+MYM0wsf45lLP43OBSdGaOStcQEKsYzl9VYIXjGSzVJjsuC0uMWv6IOmB+dUebdJ7B
        fQjYekjQfk1oKx8jNrtIDEdrupkKMYBGHPiHV2uO380a0P1+ww8dTWSB+w7Hotqy8v4VpW
        wvOuhVgMXdBty6cN8voXtMXP9ZAXIWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-w35gB8JFPNqmo2pm04YuIw-1; Sat, 25 Apr 2020 03:01:59 -0400
X-MC-Unique: w35gB8JFPNqmo2pm04YuIw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B882845F;
        Sat, 25 Apr 2020 07:01:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CF125D9C5;
        Sat, 25 Apr 2020 07:01:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 12/22] KVM: nSVM: Move SMI vmexit handling to svm_check_nested_events()
Date:   Sat, 25 Apr 2020 03:01:44 -0400
Message-Id: <20200425070154.251290-3-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unlike VMX, SVM allows a hypervisor to take a SMI vmexit without having
any special SMM-monitor enablement sequence.  Therefore, it has to be
handled like interrupts and NMIs.  Check for an unblocked SMI in
svm_check_nested_events() so that pending SMIs are correctly prioritized
over IRQs and NMIs when the latter events will trigger VM-Exit.

Note that there is no need to test explicitly for SMI vmexits, because
guests always runs outside SMM and therefore can never get an SMI while
they are blocked.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 16 ++++++++++++++++
 arch/x86/kvm/svm/svm.c    |  8 --------
 arch/x86/kvm/svm/svm.h    |  5 +++++
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 748b01220aac..226d5a0d677b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -776,6 +776,15 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 	return vmexit;
 }
 
+static void nested_svm_smi(struct vcpu_svm *svm)
+{
+	svm->vmcb->control.exit_code = SVM_EXIT_SMI;
+	svm->vmcb->control.exit_info_1 = 0;
+	svm->vmcb->control.exit_info_2 = 0;
+
+	nested_svm_vmexit(svm);
+}
+
 static void nested_svm_nmi(struct vcpu_svm *svm)
 {
 	svm->vmcb->control.exit_code = SVM_EXIT_NMI;
@@ -807,6 +816,13 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		kvm_event_needs_reinjection(vcpu) || svm->nested.exit_required ||
 		svm->nested.nested_run_pending;
 
+	if (vcpu->arch.smi_pending && nested_exit_on_smi(svm)) {
+		if (block_nested_events)
+			return -EBUSY;
+		nested_svm_smi(svm);
+		return 0;
+	}
+
 	if (vcpu->arch.nmi_pending && nested_exit_on_nmi(svm)) {
 		if (block_nested_events)
 			return -EBUSY;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3f1f80737f9e..1f9577b281e6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3766,14 +3766,6 @@ static bool svm_smi_allowed(struct kvm_vcpu *vcpu)
 	if (!gif_set(svm))
 		return false;
 
-	if (is_guest_mode(&svm->vcpu) &&
-	    svm->nested.intercept & (1ULL << INTERCEPT_SMI)) {
-		/* TODO: Might need to set exit_info_1 and exit_info_2 here */
-		svm->vmcb->control.exit_code = SVM_EXIT_SMI;
-		svm->nested.exit_required = true;
-		return false;
-	}
-
 	return !is_smm(vcpu);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d8ae654340d4..4dc6d2b4b721 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -378,6 +378,11 @@ static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
 	return is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK);
 }
 
+static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
+{
+	return (svm->nested.intercept & (1ULL << INTERCEPT_SMI));
+}
+
 static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 {
 	return (svm->nested.intercept & (1ULL << INTERCEPT_NMI));
-- 
2.18.2


