Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E725B1EEA6B
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 20:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgFDSlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 14:41:22 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22458 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726774AbgFDSlV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 14:41:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591296080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2XePoJNdNVmtKQsPI2i0zLtEeRswapNtM75dwkZ+u3s=;
        b=KKkWH8YuNAk0Ppzlc2fMysCQiUVybGKYGvPByViJxU6NETJCym4OHT7e9ICU3gQgP6Fnu3
        uVuqZ7TNjXOMKlK4DgkMgogcoFUN9kH+6P2CppK1OAvGT1W6CHbGwUvZGj6gyLwac6SI77
        6cf/ntBK0QQ1bmwbomOxeL9bmU2Ej0Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-KzChUG3SM9CKw6MIUt-FPQ-1; Thu, 04 Jun 2020 14:41:16 -0400
X-MC-Unique: KzChUG3SM9CKw6MIUt-FPQ-1
Received: by mail-wr1-f72.google.com with SMTP id f4so2764214wrp.21
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 11:41:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2XePoJNdNVmtKQsPI2i0zLtEeRswapNtM75dwkZ+u3s=;
        b=iJnArnB6cYlqpwVknCZ3RSST2joAbjPUnfQop2VNVOisgCMq4ahJ6Xb9YZmsYqcHbt
         t122Y2nWEkqaG57R9I7TA7O6HWl0IL6pWLvkRWNvGJMYAo7mEt9YZqk2QeVlGR7wHPZs
         2vk6zeO3iJjtbrP8py9A2iOt982rNvq6z7Nf9OYYYqtdAX7B28cDUrNvxJo44qoUdgRz
         +Yf3dK4iWAoKrcswd7+w9UcV21pratXokYgsUIf3sITqVITG9UTT0hT+aRknPu5o+OSe
         1i9wG9a0IF03v9fZj8Pn60bfKYzdWlNnJPoheB1M21auu8vaZmUy/sdStob8Oe8bqOWL
         6F4A==
X-Gm-Message-State: AOAM53267/Bml/En2O6XxUfi/KTWCpjT/2zHnwswhcB+VZWQ6TUmE9pN
        gsH9a7S/ayd7C7pddiVB+ZV6hIG3gC6jPY3Op+OrdW35kYstQcxpQJ+GleUTIR/PWtQNm4gh3J8
        TpJHPIr0Z0W92
X-Received: by 2002:a1c:6243:: with SMTP id w64mr5155627wmb.162.1591296073706;
        Thu, 04 Jun 2020 11:41:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy111L7niMul0OsF5rkmGw6PjdHJmyZd1HPbz5VmcAXHvsx/aKHzYnf+RRkcnww5nK/+ZgR+g==
X-Received: by 2002:a1c:6243:: with SMTP id w64mr5155610wmb.162.1591296073464;
        Thu, 04 Jun 2020 11:41:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id x8sm9042333wrs.43.2020.06.04.11.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 11:41:12 -0700 (PDT)
Subject: Re: [PATCH] KVM: Use vmemdup_user()
To:     Denis Efremov <efremov@linux.com>
Cc:     joe@perches.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0c00d96c46d34d69f5f459baebf3c89a507730fc.camel@perches.com>
 <20200603101131.2107303-1-efremov@linux.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eb48b6d2-6189-945d-33e2-1f5b29338d96@redhat.com>
Date:   Thu, 4 Jun 2020 20:41:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200603101131.2107303-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/06/20 12:11, Denis Efremov wrote:
> Replace opencoded alloc and copy with vmemdup_user().
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
> Looks like these are the only places in KVM that are suitable for
> vmemdup_user().
> 
>  arch/x86/kvm/cpuid.c | 17 +++++++----------
>  virt/kvm/kvm_main.c  | 19 ++++++++-----------
>  2 files changed, 15 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 901cd1fdecd9..27438a2bdb62 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -182,17 +182,14 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  	r = -E2BIG;
>  	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
>  		goto out;
> -	r = -ENOMEM;
>  	if (cpuid->nent) {
> -		cpuid_entries =
> -			vmalloc(array_size(sizeof(struct kvm_cpuid_entry),
> -					   cpuid->nent));
> -		if (!cpuid_entries)
> -			goto out;
> -		r = -EFAULT;
> -		if (copy_from_user(cpuid_entries, entries,
> -				   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
> +		cpuid_entries = vmemdup_user(entries,
> +					     array_size(sizeof(struct kvm_cpuid_entry),
> +							cpuid->nent));
> +		if (IS_ERR(cpuid_entries)) {
> +			r = PTR_ERR(cpuid_entries);
>  			goto out;
> +		}
>  	}
>  	for (i = 0; i < cpuid->nent; i++) {
>  		vcpu->arch.cpuid_entries[i].function = cpuid_entries[i].function;
> @@ -212,8 +209,8 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  	kvm_x86_ops.cpuid_update(vcpu);
>  	r = kvm_update_cpuid(vcpu);
>  
> +	kvfree(cpuid_entries);
>  out:
> -	vfree(cpuid_entries);
>  	return r;
>  }
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 731c1e517716..46a3743e95ff 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3722,21 +3722,18 @@ static long kvm_vm_ioctl(struct file *filp,
>  		if (routing.flags)
>  			goto out;
>  		if (routing.nr) {
> -			r = -ENOMEM;
> -			entries = vmalloc(array_size(sizeof(*entries),
> -						     routing.nr));
> -			if (!entries)
> -				goto out;
> -			r = -EFAULT;
>  			urouting = argp;
> -			if (copy_from_user(entries, urouting->entries,
> -					   routing.nr * sizeof(*entries)))
> -				goto out_free_irq_routing;
> +			entries = vmemdup_user(urouting->entries,
> +					       array_size(sizeof(*entries),
> +							  routing.nr));
> +			if (IS_ERR(entries)) {
> +				r = PTR_ERR(entries);
> +				goto out;
> +			}
>  		}
>  		r = kvm_set_irq_routing(kvm, entries, routing.nr,
>  					routing.flags);
> -out_free_irq_routing:
> -		vfree(entries);
> +		kvfree(entries);
>  		break;
>  	}
>  #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
> 

Queued, thanks.

Paolo

