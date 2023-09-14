Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBE879F7BD
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 04:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbjINCO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 22:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjINCO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 22:14:26 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94144198;
        Wed, 13 Sep 2023 19:14:20 -0700 (PDT)
X-UUID: 4f335181164a4bda80778df58e5b69ba-20230914
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:86a4ba3f-8c4f-4216-9900-a2ab82169aa4,IP:5,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-10
X-CID-INFO: VERSION:1.1.31,REQID:86a4ba3f-8c4f-4216-9900-a2ab82169aa4,IP:5,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:-10
X-CID-META: VersionHash:0ad78a4,CLOUDID:c20ed0be-14cc-44ca-b657-2d2783296e72,B
        ulkID:230914101351PPI539G4,BulkQuantity:0,Recheck:0,SF:24|17|19|44|102,TC:
        nil,Content:0,EDM:-3,IP:-2,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
        I:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,
        TF_CID_SPAM_FSI
X-UUID: 4f335181164a4bda80778df58e5b69ba-20230914
X-User: oushixiong@kylinos.cn
Received: from localhost.localdomain [(111.48.58.12)] by mailgw
        (envelope-from <oushixiong@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 876358924; Thu, 14 Sep 2023 10:13:47 +0800
From:   oushixiong <oushixiong@kylinos.cn>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shixiong Ou <oushixiong@kylinos.cn>
Subject: [PATCH] vfio/pds: Use proper PF device access helper
Date:   Thu, 14 Sep 2023 10:13:32 +0800
Message-Id: <20230914021332.1929155-1-oushixiong@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shixiong Ou <oushixiong@kylinos.cn>

The pci_physfn() helper exists to support cases where the physfn
field may not be compiled into the pci_dev structure. We've
declared this driver dependent on PCI_IOV to avoid this problem,
but regardless we should follow the precedent not to access this
field directly.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
---

This patch changes the subject line and commit log, and the previous 
patch's links is:
	https://patchwork.kernel.org/project/kvm/patch/20230911080828.635184-1-oushixiong@kylinos.cn/

 drivers/vfio/pci/pds/vfio_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index b46174f5eb09..649b18ee394b 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -162,7 +162,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 	pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
 	dev_dbg(&pdev->dev,
 		"%s: PF %#04x VF %#04x vf_id %d domain %d pds_vfio %p\n",
-		__func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
+		__func__, pci_dev_id(pci_physfn(pdev)), pci_id, vf_id,
 		pci_domain_nr(pdev->bus), pds_vfio);
 
 	return 0;
-- 
2.25.1

