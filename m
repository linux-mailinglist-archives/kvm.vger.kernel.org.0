Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3036CF862
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 02:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjC3AxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 20:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjC3AxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 20:53:12 -0400
Received: from out-32.mta1.migadu.com (out-32.mta1.migadu.com [IPv6:2001:41d0:203:375::20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9C84C2F
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 17:53:11 -0700 (PDT)
Date:   Thu, 30 Mar 2023 00:53:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680137589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u129OKoERAusr1NcAeNxizNI/fvdAMSKczWd0d3woXA=;
        b=wgi8ze+4zyW4qXl5dkwHr7dgFhgMpyWcpSuhdRy1cLNy8ZfdJgYLxWHAL6obzqTQvtrGeA
        uwwf/fsHapyKjPPJa/AQV4ilwXvLvSVaIGdcOXpMllTRLWci+cP66IoWvGixTD/q0Xdy7m
        3ZEzzgoIB8WDFdYOtDq7qCLIGTbFxBc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/7] KVM: arm64: Implement
 kvm_arch_flush_remote_tlbs_range()
Message-ID: <ZCTdcJLxWBRXItSM@linux.dev>
References: <20230206172340.2639971-1-rananta@google.com>
 <20230206172340.2639971-5-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206172340.2639971-5-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 05:23:37PM +0000, Raghavendra Rao Ananta wrote:
> Implement kvm_arch_flush_remote_tlbs_range() for arm64,
> such that it can utilize the TLBI range based instructions
> if supported.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kvm/mmu.c              | 15 +++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index dee530d75b957..211fab0c1de74 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1002,6 +1002,9 @@ struct kvm *kvm_arch_alloc_vm(void);
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>  int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>  
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
> +
>  static inline bool kvm_vm_is_protected(struct kvm *kvm)
>  {
>  	return false;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e98910a8d0af6..409cb187f4911 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -91,6 +91,21 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>  	return 0;
>  }
>  
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
> +{
> +	phys_addr_t start, end;
> +
> +	if (!system_supports_tlb_range())
> +		return -EOPNOTSUPP;

There's multiple layers of fallback throughout this series, as it would
appear that deep in __kvm_tlb_flush_range() you're blasting the whole
VMID if either the range is too large or the feature isn't supported.

Is it possible to just normalize on a single spot to gate the use of
range-based invalidations? I have a slight preference for doing it deep
in the handler, as it keeps the upper layers of code a bit more
readable.

> +	start = start_gfn << PAGE_SHIFT;
> +	end = (start_gfn + pages) << PAGE_SHIFT;
> +
> +	kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, &kvm->arch.mmu,
> +			start, end, KVM_PGTABLE_MAX_LEVELS - 1, 0);
> +	return 0;
> +}
> +
>  static bool kvm_is_device_pfn(unsigned long pfn)
>  {
>  	return !pfn_is_map_memory(pfn);
> -- 
> 2.39.1.519.gcb327c4b5f-goog
> 
> 

-- 
Thanks,
Oliver
