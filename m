Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BEF2F47E1
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbhAMJmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727387AbhAMJmY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:24 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9XXjU144531;
        Wed, 13 Jan 2021 04:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EbRVPt4q1svCF2UehoIkBKLRJknMNrtbWp1ofIHLWHA=;
 b=NJgl7jMPTztT7Cv4WtZHJw91IFcK1JbTmClUmlSO/R7kntLRB9dydsQTLVOeqnhrnWST
 9/kIlgGl0epmduxeahx2M6DLYuvKhFMtsUANZQHBW7yTwFhyyfBn6mmRKIy5YwR/+EYw
 gS1aY5mpImGjfPWvIxH0btxBh3OPfM+3foWCmhyW5Rre4jtyGxRrV08TM9KJJ2OxJxhL
 kGHM7roaYQFFOlUJRg037CBcbRuFsXm4zt+9wbKKHqPdIV3nl0nG460I1Rp6f+OPduO0
 bjik1mZVtTkTBikKP5ZkgBBRUwddYoyOPQDEojmPFeFuVxni0SdOXfWGlgG9S4V989f6 cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361xb706s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:43 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9Z5m2155217;
        Wed, 13 Jan 2021 04:41:43 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361xb706rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:43 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9R4nA014211;
        Wed, 13 Jan 2021 09:41:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 35y448ag2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fXoJ29426162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE76EA4055;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A63DCA404D;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 10/14] s390/mm: Add simple ptep shadow function
Date:   Wed, 13 Jan 2021 09:41:09 +0000
Message-Id: <20210113094113.133668-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113094113.133668-1-frankja@linux.ibm.com>
References: <20210113094113.133668-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0 spamscore=0
 mlxlogscore=860 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's factor out setting the shadow pte, so we can reuse that function
for later huge to 4k shadows where we don't have a spte or spgste.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h |  1 +
 arch/s390/mm/pgtable.c          | 24 ++++++++++++++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 6d6ad508f9c7..d2c005f35c9c 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1145,6 +1145,7 @@ void ptep_zap_unused(struct mm_struct *mm, unsigned long addr,
 void ptep_zap_key(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 int ptep_shadow_pte(struct mm_struct *mm, unsigned long saddr,
 		    pte_t *sptep, pte_t *tptep, pte_t pte);
+void ptep_shadow_set(pte_t spte, pte_t *tptep, pte_t pte);
 void ptep_unshadow_pte(struct mm_struct *mm, unsigned long saddr, pte_t *ptep);
 
 unsigned long ptep_get_and_clear_notification_bits(pte_t *ptep);
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 16896f936d32..6066c7ef027a 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -645,11 +645,24 @@ int ptep_force_prot(struct mm_struct *mm, unsigned long addr,
 	return 0;
 }
 
+void ptep_shadow_set(pte_t spte, pte_t *tptep, pte_t pte)
+{
+	pte_t tpte;
+	pgste_t tpgste;
+
+	tpgste = pgste_get_lock(tptep);
+	pte_val(tpte) = (pte_val(spte) & PAGE_MASK) |
+		(pte_val(pte) & _PAGE_PROTECT);
+	/* don't touch the storage key - it belongs to parent pgste */
+	tpgste = pgste_set_pte(tptep, tpgste, tpte);
+	pgste_set_unlock(tptep, tpgste);
+}
+
 int ptep_shadow_pte(struct mm_struct *mm, unsigned long saddr,
 		    pte_t *sptep, pte_t *tptep, pte_t pte)
 {
-	pgste_t spgste, tpgste;
-	pte_t spte, tpte;
+	pgste_t spgste;
+	pte_t spte;
 	int rc = -EAGAIN;
 
 	if (!(pte_val(*tptep) & _PAGE_INVALID))
@@ -660,12 +673,7 @@ int ptep_shadow_pte(struct mm_struct *mm, unsigned long saddr,
 	    !((pte_val(spte) & _PAGE_PROTECT) &&
 	      !(pte_val(pte) & _PAGE_PROTECT))) {
 		pgste_val(spgste) |= PGSTE_VSIE_BIT;
-		tpgste = pgste_get_lock(tptep);
-		pte_val(tpte) = (pte_val(spte) & PAGE_MASK) |
-				(pte_val(pte) & _PAGE_PROTECT);
-		/* don't touch the storage key - it belongs to parent pgste */
-		tpgste = pgste_set_pte(tptep, tpgste, tpte);
-		pgste_set_unlock(tptep, tpgste);
+		ptep_shadow_set(spte, tptep, pte);
 		rc = 1;
 	}
 	pgste_set_unlock(sptep, spgste);
-- 
2.27.0

