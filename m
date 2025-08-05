Return-Path: <kvm+bounces-54014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FCBEB1B637
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEB521886A10
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A81277C80;
	Tue,  5 Aug 2025 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T9AFXMnX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DD4274B3B;
	Tue,  5 Aug 2025 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754403476; cv=none; b=pj7HLXwZ8/5hiX0nawpblTJPBldHo74QB4Og4ETf4XnNP3zSowQrQKBrDK67zdevFEiZmo8KbX/M0cx016eeZJ0Pwr/Tm+VdJOHs+Eydc/LDZ9oau24s2/fA+LjtQDmyMMsDjqVqHWDTM4P4j+ALnOVVKB62Nm6kIClwe7XAsKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754403476; c=relaxed/simple;
	bh=d4XEDZZD8ORnYp7U2M8kfUE0y3mkybUpJZhT0+ONUcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihcffGmCvZY/TTTxoJ8aSRfgFlvcEopLPIR9q/HwQDfS07yYhUvQuooK3hL7+UnHbygA8O0qObOfGcHoGn4R9CpKcFJOFB/OZGjznxKSPahnbyxDkrkHTWtZyUeL3cu3WQa1uCE8mrPsKTLnHF7E4vtUgBOts7BGhk/wxSsg49g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T9AFXMnX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575BaaDH006083;
	Tue, 5 Aug 2025 14:17:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=KbygQjlMzfVtwpfAs
	twQgAkqTAuZ2lWickxiTB/DQ6M=; b=T9AFXMnXefFWoRTL7rvIwBZhMThepf0ZT
	iUcC9uG3fjrSTeupIPJOcbrB4LyC5gHfuwA17rqfPqmnBBnylBi15nojMEN8kHXI
	C00GPWcv73QVa9Zl1GwKw90vu7a+dVvdUuLKxem9/YQPJJMAxQ3yG0KIBZBrD24M
	E3OT8gTCoq9DvNbIzYLKs4NaZhyyQKC1VLoLrSfoWHdbNcj/sY8MTTfadBvU4gNL
	B5xl0HxpshpNn6rx6yLrw+MrhLG2o3Wxqodoc/EzkSU5ljU8D65eSrUDFfd2rGbY
	qY7qUMbK276p5Kpoz8CK51EIvdqiqI1Vw0x6ibi1UDFY6PVgchTww==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48983t7ae4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 14:17:51 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 575A2rqv004558;
	Tue, 5 Aug 2025 14:17:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 489yq2jg40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 14:17:50 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575EHlfi19923420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 14:17:47 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14BE32004E;
	Tue,  5 Aug 2025 14:17:47 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAFD22005A;
	Tue,  5 Aug 2025 14:17:46 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 14:17:46 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        mhartmay@linux.ibm.com, borntraeger@de.ibm.com
Subject: [PATCH v2 1/2] KVM: s390: Fix incorrect usage of mmu_notifier_register()
Date: Tue,  5 Aug 2025 16:17:45 +0200
Message-ID: <20250805141746.71267-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805141746.71267-1-imbrenda@linux.ibm.com>
References: <20250805141746.71267-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDEwMSBTYWx0ZWRfX5m0QNRjXIbQy
 BXlV7jXdzJruAuf74dDXxLHiWHXM/u/eTDnzF49SY0wCWJt9ly7w75Q0c8tZ300OX4VFMFWwv+i
 VbPWCHKmXsTerhxUsdTCvW6Jqe7OHy8TeQLCd3owr23qlO66AYhpIJFsIR7hBNJ3G2t0ff7/ZaV
 vXal7UocHth8jtwMmuFo2xZTfsPeGxxH109Y8bof2PLkSTNVIHyze8uUHIIOiWV7dPLhRuJ3fnj
 V5ICR9o1NYx1UvMDNJ0426IjGdh7Tdj9QWAhaLG2yVaDa8ZWHCpAh65E8/D3FsAdDtACtN++jMJ
 kWQWcqaxUEiMScsVLzhsSaCbjtWTV4DmFv+b1UscXQ/BIogp5RQrP5i18KD/qlBQEjqWPhYKR8j
 bwQtTu8LJWBSSEQRTXe4/DGNUCUuTRU2RtGSxbja1MnQYlk/6z0SAHD7XTkYw/ijWnz9YwfS
X-Proofpoint-GUID: ktBGzEMbmyJzXXBgjWQQaFVeJuLvnvBr
X-Proofpoint-ORIG-GUID: ktBGzEMbmyJzXXBgjWQQaFVeJuLvnvBr
X-Authority-Analysis: v=2.4 cv=AZSxH2XG c=1 sm=1 tr=0 ts=6892128f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=GJtTgPQnudJMRmo940AA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2508050101

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


