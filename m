Return-Path: <kvm+bounces-17777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94D478CA19A
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 19:58:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BA342824C9
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 17:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6172137C54;
	Mon, 20 May 2024 17:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X+epluMV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E054A136986;
	Mon, 20 May 2024 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227897; cv=none; b=AKU7heiq5Y9vX1e1z7Y1SZGtFThLV1tzfXsDnDpLeBn1zj4fZ8fFgQ5ccLb7rHEslXKEKsTq0jwT3ScuD9YPNOOlNVRj7KOW4OdrUY+qZkhgcAA5lcIHtIUpJVWWaT1CwdiSjlN0oCMYyPSfFEADaCb1qMXEX7L0eFibK5s3qSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227897; c=relaxed/simple;
	bh=MeRVqS2/5Y1veein1nrFkEafETCgAWNKWOs1Qq1CiNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i0qTQsQyoviTrg3zaSxXbFNf/JCvL6MNspxzQNSd8X5lHHn9nhjc/AxCb7OFbrH/myVzuHquEzk1UqeoQfbnnQFLLgOZJZhUf9C/6I7qI5+rCKFC6Vs1a9USfl0anRgkylQKjVjP8cwYzVX2b6Yg98wbEP9XSHY88Nw7bBs0aC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X+epluMV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KHl5VP007355;
	Mon, 20 May 2024 17:57:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=oj/uEy4llmIH0Y9yp8kCrXfrm50EjfkhMiwF2OjKMcQ=;
 b=X+epluMVqDL9J9lAZUBvmiCyUfArZgypPTky/z98w+sulTqVlR9bRHo63FSVY/q/AtCb
 zxBNiFWkP5nh/BQ5ixIXDeIVrA8BWaqsnsdEDfzSf0Ju6rhVTQyL4D64JVNtc9qXlrwQ
 PmTWHzApl6uFxAE/YHp/hE8aaAXoU0nzgteC5LwLW3tI5rUtVt1gsLmOCXHtIo/ubDCn
 WEx51hnNQGzycmaUR6wkZMy7b6/uF7n3SxixZ2R7oAZb36OUY+Mzv7bByiVY5m/ldg4O
 bmc1GXh3IZyqf2/S04W+fOlzXimZi8CnRIJ8MaGxkS3Bbfk6Re4qwHlLCcf/vM3dBJ3H DA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8b7kg1tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 17:57:57 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44KHvusl028302;
	Mon, 20 May 2024 17:57:56 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8b7kg1tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 17:57:56 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44KEpbFZ007424;
	Mon, 20 May 2024 17:57:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y79c2rp7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 17:57:55 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44KHvnb956099178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 17:57:52 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC1362004F;
	Mon, 20 May 2024 17:57:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4A5B20040;
	Mon, 20 May 2024 17:57:45 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.43.62.32])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 May 2024 17:57:45 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naveen N Rao <naveen@kernel.org>, Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: [PATCH v9] arch/powerpc/kvm: Add support for reading VPA counters for pseries guests
Date: Mon, 20 May 2024 23:27:40 +0530
Message-ID: <20240520175742.196329-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IFHXsTqauo8Uzh-_kABS2Yn9QyKPXSZn
X-Proofpoint-GUID: _d8rzzMH9qc5w26DAK3vy29edjcPrf96
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-20_09,2024-05-17_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 adultscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405200143

PAPR hypervisor has introduced three new counters in the VPA area of
LPAR CPUs for KVM L2 guest (see [1] for terminology) observability - 2
for context switches from host to guest and vice versa, and 1 counter
for getting the total time spent inside the KVM guest. Add a tracepoint
that enables reading the counters for use by ftrace/perf. Note that this
tracepoint is only available for nestedv2 API (i.e, KVM on PowerVM).

[1] Terminology:
a. L1 refers to the VM (LPAR) booted on top of PAPR hypervisor
b. L2 refers to the KVM guest booted on top of L1.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
v8 -> v9:
1. Fix linker errors when compiling as module.

v7 -> v8:
1. Use per_cpu vars instead of paca members.
2. Fix build error for powernv config.

v6 -> v7:
1. Use TRACE_EVENT_FN_COND to handle zero counters case.
2. Use for_each_present_cpu() to handle hotplugs.

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

 arch/powerpc/include/asm/kvm_book3s_64.h |  5 ++
 arch/powerpc/include/asm/lppaca.h        | 11 +++-
 arch/powerpc/kvm/book3s_hv.c             | 75 ++++++++++++++++++++++++
 arch/powerpc/kvm/trace_hv.h              | 29 +++++++++
 4 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index d8729ec81ca0..2ef9a5f4e5d1 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -684,6 +684,11 @@ int kvmhv_nestedv2_set_ptbl_entry(unsigned long lpid, u64 dw0, u64 dw1);
 int kvmhv_nestedv2_parse_output(struct kvm_vcpu *vcpu);
 int kvmhv_nestedv2_set_vpa(struct kvm_vcpu *vcpu, unsigned long vpa);
 
+int kmvhv_counters_tracepoint_regfunc(void);
+void kmvhv_counters_tracepoint_unregfunc(void);
+int kvmhv_get_l2_counters_status(void);
+void kvmhv_set_l2_counters_status(int cpu, bool status);
+
 #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
 
 #endif /* __ASM_KVM_BOOK3S_64_H__ */
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
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 35cb014a0c51..a6e4d46c1cd0 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4108,6 +4108,77 @@ static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
 	}
 }
 
+/* Helper functions for reading L2's stats from L1's VPA */
+#ifdef CONFIG_PPC_PSERIES
+static DEFINE_PER_CPU(u64, l1_to_l2_cs);
+static DEFINE_PER_CPU(u64, l2_to_l1_cs);
+static DEFINE_PER_CPU(u64, l2_runtime_agg);
+
+int kvmhv_get_l2_counters_status(void)
+{
+	return firmware_has_feature(FW_FEATURE_LPAR) &&
+		get_lppaca()->l2_counters_enable;
+}
+
+void kvmhv_set_l2_counters_status(int cpu, bool status)
+{
+	if (!firmware_has_feature(FW_FEATURE_LPAR))
+		return;
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
+	for_each_present_cpu(cpu) {
+		kvmhv_set_l2_counters_status(cpu, true);
+	}
+	return 0;
+}
+
+void kmvhv_counters_tracepoint_unregfunc(void)
+{
+	int cpu;
+
+	for_each_present_cpu(cpu) {
+		kvmhv_set_l2_counters_status(cpu, false);
+	}
+}
+
+static void do_trace_nested_cs_time(struct kvm_vcpu *vcpu)
+{
+	struct lppaca *lp = get_lppaca();
+	u64 l1_to_l2_ns, l2_to_l1_ns, l2_runtime_ns;
+	u64 *l1_to_l2_cs_ptr = this_cpu_ptr(&l1_to_l2_cs);
+	u64 *l2_to_l1_cs_ptr = this_cpu_ptr(&l2_to_l1_cs);
+	u64 *l2_runtime_agg_ptr = this_cpu_ptr(&l2_runtime_agg);
+
+	l1_to_l2_ns = tb_to_ns(be64_to_cpu(lp->l1_to_l2_cs_tb));
+	l2_to_l1_ns = tb_to_ns(be64_to_cpu(lp->l2_to_l1_cs_tb));
+	l2_runtime_ns = tb_to_ns(be64_to_cpu(lp->l2_runtime_tb));
+	trace_kvmppc_vcpu_stats(vcpu, l1_to_l2_ns - *l1_to_l2_cs_ptr,
+					l2_to_l1_ns - *l2_to_l1_cs_ptr,
+					l2_runtime_ns - *l2_runtime_agg_ptr);
+	*l1_to_l2_cs_ptr = l1_to_l2_ns;
+	*l2_to_l1_cs_ptr = l2_to_l1_ns;
+	*l2_runtime_agg_ptr = l2_runtime_ns;
+}
+
+#else
+int kvmhv_get_l2_counters_status(void)
+{
+	return 0;
+}
+
+static void do_trace_nested_cs_time(struct kvm_vcpu *vcpu)
+{
+}
+#endif
+
 static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 				     unsigned long lpcr, u64 *tb)
 {
@@ -4156,6 +4227,10 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	timer_rearm_host_dec(*tb);
 
+	/* Record context switch and guest_run_time data */
+	if (kvmhv_get_l2_counters_status())
+		do_trace_nested_cs_time(vcpu);
+
 	return trap;
 }
 
diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
index 8d57c8428531..77ebc724e6cd 100644
--- a/arch/powerpc/kvm/trace_hv.h
+++ b/arch/powerpc/kvm/trace_hv.h
@@ -512,6 +512,35 @@ TRACE_EVENT(kvmppc_run_vcpu_exit,
 			__entry->vcpu_id, __entry->exit, __entry->ret)
 );
 
+#ifdef CONFIG_PPC_PSERIES
+
+TRACE_EVENT_FN_COND(kvmppc_vcpu_stats,
+	TP_PROTO(struct kvm_vcpu *vcpu, u64 l1_to_l2_cs, u64 l2_to_l1_cs, u64 l2_runtime),
+
+	TP_ARGS(vcpu, l1_to_l2_cs, l2_to_l1_cs, l2_runtime),
+
+	TP_CONDITION(l1_to_l2_cs || l2_to_l1_cs || l2_runtime),
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
+#endif
 #endif /* _TRACE_KVM_HV_H */
 
 /* This part must be outside protection */
-- 
2.39.3


