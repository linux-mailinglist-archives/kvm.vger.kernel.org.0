Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD781CFB58
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 18:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgELQxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 12:53:22 -0400
Received: from foss.arm.com ([217.140.110.172]:58652 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgELQxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 12:53:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5104B1FB;
        Tue, 12 May 2020 09:53:21 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A5E93F305;
        Tue, 12 May 2020 09:53:19 -0700 (PDT)
Subject: Re: [PATCH 03/26] KVM: arm64: Factor out stage 2 page table data from
 struct kvm
To:     James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-4-maz@kernel.org>
 <a7c8207c-9061-ad0e-c9f8-64c995e928b6@arm.com>
 <76d811eb-b304-c49f-1f21-fe9d95112a28@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <6518439c-65b7-1e87-a21d-a053d75c0514@arm.com>
Date:   Tue, 12 May 2020 17:53:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <76d811eb-b304-c49f-1f21-fe9d95112a28@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/12/20 12:17 PM, James Morse wrote:
> Hi Alex, Marc,
>
> (just on this last_vcpu_ran thing...)
>
> On 11/05/2020 17:38, Alexandru Elisei wrote:
>> On 4/22/20 1:00 PM, Marc Zyngier wrote:
>>> From: Christoffer Dall <christoffer.dall@arm.com>
>>>
>>> As we are about to reuse our stage 2 page table manipulation code for
>>> shadow stage 2 page tables in the context of nested virtualization, we
>>> are going to manage multiple stage 2 page tables for a single VM.
>>>
>>> This requires some pretty invasive changes to our data structures,
>>> which moves the vmid and pgd pointers into a separate structure and
>>> change pretty much all of our mmu code to operate on this structure
>>> instead.
>>>
>>> The new structure is called struct kvm_s2_mmu.
>>>
>>> There is no intended functional change by this patch alone.
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 7dd8fefa6aecd..664a5d92ae9b8 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -63,19 +63,32 @@ struct kvm_vmid {
>>>  	u32    vmid;
>>>  };
>>>  
>>> -struct kvm_arch {
>>> +struct kvm_s2_mmu {
>>>  	struct kvm_vmid vmid;
>>>  
>>> -	/* stage2 entry level table */
>>> -	pgd_t *pgd;
>>> -	phys_addr_t pgd_phys;
>>> -
>>> -	/* VTCR_EL2 value for this VM */
>>> -	u64    vtcr;
>>> +	/*
>>> +	 * stage2 entry level table
>>> +	 *
>>> +	 * Two kvm_s2_mmu structures in the same VM can point to the same pgd
>>> +	 * here.  This happens when running a non-VHE guest hypervisor which
>>> +	 * uses the canonical stage 2 page table for both vEL2 and for vEL1/0
>>> +	 * with vHCR_EL2.VM == 0.
>> It makes more sense to me to say that a non-VHE guest hypervisor will use the
>> canonical stage *1* page table when running at EL2
> Can KVM say anything about stage1? Its totally under the the guests control even at vEL2...

It just occurred to me that "canonical stage 2 page table" refers to the L0
hypervisor stage 2, not to the L1 hypervisor stage 2. If you don't mind my
suggestion, perhaps the comment can be slightly improved to avoid any confusion?
Maybe something along the lines of "[..] This happens when running a non-VHE guest
hypervisor, in which case we use the canonical stage 2 page table for both vEL2
and for vEL1/0 with vHCR_EL2.VM == 0".

Thanks,
Alex
