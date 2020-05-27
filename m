Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCCC1E3D94
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 11:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387524AbgE0J3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 05:29:07 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5290 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbgE0J3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 05:29:06 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0B8E0E4858C83D8465D0;
        Wed, 27 May 2020 17:28:58 +0800 (CST)
Received: from [10.173.221.230] (10.173.221.230) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Wed, 27 May 2020 17:28:51 +0800
Subject: Re: [RFC PATCH 2/7] KVM: arm64: Set DBM bit of PTEs if hw DBM enabled
To:     Catalin Marinas <catalin.marinas@arm.com>
References: <20200525112406.28224-1-zhukeqian1@huawei.com>
 <20200525112406.28224-3-zhukeqian1@huawei.com> <20200526114926.GD17051@gaia>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <zhengxiang9@huawei.com>,
        Peng Liang <liangpeng10@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <01147c57-b45e-0a40-da9a-4a0e56aac78d@huawei.com>
Date:   Wed, 27 May 2020 17:28:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200526114926.GD17051@gaia>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Catalin,

On 2020/5/26 19:49, Catalin Marinas wrote:
> On Mon, May 25, 2020 at 07:24:01PM +0800, Keqian Zhu wrote:
>> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
>> index 1305e28225fc..f9910ba2afd8 100644
>> --- a/arch/arm64/include/asm/pgtable-prot.h
>> +++ b/arch/arm64/include/asm/pgtable-prot.h
>> @@ -79,6 +79,7 @@ extern bool arm64_use_ng_mappings;
>>  	})
>>  
>>  #define PAGE_S2			__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(NORMAL) | PTE_S2_RDONLY | PAGE_S2_XN)
>> +#define PAGE_S2_DBM		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(NORMAL) | PTE_S2_RDONLY | PAGE_S2_XN | PTE_DBM)
> 
> You don't need a new page permission (see below).
> 
>>  #define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_S2_XN)
>>  
>>  #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index e3b9ee268823..dc97988eb2e0 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1426,6 +1426,10 @@ static void stage2_wp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
>>  	pte = pte_offset_kernel(pmd, addr);
>>  	do {
>>  		if (!pte_none(*pte)) {
>> +#ifdef CONFIG_ARM64_HW_AFDBM
>> +			if (kvm_hw_dbm_enabled() && !kvm_s2pte_dbm(pte))
>> +				kvm_set_s2pte_dbm(pte);
>> +#endif
>>  			if (!kvm_s2pte_readonly(pte))
>>  				kvm_set_s2pte_readonly(pte);
>>  		}
> 
> Setting the DBM bit is equivalent to marking the page writable. The
> actual writable pte bit (S2AP[1] or HAP[2] as we call them in Linux for
> legacy reasons) tells you whether the page has been dirtied but it is
> still writable if you set DBM. Doing this in stage2_wp_ptes()
> practically means that you no longer have read-only pages at S2. There
> are several good reasons why you don't want to break this. For example,
> the S2 pte may already be read-only for other reasons (CoW).
> 
Thanks, your comments help to solve the first problem in cover letter.

> I think you should only set the DBM bit if the pte was previously
> writable. In addition, any permission change to the S2 pte must take
> into account the DBM bit and clear it while transferring the dirty
> status to the underlying page. I'm not deeply familiar with all these
> callbacks into KVM but two such paths are kvm_unmap_hva_range() and the
> kvm_mmu_notifier_change_pte().
Yes, I agree.
> 
> 
>> @@ -1827,7 +1831,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  
>>  		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
>>  	} else {
>> -		pte_t new_pte = kvm_pfn_pte(pfn, mem_type);
>> +		pte_t new_pte;
>> +
>> +#ifdef CONFIG_ARM64_HW_AFDBM
>> +		if (kvm_hw_dbm_enabled() &&
>> +		    pgprot_val(mem_type) == pgprot_val(PAGE_S2)) {
>> +			mem_type = PAGE_S2_DBM;
>> +		}
>> +#endif
>> +		new_pte = kvm_pfn_pte(pfn, mem_type);
>>  
>>  		if (writable) {
>>  			new_pte = kvm_s2pte_mkwrite(new_pte);
> 
> That's wrong here. Basically for any fault you get, you just turn the S2
> page writable. The point of DBM is that you don't get write faults at
> all if you have a writable page. So, as I said above, only set the DBM
> bit if you stored a writable S2 pte (kvm_s2pte_mkwrite()).
Yeah, you are right. I will correct it in Patch v1.
> 

Thanks,
Keqian

