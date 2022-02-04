Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52804AA1D7
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242146AbiBDVQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:16:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20310 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241692AbiBDVQD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:03 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214KjJA0011444;
        Fri, 4 Feb 2022 21:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2hpO6Ze2kln0T95EMFtTPhiqenn+79q5JMR7e85bp6g=;
 b=NPfyni+lunbIR3ZN6JO1vFZK3l3mRBkqxmL3L0S57dbzujSpzJfoGUkGMEe+rZunV05Q
 XB2aU/pRUgaS/tZJoxQ8ZL94zCdkqv/AcUq0QbnaX3yDlzScDtfvaAzh/6BTknju1nOn
 wFc8GoUoBVu2/os0oVpk7+rBlaUFwO9pUdlMZPzd/7KttYoy4E19V9eoSiincGywLkQA
 I4+QdGVvBIrKy3RyfNso+IkGOno2k3CnVT4cSS4ywdLKgiLYZmpCk15Af89u+/EaKA4O
 ifA+jrheHUsOLk/9dL3EovqnStxGvg5gDS4hu5Y95EUx2h5qCxHb191RXFHS70usGdzB kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx0xs7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:02 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214KAd4j026083;
        Fri, 4 Feb 2022 21:16:02 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx0xs7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:02 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LDHTx029643;
        Fri, 4 Feb 2022 21:16:01 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 3e0r0vaus7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:00 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LFxwb27984204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:15:59 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B62E13605D;
        Fri,  4 Feb 2022 21:15:59 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96776136061;
        Fri,  4 Feb 2022 21:15:57 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:15:57 +0000 (GMT)
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
Subject: [PATCH v3 08/30] s390/pci: stash associated GISA designation
Date:   Fri,  4 Feb 2022 16:15:14 -0500
Message-Id: <20220204211536.321475-9-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 01RlsTiHBwliwWXvTTHWBB3iMpgXsss6
X-Proofpoint-ORIG-GUID: THmuQnR3_8039a1xx0Gb5z2K6sCMDCJC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxlogscore=841 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For passthrough devices, we will need to know the GISA designation of the
guest if interpretation facilities are to be used.  Setup to stash this in
the zdev and set a default of 0 (no GISA designation) for now; a subsequent
patch will set a valid GISA designation for passthrough devices.
Also, extend mpcific routines to specify this stashed designation as part
of the mpcific command.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h     | 1 +
 arch/s390/include/asm/pci_clp.h | 3 ++-
 arch/s390/pci/pci.c             | 6 ++++++
 arch/s390/pci/pci_clp.c         | 1 +
 arch/s390/pci/pci_irq.c         | 5 +++++
 5 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 90824be5ce9a..d07d7c3205de 100644
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
index 792f8e0f2178..ca9c29386de6 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -119,6 +119,7 @@ int zpci_register_ioat(struct zpci_dev *zdev, u8 dmaas,
 	fib.pba = base;
 	fib.pal = limit;
 	fib.iota = iota | ZPCI_IOTA_RTTO_FLAG;
+	fib.gd = zdev->gisa;
 	cc = zpci_mod_fc(req, &fib, &status);
 	if (cc)
 		zpci_dbg(3, "reg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
@@ -132,6 +133,8 @@ int zpci_unregister_ioat(struct zpci_dev *zdev, u8 dmaas)
 	struct zpci_fib fib = {0};
 	u8 cc, status;
 
+	fib.gd = zdev->gisa;
+
 	cc = zpci_mod_fc(req, &fib, &status);
 	if (cc)
 		zpci_dbg(3, "unreg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
@@ -159,6 +162,7 @@ int zpci_fmb_enable_device(struct zpci_dev *zdev)
 	atomic64_set(&zdev->unmapped_pages, 0);
 
 	fib.fmb_addr = virt_to_phys(zdev->fmb);
+	fib.gd = zdev->gisa;
 	cc = zpci_mod_fc(req, &fib, &status);
 	if (cc) {
 		kmem_cache_free(zdev_fmb_cache, zdev->fmb);
@@ -177,6 +181,8 @@ int zpci_fmb_disable_device(struct zpci_dev *zdev)
 	if (!zdev->fmb)
 		return -EINVAL;
 
+	fib.gd = zdev->gisa;
+
 	/* Function measurement is disabled if fmb address is zero */
 	cc = zpci_mod_fc(req, &fib, &status);
 	if (cc == 3) /* Function already gone. */
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index be077b39da33..4dcc37ddeeaf 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -240,6 +240,7 @@ static int clp_set_pci_fn(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as, u8 comma
 		rrb->request.fh = zdev->fh;
 		rrb->request.oc = command;
 		rrb->request.ndas = nr_dma_as;
+		rrb->request.gisa = zdev->gisa;
 
 		rc = clp_req(rrb, CLP_LPS_PCI);
 		if (rrb->response.hdr.rsp == CLP_RC_SETPCIFN_BUSY) {
diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 2f675355fd0c..a19ac0282929 100644
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

