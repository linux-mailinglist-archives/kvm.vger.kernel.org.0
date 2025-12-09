Return-Path: <kvm+bounces-65557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22047CB098C
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 12C2A304F8FC
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2748032ED3A;
	Tue,  9 Dec 2025 16:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FWCGjC7k";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7rYfjBA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B56432E6B8
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 16:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765298101; cv=none; b=ZAW4k8ooEDe5AsPO41XSnfs6IoN5DZKDV86kUvuuJVk9kdiDnXB+leDWJVNiQTrXddWj+KrdQAyzcCyfDqZsmJjfpALqgqHdNGKBKgMakHmSi0roEn/oEj/lA5yE8lqgfnaaICwDph8i342KFXaCltyT+TruqwZI4ezZkgIXJOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765298101; c=relaxed/simple;
	bh=lnyXcCQY8wxYUiz9C+WbQVRN8NAJ6h19E/JrUdRefVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aeson0GRZVK0w3q6QTLIY0cb+LQbE7jkHKSAgDytngp9EUqa0wlBLwMvnn4QKsm4C42bVOZxoosB/eUGh2tdMYdl+6J9WPGPL6Le6EVkJskl3r8VvpHghemGIzhDEcmXM0CrtDoUOU3oIsRgqv4sltnJ58q8jSncsqkpFJbrqkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FWCGjC7k; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7rYfjBA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765298097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9JfjndmoaJNvNI6sbMSfg1Y02u1WJwsC5WsyytU640=;
	b=FWCGjC7kUGnCivpHx9u12ShI36Xv7lgQAKC5OePY2oTJQ0oJnXPkl+5TskknAIxJTF/Aj0
	iXO4pxdVzP2C+sLexxMj88oMNgv+FqZvskYqo8HGaKWjdxk3TNGDQLrVzKe8m5NI4kCKKF
	FvVkUytkMN8WPg6BttqMG78lMhmWf8w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-YLVauhhRNQSR3z0QrNL5lg-1; Tue, 09 Dec 2025 11:34:55 -0500
X-MC-Unique: YLVauhhRNQSR3z0QrNL5lg-1
X-Mimecast-MFC-AGG-ID: YLVauhhRNQSR3z0QrNL5lg_1765298095
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4779d8fd4ecso26426775e9.1
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 08:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765298094; x=1765902894; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r9JfjndmoaJNvNI6sbMSfg1Y02u1WJwsC5WsyytU640=;
        b=A7rYfjBAZbMY7MLtg3dVrKjdiV9nGjYFv2vM3j7v82Vld6N3CGoztk0wGFriBh6O9T
         zTtl/2+Ke4ELFO/0KfyT+UbZgQ+f4EMKQIj9iZR5mDs9VPMp6Y0ULy+mfn/6aCCJ/L/J
         cXpQbONl+JL6GOM8iWVXhIwViEiOaJRW6YG+6wx0R3YtUV2nOffF06N8LCXnVzcTOdTP
         LENtVtpMEBOxd/GH+O04zbA2ydDPlpJQ+e8Ss8SSki9bfNp4SYgQ/94tl7GJQ9VpUlxI
         JTCxBOkcUpOkwor2BCyHPADBVrYioAcymPvouOamiuWpKzFxG3rVN/B35T8r/dUpOoJk
         NZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765298094; x=1765902894;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r9JfjndmoaJNvNI6sbMSfg1Y02u1WJwsC5WsyytU640=;
        b=bNRuHVLTSmb+lPpHO1Mv9qKWftN8F3ByK3GDzK+2ZTzLTWx9wo4dXlPZKIfO4dhrIB
         F/+kOrouz6gUHJeSrcVFg7InLsshvMzZaDX5NorLgWUSCvTQs2cgO6YF9pAgLxtGT5a+
         cjCkuix4Z/xk5I6YsV0GVk80LE2/I2Cw1XN7COGP5I96E1+oopwbzNwCOhpRYWREPQF/
         BqbrKU7Bjg6bdExorktLr/ch4h8a7ZRD8/+S5dpPuWGBqUS/K094lp9TKlJwsa3bDbVu
         9NrwGQxBJoao8NDKAFbnDYy12WkVOxY/mpWdsmcxSgDqcbMBDxiYDeDUicRebKtfMoTH
         RUVg==
X-Forwarded-Encrypted: i=1; AJvYcCUJdnHbV+5dFg0VXL6tqYXlI7CE61biYw1O5Kx3pEmJsOvbSv74aCTy26VrMflzDHVRNJE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzuBIMHJ5eLZzjaOMcxvirYsXI/66XHMBZKEfvNge7FqLJlN6J
	D7fYwT7bZfnGV3gHWATw3WgeQioTfsgXry4pwI1HhXvapi9esnFqnenZG4G5dUA7PMbdR2dQtol
	pp95b7v/AmIbtcn8uZ1NKcuXc5En8pWMksCYAOqFhOhyrOlpIR2iN3h6Vw2nifA==
X-Gm-Gg: ASbGncuRZchFlyBvR8ajamu4EzJeyzoDQVWbvcwcT6Ppk6g8wGCJfJt03KpqP0Ila6t
	4hjboAUM6rnh5YKFvSnE4ItMOfq3KnjdofFjls7nxWBQaGSPL9nq+N5xDfKtyhgPCTL4xlKPdh1
	6S+SsiZXUU61GETFRyBYQMxOzIbPhHn3LLPBIhallfvW2D0tjQJILkSTAthqN/+oMf+Ux1D+8Cx
	EaduYhpChHArFePWTHzmju8KLbxm0QfKtFLOpC4H16x1WcbYBvz2pW7mHDemOePGuw7QjKeqCVC
	baVbRlo/JoGfOLfglgYWAxJN0a63V3gOQlPXEIOXPMWplatCt2ocFe36TcaLj4TAGRAhh+9L4re
	k
X-Received: by 2002:a05:600c:c297:b0:477:9cec:c83e with SMTP id 5b1f17b1804b1-47a7f90f366mr18557915e9.1.1765298094380;
        Tue, 09 Dec 2025 08:34:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMTQnY4WUopYEq62Lme08UXaCxVEXwK+s04m0yfRFAAPpJeSRLjIyzdawPMvHmUE0u+t16GA==
X-Received: by 2002:a05:600c:c297:b0:477:9cec:c83e with SMTP id 5b1f17b1804b1-47a7f90f366mr18557655e9.1.1765298093947;
        Tue, 09 Dec 2025 08:34:53 -0800 (PST)
Received: from redhat.com ([80.230.34.255])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a7d632cebsm48499025e9.7.2025.12.09.08.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 08:34:53 -0800 (PST)
Date: Tue, 9 Dec 2025 11:34:50 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com,
	virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
	oren@nvidia.com, aevdaev@nvidia.com, aaptel@nvidia.com
Subject: Re: [PATCH v2 1/1] virtio: add driver_override support
Message-ID: <20251209113306-mutt-send-email-mst@kernel.org>
References: <20251208220908.9250-1-mgurtovoy@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208220908.9250-1-mgurtovoy@nvidia.com>

On Tue, Dec 09, 2025 at 12:09:08AM +0200, Max Gurtovoy wrote:
> Add support for the 'driver_override' attribute to Virtio devices. This
> allows users to control which Virtio bus driver binds to a given Virtio
> device.
> 
> If 'driver_override' is not set, the existing behavior is preserved and
> devices will continue to auto-bind to the first matching Virtio bus
> driver.

oh, it's a device driver not the bus driver, actually.

> Tested with virtio blk device (virtio core and pci drivers are loaded):
> 
>   $ modprobe my_virtio_blk
> 
>   # automatically unbind from virtio_blk driver and override + bind to
>   # my_virtio_blk driver.
>   $ driverctl -v -b virtio set-override virtio0 my_virtio_blk
> 
> In addition, driverctl saves the configuration persistently under
> /etc/driverctl.d/.

what is this "mydriver" though? what are valid examples that
we want to support? 

> 
> Signed-off-by: Avraham Evdaev <aevdaev@nvidia.com>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
> 
> changes from v1:
>  - use !strcmp() to compare strings (MST)
>  - extend commit msg with example (MST)
> 
> ---
>  drivers/virtio/virtio.c | 34 ++++++++++++++++++++++++++++++++++
>  include/linux/virtio.h  |  4 ++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index a09eb4d62f82..993dc928be49 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -61,12 +61,41 @@ static ssize_t features_show(struct device *_d,
>  }
>  static DEVICE_ATTR_RO(features);
>  
> +static ssize_t driver_override_store(struct device *_d,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct virtio_device *dev = dev_to_virtio(_d);
> +	int ret;
> +
> +	ret = driver_set_override(_d, &dev->driver_override, buf, count);
> +	if (ret)
> +		return ret;
> +
> +	return count;
> +}
> +
> +static ssize_t driver_override_show(struct device *_d,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct virtio_device *dev = dev_to_virtio(_d);
> +	ssize_t len;
> +
> +	device_lock(_d);
> +	len = sysfs_emit(buf, "%s\n", dev->driver_override);
> +	device_unlock(_d);
> +
> +	return len;
> +}
> +static DEVICE_ATTR_RW(driver_override);
> +
>  static struct attribute *virtio_dev_attrs[] = {
>  	&dev_attr_device.attr,
>  	&dev_attr_vendor.attr,
>  	&dev_attr_status.attr,
>  	&dev_attr_modalias.attr,
>  	&dev_attr_features.attr,
> +	&dev_attr_driver_override.attr,
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(virtio_dev);
> @@ -88,6 +117,10 @@ static int virtio_dev_match(struct device *_dv, const struct device_driver *_dr)
>  	struct virtio_device *dev = dev_to_virtio(_dv);
>  	const struct virtio_device_id *ids;
>  
> +	/* Check override first, and if set, only use the named driver */
> +	if (dev->driver_override)
> +		return !strcmp(dev->driver_override, _dr->name);
> +
>  	ids = drv_to_virtio(_dr)->id_table;
>  	for (i = 0; ids[i].device; i++)
>  		if (virtio_id_match(dev, &ids[i]))
> @@ -582,6 +615,7 @@ void unregister_virtio_device(struct virtio_device *dev)
>  {
>  	int index = dev->index; /* save for after device release */
>  
> +	kfree(dev->driver_override);
>  	device_unregister(&dev->dev);
>  	virtio_debug_device_exit(dev);
>  	ida_free(&virtio_index_ida, index);
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index db31fc6f4f1f..418bb490bdc6 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -138,6 +138,9 @@ struct virtio_admin_cmd {
>   * @config_lock: protects configuration change reporting
>   * @vqs_list_lock: protects @vqs.
>   * @dev: underlying device.
> + * @driver_override: driver name to force a match; do not set directly,
> + *                   because core frees it; use driver_set_override() to
> + *                   set or clear it.
>   * @id: the device type identification (used to match it with a driver).
>   * @config: the configuration ops for this device.
>   * @vringh_config: configuration ops for host vrings.
> @@ -158,6 +161,7 @@ struct virtio_device {
>  	spinlock_t config_lock;
>  	spinlock_t vqs_list_lock;
>  	struct device dev;
> +	const char *driver_override;
>  	struct virtio_device_id id;
>  	const struct virtio_config_ops *config;
>  	const struct vringh_config_ops *vringh_config;
> -- 
> 2.18.1


