Return-Path: <kvm+bounces-5630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F12D823F78
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 11:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C1D22872BC
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 10:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5218720DED;
	Thu,  4 Jan 2024 10:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="V2d40fYB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5A820DE1;
	Thu,  4 Jan 2024 10:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7C1B540E0202;
	Thu,  4 Jan 2024 10:31:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cpt72dB3zF74; Thu,  4 Jan 2024 10:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704364291; bh=0rxushcfZyl8L0hy6S9Km4lGh2/dzw7ZO9lKAm8opZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V2d40fYBXLsjiwgw88xJEJal0iK5jhfOdiiW5CFmq7CsA30eB3UEH5tslaIptPYHx
	 AiKsFb6HXIdUELKJTNpqrJ+OtNud5zqyBzQO12LOoH6NGEzs213S/tk5v/52ynLT+d
	 BMUbP6o8Hi5BWVifZygd83cULDxVy73O2SgyQiBLTg/+hDTkamGbeymlReg9rcHoE2
	 qb0hcW/GpP5dnDESmgo7cEDUG5p9xnZrGBlZk/BzCIXjhvzIKEkQmTdJsLz2hR9f5Y
	 3e/8k6phnvZM8lA8qSM7zaOWOJp3eL9Tc+otbB0CH8PvK46AXOGxw1FN1ZCd2oaGD7
	 indn2kf4LREaQl/JX+VTc0TLlwQNTp2WyLiBjla+Bw720a4k9qAZa9W7O5cQQKgwp7
	 3HT2ReBRVycQg//veJFInytfO5HSRvVRcuJbA0MPCcLvSvs8oi9YMpQ4q1qn0bzL+5
	 2UximNaMGXpHLlqLvXpeC2zshznqUwr9JofQc+LA8WBk+mL2P6pNm7ZxUHu8VyYs0d
	 fc9TkDWvo4d7PMa4lnjQcWjHYn0Sf7srHrNS7OtjNQd21AGPYlE3GKV146o5opcokD
	 0FvC5c4D1ZHKr5ycn1wFc1eWC9g48Qqj6QE89nWfm6ewVFLsyBNsoFSTzvr+7wDdPE
	 uPUiPUyJWMXVD9UcdHdhHnFY=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D2A6C40E0177;
	Thu,  4 Jan 2024 10:30:53 +0000 (UTC)
Date: Thu, 4 Jan 2024 11:30:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com
Subject: Re: [PATCH v1 03/26] iommu/amd: Don't rely on external callers to
 enable IOMMU SNP support
Message-ID: <20240104103047.GDZZaI11z9Htj3XS/P@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-4-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-4-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:31AM -0600, Michael Roth wrote:
> +static void iommu_snp_enable(void)
> +{
> +#ifdef CONFIG_KVM_AMD_SEV
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return;
> +	/*
> +	 * The SNP support requires that IOMMU must be enabled, and is
> +	 * not configured in the passthrough mode.
> +	 */
> +	if (no_iommu || iommu_default_passthrough()) {
> +		pr_err("SNP: IOMMU is disabled or configured in passthrough mode, SNP cannot be supported.\n");
> +		return;
> +	}
> +
> +	amd_iommu_snp_en = check_feature(FEATURE_SNP);
> +	if (!amd_iommu_snp_en) {
> +		pr_err("SNP: IOMMU SNP feature is not enabled, SNP cannot be supported.\n");
> +		return;
> +	}
> +
> +	pr_info("IOMMU SNP support is enabled.\n");
> +
> +	/* Enforce IOMMU v1 pagetable when SNP is enabled. */
> +	if (amd_iommu_pgtable != AMD_IOMMU_V1) {
> +		pr_warn("Forcing use of AMD IOMMU v1 page table due to SNP.\n");
> +		amd_iommu_pgtable = AMD_IOMMU_V1;
> +	}

Kernel code usually says simple "<bla> enabled" not "<bla> is enabled".
Other than that, LGTM.

---

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 1ed2ef22a0fb..2f1517acaba0 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3231,17 +3231,17 @@ static void iommu_snp_enable(void)
 	 * not configured in the passthrough mode.
 	 */
 	if (no_iommu || iommu_default_passthrough()) {
-		pr_err("SNP: IOMMU is disabled or configured in passthrough mode, SNP cannot be supported.\n");
+		pr_err("SNP: IOMMU disabled or configured in passthrough mode, SNP cannot be supported.\n");
 		return;
 	}
 
 	amd_iommu_snp_en = check_feature(FEATURE_SNP);
 	if (!amd_iommu_snp_en) {
-		pr_err("SNP: IOMMU SNP feature is not enabled, SNP cannot be supported.\n");
+		pr_err("SNP: IOMMU SNP feature not enabled, SNP cannot be supported.\n");
 		return;
 	}
 
-	pr_info("IOMMU SNP support is enabled.\n");
+	pr_info("IOMMU SNP support enabled.\n");
 
 	/* Enforce IOMMU v1 pagetable when SNP is enabled. */
 	if (amd_iommu_pgtable != AMD_IOMMU_V1) {


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

