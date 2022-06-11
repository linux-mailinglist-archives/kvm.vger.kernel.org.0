Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D705470C8
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 02:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349009AbiFKA6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 20:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344800AbiFKA6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 20:58:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C1E69CD4
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u22-20020a170902a61600b0016363cdfe84so371467plq.10
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=AVQRubkzoQn/ed1EYoJH5pfC/v1u5yrl7rOVcK+kmGE=;
        b=VRiSwc2//odTKj+Eikd4OHXG3B/142UyF51ul2JgNOdEGUo27qch42urrIwYQjX4X0
         W3gjMlZ1sC/ZFB3Bpv2KccjO+6a+Ac+T6bLDwX8aH3pdYjMTC3sSZlxtYuEr/xamNZDe
         00w417jax+aMFmj9dabWcc49lg4BxoAYUQUp/Ub4Ut5gsAC/NlQSiHazeVfgNhoSEB/a
         QemA8PXGPECUB1ZtbxB2aHZzNcGTy+qOID+luCycolJUSGx+NH6P7BFmCufYtVF7W6zN
         +y6YQ6iySYfkV6AhhkZwNQ4SGYrH0kWRjb3JrFfKNZW/8sZoxxv0aXHbKqoYft+qR/dq
         q3GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=AVQRubkzoQn/ed1EYoJH5pfC/v1u5yrl7rOVcK+kmGE=;
        b=wipoTYRSHs7MdoqHLh+EuVYvauWmiYns60C6yXkaOMANrDR2WVmHOuxIlg7sc/mcBv
         K0+7IxVRXrz8ohcKOT+IxnWXdepd0EhzEi8KUscNds53zggEHl7DWOk02anYUOfrSIX5
         ojdJ9vWc4HIozzD0y5u5kDDJ2k4X3IVEGWbQB1ZZc0kXJXqExrAPj43bs8IOHw2aZ0Cn
         1eZM8YNKR+sphAYE5ZXFyddTl9nq8IkD4pZYvHZSxuR7QIKoXKEE4P+p7W3TETO/qT4d
         A/qbF5vVQPiu+AqO5P/Vfth6baJ9i9yHahdkXcTYBk7el7XZgL5+IClUqaIwETIlz6Cc
         DkeA==
X-Gm-Message-State: AOAM532uOYUGkf9NMupicxF7ty3BZzQvECvkdkcETuU8p7kmZaQ3teQu
        dBXtYmytjup2bAfVv3VSerEf/BFh7Jo=
X-Google-Smtp-Source: ABdhPJz0VXKGAmbpeP1mI8hPMgAEsThaF7yFOUoQL4dG2YifgaHvI+1U0YLnaVaH7A8lar4qT043gNdIaI0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr13438pja.1.1654909083306; Fri, 10 Jun
 2022 17:58:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 11 Jun 2022 00:57:51 +0000
In-Reply-To: <20220611005755.753273-1-seanjc@google.com>
Message-Id: <20220611005755.753273-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220611005755.753273-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 3/7] Revert "KVM: x86/pmu: Accept 0 for absent PMU MSRs when
 host-initiated if !enable_pmu"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eating reads and writes to all "PMU" MSRs when there is no PMU is wildly
broken as it results in allowing accesses to _any_ MSR on Intel CPUs
as intel_is_valid_msr() returns true for all host_initiated accesses.

A revert of commit d1c88a402056 ("KVM: x86: always allow host-initiated
writes to PMU MSRs") will soon follow.

This reverts commit 8e6a58e28b34e8d247e772159b8fa8f6bae39192.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c     |  8 --------
 arch/x86/kvm/svm/pmu.c | 11 +----------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 6a32092460d3..87483e503c46 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -442,19 +442,11 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	if (msr_info->host_initiated && !vcpu->kvm->arch.enable_pmu) {
-		msr_info->data = 0;
-		return 0;
-	}
-
 	return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	if (msr_info->host_initiated && !vcpu->kvm->arch.enable_pmu)
-		return !!msr_info->data;
-
 	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
 	return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
 }
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index fe520b2649b5..256244b8f89c 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -182,16 +182,7 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated)
 {
 	/* All MSRs refer to exactly one PMC, so msr_idx_to_pmc is enough.  */
-	if (!host_initiated)
-		return false;
-
-	switch (msr) {
-	case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
-	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
-		return true;
-	default:
-		return false;
-	}
+	return false;
 }
 
 static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
-- 
2.36.1.476.g0c4daa206d-goog

