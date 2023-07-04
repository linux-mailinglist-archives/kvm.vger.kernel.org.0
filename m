Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89D4747A95
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 01:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjGDX6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 19:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjGDX6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 19:58:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9840C1B7
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 16:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688515056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TLZ5I5VXwhpfhDrMR6rkCGEcJe9jxydQOBiM7jjqYnM=;
        b=T0fXNw3Q5OMIp1Go7zhL3w7Ar1020EOwW8C++vPVwPSUY/11rMlZX6buEuIpRfRM3vVMTW
        LBHuY+yKqq6dIs2Ift3n5IyNu7hEtaLHdpdEg5OJ7G7RormdBIf4DDkZeihXnWWYmMcH2h
        tiagKnQhQSwGcWv/ZhuGAW5iBnlMrUQ=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-7icjP_5XM9eNb7AYr8Skgw-1; Tue, 04 Jul 2023 19:57:35 -0400
X-MC-Unique: 7icjP_5XM9eNb7AYr8Skgw-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3461839c3f6so7902005ab.1
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 16:57:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688515054; x=1691107054;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TLZ5I5VXwhpfhDrMR6rkCGEcJe9jxydQOBiM7jjqYnM=;
        b=E7MRlu3IJpdauS1mmQltEfn0QfadECjgitrKaHFH2ibZULNmqNhol7kjetd0WNU/OL
         nF2gq1wFxJ8BsGB4f5OkT9/5h9A0VWgN3LRDg1d8zRk/0QedV6Ahye+/yocbVhPM8bF7
         XhqmwFnJTda1Yk+cHjyi6ZPReRncI0jTYlKQWh9sHQmef92LfdzwEz5ZTaKGU1szDxE3
         EcglSQLA4hmoczHYRwDUWBh9pYe6M+g3IomyT7Kf0l1XBnAU+wKREERVrwTWJ7DWhzjb
         41+iYz0Q5QxgJC29SWeWqHW+NBQI2dvaTlDrogZeW15q/wKiKkUF/TbeUdLXSplfqzlw
         VcsQ==
X-Gm-Message-State: ABy/qLYPsrMSqS3X2ZlZoKr8jeMmnNCgwaea/EyhFIeV/ud3wjGZrmi6
        7ZcvP28/SERhh/LiJZi0MFNwLGulHBwlyThmieQIvKqNWgFPtdBGCO225nRZCLVhopPiv8jiTt5
        fd+3innLh4XX5
X-Received: by 2002:a92:d349:0:b0:345:8abb:5b2e with SMTP id a9-20020a92d349000000b003458abb5b2emr14365941ilh.20.1688515054584;
        Tue, 04 Jul 2023 16:57:34 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFahcyBWRfLnTZyiIUY6r4zW6Jy7D9cBLz4F1RirWdeRJ1rLt2YItuLeaq71cHuDRKKxWjlpQ==
X-Received: by 2002:a92:d349:0:b0:345:8abb:5b2e with SMTP id a9-20020a92d349000000b003458abb5b2emr14365924ilh.20.1688515054313;
        Tue, 04 Jul 2023 16:57:34 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id b1-20020a170902d50100b001b86f1b5797sm8106597plg.302.2023.07.04.16.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 16:57:33 -0700 (PDT)
Message-ID: <14c8fb94-3dda-8ac3-2539-c2977686a264@redhat.com>
Date:   Wed, 5 Jul 2023 09:57:25 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 04/11] KVM: Move
 kvm_arch_flush_remote_tlbs_memslot() to common code
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230621175002.2832640-1-rananta@google.com>
 <20230621175002.2832640-5-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230621175002.2832640-5-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Move kvm_arch_flush_remote_tlbs_memslot() to common code and drop
> "arch_" from the name. kvm_arch_flush_remote_tlbs_memslot() is just a
> range-based TLB invalidation where the range is defined by the memslot.
> Now that kvm_flush_remote_tlbs_range() can be called from common code we
> can just use that and drop a bunch of duplicate code from the arch
> directories.
> 
> Note this adds a lockdep assertion for slots_lock being held when
> calling kvm_flush_remote_tlbs_memslot(), which was previously only
> asserted on x86. MIPS has calls to kvm_flush_remote_tlbs_memslot(),
> but they all hold the slots_lock, so the lockdep assertion continues to
> hold true.
> 
> Also drop the CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT ifdef gating
> kvm_flush_remote_tlbs_memslot(), since it is no longer necessary.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/kvm/arm.c     |  6 ------
>   arch/mips/kvm/mips.c     | 10 ++--------
>   arch/riscv/kvm/mmu.c     |  6 ------
>   arch/x86/kvm/mmu/mmu.c   | 16 +---------------
>   arch/x86/kvm/x86.c       |  2 +-
>   include/linux/kvm_host.h |  7 +++----
>   virt/kvm/kvm_main.c      | 18 ++++++++++++++++--
>   7 files changed, 23 insertions(+), 42 deletions(-)
> 

It's a nice cleanup to remove kvm_arch_flush_remote_tlbs_memslot() and replace
it with generic kvm_flush_remote_tlbs_memslot():

Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks,
Gavin

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 14391826241c8..9a75c23351aca 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1459,12 +1459,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>   
>   }
>   
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -					const struct kvm_memory_slot *memslot)
> -{
> -	kvm_flush_remote_tlbs(kvm);
> -}
> -
>   static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>   					struct kvm_arm_device_addr *dev_addr)
>   {
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 6e34bbe244462..614cb7322b6d5 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -199,7 +199,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   	/* Flush slot from GPA */
>   	kvm_mips_flush_gpa_pt(kvm, slot->base_gfn,
>   			      slot->base_gfn + slot->npages - 1);
> -	kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +	kvm_flush_remote_tlbs_memslot(kvm, slot);
>   	spin_unlock(&kvm->mmu_lock);
>   }
>   
> @@ -235,7 +235,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   		needs_flush = kvm_mips_mkclean_gpa_pt(kvm, new->base_gfn,
>   					new->base_gfn + new->npages - 1);
>   		if (needs_flush)
> -			kvm_arch_flush_remote_tlbs_memslot(kvm, new);
> +			kvm_flush_remote_tlbs_memslot(kvm, new);
>   		spin_unlock(&kvm->mmu_lock);
>   	}
>   }
> @@ -987,12 +987,6 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   	return 1;
>   }
>   
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -					const struct kvm_memory_slot *memslot)
> -{
> -	kvm_flush_remote_tlbs(kvm);
> -}
> -
>   int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   {
>   	int r;
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index f2eb47925806b..97e129620686c 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -406,12 +406,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>   {
>   }
>   
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -					const struct kvm_memory_slot *memslot)
> -{
> -	kvm_flush_remote_tlbs(kvm);
> -}
> -
>   void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free)
>   {
>   }
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 32f7fb1b66c8d..d8cfad72f2b1f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6654,7 +6654,7 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
>   	 */
>   	if (walk_slot_rmaps(kvm, slot, kvm_mmu_zap_collapsible_spte,
>   			    PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
> -		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +		kvm_flush_remote_tlbs_memslot(kvm, slot);
>   }
>   
>   void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> @@ -6673,20 +6673,6 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>   	}
>   }
>   
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -					const struct kvm_memory_slot *memslot)
> -{
> -	/*
> -	 * All current use cases for flushing the TLBs for a specific memslot
> -	 * related to dirty logging, and many do the TLB flush out of mmu_lock.
> -	 * The interaction between the various operations on memslot must be
> -	 * serialized by slots_locks to ensure the TLB flush from one operation
> -	 * is observed by any other operation on the same memslot.
> -	 */
> -	lockdep_assert_held(&kvm->slots_lock);
> -	kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
> -}
> -
>   void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
>   				   const struct kvm_memory_slot *memslot)
>   {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ceb7c5e9cf9e9..2ea17b51037af 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12745,7 +12745,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>   		 * See is_writable_pte() for more details (the case involving
>   		 * access-tracked SPTEs is particularly relevant).
>   		 */
> -		kvm_arch_flush_remote_tlbs_memslot(kvm, new);
> +		kvm_flush_remote_tlbs_memslot(kvm, new);
>   	}
>   }
>   
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a054f48498a8f..1eec1119cc4c9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1358,6 +1358,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
>   
>   void kvm_flush_remote_tlbs(struct kvm *kvm);
>   void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages);
> +void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
> +				   const struct kvm_memory_slot *memslot);
>   
>   #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>   int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> @@ -1386,10 +1388,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   					unsigned long mask);
>   void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
>   
> -#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -					const struct kvm_memory_slot *memslot);
> -#else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
> +#ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
>   int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
>   int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
>   		      int *is_dirty, struct kvm_memory_slot **memslot);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fc4ee20d33cc0..92218edfc6b84 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -384,6 +384,20 @@ void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages)
>   	kvm_flush_remote_tlbs(kvm);
>   }
>   
> +void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
> +				   const struct kvm_memory_slot *memslot)
> +{
> +	/*
> +	 * All current use cases for flushing the TLBs for a specific memslot
> +	 * related to dirty logging, and many do the TLB flush out of mmu_lock.
> +	 * The interaction between the various operations on memslot must be
> +	 * serialized by slots_locks to ensure the TLB flush from one operation
> +	 * is observed by any other operation on the same memslot.
> +	 */
> +	lockdep_assert_held(&kvm->slots_lock);
> +	kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
> +}
> +
>   static void kvm_flush_shadow_all(struct kvm *kvm)
>   {
>   	kvm_arch_flush_shadow_all(kvm);
> @@ -2191,7 +2205,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
>   	}
>   
>   	if (flush)
> -		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> +		kvm_flush_remote_tlbs_memslot(kvm, memslot);
>   
>   	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
>   		return -EFAULT;
> @@ -2308,7 +2322,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
>   	KVM_MMU_UNLOCK(kvm);
>   
>   	if (flush)
> -		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> +		kvm_flush_remote_tlbs_memslot(kvm, memslot);
>   
>   	return 0;
>   }

