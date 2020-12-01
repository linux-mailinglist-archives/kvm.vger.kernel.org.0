Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5155D2CA861
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 17:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgLAQjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 11:39:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLAQjN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 11:39:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606840666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wL2V5kfaTVmKlTWvGK7gg88wZom4tKDt3zAUF8Om/YU=;
        b=EmzvNsR5b0EgptNT7MIuOvTKr83Vab+cvICs712V0jsyrseZwVvFayq4zYHMirgxA8V0DH
        gOEpDIniuN46lBDD6tWxvbbMFzD4uaASssawd6nxQ2MtV/TG+jD0X0QNoTWmkR9hycPhgt
        jg8cAumEgscPdEdqErH8TXEio4u+Kbo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-hpEhJVE0NSG96_dM23Mb9Q-1; Tue, 01 Dec 2020 11:37:32 -0500
X-MC-Unique: hpEhJVE0NSG96_dM23Mb9Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB5371DDEA;
        Tue,  1 Dec 2020 16:37:30 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B0B760C0F;
        Tue,  1 Dec 2020 16:37:29 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 02/10] lib: arm/arm64: gicv2: Add missing
 barrier when sending IPIs
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-3-alexandru.elisei@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <43a43738-3169-c989-1067-4fa1964a83d7@redhat.com>
Date:   Tue, 1 Dec 2020 17:37:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201125155113.192079-3-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 11/25/20 4:51 PM, Alexandru Elisei wrote:
> GICv2 generates IPIs with a MMIO write to the GICD_SGIR register. A common
> pattern for IPI usage is for the IPI receiver to read data written to
> memory by the sender. The armv7 and armv8 architectures implement a
> weakly-ordered memory model, which means that barriers are required to make
> sure that the expected values are observed.
> 
> It turns out that because the receiver CPU must observe the write to memory
> that generated the IPI when reading the GICC_IAR MMIO register, we only
> need to ensure ordering of memory accesses, and not completion. Use a
> smp_wmb (DMB ISHST) barrier before sending the IPI.
> 
> This also matches what the Linux GICv2 irqchip driver does (more details
> in commit 8adbf57fc429 ("irqchip: gic: use dmb ishst instead of dsb when
> raising a softirq")).
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  lib/arm/gic-v2.c | 4 ++++
>  arm/gic.c        | 2 ++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
> index dc6a97c600ec..da244c82de34 100644
> --- a/lib/arm/gic-v2.c
> +++ b/lib/arm/gic-v2.c
> @@ -45,6 +45,8 @@ void gicv2_ipi_send_single(int irq, int cpu)
>  {
>  	assert(cpu < 8);
>  	assert(irq < 16);
> +
> +	smp_wmb();
>  	writel(1 << (cpu + 16) | irq, gicv2_dist_base() + GICD_SGIR);
>  }
>  
> @@ -53,5 +55,7 @@ void gicv2_ipi_send_mask(int irq, const cpumask_t *dest)
>  	u8 tlist = (u8)cpumask_bits(dest)[0];
>  
>  	assert(irq < 16);
> +
> +	smp_wmb();
>  	writel(tlist << 16 | irq, gicv2_dist_base() + GICD_SGIR);
>  }
> diff --git a/arm/gic.c b/arm/gic.c
> index 512c83636a2e..401ffafe4299 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -260,11 +260,13 @@ static void check_lpi_hits(int *expected, const char *msg)
>  
>  static void gicv2_ipi_send_self(void)
>  {
> +	smp_wmb();
>  	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
>  }
>  
>  static void gicv2_ipi_send_broadcast(void)
>  {
> +	smp_wmb();
>  	writel(1 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
>  }
>  
> 

