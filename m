Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17554D8CE5
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244473AbiCNTsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244465AbiCNTsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:48:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03053E5E6;
        Mon, 14 Mar 2022 12:47:20 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EHeGtL004107;
        Mon, 14 Mar 2022 19:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ebvnXc/LVkIRCFIJy5fYs9U35v9NkWwTGRod9yTfngc=;
 b=Jka0VNOiNOfWFg9jweTFmWzjYVKxOVXzzn4nqs9loLmJG7E/HHQ5d9i98ezgkcnWI/Xg
 oroHJA1xN9/uqA/hJQrzPPaoNKsj8/2FN6h7QbPhukPTuCFQANEGm8J1tRe9G5otKPaV
 merOPFwLZs+EXjo+TWVATFnljYCL+JmitNlBx6dBpMFOTqVaHoAHLvTzSzC/hpGTf1sX
 zYuzJ9hI6QW1Xs9bAiq2PIIJBZaonN2TTj9lr3LG0fD2JjGaf4A5EUGevLUlzcFKCg7P
 75WInwVoArnRpizBnLACj+Sl5vw1jE6AceYMP5jgLcUjiR6kuvUoWeafSlqo+oF0qNAA ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6a714hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:09 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJRoqm002548;
        Mon, 14 Mar 2022 19:47:09 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6a714gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:09 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJl7O4014273;
        Mon, 14 Mar 2022 19:47:07 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02wdc.us.ibm.com with ESMTP id 3erk59g7vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:07 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJl6Sq48562486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:47:06 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BE7E112063;
        Mon, 14 Mar 2022 19:47:06 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9679E112064;
        Mon, 14 Mar 2022 19:46:56 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:46:56 +0000 (GMT)
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
Subject: [PATCH v4 12/32] s390/pci: get SHM information from list pci
Date:   Mon, 14 Mar 2022 15:44:31 -0400
Message-Id: <20220314194451.58266-13-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Lf5BTqB_yYxhwqdCekbHBxZNYS04n_Y0
X-Proofpoint-ORIG-GUID: _lRlT4AF9cB3zz3nwpaB73t-ubUS3D9l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

KVM will need information on the special handle mask used to indicate
emulated devices.  In order to obtain this, a new type of list pci call
must be made to gather the information.  Extend clp_list_pci_req to
also fetch the model-dependent-data field that holds this mask.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
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

