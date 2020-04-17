Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E191AD986
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 11:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730114AbgDQJKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 05:10:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2397 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729987AbgDQJKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 05:10:17 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2063C4944C6BE347FA91;
        Fri, 17 Apr 2020 17:10:15 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.230) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Apr 2020
 17:10:07 +0800
Subject: Re: [PATCH v2] KVM/arm64: Support enabling dirty log gradually in
 small chunks
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20200413122023.52583-1-zhukeqian1@huawei.com>
 <be45ec89-2bdb-454b-d20a-c08898e26024@redhat.com>
 <20200416160939.7e9c1621@why>
 <442f288e-2934-120c-4994-5357e3e9216b@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jay Zhou <jianjay.zhou@huawei.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <3e3ce7dd-af13-6daa-9ccf-747405d448cc@huawei.com>
Date:   Fri, 17 Apr 2020 17:10:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <442f288e-2934-120c-4994-5357e3e9216b@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 2020/4/16 23:55, Paolo Bonzini wrote:
> On 16/04/20 17:09, Marc Zyngier wrote:
>> On Wed, 15 Apr 2020 18:13:56 +0200
>> Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>>> On 13/04/20 14:20, Keqian Zhu wrote:
>>>> There is already support of enabling dirty log graually in small chunks
>>>> for x86 in commit 3c9bd4006bfc ("KVM: x86: enable dirty log gradually in
>>>> small chunks"). This adds support for arm64.
>>>>
>>>> x86 still writes protect all huge pages when DIRTY_LOG_INITIALLY_ALL_SET
>>>> is eanbled. However, for arm64, both huge pages and normal pages can be
>>>> write protected gradually by userspace.
>>>>
>>>> Under the Huawei Kunpeng 920 2.6GHz platform, I did some tests on 128G
>>>> Linux VMs with different page size. The memory pressure is 127G in each
>>>> case. The time taken of memory_global_dirty_log_start in QEMU is listed
>>>> below:
>>>>
>>>> Page Size      Before    After Optimization
>>>>   4K            650ms         1.8ms
>>>>   2M             4ms          1.8ms
>>>>   1G             2ms          1.8ms
>>>>
>>>> Besides the time reduction, the biggest income is that we will minimize
>>>> the performance side effect (because of dissloving huge pages and marking
>>>> memslots dirty) on guest after enabling dirty log.
>>>>
>>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>>>> ---
>>>>  Documentation/virt/kvm/api.rst    |  2 +-
>>>>  arch/arm64/include/asm/kvm_host.h |  3 +++
>>>>  virt/kvm/arm/mmu.c                | 12 ++++++++++--
>>>>  3 files changed, 14 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>>> index efbbe570aa9b..0017f63fa44f 100644
>>>> --- a/Documentation/virt/kvm/api.rst
>>>> +++ b/Documentation/virt/kvm/api.rst
>>>> @@ -5777,7 +5777,7 @@ will be initialized to 1 when created.  This also improves performance because
>>>>  dirty logging can be enabled gradually in small chunks on the first call
>>>>  to KVM_CLEAR_DIRTY_LOG.  KVM_DIRTY_LOG_INITIALLY_SET depends on
>>>>  KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE (it is also only available on
>>>> -x86 for now).
>>>> +x86 and arm64 for now).
>>>>  
>>>>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 was previously available under the name
>>>>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT, but the implementation had bugs that make
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index 32c8a675e5a4..a723f84fab83 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -46,6 +46,9 @@
>>>>  #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
>>>>  #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
>>>>  
>>>> +#define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>>>> +				     KVM_DIRTY_LOG_INITIALLY_SET)
>>>> +
>>>>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>>>>  
>>>>  extern unsigned int kvm_sve_max_vl;
>>>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>>>> index e3b9ee268823..1077f653a611 100644
>>>> --- a/virt/kvm/arm/mmu.c
>>>> +++ b/virt/kvm/arm/mmu.c
>>>> @@ -2265,8 +2265,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>>>  	 * allocated dirty_bitmap[], dirty pages will be be tracked while the
>>>>  	 * memory slot is write protected.
>>>>  	 */
>>>> -	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
>>>> -		kvm_mmu_wp_memory_region(kvm, mem->slot);
>>>> +	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>>>> +		/*
>>>> +		 * If we're with initial-all-set, we don't need to write
>>>> +		 * protect any pages because they're all reported as dirty.
>>>> +		 * Huge pages and normal pages will be write protect gradually.
>>>> +		 */
>>>> +		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
>>>> +			kvm_mmu_wp_memory_region(kvm, mem->slot);
>>>> +		}
>>>> +	}
>>>>  }
>>>>  
>>>>  int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>>>   
>>>
>>> Marc, what is the status of this patch?
>>
>> I just had a look at it. Is there any urgency for merging it?
> 
> No, I thought I was still replying to the v1.
Sorry that patch v1 is dropped. Because I realized that stage2 page tables
will be unmapped during VM reboot, or they are not established soon after
migration, so stage2 page tables can not be used to decide whether a page
is needed to migrate.

Thanks,
Keqian

> 
> Paolo
> 
> 
> .
> 

