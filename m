Return-Path: <kvm+bounces-62899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CFEA6C53A83
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:24:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EE1BC54158F
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 16:42:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E2133E368;
	Wed, 12 Nov 2025 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="YVflLx5u"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6552D130B;
	Wed, 12 Nov 2025 16:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762965730; cv=none; b=HbnSRM7nTdly5XItZR0+mVnj+FWcS/VP4+kQxBQadn4jc4jCXEzj50Nm60DtSWKC8VUFtkZftwhF/bp+lOzNfuQ4k4NwFKh8m7XsTphQOLvrB3wfaia4ENUwIFXIs1764zsTCo2Xe3NdWt3Hlb30sacgBW+fDX//err61V+fs3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762965730; c=relaxed/simple;
	bh=brfumpB1KjtZ0tUjUYidieOKFPOMGTQ3pQPql8DRWmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GbMhQJsFb8oRVEZe4cuewlnKXBWSddf75/i1SfWWAMLoByd9043s1mDvZheFfUNu2AzSBLpAoqZhfpZBcKqTwNZo7//QF7H2YFhgz4F1V1rFy4CGx2TlCDEo7biY7l6DYxgqigIE0xjC2aKmLrpZEWjmNvvha/JSaaTM1cXbiQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=YVflLx5u; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3C0BC40E021A;
	Wed, 12 Nov 2025 16:42:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mkZIj2Z67Xik; Wed, 12 Nov 2025 16:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1762965720; bh=H8fRy6CI1BAGBCKXWP6X0lxiw1OBfzCJ+bndBBtYOlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YVflLx5uUbPoetXq3ohWhwyFBO14QTqiMcu1aA2NVNerXvN+EztQOA/LmJgWTsaot
	 tQeOW+4lF1+6hkLMFgVwtAIQ1XHJvCupXPjLo3PWzhKnsb/qbo/qOUJqIqFVpECS2J
	 1LGgK/GBf7m13rUsjRF9+IyMzCGdYcQiGUFMLiujsQB9G3AgZHpPI56XWcDTWFwLX4
	 zmgv9oIjf3AE7WsbAPfBaX196OJtwWnTVKTn9iuK7HD5040W5Z+QlybaJIDdrZbL4s
	 CsEkg6saAHLhwGkRRpdhI0PPDVHG9hRYLbTCzaCyadGuKZ2EE/kxW1FQVYdvYsVFcg
	 uN4muSsByls/rhP1/X9lDHXRITzg63Hf1oozWUUuaKq/BBEg2mDY7JStj0eepCat6x
	 lb19XkemtaonygVt/GE02GxWHMHM9Tkr/YmjfJ5+U3hiI6SYkOpEGYfkHJan8PZ2XA
	 SmJ/Gzy7Ecjn2TEm2uJB9tH8enEx6lwwK1Mp63qoYu6HMjWsf6XZpA3U1Uwxb1Pegh
	 xQDsHA2S6/Gql5NloFt2ROtKrJHdkJfireVfH1dQKapcRqc4tdWOcDP8g7eu/bhPhh
	 Eu5ubqJVkyp1/KEYgO1BSmLFBluhgo8ld53ERP/Qkt5/m+WZ6eovucOqz2tKEHS5oU
	 1d5JHe5AUzY3RsE4ylGaWInI=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 2CEBD40E00DA;
	Wed, 12 Nov 2025 16:41:51 +0000 (UTC)
Date: Wed, 12 Nov 2025 17:41:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
Message-ID: <20251112164144.GAaRS4yKgF0gQrLSnR@fat_crate.local>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251031003040.3491385-5-seanjc@google.com>

On Thu, Oct 30, 2025 at 05:30:36PM -0700, Sean Christopherson wrote:
> @@ -137,6 +138,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	/* Load @regs to RAX. */
>  	mov (%_ASM_SP), %_ASM_AX
>  
> +	/* Stash "clear for MMIO" in EFLAGS.ZF (used below). */

Oh wow. Alternatives interdependence. What can go wrong. :)

> +	ALTERNATIVE_2 "",								\
> +		      __stringify(test $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, %ebx), 	\

So this VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO bit gets set here:

        if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_MMIO) &&
            kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
                flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;

So how static and/or dynamic is this?

IOW, can you stick this into a simple variable which is unconditionally
updated and you can use it in X86_FEATURE_CLEAR_CPU_BUF_MMIO case and
otherwise it simply remains unused?

Because then you get rid of that yuckiness.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

