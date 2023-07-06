Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE1674949F
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 06:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjGFEPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 00:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjGFEPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 00:15:23 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408A31988;
        Wed,  5 Jul 2023 21:15:22 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-666e64e97e2so219394b3a.1;
        Wed, 05 Jul 2023 21:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688616921; x=1691208921;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IIs1Ic3kA6qxFm0PBui1PCyprdvyTG+DQnNhEQH+f60=;
        b=biJNVE7TnITK7Jn8jArQ6ai5UK/8sHSUU4C04rH/HSb//GFyfN+0zV2uGYAM1mNIpR
         NqYQCMoo0xsYDswOeUa4TTHku6lXSv2DJ8It9gug6NNyUNBFO2pnC8qnxhn/AyaaG4bS
         9QAeStpV+Q60mDniYwHKKEKqgfkJJ7jnTwQY9qqOCQQReHyd5jrRmS51Qb9KmpZ9Iuom
         Uiy8GvWaf1S9BVQbctQuSJGW2q03mLaD49oST4zr31vnM6aeG4UoUsiJ/gbskg8eagI2
         +/KAQr7Vpc3YP5irCnnwpFOZJthlJFKN7MB98giNzyC//vubSnXOw+0ZU17rTbqahvse
         M2cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688616921; x=1691208921;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IIs1Ic3kA6qxFm0PBui1PCyprdvyTG+DQnNhEQH+f60=;
        b=h+I3qDcjFtEERC8u7lm6jhBlctnpXqANtiuhXYac931TEjvLhDMhBIYWCbws3MhfzC
         bhF9NIgsbu39oiQwmdemH/jpz0tShVlJN+FNJ9jugZE0BvAsU30DT6FlCNIA3a24VtLb
         UsfhznXG10tK8Hrf32QHZTmFzhZYl7U7NEQq9klAgo/JyF8wHi8YXTxyYt3gZfv/6qmh
         S43NdVg0CmF9wHFGmnNqC97UI+9t8PVpKu4ko5lNkG0IKGKYbAQwepXa4cQGKkQzydrJ
         +sR7F0RpAwfIjBgyyozF8z2u20nYpYIbgD8Gf8xWgjl0XAn1DDnB8rx3DHdjkTD2cv4y
         BnoQ==
X-Gm-Message-State: ABy/qLYx6FrFdVKjDQg53Ppl2qoFpgXPN7M5PZmJ6nCIZLozXGjiniA2
        End5TYy5/JYhJO4wRMH0dIStfvXDQJYUow==
X-Google-Smtp-Source: APBJJlGLdBFHS/nuBRHjP4lzjj/zANJe18hspko8zTFNvPvy0FVqup/zYik1d/W12JUvN8zTeOnP/A==
X-Received: by 2002:a05:6a00:1acb:b0:66a:5466:25c6 with SMTP id f11-20020a056a001acb00b0066a546625c6mr543165pfv.18.1688616920834;
        Wed, 05 Jul 2023 21:15:20 -0700 (PDT)
Received: from localhost-live.default (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id g18-20020aa78752000000b0064d681c753csm302246pfo.40.2023.07.05.21.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 21:15:20 -0700 (PDT)
Subject: Re: [PATCH] KVM: ppc64: Enable ring-based dirty memory tracking
To:     Kautuk Consul <kconsul@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>, jpn@linux.vnet.ibm.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org
References: <20230608123448.71861-1-kconsul@linux.vnet.ibm.com>
From:   Jordan Niethe <jniethe5@gmail.com>
Message-ID: <266701ad-90df-e4c8-bbf7-c6411b759c5f@gmail.com>
Date:   Thu, 6 Jul 2023 14:15:13 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20230608123448.71861-1-kconsul@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/6/23 10:34 pm, Kautuk Consul wrote:

Need at least a little context in the commit message itself:

"Enable ring-based dirty memory tracking on ppc64:"

> - Enable CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL as ppc64 is weakly
>    ordered.
> - Enable CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP because the
>    kvmppc_xive_native_set_attr is called in the context of an ioctl
>    syscall and will call kvmppc_xive_native_eq_sync for setting the
>    KVM_DEV_XIVE_EQ_SYNC attribute which will call mark_dirty_page()
>    when there isn't a running vcpu. Implemented the
>    kvm_arch_allow_write_without_running_vcpu to always return true
>    to allow mark_page_dirty_in_slot to mark the page dirty in the
>    memslot->dirty_bitmap in this case.

Should kvm_arch_allow_write_without_running_vcpu() only return true in 
the context of kvmppc_xive_native_eq_sync()?

> - Set KVM_DIRTY_LOG_PAGE_OFFSET for the ring buffer's physical page
>    offset.
> - Implement the kvm_arch_mmu_enable_log_dirty_pt_masked function required
>    for the generic KVM code to call.
> - Add a check to kvmppc_vcpu_run_hv for checking whether the dirty
>    ring is soft full.
> - Implement the kvm_arch_flush_remote_tlbs_memslot function to support
>    the CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT config option.
> 
> On testing with live migration it was found that there is around
> 150-180 ms improvment in overall migration time with this
> 
> Signed-off-by: Kautuk Consul <kconsul@linux.vnet.ibm.com>
> ---
>   Documentation/virt/kvm/api.rst      |  2 +-
>   arch/powerpc/include/uapi/asm/kvm.h |  2 ++
>   arch/powerpc/kvm/Kconfig            |  2 ++
>   arch/powerpc/kvm/book3s_64_mmu_hv.c | 42 +++++++++++++++++++++++++++++
>   arch/powerpc/kvm/book3s_hv.c        |  3 +++
>   include/linux/kvm_dirty_ring.h      |  5 ++++
>   6 files changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index add067793b90..ce1ebc513bae 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8114,7 +8114,7 @@ regardless of what has actually been exposed through the CPUID leaf.
>   8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
>   ----------------------------------------------------------
>   
> -:Architectures: x86, arm64
> +:Architectures: x86, arm64, ppc64
>   :Parameters: args[0] - size of the dirty log ring
>   
>   KVM is capable of tracking dirty memory using ring buffers that are
> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
> index 9f18fa090f1f..f722309ed7fb 100644
> --- a/arch/powerpc/include/uapi/asm/kvm.h
> +++ b/arch/powerpc/include/uapi/asm/kvm.h
> @@ -33,6 +33,8 @@
>   /* Not always available, but if it is, this is the correct offset.  */
>   #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>   
> +#define KVM_DIRTY_LOG_PAGE_OFFSET 64
> +
>   struct kvm_regs {
>   	__u64 pc;
>   	__u64 cr;
> diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
> index 902611954200..c93354ec3bd5 100644
> --- a/arch/powerpc/kvm/Kconfig
> +++ b/arch/powerpc/kvm/Kconfig
> @@ -26,6 +26,8 @@ config KVM
>   	select IRQ_BYPASS_MANAGER
>   	select HAVE_KVM_IRQ_BYPASS
>   	select INTERVAL_TREE
> +	select HAVE_KVM_DIRTY_RING_ACQ_REL
> +	select NEED_KVM_DIRTY_RING_WITH_BITMAP
>   
>   config KVM_BOOK3S_HANDLER
>   	bool
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index 7f765d5ad436..c92e8022e017 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -2147,3 +2147,45 @@ void kvmppc_mmu_book3s_hv_init(struct kvm_vcpu *vcpu)
>   
>   	vcpu->arch.hflags |= BOOK3S_HFLAG_SLB;
>   }
> +
> +/*
> + * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
> + * dirty pages.
> + *
> + * It write protects selected pages to enable dirty logging for them.
> + */
> +void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> +					     struct kvm_memory_slot *slot,
> +					     gfn_t gfn_offset,
> +					     unsigned long mask)
> +{
> +	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
> +	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
> +	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
> +
> +	while (start < end) {
> +		pte_t *ptep;
> +		unsigned int shift;
> +
> +		ptep = find_kvm_secondary_pte(kvm, start, &shift);
> +
> +		*ptep = __pte(pte_val(*ptep) & ~(_PAGE_WRITE));
On rpt I think you'd need to use kvmppc_radix_update_pte()?

> +
> +		start += PAGE_SIZE > +	}
> +}
> +
> +#ifdef CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP
> +bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
> +{
> +	return true;
> +}
> +#endif
> +
> +#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> +void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> +					const struct kvm_memory_slot *memslot)
> +{
> +	kvm_flush_remote_tlbs(kvm);
> +}
> +#endif
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 130bafdb1430..1d1264ea72c4 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4804,6 +4804,9 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
>   		return -EINTR;
>   	}
>   
> +	if (kvm_dirty_ring_check_request(vcpu))
> +		return 0;
> +
>   #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
>   	/*
>   	 * Don't allow entry with a suspended transaction, because
> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> index 4862c98d80d3..a00301059da5 100644
> --- a/include/linux/kvm_dirty_ring.h
> +++ b/include/linux/kvm_dirty_ring.h
> @@ -69,6 +69,11 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
>   {
>   }
>   
> +static inline bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> + >   #else /* CONFIG_HAVE_KVM_DIRTY_RING */
>   
>   int kvm_cpu_dirty_log_size(void);
> 
