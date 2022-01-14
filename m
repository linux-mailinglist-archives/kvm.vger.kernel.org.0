Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71B248F133
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244541AbiANUcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:32:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244396AbiANUcQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:16 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EIQZ0h014131;
        Fri, 14 Jan 2022 20:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=laa+p8nYuaxii3XJZeUZc3q1SwK8x01qn7q7Ktt+cuU=;
 b=QK9YBxe0jMSHvyCyybcCEXat1AwrPqPVUCTw2Mg4CEnN9/QCPWGUkzKv3mIGOEShb71M
 ILjobw5diH34lwytD0Dgk4li/cs9Ls1MuYfwL3lVoaxbnw000QFfRZSLd5b9J1gX9zPd
 RPQNy2xqoSZtuDz7h6thfOBPF4o8sOpE6OlhqTIxEy6mj9lxW/lIKLgupQ+QxnDRgglg
 0XAVTeXv7nmKMjCS2/TyuYPbdQjJgqaPRWs9pGdpYLRugW+EzAyoB+oQ1Z/hlZg33twE
 Mv34PLlNUFDMHdoDo7d00VnGDxOGP16xUFnE97FUaanF/anBb8gIeZHficFyHHPu4ALU lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a8x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:16 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKHQ6Y003059;
        Fri, 14 Jan 2022 20:32:15 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a8wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:15 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKLoFL020155;
        Fri, 14 Jan 2022 20:32:14 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 3df28de4uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:14 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWD2M34931082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:13 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D8ACC6066;
        Fri, 14 Jan 2022 20:32:13 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45BCFC6057;
        Fri, 14 Jan 2022 20:32:11 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:11 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v2 11/30] s390/pci: add helper function to find device by handle
Date:   Fri, 14 Jan 2022 15:31:26 -0500
Message-Id: <20220114203145.242984-12-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6uoTomcbM1vceGQdZkMmf7cNPIN7ouYP
X-Proofpoint-ORIG-GUID: yMJ7TR4sfN7GnoA7rVlyn_UJswQBDXiQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=942 bulkscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intercepted zPCI instructions will specify the desired function via a
function handle.  Add a routine to find the device with the specified
handle.

Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
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
index 0c9879dae752..1e939b4cf25e 100644
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

