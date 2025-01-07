Return-Path: <kvm+bounces-34674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6053AA03F68
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 13:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 032FA18874DF
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 12:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E0B1E9B3E;
	Tue,  7 Jan 2025 12:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Rr25qKON"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06484FC0E;
	Tue,  7 Jan 2025 12:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253465; cv=none; b=p8GtXNP/t5TI7scz1yrJfE4g+PeManHzCuKaIQE8j2seWqyh6meZEf4NiR4mxnvn2uUyUMILz3/2S/LdNCZEwys0VuNu6oFE2x0IkEcDGVnvdrvy3VoBZnMPQUc2xL/QMYeZO4WFeO9s/Hi/ftqSebCFrkuQJ+WItCiNVYEYYd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253465; c=relaxed/simple;
	bh=3CHsslgHpJpawee/gvsUvCHadiF1wWhSK1n06g4WblQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=goO0GQ3En15dNxQAFO2uQiuYMkYZhYbBT8BqRLA3odv+lsAT6vm3tw4s9vrXGIG5sj+DHrgoHXziLf4+mTzqel/52oVyZZjE73xr5zv32n0ngdlZFA4mTf2y0IgiGcJIegUIhBlE8xwb4vlFb90ndhg3JWvb0bSvjWg6x0LY8OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Rr25qKON; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EBA2F40E0163;
	Tue,  7 Jan 2025 12:37:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id XSzZzGf8wPkp; Tue,  7 Jan 2025 12:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736253448; bh=ISji3lVCWeh5JUXkN/3WOm1xt+5joVQtVcCRL5EuvzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rr25qKONzTxSP7kYtQE/nX6ewQ4YxZtcDsw0JiP6J3JzmQg273UUx49rpriD6bh94
	 Go9DA+f/AnjaRTQ9ugQN0/uekCq4VgQ+7lDeD5Cr2wYNpPBFhw6oH0kDhKIa4cql2h
	 BGB8JCgSbZ+Dgw8+FKZhqW6mWfteHxU1UaXivEzOkjjvc6PHti1CpHGTfCRku1O4Ht
	 c0iXGhT0No9zcVahejZMbC8Vja09ue8jH4C9/ZDDb2u1ZX4WyEBdUZYBJdhL654O/K
	 a2zE6yoaQXT23GrQQt+doHPSatOYejr/rGzmK9fB0pR4rEnBq/wCQYK7QSfGRlnBQG
	 o1pCwtjWSAV4aWPuGQPvu3s9XQWRSs9l5NO55jUfpEYIr85JyemYwtSKtXzTiWOJrl
	 9EWjlRtlP1ufCXRsxBq4XRZboSqoIRPWS/q454UGheh3FoTc+RObc1xMJyevgVYVsb
	 MwSseHsUcDqXSJRf1bagFbYsksVvB+664lXn5EbD4e30m2aYsBryL7jiytB9nWomY9
	 56K2Ha0EozV58ZqsbwrahUyRdPu9cjVres7RgubXvOZN+5cSeCnC6M8CVfeLCUVQ5i
	 4hW5VqTkDGg6b7lnGZYJXXo1QXrrXUZF7nkwZTujjc8kfThqmqslQf4YmlQxVGR63T
	 cnIpy/hKFlydi463EAG0Ah9I=
Received: from zn.tnic (p200300ea971f9314329C23FFfea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9314:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B97AE40E0266;
	Tue,  7 Jan 2025 12:37:16 +0000 (UTC)
Date: Tue, 7 Jan 2025 13:37:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20250107123711.GEZ30f9_OzOcJSF10o@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-6-nikunj@amd.com>
 <20250107104227.GEZ30FE1kUWP2ArRkD@fat_crate.local>
 <465c5636-d535-453b-b1ea-4610a0227715@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <465c5636-d535-453b-b1ea-4610a0227715@amd.com>

On Tue, Jan 07, 2025 at 05:13:03PM +0530, Nikunj A. Dadhania wrote:
> >> +	case CC_ATTR_GUEST_SNP_SECURE_TSC:
> >> +		return (sev_status & MSR_AMD64_SEV_SNP_ENABLED) &&
> > 
> > This is new here?
> 
> Yes, this was suggested by Tom here [1]

Either of you care to explain why this is needed?

> >> +			(sev_status & MSR_AMD64_SNP_SECURE_TSC);

I would strongly assume that whatever sets MSR_AMD64_SNP_SECURE_TSC will have
checked/set MSR_AMD64_SEV_SNP_ENABLED already.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

