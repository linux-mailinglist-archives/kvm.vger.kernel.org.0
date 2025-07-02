Return-Path: <kvm+bounces-51288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3653CAF1304
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 13:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13E823B2383
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777D72571D8;
	Wed,  2 Jul 2025 11:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="a5F3CSt7"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster5-host1-snip4-10.eps.apple.com [57.103.66.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2EF1EC006
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 11:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.66.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751454049; cv=none; b=M+uVvjUXVdpxAncSUwL3S1L7eA3bzgIyErbg1/Dv7WE/2usPhKSs0Az/QyvpVxRpMzxJKx9ZVmklM9Vqqd/9TOvNwV7o2e6h6JkgQji7SVyLzh1SS4we3FRMxFMldHjnXl2QeZTyVx/EpEzRWIAgnSjBr9auQeBTWHJSK5rvO4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751454049; c=relaxed/simple;
	bh=EDpCE0FsRsP957sJiS4v86/d+16D13uGqgBiODpWyzM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Qa3kpbRGDxlIZHeHelwCBRkk22qKR+U8/v+vaw/WrONnOSn/B416ssHXPF4pktSwmjIbNgvI8giM7/3tw7qcvyVw9vHpZVmARAPB8gt781q/RxQnFTWyHA4dIIbM8sX+J04zUf4SM2wmrXoFAyNJIRIbPf9yiQ1qEQ0EEb/fO5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=a5F3CSt7; arc=none smtp.client-ip=57.103.66.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
	s=1a1hai; bh=l0grrrQpY81N/VQL7J2F9njJr7ho5zRKX+wKppU/wMo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version:x-icloud-hme;
	b=a5F3CSt7ew6T8OhTqenJH92raFtftvMdFQmN3s2DgK2Qx13hcJ7mAGdSQBiTDSSmm
	 tpoXs96I0wSTtSHxTkLtwBBVmKIPFkwWTx1ra9A+FOPrUSi/voo7hoboeJcVEiUC+a
	 Qwg7IJDWEJ93V0394ZH5FYyIOeQevrc0E4bYQOSaxpGLvUJBfHjsLbACBzFFCKxFSe
	 O5Fs8RR8WhBPW4eVo/C4z800MOOYbrAiz0Av5/Je1UVawI0K2CYsmv4BQvNml93MrP
	 amcQGuXsavcp/sewtrfbIZmdrAYN+3ysA12uzjuGMlClCJYJCnt7BnKIbqIN6hGq1k
	 zIiP3td/GciiQ==
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by outbound.pv.icloud.com (Postfix) with ESMTPS id 628A818000AF;
	Wed,  2 Jul 2025 11:00:45 +0000 (UTC)
Received: from dedsec-amd0.tail874668.ts.net (pv-asmtp-me-k8s.p00.prod.me.com [17.56.9.36])
	by outbound.pv.icloud.com (Postfix) with ESMTPSA id 4AA1D18006F0;
	Wed,  2 Jul 2025 11:00:39 +0000 (UTC)
From: Yulong Han <wheatfox17@icloud.com>
To: chenhuacai@kernel.org
Cc: kernel@xen0n.name,
	zhaotianrui@loongson.cn,
	maobibo@loongson.cn,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yulong Han <wheatfox17@icloud.com>
Subject: [PATCH] LoongArch: KVM: Add tracepoints for CPUCFG and CSR emulation exits
Date: Wed,  2 Jul 2025 18:59:22 +0800
Message-Id: <20250702105922.1035771-1-wheatfox17@icloud.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: SKFNO0ti4yqAUpAxixOhYuM9w5Zvmb_K
X-Proofpoint-GUID: SKFNO0ti4yqAUpAxixOhYuM9w5Zvmb_K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDA4OSBTYWx0ZWRfXzm30iI/d+ldT
 kUpGlbB7KyFewJao7eMN0ZtECEyHIbwIsJGXAL+ZT2Tkeb5YtirFgi8e9XxnbRsc8P3QUlaJn2j
 bfBs3AdNw1sDpqo99bscHDnIDTsawymTopXW40QvoZ2aKWjpDpZOm9+fGzX+/6pyQ10TTI4G7zF
 oRkSlfy5neL8arokSxlGcXSN8ZmGMy5OBZ9iXqPpSphXIdhUIlR5k8upyQh7CyVKy0ZIYTSSiW0
 9efDoPMpN87n9PY3Wh4S7p6INlNwtwcDiuCFNZShGJlfcaCnGKzzwKDqGDqFgSr02hxdtyEX8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-02_01,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 clxscore=1011 spamscore=0
 mlxlogscore=742 suspectscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2506060001 definitions=main-2507020089

This patch adds tracepoints to track KVM exits caused by CPUCFG 
and CSR emulation. Note that IOCSR emulation tracing is already
covered by the generic trace_kvm_iocsr().

Signed-off-by: Yulong Han <wheatfox17@icloud.com>
---
 arch/loongarch/kvm/exit.c  |  2 ++
 arch/loongarch/kvm/trace.h | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index fa52251b3bf1c..6a47a23ae9cd6 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -289,9 +289,11 @@ static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
 	er = EMULATE_FAIL;
 	switch (((inst.word >> 24) & 0xff)) {
 	case 0x0: /* CPUCFG GSPR */
+		trace_kvm_exit_cpucfg(vcpu, KVM_TRACE_EXIT_CPUCFG);
 		er = kvm_emu_cpucfg(vcpu, inst);
 		break;
 	case 0x4: /* CSR{RD,WR,XCHG} GSPR */
+		trace_kvm_exit_csr(vcpu, KVM_TRACE_EXIT_CSR);
 		er = kvm_handle_csr(vcpu, inst);
 		break;
 	case 0x6: /* Cache, Idle and IOCSR GSPR */
diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
index 1783397b1bc88..145514dab6d5b 100644
--- a/arch/loongarch/kvm/trace.h
+++ b/arch/loongarch/kvm/trace.h
@@ -46,11 +46,15 @@ DEFINE_EVENT(kvm_transition, kvm_out,
 /* Further exit reasons */
 #define KVM_TRACE_EXIT_IDLE		64
 #define KVM_TRACE_EXIT_CACHE		65
+#define KVM_TRACE_EXIT_CPUCFG		66
+#define KVM_TRACE_EXIT_CSR		67
 
 /* Tracepoints for VM exits */
 #define kvm_trace_symbol_exit_types			\
 	{ KVM_TRACE_EXIT_IDLE,		"IDLE" },	\
-	{ KVM_TRACE_EXIT_CACHE,		"CACHE" }
+	{ KVM_TRACE_EXIT_CACHE,		"CACHE" },	\
+	{ KVM_TRACE_EXIT_CPUCFG,	"CPUCFG" },	\
+	{ KVM_TRACE_EXIT_CSR,		"CSR" }
 
 DECLARE_EVENT_CLASS(kvm_exit,
 	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
@@ -82,6 +86,14 @@ DEFINE_EVENT(kvm_exit, kvm_exit_cache,
 	     TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
 	     TP_ARGS(vcpu, reason));
 
+DEFINE_EVENT(kvm_exit, kvm_exit_cpucfg,
+	     TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
+	     TP_ARGS(vcpu, reason));
+
+DEFINE_EVENT(kvm_exit, kvm_exit_csr,
+	     TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
+	     TP_ARGS(vcpu, reason));
+
 DEFINE_EVENT(kvm_exit, kvm_exit,
 	     TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
 	     TP_ARGS(vcpu, reason));
-- 
2.39.5


