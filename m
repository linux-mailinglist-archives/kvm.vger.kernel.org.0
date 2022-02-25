Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3EF4C4D9A
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 19:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiBYSXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 13:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiBYSX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 13:23:29 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D1A6E78C
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:22:55 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id a12-20020a65640c000000b003756296df5cso3044814pgv.19
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uyp+YpR2LCYPHpmAeEJtjNTYELJqSix3hhuKEFkcmAA=;
        b=K/9NSmTITbjmwLiBOKORmckVTpBtCOjqt8lM1ExKYGpgAuDfMMyKDuPAoxGFdQQmyO
         Cl/ZSWyRgjEsfD324NAAE7370ShErimNCl8bDVTbiDi9haRm21z+Lfzg6UO7EVjC4QIz
         0b5azA44faCG+4MUUYxMY7rRTfxPaiN3PdpTmzbZkXD97uZboDH6t+NKrk3XYbUoN+fN
         ZGgkN7NdIl00CZWchQwR+ORPvF4iJZwkdc941znlbhq3bqKlFB8bhW7HtC2n9abovu6x
         ccCEz7dl+1u3mgWVgvF/H8fzUWaYgKpUgHEKHklpNZi3oWF/2sS4xwue0wqCIGhAIwAM
         zn6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uyp+YpR2LCYPHpmAeEJtjNTYELJqSix3hhuKEFkcmAA=;
        b=UCXinBv31Ow3pNRnEllAeQUVk1/3Gy2Nc3P+lvEvnQGlbjM7kKgulXLS6RFxM1ms1T
         hlfSwruFLXMYUQ0qB1rqJwRqfChhVcAcVPdAxmHXzHQ9KxX+hIK3RNdeYDi/beS5j3OA
         FVkaxfWmSWaSnFwL5MhlhpHzE0YUZEs7ev/Ex9crhgul23G2TSqfmmrGugrJiWXmCGz0
         8/4GsJoia4BOg5tT1EBkPdk7QmSk+gv9FZS4Xv1WyXaiUruTxSS/ui0HA/u09aQ4Nl6b
         Dj7TFpBnSemM5Fi0xT5mcyxSQfdrJN55nGXWnEe7nT1qhavSIxKNQKs7KuqlH9R0EKxW
         rhUA==
X-Gm-Message-State: AOAM531wctasu8LHyuB/LsA/Jqj6rZZf1RfJsrh+2u0S5OHdb4ebVAO3
        oVwSVpsYiOh2K3SXtDmsAdYZidf58Aw=
X-Google-Smtp-Source: ABdhPJyOha9usWYX4MGUAJDF97U64lo1sBxpvSHGuIbz/lOMQKj21CeheradWAoSeC33U/vg9C8Yo7X2eLE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:770a:0:b0:4e0:2547:9219 with SMTP id
 s10-20020a62770a000000b004e025479219mr8651634pfc.43.1645813375172; Fri, 25
 Feb 2022 10:22:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 25 Feb 2022 18:22:44 +0000
In-Reply-To: <20220225182248.3812651-1-seanjc@google.com>
Message-Id: <20220225182248.3812651-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220225182248.3812651-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v2 3/7] KVM: Drop kvm_reload_remote_mmus(), open code request
 in x86 users
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
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
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

Remove the generic kvm_reload_remote_mmus() and open code its
functionality into the two x86 callers.  x86 is (obviously) the only
architecture that uses the hook, and is also the only architecture that
uses KVM_REQ_MMU_RELOAD in a way that's consistent with the name.  That
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
index b2c1c4eb6007..32c6d4b33d03 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2353,7 +2353,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 		 * treats invalid shadow pages as being obsolete.
 		 */
 		if (!is_obsolete_sp(kvm, sp))
-			kvm_reload_remote_mmus(kvm);
+			kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 	}
 
 	if (sp->lpage_disallowed)
@@ -5639,11 +5639,11 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
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
@@ -5656,7 +5656,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * Note: we need to do this under the protection of mmu_lock,
 	 * otherwise, vcpu would purge shadow page but miss tlb flush.
 	 */
-	kvm_reload_remote_mmus(kvm);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 
 	kvm_zap_obsolete_pages(kvm);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f11039944c08..0aeb47cffd43 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1325,7 +1325,6 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
-void kvm_reload_remote_mmus(struct kvm *kvm);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 83c57bcc6eb6..66bb1631cb89 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -354,11 +354,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
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
2.35.1.574.g5d30c73bfb-goog

