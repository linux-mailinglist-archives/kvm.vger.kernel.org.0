Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAECD73BBEE
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 17:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjFWPnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 11:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjFWPny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 11:43:54 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80E21FC0
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 08:43:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-66a44bf4651so593253b3a.1
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 08:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687535033; x=1690127033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2VNNy+wsDrAa7V3BNBfJBsZGaGPpQmr3wXXpQWfHP/8=;
        b=IU0i739PJ9hPmTJlji0fq7rBOLKYsqKr93IBkmdTBdvAFip08dvc9ZrbX7qzzegFIf
         xeq7HzwUzEHaq9QTyrHqmby4sbVZsqSazMp5L5eTySooHhDtN9pmBhf7QQ6PvUyHX545
         J6p5DLaFBrE7nwiAtbYQdAczj+zBE0jUvRuOcbJvetbFbPqqin3KraWEdUNpow+O5xOH
         CPxq+GzbskYP8P30qrheTLFxpxkVsFpsvbkxz3BUqKZfORzQZgyru/QSrCJi55qTdP0/
         //jzQlCoBpaWGPhNYrqh5DkyNgIi9/tm+47RxFgWfEyptf6ncm83bqJtxXuYz7YMJnfI
         U3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687535033; x=1690127033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2VNNy+wsDrAa7V3BNBfJBsZGaGPpQmr3wXXpQWfHP/8=;
        b=hLubAU278j1rGiGVVbSMcj62tOUyym7wORk5OOHY5PmDujxsl0OKqC7klcWabtBc7G
         gqAMe6b8jVzapq4S2TWjTqK3WZdKY5Bf+I7v/YalJZGJTGt0vX1MeF7r2gqTc68wujXw
         IhZCit4wxfNxSNkuxNLWMismHASoJdm/hJ8+1TYFFQs3sWOjjL5owCi4Hb/DCGi51MUV
         Q+Y5Kk7xDpdJTGOEAm1mawkt7Pgav9qGFVe17zYCMNuuitbV1RbEaiBJEBeOtV0eI4vI
         AtPuwhoBTfiEsh8jaClkdkZ8s/OnOpWzA8R1eEPssrrfXQ3bKxWLnVDmXoNITH88D7OF
         5zZA==
X-Gm-Message-State: AC+VfDxfyB8ak5nrC2dDOBpvYCV4e3hx4bF0U55rPTnLp+VhuzRsVwTB
        +3xNPBM5MkAVBKGblNxJ+aQVc1vp7Q4=
X-Google-Smtp-Source: ACHHUZ6daSO+b46MslGoC+HWxokGPBEsNG9yGK12iLJisiBB0PKx1RIfWODUMvpb+eo5O9XWyf9CPLOZgqw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3002:b0:66c:62c3:e7a2 with SMTP id
 ay2-20020a056a00300200b0066c62c3e7a2mr133301pfb.1.1687535033312; Fri, 23 Jun
 2023 08:43:53 -0700 (PDT)
Date:   Fri, 23 Jun 2023 08:43:52 -0700
In-Reply-To: <20230623123522.4185651-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230623123522.4185651-2-aaronlewis@google.com>
Message-ID: <ZJW9uBPssAtHY4h+@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: SRCU protect the PMU event filter in the
 fast path
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023, Aaron Lewis wrote:
> When running KVM's fast path it is possible to get into a situation
> where the PMU event filter is dereferenced without grabbing KVM's SRCU
> read lock.
> 
> The following callstack demonstrates how that is possible.
> 
> Call Trace:
>   dump_stack+0x85/0xdf
>   lockdep_rcu_suspicious+0x109/0x120
>   pmc_event_is_allowed+0x165/0x170
>   kvm_pmu_trigger_event+0xa5/0x190
>   handle_fastpath_set_msr_irqoff+0xca/0x1e0
>   svm_vcpu_run+0x5c3/0x7b0 [kvm_amd]
>   vcpu_enter_guest+0x2108/0x2580
> 
> Fix that by explicitly grabbing the read lock before dereferencing the
> PMU event filter.

Actually, on second thought, I think it would be better to acquire kvm->srcu in
handle_fastpath_set_msr_irqoff().  This is the second time that invoking
kvm_skip_emulated_instruction() resulted in an SRCU violation, and it probably
won't be the last since one of the benefits of using SRCU instead of per-asset
locks to protect things like memslots and filters is that low(ish) level helpers
don't need to worry about acquiring locks.

The 2x LOCK ADD from smp_mb() is unfortunate, but IMO it's worth eating that cost
to avoid having to play whack-a-mole in the future.  And as a (very small) bonus,
commit 5c30e8101e8d can be reverted.

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Jun 2023 08:19:51 -0700
Subject: [PATCH] KVM: x86: Acquire SRCU read lock when handling fastpath MSR
 writes

Temporarily acquire kvm->srcu for read when potentially emulating WRMSR in
the VM-Exit fastpath handler, as several of the common helpers used during
emulation expect the caller to provide SRCU protection.  E.g. if the guest
is counting instructions retired, KVM will query the PMU event filter when
stepping over the WRMSR.

  dump_stack+0x85/0xdf
  lockdep_rcu_suspicious+0x109/0x120
  pmc_event_is_allowed+0x165/0x170
  kvm_pmu_trigger_event+0xa5/0x190
  handle_fastpath_set_msr_irqoff+0xca/0x1e0
  svm_vcpu_run+0x5c3/0x7b0 [kvm_amd]
  vcpu_enter_guest+0x2108/0x2580

Alternatively, check_pmu_event_filter() could acquire kvm->srcu, but this
isn't the first bug of this nature, e.g. see commit 5c30e8101e8d ("KVM:
SVM: Skip WRMSR fastpath on VM-Exit if next RIP isn't valid").  Providing
protection for the entirety of WRMSR emulation will allow reverting the
aforementioned commit, and will avoid having to play whack-a-mole when new
uses of SRCU-protected structures are inevitably added in common emulation
helpers.

Fixes: dfdeda67ea2d ("KVM: x86/pmu: Prevent the PMU from counting disallowed events")
Reported-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 439312e04384..5f220c04624e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2172,6 +2172,8 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 	u64 data;
 	fastpath_t ret = EXIT_FASTPATH_NONE;
 
+	kvm_vcpu_srcu_read_lock(vcpu);
+
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
 		data = kvm_read_edx_eax(vcpu);
@@ -2194,6 +2196,8 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 	if (ret != EXIT_FASTPATH_NONE)
 		trace_kvm_msr_write(msr, data);
 
+	kvm_vcpu_srcu_read_unlock(vcpu);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);

base-commit: 88bb466c9dec4f70d682cf38c685324e7b1b3d60
-- 

