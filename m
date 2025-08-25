Return-Path: <kvm+bounces-55627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7509B34578
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:19:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D211D1A83EDF
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657D12FDC5C;
	Mon, 25 Aug 2025 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k2ljsN43"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53B62F360C;
	Mon, 25 Aug 2025 15:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135122; cv=none; b=QQ+Yt0gMZbPDZs376o1eFL/kd0bmmm4UtF6lL4ajt2ZcMIjH+FnravYE8wINbcsgGHV4HzXibGUHaPzCUr64DagCVvzD5gzftYuHOFbGarjrknmsH8nSvfxcxy2r72vR/yVVwcKWDFeRWu8t6W5CB1MfhQZLgx/QGBXUYySmteY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135122; c=relaxed/simple;
	bh=c2b39EvPjP8TBAdeCNjBhSRcYeMBfCGN+RJKGU/Vsoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HojfOqkV2V3bYTwyysogHy20lYJTkaMZUmUHi2Ko6QVxC64NOn/xVeiitP+FYz5uf2jWshXOS7BK7WkxpCufARw3sI+uEE9MBOKJAgIBwhPOT1rdF6pdLryEsnePjf0CZ9gVP20UHDqQ7XIzovi9LTCTxJY058SSGtpLsIRCXPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k2ljsN43; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PBfW80006043;
	Mon, 25 Aug 2025 15:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nOvnaQQs8vs6gp+37
	M0siP+2K2MaM0nGK78Ablmg7mQ=; b=k2ljsN43+eCAz1GEt02tx1f0flnH6fboV
	aoK0XDLl/RmHzn2CbCPdUViTEgG/9etJdPNh6FZ6GyRKz7sk8D+3JhSg/QaNSeaQ
	I8DSDfSx+zkF6vigazkoji3jG4GFXetvtZAW649ok7umMx4o2kTUb/Fw/x0QxIo/
	/CgU2tjZI9WOQ272ckRckOZ6MRWho0u9hcIgjk+egqFQt9H+qFXIcTvUcASU+xUs
	7HkyJUPXFT4EcTpmr6OXVDh4rbpF8k9BfQsFKkv1jV0fQqjb9QHUoKpEspBuaI9u
	kaujC56BQ79ByS4mONcZtLP444uIMAI5Fx6vatzeD7TDH2sm8SiNA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q97511tp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 15:18:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PDMd8K007458;
	Mon, 25 Aug 2025 15:18:36 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qqyu6p7p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 15:18:36 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PFIXXD34538028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 15:18:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E80A720049;
	Mon, 25 Aug 2025 15:18:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5104320040;
	Mon, 25 Aug 2025 15:18:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.17.238])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 15:18:32 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        mhartmay@linux.ibm.com, borntraeger@de.ibm.com
Subject: [PATCH v3 1/2] KVM: s390: Fix incorrect usage of mmu_notifier_register()
Date: Mon, 25 Aug 2025 17:18:30 +0200
Message-ID: <20250825151831.78221-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250825151831.78221-1-imbrenda@linux.ibm.com>
References: <20250825151831.78221-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RGsn1MQY6_8xgoCnc7xfUl1qgeObtJk0
X-Proofpoint-ORIG-GUID: RGsn1MQY6_8xgoCnc7xfUl1qgeObtJk0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDA3MSBTYWx0ZWRfX9RCQyNDqHgvM
 5WHXsviBvR9MiRJh8eIMnWNhv300pHJ2ii+gHTcogKAbgsQpaIAKo81trfK/NcFat5Z83ntFOC7
 YQqC5tioH22zrohGw9tUXoj/7t129OTo/tLyGDA0oGKsXgSc5PFJg/I1j0ak0QGPBNpis0yLSCb
 7Z5ztKIgvsTX4rbWJz+8CxfgUVGUdecY3N8KlPP4YuzhH6BRMv7oCZ8eMmW/wGR8AkU7ofELIY9
 oWa1kbsTPC1h5JDwjoM5JceduEDQJkQvvFKyGK1FaNx8xe4iU+I+lKIpdyIuKuBy+ZeiBngdJOg
 Up7I09MEnGlL2v+iDRvInzOLm0bHdUNCAwD3h0zQuAggZ3hAXEKeLgXEkjY8r+Em4uK/40YYr1t
 pM+PCEee
X-Authority-Analysis: v=2.4 cv=RtDFLDmK c=1 sm=1 tr=0 ts=68ac7ecd cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=GJtTgPQnudJMRmo940AA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_07,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230071

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
 arch/s390/kvm/pv.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 14c330ec8ceb..ede790798fa3 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -622,6 +622,17 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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
@@ -657,11 +668,6 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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


