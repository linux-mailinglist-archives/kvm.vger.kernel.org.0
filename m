Return-Path: <kvm+bounces-25941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7B496D803
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 14:12:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3C24B21ABF
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 12:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6CC019ABAE;
	Thu,  5 Sep 2024 12:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V8Tsqdqy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA4E19538A
	for <kvm@vger.kernel.org>; Thu,  5 Sep 2024 12:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725538345; cv=none; b=ilHVonVSD+KB79g6wn+ue9KTHR8lxy5m3UPydkFlgNX5DoGPXpht4hqzMMJzxdAZCYignSfjP4WIjKQU4ABK0lkF3uNtn4oftJww9NRtN3HguLmXT25kRb4chWyZC79VGEVzCgrdk5NO4i12sW53TFjBV6UMB7Pyu6BYToAe+to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725538345; c=relaxed/simple;
	bh=Ychmre9ag1XNKKuZ98GFZEBEmxaKj6JFon2FHeRtO/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slW2NMmOcSvbaZ0JyxpF8qbsWiD9ZLbfoFO21ntKYD1oqA9EJNecxh72BirdTNKUQxiIR22jtljbdjYzbUA8D8FHdaKXZgWcGSS8auO9YgEiLd8mczi/iapTq44EA65lpUNaGnSHvhEJ7FihcUADhdtYruYSR7gLgICbM1Kx6K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V8Tsqdqy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725538343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B5+96ubPrNEirh7F6gJ9j4NI0fdiGkhUKbUz5LxonT8=;
	b=V8TsqdqyVAbvvpyCTGSQSdAW1RBHBRq3zLSygU5LPvYDSUC3iaWw+wKGjqtZS/11PM2Toh
	IZgYxmM3WLwD+mNr8yavYd1I5gtx3Wm6PEElZ3uUt94iK2IlW1XKfqa4JKG6qtoAz/B2/F
	MTWdzh5nokBy8uBiY802dgiUouK63fA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-Eww3UhWdNl2YRyNnpyrAFg-1; Thu, 05 Sep 2024 08:12:22 -0400
X-MC-Unique: Eww3UhWdNl2YRyNnpyrAFg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42c7a5563cfso5484735e9.2
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 05:12:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725538341; x=1726143141;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B5+96ubPrNEirh7F6gJ9j4NI0fdiGkhUKbUz5LxonT8=;
        b=rEksVIhXhJ9bCD8jsqLL2aab7fUaK9x3KruVOREvk0YmJVEud/sRJXFpk/32Uc9EMr
         QgBySwkKEILkn3ijvhUGx51I7ZwYshg8VmoeT2N+e5e/aRrff5dro0kUCiEF0jlaHh7q
         Vr7cdrLsGOY1HU7j7+B4bCCGnbeHBkVP06f9ybR38y+dVpyB9FGIlzVrzxJhnERQtOVp
         Zq5BHJhXE5oGrPsZZXwFCONKsmhQu7BC1W8Zaan8yOg9i+w+LEBF7e5PT6LA18wZOK+Z
         nZM4x2w2l0GrqM0JjAxwXBzFegIi3Plam1yTFdSaYhCyOvx1vS5nYtV3HXJhUHvIGY6g
         FImw==
X-Forwarded-Encrypted: i=1; AJvYcCW5kSamJ6usKzsc7rze2wcir4TCug9DNCafRr+TT1d+3vbDy6Scop3z3mJyt1zFNiJ3he4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfluEKcDh/RUUQ+cjp8jYiDiuXwm5hve5CErNW6/orJZcgjtGD
	ItxWdYWDieoaLgXAZBJdYJ2WwSnCG82WVZDv51Zt8+nNVwrEUKzpiNZveFKAt67UgDQCMeZ4WA3
	OI171huExlHWz6FBedAFOPQgQT8g5j1TA74xJn0C9qrJxL3Utzw==
X-Received: by 2002:a05:6000:11d1:b0:374:bb34:9fd2 with SMTP id ffacd0b85a97d-374bb34a020mr10412424f8f.36.1725538340581;
        Thu, 05 Sep 2024 05:12:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNpl07ADMxEaEO/2kewuqRSpoLGY6cZKZwNF+AMSPrVUiiBQCZLREJLydrYHMLVW/zaHKtsg==
X-Received: by 2002:a05:6000:11d1:b0:374:bb34:9fd2 with SMTP id ffacd0b85a97d-374bb34a020mr10412383f8f.36.1725538339709;
        Thu, 05 Sep 2024 05:12:19 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1ee:dac1:384c:40cd:a203:ee4f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bbc127ec5sm204924375e9.19.2024.09.05.05.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 05:12:18 -0700 (PDT)
Date: Thu, 5 Sep 2024 08:12:12 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: stefanha@redhat.com, virtualization@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, kvm@vger.kernel.org,
	Jingbo Xu <jefflexu@linux.alibaba.com>, pgootzen@nvidia.com,
	smalin@nvidia.com, larora@nvidia.com, ialroy@nvidia.com,
	oren@nvidia.com, izach@nvidia.com,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Subject: Re: [PATCH v1 2/2] virtio_fs: add sysfs entries for queue information
Message-ID: <20240905081157-mutt-send-email-mst@kernel.org>
References: <20240825130716.9506-1-mgurtovoy@nvidia.com>
 <20240825130716.9506-2-mgurtovoy@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240825130716.9506-2-mgurtovoy@nvidia.com>

Cc: "Eugenio Pérez" <eperezma@redhat.com>


On Sun, Aug 25, 2024 at 04:07:16PM +0300, Max Gurtovoy wrote:
> Introduce sysfs entries to provide visibility to the multiple queues
> used by the Virtio FS device. This enhancement allows users to query
> information about these queues.
> 
> Specifically, add two sysfs entries:
> 1. Queue name: Provides the name of each queue (e.g. hiprio/requests.8).
> 2. CPU list: Shows the list of CPUs that can process requests for each
> queue.
> 
> The CPU list feature is inspired by similar functionality in the block
> MQ layer, which provides analogous sysfs entries for block devices.
> 
> These new sysfs entries will improve observability and aid in debugging
> and performance tuning of Virtio FS devices.
> 
> Reviewed-by: Idan Zach <izach@nvidia.com>
> Reviewed-by: Shai Malin <smalin@nvidia.com>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  fs/fuse/virtio_fs.c | 147 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 139 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 43f7be1d7887..78f579463cca 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -56,12 +56,14 @@ struct virtio_fs_vq {
>  	bool connected;
>  	long in_flight;
>  	struct completion in_flight_zero; /* No inflight requests */
> +	struct kobject *kobj;
>  	char name[VQ_NAME_LEN];
>  } ____cacheline_aligned_in_smp;
>  
>  /* A virtio-fs device instance */
>  struct virtio_fs {
>  	struct kobject kobj;
> +	struct kobject *mqs_kobj;
>  	struct list_head list;    /* on virtio_fs_instances */
>  	char *tag;
>  	struct virtio_fs_vq *vqs;
> @@ -200,6 +202,74 @@ static const struct kobj_type virtio_fs_ktype = {
>  	.default_groups = virtio_fs_groups,
>  };
>  
> +static struct virtio_fs_vq *virtio_fs_kobj_to_vq(struct virtio_fs *fs,
> +		struct kobject *kobj)
> +{
> +	int i;
> +
> +	for (i = 0; i < fs->nvqs; i++) {
> +		if (kobj == fs->vqs[i].kobj)
> +			return &fs->vqs[i];
> +	}
> +	return NULL;
> +}
> +
> +static ssize_t name_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	struct virtio_fs *fs = container_of(kobj->parent->parent, struct virtio_fs, kobj);
> +	struct virtio_fs_vq *fsvq = virtio_fs_kobj_to_vq(fs, kobj);
> +
> +	if (!fsvq)
> +		return -EINVAL;
> +	return sysfs_emit(buf, "%s\n", fsvq->name);
> +}
> +
> +static struct kobj_attribute virtio_fs_vq_name_attr = __ATTR_RO(name);
> +
> +static ssize_t cpu_list_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	struct virtio_fs *fs = container_of(kobj->parent->parent, struct virtio_fs, kobj);
> +	struct virtio_fs_vq *fsvq = virtio_fs_kobj_to_vq(fs, kobj);
> +	unsigned int cpu, qid;
> +	const size_t size = PAGE_SIZE - 1;
> +	bool first = true;
> +	int ret = 0, pos = 0;
> +
> +	if (!fsvq)
> +		return -EINVAL;
> +
> +	qid = fsvq->vq->index;
> +	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
> +		if (qid < VQ_REQUEST || (fs->mq_map[cpu] == qid - VQ_REQUEST)) {
> +			if (first)
> +				ret = snprintf(buf + pos, size - pos, "%u", cpu);
> +			else
> +				ret = snprintf(buf + pos, size - pos, ", %u", cpu);
> +
> +			if (ret >= size - pos)
> +				break;
> +			first = false;
> +			pos += ret;
> +		}
> +	}
> +	ret = snprintf(buf + pos, size + 1 - pos, "\n");
> +	return pos + ret;
> +}
> +
> +static struct kobj_attribute virtio_fs_vq_cpu_list_attr = __ATTR_RO(cpu_list);
> +
> +static struct attribute *virtio_fs_vq_attrs[] = {
> +	&virtio_fs_vq_name_attr.attr,
> +	&virtio_fs_vq_cpu_list_attr.attr,
> +	NULL
> +};
> +
> +static struct attribute_group virtio_fs_vq_attr_group = {
> +	.attrs = virtio_fs_vq_attrs,
> +};
> +
>  /* Make sure virtiofs_mutex is held */
>  static void virtio_fs_put_locked(struct virtio_fs *fs)
>  {
> @@ -280,6 +350,50 @@ static void virtio_fs_start_all_queues(struct virtio_fs *fs)
>  	}
>  }
>  
> +static void virtio_fs_delete_queues_sysfs(struct virtio_fs *fs)
> +{
> +	struct virtio_fs_vq *fsvq;
> +	int i;
> +
> +	for (i = 0; i < fs->nvqs; i++) {
> +		fsvq = &fs->vqs[i];
> +		kobject_put(fsvq->kobj);
> +	}
> +}
> +
> +static int virtio_fs_add_queues_sysfs(struct virtio_fs *fs)
> +{
> +	struct virtio_fs_vq *fsvq;
> +	char buff[12];
> +	int i, j, ret;
> +
> +	for (i = 0; i < fs->nvqs; i++) {
> +		fsvq = &fs->vqs[i];
> +
> +		sprintf(buff, "%d", i);
> +		fsvq->kobj = kobject_create_and_add(buff, fs->mqs_kobj);
> +		if (!fs->mqs_kobj) {
> +			ret = -ENOMEM;
> +			goto out_del;
> +		}
> +
> +		ret = sysfs_create_group(fsvq->kobj, &virtio_fs_vq_attr_group);
> +		if (ret) {
> +			kobject_put(fsvq->kobj);
> +			goto out_del;
> +		}
> +	}
> +
> +	return 0;
> +
> +out_del:
> +	for (j = 0; j < i; j++) {
> +		fsvq = &fs->vqs[j];
> +		kobject_put(fsvq->kobj);
> +	}
> +	return ret;
> +}
> +
>  /* Add a new instance to the list or return -EEXIST if tag name exists*/
>  static int virtio_fs_add_instance(struct virtio_device *vdev,
>  				  struct virtio_fs *fs)
> @@ -303,17 +417,22 @@ static int virtio_fs_add_instance(struct virtio_device *vdev,
>  	 */
>  	fs->kobj.kset = virtio_fs_kset;
>  	ret = kobject_add(&fs->kobj, NULL, "%d", vdev->index);
> -	if (ret < 0) {
> -		mutex_unlock(&virtio_fs_mutex);
> -		return ret;
> +	if (ret < 0)
> +		goto out_unlock;
> +
> +	fs->mqs_kobj = kobject_create_and_add("mqs", &fs->kobj);
> +	if (!fs->mqs_kobj) {
> +		ret = -ENOMEM;
> +		goto out_del;
>  	}
>  
>  	ret = sysfs_create_link(&fs->kobj, &vdev->dev.kobj, "device");
> -	if (ret < 0) {
> -		kobject_del(&fs->kobj);
> -		mutex_unlock(&virtio_fs_mutex);
> -		return ret;
> -	}
> +	if (ret < 0)
> +		goto out_put;
> +
> +	ret = virtio_fs_add_queues_sysfs(fs);
> +	if (ret)
> +		goto out_remove;
>  
>  	list_add_tail(&fs->list, &virtio_fs_instances);
>  
> @@ -322,6 +441,16 @@ static int virtio_fs_add_instance(struct virtio_device *vdev,
>  	kobject_uevent(&fs->kobj, KOBJ_ADD);
>  
>  	return 0;
> +
> +out_remove:
> +	sysfs_remove_link(&fs->kobj, "device");
> +out_put:
> +	kobject_put(fs->mqs_kobj);
> +out_del:
> +	kobject_del(&fs->kobj);
> +out_unlock:
> +	mutex_unlock(&virtio_fs_mutex);
> +	return ret;
>  }
>  
>  /* Return the virtio_fs with a given tag, or NULL */
> @@ -1050,7 +1179,9 @@ static void virtio_fs_remove(struct virtio_device *vdev)
>  	mutex_lock(&virtio_fs_mutex);
>  	/* This device is going away. No one should get new reference */
>  	list_del_init(&fs->list);
> +	virtio_fs_delete_queues_sysfs(fs);
>  	sysfs_remove_link(&fs->kobj, "device");
> +	kobject_put(fs->mqs_kobj);
>  	kobject_del(&fs->kobj);
>  	virtio_fs_stop_all_queues(fs);
>  	virtio_fs_drain_all_queues_locked(fs);
> -- 
> 2.18.1


