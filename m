Return-Path: <kvm+bounces-56828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E723CB43D27
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 15:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45C717BC0CB
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 13:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85A43054D6;
	Thu,  4 Sep 2025 13:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fj8myLcv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF5A30499C
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 13:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756992364; cv=none; b=tSqYMTxlOCYW0LnYx300ErJKYCHkxBeDnxaYFXZeOGYN3BXSxUopadPwWGbUdvfhjo+nQKoDZgkTTg0RmhGh/kAL+U5MbIpOw9tSZ09CBWZV/gEYcO5y2kMrtDGTRHd+pjU42s73F84caT7M5+/2YjQgGPPbFyGNvjm24VmngD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756992364; c=relaxed/simple;
	bh=K1N3OVD/4jIwE/loNZvU5ggVqQw/2Ae0TTFxNtyKH4g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W+a/URyCYQuNAywumC8g7lhRLFIiIvWBN6RqPN2tEiQxe3UYiwSF4arvcZkyLLP+5UcE2ULg7V31sX7oByzNOEsXOCNJdSA/QMVh84GEBfkTrvoH8UeSDDdjsln2lcmR75GF+pmdSZ/oHywiZ8zEValJH2KDqCZ1OPfthf1lLjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fj8myLcv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-324e41e946eso1725992a91.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 06:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756992363; x=1757597163; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qCN6Pj+XCmAisjcedbovVIrUMZAHherYJ0sw+9bB0a8=;
        b=fj8myLcvBDDeB3gwZrdY/pOxL9soNpTplK17Ljt5p550uMj/lEmx9RUL3ysSE9Aq8J
         NFZ6JCJQ7g+9TE/mkreA8P4JDZeNog3KTiR4Bf/s/WLVMVr1Mvplut5bI09LqkUugoDl
         8oFAeW51BAzmkGnrXr/yFhsfi3A5EeDrQWpGGw7MFYGBGh4z3w+BzcvWpGD33/XYGO/H
         zwxmUVV3YQy7O68A3WHWY1ynoMgBIZm1EEpRbz0noimOKX5HU0H6KG5biukUyKuFKOkj
         hTLavhFUvxcebwpe7be14qpPG4PDLbMApwFSANdwsOaZoDnrKZq99JsbpWbuNCBtRw11
         BwlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756992363; x=1757597163;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qCN6Pj+XCmAisjcedbovVIrUMZAHherYJ0sw+9bB0a8=;
        b=WyCX7i14hj5w01V4H2GFeMHr4qAMCW4f0504ShaZamKaQivETsUpOTceLN6SAnAQ1o
         61G233PLb8Ak+Pqr8UVOlMTclnYGwhcRRjitqgnBPVAebEYfcG/23tcKP8pxf2i8EPz2
         1kGAXnDfrq5TxCwJBOeFmGhpbQ++4ul4SsFJonFtu94Msws98CQse+sAdNZk5TmfC5st
         9SnD3pz4Q3X5RQKxPYYUU/i0Ebvo5tMw3qPxh2qlg6iZm7m8GBXExxKzj/sqvl4ZRLJz
         oN30Z4QKt8NCJ54T6WfJT5ttsL+CHa6NUYthD8R3oMAMijMpsRXR2jSSy+D/Um27QvGF
         nfZA==
X-Forwarded-Encrypted: i=1; AJvYcCX9JeJQMGj69APsztvYsVsLeym31IN4SWz2yrvD8ZpTrcn31Z6iPYv5etNagoHnvz1pYVU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy73lSv0lVUSLA5JrFBH/fW5E5i/UerCaVslrEvprYhY4GQQbm
	mg2el8FAa2u6C3or/clchyN4uHt+L0elN7jxIM+3et40vzBBWNRjGOWEXgr5U5xxUiV+RScSldx
	AgQSSSw==
X-Google-Smtp-Source: AGHT+IFz/vMO7oju85LfKzZ0R59IVu4BeGepAEN+RnQCU8o5CkJAM/GgwVJDXN02zuFjtWPwhmtEqhNRTYI=
X-Received: from pjbqn11.prod.google.com ([2002:a17:90b:3d4b:b0:321:c2a7:cbce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1845:b0:32b:9ede:bfd2
 with SMTP id 98e67ed59e1d1-32b9edec1b8mr1864950a91.22.1756992362639; Thu, 04
 Sep 2025 06:26:02 -0700 (PDT)
Date: Thu, 4 Sep 2025 06:25:49 -0700
In-Reply-To: <4a3be390fe559de0bd5c61d24853d88f96a6ab6a.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aLDo3F3KKW0MzlcH@google.com> <ea0d7f43d910cee9600b254e303f468722fa355b.camel@infradead.org>
 <54BCC060-1C9B-4BE4-8057-0161E816A9A3@amazon.co.uk> <caf7b1ea18eb25e817af5ea907b2f6ea31ecc3e1.camel@infradead.org>
 <aLIPPxLt0acZJxYF@google.com> <d74ff3c1c70f815a10b8743647008bd4081e7625.camel@infradead.org>
 <aLcuHHfxOlaF5htL@google.com> <3268e953e14004d1786bf07c76ae52d98d0f8259.camel@infradead.org>
 <aLl_MAk9AT5hRuoS@google.com> <4a3be390fe559de0bd5c61d24853d88f96a6ab6a.camel@infradead.org>
Message-ID: <aLmTXb6PO02idqeM@google.com>
Subject: Re: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest
 and host
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Durrant <pdurrant@amazon.co.uk>, Fred Griffoul <fgriffo@amazon.co.uk>, 
	Colin Percival <cperciva@tarsnap.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Graf (AWS), Alexander" <graf@amazon.de>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2025, David Woodhouse wrote:
> On Thu, 2025-09-04 at 04:59 -0700, Sean Christopherson wrote:
> >=20
> > I thought the original problem being solved was that the _guest_ doesn'=
t know the
> > effective TSC frequency?=C2=A0 Userspace can already get the effectivel=
y TSC frequency
> > via KVM_GET_TSC_KHZ, why do we need another uAPI to provide that?=C2=A0=
 (Honest question,
> > I feel like I'm missing something)
>=20
> I believe that KVM_GET_TSC_KHZ returns what userspace *asked* for the
> TSC frequency to be (vcpu->arch.virtual_tsc_khz), not what it actually
> ended up being based on the measured host frequency and the available
> scaling granularity (vcpu->hw_tsc_khz).

Ah, I see where you're coming from.  Purely out of curiosity, have you done=
 the
math to see if slop would be a problem in practice?  No worries if you have=
n't,
just genuinely (and lazily) curious.

Anyways, I'm a-ok reporting that information in KVM_GET_SUPPORTED_CPUID (ag=
ain,
only with constant TSC and scaling).  Reporting the effective frequency wou=
ld be
useful for the host too, e.g. for sanity checks.  What I specifically want =
to
avoid is modifying guest CPUID at runtime.

Hmm, the only wrinkle is that, if there is slop, KVM could report different
information when run on different platforms, e.g. after live migration.  Bu=
t so
long as that possibility is documented, I don't think it's truly problemati=
c.
And it's another argument for not modifying guest CPUID directly; I'd rathe=
r let
userspace figure out whether or not they care about the divergence than sil=
ently
change things from the guest's perspective.

Alternatively (or in addition to), part of me wants to stealtily update
KVM_GET_TSC_KHZ to report back the effective frequency, but I can see that =
being
problematic, e.g. if a naive VMM reads KVM_GET_TSC_KHZ when saving vCPU sta=
te for
live migration and after enough migrations, the slop ends up drastically sk=
ewing
the guest's frequency.

