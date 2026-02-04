Return-Path: <kvm+bounces-70114-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Y1vNAyGMgmnMWAMAu9opvQ
	(envelope-from <kvm+bounces-70114-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:00:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 85ACEDFE01
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BE4783030ED5
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 00:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A921D1C4A20;
	Wed,  4 Feb 2026 00:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="elHSeXsZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916A8A937
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 00:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770163227; cv=none; b=B6GsXVnP7m9lfB1PT2dA1lTwqLWIBlq1Bp6UH/S21ltXnrZ1G7D2PBXPLOL4cwHkHw8juIdv9OafkJ/u/4WxOIO2pqIRpSRojufCLQ/Jjc1HxhhNhCxflkzl4VJKx6/5JLiWKjhqrSSY0mMx3z32NczGv5kHGCHXMak0639iSJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770163227; c=relaxed/simple;
	bh=GIxDdFOXqZ0emnzPe4xyIEpY72QJVX4bBP5UXthDkxI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SCLKR0JsI+G+ZknTvzq1qubBfETbGvO6zRO+1/PSB05LBJLe1Bl+boWoBHa5qPE4eN3a+zlVmLdg/W/mnFJ8xLar9Vw7RHJtY0EraDTVbsvSSXbmDDM0qXdZRmlyleMN2V9aiPC0OoRk3E6H/YC0buBw0vC/sg9O01e30WwwMm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=elHSeXsZ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6136af8e06so3844509a12.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 16:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770163226; x=1770768026; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SVnZ/cwtK4ji87rGWMAM2IituVZDG+uyyOJMD4ekd58=;
        b=elHSeXsZozI6aFqSxGGKSRhgT0BZzM2EDdktGJPbSvD1qMpOH2nLBHlrNxpQmE3jpT
         aqTmyRvR2GD4mhVC7Y2aUQeacKiQFSJVjOwNhktcrb5+SfzbAlo5Yy97c1EVcqWTUoEM
         LH79bToXbAqDramDLN/X/Uz8Jg59PcrsT+pjIqL5TF7VqTdGeKEbzoI9m4xX1YHxzIrB
         GsU0hbXr6cF0KbumisAlEOdXktRkf465rbBv+oKA44y1/3CqCAnwrrzdGFI1SXiuFJue
         OblUnRNIdgnVtGV4VRp4lsysoQAlNsEEYJ6qZL1R4XVEOMJiGMDnSxUCmkT+SsN5mMky
         yuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770163226; x=1770768026;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SVnZ/cwtK4ji87rGWMAM2IituVZDG+uyyOJMD4ekd58=;
        b=CfK57irs+v8JN7OjAHY3cvTahgPIhQLLWakULR//50uBAGf1ueedvHrNmx0BUhDcFY
         vUsdWIujalzIbf3J6XnF26ulHlDfSS5xuBlcDRnl62UZJMF7lhnLmOYmA48HCAAGuaCK
         nJMGXWYYXgFUkyheOJwUErRRZbQDHr6D/fgDGOntPtULf1AsrdYT0mwqLNfRtQreKxV0
         owzySv5B7vSORNUW1Wd2QCG66WvWKRqjx2x4IEErXEXMN0vn3Rbn0Qmo23YLouQGzPvG
         wTbbifpSKg9FV9uzhAOrp4z97VNxP5eninGZez7vAcxl1pW3MlILLnPVPLF4srIsvRma
         6K7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWsjNE7ouTq6DQNezD3o2XMqKlaFK6JwJmQIwyHydJXfIsW/TClSelXUW2jmRWgs7Uf7s4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZA1NGtfiXNdGJ7WqcGhwWEY4yglcW+GByPYMYXSpGB2ovd5bZ
	GBbtkeaZu5Ejk9PhpEmeugx/YDz4+FxPeicyauzChRJMp6IlEMRvxi64Un3Lz/CdAVHGd87i9Qt
	AFMWN9w==
X-Received: from plbkg12.prod.google.com ([2002:a17:903:60c:b0:29f:25b4:4dc4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1805:b0:38e:87b7:5f88
 with SMTP id adf61e73a8af0-3937210bb2emr1114819637.27.1770163225959; Tue, 03
 Feb 2026 16:00:25 -0800 (PST)
Date: Tue, 3 Feb 2026 16:00:24 -0800
In-Reply-To: <da810fb5204a88c352ca3983e0b2e27b485b33e7.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
 <83f9b0a5dd0bc1de9d1e61954f6dd5211df45163.camel@infradead.org>
 <aXt6ZEgZRGPPPtTB@google.com> <da810fb5204a88c352ca3983e0b2e27b485b33e7.camel@infradead.org>
Message-ID: <aYKMGGttusuMI2QU@google.com>
Subject: Re: [PATCH v5 4/3] KVM: selftests: Add test cases for EOI suppression modes
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Khushit Shah <khushit.shah@nutanix.com>, pbonzini@redhat.com, kai.huang@intel.com, 
	mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com, 
	shaju.abraham@nutanix.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70114-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amazon.co.uk:email]
X-Rspamd-Queue-Id: 85ACEDFE01
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, David Woodhouse wrote:
> On Thu, 2026-01-29 at 07:19 -0800, Sean Christopherson wrote:
> > On Wed, Jan 28, 2026, David Woodhouse wrote:
> > > From: David Woodhouse <dwmw@amazon.co.uk>
> > >=20
> > > Rather than being frightened of doing the right thing for the in-kern=
el
> > > I/O APIC because "there might be bugs",=20
> >=20
> > I'm not worried about bugs per se, I'm worried about breaking existing =
guests.
> > Even if KVM is 100% perfect, changes in behavior can still break guests=
,
> > especially for a feature like this where it seems like everyone got it =
wrong.
>=20
> There's the potential for guest bugs when the local APIC actually
> starts honouring the DIRECTED_EOI bit in the SPIV register, sure. At
> that point, the guest *has* to do the direct EOI (and it has to work).
>=20
> But that's why we kept the 'quirk' mode as the default unless userspace
> explicitly opts in. And it's true for the split-irqchip too; fixing the
> behaviour is the whole point of this exercise.
>=20
> I don't see why supporting precisely the same behaviour in the kernel
> irqchip is any different in that respect.

Conceptually, nothing.  But fixing the in-kernel I/O APIC is more invasive,=
 it's
not currently broken (KVM doesn't advertise DIRECTED_EOI or SUPPRESS_EOI_BR=
OADCAST),
no one is lining up to actually utilizes the functionality, *and* there are=
 some
historical warts in KVM that need to be addressed.

Add it all up, and for me at least, the risk vs. reward is very different f=
or
split vs. fully in-kernel irqchips.

> > And as I said before, I'm not opposed to supporting directed EOI in the=
 in-kernel
> > I/O APIC, but (a) I don't want to do it in conjunction with the fixes f=
or stable@,
> > and (b) I'd prefer to not bother unless there's an actual use case for =
doing so.
> > The in-kernel I/O APIC isn't being deprecated, but AFAIK it's being de-=
prioritized
> > by pretty much every VMM.=C2=A0 I.e. the risk vs. reward isn't there fo=
r me.
>=20
> I tend to favour the simplicity, with _ENABLE and _DISABLE just quietly
> doing what their name implies without any of that nonsense about
> "except if you have a kernel irqchip".

But they _don't_ do what their name implies if there's no in-kernel local A=
PIC.
I.e. userspace needs to read the docs and do the right thing anyways.

> But as you wish. Most of this test case should be fine on v6 of the
> patch which dropped in-kernel I/O APIC support. All the tests are
> conditional on the corresponding support being advertised, so it just
> needs updating to correctly detect the in-kernel _ENABLE support in
> case that does get added. How did we say we would advertise that?

A doc update plus this:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 67e666921a12..d711493f9c69 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4934,7 +4934,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
                break;
        case KVM_CAP_X2APIC_API:
                r =3D KVM_X2APIC_API_VALID_FLAGS;
-               if (kvm && !irqchip_split(kvm))
+               if (kvm && !irqchip_in_kernel(kvm))
                        r &=3D ~KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST;
                break;
        case KVM_CAP_NESTED_STATE:

