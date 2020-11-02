Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E400F2A26AB
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 10:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgKBJIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 04:08:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728253AbgKBJIk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Nov 2020 04:08:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604308119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wqQDewon3xyOBfSNA03WJK4hV8rf86zjSQDT6TMNUw4=;
        b=eBnxxw2xfWdHCzIHD45qO0SQWOJKtsXQDGp5pUSgZtxX0xAGBf4DHxyPjeci0GbySexZmz
        DcUy2JyUpfEF9Or3Z6NkyFzSy1fKGsz5aBL4TKT4acKugYq2f4BhN7S+6ZPr/2TblfYMi8
        YQbRBG4OYdU7WddjDYB3dModN5Fee/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-N8Lzk3rRMLi4azEjNb4rgg-1; Mon, 02 Nov 2020 04:08:37 -0500
X-MC-Unique: N8Lzk3rRMLi4azEjNb4rgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3C39186DD28;
        Mon,  2 Nov 2020 09:08:36 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AEAD15C5B0;
        Mon,  2 Nov 2020 09:08:31 +0000 (UTC)
Subject: Re: [PATCH v2] vfio: platform: fix reference leak in
 vfio_platform_open
To:     Zhang Qilong <zhangqilong3@huawei.com>, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org
References: <20201031030353.9699-1-zhangqilong3@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a1ece9aa-9f78-f0f5-0cbc-0a176f387d24@redhat.com>
Date:   Mon, 2 Nov 2020 10:08:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201031030353.9699-1-zhangqilong3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhang,

On 10/31/20 4:03 AM, Zhang Qilong wrote:
> pm_runtime_get_sync() will increment pm usage counter even it
> failed. Forgetting to call pm_runtime_put will result in
> reference leak in vfio_platform_open, so we should fix it.
> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Looks good to me,

Acked-by: Eric Auger <eric.auger@redhat.com>

Thank you for the fix

Eric

> ---
>  drivers/vfio/platform/vfio_platform_common.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index c0771a9567fb..fb4b385191f2 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -267,7 +267,7 @@ static int vfio_platform_open(void *device_data)
>  
>  		ret = pm_runtime_get_sync(vdev->device);
>  		if (ret < 0)
> -			goto err_pm;
> +			goto err_rst;
>  
>  		ret = vfio_platform_call_reset(vdev, &extra_dbg);
>  		if (ret && vdev->reset_required) {
> @@ -284,7 +284,6 @@ static int vfio_platform_open(void *device_data)
>  
>  err_rst:
>  	pm_runtime_put(vdev->device);
> -err_pm:
>  	vfio_platform_irq_cleanup(vdev);
>  err_irq:
>  	vfio_platform_regions_cleanup(vdev);
> 

