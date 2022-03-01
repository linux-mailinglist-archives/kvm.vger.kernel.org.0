Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9374C9250
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbiCAR6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236516AbiCAR57 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:57:59 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581F45DA76
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:57:18 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id a8so33088195ejc.8
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 09:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c3WCe6YPhsNPb86+PhZQBxqhegDCQ92RBMVqRrYASCk=;
        b=e2WGmHy/xxXYHLCJ/oIMEfHRKsLuoZmGMOs1Ijld4Omd1nthuwT3jT9VSQHp94ZqE5
         YYdiVN142wywas8WXfbTI/aVNuxt4PblNsrFWjm8kt1KKsII61eSE9NKbHbHC/lupsBV
         RRS39ecuzrYw7DqRaSUgg/oEBYArzbmaXpSu2Osst+YIOQ8KQ09/R+PH5/V9gBZs/Cod
         FHipZPJzT+0FJqZTXBqmL8BrzmQzu6nHdsFf9/aj73CnfQ+z03pQ/Doxkf3mNkPFUUTr
         meT7LcAzSbG3i4ifUxrJ1px1ImToMCw446+fev+auqQ7/eo/cgTprGefShtgF2q0lAHu
         SCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c3WCe6YPhsNPb86+PhZQBxqhegDCQ92RBMVqRrYASCk=;
        b=Rs9fC+EJuskmhbx/I1/2q2Sl8Feokca6poLwz/pUlJ2+dH9CmXvk47C9Q7B8r2bMc7
         T1PneQRnIbM5biRZpnhXXsAf5vD93H3m9tAuvS//OHG+SyppPC+98IAdBHtlk+KImF6m
         fzNgZAcUXrC42QpnpTKZYfGkcZu+98r7ZVLpeWOti3V/AjjjANxVVuBBhq8MtyGW7lIc
         bX2HNL+74akoRJvArQEN6S6b2vJmlFtw6oU7NrHDW3NdXxqnWlgTTvwBph0/pvdnJTpd
         YqYK9WgDC58E6KK9GIiZDeqgvlgg+qqcOw3xU5kHPgxu8MGFHqVD3LtjhQcleSClSFc1
         6G5Q==
X-Gm-Message-State: AOAM532DDhGfS4l+Y46vEBDoJGDWmRVbbsVgL1Y8xPi/A7RQkXKYUNSV
        Fk3MyHCL2zs31rZpFNxO69B5gMMk0EkM67O91oSm6g==
X-Google-Smtp-Source: ABdhPJx6NiC03eLaiOd1JPH1zj5W1HAY6SVMujo6GDIuCDgujZ1ZYbC3sF1PQDRMmwWIwyavFsgMIhHwPDZoiNS+Ugg=
X-Received: by 2002:a17:906:459:b0:6cd:2d6d:2f4c with SMTP id
 e25-20020a170906045900b006cd2d6d2f4cmr19302374eja.687.1646157436628; Tue, 01
 Mar 2022 09:57:16 -0800 (PST)
MIME-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com> <20220226001546.360188-23-seanjc@google.com>
In-Reply-To: <20220226001546.360188-23-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 1 Mar 2022 09:57:05 -0800
Message-ID: <CANgfPd_JXJOYhMGKTHfZM0f1x_KpOzJi8fKVv9awLbbpoHdOMw@mail.gmail.com>
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via asynchronous worker
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 4:16 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Zap defunct roots, a.k.a. roots that have been invalidated after their
> last reference was initially dropped, asynchronously via the system work
> queue instead of forcing the work upon the unfortunate task that happened
> to drop the last reference.
>
> If a vCPU task drops the last reference, the vCPU is effectively blocked
> by the host for the entire duration of the zap.  If the root being zapped
> happens be fully populated with 4kb leaf SPTEs, e.g. due to dirty logging
> being active, the zap can take several hundred seconds.  Unsurprisingly,
> most guests are unhappy if a vCPU disappears for hundreds of seconds.
>
> E.g. running a synthetic selftest that triggers a vCPU root zap with
> ~64tb of guest memory and 4kb SPTEs blocks the vCPU for 900+ seconds.
> Offloading the zap to a worker drops the block time to <100ms.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu_internal.h |  8 +++-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 65 ++++++++++++++++++++++++++++-----
>  2 files changed, 63 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index be063b6c91b7..1bff453f7cbe 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -65,7 +65,13 @@ struct kvm_mmu_page {
>                 struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
>                 tdp_ptep_t ptep;
>         };
> -       DECLARE_BITMAP(unsync_child_bitmap, 512);
> +       union {
> +               DECLARE_BITMAP(unsync_child_bitmap, 512);
> +               struct {
> +                       struct work_struct tdp_mmu_async_work;
> +                       void *tdp_mmu_async_data;
> +               };
> +       };

At some point (probably not in this series since it's so long already)
it would be good to organize kvm_mmu_page. It looks like we've got
quite a few anonymous unions in there for TDP / Shadow MMU fields.

>
>         struct list_head lpage_disallowed_link;
>  #ifdef CONFIG_X86_32
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index ec28a88c6376..4151e61245a7 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -81,6 +81,38 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
>  static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>                              bool shared);
>
> +static void tdp_mmu_zap_root_async(struct work_struct *work)
> +{
> +       struct kvm_mmu_page *root = container_of(work, struct kvm_mmu_page,
> +                                                tdp_mmu_async_work);
> +       struct kvm *kvm = root->tdp_mmu_async_data;
> +
> +       read_lock(&kvm->mmu_lock);
> +
> +       /*
> +        * A TLB flush is not necessary as KVM performs a local TLB flush when
> +        * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
> +        * to a different pCPU.  Note, the local TLB flush on reuse also
> +        * invalidates any paging-structure-cache entries, i.e. TLB entries for
> +        * intermediate paging structures, that may be zapped, as such entries
> +        * are associated with the ASID on both VMX and SVM.
> +        */
> +       tdp_mmu_zap_root(kvm, root, true);
> +
> +       /*
> +        * Drop the refcount using kvm_tdp_mmu_put_root() to test its logic for
> +        * avoiding an infinite loop.  By design, the root is reachable while
> +        * it's being asynchronously zapped, thus a different task can put its
> +        * last reference, i.e. flowing through kvm_tdp_mmu_put_root() for an
> +        * asynchronously zapped root is unavoidable.
> +        */
> +       kvm_tdp_mmu_put_root(kvm, root, true);
> +
> +       read_unlock(&kvm->mmu_lock);
> +
> +       kvm_put_kvm(kvm);
> +}
> +
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>                           bool shared)
>  {
> @@ -142,15 +174,26 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>         refcount_set(&root->tdp_mmu_root_count, 1);
>
>         /*
> -        * Zap the root, then put the refcount "acquired" above.   Recursively
> -        * call kvm_tdp_mmu_put_root() to test the above logic for avoiding an
> -        * infinite loop by freeing invalid roots.  By design, the root is
> -        * reachable while it's being zapped, thus a different task can put its
> -        * last reference, i.e. flowing through kvm_tdp_mmu_put_root() for a
> -        * defunct root is unavoidable.
> +        * Attempt to acquire a reference to KVM itself.  If KVM is alive, then
> +        * zap the root asynchronously in a worker, otherwise it must be zapped
> +        * directly here.  Wait to do this check until after the refcount is
> +        * reset so that tdp_mmu_zap_root() can safely yield.
> +        *
> +        * In both flows, zap the root, then put the refcount "acquired" above.
> +        * When putting the reference, use kvm_tdp_mmu_put_root() to test the
> +        * above logic for avoiding an infinite loop by freeing invalid roots.
> +        * By design, the root is reachable while it's being zapped, thus a
> +        * different task can put its last reference, i.e. flowing through
> +        * kvm_tdp_mmu_put_root() for a defunct root is unavoidable.
>          */
> -       tdp_mmu_zap_root(kvm, root, shared);
> -       kvm_tdp_mmu_put_root(kvm, root, shared);
> +       if (kvm_get_kvm_safe(kvm)) {
> +               root->tdp_mmu_async_data = kvm;
> +               INIT_WORK(&root->tdp_mmu_async_work, tdp_mmu_zap_root_async);
> +               schedule_work(&root->tdp_mmu_async_work);
> +       } else {
> +               tdp_mmu_zap_root(kvm, root, shared);
> +               kvm_tdp_mmu_put_root(kvm, root, shared);
> +       }
>  }
>
>  enum tdp_mmu_roots_iter_type {
> @@ -954,7 +997,11 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>
>         /*
>          * Zap all roots, including invalid roots, as all SPTEs must be dropped
> -        * before returning to the caller.
> +        * before returning to the caller.  Zap directly even if the root is
> +        * also being zapped by a worker.  Walking zapped top-level SPTEs isn't
> +        * all that expensive and mmu_lock is already held, which means the
> +        * worker has yielded, i.e. flushing the work instead of zapping here
> +        * isn't guaranteed to be any faster.
>          *
>          * A TLB flush is unnecessary, KVM zaps everything if and only the VM
>          * is being destroyed or the userspace VMM has exited.  In both cases,
> --
> 2.35.1.574.g5d30c73bfb-goog
>
