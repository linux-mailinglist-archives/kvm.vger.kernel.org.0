Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23E43CCDEF
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 08:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhGSGee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 02:34:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233048AbhGSGee (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 02:34:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626676294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+196Kfl7I/cOggKI9/d0VaO8T5ekNSjAsbN7j2ytW0I=;
        b=DYDqEtkDcmtAFVTBbcWk+rI8OW8CkRjagF+0reqs0jXdOJUUqcthFrNiirJyZ/Moj4CioO
        D/CCPH7/vxFxGemBatsgjqw7K9WujauhREZ8A8ptesTxAX6BkQOWRmEzhvYYEeQlsK+jMO
        uyJtSTnL//GagGYepc3kuED0C9CZit4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-gPQHd34hNy2KwqU2Yug8uQ-1; Mon, 19 Jul 2021 02:31:33 -0400
X-MC-Unique: gPQHd34hNy2KwqU2Yug8uQ-1
Received: by mail-ej1-f72.google.com with SMTP id bl17-20020a170906c251b029052292d7c3b4so4858049ejb.9
        for <kvm@vger.kernel.org>; Sun, 18 Jul 2021 23:31:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+196Kfl7I/cOggKI9/d0VaO8T5ekNSjAsbN7j2ytW0I=;
        b=kw3eSpj6UccXg/cbhnwCkAKz56eEPNRb03vKcWh43XuNWPoe9qp3/b4AVn6n60BnRA
         geKI8sTXDFEzaMT66P+wnrI48BOXt6OPtAoHep1rwiGI7kN6cgzU7yKVGiqzdMXuxj2O
         CPsHxm6JHiYVtjfWyh+edjpBYa4u3d2ZNwoMZexuE8BFgwzjH9n9qtKDK+K4Cp3K0+xU
         sWPTmdaMe6269wuFfiBkHGx/nbba/0TIfJSmED3m9t2IprLtfdg3MLRpgZC2Fw9eOpxh
         Vmv7f+eeNAJBxXfEarDVUJwic7xRkPfb+0XfZpzIZH66UTo/Yv6HVvPhXX+jm0OdDupd
         tWOQ==
X-Gm-Message-State: AOAM533HDV8LNp3fkbdDXD25H9J0QVV0T688l6iiZwwO3wAKu+QfyhvV
        d16ZxFUoCaianf/zl6ODnMEZHYC8N4yHgym/B53Wx8XtBjmq9us2nei3+CJdLw6pZ/4hkiP6vGX
        ewTF0eINy5eBW
X-Received: by 2002:a17:906:5f99:: with SMTP id a25mr26054141eju.101.1626676292000;
        Sun, 18 Jul 2021 23:31:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOvrTC0xug9PjA728zKCBsRdaYWyJcTPeNv01/Z04ULpdx8WvrT0arC7Gk/HA8qvC4THAFuA==
X-Received: by 2002:a17:906:5f99:: with SMTP id a25mr26054125eju.101.1626676291767;
        Sun, 18 Jul 2021 23:31:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id f20sm5511280ejz.30.2021.07.18.23.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 23:31:31 -0700 (PDT)
Subject: Re: [PATCH 1/5] KVM: arm64: Walk userspace page tables to compute the
 THP mapping size
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-2-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c04fc75d-0f2a-3a3f-f698-eaf5e2aa00bd@redhat.com>
Date:   Mon, 19 Jul 2021 08:31:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210717095541.1486210-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/07/21 11:55, Marc Zyngier wrote:
> We currently rely on the kvm_is_transparent_hugepage() helper to
> discover whether a given page has the potential to be mapped as
> a block mapping.
> 
> However, this API doesn't really give un everything we want:
> - we don't get the size: this is not crucial today as we only
>    support PMD-sized THPs, but we'd like to have larger sizes
>    in the future
> - we're the only user left of the API, and there is a will
>    to remove it altogether
> 
> To address the above, implement a simple walker using the existing
> page table infrastructure, and plumb it into transparent_hugepage_adjust().
> No new page sizes are supported in the process.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

If it's okay for you to reuse the KVM page walker that's fine of course, 
but the arch/x86/mm functions lookup_address_in_{mm,pgd} are mostly 
machine-independent and it may make sense to move them to mm/.

That would also allow reusing the x86 function host_pfn_mapping_level.

Paolo

> ---
>   arch/arm64/kvm/mmu.c | 46 ++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3155c9e778f0..db6314b93e99 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -433,6 +433,44 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>   	return 0;
>   }
>   
> +static struct kvm_pgtable_mm_ops kvm_user_mm_ops = {
> +	/* We shouldn't need any other callback to walk the PT */
> +	.phys_to_virt		= kvm_host_va,
> +};
> +
> +struct user_walk_data {
> +	u32	level;
> +};
> +
> +static int user_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +		       enum kvm_pgtable_walk_flags flag, void * const arg)
> +{
> +	struct user_walk_data *data = arg;
> +
> +	data->level = level;
> +	return 0;
> +}
> +
> +static int get_user_mapping_size(struct kvm *kvm, u64 addr)
> +{
> +	struct user_walk_data data;
> +	struct kvm_pgtable pgt = {
> +		.pgd		= (kvm_pte_t *)kvm->mm->pgd,
> +		.ia_bits	= VA_BITS,
> +		.start_level	= 4 - CONFIG_PGTABLE_LEVELS,
> +		.mm_ops		= &kvm_user_mm_ops,
> +	};
> +	struct kvm_pgtable_walker walker = {
> +		.cb		= user_walker,
> +		.flags		= KVM_PGTABLE_WALK_LEAF,
> +		.arg		= &data,
> +	};
> +
> +	kvm_pgtable_walk(&pgt, ALIGN_DOWN(addr, PAGE_SIZE), PAGE_SIZE, &walker);
> +
> +	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(data.level));
> +}
> +
>   static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>   	.zalloc_page		= stage2_memcache_zalloc_page,
>   	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
> @@ -780,7 +818,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>    * Returns the size of the mapping.
>    */
>   static unsigned long
> -transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
> +transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   			    unsigned long hva, kvm_pfn_t *pfnp,
>   			    phys_addr_t *ipap)
>   {
> @@ -791,8 +829,8 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>   	 * sure that the HVA and IPA are sufficiently aligned and that the
>   	 * block map is contained within the memslot.
>   	 */
> -	if (kvm_is_transparent_hugepage(pfn) &&
> -	    fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> +	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
> +	    get_user_mapping_size(kvm, hva) >= PMD_SIZE) {
>   		/*
>   		 * The address we faulted on is backed by a transparent huge
>   		 * page.  However, because we map the compound huge page and
> @@ -1051,7 +1089,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	 * backed by a THP and thus use block mapping if possible.
>   	 */
>   	if (vma_pagesize == PAGE_SIZE && !(force_pte || device))
> -		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
> +		vma_pagesize = transparent_hugepage_adjust(kvm, memslot, hva,
>   							   &pfn, &fault_ipa);
>   
>   	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
> 

