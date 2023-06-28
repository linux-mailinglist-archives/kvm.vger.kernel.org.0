Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15454740A68
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbjF1IEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:04:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232281AbjF1IBw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 04:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687939263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rjet8Ukl1WyvnmqebMgJ6muk1ycBNL7JSNW8bedLLZI=;
        b=SMImhwbEG6F8hlscNlTedfggDK//rdQE3nRtDkiymxSNkBUdind3SpDpPd0WULwdfXXCBe
        2geYUJWwZo4QntG66qlWsAio4TBQcWlRn5a3CcD7t/jGKTRhRuGbU7nAs2UiFF8nF5hQZw
        odsNnZNgW3sab4vZT73ILVI0KgV3hVs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-9O6KTV6nMZyR72Za4PuBZQ-1; Wed, 28 Jun 2023 02:59:31 -0400
X-MC-Unique: 9O6KTV6nMZyR72Za4PuBZQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D90621C05156;
        Wed, 28 Jun 2023 06:59:30 +0000 (UTC)
Received: from server.redhat.com (ovpn-13-142.pek2.redhat.com [10.72.13.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51A62492B02;
        Wed, 28 Jun 2023 06:59:27 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        maxime.coquelin@redhat.com, xieyongji@bytedance.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [RFC 1/4] vduse: Add the struct to save the vq reconnect info
Date:   Wed, 28 Jun 2023 14:59:16 +0800
Message-Id: <20230628065919.54042-2-lulu@redhat.com>
In-Reply-To: <20230628065919.54042-1-lulu@redhat.com>
References: <20230628065919.54042-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Your Name <you@example.com>

this struct is to save the reconnect info struct, in this
struct saved the page info that alloc to save the
reconnect info

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 26b7e29cb900..f845dc46b1db 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -72,6 +72,12 @@ struct vduse_umem {
 	struct page **pages;
 	struct mm_struct *mm;
 };
+struct vdpa_reconnect_info {
+	u32 index;
+	phys_addr_t addr;
+	unsigned long vaddr;
+	phys_addr_t size;
+};
 
 struct vduse_dev {
 	struct vduse_vdpa *vdev;
@@ -106,6 +112,7 @@ struct vduse_dev {
 	u32 vq_align;
 	struct vduse_umem *umem;
 	struct mutex mem_lock;
+	struct vdpa_reconnect_info reconnect_info[64];
 };
 
 struct vduse_dev_msg {
-- 
2.34.3

