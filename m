Return-Path: <kvm+bounces-55022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03052B2CB6A
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:50:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 287917A42E9
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB59830DD0E;
	Tue, 19 Aug 2025 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oDkytkmD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8664244EA1
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 17:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755625838; cv=none; b=ol2DCmc2JCIm2LvyKhCRPSKQOuSNfUi1gLSRMb/13yvG3OsGyu5eN/AbSioTuIm5iLMUBna8cWRjz/vyVDD/Qs9tbZHPAoUdQeWTasWHrHtyjJO1bRR55BH21YWmlF2SP55ufeGQtlvjV4d9sMwJT3qHNiNWWO4kpY4V3uEKFjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755625838; c=relaxed/simple;
	bh=6kzBVQ4vXJ41E2BlAb/8JsyibyENW87RCVv7GZNAxNo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WsvYG77U6imDy+QninpEZ3aD3Tb6pqvWPeX9CB/cVmoDXnB0ml/MWzQciu0zUxN2NyNFm9lxqc9bKwdZRU3+4zuf9s1asfmrFaBphthG9Smtnrs/qd68lLA785ZKesBAvQ//8gTlf2S6eQabl0996d1mCLCiOvCy/FftpO9vdBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oDkytkmD; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b47174b2582so10283351a12.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 10:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755625835; x=1756230635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wD94oAmVvbxMhzCidjRkeh+Tz5s81LRUlXLzhaycj4k=;
        b=oDkytkmDbw2b4qUnuqnHtfjisE/qJJvQ3gLhqsVhcIgaRRGgM66DeAHV0D89z2bpp/
         1/JNDP9qbVLfIxtPbOtrIhCRV5zNuGpCqUw2A8jNMyOaqIQ07IOOfx/5TpsNspY93UF9
         QlbQ1Wh438BI2HJZkFsDqyAz3hHguhJ+OLctYZ+DK8ram88dH17pba40mRWO+qvDzmuG
         EZxEU3DCNllG4dzUsa43ZnbZt7+DtsA1bhuhP69JKxZgp350kDL/gvW6xhDUitEYHHYy
         uqj/9nXQO0QihQEd3Rm+NcFpvmkhZUNEzeSZcybikHyTqft/+GRayfjtyRgO/IQnLfCx
         TJ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755625835; x=1756230635;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wD94oAmVvbxMhzCidjRkeh+Tz5s81LRUlXLzhaycj4k=;
        b=G8rcS4QuYCDs5uCk/8BlnPUKDyBgCWdJcHofo3DM7BBjOBd72SQHlQEFyLxvo43npe
         kBafwxfZyHKqZ+ZMX1q67jkpwYmvwQeyqETLSiDPoAuwfoTis2713b7SUBSZKIfP3Zbi
         pApHtU9xq547IlVB/cLaV4lFgPq2dyeSsYDg9bKRCM2rpwrxEiT21BmNqvX74KVvLBMe
         4kMNzX1gZejPC4JFVAPz4wVbX6Pu0ftZCAorp3TAd5Qc7whrYe20FGjur5aeh6n7TF7B
         GQIMpAOjab36vQ924Bi8Oi0MYYcZ36rA+SGw2/eg2h1RK2plJRdYSwPi/wbB64VyLYSV
         40Eg==
X-Forwarded-Encrypted: i=1; AJvYcCXyi0cqlK+pfg4bm0oMi9U+nXthLsxGnXbbMYxSLhgmKJxdEYg6SznQr0YcaImaMkcBbL4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPQG2gWFghQEVJjlT39gSUt5VNIzmzYe/mXi6PitPiYMRkp0WP
	+f5OpcfjQxudF+LvoQzBHfrGlzkFmfk4EVLS/ZmUXAYkT5l5y3Q+2gYQ4XOVi4lDxGuNOSkLlb3
	YNj71Aw==
X-Google-Smtp-Source: AGHT+IEkbW0dw54TwTbKnMcxm9LW7g6jyFzY4cJM9GTd67rVA/NTRpaCDoJ8j5GeClUybRMQqkMxlZXyMOs=
X-Received: from pggh17.prod.google.com ([2002:a63:c011:0:b0:b42:2b46:da9d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:99a4:b0:232:4d23:439c
 with SMTP id adf61e73a8af0-2431b7fb1a3mr330582637.26.1755625835023; Tue, 19
 Aug 2025 10:50:35 -0700 (PDT)
Date: Tue, 19 Aug 2025 10:50:33 -0700
In-Reply-To: <a06cef50bff3ac618ec4feaa501d416f9841c7a1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250812025606.74625-1-chao.gao@intel.com> <20250812025606.74625-16-chao.gao@intel.com>
 <aKShs0btGwLtYlVc@google.com> <a06cef50bff3ac618ec4feaa501d416f9841c7a1.camel@intel.com>
Message-ID: <aKS5aUeP-X6eED-R@google.com>
Subject: Re: [PATCH v12 15/24] KVM: VMX: Emulate read and write to CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Weijiang Yang <weijiang.yang@intel.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"john.allen@amd.com" <john.allen@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"minipli@grsecurity.net" <minipli@grsecurity.net>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"xin@zytor.com" <xin@zytor.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-08-19 at 09:09 -0700, Sean Christopherson wrote:
> > This emulation is wrong (in no small part because the architecture suck=
s).=C2=A0 From
> > the SDM:
> >=20
> > =C2=A0 If the processor does not support Intel 64 architecture, these f=
ields have only
> > =C2=A0 32 bits; bits 63:32 of the MSRs are reserved.
> >=20
> > =C2=A0 On processors that support Intel 64 architecture this value cann=
ot represent a
> > =C2=A0 non-canonical address.
> >=20
> > =C2=A0 In protected mode, only 31:0 are loaded.
> >=20
> > That means KVM needs to drop bits 63:32 if the vCPU doesn't have LM or =
if the vCPU
> > isn't in 64-bit mode.=C2=A0 The last one is especially frustrating, bec=
ause software
> > can still get a 64-bit value into the MSRs while running in protected, =
e.g. by
> > switching to 64-bit mode, doing WRMSRs, then switching back to 32-bit m=
ode.
> >=20
> > But, there's probably no point in actually trying to correctly emulate/=
virtualize
> > the Protected Mode behavior, because the MSRs can be written via XRSTOR=
, and to
> > close that hole KVM would need to trap-and-emulate XRSTOR.=C2=A0 No tha=
nks.
> >=20
> > Unless someone has a better idea, I'm inclined to take an erratum for t=
his, i.e.
> > just sweep it under the rug.
>=20
> Sounds ok to me. All I could think would be something like use the CR/EFE=
R
> interceptions and just exit to userspace if (CR0.PE && !EFER.LM && CR4.CE=
T). But
> this would require some rototilling and then likely remain un-exercised.

And a far worse experience if a guest did ever trip that combo.  Letting th=
e guest
set bits 63:32 would only cause problems if the guest is being deliberately=
 weird,
whereas exiting to userspace would terminate even well-behaved guests (thou=
gh as
you note, the odds of a 32-bit guest using CET is quite small...).

> Not sure it's worth it.

