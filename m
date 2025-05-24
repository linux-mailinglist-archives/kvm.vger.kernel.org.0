Return-Path: <kvm+bounces-47658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 047BDAC2FB2
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 14:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDC78A21937
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 12:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59501A0B0E;
	Sat, 24 May 2025 12:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ei3fvW3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9488964D;
	Sat, 24 May 2025 12:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748088967; cv=none; b=RGQODZ+61aJwGPaGob4+RxHNeEp8g2IQMPUHnBhOWPrE9DAYjIOtlJlxqBubKY98VOYhZ2bQTI2dMbZOWyFEXhrAgVdR3gVfJ71bW6hFku2tH1WIRdzax6brZJIVBS+LARGxI576Xi8B1lksdvKxFRj/52SmpQM/+vlj8o3oOBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748088967; c=relaxed/simple;
	bh=4ZNTnv+X7aLB9eh6U9G1II3rkSEXnfaarUYE/GfJY70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ibjLoNb0IwP9Q0/rP9ikAVLRw2GpwGETpN72EznFcmTRs89JdyBuxSlgAyt6Ku9rP1Y0HKPvj+ZrDNrpVM4Km2HyPkkhFuQV2MNyO44yvvByZKpXzQ0ffle+n5Z/l99MDDcJzjSgOyFtZZcBt1FDk7YcQ34sg6dc4+yAyNdE3j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ei3fvW3Y; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A89E940E0192;
	Sat, 24 May 2025 12:16:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MYDVwJK-B1LQ; Sat, 24 May 2025 12:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1748088960; bh=G04Bsu13NY7VxO/c0Bho72SUtXBpCGutnQt1yuNIxsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ei3fvW3YMoyy7LoosELZ9OYefkHk9AHqN/PAEIskaKnMkCn8SWnXTseEQxn4s6Gmz
	 Ybi914HCFcj1P/I2uoOqF4eQbcODncF+5qfzzTS1ey16sPI8V3xyECQ+A4tDSl+2ST
	 9Lj6q/jepOYhUxqIo8cDH5DqQGrDvpYJBiGIuznScs1nBsi2+/vCAzUzspqlUc7iH1
	 u1Qxh9FQ3qcqN3gaHVBGEwNa8xkHScbBzDPDgjgox3CzO5A+IdWogBwWlT8oB2A1Yx
	 iw8p4YgoGo8PgMeoUoi2V0jdHiR9TD3kDwOJbFKON4/pjzUfyZlcvuFfvm2pgTWvA1
	 HzseszgOUyzyhEUFVo6nDBqArV8yCYG3Kf3i77XoCxCIocczZKcwhwmOJ1XmErmquG
	 4gGfb22SOKscA5mxLgLiORKHEnBb+UT5csKp8wmXHfX2qAOSNMANO8sjoHThwSlrAC
	 F/SWb48PRg1ZHhgtE5/GUCKkUeccLDz9pSrRR/VWrcZ0I+faLOGjUPyzD8pVdFCQVc
	 Pi7r8KblSQaWwhY50hR0rsLninHlCnywRZvY2LXd0SnyDZpu2Ce9a1pgJjRBiCZr43
	 0nMSrctiH9s9QRUgruGEmf1mRZt0JJVnjSYTQhFG5gRpdv7yZA4crv6IaNDb65Txgb
	 I3yFd0kwp+kazwnS6myWO0Us=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2C1FC40E0266;
	Sat, 24 May 2025 12:15:38 +0000 (UTC)
Date: Sat, 24 May 2025 14:15:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [RFC PATCH v6 10/32] x86/apic: Change apic_*_vector() vector
 param to unsigned
Message-ID: <20250524121537.GMaDG4adGsxaPFT7DX@fat_crate.local>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
 <20250514071803.209166-11-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250514071803.209166-11-Neeraj.Upadhyay@amd.com>

On Wed, May 14, 2025 at 12:47:41PM +0530, Neeraj Upadhyay wrote:
> Change vector parameter of apic_{set|clear|test}_vector to
> unsigned int to optimize code generation for modulo operation.
> 
> On gcc-14.2, code generation for below C statement is given
> after it.
> 
> long nr = APIC_VECTOR_TO_BIT_NUMBER(vec);
> 
> * Without change:
> 
>  mov    eax,edi
>  sar    eax,0x1f
>  shr    eax,0x1b
>  add    edi,eax
>  and    edi,0x1f
>  sub    edi,eax
>  movsxd rdi,edi
>  mov    QWORD PTR [rsp-0x8],rdi
> 
> * With change:
> 
>  and    edi,0x1f
>  mov    QWORD PTR [rsp-0x8],rdi

AT&T assembly please.

This change needs to go first too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

