Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A095E708B
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 02:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiIWAOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 20:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiIWAOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 20:14:07 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0218F8FB2
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:14:06 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p12-20020a170902e74c00b00177f3be2825so7009348plf.17
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=EBTyUY3XZE752wRZafMDoegRM4hNkAZeyMdz0Uk4JbQ=;
        b=fkCRmoRfPIqYKdmcvJI9Fta4b9KfZN7e0eQdNaWmIXq9ZQL4DSBz+ajrSHsCXaMi71
         Zgn/HSUe51xwQOcV032hxfi5UP8kOspSJUZimrlImKt8/S+EXPqiqZcjWgY/gPDW//zO
         Lbd+lGKdejwCBAFox3oJ8si7077UsyN2QRpJMlYW/LdMFfHBZMv9CvBXz8mb2wGRZg70
         tq+xOvLDHaOLiKIHzdCdveOyHMnaxG14nqTihHP18CygyqHXXOqkBBRGJY0qf0IEbHJC
         soqmTCAAaBLssjgchpPzZYOs7hyCCSv2AWBn8thxprC6q1yuge/HlbOsWZy8mx9w9Hjb
         Uf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=EBTyUY3XZE752wRZafMDoegRM4hNkAZeyMdz0Uk4JbQ=;
        b=LDbQz5ycQV4JUUk934ZdDcYX0r4pg5o6xCn1dsSdqGn91gRC6axgPgUc0DpUBnMmcN
         oWE1u9mVxFgPMqQy9659Qot48PhFgSMBneb8xqdH2dgTUqUYtRTf/d3lfB09FvWmZN6q
         dE5pje0PNkT6cXQjgmuPnlBNmhEjQu/NR+1it1N3wsq4+yCLLAT6PPrj4kh2fVxpdTM5
         G50CZnWgarvdgxDMUXr7+JpI5e3LBeTGfUwCJJMQaiKHpZOCVf3I56kH4bE6W1jI3Pk5
         SJE0H4d4S0y4YPbsBEHG2PXmwHi4EpaAcUR00jPFikbudrsUJLCr45Gx8PEdKSLsIdGi
         QjRw==
X-Gm-Message-State: ACrzQf29RB7lgLjic1ACphslbYUHCz3nZlnrEVhRC8WNuoKBoE0cEanJ
        khF10js6Pw/qBlx89ODSwI5A2r8zR8Q=
X-Google-Smtp-Source: AMsMyM7F4JyUTc+0+Z0vKXfRIXgEG8sC2y6UBGCK0o5D0CrYPyYnoSRVj26nigofwjfILt7FrNyq7J229xg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:10a:b0:200:2849:235f with SMTP id
 p10-20020a17090b010a00b002002849235fmr437280pjz.1.1663892046038; Thu, 22 Sep
 2022 17:14:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Sep 2022 00:13:52 +0000
In-Reply-To: <20220923001355.3741194-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220923001355.3741194-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220923001355.3741194-2-seanjc@google.com>
Subject: [PATCH 1/4] KVM: x86/pmu: Force reprogramming of all counters on PMU
 filter change
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Like Xu <likexu@tencent.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Force vCPUs to reprogram all counters on a PMU filter change to provide
a sane ABI for userspace.  Use the existing KVM_REQ_PMU to do the
programming, and take advantage of the fact that the reprogram_pmi bitmap
fits in a u64 to set all bits in a single atomic update.  Note, setting
the bitmap and making the request needs to be done _after_ the SRCU
synchronization to ensure that vCPUs will reprogram using the new filter.

KVM's current "lazy" approach is confusing and non-deterministic.  It's
confusing because, from a developer perspective, the code is buggy as it
makes zero sense to let userspace modify the filter but then not actually
enforce the new filter.  The lazy approach is non-deterministic because
KVM enforces the filter whenever a counter is reprogrammed, not just on
guest WRMSRs, i.e. a guest might gain/lose access to an event at random
times depending on what is going on in the host.

Note, the resulting behavior is still non-determinstic while the filter
is in flux.  If userspace wants to guarantee deterministic behavior, all
vCPUs should be paused during the filter update.

Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
Cc: Aaron Lewis <aaronlewis@google.com>
Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 11 ++++++++++-
 arch/x86/kvm/pmu.c              | 15 +++++++++++++--
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b3ce723efb43..462f041ede9f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -519,7 +519,16 @@ struct kvm_pmu {
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
 	struct irq_work irq_work;
-	DECLARE_BITMAP(reprogram_pmi, X86_PMC_IDX_MAX);
+
+	/*
+	 * Overlay the bitmap with a 64-bit atomic so that all bits can be
+	 * set in a single access, e.g. to reprogram all counters when the PMU
+	 * filter changes.
+	 */
+	union {
+		DECLARE_BITMAP(reprogram_pmi, X86_PMC_IDX_MAX);
+		atomic64_t __reprogram_pmi;
+	};
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d9b9a0f0db17..4504987cbbe2 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -577,6 +577,8 @@ EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_pmu_event_filter tmp, *filter;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
 	size_t size;
 	int r;
 
@@ -613,9 +615,18 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	mutex_lock(&kvm->lock);
 	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
 				     mutex_is_locked(&kvm->lock));
-	mutex_unlock(&kvm->lock);
-
 	synchronize_srcu_expedited(&kvm->srcu);
+
+	BUILD_BUG_ON(sizeof(((struct kvm_pmu *)0)->reprogram_pmi) >
+		     sizeof(((struct kvm_pmu *)0)->__reprogram_pmi));
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		atomic64_set(&vcpu_to_pmu(vcpu)->__reprogram_pmi, -1ull);
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_PMU);
+
+	mutex_unlock(&kvm->lock);
+
 	r = 0;
 cleanup:
 	kfree(filter);
-- 
2.37.3.998.g577e59143f-goog

