Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39A7215721
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 14:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgGFMRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 08:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727896AbgGFMRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 08:17:34 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49A3F2070C;
        Mon,  6 Jul 2020 12:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594037853;
        bh=KuxlYi/WPeTd60f/cMp3naUg3QZOGwvNaBWXU66jIVE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CgttgXoal5cvnNee8/vDQpHse3xCG5b9UzDhFHkcuTafKGilaGK2bDf0F0nsTECi5
         vpQnUWxcleiB4DOEcoQ90TVvF1AYQEUmfZZ9243cL4JvJa3nfLQKAwtpRj1M2ncV/r
         GU0xUFi+YHrWj9cX8fvPCLkse+RK0KbdaUylhHyE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jsQ3v-009Rdk-KW; Mon, 06 Jul 2020 13:17:31 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 06 Jul 2020 13:17:31 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
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
Subject: Re: [PATCH v2 01/17] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
In-Reply-To: <d3804b25-4ce4-b263-c087-d8e563f939ed@arm.com>
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-2-maz@kernel.org>
 <17d37bde-2fc8-d165-ee02-7640fc561167@arm.com>
 <9c0044564885d3356f76b55f35426987@kernel.org>
 <d3804b25-4ce4-b263-c087-d8e563f939ed@arm.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <b3f34d53dfe8bc3c2b0838187fe12538@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, mark.rutland@arm.com, kernel-team@android.com, kvm@vger.kernel.org, suzuki.poulose@arm.com, jintack@cs.columbia.edu, andre.przywara@arm.com, christoffer.dall@arm.com, kvmarm@lists.cs.columbia.edu, gcherian@marvell.com, james.morse@arm.com, ascull@google.com, prime.zeng@hisilicon.com, catalin.marinas@arm.com, julien.thierry.kdev@gmail.com, will@kernel.org, Dave.Martin@arm.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-06-25 13:19, Alexandru Elisei wrote:
> Hi Marc,
> 
> On 6/16/20 5:18 PM, Marc Zyngier wrote:
>> Hi Alexandru,
>> [..]
>>>> [..]
>>>> 
>>>>  /**
>>>> - * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 
>>>> translation.
>>>> - * @kvm:    The KVM struct pointer for the VM.
>>>> + * kvm_init_stage2_mmu - Initialise a S2 MMU strucrure
>>>> + * @kvm:    The pointer to the KVM structure
>>>> + * @mmu:    The pointer to the s2 MMU structure
>>>>   *
>>>>   * Allocates only the stage-2 HW PGD level table(s) of size defined 
>>>> by
>>>> - * stage2_pgd_size(kvm).
>>>> + * stage2_pgd_size(mmu->kvm).
>>>>   *
>>>>   * Note we don't need locking here as this is only called when the 
>>>> VM is
>>>>   * created, which can only be done once.
>>>>   */
>>>> -int kvm_alloc_stage2_pgd(struct kvm *kvm)
>>>> +int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>>>>  {
>>>>      phys_addr_t pgd_phys;
>>>>      pgd_t *pgd;
>>>> +    int cpu;
>>>> 
>>>> -    if (kvm->arch.pgd != NULL) {
>>>> +    if (mmu->pgd != NULL) {
>>>>          kvm_err("kvm_arch already initialized?\n");
>>>>          return -EINVAL;
>>>>      }
>>>> @@ -1024,8 +1040,20 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
>>>>      if (WARN_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm)))
>>>>          return -EINVAL;
>>> 
>>> We don't free the pgd if we get the error above, but we do free it 
>>> below, if
>>> allocating last_vcpu_ran fails. Shouldn't we free it in both cases?
>> 
>> Worth investigating. This code gets majorly revamped in the NV series, 
>> so it is
>> likely that I missed something in the middle.
> 
> You didn't miss anything, I checked and it's the same in the upstream
> version of KVM.
> 
> kvm_arch_init_vm() returns with an error if this functions fails, so 
> it's up to
> the function to do the clean up. kvm_alloc_pages_exact() returns NULL
> on error, so
> at this point we have a valid allocation of physical contiguous pages.
> Failing to
> create a VM is not a fatal error for the system, so I'm thinking that 
> maybe we
> should free those pages for the rest of the system to use. However, 
> this is a
> minor issue, and the patch isn't supposed to make any functional 
> changes, so it
> can be probably be left for another patch and not add more to an
> already big series.

Cool. Will you be posting such patch?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
