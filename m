Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF18F61F2A0
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 13:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiKGMMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 07:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbiKGMMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 07:12:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F131119;
        Mon,  7 Nov 2022 04:12:29 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7BgPpe026334;
        Mon, 7 Nov 2022 12:12:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f5ot82JlgfNJRspBUTvlagRyWaL/7Isrn31mVdyBN6A=;
 b=q80/3+nAvI0hao+6X/B/2TeSwYVlaDRXMXGJNiTxu5UPzIhlGePbe86d5rWfq/UCuIR7
 dal74M4ULznglE3efu4dSBuywFjjFPnBctsIaUbhu/9bgjYBHz/HRRpQa+6s/a+oZep1
 W/+LKSoiOUYUAtvNRHSnV7/joT+zXeuhNO2loJrYaS+hF10oF24z0B8kqlEl5Xj8Aybt
 Dd0PipUnw7EtVMGTuKJL4LDsx8mEgjyi/ixyzNUr17auQRFZH95S1lOMFTiHWkv5P5g5
 TKrfDvVvowZBwtvCcM4vJ08GQ4cPB88r9QaO013WnEtd7lLBGiTwW3nuZ/omFL1wXQbX vQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1mshcqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 12:12:28 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7C69Es016434;
        Mon, 7 Nov 2022 12:12:25 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3kngs4htxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 12:12:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7CCMsR40436178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 12:12:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C5B7A4054;
        Mon,  7 Nov 2022 12:12:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53185A405C;
        Mon,  7 Nov 2022 12:12:22 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 12:12:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 1/1] s390/mm: fix virtual-physical address confusion for swiotlb
Date:   Mon,  7 Nov 2022 13:12:21 +0100
Message-Id: <20221107121221.156274-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221107121221.156274-1-nrb@linux.ibm.com>
References: <20221107121221.156274-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -0MyYLMLVE33SSebxgjEIL8_xPiZzaKr
X-Proofpoint-ORIG-GUID: -0MyYLMLVE33SSebxgjEIL8_xPiZzaKr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_04,2022-11-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=979 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070099
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
 arch/s390/include/asm/mem_encrypt.h |  4 ++--
 arch/s390/mm/init.c                 | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/mem_encrypt.h b/arch/s390/include/asm/mem_encrypt.h
index 08a8b96606d7..b85e13505a0f 100644
--- a/arch/s390/include/asm/mem_encrypt.h
+++ b/arch/s390/include/asm/mem_encrypt.h
@@ -4,8 +4,8 @@
 
 #ifndef __ASSEMBLY__
 
-int set_memory_encrypted(unsigned long addr, int numpages);
-int set_memory_decrypted(unsigned long addr, int numpages);
+int set_memory_encrypted(unsigned long vaddr, int numpages);
+int set_memory_decrypted(unsigned long vaddr, int numpages);
 
 #endif	/* __ASSEMBLY__ */
 
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 97d66a3e60fb..d509656c67d7 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -140,25 +140,25 @@ void mark_rodata_ro(void)
 	debug_checkwx();
 }
 
-int set_memory_encrypted(unsigned long addr, int numpages)
+int set_memory_encrypted(unsigned long vaddr, int numpages)
 {
 	int i;
 
 	/* make specified pages unshared, (swiotlb, dma_free) */
 	for (i = 0; i < numpages; ++i) {
-		uv_remove_shared(addr);
-		addr += PAGE_SIZE;
+		uv_remove_shared(virt_to_phys((void *)vaddr));
+		vaddr += PAGE_SIZE;
 	}
 	return 0;
 }
 
-int set_memory_decrypted(unsigned long addr, int numpages)
+int set_memory_decrypted(unsigned long vaddr, int numpages)
 {
 	int i;
 	/* make specified pages shared (swiotlb, dma_alloca) */
 	for (i = 0; i < numpages; ++i) {
-		uv_set_shared(addr);
-		addr += PAGE_SIZE;
+		uv_set_shared(virt_to_phys((void *)vaddr));
+		vaddr += PAGE_SIZE;
 	}
 	return 0;
 }
-- 
2.37.3

