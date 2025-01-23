Return-Path: <kvm+bounces-36379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AB59A1A607
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:47:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E96933A3EB9
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F66E2139C8;
	Thu, 23 Jan 2025 14:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VN2DLF2F"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BEB213256;
	Thu, 23 Jan 2025 14:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643608; cv=none; b=HOPyJbSe3m3KPq0Cfwa+P7SsXqsDuERUVRPXHMDH5iC79ufpPsepyv1jzgVwdwCUMXSuL0KHvAAF8SJ47cMp6muQf7k/X+Fws3mmTDfUyw6Dsju+0apU4X0hc8jy76wLzw7Qyq5E1uwsBUV5mIVAQaTylIKm6BRDE2Dbm9Dr3aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643608; c=relaxed/simple;
	bh=/GAH9JlJsZdoBO0+aWHAgvg0cXu5EJKOsgG0Ur/7GNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9EwyCtvcRlvgW/f5/RY1z37/6XDiKSmGfEowzyP170nvaqRJ5ANTodWJMYKALJdQhpYivwof4vTideQatm71SiN15mj9FUK6juHdtEZcdHsDUjZNLCL6z+KazKObSukTN7XG9kLWNIhsVqITj+vB6U9WHKHgOsz3LSsOe7gE90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VN2DLF2F; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50NDO18j014054;
	Thu, 23 Jan 2025 14:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9pHuiAK3V11YtAXSs
	cMA/DK2oecbbZ4mH3GmWWG3+60=; b=VN2DLF2F6+pRqrHU7VgT+YICMpO2XVPvS
	Vom2EKs3qpyk57+MVpfVdeUbykYq1Rgqqwd5/E8dhgZWbglALVuVjqjMANNArZgp
	CWC2ifDOt76NOKhg/TQnnY0XnFGpf+nOHaZgP7qKuIy+HG5gXRkRFuv299fiXXh7
	2KtId1xgqE6dtI9UfV3Y7nHF07+fRjm+nEL9a+pSZTFjR74M6aIyQmEOONOfc1OR
	Kb0RuAYi1doQUfVPA1pUlEf5cEfWQSnyBTC5HXIm1ZbgQ+2JuCxaWdefUKQBjt9E
	r3h296G8HkY7nps13mZptfQ/JXPUaevsdd2p6mpKajlFvW34CgSzw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bckyu64q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:34 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NEZpuV014514;
	Thu, 23 Jan 2025 14:46:34 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bckyu64j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:34 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NBkvQQ022392;
	Thu, 23 Jan 2025 14:46:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448r4kduxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NEkT4F22872328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 14:46:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A80FE20040;
	Thu, 23 Jan 2025 14:46:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 72EC320043;
	Thu, 23 Jan 2025 14:46:29 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jan 2025 14:46:29 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH v4 04/15] KVM: s390: selftests: fix ucontrol memory region test
Date: Thu, 23 Jan 2025 15:46:16 +0100
Message-ID: <20250123144627.312456-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250123144627.312456-1-imbrenda@linux.ibm.com>
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FY1JW1q_noxC4ErV2uH4UuNCPqwRNNXd
X-Proofpoint-ORIG-GUID: sDFGpCM_qfkZiNQOx3MstOagH4ymQ3rR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_06,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 mlxlogscore=647 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230108

With the latest patch, attempting to create a memslot from userspace
will result in an EEXIST error for UCONTROL VMs, instead of EINVAL,
since the new memslot will collide with the internal memslot. There is
no simple way to bring back the previous behaviour.

This is not a problem, but the test needs to be fixed accordingly.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/ucontrol_test.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
index 135ee22856cf..22ce9219620c 100644
--- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
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


