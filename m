Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9867AB809
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 19:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjIVRtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 13:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjIVRtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 13:49:01 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A188F
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 10:48:55 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-53317e29b00so1817a12.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 10:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695404934; x=1696009734; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhGuM0Q4auyy7BuCTTo7tiqMyVBh5ydDrIuyAUwAZzs=;
        b=NQkLxkdA4fW3o+dL/dSd9XciAMcE/CNK8zBGoupurbkbqUhRRVou0GMprtlnEbvKPI
         Nfs00+jHj/j6oOBfL4lYT3yr9viXQrsbmPM3HSQjAnY9+kFcUxM8KGc8dJLvjxjRuWPL
         8H4C8vhXuWiP2/K56U/B1OJmleBbGp8vK/s3AXV8ySedILrnmlhYwGh4914hg/o8xIQB
         U+y2Qhq3/VABAiPBh/Vc5GuKnHt80r2MCYzAK60CvqfPKSr2nHb8Iu4PFT/DxW6kLl46
         qhYxzsvFoxSbdQpE7UbxvMFd8Qw8kVWIBatMS0J9uGqnMGIIRkGZRJbyjXonHxhJfScW
         fuyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695404934; x=1696009734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HhGuM0Q4auyy7BuCTTo7tiqMyVBh5ydDrIuyAUwAZzs=;
        b=wWj1Fucrhev5PMypEBzKjWHqifON8JxQDDrXvwLVvesHRnjkohIPbTOdX0lF7b94xl
         k+N9pLuM9dsjTImCpRaCyoPeuI9PUk9zssdgEugPedPB2pBDR8FKv2xLy2kvsXLX6M/U
         GHPLe4F1w53yXqU+yv6xbUPo2ieS51VJXMyKADlSopmH0IF4VuRk2XIZkrKIzqi4NMVb
         XPLLHFbX/QJZfJ2hGGtv3URek5wEGYK+cCfGN617P/jUyuTQYPmj+77gDOM9TqnRrawD
         EWzlmxBKp7arYxniTPnSD2xITbxJGkqas1XUIiTvQ4AXixUc7eBPBwyrpYaI7iZMJb6x
         Ky4g==
X-Gm-Message-State: AOJu0YyLVcdQnGdnjY37gPgJQYyDE6w0nUPfHKLKvhLC0tT9/5Zr1Pag
        +H1E4zFZYPMYxaiEz6tC59XMQy5NodKJWraJ451gaQ==
X-Google-Smtp-Source: AGHT+IFAW4byvqWTI8BH+gaDGM48PCWY/0fWy6PNi1kvr5pz+8Gz5AxMVxhSVrp6anlQDZ3WfnVHvh/2hAV5fB0V10s=
X-Received: by 2002:a50:c048:0:b0:522:4741:d992 with SMTP id
 u8-20020a50c048000000b005224741d992mr11354edd.4.1695404933610; Fri, 22 Sep
 2023 10:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230922164239.2253604-1-jmattson@google.com> <20230922164239.2253604-2-jmattson@google.com>
 <ZQ3NHv9Yok8Uybzo@google.com>
In-Reply-To: <ZQ3NHv9Yok8Uybzo@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 22 Sep 2023 10:48:38 -0700
Message-ID: <CALMp9eQKB5mxb=OpvkvZEBLXzekrBYaz9z016A9Xp3-QpMJpUg@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Sep 22, 2023 at 10:21=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Sep 22, 2023, Jim Mattson wrote:
> > On certain CPUs, Linux guests expect HWCR.TscFreqSel[bit 24] to be
> > set. If it isn't set, they complain:
> >       [Firmware Bug]: TSC doesn't count with P0 frequency!
> >
> > Eliminate this complaint by setting the bit on virtual processors for
> > which Linux guests expect it to be set.
> >
> > Note that this bit is read-only on said processors.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 10 ++++++++++
> >  arch/x86/kvm/x86.c   |  7 +++++++
> >  2 files changed, 17 insertions(+)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 0544e30b4946..2d7dcd13dcc3 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -373,6 +373,16 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vc=
pu *vcpu)
> >       vcpu->arch.maxphyaddr =3D cpuid_query_maxphyaddr(vcpu);
> >       vcpu->arch.reserved_gpa_bits =3D kvm_vcpu_reserved_gpa_bits_raw(v=
cpu);
> >
> > +     /*
> > +      * HWCR.TscFreqSel[bit 24] has a reset value of 1 on some process=
ors.
> > +      */
> > +     if (guest_cpuid_is_amd_or_hygon(vcpu) &&
> > +         guest_cpuid_has(vcpu, X86_FEATURE_CONSTANT_TSC) &&
> > +         (guest_cpuid_family(vcpu) > 0x10 ||
> > +          (guest_cpuid_family(vcpu) =3D=3D 0x10 &&
> > +           guest_cpuid_model(vcpu) >=3D 2)))
> > +             vcpu->arch.msr_hwcr |=3D BIT(24);
>
> Oh hell no.  It's bad enough that KVM _allows_ setting uarch specific bit=
s, but
> actively setting bits is a step too far.

The bit should be set on power on. From the PPR for AMD Family 17h
Model 01h, Revision B1 Processors,

> TscFreqSel: TSC frequency select. Read-only. Reset: 1.

Leaving it clear is a violation of the CPU vendor's hardware specification.

> IMO, we should delete the offending kernel code.  I don't see how it prov=
ides any
> value these days.

Sure, but that doesn't help legacy guests.

> And *if* we want to change something in KVM so that we stop getting coust=
omer
> complaints about a useless bit, just let userspace stuff the bit.

We want to make customers happy. That should not even be a question.

> I think we should also raise the issue with AMD (Borislav maybe?) and ask=
/demand
> that bits in HWCR that KVM allows to be set are architecturally defined. =
 It's
> totally fine if the value of bit 24 is uarch specific, but the behavior n=
eeds to
> be something that won't change from processor to processor.
>
> >       kvm_pmu_refresh(vcpu);
> >       vcpu->arch.cr4_guest_rsvd_bits =3D
> >           __cr4_reserved_bits(guest_cpuid_has, vcpu);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 3421ed7fcee0..cb02a7c2938b 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3699,12 +3699,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, s=
truct msr_data *msr_info)
> >               data &=3D ~(u64)0x40;     /* ignore flush filter disable =
*/
> >               data &=3D ~(u64)0x100;    /* ignore ignne emulation enabl=
e */
> >               data &=3D ~(u64)0x8;      /* ignore TLB cache disable */
> > +             data &=3D ~(u64)0x1000000;/* ignore TscFreqSel */
> >
> >               /* Handle McStatusWrEn */
> >               if (data & ~BIT_ULL(18)) {
> >                       kvm_pr_unimpl_wrmsr(vcpu, msr, data);
> >                       return 1;
> >               }
> > +
> > +             /*
> > +              * When set, TscFreqSel is read-only. Attempts to
> > +              * clear it are ignored.
> > +              */
> > +             data |=3D vcpu->arch.msr_hwcr & BIT_ULL(24);
>
>
> The bit is read-only from the guest, but KVM needs to let userspace clear=
 the
> bit.

Why? We don't let userspace clear bit 1 of EFLAGS, which is also a
"reads as one" bit.
