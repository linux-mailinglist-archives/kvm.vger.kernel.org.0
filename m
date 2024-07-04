Return-Path: <kvm+bounces-20945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67AD39271F1
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 10:43:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8E4E1F225CE
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 08:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610271A4F2F;
	Thu,  4 Jul 2024 08:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cCkThyG9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA371A4F01;
	Thu,  4 Jul 2024 08:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720082577; cv=none; b=d+ijgNvQ2tlVtVTxUZp1k//BpnuVATduB6bpgpsOxMVBbjgQnkbXPu3nnqLw4hL4G+QnFBzNTpAWFFv4zUuN90PzR1KKYEYQA8MX5uoV1OeoQ8InSGLNvhnChoPR5ETr/y/mc6NUQZ4VGZOxvtrIGoFIaH569bCFazEWvW1UWp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720082577; c=relaxed/simple;
	bh=4aqYJPgsVKjY1mrgWBw4l1BqP2ZwfWWf9JV+R1EK1TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksKoluHE/wzTRzS5GzPF/mnCRh/yMynTQGpYOExJFEwtEOio2HG0XH8pjeRnaV76dGcYkWpxbFsX3B+LWaWjMEPPp3izfx56AgjlTh3Qd0S6QDXOyj9KqKQc43tJnKYxxXcgWDkWFyjr9ERS5xWguyJjuD9QQd4oYHAKMT1IpTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cCkThyG9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4648Madn022445;
	Thu, 4 Jul 2024 08:42:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=PbWRneBDuRWcC
	gxuX3ia8BuTQnPASuF4A2nLvp3NVIY=; b=cCkThyG90M4qz83eygsDPMs3eVoaF
	TCn806Be168eg6TcscQefqCEH9UNkH1gGn6HffRgeQT6kTN+kOb/hyLf5+aUkPCJ
	BnpeOhFPRGrYsVCUAJ/4MgLuDi+hpV1vllw/UtfOxNZ+xgLeHlaom2pM91fR0Ve+
	PShHU4JWfyoDsChqpuZ8jp4KKX6RU1dIum5N6RQT2oFwY5jGswXTaRedcbQMOGRd
	qjFBjbSN1yswBchASN5EkLDkk5+84vXKGJ1g+/NZuAljGlT0PvvxwGSlu0YCUbt9
	jDrQNSHkhD3UaLmP3cC39LnCa7/1OYGzTZ9kWgmthLbnye16cuFalLCHQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 405pxfr9ak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Jul 2024 08:42:53 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4648gqu6020099;
	Thu, 4 Jul 2024 08:42:53 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 405pxfr9ah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Jul 2024 08:42:52 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4647oFhx030030;
	Thu, 4 Jul 2024 08:42:52 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402x3n74qd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Jul 2024 08:42:52 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4648gkdT56099090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 4 Jul 2024 08:42:48 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 780062004B;
	Thu,  4 Jul 2024 08:42:46 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 414B020063;
	Thu,  4 Jul 2024 08:42:46 +0000 (GMT)
Received: from m83lp52.lnxne.boe (unknown [9.152.108.100])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  4 Jul 2024 08:42:46 +0000 (GMT)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Sven Schnelle <svens@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [GIT PULL 1/1] KVM: s390: fix LPSWEY handling
Date: Thu,  4 Jul 2024 10:42:45 +0200
Message-ID: <20240704084245.13539-2-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240704084245.13539-1-borntraeger@linux.ibm.com>
References: <20240704084245.13539-1-borntraeger@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OUWiDBXwk6VQYIpb_L9-dGK4MGiXHQ4A
X-Proofpoint-ORIG-GUID: 2fHruIM6Zq_J7EHX_0ISLQoHsLY7XYLn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_18,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407040058

in rare cases, e.g. for injecting a machine check we do intercept all
load PSW instructions via ICTL_LPSW. With facility 193 a new variant
LPSWEY was added. KVM needs to handle that as well.

Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Message-ID: <20240628163547.2314-1-borntraeger@linux.ibm.com>
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
index 82e9631cd9ef..54b5b2565df8 100644
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
index 111eb5c74784..bf8534218af3 100644
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


