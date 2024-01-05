Return-Path: <kvm+bounces-5758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C134825CA9
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 23:55:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D10081F23FC7
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 22:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49F3364BB;
	Fri,  5 Jan 2024 22:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sriP1hdq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4244360BD;
	Fri,  5 Jan 2024 22:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 405LIaPP000410;
	Fri, 5 Jan 2024 22:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AYmBUZ5W7HWVQufIZA+lKi/k6VI7OYdFz+Fr1gZ8C0k=;
 b=sriP1hdqUDS1fKa2cacoMpQyhfHazin/cULq4oEDFRnIHIMOxAfAnfAirdzOp7sPOYt3
 WAkHj1aSvDI7FXWi3s1HZwKsXq76QHzUjvfdtRFm2XAmB2UZS5kfo470nRjytUvG/bEd
 Bsyn31zxfERkzj0LPcV8kTMuw2AAbQ66mG9rXJUPllSs+EEQixMi0bQxZbfOlxj3MY6x
 cclSZnFv9xfXwgMKJLiJJrvP6/spSW0EwnylqLtJBqum3qOd056aejyLpnxF5m4z5rn6
 ofR+nS/XpfzoE6j4v8CVu5r1fTB1dahIJuFa/oWCgAK2ngz1M8PxwSwLRjLkJDD/wprJ +g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vesjmsswr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:27 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 405MjCdM030736;
	Fri, 5 Jan 2024 22:54:27 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vesjmsswf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:26 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 405KZFRP024495;
	Fri, 5 Jan 2024 22:54:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vb082suma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:26 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 405MsNrB39649694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Jan 2024 22:54:23 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E0FD20043;
	Fri,  5 Jan 2024 22:54:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D90CC20040;
	Fri,  5 Jan 2024 22:54:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  5 Jan 2024 22:54:22 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v2 2/5] s390x: lib: Remove double include
Date: Fri,  5 Jan 2024 23:54:16 +0100
Message-Id: <20240105225419.2841310-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240105225419.2841310-1-nsg@linux.ibm.com>
References: <20240105225419.2841310-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9Typ6gGW9h60vPSB7q26nmVSSTj8aKMV
X-Proofpoint-GUID: ccoYn-9pO_kQmP1-uski0sNfBnMDyysG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-05_08,2024-01-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 mlxlogscore=841 suspectscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401050176

libcflat.h was included twice.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 lib/s390x/sie.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 28fbf146..40936bd2 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -14,7 +14,6 @@
 #include <sie.h>
 #include <asm/page.h>
 #include <asm/interrupt.h>
-#include <libcflat.h>
 #include <alloc_page.h>
 #include <vmalloc.h>
 #include <sclp.h>
-- 
2.43.0


