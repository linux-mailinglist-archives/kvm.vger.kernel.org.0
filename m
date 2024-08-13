Return-Path: <kvm+bounces-24030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6029509E6
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 501161C22600
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7BA1A2542;
	Tue, 13 Aug 2024 16:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GTZt03Wu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8050D1A0AFB
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 16:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723565458; cv=none; b=BGAlGpYz9DsUfvX8J4+ZHu6D09MjqaSQ1SamLWxSM+1TQjnRNQrJg3i7r8H96M3Afxya04QxhHdrox6vKk0p4Ta1AoEBcqMyNAzQVKycN8ehPwRZ8a/gtKBprsTPvF3b9pnLTh0uZkbjhImNqONFv2cpsMqk07QjnZjWUYMoOuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723565458; c=relaxed/simple;
	bh=saaYfi8ZsXxVO9FzeCqJPBDYrbCP+GnyxF1yJ+NwnMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PHFxIs12KijWCLhbeuP3ICXPbnh/gnTQPZYZBkPSIlkdWQJ1V8to/lCiEjZwDDhX7t1bEHIczeOZTLwwnxldr5Jy0NPtLEfvxrM5kTwOdGDudFqhpgpieLR70wVu5UKmNjPjXcVem96GZH0/njhgY24jD3Q0fUgXcDqUkHGZqEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GTZt03Wu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723565455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XgSX3wp9iueC/8sR2kEg7rGFWS4N4ECfGsCl4oGGAi4=;
	b=GTZt03Wu2GulCKXzJAD/lzYKrkYQ5Hi+qZDFMoFMjnAbluB9EcDU2Xu8Vq+FfsMhhwdBrr
	0De+57ngbk/d9qWulsvW+2GPQvPHdTL2vtusOvIpifY7RYojSK5qx8U52RVOmUrVyyLZNv
	v7ry6oWJAOHHZ0YieCaY5LID1KQV4og=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-H0Cz1_dbOW2FUnT9yXwv6w-1; Tue, 13 Aug 2024 12:10:54 -0400
X-MC-Unique: H0Cz1_dbOW2FUnT9yXwv6w-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a7aa5885be3so419164666b.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 09:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723565451; x=1724170251;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XgSX3wp9iueC/8sR2kEg7rGFWS4N4ECfGsCl4oGGAi4=;
        b=aCjqmdaceEETIQTZ0mgc2dtlVIQ1DkRwlfotELeL5x+cxvalwxkOLZP0q7hVjpOwmt
         L5PStsqp2KllnHP1sMk+TSCfxz5RkbuOr+xajZajYpl34RIDumzDF0WUNgq5YbyF/Ga7
         p5kCDm8KBauv5zqVoug1rBFcb72ujUAJfv9AmW0Q+iDmedgZ1Z/2tQqwgMjMV9zMAHmU
         2gCpZ5kdBt/pNa8ezGQkMlX7pQ+o4/qzlaQ2V0NOlmFuzBvcq8/3fuG1vgddnmJYy2qQ
         b1U1iDtPVFYBEV5qbbJIyCnaLlBnsMSVCgYQ7sX9qleGdNjKno3Ac8PuUl9zIj1buw1A
         1lVw==
X-Forwarded-Encrypted: i=1; AJvYcCXFJ3i/y18nmcqe3hl3dCbk2qtMjo/PYP2XQyPyhkbaMYgTJxFMTz1eBcGaXbgYLlx3NhEkxxUZsbwdIPpySHHGEtM/
X-Gm-Message-State: AOJu0YyYxW+wJTgzum2ur88BEgnletDBxylcTWsLltb6CvKEjKnF5vhm
	XcWQ/G7C5tWD/mCgzoFV8tUUmMvhyNv1g6baQoWeUqwMR46iHZX+1gtuim3DI3ZcO/qv2j6dEop
	aiBwrCxOERKVxSe+QMLzRxkmr6EK8C+l6y7w+ZIul/tiVa7ilO8RAKn9kJA==
X-Received: by 2002:a17:907:9703:b0:a80:f79a:eb6f with SMTP id a640c23a62f3a-a80f79af154mr148622066b.8.1723565450541;
        Tue, 13 Aug 2024 09:10:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIfIFClQR5AQnTNFl6M8NbJwoxycY9Oe2vA8WLvhS9mspJedaPN1gx4LEo4GSKt0DyBL27pg==
X-Received: by 2002:a17:907:9703:b0:a80:f79a:eb6f with SMTP id a640c23a62f3a-a80f79af154mr148620466b.8.1723565449986;
        Tue, 13 Aug 2024 09:10:49 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a80f411b11bsm80356266b.130.2024.08.13.09.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 09:10:48 -0700 (PDT)
Message-ID: <17a49ab6-9669-486b-9835-62c2d3979400@redhat.com>
Date: Tue, 13 Aug 2024 18:10:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: eventfd: Use synchronize_srcu_expedited()
To: Li RongQing <lirongqing@baidu.com>, kvm@vger.kernel.org
References: <20240711121130.38917-1-lirongqing@baidu.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240711121130.38917-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/11/24 14:11, Li RongQing wrote:
> When hot-unplug a device which has many queues, and guest CPU will has
> huge jitter, and unplugging is very slow.
> 
> It turns out synchronize_srcu() in irqfd_shutdown() caused the guest
> jitter and unplugging latency, so replace synchronize_srcu() with
> synchronize_srcu_expedited(), to accelerate the unplugging, and reduce
> the guest OS jitter, this accelerates the VM reboot too.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>   virt/kvm/eventfd.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 2295700..e9e1fa2 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -97,13 +97,13 @@ irqfd_resampler_shutdown(struct kvm_kernel_irqfd *irqfd)
>   	mutex_lock(&kvm->irqfds.resampler_lock);
>   
>   	list_del_rcu(&irqfd->resampler_link);
> -	synchronize_srcu(&kvm->irq_srcu);
> +	synchronize_srcu_expedited(&kvm->irq_srcu);
>   
>   	if (list_empty(&resampler->list)) {
>   		list_del_rcu(&resampler->link);
>   		kvm_unregister_irq_ack_notifier(kvm, &resampler->notifier);
>   		/*
> -		 * synchronize_srcu(&kvm->irq_srcu) already called
> +		 * synchronize_srcu_expedited(&kvm->irq_srcu) already called
>   		 * in kvm_unregister_irq_ack_notifier().
>   		 */
>   		kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
> @@ -126,7 +126,7 @@ irqfd_shutdown(struct work_struct *work)
>   	u64 cnt;
>   
>   	/* Make sure irqfd has been initialized in assign path. */
> -	synchronize_srcu(&kvm->irq_srcu);
> +	synchronize_srcu_expedited(&kvm->irq_srcu);
>   
>   	/*
>   	 * Synchronize with the wait-queue and unhook ourselves to prevent
> @@ -384,7 +384,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>   		}
>   
>   		list_add_rcu(&irqfd->resampler_link, &irqfd->resampler->list);
> -		synchronize_srcu(&kvm->irq_srcu);
> +		synchronize_srcu_expedited(&kvm->irq_srcu);
>   
>   		mutex_unlock(&kvm->irqfds.resampler_lock);
>   	}
> @@ -523,7 +523,7 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
>   	mutex_lock(&kvm->irq_lock);
>   	hlist_del_init_rcu(&kian->link);
>   	mutex_unlock(&kvm->irq_lock);
> -	synchronize_srcu(&kvm->irq_srcu);
> +	synchronize_srcu_expedited(&kvm->irq_srcu);
>   	kvm_arch_post_irq_ack_notifier_list_update(kvm);
>   }
>   
> @@ -608,7 +608,7 @@ kvm_irqfd_release(struct kvm *kvm)
>   
>   /*
>    * Take note of a change in irq routing.
> - * Caller must invoke synchronize_srcu(&kvm->irq_srcu) afterwards.
> + * Caller must invoke synchronize_srcu_expedited(&kvm->irq_srcu) afterwards.
>    */
>   void kvm_irq_routing_update(struct kvm *kvm)
>   {

Queued, thanks.

Paolo


