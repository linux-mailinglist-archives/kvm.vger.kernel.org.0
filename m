Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F56846E243
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 07:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhLIGJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 01:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhLIGJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 01:09:36 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9D7C061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 22:06:03 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id h15-20020a17090a648f00b001a96c2c97abso3024697pjj.9
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 22:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=6yjoNs+SmXvk90kUtd+a9DXdNUZb+yDSBhnGFbOEGjU=;
        b=VX1aoNHpE83yTz5eF/CG5D4Scz5kuRlxWMzqlJSzJdN6Idh4BNGVCwv8yTBdmj7TCI
         VHGbbfefS2NWT0ukbYfK5WA72iNe18e7pm+7YxzyXrczpffD02tBn4sIDFuWwz/btiYV
         r4qk4QrHfktT6VRxSskpVdAY39HU4jKpWmFbByE0KnUdoX0FVa2BQ32Ev+EYiTFzUr5f
         OGoV3cUJgn87GD9BK3orAI6YYVimM0s1lu+QGfyFmaLA4vb44f9cEFXMqmNGESFh0Sy/
         waaWh37RFrbYyyxwZEtGDoUXbY3Hntoyw52bh4Rh5NDe6APWe0RTV6SmAUs+Ue1GJCPI
         WHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=6yjoNs+SmXvk90kUtd+a9DXdNUZb+yDSBhnGFbOEGjU=;
        b=UNyOQARcPpjaqrrv8KN/UBlY7JW6psvLInxoVMwvWS8a12UNgnOTdVW43tStrQ64QG
         1wpFnghmfO65fpZRSWx+aKzyBdI94FE2dkx1ekeQuul25D27EpKKpbI08RxlUvy0vP3M
         LxEjMwLwE5R8Il23No23NW0QmYpEC12/Uuy0Ciese4v+TIRbSPlTzpSPsynqrpTh6VqH
         LUFqByFbk3UfvXZD4pUmNk7JNAkEU+j0mB6I6vFKlJwm9Hnk9q2giBcjO+7AH20nexK+
         Mh4LXxMeroVY6ILIW16E+Pjrwe1j7B3Ob1q25D09VbI9Zpa7DSA1j5LnUtKDUOKYOtv0
         94IA==
X-Gm-Message-State: AOAM532SUsDaEoIHkXNveVDxM+ocRbiKTYiiBa+PP64yozH9zi/wKCG7
        BvTvj9y1OReVO1vc0ZGOgs5PQoaPP5s=
X-Google-Smtp-Source: ABdhPJzhYDjvACyHNsRUR/v1wMeSBBvR6ankwNaI3Mz7Vb+CzgnY1QsjOKc7IgxPkX5FG3nH4JCc/MdCXpA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a14:b0:4a0:945:16fa with SMTP id
 p20-20020a056a000a1400b004a0094516famr9642357pfh.9.1639029963002; Wed, 08 Dec
 2021 22:06:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Dec 2021 06:05:48 +0000
In-Reply-To: <20211209060552.2956723-1-seanjc@google.com>
Message-Id: <20211209060552.2956723-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211209060552.2956723-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 3/7] KVM: Drop kvm_reload_remote_mmus(), open code request in
 x86 users
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the generic kvm_reload_remote_mmus() and open code its
functionality into the two x86 callers.  x86 is (obviously) the only
architecture that uses the hook, and is also the only architecture that
uses KVM_REQ_MMU_RELOAD in away that's consistent with the name.  That
will change in a future patch, as x86's usage when zapping a single
shadow page x86 doesn't actually _need_ to reload all vCPUs' MMUs, only
MMUs whose root is being zapped actually need to be reloaded.

s390 also uses KVM_REQ_MMU_RELOAD, but for a slightly different purpose.

Drop the generic code in anticipation of implementing s390 and x86 arch
specific requests, which will allow dropping KVM_REQ_MMU_RELOAD entirely.

Opportunistically reword the x86 TDP MMU comment to avoid making
references to functions (and requests!) when possible, and to remove the
rather ambiguous "this".

No functional change intended.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 14 +++++++-------
 include/linux/kvm_host.h |  1 -
 virt/kvm/kvm_main.c      |  5 -----
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1d275e9d76b5..31605cd3c09f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2388,7 +2388,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 		 * treats invalid shadow pages as being obsolete.
 		 */
 		if (!is_obsolete_sp(kvm, sp))
-			kvm_reload_remote_mmus(kvm);
+			kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 	}
 
 	if (sp->lpage_disallowed)
@@ -5669,11 +5669,11 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 */
 	kvm->arch.mmu_valid_gen = kvm->arch.mmu_valid_gen ? 0 : 1;
 
-	/* In order to ensure all threads see this change when
-	 * handling the MMU reload signal, this must happen in the
-	 * same critical section as kvm_reload_remote_mmus, and
-	 * before kvm_zap_obsolete_pages as kvm_zap_obsolete_pages
-	 * could drop the MMU lock and yield.
+	/*
+	 * In order to ensure all vCPUs drop their soon-to-be invalid roots,
+	 * invalidating TDP MMU roots must be done while holding mmu_lock for
+	 * write and in the same critical section as making the reload request,
+	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
 	 */
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_invalidate_all_roots(kvm);
@@ -5686,7 +5686,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * Note: we need to do this under the protection of mmu_lock,
 	 * otherwise, vcpu would purge shadow page but miss tlb flush.
 	 */
-	kvm_reload_remote_mmus(kvm);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 
 	kvm_zap_obsolete_pages(kvm);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f8ed799e8674..636e62c09964 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1112,7 +1112,6 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
-void kvm_reload_remote_mmus(struct kvm *kvm);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f3acff708bf5..e5a89592e89d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -355,11 +355,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 #endif
 
-void kvm_reload_remote_mmus(struct kvm *kvm)
-{
-	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
-}
-
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 					       gfp_t gfp_flags)
-- 
2.34.1.400.ga245620fadb-goog

