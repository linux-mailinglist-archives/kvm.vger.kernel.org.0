Return-Path: <kvm+bounces-5879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB875828634
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 13:45:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A7ED286D92
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 12:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E91838DCD;
	Tue,  9 Jan 2024 12:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="P3vWCRHo"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3206381C3;
	Tue,  9 Jan 2024 12:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C5EDB40E01B2;
	Tue,  9 Jan 2024 12:45:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8JN_jPoAT9UY; Tue,  9 Jan 2024 12:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704804322; bh=l6b0BVWYus0PqvwNEk2f7GpDUFZb2PXSAO/GejNElUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P3vWCRHonjL26YO014HkDzmHfhlyWvUpkuqIEPLXmV5eJ6Q4HswyJIiLdCq75I/tc
	 Y7Lqd6l5lCkjB1JZRE4EF7T8eyRhELDXngGcqWwMI/3mQZpI50KOA0Gmjvo+69HuS8
	 n6TZ95AZFoyCuQW9z8vz8SPac5eetbfupizS08/01RM4MPNyNkXsge5GtptNLRHrq4
	 8aS72rGot0EIdY8gRNmoujNrFPgrg8SKJs/SKuT/Vpo6n6qAOtL0ccrAvx6y8xMDvG
	 dmqSGzlx7F6yOD3YqtjplBih06OELzh1ouH6b32/zyPV4ZV/rDq5hm3y/ili1YRrfm
	 LB3ULJANtMn33Ocx3ZP8oyp0ONqAgvUjXcw/E4hX6UnZr9hTrrO9iff5N89D3ltHLR
	 JCEXwEDP1mRsoi9kCKG5DK1CswarhfyY5jdBTZQejQgd5eisdRaOQLYPEu6O/ouEaf
	 zZ3esY5AxUJZQeR35pBzbCUj31lahwt+PHpqJp9eVgjywOTA2ngPbKuPdgaFwqwKIb
	 68ngs77We4wQiFOCjSQr/w2Se3FUxh9rxbfMAV01fYUUqS3JXb4WQEtScEkZtx2dF0
	 H6nyFxBskt06YADAQ2otuQ68m+yCRo4zpo/KnTsFgjhSyy/p3wTaDebIwcr7o3Kr7/
	 yxAy0oTE3aG+3thy44+MQJSM=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 05E5540E01B0;
	Tue,  9 Jan 2024 12:44:44 +0000 (UTC)
Date: Tue, 9 Jan 2024 13:44:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
	ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com,
	"liam.merwick@oracle.com Brijesh Singh" <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20240109124440.GDZZ0/uDY9RRPIOxOB@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-5-michael.roth@amd.com>
 <f60c5fe0-9909-468d-8160-34d5bae39305@linux.microsoft.com>
 <20240105160916.GDZZgprE8T6xbbHJ9E@fat_crate.local>
 <20240105162142.GEZZgslgQCQYI7twat@fat_crate.local>
 <0c4aac73-10d8-4e47-b6a8-f0c180ba1900@linux.microsoft.com>
 <20240108170418.GDZZwrEiIaGuMpV0B0@fat_crate.local>
 <b5b57b60-1573-44f4-8161-e2249eb6f9b6@linux.microsoft.com>
 <20240109122906.GCZZ08Esh86vhGwVx1@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240109122906.GCZZ08Esh86vhGwVx1@fat_crate.local>

On Tue, Jan 09, 2024 at 01:29:06PM +0100, Borislav Petkov wrote:
> At least three issues I see with that:
> 
> - the allocation can fail so it is a lot more convenient when the
>   firmware prepares it
> 
> - the RMP_BASE and RMP_END writes need to be verified they actially did
>   set up the RMP range because if they haven't, you might as well
>   throw SNP security out of the window. In general, letting the kernel
>   do the RMP allocation needs to be verified very very thoroughly.
> 
> - a future feature might make this more complicated

- What do you do if you boot on a system which has the RMP already
  allocated in the BIOS?

- How do you detect that it is the L1 kernel that must allocate the RMP?

- Why can't you use the BIOS allocated RMP in your scenario too instead
  of the L1 kernel allocating it?

- ...

I might think of more.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

