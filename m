Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305692A4E49
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 19:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgKCSVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 13:21:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbgKCSVL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 13:21:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604427670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SaC7TgHjFvy/qqAyPMD2OVFai6Lwhq4gX9LD0DI1FSI=;
        b=bxrFqv+Xrl1jWer7sO/2MrfkyPlPZyK2xDXzDSG0aXJYCC1ZkEbElPwZ4a01vXr1q9l4j/
        DINBszMm4pTVbiobN5rSJVLjTQYbShbcG2qfTovtA3sN/nMhGFrdQH9Va66UushFar6y/D
        TGEp2qYGgmB9HDgxIBlQbs4/D00/ytg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-jbowo85PMlKakeE2KrDKoQ-1; Tue, 03 Nov 2020 13:21:09 -0500
X-MC-Unique: jbowo85PMlKakeE2KrDKoQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BF02107465C;
        Tue,  3 Nov 2020 18:21:08 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE40360BF1;
        Tue,  3 Nov 2020 18:21:04 +0000 (UTC)
Date:   Tue, 3 Nov 2020 11:21:04 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     <eric.auger@redhat.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] vfio: platform: fix reference leak in
 vfio_platform_open
Message-ID: <20201103112104.57e8eea1@w520.home>
In-Reply-To: <20201031030353.9699-1-zhangqilong3@huawei.com>
References: <20201031030353.9699-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 31 Oct 2020 11:03:53 +0800
Zhang Qilong <zhangqilong3@huawei.com> wrote:

> pm_runtime_get_sync() will increment pm usage counter even it
> failed. Forgetting to call pm_runtime_put will result in
> reference leak in vfio_platform_open, so we should fix it.
> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>  drivers/vfio/platform/vfio_platform_common.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied to vfio for-linus branch with Eric's ack for v5.10.  Thanks,

Alex


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

