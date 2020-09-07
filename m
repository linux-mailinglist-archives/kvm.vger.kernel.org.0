Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED3A26033A
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbgIGRqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 13:46:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19478 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729394AbgIGNO0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 09:14:26 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087D4UNn167875;
        Mon, 7 Sep 2020 09:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=qAM6XSxtNjfqGEthn7zWqzDo3LY9WO8P+0xYllpgUh8=;
 b=PcYpCD7mhcMlTayQdJaSb50I2Gi7UCBmOD+4dFPd1fpS0n/f8fV7FtjeehFK55+/CNjv
 jSv/XoP8bMGGpEXEEleROj5FW4hlFV3+BVq3A3fIQQkRyQyLedbo4GPaxnlT2P4f1Hzy
 ZWdaly6emoVKSNWRn7dUO8soqfXC5KcmRFGndQ4qm/tfh97labf683d1qMjj4ZKTUNrc
 w16K8p1uwQi4fcqXKJYElv7SmX8WE3suGw9nJRddRYpusgdQuVGSIi3VelW1SH+J/u6j
 eljFVWmiAD2Rg5ecsBLzr9NT6kgVkPqHH1o2Hpy0T7L9mvjQSKvppbFK/3qEnA/zfupD 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33dkc4bq76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 09:14:24 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 087D53TK170637;
        Mon, 7 Sep 2020 09:14:24 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33dkc4bq6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 09:14:24 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 087DCSLF029546;
        Mon, 7 Sep 2020 13:14:22 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 33c2a8adyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 13:14:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 087DClrJ29295024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Sep 2020 13:12:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F167A4040;
        Mon,  7 Sep 2020 13:14:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4BEDA405B;
        Mon,  7 Sep 2020 13:14:18 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Sep 2020 13:14:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org
Subject: [PATCH] KVM: s390: Introduce storage key removal facility
Date:   Mon,  7 Sep 2020 09:14:10 -0400
Message-Id: <20200907131410.11474-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_07:2020-09-07,2020-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 suspectscore=1 malwarescore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070128
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
 arch/s390/kvm/intercept.c | 40 ++++++++++++++++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.c  |  5 +++++
 arch/s390/kvm/priv.c      | 26 ++++++++++++++++++++++---
 3 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index e7a7c499a73f..99dd042d7dea 100644
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
@@ -565,7 +566,44 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 		rc = handle_partial_execution(vcpu);
 		break;
 	case ICPT_KSS:
-		rc = kvm_s390_skey_check_enable(vcpu);
+		if (likely(!test_kvm_facility(vcpu->kvm, 169))) {
+			rc = kvm_s390_skey_check_enable(vcpu);
+		} else {
+			/*
+			 * Storage key removal facility emulation.
+			 *
+			 * KSS is the same priority as instruction
+			 * interception. Hence we need handling here
+			 * and in the instruction emulation code.
+			 *
+			 * lpsw(e) needs to store the problematic psw
+			 * as the program old psw. Calling the
+			 * handlers directly does that without falsely
+			 * increasing stat counters.
+			 */
+			switch (vcpu->arch.sie_block->ipa) {
+			case 0xb2b2:
+				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
+				rc = kvm_s390_handle_b2(vcpu);
+				break;
+			case 0x8200:
+				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
+				rc = kvm_s390_handle_lpsw(vcpu);
+				break;
+			case 0:
+				/* Interception caused by exception new PSW key */
+				rc = kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+				break;
+			default:
+				/*
+				 * KSS is nullifying (no psw forward),
+				 * SKRF issues suppressing SPECIAL
+				 * OPS, so we need to forward by hand.
+				 */
+				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
+				rc = kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
+			}
+		}
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
index cd74989ce0b0..d1923fbec341 100644
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
+		return rc != (-EAGAIN || -EOPNOTSUPP) ? rc : 0;
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
@@ -304,7 +311,7 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
 
 	rc = try_handle_skey(vcpu);
 	if (rc)
-		return rc != -EAGAIN ? rc : 0;
+		return rc != (-EAGAIN || -EOPNOTSUPP) ? rc : 0;
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
@@ -355,7 +362,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 
 	rc = try_handle_skey(vcpu);
 	if (rc)
-		return rc != -EAGAIN ? rc : 0;
+		return rc != (-EAGAIN || -EOPNOTSUPP) ? rc : 0;
 
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

