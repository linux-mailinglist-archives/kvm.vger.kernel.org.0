Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408E353F2B7
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 01:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbiFFXqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 19:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiFFXqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 19:46:12 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71740C039C
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 16:46:11 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id br33so10366138qkb.0
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 16:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F3hOH9RA5JoblI2pxUlcLp6jn6iFgdYtxKJdEXArLz8=;
        b=H4hdQBXcoHuewS6bMmzTaq4Gi46SWkQGuA+7UxvO61phStKl3JgqnymllrkMmhexSP
         dLWLsx3WY0TdjatRyvhQoRXXax2GfIDXfrFQwQ+jlZwwk4ewAKjtmikJRqr4MMOKwpQh
         +ooX9uHqlT4o1HAJ/XreaoYzR0uC67Hi+rLGCgt7+kskip/KVVuAB1HFaptGPaj4fh7C
         e6ngIUJIIOaFVhWkjQQB4UKzxypeniGWdibGtKORusraOMk42575Og1/cAFZKn3cJ/ys
         FINhuHpisIRcMnxUJjsOoT2Jxo1H86pe4P1ZB6rp/lSPDNDJhxff9ViRq1na/nZTlz8a
         a2lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F3hOH9RA5JoblI2pxUlcLp6jn6iFgdYtxKJdEXArLz8=;
        b=Jk0V5/M/RBdWgo5+51FoI/dYWdk93fnqQzc3bZOrvq0B7RxZ9MrWQiFWYiDuP5xwHR
         a6HfhT2rb4EMMUXbonwSiaEcz5a7L3r2Lw/ganeC1AvqZvW+9UAe+qMTMhWmP4w0qP7k
         6JZxZ3aUxpVGDT1YCpYzo+kqxoF2bDrDnVrto5rt5KjFREZK3SurM8ETdjlyVOoPc4K/
         1wPV0c6OP2Bcf+TmsGCbUHcqmZMKoKVSDqRzM2CM34RnQmnsdK17ZMBmBPOviUFxSuYR
         8ICq7F6uRa9mPCJVdFfzufLri9zxMaFYx1KcZH/SbIx/VniL6yzn0IU7qiHHWGqW7FzR
         b9mw==
X-Gm-Message-State: AOAM532V4lucCAInuir22s9me/BAnpvQFRxSlcLjYr6bz0nT/ZK37TcC
        D/jHGAxGJ5N6PAvHx0w2r2ITDA==
X-Google-Smtp-Source: ABdhPJz7BqWVlzqnzkNXKYLIBTQBhbYjjkh0W7sn7nsw4vknSF/ZFvjraLVZBw3KVNYyzDf0OrFGDQ==
X-Received: by 2002:a05:620a:298c:b0:6a0:94d2:2e39 with SMTP id r12-20020a05620a298c00b006a094d22e39mr18203085qkp.278.1654559170649;
        Mon, 06 Jun 2022 16:46:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id 10-20020ac8570a000000b00304e5839734sm6340649qtw.55.2022.06.06.16.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 16:46:10 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nyMQD-002q2l-Lj; Mon, 06 Jun 2022 20:46:09 -0300
Date:   Mon, 6 Jun 2022 20:46:09 -0300
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
Subject: Re: [PATCH 6/8] vfio/mdev: unexport mdev_bus_type
Message-ID: <20220606234609.GG3932382@ziepe.ca>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603063328.3715-7-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 08:33:26AM +0200, Christoph Hellwig wrote:
> mdev_bus_type is only used in mdev.ko now, so unexport it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/mdev/mdev_driver.c  | 1 -
>  drivers/vfio/mdev/mdev_private.h | 1 +
>  include/linux/mdev.h             | 2 --
>  3 files changed, 1 insertion(+), 3 deletions(-)

Yay, people trying to sneak in tests of this bus type in platform code
has been a problem in the past

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
