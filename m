Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F55241B94B
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 23:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242914AbhI1VaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 17:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242890AbhI1VaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 17:30:23 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1ABC061746
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 14:28:42 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id m26so138320pff.3
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 14:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sgkqKqZf4QJoBijGu0IXklrb1nmzgsBtxZkYg5n9zxE=;
        b=J/EJ4mMJ3ZLZAbmeRAlX5LJfvMsNbbDSladhViolpZyY0+1iztMVpzcxSEAQeDq6Hb
         mvyL2HfTQknNFziPx2O/NaUg7lqWP2HXc6y9XjS+BMrWjIfCXVGhTl5tNNoD4iAKY8bs
         k5sJA3mLJxJfUZGqwHYVmudwHI2nlGY2BFaHOZKX9v+6isMjYS7zBZKnExN1gc8MNuJt
         31wt0QcrsYOB0p0OgRXkcoXO2xkePImj2IZEz4V8Fs50DasN0tCQTs2sJreXzyfRTFBI
         +cwtlvA0XsUCHLC26wA9+4sb2c0+wQTzSqiwHhjMedUUFArmYQNW9SEoQocvPXt33XKM
         cK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sgkqKqZf4QJoBijGu0IXklrb1nmzgsBtxZkYg5n9zxE=;
        b=RIWPopK7r4jkHzS1xYk/0zhAM0oaIDaqOXmXLEhJ3yPqUGltD9wQlrS2HzleztOPJl
         339Nyz0/bZJCYzQ1p37SC6WyrZ1AnRySNXx/lo9Bsdm7nqmCH7dWrlUBDdrMRIJHv0X6
         OmRgaRG8ZHFDWHGYO9pbQ1+dC4Jc3gtOPNyNsJOfb/2o3hAnXSWAQfov6rC8Vr06mUjO
         g8ZK8LI3VAE16Rxu+wakJK3N0vaz5EBVNgqOwLXWg1YCgmjQNLAwk91mgR55IMCc3Ln0
         JsWuHeUNiSEwDZAemfiFcStPobSIUblfOJemxHb6Vv+1FCGR+OOAp1PteBxTIq43bfIn
         Dmhw==
X-Gm-Message-State: AOAM530VCatzUnWU9YuxTWg5quLzGZEQ34JyBw4UE1BDvcMvXYLWG+A2
        7AR3W2cTO5WRoN7bBxzzeAO5og==
X-Google-Smtp-Source: ABdhPJyoYpfDFNYnSLw/O+H75z/7mXjFXxNDN9u9o430xttDbGkEBLyYdUk2WBhhjvuPbCzyN4dRVg==
X-Received: by 2002:a63:dd56:: with SMTP id g22mr6402024pgj.38.1632864522226;
        Tue, 28 Sep 2021 14:28:42 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id c22sm68864pja.10.2021.09.28.14.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 14:28:41 -0700 (PDT)
Date:   Tue, 28 Sep 2021 21:28:37 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 06/14] KVM: Drop obsolete kvm_arch_vcpu_block_finish()
Message-ID: <YVOJBVTlspSAh3ZL@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-7-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-7-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 05:55:20PM -0700, Sean Christopherson wrote:
> Drop kvm_arch_vcpu_block_finish() now that all arch implementations are
> nops.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/arm64/include/asm/kvm_host.h   | 1 -
>  arch/mips/include/asm/kvm_host.h    | 1 -
>  arch/powerpc/include/asm/kvm_host.h | 1 -
>  arch/s390/include/asm/kvm_host.h    | 2 --
>  arch/s390/kvm/kvm-s390.c            | 5 -----
>  arch/x86/include/asm/kvm_host.h     | 2 --
>  virt/kvm/kvm_main.c                 | 1 -
>  7 files changed, 13 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..4e0ad0fff540 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -716,7 +716,6 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
>  static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  
>  void kvm_arm_init_debug(void);
>  void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 696f6b009377..72b90d45a46e 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -897,7 +897,6 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
>  int kvm_arch_flush_remote_tlb(struct kvm *kvm);
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 59cb38b04ede..8a84448d77a6 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -864,6 +864,5 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_exit(void) {}
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  
>  #endif /* __POWERPC_KVM_HOST_H__ */
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a604d51acfc8..a22c9266ea05 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -1010,6 +1010,4 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  
> -void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu);
> -
>  #endif
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 08ed68639a21..17fabb260c35 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5080,11 +5080,6 @@ static inline unsigned long nonhyp_mask(int i)
>  	return 0x0000ffffffffffffUL >> (nonhyp_fai << 4);
>  }
>  
> -void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu)
> -{
> -
> -}
> -
>  static int __init kvm_s390_init(void)
>  {
>  	int i;
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1e0e909b98b2..4e8c21083bdb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1916,8 +1916,6 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  	static_call_cond(kvm_x86_vcpu_unblocking)(vcpu);
>  }
>  
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> -
>  static inline int kvm_cpu_get_apicid(int mps_cpu)
>  {
>  #ifdef CONFIG_X86_LOCAL_APIC
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2ba22b68af3b..2015a1f532ce 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3301,7 +3301,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	}
>  
>  	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
> -	kvm_arch_vcpu_block_finish(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_block);
>  
> -- 
> 2.33.0.685.g46640cef36-goog
> 
