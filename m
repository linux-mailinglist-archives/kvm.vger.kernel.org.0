Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C6251C529
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 18:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382011AbiEEQel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 12:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244089AbiEEQek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 12:34:40 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C36F5419E
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 09:31:00 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id r9so4651047pjo.5
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 09:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v9OcuXb9vFCkW+RJjZNp2f7Wxc2CJq8/73BL58AUb1Y=;
        b=CfQPl9zIqEqyrneW7slih37AsNDG3C4Yt86bIfhHoUSWlAqxd9VZsBq1tIr91BD3Gw
         5lJ2J3XGN7F80FeT3tHzXA2z6BwDXmS+TQH9zQk+wp3ML8T3ce0Gb+dxsNvpBUkA/m25
         oelaYhJku2SSImqmN86k0tnG9hRjJtLwGK4dNMUgFDQ/78ywrnk8B5FrIl7RFc6Ip0lp
         RUMo8TbMUf+Zr7SRLJ4o5kd/xlnpgOAu4HAJjzeYQ/AQTbq5sUAiozxRq4ISYkMls5xe
         00WUrAdDbdSNLPqmDK3R05epOuKaXbQMBnDn8/SZxx1+uOOJfRh3BLlNf9CXPfRgucVu
         lFaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v9OcuXb9vFCkW+RJjZNp2f7Wxc2CJq8/73BL58AUb1Y=;
        b=5GASW9VsfVLbTm/wBqGfPfThjMIUPuCj7c+93dqXeJ12vDnV4Cv1nKZ7TJCq2dwDQS
         CYG04ZBSaI1qYCTH7ezwnaVNUEW7QrHrMdSfZKA9dyMdHxiLSNyDjzzO92b/ggJBrCdN
         4EZK1ORF3KBCNqI+QW949N/z5MYG+1bOazkrP9EHxoFwRSOqsnsnH4nfAC+wo9+NBgEK
         5TwnXYGVKJONpAyXGWLryDkPK1D9x/VJN1xS8J2cx8MXIF9R5hIXHbzkL1krTFambOwn
         zESx7SXNK+UM4XFvDJeVVMQgzIPOxbvoI6ter7BOQ8O5MR0USchrlSEosAL2/L4x5vKI
         NthA==
X-Gm-Message-State: AOAM53329sN2HuL8y2NRu+edpvPyRcXesNzkVkM85FyJoTfFK0GSCk4N
        lrp7jpVI8f1b0NxxQIMmAzj2fQ==
X-Google-Smtp-Source: ABdhPJyPgmuNVn9/GTEDuPTE+EjZqvCDEfBpij2BKs2l/YSZJTlAJ5JUC4ICAf4B+LBTEGWM2diwtw==
X-Received: by 2002:a17:90a:170c:b0:1dc:20c4:6354 with SMTP id z12-20020a17090a170c00b001dc20c46354mr7134882pjd.113.1651768259547;
        Thu, 05 May 2022 09:30:59 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902c14600b0015e8d4eb23bsm1750865plj.133.2022.05.05.09.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 09:30:58 -0700 (PDT)
Date:   Thu, 5 May 2022 16:30:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        bgardon@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] KVM: x86/mmu: Remove KVM memory shrinker
Message-ID: <YnP7v0osIshCIPZH@google.com>
References: <20220503221357.943536-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503221357.943536-1-vipinsh@google.com>
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

On Tue, May 03, 2022, Vipin Sharma wrote:
> KVM memory shrinker is only used in the shadow paging. Most of the L1
> guests are backed by TDP (Two Dimensional Paging) which do not use the
> shrinker, only L2 guests are backed by shadow paging.

Nit, the TDP MMU doesn't use the shrinker, but legacy MMU, which supports TDP,
does.

> KVM memory shrinker can cause guests performance to degrade if any other
> process (VM or non-VM) in the same or different cgroup in kernel causes
> memory shrinker to run.

Ah, but digging into this aspect reveals that per-memcg shrinkers were added in
2015 by commit cb731d6c62bb ("vmscan: per memory cgroup slab shrinkers").  I
haven't dug too deep, but presumably it wouldn't be all that difficult to support
SHRINKER_MEMCG_AWARE in KVM.  That's quite tempting to support as it would/could
guard against an unintentional DoS of sorts against L1 from L2, e.g. if L1 doesn't
cap the number of TDP SPTEs it creates (*cough* TDP MMU *cough*) and ends up
creating a large number of SPTEs for L2.  IIUC, that sort of scenario was the
primary motivation for commit 2de4085cccea ("KVM: x86/MMU: Recursively zap nested
TDP SPs when zapping last/only parent").

> The KVM memory shrinker was introduced in 2008,
> commit 3ee16c814511 ("KVM: MMU: allow the vm to shrink the kvm mmu
> shadow caches"), each invocation of shrinker only released 1 shadow page
> in 1 VM. This behavior was not effective until the batch zapping commit
> was added in 2020, commit ebdb292dac79 ("KVM: x86/mmu: Batch zap MMU
> pages when shrinking the slab"), which zaps multiple pages but still in
> 1 VM for each shrink invocation. Overall, this feature existed for many
> years without providing meaningful benefit.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 99 ++----------------------------------------
>  1 file changed, 3 insertions(+), 96 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4e8d546431eb..80618c847ce2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -178,7 +178,6 @@ struct kvm_shadow_walk_iterator {
>  
>  static struct kmem_cache *pte_list_desc_cache;
>  struct kmem_cache *mmu_page_header_cache;
> -static struct percpu_counter kvm_total_used_mmu_pages;
>  
>  static void mmu_spte_set(u64 *sptep, u64 spte);
>  
> @@ -1658,16 +1657,9 @@ static int is_empty_shadow_page(u64 *spt)
>  }
>  #endif
>  
> -/*
> - * This value is the sum of all of the kvm instances's
> - * kvm->arch.n_used_mmu_pages values.  We need a global,
> - * aggregate version in order to make the slab shrinker
> - * faster
> - */
> -static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
> +static inline void kvm_used_mmu_pages(struct kvm *kvm, long nr)

This rename is unnecessary, and I much prefer the existing name, kvm_used_mmu_pages()
sounds like an accessor to get the number of used pages.

>  {
>  	kvm->arch.n_used_mmu_pages += nr;
> -	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
>  }
>  
>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)

...

> -static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
> -{
> -	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
> -}

zapped_obsolete_pages can be dropped, its sole purposed was to expose those pages
to the shrinker.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c59fea4bdb6e..15b71de6f6fe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1065,7 +1065,6 @@ struct kvm_arch {
        u8 mmu_valid_gen;
        struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
        struct list_head active_mmu_pages;
-       struct list_head zapped_obsolete_pages;
        struct list_head lpage_disallowed_mmu_pages;
        struct kvm_page_track_notifier_node mmu_sp_tracker;
        struct kvm_page_track_notifier_head track_notifier_head;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 51443a8e779a..299c9297418e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5657,6 +5657,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
        struct kvm_mmu_page *sp, *node;
        int nr_zapped, batch = 0;
+       LIST_HEAD(zapped_pages);

 restart:
        list_for_each_entry_safe_reverse(sp, node,
@@ -5688,8 +5689,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
                        goto restart;
                }

-               if (__kvm_mmu_prepare_zap_page(kvm, sp,
-                               &kvm->arch.zapped_obsolete_pages, &nr_zapped)) {
+               if (__kvm_mmu_prepare_zap_page(kvm, sp, &zapped_pages, &nr_zapped)) {
                        batch += nr_zapped;
                        goto restart;
                }
@@ -5704,7 +5704,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
         * kvm_mmu_load()), and the reload in the caller ensure no vCPUs are
         * running with an obsolete MMU.
         */
-       kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
+       kvm_mmu_commit_zap_page(kvm, &zapped_pages);
 }

 /*
@@ -5780,7 +5780,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
        int r;

        INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
-       INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
        INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
        spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);


