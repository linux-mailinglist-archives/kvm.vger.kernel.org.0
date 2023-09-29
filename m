Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5742E7B3356
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 15:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbjI2NSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 09:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbjI2NSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 09:18:53 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07CDB7
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 06:18:50 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-534694a9f26so11720a12.1
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 06:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695993529; x=1696598329; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ImiHgyMEGO63z4gGUf+Mr35oQ7zEaptMyjrKGfgmAFc=;
        b=OniZ1V3/D5GlUFfBW+X4lyXT4K/yhQ5T3WifIzTe2zRLwJ2OmKxaIckwdv2BpbZSGa
         guvgrWE9APnth7c2Xu36R7+z1G8tUwFKauw4Y/t8/W0wDnU0m56/1dG5z+Xh6/UJDuMn
         fv9YGkR4esCmUOopebqpCdNsvehCCzByWnclD2KIR7urICqWFzw1H1T9bMhoLfNiy/g2
         ZSto+RSo7ovF4avRKuNTbyBAmEigkA1xytNkOxeKEz4DtKU07YDSNxjC79iTpactwIy8
         K2j/KQb+YNEmBCODnw4SxIcmxx2RiZvrIcJSjq/EBGCa9iJMKU6PRCEkhFyyObkgL42C
         8Saw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695993529; x=1696598329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ImiHgyMEGO63z4gGUf+Mr35oQ7zEaptMyjrKGfgmAFc=;
        b=X5SsZ/S3lLzdnbbxP9ING1jW54QQIQ1XmYt0NEXqZVxzsfSMgU9nEA4hN2u/Zqcwk/
         UpqOYiacV/NQnXB6+RkMiUDevv6ehH68M1INH9u4+LNAFIMFm4VGxhOK+Dk78yxWylMj
         JOK3jJ39bZ8Awk7XZdfAa2Cp8DDhxH6WxM1RKzNJdeTENZwHboRHxtr8b94L8dhfUaBX
         LcwTO1oxGzvGxHC0hdf+zvIuHWhuifO1C18AWuYxG0COpOfcrvMJtTxjLdueG5p3JdP8
         68mJ/es+PKSnrbf0ZGL1xM6GPGQy/KNsd9XTxAIcZ5q9rU7mddQMneAv/FusbOMd9nCt
         WSlQ==
X-Gm-Message-State: AOJu0YzkUDForJrte8Zh05RXkxFc1sWK8VsVSuFZY/YQtE5d5NF/U9+/
        7vANjQN9fgkSM1muAxP/TH3EEpiXOeOmlGFjQlgprU6nC5jG101vTgtahw==
X-Google-Smtp-Source: AGHT+IGSf6VJrW7/wMX1j/NoWRBDaGJgLENeiAUIB8ifi6AjBWcZgHhwesswowjIG/fI29h8pWzTrZf/UbjtElhdlZA=
X-Received: by 2002:a50:c3c1:0:b0:52f:5697:8dec with SMTP id
 i1-20020a50c3c1000000b0052f56978decmr527870edf.4.1695993529026; Fri, 29 Sep
 2023 06:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230928185128.824140-1-jmattson@google.com> <20230928185128.824140-3-jmattson@google.com>
 <ZRYgpnMJb1XYCeUs@google.com>
In-Reply-To: <ZRYgpnMJb1XYCeUs@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 29 Sep 2023 06:18:32 -0700
Message-ID: <CALMp9eR++X5PCWGyVkZGxJoCnzTBUTs6f6yW=SzUXyejjUCgTQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
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

On Thu, Sep 28, 2023 at 5:56=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Sep 28, 2023, Jim Mattson wrote:
> > On certain CPUs, Linux guests expect HWCR.TscFreqSel[bit 24] to be
> > set. If it isn't set, they complain:
> >       [Firmware Bug]: TSC doesn't count with P0 frequency!
> >
> > Allow userspace to set this bit in the virtual HWCR to eliminate the
> > above complaint.
> >
> > Attempts to clear this bit from within the guest are ignored, to match
> > the behavior of modern AMD processors.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 1a323cae219c..9209fc0d1a51 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3700,11 +3700,26 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, s=
truct msr_data *msr_info)
> >               data &=3D ~(u64)0x100;    /* ignore ignne emulation enabl=
e */
> >               data &=3D ~(u64)0x8;      /* ignore TLB cache disable */
> >
> > -             /* Handle McStatusWrEn */
> > -             if (data & ~BIT_ULL(18)) {
> > +             /*
> > +              * Ignore guest attempts to set TscFreqSel.
> > +              */
>
> No need for a multi-line comment.
> /
> > +             if (!msr_info->host_initiated)
> > +                     data &=3D ~BIT_ULL(24);
>
> There's no need to clear this before the check below.  The (arguably usel=
ess)
> print will show the "supported" bit, but I can't imagine anyone will care=
.
>
> > +
> > +             /*
> > +              * Allow McStatusWrEn and (from the host) TscFreqSel.
>
> This is unnecessarily confusing IMO, just state that writes to TscFreqSel=
 are
> architecturally ignored.  This would also be an opportune time to explain=
 why
> KVM allows this stupidity...
>
> > +              */
> > +             if (data & ~(BIT_ULL(18) | BIT_ULL(24))) {
> >                       kvm_pr_unimpl_wrmsr(vcpu, msr, data);
> >                       return 1;
> >               }
> > +
> > +             /*
> > +              * TscFreqSel is read-only from within the
> > +              * guest. Attempts to clear it are ignored.
>
> Overly aggressive wrapping.
>
> How about this?
>
> ---
>  arch/x86/kvm/x86.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 791a644dd481..4dd64d359142 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3700,11 +3700,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, str=
uct msr_data *msr_info)
>                 data &=3D ~(u64)0x100;    /* ignore ignne emulation enabl=
e */
>                 data &=3D ~(u64)0x8;      /* ignore TLB cache disable */
>
> -               /* Handle McStatusWrEn */
> -               if (data & ~BIT_ULL(18)) {
> +               /*
> +                * Allow McStatusWrEn and TscFreqSel, some guests whine i=
f they
> +                * aren't set.
> +                */

The whining is only about TscFreqSel. KVM actually supports the
functionality of McStatusWrEn (i.e. allows the guest to write to the
MCi_STATUS MSRs).

How about...

/*
* Allow McStatusWrEn and TscFreqSel. (Linux guests from v3.2 through
* at least v6.6 whine if TscFreqSel is clear, depending on F/M/S.
*/

> +               if (data & ~(BIT_ULL(18) | BIT_ULL(24))) {
>                         kvm_pr_unimpl_wrmsr(vcpu, msr, data);
>                         return 1;
>                 }
> +
> +               /* TscFreqSel is architecturally read-only, writes are ig=
nored */

This isn't true. TscFreqSel is not architectural at all. On Family
10h, per https://www.amd.com/content/dam/amd/en/documents/archived-tech-doc=
s/programmer-references/31116.pdf,
it was R/W and powered on as 0. In Family 15h, one of the "changes
relative to Family 10H Revision D processors," per
https://www.amd.com/content/dam/amd/en/documents/archived-tech-docs/program=
mer-references/42301_15h_Mod_00h-0Fh_BKDG.pdf,
was:

=E2=80=A2 MSRC001_0015 [Hardware Configuration (HWCR)]:
  =E2=80=A2 Dropped TscFreqSel; TSC can no longer be selected to run at NB =
P0-state.

Despite the "Dropped" above, that same document later describes
HWCR[bit 24] as follows:

TscFreqSel: TSC frequency select. Read-only. Reset: 1. 1=3DThe TSC
increments at the P0 frequency

So, perhaps this block of code can just be dropped? Who really cares
if the guest changes the value (unless it goes on to kexec a new
kernel, which will whine about the bit being clear)?

> +               if (!msr_info->host_initiated)
> +                       data =3D ~(data & BIT_ULL(24)) |
> +                              (vcpu->arch.msr_hwcr & BIT_ULL(24));
>                 vcpu->arch.msr_hwcr =3D data;
>                 break;
>         case MSR_FAM10H_MMIO_CONF_BASE:
>
> base-commit: 831ee29a0d4a2219d30268f9fc577217d222e339
> --
>
