Return-Path: <kvm+bounces-12679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48CA188BE30
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 10:45:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4B062E6418
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4A97580B;
	Tue, 26 Mar 2024 09:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jvcK/+3s"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCB274C19;
	Tue, 26 Mar 2024 09:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711446064; cv=none; b=rtFM2S33bJTNUxZa6dkdTke4f+CgM/hknwqr/JMJWk1B9+bDg2hUMfqUHQ1oFLavs/ajQ3H95c3GlWF6cjGZK2PHpBFEmZTq0k89ScIJvENB+IxhApceoDC+MMaKMDiRHo1cRTUwaNdvvUYXZahAnZk3mJGzlKt43/iO08TG+1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711446064; c=relaxed/simple;
	bh=Cw/bE4K9XFQGeeDIyZW+Sim5udJsATh2Y+3vzo/QpEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KzTZ71KR4yPqu4zI9y1OcS+bR9TKTIeeuyC2+z+aS6SXgLFtm/Xmv8xFtI9wPBhHTt+IMMTiNk54anZCniWcir9xgrvdompFIUQw4pazPAc0HXspVh1zyiUb9Gcq+4NZc7HH6YpRpDGjR4kTL4/ycP6KpuZfLYh9qfs0q7Iov8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jvcK/+3s; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q9N54i023600;
	Tue, 26 Mar 2024 09:40:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=uJNAJjKWdrahfVruhoFLG+c0CK4WQu5T+8th4lVOKTE=;
 b=jvcK/+3s3E6PP0XoYgJZKmJRu7hT7ifU6bayN6IasuSqgcNgmadgjZB17aKy/kYkS93v
 Y4iZWIz+FSNXPu+xR8zUIKduwOU48WexfFcLPuOnFViKOf7+IODJWjKFUphHxPlZxFkx
 OUR0BtJnbuk/85sn2CNaDGwN0s4ylrnaq/beN9S9SCgGJOk9xxLKTXe0wKp7dqCCva2+
 iA8CJ7XShLHac9DiMrj7kaXniXQgVnIrG4nLBmeJuABBPh9bcwOmBCgC2YXHZKxXro1M
 6RwQNilbm+3sWLvA58u/L8blt1DmIqKufjb3iN4LZs07N3aAD8VPxdOqOM1/4VqXLGDI aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x3svs0agy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 09:40:47 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42Q9ekc7015313;
	Tue, 26 Mar 2024 09:40:46 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x3svs0agv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 09:40:46 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q8Bb4g003804;
	Tue, 26 Mar 2024 09:40:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x2c42pcua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 09:40:45 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42Q9edBM49021324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 09:40:42 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A2A492004E;
	Tue, 26 Mar 2024 09:40:39 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C51CB20067;
	Tue, 26 Mar 2024 09:40:37 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Mar 2024 09:40:37 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: [PATCH v4] arch/powerpc/kvm: Add support for reading VPA counters for pseries guests
Date: Tue, 26 Mar 2024 15:10:34 +0530
Message-ID: <20240326094035.115835-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BAQ576wi2XwAlqW_H3TqgG1yWY80G5Bp
X-Proofpoint-ORIG-GUID: yCeQNG7Mp8v8A4QvUMBUqeyNm0qA3gRq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_04,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 adultscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260065

PAPR hypervisor has introduced three new counters in the VPA area of
LPAR CPUs for KVM L2 guest (see [1] for terminology) observability - 2
for context switches from host to guest and vice versa, and 1 counter
for getting the total time spent inside the KVM guest. Add a tracepoint
that enables reading the counters for use by ftrace/perf. Note that this
tracepoint is only available for nestedv2 API (i.e, KVM on PowerVM).

Also maintain an aggregation of the context switch times in vcpu->arch.
This will be useful in getting the aggregate times with a pmu driver
which will be upstreamed in the near future.

[1] Terminology:
a. L1 refers to the VM (LPAR) booted on top of PAPR hypervisor
b. L2 refers to the KVM guest booted on top of L1.

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
v1 -> v2:
1. Fix the build error due to invalid struct member reference.

v2 -> v3:
1. Move the counter disabling and zeroing code to a different function.
2. Move the get_lppaca() inside the tracepoint_enabled() branch.
3. Add the aggregation logic to maintain total context switch time.

v3 -> v4:
1. After vcpu_run, check the VPA flag instead of checking for tracepoint
being enabled for disabling the cs time accumulation.

 arch/powerpc/include/asm/kvm_host.h |  5 +++++
 arch/powerpc/include/asm/lppaca.h   | 11 ++++++++---
 arch/powerpc/kvm/book3s_hv.c        | 30 +++++++++++++++++++++++++++++
 arch/powerpc/kvm/trace_hv.h         | 25 ++++++++++++++++++++++++
 4 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 8abac5321..d953b32dd 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -847,6 +847,11 @@ struct kvm_vcpu_arch {
 	gpa_t nested_io_gpr;
 	/* For nested APIv2 guests*/
 	struct kvmhv_nestedv2_io nestedv2_io;
+
+	/* Aggregate context switch and guest run time info (in ns) */
+	u64 l1_to_l2_cs_agg;
+	u64 l2_to_l1_cs_agg;
+	u64 l2_runtime_agg;
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
index 8e86eb577..dcd6edd3b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4108,6 +4108,27 @@ static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void do_trace_nested_cs_time(struct kvm_vcpu *vcpu)
+{
+	struct lppaca *lp = get_lppaca();
+	u64 l1_to_l2_ns, l2_to_l1_ns, l2_runtime_ns;
+
+	l1_to_l2_ns = tb_to_ns(be64_to_cpu(lp->l1_to_l2_cs_tb));
+	l2_to_l1_ns = tb_to_ns(be64_to_cpu(lp->l2_to_l1_cs_tb));
+	l2_runtime_ns = tb_to_ns(be64_to_cpu(lp->l2_runtime_tb));
+	trace_kvmppc_vcpu_exit_cs_time(vcpu, l1_to_l2_ns, l2_to_l1_ns,
+					l2_runtime_ns);
+	lp->l1_to_l2_cs_tb = 0;
+	lp->l2_to_l1_cs_tb = 0;
+	lp->l2_runtime_tb = 0;
+	lp->l2_accumul_cntrs_enable = 0;
+
+	// Maintain an aggregate of context switch times
+	vcpu->arch.l1_to_l2_cs_agg += l1_to_l2_ns;
+	vcpu->arch.l2_to_l1_cs_agg += l2_to_l1_ns;
+	vcpu->arch.l2_runtime_agg += l2_runtime_ns;
+}
+
 static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 				     unsigned long lpcr, u64 *tb)
 {
@@ -4130,6 +4151,11 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 	kvmppc_gse_put_u64(io->vcpu_run_input, KVMPPC_GSID_LPCR, lpcr);
 
 	accumulate_time(vcpu, &vcpu->arch.in_guest);
+
+	/* Enable the guest host context switch time tracking */
+	if (unlikely(trace_kvmppc_vcpu_exit_cs_time_enabled()))
+		get_lppaca()->l2_accumul_cntrs_enable = 1;
+
 	rc = plpar_guest_run_vcpu(0, vcpu->kvm->arch.lpid, vcpu->vcpu_id,
 				  &trap, &i);
 
@@ -4156,6 +4182,10 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	timer_rearm_host_dec(*tb);
 
+	/* Record context switch and guest_run_time data */
+	if (get_lppaca()->l2_accumul_cntrs_enable)
+		do_trace_nested_cs_time(vcpu);
+
 	return trap;
 }
 
diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
index 8d57c8428..ab19977c9 100644
--- a/arch/powerpc/kvm/trace_hv.h
+++ b/arch/powerpc/kvm/trace_hv.h
@@ -491,6 +491,31 @@ TRACE_EVENT(kvmppc_run_vcpu_enter,
 	TP_printk("VCPU %d: tgid=%d", __entry->vcpu_id, __entry->tgid)
 );
 
+TRACE_EVENT(kvmppc_vcpu_exit_cs_time,
+	TP_PROTO(struct kvm_vcpu *vcpu, u64 l1_to_l2_cs, u64 l2_to_l1_cs,
+		u64 l2_runtime),
+
+	TP_ARGS(vcpu, l1_to_l2_cs, l2_to_l1_cs, l2_runtime),
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
+		__entry->l1_to_l2_cs_ns = l1_to_l2_cs;
+		__entry->l2_to_l1_cs_ns = l2_to_l1_cs;
+		__entry->l2_runtime_ns = l2_runtime;
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


