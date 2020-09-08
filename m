Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95495260F3A
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 12:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbgIHKDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 06:03:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729248AbgIHKDQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 06:03:16 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088A14LH135907;
        Tue, 8 Sep 2020 06:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=VWNPJ8nrQ3kyrPXv3ORfc0g5VmVXuAU5MlsyPmYGm0k=;
 b=EqyzS4OJcJ6aOvTgxl8KrcSQF7WumTTNF7Gjn52OEfVGgjfNPT7jKJ0uoW9O3wh/lsy2
 2f+iI8NenE5jtksdp7ViF5Yf3dzzjxF3dNf4gImXzrdynCvPXrSMIPUssJGDnQhyRd63
 NxSK0w/shlbKD/VdwqQNBUpDH1VeiZTCPTcAmvtf7UuWf3o+BtRwei9ynPi5emh+V6Pr
 S3iVvkufTAn1DmC6aou21Fp+2YputH0C0qlaFotiDYyP+hCuZNBd8CPfy6HQmSopaYG/
 njxUq8gLE86i2OaBzkRm1giyVElABViegj3eNPspUeIHKa0qCyoVLuDuHMlf9LXxzZzb Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33e5yec118-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 06:03:14 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 088A1ok8138956;
        Tue, 8 Sep 2020 06:03:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33e5yec10e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 06:03:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 088A28LW019729;
        Tue, 8 Sep 2020 10:03:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 33c2a8ba62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 10:03:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 088A39TV35455368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 10:03:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0662CA4051;
        Tue,  8 Sep 2020 10:03:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B963A404D;
        Tue,  8 Sep 2020 10:03:08 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Sep 2020 10:03:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org
Subject: [PATCH v3] KVM: s390: Introduce storage key removal facility
Date:   Tue,  8 Sep 2020 06:02:49 -0400
Message-Id: <20200908100249.23150-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_04:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 impostorscore=0 lowpriorityscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The storage key removal facility makes skey related instructions
result in special operation program exceptions. It is based on the
Keyless Subset Facility.

The usual suspects are iske, sske, rrbe and their respective
variants. lpsw(e), pfmf and tprot can also specify a key and essa with
an ORC of 4 will consult the change bit, hence they all result in
exceptions.

Unfortunately storage keys were so essential to the architecture, that
there is no facility bit that we could deactivate. That's why the
removal facility (bit 169) was introduced which makes it necessary,
that, if active, the skey related facilities 10, 14, 66, 145 and 149
are zero. Managing this requirement and migratability has to be done
in userspace, as KVM does not check the facilities it receives to be
able to easily implement userspace emulation.

Removing storage key support allows us to circumvent complicated
emulation code and makes huge page support tremendously easier.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---

v3:
	* Put kss handling into own function
	* Removed some unneeded catch statements and converted others to ifs

v2:
	* Removed the likely
	* Updated and re-shuffeled the comments which had the wrong information

---
 arch/s390/kvm/intercept.c | 34 +++++++++++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.c  |  5 +++++
 arch/s390/kvm/priv.c      | 26 +++++++++++++++++++++++---
 3 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index e7a7c499a73f..9c699c3fcf84 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -33,6 +33,7 @@ u8 kvm_s390_get_ilen(struct kvm_vcpu *vcpu)
 	case ICPT_OPEREXC:
 	case ICPT_PARTEXEC:
 	case ICPT_IOINST:
+	case ICPT_KSS:
 		/* instruction only stored for these icptcodes */
 		ilen = insn_length(vcpu->arch.sie_block->ipa >> 8);
 		/* Use the length of the EXECUTE instruction if necessary */
@@ -531,6 +532,37 @@ static int handle_pv_notification(struct kvm_vcpu *vcpu)
 	return handle_instruction(vcpu);
 }
 
+static int handle_kss(struct kvm_vcpu *vcpu)
+{
+	if (!test_kvm_facility(vcpu->kvm, 169))
+		return kvm_s390_skey_check_enable(vcpu);
+
+	/*
+	 * Storage key removal facility emulation.
+	 *
+	 * KSS is the same priority as an instruction
+	 * interception. Hence we need handling here
+	 * and in the instruction emulation code.
+	 *
+	 * KSS is nullifying (no psw forward), SKRF
+	 * issues suppressing SPECIAL OPS, so we need
+	 * to forward by hand.
+	 */
+	if  (vcpu->arch.sie_block->ipa == 0) {
+		/*
+		 * Interception caused by a key in a
+		 * exception new PSW mask. The guest
+		 * PSW has already been updated to the
+		 * non-valid PSW so we only need to
+		 * inject a PGM.
+		 */
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+	}
+
+	kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
+	return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
+}
+
 int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 {
 	int rc, per_rc = 0;
@@ -565,7 +597,7 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 		rc = handle_partial_execution(vcpu);
 		break;
 	case ICPT_KSS:
-		rc = kvm_s390_skey_check_enable(vcpu);
+		rc = handle_kss(vcpu);
 		break;
 	case ICPT_MCHKREQ:
 	case ICPT_INT_ENABLE:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b74b92c1a58..85647f19311d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2692,6 +2692,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* we emulate STHYI in kvm */
 	set_kvm_facility(kvm->arch.model.fac_mask, 74);
 	set_kvm_facility(kvm->arch.model.fac_list, 74);
+	/* we emulate the storage key removal facility only with kss */
+	if (sclp.has_kss) {
+		set_kvm_facility(kvm->arch.model.fac_mask, 169);
+		set_kvm_facility(kvm->arch.model.fac_list, 169);
+	}
 	if (MACHINE_HAS_TLB_GUEST) {
 		set_kvm_facility(kvm->arch.model.fac_mask, 147);
 		set_kvm_facility(kvm->arch.model.fac_list, 147);
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index cd74989ce0b0..5e3583b8b5e3 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -207,6 +207,13 @@ int kvm_s390_skey_check_enable(struct kvm_vcpu *vcpu)
 	int rc;
 
 	trace_kvm_s390_skey_related_inst(vcpu);
+
+	if (test_kvm_facility(vcpu->kvm, 169)) {
+		rc = kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
+		if (!rc)
+			return -EOPNOTSUPP;
+	}
+
 	/* Already enabled? */
 	if (vcpu->arch.skey_enabled)
 		return 0;
@@ -257,7 +264,7 @@ static int handle_iske(struct kvm_vcpu *vcpu)
 
 	rc = try_handle_skey(vcpu);
 	if (rc)
-		return rc != -EAGAIN ? rc : 0;
+		return (rc != -EAGAIN || rc != -EOPNOTSUPP) ? rc : 0;
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
@@ -304,7 +311,7 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
 
 	rc = try_handle_skey(vcpu);
 	if (rc)
-		return rc != -EAGAIN ? rc : 0;
+		return (rc != -EAGAIN || rc != -EOPNOTSUPP) ? rc : 0;
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
@@ -355,7 +362,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 
 	rc = try_handle_skey(vcpu);
 	if (rc)
-		return rc != -EAGAIN ? rc : 0;
+		return (rc != -EAGAIN || rc != -EOPNOTSUPP) ? rc : 0;
 
 	if (!test_kvm_facility(vcpu->kvm, 8))
 		m3 &= ~SSKE_MB;
@@ -745,6 +752,8 @@ int kvm_s390_handle_lpsw(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
 	if (!(new_psw.mask & PSW32_MASK_BASE))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+	if (new_psw.mask & PSW32_MASK_KEY && test_kvm_facility(vcpu->kvm, 169))
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
 	gpsw->mask = (new_psw.mask & ~PSW32_MASK_BASE) << 32;
 	gpsw->mask |= new_psw.addr & PSW32_ADDR_AMODE;
 	gpsw->addr = new_psw.addr & ~PSW32_ADDR_AMODE;
@@ -771,6 +780,8 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
 	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
+	if ((new_psw.mask & PSW_MASK_KEY) && test_kvm_facility(vcpu->kvm, 169))
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
 	vcpu->arch.sie_block->gpsw = new_psw;
 	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
@@ -1025,6 +1036,10 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
+	if (vcpu->run->s.regs.gprs[reg1] & PFMF_SK &&
+	    test_kvm_facility(vcpu->kvm, 169))
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
+
 	if (vcpu->run->s.regs.gprs[reg1] & PFMF_RESERVED)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
@@ -1203,6 +1218,8 @@ static int handle_essa(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 	/* Check for invalid operation request code */
 	orc = (vcpu->arch.sie_block->ipb & 0xf0000000) >> 28;
+	if (orc == ESSA_SET_POT_VOLATILE && test_kvm_facility(vcpu->kvm, 169))
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
 	/* ORCs 0-6 are always valid */
 	if (orc > (test_kvm_facility(vcpu->kvm, 147) ? ESSA_SET_STABLE_NODAT
 						: ESSA_SET_STABLE_IF_RESIDENT))
@@ -1451,6 +1468,9 @@ static int handle_tprot(struct kvm_vcpu *vcpu)
 
 	kvm_s390_get_base_disp_sse(vcpu, &address1, &address2, &ar, NULL);
 
+	if ((address2 & 0xf0) && test_kvm_facility(vcpu->kvm, 169))
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
+
 	/* we only handle the Linux memory detection case:
 	 * access key == 0
 	 * everything else goes to userspace. */
-- 
2.25.1

