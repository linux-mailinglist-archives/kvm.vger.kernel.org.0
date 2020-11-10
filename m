Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971382ADCFB
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 18:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgKJRfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 12:35:30 -0500
Received: from foss.arm.com ([217.140.110.172]:59054 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgKJRf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 12:35:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 236141396;
        Tue, 10 Nov 2020 09:35:29 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2DC1A3F7BB;
        Tue, 10 Nov 2020 09:35:28 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 1/2] arm: Add mmu_get_pte() to the MMU
 API
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, drjones@redhat.com
References: <20201110144207.90693-1-nikos.nikoleris@arm.com>
 <20201110144207.90693-2-nikos.nikoleris@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <788b9fad-ec5f-494c-ddbc-d60c27790b65@arm.com>
Date:   Tue, 10 Nov 2020 17:36:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201110144207.90693-2-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

On 11/10/20 2:42 PM, Nikos Nikoleris wrote:
> From: Luc Maranget <Luc.Maranget@inria.fr>
>
> Add the mmu_get_pte() function that allows a test to get a pointer to
> the PTE for a valid virtual address. Return NULL if the MMU is off.
>
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Luc Maranget <Luc.Maranget@inria.fr>
> Co-Developed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/asm/mmu-api.h |  1 +
>  lib/arm/mmu.c         | 32 +++++++++++++++++++++-----------
>  2 files changed, 22 insertions(+), 11 deletions(-)
>
> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> index 2bbe1fa..3d04d03 100644
> --- a/lib/arm/asm/mmu-api.h
> +++ b/lib/arm/asm/mmu-api.h
> @@ -22,5 +22,6 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>  extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
>  			       phys_addr_t phys_start, phys_addr_t phys_end,
>  			       pgprot_t prot);
> +extern pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr);
>  extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
>  #endif
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index d937f20..e58da10 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -212,15 +212,21 @@ unsigned long __phys_to_virt(phys_addr_t addr)
>  	return addr;
>  }
>  
> -void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
> +pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
>  {
> +	/*
> +	 * NOTE: The Arm architecture requires the use of a
> +	 * break-before-make sequence before making any changes to
> +	 * PTEs (Arm ARM D5-2669 for AArch64, B3-1378 for AArch32).
> +	 */

That should go above the function definition. Also, break-before-make is not
required for every PTE change, only when certain conditions are met.

Thanks,
Alex
