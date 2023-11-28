Return-Path: <kvm+bounces-2581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 040847FB313
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:46:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A27EB1F20F54
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131A014010;
	Tue, 28 Nov 2023 07:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UiIGG7Gr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8240D1AE
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701157572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wb25FdrboGaZvJETW0bMwe9DFjRK33J4XlIEQW2L1fM=;
	b=UiIGG7GrpgxorCGtlqZ6UMl/K2gEJ3HXxFFlRqJE0jxxJUh36GPK0tb72LPhmGfKQkMjnc
	nLCWsO1tKdY0TGWJYwug3PXboSRy6XwwsVh4RqvFeO3wU+EOpU8vHRtbZvHYn3r53ITmXZ
	d+1ONn2Yz2Kup4+NoUmqStjqeHLIIoU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-xNqtdIRoMi21eKN8osYERg-1; Tue, 28 Nov 2023 02:46:11 -0500
X-MC-Unique: xNqtdIRoMi21eKN8osYERg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40b29868c6eso30122575e9.3
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:46:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701157570; x=1701762370;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wb25FdrboGaZvJETW0bMwe9DFjRK33J4XlIEQW2L1fM=;
        b=HYVX27OnOrn0hU1qK6LO8rHBiPuPPTjPDcuCIDNYad+XDyu/gElSnspWdOH/uFAiUA
         1jbXzebxVjfc+x67bxSpeca70fKTN744MDcGP5BRk2I9uNffKDb/5nlC+3dElp0Vu4AT
         G02Z4Vr5abR29SezAAeai9Mjk6tKohy165Fs1U7DQvYRA14/TgVQNakvmNnf2IIzF+TK
         znTRu2GQ2d4/ZzPUimccI4fxnIecLwtHMT7rqmDnu/7zDA78TjLbLCY4Cio23Z1G3eCC
         CZTKtr7E6bWxXkbMMajMuvYNCAs4UN3UqPtDJDXsj5IxUFYXtdn/HMPaZ2UjIU/ycjBl
         AYKA==
X-Gm-Message-State: AOJu0YyHfMnptW2amUojcJC0dkxshRuAaC7DQ6PbbaQVBDZfcvBRBW0B
	vpBYDOjz2/Ef2T0I+OpsGpZCAg/nyrraawgm4Y1pI2eYCf1vp6KEI8O+nc/Uec57u7iYf/J8ItJ
	NajSpq65bQA6t
X-Received: by 2002:a05:600c:3b87:b0:401:b2c7:34a8 with SMTP id n7-20020a05600c3b8700b00401b2c734a8mr10311392wms.7.1701157570374;
        Mon, 27 Nov 2023 23:46:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFM7X409mjq5z4s/W9dIlio0yKzGMUB5yp4pNmEB/Qs5xVM/kuQuPrmslzwru1Fpb2W+QylOQ==
X-Received: by 2002:a05:600c:3b87:b0:401:b2c7:34a8 with SMTP id n7-20020a05600c3b8700b00401b2c734a8mr10311382wms.7.1701157570040;
        Mon, 27 Nov 2023 23:46:10 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id az15-20020a05600c600f00b0040b2b9bf321sm17200797wmb.9.2023.11.27.23.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 23:46:09 -0800 (PST)
Message-ID: <c55ae0a19330d3e1d4aaa92f33193d9861bd12bb.camel@redhat.com>
Subject: Re: [RFC 27/33] KVM: x86/mmu/hyper-v: Validate memory faults
 against per-VTL memprots
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 anelkz@amazon.com,  graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com,
 corbert@lwn.net,  kys@microsoft.com, haiyangz@microsoft.com,
 decui@microsoft.com, x86@kernel.org,  linux-doc@vger.kernel.org
Date: Tue, 28 Nov 2023 09:46:07 +0200
In-Reply-To: <20231108111806.92604-28-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-28-nsaenz@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-08 at 11:18 +0000, Nicolas Saenz Julienne wrote:
> Introduce a new step in __kvm_faultin_pfn() that'll validate the
> fault against the vCPU's VTL protections and generate a user space exit
> when invalid.
> 
> Note that kvm_hv_faultin_pfn() has to be run after resolving the fault
> against the memslots, since that operation steps over
> 'fault->map_writable'.
> 
> Non VSM users shouldn't see any behaviour change.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---
>  arch/x86/kvm/hyperv.c  | 66 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/hyperv.h  |  1 +
>  arch/x86/kvm/mmu/mmu.c |  9 +++++-
>  3 files changed, 75 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index bcace0258af1..eb6a4848e306 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -42,6 +42,8 @@
>  #include "irq.h"
>  #include "fpu.h"
>  
> +#include "mmu/mmu_internal.h"
> +
>  #define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, HV_VCPUS_PER_SPARSE_BANK)
>  
>  /*
> @@ -3032,6 +3034,55 @@ struct kvm_hv_vtl_dev {
>  	struct xarray mem_attrs;
>  };
>  
> +static struct xarray *kvm_hv_vsm_get_memprots(struct kvm_vcpu *vcpu);
> +
> +bool kvm_hv_vsm_access_valid(struct kvm_page_fault *fault, unsigned long attrs)
> +{
> +	if (attrs == KVM_MEMORY_ATTRIBUTE_NO_ACCESS)
> +		return false;
> +
> +	/* We should never get here without read permissions, force a fault. */
> +	if (WARN_ON_ONCE(!(attrs & KVM_MEMORY_ATTRIBUTE_READ)))
> +		return false;
> +
> +	if (fault->write && !(attrs & KVM_MEMORY_ATTRIBUTE_WRITE))
> +		return false;
> +
> +	if (fault->exec && !(attrs & KVM_MEMORY_ATTRIBUTE_EXECUTE))
> +		return false;
> +
> +	return true;
> +}
> +
> +static unsigned long kvm_hv_vsm_get_memory_attributes(struct kvm_vcpu *vcpu,
> +						      gfn_t gfn)
> +{
> +	struct xarray *prots = kvm_hv_vsm_get_memprots(vcpu);
> +
> +	if (!prots)
> +		return 0;
> +
> +	return xa_to_value(xa_load(prots, gfn));
> +}
> +
> +int kvm_hv_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +{
> +	unsigned long attrs;
> +
> +	attrs = kvm_hv_vsm_get_memory_attributes(vcpu, fault->gfn);
> +	if (!attrs)
> +		return RET_PF_CONTINUE;
> +
> +	if (kvm_hv_vsm_access_valid(fault, attrs)) {
> +		fault->map_executable =
> +			!!(attrs & KVM_MEMORY_ATTRIBUTE_EXECUTE);
> +		fault->map_writable = !!(attrs & KVM_MEMORY_ATTRIBUTE_WRITE);
> +		return RET_PF_CONTINUE;
> +	}
> +
> +	return -EFAULT;
> +}
> +
>  static int kvm_hv_vtl_get_attr(struct kvm_device *dev,
>  			       struct kvm_device_attr *attr)
>  {
> @@ -3120,6 +3171,21 @@ static struct kvm_device_ops kvm_hv_vtl_ops = {
>  	.get_attr = kvm_hv_vtl_get_attr,
>  };
>  
> +static struct xarray *kvm_hv_vsm_get_memprots(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_hv_vtl_dev *vtl_dev;
> +	struct kvm_device *tmp;
> +
> +	list_for_each_entry(tmp, &vcpu->kvm->devices, vm_node)
> +		if (tmp->ops == &kvm_hv_vtl_ops) {
> +			vtl_dev = tmp->private;
> +			if (vtl_dev->vtl == kvm_hv_get_active_vtl(vcpu))
> +				return &vtl_dev->mem_attrs;
> +		}
> +
> +	return NULL;
> +}
> +
>  static int kvm_hv_vtl_create(struct kvm_device *dev, u32 type)
>  {
>  	struct kvm_hv_vtl_dev *vtl_dev;
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 3cc664e144d8..ae781b4d4669 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -271,5 +271,6 @@ static inline void kvm_mmu_role_set_hv_bits(struct kvm_vcpu *vcpu,
>  
>  int kvm_hv_vtl_dev_register(void);
>  void kvm_hv_vtl_dev_unregister(void);
> +int kvm_hv_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  
>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a76028aa8fb3..ba454c7277dc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4374,7 +4374,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  					  fault->write, &fault->map_writable,
>  					  &fault->hva);
>  	if (!async)
> -		return RET_PF_CONTINUE; /* *pfn has correct page already */
> +		goto pf_continue; /* *pfn has correct page already */
>  
>  	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
>  		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
> @@ -4395,6 +4395,13 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
>  					  fault->write, &fault->map_writable,
>  					  &fault->hva);
> +pf_continue:
> +	if (kvm_hv_vsm_enabled(vcpu->kvm)) {
> +		if (kvm_hv_faultin_pfn(vcpu, fault)) {
> +			kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> +			return -EFAULT;
> +		}
> +	}
>  	return RET_PF_CONTINUE;
>  }
>  

If we don't go with Sean's suggestion of having a VM per VTL,
then this feature should be VSM agnostic IMHO, because it might be useful for other security features that might
want to change the guest memory protection based on some 'level' like VSM.

Even SMM to some extent fits this description although in theory I think that SMM can have "different" memory mapped to the same GPA.

Best regards,
	Maxim Levitsky



