Return-Path: <kvm+bounces-56823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7634CB43AE7
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 14:00:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ABF657A01CF
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8F32FD7CC;
	Thu,  4 Sep 2025 12:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fR14sSbE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B022FB99C
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 11:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756987199; cv=none; b=XhOR8+qh/Lt8bJUI50+uAYqsDj5/fU6VCgtz29YBWB0b9aY795ev1pzarLXzfYgfmpRvKfwEalmCDmasjCsr/VBo03Ky1rFPjkoaZiH2Aeczf1ZOO2k3nqTH0EZwSeFBa5T2cHPS1dPLSJjD+R9W3zN5sCZ3z6YhAYbykF4XzaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756987199; c=relaxed/simple;
	bh=ZXNn7I+rDr8GQnTPEyxX8hDMbjRGz6pxIO5JVjmS4wM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eZqTGP/Q25iJfWy4dd/DBs1d9flyjRRNnvYANwfg5bzfGN+lpgh61vJGqQGHWydGxw5bvhedWTB1w65jLbSvutOnWBccXum2LYKT2S1+ViTInp2XjjVByTWAslgV5eiO9sJRFLSDNf8j5UUyMVAkz/TL0G0cYYHfyiWfomkPqj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fR14sSbE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3278bb34a68so835750a91.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 04:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756987198; x=1757591998; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dto7K6eXvGSvhdBpztAXq5eWQrSsso/7rLd9mr1E24A=;
        b=fR14sSbEaJim7HvVIfltSd3dXGIVPlqzLZlXm+98fIZfCb7atRyJ9jURKHdti7cM9N
         V278HnrDVoN5Rowtj1GDcEA8T6l7PfWc5azsVXHksCEG1rqdtI4hTfxZdsU6CKu5Wf04
         Ms0QB2xGwZC8WrJjuzxlYEBgVyKpyckcv9dWNn4a9Yw/GAdsLadKugmf2A8I0HYuPsaQ
         OzQq6CiSKVTfFXj5QPQd15w1ss0JHCFAQuRhHI6WMMdlo8N55L8ScLh8X7ZRjKqDRTlD
         d1givSFKeT4s67aQ8ZVuWZpc/J39V1gFxVIa/0iLAnWKUSmn5DvBvRbquGBSh69rP/ww
         990Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756987198; x=1757591998;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Dto7K6eXvGSvhdBpztAXq5eWQrSsso/7rLd9mr1E24A=;
        b=HrdDN9LUOv1PFXdAyC+o6MU7ZWss6YIK88033EcY5B+8JLZJICZxpE6YhhlhnllG2D
         Revi4Q64owpwqAGkOLP3K3rJnNvHIjyNLX2Ao5AuRDmQPnjGMU4wCRkvUYZbT5wNDxM/
         icLVGmsWyAbqTB7sAIe9cGj0jmk2FsLfuE71Ho9+50bsoTe1/H4fBqwmcgeQUEvABkoG
         UL9oiSzL5ZWXwV6D3Ra9mBB8gGwNXhAwKtCKROvf2uvCHKo5GXBDN6w2zoBZ5PQ5Bt1P
         paPBX4h+RZAQNdCweu7TM2WSzOlyYgs9pRwh10Edd9+Z7009U9BSPAc5B892WX3sPbhc
         c1/g==
X-Forwarded-Encrypted: i=1; AJvYcCUc4fxcyiVkdFZsdmXSVLaEc+Fip0OIcbFry8neQ7PkmLYfaVjDmou/f9P34HAcqc0OVO0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1Vds1VTvguOJNBGmC5PSanQROcTocLP/QGI8K1WvgSJGz3q/T
	muqbyUWeWVTvn4AlQcbnrnzfL1z6kz2sDWkm4T1Y3iVbJ6FuilOJJiydwWVvtDuPUnHU4l92iav
	2B7MCeg==
X-Google-Smtp-Source: AGHT+IHP6++Ieg1NxgcxEx/LfHzuEBAPAP8bF6XQFVaVCxfhu7J+bDNjZtW76Vo5/SjfbbqGGuwo3OTmXSY=
X-Received: from pjh5.prod.google.com ([2002:a17:90b:3f85:b0:325:7c49:9cce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d03:b0:328:a89:71b8
 with SMTP id 98e67ed59e1d1-328156e1238mr23720013a91.30.1756987197621; Thu, 04
 Sep 2025 04:59:57 -0700 (PDT)
Date: Thu, 4 Sep 2025 04:59:44 -0700
In-Reply-To: <3268e953e14004d1786bf07c76ae52d98d0f8259.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aK4LamiDBhKb-Nm_@google.com> <e6dd6de527d2eb92f4a2b4df0be593e2cf7a44d3.camel@infradead.org>
 <aLDo3F3KKW0MzlcH@google.com> <ea0d7f43d910cee9600b254e303f468722fa355b.camel@infradead.org>
 <54BCC060-1C9B-4BE4-8057-0161E816A9A3@amazon.co.uk> <caf7b1ea18eb25e817af5ea907b2f6ea31ecc3e1.camel@infradead.org>
 <aLIPPxLt0acZJxYF@google.com> <d74ff3c1c70f815a10b8743647008bd4081e7625.camel@infradead.org>
 <aLcuHHfxOlaF5htL@google.com> <3268e953e14004d1786bf07c76ae52d98d0f8259.camel@infradead.org>
Message-ID: <aLl_MAk9AT5hRuoS@google.com>
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

On Tue, Sep 02, 2025, David Woodhouse wrote:
> On Tue, 2025-09-02 at 10:49 -0700, Sean Christopherson wrote:
> >=20
> > > So even if a VMM has set the TSC frequency VM-wide with KVM_SET_TSC_K=
HZ
> > > instead of doing it the old per- vCPU way, how can it get the results=
 for a
> > > specific VM?
> >=20
> > I don't see any need for userspace to query per-VM support.=C2=A0 What =
I'm proposing
> > is that KVM advertise the feature if the bare metal TSC is constant and=
 the CPU
> > supports TSC scaling.=C2=A0 Beyond that, _KVM_ doesn't need to do anyth=
ing to ensure
> > the guest sees a constant frequency, it's userspace's responsibility to=
 provide
> > a sane configuration.
> >=20
> > And strictly speaking, CPUID is per-CPU, i.e. it's architecturally lega=
l to set
> > per-vCPU frequencies and then advertise a different frequency in CPUID =
for each
> > vCPU.=C2=A0 That's all but guaranteed to break guests as most/all kerne=
ls assume that
> > TSC operates at the same frequency on all CPUs, but as above, that's us=
erspace's
> > responsibility to not screw up.
>=20
> Sure, but doesn't that make this whole thing orthogonal to the original
> problem being solved? Because userspace still doesn't *know* the actual
> effective TSC frequency, whether it's scaled or not.

I thought the original problem being solved was that the _guest_ doesn't kn=
ow the
effective TSC frequency?  Userspace can already get the effectively TSC fre=
quency
via KVM_GET_TSC_KHZ, why do we need another uAPI to provide that?  (Honest =
question,
I feel like I'm missing something)

> Or are you suggesting that we add the leaf (with unscaled values) in
> KVM_GET_SUPPORTED_CPUID and *also* 'correct' the values if userspace
> does pass that leaf to its guests, as I had originally proposed?

The effective guest TSC frequency should be whatever is reported in KVM_GET=
_TSC_KHZ
when done on a vCPU, modulo temporarily skewed results without hardware sca=
ling.
If that doesn't hold true, we should fix that.

