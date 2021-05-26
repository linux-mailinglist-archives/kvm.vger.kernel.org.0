Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E76639105F
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 08:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhEZGLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 02:11:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:4009 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbhEZGLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 02:11:02 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FqgT85qz9zmZ9F;
        Wed, 26 May 2021 14:07:08 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 14:09:29 +0800
Received: from [10.67.77.175] (10.67.77.175) by dggpeml500023.china.huawei.com
 (7.185.36.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 26 May
 2021 14:09:29 +0800
Subject: Re: [PATCH] KVM: x86/mmu: Remove the repeated declaration
To:     Sean Christopherson <seanjc@google.com>
CC:     <x86@kernel.org>, <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <1621910615-29985-1-git-send-email-zhangshaokun@hisilicon.com>
 <YK0hPadppDR1sPaD@google.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <b0e4d53e-c59e-bebc-a6c3-22f89e1c0a5f@hisilicon.com>
Date:   Wed, 26 May 2021 14:09:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YK0hPadppDR1sPaD@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.77.175]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 2021/5/26 0:09, Sean Christopherson wrote:
> On Tue, May 25, 2021, Shaokun Zhang wrote:
>> Function 'is_nx_huge_page_enabled' is declared twice, remove the
>> repeated declaration.
>>
>> Cc: Ben Gardon <bgardon@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
>> ---
>>  arch/x86/kvm/mmu/mmu_internal.h | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
>> index d64ccb417c60..54c6e6193ff2 100644
>> --- a/arch/x86/kvm/mmu/mmu_internal.h
>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
>> @@ -158,8 +158,6 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
>>  void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
>>  				kvm_pfn_t *pfnp, int *goal_levelp);
>>  
>> -bool is_nx_huge_page_enabled(void);
> 
> Rather than simply delete the extra declaration, what about converting this to
> static inline and opportunistically deleting the duplicate?  The implementation

It seems that you want to make it static inline in mmu_internal.h, right?

> is a single operation and this is MMU-internal, i.e. there's no need to export
> and limited exposure of nx_huge_pages to other code.

If is_nx_huge_page_enabled is inline in mmu_internal.h, nx_huge_pages will be
external in mmu_internal.h and exposed to other code. Do I miss something?

Thanks,
Shaokun

> 
>> -
>>  void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>>  
>>  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>> -- 
>> 2.7.4
>>
> .
> 
