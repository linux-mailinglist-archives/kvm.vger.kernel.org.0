Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013F5638A73
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiKYMnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiKYMnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:43:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C761ADA3;
        Fri, 25 Nov 2022 04:43:06 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APCDSYo027195;
        Fri, 25 Nov 2022 12:43:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=xLdAUNlIDHH/dXoyPgvIDGCNVlMVNrkBNW9qKRMjDMI=;
 b=IKTbfOlzgPmW8wwjbsiYO+T1yf8+Qxf3ior0AcuLxzheDHCS5Sz6IvaMSOwST+fNv59K
 PeAnFQLzivA8PA5Mkjlg6QlMgBf0sBLSbv528HXByEeAh7p5jXsgpNpcc1cZrVA8wQOI
 X79xpGi/nlZVrVXHEMQ35sAzg7DNnfieggvNAbS89MgLhdeQBHG3xDtgly+OQg3pLe26
 7lEfF/CtqGz+GXBot6na7LB8PHOtEcoWkYFV6FBiMflPCVXLaYeKv2WdB14bTdE6Cqur
 GwfNcApu23BnQEzbl3TO20wcSGluGNtnORXDxDIiq6vowrIqO9rY4OYMH4eMmBplMlPP 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2wh5rjgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:05 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APCaRIw015645;
        Fri, 25 Nov 2022 12:43:05 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2wh5rjft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:04 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APCZZln028938;
        Fri, 25 Nov 2022 12:43:03 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8xwna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APChfoV328346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:43:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D07124C044;
        Fri, 25 Nov 2022 12:42:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 553AE4C046;
        Fri, 25 Nov 2022 12:42:59 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 12:42:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [GIT PULL 07/15] s390/mm: fix virtual-physical address confusion for swiotlb
Date:   Fri, 25 Nov 2022 13:39:39 +0100
Message-Id: <20221125123947.31047-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125123947.31047-1-frankja@linux.ibm.com>
References: <20221125123947.31047-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bZQqRurcPOMMk7V7S51oL8ANy1p3Yw8R
X-Proofpoint-GUID: n9nKaXTrSPuJ7PPcsImtJ4yJTtfHdvUU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=990
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

swiotlb passes virtual addresses to set_memory_encrypted() and
set_memory_decrypted(), but uv_remove_shared() and uv_set_shared()
expect physical addresses. This currently works, because virtual
and physical addresses are the same.

Add virt_to_phys() to resolve the virtual-physical confusion.

Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20221107121221.156274-2-nrb@linux.ibm.com
Message-Id: <20221107121221.156274-2-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.38.1

