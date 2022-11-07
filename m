Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730D361F15C
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 11:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiKGK7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 05:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiKGK6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 05:58:50 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D14FACD;
        Mon,  7 Nov 2022 02:58:49 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A79RJoT031559;
        Mon, 7 Nov 2022 10:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mLQgHqgxLW4IBDzDlUE3URrpBRkD+w3wy+BnMK5/nJM=;
 b=RDgQcAR7ZuqPKpiaQ9s/ExcHCE39ZcgNepo4pS0PWvpepBdH8pT7IGPfdh0a3xTR3BYc
 Pp5qj/DRvAK0U8+2rJVAgzhGQBdRH8P9vU94nGEDqd/usklhC/C+IAb9MM7EQl0/Ewoz
 Fy1HZ5JpMyObbn3fLcPaao+hVkIKH0QSUH30jaArXuD9r6o55XZzpXk21Uk6vP/k7V3Q
 Ojr9Oop3Hn/mYkBC9LHpGiAd7Jy8TE95S+UgEeWa7ZlbCnugMJoDPwxc1gROTG/GROus
 2NvLk7yKOM7IzF5azo4nsJ7zyzMRZc734zh6wePALOWVb2XBsZOOHyb0p3nGqxDTe+I1 rg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1gky4f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 10:58:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7AoKKU017002;
        Mon, 7 Nov 2022 10:58:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3kngp5hs2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 10:58:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7AwhBo65405414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 10:58:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A75315204E;
        Mon,  7 Nov 2022 10:58:43 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 627315204F;
        Mon,  7 Nov 2022 10:58:43 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1] s390/mm: fix virtual-physical address confusion for swiotlb
Date:   Mon,  7 Nov 2022 11:58:43 +0100
Message-Id: <20221107105843.6641-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 43Ez8trfHkwAbl8Eu9zN5X4uMdrI0iS5
X-Proofpoint-GUID: 43Ez8trfHkwAbl8Eu9zN5X4uMdrI0iS5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=874 suspectscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

swiotlb passes virtual addresses to set_memory_encrypted() and
set_memory_decrypted(), but uv_remove_shared() and uv_set_shared()
expect physical addresses. This currently works, because virtual
and physical addresses are the same.

Add virt_to_phys() to resolve the virtual-physical confusion.

Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/mm/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 97d66a3e60fb..8b652654064e 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -146,7 +146,7 @@ int set_memory_encrypted(unsigned long addr, int numpages)
 
 	/* make specified pages unshared, (swiotlb, dma_free) */
 	for (i = 0; i < numpages; ++i) {
-		uv_remove_shared(addr);
+		uv_remove_shared(virt_to_phys((void *)addr));
 		addr += PAGE_SIZE;
 	}
 	return 0;
@@ -157,7 +157,7 @@ int set_memory_decrypted(unsigned long addr, int numpages)
 	int i;
 	/* make specified pages shared (swiotlb, dma_alloca) */
 	for (i = 0; i < numpages; ++i) {
-		uv_set_shared(addr);
+		uv_set_shared(virt_to_phys((void *)addr));
 		addr += PAGE_SIZE;
 	}
 	return 0;
-- 
2.37.3

