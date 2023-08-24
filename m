Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486B2786C28
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 11:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240684AbjHXJig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 05:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbjHXJiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 05:38:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35079137
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 02:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692869853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uZHW7/YdobFQu4b8Ky8EljlQfqzf6RTBcoIhE6B2qYY=;
        b=hRQobwD/LZTMsWGTGS1GwUjCOkKf4n/+8dJvp9zzlej/HdOXzf7bDQtJYaIJtG4BwBC4Jg
        enbIcDACGD1ll4vHsTEQEL3wwTKK4yAXwWd7GAxPkZRYfss0I2172+uNE6IPDt0dkLtiGW
        ti8iLXmPmjK27PuvHXoDpVA/R9yc54U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-gOjt71FkNzGmanITnBlIvw-1; Thu, 24 Aug 2023 05:37:28 -0400
X-MC-Unique: gOjt71FkNzGmanITnBlIvw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 859D8101A528;
        Thu, 24 Aug 2023 09:37:27 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60C4B6B2B2;
        Thu, 24 Aug 2023 09:37:25 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, elic@nvidia.com,
        mail@anirudhrb.com, jasowang@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvmarm@lists.linux.dev
Cc:     stable@vger.kernel.org
Subject: [PATCH v2] vhost: Allow null msg.size on VHOST_IOTLB_INVALIDATE
Date:   Thu, 24 Aug 2023 11:37:22 +0200
Message-ID: <20230824093722.249291-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb
entries") Forbade vhost iotlb msg with null size to prevent entries
with size = start = 0 and last = ULONG_MAX to end up in the iotlb.

Then commit 95932ab2ea07 ("vhost: allow batching hint without size")
only applied the check for VHOST_IOTLB_UPDATE and VHOST_IOTLB_INVALIDATE
message types to fix a regression observed with batching hit.

Still, the introduction of that check introduced a regression for
some users attempting to invalidate the whole ULONG_MAX range by
setting the size to 0. This is the case with qemu/smmuv3/vhost
integration which does not work anymore. It Looks safe to partially
revert the original commit and allow VHOST_IOTLB_INVALIDATE messages
with null size. vhost_iotlb_del_range() will compute a correct end
iova. Same for vhost_vdpa_iotlb_unmap().

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entries")
Cc: stable@vger.kernel.org # v5.17+
Acked-by: Jason Wang <jasowang@redhat.com>

---
v1 -> v2:
- Added Cc stable and Jason's Acked-by
---
 drivers/vhost/vhost.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c71d573f1c94..e0c181ad17e3 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1458,9 +1458,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
-	if ((msg.type == VHOST_IOTLB_UPDATE ||
-	     msg.type == VHOST_IOTLB_INVALIDATE) &&
-	     msg.size == 0) {
+	if (msg.type == VHOST_IOTLB_UPDATE && msg.size == 0) {
 		ret = -EINVAL;
 		goto done;
 	}
-- 
2.41.0

