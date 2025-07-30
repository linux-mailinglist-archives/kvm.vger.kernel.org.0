Return-Path: <kvm+bounces-53725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA51DB15A3F
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 10:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB15B18A5FA2
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 08:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 427C226529A;
	Wed, 30 Jul 2025 08:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gmvLdFPL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEACD254AFF;
	Wed, 30 Jul 2025 08:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753863238; cv=none; b=Ft4+yelyUZ3FabmTXJcc7Ox9buOrKYPeSC57P6hncr2qfQYFmaDDbrPSYYY52ROUySJC/YYoY++61/qXcyNuzQXGXesOdgqVA0GCPM2JscuJMQ4QSk9Ly5eo3+nOThdqZ6CU1bC7zNKAFZDkCGNufBEgX6eXoNbEuf+oNlqlEr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753863238; c=relaxed/simple;
	bh=OZwyWhIkomiEJFBzpbtykcKC3w3QM/xcB+Z2wpkSUCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owhmQ7vzbokfIBY77rCW2ji4jZM7k7y2IB7nBQrdebIa9ttqRyT1byYK+BvPPCb5IOKUS2bgbRrtUePgiR3q8hx8Oymyl1TOXhnW/s6T8j2Z4ghKEkmo3lfQjJMVmkVIEEOjhJC0HGnjFFCqYspBbiGIhDlU5i5PrzHH5MrAkZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gmvLdFPL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56U099Wj009401;
	Wed, 30 Jul 2025 08:13:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=04mMiwdw81mNFgvME
	OetQUsgLgTuzznXCq7UE6rNtr0=; b=gmvLdFPLJ/x5IAwEQN4ai1IvpnBIIOmad
	iBp4IUzwVC8Zq3NnhnlWB21qxdwFtcM47bUXt4KWlcHW9hcZ19K437wMv+ExzWjV
	UBJa2v4ywnEwzQvgU5k6PEi+p0EFugvB+IM6gUNbK6Bv8XZk9qUgTSuN/BDERBuu
	SUWZXP2El1TxF4vv9iEyIhC5wMSFBrB2LM1a57zqDwglEt8udJf9wVEbxZOdaZLH
	dK5+hK6oG1aMz/2MkcQYLJA9M7YclIPbH1tF97Xkcapt0HwWwdVKpi2FMQMRlmtt
	gPh8VAB1d0qmincrCoqtJTUY/qLXW3N0r2VP7wwUdiY0SB6RXDwIQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qcg3j3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Jul 2025 08:13:14 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56U6bMR3018665;
	Wed, 30 Jul 2025 08:13:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 485abp6h86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Jul 2025 08:13:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56U8DA7P53346560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 08:13:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 317C02004E;
	Wed, 30 Jul 2025 08:13:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FE4420040;
	Wed, 30 Jul 2025 08:13:09 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.87.148.140])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Jul 2025 08:13:09 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, ajd@linux.ibm.com,
        sfr@canb.auug.org.au, Mark Rutland <mark.rutland@arm.com>,
        Andy Lutomirski <luto@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [GIT PULL 1/2] entry: Add arch_in_rcu_eqs()
Date: Wed, 30 Jul 2025 10:10:32 +0200
Message-ID: <20250730081224.38778-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730081224.38778-1-frankja@linux.ibm.com>
References: <20250730081224.38778-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDA1MyBTYWx0ZWRfXxMLtWpquGS8x
 C44CK6swq4jYBe/PNfaVEZ6FShTsPNd+qCsV4tCprB9u5ZxRlbJ1wYdWt8vDy/n0XDMsBGYeuOP
 QnkvvdfIMZLTKcmQy8uEAqymdaD/zF4sTj0I63CQywOzvpxAVZN7Nlx0LnhcVOYPJmnrjV9JLMl
 IfPuQhEYb05MHP81rmWU2A2Sxvg9u7BOsAcv8u9dqESLqLBj8YaB4IDp8m/l3//LUKAq1uE2Va6
 oP05urQFgwoc0zDFpdu3DjG1IZU5ma+IbJzHtIfmNuWb4ZYuAXx/0R2g6HzhaOFz1BZcxLE/oQB
 B3lmrpXrtRCxqqo1nR2CyxjpE/9JFR2XkXJW+NIvnlxaej53HaEKCAhUCp9eCfQPvBZBodncDdt
 7jfWihhCSpWr9EfOXlWX8v4wGAkkAhA9KSrcFxkaRszhJR4Nx0T7sPSSQcXHNPFaSld6KOum
X-Proofpoint-ORIG-GUID: 2TuBFecMa449mD8HLGO5-2agDq8oK6jl
X-Authority-Analysis: v=2.4 cv=Lp2Symdc c=1 sm=1 tr=0 ts=6889d41a cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=7CQSdrXTAAAA:8
 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=OIHnq4nhO9tdK0j1QDAA:9
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: 2TuBFecMa449mD8HLGO5-2agDq8oK6jl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_03,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=858 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507300053

From: Mark Rutland <mark.rutland@arm.com>

All architectures have an interruptible RCU extended quiescent state
(EQS) as part of their idle sequences, where interrupts can occur
without RCU watching. Entry code must account for this and wake RCU as
necessary; the common entry code deals with this in irqentry_enter() by
treating any interrupt from an idle thread as potentially having
occurred within an EQS and waking RCU for the duration of the interrupt
via rcu_irq_enter() .. rcu_irq_exit().

Some architectures may have other interruptible EQSs which require
similar treatment. For example, on s390 it is necessary to enable
interrupts around guest entry in the middle of a period where core KVM
code has entered an EQS.

So that architectures can wake RCU in these cases, this patch adds a
new arch_in_rcu_eqs() hook to the common entry code which is checked in
addition to the existing is_idle_thread() check, with RCU woken if
either returns true. A default implementation is provided which always
returns false, which suffices for most architectures.

As no architectures currently implement arch_in_rcu_eqs(), there should
be no functional change as a result of this patch alone. A subsequent
patch will add an s390 implementation to fix a latent bug with missing
RCU wakeups.

[ajd@linux.ibm.com: rebase, fix commit message]

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20250708092742.104309-2-ajd@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20250708092742.104309-2-ajd@linux.ibm.com>
---
 include/linux/entry-common.h | 16 ++++++++++++++++
 kernel/entry/common.c        |  3 ++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index f94f3fdf15fc..3bf99cbad8a3 100644
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -86,6 +86,22 @@ static __always_inline void arch_enter_from_user_mode(struct pt_regs *regs);
 static __always_inline void arch_enter_from_user_mode(struct pt_regs *regs) {}
 #endif
 
+/**
+ * arch_in_rcu_eqs - Architecture specific check for RCU extended quiescent
+ * states.
+ *
+ * Returns: true if the CPU is potentially in an RCU EQS, false otherwise.
+ *
+ * Architectures only need to define this if threads other than the idle thread
+ * may have an interruptible EQS. This does not need to handle idle threads. It
+ * is safe to over-estimate at the cost of redundant RCU management work.
+ *
+ * Invoked from irqentry_enter()
+ */
+#ifndef arch_in_rcu_eqs
+static __always_inline bool arch_in_rcu_eqs(void) { return false; }
+#endif
+
 /**
  * enter_from_user_mode - Establish state when coming from user mode
  *
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index a8dd1f27417c..eb52d38e8099 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -220,7 +220,8 @@ noinstr irqentry_state_t irqentry_enter(struct pt_regs *regs)
 	 * TINY_RCU does not support EQS, so let the compiler eliminate
 	 * this part when enabled.
 	 */
-	if (!IS_ENABLED(CONFIG_TINY_RCU) && is_idle_task(current)) {
+	if (!IS_ENABLED(CONFIG_TINY_RCU) &&
+	    (is_idle_task(current) || arch_in_rcu_eqs())) {
 		/*
 		 * If RCU is not watching then the same careful
 		 * sequence vs. lockdep and tracing is required
-- 
2.50.1


