Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483E2562395
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 21:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbiF3Twj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 15:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236790AbiF3Twg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 15:52:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7630E443F8
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656618754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ExCLRUTepyP4PJv4nv3WQINVvpNQ2mK6jdr2kPhXUFc=;
        b=OVjKbs6bGKNFQ9FmVxmBYcI9uEiDB9+r2OCQjhakaQxhfOHCxA4TO/HBClrBh5tBW0+636
        Tff15kDZzCJTZ/P7kBP7q7eBSwQAflWDWENaRf4cipJhkj6SBTgWgllwyK/I/8UyTJs99g
        AEk9UxfsXxmC6OavOXZc5DmZmVUZqtM=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-iY9DFG9EMp2RIkAkiUHZJw-1; Thu, 30 Jun 2022 15:52:33 -0400
X-MC-Unique: iY9DFG9EMp2RIkAkiUHZJw-1
Received: by mail-io1-f69.google.com with SMTP id c8-20020a056602334800b0067500ca88aaso145060ioz.0
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ExCLRUTepyP4PJv4nv3WQINVvpNQ2mK6jdr2kPhXUFc=;
        b=prqgqtpbYLHKg0uVJywRmQe1qjnHpunqI6dJL0+MbRxt3xp58CMNYW+SiBdw05+jha
         l8m5QKBeiOLPepx3vyoy3RVFNei+yEDHU1Rj6Bt9LjQ+kWo0g1wCNLSmxsvy5YXU+mu3
         HFS//jSiFJFBFCtUt/2yL8gOA6/VQd6xlVRyk4UFch5807ySr1VZUNUAKu0Vo5p0LAQQ
         zHgSIpUjTtJX+MwHL+nxNXOUwz5rG4O1WHszo5DZEAiP7/VyUps8A6Xp7MdlCnuG6KMK
         xLcG+dzt83s07XCkZhWAQ7HfomMxA0OVdxGAkRB2jVH9lfuZncj+40jv2G3nG4O0qeqT
         8G4g==
X-Gm-Message-State: AJIora8ogLUHviMbGto8WGyskE9O/CQtolbxUniRvJ499MF84mKoFDUG
        IPZ4RBWmt1w+n0JX9zfx3vzWZxYCpPkOkiskqkad6v4mwun/B45VOfZg6RwgVMLM3NxAvHRIH5B
        huIJ6PaqU7IHU
X-Received: by 2002:a05:6638:1a8d:b0:33c:9a98:ff2d with SMTP id ce13-20020a0566381a8d00b0033c9a98ff2dmr6701516jab.31.1656618752626;
        Thu, 30 Jun 2022 12:52:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vV3dSvtdAEongR8ZorbRwm1TM07AxbSckZ7zfr5UPRFS8Cn4Wkuiy4T4xypOywlTXPfamwEA==
X-Received: by 2002:a05:6638:1a8d:b0:33c:9a98:ff2d with SMTP id ce13-20020a0566381a8d00b0033c9a98ff2dmr6701505jab.31.1656618752455;
        Thu, 30 Jun 2022 12:52:32 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x42-20020a0294ad000000b00330c5581c03sm8880286jah.1.2022.06.30.12.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 12:52:31 -0700 (PDT)
Date:   Thu, 30 Jun 2022 13:51:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liam Ni <zhiguangni01@gmail.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: check iommu_group_set_name() return value
Message-ID: <20220630135141.4fd4c4d5.alex.williamson@redhat.com>
In-Reply-To: <20220625114239.9301-1-zhiguangni01@gmail.com>
References: <20220625114239.9301-1-zhiguangni01@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 25 Jun 2022 19:42:39 +0800
Liam Ni <zhiguangni01@gmail.com> wrote:

> As iommu_group_set_name() can fail,we should check the return value.
> 
> Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
> ---
>  drivers/vfio/vfio.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied to vfio next branch for v5.20.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..ca823eeac237 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -504,7 +504,9 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
>  	if (IS_ERR(iommu_group))
>  		return ERR_CAST(iommu_group);
>  
> -	iommu_group_set_name(iommu_group, "vfio-noiommu");
> +	ret = iommu_group_set_name(iommu_group, "vfio-noiommu");
> +	if (ret)
> +		goto out_put_group;
>  	ret = iommu_group_add_device(iommu_group, dev);
>  	if (ret)
>  		goto out_put_group;

