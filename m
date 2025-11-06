Return-Path: <kvm+bounces-62200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 37EE4C3C5CC
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:22:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 67A7A4FA9EF
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06BC350A03;
	Thu,  6 Nov 2025 16:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bghZljVd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B0E34FF54;
	Thu,  6 Nov 2025 16:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445495; cv=none; b=tCmuQdX0dm9BsbyaSrBu2gH+D/QHuieaRyw7eAP3IOOJltzWujLlWNOSVwb+MYnQZIrDbc9mX9poZIDxHhs4Z/5H9eAjRBLtnlhczk3K+wA9eyEBV74i6Hq+IUzJeeoWJnrdq+ITKsbU0H1Zu5jS2NACM8MfXxabGvpX3RbnLnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445495; c=relaxed/simple;
	bh=8TgO65JwbDC7V7hOOwTDnZUhkhIbIu4EIUnaUFKTdDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUU3sq12ITOFZgXrnCtZCiyisgsgJaKrG/c6GsoIl1QdU4sjfchCxZ4RXlcu+GnSbjEzL9rEBf+PLg9gIhuIi3ZTGqRt8a2F4PXdjejOw1G5L6cFgSqGd1QtPhw9qFvWNV3uTdBCBtoSPLm/TI2bOJTNzMNjv0anS9pU1tEuLM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bghZljVd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A67T487003443;
	Thu, 6 Nov 2025 16:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Hg8/TrBPyKf5U3Oy0
	w06WRTqGuEGW1o/ucxdq1/qhmE=; b=bghZljVdW+sr1Wjkobox5YC1NdHae67dB
	dRwTrtqkYt9/xKv7ZLqke5EXA8Mqgm86L1s75CC/J21dix9Hhbqg+hd+/jgUsBw9
	YM+2AVHwXYut4CrVFQ/RLbrTBvWJRs11SOt3FugBBP/lDonEsvrH+VOpDMeDE3Zv
	+rhS91GATb4ANYCqMZHXJSnkQnKLNz3OHJOsyVOtb+zGejdHk1BfeyNPVU8kKgsb
	elMkQ3HPeUzk/JwE3OC0MDS1W7LHl2El5cdNyNAVP5jLXBsv1d/2MqBvZirAoINy
	YP5WjNsnf8Q7EVTLlC1X5J374XzJGVs+w84yXX2ICyHxunVWhCj+w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59xc84n5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:31 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6F0CrD027408;
	Thu, 6 Nov 2025 16:11:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5vwypftj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:29 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GBPeM27591246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:11:25 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFEB620043;
	Thu,  6 Nov 2025 16:11:25 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69F582004F;
	Thu,  6 Nov 2025 16:11:25 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:11:25 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: [PATCH v3 16/23] KVM: s390: Add some helper functions needed for vSIE
Date: Thu,  6 Nov 2025 17:11:10 +0100
Message-ID: <20251106161117.350395-17-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106161117.350395-1-imbrenda@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfXy1lxUri9/xka
 IHwwKZMhvlEaCxfLc1EPHj7ckkaMDx+i2dtpi2sqbW//QOg837R1hv6TiibYcoJyMtVWp8M58BX
 60lq0x7PBcQzei8UYkOJ3cEMWwKFMM4QfK7fHpDGaJ9peKHMympIJVnyuqrns0CdpgHCndB8Fyn
 0MuAuDOozCVapezD8xQRfAim+eEYrxqJKjJNuHdU5ytruVKNJgJZjGYhfN1eVul+OLRlKmUWkm3
 1czNMS2kz8tBrNOVjBPQvSjd26LYsSsFW0qRWYtaFAfy3scSaxkYcQrRK/ex3py+NZ46+Ze0VzK
 WkMzTiv735apmYsLCP3bQBJoZSgmf6U9uoDBnszg13d3fxhqWxkAMOfY6ugd+WV6/Cqm8dW3V96
 YVb6mJiPFU1nvkuPnCQB7rNOsM6V7g==
X-Proofpoint-GUID: dQJpGYYN3te784cZdyw6nkWvbafrEH2P
X-Authority-Analysis: v=2.4 cv=OdCVzxTY c=1 sm=1 tr=0 ts=690cc8b3 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=s396rH6M6x42IRX-7TcA:9
X-Proofpoint-ORIG-GUID: dQJpGYYN3te784cZdyw6nkWvbafrEH2P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021

Implement gmap_protect_asce_top_level(), which was a stub. This
function was a stub due to cross dependencies with other patches.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gmap.c | 66 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index ebe0947e0be2..124443d0f5ff 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -22,6 +22,7 @@
 #include "dat.h"
 #include "gmap.h"
 #include "kvm-s390.h"
+#include "faultin.h"
 
 static inline bool kvm_s390_is_in_sie(struct kvm_vcpu *vcpu)
 {
@@ -985,10 +986,71 @@ static struct gmap *gmap_find_shadow(struct gmap *parent, union asce asce, int e
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
+	for (i = 0; i < CRST_TABLE_PAGES; i++) {
+		rc = gmap_protect_rmap(mc, sg, context->f[i].gfn, 0, context->f[i].pfn,
+				       TABLE_TYPE_REGION1 + 1, context->f[i].writable);
+		if (rc)
+			return rc;
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
+		radix_tree_preload(GFP_KERNEL);
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


