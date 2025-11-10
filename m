Return-Path: <kvm+bounces-62540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A294C48441
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E2ED634A93B
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA69E2BD5A8;
	Mon, 10 Nov 2025 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eNDuI6Hu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A22A299954;
	Mon, 10 Nov 2025 17:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795071; cv=none; b=nLJeBkACYBNspVPPos6Nw/946RGY5fm/VDOOET5lXekgwu8cMi4Vx9+RI06/pOsB04kGJS1l4xDQO5Io1jFZNgFLH+UmM47jqeonE6KH0Xi84nW9w5ogZe9WT0tGdKsfElM9flF98dQtAF/gQeZE/NGJrLJtuSTRLVjMucFoRAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795071; c=relaxed/simple;
	bh=Hst/OhKhiH9SPRZswZ0IEvg8OQT+QMQcmU7e5AZ5NW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mK5JRIjOpj9mF494/G22A2/0R4QRe3xf81PqZgBvBVUlvlFsztRzDzR7jRLzV0ZBNKgFZa6Sy2Mx/WqcNmvVhbGhR1YzlmKcXFHie/z27qyjyG1aTfgeGeVdjBSdotri0aVhsFz3yFv+/0fSwoeC1aUTBR88q9+wRMfmhSJD5qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eNDuI6Hu; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AADjwAM029376;
	Mon, 10 Nov 2025 17:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8xZqda
	ieLskYYPxWrObwSvNWdiU4q7URh/IR8i/64M8=; b=eNDuI6Huf1OtL2/ZIW9VtC
	JtMtA2qH+DSqUYRU1QXkUa9r2x0lD5AOo/fVWMuJyI5fJSxh3uwbhspYgKXxBIro
	MIPubVLP6lFd8J5+TMmdhaAbRfNvnYKiWj2kAI38POFxnPI5kxo+gp540CJZO0lp
	wwGhaI6KKEcKzsH58A1INCJ0WLaL/3AHXRsK0SWTkb/2MmaJYWqz3uHdhjN4CqWW
	dTSqu1GzP+N3gr3MhV61+EDWhZqRdO7RjL9PEDGRJ9/5MmkQ7krTRcHMY65TII0Q
	pa+y2yVd9x3WcB3tt8cviwBTOLWGbK0O/LdNad9C0Ersem1UWIixbwrzwuJOwvzg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5cj06fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGUmb4004770;
	Mon, 10 Nov 2025 17:17:43 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aagjxpuw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHdIc16187740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87DF220040;
	Mon, 10 Nov 2025 17:17:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECD1B20043;
	Mon, 10 Nov 2025 17:17:38 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:38 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 10 Nov 2025 18:16:51 +0100
Subject: [PATCH RFC v2 11/11] KVM: s390: Add VSIE shadow stat counters
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-vsieie-v2-11-9e53a3618c8c@linux.ibm.com>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
In-Reply-To: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3512;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=Hst/OhKhiH9SPRZswZ0IEvg8OQT+QMQcmU7e5AZ5NW0=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCctp7fHesk1zgcbKmL/+gk/m3UrWXx2Y/4Lp6rr9y0
 uHYUibujlIWBjEuBlkxRZZqceu8qr7WpXMOWl6DmcPKBDKEgYtTACYSyc/wT/8At5vu5Kmh189G
 VXp4325W4TviYBnvek91dvqRBSmCwgx/RbRZ8naYqC+Sav+R+9vXr6/8kenHhS+1CtRWTTv4sfk
 +KwA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Ss+dKfO0 c=1 sm=1 tr=0 ts=69121e38 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=ACqrv-Omp4_yNseKlhkA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5NSBTYWx0ZWRfX4RwNmY/fRgfZ
 mZTjvuOey4dInBY5WnZ848b6OsaInimc7FYwyD0cBB9+NvndNHNQZPGsVh4vvbaEOYJHbHGH18m
 xbHB+3a/xkwx573gaU+84WZ269PJJqzetK5kMMotDXXkWsaq3egQ6uA/bcZ+QE2Yuzz6ieusNQU
 xmcMzbslckZEMwmoZ6+YTt9dPp+ZEFCEEEaH0zRWdYSpB3E7vGBMEyuxEyheu0tAbo6tlqoPKcd
 z3FIBhaSWup05kiQRtg2OfDOL5S29+4YXbMJQt5mp4QF38YvePdNLXKzponzCWsq6EXd973tmU4
 YT7mizzWzozOADkOCO058sZg15arzpGQN+vxZXARzirdRyrENyzk8soaDq0tT4eL86rHOUqBj/F
 wo7tGqaAmTxr3Quq/ZjilBBZQDLtNg==
X-Proofpoint-GUID: USDpZeI-3No_AMCU7gBA5ILgECIPyNRH
X-Proofpoint-ORIG-GUID: USDpZeI-3No_AMCU7gBA5ILgECIPyNRH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080095

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
 arch/s390/kvm/vsie.c             | 9 ++++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 191b23edf0ac7e9a3e1fd9cdc6fc4c9a9e6769f8..ef7bf2d357f8d289b5f163ec95976c5d270d1380 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -457,6 +457,10 @@ struct kvm_vm_stat {
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
index e3fc53e33e90be7dab75f73ebd0b949c13d22939..d86bf2206c230ce25fd48610c8305326e260e590 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -79,6 +79,10 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
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
index cd114df5e119bd289d14037d1f1c5bfe148cf5c7..f7c1a217173cefe93d0914623df08efa14270771 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -767,6 +767,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 out:
 	if (rc)
 		unshadow_scb(vcpu, vsie_page);
+	else
+		vcpu->kvm->stat.vsie_shadow_scb++;
 	return rc;
 }
 
@@ -843,8 +845,10 @@ static struct vsie_sca *get_existing_vsie_sca(struct kvm *kvm, hpa_t sca_o_gpa)
 {
 	struct vsie_sca *sca = radix_tree_lookup(&kvm->arch.vsie.osca_to_sca, sca_o_gpa);
 
-	if (sca)
+	if (sca) {
 		WARN_ON_ONCE(atomic_inc_return(&sca->ref_count) < 1);
+		kvm->stat.vsie_shadow_sca_reuse++;
+	}
 	return sca;
 }
 
@@ -958,6 +962,8 @@ static struct vsie_sca *get_vsie_sca(struct kvm_vcpu *vcpu, struct vsie_page *vs
 		sca_new = NULL;
 
 		kvm->arch.vsie.scas[kvm->arch.vsie.sca_count] = sca;
+		kvm->arch.vsie.sca_count++;
+		kvm->stat.vsie_shadow_sca++;
 	} else {
 		/* reuse previously created vsie_sca allocation for different osca */
 		sca = get_free_existing_vsie_sca(kvm);
@@ -992,6 +998,7 @@ static struct vsie_sca *get_vsie_sca(struct kvm_vcpu *vcpu, struct vsie_page *vs
 
 	atomic_set(&sca->ref_count, 1);
 	radix_tree_insert(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa, sca);
+	kvm->stat.vsie_shadow_sca_create++;
 
 out:
 	up_write(&kvm->arch.vsie.ssca_lock);

-- 
2.51.1


