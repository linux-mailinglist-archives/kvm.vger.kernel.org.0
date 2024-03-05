Return-Path: <kvm+bounces-11080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B17C2872ADE
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 00:14:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 285AF1F280F7
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 23:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E032512EBC5;
	Tue,  5 Mar 2024 23:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="StQUUKHZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D22512DDBE
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 23:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709680407; cv=none; b=CG8mtTr7Z3+vpn1jSDASAIvMWyjjrjMKWAla3DAnRdXJutiIyUYFYvBF8iEQMZ1MxtVxFiKH3VDPNKlXwseHJcmycNw8tJ9mlLwqtKz+Obbf08bJqxU9GFX68Lkg7KGtefmqXQ1Z+dDlPQMGqqkoPNgkodQoqhsVG3bf8xqH4f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709680407; c=relaxed/simple;
	bh=DBDrKUA81JtzmXSb4rA+240wDRyvevEIN1zSyRb208s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m1nQCFN9hDlBciG7Pyx2OwmbvE3NO5gDNR9GZIwFOudZR4AWdO2Nuh3G2DooeWj6tQLmQnC0j0bIbsYOt5h5zr9Aj4lcKxQCy69dCgA1IeIa7MFyWZUla8B851XXD6vx59MOecdALxdKTrEBISJHB+O7XtBdTy4DjmlEg//VVwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=StQUUKHZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709680404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I7oX6TQq3gnlEQ/JHOQfAZW1rojI6AXt0k3riqS9WiU=;
	b=StQUUKHZ8tS5PBhKrztfb7o2D9nF6UgcP4Zjj0oX7M5e23dxj9K/3eiqw78jZIobeQA9zN
	Iwus1luXuAnU4Rat7ZmeWl0N9r1m/Is+nxARh587DgiCJIUHRqy5hD5gOUB2+sk/uJKlsm
	9D0gFGrGeQt+bnZiRaweGGYyHYT4evM=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-fl7VroiGO1yXbLeKRNCt1w-1; Tue, 05 Mar 2024 18:13:23 -0500
X-MC-Unique: fl7VroiGO1yXbLeKRNCt1w-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-365761d483aso55648615ab.2
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 15:13:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709680402; x=1710285202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I7oX6TQq3gnlEQ/JHOQfAZW1rojI6AXt0k3riqS9WiU=;
        b=LO/IkO2mpRfOVKwMziIXzYVdHlC3x/BLIxcDWASs1sYHa2VnVEFuvUiYz7U6pzwCul
         wuuATbYlU/bKxqO3cMpAH0LpgezPfdQc1CRgAVN0sUK1C1GTQjV+4tb3Bgg5g5oJfUBb
         DE6xrRf3j6YJb9nr4fgTM600G4AQPwMy43Zo615buGR5goKmu5yF3FQLAtX9U3WYeE52
         XdggTkCyfpsdOz4Hn6jSc796bx36ynI7c9ZDZIwUwx8jsqioSr0nRcgxjrqlKqQ0kvV8
         KQKw9hvIcVYxl/Xekc1mQv20j1keqKsyaMWekbPMmM5sUl8Bud7pZfVoJ9+Erg+/IBI9
         4Wbg==
X-Gm-Message-State: AOJu0YxHIdGldq2pF0hG5m0mNrdViuFgTcfvtZJhCiaUpXbgx/BwyE1h
	O8pM0RIPB5AHj9H0159ifsqUsDgjkLsPI2YtEbbEfDzZ9ZTK9KQgkT1QfHDymbl6zibaAAF7SMI
	JMZ04YYQjaUaLSdHj1QA5h8W1+JGH8+5dgvKDqKrL2GEYtqSl8g==
X-Received: by 2002:a05:6e02:1c82:b0:365:b614:5cb7 with SMTP id w2-20020a056e021c8200b00365b6145cb7mr18279908ill.16.1709680402352;
        Tue, 05 Mar 2024 15:13:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGdxCJ+2chdn4hqWqktfybAk7qGIpBM504TRi8Aaeg6fwVD1R7bmqDmiL6y1KaueEWibZq5WA==
X-Received: by 2002:a05:6e02:1c82:b0:365:b614:5cb7 with SMTP id w2-20020a056e021c8200b00365b6145cb7mr18279892ill.16.1709680402112;
        Tue, 05 Mar 2024 15:13:22 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id c26-20020a02c9da000000b00474b48a629csm3084467jap.46.2024.03.05.15.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 15:13:21 -0800 (PST)
Date: Tue, 5 Mar 2024 16:12:41 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: <kvm@vger.kernel.org>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <linuxarm@huawei.com>, <liulongfang@huawei.com>,
 <bcreeley@amd.com>
Subject: Re: [PATCH] hisi_acc_vfio_pci: Remove the deferred_reset logic
Message-ID: <20240305161241.7eeda272.alex.williamson@redhat.com>
In-Reply-To: <20240229091152.56664-1-shameerali.kolothum.thodi@huawei.com>
References: <20240229091152.56664-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Feb 2024 09:11:52 +0000
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> The deferred_reset logic was added to vfio migration drivers to prevent
> a circular locking dependency with respect to mm_lock and state mutex.
> This is mainly because of the copy_to/from_user() functions(which takes
> mm_lock) invoked under state mutex. But for HiSilicon driver, the only
> place where we now hold the state mutex for copy_to_user is during the
> PRE_COPY IOCTL. So for pre_copy, release the lock as soon as we have
> updated the data and perform copy_to_user without state mutex. By this,
> we can get rid of the deferred_reset logic.
> 
> Link: https://lore.kernel.org/kvm/20240220132459.GM13330@nvidia.com/
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 48 +++++--------------
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  6 +--
>  2 files changed, 14 insertions(+), 40 deletions(-)

Applied to vfio next branch for v6.9.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 4d27465c8f1a..9a3e97108ace 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -630,25 +630,11 @@ static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vde
>  	}
>  }
>  
> -/*
> - * This function is called in all state_mutex unlock cases to
> - * handle a 'deferred_reset' if exists.
> - */
> -static void
> -hisi_acc_vf_state_mutex_unlock(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> +static void hisi_acc_vf_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>  {
> -again:
> -	spin_lock(&hisi_acc_vdev->reset_lock);
> -	if (hisi_acc_vdev->deferred_reset) {
> -		hisi_acc_vdev->deferred_reset = false;
> -		spin_unlock(&hisi_acc_vdev->reset_lock);
> -		hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
> -		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> -		hisi_acc_vf_disable_fds(hisi_acc_vdev);
> -		goto again;
> -	}
> -	mutex_unlock(&hisi_acc_vdev->state_mutex);
> -	spin_unlock(&hisi_acc_vdev->reset_lock);
> +	hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
> +	hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> +	hisi_acc_vf_disable_fds(hisi_acc_vdev);
>  }
>  
>  static void hisi_acc_vf_start_device(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> @@ -804,8 +790,10 @@ static long hisi_acc_vf_precopy_ioctl(struct file *filp,
>  
>  	info.dirty_bytes = 0;
>  	info.initial_bytes = migf->total_length - *pos;
> +	mutex_unlock(&migf->lock);
> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
>  
> -	ret = copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
> +	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
>  out:
>  	mutex_unlock(&migf->lock);
>  	mutex_unlock(&hisi_acc_vdev->state_mutex);
> @@ -1071,7 +1059,7 @@ hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
>  			break;
>  		}
>  	}
> -	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
>  	return res;
>  }
>  
> @@ -1092,7 +1080,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>  
>  	mutex_lock(&hisi_acc_vdev->state_mutex);
>  	*curr_state = hisi_acc_vdev->mig_state;
> -	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
>  	return 0;
>  }
>  
> @@ -1104,21 +1092,9 @@ static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
>  				VFIO_MIGRATION_STOP_COPY)
>  		return;
>  
> -	/*
> -	 * As the higher VFIO layers are holding locks across reset and using
> -	 * those same locks with the mm_lock we need to prevent ABBA deadlock
> -	 * with the state_mutex and mm_lock.
> -	 * In case the state_mutex was taken already we defer the cleanup work
> -	 * to the unlock flow of the other running context.
> -	 */
> -	spin_lock(&hisi_acc_vdev->reset_lock);
> -	hisi_acc_vdev->deferred_reset = true;
> -	if (!mutex_trylock(&hisi_acc_vdev->state_mutex)) {
> -		spin_unlock(&hisi_acc_vdev->reset_lock);
> -		return;
> -	}
> -	spin_unlock(&hisi_acc_vdev->reset_lock);
> -	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
> +	mutex_lock(&hisi_acc_vdev->state_mutex);
> +	hisi_acc_vf_reset(hisi_acc_vdev);
> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
>  }
>  
>  static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index dcabfeec6ca1..5bab46602fad 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -98,8 +98,8 @@ struct hisi_acc_vf_migration_file {
>  
>  struct hisi_acc_vf_core_device {
>  	struct vfio_pci_core_device core_device;
> -	u8 match_done:1;
> -	u8 deferred_reset:1;
> +	u8 match_done;
> +
>  	/* For migration state */
>  	struct mutex state_mutex;
>  	enum vfio_device_mig_state mig_state;
> @@ -109,8 +109,6 @@ struct hisi_acc_vf_core_device {
>  	struct hisi_qm vf_qm;
>  	u32 vf_qm_state;
>  	int vf_id;
> -	/* For reset handler */
> -	spinlock_t reset_lock;
>  	struct hisi_acc_vf_migration_file *resuming_migf;
>  	struct hisi_acc_vf_migration_file *saving_migf;
>  };


