Return-Path: <kvm+bounces-36905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 757A0A22ACF
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:52:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB00C3A7630
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 09:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FEC11C173F;
	Thu, 30 Jan 2025 09:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XLhXs+mk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4AA1B87C9;
	Thu, 30 Jan 2025 09:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230691; cv=none; b=sBh6jhE1B1KJKL8i3NFRR9z6USB9z66gvdL95K/yQMN7GE47jhC3N0DBjeOAlWYtn2wVpkeXozmVxgoxrjD4jDNYio2hG1+cyta0OT+vVfaIt/MjUlxaVFbPCA93vkH/IkoRzTfdAPAMq/7WHl7PRyvi8mV+/MoBhxlGbm5GIY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230691; c=relaxed/simple;
	bh=hW8QUGSJeZi4NErsIV3FnLcZc0wm+zIpbi0XOPHbwuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWcdXDBszzZyFIImqwBs5ToTJrDv0UBbNvUf8L7yxUvwl0+eCvaGSiekbnm9clrFFrbZ1Oxn693+1sHAZYyURvPKxszuRrAm5iyweZvVhR3oAg1+DqP6uAn8jeOxpRnsyo5b7muygOXztMxU4W52sKzXHZUGwnIDXtO6uf8vbtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XLhXs+mk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50U5NpqJ012398;
	Thu, 30 Jan 2025 09:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SRG2Lsjbt5losy1EF
	Q08+azcIQgwFnZAQYhP9wLiCek=; b=XLhXs+mkbPHyA8zVSk79640Wp/CKssUfA
	uCrJyjEZOCcwBqaillp4Ro/CM1iSF+cp/rRY6RHMkaidXGmQAikoxymbTfcDYfmA
	RQNA18K8SMKlIaAJUL8QVzDDJEGwCgLLla7NJL4J68zlIY542u0a6oHX2J0qW6ya
	33jPmK5JUeY2H31hEMuipnYzTB6wqDJV95s+07MVPHgz4o1n7oDBiZSEdjqxlhWv
	98+4LF7ObXqwreM1RDoOkqoHRkj8IiCdxnYF1nxNnn2Ox0Fyu0zLpXqAcz3r4RPy
	XGawQfcDzpd07qP4feYlRyqdX8zWWu/6JHMKe78HxCyCBj1LyRNmA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44g38814e3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50U5e7tM018886;
	Thu, 30 Jan 2025 09:51:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44dd01n51h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50U9pKLr34865788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:51:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDC3C2013E;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB0F020142;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 08/20] KVM: s390: selftests: fix ucontrol memory region test
Date: Thu, 30 Jan 2025 10:51:01 +0100
Message-ID: <20250130095113.166876-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130095113.166876-1-imbrenda@linux.ibm.com>
References: <20250130095113.166876-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VfFSkax9vcEgmjemofQLSHb36PPm04h5
X-Proofpoint-GUID: VfFSkax9vcEgmjemofQLSHb36PPm04h5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=680 phishscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501300073

With the latest patch, attempting to create a memslot from userspace
will result in an EEXIST error for UCONTROL VMs, instead of EINVAL,
since the new memslot will collide with the internal memslot. There is
no simple way to bring back the previous behaviour.

This is not a problem, but the test needs to be fixed accordingly.

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20250123144627.312456-5-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-5-imbrenda@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390/ucontrol_test.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390/ucontrol_test.c b/tools/testing/selftests/kvm/s390/ucontrol_test.c
index 135ee22856cf..22ce9219620c 100644
--- a/tools/testing/selftests/kvm/s390/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390/ucontrol_test.c
@@ -459,10 +459,14 @@ TEST_F(uc_kvm, uc_no_user_region)
 	};
 
 	ASSERT_EQ(-1, ioctl(self->vm_fd, KVM_SET_USER_MEMORY_REGION, &region));
-	ASSERT_EQ(EINVAL, errno);
+	ASSERT_TRUE(errno == EEXIST || errno == EINVAL)
+		TH_LOG("errno %s (%i) not expected for ioctl KVM_SET_USER_MEMORY_REGION",
+		       strerror(errno), errno);
 
 	ASSERT_EQ(-1, ioctl(self->vm_fd, KVM_SET_USER_MEMORY_REGION2, &region2));
-	ASSERT_EQ(EINVAL, errno);
+	ASSERT_TRUE(errno == EEXIST || errno == EINVAL)
+		TH_LOG("errno %s (%i) not expected for ioctl KVM_SET_USER_MEMORY_REGION2",
+		       strerror(errno), errno);
 }
 
 TEST_F(uc_kvm, uc_map_unmap)
-- 
2.48.1


