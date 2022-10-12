Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032D35FCA65
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 20:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJLSRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 14:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiJLSRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 14:17:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9CE8F272
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3606e54636aso124280797b3.16
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TyhNic6RvRRWto70e2eCzZmqxgJk22R96aLUbLuIWvs=;
        b=MVQI3M6pbnDm9koPk/+/XGl6NZkOOF3VKQKaZVSZjFl6JxjgenM2TroRTmInL4qQiT
         kE7xjKNlTauf9ZjHyleDGQQZ57S7JpqLShfQReaA9Ga2AGPgUdm0M/boo6iV4UWs+BXK
         vRAP+xfrf+gCf5StNDUN7CqCpKI4if3Clv1czf1UnxpqqMa8fecGAfvZlFu0RQqqRc7t
         ve0DCfPCji3W1bzhdcfvD/Nm8vJOzVEkVNUDlTTMkoTj+eT2aIRn1ZDE8ksEbe1ofpfW
         fgKLmBrgmT2wMhxKpn2UR9JcRBdTQRVwyEPNnLx3kljweq1qmlro0s+ABvo0QtsQ+pTu
         8m5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TyhNic6RvRRWto70e2eCzZmqxgJk22R96aLUbLuIWvs=;
        b=QZRMVbWa5KaoxsQJwy5xQl+EYtiiklDTXY/uccwecs0THefnSlYIe24bzE1SyK4/Z9
         KavHH2vZlHLUZtyKn1SO96KXqevz/WJnSEWCjYck+wZke2twD1qRVdqDV7V16uz4ZIBR
         zhl2z/O4t17NGWaD+SX23hgp0PzQzLnbl6sPFjfofcJm4YBae8VhoXb4k8aYUty/53sf
         lXW5G6lSO7Qjp2lu488kM36N0IJhDKTSXzYU2aMqLFPphUErqJWtApDq7E/qnkIWaARC
         54DQQ4ajmEsnMyOKVxc9gBd66fz/acujqwPvrCxDh0GcXUKIBDmrgRIRH0GO+XpK8RiB
         0m7Q==
X-Gm-Message-State: ACrzQf2ND+x3LaiOCZzRQGiFP2K9DLe6rohQ+RrR//c+xyQkoOLmOsOI
        EXKLvH0i96z2Lrk2JlcTygPLSwohdXs=
X-Google-Smtp-Source: AMsMyM4F55qdnAxdTruYJL4NvuqMwcZDQ9nbKWTitPpl1wVMtTj8QpPhAdtMT8Tdyk+zByiu7mDlMO/Gi74=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3cc4:0:b0:6af:c67e:909e with SMTP id
 j187-20020a253cc4000000b006afc67e909emr27796209yba.266.1665598632588; Wed, 12
 Oct 2022 11:17:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 12 Oct 2022 18:16:54 +0000
In-Reply-To: <20221012181702.3663607-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221012181702.3663607-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012181702.3663607-4-seanjc@google.com>
Subject: [PATCH v4 03/11] KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faultin_pfn()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
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

From: David Matlack <dmatlack@google.com>

Grab mmu_invalidate_seq in kvm_faultin_pfn() and stash it in struct
kvm_page_fault. The eliminates duplicate code and reduces the amount of
parameters needed for is_page_fault_stale().

Preemptively split out __kvm_faultin_pfn() to a separate function for
use in subsequent commits.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 21 ++++++++++++---------
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  |  6 +-----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b2b970e9fa8d..72c3dc1884f6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4143,7 +4143,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
 }
 
-static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -4199,12 +4199,20 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return RET_PF_CONTINUE;
 }
 
+static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	smp_rmb();
+
+	return __kvm_faultin_pfn(vcpu, fault);
+}
+
 /*
  * Returns true if the page fault is stale and needs to be retried, i.e. if the
  * root was invalidated by a memslot update or a relevant mmu_notifier fired.
  */
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
-				struct kvm_page_fault *fault, int mmu_seq)
+				struct kvm_page_fault *fault)
 {
 	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
 
@@ -4224,14 +4232,12 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 		return true;
 
 	return fault->slot &&
-	       mmu_invalidate_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
+	       mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva);
 }
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
-
-	unsigned long mmu_seq;
 	int r;
 
 	fault->gfn = fault->addr >> PAGE_SHIFT;
@@ -4248,9 +4254,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
-	smp_rmb();
-
 	r = kvm_faultin_pfn(vcpu, fault);
 	if (r != RET_PF_CONTINUE)
 		return r;
@@ -4266,7 +4269,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
 
-	if (is_page_fault_stale(vcpu, fault, mmu_seq))
+	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
 	r = make_mmu_pages_available(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 582def531d4d..1c0a1e7c796d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -221,6 +221,7 @@ struct kvm_page_fault {
 	struct kvm_memory_slot *slot;
 
 	/* Outputs of kvm_faultin_pfn.  */
+	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
 	hva_t hva;
 	bool map_writable;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5ab5f94dcb6f..30b9d9b6734f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -791,7 +791,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 {
 	struct guest_walker walker;
 	int r;
-	unsigned long mmu_seq;
 	bool is_self_change_mapping;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
@@ -838,9 +837,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	else
 		fault->max_level = walker.level;
 
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
-	smp_rmb();
-
 	r = kvm_faultin_pfn(vcpu, fault);
 	if (r != RET_PF_CONTINUE)
 		return r;
@@ -871,7 +867,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
-	if (is_page_fault_stale(vcpu, fault, mmu_seq))
+	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
 	r = make_mmu_pages_available(vcpu);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

