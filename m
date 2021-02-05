Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F80310DDD
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 17:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhBEOr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 09:47:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229808AbhBEOlT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 09:41:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612541917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OO/Z9Pbt3ecs88CwJUi87r2qp3LeYfy2PFUUcweybu4=;
        b=LaE9WMomg7O8+qc/pEbruBstnc/YHzF9/5gybqpbBvsCVMr5U5fwTQ1vpud1/Fe7nK6lok
        fBqFYu51Lct82JJiVcIo/vp1rWQFEGp3Oda4Jl5gJ/QzcZaEzs45mxsGS9WvpjaluMDZmV
        cXTuxVYGIOiZpdEhwt3uj5a8q5GvyYY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-JjOKQRXqNmeTfRJ6sQkKCw-1; Fri, 05 Feb 2021 09:17:58 -0500
X-MC-Unique: JjOKQRXqNmeTfRJ6sQkKCw-1
Received: by mail-wr1-f70.google.com with SMTP id w3so5377880wrm.22
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 06:17:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OO/Z9Pbt3ecs88CwJUi87r2qp3LeYfy2PFUUcweybu4=;
        b=H3kC4Zan9S62aeg3yYLJKtlJHEtyN7idjajAJEzqtaK7H3pBvLGPr4pSUNe9qHJuwW
         nK38YWI0zs0f6KRyj96UktGtb5C9OFsD4jT18s6yvAL6J2edkrS91aS1GXXcnVtyHisi
         9D+utsa8FV0KXkYpxHLualzIczDlkWblUOyn6YJNm6YVctOnD0FFqPqfpCEbrIiI+U7i
         ymMzlJLRkbFQK6CZHXw8bO0rvuAM3ZMafcJSW1lRIsqz2yXN+QTT9+Ho980zxoR40YoP
         7Rvb481YhEZlFQ257vO2eEShZx5R7CLaHG8WSTgK8TDk1JRrHbC48I1rT7XpqmkI4Fgp
         dnnA==
X-Gm-Message-State: AOAM532dBy/KHgZWODoUyRIP9UM2WVwzJs2Tp02gHafBd8yxcXjqSWfa
        8hLVRZ6FmCNY4k7WSvr5tGGGgNRbaxLH1riTruJbuDqErmzj+oUNwfdu/jsCLG706hbELwPD3rL
        SXIcd4ldEA0Um
X-Received: by 2002:a5d:6b47:: with SMTP id x7mr5469519wrw.170.1612534677389;
        Fri, 05 Feb 2021 06:17:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzhXbMuzW+9lf4mHkd5Twhn2KBAz8ru70DzypAHZB3/V1aKyI0GBYXHQZ9Aqaw239oEpTOgNw==
X-Received: by 2002:a5d:6b47:: with SMTP id x7mr5469488wrw.170.1612534677136;
        Fri, 05 Feb 2021 06:17:57 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id n9sm12749550wrq.41.2021.02.05.06.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:17:56 -0800 (PST)
Date:   Fri, 5 Feb 2021 15:17:54 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 08/13] vdpa: add return value to get_config/set_config
 callbacks
Message-ID: <20210205141754.cyp4q77cqrj4xx7p@steredhat>
References: <20210204172230.85853-1-sgarzare@redhat.com>
 <20210204172230.85853-9-sgarzare@redhat.com>
 <fe6d02be-b6f9-b07f-a86b-97912dddffdc@redhat.com>
 <20210205084847.d4pkqq2sbqs3p53r@steredhat>
 <20210205091123-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210205091123-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 09:11:26AM -0500, Michael S. Tsirkin wrote:
>On Fri, Feb 05, 2021 at 09:48:47AM +0100, Stefano Garzarella wrote:
>> Adding Eli in the loop.
>>
>> On Fri, Feb 05, 2021 at 11:20:11AM +0800, Jason Wang wrote:
>> >
>> > On 2021/2/5 上午1:22, Stefano Garzarella wrote:
>> > > All implementations of these callbacks already validate inputs.
>> > >
>> > > Let's return an error from these callbacks, so the caller doesn't
>> > > need to validate the input anymore.
>> > >
>> > > We update all implementations to return -EINVAL in case of invalid
>> > > input.
>> > >
>> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> > > ---
>> > >  include/linux/vdpa.h              | 18 ++++++++++--------
>> > >  drivers/vdpa/ifcvf/ifcvf_main.c   | 24 ++++++++++++++++--------
>> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 17 +++++++++++------
>> > >  drivers/vdpa/vdpa_sim/vdpa_sim.c  | 16 ++++++++++------
>> > >  4 files changed, 47 insertions(+), 28 deletions(-)
>> > >
>> > > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>> > > index 4ab5494503a8..0e0cbd5fb41b 100644
>> > > --- a/include/linux/vdpa.h
>> > > +++ b/include/linux/vdpa.h
>> > > @@ -157,6 +157,7 @@ struct vdpa_iova_range {
>> > >   *				@buf: buffer used to read to
>> > >   *				@len: the length to read from
>> > >   *				configuration space
>> > > + *				Returns integer: success (0) or error (< 0)
>> > >   * @set_config:			Write to device specific configuration space
>> > >   *				@vdev: vdpa device
>> > >   *				@offset: offset from the beginning of
>> > > @@ -164,6 +165,7 @@ struct vdpa_iova_range {
>> > >   *				@buf: buffer used to write from
>> > >   *				@len: the length to write to
>> > >   *				configuration space
>> > > + *				Returns integer: success (0) or error (< 0)
>> > >   * @get_generation:		Get device config generation (optional)
>> > >   *				@vdev: vdpa device
>> > >   *				Returns u32: device generation
>> > > @@ -231,10 +233,10 @@ struct vdpa_config_ops {
>> > >  	u32 (*get_vendor_id)(struct vdpa_device *vdev);
>> > >  	u8 (*get_status)(struct vdpa_device *vdev);
>> > >  	void (*set_status)(struct vdpa_device *vdev, u8 status);
>> > > -	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
>> > > -			   void *buf, unsigned int len);
>> > > -	void (*set_config)(struct vdpa_device *vdev, unsigned int offset,
>> > > -			   const void *buf, unsigned int len);
>> > > +	int (*get_config)(struct vdpa_device *vdev, unsigned int offset,
>> > > +			  void *buf, unsigned int len);
>> > > +	int (*set_config)(struct vdpa_device *vdev, unsigned int offset,
>> > > +			  const void *buf, unsigned int len);
>> > >  	u32 (*get_generation)(struct vdpa_device *vdev);
>> > >  	struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
>> > > @@ -329,8 +331,8 @@ static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
>> > >  }
>> > > -static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
>> > > -				   void *buf, unsigned int len)
>> > > +static inline int vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
>> > > +				  void *buf, unsigned int len)
>> > >  {
>> > >          const struct vdpa_config_ops *ops = vdev->config;
>> > > @@ -339,8 +341,8 @@ static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
>> > >  	 * If it does happen we assume a legacy guest.
>> > >  	 */
>> > >  	if (!vdev->features_valid)
>> > > -		vdpa_set_features(vdev, 0);
>> > > -	ops->get_config(vdev, offset, buf, len);
>> > > +		return vdpa_set_features(vdev, 0);
>> > > +	return ops->get_config(vdev, offset, buf, len);
>> > >  }
>> > >  /**
>> > > diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>> > > index 7c8bbfcf6c3e..f5e6a90d8114 100644
>> > > --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> > > +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> > > @@ -332,24 +332,32 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>> > >  	return IFCVF_QUEUE_ALIGNMENT;
>> > >  }
>> > > -static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
>> > > -				  unsigned int offset,
>> > > -				  void *buf, unsigned int len)
>> > > +static int ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
>> > > +				 unsigned int offset,
>> > > +				 void *buf, unsigned int len)
>> > >  {
>> > >  	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>> > > -	WARN_ON(offset + len > sizeof(struct virtio_net_config));
>> > > +	if (offset + len > sizeof(struct virtio_net_config))
>> > > +		return -EINVAL;
>> > > +
>> > >  	ifcvf_read_net_config(vf, offset, buf, len);
>> > > +
>> > > +	return 0;
>> > >  }
>> > > -static void ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
>> > > -				  unsigned int offset, const void *buf,
>> > > -				  unsigned int len)
>> > > +static int ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
>> > > +				 unsigned int offset, const void *buf,
>> > > +				 unsigned int len)
>> > >  {
>> > >  	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>> > > -	WARN_ON(offset + len > sizeof(struct virtio_net_config));
>> > > +	if (offset + len > sizeof(struct virtio_net_config))
>> > > +		return -EINVAL;
>> > > +
>> > >  	ifcvf_write_net_config(vf, offset, buf, len);
>> > > +
>> > > +	return 0;
>> > >  }
>> > >  static void ifcvf_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
>> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> > > index 029822060017..9323b5ff7988 100644
>> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> > > @@ -1796,20 +1796,25 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>> > >  	ndev->mvdev.status |= VIRTIO_CONFIG_S_FAILED;
>> > >  }
>> > > -static void mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset, void *buf,
>> > > -				 unsigned int len)
>> > > +static int mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset, void *buf,
>> > > +				unsigned int len)
>> > >  {
>> > >  	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>> > >  	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>> > > -	if (offset + len < sizeof(struct virtio_net_config))
>> > > -		memcpy(buf, (u8 *)&ndev->config + offset, len);
>> > > +	if (offset + len > sizeof(struct virtio_net_config))
>> > > +		return -EINVAL;
>> >
>> >
>> > It looks to me we should use ">=" here?
>>
>>
>> Ehmm, I think it was wrong before this patch. If 'offset + len' is equal to
>> 'sizeof(struct virtio_net_config)', should be okay to copy, no?
>>
>> I think it's one of the rare cases where the copy and paste went well :-)
>>
>> Should I fix this in a separate patch?
>>
>> Thanks,
>> Stefano
>
>Sure.
>

I'll do it.

Thanks,
Stefano

