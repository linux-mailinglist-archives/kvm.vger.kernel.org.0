Return-Path: <kvm+bounces-53973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC98B1B27B
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C421F6209E5
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 11:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DE76246BCD;
	Tue,  5 Aug 2025 11:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YgQAGSbL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13415244671;
	Tue,  5 Aug 2025 11:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754392495; cv=none; b=Pc4BKDCvtdjPguWHsCikhFRaXJvID2KzThM24hJXkSfdrMQTWP+U5wWPhHhnxyWEn8fUgRyA0aT/HIlGj1JKuksE6ohMcZsjUSs+nrPe33bbDHXSbCIuODf9hAFWJf0cKr3ydRcHuW64zX+4Ipu5uXwI9AX+1sZPh35RQPqbHz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754392495; c=relaxed/simple;
	bh=2ulKMrJshbnmTEThItjii4dtLzTtkSzMe0zlXdGENVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3oe1+ZWv2K82UumEmSxK3o5ELtZE1Tiw/UmBoCbwnPY0oYGgdfbARpBI9Rfhk7Exriz98tZQJtPDMP+mWu11ZwBpx84iN9Sm6C1liuo6bweeBRMgWbkcmMzXTMHXIAKQunod6rY02tLdlh5LWHv95znbkRFA+f+QD5JT9tOiLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YgQAGSbL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575AtDZX030927;
	Tue, 5 Aug 2025 11:14:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=XX9iNCw9kBZ9JkUcN
	DiWoSITc1oo12UsF6nQvuFraAo=; b=YgQAGSbL+6uYCrbRPpP0CslKqRgSHmw94
	qMEjb+HiE4hi8BgkJFRnU6WRs40CFl900mWGGQPjzxFa0WxbIZWtNCClahii+gqz
	S26z7mDIb1pl5dFcoKWNmLDsArTvYbaO8Y3D1zOjjaJiHvSnF2IBejn5V1p1yVSh
	Tb78hFAPp7V+jh0h4hlJmhJB+eOiYd69Jk7zvwlEBqs4uo3JnneH4lIJWSNWVF8z
	QnExP5YILTyV5oConAAIrnLQBs273/jUyNYvd+805ulBV4bNNx0mCxRp8aTNd76Y
	uXn/DqjjLvk2ncUoRFFggopmJeo27tlBNIQTX0x022U8f/FL85r7w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48b6keag8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:14:51 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5759ZYAP004594;
	Tue, 5 Aug 2025 11:14:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 489yq2hurk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:14:50 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575BEkiO53281052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 11:14:46 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD9C82004D;
	Tue,  5 Aug 2025 11:14:46 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 881B32004B;
	Tue,  5 Aug 2025 11:14:46 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 11:14:46 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        mhartmay@linux.ibm.com, borntraeger@de.ibm.com
Subject: [PATCH v1 1/2] KVM: s390: Fix incorrect usage of mmu_notifier_register()
Date: Tue,  5 Aug 2025 13:14:45 +0200
Message-ID: <20250805111446.40937-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805111446.40937-1-imbrenda@linux.ibm.com>
References: <20250805111446.40937-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4AVOZmLQv4owTrzdngGVpU8uSXcxrrvI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA3OSBTYWx0ZWRfX0DCkmkvYDbhn
 2yqnb4GSnrFOuIEJSVc8PuCCcFJKiLDlrL+iv9tECKNilK6GVes2rEfW7NxBLYY2fwFhulOssWt
 3IdWglgnCc0ViSqo89aAaRSIiEsT9Bpwf86T500jCKcVE9gysQsYBrNK8HshMaHmrT6zWz/DBBK
 FsRlnnpQrJjiIjihVPSQ+fzOjfFse0qaSu0Rt+C3I9DX/i2wHYMdURY6LaRPJt99J5ragl4CmKQ
 hJbdsLfkiXEvqWV+tpRkTtcdmskI6T8W2ccpLe6oG6knxJpeCAB/FfkY4RMErGpl00JdB2lWW76
 91gkSV8DewsGwqV64uSPPIMBNo9TGle8BQ7e2qOLGtyHQIyL7VyctlFxO9YeVYHj5skzKFUpR8q
 xTNWjzYQiq/b8z3riJPmnqYsDWZiSbVdzWg9LDwYwq1+McxQDlcjrigMpN2Q4+eMos2CV0vH
X-Authority-Analysis: v=2.4 cv=eLATjGp1 c=1 sm=1 tr=0 ts=6891e7ab cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=NBUbcLxLv0y36TE2GLIA:9
X-Proofpoint-GUID: 4AVOZmLQv4owTrzdngGVpU8uSXcxrrvI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 adultscore=0 clxscore=1011 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508050079

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
---
 arch/s390/kvm/pv.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 14c330ec8ceb..e85fb3247b0e 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -622,6 +622,15 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	int cc, ret;
 	u16 dummy;
 
+	/* Add the notifier only once. No races because we hold kvm->lock */
+	if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
+		ret = mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
+		if (ret)
+			return ret;
+		/* The notifier will be unregistered when the VM is destroyed */
+		kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
+	}
+
 	ret = kvm_s390_pv_alloc_vm(kvm);
 	if (ret)
 		return ret;
@@ -657,11 +666,6 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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
2.50.1


