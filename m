Return-Path: <kvm+bounces-7324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D241D840463
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B385B250B6
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 11:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 382205FEE5;
	Mon, 29 Jan 2024 11:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d2vB39I4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E2A60869;
	Mon, 29 Jan 2024 11:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706529400; cv=none; b=qxwp8rhUmNffY9EEfn+smy7zneFljF23RKbrWyUZalY/F1csYZ080ImMX6BzPzypCVgslktyXgk2EEdAX7fLtZiUnqA3n0oQy2Ta+beKwPCT1wxajs7CsDjDjEXNCtz8Kd2cJaFLxoCmEy3JTyDo1qg752P0KFWCg7ZnePHL6KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706529400; c=relaxed/simple;
	bh=WsC1jzqJt8v0tVnaYxv4ggMXksNSjkzD9+2lyOkYaLE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=dLqOC2g1NkprWtOArZKKZf17nyuIkFOQoDrffG50PWC5cweaVP9I/my5Q+wwolwvyYgj1CzmopgGXIEnvy7njfewclGIcWsoAL+tDtZ5mQ7U87FyP7xHJrU6pFEVVJ9k9dB2DAWfbTNrmYf5b1RYrsPW/i76/ZAPSEXaFq/1Wtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d2vB39I4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40T9i5rb003224;
	Mon, 29 Jan 2024 11:56:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=uAhbu4AUajdcQROPp7AvbiHI/LFlFhMVo6VGoxnZCWM=;
 b=d2vB39I4Og0wxCVnADXW1/7MnjlGyD2CUhMp3SC3IT8uGtcqSgDb6v/sZdoKLENxoEfe
 4n6c2zqynNAZtBYQ7ZzFWa7f4OKN1yIAmJXXuoZMx1DD3IKKTDV2NW3nJ93hJJM1sgFZ
 ImdnnCApsS+0VQidCglEggQp9Tp5Q1lryPNnIMWvUI1wUM/vqqyrWHoGVu1lEboRaYgf
 Myd65CzEyBjg/UNp6qSPMZHnSEOejfkdLzRUMzStmig3OhXqSCBJenSD5NaUf0uL9Lty
 bkc0S3AFI1qFrtQCK6C+yOWl1HkGDgfV9hruFaNq8gAocyQusznCblARVfdaZzH0Uj2D Xg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvre2bpy9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:56:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TB1FB6035346;
	Mon, 29 Jan 2024 11:55:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9bhd06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:59 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40TBtniI038181;
	Mon, 29 Jan 2024 11:55:58 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3vvr9bhcty-8;
	Mon, 29 Jan 2024 11:55:58 +0000
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
Subject: [PATCH v3 7/7] cpuidle/poll_state: replace cpu_relax with smp_cond_load_relaxed
Date: Mon, 29 Jan 2024 12:40:34 +0200
Message-Id: <1706524834-11275-8-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com>
References: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_06,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401290086
X-Proofpoint-GUID: dQYM6tQD_1vhmUDfI0qPFICGEXTzpN_a
X-Proofpoint-ORIG-GUID: dQYM6tQD_1vhmUDfI0qPFICGEXTzpN_a
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

cpu_relax on ARM64 does a simple "yield". Thus we replace it with
smp_cond_load_relaxed which basically does a "wfe".

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 drivers/cpuidle/poll_state.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 9b6d90a72601..440cd713e39a 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -26,12 +26,16 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
 
 		limit = cpuidle_poll_time(drv, dev);
 
-		while (!need_resched()) {
-			cpu_relax();
-			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
-				continue;
-
+		for (;;) {
 			loop_count = 0;
+
+			smp_cond_load_relaxed(&current_thread_info()->flags,
+					      (VAL & _TIF_NEED_RESCHED) ||
+					      (loop_count++ >= POLL_IDLE_RELAX_COUNT));
+
+			if (loop_count < POLL_IDLE_RELAX_COUNT)
+				break;
+
 			if (local_clock_noinstr() - time_start > limit) {
 				dev->poll_time_limit = true;
 				break;
-- 
1.8.3.1


