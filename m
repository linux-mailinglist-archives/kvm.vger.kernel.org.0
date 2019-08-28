Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB89A0565
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 16:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfH1Ozb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 10:55:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33968 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbfH1Oza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 10:55:30 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD05218C426B;
        Wed, 28 Aug 2019 14:55:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02ABB600CD;
        Wed, 28 Aug 2019 14:55:28 +0000 (UTC)
Date:   Wed, 28 Aug 2019 16:55:26 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, maz@kernel.org,
        vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 08/16] lib: arm/arm64: Refuse to
 disable the MMU with non-identity stack pointer
Message-ID: <20190828145526.g6xlotkhial5tv57@kamzik.brq.redhat.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-9-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566999511-24916-9-git-send-email-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Wed, 28 Aug 2019 14:55:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 02:38:23PM +0100, Alexandru Elisei wrote:
> When the MMU is off, all addresses are physical addresses. If the stack
> pointer is not an identity mapped address (the virtual address is not the
> same as the physical address), then we end up trying to access an invalid
> memory region. This can happen if we call mmu_disable from a secondary CPU,
> which has its stack allocated from the vmalloc region.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/mmu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 3d38c8397f5a..161f7a8e607c 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -66,8 +66,12 @@ void mmu_enable(pgd_t *pgtable)
>  extern void asm_mmu_disable(void);
>  void mmu_disable(void)
>  {
> +	unsigned long sp = current_stack_pointer;
>  	int cpu = current_thread_info()->cpu;
>  
> +	assert_msg(__virt_to_phys(sp) == sp,
> +			"Attempting to disable MMU with non-identity mapped stack");
> +
>  	mmu_mark_disabled(cpu);
>  
>  	asm_mmu_disable();
> -- 
> 2.7.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
