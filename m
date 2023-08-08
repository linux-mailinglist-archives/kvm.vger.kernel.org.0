Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA1F774F4D
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 01:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjHHXbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 19:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjHHXbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 19:31:40 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CD81BCE
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 16:31:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5840614b13cso7578297b3.0
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 16:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691537498; x=1692142298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EPD874mS5DFXE7q5j+htsJnjyxr2fxrlyK2awIJE77s=;
        b=R6PS/UbuTNwK6Pgw8wERz7SV4Dg22YULDLQo8LtM+HTNtZYY/ALRYoF7v2KmpB39wG
         3AtZw/QwqNGD62fZhjLEMGB3+DqX4TBsuqgZILHFEATsLvU8ZfRjBiDePZ7x1yfPXWUQ
         OQIzS4qi5WK96rqoXWdEeGNQyTO4JSMEEKj7uqb7L3Yg/ACbTAms16AKjUx1voI0NI6L
         kNblvkQlYadYGbc67cuMFXt7P8WNsc+MX3enJC5TxAkVpZl087+nrZJ8tEIWEqVcAmw9
         nKuSHSwaxw8wETYMS0wyjqVz+AU+DvYO4kOCKTJ7gVo/euvqkqSBl7W/n2I2v0JD2RpT
         kvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691537498; x=1692142298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EPD874mS5DFXE7q5j+htsJnjyxr2fxrlyK2awIJE77s=;
        b=iGPkTJNLT7zRkIh7ZEkrG1dvt4wB8q3ZeuUWAJ3AbCiBgFmzTQWRzm470iTcjltJV7
         unjjmgAQmV++w38f6XTnBv0yfW9jsKnn1JxYtSG99JNIhzuWl06DNXG9CUjUPRcpmc0N
         gw9t+zFVIj3lRlxOZFys+IiA8NYNd6iVd+cJJucNBoRqR31N4IEtOI+qF4Gi4p+feT2J
         5aZHTO2KVpFeclHrtlNHSlRiOY0Y7AXpvO4g2hlAvZ0Hhc2AveodwhY+A3nFQrtXfv62
         zyWw3ApijDTcuYRBs3eeXt3J9i+n4keP0Mcn9+X9jf3zMTwPcFdUwVscT8DmN0ypKsAF
         3ikQ==
X-Gm-Message-State: AOJu0YycAKyXEJXjFrqbsgTxcu8wNEFRd4ouPUe+3awSUq7DFTa/SoHn
        Le+7BwP4ozRSEwgRTWGjycI95032E3E=
X-Google-Smtp-Source: AGHT+IF8AouhVr9UyFX4qHC+5TY3Ir6STkDAWiVLmV/MkbxJxSGeuqg95HvOZJgp6pY3rDvitVEzPjzR+pQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b707:0:b0:56c:ed45:442c with SMTP id
 v7-20020a81b707000000b0056ced45442cmr34413ywh.5.1691537498667; Tue, 08 Aug
 2023 16:31:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  8 Aug 2023 16:31:32 -0700
In-Reply-To: <20230808233132.2499764-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230808233132.2499764-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808233132.2499764-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: SVM: Set target pCPU during IRTE update if target
 vCPU is running
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

Update the target pCPU for IOMMU doorbells when updating IRTE routing if
KVM is actively running the associated vCPU.  KVM currently only updates
the pCPU when loading the vCPU (via avic_vcpu_load()), and so doorbell
events will be delivered to the wrong pCPU until the vCPU goes through a
put+load cycle (which might very well "never" happen for the lifetime of
the VM), ultimately resulting in lost IRQs in the guest.

To avoid inserting a stale pCPU, e.g. due to racing between updating IRTE
routing and vCPU load/put, get the pCPU information from the vCPU's
Physical APIC ID table entry (a.k.a. avic_physical_id_cache in KVM) and
update the IRTE while holding ir_list_lock.  Add comments with --verbose
enabled to explain exactly what is and isn't protected by ir_list_lock.

Fixes: 411b44ba80ab ("svm: Implements update_pi_irte hook to setup posted interrupt")
Reported-by: dengqiao.joey <dengqiao.joey@bytedance.com>
Cc: stable@vger.kernel.org
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8e041b215ddb..2092db892d7d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -791,6 +791,7 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 	int ret = 0;
 	unsigned long flags;
 	struct amd_svm_iommu_ir *ir;
+	u64 entry;
 
 	/**
 	 * In some cases, the existing irte is updated and re-set,
@@ -824,6 +825,18 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 	ir->data = pi->ir_data;
 
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
+	/*
+	 * Update the target pCPU for IOMMU doorbells if the vCPU is running.
+	 * If the vCPU is NOT running, i.e. is blocking or scheduled out, KVM
+	 * will update the pCPU info when the vCPU awkened and/or scheduled in.
+	 * See also avic_vcpu_load().
+	 */
+	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
+		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
+				    true, pi->ir_data);
+
 	list_add(&ir->node, &svm->ir_list);
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 out:
@@ -1031,6 +1044,13 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_vcpu_is_blocking(vcpu))
 		return;
 
+	/*
+	 * Grab the per-vCPU interrupt remapping lock even if the VM doesn't
+	 * _currently_ have assigned devices, as that can change.  Holding
+	 * ir_list_lock ensures that either svm_ir_list_add() will consume
+	 * up-to-date entry information, or that this task will wait until
+	 * svm_ir_list_add() completes to set the new target pCPU.
+	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
@@ -1067,6 +1087,14 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
 		return;
 
+	/*
+	 * Take and hold the per-vCPU interrupt remapping lock while updating
+	 * the Physical ID entry even though the lock doesn't protect against
+	 * multiple writers (see above).  Holding ir_list_lock ensures that
+	 * either svm_ir_list_add() will consume up-to-date entry information,
+	 * or that this task will wait until svm_ir_list_add() completes to
+	 * mark the vCPU as not running.
+	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
 	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
-- 
2.41.0.640.ga95def55d0-goog

