Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2216E764A
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 11:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbjDSJbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 05:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjDSJbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 05:31:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93D5A5E2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 02:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681896630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=To/Z2aKUn05uCqDmpdizDe13Xy/Ne8IR1ELES9feEn8=;
        b=UCihjCCxjzl0G1LpgEkFU8VhDHQ0sfVv6Kb2lDeVRzubZ4REDN8IOIo+y1m2QjDKLMtd89
        H+CHJSnve/zmi5840aX4qhXfews7lhJq1D7dxPdHGyIQQSvtyBiGldce2v6LSKAl9QqQfG
        xNSXEV105Yz25OJaPkVeKiSMw8LAKgc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-f_w0EKG1PGmuDTuWCrE4sQ-1; Wed, 19 Apr 2023 05:30:28 -0400
X-MC-Unique: f_w0EKG1PGmuDTuWCrE4sQ-1
Received: by mail-qv1-f70.google.com with SMTP id bt4-20020ad455c4000000b005f2ecead82eso284921qvb.6
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 02:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681896628; x=1684488628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=To/Z2aKUn05uCqDmpdizDe13Xy/Ne8IR1ELES9feEn8=;
        b=TLAqWxxswwnjxsFKrqUpRHKyZNKsKLIbZI6bu1wgvRgLueJxHIzHeR2DKF0RKjyCTM
         F4rEZXGwm68pYru7eHIRCyiLv+hzqHNr/kITtDFK2TPVuYfwlzTEn/z3BeWH9ez5cxam
         tPD/sKVCNNkNb0t4RodELcweDHhgIbtx8gqi1Ue83c+HGuCJFVxhPqPeGUCez4NvOJT/
         5bbdHgGFJqcw7l0mqBo6YoJcIB2Znygm++SIp4u2EMSq4fUwnxbaDWv5rwEMR+BzlqSd
         HT5kNsvU1HUibXQ5UhQz+PI62gK77FfGjXJgwD0N9OhS51CS2bUUiD8iu67snA9zutol
         2s2g==
X-Gm-Message-State: AAQBX9fliI5/Weg8xTll8MxMqFx3oEONbGt/WcmB/mqbP17envzMq1hJ
        pBjQiki4/Sx+DwvvASZB3cbddrsZ91ooxCnrLYPezlDujvShzvxgsPzGBwNPDu07avA/uEtPlWk
        ZutqkhyEMh1a3
X-Received: by 2002:ac8:5856:0:b0:3e3:8ebe:ce2d with SMTP id h22-20020ac85856000000b003e38ebece2dmr4663812qth.68.1681896628027;
        Wed, 19 Apr 2023 02:30:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350arWkVKYAcdMdvj77voljoNXo58Xfzci6Fuv0r9IbfMnWkq1bBapWpJIOmEljT7ApJVePXaIw==
X-Received: by 2002:ac8:5856:0:b0:3e3:8ebe:ce2d with SMTP id h22-20020ac85856000000b003e38ebece2dmr4663749qth.68.1681896627694;
        Wed, 19 Apr 2023 02:30:27 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id z17-20020ac87cb1000000b003e64ea3faf7sm2631599qtv.59.2023.04.19.02.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:30:27 -0700 (PDT)
Date:   Wed, 19 Apr 2023 11:30:21 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, Jiang Wang <jiang.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v2 2/4] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <nbuuohh72i4n27rzlg7sj7bwsrsrnnxxcxj6w5yotw5bhpcznt@ormwl5d6jiuw>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
 <20230413-b4-vsock-dgram-v2-2-079cc7cee62e@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v2-2-079cc7cee62e@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 14, 2023 at 12:25:58AM +0000, Bobby Eshleman wrote:
>This commit adds a feature bit for virtio vsock to support datagrams.
>This commit should not be applied without first applying the commit
>that implements datagrams for virtio.
>
>Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> drivers/vhost/vsock.c             | 3 ++-
> include/uapi/linux/virtio_vsock.h | 1 +
> net/vmw_vsock/virtio_transport.c  | 8 ++++++--
> 3 files changed, 9 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index dff6ee1c479b..028cf079225e 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -32,7 +32,8 @@
> enum {
> 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
> 			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>-			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
>+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
>+			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
> };
>
> enum {
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 331be28b1d30..0975b9c88292 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -40,6 +40,7 @@
>
> /* The feature bitmap for virtio vsock */
> #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
>+#define VIRTIO_VSOCK_F_DGRAM		2	/* Host support dgram vsock */
>
> struct virtio_vsock_config {
> 	__le64 guest_cid;
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 582c6c0f788f..bb43eea9a6f9 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -29,6 +29,7 @@ static struct virtio_transport virtio_transport; /* forward declaration */
> struct virtio_vsock {
> 	struct virtio_device *vdev;
> 	struct virtqueue *vqs[VSOCK_VQ_MAX];
>+	bool has_dgram;
>
> 	/* Virtqueue processing is deferred to a workqueue */
> 	struct work_struct tx_work;
>@@ -640,7 +641,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	}
>
> 	vsock->vdev = vdev;
>-
> 	vsock->rx_buf_nr = 0;
> 	vsock->rx_buf_max_nr = 0;
> 	atomic_set(&vsock->queued_replies, 0);
>@@ -657,6 +657,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
> 		vsock->seqpacket_allow = true;
>
>+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
>+		vsock->has_dgram = true;

This is unused for now, but I think the idea is to use in
virtio_transport_dgram_allow(), right?

I would follow `seqpacket_allow` in this case.

Thanks,
Stefano

>+
> 	vdev->priv = vsock;
>
> 	ret = virtio_vsock_vqs_init(vsock);
>@@ -749,7 +752,8 @@ static struct virtio_device_id id_table[] = {
> };
>
> static unsigned int features[] = {
>-	VIRTIO_VSOCK_F_SEQPACKET
>+	VIRTIO_VSOCK_F_SEQPACKET,
>+	VIRTIO_VSOCK_F_DGRAM
> };
>
> static struct virtio_driver virtio_vsock_driver = {
>
>-- 
>2.30.2
>

