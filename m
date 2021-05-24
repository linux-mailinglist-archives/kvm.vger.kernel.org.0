Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C85938EE34
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 17:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbhEXPrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 11:47:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20734 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234772AbhEXPox (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 11:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621871005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rM7i7qUUzR3I7GRawS6egVQdl5e+fKqGxnHxQplP50k=;
        b=PZIyW5EQ1KnM2PCMAyZYGOTsxcvEn+MhC62JwvyTEtvGMJC2TKwpcR1yyQIlRPKvpMl46q
        aCnpzEFyJ1sc++HG/FqXgmWa5tb8vj3TdEp1cFSro7kig/TK7w15XuxUAwfh3t02J5oLdf
        0A2ghk+mn/M/fk6P6SWA0X+2xegOl34=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-95OrDMgWOju_ic96rlJISQ-1; Mon, 24 May 2021 11:43:23 -0400
X-MC-Unique: 95OrDMgWOju_ic96rlJISQ-1
Received: by mail-ed1-f69.google.com with SMTP id h18-20020a05640250d2b029038cc3938914so15831740edb.17
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 08:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rM7i7qUUzR3I7GRawS6egVQdl5e+fKqGxnHxQplP50k=;
        b=q6zkT47onhIfMIYfchPwbutqJtB4+c36qpkElm744Q6sPeb0+76BnqUDgVii4hknw0
         8w1i7WUXc95MyG2y9b4xulqT4vdIkLmOL9yvgWQchN7ab21Bxrpm8zLOVxjFE0CIm1kR
         ODspECU7NVs9870/gKuq0TUnLqXFT2Yx+wdjSRpU6MNXx/rTGRIlD5GTZBo4TuHF1eO5
         IowjHQB3NoGdfVVgZmRX18/MnGtoyEqYktVpNG/TdbA6Z1uRepronnpTWWF1o5C3wqAn
         4Mu3in9qJ+B33q6uCUfQQxnt/7lyGWM14/i+L/2Xc6Bf4+JxBceKjMALNCLknT5ZjEzK
         0PVg==
X-Gm-Message-State: AOAM533IFgsTe1WmJ1C0bE1ygFCUhkbHJ+WdXIHwyx/1iH7iqv4F2U1P
        LQUEoaxI7jrju/LtDTQ2OqC1N7pZ+7hmFNpMKiUIi7Jl5VdVwHYz0Pa9QG7YRLqJNdVKJHBr+KT
        66Dxe1YdKf8gk
X-Received: by 2002:a17:906:a255:: with SMTP id bi21mr7982180ejb.323.1621871002248;
        Mon, 24 May 2021 08:43:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxybFLMguaMSeQtMEmEgH0EgF9gi51Z5/+u7D4QKBBd8vow7hynWP4YQhUqRxKF1U3gK7Z/4Q==
X-Received: by 2002:a17:906:a255:: with SMTP id bi21mr7982171ejb.323.1621871002111;
        Mon, 24 May 2021 08:43:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l28sm9393011edc.29.2021.05.24.08.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 08:43:21 -0700 (PDT)
Subject: Re: [PATCH 02/12] KVM: x86: Wake up a vCPU when
 kvm_check_nested_events fails
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>
References: <20210520230339.267445-1-jmattson@google.com>
 <20210520230339.267445-3-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <10d51d46-8b60-e147-c590-62a68f26f616@redhat.com>
Date:   Mon, 24 May 2021 17:43:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520230339.267445-3-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/21 01:03, Jim Mattson wrote:
> At present, there are two reasons why kvm_check_nested_events may
> return a non-zero value:
> 
> 1) we just emulated a shutdown VM-exit from L2 to L1.
> 2) we need to perform an immediate VM-exit from vmcs02.
> 
> In either case, transition the vCPU to "running."
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>   arch/x86/kvm/x86.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d517460db413..d3fea8ea3628 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9468,8 +9468,8 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>   
>   static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>   {
> -	if (is_guest_mode(vcpu))
> -		kvm_check_nested_events(vcpu);
> +	if (is_guest_mode(vcpu) && kvm_check_nested_events(vcpu))
> +		return true;

That doesn't make the vCPU running.  You still need to go through 
vcpu_block, which would properly update the vCPU's mp_state.

What is this patch fixing?

Paolo

>   	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
>   		!vcpu->arch.apf.halted);
> 

