Return-Path: <kvm+bounces-1461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C187E7CA9
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:54:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D2671C20A08
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EEB31B29A;
	Fri, 10 Nov 2023 13:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YA5wzECk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49A91A5BC
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:21 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6A13821A
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:21 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADaGG8001172;
	Fri, 10 Nov 2023 13:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=d75oRC1GW/6duzzGQJmxCn0I9FlvrezJL+Njah9YuX4=;
 b=YA5wzECkdCJ2bvrctWb6a1PACRbwYjv4GIaCvKKKkW0QgBhy2o94WuAaWG8EtLLWfpu3
 nRCoK21Nax2dtxKTWc8qys5o0mZktsAVK5NSC0GjmH+ehnnHAfKwMXp5gCIdHjewdkD+
 2qByu5/81Kn0TfN9HpSgDFHYi0cMl/kXiWmWoDG0BzHgz8MHxZqrNxWFZRJEWX9a2agZ
 Y2BQD77vrBjkchE1x+NNjQ3fG9jJRu2imBbZdagaGOFw3mvLoUl818ySuUaCZGQtzIOt
 s8L6g8HxyZF/Q5lvUF3YjCTD5IPBbFt/1uZdcXeH4HY+ocbSsEr+2mXLmBRPZKV+EGik CA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mrn9ra3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:09 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADoRxC017047;
	Fri, 10 Nov 2023 13:54:09 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mrn9r9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:08 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADq3tU000652;
	Fri, 10 Nov 2023 13:54:07 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w23b7c8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:07 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADs4au55574838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F2B02004B;
	Fri, 10 Nov 2023 13:54:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9CC820043;
	Fri, 10 Nov 2023 13:54:02 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:02 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 01/26] s390x: spec_ex: load full register
Date: Fri, 10 Nov 2023 14:52:10 +0100
Message-ID: <20231110135348.245156-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZgXbSfu79sj029jHxBzT6NuLTWD4cq2C
X-Proofpoint-GUID: 4zHxeZFnLCEUT7ZQLa4xEOiS82dSQtee
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311100114

There may be contents left in the upper 32 bits of executed_addr; hence
we should use a 64-bit load to make sure they are overwritten.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20230811112949.888903-1-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/spec_ex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index e3dd85d..72b9425 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -142,7 +142,7 @@ static int psw_odd_address(void)
 		"	larl	%%r1,0f\n"
 		"	stg	%%r1,%[fixup_addr]\n"
 		"	lpswe	%[odd_psw]\n"
-		"0:	lr	%[executed_addr],%%r0\n"
+		"0:	lgr	%[executed_addr],%%r0\n"
 	: [fixup_addr] "=&T" (fixup_psw.addr),
 	  [executed_addr] "=d" (executed_addr)
 	: [odd_psw] "Q" (odd)
-- 
2.41.0


