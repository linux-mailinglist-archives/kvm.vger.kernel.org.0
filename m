Return-Path: <kvm+bounces-35858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17FF8A157E4
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:10:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73A01188C3D2
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD0C1CDFD5;
	Fri, 17 Jan 2025 19:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YAR3lz9K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0614F1A83E7;
	Fri, 17 Jan 2025 19:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140993; cv=none; b=Vda1sZDgfrDr2T5tMm1+YxHR7styxJQODbgoZQr7eOLn+SMHjmdWUV4N/RjxGLFXJZM1QEUePxQOujwJNgxnE0ANREDvlSFATA9ASvDdVggkWgZ/AVnZh7f30QVt1i2uMcZXgEyxA2GEqymBIQjt+ByRxdYFiqQC0TCgPF0jdeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140993; c=relaxed/simple;
	bh=4dXhE3pFN9s9t+xu8XFZw5Zag5POPhPYDRGtC4h+oJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXNh8glc/qWN6AYKGfHX7yMBMh0wI2YBhfikoEWetT0GMO/2bUebUVEy2L2fXOIJqhwA0OaeVuqXwCvzHSCEpojPvjTJUb9QeGrvjIWo/grIXczD01nCmhjo0XCUHHGq290VAkHXBrODJauymkUlyjoT1eM0PGOd7rm6lo8WkAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YAR3lz9K; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HEAjWG024963;
	Fri, 17 Jan 2025 19:09:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=BQI3f76dGw84QJouA
	ZxGTK12J3hX3xhiSMJLhxvKKAM=; b=YAR3lz9KdgBDPPfPg/hfmL33t00t/2T7r
	U5EIil2BU/VPkM+3xn3aOT2AHcAIqhMwt+wYn1DcvSgAjy4i3uJWiYNCqsrsKL7N
	amovCBpcARGjDvV09hgXsl04oxgtGNP2KoKiTQmNj/SQ6jmqNOGEck1VQ5CPijFu
	IxQFk/LanFAmmYocM5B0inyKBLoOChFA2QzjgKjXxDkE4j2wbS799MNJqEaP5nBK
	q1wfiiONixnCoSFCtSFu0E2U6vMaMyrs70IDTRiXjXQvgv+3Lio4duNvBKnNwnmq
	p0PbB9u4bBbZQJh+kk2JP82VhW1eIdl1X+kMNnvjc5ZecBXBxQaIg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447fpcc1gj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:44 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HJ9iRp019426;
	Fri, 17 Jan 2025 19:09:44 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447fpcc1gd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:44 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HGIJSN016499;
	Fri, 17 Jan 2025 19:09:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4445p2411k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HJ9eJG35520878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:09:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10BD420040;
	Fri, 17 Jan 2025 19:09:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7ACB20043;
	Fri, 17 Jan 2025 19:09:39 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 19:09:39 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v3 04/15] KVM: s390: selftests: fix ucontrol memory region test
Date: Fri, 17 Jan 2025 20:09:27 +0100
Message-ID: <20250117190938.93793-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250117190938.93793-1-imbrenda@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8_Xtf4XXznljSCr6M18KkhI3v5F3kohn
X-Proofpoint-GUID: 0VFOYf4CdNLUihdlAePmq3yHi1UsFIvn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxlogscore=693 spamscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170149

With the latest patch, attempting to create a memslot from userspace
will result in an EEXIST error for UCONTROL VMs, instead of EINVAL,
since the new memslot will collide with the internal memslot. There is
no simple way to bring back the previous behaviour.

This is not a problem, but the test needs to be fixed accordingly.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/ucontrol_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
index 135ee22856cf..ca18736257f8 100644
--- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
@@ -459,10 +459,12 @@ TEST_F(uc_kvm, uc_no_user_region)
 	};
 
 	ASSERT_EQ(-1, ioctl(self->vm_fd, KVM_SET_USER_MEMORY_REGION, &region));
-	ASSERT_EQ(EINVAL, errno);
+	if (errno != EEXIST)
+		ASSERT_EQ(EINVAL, errno);
 
 	ASSERT_EQ(-1, ioctl(self->vm_fd, KVM_SET_USER_MEMORY_REGION2, &region2));
-	ASSERT_EQ(EINVAL, errno);
+	if (errno != EEXIST)
+		ASSERT_EQ(EINVAL, errno);
 }
 
 TEST_F(uc_kvm, uc_map_unmap)
-- 
2.48.1


