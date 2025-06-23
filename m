Return-Path: <kvm+bounces-50392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA97AE4B5D
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:48:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD69E177573
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99AC527C15B;
	Mon, 23 Jun 2025 16:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1LymG4/E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCB51DEFE6
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 16:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750697316; cv=none; b=TD8yaCAvQFFJEqE8+Tfwn6BU5YIvje6zqIoivhJcIh/WEOLYWyRFL8RVCbrRg1EuLH3PXSKNSUhfPVLvfmuwUUGBovdxq8022ZkRV/5oIEFmiD3JKsiSSjOnjY5aSPRLBMzrPUcPOso7napw3fGS7Wvqq25Ejti0zsAD60qMEew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750697316; c=relaxed/simple;
	bh=Vh0K3JgybiXqh8bhuli73IwsyvXMrO6Lef7CPmI5wDI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bpVpYZR2g9YtC22aT0+cgdEXUl2y+CmSX8AmU50lrcdNoCMoojWzPFVybe66zLxsBP0gF0lD2jnn1wiXcECn4ABlp/VU55qlrqxObujStLhxHZEtRKavWlgM4RQWkArEq5sv8daGXnCZfbVTIZdT8MDldxPaCta2SbUTrkqKvB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1LymG4/E; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138e64b3f1so5458198a91.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 09:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750697315; x=1751302115; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MNsTl7o1kMR/XQbvyza/I69IGDpibUQIxWthc0R5kZI=;
        b=1LymG4/EM4gyDyP4t5tl2ZTcBZ4qP2jl/64qed6xXju3sXvf5ZvrUdWldzIhj4lDaQ
         LdFpsGKo6EkuPfytUV5+MtPPIP0O2TKVm+qNo5aHE9AKaTeunhtkxF7IFO8hu9N26a6h
         Xpx/7nWvqK3g5UkoCw7KMQ07P1lGxhJqCdBaq5F1HpQJZk5x4skjkxqRMs3GN11OZzXG
         U02L2UdZr5TUqsMTgJLhlnrTLmgCPgtzYyj3V0yx4UEzsktN3Ztp+3B6kAvFghKePTKe
         C4cwOaTwlOwAYCwgH3ttvRnANIlAO082Pvwb84BxuEdxcUVxW79JlMneCIFWWv+nriHD
         WwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750697315; x=1751302115;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MNsTl7o1kMR/XQbvyza/I69IGDpibUQIxWthc0R5kZI=;
        b=Ypr0Er+qzuZM1pt0ihOne0ZFwWhvOf0el4BQm4+5W4zBUxZm96+DsV/PSz+8u7yVMO
         2/Mh1heZMHheReNuqyhfUHA7SliNkbOulv2LGfutIbbJuFCqdt5uqVHE932hF65FWZoX
         yhhqRDRUGoiEXPj91EoL3JbXQmJ89mBaFSm2GYe/w0HSYaVufed4XDZ+gVP6X/hx6gFt
         aVJeVeCz6DHm91nrrKtzPmhhi4/eBgkjXiuTj2UgKgqL7Ac7WWTqyZnZs3YD2pfMSbf6
         6Y72oOVrbOFS16+iv3BpbFSXkLibjY6/S492zj3D/F4W4hfjIJkcgj3xaHnDc4CWkC3T
         zNkA==
X-Forwarded-Encrypted: i=1; AJvYcCUPoR6Ww6QiCuzgvogtTbHE8M20l+hT7vNfI+iR15LuxnQkN86rMLY7pP/fiWnj4+uJ4u0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPWa6xYuJz5+btgzLW40dQ/XHUWtN6RKXkx9J+L7xFDaCX1tZk
	bIdxDwbHPpMwyAH/ymtcpuzJnxSFtlrrk6bXRpvlbpx2MNLqc4/n7TdNBDLUfLoxPCKg9n2vGOl
	PwOBM+Q==
X-Google-Smtp-Source: AGHT+IFb0LToMc4+oHvP1f0u0d+eBVoHOPu4uIjs79zNzocSTjaX1tNGgg2qHX7XgkL7ws8zyZ0c2z8q4fo=
X-Received: from pji8.prod.google.com ([2002:a17:90b:3fc8:b0:313:246f:8d54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3cd0:b0:311:b6d2:4c36
 with SMTP id 98e67ed59e1d1-3159d8d6847mr16718135a91.26.1750697314798; Mon, 23
 Jun 2025 09:48:34 -0700 (PDT)
Date: Mon, 23 Jun 2025 09:48:33 -0700
In-Reply-To: <7cc618b80681e8e1402c73886505f6247c810db8.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <e489252745ac4b53f1f7f50570b03fb416aa2065.camel@infradead.org>
 <7fedbeac-300f-48a3-9860-e05b6d286cd1@xen.org> <7cc618b80681e8e1402c73886505f6247c810db8.camel@infradead.org>
Message-ID: <aFmFYZlrxlLE2ZzY@google.com>
Subject: Re: KVM: x86/xen: Allow 'out of range' event channel ports in IRQ
 routing table.
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: paul@xen.org, kvm@vger.kernel.org, Ivan Orlov <iorlov@amazon.co.uk>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2025, David Woodhouse wrote:
> On Mon, 2025-05-12 at 10:29 +0100, Paul Durrant wrote:
> > On 08/05/2025 21:30, David Woodhouse wrote:
> > > From: David Woodhouse <dwmw@amazon.co.uk>
> > >=20
> > > To avoid imposing an ordering constraint on userspace, allow 'invalid=
'
> > > event channel targets to be configured in the IRQ routing table.
> > >=20
> > > This is the same as accepting interrupts targeted at vCPUs which don'=
t
> > > exist yet, which is already the case for both Xen event channels *and=
*
> > > for MSIs (which don't do any filtering of permitted APIC ID targets a=
t
> > > all).
> > >=20
> > > If userspace actually *triggers* an IRQ with an invalid target, that
> > > will fail cleanly, as kvm_xen_set_evtchn_fast() also does the same ra=
nge
> > > check.
> > >=20
> > > If KVM enforced that the IRQ target must be valid at the time it is
> > > *configured*, that would force userspace to create all vCPUs and do
> > > various other parts of setup (in this case, setting the Xen long_mode=
)
> > > before restoring the IRQ table.
> > >=20
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > > ---
> > > =C2=A0 arch/x86/kvm/xen.c | 14 ++++++++++++--
> > > =C2=A0 1 file changed, 12 insertions(+), 2 deletions(-)
> > >=20
> >=20
> > Reviewed-by: Paul Durrant <paul@xen.org>
>=20
> Ping?

Almost there :-)  I've got it applied (for 6.16), just need to run my gener=
ic
test stuff before making it "official".

