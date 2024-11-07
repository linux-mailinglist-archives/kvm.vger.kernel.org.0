Return-Path: <kvm+bounces-31191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A869C11B5
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 23:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C80F11F25150
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 22:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318BB218D99;
	Thu,  7 Nov 2024 22:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C1AeZmiI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB82B212D30
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 22:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731018755; cv=none; b=I4QehdvigI09d9e45cdVi59y0mBFGX6aeF6LKNsDrlr6sG0XpWtKDyVCKxc+yCxJNsIE+inhSlmcQD7NF5fk6tIGSpeMgb48Ch6ikaE4FFHu3uBvnVzQEuITcAizb173XGqjXl6krWyPPHK4nklXdvjR4Elx/4BdDphFCkFteYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731018755; c=relaxed/simple;
	bh=hgceEYWbNgenk5ztiLvob2RCbb5hxkvrKWHpbPAKSGM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RPMRGv3AjBcmsBIxOn+uJjfiUp2+4yQkey0XfvpFGPd62dGR6w0EZxRul4vfmQITN7M7hCPW4X4VLvQYhyQ3ssyS/w9J6CFgEinCxyhj4eGceFFhl94dvJwZCyyCxkp5nRI2GkdnrQwBhJJc4fpW0p+q4g5xbaz5FBVHQpnjIbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C1AeZmiI; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e30cf48435fso2419055276.0
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 14:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731018753; x=1731623553; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e4vY0bI5vuWGCkQbYf92s3szBV/rAuFWIqfr4MnYBjM=;
        b=C1AeZmiIHxc5zKxBaW3bdqvGU6Tciltj4FFfq6AfeAih2gLa5ehOqdbIVqHkf5qPZ6
         noeMeBWfM+vIS6x5mcWAbSFY85XuEY1QmRNE+xfECnQuV+khanPlAC26GwRzA2KxAn3J
         Lc3iYNYM9iSI0AEoE8e7lVxyDH/h+M3VNB0gv7Vq+kj0nnNZ9W5qT/xz48zKaQ28yrT/
         FmSJyALzkhPwEaZiLtjxRlddAR3oLGnODLynOiHIPvBsjQ3qadwwZIJaHcZkugx7G0yB
         Lvk/lnEBuS/GD9qnflpyuh5zNDadY0MorZzdUcSp5GM79LuJgkXHBEO46I3NgZ6BiEhV
         OPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731018753; x=1731623553;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e4vY0bI5vuWGCkQbYf92s3szBV/rAuFWIqfr4MnYBjM=;
        b=R5P472NYF2aIME8j4/QmTCyG/NdxTjk99nnOuC+C/elNlHZx3aMWw1o1wNwZJUeEjK
         hXg2tBedLYvvKvQ4a9imOM/CNG4yRhxw5w0qrBKoEr4VccduOAekXz3No2H+QVQ8yJ7A
         LyUbcdzRyznyJI5hqc1VQSupV7r3LVihqSPkan9u9vMmwDqCOojeF+gEJ65TcobHSsBC
         e5QtEY84Z1xKDmtFFfDSXu4I+PsWq/Pgqb8xoYA0KjOPcyodws+51b36EEHxZXr+gB4u
         wNYlgMLCYDTKEs+KkfqbrB61PgHezjgVd3d8TdBWFXyqmu4Tl4QuEwnf6rVOdkXr/x0J
         M5fQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdMW6Xx97ENm1NcKgxlUB6j7/S3J8nLVkTSKO0RcDswDv1XQo5CkU12ke8BophpYhAGc8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCKr9HK8im2R3iG2Y1dq/3pi85sGQv78j4hvmMIthNfuEDOcds
	nVTKfxBkMTp2tyQR92vJZijshecHuQ6F38SoVYV0ABJM2qSRzn5tKX9WOmsg7euTxKhnr2oqiXI
	eaQ==
X-Google-Smtp-Source: AGHT+IGKXmE1nSEKaGpFn0x/nPSLRIPy2ki8n3MOo4lOfbtlHCujpBbzF9Ro6Y+PO/jXSoxIoMz6Wfh67BY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:86c4:0:b0:e30:c741:ab06 with SMTP id
 3f1490d57ef6-e337f8ca272mr571276.5.1731018752699; Thu, 07 Nov 2024 14:32:32
 -0800 (PST)
Date: Thu, 7 Nov 2024 14:32:31 -0800
In-Reply-To: <CABQX2QMR=Nsn23zojFdhemR7tvGUz6_UM8Rgf6WLsxwDqoFtxg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241030033514.1728937-1-zack.rusin@broadcom.com>
 <20241030033514.1728937-3-zack.rusin@broadcom.com> <CABgObfaRP6zKNhrO8_atGDLcHs=uvE0aT8cPKnt_vNHHM+8Nxg@mail.gmail.com>
 <CABQX2QMR=Nsn23zojFdhemR7tvGUz6_UM8Rgf6WLsxwDqoFtxg@mail.gmail.com>
Message-ID: <Zy0__5YB9F5d0eZn@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Add support for VMware guest specific hypercalls
From: Sean Christopherson <seanjc@google.com>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Doug Covelli <doug.covelli@broadcom.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Arnaldo Carvalho de Melo <acme@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Joel Stanley <joel@jms.id.au>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 04, 2024, Zack Rusin wrote:
> On Mon, Nov 4, 2024 at 5:13=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
> >
> > On Wed, Oct 30, 2024 at 4:35=E2=80=AFAM Zack Rusin <zack.rusin@broadcom=
.com> wrote:
> > >
> > > VMware products handle hypercalls in userspace. Give KVM the ability
> > > to run VMware guests unmodified by fowarding all hypercalls to the
> > > userspace.
> > >
> > > Enabling of the KVM_CAP_X86_VMWARE_HYPERCALL_ENABLE capability turns
> > > the feature on - it's off by default. This allows vmx's built on top
> > > of KVM to support VMware specific hypercalls.
> >
> > Hi Zack,
>=20
> Hi, Paolo.
>=20
> Thank you for looking at this.
>=20
> > is there a spec of the hypercalls that are supported by userspace? I
> > would like to understand if there's anything that's best handled in
> > the kernel.
>=20
> There's no spec but we have open headers listing the hypercalls.
> There's about a 100 of them (a few were deprecated), the full
> list starts here:
> https://github.com/vmware/open-vm-tools/blob/739c5a2f4bfd4cdda491e6a6f686=
9d88c0bd6972/open-vm-tools/lib/include/backdoor_def.h#L97
> They're not well documented, but the names are pretty self-explenatory.

At a quick glance, this one needs to be handled in KVM:

  BDOOR_CMD_VCPU_MMIO_HONORS_PAT

and these probably should be in KVM:

  BDOOR_CMD_GETTIME
  BDOOR_CMD_SIDT
  BDOOR_CMD_SGDT
  BDOOR_CMD_SLDT_STR
  BDOOR_CMD_GETTIMEFULL
  BDOOR_CMD_VCPU_LEGACY_X2APIC_OK
  BDOOR_CMD_STEALCLOCK

and these maybe? (it's not clear what they do, from the name alone)

  BDOOR_CMD_GET_VCPU_INFO
  BDOOR_CMD_VCPU_RESERVED

> > If we allow forwarding _all_ hypercalls to userspace, then people will
> > use it for things other than VMware and there goes all hope of
> > accelerating stuff in the kernel in the future.

To some extent, that ship has sailed, no?  E.g. do KVM_XEN_HVM_CONFIG with
KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL set, and userspace can intercept pretty =
much
all hypercalls with very few side effects.

> > So even having _some_ checks in the kernel before going out to
> > userspace would keep that door open, or at least try.
>=20
> Doug just looked at this and I think I might have an idea on how to
> limit the scope at least a bit: if you think it would help we could
> limit forwarding of hypercalls to userspace only to those that that
> come with a BDOOR_MAGIC (which is 0x564D5868) in eax. Would that help?

I don't think it addresses Paolo's concern (if I understood Paolo's concern
correctly), but it would help from the perspective of allowing KVM to suppo=
rt
VMware hypercalls and Xen/Hyper-V/KVM hypercalls in the same VM.

I also think we should add CONFIG_KVM_VMWARE from the get-go, and if we're =
feeling
lucky, maybe even retroactively bury KVM_CAP_X86_VMWARE_BACKDOOR behind tha=
t
Kconfig.  That would allow limiting the exposure to VMware specific code, e=
.g. if
KVM does end up handling hypercalls in-kernel.  And it might deter abuse to=
 some
extent.

