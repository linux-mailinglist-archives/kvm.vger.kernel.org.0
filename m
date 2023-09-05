Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD41792580
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbjIEQEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343619AbjIECku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 22:40:50 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83883CC6;
        Mon,  4 Sep 2023 19:40:42 -0700 (PDT)
X-UUID: 7279bac059b34fff8ac20e4f995e63f3-20230905
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:c87f21bf-e03a-41f3-8422-8d9d6c6a6197,IP:15,
        URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-INFO: VERSION:1.1.31,REQID:c87f21bf-e03a-41f3-8422-8d9d6c6a6197,IP:15,UR
        L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:0
X-CID-META: VersionHash:0ad78a4,CLOUDID:ca901d20-33fd-4aaa-bb43-d3fd68d9d5ae,B
        ulkID:2309051040336BBU5ZH6,BulkQuantity:0,Recheck:0,SF:24|17|19|44|102,TC:
        nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
        I:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 7279bac059b34fff8ac20e4f995e63f3-20230905
X-User: oushixiong@kylinos.cn
Received: from localhost.localdomain [(111.48.58.12)] by mailgw
        (envelope-from <oushixiong@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1120735331; Tue, 05 Sep 2023 10:40:31 +0800
From:   oushixiong <oushixiong@kylinos.cn>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shixiong Ou <oushixiong@kylinos.cn>
Subject: [PATCH] vfio/pds: Limit Calling dev_dbg function to CONFIG_PCI_ATS
Date:   Tue,  5 Sep 2023 10:40:28 +0800
Message-Id: <20230905024028.940377-1-oushixiong@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shixiong Ou <oushixiong@kylinos.cn>

If CONFIG_PCI_ATS isn't set, then pdev->physfn is not defined.
So it causes a compilation issue:

../drivers/vfio/pci/pds/vfio_dev.c:165:30: error: ‘struct pci_dev’ has no member named ‘physfn’; did you mean ‘is_physfn’?
  165 |   __func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
      |                              ^~~~~~

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
---
 drivers/vfio/pci/pds/vfio_dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index b46174f5eb09..18b4a6a5bc16 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -160,10 +160,13 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 	vdev->log_ops = &pds_vfio_log_ops;
 
 	pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
+
+#ifdef CONFIG_PCI_ATS
 	dev_dbg(&pdev->dev,
 		"%s: PF %#04x VF %#04x vf_id %d domain %d pds_vfio %p\n",
 		__func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
 		pci_domain_nr(pdev->bus), pds_vfio);
+#endif
 
 	return 0;
 }
-- 
2.25.1

