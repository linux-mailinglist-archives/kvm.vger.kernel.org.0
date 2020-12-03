Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F872CD34F
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 11:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgLCKUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 05:20:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbgLCKUw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 05:20:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606990765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fdoqPowfgaPwgdpg4xdqnBSrmpGIg2cYmWgzjzhfZg8=;
        b=EBOmkUjuurcdFXdmdMWBeWWNEWOyvDRjbOzOztJq/t1SIE4/J0gfSxfI2sUKr8YCIBN+/W
        XMEHQ0+TWzfsj3Tvd2r4pyMQeNhoTCP0dIH9J5rKfNVHNhXYYp5fjZhY90fHslxU6msqI9
        cVB46jOvmrq9JqEoiFOSE33b8sedG7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-NznW8gA9Op-k8sBayTMKlw-1; Thu, 03 Dec 2020 05:19:23 -0500
X-MC-Unique: NznW8gA9Op-k8sBayTMKlw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A4141936B8F;
        Thu,  3 Dec 2020 10:19:17 +0000 (UTC)
Received: from gondolin (ovpn-113-106.ams2.redhat.com [10.36.113.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE6E35D6AC;
        Thu,  3 Dec 2020 10:19:09 +0000 (UTC)
Date:   Thu, 3 Dec 2020 11:19:07 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201203111907.72a89884.cohuck@redhat.com>
In-Reply-To: <20201202234101.32169-1-akrowiak@linux.ibm.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  2 Dec 2020 18:41:01 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The vfio_ap device driver registers a group notifier with VFIO when the
> file descriptor for a VFIO mediated device for a KVM guest is opened to
> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> event). When the KVM pointer is set, the vfio_ap driver stashes the pointer
> and calls the kvm_get_kvm() function to increment its reference counter.
> When the notifier is called to make notification that the KVM pointer has
> been set to NULL, the driver should clean up any resources associated with
> the KVM pointer and decrement its reference counter. The current
> implementation does not take care of this clean up.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..eeb9c9130756 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1083,6 +1083,17 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>  	return NOTIFY_DONE;
>  }
>  
> +static void vfio_ap_mdev_put_kvm(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	if (matrix_mdev->kvm) {
> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> +		kvm_put_kvm(matrix_mdev->kvm);
> +		matrix_mdev->kvm = NULL;
> +	}
> +}
> +
>  static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  				       unsigned long action, void *data)
>  {
> @@ -1095,7 +1106,7 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>  
>  	if (!data) {
> -		matrix_mdev->kvm = NULL;
> +		vfio_ap_mdev_put_kvm(matrix_mdev);

Hm. I'm wondering whether you need to hold the maxtrix_dev lock here as
well?

>  		return NOTIFY_OK;
>  	}
>  
> @@ -1222,13 +1233,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
>  	mutex_lock(&matrix_dev->lock);
> -	if (matrix_mdev->kvm) {
> -		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> -		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> -		vfio_ap_mdev_reset_queues(mdev);
> -		kvm_put_kvm(matrix_mdev->kvm);
> -		matrix_mdev->kvm = NULL;
> -	}
> +	vfio_ap_mdev_put_kvm(matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,

