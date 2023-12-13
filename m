Return-Path: <kvm+bounces-4324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9CB8111A5
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78D5FB208C6
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590472C1BA;
	Wed, 13 Dec 2023 12:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HTB+cimB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902FD106;
	Wed, 13 Dec 2023 04:49:54 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDCluQb011965;
	Wed, 13 Dec 2023 12:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4YbvUWxAmQdfoGDiwSA3Zht0pnxEdFXb9M3y8UeUUZw=;
 b=HTB+cimBZocrWvBhp4QKwVOI7gDFCWPzfHbnjgGUYE8Z5uFGT1LG2rOS2QwwDco6Ee+3
 RSZB4cDkN6tZkUWk6RQLKKmIX62/AqUPRLijU+9fg+EkIp0uAgen8dWbt3sgbbLxbvXX
 Onluzn9FJlL8f5ly8D5X/PPXhiBStzphKO/yytrvKY7hlHDXFCvxl9gkYK7PgbI8JWu+
 fD4YsBW4ivlxtS0DM8GiiO91jjmTrPP4wcXPAvfERs8DYIK6gS/JSYnxXHvDidpXfmbz
 wj5Rob+Wa5z9OvNrI+X0cCYrYrMY8Q3jKfCAxUUMNdUJQJrK+P0J9hTMd2SUcNfWgTHu Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uycxag0w1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:49 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDCnmqA016137;
	Wed, 13 Dec 2023 12:49:48 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uycxag0vt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:48 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BD7MHav014819;
	Wed, 13 Dec 2023 12:49:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uw42keshv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:47 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDCni8A44696020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 12:49:44 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABC1220040;
	Wed, 13 Dec 2023 12:49:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 713E920043;
	Wed, 13 Dec 2023 12:49:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 12:49:44 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/5] s390x: lib: Remove double include
Date: Wed, 13 Dec 2023 13:49:39 +0100
Message-Id: <20231213124942.604109-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231213124942.604109-1-nsg@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M8Y1JNzewUn4Xx7PxjsVzZJ4AHNUAG1K
X-Proofpoint-ORIG-GUID: W6gxDDc6ktizdoyl45OTnITNTPZdJxCC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_05,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxscore=0 clxscore=1015 impostorscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=784 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312130093

libcflat.h was included twice.

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
2.41.0


