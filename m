Return-Path: <kvm+bounces-51753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA6FAFC70F
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 11:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C835C18845B4
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 09:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9A726561C;
	Tue,  8 Jul 2025 09:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dt2XDUHD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1761922D7B1;
	Tue,  8 Jul 2025 09:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751966933; cv=none; b=kLXV/ZNKoOKBWmYoYUGNwwWbg5z1Sn6yf+aHOCDKSwhGKMIYYu5Sqorl9+LWK/fcw06k9tSirw9p9t5p/m9j1mKJUf3TSesn74VqWB7Pmp6nZZYWQJKCyXAW4uxAN7XJYs1uVV/E9jjyt6Lmd3f7qoCyF+NVgKd5Eujv0KNsl68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751966933; c=relaxed/simple;
	bh=GzRbTFySjm2ev1EIYMrO2uMWEMk5BE4yffNv9hoNe/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKw97mkcMPBG7u7cCpuh0oM8v6+YAiAHzbAPQ3tT+z4PsxKA/SlH9Dvmz9fZg/acrGhLMo6zEfZQJgLSSDRgHera0PeZD1mKwcPP7CICSdIC+fE5B2QA++qEYPIGLhKnNbj8T8WCjZTFZacA6+gLEzGsldJIjflEa904W3gUG4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dt2XDUHD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 567MswUB005275;
	Tue, 8 Jul 2025 09:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QgLQrBLzoxLb6s1HI
	0QGfxg1+tp97x/hQ42tx4CKN40=; b=Dt2XDUHDajolSVbbe++WIGcHHDkLEdTEK
	y1QCwd1lBTdOoqpEcuiozF7Zrq1eY7ESEjwHqjGPbzkZVCcxmYfscxgAZLgMoQue
	Ccb47ekkpG8bu1iPvAh6K2V/00XWHooo1raqc3j9IvENqGA6SvhfVA/myQn7z+VE
	ipzPrgFaxpRMgOZh4a+hsQkEYTKUpfy2o82PABzqLwgDlOJWP1oLvuKhG9yb4Zg6
	eryMS6NA5rKhqQtW64kYnfffeM0X6jQctUHnuzbqM/26V+qHgALbTVxnWbXVgeOj
	ZubIXS/a+44tCiaWiDCFDbjDR/g5Nv0tdNA1cpWcB/5H/GYRcKT+g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47ptfypc2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Jul 2025 09:28:23 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56886BUI024678;
	Tue, 8 Jul 2025 09:28:23 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 47qh329xv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Jul 2025 09:28:22 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5689SLC832244068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Jul 2025 09:28:21 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6C3158059;
	Tue,  8 Jul 2025 09:28:20 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47C3258043;
	Tue,  8 Jul 2025 09:28:11 +0000 (GMT)
Received: from jarvis.j0t-au.ibm.com (unknown [9.90.171.232])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  8 Jul 2025 09:28:10 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] entry: Add arch_in_rcu_eqs()
Date: Tue,  8 Jul 2025 19:27:41 +1000
Message-ID: <20250708092742.104309-2-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708092742.104309-1-ajd@linux.ibm.com>
References: <20250708092742.104309-1-ajd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=crubk04i c=1 sm=1 tr=0 ts=686ce4b7 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=Wb1JkmetP80A:10 a=7CQSdrXTAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8
 a=FZ1SKm-Zv34cIHXLlDMA:9 a=a-qgeE7W1pNrGK8U0ZQC:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: U9FR-Eu4HpNa-sHoBx23d4_GZU4urg5a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA4MDA3NiBTYWx0ZWRfX+FvDV7Xd0T5e MsMvbdzbR8bmZo2n4yU4HnFcZfVGQ9CzcETfTBn55GjJu6O0cX8DrwWyen7GxfQrd+JBIaTmjkx FGj6YvQPfgMKbhPHtCK4vgCsJQkUXL/3hrd7kf7bRar3jE1mFH3AWTQOnuh9RlZqdXbmoD9X6/S
 i+0FaS/kGyz5B3q8cAhPPek1xmq9fVtP0q3vM/U0SAgK8dLvShC8NmPXExtsU62rX99BDYWeFHD 8oRXaM1zf4QQlEUemMaufUFvDhEmBZuGbKDsPt2mpH1m1f1i/N5Yvn8MQiox2uGOWbV1mBwpo6s ATVQHqnKtjSQfI4X90WVdkWV44YABcNDXn31m5nnMQYIS8K8AmbYD37c/u2FV74gj2Mj4NDyHwP
 s3dmXNYP+yqdRUzmsMWn59RJn+PnhVpSsNZYS61/Y1V8paheAwm9Ld6oVGBk0a5lRDVRRTFW
X-Proofpoint-GUID: U9FR-Eu4HpNa-sHoBx23d4_GZU4urg5a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-08_02,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=828
 priorityscore=1501 adultscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507080076

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
2.50.0


