Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433C66EC23A
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 22:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjDWU1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 16:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjDWU1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 16:27:47 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DED10CC
        for <kvm@vger.kernel.org>; Sun, 23 Apr 2023 13:27:45 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1a950b982d4so175455ad.0
        for <kvm@vger.kernel.org>; Sun, 23 Apr 2023 13:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682281665; x=1684873665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R0/B9lFkkCJj4mQM+0mg+ieKB6jK4kbgggHwaUIqlD4=;
        b=usLoj8qmGkEIiXHrONM0gFXx2Oolg31swqhrOX/TMfBKAiJHnY2tBb8+R/O2OsFX/g
         PK8eKH9SV0kS956DtQe0WUP+N32MrNQZND+TO2PMFrDfm2g0h04hqgdWXxjXeByiaGnT
         PIpv/xUtvb64ukNlR37aSqRd0jX7k2PJXQ80UnlyqoAVo2QSid+sBjnXNRvTZwjGnRC9
         dNoaF8yU6wDeryd3156fESQksP0gADwzTAMnAvxpX+geMqvR5Bl3xaRlh2rzkbe4Z9dI
         AdV2TZQnMmngF/kAnu7rxsL9v2dR4G0dLBUeTp3ShurQdcpReQQsiip8u3i+W9NY0RKp
         S2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682281665; x=1684873665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R0/B9lFkkCJj4mQM+0mg+ieKB6jK4kbgggHwaUIqlD4=;
        b=Jxmqdz+F1TCWzRBDNGGJIj81jgul01H9fBGGTw7nRd/5I778YmuSkfY8rVU+MZcV5q
         JHc+Un7SVQOcm4+7XKZGzTA7ZpNzJpn9F8yEOr6F1aimcbtaenvCg+kNRmgvX7rZpKL+
         zC99+0Md7aZtHqAAErR3n1meEkiFqvo5pBLfoW44wnOmf7Hq4EWJQe7wwLi1Nu1+m+Em
         XQ9qHk/4LJkxlaXeEDtWG29zVXjgbpfthvCfJH0x+ytGpeRIje79F/0c2JOsxfYyyBcC
         GXQdxB83KslZUzVEIfURmaYTHk5aM49GopiQ7cKRgcSqSxv+95hX2Gp4qL+nvS1LXiC0
         /feQ==
X-Gm-Message-State: AAQBX9dftZjcud/9V/W+i3A4tphgpoo+G+wsdZKSDD3c3znKGr5sKsIz
        bfG2LArVbkGAP0CqDz/jlRxoOg==
X-Google-Smtp-Source: AKy350bj7u1aE2a3+tdpqVIfezWSw+g7N5IW6rPQXMz1IBMl10VgOFaJwuccI9j1NXGYDlqr1Z+pmA==
X-Received: by 2002:a17:903:10c:b0:1a5:2796:c9e4 with SMTP id y12-20020a170903010c00b001a52796c9e4mr361960plc.8.1682281664845;
        Sun, 23 Apr 2023 13:27:44 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902728600b001a67efce4dbsm5357913pll.12.2023.04.23.13.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 13:27:44 -0700 (PDT)
Date:   Sun, 23 Apr 2023 13:27:41 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v7 08/12] KVM: arm64: Add
 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
Message-ID: <ZEWUvTmdfSOwOPOz@google.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-10-ricarkol@google.com>
 <58664917-edfa-8c7a-2833-0664d83277d6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58664917-edfa-8c7a-2833-0664d83277d6@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023 at 03:04:47PM +0800, Gavin Shan wrote:
> On 4/9/23 2:29 PM, Ricardo Koller wrote:
> > Add a capability for userspace to specify the eager split chunk size.
> > The chunk size specifies how many pages to break at a time, using a
> > single allocation. Bigger the chunk size, more pages need to be
> > allocated ahead of time.
> > 
> > Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >   Documentation/virt/kvm/api.rst       | 28 ++++++++++++++++++++++++++
> >   arch/arm64/include/asm/kvm_host.h    | 15 ++++++++++++++
> >   arch/arm64/include/asm/kvm_pgtable.h | 18 +++++++++++++++++
> >   arch/arm64/kvm/arm.c                 | 30 ++++++++++++++++++++++++++++
> >   arch/arm64/kvm/mmu.c                 |  3 +++
> >   include/uapi/linux/kvm.h             |  2 ++
> >   6 files changed, 96 insertions(+)
> > 
> 
> With the following comments addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 62de0768d6aa5..f8faa80d87057 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -8380,6 +8380,34 @@ structure.
> >   When getting the Modified Change Topology Report value, the attr->addr
> >   must point to a byte where the value will be stored or retrieved from.
> > +8.40 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> > +---------------------------------------
> > +
> > +:Capability: KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> > +:Architectures: arm64
> > +:Type: vm
> > +:Parameters: arg[0] is the new split chunk size.
> > +:Returns: 0 on success, -EINVAL if any memslot was already created.
>                                                   ^^^^^^^^^^^^^^^^^^^
> 
> Maybe s/was already created/has been created
> 
> > +
> > +This capability sets the chunk size used in Eager Page Splitting.
> > +
> > +Eager Page Splitting improves the performance of dirty-logging (used
> > +in live migrations) when guest memory is backed by huge-pages.  It
> > +avoids splitting huge-pages (into PAGE_SIZE pages) on fault, by doing
> > +it eagerly when enabling dirty logging (with the
> > +KVM_MEM_LOG_DIRTY_PAGES flag for a memory region), or when using
> > +KVM_CLEAR_DIRTY_LOG.
> > +
> > +The chunk size specifies how many pages to break at a time, using a
> > +single allocation for each chunk. Bigger the chunk size, more pages
> > +need to be allocated ahead of time.
> > +
> > +The chunk size needs to be a valid block size. The list of acceptable
> > +block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a 64bit
> > +bitmap (each bit describing a block size). Setting
> > +KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE to 0 disables Eager Page Splitting;
> > +this is the default value.
> > +
> 
> s/a 64bit bitmap/a 64-bit bitmap
> 
> For the last sentence, maybe:
> 
> The default value is 0, to disable the eager page splitting.

Fixed, much better.

> 
> >   9. Known KVM API problems
> >   =========================
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index a1892a8f60323..b87da1ebc3454 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -158,6 +158,21 @@ struct kvm_s2_mmu {
> >   	/* The last vcpu id that ran on each physical CPU */
> >   	int __percpu *last_vcpu_ran;
> > +#define KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT 0
> > +	/*
> > +	 * Memory cache used to split
> > +	 * KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE worth of huge pages. It
> > +	 * is used to allocate stage2 page tables while splitting huge
> > +	 * pages. Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE
> > +	 * influences both the capacity of the split page cache, and
> > +	 * how often KVM reschedules. Be wary of raising CHUNK_SIZE
> > +	 * too high.
> > +	 *
> > +	 * Protected by kvm->slots_lock.
> > +	 */
> > +	struct kvm_mmu_memory_cache split_page_cache;
> > +	uint64_t split_page_chunk_size;
> > +
> >   	struct kvm_arch *arch;
> >   };
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 32e5d42bf020f..889bd7afeb355 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -92,6 +92,24 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
> >   	return level >= KVM_PGTABLE_MIN_BLOCK_LEVEL;
> >   }
> > +static inline u64 kvm_supported_block_sizes(void)
> > +{
> > +	u32 level = KVM_PGTABLE_MIN_BLOCK_LEVEL;
> > +	u64 res = 0;
> > +
> > +	for (; level < KVM_PGTABLE_MAX_LEVELS; level++)
> > +		res |= BIT(kvm_granule_shift(level));
> > +
> > +	return res;
> > +}
> > +
> 
> maybe s/@res/@r

changed

> 
> > +static inline bool kvm_is_block_size_supported(u64 size)
> > +{
> > +	bool is_power_of_two = !((size) & ((size)-1));
> > +
> > +	return is_power_of_two && (size & kvm_supported_block_sizes());
> > +}
> > +
> 
> IS_ALIGNED() maybe used here.

I've been trying to reuse some bitmap related function in the kernel,
like IS_ALIGNED(), but can't find anything. Or at least it doesn't occur
to me how.

kvm_is_block_size_supported() returns true if @size matches only one of
the bits set in kvm_supported_block_sizes(). For example, given these
supported sizes: 10000100001000.

kvm_is_block_size_supported(100000000) => true
kvm_is_block_size_supported(1100) => false

> 
> >   /**
> >    * struct kvm_pgtable_mm_ops - Memory management callbacks.
> >    * @zalloc_page:		Allocate a single zeroed memory page.
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3bd732eaf0872..34fd3c59a9b82 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -67,6 +67,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >   			    struct kvm_enable_cap *cap)
> >   {
> >   	int r;
> > +	u64 new_cap;
> >   	if (cap->flags)
> >   		return -EINVAL;
> > @@ -91,6 +92,26 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >   		r = 0;
> >   		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
> >   		break;
> > +	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> > +		new_cap = cap->args[0];
> > +
> > +		mutex_lock(&kvm->lock);
> > +		mutex_lock(&kvm->slots_lock);
> > +		/*
> > +		 * To keep things simple, allow changing the chunk
> > +		 * size only if there are no memslots already created.
> > +		 */
> 
> 		/*
> 		 * To keep things simple, allow changing the chunk size
> 		 * only when no memory slots have been created.
> 		 */
> 
> > +		if (!kvm_are_all_memslots_empty(kvm)) {
> > +			r = -EINVAL;
> > +		} else if (new_cap && !kvm_is_block_size_supported(new_cap)) {
> > +			r = -EINVAL;
> > +		} else {
> > +			r = 0;
> > +			kvm->arch.mmu.split_page_chunk_size = new_cap;
> > +		}
> > +		mutex_unlock(&kvm->slots_lock);
> > +		mutex_unlock(&kvm->lock);
> > +		break;
> >   	default:
> >   		r = -EINVAL;
> >   		break;
> > @@ -288,6 +309,15 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >   	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> >   		r = system_has_full_ptr_auth();
> >   		break;
> > +	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> > +		if (kvm)
> > +			r = kvm->arch.mmu.split_page_chunk_size;
> > +		else
> > +			r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> > +		break;
> > +	case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
> > +		r = kvm_supported_block_sizes();
> > +		break;
> 
> kvm_supported_block_sizes() returns u64, but @r is 32-bits in width. It may be
> worthy to make the return value from kvm_supported_block_sizes() as u32.
> 
> >   	default:
> >   		r = 0;
> >   	}
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index a2800e5c42712..898985b09321a 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -756,6 +756,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
> >   	for_each_possible_cpu(cpu)
> >   		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
> 
> It may be worthy to have comments like below:
> 
> 	/* The eager page splitting is disabled by default */
> > +	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
> > +	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> > +
> >   	mmu->pgt = pgt;
> >   	mmu->pgd_phys = __pa(pgt->pgd);
> >   	return 0;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index d77aef872a0a0..f18b48fcd25ba 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1184,6 +1184,8 @@ struct kvm_ppc_resize_hpt {
> >   #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
> >   #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
> >   #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
> > +#define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 227
> > +#define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 228
> >   #ifdef KVM_CAP_IRQ_ROUTING
> > 
> 
> Thanks,
> Gavin
> 
