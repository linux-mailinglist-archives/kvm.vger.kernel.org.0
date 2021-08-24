Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432C63F6C2C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 01:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhHXXZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 19:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHXXZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 19:25:15 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17699C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:24:31 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id b64so11314866qkg.0
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fwoh2tmLORG6oex5De56LuB1cf8kFT7rQjBycMt9ue0=;
        b=nqvRuEzKi14UFx0k6oyIgTDmc/HpoxtTwrW688gJRAiFEJWbAdOa8VnCVUwfO1Hw3Y
         mnTvq7RfY1sfPxPTwRdBAMmkMI6dGQ3aV1SacdHNDLy7cmoa3i58M9pOZ3Ib8vCz6Mpt
         f1rC+4RH0y/SvzKjxW5OmZIKhc40y1IDzYXH4Qu6H9f5khag19FvvU8N0IT8XhuCglwS
         Mlr2Sncb+uTBHE6RmRKJjFK5mZ+UZxxQZp+w2mqmtha5UyRqYT7n7sqVKV3pm/SbasBi
         DuR9ua6SH4Ig/oCmPDuzH5SYLm3IlQYJELd5xGOOU47jErn2540P+pGJ6PbF3aRoU9Xs
         5DNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fwoh2tmLORG6oex5De56LuB1cf8kFT7rQjBycMt9ue0=;
        b=W8NYCJ4TWg0H8fHyfDaF73R8f8Ajmp9LR8IVavAHRoSBR3xox+RGXXj8ESsxEnoZ2z
         Cu0VBYI/C55oYWpA8peq6VDciHwABvPmlAlrd75L8xoVbu50A4472NSSs1vqGtphL+BI
         AokMV7SRsz5K8K1+jyZ1jkQ3LdL11ZBWsoZFu4mwWfEEl7GWys/16hP3eUFvwcPHFpEn
         7taLv35EQ+n4EhIve7Dqd1wWGyMBrxqlRcGq2qbHx3yFvOBdq34sUhN0fiLLT6x+/aSa
         adp+fw0lM2GBO/uzvmNrM0ue2mKBuxW7XaU48lRgfB3o5wCJy8e4MgMKTn3RXvNeZL/q
         3New==
X-Gm-Message-State: AOAM532NoVgLj1IcHoc+NJlTsFubQFhWJy2dbB7RmDH0C52fm823zGtE
        grTBxQdNj4HAL2lxY/f9dfCSjQ==
X-Google-Smtp-Source: ABdhPJzVUUUgrD/NwLqbnn2sZq/66A1HL6X1vw9iGbCr9L3mtaKgXkfTfeLxXhqATMlCYik1OcuqSg==
X-Received: by 2002:a05:620a:4482:: with SMTP id x2mr13028645qkp.474.1629847470277;
        Tue, 24 Aug 2021 16:24:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id o63sm11968229qkf.4.2021.08.24.16.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 16:24:29 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIfmP-004hOS-2H; Tue, 24 Aug 2021 20:24:29 -0300
Date:   Tue, 24 Aug 2021 20:24:29 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 02/14] vfio: factor out a vfio_iommu_driver_allowed helper
Message-ID: <20210824232429.GI543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-3-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:37PM +0200, Christoph Hellwig wrote:
> Factor out a little helper to make the checks for the noiommu driver less
> ugly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio.c | 33 +++++++++++++++++++--------------
>  1 file changed, 19 insertions(+), 14 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
