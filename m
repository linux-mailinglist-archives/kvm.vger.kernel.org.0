Return-Path: <kvm+bounces-30822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1215D9BD992
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 00:19:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3732A1C228B2
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 23:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0D6216431;
	Tue,  5 Nov 2024 23:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kyz4ZGHs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF211D27BF
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 23:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730848733; cv=none; b=n1b7pzfAjGfN3xLAsWJagbHLwJ8dH++MMxq740p0CU14mDa3SARSyvaeQ5X7D1N46uktKkGKA1J9qkafZvGy7W18zF+MNS8eIYxE8mSnaih9kH7EIkmk+fNHQDRAo4l0K94taTtseUvJvBaLyrbfhcDDEuEoakT6IltMI23DmjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730848733; c=relaxed/simple;
	bh=LwBakWoo04OagPpyp0RAonw0RHNrAFVcq29SGjGwL7E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mfmS+RYpbLxLNdTuSuU8V1UvoNYjY0rIbnDPMYqD1YZNfd1Cvhot2hJUukSABzt9EAq1Hd6V1wLL/xY3dbr2OQO8wVwcYFilVgrdJV5ePN+IlM68UROdV23XAt3e/n6lQbP51k9xXltG9dQbsvMwu0TFOMbd0HOxPBUVWkxOlVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kyz4ZGHs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730848730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=29OVp9dBUQ2V20hBqFAQ4FqvV7sf8LfdstOD5BPqG/s=;
	b=Kyz4ZGHsdfwz1GgxKCwuB9gMLU/qrz6fxfsHNpJy3YRpEFg46KF5cPoGicuWmJPEGnosGz
	D2sIv5KFHlCbltljy4aZYBViCKt2dpbTLS+CBD4T1PHmGvJg94iqiyB4MgUlrNXtXXtEWH
	ogt2B8Z3Hw+oVYONg2SJl3kL+r7eNCg=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-Zr0G08huPTidA0mZKbG9Xg-1; Tue, 05 Nov 2024 18:18:48 -0500
X-MC-Unique: Zr0G08huPTidA0mZKbG9Xg-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a4d8e3c162so5196775ab.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 15:18:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730848727; x=1731453527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=29OVp9dBUQ2V20hBqFAQ4FqvV7sf8LfdstOD5BPqG/s=;
        b=ZPwyi/7+XdPUgbcQRyX131gyfE7JC4IZC9EPdGtq4dWSEeb6X5HBWwKtx8NamJAKsV
         ckog7V24KZ/SimMV9JTY02PtdbaAg4UCK4Xam51Q1P3Tst24fNsWuoncDd2jWo8YU3NK
         wLDb5Y7V2FanwygR5GSywewJapuw6D8uxn/8HXBU/P1SLc4KOORIvSHcQ2mOooJzdobB
         +ElkbxhOz2q/dotN0v+U9PGqkWhs6b2MW1LLveyu9/0A6vt9ztckRVcZYmAsuTa5gwjU
         ehorJCuK43LsiU7IMEjCcDicix+5CtE5DOTwXHSNFk3mnYPIzi00SMRgMCqpnWDswCra
         thIw==
X-Forwarded-Encrypted: i=1; AJvYcCXqPnsH6cfLZX82KF8r0gfaSHv+HvQVQhP5c/h9EVly/LH3Cl5hl0aXfUL+rdi6iENcHcw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCKrhtAXoqfu2YTT8/pYEO7MyJPNYoQBA3xCxY03KyjulxgNvc
	AycRx4PgEG0QjOyoKU4ldguqgXCX7V+/Ium2gPApb+oHCSD8xpJ2BbEwD9JjZCKSRYBnQKBnUGd
	Feigyfa2pIFMWic3K47svcKxnY0l8OBssTIGrttguCO8HHtT0EQ==
X-Received: by 2002:a05:6e02:b2d:b0:3a6:ac17:13e3 with SMTP id e9e14a558f8ab-3a6ac1717famr60577565ab.7.1730848727245;
        Tue, 05 Nov 2024 15:18:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/B5xVC97K5koz5637iGId4N+tsYxZgKGmtzW8MaaSyK3qhMVypcGHpBarTT6cMX6q2Jtw5g==
X-Received: by 2002:a05:6e02:b2d:b0:3a6:ac17:13e3 with SMTP id e9e14a558f8ab-3a6ac1717famr60577495ab.7.1730848726717;
        Tue, 05 Nov 2024 15:18:46 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de049a325esm2643757173.140.2024.11.05.15.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2024 15:18:46 -0800 (PST)
Date: Tue, 5 Nov 2024 16:18:45 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 6/7] vfio/virtio: Add PRE_COPY support for live
 migration
Message-ID: <20241105161845.734e777e.alex.williamson@redhat.com>
In-Reply-To: <20241104102131.184193-7-yishaih@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
	<20241104102131.184193-7-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 Nov 2024 12:21:30 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Add PRE_COPY support for live migration.
> 
> This functionality may reduce the downtime upon STOP_COPY as of letting
> the target machine to get some 'initial data' from the source once the
> machine is still in its RUNNING state and let it prepares itself
> pre-ahead to get the final STOP_COPY data.
> 
> As the Virtio specification does not support reading partial or
> incremental device contexts. This means that during the PRE_COPY state,
> the vfio-virtio driver reads the full device state.
> 
> As the device state can be changed and the benefit is highest when the
> pre copy data closely matches the final data we read it in a rate
> limiter mode and reporting no data available for some time interval
> after the previous call.
> 
> With PRE_COPY enabled, we observed a downtime reduction of approximately
> 70-75% in various scenarios compared to when PRE_COPY was disabled,
> while keeping the total migration time nearly the same.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/virtio/common.h  |   4 +
>  drivers/vfio/pci/virtio/migrate.c | 233 +++++++++++++++++++++++++++++-
>  2 files changed, 229 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/pci/virtio/common.h b/drivers/vfio/pci/virtio/common.h
> index 3bdfb3ea1174..5704603f0f9d 100644
> --- a/drivers/vfio/pci/virtio/common.h
> +++ b/drivers/vfio/pci/virtio/common.h
> @@ -10,6 +10,8 @@
>  
>  enum virtiovf_migf_state {
>  	VIRTIOVF_MIGF_STATE_ERROR = 1,
> +	VIRTIOVF_MIGF_STATE_PRECOPY = 2,
> +	VIRTIOVF_MIGF_STATE_COMPLETE = 3,
>  };
>  
>  enum virtiovf_load_state {
> @@ -57,6 +59,8 @@ struct virtiovf_migration_file {
>  	/* synchronize access to the file state */
>  	struct mutex lock;
>  	loff_t max_pos;
> +	u64 pre_copy_initial_bytes;
> +	struct ratelimit_state pre_copy_rl_state;
>  	u64 record_size;
>  	u32 record_tag;
>  	u8 has_obj_id:1;
> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> index 2a9614c2ef07..cdb252f6fd80 100644
> --- a/drivers/vfio/pci/virtio/migrate.c
> +++ b/drivers/vfio/pci/virtio/migrate.c
...
> @@ -379,9 +432,104 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
>  	return done;
>  }
>  
> +static long virtiovf_precopy_ioctl(struct file *filp, unsigned int cmd,
> +				   unsigned long arg)
> +{
> +	struct virtiovf_migration_file *migf = filp->private_data;
> +	struct virtiovf_pci_core_device *virtvdev = migf->virtvdev;
> +	struct vfio_precopy_info info = {};
> +	loff_t *pos = &filp->f_pos;
> +	bool end_of_data = false;
> +	unsigned long minsz;
> +	u32 ctx_size;
> +	int ret;
> +
> +	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
> +		return -ENOTTY;
> +
> +	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
> +	if (copy_from_user(&info, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	mutex_lock(&virtvdev->state_mutex);
> +	if (virtvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY &&
> +	    virtvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY_P2P) {
> +		ret = -EINVAL;
> +		goto err_state_unlock;
> +	}
> +
> +	/*
> +	 * The virtio specification does not include a PRE_COPY concept.
> +	 * Since we can expect the data to remain the same for a certain period,
> +	 * we use a rate limiter mechanism before making a call to the device.
> +	 */
> +	if (!__ratelimit(&migf->pre_copy_rl_state)) {
> +		/* Reporting no data available */
> +		ret = 0;
> +		goto done;

@ret is not used by the done: goto target.  Don't we need to zero dirty
bytes, or account for initial bytes not being fully read yet?

> +	}
> +
> +	ret = virtio_pci_admin_dev_parts_metadata_get(virtvdev->core_device.pdev,
> +				VIRTIO_RESOURCE_OBJ_DEV_PARTS, migf->obj_id,
> +				VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_SIZE,
> +				&ctx_size);
> +	if (ret)
> +		goto err_state_unlock;
> +
> +	mutex_lock(&migf->lock);
> +	if (migf->state == VIRTIOVF_MIGF_STATE_ERROR) {
> +		ret = -ENODEV;
> +		goto err_migf_unlock;
> +	}
> +
> +	if (migf->pre_copy_initial_bytes > *pos) {
> +		info.initial_bytes = migf->pre_copy_initial_bytes - *pos;
> +	} else {
> +		info.dirty_bytes = migf->max_pos - *pos;
> +		if (!info.dirty_bytes)
> +			end_of_data = true;
> +		info.dirty_bytes += ctx_size;
> +	}
> +
> +	if (!end_of_data || !ctx_size) {
> +		mutex_unlock(&migf->lock);
> +		goto done;
> +	}
> +
> +	mutex_unlock(&migf->lock);
> +	/*
> +	 * We finished transferring the current state and the device has a
> +	 * dirty state, read a new state.
> +	 */
> +	ret = virtiovf_read_device_context_chunk(migf, ctx_size);
> +	if (ret)
> +		/*
> +		 * The machine is running, and context size could be grow, so no reason to mark
> +		 * the device state as VIRTIOVF_MIGF_STATE_ERROR.
> +		 */
> +		goto err_state_unlock;
> +
> +done:
> +	virtiovf_state_mutex_unlock(virtvdev);
> +	if (copy_to_user((void __user *)arg, &info, minsz))
> +		return -EFAULT;
> +	return 0;
> +
> +err_migf_unlock:
> +	mutex_unlock(&migf->lock);
> +err_state_unlock:
> +	virtiovf_state_mutex_unlock(virtvdev);
> +	return ret;
> +}
> +
...
> @@ -536,6 +719,17 @@ virtiovf_pci_save_device_data(struct virtiovf_pci_core_device *virtvdev)
>  	if (ret)
>  		goto out_clean;
>  
> +	if (pre_copy) {
> +		migf->pre_copy_initial_bytes = migf->max_pos;
> +		ratelimit_state_init(&migf->pre_copy_rl_state, 1 * HZ, 1);

A comment describing the choice of this heuristic would be useful for
future maintenance, even if the comment is "Arbitrarily rate limit
pre-copy to 1s intervals."  Thanks,

Alex

> +		/* Prevent any rate messages upon its usage */
> +		ratelimit_set_flags(&migf->pre_copy_rl_state,
> +				    RATELIMIT_MSG_ON_RELEASE);
> +		migf->state = VIRTIOVF_MIGF_STATE_PRECOPY;
> +	} else {
> +		migf->state = VIRTIOVF_MIGF_STATE_COMPLETE;
> +	}
> +
>  	return migf;
>  
>  out_clean:


