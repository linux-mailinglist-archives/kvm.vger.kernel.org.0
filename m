Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1576631C854
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhBPJrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 04:47:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230053AbhBPJrG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 04:47:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613468740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=epeDldi/RqZNzvZCpZ/Dw6am7oNc4937HhZPeBnWnoI=;
        b=A1ZfPInofDJI9EUGMfX6upEk8GMxBk6K7EF3dJDCAO1IBKR1LgzBjLXMzuOT6GAhfDHSmO
        Z/g+LfXaoftsLq439zyM6ljlEmxuIWCD7WG7HI5/fuM2wUT5wZxAhKadhDbm8WujNObJn8
        oTxFvQAaSbrKq6L4Y/kzJEwu40TcWrg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-YetAxVWXOEmKjMEu6GCXKw-1; Tue, 16 Feb 2021 04:45:38 -0500
X-MC-Unique: YetAxVWXOEmKjMEu6GCXKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65573100A689;
        Tue, 16 Feb 2021 09:45:37 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 109B216D5E;
        Tue, 16 Feb 2021 09:45:35 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 05/10] vdpa: remove WARN_ON() in the get/set_config callbacks
Date:   Tue, 16 Feb 2021 10:44:49 +0100
Message-Id: <20210216094454.82106-6-sgarzare@redhat.com>
In-Reply-To: <20210216094454.82106-1-sgarzare@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vdpa_get_config() and vdpa_set_config() now check parameters before
calling callbacks, so we can remove these warnings.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
Maybe we can skip this patch and leave the WARN_ONs in place.
What do you recommend?
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 3 +--
 drivers/vdpa/ifcvf/ifcvf_main.c | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index f2a128e56de5..5941ecf934d0 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -222,7 +222,6 @@ void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
 	u8 old_gen, new_gen, *p;
 	int i;
 
-	WARN_ON(offset + length > sizeof(struct virtio_net_config));
 	do {
 		old_gen = ifc_ioread8(&hw->common_cfg->config_generation);
 		p = dst;
@@ -240,7 +239,7 @@ void ifcvf_write_net_config(struct ifcvf_hw *hw, u64 offset,
 	int i;
 
 	p = src;
-	WARN_ON(offset + length > sizeof(struct virtio_net_config));
+
 	for (i = 0; i < length; i++)
 		ifc_iowrite8(*p++, hw->net_cfg + offset + i);
 }
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 2443271e17d2..e55f88c57461 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -343,7 +343,6 @@ static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	WARN_ON(offset + len > sizeof(struct virtio_net_config));
 	ifcvf_read_net_config(vf, offset, buf, len);
 }
 
@@ -353,7 +352,6 @@ static void ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	WARN_ON(offset + len > sizeof(struct virtio_net_config));
 	ifcvf_write_net_config(vf, offset, buf, len);
 }
 
-- 
2.29.2

