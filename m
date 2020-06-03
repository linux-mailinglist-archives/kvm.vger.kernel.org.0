Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E211EC9AA
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 08:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgFCGoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 02:44:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36955 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725275AbgFCGoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 02:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591166645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LNHVI7P34BM+W8F8+/kyhRzc/JWzM8TCEpl7EdHB1Es=;
        b=HWbjE1U0qrHegPKiflqQiDwEOIXpBAe2Q185hw9qaxzuTXnxJ8mCxQZ2z6J2LA4WCe0ftt
        hlHI1Sy6yCOkI2TpSqujbdquWV1kMx8+aK0BgUTwDxNXqsSBCjxCOAUqkzTwores0abxOi
        FdjgU3NRjXxTMXA97z1Qcxve+koDUF8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-MOpPq_q3OEO3q3R3KxRd1Q-1; Wed, 03 Jun 2020 02:44:01 -0400
X-MC-Unique: MOpPq_q3OEO3q3R3KxRd1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82E8718FE86D;
        Wed,  3 Jun 2020 06:44:00 +0000 (UTC)
Received: from gondolin (ovpn-112-182.ams2.redhat.com [10.36.112.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7900978B56;
        Wed,  3 Jun 2020 06:43:59 +0000 (UTC)
Date:   Wed, 3 Jun 2020 08:43:56 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] s390/virtio: remove unused pm callbacks
Message-ID: <20200603084356.326d66aa.cohuck@redhat.com>
In-Reply-To: <20200526093629.257649-1-cohuck@redhat.com>
References: <20200526093629.257649-1-cohuck@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Friendly ping.

On Tue, 26 May 2020 11:36:29 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> Support for hibernation on s390 has been recently been removed with

(one 'been' too much here, I just noticed :)

> commit 394216275c7d ("s390: remove broken hibernate / power management
> support"), no need to keep unused code around.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  drivers/s390/virtio/virtio_ccw.c | 26 --------------------------
>  1 file changed, 26 deletions(-)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 957889a42d2e..5730572b52cd 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -1372,27 +1372,6 @@ static struct ccw_device_id virtio_ids[] = {
>  	{},
>  };
>  
> -#ifdef CONFIG_PM_SLEEP
> -static int virtio_ccw_freeze(struct ccw_device *cdev)
> -{
> -	struct virtio_ccw_device *vcdev = dev_get_drvdata(&cdev->dev);
> -
> -	return virtio_device_freeze(&vcdev->vdev);
> -}
> -
> -static int virtio_ccw_restore(struct ccw_device *cdev)
> -{
> -	struct virtio_ccw_device *vcdev = dev_get_drvdata(&cdev->dev);
> -	int ret;
> -
> -	ret = virtio_ccw_set_transport_rev(vcdev);
> -	if (ret)
> -		return ret;
> -
> -	return virtio_device_restore(&vcdev->vdev);
> -}
> -#endif
> -
>  static struct ccw_driver virtio_ccw_driver = {
>  	.driver = {
>  		.owner = THIS_MODULE,
> @@ -1405,11 +1384,6 @@ static struct ccw_driver virtio_ccw_driver = {
>  	.set_online = virtio_ccw_online,
>  	.notify = virtio_ccw_cio_notify,
>  	.int_class = IRQIO_VIR,
> -#ifdef CONFIG_PM_SLEEP
> -	.freeze = virtio_ccw_freeze,
> -	.thaw = virtio_ccw_restore,
> -	.restore = virtio_ccw_restore,
> -#endif
>  };
>  
>  static int __init pure_hex(char **cp, unsigned int *val, int min_digit,

