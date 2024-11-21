Return-Path: <kvm+bounces-32248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A76259D4B1B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 11:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D4F02817F6
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 10:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502D71CF29D;
	Thu, 21 Nov 2024 10:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kQYvPwbg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E4714BF87;
	Thu, 21 Nov 2024 10:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732186472; cv=none; b=mTsOW8Z6f/3WLvxhH6wDVFaZEtx5d0wR2C5MtmPw39X/tz7rtl48WXPnGohY6GIWBPCtzdl8dIgN1bATEVBpSTD4+JrcRR84BgKSLAaxU9b/gjFK4+yW9HxvAodm33f6Nt6OLC+QHJAqASMMRa/I/NGyThwOiKLzC82wdmp8S7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732186472; c=relaxed/simple;
	bh=fB5OcF75MtK6hPDV2GWDTP/gWRQawJ+U4HsHrmF/awk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hjgb+307/wPjObxzEf3pSEwVl0SrwAjwfH/keIgyxp/AZtdByKlMJfznjlNp3se3zi6MNFhH+HQpYBcRfaPfAuqaJpM0Ibrfm4WVmeYdPRVGZCrNpOcxADKlvZQZ0MzMPF2OEJvsEqRZRv5xfd2soqxHKhMoLC7JuPH8fwZBU6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kQYvPwbg; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0191A40E01D6;
	Thu, 21 Nov 2024 10:54:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rZ5d5XYprrqK; Thu, 21 Nov 2024 10:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732186452; bh=QJ7XSOZv9ivJWYqHnhDDw2JQ05ATG/24E/OppcpjgAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kQYvPwbgWfldoRIYm079SHcVHS1jcbohh5K90CTKH/SaM0cXS9+ucgpRlaXnWlQ8J
	 QsoAEVk6XgL7JgYQHtZ4DKgV/RiBvLbuAcJTMx+XaWVJ6/vI3YKl4AhpYrWIDzmszH
	 AcEljEaGmZ4oH4XKZraWtZ200PkzsC6VMDC3dmzuIYcQ5G7r8+bb78MsSVjo/Tn4kD
	 bO1PbtDMIzVuy+QoHzrd2CIyVS4zrHzaUxJPvtRanzZLlLyWCw0UCXW0TSo7FtSiCG
	 E2U2vnBWr8jfnDrwLi0J0UT9WUGawIJTKRrfDqfKOj8lrBKl3FhKfK0hRSRqWqUNuo
	 OpPjhsUJCI4nnvgPkJyWTQ6HzpQ8F9bdZ61fM2MOL2f9iuXAB7MJG+PAP8ofpw1RM8
	 UXo7qFhy6EtkXdbO1VvTmEvy1Sv1eCFYIOb1PoSewwUfhv38lAjiQseuU1kXKBkQyq
	 jN4R6WMCHySDW+CqwDCiFCslNK6nsAMaiTtoxazmmPgIG3Iff+fCG1fe0QT4d7MM15
	 MuOQma7s+gsqEZZwPOSgV91cswKTdCpQxC9PgsLw8HmK3VYcmLXWOs1D0R+37QFaIR
	 f4V8jcHcvvOmanONCV8P0V5CRSLzgPMx0ozVqNBN4XKTVFMy3t5981WdWvaDr4M+AD
	 S9NXZyc3An9XCABtVMdy4/O8=
Received: from zn.tnic (p200300ea9736a1a8329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9736:a1a8:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 45CEA40E0275;
	Thu, 21 Nov 2024 10:53:54 +0000 (UTC)
Date: Thu, 21 Nov 2024 11:53:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: "Melody (Huibo) Wang" <huibo.wang@amd.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <20241121105344.GBZz8ROFlE8Qx2JuLB@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <6f6c1a11-40bd-48dc-8e11-4a1f67eaa43b@amd.com>
 <4f0769a6-ef77-46f8-ba78-38d82995aa26@amd.com>
 <20241121054116.GAZz7H_Cub_ziNiBQN@fat_crate.local>
 <6b2d9a59-cfca-4d6c-915b-ca36826ce96b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6b2d9a59-cfca-4d6c-915b-ca36826ce96b@amd.com>

On Thu, Nov 21, 2024 at 01:33:29PM +0530, Neeraj Upadhyay wrote:
> As SAVIC's guest APIC register accesses match x2avic (which uses x2APIC MSR
> interface in guest), the x2apic common flow need to be executed in the
> guest.

How much of that "common flow" is actually needed by SAVIC?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

