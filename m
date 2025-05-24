Return-Path: <kvm+bounces-47656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBD57AC2FAE
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 14:13:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B91929E5007
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 12:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 135E31E5218;
	Sat, 24 May 2025 12:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="J8aoAztF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54EA2744D;
	Sat, 24 May 2025 12:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748088801; cv=none; b=rdk159OepW9r9wcXDjeKZ0qzWURQgS3SCqn2AbidvVGSMnxkMkiNYcGMDEMDoA3V4tPc8W0GGCPv8LriIFKemROEOKrBcREJ+ghxSl/pLl4PfsFvtWoUH0G9tmI4vLUtZpYnRFGtfwCY2t8u+56xW1fvTTLI2FPHyt9Q/RfmkBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748088801; c=relaxed/simple;
	bh=/Il4/ysOexZBrcONrJ3Jjm1DGmZgOmJ7/HOesP15zac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIRYavNl1Ty/RhXSpKTMY3sTC2a+s8Gb3jmNYP4y0VZN2K4xvQq2iMpZZXAEGeZZRrLX/wFlvufYUOVdN6K+pyp14bzpMPzqK0ojT1Imup+8dWE7mN2gCPyDGWGVaZLGloXvO7uyECZVw4vLT0+q1JhwZ5lYFFwU3rn84K53ADw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=J8aoAztF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6484440E0238;
	Sat, 24 May 2025 12:13:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id J0UUjnVWcI0a; Sat, 24 May 2025 12:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1748088791; bh=i5jzlN9kOMMW5iYxcC8RI5s3TLYz+RAqWBa4RmwqDqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J8aoAztFr7Lwl1F3u8eOnOEU1niJH+u12xVHPSgNvswEbejYe0ors3gqqYfKOANba
	 xESNcdtsIKyaql4wxUzn5bmFDpkynyouNz1pXbV3n6faLW7nfmgTY/cd0m0Tn85y/K
	 xaqWglio6n993YCeR56c/WLb9C3mPrkN37kiD/H9KuENRRNakK+46HfV5SVPLum6ZV
	 Mvoj4qh3MY5KMSTsgXk4w0jKk2AX3B8L+WsvQNvteB8S46TTPFrQ22+Xs70mttbAiv
	 Aa16U7nrz0dyezMX1uudqFKcj6eDnJaPCQs3XQVYbROmcuJWOSc8fi741To2A/5GFa
	 ONayCY3SbFFtv1RX0/keulVhumzWzBRqC84QzDd+DXtoZTaum69z5bKcNO/NYnUY2z
	 0SYq0JuRyRTGmfuGmG8i1ofxMnOIWksZlOQ/DcKDHuNBXt0qG2vLnj/PpTkNB0j+Nl
	 vZKhnPUozubm9bRWtHXctsvlPs3yK6SkFJ/DML+V0ntCzUmGhoc9lvFLRCqWkFX2hm
	 WbyN1hITpytziMPbgfb++nDzvfTaU2OAr0Zof51EEaavbvCOOzhpRf9Zu3wbGHO10x
	 JgzDCfnx2WaXBHGmKLiEQvHXjq5xWskN8crhhzrZD5TNXxoism9nvsFF2nvc0/0n4y
	 pFUqL2kc+EFxA6nd8L0Lrl0E=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7475640E0192;
	Sat, 24 May 2025 12:12:49 +0000 (UTC)
Date: Sat, 24 May 2025 14:12:41 +0200
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
Subject: Re: [RFC PATCH v6 07/32] KVM: x86: apic_test_vector() to common code
Message-ID: <20250524121241.GKaDG3uWICZGPubp-k@fat_crate.local>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
 <20250514071803.209166-8-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250514071803.209166-8-Neeraj.Upadhyay@amd.com>

On Wed, May 14, 2025 at 12:47:38PM +0530, Neeraj Upadhyay wrote:
> Move apic_test_vector() to apic.h in order to reuse it in the
> Secure AVIC guest APIC driver in later patches to test vector
> state in the APIC backing page.
> 
> No function changes intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v5:
> 
>  - New change.
> 
>  arch/x86/include/asm/apic.h | 5 +++++
>  arch/x86/kvm/lapic.c        | 5 -----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index ef5b1be5eeab..d7377615d93a 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -557,6 +557,11 @@ static inline void apic_set_vector(int vec, void *bitmap)
>  	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
>  }
>  
> +static inline int apic_test_vector(int vec, void *bitmap)
> +{
> +	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
> +}
> +
>  /*
>   * Warm reset vector position:
>   */
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 25fd4ad72554..8ecc3e960121 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -96,11 +96,6 @@ static __always_inline void kvm_lapic_set_reg64(struct kvm_lapic *apic,
>  	apic_set_reg64(apic->regs, reg, val);
>  }
>  
> -static inline int apic_test_vector(int vec, void *bitmap)
> -{
> -	return test_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> -}
> -
>  bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> -- 

The previous patch is moving those *_POS() macros to arch/x86/kvm/lapic.c, now
this patch is doing rename-during-move to the new macros.

Why can't you simply do the purely mechanical moves first and then do the
renames? Didn't I explain it the last time? Or is it still unclear?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

