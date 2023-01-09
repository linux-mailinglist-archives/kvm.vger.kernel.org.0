Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6358D663577
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 00:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbjAIXlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 18:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbjAIXlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 18:41:13 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28C963C9
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 15:41:11 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o13so6966070pjg.2
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 15:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yJ7r4VJ0GFzUkp84DlniKC/ADesB2+RyryWjunDppAY=;
        b=YvL/R5uN59b8Oco6nvSc4oNoDO3miEM4rJitbnSySSpJWFkVPZEOlTHZLYh6w8RdnL
         ipIQI0SijUmLEM1TZ+LdgAlDYUpFz6vlQDI23WfcJ+NE1oAYSPB+xkO2+m3O7wdJLOqo
         Do897VYzZORy/Iby0sJ0/6DZJ61HL0Nnpf9vcegPR2CZ0abKcMSZ9hoirzi+WbHbhHLJ
         H/EEpaVjTESLuuMG+SbEeSAvJc4zGVYq2YddpPE/+fzVgcMKYRSIvsXrG6/C56aT73g8
         gpbPKJh3ATQVASmPXVAJvkpVKffENsxvgh5UnPhJ6mJjBRQ7/EWwnEavRdgOuGof4OIX
         0ZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yJ7r4VJ0GFzUkp84DlniKC/ADesB2+RyryWjunDppAY=;
        b=IVjOfs4qbs9kLlsVPSJQu3ieKE+rPV3pdrkCqRBskj7Ix6yJIXOJbhj8kAh0jpNWat
         4kewQMNe+EAeMe0FAJoXi7G5ZcovPaLhorL2SPi6UGrx/aydK2K3yW1oJ06DG4JqUVNI
         8ZQmfUogLfSQzXwIzx44tv4hTLdg3NgVfYwylWqFzmt5ESztmB+acsDaZWFw9TamdQNh
         F4AxUtk7GtWGhXGKU2htvLBEFmKNA0abKrNDCmTRCZFapxJsF5BsDK6MUEW+8uMKUxXI
         ib/8hn41mtlcxAqphrVvbeGb8bOccVlo44TGJRjgkBk2yhLo1rovyBQNJ8Unr1rfxhJg
         NKfA==
X-Gm-Message-State: AFqh2kpDo9rgWZU/cauEuCOJ3XMuKX68zSebciGZSZv18AaiUSZb3g+r
        2RcE0NGKVZweTePHfVW0kFr8gw==
X-Google-Smtp-Source: AMrXdXu6spkhFc1u6USGxG9WJvsK4rqSAtSutoxwGglqpclqT4M1fyXN+pidEm9POsve9oQG7e472A==
X-Received: by 2002:a05:6a20:e61a:b0:ac:a4fd:f5bf with SMTP id my26-20020a056a20e61a00b000aca4fdf5bfmr82389323pzb.50.1673307671315;
        Mon, 09 Jan 2023 15:41:11 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id z7-20020a63e547000000b00476d1385265sm5605289pgj.25.2023.01.09.15.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 15:41:10 -0800 (PST)
Date:   Mon, 9 Jan 2023 15:41:06 -0800
From:   David Matlack <dmatlack@google.com>
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
Subject: Re: [RFC PATCH 3/6] KVM: Define kvm_flush_remote_tlbs_range
Message-ID: <Y7ymEiU1ZC/gzs9s@google.com>
References: <20230109215347.3119271-1-rananta@google.com>
 <20230109215347.3119271-4-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109215347.3119271-4-rananta@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 09:53:44PM +0000, Raghavendra Rao Ananta wrote:
> Define kvm_flush_remote_tlbs_range() to limit the TLB flush only
> to a certain range of addresses. Replace this with the existing
> call to kvm_flush_remote_tlbs() in the MMU notifier path.
> Architectures such as arm64 can define this to flush only the
> necessary addresses, instead of the entire range.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/mmu.c     | 10 ++++++++++
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      |  7 ++++++-
>  3 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 39d9a334efb57..70f76bc909c5d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -91,6 +91,16 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>  	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
>  }
>  
> +void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end)
> +{
> +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> +
> +	if (system_supports_tlb_range())
> +		kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, mmu, start, end, 0);
> +	else
> +		kvm_flush_remote_tlbs(kvm);
> +}
> +
>  static bool kvm_is_device_pfn(unsigned long pfn)
>  {
>  	return !pfn_is_map_memory(pfn);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f51eb9419bfc3..a76cede9dc3bb 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1359,6 +1359,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
>  void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
>  
>  void kvm_flush_remote_tlbs(struct kvm *kvm);
> +void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end);
>  
>  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 03e6a38094c17..f538ecc984f5b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -376,6 +376,11 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>  		++kvm->stat.generic.remote_tlb_flush;
>  }
>  EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
> +
> +void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end)

It's ambiguous what start/end represent. Case in point,
__kvm_handle_hva_range() is passing in HVAs but then patch 4 passes in
GFNs.

Probably kvm_flush_tlbs_range() should accept GFN and there can be a
helper wrapper that does the HVA-to-GFN conversion.

> +{
> +	kvm_flush_remote_tlbs(kvm);
> +}

FYI I also proposed a common kvm_flush_remote_tlbs() in my Common MMU
series [1].

Could I interest you in grabbing patches 29-33 from that series, which
has the same end result (common kvm_flush_remote_tlbs_range()) but also
hooks up the KVM/x86 range-based flushing, and folding them into this
series?

[1] https://lore.kernel.org/kvm/20221208193857.4090582-33-dmatlack@google.com/

>  #endif
>  
>  static void kvm_flush_shadow_all(struct kvm *kvm)
> @@ -637,7 +642,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  	}
>  
>  	if (range->flush_on_ret && ret)
> -		kvm_flush_remote_tlbs(kvm);
> +		kvm_flush_remote_tlbs_range(kvm, range->start, range->end - 1);
>  
>  	if (locked) {
>  		KVM_MMU_UNLOCK(kvm);
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
