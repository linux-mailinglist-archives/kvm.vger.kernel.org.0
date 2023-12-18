Return-Path: <kvm+bounces-4744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F3681791F
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 18:49:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D04311C25A02
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A915D72D;
	Mon, 18 Dec 2023 17:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Up7Ng5oa"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8825C72069;
	Mon, 18 Dec 2023 17:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 853C040E00A9;
	Mon, 18 Dec 2023 17:44:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id m9dl5PpHaaR0; Mon, 18 Dec 2023 17:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702921437; bh=Z3gLK2hvl7+MxZT0PYqx203zqjrTJn7QqrwGTsrc/p0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Up7Ng5oayew1nPDTS0jZMKdUCZRcJGusLwfhWKwuqbsptAuhc8CEsSU+T/NNbADem
	 U9TXTld+nlWGfR3r/Gl8dsDw3L7tUlsWL3E55mpZnfNz0oF/3mIIa8WLoCpZrewYvz
	 4zHzHJgJsC+ziQexo2dVq1aHs5wTaL1BvC4MotTUFzD6AaSbsITmmDNEVJdbVJZjEI
	 huOu5B5UXtVvxvGiCcSfHdie7WnkrD6XyAws6gQUp6al3cF3K6vcXa/LG8rM0IsHJC
	 6aK3MDZ+VNwbPWwT/jkclDKCOJW/XKIsGlUXJkN4Rc0r/lfBp6lBIlAjfbOF5WBWio
	 Zjl2o6R8oV8YAsek34ZsWiFyldI3lnEN1BoEdMj/tNDLwaVEo707D+rgOaonrxaK+N
	 1KW8Vmqn05yPH+i1kKC9N191sEjyEubZPbiVaHtMwTqIYVXPAsvjIyzIFJjqAydhvM
	 eKJSFsiYrYY4PMu7vLOJQcdWL8gBwwxwSTo6P5+NtGl8FjMfdCCGbd9XXXIiNDeEYa
	 60+s3aYP9FB2hb57qqyWV6PSBaRAqq+2L775+nzV4Sgs5uH23dLGl20KHYSQ8fDHmw
	 0XDAyTBR1TeVLiOrDj7Nk6H7bwDvIMx74gnIpVFVWBi8m7FUqyic2ZjqodnfPUDl0C
	 jf0z7QWWclQVjf7G/k32LP6U=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 39F9A40E0030;
	Mon, 18 Dec 2023 17:43:18 +0000 (UTC)
Date: Mon, 18 Dec 2023 18:43:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 24/50] KVM: SEV: Add initial SEV-SNP support
Message-ID: <20231218174258.GRZYCEomVKa9J+EvHh@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-25-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-25-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:53AM -0500, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The next generation of SEV is called SEV-SNP (Secure Nested Paging).
> SEV-SNP builds upon existing SEV and SEV-ES functionality  while adding new
> hardware based security protection. SEV-SNP adds strong memory encryption
> integrity protection to help prevent malicious hypervisor-based attacks
> such as data replay, memory re-mapping, and more, to create an isolated
> execution environment.
> 
> The SNP feature is added incrementally, the later patches adds a new module
> parameters that can be used to enabled SEV-SNP in the KVM.

This sentence can simply go to /dev/null.

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 10 ++++++++++
>  arch/x86/kvm/svm/svm.h |  8 ++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1cfb9232fc74..4eefc168ebb3 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -59,10 +59,14 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  /* enable/disable SEV-ES DebugSwap support */
>  static bool sev_es_debug_swap_enabled = true;
>  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
> +
> +/* enable/disable SEV-SNP support */

Useless comment.

> +static bool sev_snp_enabled;
>  #else
>  #define sev_enabled false
>  #define sev_es_enabled false
>  #define sev_es_debug_swap_enabled false
> +#define sev_snp_enabled false
>  #endif /* CONFIG_KVM_AMD_SEV */
>  
>  #define AP_RESET_HOLD_NONE		0
> @@ -2186,6 +2190,7 @@ void __init sev_hardware_setup(void)
>  {
>  #ifdef CONFIG_KVM_AMD_SEV
>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> +	bool sev_snp_supported = false;
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
>  
> @@ -2261,6 +2266,10 @@ void __init sev_hardware_setup(void)
>  	sev_es_asid_count = min_sev_asid - 1;
>  	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>  	sev_es_supported = true;
> +	sev_snp_supported = sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SEV_SNP);
> +
> +	pr_info("SEV-ES %ssupported: %u ASIDs\n",
> +		sev_snp_supported ? "and SEV-SNP " : "", sev_es_asid_count);

Why like this?

>  
>  out:

Here, below the "out:" label you're already dumping SEV and -ES status.
Just do SNP exactly the same.

>  	if (boot_cpu_has(X86_FEATURE_SEV))
> @@ -2277,6 +2286,7 @@ void __init sev_hardware_setup(void)
>  	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
>  	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
>  		sev_es_debug_swap_enabled = false;
> +	sev_snp_enabled = sev_snp_supported;
>  #endif
>  }

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

