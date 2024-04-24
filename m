Return-Path: <kvm+bounces-15792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6468B07E6
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:00:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6988B2289E
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D158D15B114;
	Wed, 24 Apr 2024 10:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qlNPJEXU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A3E15991A
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956397; cv=none; b=MFXJiwdOJHXqjC4MW85QVzohnA7M6QOJWYWHyP4ew4ETqWZ7Fbqi+Wknn860XqNrzdTgPskihBHq9AUbMjrXfBxT+mWMaTjbgNi88a+B4BdpMjLkVYcH8VWbVxwWk8JV79UBDUCHOif957T1heMfq/sCP44hLRFbgg5qiSzmfQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956397; c=relaxed/simple;
	bh=JEObXw7LlQNxZNkdRLC+07jQhbjyaKsvK4MekDgKmco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn2SmTZl1CqtxwCHCKjZ5aRVrwq3SNXNbZJgJynlOVY3cHsjgBg+oBQO+yMWAwJFkM28JeKLSGmK6RWVoWjjUjZjAeLEXnW+SsTqEYszKG1db4YHRg2O9PlmR9h2lyvugWXK4x/WbGiJ1legNKpOZzimM/64stBvJpDBvklkpeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qlNPJEXU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAvgov029766;
	Wed, 24 Apr 2024 10:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tZy76LyIi/efz/j6OfXzjjkPYzS7V3dBrjZmCT9R7Ik=;
 b=qlNPJEXUQwT8+KMEg+lUhy0MJMu10hZaQIS/Uv2WHmhbBfv1acBq25HuYgFDgvn5Krg4
 DsdEZTZNU3dp/iIGIKH+Dns1AIRA1/6REBSApzBR3H6KPVVCwpCqVfLlR30UTS4HIHAs
 4zH5pov1oAAByGuWOQTJ0A2AOGA/UfrY9/lSh3jYAYuXR+KfAkRHnkXhddke3CmfKe+z
 VTIDosThKah3lqVZ8DiXbwQarue922Y51pq0eEHYTQ0fHuiAsWOhgh0osIlHSePb6euT
 s/nYANEF49l41QDCNs1uZKbcpChWZdLkdwBqjvQfHoBTGI10HDj0jiN2PdFa6YyqKHEc Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0sb004h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:47 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxkXL000469;
	Wed, 24 Apr 2024 10:59:46 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0sb004c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAlMfm029929;
	Wed, 24 Apr 2024 10:59:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmr1tkeg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxekY51380600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:42 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F3822006A;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E0082006C;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 09/13] s390x: emulator: Fix error path of invalid function code
Date: Wed, 24 Apr 2024 12:59:28 +0200
Message-ID: <20240424105935.184138-10-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VTTlHycDWiZnJ49X_ZDs5Rs-wwskEUu2
X-Proofpoint-ORIG-GUID: dOB1q5EA-MKMt4TQoSGsJKLIWPSVl-Pc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_08,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxlogscore=910 mlxscore=0 spamscore=0 suspectscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404240045

From: Christian Borntraeger <borntraeger@linux.ibm.com>

When 127 is not an invalid function code we should not wait for the
program check. Move this check into the else branch.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/emulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/emulator.c b/s390x/emulator.c
index 2c42f96f..5a5a3edb 100644
--- a/s390x/emulator.c
+++ b/s390x/emulator.c
@@ -130,8 +130,8 @@ static __always_inline void __test_cpacf_invalid_func(unsigned int opcode)
 		report_skip("127 not invalid");
 	} else {
 		__test_cpacf(opcode, 127, 2, 4, 6);
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 	}
-	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 	report_prefix_pop();
 }
 
-- 
2.44.0


