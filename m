Return-Path: <kvm+bounces-2882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8347D7FEC34
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:52:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E0CF281FC6
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744DE3A29D;
	Thu, 30 Nov 2023 09:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dKcv3oy1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE24210C9
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701337960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=syzny7hYQCh/DH3BoavsbNlrR+AhgJLrIIbJQwb1FFo=;
	b=dKcv3oy19LUmpz4gp0DAVw6kQFpiNmZzYz1i2r8a8yafp3svC5T/e8t7skkQKlcjsTw9u9
	ccvrONBBEsL1xo5FHbPzXBgB29lGxc90a3YAZFqkMZweR4qXDQP+MhUIkqYmRgvxEelBoC
	HEohkvUe66pAycE7w/tLRmWTB75vD7Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-lq61hPTiNlq1jMblxr-kqg-1; Thu, 30 Nov 2023 04:52:38 -0500
X-MC-Unique: lq61hPTiNlq1jMblxr-kqg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-332e2e0b98bso755690f8f.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:52:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701337958; x=1701942758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=syzny7hYQCh/DH3BoavsbNlrR+AhgJLrIIbJQwb1FFo=;
        b=qRlcW/gQO7RpagacJwdgmb3EwELZgH2/ERijqe+JIQSkiTkbUgSKm5edek3PD2TQJT
         TpJvmh4t1wKXoL7bDlfI0knXKvU0XOpBYXNI16I08H9YTfbr6iE/3cK7Ya+BqTplJJU+
         dv7FY5CutXbjFIcSo/d64lg+Y/lrSSneoQ2ylm6DFWywg/qN7nJWRxUEklRu9HXJF7GS
         JCg1fGuQvM36p8uSJVlipt+dDgHxjrHM2DF4HTXvvdaDf5to00yZnEP1617HPwN988N+
         RRcLasayHEbHEZ0jYlMP2fB0b6cwYgLbKIWGhwLfwQ+qHFyF0WvxUOcpbQuzVtIE1IdZ
         K8ow==
X-Gm-Message-State: AOJu0YwCyEyPyFBc6Psp/ttlzyw1+UE17pCmWTHOk5REwRzS8nkmssiK
	iHdTWaRTn9Vml9l3pwAJDCMGLZBVbIY7p+sfDnu3i+Gm1SEV1wq7UXQw2cFc38Ky2w3OsVMY4ur
	4VP1BCKwzRO6v
X-Received: by 2002:a5d:6750:0:b0:332:ee15:7182 with SMTP id l16-20020a5d6750000000b00332ee157182mr14800384wrw.11.1701337957905;
        Thu, 30 Nov 2023 01:52:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHOAPePhLEf8K1B9QypzK3aIQgJmwveh/+E4piPyr4Plo37pFs9D8biAp8SlmNK5YCWYRNjZA==
X-Received: by 2002:a5d:6750:0:b0:332:ee15:7182 with SMTP id l16-20020a5d6750000000b00332ee157182mr14800369wrw.11.1701337957582;
        Thu, 30 Nov 2023 01:52:37 -0800 (PST)
Received: from redhat.com ([2.55.10.128])
        by smtp.gmail.com with ESMTPSA id w8-20020adfee48000000b0033304787251sm1024857wro.17.2023.11.30.01.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 01:52:36 -0800 (PST)
Date: Thu, 30 Nov 2023 04:52:33 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V4 vfio 4/9] virtio-pci: Introduce admin commands
Message-ID: <20231130044910-mutt-send-email-mst@kernel.org>
References: <20231129143746.6153-1-yishaih@nvidia.com>
 <20231129143746.6153-5-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129143746.6153-5-yishaih@nvidia.com>

On Wed, Nov 29, 2023 at 04:37:41PM +0200, Yishai Hadas wrote:
> +/* Transitional device admin command. */
> +#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE	0x2
> +#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ		0x3
> +#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE		0x4
> +#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
> +#define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
> +
> +/* Increment MAX_OPCODE to next value when new opcode is added */
> +#define VIRTIO_ADMIN_MAX_CMD_OPCODE			0x6

Does anything need VIRTIO_ADMIN_MAX_CMD_OPCODE? Not in this
patchset...

-- 
MST


