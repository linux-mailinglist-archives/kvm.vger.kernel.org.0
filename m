Return-Path: <kvm+bounces-26222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FEB3973136
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 344E81C255AD
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C21519EEBB;
	Tue, 10 Sep 2024 10:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0of05pz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9672819ADB6
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962685; cv=none; b=TXDcsTfz5u9mb35b4Us36/81gKp9wQx7CdRC97CkkonXfYrCRi8VaczlpgOZJNbjAPWCGKRAbYZlQ1tGddjGHOd08o9RWrYLl+Shz42mncxTsav4INKVsD1/4f2w+arwDp7s4elBlPOH1KhAu+RJ5x3SF9/PWs0z9yiFzZLRHbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962685; c=relaxed/simple;
	bh=c1q+2ZRMkIemQg5aKWOwHHskC4R3MMARGodpVyx0GPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iXZJqrlsG0sue83zOPqzFnTFvmokfvOK2beD+FndFOL8XFOy0ZzWlknkTYPGUoGQ1OQ0TBljvMztQ4TbPT0B93zAVE6D0T91GQqi/57EO4sLVYEBFXZEKSAjTaIYMiF5E3xYj2iPA1vidMZ7Kqwvs1jw1nwLq3LDPI8crw35leo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0of05pz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725962682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kabCxL/6w6s9bJiFniqx3kSTgIzeS/1Z08vJuRnvWiA=;
	b=N0of05pzYcMOQeaMkCcZH0Q+k8oGVbAX1Mhn8Q3MwJ68tCeoLxPVwhkqFZekDyO53MREmJ
	1cx9EP4J8C/HtI4XFVX0z6vEuPzWcPOYyvXG5WdfT9OUZwbTq7Ej7D6Zp2POJd/IIf9kop
	bJqm3ZxuDQLjhif2HyF5Bv+/4RvssFY=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-W3FYrmF5MT-2hxnhXOPJPg-1; Tue, 10 Sep 2024 06:04:41 -0400
X-MC-Unique: W3FYrmF5MT-2hxnhXOPJPg-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5365b1f0c2bso3173454e87.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:04:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725962679; x=1726567479;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kabCxL/6w6s9bJiFniqx3kSTgIzeS/1Z08vJuRnvWiA=;
        b=J6e1RGgW3pJ9lCgy5hJQCzYTC0sSI9jZqom+kTvQzUcEQUCCbdaHNRKzxltHGhaeCl
         QaQjF6hlfa4tLmFY+gddevdYSX1OV884ybNQg9T7TDaPP3aFkJjsiU/rExiSfw+Jg3m6
         ygPbr63BllsNcXZRePylUlkNh/Q6f9ja2VeIl2Zq1QP/2mXp9hsMme4OnFIvNVcKktnJ
         5foEyMtD5q/8WDb9aCRFT2HKxjUYMXUsqniGXcahjue091pPwYHyd4UcCVNECQPsVZay
         sjSPuFShtQ4rCmvo0hHFDqWK+SdWvLs8TBBvMp1ZGMVCE2bADxOyr9Cw4ya92nsNahCW
         d/qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuSoDTI6BXdZdn/AVnhSp5cn8dr9QjbojQYtOTWXTxWM7Ik6/x+aX5R26UFNC45ejJOLs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeWjJKLZscdRIljor7wWa5LvHaJniC7d93K/5wKZwCZ9CTXSsm
	Jg7XXWsW0AxhknSgWvQfJ3Q1lvSSccoE6XZrMmr/W36zZpF6obAt/gqQUstH7CAxvW+tZJotjlN
	X6H+5KJqoO/21SbmLNDcNI+VdYV65nJT/BnYq5GQ7yM9yEzINfQHVueTgMIBy
X-Received: by 2002:a05:6512:39ce:b0:536:54df:bff2 with SMTP id 2adb3069b0e04-53658812f84mr9622740e87.54.1725962678923;
        Tue, 10 Sep 2024 03:04:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+PoFLbcRKIJkJNVfdmgaoelN5gExicdgOdCqJVTkL4CGjPFfbnWqFRTQk4Pv12lYKO58SlA==
X-Received: by 2002:a05:6512:39ce:b0:536:54df:bff2 with SMTP id 2adb3069b0e04-53658812f84mr9622706e87.54.1725962678246;
        Tue, 10 Sep 2024 03:04:38 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42cb73ab096sm68228645e9.22.2024.09.10.03.04.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:04:37 -0700 (PDT)
Message-ID: <b791a3f6-a5ab-4f7e-bb2a-d277b26ec2c4@redhat.com>
Date: Tue, 10 Sep 2024 12:04:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/21] KVM: TDX: MTRR: implement get_mt_mask() for TDX
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-18-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-18-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Although TDX supports only WB for private GPA, it's desirable to support
> MTRR for shared GPA.  Always honor guest PAT for shared EPT as what's done
> for normal VMs.
> 
> Suggested-by: Kai Huang <kai.huang@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU part 2 v1:
>   - Align with latest vmx code in kvm/queue.
>   - Updated patch log.
>   - Dropped KVM_BUG_ON() in vt_get_mt_mask(). (Rick)

The only difference at this point is

         if (!static_cpu_has(X86_FEATURE_SELFSNOOP) &&
             !kvm_arch_has_noncoherent_dma(vcpu->kvm))
                 return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | 
VMX_EPT_IPAT_BIT;


which should never be true.  I think this patch can simply be dropped.

Paolo

> +static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_get_mt_mask(vcpu, gfn, is_mmio);
> +
> +	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
> +}
> +
>   static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -292,7 +300,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.set_tss_addr = vmx_set_tss_addr,
>   	.set_identity_map_addr = vmx_set_identity_map_addr,
> -	.get_mt_mask = vmx_get_mt_mask,
> +	.get_mt_mask = vt_get_mt_mask,
>   
>   	.get_exit_info = vmx_get_exit_info,
>   
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 435112562954..50ce24905062 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -374,6 +374,14 @@ int tdx_vm_init(struct kvm *kvm)
>   	return 0;
>   }
>   
> +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +{
> +	if (is_mmio)
> +		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> +
> +	return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> +}
> +
>   int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 66829413797d..d8a00ab4651c 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -128,6 +128,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>   
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>   
> @@ -153,6 +154,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
>   static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>   static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
> +static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
>   
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>   


