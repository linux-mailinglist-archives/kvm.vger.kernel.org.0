Return-Path: <kvm+bounces-4049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F37D580CAE0
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 14:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5837DB20DB2
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 13:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0AD3E491;
	Mon, 11 Dec 2023 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qgq0uhGv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5icEo1eW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qgq0uhGv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5icEo1eW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03BB9F;
	Mon, 11 Dec 2023 05:24:36 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 185611FB92;
	Mon, 11 Dec 2023 13:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702301075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMgnxyitx5biXn0pgd3cG6sZC67XFgXymWiCAbEeFTU=;
	b=qgq0uhGvq6aIfA5kdV6s+QP77h0xXawLNa4A29TZgm39fmSyEMcNuUNl/UJlXlQZ6TlVII
	zUPmDYi0fH0Yt0D7dLkXicNuqDMiJaxJ5heDUfk+mrsPuy6M1oh6T0tY9SMzDlOSlV4LgP
	QY8JDDt5fKiuyhv186WN/KT6tMWo6a0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702301075;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMgnxyitx5biXn0pgd3cG6sZC67XFgXymWiCAbEeFTU=;
	b=5icEo1eWkvwddWdmXQVEWIOUzUs2xYmB+HjHHoXSDtcBu2H6WH1b4L1DKOEh4M/mvL1rSS
	DA8zHNEP7Ohx7sCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702301075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMgnxyitx5biXn0pgd3cG6sZC67XFgXymWiCAbEeFTU=;
	b=qgq0uhGvq6aIfA5kdV6s+QP77h0xXawLNa4A29TZgm39fmSyEMcNuUNl/UJlXlQZ6TlVII
	zUPmDYi0fH0Yt0D7dLkXicNuqDMiJaxJ5heDUfk+mrsPuy6M1oh6T0tY9SMzDlOSlV4LgP
	QY8JDDt5fKiuyhv186WN/KT6tMWo6a0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702301075;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMgnxyitx5biXn0pgd3cG6sZC67XFgXymWiCAbEeFTU=;
	b=5icEo1eWkvwddWdmXQVEWIOUzUs2xYmB+HjHHoXSDtcBu2H6WH1b4L1DKOEh4M/mvL1rSS
	DA8zHNEP7Ohx7sCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE1C0133DE;
	Mon, 11 Dec 2023 13:24:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IoIJMpINd2W+DAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 11 Dec 2023 13:24:34 +0000
Message-ID: <20e52d79-7eff-1aad-2f77-24ed7fd56fa7@suse.cz>
Date: Mon, 11 Dec 2023 14:24:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 23/50] KVM: SEV: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-24-michael.roth@amd.com>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20231016132819.1002933-24-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Score: -4.30
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 R_RATELIMIT(0.00)[to_ip_from(RL81e5qggtdx371s8ik49ru6xr)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-0.999];
	 RCPT_COUNT_TWELVE(0.00)[40];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO

On 10/16/23 15:27, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Implement a workaround for an SNP erratum where the CPU will incorrectly
> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> RMP entry of a VMCB, VMSA or AVIC backing page.
> 
> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
> backing pages as "in-use" via a reserved bit in the corresponding RMP
> entry after a successful VMRUN. This is done for _all_ VMs, not just
> SNP-Active VMs.
> 
> If the hypervisor accesses an in-use page through a writable
> translation, the CPU will throw an RMP violation #PF. On early SNP
> hardware, if an in-use page is 2mb aligned and software accesses any
> part of the associated 2mb region with a hupage, the CPU will
> incorrectly treat the entire 2mb region as in-use and signal a spurious
> RMP violation #PF.
> 
> The recommended is to not use the hugepage for the VMCB, VMSA or
> AVIC backing page for similar reasons. Add a generic allocator that will
> ensure that the page returns is not hugepage (2mb or 1gb) and is safe to

This is a bit confusing wording as we are not avoiding "using a
hugepage" but AFAIU, avoiding using a (4k) page that has a hugepage
aligned physical address, right?

> be used when SEV-SNP is enabled. Also implement similar handling for the
> VMCB/VMSA pages of nested guests.
> 
> Co-developed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> Reported-by: Alper Gun <alpergun@google.com> # for nested VMSA case
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> [mdr: squash in nested guest handling from Ashish]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---

<snip>

> +
> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long pfn;
> +	struct page *p;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +
> +	/*
> +	 * Allocate an SNP safe page to workaround the SNP erratum where
> +	 * the CPU will incorrectly signal an RMP violation  #PF if a
> +	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
> +	 * or AVIC backing page. The recommeded workaround is to not use the
> +	 * hugepage.

Same here "not use the hugepage"

> +	 *
> +	 * Allocate one extra page, use a page which is not 2mb aligned
> +	 * and free the other.

This makes more sense.

> +	 */
> +	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> +	if (!p)
> +		return NULL;
> +
> +	split_page(p, 1);

Yeah I think that's a sensible use of split_page(), as we don't have
support for forcefully non-aligned allocations or specific "page
coloring" in the page allocator.
So even with my wording concerns:

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> +
> +	pfn = page_to_pfn(p);
> +	if (IS_ALIGNED(pfn, PTRS_PER_PMD))
> +		__free_page(p++);
> +	else
> +		__free_page(p + 1);
> +
> +	return p;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1e7fb1ea45f7..8e4ef0cd968a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -706,7 +706,7 @@ static int svm_cpu_init(int cpu)
>  	int ret = -ENOMEM;
>  
>  	memset(sd, 0, sizeof(struct svm_cpu_data));
> -	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +	sd->save_area = snp_safe_alloc_page(NULL);
>  	if (!sd->save_area)
>  		return ret;
>  
> @@ -1425,7 +1425,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  	svm = to_svm(vcpu);
>  
>  	err = -ENOMEM;
> -	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	vmcb01_page = snp_safe_alloc_page(vcpu);
>  	if (!vmcb01_page)
>  		goto out;
>  
> @@ -1434,7 +1434,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  		 * SEV-ES guests require a separate VMSA page used to contain
>  		 * the encrypted register state of the guest.
>  		 */
> -		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +		vmsa_page = snp_safe_alloc_page(vcpu);
>  		if (!vmsa_page)
>  			goto error_free_vmcb_page;
>  
> @@ -4876,6 +4876,16 @@ static int svm_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>  
> +static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
> +{
> +	struct page *page = snp_safe_alloc_page(vcpu);
> +
> +	if (!page)
> +		return NULL;
> +
> +	return page_address(page);
> +}
> +
>  static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.name = KBUILD_MODNAME,
>  
> @@ -5007,6 +5017,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  
>  	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>  	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
> +	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
>  };
>  
>  /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index c13070d00910..b7b8bf73cbb9 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -694,6 +694,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>  void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
>  
>  /* vmenter.S */
>  

