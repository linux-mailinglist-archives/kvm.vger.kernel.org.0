Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E29B2F47DF
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbhAMJmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727345AbhAMJmZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:25 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9XdNr135653;
        Wed, 13 Jan 2021 04:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=S6GFKR32bZeIaFLowyDYhSyXr4ztMq6nXbUXvw5LcTQ=;
 b=L1xbP4NpoBxqxDGyMfe2Y/NGgO8PCMPr40GZwdGGkFMGg7Kx4VC35jQolM3mHRl21niR
 tiBv6MYatDR1zy/XNF1pPp7IgkMHoRMdBR4gZIuaavLts9mIt77WuxoYCtzRUwnn0Ekl
 9UY4ffUWxxtoUXeHosa34zV+n87Nim6MnMXjZEXfrageThqfN3eUCaoGFHrsLNNSyPca
 sbuoYdZ5ro6QKrtcg7QveA6IjVGSB0P74LeVsxSZxX/wmUV9jV0DSQeLd2iTxtE+B5G+
 Hm4qJtQ2zfqE3AUj/vsmjlCNxCGJ/jknj+FwX16bFm7H0009nVyavopkFslMXSNY0ShL 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361uq2vjaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:44 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9YDPG138782;
        Wed, 13 Jan 2021 04:41:44 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361uq2vj9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:43 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9SHJu001148;
        Wed, 13 Jan 2021 09:41:41 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448cuyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fcF348365942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE4B0A4057;
        Wed, 13 Jan 2021 09:41:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CBA2A4053;
        Wed, 13 Jan 2021 09:41:38 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:38 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 13/14] s390/mm: Pull pmd invalid check in gmap_pmd_op_walk
Date:   Wed, 13 Jan 2021 09:41:12 +0000
Message-Id: <20210113094113.133668-14-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113094113.133668-1-frankja@linux.ibm.com>
References: <20210113094113.133668-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not yet sure if I'll keep this.

The walk should only walk and not check I, but then it looks way
nicer.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index bc89fb974367..c4778ded8450 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -956,7 +956,8 @@ static inline pmd_t *gmap_pmd_op_walk(struct gmap *gmap, unsigned long gaddr,
 	}
 
 	pmdp = (pmd_t *) gmap_table_walk(gmap, gaddr, 1);
-	if (!pmdp || pmd_none(*pmdp)) {
+	if (!pmdp || pmd_none(*pmdp) ||
+	    pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID) {
 		if (*ptl)
 			spin_unlock(*ptl);
 		pmdp = NULL;
@@ -1165,7 +1166,7 @@ static int gmap_protect_range(struct gmap *gmap, unsigned long gaddr,
 			return vmaddr;
 		vmaddr |= gaddr & ~PMD_MASK;
 		pmdp = gmap_pmd_op_walk(gmap, gaddr, vmaddr, &ptl_pmd);
-		if (pmdp && !(pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID)) {
+		if (pmdp) {
 			if (!pmd_large(*pmdp)) {
 				ptep = gmap_pte_from_pmd(gmap, pmdp, gaddr,
 							 &ptl_pte);
@@ -1274,7 +1275,7 @@ int gmap_read_table(struct gmap *gmap, unsigned long gaddr, unsigned long *val)
 		if (IS_ERR_VALUE(vmaddr))
 			return vmaddr;
 		pmdp = gmap_pmd_op_walk(gmap, gaddr, vmaddr, &ptl_pmd);
-		if (pmdp && !(pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID)) {
+		if (pmdp) {
 			if (!pmd_large(*pmdp)) {
 				ptep = gmap_pte_from_pmd(gmap, pmdp, vmaddr, &ptl_pte);
 				if (ptep) {
@@ -1388,7 +1389,7 @@ static int gmap_protect_rmap(struct gmap *sg, unsigned long raddr,
 			return vmaddr;
 		vmaddr |= paddr & ~PMD_MASK;
 		pmdp = gmap_pmd_op_walk(parent, paddr, vmaddr, &ptl_pmd);
-		if (pmdp && !(pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID)) {
+		if (pmdp) {
 			if (!pmd_large(*pmdp)) {
 				ptl_pte = NULL;
 				ptep = gmap_pte_from_pmd(parent, pmdp, paddr,
@@ -2378,8 +2379,7 @@ int gmap_shadow_segment(struct gmap *sg, unsigned long saddr, pmd_t pmd)
 				break;
 			}
 			spmd = *spmdp;
-			if (!(pmd_val(spmd) & _SEGMENT_ENTRY_INVALID) &&
-			    !((pmd_val(spmd) & _SEGMENT_ENTRY_PROTECT) &&
+			if (!((pmd_val(spmd) & _SEGMENT_ENTRY_PROTECT) &&
 			      !(pmd_val(pmd) & _SEGMENT_ENTRY_PROTECT))) {
 
 				pmd_val(*spmdp) |= _SEGMENT_ENTRY_GMAP_VSIE;
@@ -2452,7 +2452,7 @@ int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte)
 			break;
 		rc = -EAGAIN;
 		spmdp = gmap_pmd_op_walk(parent, paddr, vmaddr, &ptl_pmd);
-		if (spmdp && !(pmd_val(*spmdp) & _SEGMENT_ENTRY_INVALID)) {
+		if (spmdp) {
 			/* Get page table pointer */
 			tptep = (pte_t *) gmap_table_walk(sg, saddr, 0);
 			if (!tptep) {
@@ -2886,9 +2886,6 @@ static bool gmap_test_and_clear_dirty_pmd(struct gmap *gmap, pmd_t *pmdp,
 					  unsigned long gaddr,
 					  unsigned long vmaddr)
 {
-	if (pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID)
-		return false;
-
 	/* Already protected memory, which did not change is clean */
 	if (pmd_val(*pmdp) & _SEGMENT_ENTRY_PROTECT &&
 	    !(pmd_val(*pmdp) & _SEGMENT_ENTRY_GMAP_UC))
-- 
2.27.0

