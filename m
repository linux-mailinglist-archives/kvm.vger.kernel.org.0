Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE38FA0574
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 16:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfH1O7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 10:59:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37477 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfH1O7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 10:59:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DDA03859FB;
        Wed, 28 Aug 2019 14:59:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2ACA05D70D;
        Wed, 28 Aug 2019 14:59:30 +0000 (UTC)
Date:   Wed, 28 Aug 2019 16:59:27 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, maz@kernel.org,
        vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 09/16] lib: arm/arm64: Invalidate TLB
 before enabling MMU
Message-ID: <20190828145927.7efffq54rm3rxow3@kamzik.brq.redhat.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-10-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566999511-24916-10-git-send-email-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 28 Aug 2019 14:59:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 02:38:24PM +0100, Alexandru Elisei wrote:
> Let's invalidate the TLB before enabling the MMU, not after, so we don't
> accidently use a stale TLB mapping. For arm64, we already do that in
> asm_mmu_enable, and we issue an extra invalidation after the function
> returns. Invalidate the TLB in asm_mmu_enable for arm also, and remove the
> redundant call to tlb_flush_all.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/mmu.c | 1 -
>  arm/cstart.S  | 4 ++++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 161f7a8e607c..66a05d789386 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -57,7 +57,6 @@ void mmu_enable(pgd_t *pgtable)
>  	struct thread_info *info = current_thread_info();
>  
>  	asm_mmu_enable(__pa(pgtable));
> -	flush_tlb_all();
>  
>  	info->pgtable = pgtable;
>  	mmu_mark_enabled(info->cpu);
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 5d4fe4b1570b..316672545551 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -160,6 +160,10 @@ halt:
>  .equ	NMRR,	0xff000004		@ MAIR1 (from Linux kernel)
>  .globl asm_mmu_enable
>  asm_mmu_enable:
> +	/* TLBIALL */
> +	mcr	p15, 0, r2, c8, c7, 0
> +	dsb	ish
> +
>  	/* TTBCR */
>  	mrc	p15, 0, r2, c2, c0, 2
>  	orr	r2, #(1 << 31)		@ TTB_EAE
> -- 
> 2.7.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
