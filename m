Return-Path: <kvm+bounces-31641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C88239C5D38
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:28:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DF782834F5
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D671F206976;
	Tue, 12 Nov 2024 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gp04v2no"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CA3206E6C;
	Tue, 12 Nov 2024 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428784; cv=none; b=t5t4c4OUTCgZx93eTNAGVWM4SktO7iLfczbMYjGX1ZzPB1zqEou4wkCIBW9NL101nWSSFT/Pomna3nFYj8VBBNlh8+5NYV72sFHm0dSupUX+24nxD3jixWO1nM88fFvf102s2/mLLxXfQgSYXghMRN2k3QEy4If5AGWd0Wl6g9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428784; c=relaxed/simple;
	bh=fduP8tMWdHIxCLiKHs4XvUzmNSDvyzjH0o/NXOvdhhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD2HOJ1ndfO9OGX6MfiKAzy4TpUgfyk+HUpyBWmAGmvh8S6ndTtA4IDQj7laBXNIBJymdDUWfwRsOW08Op7S05bjB1gYOTGhbiUytAej6uNPPKHSmNQuausJ/yX12j3+/0BObdJc8uvb4mtwObf1IPIeu5V6lmx5V7At1+4Wiyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gp04v2no; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACEfPGE009401;
	Tue, 12 Nov 2024 16:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=sS9x9qEznK+EpBkVD
	pCkBm6Q0qTZgQu2T/GFe7Ak7xc=; b=gp04v2noyixZK6/gL01fBVsjT9oWUsh1q
	nPs54CNPgqD42LxNvVb2w5H8V3LW7TI5YxI4ymuQd9TvVLDNKziwfzSEb3SyerUw
	ReViDhE/SFgAfCD7yBfmucbQYcWiGE6EGZddtll3sI0dyshxEzLiCCwMJHpmEt+1
	evUcmE+SXmbSw65wDBzyLpFr9zVEO83X9AzTW6zwpQVBJ8JXEKWtyao+pXdi3OZ1
	flF/BEEHBySARCyzvD/gjn0ha1d8FQsRgNmsdtPLy4ohmDSFqV0bjzFRnCIIcADf
	XZ69c2IE069N66/XmeR9na0kK8aH1QguYfi5eia9g/uHm6tSF2LSA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v8yv8ghr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFhABb029753;
	Tue, 12 Nov 2024 16:26:17 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tkjktqxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:16 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQD6n56754542
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:13 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36EEE20040;
	Tue, 12 Nov 2024 16:26:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4A0020049;
	Tue, 12 Nov 2024 16:26:12 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:12 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: [GIT PULL 13/14] KVM: s390: add gen17 facilities to CPU model
Date: Tue, 12 Nov 2024 17:23:27 +0100
Message-ID: <20241112162536.144980-14-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vsHm9uOk2NghKV38WPCynn7GYy8fijg1
X-Proofpoint-ORIG-GUID: vsHm9uOk2NghKV38WPCynn7GYy8fijg1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=775 spamscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411120128

From: Hendrik Brueckner <brueckner@linux.ibm.com>

Add gen17 facilities and let KVM_CAP_S390_VECTOR_REGISTERS handle
the enablement of the vector extension facilities.

Signed-off-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20241107152319.77816-4-brueckner@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20241107152319.77816-4-brueckner@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c         | 8 ++++++++
 arch/s390/tools/gen_facilities.c | 1 +
 2 files changed, 9 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 20b1317ef95d..0676c41ac9b8 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -812,6 +812,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 				set_kvm_facility(kvm->arch.model.fac_mask, 192);
 				set_kvm_facility(kvm->arch.model.fac_list, 192);
 			}
+			if (test_facility(198)) {
+				set_kvm_facility(kvm->arch.model.fac_mask, 198);
+				set_kvm_facility(kvm->arch.model.fac_list, 198);
+			}
+			if (test_facility(199)) {
+				set_kvm_facility(kvm->arch.model.fac_mask, 199);
+				set_kvm_facility(kvm->arch.model.fac_list, 199);
+			}
 			r = 0;
 		} else
 			r = -EINVAL;
diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
index 1d0efd3c3e7c..855f818deb98 100644
--- a/arch/s390/tools/gen_facilities.c
+++ b/arch/s390/tools/gen_facilities.c
@@ -109,6 +109,7 @@ static struct facility_def facility_defs[] = {
 			15, /* AP Facilities Test */
 			156, /* etoken facility */
 			165, /* nnpa facility */
+			170, /* ineffective-nonconstrained-transaction facility */
 			193, /* bear enhancement facility */
 			194, /* rdp enhancement facility */
 			196, /* processor activity instrumentation facility */
-- 
2.47.0


