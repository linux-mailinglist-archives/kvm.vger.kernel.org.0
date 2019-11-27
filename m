Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33DF610B3A0
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 17:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfK0QlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 11:41:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26468 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727116AbfK0QlC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 11:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574872861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9clyZwt1Uy0kISk+R89yEnPo3r3EiKdUvG2fY8pwo4=;
        b=WXfLxT5cAl7jXe8VReWKWf+4kULsazN9b5nXv8X/McKbHVjLMbOdTnA6NVuFqVQY0QOVOZ
        pl6WZLG61FGixlUSeVB765C7SVwp3SGcPedX+VWmE1FT4XlDr9R5xt0RjG8aOFirI4OCF8
        qh3n5M0BPOk9TUsuDUO28k0o+x7/QDw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-0iDrmnkxMoio7y36eJG53Q-1; Wed, 27 Nov 2019 11:40:57 -0500
Received: by mail-wm1-f69.google.com with SMTP id m68so2730650wme.7
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2019 08:40:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D9clyZwt1Uy0kISk+R89yEnPo3r3EiKdUvG2fY8pwo4=;
        b=VdyPXgSZ++ufMOUdueruyPZZVcQn2qA8wxEpUXlRZ6KfqUR15Q9m0ElqaPNS4Hrr+p
         /96W8Xb/63FKU9rYRdi30Puu2hHN1JgYw8rkKE8FMqWjNHeJRpHRDQxkz9wEtxdL0NNO
         wTbiAKjegW1eHyWr41vjpnUWpFhhSMxuyNKDYNM3dm510JUhUs5NVoHQsFlqttE3Z9FS
         XvFU0zKUyNv281Bsvo3WQWlgaduXJiT7aWXYYBeKPnj8H1yo/jtQ0nXXltVStb+D37ik
         M/YyBV2+j7Z7cxJ8ChLARwtxxVbS3swZgYCerzzxbXXRpT0+7NwkYzMtwMai0TEgukm9
         eYZw==
X-Gm-Message-State: APjAAAV6Xa7Fbq8uUsdGekQAQFvpAradkzhIJcmiCSbtwJjY5dZajbhK
        4DNla3vlCyl5COzpkRjhqyh+54k6Biwhq3TiRsQ9+OZzhoeS3DmEKnKj5CEMc9AkMGwsmpBT//U
        yaPWovYRnSU4m
X-Received: by 2002:a5d:6548:: with SMTP id z8mr46445811wrv.273.1574872856522;
        Wed, 27 Nov 2019 08:40:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwJQYQNL5K2QbppXpn6b5gcGOLuYeQF7OCPZVcjBL74U3Lx1Ff4ldEAiNEf3QLlek78dqhKpg==
X-Received: by 2002:a5d:6548:: with SMTP id z8mr46445770wrv.273.1574872856109;
        Wed, 27 Nov 2019 08:40:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:459f:99a9:39f1:65ba? ([2001:b07:6468:f312:459f:99a9:39f1:65ba])
        by smtp.gmail.com with ESMTPSA id b63sm6832818wmb.40.2019.11.27.08.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 08:40:55 -0800 (PST)
Subject: Re: [PATCH 1/1] powerpc/kvm/book3s: Fixes possible 'use after
 release' of kvm
To:     Leonardo Bras <leonardo@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20191126175212.377171-1-leonardo@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f3750cf8-88fc-cae7-1cfb-cb4b86b44704@redhat.com>
Date:   Wed, 27 Nov 2019 17:40:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191126175212.377171-1-leonardo@linux.ibm.com>
Content-Language: en-US
X-MC-Unique: 0iDrmnkxMoio7y36eJG53Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/11/19 18:52, Leonardo Bras wrote:
> Fixes a possible 'use after free' of kvm variable.
> It does use mutex_unlock(&kvm->lock) after possible freeing a variable
> with kvm_put_kvm(kvm).
> 
> Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_64_vio.c | 3 +--
>  virt/kvm/kvm_main.c              | 8 ++++----
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index 5834db0a54c6..a402ead833b6 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -316,14 +316,13 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
>  
>  	if (ret >= 0)
>  		list_add_rcu(&stt->list, &kvm->arch.spapr_tce_tables);
> -	else
> -		kvm_put_kvm(kvm);
>  
>  	mutex_unlock(&kvm->lock);
>  
>  	if (ret >= 0)
>  		return ret;
>  
> +	kvm_put_kvm(kvm);
>  	kfree(stt);
>   fail_acct:
>  	account_locked_vm(current->mm, kvmppc_stt_pages(npages), false);

This part is a good change, as it makes the code clearer.  The
virt/kvm/kvm_main.c bits, however, are not necessary as explained by Sean.

Paolo

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 13efc291b1c7..f37089b60d09 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2744,10 +2744,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	/* Now it's all set up, let userspace reach it */
>  	kvm_get_kvm(kvm);
>  	r = create_vcpu_fd(vcpu);
> -	if (r < 0) {
> -		kvm_put_kvm(kvm);
> +	if (r < 0)
>  		goto unlock_vcpu_destroy;
> -	}
>  
>  	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
>  
> @@ -2771,6 +2769,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	mutex_lock(&kvm->lock);
>  	kvm->created_vcpus--;
>  	mutex_unlock(&kvm->lock);
> +	if (r < 0)
> +		kvm_put_kvm(kvm);
>  	return r;
>  }
>  
> @@ -3183,10 +3183,10 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
>  	kvm_get_kvm(kvm);
>  	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
>  	if (ret < 0) {
> -		kvm_put_kvm(kvm);
>  		mutex_lock(&kvm->lock);
>  		list_del(&dev->vm_node);
>  		mutex_unlock(&kvm->lock);
> +		kvm_put_kvm(kvm);
>  		ops->destroy(dev);
>  		return ret;
>  	}
> 

