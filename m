Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A5AC23A2
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 16:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731714AbfI3Ovi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 10:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731470AbfI3Ovh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 10:51:37 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA8CE59449;
        Mon, 30 Sep 2019 14:51:37 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41A185D9C3;
        Mon, 30 Sep 2019 14:51:36 +0000 (UTC)
Date:   Mon, 30 Sep 2019 16:51:33 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, mark.rutland@arm.com,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH 1/3] lib: arm64: Add missing ISB in
 flush_tlb_page
Message-ID: <20190930145133.7hy5lkoym7mg5rce@kamzik.brq.redhat.com>
References: <20190930142508.25102-1-alexandru.elisei@arm.com>
 <20190930142508.25102-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930142508.25102-2-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 30 Sep 2019 14:51:37 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 03:25:06PM +0100, Alexandru Elisei wrote:
> Linux commit d0b7a302d58a made it abundantly clear that certain CPU
> implementations require an ISB after a DSB. Add the missing ISB to
> flush_tlb_page. No changes are required for flush_tlb_all, as the function
> already had the ISB.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm64/asm/mmu.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
> index fa554b0c20ae..72d75eafc882 100644
> --- a/lib/arm64/asm/mmu.h
> +++ b/lib/arm64/asm/mmu.h
> @@ -24,6 +24,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
>  	dsb(ishst);
>  	asm("tlbi	vaae1is, %0" :: "r" (page));
>  	dsb(ish);
> +	isb();
>  }
>  
>  static inline void flush_dcache_addr(unsigned long vaddr)
> -- 
> 2.20.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
