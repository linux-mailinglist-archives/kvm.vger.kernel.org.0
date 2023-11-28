Return-Path: <kvm+bounces-2580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B457FB30A
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6907B281E66
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C74C14A85;
	Tue, 28 Nov 2023 07:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fiZd/QDp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC59D4E
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701157446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KtKgFk3CHBTEPt7gp/Kob8Ku/rlWDYksUTZDpLhR1S0=;
	b=fiZd/QDptuM5MGhjozWDM83wF6y3kYPtWaWgIb8ondEsHTavyhEiClhD57Q73Vi94Kp4SV
	3l1lyklC33xjVSa6YAZWMi0dMaCV9nH9tb5UqXSgTcuyKBXgfD8zECpfOWjDkRvWHR/dxm
	FXIwNKKntyXnJzfnYhRhhJJNCjvAstM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-h7XEhFgqOq-5nyR5Mj23bQ-1; Tue, 28 Nov 2023 02:44:04 -0500
X-MC-Unique: h7XEhFgqOq-5nyR5Mj23bQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-332fcd4b871so1465103f8f.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:44:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701157443; x=1701762243;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KtKgFk3CHBTEPt7gp/Kob8Ku/rlWDYksUTZDpLhR1S0=;
        b=lAK+5XE/4aw3z4K8I7FUiXHQZMtX3Uzi4xMobMmwKVpY06XCqQzJjtf1Dq4mjdP9W+
         Ut826fpPiUbIWndsu3vClOuz3obZOg6ubMDEiY7NNrPQvcX3+9J5VQjS1tU2nw0Z0LBS
         ioflNAEzn0GBhfnOceMmGj2PhFjW/JmQiSlcBiyh3ZBCAjzHnAwMcv6Ufs8iPnhf1fBG
         n3HmJ5ncuibctFue6JYUFt6vtOpbd1qEkJgrsmh+z3AEY9muxwhOoBpvgPCTWwRmJJzz
         ktTE0YtqmSPeKn1Z+7/Bdg41WlixAZOD1g2yQtRvYTrvFOMbV5QqxduN0twI736oyNuq
         +Uxg==
X-Gm-Message-State: AOJu0YyBZE9fbaEtFqqht76qUIvr7d3D/IlDdWFzRFLxN8dZYS6owU8s
	hymhKojL6pBOGCtUW2hVAWlUJSl4yvVzAUyTpuREMxknWwXRQZ3vTBZWrho8g+MH2BXcd8V4EKm
	P4IfxOOmTIpFT
X-Received: by 2002:adf:f88d:0:b0:332:e9ff:7fad with SMTP id u13-20020adff88d000000b00332e9ff7fadmr10210251wrp.12.1701157443563;
        Mon, 27 Nov 2023 23:44:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFSrzOfVFXXaYd5bwOlRnKvmus8guyrTlPsH/3Zw/WlyXTEMG/LN54CkOejsPqYFMufXdBSmw==
X-Received: by 2002:adf:f88d:0:b0:332:e9ff:7fad with SMTP id u13-20020adff88d000000b00332e9ff7fadmr10210233wrp.12.1701157443271;
        Mon, 27 Nov 2023 23:44:03 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id r5-20020a5d6c65000000b00332f6202b82sm8573153wrz.9.2023.11.27.23.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 23:44:02 -0800 (PST)
Message-ID: <4f3d9563a4246a97eae28486eee1730d134b222b.camel@redhat.com>
Subject: Re: [RFC 26/33] KVM: x86: hyper-vsm: Allow setting per-VTL memory
 attributes
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 anelkz@amazon.com,  graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com,
 corbert@lwn.net,  kys@microsoft.com, haiyangz@microsoft.com,
 decui@microsoft.com, x86@kernel.org,  linux-doc@vger.kernel.org
Date: Tue, 28 Nov 2023 09:44:00 +0200
In-Reply-To: <20231108111806.92604-27-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-27-nsaenz@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-08 at 11:17 +0000, Nicolas Saenz Julienne wrote:
> Introduce KVM_SET_MEMORY_ATTRIBUTES ioctl support for VTL KVM devices.
> The attributes are stored in an xarray private to the VTL device.
> 
> The following memory attributes are supported:
>  - KVM_MEMORY_ATTRIBUTE_READ
>  - KVM_MEMORY_ATTRIBUTE_WRITE
>  - KVM_MEMORY_ATTRIBUTE_EXECUTE
>  - KVM_MEMORY_ATTRIBUTE_NO_ACCESS
> Although only some combinations are valid, see code comment below.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---
>  arch/x86/kvm/hyperv.c | 61 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 0d8402dba596..bcace0258af1 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -62,6 +62,10 @@
>   */
>  #define HV_EXT_CALL_MAX (HV_EXT_CALL_QUERY_CAPABILITIES + 64)
>  
> +#define KVM_HV_VTL_ATTRS						\
> +	(KVM_MEMORY_ATTRIBUTE_READ | KVM_MEMORY_ATTRIBUTE_WRITE |	\
> +	 KVM_MEMORY_ATTRIBUTE_EXECUTE | KVM_MEMORY_ATTRIBUTE_NO_ACCESS)
> +
>  static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
>  				bool vcpu_kick);
>  
> @@ -3025,6 +3029,7 @@ int kvm_vm_ioctl_get_hv_vsm_state(struct kvm *kvm, struct kvm_hv_vsm_state *stat
>  
>  struct kvm_hv_vtl_dev {
>  	int vtl;
> +	struct xarray mem_attrs;
>  };
>  
>  static int kvm_hv_vtl_get_attr(struct kvm_device *dev,
> @@ -3047,16 +3052,71 @@ static void kvm_hv_vtl_release(struct kvm_device *dev)
>  {
>  	struct kvm_hv_vtl_dev *vtl_dev = dev->private;
>  
> +	xa_destroy(&vtl_dev->mem_attrs);
>  	kfree(vtl_dev);
>  	kfree(dev); /* alloc by kvm_ioctl_create_device, free by .release */
>  }
>  
> +/*
> + * The TLFS lists the valid memory protection combinations (15.9.3):
> + *  - No access
> + *  - Read-only, no execute
> + *  - Read-only, execute
> + *  - Read/write, no execute
> + *  - Read/write, execute
> + */
> +static bool kvm_hv_validate_vtl_mem_attributes(struct kvm_memory_attributes *attrs)
> +{
> +	u64 attr = attrs->attributes;
> +
> +	if (attr & ~KVM_HV_VTL_ATTRS)
> +		return false;
> +
> +	if (attr == KVM_MEMORY_ATTRIBUTE_NO_ACCESS)
> +		return true;
> +
> +	if (!(attr & KVM_MEMORY_ATTRIBUTE_READ))
> +		return false;
> +
> +	return true;
> +}
> +
> +static long kvm_hv_vtl_ioctl(struct kvm_device *dev, unsigned int ioctl,
> +			     unsigned long arg)
> +{
> +	switch (ioctl) {
> +	case KVM_SET_MEMORY_ATTRIBUTES: {
> +		struct kvm_hv_vtl_dev *vtl_dev = dev->private;
> +		struct kvm_memory_attributes attrs;
> +		int r;
> +
> +		if (copy_from_user(&attrs, (void __user *)arg, sizeof(attrs)))
> +			return -EFAULT;
> +
> +		r = -EINVAL;
> +		if (!kvm_hv_validate_vtl_mem_attributes(&attrs))
> +			return r;
> +
> +		r = kvm_ioctl_set_mem_attributes(dev->kvm, &vtl_dev->mem_attrs,
> +						 KVM_HV_VTL_ATTRS, &attrs);
> +		if (r)
> +			return r;
> +		break;
> +	}
> +	default:
> +		return -ENOTTY;
> +	}
> +
> +	return 0;
> +}
> +
>  static int kvm_hv_vtl_create(struct kvm_device *dev, u32 type);
>  
>  static struct kvm_device_ops kvm_hv_vtl_ops = {
>  	.name = "kvm-hv-vtl",
>  	.create = kvm_hv_vtl_create,
>  	.release = kvm_hv_vtl_release,
> +	.ioctl = kvm_hv_vtl_ioctl,
>  	.get_attr = kvm_hv_vtl_get_attr,
>  };
>  
> @@ -3076,6 +3136,7 @@ static int kvm_hv_vtl_create(struct kvm_device *dev, u32 type)
>  			vtl++;
>  
>  	vtl_dev->vtl = vtl;
> +	xa_init(&vtl_dev->mem_attrs);
>  	dev->private = vtl_dev;
>  
>  	return 0;

It makes sense, but hopefully we won't need it if we adopt the VM per VTL approach.

Best regards,
	Maxim Levitsky




