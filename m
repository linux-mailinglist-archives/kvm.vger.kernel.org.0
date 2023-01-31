Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535CE682688
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 09:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjAaIe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 03:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbjAaIe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 03:34:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC4B17CFD;
        Tue, 31 Jan 2023 00:34:03 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30V8S2fl027888;
        Tue, 31 Jan 2023 00:33:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=vQvH3qXMcHL4qC8BimrefIOfrFwKAmxERZF1pGL8+3E=;
 b=UsUrm5pcqfJM/mvdj43yoCGuiaDMQ+AlFu4z6/byDgipyH2d4hALrojmAPbAy53qHMH4
 uLaGtlElxXo7w+XeNN/ntR+06mqlDNmArNWojxMAAxx+vVv2LMpVB/AH04ahaOyeT6My
 w3mIrHFniWocTy6qcX/F0kPI2+qLQwp13ocoYkoxDgi+qmqCPKwenYNb0A8Xsf+A1Cgx
 aeLlpbBWDbS0bAq2l65P8hTEnub+O2E8U3fKVuK8rWOx7grqwux15e1cw2sf0n4O/S91
 +TD7lNlUvDFHf1X02BJSlU58bLYS1NPTOFymTKGu4qR25aGE9j+VPKU7Pqc+ixhsKsbf 1A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nd1xurs1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 00:33:59 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 31 Jan
 2023 00:33:57 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Tue, 31 Jan 2023 00:33:57 -0800
Received: from cavium-DT10.. (unknown [10.28.34.39])
        by maili.marvell.com (Postfix) with ESMTP id A68123F704E;
        Tue, 31 Jan 2023 00:33:54 -0800 (PST)
From:   Tomasz Duszynski <tduszynski@marvell.com>
To:     Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     <jerinj@marvell.com>, Tomasz Duszynski <tduszynski@marvell.com>
Subject: [PATCH v2] vfio: platform: ignore missing reset if disabled at module init
Date:   Tue, 31 Jan 2023 09:33:49 +0100
Message-ID: <20230131083349.2027189-1-tduszynski@marvell.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1nv3gJORAb-0tnAZ9IjxB8ntSRLC3OI8
X-Proofpoint-GUID: 1nv3gJORAb-0tnAZ9IjxB8ntSRLC3OI8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_02,2023-01-30_01,2022-06-22_01
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
v2:
- return directly instead of using ternary to do that

 drivers/vfio/platform/vfio_platform_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 1a0a238ffa35..7325ff463cf0 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -650,10 +650,13 @@ int vfio_platform_init_common(struct vfio_platform_device *vdev)
 	mutex_init(&vdev->igate);

 	ret = vfio_platform_get_reset(vdev);
-	if (ret && vdev->reset_required)
+	if (ret && vdev->reset_required) {
 		dev_err(dev, "No reset function found for device %s\n",
 			vdev->name);
-	return ret;
+		return ret;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_platform_init_common);

--
2.34.1

