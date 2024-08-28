Return-Path: <kvm+bounces-25237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D7EB9623EC
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 11:50:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FF781C23CAB
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 09:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCFD166F34;
	Wed, 28 Aug 2024 09:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jmG1sPeq"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBDE1547F2;
	Wed, 28 Aug 2024 09:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724838601; cv=none; b=oACtmsz+QVmpye4RmTL/5a5pMcsxF+AsJZjI1mh977CHPJ1SMeLpAsoj/+w7q6lHdCRcChxyzpiaUpBgGJFfYol/B93iqbhpjGy6ikR63WmGKX36jHicZiK+ISHPnKTIZsjakyVnYa9E58itVb1MtRDpRiuj4AbcaKYH/Ecg0MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724838601; c=relaxed/simple;
	bh=yI8UGtDeDzq0ejW8pdr/qL9ax7t3BWnl+/WBFqgMGcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpsSR0O/zEF/6C/on3VP1aMDj7IQNwpRJMfcMjp5LPC0ZSj3vdTANA8q+ak1Jgzt9CR0fHP1ob9p7IEEcUDvD/bBdsor6HyaftVVbX7GGithwoXz2bE6i1uAifmmXIsM/5pgJAHQ7DqeSruGtJWNCrKtxPrRHI88scOyc1aVgk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jmG1sPeq; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3B65D40E0169;
	Wed, 28 Aug 2024 09:49:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id fs9lpMNWbvlK; Wed, 28 Aug 2024 09:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1724838590; bh=YvhPqudcoWPR0qgKjwOwmAY5MUaGOhjFnDWRorh3R24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jmG1sPeqgZEqwW9gdYGJtbbQhlI9DPC2kDHs3DrhwvSdlsVaKfiKQfey1bVMfr78v
	 TrmTAkuvvVEwqyHs+5u5pZqes1ouDQzQJkKeAzv1tiqqJxoP7m2wwtsu1tS/I7XNZv
	 cHycddpT6IzEt+lp1QiX6pElAqN8R0wgI3lGM2NElYUQyp8n5GhqnG06y7EYOOAFt4
	 GTzpCJUM97UfE6bk7K4+R6ALajym6uecwu4dFCVMFyZ8EF3cepc30hWL4PhBofKEVJ
	 tl8GeNqooxyDv9h/VmMoX5mV1f85OpT8mBLAXFDBxmDiWCrbnhUx7ODtb82OKSDhOj
	 bO3u+VCxgjKzATTW0o00TBVIEx6PW0ubnCZ5IcGncFBSzlmUkRFYTiFkheA92rz4ig
	 Dauqo+YPPE2F/D/uSXfQ2AN/tEWUmtR9Vy88aOLWlVT4Uzdljl2QjoibN/RSjhdDwn
	 RE+mbRZVChM1MB7AvccRnXJDNaqkELVPE2NS7b34N+DfLfPGRqZrNfp3qg6wnUVXte
	 RtEaT8G2w45U6ytnfCS6Qyjh2yqSxRiFn0RAxhXRHwSQ8/mw3R50Ece0syzM861gQc
	 rddoWF7Sib9F/xzhsiPVUX5eL4IxARtvEbiQ4rBbPBF0vBminszqY0x13gMQ7Tp0dy
	 mkSkhlO9+BeJugnSVal3Yq64=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BC9C340E01C5;
	Wed, 28 Aug 2024 09:49:39 +0000 (UTC)
Date: Wed, 28 Aug 2024 11:49:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v11 06/20] x86/sev: Handle failures from snp_init()
Message-ID: <20240828094933.GAZs7yrbCHDJUeUWys@fat_crate.local>
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-7-nikunj@amd.com>
 <20240827113227.GAZs25S8Ubep1CDYr8@fat_crate.local>
 <5b62f751-668f-714e-24a2-6bbc188c3ce8@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5b62f751-668f-714e-24a2-6bbc188c3ce8@amd.com>

On Wed, Aug 28, 2024 at 10:17:57AM +0530, Nikunj A. Dadhania wrote:
> +	if ((snp && !snp_enabled) ||
> +	    (!snp && snp_enabled))
>  		snp_abort();

And which boolean function is that?

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index e83b363c5e68..706cb59851b0 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -495,10 +495,10 @@ void __head sme_enable(struct boot_params *bp)
 	unsigned int eax, ebx, ecx, edx;
 	unsigned long feature_mask;
 	unsigned long me_mask;
-	bool snp;
+	bool snp_en;
 	u64 msr;
 
-	snp = snp_init(bp);
+	snp_en = snp_init(bp);
 
 	/* Check for the SME/SEV support leaf */
 	eax = 0x80000000;
@@ -531,15 +531,11 @@ void __head sme_enable(struct boot_params *bp)
 	RIP_REL_REF(sev_status) = msr = __rdmsr(MSR_AMD64_SEV);
 	feature_mask = (msr & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
 
-	/* The SEV-SNP CC blob should never be present unless SEV-SNP is enabled. */
-	if (snp && !(msr & MSR_AMD64_SEV_SNP_ENABLED))
-		snp_abort();
-
 	/*
-	 * The SEV-SNP CC blob should be present and parsing CC blob should
-	 * succeed when SEV-SNP is enabled.
+	 * Any discrepancies between the presence of a CC blob and SNP
+	 * enablement abort the guest.
 	 */
-	if (!snp && (msr & MSR_AMD64_SEV_SNP_ENABLED))
+	if (snp_en ^ (msr & MSR_AMD64_SEV_SNP_ENABLED))
 		snp_abort();
 
 	/* Check if memory encryption is enabled */

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

