Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B72428803
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 09:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhJKHrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 03:47:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234494AbhJKHrK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 03:47:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633938310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LSuc4UVJmiHSzAiziKZ1KJ+0nObIwFoDvepNLe3NpSw=;
        b=Jg9T50qPI8ir7dUSh5VJrM6xUR9GZtAXH8e7FPMW4sPCjpAUv+cf9mf9f6D4tW9/2cYwGy
        o3PGqMNQOYIEFknNdETsrO6nMWsoxaKrA55dpi7rWoPLyZ4fnI6HiBQkOIMBsU6DHMY9L9
        C4YjYIJ4As0HcudtyDBDm8Sc/RLeCcs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-eujRnzqsOaiLaTWY0lLzRg-1; Mon, 11 Oct 2021 03:45:08 -0400
X-MC-Unique: eujRnzqsOaiLaTWY0lLzRg-1
Received: by mail-wr1-f70.google.com with SMTP id j19-20020adfb313000000b00160a9de13b3so12572707wrd.8
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 00:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=LSuc4UVJmiHSzAiziKZ1KJ+0nObIwFoDvepNLe3NpSw=;
        b=V59e8f97fCBU6G1sFsy8d+6U2EkfqeDH2RZnjn0HltRPNnMjctywdNdO5wUqwMJEEy
         373e4kk0sUfcjWenFWquQ0J9oHbb3sheMhId5QyQXoxf5wYdGSQHwir+VZOVE6nz2oXz
         nS8l3GQDXVaYTDL9srcRZHc75LGop2EsZhTKEjVnGS77azOWXYIch9gC3QgpXfyufK6i
         zZQ/H059fE0i+iw0+OrGsAn2pLwq1zkcpIlxElEzmUQ6nMt+XkOrSJFlRPTonr0mvEa6
         xYl7KwGUsrvhJmaWz9UxXbxb/eSdEf5nrIl/jmoDYIg4LiCJLKM02OXiT9KCfs1v8K79
         gajA==
X-Gm-Message-State: AOAM532j/0CAMQkXxJ5VXqbgcamK5d0nR0Ihiboah4+Iwl19tfGfCMNJ
        FQjXqkRUd3keZoQeJYjkTd3ocYUBNXAKdNtYppaIaB22Svb7Ats/GKBHHJifF8EBi9y/asLKmVk
        7tlaMLJqIWmf+
X-Received: by 2002:a7b:c193:: with SMTP id y19mr16530338wmi.125.1633938307724;
        Mon, 11 Oct 2021 00:45:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEXteg820Qpm2pfAUuKRxfpLikImqdkOGT+Q3tHDW6PBFaytT3M1sCv60MWzuhDbyX4uY+3g==
X-Received: by 2002:a7b:c193:: with SMTP id y19mr16530313wmi.125.1633938307467;
        Mon, 11 Oct 2021 00:45:07 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c64ba.dip0.t-ipconnect.de. [91.12.100.186])
        by smtp.gmail.com with ESMTPSA id f15sm3877814wrt.38.2021.10.11.00.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 00:45:07 -0700 (PDT)
Subject: Re: [RFC PATCH v1 6/6] KVM: s390: Add a routine for setting userspace
 CPU state
To:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211008203112.1979843-1-farman@linux.ibm.com>
 <20211008203112.1979843-7-farman@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <e3f86c1e-8c92-3c67-2312-70ca152b45df@redhat.com>
Date:   Mon, 11 Oct 2021 09:45:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211008203112.1979843-7-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.10.21 22:31, Eric Farman wrote:
> This capability exists, but we don't record anything when userspace
> enables it. Let's refactor that code so that a note can be made in
> the debug logs that it was enabled.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 6 +++---
>   arch/s390/kvm/kvm-s390.h | 9 +++++++++
>   2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 33d71fa42d68..48ac0bd05bee 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2487,8 +2487,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   	case KVM_S390_PV_COMMAND: {
>   		struct kvm_pv_cmd args;
>   
> -		/* protvirt means user sigp */
> -		kvm->arch.user_cpu_state_ctrl = 1;
> +		/* protvirt means user cpu state */
> +		kvm_s390_set_user_cpu_state_ctrl(kvm);
>   		r = 0;
>   		if (!is_prot_virt_host()) {
>   			r = -EINVAL;
> @@ -3801,7 +3801,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>   	vcpu_load(vcpu);
>   
>   	/* user space knows about this interface - let it control the state */
> -	vcpu->kvm->arch.user_cpu_state_ctrl = 1;
> +	kvm_s390_set_user_cpu_state_ctrl(vcpu->kvm);
>   
>   	switch (mp_state->mp_state) {
>   	case KVM_MP_STATE_STOPPED:
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 57c5e9369d65..36f4d585513c 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -208,6 +208,15 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
>   	return kvm->arch.user_cpu_state_ctrl != 0;
>   }
>   
> +static inline void kvm_s390_set_user_cpu_state_ctrl(struct kvm *kvm)
> +{
> +	if (kvm->arch.user_cpu_state_ctrl)
> +		return;
> +
> +	VM_EVENT(kvm, 3, "%s", "ENABLE: Userspace CPU state control");
> +	kvm->arch.user_cpu_state_ctrl = 1;
> +}
> +
>   /* implemented in pv.c */
>   int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
>   int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

