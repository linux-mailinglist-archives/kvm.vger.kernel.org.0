Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131ED53F2B3
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 01:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiFFXpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 19:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234848AbiFFXpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 19:45:40 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE19C039C
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 16:45:38 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id o73so7131175qke.7
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 16:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7eRK9Jzco6zaNzKezRSe21QtwINuCVoa5KXsUQC3180=;
        b=jAX96k1SfIBELpO/UdAggYmzm0dmWWLs4cZGxrIiYnFWe9BunBdImD3qE8GX5/n5oS
         XCx/pwFQWFciiYl4z+k/bYiShg6+7bYd46TLVpcKqAV/kIMY3GwAk/gtb4ydf738iOPy
         coh732bxpVTleJJieq3gSkDgOl405aKGul1zSi/Yc+iyGBgb3W5EzPgSgYW1tWmI9sis
         Efyc9Ocfdj8n9hPJeLOeHaYPboTVJVoA7aZu6izJFJxfqJCMMREhWrXbTmoBoble+zA8
         p7JMHKmke/sKbHKTqw6HuH48Mq8ZhtHTheLgBXknvv53yCbIYAvg7TdJve9La6ZRWbua
         oJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7eRK9Jzco6zaNzKezRSe21QtwINuCVoa5KXsUQC3180=;
        b=cqPi9+BV49qpFxtj9Q0tSowolHbJqHAYNkS341TrD5NhPcgEDT2biPVXqZfoRze/mJ
         /K+m2IVnT7a6ASiN/Okd1PLMbQC33HcOYhH+vsrEsnVl8srtL3g+5W1kYDimIZPONVj4
         bcPHz3G5qenHljG9UN7zszyt/iPfXwgZKxjee0mDq5o1aVbLx4B3g9kDG7YkX5HkTao2
         F0a5qIN+LkLQcv/ZFnoEUGfNEuLuGUvWM84IfaeBdHpPm65RlQGsYAK9NagOdu8haNQs
         fC3my5arNSn42sTBH3dGoSVTYPFBRGam0fxLg0tAbhJoB2WKRkBE4MKkQ+zLlq+PEqTs
         z/PA==
X-Gm-Message-State: AOAM532Itu9y3/lIzu13Tcve2+rENPcE6v3wP2lGf4wZu+3JSpHRSeBt
        V6cjzeAopHooRCI6JOaMIe2G+w==
X-Google-Smtp-Source: ABdhPJxcfjZTvFvT18Z5mBZR5Sa0iKO+ftAmalw28pYUIVYuQcvulbwp+qhNES3flaj709o81mFsqg==
X-Received: by 2002:a37:2750:0:b0:6a6:9ee2:5f5c with SMTP id n77-20020a372750000000b006a69ee25f5cmr12669209qkn.558.1654559137777;
        Mon, 06 Jun 2022 16:45:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id s126-20020a375e84000000b0069fcc501851sm11986621qkb.78.2022.06.06.16.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 16:45:37 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nyMPg-002q1q-O1; Mon, 06 Jun 2022 20:45:36 -0300
Date:   Mon, 6 Jun 2022 20:45:36 -0300
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
Subject: Re: [PATCH 5/8] vfio/mdev: remove mdev_from_dev
Message-ID: <20220606234536.GF3932382@ziepe.ca>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603063328.3715-6-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 08:33:25AM +0200, Christoph Hellwig wrote:
> Just open code it in the only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/mdev/mdev_core.c | 6 ++----
>  include/linux/mdev.h          | 4 ----
>  2 files changed, 2 insertions(+), 8 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
