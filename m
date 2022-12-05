Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77475642FE3
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 19:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbiLESYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 13:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiLESYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 13:24:33 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52634209AE
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 10:24:32 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id z17so5655084qki.11
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 10:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2P9EsS2tsbUaY4dcD49BmgQjZYX6Yb1webDSZ03mbXw=;
        b=tSik+6xRk+SrYoWiJnRXnocphBDMpyh53ucwgGxIO7ZFeAEqD7VHCaOjr38zARzj8I
         r2bVblVctpS7IbK6mkamgY7TJI9Rm6g86zEa38nBYh2LD5/Ere8TbLF4Q9qzqZWIu8ND
         it+xe0OtYzmqqYhGr+4ZfgCBVkMztqbfLFMz/v5rPBKCmz9IS30QQcP/hF2+y/nX/X43
         MaiL+peuROUFwTdNTjnDEUIIPp+nNKkaDs62xKBzhLZEBHhq448QoENSNoDXt1Q45/RZ
         8hZ96cqDmRYB2OEqRIsrDQaLE7+s+6Vv0Q+mYPXT1W5J+/b2hH0Wn3YQ7IR4FW4y30Fg
         eLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2P9EsS2tsbUaY4dcD49BmgQjZYX6Yb1webDSZ03mbXw=;
        b=sawzOK+XiOzRKMGlcRP6Nv4YbRUisJ8MN7Okw0/wkGmeKY18bK18jvtJetcxyAW75g
         LqAhcu9uOH3EQrXH8qvWBpdIQSZbbr9V4xOkUcYhaZmnGNJ2orEI8pzkMlJOle/rveh8
         6ceA/OfKwqy+lEzwMENX1u1whFsMh6zOjamLuz9i0JYWe4LMTj2iCmX80hcwpJ70XLUr
         5mvyM96sRq67ZpnWIGjalidiZychvLY128NzIC+a5aUQsxdmMfS2lmrX4qV81XsaLScy
         a5Kh6myUrfIb6OIIyr1cWmOqKe+B39yPxkYhZ4+3QYs7+a6t5mUvCDJvlZxNWNJn3w2K
         9vCQ==
X-Gm-Message-State: ANoB5pl0sJR3hHApF8GK14Cw5/ySD39JpJouYOm43FlJWnC90yMNx9RB
        gm/KM4FTnA+fkNVQp6o3C+TxkVUWUyikhmIDQqutGA==
X-Google-Smtp-Source: AA0mqf5Hb1GPcOEkgj/1xs5WXa3rdESQFMj847BK6VJDMjvdE2UYWIz8hpSJQF9ggzYC8A83Ji4eerK6Ajeyuyhspg8=
X-Received: by 2002:a37:464b:0:b0:6fa:3431:1f2f with SMTP id
 t72-20020a37464b000000b006fa34311f2fmr59252381qka.81.1670264671267; Mon, 05
 Dec 2022 10:24:31 -0800 (PST)
MIME-Version: 1.0
References: <20221201195718.1409782-1-vipinsh@google.com> <20221201195718.1409782-2-vipinsh@google.com>
In-Reply-To: <20221201195718.1409782-2-vipinsh@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 5 Dec 2022 10:24:20 -0800
Message-ID: <CANgfPd_sZoW6gRNgs44BbBu4RhwqNPjUO-=biJ++L5d8LpU3zg@mail.gmail.com>
Subject: Re: [Patch v2 1/2] KVM: x86/mmu: Allocate page table pages on TDP
 splits during dirty log enable on the underlying page's numa node
To:     Vipin Sharma <vipinsh@google.com>
Cc:     dmatlack@google.com, seanjc@google.com, pbonzini@redhat.com,
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

On Thu, Dec 1, 2022 at 11:57 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> Huge pages are split when dirty log is enabled. New page table pages are
> allocated based on the current thread NUMA node or mempolicy. This
> causes inefficient page table accesses if underlying page is on a
> different NUMA node
>
> Allocate page table pages on the same NUMA node as the underlying huge
> page when dirty log is enabled and huge pages are split.
>
> The performance gain during the pre-copy phase of live migrations of a
> 416 vCPUs and 11 TiB memory VM  on a 8 node host was seen in the range
> of 130% to 150%.
>
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/kvm/mmu.h         |  1 +
>  arch/x86/kvm/mmu/mmu.c     | 19 +++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++----
>  include/linux/kvm_host.h   | 15 +++++++++++++++
>  4 files changed, 43 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 6bdaacb6faa0..c960fb096e5c 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -119,6 +119,7 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu);
>  void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu);
>  void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
>  void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
> +void *kvm_mmu_get_free_page(int nid, gfp_t gfp);
>
>  static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4736d7849c60..0554dfc55553 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -90,6 +90,9 @@ __MODULE_PARM_TYPE(nx_huge_pages_recovery_period_ms, "uint");
>  static bool __read_mostly force_flush_and_sync_on_reuse;
>  module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
>
> +static bool __read_mostly numa_aware_pagetable = true;
> +module_param_named(numa_aware_pagetable, numa_aware_pagetable, bool, 0644);
> +

I'm usually all for having module params to control things, but in
this case I don't think it provides much value because whether this
NUMA optimization is useful or not is going to depend more on VM size
and workload than anything else. If we wanted to make this
configurable, a VM capability would probably be a better mechanism so
that userspace could leave it off when running small,
non-performance-sensitive VMs and turn it on when running large,
multi-node VMs. A whole-host module parameter seems overly
restrictive.

>  /*
>   * When setting this variable to true it enables Two-Dimensional-Paging
>   * where the hardware walks 2 page tables:
> @@ -6984,3 +6987,19 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
>         if (kvm->arch.nx_huge_page_recovery_thread)
>                 kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
>  }
> +
> +void *kvm_mmu_get_free_page(int nid, gfp_t gfp)
> +{
> +       struct page *spt_page;
> +       void *address = NULL;
> +
> +       if (numa_aware_pagetable) {
> +               spt_page = alloc_pages_node(nid, gfp, 0);
> +               if (spt_page)
> +                       address = page_address(spt_page);
> +       } else {
> +               address = (void *)__get_free_page(gfp);
> +       }
> +
> +       return address;
> +}
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 771210ce5181..1607afbfcc0b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1413,7 +1413,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>         return spte_set;
>  }
>
> -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(int nid, gfp_t gfp)
>  {
>         struct kvm_mmu_page *sp;
>
> @@ -1423,7 +1423,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
>         if (!sp)
>                 return NULL;
>
> -       sp->spt = (void *)__get_free_page(gfp);
> +       sp->spt = kvm_mmu_get_free_page(nid, gfp);
> +
>         if (!sp->spt) {
>                 kmem_cache_free(mmu_page_header_cache, sp);
>                 return NULL;
> @@ -1437,6 +1438,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>                                                        bool shared)
>  {
>         struct kvm_mmu_page *sp;
> +       int nid;
> +
> +       nid = kvm_pfn_to_refcounted_page_nid(spte_to_pfn(iter->old_spte));
>
>         /*
>          * Since we are allocating while under the MMU lock we have to be
> @@ -1447,7 +1451,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>          * If this allocation fails we drop the lock and retry with reclaim
>          * allowed.
>          */
> -       sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
> +       sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_NOWAIT | __GFP_ACCOUNT);
>         if (sp)
>                 return sp;
>
> @@ -1459,7 +1463,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>                 write_unlock(&kvm->mmu_lock);
>
>         iter->yielded = true;
> -       sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
> +       sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_KERNEL_ACCOUNT);
>
>         if (shared)
>                 read_lock(&kvm->mmu_lock);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8f874a964313..558ded73f660 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1596,6 +1596,21 @@ void kvm_arch_sync_events(struct kvm *kvm);
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
>
>  struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn);
> +
> +/*
> + * Returns the nid of a 'struct page' if pfn is valid and backed by a refcounted
> + * page, NUMA_NO_NODE otherwise.
> + */
> +static inline int kvm_pfn_to_refcounted_page_nid(kvm_pfn_t pfn)
> +{
> +       struct page *page = kvm_pfn_to_refcounted_page(pfn);
> +
> +       if (page)
> +               return page_to_nid(page);
> +       else
> +               return NUMA_NO_NODE;
> +}
> +
>  bool kvm_is_zone_device_page(struct page *page);
>
>  struct kvm_irq_ack_notifier {
> --
> 2.39.0.rc0.267.gcb52ba06e7-goog
>
