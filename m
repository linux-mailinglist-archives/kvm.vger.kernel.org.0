Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4BC46CAA4
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243610AbhLHB7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243448AbhLHB7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:59:02 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2560C0698C5
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:25 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t1-20020a6564c1000000b002e7f31cf59fso429179pgv.14
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zMqSw9DjsctvX2kHjzsjMwRHpb1qJqGe5cba6m1kl4s=;
        b=SGoA9JReTHagmcuj4wdk6JIDMU3iSsEWgylUiO0/XB4jaezJSuiFhkzeR/n1JIQdiw
         rgX8vkf/9pt/W30P5NvLEqoR2I77x3O3aNxligZRhbb6pcn3jJfp28Tx5X+6kiCHzKum
         fDnFkxpLBYjjc7d4ewYMyLMdpXnBypZE6KaEah1iOnRsp6HWj2Q08bphnl13hb+sh5pe
         GbtrDPgtdV6D9XC+okWYuxegfA869PT4dsbOAGBhDzfr+y1I9PcPvZId4tcy3dQ8brw2
         /oUSrIPXD+UYD5+zduLQOvOcgkt8bnvQ9uyi9J4nJGKY7fIW4zFDRSOkRL1QVBMMJird
         GVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zMqSw9DjsctvX2kHjzsjMwRHpb1qJqGe5cba6m1kl4s=;
        b=3OIPAuftNmcY9FN63bPwyQdvluMgZs6Pf3o09eELIJWszagLdDcxXkr84bFlLdpe83
         yHSENEe56Or0k5XOJuWJ1Y8GjNBe0A+6588BicFP1VuORDOLQXUFdWNSRmOQflxIFRs8
         isbaINlVT02RqN2Q6qG2tf760HOK4RsJelr0TrWyNV0bWwLiGP1Fav8HUp62EyJ0gp6H
         VMn8oWAjvXDwyg1jR+NZrE7ApPmvse/OgoiK4RY4q/oKvYHhekvAUxvcqx+7Dp9Hj1pU
         27/igOlQmK8Bvs5nq5k7s48jdqvGPkfodRB4ZfmwXt7+mNVhA3z9MDuNS0JrJ51ROOY/
         h8tA==
X-Gm-Message-State: AOAM5331Tfh18TUqjs4Ut79ii6yBRRB9f3AU09zty9vNS9jPQOQCVyvr
        4Y2SV3b/gOAbo/rdyBENOeT7O3qTzdY=
X-Google-Smtp-Source: ABdhPJx/DCvh/0By4lkVe+LvL+R6Uz52EC3FR3J8mjqoo2v1YJZTtqCtNOkmuVRMivr6qzF1Mg4BXJiztRA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:751a:: with SMTP id q26mr22763534pgc.529.1638928525427;
 Tue, 07 Dec 2021 17:55:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:33 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-24-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 23/26] KVM: SVM: Nullify vcpu_(un)blocking() hooks if AVIC
 is disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nullify svm_x86_ops.vcpu_(un)blocking if AVIC/APICv is disabled as the
hooks are necessary only to clear the vCPU's IsRunning entry in the
Physical APIC and to update IRTE entries if the VM has a pass-through
device attached.

Opportunistically rename the helpers to clarify their AVIC relationship.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 4 ++--
 arch/x86/kvm/svm/svm.c  | 7 +++++--
 arch/x86/kvm/svm/svm.h  | 4 ++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index dd0d688bc342..26ed5325c593 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1026,7 +1026,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
-void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
+void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
@@ -1046,7 +1046,7 @@ void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
+void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
 	int cpu;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 98f7c454a784..e57e6857e063 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4370,8 +4370,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.prepare_guest_switch = svm_prepare_guest_switch,
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
-	.vcpu_blocking = svm_vcpu_blocking,
-	.vcpu_unblocking = svm_vcpu_unblocking,
+	.vcpu_blocking = avic_vcpu_blocking,
+	.vcpu_unblocking = avic_vcpu_unblocking,
 
 	.update_exception_bitmap = svm_update_exception_bitmap,
 	.get_msr_feature = svm_get_msr_feature,
@@ -4658,6 +4658,9 @@ static __init int svm_hardware_setup(void)
 		pr_info("AVIC enabled\n");
 
 		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+	} else {
+		svm_x86_ops.vcpu_blocking = NULL;
+		svm_x86_ops.vcpu_unblocking = NULL;
 	}
 
 	if (vls) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 83ced47fa9b9..daa8ca84afcc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -593,8 +593,8 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
-void svm_vcpu_blocking(struct kvm_vcpu *vcpu);
-void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
+void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
+void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-- 
2.34.1.400.ga245620fadb-goog

