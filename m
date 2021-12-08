Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EC646CA9B
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243824AbhLHB7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243611AbhLHB7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:59:01 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1EDC061D76
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:22 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id iq9-20020a17090afb4900b001a54412feb0so678776pjb.1
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=lSh30i++wti8tFPA9afgXl8JTEqp4ySOIwGy8kr7tR8=;
        b=Htlzvs+plCJtV9VSlYiOapDMHz3HBEbpS8QE4+92NjOXvayrW/KMXuarwtdNEXrpSX
         CQzYdPtUTaqKXHFKtWn39LWRyJsx5U5FDn/zca9RHCNWYIKcc6ekwGgXx3zNFChT39w2
         ph15CtPxFYriuAhHfTVmCm0z/pjlrfV1KY5qkZpqcgLlt/u+s9/7i4WV8RSoE5UbH7vF
         todxgJWzRlHRpkzl9dETXe5B97vq9tbL2jSOL83irp6bZgsbX0XYvqFCYxzcMplw5vri
         1X8vG/Cej3k3m0FK+GHH0XitfECppGUvIPk+wOHRA0n340lY3QJkVDF+F2Vl5lJOBcuN
         0fTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=lSh30i++wti8tFPA9afgXl8JTEqp4ySOIwGy8kr7tR8=;
        b=KeD0KQmQgldAtELR+7T8bcMwRlNfwmbntTa90i9+TWpzsfyQej8GWxLfsxPiIy9h71
         kB6RtpJt+d7cOEdPJ4WmEOcxeOvbUAGw3mmc7ri7bl5xnPv5My+1V8XRPD2SP6xR4RPx
         BiAz7iurqq4v6ALpH5aCUZX7amGU+L+g+2czgltQ0lRnnqgnN96nQ1qyASovtMmagwAY
         2776FqgfEOKaMs83v2ejgOGK3FwLah3sFMhzrsenfVwlHJA34vWgzpMtA2MxnzdLO/wJ
         TrAjvf1xrTgvK4UVj66mEPjt6nqjvWZ+gVf+lSTiljiAP2YoRmTyn88k6jLxVh/MqCsQ
         hExw==
X-Gm-Message-State: AOAM533oDjx4t3J1uElkcP0A3Un8vy7nYkuEjQ53+xlllO/fb97RkaYX
        pCKUozqsJymz1gXJgJ9qkGmxSvVptag=
X-Google-Smtp-Source: ABdhPJxBRvOj5N/bhP8b+AjMFz0tiJwLiByWoRzaCUE9KYasIigz5qVHTot6i47figsMioG93rRFft4c9is=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:2ec8:: with SMTP id
 h8mr3521139pjs.168.1638928522214; Tue, 07 Dec 2021 17:55:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:31 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-22-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 21/26] KVM: SVM: Drop AVIC's intermediate
 avic_set_running() helper
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

Drop avic_set_running() in favor of calling avic_vcpu_{load,put}()
directly, and modify the block+put path to use preempt_disable/enable()
instead of get/put_cpu(), as it doesn't actually care about the current
pCPU associated with the vCPU.  Opportunistically add lockdep assertions
as being preempted in avic_vcpu_put() would lead to consuming stale data,
even though doing so _in the current code base_ would not be fatal.

Add a much needed comment explaining why svm_vcpu_blocking() needs to
unload the AVIC and update the IRTE _before_ the vCPU starts blocking.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 50 ++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 88b3c315b34f..dd0d688bc342 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -977,6 +977,8 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	lockdep_assert_preemption_disabled();
+
 	/*
 	 * Since the host physical APIC id is 8 bits,
 	 * we can support host APIC ID upto 255.
@@ -1010,6 +1012,8 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	u64 entry;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	lockdep_assert_preemption_disabled();
+
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 
 	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
@@ -1022,31 +1026,37 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
-/*
- * This function is called during VCPU halt/unhalt.
- */
-static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
-{
-	int cpu = get_cpu();
-
-	WARN_ON(cpu != vcpu->cpu);
-
-	if (kvm_vcpu_apicv_active(vcpu)) {
-		if (is_run)
-			avic_vcpu_load(vcpu, cpu);
-		else
-			avic_vcpu_put(vcpu);
-	}
-	put_cpu();
-}
-
 void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
-	avic_set_running(vcpu, false);
+	if (!kvm_vcpu_apicv_active(vcpu))
+		return;
+
+	preempt_disable();
+
+	/*
+	 * Unload the AVIC when the vCPU is about to block, _before_ the vCPU
+	 * actually blocks.  The vCPU needs to be marked IsRunning=0 before the
+	 * final pass over the vIRR via kvm_vcpu_check_block().  Any IRQs that
+	 * arrive before IsRunning=0 will not signal the doorbell, i.e. it's
+	 * KVM's responsibility to ensure there are no pending IRQs in the vIRR
+	 * after IsRunning is cleared, prior to scheduling out the vCPU.
+	 */
+	avic_vcpu_put(vcpu);
+
+	preempt_enable();
 }
 
 void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
+	int cpu;
 
-	avic_set_running(vcpu, true);
+	if (!kvm_vcpu_apicv_active(vcpu))
+		return;
+
+	cpu = get_cpu();
+	WARN_ON(cpu != vcpu->cpu);
+
+	avic_vcpu_load(vcpu, cpu);
+
+	put_cpu();
 }
-- 
2.34.1.400.ga245620fadb-goog

