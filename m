Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D68A7AB8F4
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 20:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjIVSQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 14:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjIVSQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 14:16:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAE2A9
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 11:15:57 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59c27703cc6so35687437b3.2
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 11:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695406557; x=1696011357; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rqnOSWLWq6nLAaLKULqsHUaxck1PfZUtsIVWixoYO6g=;
        b=LCKx91E6fxLm/5sM1fjMlqdHO1B4w/p0sob5JsdSGVJFiDaplkrO412YMUDc22QGXI
         PgQuBmRkLNZnSa2YEsfpmrqWATWRqvAtr99V7CilSCimhyMYHj78szZYmkzMafrgMovE
         z/eF+n1G44xry9yoMWWgAd3zyeAUkCLtg7kNtwINMoBv0IXlsuDCHypiqbt7Wb79ttdM
         7bLrcz8Ym+h3GolXxeZ1o74ERnbvP0LfhDKVLu2ufWjRfbvt9ROwC8p1GGdhlXJPu0IM
         MGI0N+t6SzkJ8IPvtAbiresaSPuvNKrIpMOq6cOH+/1WpEst9/dO5u45iUSlpl2wqGCX
         DS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695406557; x=1696011357;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rqnOSWLWq6nLAaLKULqsHUaxck1PfZUtsIVWixoYO6g=;
        b=u8icTIDMDDVtpFefqjKq4Lh65FUVjLAFbyCXBzjY/hpb+NhE3JtbosfmAU1F3FcCxS
         EVx7jc5kFRGkkTcxKjY8+RujyhaZ/5j0Ot0Vn8ovKWQZWadv0uAza0rv2WCnIIQUabkE
         sZDtt8H2S5pRtOTOTpVXQy/QoQxO4HJHw9MKHqDrk65Kf1VRRtMVTnKHwk8aOO+xoeXQ
         dWLaNdKJ73xJ/a2CiVZr2YVmVeI04OMb9suppGRbj9wr/G4Z+hjoa6nd2LPcDCxKSaFb
         1DEzLDNIp5AoTY4wgGChstrqkK60mELl3z9X7hGcRBYF6HZrr/Sp0c1V7K7WUp6InRE1
         e6Ow==
X-Gm-Message-State: AOJu0YxJYOzbtrXxXiLgEJmWXsj8mw+/3bL5KJOVdDmphaY5dlhsaoM3
        5yzMfVLRpBTa+j7gV7rC3mGYupRdTPE=
X-Google-Smtp-Source: AGHT+IG7uoTw7xuI0Fl5esEhwDXBz4ndIEsG4fGYCk6UTcXUI7WPVmbji6jpbo4WW3oSahq3yqwiosit3+g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:160c:b0:d85:aa2f:5715 with SMTP id
 bw12-20020a056902160c00b00d85aa2f5715mr777ybb.10.1695406556997; Fri, 22 Sep
 2023 11:15:56 -0700 (PDT)
Date:   Fri, 22 Sep 2023 11:15:55 -0700
In-Reply-To: <CALMp9eQKB5mxb=OpvkvZEBLXzekrBYaz9z016A9Xp3-QpMJpUg@mail.gmail.com>
Mime-Version: 1.0
References: <20230922164239.2253604-1-jmattson@google.com> <20230922164239.2253604-2-jmattson@google.com>
 <ZQ3NHv9Yok8Uybzo@google.com> <CALMp9eQKB5mxb=OpvkvZEBLXzekrBYaz9z016A9Xp3-QpMJpUg@mail.gmail.com>
Message-ID: <ZQ3Z25cu5gnsedqr@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023, Jim Mattson wrote:
> On Fri, Sep 22, 2023 at 10:21=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > IMO, we should delete the offending kernel code.  I don't see how it pr=
ovides any
> > value these days.
>=20
> Sure, but that doesn't help legacy guests.

Heh, IMO they don't need help, their owners just need to be placated ;-)

> > And *if* we want to change something in KVM so that we stop getting cou=
stomer
> > complaints about a useless bit, just let userspace stuff the bit.
>=20
> We want to make customers happy. That should not even be a question.

Can we really not tell them "this is a benign guest bug, ignore it"?

> > I think we should also raise the issue with AMD (Borislav maybe?) and a=
sk/demand
> > that bits in HWCR that KVM allows to be set are architecturally defined=
.  It's
> > totally fine if the value of bit 24 is uarch specific, but the behavior=
 needs to
> > be something that won't change from processor to processor.
> >
> > >       kvm_pmu_refresh(vcpu);
> > >       vcpu->arch.cr4_guest_rsvd_bits =3D
> > >           __cr4_reserved_bits(guest_cpuid_has, vcpu);
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 3421ed7fcee0..cb02a7c2938b 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -3699,12 +3699,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu,=
 struct msr_data *msr_info)
> > >               data &=3D ~(u64)0x40;     /* ignore flush filter disabl=
e */
> > >               data &=3D ~(u64)0x100;    /* ignore ignne emulation ena=
ble */
> > >               data &=3D ~(u64)0x8;      /* ignore TLB cache disable *=
/
> > > +             data &=3D ~(u64)0x1000000;/* ignore TscFreqSel */
> > >
> > >               /* Handle McStatusWrEn */
> > >               if (data & ~BIT_ULL(18)) {
> > >                       kvm_pr_unimpl_wrmsr(vcpu, msr, data);
> > >                       return 1;
> > >               }
> > > +
> > > +             /*
> > > +              * When set, TscFreqSel is read-only. Attempts to
> > > +              * clear it are ignored.
> > > +              */
> > > +             data |=3D vcpu->arch.msr_hwcr & BIT_ULL(24);
> >
> >
> > The bit is read-only from the guest, but KVM needs to let userspace cle=
ar the
> > bit.
>=20
> Why? We don't let userspace clear bit 1 of EFLAGS, which is also a
> "reads as one" bit.

Because that's architectural behavior, not dependent on FMS, and KVM needs =
to
write EFLAGS to have any hope of being useful, i.e. giving ownership of EFL=
AGS
to userspace is not a realistic option.

As proposed, if userspace sets CPUID to a magic FMS, and then changes the F=
MS to
something else, kvm_vcpu_after_set_cpuid() will not clear the bit and KVM w=
ill
end up wrongly enumerating the bit.  I doubt userspace would ever do that, =
but
it's at least possible.

That could be fixed by actively clearing vcpu->arch.msr_hwcr for other FMS =
values,
but then KVM would have to be 100% precise on the FMS matching, which would=
 be a
maintenance nightmare.

In other words, userspace owns the vCPU model, and for good reasons.  KVM n=
eeds
to allow userspace to define a sane model, but with *very* few exceptions, =
KVM
should not try to "help" userspace by stuffing bits.

Pretty much everytime KVM tries to help, it causes problems.  E.g. initiali=
zing
perf_capabilities to kvm_caps.supported_perf_cap seems like a good thing, e=
xcept
it presents a bogus model if userspace decides to not enumerate a vPMU to t=
he
guest (Aaron was allegedly going to send a patch for this...).
