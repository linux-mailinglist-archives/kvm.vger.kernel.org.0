Return-Path: <kvm+bounces-37871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C68CA30E3C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 15:31:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 165103A5949
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 14:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647592505B0;
	Tue, 11 Feb 2025 14:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OJD7vs8N"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC3C1F153D
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 14:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739284271; cv=none; b=Cl6jV/7CWwICBJMBDIUF+2OyudLSAbxkaxbKFFXYDgohhxaYlmCumDq9sTZo4St5ZmcvsvnCb8nJUGKyWdoRU+VL6AF+dAAEjuvqTPXlCRjMTsix2xokdWc4U16BLqRLajePooHkacdFKKTx4eTdz1OGVAqntb/Yc/MUuLJAJ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739284271; c=relaxed/simple;
	bh=5j/diX5tAEy/A/s7JdnbcHjX3nY/0al/HbN+kjUuakg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g4C0l6k4HpjN1Wt9bipe9dz3Hjo+eIWgVig8m2H/RrYuHtYhF9Ok9wfTC6eBZagXiRPegkHNgvNO2sQn/oGxx+OifVqCYVbXbqEgwZy9No1OcPAj/EDBi3jNgIccvUrf1te1h9lMIfEsdSmq9NmGW/JHOujdBVRckG1+HXQzmBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=OJD7vs8N; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 026EE40E0220;
	Tue, 11 Feb 2025 14:31:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id PV8wFRTTlKd9; Tue, 11 Feb 2025 14:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739284255; bh=WmTmiLrhpAykTB6yuig9A89IiB1YFEuaZS2JhrA4g0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OJD7vs8NpQuSBizqoG2sg/Hk1Lo6xZtNV03gxP0KlK7K7i2tm9RBJyCRk1rcFrGNU
	 CF5zvEJKXnDFggSFvorcWSwFZMEghbEx/yIR+WU7ozCtAnJOFobqLJw3EGJJ47MS9x
	 352MsMTwWIDfNe7xO15wcAJEruL+udSdPq4bKdZ4EWjCTez3XMMVEiIDW8DjhRljK2
	 9t9ZCAj8ndcvSqiuAf3x/saf+BVufju0cSwQGIMCRGMHZfqh98RjPKKF+YEz0wE5/e
	 iAyrIrq7/0LoSSUtEEcTmBvCdGxmOK2FlxYiR4RoESyMS5keNzfIpXUizzVKHMVi2g
	 GR5+Y+1pPMPW2ecLE896iE851OMU7Lhgsn+1iTYlGmWSbRz6OOAqS1uGt09UIv1uaz
	 bV3KVkhFlfEvQYX5hCgPf/fo/NOjtSCdQjNmE+dam6kZl2F4tTi//oagBaA/P5V/Zd
	 isg1q9LsdHu3pfKbEjNZoFeHXRH5LcsEGbMFguqDFueFq/bSqWRfZTgx2isxhvq1TQ
	 ns80jFe9QWrQZRXjcfZkdR5wAaJtTDxLDxsSkVqbo3OCydoA9a7m56AdcND8VVBYiU
	 2HJxHE0Y2a4ur317Ukd5qOq+Glu8DuaYuig/k501N1geMXuTaSnNR5D9FRMW72SmPs
	 aVTBll0ANn2jJ8PAVE7zi4v8=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EBACC40E01AE;
	Tue, 11 Feb 2025 14:30:46 +0000 (UTC)
Date: Tue, 11 Feb 2025 15:30:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, santosh.shukla@amd.com, ketanch@iitk.ac.in,
	isaku.yamahata@intel.com
Subject: Re: [PATCH v2 1/4] x86/cpufeatures: Add SNP Secure TSC
Message-ID: <20250211143041.GEZ6tfEULqVzgNU6TH@fat_crate.local>
References: <20250210092230.151034-1-nikunj@amd.com>
 <20250210092230.151034-2-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250210092230.151034-2-nikunj@amd.com>

On Mon, Feb 10, 2025 at 02:52:27PM +0530, Nikunj A Dadhania wrote:
> The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
> and RDTSCP instructions, ensuring that the parameters used cannot be
> altered by the hypervisor once the guest is launched. For more details,
> refer to the AMD64 APM Vol 2, Section "Secure TSC".
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 508c0dad116b..921ed26b0be7 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -448,6 +448,7 @@
>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" Secure Encrypted Virtualization - Encrypted State */
>  #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" Secure Encrypted Virtualization - Secure Nested Paging */
> +#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* SEV-SNP Secure TSC */
>  #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* hardware-enforced cache coherency */
>  #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
> -- 

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

