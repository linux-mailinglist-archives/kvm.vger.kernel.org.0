Return-Path: <kvm+bounces-16769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 304C68BD7F8
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 00:56:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9DA1281178
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 22:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221B715EFD9;
	Mon,  6 May 2024 22:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lPnIswQG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5091C15EFC4;
	Mon,  6 May 2024 22:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715036010; cv=none; b=kMYeWSCeTzm9Eyj5BgkglC9FNvGmbpW5SpgqKypfSCoddkSXb8x5c2vNe4aybo5hvQ+t4MCOL20CLXgfuT2/j1OkzYr8tCWV7eH9Fm5OqoiBMjOBe+Lp3n66KgblwNfEi1AMBmhhwwD0yZ45Fg4AA4HGeU6owQqGVvez84bjcz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715036010; c=relaxed/simple;
	bh=N83RTlbkk1uWKz5wxtRBpnWXby9KMfSeVUq0AzDvW0Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z6ztgTWUUoDgE4OVe7nA0stUzGsplWhn7kN17+880Sn2KXXiEnE8WY9pkpILGDvYa4/B77vAHdqT3Gd0Zx1DYFD7An4NoGlM8ySCL87F3rVv0qp4gdgkn/suayjatqANwvu5mDxmADIDWBQ2Gk/5qsxKYeXwH+6dCTfs3rlFtAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lPnIswQG; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MmiNa018450;
	Mon, 6 May 2024 22:53:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=L03fituX5ED4j0N/+xawJHW+6W8Cf/jN9ak36qucFGQ=;
 b=lPnIswQGLG0ufbGrw+XQccZULuO42QdqfYXaH+GAKPFKLWdat94fdlwxzzpsolLUbnQW
 qx3DYAF8vRdwDhj0uN2+h2V/qKAptfg3z2XzXCaaNzth0PWjeQxIiTm8RO6usAO+fyDX
 yqDHadsrsN/d54WHa93aTytbrDovwawyIQD3r01lisxiAzmP8FjQuzNIUg9N3fHoWKNC
 2fEUS4+kgFwYZn2U9YKYCDFG2ilPotwW5fVk333KdYYh0fQFJ2Gh3dLlbjJNumFcJP4U
 nEBt7cs9zgxdGeIJohNZGcK6pYbjp8APm9xUYh2tI4puMAQWbOy31sKMP4uITw0BPaiO ag== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwd2duqpx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 22:53:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446LFKRL027629;
	Mon, 6 May 2024 22:53:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbfdg8nd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 22:53:23 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446MrMxC006764;
	Mon, 6 May 2024 22:53:22 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xwbfdg8mq-2;
	Mon, 06 May 2024 22:53:22 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org, seanjc@google.com, vasant.hegde@amd.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        alejandro.j.jimenez@oracle.com
Subject: [PATCH v2 1/2] KVM: x86: Print names of apicv inhibit reasons in traces
Date: Mon,  6 May 2024 22:53:20 +0000
Message-Id: <20240506225321.3440701-2-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240506225321.3440701-1-alejandro.j.jimenez@oracle.com>
References: <20240506225321.3440701-1-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_17,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405060166
X-Proofpoint-GUID: fhH8LZyyFX6i2M0TQm15-WjQk_lqZCQr
X-Proofpoint-ORIG-GUID: fhH8LZyyFX6i2M0TQm15-WjQk_lqZCQr

Use the tracing infrastructure helper __print_flags() for printing flag
bitfields, to enhance the trace output by displaying a string describing
each of the inhibit reasons set.

The kvm_apicv_inhibit_changed tracepoint currently shows the raw bitmap
value, requiring the user to consult the source file where the inhibit
reasons are defined to decode the trace output.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 19 +++++++++++++++++++
 arch/x86/kvm/trace.h            |  9 +++++++--
 arch/x86/kvm/x86.c              |  4 ++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1d13e3cd1dc5..08f83efd12ff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1273,8 +1273,27 @@ enum kvm_apicv_inhibit {
 	 * mapping between logical ID and vCPU.
 	 */
 	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
+
+	NR_APICV_INHIBIT_REASONS,
 };
 
+#define __APICV_INHIBIT_REASON(reason)			\
+	{ BIT(APICV_INHIBIT_REASON_##reason), #reason }
+
+#define APICV_INHIBIT_REASONS				\
+	__APICV_INHIBIT_REASON(DISABLE),		\
+	__APICV_INHIBIT_REASON(HYPERV),			\
+	__APICV_INHIBIT_REASON(ABSENT),			\
+	__APICV_INHIBIT_REASON(BLOCKIRQ),		\
+	__APICV_INHIBIT_REASON(PHYSICAL_ID_ALIASED),	\
+	__APICV_INHIBIT_REASON(APIC_ID_MODIFIED),	\
+	__APICV_INHIBIT_REASON(APIC_BASE_MODIFIED),	\
+	__APICV_INHIBIT_REASON(NESTED),			\
+	__APICV_INHIBIT_REASON(IRQWIN),			\
+	__APICV_INHIBIT_REASON(PIT_REINJ),		\
+	__APICV_INHIBIT_REASON(SEV),			\
+	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
+
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 9d0b02ef307e..f23fb9a6776e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1375,6 +1375,10 @@ TRACE_EVENT(kvm_hv_stimer_cleanup,
 		  __entry->vcpu_id, __entry->timer_index)
 );
 
+#define kvm_print_apicv_inhibit_reasons(inhibits)	\
+	(inhibits), (inhibits) ? " " : "",		\
+	(inhibits) ? __print_flags(inhibits, "|", APICV_INHIBIT_REASONS) : ""
+
 TRACE_EVENT(kvm_apicv_inhibit_changed,
 	    TP_PROTO(int reason, bool set, unsigned long inhibits),
 	    TP_ARGS(reason, set, inhibits),
@@ -1391,9 +1395,10 @@ TRACE_EVENT(kvm_apicv_inhibit_changed,
 		__entry->inhibits = inhibits;
 	),
 
-	TP_printk("%s reason=%u, inhibits=0x%lx",
+	TP_printk("%s reason=%u, inhibits=0x%lx%s%s",
 		  __entry->set ? "set" : "cleared",
-		  __entry->reason, __entry->inhibits)
+		  __entry->reason,
+		  kvm_print_apicv_inhibit_reasons(__entry->inhibits))
 );
 
 TRACE_EVENT(kvm_apicv_accept_irq,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b389129d59a9..597ff748f955 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10011,6 +10011,10 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_apicv_activated);
 static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
 				       enum kvm_apicv_inhibit reason, bool set)
 {
+	const struct trace_print_flags apicv_inhibits[] = { APICV_INHIBIT_REASONS };
+
+	BUILD_BUG_ON(ARRAY_SIZE(apicv_inhibits) != NR_APICV_INHIBIT_REASONS);
+
 	if (set)
 		__set_bit(reason, inhibits);
 	else
-- 
2.39.3


