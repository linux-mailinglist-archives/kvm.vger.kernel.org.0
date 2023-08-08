Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFA7774F4B
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 01:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjHHXbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 19:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjHHXbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 19:31:37 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338AB1BC9
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 16:31:37 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c7bb27977so6301314a12.0
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 16:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691537496; x=1692142296;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=day2+XW8RNdkVZC5xrvfHTk42KwCQcUIyqc4gEqLSPk=;
        b=IGmQ30wtToTKQKXNfWHwqf7mw/Hg77MZs9+1Vdvn94qB/PVakIJQxvUyLSulwlYS8t
         80GU/aqTxi20TipyYeOpkXSl6Uqkp08qnPXCQwzRwKcjUYuujERd2Vx++vZgGMBtKX77
         UIJHAKR/laksl5dFdrXICnoZJikfHgZBk2TVLoC71XpsnZhGDqNWCn9SwEjG7HmfKV2k
         GO5kUgZgeLwNOqeR4wR1Y3rD9k9rkWPqg71RIwqk6LEmMq0v6zJkc3iAn70jwNCTfllF
         9wRThvjah7D9II39gLIQb6aisqPUW3I4RjvQeAL9JrRdJD/HDa66EOqmT9hsPn2VTp9v
         CxwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691537496; x=1692142296;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=day2+XW8RNdkVZC5xrvfHTk42KwCQcUIyqc4gEqLSPk=;
        b=jZpW0nNs0Fy54cE9r3FHD1koPOZtwRYXQI845n8hgUWvei+QiAylz6BOJmgNiLrHYR
         lNlzuuMYx2+p/LzS0qRHE+gwIxD59y/+4qG1ZO32PZDVpM85mTo6hFFxzuo6cYGm7XIF
         8+0cyCnwfLz3SyP1OIL1zZFgcAsI9ZW69uWmZNhyRzVGGVA+Ws2g26wbUM429CL0y+O8
         5tcaShpRT/cEfwQAOwcn8Od1b/KyfdCtsinwwl5/SgkuHGJx71+i51SvyaQpzEQW77lD
         HnL3kix8e6e1cAca3yM7fM4odB6K2nZSyp5CVuwCYBiY+/XGdRJOBwg3r914JjGK6ABG
         qGCg==
X-Gm-Message-State: AOJu0YzLrsFA3KjdnaLwdQDvp6NlWfODRQ4dX2CjlIx2Xm8FJ5MbZZYW
        ANdn52BkkdZWOGNYfKY06MjJ53JjYpU=
X-Google-Smtp-Source: AGHT+IHAY8TY7N6IaKGIUPURwq8foE2MqhUfIQb0pL4n4R44D3WSamPDhP9iirQ7wpJgBbXoYynBsGEMHSg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6f0a:0:b0:563:dced:3f35 with SMTP id
 k10-20020a636f0a000000b00563dced3f35mr20610pgc.4.1691537496734; Tue, 08 Aug
 2023 16:31:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  8 Aug 2023 16:31:31 -0700
In-Reply-To: <20230808233132.2499764-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230808233132.2499764-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808233132.2499764-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: SVM: Take and hold ir_list_lock when updating vCPU's
 Physical ID entry
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "dengqiao . joey" <dengqiao.joey@bytedance.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hoist the acquisition of ir_list_lock from avic_update_iommu_vcpu_affinity()
to its two callers, avic_vcpu_load() and avic_vcpu_put(), specifically to
encapsulate the write to the vCPU's entry in the AVIC Physical ID table.
This will allow a future fix to pull information from the Physical ID entry
when updating the IRTE, without potentially consuming stale information,
i.e. without racing with the vCPU being (un)loaded.

Add a comment to call out that ir_list_lock does NOT protect against
multiple writers, specifically that reading the Physical ID entry in
avic_vcpu_put() outside of the lock is safe.

To preserve some semblance of independence from ir_list_lock, keep the
READ_ONCE() in avic_vcpu_load() even though acuiring the spinlock
effectively ensures the load(s) will be generated after acquiring the
lock.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index cfc8ab773025..8e041b215ddb 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -986,10 +986,11 @@ static inline int
 avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 {
 	int ret = 0;
-	unsigned long flags;
 	struct amd_svm_iommu_ir *ir;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	lockdep_assert_held(&svm->ir_list_lock);
+
 	if (!kvm_arch_has_assigned_device(vcpu->kvm))
 		return 0;
 
@@ -997,19 +998,15 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 	 * Here, we go through the per-vcpu ir_list to update all existing
 	 * interrupt remapping table entry targeting this vcpu.
 	 */
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-
 	if (list_empty(&svm->ir_list))
-		goto out;
+		return 0;
 
 	list_for_each_entry(ir, &svm->ir_list, node) {
 		ret = amd_iommu_update_ga(cpu, r, ir->data);
 		if (ret)
-			break;
+			return ret;
 	}
-out:
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-	return ret;
+	return 0;
 }
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
@@ -1017,6 +1014,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	u64 entry;
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long flags;
 
 	lockdep_assert_preemption_disabled();
 
@@ -1033,6 +1031,8 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_vcpu_is_blocking(vcpu))
 		return;
 
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
@@ -1042,25 +1042,40 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
+
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	u64 entry;
 	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long flags;
 
 	lockdep_assert_preemption_disabled();
 
+	/*
+	 * Note, reading the Physical ID entry outside of ir_list_lock is safe
+	 * as only the pCPU that has loaded (or is loading) the vCPU is allowed
+	 * to modify the entry, and preemption is disabled.  I.e. the vCPU
+	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
+	 * recursively.
+	 */
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 
 	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
 	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
 		return;
 
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
 	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+
 }
 
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
-- 
2.41.0.640.ga95def55d0-goog

