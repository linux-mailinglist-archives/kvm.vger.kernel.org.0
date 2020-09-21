Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0701271EDB
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 11:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIUJXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 05:23:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbgIUJXc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 05:23:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600680211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l2BihOhVLQI3Fiuw96ozpY+9Laf0KFEpgF1HeUeh3t8=;
        b=RixvTCW8PdYU6VoxQgxMGCNngR63waal2Cv0J9x1Hg3TDY5ev4ZE9jLs/dDS+XdGlzHt4C
        XUyQ6nJQY2UZ69CZchXuEu3KxFYsyR+GvHZeeXlSpSQL8NAdcwic8NS1aTEfpjqvwe9uep
        3mzvkjERpEc5cy+2W8iRvjeIg1VmwWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-FMgK4nM6PIG6eY0xIurFgQ-1; Mon, 21 Sep 2020 05:23:27 -0400
X-MC-Unique: FMgK4nM6PIG6eY0xIurFgQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFE148030A4;
        Mon, 21 Sep 2020 09:23:25 +0000 (UTC)
Received: from gondolin (ovpn-112-187.ams2.redhat.com [10.36.112.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15D526115F;
        Mon, 21 Sep 2020 09:23:20 +0000 (UTC)
Date:   Mon, 21 Sep 2020 11:23:18 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        borntraeger@de.ibm.com
Subject: Re: [PATCH] s390/vfio-ap: fix unregister GISC when KVM is already
 gone results in OOPS
Message-ID: <20200921112318.0d11a2e5.cohuck@redhat.com>
In-Reply-To: <20200918170234.5807-1-akrowiak@linux.ibm.com>
References: <20200918170234.5807-1-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Sep 2020 13:02:34 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Attempting to unregister Guest Interruption Subclass (GISC) when the
> link between the matrix mdev and KVM has been removed results in the
> following:
> 
>    "Kernel panic -not syncing: Fatal exception: panic_on_oops"

I'm wondering how we get there (why are we unregistering the gisc if
the mdev and kvm are not yet linked or are already unlinked?), so I
agree that the actual backchain would be helpful here.

> 
> This patch fixes this bug by verifying the matrix mdev and KVM are still
> linked prior to unregistering the GISC.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..847a88642644 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -119,11 +119,15 @@ static void vfio_ap_wait_for_irqclear(int apqn)
>   */
>  static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
>  {
> -	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)

If checking for ->kvm is the right thing to do, I agree that moving the
check here would be easier to read.

> -		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
> -	if (q->saved_pfn && q->matrix_mdev)
> -		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> -				 &q->saved_pfn, 1);
> +	if (q->matrix_mdev) {
> +		if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev->kvm)
> +			kvm_s390_gisc_unregister(q->matrix_mdev->kvm,
> +						 q->saved_isc);
> +		if (q->saved_pfn)
> +			vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> +					 &q->saved_pfn, 1);
> +	}
> +
>  	q->saved_pfn = 0;
>  	q->saved_isc = VFIO_AP_ISC_INVALID;
>  }

