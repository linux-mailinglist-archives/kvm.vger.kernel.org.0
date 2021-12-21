Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC14147C6E9
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 19:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241530AbhLUSsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 13:48:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241524AbhLUSsO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 13:48:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640112493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VjBlkUreuHNMRKecqwHy9Zfj3WCtgMAjATsqvRqr8WY=;
        b=J7w1TvVMQKxhjp0DGIXpxlPxcSJk7TKuqGpOhj6ct4YGJaHKN8Hphk9Q2MzqLnLY6az3yz
        tznjuJ6WUpp68tdeylcRSpiL9etsWYXVy9YnrY+bs6ASPDEBVjAhhX83XbzdZco2pJXfIH
        x/NQLsyYRsL5nkgRJJpD7ilv9JLSQ04=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-aPVkPkygMhqxK0MaoZrS9A-1; Tue, 21 Dec 2021 13:48:12 -0500
X-MC-Unique: aPVkPkygMhqxK0MaoZrS9A-1
Received: by mail-ot1-f71.google.com with SMTP id v13-20020a9d69cd000000b00563c36fd48cso4612708oto.4
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 10:48:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VjBlkUreuHNMRKecqwHy9Zfj3WCtgMAjATsqvRqr8WY=;
        b=qXQzdM/P/R//PYxJAcHsOV99ekOGFxQpySaMb9Z+WlhkrcF5eC8t29A8XQTCxDTrmG
         msLZ1bSx16vgbsuNqfL6djasqvkiZJj/TVKvRU14MVdQSlsEICxlqG+Q4rJMj7/8qqI0
         KM6t/ns2PmC4XSj66uDGlp6jpHiiHANcC8nZfNOEdOW4Z4glMPesfbiillizz+krTu6i
         1jl0i6iemA6rBIu1bZmBBQZqR82P85C7jKT0XFFRv14AyT+eHkE5TSMldBY3uJgBRob0
         rh+tWKEdUurG8HHfV/KNpQZ/7KPfZVXkIPTvSp0kqRLspfRZhX7Q4hrzQ0Nayaf+B8rm
         +srw==
X-Gm-Message-State: AOAM533wScxiippVjBbsQJI4YS6uoRK5CPVLE2uKtQmMMin9TDAPpYbm
        Luv7HEYKj6J0g9eveozHhPXOG3syGq+aFyBylDHjg9jAoicjNYaimDj7xLWQViw0Pmb+wbEHZjU
        DQPLeo37FAIYs
X-Received: by 2002:aca:e041:: with SMTP id x62mr3596253oig.84.1640112491723;
        Tue, 21 Dec 2021 10:48:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVCx8tJrxXptqbShpSrhkD08yB4rkw7qniaNME+N8he3nNQnQu0Vu90D5hr8faGU0cFDErZA==
X-Received: by 2002:aca:e041:: with SMTP id x62mr3596235oig.84.1640112491422;
        Tue, 21 Dec 2021 10:48:11 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o19sm4355099oiw.22.2021.12.21.10.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 10:48:11 -0800 (PST)
Date:   Tue, 21 Dec 2021 11:48:09 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 27/32] vfio-pci/zdev: wire up zPCI interpretive
 execution support
Message-ID: <20211221114809.3e883940.alex.williamson@redhat.com>
In-Reply-To: <20211207205743.150299-28-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
        <20211207205743.150299-28-mjrosato@linux.ibm.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Dec 2021 15:57:38 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Introduce support for VFIO_DEVICE_FEATURE_ZPCI_INTERP, which is a new
> VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
> s390x vfio-pci device wishes to enable/disable zPCI interpretive
> execution, which allows zPCI instructions to be executed directly by
> underlying firmware without KVM involvement.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_pci.h  |  1 +
>  drivers/vfio/pci/vfio_pci_core.c |  2 +
>  drivers/vfio/pci/vfio_pci_zdev.c | 76 ++++++++++++++++++++++++++++++++
>  include/linux/vfio_pci_core.h    | 10 +++++
>  include/uapi/linux/vfio.h        |  7 +++
>  include/uapi/linux/vfio_zdev.h   | 15 +++++++
>  6 files changed, 111 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 6526908ac834..062bac720428 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -35,6 +35,7 @@ struct kvm_zdev {
>  	struct kvm_zdev_ioat ioat;
>  	struct zpci_fib fib;
>  	struct notifier_block nb;
> +	bool interp;
>  };
>  
>  extern int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index fc57d4d0abbe..2b2d64a2190c 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1172,6 +1172,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  			mutex_unlock(&vdev->vf_token->lock);
>  
>  			return 0;
> +		case VFIO_DEVICE_FEATURE_ZPCI_INTERP:
> +			return vfio_pci_zdev_feat_interp(vdev, feature, arg);
>  		default:
>  			return -ENOTTY;
>  		}
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index cfd7f44b06c1..b205e0ad1fd3 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -54,6 +54,10 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
>  		.version = zdev->version
>  	};
>  
> +	/* Some values are different for interpreted devices */
> +	if (zdev->kzdev && zdev->kzdev->interp)
> +		cap.maxstbl = zdev->maxstbl;
> +
>  	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
>  }
>  
> @@ -138,6 +142,70 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  	return ret;
>  }
>  
> +int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
> +			      struct vfio_device_feature feature,
> +			      unsigned long arg)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +	struct vfio_device_zpci_interp *data;
> +	struct vfio_device_feature *feat;
> +	unsigned long minsz;
> +	int size, rc;
> +
> +	if (!zdev || !zdev->kzdev)
> +		return -EINVAL;
> +
> +	/*
> +	 * If PROBE requested and feature not found, leave immediately.
> +	 * Otherwise, keep going as GET or SET may also be specified.
> +	 */
> +	if (feature.flags & VFIO_DEVICE_FEATURE_PROBE) {
> +		rc = kvm_s390_pci_interp_probe(zdev);
> +		if (rc)
> +			return rc;
> +	}
> +	if (!(feature.flags & (VFIO_DEVICE_FEATURE_GET +
> +			       VFIO_DEVICE_FEATURE_SET)))
> +		return 0;
> +
> +	size = sizeof(*feat) + sizeof(*data);
> +	feat = kzalloc(size, GFP_KERNEL);
> +	if (!feat)
> +		return -ENOMEM;
> +
> +	data = (struct vfio_device_zpci_interp *)&feat->data;
> +	minsz = offsetofend(struct vfio_device_feature, flags);
> +
> +	/* Get the rest of the payload for GET/SET */
> +	rc = copy_from_user(data, (void __user *)(arg + minsz),
> +			    sizeof(*data));

argsz as noted by Pierre.

> +	if (rc)
> +		rc = -EINVAL;
> +
> +	if (feature.flags & VFIO_DEVICE_FEATURE_GET) {
> +		if (zdev->gd != 0)
> +			data->flags = VFIO_DEVICE_ZPCI_FLAG_INTERP;
> +		else
> +			data->flags = 0;
> +		data->fh = zdev->fh;
> +		/* userspace is using host fh, give interpreted clp values */
> +		zdev->kzdev->interp = true;
> +
> +		if (copy_to_user((void __user *)arg, feat, size))
> +			rc = -EFAULT;
> +	} else if (feature.flags & VFIO_DEVICE_FEATURE_SET) {
> +		if (data->flags == VFIO_DEVICE_ZPCI_FLAG_INTERP)
> +			rc = kvm_s390_pci_interp_enable(zdev);
> +		else if (data->flags == 0)
> +			rc = kvm_s390_pci_interp_disable(zdev);

I see kvm_s390_pci_interp_enable() dereferencing through
zdev->kzdev->kvm without testing it, how do you know the device is
being using with KVM and that the user has registered the group through
the kvm-vfio device?  If these features are dependent on a previously
registered KVM association, shouldn't the feature probing reflect that?
VFIO_GROUP_NOTIFY_SET_KVM can also be called with a NULL KVM pointer.
Thanks,

Alex


> +		else
> +			rc = -EINVAL;
> +	}
> +
> +	kfree(feat);
> +	return rc;
> +}
> +
>  static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
>  					unsigned long action, void *data)
>  {
> @@ -167,6 +235,7 @@ int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
>  		return -ENODEV;
>  
>  	zdev->kzdev->nb.notifier_call = vfio_pci_zdev_group_notifier;
> +	zdev->kzdev->interp = false;
>  
>  	ret = vfio_register_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
>  				     &events, &zdev->kzdev->nb);
> @@ -186,6 +255,13 @@ int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
>  	vfio_unregister_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
>  				 &zdev->kzdev->nb);
>  
> +	/*
> +	 * If the device was using interpretation, don't trust that userspace
> +	 * did the appropriate cleanup
> +	 */
> +	if (zdev->gd != 0)
> +		kvm_s390_pci_interp_disable(zdev);
> +
>  	kvm_s390_pci_dev_release(zdev);
>  
>  	return 0;
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 14079da409f1..92dc43c827c9 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -198,6 +198,9 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
>  #ifdef CONFIG_VFIO_PCI_ZDEV
>  extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  				       struct vfio_info_cap *caps);
> +int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
> +			      struct vfio_device_feature feature,
> +			      unsigned long arg);
>  int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
>  int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
>  #else
> @@ -207,6 +210,13 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  	return -ENODEV;
>  }
>  
> +static inline int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
> +					    struct vfio_device_feature feature,
> +					    unsigned long arg)
> +{
> +	return -ENOTTY;
> +}
> +
>  static inline int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
>  {
>  	return -ENODEV;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..b9a75485b8e7 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1002,6 +1002,13 @@ struct vfio_device_feature {
>   */
>  #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
>  
> +/*
> + * Provide support for enabling interpretation of zPCI instructions.  This
> + * feature is only valid for s390x PCI devices.  Data provided when setting
> + * and getting this feature is futher described in vfio_zdev.h
> + */
> +#define VFIO_DEVICE_FEATURE_ZPCI_INTERP		(1)
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**
> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> index b4309397b6b2..575f0410dc66 100644
> --- a/include/uapi/linux/vfio_zdev.h
> +++ b/include/uapi/linux/vfio_zdev.h
> @@ -75,4 +75,19 @@ struct vfio_device_info_cap_zpci_pfip {
>  	__u8 pfip[];
>  };
>  
> +/**
> + * VFIO_DEVICE_FEATURE_ZPCI_INTERP
> + *
> + * This feature is used for enabling zPCI instruction interpretation for a
> + * device.  No data is provided when setting this feature.  When getting
> + * this feature, the following structure is provided which details whether
> + * or not interpretation is active and provides the guest with host device
> + * information necessary to enable interpretation.
> + */
> +struct vfio_device_zpci_interp {
> +	__u64 flags;
> +#define VFIO_DEVICE_ZPCI_FLAG_INTERP 1
> +	__u32 fh;		/* Host device function handle */
> +};
> +
>  #endif

