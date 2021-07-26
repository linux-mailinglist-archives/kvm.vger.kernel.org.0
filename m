Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39943D5972
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 14:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbhGZLqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 07:46:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233877AbhGZLqh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 07:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627302425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/pLQHCoDSsXCllDb0GnTFJnUbcQ1cRoUJbtUYUP6ANM=;
        b=jOXdu0zNi9TkRzrfSpc5Fu5PvDwKrbfn1n2daN5+i+Buipf4z0p2XJGfSC9bJ1oMgpjADk
        bSR+OF+Ceux5WY+zMe+6ZCkYGXg4QQqe8C2UtgMpyoRZFFoNqgeeqc0ZQ7EaixU9ddZIhH
        +erorFfLa44IADfg9GeoNnhyN7ZSYe8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-rEPqccBlOWCfAoecrE9z7g-1; Mon, 26 Jul 2021 08:27:04 -0400
X-MC-Unique: rEPqccBlOWCfAoecrE9z7g-1
Received: by mail-ed1-f69.google.com with SMTP id b4-20020a05640202c4b02903948bc39fd5so4632570edx.13
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 05:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/pLQHCoDSsXCllDb0GnTFJnUbcQ1cRoUJbtUYUP6ANM=;
        b=qBxdGu5u9OtXPhHAvFqPhFU5IOvaL1MS9hfrgcYTj7nvFAjF3/3D1oCLMRdMm0aTUv
         BHvFRJTqWst/ex2ag/HZ0M6MFLg8rnQ74gTRwwOa4280umv+/9LcZjUAdwbSTdaAc8xh
         uAYeARdsMuo3SX+z2Ln3aolc/lfDc7ajjUz07OPdVa6BST76MAjOyCCtn/wuyk2UDW1s
         gWsKBPIaCypf3bYUTbzYY+O6gzXgyCDS1C76m7MqfJib3k7IaLI7IKw6nXvmdzlRvkRt
         ugUWNfNKNGdbZk5hIxw+/Ud1LtXy4xaMJeNsHyRd59p1AEt0/df13wyJX8DpiDGjPT22
         jh0g==
X-Gm-Message-State: AOAM530NQAD0Qk5/AnUP8y26x9Z65/f0cpnqDzKYwcYEqUV+R8pJ3C40
        Gm5zyVV/mrnuhKdkx1Gu7a8HsQhhlEm8CMGlcGYEVhBzbBSDCbunSlErGafJxK97cJLeYTXnR2s
        0BsALLJ4GvDXX
X-Received: by 2002:a17:906:4158:: with SMTP id l24mr16328180ejk.245.1627302422970;
        Mon, 26 Jul 2021 05:27:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvjMhQPXalA1SR9kEMp1/APEZND8KBWzgcVBR8Mit7Cbs2RpIvZ6rtl7cJkX/IzptkkpiJ7w==
X-Received: by 2002:a17:906:4158:: with SMTP id l24mr16328166ejk.245.1627302422762;
        Mon, 26 Jul 2021 05:27:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c5sm12159692edk.26.2021.07.26.05.27.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 05:27:02 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Check the right feature bit for
 MSR_KVM_ASYNC_PF_ACK access
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
References: <20210722123018.260035-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a8500354-b204-3e21-f6c9-1e6a80f88851@redhat.com>
Date:   Mon, 26 Jul 2021 14:27:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210722123018.260035-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/07/21 14:30, Vitaly Kuznetsov wrote:
> MSR_KVM_ASYNC_PF_ACK MSR is part of interrupt based asynchronous page fault
> interface and not the original (deprecated) KVM_FEATURE_ASYNC_PF. This is
> stated in Documentation/virt/kvm/msr.rst.
> 
> Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/kvm/x86.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d715ae9f9108..88ff7a1af198 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3406,7 +3406,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 1;
>   		break;
>   	case MSR_KVM_ASYNC_PF_ACK:
> -		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
> +		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
>   			return 1;
>   		if (data & 0x1) {
>   			vcpu->arch.apf.pageready_pending = false;
> @@ -3745,7 +3745,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		msr_info->data = vcpu->arch.apf.msr_int_val;
>   		break;
>   	case MSR_KVM_ASYNC_PF_ACK:
> -		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
> +		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
>   			return 1;
>   
>   		msr_info->data = 0;
> 

Queued, thanks.

Paolo

