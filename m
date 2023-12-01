Return-Path: <kvm+bounces-3124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15AE2800C3F
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9525DB20EFD
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 13:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CED233B28E;
	Fri,  1 Dec 2023 13:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bnfJsY3K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C301193;
	Fri,  1 Dec 2023 05:33:15 -0800 (PST)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1DM178009911;
	Fri, 1 Dec 2023 13:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VjgXqS/kBjD2g7EPDogOf1muMe4VYhRCx0aiMHeFe1g=;
 b=bnfJsY3KCippl0MoP50GgpwZ5xeIQT5erNe9Gmixw+2om4R+eavxUyL5XBRcmmDyXBUH
 zE8lnrK4lw9LOsin24yeqsdVXNhpjXJKYpM6ZpdZ1towphrZAPqNApqeS98xnMZTMPSt
 1CXsfr3bcYR7irJucs04JJvcm3Kf12B6MIKdUa8d9OzsJbVxvVHR6kTMB3sNZ4skpCLs
 7gc65r6yooZYzCWsLIhDQoGRe6aMokIEBJ6Q9Dl5+q03tkpKx3MVlJv/jAnNapidIySo
 +urf3M7V8cq4q4Cc5Cv+6FES46TSIiEbWAztX3iOHSGYP2Y3cp+XvxNzyH7BChggI14Q 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqgad0agx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:33:06 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B1DMiJr012212;
	Fri, 1 Dec 2023 13:33:05 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqgad0ae8-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:33:05 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1AXpdl031675;
	Fri, 1 Dec 2023 13:27:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukun05dn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:27:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B1DRLKL42926426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 13:27:21 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 908722004D;
	Fri,  1 Dec 2023 13:27:21 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B112C20040;
	Fri,  1 Dec 2023 13:27:17 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.171.33.138])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  1 Dec 2023 13:27:17 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:57:16 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org,
        paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM
Subject: [PATCH 11/12] KVM: PPC: Reduce reliance on analyse_instr() in mmio emulation
Date: Fri,  1 Dec 2023 18:56:16 +0530
Message-ID: <20231201132618.555031-12-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231201132618.555031-1-vaibhav@linux.ibm.com>
References: <20231201132618.555031-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Yln3g9ZR4DLMeYCHsxD3FO9n7F_PigO0
X-Proofpoint-ORIG-GUID: Or9SMVsvDHNDgHKuTIVV7rI9OjVdvR_3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_11,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=664 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312010092

From: Jordan Niethe <jniethe5@gmail.com>

Commit 709236039964 ("KVM: PPC: Reimplement non-SIMD LOAD/STORE
instruction mmio emulation with analyse_instr() input") and
commit 2b33cb585f94 ("KVM: PPC: Reimplement LOAD_FP/STORE_FP instruction
mmio emulation with analyse_instr() input") made
kvmppc_emulate_loadstore() use the results from analyse_instr() for
instruction emulation. In particular the effective address from
analyse_instr() is used for UPDATE type instructions and fact that
op.val is all ready endian corrected is used in the STORE case.

However, these changes now have some negative implications for the
nestedv2 case.  For analyse_instr() to determine the correct effective
address, the GPRs must be loaded from the L0. This is not needed as
vcpu->arch.vaddr_accessed is already set. Change back to using
vcpu->arch.vaddr_accessed.

In the STORE case, use kvmppc_get_gpr() value instead of the op.val.
kvmppc_get_gpr() will reload from the L0 if needed in the nestedv2 case.
This means if a byte reversal is needed must now be passed to
kvmppc_handle_store() like in the kvmppc_handle_load() case.

This means the call to kvmhv_nestedv2_reload_ptregs() can be avoided as
there is no concern about op.val being stale. Drop the call to
kvmhv_nestedv2_mark_dirty_ptregs() as without the call to
kvmhv_nestedv2_reload_ptregs(), stale state could be marked as valid.

This is fine as the required marking things dirty is already handled for
the UPDATE case by the call to kvmppc_set_gpr(). For LOADs, it is
handled in kvmppc_complete_mmio_load(). This is called either directly
in __kvmppc_handle_load() if the load can be handled in KVM, or on the
next kvm_arch_vcpu_ioctl_run() if an exit was required.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
 arch/powerpc/kvm/emulate_loadstore.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
index 077fd88a0b68..ec60c7979718 100644
--- a/arch/powerpc/kvm/emulate_loadstore.c
+++ b/arch/powerpc/kvm/emulate_loadstore.c
@@ -93,7 +93,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 
 	emulated = EMULATE_FAIL;
 	vcpu->arch.regs.msr = kvmppc_get_msr(vcpu);
-	kvmhv_nestedv2_reload_ptregs(vcpu, &vcpu->arch.regs);
 	if (analyse_instr(&op, &vcpu->arch.regs, inst) == 0) {
 		int type = op.type & INSTR_TYPE_MASK;
 		int size = GETSIZE(op.type);
@@ -112,7 +111,7 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 						op.reg, size, !instr_byte_swap);
 
 			if ((op.type & UPDATE) && (emulated != EMULATE_FAIL))
-				kvmppc_set_gpr(vcpu, op.update_reg, op.ea);
+				kvmppc_set_gpr(vcpu, op.update_reg, vcpu->arch.vaddr_accessed);
 
 			break;
 		}
@@ -132,7 +131,7 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 					     KVM_MMIO_REG_FPR|op.reg, size, 1);
 
 			if ((op.type & UPDATE) && (emulated != EMULATE_FAIL))
-				kvmppc_set_gpr(vcpu, op.update_reg, op.ea);
+				kvmppc_set_gpr(vcpu, op.update_reg, vcpu->arch.vaddr_accessed);
 
 			break;
 #endif
@@ -224,16 +223,17 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 			break;
 		}
 #endif
-		case STORE:
-			/* if need byte reverse, op.val has been reversed by
-			 * analyse_instr().
-			 */
-			emulated = kvmppc_handle_store(vcpu, op.val, size, 1);
+		case STORE: {
+			int instr_byte_swap = op.type & BYTEREV;
+
+			emulated = kvmppc_handle_store(vcpu, kvmppc_get_gpr(vcpu, op.reg),
+						       size, !instr_byte_swap);
 
 			if ((op.type & UPDATE) && (emulated != EMULATE_FAIL))
-				kvmppc_set_gpr(vcpu, op.update_reg, op.ea);
+				kvmppc_set_gpr(vcpu, op.update_reg, vcpu->arch.vaddr_accessed);
 
 			break;
+		}
 #ifdef CONFIG_PPC_FPU
 		case STORE_FP:
 			if (kvmppc_check_fp_disabled(vcpu))
@@ -254,7 +254,7 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 					kvmppc_get_fpr(vcpu, op.reg), size, 1);
 
 			if ((op.type & UPDATE) && (emulated != EMULATE_FAIL))
-				kvmppc_set_gpr(vcpu, op.update_reg, op.ea);
+				kvmppc_set_gpr(vcpu, op.update_reg, vcpu->arch.vaddr_accessed);
 
 			break;
 #endif
@@ -358,7 +358,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_ppc_instr(ppc_inst_val(inst), kvmppc_get_pc(vcpu), emulated);
-	kvmhv_nestedv2_mark_dirty_ptregs(vcpu, &vcpu->arch.regs);
 
 	/* Advance past emulated instruction. */
 	if (emulated != EMULATE_FAIL)
-- 
2.42.0


