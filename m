Return-Path: <kvm+bounces-25353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12EB296465C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD9E81F216E3
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 13:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535B31A707F;
	Thu, 29 Aug 2024 13:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="EqVLPlTy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD451A76A4
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 13:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937745; cv=none; b=JND9HoanL3405/ohWx4uN4GGv6S+YUdI/JjeO03aJZhHXNn4jyca3EmtAcrdONCY92HEjZ+zHoqqikIFSueD+6JzrrBKWtqUELC0eqvgoOMAUkbLv7eKZppFptz0HGS2uDZLamNEaCKCXYdCymlfrcsZGuRb6w++NdJF8VT89po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937745; c=relaxed/simple;
	bh=oQj0KRBGMHjNHdPfh8Q8h3wMueXaodfE1dhhnO+N7fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYvDd7Z8dEYvHPrr63F05Pq22FbTO/rBmdPNy57ShzM0LzqFJoVG6Ya5fC5fbEELkYvPCnbI3Hs3CmI8fHyuQE/eo3CeJdU2Ij0y+s97shmXLdhxC3zB4c8+aos6cXIqCwCBMTpV84Ka12cCdj97l4z7NlLa4DzAZPA92wxj5Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=EqVLPlTy; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BB46F40E0284;
	Thu, 29 Aug 2024 13:22:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id q7TLeNyQaVLA; Thu, 29 Aug 2024 13:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1724937734; bh=ufGW6vocR0XGYpmUqWuOf+mbsV59/16zoa4Ts9IJi9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EqVLPlTyX8MF8e4MiXVevI4A5jh6fwqGXwqPFMxgMcTq6L7uiguaGmrt6ZYEbbg6R
	 LL2ux1GrHlzAfVODn8DSraEhMdm4h07CMWEQysAzJ2POMNSZmMWdM2rn1B9BNoPnja
	 NTa8O2FUY07dYymf0zVbNOOaxo1MSBY+ZkAJmKbdG6uqgYwHy1sDRRKam3FaxLeIwZ
	 Ia6RQmQpPW7puuvoPbXoRa2ElusGGUdMmN61B3b4wE3K2EMZ31HZW9YBtrnUk3cr6z
	 l4IlxhwQUIihspxTAa1rWWmqec4OY+d4+5gy0OWt4OPwuvdlqYE7dryCVxx6m4oix0
	 GJ9N6/3gUHZXKZ8ViB86JpZUkMvhMrsuSZs5YXh5ThmRmgTaZEP1xGvKCavUZIsVZJ
	 mcfxqJweKeiaf5qR8IbvMdAlbreFLBLABvImjiWFYOZsrqOjgtW8NmPzTAGMdezSSF
	 UbPy7C32j3nZLKf23v8vOG+6ovmPlM1X38jmbFUjq1yS9dU3j+Om1T8xEziGwFKdZR
	 WnqPeQdPluXwY2qtwEIUYF5rc3wFn+uPt1yVYyxZjPSJB1kTIOCRiUu/5K/eoY3Vzl
	 vo0tcP87GEt/SK6oKP/pmzNZg1AmJoH+KgtoOwthhsB566XDj0iee8BMDml6YppBnV
	 Xyod1JMejOv0w+QyHLWwogC4=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A711E40E0169;
	Thu, 29 Aug 2024 13:22:07 +0000 (UTC)
Date: Thu, 29 Aug 2024 15:22:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, santosh.shukla@amd.com, ketanch@iitk.ac.in
Subject: Re: [RFC PATCH 1/5] x86/cpufeatures: Add SNP Secure TSC
Message-ID: <20240829132201.GBZtB1-ZHQ8wW9-5fi@fat_crate.local>
References: <20240829053748.8283-1-nikunj@amd.com>
 <20240829053748.8283-2-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240829053748.8283-2-nikunj@amd.com>

On Thu, Aug 29, 2024 at 11:07:44AM +0530, Nikunj A Dadhania wrote:
> The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
> and RDTSCP instructions, ensuring that the parameters used cannot be
> altered by the hypervisor once the guest is launched. More details in the
> AMD64 APM Vol 2, Section "Secure TSC".
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index dd4682857c12..ed61549e8a11 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -444,6 +444,7 @@
>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" AMD Secure Encrypted Virtualization - Encrypted State */
>  #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" AMD Secure Encrypted Virtualization - Secure Nested Paging */
> +#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* "" AMD SEV-SNP Secure TSC */

There's a newline here on purpose - keep it.

Also, you don't need "" anymore.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

