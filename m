Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7ECA6DCC03
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 22:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjDJUEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 16:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjDJUEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 16:04:43 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A529C
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 13:04:42 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1a1b23f49e2so350895ad.0
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 13:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681157082; x=1683749082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ioh7H8l7yHk6qWPycTIzyodgQk+veGhOYnAh0iMY1+w=;
        b=lWtyZKzYcc1MyYe7qNHQjECK/dg2CML09VVHQcrM2Wq0FpFlSWEjPrdhXxb4iGnSM8
         WW1oDeNJKmcbJ2YGduDza3p2OwzwBVBlL9NaiUIxPVC2Vb7esdENbAHKAcIvZLjQs+fU
         r5ZVGpDtF3oITFKpWRAVGErbpGlPjQqpI7ekDq6uhTZEMZdxRR1Ij0QuiZoKezquRNji
         rE/470RHWL+3eJvJ1OK0b2vUexzcygYo5fKuesngRR+efH6Wwfi3fXQza5IheHRA+6Kb
         o/gHOzOqAwEg4HzW6lUFWgujuxn6iN+avE1mOgb2jQNoRaIYuwCB5iTWf/1Qe8fRvslx
         Y8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681157082; x=1683749082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ioh7H8l7yHk6qWPycTIzyodgQk+veGhOYnAh0iMY1+w=;
        b=xtHSAzYM1IdbglXkGWdd3PxD2ttGN6+aK7i/wFsn2fHjewuSMSe5w5dXYy8L/CmiDH
         BlDDm6NC6PczKUlkvmGfv+efTBJUhd/TdS/nPoQKcUuGPA/3wqBGot5r67qVjzloiMwj
         eUbWv8+4w89FpOGrpGj3Dm0BvwwVR6qc24Vx4Vw2mmqpvmT+ftu+gMa7yneYJoG07KMy
         WDakOjXYnJIDtWaP9QNu2cTxQ/MrNzvSGxZwAZoqu7j91/P+I84OQFMC7k6jXvUcMf9S
         ISV0LlP46jNaZ5JJ2mJM6WobivLrJUd3r2K7YiWN8Tda2LYvO+Mc6lOrqa675oZbzfxd
         8MIA==
X-Gm-Message-State: AAQBX9eLR+o10Pc643+Y4n161InWN+70xTpPh6nRjLvjrU59st1aDJ6L
        Ay/YN3PiD5A9aBIjQ5chc6796A==
X-Google-Smtp-Source: AKy350ZW9oej8RUl8/eOvpVf8OCKfDFJNBTL3TZd9an4aitV0vDTNyioWDQmQgd7+UPDNhApEI0Z+Q==
X-Received: by 2002:a17:903:1351:b0:1a5:2e85:94a1 with SMTP id jl17-20020a170903135100b001a52e8594a1mr54087plb.14.1681157082052;
        Mon, 10 Apr 2023 13:04:42 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id mh5-20020a17090b4ac500b0023fbb21214bsm3185888pjb.17.2023.04.10.13.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 13:04:41 -0700 (PDT)
Date:   Mon, 10 Apr 2023 13:04:38 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v6 08/12] KVM: arm64: Add
 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
Message-ID: <ZDRr1ozBOoW2PtPQ@google.com>
References: <20230307034555.39733-1-ricarkol@google.com>
 <20230307034555.39733-9-ricarkol@google.com>
 <20230329045046.anwujgkede7h2hi5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329045046.anwujgkede7h2hi5@google.com>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 09:50:46PM -0700, Reiji Watanabe wrote:
> Hi Ricardo,
> 
> On Tue, Mar 07, 2023 at 03:45:51AM +0000, Ricardo Koller wrote:
> > Add a capability for userspace to specify the eager split chunk size.
> > The chunk size specifies how many pages to break at a time, using a
> > single allocation. Bigger the chunk size, more pages need to be
> > allocated ahead of time.
> > 
> > Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst    | 26 ++++++++++++++++++++++++++
> >  arch/arm64/include/asm/kvm_host.h | 19 +++++++++++++++++++
> >  arch/arm64/kvm/arm.c              | 22 ++++++++++++++++++++++
> >  arch/arm64/kvm/mmu.c              |  3 +++
> >  include/uapi/linux/kvm.h          |  1 +
> >  5 files changed, 71 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 62de0768d6aa..872dae7cfbe0 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -8380,6 +8380,32 @@ structure.
> >  When getting the Modified Change Topology Report value, the attr->addr
> >  must point to a byte where the value will be stored or retrieved from.
> >  
> > +8.40 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> > +---------------------------------------
> > +
> > +:Capability: KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> > +:Architectures: arm64
> > +:Type: vm
> > +:Parameters: arg[0] is the new chunk size.
> > +:Returns: 0 on success, -EINVAL if any memslot has been created.
> > +
> > +This capability sets the chunk size used in Eager Page Splitting.
> > +
> > +Eager Page Splitting improves the performance of dirty-logging (used
> > +in live migrations) when guest memory is backed by huge-pages.  This
> > +optimization is enabled by default on arm64. It avoids splitting
> > +huge-pages (into PAGE_SIZE pages) on fault, by doing it eagerly when
> > +enabling dirty logging (with the KVM_MEM_LOG_DIRTY_PAGES flag for a
> > +memory region), or when using KVM_CLEAR_DIRTY_LOG.
> > +
> > +The chunk size specifies how many pages to break at a time, using a
> > +single allocation for each chunk. Bigger the chunk size, more pages
> > +need to be allocated ahead of time. A good heuristic is to pick the
> > +size of the huge-pages as the chunk size.
> > +
> > +If the chunk size (arg[0]) is zero, then no eager page splitting is
> > +performed. The default value PMD size (e.g., 2M when PAGE_SIZE is 4K).
> > +
> >  9. Known KVM API problems
> >  =========================
> >  
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index a1892a8f6032..b7755d0cbd4d 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -158,6 +158,25 @@ struct kvm_s2_mmu {
> >  	/* The last vcpu id that ran on each physical CPU */
> >  	int __percpu *last_vcpu_ran;
> >  
> > +#define KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT	PMD_SIZE
> > +	/*
> > +	 * Memory cache used to split
> > +	 * KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE worth of huge pages. It
> > +	 * is used to allocate stage2 page tables while splitting huge
> > +	 * pages. Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE
> 
> Nit: s/EAGER_PAGE_SPLIT_CHUNK_SIZE/EAGER_SPLIT_CHUNK_SIZE/ ?
> (or 'split_page_chunk_size' to make the comment consistent
> with the field name?)
> 
>

I missed this on v7! sorry Reiji. Will fix this on the next version.

> > +	 * influences both the capacity of the split page cache, and
> > +	 * how often KVM reschedules. Be wary of raising CHUNK_SIZE
> > +	 * too high.
> > +	 *
> > +	 * A good heuristic to pick CHUNK_SIZE is that it should be
> > +	 * the size of the huge-pages backing guest memory. If not
> > +	 * known, the PMD size (usually 2M) is a good guess.
> > +	 *
> > +	 * Protected by kvm->slots_lock.
> > +	 */
> > +	struct kvm_mmu_memory_cache split_page_cache;
> > +	uint64_t split_page_chunk_size;
> > +
> >  	struct kvm_arch *arch;
> >  };
> >  
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3bd732eaf087..3468fee223ae 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -91,6 +91,22 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >  		r = 0;
> >  		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
> >  		break;
> > +	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> > +		mutex_lock(&kvm->lock);
> 
> Do we need to hold kvm->lock here ?

We don't need it. It's safe to have it here, but it's not required.

The ordering of locks is:

	kvm->lock --> kvm->slots_lock

and kvm->lock is not held at this point, so it's safe to grab it.  I
found instances where kvm->lock is held before grabbing kvm->slots_lock,
and others where it's not. So it's not required.

I will remove it for the next version.

Thanks,
Ricardo

> 
> Thanks,
> Reiji
> 
> 
> > +		mutex_lock(&kvm->slots_lock);
> > +		/*
> > +		 * To keep things simple, allow changing the chunk
> > +		 * size only if there are no memslots created.
> > +		 */
> > +		if (!kvm_are_all_memslots_empty(kvm)) {
> > +			r = -EINVAL;

> > +		} else {
> > +			r = 0;
> > +			kvm->arch.mmu.split_page_chunk_size = cap->args[0];
> > +		}
> > +		mutex_unlock(&kvm->slots_lock);
> > +		mutex_unlock(&kvm->lock);
> > +		break;
> >  	default:
> >  		r = -EINVAL;
> >  		break;
> > @@ -288,6 +304,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> >  		r = system_has_full_ptr_auth();
> >  		break;
> > +	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> > +		if (kvm)
> > +			r = kvm->arch.mmu.split_page_chunk_size;
> > +		else
> > +			r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> > +		break;
> >  	default:
> >  		r = 0;
> >  	}
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index a2800e5c4271..898985b09321 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -756,6 +756,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
> >  	for_each_possible_cpu(cpu)
> >  		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
> >  
> > +	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
> > +	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> > +
> >  	mmu->pgt = pgt;
> >  	mmu->pgd_phys = __pa(pgt->pgd);
> >  	return 0;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index d77aef872a0a..af43acdc7901 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1184,6 +1184,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
> >  #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
> >  #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
> > +#define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 227
> >  
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >  
> > -- 
> > 2.40.0.rc0.216.gc4246ad0f0-goog
> > 
