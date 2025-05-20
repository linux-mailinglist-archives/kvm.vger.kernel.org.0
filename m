Return-Path: <kvm+bounces-47172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB13ABE2A6
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 20:27:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC9BC7A4F9B
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA8925B1D8;
	Tue, 20 May 2025 18:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HlqTbrLt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8831D280027;
	Tue, 20 May 2025 18:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747765611; cv=none; b=Dd6Kd9zkmmdBY7gO2Ebu6urBrdDFmyO/eW1YHZQ7Gu+RS8izGpO5s2phrzrISgkvy7WGpNPjD1IE9TYh7ykM7ra9KmzozbUnGbffP4NuHY/kMpEat6SZ96BxnlO27IEkVR1fcRrSDl9AvKV4L79X5q9vEy638Jq11X8A9SMdHjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747765611; c=relaxed/simple;
	bh=CDQ5rVh03Qg1vAxIFsNtx7Q8+jzgOktaMkZVLDbKP8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuDV5ztEhRtTmnO1Su+8Tqm5xV7LmiNC3xfWkaUii/Qb4JY5Ih3A5nhv0nBDE8ETcPNqOPmMOhdrG4uVYi9uVQLgXZDb/KlMmhFf981BLakeAqyzF1nsGFtlmQN8TD0HpCoCnVDCU8HKoz/9kijKwJyqp07PVBDs46uozS1NUQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HlqTbrLt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KH6xer024436;
	Tue, 20 May 2025 18:26:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nfDW9FElWYsvDnw/E
	U2KykhbJMj4L5+JyQHZy6sK3hk=; b=HlqTbrLtb/6ofg4+kyhE0X60ypnUMlJK6
	7HDiGJUhiVfwKF2Yey1GhVV5oud4VmSFZ1GVSvp1T7meqQPABtwpUYkUekwPbCO3
	ejza52wSZ41q7xTk0xq6FHn9eiodersFh+RU0kseYSK2y/TnWv1ph/iIJ1Dp3F4x
	HouDQ479s4NHKwxneQEPEX7+TZtjYdmSvi6r0MHeUwe69PlPJfaMFDk+D68EgtOs
	OaHI6VIqv0XveqOGY2bwVO++NUAB4o+TlQFv5eu0e4A2BgXarOj0Mnxj3UISAw7E
	lM9//OWljkSgRLSDy57iJEc1KOtjpCQO2V1Xe/0TXvJtoGyoQQGzQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46rwut8c1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 18:26:45 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54KGnpib024698;
	Tue, 20 May 2025 18:26:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwkr0dau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 18:26:44 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54KIQf0446137668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 18:26:41 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D1B720049;
	Tue, 20 May 2025 18:26:41 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA6182004D;
	Tue, 20 May 2025 18:26:40 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 May 2025 18:26:40 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v2 3/5] KVM: s390: refactor some functions in priv.c
Date: Tue, 20 May 2025 20:26:37 +0200
Message-ID: <20250520182639.80013-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520182639.80013-1-imbrenda@linux.ibm.com>
References: <20250520182639.80013-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XRGY4wCYVxcHbfZoxiJsQ_1fXShH9shW
X-Proofpoint-GUID: XRGY4wCYVxcHbfZoxiJsQ_1fXShH9shW
X-Authority-Analysis: v=2.4 cv=MMRgmNZl c=1 sm=1 tr=0 ts=682cc965 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=ilECb7VF1RFgedB8ViUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDE1MCBTYWx0ZWRfX5blC5hXS3CuT uGlwMC9A+Bu5EHnnx4+0jrQt4my00E12fT+I+qOQ7toqHTeYkTkrpn7+pt91ATgF5bwmDhOYrms UbJdCG5JAKpMhvW9Ui5wB9NADNdo+ld0BYlnMH/CcsmCeD+7a8El0yR0PMhS3T2wsqeG/iYXcct
 WvOCbYI8FQUJd3c1t21N5uaa8FO3Utic3NCRz9KnCb14D98XCFpJwZ3jsgah0Wuvi5sPZQyRDBp an5tXTzIiusgCY7pydL8z/k4Rg3eVEMMDe8lsfYJxhKNSlQes9mOm8tG7OPI2rZ6On2VjPIGMRb f+sP3rRu2Lbc9FB3zIM7ehGpjEZVxxYLKVlPnW+i/PjJksQqC2N4Ge/FpBN+TKjByHFzpKUnZrp
 DRwCDD7FVxir4VAZ0HqbKAtVS76KsOqorWhiNAcZ2fZeJxhjQsFHhD0gJSUMF5/4eaBm0bVf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_08,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=609 impostorscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505200150

Refactor some functions in priv.c to make them more readable.

handle_{iske,rrbe,sske}: move duplicated checks into a single function.
handle{pfmf,epsw}: improve readability.
handle_lpswe{,y}: merge implementations since they are almost the same.

Use a helper function to replace open-coded bit twiddling operations.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.h |  15 +++
 arch/s390/kvm/priv.c     | 281 +++++++++++++++++++--------------------
 2 files changed, 153 insertions(+), 143 deletions(-)

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
index 9253c70897a8..15843e7e57e6 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -253,29 +253,64 @@ static int try_handle_skey(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static inline void replace_selected_bits(u64 *w, unsigned long mask, unsigned long val)
+{
+	*w = (*w & ~mask) | (val & mask);
+}
+
+struct skeys_ops_state {
+	int reg1;
+	int reg2;
+	u64 *r1;
+	u64 *r2;
+	unsigned long effective;
+	unsigned long absolute;
+};
+
+static void get_regs_rre_ptr(struct kvm_vcpu *vcpu, int *reg1, int *reg2, u64 **r1, u64 **r2)
+{
+	kvm_s390_get_regs_rre(vcpu, reg1, reg2);
+	*r1 = vcpu->run->s.regs.gprs + *reg1;
+	*r2 = vcpu->run->s.regs.gprs + *reg2;
+}
+
+static int skeys_common_checks(struct kvm_vcpu *vcpu, struct skeys_ops_state *state)
+{
+	int rc;
+
+	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE) {
+		rc = kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
+		return rc ? rc : -EAGAIN;
+	}
+
+	rc = try_handle_skey(vcpu);
+	if (rc)
+		return rc;
+
+	get_regs_rre_ptr(vcpu, &state->reg1, &state->reg2, &state->r1, &state->r2);
+
+	state->effective = vcpu->run->s.regs.gprs[state->reg2] & PAGE_MASK;
+	state->effective = kvm_s390_logical_to_effective(vcpu, state->effective);
+	state->absolute = kvm_s390_real_to_abs(vcpu, state->effective);
+
+	return 0;
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
 	int rc;
 
 	vcpu->stat.instruction_iske++;
 
-	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
-		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
-
-	rc = try_handle_skey(vcpu);
+	rc = skeys_common_checks(vcpu, &state);
 	if (rc)
 		return rc != -EAGAIN ? rc : 0;
 
-	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
-
-	gaddr = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
-	gaddr = kvm_s390_logical_to_effective(vcpu, gaddr);
-	gaddr = kvm_s390_real_to_abs(vcpu, gaddr);
-	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
+	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(state.absolute));
 	if (kvm_is_error_hva(vmaddr))
 		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 retry:
@@ -296,33 +331,24 @@ static int handle_iske(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 	if (rc < 0)
 		return rc;
-	vcpu->run->s.regs.gprs[reg1] &= ~0xff;
-	vcpu->run->s.regs.gprs[reg1] |= key;
+	replace_selected_bits(state.r1, 0xff, key);
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
+	rc = skeys_common_checks(vcpu, &state);
 	if (rc)
 		return rc != -EAGAIN ? rc : 0;
 
-	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
-
-	gaddr = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
-	gaddr = kvm_s390_logical_to_effective(vcpu, gaddr);
-	gaddr = kvm_s390_real_to_abs(vcpu, gaddr);
-	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
+	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(state.absolute));
 	if (kvm_is_error_hva(vmaddr))
 		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 retry:
@@ -353,40 +379,28 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
 static int handle_sske(struct kvm_vcpu *vcpu)
 {
 	unsigned char m3 = vcpu->arch.sie_block->ipb >> 28;
+	struct skeys_ops_state state;
 	unsigned long start, end;
 	unsigned char key, oldkey;
-	int reg1, reg2;
+	bool nq, mr, mc, mb;
 	bool unlocked;
 	int rc;
 
 	vcpu->stat.instruction_sske++;
 
-	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
-		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
+	mb = test_kvm_facility(vcpu->kvm, 8) && (m3 & SSKE_MB);
+	mr = test_kvm_facility(vcpu->kvm, 10) && (m3 & SSKE_MR);
+	mc = test_kvm_facility(vcpu->kvm, 10) && (m3 & SSKE_MC);
+	nq = test_kvm_facility(vcpu->kvm, 14) && (m3 & SSKE_NQ);
 
-	rc = try_handle_skey(vcpu);
+	rc = skeys_common_checks(vcpu, &state);
 	if (rc)
 		return rc != -EAGAIN ? rc : 0;
 
-	if (!test_kvm_facility(vcpu->kvm, 8))
-		m3 &= ~SSKE_MB;
-	if (!test_kvm_facility(vcpu->kvm, 10))
-		m3 &= ~(SSKE_MC | SSKE_MR);
-	if (!test_kvm_facility(vcpu->kvm, 14))
-		m3 &= ~SSKE_NQ;
-
-	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
-
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
+	/* start already designates an absolute address if MB is set */
+	start = mb ? state.effective : state.absolute;
+	end = mb ? ALIGN(start + 1, _SEGMENT_SIZE) : start + PAGE_SIZE;
+	key = *state.r1 & 0xfe;
 
 	while (start != end) {
 		unsigned long vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(start));
@@ -396,9 +410,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 
 		mmap_read_lock(current->mm);
-		rc = cond_set_guest_storage_key(current->mm, vmaddr, key, &oldkey,
-						m3 & SSKE_NQ, m3 & SSKE_MR,
-						m3 & SSKE_MC);
+		rc = cond_set_guest_storage_key(current->mm, vmaddr, key, &oldkey, nq, mr, mc);
 
 		if (rc < 0) {
 			rc = fixup_user_fault(current->mm, vmaddr,
@@ -415,23 +427,21 @@ static int handle_sske(struct kvm_vcpu *vcpu)
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
+			replace_selected_bits(state.r1, 0xff00, oldkey << 8);
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
+			replace_selected_bits(state.r2, PAGE_MASK, end);
+		else
+			replace_selected_bits(state.r2, 0xfffff000, end);
 	}
 	return 0;
 }
@@ -773,19 +783,14 @@ int kvm_s390_handle_lpsw(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int handle_lpswe(struct kvm_vcpu *vcpu)
+static int handle_lpswe_y(struct kvm_vcpu *vcpu, u8 ar, unsigned long addr)
 {
 	psw_t new_psw;
-	u64 addr;
 	int rc;
-	u8 ar;
-
-	vcpu->stat.instruction_lpswe++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	addr = kvm_s390_get_base_disp_s(vcpu, &ar);
 	if (addr & 7)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
@@ -799,9 +804,7 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
 
 static int handle_lpswey(struct kvm_vcpu *vcpu)
 {
-	psw_t new_psw;
-	u64 addr;
-	int rc;
+	unsigned long addr;
 	u8 ar;
 
 	vcpu->stat.instruction_lpswey++;
@@ -809,22 +812,19 @@ static int handle_lpswey(struct kvm_vcpu *vcpu)
 	if (!test_kvm_facility(vcpu->kvm, 193))
 		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
 
-	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
-		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
-
 	addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
-	if (addr & 7)
-		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+	return handle_lpswe_y(vcpu, ar, addr);
+}
 
-	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
-	if (rc)
-		return kvm_s390_inject_prog_cond(vcpu, rc);
+static int handle_lpswe(struct kvm_vcpu *vcpu)
+{
+	unsigned long addr;
+	u8 ar;
 
-	vcpu->arch.sie_block->gpsw = new_psw;
-	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
-		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+	vcpu->stat.instruction_lpswe++;
 
-	return 0;
+	addr = kvm_s390_get_base_disp_s(vcpu, &ar);
+	return handle_lpswe_y(vcpu, ar, addr);
 }
 
 static int handle_stidp(struct kvm_vcpu *vcpu)
@@ -1043,42 +1043,49 @@ int kvm_s390_handle_b2(struct kvm_vcpu *vcpu)
 static int handle_epsw(struct kvm_vcpu *vcpu)
 {
 	int reg1, reg2;
+	u64 *r1, *r2;
 
 	vcpu->stat.instruction_epsw++;
 
-	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
+	get_regs_rre_ptr(vcpu, &reg1, &reg2, &r1, &r2);
 
 	/* This basically extracts the mask half of the psw. */
-	vcpu->run->s.regs.gprs[reg1] &= 0xffffffff00000000UL;
-	vcpu->run->s.regs.gprs[reg1] |= vcpu->arch.sie_block->gpsw.mask >> 32;
-	if (reg2) {
-		vcpu->run->s.regs.gprs[reg2] &= 0xffffffff00000000UL;
-		vcpu->run->s.regs.gprs[reg2] |=
-			vcpu->arch.sie_block->gpsw.mask & 0x00000000ffffffffUL;
-	}
+	replace_selected_bits(r1, 0xffffffff, vcpu->arch.sie_block->gpsw.mask >> 32);
+	if (reg2)
+		replace_selected_bits(r2, 0xffffffff, vcpu->arch.sie_block->gpsw.mask);
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
-	int reg1, reg2;
 	unsigned long start, end;
-	unsigned char key;
+	union pfmf_r1 r1;
+	u64 *dummy, *r2;
+	int reg1, reg2;
 
 	vcpu->stat.instruction_pfmf++;
 
-	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
+	get_regs_rre_ptr(vcpu, &reg1, &reg2, &dummy, &r2);
+	r1.val = vcpu->run->s.regs.gprs[reg1];
 
 	if (!test_kvm_facility(vcpu->kvm, 8))
 		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
@@ -1086,47 +1093,38 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
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
@@ -1141,19 +1139,17 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
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
@@ -1169,14 +1165,12 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
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
+		end = kvm_s390_logical_to_effective(vcpu, end);
+		if (kvm_s390_is_amode_64(vcpu))
+			replace_selected_bits(r2, PAGE_MASK, end);
+		else
+			replace_selected_bits(r2, 0xfffff000, end);
 	}
 	return 0;
 }
@@ -1363,8 +1357,9 @@ int kvm_s390_handle_lctl(struct kvm_vcpu *vcpu)
 	reg = reg1;
 	nr_regs = 0;
 	do {
-		vcpu->arch.sie_block->gcr[reg] &= 0xffffffff00000000ul;
-		vcpu->arch.sie_block->gcr[reg] |= ctl_array[nr_regs++];
+		u64 *cr = vcpu->arch.sie_block->gcr + reg;
+
+		replace_selected_bits(cr, 0xffffffff, ctl_array[nr_regs++]);
 		if (reg == reg3)
 			break;
 		reg = (reg + 1) % 16;
-- 
2.49.0


