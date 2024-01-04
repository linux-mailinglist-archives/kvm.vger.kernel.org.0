Return-Path: <kvm+bounces-5637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EABB82406F
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 12:18:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7F77286338
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 11:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EBF121111;
	Thu,  4 Jan 2024 11:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="S8vDLPBG"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8786320B28;
	Thu,  4 Jan 2024 11:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5147D40E00C5;
	Thu,  4 Jan 2024 11:17:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KGOr19mSjR4J; Thu,  4 Jan 2024 11:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704367065; bh=rWnQdgMEkN3G7K5K3oauO5Dk8faRv4o3tZ5emI76S5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S8vDLPBG+v9OUyaP3+Ro45KPEmAb/VZQfjECTPx2xhoJkblHwT9fpWWNX6EWUKsGJ
	 YEuqyCPmuh7VJd7DcgQcOEyHFq1jx1Ut5FEPLy3e+sonMTUw1bp1U45gWBQqN2mpQM
	 Cnr/fHnuEAcHPCve+YoeBKGLAqGHgtIqcqgtJWfSGNGDfb2nwBVqViWznq2NadN9ac
	 gQptVnl7Vbke0ozSfIZPvPq3bsDEnQsLsTOB9hJlSrfRq0nSjCd7Aik6aoacSUWgNj
	 DLJMbATVAUAkGugV7Vb044aqTChzFodhC796XhX9dhN3Lnmu7OPoBrw1oZK3fQYHOi
	 kYuneRyqHsd9uKDGXdqx2pbFM7ZAf1EcyZDH5fwO69qzT8VM76ew9Hs2lRDnx2WYdy
	 jgWqxfXNgT2prcS2c/mmze8g1fobiFHpNVzVVgQlwLCRM7rARkBOu7S/Yn85oIuFxo
	 jJcjZHDD5VV3bDz38njXksB3V/6HQqsLPV6rTIyrZ6pkMEutwUNU8swpyJqZu2/pMu
	 3s955RE9bc5rt4q6d5FOGTzQB14BXBeFatuMyBfimymFVuA7My+zGY2dLvDGpVIrZb
	 3fH37ifRpIcRi0aseZzevA45QaGy44JvDRsQi+/rDHqzVL7XQfwUNlpRrWzDQ4cl5n
	 /hNWVO1P6LSGdJ+2RpE+qB0g=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BCCF240E0196;
	Thu,  4 Jan 2024 11:17:06 +0000 (UTC)
Date: Thu, 4 Jan 2024 12:16:59 +0100
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20240104111659.GEZZaTq1FGUfRzz3lM@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-5-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-5-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:32AM -0600, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The memory integrity guarantees of SEV-SNP are enforced through a new
> structure called the Reverse Map Table (RMP). The RMP is a single data
> structure shared across the system that contains one entry for every 4K
> page of DRAM that may be used by SEV-SNP VMs. APM2 section 15.36 details
> a number of steps needed to detect/enable SEV-SNP and RMP table support
> on the host:
> 
>  - Detect SEV-SNP support based on CPUID bit
>  - Initialize the RMP table memory reported by the RMP base/end MSR
>    registers and configure IOMMU to be compatible with RMP access
>    restrictions
>  - Set the MtrrFixDramModEn bit in SYSCFG MSR
>  - Set the SecureNestedPagingEn and VMPLEn bits in the SYSCFG MSR
>  - Configure IOMMU
> 
> RMP table entry format is non-architectural and it can vary by
> processor. It is defined by the PPR. Restrict SNP support to CPU
> models/families which are compatible with the current RMP table entry
> format to guard against any undefined behavior when running on other
> system types. Future models/support will handle this through an
> architectural mechanism to allow for broader compatibility.
> 
> SNP host code depends on CONFIG_KVM_AMD_SEV config flag, which may be
> enabled even when CONFIG_AMD_MEM_ENCRYPT isn't set, so update the
> SNP-specific IOMMU helpers used here to rely on CONFIG_KVM_AMD_SEV
> instead of CONFIG_AMD_MEM_ENCRYPT.

Small fixups to the commit message:

    The memory integrity guarantees of SEV-SNP are enforced through a new
    structure called the Reverse Map Table (RMP). The RMP is a single data
    structure shared across the system that contains one entry for every 4K
    page of DRAM that may be used by SEV-SNP VMs. The APM v2 section on
    Secure Nested Paging (SEV-SNP) details a number of steps needed to
    detect/enable SEV-SNP and RMP table support on the host:
    
     - Detect SEV-SNP support based on CPUID bit
     - Initialize the RMP table memory reported by the RMP base/end MSR
       registers and configure IOMMU to be compatible with RMP access
       restrictions
     - Set the MtrrFixDramModEn bit in SYSCFG MSR
     - Set the SecureNestedPagingEn and VMPLEn bits in the SYSCFG MSR
     - Configure IOMMU
    
    The RMP table entry format is non-architectural and it can vary by
    processor. It is defined by the PPR document for each respective CPU
    family. Restrict SNP support to CPU models/families which are compatible
    with the current RMP table entry format to guard against any undefined
    behavior when running on other system types. Future models/support will
    handle this through an architectural mechanism to allow for broader
    compatibility.
    
    The SNP host code depends on CONFIG_KVM_AMD_SEV config flag which may
    be enabled even when CONFIG_AMD_MEM_ENCRYPT isn't set, so update the
    SNP-specific IOMMU helpers used here to rely on CONFIG_KVM_AMD_SEV
    instead of CONFIG_AMD_MEM_ENCRYPT.

> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index f1bd7b91b3c6..15ce1269f270 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -599,6 +599,8 @@
>  #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
>  #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>  #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
> +#define MSR_AMD64_RMP_BASE		0xc0010132
> +#define MSR_AMD64_RMP_END		0xc0010133
>  
>  /* SNP feature bits enabled by the hypervisor */
>  #define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
> @@ -709,7 +711,14 @@
>  #define MSR_K8_TOP_MEM2			0xc001001d
>  #define MSR_AMD64_SYSCFG		0xc0010010
>  #define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
> -#define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
> +#define MSR_AMD64_SYSCFG_MEM_ENCRYPT		BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_EN_BIT		24
> +#define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT	25
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
> +#define MSR_AMD64_SYSCFG_MFDM_BIT		19
> +#define MSR_AMD64_SYSCFG_MFDM			BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)
> +

Fix the vertical alignment:

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 15ce1269f270..f482bc6a5ae7 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -710,14 +710,14 @@
 #define MSR_K8_TOP_MEM1			0xc001001a
 #define MSR_K8_TOP_MEM2			0xc001001d
 #define MSR_AMD64_SYSCFG		0xc0010010
-#define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
-#define MSR_AMD64_SYSCFG_MEM_ENCRYPT		BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
-#define MSR_AMD64_SYSCFG_SNP_EN_BIT		24
+#define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT 23
+#define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
+#define MSR_AMD64_SYSCFG_SNP_EN_BIT	24
 #define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
-#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT	25
-#define MSR_AMD64_SYSCFG_SNP_VMPL_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
-#define MSR_AMD64_SYSCFG_MFDM_BIT		19
-#define MSR_AMD64_SYSCFG_MFDM			BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)
+#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT 25
+#define MSR_AMD64_SYSCFG_SNP_VMPL_EN	BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
+#define MSR_AMD64_SYSCFG_MFDM_BIT	19
+#define MSR_AMD64_SYSCFG_MFDM		BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)
 
 #define MSR_K8_INT_PENDING_MSG		0xc0010055
 /* C1E active bits in int pending message */

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

