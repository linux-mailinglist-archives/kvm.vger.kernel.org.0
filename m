Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8474C61FF9D
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 21:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiKGUgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 15:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiKGUgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 15:36:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DA8264A1
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 12:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667853348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=drX9+vl44zYzpBoXJCuJVBuSeyp+bHZXGq/s8MCBeRs=;
        b=CRq/YTidVMc2Pzp5vSE1TCpnxXFSIZZ2B2vOjG/UfoLdSCRA4sf8Jr/rdHDQkVthUoU8cT
        HF7pZA1X+75ZvVgTtA4hdslQL+Z/ClRJZRldXhEmHBDTubk9oMIyB4ZHbV4mzVpEAc79/z
        3iXPXgpKfoONqfJ7GRWb0So3ZsdKc/U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-rRg4vbBDOryX_Fp3et26Yg-1; Mon, 07 Nov 2022 15:35:43 -0500
X-MC-Unique: rRg4vbBDOryX_Fp3et26Yg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C26D806004;
        Mon,  7 Nov 2022 20:35:37 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8B9AC159CD;
        Mon,  7 Nov 2022 20:35:25 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [RFC] vhost: Clear the pending messages on vhost_init_device_iotlb()
Date:   Mon,  7 Nov 2022 21:34:31 +0100
Message-Id: <20221107203431.368306-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the vhost iotlb is used along with a guest virtual iommu
and the guest gets rebooted, some MISS messages may have been
recorded just before the reboot and spuriously executed by
the virtual iommu after the reboot. Despite the device iotlb gets
re-initialized, the messages are not cleared. Fix that by calling
vhost_clear_msg() at the end of vhost_init_device_iotlb().

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vhost/vhost.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 40097826cff0..422a1fdee0ca 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1751,6 +1751,7 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled)
 	}
 
 	vhost_iotlb_free(oiotlb);
+	vhost_clear_msg(d);
 
 	return 0;
 }
-- 
2.37.3

