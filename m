Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D059E3101EE
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhBEA6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 19:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhBEA6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:58:39 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B90C061794
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 16:57:59 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b125so5138772ybg.10
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 16:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=s/7OLdaHi3yoUUX9wWrGdt8SN3RdwtsZAJpN80nW/RM=;
        b=qayTKsI/p7rDGHpuF8mEyIK52XOGj/oCB2Uoibej7fzaUQlWzPI8+idvL6VAqBfKvw
         UaEJAglAgz7aZRNql+wR5KiDIKD/aOs45vlizRO9mXGFhNow04ejrRdrA2IPnH2Hvxpx
         TtRbreH7UDYfxKbwrQxOCwrP4l9c1mzc48X+2EHCuW2oUD3sc8G4UpUPZhh8BSKTcuG/
         XHQCeP1outKwFvKKFudty5CsyMidykmp5F3JZm/muFPNaTGW8l2CYfy+NLOmlEC/KbvS
         KXTRV1cRD1U9VeR8OuT5WHnBuT6x4PUx1I+xAx/T/gTxbqyaXh9N8MbZed9/xvk8Bb4d
         EEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=s/7OLdaHi3yoUUX9wWrGdt8SN3RdwtsZAJpN80nW/RM=;
        b=WZSEqr4oREOdTb3I5rBe8UzL1XOt8F0a8I6lnVPCLfhrHIRR1lLnYpUHaStgXxUa8q
         RtPNEjtRwcRPNr+4HoDZ/rS9TO7EwA7xkQflMKj9fy7uyb6b9mBu59G1uIZXNiyZ9fmN
         oaAZfR8scvTSYhqmNX+BtfYTfHe2kygThvOUhMulXIhkOseMOcjSWofchkLV5kb4f0rZ
         fG98HeYqnOazZqZgBWb+bft/E5LQ7yR9GrKcxpUsPVjaNz+aNlN31DoA1KLYIFEtl9A1
         nKbO1WuJ6dlJUeayOlojDAVUxQXzYSqSpF6hoQ6BU3POtSQ28xdIHN0KZf+9aAu0b8Fp
         UStw==
X-Gm-Message-State: AOAM533fEUg3AqyE9eOAzyCEFRx7ynlooEEc0H2BJOmAIaZYUdFa0BWg
        xghWuNuouEBGfnNIq1YLRCp3xBuc5/U=
X-Google-Smtp-Source: ABdhPJzL9xdiNeojWZKa6LwA6l9D94N3uAy+fqgTEczM2Vsyqd+0+QgUFzKXCtvoQt36LfqqDF/W4BO8Huw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
 (user=seanjc job=sendgmr) by 2002:a25:5f43:: with SMTP id h3mr2950650ybm.122.1612486678782;
 Thu, 04 Feb 2021 16:57:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Feb 2021 16:57:42 -0800
In-Reply-To: <20210205005750.3841462-1-seanjc@google.com>
Message-Id: <20210205005750.3841462-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210205005750.3841462-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 1/9] KVM: SVM: Move AVIC vCPU kicking snippet to helper function
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Kosina <trivial@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper function to handle kicking non-running vCPUs when sending
virtual IPIs.  A future patch will change SVM's interception functions
to take @vcpu instead of @svm, at which piont declaring and modifying
'vcpu' in a case statement is confusing, and potentially dangerous.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 0ef84d57b72e..78bdcfac4e40 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -298,6 +298,23 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
+				   u32 icrl, u32 icrh)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		bool m = kvm_apic_match_dest(vcpu, source,
+					     icrl & APIC_SHORT_MASK,
+					     GET_APIC_DEST_FIELD(icrh),
+					     icrl & APIC_DEST_MASK);
+
+		if (m && !avic_vcpu_is_running(vcpu))
+			kvm_vcpu_wake_up(vcpu);
+	}
+}
+
 int avic_incomplete_ipi_interception(struct vcpu_svm *svm)
 {
 	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
@@ -324,28 +341,14 @@ int avic_incomplete_ipi_interception(struct vcpu_svm *svm)
 		kvm_lapic_reg_write(apic, APIC_ICR2, icrh);
 		kvm_lapic_reg_write(apic, APIC_ICR, icrl);
 		break;
-	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING: {
-		int i;
-		struct kvm_vcpu *vcpu;
-		struct kvm *kvm = svm->vcpu.kvm;
-		struct kvm_lapic *apic = svm->vcpu.arch.apic;
-
+	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
 		/*
 		 * At this point, we expect that the AVIC HW has already
 		 * set the appropriate IRR bits on the valid target
 		 * vcpus. So, we just need to kick the appropriate vcpu.
 		 */
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			bool m = kvm_apic_match_dest(vcpu, apic,
-						     icrl & APIC_SHORT_MASK,
-						     GET_APIC_DEST_FIELD(icrh),
-						     icrl & APIC_DEST_MASK);
-
-			if (m && !avic_vcpu_is_running(vcpu))
-				kvm_vcpu_wake_up(vcpu);
-		}
+		avic_kick_target_vcpus(svm->vcpu.kvm, apic, icrl, icrh);
 		break;
-	}
 	case AVIC_IPI_FAILURE_INVALID_TARGET:
 		WARN_ONCE(1, "Invalid IPI target: index=%u, vcpu=%d, icr=%#0x:%#0x\n",
 			  index, svm->vcpu.vcpu_id, icrh, icrl);
-- 
2.30.0.365.g02bc693789-goog

