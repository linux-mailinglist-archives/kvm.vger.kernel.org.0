Return-Path: <kvm+bounces-20974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E04AD927F83
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45690B2320E
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCF4DDD4;
	Fri,  5 Jul 2024 01:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dSxEm7Z/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B2C18D
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141361; cv=none; b=RV7xCC+LQ3c9e/RQf1nyifXI011st0jLUHvn2Lq0d0cxAe1R1eZU8S5Mo+BYJRt1cX/Nl8bzG8wVK1gNQNrDA3Za8YAxHQbBK4bDqs0fOtaporNMA9k3Epft3eTTi6IRtrHqiGnmaup7kFI2WnZqCrsuRX2OF+YLc3BC+bg0G28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141361; c=relaxed/simple;
	bh=d28O/O1NNXtFdZSLqWx/Hw/P4g98RXkmjaWVisB5hUE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NQ3Ijs5qXGq3hJyC+DNHNJWncw0BOEd06TW+w4R6xVmBjZ5zD1iJ+GVVK/SyCPLVuUPe6fkhAmySDbR2rum63ultt1593MCRihePKh5P7ZNWGjzIe4XbFx7mWVvQe3otplweNwbuHo0r0Jlq1U/fgLz2Xdz9H62tXCRE3GJ7mqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dSxEm7Z/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720141358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gwVWVVn2PQAhE34Slz2JjSzwHzwSSlv06I+ZV3jhpoM=;
	b=dSxEm7Z/ev6fV2lId+HO/SfNmyvYJaeKwDShlHxKE9wVJL62QW6I4GycrPFfuEjfMDdeLo
	SDUwMl6qt7hxXs4ljWIHVTuBYy34XYo6QellT3HP8JcNigeHmzoPKxzU7W/a1fpndB8NMw
	Rht8SIrwsFJ9USLa+sa5H49NNF3TUsw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-hfdIdID2MWCfT2Xxgt5dJg-1; Thu, 04 Jul 2024 21:02:37 -0400
X-MC-Unique: hfdIdID2MWCfT2Xxgt5dJg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6b5e0f00d63so14273706d6.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720141357; x=1720746157;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gwVWVVn2PQAhE34Slz2JjSzwHzwSSlv06I+ZV3jhpoM=;
        b=Yq3Ol6iCEZwoMHt/Jc5gAb+vzns/AIdey5EewgUTnEY5reD0CPAOR/C56YCZfPnP4i
         /HzPdCBpZMORm5i4XY/VroStHPdChefJpHCwlvOcIqq7K2YShg9rjHR1QjxhH/M9I7a0
         XFjo2NXDL5BV/C82IN8V8nF9e6W0S11cxKam0Cy2l/oXRmg+5VkgEoBJk7ubvBricPjO
         LjV7j3vWb+dcmtuUynz5Pk+YZq0N6tJUTX5tNagvf8roWiShhc+P8oja901UrrKUm7xB
         CzHkhlyl6nqs08NOPENNV3TUlBRQkoiwFUN3FD/ImNfsV8sxiPDHmyQ4dYIVbBw3fpGb
         LPjQ==
X-Gm-Message-State: AOJu0YwXraJthLXEDvv+fX7u3dz7VcYc0zhqIhLcL6Lsj2KlNzAX1GxK
	dfOvxCtehHxW3en7nTV/kpyoT/qYeQ/8PY+6rrOndMoYkADODhYnEc7j2qOdUI/y+CZ2MADT1xW
	ge43oaVP+AZokOYe38dy/2J3ao35SSXHtKOPm31WfyFsRBBmGgg==
X-Received: by 2002:ad4:5c69:0:b0:6b2:b510:8b79 with SMTP id 6a1803df08f44-6b5ed00d3e6mr34076106d6.36.1720141357191;
        Thu, 04 Jul 2024 18:02:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgHHFK2aM2VfXFAkWbXWdsT/fbJGrY/e1g1UXJUmVTtQqviU3TXnQiExxFUPuOPNaxwjmNeg==
X-Received: by 2002:ad4:5c69:0:b0:6b2:b510:8b79 with SMTP id 6a1803df08f44-6b5ed00d3e6mr34075926d6.36.1720141356874;
        Thu, 04 Jul 2024 18:02:36 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e737d61sm68437506d6.136.2024.07.04.18.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:02:36 -0700 (PDT)
Message-ID: <bda82bfab432602125bb8f317ff598921827e13d.camel@redhat.com>
Subject: Re: [PATCH v2 08/49] KVM: x86: Move __kvm_is_valid_cr4() definition
 to x86.h
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:02:35 -0400
In-Reply-To: <20240517173926.965351-9-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> Let vendor code inline __kvm_is_valid_cr4() now x86.c's cr4_reserved_bits
> no longer exists, as keeping cr4_reserved_bits local to x86.c was the only
> reason for "hiding" the definition of __kvm_is_valid_cr4().
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 9 ---------
>  arch/x86/kvm/x86.h | 6 +++++-
>  2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3f20de4368a6..2f6dda723005 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1130,15 +1130,6 @@ int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
>  
> -bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> -{
> -	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
> -		return false;
> -
> -	return true;
> -}
> -EXPORT_SYMBOL_GPL(__kvm_is_valid_cr4);
> -
>  static bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
>  	return __kvm_is_valid_cr4(vcpu, cr4) &&
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index d80a4c6b5a38..4a723705a139 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -491,7 +491,6 @@ static inline void kvm_machine_check(void)
>  void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>  int kvm_spec_ctrl_test_value(u64 value);
> -bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
>  int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
>  			      struct x86_exception *e);
>  int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
> @@ -505,6 +504,11 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>  #define  KVM_MSR_RET_INVALID	2	/* in-kernel MSR emulation #GP condition */
>  #define  KVM_MSR_RET_FILTERED	3	/* #GP due to userspace MSR filter */
>  
> +static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> +{
> +	return !(cr4 & vcpu->arch.cr4_guest_rsvd_bits);
> +}
> +
>  #define __cr4_reserved_bits(__cpu_has, __c)             \
>  ({                                                      \
>  	u64 __reserved_bits = CR4_RESERVED_BITS;        \


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


