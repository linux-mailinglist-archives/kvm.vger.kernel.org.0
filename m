Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8464E4EA2
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 09:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242982AbiCWIwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242950AbiCWIvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:51:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5519D75601
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 01:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648025413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OgA1lCzF0b4XjouCMdWAekLZD2KK/T/B0hpIucmcAvY=;
        b=G5g9aOuf91AvVT5T+uTTLilDIoUbYLjkjJyV0aEyoY86InI8mu2COGfW6Lts7fodtXw1fw
        fAzaEEytZS1m/XFjHZgYYD+xfXn541bVsgzus1C0gz2NZWSf+mgCGla5SgWLOcbNdzKIXa
        nbHFNrkOclqwR9holmYgd2xNj/an2N4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-Gkto_CVKMBO9GQYbFg9sTQ-1; Wed, 23 Mar 2022 04:50:12 -0400
X-MC-Unique: Gkto_CVKMBO9GQYbFg9sTQ-1
Received: by mail-qv1-f70.google.com with SMTP id fw9-20020a056214238900b0043522aa5b81so732565qvb.21
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 01:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OgA1lCzF0b4XjouCMdWAekLZD2KK/T/B0hpIucmcAvY=;
        b=Vps5W+mhuVW1JD1WcLREaO+xnVJXNvT0gNPRrLKrifxBd75nBtAsoIJJbMIw8XG24i
         oc5+c0x22wRjJEhAtPwpvW+76XZjnPbp/GOCfkl3Xtr65wc63MtrkLtF/f7HmSXDJxlh
         7QyLokKGgTZcOqNsUpRou4+nOi1UN9M6pfp68080G5GqCvZALINXc1yfLt2TOiGotW0Y
         KviWyZ+TCNiG7LxjOyu7Voi7gSlVACSgZ23RizlAnK4nmhSmhf4s63DMXfqLOEjqjHia
         bDis0lfh0RKMxj69HHlIWtDxCFESltoCltD35TROVPfaIfN6iDj3cu5aE7rxzMzC908E
         /dzg==
X-Gm-Message-State: AOAM532ujzGP0jfbnRib1Hcxj6/dMNhXUq3u+MZRI/+q/h9eyOR2k6u2
        7ZyVIGEtMzU2J0mn64StCFXi5eTOwJ8FKV/GObaJBkvwitEnqSxMSiuOm784piVmGz0Ma8j9VNK
        cZzBfjIqUIXSV
X-Received: by 2002:a05:620a:370a:b0:67d:5f35:900f with SMTP id de10-20020a05620a370a00b0067d5f35900fmr17592014qkb.767.1648025411592;
        Wed, 23 Mar 2022 01:50:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzyPK4ZKA2MkSsVUsQecAaz7gloEHvd5w3N1Q/3d1hjdf5Wr4EaGY3ikaTT6b++I1clHGznQ==
X-Received: by 2002:a05:620a:370a:b0:67d:5f35:900f with SMTP id de10-20020a05620a370a00b0067d5f35900fmr17591997qkb.767.1648025411363;
        Wed, 23 Mar 2022 01:50:11 -0700 (PDT)
Received: from step1.redhat.com (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id j188-20020a3755c5000000b0067d1c76a09fsm10640609qkb.74.2022.03.23.01.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 01:50:10 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 3/3] vsock/virtio: read the negotiated features before using VQs
Date:   Wed, 23 Mar 2022 09:49:54 +0100
Message-Id: <20220323084954.11769-4-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323084954.11769-1-sgarzare@redhat.com>
References: <20220323084954.11769-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Complete the driver configuration, reading the negotiated features,
before using the VQs and tell the device that the driver is ready in
the virtio_vsock_probe().

Fixes: 53efbba12cc7 ("virtio/vsock: enable SEQPACKET for transport")
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index fff67ad39087..1244e7cf585b 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -622,6 +622,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
 
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
+		vsock->seqpacket_allow = true;
+
 	vdev->priv = vsock;
 	virtio_device_ready(vdev);
 
@@ -639,9 +642,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
 
-	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
-		vsock->seqpacket_allow = true;
-
 	rcu_assign_pointer(the_virtio_vsock, vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.35.1

