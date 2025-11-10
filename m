Return-Path: <kvm+bounces-62539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB08C4843B
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC1F0188A3C2
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FE742BCF46;
	Mon, 10 Nov 2025 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kWlgHvKz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C99329BDA5;
	Mon, 10 Nov 2025 17:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795071; cv=none; b=edYf58ksxVqmTRrSxa/KSnX6cwa1GdIvPpjdI4WJmjZ6M29RTYxCsnrNApixubhDBP4XCrGwaUj07g1DUYGIVGESwOL4jD7nmNkikL5MwFoxH3yBngtdQmsV1RWarekeZ+UEI8nk2+01xApiOskjD2wAiSZAnyc3k5W1+HDd6pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795071; c=relaxed/simple;
	bh=OqkuoFkh+DNCH2GM1okMh1NF5heTrlG9iNrW/OksDos=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=e+9rpzv5X8LgrnjfF6A380fuFxpqjWwubyouuKPSjiOnYBTSwvupMT3WMD5tNSmQboT2zO0aqT9896rVV2B5y7wzdzaUt5HcDsliyOdDB2ioXVHLHCmUGCjMP3d/7v7zfzp/awckat8FBnb/SZ0qmCbdzxkWHZTbTlaw+ZUtHHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kWlgHvKz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA72sYx019908;
	Mon, 10 Nov 2025 17:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TgBKY9
	K7T968lCdvQSuZaYyiOMFoh8H9pHrSnNKhtXM=; b=kWlgHvKzQ+rofnsPdqJSMb
	zlCYuVkwoCcqrdpWE7qGl9C2pE9aDMS1F4WKdj/Mknp/vE6DLM+AVqaYsxfWgz1C
	hwTRtcKPhEtJ2+F54jBdxY9zG0iyJM3tXz3RKJokw/VFYPXMhCEemsi4ywL5OJNo
	hxBvo/sxj2IRLW5ckHHjHezmOhDykOzBz2/s1UZZbzgfhZDxfMYrBa/iJ3pNcFNS
	qJSvesVL/pfsgTVKoqy6WQv7yd6dZ4N2+FAJqWu4IT3KSWe7DIW32vWWZU56YiXA
	BQ0nmRBg9A32fUzAoPSxifkHrRLnTE4H1MQbDp2kNPWsXUb0UxierWyVL8aHFkiQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa3m7ym37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:43 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGeXjR028893;
	Mon, 10 Nov 2025 17:17:42 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aag6s6vua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHceP52036022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD98B20040;
	Mon, 10 Nov 2025 17:17:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52C162004B;
	Mon, 10 Nov 2025 17:17:38 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:38 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 10 Nov 2025 18:16:50 +0100
Subject: [PATCH RFC v2 10/11] KVM: s390: Add VSIE shadow configuration
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-vsieie-v2-10-9e53a3618c8c@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3166;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=OqkuoFkh+DNCH2GM1okMh1NF5heTrlG9iNrW/OksDos=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCcto8nCmHi9OOWDHH/TR+V5aryeJTt/ii8p/JpSo8R
 57Y8HR3lLIwiHExyIopslSLW+dV9bUunXPQ8hrMHFYmkCEMXJwCMJGniQz/03nl/73jj3qvoTJv
 8cKfQjf3SoapPnn9nNtl8sLXvQu3BTMy3Dv/4+TSvWvvPbyhfOGi7G8X4dPnYxVS/nokBs2Q8dT
 xZgUA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MtZfKmae c=1 sm=1 tr=0 ts=69121e37 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=wHsTlRLSA-Ik0HtLG-wA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: vFEQ9BAOUElw-GTqdxl5Ux1aFDLjaDGL
X-Proofpoint-ORIG-GUID: vFEQ9BAOUElw-GTqdxl5Ux1aFDLjaDGL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA3OSBTYWx0ZWRfX0lEljQu7Pwf5
 ZujQOyHJWx45gW6w6FDXbAqh2qAqFdC/m3Ewm2GM0/3jdgrw4lR1ors/g9LKH9GKh/J8nah/+8k
 O9fb7sa+CKkN9q1Bo16aNWsDG9SdJzBzc4vf+DR5Hxua5Uc6Bt7siX2o8PnmdU8ijrQ/wQ73cKn
 sl138y18qKiHBDHIbjRoyhx9a1+2kEKzzrtpj3UFwzYMXirVQKqraTmwwz0ewEvV7FTh5kc0aZe
 kbma1I2aaYobjhlWYbfRrOMYODys5SlPJxqBwSCloGRmJRfdPKLGbTCqTx8G+ixVnmlCzo/yK52
 y1mbkwYGMl5QLsWqnn4Qcw9mYuny1LZbvzqoMG2yowhxSfgWVcsPpErWmIp83lugDMKgL72VxyW
 PsRQI6g/WaenqgwBCKy9Mj3mzVKYZA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080079

Introduce two new module parameters allowing to keep more shadow
structures

* vsie_shadow_scb_max
  Override the maximum number of VSIE control blocks / vsie_pages to
  shadow in guest-1. KVM will use the maximum of the current number of
  vCPUs and a maximum of 256 or this value if it is lower.
  This is the number of guest-3 control blocks / CPUs to keep shadowed
  to minimize the repeated shadowing effort.

* vsie_shadow_sca_max
  Override the maximum number of VSIE system control areas to
  shadow in guest-1. KVM will use a minimum of the current number of
  vCPUs and a maximum of 256 or this value if it is lower.
  This is the number of guest-3 system control areas / VMs to keep
  shadowed to minimize repeated shadowing effort.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index b69ef763b55296875522f2e63169446b5e2d5053..cd114df5e119bd289d14037d1f1c5bfe148cf5c7 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -98,9 +98,19 @@ struct vsie_sca {
 	struct vsie_page	*pages[KVM_S390_MAX_VSIE_VCPUS];
 };
 
+/* maximum vsie shadow scb */
+unsigned int vsie_shadow_scb_max;
+module_param(vsie_shadow_scb_max, uint, 0644);
+MODULE_PARM_DESC(vsie_shadow_scb_max, "Maximum number of VSIE shadow control blocks to keep. Values smaller number vcpus uses number of vcpus; maximum 256");
+
+/* maximum vsie shadow sca */
+unsigned int vsie_shadow_sca_max;
+module_param(vsie_shadow_sca_max, uint, 0644);
+MODULE_PARM_DESC(vsie_shadow_sca_max, "Maximum number of VSIE shadow system control areas to keep. Values smaller number of vcpus uses number of vcpus; 0 to disable sca shadowing; maximum 256");
+
 static inline bool use_vsie_sigpif(struct kvm *kvm)
 {
-	return kvm->arch.use_vsie_sigpif;
+	return kvm->arch.use_vsie_sigpif && vsie_shadow_sca_max;
 }
 
 static inline bool use_vsie_sigpif_for(struct kvm *kvm, struct vsie_page *vsie_page)
@@ -907,7 +917,8 @@ static struct vsie_sca *get_vsie_sca(struct kvm_vcpu *vcpu, struct vsie_page *vs
 	 * We want at least #online_vcpus shadows, so every VCPU can execute the
 	 * VSIE in parallel. (Worst case all single core VMs.)
 	 */
-	max_sca = MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCPUS);
+	max_sca = MIN(MAX(atomic_read(&kvm->online_vcpus), vsie_shadow_sca_max),
+		      KVM_S390_MAX_VSIE_VCPUS);
 	if (kvm->arch.vsie.sca_count < max_sca) {
 		BUILD_BUG_ON(sizeof(struct vsie_sca) > PAGE_SIZE);
 		sca_new = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -1782,7 +1793,8 @@ static struct vsie_page *get_vsie_page(struct kvm_vcpu *vcpu, unsigned long addr
 		put_vsie_page(vsie_page);
 	}
 
-	max_vsie_page = MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCPUS);
+	max_vsie_page = MIN(MAX(atomic_read(&kvm->online_vcpus), vsie_shadow_scb_max),
+			    KVM_S390_MAX_VSIE_VCPUS);
 
 	/* allocate new vsie_page - we will likely need it */
 	if (addr || kvm->arch.vsie.page_count < max_vsie_page) {

-- 
2.51.1


