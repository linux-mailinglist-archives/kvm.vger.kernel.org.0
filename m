Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73DD7CF310
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 10:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbjJSInb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 04:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345115AbjJSInF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 04:43:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2B1AB
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697704924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vGK+hSgFfYjiRKwMyBTzzh6ZEkWcBlSDg4646KYldsk=;
        b=QqKY2OWFAEH68SFQ1OJ3PiN03R+txtGgkUmJGC0KcRgUZpIX/ZMoMzV85piKgIwVEZ8VL/
        WkGhqkqsHD8snf3coHadL1GCdujlMBn6irgPyk6o2KObm/WT9+8JpNMePNXAJ0Lfb75ENA
        88B4EDxqnOGJqEIICa0cu96gE/KAAW4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-rx9mZEvHPE6zC-E8EvfTnQ-1; Thu, 19 Oct 2023 04:42:02 -0400
X-MC-Unique: rx9mZEvHPE6zC-E8EvfTnQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9a9e12a3093so64197366b.0
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:42:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697704921; x=1698309721;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vGK+hSgFfYjiRKwMyBTzzh6ZEkWcBlSDg4646KYldsk=;
        b=AY7DTdd76rWHJqBOMMiwxUPkKGFpKepD/9TVU2OBvtedAiUE+B8D2IBhJxeZPbxw5T
         mM+4Jv8B7XFIBNVmt0Cj2QuJ8OATFRvGGIAz+RCRj6ZSnXRRqzSAHKgmvA8Ovig5dP89
         SBI6+SmI8163LWLt3DRO9EKOHmd3nqUKtQgXSpJm1HoL2gswg8UDJfDatlZq9u7/u5ZC
         VdC/D+rmXpDZwiagX5Mc1FbAjDP8ll7KGthJ1A8Ov4l6pZmiCbq9o/3Gcwb2n6PIxt5Y
         wg1n0CQ4pOED6LVMSFrwgdZ07rrhTgjkN7sVlowHG8o4l74dF4Wlqc8RTvh2pemFwFPl
         7Uhg==
X-Gm-Message-State: AOJu0YytjeMvUxsNOfiiHmHT3oIuKNAkXZtATd3bU8BSHGwAhRwVjqJF
        lDjsVoE57WwywAuN+nNha2HvoSjbSwqOmmSlP7y2Tzo+O5ePcRcLyyK2ECngU/iXZRegRaJoFwO
        QonamKZ2VM7uE
X-Received: by 2002:a17:906:7951:b0:9b2:be5e:3674 with SMTP id l17-20020a170906795100b009b2be5e3674mr1197946ejo.36.1697704921613;
        Thu, 19 Oct 2023 01:42:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQ1BG4b6jNv9iIaBTLiXVkoHYtlB43Tr9jZFdJbu5AO5W4UbtvXIvAh56Wk8wNUVrypXZoPg==
X-Received: by 2002:a17:906:7951:b0:9b2:be5e:3674 with SMTP id l17-20020a170906795100b009b2be5e3674mr1197925ejo.36.1697704921302;
        Thu, 19 Oct 2023 01:42:01 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id y4-20020a1709064b0400b009b947aacb4bsm3117049eju.191.2023.10.19.01.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 01:42:00 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Declare flush_remote_tlbs{_range}() hooks
 iff HYPERV!=n
In-Reply-To: <20231018192325.1893896-1-seanjc@google.com>
References: <20231018192325.1893896-1-seanjc@google.com>
Date:   Thu, 19 Oct 2023 10:41:59 +0200
Message-ID: <87wmvj57hk.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Declare the kvm_x86_ops hooks used to wire up paravirt TLB flushes when
> running under Hyper-V if and only if CONFIG_HYPERV!=n.  Wrapping yet more
> code with IS_ENABLED(CONFIG_HYPERV) eliminates a handful of conditional
> branches, and makes it super obvious why the hooks *might* be valid.
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  2 ++
>  arch/x86/include/asm/kvm_host.h    | 12 ++++++++++++
>  arch/x86/kvm/mmu/mmu.c             | 12 ++++--------
>  3 files changed, 18 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 26b628d84594..f482216bbdb8 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -55,8 +55,10 @@ KVM_X86_OP(set_rflags)
>  KVM_X86_OP(get_if_flag)
>  KVM_X86_OP(flush_tlb_all)
>  KVM_X86_OP(flush_tlb_current)
> +#if IS_ENABLED(CONFIG_HYPERV)
>  KVM_X86_OP_OPTIONAL(flush_remote_tlbs)
>  KVM_X86_OP_OPTIONAL(flush_remote_tlbs_range)
> +#endif
>  KVM_X86_OP(flush_tlb_gva)
>  KVM_X86_OP(flush_tlb_guest)
>  KVM_X86_OP(vcpu_pre_run)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7c228ae05df0..f0d1ac871465 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1614,9 +1614,11 @@ struct kvm_x86_ops {
>  
>  	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
>  	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
> +#if IS_ENABLED(CONFIG_HYPERV)
>  	int  (*flush_remote_tlbs)(struct kvm *kvm);
>  	int  (*flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
>  					gfn_t nr_pages);
> +#endif
>  
>  	/*
>  	 * Flush any TLB entries associated with the given GVA.
> @@ -1825,6 +1827,7 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
>  #define __KVM_HAVE_ARCH_VM_FREE
>  void kvm_arch_free_vm(struct kvm *kvm);
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>  static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>  {
> @@ -1836,6 +1839,15 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>  }
>  
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn,
> +						   u64 nr_pages)
> +{
> +	if (!kvm_x86_ops.flush_remote_tlbs_range)
> +		return -EOPNOTSUPP;
> +
> +	return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);
> +}
> +#endif /* CONFIG_HYPERV */
>  
>  #define kvm_arch_pmi_in_guest(vcpu) \
>  	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5d3dc7119e57..0702f5234d69 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -271,15 +271,11 @@ static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu,
>  
>  static inline bool kvm_available_flush_remote_tlbs_range(void)
>  {
> +#if IS_ENABLED(CONFIG_HYPERV)
>  	return kvm_x86_ops.flush_remote_tlbs_range;
> -}
> -
> -int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
> -{
> -	if (!kvm_x86_ops.flush_remote_tlbs_range)
> -		return -EOPNOTSUPP;
> -
> -	return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);
> +#else
> +	return false;
> +#endif
>  }
>  
>  static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index);
>
> base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc

Makes sense,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

I can take it to my CONFIG_KVM_HYPERV series but it doesn't seem to
intersect with it so I guess there's no need for that.

-- 
Vitaly

