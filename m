Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75FF67B6A2
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 17:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbjAYQLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 11:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjAYQLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 11:11:36 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A481269D;
        Wed, 25 Jan 2023 08:11:35 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PBQ8lv019573;
        Wed, 25 Jan 2023 08:11:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=64PsPJS+9HFkKPYYL53jRXNfo5jOnlTkQq+pcqdFRq8=;
 b=A4BjRpNpo2eLUepW0VzkTzvQZVT8lnTmSUCzXOzMu1g8kdbpaeKIRwPANCYickUxiFQ2
 bUMQiMnpNAmgPDOcjWDKi8/fmph/3kGc39NwwMJKeX1BZcCX8Fo1ez7P94pSs2lFy9Qb
 RdLjdOhYoZXIDm9KIAKlc67pH1XY3HI999Y69hLOY/91efDcV2vBWvwLrBwN8VXM86Y/
 PI5Xq6VwhRG8VT7cWJpsgu95M8drM2RZkzDpdPeHMxC3eJqDWx55wgVSp/zurL9ayPiU
 2gVaMvbPMGx1dquWNWul65QVLkU5xp/opEYJgtwZbS2OYZQxYmK6qy/FwmG8VHj3Vbw+ gw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nb0hp9npx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Jan 2023 08:11:32 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 25 Jan
 2023 08:11:28 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 25 Jan 2023 08:11:28 -0800
Received: from cavium-DT10.. (unknown [10.28.34.39])
        by maili.marvell.com (Postfix) with ESMTP id 57D4B3F7053;
        Wed, 25 Jan 2023 08:11:25 -0800 (PST)
From:   Tomasz Duszynski <tduszynski@marvell.com>
To:     Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     <jerinj@marvell.com>, Tomasz Duszynski <tduszynski@marvell.com>
Subject: [PATCH] vfio: platform: ignore missing reset if disabled at module init
Date:   Wed, 25 Jan 2023 17:11:15 +0100
Message-ID: <20230125161115.1356233-1-tduszynski@marvell.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6yQ2Ja2x8Kpoe_AwZgwhMo405DZkW_dm
X-Proofpoint-GUID: 6yQ2Ja2x8Kpoe_AwZgwhMo405DZkW_dm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_10,2023-01-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If reset requirement was relaxed via module parameter errors caused by
missing reset should not be propagated down to the vfio core.
Otherwise initialization will fail.

Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
Fixes: 5f6c7e0831a1 ("vfio/platform: Use the new device life cycle helpers")
---
 drivers/vfio/platform/vfio_platform_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 1a0a238ffa35..c09ffab6fbe6 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -653,7 +653,8 @@ int vfio_platform_init_common(struct vfio_platform_device *vdev)
 	if (ret && vdev->reset_required)
 		dev_err(dev, "No reset function found for device %s\n",
 			vdev->name);
-	return ret;
+
+	return vdev->reset_required ? ret : 0;
 }
 EXPORT_SYMBOL_GPL(vfio_platform_init_common);
 
-- 
2.34.1

