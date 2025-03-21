Return-Path: <kvm+bounces-41661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C420A6BC29
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:55:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01EF048066C
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 13:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A981C1D63E1;
	Fri, 21 Mar 2025 13:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="hFKTo13M"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF33C142659;
	Fri, 21 Mar 2025 13:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742565187; cv=none; b=LaGFjSEyGcfugTOzG4hv34ctbHDYm7VP1A9CDmn4BZIQfktipv1eYNnQ0D0PID11TYfn5aL+LLZQIvCvSavonCRtDP7caFlKxE0rGehVrjxUs3Sfu0w7AEdxcn8pxJfuQ9K7k0JK/9gelFuBTmsOBa42MT+WJ6cnZ3/Jnqgqv80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742565187; c=relaxed/simple;
	bh=NX4e6NsWbLcYcrYcLG0s5rLv6crXDWHy/rHcoVm1nqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLsiJi94pm8D5qviG3p2YeXOepcvdnW+5gxyIeUX3ARy45iuo4avHR3pkdZMQyyqE+pQ7UKrXJlzpNan63Nphq99R0yOS42JwV6Bj87CWnxeNTKeLvOKxaFD35fI9H3C8Q6EDY4veuHHpFClB2FyCzrpha7+/5E0d2vdK6tpSME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=hFKTo13M; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4720840E021F;
	Fri, 21 Mar 2025 13:53:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id xU4x89GJ0puP; Fri, 21 Mar 2025 13:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1742565176; bh=XSWG7oiYGAeCKB+qfTwRv41Y2MS5husvtxXq7POYzCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hFKTo13MXXbjZ+iFqwYjQv9OybFKuigKA27CNFa4HiAuY+4eT2mo2EH0wQKF+XIkY
	 e6USQO3zIgoaqju+7ObBxCpyUGqOMnE5mNJFuor9tSlOxyxRb3ZDPJRsa9h3O7C53Z
	 nSxtTZPRC+8J8ghT7XCrlw/M5e9G3yvMWUdzyjmuS8JFFlWSligxSfBPgnayweTBbL
	 MPgwtzTERyxDBLaPQkpeg3arPuGdIrvlZtMBo/OzkK0bYHKqmCy0CrsVI3h9W8paJj
	 Yq5PpaQ9OjqGNyeD05a9eRuTi4/Q5XYYnm8CgjgCegVJTSNQgrcWX5lTAneDB7Mue8
	 AMmKTuhD1JITbkYRzPKMCqa8B/VC9gT61kUJPSRtNyzbwIaZqPhRTEx+UfKJJY8+EM
	 kBt6+NPfwNo3VoBfjPATR6HR0PrTpLz+Y2mhO4h7531wAKBbTEUl8Do/5NJs+im8ts
	 TVnSDbI0OfUihAkxifDJypoOibBEaCk68bF+JkueU1u94DDu8CQPT/t2VQ+nT7OK7S
	 3q0A+mmcm/jpSANa3hpzQ/KjYj823qKlQKnl4qvVjZjzkFEcMfRlKMnRkjguc1UeZK
	 n1pCamCYferS1EA8P01Kgfxy1LetrvdbGhBRJ5Zz3FDOuyGKN7HSBi9JFQotcq+18w
	 jLzenbZqKX/8ULlHJizg2odo=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 738EE40E0169;
	Fri, 21 Mar 2025 13:52:36 +0000 (UTC)
Date: Fri, 21 Mar 2025 14:52:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org,
	mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com,
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
	huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
Message-ID: <20250321135230.GBZ91vHhSEmj6jG8iT@fat_crate.local>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
 <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
 <87y0wy3651.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87y0wy3651.ffs@tglx>

On Fri, Mar 21, 2025 at 01:44:26PM +0100, Thomas Gleixner wrote:
> So if you box does not switch to something else it keeps the default and
> does not print. See the first condition in apic_install_driver().

Ofc.

> But that SNP thing will switch and print....

Can we pretty-please make that an unconditional pr_info_once() so that I know
what it is?

Even you and I have wondered in the past while debugging something, what APIC
driver the thing selects...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

