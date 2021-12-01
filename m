Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6B74643DF
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 01:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345557AbhLAAUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 19:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbhLAATx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 19:19:53 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115CAC061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 16:16:33 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id p8so30990259ljo.5
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 16:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TeJsOsbKI8C/6A55qUWfNd25mzOWLdLFfNQT3tIjiw0=;
        b=A2C/+heBsOm2BCTRWSfoWOf0g+vLGrflPg71RVczoPHC5Uly5ikc19zCUurjuWuw2n
         k/1d5VlvNNzE2N2zbMFcaE6uv4Hj+CfmtabyHuQDWtebT2j69Gbxqp58L8QI/ZBoJtqC
         IiV8Q9yWVo2SSwmdr6TJPxM09iLFdEnyYtkh6qq/r4ibuGCSqxK6snN6opYfYUUeh18z
         /+kLdwg6KPlNlzNlMyIZYVlI1ChECmQNHR4wvEBru79oBAJ6sbbOXKIgZGKIXBIdr/ia
         C7+RqiBirGnSAB8yAfpjF2CK5FYGh0HO6iDZTd8gfmoFPjeYZR/WNadZ+2OQs3J9aGT3
         VJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TeJsOsbKI8C/6A55qUWfNd25mzOWLdLFfNQT3tIjiw0=;
        b=iHKzs5zq2TgZMvLl88b2Pzz21joUB4CESI5FJdarYcKDojeXbSVvDxhQEG78DXGeEb
         pvpSOF5bb/x+udRFNYDeUd81TOybLc0H/sny+xKm049TgvlueOO2BQPMJYDYYeaDORum
         f1Eou8nAf1p5byLpHXCKo2jSEkSnCuECAnCmmXwQlI1arROHUUk7RsvH6AxaQ7MHS01C
         GaY6hByealq8xSUbJSS7PPqX61oMIolM5nRxIqpIqzffigijTjoQ3IcJPDUvwmeZS5Ha
         Ed6WDUXc9xAgT/iT6PzwOHBHkthVMtY8U0NH41YqnlOJC3IXtSlzrbsYEyc0fotEA1F3
         qHJg==
X-Gm-Message-State: AOAM531Cyh0MfuM8ah5PmwXo6cOzcYfDawYfw/VL1U3RcAZtSoWMuvNp
        Jl03TnlFmPvBrNa3Dfvg4vWccvoi6aQfQ5JU/JzhRw==
X-Google-Smtp-Source: ABdhPJx5l26+K/+wdOYXeDCBw+Op5Kk6Xw8z9GZDp8NsgEAvBGjGBwqJWMrho5DKjWI8ZjMGfdF0gbYBVHL81CYpKoo=
X-Received: by 2002:a2e:8991:: with SMTP id c17mr2045990lji.361.1638317791045;
 Tue, 30 Nov 2021 16:16:31 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-14-dmatlack@google.com>
 <YaDQSKnZ3bN501Ml@xz-m1.local>
In-Reply-To: <YaDQSKnZ3bN501Ml@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 30 Nov 2021 16:16:04 -0800
Message-ID: <CALzav=fVd4mLMyf6RBS=yDuN+hMM0hoa7+YHdYucRcJDjD4EfA@mail.gmail.com>
Subject: Re: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during CLEAR_DIRTY_LOG
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 26, 2021 at 4:17 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Nov 19, 2021 at 11:57:57PM +0000, David Matlack wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6768ef9c0891..4e78ef2dd352 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1448,6 +1448,12 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> >               gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
> >               gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
> >
> > +             /*
> > +              * Try to proactively split any large pages down to 4KB so that
> > +              * vCPUs don't have to take write-protection faults.
> > +              */
> > +             kvm_mmu_try_split_large_pages(kvm, slot, start, end, PG_LEVEL_4K);
> > +
> >               kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
> >
> >               /* Cross two large pages? */
>
> Is it intended to try split every time even if we could have split it already?
> As I remember Paolo mentioned that we can skip split if it's not the 1st
> CLEAR_LOG on the same range, and IIUC that makes sense.
>
> But indeed I don't see a trivial way to know whether this is the first clear of
> this range.  Maybe we can maintain "how many huge pages are there under current
> kvm_mmu_page node" somehow?  Then if root sp has the counter==0, then we can
> skip it.  Just a wild idea..
>
> Or maybe it's intended to try split unconditionally for some reason?  If so
> it'll be great to mention that either in the commit message or in comments.

Thanks for calling this out. Could the same be said about the existing
code that unconditionally tries to write-protect 2M+ pages? I aimed to
keep parity with the write-protection calls (always try to split
before write-protecting) but I agree there might be opportunities
available to skip altogether.

By the way, looking at this code again I think I see some potential bugs:
 - I don't think I ever free split_caches in the initially-all-set case.
 - What happens if splitting fails the CLEAR_LOG but succeeds the
CLEAR_LOG? We would end up propagating the write-protection on the 2M
page down to the 4K page. This might cause issues if using PML.

>
> Thanks,
>
> --
> Peter Xu
>
