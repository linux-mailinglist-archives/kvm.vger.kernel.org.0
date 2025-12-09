Return-Path: <kvm+bounces-65582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 45211CB0D4A
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 19:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 341C4301B69D
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 18:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41F2301486;
	Tue,  9 Dec 2025 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D6fcPfpt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DithfqX3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF092F60AC
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765304669; cv=none; b=s3oVrfLILDeV0/KufynbtLuYy5nziqz7TVyRP9AM70i8G7A+8+4lUemJ+WUMWca3PSPiQvc+6oOuDjw1f3msyNEvYIzbk/DVxYjTtIgPyrbOO5npgm0fsgKlC4AxbmcUNk0PxZIN/KNPWtRCpsYBwhe0UxP0aY0HZwdpwdh1co8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765304669; c=relaxed/simple;
	bh=1VHf9csxRdUdp3601l4R7AIy9z/7AEjDyrvpyUT3F8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nw/9mlou8T5GYacP0G0sGEvRUKQEl3N+kUN+YxX0OMroFGsz67Yd+cNpA24anVvYryRHM43bdJAv1iSem6klq3kJGO8pLHTm3wzsd2rpGKindYqFoyHWNebnn/+8Wv/qVQ46YCeE7Oa/npzlMhCgPJKuguPjqGfE18a/WadPX3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D6fcPfpt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DithfqX3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765304666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=USk9jSaWQvYUDmDx9daRJ6IHaYeMNOUxJLYi+6sv0Co=;
	b=D6fcPfptBdoVvbvRp7jCZz7RE2kc35fS86jnViZP/2do79r/BbJdjamuwOToEZUZeeZzWl
	DLtqIqVuqpRaZfl8zTkcPbjhfTJ2eRNb4bIzhf5qwBk4/ygwU3Et9hkAA0ANrEqiJ4c04S
	iQ8vw7xNeyPkEGBbozHnuhpjCIuYahA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-GhFxcdNkP0mnlyEx1G5Ebw-1; Tue, 09 Dec 2025 13:24:16 -0500
X-MC-Unique: GhFxcdNkP0mnlyEx1G5Ebw-1
X-Mimecast-MFC-AGG-ID: GhFxcdNkP0mnlyEx1G5Ebw_1765304656
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477a0ddd1d4so34721675e9.0
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 10:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765304656; x=1765909456; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=USk9jSaWQvYUDmDx9daRJ6IHaYeMNOUxJLYi+6sv0Co=;
        b=DithfqX36cf0PlMUGqPvr0CQXmrGz7JZwEEaChAgqCazsVPXfaUm9iB3IuCZr59EPP
         Ko/Ngiqjvu9I7bgxdpurjaSqM4MMfN2N86teAdKuRpIIS+0wVrc+LGq+gW9TU7quU/43
         uD3BK/E5r+6plDbIUJb0qO7yOEERfp5sXClUwdCgdyEK9Est3ybzrPbrCoThxPuVNjBs
         6IbEh2PiUeqsPKJIk/bKEftXBVzApcuFV8DglGd2cgXs2Od8rvDr7srAbBJ5Apk42fL/
         i5NgSY/KG9vwUnsIdbXUK41ChfnwijyD3JKVmKAeNJNnEGXnyUr7y4/guBTyYpPRYDm8
         4Now==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765304656; x=1765909456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=USk9jSaWQvYUDmDx9daRJ6IHaYeMNOUxJLYi+6sv0Co=;
        b=dhPv4CKIysljWtSXa7W8/kWJHJjwt4GmteTZ/PDA+GXV5UPre/Uc0ua/iN25o1PC+b
         ue03YT85knb48xfSRz8dzDiBQSyrcL158RUmIm9JJbqHiHz8VxcLGBypDVsHPhZNoqZb
         h3oFIl8Thp+8eYuYnMEQ46z9g8cWL/EwskLSdDqPq8Egt01iu7vjkqvX1CpX+FzbGcj4
         DEjbhTMu+KfZFcVSAuu+9JQ1NoXktuVhflOUlWcpbnGCyq1Z9otvvdFDwxVrn0ng54si
         GW1o9JLAmDyS3y7g7Z6nF6mKgWhycpRg1+UwejQw0aXVLD0B6eN3+KgZ6sqd7Nu4q4zS
         ZAxw==
X-Forwarded-Encrypted: i=1; AJvYcCXSYdAgmqfROmZYJkO1moBkOJ85VQRjjEqy3MwcwK3S10HbMGQ43fGSjf5AOV2AyH1ca3g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu/lnz46y4qau2Vx0vp+AOh4dR/s2lfB9xh3CaDzN4BYEWEt6T
	9DO0kQXkbr0LTDrxO8jbv+pqRLwz2nmH0I8AiVHgrANQ+brzqIjhZsUyPOBcFv191UE62bN/wQA
	/X21P5SvXqpGDmD7CSNUwu760CvFvdheIZvBjRf4W1hvOFcSiv/MXkg==
X-Gm-Gg: ASbGncv7ql7+Czsjsc2yryhvRBI+G9EbiIe/KnZ/29VquRK1ZyyZBasOhbtYgAc6p6X
	ezAHUyXQfI+f2AoWhVX++0wDQSi8Bd/3bdzaHA4TQCB9LCKNa4fXotc0f/kUzTCFncH/ve2uxNd
	229Tx4KzlWMqi5OIaHRnylrBhGw9ZXtLTKxP+K8OqUa+DZVjll3XYOopaS5sk4tydYziu62YHi1
	6dbhKNNvWKLlVFoUD0Ez0OEJmu3igDaKyBhrBKXfr5BdLYkQQe1nvYJy/orvYFVAxcttQ1ECt7L
	+tB+xEg4oMERRKMGL5Zf6dRi4ssrDzgXirTCRXtwkEVwJbOaXOlA2bl1wRyQAEkWWXd7nSSOBkH
	z
X-Received: by 2002:a05:600c:4f54:b0:477:b642:9dbf with SMTP id 5b1f17b1804b1-47939e48e88mr105233265e9.32.1765304655660;
        Tue, 09 Dec 2025 10:24:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG2N1U/qfn+cqUhT/IdKlmaO0Dfp9eCxkzBOQ6EPjCrkLOr7GnqGDK1Xhz5Rxxc3o/HgqTw+Q==
X-Received: by 2002:a05:600c:4f54:b0:477:b642:9dbf with SMTP id 5b1f17b1804b1-47939e48e88mr105233085e9.32.1765304655197;
        Tue, 09 Dec 2025 10:24:15 -0800 (PST)
Received: from redhat.com ([80.230.34.255])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a82d910b2sm3071355e9.14.2025.12.09.10.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 10:24:14 -0800 (PST)
Date: Tue, 9 Dec 2025 13:24:12 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com,
	virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
	oren@nvidia.com, aevdaev@nvidia.com, aaptel@nvidia.com
Subject: Re: [PATCH v2 1/1] virtio: add driver_override support
Message-ID: <20251209132326-mutt-send-email-mst@kernel.org>
References: <20251208220908.9250-1-mgurtovoy@nvidia.com>
 <20251209113306-mutt-send-email-mst@kernel.org>
 <49a3aabb-eb28-4149-b845-1bc5afffb985@nvidia.com>
 <20251209124819-mutt-send-email-mst@kernel.org>
 <df0d1e2e-a496-416a-8cfc-22d69ad4c37b@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df0d1e2e-a496-416a-8cfc-22d69ad4c37b@nvidia.com>

On Tue, Dec 09, 2025 at 08:20:45PM +0200, Max Gurtovoy wrote:
> 
> On 09/12/2025 19:48, Michael S. Tsirkin wrote:
> > On Tue, Dec 09, 2025 at 07:45:19PM +0200, Max Gurtovoy wrote:
> > > On 09/12/2025 18:34, Michael S. Tsirkin wrote:
> > > > On Tue, Dec 09, 2025 at 12:09:08AM +0200, Max Gurtovoy wrote:
> > > > > Add support for the 'driver_override' attribute to Virtio devices. This
> > > > > allows users to control which Virtio bus driver binds to a given Virtio
> > > > > device.
> > > > > 
> > > > > If 'driver_override' is not set, the existing behavior is preserved and
> > > > > devices will continue to auto-bind to the first matching Virtio bus
> > > > > driver.
> > > > oh, it's a device driver not the bus driver, actually.
> > > Yes. I'll fix the commit message.
> > > 
> > > 
> > > > > Tested with virtio blk device (virtio core and pci drivers are loaded):
> > > > > 
> > > > >     $ modprobe my_virtio_blk
> > > > > 
> > > > >     # automatically unbind from virtio_blk driver and override + bind to
> > > > >     # my_virtio_blk driver.
> > > > >     $ driverctl -v -b virtio set-override virtio0 my_virtio_blk
> > > > > 
> > > > > In addition, driverctl saves the configuration persistently under
> > > > > /etc/driverctl.d/.
> > > > what is this "mydriver" though? what are valid examples that
> > > > we want to support?
> > > This is an example for a custom virtio block driver.
> > > 
> > > It can be any custom virtio-XX driver (XX=FS/NET/..).
> > Is "custom" a way to say "out of tree"?
> 
> The driver_override mechanism fits both in-tree/out-of-tree drivers.

good to know.  which in tree drivers can use it?
this is the part that's missing in the commit log.

thanks


> > 
> > > > > Signed-off-by: Avraham Evdaev <aevdaev@nvidia.com>
> > > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > > ---
> > > > > 
> > > > > changes from v1:
> > > > >    - use !strcmp() to compare strings (MST)
> > > > >    - extend commit msg with example (MST)
> > > > > 
> > > > > ---
> > > > >    drivers/virtio/virtio.c | 34 ++++++++++++++++++++++++++++++++++
> > > > >    include/linux/virtio.h  |  4 ++++
> > > > >    2 files changed, 38 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > > > > index a09eb4d62f82..993dc928be49 100644
> > > > > --- a/drivers/virtio/virtio.c
> > > > > +++ b/drivers/virtio/virtio.c
> > > > > @@ -61,12 +61,41 @@ static ssize_t features_show(struct device *_d,
> > > > >    }
> > > > >    static DEVICE_ATTR_RO(features);
> > > > > +static ssize_t driver_override_store(struct device *_d,
> > > > > +				     struct device_attribute *attr,
> > > > > +				     const char *buf, size_t count)
> > > > > +{
> > > > > +	struct virtio_device *dev = dev_to_virtio(_d);
> > > > > +	int ret;
> > > > > +
> > > > > +	ret = driver_set_override(_d, &dev->driver_override, buf, count);
> > > > > +	if (ret)
> > > > > +		return ret;
> > > > > +
> > > > > +	return count;
> > > > > +}
> > > > > +
> > > > > +static ssize_t driver_override_show(struct device *_d,
> > > > > +				    struct device_attribute *attr, char *buf)
> > > > > +{
> > > > > +	struct virtio_device *dev = dev_to_virtio(_d);
> > > > > +	ssize_t len;
> > > > > +
> > > > > +	device_lock(_d);
> > > > > +	len = sysfs_emit(buf, "%s\n", dev->driver_override);
> > > > > +	device_unlock(_d);
> > > > > +
> > > > > +	return len;
> > > > > +}
> > > > > +static DEVICE_ATTR_RW(driver_override);
> > > > > +
> > > > >    static struct attribute *virtio_dev_attrs[] = {
> > > > >    	&dev_attr_device.attr,
> > > > >    	&dev_attr_vendor.attr,
> > > > >    	&dev_attr_status.attr,
> > > > >    	&dev_attr_modalias.attr,
> > > > >    	&dev_attr_features.attr,
> > > > > +	&dev_attr_driver_override.attr,
> > > > >    	NULL,
> > > > >    };
> > > > >    ATTRIBUTE_GROUPS(virtio_dev);
> > > > > @@ -88,6 +117,10 @@ static int virtio_dev_match(struct device *_dv, const struct device_driver *_dr)
> > > > >    	struct virtio_device *dev = dev_to_virtio(_dv);
> > > > >    	const struct virtio_device_id *ids;
> > > > > +	/* Check override first, and if set, only use the named driver */
> > > > > +	if (dev->driver_override)
> > > > > +		return !strcmp(dev->driver_override, _dr->name);
> > > > > +
> > > > >    	ids = drv_to_virtio(_dr)->id_table;
> > > > >    	for (i = 0; ids[i].device; i++)
> > > > >    		if (virtio_id_match(dev, &ids[i]))
> > > > > @@ -582,6 +615,7 @@ void unregister_virtio_device(struct virtio_device *dev)
> > > > >    {
> > > > >    	int index = dev->index; /* save for after device release */
> > > > > +	kfree(dev->driver_override);
> > > > >    	device_unregister(&dev->dev);
> > > > >    	virtio_debug_device_exit(dev);
> > > > >    	ida_free(&virtio_index_ida, index);
> > > > > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > > > > index db31fc6f4f1f..418bb490bdc6 100644
> > > > > --- a/include/linux/virtio.h
> > > > > +++ b/include/linux/virtio.h
> > > > > @@ -138,6 +138,9 @@ struct virtio_admin_cmd {
> > > > >     * @config_lock: protects configuration change reporting
> > > > >     * @vqs_list_lock: protects @vqs.
> > > > >     * @dev: underlying device.
> > > > > + * @driver_override: driver name to force a match; do not set directly,
> > > > > + *                   because core frees it; use driver_set_override() to
> > > > > + *                   set or clear it.
> > > > >     * @id: the device type identification (used to match it with a driver).
> > > > >     * @config: the configuration ops for this device.
> > > > >     * @vringh_config: configuration ops for host vrings.
> > > > > @@ -158,6 +161,7 @@ struct virtio_device {
> > > > >    	spinlock_t config_lock;
> > > > >    	spinlock_t vqs_list_lock;
> > > > >    	struct device dev;
> > > > > +	const char *driver_override;
> > > > >    	struct virtio_device_id id;
> > > > >    	const struct virtio_config_ops *config;
> > > > >    	const struct vringh_config_ops *vringh_config;
> > > > > -- 
> > > > > 2.18.1


