Return-Path: <kvm+bounces-19414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D4DB904C78
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:13:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 196D9284AFA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8613116C445;
	Wed, 12 Jun 2024 07:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QTmInuvb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C2AB651
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718176377; cv=none; b=oobUfkhJPz4AKvFeae1st9P5nof6TQB24R54XwT2UQMcqTR4knQQ3uP0LVTL2lkyN2ac1dJxQpELplCzMXWxxCli9hYHwQFbJksBxTIB/5+a1iYmuMNKIezAgYUargWY0yUUOvMtjsndDk2zSKGy88BX7yIOGPSfUgj42x2zm6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718176377; c=relaxed/simple;
	bh=FJ9BTeEbejPctTmHZIUK+28zrcodhwdsqUv2ldy1WOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KNtfxaeEta01OsZ1FFzXbx1A4XxTmvvEzif3aaM+Hm+UZBYeBtR/HLs24CjV0SjxUF6dUk1aUZiA5KFh4R9+l6I2rVj3GZ43eQXjLNsVnwnPBOP94NHqsHpTC9AJv250GKcfVL0Vg7SAie2bfC/cb5drPHNN5dGWK3Nh3732uP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QTmInuvb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718176374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0AdGqhESB7FcgdEdVmtQDKt7grmbOEq0F0SyTtNx6No=;
	b=QTmInuvb+1LJ6LC0AWoqlTO9MxkNXYI10dUUDghNrBClPT9VhrDl5bUkDfKLVJuM2GpIwr
	IU1qLqvMLsgw9kpM2TziJN8mKKK+jxNps1jClcp4UMXDoHmwQKoRGvStWYr3rlYlFp4PTJ
	/F09GDxLEb8gckP0LANXCf0BGgnVit0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-8KEwm3TUO5eaSxiUSRQ_iA-1; Wed, 12 Jun 2024 03:12:52 -0400
X-MC-Unique: 8KEwm3TUO5eaSxiUSRQ_iA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42181a81354so26255585e9.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 00:12:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718176372; x=1718781172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0AdGqhESB7FcgdEdVmtQDKt7grmbOEq0F0SyTtNx6No=;
        b=o2xre2mwxx9CjolGT9F8dS7/EEc5mvv5YNZy3kh96p5pJfbk2txwl5rigE5IEczQ8J
         Ml6KUk6g/gAXmNk/nkl9cPzSJHGUDD9Yc5p5Bs0rZiF7A4QyzdDS5bUWaQa4vkTwACLB
         1uR/PyS4OkhfQ1lhjCimZVzUSEmYhTTUahadkepYFOpGFcpNa2xvJd0Na3zwoc04QLWa
         Y96k6PrJbbIeXFK2URrFJ/GQpLHeaWtwpq2kxl14iwhHmdiBSKIRdEAV4H7BIFEwDCZW
         3xreBKMn+0xwmLxkRSEFS1GpmiAOTKQHbXVN5ovHp1Z/x+RKxWaS58hgSdcACiZpWlLX
         vLPA==
X-Forwarded-Encrypted: i=1; AJvYcCXyhDUWqJYzmzvuQ/pJm0Xhp7WK+MHEFU8VYDBplgTykStwg9e/zk3jNXmwcHOWsMVyvIVD7FQbikZBAvmuJlLbMd39
X-Gm-Message-State: AOJu0YyNE0EEljzTrFDHR5BQupJwN1M4xfLG/Kdk9YTWr8sdrsgc0N15
	H+SncYbDr7e7/7HJEjlc+IvCfUwqMgJPshouU1ce9Oh/m3/NIDa4xjK1l6HLAjJ37Y73Fo2+uP5
	R/zvpw/PKc7Mpv8TjTpcitGftNcOohLpdrEENIPjzeqiduCtPIQ==
X-Received: by 2002:a05:600c:3552:b0:421:7be5:f318 with SMTP id 5b1f17b1804b1-422867c0408mr7204585e9.33.1718176371644;
        Wed, 12 Jun 2024 00:12:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGphusi1X4I6zrV9eu6daKqPEPomJK6FFUdfburgBDZrRG2/0lanC4F2ufq6sccZD88eQM6rQ==
X-Received: by 2002:a05:600c:3552:b0:421:7be5:f318 with SMTP id 5b1f17b1804b1-422867c0408mr7204415e9.33.1718176371029;
        Wed, 12 Jun 2024 00:12:51 -0700 (PDT)
Received: from redhat.com ([2a02:14f:178:39eb:4161:d39d:43e6:41f8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422874de5d5sm13703115e9.33.2024.06.12.00.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 00:12:50 -0700 (PDT)
Date: Wed, 12 Jun 2024 03:12:47 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cindy Lu <lulu@redhat.com>
Cc: dtatulea@nvidia.com, jasowang@redhat.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Message-ID: <20240612014143-mutt-send-email-mst@kernel.org>
References: <20240611053239.516996-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611053239.516996-1-lulu@redhat.com>

On Tue, Jun 11, 2024 at 01:32:32PM +0800, Cindy Lu wrote:
> Add new UAPI to support the mac address from vdpa tool

The patch does not do what commit log says.
Instead there's an internal API to set mac and
a UAPI to write into config space.

> Function vdpa_nl_cmd_dev_config_set_doit() will get the
> MAC address from the vdpa tool and then set it to the device.
> 
> The usage is: vdpa dev set name vdpa_name mac **:**:**:**:**:**
> 
> Here is sample:
> root@L1# vdpa -jp dev config show vdpa0
> {
>     "config": {
>         "vdpa0": {
>             "mac": "82:4d:e9:5d:d7:e6",
>             "link ": "up",
>             "link_announce ": false,
>             "mtu": 1500
>         }
>     }
> }
> 
> root@L1# vdpa dev set name vdpa0 mac 00:11:22:33:44:55
> 
> root@L1# vdpa -jp dev config show vdpa0
> {
>     "config": {
>         "vdpa0": {
>             "mac": "00:11:22:33:44:55",
>             "link ": "up",
>             "link_announce ": false,
>             "mtu": 1500
>         }
>     }
> }
> 
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vdpa/vdpa.c       | 71 +++++++++++++++++++++++++++++++++++++++
>  include/linux/vdpa.h      |  2 ++
>  include/uapi/linux/vdpa.h |  1 +
>  3 files changed, 74 insertions(+)
> 
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index a7612e0783b3..347ae6e7749d 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -1149,6 +1149,72 @@ static int vdpa_nl_cmd_dev_config_get_doit(struct sk_buff *skb, struct genl_info
>  	return err;
>  }
>  
> +static int vdpa_nl_cmd_dev_config_set_doit(struct sk_buff *skb,
> +					   struct genl_info *info)
> +{
> +	struct vdpa_dev_set_config set_config = {};
> +	struct nlattr **nl_attrs = info->attrs;
> +	struct vdpa_mgmt_dev *mdev;
> +	const u8 *macaddr;
> +	const char *name;
> +	int err = 0;
> +	struct device *dev;
> +	struct vdpa_device *vdev;
> +
> +	if (!info->attrs[VDPA_ATTR_DEV_NAME])
> +		return -EINVAL;
> +
> +	name = nla_data(info->attrs[VDPA_ATTR_DEV_NAME]);
> +
> +	down_write(&vdpa_dev_lock);
> +	dev = bus_find_device(&vdpa_bus, NULL, name, vdpa_name_match);
> +	if (!dev) {
> +		NL_SET_ERR_MSG_MOD(info->extack, "device not found");
> +		err = -ENODEV;
> +		goto dev_err;
> +	}
> +	vdev = container_of(dev, struct vdpa_device, dev);
> +	if (!vdev->mdev) {
> +		NL_SET_ERR_MSG_MOD(
> +			info->extack,
> +			"Fail to find the specified management device");
> +		err = -EINVAL;
> +		goto mdev_err;
> +	}
> +	mdev = vdev->mdev;
> +	if (nl_attrs[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
> +		if (!(mdev->supported_features & BIT_ULL(VIRTIO_NET_F_MAC))) {


Seems to poke at a device without even making sure it's a network
device.

> +			NL_SET_ERR_MSG_FMT_MOD(
> +				info->extack,
> +				"Missing features 0x%llx for provided attributes",
> +				BIT_ULL(VIRTIO_NET_F_MAC));
> +			err = -EINVAL;
> +			goto mdev_err;
> +		}
> +		macaddr = nla_data(nl_attrs[VDPA_ATTR_DEV_NET_CFG_MACADDR]);
> +		memcpy(set_config.net.mac, macaddr, ETH_ALEN);
> +		set_config.mask |= BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR);
> +		if (mdev->ops->set_mac) {
> +			err = mdev->ops->set_mac(mdev, vdev, &set_config);
> +		} else {
> +			NL_SET_ERR_MSG_FMT_MOD(
> +				info->extack,
> +				"%s device not support set mac address ", name);
> +		}
> +
> +	} else {
> +		NL_SET_ERR_MSG_FMT_MOD(info->extack,
> +				       "%s device not support this config ",
> +				       name);
> +	}
> +
> +mdev_err:
> +	put_device(dev);
> +dev_err:
> +	up_write(&vdpa_dev_lock);
> +	return err;
> +}
> +
>  static int vdpa_dev_config_dump(struct device *dev, void *data)
>  {
>  	struct vdpa_device *vdev = container_of(dev, struct vdpa_device, dev);
> @@ -1285,6 +1351,11 @@ static const struct genl_ops vdpa_nl_ops[] = {
>  		.doit = vdpa_nl_cmd_dev_stats_get_doit,
>  		.flags = GENL_ADMIN_PERM,
>  	},
> +	{
> +		.cmd = VDPA_CMD_DEV_CONFIG_SET,
> +		.doit = vdpa_nl_cmd_dev_config_set_doit,
> +		.flags = GENL_ADMIN_PERM,
> +	},
>  };
>  
>  static struct genl_family vdpa_nl_family __ro_after_init = {
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index db15ac07f8a6..c97f4f1da753 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -581,6 +581,8 @@ struct vdpa_mgmtdev_ops {
>  	int (*dev_add)(struct vdpa_mgmt_dev *mdev, const char *name,
>  		       const struct vdpa_dev_set_config *config);
>  	void (*dev_del)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev);
> +	int (*set_mac)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev,
> +		       const struct vdpa_dev_set_config *config);


Well, now vdpa_mgmtdev_ops which was completely generic is growing
a net specific interface. Which begs a question - how is this
going to work with other device types?

>  };
>  
>  /**
> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
> index 54b649ab0f22..53f249fb26bc 100644
> --- a/include/uapi/linux/vdpa.h
> +++ b/include/uapi/linux/vdpa.h
> @@ -19,6 +19,7 @@ enum vdpa_command {
>  	VDPA_CMD_DEV_GET,		/* can dump */
>  	VDPA_CMD_DEV_CONFIG_GET,	/* can dump */
>  	VDPA_CMD_DEV_VSTATS_GET,
> +	VDPA_CMD_DEV_CONFIG_SET,
>  };
>  
>  enum vdpa_attr {
> -- 
> 2.45.0


