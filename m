Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C2915A791
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgBLLTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:19:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20448 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbgBLLTW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 06:19:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581506360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YlLI5XVr5Wc9+pWx7tpAwQuz9CsmiC2eusgJFVPX+ck=;
        b=Mtvh2HXaz5cjF5kIGzy+rWyLE3NRDp8YJllGdun0e3sKme/+QYknzmA0EHEKZks1bMLb4C
        3xrjCXvDsiPAgImST9hYqbtFJWzrni6mH2ZGO3WT6OGUSv4hrEE6bHtyD0xtewTSczF1YV
        z+ndwCFeDHGRXusSeDnutz9wL/r771o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-wW5kncDdMO-fevnS8H-M3A-1; Wed, 12 Feb 2020 06:19:15 -0500
X-MC-Unique: wW5kncDdMO-fevnS8H-M3A-1
Received: by mail-wm1-f69.google.com with SMTP id u11so593812wmb.4
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 03:19:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YlLI5XVr5Wc9+pWx7tpAwQuz9CsmiC2eusgJFVPX+ck=;
        b=c0tywreM+BXO2K4FjnseGHmfCohp3XUa5MUTk5HczcJ5jfjhN2R16G8iRyYnZuXWnN
         /v8SEQKB/n+TEnJm0dVzXLu5jTxP+I8/e/NQ4WTWJHWD+UxYLfnuy1CxLbo9hLVO2nCJ
         GAnLsRlE/ykpFvynxW5KSOt8kZ/tXwsQf83S8B9USKyNLnevJ6hG12tGMw9TyAmtkwsL
         /mMXo6YfxtSUyVutuAiX0Yh0ZvGuRY7lum+A0zWhlEkFxwjxSXWMg9VP/erHgHoBHADa
         a1F5oTEblAsI9Sl/eAi9fICm2OekZhzvC1HvLljI7tUyvBxJM1RXQv4DDhzdCSwh0Ez2
         7Z+A==
X-Gm-Message-State: APjAAAXjk5BoV/2WrSoplh0xJPaAQhSqQMUlQ2qdNNf+swZ1louc/psD
        t7emLCgGWShp4RHmq1zDzdZ1h5h10sPgsXgIcUGs3DK5EjolU7jSK1vUSVYzQqTCTubF5M8xMYz
        EwTkCfMsDNazL
X-Received: by 2002:adf:f406:: with SMTP id g6mr14924815wro.189.1581506354121;
        Wed, 12 Feb 2020 03:19:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqymfHc6RwQBr8SJa0qfwEJkhyZj1ibMcD/6wcX1Ufs9ioeURGiTMq4XoSDi3emuW5gMXLaYCg==
X-Received: by 2002:adf:f406:: with SMTP id g6mr14924770wro.189.1581506353668;
        Wed, 12 Feb 2020 03:19:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id b13sm249477wrq.48.2020.02.12.03.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 03:19:11 -0800 (PST)
Subject: Re: [PATCH] KVM: Disable preemption in kvm_get_running_vcpu()
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20200207163410.31276-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <34f68f45-1c09-d7bf-2f86-551d11a2274a@redhat.com>
Date:   Wed, 12 Feb 2020 12:19:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200207163410.31276-1-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 17:34, Marc Zyngier wrote:
> Accessing a per-cpu variable only makes sense when preemption is
> disabled (and the kernel does check this when the right debug options
> are switched on).
> 
> For kvm_get_running_vcpu(), it is fine to return the value after
> re-enabling preemption, as the preempt notifiers will make sure that
> this is kept consistent across task migration (the comment above the
> function hints at it, but lacks the crucial preemption management).
> 
> While we're at it, move the comment from the ARM code, which explains
> why the whole thing works.
> 
> Fixes: 7495e22bb165 ("KVM: Move running VCPU from ARM to common code").
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/318984f6-bc36-33a3-abc6-bf2295974b06@huawei.comz

Queued, thanks.

Paolo

> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 12 ------------
>  virt/kvm/kvm_main.c           | 16 +++++++++++++---
>  2 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index d656ebd5f9d4..97fb2a40e6ba 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -179,18 +179,6 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  	return value;
>  }
>  
> -/*
> - * This function will return the VCPU that performed the MMIO access and
> - * trapped from within the VM, and will return NULL if this is a userspace
> - * access.
> - *
> - * We can disable preemption locally around accessing the per-CPU variable,
> - * and use the resolved vcpu pointer after enabling preemption again, because
> - * even if the current thread is migrated to another CPU, reading the per-CPU
> - * value later will give us the same value as we update the per-CPU variable
> - * in the preempt notifier handlers.
> - */
> -
>  /* Must be called with irq->irq_lock held */
>  static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  				 bool is_uaccess)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67ae2d5c37b2..70f03ce0e5c1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4409,12 +4409,22 @@ static void kvm_sched_out(struct preempt_notifier *pn,
>  
>  /**
>   * kvm_get_running_vcpu - get the vcpu running on the current CPU.
> - * Thanks to preempt notifiers, this can also be called from
> - * preemptible context.
> + *
> + * We can disable preemption locally around accessing the per-CPU variable,
> + * and use the resolved vcpu pointer after enabling preemption again,
> + * because even if the current thread is migrated to another CPU, reading
> + * the per-CPU value later will give us the same value as we update the
> + * per-CPU variable in the preempt notifier handlers.
>   */
>  struct kvm_vcpu *kvm_get_running_vcpu(void)
>  {
> -        return __this_cpu_read(kvm_running_vcpu);
> +	struct kvm_vcpu *vcpu;
> +
> +	preempt_disable();
> +	vcpu = __this_cpu_read(kvm_running_vcpu);
> +	preempt_enable();
> +
> +	return vcpu;
>  }
>  
>  /**
> 

