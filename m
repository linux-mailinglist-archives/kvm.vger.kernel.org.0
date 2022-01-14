Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A29648F12F
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244490AbiANUcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:32:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244412AbiANUcT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:19 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EIQVQB014057;
        Fri, 14 Jan 2022 20:32:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lRB9JrHsyHppT+i38JYc09DHrUS9hUPqFB0LKEN65SI=;
 b=J8JzFNyTLQOkozuPjTI3wmomkgaOfZ30w4LdfhoCGIrdmcfDt53FBCxV/iO7s+iCVCBK
 jnmKc9BMf9j2KIC2ohNZuCpWJ+cFcN93Xo8DxhVsxO1UssTzpOay0Cx4iRL2rnpKfGsx
 gg68MSVaDECeNKSf1hLopFDeOCle9HD/duuF+CnjM7hlc/VZivF+BxzxUhhhEeiSG1dE
 DyKtLOVgDjLkLwqVKwuZbrXEIoJ6WKAYlZfNIOcaEhul6xZ6lQNI0VFBHp1qFy04ack+
 UCvl2Aa/rFKC1Orv7xxijgWw2xoblkjtBG7iZ7IL+G7WNAKe0FEDVqFtAGDmvwW73f8d 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a8xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKJZWr010518;
        Fri, 14 Jan 2022 20:32:17 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a8xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:17 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKMWW4032710;
        Fri, 14 Jan 2022 20:32:16 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3df28ddysa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:16 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWFkS33423668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:15 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC744C6055;
        Fri, 14 Jan 2022 20:32:14 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FFA1C6072;
        Fri, 14 Jan 2022 20:32:13 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:13 +0000 (GMT)
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
Subject: [PATCH v2 12/30] s390/pci: get SHM information from list pci
Date:   Fri, 14 Jan 2022 15:31:27 -0500
Message-Id: <20220114203145.242984-13-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i_WRA9b6yyw6h1QeNRk2lq3RAg7qVh8D
X-Proofpoint-ORIG-GUID: ioW13zpK-DEN62-D7hKxkdPIgGD1NaAd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM will need information on the special handle mask used to indicate
emulated devices.  In order to obtain this, a new type of list pci call
must be made to gather the information.  Extend clp_list_pci_req to
also fetch the model-dependent-data field that holds this mask.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h     |  1 +
 arch/s390/include/asm/pci_clp.h |  2 +-
 arch/s390/pci/pci_clp.c         | 28 +++++++++++++++++++++++++---
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 00a2c24d6d2b..f3cd2da8128c 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -227,6 +227,7 @@ int clp_enable_fh(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as);
 int clp_disable_fh(struct zpci_dev *zdev, u32 *fh);
 int clp_get_state(u32 fid, enum zpci_state *state);
 int clp_refresh_fh(u32 fid, u32 *fh);
+int zpci_get_mdd(u32 *mdd);
 
 /* UID */
 void update_uid_checking(bool new);
diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
index 124fadfb74b9..d6bc324763f3 100644
--- a/arch/s390/include/asm/pci_clp.h
+++ b/arch/s390/include/asm/pci_clp.h
@@ -76,7 +76,7 @@ struct clp_req_list_pci {
 struct clp_rsp_list_pci {
 	struct clp_rsp_hdr hdr;
 	u64 resume_token;
-	u32 reserved2;
+	u32 mdd;
 	u16 max_fn;
 	u8			: 7;
 	u8 uid_checking		: 1;
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index bc7446566cbc..308ffb93413f 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -328,7 +328,7 @@ int clp_disable_fh(struct zpci_dev *zdev, u32 *fh)
 }
 
 static int clp_list_pci_req(struct clp_req_rsp_list_pci *rrb,
-			    u64 *resume_token, int *nentries)
+			    u64 *resume_token, int *nentries, u32 *mdd)
 {
 	int rc;
 
@@ -354,6 +354,8 @@ static int clp_list_pci_req(struct clp_req_rsp_list_pci *rrb,
 	*nentries = (rrb->response.hdr.len - LIST_PCI_HDR_LEN) /
 		rrb->response.entry_size;
 	*resume_token = rrb->response.resume_token;
+	if (mdd)
+		*mdd = rrb->response.mdd;
 
 	return rc;
 }
@@ -365,7 +367,7 @@ static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
 	int nentries, i, rc;
 
 	do {
-		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
+		rc = clp_list_pci_req(rrb, &resume_token, &nentries, NULL);
 		if (rc)
 			return rc;
 		for (i = 0; i < nentries; i++)
@@ -383,7 +385,7 @@ static int clp_find_pci(struct clp_req_rsp_list_pci *rrb, u32 fid,
 	int nentries, i, rc;
 
 	do {
-		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
+		rc = clp_list_pci_req(rrb, &resume_token, &nentries, NULL);
 		if (rc)
 			return rc;
 		fh_list = rrb->response.fh_list;
@@ -468,6 +470,26 @@ int clp_get_state(u32 fid, enum zpci_state *state)
 	return rc;
 }
 
+int zpci_get_mdd(u32 *mdd)
+{
+	struct clp_req_rsp_list_pci *rrb;
+	u64 resume_token = 0;
+	int nentries, rc;
+
+	if (!mdd)
+		return -EINVAL;
+
+	rrb = clp_alloc_block(GFP_KERNEL);
+	if (!rrb)
+		return -ENOMEM;
+
+	rc = clp_list_pci_req(rrb, &resume_token, &nentries, mdd);
+
+	clp_free_block(rrb);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(zpci_get_mdd);
+
 static int clp_base_slpc(struct clp_req *req, struct clp_req_rsp_slpc *lpcb)
 {
 	unsigned long limit = PAGE_SIZE - sizeof(lpcb->request);
-- 
2.27.0

