Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3817D732C61
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbjFPJnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241228AbjFPJnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:43:23 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71B963AB0
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:42:58 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A5B21FB;
        Fri, 16 Jun 2023 02:43:16 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6FEF13F5A1;
        Fri, 16 Jun 2023 02:42:30 -0700 (PDT)
Date:   Fri, 16 Jun 2023 10:42:27 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/6] arm: pmu: Add extra DSB barriers
 in the mem_access loop
Message-ID: <ZIwug0Oz0RUFisRp@monolith.localdoman>
References: <20230531201438.3881600-1-eric.auger@redhat.com>
 <20230531201438.3881600-4-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531201438.3881600-4-eric.auger@redhat.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, May 31, 2023 at 10:14:35PM +0200, Eric Auger wrote:
> The mem access loop currently features ISB barriers only. However
> the mem_access loop counts the number of accesses to memory. ISB
> do not garantee the PE cannot reorder memory access. Let's
> add a DSB ISH before the write to PMCR_EL0 that enables the PMU
> to make sure any previous memory access aren't counted in the
> loop, another one after the PMU gets enabled (to make sure loop
> memory accesses cannot be reordered before the PMU gets enabled)
> and a last one after the last iteration, before disabling the PMU.

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> ---
> 
> v1 -> v2:
> - added yet another DSB after PMU enabled as suggested by Alexandru
> 
> This was discussed in https://lore.kernel.org/all/YzxmHpV2rpfaUdWi@monolith.localdoman/
> ---
>  arm/pmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 51c0fe80..74dd4c10 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -301,13 +301,16 @@ static void mem_access_loop(void *addr, long loop, uint32_t pmcr)
>  {
>  	uint64_t pmcr64 = pmcr;
>  asm volatile(
> +	"       dsb     ish\n"
>  	"       msr     pmcr_el0, %[pmcr]\n"
>  	"       isb\n"
> +	"       dsb     ish\n"
>  	"       mov     x10, %[loop]\n"
>  	"1:     sub     x10, x10, #1\n"
>  	"       ldr	x9, [%[addr]]\n"
>  	"       cmp     x10, #0x0\n"
>  	"       b.gt    1b\n"
> +	"       dsb     ish\n"
>  	"       msr     pmcr_el0, xzr\n"
>  	"       isb\n"
>  	:
> -- 
> 2.38.1
> 
