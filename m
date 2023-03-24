Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240BD6C7912
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 08:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjCXHlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 03:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjCXHlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 03:41:24 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CB719C50
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 00:41:23 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-19f3449bf02so145165ad.1
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 00:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679643683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UNF2BYfc/eUF16ojRHfHm/WuPO82GBqOTkKROijHv4Q=;
        b=M/4Zcr5p/D3klYJ9dobMZBLso6pNrrLkgVbmupVuQuQKedCszhQjR/DGcu2C5TA7b0
         vNoOG6Ae2XZflL5VTznIL8dE1P1dz+dDR2Lcyn0nkLy/B9SYbIofxMk+bdmvm30cIumI
         Dlz1KikgIS8KyPo6Sw1lOHJYmb6GgOOuBNT3vdUABkb4Imrc5EPSvQezeaiUn0Yyd6Xm
         AJmC95mKZ2udDxsIo5QBMOZ9fGpFcGK/V/c8WJxX+p2T4wmsTUPuLEtoMyJlktW1qP/e
         fg3xvihVFH5YcfW6FjE+FULSx6gLaRBoZu1XzbhNoWnSlmhRbi9xPtvyoU+dqCtVJgKy
         36DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679643683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNF2BYfc/eUF16ojRHfHm/WuPO82GBqOTkKROijHv4Q=;
        b=zCD620SyW+oPa5XZmaGAkXljFrWbHXuojM3SYQ0pEh9AqlLtXCVin8G4DR+fWFQbMg
         B1P3vV+yiCeAK/ZOUA9Pchcrv4hvBUKLVTtAb2P3F8EL2YL4i8Pqnos2t8IsA3QSfxb+
         vU+kR9N8ZhhqZN/f1QINcn169q5QVAVwhEn6K1TR8+TKQa3mZ0HUZoEJkMxMZkN5zAZ/
         VnYK9WNcR4D3GD9hTuJAkh8UYcUF2vyNENL3TkRrzD7GxEafAvabOY9X7og2PoF9HIHz
         FmspWDjwZVBBhQRtrvnlxgtS6tpHNRTV9CYHt01ytTz8hzNifKMfeg7iDPHtC64c/m+/
         LmbA==
X-Gm-Message-State: AAQBX9d5bFj+gCKfrJiGNf/gZ0E0TDAsuua9f4+LEFKvxDUNXe0BKyKW
        VHegQJrs3sqqZjtiG9glBobu+Q==
X-Google-Smtp-Source: AKy350Y1M7+uUFn+dIQEoNALnRQhnSZsxvDkHH5iq38PFzkOQPLA7tTx+bmKGinufKoQ7ObK68sbZQ==
X-Received: by 2002:a17:902:a60f:b0:19a:f15a:5b2f with SMTP id u15-20020a170902a60f00b0019af15a5b2fmr89461plq.19.1679643682563;
        Fri, 24 Mar 2023 00:41:22 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id x15-20020a63f70f000000b0051303d3e3c5sm3043053pgh.42.2023.03.24.00.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 00:41:22 -0700 (PDT)
Date:   Fri, 24 Mar 2023 00:41:18 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v6 08/12] KVM: arm64: Add
 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
Message-ID: <ZB1UHrLFSOeVWhaV@google.com>
References: <20230307034555.39733-1-ricarkol@google.com>
 <20230307034555.39733-9-ricarkol@google.com>
 <877cvm5gk4.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877cvm5gk4.wl-maz@kernel.org>
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

On Sun, Mar 12, 2023 at 11:56:27AM +0000, Marc Zyngier wrote:
> On Tue, 07 Mar 2023 03:45:51 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
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
> 
> split chunk size?
> 
> > +:Returns: 0 on success, -EINVAL if any memslot has been created.
> 
> nit: if any memslot was *already* created.
> 
> > +
> > +This capability sets the chunk size used in Eager Page Splitting.
> > +
> > +Eager Page Splitting improves the performance of dirty-logging (used
> > +in live migrations) when guest memory is backed by huge-pages.  This
> > +optimization is enabled by default on arm64.
> 
> Why enabled by default? It means that systems that do not want to pay
> the extra memory for this have to do an explicit call to disable it.
> I'd rather see this as a buy-in option.
>

Will disable by default.

> > It avoids splitting
> > +huge-pages (into PAGE_SIZE pages) on fault, by doing it eagerly when
> > +enabling dirty logging (with the KVM_MEM_LOG_DIRTY_PAGES flag for a
> > +memory region), or when using KVM_CLEAR_DIRTY_LOG.
> > +
> > +The chunk size specifies how many pages to break at a time, using a
> > +single allocation for each chunk. Bigger the chunk size, more pages
> > +need to be allocated ahead of time. A good heuristic is to pick the
> > +size of the huge-pages as the chunk size.
> 
> How about making this a requirement rather than a heuristic? 

Sounds good. Planning to return EINVAL for anything that's not a
supported block size. 

> You could
> also tell userspace what are the block sizes that are acceptable (1G,
> 512M, 2M, 64K...) by exposing a 64bit bitmap (each bit describing a
> block size).

Good idea, I'm thinking of using a new KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES
capability to return this bitmap.

> 
> > +
> > +If the chunk size (arg[0]) is zero, then no eager page splitting is
> > +performed. The default value PMD size (e.g., 2M when PAGE_SIZE is 4K).
> 
> I really dislike exposing the notion of PMD to userspace. Not only
> this is a concept that is mostly foreign to the arm64 architecture,
> this isn't a userspace concept at all. Another reason to talk about
> block sizes (but I really want this to default to 0 and keep the
> current behaviour as the default).
> 
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
> > +	 * influences both the capacity of the split page cache, and
> > +	 * how often KVM reschedules. Be wary of raising CHUNK_SIZE
> > +	 * too high.
> > +	 *
> > +	 * A good heuristic to pick CHUNK_SIZE is that it should be
> > +	 * the size of the huge-pages backing guest memory. If not
> > +	 * known, the PMD size (usually 2M) is a good guess.
> 
> This is a 4kB-ness. Nothing "usual" about it (and my 16kB hosts
> definitely object!).
> 
> > +	 *
> > +	 * Protected by kvm->slots_lock.
> > +	 */
> > +	struct kvm_mmu_memory_cache split_page_cache;
> 
> If this is living in kvm_s2_mmu, and that this is a proper memcache,
> why does patch #4 have this horrible 'struct stage2_split_data' that
> uses a 'void *' and carries a kvm_s2_mmu pointer?
> 
> Surely, passing the memcache around should be enough (and container_of
> is your forever friend).
> 

This simplified things quite a bit.

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
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Thanks,
Ricardo
