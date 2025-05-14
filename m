Return-Path: <kvm+bounces-46523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4619CAB71B8
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76BDB4A0013
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0247328314C;
	Wed, 14 May 2025 16:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n09S+Wbh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B15027B506;
	Wed, 14 May 2025 16:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747240747; cv=none; b=hHJtMsKzO5Rpuyf+iGUiAzPSJBhbd5T+scNWTl1UM0nj5w74qVQuafSV98R+ukIe6QYuCt5nGGws+uOTlh8esRwUHeTJQVPjphIhZWVCnqz95zisu1gS0r9hkCihWRHr5XiE0d1f3Vhv+kLut0L8sGVgTW/sTrDerC4VaozxDTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747240747; c=relaxed/simple;
	bh=iHZvcX63K1uEZ12At1/792SaV5OrCUKqkUJCTIspoKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz7r5I9yXJzwwVtcA0z8kcnV6pEBAucau/jydtVN1HSUD6K+1cPuLUW4EY4UPh/AZYjWnPby+855WIpOZNQwrxJpLy120+SfD5Yk47NSn8H5x+ZGemJoeHjSbbFmMs0DgwNRqfBDEL+aNJABD7Hf/8JFI8I8zuh7N0BIH6V07ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n09S+Wbh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E7YbBC025522;
	Wed, 14 May 2025 16:39:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zm0nO3kZha1Icct/b
	LZBBxBIDj2brp4fW2Jn6nUlIY8=; b=n09S+Wbhn2aSTu4dy3vdamwv2E2nLSqyW
	915E9E7aa8eQhrGjYJTZqhLV6CFlGAhFJHeZgijqW8bJIV5+Zf6GhRGMiXRXrnk7
	uMf0vRDSZYJi9Z9G60o4zkcW4/PqZ8/qPezPpxbJW/P9h4j3OGZooRBYZZukUwYG
	ptqeRvavJ/bm/n600GKc9noEejhizsUh1dIuzqPi/qr8YcVZN+6Kf+u80i6V6fk8
	nTb+EpAV2MwbA52XfEmqWKHxvvC0s45MJr0TYJdFpYTpYo9frE8BrE2u+3/Q7pE+
	ap4KKx3j7B0beIo9SJJKV1+keSaf6rjGhuJ9VKdtTRXvMn8gT4LKw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mbs6nf0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:39:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EGY7jK021408;
	Wed, 14 May 2025 16:39:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfrn9br-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:39:01 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EGcv1L30999150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:38:58 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB43F2004E;
	Wed, 14 May 2025 16:38:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5CF3E2004B;
	Wed, 14 May 2025 16:38:57 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 16:38:57 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com
Subject: [PATCH v1 3/5] KVM: s390: refactor some functions in priv.c
Date: Wed, 14 May 2025 18:38:53 +0200
Message-ID: <20250514163855.124471-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250514163855.124471-1-imbrenda@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDE0OSBTYWx0ZWRfX+usHbN7QpQy7 1gfway2hmgHv8dBqBHkKkod9eivL1oVfVxbOU6Ol+tkqtkjDT2yV6PusGjVhOqFK9toj04W9Uz9 e+IyTZHj8ywL98gLbEngk0NDEb1PRG1NREelybsAno1pok07u76mtqjata9wopxWpj+LGtPZ9Nx
 DgykvnqAkDKH9cGnBEhFMyMSahjp6QIN6QR7Ta65Mpbi4GQ9CIGrszLOPeYn6WBT8thtJ9Yr8ss XK09xADuuSLM5SXmKjVLZCRf3AQC/2PI8TfftphuFsAZbwVcaoxCfL2Z0vhqDmzql2CdJ23u1Pf //xH01SKaupoQ42nudvXVca+kzDHOjVW6ENhUdQJaVe2o0jnj+5wWmbGOAxGG2if8u1l4KxDyp7
 1HBxOKzXBRr9Ah2QsthMG6+HZ+WYaQZhgMVJD3UpopR9loZQcXM1rAWNiO+FYE69Q1O0f5+u
X-Proofpoint-ORIG-GUID: ttaAWLonSLBfyl3F1sudZ39_5rdcXbOK
X-Authority-Analysis: v=2.4 cv=d5f1yQjE c=1 sm=1 tr=0 ts=6824c726 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=ilECb7VF1RFgedB8ViUA:9
X-Proofpoint-GUID: ttaAWLonSLBfyl3F1sudZ39_5rdcXbOK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=712 impostorscore=0 adultscore=0 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140149

Refactor some functions in priv.c to make them more readable.

handle_{iske,rrbe,sske}: move duplicated checks into a single function.
handle{pfmf,epsw}: improve readability.
handle_lpswe{,y}: merge implementations since they are almost the same.

Use u64_replace_bits() where it makes sense.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.h |  15 ++
 arch/s390/kvm/priv.c     | 288 ++++++++++++++++++---------------------
 2 files changed, 148 insertions(+), 155 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 8d3bbb2dd8d2..f8c32527c4e4 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -22,6 +22,21 @@
 
 #define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
 
+static inline bool kvm_s390_is_amode_24(struct kvm_vcpu *vcpu)
+{
+	return psw_bits(vcpu->arch.sie_block->gpsw).eaba == PSW_BITS_AMODE_24BIT;
+}
+
+static inline bool kvm_s390_is_amode_31(struct kvm_vcpu *vcpu)
+{
+	return psw_bits(vcpu->arch.sie_block->gpsw).eaba == PSW_BITS_AMODE_31BIT;
+}
+
+static inline bool kvm_s390_is_amode_64(struct kvm_vcpu *vcpu)
+{
+	return psw_bits(vcpu->arch.sie_block->gpsw).eaba == PSW_BITS_AMODE_64BIT;
+}
+
 static inline void kvm_s390_fpu_store(struct kvm_run *run)
 {
 	fpu_stfpc(&run->s.regs.fpc);
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 758cefb5bac7..1a26aa591c2e 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -14,6 +14,7 @@
 #include <linux/mm_types.h>
 #include <linux/pgtable.h>
 #include <linux/io.h>
+#include <linux/bitfield.h>
 #include <asm/asm-offsets.h>
 #include <asm/facility.h>
 #include <asm/current.h>
@@ -253,29 +254,50 @@ static int try_handle_skey(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+struct skeys_ops_state {
+	int reg1;
+	int reg2;
+	int rc;
+	unsigned long gaddr;
+};
+
+static bool skeys_common_checks(struct kvm_vcpu *vcpu, struct skeys_ops_state *state, bool abs)
+{
+	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE) {
+		state->rc = kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
+		return true;
+	}
+
+	state->rc = try_handle_skey(vcpu);
+	if (state->rc)
+		return true;
+
+	kvm_s390_get_regs_rre(vcpu, &state->reg1, &state->reg2);
+
+	state->gaddr = vcpu->run->s.regs.gprs[state->reg2] & PAGE_MASK;
+	state->gaddr = kvm_s390_logical_to_effective(vcpu, state->gaddr);
+	if (!abs)
+		state->gaddr = kvm_s390_real_to_abs(vcpu, state->gaddr);
+
+	return false;
+}
+
 static int handle_iske(struct kvm_vcpu *vcpu)
 {
-	unsigned long gaddr, vmaddr;
+	struct skeys_ops_state state;
+	unsigned long vmaddr;
 	unsigned char key;
-	int reg1, reg2;
 	bool unlocked;
+	u64 *r1;
 	int rc;
 
 	vcpu->stat.instruction_iske++;
 
-	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
-		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
-
-	rc = try_handle_skey(vcpu);
-	if (rc)
-		return rc != -EAGAIN ? rc : 0;
-
-	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
+	if (skeys_common_checks(vcpu, &state, false))
+		return state.rc;
+	r1 = vcpu->run->s.regs.gprs + state.reg1;
 
-	gaddr = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
-	gaddr = kvm_s390_logical_to_effective(vcpu, gaddr);
-	gaddr = kvm_s390_real_to_abs(vcpu, gaddr);
-	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
+	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(state.gaddr));
 	if (kvm_is_error_hva(vmaddr))
 		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 retry:
@@ -296,33 +318,23 @@ static int handle_iske(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 	if (rc < 0)
 		return rc;
-	vcpu->run->s.regs.gprs[reg1] &= ~0xff;
-	vcpu->run->s.regs.gprs[reg1] |= key;
+	*r1 = u64_replace_bits(*r1, key, 0xff);
 	return 0;
 }
 
 static int handle_rrbe(struct kvm_vcpu *vcpu)
 {
-	unsigned long vmaddr, gaddr;
-	int reg1, reg2;
+	struct skeys_ops_state state;
+	unsigned long vmaddr;
 	bool unlocked;
 	int rc;
 
 	vcpu->stat.instruction_rrbe++;
 
-	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
-		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
-
-	rc = try_handle_skey(vcpu);
-	if (rc)
-		return rc != -EAGAIN ? rc : 0;
-
-	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
+	if (skeys_common_checks(vcpu, &state, false))
+		return state.rc;
 
-	gaddr = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
-	gaddr = kvm_s390_logical_to_effective(vcpu, gaddr);
-	gaddr = kvm_s390_real_to_abs(vcpu, gaddr);
-	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
+	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(state.gaddr));
 	if (kvm_is_error_hva(vmaddr))
 		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 retry:
@@ -353,40 +365,30 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
 static int handle_sske(struct kvm_vcpu *vcpu)
 {
 	unsigned char m3 = vcpu->arch.sie_block->ipb >> 28;
+	struct skeys_ops_state state;
 	unsigned long start, end;
 	unsigned char key, oldkey;
-	int reg1, reg2;
+	bool nq, mr, mc, mb;
 	bool unlocked;
+	u64 *r1, *r2;
 	int rc;
 
 	vcpu->stat.instruction_sske++;
 
-	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
-		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
-
-	rc = try_handle_skey(vcpu);
-	if (rc)
-		return rc != -EAGAIN ? rc : 0;
-
-	if (!test_kvm_facility(vcpu->kvm, 8))
-		m3 &= ~SSKE_MB;
-	if (!test_kvm_facility(vcpu->kvm, 10))
-		m3 &= ~(SSKE_MC | SSKE_MR);
-	if (!test_kvm_facility(vcpu->kvm, 14))
-		m3 &= ~SSKE_NQ;
+	mb = test_kvm_facility(vcpu->kvm, 8) && (m3 & SSKE_MB);
+	mr = test_kvm_facility(vcpu->kvm, 10) && (m3 & SSKE_MR);
+	mc = test_kvm_facility(vcpu->kvm, 10) && (m3 & SSKE_MC);
+	nq = test_kvm_facility(vcpu->kvm, 14) && (m3 & SSKE_NQ);
 
-	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
+	/* start already designates an absolute address if MB is set */
+	if (skeys_common_checks(vcpu, &state, mb))
+		return state.rc;
 
-	key = vcpu->run->s.regs.gprs[reg1] & 0xfe;
-	start = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
-	start = kvm_s390_logical_to_effective(vcpu, start);
-	if (m3 & SSKE_MB) {
-		/* start already designates an absolute address */
-		end = (start + _SEGMENT_SIZE) & ~(_SEGMENT_SIZE - 1);
-	} else {
-		start = kvm_s390_real_to_abs(vcpu, start);
-		end = start + PAGE_SIZE;
-	}
+	start = state.gaddr;
+	end = mb ? ALIGN(start + 1, _SEGMENT_SIZE) : start + PAGE_SIZE;
+	r1 = vcpu->run->s.regs.gprs + state.reg1;
+	r2 = vcpu->run->s.regs.gprs + state.reg2;
+	key = *r1 & 0xfe;
 
 	while (start != end) {
 		unsigned long vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(start));
@@ -396,9 +398,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 
 		mmap_read_lock(current->mm);
-		rc = cond_set_guest_storage_key(current->mm, vmaddr, key, &oldkey,
-						m3 & SSKE_NQ, m3 & SSKE_MR,
-						m3 & SSKE_MC);
+		rc = cond_set_guest_storage_key(current->mm, vmaddr, key, &oldkey, nq, mr, mc);
 
 		if (rc < 0) {
 			rc = fixup_user_fault(current->mm, vmaddr,
@@ -415,23 +415,21 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 		start += PAGE_SIZE;
 	}
 
-	if (m3 & (SSKE_MC | SSKE_MR)) {
-		if (m3 & SSKE_MB) {
+	if (mc || mr) {
+		if (mb) {
 			/* skey in reg1 is unpredictable */
 			kvm_s390_set_psw_cc(vcpu, 3);
 		} else {
 			kvm_s390_set_psw_cc(vcpu, rc);
-			vcpu->run->s.regs.gprs[reg1] &= ~0xff00UL;
-			vcpu->run->s.regs.gprs[reg1] |= (u64) oldkey << 8;
+			*r1 = u64_replace_bits(*r1, oldkey << 8, 0xff00);
 		}
 	}
-	if (m3 & SSKE_MB) {
-		if (psw_bits(vcpu->arch.sie_block->gpsw).eaba == PSW_BITS_AMODE_64BIT)
-			vcpu->run->s.regs.gprs[reg2] &= ~PAGE_MASK;
-		else
-			vcpu->run->s.regs.gprs[reg2] &= ~0xfffff000UL;
+	if (mb) {
 		end = kvm_s390_logical_to_effective(vcpu, end);
-		vcpu->run->s.regs.gprs[reg2] |= end;
+		if (kvm_s390_is_amode_64(vcpu))
+			*r2 = u64_replace_bits(*r2, end, PAGE_MASK);
+		else
+			*r2 = u64_replace_bits(*r2, end, 0xfffff000);
 	}
 	return 0;
 }
@@ -773,46 +771,28 @@ int kvm_s390_handle_lpsw(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int handle_lpswe(struct kvm_vcpu *vcpu)
+static int handle_lpswe_y(struct kvm_vcpu *vcpu, bool lpswey)
 {
 	psw_t new_psw;
 	u64 addr;
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_lpswe++;
-
-	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
-		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
-
-	addr = kvm_s390_get_base_disp_s(vcpu, &ar);
-	if (addr & 7)
-		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
-	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
-	if (rc)
-		return kvm_s390_inject_prog_cond(vcpu, rc);
-	vcpu->arch.sie_block->gpsw = new_psw;
-	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
-		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
-	return 0;
-}
-
-static int handle_lpswey(struct kvm_vcpu *vcpu)
-{
-	psw_t new_psw;
-	u64 addr;
-	int rc;
-	u8 ar;
-
-	vcpu->stat.instruction_lpswey++;
+	if (lpswey)
+		vcpu->stat.instruction_lpswey++;
+	else
+		vcpu->stat.instruction_lpswe++;
 
-	if (!test_kvm_facility(vcpu->kvm, 193))
+	if (lpswey && !test_kvm_facility(vcpu->kvm, 193))
 		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
+	if (!lpswey)
+		addr = kvm_s390_get_base_disp_s(vcpu, &ar);
+	else
+		addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
 	if (addr & 7)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
@@ -1034,7 +1014,7 @@ int kvm_s390_handle_b2(struct kvm_vcpu *vcpu)
 	case 0xb1:
 		return handle_stfl(vcpu);
 	case 0xb2:
-		return handle_lpswe(vcpu);
+		return handle_lpswe_y(vcpu, false);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1043,42 +1023,50 @@ int kvm_s390_handle_b2(struct kvm_vcpu *vcpu)
 static int handle_epsw(struct kvm_vcpu *vcpu)
 {
 	int reg1, reg2;
+	u64 *r1, *r2;
 
 	vcpu->stat.instruction_epsw++;
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
+	r1 = vcpu->run->s.regs.gprs + reg1;
+	r2 = vcpu->run->s.regs.gprs + reg2;
 
 	/* This basically extracts the mask half of the psw. */
-	vcpu->run->s.regs.gprs[reg1] &= 0xffffffff00000000UL;
-	vcpu->run->s.regs.gprs[reg1] |= vcpu->arch.sie_block->gpsw.mask >> 32;
-	if (reg2) {
-		vcpu->run->s.regs.gprs[reg2] &= 0xffffffff00000000UL;
-		vcpu->run->s.regs.gprs[reg2] |=
-			vcpu->arch.sie_block->gpsw.mask & 0x00000000ffffffffUL;
-	}
+	*r1 = u64_replace_bits(*r1, vcpu->arch.sie_block->gpsw.mask >> 32, 0xffffffff);
+	if (reg2)
+		*r2 = u64_replace_bits(*r2, vcpu->arch.sie_block->gpsw.mask, 0xffffffff);
 	return 0;
 }
 
 #define PFMF_RESERVED   0xfffc0101UL
-#define PFMF_SK         0x00020000UL
-#define PFMF_CF         0x00010000UL
-#define PFMF_UI         0x00008000UL
-#define PFMF_FSC        0x00007000UL
-#define PFMF_NQ         0x00000800UL
-#define PFMF_MR         0x00000400UL
-#define PFMF_MC         0x00000200UL
-#define PFMF_KEY        0x000000feUL
+union pfmf_r1 {
+	unsigned long val;
+	struct {
+		unsigned long    :46;
+		unsigned long sk : 1;
+		unsigned long cf : 1;
+		unsigned long ui : 1;
+		unsigned long fsc: 3;
+		unsigned long nq : 1;
+		unsigned long mr : 1;
+		unsigned long mc : 1;
+		unsigned long    : 1;
+		unsigned char skey;
+	} __packed;
+};
+
+static_assert(sizeof(union pfmf_r1) == sizeof(unsigned long));
 
 static int handle_pfmf(struct kvm_vcpu *vcpu)
 {
-	bool mr = false, mc = false, nq;
 	int reg1, reg2;
 	unsigned long start, end;
-	unsigned char key;
+	union pfmf_r1 r1;
 
 	vcpu->stat.instruction_pfmf++;
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
+	r1.val = vcpu->run->s.regs.gprs[reg1];
 
 	if (!test_kvm_facility(vcpu->kvm, 8))
 		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
@@ -1086,47 +1074,38 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	if (vcpu->run->s.regs.gprs[reg1] & PFMF_RESERVED)
+	if (r1.val & PFMF_RESERVED)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
 	/* Only provide non-quiescing support if enabled for the guest */
-	if (vcpu->run->s.regs.gprs[reg1] & PFMF_NQ &&
-	    !test_kvm_facility(vcpu->kvm, 14))
+	if (r1.nq && !test_kvm_facility(vcpu->kvm, 14))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
 	/* Only provide conditional-SSKE support if enabled for the guest */
-	if (vcpu->run->s.regs.gprs[reg1] & PFMF_SK &&
-	    test_kvm_facility(vcpu->kvm, 10)) {
-		mr = vcpu->run->s.regs.gprs[reg1] & PFMF_MR;
-		mc = vcpu->run->s.regs.gprs[reg1] & PFMF_MC;
-	}
+	if (!r1.sk || !test_kvm_facility(vcpu->kvm, 10))
+		r1.mr = r1.mc = 0;
 
-	nq = vcpu->run->s.regs.gprs[reg1] & PFMF_NQ;
-	key = vcpu->run->s.regs.gprs[reg1] & PFMF_KEY;
 	start = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
 	start = kvm_s390_logical_to_effective(vcpu, start);
 
-	if (vcpu->run->s.regs.gprs[reg1] & PFMF_CF) {
-		if (kvm_s390_check_low_addr_prot_real(vcpu, start))
-			return kvm_s390_inject_prog_irq(vcpu, &vcpu->arch.pgm);
-	}
+	if (r1.cf && kvm_s390_check_low_addr_prot_real(vcpu, start))
+		return kvm_s390_inject_prog_irq(vcpu, &vcpu->arch.pgm);
 
-	switch (vcpu->run->s.regs.gprs[reg1] & PFMF_FSC) {
-	case 0x00000000:
+	switch (r1.fsc) {
+	case 0:
 		/* only 4k frames specify a real address */
 		start = kvm_s390_real_to_abs(vcpu, start);
-		end = (start + PAGE_SIZE) & ~(PAGE_SIZE - 1);
+		end = ALIGN(start + 1, PAGE_SIZE);
 		break;
-	case 0x00001000:
-		end = (start + _SEGMENT_SIZE) & ~(_SEGMENT_SIZE - 1);
+	case 1:
+		end = ALIGN(start + 1, _SEGMENT_SIZE);
 		break;
-	case 0x00002000:
+	case 2:
 		/* only support 2G frame size if EDAT2 is available and we are
 		   not in 24-bit addressing mode */
-		if (!test_kvm_facility(vcpu->kvm, 78) ||
-		    psw_bits(vcpu->arch.sie_block->gpsw).eaba == PSW_BITS_AMODE_24BIT)
+		if (!test_kvm_facility(vcpu->kvm, 78) || kvm_s390_is_amode_24(vcpu))
 			return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
-		end = (start + _REGION3_SIZE) & ~(_REGION3_SIZE - 1);
+		end = ALIGN(start + 1, _REGION3_SIZE);
 		break;
 	default:
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
@@ -1141,19 +1120,17 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 		if (kvm_is_error_hva(vmaddr))
 			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 
-		if (vcpu->run->s.regs.gprs[reg1] & PFMF_CF) {
-			if (kvm_clear_guest(vcpu->kvm, start, PAGE_SIZE))
-				return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-		}
+		if (r1.cf && kvm_clear_guest(vcpu->kvm, start, PAGE_SIZE))
+			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 
-		if (vcpu->run->s.regs.gprs[reg1] & PFMF_SK) {
+		if (r1.sk) {
 			int rc = kvm_s390_skey_check_enable(vcpu);
 
 			if (rc)
 				return rc;
 			mmap_read_lock(current->mm);
-			rc = cond_set_guest_storage_key(current->mm, vmaddr,
-							key, NULL, nq, mr, mc);
+			rc = cond_set_guest_storage_key(current->mm, vmaddr, r1.skey, NULL,
+							r1.nq, r1.mr, r1.mc);
 			if (rc < 0) {
 				rc = fixup_user_fault(current->mm, vmaddr,
 						      FAULT_FLAG_WRITE, &unlocked);
@@ -1169,14 +1146,14 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 		}
 		start += PAGE_SIZE;
 	}
-	if (vcpu->run->s.regs.gprs[reg1] & PFMF_FSC) {
-		if (psw_bits(vcpu->arch.sie_block->gpsw).eaba == PSW_BITS_AMODE_64BIT) {
-			vcpu->run->s.regs.gprs[reg2] = end;
-		} else {
-			vcpu->run->s.regs.gprs[reg2] &= ~0xffffffffUL;
-			end = kvm_s390_logical_to_effective(vcpu, end);
-			vcpu->run->s.regs.gprs[reg2] |= end;
-		}
+	if (r1.fsc) {
+		u64 *r2 = vcpu->run->s.regs.gprs + reg2;
+
+		end = kvm_s390_logical_to_effective(vcpu, end);
+		if (kvm_s390_is_amode_64(vcpu))
+			*r2 = u64_replace_bits(*r2, end, PAGE_MASK);
+		else
+			*r2 = u64_replace_bits(*r2, end, 0xfffff000);
 	}
 	return 0;
 }
@@ -1361,8 +1338,9 @@ int kvm_s390_handle_lctl(struct kvm_vcpu *vcpu)
 	reg = reg1;
 	nr_regs = 0;
 	do {
-		vcpu->arch.sie_block->gcr[reg] &= 0xffffffff00000000ul;
-		vcpu->arch.sie_block->gcr[reg] |= ctl_array[nr_regs++];
+		u64 *cr = vcpu->arch.sie_block->gcr + reg;
+
+		*cr = u64_replace_bits(*cr, ctl_array[nr_regs++], 0xffffffff);
 		if (reg == reg3)
 			break;
 		reg = (reg + 1) % 16;
@@ -1489,7 +1467,7 @@ int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
 	case 0x62:
 		return handle_ri(vcpu);
 	case 0x71:
-		return handle_lpswey(vcpu);
+		return handle_lpswe_y(vcpu, true);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.49.0


