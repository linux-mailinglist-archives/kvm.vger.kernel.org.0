Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42C83D5C8F
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 17:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhGZOVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 10:21:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46004 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234778AbhGZOU6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 10:20:58 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QEXKgZ144035;
        Mon, 26 Jul 2021 11:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=OffdIqJ+r+X2rMyjYweT1j0nDqkUu9wy0qgWcF//4ZU=;
 b=fL/p3N8B2i3+z+DaXv/4iU26fAahvOwCZFyTGgEQlphn3HYoSebOF4a4LLHX42J6yX8P
 bjduw6UR6My7B7u3DqsZ6CvU5ofGcY8SRB7CmrNDUr8HEkop7HjLFaIbZDZkUaPhi+PI
 FapUh7ernsCG1stMjwpCtNl98MlN01o8aI4EBZIH4dqM3FDQ8R1T4RcGv4wUy9c+/90W
 AVdBAki2UrPuVw3wILGfdUMFpl88R2yl5EJRfFDTNa0HztUCv8A/fVd+vqlzr3gZNnyC
 Y/DfdcleJJ4jESbIhamQY7Hrrr1tX33+mFZP0nkwM+LEPpYKZmYfejudCCOfpzNdI6nm sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a1vvenyev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 11:01:23 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16QEXMQ3144374;
        Mon, 26 Jul 2021 11:01:23 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a1vvenycr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 11:01:23 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16QEri0G021425;
        Mon, 26 Jul 2021 15:01:13 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3a0a4hh4n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 15:01:13 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16QF1AU714483834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 15:01:10 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01DC852052;
        Mon, 26 Jul 2021 15:01:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id D9DAC5204E;
        Mon, 26 Jul 2021 15:01:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 84878E0228; Mon, 26 Jul 2021 17:01:09 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     KVM <kvm@vger.kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: [PATCH] KVM: s390: restore old debugfs names
Date:   Mon, 26 Jul 2021 17:01:08 +0200
Message-Id: <20210726150108.5603-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DbsYLbRn8XLx27Qdf3g4BV2j_Ln3feHu
X-Proofpoint-ORIG-GUID: KWkUJCbuhz-unTOkD1T6MAx_QwKdbKDe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-26_06:2021-07-26,2021-07-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
did replace the old definitions with the binary ones. While doing that
it missed that some files are names different than the counters. This
is especially important for kvm_stat which does have special handling
for counters named instruction_*.

Fixes: commit bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
CC: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 18 +++++++++---------
 arch/s390/kvm/diag.c             | 18 +++++++++---------
 arch/s390/kvm/kvm-s390.c         | 18 +++++++++---------
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3a5b5084cdbe..f1a202327ebd 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -446,15 +446,15 @@ struct kvm_vcpu_stat {
 	u64 instruction_sigp_init_cpu_reset;
 	u64 instruction_sigp_cpu_reset;
 	u64 instruction_sigp_unknown;
-	u64 diagnose_10;
-	u64 diagnose_44;
-	u64 diagnose_9c;
-	u64 diagnose_9c_ignored;
-	u64 diagnose_9c_forward;
-	u64 diagnose_258;
-	u64 diagnose_308;
-	u64 diagnose_500;
-	u64 diagnose_other;
+	u64 instruction_diagnose_10;
+	u64 instruction_diagnose_44;
+	u64 instruction_diagnose_9c;
+	u64 diag_9c_ignored;
+	u64 diag_9c_forward;
+	u64 instruction_diagnose_258;
+	u64 instruction_diagnose_308;
+	u64 instruction_diagnose_500;
+	u64 instruction_diagnose_other;
 	u64 pfault_sync;
 };
 
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 02c146f9e5cd..807fa9da1e72 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -24,7 +24,7 @@ static int diag_release_pages(struct kvm_vcpu *vcpu)
 
 	start = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
 	end = vcpu->run->s.regs.gprs[vcpu->arch.sie_block->ipa & 0xf] + PAGE_SIZE;
-	vcpu->stat.diagnose_10++;
+	vcpu->stat.instruction_diagnose_10++;
 
 	if (start & ~PAGE_MASK || end & ~PAGE_MASK || start >= end
 	    || start < 2 * PAGE_SIZE)
@@ -74,7 +74,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
 
 	VCPU_EVENT(vcpu, 3, "diag page reference parameter block at 0x%llx",
 		   vcpu->run->s.regs.gprs[rx]);
-	vcpu->stat.diagnose_258++;
+	vcpu->stat.instruction_diagnose_258++;
 	if (vcpu->run->s.regs.gprs[rx] & 7)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 	rc = read_guest(vcpu, vcpu->run->s.regs.gprs[rx], rx, &parm, sizeof(parm));
@@ -145,7 +145,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
 static int __diag_time_slice_end(struct kvm_vcpu *vcpu)
 {
 	VCPU_EVENT(vcpu, 5, "%s", "diag time slice end");
-	vcpu->stat.diagnose_44++;
+	vcpu->stat.instruction_diagnose_44++;
 	kvm_vcpu_on_spin(vcpu, true);
 	return 0;
 }
@@ -169,7 +169,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 	int tid;
 
 	tid = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
-	vcpu->stat.diagnose_9c++;
+	vcpu->stat.instruction_diagnose_9c++;
 
 	/* yield to self */
 	if (tid == vcpu->vcpu_id)
@@ -192,7 +192,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 		VCPU_EVENT(vcpu, 5,
 			   "diag time slice end directed to %d: yield forwarded",
 			   tid);
-		vcpu->stat.diagnose_9c_forward++;
+		vcpu->stat.diag_9c_forward++;
 		return 0;
 	}
 
@@ -203,7 +203,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 	return 0;
 no_yield:
 	VCPU_EVENT(vcpu, 5, "diag time slice end directed to %d: ignored", tid);
-	vcpu->stat.diagnose_9c_ignored++;
+	vcpu->stat.diag_9c_ignored++;
 	return 0;
 }
 
@@ -213,7 +213,7 @@ static int __diag_ipl_functions(struct kvm_vcpu *vcpu)
 	unsigned long subcode = vcpu->run->s.regs.gprs[reg] & 0xffff;
 
 	VCPU_EVENT(vcpu, 3, "diag ipl functions, subcode %lx", subcode);
-	vcpu->stat.diagnose_308++;
+	vcpu->stat.instruction_diagnose_308++;
 	switch (subcode) {
 	case 3:
 		vcpu->run->s390_reset_flags = KVM_S390_RESET_CLEAR;
@@ -245,7 +245,7 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	vcpu->stat.diagnose_500++;
+	vcpu->stat.instruction_diagnose_500++;
 	/* No virtio-ccw notification? Get out quickly. */
 	if (!vcpu->kvm->arch.css_support ||
 	    (vcpu->run->s.regs.gprs[1] != KVM_S390_VIRTIO_CCW_NOTIFY))
@@ -299,7 +299,7 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
 	case 0x500:
 		return __diag_virtio_hypercall(vcpu);
 	default:
-		vcpu->stat.diagnose_other++;
+		vcpu->stat.instruction_diagnose_other++;
 		return -EOPNOTSUPP;
 	}
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 7675b72a3ddf..01925ef78518 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -163,15 +163,15 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, instruction_sigp_init_cpu_reset),
 	STATS_DESC_COUNTER(VCPU, instruction_sigp_cpu_reset),
 	STATS_DESC_COUNTER(VCPU, instruction_sigp_unknown),
-	STATS_DESC_COUNTER(VCPU, diagnose_10),
-	STATS_DESC_COUNTER(VCPU, diagnose_44),
-	STATS_DESC_COUNTER(VCPU, diagnose_9c),
-	STATS_DESC_COUNTER(VCPU, diagnose_9c_ignored),
-	STATS_DESC_COUNTER(VCPU, diagnose_9c_forward),
-	STATS_DESC_COUNTER(VCPU, diagnose_258),
-	STATS_DESC_COUNTER(VCPU, diagnose_308),
-	STATS_DESC_COUNTER(VCPU, diagnose_500),
-	STATS_DESC_COUNTER(VCPU, diagnose_other),
+	STATS_DESC_COUNTER(VCPU, instruction_diagnose_10),
+	STATS_DESC_COUNTER(VCPU, instruction_diagnose_44),
+	STATS_DESC_COUNTER(VCPU, instruction_diagnose_9c),
+	STATS_DESC_COUNTER(VCPU, diag_9c_ignored),
+	STATS_DESC_COUNTER(VCPU, diag_9c_forward),
+	STATS_DESC_COUNTER(VCPU, instruction_diagnose_258),
+	STATS_DESC_COUNTER(VCPU, instruction_diagnose_308),
+	STATS_DESC_COUNTER(VCPU, instruction_diagnose_500),
+	STATS_DESC_COUNTER(VCPU, instruction_diagnose_other),
 	STATS_DESC_COUNTER(VCPU, pfault_sync)
 };
 static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-- 
2.31.1

