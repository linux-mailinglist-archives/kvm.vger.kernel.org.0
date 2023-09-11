Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E44C79A593
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 10:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbjIKIJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 04:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbjIKIJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 04:09:12 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224E2CD7;
        Mon, 11 Sep 2023 01:08:40 -0700 (PDT)
X-UUID: 838370dd57ee48bb9b52dc0ff3bc3b20-20230911
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:0ebd95a8-eab7-4741-af2d-9bb3daf083da,IP:15,
        URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-INFO: VERSION:1.1.31,REQID:0ebd95a8-eab7-4741-af2d-9bb3daf083da,IP:15,UR
        L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:0
X-CID-META: VersionHash:0ad78a4,CLOUDID:5efce1c2-1e57-4345-9d31-31ad9818b39f,B
        ulkID:230911160834LYXXCYPN,BulkQuantity:0,Recheck:0,SF:19|44|24|17|102,TC:
        nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
        I:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 838370dd57ee48bb9b52dc0ff3bc3b20-20230911
X-User: oushixiong@kylinos.cn
Received: from localhost.localdomain [(111.48.58.12)] by mailgw
        (envelope-from <oushixiong@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1290505474; Mon, 11 Sep 2023 16:08:31 +0800
From:   oushixiong <oushixiong@kylinos.cn>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shixiong Ou <oushixiong@kylinos.cn>
Subject: [PATCH] vfio/pds: Using pci_physfn() to fix a compilation issue
Date:   Mon, 11 Sep 2023 16:08:28 +0800
Message-Id: <20230911080828.635184-1-oushixiong@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shixiong Ou <oushixiong@kylinos.cn>

If PCI_ATS isn't set, then pdev->physfn is not defined.
it causes a compilation issue:

../drivers/vfio/pci/pds/vfio_dev.c:165:30: error: ‘struct pci_dev’ has no member named ‘physfn’; did you mean ‘is_physfn’?
  165 |   __func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
      |                              ^~~~~~

So using pci_physfn() rather than using pdev->physfn directly.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
---
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

