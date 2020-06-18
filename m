Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1831F1FE9D2
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 06:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgFREOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 00:14:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52342 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbgFREOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 00:14:40 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6D0869EA1F87D160B4FF;
        Thu, 18 Jun 2020 12:14:37 +0800 (CST)
Received: from [10.173.221.230] (10.173.221.230) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 18 Jun 2020 12:13:50 +0800
Subject: Re: [PATCH 00/12] KVM: arm64: Support stage2 hardware DBM
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>
References: <20200616093553.27512-1-zhukeqian1@huawei.com>
CC:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <liangpeng10@huawei.com>, <zhengxiang9@huawei.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <f480d0dc-aaf8-c915-409c-d0f56812a49f@huawei.com>
Date:   Thu, 18 Jun 2020 12:13:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200616093553.27512-1-zhukeqian1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2020/6/16 17:35, Keqian Zhu wrote:
> This patch series add support for stage2 hardware DBM, and it is only
> used for dirty log for now.
> 
> It works well under some migration test cases, including VM with 4K
> pages or 2M THP. I checked the SHA256 hash digest of all memory and
> they keep same for source VM and destination VM, which means no dirty
> pages is missed under hardware DBM.
> 
> Some key points:
> 
> 1. Only support hardware updates of dirty status for PTEs. PMDs and PUDs
>    are not involved for now.
> 
> 2. About *performance*: In RFC patch, I have mentioned that for every 64GB
>    memory, KVM consumes about 40ms to scan all PTEs to collect dirty log.
>    
>    Initially, I plan to solve this problem using parallel CPUs. However
>    I faced two problems.
> 
>    The first is bottleneck of memory bandwith. Single thread will occupy
>    bandwidth about 500GB/s, we can support about 4 parallel threads at
>    most, so the ideal speedup ratio is low.
Aha, I make it wrong here. I test it again, and find that speedup ratio can
be about 23x when I use 32 CPUs to scan PTs (takes about 5ms when scanning PTs
of 200GB RAM).

> 
>    The second is huge impact on other CPUs. To scan PTs quickly, I use
>    smp_call_function_many, which is based on IPI, to dispatch workload
>    on other CPUs. Though it can complete work in time, the interrupt is
>    disabled during scaning PTs, which has huge impact on other CPUs.
I think we can divide scanning workload into smaller ones, which can disable
and enable interrupts periodly.

> 
>    Now, I make hardware dirty log can be dynamic enabled and disabled.
>    Userspace can enable it before VM migration and disable it when
>    remaining dirty pages is little. Thus VM downtime is not affected. 
BTW, we can reserve this interface for userspace if CPU computing resources
are not enough.

Thanks,
Keqian
> 
> 
> 3. About correctness: Only add DBM bit when PTE is already writable, so
>    we still have readonly PTE and some mechanisms which rely on readonly
>    PTs are not broken.
> 
> 4. About PTs modification races: There are two kinds of PTs modification.
>    
>    The first is adding or clearing specific bit, such as AF or RW. All
>    these operations have been converted to be atomic, avoid covering
>    dirty status set by hardware.
>    
>    The second is replacement, such as PTEs unmapping or changement. All
>    these operations will invoke kvm_set_pte finally. kvm_set_pte have
>    been converted to be atomic and we save the dirty status to underlying
>    bitmap if dirty status is coverred.
> 
> 
> Keqian Zhu (12):
>   KVM: arm64: Add some basic functions to support hw DBM
>   KVM: arm64: Modify stage2 young mechanism to support hw DBM
>   KVM: arm64: Report hardware dirty status of stage2 PTE if coverred
>   KVM: arm64: Support clear DBM bit for PTEs
>   KVM: arm64: Add KVM_CAP_ARM_HW_DIRTY_LOG capability
>   KVM: arm64: Set DBM bit of PTEs during write protecting
>   KVM: arm64: Scan PTEs to sync dirty log
>   KVM: Omit dirty log sync in log clear if initially all set
>   KVM: arm64: Steply write protect page table by mask bit
>   KVM: arm64: Save stage2 PTE dirty status if it is coverred
>   KVM: arm64: Support disable hw dirty log after enable
>   KVM: arm64: Enable stage2 hardware DBM
> 
>  arch/arm64/include/asm/kvm_host.h |  11 +
>  arch/arm64/include/asm/kvm_mmu.h  |  56 +++-
>  arch/arm64/include/asm/sysreg.h   |   2 +
>  arch/arm64/kvm/arm.c              |  22 +-
>  arch/arm64/kvm/mmu.c              | 411 ++++++++++++++++++++++++++++--
>  arch/arm64/kvm/reset.c            |  14 +-
>  include/uapi/linux/kvm.h          |   1 +
>  tools/include/uapi/linux/kvm.h    |   1 +
>  virt/kvm/kvm_main.c               |   7 +-
>  9 files changed, 499 insertions(+), 26 deletions(-)
> 
