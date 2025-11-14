Return-Path: <kvm+bounces-63235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD66C5E52E
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 17:48:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B79D64F1A33
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 16:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE5533555C;
	Fri, 14 Nov 2025 16:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="IbDmIahP"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B60A314D2E;
	Fri, 14 Nov 2025 16:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763138473; cv=none; b=CGWVagAHundaXaZhroQ5b8jP0VDUcgzhXzZu1x6KwifN/MnOyXUfmfnmpTrLxouIBs2gh246l1fI1eyfzVUUAApGLDiZzVjU19xf1bEh26ONGOKvFRIFnQ6fNMh/C1ZFxg9SZPIHdwHnQ4k3qv9EeIi70cixqr7M/lMbmZEGZFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763138473; c=relaxed/simple;
	bh=c77v2lreVHd8pT7KjMdH3CEH7CQsd+suRbc3fGPdpUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgvD6xf3xOW3VitxmCUkvM/yKaVwoo0ZhXhtrRs4wyjYUqsqMU90QQSehR1dgPjZ4CDIDn/7/wCKOb12vFwo6VgK0lGX2vnL7lHfP6QDniUZ+9Tjb+2/EP5rz3sdjczIh0w5V5KI2y092OkPrfB41ULstXZEsze4GOl56AXJ6PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=IbDmIahP; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 22CEF40E022F;
	Fri, 14 Nov 2025 16:41:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Sl3Ki4_HsH0x; Fri, 14 Nov 2025 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1763138455; bh=6STHzNly2lww8z9RJvHcPTI+uLTRLxHtfn3Q7w+Zwu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IbDmIahPUj0MksrVyuWS1lYxet4gREij22Ze4z/wlqPGkjQhTdpNy6t7gSuroIAcc
	 Zo4E4ULRpnyySgG1Leu9ZYoWpdE294tj1057lbXPQpiBZuoioz6nsFW1koF9PZlxQ6
	 OVdoG/l4kLL6yKpDxS0ufJvbEFSivSIY7rogXupAcJ2mMM+ObKX1FbCCWRhYDqH2qN
	 eK6HUQ4O/0hMWKhn2eglTAEKU66UE/kJ9Yv6k/BI+UX5rNnYtjDKvN4cK/VO1q1fom
	 z4Rurlj1uSsFNQiw6hfLtNOHClbgj/RZq6PU579Dpb2Ey8Q4p8bEIXiDU8dx10qtvl
	 4v77C3AOBdPKUnqc9/nAIsJk6jqIf+lfCl9XujGD1EHvSoieD/Rk9ZrO+2PduuYiXt
	 +UrXEkiDq9YETZtnkAFTGg36jXzflx4IBpCBN7t3b+QQqYkuqsedT8YyFnwk8nvweO
	 Ju6whImIav3nNseLeSNvsRfOqMqf+riY/O6aQ5FSwlt+k2XuHpyjRHlk/pA3fZgEmO
	 5+7gBba6emphirylf5Y8vl4OnC6+hxvW482gX2wVc0bv3X/c9YN2ha0FVwRfMr9dPq
	 h7qFfts8hRJxlOMpQkTmg65YLvUiAmmxeUw2Rrlpk/qCdqhmkOIn7PM41XKtLRXhf4
	 mzbHHPnVYPy8rQ+maurE6Vjg=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id BE8CE40E016E;
	Fri, 14 Nov 2025 16:40:45 +0000 (UTC)
Date: Fri, 14 Nov 2025 17:40:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v5 1/9] KVM: VMX: Use on-stack copy of @flags in
 __vmx_vcpu_run()
Message-ID: <20251114164038.GDaRdbhpoLbiq02vDu@fat_crate.local>
References: <20251113233746.1703361-1-seanjc@google.com>
 <20251113233746.1703361-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251113233746.1703361-2-seanjc@google.com>

On Thu, Nov 13, 2025 at 03:37:38PM -0800, Sean Christopherson wrote:
> Suggested-by: Borislav Petkov <bp@alien8.de>

Bah, I didn't suggest that - that's all your effort :)

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/run_flags.h | 10 +++-------
>  arch/x86/kvm/vmx/vmenter.S   | 13 ++++---------
>  2 files changed, 7 insertions(+), 16 deletions(-)

...

> @@ -173,8 +167,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	/* Clobbers EFLAGS.ZF */
>  	CLEAR_CPU_BUFFERS
>  
> -	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
> -	jnc .Lvmlaunch
> +	/* Check @flags to see if vmlaunch or vmresume is needed. */

VMRESUME/VMLAUNCH in caps, like the rest of the file. We like our x86 insns in
all caps. :)

> +	testl $VMX_RUN_VMRESUME, WORD_SIZE(%_ASM_SP)
> +	jz .Lvmlaunch
>  
>  	/*
>  	 * After a successful VMRESUME/VMLAUNCH, control flow "magically"
> -- 

But yeah, AFAIU this code, that's a nice cleanup.

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

