Return-Path: <kvm+bounces-2757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CBA47FD5EC
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 12:40:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F5D71C211E5
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 11:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031201D528;
	Wed, 29 Nov 2023 11:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R+hIrvBv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6406B137;
	Wed, 29 Nov 2023 03:40:26 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1cf8e569c35so44488875ad.0;
        Wed, 29 Nov 2023 03:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701258026; x=1701862826; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hJF+hJ5VN4sJhJYjpX9/OpUUp6GMMh66U/1NZe17HOA=;
        b=R+hIrvBvzgFTSyWOJ5Ar9qMwT1eK7z+TofcZxjDRCW5TY5Fc9esXOwToQPxovjIoGN
         tvkVmfItj+i2qTwO8dZmDwwA0kq+lZXDq4Tra0ecycPrZqKumNsDJnE080CL5L1GMX+4
         jfnTG4ln5ioXQV80YQ/5d81CIYk2WNADsJxIvxjH+Lk/r5gubT/lb6gzfakTDtoIJb4z
         KicaNtbh1ESeJSUMn5E3La5u3FA1j118FLUrnMRq25XgE0cSUGLPYIgrLjOkqZeuSGTx
         Ai/GZGGVlxKOGrTDOgS2yz47JR9v3Fv5i22p5Kmb6XxqALQmrQ638ntKWiw+7zBK0223
         aZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701258026; x=1701862826;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hJF+hJ5VN4sJhJYjpX9/OpUUp6GMMh66U/1NZe17HOA=;
        b=JSq3CXeqljCjEbwicn1fvQp9hxxVHRtnJgw/mTKy3WF0WlSlaVvfCxSQd1wlXHqkCf
         gypLd173hbfUOPhYkw+nAKBUQaA4P0XcOJ4T7GRsT170mJ/C7B4b7w3AjIffOSsCT4Fy
         pcVqsTBogX0jonKixnz+Czztnob2qESSxtkebQJ7l1meF7F5NKc2FPIqVxb20361FBrf
         Daawi6EFhCM7IOGfiZ+JFblkYi4Delx/FdFIjLBh6WvEuYpHNKkIva/9/i/vIgTJ+sMU
         yJx4zW+M3v0FHqmVMIeia5ZzxFp2OHxhE5G8XWMycbnrnM/W1thgLJ1OAOdedsi9tuoe
         lJJA==
X-Gm-Message-State: AOJu0YycqRnccbQkmZc632PWazpkANpvZZmtnx2+ag56XCaLuaeW70Zk
	kaREv52C3ViveYyluPShx3I=
X-Google-Smtp-Source: AGHT+IFewmWHo4E8iy3QvOvjiPAb7kQz7zx9xJGJNRmV2iBw5agvEIOeCnZL94/9HFeQEnZd8iT4aw==
X-Received: by 2002:a17:902:ecc3:b0:1d0:1216:8f1a with SMTP id a3-20020a170902ecc300b001d012168f1amr2361908plh.0.1701258025725;
        Wed, 29 Nov 2023 03:40:25 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u6-20020a170902e5c600b001cfde4c84bcsm4431332plf.141.2023.11.29.03.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Nov 2023 03:40:25 -0800 (PST)
Message-ID: <bcbc9d0f-8b52-468b-8c69-0e09ec168a39@gmail.com>
Date: Wed, 29 Nov 2023 19:40:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Use get_cpl directly in case of vcpu_load to
 improve accuracy
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231123075818.12521-1-likexu@tencent.com>
 <ZWVCwvoETD_NVOFG@google.com>
Content-Language: en-US
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZWVCwvoETD_NVOFG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for your comments.

On 28/11/2023 9:30 am, Sean Christopherson wrote:
> On Thu, Nov 23, 2023, Like Xu wrote:
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/x86.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 2c924075f6f1..c454df904a45 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -13031,7 +13031,10 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
>>   	if (vcpu->arch.guest_state_protected)
>>   		return true;
>>   
>> -	return vcpu->arch.preempted_in_kernel;
>> +	if (vcpu != kvm_get_running_vcpu())
>> +		return vcpu->arch.preempted_in_kernel;
> 
> Eww, KVM really shouldn't be reading vcpu->arch.preempted_in_kernel in a generic
> vcpu_in_kernel() API.

It looks weird to me too.

> 
> Rather than fudge around that ugliness with a kvm_get_running_vcpu() check, what
> if we instead repurpose kvm_arch_dy_has_pending_interrupt(), which is effectively
> x86 specific, to deal with not being able to read the current CPL for a vCPU that
> is (possibly) not "loaded", which AFAICT is also x86 specific (or rather, Intel/VMX
> specific).

I'd break it into two parts, the first step applying this simpler, more 
straightforward fix
(which is backport friendly compared to the diff below), and the second step 
applying
your insight for more decoupling and cleanup.

You'd prefer one move to fix it, right ?

> 
> And if getting the CPL for a vCPU that may not be loaded is problematic for other
> architectures, then I think the correct fix is to move preempted_in_kernel into
> common code and check it directly in kvm_vcpu_on_spin().

Not sure which tests would cover this part of the change.

> 
> This is what I'm thinking:
> 
> ---
>   arch/x86/kvm/x86.c       | 22 +++++++++++++++-------
>   include/linux/kvm_host.h |  2 +-
>   virt/kvm/kvm_main.c      |  7 +++----
>   3 files changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6d0772b47041..5c1a75c0dafe 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13022,13 +13022,21 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>   	return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
>   }
>   
> -bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
> +static bool kvm_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
>   {
> -	if (kvm_vcpu_apicv_active(vcpu) &&
> -	    static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
> -		return true;
> +	return kvm_vcpu_apicv_active(vcpu) &&
> +	       static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu);
> +}
>   
> -	return false;
> +bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Treat the vCPU as being in-kernel if it has a pending interrupt, as
> +	 * the vCPU trying to yield may be spinning on IPI delivery, i.e. the
> +	 * the target vCPU is in-kernel for the purposes of directed yield.

How about the case "vcpu->arch.guest_state_protected == true" ?

> +	 */
> +	return vcpu->arch.preempted_in_kernel ||
> +	       kvm_dy_has_pending_interrupt(vcpu);
>   }
>   
>   bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
> @@ -13043,7 +13051,7 @@ bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
>   		 kvm_test_request(KVM_REQ_EVENT, vcpu))
>   		return true;
>   
> -	return kvm_arch_dy_has_pending_interrupt(vcpu);
> +	return kvm_dy_has_pending_interrupt(vcpu);
>   }
>   
>   bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> @@ -13051,7 +13059,7 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
>   	if (vcpu->arch.guest_state_protected)
>   		return true;
>   
> -	return vcpu->arch.preempted_in_kernel;
> +	return static_call(kvm_x86_get_cpl)(vcpu);

We need "return static_call(kvm_x86_get_cpl)(vcpu) == 0;" here.

>   }
>   
>   unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ea1523a7b83a..820c5b64230f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1505,7 +1505,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
>   bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
>   int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
>   bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
> -bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
> +bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu);
>   int kvm_arch_post_init_vm(struct kvm *kvm);
>   void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>   int kvm_arch_create_vm_debugfs(struct kvm *kvm);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8758cb799e18..e84be7e2e05e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4049,9 +4049,9 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
>   	return false;
>   }
>   
> -bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
> +bool __weak kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
>   {
> -	return false;
> +	return kvm_arch_vcpu_in_kernel(vcpu);
>   }
>   
>   void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
> @@ -4086,8 +4086,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>   			if (kvm_vcpu_is_blocking(vcpu) && !vcpu_dy_runnable(vcpu))
>   				continue;
>   			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
> -			    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
> -			    !kvm_arch_vcpu_in_kernel(vcpu))
> +			    kvm_arch_vcpu_preempted_in_kernel(vcpu))

Use !kvm_arch_vcpu_preempted_in_kernel(vcpu) ?

>   				continue;
>   			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
>   				continue;
> 
> base-commit: e9e60c82fe391d04db55a91c733df4a017c28b2f

