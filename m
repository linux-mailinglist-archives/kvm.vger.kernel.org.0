Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC6757E3D3
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 17:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiGVPgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 11:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiGVPgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 11:36:06 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1924440BE7
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:36:05 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h8so7017937wrw.1
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rmfDswxY6ta1vy/gnvg7TVoT2LGNlRTO9rFM64SufS8=;
        b=fyHDA43mwXEj2j3I1O9hdD/vcHjc2sdUZl+jHm2bT+hFQYcHLWK++SQUUPnhyhAgwf
         ag5WSSbnvX6nWbhHw4Mm/1quw6rfpVZ78LHNYVCxlu2W/wmnBGGJbq6W8/rKhq62aq4B
         nxfyHazmCQ3nqdLM1SXxir3d7/KYT76heVBp7FqRs7R+9FyNMsp95+XidJZ44gUh1eQM
         PWpe65ryBlsmkj1WggMMbApmoIlYWrVs+rfL3SAdS2MI8aC1OeOuU+PBudBVWTj8cujE
         WVozYcdCH/m6wY4UeIpBMLI2ghwWx0HsaV20V7PvB+DkD84EvWs0RllIRWEwx/sSeVqW
         cAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rmfDswxY6ta1vy/gnvg7TVoT2LGNlRTO9rFM64SufS8=;
        b=brkIt8U9HpeLJZvi7Yu1bCn4uZ6Ac4JCbglZXCUbGeuigi3RDT8cY12zGBrmUTmzC7
         yknBQ98vn7oksIpxNVslXy1sVosztuFBCTrpJd+jyjvf+EcOdWI132w3hu/NBiYb1jzu
         u+B4jWYyFPJHWLpyY3jxwSuJ3AedWpLx+APIEMLD696vysepu9+KEqnMWWJjyQQKHjkO
         71q9WdCe7i4BBUVjxiNcvp1k1L3FB9jyDPLkjTwKyE1l0t3DOhUUoIxKvOaf6gbPnJbH
         mt75h1FzErCkN8+EaRK5pMcxlt59/mnOOdEgumtIHk2Y1XpUY/p8tCEi86oYLJObCBR6
         L1sw==
X-Gm-Message-State: AJIora/Drti8vvjEZKglKNfm6MagyNzTsBNqAiJ9R/00+SfP17ZWbvZe
        GubPFulLg7PQ2BgidHhM4CrMoUxLTsfMvfsQKX2fJgclKT3Ttg==
X-Google-Smtp-Source: AGRyM1u5ebk3S2kkRUtAy0JbM/Li/uBHMCKuxxtd60YMB1skZw3vfbK5QA+VzATXadLFMck9Z1XG9Ef/3apxu+Q4tyk=
X-Received: by 2002:a5d:5e90:0:b0:21e:5b04:7892 with SMTP id
 ck16-20020a5d5e90000000b0021e5b047892mr353709wrb.282.1658504163393; Fri, 22
 Jul 2022 08:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220719234950.3612318-1-aaronlewis@google.com>
 <20220719234950.3612318-2-aaronlewis@google.com> <YtiQN4LB7a6tE4UD@google.com>
In-Reply-To: <YtiQN4LB7a6tE4UD@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 22 Jul 2022 15:35:51 +0000
Message-ID: <CAAAPnDG3ki5ECdPLpzbJabksDWG0t=Gu2ivQsjwh1hBJ_sor=Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] KVM: x86: Protect the unused bits in the MSR
 filtering / exiting flags
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
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

On Wed, Jul 20, 2022 at 11:31 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jul 19, 2022, Aaron Lewis wrote:
> > The flags used in KVM_CAP_X86_USER_SPACE_MSR and KVM_X86_SET_MSR_FILTER
> > have no protection for their unused bits.  Without protection, future
> > development for these features will be difficult.  Add the protection
> > needed to make it possible to extend these features in the future.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >  arch/x86/include/uapi/asm/kvm.h | 1 +
> >  arch/x86/kvm/x86.c              | 6 ++++++
> >  include/uapi/linux/kvm.h        | 3 +++
> >  3 files changed, 10 insertions(+)
> >
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index ee3896416c68..63691a4c62d0 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -224,6 +224,7 @@ struct kvm_msr_filter_range {
> >  struct kvm_msr_filter {
> >  #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
>
> Well this is silly.  Can we wrap this with
>
> #ifdef __KERNEL__
> #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
> #endif
>
> so that we don't try to use it in the kernel?  E.g. I can see someone doing
>
>         if (filter.flags & KVM_MSR_FILTER_DEFAULT_ALLOW)
>                 <allow the MSR>
>
> and getting really confused when that doesn't work.
>
> Or if we're feeling lucky, just remove it entirely as userspace doing
>
>         filter.flags &= KVM_MSR_FILTER_DEFAULT_ALLOW;
>
> is going to make someone sad someday.

Agreed that removing it would be more ideal, but I'm not feeling that
lucky to assume userspace isn't already using it.  I think it'll go
with your first option and wrap it in an #ifndef __KERNEL__.

>
> >  #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
> > +#define KVM_MSR_FILTER_VALID_MASK (KVM_MSR_FILTER_DEFAULT_DENY)
> >       __u32 flags;
> >       struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
> >  };
