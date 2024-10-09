Return-Path: <kvm+bounces-28225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 816BD996780
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 12:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A72751C242D6
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DED018FDDB;
	Wed,  9 Oct 2024 10:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GCZV1xtH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A87117E003;
	Wed,  9 Oct 2024 10:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728470581; cv=none; b=OSR+lH99b0JiKIRz1lwPOBmH9WMr4KYnv0emwmXViYZd+oGyzqPU+I0BE79737fzyt8mBbDmHdPwxbx9hz+4HY9XEC1YLAyOA9Lp1kgDwEIv/q44tDx7RYryNti0EzUdcHLiV3+2g5EleBOuSjpHsmSMx3iS3i1qZY6rL8raDRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728470581; c=relaxed/simple;
	bh=y+FHToDkdmoGM9ZlI965gDuwyhD+rrt/PzZNqNo50IM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YsPvcHOM3bCIaM82CggoPru2D4eFEnCe+uRhUPg/uip6A0vYuS1DnFYIMLga/zZEgDpEMuZ1pBUxvea6V7tIiPyl83z5NeZwY/8brleuKw4e0ddvkABX2NBqv7Yz2ClPDjTHaLusexgBQtHr7Kb7GWab+9ZjtahP/b6euKiGrDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GCZV1xtH; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E9C1640E0263;
	Wed,  9 Oct 2024 10:42:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Jn8mNW62rvoP; Wed,  9 Oct 2024 10:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1728470574; bh=u6LMZ47p1zQljkYPQce6JNG7WygsvCyX41arxCqYh9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GCZV1xtHEQAhbcpt5p2QX/EAgV2ms6gNo6CUi4WGRaiohThtSTDrbOs/QTE9ObTxS
	 v9ZXiKyja0COTjlMibMKwmt30cjov7Vd4wl4gIn7Wqs8fIgTCfazfF9TeCBgBp/ahc
	 a8qrinDnsL7K0q+YknmITLzd+8XBwOPEMoppTs8lvW9s6MXWQ8CYct0ln6Opa/n7Xb
	 kDsBfF/VmOZb0yx0XRla0JKBTGZoEZ3BXcFmsgrj3Byy8y2JK1C/n5LzWv4RgMr9rK
	 gUDF5eUn43aM43SazScTi09Y8Z+DwoTVNoByHFnLjHwjIqPFLqb2oTAEkPrpL85O8T
	 SKEiwJczMVYWHoThv6KJM3lJ8Mv2KwKi3PRvWyecT3ZE1o8revZsBaeIpVM0eqRqiA
	 nftQQAqqbEM0mwaPT6u9teztmt+gpH9KDnUp/bhCCkJuEf1Y5YQlJwnlM0Bns647lG
	 A7EJmW0AtEis7+YD2IkcuysguDx+SF56jrZp7p8ruvZ84ulCCAHN3rP2C5C0nGItCd
	 yMa/DFZGbanF8cNUvwThzc25GLBxdhzjaWIB7P1uDpVjDa5LM+dioBzZiPqTev67m3
	 eYwDkK7v3b659F5uvO54kgbJSUA9m1jvepoY7OTejmpXbUQj5Rr1KICi455+7bui9H
	 PolMeN08xj+4ADjtikJoca3E=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E074A40E0163;
	Wed,  9 Oct 2024 10:42:35 +0000 (UTC)
Date: Wed, 9 Oct 2024 12:42:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <20241009104234.GFZwZeGsJA-VoHSkxj@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <sng54pb3ck25773jnajmnci3buczq4tnvuofht6rnqbfqpu77s@vucyk6py2wyf>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sng54pb3ck25773jnajmnci3buczq4tnvuofht6rnqbfqpu77s@vucyk6py2wyf>

On Wed, Oct 09, 2024 at 01:10:58PM +0300, Kirill A. Shutemov wrote:
> I don't think CC attributes is the right way to track this kind of
> features. My understanding of cc_platform interface is that it has to be
> used to advertise some kind of property of the platform that generic code
> and be interested in, not a specific implementation.

Yes.

> 
> For the same reason, I think CC_ATTR_GUEST/HOST_SEV_SNP is also a bad use
> of the interface.
> 
> Borislav, I know we had different view on this. What is your criteria on
> what should and shouldn't be a CC attribute? I don't think we want a
> parallel X86_FEATURE_*.

Yes, we don't.

Do you have a better idea which is cleaner than what we do now?

Yes yes, cc_platform reports aspects of the coco platform to generic code but
nothing stops the x86 code from calling those interfaces too, for simplicity
reasons.

Because the coco platform being a SNP guest or having an SAVIC are also two
aspects of that same confidential computing platform. So we might as well use
it this way too.

I'd say.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

