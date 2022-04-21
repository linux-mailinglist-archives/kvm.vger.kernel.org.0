Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C765F50A5E6
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiDUQi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiDUQi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:38:28 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8D2E09C
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:35:38 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id r189so9738742ybr.6
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2o+bfoCrm9ENS05/J4NbbBTAqkMpAlAf6csqUjQGcTQ=;
        b=m/ShF2lo3xbNaf8VAl5+Uia+xkKXoGYXilGMMPwqyh4OC1sg7+KDOMh6T+lZnC0GyF
         DzuRd+Q9l56n1anfHL3gafeiHNO9sqQFiwhwYqgFnyZD1d44XVjWjPeJReCzH6pf/7nk
         OkhzFnLO5KjRVIk+br7E9CWH0wsyQPfn+Qu35KvWTakz78FDeUTIA1x4Zf2NTGqhzIEU
         4cM2K7uY+ftNRBqv9Ws0GFb2BjQ4IQb/si+kZwf4AmjOp4iFOS+BIVNEWsdAXZv42qQY
         zCynBapR/RnINkNzeB4scrWsZoWDO/jSR7bGrk8hKVaJmERoTVg9RpO0RY7IjjCisuoU
         N0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2o+bfoCrm9ENS05/J4NbbBTAqkMpAlAf6csqUjQGcTQ=;
        b=dxhv+FeEZeqxRZLvIDU0loD0ROXmamNQb4RqbKO4alvTiv1ClOQRYo87pYBTbwfk2W
         2VP6v5Vr7ZzL8uuoMHqtd0OyYUL6gVqNk/bNnaODwMJRH9zA/m/Uyu8IMImtEuvmZynl
         xPa/pCDWwM0zRfzhCmy8CcHZbSn+YV6Uq/ZNSsFLhMxfWAqXniRg+FDWqTnM2gIE/CSM
         Scq1HJpi6vNbyPmng1egWtC7p04ALQBpsw7/KL/ZC2kpC2xzKSAjBjAQSTjTFxAB6ZU8
         n+gjRvsJ/4ZbWfO35wTVprr1KCTmwYI6P8T6VbilLPUYnlGjvPs/YXoa+2jx0Gd6cIV4
         2UNA==
X-Gm-Message-State: AOAM532SERAecjTnWLY7lNTymPtxx3o+0Tm6MLEwhREv5MVh60tDRoK1
        hI/ufko8bfonqinsr+R6JI+bmfz7uMyRzLYQbjAR2A==
X-Google-Smtp-Source: ABdhPJwQjb989eibb7OonB7D8gVNlF36degE7seajBqNLXdn06AMKJRHpNLrwXdZytOXmLLJ77afmYHmHe7MXZNMyss=
X-Received: by 2002:a25:4094:0:b0:641:2b90:3b1a with SMTP id
 n142-20020a254094000000b006412b903b1amr568265yba.8.1650558937838; Thu, 21 Apr
 2022 09:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com> <20220415215901.1737897-17-oupton@google.com>
In-Reply-To: <20220415215901.1737897-17-oupton@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 21 Apr 2022 09:35:27 -0700
Message-ID: <CANgfPd9bb213hsdKTMW9K0EsVLuKEKCF8V0pb6xM1qfnRj1qfw@mail.gmail.com>
Subject: Re: [RFC PATCH 16/17] KVM: arm64: Enable parallel stage 2 MMU faults
To:     Oliver Upton <oupton@google.com>
Cc:     "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
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

On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
>
> Voila! Since the map walkers are able to work in parallel there is no
> need to take the write lock on a stage 2 memory abort. Relax locking
> on map operations and cross fingers we got it right.

Might be worth a healthy sprinkle of lockdep on the functions taking
"shared" as an argument, just to make sure the wrong value isn't going
down a callstack you didn't expect.

>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 21 +++------------------
>  1 file changed, 3 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 63cf18cdb978..2881051c3743 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1127,7 +1127,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         gfn_t gfn;
>         kvm_pfn_t pfn;
>         bool logging_active = memslot_is_logging(memslot);
> -       bool use_read_lock = false;
>         unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
>         unsigned long vma_pagesize, fault_granule;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> @@ -1162,8 +1161,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (logging_active) {
>                 force_pte = true;
>                 vma_shift = PAGE_SHIFT;
> -               use_read_lock = (fault_status == FSC_PERM && write_fault &&
> -                                fault_granule == PAGE_SIZE);
>         } else {
>                 vma_shift = get_vma_page_shift(vma, hva);
>         }
> @@ -1267,15 +1264,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (exec_fault && device)
>                 return -ENOEXEC;
>
> -       /*
> -        * To reduce MMU contentions and enhance concurrency during dirty
> -        * logging dirty logging, only acquire read lock for permission
> -        * relaxation.
> -        */
> -       if (use_read_lock)
> -               read_lock(&kvm->mmu_lock);
> -       else
> -               write_lock(&kvm->mmu_lock);
> +       read_lock(&kvm->mmu_lock);
> +

Ugh, I which we could get rid of the analogous ugly block on x86.

>         pgt = vcpu->arch.hw_mmu->pgt;
>         if (mmu_notifier_retry(kvm, mmu_seq))
>                 goto out_unlock;
> @@ -1322,8 +1312,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
>                 ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
>         } else {
> -               WARN_ONCE(use_read_lock, "Attempted stage-2 map outside of write lock\n");
> -
>                 ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
>                                              __pfn_to_phys(pfn), prot,
>                                              mmu_caches, true);
> @@ -1336,10 +1324,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         }
>
>  out_unlock:
> -       if (use_read_lock)
> -               read_unlock(&kvm->mmu_lock);
> -       else
> -               write_unlock(&kvm->mmu_lock);
> +       read_unlock(&kvm->mmu_lock);
>         kvm_set_pfn_accessed(pfn);
>         kvm_release_pfn_clean(pfn);
>         return ret != -EAGAIN ? ret : 0;
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
