Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9948031C858
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhBPJrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 04:47:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230077AbhBPJrI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 04:47:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613468742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HBRaTQc7Ttw1kohIDA1m2qTU6L8be75odJdy+4tgCL8=;
        b=LQop7jixI3dp3ed+TmkJx6L/FRb5xPcmt/SaBVhw16xi+C4wNW0Uh23eHS3iUq+E6g+Ghl
        zvbuSPQYThfgaC9XfVC5PqkDSDUYrEsEjOH1xXkjnm5K5hwDWcPNhter8WgSlIBwqawDMD
        jsKc1Bs5riZF/7Sh2E0jJ4pwsZrxqDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-LEkPaDiQMqOnRTuseGIZ_A-1; Tue, 16 Feb 2021 04:45:40 -0500
X-MC-Unique: LEkPaDiQMqOnRTuseGIZ_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18ED5801962;
        Tue, 16 Feb 2021 09:45:39 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA50F1851D;
        Tue, 16 Feb 2021 09:45:37 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 06/10] virtio_vdpa: use vdpa_set_config()
Date:   Tue, 16 Feb 2021 10:44:50 +0100
Message-Id: <20210216094454.82106-7-sgarzare@redhat.com>
In-Reply-To: <20210216094454.82106-1-sgarzare@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of calling the 'set_config' callback directly, we call the
new vdpa_set_config() helper which also checks the parameters.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/virtio/virtio_vdpa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index e28acf482e0c..2f1c4a2dd241 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -65,9 +65,8 @@ static void virtio_vdpa_set(struct virtio_device *vdev, unsigned offset,
 			    const void *buf, unsigned len)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
-	const struct vdpa_config_ops *ops = vdpa->config;
 
-	ops->set_config(vdpa, offset, buf, len);
+	vdpa_set_config(vdpa, offset, buf, len);
 }
 
 static u32 virtio_vdpa_generation(struct virtio_device *vdev)
-- 
2.29.2

