Return-Path: <kvm+bounces-20686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0488191C3CA
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 18:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE3722844D2
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 16:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5001C9EC5;
	Fri, 28 Jun 2024 16:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DjZZwSh2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D7227713;
	Fri, 28 Jun 2024 16:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719592559; cv=none; b=d4dSS7K9UWYOWocCNxpOScEkRZdeAL9tRY4Q3GMPoUvTyA7jigSoSzskNpEC0E1HoETTlek9uc6mhGLWZwS6Z876hp0p+ZxkX8cM7OZfGM8fRE+q2cPXfWVna9mrJd7RgJEWyTfsU9QBN5ccQu4XP3dcI2FlnH8RILfc6/CyW7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719592559; c=relaxed/simple;
	bh=GWQynfy+nKb6z46ePo9Kx4EYXNUd9zPCjd0pKZCEcCE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cDVS8LUdPMvJa2pZ3iu+0adGFdPGPtK1HvlWPsXgm1kEP7LW0lrlAybuMdjlItWM2MifxY8L7WfapP5T5gGYp1M7TQqpEwfTOmxXvYxRD9gZZVP6AwZbbCchxqb6hIMyYmReudsMjXqnKOe/pGT+rXtcwrnPY7wVwtzeLJZpvDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DjZZwSh2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SFT8ur001218;
	Fri, 28 Jun 2024 16:35:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=vskFbtLj82CA3Xm6IBQIVs7rFR
	qZI81nk1OwFoGmJLE=; b=DjZZwSh2jyzS1gtpT6cdVqSc1Ln5Gr0bm5eQm95dew
	DkY+jzqb6wv1jx9HpQxkdM35UrJWzB7PljK5pPMZT34cZSu4ARR98Gfp0umDMknk
	Zsq+E0faq4vSnfYG7Nfq46v2giczSqa0QLmnw2eB+57tkd7vuwP4s0GWXwuaYxzL
	5Lrl4sn2E9HXP0HU6M50aPDti/7qJvbQx0kzd8Y2Qh6gqKHDn2MTzEZDkaw4lT01
	rDWw/fZU7vQkW2DeePh4fk4qw6gN4NQW7Ufz1BQZp0IocGH+g1H5Q60zFisVXN/z
	cJs+4Eo1TVVL6Qo2D/rSPKVkETm/PXGTZRtG51VLbs9g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401yuhg5yf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 16:35:55 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45SGZtsT011337;
	Fri, 28 Jun 2024 16:35:55 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401yuhg5ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 16:35:55 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45SG0Xlk008172;
	Fri, 28 Jun 2024 16:35:54 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yx9b19h1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 16:35:54 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45SGZlEj59048222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 16:35:50 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D49F02004E;
	Fri, 28 Jun 2024 16:35:47 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 930752004B;
	Fri, 28 Jun 2024 16:35:47 +0000 (GMT)
Received: from b35lp69.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 28 Jun 2024 16:35:47 +0000 (GMT)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: KVM <kvm@vger.kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH v2] KVM: s390: fix LPSWEY handling
Date: Fri, 28 Jun 2024 18:35:47 +0200
Message-ID: <20240628163547.2314-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5m6A08zPwiI-sDc7gUZtk1dgIfI7DFAL
X-Proofpoint-GUID: NzyzyrKF1_bEfXA3EGna9a3jvzA6XvOG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_12,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=957 phishscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406280121

in rare cases, e.g. for injecting a machine check we do intercept all
load PSW instructions via ICTL_LPSW. With facility 193 a new variant
LPSWEY was added. KVM needs to handle that as well.

Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/kvm-s390.c         |  1 +
 arch/s390/kvm/kvm-s390.h         | 15 +++++++++++++++
 arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 95990461888f..9281063636a7 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -427,6 +427,7 @@ struct kvm_vcpu_stat {
 	u64 instruction_io_other;
 	u64 instruction_lpsw;
 	u64 instruction_lpswe;
+	u64 instruction_lpswey;
 	u64 instruction_pfmf;
 	u64 instruction_ptff;
 	u64 instruction_sck;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 50b77b759042..8e04c7f0c90c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -132,6 +132,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, instruction_io_other),
 	STATS_DESC_COUNTER(VCPU, instruction_lpsw),
 	STATS_DESC_COUNTER(VCPU, instruction_lpswe),
+	STATS_DESC_COUNTER(VCPU, instruction_lpswey),
 	STATS_DESC_COUNTER(VCPU, instruction_pfmf),
 	STATS_DESC_COUNTER(VCPU, instruction_ptff),
 	STATS_DESC_COUNTER(VCPU, instruction_sck),
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 111eb5c74784..1b326f3c3383 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -138,6 +138,21 @@ static inline u64 kvm_s390_get_base_disp_s(struct kvm_vcpu *vcpu, u8 *ar)
 	return (base2 ? vcpu->run->s.regs.gprs[base2] : 0) + disp2;
 }
 
+static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
+{
+	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
+	s64 disp1;
+       
+	/* The displacement is a 20bit _SIGNED_ value */
+	disp1 = sign_extend64(((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
+			      ((vcpu->arch.sie_block->ipb & 0xff00) << 4), 19);
+
+	if (ar)
+		*ar = base1;
+
+	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + disp1;
+}
+
 static inline void kvm_s390_get_base_disp_sse(struct kvm_vcpu *vcpu,
 					      u64 *address1, u64 *address2,
 					      u8 *ar_b1, u8 *ar_b2)
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 1be19cc9d73c..1a49b89706f8 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -797,6 +797,36 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int handle_lpswey(struct kvm_vcpu *vcpu)
+{
+	psw_t new_psw;
+	u64 addr;
+	int rc;
+	u8 ar;
+
+	vcpu->stat.instruction_lpswey++;
+
+	if (!test_kvm_facility(vcpu->kvm, 193))
+		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
+
+	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
+		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
+
+	addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
+	if (addr & 7)
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+
+	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
+	if (rc)
+		return kvm_s390_inject_prog_cond(vcpu, rc);
+
+	vcpu->arch.sie_block->gpsw = new_psw;
+	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+
+	return 0;
+}
+
 static int handle_stidp(struct kvm_vcpu *vcpu)
 {
 	u64 stidp_data = vcpu->kvm->arch.model.cpuid;
@@ -1462,6 +1492,8 @@ int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
 	case 0x61:
 	case 0x62:
 		return handle_ri(vcpu);
+	case 0x71:
+		return handle_lpswey(vcpu);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.45.0


