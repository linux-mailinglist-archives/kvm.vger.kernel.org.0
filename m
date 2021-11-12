Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B35744E3D9
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbhKLJfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:35:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230510AbhKLJfG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 04:35:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636709535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IGqIOaYOVVDlA03zMXxsS+TDWYGOiD9fi9k1v1Jwf24=;
        b=iac0JBD7z7g36i075NHQp5n8Vf5lzcTydWTNBSLyBtV9sb81CvZu2UD5vfDI+FEj5zMwiF
        2lpAPjA4ktigaaf7QZaLuLY9fuWuPaxVQrl17aKdyN6gHZ8nUhQEmCuJlAugBmTvHwdzo8
        tLapUyNRIdOhQ6uoith/gWVw+lfbDjI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-8yFnRX0hPP6zcb2Y9QfxAA-1; Fri, 12 Nov 2021 04:32:12 -0500
X-MC-Unique: 8yFnRX0hPP6zcb2Y9QfxAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA66D101F004;
        Fri, 12 Nov 2021 09:32:10 +0000 (UTC)
Received: from [10.39.193.118] (unknown [10.39.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BA035F4F5;
        Fri, 12 Nov 2021 09:31:50 +0000 (UTC)
Message-ID: <e4b6e45f-dddd-8401-8d7b-9d9cc4f1def0@redhat.com>
Date:   Fri, 12 Nov 2021 10:31:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 4/6] kvm: irqchip: extract
 kvm_irqchip_add_deferred_msi_route
Content-Language: en-US
To:     "Longpeng(Mike)" <longpeng2@huawei.com>, alex.williamson@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, arei.gonglei@huawei.com
References: <20211103081657.1945-1-longpeng2@huawei.com>
 <20211103081657.1945-5-longpeng2@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211103081657.1945-5-longpeng2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/21 09:16, Longpeng(Mike) wrote:
> Extract a common helper that add MSI route for specific vector
> but does not commit immediately.
> 
> Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>

I think adding the new function is not necessary; I have no problem 
moving the call to kvm_irqchip_commit_routes to the callers.  Perhaps 
you can have an API like this:

typedef struct KVMRouteChange {
     KVMState *s;
     int changes;
} KVMRouteChange;

KVMRouteChange kvm_irqchip_begin_route_changes(KVMState *s)
{
     return (KVMRouteChange) { .s = s, .changes = 0 };
}

void kvm_irqchip_commit_route_changes(KVMRouteChange *c)
{
     if (c->changes) {
         kvm_irqchip_commit_routes(c->s);
         c->changes = 0;
    }
}

int kvm_irqchip_add_msi_route(KVMRouteChange *c, int vector, PCIDevice *dev)
{
     KVMState *s = c->s;
     ...
     kvm_add_routing_entry(s, &kroute);
     kvm_arch_add_msi_route_post(&kroute, vector, dev);
     c->changes++;

     return virq;
}

so it's harder for the callers to "forget" kvm_irqchip_commit_route_changes.

Paolo

> ---
>   accel/kvm/kvm-all.c  | 15 +++++++++++++--
>   include/sysemu/kvm.h |  6 ++++++
>   2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index db8d83b..8627f7c 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1953,7 +1953,7 @@ int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg)
>       return kvm_set_irq(s, route->kroute.gsi, 1);
>   }
>   
> -int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
> +int kvm_irqchip_add_deferred_msi_route(KVMState *s, int vector, PCIDevice *dev)
>   {
>       struct kvm_irq_routing_entry kroute = {};
>       int virq;
> @@ -1996,7 +1996,18 @@ int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
>   
>       kvm_add_routing_entry(s, &kroute);
>       kvm_arch_add_msi_route_post(&kroute, vector, dev);
> -    kvm_irqchip_commit_routes(s);
> +
> +    return virq;
> +}
> +
> +int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
> +{
> +    int virq;
> +
> +    virq = kvm_irqchip_add_deferred_msi_route(s, vector, dev);
> +    if (virq >= 0) {
> +        kvm_irqchip_commit_routes(s);
> +    }
>   
>       return virq;
>   }
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index a1ab1ee..8de0d9a 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -476,6 +476,12 @@ void kvm_init_cpu_signals(CPUState *cpu);
>    * @return: virq (>=0) when success, errno (<0) when failed.
>    */
>   int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev);
> +/**
> + * Add MSI route for specific vector but does not commit to KVM
> + * immediately
> + */
> +int kvm_irqchip_add_deferred_msi_route(KVMState *s, int vector,
> +                                       PCIDevice *dev);
>   int kvm_irqchip_update_msi_route(KVMState *s, int virq, MSIMessage msg,
>                                    PCIDevice *dev);
>   void kvm_irqchip_commit_routes(KVMState *s);
> 

