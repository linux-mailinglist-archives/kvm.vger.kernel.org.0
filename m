Return-Path: <kvm+bounces-31122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93AB09C08E2
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:29:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A9F51F243BC
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 14:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E2F212D16;
	Thu,  7 Nov 2024 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="WpXfZWMF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914C929CF4;
	Thu,  7 Nov 2024 14:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730989774; cv=none; b=rWp2itFz0u6ylqN/37n29iQM0g8ONnPjN1+/LfgVMMQpjvHf4beRdV/SfGTJ+NdqM5cFvBIpijXjr4MjoeP3P5bpwKkOLh8zTUbMtpys5TBQ85fDuSeSHcegERoUdzaPDqb3BU6WSec7+hsN7qjTy1V6rqMi5YzSosqjWV1aqm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730989774; c=relaxed/simple;
	bh=qTJCPmQc0wQPBA2t7FrvNJQ16tzLCuQde9NWc/cfJes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CbrArvSpr+TtEfsMroVqq9MqeYMWcTapH8sS0Kk1LnMmJ8i4BwZ5qc3gmENV2rkM9V4vD3a/9dlOeqkcLHmzUKngbXWCm7yuAXifDtpC1dP5yg8/q7LYlwTGTLDvU7DMS0jPmnYp4DkO96sMBxwxZuejYJKldoCrBp17WYKIgws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=WpXfZWMF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0CBE640E0261;
	Thu,  7 Nov 2024 14:29:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hgWXCkSHF6Hg; Thu,  7 Nov 2024 14:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730989762; bh=CpUSF5wV943nizZbTHFsAvrf8peZivoamSj5AQOYqJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WpXfZWMFRF5y5R+ioYc3w7GP+hIGkgzbVfsM8qPcriZ+3iC534kr1LRL+I2tMObag
	 0Z+pq3c+PeV/2W2H//suly6l/wQxUaooRGZei6O63O65g7pp/oPurHUzt8xStpMsqr
	 0lTC+uTnm4ajBfhdbCkrpJEiwRKfN90EyRTsxcA6loRME/FSbNGgZdTHhrF3E4CKal
	 4w2ynibYDKeIbfR/6Omndza4dNTQmSB1Ugwi+rPgCHc9yIWqb3pQsErOjNiAsQjWqK
	 BycMwJ8rWLb83Dj+eShm+uhiAAFEfv0oefOIiks8v6TyYnuN7Yaxhm1+JmoYskay2g
	 DgK+ohuZhgMhVWg+Qe5HBaRYrYm6NBXVRKhnm+VbEsFG84Zxr8ys2uOYHIb1Jp6eQY
	 qN7NWwORvI5fEerafRrv5uQUIfKj+2H886bxGhLyr3sDJbNdTzIby333DN+te1WcAs
	 2NRpAcESBhoRjdUOdcCmsZbrawHx2EsWF/RJ2P3D2vuqtc5QpgnaVybIaWxzuHjYQ9
	 UKJyUwPOoICwBBmO2e4RG0BH8xFcJzqaAYIh8k9U4wFub5MVuTkH/xrEdzhzDz5Ltz
	 dm5PqOghgZkrjWNfWVMWnsMiVOrKRJHUHNPOh23K+ZWlu1zgXBIIgrc09D2WKRFVIf
	 0UB7TAysopDld7Zeh/dIQmTY=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 671E840E0163;
	Thu,  7 Nov 2024 14:29:05 +0000 (UTC)
Date: Thu, 7 Nov 2024 15:28:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 03/14] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
Message-ID: <20241107142856.GBZyzOqHvusxcskYR1@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-4-Neeraj.Upadhyay@amd.com>
 <20241106181655.GYZyuyl0zDTTmlMKzz@fat_crate.local>
 <72878fd9-6b04-4336-a409-8118c4306171@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <72878fd9-6b04-4336-a409-8118c4306171@amd.com>

On Thu, Nov 07, 2024 at 09:02:16AM +0530, Neeraj Upadhyay wrote:
> Intention of doing per reg is to be explicit about which registers
> are accessed from backing page, which from hv and which are not allowed
> access. As access (and their perms) are per-reg and not range-based, this
> made sense to me. Also, if ranges are used, I think 16-byte aligned
> checks are needed for the range. If using ranges looks more logical grouping
> here, I can update it as per the above range groupings.

Is this list of registers going to remain or are we going to keep adding to
it so that the ranges become contiguous?

And yes, there is some merit to explicitly naming them but you can also put
that in a comment once above those functions too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

