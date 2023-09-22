Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D03A7ABA2C
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 21:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjIVTlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 15:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjIVTlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 15:41:01 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AFBC6
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 12:40:55 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59b59e1ac70so41343587b3.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 12:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695411654; x=1696016454; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gmoldMWze5A2jzf4X9RY6Tco71MqHEl4RDJGXpsYRF8=;
        b=tHLvtn4iehlg2LUMNpSrj9Ork6vetAJHkxPM7tK6aEsYLCujsTjRe2TXACK1vrNObQ
         5TTa4rzqtuxzAvbQBOanFlhdKiYF8IdZQabfY+qn7xpIzKO3hh0MzeeIMe+Yrfhq1l5Y
         bprGt4Qd4oVM1qsFyiiqoXORoIKSmLVYJC89FKvZh+VkiKNIgd80ePES1kjhVVIRC/m3
         f8MSqiFrxy/Xv8P1QAFMwwFgM9graWdI8AdVL7xsanmVwvoM4SbP2+3Kp4SI9b+rqT8n
         YQarJZbpSadH4oDiUS8DlyWcWLV+EAyAnEHqm4OV12+5e+5DFoWqrGjpGJAk3oPS0cd5
         ZGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695411654; x=1696016454;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gmoldMWze5A2jzf4X9RY6Tco71MqHEl4RDJGXpsYRF8=;
        b=YRSVSKd+R+639LmY/BblA+wYJrCYkGrWyopS6EyuwT4PPL9MmYF1nkk9r7qWrEeU/H
         q05G45T3k+4PoKcIN6Z4jWoBl2MNMRebqajJJVrkV21JkJywmI6a0bX5TWpwXA/aGLl6
         XCsXT+TVweAxZAHQ+oiQTmCAEhV19C/A3JeomAhpTjlKcaLmcwL+MQmYhh4cD0rCZOIT
         GOZ6EWr7acJVXikMH7+HuY3EsGOnusivjddURUx3FzRo+JOjMBDb+wkcFKqgE4vvzNsl
         ZNd3qCRF8Ec7pDSf0yAGGEbZEn1chd3VauZViNyWW+mEZpiAX+IDPvWZA6MF4WTp9YBT
         i2gw==
X-Gm-Message-State: AOJu0YxP4KIRMIKZTxLo9QdqpvTryWYKD1YCou/ETBsb7a34DD202y/b
        wLUKpm3tsGsCxYT8k4CAn2HtFZH6NNM=
X-Google-Smtp-Source: AGHT+IGWfWGAEqFlND2J8U5QnPsCCp/FL4mqVj+v/AD/0/f5fRXu0EphCLuX6buMCo/W+LQj2a4rnecjJsM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c641:0:b0:57a:118a:f31 with SMTP id
 q1-20020a81c641000000b0057a118a0f31mr9534ywj.7.1695411654283; Fri, 22 Sep
 2023 12:40:54 -0700 (PDT)
Date:   Fri, 22 Sep 2023 12:40:52 -0700
In-Reply-To: <CALMp9eSQx5KWxDN97GTevxx-UkyAW8WCeVWbH0nAAnAY+phqKQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230922164239.2253604-1-jmattson@google.com> <20230922164239.2253604-2-jmattson@google.com>
 <ZQ3NHv9Yok8Uybzo@google.com> <CALMp9eQKB5mxb=OpvkvZEBLXzekrBYaz9z016A9Xp3-QpMJpUg@mail.gmail.com>
 <ZQ3Z25cu5gnsedqr@google.com> <CALMp9eSQx5KWxDN97GTevxx-UkyAW8WCeVWbH0nAAnAY+phqKQ@mail.gmail.com>
Message-ID: <ZQ3txHpC9XQ9mc8c@google.com>
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
> On Fri, Sep 22, 2023 at 11:15=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Fri, Sep 22, 2023, Jim Mattson wrote:
> > > On Fri, Sep 22, 2023 at 10:21=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > > IMO, we should delete the offending kernel code.  I don't see how i=
t provides any
> > > > value these days.
> > >
> > > Sure, but that doesn't help legacy guests.
> >
> > Heh, IMO they don't need help, their owners just need to be placated ;-=
)
> >
> > > > And *if* we want to change something in KVM so that we stop getting=
 coustomer
> > > > complaints about a useless bit, just let userspace stuff the bit.
> > >
> > > We want to make customers happy. That should not even be a question.
> >
> > Can we really not tell them "this is a benign guest bug, ignore it"?
>=20
> What is the mechanism for doing that?

Not my problem?  :-D

> > Because that's architectural behavior, not dependent on FMS, and KVM ne=
eds to
> > write EFLAGS to have any hope of being useful, i.e. giving ownership of=
 EFLAGS
> > to userspace is not a realistic option.
>=20
> Remind me what "MSR" stands for. :)

Heh, that acronym has long, long since lost all meaning.

Joking aside, I think KVM needs to set a very, very high bare for emulating=
 any
part of any MSR that is truly model specific.  IMO, it's far too likely tha=
t KVM
will be the one left holding the bag in such situations.

> > As proposed, if userspace sets CPUID to a magic FMS, and then changes t=
he FMS to
> > something else, kvm_vcpu_after_set_cpuid() will not clear the bit and K=
VM will
> > end up wrongly enumerating the bit.  I doubt userspace would ever do th=
at, but
> > it's at least possible.
> >
> > That could be fixed by actively clearing vcpu->arch.msr_hwcr for other =
FMS values,
> > but then KVM would have to be 100% precise on the FMS matching, which w=
ould be a
> > maintenance nightmare.
>=20
> What if I did something crude like we do for MSR_IA32_MISC_ENABLE, and
> just set the bit at reset regardless of FMS:

I'd prefer that over playing games with FMS.  Though my first chioce would =
still
be to punt the decision to userspace.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cb02a7c2938b..4d7d0de42a9d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12086,6 +12086,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu,
> bool init_event)
>                 vcpu->arch.msr_misc_features_enables =3D 0;
>                 vcpu->arch.ia32_misc_enable_msr =3D
> MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |
>=20
> MSR_IA32_MISC_ENABLE_BTS_UNAVAIL;
> +               vcpu_arch.msr_hwcr =3D BIT_ULL(24);
>=20
>                 __kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
>                 __kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
>=20
> > In other words, userspace owns the vCPU model, and for good reasons.  K=
VM needs
> > to allow userspace to define a sane model, but with *very* few exceptio=
ns, KVM
> > should not try to "help" userspace by stuffing bits.
>=20
> Okay. What about the IA32_MISC_ENABLE bits above?

One of the exceptions where I don't see a better option, and hopefully some=
thing
that Intel won't repeat in the future.  Though I'm not exactly brimming wit=
h
confidence that Intel won't retroactively add more "gotcha! unsupported!" b=
its
in the future when they realize they forgot add a useful CPUID feature bit.

> > Pretty much everytime KVM tries to help, it causes problems.  E.g. init=
ializing
> > perf_capabilities to kvm_caps.supported_perf_cap seems like a good thin=
g, except
> > it presents a bogus model if userspace decides to not enumerate a vPMU =
to the
> > guest (Aaron was allegedly going to send a patch for this...).
>=20
> KVM is nothing if not inconsistent.

Yeah, the existing inconsistencies are painful, but that's not a good reaso=
n to
continue what I see as bad behavior.
