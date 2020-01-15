Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1807313CB5F
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 18:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgAORvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 12:51:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52884 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728899AbgAORvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 12:51:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579110692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U601CLGCdVAs17IVbD0yyOLC6DlNZgQCJ18JOZ2iGUM=;
        b=Rg82let77ML8gS9cN4iiNXwo4OINZ9VLFQY08wLSLPmGgntIhPnHh61XJ4IL/sUaOt/p0d
        OdDYUryvWcEDoIFXRBu9cWivxsZaL/QPaWGpu5Sd1NMnrWGKQrVGTRKKNL2r7jcNLp+H3r
        NrvE805+gqVYQnGM4mjWDXsiJOyaEVE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-nGb6XKjVOiufFZv5v9f50w-1; Wed, 15 Jan 2020 12:51:31 -0500
X-MC-Unique: nGb6XKjVOiufFZv5v9f50w-1
Received: by mail-wr1-f71.google.com with SMTP id 90so8203996wrq.6
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 09:51:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U601CLGCdVAs17IVbD0yyOLC6DlNZgQCJ18JOZ2iGUM=;
        b=sNDSzPARo4gL1Bilx/B1NcKjWCOOAZEtJ4a2+imjQdExG6l1yEFRduiPwKAjDxgl/k
         2GIp0mdyp7XdWFOQsWIwKnS0MykURMZrcWIpXsRjbRPpamqZbkoaDzgiyGmzDvfoBvA2
         qf/zJQxP5gMa9zmLDwq6uJjG7JZZCfypGOUZW7Vjhj/a/Mv4wabY/6lO9UuZpca+z9jH
         7fW+42QgqVdRL2mD3/nDCMLjBd6H3LqoXHGZO9Bg8th1sJV3qvKjypi6n9D4/1R6djwc
         EymxB0dTu+6BeMs8U/eCF9fuHkT4pVtYMc3sF9J3KO6AVIIdCqKpMOcnc+yQ8llV1RC6
         6PCg==
X-Gm-Message-State: APjAAAWqGRv/+Koz4+ljy/bHG+3ZgaOu5D2HmrOAQp1keS5opW2pGw3P
        +FABR7B8H2tEDxteJSmc6H7zcbrANtH4iY0hVL1LeJbVwz7/rBIIjMXObb8rAIu9oyKWG+agkX1
        LYLwJBaxPPMpb
X-Received: by 2002:a1c:1f51:: with SMTP id f78mr1111317wmf.60.1579110689612;
        Wed, 15 Jan 2020 09:51:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqz37Fwd9FYw9yKIWeGLEnoGTzaMgIWhzdGN84AOR4oqqNRXqZpYEEEXJiwFaIUZKdj3bGR76Q==
X-Received: by 2002:a1c:1f51:: with SMTP id f78mr1111294wmf.60.1579110689384;
        Wed, 15 Jan 2020 09:51:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id o15sm25943715wra.83.2020.01.15.09.51.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 09:51:28 -0800 (PST)
Subject: Re: [PATCH v4 2/2] KVM: LAPIC: micro-optimize fixed mode ipi delivery
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1574306232-872-1-git-send-email-wanpengli@tencent.com>
 <1574306232-872-2-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b84594ae-5874-e006-7a9e-dfd30e1bbefd@redhat.com>
Date:   Wed, 15 Jan 2020 18:51:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1574306232-872-2-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/11/19 04:17, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> This patch optimizes redundancy logic before fixed mode ipi is delivered
> in the fast path, broadcast handling needs to go slow path, so the delivery
> mode repair can be delayed to before slow path.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/irq_comm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 8ecd48d..aa88156 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -52,15 +52,15 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>  	unsigned long dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
>  	unsigned int dest_vcpus = 0;
>  
> +	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
> +		return r;
> +
>  	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
>  			kvm_lowest_prio_delivery(irq)) {
>  		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
>  		irq->delivery_mode = APIC_DM_FIXED;
>  	}
>  
> -	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
> -		return r;
> -
>  	memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> 

Applied.

Paolo

