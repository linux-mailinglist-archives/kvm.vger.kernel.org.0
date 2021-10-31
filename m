Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4969440E19
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhJaMNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:13:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31732 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231720AbhJaMNo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:44 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19VBpnHu028086;
        Sun, 31 Oct 2021 12:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=W5DVq1ztv9uk7+XqIpIrveJKZPbF3dONor1NRbQrqP8=;
 b=JcrNx0areF0ciYv5hwOfbs6qlT9pUOh4Ij2UK9QJ01/K6mWqidOjxwSrXq2irKo7c6/O
 V3jiXRwSODeJHCWkDhpaC0itGoh/lCv9RkweSZ4HZ3xlZP0pA4mj1UjykJT++RxD0mwc
 Lzkb3xlNthVg3sDNtjMmrEMRlR1rtuXrJNcWp8Q/rGilhonwMUDJngc3KM3u3LUerTy8
 aL3z5Kx42Ik7ZVPLSDzoUuXxLm7AldDSMG1P2HGjVILtFsimImcYRAidO/1ruSQU0QkL
 L5IB97KEc2I5hosUL88P+599FGbfXYoStjNoiO6Yr8cWTZNb4LHZh62Og1I6JB9jRZpz WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1tn4r8n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:12 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VCBCPa022575;
        Sun, 31 Oct 2021 12:11:12 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1tn4r8mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:12 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC8x2v030674;
        Sun, 31 Oct 2021 12:11:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3c0wp94pd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VCB7r646137706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:11:07 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F51C42045;
        Sun, 31 Oct 2021 12:11:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BDF042042;
        Sun, 31 Oct 2021 12:11:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 31 Oct 2021 12:11:07 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id B33AEE056B; Sun, 31 Oct 2021 13:11:06 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 07/17] s390/mm: optimize set_guest_storage_key()
Date:   Sun, 31 Oct 2021 13:10:54 +0100
Message-Id: <20211031121104.14764-8-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P_TKzCDU0-ZF9gxgj7s5tnVZD1qyDBCj
X-Proofpoint-ORIG-GUID: oNojkwjQcNXdQyw-Jqto42Z5gG__xkh3
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=900 clxscore=1015
 mlxscore=0 adultscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

We already optimize get_guest_storage_key() to assume that if we don't have
a PTE table and don't have a huge page mapped that the storage key is 0.

Similarly, optimize set_guest_storage_key() to simply do nothing in case
the key to set is 0.

Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20210909162248.14969-9-david@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/mm/pgtable.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index e74cc59dcd67..1c9aeb361f8d 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -792,13 +792,23 @@ int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 	pmd_t *pmdp;
 	pte_t *ptep;
 
-	if (pmd_lookup(mm, addr, &pmdp))
+	/*
+	 * If we don't have a PTE table and if there is no huge page mapped,
+	 * we can ignore attempts to set the key to 0, because it already is 0.
+	 */
+	switch (pmd_lookup(mm, addr, &pmdp)) {
+	case -ENOENT:
+		return key ? -EFAULT : 0;
+	case 0:
+		break;
+	default:
 		return -EFAULT;
+	}
 
 	ptl = pmd_lock(mm, pmdp);
 	if (!pmd_present(*pmdp)) {
 		spin_unlock(ptl);
-		return -EFAULT;
+		return key ? -EFAULT : 0;
 	}
 
 	if (pmd_large(*pmdp)) {
-- 
2.31.1

