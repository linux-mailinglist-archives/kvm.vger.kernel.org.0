Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8E9437058
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 05:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhJVDFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 23:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbhJVDFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 23:05:50 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56B4C061764;
        Thu, 21 Oct 2021 20:03:33 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id y17so2796238ilb.9;
        Thu, 21 Oct 2021 20:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XK3a1LwqzUeACg4aXNx630V9gtFWyhO4gs8m0Vnr7Ls=;
        b=fu6JyUIqLhrpitkAaY4qmPTW7IR37wQcNqhQZfBjIwh9vhX+7NJrPYD24B8ekLX+OT
         F4BsT/30vU5QoNUENoTGq1CWSJKUJbZ2gGaHu/CQbzfKuigC7LzRL6aOeyV5ox5pWfMV
         igDHdYTLqv2zGREhGnuEmCmQe90MXxTcgdyZMglzyM+O1ybUhtguxFpwW1wMLEG47fYC
         wA164Xiq8F3jHm5upLyh672SJ19n+vxnixZyA5LBFxfsZ8tkY9nJCw0Ecb6uk1EU4V52
         38c4E0gYBjBFYJHAJr6AF29DJZpbL8eGLOLivdKB+g03AVyG8zATwGGFvKFRPVlkFfii
         k38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XK3a1LwqzUeACg4aXNx630V9gtFWyhO4gs8m0Vnr7Ls=;
        b=LKXzYk34R7VAQWpQN1sO9/9FeMsslffR3IDVuVMHrG9LJEM+PwFDACSMS6pAxApukt
         0I17ZbQM0TxbOCCq9URbDXbhC4MNOQoIIam27lDCh3AQuhnGPviM9R7YfMfZ6UDucHRA
         +Tr8Bx9fn0Fy6U3eMmz84db+8jxaXDSBUb0M8bSQBT3xGFjy6UiNapyzq2PfIKkwfLBW
         sfjrRjTS2zPf81V0zu9DzhWlM3L+tV/wfBmG72wq5674vTR78HIY+AvmiHrc3bCIEakk
         IZCHG4FDTa+rhnCejn2ykoSSTfZdwksPsr6iWIFXlYUSufqbV3Qa/G8zT/JluVYTIhi5
         zbuw==
X-Gm-Message-State: AOAM531fxvBRTVTixLsDUhcqLhccDbhyl9Zf/4IrWZUBSaHZZa05eKqD
        Zb2iUzsqgFzCEftHP9kh0jf//0uwcMyXRry8kOk=
X-Google-Smtp-Source: ABdhPJz02azZOOkaFJCIcObCEOdOGg69b65VhU1I8rcmQuAkwMDKAF/8hy4Ve4MZXSCBT+vaD6JeyErBlMaljaV2pdY=
X-Received: by 2002:a05:6e02:893:: with SMTP id z19mr6053922ils.224.1634871806321;
 Thu, 21 Oct 2021 20:03:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211022010005.1454978-1-seanjc@google.com> <20211022010005.1454978-2-seanjc@google.com>
 <CAJhGHyCA-nfoJPmQxVWRtu+iJk3aj9ZdNH630RjrQJ_vYnZ3Gg@mail.gmail.com>
In-Reply-To: <CAJhGHyCA-nfoJPmQxVWRtu+iJk3aj9ZdNH630RjrQJ_vYnZ3Gg@mail.gmail.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Fri, 22 Oct 2021 11:03:15 +0800
Message-ID: <CAJhGHyDHwz-ADZdUUcFd+PswTKKQRi=UDkZGQVu1erRbDFMSKQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Drop a redundant, broken remote TLB flush
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 22, 2021 at 10:58 AM Lai Jiangshan
<jiangshanlai+lkml@gmail.com> wrote:
>
> On Fri, Oct 22, 2021 at 9:01 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > A recent commit to fix the calls to kvm_flush_remote_tlbs_with_address()
> > in kvm_zap_gfn_range() inadvertantly added yet another flush instead of
> > fixing the existing flush.  Drop the redundant flush, and fix the params
> > for the existing flush.
> >
> > Fixes: 2822da446640 ("KVM: x86/mmu: fix parameters to kvm_flush_remote_tlbs_with_address")
> > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index c6ddb042b281..f82b192bba0b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5709,13 +5709,11 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> >                 for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> >                         flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
> >                                                           gfn_end, flush);
> > -               if (flush)
> > -                       kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
> > -                                                          gfn_end - gfn_start);
>
> In the recent queue branch of kvm tree, there is the same "if (flush)" in
> the previous "if (kvm_memslots_have_rmaps(kvm))" branch.  The "if (flush)"
> branch needs to be removed too.

Oh, it is in the patch 2. For patch 1 and 2:

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>

>
> Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
>
> >         }
> >
> >         if (flush)
> > -               kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
> > +               kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
> > +                                                  gfn_end - gfn_start);
> >
> >         kvm_dec_notifier_count(kvm, gfn_start, gfn_end);
> >
> > --
> > 2.33.0.1079.g6e70778dc9-goog
> >
