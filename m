Return-Path: <kvm+bounces-50305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B045EAE3E80
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F08816F7DB
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 11:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32F024169A;
	Mon, 23 Jun 2025 11:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="XqXhwRmT"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC10223774;
	Mon, 23 Jun 2025 11:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750679381; cv=none; b=S/Sa1lgW3NGNq/83bEFjX54+GuNz0MZEk+fk+MoGXnsTPHF4i5VL4JvPcxqk47QIM1JbykkmFvBzFWPXifAKyFdGVl4kNSDjsUECJTX7bmIGypht45zrq0UlLbI79+iX7dF/KPQqraAzTd/Mt12hSJG0oh8WJl7MfwkjEfWRRIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750679381; c=relaxed/simple;
	bh=m+Qd1Cb/X0RC7mbPvOpJ0Mdpw8OSC6q2uYPyT+xzuVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D63dq0RAIGxH4OV3wzhDtknej3KI+KRR2eMBp6u1LLZJQ6gWVtBpJxCbWFRSuuu62ECQ7Jxkoaf4UDHysSbWwH0UnxekDLm9UW0eTMBKedJPPNz4NUOvVqFALFN6hdz1bJ0CgJYUbWebYGWqy8o0ZJWnrSy57XC++p9RAp5MJnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=XqXhwRmT; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 407A840E019C;
	Mon, 23 Jun 2025 11:49:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 9WEx8yNFNSCU; Mon, 23 Jun 2025 11:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1750679373; bh=kfvlOPZPYOqpJCisMXBomvYik2rz2a87LAMAgti+Ebo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqXhwRmTnHrn17Yqo8ZTokhxjs5+ZHrhkWBnWUoMHAAXmmQEUfTM8s2vjsSpkRAZp
	 cpCmf5odvPe5tsUZLwddIokSqQMBm4BpPFTAdRVIPe4/KR8hCQRR8bI04qvKMa6tpP
	 b7hDIRymYp1+t+aMxK9JO377/5BS9V6kaAkZ/8gt3J+sO45q49q6NgxUa5MymZ3W1d
	 IRal9cqx+qZM4FR81BLq0X7Gi70k740XfB3ld7l/YX3WoCygflfyMMaoPbTId2KOoq
	 B2C7KT86qWLBc/3j0BCC7xufPfbEo3z3WHwxez6e8TuWt2FZUcB+WKCQHQdcqoKDiK
	 FFh8L3WfG0OwCv9TURuZgagSAx7q/nAk+XO1PnbP3g7+a/KxanadIW6IV177CUqVR2
	 L4QuPlC6NJx357/lvIRi2D4Sl582bhV+4GCcbRUkx7v20C02jO3V4UA+7uM0MdQ+Aw
	 5v0ZPrLBtkwH212401e4c5S17V5wTvAxBYKYFuOrIEQ90tYZuPgRVbmWjonM4s6YHK
	 ow6UO3aJOMwNid1BXet9/MuSUkbhF17KS4qTDmIlb5klI7t/qsCn94WS+gREqmTI60
	 py4LAC0PRWn02hMgznoXMTz1wKu8V8REvLn94ib9t08hs+sC3KpZwbQJ0yNM5gDYQA
	 R9e+tnF/y1/4U8r6DHsM+Btk=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 953BC40E00CE;
	Mon, 23 Jun 2025 11:49:11 +0000 (UTC)
Date: Mon, 23 Jun 2025 13:49:10 +0200
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
Subject: Re: [RFC PATCH v7 03/37] x86/apic: KVM: Deduplicate APIC vector =>
 register+bit math
Message-ID: <20250623114910.GGaFk_NqzGmR81fG8f@fat_crate.local>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
 <20250610175424.209796-4-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250610175424.209796-4-Neeraj.Upadhyay@amd.com>

On Tue, Jun 10, 2025 at 11:23:50PM +0530, Neeraj Upadhyay wrote:
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 23d86c9750b9..c84d4e86fe4e 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -488,11 +488,14 @@ static inline void apic_setup_apic_calls(void) { }
>  
>  extern void apic_ack_irq(struct irq_data *data);
>  
> +#define APIC_VECTOR_TO_BIT_NUMBER(v) ((unsigned int)(v) % 32)
> +#define APIC_VECTOR_TO_REG_OFFSET(v) ((unsigned int)(v) / 32 * 0x10)

Dunno - I'd probably shorten those macro names:

APIC_VEC_TO_BITNUM()
APIC_VEC_TO_REGOFF()

because this way of shortening those words is very common and is still very
readable, even if not fully written out...

LGTM regardless.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

