Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1314EE3FA
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 00:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbiCaW0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 18:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242428AbiCaW0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 18:26:01 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2C6193234
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 15:24:13 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id e16so1579018lfc.13
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 15:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FP8sOgFMKdQHyzKTsWIeV2u7i9jzT+8IqNj2W9h0y6Y=;
        b=mgJpIhoRYTQaPKyD3ets4VfMCGuyuUERLeqqLiU6SYa8F/zYOQ+h8/g1J0qezFVtOK
         O9SUhLAx/Ggx5tyWGuHYOABMZhIskcWmon0TsLGOFa2UpeiysS8LHeBZHAL6LGKFlLwh
         fhbO10znZh8RNnVHLo/dtXGYwPnlRcoIIZyVp0/wY+x6gBkYTdqjvOIjvfrsmOxR18GC
         futWvmXYez+5heCAfp/zr9jgJzzw79AeOjnRIbDFSupqzBYfYkrEyaUE2EpSfF0iMQov
         PHDqvCl8rCy0XQj9zBoaT1ikVu3p0u3FdN1Ni1zcCOZ2Q23HUkirni5TmfR3nlFTd/Z8
         02qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FP8sOgFMKdQHyzKTsWIeV2u7i9jzT+8IqNj2W9h0y6Y=;
        b=AmUhqdxooEGTb3sZPvqGs23wPCN16yKWgJn3+Vw8obtemP/IyykGYFpNAOOpFsNo/v
         ocSIleR4RJfuL2qprQihU4vbJExWyZafB0ziyXhVsNpB2Bl1hN5zxjMiNnk+a+G8rleF
         BGDBkuHXaPmgBJY6EJckSNfZYIJ0uyaQYAVJvg0Jwey75S8CtR0Td4jC8be5Fwdpp++E
         yYkSRpD757wtmojJby1Rer77IhvVezq2EMqyLlIw9cqIb7wqY1nMc93n/H/ou6MA2oy3
         07H/idy7iYqiKXP5FeHCoV+tdvwbgTweRoY17txWkF/FNTLxb2NdABdIgR0o3bcru+VU
         yhKQ==
X-Gm-Message-State: AOAM533J4XvsX1YLSeyyVeY4aoNdHRdtL6DxKcjXU8G7mOVN3pAv3vZY
        i4HKbeDTfqpr9cpHCaLsqRbvar5b104fMzz+UDaBjA==
X-Google-Smtp-Source: ABdhPJw/vhxve7+6KTHW3YpBJoZ3JZrLnR/TtF1CNp+XFA/FgPzfWR/amGaUksAVYCKZi+H81bYWKN+lPht6SwO2tkE=
X-Received: by 2002:a19:490f:0:b0:448:4bf8:6084 with SMTP id
 w15-20020a19490f000000b004484bf86084mr11842370lfa.537.1648765451129; Thu, 31
 Mar 2022 15:24:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220330165510.213111-1-pbonzini@redhat.com> <YkTs5BU24zrw30hK@google.com>
 <0c830e36-fcf2-fab6-aed9-7b6a6736140f@redhat.com>
In-Reply-To: <0c830e36-fcf2-fab6-aed9-7b6a6736140f@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 31 Mar 2022 15:23:44 -0700
Message-ID: <CALzav=ch2ZEA6OGvYnucZCWG12uhSuTnQpxc8e9FwvP5VCSvcw@mail.gmail.com>
Subject: Re: [PATCH] KVM: MMU: propagate alloc_workqueue failure
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022 at 2:34 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 3/31/22 01:51, David Matlack wrote:
> >> -void kvm_mmu_init_vm(struct kvm *kvm)
> >> +int kvm_mmu_init_vm(struct kvm *kvm)
> >>   {
> >>      struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
> >> +    int r;
> >>
> >> +    INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
> >> +    INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
> >> +    INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
> >
> > I agree with moving these but that should probably be done in a separate
> > commit.
>
> Ok.
>
> >> -    kvm->arch.tdp_mmu_zap_wq =
> >> -            alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
> >> -
> >> -    return true;
> >> +    kvm->arch.tdp_mmu_zap_wq = wq;
> >
> > Suggest moving this to just after checking the return value of
> > alloc_workqueue().
>
> This is intentional, in case we have other future allocations, to avoid
> having to NULL out the field in the unwind path.  It's a matter of taste
> I guess.

Oh ok, that makes sense. I agree it's a matter of taste.

>
> >> +    return 1;
> >
> > Perhaps return 0 until we have a reason to differentiate the 2 cases.
>
> Yeah, though I wanted to preserve the previous behavior.
>
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index fe2171b11441..89b6efb7f504 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -11629,12 +11629,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >>
> >>      ret = kvm_page_track_init(kvm);
> >>      if (ret)
> >> -            return ret;
> >> +            goto out;
> >
> > nit: This goto is unnecessary.
>
> True, but I prefer to be consistent in using "goto" so that any future
> additions are careful about preserving the chain.

Sounds good.

>
> Paolo
>
