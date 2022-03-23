Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024BB4E57A2
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbiCWRiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343772AbiCWRiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:38:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FA9A7EA00
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 10:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648057001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=badQ4iNux1pPz/7wSA5tFhWc+QQEkhPUp5sQLckQMkQ=;
        b=YgCi3ETzvVxKO7J3Ij6LTWXsFJo8aOInV3YUPVz8C/1+JEhDwHKpHHbLFUbYIhul0eK1eP
        h3398XS2R5DFnn/JebuJ/IVtKubEhT6dwQ3hl5ZonhFxvv2DQ6F5xRv+v+BDX1P+MErPKS
        JzYmJuMGaR+R38XbZMG1wDgHylexshU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-CxAlzDXoPjquNMnOn_kM4Q-1; Wed, 23 Mar 2022 13:36:40 -0400
X-MC-Unique: CxAlzDXoPjquNMnOn_kM4Q-1
Received: by mail-qv1-f70.google.com with SMTP id g2-20020a0562141cc200b004123b0abe18so1793019qvd.2
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 10:36:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=badQ4iNux1pPz/7wSA5tFhWc+QQEkhPUp5sQLckQMkQ=;
        b=wdQ3AioBVRnK2B9rDDx9+H4tkzv69S35GbCAhfaP02fWTjFAktQgyBKk79mqGVCcqT
         JCrICpdjp5ijrGD3QTVz7CjJGKc5ENRRdcKPgkhYriGLqYWS0vcNbAdhsQghGRaf98do
         wKmPn9o3hvc78h1ktPz3B4XniulNr1ekiHx14LJBLAhQCDFgpsOe0dp9lNFgNgQb+wMI
         hL5e0lASwh3ncCAxtDZFenswztkxDa+8AKVsa44C4B7wlwADPZuec0WVF2Mr8xJqwtzz
         c1EbYpH5VW3AFocvb990piDnIWS68eYdegQc6g6fcbODI08LH1psZI0An+NjNGGIlO1J
         WZ8A==
X-Gm-Message-State: AOAM533i0W1gCpMf2Rm7N77HkqAXdoTcRRKCIovkEierA2JV+UxuU+ca
        Z6bAJOZEN91B+jjRY49txk8eS2dHJkWra51RJcLSVq5p4ebOB4wGITzSON2iJkvXBQq8eUChzW2
        ZUJnBnaOSHYXm
X-Received: by 2002:ae9:ed96:0:b0:67e:c89e:480a with SMTP id c144-20020ae9ed96000000b0067ec89e480amr718874qkg.274.1648056999445;
        Wed, 23 Mar 2022 10:36:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydhjsyMjk7m4UHfPJYXhDmCRpm61QiwyPkqiHwWTFXbdWyL3aM7kxuaIS4gs2HZKKewMIaMg==
X-Received: by 2002:ae9:ed96:0:b0:67e:c89e:480a with SMTP id c144-20020ae9ed96000000b0067ec89e480amr718839qkg.274.1648056998815;
        Wed, 23 Mar 2022 10:36:38 -0700 (PDT)
Received: from step1.redhat.com (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id h14-20020a05622a170e00b002e1a65754d8sm476127qtk.91.2022.03.23.10.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 10:36:38 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net v3 2/3] vsock/virtio: read the negotiated features before using VQs
Date:   Wed, 23 Mar 2022 18:36:24 +0100
Message-Id: <20220323173625.91119-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323173625.91119-1-sgarzare@redhat.com>
References: <20220323173625.91119-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Complete the driver configuration, reading the negotiated features,
before using the VQs in the virtio_vsock_probe().

Fixes: 53efbba12cc7 ("virtio/vsock: enable SEQPACKET for transport")
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 3e5513934c9f..3954d3be9083 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -622,6 +622,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
 
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
+		vsock->seqpacket_allow = true;
+
 	vdev->priv = vsock;
 
 	mutex_lock(&vsock->tx_lock);
@@ -638,9 +641,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
 
-	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
-		vsock->seqpacket_allow = true;
-
 	rcu_assign_pointer(the_virtio_vsock, vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.35.1

