Return-Path: <kvm+bounces-62889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC0A1C52E74
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 16:10:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C9C34A6971
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 14:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940BE346E69;
	Wed, 12 Nov 2025 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kVKNKr/Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D883451BF;
	Wed, 12 Nov 2025 14:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762958839; cv=none; b=Y3StawkXijKLZah5IGZild+c2xIxnzkEhSiHvr/0hBJoHzpMms6S+h4piS8gjTT7caanPEfoDL8HpYBq0B7XenJ9VbLKOeCWqS75VZFCZ+dFxUM0mRt++Hp7H0XaviNO3XcBAQRGuRGR+I12E7uXklpcVBGFsnVUf3a9XCLRrPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762958839; c=relaxed/simple;
	bh=bwaRCpeS2yq0SX8A03YWm7Qiu0T4KcudSNiRWid9EqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6NkIStxPbgm4rd6FaS16qAkuIoPRQ+hzFSBdr7UgkbHC74Ch/Y696ccewEEY+/GYL20q4Euztt80jUdi5hIKoBWp4yJCYhFJ3pcm1rfSv74U5XaiOXw2mhBQ9tTVFCbva66ysxQ1+JyPsDw0BfDw3IbSAO94bFNks41CZTSJQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kVKNKr/Q; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CEEE040E01CD;
	Wed, 12 Nov 2025 14:47:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id dlz27SUN9iJd; Wed, 12 Nov 2025 14:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1762958831; bh=qomM3QjE2XBe/IADVdUhX22UYlwaiV0sa0EWCUqdtGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kVKNKr/QMWyJ/zAJwgEi9oXv2YNpNJtggBhsVqu1CYeqwOmpdo7cyaUaLrt1MeWQf
	 NKlb0ygTnS+4qRNYiBLfH5D3J3vD//B2T2BWXYXI9C6sitQtIVQGQCLmuxgbcSaJ2O
	 SEmpfRkY3S/lMJP7cLtjxQnDBoDvR3EiMluUCMRActwjuIdaSRCEITiOVFOFKwosqM
	 1l0a8Ak3Yel8R2lO6/+yNyBIj5/STY9jvLjdxf10nJXfs5KVvMFfQ7lqiM3VrC7MJm
	 C8wKY5fx/RqNAPd9570nL+QrdXqefGlS96Y6N2F7F2jmsXXPjIw5DFWlhasVw/f2Ni
	 0caEn4UYHz1JopB4MJDJHbtsG9kRpJ59QLGLtiGSXACer2DktF+qXGlpR8LyiLsDYX
	 KojY/LZmLKcKgDKB2ELRYvWkQCl8Scy1bTeE74253/3grQgRZB1859QxccYBd6FcU6
	 CQ5/pvbZ9clv2DJVa6/tgleeerDBZK1Y1wADIZQLMnLbiwzUA1plP2BQD4TcPQBzTp
	 59w57yf0p2byDEhWRXmWnHW0OCHztPoOUfrcm7rREM8Ue5cfYfcwogq+oyZa1wlImH
	 62ouNb2k2Z8vLtc2510c/P8dMk5lw+QuwX9r07NMpJLgsH+LmO/X0yQXMEVUOrrD8n
	 yD5NCsDwPQ9DCPdiDRkzgeQ4=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id F055840E021B;
	Wed, 12 Nov 2025 14:47:01 +0000 (UTC)
Date: Wed, 12 Nov 2025 15:46:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 3/8] x86/bugs: Use an X86_FEATURE_xxx flag for the
 MMIO Stale Data mitigation
Message-ID: <20251112144655.GZaRSd32GC0lZdDOWg@fat_crate.local>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251031003040.3491385-4-seanjc@google.com>

On Thu, Oct 30, 2025 at 05:30:35PM -0700, Sean Christopherson wrote:
> Subject: Re: [PATCH v4 3/8] x86/bugs: Use an X86_FEATURE_xxx flag for the MMIO Stale Data mitigation

I'm guessing that "xxx" would turn into the proper name after we're done
bikeshedding.

> Convert the MMIO Stale Data mitigation flag from a static branch into an
> X86_FEATURE_xxx so that it can be used via ALTERNATIVE_2 in KVM.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/cpufeatures.h   |  1 +
>  arch/x86/include/asm/nospec-branch.h |  2 --
>  arch/x86/kernel/cpu/bugs.c           | 11 +----------
>  arch/x86/kvm/mmu/spte.c              |  2 +-
>  arch/x86/kvm/vmx/vmx.c               |  4 ++--
>  5 files changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 7129eb44adad..d1d7b5ec6425 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -501,6 +501,7 @@
>  #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
>  #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
>  #define X86_FEATURE_X2AVIC_EXT		(21*32+17) /* AMD SVM x2AVIC support for 4k vCPUs */
> +#define X86_FEATURE_CLEAR_CPU_BUF_MMIO	(21*32+18) /* Clear CPU buffers using VERW before VMRUN, iff the vCPU can access host MMIO*/
							   ^^^^^^^

Yes, you can break the line and format it properly. :-)

Also, this should be called then

X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO

as it is a VM-thing too.

Also, in my tree pile I have for bit 17

#define X86_FEATURE_SGX_EUPDATESVN      (21*32+17) /* Support for ENCLS[EUPDATESVN] instruction */

I see you have X86_FEATURE_X2AVIC_EXT there so we need to pay attention during
the merge window.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

