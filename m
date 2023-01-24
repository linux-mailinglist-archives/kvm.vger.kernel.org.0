Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2C167A62B
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 23:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjAXWyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 17:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjAXWyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 17:54:14 -0500
Received: from out-246.mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E02D474FB
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 14:54:09 -0800 (PST)
Date:   Tue, 24 Jan 2023 14:54:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674600847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=89LHdp2iidBYEJxIivMbaQf8lDKjYIbRHtNpIRtucvg=;
        b=fnj/snkgDOwjWEdnayZeLkkYSrAgCDx9UY78BuX1gquOv8FWgO4XYZHlQH+yWFOgEW2cPx
        UU0et3Z9AqS7glL1qv0VQ3eTk+LcVOoZXJ1/fqEiaT4HkIExSu5s/SIX/V64fFMLB9R2Bv
        wtg9E+/6mrcp+RKIdQtOW+Mv3fPAotE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] KVM: arm64: Optimize TLBIs in the dirty logging
 path
Message-ID: <Y9BhiOyvMvu/L0J4@thinky-boi>
References: <20230109215347.3119271-1-rananta@google.com>
 <20230109215347.3119271-5-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109215347.3119271-5-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

I find the commit title rather ambiguous. May I suggest:

  KVM: arm64: Use range-based TLBIs for write protection

On Mon, Jan 09, 2023 at 09:53:45PM +0000, Raghavendra Rao Ananta wrote:
> Currently the dirty-logging paths, including
> kvm_arch_flush_remote_tlbs_memslot() and kvm_mmu_wp_memory_region()
> ivalidates the entire VM's TLB entries using kvm_flush_remote_tlbs().
> As the range of IPAs is provided by these functions, this is highly
> inefficient on the systems which support FEAT_TLBIRANGE. Hence,
> use kvm_flush_remote_tlbs_range() to flush the TLBs instead.

This commit message gives a rather mechanical description of the commit.
Instead of describing the change, could you describe _why_ this is an
improvement over the VM-wide invalidation?

--
Thanks,
Oliver

> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/arm.c | 7 ++++++-
>  arch/arm64/kvm/mmu.c | 2 +-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 00da570ed72bd..179520888c697 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1433,7 +1433,12 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
>  					const struct kvm_memory_slot *memslot)
>  {
> -	kvm_flush_remote_tlbs(kvm);
> +	phys_addr_t start, end;
> +
> +	start = memslot->base_gfn << PAGE_SHIFT;
> +	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
> +
> +	kvm_flush_remote_tlbs_range(kvm, start, end);
>  }
>  
>  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 70f76bc909c5d..e34b81f5922ce 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -976,7 +976,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
>  	write_lock(&kvm->mmu_lock);
>  	stage2_wp_range(&kvm->arch.mmu, start, end);
>  	write_unlock(&kvm->mmu_lock);
> -	kvm_flush_remote_tlbs(kvm);
> +	kvm_flush_remote_tlbs_range(kvm, start, end);
>  }
>  
>  /**
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
> 
