Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D377AB929
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 20:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbjIVS2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 14:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjIVS2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 14:28:04 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2926AB
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 11:27:58 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so2528a12.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 11:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695407277; x=1696012077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnDAGVkzgeTWoaA5gXmZFU7gx+wJG7Q+DzR9vxQBpG0=;
        b=k9mQVKWwM+zsPLdKzxx7ORFBFPTTB7aSYeGAcPmk21F9U3jul7726hox9hp+c6RAEt
         fbzBerxnQZS0PiPuRCKnodAmEJr+ZzsvbAxXwS7GOuQmIWNIci+TPaQxvV5IBJLQnpxS
         PGh9IGPmG8y73cXhx62PbWQnCP9FAVAAzPD9l2hVCdaDkkkJcAVawnT4nuJpJf37C/yz
         ly+y/zWzNU/dBXTaPE3D8etQ/CowKUwyoYlD5R5COHFbNGkZmT6/CUNJRKnFmh43gGM5
         XlShK9ngkmzEhc9f7SPbhvrWZAWIEN5+eJ1nb/nPD3pFKO2hAQb9DB/NidB6Te8snj+U
         uD0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695407277; x=1696012077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CnDAGVkzgeTWoaA5gXmZFU7gx+wJG7Q+DzR9vxQBpG0=;
        b=MwaKRwIUxMwV2gMwPAtWX92OBugMglaZ+EoCjq3/nTmUIHJrAzy9/jJt5dqBFkbGsq
         Kt+MliBaKXQPoM7xqnJtcxeZN+xcGQ2F48VnUDCrkumqBTeH3frd5qH05tIvzMAvZnWq
         yWRdhcKfZBEw1tYFY+mSjBqRiUa73txBBFZOKzOJGMBk5t3heiTgmNIbn3Fzgljgfq9e
         V8JDowF8fte7N28yWECFhl/oxWCl2n6o3wfbVoytpKusVUdbtoZe2W13HTNzx7hRbNIC
         gPG/xu8NQeDK8O6B3MXzhEPTzVdsuguPgBrIWM3YTyQFrBcOHpPjfnUPqv06bMvwLfu5
         qcIg==
X-Gm-Message-State: AOJu0Yw4sfeEIjhWr/vbBVJgknOCnwZrEo9fiGqWuHgw3fqV800w8rJw
        J/V2MSfn8WYZTeYILYCoHmxcwh2CkvJUgAZc8a6N9Q==
X-Google-Smtp-Source: AGHT+IHMaPzyi9TqSdGf5XRPW29qrXpoFmMxPSkreYGqnqn3+pjUZKmjSgkmJimilN/88X2mLj9YQspAMdjp6ItFAvA=
X-Received: by 2002:a50:a41d:0:b0:525:573c:6444 with SMTP id
 u29-20020a50a41d000000b00525573c6444mr20234edb.1.1695407276901; Fri, 22 Sep
 2023 11:27:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230922164239.2253604-1-jmattson@google.com> <20230922164239.2253604-2-jmattson@google.com>
 <ZQ3NHv9Yok8Uybzo@google.com> <CALMp9eQKB5mxb=OpvkvZEBLXzekrBYaz9z016A9Xp3-QpMJpUg@mail.gmail.com>
 <ZQ3Z25cu5gnsedqr@google.com>
In-Reply-To: <ZQ3Z25cu5gnsedqr@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 22 Sep 2023 11:27:44 -0700
Message-ID: <CALMp9eSQx5KWxDN97GTevxx-UkyAW8WCeVWbH0nAAnAY+phqKQ@mail.gmail.com>
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

On Fri, Sep 22, 2023 at 11:15=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Sep 22, 2023, Jim Mattson wrote:
> > On Fri, Sep 22, 2023 at 10:21=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > IMO, we should delete the offending kernel code.  I don't see how it =
provides any
> > > value these days.
> >
> > Sure, but that doesn't help legacy guests.
>
> Heh, IMO they don't need help, their owners just need to be placated ;-)
>
> > > And *if* we want to change something in KVM so that we stop getting c=
oustomer
> > > complaints about a useless bit, just let userspace stuff the bit.
> >
> > We want to make customers happy. That should not even be a question.
>
> Can we really not tell them "this is a benign guest bug, ignore it"?

What is the mechanism for doing that?

> > > I think we should also raise the issue with AMD (Borislav maybe?) and=
 ask/demand
> > > that bits in HWCR that KVM allows to be set are architecturally defin=
ed.  It's
> > > totally fine if the value of bit 24 is uarch specific, but the behavi=
or needs to
> > > be something that won't change from processor to processor.
> > >
> > > >       kvm_pmu_refresh(vcpu);
> > > >       vcpu->arch.cr4_guest_rsvd_bits =3D
> > > >           __cr4_reserved_bits(guest_cpuid_has, vcpu);
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 3421ed7fcee0..cb02a7c2938b 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -3699,12 +3699,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcp=
u, struct msr_data *msr_info)
> > > >               data &=3D ~(u64)0x40;     /* ignore flush filter disa=
ble */
> > > >               data &=3D ~(u64)0x100;    /* ignore ignne emulation e=
nable */
> > > >               data &=3D ~(u64)0x8;      /* ignore TLB cache disable=
 */
> > > > +             data &=3D ~(u64)0x1000000;/* ignore TscFreqSel */
> > > >
> > > >               /* Handle McStatusWrEn */
> > > >               if (data & ~BIT_ULL(18)) {
> > > >                       kvm_pr_unimpl_wrmsr(vcpu, msr, data);
> > > >                       return 1;
> > > >               }
> > > > +
> > > > +             /*
> > > > +              * When set, TscFreqSel is read-only. Attempts to
> > > > +              * clear it are ignored.
> > > > +              */
> > > > +             data |=3D vcpu->arch.msr_hwcr & BIT_ULL(24);
> > >
> > >
> > > The bit is read-only from the guest, but KVM needs to let userspace c=
lear the
> > > bit.
> >
> > Why? We don't let userspace clear bit 1 of EFLAGS, which is also a
> > "reads as one" bit.
>
> Because that's architectural behavior, not dependent on FMS, and KVM need=
s to
> write EFLAGS to have any hope of being useful, i.e. giving ownership of E=
FLAGS
> to userspace is not a realistic option.

Remind me what "MSR" stands for. :)

> As proposed, if userspace sets CPUID to a magic FMS, and then changes the=
 FMS to
> something else, kvm_vcpu_after_set_cpuid() will not clear the bit and KVM=
 will
> end up wrongly enumerating the bit.  I doubt userspace would ever do that=
, but
> it's at least possible.
>
> That could be fixed by actively clearing vcpu->arch.msr_hwcr for other FM=
S values,
> but then KVM would have to be 100% precise on the FMS matching, which wou=
ld be a
> maintenance nightmare.

What if I did something crude like we do for MSR_IA32_MISC_ENABLE, and
just set the bit at reset regardless of FMS:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cb02a7c2938b..4d7d0de42a9d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12086,6 +12086,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu,
bool init_event)
                vcpu->arch.msr_misc_features_enables =3D 0;
                vcpu->arch.ia32_misc_enable_msr =3D
MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |

MSR_IA32_MISC_ENABLE_BTS_UNAVAIL;
+               vcpu_arch.msr_hwcr =3D BIT_ULL(24);

                __kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
                __kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);

> In other words, userspace owns the vCPU model, and for good reasons.  KVM=
 needs
> to allow userspace to define a sane model, but with *very* few exceptions=
, KVM
> should not try to "help" userspace by stuffing bits.

Okay. What about the IA32_MISC_ENABLE bits above?

> Pretty much everytime KVM tries to help, it causes problems.  E.g. initia=
lizing
> perf_capabilities to kvm_caps.supported_perf_cap seems like a good thing,=
 except
> it presents a bogus model if userspace decides to not enumerate a vPMU to=
 the
> guest (Aaron was allegedly going to send a patch for this...).

KVM is nothing if not inconsistent.
