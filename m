Return-Path: <kvm+bounces-35442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E8FA111B3
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 21:07:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D56641884AF8
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 20:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DAA212D71;
	Tue, 14 Jan 2025 20:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O2idZCi8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B9120F09A
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 20:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736885161; cv=none; b=jU0CXjE6Wit6Ujd11RRRpAKD1m4q3QdtjPUhBQwkooeyPV+YK5I2HcyMiMb+5FQ+rz5kXEtI4LrFRDCfvixCR/53h6E9DclRNtm0nhwqIp8rCDb4xmDRF1s6uSSohWdU4c+X82yZaYk2hJSU5WLRxYSCcWEVZBD4aGJEEOoMo9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736885161; c=relaxed/simple;
	bh=8atAq7Fvid1hyCpF6Kr2YPzZhvvcDCqhVTTDUuWlKjI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUmN3EhjK9251tnjjZw/ifAQhhDVEllfR/5A7J9ePA2Waqjf9SU0EQpJPgaDK0U2z0+SjrFWLoqxNqp+cAyUiKag/qVsPSe9t/F7g/GwCc7pBLRPv4m1iu6dW6QQyV0H0EDgwM5ivLZ4Mi8xq3vEkBVSKU1JfKqOKBGmqdnUBHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O2idZCi8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736885158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lbFar/I+VwSDzfZCkzrzUXwa5D3xb1SGyeHZsqGpL1Y=;
	b=O2idZCi8Ar+9yb/gbH9HGED3WTEQJ6+Zw7UzfSVCdeGRqJYb6q3WXPfIDhRNNMfhF19qvu
	oCiDUmUq/2l4k2eiDq3iRji7ook1BLmeoXL9LHO0ZT+tRSR6zLC3b18vjkz4ygfGdDf0Wm
	23utNQtj50g0ksm6ozpfeYSJLkbTeEk=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-RL-xWWhrNvS9UZ2W_dLV7g-1; Tue, 14 Jan 2025 15:05:57 -0500
X-MC-Unique: RL-xWWhrNvS9UZ2W_dLV7g-1
X-Mimecast-MFC-AGG-ID: RL-xWWhrNvS9UZ2W_dLV7g
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-84990d44b31so31539739f.3
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 12:05:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736885156; x=1737489956;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lbFar/I+VwSDzfZCkzrzUXwa5D3xb1SGyeHZsqGpL1Y=;
        b=Y3+LvEQesW9X9Py5EJE70GUu8n110m2LdBtsAvowifFixZb7ST+5o1uh4sNjmiFKdx
         sqzjwHmw/8WqmxazwsizYTc+P19kmG6q1GtTm3FDrs7y6V+/ubM5WKwwGdE32QOoXlPO
         BVSymmf+HwUxn1jRhgnaZ2zFihNKHgmxxuBNbYqvFbhBIxcTngg2+6Hxi0r4vj6fEfOc
         bP3rxjISN8hctZ81hEzaL0HKyBfH+0Xc85TaFOqQmrE/Dd4d4T2MYh1PxJJ21IHkdhBK
         enaifhf0wLZOhyPwjx30hcmBZI2s7tZ31obGtz36NvqXrpZhqy0tPFfyjdo4u4YyZ+J1
         c6lw==
X-Forwarded-Encrypted: i=1; AJvYcCWwfxElC9mEwgVcE43bypJeWHRKIfALM6CdqCxCDH//IIDY3w0CygNWn2nu3So57uMsOLk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu+uYNatfBCzezh8iZfGRsr8F2oQe+18N/hm31cjGXVwTX+XV7
	6adAVxVJtCxVdUK7wEehkQp4COSEWQL/0MN/8pIxI6MuH1NcjsZDbKrcmTHWt/1Cod9RTmXU+H/
	9Q370Rl43HZ2QOccE5WGh9CCMqDcoBh+toh67aTZe5r9HR4Ycng==
X-Gm-Gg: ASbGnctr/EG1EcJHGgrsqmX++p2ue9dc8bQjl5P+MWBY4TyX2NU67yr+GXGCljgFY0i
	HzCw2w5an7SZ1qBUSMux49o9NQf3StlT6WRvdz3bqoyxVqPG4B+fhdsQYYYcUuonfEFmqBhnvGg
	iQ5S5Jp0gwtYSVixLc9kNLIej4y2gWVCVMMFCID2lVRZ9MziRFmrfJBpy+H7e32lGhPHu4NFVDs
	hXVmjIIY8kuvEcFFt6fS9ZV/nkQ5fx/nSzKsbqwfoVhaxCwJggjP6BpQWGk
X-Received: by 2002:a92:c98c:0:b0:3ce:64a4:4c41 with SMTP id e9e14a558f8ab-3ce64a44da0mr17937575ab.1.1736885155870;
        Tue, 14 Jan 2025 12:05:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFEDY6eIKMtRgDol6QZ9qwiDi184sj66O6NoceBRHc+xa1mFh7sgUaATLUNGGtMeRyOyweG2Q==
X-Received: by 2002:a92:c98c:0:b0:3ce:64a4:4c41 with SMTP id e9e14a558f8ab-3ce64a44da0mr17937455ab.1.1736885155518;
        Tue, 14 Jan 2025 12:05:55 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b74945csm3640279173.124.2025.01.14.12.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 12:05:55 -0800 (PST)
Date: Tue, 14 Jan 2025 15:05:40 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Rorie Reyes <rreyes@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, hca@linux.ibm.com, borntraeger@de.ibm.com,
 agordeev@linux.ibm.com, gor@linux.ibm.com, pasic@linux.ibm.com,
 jjherne@linux.ibm.com, akrowiak@linux.ibm.com
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
Message-ID: <20250114150540.64405f27.alex.williamson@redhat.com>
In-Reply-To: <20250107183645.90082-1-rreyes@linux.ibm.com>
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  7 Jan 2025 13:36:45 -0500
Rorie Reyes <rreyes@linux.ibm.com> wrote:

> In this patch, an eventfd object is created by the vfio_ap device driver
> and used to notify userspace when a guests's AP configuration is
> dynamically changed. Such changes may occur whenever:
> 
> * An adapter, domain or control domain is assigned to or unassigned from a
>   mediated device that is attached to the guest.
> * A queue assigned to the mediated device that is attached to a guest is
>   bound to or unbound from the vfio_ap device driver. This can occur
>   either by manually binding/unbinding the queue via the vfio_ap driver's
>   sysfs bind/unbind attribute interfaces, or because an adapter, domain or
>   control domain assigned to the mediated device is added to or removed
>   from the host's AP configuration via an SE/HMC
> 
> The purpose of this patch is to provide immediate notification of changes
> made to a guest's AP configuration by the vfio_ap driver. This will enable
> the guest to take immediate action rather than relying on polling or some
> other inefficient mechanism to detect changes to its AP configuration.
> 
> Note that there are corresponding QEMU patches that will be shipped along
> with this patch (see vfio-ap: Report vfio-ap configuration changes) that
> will pick up the eventfd signal.
> 
> Signed-off-by: Rorie Reyes <rreyes@linux.ibm.com>
> Reviewed-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Tested-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 52 ++++++++++++++++++++++++++-
>  drivers/s390/crypto/vfio_ap_private.h |  2 ++
>  include/uapi/linux/vfio.h             |  1 +
>  3 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index a52c2690933f..c6ff4ab13f16 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -650,13 +650,22 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>  	matrix->adm_max = info->apxa ? info->nd : 15;
>  }
>  
> +static void signal_guest_ap_cfg_changed(struct ap_matrix_mdev *matrix_mdev)
> +{
> +		if (matrix_mdev->cfg_chg_trigger)
> +			eventfd_signal(matrix_mdev->cfg_chg_trigger);
> +}
> +
>  static void vfio_ap_mdev_update_guest_apcb(struct ap_matrix_mdev *matrix_mdev)
>  {
> -	if (matrix_mdev->kvm)
> +	if (matrix_mdev->kvm) {
>  		kvm_arch_crypto_set_masks(matrix_mdev->kvm,
>  					  matrix_mdev->shadow_apcb.apm,
>  					  matrix_mdev->shadow_apcb.aqm,
>  					  matrix_mdev->shadow_apcb.adm);
> +
> +		signal_guest_ap_cfg_changed(matrix_mdev);
> +	}
>  }
>  
>  static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
> @@ -792,6 +801,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>  	if (ret)
>  		goto err_put_vdev;
>  	matrix_mdev->req_trigger = NULL;
> +	matrix_mdev->cfg_chg_trigger = NULL;
>  	dev_set_drvdata(&mdev->dev, matrix_mdev);
>  	mutex_lock(&matrix_dev->mdevs_lock);
>  	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
> @@ -1860,6 +1870,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>  		get_update_locks_for_kvm(kvm);
>  
>  		kvm_arch_crypto_clear_masks(kvm);
> +		signal_guest_ap_cfg_changed(matrix_mdev);
>  		vfio_ap_mdev_reset_queues(matrix_mdev);
>  		kvm_put_kvm(kvm);
>  		matrix_mdev->kvm = NULL;
> @@ -2097,6 +2108,10 @@ static ssize_t vfio_ap_get_irq_info(unsigned long arg)
>  		info.count = 1;
>  		info.flags = VFIO_IRQ_INFO_EVENTFD;
>  		break;
> +	case VFIO_AP_CFG_CHG_IRQ_INDEX:
> +		info.count = 1;
> +		info.flags = VFIO_IRQ_INFO_EVENTFD;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2160,6 +2175,39 @@ static int vfio_ap_set_request_irq(struct ap_matrix_mdev *matrix_mdev,
>  	return 0;
>  }
>  
> +static int vfio_ap_set_cfg_change_irq(struct ap_matrix_mdev *matrix_mdev, unsigned long arg)
> +{
> +	s32 fd;
> +	void __user *data;
> +	unsigned long minsz;
> +	struct eventfd_ctx *cfg_chg_trigger;
> +
> +	minsz = offsetofend(struct vfio_irq_set, count);
> +	data = (void __user *)(arg + minsz);
> +
> +	if (get_user(fd, (s32 __user *)data))
> +		return -EFAULT;
> +
> +	if (fd == -1) {
> +		if (matrix_mdev->cfg_chg_trigger)
> +			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
> +		matrix_mdev->cfg_chg_trigger = NULL;
> +	} else if (fd >= 0) {
> +		cfg_chg_trigger = eventfd_ctx_fdget(fd);
> +		if (IS_ERR(cfg_chg_trigger))
> +			return PTR_ERR(cfg_chg_trigger);
> +
> +		if (matrix_mdev->cfg_chg_trigger)
> +			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
> +
> +		matrix_mdev->cfg_chg_trigger = cfg_chg_trigger;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

How does this guard against a use after free, such as the eventfd being
disabled or swapped concurrent to a config change?  Thanks,

Alex

> +
>  static int vfio_ap_set_irqs(struct ap_matrix_mdev *matrix_mdev,
>  			    unsigned long arg)
>  {
> @@ -2175,6 +2223,8 @@ static int vfio_ap_set_irqs(struct ap_matrix_mdev *matrix_mdev,
>  		switch (irq_set.index) {
>  		case VFIO_AP_REQ_IRQ_INDEX:
>  			return vfio_ap_set_request_irq(matrix_mdev, arg);
> +		case VFIO_AP_CFG_CHG_IRQ_INDEX:
> +			return vfio_ap_set_cfg_change_irq(matrix_mdev, arg);
>  		default:
>  			return -EINVAL;
>  		}
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 437a161c8659..37de9c69b6eb 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -105,6 +105,7 @@ struct ap_queue_table {
>   * @mdev:	the mediated device
>   * @qtable:	table of queues (struct vfio_ap_queue) assigned to the mdev
>   * @req_trigger eventfd ctx for signaling userspace to return a device
> + * @cfg_chg_trigger eventfd ctx to signal AP config changed to userspace
>   * @apm_add:	bitmap of APIDs added to the host's AP configuration
>   * @aqm_add:	bitmap of APQIs added to the host's AP configuration
>   * @adm_add:	bitmap of control domain numbers added to the host's AP
> @@ -120,6 +121,7 @@ struct ap_matrix_mdev {
>  	struct mdev_device *mdev;
>  	struct ap_queue_table qtable;
>  	struct eventfd_ctx *req_trigger;
> +	struct eventfd_ctx *cfg_chg_trigger;
>  	DECLARE_BITMAP(apm_add, AP_DEVICES);
>  	DECLARE_BITMAP(aqm_add, AP_DOMAINS);
>  	DECLARE_BITMAP(adm_add, AP_DOMAINS);
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index c8dbf8219c4f..a2d3e1ac6239 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -671,6 +671,7 @@ enum {
>   */
>  enum {
>  	VFIO_AP_REQ_IRQ_INDEX,
> +	VFIO_AP_CFG_CHG_IRQ_INDEX,
>  	VFIO_AP_NUM_IRQS
>  };
>  


