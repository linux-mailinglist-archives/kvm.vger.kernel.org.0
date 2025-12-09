Return-Path: <kvm+bounces-65579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E0454CB0C56
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 18:48:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7874A30A1831
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 17:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BEDB32E6A8;
	Tue,  9 Dec 2025 17:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b+hXtKw3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ctLkl4XK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2520B2BE7AB
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765302527; cv=none; b=paIPFEgsvSyI8yWjEF9DNQCXLOKPqqrqhgvzUoA8JVk8N+07m352dmrQBHqcmf4zl4Ig35lzN9aZ8qU5v1CtLwNb0So29GdUBapbpu7LrcJ67Kuby8gH50D/PgrioKHrMPKBdCB6/Twm9ZdRUMPbODXOgmj/uzo6w1Zl+wKGlhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765302527; c=relaxed/simple;
	bh=K0ibrbryHWA8nhR7V2WWbJtZNyh1iYz3h92NfYNz0iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DSnZMfWNXDANUEELgi676bBFb5uhybp6IOyqk/wzwCrYuif6eeFCHXrqwHACxZkIOsW/O+88xJ0YQui21tgWTdBDk/yspWHZyeuxpEo5ItKVdHOO8h9DoPKsf1uk1dUVNFzYfJXcLZPFb1JZl2cdQfr96qZODJZfbWzGhj3KYU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b+hXtKw3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ctLkl4XK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765302524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Wds+RnykkG8gXthSZ5oxSbSivYlkrug9sYVYpvvQME=;
	b=b+hXtKw3nqKglLSE3JzhVTlTzp2OQLp8inPknemmnAqab3GUpdirZtYIEXZZuN+ayQYfln
	Kr0nqs2SD/TCYEAm1l7T8BwlOdTZ7aIZvKUEX/hQxT0uYRDHSz5nX4+DFS71QQITm53Gmf
	nw5Ssy3DYUNpGD9+YivudNgZB2zkTAM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-wBG6WIH_PCaNKQog7Lx7WQ-1; Tue, 09 Dec 2025 12:48:40 -0500
X-MC-Unique: wBG6WIH_PCaNKQog7Lx7WQ-1
X-Mimecast-MFC-AGG-ID: wBG6WIH_PCaNKQog7Lx7WQ_1765302519
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42e2e448d01so4671457f8f.1
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 09:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765302519; x=1765907319; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Wds+RnykkG8gXthSZ5oxSbSivYlkrug9sYVYpvvQME=;
        b=ctLkl4XKJU9ZyIm6pycQcwq14AjiKHFkKI5usYjX67OV5I/xQUu96t2sUFk73c8tp/
         UlyFC4Mk10+1JI+2Qfq9p0dMjcm88s4mcHrC0OtdxIuCdIHe/MjVioevQv2vsMdJ4lIV
         bvL6/qgYcsJuHicNSawiuDY6mc34Zw+VJotwNS7JRmTPYUEC2vXmBOtfdbgfQHMH0IWg
         HY1+mhdOVOXRb14BwMlAt15ooROtszINDEpjjHpi5tyOb50LSxcOVsEzb8p0WiDv2n/4
         N68c/fCuvcZsh3SVUUf1/R7lS5VSlg0vu/qZcLHjA7Lby+tBfEmE7yDljmjWf5/QPVy+
         tOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765302519; x=1765907319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Wds+RnykkG8gXthSZ5oxSbSivYlkrug9sYVYpvvQME=;
        b=QU6Hp8bDmvUV5Svt0WXVt9Jbc0dNgZlCmdeYBxKbJg6RBp97SOT/SsWQGzZNEmIK2K
         kkUDgaimgVRt5g2/UJeAgg+abLu2FFAssmEdC1TIF6ht5kqdTai0cplIb33DEfSAaiwM
         8IuOZ7ye2iu64LWWXcb57XA88uLVwH2VcFZS+7W2u7xWU7M9ZJgmGRpb/kOpeHJHexmh
         XYaK+57eI1xEw/FsEZ+e2NmHpi0Tp1NYdwkaprbcmCgzJwRQzT+qGgbW/+BozTJDF5kh
         o913qPaRfJKu08lQU/ln0NLZGh6OQeX9E7sBJggpHDsXx58ij73mcQHqlxE007alskN0
         +KeA==
X-Forwarded-Encrypted: i=1; AJvYcCVLNGBAFMo42JdtDYmEN251eMFyLlZ0ntpLoseD2GWmW3aqXMpRtkM3Vlj4qo5yOPKhKjI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzErI7584hoZFclqz00FI6STs2iN/ii9xGMYhtXjjBjt0K5X7U6
	VTzlp9TziWZn/bE2mRRMyqmzbLZIocUaGm0pFawlfx4CeCwqRsL+NlEZ5w8bSH4xFTjfnMPjy/x
	UYvkMBqN3oRluPjfRrxFK83exr0ejqn7dsJn8t6CGy6Y3eJMDuZrwQQ==
X-Gm-Gg: AY/fxX4Nuo6ySvlACB3LZIgVlz4Ktg9kViapt7e2b4El/2uxmBYCuy/ybau38eNjakm
	wThhYt04rOgQvl5q1EZRHOCwOjRTZEOKWrtg4DZAswKvbenyqeyv8GiqLN8fXy6uuG5Fa0NCBN6
	gGhGyJv+kl0cLtZ5bXip8EHe1stKXnWeMzwHC2XX0rW6nKcbaDZQCsL8I7q7exqRsMlyEB8WDIn
	vwOz4VQkyrcnqv7/kpay0qB8dc4O0BanSvX5MvKN9aTfYD7BV0npkWapqs4+xLhjRxShcoZH+ce
	chASTKhwkc34ve3vgo1zQaKetsOGFpYINozAyQKd/u80feqDZGtCW1yRknqBREzEMxZSvwD5uX1
	J
X-Received: by 2002:a05:6000:402a:b0:42c:a449:d6a5 with SMTP id ffacd0b85a97d-42f89f3d718mr11473076f8f.34.1765302519294;
        Tue, 09 Dec 2025 09:48:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGNodAp4VRw+WDt0ClnkNSIgayKL8Y6tDD9ajoVtZAIm0NOGVQk4fbxwV5uQBvf9Fsn1fd/QA==
X-Received: by 2002:a05:6000:402a:b0:42c:a449:d6a5 with SMTP id ffacd0b85a97d-42f89f3d718mr11473038f8f.34.1765302518521;
        Tue, 09 Dec 2025 09:48:38 -0800 (PST)
Received: from redhat.com ([80.230.34.255])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d331092sm33270787f8f.30.2025.12.09.09.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 09:48:37 -0800 (PST)
Date: Tue, 9 Dec 2025 12:48:35 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com,
	virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
	oren@nvidia.com, aevdaev@nvidia.com, aaptel@nvidia.com
Subject: Re: [PATCH v2 1/1] virtio: add driver_override support
Message-ID: <20251209124819-mutt-send-email-mst@kernel.org>
References: <20251208220908.9250-1-mgurtovoy@nvidia.com>
 <20251209113306-mutt-send-email-mst@kernel.org>
 <49a3aabb-eb28-4149-b845-1bc5afffb985@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49a3aabb-eb28-4149-b845-1bc5afffb985@nvidia.com>

On Tue, Dec 09, 2025 at 07:45:19PM +0200, Max Gurtovoy wrote:
> 
> On 09/12/2025 18:34, Michael S. Tsirkin wrote:
> > On Tue, Dec 09, 2025 at 12:09:08AM +0200, Max Gurtovoy wrote:
> > > Add support for the 'driver_override' attribute to Virtio devices. This
> > > allows users to control which Virtio bus driver binds to a given Virtio
> > > device.
> > > 
> > > If 'driver_override' is not set, the existing behavior is preserved and
> > > devices will continue to auto-bind to the first matching Virtio bus
> > > driver.
> > oh, it's a device driver not the bus driver, actually.
> 
> Yes. I'll fix the commit message.
> 
> 
> > 
> > > Tested with virtio blk device (virtio core and pci drivers are loaded):
> > > 
> > >    $ modprobe my_virtio_blk
> > > 
> > >    # automatically unbind from virtio_blk driver and override + bind to
> > >    # my_virtio_blk driver.
> > >    $ driverctl -v -b virtio set-override virtio0 my_virtio_blk
> > > 
> > > In addition, driverctl saves the configuration persistently under
> > > /etc/driverctl.d/.
> > what is this "mydriver" though? what are valid examples that
> > we want to support?
> 
> This is an example for a custom virtio block driver.
> 
> It can be any custom virtio-XX driver (XX=FS/NET/..).

Is "custom" a way to say "out of tree"?

> > > Signed-off-by: Avraham Evdaev <aevdaev@nvidia.com>
> > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > ---
> > > 
> > > changes from v1:
> > >   - use !strcmp() to compare strings (MST)
> > >   - extend commit msg with example (MST)
> > > 
> > > ---
> > >   drivers/virtio/virtio.c | 34 ++++++++++++++++++++++++++++++++++
> > >   include/linux/virtio.h  |  4 ++++
> > >   2 files changed, 38 insertions(+)
> > > 
> > > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > > index a09eb4d62f82..993dc928be49 100644
> > > --- a/drivers/virtio/virtio.c
> > > +++ b/drivers/virtio/virtio.c
> > > @@ -61,12 +61,41 @@ static ssize_t features_show(struct device *_d,
> > >   }
> > >   static DEVICE_ATTR_RO(features);
> > > +static ssize_t driver_override_store(struct device *_d,
> > > +				     struct device_attribute *attr,
> > > +				     const char *buf, size_t count)
> > > +{
> > > +	struct virtio_device *dev = dev_to_virtio(_d);
> > > +	int ret;
> > > +
> > > +	ret = driver_set_override(_d, &dev->driver_override, buf, count);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	return count;
> > > +}
> > > +
> > > +static ssize_t driver_override_show(struct device *_d,
> > > +				    struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct virtio_device *dev = dev_to_virtio(_d);
> > > +	ssize_t len;
> > > +
> > > +	device_lock(_d);
> > > +	len = sysfs_emit(buf, "%s\n", dev->driver_override);
> > > +	device_unlock(_d);
> > > +
> > > +	return len;
> > > +}
> > > +static DEVICE_ATTR_RW(driver_override);
> > > +
> > >   static struct attribute *virtio_dev_attrs[] = {
> > >   	&dev_attr_device.attr,
> > >   	&dev_attr_vendor.attr,
> > >   	&dev_attr_status.attr,
> > >   	&dev_attr_modalias.attr,
> > >   	&dev_attr_features.attr,
> > > +	&dev_attr_driver_override.attr,
> > >   	NULL,
> > >   };
> > >   ATTRIBUTE_GROUPS(virtio_dev);
> > > @@ -88,6 +117,10 @@ static int virtio_dev_match(struct device *_dv, const struct device_driver *_dr)
> > >   	struct virtio_device *dev = dev_to_virtio(_dv);
> > >   	const struct virtio_device_id *ids;
> > > +	/* Check override first, and if set, only use the named driver */
> > > +	if (dev->driver_override)
> > > +		return !strcmp(dev->driver_override, _dr->name);
> > > +
> > >   	ids = drv_to_virtio(_dr)->id_table;
> > >   	for (i = 0; ids[i].device; i++)
> > >   		if (virtio_id_match(dev, &ids[i]))
> > > @@ -582,6 +615,7 @@ void unregister_virtio_device(struct virtio_device *dev)
> > >   {
> > >   	int index = dev->index; /* save for after device release */
> > > +	kfree(dev->driver_override);
> > >   	device_unregister(&dev->dev);
> > >   	virtio_debug_device_exit(dev);
> > >   	ida_free(&virtio_index_ida, index);
> > > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > > index db31fc6f4f1f..418bb490bdc6 100644
> > > --- a/include/linux/virtio.h
> > > +++ b/include/linux/virtio.h
> > > @@ -138,6 +138,9 @@ struct virtio_admin_cmd {
> > >    * @config_lock: protects configuration change reporting
> > >    * @vqs_list_lock: protects @vqs.
> > >    * @dev: underlying device.
> > > + * @driver_override: driver name to force a match; do not set directly,
> > > + *                   because core frees it; use driver_set_override() to
> > > + *                   set or clear it.
> > >    * @id: the device type identification (used to match it with a driver).
> > >    * @config: the configuration ops for this device.
> > >    * @vringh_config: configuration ops for host vrings.
> > > @@ -158,6 +161,7 @@ struct virtio_device {
> > >   	spinlock_t config_lock;
> > >   	spinlock_t vqs_list_lock;
> > >   	struct device dev;
> > > +	const char *driver_override;
> > >   	struct virtio_device_id id;
> > >   	const struct virtio_config_ops *config;
> > >   	const struct vringh_config_ops *vringh_config;
> > > -- 
> > > 2.18.1


