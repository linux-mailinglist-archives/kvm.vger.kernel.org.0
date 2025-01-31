Return-Path: <kvm+bounces-36983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB17A23D0B
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:29:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7625916B256
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A961F2C47;
	Fri, 31 Jan 2025 11:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Df5c1BB5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0141F0E24;
	Fri, 31 Jan 2025 11:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322732; cv=none; b=AQn8A8IwUelC5AXmBcQaW1ibysJvixlLbVpeoVOzMG2yXHvUvd4LXU9Khqx/SLrqb1c5NfZ1CieWmbnsEK4bgxWHnSqqa0MdUzY28HBj8uWByP+SVChb0dPeJ1QFoIZ7b/Yn4omfIOuEtf74BQA/5umVyLLuQK6lskinRgHTQ5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322732; c=relaxed/simple;
	bh=hW8QUGSJeZi4NErsIV3FnLcZc0wm+zIpbi0XOPHbwuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTymtia+le5xoEW5iTpFUVl0Ar8b1U4Qb5fVg9a3wUq4BhHfLNfp9YUswnnkUuUl+Tojj30+5d+13MeVKhrNdky+CVRNytRKWtD6yKkoVbzksmouKeL1GWekSFIgK9HeD4LG236kGPOdKarAS1qZCngBDknkVEQ9pCileGqFBcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Df5c1BB5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2OPIC030494;
	Fri, 31 Jan 2025 11:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SRG2Lsjbt5losy1EF
	Q08+azcIQgwFnZAQYhP9wLiCek=; b=Df5c1BB5jYwB8ZK3F8Ei5YX3Tt2vfcYpI
	E2izCDlYe6zYVNq0rkyikPL9hqCsDVoJdE2D7fF080NbVjtNMJUhRnCVO4yoGif6
	C6VZOHHTmRMn0QonH9RL1E+KD77T6MbVy8pCXa0SByYMRWuoZMAgyE2VVDHxpl8N
	gHYi4CZe9/WlEJKvn0L/vFnFdBEyabXUx5kkYAocQ+Zzdu1UmOgwXQ2hZ+oaGWQL
	Pwtc+hWySulos8FvqbL24uii6PUvsX69M7IJpdgMR+kZ4e1JQJxANZmYWPw1N9rP
	JQFqjMe16YzEjghNxnefwiSHC/EPkO3MQWuyUzYwowatXPdkCuoBA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gfn5b8sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:28 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8Bm4I010257;
	Fri, 31 Jan 2025 11:25:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44gfa0k94n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:27 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPN2F20316568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9252A20133;
	Fri, 31 Jan 2025 11:25:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 458162012F;
	Fri, 31 Jan 2025 11:25:23 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:23 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 08/20] KVM: s390: selftests: fix ucontrol memory region test
Date: Fri, 31 Jan 2025 12:24:58 +0100
Message-ID: <20250131112510.48531-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131112510.48531-1-imbrenda@linux.ibm.com>
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wMTnncO1RKPm7Nfujdidm0S7zT3KNLyi
X-Proofpoint-GUID: wMTnncO1RKPm7Nfujdidm0S7zT3KNLyi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=680 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2501310083

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


