Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9C679337B
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 03:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbjIFBuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 21:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbjIFBuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 21:50:08 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DD3CD2;
        Tue,  5 Sep 2023 18:50:01 -0700 (PDT)
X-UUID: 9e3770defd2a49d09c2b421257c58c5f-20230906
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:e80f1eb1-720b-45a1-a92a-0754ddea1d50,IP:15,
        URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-INFO: VERSION:1.1.31,REQID:e80f1eb1-720b-45a1-a92a-0754ddea1d50,IP:15,UR
        L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:0
X-CID-META: VersionHash:0ad78a4,CLOUDID:61312920-33fd-4aaa-bb43-d3fd68d9d5ae,B
        ulkID:230906094948VYPMASHI,BulkQuantity:0,Recheck:0,SF:24|17|19|44|102,TC:
        nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
        I:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 9e3770defd2a49d09c2b421257c58c5f-20230906
X-User: oushixiong@kylinos.cn
Received: from localhost.localdomain [(111.48.58.12)] by mailgw
        (envelope-from <oushixiong@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 779420723; Wed, 06 Sep 2023 09:49:45 +0800
From:   oushixiong <oushixiong@kylinos.cn>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shixiong Ou <oushixiong@kylinos.cn>
Subject: [PATCH] vfio/pds: Add missing PCI_IOV depends
Date:   Wed,  6 Sep 2023 09:49:42 +0800
Message-Id: <20230906014942.1658769-1-oushixiong@kylinos.cn>
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

If PCI_ATS isn't set, then pdev->physfn is not defined.
it causes a compilation issue:

../drivers/vfio/pci/pds/vfio_dev.c:165:30: error: ‘struct pci_dev’ has no member named ‘physfn’; did you mean ‘is_physfn’?
  165 |   __func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
      |                              ^~~~~~

So adding PCI_IOV depends to select PCI_ATS.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
---
 drivers/vfio/pci/pds/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/pds/Kconfig b/drivers/vfio/pci/pds/Kconfig
index 407b3fd32733..6eceef7b028a 100644
--- a/drivers/vfio/pci/pds/Kconfig
+++ b/drivers/vfio/pci/pds/Kconfig
@@ -3,7 +3,7 @@
 
 config PDS_VFIO_PCI
 	tristate "VFIO support for PDS PCI devices"
-	depends on PDS_CORE
+	depends on PDS_CORE && PCI_IOV
 	select VFIO_PCI_CORE
 	help
 	  This provides generic PCI support for PDS devices using the VFIO
-- 
2.25.1

