Return-Path: <kvm+bounces-64366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A76BC80523
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:01:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A035D3AB059
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827AF306490;
	Mon, 24 Nov 2025 11:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iMRcWZpU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805642FFFBF;
	Mon, 24 Nov 2025 11:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985395; cv=none; b=Vq7tQlg5F6zY41jWTd11wsf4G5XZmP5DHb6BOogNTSr1yyWiU0Be5fvvyIKvIGK5jwjNfOVlBn95f7geshX+rb4f3EQdO4K1lLgFArkZOKIBZpTT+NdqZ6p+NaBQyIYpm4UeZExe80Y5V2E/lXG+Imb0S5t7CANxINz+QsziNU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985395; c=relaxed/simple;
	bh=eFx4C8TKinkyxXAGMKT6Z5dUG3VPINYdwUX6lGw1io8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/xg++SbKqMsapOWeOryTZd+aNzVEhb2W92cUp6M/ZaQtl0k4sBM4JNu9EPDdIfiqmntxK80+zUfCRa8WkPdfQ38+d0k5ue9qNvUHWJyF1Uf5aTE7S5auehxwWf2BahsGU45M3W+8jnXHtd8xgzlUDuU+f8Ul23F9cVHjXhnyco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iMRcWZpU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOB7pPV002793;
	Mon, 24 Nov 2025 11:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4PVGjAsHVoKCa4Eb3
	luIfLPN4UXS/FA5azO0So6nb5U=; b=iMRcWZpUPVl63isLGsIu0WjbGlxoqQj0m
	/sn7wBBCWIvfTMeKhfs4tc6/PlGIjn3WmG/oJjgrsUF6at8oYHLGGN74BD3Ca/cH
	qa3ima7pTNok3ywZe6KUJ1nt0Rt2fyqof1dZeqgwbzGjWg+ZiY+cteC6tELHt15e
	AYQ7yRP3y/yqbDf+RURBFx7zcnhCPz1pKPXqWfQDkeaJTTzQLXuOUoeTmestNXyH
	TYPPKokbIhwOJbYcGWjtbE5ovJqY+i5vytlu0isidddi5W+43PtgR4rsdg5+V0sN
	NPD1xTIVgShjF+0fTeNjZpIgxYgPkr7emheTXpwjGuncIrzSZvj6A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4u1qdty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOA8QV5000831;
	Mon, 24 Nov 2025 11:56:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4akqvxnuqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBuQrd52429170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5749F20043;
	Mon, 24 Nov 2025 11:56:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF36620040;
	Mon, 24 Nov 2025 11:56:24 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:56:24 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 16/23] KVM: s390: Add some helper functions needed for vSIE
Date: Mon, 24 Nov 2025 12:55:47 +0100
Message-ID: <20251124115554.27049-17-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124115554.27049-1-imbrenda@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX9E8cI+24Wqgz
 sut12Bnl5hVOHJh8qEQ+STXYgqbkYsARG48fK/GRzH77qBGRY55vDIUVTgURw0XyZevbm0WgNqp
 OjWzSU7KuKNx9ioaxRhfEhWH7xAq8z7wUUGadRG+wHUK1SfOV+BzZCwkmT3aRkLZCJYvcbV7GcA
 keOPBI+6X8Vmd4ktosbERsj8jRfKnP1qSMNYXLHY1tnSmbJKHxLh4IYx1TAiRd0DeSYz+XTuQz1
 EQOriprp7RY7NrQGfMCBmtBptSvf1I8ICxniCbuB0gB33pCdiKooFRCqGXq7MvnOshpDS4/QfxY
 Fik2cWdLlcRsc8RjMyQjkQkq+KTx6R4zqvTuBXcBNQuMqUisp1/pocHZ7FWQNatXCvirkI/avU1
 7E3t6FuVrveLos+jxy1QvTKvaJohPQ==
X-Authority-Analysis: v=2.4 cv=SuidKfO0 c=1 sm=1 tr=0 ts=692447ee cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=aP1jQA4SsBbapb4bBcQA:9
X-Proofpoint-ORIG-GUID: Lvm-dye2TGFwIrMTTRq-udEZBAYvmCP0
X-Proofpoint-GUID: Lvm-dye2TGFwIrMTTRq-udEZBAYvmCP0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220021

Implement gmap_protect_asce_top_level(), which was a stub. This
function was a stub due to cross dependencies with other patches.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gmap.c | 73 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index be2f6cd5263e..26d9b841ab23 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -22,6 +22,7 @@
 #include "dat.h"
 #include "gmap.h"
 #include "kvm-s390.h"
+#include "faultin.h"
 
 static inline bool kvm_s390_is_in_sie(struct kvm_vcpu *vcpu)
 {
@@ -982,10 +983,78 @@ static struct gmap *gmap_find_shadow(struct gmap *parent, union asce asce, int e
 	return NULL;
 }
 
+#define CRST_TABLE_PAGES (_CRST_TABLE_SIZE / PAGE_SIZE)
+struct gmap_protect_asce_top_level {
+	unsigned long seq;
+	struct guest_fault f[CRST_TABLE_PAGES];
+};
+
+static inline int __gmap_protect_asce_top_level(struct kvm_s390_mmu_cache *mc, struct gmap *sg,
+						struct gmap_protect_asce_top_level *context)
+{
+	int rc, i;
+
+	guard(write_lock)(&sg->kvm->mmu_lock);
+
+	if (kvm_s390_array_needs_retry_safe(sg->kvm, context->seq, context->f))
+		return -EAGAIN;
+
+	scoped_guard(spinlock, &sg->parent->children_lock) {
+		for (i = 0; i < CRST_TABLE_PAGES; i++) {
+			rc = gmap_protect_rmap(mc, sg, context->f[i].gfn, 0, context->f[i].pfn,
+					       TABLE_TYPE_REGION1 + 1, context->f[i].writable);
+			if (rc)
+				return rc;
+		}
+		sg->initialized = true;
+		gmap_add_child(sg->parent, sg);
+	}
+
+	kvm_s390_release_faultin_array(sg->kvm, context->f, false);
+	return 0;
+}
+
+static inline int _gmap_protect_asce_top_level(struct kvm_s390_mmu_cache *mc, struct gmap *sg,
+					       struct gmap_protect_asce_top_level *context)
+{
+	int rc;
+
+	if (kvm_s390_array_needs_retry_unsafe(sg->kvm, context->seq, context->f))
+		return -EAGAIN;
+	do {
+		rc = kvm_s390_mmu_cache_topup(mc);
+		if (rc)
+			return rc;
+		rc = radix_tree_preload(GFP_KERNEL);
+		if (rc)
+			return rc;
+		rc = __gmap_protect_asce_top_level(mc, sg, context);
+		radix_tree_preload_end();
+	} while (rc == -ENOMEM);
+
+	return rc;
+}
+
 static int gmap_protect_asce_top_level(struct kvm_s390_mmu_cache *mc, struct gmap *sg)
 {
-	KVM_BUG_ON(1, sg->kvm);
-	return -EINVAL;
+	struct gmap_protect_asce_top_level context = {};
+	union asce asce = sg->guest_asce;
+	int rc;
+
+	KVM_BUG_ON(!sg->is_shadow, sg->kvm);
+
+	context.seq = sg->kvm->mmu_invalidate_seq;
+	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
+
+	rc = kvm_s390_get_guest_pages(sg->kvm, context.f, asce.rsto, asce.dt + 1, false);
+	if (rc > 0)
+		rc = -EFAULT;
+	if (!rc)
+		rc = _gmap_protect_asce_top_level(mc, sg, &context);
+	if (rc)
+		kvm_s390_release_faultin_array(sg->kvm, context.f, true);
+	return rc;
 }
 
 /**
-- 
2.51.1


