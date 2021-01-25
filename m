Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71E33029BC
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 19:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbhAYSNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 13:13:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731110AbhAYSNY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 13:13:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611598317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aRLVA34g2UiZFXfWsom7Zc/R9cBgMjuJJ4B6y+IhQwA=;
        b=BkpEhYaafEeFlvN7HQMX+rXq9Hp89E4UuazAgmzWVgRHH2TXk+lAVsIc6zEYzDrnyY3ZEt
        pOKO706W9NxL+UXDgWc1R9pf+Kf/vRCmbHNPpndeQDyTpy8fNmh9ywTQkyUXPDSBAhJ7yj
        vFORVdQfp5v3FFZStCqoWagaMiy+qgM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-QEP5XgAPM4-Dbu6cYUYgvg-1; Mon, 25 Jan 2021 13:11:56 -0500
X-MC-Unique: QEP5XgAPM4-Dbu6cYUYgvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 082CC107ACE6;
        Mon, 25 Jan 2021 18:11:55 +0000 (UTC)
Received: from gondolin (ovpn-113-161.ams2.redhat.com [10.36.113.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29BA370476;
        Mon, 25 Jan 2021 18:11:51 +0000 (UTC)
Date:   Mon, 25 Jan 2021 19:11:47 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Fix handling of pci use accessor return codes
Message-ID: <20210125191147.5f876923.cohuck@redhat.com>
In-Reply-To: <3d14987b-278c-be28-be7b-8f3c733fc4e9@gmail.com>
References: <3d14987b-278c-be28-be7b-8f3c733fc4e9@gmail.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 24 Jan 2021 16:35:41 +0100
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> The pci user accessors return negative errno's on error.
> 
> Fixes: f572a960a15e ("vfio/pci: Intel IGD host and LCP bridge config space access")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index 53d97f459..e66dfb017 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -127,7 +127,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
>  
>  		ret = pci_user_read_config_byte(pdev, pos, &val);
>  		if (ret)
> -			return pcibios_err_to_errno(ret);
> +			return ret;

This is actually not strictly needed, as pcibios_err_to_errno() already
keeps errors <= 0 unchanged, so more a cleanup than a fix?

Anyway,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

>  
>  		if (copy_to_user(buf + count - size, &val, 1))
>  			return -EFAULT;

