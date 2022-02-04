Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCF84AA1E1
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbiBDVQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:16:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62560 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242135AbiBDVQL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:11 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214K08NQ003319;
        Fri, 4 Feb 2022 21:16:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Yh7aAYl9nehFzILhLmRaOMjsAZGm+FYiJQywVPp+8Nk=;
 b=YbmyHRH/xhXlxmDVtXafsxhclzUACD/e855dOjryKyGqi6DohTdACVVU/jAtyk/heo00
 ugiWqPriOpnRh7+qKf8V5wDUOyltmFg2fKSO8SHfRF6jB4AcnmVryQC7LmCKpHr5CyBI
 lNevnL5kJ0+uWJOsHgMDOsody6WsmjU8UB5O8p/+S5otqw1RyTylQliJitsnGn+61Rru
 Ezfnl0c8u4dNr+KnRLrtUS6M64mkgh2HVbUgBgGjbnWELh7+jXN7OZ5dBzp09s91RTPj
 RO9hhTV1Po5OTFX2g7DuwElQuXn6jiChY1iJ7aXTCkb2ZNJBcyE+5JUbFpabKIWSXPnm EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0rt5nmsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:10 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LGAOY002791;
        Fri, 4 Feb 2022 21:16:10 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0rt5nms2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:10 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCa9b022102;
        Fri, 4 Feb 2022 21:16:09 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3e0r0kav5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:09 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LG7nE37552574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:07 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A46FD136060;
        Fri,  4 Feb 2022 21:16:07 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9E68136066;
        Fri,  4 Feb 2022 21:16:05 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:05 +0000 (GMT)
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
Subject: [PATCH v3 12/30] s390/pci: get SHM information from list pci
Date:   Fri,  4 Feb 2022 16:15:18 -0500
Message-Id: <20220204211536.321475-13-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M3mwsdhdp7s_aqzvsiUUEgY07m8drPY5
X-Proofpoint-ORIG-GUID: 28QxcQMTzWsK1imgHtOdPXtYewTbJcd-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM will need information on the special handle mask used to indicate
emulated devices.  In order to obtain this, a new type of list pci call
must be made to gather the information.  Extend clp_list_pci_req to
also fetch the model-dependent-data field that holds this mask.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h     |  1 +
 arch/s390/include/asm/pci_clp.h |  2 +-
 arch/s390/pci/pci_clp.c         | 25 ++++++++++++++++++++++---
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 3c0b9986dcdc..e8a3fd5bc169 100644
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
index d6189ed14f84..dc2041e97de4 100644
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
index dc733b58e74f..7477956be632 100644
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
@@ -468,6 +470,23 @@ int clp_get_state(u32 fid, enum zpci_state *state)
 	return rc;
 }
 
+int zpci_get_mdd(u32 *mdd)
+{
+	struct clp_req_rsp_list_pci *rrb;
+	u64 resume_token = 0;
+	int nentries, rc;
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

