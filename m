Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C231E3C41
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 10:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388070AbgE0Ila (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 04:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387858AbgE0Il3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 04:41:29 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF36120723;
        Wed, 27 May 2020 08:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590568888;
        bh=E378D1wkdmQfMiop/fBX66cdxZ0b9zhjf0U/fYZnvBk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nmjnrOt6WgNE82CBCmt4ZJ8pDHHi6T+/y6D/ivIGYua+SXBSlKOrfbiEBriENHmGv
         xWvu55Jfjl8GQN0O46HWurgC/PJfj3r1bBcFfphCXq2Z8Y+FzkWo58iaQdFLBFaQbu
         aEHmcEhuDX/LU957RhGmlO3saI7YCobglXKif+mM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jdrct-00Fe3b-6m; Wed, 27 May 2020 09:41:27 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 27 May 2020 09:41:27 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
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
Subject: Re: [PATCH 03/26] KVM: arm64: Factor out stage 2 page table data from
 struct kvm
In-Reply-To: <6518439c-65b7-1e87-a21d-a053d75c0514@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-4-maz@kernel.org>
 <a7c8207c-9061-ad0e-c9f8-64c995e928b6@arm.com>
 <76d811eb-b304-c49f-1f21-fe9d95112a28@arm.com>
 <6518439c-65b7-1e87-a21d-a053d75c0514@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <ea603b3a7a51a597263e7c8152f4c795@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2020-05-12 17:53, Alexandru Elisei wrote:
> Hi,
> 
> On 5/12/20 12:17 PM, James Morse wrote:
>> Hi Alex, Marc,
>> 
>> (just on this last_vcpu_ran thing...)
>> 
>> On 11/05/2020 17:38, Alexandru Elisei wrote:
>>> On 4/22/20 1:00 PM, Marc Zyngier wrote:
>>>> From: Christoffer Dall <christoffer.dall@arm.com>
>>>> 
>>>> As we are about to reuse our stage 2 page table manipulation code 
>>>> for
>>>> shadow stage 2 page tables in the context of nested virtualization, 
>>>> we
>>>> are going to manage multiple stage 2 page tables for a single VM.
>>>> 
>>>> This requires some pretty invasive changes to our data structures,
>>>> which moves the vmid and pgd pointers into a separate structure and
>>>> change pretty much all of our mmu code to operate on this structure
>>>> instead.
>>>> 
>>>> The new structure is called struct kvm_s2_mmu.
>>>> 
>>>> There is no intended functional change by this patch alone.
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h 
>>>> b/arch/arm64/include/asm/kvm_host.h
>>>> index 7dd8fefa6aecd..664a5d92ae9b8 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -63,19 +63,32 @@ struct kvm_vmid {
>>>>  	u32    vmid;
>>>>  };
>>>> 
>>>> -struct kvm_arch {
>>>> +struct kvm_s2_mmu {
>>>>  	struct kvm_vmid vmid;
>>>> 
>>>> -	/* stage2 entry level table */
>>>> -	pgd_t *pgd;
>>>> -	phys_addr_t pgd_phys;
>>>> -
>>>> -	/* VTCR_EL2 value for this VM */
>>>> -	u64    vtcr;
>>>> +	/*
>>>> +	 * stage2 entry level table
>>>> +	 *
>>>> +	 * Two kvm_s2_mmu structures in the same VM can point to the same 
>>>> pgd
>>>> +	 * here.  This happens when running a non-VHE guest hypervisor 
>>>> which
>>>> +	 * uses the canonical stage 2 page table for both vEL2 and for 
>>>> vEL1/0
>>>> +	 * with vHCR_EL2.VM == 0.
>>> It makes more sense to me to say that a non-VHE guest hypervisor will 
>>> use the
>>> canonical stage *1* page table when running at EL2
>> Can KVM say anything about stage1? Its totally under the the guests 
>> control even at vEL2...
> 
> It just occurred to me that "canonical stage 2 page table" refers to 
> the L0
> hypervisor stage 2, not to the L1 hypervisor stage 2. If you don't mind 
> my
> suggestion, perhaps the comment can be slightly improved to avoid any 
> confusion?
> Maybe something along the lines of "[..] This happens when running a
> non-VHE guest
> hypervisor, in which case we use the canonical stage 2 page table for 
> both vEL2
> and for vEL1/0 with vHCR_EL2.VM == 0".

If the confusion stems from the lack of guest stage-2, how about:

"This happens when running a guest using a translation regime that isn't
  affected by its own stage-2 translation, such as a non-VHE hypervisor
  running at vEL2, or for vEL1/EL0 with vHCR_EL2.VM == 0. In that case,
  we use the canonical stage-2 page tables."

instead? Does this lift the ambiguity?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
