Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AA468ED7C
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 12:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjBHLGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 06:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjBHLGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 06:06:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442F33C04
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 03:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675854355;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ddn3ZHKD3Y1fAHYFvdUXFlfh/V/xujs0Wif2Rwk78Bg=;
        b=Wf/6fuyjXbOe5Bw6s7HAZq5ucnTdmeXkgVGlDedPhUjYwdyW1qhIhKYB0yZk5hq/wMZZfh
        Rpv2oOWDdtw8QHAUxcOScQBau/mAiFbDAHVoU4ZxpaDpJnqqh70Pw4EKscr7mkCpSZyidZ
        MFXR16YacAAyTigLIsCVOz6eo3OjwDo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-AsEauE5EPruvmEn019oLcw-1; Wed, 08 Feb 2023 06:05:48 -0500
X-MC-Unique: AsEauE5EPruvmEn019oLcw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBE4029A9D42;
        Wed,  8 Feb 2023 11:05:47 +0000 (UTC)
Received: from [10.64.54.63] (vpn2-54-63.bne.redhat.com [10.64.54.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EC1CA1121314;
        Wed,  8 Feb 2023 11:05:40 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 08/12] KVM: arm64: Add
 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Oliver Upton <oliver.upton@linux.dev>
References: <20230206165851.3106338-1-ricarkol@google.com>
 <20230206165851.3106338-9-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <58151bf0-1f56-3887-fa22-479c9b84bd4a@redhat.com>
Date:   Wed, 8 Feb 2023 22:05:37 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230206165851.3106338-9-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 2/7/23 3:58 AM, Ricardo Koller wrote:
> Add a capability for userspace to specify the eager split chunk size.
> The chunk size specifies how many pages to break at a time, using a
> single allocation. Bigger the chunk size, more pages need to be
> allocated ahead of time.
> 
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   Documentation/virt/kvm/api.rst    | 26 ++++++++++++++++++++++++++
>   arch/arm64/include/asm/kvm_host.h |  2 ++
>   arch/arm64/kvm/arm.c              | 22 ++++++++++++++++++++++
>   arch/arm64/kvm/mmu.c              |  3 +++
>   include/uapi/linux/kvm.h          |  1 +
>   5 files changed, 54 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9807b05a1b57..a9332e331cce 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8284,6 +8284,32 @@ structure.
>   When getting the Modified Change Topology Report value, the attr->addr
>   must point to a byte where the value will be stored or retrieved from.
>   
> +8.40 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> +---------------------------------------
> +
> +:Capability: KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> +:Architectures: arm64
> +:Type: vm
> +:Parameters: arg[0] is the new chunk size.
> +:Returns: 0 on success, -EINVAL if any memslot has been created.
> +
> +This capability sets the chunk size used in Eager Page Splitting.
> +
> +Eager Page Splitting improves the performance of dirty-logging (used
> +in live migrations) when guest memory is backed by huge-pages.  This
> +optimization is enabled by default on arm64. It avoids splitting
> +huge-pages (into PAGE_SIZE pages) on fault, by doing it eagerly when
> +enabling dirty logging (with the KVM_MEM_LOG_DIRTY_PAGES flag for a
> +memory region), or when using KVM_CLEAR_DIRTY_LOG.
> +
> +The chunk size specifies how many pages to break at a time, using a
> +single allocation for each chunk. Bigger the chunk size, more pages
> +need to be allocated ahead of time. A good heuristic is to pick the
> +size of the huge-pages as the chunk size.
> +
> +If the chunk size (arg[0]) is zero, then no eager page splitting is
> +performed. The default value PMD size (e.g., 2M when PAGE_SIZE is 4K).
> +
>   9. Known KVM API problems
>   =========================
>   
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 35a159d131b5..a69a815719cf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -153,6 +153,8 @@ struct kvm_s2_mmu {
>   	/* The last vcpu id that ran on each physical CPU */
>   	int __percpu *last_vcpu_ran;
>   
> +#define KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT	PMD_SIZE
> +
>   	struct kvm_arch *arch;
>   };
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9c5573bc4614..c80617ced599 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -101,6 +101,22 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		r = 0;
>   		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
>   		break;
> +	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> +		mutex_lock(&kvm->lock);
> +		mutex_lock(&kvm->slots_lock);
> +		/*
> +		 * To keep things simple, allow changing the chunk
> +		 * size only if there are no memslots created.
> +		 */
> +		if (!kvm_are_all_memslots_empty(kvm)) {
> +			r = -EINVAL;
> +		} else {
> +			r = 0;
> +			kvm->arch.mmu.split_page_chunk_size = cap->args[0];
> +		}
> +		mutex_unlock(&kvm->slots_lock);
> +		mutex_unlock(&kvm->lock);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		break;
> @@ -298,6 +314,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_ARM_PTRAUTH_GENERIC:
>   		r = system_has_full_ptr_auth();
>   		break;
> +	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> +		if (kvm)
> +			r = kvm->arch.mmu.split_page_chunk_size;
> +		else
> +			r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +		break;
>   	default:
>   		r = 0;
>   	}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 812633a75e74..e2ada6588017 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -755,6 +755,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   	for_each_possible_cpu(cpu)
>   		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
>   
> +	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
> +	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +
>   	mmu->pgt = pgt;
>   	mmu->pgd_phys = __pa(pgt->pgd);
>   	return 0;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 55155e262646..02e05f7918e2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1175,6 +1175,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
>   #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>   #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
> +#define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 226
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> 

mmu->split_page_cache and mmu->split_page_chunk_size are defined in PATCH[09/12].
I think you need move the definitions to PATCH[08/12] instead. Otherwise, git-bisect
is broken.

Thanks,
Gavin

