Return-Path: <kvm+bounces-30988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA019BF223
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BD39285803
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0C620607C;
	Wed,  6 Nov 2024 15:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jn8WYfZs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD926202640
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730908062; cv=none; b=JfpNBNBaDQfjtOhDjIPtj3/ToJU+eqj4nN5VvoarsgYvG15M7BWbo3hfWWsn2yd5nzkg8OFZQ9lwbvS3sJe/XQrPV1XNUdHQxwh8oWAf8gFRZkLQThM7c9Z0RICi2jFACePDDywDpxCVg6c5jK9LYbrcB7/vdX5J5X+NrFnksu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730908062; c=relaxed/simple;
	bh=ud6DcSzqWACwYhSXKpIi1iUCAdnyqraoqLvk7kX+0bk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gk/nSRwvg/4fIi+MK3olGWhPI7MLQIg87/L/VE+9pIqERjM3ztoJyRT0vR6ay1iffP/MPa6h4711OKLZhIvkdPVEfUq+Y0ru2Yf3Lr+ZrhZL2g10nitdfilJI8p9Z2VzkiBSrcSdq5h6QJ5Rfe3T03Y0pOWx9iOk//1DaMvQfzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jn8WYfZs; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7e6cc094c2fso863900a12.1
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 07:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730908060; x=1731512860; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OBKgjcDNy+SPFAPsQ4A8KmJaHk3HzSgnQKeu+lAhFHE=;
        b=jn8WYfZsEPBmfRbdLwFEjx3WOT7fxGJ8djy0lBYElOP5+CPZmPTDFVE82cU64Ivoer
         EcHv+tFBdLaS0pfo+MN7sI0QGVM8kuO4JWVQb05rahw1G4eTwp0DrVgiRgQTzPX/MJ/i
         E3E652DE6D0acLt/v68/GKMaLEhwATA1NzMs7M32vEmDUPZBV+Fs6iizFL57Twux0uoP
         7KMEZDDe7U1uwF/C/MIuz0mpLNjHLDhCH5b9hDXK3fsuCN2LJxFfoqq8+dNOsv55Hzsy
         0lDtVsFsWBaGWcWevn3tv5eQyWRsO4rqoa/cSf/JhsstOD1UG6uZi7Q5BSAutYLcNQpq
         Tpew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730908060; x=1731512860;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OBKgjcDNy+SPFAPsQ4A8KmJaHk3HzSgnQKeu+lAhFHE=;
        b=ZPkH3ZfXr/iWgE86MUHOUWYWgBOHezUxC8GaDhq5rHEyV19nyqKQAiRj6sNfIcs1e6
         XEuaM6UVDUgh4UcFSG3F139mBiWtQfVhP5piR56JLAfZ4bjxP3wliMp9MtFbjpKs2SKV
         ZoMDJ+/ra2vB6arYn5YiIr0ogGYNpnROXI5Hnb5VXBhhS61AwOjkCfXzcyFfkFvccsp5
         QJkdY83a8/2PBiXBuAxJo/cvfFNZee2WOXRMmWM1/DY6gyw1yrGolrRO09i8RKE59pl/
         QZ8IhQI2/GvdOmuFVugIIq1Y3Mj6aGT+Ui9ioS3jUNjQHFUmrX21M+yoBERDNiZQLh1y
         QbgA==
X-Forwarded-Encrypted: i=1; AJvYcCUq4nAY6yN9fTQNwvZ7c0nEjbrG3B7rF8jqiqYVjIBAG86oVJR5Zoz1j3uMHBnvVboeQp0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWRqNNSFjV2veSH/fhhFhjqmPHoWnJsa/EqYeFJgPuT8bV7rT7
	HHkKzT9QSWNcVV2TaJCwCWO9GqokC70Y28lfCo2k1BnBbGJj2/71k4f15I5zsvvcobCXaXSGryd
	qWg==
X-Google-Smtp-Source: AGHT+IFYSZp6EfFzlya7zyiyA1G8w0vpviweHR7E4jrTqnyBCUF6T8C4eSn3eaOG7qNrrtWYvhWPAEY7DC4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:6b8c:b0:20c:60c7:6551 with SMTP id
 d9443c01a7336-2116cb00cabmr183645ad.5.1730908058898; Wed, 06 Nov 2024
 07:47:38 -0800 (PST)
Date: Wed, 6 Nov 2024 07:47:37 -0800
In-Reply-To: <CAAH4kHba3yFuohazDHGXYDwymKhUkHeSRq2hpaoPOvYBs6tu5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105010558.1266699-1-dionnaglaze@google.com>
 <20241105010558.1266699-2-dionnaglaze@google.com> <Zyt-jxNsyMTH4f3q@google.com>
 <CAAH4kHba3yFuohazDHGXYDwymKhUkHeSRq2hpaoPOvYBs6tu5g@mail.gmail.com>
Message-ID: <ZyuPmXEeRK9KYDXh@google.com>
Subject: Re: [PATCH v4 1/6] kvm: svm: Fix gctx page leak on invalid inputs
From: Sean Christopherson <seanjc@google.com>
To: Dionna Amalie Glaze <dionnaglaze@google.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 06, 2024, Dionna Amalie Glaze wrote:
> On Wed, Nov 6, 2024 at 6:34=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > KVM: SVM:
> >
> > In the future, please post bug fixes separately from new features serie=
s, especially
> > when the fix has very little to do with the rest of the series (AFAICT,=
 this has
> > no relation whatsoever beyond SNP).
> >
>=20
> Understood. Are dependent series best shared through links to a dev
> branch containing all patches?

I don't follow.  There is no dependency here.  If this series were moving
snp_context_create() out of KVM, then that would be a different story, i.e.=
 then
it _would_ be appropriate to include the fix at the front of the series.

If you end up a situation where a dependency is created after the initial p=
osting,
e.g. you post this fix, then later decide to move snp_context_create() out =
of KVM,
then simply call that out in the cover letter and provide a lore.kernel.org=
 link.

For large scale dependencies, e.g. multi-patch series that build on other m=
ulti-patch
series, then providing a link to a git branch is helpful.  But for somethin=
g this
trivial, it's overkill.

> > > ---
> > >  arch/x86/kvm/svm/sev.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 714c517dd4b72..f6e96ec0a5caa 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -2212,10 +2212,6 @@ static int snp_launch_start(struct kvm *kvm, s=
truct kvm_sev_cmd *argp)
> > >       if (sev->snp_context)
> > >               return -EINVAL;
> > >
> > > -     sev->snp_context =3D snp_context_create(kvm, argp);
> > > -     if (!sev->snp_context)
> > > -             return -ENOTTY;
> > > -
> > >       if (params.flags)
> > >               return -EINVAL;
> > >
> > > @@ -2230,6 +2226,10 @@ static int snp_launch_start(struct kvm *kvm, s=
truct kvm_sev_cmd *argp)
> > >       if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
> > >               return -EINVAL;
> > >
> > > +     sev->snp_context =3D snp_context_create(kvm, argp);
> > > +     if (!sev->snp_context)
> > > +             return -ENOTTY;
> >
> > Related to this fix, the return values from snp_context_create() are ga=
rbage.  It
> > should return ERR_PTR(), not NULL.  -ENOTTY on an OOM scenatio is blata=
ntly wrong,
> > as -ENOTTY on any SEV_CMD_SNP_GCTX_CREATE failure is too.
>=20
> I caught this too. I'll be changing that behavior with the new gctx
> management API from ccp in v5, i.e.,

Please fix the KVM flaws before moving code out of KVM, i.e. ensure the fla=
ws are
cleaned up even if we opt not to go the route of moving the code out of KVM=
 (which
I assume is what you plan to do with sev_snp_create_context()).

