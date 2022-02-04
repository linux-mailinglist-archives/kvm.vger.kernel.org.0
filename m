Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5C74A9975
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 13:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbiBDMjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 07:39:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230130AbiBDMjj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 07:39:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643978378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SdIzy7UM4kl6UKXLGR3KWInAe1rl2NNJmwxf0yuz4TA=;
        b=C+Iq5r7NYK3/RThGv/k1YDgU61/QK9Vdd90162YEBg+QzA/WukHakHJn/Pv8j5ylX9ZWe0
        KcEYL0QAgSit0GxaX+BLW4TuRDd4xFVs1tLOq9EybuwhmnRZ8tP3TvI/i2siOM7/4/zh5q
        epo+GowPjQl/hE8B59Eurp5rQvVI/dI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-i-0aqW5DMcaEtMWPiydZJA-1; Fri, 04 Feb 2022 07:39:37 -0500
X-MC-Unique: i-0aqW5DMcaEtMWPiydZJA-1
Received: by mail-wm1-f70.google.com with SMTP id n22-20020a05600c3b9600b00352d3f6a850so1113092wms.3
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 04:39:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SdIzy7UM4kl6UKXLGR3KWInAe1rl2NNJmwxf0yuz4TA=;
        b=Lrg0Ek6IupkQFTect+jMk+I46+vflDQGc5uAm8lHqPN5KvDmxyd3TPlwCGMpOoMDsa
         YwPhqM1M+y/VRjPCYeX0miVYmYygVXEpji68Kz44L5ZvbUOPKGd+q6WL3vKpnjPvojQM
         nyZL32QLz/yEOB+4KPhGT2qy/xAMAZeQjej/2gUQucR9kKX1kXkj335ii/4k2C+7sZoD
         yJJpcp0NncEP29NLhB223qwU/Q85TqOARQ6m/+Ei8jP70OJj7I3U4uQbgS8B9YWW3OtQ
         +w9H9oZoQd6cTLnVt/4NGquqhR+w2Ljhdt9Fm6l9ZR/7mwBhAEX6+0Skvl8Iwcq7lPEr
         V5Qg==
X-Gm-Message-State: AOAM532JAV6z8azooq3/Ru/TQleFODAFsWeM1lwYioI+Jo3u6fJKEWyc
        ehwa1vx/nXqY7iOHiB9Sqkgtxya4K38aWuUu8qeLrhZaYQ5pJfePXLNhNcUrddilZOCrDdudbuA
        FsbWYfyxgrF6Q
X-Received: by 2002:a05:600c:3005:: with SMTP id j5mr2085526wmh.35.1643978376511;
        Fri, 04 Feb 2022 04:39:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqO9MmuK1szmxWl41FLMFsk1y1qSwj0C87lU69QJiEK1mnbbIu0I/oJm3BYNhLpKb2eA12/Q==
X-Received: by 2002:a05:600c:3005:: with SMTP id j5mr2085511wmh.35.1643978376286;
        Fri, 04 Feb 2022 04:39:36 -0800 (PST)
Received: from redhat.com ([2a10:8005:331d:0:5c51:c095:613e:277c])
        by smtp.gmail.com with ESMTPSA id j13sm1873062wrw.116.2022.02.04.04.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 04:39:34 -0800 (PST)
Date:   Fri, 4 Feb 2022 07:39:31 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     qemu-s390x@nongnu.org, alex.williamson@redhat.com,
        schnelle@linux.ibm.com, cohuck@redhat.com, thuth@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/9] s390x/pci: zPCI interpretation support
Message-ID: <20220204073806-mutt-send-email-mst@kernel.org>
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114203849.243657-1-mjrosato@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 03:38:40PM -0500, Matthew Rosato wrote:
> For QEMU, the majority of the work in enabling instruction interpretation
> is handled via new VFIO ioctls to SET the appropriate interpretation and
> interrupt forwarding modes, and to GET the function handle to use for
> interpretive execution.  
> 
> This series implements these new ioctls, as well as adding a new, optional
> 'intercept' parameter to zpci to request interpretation support not be used
> as well as an 'intassist' parameter to determine whether or not the
> firmware assist will be used for interrupt delivery or whether the host
> will be responsible for delivering all interrupts.
> 
> The ZPCI_INTERP CPU feature is added beginning with the z14 model to
> enable this support.
> 
> As a consequence of implementing zPCI interpretation, ISM devices now
> become eligible for passthrough (but only when zPCI interpretation is
> available).
> 
> >From the perspective of guest configuration, you passthrough zPCI devices
> in the same manner as before, with intepretation support being used by
> default if available in kernel+qemu.
> 
> Associated kernel series:
> https://lore.kernel.org/kvm/20220114203145.242984-1-mjrosato@linux.ibm.com/

I took a quick look and don't see much to object to, but
I don't know much about the topic either.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Pls use the s390 tree for this.

> Changes v1->v2:
> 
> - Update kernel headers sync                                                    
> - Drop some pre-req patches that are now merged                                 
> - Add some R-bs (Thanks!)                                                       
> - fence FEAT_ZPCI_INTERP for QEMU 6.2 and older (Christian)                     
> - switch from container_of to VFIO_PCI and drop asserts (Thomas)                
> - re-arrange g_autofree so we malloc at time of declaration (Thomas) 
> 
> Matthew Rosato (9):
>   Update linux headers
>   target/s390x: add zpci-interp to cpu models
>   fixup: force interp off for QEMU machine 6.2 and older
>   s390x/pci: enable for load/store intepretation
>   s390x/pci: don't fence interpreted devices without MSI-X
>   s390x/pci: enable adapter event notification for interpreted devices
>   s390x/pci: use I/O Address Translation assist when interpreting
>   s390x/pci: use dtsm provided from vfio capabilities for interpreted
>     devices
>   s390x/pci: let intercept devices have separate PCI groups
> 
>  hw/s390x/s390-pci-bus.c                       | 121 ++++++++++-
>  hw/s390x/s390-pci-inst.c                      | 168 ++++++++++++++-
>  hw/s390x/s390-pci-vfio.c                      | 204 +++++++++++++++++-
>  hw/s390x/s390-virtio-ccw.c                    |   1 +
>  include/hw/s390x/s390-pci-bus.h               |   8 +-
>  include/hw/s390x/s390-pci-inst.h              |   2 +-
>  include/hw/s390x/s390-pci-vfio.h              |  45 ++++
>  include/standard-headers/asm-x86/kvm_para.h   |   1 +
>  include/standard-headers/drm/drm_fourcc.h     |  11 +
>  include/standard-headers/linux/ethtool.h      |   1 +
>  include/standard-headers/linux/fuse.h         |  60 +++++-
>  include/standard-headers/linux/pci_regs.h     |   4 +
>  include/standard-headers/linux/virtio_iommu.h |   8 +-
>  linux-headers/asm-mips/unistd_n32.h           |   1 +
>  linux-headers/asm-mips/unistd_n64.h           |   1 +
>  linux-headers/asm-mips/unistd_o32.h           |   1 +
>  linux-headers/asm-powerpc/unistd_32.h         |   1 +
>  linux-headers/asm-powerpc/unistd_64.h         |   1 +
>  linux-headers/asm-s390/kvm.h                  |   1 +
>  linux-headers/asm-s390/unistd_32.h            |   1 +
>  linux-headers/asm-s390/unistd_64.h            |   1 +
>  linux-headers/linux/kvm.h                     |   1 +
>  linux-headers/linux/vfio.h                    |  22 ++
>  linux-headers/linux/vfio_zdev.h               |  51 +++++
>  target/s390x/cpu_features_def.h.inc           |   1 +
>  target/s390x/gen-features.c                   |   2 +
>  target/s390x/kvm/kvm.c                        |   1 +
>  27 files changed, 693 insertions(+), 27 deletions(-)
> 
> -- 
> 2.27.0

