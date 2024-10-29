Return-Path: <kvm+bounces-29936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D6C39B45F1
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 10:47:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 223FE284C99
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 09:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A083220403E;
	Tue, 29 Oct 2024 09:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OABylL2l"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583091E0DEF;
	Tue, 29 Oct 2024 09:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730195268; cv=none; b=j+U1sFoNDFEZSMjrBncBhBPw/LbGoE9VBMpxkeuZH6hob0vJvwvS3cq1NJslxWkGHO/XH+nQYQjxteIr/1Sk9TWzsZl5Q4CwtV7pGRRBJDFLSvFJMeB8Du+fyOCbyHDOJBbdfhq9otgIeNY544ZkTDO8ljSsyEqwPCokQ+MwKw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730195268; c=relaxed/simple;
	bh=w84yovQX9VankTIfhozN2SGoYIbfrAMvtfWpdYyjIp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYlpoMJbUKFy441r2IZ5l+7uLfdxSuQSlVj97FYa566atto0NNIaYGB0bpLZxiPXB+5MiTlKGxshvICUxl00OsmNwSKHmyrn+dCGuKC0twZHN5U9v/sk5ayfpxagyEHDgn9+tBsLShaZjB4qoQkcCM5W2KNmJeB7F5DVf4zC1dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=OABylL2l; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id F211340E0191;
	Tue, 29 Oct 2024 09:47:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bvaIHUbMnzs4; Tue, 29 Oct 2024 09:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730195255; bh=Rd3LFr9gFzOX97cSATj3F//ifyUpWRBVYvK6Cv0Mprc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OABylL2lRGZyEngz4jucgLxPy0F78BO+yV+XpGgp3bcO3hrLLl7/Ead/YCcO9sK0H
	 br+bgdT2fCHyo3E6WWKfNhdwUPqCxmLMVWLMJSCFJlX6Mg3pTcw3sCdwltqyOmP0rc
	 ZIajAZdif5EkZANF80h2YidfLgPYyFumokdZtGsJI1QrXemwcsqXMp+RBeb5hEbumZ
	 +nsVmiEYPdvIMylcFFcMZl3dYJjqX1EjyFNNWf0OAI0634HbFKMMfWyK44IgiN/Uqr
	 /WRJ4KgCWwj6scKfbcYNXXrTUpesuunx+4ToPWg5ICRhq6folsx4r3LhSSeM1JUDyR
	 VnjAOA6hQutdPVR9cWngqOgX/uANJc+i5e8qin/6Mx86NPUnrPcdPhPmLQzR0+4/dY
	 T2QK7VLNKBLOy8vHw0u35Fjw/KopQKj0/LbmYPGUeo1Y6wz98t2gVVWqrNrFQFX2Oa
	 Uh8fRl6beh32ZRj6QJq5FLOvONjT3XpoZNXo/9jc2I8mJhN+ft0+Oft9jenl17tPoj
	 O+vETn1c+ZCY/EVFfDLp4LVcaHIGnQCLB30RKhtztUxFGZGWnZZ4gpe0hvXZLmz/T1
	 dzJHI8G8xlCHC/F/bd6hrYezeuwypzAr3qCstNnYlBhF2jqsI9xJQhmDjfDXzWLFK6
	 UCWv9lprMLj33FDlogtOcnQQ=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1327040E0263;
	Tue, 29 Oct 2024 09:47:17 +0000 (UTC)
Date: Tue, 29 Oct 2024 10:47:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: Re: [RFC 00/14] AMD: Add Secure AVIC Guest Support
Message-ID: <20241029094711.GAZyCvH-ZMHskXAwuv@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <vo2oavwp2p4gbenistkq2demqtorisv24zjq2jgotuw6i5i7oy@uq5k2wcg3j5z>
 <378fb9dd-dfb9-48aa-9304-18367a60af58@amd.com>
 <ramttkbttoyswpl7fkz25jwsxs4iuoqdogfllp57ltigmgb3vd@txz4azom56ej>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ramttkbttoyswpl7fkz25jwsxs4iuoqdogfllp57ltigmgb3vd@txz4azom56ej>

On Fri, Oct 18, 2024 at 10:54:21AM +0300, Kirill A. Shutemov wrote:
> I think it has to be addressed before it got merged. Or we will get a
> regression.

... or temporarily disable kexec when SAVIC is present.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

