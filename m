Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D0C656E1E
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 20:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiL0TCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 14:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiL0TCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 14:02:49 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF572D108
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 11:02:48 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g1so5945117edj.8
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 11:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O0p+ppNOGRKb/NOMxrUDYaSzLYMOpLEPChffMwzyD4s=;
        b=G+As5w1O9GJAgcoSWrA1V1BBzCp4+BkPOjQB9qG4fRx7dwEQAqXK8xYYxvvOgFcZIt
         4hMjo/Ckrx//oepVJWG+oBx9wRpONu/UKVWzE8Iwi4VauxCXxC8lCy6OI0Q/jjhX+BWf
         ZaLhfnQcfZWQ/DEFbzeCFUYcT2X+aIEsad4VbI5Pmg+ATzQkoe5xMe8Cmf229TBWVoAV
         wAIHOKQq7zUg3Hj/40JbeWk+DT09nO2Sg6jlT/fp08Gw8gAJ6g2xIKZHcWjzaIeIprgn
         7dXxfdxKgZ5pGaPhrLMuW+7FinDO9XBlyfJMzZHReg9OFaAlYfViqIVKOSlg9Iirj5bC
         KT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O0p+ppNOGRKb/NOMxrUDYaSzLYMOpLEPChffMwzyD4s=;
        b=kXKvfe7bhdIX4e7Kk/Gb76sxbYnk4pMJv7N5EsTEjHM3svP1hcrBS4EYWcq7//w9aB
         XkanRy17amagMp7SPGgauZsziYKPXnk4gIelNnNi05SxKX37hrcOpS8Hmlwd3XpyfWeB
         wNj+6G9GZtqA66iqhFm0GI7NZa9d8aUp//LYrkBPuBGHk506Lz61EI5GJ5cIAs4wn5HC
         hW+GalO528JA22KuF2i8ycUTwTL0PYPrcEivDdRAEC6+W2PZYEFcpFnwiVuyrV6npTqF
         nzZSgCiiW8KtI3zdBHyI4E3f6D/NtfNyI0w6Q2R3CRoi2vIyd8HnnH6IofpgnnbpZo+w
         Gv7A==
X-Gm-Message-State: AFqh2ko4OtlQzxb5Jj1aB4cno/Oh0IUga6aJNJv0HLKWLUE+W7GUrY4M
        kq+QVNGfFWVpCtZHDpZ3LGaTFZ4wNAo+N0lU1ZJuoQ==
X-Google-Smtp-Source: AMrXdXvi6hRJf+bFZ47VpANM/2xs3vP25zTe6ZAc9vU4JEzmbdcfZ4YfBsh1C7oaOLY/tye78AWCvC9kVBtXX+D2emU=
X-Received: by 2002:a05:6402:204d:b0:471:c322:ce41 with SMTP id
 bc13-20020a056402204d00b00471c322ce41mr1566013edb.4.1672167767277; Tue, 27
 Dec 2022 11:02:47 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-6-vipinsh@google.com>
In-Reply-To: <20221222023457.1764-6-vipinsh@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 27 Dec 2022 11:02:35 -0800
Message-ID: <CANgfPd-x+w8DnyfnLeMCWApbNyAbxOdS8e-nhoSq7txSu2mHXA@mail.gmail.com>
Subject: Re: [Patch v3 5/9] KVM: x86/mmu: Allocate TDP page table's page on
 correct NUMA node on split
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 6:35 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> When dirty log is enabled, huge pages are split. Page table's pages

Nit: Suggest "When huge pages are split for dirty log" since this can
happen at various points during dirty logging.
Same below.

> during the split are allocated based on the current thread NUMA node or
> mempolicy. This causes inefficient page table accesses if underlying
> page is on a different NUMA node
>
> Allocate page table's pages on the same NUMA node as the underlying huge
> page when dirty log is enabled and huge pages are split.
>
> The performance gain during the pre-copy phase of live migrations of a
> 416 vCPUs and 11 TiB memory VM  on a 8 node host was seen in the range
> of 130% to 150%.
>
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++----
>  include/linux/kvm_host.h   | 18 ++++++++++++++++++
>  2 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4974fa96deff..376b8dceb3f9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1403,7 +1403,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>         return spte_set;
>  }
>
> -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(int nid, gfp_t gfp)
>  {
>         struct kvm_mmu_page *sp;
>
> @@ -1413,7 +1413,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
>         if (!sp)
>                 return NULL;
>
> -       sp->spt = (void *)__get_free_page(gfp);
> +       sp->spt = kvm_mmu_get_free_page(nid, gfp);
> +

Just so that kvm_mmu_get_free_page isn't dead code in the previous
commit, I'd do this refactor there and just pass NUMA_NO_NODE here.

>         if (!sp->spt) {
>                 kmem_cache_free(mmu_page_header_cache, sp);
>                 return NULL;
> @@ -1427,6 +1428,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>                                                        bool shared)
>  {
>         struct kvm_mmu_page *sp;
> +       int nid;
> +
> +       nid = kvm_pfn_to_page_table_nid(spte_to_pfn(iter->old_spte));
>
>         /*
>          * Since we are allocating while under the MMU lock we have to be
> @@ -1437,7 +1441,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>          * If this allocation fails we drop the lock and retry with reclaim
>          * allowed.
>          */
> -       sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
> +       sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_NOWAIT | __GFP_ACCOUNT);
>         if (sp)
>                 return sp;
>
> @@ -1449,7 +1453,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>                 write_unlock(&kvm->mmu_lock);
>
>         iter->yielded = true;
> -       sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
> +       sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_KERNEL_ACCOUNT);
>
>         if (shared)
>                 read_lock(&kvm->mmu_lock);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d48064503b88..a262e15ebd19 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1583,6 +1583,24 @@ void kvm_arch_sync_events(struct kvm *kvm);
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
>
>  struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn);
> +
> +/*
> + * Tells the appropriate NUMA node location of the page table's page based on
> + * pfn it will point to.
> + *
> + * Return the nid of the page if pfn is valid and backed by a refcounted page,
> + * otherwise, return the nearest memory node for the current CPU.

Nit: Should this be "current thread"?

> + */
> +static inline int kvm_pfn_to_page_table_nid(kvm_pfn_t pfn)

This could just be kvm_pfn_nid (or even better kvm_pfn_node_id) since
this really has nothing to do with page tables. We just want to know
which NUMA node backs the given PFN.

> +{
> +       struct page *page = kvm_pfn_to_refcounted_page(pfn);
> +
> +       if (page)
> +               return page_to_nid(page);
> +       else
> +               return numa_mem_id();
> +}
> +
>  bool kvm_is_zone_device_page(struct page *page);
>
>  struct kvm_irq_ack_notifier {
> --
> 2.39.0.314.g84b9a713c41-goog
>
