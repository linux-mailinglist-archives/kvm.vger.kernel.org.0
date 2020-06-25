Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB32209E51
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 14:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404694AbgFYMTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 08:19:19 -0400
Received: from foss.arm.com ([217.140.110.172]:40206 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404343AbgFYMTS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 08:19:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A0751FB;
        Thu, 25 Jun 2020 05:19:18 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 073353F73C;
        Thu, 25 Jun 2020 05:19:15 -0700 (PDT)
Subject: Re: [PATCH v2 01/17] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
To:     Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com,
        kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        kvmarm@lists.cs.columbia.edu,
        George Cherian <gcherian@marvell.com>,
        James Morse <james.morse@arm.com>,
        Andrew Scull <ascull@google.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Will Deacon <will@kernel.org>,
        Dave Martin <Dave.Martin@arm.com>,
        linux-arm-kernel@lists.infradead.org
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-2-maz@kernel.org>
 <17d37bde-2fc8-d165-ee02-7640fc561167@arm.com>
 <9c0044564885d3356f76b55f35426987@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d3804b25-4ce4-b263-c087-d8e563f939ed@arm.com>
Date:   Thu, 25 Jun 2020 13:19:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <9c0044564885d3356f76b55f35426987@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/16/20 5:18 PM, Marc Zyngier wrote:
> Hi Alexandru,
> [..]
>>> [..]
>>>
>>>  /**
>>> - * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 translation.
>>> - * @kvm:    The KVM struct pointer for the VM.
>>> + * kvm_init_stage2_mmu - Initialise a S2 MMU strucrure
>>> + * @kvm:    The pointer to the KVM structure
>>> + * @mmu:    The pointer to the s2 MMU structure
>>>   *
>>>   * Allocates only the stage-2 HW PGD level table(s) of size defined by
>>> - * stage2_pgd_size(kvm).
>>> + * stage2_pgd_size(mmu->kvm).
>>>   *
>>>   * Note we don't need locking here as this is only called when the VM is
>>>   * created, which can only be done once.
>>>   */
>>> -int kvm_alloc_stage2_pgd(struct kvm *kvm)
>>> +int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>>>  {
>>>      phys_addr_t pgd_phys;
>>>      pgd_t *pgd;
>>> +    int cpu;
>>>
>>> -    if (kvm->arch.pgd != NULL) {
>>> +    if (mmu->pgd != NULL) {
>>>          kvm_err("kvm_arch already initialized?\n");
>>>          return -EINVAL;
>>>      }
>>> @@ -1024,8 +1040,20 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
>>>      if (WARN_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm)))
>>>          return -EINVAL;
>>
>> We don't free the pgd if we get the error above, but we do free it below, if
>> allocating last_vcpu_ran fails. Shouldn't we free it in both cases?
>
> Worth investigating. This code gets majorly revamped in the NV series, so it is
> likely that I missed something in the middle.

You didn't miss anything, I checked and it's the same in the upstream version of KVM.

kvm_arch_init_vm() returns with an error if this functions fails, so it's up to
the function to do the clean up. kvm_alloc_pages_exact() returns NULL on error, so
at this point we have a valid allocation of physical contiguous pages. Failing to
create a VM is not a fatal error for the system, so I'm thinking that maybe we
should free those pages for the rest of the system to use. However, this is a
minor issue, and the patch isn't supposed to make any functional changes, so it
can be probably be left for another patch and not add more to an already big series.

Thanks,
Alex
