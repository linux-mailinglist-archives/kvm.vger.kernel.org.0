Return-Path: <kvm+bounces-8739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E862855D96
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 10:16:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B167B3145F
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 09:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A6D1EA7A;
	Thu, 15 Feb 2024 08:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BlA22SaI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206781CAA2;
	Thu, 15 Feb 2024 08:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987498; cv=none; b=EJXUvzszXBliqUPRFEsAYihesN8C39bdqAfrHvMunMy16l0qsp9YkD3o7xVjgIfVko+/WD0NTe6mnz6GiamsqFjMY8F87JdcPtrQTjdQhnTGRHkzyQrwNRnTe9S0VbFlmiVSq+bCE40hELUZF8wtK2xUZ+22+NMLZp/KthcpNfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987498; c=relaxed/simple;
	bh=oT5VmBJQVuSb8o/SFdi2izyADM9BamqPWkKDm1+wq1o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=u0yhwLbbzm2p2Ga45C2XqISVvzlDL4eeX35wBsts2gPO4NPnpSsBzAKpffhKDMH87o4DwuVb2250kg6oF6q+aU7Eu6ggMfGvCVkiKS0kwkcrD9E3K3a42nqfGouBSparRKgc3KAAHEdZ5rjqTLoGqq/7LWzcTY8XpotqFjTTciU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BlA22SaI; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41F6hwpN031109;
	Thu, 15 Feb 2024 08:57:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=V7nZPrYATUFAp4Eq6Ao12RohHH79Z76Hub/Iv1Wwg9w=;
 b=BlA22SaI3Sw51j5gazMju97Qto7T6hUCurUosEOXlvs0PuY+8W8Go93/L9IMz3os663E
 xZCFdkH+O1yYi4gZtjzwapSaLWID0A0cVQzcsgwllh8edoGznjSP8++xRlbXldYJNwG7
 FMkfzk8BFTo1WglNESBFqNzjbbhiHY51HGjY65oOIb94qHQ3VwFWGfhBacWy+IO562Xr
 wY8ZEv9Z7ExVgZAtZJ7oET49irB4DbZaNhLHSsyS8d4P/sagmo/BnYQ+STH4/sXnZtoL
 5eAPRCElFfpI+AnZQsecZBZufSKkGSpGKT4talSjUuuOXYiHaCANrxpwEfyDZWNvXKKw dQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92db1g5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41F74A09015104;
	Thu, 15 Feb 2024 08:57:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yka73q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:34 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41F8vDcx033748;
	Thu, 15 Feb 2024 08:57:33 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w5yka73cg-6;
	Thu, 15 Feb 2024 08:57:33 +0000
From: Mihai Carabas <mihai.carabas@oracle.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
        akpm@linux-foundation.org, pmladek@suse.com, peterz@infradead.org,
        dianders@chromium.org, npiggin@gmail.com, rick.p.edgecombe@intel.com,
        joao.m.martins@oracle.com, juerg.haefliger@canonical.com,
        mic@digikod.net, mihai.carabas@oracle.com, arnd@arndb.de,
        ankur.a.arora@oracle.com
Subject: [PATCH v4 5/8] arm64: Define TIF_POLLING_NRFLAG
Date: Thu, 15 Feb 2024 09:41:47 +0200
Message-Id: <1707982910-27680-6-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
References: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_08,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=871 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402150069
X-Proofpoint-GUID: xa6bMgHE2XaJ7zKkzKlmHBXQxg2JYjTu
X-Proofpoint-ORIG-GUID: xa6bMgHE2XaJ7zKkzKlmHBXQxg2JYjTu
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Joao Martins <joao.m.martins@oracle.com>

The default idle method for arm64 is WFI and it therefore
unconditionally requires the reschedule interrupt when idle.

Commit 842514849a61 ("arm64: Remove TIF_POLLING_NRFLAG") had
reverted it because WFI was the only idle method. ARM64 support
for haltpoll means that poll_idle() polls for TIF_POLLING_NRFLAG,
so define on arm64 *only if* haltpoll is built, using the same bit.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 arch/arm64/include/asm/thread_info.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index e72a3bf9e563..72273a2168fa 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -69,6 +69,9 @@ struct thread_info {
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
 #define TIF_SECCOMP		11	/* syscall secure computing */
 #define TIF_SYSCALL_EMU		12	/* syscall emulation active */
+#if IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE) || IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE_MODULE)
+#define TIF_POLLING_NRFLAG      16      /* poll_idle() polls TIF_NEED_RESCHED */
+#endif
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
@@ -91,6 +94,9 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#if IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE) || IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE_MODULE)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
+#endif
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
-- 
1.8.3.1


