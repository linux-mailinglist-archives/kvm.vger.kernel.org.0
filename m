Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37397420920
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 12:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhJDKOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 06:14:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229478AbhJDKOd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 06:14:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633342364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rCPDv4QRNZ0a1fQs05Nas1A64qaGfmSB0iOlYE+QsHo=;
        b=WcC/5S85Qdw+pwLrN3LUq9axW6TckjG4KkxJX2eR7CQ6GVNKGNOFrw1voyg5qLRLSLhrYa
        /mvWf6M8bQzrcbvSTi676ru96VOoYJ+XXy4ZH4DQxxhoXQ0UvmZXHdyUQ421qRJn1TGim3
        7nOhsGTQnQn2iTieisuwQIm82QCe4Ek=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-zEUAEqNpP1-egb0lSsl_ig-1; Mon, 04 Oct 2021 06:12:43 -0400
X-MC-Unique: zEUAEqNpP1-egb0lSsl_ig-1
Received: by mail-wm1-f69.google.com with SMTP id y23-20020a05600c365700b003015b277f98so4636656wmq.2
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 03:12:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rCPDv4QRNZ0a1fQs05Nas1A64qaGfmSB0iOlYE+QsHo=;
        b=6bBvepXbpuLWF2vU+b1zmCHQAACPN5o4LLAHCsUVuXKRCiSKexVGzVfFjkAp4agZ3C
         uzwSGSAENZRHVVJyOwsdil2+MhnlLQuvB7RZz9tkRDGzxsQ3q4EdillMAnxIlbamj5MU
         GIJt7r9nwnQ1b3H51R3FruyfBaC08yOo6I5Air3Zvoqc8fDmoNSO6L/7R1OPEGyoRIr7
         SIOy1YZOaTCMOIP0DsIxe2xUNsR1rDNsmiu/e0k9uepmhFlhU3ij3OWEHvk+rlwYk2sx
         Ip7NgqOQT7uSC8aU8AluplEMXOwgLgoOLybPpcoHPsKfUxvsL4KgnSBYtzzSnL/8mGHi
         HGqQ==
X-Gm-Message-State: AOAM533iM473UKQdnLt9TLlO3xkzGNuUKWEBJwOsUvsDJ2Lhx2tZboSv
        yDe40j8U8nn7g0Gxs3LGPvMcxXGzdo9ge1dF1e0z3lsczJqNw+pNIQivbZXnBwQ5Hvaq5RJkDUN
        BA2Q2lvo+mVDZ
X-Received: by 2002:adf:f946:: with SMTP id q6mr13123327wrr.437.1633342362030;
        Mon, 04 Oct 2021 03:12:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSvhm+jWUInTDea5wEfwMr2LgnDYEZ4Lout+X2NLSfcGiX7+w+w//Bp93Dv3sbxAR10OUxnw==
X-Received: by 2002:adf:f946:: with SMTP id q6mr13123315wrr.437.1633342361923;
        Mon, 04 Oct 2021 03:12:41 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id b16sm1605797wrw.46.2021.10.04.03.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 03:12:41 -0700 (PDT)
Date:   Mon, 4 Oct 2021 12:12:40 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 5/5] hw/arm/virt: Disable highmem devices that don't
 fit in the PA range
Message-ID: <20211004101240.fdf2mty5jvnler33@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211003164605.3116450-6-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 03, 2021 at 05:46:05PM +0100, Marc Zyngier wrote:
> Make sure both the highmem PCIe and GICv3 regions are disabled when
> they don't fully fit in the PA range.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index a572e0c9d9..756f67b6c8 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1673,6 +1673,9 @@ static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
>      if (base <= BIT_ULL(pa_bits)) {
>          vms->highest_gpa = base -1;
>      } else {
> +        /* Advertise that we have disabled the highmem devices */
> +        vms->highmem_ecam = false;
> +        vms->highmem_redists = false;
>          vms->highest_gpa = memtop - 1;
>      }
>  
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

