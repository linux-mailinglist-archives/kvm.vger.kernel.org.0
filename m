Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAD25330E3
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 20:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240629AbiEXS7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 14:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240615AbiEXS7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 14:59:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4795D666;
        Tue, 24 May 2022 11:59:35 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIKjUw032178;
        Tue, 24 May 2022 18:59:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=prpxURb+6wsNx7vPsltFiA7tZXjghQyWratKcu8oDCs=;
 b=juKnObkD+4fyycnaGsOHt+G6ivy7BrJCkzstlSfMCMJ6MHRFb76hdXpu4F2NUDA/TLe5
 c9Pp48VSp4TfSKL3phOopPjrQU6KVtbCdD91vzXokXMDosQERThcS7MTCDZgwJsu2apa
 9ZtQFsqNr6x92GZLEkgHLfngj1B6OjCinOygjDhSGOaFITcEP0VL6DDM1EEqqSLgJVTC
 ZZWNSzrhaBc9G/gKR9MdOrxFJvyxQ6qDaIL560lw7pwdF+XOINhz8tU5zBC+BKCuzCb3
 SRckigsJODTZaywFhmDUtGdr1DrEn0hwkk4WPnoJ/ktD/eJvD94dR7mmPdD6HtdmYvWm ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94jf0mfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:30 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIxMPc015529;
        Tue, 24 May 2022 18:59:30 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94jf0mf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:30 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OIrvAC011874;
        Tue, 24 May 2022 18:59:29 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 3g93ut8nu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:29 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OIxSmG13828694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:59:28 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11FA6BE056;
        Tue, 24 May 2022 18:59:28 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 077A0BE063;
        Tue, 24 May 2022 18:59:26 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 18:59:25 +0000 (GMT)
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
        linux-doc@vger.kernel.org
Subject: [PATCH v8 06/22] s390/airq: allow for airq structure that uses an input vector
Date:   Tue, 24 May 2022 14:58:51 -0400
Message-Id: <20220524185907.140285-7-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524185907.140285-1-mjrosato@linux.ibm.com>
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OjzXFTGnxhCVrO2De-9HPUr7co5ePc7V
X-Proofpoint-GUID: m1BvGH1Ly5AlEVVKJshUAQ2q-homufWT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=800
 priorityscore=1501 impostorscore=0 spamscore=0 suspectscore=0 adultscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205240090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When doing device passthrough where interrupts are being forwarded from
host to guest, we wish to use a pinned section of guest memory as the
vector (the same memory used by the guest as the vector). To accomplish
this, add a new parameter for airq_iv_create which allows passing an
existing vector to be used instead of allocating a new one. The caller
is responsible for ensuring the vector is pinned in memory as well as for
unpinning the memory when the vector is no longer needed.

A subsequent patch will use this new parameter for zPCI interpretation.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/airq.h     |  4 +++-
 arch/s390/pci/pci_irq.c          |  8 ++++----
 drivers/s390/cio/airq.c          | 10 +++++++---
 drivers/s390/virtio/virtio_ccw.c |  2 +-
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/airq.h b/arch/s390/include/asm/airq.h
index 7918a7d09028..e82e5626e139 100644
--- a/arch/s390/include/asm/airq.h
+++ b/arch/s390/include/asm/airq.h
@@ -47,8 +47,10 @@ struct airq_iv {
 #define AIRQ_IV_PTR		4	/* Allocate the ptr array */
 #define AIRQ_IV_DATA		8	/* Allocate the data array */
 #define AIRQ_IV_CACHELINE	16	/* Cacheline alignment for the vector */
+#define AIRQ_IV_GUESTVEC	32	/* Vector is a pinned guest page */
 
-struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags);
+struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags,
+			       unsigned long *vec);
 void airq_iv_release(struct airq_iv *iv);
 unsigned long airq_iv_alloc(struct airq_iv *iv, unsigned long num);
 void airq_iv_free(struct airq_iv *iv, unsigned long bit, unsigned long num);
diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index b805c75252ed..87c7d121c255 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -296,7 +296,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		zdev->aisb = bit;
 
 		/* Create adapter interrupt vector */
-		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK);
+		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK, NULL);
 		if (!zdev->aibv)
 			return -ENOMEM;
 
@@ -419,7 +419,7 @@ static int __init zpci_directed_irq_init(void)
 	union zpci_sic_iib iib = {{0}};
 	unsigned int cpu;
 
-	zpci_sbv = airq_iv_create(num_possible_cpus(), 0);
+	zpci_sbv = airq_iv_create(num_possible_cpus(), 0, NULL);
 	if (!zpci_sbv)
 		return -ENOMEM;
 
@@ -441,7 +441,7 @@ static int __init zpci_directed_irq_init(void)
 		zpci_ibv[cpu] = airq_iv_create(cache_line_size() * BITS_PER_BYTE,
 					       AIRQ_IV_DATA |
 					       AIRQ_IV_CACHELINE |
-					       (!cpu ? AIRQ_IV_ALLOC : 0));
+					       (!cpu ? AIRQ_IV_ALLOC : 0), NULL);
 		if (!zpci_ibv[cpu])
 			return -ENOMEM;
 	}
@@ -458,7 +458,7 @@ static int __init zpci_floating_irq_init(void)
 	if (!zpci_ibv)
 		return -ENOMEM;
 
-	zpci_sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC);
+	zpci_sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, NULL);
 	if (!zpci_sbv)
 		goto out_free;
 
diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
index 230eb5b5b64e..34967e67249e 100644
--- a/drivers/s390/cio/airq.c
+++ b/drivers/s390/cio/airq.c
@@ -122,10 +122,12 @@ static inline unsigned long iv_size(unsigned long bits)
  * airq_iv_create - create an interrupt vector
  * @bits: number of bits in the interrupt vector
  * @flags: allocation flags
+ * @vec: pointer to pinned guest memory if AIRQ_IV_GUESTVEC
  *
  * Returns a pointer to an interrupt vector structure
  */
-struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
+struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags,
+			       unsigned long *vec)
 {
 	struct airq_iv *iv;
 	unsigned long size;
@@ -146,6 +148,8 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
 					     &iv->vector_dma);
 		if (!iv->vector)
 			goto out_free;
+	} else if (flags & AIRQ_IV_GUESTVEC) {
+		iv->vector = vec;
 	} else {
 		iv->vector = cio_dma_zalloc(size);
 		if (!iv->vector)
@@ -185,7 +189,7 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
 	kfree(iv->avail);
 	if (iv->flags & AIRQ_IV_CACHELINE && iv->vector)
 		dma_pool_free(airq_iv_cache, iv->vector, iv->vector_dma);
-	else
+	else if (!(iv->flags & AIRQ_IV_GUESTVEC))
 		cio_dma_free(iv->vector, size);
 	kfree(iv);
 out:
@@ -204,7 +208,7 @@ void airq_iv_release(struct airq_iv *iv)
 	kfree(iv->bitlock);
 	if (iv->flags & AIRQ_IV_CACHELINE)
 		dma_pool_free(airq_iv_cache, iv->vector, iv->vector_dma);
-	else
+	else if (!(iv->flags & AIRQ_IV_GUESTVEC))
 		cio_dma_free(iv->vector, iv_size(iv->bits));
 	kfree(iv->avail);
 	kfree(iv);
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 52c376d15978..410498d693f8 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -241,7 +241,7 @@ static struct airq_info *new_airq_info(int index)
 		return NULL;
 	rwlock_init(&info->lock);
 	info->aiv = airq_iv_create(VIRTIO_IV_BITS, AIRQ_IV_ALLOC | AIRQ_IV_PTR
-				   | AIRQ_IV_CACHELINE);
+				   | AIRQ_IV_CACHELINE, NULL);
 	if (!info->aiv) {
 		kfree(info);
 		return NULL;
-- 
2.27.0

