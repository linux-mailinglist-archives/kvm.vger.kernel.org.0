Return-Path: <kvm+bounces-12209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE421880A8C
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 06:08:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A6BAB22416
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 05:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280B7154B1;
	Wed, 20 Mar 2024 05:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Wh4tQjbO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D8E17BA1;
	Wed, 20 Mar 2024 05:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710911318; cv=none; b=o74ZNIwU/Zxq5roxDQz++sU1MLNLqQTxOAgy6TsyZmQIwLcHlEle/dgQddOF6WrtBKo1sScTtTQGP+xtPRz+G8cZaeWhDQsjXo4uTKgcSGaqx6K2KBPbgscS3AYk8kB4XD/88E0v4r+9N0zFWHwlVACuSHv5fxczXb/yhqJBMQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710911318; c=relaxed/simple;
	bh=od4pwcWUsXfzMzhox/XrLT+mGeEuAizu7rwGoCn+b5I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uoyT8Im35BQM3YN3aey9T2cXjPHGe1+/+DZMAdiwPTpoCVgW+HhgZY0O/kozEk9fSVFLTLrxlmEtmnrk5NIAzTJVbFi7QEBZ4751gWfpGh3fmBA9EGbJoPz+ftyRFgwAS/Yc/haazLWKwsQSs2+77/VuUwvY81Qo3DgsyibLuC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Wh4tQjbO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42K3aL9q014515;
	Wed, 20 Mar 2024 05:08:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=PnC+QHysVH2fKvyKKXOjlYt8dPv/ly++rH8qT1mvb20=;
 b=Wh4tQjbOpJ5RQgaeksJafRGHMZXFqJZtU6maqa4/koE4PHCsfWotRJnDjmzYujSpwN5k
 LwH3uofc9wYSotocLK0VgIRvk5Jottju3kFgt5kY/4dOXIvTmeB2kuIOicAdhntOqswa
 +GrTGp8TJsC4SkrE7qUVS+qumxhm7XLW3W8DBOshaNC7Who2qlv8TQDxsbRnZiOb2KNc
 LOy08Nj8A1oWqsgNaTtTh6YI1U07MboLgGaPNrJvWO5LWqy6ZRTtvnEQuyEkkZzxNdjQ
 7QOJIeYKMUbG/UNaDLxujr2XFz0/4q3o4Ad+ymMIfrZjorDs2vjXdAb7kjrEtexWJAke 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wym618efj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Mar 2024 05:08:18 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42K58Ivw020369;
	Wed, 20 Mar 2024 05:08:18 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wym618eff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Mar 2024 05:08:18 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42K4dFZF017208;
	Wed, 20 Mar 2024 05:08:17 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wwnrtcffg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Mar 2024 05:08:17 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42K589v043254102
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Mar 2024 05:08:11 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA9EC2004D;
	Wed, 20 Mar 2024 05:08:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75D9120040;
	Wed, 20 Mar 2024 05:08:06 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.43.121.20])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 Mar 2024 05:08:06 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: [PATCH v2] arch/powerpc/kvm: Add support for reading VPA counters for pseries guests
Date: Wed, 20 Mar 2024 10:37:58 +0530
Message-ID: <20240320050800.137923-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aUhYoWymYVX-xp008U5t1VCvXeOqXbVM
X-Proofpoint-GUID: OmrnNij28sRCzVEAgCPR67nq380b5Glq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-20_02,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403200037

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
V1 -> V2:
1. Fix the build error due to invalid struct member reference.

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
index 8e86eb577..e2ec1f7db 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4115,6 +4115,7 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 	unsigned long msr, i;
 	int trap;
 	long rc;
+	struct lppaca *lp = get_lppaca();
 
 	io = &vcpu->arch.nestedv2_io;
 
@@ -4130,6 +4131,17 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
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
 
@@ -4156,6 +4168,14 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
index 8d57c8428..d411489e5 100644
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
+		__entry->l2_runtime_ns = vcpu->arch.l2_runtime;
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


