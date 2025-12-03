Return-Path: <kvm+bounces-65203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DED56C9F133
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 14:10:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C88F94E0F56
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 13:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6ACB2F3C1D;
	Wed,  3 Dec 2025 13:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fbdNMCKW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BF9aK5EO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0879D2DA76B
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 13:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764767444; cv=none; b=u2faKPMdJPimCUZhjF21e/WVsvgEdbuebMjlwGxIdHr1CxBCun3AW/6rOID65tCbqGufoD42BIskEnV0woO1K/YJJ+fEjjBrXPF4bbN8hqTdYrFk1x8N1cld1bJpC7sXxwMsJHABhYYWYgf6waLYdfKjaSSgXbnWdzpGXxNSoWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764767444; c=relaxed/simple;
	bh=VL1b6qM5tnDMA9tezK5Rtk2DqKNTgi5puNqAkwa8uCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tUwH4RvZywmaoB6PHihdNCyl5ds5+ag2iX8pDw/p2sAZn58dhrw7LnTnbre0rZPm8+VvW6Je7vS1ttwGylIcSES8OKEmXQC7H3A5NTZa0IOfzLfWcpVO3mFLu81LYF1npLwwszm1051NjEgyaOhJ6Ia1/cvE5D/te9djMl59WeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fbdNMCKW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BF9aK5EO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764767442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VaK8gNVnnLXvI7IlxmSXzCdCZI80rI+Rz8uERiiIxZE=;
	b=fbdNMCKW19m4wlJBqYgzC/iBkUPc85spDSf5p4YiSqmDVQ8LSruikFqDd6Hsuz1cI9Ryih
	7To6dKWSRkj7QCIlgty+0kxn+U4/jexDNpDmc/d9s5QA634I6ETJItGaZHahnKaW+YZ7P8
	Q+H656remKL5fyjjPKVW9pcWkYWaQdE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-Mr-iEcBqPWSr6YSd1LSBUQ-1; Wed, 03 Dec 2025 08:10:41 -0500
X-MC-Unique: Mr-iEcBqPWSr6YSd1LSBUQ-1
X-Mimecast-MFC-AGG-ID: Mr-iEcBqPWSr6YSd1LSBUQ_1764767440
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4776079ada3so58846825e9.1
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 05:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764767440; x=1765372240; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VaK8gNVnnLXvI7IlxmSXzCdCZI80rI+Rz8uERiiIxZE=;
        b=BF9aK5EOEiePQlU8IsB9MR9iQNZfHX0P0g3tTKrdTTaVIDebE5gimJzI72REjleQwH
         PN5JZPaPeDRiX6qUaKWWU/QiYkVVKuVJl0ZlbRT+zuMgGwQ6YQkaej7LAPnvq2is/Scy
         aH1qH54cGdu4CIrplj7epeJ/kLOIdD8VAkwm/gz52bq7QsmHdyBa468jjKibyEGYuoLc
         eLc5hCas7m50bmLZYAFyiOwFblajAvvZHpexx7iFnvTf9w9iBzNaxdtJgTMZfvZ30Z4M
         uDbeghiAgR1nTV5hB3T+istJjMH8HWffa+ATeu8ZYyEOWc1Dg0gcFwYFNyld5AgKkuQI
         yJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764767440; x=1765372240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VaK8gNVnnLXvI7IlxmSXzCdCZI80rI+Rz8uERiiIxZE=;
        b=Dcb+x2GoduYJLX9WqajlHgFxzBapTAo232Mh2H+HsyqZCNTwbhcW/q683gJyyIxVoO
         S+3cHUY5MTuhBsfWoDSCnIFTec8uvfCIOAcLYYCEQ+vQr38HGbYmnySWF9Nfgl59VrvB
         rr2SC1l5fc57mmf2i9LhXVnwUS1DtMssjAm6gIwM9mviOeHdNlD2LcCba6ti/rcpSdgv
         fGs9E0s7/o2XVdYBWreGGcv4+F6lraRpvLvT1WJSz4jIyO5m56MU3HdRYk5vaSV/+Z2z
         EfWG5ygl+Ir//28W0fnMeFZ/3PDugUU4lxNbupmdEKzINCvrp9DVI4oZgBOLwtkQ8Zll
         9Pzw==
X-Forwarded-Encrypted: i=1; AJvYcCWKIO0KPEYfFRfVqCY35rAa2Qx7FkoaPQb4wX0EUhLH7v8XNe8jjOWb4RO1MMIPMESPoQU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSkf88vV02H9dcX/Ju1TTfStZyFZ1T6932GB5hqBm2PJU/VgPI
	tUIWJvuc7Qy0fzjVJv+ypZM3Xgdj1C/m+C7vIafxouG00rgSknFS8O5qWHLIA3E+exDPE1ekwfD
	tpRtRcLRjtwFLKmbr64C4RUz8qdnWElDp61Hxd+4Qvs80NMtCApNbq5yfJsdRafMr5ipuVF/rlU
	gLnDDL/kqEOfTdAejNPWCYUB/pfEEF
X-Gm-Gg: ASbGnct3tYjzloe0tAiwzuI5c5clCpuPh6yO4yOwUAEncM7MnXpuI1XHJHZ09L6mvl8
	CJXho2qCrDgFSV/BQkehewDE+jFDa4OyoUeTAk51Yh3pJ/irRP5P34DRrlJnPclC/ilDyeBfBEj
	Y99tUJ7yY4bAxe+H+a6QnoPQyfsSj8wcno9nKcjzWJOPJXhv7YRPUG4fsjz27JkGbY9BEbGiYZn
	X2pLJQbOUIHUhN+vfbCwUB5LEYWnSxqy/0vLFf2G/H8ZKTNmHyyxbRwEvpTuVaQ8zjRbno=
X-Received: by 2002:a05:6000:2689:b0:42b:32f5:ad18 with SMTP id ffacd0b85a97d-42f73180f9dmr2597701f8f.9.1764767439736;
        Wed, 03 Dec 2025 05:10:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgj3s8W8vwuMl7G5t3fm3GBqzlmfmjEzVSIi7i5l/GlACVq9dghbhMIm5ZQkzBpYHH8aphJQPlHspidUR5DmQ=
X-Received: by 2002:a05:6000:2689:b0:42b:32f5:ad18 with SMTP id
 ffacd0b85a97d-42f73180f9dmr2597663f8f.9.1764767439296; Wed, 03 Dec 2025
 05:10:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251125180557.2022311-1-khushit.shah@nutanix.com>
 <6353f43f3493b436064068e6a7f55543a2cd7ae1.camel@infradead.org>
 <A922DCC2-4CB4-4DE8-82FA-95B502B3FCD4@nutanix.com> <118998075677b696104dcbbcda8d51ab7f1ffdfd.camel@infradead.org>
 <aS8I6T3WtM1pvPNl@google.com> <68ad817529c6661085ff0524472933ba9f69fd47.camel@infradead.org>
 <aS8Vhb66UViQmY_Q@google.com> <352e189ec40fae044206b48ca6e68d77df7dced1.camel@intel.com>
 <d3b8fd036f05e9819f654c18853ff79a255c919d.camel@infradead.org>
In-Reply-To: <d3b8fd036f05e9819f654c18853ff79a255c919d.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 3 Dec 2025 14:10:26 +0100
X-Gm-Features: AWmQ_bkXG6zGUGLk1doAMHJxgzoMJ2DUg4jVyEHzZHJl2BaaKFz0PWxqK9MC6fM
Message-ID: <CABgObfa3wNsQBjAwWuBhWQbw4FuO7TGePuNzfqAYS1CzRFP6DQ@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>, 
	"khushit.shah@nutanix.com" <khushit.shah@nutanix.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Kohler, Jon" <jon@nutanix.com>, "tglx@linutronix.de" <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 1:26=E2=80=AFPM David Woodhouse <dwmw2@infradead.org=
> wrote:
>
> On Wed, 2025-12-03 at 00:50 +0000, Huang, Kai wrote:
> >
> > > -#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
> > > -#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
> > > +#define KVM_X2APIC_API_USE_32BIT_IDS                       (_BITULL(=
0))
> > > +#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK             (_BITULL(=
1))
> > > +#define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST   (_BITULL(2))
> > > +#define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST  (_BITULL(3))
> >
> > I hate to say, but wants to ask again:
> >
> > Since it's uAPI, are we expecting the two flags to have impact on in-ke=
rnel
> > ioapic?
> >
> > I think there should no harm to make the two also apply to in-kernel io=
apic.
> >
> > E.g., for now we can reject KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST fl=
ag for
> > in-kernel ioapic.  In the future, we might add EOI register support to =
in-kernel
> > ioapic and report supporting suppress EOI broadcast, then we can in-ker=
nel
> > ioapic to honor these two flags too.
>
> I don't think we should leave that to the unspecified 'future'. Let's
> fix the kernel I/O APIC to support the directed EOI at the same time,
> rather than having an interim version of KVM which supports the
> broadcast suppression but *not* the explicit EOI that replaces it.
>
> Since I happened to have the I/O APIC PDFs in my recent history for
> other reasons, and implemented these extra registers for version 0x20
> in another userspace VMM within living memory, I figured I could try to
> help with the actual implementation (untested, below).
>
> There is some bikeshedding to be done on precisely *how* ->version_id
> should be set. Maybe we shouldn't have the ->version_id field, and
> should just check kvm->arch.suppress_eoi_broadcast to see which version
> to report?

That would make it impossible to use the fixed implementation on the
local APIC side, without changing the way the IOAPIC appears to the
guest.

There are no parameters that you can use in KVM_CREATE_IRQCHIP,
unfortunately, and no checks that (for example) kvm_irqchip.pad or
kvm_ioapic_state.pad are zero.

The best possibility that I can think of, is to model it like KVM_CAP_XSAVE=
2

1) Add a capability KVM_CAP_IRQCHIP2 (x86 only)

2) If reported, kvm_irqchip.pad becomes "flags" (a set of flag bits)
and kvm_ioapic_state.pad becomes version_id when returned from
KVM_GET_IRQCHIP. Using an anonymous union allows adding the synonyms.

3) On top of this, KVM_SET_IRQCHIP2 is added which checks that
kvm_irqchip.flags is zero and that kvm_ioapic_state.version_id is
either 0x11 or 0x20.

4) Leave the default to 0x11 for backwards compatibility.

The alternative is to add KVM_ENABLE_CAP(KVM_CAP_IRQCHIP2) but I
dislike adding another stateful API.

Paolo


