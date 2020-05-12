Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E954A1CF3F4
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 14:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgELMEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 08:04:38 -0400
Received: from foss.arm.com ([217.140.110.172]:53518 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729408AbgELMEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 08:04:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 073B130E;
        Tue, 12 May 2020 05:04:38 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F7063F71E;
        Tue, 12 May 2020 05:04:36 -0700 (PDT)
Subject: Re: [PATCH 08/26] KVM: arm64: Use TTL hint in when invalidating
 stage-2 translations
To:     Andrew Scull <ascull@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Andre Przywara <andre.przywara@arm.com>,
        kvmarm@lists.cs.columbia.edu,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Dave Martin <Dave.Martin@arm.com>,
        linux-arm-kernel@lists.infradead.org
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-9-maz@kernel.org>
 <20200507151321.GH237572@google.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <63e16fdd-fe1b-07d3-23b7-cd99170fdd59@arm.com>
Date:   Tue, 12 May 2020 13:04:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200507151321.GH237572@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On 07/05/2020 16:13, Andrew Scull wrote:
>> @@ -176,7 +177,7 @@ static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr
>>  	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
>>  	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
>>  	stage2_pud_clear(kvm, pud);
>> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
>> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
>>  	stage2_pmd_free(kvm, pmd_table);
>>  	put_page(virt_to_page(pud));
>>  }
>> @@ -186,7 +187,7 @@ static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu, pmd_t *pmd, phys_addr
>>  	pte_t *pte_table = pte_offset_kernel(pmd, 0);
>>  	VM_BUG_ON(pmd_thp_or_huge(*pmd));
>>  	pmd_clear(pmd);
>> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
>> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
>>  	free_page((unsigned long)pte_table);
>>  	put_page(virt_to_page(pmd));
>>  }
> 
> Going by the names, is it possible to give a better level hint for these
> cases?

There is no leaf entry being invalidated here. After clearing the range, we found we'd
emptied (and invalidated) a whole page of mappings:
|	if (stage2_pmd_table_empty(kvm, start_pmd))
|		clear_stage2_pud_entry(mmu, pud, start_addr);

Now we want to remove the link to the empty page so we can free it. We are changing the
structure of the tables, not what gets mapped.

I think this is why we need the un-hinted behaviour, to invalidate "any level of the
translation table walk required to translate the specified IPA". Otherwise the hardware
can look for a leaf at the indicated level, find none, and do nothing.


This is sufficiently horrible, its possible I've got it completely wrong! (does it make
sense?)


Thanks,

James
