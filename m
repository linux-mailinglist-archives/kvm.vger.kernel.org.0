Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FA757D0E4
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiGUQNW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiGUQNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2E67AB1F;
        Thu, 21 Jul 2022 09:13:15 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFru1u006000;
        Thu, 21 Jul 2022 16:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=aWNBt4JTR07+9Q6VTWpDQonQwRa01GP89uyiHOS1XBE=;
 b=KcT76ZAhBwD6pYcjPwFkUisXBfK+c7vbaAuzPNIEnu1ha/QzALQyCg3ZZFJFb4LI6i64
 LNpaywBAaONrvxbEJKRFoCjfpWT832ct8gYo3nhAFgdqyupShZg3w2XvltYxFAgvPfQh
 jg0YBsTQSLI8/vXj/BO2NjgwVK9Q7A+HoPeUM2KY6rE1Ro6kCFUEIlffiUJDTYPZOmqD
 GVJzcbzP5OWDyaKNks3W8SCqDP2WewDfZ4OOLapKE7av0ipcI/QK15BwKELJ/1A+9jtu
 rcxACHIIrTwtLlmr+WOaeovaVeEfigcMrSs7b8o9VHNMkjJnDh9PyjAVySGyqvDQBwjK bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9um8f49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:14 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LG0Plw010530;
        Thu, 21 Jul 2022 16:13:14 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9um8f3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:13 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG7nqj029829;
        Thu, 21 Jul 2022 16:13:12 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3hbmy8were-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:11 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGD8pG24183106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:08 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEC3EA405B;
        Thu, 21 Jul 2022 16:13:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 271C7A4054;
        Thu, 21 Jul 2022 16:13:08 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:08 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL 08/42] s390/pci: stash associated GISA designation
Date:   Thu, 21 Jul 2022 18:12:28 +0200
Message-Id: <20220721161302.156182-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fNm8vBYTIOBjdW-NSA9zq2E0Ppfgyfs3
X-Proofpoint-GUID: FlK4QGTuXHFvqypJnGcDxmlPvO5KXMIN
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=799 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

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
Link: https://lore.kernel.org/r/20220606203325.110625-9-mjrosato@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
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
index bc980fd313d5..c8b9d866434c 100644
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
index 375e0a5120bc..d058c83467ef 100644
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
2.36.1

