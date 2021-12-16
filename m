Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2289E476C2A
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 09:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbhLPIrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 03:47:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232569AbhLPIrR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 03:47:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639644436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2tg22waHuW5CQsQYlHK6Flo/4VDA1ciuXDsOUGOBnv8=;
        b=ggHKDszUjzVcfhh5QlR+Ae9oYq8mYHh4yZt4CCBuO21BvLTd5+N/oSeVu3D8erfwjffrMY
        8W1QhzsO1rjK+yo33OGP0bgX5DXQbLr0YCDMC/n+cWoAxSagc/2zEUlip4CZ4l49VnboEx
        v2tZlDzjYicpQdGnoUGZSsDJG4dqckw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458--v0ud_GaPo2UstJdjmNe6g-1; Thu, 16 Dec 2021 03:47:15 -0500
X-MC-Unique: -v0ud_GaPo2UstJdjmNe6g-1
Received: by mail-wm1-f72.google.com with SMTP id r10-20020a1c440a000000b003456b2594e0so1405171wma.8
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 00:47:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2tg22waHuW5CQsQYlHK6Flo/4VDA1ciuXDsOUGOBnv8=;
        b=N1Ttt4c/1AyggjQR8Pt2xo0UYRXP0AnXWCVV56CIu5dJOTz5nDPzulYo9Bk3xOcYjI
         0YXHxqgflPXx7MSbHpDFpE3PgUI8r4gpGa3cjeJbFu2vPa/KBxIKatYaXp4435c6wOBw
         6PPNoDETTcut1J6vQgZM2HTfjicmSW/GcPQu2Q2C3O2B974D7qRMu9/gyxOAV9jV5Njn
         agKGr0xhDt2PQOs2CKc0vC9/drGwN2eMZws4M6NUlQcFbtJMx5sN90EMcoBbu9Lp+lnK
         mslMeI68sgn2q4nNiRNGrZ3P1xRJbTMo2/y4P8we5i0P1GTGj6DJFGOcz4D7dP/riXIr
         c+rA==
X-Gm-Message-State: AOAM533aFuI8Lg4DectA0dtnvHklgF/AQsjmpwZsyLv07mnHU4QSPq0d
        LIIhY9eD/0DJe3XAzDq+hGxc+/ZjWxs7ls9alZsLRdgYMxb74fG/Z+6h4EhVS5QOuJi5Q9PF8Rt
        igUo0sX2FL3y7
X-Received: by 2002:a05:600c:4f0f:: with SMTP id l15mr3886749wmq.25.1639644434063;
        Thu, 16 Dec 2021 00:47:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7EZ9KrpHeN6hLzB6CDWNWhpRfGg8hLtaOpMGGpg3Kha5qpFV5HNYTqcWKqFzyxJqYitJEOg==
X-Received: by 2002:a05:600c:4f0f:: with SMTP id l15mr3886725wmq.25.1639644433845;
        Thu, 16 Dec 2021 00:47:13 -0800 (PST)
Received: from xz-m1.local ([64.64.123.12])
        by smtp.gmail.com with ESMTPSA id o2sm3112072wru.109.2021.12.16.00.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 00:47:13 -0800 (PST)
Date:   Thu, 16 Dec 2021 16:47:06 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] intel_iommu: Fix irqchip / X2APIC configuration
 checks
Message-ID: <Ybr9Cn7GPKbm/rzL@xz-m1.local>
References: <20211209220840.14889-1-dwmw2@infradead.org>
 <20211209220840.14889-4-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211209220840.14889-4-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, David,

On Thu, Dec 09, 2021 at 10:08:40PM +0000, David Woodhouse wrote:
> We don't need to check kvm_enable_x2apic(). It's perfectly OK to support
> interrupt remapping even if we can't address CPUs above 254. Kind of
> pointless, but still functional.

We only checks kvm_enable_x2apic() if eim=on is set, right?  I mean, we can
still enable IR without x2apic even with current code?

Could you elaborate what's the use scenario for this patch?  Thanks in advance.

> 
> The check on kvm_enable_x2apic() needs to happen *anyway* in order to
> allow CPUs above 254 even without an IOMMU, so allow that to happen
> elsewhere.
> 
> However, we do require the *split* irqchip in order to rewrite I/OAPIC
> destinations. So fix that check while we're here.
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

I think the r-b and a-b should be for patch 2 not this one? :)

> ---
>  hw/i386/intel_iommu.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index bd288d45bb..0d1c72f08e 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -3760,15 +3760,10 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
>                                                ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>      }
>      if (s->intr_eim == ON_OFF_AUTO_ON && !s->buggy_eim) {
> -        if (!kvm_irqchip_in_kernel()) {
> +        if (!kvm_irqchip_is_split()) {

I think this is okay, but note that we'll already fail if !split in
x86_iommu_realize():

    bool irq_all_kernel = kvm_irqchip_in_kernel() && !kvm_irqchip_is_split();

    /* Both Intel and AMD IOMMU IR only support "kernel-irqchip={off|split}" */
    if (x86_iommu_ir_supported(x86_iommu) && irq_all_kernel) {
        error_setg(errp, "Interrupt Remapping cannot work with "
                         "kernel-irqchip=on, please use 'split|off'.");
        return;
    }

>              error_setg(errp, "eim=on requires accel=kvm,kernel-irqchip=split");
>              return false;
>          }
> -        if (!kvm_enable_x2apic()) {
> -            error_setg(errp, "eim=on requires support on the KVM side"
> -                             "(X2APIC_API, first shipped in v4.7)");
> -            return false;
> -        }
>      }
>  
>      /* Currently only address widths supported are 39 and 48 bits */
> -- 
> 2.31.1
> 

-- 
Peter Xu

