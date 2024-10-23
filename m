Return-Path: <kvm+bounces-29574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 36FB49AD105
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 18:31:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D773D1F2273B
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 16:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92FDE1CF7D3;
	Wed, 23 Oct 2024 16:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="HaRa7LH4"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FE51CB536;
	Wed, 23 Oct 2024 16:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729701062; cv=none; b=t33S4Dj0cblAw4OI3GYDkKKKkSPQODeFfQMJhvXsGZgVk0RXSNiS3QrZHgZe5rqgpXAAT/2Dsm6yoBDRCtHUxjBAXo3RpyaW0fa5IEt7VxTSp00cEp7QwyIpgXYaXbJRlMA5TNXMS06cRctbqYZmpg0uTdoCjlHN5SNPPDEAHN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729701062; c=relaxed/simple;
	bh=UixwmJ5szfNuS+Tq0CHtsJBh+pb34QG21arGCFnLLlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wq33ooedfpiCPTtlATB8VGW7PBkS4vQBmH1t72zrxjk3JZC0R+2g3/J6QJe8M+E8Fgse4olkZL817uVh3xyy6keKUAE47MKFDPwgn25fF8P+AGx0Y+AR01MGvR/LGtmCnjp4N0MEluzF2NPykTXZDXGCiuIowgvkmjKi6IYAlMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=HaRa7LH4; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8AA5740E0263;
	Wed, 23 Oct 2024 16:30:58 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zruC6gNH1KVS; Wed, 23 Oct 2024 16:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1729701054; bh=9VPKPpHyWW4bo1shlL7/ngzTD+Bi/um84TQvbU+2CK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HaRa7LH40cDNaaMgNxvTfdTyqZUZlGcsXvMzGxgGDS8voA7zEdT3nguUkvmNe4UtK
	 bIOhFacT3sXFRh1ckrhZECud01l8owFUDlm9g/nIQFdeiBBgfv4DajuEhddD48RcBB
	 6a5Lc4y2m81V22W8gmGt8sRQrPqV9hpK7/oyTn9CvK0DYi+DQTFgLx6SE4W0JXuPKa
	 sa8Pid6rJScFtaX6/uY4lhQ2sFVJcsAgwj1ZUCPLEsgujvBqnsXGgfriEZvt8eGzP/
	 wuPwfEuXCFgKm+aO+ic6phDiovENS4sC1qIyVIljjlSFVl2nqdmJIP+m2AX+a/wP1j
	 7eWYk1OfVBqGcCpPIT6GMx6EKPqWbYpOiba2gDGC7vki58rTU8sJlODo8BaVU/sBLE
	 DI6bXKohYUVifTXbn+AZT8KRpbh9QczKEIJoJWA8ZS8++ErLw7jND3m4Za/ogKj6el
	 RzXAGplqeB2kGzMVptsWy30214MkmQLac7M9yf6NhzC35QpM00fkBniuuRxvWq3Fwl
	 V2BCnOqjIBBcvwbbU6h0Azg33jQhRSK9NjFG2w4V4b8PHk3xzzPseWk7iV9z1iRWna
	 UW4m8VauN94O614GcHkLQLJrVWthqikr6LydFrqkDvqVFNau0m10Y44+S2PH2eQcdJ
	 lqdGYd9iqd5C0cHwgiJm/c7A=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E6F2340E0198;
	Wed, 23 Oct 2024 16:30:35 +0000 (UTC)
Date: Wed, 23 Oct 2024 18:30:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: Re: [RFC 02/14] x86/apic: Initialize Secure AVIC APIC backing page
Message-ID: <20241023163029.GEZxkkpdfkxdHWTHAW@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-3-Neeraj.Upadhyay@amd.com>
 <9b943722-c722-4a38-ab17-f07ef6d5c8c6@intel.com>
 <4298b9e1-b60f-4b1c-876d-7ac71ca14f70@amd.com>
 <2436d521-aa4c-45ac-9ccc-be9a4b5cb391@intel.com>
 <e4568d3d-f115-4931-bbc6-9a32eb04ee1c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e4568d3d-f115-4931-bbc6-9a32eb04ee1c@amd.com>

On Wed, Oct 09, 2024 at 11:22:58PM +0530, Neeraj Upadhyay wrote:
> I will start with 4K. For later, I will get the performance numbers to propose
> a change in allocation scheme  - for ex, allocating a bigger contiguous
> batch from the total allocation required for backing pages (num_possible_cpus() * 4K)
> without doing 2M reservation.

Why does performance matter here if you're going to allocate simply a 4K page
per vCPU and set them all up in the APIC setup path? And then you can do the
page conversion to guest-owned as part of the guest vCPU init path?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

