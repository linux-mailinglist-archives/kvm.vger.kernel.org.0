Return-Path: <kvm+bounces-16731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC5FF8BD0ED
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 17:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 196D21C21A7E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 15:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B803B154455;
	Mon,  6 May 2024 14:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f3eRr83a"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC434381AA;
	Mon,  6 May 2024 14:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715007596; cv=none; b=Vp15x/3jDnX+RzLnLt727EkZkRs4jbYUYm/HqeN7nWgvQ9fV9mTeukRpURjlblvJaxQaeCOeiFRDyi7HC3PsuHd0CsqLcLMklr2Gz8TvNnQ59HUGK4YzV5MVTnJRf5itEDSHL8Jj4dEg5dAxiWlPrGq3Z33bjPkZRBMKz9C0w5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715007596; c=relaxed/simple;
	bh=H18mNLmvZtvZuBcMKiw8Us9+FxIZv5dUWJks16b1Jpg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NM5c2mLRnKkyqmfIqsirY5e6YeycQWg4k/VsZ5H/J/SRrnicAVr7cgGu5vydCZIvwcDx9p/ejLNDHR6cFkFoGIrc2bn1qvsxoqse1UfYulnhsGRY1uz2v+3oFYEavonP5nzYjoXOsTWqlsatrXmTcaEx8qXwCKCQj3n+wr4tqdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f3eRr83a; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446Ejogd016183;
	Mon, 6 May 2024 14:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ufcz7t0A1piBkd98O1lYvjfNAwGIZPGvOFFEF4WTtt4=;
 b=f3eRr83aHzgGXnJNPYPYA1s88cDKGilTckPbheVeiZoL2vQkWu/+mc952fDSeJ9ebVED
 KpXwZYF8NKOQxPkTNuP66PNI2apIv+GA/aneK68UK/WbVVI3grSI0vm51XKZ13AiPpvD
 KhgKVeO36iXSwUa4Z21fNiZaxce5PheTkVBW+lT1fZ9RHvSrY7XEJppD934qHYBTxbtI
 HWm3dSyimkmcIWBDAMWri4MzNB2+Yrll9NrWhqsXh7x9nGtjdFslip7UywMMPsRNZkxl
 uAkSPEpEpr1QytRptzHo4lndpFAyCaIGq+SvMsdncI7CNPSOCHH4ccP262fD2q3OrOEv dA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy18hg13d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 14:59:44 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446EtefX000382;
	Mon, 6 May 2024 14:59:43 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy18hg119-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 14:59:43 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446EYwI2030885;
	Mon, 6 May 2024 14:56:19 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xwybtrqts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 14:56:19 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446EuEft54460696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 14:56:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4286720043;
	Mon,  6 May 2024 14:56:14 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD23D20040;
	Mon,  6 May 2024 14:56:10 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.43.105.31])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 May 2024 14:56:10 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: [PATCH v6] arch/powerpc/kvm: Add support for reading VPA counters for pseries guests
Date: Mon,  6 May 2024 20:26:03 +0530
Message-ID: <20240506145605.73794-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I6-OMug5WjhJXyE88WJrPOqnlzUhHrLG
X-Proofpoint-GUID: JQASrrDOMa-FNKqtEyYUyNjW6SXSAS3q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_09,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2405060102

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
v5 -> v6:
1. Use TRACE_EVENT_FN to enable/disable counters only once.
2. Remove the agg. counters from vcpu->arch.
3. Use PACA to maintain old counter values instead of zeroing on every
entry.
4. Simplify variable names

v4 -> v5:
1. Define helper functions for getting/setting the accumulation counter
in L2's VPA

v3 -> v4:
1. After vcpu_run, check the VPA flag instead of checking for tracepoint
being enabled for disabling the cs time accumulation.

v2 -> v3:
1. Move the counter disabling and zeroing code to a different function.
2. Move the get_lppaca() inside the tracepoint_enabled() branch.
3. Add the aggregation logic to maintain total context switch time.

v1 -> v2:
1. Fix the build error due to invalid struct member reference.

 arch/powerpc/include/asm/lppaca.h | 11 +++++--
 arch/powerpc/include/asm/paca.h   |  5 +++
 arch/powerpc/kvm/book3s_hv.c      | 52 +++++++++++++++++++++++++++++++
 arch/powerpc/kvm/trace_hv.h       | 27 ++++++++++++++++
 4 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/lppaca.h b/arch/powerpc/include/asm/lppaca.h
index 61ec2447dabf..f40a646bee3c 100644
--- a/arch/powerpc/include/asm/lppaca.h
+++ b/arch/powerpc/include/asm/lppaca.h
@@ -62,7 +62,8 @@ struct lppaca {
 	u8	donate_dedicated_cpu;	/* Donate dedicated CPU cycles */
 	u8	fpregs_in_use;
 	u8	pmcregs_in_use;
-	u8	reserved8[28];
+	u8	l2_counters_enable;  /* Enable usage of counters for KVM guest */
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
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 1d58da946739..f20ac7a6efa4 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -278,6 +278,11 @@ struct paca_struct {
 	struct mce_info *mce_info;
 	u8 mce_pending_irq_work;
 #endif /* CONFIG_PPC_BOOK3S_64 */
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	u64 l1_to_l2_cs;
+	u64 l2_to_l1_cs;
+	u64 l2_runtime_agg;
+#endif
 } ____cacheline_aligned;
 
 extern void copy_mm_to_paca(struct mm_struct *mm);
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8e86eb577eb8..ed69ad58bd02 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4108,6 +4108,54 @@ static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
 	}
 }
 
+static inline int kvmhv_get_l2_counters_status(void)
+{
+	return get_lppaca()->l2_counters_enable;
+}
+
+static inline void kvmhv_set_l2_counters_status(int cpu, bool status)
+{
+	if (status)
+		lppaca_of(cpu).l2_counters_enable = 1;
+	else
+		lppaca_of(cpu).l2_counters_enable = 0;
+}
+
+int kmvhv_counters_tracepoint_regfunc(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		kvmhv_set_l2_counters_status(cpu, true);
+	}
+	return 0;
+}
+
+void kmvhv_counters_tracepoint_unregfunc(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		kvmhv_set_l2_counters_status(cpu, false);
+	}
+}
+
+static void do_trace_nested_cs_time(struct kvm_vcpu *vcpu)
+{
+	struct lppaca *lp = get_lppaca();
+	u64 l1_to_l2_ns, l2_to_l1_ns, l2_runtime_ns;
+
+	l1_to_l2_ns = tb_to_ns(be64_to_cpu(lp->l1_to_l2_cs_tb));
+	l2_to_l1_ns = tb_to_ns(be64_to_cpu(lp->l2_to_l1_cs_tb));
+	l2_runtime_ns = tb_to_ns(be64_to_cpu(lp->l2_runtime_tb));
+	trace_kvmppc_vcpu_stats(vcpu, l1_to_l2_ns - local_paca->l1_to_l2_cs,
+					l2_to_l1_ns - local_paca->l2_to_l1_cs,
+					l2_runtime_ns - local_paca->l2_runtime_agg);
+	local_paca->l1_to_l2_cs = l1_to_l2_ns;
+	local_paca->l2_to_l1_cs = l2_to_l1_ns;
+	local_paca->l2_runtime_agg = l2_runtime_ns;
+}
+
 static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 				     unsigned long lpcr, u64 *tb)
 {
@@ -4156,6 +4204,10 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	timer_rearm_host_dec(*tb);
 
+	/* Record context switch and guest_run_time data */
+	if (kvmhv_get_l2_counters_status())
+		do_trace_nested_cs_time(vcpu);
+
 	return trap;
 }
 
diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
index 8d57c8428531..dc118ab88f23 100644
--- a/arch/powerpc/kvm/trace_hv.h
+++ b/arch/powerpc/kvm/trace_hv.h
@@ -238,6 +238,9 @@
 	{H_MULTI_THREADS_ACTIVE,	"H_MULTI_THREADS_ACTIVE"}, \
 	{H_OUTSTANDING_COP_OPS,		"H_OUTSTANDING_COP_OPS"}
 
+int kmvhv_counters_tracepoint_regfunc(void);
+void kmvhv_counters_tracepoint_unregfunc(void);
+
 TRACE_EVENT(kvm_guest_enter,
 	TP_PROTO(struct kvm_vcpu *vcpu),
 	TP_ARGS(vcpu),
@@ -512,6 +515,30 @@ TRACE_EVENT(kvmppc_run_vcpu_exit,
 			__entry->vcpu_id, __entry->exit, __entry->ret)
 );
 
+TRACE_EVENT_FN(kvmppc_vcpu_stats,
+	TP_PROTO(struct kvm_vcpu *vcpu, u64 l1_to_l2_cs, u64 l2_to_l1_cs, u64 l2_runtime),
+
+	TP_ARGS(vcpu, l1_to_l2_cs, l2_to_l1_cs, l2_runtime),
+
+	TP_STRUCT__entry(
+		__field(int,		vcpu_id)
+		__field(u64,		l1_to_l2_cs)
+		__field(u64,		l2_to_l1_cs)
+		__field(u64,		l2_runtime)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id  = vcpu->vcpu_id;
+		__entry->l1_to_l2_cs = l1_to_l2_cs;
+		__entry->l2_to_l1_cs = l2_to_l1_cs;
+		__entry->l2_runtime = l2_runtime;
+	),
+
+	TP_printk("VCPU %d: l1_to_l2_cs_time=%llu ns l2_to_l1_cs_time=%llu ns l2_runtime=%llu ns",
+		__entry->vcpu_id,  __entry->l1_to_l2_cs,
+		__entry->l2_to_l1_cs, __entry->l2_runtime),
+	kmvhv_counters_tracepoint_regfunc, kmvhv_counters_tracepoint_unregfunc
+);
 #endif /* _TRACE_KVM_HV_H */
 
 /* This part must be outside protection */
-- 
2.44.0


