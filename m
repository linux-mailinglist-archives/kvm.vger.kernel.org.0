Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733834B0451
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 05:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbiBJEP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 23:15:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiBJEP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 23:15:26 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0DF272D
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 20:15:28 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso4311824pjh.5
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 20:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MDxf4BrnwStXUjsYxwjI3lJC+rIcyxFDuuEmHqrQ/Oc=;
        b=qgqsDox8Uz2voagu3SS62EbUZLzC4+jwAS+IETwJnJ3WDf9LcHDPRHBYlPb+QqvTwz
         rr1ve49rjegbL66nRKCfoRHGLIT5zui9RIxCMIs4Ibi4DDbfhdUEGAlhoWwzDaR1LDWU
         6fNbAKXodXe6oPJrV7mO0cU1Lv9u7VmoR5tHwSZ4IvQL3lqQBkcsRe5QAHSL5zPpACji
         lg6qPIaKgZ4e75HuHXkXm73zjeCkEOKMVnkxFIUUZ1snmXAx7Y6Lvo8hY45HlEAgT1uD
         xokqMib5SOuBx/sCi958eRUq7d9bDw+qWNEvZbObBDUokOwxpuzwX7UR5lKsV5bxHr/9
         5Zyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MDxf4BrnwStXUjsYxwjI3lJC+rIcyxFDuuEmHqrQ/Oc=;
        b=tT2owJMBbLcrl4ecUDtiohQ8bTtea6wU9dM5kCvcWrr0jvLD2i/7UwwtSpo3SVjOsI
         jCB5AV03V9np3C3VkBPHzzYxepkVtz677SzKvKAgRwuVcAPcNuZvfu3sWr3UoPqbHPW6
         Br/KuAkrKidY9jqPmqthJrE05HPDl30rSePSJaopxiwlwSI/bjInqY4g3uIVY++ZfXVl
         nnIIxSzK22AXKxJ0858SlfOD0KIA110MX4/5HsGdWoGNQoIgebYGGzB8NGTJRq52vSeu
         F3UARzDCRriiOedQQK8wnqRuFZnWmuDfh8h0JTCwt89jHWFnsoJe1f+b6y45T8JDAEpU
         Ljmg==
X-Gm-Message-State: AOAM530Gq8klSvhf7xp10Q2UAkdgf4zdQE6XJjKTcgzog8sTT9etFZZG
        Pv9OhRI4nR+RsJhDxi3yHU6ZPyYGryMPOHHr2AAQ8A==
X-Google-Smtp-Source: ABdhPJycsJw7aHUyLA1Fvry8/yj4cc0Za+AYbDOdm5osBbufU/q5zbR4L8vQjN32IWZfSBIFBZwlUxfcLH1cXtwOU7k=
X-Received: by 2002:a17:90b:4f43:: with SMTP id pj3mr783525pjb.9.1644466527831;
 Wed, 09 Feb 2022 20:15:27 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-21-reijiw@google.com>
 <CA+EHjTy4L37G89orJ+cPTTZdFUehxNSMy0Pd36PW41JKVB0ohA@mail.gmail.com>
 <CAAeT=Fx1pM66cQaefkBTAJ7-Y0nzjmABJrp5DiNm4_47hdEyrg@mail.gmail.com> <CA+EHjTx=ztc-RnuazbUcR-JsKocyie+FtrukvzUP=SZ-y9WPuw@mail.gmail.com>
In-Reply-To: <CA+EHjTx=ztc-RnuazbUcR-JsKocyie+FtrukvzUP=SZ-y9WPuw@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 9 Feb 2022 20:15:11 -0800
Message-ID: <CAAeT=FyEbk+9mM802Drb-pVgE=aL-RUdyn7zdHOnUACoMtDVmQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 20/26] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
To:     Fuad Tabba <tabba@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Fuad,

On Tue, Feb 1, 2022 at 6:14 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> ...
>
> > > > +static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +       feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
> > >
> > > Covers the CPTR flags for AMU, but as you mentioned, does not
> > > explicitly clear HCR_AMVOFFEN.
> >
> > In my understanding, clearing HCR_EL2.AMVOFFEN is not necessary as
> > CPTR_EL2.TAM == 1 traps the guest's accessing AMEVCNTR0<n>_EL0 and
> > AMEVCNTR1<n>_EL0 anyway (HCR_EL2.AMVOFFEN doesn't matter).
> > (Or is my understanding wrong ??)
>
> You're right. However, I think they should be cleared first for
> completeness. Also, if I understand correctly, AMVOFFEN is about
> enabling and disabling virtualization of the registers, making
> indirect reads of the virtual offset registers as zero, so it's not
> just about trapping.

I understand that AMVOFFEN is making indirect reads of the
virtual offset registers as zero.  But, in my understanding,
enabling and disabling virtualization of the registers doesn't
matter as long as CPTR_EL2.TAM == 1 (a value of HCR_EL2.AMVOFFEN
doesn't change any behavior because the virtual offset registers
won't be used). So, I'm not too keen on adding that so far.

Thanks,
Reiji
