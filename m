Return-Path: <kvm+bounces-47657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3000AC2FB0
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 14:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19159A21937
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 12:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9371E5219;
	Sat, 24 May 2025 12:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Q18JpVPa"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0BF1487C3;
	Sat, 24 May 2025 12:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748088895; cv=none; b=WZGY/O0BGmv8w89e2fKzGEAuqTkX9Q4wS+hSuDokNJ/uoxaVtljMUjdLfN0aFPvUzN1Mp4Tpt1bjSBea2KkVBNdNid8cu86SKbeWg7TmXqlEHOxF//hXfRdvSfVEeI8duaPe+YDjw/a/40o5+nFw5d7w5siahx1mN7xDg8kxumk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748088895; c=relaxed/simple;
	bh=4whVl0z2Ad7XRfDwAyiAEfeNQuHy0HAzymD8hPCXlkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sijN5SLsZWi+pmWAO+0fUYTy7bqHoWcTNFVkYc26ts+dCL7dyuPo83VPnPqPfEcTBCokfU/RQoCZTvHStx+jI5WO3XfwL5pr+UIu6JH1RCiljahjXO5NIZmSpQqme9d6offmWE6IDFrM+OGw87yJ61Mgp36ZisEv+aIAoj9ekw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Q18JpVPa; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E001740E0241;
	Sat, 24 May 2025 12:14:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id eOyrbSqdcFV4; Sat, 24 May 2025 12:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1748088886; bh=AUFbiQsSpZZvYTtkasoFK0TgyFER+wnqGtzAj4dHeGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q18JpVPa9tEwG2HxoLyoOQizs8tDI1AliG0fISHlkHxJGiUs/01atlBtyhD98OFMu
	 BMVere0QFt7vo7PWGLWvSNYkw9uezUBDLFNMdTe4WaXFcsIZ4HS2IU9noftEyXDJ1n
	 49FWoluSlf/U8dygVpprr4OEsjAdMEbtMhljIzJxDjyJfW6Q8VNCZ4r8h7NX/OOJ0I
	 R2JOYAGcwTVM4N5WmtQYgAfgXWPHb16hr1A9z0GajT/G78/byruUf75Dfgg07yUYvE
	 A0OeefBaWPuqIjhzUzHyJnL6Iq9OlFjv0WYYxXZr1WjW9XKUbjfJV2MfV10U0rW3UW
	 IBXmZ3brEk4Mhx+d+WKkfhwakqaBeD+Q1KMKhWv4mGnSF5E+/VHsXjbfFkPMuxqVlc
	 L1EODp2icYD1kGm3wGjkk4V0nhzhxLE1YjFvScJen0zVpeUL97Ra4xFsfKK2zUtbRY
	 bjiXJIyN7KBAOuXwyhTLRl2hPDlbKvr/pExsblDoxsmp32uGlSVNr83JmMEMk2TQBp
	 IhAS8dU2QflpG0rnC+KJNFzmCTj19UdAMYe4JknsxQ7OOlepVtpzp8HgNGvulGC25s
	 NxUXUCV2JruXmoyo/fUOwlAYQ1rTEz16cBL6dHvQ6kjGSDByhh6tjqdCRxUzhOhUh6
	 7IPd9dBLUngOtQszPAtx5jBI=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8912540E0264;
	Sat, 24 May 2025 12:14:24 +0000 (UTC)
Date: Sat, 24 May 2025 14:14:23 +0200
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
Subject: Re: [RFC PATCH v6 08/32] x86/apic: Remove redundant parentheses
 around 'bitmap'
Message-ID: <20250524121423.GLaDG4H7R2-QVygIXa@fat_crate.local>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
 <20250514071803.209166-9-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250514071803.209166-9-Neeraj.Upadhyay@amd.com>

On Wed, May 14, 2025 at 12:47:39PM +0530, Neeraj Upadhyay wrote:
> When doing pointer arithmetic in apic_{clear|set|test}_vector(),
> remove the unnecessary parentheses surrounding the 'bitmap'
> parameter.
> 
> No functional changes intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v5:
> 
>  - New change.
> 
>  arch/x86/include/asm/apic.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index d7377615d93a..fb0efd297066 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -549,17 +549,17 @@ static __always_inline void apic_set_reg64(char *regs, int reg, u64 val)
>  
>  static inline void apic_clear_vector(int vec, void *bitmap)
>  {
> -	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
> +	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
>  }
>  
>  static inline void apic_set_vector(int vec, void *bitmap)
>  {
> -	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
> +	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
>  }
>  
>  static inline int apic_test_vector(int vec, void *bitmap)
>  {
> -	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
> +	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
>  }
>  
>  /*
> -- 

This change needs to go first so that it gets picked up first since it is
a cleanup.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

