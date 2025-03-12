Return-Path: <kvm+bounces-40849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE52AA5E3C5
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 19:39:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F375E17578A
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 18:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CEEA257430;
	Wed, 12 Mar 2025 18:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WHEtGdiK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAD1256C6A
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 18:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741804768; cv=none; b=RRVz37rc0ousEpOCyxlyCDIGB1qovw2Sel+El/tG82pBR9yC6KXbkv+f9wFkVJRlXlo3yEoaV7ATmRY81ArCj87e4OUV9rhFKxLsCBjJsS0L6GXhg0ES7KM11ZDoRcd8jntPXNrgCn2Q4g+Qcc5WZGE0wjAgVrrQvmb3LfDWo3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741804768; c=relaxed/simple;
	bh=wVF5UCJq8TwNkOCogaMkn5fk/pOwfq9wFtAG/vz6GOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kd1JAiFn5kdk3BTToN3cjOqjgZYHTF3FjRAlECS+1yGwPISCbJ3NzwoyXCjH6JDa0G4i2+Nwg88FZbLkbiJd3r8j7lxb3oD0iFJ9a1gR7SmNy5TrlhXlOLjapCF3Dts03++nOjD4HrNsw7BzYpXwzreNTo8dEvHUOC8QILIxOkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WHEtGdiK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741804765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FpAQlvDURVXWfuuOfiLPpYSES6FxJzxrvh27SN0EPb0=;
	b=WHEtGdiK4XcW+bsstegrHfOTghhdb+uRFrTctUgC08yzYhXJTLT16Ud9S+FxBgvJes9YJB
	FBGdH3N/aoS52pZVYypddvw9CMOvXNtBC1OidNB+FegbsoqImoXb4fHuEho9hcc07v5SG6
	hjSOuh18J0eMKq/QSAqkltmv3pcs7u8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-nUZe4oHnP6-stiuLsWwwvg-1; Wed, 12 Mar 2025 14:39:24 -0400
X-MC-Unique: nUZe4oHnP6-stiuLsWwwvg-1
X-Mimecast-MFC-AGG-ID: nUZe4oHnP6-stiuLsWwwvg_1741804763
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43cf446681cso540175e9.1
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 11:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741804763; x=1742409563;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FpAQlvDURVXWfuuOfiLPpYSES6FxJzxrvh27SN0EPb0=;
        b=J/Ms8qKpzvMwD5mbwEWwoPSAyCKfnc7jTvTinTARAJHxORT9YQImBq5uoknuiWFiOk
         KDHWokfKcepunxbYApW1hueSytFI3RknfcGNeVc62tt6RzEDnBdB/N9Ddg4sO8g8k6vL
         1Ls4gEsrGt6ZQs9dtA7koGXfZvyhpzuuaV6vV6ROWp1xqo/v+uMESS+ZkTL2z4OB44Yg
         pdzsNe8WuZ3WccNFnOsxfg1DSJK6Fx52ainzXVTv4qoalzVKFl4qcnJFretxfg+i8V9u
         mBi8d0mD6EkdGK1PbCxI7SnPhlpvEZNiAydI17LO6gfyeEsnwBdk72NSsf3420kVp9F6
         /S6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWCI+7m2ODzl3aO07VOeLGjh4AKPqY/wrnss3LD/keo6OEmNpqDDTeVAGVyHhbmz1O8fm0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvYwhgpv6m0juCxeuo3HUuzmBfzudF37cAeCMYYi8hoeftMs1U
	aEWI91ceYiEYgiuwHH3KUs9l5ojOqIhBdVlkoDAwt5FmKcKSxfBQaEQZabS2RnalITpjjmfZ+2E
	q56QFi893gvQ0NrL700je7yNeOlAYcgDqGp9HEy7wEC5oIFwteQ==
X-Gm-Gg: ASbGncvNHXn6q9mnzAg48nkR6n3qQcnLxA8/GvRpjBBfufKENwGyVtIa42rd1Jc0J2+
	jSkD64EpVBvTg7QZkb7a16X1v7xa5i58eGHXvEjosoCsyTbjfq9wRLegJYdxjUB+buR5WnEM7o2
	618iIPDuE1vd3lLVrx2q9gIndgFB0Hru/ml/vcHHbagkw+nIi1qpU+Z3w8LWbrSWmcF5WwLCKZQ
	YVOBcuZWvZ78Wsh6+5atqi5DQ6NKfaO6LOjLvwBZIDeX5W11pdOMnNHSnFS4/mENBjY6hZL/jM2
	xU/8f8xw4ZLKwxXwz3WLuw==
X-Received: by 2002:a05:600c:154d:b0:43d:160:cd97 with SMTP id 5b1f17b1804b1-43d0160cfb3mr81433545e9.25.1741804762795;
        Wed, 12 Mar 2025 11:39:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8Up0exKa8uUyXSVqc46o/ZF8opDLggJlhh9jMidWnfu/BbBjzmo/eHcQWr0AS31ifbuD0MA==
X-Received: by 2002:a05:600c:154d:b0:43d:160:cd97 with SMTP id 5b1f17b1804b1-43d0160cfb3mr81433405e9.25.1741804762391;
        Wed, 12 Mar 2025 11:39:22 -0700 (PDT)
Received: from [192.168.10.81] ([176.206.122.167])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43d0a8d0ab1sm28753375e9.34.2025.03.12.11.39.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 11:39:21 -0700 (PDT)
Message-ID: <052c37b5-8deb-413e-b8cf-966e00f608ef@redhat.com>
Date: Wed, 12 Mar 2025 19:39:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/16] KVM: VMX: Move posted interrupt delivery code to
 common header
To: Binbin Wu <binbin.wu@linux.intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
 <20250222014757.897978-4-binbin.wu@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250222014757.897978-4-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/22/25 02:47, Binbin Wu wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Move posted interrupt delivery code to common header so that TDX can
> leverage it.
> 
> No functional change intended.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> [binbin: split into new patch]
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> ---
> TDX interrupts v3:
>   - fixup comment and add Chao's Reviewed-by
>     https://lore.kernel.org/kvm/20250211025828.3072076-2-binbin.wu@linux.intel.com/T/#m990cab2280c2f5fdaffc22575c3e3e3012a691df
> 
> TDX interrupts v2:
> - Rebased due to moving pi_desc to vcpu_vt.
> 
> TDX interrupts v1:
> - This is split out from patch "KVM: TDX: Implement interrupt injection"
> ---
>   arch/x86/kvm/vmx/common.h | 68 +++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c    | 59 +--------------------------------
>   2 files changed, 69 insertions(+), 58 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 9d4982694f06..8b12d8214b6c 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -4,6 +4,7 @@
>   
>   #include <linux/kvm_host.h>
>   
> +#include "posted_intr.h"

This include is already needed in "KVM: VMX: Move common fields of 
struct vcpu_{vmx,tdx} to a struct" due to

+struct vcpu_vt {
+	/* Posted interrupt descriptor */
+	struct pi_desc pi_desc;

I'll fix it up in kvm-coco-queue.

Paolo

>   #include "mmu.h"
>   
>   union vmx_exit_reason {
> @@ -108,4 +109,71 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>   	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>   }
>   
> +static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
> +						     int pi_vec)
> +{
> +#ifdef CONFIG_SMP
> +	if (vcpu->mode == IN_GUEST_MODE) {
> +		/*
> +		 * The vector of the virtual has already been set in the PIR.
> +		 * Send a notification event to deliver the virtual interrupt
> +		 * unless the vCPU is the currently running vCPU, i.e. the
> +		 * event is being sent from a fastpath VM-Exit handler, in
> +		 * which case the PIR will be synced to the vIRR before
> +		 * re-entering the guest.
> +		 *
> +		 * When the target is not the running vCPU, the following
> +		 * possibilities emerge:
> +		 *
> +		 * Case 1: vCPU stays in non-root mode. Sending a notification
> +		 * event posts the interrupt to the vCPU.
> +		 *
> +		 * Case 2: vCPU exits to root mode and is still runnable. The
> +		 * PIR will be synced to the vIRR before re-entering the guest.
> +		 * Sending a notification event is ok as the host IRQ handler
> +		 * will ignore the spurious event.
> +		 *
> +		 * Case 3: vCPU exits to root mode and is blocked. vcpu_block()
> +		 * has already synced PIR to vIRR and never blocks the vCPU if
> +		 * the vIRR is not empty. Therefore, a blocked vCPU here does
> +		 * not wait for any requested interrupts in PIR, and sending a
> +		 * notification event also results in a benign, spurious event.
> +		 */
> +
> +		if (vcpu != kvm_get_running_vcpu())
> +			__apic_send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
> +		return;
> +	}
> +#endif
> +	/*
> +	 * The vCPU isn't in the guest; wake the vCPU in case it is blocking,
> +	 * otherwise do nothing as KVM will grab the highest priority pending
> +	 * IRQ via ->sync_pir_to_irr() in vcpu_enter_guest().
> +	 */
> +	kvm_vcpu_wake_up(vcpu);
> +}
> +
> +/*
> + * Post an interrupt to a vCPU's PIR and trigger the vCPU to process the
> + * interrupt if necessary.
> + */
> +static inline void __vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu,
> +						  struct pi_desc *pi_desc, int vector)
> +{
> +	if (pi_test_and_set_pir(vector, pi_desc))
> +		return;
> +
> +	/* If a previous notification has sent the IPI, nothing to do.  */
> +	if (pi_test_and_set_on(pi_desc))
> +		return;
> +
> +	/*
> +	 * The implied barrier in pi_test_and_set_on() pairs with the smp_mb_*()
> +	 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU is
> +	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
> +	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
> +	 */
> +	kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR);
> +}
> +
>   #endif /* __KVM_X86_VMX_COMMON_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 008e558a6f41..2d4185df1581 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4186,50 +4186,6 @@ void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
>   		pt_update_intercept_for_msr(vcpu);
>   }
>   
> -static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
> -						     int pi_vec)
> -{
> -#ifdef CONFIG_SMP
> -	if (vcpu->mode == IN_GUEST_MODE) {
> -		/*
> -		 * The vector of the virtual has already been set in the PIR.
> -		 * Send a notification event to deliver the virtual interrupt
> -		 * unless the vCPU is the currently running vCPU, i.e. the
> -		 * event is being sent from a fastpath VM-Exit handler, in
> -		 * which case the PIR will be synced to the vIRR before
> -		 * re-entering the guest.
> -		 *
> -		 * When the target is not the running vCPU, the following
> -		 * possibilities emerge:
> -		 *
> -		 * Case 1: vCPU stays in non-root mode. Sending a notification
> -		 * event posts the interrupt to the vCPU.
> -		 *
> -		 * Case 2: vCPU exits to root mode and is still runnable. The
> -		 * PIR will be synced to the vIRR before re-entering the guest.
> -		 * Sending a notification event is ok as the host IRQ handler
> -		 * will ignore the spurious event.
> -		 *
> -		 * Case 3: vCPU exits to root mode and is blocked. vcpu_block()
> -		 * has already synced PIR to vIRR and never blocks the vCPU if
> -		 * the vIRR is not empty. Therefore, a blocked vCPU here does
> -		 * not wait for any requested interrupts in PIR, and sending a
> -		 * notification event also results in a benign, spurious event.
> -		 */
> -
> -		if (vcpu != kvm_get_running_vcpu())
> -			__apic_send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
> -		return;
> -	}
> -#endif
> -	/*
> -	 * The vCPU isn't in the guest; wake the vCPU in case it is blocking,
> -	 * otherwise do nothing as KVM will grab the highest priority pending
> -	 * IRQ via ->sync_pir_to_irr() in vcpu_enter_guest().
> -	 */
> -	kvm_vcpu_wake_up(vcpu);
> -}
> -
>   static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
>   						int vector)
>   {
> @@ -4289,20 +4245,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
>   	if (!vcpu->arch.apic->apicv_active)
>   		return -1;
>   
> -	if (pi_test_and_set_pir(vector, &vt->pi_desc))
> -		return 0;
> -
> -	/* If a previous notification has sent the IPI, nothing to do.  */
> -	if (pi_test_and_set_on(&vt->pi_desc))
> -		return 0;
> -
> -	/*
> -	 * The implied barrier in pi_test_and_set_on() pairs with the smp_mb_*()
> -	 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU is
> -	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
> -	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
> -	 */
> -	kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR);
> +	__vmx_deliver_posted_interrupt(vcpu, &vt->pi_desc, vector);
>   	return 0;
>   }
>   


