Return-Path: <kvm+bounces-15796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 239348B07EA
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 556DD1C21AA4
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36C1C15B159;
	Wed, 24 Apr 2024 11:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dMb84oFC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221DB15B120
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956399; cv=none; b=BFw9ICdmVSClGValX+FNHKCwV/3YfE4AvWW4w6+xO0qnTDERygA2dTGZuPc02vSLLKJjX9oqydPT5klSA5JEIrT4PDaoign7dMG/8hG1nPh0PlhQNlR4FUR/u/QqKbsCQduXZGYQ43zc407QSipczyLJ/RPZbVFPrCQKO1zHD60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956399; c=relaxed/simple;
	bh=R7qBm11C/SwM/j2AS6smYZ57mEemXCA02PMH88ZRrEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnoK3GEFrXAmbWhaFX6xuSG0PLQx84L6CBXjM1hON/B1LRMyOgzDDfRUvwOb+6oSrSksjLQq+b/TRVtGXG6ZIsESO1K2aClNXBQPtsBUvr3CLxg7t6OtUyRzpOFXHtxecJGU+nHwLvirCPuRpnawryQLjYfZWNrMKNJwTkvcPhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dMb84oFC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAh1PR008709;
	Wed, 24 Apr 2024 10:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=C4qxAaEfbFgEKYr19MzNR67kVgY/GBO8EZ9KvJmZobg=;
 b=dMb84oFCVuBPyuZL4wuePifVZ/lZbz95TOtNkO9BPOSjach3y8B2erc0idKHynEB+ups
 yBwY2VEbYIdZ1E9sMjQ7sfMVe+bsbm7ClEPw/J8dILamv/GFoaJcSLQeumLalrb7MZi4
 I7VqfXwXVz7L1C6eoneqWSAsGJPRRmUx3gtN2WBnmPJtRuf1rQjWikil6OpFXoVdOVk8
 SxAjkxTM/kiHm/0wDQ1Ro0GJGvmydanja0j6uEOSEcaO21zhzDAplACz+39XdOivsIHe
 c23LdrZRbzzogTsIE8ssFSGvW0hy5aPPIVSGIFHdiZrdquLyCbcd3Wq2QFDecwfpNN6a Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0jb80wt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:49 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxnDA002203;
	Wed, 24 Apr 2024 10:59:49 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0jb80wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:49 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O7Xsrm021021;
	Wed, 24 Apr 2024 10:59:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmre03afr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxe0Z51118412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:42 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D06552004D;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A960D20071;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [kvm-unit-tests GIT PULL 11/13] s390x: Use local accel variable in arch_cmd_s390x
Date: Wed, 24 Apr 2024 12:59:30 +0200
Message-ID: <20240424105935.184138-12-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s1DLynq8diOSSAT1VS7okYqYv_wfQpbP
X-Proofpoint-GUID: q74tRNwjzEvsEs5CZ6wqstooWeuacahm
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_08,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 malwarescore=0 impostorscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404240045

From: Nicholas Piggin <npiggin@gmail.com>

By the time we end up in arch_cmd_s390x() the global ACCEL variable
has already been processed and is passed to arch_cmd_s390x() as an
argument. We should use the local argument to achieve the correct
behavior and not rely on global variables.

Fix this by changing ACCEL to lower case.

Reported-by: shellcheck SC2153
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Link: https://lore.kernel.org/r/20240406122456.405139-2-npiggin@gmail.com
Message-ID: <20240406122456.405139-2-npiggin@gmail.com>
[frankja@linux.ibm.com: Improved commit message]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 scripts/s390x/func.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
index 6c75e89a..fa47d019 100644
--- a/scripts/s390x/func.bash
+++ b/scripts/s390x/func.bash
@@ -21,7 +21,7 @@ function arch_cmd_s390x()
 	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 
 	# run PV test case
-	if [ "$ACCEL" = 'tcg' ] || grep -q "migration" <<< "$groups"; then
+	if [ "$accel" = 'tcg' ] || grep -q "migration" <<< "$groups"; then
 		return
 	fi
 	kernel=${kernel%.elf}.pv.bin
-- 
2.44.0


