Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8FC68A50
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbfGONRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:17:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9536 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730185AbfGONRy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jul 2019 09:17:54 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6FDHeIn052539
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 09:17:53 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2trt5p07vk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 09:17:53 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Mon, 15 Jul 2019 14:17:51 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 15 Jul 2019 14:17:49 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6FDHlMq57213002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 13:17:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5923BA405B;
        Mon, 15 Jul 2019 13:17:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B187A4054;
        Mon, 15 Jul 2019 13:17:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jul 2019 13:17:46 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 1/1] s390/protvirt: restore force_dma_unencrypted()
Date:   Mon, 15 Jul 2019 15:17:19 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19071513-0008-0000-0000-000002FD613B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071513-0009-0000-0000-0000226AD343
Message-Id: <20190715131719.100650-1-pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-15_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907150160
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit e67a5ed1f86f ("dma-direct: Force unencrypted DMA under SME
for certain DMA masks"), force_dma_unencrypted() is broken on s390
(under protvirt). Before used to return sev_active(), after it became
practically architecture specific, with the default implementation
always returning false.

Let's restore the old behavior of force_dma_unencrypted().

Note: we still need sev_active() defined because of the reference
in fs/core/vmcore, but this one is likely to go away soon along
with the need for an s390 sev_active().

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: e67a5ed1f86f ("dma-direct: Force unencrypted DMA under SME for
certain DMA masks")

--

Thiago has a path that gets rid of the fs/core/vmcore reference. Link:
https://patchwork.ozlabs.org/patch/1131571/

Prior discussion:
https://www.spinics.net/lists/kernel/msg3189113.html
---
 arch/s390/Kconfig                   | 1 +
 arch/s390/include/asm/mem_encrypt.h | 2 +-
 arch/s390/mm/init.c                 | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 5d8570ed6cab..a4ad2733eedf 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -189,6 +189,7 @@ config S390
 	select VIRT_CPU_ACCOUNTING
 	select ARCH_HAS_SCALED_CPUTIME
 	select HAVE_NMI
+	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
 	select SWIOTLB
 	select GENERIC_ALLOCATOR
 
diff --git a/arch/s390/include/asm/mem_encrypt.h b/arch/s390/include/asm/mem_encrypt.h
index 3eb018508190..f8453f8cc191 100644
--- a/arch/s390/include/asm/mem_encrypt.h
+++ b/arch/s390/include/asm/mem_encrypt.h
@@ -7,7 +7,7 @@
 #define sme_me_mask	0ULL
 
 static inline bool sme_active(void) { return false; }
-extern bool sev_active(void);
+static inline bool sev_active(void) { return false; }
 
 int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index f0bee6af3960..023ab4221687 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -156,7 +156,7 @@ int set_memory_decrypted(unsigned long addr, int numpages)
 }
 
 /* are we a protected virtualization guest? */
-bool sev_active(void)
+bool force_dma_unencrypted(struct device *dev)
 {
 	return is_prot_virt_guest();
 }
-- 
2.17.1

