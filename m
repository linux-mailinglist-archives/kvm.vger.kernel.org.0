Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2A31DA65D
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 02:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgETAU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 20:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgETAU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 20:20:57 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D62C061A0E
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 17:20:57 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id l3so547970qvo.7
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 17:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LBB46rtW2d9K5WUtTRAG4fGkmmxRO4txDBDNhv1nb3I=;
        b=aufPXHafyAKGS85jzWFQOmgEWdqs2c3vqfnjP5CTdSPYXzcd9jfZDjoFw7/fNhSpkq
         IEZvwy3nKg/7g5wAsBDxBkWyxPLi0cj4q3usRy4fSHicFZVt61hbduN29GYLULTU3gPr
         Q7V7t+NzRRNytV7oV32b0dXWPTuzrqLtQT5r6hIF73tiiSOpCL7QS877pdVlaLjAS6N7
         UBfvfG4X9vrVciR1zgfzlhvxP9ALidemtfWxUeq9f3OWI2jyqIvHIHbU5TEQLYHeFsSS
         MMrEe9j7jF8ybu7VVS564vbdG9pPvCrzDHDqF1D3h/arpm778fP207M1EnuLnsBaOaqN
         NlPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LBB46rtW2d9K5WUtTRAG4fGkmmxRO4txDBDNhv1nb3I=;
        b=rEL3DzDq8mER7UmviDApfJHjV/0/hp8aLQiy086sIv6CUdT7FCEY8CnApeWr9aDKUa
         tHaHky1W7EPyYG/04sxK2bDMU5rqfEDs3o8Xh8n/EKVbRDMMae2ymTjE4x+El8YLuOtw
         8yZ7/VBf7r3RUfa4LYyGRXZfss3xZ73N/uKh7ujezxc8gSkNFrRfuthCElummCtSzeyq
         z2RVlX0bxWbMQJ980JkJklSt8uomrtSrEBVY2cbxytZga6bGFJOD9K0xX6fOzw+0EOHY
         inCGzMr0w2MGPM8i9Ua8HIAzJfAMigy6gwaXT252dxDSQEGZoZCU6cXfl3y4w/ddvhMn
         GUyw==
X-Gm-Message-State: AOAM533MSSpIFrGmDeZ88dYnbOlZ4KN3wJ8GJSkMgJl/XlGvH1wS1Gmw
        JFTlghRcp34o9lTEMlG/DTqDES/j0UM=
X-Google-Smtp-Source: ABdhPJzUB+q2wwwWl7HLqKjiszG5tdFF+m444eib+1trXjL6fLEd1NOT5DuZ5jvnviZDurr8gfCNzw==
X-Received: by 2002:ad4:4a8b:: with SMTP id h11mr2482355qvx.232.1589934056694;
        Tue, 19 May 2020 17:20:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id y66sm769077qka.24.2020.05.19.17.20.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 May 2020 17:20:56 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jbCTf-0003SK-R4; Tue, 19 May 2020 21:20:55 -0300
Date:   Tue, 19 May 2020 21:20:55 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 2/2] vfio: Introduce strict PFNMAP mappings
Message-ID: <20200520002055.GC31189@ziepe.ca>
References: <158947414729.12590.4345248265094886807.stgit@gimli.home>
 <158947512947.12590.4756232870747830161.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158947512947.12590.4756232870747830161.stgit@gimli.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 10:52:09AM -0600, Alex Williamson wrote:
>  	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 62ba6bd8a486..8d6286d89230 100644
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -61,6 +61,11 @@ module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
>  MODULE_PARM_DESC(dma_entry_limit,
>  		 "Maximum number of user DMA mappings per container (65535).");
>  
> +static bool strict_mmio_maps = true;
> +module_param_named(strict_mmio_maps, strict_mmio_maps, bool, 0644);
> +MODULE_PARM_DESC(strict_mmio_maps,
> +		 "Restrict DMA mappings of MMIO to those provided by vfio bus drivers supporting invalidation (true).");
> +

This should probably explain that 'false' allows some kind of security
issue and maybe taint the kernel?

Do you think there is a reason to have this anyhow?

Jason
