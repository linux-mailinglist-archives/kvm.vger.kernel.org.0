Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C274EEF42
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 16:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346805AbiDAOY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 10:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiDAOY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 10:24:27 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68D0248792
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 07:22:37 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s72so2522327pgc.5
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 07:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y6NYgD6CmQKrzTR96Y2z4+22G7HGe2HX0/wPly7z848=;
        b=HA5iffyA3tFUMp6Pxr9Re5GUyp6m4S7asQu/DiHNbPWlTGtD3kbvzQc8KjfiSGhcV/
         L3MH8J9RPl46+EXVE3u3zNpgtBi3RQ98QM1ptM/G8gRQKiIPjRXy61Mup+Lsk26q9J8E
         NyXyu9x63QS0DGcp7ouEjo6TOLSh7i0NfUtZhNCKhH4edSCQXunzdRhLPwDwEmN/0bBy
         KmdF0Ig0R2tsB2P2EletU/Wt0nX8TiMURFjfuARKALF9Vx2M6od/gVsGIy0Zn+ZO41qY
         sb4Jl7OFc+u/1LlCiwcQKX+gB8afChBs8wkdzB4/BoZQgyfXfaDxe09vGxEZt7+/ex4D
         /lRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y6NYgD6CmQKrzTR96Y2z4+22G7HGe2HX0/wPly7z848=;
        b=JgVRLjCaNYPd65GllSDsrDx9CJhtNOX+G7N6NCW9sgccx513faNkiNLc07PbPF//3p
         DHGqdqpjx1EMtCvnBgD8GGkjNDrWg9/KUzUhq/GXPWZAqduq4o7Yx1Az/zkMC3I39MTa
         1ic1YzZUeVor5UCEKETk4igMUhv+Ztn6oARs6+5joTnFR5uZyLINnwMEBJqhzqFwlGSb
         1dpL57cyiiY6K78OMWJMTC/PlufzgerHXA8Yp8Jni9Lm2SpjedgzRq4v9uz5p1Pzc9On
         9fybVWR9oyZams3Ue3XEgTMKLU8lxQ9/2j8Csttuk0KS5QyQt5UjR1VwZPxotCH093iL
         jFLw==
X-Gm-Message-State: AOAM532BE5kS5GxqlWp6w9pnXIvq4EbwNNSRT4G9GxSA748WvOMYK7iq
        YAg0AAxUh+KF9OvJdToqcP/8UQ==
X-Google-Smtp-Source: ABdhPJwjSxNwfxF3iYVakNEEEOp1wum2Psbj1Tr4354n4ZHnBsOhz818mClGfh6VMEXcC4dZMwUszA==
X-Received: by 2002:a62:7b97:0:b0:4fa:7a9a:6523 with SMTP id w145-20020a627b97000000b004fa7a9a6523mr11182028pfc.80.1648822956936;
        Fri, 01 Apr 2022 07:22:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u18-20020a056a00125200b004fb112ee9b7sm2933175pfi.75.2022.04.01.07.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 07:22:36 -0700 (PDT)
Date:   Fri, 1 Apr 2022 14:22:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 2/6] KVM: x86/mmu: Track the number of TDP MMU pages,
 but not the actual pages
Message-ID: <YkcKqAqcKUAS+b7+@google.com>
References: <20220401063636.2414200-1-mizhang@google.com>
 <20220401063636.2414200-3-mizhang@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="j3c8VscvnAccrGCY"
Content-Disposition: inline
In-Reply-To: <20220401063636.2414200-3-mizhang@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--j3c8VscvnAccrGCY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 01, 2022, Mingwei Zhang wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f05423545e6d..5ca78a89d8ed 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -24,7 +24,6 @@ bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  
>  	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
>  	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
> -	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
>  	kvm->arch.tdp_mmu_zap_wq =
>  		alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);

This has a minor conflict with kvm/next and kvm/queue, attached a new version since
you'll need a v3 (foreshadowing...).

--j3c8VscvnAccrGCY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-mmu-Track-the-number-of-TDP-MMU-pages-but-no.patch"

From 3d0c2796b22c75e3ab279cbcd3036c44500a6744 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 1 Apr 2022 06:36:32 +0000
Subject: [PATCH] KVM: x86/mmu: Track the number of TDP MMU pages, but not the
 actual pages

Track the number of TDP MMU "shadow" pages instead of tracking the pages
themselves. With the NX huge page list manipulation moved out of the common
linking flow, elminating the list-based tracking means the happy path of
adding a shadow page doesn't need to acquire a spinlock and can instead
inc/dec an atomic.

Keep the tracking as the WARN during TDP MMU teardown on leaked shadow
pages is very, very useful for detecting KVM bugs.

Tracking the number of pages will also make it trivial to expose the
counter to userspace as a stat in the future, which may or may not be
desirable.

Note, the TDP MMU needs to use a separate counter (and stat if that ever
comes to be) from the existing n_used_mmu_pages. The TDP MMU doesn't bother
supporting the shrinker nor does it honor KVM_SET_NR_MMU_PAGES (because the
TDP MMU consumes so few pages relative to shadow paging), and including TDP
MMU pages in that counter would break both the shrinker and shadow MMUs,
e.g. if a VM is using nested TDP.

Cc: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++--------
 arch/x86/kvm/mmu/tdp_mmu.c      | 16 ++++++++--------
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 676705ad1e23..8a80056cf841 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1192,6 +1192,9 @@ struct kvm_arch {
 	 */
 	bool tdp_mmu_enabled;
 
+	/* The number of TDP MMU pages across all roots. */
+	atomic64_t tdp_mmu_pages;
+
 	/*
 	 * List of struct kvm_mmu_pages being used as roots.
 	 * All struct kvm_mmu_pages in the list should have
@@ -1212,18 +1215,10 @@ struct kvm_arch {
 	 */
 	struct list_head tdp_mmu_roots;
 
-	/*
-	 * List of struct kvmp_mmu_pages not being used as roots.
-	 * All struct kvm_mmu_pages in the list should have
-	 * tdp_mmu_page set and a tdp_mmu_root_count of 0.
-	 */
-	struct list_head tdp_mmu_pages;
-
 	/*
 	 * Protects accesses to the following fields when the MMU lock
 	 * is held in read mode:
 	 *  - tdp_mmu_roots (above)
-	 *  - tdp_mmu_pages (above)
 	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
 	 *  - lpage_disallowed_mmu_pages
 	 *  - the lpage_disallowed_link field of struct kvm_mmu_pages used
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d6417740646a..1f44826cf794 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -29,7 +29,6 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	kvm->arch.tdp_mmu_enabled = true;
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
-	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 	kvm->arch.tdp_mmu_zap_wq = wq;
 	return 1;
 }
@@ -54,7 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	flush_workqueue(kvm->arch.tdp_mmu_zap_wq);
 	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
 
-	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
+	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
@@ -384,14 +383,17 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 			      bool shared)
 {
+	atomic64_dec(&kvm->arch.tdp_mmu_pages);
+
+	if (!sp->lpage_disallowed)
+		return;
+
 	if (shared)
 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	else
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
-	list_del(&sp->link);
-	if (sp->lpage_disallowed)
-		unaccount_huge_nx_page(kvm, sp);
+	unaccount_huge_nx_page(kvm, sp);
 
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1119,9 +1121,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 		tdp_mmu_set_spte(kvm, iter, spte);
 	}
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	atomic64_inc(&kvm->arch.tdp_mmu_pages);
 
 	return 0;
 }

base-commit: 88d1a6895b71b580b8fc98c23824aafa49d4948e
-- 
2.35.1.1094.g7c7d902a7c-goog


--j3c8VscvnAccrGCY--
