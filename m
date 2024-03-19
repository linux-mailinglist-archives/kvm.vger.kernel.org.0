Return-Path: <kvm+bounces-12144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0824987FF9B
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 15:28:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C2311F22461
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF9E81ABA;
	Tue, 19 Mar 2024 14:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fqy/iEfT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE8E81AA7;
	Tue, 19 Mar 2024 14:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710858519; cv=none; b=eTe54tKnEjWFjfk09LdZGWo27l6KJXr8H9RlKMGLvK1b2DtHQbofqUhEoK+ZLGGJPB58FzVSECk8pPRvBYGTI4V5PKAuLrk6gXNkQV/szUe+015UAP4nI+L7e6iGbxz4md0L4uaFZKWjiQxN6rLe6C60D+RF/0FRfWNS1E2AmgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710858519; c=relaxed/simple;
	bh=Dl20teuF0LcyaprwKl4zkyFxg7kNAs+oNxyc1Ln7iF0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XqykYqyVAs1d8p1eZotIFD7oHl572HmvrCSzmNFpPRxr5L2REso7MBjPpksE5DT0vAtoxEtKb9PD94SH441L5H4+euCpUlJ9lq59BjksWxG10dobFANflGkTXQ3mIzxs9pMWfs+W9s/AgKlrc9DGOk+PkZ7OeaZnowiOi12d42c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fqy/iEfT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42JEQcbe023407;
	Tue, 19 Mar 2024 14:28:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=VXexiXBKopZYjzbOhqUXZ+UbaH9CdHlMt8VeoGUFPvg=;
 b=fqy/iEfTzbQskEzrVIId4HL6XZ6YWk71MpEnqFsLWw5zDCtDKRKwrPomfpqr733jz8CS
 5I22Lk76Hgo+BO+qeuki5BMjWLSAeH+USslSYaN9Gi2CJgUBqet4Mta1/sgI+mpQTgOT
 8+h8YiqppzwUSQ5zQjfdI9QTpwAbCm1ks37Y3VWxF2zMIsNlX2Xl+FMZS0+SFEP3Z7wp
 J+OLC0537DGRE2h9bJq8JkiG93Wge8tK/J69+dLdvdEOV/e9bgHpgk/xei1wfYxN3Ifu
 f7/W+QUqyUbQDaybSHhH6FGUZ6q1PxAk7xRGD8FLiyHpU2dZ2ygROv7HfRH1eBjolnwo Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wyb39rnqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 14:28:18 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42JESIhi027738;
	Tue, 19 Mar 2024 14:28:18 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wyb39rnqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 14:28:18 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42JCbUFY019843;
	Tue, 19 Mar 2024 14:28:17 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wwqykftet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 14:28:17 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42JESBdY17367448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Mar 2024 14:28:13 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B8A82004E;
	Tue, 19 Mar 2024 14:28:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AACA920043;
	Tue, 19 Mar 2024 14:28:09 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Mar 2024 14:28:09 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: [PATCH] arch/powerpc/kvm: Add support for reading VPA counters for pseries guests
Date: Tue, 19 Mar 2024 19:58:04 +0530
Message-ID: <20240319142807.95547-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J8x6r8YAIRMIrqFXNi6zJfskGvl25iTG
X-Proofpoint-ORIG-GUID: OPxV9XhGccYgCGoYTruZ4lgh7ZSTpv4V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-19_04,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403190109

PAPR hypervisor has introduced three new counters in the VPA area of
LPAR CPUs for KVM L2 guest (see [1] for terminology) observability - 2
for context switches from host to guest and vice versa, and 1 counter
for getting the total time spent inside the KVM guest. Add a tracepoint
that enables reading the counters for use by ftrace/perf. Note that this
tracepoint is only available for nestedv2 API (i.e, KVM on PowerVM).

[1] Terminology:
a. L1 refers to the VM (LPAR) booted on top of PAPR hypervisor
b. L2 refers to the KVM guest booted on top of L1.

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_host.h |  5 +++++
 arch/powerpc/include/asm/lppaca.h   | 11 ++++++++---
 arch/powerpc/kvm/book3s_hv.c        | 20 ++++++++++++++++++++
 arch/powerpc/kvm/trace_hv.h         | 24 ++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 8abac5321..26d7bb4b9 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -847,6 +847,11 @@ struct kvm_vcpu_arch {
 	gpa_t nested_io_gpr;
 	/* For nested APIv2 guests*/
 	struct kvmhv_nestedv2_io nestedv2_io;
+
+	/* For VPA counters having context switch and guest run time info (in ns) */
+	u64 l1_to_l2_cs;
+	u64 l2_to_l1_cs;
+	u64 l2_runtime;
 #endif
 
 #ifdef CONFIG_KVM_BOOK3S_HV_EXIT_TIMING
diff --git a/arch/powerpc/include/asm/lppaca.h b/arch/powerpc/include/asm/lppaca.h
index 61ec2447d..bda6b86b9 100644
--- a/arch/powerpc/include/asm/lppaca.h
+++ b/arch/powerpc/include/asm/lppaca.h
@@ -62,7 +62,8 @@ struct lppaca {
 	u8	donate_dedicated_cpu;	/* Donate dedicated CPU cycles */
 	u8	fpregs_in_use;
 	u8	pmcregs_in_use;
-	u8	reserved8[28];
+	u8	l2_accumul_cntrs_enable;  /* Enable usage of counters for KVM guest */
+	u8	reserved8[27];
 	__be64	wait_state_cycles;	/* Wait cycles for this proc */
 	u8	reserved9[28];
 	__be16	slb_count;		/* # of SLBs to maintain */
@@ -92,9 +93,13 @@ struct lppaca {
 	/* cacheline 4-5 */
 
 	__be32	page_ins;		/* CMO Hint - # page ins by OS */
-	u8	reserved12[148];
+	u8	reserved12[28];
+	volatile __be64 l1_to_l2_cs_tb;
+	volatile __be64 l2_to_l1_cs_tb;
+	volatile __be64 l2_runtime_tb;
+	u8 reserved13[96];
 	volatile __be64 dtl_idx;	/* Dispatch Trace Log head index */
-	u8	reserved13[96];
+	u8	reserved14[96];
 } ____cacheline_aligned;
 
 #define lppaca_of(cpu)	(*paca_ptrs[cpu]->lppaca_ptr)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2b04eba90..b94461b5f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4092,6 +4092,7 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 	unsigned long msr, i;
 	int trap;
 	long rc;
+	struct lppaca *lp = get_lppaca();
 
 	io = &vcpu->arch.nestedv2_io;
 
@@ -4107,6 +4108,17 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 	kvmppc_gse_put_u64(io->vcpu_run_input, KVMPPC_GSID_LPCR, lpcr);
 
 	accumulate_time(vcpu, &vcpu->arch.in_guest);
+
+	/* Reset the guest host context switch timing */
+	if (unlikely(trace_kvmppc_vcpu_exit_cs_time_enabled())) {
+		lp->l2_accumul_cntrs_enable = 1;
+		lp->l1_to_l2_cs_tb = 0;
+		lp->l2_to_l1_cs_tb = 0;
+		lp->l2_runtime_tb = 0;
+	} else {
+		lp->l2_accumul_cntrs_enable = 0;
+	}
+
 	rc = plpar_guest_run_vcpu(0, vcpu->kvm->arch.lpid, vcpu->vcpu_id,
 				  &trap, &i);
 
@@ -4133,6 +4145,14 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	timer_rearm_host_dec(*tb);
 
+	/* Record context switch and guest_run_time data */
+	if (unlikely(trace_kvmppc_vcpu_exit_cs_time_enabled())) {
+		vcpu->arch.l1_to_l2_cs = tb_to_ns(be64_to_cpu(lp->l1_to_l2_cs_tb));
+		vcpu->arch.l2_to_l1_cs = tb_to_ns(be64_to_cpu(lp->l2_to_l1_cs_tb));
+		vcpu->arch.l2_runtime = tb_to_ns(be64_to_cpu(lp->l2_runtime_tb));
+		trace_kvmppc_vcpu_exit_cs_time(vcpu);
+	}
+
 	return trap;
 }
 
diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
index 8d57c8428..10b8f6e5a 100644
--- a/arch/powerpc/kvm/trace_hv.h
+++ b/arch/powerpc/kvm/trace_hv.h
@@ -491,6 +491,30 @@ TRACE_EVENT(kvmppc_run_vcpu_enter,
 	TP_printk("VCPU %d: tgid=%d", __entry->vcpu_id, __entry->tgid)
 );
 
+TRACE_EVENT(kvmppc_vcpu_exit_cs_time,
+	TP_PROTO(struct kvm_vcpu *vcpu),
+
+	TP_ARGS(vcpu),
+
+	TP_STRUCT__entry(
+		__field(int,		vcpu_id)
+		__field(__u64,		l1_to_l2_cs_ns)
+		__field(__u64,		l2_to_l1_cs_ns)
+		__field(__u64,		l2_runtime_ns)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id  = vcpu->vcpu_id;
+		__entry->l1_to_l2_cs_ns = vcpu->arch.l1_to_l2_cs;
+		__entry->l2_to_l1_cs_ns = vcpu->arch.l2_to_l1_cs;
+		__entry->l2_runtime_ns = vcpu->l2_runtime;
+	),
+
+	TP_printk("VCPU %d: l1_to_l2_cs_time=%llu-ns l2_to_l1_cs_time=%llu-ns l2_runtime=%llu-ns",
+		__entry->vcpu_id,  __entry->l1_to_l2_cs_ns,
+		__entry->l2_to_l1_cs_ns, __entry->l2_runtime_ns)
+);
+
 TRACE_EVENT(kvmppc_run_vcpu_exit,
 	TP_PROTO(struct kvm_vcpu *vcpu),
 
-- 
2.43.2


