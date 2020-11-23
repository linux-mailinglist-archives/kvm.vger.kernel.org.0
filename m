Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5132C0DAD
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 15:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388926AbgKWO3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 09:29:47 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:54172 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730778AbgKWO3r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Nov 2020 09:29:47 -0500
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANEQJWN022746;
        Mon, 23 Nov 2020 09:29:43 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 34y0p850k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 09:29:43 -0500
Received: from SCSQMBX11.ad.analog.com (SCSQMBX11.ad.analog.com [10.77.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 0ANETfVB064133
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 23 Nov 2020 09:29:42 -0500
Received: from SCSQMBX10.ad.analog.com (10.77.17.5) by SCSQMBX11.ad.analog.com
 (10.77.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1779.2; Mon, 23 Nov
 2020 06:29:40 -0800
Received: from zeus.spd.analog.com (10.66.68.11) by SCSQMBX10.ad.analog.com
 (10.77.17.5) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Mon, 23 Nov 2020 06:29:40 -0800
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 0ANETbuu024011;
        Mon, 23 Nov 2020 09:29:37 -0500
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <mst@redhat.com>, <gregkh@linuxfoundation.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2] uio/uio_pci_generic: remove unneeded pci_set_drvdata()
Date:   Mon, 23 Nov 2020 16:34:47 +0200
Message-ID: <20201123143447.16829-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201119145906.73727-1-alexandru.ardelean@analog.com>
References: <20201119145906.73727-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_11:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=953 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pci_get_drvdata() was moved during commit ef84928cff58
("uio/uio_pci_generic: use device-managed function equivalents").

Storing a private object with pci_set_drvdata() doesn't make sense
since that change, since there is no more pci_get_drvdata() call in the
driver to retrieve the information.

This change removes it.

Fixes: ef84928cff58 ("io/uio_pci_generic: use device-managed function equivalents")
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/uio/uio_pci_generic.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
index 1c6c09e1280d..b8e44d16279f 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -101,13 +101,7 @@ static int probe(struct pci_dev *pdev,
 			 "no support for interrupts?\n");
 	}
 
-	err = devm_uio_register_device(&pdev->dev, &gdev->info);
-	if (err)
-		return err;
-
-	pci_set_drvdata(pdev, gdev);
-
-	return 0;
+	return devm_uio_register_device(&pdev->dev, &gdev->info);
 }
 
 static struct pci_driver uio_pci_driver = {
-- 
2.17.1

