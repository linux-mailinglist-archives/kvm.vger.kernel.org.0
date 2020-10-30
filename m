Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4574F2A0A6D
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 16:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgJ3Pws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 11:52:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725939AbgJ3Pws (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 11:52:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604073167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c9jJaGV9y6FTbJMb2ia/5TZBUj+9Nbj1vDWGxoH50Yg=;
        b=KSYduUJ3SOZHtcWNOqPMSIL9loviFNGgcDsssjaV+KRPDCaZOBuLPP7cgyFM+YvxlmGuos
        PA9kG+nsbV54pQ4k+VliJz2AEztgMet50WMPammz6GATciODYIoKOOFysYct4L43f3cgVF
        jePC/f4zktOFz4Mf5rQwCFYzR037oLM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-c-qml3Z0MEqum_v27fbxvw-1; Fri, 30 Oct 2020 11:52:45 -0400
X-MC-Unique: c-qml3Z0MEqum_v27fbxvw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A52D425D5;
        Fri, 30 Oct 2020 15:52:43 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01DDA5D9D2;
        Fri, 30 Oct 2020 15:52:38 +0000 (UTC)
Subject: Re: [PATCH] vfio: platform: fix reference leak in vfio_platform_open
To:     Zhang Qilong <zhangqilong3@huawei.com>, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org
References: <20201030154754.99431-1-zhangqilong3@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <8260f3ed-1b0a-d6d9-f058-9580949bf34e@redhat.com>
Date:   Fri, 30 Oct 2020 16:52:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201030154754.99431-1-zhangqilong3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhang,

On 10/30/20 4:47 PM, Zhang Qilong wrote:
> pm_runtime_get_sync() will increment pm usage counter even it
> failed. Forgetting to call pm_runtime_put_noidle will result
> in reference leak in vfio_platform_open, so we should fix it.
> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>  drivers/vfio/platform/vfio_platform_common.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index c0771a9567fb..aa97f1678981 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -266,8 +266,10 @@ static int vfio_platform_open(void *device_data)
>  			goto err_irq;
>  
>  		ret = pm_runtime_get_sync(vdev->device);
> -		if (ret < 0)
> +		if (ret < 0) {
> +			pm_runtime_put_noidle(vdev->device);
can't we jump to err_rst then?

Thanks

Eric
>  			goto err_pm;
> +		}
>  
>  		ret = vfio_platform_call_reset(vdev, &extra_dbg);
>  		if (ret && vdev->reset_required) {
> 

