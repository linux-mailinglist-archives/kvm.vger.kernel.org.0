Return-Path: <kvm+bounces-42573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BAE2A7A21A
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:45:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C42A33B3778
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCFC724BC17;
	Thu,  3 Apr 2025 11:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Q3PZrBgN";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fvXfcmQe"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99009EAD7;
	Thu,  3 Apr 2025 11:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743680739; cv=none; b=i6adEqG+52a8SK/Df7qG9f0mE3rIDq2IgmJykD9sPg0JM54Z9g8TpfCBZy33l4qX1nS/lBRvg+U5FZLzlzEuUGljNALiXKlc8QeLMx6k8B1HaE0xBY7ljEUOrDF8CNBpJBmS98OYNq3c2wpk7iSwR+nDArzNEmirqzGup9DdoYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743680739; c=relaxed/simple;
	bh=F8vYjQ7pqAlWMomctD7e5fDvI6nmFvIPV/DvTTQWtN4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=imJmCS4yTttn6C3F1MuUZqP5GxlkI8e8SWtJ4stZnD6odBrR7RG8NdsNhaTXdyVAYK31pshgDDyVKH2A3XeJzS8CAStPJtMRbb7ucvZ99I5VoWKcYb6KK0ZbuwgkvVHOVMBg6Nzu7yyW6ky54wchJ/fq+Geta26zVC436GzexM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Q3PZrBgN; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fvXfcmQe; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1743680735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mes+eN7AREiOf/WQemPyHFwC3IiAGpqNnHV5kzLcAVA=;
	b=Q3PZrBgN4UALpvDDT4cJEJpe/bJjBfLeEcajftTjzj9b/0eEPKNlPU7thFN0IYh6qTe0/g
	k9DXGpCcb8s/nXbL+Oxrgl/oRicE/onkYC21bIz0oKz4f9dhPg6w/KPyrUgamDHFDR8It2
	/1B20ubVLqp9ltq4zxdY/PZNXV2M1NR2m9JBS/gEcmFLHm4IPtxBrID/AlM95n4hj2pkmy
	PfR0/qrKnFPCHYp3y9jU32NdWnCGmn9564LvreIEtcaKSb92GiCGs4axFUT2tTcd0f24pn
	Yl/H12X+D6CxbmkYi7TeazJD7LA0f9mFUUsMXV21Rg6UAb32CI9Ekz+MNT2A0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1743680735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mes+eN7AREiOf/WQemPyHFwC3IiAGpqNnHV5kzLcAVA=;
	b=fvXfcmQeHTyHf9BS6HLTi5c2SJxu9A0JexXAu1CWSYVCIUxD2J6L7E/Abw9hsxlKkM6Ej5
	8yQpMF5zfHp+qMDg==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v3 06/17] x86/apic: Add support to send IPI for Secure AVIC
In-Reply-To: <20250401113616.204203-7-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
 <20250401113616.204203-7-Neeraj.Upadhyay@amd.com>
Date: Thu, 03 Apr 2025 13:45:35 +0200
Message-ID: <87y0whv57k.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 01 2025 at 17:06, Neeraj Upadhyay wrote:
> --- a/arch/x86/kernel/apic/x2apic_savic.c
> +++ b/arch/x86/kernel/apic/x2apic_savic.c
> @@ -46,6 +46,25 @@ static __always_inline void set_reg(unsigned int offset, u32 val)
>  
>  #define SAVIC_ALLOWED_IRR	0x204
>  
> +static inline void update_vector(unsigned int cpu, unsigned int offset,
> +				 unsigned int vector, bool set)

Why aren't you placing that function right away there instead of adding
it first somewhere else and then shuffle it around?

> -static void __send_ipi_mask(const struct cpumask *mask, int vector, bool excl_self)
> +static void send_ipi_mask(const struct cpumask *mask, unsigned int vector, bool excl_self)
>  {
> -	unsigned long query_cpu;
> -	unsigned long this_cpu;
> +	unsigned int this_cpu;
> +	unsigned int cpu;

Again. Do it right in the first place and not later. Same for the
underscores of the function name.


