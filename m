Return-Path: <kvm+bounces-13096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72EEC891F7D
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 16:05:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3D4B1C28DC8
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 15:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C42155A5F;
	Fri, 29 Mar 2024 13:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+quUCH2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCD8155A46
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 13:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711718927; cv=none; b=OfhIXL7ppLMXRIxdQjF2o8Fs7AEPryZ2iFE0vI3hyr1dT81qahBAgM5xyFEe6D6f48aSxUds/Rk12ahESryz9AXQwTdlgeVB17Xhd5nWoyK9XYjoqOOzkZ8A7A1JvPAd3DOtMW7y5ZlBeIVbly3r8Ama9vTyL/ai5blvLhj13WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711718927; c=relaxed/simple;
	bh=zlmV0sBDPPllGZWjPqa2/c1/r7nXDK5/rzJZO9Fvals=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhYo96Xasp9B19vAjSANnpTspb3Isoo7aw3/rPDTBM3zuTWC9i4DqKzku/PMZuC9X3RgXOx5M5Cr3KD3uJ8fVRcSjsLy2sE1AfAcmNsRosnj8NTkKcYCTBInIeZRgITVmS7bam8JdfSkPnf5c32DuUFQNE8zi/05F/mY6dxZ4NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+quUCH2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711718925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9b2+syugljaMrrOP++3j3QqL3+aM8ytb7iOaLk3Q4wQ=;
	b=S+quUCH2AVxFUWI8ays1z6iM+Jv8/SFTHHrSHQlfFqY75RoKW4avjNvcu3du+1S28VWYEj
	/2skUku1lsFTy5vJvLtCxHro+YOneDB2/zI1Nj/maKWxzLToftr3Jr5hxWRIDcnk4/br97
	8QHTinJ3InCcd4o9FJad6wjPWpjJ/QE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-FA8kuZpKP8mcGYKlA9132A-1; Fri, 29 Mar 2024 09:28:36 -0400
X-MC-Unique: FA8kuZpKP8mcGYKlA9132A-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33ed44cb765so1145152f8f.2
        for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 06:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711718915; x=1712323715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9b2+syugljaMrrOP++3j3QqL3+aM8ytb7iOaLk3Q4wQ=;
        b=wNYmmRkJF1+hwIQpbHJB6YXcHtR4XUafNm6N+/AkNAnrb4xdUqbGzZGydAC5CIGcte
         J2D9j4RNKHbggfHdD6cL/GMABAoNFcJTRL19KNiRypkYQAipdo4oEH4EyevQwJ10oBhP
         foLmukE1PRMJUB8DITIsQXUYtuBUqN+XPq9ddrkqvQ5PTJ9VhaP/nYSzV2w2OuIVYsTK
         DiYsDKzMRDAM4fiGOzflCkI8tIGE7XaH+Eqtx03UeCIkbR7zmCNsXHrhyjyaPS5gF2VT
         5KMDRW9gTYplG4AlZHkd3oqsUhWZh7DJ8oyc03JT7MTh+BIZFzJKWQh2qPNl6L8z1YQH
         LHVw==
X-Forwarded-Encrypted: i=1; AJvYcCXvtiepAQXmxPPcD661c6cHynPJshJLL9kfIux7jWXW1rKUmWnZG5KtDlwCw5NRNDroHlDqwCZflkRGjxF7js5h+Xny
X-Gm-Message-State: AOJu0Yw+YAyBPq57Mo4+osmSuhURSkwCNK1zH4+zy26VKVxeTlJUd7Nz
	auFoP+J7vpkxc5KmXfu0MMxapCBlOJV3IQogGWByhgTXutYY3Q/ZNzRpbYCTxbH5ePs1y6NufiU
	Eoh3QxcLggH8T1sj0Aogl3GskIgKXutitDDGyu1yN1FqxXeTY/w==
X-Received: by 2002:a05:6000:258:b0:343:3e54:6208 with SMTP id m24-20020a056000025800b003433e546208mr405100wrz.55.1711718915577;
        Fri, 29 Mar 2024 06:28:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0y693U6Mrafzyu7YFm6f17FVsvRLIAvGL111PeLg9URymVxfxN4rrw7+XNw571qiaGR1ycw==
X-Received: by 2002:a05:6000:258:b0:343:3e54:6208 with SMTP id m24-20020a056000025800b003433e546208mr405040wrz.55.1711718915211;
        Fri, 29 Mar 2024 06:28:35 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-33.business.telecomitalia.it. [87.12.25.33])
        by smtp.gmail.com with ESMTPSA id e11-20020a056000194b00b00341c6b53358sm4171063wry.66.2024.03.29.06.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 06:28:34 -0700 (PDT)
Date: Fri, 29 Mar 2024 14:28:27 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Paolo Bonzini <pbonzini@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gonglei <arei.gonglei@huawei.com>, 
	"David S. Miller" <davem@davemloft.net>, Viresh Kumar <vireshk@kernel.org>, 
	Linus Walleij <linus.walleij@linaro.org>, Bartosz Golaszewski <brgl@bgdev.pl>, 
	David Airlie <airlied@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu <olvaffe@gmail.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Joerg Roedel <joro@8bytes.org>, Alexander Graf <graf@amazon.com>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, Kalle Valo <kvalo@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Anton Yakovlev <anton.yakovlev@opensynergy.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	v9fs@lists.linux.dev, kvm@vger.kernel.org, linux-wireless@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, alsa-devel@alsa-project.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 01/22] virtio: store owner from modules with
 register_virtio_driver()
Message-ID: <e2xy5kjdctpitcrev2byqc5gcwntvsd6pfutrvp3l2kfe3llgs@l2xp5opj7xu2>
References: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
 <20240327-module-owner-virtio-v1-1-0feffab77d99@linaro.org>
 <oaoiehcpkjs3wrhc22pwx676pompxml2z5dcq32a6fvsyntonw@hnohrbbp6wpm>
 <d01cc73e-a365-4ce8-a25f-780ea45bc581@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d01cc73e-a365-4ce8-a25f-780ea45bc581@linaro.org>

On Fri, Mar 29, 2024 at 01:07:31PM +0100, Krzysztof Kozlowski wrote:
>On 29/03/2024 12:42, Stefano Garzarella wrote:
>>> };
>>>
>>> -int register_virtio_driver(struct virtio_driver *driver)
>>> +int __register_virtio_driver(struct virtio_driver *driver, struct module *owner)
>>> {
>>> 	/* Catch this early. */
>>> 	BUG_ON(driver->feature_table_size && !driver->feature_table);
>>> 	driver->driver.bus = &virtio_bus;
>>> +	driver->driver.owner = owner;
>>> +
>>
>> `.driver.name =  KBUILD_MODNAME` also seems very common, should we put
>> that in the macro as well?
>
>This is a bit different thing. Every driver is expected to set owner to
>itself (THIS_MODULE), but is every driver name KBUILD_MODNAME?

Nope, IIUC we have 2 exceptions:
- drivers/firmware/arm_scmi/virtio.c
- arch/um/drivers/virt-pci.c

>Remember that this overrides whatever driver actually put there.

They can call __register_virtio_driver() where we can add the `name`
parameter. That said, I don't have a strong opinion, we can leave it
as it is.

Thanks,
Stefano


