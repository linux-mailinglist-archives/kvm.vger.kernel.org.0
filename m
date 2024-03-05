Return-Path: <kvm+bounces-11011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E77987214B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 15:15:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D2D71F2491D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994F886630;
	Tue,  5 Mar 2024 14:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HvY8kQ3/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733DD85C73;
	Tue,  5 Mar 2024 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709648142; cv=none; b=UfD+bK2uYAxVWiXlIRHvovGoT4qd8O+wbVPDoIOIgQUu4658u7wjJgt5lOBNzlyk1g6w7CMlOctqgouxsRXap0zVxn8ymZuz1G1Xmpn30GsF6dHmv7RtlqDdxZDtTLC02Z/Kzd1DV1wyWf3FCIH+mmgu8iVu+rGaULs1etU44Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709648142; c=relaxed/simple;
	bh=NOrYqrOBKmtYhNesKNo9esl759+uodRTcRkHuZf+zRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l68uKuLBLJtbLE5GHCwBAOpvKMcLJKAFQ1u/2AzQiyOsLMh/Mt0iZHMnXYLISfRCysnhrs5RlMRikG+Ub4FcIjkYPpOUOvvk1+ZjrSjSBgT22j3FMQ/3OKnhk1c7dV/YdqqEF3cdcMrB7k/VrGJOKDwlFkVE/kqRG4WFUSw+Qk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HvY8kQ3/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 425EF0A4027026;
	Tue, 5 Mar 2024 14:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=uCGzW2iZ273VwjEQ9vkC8xRDDD3pC4czBjmDdDYh0iM=;
 b=HvY8kQ3/63r0fuGIi901Od2JNbj3d/BbcTQGIbZVj2q/oMxY1FwQK+Xm8npK5dTWxwHc
 iiVvhkt0by+LzgvWAC4i64v3EV20TkSeWBdJURu+S7oYuQ6LDc9WGSizYji8bjlwO4E1
 0R6aL+IjzOb7IGYDzPGIB8VTZ9KWAUnpRV18GWOroBgk5h0bzp4Sjb27TGKYLi6XKvr3
 VTjXf+oWLM81/ASJLgBrt64FpqZnTYhbyAx0k2jzn67uEJY2uXXUy4ilGg9n4TBUJoVZ
 OCr+chWcvy74A2CQAa0Nn5obhI5+uaKoHEWWF0vItrYJQaSI57RPT8avJqACAJ95VMLg lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wp3fwb333-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Mar 2024 14:15:40 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 425EFd7Y028062;
	Tue, 5 Mar 2024 14:15:39 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wp3fwb2wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Mar 2024 14:15:37 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 425DZXtI027187;
	Tue, 5 Mar 2024 14:12:20 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wmfenr008-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Mar 2024 14:12:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 425ECEkl38928736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Mar 2024 14:12:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E3BB2006B;
	Tue,  5 Mar 2024 14:12:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58AD32004E;
	Tue,  5 Mar 2024 14:12:14 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Mar 2024 14:12:14 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        npiggin@gmail.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] arch-run: Wait for incoming socket being removed
Date: Tue,  5 Mar 2024 15:11:51 +0100
Message-ID: <20240305141214.707046-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9uaFL7PHBJW9HG2uLp4zkUY0lR0axDGr
X-Proofpoint-ORIG-GUID: z9j5wqFjEdIOLBq4c8vkkLy0gPXnGZgr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-05_11,2024-03-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 clxscore=1011 bulkscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403050115

Sometimes, QEMU needs a bit longer to remove the incoming migration
socket. This happens in some environments on s390x for the
migration-skey-sequential test.

Instead of directly erroring out, wait for the removal of the socket.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 scripts/arch-run.bash | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 2214d940cf7d..413f3eda8cb8 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -237,12 +237,8 @@ do_migration ()
 	echo > ${dst_infifo}
 	rm ${dst_infifo}
 
-	# Ensure the incoming socket is removed, ready for next destination
-	if [ -S ${dst_incoming} ] ; then
-		echo "ERROR: Incoming migration socket not removed after migration." >& 2
-		qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
-		return 2
-	fi
+	# Wait for the incoming socket being removed, ready for next destination
+	while [ -S ${dst_incoming} ] ; do sleep 0.1 ; done
 
 	wait ${live_pid}
 	ret=$?
-- 
2.44.0


