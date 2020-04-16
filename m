Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8794A1AC08D
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 14:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634641AbgDPL6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 07:58:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58819 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2634633AbgDPL6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 07:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587038307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bGw1yxQ4kUkJge/B/iukxWMb8QJpj2UIRy259IkujXU=;
        b=g/CvnPiL/bb/ADeJxTN+JDW+Dt+1PW5uniiluKeVxZwumapxJ5cFu42lX4kCx8Ow7U9pIl
        BWHdRbNrXVf98wXA1WO+69NhNgRxvpQoPV87zPAnsBC5k+fw/5jYmHM1juyPILo1d+fECJ
        Qo75DkWxOGcs/L8hcnX6a8om06quLRA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-O1gRkXczPaKdX84Ai9Wx9Q-1; Thu, 16 Apr 2020 07:58:25 -0400
X-MC-Unique: O1gRkXczPaKdX84Ai9Wx9Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CE6B800D5C;
        Thu, 16 Apr 2020 11:58:23 +0000 (UTC)
Received: from gondolin (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F7D59DD6D;
        Thu, 16 Apr 2020 11:58:17 +0000 (UTC)
Date:   Thu, 16 Apr 2020 13:58:15 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 05/15] s390/vfio-ap: introduce shadow CRYCB
Message-ID: <20200416135815.0ec6e0b3.cohuck@redhat.com>
In-Reply-To: <20200407192015.19887-6-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-6-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Apr 2020 15:20:05 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Let's introduce a shadow copy of the KVM guest's CRYCB and maintain it for
> the lifespan of the guest. The shadow CRYCB will be used to provide the
> AP configuration for a KVM guest.

'shadow CRYCB' seems to be a bit of a misnomer, as the real CRYCB has a
different format (for starters, it also contains key wrapping stuff).
It seems to be more of a 'shadow matrix'.

> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 31 +++++++++++++++++++++------
>  drivers/s390/crypto/vfio_ap_private.h |  1 +
>  2 files changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 8ece0d52ff4c..b8b678032ab7 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -280,14 +280,32 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static void vfio_ap_matrix_clear(struct ap_matrix *matrix)

vfio_ap_matrix_clear_masks()?

> +{
> +	bitmap_clear(matrix->apm, 0, AP_DEVICES);
> +	bitmap_clear(matrix->aqm, 0, AP_DOMAINS);
> +	bitmap_clear(matrix->adm, 0, AP_DOMAINS);
> +}
> +
>  static void vfio_ap_matrix_init(struct ap_config_info *info,
>  				struct ap_matrix *matrix)
>  {
> +	vfio_ap_matrix_clear(matrix);
>  	matrix->apm_max = info->apxa ? info->Na : 63;
>  	matrix->aqm_max = info->apxa ? info->Nd : 15;
>  	matrix->adm_max = info->apxa ? info->Nd : 15;
>  }
>  
> +static bool vfio_ap_mdev_commit_crycb(struct ap_matrix_mdev *matrix_mdev)

vfio_ap_mdev_commit_masks()?

And it does not seem to return anything? (Maybe it should, to be
consumed below?)

> +{
> +	if (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd) {
> +		kvm_arch_crypto_set_masks(matrix_mdev->kvm,
> +					  matrix_mdev->shadow_crycb.apm,
> +					  matrix_mdev->shadow_crycb.aqm,
> +					  matrix_mdev->shadow_crycb.adm);
> +	}
> +}
> +
>  static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>  {
>  	struct ap_matrix_mdev *matrix_mdev;
> @@ -303,6 +321,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>  
>  	matrix_mdev->mdev = mdev;
>  	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
> +	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_crycb);
>  	mdev_set_drvdata(mdev, matrix_mdev);
>  	matrix_mdev->pqap_hook.hook = handle_pqap;
>  	matrix_mdev->pqap_hook.owner = THIS_MODULE;
> @@ -1126,13 +1145,9 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	if (ret)
>  		return NOTIFY_DONE;
>  
> -	/* If there is no CRYCB pointer, then we can't copy the masks */
> -	if (!matrix_mdev->kvm->arch.crypto.crycbd)
> -		return NOTIFY_DONE;
> -
> -	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
> -				  matrix_mdev->matrix.aqm,
> -				  matrix_mdev->matrix.adm);
> +	memcpy(&matrix_mdev->shadow_crycb, &matrix_mdev->matrix,
> +	       sizeof(matrix_mdev->shadow_crycb));
> +	vfio_ap_mdev_commit_crycb(matrix_mdev);

You are changing the return code for !crycb; maybe that's where a good
return code for vfio_ap_mdev_commit_crycb() would come in handy :)

>  
>  	return NOTIFY_OK;
>  }
> @@ -1247,6 +1262,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>  		kvm_put_kvm(matrix_mdev->kvm);
>  		matrix_mdev->kvm = NULL;
>  	}
> +
> +	vfio_ap_matrix_clear(&matrix_mdev->shadow_crycb);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 4b6e144bab17..87cc270c3212 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -83,6 +83,7 @@ struct ap_matrix {
>  struct ap_matrix_mdev {
>  	struct list_head node;
>  	struct ap_matrix matrix;
> +	struct ap_matrix shadow_crycb;

I think shadow_matrix would be a better name.

>  	struct notifier_block group_notifier;
>  	struct notifier_block iommu_notifier;
>  	struct kvm *kvm;

