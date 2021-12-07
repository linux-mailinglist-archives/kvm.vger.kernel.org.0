Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E2E46C571
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 21:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241541AbhLGVCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:02:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26626 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240347AbhLGVC0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:02:26 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JgfeC023895;
        Tue, 7 Dec 2021 20:58:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WvYi9eGzUpUqqQMu65u1qn3H97JnN3+Ek4Zh1NgeEt0=;
 b=GXBMfuZTszglM6r7qOW2Or8euyLWlcS6szbjktQqU+zk+5OtgK+9Yzb8veQUVlON3ImF
 yxKZh0LmxdTz1wWx1C80oGNS9NJG/7IAkirrSENd/dsq74p3a/p8jUB+2cFlKYrZY1Hn
 PaZUzifYC10LBkbgg4TRkez1lfT6mcIqcWh1+HgmpUVj1DhEVDbNkCsPiUa6SJ7due5u
 dZ6kjBRs0Ajp2qFvh+/D4+TUmfzOiP/unvNv1611NJjz84HSqpBPzMhooloURFvMCbPd
 IeNhXs4uMklqTLC0kbGuZLWnFSwowkLsROOOyTyHvDr0w8PQ21eOBlGVifgXZy1DWvIv Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctbgt4tbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:54 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KA0Vk006083;
        Tue, 7 Dec 2021 20:58:54 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctbgt4tb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:54 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Kw0nK021341;
        Tue, 7 Dec 2021 20:58:53 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3cqyyau0rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:53 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7KwpSC47448508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:58:51 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9A4AAE06F;
        Tue,  7 Dec 2021 20:58:51 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93D2AAE063;
        Tue,  7 Dec 2021 20:58:46 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:58:46 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/32] s390/pci: add helper function to find device by handle
Date:   Tue,  7 Dec 2021 15:57:22 -0500
Message-Id: <20211207205743.150299-12-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0xy7PU7D1KIE4KhSax38E3d9HNRsGnrQ
X-Proofpoint-ORIG-GUID: QesVvNMYzwRoNOnXxTd4rdZa_LGaUQse
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 phishscore=0 mlxlogscore=870 bulkscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intercepted zPCI instructions will specify the desired function via a
function handle.  Add a routine to find the device with the specified
handle.

Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h |  1 +
 arch/s390/pci/pci.c         | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 1a8f9f42da3a..00a2c24d6d2b 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -275,6 +275,7 @@ static inline struct zpci_dev *to_zpci_dev(struct device *dev)
 }
 
 struct zpci_dev *get_zdev_by_fid(u32);
+struct zpci_dev *get_zdev_by_fh(u32 fh);
 
 /* DMA */
 int zpci_dma_init(void);
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 9b4d3d78b444..af1c0ae017b1 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -76,6 +76,22 @@ struct zpci_dev *get_zdev_by_fid(u32 fid)
 	return zdev;
 }
 
+struct zpci_dev *get_zdev_by_fh(u32 fh)
+{
+	struct zpci_dev *tmp, *zdev = NULL;
+
+	spin_lock(&zpci_list_lock);
+	list_for_each_entry(tmp, &zpci_list, entry) {
+		if (tmp->fh == fh) {
+			zdev = tmp;
+			break;
+		}
+	}
+	spin_unlock(&zpci_list_lock);
+	return zdev;
+}
+EXPORT_SYMBOL_GPL(get_zdev_by_fh);
+
 void zpci_remove_reserved_devices(void)
 {
 	struct zpci_dev *tmp, *zdev;
-- 
2.27.0

