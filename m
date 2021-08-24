Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9633F6C50
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 01:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhHXXpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 19:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHXXpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 19:45:47 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E27FC061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:45:02 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id a10so16327350qka.12
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nPISlNnlijRS7NGI6x3M1PPe4bWd9ZSJLM/30kpeaB0=;
        b=Qbw6WJ01jaIYd91ayRmU/BWJkssM8zGdkK0Afw02PCSZr1lhWCTgEBw466Mx6Ns7zQ
         CW7yGY/PY8TubTNkr9krq3BTj+h9PL3Q/HSrUZc6fXlfYnWiYZcvoWthDMcPiopP8CkD
         6vhOvwJL5wSRio3RbW+vtahQeRS9wHIpENsMFj++tkz374r8oQIoem5WkWPG8G8m6lJh
         Oii8VkRBdmFVKRwjVNeeDKUztcZUrDlrklTznylVWD3gwRj400PI9S754FJRCF7He09O
         jpW2OhqbnjYJHO3cXPfVBZq06Axx6cYxsxUInwiyI5jIVI9jLI9E2MCHiaRmCduhyo1K
         ++Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nPISlNnlijRS7NGI6x3M1PPe4bWd9ZSJLM/30kpeaB0=;
        b=NSadqWTIQkaMXFQmQbdsKNlTTvA2L+WIMabFmSNptNjsm1TvqxMAqY2qGr3pcqZIho
         rs1fWI8tv16FiY/XtvTdW2Tepakx/jYJsrqT1r1wMqzed7I5EHgQDuMohiJJfKuaGNZ0
         6uMPYCcF4syAAAaJGmlsU+IwgRiKihoGcbpRcu1Xhg4V1T+AUY1OF2RWEX/xjzv6h/i9
         lTEqw+TQa1NQacxGSku5Ohv6hbnbqGb+Fynr0Jh5t10ZF6GnY1HKqsNDMJJhNThTDI94
         cXUorGClTrgEk/55GrjGVgx0ovQ2LKMPBeBmp2lpQnxh4ozTIr9bz5iphoU/2/xevl2p
         Hw2Q==
X-Gm-Message-State: AOAM531e0GVH81RiRZZY+4AXyi/NCprpYSUL10ViBfjjcEu9aigmbKL/
        7f6j4UJrTzfbnk2TOdwwCpcutQ==
X-Google-Smtp-Source: ABdhPJzmGMnmWYw3eKFis9TTi7p3t5HAJUBsGVSXkPKfaaSiOswmaljly0DMHjlBfNcFaOrhVAa8Jw==
X-Received: by 2002:a37:e10c:: with SMTP id c12mr28760125qkm.199.1629848701495;
        Tue, 24 Aug 2021 16:45:01 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id k9sm9079705qtj.12.2021.08.24.16.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 16:45:01 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIg6G-004iVa-Gg; Tue, 24 Aug 2021 20:45:00 -0300
Date:   Tue, 24 Aug 2021 20:45:00 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 06/14] vfio: remove the iommudata hack for noiommu groups
Message-ID: <20210824234500.GM543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-7-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:41PM +0200, Christoph Hellwig wrote:
> Just pass a noiommu argument to vfio_create_group and set up the
> ->noiommu flag directly, and remove the now superflous
> vfio_iommu_group_put helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio.c | 30 +++++++++++-------------------
>  1 file changed, 11 insertions(+), 19 deletions(-)

I like this a lot better

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
