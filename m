Return-Path: <kvm+bounces-66500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B43CD6C22
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BC54E30BBCC8
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE2D34678E;
	Mon, 22 Dec 2025 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Gxihkx5A"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F483446C7;
	Mon, 22 Dec 2025 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422272; cv=none; b=IGkDJ4PuTINfknRWxPacnLb+Jt1Hf0nNjyQCmqadZ3YuCYlf9MqPd/F92wtAVllEYaUQLRyo9NAXRZvkFNP7GZ+xcFuQJNyW/OAzcvYuBfmh/IB7RBA4f7/8Pl87twh0vOaZyvCODXVa4wdBtcwrH9dqbc41QpdFxvPzGqy6Db4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422272; c=relaxed/simple;
	bh=3bXGPw+sqw4OSROua4l0QQfwqREdJhj7Ojv2eP9AtN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKqZaP++IBERAZFui9eiJqaGMJG25TOOfMljdfCRgixMDRq4ElvWWxb0hBT2vbVggBSPeT/u/NsGPXxEPxFJ75vevIAUjfFqswHtQft2VlmP/oienSDHE7Bmu3Fa8roxV8W/Ph10b/RD76M3zeGL3EWLL4FNrAWpy5OtcijjMmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Gxihkx5A; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMDUYwb006747;
	Mon, 22 Dec 2025 16:51:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Yo1/wWzGulIqhiMgo
	ZSkXn1/6nmpxw1R8Mrxi66Tl4s=; b=Gxihkx5AJda7X7dimSmW8Jlx7pUkI7Ijz
	TphxZkCoev2wj27ta3hrOXHg5COONDwzNYBajAIh2M1HkDZu9JDwk1B4OAEOqUKc
	NBbryUbF5KjdMHzgwRU6WYvvgM5lP8/WuUdHyG7M09A/yHliQukcMycYCy7+XM7L
	1CAhYz79iQwiWHvlaGWOCQkJ8IWnxFBom+C+mTdeneIeDM4m1LRsYVZMgRUzW0V6
	tNFxmbZYgXuXFQ+i7foG3jzCIZ5ueQ3fULrfnGnNwIe3rMdH6zzW1pgfCRLqI2dP
	FvlsjhCHsBFUtJGhVy9YcgsjhSfC2xEKH4mxx6nZf53j4oQkaHqOA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5ka399gy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMFXWeO001099;
	Mon, 22 Dec 2025 16:51:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b664s7a7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:06 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGp3Hu43450660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:51:03 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 274892004B;
	Mon, 22 Dec 2025 16:51:03 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A56C20043;
	Mon, 22 Dec 2025 16:51:02 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:51:01 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 21/28] KVM: s390: Add some helper functions needed for vSIE
Date: Mon, 22 Dec 2025 17:50:26 +0100
Message-ID: <20251222165033.162329-22-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251222165033.162329-1-imbrenda@linux.ibm.com>
References: <20251222165033.162329-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cw7WvHtpcQppx9MxdhjZqUlVmJaQon1r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX6KTuAR+SjC2Q
 TUfCiiHWeMcud4WvjHmN/gRMBoL7WmOvMt51fh6U0/RKfdkh7toxKA9qQPPBh9SM4Hsv9EhFH/r
 XeJObs5VyQsd/f8azXMZio5zC0l/lGj5DdCctdl72aFbWT1zqVowikpLvKK6R042rTJe4fgl7sO
 nXvDN77HU9+hY6k2cf01XboW5tm8fHoo+FsHvuRcqA2ODtOf+X75B9zO7eCzDa5WYiPqwGpNWPF
 Yen6BIkeZoqpjK7Jfk/2FRPgI04ABFaoGYJzDj4kcJ1Hjip03oaU8s+WxXixzCUcGxoypS3A/bs
 UOhuZgZEWEtiKMLTug7Mw7JbKvu9BiTm4Tl0QnGyxVtqhnCFNC6RinOleUgSITJ8UNN5fJSbZdp
 lnf8XAD8mZqVtdfbrgoQrFoWVHJD4kD6A9oMJ53/6zcat1KWFLYh/oUKMfX2UGwlmZ1XY6La89j
 mwhTxMtLsDMMXx0mVmg==
X-Proofpoint-ORIG-GUID: cw7WvHtpcQppx9MxdhjZqUlVmJaQon1r
X-Authority-Analysis: v=2.4 cv=dqHWylg4 c=1 sm=1 tr=0 ts=694976fb cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=DmfEQQ1nzNyZHvt6oY8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2512220154

Implement gmap_protect_asce_top_level(), which was a stub. This
function was a stub due to cross dependencies with other patches.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gmap.c | 72 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index f4f47e5fc3d5..0abed178dde0 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -22,6 +22,7 @@
 #include "dat.h"
 #include "gmap.h"
 #include "kvm-s390.h"
+#include "faultin.h"
 
 static inline bool kvm_s390_is_in_sie(struct kvm_vcpu *vcpu)
 {
@@ -1009,10 +1010,77 @@ static struct gmap *gmap_find_shadow(struct gmap *parent, union asce asce, int e
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
+	KVM_BUG_ON(!is_shadow(sg), sg->kvm);
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
2.52.0


