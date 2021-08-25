Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1163F7E91
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhHYW11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbhHYW11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:27:27 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFE5C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:40 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id r21so831469qtw.11
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i2eQNF0OstqrHCD0xDuzAKu18Rus+F7/SNZBetPBi6Y=;
        b=At8OZqtkpT2a+ibzjHt+U9UGqAy6SW3VFjqQfPifUXC1784UYNE6iRKN1aRl9cZcPQ
         3wpSvNVWdUOSGCVMNrvmufLFEtvJG5YM9l/6xTXol27YjxEWTka/kVlo0+GI7+4z89Ra
         SjGIZ0SFLzsEfZW7UrGCmvfTfj6QQbYEh1uMghP4Tjyjai0Gf1xZNf+aq14HbeYJDsCb
         hbmhcZtKZFaW/tFVWiwDGeud0jgRXebn4ZhizZSrv71esrRTNbqWDkLkT0WiwwxzTKQy
         ge46DMo6nVwyrm/LDpc5iC0VdTWGEqpVVI/v/Vho8XrRcPuqs/Lz5DQwRx8zMd8/ABVE
         TvwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i2eQNF0OstqrHCD0xDuzAKu18Rus+F7/SNZBetPBi6Y=;
        b=DRrshccF25J/q2ajHvWyL3mAAWf1m83iyI/4mEhDmg55jaP9RuPyhrwpUnVZnbfdTl
         NqZ00x+BNlh3WR6tci12G1FZCIdQCz6FnYLTsFgIbWr3bZFE2YUQ717xBdeVzfeAL7qD
         D7DdJf9bSNCrfX9g/FwgmWMm+T57/3ITIW+6sgWDkAfSrz/ILsz4gLvyLqu2O1nwSaDH
         EeVPf8pYplCsuRMs8HpDKEJKTx20qZWCar0R+D12jKaKcsLVgxmZYIwkuP+CF1x+Fkv+
         FFfFBuLGyipfe2g/vNVE5OK8NEOzroW36ts8px9cuoqZ0q5cHWm2NO3XeZ4w5q3GNcSW
         mgOQ==
X-Gm-Message-State: AOAM532nO11p7jab3/JoRw5CmD9XWwSRAdxDwblnEHRm06jyywhhB5Oz
        ni69hCGkHlnmlU7f54bhKswFUg==
X-Google-Smtp-Source: ABdhPJyB80+q0muMvaKJc8KhIMzx/osAKjV2yPeHzI7r1wpDw/2driiMSmMXuIeYTlIUqiV0B2KpzA==
X-Received: by 2002:a05:622a:488:: with SMTP id p8mr528973qtx.159.1629930400053;
        Wed, 25 Aug 2021 15:26:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id e10sm1063728qkg.18.2021.08.25.15.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 15:26:39 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mJ1Ly-0057Lg-PX; Wed, 25 Aug 2021 19:26:38 -0300
Date:   Wed, 25 Aug 2021 19:26:38 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Message-ID: <20210825222638.GA1200268@ziepe.ca>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825161916.50393-5-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 06:19:05PM +0200, Christoph Hellwig wrote:
> Factor out a helper to find or allocate the vfio_group to reduce the
> spagetthi code in vfio_register_group_dev a little.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio.c | 51 ++++++++++++++++++++++++++-------------------
>  1 file changed, 30 insertions(+), 21 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
