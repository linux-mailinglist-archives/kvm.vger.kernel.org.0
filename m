Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F68F1ADA56
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 11:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDQJrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 05:47:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2348 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725830AbgDQJrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 05:47:13 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D82F383C57B3FD2E2153;
        Fri, 17 Apr 2020 17:47:10 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.230) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Apr 2020
 17:47:00 +0800
Subject: Re: [PATCH v2] KVM/arm64: Support enabling dirty log gradually in
 small chunks
To:     Marc Zyngier <maz@kernel.org>
References: <20200413122023.52583-1-zhukeqian1@huawei.com>
 <20200416160833.728017e9@why>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jay Zhou <jianjay.zhou@huawei.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <44ce4553-5215-2290-5956-2e6c577d030b@huawei.com>
Date:   Fri, 17 Apr 2020 17:46:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200416160833.728017e9@why>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/4/16 23:08, Marc Zyngier wrote:
> On Mon, 13 Apr 2020 20:20:23 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> There is already support of enabling dirty log graually in small chunks
> 
> gradually
> 
>> for x86 in commit 3c9bd4006bfc ("KVM: x86: enable dirty log gradually in
>> small chunks"). This adds support for arm64.
>>
>> x86 still writes protect all huge pages when DIRTY_LOG_INITIALLY_ALL_SET
>> is eanbled. However, for arm64, both huge pages and normal pages can be
> 
> enabled
> 
>> write protected gradually by userspace.
>>
>> Under the Huawei Kunpeng 920 2.6GHz platform, I did some tests on 128G
>> Linux VMs with different page size. The memory pressure is 127G in each
>> case. The time taken of memory_global_dirty_log_start in QEMU is listed
>> below:
>>
>> Page Size      Before    After Optimization
>>   4K            650ms         1.8ms
>>   2M             4ms          1.8ms
>>   1G             2ms          1.8ms
> 
> These numbers are different from what you have advertised before. What
> changed?
In patch RFC, the numbers is got when memory pressure is 100G, so the number
is bigger here.
> 
>>
>> Besides the time reduction, the biggest income is that we will minimize
> 
> s/income/improvement/
> 
>> the performance side effect (because of dissloving huge pages and marking
> 
> dissolving
embarrassed for these misspell :(
> 
>> memslots dirty) on guest after enabling dirty log.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  Documentation/virt/kvm/api.rst    |  2 +-
>>  arch/arm64/include/asm/kvm_host.h |  3 +++
>>  virt/kvm/arm/mmu.c                | 12 ++++++++++--
>>  3 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index efbbe570aa9b..0017f63fa44f 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -5777,7 +5777,7 @@ will be initialized to 1 when created.  This also improves performance because
>>  dirty logging can be enabled gradually in small chunks on the first call
>>  to KVM_CLEAR_DIRTY_LOG.  KVM_DIRTY_LOG_INITIALLY_SET depends on
>>  KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE (it is also only available on
>> -x86 for now).
>> +x86 and arm64 for now).
>>  
>>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 was previously available under the name
>>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT, but the implementation had bugs that make
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 32c8a675e5a4..a723f84fab83 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -46,6 +46,9 @@
>>  #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
>>  #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
>>  
>> +#define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>> +				     KVM_DIRTY_LOG_INITIALLY_SET)
>> +
>>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>>  
>>  extern unsigned int kvm_sve_max_vl;
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index e3b9ee268823..1077f653a611 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -2265,8 +2265,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>  	 * allocated dirty_bitmap[], dirty pages will be be tracked while the
>>  	 * memory slot is write protected.
>>  	 */
>> -	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
>> -		kvm_mmu_wp_memory_region(kvm, mem->slot);
>> +	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>> +		/*
>> +		 * If we're with initial-all-set, we don't need to write
>> +		 * protect any pages because they're all reported as dirty.
>> +		 * Huge pages and normal pages will be write protect gradually.
>> +		 */
>> +		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
>> +			kvm_mmu_wp_memory_region(kvm, mem->slot);
>> +		}
>> +	}
>>  }
>>  
>>  int kvm_arch_prepare_memory_region(struct kvm *kvm,
> 
> As it is, it is pretty good. The one thing that isn't clear to me is
> why we have a difference in behaviour between x86 and arm64. What
> prevents x86 from having the same behaviour as arm64?
I am also not very clear about the difference. Maybe there is historic reason.

Before introducing DIRTY_LOG_INITIALLY_ALL_SET, all pages will be write
protected when starting dirty log, but only normal pages are needed
to be write protected again during dirty log sync, because huge pages will
be dissolved to normal pages.

For that x86 uses different routine to write protect huge pages and normal pages,
and arm64 uses same routine to do this, so arm64 still write protect all
pages again during dirty log sync, but x86 didn't.

So I think that x86 can write protect huge pages gradually too, just need to add
some code legs in dirty log sync.

Thanks,
Keqian
> 
> Thanks,
> 
> 	M.
> 

