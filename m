Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6077322A932
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 09:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgGWHBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 03:01:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38516 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725774AbgGWHBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 03:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595487695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tCJ9HV/dQQNN/kdt2YO0dJshLcnXkw4jxhsX/ogpvnQ=;
        b=WnKXCssAkZoguoYnLUDQVc0TIXedvEVVcgRbFDJcxjPMov7gXMn1oHRTDJuzUtn6kjdMF+
        fyQKLRQvFJ89PlSQb9FCSbevoJgd6xCwZioOdNFVUi5i3NfviTvkCIK63cFh2roRyytsQV
        p94zZRtxRNPid+Dwn0Sm7vfGqAYfeEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-KzkHWC6xN2yqCVe1f7Qr1Q-1; Thu, 23 Jul 2020 03:01:31 -0400
X-MC-Unique: KzkHWC6xN2yqCVe1f7Qr1Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 333D71DE0;
        Thu, 23 Jul 2020 07:01:30 +0000 (UTC)
Received: from gondolin (ovpn-112-228.ams2.redhat.com [10.36.112.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 038A91000232;
        Thu, 23 Jul 2020 07:01:26 +0000 (UTC)
Date:   Thu, 23 Jul 2020 09:01:23 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        prime.zeng@hisilicon.com
Subject: Re: [PATCH] vfio/pci: Hold igate across releasing eventfd contexts
Message-ID: <20200723090123.095159ed.cohuck@redhat.com>
In-Reply-To: <159527934542.26615.503005826695043299.stgit@gimli.home>
References: <159527934542.26615.503005826695043299.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Jul 2020 15:09:27 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> No need to release and immediately re-acquire igate while clearing
> out the eventfd ctxs.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index b0258b79bb5b..dabca0450e6d 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -523,14 +523,12 @@ static void vfio_pci_release(void *device_data)
>  		vfio_pci_vf_token_user_add(vdev, -1);
>  		vfio_spapr_pci_eeh_release(vdev->pdev);
>  		vfio_pci_disable(vdev);
> +
>  		mutex_lock(&vdev->igate);
>  		if (vdev->err_trigger) {
>  			eventfd_ctx_put(vdev->err_trigger);
>  			vdev->err_trigger = NULL;
>  		}
> -		mutex_unlock(&vdev->igate);
> -
> -		mutex_lock(&vdev->igate);
>  		if (vdev->req_trigger) {
>  			eventfd_ctx_put(vdev->req_trigger);
>  			vdev->req_trigger = NULL;
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

