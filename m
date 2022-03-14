Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED414D8CE0
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236704AbiCNTsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244359AbiCNTsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:48:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDC83DDF8;
        Mon, 14 Mar 2022 12:47:06 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EHfxqa000786;
        Mon, 14 Mar 2022 19:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XmqMk+lEABYpM+9BV3uK0X5g2LK2Ku400QAKT44/diQ=;
 b=d15+uqmasu+2i7MEBXNmnuBLG7haM6SfdJ51yODU+s+aRR6s+0NtELMR50Ryn4DRdeau
 npi7qQrrXSYg4ghWEGj4zKERU0L5xkSjPezStjQBk/chJRQPqnPK3HjDxT1Y61vJp86z
 hLz9bKBDuLXybxZchgQF6hgQ9/glZqUcVyLzKpW8CtdBpjiSAyXJIVUHTDdt/l6PnqtU
 PlWwKdVRyt0PnU2t7fkxfgPJUdJpmY6aOxsCOawZRXJl+R8gG2+lO/4K/W8HmQvl3V+X
 rowK4+AhbQ80vbFcMp04fywYOuKE+DYNkIvwj0TPuxA5plJO9ocENdoO4BwHpEcC+99r fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6aj0txk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:46:59 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJeoks029436;
        Mon, 14 Mar 2022 19:46:59 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6aj0tx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:46:59 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJNB2m001535;
        Mon, 14 Mar 2022 19:46:58 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 3erk59cbth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:46:58 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJkujc20840858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:46:56 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C39311206B;
        Mon, 14 Mar 2022 19:46:56 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2E2B112061;
        Mon, 14 Mar 2022 19:46:45 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:46:45 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 11/32] s390/pci: add helper function to find device by handle
Date:   Mon, 14 Mar 2022 15:44:30 -0400
Message-Id: <20220314194451.58266-12-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iSgqA6D3SAjVZXhxav5rqIX4iYDDxHsN
X-Proofpoint-ORIG-GUID: n2GLZzJDoa_sV7_98Ow15-2pW-clMNFj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 mlxlogscore=680 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intercepted zPCI instructions will specify the desired function via a
function handle.  Add a routine to find the device with the specified
handle.

Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
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

