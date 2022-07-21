Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559BD57D10C
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiGUQN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbiGUQNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7B88876A;
        Thu, 21 Jul 2022 09:13:31 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LG6jPj006248;
        Thu, 21 Jul 2022 16:13:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=iZhYZlaeqI14CE9sDXBtq9KvKUbeiDgfN+y8uu9eJvg=;
 b=cqPUAMIrXMymUS1JYt3eUQqa18SRceOl3HM6bMPGtdFOR3qttb11fg4a8et20OkqdWVa
 0sPWm3bxSMjMbs0Y3FPzhaBuAWtBNvraCOZKk5jbQ5RM1m+4Rj5U/B17FGv6HRG/T9il
 8NC4iY/jo/X/nxyH+DLuN2lHnF8+2gX/mR/QbB3zGuDKND/ddVlIlEFqdrHKVvpr2ZC6
 NWirLJYT6AC/mqUxT/2GWuCqcR9ybZffcu0tlOQoFfZw/EVJ/Da2NekhK8JJACJ2EOTe
 J3fGRJQb7Mgg3ixKo/pYOVe1laEA2FkmfhsFt8pqWX3vKRiAFiaIpnpXsqCZeyfoZmKE Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9tfgfq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:29 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LG78js010728;
        Thu, 21 Jul 2022 16:13:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9tfgfnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG7B9S029986;
        Thu, 21 Jul 2022 16:13:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj769a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGD7Zb23986648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63BCEA405F;
        Thu, 21 Jul 2022 16:13:07 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7D5BA4054;
        Thu, 21 Jul 2022 16:13:06 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:06 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [GIT PULL 06/42] s390/airq: allow for airq structure that uses an input vector
Date:   Thu, 21 Jul 2022 18:12:26 +0200
Message-Id: <20220721161302.156182-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FZtvF4qM0OVRT-l3YFXQofZIb3aRIyXf
X-Proofpoint-ORIG-GUID: NHJC_-n9qslELSEP9JQ2dneMrqCept1v
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 mlxlogscore=868 clxscore=1015 bulkscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

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
Link: https://lore.kernel.org/r/20220606203325.110625-7-mjrosato@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
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
index 58cca50996ee..51bef226d33f 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -242,7 +242,7 @@ static struct airq_info *new_airq_info(int index)
 		return NULL;
 	rwlock_init(&info->lock);
 	info->aiv = airq_iv_create(VIRTIO_IV_BITS, AIRQ_IV_ALLOC | AIRQ_IV_PTR
-				   | AIRQ_IV_CACHELINE);
+				   | AIRQ_IV_CACHELINE, NULL);
 	if (!info->aiv) {
 		kfree(info);
 		return NULL;
-- 
2.36.1

