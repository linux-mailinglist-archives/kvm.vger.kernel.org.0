Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE671CFC1C
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 19:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgELR0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 13:26:18 -0400
Received: from foss.arm.com ([217.140.110.172]:58964 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgELR0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 13:26:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE76F1FB;
        Tue, 12 May 2020 10:26:17 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5CC73F305;
        Tue, 12 May 2020 10:26:15 -0700 (PDT)
Subject: Re: [PATCH 08/26] KVM: arm64: Use TTL hint in when invalidating
 stage-2 translations
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-9-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <157643ed-53a7-db90-e898-c0c040a93716@arm.com>
Date:   Tue, 12 May 2020 18:26:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-9-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 22/04/2020 13:00, Marc Zyngier wrote:
> Since we always have a precide idea of the level we're dealing with

(precise)

> when invalidating TLBs, we can provide it to as a hint to our
> invalidation helper.

> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
> index 326aac658b9da..7ed5c1a769a9b 100644
> --- a/arch/arm64/include/asm/stage2_pgtable.h
> +++ b/arch/arm64/include/asm/stage2_pgtable.h
> @@ -230,4 +230,13 @@ stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
>  	return (boundary - 1 < end - 1) ? boundary : end;
>  }
>  
> +/*
> + * Level values for the ARMv8.4-TTL extension, mapping PUD/PMD/PTE and
> + * the architectural page-table level.
> + */
> +#define S2_NO_LEVEL_HINT	0
> +#define S2_PUD_LEVEL		1
> +#define S2_PMD_LEVEL		2
> +#define S2_PTE_LEVEL		3

Are these really just for stage2, would the stage1 definition be the same?

~

Digging into the VTCR_EL2.SL0 trickery, it does everything at pgd where there are no block
mappings, and no hints, so it looks fine.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
