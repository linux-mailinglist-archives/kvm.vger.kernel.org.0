Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C36817F1E8
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 09:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgCJI0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 04:26:35 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11612 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725919AbgCJI0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 04:26:35 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E5E52B5FFA0075FDFCFE;
        Tue, 10 Mar 2020 16:26:25 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.230) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Tue, 10 Mar 2020
 16:26:19 +0800
Subject: Re: [RFC] KVM: arm64: support enabling dirty log graually in small
 chunks
To:     Marc Zyngier <maz@kernel.org>
References: <20200309085727.1106-1-zhukeqian1@huawei.com>
 <4b85699ec1d354cc73f5302560231f86@misterjones.org>
CC:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Jay Zhou" <jianjay.zhou@huawei.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <64925c8b-af3d-beb5-bc9b-66ef1e47f92d@huawei.com>
Date:   Tue, 10 Mar 2020 16:26:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <4b85699ec1d354cc73f5302560231f86@misterjones.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/3/9 19:45, Marc Zyngier wrote:
> Kegian,
> 
> In the future, please Cc me on  your KVM/arm64 patches, as well as
> all the reviewers mentioned in the MAINTAINERS file.
> 
> On 2020-03-09 08:57, Keqian Zhu wrote:
>> There is already support of enabling dirty log graually
> 
> gradually?
> 
Yeah, gradually. :)
>> in small chunks for x86. This adds support for arm64.
>>
>> Under the Huawei Kunpeng 920 2.6GHz platform, I did some
>> tests with a 128G linux VM and counted the time taken of
> 
> Linux
Thanks.
> 
>> memory_global_dirty_log_start, here is the numbers:
>>
>> VM Size        Before    After optimization
>> 128G           527ms     4ms
> 
> What does this benchmark do? Can you please provide a pointer to it?
> 
I will explain this in following text.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>> Cc: Jay Zhou <jianjay.zhou@huawei.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Peter Xu <peterx@redhat.com>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> ---
>>  Documentation/virt/kvm/api.rst    |  2 +-
>>  arch/arm64/include/asm/kvm_host.h |  4 ++++
>>  virt/kvm/arm/mmu.c                | 30 ++++++++++++++++++++++--------
>>  3 files changed, 27 insertions(+), 9 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 0adef66585b1..89d4f2680af1 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -5735,7 +5735,7 @@ will be initialized to 1 when created.  This
>> also improves performance because
>>  dirty logging can be enabled gradually in small chunks on the first call
>>  to KVM_CLEAR_DIRTY_LOG.  KVM_DIRTY_LOG_INITIALLY_SET depends on
>>  KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE (it is also only available on
>> -x86 for now).
>> +x86 and arm64 for now).
> 
> What is this based on? I can't find this in -next, and you provide no
> context whatsoever.
This is based on branch "queue" of git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> 
> I assume this is related to this:
> https://lore.kernel.org/kvm/20200227013227.1401-1-jianjay.zhou@huawei.com/
> 
Yes, you are right.

The background is that in [https://patchwork.kernel.org/cover/10702447/], Paolo
made an optimization for dirty log sync used by VM migration. Currently the dirty
log sync logic is getting and clearing dirty log at the same time for each KVM
memslot. This will lead to obvious problem for large guests.

As described by Paolo, "First, and less important, it can take kvm->mmu_lock for
an extended period of time.  Second, its user can actually see many false positives
in some cases." There will be enough time for guests mark page dirty again between
Qemu synchronizes dirty log and actually sends these page, so both guests and Qemu
will suffer unnecessary overhead.

Paolo introduced a new KVM ioctl. "The new KVM_CLEAR_DIRTY_LOG ioctl can operate
on a 64-page granularity rather than requiring to sync a full memslot. This way
the mmu_lock is taken for small amounts of time, and only a small amount of time
will pass between write protection of pages and the sending of their content."

The changes made by Paolo have been merge to mainline kernel. And the userspace
counterpart (Qemu) also has been updated.

After that, Jay Zhou declared an optimization about enable dirty log (The link you
paste above) based on Paolo's work. When enabling dirty log, we dont need to write
protect PTEs now. All PTEs will be write protected after first round RAM sending.

> Is there a userspace counterpart to it?
> 
As this KVM/x86 related changes have not been merged to mainline kernel, some little
modification is needed on mainline Qemu.

As I tested this patch on a 128GB RAM Linux VM with no huge pages, the time of enabling
dirty log will decrease obviously.

>>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 was previously available under the name
>>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT, but the implementation had bugs that make
>> diff --git a/arch/arm64/include/asm/kvm_host.h
>> b/arch/arm64/include/asm/kvm_host.h
>> index d87aa609d2b6..0deb2ac7d091 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -16,6 +16,7 @@
>>  #include <linux/jump_label.h>
>>  #include <linux/kvm_types.h>
>>  #include <linux/percpu.h>
>> +#include <linux/kvm.h>
>>  #include <asm/arch_gicv3.h>
>>  #include <asm/barrier.h>
>>  #include <asm/cpufeature.h>
>> @@ -45,6 +46,9 @@
>>  #define KVM_REQ_VCPU_RESET    KVM_ARCH_REQ(2)
>>  #define KVM_REQ_RECORD_STEAL    KVM_ARCH_REQ(3)
>>
>> +#define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>> +                    KVM_DIRTY_LOG_INITIALLY_SET)
>> +
>>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>>
>>  extern unsigned int kvm_sve_max_vl;
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index e3b9ee268823..5c7ca84dec85 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1438,9 +1438,11 @@ static void stage2_wp_ptes(pmd_t *pmd,
>> phys_addr_t addr, phys_addr_t end)
>>   * @pud:    pointer to pud entry
>>   * @addr:    range start address
>>   * @end:    range end address
>> + * @wp_ptes:    write protect ptes or not
>>   */
>>  static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
>> -               phys_addr_t addr, phys_addr_t end)
>> +               phys_addr_t addr, phys_addr_t end,
>> +               bool wp_ptes)
> 
> If you are going to pass extra parameters like this, make it at least
> extensible (unsigned long flags, for example).
> 
OK, I will use flags in formal patch.
>>  {
>>      pmd_t *pmd;
>>      phys_addr_t next;
>> @@ -1453,7 +1455,7 @@ static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
>>              if (pmd_thp_or_huge(*pmd)) {
>>                  if (!kvm_s2pmd_readonly(pmd))
>>                      kvm_set_s2pmd_readonly(pmd);
>> -            } else {
>> +            } else if (wp_ptes) {
>>                  stage2_wp_ptes(pmd, addr, next);
>>              }
>>          }
[...]

Thanks,
keqian

