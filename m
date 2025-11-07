Return-Path: <kvm+bounces-62350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 14474C41619
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 20:06:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 54ABD4EB689
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 19:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD025287257;
	Fri,  7 Nov 2025 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="XmWfL3hV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87716239E88;
	Fri,  7 Nov 2025 19:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762542352; cv=none; b=f5DKK9x0GrYHFdD/tcYjD4y8SPsFIlIjR9ItdASwkUbcs/MGy1V9FSyclw9YEduzycD+UClpQBu6wS1/s36PvnPjYtI8ozCK0ZMtoSGcBtyMZbofF+w1mU5K4g8dYn8n0wneM0RFLjs1xeD2us3w3pEnHmkT/UW7xQdYPuLoI90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762542352; c=relaxed/simple;
	bh=mXFR1PhmKgmSVMFeCXXi28Wz72C3jBWODvB+di636gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5D/a7FErE3tMP/p5e37T3hs6lkpl5N48qz7R81lGHSwXI98V3WY0Vkg3D/xZFcYjLysQ+4CIsCDRRguadVT+WOLnh4aT0VRhfIW+m6ur/ycvMzeduZH2fgHmrtVzTama03hFwfMldr7iniZhgPGrjQPF03OUaT7QMxkYO0dqPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=XmWfL3hV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 47D2140E019D;
	Fri,  7 Nov 2025 19:05:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6kqq-evhot0V; Fri,  7 Nov 2025 19:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1762542344; bh=lujgfbqZ4qlRCiqTlaXxcoUU22N7BBwu48Sd8U8jwCc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XmWfL3hVNM+7GgDM7O4LUM10o5oZxOwNMcMYFdL70WGMKfQrcKGEaZLgGZjZP7Jwk
	 v0cdEL+w1ykgG7nAn0zAh3g+P6ip0qJZkT/cqu8OGsLyaOH5ruBD8ymHemYR6P7QmQ
	 i1zaGx5Ps5mlRtYja4PZQc69fGAGVCuiMnwwBTlMX2mfLsqXdX9RJmUprU0VIZmInq
	 3KNcX+Imb8dGzwlYxflOd9Elt12TAgJyRBZgj5OhZuev519s/KkX7wvYog/1GkonUh
	 hZk9DP+F3Amxyc7q6h7NBUwIFVLnTaaLg1JfDKqdegNDa0Kgprs5c1bs1oFLsgKqzn
	 6QUa1hH5wT1Zs2oI6IWb4shqWcvnbCJ9uwrLuF3LG4oIildrK/OdWTO8mOEDaQwp7m
	 GamvI5na+K+2MRJSxhZfmtTAHxrP2F3+PGEHpRET+g6Wg6JxtSpWA309a08i7wBBjD
	 2lrigkC5WwwYJS8CCfIjNSu2e5rnc7fcwDfar1PckSeNhr3FH+hWUQJ6VpmOslyjMc
	 I5+cGfYsJArRmpnIWaouL+f3nr0tAPIBRN52Jlez4EPmwpCV/678TT/41tjQ8FEzOW
	 fX+V5y/SqamrXJm0pH67AE/jK4qH7/TOJbPvJtneREzk+egzTvfwX5SrwXQPJ08MM6
	 kylKx3g3vKhgouhhMyfnea4w=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 90F9B40E0191;
	Fri,  7 Nov 2025 19:05:35 +0000 (UTC)
Date: Fri, 7 Nov 2025 20:05:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 1/8] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
Message-ID: <20251107190534.GTaQ5C_l_UsZmQR1ph@fat_crate.local>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-2-seanjc@google.com>
 <20251103181840.kx3egw5fwgzpksu4@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251103181840.kx3egw5fwgzpksu4@desk>

On Mon, Nov 03, 2025 at 10:18:40AM -0800, Pawan Gupta wrote:
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 08ed5a2e46a5..2be9be782013 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -321,9 +321,11 @@
>  #endif
>  .endm
>  
> +/* Primarily used in exit-to-userspace path */

What does "primarily" mean here?

$ git grep -w CLEAR_CPU_BUFFERS

says *only* the kernel->user vector.

>  #define CLEAR_CPU_BUFFERS \
>  	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF
>  
> +/* For use in KVM */

That's why the "VM_" prefix is there.

The comments in arch/x86/include/asm/cpufeatures.h actually already explain
that, you could make them more explicit but let's not sprinkle comments
willy-nilly.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

