Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A7D3892E7
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 17:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354973AbhESPqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 11:46:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348197AbhESPqo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 11:46:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621439124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tJhhAB5BAUKw2eGpq2+2/VViXgOiLGOuvkZG3xj1vTw=;
        b=XgAYnzsUctmnnYvShszSmFcJXF8a7XGee/ZsIteyTE8veOWYjYNGy4+DBsxA9Lm7w3ZWG5
        fhSOn1ZhDviT1zmCcOINw5qxYmtAx5TU1K85tY+bxBYPeQP6sRB/Qx/gcgWfrDxAuhd6ZZ
        CLkbMMf8kFfdky3kqMD6bdJf8tXFG2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-Gzs1CZxJM5uB2kFoU4Qm4Q-1; Wed, 19 May 2021 11:45:21 -0400
X-MC-Unique: Gzs1CZxJM5uB2kFoU4Qm4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A998D107ACE3;
        Wed, 19 May 2021 15:45:19 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 631295C261;
        Wed, 19 May 2021 15:45:13 +0000 (UTC)
Date:   Wed, 19 May 2021 09:45:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>,
        kraxel@redhat.com
Subject: Re: [PATCH -next] samples: vfio-mdev: fix error return code in
 mdpy_fb_probe()
Message-ID: <20210519094512.7ed3ea0f.alex.williamson@redhat.com>
In-Reply-To: <20210519141559.3031063-1-weiyongjun1@huawei.com>
References: <20210519141559.3031063-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 May 2021 14:15:59 +0000
Wei Yongjun <weiyongjun1@huawei.com> wrote:

> Fix to return negative error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  samples/vfio-mdev/mdpy-fb.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
> index 21dbf63d6e41..d4abc0594dbd 100644
> --- a/samples/vfio-mdev/mdpy-fb.c
> +++ b/samples/vfio-mdev/mdpy-fb.c
> @@ -131,8 +131,10 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
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

I think there's also a question of why the three 'return -EINVAL;' exit
paths between here and the prior call to pci_request_regions() don't
also take this goto.  Thanks,

Alex

