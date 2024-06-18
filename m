Return-Path: <kvm+bounces-19850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9C1D90C928
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 13:24:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91AEB1F21D11
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 11:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010F57172F;
	Tue, 18 Jun 2024 10:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="PG7bIPik"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628EE15B54B;
	Tue, 18 Jun 2024 10:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718705888; cv=none; b=nm7W2EY9NNiezYBqrYvoQO5gnRUTh4YYpXx7zXr5xvNs6bizReTQwuAMZw6iCYWGGqdNJbaUBEE+HVJ0vLuJKkCRAFymbRpimRtVlQZDiRt+e9s70IR93jL/xam72Mi9Z8pXdP6w7GJcWfrpcU7EEiJbWwJDK+MimG187xL8ZVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718705888; c=relaxed/simple;
	bh=gDy9EynZRoK5biH+tw1UOCYBkKB1G7CJM81nlDWD3DU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KI0xirhnco+jb50KuyX9Io/LISlQ4GG8jgjPLcmqkgQCorW2GCXVwZ25UCk/96DCjF4RZNSpYYQAYbbSeClW+CRG4ku4pocIZ42VwC6YEEJVteG03VoEPYW5HYLvfOrlijS+GmSBY1tM8MKGImdydkh8Xh2V3H5IFQ6M38LgzLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=PG7bIPik; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9B7E640E019D;
	Tue, 18 Jun 2024 10:17:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id FQq64omPlDhG; Tue, 18 Jun 2024 10:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1718705873; bh=wHWM0Qr9z5op45g9n4gyfPeLzMRg+8q7xecWmnDkKPQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PG7bIPikLKC74dlci09OuNm1N/Fw6OUSjXrzooLzdsYOIamEhXCJrbc0bQtep6pFm
	 XPqdZxgY9/77MZZMjy/8muhbte/KoukPpxe2FtCZ1VFAwv7pzI1PjVoyxv/V4Ekmdy
	 FFLIwPsn5gEW4XTPuTBoe3tVAUSFtD0t6guupVi4oAjTmhwC4oQcz0gWboqPtENOZX
	 YnGPnOkcKc1u7Kel2DjIoJd/zS0HbeICrxnvqlTbewixCwgywbyPLiJxHaWO2NdsrG
	 OHKJ3LTfEo7UsbR3bBZh7aMxoBG793PWAfp4S7gejrkLxvODT2Do/WqVmKUhBtMPqh
	 Cun5A/nolVm6WcMKveq5Hx4AhRMkgOIzsbfoilMzgLEm2YfhW0JllbevmjSfp8pVpc
	 5vL5eEqzvDx3uP/aELrRfOFYJ4ufMyvJhdKKF4NonPX0Mjfud6pTMadvUeZxQ9xDan
	 PpfGKj+njjZBTrTpYRS3nCZqQIGlxV6Fx+3qIDVCgQ/Sj0AU5zVoa/iS2j7kXr9xQf
	 7zQ/T2XOxGD7vDtC7EfU9nAoX2AT7Xy+tkYK26gAnfsasbM9eIv7DLuHQaHx9PLrlC
	 0pxSwnaoH/79lC8Dirvdj8Izyf5w5THCCePKjpPdyPx3srJ2dvi9yGAG4Uvtp2C7EI
	 EleRbIPxEDFT5hq1c0nL5Olw=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 784B940E01A5;
	Tue, 18 Jun 2024 10:17:49 +0000 (UTC)
Date: Tue, 18 Jun 2024 12:17:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: SVM: Force sev_es_host_save_area() to be
 inlined (for noinstr usage)
Message-ID: <20240618101743.GCZnFexxIaHkDsv_kG@fat_crate.local>
References: <20240617210432.1642542-1-seanjc@google.com>
 <20240617210432.1642542-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240617210432.1642542-2-seanjc@google.com>

On Mon, Jun 17, 2024 at 02:04:30PM -0700, Sean Christopherson wrote:
> Force sev_es_host_save_area() to be always inlined, as it's used in the
> low level VM-Enter/VM-Exit path, which is non-instrumentable.
> 
>   vmlinux.o: warning: objtool: svm_vcpu_enter_exit+0xb0: call to
>     sev_es_host_save_area() leaves .noinstr.text section
>   vmlinux.o: warning: objtool: svm_vcpu_enter_exit+0xbf: call to
>     sev_es_host_save_area.isra.0() leaves .noinstr.text section
> 
> Fixes: c92be2fd8edf ("KVM: SVM: Save/restore non-volatile GPRs in SEV-ES VMRUN via host save area")
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9ac6fca50cf3..0a36c82b316f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1504,7 +1504,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
>  	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
>  }
>  
> -static struct sev_es_save_area *sev_es_host_save_area(struct svm_cpu_data *sd)
> +static __always_inline struct sev_es_save_area *sev_es_host_save_area(struct svm_cpu_data *sd)
>  {
>  	return page_address(sd->save_area) + 0x400;
>  }
> -- 

Tested-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

