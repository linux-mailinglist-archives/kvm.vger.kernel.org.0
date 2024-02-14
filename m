Return-Path: <kvm+bounces-8713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A776855611
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 23:37:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B981B29412
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 22:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9505E1419A6;
	Wed, 14 Feb 2024 22:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UEn54zZ3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0414502D;
	Wed, 14 Feb 2024 22:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707950164; cv=none; b=HkAVjzsguzy1WdMs1KIgBCA/h0Wq5phJ0GikjS94NmuwdPry9kRzLkTSuGg40flCKYuW+Xdh7PaPRbIO3hwp8qGPzqnlUOXeR5hK5ruwgR1UNsITAXvJwRF1CjH2cCdYFkipTqpK915X48LVE7ytIPZYQDUcVmNMaAAtkCjgSY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707950164; c=relaxed/simple;
	bh=zSsEp6WIbwar3E1MkHiDYZQkkX71x7A1W8sVSFzBhc0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HWi6bzsDg1067rhG1hXSSZh6iKmliDnAx0Cmvs/Qu3gaycn93IqXU7DmfKrN74qqedeN3SwPMbrGvxAuyLlWpVWkI0Thf8O26zUgAoyk6CiJHpRsFgr65jmUI9U8Klof1A+Zal/8bLQP3Foqu9Lo3MHguov+LFKfPWz0lUeBmK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UEn54zZ3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41ELiX8W022711;
	Wed, 14 Feb 2024 22:35:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=w3ig6KHMTEgTENKvlHnOdkrUoc8w9f3gJq3KxOYjllA=;
 b=UEn54zZ3fTCl9HgEI3Uc0qg9ulaaAUOd6Wlueh9v0dePptYGUM2TWXlUcJcZ3AyxLYwJ
 QwwQBzr3tJhmaHgF5hZo1r4oUvyf2vtN2isMWRfhwSzq0fHuCcfJbtFzz51EAAvurJhU
 3HvwsfS0/XDp1pxmec6WMDQy6JYpVTwjWYekuTFB4TUD8JRWWoEjTW5YtVOSWa8u1nGi
 hpuy8ZKcYs6rBTmJgRBVilLUsKIwMbGzsHbVqqFCd5xYvvmilA26uzbbclgTHql2viFS
 eJyIRk3Qs53o4b0Uf42L5YmIfovBpKgguIwa5m9OmqZab8OLC+mYIv7hjPZxroiaQh/y og== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92ppghs9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Feb 2024 22:35:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41ELZirv013764;
	Wed, 14 Feb 2024 22:35:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w6apcera3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Feb 2024 22:35:56 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41EMZtqc012570;
	Wed, 14 Feb 2024 22:35:55 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w6apcer8u-1;
	Wed, 14 Feb 2024 22:35:55 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        alejandro.j.jimenez@oracle.com
Subject: [PATCH 1/1] KVM: x86: Print names of apicv inhibit reasons in traces
Date: Wed, 14 Feb 2024 22:35:54 +0000
Message-Id: <20240214223554.1033154-1-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-14_14,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=985 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402140170
X-Proofpoint-ORIG-GUID: yTAUtYVm6jr8_vaL4CG3EzgAtjl6F59J
X-Proofpoint-GUID: yTAUtYVm6jr8_vaL4CG3EzgAtjl6F59J

Use the tracing infrastructure helper __print_flags() for printing flag
bitfields, to enhance the trace output by displaying a string describing
each of the inhibit reasons set.

The kvm_apicv_inhibit_changed tracepoint currently shows the raw bitmap
value, requiring the user to consult the source file where the inhbit
reasons are defined to decode the trace output.

Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

---
checkpatch reports an error:
ERROR: Macros with complex values should be enclosed in parentheses

but that seems common for other patches that also use a macro to define an array
of struct trace_print_flags used by __print_flags().

I did not include an example of the new traces in the commit message since they
are longer than 80 columns, but perhaps that is desirable. e.g.:

qemu-system-x86-6961    [055] .....  1779.344065: kvm_apicv_inhibit_changed: set reason=2, inhibits=0x4 ABSENT
qemu-system-x86-6961    [055] .....  1779.356710: kvm_apicv_inhibit_changed: cleared reason=2, inhibits=0x0

qemu-system-x86-9912    [137] ..... 57106.196107: kvm_apicv_inhibit_changed: set reason=8, inhibits=0x300 IRQWIN|PIT_REINJ
qemu-system-x86-9912    [137] ..... 57106.196115: kvm_apicv_inhibit_changed: cleared reason=8, inhibits=0x200 PIT_REINJ
---
 arch/x86/kvm/trace.h | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b82e6ed4f024..8469e59dfce2 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1372,6 +1372,27 @@ TRACE_EVENT(kvm_hv_stimer_cleanup,
 		  __entry->vcpu_id, __entry->timer_index)
 );
 
+/*
+ * The inhibit flags in this flag array must be kept in sync with the
+ * kvm_apicv_inhibit enum members in <asm/kvm_host.h>.
+ */
+#define APICV_INHIBIT_FLAGS \
+	{ BIT(APICV_INHIBIT_REASON_DISABLE),		 "DISABLED" }, \
+	{ BIT(APICV_INHIBIT_REASON_HYPERV),		 "HYPERV" }, \
+	{ BIT(APICV_INHIBIT_REASON_ABSENT),		 "ABSENT" }, \
+	{ BIT(APICV_INHIBIT_REASON_BLOCKIRQ),		 "BLOCKIRQ" }, \
+	{ BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED), "PHYS_ID_ALIASED" }, \
+	{ BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED),	 "APIC_ID_MOD" }, \
+	{ BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED),	 "APIC_BASE_MOD" }, \
+	{ BIT(APICV_INHIBIT_REASON_NESTED),		 "NESTED" }, \
+	{ BIT(APICV_INHIBIT_REASON_IRQWIN),		 "IRQWIN" }, \
+	{ BIT(APICV_INHIBIT_REASON_PIT_REINJ),		 "PIT_REINJ" }, \
+	{ BIT(APICV_INHIBIT_REASON_SEV),		 "SEV" }, \
+	{ BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED),	 "LOG_ID_ALIASED" } \
+
+#define show_inhibit_reasons(inhibits) \
+	__print_flags(inhibits, "|", APICV_INHIBIT_FLAGS)
+
 TRACE_EVENT(kvm_apicv_inhibit_changed,
 	    TP_PROTO(int reason, bool set, unsigned long inhibits),
 	    TP_ARGS(reason, set, inhibits),
@@ -1388,9 +1409,12 @@ TRACE_EVENT(kvm_apicv_inhibit_changed,
 		__entry->inhibits = inhibits;
 	),
 
-	TP_printk("%s reason=%u, inhibits=0x%lx",
+	TP_printk("%s reason=%u, inhibits=0x%lx%s%s",
 		  __entry->set ? "set" : "cleared",
-		  __entry->reason, __entry->inhibits)
+		  __entry->reason, __entry->inhibits,
+		  __entry->inhibits ? " " : "",
+		  __entry->inhibits ?
+		  show_inhibit_reasons(__entry->inhibits) : "")
 );
 
 TRACE_EVENT(kvm_apicv_accept_irq,

base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4
-- 
2.39.3


