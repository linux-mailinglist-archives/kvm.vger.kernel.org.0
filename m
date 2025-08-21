Return-Path: <kvm+bounces-55225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFE19B2EB34
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 362665A848B
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 02:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3C1258EC1;
	Thu, 21 Aug 2025 02:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZy9ibA4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530EF253F03;
	Thu, 21 Aug 2025 02:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755743406; cv=none; b=IYE15kAHSNvPAKg42bV2RFWvIeSfvxfg+j5nDvMZfcNwyHz0z060e7p2uMeLBQ9R0tt2BU3rrc8H96iyeg3yHXlxJNfpD27813bkEtcBCI8ytpP80BkHqlUy4miE+IK5yDlRB8MgspL6l/9ppAGcoKRqgxPgvjHVgSZxULcS53s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755743406; c=relaxed/simple;
	bh=hubpUThmEzsghOP3D/C7Zn97GmCl6Og8IXTCNTfgLvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RIdM4w5+PcxNEmLUV0k/NYBTwH348xOkKuwUIWR5a19olVEHn6dSBEucQmufw8gZbf7uNHuqJB3z3OFQVCQFJmyhvxdUoqCitWcI0IA3OZn7Sylx3uG28IjOWgPUQ7GHeahHe78uKmUbvOzwRqpAxYK1OxqnuIWP4bysZFzYUO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZy9ibA4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D18C116C6;
	Thu, 21 Aug 2025 02:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755743405;
	bh=hubpUThmEzsghOP3D/C7Zn97GmCl6Og8IXTCNTfgLvU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SZy9ibA4EDz7L62RgEWFEo9hJQ/vxQ7Fnp+Nd/4CfZpQe80EA5wZxZjxi3wz+nVAt
	 gXlqIhk6hRmGtUcUXCpN6PhuO5v5esX8Db5l9xiiwih47XGarB9LGrg/uORS1gPCXy
	 1igIdIsfCuOL9MOtsVqmJEO/1kB/pLA6mmuLJ/x+a42Z+8wWIh0wtd1jUDJyMXP6F6
	 LhblU1I/X/pbifS09DqxJr2UzyJX3BB72BMCprkGmxOwjHWQYJOV7CphUMo0Dwt7+B
	 ICzg6lqrcyWwMUYvvz9sX6sA/cL5BfqudbmMTrCQYRJHVAKTKSt1/hUDDOZjlU/MA/
	 nwxhf2v2WQQiw==
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a1b004a31so3227165e9.0;
        Wed, 20 Aug 2025 19:30:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUjZoqBfN7QssoxkDEnqFwbpSLPccbqNK/eA+gOVfV0eyGbpplVG+lll1+CDacL7FjaYPI=@vger.kernel.org, AJvYcCWegdbaSKfdSdZO1dOjAsp7WykhviJ+pJ1D9J3WdB5/HrNS8tvwdSIn4O6Kt2hE9YBR4Dwbm1Xr4jSYJu0u@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ4wMmB9hBpVroD91+kMnWfJOnNf2eeZUXtcaMclTPfNYkAQ7k
	b2MiaUo1f61EZWyToC7tK873sWpXgQviYGg+of6UiD6xwU+1EzFaKGl9SmAmgxnd+nq8cU3x/i0
	BvB6Ga0Qv+JqALUhv7y78enGMMQPlUdU=
X-Google-Smtp-Source: AGHT+IGYX4eEyPphK+rf6VYqExLd5m/PEgZbk79xQHbEyvtKvfzfhnDjWrlazH1kSQ3/wuGNLwSYdViL32OHBPoQlXg=
X-Received: by 2002:a05:600c:4587:b0:456:302:6dc3 with SMTP id
 5b1f17b1804b1-45b4d858a37mr4606865e9.26.1755743404380; Wed, 20 Aug 2025
 19:30:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820125952.71689-1-fangyu.yu@linux.alibaba.com>
 <20250820125952.71689-3-fangyu.yu@linux.alibaba.com> <aKXeXd4pZvoQmYB9@troy-wujie14pro-arch>
 <CAJF2gTRR0LTO-CbUMkyXisov3BeftN+UJzv99GX7KfqCxWxmUg@mail.gmail.com>
In-Reply-To: <CAJF2gTRR0LTO-CbUMkyXisov3BeftN+UJzv99GX7KfqCxWxmUg@mail.gmail.com>
From: Guo Ren <guoren@kernel.org>
Date: Thu, 21 Aug 2025 10:29:51 +0800
X-Gmail-Original-Message-ID: <CAJF2gTT9Py=wE9eHfY-i-cvoPatwFvRHq2dH1xznyX+GM8BxQw@mail.gmail.com>
X-Gm-Features: Ac12FXw_adGCNVjgTV_UXKrfw26y_tUOuHc9MjDbq3ZDuenvMG1Bo2H0ToRcxCg
Message-ID: <CAJF2gTT9Py=wE9eHfY-i-cvoPatwFvRHq2dH1xznyX+GM8BxQw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] RISC-V KVM: Remove unnecessary HGATP csr_read
To: Troy Mitchell <troy.mitchell@linux.dev>
Cc: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 9:25=E2=80=AFAM Guo Ren <guoren@kernel.org> wrote:
>
> On Wed, Aug 20, 2025 at 10:40=E2=80=AFPM Troy Mitchell <troy.mitchell@lin=
ux.dev> wrote:
> >
> > On Wed, Aug 20, 2025 at 08:59:52PM +0800, fangyu.yu@linux.alibaba.com w=
rote:
> > > From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>
> > >
> > > The HGATP has been set to zero in gstage_mode_detect(), so there
> > > is no need to save the old context. Unify the code convention
> > > with gstage_mode_detect().
> > >
> > > Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
> > > Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> > > ---
> > >  arch/riscv/kvm/vmid.c | 5 +----
> > >  1 file changed, 1 insertion(+), 4 deletions(-)
> > >
> > > diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> > > index 5f33625f4070..abb1c2bf2542 100644
> > > --- a/arch/riscv/kvm/vmid.c
> > > +++ b/arch/riscv/kvm/vmid.c
> > > @@ -25,15 +25,12 @@ static DEFINE_SPINLOCK(vmid_lock);
> > >
> > >  void __init kvm_riscv_gstage_vmid_detect(void)
> > >  {
> > > -     unsigned long old;
> > > -
> > >       /* Figure-out number of VMID bits in HW */
> > > -     old =3D csr_read(CSR_HGATP);
> > >       csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT=
) | HGATP_VMID);
> > >       vmid_bits =3D csr_read(CSR_HGATP);
> > >       vmid_bits =3D (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
> > >       vmid_bits =3D fls_long(vmid_bits);
> > > -     csr_write(CSR_HGATP, old);
> > > +     csr_write(CSR_HGATP, 0);
> > Is setting HGATP to 0 in gstage_mode_detect meaningless now?
> > If so, it might be better to drop it and just keep the one here.
> Sorry, I misunderstood here.
>
> 1. kvm_riscv_gstage_vmid_detect() & gstage_mode_detect() are indepent
> function, so keep csr_write(CSR_HGATP, 0) is considerable.
>
> 2. But your idea is good, because csr_write(CSR_HGATP, 0) would cause
> TLB flush in some micro-arch, which reduces the IPC. So, removing
> unnecessary CSR_write (CSR_HGATP, 0) is also considerable.
>
> I would update V4 to merge kvm_riscv_gstage_vmid_detect() &
> gstage_mode_detect() into a single function, inspired by your idea.
I found we can't remove "csr_write(CSR_HGATP, 0)" in
gstage_mode_detect(), because this patch needs to reset the HGATP when
mode check failure:
https://lore.kernel.org/linux-riscv/20250819004643.1884149-1-guoren@kernel.=
org/

I would update to v4, which collects these related patches together
for review convenience.

>
> >
> >                 - Troy
> >
> > >
> > >       /* We polluted local TLB so flush all guest TLB */
> > >       kvm_riscv_local_hfence_gvma_all();
> > > --
> > > 2.49.0
> > >
> > >
> > > _______________________________________________
> > > linux-riscv mailing list
> > > linux-riscv@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/linux-riscv
>
>
>
> --
> Best Regards
>  Guo Ren



--=20
Best Regards
 Guo Ren

