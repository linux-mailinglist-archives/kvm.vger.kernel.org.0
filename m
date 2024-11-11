Return-Path: <kvm+bounces-31494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ECC19C422D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:54:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BEC9FB21BC4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 15:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6211A00D1;
	Mon, 11 Nov 2024 15:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="B9Mo9I5D"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04671C01;
	Mon, 11 Nov 2024 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731340467; cv=none; b=Q/Dit/riMsThfCohDxGPDyMQ4FU0junRHQCUYcRyON1DizRHb0U+BIY5GCiDSCvF45f6EJLosoe5T8heg9orw63R9ERUUiU1qt83P4H80k/hYpit7GW/hgwBE1zhV9QHzLCECWaBNEY673QHU++WCBXRLlVIIDRFNE1FldYBelw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731340467; c=relaxed/simple;
	bh=wysr5AwwiTfiWK64PEhZjim4vDpBx6901NvP59LDUA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E+p6NOSWfCGAXlCnE1z7LEMhyJR3vFoj451t9Uedy5U+qoGKrNvW+WTHCJQVnQZjuRQjcfXNhVyRdeY9cBw5d7sPSH63lEcY8q1RE4E/bhU8EloTWI9fmVh1HJ7IKn78zPf6gd1mVL0Hdm/Igu2BHfd/UNVn/ctCSTuzPccQOvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=B9Mo9I5D; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 75B5740E019C;
	Mon, 11 Nov 2024 15:54:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 7IeQxAi75JdE; Mon, 11 Nov 2024 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731340453; bh=nR7DDU6Sexlx9q00aYvBzcu9DyU8yGh9kLU0QnplID4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B9Mo9I5D4cIEbwZJYws3iTx19U+XGekZEkesuJfhKzS1Yqm0sqgQc9DDMJiv6BT/+
	 Zs30A+wA70hNG1V0nmBX9yUkd625gnb68ZXNDRSZYHuKLZCnwZIIzam20m06cL1MfF
	 CGrPnNY//sRTdcLYSVySdzBQiLNy65OQLfsf28MSsy5jjfciUljwQhh4os2ccMMq9Y
	 IjciPj8cFn3rr5pme5H6SzZ6a/Dzc0Nqojk8DKAFhq5yQtVAS2Dz954WenSz7ZPTN6
	 44QdE9j3KUusvSp+0K8PrESv1HQPzwqMFhSxdVMmD1Y9NBfbH2LGw0mC2pjQOV6sfK
	 c3HSyIAAH2PJ8MokhweL/DxUl2mN+edwsistGLp2eJSnY3f3+bRUsABPD9bfbyP6tc
	 x3nHIrS/m2uhu1PMma7uuykbIbTxFTbPPioV+16WqYGQDNW4L0zUAMDfCmxkAbAU8W
	 lExlVWIuiFrXdCcVxrwDCeJEfO7wJfhuEf9QvJvIk+vRYkXNw9hBXKhruUHSboy02L
	 LUfQM/GBkkupskuOL6rFVYbVNY6b1hn3AOWHahxe4MVh6nfWwIYzDDmEc9JGU/Xs4A
	 R5gKt+a60DshUDg25OOw1hPs+ohC6tMyOAyg2frlUxXaP+hsUFR6oWWuFsx6WI2lN4
	 7vOYfltKz3merTQKbyHfabq8=
Received: from zn.tnic (p200300ea973a31e1329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:973a:31e1:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7D73640E0208;
	Mon, 11 Nov 2024 15:54:02 +0000 (UTC)
Date: Mon, 11 Nov 2024 16:53:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v14 05/13] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
Message-ID: <20241111155355.GDZzIok9eRWDPKnmS_@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-6-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241028053431.3439593-6-nikunj@amd.com>

On Mon, Oct 28, 2024 at 11:04:23AM +0530, Nikunj A Dadhania wrote:
> The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
> enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
> are being intercepted. If this should occur and Secure TSC is enabled,
> guest execution should be terminated as the guest cannot rely on the TSC
> value provided by the hypervisor.

This should be in the comment below.

> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/coco/sev/shared.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
> index 71de53194089..c2a9e2ada659 100644
> --- a/arch/x86/coco/sev/shared.c
> +++ b/arch/x86/coco/sev/shared.c
> @@ -1140,6 +1140,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
>  	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
>  	enum es_result ret;
>  
> +	/*
> +	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
> +	 * enabled. Terminate the SNP guest when the interception is enabled.
> +	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
> +	 * use sev_status here as cc_platform_has() is not available when
> +	 * compiling boot/compressed/sev.c.
> +	 */
> +	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> +		return ES_VMM_ERROR;
> +
>  	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
>  	if (ret != ES_OK)
>  		return ret;
> -- 
> 2.34.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

