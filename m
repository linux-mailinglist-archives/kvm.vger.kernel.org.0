Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511B946C575
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 21:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240130AbhLGVCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:02:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241452AbhLGVCb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:02:31 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JbfTe022849;
        Tue, 7 Dec 2021 20:59:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mgaXutw8CDNM7PhttO1iudH74y/sWbEfBCRcHTiqKQw=;
 b=DwMVtfMYsok18vLCWIexmeEjWZFER0/grjAPJQxhvIgNHAPA0m4fURak5gjr9/9p4bKp
 s0cBJOJDf5IrbWmcLoEiy4W7Tqyn8xZi9DlpnqnT+13iToj4j3CIymFv75GoC2FFFUB0
 v7vO9xyteh09aEPy/Y0DPndsKBU7+jHc+olW1Ojolq29lLVph70KiBnrVs2fspdOXXfz
 txLQNhQcdSR6TTBvwRL1nRJdAte1LCPnUgbjg1UaLilC+8K54mp8R/pUjML6F5wgQIWc
 8Hek+vP31j+nJOsKog1WF3f+oL8QYsh+oZfk3EZWT0k49GnjAOM9TkJs+Ul5s9w0vrTA kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajxpcy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:00 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KmPvq017424;
        Tue, 7 Dec 2021 20:59:00 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajxpcxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:00 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Kvstd010218;
        Tue, 7 Dec 2021 20:58:59 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 3cqyyamjrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:58 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7Kwv4A29360610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:58:57 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73DDAAE05F;
        Tue,  7 Dec 2021 20:58:57 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20C65AE063;
        Tue,  7 Dec 2021 20:58:52 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:58:51 +0000 (GMT)
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
Subject: [PATCH 12/32] s390/pci: get SHM information from list pci
Date:   Tue,  7 Dec 2021 15:57:23 -0500
Message-Id: <20211207205743.150299-13-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OPth8sHDxfG4vF8-ZSi5JMaSEI5VaWgY
X-Proofpoint-GUID: LN46INZaC16xgf4LbZCBSJJIW8Uawuuq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM will need information on the special handle mask used to indicate
emulated devices.  In order to obtain this, a new type of list pci call
must be made to gather the information.  Remove the unused data pointer
from clp_list_pci and __clp_add and instead optionally pass a pointer to
a model-dependent-data field.  Additionally, allow for clp_list_pci calls
that don't specify a callback - in this case, just do the first pass of
list pci and exit.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h     |  6 ++++++
 arch/s390/include/asm/pci_clp.h |  2 +-
 arch/s390/pci/pci.c             | 19 +++++++++++++++++++
 arch/s390/pci/pci_clp.c         | 16 ++++++++++------
 4 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 00a2c24d6d2b..86f43644756d 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -219,12 +219,18 @@ int zpci_unregister_ioat(struct zpci_dev *, u8);
 void zpci_remove_reserved_devices(void);
 void zpci_update_fh(struct zpci_dev *zdev, u32 fh);
 
+int zpci_get_mdd(u32 *mdd);
+
 /* CLP */
+void *clp_alloc_block(gfp_t gfp_mask);
+void clp_free_block(void *ptr);
 int clp_setup_writeback_mio(void);
 int clp_scan_pci_devices(void);
 int clp_query_pci_fn(struct zpci_dev *zdev);
 int clp_enable_fh(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as);
 int clp_disable_fh(struct zpci_dev *zdev, u32 *fh);
+int clp_list_pci(struct clp_req_rsp_list_pci *rrb, u32 *mdd,
+		 void (*cb)(struct clp_fh_list_entry *));
 int clp_get_state(u32 fid, enum zpci_state *state);
 int clp_refresh_fh(u32 fid, u32 *fh);
 
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
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index af1c0ae017b1..175854c861cd 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -531,6 +531,25 @@ void zpci_update_fh(struct zpci_dev *zdev, u32 fh)
 		zpci_do_update_iomap_fh(zdev, fh);
 }
 
+int zpci_get_mdd(u32 *mdd)
+{
+	struct clp_req_rsp_list_pci *rrb;
+	int rc;
+
+	if (!mdd)
+		return -EINVAL;
+
+	rrb = clp_alloc_block(GFP_KERNEL);
+	if (!rrb)
+		return -ENOMEM;
+
+	rc = clp_list_pci(rrb, mdd, NULL);
+
+	clp_free_block(rrb);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(zpci_get_mdd);
+
 static struct resource *__alloc_res(struct zpci_dev *zdev, unsigned long start,
 				    unsigned long size, unsigned long flags)
 {
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index bc7446566cbc..e18a548ac22d 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -84,12 +84,12 @@ static __always_inline int clp_req(void *data, unsigned int lps)
 	return cc;
 }
 
-static void *clp_alloc_block(gfp_t gfp_mask)
+void *clp_alloc_block(gfp_t gfp_mask)
 {
 	return (void *) __get_free_pages(gfp_mask, get_order(CLP_BLK_SIZE));
 }
 
-static void clp_free_block(void *ptr)
+void clp_free_block(void *ptr)
 {
 	free_pages((unsigned long) ptr, get_order(CLP_BLK_SIZE));
 }
@@ -358,8 +358,8 @@ static int clp_list_pci_req(struct clp_req_rsp_list_pci *rrb,
 	return rc;
 }
 
-static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
-			void (*cb)(struct clp_fh_list_entry *, void *))
+int clp_list_pci(struct clp_req_rsp_list_pci *rrb, u32 *mdd,
+		 void (*cb)(struct clp_fh_list_entry *))
 {
 	u64 resume_token = 0;
 	int nentries, i, rc;
@@ -368,8 +368,12 @@ static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
 		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
 		if (rc)
 			return rc;
+		if (mdd)
+			*mdd = rrb->response.mdd;
+		if (!cb)
+			return 0;
 		for (i = 0; i < nentries; i++)
-			cb(&rrb->response.fh_list[i], data);
+			cb(&rrb->response.fh_list[i]);
 	} while (resume_token);
 
 	return rc;
@@ -398,7 +402,7 @@ static int clp_find_pci(struct clp_req_rsp_list_pci *rrb, u32 fid,
 	return -ENODEV;
 }
 
-static void __clp_add(struct clp_fh_list_entry *entry, void *data)
+static void __clp_add(struct clp_fh_list_entry *entry)
 {
 	struct zpci_dev *zdev;
 
-- 
2.27.0

