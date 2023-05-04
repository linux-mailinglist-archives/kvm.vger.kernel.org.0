Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2756F6CE7
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 15:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjEDN0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 09:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjEDNZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 09:25:58 -0400
X-Greylist: delayed 535 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 04 May 2023 06:25:56 PDT
Received: from vulcan.natalenko.name (vulcan.natalenko.name [104.207.131.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC48273B;
        Thu,  4 May 2023 06:25:56 -0700 (PDT)
Received: from localhost (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 8DE4A12F8768;
        Thu,  4 May 2023 15:16:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1683206216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1GoSmlsswYCSSMaB76ExjC77jP1QgiBUF/bzBvuBTsg=;
        b=Td2N0gBjPvlTlyWzvZHpJqFSgse2/YThNRfD6cCkdFEtPcZvagxfK2z2uJ/6ZK4CiNuRGx
        /cPifY7XykPQVQctaZOZrKE92Cm2Akzh3uCoKNdldBM1lfHT9NFCLB9hcsb77/uhp5Nc0S
        Tj87eGjKwHqbtCXeQG/t0nqYKwS9kDo=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     linux-kernel@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>, Bo Liu <liubo03@inspur.com>,
        "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>,
        kvm@vger.kernel.org
Subject: [PATCH] vfio/pci: demote hiding ecap messages to debug level
Date:   Thu,  4 May 2023 15:16:54 +0200
Message-Id: <20230504131654.24922-1-oleksandr@natalenko.name>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seeing a burst of messages like this:

    vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x19@0x1d0
    vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x25@0x200
    vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x26@0x210
    vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x27@0x250
    vfio-pci 0000:98:00.1: vfio_ecap_init: hiding ecap 0x25@0x200
    vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x19@0x1d0
    vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x25@0x200
    vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x26@0x210
    vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x27@0x250
    vfio-pci 0000:b1:00.1: vfio_ecap_init: hiding ecap 0x25@0x200

is of little to no value for an ordinary user.

Hence, use pci_dbg() instead of pci_info().

Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
---
 drivers/vfio/pci/vfio_pci_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 948cdd464f4e..dd8dda14e701 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1643,7 +1643,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device *vdev)
 		}
 
 		if (!len) {
-			pci_info(pdev, "%s: hiding ecap %#x@%#x\n",
+			pci_dbg(pdev, "%s: hiding ecap %#x@%#x\n",
 				 __func__, ecap, epos);
 
 			/* If not the first in the chain, we can skip over it */
-- 
2.40.1

