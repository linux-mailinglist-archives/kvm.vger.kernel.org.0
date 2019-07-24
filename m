Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C1F72E9C
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 14:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfGXMRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 08:17:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35140 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfGXMRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 08:17:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so41410292wmg.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 05:17:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d/bnNeFnlnArvv9m90hzgTqoTaqu56sti/BTphxXxoM=;
        b=dFOkuLHt4cLFjGFdd2Z1bcqCzrewruuu+D2ujPuF0alInjkkgPKadZP7CQW+Rx56TJ
         9q39hxPpRP4PWgHVH+qUjZFLT1WVMq+YT1/aMlO+oi/szPyvG+5EUIaOr1pyMeXNmg6o
         E3v3n8yaxuHOwGJXYLyfVWrVBf8s3yJ7NGDe94i7xVXsC6JvC+6Jw9qDnWZShVH/y6Ql
         fvyOUcpvLI4gY5kHEaCkQFVO7WtqOjck/qbBERBR6H0dP63I+RnJmuZQgK7KXg2+eVaL
         EJYkcktWKsXbUB11SIeDh77ZiePKKCEXyYxktZuSjmD2VRUi6FJnfCZd7Fy8ESUFOlZ3
         sNxQ==
X-Gm-Message-State: APjAAAV1grCv0NlUQbW+Kw2unsfUhnjFABdCnRx0AaP40lCj6UBsiMEV
        R3P5UplGjIinnMZRP1x+0HDfEA==
X-Google-Smtp-Source: APXvYqwCvrf4yPzzk3NFn3Qx2+lKh32KmGRJqKMQSlgWv3da79lYQl+eEShtkRMIfH4axXaXxN60Qw==
X-Received: by 2002:a1c:407:: with SMTP id 7mr78394104wme.113.1563970635452;
        Wed, 24 Jul 2019 05:17:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:10f7:67c8:abb4:8512? ([2001:b07:6468:f312:10f7:67c8:abb4:8512])
        by smtp.gmail.com with ESMTPSA id y12sm41112207wrm.79.2019.07.24.05.17.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 05:17:14 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Boost queue head vCPU to mitigate lock waiter
 preemption
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <1563961393-10301-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5ffaea5b-fb07-0141-cab8-6dce39071abe@redhat.com>
Date:   Wed, 24 Jul 2019 14:17:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1563961393-10301-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/07/19 11:43, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Commit 11752adb (locking/pvqspinlock: Implement hybrid PV queued/unfair locks)
> introduces hybrid PV queued/unfair locks 
>  - queued mode (no starvation)
>  - unfair mode (good performance on not heavily contended lock)
> The lock waiter goes into the unfair mode especially in VMs with over-commit
> vCPUs since increaing over-commitment increase the likehood that the queue 
> head vCPU may have been preempted and not actively spinning.
> 
> However, reschedule queue head vCPU timely to acquire the lock still can get 
> better performance than just depending on lock stealing in over-subscribe 
> scenario.
> 
> Testing on 80 HT 2 socket Xeon Skylake server, with 80 vCPUs VM 80GB RAM:
> ebizzy -M
>              vanilla     boosting    improved
>  1VM          23520        25040         6%
>  2VM           8000        13600        70%
>  3VM           3100         5400        74%
> 
> The lock holder vCPU yields to the queue head vCPU when unlock, to boost queue 
> head vCPU which is involuntary preemption or the one which is voluntary halt 
> due to fail to acquire the lock after a short spin in the guest.

Clever!  I have applied the patch.

Paolo

> Cc: Waiman Long <longman@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 01e18ca..c6d951c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7206,7 +7206,7 @@ static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
>  
>  	rcu_read_unlock();
>  
> -	if (target)
> +	if (target && READ_ONCE(target->ready))
>  		kvm_vcpu_yield_to(target);
>  }
>  
> @@ -7246,6 +7246,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		break;
>  	case KVM_HC_KICK_CPU:
>  		kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);
> +		kvm_sched_yield(vcpu->kvm, a1);
>  		ret = 0;
>  		break;
>  #ifdef CONFIG_X86_64
> 

