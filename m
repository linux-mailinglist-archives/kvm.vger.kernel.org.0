Return-Path: <kvm+bounces-42842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9FF4A7DEDB
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 15:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D921188C87E
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 13:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9F38F6E;
	Mon,  7 Apr 2025 13:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="FIZFtSDt"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FEF23ED6E;
	Mon,  7 Apr 2025 13:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744031871; cv=none; b=i4PYTM7jMFd5UgkAgr24MxKG6q+t79NLo25wBGnWPKH+HPvJhQcZ24QgVIpaTpDOtF60zXsPn7xSV85BMAaLGNZvNQo5CrN+vTKk0CmNVeMTaRPAxgPjePQpJ6E2l90chdwsha1V8/gmjkucj+W+oAd7BmznlRoJSCgf5kVljdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744031871; c=relaxed/simple;
	bh=j3ADn87dIPWF3LPVBrrNAXdif+WJGrSNjAcLZdKKQeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p80f0hgwOuz0NrnnCUs2lZgtZiwu8oBQTIm/+gzwCOCTJAXhCpTRdTDtZY+PlbSD7Up5vAkyLn/YPmeahO3VsebH8o5270AnAkIC1UdTYKLKqLaO3pTDJSWHi2QabvmWqjPI1o44wSrYHjK9Qwl5VrYX/CmKn2KDnpgBhvvg1S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=FIZFtSDt; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id ACC1840E0214;
	Mon,  7 Apr 2025 13:17:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id U1-CwGR10169; Mon,  7 Apr 2025 13:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1744031862; bh=9hSq2gq21alq/FTZf3bAecPFmsh15ve6BUHSwGy1L+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FIZFtSDtEO76M2xlQTcEyk9e1CrKBXIn8vCQtjFF1LZnGuo9HJ/tgjGbJ1z7+O9Ky
	 O/eSaFka/4B3Nma2jfLSfYfSmE/fx2M8v8pOWSpCgBbQGkklt5rWHNn/iqlO3LjkDT
	 J3erIiNoj+LHaqJLnW6Sb6Whb8w5beh5wlWXbdv/m4mg8+b97osfh6CmXxKBuY7WoX
	 xWaX8Ag3OuC6lyNeJqb/3tRpqARu75nFGof1fm/KO51HYM9qMigeEvgCHDcxFZDpLd
	 1/xbHYVEG+Sqw4pPh4u66iELjqRqeubjj/spxchap2L8aY6QxeQOmf0ohLFrZYv26S
	 O/TaF9GWgdozW/S05FEomrEzGBE+PeV/El94aWKPKgTPrLTKhmXU7UuONeg29MscVp
	 6WNGfrGkH2siWuQE22tDFrBmhEmvqqahQqJ8GGMEnnngq822Vg/cLn0LxLDe9knlH4
	 HzDoeN5S5WOb7HrL+TUrPqTdGyvg48/bhNmDVpR++N/bWraOWNJRs2b9UrHm59aYGk
	 UkWuTckJqCNOOY4ihapbOOsnNbUrG2SThhYzluLZFORVuiShPB9rYcmQSrBvgAwZx+
	 wtIrTF0yZKwbgezrIDEYlu/97gmM3gNV1kt/0OCMaSemDa7233S/bNkNi9zlM947t5
	 jiWXArXVL9hDxs21tUCdqyEE=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 28F2E40E0213;
	Mon,  7 Apr 2025 13:17:22 +0000 (UTC)
Date: Mon, 7 Apr 2025 15:17:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
Message-ID: <20250407131716.GCZ_PQXC9Gkc-LzS33@fat_crate.local>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
 <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
 <a7422464-4571-4eb3-b90c-863d8b74adca@amd.com>
 <20250321135540.GCZ91v3N5bYyR59WjK@fat_crate.local>
 <e0362a96-4b3a-44b1-8d54-806a6b045799@amd.com>
 <20250321171138.GDZ92dykj1kOmNrUjZ@fat_crate.local>
 <38edfce2-72c7-44a6-b657-b5ed9c75ed51@amd.com>
 <20250402094736.GAZ-0HuG0uVznq5wX_@fat_crate.local>
 <18538e70-aadf-4891-964e-4f8a06d85e5a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <18538e70-aadf-4891-964e-4f8a06d85e5a@amd.com>

On Wed, Apr 02, 2025 at 04:04:34PM +0530, Neeraj Upadhyay wrote:
> - snp_get_unsupported_features() looks like below.
>   It checks that, for the feature bits which are part of SNP_FEATURES_IMPL_REQ,
>   if they are enabled in hypervisor (and so reported in sev_status),
>   guest need to implement/enable those features. SAVIC also falls in that category
>   of SNP features.
> 
>   So, if CONFIG_AMD_SECURE_AVIC is disabled, guest would run with SAVIC feature
>   disabled in guest. This would cause undefined behavior for that guest if SAVIC
>   feature is active for that guest in hypervisor.

Ok, so SNP_FEATURES_IMPL_REQ will contain the SAVIC bit (unconditionally,
without the ifdeffery) and SNP_FEATURES_PRESENT will contain that thing you
had suggested with the ifdeffery to denote whether SAVIC support has been
enabled at build time:

https://lore.kernel.org/r/e0362a96-4b3a-44b1-8d54-806a6b045799@amd.com

or not.

Right?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

