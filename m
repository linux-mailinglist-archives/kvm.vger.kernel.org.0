Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0932A3624
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 22:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgKBVpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 16:45:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725894AbgKBVpu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Nov 2020 16:45:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604353549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ppDWZLFuLILFXtSDmcPrGG8E8KknQmLkxXAxflMcQvY=;
        b=EGQaCpK/0A464GsZIikOvPx6TD8urIi1aKFoY9SXe2HN7D1dRNgaC/cKfC2b6fSn3/okvB
        wHCdQCqNLtFDQmFF1YxShN8/DW4U0BUVMlhYDgxqrWtttAEMOSaCAhjT+vidyqIikA/Qp3
        G7I+3nhCbqhgfIXWSxumNeb7gTm/TkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-iEqOaznvOAyBP9zldyFhcQ-1; Mon, 02 Nov 2020 16:45:47 -0500
X-MC-Unique: iEqOaznvOAyBP9zldyFhcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4794E57202;
        Mon,  2 Nov 2020 21:45:46 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6F3E10013C0;
        Mon,  2 Nov 2020 21:45:45 +0000 (UTC)
Date:   Mon, 2 Nov 2020 14:45:38 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] vfio/fsl-mc: prevent underflow in
 vfio_fsl_mc_mmap()
Message-ID: <20201102144538.2871369d@w520.home>
In-Reply-To: <20201023112947.GF282278@mwanda>
References: <20201023112947.GF282278@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Diana, same for this one.  Thanks,

Alex

On Fri, 23 Oct 2020 14:29:47 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> My static analsysis tool complains that the "index" can be negative.
> There are some checks in do_mmap() which try to prevent underflows but
> I don't know if they are sufficient for this situation.  Either way,
> making "index" unsigned is harmless so let's do it just to be safe.
> 
> Fixes: 67247289688d ("vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 21f22e3da11f..f27e25112c40 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -472,7 +472,7 @@ static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
>  {
>  	struct vfio_fsl_mc_device *vdev = device_data;
>  	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> -	int index;
> +	unsigned int index;
>  
>  	index = vma->vm_pgoff >> (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT);
>  

