Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA21645F8C
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 18:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiLGRAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 12:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiLGRAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 12:00:24 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB9C68C6E
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 09:00:24 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id i12so13067974qvs.2
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 09:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bMJWa4BhNLGgieoEqbDLRoe8g9LSSuFzkTabKvVomJQ=;
        b=KmMAeqnvR+wYfK6n0HtxUFK8m+0Q/sY8QDrjrqtvA5/xBtQ9oaBGX823QH9xvLXLq0
         4sLFp1NGtf5ViZrFB3OQ7gBTpziLIBqFoO3vBenLmzlgXRl1x4XEe1YW6lc4SMXKbGmB
         mhfT5ayD2AJNnSzRgycB303D8R+4yfzpAyy7Ni/En/KQDU+mpXQ8IId8b7kQfWHsJMN8
         OPn2dRHv+eJjJQyN9eZKjiFVLbxvxfDZou0MSfR0sRT5s0ROiRmLcB2ekWf8Hihoybse
         QIB2ncLbuZ1bj1c9fbE0aN1Fh1aRsZFgd/U/mBuEw+gNgerRuYjpYc6b039BZWnWXxsR
         QWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bMJWa4BhNLGgieoEqbDLRoe8g9LSSuFzkTabKvVomJQ=;
        b=dL/XZuW5N5Y0oK5jmNWoPhgPdYN1N3nKsp0r7gQzpWdBcDomewsNdBcuXkCKo0XUVf
         IGx69F12pMdWFSV2fyoKXamHb3rZsLt5ptwUmtaORlaQ8+k7p2+BvvL09ZHr88KrdVNL
         hguo72j7JnywjzOJMbBaLlnswygCTwdB5dNZELbGa7JFq6KKkgCsVfBPAt6pTM5aGUUX
         +ZuvHf7Dkipy/LE3bnngOk6l1m/NwJljIAYTzW34LdEsq8y5VUdJWDLFdUBmd+ndLCQ1
         DEyIUmqDCboI19IWoFdEymvYLdN7nw8wIY4aVcKIHjrIpZwMFJoyVfLwCMK0Cf9rvZb1
         I8rw==
X-Gm-Message-State: ANoB5pkLbH4YsmV6OB0G4EGNl8FIxApLyNRawzZ+4AoDKTak/GSoE93I
        2xk/+wsTRT6o4exPNSuRTNqDvQiMvAFq2rwY
X-Google-Smtp-Source: AA0mqf4BjY3rgtwSESRRUiYWxktjvvCWp27Ab0Iw9FmUyoYE9+fQMiT77crLI/UW3sb9FdT7shb5JA==
X-Received: by 2002:a05:6214:1187:b0:4c7:6648:a2c4 with SMTP id t7-20020a056214118700b004c76648a2c4mr12728337qvv.12.1670432423183;
        Wed, 07 Dec 2022 09:00:23 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id a22-20020ac85b96000000b0039a08c0a594sm14005962qta.82.2022.12.07.09.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 09:00:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2xmQ-005HmX-2i;
        Wed, 07 Dec 2022 13:00:22 -0400
Date:   Wed, 7 Dec 2022 13:00:22 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 8/8] vfio/type1: change dma owner
Message-ID: <Y5DGpqxHJpl7doyN@ziepe.ca>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-9-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670363753-249738-9-git-send-email-steven.sistare@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 01:55:53PM -0800, Steve Sistare wrote:
> Implement VFIO_CHANGE_DMA_OWNER in the type1 iommu.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 119 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 119 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index fbea2b5..55ba1e7 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1509,6 +1509,112 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
>  	return list_empty(iova);
>  }
>  
> +/*
> + * Return true if mm1 vaddr1 maps the same memory object as mm2 vaddr2.
> + * This does not prevent other tasks from concurrently modifying mappings
> + * and invalidating this test, but that would be an application bug.
> + */

And so the only reason to do this is to help 'self test' quemu that it
isn't doing something wrong, because it obviously doesn't protect the
kernel from security issues/etc.

I probably would not bother, but if you do it then it should be an
option to spend these cycles and debugged qemu can avoid it..

Jason
