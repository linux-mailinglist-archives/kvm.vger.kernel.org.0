Return-Path: <kvm+bounces-57103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 425C7B4ACFE
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 13:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 013257B81F3
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D417326D64;
	Tue,  9 Sep 2025 11:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="owFp28YY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07C51DA61B;
	Tue,  9 Sep 2025 11:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757418916; cv=none; b=A4EIpzwlI1CPrtkeEf7NgXu3X/L0rsUaRFn7GWcylM99o76mvdmQsZ11PnlpbZ8+HcZfRJKWiZ7O+yOS/MKvSGFTnTivCxpd8CatS81hOQDIljpyEmri3LoD3NTPXg8zlwyUOqbXa9+uEEFiiCqKvfVSLrT/+Ime5rlShhcgrwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757418916; c=relaxed/simple;
	bh=9ghiyUlmNcA1qeWGRHkfVYWJhKaIrnGpa5khcZIWnNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=di0gItVQBnDL4qVytZ7DUdc/da2oCOb6DdGhGEkwoUey4Fm+CHqMQhjNKW6uTsLDiDeGHXQA818piYW97WESNuKw7wyuvQaR2XYnXrUF4i8Wn+KZWT9xQx0qhcxpe2tTgT+tlVi2Tg8QVXk0GRIxg52/jFsjcGuXLtDoZck5+iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=owFp28YY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5896vgFm023715;
	Tue, 9 Sep 2025 11:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/B6u7LLuz1WlHKNNu
	obRyc5yTQwPM9SQ6/O4Ff0ui48=; b=owFp28YYtVFRM4wxfoKYMJn3P+KuG/DPp
	1kfJ7f07GRd6yK3qZkEJ5P9mKPDmb83xDQhcWY1vVfZcZdShiV2R0MqRLAuWuQMt
	732d+NKqREe2ZgyREmexGyC0mszqXThKaPBshkOVh0VEIgHg+sGUIHT0Qx94iwTj
	fgkg6ODx8fWuduo5WI6gjxNfFu5yKv1MBp4M938YOr6u1SdC+y/hc1Is807DasAV
	zk8lS33xgid8DKOMmXqbW/Fy16NMJPHS5ntHfwYQHA/JCHTHb2y6Zas8t11FDW+w
	Rutjpyh8kdNSofAZZrMfbYFtzevuC7XU3wdiFSNLmwL8lLPEaeCCg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acqydh6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:55:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58996axI020465;
	Tue, 9 Sep 2025 11:55:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 490yp0u37j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:55:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589Bt5f79306496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 11:55:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0193A20043;
	Tue,  9 Sep 2025 11:55:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F33820040;
	Tue,  9 Sep 2025 11:55:04 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.111.71.18])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 11:55:04 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 2/3] KVM: s390: Fix incorrect usage of mmu_notifier_register()
Date: Tue,  9 Sep 2025 13:46:14 +0200
Message-ID: <20250909115446.90338-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909115446.90338-1-frankja@linux.ibm.com>
References: <20250909115446.90338-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D0rPsSSBFdkQ8jvHNKYnH02DhiqmMzCq
X-Authority-Analysis: v=2.4 cv=Mp1S63ae c=1 sm=1 tr=0 ts=68c0159d cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=GJtTgPQnudJMRmo940AA:9
X-Proofpoint-ORIG-GUID: D0rPsSSBFdkQ8jvHNKYnH02DhiqmMzCq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAwMCBTYWx0ZWRfXxyWgqvfgmPDp
 hDcfB2tgfYsRVpZDWe37NFcDCVSR0Pr0JlYCPDVA0HkHwbXBo5HWOGb93HYZUxYDhUNUBaPDC+D
 AGZz0BI591WuHQQFar6IF2tnXfOp3IbATddQUplPl0ycl6kYKN8BFJ5x7AbIeTo5MqvD2hIIv7e
 yyVDl7T8WmNW3c+odLAx60by4jTitoDXJx4Oge9+tKBm5d8x64+bmR9YcNB5X4wHZbXAvGQoFi3
 cLpJsi2mZTbAwscdPvGIDVsAU7NeQGLFAJqj4X1PUgk5ZEyFEcQyBhvPrHk+bHR1NmtEzJmo4aX
 vSQB+hXaGCPVQxJj1jlIsUM0CC5POUgiEOh15C0EupjtKmsm5oHQsC0LjSbaY2RWfE+e2jhkgIx
 5ztwwhQw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_01,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060000

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

If mmu_notifier_register() fails, for example because a signal was
pending, the mmu_notifier will not be registered. But when the VM gets
destroyed, it will get unregistered anyway and that will cause one
extra mmdrop(), which will eventually cause the mm of the process to
be freed too early, and cause a use-after free.

This bug happens rarely, and only when secure guests are involved.

The solution is to check the return value of mmu_notifier_register()
and return it to the caller (ultimately it will be propagated all the
way to userspace). In case of -EINTR, userspace will try again.

Fixes: ca2fd0609b5d ("KVM: s390: pv: add mmu_notifier")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 25ede8354514..6ba5a0305e25 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -624,6 +624,17 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	int cc, ret;
 	u16 dummy;
 
+	/* Add the notifier only once. No races because we hold kvm->lock */
+	if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
+		/* The notifier will be unregistered when the VM is destroyed */
+		kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
+		ret = mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
+		if (ret) {
+			kvm->arch.pv.mmu_notifier.ops = NULL;
+			return ret;
+		}
+	}
+
 	ret = kvm_s390_pv_alloc_vm(kvm);
 	if (ret)
 		return ret;
@@ -659,11 +670,6 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return -EIO;
 	}
 	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
-	/* Add the notifier only once. No races because we hold kvm->lock */
-	if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
-		kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
-		mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
-	}
 	return 0;
 }
 
-- 
2.51.0


