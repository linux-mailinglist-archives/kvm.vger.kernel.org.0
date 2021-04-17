Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C215036302C
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbhDQNJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 09:09:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236356AbhDQNJm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 09:09:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618664955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RdJA/70yRUXxsr98G7H359pbURZLXm98LR2QoHSH+98=;
        b=gI2DavyOkRRgAh0vCct+2s9kRuN0XRJQD+wNkQ5SRITIIAqn/dj5YtVr+bsFSQbb6KVXYw
        qzVxCM+fXWOzK9Fuq7PvaypgX3XaCfvHyHSs2w0X+VCcD3fvEZ5o2AVzpiYFj1Lk9iteqG
        aY0gkzesCiYHTSvwfCrwuQ54n5wyKGQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-yXcNUiTyOsawYmzl7kOu_w-1; Sat, 17 Apr 2021 09:09:11 -0400
X-MC-Unique: yXcNUiTyOsawYmzl7kOu_w-1
Received: by mail-ed1-f71.google.com with SMTP id co5-20020a0564020c05b02903825bcdad12so8599058edb.0
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 06:09:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RdJA/70yRUXxsr98G7H359pbURZLXm98LR2QoHSH+98=;
        b=FVUj7iN1WH4P2pYEIiv5WRu5gU9bTBNaaj2wLFSlcX3UVzNvy3MR1zGJgQeyqY0eea
         FA7DO/bdq1pUVTMshblHJPkkFa9QtrvDuQgrYxzMvpyFE2MGhBoZgAra1LzKATvhkyUF
         Uxv4rjKxv6h8qwXQe3PBoN+F6rBIVLuOYERHiBrYIxkYzi7noU+qqS3KQjcgO5O+NWXP
         YcZftnRx2pVofJ86BVoThWgtHWHuRaZa5napIWg4X31BVu2KvIJWLwiLS7XFtMlql5qH
         qQZLsNHu/LI+X2fdlVDFVxh93iJRiJCkj6q/PvjPl7b8T422XgHQpp1Py6YIOqBfeJQV
         UfXA==
X-Gm-Message-State: AOAM5310wB2v4T7OAADIRjjiuUvtqMlsDz2tX9UIM0hkB8DvlqhqEY4J
        +UrK1dEWvb+Y3DCnb4OI1mfeKbjz90vazPZVJK2fGBze2umxGqFXbmudmL/yxEXIXrEEVzJvmsd
        GcZYAEW0Riuqm
X-Received: by 2002:a17:906:1a0d:: with SMTP id i13mr12561052ejf.197.1618664950754;
        Sat, 17 Apr 2021 06:09:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOf4A5+WCQ0lTRhS5/k8VN4bJjvqStUgBkq0vrCrZJrDVQGjQaCyqM+rVXQBr0doE6XUtRQw==
X-Received: by 2002:a17:906:1a0d:: with SMTP id i13mr12561023ejf.197.1618664950497;
        Sat, 17 Apr 2021 06:09:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q10sm4666201eds.26.2021.04.17.06.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:09:09 -0700 (PDT)
Subject: Re: [PATCH] KVM: Boost vCPU candidiate in user mode which is
 delivering interrupt
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1618542490-14756-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9c49c6ff-d896-e6a5-c051-b6707f6ec58a@redhat.com>
Date:   Sat, 17 Apr 2021 15:09:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1618542490-14756-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/21 05:08, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Both lock holder vCPU and IPI receiver that has halted are condidate for
> boost. However, the PLE handler was originally designed to deal with the
> lock holder preemption problem. The Intel PLE occurs when the spinlock
> waiter is in kernel mode. This assumption doesn't hold for IPI receiver,
> they can be in either kernel or user mode. the vCPU candidate in user mode
> will not be boosted even if they should respond to IPIs. Some benchmarks
> like pbzip2, swaptions etc do the TLB shootdown in kernel mode and most
> of the time they are running in user mode. It can lead to a large number
> of continuous PLE events because the IPI sender causes PLE events
> repeatedly until the receiver is scheduled while the receiver is not
> candidate for a boost.
> 
> This patch boosts the vCPU candidiate in user mode which is delivery
> interrupt. We can observe the speed of pbzip2 improves 10% in 96 vCPUs
> VM in over-subscribe scenario (The host machine is 2 socket, 48 cores,
> 96 HTs Intel CLX box). There is no performance regression for other
> benchmarks like Unixbench spawn (most of the time contend read/write
> lock in kernel mode), ebizzy (most of the time contend read/write sem
> and TLB shoodtdown in kernel mode).
>   
> +bool kvm_arch_interrupt_delivery(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->arch.apicv_active && static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
> +		return true;
> +
> +	return false;
> +}

Can you reuse vcpu_dy_runnable instead of this new function?

Paolo



>   bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
>   {
>   	return vcpu->arch.preempted_in_kernel;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3b06d12..5012fc4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -954,6 +954,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
>   bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
>   int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
>   bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
> +bool kvm_arch_interrupt_delivery(struct kvm_vcpu *vcpu);
>   int kvm_arch_post_init_vm(struct kvm *kvm);
>   void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0a481e7..781d2db 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3012,6 +3012,11 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
>   	return false;
>   }
>   
> +bool __weak kvm_arch_interrupt_delivery(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>   void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>   {
>   	struct kvm *kvm = me->kvm;
> @@ -3045,6 +3050,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>   			    !vcpu_dy_runnable(vcpu))
>   				continue;
>   			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
> +				!kvm_arch_interrupt_delivery(vcpu) &&
>   				!kvm_arch_vcpu_in_kernel(vcpu))
>   				continue;
>   			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
> 

