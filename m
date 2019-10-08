Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B8FCF990
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 14:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbfJHMMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 08:12:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbfJHMLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 08:11:24 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 191CD7FDF0
        for <kvm@vger.kernel.org>; Tue,  8 Oct 2019 12:11:24 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id k9so1306954wmb.0
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 05:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XC+l+JGNpdezIfgQgjgQjgcBhVIbmx5T2yywcc/3dIc=;
        b=Jtr307aovqgEuGfdvaUN9vVK0oLvKGPK2ntYEkpSFLYksVnV6ZWq9/PjDRLZyaeW10
         srKuZi2GaRPUQznvQ+nOnb/CbM9FDI45AFFUfjzFg878IjX/VFLW/Rang9eeAfUrtPnG
         Xp9iv2wld7R3otcMi9j2CCpsaMC5X+TrtI4vHl28mtgThzmC2jOZSAhAVgSql8CuiZjc
         wlbZnXly2gs1FPUPkmp6S3S7Vk/ScNZQ+ezD3JH74UIYd7ElyaXM0JTyg5WmrYoJhVo0
         p7E95ST3RX8rWc72ohFegFqviPykn6bieqr//7qzkUP00beiaZ2hfYC8dPuMBGeb8aRS
         B1bA==
X-Gm-Message-State: APjAAAVLgib16zbdZqL/pki86A19+XCpLFKDsMxRdk6a4tx8/Np4Rln8
        jLJHQJoxzqplrLTyWfYkJZMNrSmYj2/36WBk9PNp95q1TlhikuhWAf5O17Qv7EgioMPJl5Gmjbe
        9hXBTmgsQoNht
X-Received: by 2002:a05:6000:45:: with SMTP id k5mr24156927wrx.259.1570536682667;
        Tue, 08 Oct 2019 05:11:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxVOLNmOG55qRmpeZcOk9E693639E92Lk3u+fEJ6vxxVUor4lqnEMXs6hNuOIi96Wl4hyTPMw==
X-Received: by 2002:a05:6000:45:: with SMTP id k5mr24156902wrx.259.1570536682402;
        Tue, 08 Oct 2019 05:11:22 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id t83sm5002990wmt.18.2019.10.08.05.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 05:11:21 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: Don't shrink/grow vCPU halt_poll_ns if host side
 polling is disabled
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <1569719216-32080-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a0f940ba-7bc9-8695-c233-0d82858fb91d@redhat.com>
Date:   Tue, 8 Oct 2019 14:11:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569719216-32080-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/19 03:06, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Don't waste cycles to shrink/grow vCPU halt_poll_ns if host 
> side polling is disabled.
> 
> Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2: 
>  * fix coding style
> 
>  virt/kvm/kvm_main.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e6de315..9d5eed9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2359,20 +2359,23 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_unblocking(vcpu);
>  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>  
> -	if (!vcpu_valid_wakeup(vcpu))
> -		shrink_halt_poll_ns(vcpu);
> -	else if (halt_poll_ns) {
> -		if (block_ns <= vcpu->halt_poll_ns)
> -			;
> -		/* we had a long block, shrink polling */
> -		else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
> +	if (!kvm_arch_no_poll(vcpu)) {
> +		if (!vcpu_valid_wakeup(vcpu)) {
>  			shrink_halt_poll_ns(vcpu);
> -		/* we had a short halt and our poll time is too small */
> -		else if (vcpu->halt_poll_ns < halt_poll_ns &&
> -			block_ns < halt_poll_ns)
> -			grow_halt_poll_ns(vcpu);
> -	} else
> -		vcpu->halt_poll_ns = 0;
> +		} else if (halt_poll_ns) {
> +			if (block_ns <= vcpu->halt_poll_ns)
> +				;
> +			/* we had a long block, shrink polling */
> +			else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
> +				shrink_halt_poll_ns(vcpu);
> +			/* we had a short halt and our poll time is too small */
> +			else if (vcpu->halt_poll_ns < halt_poll_ns &&
> +				block_ns < halt_poll_ns)
> +				grow_halt_poll_ns(vcpu);
> +		} else {
> +			vcpu->halt_poll_ns = 0;
> +		}
> +	}
>  
>  	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
>  	kvm_arch_vcpu_block_finish(vcpu);
> 

Queued, thanks.

Paolo
