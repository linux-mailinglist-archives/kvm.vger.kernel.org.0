Return-Path: <kvm+bounces-66488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F72CCD6CFF
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1E0D30823D5
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1899833ADAC;
	Mon, 22 Dec 2025 16:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pgLF84UF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B286338595;
	Mon, 22 Dec 2025 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422253; cv=none; b=fSDFe5Z/aHejfRQ+n5VbwgcG+GL7jA9KOuJFt145iAGT08jQPstl1v3rGHhmTWtnYn41T6naH6uafv3mXUAy+/mU9K75j0aM5ovjojTBIqNQFCbYw4XxKP73vK8eXUMlRsCWjQu4Tws2siun+U0SVp0Pj5T2fQeSQjQLSfpbbu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422253; c=relaxed/simple;
	bh=2G/RNx8tFc20K9NAY2KiZ4CkWJ7nDB/pbKmFm1hV4Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIWIyxki7MuayqnHvG0DYGieYDJ2aGx1329NprfdBWrHT2w0aFoZWEIpT2nFKIREzhr+l6LEY1RbBvh+GojNfnmAawysfbksQcXActB955x0Qyk/8KMdSXqj0QqaDhcpsGAbhuFmdIuDYgSNVlEBJlpkdpQsF6h9mfWvooidsRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pgLF84UF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMDi0Lo002084;
	Mon, 22 Dec 2025 16:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9qirMlnR08lnLuOsu
	ocG1SXixr7jpbIgJF3CIcBfEdM=; b=pgLF84UFm2f5fCpeUZ8qddNaS9qTPwF73
	2PTnrPZ3DFJmOzY6dVXKR9ZuyYSTULBea2vH8k236NnNTW2KViIFunt3HosfbpCl
	y+stVaJ3WPM352uQiiIhz/w3KFilNfwSJwMUn0+6Y68lkRnyaYMa8slmj10wdolk
	AB30pQzBQybmvhKBZ7GtOvqV3J8bRabpFyIA+LkpSwebfX2vpOkoao1M1FVC7ccN
	Shmh8J4n+VXKczyH8I+UBjUoba7kMADhqfwcA7M92i6OVI0SU1fT0Mmdc6s4gk7n
	uxPf2rRyvwwh3gFm00+3LS6QpLUllH+FV6KYkHgYoMW9yShsc/pUQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5j7e10yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BME83G7032274;
	Mon, 22 Dec 2025 16:50:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b68u0xva7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:47 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGohQC29098362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:43 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EFD42004F;
	Mon, 22 Dec 2025 16:50:43 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6C2C20040;
	Mon, 22 Dec 2025 16:50:41 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:41 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 06/28] KVM: s390: Introduce import_lock
Date: Mon, 22 Dec 2025 17:50:11 +0100
Message-ID: <20251222165033.162329-7-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=G8YR0tk5 c=1 sm=1 tr=0 ts=694976e7 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=ukBcN2NOhkw1kEjOR7IA:9
X-Proofpoint-ORIG-GUID: tawjs8rIpNfPuimSNT2LbofBU_SmuI3P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX09KcxDK/nkMm
 3OFlZKvHdNT3IwBpi6AA6L/sZLinO+CVksxRjH4gXZo2AtkOwgIqW0ageyj4PqIDSVgOtqG9oc+
 1oiZWQSPol/ZMzzpv4AJtBhan0rYoGYZXH5IVdk1mqvGjchAH4Z5ZQeYFAL0vHMPAvvkFjpGV5q
 LFVoh4gW9zKN5BEXP1msSi5OHGtTZSmQkbpK1aHpimGS3jD9Cv2KCoOiR9xZyhOWfzphsO0+w0p
 mdOmZIY7uOwLVxquVVlJRUc+cCCLlRN16Q4Zc0vTKNDtWsBr3HIPRa8acbmLzN6L6vjahO4ABWz
 l1KTIi3T56nx119DPNadPcxiK8uTTyUKUCpE5Va3TVLQgyATRuGEJRTtEe/GeAAnr2+Am5jc2QZ
 NdMKMoWwy7HdiU7+xlaJvi3dJjqwyTZhFBQu0gaUksC8XTh/V4VNK9ifEi+/+9MTqVVVqFr0+5Z
 62vEx82q0YsH3MJkivg==
X-Proofpoint-GUID: tawjs8rIpNfPuimSNT2LbofBU_SmuI3P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

Introduce import_lock to avoid future races when converting pages to
secure.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 2 ++
 arch/s390/kvm/kvm-s390.c         | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index ae1223264d3c..3dbddb7c60a9 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -630,6 +630,8 @@ struct kvm_s390_pv {
 	void *set_aside;
 	struct list_head need_cleanup;
 	struct mmu_notifier mmu_notifier;
+	/* Protects against concurrent import-like operations */
+	struct mutex import_lock;
 };
 
 struct kvm_arch {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 56a50524b3ee..cd39b2f099ca 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3330,6 +3330,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	char debug_name[16];
 	int i, rc;
 
+	mutex_init(&kvm->arch.pv.import_lock);
+
 	rc = -EINVAL;
 #ifdef CONFIG_KVM_S390_UCONTROL
 	if (type & ~KVM_VM_S390_UCONTROL)
-- 
2.52.0


