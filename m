Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA7957E27C
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 15:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbiGVNnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 09:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbiGVNno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 09:43:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13A866D9DF
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658497423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TyD0FWUO0IRf/eSrfngxODmbJnXlP4byirFk3EYR7NM=;
        b=BltOVsUHVhl6va3r5nPu8+ZZ2X4le+S8naF5OUMAUbMapBi7ys/g/cSvmcK48rsUpmttec
        Aq5CFsJqqNJSALKQAUSqgC8DVmlzxgBkZGNSAzopcF0kbuq2vyMwuVZJrid1BCBIvwxK7R
        WR06y5AFRWFqnjTyWOV/pkJmQ0NfgvE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-C9BwHSbHOiqz2Mr6fGvCWw-1; Fri, 22 Jul 2022 09:43:30 -0400
X-MC-Unique: C9BwHSbHOiqz2Mr6fGvCWw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2B20811E76;
        Fri, 22 Jul 2022 13:43:28 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.194.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BD3B492C3B;
        Fri, 22 Jul 2022 13:43:26 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Cindy Lu <lulu@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v2 2/7] vdpa: Use v->shadow_vqs_enabled in vhost_vdpa_svqs_start & stop
Date:   Fri, 22 Jul 2022 15:43:13 +0200
Message-Id: <20220722134318.3430667-3-eperezma@redhat.com>
In-Reply-To: <20220722134318.3430667-1-eperezma@redhat.com>
References: <20220722134318.3430667-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function used to trust in v->shadow_vqs != NULL to know if it must
start svq or not.

This is not going to be valid anymore, as qemu is going to allocate svq
unconditionally (but it will only start them conditionally).

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost-vdpa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 9a2daef7e3..897e1fdd47 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -1019,7 +1019,7 @@ static bool vhost_vdpa_svqs_start(struct vhost_dev *dev)
     Error *err = NULL;
     unsigned i;
 
-    if (!v->shadow_vqs) {
+    if (!v->shadow_vqs_enabled) {
         return true;
     }
 
@@ -1072,7 +1072,7 @@ static bool vhost_vdpa_svqs_stop(struct vhost_dev *dev)
 {
     struct vhost_vdpa *v = dev->opaque;
 
-    if (!v->shadow_vqs) {
+    if (!v->shadow_vqs_enabled) {
         return true;
     }
 
-- 
2.31.1

