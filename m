Return-Path: <kvm+bounces-5986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C258296C7
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 11:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4767DB250A6
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 10:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429493FB08;
	Wed, 10 Jan 2024 10:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MZUF+eVm"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31743F8D9;
	Wed, 10 Jan 2024 10:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AC5AA40E01B2;
	Wed, 10 Jan 2024 09:59:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id t_Tn0inSc1pY; Wed, 10 Jan 2024 09:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704880797; bh=KJvIW3wGLgeykBglh9gfqqbtZfBEiY8fY9XU3XU6k20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MZUF+eVmMir+M1csoIULZxfauukcd7CIuBhSBhwBfhowq36E2RXi4e9gJ75fzZH9b
	 Wg6xn7brRPR4AwnRuCsq63ewIR/Xd7XFj67bgKbdKeb989Hgb9jGSZeUDdRLdfG7kB
	 WfsISTeUpUhK+LnBQkmPsNRbT0sOMv8Q8OQfrD6QLCHN/DQZpoTReSw82F5WpR//qZ
	 BnysNvbWGF31/Flzzv+uQLZQE9GP/i48XSZWOFnCIeLTv0UDkMM8XwpEpUSjbtQ+in
	 ytNul1/xz+BxbQ+322LEQcEVeh5I7sKfUzvQ/3PHa/BiTQX2YsmDlKSn3r3FJ2HEVo
	 tAfW05x8P5pbsC5YfiyRWtBfpkQFgr8M1DaPYLouuX8BfM/HMK15n6sIPb++WoPywo
	 yf2277q5vXXIdpe+FL1J6T2SCJH/lQEIdnLhwgQ4zFJxtufCyWXcVgfMax9BHQYREq
	 ptClxSF7ifxh6Z2ojSIgdLXQx1zVF8cnZaJw6qS1Uokypca32F5hO6k6w/j62w1xNH
	 Hv9ZDY3ZSUdUrwC+hrnXWhglinSkchD9uqSyz/Pu05OogRBjymaUWH2mLgixn8o8X5
	 a29JrS9ZsD6e1pt0bQjQlLXa4MC3q7a7wr2jbO3L2uGQ2u7+Ec5IaMh9WP0uztwh3O
	 IfOfk0ue5sI4yXGKrvIRn+f4=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 22F3940E0196;
	Wed, 10 Jan 2024 09:59:19 +0000 (UTC)
Date: Wed, 10 Jan 2024 10:59:12 +0100
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
Subject: Re: [PATCH v1 07/26] x86/fault: Add helper for dumping RMP entries
Message-ID: <20240110095912.GAZZ5qcFXYgvPrCdRI@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-8-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-8-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:35AM -0600, Michael Roth wrote:
> +void snp_dump_hva_rmpentry(unsigned long hva)
> +{
> +	unsigned int level;
> +	pgd_t *pgd;
> +	pte_t *pte;
> +
> +	pgd = __va(read_cr3_pa());
> +	pgd += pgd_index(hva);
> +	pte = lookup_address_in_pgd(pgd, hva, &level);
> +
> +	if (!pte) {
> +		pr_info("Can't dump RMP entry for HVA %lx: no PTE/PFN found\n", hva);
> +		return;
> +	}
> +
> +	dump_rmpentry(pte_pfn(*pte));
> +}
> +EXPORT_SYMBOL_GPL(snp_dump_hva_rmpentry);

show_fault_oops() - the only caller of this - is builtin code and thus
doesn't need symbol exports. Symbol exports are only for module code.

---
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index a8cf33b7da71..31154f087fb0 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -339,4 +339,3 @@ void snp_dump_hva_rmpentry(unsigned long hva)
 
 	dump_rmpentry(pte_pfn(*pte));
 }
-EXPORT_SYMBOL_GPL(snp_dump_hva_rmpentry);

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

