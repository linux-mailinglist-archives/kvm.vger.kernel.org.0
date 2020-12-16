Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A902DBF23
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 12:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgLPLBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 06:01:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgLPLBP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 06:01:15 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGAgrtC079946;
        Wed, 16 Dec 2020 05:44:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YhDFzmQUoC8UQuz1UgKN1pr7/sypnPEqm7ZijMJFeYY=;
 b=KdPLmPhUS8+MCjjJt4vEI7D+2gdz800Dxzcttti7myx0jaFCHZxoW4bpOgZF5+nYbBEN
 t1Sm5NXSt0bzKht11HySAynpOOKlkC7RYvF73mu7V9X6reshAP5lAmsdbZGZa566E0Pm
 +6TRjoG+pm7wpD6RHiP7Qk4sZk0NteGwirV7ZqvuR+bFM3YDe/FYVkp9Hal1Jg3kx8v+
 jBZ0leeShSa5aRJ+slI+lABKQgtG0sodtcqto+zed6CeNXNK8SUpKtBHLvoPkXZA8HQE
 sMU0OF/SGHedUhzbVw8Gf64bBS4rbrVUKO9mlZuwBATgcs02BWeiMcGq/06wQEJVNdwx tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fgqr812w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 05:44:35 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGAiYCh083723;
        Wed, 16 Dec 2020 05:44:35 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fgqr8123-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 05:44:34 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGAhECE012676;
        Wed, 16 Dec 2020 10:44:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8e78n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 10:44:32 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGAhFlJ30015750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 10:43:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42A2011C05C;
        Wed, 16 Dec 2020 10:43:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1A2511C04C;
        Wed, 16 Dec 2020 10:43:11 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.41.249])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 10:43:11 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     mpe@ellerman.id.au, paulus@samba.org
Cc:     ravi.bangoria@linux.ibm.com, mikey@neuling.org, npiggin@gmail.com,
        leobras.c@gmail.com, pbonzini@redhat.com, christophe.leroy@c-s.fr,
        jniethe5@gmail.com, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 1/4] KVM: PPC: Allow nested guest creation when L0 hv_guest_state > L1
Date:   Wed, 16 Dec 2020 16:12:16 +0530
Message-Id: <20201216104219.458713-2-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201216104219.458713-1-ravi.bangoria@linux.ibm.com>
References: <20201216104219.458713-1-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_04:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On powerpc, L1 hypervisor takes help of L0 using H_ENTER_NESTED
hcall to load L2 guest state in cpu. L1 hypervisor prepares the
L2 state in struct hv_guest_state and passes a pointer to it via
hcall. Using that pointer, L0 reads/writes that state directly
from/to L1 memory. Thus L0 must be aware of hv_guest_state layout
of L1. Currently it uses version field to achieve this. i.e. If
L0 hv_guest_state.version != L1 hv_guest_state.version, L0 won't
allow nested kvm guest.

This restriction can be loosen up a bit. L0 can be taught to
understand older layout of hv_guest_state, if we restrict the
new member to be added only at the end. i.e. we can allow
nested guest even when L0 hv_guest_state.version > L1
hv_guest_state.version. Though, the other way around is not
possible.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/include/asm/hvcall.h   | 17 +++++++--
 arch/powerpc/kvm/book3s_hv_nested.c | 55 +++++++++++++++++++++++------
 2 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index c1fbccb04390..ca6840239f90 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -526,9 +526,12 @@ struct h_cpu_char_result {
 	u64 behaviour;
 };
 
-/* Register state for entering a nested guest with H_ENTER_NESTED */
+/*
+ * Register state for entering a nested guest with H_ENTER_NESTED.
+ * New member must be added at the end.
+ */
 struct hv_guest_state {
-	u64 version;		/* version of this structure layout */
+	u64 version;		/* version of this structure layout, must be first */
 	u32 lpid;
 	u32 vcpu_token;
 	/* These registers are hypervisor privileged (at least for writing) */
@@ -562,6 +565,16 @@ struct hv_guest_state {
 /* Latest version of hv_guest_state structure */
 #define HV_GUEST_STATE_VERSION	1
 
+static inline int hv_guest_state_size(unsigned int version)
+{
+	switch (version) {
+	case 1:
+		return offsetofend(struct hv_guest_state, ppr);
+	default:
+		return -1;
+	}
+}
+
 /*
  * From the document "H_GetPerformanceCounterInfo Interface" v1.07
  *
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 33b58549a9aa..937dd5114300 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -215,12 +215,51 @@ static void kvmhv_nested_mmio_needed(struct kvm_vcpu *vcpu, u64 regs_ptr)
 	}
 }
 
+static int kvmhv_read_guest_state_and_regs(struct kvm_vcpu *vcpu,
+					   struct hv_guest_state *l2_hv,
+					   struct pt_regs *l2_regs,
+					   u64 hv_ptr, u64 regs_ptr)
+{
+	int size;
+
+	if (kvm_vcpu_read_guest(vcpu, hv_ptr, &l2_hv->version,
+				sizeof(l2_hv->version)))
+		return -1;
+
+	if (kvmppc_need_byteswap(vcpu))
+		l2_hv->version = swab64(l2_hv->version);
+
+	size = hv_guest_state_size(l2_hv->version);
+	if (size < 0)
+		return -1;
+
+	return kvm_vcpu_read_guest(vcpu, hv_ptr, l2_hv, size) ||
+		kvm_vcpu_read_guest(vcpu, regs_ptr, l2_regs,
+				    sizeof(struct pt_regs));
+}
+
+static int kvmhv_write_guest_state_and_regs(struct kvm_vcpu *vcpu,
+					    struct hv_guest_state *l2_hv,
+					    struct pt_regs *l2_regs,
+					    u64 hv_ptr, u64 regs_ptr)
+{
+	int size;
+
+	size = hv_guest_state_size(l2_hv->version);
+	if (size < 0)
+		return -1;
+
+	return kvm_vcpu_write_guest(vcpu, hv_ptr, l2_hv, size) ||
+		kvm_vcpu_write_guest(vcpu, regs_ptr, l2_regs,
+				     sizeof(struct pt_regs));
+}
+
 long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 {
 	long int err, r;
 	struct kvm_nested_guest *l2;
 	struct pt_regs l2_regs, saved_l1_regs;
-	struct hv_guest_state l2_hv, saved_l1_hv;
+	struct hv_guest_state l2_hv = {0}, saved_l1_hv;
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	u64 hv_ptr, regs_ptr;
 	u64 hdec_exp;
@@ -235,17 +274,15 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	hv_ptr = kvmppc_get_gpr(vcpu, 4);
 	regs_ptr = kvmppc_get_gpr(vcpu, 5);
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-	err = kvm_vcpu_read_guest(vcpu, hv_ptr, &l2_hv,
-				  sizeof(struct hv_guest_state)) ||
-		kvm_vcpu_read_guest(vcpu, regs_ptr, &l2_regs,
-				    sizeof(struct pt_regs));
+	err = kvmhv_read_guest_state_and_regs(vcpu, &l2_hv, &l2_regs,
+					      hv_ptr, regs_ptr);
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	if (err)
 		return H_PARAMETER;
 
 	if (kvmppc_need_byteswap(vcpu))
 		byteswap_hv_regs(&l2_hv);
-	if (l2_hv.version != HV_GUEST_STATE_VERSION)
+	if (l2_hv.version > HV_GUEST_STATE_VERSION)
 		return H_P2;
 
 	if (kvmppc_need_byteswap(vcpu))
@@ -325,10 +362,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 		byteswap_pt_regs(&l2_regs);
 	}
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-	err = kvm_vcpu_write_guest(vcpu, hv_ptr, &l2_hv,
-				   sizeof(struct hv_guest_state)) ||
-		kvm_vcpu_write_guest(vcpu, regs_ptr, &l2_regs,
-				   sizeof(struct pt_regs));
+	err = kvmhv_write_guest_state_and_regs(vcpu, &l2_hv, &l2_regs,
+					       hv_ptr, regs_ptr);
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	if (err)
 		return H_AUTHORITY;
-- 
2.26.2

