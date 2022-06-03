Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C36353D2CF
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 22:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbiFCU3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 16:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiFCU3L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 16:29:11 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE68C326E8
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 13:29:09 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id t13so9596863ljd.6
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 13:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ewAB+mvZTcePxip/ggRUqgJv4w8qFXiqrwr/21vXlAE=;
        b=I5ilZrtG/XpxYRuzWxtH6+HoixTjej/BgMbRFpQYfRU9UmuzAcNcE5RtUwRBwVhvfh
         rP9BsW3Op0Uu7g5dfd2D1a+L52ugMts4/GzOQtJLJBXtjgrmLQk1Yx1lXfUERIeb9vKR
         QzreHY5JVeO8K3P/JbANebeiNgHPm1IvteWLrMjbbUL1UuFKKdC6us2HOqR79slrkdxy
         f0ZxbwmKw51kPN6IP2xpKoQxFnaTsnuJlu28zzLDxxTx4i0NjqJ03uwZTg7dPDcfXx62
         AvMDbGL6LnbCB2jBCYBiaDVvZV0hdvxv/j7IzH7DHWji4tpyilCpHw+Jn+jIKt31S3Fp
         G2mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ewAB+mvZTcePxip/ggRUqgJv4w8qFXiqrwr/21vXlAE=;
        b=wjeDwfYwFkMtj20xtpQXaL9r/OrSjvbiiEGyx/6vqqmAf1KGDKoujpNQNtj7N1PYqr
         FFTJoHpJ+G/VT+1etJ/W2EbZNAgbN0k8Cd49BZNJnKHwFyeAGL1qRIzeNnICaKgQTX16
         tfGmAylYQnMmzkmQx9P96dGthNVwR17ey3KIlMNqEGOXpRBiWp11BOAX6sxHyPQCxyC6
         1WfZ9gQO0gRAxqPYiB27B6fTK7ASqQbDjR1IGuyDGW0U/486qOa8xDGGd6RRtl2t6ljo
         PlfI2GJuuZBidHEdy4etcxT/r9R2wx/OUB+VdRl5TINstYLRm1e/Jm3/ZUjX6rUdViiz
         v9pg==
X-Gm-Message-State: AOAM531ky0R4Fo6wHVjel7+sxnZThnqOGnHWYjQw7tq6oGv9pI4uAzMZ
        9gAR4yxWzKQU//HNxiVwYWgmjbaJqwx+C3A46Xlc5g==
X-Google-Smtp-Source: ABdhPJzAwhZsayyj6RsT6S82Z069qfKARGa9ZsydR54PomEy5rXeI8+KYRJyVBPRIDqLAEdx9DYxTZEtdyCKQ+80jpI=
X-Received: by 2002:a2e:9e54:0:b0:250:d6c8:c2a6 with SMTP id
 g20-20020a2e9e54000000b00250d6c8c2a6mr46776253ljk.16.1654288147938; Fri, 03
 Jun 2022 13:29:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220520173638.94324-1-juew@google.com> <20220520173638.94324-2-juew@google.com>
 <CALzav=c9wmDSNP9=RAGsFKob9D+iR4kTXwhpGuQEXuBDCDg5UA@mail.gmail.com>
In-Reply-To: <CALzav=c9wmDSNP9=RAGsFKob9D+iR4kTXwhpGuQEXuBDCDg5UA@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 3 Jun 2022 13:28:41 -0700
Message-ID: <CALzav=epUxLgt6+pJpPqoXi8yL8fsXP5C_qMK5i0gJwaygGNBw@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] KVM: x86: Make APIC_VERSION capture only the magic 0x14UL.
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>
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

On Fri, Jun 3, 2022 at 11:58 AM David Matlack <dmatlack@google.com> wrote:
>
> On Fri, May 20, 2022 at 10:36 AM Jue Wang <juew@google.com> wrote:
> >
> > To implement Corrected Machine Check Interrupt (CMCI) as another
> > LVT vector, the APIC LVT logic needs to be able to handle an additional
> > LVT vector conditioned on whether MCG_CMCI_P is enabled on the vCPU,
> > this is because CMCI signaling can only be enabled when the CPU's
> > MCG_CMCI_P bit is set (Intel SDM, section 15.3.1.1).
> >
> > This patch factors out the dependency on KVM_APIC_LVT_NUM from the
> > APIC_VERSION macro. In later patches, KVM_APIC_LVT_NUM will be replaced
> > with a helper kvm_apic_get_nr_lvt_entries that reports different LVT
> > number conditioned on whether MCG_CMCI_P is enabled on the vCPU.
>
> Prefer to state what the patch does first, then explain why. Also
> please to use more precise language, especially when referring to
> architectural concepts. For example, I don't believe there is any such
> thing as an "LVT vector".

BTW, these suggestions apply to the entire series.

>
> Putting that together, how about something like this:
>
> Refactor APIC_VERSION so that the maximum number of LVT entries is
> inserted at runtime rather than compile time. This will be used in a
> subsequent commit to expose the LVT CMCI Register to VMs that support
> Corrected Machine Check error counting/signaling
> (IA32_MCG_CAP.MCG_CMCI_P=1).
>
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Jue Wang <juew@google.com>
> > ---
> >  arch/x86/kvm/lapic.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 66b0eb0bda94..a5caa77e279f 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -54,7 +54,7 @@
> >  #define PRIo64 "o"
> >
> >  /* 14 is the version for Xeon and Pentium 8.4.8*/
> > -#define APIC_VERSION                   (0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
> > +#define APIC_VERSION                   0x14UL
> >  #define LAPIC_MMIO_LENGTH              (1 << 12)
> >  /* followed define is not in apicdef.h */
> >  #define MAX_APIC_VECTOR                        256
> > @@ -401,7 +401,7 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
> >  void kvm_apic_set_version(struct kvm_vcpu *vcpu)
> >  {
> >         struct kvm_lapic *apic = vcpu->arch.apic;
> > -       u32 v = APIC_VERSION;
> > +       u32 v = APIC_VERSION | ((KVM_APIC_LVT_NUM - 1) << 16);
> >
> >         if (!lapic_in_kernel(vcpu))
> >                 return;
> > --
> > 2.36.1.124.g0e6072fb45-goog
> >
