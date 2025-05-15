Return-Path: <kvm+bounces-46610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16BEEAB7A75
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 02:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 456E517A8DE
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 00:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D4310E4;
	Thu, 15 May 2025 00:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yz+3mu+h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B3B12B93
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 00:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747268349; cv=none; b=awrJpEgVtYXKbWkAEGcYJUctWgMJ/LwwejIePhNBtzyqd+OjpXv9BFqTjG4c+4H+4XLDIhkc7ZY47p0ibrBrYPS40Ar/vcoizYko7/ViSZxQLYcx5AM8j7aRHrYWu3yjsYPDApelqzKJ6lxaq5wkktmJkntlm3nZ1y/pLyYCFKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747268349; c=relaxed/simple;
	bh=CwFN4BYKQFRQh/Xr76a4fW5WHqO7eX/lUR6egztCPsw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GMF245VQRK3FoKM9MdtwAPWDuXOyL4Sedd5xiguftiMRFTliREiy6RbPloNnBP7RKgleo+og5CY1lj8kznsQ0F+Ec0rkfnVci8ePqpG2xtUii4rlDlli+Jdu1XhB3dAXjjJBXAQCK2up8ks/ha0wajbeCyxe/nxbNvz+qrnKCV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yz+3mu+h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747268346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xAdpM5Q7/vE/oYJJ+JI4td5zwc5mWcdORMBLORRPIA8=;
	b=Yz+3mu+hmoQWLusMBoHTWjntBS8V4qkjomS+v92aKhGsh5PrcwkHgpHsoquaUbtiPElz/Q
	KbeWF1nxHXbPvXkd6A/ybFWOhORY7m/8VuFM+/I2KK1/9s80T9lP/nKrF0+ubmGCPDTHQO
	qR+r7O2Vgslvxk1ifBoUAIRnVGqJuao=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-1WG5fLm9Nr2GDhbbkUXzag-1; Wed, 14 May 2025 20:19:05 -0400
X-MC-Unique: 1WG5fLm9Nr2GDhbbkUXzag-1
X-Mimecast-MFC-AGG-ID: 1WG5fLm9Nr2GDhbbkUXzag_1747268345
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4768a1420b6so6490261cf.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 17:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747268345; x=1747873145;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xAdpM5Q7/vE/oYJJ+JI4td5zwc5mWcdORMBLORRPIA8=;
        b=DQ7Hwo82B2EViyI3eYeJSS44qbyiBAqrc9hpqalG/6zF6kz7z17823ELo8sEp+iVLf
         OMw/GZVeBOXI56WowXoUWVc0c27Mlncmr3rayUzi37HTpzseNNfQJiSsARQQcxkFC9N4
         FUN5AMtTMKmVP3DtXDuePnLVIRKbIXR9d3QsJZR5hoOqN098pxaYX0vJrFvRhfyOgSB8
         OqDPHg3q6XZ5koh+t9iUR7jWbJQvsGsw+rV9/gdmAeR+8+mHXxFITzT5kO2kyDfG+jHT
         7MhrAu9wnJdiCKmOtZc4EFT3IKrDt0GJOXlftsjiMZ5/4il0/ZTWgan09Ktb5Zamp8YX
         5qLg==
X-Gm-Message-State: AOJu0Yx91CTe96omY3hXQsCgR2KCTQ6DQVEf5D7/FmqOQZYumXzCgLbi
	ZIHY0DKmOSHxKilWyGoyoSd/xvgYQo2pnm1s6TDd6SEZIMH+ftDV4BfouazKorx+tn9y8JEjyuJ
	ZZGDYbNxp/BUZojODzxpkaiQekNWroBeRINixKFIE7BW961fBhg==
X-Gm-Gg: ASbGncv4nAB2jKPXkH7LOS7rEaG21US5hIB3vSo7ECOr8O04gAtEk//OkpTlyUhOBeC
	P5UZZT3v7hEKLsGFp/GGEs9aQa17r+5x1gdzCwlnJhQh+7d25AEimobefsoH3VIBfvyWMz+MSX6
	8JxAipeT3AR353hHGCvGbRpzThdahfybqnkL/ad32jh8AM61c+5g55huobRUm3F6B4QhavUs/S5
	tkrN+aYGVglpdz+1Q6jn6pSYCHPT+BHS86Jra5qT3w8qM5GTvSurFHvz+SPv5wTyxD697lchyUk
	0UV4bD4camSYNICjrvpEyxUWqmDlfyhgQMcyY7TDQIc25UzU45HovQQQyJ0=
X-Received: by 2002:a05:622a:550f:b0:494:a4bc:3b4d with SMTP id d75a77b69052e-494a4bc3e86mr7310471cf.18.1747268345011;
        Wed, 14 May 2025 17:19:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHm4JjYY+Nx9t9nYvk2Gm1RhK8ioZCZ7rNUtqRSWrSEgm9/4nzUsOnioaJrjwzl/vmuEc8f4g==
X-Received: by 2002:a05:622a:550f:b0:494:a4bc:3b4d with SMTP id d75a77b69052e-494a4bc3e86mr7309901cf.18.1747268344579;
        Wed, 14 May 2025 17:19:04 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945259fa0dsm85842911cf.80.2025.05.14.17.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 17:19:04 -0700 (PDT)
Message-ID: <8e4e3a564b652a1dd402873fbf3d320c8fdc41f8.camel@redhat.com>
Subject: Re: [PATCH 3/3] x86: KVM: VMX: preserve host's
 DEBUGCTLMSR_FREEZE_IN_SMM while in the guest mode
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav
 Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 14 May 2025 20:19:03 -0400
In-Reply-To: <aByzGilzBiTa-43C@google.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
	 <20250416002546.3300893-4-mlevitsk@redhat.com>
	 <aAgpD_5BI6ZcCN29@google.com>
	 <2b1ec570a37992cdfa2edad325e53e0592d696c8.camel@redhat.com>
	 <71af8435d2085b3f969cb3e73cff5bfacd243819.camel@redhat.com>
	 <aBvmxjxUrXEBa3sc@google.com> <aByzGilzBiTa-43C@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-05-08 at 06:35 -0700, Sean Christopherson wrote:
> On Wed, May 07, 2025, Sean Christopherson wrote:
> > On Thu, May 01, 2025, mlevitsk@redhat.com=C2=A0wrote:
> > > Any ideas on how to solve this then? Since currently its the common c=
ode that
> > > reads the current value of the MSR_IA32_DEBUGCTLMSR and it doesn't le=
ave any
> > > indication about if it changed I can do either
> > >=20
> > > 1. store old value as well, something like 'vcpu->arch.host_debugctl_=
old' Ugly IMHO.
> > >=20
> > > 2. add DEBUG_CTL to the set of the 'dirty' registers, e.g add new bit=
 for kvm_register_mark_dirty
> > > It looks a bit overkill to me
> > >=20
> > > 3. Add new x86 callback for something like .sync_debugctl(). I vote f=
or this option.
> > >=20
> > > What do you think/prefer?
> >=20
> > I was going to say #3 as well, but I think I have a better idea.
> >=20
> > DR6 has a similar problem; the guest's value needs to be loaded into ha=
rdware,
> > but only somewhat rarely, and more importantly, never on a fastpath ree=
ntry.
> >=20
> > Forced immediate exits also have a similar need: some control logic in =
common x86
> > needs instruct kvm_x86_ops.vcpu_run() to do something.
> >=20
> > Unless I've misread the DEBUGCTLMSR situation, in all cases, common x86=
 only needs
> > to a single flag to tell vendor code to do something.=C2=A0 The payload=
 for that action
> > is already available.
> >=20
> > So rather than add a bunch of kvm_x86_ops hooks that are only called im=
mediately
> > before kvm_x86_ops.vcpu_run(), expand @req_immediate_exit into a bitmap=
 of flags
> > to communicate what works needs to be done, without having to resort to=
 a field
> > in kvm_vcpu_arch that isn't actually persistent.
> >=20
> > The attached patches are relatively lightly tested, but the DR6 tests f=
rom the
> > recent bug[*] pass, so hopefully they're correct?
> >=20
> > The downside with this approach is that it would be difficult to backpo=
rt to LTS
> > kernels, but given how long this has been a problem, I'm not super conc=
erned about
> > optimizing for backports.
> >=20
> > If they look ok, feel free to include them in the next version.=C2=A0 O=
r I can post
> > them separately if you want.
>=20
> And of course I forgot to attach the patches...

There is one problem with this approach though: the common x86 code will st=
ill have to decide if
to set KVM_RUN_LOAD_DEBUGCTL flag.

Checking that DEBUGCTLMSR_FREEZE_IN_SMM bit of 'vcpu->arch.host_debugctl' c=
hanged is VMX specific,
because AMD doesn't have this bit, and it might even in the future have a d=
ifferent bit at that
position for different purpose.

I can set the KVM_RUN_LOAD_DEBUGCTL when any bit in DEBUGCTL changes instea=
d, which should still be rare
and then SVM code can ignore the KVM_RUN_LOAD_DEBUGCTL, while VMX code will=
 reload the VMCS field.

Is this OK?

Best regards,
	Maxim Levitsky


