Return-Path: <kvm+bounces-34524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF7BA00902
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 13:04:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F41E43A3BD1
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 12:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3C21F9ECE;
	Fri,  3 Jan 2025 12:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="XNIcuvwB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385B817BB32;
	Fri,  3 Jan 2025 12:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735905873; cv=none; b=lhywgun4B3S+1XY4b9VSsX1PSXOI8QsNMGWMjPOW/ediQ/UVpDa3IUiPmwkoHkCAIXQInsRdO9eu/VlIC+9IzcqIneoMyqcO7EgmnJ2hUzRQguiKiG7kbZbxKAIxlQ/gCMwCEuWEAJbdw6cWyyB8Z80BXCSH9xL0i+MODswx6D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735905873; c=relaxed/simple;
	bh=iJfMAovTfBxzp2Rmb1uGcgVVAnlnn3S/sCiRUwY7wFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0+i+KmfIW/fuNul1z+O2iWURAIAijlCWRItLLrtwoA63ScVUkNUJvy9Uh4Qfl59MbQX4Zw9mZ7H2XFcWBwtSfG5dnwdjmG0HtrYcsfK6y1ZB7Y7E6pDdvbUulRHfPDjXTZ4bgQ/6/DBEexHI05EAZKQH/Nhv4bEl/+x2k3+XWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=XNIcuvwB reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A889A40E0264;
	Fri,  3 Jan 2025 12:04:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Jx3YdI6s21hN; Fri,  3 Jan 2025 12:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735905863; bh=OFCo4ZcA0nXDzwXhD4wLT5Gd/hZQO+fN3NdZrHSYXKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XNIcuvwBStoFVqzLMJSF7RVxZ/G96sw39SwAN6IXlot3n9ZsguPaxmbk+F+ht/7zz
	 +bIJ1g7pHnIQ5sj2tOt4f+51COSaZZNV/iLlPtG5MDxax8LkgfbhF8tCtcEqYAdFhs
	 WW+NdtiKwom/2+Na5amFBF4yzf9v/sfD21F/tENv+R7sXDpD6K4Pi9VpY2Q27+Trgf
	 Km6RZpzKTv5GFqI5BXXZPrf5f4kmlekbAy3Q2AX1iri6822bnkAmCBk5oGOFbXNP70
	 7EisJjAaeTftPpUd6mkch7twmEHjuxKxUG6OzNye3CICcQyXnNQsx662/YkczFKp0E
	 E55rpc0AeTrVOEzEyZubUYjiTBTVoEZZzuCNzN4PBaooUQ8kiv8GKE1Iw7x8MA8oAB
	 AwJhVCQw0RWxxsGugI/NiDgNr8OTrTSm8tf7fPRumDUcrFpvBvRcEtltdukFRDuqn+
	 /NIXM1TWZXekBP9haWaLuvFwk+Ol13ebxQOfhYBmEuk50YpgSfcXbvbY+TafeTfm73
	 9X6L5Si1ADnQ8lFmHuml0NMNP2oD9pzyMsZ9W5D7SPJODKZC24LFrmdZ7bUZcZm1Q4
	 phkOgF8xJpqrZmjJ2NUXNVkAQjDfOZr8YlkAeX+RIQULeJORiZJbIb1YFG2TOJfcv2
	 bqDwPm+TPhJyNFVx2tdiZkHE=
Received: from zn.tnic (p200300eA971f93bA329C23FFfEA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93ba:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A479D40E021C;
	Fri,  3 Jan 2025 12:04:12 +0000 (UTC)
Date: Fri, 3 Jan 2025 13:04:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: thomas.lendacky@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for
 discovering TSC frequency
Message-ID: <20250103120406.GBZ3fSNnQ5vnkvkHKo@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
 <343bfd4c-97b2-45f5-8a6a-5dbe0a809af3@amd.com>
 <20250101161537.GCZ3VqKY9GNlVVH647@fat_crate.local>
 <a978259b-355b-4271-ad54-43bb013e5704@amd.com>
 <20250102091722.GCZ3ZZosVREObWSfX_@fat_crate.local>
 <cc8acb94-04e7-4ef3-a5a7-12e62a6c0b3d@amd.com>
 <20250102104519.GFZ3ZuPx8z57jowOWr@fat_crate.local>
 <061b675d-529b-4175-93bc-67e4fa670cd3@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <061b675d-529b-4175-93bc-67e4fa670cd3@amd.com>
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 02, 2025 at 06:40:38PM +0530, Nikunj A. Dadhania wrote:
> -----------------------------------------------------------------------=
----
> x86/tsc: Use the GUEST_TSC_FREQ MSR for discovering TSC frequency
>=20
> Although the kernel switches over to stable TSC clocksource instead of
> kvm-clock, TSC frequency calibration still keeps on using the kvm-clock
> based frequency calibration. This is due to kvmclock_init() updating th=
e
> x86_platform's CPU and TSC callbacks unconditionally.
>=20
> For SecureTSC enabled guests, use the GUEST_TSC_FREQ MSR to discover th=
e
> TSC frequency instead of relying on kvm-clock based frequency calibrati=
on.
> Override both CPU and TSC frequency calibration callbacks with
> securetsc_get_tsc_khz(). As difference between CPU base and TSC frequen=
cy
> does not apply in this case same callback is being used.
> -----------------------------------------------------------------------=
----

Ok.

> -----------------------------------------------------------------------=
----
> x86/kvmclock: Warn when kvmclock is selected for SecureTSC enabled gues=
ts
>=20
> Warn users when kvmclock is selected as the clock source for SecureTSC =
enabled
> guests. Users can change the clock source to kvm-clock using the sysfs =
interface
> while running on a Secure TSC enabled guest. Switching to the hyperviso=
r-controlled
> kvmclock defeats the purpose of using SecureTSC.
>=20
> Taint the kernel and issue a warning to the user when the clock source =
switches
> to kvmclock, ensuring they are aware of the change and its implications=
.
>=20
> -----------------------------------------------------------------------=
----

Ok.

> =E2=97=8B Modern CPU/VMs: VMs running on platforms supporting constant,=
 non-stop and reliable TSC

Modern?

What guarantees do you have on "modern" setups that the HV has no control=
 over
the TSC MSRs? None.

The only guarantee you have is when the TSC MSRs are not intercepted - IO=
W,
you're a STSC guest.

So none of that modern stuff means anything - your only case is a STSC gu=
est
where you can somewhat reliably know in the guest that the host is not ly=
ing
to you.

So the only configuration is a STSC guest - everything else should use
kvm-clock.

AFAIU.

> > After asking so many questions, it sounds to me like this patch and p=
atch 12
> > should be merged into one and there it should be explained what the s=
trategy
> > is when a STSC guest loads and how kvmclock is supposed to be handled=
, what is
> > allowed, what is warned about, when the guest terminates what is tain=
ted,
> > yadda yadda.=20
> > > This all belongs in a single patch logically.

Now, why aren't you merging patch 9 and 12 into one and calling it:

"Switch Secure TSC guests away from kvm-clock"

or so, where you switch a STSC guest to use the TSC MSRs and
warn/taint/terminate the guest if the user chooses otherwise?

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

