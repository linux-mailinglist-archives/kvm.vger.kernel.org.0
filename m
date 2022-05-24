Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA4F533120
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbiEXTB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 15:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240679AbiEXTAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 15:00:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22765C660;
        Tue, 24 May 2022 11:59:48 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OInGKh005912;
        Tue, 24 May 2022 18:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vU7gY8729myJN2ToLA4NHWV0BlMu879Xs8d/nrFHg1g=;
 b=PUhSRd2+czZJY8lL6e18a4S6CGBX4QJOyXwoFxNnVhu32QBPDIOuHwq26pwQCdZ060Kn
 NlGsWcteT3kVXFkAj4vU1md1QZnM+10OroO/TGukHbsw8PL4YfNot/Xt+PDMB+1cYsHO
 0SboYIAnXYGAXqJWQ/DuA1j+/O4dLRHyY9/NVa4mqB/TofqyVxMNGBxMTLBNWPCts42P
 wwLD1XnF9cXYHyvqLdUlzz4cUZIktuL4eTpLD5kE3z57x8Qxgji+1GnJMCEqcWtFCicG
 yKn48PeZr/gIWx7oPjOohvDdjkURpoBXldMKP+rq9UGLCuunZhVgVjCFzmq0T4bw8mWa sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94yr057j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:35 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIpbKT014152;
        Tue, 24 May 2022 18:59:34 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94yr0578-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:34 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OIqtHU031425;
        Tue, 24 May 2022 18:59:34 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3g93v80nkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:34 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OIxWVw32768336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:59:32 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B92EDBE056;
        Tue, 24 May 2022 18:59:32 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80BEFBE051;
        Tue, 24 May 2022 18:59:30 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 18:59:30 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v8 08/22] s390/pci: stash associated GISA designation
Date:   Tue, 24 May 2022 14:58:53 -0400
Message-Id: <20220524185907.140285-9-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524185907.140285-1-mjrosato@linux.ibm.com>
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SAWSoeXBZ6II9ljpbG1rDDL1ZCfq1APG
X-Proofpoint-GUID: AvPpQEEflarsqweTd-0QrIgBy1YfFW_U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=662
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2205240090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For passthrough devices, we will need to know the GISA designation of the
guest if interpretation facilities are to be used.  Setup to stash this in
the zdev and set a default of 0 (no GISA designation) for now; a subsequent
patch will set a valid GISA designation for passthrough devices.
Also, extend mpcific routines to specify this stashed designation as part
of the mpcific command.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h     | 1 +
 arch/s390/include/asm/pci_clp.h | 3 ++-
 arch/s390/pci/pci.c             | 6 ++++++
 arch/s390/pci/pci_clp.c         | 5 +++++
 arch/s390/pci/pci_irq.c         | 5 +++++
 5 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index fdb9745ee998..42a4a312a6dd 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -123,6 +123,7 @@ struct zpci_dev {
 	enum zpci_state state;
 	u32		fid;		/* function ID, used by sclp */
 	u32		fh;		/* function handle, used by insn's */
+	u32		gisa;		/* GISA designation for passthrough */
 	u16		vfn;		/* virtual function number */
 	u16		pchid;		/* physical channel ID */
 	u8		pfgid;		/* function group ID */
diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
index 1f4b666e85ee..f3286bc5ba6e 100644
--- a/arch/s390/include/asm/pci_clp.h
+++ b/arch/s390/include/asm/pci_clp.h
@@ -173,7 +173,8 @@ struct clp_req_set_pci {
 	u16 reserved2;
 	u8 oc;				/* operation controls */
 	u8 ndas;			/* number of dma spaces */
-	u64 reserved3;
+	u32 reserved3;
+	u32 gisa;			/* GISA designation */
 } __packed;
 
 /* Set PCI function response */
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index e563cb65c0c4..a86cd1cbb80e 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -120,6 +120,7 @@ int zpci_register_ioat(struct zpci_dev *zdev, u8 dmaas,
 	fib.pba = base;
 	fib.pal = limit;
 	fib.iota = iota | ZPCI_IOTA_RTTO_FLAG;
+	fib.gd = zdev->gisa;
 	cc = zpci_mod_fc(req, &fib, &status);
 	if (cc)
 		zpci_dbg(3, "reg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
@@ -133,6 +134,8 @@ int zpci_unregister_ioat(struct zpci_dev *zdev, u8 dmaas)
 	struct zpci_fib fib = {0};
 	u8 cc, status;
 
+	fib.gd = zdev->gisa;
+
 	cc = zpci_mod_fc(req, &fib, &status);
 	if (cc)
 		zpci_dbg(3, "unreg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
@@ -160,6 +163,7 @@ int zpci_fmb_enable_device(struct zpci_dev *zdev)
 	atomic64_set(&zdev->unmapped_pages, 0);
 
 	fib.fmb_addr = virt_to_phys(zdev->fmb);
+	fib.gd = zdev->gisa;
 	cc = zpci_mod_fc(req, &fib, &status);
 	if (cc) {
 		kmem_cache_free(zdev_fmb_cache, zdev->fmb);
@@ -178,6 +182,8 @@ int zpci_fmb_disable_device(struct zpci_dev *zdev)
 	if (!zdev->fmb)
 		return -EINVAL;
 
+	fib.gd = zdev->gisa;
+
 	/* Function measurement is disabled if fmb address is zero */
 	cc = zpci_mod_fc(req, &fib, &status);
 	if (cc == 3) /* Function already gone. */
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index 1057d7af4a55..deed35edea14 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -229,12 +229,16 @@ static int clp_set_pci_fn(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as, u8 comma
 {
 	struct clp_req_rsp_set_pci *rrb;
 	int rc, retries = 100;
+	u32 gisa = 0;
 
 	*fh = 0;
 	rrb = clp_alloc_block(GFP_KERNEL);
 	if (!rrb)
 		return -ENOMEM;
 
+	if (command != CLP_SET_DISABLE_PCI_FN)
+		gisa = zdev->gisa;
+
 	do {
 		memset(rrb, 0, sizeof(*rrb));
 		rrb->request.hdr.len = sizeof(rrb->request);
@@ -243,6 +247,7 @@ static int clp_set_pci_fn(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as, u8 comma
 		rrb->request.fh = zdev->fh;
 		rrb->request.oc = command;
 		rrb->request.ndas = nr_dma_as;
+		rrb->request.gisa = gisa;
 
 		rc = clp_req(rrb, CLP_LPS_PCI);
 		if (rrb->response.hdr.rsp == CLP_RC_SETPCIFN_BUSY) {
diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index f2b3145b6697..a2b42a63a53b 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -43,6 +43,7 @@ static int zpci_set_airq(struct zpci_dev *zdev)
 	fib.fmt0.aibvo = 0;	/* each zdev has its own interrupt vector */
 	fib.fmt0.aisb = virt_to_phys(zpci_sbv->vector) + (zdev->aisb / 64) * 8;
 	fib.fmt0.aisbo = zdev->aisb & 63;
+	fib.gd = zdev->gisa;
 
 	return zpci_mod_fc(req, &fib, &status) ? -EIO : 0;
 }
@@ -54,6 +55,8 @@ static int zpci_clear_airq(struct zpci_dev *zdev)
 	struct zpci_fib fib = {0};
 	u8 cc, status;
 
+	fib.gd = zdev->gisa;
+
 	cc = zpci_mod_fc(req, &fib, &status);
 	if (cc == 3 || (cc == 1 && status == 24))
 		/* Function already gone or IRQs already deregistered. */
@@ -72,6 +75,7 @@ static int zpci_set_directed_irq(struct zpci_dev *zdev)
 	fib.fmt = 1;
 	fib.fmt1.noi = zdev->msi_nr_irqs;
 	fib.fmt1.dibvo = zdev->msi_first_bit;
+	fib.gd = zdev->gisa;
 
 	return zpci_mod_fc(req, &fib, &status) ? -EIO : 0;
 }
@@ -84,6 +88,7 @@ static int zpci_clear_directed_irq(struct zpci_dev *zdev)
 	u8 cc, status;
 
 	fib.fmt = 1;
+	fib.gd = zdev->gisa;
 	cc = zpci_mod_fc(req, &fib, &status);
 	if (cc == 3 || (cc == 1 && status == 24))
 		/* Function already gone or IRQs already deregistered. */
-- 
2.27.0

