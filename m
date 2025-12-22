Return-Path: <kvm+bounces-66486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A0B5CD6BCD
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C2AF93004EEB
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E16533859B;
	Mon, 22 Dec 2025 16:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Um0kXMy0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36798332901;
	Mon, 22 Dec 2025 16:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422250; cv=none; b=PEzxlePAQ6f/UK8fpOdHC7injeNDWZ/P3g5gnYPSYxDlKECadPhuTlkQDx5tExf3EYqN2FXKKfXRiNpAdMP8smkHV1xN8TMjfOpAtzusb4Ol3hw9BRue4YPUM2xHJnhcRSSY3qYl1UPrK4eKqKT6Uwq4e42m/ogWt2gbIIyUUAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422250; c=relaxed/simple;
	bh=ppddRHBjjzuGKYC56DMR9Y/6uMZxA+vA361WbAMUQjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2+DyfOAJ3SCX76XKMeDDzBXuy9y+WyWoAgWCqa3UiX9MdZpcCaNUPMMdYIH3NwtkTuzQVTmah5rlc7OWgEpoT7s+JcWrS72OPjEfpkLpA4HdqvodMPqIfsLFOJCfmO0+NlB8KpNe0l5u2f3DhvEuBsulFFJu/s9uqRyHkVJBbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Um0kXMy0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMBIMPN020242;
	Mon, 22 Dec 2025 16:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=53+6YA0gHtcxVllIt
	onUc6YdfZpmIkiOnoO0JHtuaEQ=; b=Um0kXMy0mPe8r7w5xJhJg6Os7gccTYZou
	uzScTxf6aUAILTSFI20JK3d8WMBmAXxPkcbBj1EGun/w8gokO6NzweE3t8/8ORro
	K8czLEdlIGYXub8ttvzidJx97WlP74N+WdL30ipWrih1ZMACXX0uKzMIMVGlLw6W
	APRIrluPk/v2j0bMqpc5g0R616yZcI6l5gBS4irANNNo+gvrIthPYKyC8AElycl/
	UKGejutgBZ5weNknb52ywbWWatzC2BpFcLHfrBl3/z89/yjrFnltAzkPhTKOjsZc
	KccQwfmw3ZT6s1PGWnSu4lEn5RpiJVMdF7sXRiSjXUPAbtjq0SLOw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5ka399et-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:45 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMDcXZ5005286;
	Mon, 22 Dec 2025 16:50:44 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b67mjy3hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGoeQr14680506
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 09FBB20043;
	Mon, 22 Dec 2025 16:50:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E412B20040;
	Mon, 22 Dec 2025 16:50:38 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:38 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 04/28] s390: Move sske_frame() to a header
Date: Mon, 22 Dec 2025 17:50:09 +0100
Message-ID: <20251222165033.162329-5-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: x55RDZf1V80rFGrcYKmP14sIwLW_VqTt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX6vJY0XcYlMtl
 kcZQA6rfsCXiQS9lKvMBAfg29yrrBlIZ/Z8nELqyvWG7PxQ6qfXzDBcvZdGcx6yYh+tdDAK390I
 sqQMYKB5r2t8QQZi/VWLK78TDpQtvTC8Nv1lelCiI0AilQfqLVjOewieOIXw9ehOhxK2Oi2JeCg
 SgvFhTVkX2B/zNrELTX7gojCl5CabJr1t94YJyIU7Yiv8v+QaYL8sFQXGz4TwW2zCA+ZG/+Nhgu
 lMRJ5kIo+7baNYyJQa1rsIRYIrafC3m692jI27nu9PdkZELJcCZtFcFx6v0NiUMLqgLrLaD4c1K
 fHS1yI2/Jy18TBrrRisEevQzdoWR8s5+LQ9LhrhLBileYl4vUdfwzilo1PE0zpMgsq8LwuYn37e
 9A2PlNieRKV/3sHz2b4+62MWjtoX5qzz1h60MW2PwUy7gkhLgsAuqGnBN0PYaXFgoJBLsAmKHWx
 tuyKbxfRpr9SdB1ORBQ==
X-Proofpoint-ORIG-GUID: x55RDZf1V80rFGrcYKmP14sIwLW_VqTt
X-Authority-Analysis: v=2.4 cv=dqHWylg4 c=1 sm=1 tr=0 ts=694976e5 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=cwyL-bC_1qH1TysSW8cA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2512220154

Move the sske_frame() function to asm/pgtable.h, so it can be used in
other modules too.

Opportunistically convert the .insn opcode specification to the
appropriate mnemonic.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 7 +++++++
 arch/s390/mm/pageattr.c         | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 8194a2b12ecf..73c30b811b98 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1136,6 +1136,13 @@ static inline pte_t pte_mkhuge(pte_t pte)
 }
 #endif
 
+static inline unsigned long sske_frame(unsigned long addr, unsigned char skey)
+{
+	asm volatile("sske %[skey],%[addr],1"
+		     : [addr] "+a" (addr) : [skey] "d" (skey));
+	return addr;
+}
+
 #define IPTE_GLOBAL	0
 #define	IPTE_LOCAL	1
 
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index d3ce04a4b248..bb29c38ae624 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -16,13 +16,6 @@
 #include <asm/asm.h>
 #include <asm/set_memory.h>
 
-static inline unsigned long sske_frame(unsigned long addr, unsigned char skey)
-{
-	asm volatile(".insn rrf,0xb22b0000,%[skey],%[addr],1,0"
-		     : [addr] "+a" (addr) : [skey] "d" (skey));
-	return addr;
-}
-
 void __storage_key_init_range(unsigned long start, unsigned long end)
 {
 	unsigned long boundary, size;
-- 
2.52.0


