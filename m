Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949A328F8E7
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 20:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391060AbgJOSwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 14:52:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgJOSwU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 14:52:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602787938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSej2UjMQRw9PUOU9ztxUjTXF07dstBYT40GdW1tXXg=;
        b=ZUIU5w5JVKM0wLAjTP6F1zZs5vTIn8PXauT8BujSiCpcVm3anBelpNf5dRVrFPs9A/IxIW
        2M7fi8oVT9MO2orX7QNXgo5K1KnFX0U8LwV0qKg0b7VNJNuzcn0tWFWCJGm3/0r2uD5RLS
        FNouABPQFmVRDImyPeNfQitJdL1OdCY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-UdXtL369OZSRB1ZZs07CXw-1; Thu, 15 Oct 2020 14:52:16 -0400
X-MC-Unique: UdXtL369OZSRB1ZZs07CXw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CFEA86ABDC;
        Thu, 15 Oct 2020 18:52:15 +0000 (UTC)
Received: from w520.home (ovpn-113-35.phx2.redhat.com [10.3.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20C351972A;
        Thu, 15 Oct 2020 18:52:11 +0000 (UTC)
Date:   Thu, 15 Oct 2020 12:52:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/fsl-mc: fix the return of the uninitialized
 variable ret
Message-ID: <20201015125211.3ff46dc1@w520.home>
In-Reply-To: <20201015122226.485911-1-colin.king@canonical.com>
References: <20201015122226.485911-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Oct 2020 13:22:26 +0100
Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the success path in function vfio_fsl_mc_reflck_attach is
> returning an uninitialized value in variable ret. Fix this by setting
> this to zero to indicate success.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: f2ba7e8c947b ("vfio/fsl-mc: Added lock support in preparation for interrupt handling")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 80fc7f4ed343..42a5decb78d1 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -84,6 +84,7 @@ static int vfio_fsl_mc_reflck_attach(struct vfio_fsl_mc_device *vdev)
>  		vfio_fsl_mc_reflck_get(cont_vdev->reflck);
>  		vdev->reflck = cont_vdev->reflck;
>  		vfio_device_put(device);
> +		ret = 0;
>  	}
>  
>  unlock:

Looks correct to me, unless Diana would rather set the initial value to
zero instead.  Thanks,

Alex

