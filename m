Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB0549B4FD
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 14:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1576591AbiAYNZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 08:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576565AbiAYNXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 08:23:13 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F43C0613EE
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 05:23:09 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id q186so30929162oih.8
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 05:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7GmwAVl/MoxtO21S2PDRJaYdqihfLh9OC3HwysJFbw0=;
        b=WlVq3jDd1sN/talTN+PjHAE+iRB0VKvmAISPQE8rRe8S37YJTh0RBYt2JieQifeCAa
         HWv5PZwPzrkyEsY1Q5njf0BKKhGXHs2Q2tT9HFx09ExgnzFzolHuQduy3ZLF5U060d2h
         sHe4T7l3Y3ZMOmXZWTQEcvOnyglrCtYSQ1xk2+WjQ668yJLw09UQe+PYRo2l7vQlvBhU
         Pbl0XB821KS7qZwRVUGHc/buyteH8GAGtiwGDw7zI7fkj+YsBplB1tIcNuFSIxh/Pa2z
         t2PxfZoqMqHwVz0NYrvV5jEKqI8OKrLSR9NohBlBL9Lp3hF0ahOGGPj7FFwQtXG1iA6g
         wB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7GmwAVl/MoxtO21S2PDRJaYdqihfLh9OC3HwysJFbw0=;
        b=EWJn/i43eHG1EOE0dFWlQ/fn+6GV9C/EFxLUIkf9LirpeLJICYB7HAe1wE+ieW5SOI
         UCFT48+tu2N6BieaaL82xkRDRyizoDQKA/rBBRX75xMrU5SmjvlpN9jE2kkLJjfMeGZ9
         D83/rmCPm2pCGI1Lvy4ND+b5WlLpNfSh2gt7lll+LWw0b99HmkFbPRFgbGERH9g/KIf1
         0wODuwkgqWMiL+h2s+U7FjNuNikB4Tw6iKJfErleImbC7Ia01/ksnPpYZC9Vu2yUDa59
         WpQ1eBvLOrTcSmGra4jaWxCWae0d7rh2FUq+eAhB4GGkzbFgtJSMiQ49ScNs/f5E5bvC
         1MEQ==
X-Gm-Message-State: AOAM5317N5MBMo8zVCjiylCWmI7c336NU6ifWJVb1Hv7m1+phiQF82eS
        UHUkBEVxi+sEM2vbspwLJ3Nm7bpfWn5zBnfLYGBJDA==
X-Google-Smtp-Source: ABdhPJyX4G2P+ppGXnVoStTwSV/jbXl0nhjknnUmS2sg5MuTnj6ZZQ/wkq5DHRJ1r54+4zVWfcdBl0EMyblcLO6pZLA=
X-Received: by 2002:a05:6808:ec2:: with SMTP id q2mr621256oiv.124.1643116988604;
 Tue, 25 Jan 2022 05:23:08 -0800 (PST)
MIME-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com> <20220118015703.3630552-3-jingzhangos@google.com>
In-Reply-To: <20220118015703.3630552-3-jingzhangos@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 25 Jan 2022 13:22:32 +0000
Message-ID: <CA+EHjTwskGDoZyh4zJR56feKSCfgsGe3eh3_N1r7BPoVyyrg6Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Add fast path to handle permission
 relaxation during dirty logging
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Tue, Jan 18, 2022 at 1:57 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> To reduce MMU lock contention during dirty logging, all permission
> relaxation operations would be performed under read lock.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index cafd5813c949..10df5d855d54 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1080,6 +1080,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         gfn_t gfn;
>         kvm_pfn_t pfn;
>         bool logging_active = memslot_is_logging(memslot);
> +       bool logging_perm_fault = false;
>         unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
>         unsigned long vma_pagesize, fault_granule;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> @@ -1114,6 +1115,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (logging_active) {
>                 force_pte = true;
>                 vma_shift = PAGE_SHIFT;
> +               logging_perm_fault = (fault_status == FSC_PERM && write_fault);
>         } else {
>                 vma_shift = get_vma_page_shift(vma, hva);
>         }
> @@ -1212,7 +1214,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (exec_fault && device)
>                 return -ENOEXEC;
>
> -       write_lock(&kvm->mmu_lock);
> +       /*
> +        * To reduce MMU contentions and enhance concurrency during dirty
> +        * logging dirty logging, only acquire read lock for permission
> +        * relaxation.
> +        */

A couple of nits:
"dirty logging" is repeated twice
s/contentions/contention

Other than that,

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad






> +       if (logging_perm_fault)
> +               read_lock(&kvm->mmu_lock);
> +       else
> +               write_lock(&kvm->mmu_lock);
>         pgt = vcpu->arch.hw_mmu->pgt;
>         if (mmu_notifier_retry(kvm, mmu_seq))
>                 goto out_unlock;
> @@ -1271,7 +1281,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         }
>
>  out_unlock:
> -       write_unlock(&kvm->mmu_lock);
> +       if (logging_perm_fault)
> +               read_unlock(&kvm->mmu_lock);
> +       else
> +               write_unlock(&kvm->mmu_lock);
>         kvm_set_pfn_accessed(pfn);
>         kvm_release_pfn_clean(pfn);
>         return ret != -EAGAIN ? ret : 0;
> --
> 2.34.1.703.g22d0c6ccf7-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
