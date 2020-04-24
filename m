Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0241B7CA6
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 19:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgDXRYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 13:24:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40012 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728775AbgDXRYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 13:24:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587749078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=BKlpMaDDnpf6oM4hQ3cYP2CARvyZyLnX+wypaaAyFF8=;
        b=UuWvqR9n5jjNK0plWvL1Y00+0+yij6t3SSGYfSB79I4FU5V7SFpFF1+/tzd9dgj+3+1xDH
        ll9Kb6iXaE9MyJPB0aIUCXPtZlIAdeTZ9uuGYOGdJ/cHDLBtYKOdSWvDKLID1blHKbpwjG
        i44+x4Uga8aqP7bg0FwoA154LAjrnAY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-DyQikqukM1WYFN0UYu9Agg-1; Fri, 24 Apr 2020 13:24:36 -0400
X-MC-Unique: DyQikqukM1WYFN0UYu9Agg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DC8B8014D6;
        Fri, 24 Apr 2020 17:24:28 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 650541FDE1;
        Fri, 24 Apr 2020 17:24:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 09/22] KVM: x86: replace is_smm checks with kvm_x86_ops.smi_allowed
Date:   Fri, 24 Apr 2020 13:24:03 -0400
Message-Id: <20200424172416.243870-10-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not hardcode is_smm so that all the architectural conditions for
blocking SMIs are listed in a single place.  Well, in two places because
this introduces some code duplication between Intel and AMD.

This ensures that nested SVM obeys GIF in kvm_vcpu_has_events.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 arch/x86/kvm/x86.c     | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cdee634e961d..01ee1c3be25b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3771,7 +3771,7 @@ static bool svm_smi_allowed(struct kvm_vcpu *vcpu)
 		return false;
 	}
 
-	return true;
+	return !is_smm(vcpu);
 }
 
 static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c98194f04b04..c33317bfc1cf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7680,7 +7680,7 @@ static bool vmx_smi_allowed(struct kvm_vcpu *vcpu)
 	/* we need a nested vmexit to enter SMM, postpone if run is pending */
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return false;
-	return true;
+	return !is_smm(vcpu);
 }
 
 static int vmx_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ebfebc807fd..e8469db6ccae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7744,8 +7744,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 	if (kvm_event_needs_reinjection(vcpu))
 		return 0;
 
-	if (vcpu->arch.smi_pending && !is_smm(vcpu) &&
-	    kvm_x86_ops.smi_allowed(vcpu)) {
+	if (vcpu->arch.smi_pending && kvm_x86_ops.smi_allowed(vcpu)) {
 		vcpu->arch.smi_pending = false;
 		++vcpu->arch.smi_count;
 		enter_smm(vcpu);
@@ -10174,7 +10173,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 		return true;
 
 	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
-	    (vcpu->arch.smi_pending && !is_smm(vcpu)))
+	    (vcpu->arch.smi_pending &&
+	     kvm_x86_ops.smi_allowed(vcpu)))
 		return true;
 
 	if (kvm_arch_interrupt_allowed(vcpu) &&
-- 
2.18.2


