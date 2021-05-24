Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D096038F3DA
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 21:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhEXTvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 15:51:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232107AbhEXTvP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 15:51:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621885786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ks2ewGQDMjkPlSXbPudMhSXdnsqWMPCcsnAWLRBS1E=;
        b=CkTVlvIKtt0IH91Iz0vblkfjLI8KJHGOr0BmkHryUoeuOd8eti9OkhYowpjXcPZEUMZ17W
        n7/mCZpA4qB05+40RpS3Pw4sxKZwwQx63egBWkUoTTC6hM5qKjAweMRNtA3XGlqb0gkF/S
        +Nv/lU8fT/6mgKOxAzfjQgEV76T1iqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-oba3XaYtNWq1VGhUF2Fz9w-1; Mon, 24 May 2021 15:49:44 -0400
X-MC-Unique: oba3XaYtNWq1VGhUF2Fz9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CACD107ACC7;
        Mon, 24 May 2021 19:49:43 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72678E14D;
        Mon, 24 May 2021 19:49:39 +0000 (UTC)
Date:   Mon, 24 May 2021 13:49:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <kvm@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next v2] samples: vfio-mdev: fix error handing in
 mdpy_fb_probe()
Message-ID: <20210524134938.0d736615@x1.home.shazbot.org>
In-Reply-To: <20210520133641.1421378-1-weiyongjun1@huawei.com>
References: <20210520133641.1421378-1-weiyongjun1@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 May 2021 13:36:41 +0000
Wei Yongjun <weiyongjun1@huawei.com> wrote:

> Fix to return a negative error code from the framebuffer_alloc() error
> handling case instead of 0, also release regions in some error handing
> cases.
> 
> Fixes: cacade1946a4 ("sample: vfio mdev display - guest driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
> v1 -> v2: add missing regions release.
> ---
>  samples/vfio-mdev/mdpy-fb.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
> index 21dbf63d6e41..9ec93d90e8a5 100644
> --- a/samples/vfio-mdev/mdpy-fb.c
> +++ b/samples/vfio-mdev/mdpy-fb.c
> @@ -117,22 +117,27 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
>  	if (format != DRM_FORMAT_XRGB8888) {
>  		pci_err(pdev, "format mismatch (0x%x != 0x%x)\n",
>  			format, DRM_FORMAT_XRGB8888);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto err_release_regions;
>  	}
>  	if (width < 100	 || width > 10000) {
>  		pci_err(pdev, "width (%d) out of range\n", width);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto err_release_regions;
>  	}
>  	if (height < 100 || height > 10000) {
>  		pci_err(pdev, "height (%d) out of range\n", height);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto err_release_regions;
>  	}
>  	pci_info(pdev, "mdpy found: %dx%d framebuffer\n",
>  		 width, height);
>  
>  	info = framebuffer_alloc(sizeof(struct mdpy_fb_par), &pdev->dev);
> -	if (!info)
> +	if (!info) {
> +		ret = -ENOMEM;
>  		goto err_release_regions;
> +	}
>  	pci_set_drvdata(pdev, info);
>  	par = info->par;
>  
> 

Thanks for adding the extra error cases.  Applied to vfio for-linus
branch for v5.13.  Thanks,

Alex

