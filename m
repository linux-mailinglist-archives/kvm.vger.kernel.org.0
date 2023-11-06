Return-Path: <kvm+bounces-746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7C87E2277
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 13:54:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E459EB21078
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B69025104;
	Mon,  6 Nov 2023 12:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SvewJeNt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9828B1F95A
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 12:54:10 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C32610B;
	Mon,  6 Nov 2023 04:54:08 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6CS1kx027832;
	Mon, 6 Nov 2023 12:54:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=25sG0viOZuc5jZJGiaiZzU1sDIqDuV6ojB3aWmN7du4=;
 b=SvewJeNt7DCMX2aa1F6bcAPHPlZ9ljokeL59dbKWRQ9JkrewiEktCof8l7YrEDWrHU1e
 7MagnRSDsjXP9/zw+BkFotl9kSHaY5Ahoo4AjA1LnzHsroV+RDS/sJGLH/Yh6ZPiBEQP
 ljSWZtDBSpK8HErYpQOneKy66Gpmx5fmxfbl+S9yCOSa3aawUfU4Ep8cc/iQfHtbRHBU
 ad+4/7QqjIi5c1mXpFRV5p4lVctuYpWClNbuz9Yg/0LeRT6bcILoLJl+8L19Bsrsy2su
 m9U0rgg7lA8Ao0aSCfzEsOBQnw7Xq6gVRwARc69eHSiem3JfMie6vyyWL+cRm72j2vph Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u705rgm4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:59 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6ComF9004647;
	Mon, 6 Nov 2023 12:53:59 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u705rgm48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:59 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6B9XHI025605;
	Mon, 6 Nov 2023 12:53:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u619n99fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:57 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6CrsQb7013034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 12:53:54 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9386A20040;
	Mon,  6 Nov 2023 12:53:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5CA8220049;
	Mon,  6 Nov 2023 12:53:54 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 12:53:54 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev,
        lvivier@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 07/10] s390x: cpumodel: list tcg_fail explicitly
Date: Mon,  6 Nov 2023 13:51:03 +0100
Message-ID: <20231106125352.859992-8-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106125352.859992-1-nrb@linux.ibm.com>
References: <20231106125352.859992-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JJXnMzB2ZJHtBi8qZCZacuPCaBczQMS1
X-Proofpoint-ORIG-GUID: Ym8uLHuY_S6Cw0I_IUDhgNy0-3thMqco
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_11,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060104

This makes the list more readable.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/cpumodel.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 5c0b73e0f9fe..5734312b102d 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -84,28 +84,28 @@ static struct {
 	bool expected_tcg_fail;
 } dep[] = {
 	/* from SA22-7832-11 4-98 facility indications */
-	{   4,   3 },
-	{   5,   3 },
-	{   5,   4 },
-	{  19,  18 },
+	{   4,   3, false },
+	{   5,   3, false },
+	{   5,   4, false },
+	{  19,  18, false },
 	{  37,  42, true },  /* TCG does not have DFP and won't get it soon */
-	{  43,  42 },
-	{  73,  49 },
-	{ 134, 129 },
-	{ 135, 129 },
-	{ 139,  25 },
-	{ 139,  28 },
-	{ 146,  76 },
+	{  43,  42, false },
+	{  73,  49, false },
+	{ 134, 129, false },
+	{ 135, 129, false },
+	{ 139,  25, false },
+	{ 139,  28, false },
+	{ 146,  76, false },
 	/* indirectly documented in description */
-	{  78,   8 },  /* EDAT */
+	{  78,   8, false },  /* EDAT */
 	/* new dependencies from gen15 */
-	{  61,  45 },
-	{ 148, 129 },
-	{ 148, 135 },
-	{ 152, 129 },
-	{ 152, 134 },
-	{ 155,  76 },
-	{ 155,  77 },
+	{  61,  45, false },
+	{ 148, 129, false },
+	{ 148, 135, false },
+	{ 152, 129, false },
+	{ 152, 134, false },
+	{ 155,  76, false },
+	{ 155,  77, false },
 };
 
 int main(void)
-- 
2.41.0


