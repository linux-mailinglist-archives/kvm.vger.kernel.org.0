Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F4A30C7A0
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbhBBRZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:25:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233896AbhBBRXq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:23:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612286540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x1tB/9FnKtVTeOPxic+crZ2fbs0UqMAsbkLVkzkX2Ss=;
        b=R39vl/epRhtrUhFLw7EGiwrd8C+5R23Bq/KP0shc+/QUn2BsvFCk3xAzmErCzZe0Pc4E61
        BCBEdwYm1eGtEKaPOjaxw65ycQeljEms0MQLdq1ZYgJxs4Qhp2vmW9A7/gWDmK0oF5Q72C
        JHcaAMWPFGMXeiQ6zlzrOJiNvXubDAU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-Ryo2Y5QOMLu0hzDFnPspoQ-1; Tue, 02 Feb 2021 12:22:19 -0500
X-MC-Unique: Ryo2Y5QOMLu0hzDFnPspoQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52E07107ACE3;
        Tue,  2 Feb 2021 17:22:18 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AB899CA0;
        Tue,  2 Feb 2021 17:22:18 +0000 (UTC)
Date:   Tue, 2 Feb 2021 10:22:17 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Fix handling of pci use accessor return codes
Message-ID: <20210202102217.48135d0f@omen.home.shazbot.org>
In-Reply-To: <3d14987b-278c-be28-be7b-8f3c733fc4e9@gmail.com>
References: <3d14987b-278c-be28-be7b-8f3c733fc4e9@gmail.com>
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

Applied to vfio next branch for v5.12 w/ Connie's R-b.  I did drop the
fixes tag since pcibios_err_to_errno() has always handled -errno
correctly to avoid the unnecessary churn.  Thanks,

Alex

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
>  
>  		if (copy_to_user(buf + count - size, &val, 1))
>  			return -EFAULT;
> @@ -141,7 +141,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
>  
>  		ret = pci_user_read_config_word(pdev, pos, &val);
>  		if (ret)
> -			return pcibios_err_to_errno(ret);
> +			return ret;
>  
>  		val = cpu_to_le16(val);
>  		if (copy_to_user(buf + count - size, &val, 2))
> @@ -156,7 +156,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
>  
>  		ret = pci_user_read_config_dword(pdev, pos, &val);
>  		if (ret)
> -			return pcibios_err_to_errno(ret);
> +			return ret;
>  
>  		val = cpu_to_le32(val);
>  		if (copy_to_user(buf + count - size, &val, 4))
> @@ -171,7 +171,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
>  
>  		ret = pci_user_read_config_word(pdev, pos, &val);
>  		if (ret)
> -			return pcibios_err_to_errno(ret);
> +			return ret;
>  
>  		val = cpu_to_le16(val);
>  		if (copy_to_user(buf + count - size, &val, 2))
> @@ -186,7 +186,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
>  
>  		ret = pci_user_read_config_byte(pdev, pos, &val);
>  		if (ret)
> -			return pcibios_err_to_errno(ret);
> +			return ret;
>  
>  		if (copy_to_user(buf + count - size, &val, 1))
>  			return -EFAULT;

