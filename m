Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5281853313F
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240900AbiEXTFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 15:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240945AbiEXTEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 15:04:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFB766CB6
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 12:03:47 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHdRZX011941;
        Tue, 24 May 2022 19:03:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yuBgPGKQMkOxRnyAt3tUd9KnIqFThjJ3sVhr+Vrzy90=;
 b=Tm5CeUB0OiqBVPMUgagCIdW3b7kfFMr6jm+RaA2K2LY6IRuQu2sy0uXPnCU0tiBg7B8k
 n2MSp1gEcuLugOwOIbb2KFP0a+C7kSJ2Ct/sxZhMtbP20WgrbkMObkbBUn3yVE5VekOa
 cPxwuoCVOIq7mMRuyJ38zOWBYTolErgW1yiLvueOnQmgkJNDzCRPKvDZ+/DUznQF1UX2
 +Yab7OP2cmSdvmXpbFEZUUXYYDhH9HyJRZGYMDMfXoMF4p3+ddqWKVOyVsDG8r+Vur04
 6ntigGGYXVuO3/aNXoSiLvHT3SZUjRQ/KxOwNjJabycYnNpUjLbiRGmoxFF/nCvIxwOE BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g93y39m0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:35 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIp5EZ008043;
        Tue, 24 May 2022 19:03:35 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g93y39m0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:35 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OJ2sLC015866;
        Tue, 24 May 2022 19:03:34 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 3g93v80q6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:34 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OJ3XLP18219322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 19:03:33 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E0D012405C;
        Tue, 24 May 2022 19:03:33 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF575124055;
        Tue, 24 May 2022 19:03:30 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 19:03:30 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v6 5/8] s390x/pci: don't fence interpreted devices without MSI-X
Date:   Tue, 24 May 2022 15:03:02 -0400
Message-Id: <20220524190305.140717-6-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524190305.140717-1-mjrosato@linux.ibm.com>
References: <20220524190305.140717-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EfCKl7mVdFvFSBAyjnMdxL8cbaSgqLBA
X-Proofpoint-ORIG-GUID: _sYKQw4-Xa3_zMqXsnrYz9rjkasC7Y7c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lack of MSI-X support is not an issue for interpreted passthrough
devices, so let's let these in.  This will allow, for example, ISM
devices to be passed through -- but only when interpretation is
available and being used.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 156051e6e9..816d17af99 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -881,6 +881,10 @@ static int s390_pci_msix_init(S390PCIBusDevice *pbdev)
 
 static void s390_pci_msix_free(S390PCIBusDevice *pbdev)
 {
+    if (pbdev->msix.entries == 0) {
+        return;
+    }
+
     memory_region_del_subregion(&pbdev->iommu->mr, &pbdev->msix_notify_mr);
     object_unparent(OBJECT(&pbdev->msix_notify_mr));
 }
@@ -1093,7 +1097,7 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
             pbdev->interp = false;
         }
 
-        if (s390_pci_msix_init(pbdev)) {
+        if (s390_pci_msix_init(pbdev) && !pbdev->interp) {
             error_setg(errp, "MSI-X support is mandatory "
                        "in the S390 architecture");
             return;
-- 
2.27.0

