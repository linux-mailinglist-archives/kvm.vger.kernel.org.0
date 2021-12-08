Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5CB46CA8C
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243600AbhLHB7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243395AbhLHB6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:40 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192CEC0698C4
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:09 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x3-20020a17090a1f8300b001a285b9f2cbso681924pja.6
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RN6WvHTMttYY9G5+WvO2UU4giOt+jhBO4kXUEfmjbVY=;
        b=ijxneh9EkX++RC8ZhHk1tJ6Zb7Yu7HTQmaTahYE7i+pCeGF9EJyb/lDqHnBsFGQJEV
         ApQmbD5s1JrNnOUCGtZH31rfODOPlzdq3Bb1hGUJTcSrfxvdL4uo9q05pattTdOrzJap
         /5XtsoYPuaiqXyhPY1u0N98R/HLDsAJv9sVcP+WFDb79RlMa6TiYUK7Gn1j0lZ00Ge/+
         afrk3KdsTr2cZUjjuuhZnaLzF1TEjhdV/RMGHJTzer0BsCZyFzHAWKzuplz/wKHRBKmv
         BxmJY04YnT5H8pRaGZeFejAdPOShDbmHQcURiEW0cVjT9L7VIL0fdrBkbHgfHnx7V4uD
         fmog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RN6WvHTMttYY9G5+WvO2UU4giOt+jhBO4kXUEfmjbVY=;
        b=lIUv7UIMeCHkVCluCATWT+1mrI+7+Giy+0YS+DqnC7FS0qrz5wxyH/TreShsCMcdXq
         jHw2SQMV9t+NDc+Ldm8b1lo07553dflvdNvYYXPtxad9VSLcc47zJxq/R0zdMAqDB443
         Dt8tAT08nmpuuJt8a38ouvIBcYvmGcYQUPaNzJJsvyBIjntQubuA9q33qSrQ1wt8WXQq
         /evclMQLBVLC1lqUFAvD92FGUGPAtHRzFrArgyO5oofq+vBnZwd2KqW0kQNS7KiM1hh7
         /MasHK+j5kapK8DTKsIcGJ3X2xfd5chKSRWxTW0H2xP5GbHNH2MH+2L0/ZmGIWjsov4D
         DsGg==
X-Gm-Message-State: AOAM530FZUkdXhd9jQSx9TXqqEPCwn2P1FLI/5FXB61FoP2410U9Tp+O
        kX+voJl/OPWOVoulVK5u6VNXty4ZmGE=
X-Google-Smtp-Source: ABdhPJwpV9KyfQg8BjQExB6hqkzZypTPztaQh+jY5QSQJCH5c9MrySGkChv+eh0Hm/a7Q2Bxuo/M4x5RTYI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:bf4a:: with SMTP id i10mr26354995pgo.196.1638928508625;
 Tue, 07 Dec 2021 17:55:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:23 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-14-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 13/26] KVM: SVM: Use kvm_vcpu_is_blocking() in AVIC load to
 handle preemption
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

Use kvm_vcpu_is_blocking() to determine whether or not the vCPU should be
marked running during avic_vcpu_load().  Drop avic_is_running, which
really should have been named "vcpu_is_not_blocking", as it tracked if
the vCPU was blocking, not if it was actually running, e.g. it was set
during svm_create_vcpu() when the vCPU was obviously not running.

This is technically a teeny tiny functional change, as the vCPU will be
marked IsRunning=1 on being reloaded if the vCPU is preempted between
svm_vcpu_blocking() and prepare_to_rcuwait().  But that's a benign change
as the vCPU will be marked IsRunning=0 when KVM voluntarily schedules out
the vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 14 +++++++++-----
 arch/x86/kvm/svm/svm.c  |  6 ------
 arch/x86/kvm/svm/svm.h  |  1 -
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 16e4ebd980a2..dc0cbe500106 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -974,6 +974,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
 	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
+	bool is_blocking = kvm_vcpu_is_blocking(vcpu);
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -991,12 +992,17 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	if (svm->avic_is_running)
+
+	/*
+	 * Don't mark the vCPU as running if its blocking, i.e. if the vCPU is
+	 * preempted after svm_vcpu_blocking() but before KVM voluntarily
+	 * schedules out the vCPU.
+	 */
+	if (!is_blocking)
 		entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id,
-					svm->avic_is_running);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, !is_blocking);
 }
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
@@ -1017,11 +1023,9 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
  */
 static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
 	int cpu = get_cpu();
 
 	WARN_ON(cpu != vcpu->cpu);
-	svm->avic_is_running = is_run;
 
 	if (kvm_vcpu_apicv_active(vcpu)) {
 		if (is_run)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 208566f63bce..dde0106ffc47 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1444,12 +1444,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (err)
 		goto error_free_vmsa_page;
 
-	/* We initialize this flag to true to make sure that the is_running
-	 * bit would be set the first time the vcpu is loaded.
-	 */
-	if (irqchip_in_kernel(vcpu->kvm) && kvm_apicv_activated(vcpu->kvm))
-		svm->avic_is_running = true;
-
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm) {
 		err = -ENOMEM;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ca51d6dfc8e6..83ced47fa9b9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -226,7 +226,6 @@ struct vcpu_svm {
 	u32 dfr_reg;
 	struct page *avic_backing_page;
 	u64 *avic_physical_id_cache;
-	bool avic_is_running;
 
 	/*
 	 * Per-vcpu list of struct amd_svm_iommu_ir:
-- 
2.34.1.400.ga245620fadb-goog

