Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DDE5A71F8
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiH3Xqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiH3Xqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:46:37 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C38867453
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:46:35 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-11e9a7135easo18086254fac.6
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=X1ll68FYCjFg9pMpHQVhzgtsyQhQB9i2JL2EDHFgAjs=;
        b=KUbMOL9j85nZRz10Mv9Z+yVJluhYGt1Nc3rV1ThW2ZfurXst01dWOJtgcxf2qIUGaG
         idtQyHWehJ0ReaZ5N/9wctUMxBlg54O+WS25L/Cxpkjml2Mhfwl7T+GXAXZjxzdMqbTS
         1ie2uT8UcovwnkbMmWgCNowYHG9AFxNA6cbmDvRQ7+3yC8uF9Gk3yARCNfT5WIVgoJLO
         ARdNULMe+PB8D34ShR9rRueD1rA1m9306DyZP0Gd2E/dyFZngYj1a7fDnp2A83c1LU81
         DzJxLFR8WjaIuNwnU9VK4UlxUYWbutYCsodn5iK+X6PnEp4DL7ht0MMkXxjgkqlq0+mU
         89sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=X1ll68FYCjFg9pMpHQVhzgtsyQhQB9i2JL2EDHFgAjs=;
        b=4pzYV3n0gvuIgA6ojrnFXjAbK6uqHarbM2fheDeXndGzpiN+Vbf7W41gOaGzLxuOiC
         +rjiLLZ4D/hPDiSPdyRz3MQpBUYvys4nGI+9PpLQnmtwZXR/Pc2a0QO7FxHYktO4jMLs
         G/caZQmKvjb+3Esrq6G7iijfvCWa/EuumZZs4KSO3634ZKW+iruTKtNEYsklfx+zpuXE
         cTZISvui2tfb2H/FpaDGKX7eSF/5FVt2/EAc7NsyDr610/icW9T6MbB6RB13OnCQD2Ll
         weHq5hDc/YeP6agZYT+P4cy2Gw7Fi9nLwM+jU54PUSOyU3rS8I43KZPDt2vgWH7ShbIy
         uT7g==
X-Gm-Message-State: ACgBeo1y5t9AOmINQk6eme8i0YxWe6EkPIpWid3tuXKFurRdKErNlAE8
        3XwO5+qjbaPI2K+k/wyEoN3Nn+RRAzVgSNvOvqcyFBVVx6Lzwg==
X-Google-Smtp-Source: AA6agR75ciY9ENO+nMF/N5aLS8fdO9kRRDnnWWHgm8zfot3KPSqJOVaSRaX1JU99DGnbtK1c3IbKaWVEaNWU2M14TkU=
X-Received: by 2002:a05:6808:150f:b0:343:3202:91cf with SMTP id
 u15-20020a056808150f00b00343320291cfmr186766oiw.112.1661903194649; Tue, 30
 Aug 2022 16:46:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220830225210.2381310-1-jmattson@google.com> <20220830225210.2381310-2-jmattson@google.com>
 <Yw6fkyJrsu/i+Byy@google.com>
In-Reply-To: <Yw6fkyJrsu/i+Byy@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 30 Aug 2022 16:46:23 -0700
Message-ID: <CALMp9eRfq9jtC20an2brOL=+LpFFReqz0-BvOE_6p-461C8vaw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: Expose Predictive Store Forwarding
 Disable on Intel parts
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
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

On Tue, Aug 30, 2022 at 4:39 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Aug 30, 2022, Jim Mattson wrote:
> > Intel enumerates support for PSFD in CPUID.(EAX=7,ECX=2):EDX.PSFD[bit
> > 0]. Report support for this feature in KVM if it is available on the
> > host.
> >
> > Presumably, this feature bit, like its AMD counterpart, is not welcome
> > in cpufeatures.h, so add a local definition of this feature in KVM.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 23 +++++++++++++++++------
> >  1 file changed, 17 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 07be45c5bb93..b5af9e451bef 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -62,6 +62,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
> >   * This one is tied to SSB in the user API, and not
> >   * visible in /proc/cpuinfo.
> >   */
> > +#define KVM_X86_FEATURE_PSFD         0          /* Predictive Store Forwarding Disable */
>
> I believe we can use "enum kvm_only_cpuid_leafs" to handle this.  E.g.
>
>         enum kvm_only_cpuid_leafs {
>                 CPUID_12_EAX     = NCAPINTS,
>                 CPUID_7_2_EDX,
>                 NR_KVM_CPU_CAPS,
>
>                 NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
>         };
>
> then the intended use of KVM_X86_FEATURE_*
>
>         #define KVM_X86_FEATURE_PSFD    KVM_X86_FEATURE(CPUID_7_2_EDX, 0)
>
> I _think_ we can then define an arbitrary word for X86_FEATURE_PSFD, e.g.
>
>         #define X86_FEATURE_PSFD        (NKVMCAPINTS*32+0)

We may run afoul of reverse_cpuid_check(), depending on usage.

> and then wire up the translation:
>
>         static __always_inline u32 __feature_translate(int x86_feature)
>         {
>                 if (x86_feature == X86_FEATURE_SGX1)
>                         return KVM_X86_FEATURE_SGX1;
>                 else if (x86_feature == X86_FEATURE_SGX2)
>                         return KVM_X86_FEATURE_SGX2;
>                 else if (x86_feature == X86_FEATURE_PSFD)
>                         return KVM_X86_FEATURE_PSFD;
>
>                 return x86_feature;
>         }
>
> I believe/hope that allows us to use at least cpuid_entry_override().  Open coding
> masking of specific registers was a mess that I don't want to repeat.

Maybe we can plead for a bit in word 11?
