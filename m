Return-Path: <kvm+bounces-55639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5580BB34664
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 366ED3AA265
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E0DA2FE571;
	Mon, 25 Aug 2025 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="g/4Zs9GO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4B22FCBF4;
	Mon, 25 Aug 2025 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756137307; cv=none; b=KAbfYGjNM5Y89NTygluFuR2IGK7m3vBvsOfBkVPGwZRb4igljgwXLnDIW23omx/ySLuFZW7S9HvgdjPY3fnNZXaU6qwiVmYHsC4aylqHLXcU+0SBO2qnlUwfC5bcldU6n74rMO2QSGju/dgoPvaOkA3eGl92UaKIir4EdGj12+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756137307; c=relaxed/simple;
	bh=4j5cPccNoo1GvUX/Bio206S/2RoD4+EFZU6pa0pdd4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DiiIFqzAbKAX4TbFZKxIqH3Kz/PnNFT4PKS8mrIYpU89axgs5Lho7u/742tWEb37zv0uSkDn3rtxZF7pl49j2VNJUZEv2dgZzMeVaspRAaTPZGLJZG5VROrwUlVERYPgHK1VL6PtmRc89zj82wlqvdBXRCXGyjVGdwCSP68cPec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=g/4Zs9GO; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 140C440E016C;
	Mon, 25 Aug 2025 15:55:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id p5z28Zn20_wF; Mon, 25 Aug 2025 15:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756137298; bh=zmk6X8NNKl7QU6B3Y7nFOLjJmQptP/tyBeLMXSCuEGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g/4Zs9GOc24CPDwyfDTvyeTn/abKlvSVJE2bwzHW8UUc2/pNACZkwogND71PmS1uI
	 4upmfV830oFaxEj/2ZXTG+F1leVIciDxVjJIEFLobiMIQUbWGqhz5fWLTwn4QDxc40
	 E3PLSSXfOCX8sGJtJU28TligiiHYC2686mMQXptwOG7Az7kaXqNli+t506ZFneP3Zf
	 0NUKe7TYN62kI6yUCTE+yO4zxXOaF9Ju9tFpBFuQqEeyC3nZeBtNavtQP0qbzjsxY2
	 EW3WztQtnMZiQE/hyU4ltbjgJhXY7tBcONZGMBsF2wt+juczi/sldde4+ftSvv+Eyw
	 3hW0tNMx/OnfrmZGN9H6/jJvLA4w8USgXoN6HltuHekZEIVtbQnio8hyg5PYyR5wZq
	 sZCGSvXxGoBXzekdv53eokMCo8PEHWqQtW2O0JzwcgYPs575Yesq0acRBYa8yv3Zrs
	 SKizvLlg/98aD57C41p2c5/adZHY9+r3qws/LDrfmiT9bJeeFlYFbvwLirdGGX5nyt
	 l6prJLizis5OaeZbAOR00iNTQeZTyS9Bq2XP0NF2ZKBwFExQrIDe8BdNgKsMWQ2L7e
	 w74V7HwUoHWEFN/8UrgpvNEcilm4t0HdxsfCO2a1Fg4/eGx+LMYzDUho40kfJYoGiy
	 szENSV/idrkrQagP7+Pk6ntw=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9093A40E0217;
	Mon, 25 Aug 2025 15:54:37 +0000 (UTC)
Date: Mon, 25 Aug 2025 17:54:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [PATCH v9 16/18] x86/apic: Enable Secure AVIC in Control MSR
Message-ID: <20250825155420.GBaKyHLA70ShAp_s8d@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-17-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811094444.203161-17-Neeraj.Upadhyay@amd.com>

On Mon, Aug 11, 2025 at 03:14:42PM +0530, Neeraj Upadhyay wrote:
>  #define MSR_AMD64_SNP_RESV_BIT		19
>  #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
>  #define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
> +#define MSR_AMD64_SECURE_AVIC_EN_BIT	0
> +#define MSR_AMD64_SECURE_AVIC_EN	BIT_ULL(MSR_AMD64_SECURE_AVIC_EN_BIT)

..._SAVIC_...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

