Return-Path: <kvm+bounces-13275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A10893AA0
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 13:26:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A36AB21345
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 11:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E533020DDC;
	Mon,  1 Apr 2024 11:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Xe1yzhvm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6D9D26D;
	Mon,  1 Apr 2024 11:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711970781; cv=none; b=SE9ZLj/ZgWll221MJI77kUiQV21vdmHW2hBDVP97r4IrMxqzWfshrm/KGJdYdEtwVqb1j0Af3dcujFtN2AeLpSiNBQXH48gTsv/hfJ3A0QgGNU0MgegKBUZ6LTMO+/zW5OmbGZ3GE+rckC5olh7XdlP+h9wEjWUqJae6GpxCY2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711970781; c=relaxed/simple;
	bh=3DO2lk/X2mYh8YCGDMvIh7GosKNhzaCowOY5LEPM/fw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KfVAoiv1vJs3fltAbACGkVkTOOZDuhSRwmWJ4xiO1cEFVgufAmg6RX53ro8kQQprWLnhi3CnYNwQyxILeEnWd9opMt1Sdey9ugJ/mlvOvUtMpfD52isQR0g01+LX0thG0gws2w1UH8Pg3G5mr2cuH5HzAO8cT8ZDAlRWAPzVqw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Xe1yzhvm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 431AT6L5009006;
	Mon, 1 Apr 2024 11:25:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hIfWf96+nXLMpBhhld2BYjm2u7wN14KfSGQObB84m1I=;
 b=Xe1yzhvmrfesCCtvXW+PfiCtuUzoVguCAGPadXve2sv4d7LsGHDskb0UYjMEyUlCO9y/
 AflzuKbH4EmZ+cHAxx2T+cSbE/Xjl43JKJDbmJnvvmsQOBW8mcxrmS+keXuIBYeTkVnA
 DollROVVVfrKeDfeYEU1CpexlDZuNgm/GGWHVMFTsgTCNltebSj5YWLX2WJUyHgLMXRd
 /xAqZNIMmTEZJTCmVZ3zm/npRVCPLaMPBRXD5Mvl3HeRflLucW4BfGRLldTkeZNiPhQC
 Uh0+GDOC8zrliYZSpbJhITslXz5vZHPu2Ao1GwwnQU1sjRW5Z1IimmYJsEfrIKyt9hnm QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x7u7002xj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 11:25:55 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 431BPteG029320;
	Mon, 1 Apr 2024 11:25:55 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x7u7002xg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 11:25:55 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 431AK559008468;
	Mon, 1 Apr 2024 11:25:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x6w2tr4du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 11:25:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 431BPm2f13238690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Apr 2024 11:25:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD9812004B;
	Mon,  1 Apr 2024 11:25:48 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 859282004F;
	Mon,  1 Apr 2024 11:25:46 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Apr 2024 11:25:46 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: [PATCH v5] arch/powerpc/kvm: Add support for reading VPA counters for pseries guests
Date: Mon,  1 Apr 2024 16:55:42 +0530
Message-ID: <20240401112544.51764-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hmKXj4kRYUK-CrFcHhPSFY7jQMqI5oS3
X-Proofpoint-ORIG-GUID: e4Af83RIcyZvufTmDqe1ep-PVypF6ZC3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-01_08,2024-03-28_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404010081

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
 arch/powerpc/include/asm/kvm_host.h |  5 ++++
 arch/powerpc/include/asm/lppaca.h   | 11 +++++---
 arch/powerpc/kvm/book3s_hv.c        | 40 +++++++++++++++++++++++++++++
 arch/powerpc/kvm/trace_hv.h         | 25 ++++++++++++++++++
 4 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 8abac532146e..d953b32dd68a 100644
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
index 61ec2447dabf..bda6b86b9f13 100644
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
index 8e86eb577eb8..fea1c1429975 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4108,6 +4108,37 @@ static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
 	}
 }
 
+static inline int kvmhv_get_l2_accumul(void)
+{
+	return get_lppaca()->l2_accumul_cntrs_enable;
+}
+
+static inline void kvmhv_set_l2_accumul(int val)
+{
+	get_lppaca()->l2_accumul_cntrs_enable = val;
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
+	trace_kvmppc_vcpu_exit_cs_time(vcpu, l1_to_l2_ns, l2_to_l1_ns,
+					l2_runtime_ns);
+	lp->l1_to_l2_cs_tb = 0;
+	lp->l2_to_l1_cs_tb = 0;
+	lp->l2_runtime_tb = 0;
+	kvmhv_set_l2_accumul(0);
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
@@ -4130,6 +4161,11 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 	kvmppc_gse_put_u64(io->vcpu_run_input, KVMPPC_GSID_LPCR, lpcr);
 
 	accumulate_time(vcpu, &vcpu->arch.in_guest);
+
+	/* Enable the guest host context switch time tracking */
+	if (unlikely(trace_kvmppc_vcpu_exit_cs_time_enabled()))
+		kvmhv_set_l2_accumul(1);
+
 	rc = plpar_guest_run_vcpu(0, vcpu->kvm->arch.lpid, vcpu->vcpu_id,
 				  &trap, &i);
 
@@ -4156,6 +4192,10 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	timer_rearm_host_dec(*tb);
 
+	/* Record context switch and guest_run_time data */
+	if (kvmhv_get_l2_accumul())
+		do_trace_nested_cs_time(vcpu);
+
 	return trap;
 }
 
diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
index 8d57c8428531..ab19977c91b4 100644
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


