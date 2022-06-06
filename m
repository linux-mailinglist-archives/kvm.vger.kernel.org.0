Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6BD53F2BB
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 01:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbiFFXqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 19:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiFFXq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 19:46:28 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318AEC03AE
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 16:46:28 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id o68so12081818qkf.13
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 16:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BobLl+SlFstwFdCAgot2j19OhmEJmjKMcmrAyX++IpQ=;
        b=nTfkLS746hnRkFmQz8zZo7fxRpg63kXstyT8r7gW9PDX8jfk8n9wPYN+FQ0XgmC9fz
         nii/p1w15omesttBp8810sHQEh+P+NwdH+lOHKg2lWA3f2I8rz+/LiPoLfY9Uf3zExmn
         lZvIKLet/yrIs+LRJwbHr5A1+ceMHQeE50rVoUBTkrXSrBNNMbtbnb9Nvh3bdrFCuqce
         GrOxC1ZVY9FnqjAoPe7//ERX/vTKxps9R4em/RHDci4XEK17vekdDuvS/NZ2BAnQli9z
         Q3lznZLbcnaaLSm+/994C56wGWaJJmwTkCqSGQ7EQ/olGImF4gaBV85YzOVtWO4suYRA
         k0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BobLl+SlFstwFdCAgot2j19OhmEJmjKMcmrAyX++IpQ=;
        b=hha0o90fRLmNG1wI3PGh1w7fjGGJ63ccev/TbebrDgpSs+37eIo0R7yDNkLcpG0wS+
         ak0wJdEIFlqinu8FKo4nEhBDRxRkGJVPSVpPqspIjraPa9aTJOHYwiHsN7LOMF13OJDl
         dVVc6BAeVLTBvnR1isIp6jDf2x7kzorNBk5gxKmGf1IE6p7fV2DRs9CpFSCb73DucckI
         bjWY+C2sh5PyD65JjjoYLz5aEPcbkp7qvWmzQzK6ivyKAxEiXZK7FblUcnQW/OxoEIoR
         KKL+1GfU6wn89QoXLTgGX78WhV/bXiYVLGF7vDqOF9NtKGusgkfiVNzdTYmMm3/eLmy8
         zqiw==
X-Gm-Message-State: AOAM533G3aiFPluh9jZt/GcaeyuuMQQYP0RWC2/MIVWmSd6CO70EZHY5
        yczRWtFWVXkyQeFrSuwCfyMNiA==
X-Google-Smtp-Source: ABdhPJxdw6L/xOuwADspsqstoD5nz7gt8vQH/za9tZhkeo/mqgj+nrGe6IzJ+9V9rqmxQ7fk9+5a4w==
X-Received: by 2002:ae9:eb88:0:b0:6a6:b3e3:4c44 with SMTP id b130-20020ae9eb88000000b006a6b3e34c44mr6995123qkg.83.1654559187889;
        Mon, 06 Jun 2022 16:46:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id g16-20020ac85810000000b002f906fc8530sm2525617qtg.46.2022.06.06.16.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 16:46:27 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nyMQU-002q3M-Lz; Mon, 06 Jun 2022 20:46:26 -0300
Date:   Mon, 6 Jun 2022 20:46:26 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 7/8] vfio/mdev: remove mdev_parent_dev
Message-ID: <20220606234626.GH3932382@ziepe.ca>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603063328.3715-8-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 08:33:27AM +0200, Christoph Hellwig wrote:
> Just open code the dereferences in the only user.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/driver-api/vfio-mediated-device.rst | 3 ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c                  | 2 +-
>  drivers/vfio/mdev/mdev_core.c                     | 6 ------
>  include/linux/mdev.h                              | 1 -
>  4 files changed, 1 insertion(+), 11 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
