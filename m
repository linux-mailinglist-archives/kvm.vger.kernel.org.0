Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689F52F7694
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 11:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbhAOKYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 05:24:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbhAOKYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 05:24:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 621BE235F9;
        Fri, 15 Jan 2021 10:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610706221;
        bh=c/+XqWLmQTEyndmY4XhHmEat6eBL2W+LzNHlJg1xGlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GQwIacPmjs/aOm4bQ1rFpzSRDHy739OTYVDLZinf3vIbt7XaORjK14OSbDSdGh6Ij
         7DOaM4QxtaG0JZsU18PjC4KvQa6bGICy8UpXQw29+cxhdYimqTY9stfbshm+JhT/cf
         O821VSuzWQTvjgPq0kr+fXNYeQ1z207Ns8XMzOb7LQpsEu+vFr1+8V8TLI0u9i7PFs
         Z5bY3BeoxFG57wfFcqto6uPrpKzc3NlFGlVWKMEO+wX9/J5iLo2exKI16IJ1DGDZdB
         3c4P0oFfKYtWfyHSPqCxayXwV4nWDUlKHeBadwhZArU4E9Q7ZPhnmoyQNBaIjUW+aX
         q5yeMNOO4fmBw==
Date:   Fri, 15 Jan 2021 10:23:35 +0000
From:   Will Deacon <will@kernel.org>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        wanghaibin.wang@huawei.com, jiangkunkun@huawei.com
Subject: Re: [PATCH] kvm: arm64: Properly align the end address of table walk
Message-ID: <20210115102334.GA14167@willie-the-truck>
References: <20210115095307.12912-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115095307.12912-1-zhukeqian1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 05:53:07PM +0800, Keqian Zhu wrote:
> When align the end address, ought to use its original value.
> 
> Fixes: b1e57de62cfb ("KVM: arm64: Add stand-alone page-table walker infrastructure")
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index bdf8e55ed308..670b0ef12440 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -296,7 +296,7 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	struct kvm_pgtable_walk_data walk_data = {
>  		.pgt	= pgt,
>  		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
> -		.end	= PAGE_ALIGN(walk_data.addr + size),
> +		.end	= PAGE_ALIGN(addr + size),
>  		.walker	= walker,

Hmm, this is a change in behaviour, no (consider the case where both 'addr'
and 'size' are misaligned)? The current code is consistent with the
kerneldoc in asm/kvm_pgtable.h, so I don't see the motivation to change it.

Did you hit a bug somewhere?

Will
