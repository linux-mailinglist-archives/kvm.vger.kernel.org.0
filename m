Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479E631070A
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 09:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhBEIu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 03:50:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229511AbhBEIuX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 03:50:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612514934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qats9+82wU3qAY98Gc8MG/7rmEQkf2rmw/ej3jR/AJc=;
        b=XypyhtmAmQ4TCemYg+lSNakBi1jEoOVm2z+xyGN9OjIr2+bOlhe+7GcnyDK13daySLtH4J
        41LD7jiEm2Hl8sJNjST7khCIbx5j3yqsENdkH7pcJhp6ectkktzq9SC3zn4Bqbn/xk0PIG
        DDwyocUHXCB1byFZcQ9FEM4scJSPM3w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-ejJfJsW4PnaV7P6Q1lEpkw-1; Fri, 05 Feb 2021 03:48:52 -0500
X-MC-Unique: ejJfJsW4PnaV7P6Q1lEpkw-1
Received: by mail-wr1-f71.google.com with SMTP id x7so4882638wrp.9
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 00:48:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qats9+82wU3qAY98Gc8MG/7rmEQkf2rmw/ej3jR/AJc=;
        b=EVyZr/+uCfkM1/Rclli6vrNZJN9sDaS7qCZcvgoASCX9/bHXvJSMfWjgjXdUa/5z0a
         MP/rTcU0IIYDe9PSq6PoAmrWAx+3V1Onpi4PpTG6Dtyfd3k8VzHsZeb1HA+P/Bn7rxEc
         a0N8TB9ffys3h8gz6JKTU8HLfT8QxxO/4B7UvYrsFmkxK4p0qLM+z6SwX5dhvMxDD02r
         oX/LWC5+3KpWEuGiAZ8ABZn9sxSP7FpMzVfnBHkfdtnMT4EHa9K5x9GQHAVN/DSvpzgM
         VgKT6gqAma/X4eSu2WVmAwE+ZbTAPhpGHevpHBFqudf5jo6q5I0xT+iK4hz4zpG38rTA
         gQYg==
X-Gm-Message-State: AOAM530jMVDzvGE78k+S+UpFfw/L2wVPJ9p9dQ+xOQE96one0UdZ5y6l
        YPbfuJ4jdx8u4uC4t3XN+SvRigGA0avuFSaiA/jbBlc6jFezmpk5dKyGNIXNZ9Sr8/Dv2j5OxlF
        w12RSd6rshl1+
X-Received: by 2002:a5d:6712:: with SMTP id o18mr3603972wru.375.1612514931189;
        Fri, 05 Feb 2021 00:48:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzCQqPTFZtarTI+RyF/EcK9EX3zDigmzlWkyGFPbLEWf1RVHsZ2nDDpeNiO5e/Z/sg+KIrizQ==
X-Received: by 2002:a5d:6712:: with SMTP id o18mr3603950wru.375.1612514930954;
        Fri, 05 Feb 2021 00:48:50 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id o9sm11859486wrw.81.2021.02.05.00.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 00:48:50 -0800 (PST)
Date:   Fri, 5 Feb 2021 09:48:47 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 08/13] vdpa: add return value to get_config/set_config
 callbacks
Message-ID: <20210205084847.d4pkqq2sbqs3p53r@steredhat>
References: <20210204172230.85853-1-sgarzare@redhat.com>
 <20210204172230.85853-9-sgarzare@redhat.com>
 <fe6d02be-b6f9-b07f-a86b-97912dddffdc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe6d02be-b6f9-b07f-a86b-97912dddffdc@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adding Eli in the loop.

On Fri, Feb 05, 2021 at 11:20:11AM +0800, Jason Wang wrote:
>
>On 2021/2/5 上午1:22, Stefano Garzarella wrote:
>>All implementations of these callbacks already validate inputs.
>>
>>Let's return an error from these callbacks, so the caller doesn't
>>need to validate the input anymore.
>>
>>We update all implementations to return -EINVAL in case of invalid
>>input.
>>
>>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>---
>>  include/linux/vdpa.h              | 18 ++++++++++--------
>>  drivers/vdpa/ifcvf/ifcvf_main.c   | 24 ++++++++++++++++--------
>>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 17 +++++++++++------
>>  drivers/vdpa/vdpa_sim/vdpa_sim.c  | 16 ++++++++++------
>>  4 files changed, 47 insertions(+), 28 deletions(-)
>>
>>diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>>index 4ab5494503a8..0e0cbd5fb41b 100644
>>--- a/include/linux/vdpa.h
>>+++ b/include/linux/vdpa.h
>>@@ -157,6 +157,7 @@ struct vdpa_iova_range {
>>   *				@buf: buffer used to read to
>>   *				@len: the length to read from
>>   *				configuration space
>>+ *				Returns integer: success (0) or error (< 0)
>>   * @set_config:			Write to device specific configuration space
>>   *				@vdev: vdpa device
>>   *				@offset: offset from the beginning of
>>@@ -164,6 +165,7 @@ struct vdpa_iova_range {
>>   *				@buf: buffer used to write from
>>   *				@len: the length to write to
>>   *				configuration space
>>+ *				Returns integer: success (0) or error (< 0)
>>   * @get_generation:		Get device config generation (optional)
>>   *				@vdev: vdpa device
>>   *				Returns u32: device generation
>>@@ -231,10 +233,10 @@ struct vdpa_config_ops {
>>  	u32 (*get_vendor_id)(struct vdpa_device *vdev);
>>  	u8 (*get_status)(struct vdpa_device *vdev);
>>  	void (*set_status)(struct vdpa_device *vdev, u8 status);
>>-	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
>>-			   void *buf, unsigned int len);
>>-	void (*set_config)(struct vdpa_device *vdev, unsigned int offset,
>>-			   const void *buf, unsigned int len);
>>+	int (*get_config)(struct vdpa_device *vdev, unsigned int offset,
>>+			  void *buf, unsigned int len);
>>+	int (*set_config)(struct vdpa_device *vdev, unsigned int offset,
>>+			  const void *buf, unsigned int len);
>>  	u32 (*get_generation)(struct vdpa_device *vdev);
>>  	struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
>>@@ -329,8 +331,8 @@ static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
>>  }
>>-static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
>>-				   void *buf, unsigned int len)
>>+static inline int vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
>>+				  void *buf, unsigned int len)
>>  {
>>          const struct vdpa_config_ops *ops = vdev->config;
>>@@ -339,8 +341,8 @@ static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
>>  	 * If it does happen we assume a legacy guest.
>>  	 */
>>  	if (!vdev->features_valid)
>>-		vdpa_set_features(vdev, 0);
>>-	ops->get_config(vdev, offset, buf, len);
>>+		return vdpa_set_features(vdev, 0);
>>+	return ops->get_config(vdev, offset, buf, len);
>>  }
>>  /**
>>diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>>index 7c8bbfcf6c3e..f5e6a90d8114 100644
>>--- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>@@ -332,24 +332,32 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>>  	return IFCVF_QUEUE_ALIGNMENT;
>>  }
>>-static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
>>-				  unsigned int offset,
>>-				  void *buf, unsigned int len)
>>+static int ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
>>+				 unsigned int offset,
>>+				 void *buf, unsigned int len)
>>  {
>>  	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>-	WARN_ON(offset + len > sizeof(struct virtio_net_config));
>>+	if (offset + len > sizeof(struct virtio_net_config))
>>+		return -EINVAL;
>>+
>>  	ifcvf_read_net_config(vf, offset, buf, len);
>>+
>>+	return 0;
>>  }
>>-static void ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
>>-				  unsigned int offset, const void *buf,
>>-				  unsigned int len)
>>+static int ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
>>+				 unsigned int offset, const void *buf,
>>+				 unsigned int len)
>>  {
>>  	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>-	WARN_ON(offset + len > sizeof(struct virtio_net_config));
>>+	if (offset + len > sizeof(struct virtio_net_config))
>>+		return -EINVAL;
>>+
>>  	ifcvf_write_net_config(vf, offset, buf, len);
>>+
>>+	return 0;
>>  }
>>  static void ifcvf_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
>>diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>index 029822060017..9323b5ff7988 100644
>>--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>@@ -1796,20 +1796,25 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>>  	ndev->mvdev.status |= VIRTIO_CONFIG_S_FAILED;
>>  }
>>-static void mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset, void *buf,
>>-				 unsigned int len)
>>+static int mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset, void *buf,
>>+				unsigned int len)
>>  {
>>  	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>>  	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>>-	if (offset + len < sizeof(struct virtio_net_config))
>>-		memcpy(buf, (u8 *)&ndev->config + offset, len);
>>+	if (offset + len > sizeof(struct virtio_net_config))
>>+		return -EINVAL;
>
>
>It looks to me we should use ">=" here?


Ehmm, I think it was wrong before this patch. If 'offset + len' is equal 
to 'sizeof(struct virtio_net_config)', should be okay to copy, no?

I think it's one of the rare cases where the copy and paste went well 
:-)

Should I fix this in a separate patch?

Thanks,
Stefano

