Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E160E426874
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 13:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhJHLIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 07:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbhJHLIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 07:08:42 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1FBC061570;
        Fri,  8 Oct 2021 04:06:47 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id x33-20020a9d37a4000000b0054733a85462so11179762otb.10;
        Fri, 08 Oct 2021 04:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SEkz4ZOw2MRo2rGqF0mpjib4aQPW8paURZ/TdkwthmA=;
        b=NKaIzCWY041PjfWtF60lyzX7TLZJF+nRK4ZfM0QdCgAD4C4IpoOOLfpKQhaq9MPaoA
         +7dEqqydbnMitfo/ztUdodTUWd6dbVV777D3ygogOGGq/gBh11RpnQRlucwqNxpYiEiM
         7ngODPtRqXD7snqgmPm5pNsVUbrG7WwSJqGyWmbrc5raj+xUaRTk7gtBArjG+XWlTJDZ
         ocgpem0ZFjin9uSwReNaqVcGCVaDGra4txS8fCE7yxG2xyc0FyOD845JNTxLqlqc5QPE
         JGmNdqDSiUspiX/MEikDc4EEw30lsIDv/Xd6oyS3ok/Rn7vF8nuTWLNVXEtA7a1+WB6u
         1DcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SEkz4ZOw2MRo2rGqF0mpjib4aQPW8paURZ/TdkwthmA=;
        b=QbPOiEhtwbagRJSmnEcChJYig5aT1e4QJ8fK520/8P9TUYJVSnZQtnE9do6pdokgaF
         2/PhaNrwpSajqdPg6TGoVYUDcGuUar30tZOJGcRxdWA4YoEIGxD1g+aULjFqRA/0BMt4
         u46jfRc1ej23o20G2OWPqNQUcGKJj63gKiXb/n6Ur21VlX+cEUm8vw8/+AF7a9dZSUWf
         HH1wwOTBgbg+d21Bu4rzKIOBoBhrTscB+/ml8RkWWzWYcym6fg1sRDpoxn1HIMLQDPJq
         GV4i2vra2bJ9Qglqnfyfktz2ItP2XTWKd2019ElFai0btJfPTdpPHC5kxciiVz00WGMI
         kvDA==
X-Gm-Message-State: AOAM532cO/HEmvhoNPGCGtRRLNrqmtPfMKM3ab2w2e13xWWFrlmcbcP5
        qUWliGXQWaQG84cygMQzrPPItEA6cCohcEil7ff5ulB29oU=
X-Google-Smtp-Source: ABdhPJw6tG1RdLQIcWZTmkHLRfJS1I3MQ9Zv2GAWFPOqMDwzw5il5UhhmEChutFTiMqi4nSLrtpiVZ8b4Vsnx/AwmW0=
X-Received: by 2002:a05:6830:40b0:: with SMTP id x48mr8136182ott.246.1633691205672;
 Fri, 08 Oct 2021 04:06:45 -0700 (PDT)
MIME-Version: 1.0
References: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
 <1633687054-18865-3-git-send-email-wanpengli@tencent.com> <87ily73i0x.fsf@vitty.brq.redhat.com>
In-Reply-To: <87ily73i0x.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 8 Oct 2021 19:06:34 +0800
Message-ID: <CANRm+Cy=bb_iap6JKsux7ekmo6Td0FXqwpuVdgPSC8u8b2wFNA@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: LAPIC: Optimize PMI delivering overhead
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Oct 2021 at 18:52, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > The overhead of kvm_vcpu_kick() is huge since expensive rcu/memory
> > barrier etc operations in rcuwait_wake_up(). It is worse when local
> > delivery since the vCPU is scheduled and we still suffer from this.
> > We can observe 12us+ for kvm_vcpu_kick() in kvm_pmu_deliver_pmi()
> > path by ftrace before the patch and 6us+ after the optimization.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 76fb00921203..ec6997187c6d 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1120,7 +1120,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
> >       case APIC_DM_NMI:
> >               result = 1;
> >               kvm_inject_nmi(vcpu);
> > -             kvm_vcpu_kick(vcpu);
> > +             if (vcpu != kvm_get_running_vcpu())
> > +                     kvm_vcpu_kick(vcpu);
>
> Out of curiosity,
>
> can this be converted into a generic optimization for kvm_vcpu_kick()
> instead? I.e. if kvm_vcpu_kick() is called for the currently running
> vCPU, there's almost nothing to do, especially when we already have a
> request pending, right? (I didn't put too much though to it)

I thought about it before, I will do it in the next version since you
also vote for it. :)

    Wanpeng
