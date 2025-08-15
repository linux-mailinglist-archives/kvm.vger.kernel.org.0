Return-Path: <kvm+bounces-54780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7027FB27E3B
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 12:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 526955E4C27
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 10:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BB482FE593;
	Fri, 15 Aug 2025 10:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="gvoJAsJJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717972FDC33;
	Fri, 15 Aug 2025 10:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755253583; cv=none; b=UROfcl1aj/hfeSTdCk9dF2acssi3Pnzvg1Gs0LsvFkYJC+BWrqZcnAWo7ijvkbQvkcBJQXMp3neAJpA5eqBP5em9Rpl63LOBlhNtjCbVohuNUP+oOPZYMiK1RcmtLsw2o/HDUHk4Npw+GGhsjPKZRClVgc+kCaotPQInN95JMKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755253583; c=relaxed/simple;
	bh=SuaeDpWJTY83s/+kzEFXcNK853ZafoHoZL6YPGr0/0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nl/zjpk5JZXGd13XTIM9LugJ2grAuJkNsfbF7BHe6fz3NPCqPyEy2n/b8ZiLAIhpISa66gMi45nBK7nPkbRy9VwkYF8teb4miv4+QsjWCa2AcLRTwVmDVaAot2mjYzxJxjGr0+AcN1aEPzVjCwQxhT4DDRMiGo7jcYwKY2+Jr38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=gvoJAsJJ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 19ACE40E00DC;
	Fri, 15 Aug 2025 10:26:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qIGAs6e7c6FH; Fri, 15 Aug 2025 10:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755253566; bh=MWXJjrKvX4HZfZr+iE2DCfAcLn7uRQ5dmuri5NVC/7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gvoJAsJJ1pQZD83pw16a3muaEmTdZTsrkuD3P0vJpRXSVsCs4PjVuRC3oal7E4bFQ
	 1fTg4gvd8oRSIdavBzCE8AokT6DP7Mh9c5Jyn9jZkZe4zJwH/kfNbUvEAylNezMEtP
	 p01uE3tFtxVt1d8oTOdIPzh7QBsurv+/NjUV4y75DguXRNTzdc8R61q8SpUVlvpTEb
	 CNNja9ud9X3bwhJi2UwvILefAKk/31tcrLrqbaqbCT6ydVHUSI5mZnUpOkQxLIhLxX
	 4HQzkKDh/f/Wuft4wzVDm7P28sJONfLW4E/SACMQDPeapd6t3FDkyFNmFJ4gVtByAK
	 OFeCSfHZ4A5/S3VngQviuhSnIllSe3SM7pUxM2sQgsR/CuocBBK6BVCmJkLrSh2y9f
	 k/vupuDnXOanWVjay5kbEyedmbNupBw+id//bTLds1mPategM3IFrxMggEb5z6/euq
	 2Gt8ZY2s5BbzS6aJrY9x7gHXE+TYwxTS1UpSPkhBgiG3rcsC54Kt2E6XwjZRxvS8go
	 31V/ARQY1NY0hYnCB24OAi9qRWvNrZ3u1/v3ixfxbEMIUB3J6cENQaeAR1g8EKeahD
	 KEfRJSEFdusHb9lVUBHXIhI1JkwFO2JzgCjuznu0ZcHuJPeu54zwOzFsp7dlCDU5Rt
	 wOoG8xb9ocH7IAjFEJGdG5Ag=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6165640E023D;
	Fri, 15 Aug 2025 10:25:44 +0000 (UTC)
Date: Fri, 15 Aug 2025 12:25:37 +0200
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
Subject: Re: [PATCH v9 02/18] x86/apic: Initialize Secure AVIC APIC backing
 page
Message-ID: <20250815102537.GCaJ8LIZodp1yY39QA@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-3-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811094444.203161-3-Neeraj.Upadhyay@amd.com>

On Mon, Aug 11, 2025 at 03:14:28PM +0530, Neeraj Upadhyay wrote:
> With Secure AVIC, the APIC backing page is owned and managed by guest.

Please use articles: "...and managed by the guest."

Check all your text pls.

> +enum es_result savic_register_gpa(u64 gpa)
> +{
> +	struct ghcb_state state;
> +	struct es_em_ctxt ctxt;
> +	enum es_result res;
> +	struct ghcb *ghcb;
> +
> +	guard(irqsave)();
> +
> +	ghcb = __sev_get_ghcb(&state);
> +	vc_ghcb_invalidate(ghcb);
> +
> +	ghcb_set_rax(ghcb, SVM_VMGEXIT_SAVIC_SELF_GPA);
> +	ghcb_set_rbx(ghcb, gpa);
> +	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SAVIC,
> +				  SVM_VMGEXIT_SAVIC_REGISTER_GPA, 0);
> +
> +	__sev_put_ghcb(&state);
> +
> +	return res;
> +}

I was gonna say put this into a new arch/x86/coco/sev/savic.c but ok, you're
adding only two functions.

> +struct secure_avic_page {
> +	u8 regs[PAGE_SIZE];
> +} __aligned(PAGE_SIZE);
> +
> +static struct secure_avic_page __percpu *secure_avic_page __ro_after_init;


static struct secure_avic_page __percpu *savic_page __ro_after_init;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

