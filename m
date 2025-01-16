Return-Path: <kvm+bounces-35648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7F94A1391E
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCEE83A7A3C
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559601DED4E;
	Thu, 16 Jan 2025 11:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iUpfliuL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEACF1DE3DB;
	Thu, 16 Jan 2025 11:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737027251; cv=none; b=TIA9cP2EB+YI5lArPiPDx0Dp+FMbSwcUglR8gYB1oCGjRvUn189A/TYxldyO3rBMn/sd4/07Rn3cWjDVLX27FD6MfwKg4bQRWKgzIe7poN/N9xSUNHCX6L4Dq+44I5xzJlJfZyeo32469JPhS3hufe1FtHDb8krw3SG1k+4shfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737027251; c=relaxed/simple;
	bh=DYH+wBNwcSAOvNucGHQSlG54R703MOc9SJsJYyeEcg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b767vX2WJgCaQRzz8e9zWELA+N6zYIT4DIAZKaQIH3fSL1j6vV00vHdjJJhJhYK0nWNTLksFVYfKK0JR9T7j8SF6gxAt5ahFq1k9t7169hWIRpsaPDZgpSxgKTY/yNi91NzZAWfyzNUD4QX7QdKH0IDvN6KNNUwkmST0F8zwpmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iUpfliuL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FNahYZ022858;
	Thu, 16 Jan 2025 11:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0cw7mc2sHry4f1WIR
	gGw40Q10ApBdrHkX2uvImAPkew=; b=iUpfliuLKgZuGRK+3ghFLIBzBUBsGFFF/
	UWR6CM0n7Ks8RtD8EDNfhXrMXScwelaIJEKk4LSPnsprWZTAk+uMEY4KpORH/cFG
	b5oVX+BmoLw/owIfP3TxA49u5y26YeJOHfwvWJ3pgY3OJUKkjtvZAbIVVX+z6t5H
	cnhh7MuO7x5X6/O+0airYUnyLHalUR/ffwmhxbwlF+VtSZvRzNadwWbaZVBC0O3E
	jYZZRsCowPREd4GygQ9T/QMrx4QHkhNBbQmH2U7O9v84B2Gukfpb6wsBsqpRo1sI
	Vw+kOj9eJObwZdJ4Z0JPEEfDP4JPHgPweUCjGXiSeuK+tnhCkySGg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446pub2qr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:02 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GBPJYb006839;
	Thu, 16 Jan 2025 11:34:02 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446pub2qr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50G9vsdZ002734;
	Thu, 16 Jan 2025 11:34:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443bydpmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:01 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GBXvFO54788536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:33:57 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A5C7B20040;
	Thu, 16 Jan 2025 11:33:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D5662004B;
	Thu, 16 Jan 2025 11:33:57 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 11:33:57 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v2 05/15] KVM: s390: selftests: fix ucontrol memory region test
Date: Thu, 16 Jan 2025 12:33:45 +0100
Message-ID: <20250116113355.32184-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250116113355.32184-1-imbrenda@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 15nwSvUW7a06nrC2aQ77laxUuB9EhofE
X-Proofpoint-ORIG-GUID: 06Aq160-zC35zD5VZUj70t4BdbpktRXC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=694 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501160086

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
2.47.1


