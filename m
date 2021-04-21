Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA27366A57
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 14:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhDUMBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 08:01:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234234AbhDUMBX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 08:01:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619006450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IK8rNqxriUfZgIBGQj3cIoO+PFxUc7/geRSzlVfw5xE=;
        b=PxAatrIuQ94WeUzsKHRT5Ye8eJUB+vYJ/MhIjrfmnWPg2wP6emsJLWZEWwPLWFxiVb/1ze
        /2RBXkxp4wrjLG6TR2fLmZROLNAEltA+0654ikmm4n//K3sxUN8loa8E9ygVqhzhcyizbG
        wdJFOXMdDBCf/fpV2nA7+UDq110xweA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-fcZAOIisPS26qYlXdOIbVg-1; Wed, 21 Apr 2021 08:00:47 -0400
X-MC-Unique: fcZAOIisPS26qYlXdOIbVg-1
Received: by mail-wr1-f71.google.com with SMTP id j4-20020adfe5040000b0290102bb319b87so12560143wrm.23
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 05:00:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IK8rNqxriUfZgIBGQj3cIoO+PFxUc7/geRSzlVfw5xE=;
        b=BSLEuf/BV4b7JSC1FpybEeSIGjvIQ5zyqPzfV8aAh3fONRWcW2FGxBFTNbB78EPpFm
         LwVLjR9jr1XR2OL6RtUELx0/AZskcSQcMT+Bur9iw46G0956VZLRP5SzxrAhECXD6Upv
         wCO7DgwymxtuborVnwyZmLa3Kn/+7t5CneT5/G8yXf+9xTYsq/z3Sqxj11paQQXKlaq1
         fnv4b/9GWqA/6q3EJc/knnqf1dIRjesQ8b8wvaM76MCLreu7OmabrIlyXwIcfAxBcrEv
         GUGU27VlguCqWURPWZOcVWdOa4o0mzy4Pegsm6KZbTzR48TvP9IEmnjK6joMnTyjxlqm
         5wKA==
X-Gm-Message-State: AOAM530y9XjhxOqsE667zbkNu7nty29UxgetWhNXrE1mtb9SeKJBlQiJ
        xVsd6zAdnGKvLXYwVOnF2RgdLI3iHLJRm8f6hr98QXqqxRd9UXxoCb7/RcuQ6+kOJp7Eu3C7dPL
        282nYdWyuwLIa
X-Received: by 2002:a05:600c:1546:: with SMTP id f6mr9310829wmg.156.1619006446175;
        Wed, 21 Apr 2021 05:00:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNv79et85M29gcYqBuP/mxfRipp3hvtxuVMeYFbWpLW9uTOlR5sx4EqM3X88BVF4Sp03sdIw==
X-Received: by 2002:a05:600c:1546:: with SMTP id f6mr9310808wmg.156.1619006445934;
        Wed, 21 Apr 2021 05:00:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q17sm2958030wro.33.2021.04.21.05.00.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 05:00:44 -0700 (PDT)
Subject: Re: [PATCH v13 09/12] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Borislav Petkov <bp@alien8.de>, Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <f2340642c5b8d597a099285194fca8d05c9843bd.1618498113.git.ashish.kalra@amd.com>
 <20210421100508.GA11234@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f63735b4-8ec2-fdb4-0bac-8ee0921268b0@redhat.com>
Date:   Wed, 21 Apr 2021 14:00:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210421100508.GA11234@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/21 12:05, Borislav Petkov wrote:
> On Thu, Apr 15, 2021 at 03:57:26PM +0000, Ashish Kalra wrote:
>> +static inline void page_encryption_changed(unsigned long vaddr, int npages,
>> +						bool enc)
> 
> When you see a function name "page_encryption_changed", what does that
> tell you about what that function does?
> 
> Dunno but it doesn't tell me a whole lot.
> 
> Now look at the other function names in struct pv_mmu_ops.
> 
> See the difference?
> 
>> +static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
> 
> If I had to guess what that function does just by reading its name, it
> sets a memory encryption/decryption hypercall.
> 
> Am I close?

The words are right but the order is wrong (more like "hypercall to set 
some memory's encrypted/decrypted state").  Perhaps? 
kvm_hypercall_set_page_enc_status.

page_encryption_changed does not sound bad to me though, it's a 
notification-like function name.  Maybe notify_page_enc_status_changed?

Paolo

>> +					bool enc)
>> +{
>> +	unsigned long sz = npages << PAGE_SHIFT;
>> +	unsigned long vaddr_end, vaddr_next;
>> +
>> +	vaddr_end = vaddr + sz;
>> +
>> +	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
>> +		int psize, pmask, level;
>> +		unsigned long pfn;
>> +		pte_t *kpte;
>> +
>> +		kpte = lookup_address(vaddr, &level);
>> +		if (!kpte || pte_none(*kpte))
>> +			return;
>> +
>> +		switch (level) {
>> +		case PG_LEVEL_4K:
>> +			pfn = pte_pfn(*kpte);
>> +			break;
>> +		case PG_LEVEL_2M:
>> +			pfn = pmd_pfn(*(pmd_t *)kpte);
>> +			break;
>> +		case PG_LEVEL_1G:
>> +			pfn = pud_pfn(*(pud_t *)kpte);
>> +			break;
>> +		default:
>> +			return;
>> +		}
> 
> Pretty much that same thing is in __set_clr_pte_enc(). Make a helper
> function pls.
> 
>> +
>> +		psize = page_level_size(level);
>> +		pmask = page_level_mask(level);
>> +
>> +		kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
>> +				   pfn << PAGE_SHIFT, psize >> PAGE_SHIFT, enc);
>> +
>> +		vaddr_next = (vaddr & pmask) + psize;
>> +	}
> 
> As with other patches from Brijesh, that should be a while loop. :)
> 
>> +}
>> +
>>   static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>>   {
>>   	pgprot_t old_prot, new_prot;
>> @@ -286,12 +329,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>>   static int __init early_set_memory_enc_dec(unsigned long vaddr,
>>   					   unsigned long size, bool enc)
>>   {
>> -	unsigned long vaddr_end, vaddr_next;
>> +	unsigned long vaddr_end, vaddr_next, start;
>>   	unsigned long psize, pmask;
>>   	int split_page_size_mask;
>>   	int level, ret;
>>   	pte_t *kpte;
>>   
>> +	start = vaddr;
>>   	vaddr_next = vaddr;
>>   	vaddr_end = vaddr + size;
>>   
>> @@ -346,6 +390,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
>>   
>>   	ret = 0;
>>   
>> +	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
>> +					enc);
>>   out:
>>   	__flush_tlb_all();
>>   	return ret;
>> @@ -481,6 +527,15 @@ void __init mem_encrypt_init(void)
>>   	if (sev_active() && !sev_es_active())
>>   		static_branch_enable(&sev_enable_key);
>>   
>> +#ifdef CONFIG_PARAVIRT
>> +	/*
>> +	 * With SEV, we need to make a hypercall when page encryption state is
>> +	 * changed.
>> +	 */
>> +	if (sev_active())
>> +		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
>> +#endif
> 
> There's already a sev_active() check above it. Merge the two pls.
> 
>> +
>>   	print_mem_encrypt_feature_info();
>>   }
>>   
>> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
>> index 16f878c26667..3576b583ac65 100644
>> --- a/arch/x86/mm/pat/set_memory.c
>> +++ b/arch/x86/mm/pat/set_memory.c
>> @@ -27,6 +27,7 @@
>>   #include <asm/proto.h>
>>   #include <asm/memtype.h>
>>   #include <asm/set_memory.h>
>> +#include <asm/paravirt.h>
>>   
>>   #include "../mm_internal.h"
>>   
>> @@ -2012,6 +2013,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>>   	 */
>>   	cpa_flush(&cpa, 0);
>>   
>> +	/* Notify hypervisor that a given memory range is mapped encrypted
>> +	 * or decrypted. The hypervisor will use this information during the
>> +	 * VM migration.
>> +	 */
> 
> Kernel comments style is:
> 
> 	/*
> 	 * A sentence ending with a full-stop.
> 	 * Another sentence. ...
> 	 * More sentences. ...
> 	 */
> 

