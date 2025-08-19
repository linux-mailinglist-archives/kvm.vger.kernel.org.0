Return-Path: <kvm+bounces-54992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7081B2C711
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0ED6A1BC3B29
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 14:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9A827603C;
	Tue, 19 Aug 2025 14:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UVMpVPsb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAC4273803;
	Tue, 19 Aug 2025 14:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755613972; cv=none; b=B7+csrEx0fni60qnrkk+l5+v5rp3+nm7qxJX01UvbKXqQ6dELLTuybuoATB276/qqVmttDgXXrAXqp2ttYPCi7H8dmvYi4sy0R/PeoPbAZKGqr5wTzGN/RqFsxd+istc87qA1CTngIHL7GSN91hrTRUFy9Tkt7z2qBo5IZiyQeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755613972; c=relaxed/simple;
	bh=gf4hkI9hcplSkySrTCaV3SJnK5vYQHEDd5Zf3JnREhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzb7lu4q0ILrTVL/EenOjG/iDDQxBDZns7dPptMjnz+pKVLjq8iBbypS5RV0CkfsGnRGlyYnZtBJv82QgAd7GxqwKwTWysZKgSZN7mNsWGKy6GqV6QLt1ujweG+8RZHBvBk0mCUXTOcm9q1Sr3Ruu06gZg6mnbg09Fe4LtSv3kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=UVMpVPsb; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9636640E0288;
	Tue, 19 Aug 2025 14:32:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zaFT-GfrdxNt; Tue, 19 Aug 2025 14:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755613962; bh=xjlGYKPliHKhc5RSWVlRNbayOIa12C78m0wSqOWzikk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UVMpVPsb9OmrozhVyw06n6OdY6O6taVnG0IZUF4WqxZXFlk04Ify4CabyjnAaHzVv
	 FhzU0ouSgri5VRuskaxXNj807QIDdgNKHxlqB+iGAbS3wjyW9BoI46hvWXxB++0qOX
	 0abkNUfJoBgwuYPsOpzJ5SU/wwq9wT5VEGe9BRwycZGUJOe6fR9tcj/5eLWwrUrxx5
	 IBm8t+mwiL56EGMcdFoKojSEIyE0Wv9pZjSUaMhZMv78ydm3I0qVeC09GVBdVHAnke
	 X9SyuFoAy4L1oLAONiun8EqEvg/9Ura0EzGAzSqMO+JUjX7rHAeqAZJdmqgRbTZDwV
	 7PpI/P9aSWMwYRyoouxMx7hnVrp0Ip+mGK8JnzWExgvxDzSWLzDRMABI54rFQ601qw
	 7y7/QSKlC57+ftLDhRls0SKCJOzEf1oydvIRN+yrQvcqV9bnqsCbPrNDipfm3D7Mhp
	 sYjE1Je0kpCBYmCnGiaXZeKvyyXenYs+QcDjaYHVXIAWvIrLRmukwI++hA+ksOld8V
	 dOZUgGV7HBnCEcZVrS6DDBJdmB5jFZ/GAauhdgRKEvyuoMEnYzQjNFn8paBpe/eVeR
	 vrkVHVzWE4E4nGISErqJDdWWkQi9OxPNwsxJXnpSoP00SfbYS0UoPIuhQRNDm79AJb
	 Moi0icz50yrxrlQPPkdmFh+0=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DF9C540E0232;
	Tue, 19 Aug 2025 14:32:19 +0000 (UTC)
Date: Tue, 19 Aug 2025 16:32:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [PATCH v9 03/18] x86/apic: Populate .read()/.write() callbacks
 of Secure AVIC driver
Message-ID: <20250819143214.GKaKSK7rABhHAldbbR@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-4-Neeraj.Upadhyay@amd.com>
 <20250818112650.GFaKMN-kR_4SLxrqov@fat_crate.local>
 <964f3885-059e-4ab0-b8fc-1b949f0b853b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <964f3885-059e-4ab0-b8fc-1b949f0b853b@amd.com>

On Tue, Aug 19, 2025 at 09:45:02AM +0530, Upadhyay, Neeraj wrote:
> Maybe change it to below?
> 
> /*
>  * Valid APIC_IRR/SAVIC_ALLOWED_IRR registers are at 16 bytes strides
>  * from their respective base offset.
>  */
> 
> if (WARN_ONCE(!(IS_ALIGNED(reg - APIC_IRR, 16) ||
>                 IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)),
>               "Misaligned APIC_IRR/ALLOWED_IRR APIC register read offset
> 0x%x",
>               reg))

Let's beef that up some more with a crystal-clear explanation what is going on
here so that readers don't have to stop and stare for 5 mins before they grok
what this is doing:

	/*
	 * Valid APIC_IRR/SAVIC_ALLOWED_IRR registers are at 16 bytes strides from
	 * their respective base offset. APIC_IRRs are in the range
	 *
	 * (0x200, 0x210,  ..., 0x270)
	 *
	 * while the SAVIC_ALLOWED_IRR range starts 4 bytes later, in the rangea
	 * 
	 * (0x204, 0x214, ..., 0x274).
	 *
	 * Filter out everything else.
	 */
	 if (WARN_ONCE(!(IS_ALIGNED(reg, 16) ||
		 	 IS_ALIGNED(reg - 4, 16)),
		      "Misaligned APIC_IRR/ALLOWED_IRR APIC register read offset 0x%x", reg));

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

