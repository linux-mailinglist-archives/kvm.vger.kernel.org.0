Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88F63114E5
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 23:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbhBEWR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 17:17:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50477 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232735AbhBEOfo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 09:35:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612541582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5zJF7iuXnudexlnvrDsie00riA//JRoTFejPvAO5inY=;
        b=bIAk64PQL1192TyrX9iqSZ+5lpks9a7axEBrGUG6I7dHuLp9ZAN1LjKsIpd95qyzAslvIc
        lEAeYFDg87N3/WNmD39QrtIjQr6dXtSF1ZDmEmQl+TQ0lY+vLQEYATnarCOJBSE7Cz/1ec
        XwZZFBgQqzVyVCwU0B2fKBK8mFkcN+Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-ZyJrTyPFM3WInZHo2mg3IA-1; Fri, 05 Feb 2021 09:11:32 -0500
X-MC-Unique: ZyJrTyPFM3WInZHo2mg3IA-1
Received: by mail-wm1-f70.google.com with SMTP id h25so3016379wmb.6
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 06:11:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5zJF7iuXnudexlnvrDsie00riA//JRoTFejPvAO5inY=;
        b=Oxse43iHz4LAx2O7xQLmS1531Ru4MBspCjuqB4d0wERVepmGTSsPL9Fr8VZaU6Yav6
         Te7vMEIIimBd6Cg5yB2+pB8DEunvNwQGHBQNbjMNnGwJYjj3Ugik+LUHgNZ3GskkaNzz
         lrbUZJ4AdWRV/g14P8xfamQf/rMOCjGsQVeNH6KsJsWthY3FWX7msK5tYinCwLm3ctq6
         LTnvmX67++XOWfzClmqNB0VjKbWxkVK1Viay1euPgTz2iWjLMnQQMBHVkv+CGIqx6BxQ
         Kzlt8tCqdEJVk0e4auVVYrQ1FCoO9LjGUycTKZJ+mUeH61L+sItqub7wZFh/F/9kiFyK
         fEcA==
X-Gm-Message-State: AOAM533OoNgjuLYX3VHVI4KpJY5crQkGXk2b0zWPqvbK8OkPSeet0XD5
        3+eCbdcxS3+iWn1Hw3c9TtHFPIsbKOdLnlNUSlX30t0XFnu/5JosHY+NvgBDEt15Yzyi4QQjTPi
        HPqVzJ7/gE0jU
X-Received: by 2002:a1c:2ed4:: with SMTP id u203mr3822674wmu.45.1612534291425;
        Fri, 05 Feb 2021 06:11:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSg+HHzDXB2BGX+TaLFCEKbGu1PNRXWRqnpd7Z4UyG/TKgPiXwo7pDwidZbOFLUx261YnLyg==
X-Received: by 2002:a1c:2ed4:: with SMTP id u203mr3822642wmu.45.1612534291150;
        Fri, 05 Feb 2021 06:11:31 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id a16sm12668023wrr.89.2021.02.05.06.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:11:30 -0800 (PST)
Date:   Fri, 5 Feb 2021 09:11:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 08/13] vdpa: add return value to get_config/set_config
 callbacks
Message-ID: <20210205091123-mutt-send-email-mst@kernel.org>
References: <20210204172230.85853-1-sgarzare@redhat.com>
 <20210204172230.85853-9-sgarzare@redhat.com>
 <fe6d02be-b6f9-b07f-a86b-97912dddffdc@redhat.com>
 <20210205084847.d4pkqq2sbqs3p53r@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210205084847.d4pkqq2sbqs3p53r@steredhat>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 09:48:47AM +0100, Stefano Garzarella wrote:
> Adding Eli in the loop.
> 
> On Fri, Feb 05, 2021 at 11:20:11AM +0800, Jason Wang wrote:
> > 
> > On 2021/2/5 上午1:22, Stefano Garzarella wrote:
> > > All implementations of these callbacks already validate inputs.
> > > 
> > > Let's return an error from these callbacks, so the caller doesn't
> > > need to validate the input anymore.
> > > 
> > > We update all implementations to return -EINVAL in case of invalid
> > > input.
> > > 
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > >  include/linux/vdpa.h              | 18 ++++++++++--------
> > >  drivers/vdpa/ifcvf/ifcvf_main.c   | 24 ++++++++++++++++--------
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 17 +++++++++++------
> > >  drivers/vdpa/vdpa_sim/vdpa_sim.c  | 16 ++++++++++------
> > >  4 files changed, 47 insertions(+), 28 deletions(-)
> > > 
> > > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> > > index 4ab5494503a8..0e0cbd5fb41b 100644
> > > --- a/include/linux/vdpa.h
> > > +++ b/include/linux/vdpa.h
> > > @@ -157,6 +157,7 @@ struct vdpa_iova_range {
> > >   *				@buf: buffer used to read to
> > >   *				@len: the length to read from
> > >   *				configuration space
> > > + *				Returns integer: success (0) or error (< 0)
> > >   * @set_config:			Write to device specific configuration space
> > >   *				@vdev: vdpa device
> > >   *				@offset: offset from the beginning of
> > > @@ -164,6 +165,7 @@ struct vdpa_iova_range {
> > >   *				@buf: buffer used to write from
> > >   *				@len: the length to write to
> > >   *				configuration space
> > > + *				Returns integer: success (0) or error (< 0)
> > >   * @get_generation:		Get device config generation (optional)
> > >   *				@vdev: vdpa device
> > >   *				Returns u32: device generation
> > > @@ -231,10 +233,10 @@ struct vdpa_config_ops {
> > >  	u32 (*get_vendor_id)(struct vdpa_device *vdev);
> > >  	u8 (*get_status)(struct vdpa_device *vdev);
> > >  	void (*set_status)(struct vdpa_device *vdev, u8 status);
> > > -	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> > > -			   void *buf, unsigned int len);
> > > -	void (*set_config)(struct vdpa_device *vdev, unsigned int offset,
> > > -			   const void *buf, unsigned int len);
> > > +	int (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> > > +			  void *buf, unsigned int len);
> > > +	int (*set_config)(struct vdpa_device *vdev, unsigned int offset,
> > > +			  const void *buf, unsigned int len);
> > >  	u32 (*get_generation)(struct vdpa_device *vdev);
> > >  	struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
> > > @@ -329,8 +331,8 @@ static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
> > >  }
> > > -static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
> > > -				   void *buf, unsigned int len)
> > > +static inline int vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
> > > +				  void *buf, unsigned int len)
> > >  {
> > >          const struct vdpa_config_ops *ops = vdev->config;
> > > @@ -339,8 +341,8 @@ static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
> > >  	 * If it does happen we assume a legacy guest.
> > >  	 */
> > >  	if (!vdev->features_valid)
> > > -		vdpa_set_features(vdev, 0);
> > > -	ops->get_config(vdev, offset, buf, len);
> > > +		return vdpa_set_features(vdev, 0);
> > > +	return ops->get_config(vdev, offset, buf, len);
> > >  }
> > >  /**
> > > diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> > > index 7c8bbfcf6c3e..f5e6a90d8114 100644
> > > --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> > > +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> > > @@ -332,24 +332,32 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
> > >  	return IFCVF_QUEUE_ALIGNMENT;
> > >  }
> > > -static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
> > > -				  unsigned int offset,
> > > -				  void *buf, unsigned int len)
> > > +static int ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
> > > +				 unsigned int offset,
> > > +				 void *buf, unsigned int len)
> > >  {
> > >  	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> > > -	WARN_ON(offset + len > sizeof(struct virtio_net_config));
> > > +	if (offset + len > sizeof(struct virtio_net_config))
> > > +		return -EINVAL;
> > > +
> > >  	ifcvf_read_net_config(vf, offset, buf, len);
> > > +
> > > +	return 0;
> > >  }
> > > -static void ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
> > > -				  unsigned int offset, const void *buf,
> > > -				  unsigned int len)
> > > +static int ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
> > > +				 unsigned int offset, const void *buf,
> > > +				 unsigned int len)
> > >  {
> > >  	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> > > -	WARN_ON(offset + len > sizeof(struct virtio_net_config));
> > > +	if (offset + len > sizeof(struct virtio_net_config))
> > > +		return -EINVAL;
> > > +
> > >  	ifcvf_write_net_config(vf, offset, buf, len);
> > > +
> > > +	return 0;
> > >  }
> > >  static void ifcvf_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > index 029822060017..9323b5ff7988 100644
> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > @@ -1796,20 +1796,25 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
> > >  	ndev->mvdev.status |= VIRTIO_CONFIG_S_FAILED;
> > >  }
> > > -static void mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset, void *buf,
> > > -				 unsigned int len)
> > > +static int mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset, void *buf,
> > > +				unsigned int len)
> > >  {
> > >  	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
> > >  	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> > > -	if (offset + len < sizeof(struct virtio_net_config))
> > > -		memcpy(buf, (u8 *)&ndev->config + offset, len);
> > > +	if (offset + len > sizeof(struct virtio_net_config))
> > > +		return -EINVAL;
> > 
> > 
> > It looks to me we should use ">=" here?
> 
> 
> Ehmm, I think it was wrong before this patch. If 'offset + len' is equal to
> 'sizeof(struct virtio_net_config)', should be okay to copy, no?
> 
> I think it's one of the rare cases where the copy and paste went well :-)
> 
> Should I fix this in a separate patch?
> 
> Thanks,
> Stefano

Sure.

