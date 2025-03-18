Return-Path: <kvm+bounces-41441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3073BA67C71
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 20:00:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B270881F80
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57B6212D6B;
	Tue, 18 Mar 2025 18:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X2OVVS63"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85A2204C39;
	Tue, 18 Mar 2025 18:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742324390; cv=none; b=orQuktIinJJlc3DNa/15gZo3rinRV0mtC1EZazxnOQ7Q4yxOMPqX+0yN6AOK8GMTJAbFEPhp/L+i6bH2mbIraDlN4DKPkyVREa4tlNa6851b8BHD4H4jP++iE7dVaVWHiJrXV+tmAb8cMbv34TbG/HE7JY801m/DbWgrN/eJdHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742324390; c=relaxed/simple;
	bh=+Yg72qORBtzVV1T7esyDCUCOX2LDt81lDlbKyhaAPVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IlpIhGjYb+dRiQhdEcys3Y8sdhgMZPmRv8Ng0sp7gh6F0wBxbzvqS4mE9yiQNJwcM0LovjYWGbPkPIdkQjBS3aY2xHDOw/YIzXGynWHJZISMSeda+ac8Dgzdo28GJ7POWkSDO/GTVx1CpSz6b/3QU0kt+amQXfD2DzsBbtNDVeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X2OVVS63; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52IEa27t006836;
	Tue, 18 Mar 2025 18:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qnuq1/
	psp08YISaDhpu9X5WVOinbRwZ7xXMTC1EgNsc=; b=X2OVVS63iEhGMfS8eVOIxb
	QAgJ0IGaBl1JkYEBqcPEupFFnsN4Y1lm/Qc7KkPuPekER9OczZRG1TtmBY81vuyx
	rG1TMijMOLr653Itpgw1aqJLQMjf/qPVFi5nNsg3vnfqf1PlSCxk47lqTX++nyBg
	ik+q7z9LM9VAPNMVCycWZDlRXcxqaOWT5VomV2uwdRi9QezzgPKGtIsMKlIdCWKF
	4nppdtqLK4ErwwR7e2deyQQpqz1uT+Km7mXrRsIRuqtft8TRrafE2ZF96oFWZtAJ
	l7l4FtUPcQSM0yKhH34XLqb8hGqEGz4mSDIjaIUHPro/QES0wKBdCreICgCP+ThA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45f179mghx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:45 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52II84ej024440;
	Tue, 18 Mar 2025 18:59:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45dncm5eca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52IIxe7D60490048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 18:59:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0F7A2004B;
	Tue, 18 Mar 2025 18:59:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A45C20040;
	Tue, 18 Mar 2025 18:59:40 +0000 (GMT)
Received: from darkmoore.ibmuc.com (unknown [9.171.51.150])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Mar 2025 18:59:40 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH RFC 5/5] KVM: s390: Add VSIE shadow stat counters
Date: Tue, 18 Mar 2025 19:59:22 +0100
Message-ID: <20250318-vsieie-v1-5-6461fcef3412@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
References: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zfIH89Xb23ro3MrnCRu2mMhMn-dCnXtT
X-Proofpoint-ORIG-GUID: zfIH89Xb23ro3MrnCRu2mMhMn-dCnXtT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_08,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=777 bulkscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503180137

Add new stat counters to VSIE shadowing to be able to verify and monitor
the functionality.

* vsie_shadow_scb shows the number of allocated SIE control block
  shadows. Should count upwards between 0 and the max number of cpus.
* vsie_shadow_sca shows the number of allocated system control area
  shadows. Should count upwards between 0 and the max number of cpus.
* vsie_shadow_sca_create shows the number of newly allocated system
  control area shadows.
* vsie_shadow_sca_reuse shows the number of reused system control area
  shadows.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 4 ++++
 arch/s390/kvm/kvm-s390.c         | 4 ++++
 arch/s390/kvm/vsie.c             | 7 ++++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index e44f43906844d3b629e9685637af3f66398a4a8d..909c662ac4e3e1e70a2e3e9054acee14bc20ed02 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -824,6 +824,10 @@ struct kvm_vm_stat {
 	u64 gmap_shadow_r3_entry;
 	u64 gmap_shadow_sg_entry;
 	u64 gmap_shadow_pg_entry;
+	u64 vsie_shadow_scb;
+	u64 vsie_shadow_sca;
+	u64 vsie_shadow_sca_create;
+	u64 vsie_shadow_sca_reuse;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 16204c638119fa3a6c36e8e24af2b0b399f8123b..aba798e7814be6011d71a1e1be894e2c0a6b2bb2 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -76,6 +76,10 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_COUNTER(VM, gmap_shadow_r3_entry),
 	STATS_DESC_COUNTER(VM, gmap_shadow_sg_entry),
 	STATS_DESC_COUNTER(VM, gmap_shadow_pg_entry),
+	STATS_DESC_COUNTER(VM, vsie_shadow_scb),
+	STATS_DESC_COUNTER(VM, vsie_shadow_sca),
+	STATS_DESC_COUNTER(VM, vsie_shadow_sca_create),
+	STATS_DESC_COUNTER(VM, vsie_shadow_sca_reuse),
 };
 
 const struct kvm_stats_header kvm_vm_stats_header = {
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 3ddebebf8e9e90be3d5e27b6dc91d91214c3ea34..7b599b6eb2ceb4141b8f1489804aef5dcd429ea0 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -678,8 +678,10 @@ static struct ssca_vsie *get_existing_ssca(struct kvm *kvm, u64 sca_o_hva)
 {
 	struct ssca_vsie *ssca = radix_tree_lookup(&kvm->arch.vsie.osca_to_ssca, sca_o_hva);
 
-	if (ssca)
+	if (ssca) {
 		WARN_ON_ONCE(atomic_inc_return(&ssca->ref_count) < 1);
+		kvm->stat.vsie_shadow_sca_reuse++;
+	}
 	return ssca;
 }
 
@@ -755,6 +757,7 @@ static struct ssca_vsie *get_ssca(struct kvm *kvm, struct vsie_page *vsie_page)
 
 		kvm->arch.vsie.sscas[kvm->arch.vsie.ssca_count] = ssca;
 		kvm->arch.vsie.ssca_count++;
+		kvm->stat.vsie_shadow_sca++;
 	} else {
 		/* reuse previously created ssca for different osca */
 		ssca = get_free_existing_ssca(kvm);
@@ -771,6 +774,7 @@ static struct ssca_vsie *get_ssca(struct kvm *kvm, struct vsie_page *vsie_page)
 
 	/* virt_to_phys(sca_o_hva) == ssca->osca */
 	radix_tree_insert(&kvm->arch.vsie.osca_to_ssca, sca_o_hva, ssca);
+	kvm->stat.vsie_shadow_sca_create++;
 	WRITE_ONCE(ssca->ssca.osca, sca_o_hpa);
 
 out:
@@ -1672,6 +1676,7 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 		__set_bit(VSIE_PAGE_IN_USE, &vsie_page->flags);
 		kvm->arch.vsie.pages[kvm->arch.vsie.page_count] = vsie_page;
 		kvm->arch.vsie.page_count++;
+		kvm->stat.vsie_shadow_scb++;
 	} else {
 		/* reuse an existing entry that belongs to nobody */
 		while (true) {

-- 
2.48.1

