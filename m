Return-Path: <kvm+bounces-10288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D90E86B52C
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 17:40:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89B77B25662
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313E4159587;
	Wed, 28 Feb 2024 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a6FzsXR8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A9E1332BC
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709138353; cv=none; b=OEsTufDjpgpYdlAYwg313wBEM0CFujmmb7R/Lxoh/Qve51ZF/abodKDN3rR2LGVCJG0msmS+xNKseI3XDlSnkAUsyjEzxxheRu3Ot735OtS94K8MBqkN3DQalMqJc+M7TP4vBc4JKdWmj71D28KUPJFP9fHoGd5gjI1IljmqYl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709138353; c=relaxed/simple;
	bh=WiX9KtC09wJJPUJJv7ze4L+SsXIBO6G3kahrWm3FGSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IgWjHetskof+Y74FNyuDdvjbktCp5hnilqAJBgqEUs8G9ll0D+tdUyzVhToROnyYu2mSqd3qWs2hqTba4ac0syka2muvI4vQg1T2I2daS5BXU5SNdZkwbj7I68SOdyszpKhv3RnqwU/YNNsFNwcIR2NNLX+I2q6vS5/u8Z7828Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a6FzsXR8; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcbfe1a42a4so10877885276.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 08:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709138351; x=1709743151; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=in1G4Nf0xBzdZL+ZLfa80V34ZfSkT4yQR98VuhCKCF4=;
        b=a6FzsXR8SB7SYky2iq60UtmubtZYgpRK3/8bDVgPdSyPZADqtHa4FlWe9i75HSi6f2
         BJGHqGR8USbY4jqa4+mScSkTrT/2LbfLyrX4DTBwQcP8qk7cLlzWoJfIizAhBBFoVMSC
         6FDI4qoujRKKzbz1bmaMgQH15GOHYznlWqTj5GLOnPY/SSde1i11bUgg5Sqg5gah2jhR
         UgR2J+D03P/+lkXTBEEjMK3eOuIlGvoCByvYCcGOl1dZ+/Z1+pwWPf1CoOMCgOx/wDp9
         cYSHF4JACV/Qi1nbTs1TQ1rmyA0h+f6pW7soj8hro5Xuyd7+LhM3+lvZv2B2X2VOm9zv
         tzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709138351; x=1709743151;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=in1G4Nf0xBzdZL+ZLfa80V34ZfSkT4yQR98VuhCKCF4=;
        b=RY8YF2bbOr1mXTGdQ1c+780Sc58UuKgj8BcsGb/3oMTPRNrg1lssREQhnI0vkuy4fv
         peVEO8yGmTTSqAiaP2d//oaPRly349D4occHi4/1P+ud1i+uhE2VFuUTxioofwXJsKVb
         T9FX47aaJtdVFB3yTfyfuPXPASH63rlxlK+JO6xfJYW8GK/PJgt1y+O5wFQUaugFe78w
         MVtXAm14Ywb3X5wVjDT86+PPPk8aNTFBpFPupHjDYOs9rhxjR4L+tdn2w5DuQvk1izNM
         ms6G4aiCW8XkJx5BpihU4EVEVEcq6GyIBl57eUcgU83RLluaDdkfvcrvDfKtgB7qHDEr
         /A0A==
X-Forwarded-Encrypted: i=1; AJvYcCV/HZP3/jmK5sz7xHPH4ZTtiyrr5mGGkiKWdLMuZ+w+jpEjETaGX4soT9udSn09R/v+CL7LWDcuq2cA0VqxYQGZhWEp
X-Gm-Message-State: AOJu0Yz3fHnggjFKTImkdXrzj/9XG6kQ3xIDMN/JzBV+TuyAOV9jw9mZ
	isHIQImBV97Sm0YWcN3xV7iBPU59PXK2+FQ5pDIQ+dQJNPDfq0kMmh531EVwRmAXUcWaRRByami
	x/g==
X-Google-Smtp-Source: AGHT+IFhfNyqrQkVj+BlwOzo9dGaRw3xoN6XW/JX6zn2UpjdUQ3bd6mSpfQCrTVfNzBjz3V+p7x34Jhjb18=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1507:b0:dc6:e1ed:bd1a with SMTP id
 q7-20020a056902150700b00dc6e1edbd1amr835132ybu.2.1709138350982; Wed, 28 Feb
 2024 08:39:10 -0800 (PST)
Date: Wed, 28 Feb 2024 08:39:09 -0800
In-Reply-To: <CABgObfYpRJnDdQrxp=OgjhbT9A+LHK36MHjMvzcQJsHAmfX++w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <Zd6LK7RpZZ8t-5CY@google.com>
 <CABgObfYpRJnDdQrxp=OgjhbT9A+LHK36MHjMvzcQJsHAmfX++w@mail.gmail.com>
Message-ID: <Zd9hrfJ5xRI6HeZp@google.com>
Subject: Re: [PATCH 00/21] TDX/SNP part 1 of n, for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024, Paolo Bonzini wrote:
> On Wed, Feb 28, 2024 at 2:25=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > Michael Roth (2):
> > >   KVM: x86: Add gmem hook for invalidating memory
> > >   KVM: x86: Add gmem hook for determining max NPT mapping level
> > >
> > > Paolo Bonzini (6):
> > >   KVM: x86/mmu: pass error code back to MMU when async pf is ready
> > >   KVM: x86/mmu: Use PFERR_GUEST_ENC_MASK to indicate fault is private
> >
> > This doesn't work.  The ENC flag gets set on any SNP *capable* CPU, whi=
ch results
> > in false positives for SEV and SEV-ES guests[*].
>=20
> You didn't look at the patch did you? :)

Guilty, sort of.  I looked (and tested) the patch from the TDX series, but =
I didn't
look at what you postd.  But it's a moot point, because now I did look at w=
hat you
posted, and it's still broken :-)

> It does check for has_private_mem (alternatively I could have dropped the=
 bit
> in SVM code for SEV and SEV-ES guests).

The problem isn't with *KVM* setting the bit, it's with *hardware* setting =
the
bit for SEV and SEV-ES guests.  That results in this:

  .is_private =3D vcpu->kvm->arch.has_private_mem && (err & PFERR_GUEST_ENC=
_MASK),

marking the fault as private.  Which, in a vacuum, isn't technically wrong,=
 since
from hardware's perspective the vCPU access was "private".  But from KVM's
perspective, SEV and SEV-ES guests don't have private memory, they have mem=
ory
that can be *encrypted*, and marking the access as "private" results in vio=
lations
of KVM's rules for private memory.  Specifically, it results in KVM trigger=
ing
emulated MMIO for faults that are marked private, which we want to disallow=
 for
SNP and TDX.

And because the flag only gets set on SNP capable hardware (in my limited t=
esting
of a whole two systems), running the same VM on different hardware would re=
sult
in faults being marked private on one system, but not the other.  Which mea=
ns that
KVM can't rely on the flag being set for SEV or SEV-ES guests, i.e. we can'=
t
retroactively enforce anything (not to mention that that might break existi=
ng VMs).

