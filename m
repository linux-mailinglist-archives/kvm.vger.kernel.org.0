Return-Path: <kvm+bounces-7330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 495D5840475
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:58:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCB111F22F44
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 11:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B9C5EE82;
	Mon, 29 Jan 2024 11:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hqSVP9IZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4639160895;
	Mon, 29 Jan 2024 11:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706529406; cv=none; b=ZEM3rju9KCMaWTNi8EUcENtCvA1JQ0t0d8CFVdqWvR2+pt77U10Kv0vfimz6piIpYiXrqfpNGEmKXIn5YQhFp8sC0uXWTdMpiMVxsU/1z9y72OtohxD3sCcoFTuCqPT+fPMhVDCsjya0su/Z5YfVeGqHZHmMpu2fRmZ8u/rOcIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706529406; c=relaxed/simple;
	bh=Cx1GJ8tb4Rwe9cT5ZQ3JwMc7AvNFn8941Kx/X8gvbD8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=TFDcgkbZmcCvE5DnF0VxLBpHGsi8Ak+QHbSjS2qKWBXjVSWggvIG2Ild7REBfMWFZYReNxW8gx+CvGamClKDmm8OVCzq5tJoWVQFdeJAKJwBSCZI/i1WhoCZpTacqUsb2stuSUk8/t3B2PclUR7KNWkKYJOpuURjLQVu0eXzJ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hqSVP9IZ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40T9hsPs018230;
	Mon, 29 Jan 2024 11:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=3CBdIWj34ZRhxUcc3rj18We/Fw9vZjncSXWx3xdqX8c=;
 b=hqSVP9IZpA55IVek6IxGZrONcsUKQGHODmUbsbu747x8cLxEx71QsVDw9BHKFYCPCzZ2
 6HyS1Jzu0vTplAorSzgAcxzIqGSSw2ZrJpHFxjyuDvAzI2YebDntEttJAH13AhOAs1mZ
 FI7hIyUYWq8zTiB7sXMS+4o/q1jAu4OEh0/ubwKyfk51Cl97cZQA9BT/EiSc9Cu6AGuO
 L/FboliuBk34d08FXWenHldP/8grWKwzP7V8QuDkP/QKogHQvpNyn+k/w7/F/31ltZ10
 8R3BZMABjfE8+bx3kQaxuwgcT+o4tPpYCQD2tzPwaLyK9JOZVwcGQEP87X8RBV2zgTCo LQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8ebmp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:57 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TB2icS035421;
	Mon, 29 Jan 2024 11:55:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9bhcxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:56 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40TBtniE038181;
	Mon, 29 Jan 2024 11:55:56 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3vvr9bhcty-6;
	Mon, 29 Jan 2024 11:55:56 +0000
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
Subject: [PATCH v3 5/7] arm64: Define TIF_POLLING_NRFLAG
Date: Mon, 29 Jan 2024 12:40:32 +0200
Message-Id: <1706524834-11275-6-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com>
References: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_06,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=865 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401290086
X-Proofpoint-ORIG-GUID: w4KDuam02VO2JcdZ0ujKc5qyJMf4Ztb4
X-Proofpoint-GUID: w4KDuam02VO2JcdZ0ujKc5qyJMf4Ztb4
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
index 553d1bc559c6..d3010d0b2988 100644
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
@@ -90,6 +93,9 @@ struct thread_info {
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


