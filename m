Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EE04E8A16
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 22:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiC0UpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 16:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbiC0UpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 16:45:05 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0869BDF99
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 13:43:25 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id v15so10004581qkg.8
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 13:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lxxWCgHNZWMKU7Ny0DjHsf3s23oLRkOVPRxextG00dE=;
        b=L1ycbZtxsJPB1/9Xzl57OFyZ9e/gQCmZZqnt/vydyIrcYblpWF2xhXnkjCMSu6UAEY
         bg6QxzjfKvbLXfY7nhCjm2EyQtrkUw52YXV9DrL7avOZLCN8j5kDZ70/hBdfA3BFCmGA
         M+j80QhoRvKqBiwvLr8UwBWbNO2feRpAAerOS5pADwR3RTISxENL04qDF1ugcGkPCMgW
         ATYf2udq5wwiyBJcZjNL5plgNZNuYpUAZApojMYxwBcQcIeinwkFFSegnQQfTKPhirGN
         Xn069vC2v7/AoPt4lX5LhwAvp5blbRNeY2Lk3dWx8nD9th45DD/kZ0vTKq0jEEZBLk6P
         8wKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lxxWCgHNZWMKU7Ny0DjHsf3s23oLRkOVPRxextG00dE=;
        b=ktZTOX7UoyFsRdg0m6er8Su+txzj8cHlEGdGGvys4dEdkMyBDrWg4ps9x1YhiayB3i
         Res/nrJakOPLtvW7DYCt9oPfPqlXkCA6nQJY3f952c1TOiUYZlRjKXivX4IFW89adM9D
         pwKdhJvsYHGnRI9vm9w043UMV9DUCeogswTrfV66pfZabSkzloL85YlQBUhVVF8N3ESq
         7QKlmPGGEmkjw/vp7FHr1CeoeG1xgaLra4T242saLYZ7K5/HMWfiscvPyzcxt9n/LWzl
         7/IWBv0ijuRWyVc1yLKnkP21uZKcrglY/4GswToOGiOSZgsYCu3fCN9eI1fIq+rMuZa8
         p5RQ==
X-Gm-Message-State: AOAM5328fb4MQiC2bbJzqOjFAIW59IMNvHSlUnXQPFr31i5aaw9zqNBH
        T5BKM9KJ/l+QMEw1gJv6HVo8wOLDh/vXmt/ILK61Sw==
X-Google-Smtp-Source: ABdhPJxWhHAdX8JHUz3VoU5Awi9+MR8BZCYkOxNkxXIJm7hc4e69+97wtCO+GmAbQG1JFE3nsaBv7m4kHeaUNjsgF9M=
X-Received: by 2002:a37:6784:0:b0:67b:32b3:ba71 with SMTP id
 b126-20020a376784000000b0067b32b3ba71mr13989523qkc.595.1648413804527; Sun, 27
 Mar 2022 13:43:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220327203532.407821-1-mizhang@google.com>
In-Reply-To: <20220327203532.407821-1-mizhang@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Sun, 27 Mar 2022 13:43:13 -0700
Message-ID: <CAL715W+ftVzqBizAwZNZhmn5F8kRCF==eN+xjc+0KuSEmqm5Mw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: add lockdep check before lookup_address_in_mm()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
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

Please ignore this one and will provide an updated patch shortly.

On Sun, Mar 27, 2022 at 1:35 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> Add a lockdep check before invoking lookup_address_in_mm().
> lookup_address_in_mm() walks all levels of host page table without
> accquiring any lock. This is usually unsafe unless we are walking the
> kernel addresses (check other usage cases of lookup_address_in_mm and
> lookup_address_in_pgd).
>
> Walking host page table (especially guest addresses) usually requires
> holding two types of locks: 1) mmu_lock in mm or the lock that protects
> the reverse maps of host memory in range; 2) lock for the leaf paging
> structures.
>
> One exception case is when we take the mmu_lock of the secondary mmu.
> Holding mmu_lock of KVM MMU in either read mode or write mode prevents host
> level entities from modifying the host page table concurrently. This is
> because all of them will have to invoke KVM mmu_notifier first before doing
> the actual work. Since KVM mmu_notifier invalidation operations always take
> the mmu write lock, we are safe if we hold the mmu lock here.
>
> Note: this means that KVM cannot allow concurrent multiple mmu_notifier
> invalidation callbacks by using KVM mmu read lock. Since, otherwise, any
> host level entity can cause race conditions with this one. Walking host
> page table here may get us stale information or may trigger NULL ptr
> dereference that is hard to reproduce.
>
> Having a lockdep check here will prevent or at least warn future
> development that directly walks host page table simply in a KVM ioctl
> function. In addition, it provides a record for any future development on
> KVM mmu_notifier.
>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: David Matlack <dmatlack@google.com>
>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1361eb4599b4..342aa184c0a2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2820,6 +2820,24 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>          */
>         hva = __gfn_to_hva_memslot(slot, gfn);
>
> +       /*
> +        * lookup_address_in_mm() walks all levels of host page table without
> +        * accquiring any lock. This is not safe when KVM does not take the
> +        * mmu_lock. Holding mmu_lock in either read mode or write mode prevents
> +        * host level entities from modifying the host page table. This is
> +        * because all of them will have to invoke KVM mmu_notifier first before
> +        * doing the actual work. Since KVM mmu_notifier invalidation operations
> +        * always take the mmu write lock, we are safe if we hold the mmu lock
> +        * here.
> +        *
> +        * Note: this means that KVM cannot allow concurrent multiple
> +        * mmu_notifier invalidation callbacks by using KVM mmu read lock.
> +        * Otherwise, any host level entity can cause race conditions with this
> +        * one. Walking host page table here may get us stale information or may
> +        * trigger NULL ptr dereference that is hard to reproduce.
> +        */
> +       lockdep_is_held(kvm->mmu_lock);
> +
>         pte = lookup_address_in_mm(kvm->mm, hva, &level);
>         if (unlikely(!pte))
>                 return PG_LEVEL_4K;
> --
> 2.35.1.1021.g381101b075-goog
>
