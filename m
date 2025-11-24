Return-Path: <kvm+bounces-64375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 557CEC80559
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 877413422BB
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2B030ACEF;
	Mon, 24 Nov 2025 11:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a8+pkUPt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7347F301016;
	Mon, 24 Nov 2025 11:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985410; cv=none; b=KHpzgOwJQ1cxlPR4QVgF64qQl48ABVoenH5jY3W6KZYP4UsJVmskbn6e+53k8uvN/op4xRnvhqaYnUEkxsCh9xMPvVMhD4V9to/qXeyKegAIBn5oCT94KmQNTYUrWXmdVNKCpVu3dVKX2buisNNdpkfA/RQVkNmlxFMiXqXaIXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985410; c=relaxed/simple;
	bh=BQaVofsijYu6aqGbX23OEg5Svm/IT88rlNXdFKrCOnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2eItkBJD32HXdHPuBcTr6J7AvromxXeyP7UCdgRru1nLm+agTuPcMYxT2QAD9lOCTGsiI5BphG9gA4k9iKk3ucuWr/TFHhRIlxKl1lIsYrYbKtswvSdAzbm6b8aBFS1yRXBAv7oGajpp3FnxbPdKQEL6F7JobJy2u5X7M/v76Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a8+pkUPt; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO7K6p6001353;
	Mon, 24 Nov 2025 11:56:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=n/gwE/8dJnFPtSE3p
	oDmul5aFQbsbO8y6rZMzFe19Bc=; b=a8+pkUPtc37WOBlyvjb21lv8MlWQp0OyD
	Y6XufavSF8O7ziiydyz/iE2YcYoP20Yq81r169rM55JPi+oEEdizUugSBVqaMLuB
	nSzDnL0vu5Tp4hPYu3b4icc8HjHfMpGjVJY9hQk06uvuCpsGqLsQ9nEy4zDn2UBg
	G0+OnvaBz48/PriofSNsvs3QlydplocxPnpY1/SO6G1THOxmrvmFFvGzuBkyBgvH
	qnsKPN8dgjfnBFFCDPUrBs5jp9iMWuSwfmo6SCIgfdvmKt4zZQP/zZRI1++nZL9Y
	aks9/csEEHhCM1iKJKR2PfDGmLOpXlosFDwNGvViUOprsSvNqWLqw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uuywwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:44 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOB6bIF016409;
	Mon, 24 Nov 2025 11:56:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aks0jwn3x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:43 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBudOr42533278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:39 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9ED3420040;
	Mon, 24 Nov 2025 11:56:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2590920043;
	Mon, 24 Nov 2025 11:56:38 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:56:38 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 22/23] KVM: s390: Enable 1M pages for gmap
Date: Mon, 24 Nov 2025 12:55:53 +0100
Message-ID: <20251124115554.27049-23-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX/US7z0R0w7Mh
 Lc65vVkj6mK2En6ySrQzfkMxjM0z5+XgKKB9+d9abYTiAe15HamaQehSIpQiTJaAVu88CJFlwqO
 ayyc7+8UZvyCsfIlIGwuT7SK3d2SXyLHb5eAVv778QIYda6P9efOhLbzGp7qXQmUjgd1cJ+vLMp
 dtMChL7mq8lwJ5xeWOZLPy4ORMM8fxURUtv3zJeaGs7D9QboJ9zsLfPSet01nLGLcfTZYNWa5UR
 IH+YNOHwd0yJgbQjJe62WWoyWPM/WS26MYViMNaAHsDO5izMFC2aioQhrW7sCo58NHk6Mz1FQlA
 clU5S8CkJQFdPku0XSdBwQUgeWCmHXZUyXtL8Tp7aPzGbTkF91MM+UnHPD7MrHtYCFb2aRRbZ/P
 6q1KrHfiCUAkmeKTxHCOrLjTDHRSzg==
X-Authority-Analysis: v=2.4 cv=PLoCOPqC c=1 sm=1 tr=0 ts=692447fd cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=2DwSK8QdlStOok5YbGYA:9
X-Proofpoint-ORIG-GUID: DFXfmTYrRklt3BdlGL9v0Dy0KhIvcjJy
X-Proofpoint-GUID: DFXfmTYrRklt3BdlGL9v0Dy0KhIvcjJy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021

While userspace is allowed to have pages of any size, the new gmap
would always use 4k pages to back the guest.

Enable 1M pages for gmap.

This allows 1M pages to be used to back a guest when userspace is using
1M pages for the corresponding addresses (e.g. THP or hugetlbfs).

Remove the limitation that disallowed having nested guests and
hugepages at the same time.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gmap.c     | 2 +-
 arch/s390/kvm/kvm-s390.c | 6 +-----
 arch/s390/kvm/pv.c       | 3 +++
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 11fcafcf5697..9d454764e36c 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -591,7 +591,7 @@ static inline bool gmap_2g_allowed(struct gmap *gmap, gfn_t gfn)
 
 static inline bool gmap_1m_allowed(struct gmap *gmap, gfn_t gfn)
 {
-	return false;
+	return gmap->allow_hpage_1m;
 }
 
 int gmap_link(struct kvm_s390_mmu_cache *mc, struct gmap *gmap, struct guest_fault *f)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c8662177c63c..b7dc1d601fb8 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -849,6 +849,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 			r = -EINVAL;
 		else {
 			r = 0;
+			WRITE_ONCE(kvm->arch.gmap->allow_hpage_1m, 1);
 			/*
 			 * We might have to create fake 4k page
 			 * tables. To avoid that the hardware works on
@@ -5837,11 +5838,6 @@ static int __init kvm_s390_init(void)
 		return -ENODEV;
 	}
 
-	if (nested && hpage) {
-		pr_info("A KVM host that supports nesting cannot back its KVM guests with huge pages\n");
-		return -EINVAL;
-	}
-
 	for (i = 0; i < 16; i++)
 		kvm_s390_fac_base[i] |=
 			stfle_fac_list[i] & nonhyp_mask(i);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index d8a5c7b91148..8ea5f8d7e714 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -621,6 +621,9 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	uvcb.flags.ap_allow_instr = kvm->arch.model.uv_feat_guest.ap;
 	uvcb.flags.ap_instr_intr = kvm->arch.model.uv_feat_guest.ap_intr;
 
+	WRITE_ONCE(kvm->arch.gmap->allow_hpage_1m, 0);
+	gmap_split_huge_pages(kvm->arch.gmap);
+
 	cc = uv_call_sched(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
-- 
2.51.1


