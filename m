Return-Path: <kvm+bounces-62532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5F8C484A7
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 037D04F2768
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F8B2367CE;
	Mon, 10 Nov 2025 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jHBx99Bj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEA021CFF7;
	Mon, 10 Nov 2025 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795065; cv=none; b=np/M+ZNbtkeUBEoZcxp6twur2uyvcuJYJQLK/TMCVQTAbBzmtFI/zBIF6bQtNPU/bYg+bB27x3HswnV2VNP/VzY4suRtIM7Dds8rIhS0ifEMdbXTIZFvi6dubGEJvDkIPeNHurVE7i0/t0+Ft2Aq6l7Z1mZwg5dWzCvH/6rjPVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795065; c=relaxed/simple;
	bh=Lt9GsDJsRrVGBzugmWTBIS/5JzEVPpcw9QlURBo3Jew=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VLbY4uXbBo0lgoF1N5s6yYYJf0FGsfyw2hMm/Fk6EkKxWXxCUmqykxerhCsyBqXewGw4BVDFImAaDAWyEA7zbBIgNcQcws+2R/kaKOGjV8vDUnL0nDMYGUKpra6nB3+JStoQDRVJxVbNlODJZnktcvD+z7qQNGf7YvI4SX5OE5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jHBx99Bj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAEMDE1031978;
	Mon, 10 Nov 2025 17:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=dq3LGK
	7iHU5adWrXO1bFN9eQS99r+mrago9aBWqwqlM=; b=jHBx99BjEuFTfdOovdMQCt
	f8SqiEhWjmX8jEkCPm6VBum731tNmfRDCxXxnkbv4NYhCcoRcNYjcrOipuQ2VDTy
	8z/taI2KCfYocpndbtKTZP27vg+VIEnW7ItjDWkUvCHx5a1VrQ1f52O/D3328jpe
	8bgZ1tFjHYBWXSdQumzXus0suDxAIKt+pku8HXn7DSPnFEobMqr55Rc14rA34AJl
	WaPLVtqsaTo0x/npV5oVJ7t384MDD+hya4j/XutGkOFtUeeBP9U6g7EmwoOFz6x0
	kHFRD1Nb36pJvTzcFkKAMy3bEuA0Fi820UqdXAb/itpZa67z5wyoM57MGRZF6sWQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa3m7ym2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:39 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGWB3c014773;
	Mon, 10 Nov 2025 17:17:38 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aahpjxpnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHYBb46399980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A9C220040;
	Mon, 10 Nov 2025 17:17:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD6922004B;
	Mon, 10 Nov 2025 17:17:33 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:33 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 10 Nov 2025 18:16:43 +0100
Subject: [PATCH RFC v2 03/11] KVM: s390: Move scao validation into a
 function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-vsieie-v2-3-9e53a3618c8c@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1897;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=Lt9GsDJsRrVGBzugmWTBIS/5JzEVPpcw9QlURBo3Jew=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCctqFRXxbbKb3Mt/PzNk0jfHdzRr2O51Kp96p3Wi4N
 +3vhy8VHaUsDGJcDLJiiizV4tZ5VX2tS+cctLwGM4eVCWQIAxenAEzkxwlGhh9Mbw+VWU6f88pl
 ttUe7VWbZ1moMhzruep/f0527dbJkx8z/K8y/ijLGvZGZrnB9Vchsg+TCu6ZPl/eK6Bw4+DRvEy
 9OSwA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MtZfKmae c=1 sm=1 tr=0 ts=69121e33 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=mLffYC6w_0g0fPzL8WAA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: 7G5f_1YMXMe43lGDupgjpw72lJFTzJiU
X-Proofpoint-ORIG-GUID: 7G5f_1YMXMe43lGDupgjpw72lJFTzJiU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA3OSBTYWx0ZWRfXzbADGOXw1u5w
 z09Zi1Hy+7g/bvL3ObaHBAyh3E3X7nURMe2a7eaTlAIbvugwH1MqCbs8b2vLVJlR5vlMmrW2Qyn
 BNydlLb/Qdwo2NuMc8ProbxjsgWRbXWJJwmzHNz3CNGT0qmR0V2bZ3YinAvP4l1U6ycJxDGE0Ta
 LEvhNam9p1b/q+fThuDuxy86dwcEb4e9pd7/zdokpp+ULbNAR8J/4fdDQEoRxAdwx4/8P13nS/L
 LWOkRjeDwf57qI7cLeIPOKszdc49Xrdoapg8zx8Gnflq117PDl/9azh1p9+ywf9895VrFALQnqa
 VxxfJMqVSs4mI4scDAauekzRBeG0fEU4kJHEiH0cN0w640OIpSXq7xrmKBl99fKRUVOk+P9CZxN
 9FycF/U8HCCQ3e+qUKYRL/6x31rMoA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080079

This improves readability as well as allows re-use in coming patches.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index ced2ca4ce5b584403d900ed11cb064919feda8e9..3d602bbd1f70b7bd8ddc2c54d43027dc37a6e032 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -95,6 +95,25 @@ static int set_validity_icpt(struct kvm_s390_sie_block *scb,
 	return 1;
 }
 
+/* The sca header must not cross pages etc. */
+static int validate_scao(struct kvm_vcpu *vcpu, struct kvm_s390_sie_block *scb, gpa_t gpa)
+{
+	int offset;
+
+	if (gpa < 2 * PAGE_SIZE)
+		return set_validity_icpt(scb, 0x0038U);
+	if ((gpa & ~0x1fffUL) == kvm_s390_get_prefix(vcpu))
+		return set_validity_icpt(scb, 0x0011U);
+
+	if (sie_uses_esca(scb))
+		offset = offsetof(struct esca_block, cpu[0]) - 1;
+	else
+		offset = offsetof(struct bsca_block, cpu[0]) - 1;
+	if ((gpa & PAGE_MASK) != ((gpa + offset) & PAGE_MASK))
+		return set_validity_icpt(scb, 0x003bU);
+	return false;
+}
+
 /* mark the prefix as unmapped, this will block the VSIE */
 static void prefix_unmapped(struct vsie_page *vsie_page)
 {
@@ -791,13 +810,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 
 	gpa = read_scao(vcpu->kvm, scb_o);
 	if (gpa) {
-		if (gpa < 2 * PAGE_SIZE)
-			rc = set_validity_icpt(scb_s, 0x0038U);
-		else if ((gpa & ~0x1fffUL) == kvm_s390_get_prefix(vcpu))
-			rc = set_validity_icpt(scb_s, 0x0011U);
-		else if ((gpa & PAGE_MASK) !=
-			 ((gpa + sizeof(struct bsca_block) - 1) & PAGE_MASK))
-			rc = set_validity_icpt(scb_s, 0x003bU);
+		rc = validate_scao(vcpu, scb_o, gpa);
 		if (!rc) {
 			rc = pin_guest_page(vcpu->kvm, gpa, &hpa);
 			if (rc)

-- 
2.51.1


