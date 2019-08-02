Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF597F569
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 12:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732075AbfHBKqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 06:46:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43710 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730841AbfHBKqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 06:46:35 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so2131417wru.10
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 03:46:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8nHVa+8uGKdtX3pSY7JjerDZijsdBHPkAyPWVC/nVmk=;
        b=ZAEf+KTy6f5AhWFlRsx61w4ofZ81YfGRsavZCFgDbWCjF7HcLOO9915Wa+i4qPOGNq
         JWlrVG4P8jEDG+EK8rfHr7EBb8BIsyhkzXs7OcfBp4oN9v9M5P5HTM+VECZY6EBhgCT8
         QngMkcjlTE4fDfMn5Jgl34Dr1aI+TVu7MmYv8XsmYReLt/nVf/veGk4Iw6apaEmyZbku
         N3bw/siJ5td+hGRkz847Cjv8/4pJOLibkEbA9f+UVOGhtlG6KzQkCg7xHeXu/NZik89X
         MqJOY0byLzgciLKrRg3EAOhbC1B5gRdiDA1+ad07r/e3XfoVxlAQ/KOMWeZ9haTPN8PW
         mO7g==
X-Gm-Message-State: APjAAAW2W4NEwiILDrVM+lsUSi+yLqn72ZXwtBgZ6BoyffnFLtqm/6uw
        GVK4ikc4jkQ5oejxk4SRA/7D0Q==
X-Google-Smtp-Source: APXvYqweacgUco11b5+iiklsZr3HnubI3sddSf7PjrsWTggPB1b/KH1PZW2FxQ0WyAeTEVE3WuJUPQ==
X-Received: by 2002:a5d:4484:: with SMTP id j4mr3719539wrq.143.1564742793492;
        Fri, 02 Aug 2019 03:46:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id l9sm58540760wmh.36.2019.08.02.03.46.32
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 03:46:32 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: Call kvm_arch_vcpu_blocking early into the
 blocking sequence
To:     Marc Zyngier <maz@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Tangnianyao <tangnianyao@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20190802103709.70148-1-maz@kernel.org>
 <20190802103709.70148-3-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a7250b9a-60e9-b04c-5515-e506aea46515@redhat.com>
Date:   Fri, 2 Aug 2019 12:46:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802103709.70148-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/19 12:37, Marc Zyngier wrote:
> When a vpcu is about to block by calling kvm_vcpu_block, we call
> back into the arch code to allow any form of synchronization that
> may be required at this point (SVN stops the AVIC, ARM synchronises
> the VMCR and enables GICv4 doorbells). But this synchronization
> comes in quite late, as we've potentially waited for halt_poll_ns
> to expire.
> 
> Instead, let's move kvm_arch_vcpu_blocking() to the beginning of
> kvm_vcpu_block(), which on ARM has several benefits:
> 
> - VMCR gets synchronised early, meaning that any interrupt delivered
>   during the polling window will be evaluated with the correct guest
>   PMR
> - GICv4 doorbells are enabled, which means that any guest interrupt
>   directly injected during that window will be immediately recognised
> 
> Tang Nianyao ran some tests on a GICv4 machine to evaluate such
> change, and reported up to a 10% improvement for netperf:
> 
> <quote>
> 	netperf result:
> 	D06 as server, intel 8180 server as client
> 	with change:
> 	package 512 bytes - 5500 Mbits/s
> 	package 64 bytes - 760 Mbits/s
> 	without change:
> 	package 512 bytes - 5000 Mbits/s
> 	package 64 bytes - 710 Mbits/s
> </quote>
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/kvm_main.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 887f3b0c2b60..90d429c703cb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2322,6 +2322,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	bool waited = false;
>  	u64 block_ns;
>  
> +	kvm_arch_vcpu_blocking(vcpu);
> +
>  	start = cur = ktime_get();
>  	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
>  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
> @@ -2342,8 +2344,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  		} while (single_task_running() && ktime_before(cur, stop));
>  	}
>  
> -	kvm_arch_vcpu_blocking(vcpu);
> -
>  	for (;;) {
>  		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
>  
> @@ -2356,9 +2356,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  
>  	finish_swait(&vcpu->wq, &wait);
>  	cur = ktime_get();
> -
> -	kvm_arch_vcpu_unblocking(vcpu);
>  out:
> +	kvm_arch_vcpu_unblocking(vcpu);
>  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>  
>  	if (!vcpu_valid_wakeup(vcpu))
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
