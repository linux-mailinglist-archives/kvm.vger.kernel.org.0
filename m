Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECA13F7E9D
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhHYWcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhHYWcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:32:06 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08836C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:31:20 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id f22so1215171qkm.5
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bUAXoLkrHX/37iaSaxMoxr3Vodjakrcmk+fLSY4azrg=;
        b=UFdqDNgvmWAizF8GEu3jhzrUNiJMfz4azYjbjauvoGfSi+2wiwv/WODyfI+ejhyY5i
         eaCQKppY/ikhhs8rzRhP2DrHpCMIlpOwoblEhIcoccQkgYwWZAmojzn+lZLIraXr+WMr
         fJpXRs0vqYbmsZNrnjTHjz5eDlJ/I2S2uyLByjSgHlsI6mHLDP3Y4uJQnI1Ik6Y6bztt
         SVLmj7W5MpqD0myv8bCAup5RNMrZbp2ivTbAFAJoDj8S4aqoYoUzsRhfD4qPj2B7lfdC
         Sm6oZ0ljpW+GuicpcdYTYjRWusRMQsnHxhPopDc+Pd5IOW+Mr5VTHwWWGb2tiNP1KiIb
         6zNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bUAXoLkrHX/37iaSaxMoxr3Vodjakrcmk+fLSY4azrg=;
        b=ZXquAT3b5sOWJjD1/f6OlRNrxNNKrkyXMbOOM0lSc+bwvq5HlUNswEfggzrFJyEsVP
         rHzvM7Kvn+JFXMV8EUuCfWSEsNVIYsNP5RptEWkrgt+POSiTgHgYX1ri6+uXbbO3TnOM
         XUM8inoORKcqR7BksMUKgB7cTjN81tuWmioq9YkRh0BnCI6GWQT4Qi2bV6jzLr6vRWaX
         bfcpBlecebId/05RYVO1jm/3KgrQWlmP/twmKhXk7B773rGP/MFGEfWMKbUuK0531cSy
         yXhOwtEqwjpli1QyU0iSpWR16JAoTstVw1NHP3YedVfYgKqYGLt5J2fqltq+kl4KyZyG
         dfSQ==
X-Gm-Message-State: AOAM532NOP3ST4UOLfFLi8oB6pR2VAL+bsaKz5VxbIxD+D0Keir8AD/o
        bzL9g+Dohh9XWe/OvPZsS3PJhrhRji7Mcw==
X-Google-Smtp-Source: ABdhPJwiAnKSaHGSWegqHsPA+J4nG3MaebyQPsePD/IyR0zh5g159W8K6FDAuaZ5pHmyzJUqgPZ3oA==
X-Received: by 2002:a05:620a:209b:: with SMTP id e27mr863101qka.133.1629930679086;
        Wed, 25 Aug 2021 15:31:19 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id v15sm711299qta.82.2021.08.25.15.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 15:31:18 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mJ1QT-0057Pi-SX; Wed, 25 Aug 2021 19:31:17 -0300
Date:   Wed, 25 Aug 2021 19:31:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Message-ID: <20210825223117.GB1200268@ziepe.ca>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825161916.50393-8-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 06:19:08PM +0200, Christoph Hellwig wrote:
> Reuse the logic in vfio_noiommu_group_alloc to allocate a fake
> single-device iommu group for mediated devices.  A new function is
> exposed to create vfio_device for this emulated case and the noiommu
> boolean field in struct vfio_group is replaced with a set of flags so
> that devices with an emulated IOMMU can be distinguished from those
> with no IOMMU at all.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/mdev/mdev_driver.c | 46 ++--------------------
>  drivers/vfio/mdev/vfio_mdev.c   |  2 +-
>  drivers/vfio/vfio.c             | 70 +++++++++++++++++++++------------
>  include/linux/vfio.h            |  1 +
>  samples/vfio-mdev/mbochs.c      |  2 +-
>  samples/vfio-mdev/mdpy.c        |  2 +-
>  samples/vfio-mdev/mtty.c        |  2 +-
>  7 files changed, 53 insertions(+), 72 deletions(-)

This conflicts with the AP mdev conversion, it will need to change to
vfio_register_emulated_iommu_dev() like the samples did. Alex, I suggest
you take this patch after the AP mdev patch and add the one line fix up.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
