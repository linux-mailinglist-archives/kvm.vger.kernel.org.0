Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911AD4AA1D1
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiBDVQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:16:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52064 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241582AbiBDVQI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:08 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214HpnUl010449;
        Fri, 4 Feb 2022 21:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QfeB28pJr8D7CfHJ69dZVIPLPRYRUPBbGl8sdkItch4=;
 b=DH6Pitngv6peuTyHVXnXe6CGLB7bYMqjRQNm7YpV/hXOjv92yKK9r9/c2rAMFAyG4SHH
 AbPbh2hXjUAksZIErUGfK0HyDrY9syuZJeIEQNgmd7bz9Iso9OaAJosmswzOWYvC/RBq
 aSiyX2fTQR4NGv8h67WE/mEOR23H4N+fIRtab+4PYqfrKXHEksHLws1Z7FISCRdbu4MV
 R6KhhhgQR05xldJpfhNhJdKUzi/b1SbUBCIcD82nVE6L0Y9z/IezMe3tfEfMFrYk26PK
 YO4KoZyf8PfN9PHOVgrPOSMIIJ/5w3vz/8guDmLHx4xmV8K/XVfCkCh6PpHpkLGAau5i Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e109f6wn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:08 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214L8B4O012836;
        Fri, 4 Feb 2022 21:16:07 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e109f6wmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:07 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCfEN011934;
        Fri, 4 Feb 2022 21:16:07 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3e0r0m2wc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:07 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LG5vf18678160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:05 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B65F6136063;
        Fri,  4 Feb 2022 21:16:05 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D739C136055;
        Fri,  4 Feb 2022 21:16:03 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:03 +0000 (GMT)
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
Subject: [PATCH v3 11/30] s390/pci: add helper function to find device by handle
Date:   Fri,  4 Feb 2022 16:15:17 -0500
Message-Id: <20220204211536.321475-12-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7oHTsjnQX8Fxf40J73cpYANDkVLjmfjC
X-Proofpoint-ORIG-GUID: LI3PZL3S4wrlGDonn-RvloY9zYQ3Ocut
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=849 clxscore=1015
 phishscore=0 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intercepted zPCI instructions will specify the desired function via a
function handle.  Add a routine to find the device with the specified
handle.

Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h |  1 +
 arch/s390/pci/pci.c         | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 7ee52a70a96f..3c0b9986dcdc 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -275,6 +275,7 @@ static inline struct zpci_dev *to_zpci_dev(struct device *dev)
 }
 
 struct zpci_dev *get_zdev_by_fid(u32);
+struct zpci_dev *get_zdev_by_fh(u32 fh);
 
 /* DMA */
 int zpci_dma_init(void);
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index ca9c29386de6..04c16312ad54 100644
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

