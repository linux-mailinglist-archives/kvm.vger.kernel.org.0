Return-Path: <kvm+bounces-57422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81CC2B55442
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2308B3BAF9E
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B165431987A;
	Fri, 12 Sep 2025 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="gsbdA/Oy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB444188580;
	Fri, 12 Sep 2025 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757692770; cv=none; b=PP3yLMDV7wuouHW37F6GDwxgcF1JUvldSjtluGHd0D3WGHHG8/5aYUpzOaaUW6p5Kmzsyxn/W+HHX/73YsCS4CWPhsCpT7G9Np0xHqrb9hevHHL3EJ4cDJfo9mcziHah6kPZwJo0kQPFFatd8mWXPkWJous2fPEs9OsTI+qKe04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757692770; c=relaxed/simple;
	bh=GEBOk8PUOnHvSZXyPwd6N6SN/rdmFnYyQYQiSGsy8bE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNqYZX0vFBcq/ZO9Gd8N3BheEy7vWqIADigjRyj3t8OkIbU+AmtTK3P626vqmLf68z2ci67mbSTAywrW6hXSTnMsB9rTP+cZGK9uabrXPg1NTyViwdy6ipwQXO9E/brmX9oZdffyKzt+YVIFM5oht3opAZY5YsiXY+3J3j4D5Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=gsbdA/Oy; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2A48140E015C;
	Fri, 12 Sep 2025 15:59:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mifj5-GIQUtb; Fri, 12 Sep 2025 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757692758; bh=Q7C0QzXqcbpFCbjIXqNbLP6tXQLFqk1MBSz9ZcxW/ag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gsbdA/OyMeaHLRBJCvpAZ2lYcfA+fT16HkNZShvgfymNgHta6fOp31XGfLoR4i2ij
	 xi0rPSNAkwo7fvvVjiJ+7spgzg2oHvBaPTe0MsHXp/Ed/vRFBo2xENZezn25DgLfVh
	 GbeS1KnDanVL0KeferUm19BagZi626XZ8GroPjWrc2CClpysWa00z+ChbEvrqsomzP
	 FtWRQtoZC1o0KydH/WCfOB5nX0PVPLHxGvzJNWYnz5VAV7+KIP8fiPZhhs2k4+NXGG
	 W+oXUFM84PA+1qciZS62ysQPhWcnKEt1e/WKIZ92AOIUMh+bfDGi4Fh5OcX03LTQ0E
	 nSxW9g4Yuu5G8kxxOMDmsjFVrWwWh4+fOFcrzHVmFJBmFwTyG9e0AUtU9Qp3bhdu8F
	 +L4gNQo0Y7jWT5YVRV8OyNWtJLDBZYwVDRsz725mpv8AzmDCaaUGsnKbi1tUyWitif
	 SDhhaMJwo93yDt//a8jT5ghwZQONztKPe2dgaYikwOTo+r4+6mwkfBUQ7UP0I3Qnu0
	 R+G0wZQPwUrI9pAW7WVz3RLFOvu8w7ZFHaxlL921I4HUzz0dCcBBMZ2WZiaozGIfql
	 unPAvbmsN2Opc1jIFA4dlknstZMEko62GdxXK1kbk01IN47TzFdD1v6K0v4pEX93vu
	 GwMabEI3lf+258cLMzN4Vwh0=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 3032640E0140;
	Fri, 12 Sep 2025 15:58:58 +0000 (UTC)
Date: Fri, 12 Sep 2025 17:58:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: seanjc@google.com
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, nikunj@amd.com, davem@davemloft.net,
	aik@amd.com, ardb@kernel.org, john.allen@amd.com,
	michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
Message-ID: <20250912155852.GBaMRDPEhr2hbAXavs@fat_crate.local>
References: <cover.1757543774.git.ashish.kalra@amd.com>
 <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>

On Wed, Sep 10, 2025 at 10:55:24PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When leaking certain page types, such as Hypervisor Fixed (HV_FIXED)
> pages, it does not make sense to dump RMP contents for the 2MB range of
> the page(s) being leaked. In the case of HV_FIXED pages, this is not an
> error situation where the surrounding 2MB page RMP entries can provide
> debug information.
> 
> Add new __snp_leak_pages() API with dump_rmp bool parameter to support
> continue adding pages to the snp_leaked_pages_list but not issue
> dump_rmpentry().
> 
> Make snp_leak_pages() a wrapper for the common case which also allows
> existing users to continue to dump RMP entries.
> 
> Suggested-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/sev.h | 8 +++++++-
>  arch/x86/virt/svm/sev.c    | 7 ++++---
>  2 files changed, 11 insertions(+), 4 deletions(-)

Sean, lemme know if I should carry this through tip.

Or, if you wanna take it:

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

