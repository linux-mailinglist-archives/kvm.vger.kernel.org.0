Return-Path: <kvm+bounces-3562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8BFB8053C9
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:06:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 832F0281753
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6AA5ABA1;
	Tue,  5 Dec 2023 12:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hqKKaWM5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717FEB9
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 04:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701777949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wt+AiIcIrJIdky3PT7rqLRhG9cMnHXi1hr611kIK+yg=;
	b=hqKKaWM5qAhu5BA9f5/gi3GBrT6iWxjPsxrNthwcchSZSnqXbKvemnTqpnUWr6MoXj5cah
	tKpVXcTzaeT00JqM/NbsmjTyxBuLsmJTpLaDpuo+YULNi+9ZhBJiz1rwG4OswyDVnuZeyK
	1v+UDz+iSbnxp5W33Qj/okXur4eANzM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-GlRJstsWO5eVHMA1lvsbhQ-1; Tue, 05 Dec 2023 07:05:48 -0500
X-MC-Unique: GlRJstsWO5eVHMA1lvsbhQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33349915da6so1420845f8f.3
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 04:05:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701777947; x=1702382747;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wt+AiIcIrJIdky3PT7rqLRhG9cMnHXi1hr611kIK+yg=;
        b=wl8qRkyTTGdY8toLAkIzflsuRTB4jgD2s8PxIczuXI3DN8JgSJHuiuMAweMjc0F6tS
         mnBZtiU3Gqr2rZ8IKiUZ1rgHgrkW18jBUFw3JFhtkNrI20E1R+8rsSjshUaZnDyL+87Q
         5Q2poKkKZIsxyn3z8Yd3beJ+CnkyRhjv4njLy0JEfaiMO2KmVz0uJdhttCRQ6OW/tO39
         MlD27WDoVgrpljHaflsTFjioqG7WNj8Jho7hrVfZmRZfYCa68gUMGMF1Dl4nKKxxi37B
         srLTT3+bunN+aZYW4hoOd90vPXLa783lkQJ4anO5mfRrEhDbOkiVe0GMVQYE5tCxs/yi
         NMZA==
X-Gm-Message-State: AOJu0YyGVhKy/vlVckNLkcXnHP9JDJzz8JVemXUm7oAWq2T7ZLzqJxfN
	OvqRM1T6lfN/7uPef9wkHLY5ZSYNDeGKh5ATVyZPeDODxjNMw7/seDbzIzbGPh6gW1OnsxPtJU4
	3//QRbd03o2Qbol4bhwID
X-Received: by 2002:a5d:68ce:0:b0:32d:9a8f:6245 with SMTP id p14-20020a5d68ce000000b0032d9a8f6245mr4405103wrw.68.1701777946938;
        Tue, 05 Dec 2023 04:05:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF6dQoMSoJ/2PghAJiPCUKJVI/2z6XyDCvDPiw2f+HeBYuiOIW586viouajB37g2OimWxyipg==
X-Received: by 2002:a5d:68ce:0:b0:32d:9a8f:6245 with SMTP id p14-20020a5d68ce000000b0032d9a8f6245mr4405091wrw.68.1701777946611;
        Tue, 05 Dec 2023 04:05:46 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id v2-20020a5d6102000000b003335c061a2asm1214618wrt.33.2023.12.05.04.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 04:05:46 -0800 (PST)
Message-ID: <166562fe34d94bb2e2f4984177cce49905e3a6e9.camel@redhat.com>
Subject: Re: [PATCH v2 11/16] KVM: nVMX: Move guest_cpuid_has_evmcs() to
 hyperv.h
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, Paolo
 Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Date: Tue, 05 Dec 2023 14:05:44 +0200
In-Reply-To: <20231205103630.1391318-12-vkuznets@redhat.com>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
	 <20231205103630.1391318-12-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-12-05 at 11:36 +0100, Vitaly Kuznetsov wrote:
> In preparation for making Hyper-V emulation optional, move Hyper-V specific
> guest_cpuid_has_evmcs() to hyperv.h.
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/hyperv.h | 11 +++++++++++
>  arch/x86/kvm/vmx/vmx.h    | 10 ----------
>  2 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index d4ed99008518..6e1ee951e360 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/kvm_host.h>
>  #include "vmcs12.h"
> +#include "vmx.h"
>  
>  #define EVMPTR_INVALID (-1ULL)
>  #define EVMPTR_MAP_PENDING (-2ULL)
> @@ -20,6 +21,16 @@ enum nested_evmptrld_status {
>  	EVMPTRLD_ERROR,
>  };
>  
> +static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
> +	 * eVMCS has been explicitly enabled by userspace.
> +	 */
> +	return vcpu->arch.hyperv_enabled &&
> +	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
> +}
> +
>  u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index c2130d2c8e24..959c6d94287f 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -745,14 +745,4 @@ static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
>  	return  lapic_in_kernel(vcpu) && enable_ipiv;
>  }
>  
> -static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
> -{
> -	/*
> -	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
> -	 * eVMCS has been explicitly enabled by userspace.
> -	 */
> -	return vcpu->arch.hyperv_enabled &&
> -	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
> -}
> -
>  #endif /* __KVM_X86_VMX_H */

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


