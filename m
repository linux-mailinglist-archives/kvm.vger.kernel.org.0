Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5066E56C5ED
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 04:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiGICF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 22:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGICF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 22:05:58 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C363D5E33F
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 19:05:56 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id r129-20020a1c4487000000b003a2d053adcbso2066884wma.4
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 19:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AWIB2pfpzuLcT8WsTSyf7MJ0QpIcd0Rlv0R7BrKmB9s=;
        b=o0dyewuD3KMgm3pQ5CQbU5zXjmmINVct6R4FQ+VNuABHj+SmKWHRdwLn5bQZwqPbKd
         enOztap5rB0/thF3Fc8WY8RzqCsd9C0PAb/A8cuSsog+qKJu7dR5wLAQoTG9e3js/rbL
         cUB5in9HFKDI9S2qX8OHsC25UJs1VLbi+xgia0cnG0vMJtk51pTteLlkjUx1suiWMdaY
         VEnFBqfa4jRBhSD7ah75hUOj2oIpW5nrSoUe0pDPGKUb8f57r+xwiOTQir71bMKUYMLB
         ex0yMfkTVhNaCkGmXmt5Ak//YzM4heZTuMWpHokCATXiv2PZk8BjzSLjbG3caG9mvZbR
         tQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AWIB2pfpzuLcT8WsTSyf7MJ0QpIcd0Rlv0R7BrKmB9s=;
        b=NlH4K49/sxS32AR55XE5CDuDVcFJcwkW7Yzy0fS8JLxGoq9OlqNQCSy9LADmqKF+YO
         xjbV1Q8llbyq+A1aPxOvi3CMTn1Gp0BlmfcU0T/A1bMQhMjta2zVuDrPJ3zo3YZx9QDF
         LWTB7+M39JUJSWez+bW/eLfqGjqKWsfzACtqfn/zb1PJ7Oa5Ir+MnEQjZhL1KDeN67gz
         rZalQfSV6JjGvtHb1TbiFQdCQ7HUxKbXdtKPqNnDllg3RR8uRtrvHCp31EyBqiZ070fE
         QDeeRVJp09VA+/H0dGjCUYLzK0mxYc+8ND+pkbBVtGayPVLoXuYUCC4bymjkkBqeyZeu
         wpuQ==
X-Gm-Message-State: AJIora8Vauqwpt2xTbcXwA2sjRCoQ8vWk+oI6MGRXhe/dmJbGLusRFSZ
        foyFbQ1OqnR67eOLwfrBSKT1Ch4KlTBHHd2GsIGeZg==
X-Google-Smtp-Source: AGRyM1vAU8OLB+1rQR0/KG70cbwnMZOSvyIOfnQj+NUnuNGG/nptKiEMjie/8Rk3qX1M3qP0ZQgU3hNI22tzc7ItPz0=
X-Received: by 2002:a05:600c:3659:b0:3a0:3915:8700 with SMTP id
 y25-20020a05600c365900b003a039158700mr2709938wmq.127.1657332355329; Fri, 08
 Jul 2022 19:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220703191636.2159067-1-aaronlewis@google.com>
 <20220703191636.2159067-4-aaronlewis@google.com> <YscyJf3pzsSVZonS@google.com>
In-Reply-To: <YscyJf3pzsSVZonS@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Sat, 9 Jul 2022 02:05:43 +0000
Message-ID: <CAAAPnDGWc6Co2CVPciy0MmB6=R16RyDheCO_rr9qcCSkzgjycA@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86: Don't deflect MSRs to userspace that can't
 be filtered
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
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

On Thu, Jul 7, 2022 at 7:21 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sun, Jul 03, 2022, Aaron Lewis wrote:
> > If an MSR is not permitted to be filtered and deflected to userspace,
> > don't then allow it to be deflected to userspace by other means.  If an
> > MSR that cannot be filtered #GP's, and KVM is configured to send all
> > MSRs that #GP to userspace, that MSR will be sent to userspace as well.
> > Prevent that from happening by filtering out disallowed MSRs from being
> > deflected to userspace.
>
> Why?  Honest question.  KVM doesn't allow filtering x2APIC accesses because
> supporting that would be messy, and there's no sane use case for intercepting
> x2APIC accesses if userspace has enabled the in-kernel local APIC.
>
> I can't think of a meaningful use case for intercepting faults on x2APIC MSRs,
> but I also don't see anything inherently broken with allowing userspace to intercept
> such faults.

Ack.  I'll drop it in v2.

>
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 031678eff28e..a84741f7d254 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1712,6 +1712,15 @@ void kvm_enable_efer_bits(u64 mask)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
> >
> > +bool kvm_msr_filtering_disallowed(u32 index)
>
> Should be static, per the test bot.
>
> > +{
> > +     /* x2APIC MSRs do not support filtering. */
> > +     if (index >= 0x800 && index <= 0x8ff)
> > +             return true;
> > +
> > +     return false;
> > +}
> > +
> >  bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
> >  {
> >       struct kvm_x86_msr_filter *msr_filter;
> > @@ -1721,8 +1730,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
> >       int idx;
> >       u32 i;
> >
> > -     /* x2APIC MSRs do not support filtering. */
> > -     if (index >= 0x800 && index <= 0x8ff)
> > +     /* Prevent certain MSRs from using MSR Filtering. */
> > +     if (kvm_msr_filtering_disallowed(index))
> >               return true;
> >
> >       idx = srcu_read_lock(&kvm->srcu);
> > @@ -1962,6 +1971,9 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
> >       if (!(vcpu->kvm->arch.user_space_msr_mask & msr_reason))
> >               return 0;
> >
> > +     if (kvm_msr_filtering_disallowed(index))
> > +             return 0;
> > +
> >       vcpu->run->exit_reason = exit_reason;
> >       vcpu->run->msr.error = 0;
> >       memset(vcpu->run->msr.pad, 0, sizeof(vcpu->run->msr.pad));
> > --
> > 2.37.0.rc0.161.g10f37bed90-goog
> >
