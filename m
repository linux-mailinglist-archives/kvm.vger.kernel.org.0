Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D82373F28
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 18:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbhEEQFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 12:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbhEEQFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 12:05:45 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5803EC061761
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 09:04:47 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id i24so2659838edy.8
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 09:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gOsnjT8C91JOpSyd9rFGpVjpMC/XK1TYyPunXCVbQbQ=;
        b=GG4scJl51UAp/NLf7Lhis3w49wljBY7IVX7YuhCKTXyxDBTX+IBigU5Wu7ty1o01eG
         X0oUpWF5IMV85sGnkXiUYyJIaduqOMHchl/9HbHuaNkIvxLPkQdv/OjZ6gnChEv7EdQs
         EsaNU4dVQC/ze6DeINYKtN9H3E64hrK/b4a9UBi1jUbo8sSLjdt4q97U4c5y0nz5JnCQ
         GCUW5WPsAgJVIt4mSd0MJRagVWIgPvD0iyH/aoqX9qshqqqH/HWJD5SuQGKIy00osK5w
         R5W3qMd09S/RMM2fDZ1GkIBrOfx6YaX7xMaoUnqvZRgBufPlXn+GZs5fMY3owGsy99qk
         8r3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gOsnjT8C91JOpSyd9rFGpVjpMC/XK1TYyPunXCVbQbQ=;
        b=KvI3naSKWMQC/3Pa/NGScDSaW8IrcIJ2EgvhRoHRr3Pwn30WpGTZZG8rWjik4g0B8t
         5sqhOltFKYnVU4FaE2uHqGy+gRddTVfLyQWHhz/guaIYx5M8DVUn1wKgJpHPCa9ehyKc
         YkegKdtdDCX8GsuEmuvNMd5Ftbt0j6aznymNyC6kAx2VZU/eLMAA5IcDGZYqr109qwuv
         jfCr5sWT6g3OdN8l7rcpXH5AGu0p9it2zwLqVe3JoUM5VE87pohvwwgNjAa03Eqb9Bis
         CC1EHLMRDJuF4IxFLjiSMCwBEZ/zxSdhgV9wJ3sUfbgpvLxa8DERwasU01RTP2fZIeie
         Y0rA==
X-Gm-Message-State: AOAM531T3esbM8L1vNNw/pHz5h25RZaIrXttrUyVvM0rgaclBxCgaOQT
        l7DbMXLQm7lWin3UXvyp+uP2sFVV2CpvhnZm/PuFvw==
X-Google-Smtp-Source: ABdhPJyfobAt6/Y5k9lowOCMC8BloIK32Wmfh5osXuyCXjokoRGnyc4+RUqZidriFlnOHv+7oz3s5vDB6KI7Z4ntKHc=
X-Received: by 2002:aa7:dc54:: with SMTP id g20mr33166380edu.266.1620230685827;
 Wed, 05 May 2021 09:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1620200410.git.kai.huang@intel.com> <00875eb37d6b5cc9d19bb19e31db3130ac1d8730.1620200410.git.kai.huang@intel.com>
 <YJLBARcEiD+Sn4UV@google.com>
In-Reply-To: <YJLBARcEiD+Sn4UV@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 5 May 2021 09:04:34 -0700
Message-ID: <CANgfPd_s1jrAaRRPtC=VUbeL=GfqWPncPx3RVG=+mK3fCiuiKQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 5, 2021 at 9:00 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 05, 2021, Kai Huang wrote:
> > Currently tdp_mmu_map_handle_target_level() returns 0, which is
> > RET_PF_RETRY, when page fault is actually fixed.  This makes
> > kvm_tdp_mmu_map() also return RET_PF_RETRY in this case, instead of
> > RET_PF_FIXED.  Fix by initializing ret to RET_PF_FIXED.
>
> Probably worth adding a blurb to call out that the bad return value is benign
> since kvm_mmu_page_fault() resumes the guest on RET_PF_RETRY or RET_PF_FIXED.
> And for good measure, a Fixes without stable@.
>
>   Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Haha I was just about to add the same two comments. Besides those,
this patch looks good to me as well.

Reviewed-by: Ben Gardon <bgardon@google.com>

>
>
> Side topic...
>
> Ben, does the TDP MMU intentionally not prefetch pages?  If so, why not?

It does not currently prefetch pages, but there's no reason it
shouldn't. It simply hasn't been implemented yet.

>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index ff0ae030004d..1cad4c9f7c34 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -905,7 +905,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
> >                                         kvm_pfn_t pfn, bool prefault)
> >  {
> >       u64 new_spte;
> > -     int ret = 0;
> > +     int ret = RET_PF_FIXED;
> >       int make_spte_ret = 0;
> >
> >       if (unlikely(is_noslot_pfn(pfn)))
> > --
> > 2.31.1
> >
