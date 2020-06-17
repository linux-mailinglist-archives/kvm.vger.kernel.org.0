Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F281FC5DE
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 07:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgFQF4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 01:56:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35519 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725929AbgFQF4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 01:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592373374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bqylOELuu5u+OMaXH6+BHxzbmV1N3q++LSowq/nIA1I=;
        b=if8rRWzPXbrRTcUgVKnHdwGfxjxcgY+C/09WD+Y9yq70sS35gzJmV/haFHiGUrQyT5CoEr
        ypBHKVcHMxQY33G10izf+25Lazen9clOsDPbXpJzX6wiJfYSZFiZ2ELPja76TYGBQUG63J
        g0zkWylheEMGiuQ0w67NZ9EBNh7Xyu8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-P4RaW-KYNnSocYt9_L0J7w-1; Wed, 17 Jun 2020 01:56:12 -0400
X-MC-Unique: P4RaW-KYNnSocYt9_L0J7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEA79188362F;
        Wed, 17 Jun 2020 05:56:10 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F03060CC0;
        Wed, 17 Jun 2020 05:56:06 +0000 (UTC)
Date:   Wed, 17 Jun 2020 07:56:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, dwagner@suse.de,
        cai@lca.pw
Subject: Re: [PATCH] vfio/pci: Clear error and request eventfd ctx after
 releasing
Message-ID: <20200617075604.67b47078.cohuck@redhat.com>
In-Reply-To: <159234276956.31057.6902954364435481688.stgit@gimli.home>
References: <159234276956.31057.6902954364435481688.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Jun 2020 15:26:36 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> The next use of the device will generate an underflow from the
> stale reference.
> 
> Cc: Qian Cai <cai@lca.pw>
> Fixes: 1518ac272e78 ("vfio/pci: fix memory leaks of eventfd ctx")
> Reported-by: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 7c0779018b1b..f634c81998bb 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -521,10 +521,14 @@ static void vfio_pci_release(void *device_data)
>  		vfio_pci_vf_token_user_add(vdev, -1);
>  		vfio_spapr_pci_eeh_release(vdev->pdev);
>  		vfio_pci_disable(vdev);
> -		if (vdev->err_trigger)
> +		if (vdev->err_trigger) {
>  			eventfd_ctx_put(vdev->err_trigger);
> -		if (vdev->req_trigger)
> +			vdev->err_trigger = NULL;
> +		}
> +		if (vdev->req_trigger) {
>  			eventfd_ctx_put(vdev->req_trigger);
> +			vdev->req_trigger = NULL;
> +		}
>  	}
>  
>  	mutex_unlock(&vdev->reflck->lock);
> 

Clearing this seems like the right thing to do.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

