Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9C5367EBF
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbhDVKg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:36:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235810AbhDVKgs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 06:36:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619087774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zK5U5dXbkwFpCBp/gShcg1bhC7LrD77rsahqB3DzIno=;
        b=MbjRwQyrTJrK89bBKtXhEhPuAFL8bGTqBsGrHybJcfCEYJbDxBc3bvBKVaRAfxISNSmCec
        mMzyBBPJHnsX5hSb2xZbUMi3snhF00VAi8MD76L7Ne6wlbqPBQWJy3mrKgMnSjwu+eET6S
        QbP/TauSqNtDGsilIASvMw6HX5GGiBM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-iGgGAvL7NQuknw5t4qCpaA-1; Thu, 22 Apr 2021 06:36:01 -0400
X-MC-Unique: iGgGAvL7NQuknw5t4qCpaA-1
Received: by mail-ed1-f70.google.com with SMTP id l22-20020a0564021256b0290384ebfba68cso12654082edw.2
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 03:36:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zK5U5dXbkwFpCBp/gShcg1bhC7LrD77rsahqB3DzIno=;
        b=W6XjX936HitgbuVJ8kgrsaT5ueXUHFenvUaMcUGH3sbBfZedDus9cRBl0XLOIGrwAo
         d5zc5qZNjC9jIRS4e+0hDjNA2SWERXCsNkgZ4MW0EcD+MBHwg7x2LhfA75ML36n0gnnx
         pwmh4e0Ss6VKbD58fJTxaMPMrOuayBEfR3dTKDcrefZqXa+dqyO5sluyw9u3sBvDFkbr
         OOr4sH/lc9N35SSllfDtvWMJzKoGkKhlhA/PWP/jJgKbtOdgNB0HPupFxFzsj4UvtZ5y
         GfhNepd6tzFn+A6UbrrOv8AJl4ejuJz45Yhye5hLlBSg57vSfcyXNKBCSuPnWPEAbyCZ
         mhbA==
X-Gm-Message-State: AOAM530OD7JLdWnvWggx1/FHww7Y1iC35QOedVi4RNycOl+JhiVHULhj
        ZeLa2E7sE6+05HFjwlRQx7FANq1OWsAPBL0x7WLUD2HMHjBbwLyZ7eu9Rk7KE9Bq8gAaIeLkbUk
        8e3DSFzTn2eiE
X-Received: by 2002:a17:906:b34e:: with SMTP id cd14mr2717447ejb.369.1619087759946;
        Thu, 22 Apr 2021 03:35:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzou7r7WMcBgmw1y5sWFhuuzWkBuhHTkKys162oeyQepu9tDCQYqJXtGttfHiRf4cDHlu+4gA==
X-Received: by 2002:a17:906:b34e:: with SMTP id cd14mr2717425ejb.369.1619087759781;
        Thu, 22 Apr 2021 03:35:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f19sm1768437edu.12.2021.04.22.03.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 03:35:59 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Take advantage of
 kvm_arch_dy_has_pending_interrupt()
To:     lihaiwei.kernel@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>
References: <20210421032513.1921-1-lihaiwei.kernel@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2c1c0771-5ff7-03e9-53e3-ee7b2cfe63a6@redhat.com>
Date:   Thu, 22 Apr 2021 12:35:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210421032513.1921-1-lihaiwei.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/21 05:25, lihaiwei.kernel@gmail.com wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> `kvm_arch_dy_runnable` checks the pending_interrupt as the code in
> `kvm_arch_dy_has_pending_interrupt`. So take advantage of it.
> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>   arch/x86/kvm/x86.c | 21 +++++++++------------
>   1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d696a9f..08bd616 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11125,28 +11125,25 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>   	return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
>   }
>   
> -bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
> +bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
>   {
> -	if (READ_ONCE(vcpu->arch.pv.pv_unhalted))
> -		return true;
> -
> -	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
> -		kvm_test_request(KVM_REQ_SMI, vcpu) ||
> -		 kvm_test_request(KVM_REQ_EVENT, vcpu))
> -		return true;
> -
>   	if (vcpu->arch.apicv_active && static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
>   		return true;
>   
>   	return false;
>   }
>   
> -bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
> +bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
>   {
> -	if (vcpu->arch.apicv_active && static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
> +	if (READ_ONCE(vcpu->arch.pv.pv_unhalted))
>   		return true;
>   
> -	return false;
> +	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
> +		kvm_test_request(KVM_REQ_SMI, vcpu) ||
> +		 kvm_test_request(KVM_REQ_EVENT, vcpu))
> +		return true;
> +
> +	return kvm_arch_dy_has_pending_interrupt(vcpu);
>   }
>   
>   bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> 

Looks good, but I'd like to take a look at the other patches for 
directed yield first.  Thanks!

Paolo

