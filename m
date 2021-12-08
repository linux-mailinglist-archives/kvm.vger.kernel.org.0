Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39A846CAA1
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243313AbhLHB7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243446AbhLHB7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:59:03 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37F1C079796
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:27 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id y125-20020a25dc83000000b005c2326bf744so1777384ybe.21
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nSA+7Wbn1md8c4hejoAgllm6FyYF3EIl7O6C+XokVrA=;
        b=FhPI6SiC4iO3RKc/hZUq1Y5sHMYSUtxK47TC+eEWDtGVJqun3MqjqRWeOpkOjtDObH
         vvaZZJoOLeIspoyCyToiThABZa89sJuC4+IhWuzo0Zc+dxdwcEN8gzlNLjNxGFu4DUdW
         3B4qe0ecCyjkpglFvsLtoQOkuybiafiKm++S3gkV5B80+9xH7FWRoA5/TLtYKreDlb2P
         9Q2YypVQNTGKpqi/RvynV+dUT1CJdCN3K3yqAXKfUldZ0G7XUa4YsGV8/Igm0UIulDDx
         nXc36tIAKiH0gX2mjSzxi+KKj8Pz3TnPVtVCQDzdpySRak+dBmwyuT49toXaV2ttZ1Cd
         suGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nSA+7Wbn1md8c4hejoAgllm6FyYF3EIl7O6C+XokVrA=;
        b=MHMVTElhcgJk/qGSjRe7oFedoR0NitppMTR4lAWzcZVdJVWa5ftO7nymiOOrfqiEDt
         VGTU8qZPVKwq1GIUsWTh3KOEYKrfHua+TeCXts8Uzv/WP9RKkUSb606k/176IaN3ShlE
         Rwv5qxHU/VaUTLufhCfvghXjfnPCYEINByZ1jrII3CVYFN0QLsKDENRFAnYFnYrBXIHg
         x8kQPBVQUxHipDxntS9eC6HoTo4yC4jDl6hqztygS977cKaWeJktBlFER6yK4rNXfnSM
         /GFpJ4Y8K2y6i7ZthHGNepmNTwjprY0nCM5S8aNbyQBFUoltoRxoPPU0fsdCj1LtMCAk
         BaJg==
X-Gm-Message-State: AOAM531yIdI5mebsZxIMPZXDQLwej9OrXHrVkRvd+9XbgkhAIrXIskzA
        xAcJ30yqCG70/izwBf8j6dNnQGIAwO4=
X-Google-Smtp-Source: ABdhPJwlJGmLgQ9J6FIpPO/lILT+cfvhzCud+NGJkyme0uG+7Qffst4AD9tNwdk3H8zfZxC0+0MTTaWGPYQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:d55:: with SMTP id 82mr54919866ybn.237.1638928527132;
 Tue, 07 Dec 2021 17:55:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:34 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-25-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 24/26] KVM: x86: Skip APICv update if APICv is disable at
 the module level
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

Bail from the APICv update paths _before_ taking apicv_update_lock if
APICv is disabled at the module level.  kvm_request_apicv_update() in
particular is invoked from multiple paths that can be reached without
APICv being enabled, e.g. svm_enable_irq_window(), and taking the
rw_sem for write when APICv is disabled may introduce unnecessary
contention and stalls.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c | 3 +++
 arch/x86/kvm/x86.c    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 7179fa645eda..175c1bace091 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -112,6 +112,9 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 	if (!!auto_eoi_old == !!auto_eoi_new)
 		return;
 
+	if (!enable_apicv)
+		return;
+
 	down_write(&vcpu->kvm->arch.apicv_update_lock);
 
 	if (auto_eoi_new)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index abf99b77883e..c804cc39c90d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9602,6 +9602,9 @@ EXPORT_SYMBOL_GPL(__kvm_request_apicv_update);
 
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
+	if (!enable_apicv)
+		return;
+
 	down_write(&kvm->arch.apicv_update_lock);
 	__kvm_request_apicv_update(kvm, activate, bit);
 	up_write(&kvm->arch.apicv_update_lock);
-- 
2.34.1.400.ga245620fadb-goog

