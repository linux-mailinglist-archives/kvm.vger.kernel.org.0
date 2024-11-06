Return-Path: <kvm+bounces-30971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71D1A9BF1B8
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:31:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32663282589
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B82204F7E;
	Wed,  6 Nov 2024 15:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o6ddjagw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD7420371C
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907044; cv=none; b=bTcwwsRAAKYVF2jzDJoKg/paVjm2BiYy5XYf4clxVPvX3QDulz1Mol0qU274TnypftJRNLVukBg8c8qmSNyh9NbZNeRfhH4e4R0df2ZSU+6CAD3SluP7saVMUeSoWWXFzIAPnLxZY/Fv1eGq1I8qXWJOpFvlFKSkC0YFOzkkJtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907044; c=relaxed/simple;
	bh=7pxkvJH0rBoxXFWeHo3gNIGCvGy/7Vi3eCLxZlm+vcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r0dNh3V/2sGqxp7ReB60/AaoqBmLakYujBwcma552cyI7jN6D7SE5mdsobCVHqDxIRZZEp3isF1+5653ZF6A3jBL/gv39KoA0b5bMj3N/4O1n9aVyqCIEQDO3cxbsRFt2bUFKtWICke2mc9k+5J4CmYDMmtmymmFYDkGBckH/0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o6ddjagw; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a99e3b3a411so181825766b.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 07:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730907040; x=1731511840; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K3uSmY0ZqL8Ver5o/edt81IkDBUpVzSXDkat7VuPWyk=;
        b=o6ddjagwAJuTrXTAB7aCjsxyhh2Uqd16Jm+nu8kuQeZnvVd8YVDnsQPDewBvEHUiRO
         bJhpblZuC8yXhEzzpyAZIEHlB9jaN3xJgE+FxCDx3ko8rzxvlpRxfR1sK93YdbXuPX/K
         oT+WT/iBlwA35EN2PFcVGTiNqGFAoLX2CQKdiE7iQoKfmlozTThPILDzx+r6C1oLZchS
         Wk2tq34NF9fKFw6ynSVvoR8HK+MZPpE+6NG+4VQ0Xaezrb31nlavCtC1q0KBuqoUGSPY
         /BszCb/CnyZmZcSqsRusL3UXbeKR83KHooxcqwfLlJvOnF76dRyHRK8F+1IlnQXyqv47
         iyGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730907040; x=1731511840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K3uSmY0ZqL8Ver5o/edt81IkDBUpVzSXDkat7VuPWyk=;
        b=YJHYnjWyKPDGzPfhO3CgeZawT3eryiYgcTfGOvR5WUqSe8lYrLVMpiRbQY9f9BUWua
         TMz7w1frIZikbCW0hcLU2IG0jkDSi6DRm6yuJw5oLWsRlYtmClXH+1cv/IUJuBi4cfnb
         zgUSMmmD7WApy28OEjSort0xa6J435ahv9tC5ZnXGVUabziYzZny3BdXZZv+eQKGJa87
         si5ko/wNw7WLPpOYy1OD54yhSPLFljkHrgCMuXZUwXtsQsqTwkBrszUJUAEsxy2w0APW
         HLmHRbirKmvaivIvDAj/p6swVJXVYPQG+gpdbbUoP4bBYteFz/+SVdNUJ6HwXG5KzMdZ
         gDFA==
X-Forwarded-Encrypted: i=1; AJvYcCVccr521MEwqDTKUHwQE/N5gFsJPQxqS3OMBZ5VTIQYCAwJNMljgwWolu82O18y1iG1vKc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPpJqhQuaL7B41FLLq3DhZxweUWfnODbgeRHIrApgPyLJHRUmt
	u8JAhMa/kdpx2jfXyPoa5hpNDF4gfpNGgDdNbuSHdvpv2/Cc0ALCj8D9RINQyLRjEZBK7+d05wn
	2suOomG/roTITM2YBqkVq/YmR57iE+2MvqfN8
X-Google-Smtp-Source: AGHT+IFj6pXumSSZ/p1UajDNTPiKe3GPiNi2O7Kz8sjpSrXMvKdRtAac8kpdZmmQ89AvFWH4NUkZMzqTk3vmpppM/OM=
X-Received: by 2002:a17:906:7305:b0:a99:f5d8:726 with SMTP id
 a640c23a62f3a-a9ec665831cmr304293066b.23.1730907040104; Wed, 06 Nov 2024
 07:30:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105010558.1266699-1-dionnaglaze@google.com>
 <20241105010558.1266699-2-dionnaglaze@google.com> <Zyt-jxNsyMTH4f3q@google.com>
In-Reply-To: <Zyt-jxNsyMTH4f3q@google.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Wed, 6 Nov 2024 07:30:27 -0800
Message-ID: <CAAH4kHba3yFuohazDHGXYDwymKhUkHeSRq2hpaoPOvYBs6tu5g@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] kvm: svm: Fix gctx page leak on invalid inputs
To: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Michael Roth <michael.roth@amd.com>, 
	Brijesh Singh <brijesh.singh@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>, 
	Danilo Krummrich <dakr@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Tianfei zhang <tianfei.zhang@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 6:34=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> KVM: SVM:
>
> In the future, please post bug fixes separately from new features series,=
 especially
> when the fix has very little to do with the rest of the series (AFAICT, t=
his has
> no relation whatsoever beyond SNP).
>

Understood. Are dependent series best shared through links to a dev
branch containing all patches?

> On Tue, Nov 05, 2024, Dionna Glaze wrote:
> > Ensure that snp gctx page allocation is adequately deallocated on
> > failure during snp_launch_start.
> >
> > Fixes: 136d8bc931c8 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command")
>
> This needs
>
> Cc: stable@vger.kernel.org
>
> especially if it doesn't get into 6.12.
>
> > CC: Sean Christopherson <seanjc@google.com>
> > CC: Paolo Bonzini <pbonzini@redhat.com>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Ingo Molnar <mingo@redhat.com>
> > CC: Borislav Petkov <bp@alien8.de>
> > CC: Dave Hansen <dave.hansen@linux.intel.com>
> > CC: Ashish Kalra <ashish.kalra@amd.com>
> > CC: Tom Lendacky <thomas.lendacky@amd.com>
> > CC: John Allen <john.allen@amd.com>
> > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: Michael Roth <michael.roth@amd.com>
> > CC: Luis Chamberlain <mcgrof@kernel.org>
> > CC: Russ Weight <russ.weight@linux.dev>
> > CC: Danilo Krummrich <dakr@redhat.com>
> > CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > CC: "Rafael J. Wysocki" <rafael@kernel.org>
> > CC: Tianfei zhang <tianfei.zhang@intel.com>
> > CC: Alexey Kardashevskiy <aik@amd.com>
> >
> > Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
>
> Acked-by: Sean Christopherson <seanjc@google.com>
>
> Paolo, do you want to grab this one for 6.12 too?
>
> > ---
> >  arch/x86/kvm/svm/sev.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 714c517dd4b72..f6e96ec0a5caa 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2212,10 +2212,6 @@ static int snp_launch_start(struct kvm *kvm, str=
uct kvm_sev_cmd *argp)
> >       if (sev->snp_context)
> >               return -EINVAL;
> >
> > -     sev->snp_context =3D snp_context_create(kvm, argp);
> > -     if (!sev->snp_context)
> > -             return -ENOTTY;
> > -
> >       if (params.flags)
> >               return -EINVAL;
> >
> > @@ -2230,6 +2226,10 @@ static int snp_launch_start(struct kvm *kvm, str=
uct kvm_sev_cmd *argp)
> >       if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
> >               return -EINVAL;
> >
> > +     sev->snp_context =3D snp_context_create(kvm, argp);
> > +     if (!sev->snp_context)
> > +             return -ENOTTY;
>
> Related to this fix, the return values from snp_context_create() are garb=
age.  It
> should return ERR_PTR(), not NULL.  -ENOTTY on an OOM scenatio is blatant=
ly wrong,
> as -ENOTTY on any SEV_CMD_SNP_GCTX_CREATE failure is too.
>

I caught this too. I'll be changing that behavior with the new gctx
management API from ccp in v5, i.e.,

/**
 * sev_snp_create_context - allocates an SNP context firmware page
 *
 * Associates the created context with the ASID that an activation
 * call after SNP_LAUNCH_START will commit. The association is needed
 * to track active GCTX pages to refresh during firmware hotload.
 *
 * @asid:    The ASID allocated to the caller that will be used in a
subsequent SNP_ACTIVATE.
 * @psp_ret: sev command return code.
 *
 * Returns:
 * A pointer to the SNP context page, or an ERR_PTR of
 * -%ENODEV    if the PSP device is not available
 * -%ENOTSUPP  if PSP device does not support SEV
 * -%ETIMEDOUT if the SEV command timed out
 * -%EIO       if PSP device returned a non-zero return code
 */
void *sev_snp_create_context(int asid, int *psp_ret);

/**
 * sev_snp_activate_asid - issues SNP_ACTIVATE for the asid and
associated GCTX page.
 *
 * @asid:    The ASID to activate.
 * @psp_ret: sev command return code.
 *
 * Returns:
 * 0 if the SEV device successfully processed the command
 * -%ENODEV    if the PSP device is not available
 * -%ENOTSUPP  if PSP device does not support SEV
 * -%ETIMEDOUT if the SEV command timed out
 * -%EIO       if PSP device returned a non-zero return code
 */
int sev_snp_activate_asid(int asid, int *psp_ret);

/**
 * sev_snp_guest_decommission - issues SNP_DECOMMISSION for an asid's
GCTX page and frees it.
 *
 * @asid:    The ASID to activate.
 * @psp_ret: sev command return code.
 *
 * Returns:
 * 0 if the SEV device successfully processed the command
 * -%ENODEV    if the PSP device is not available
 * -%ENOTSUPP  if PSP device does not support SEV
 * -%ETIMEDOUT if the SEV command timed out
 * -%EIO       if PSP device returned a non-zero return code
 */
int sev_snp_guest_decommission(int asid, int *psp_ret);

> > +
> >       start.gctx_paddr =3D __psp_pa(sev->snp_context);
> >       start.policy =3D params.policy;
> >       memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
> > --
> > 2.47.0.199.ga7371fff76-goog
> >



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

