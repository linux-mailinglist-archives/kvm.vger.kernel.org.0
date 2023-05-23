Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91DC670E94B
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 00:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjEWWxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 18:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjEWWxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 18:53:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAADCA
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 15:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684882375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3e5RvzPs6Kw2fPgZz0T2lG7+lH8xZxSSM9JfAWt2EMo=;
        b=Vf8um/YIzWzGZSI0yTNy79kakdrMXL1YFfJ01mb64hPIdnox/kh4TZzJ+2vyteeDHnb7g3
        G1GqTkWi7kfksv/yIdx5V3Z/L0ygZcyL8pJv17KniGi/afC5a1Uxes73WrZVECFwFcj8jE
        nYQ/2FQhmhVUSbelC4k/wxGU1j/oW00=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-9xu2bbJ5OtCTedh2v_Si6g-1; Tue, 23 May 2023 18:52:54 -0400
X-MC-Unique: 9xu2bbJ5OtCTedh2v_Si6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFEAE8007D9;
        Tue, 23 May 2023 22:52:53 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.10.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6364B1121314;
        Tue, 23 May 2023 22:52:53 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        oleksandr@natalenko.name, clg@redhat.com
Subject: [PATCH] vfio/pci: Also demote hiding standard cap messages
Date:   Tue, 23 May 2023 16:52:50 -0600
Message-Id: <20230523225250.1215911-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apply the same logic as commit 912b625b4dcf ("vfio/pci: demote hiding
ecap messages to debug level") for the less common case of hiding
standard capabilities.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 1d95fe435f0e..7e2e62ab0869 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1566,8 +1566,8 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
 		}
 
 		if (!len) {
-			pci_info(pdev, "%s: hiding cap %#x@%#x\n", __func__,
-				 cap, pos);
+			pci_dbg(pdev, "%s: hiding cap %#x@%#x\n", __func__,
+				cap, pos);
 			*prev = next;
 			pos = next;
 			continue;
-- 
2.39.2

