Return-Path: <kvm+bounces-37490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94EBAA2AC6C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:26:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77980188489B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E7F1EDA2D;
	Thu,  6 Feb 2025 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qb2ap9S7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2578D1C700E;
	Thu,  6 Feb 2025 15:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738855578; cv=none; b=CtYwxYvUBBYP/Dp8mW4f0pyjFSWt7c4v7n081Vhi/TfcP7RgQXhKBNa/GCL5KZX8Z0DHWqErXQQ/Rvy1yXe6BCqiiow5d+pqk3Bsf5sor6AHxNgIY0wR4Dh1qvKoxOreSdrYt1Z7m0/snFiua8XjpFXyiPQDq3QC0U/T2lNxPkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738855578; c=relaxed/simple;
	bh=tcVpN1qc+CNHOZ+Drmas1nokJSHGtwyKNe/PAK4Joq4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pHj1ZRgQJl+cgkjXqb3pPUVar3MUzAbk5LWUnsK+Weue932RNSaSom4tahLbXad43SvsiranYcb6K6M4pjGbmO+TKAYWG+/AshYieCAVPhZmVwR83xOllOAQquBqKl5MpKvVf3d3KbrFdPBIzR0w03uhV63gjFCuz+vNElQAoo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qb2ap9S7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 516ESKHg009550;
	Thu, 6 Feb 2025 15:26:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=OgRc2XZeqDfYKX9OdYVxO+K/KEjR0lZARFuay+GGR
	9k=; b=qb2ap9S7u1aVUz6bNDvBQ4aU6I4fKWQon7SKn90BN1svxFM7JoUxSlyps
	XN+uL2fD3xQAGPKj9XSTEWBi9+NESzpWq/smB98UckJD8+/njkN+JwbFtijurrR4
	Mi+f3wrwW2JeZqMgiA/mg8scvmnWactG1TmIYVBbTafCV6DW6ZLq7L6xHLXmJnKn
	WHLsqUHzWlJ2DSkKnGmIr4aRQW9Zsd91MvRDGb6EYIlpgDWCVWYLGfGIiKy2/JKT
	IAWSCDWahZOLueOH15ydJmhj4lCivMgx6Tt2aZJkyPOjeLEmrdqdG5QT+oObGsjv
	ebfvgUgelIfTx6Th9UmU85fwrqnkw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44mk5a3wbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 15:26:14 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 516ElFN6024635;
	Thu, 6 Feb 2025 15:26:13 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxxneyvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 15:26:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 516FQ9g339911804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Feb 2025 15:26:09 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D65A420135;
	Thu,  6 Feb 2025 15:01:45 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AEA6620134;
	Thu,  6 Feb 2025 15:01:45 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Feb 2025 15:01:45 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        hca@linux.ibm.com
Subject: [kvm-unit-tests PATCH] lib: s390x: css: Cleanup chsc inline assembly
Date: Thu,  6 Feb 2025 14:58:49 +0000
Message-ID: <20250206150128.147206-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8QwqespLYpMUgXJPxR3jFWOhGj-XcWLa
X-Proofpoint-ORIG-GUID: 8QwqespLYpMUgXJPxR3jFWOhGj-XcWLa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_03,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=877 mlxscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 impostorscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502060123

Name the CHSC command block pointer instead of naming it "p".

Also replace the two "m" constraints with a memory globber so the
constraints are easier to read.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---

To me it makes more sense to have a separate commit that has a message
explaining why we changed it instead of sending a v2, so here it is.

---
 lib/s390x/css.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 06bb59c7..167f8e83 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -364,16 +364,16 @@ bool get_chsc_scsc(void);
 #define CHSC_RSP_EBUSY	0x000B
 #define CHSC_RSP_MAX	0x000B
 
-static inline int _chsc(void *p)
+static inline int _chsc(void *com_blk)
 {
 	int cc;
 
-	asm volatile(" .insn   rre,0xb25f0000,%2,0\n"
+	asm volatile(" .insn   rre,0xb25f0000,%[com_blk],0\n"
 		     " ipm     %[cc]\n"
 		     " srl     %[cc],28\n"
-		     : [cc] "=d" (cc), "=m" (p)
-		     : "d" (p), "m" (p)
-		     : "cc");
+		     : [cc] "=d" (cc)
+		     : [com_blk] "d" (com_blk)
+		     : "cc", "memory");
 
 	return cc;
 }
-- 
2.43.0


