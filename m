Return-Path: <kvm+bounces-62533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D527CC48471
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:21:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 375FB3AAF2B
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4EC29B239;
	Mon, 10 Nov 2025 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="my7RfYGH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CC0284884;
	Mon, 10 Nov 2025 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795066; cv=none; b=TOo2SaXGQimpjYGYhPw/kaMh1ZXJkE1MOKTYsPkAGcj0zeDSE7F/IF0sib6zSENhjBOYphzzUWtnplgoDcU5dKhwtVqLy18GFeAWUZy9du2fXjV8ZyvWKFB9ym2guPyd+IxZjBUTa4UGcrb7DWeKGrdGlUNpu/w+CW5ququNK14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795066; c=relaxed/simple;
	bh=fBa1poYiFXV4uQZ+0i7H/rZ/MIT+1p6+g3rHEET1Yqc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BfqsohOhmWUwEa2bU5pljZbWb1SM4BydUlBHGgm+WhyI1kCw9XhFeAnYrmyMxauLZ6luM7moYpU//Ybo/je9eekvWYXnkzLDbnx4Q+gi7hJBVp5tLF1MM6vuYA8KhguZI7BRoeYgNtsUouH0aqVDKfF867vbyHOmamIHPQIHqVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=my7RfYGH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AADOaW7019038;
	Mon, 10 Nov 2025 17:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Pf/tc+
	yEnb18HaSdBkMWZ7tHD5CcqTT5LJ1HaaM2oB8=; b=my7RfYGH8PQ6uapoJwM0hz
	osC09SHxp88fezZcmS9fBh0THAL6GqMKTFKhokwQYfpTa3RdHm5rMIqNzlEkNQun
	+30Dl+kgBbODXITQqjILhgrypzxnM4zCBaAISgGm0q8ZfAK+70NM2KKx04GDKkmD
	3eoLDFtGx1MPp1Eq2oP1HCkjG/4ZX51Aq9cyfuMiqogOdFwgkR6CRRbmJvqZFYBd
	UQxYZd4G1/ilVHBRbT+lzjDB6KeHkgY+MZ7Q+gBZ5bof6x6RQ98SSmu9hjSvbrob
	zEC31jbuUFTMyGvjkLtwTmkgK0BXWdeG3EIKLNUpnPn1bgKxLwUHWNn6dskxo8tw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk81c3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:39 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGXscQ007314;
	Mon, 10 Nov 2025 17:17:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajdj6h18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHZP515532342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FC6B2004B;
	Mon, 10 Nov 2025 17:17:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A41120043;
	Mon, 10 Nov 2025 17:17:34 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:34 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 10 Nov 2025 18:16:44 +0100
Subject: [PATCH RFC v2 04/11] KVM: s390: Add vsie_sigpif detection
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-vsieie-v2-4-9e53a3618c8c@linux.ibm.com>
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
        Christoph Schlameuss <schlameuss@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2676;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=fBa1poYiFXV4uQZ+0i7H/rZ/MIT+1p6+g3rHEET1Yqc=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCctp7ar8p5Z97dmj/dMmfBfe3cJ5NOLNHaE6ez6z5r
 0tvNVb3dJSyMIhxMciKKbJUi1vnVfW1Lp1z0PIazBxWJpAhDFycAjCRnxcZ/ntURVtn7F1W7PVG
 TujOlx1FihfmOj5eVrT6wdvbqxjd+pMYGdad//T9U5n28zaWE782plWtkd9hydqwJMbZLbrJzbR
 alAEA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX9YXp34I2puDF
 oSyYagbyNDO98STaGzD+GA5J2+/Z9uXiaRXnrp9+YQoasqlNmYtgBt4hEb69eUyvE94cQAdIg57
 kVAf8utL+TJAyosb0bw9oJ5jK7nUJpr0skMRMlFL3L5oZhM0PGgBzN844MAITgT+1hSFvhko80h
 oiz6z2Ap0rpwQkXHaCrQSYCFw3cEE24Curmb/carPtaFCKzWYNWwTtWIIfwp3F6Jt/Bzbn08893
 BoQkuVzQOzM3jE8XJZRQqAKX4ZvIgvrJ00vUlJgjoNRXL++DXDxNBF367avqg6TLVjt2cVkVRXg
 1uS0W8OtNiAwNgZH/Ry4F+hsnlfVvWg/3+Sh2AW9qdlRc+pyQQ229hznDzNGzFmXmYg/+eUCdml
 YLwhFq7gtQ/5r7sQT4dvVA5/tLV0pQ==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=69121e33 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=HhGY3ygtAZ2b3DQUAK4A:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: zbjf9-VqDsUCfYM5ZfASfJnWMuqq6tUD
X-Proofpoint-GUID: zbjf9-VqDsUCfYM5ZfASfJnWMuqq6tUD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

Add sensing of the VSIE Interpretation Extension Facility as vsie_sigpif
from SCLP. This facility is introduced with IBM Z gen17.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/kvm_host.h | 1 +
 arch/s390/include/asm/sclp.h     | 1 +
 arch/s390/kvm/kvm-s390.c         | 1 +
 drivers/s390/char/sclp_early.c   | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 22cedcaea4756be50dcd65bdd85b83cdb0386dbb..647014edd3de8abc15067e7203c4855c066c53ad 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -644,6 +644,7 @@ struct kvm_arch {
 	int use_pfmfi;
 	int use_skf;
 	int use_zpci_interp;
+	int use_vsie_sigpif;
 	int user_cpu_state_ctrl;
 	int user_sigp;
 	int user_stsi;
diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
index 0f184dbdbe5e0748fcecbca38b9e55a56968dc79..e4545d96e4bf67243583f184c2d4e734a9605007 100644
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -101,6 +101,7 @@ struct sclp_info {
 	unsigned char has_dirq : 1;
 	unsigned char has_iplcc : 1;
 	unsigned char has_zpci_lsi : 1;
+	unsigned char has_vsie_sigpif : 1;
 	unsigned char has_aisii : 1;
 	unsigned char has_aeni : 1;
 	unsigned char has_aisi : 1;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 984baa5f5ded1e05e389abc485c63c0bf35eee4c..ab672aa93f758711af4defb13875fd49a6609758 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3439,6 +3439,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm->arch.use_pfmfi = sclp.has_pfmfi;
 	kvm->arch.use_skf = sclp.has_skey;
+	kvm->arch.use_vsie_sigpif = sclp.has_vsie_sigpif;
 	spin_lock_init(&kvm->arch.start_stop_lock);
 	kvm_s390_vsie_init(kvm);
 	if (use_gisa)
diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index bd5e5ba50c0acaedce899702433a7f075dc56258..7211d85a8d4e9c97745fd13955c742407c0ab22f 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -57,6 +57,7 @@ static void __init sclp_early_facilities_detect(void)
 		sclp.has_diag318 = !!(sccb->byte_134 & 0x80);
 		sclp.has_diag320 = !!(sccb->byte_134 & 0x04);
 		sclp.has_iplcc = !!(sccb->byte_134 & 0x02);
+		sclp.has_vsie_sigpif = !!(sccb->byte_134 & 0x01);
 	}
 	if (sccb->cpuoff > 137) {
 		sclp.has_sipl = !!(sccb->cbl & 0x4000);

-- 
2.51.1


