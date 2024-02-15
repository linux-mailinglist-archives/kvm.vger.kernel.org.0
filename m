Return-Path: <kvm+bounces-8737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC089855D2D
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 10:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67E4528CC93
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 09:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90261CA98;
	Thu, 15 Feb 2024 08:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V1dZ8wGT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926D91B966;
	Thu, 15 Feb 2024 08:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987496; cv=none; b=WNCKsC64LpZmlR7KASA1AcURm4jUt/efdBVWYLBg8eR+dEzyskZVAMyoWnmx9+bg1MAkAV2MqyZ28YyosL9GZeuCDN8UmAPLGG+xajEI9o9Z1h7mK+8qMOV2q3jWX9TY6QgBGg15WyZhWM98Z95oxx7YuBpUKDsHXL9dkIRIcfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987496; c=relaxed/simple;
	bh=0yDZe5Gug3G88eQxog9P6hpCmjQ2/vQHDkmYBm8PlKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=fiQim1EXd6nFAWf1qDxLx54MdUHiHOlgg+ami5B63mK8DEYMxPVfxj4N2AoNweH7XdHjIQP91YhaHfWp8Gw/lDGBA6Fqtjb5efih+s6AHJyuTlJ1aHd/ovEmUEZQwrMmKe7IuT+yMHqrwWs/VJTL5VwvrwccOg2qhaWAwpRopdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V1dZ8wGT; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41F6iQBu013773;
	Thu, 15 Feb 2024 08:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=jwgRCWyFl1O7epx0x8iWWiua+ulnxF3yCh67glyLBKk=;
 b=V1dZ8wGTWncD6/oeL4npJv5r3qB9QQyQ354M+jNqsYr9rnpvDUERlOeH+NdbrBKgQ6CS
 pOGHTJtca0j8dyy22O/OtRTqFnTr7RbEvG0ScNGOMiV3GDRqjUKRc94NQe4V1Ist/uYj
 H+v5isde01nAQcPUE77GPN2aYudxmg24uUwSoyKCsjM//ueSpjBodcZN4B55mcedlw56
 3k6f8+16qhIF5BzQZcFF/Nqyg8sn96TW6nVezl9+8p+DMMZEX0zN6E9tlPBEHDTw6bJe
 iLyOgZ0DNR6GRR0DkJKhw2rGtVlKfwuH1X5OW0XCBPQVfE294RnfKgOLP7XWQLevvGqM YQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92s71e5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41F8qUA6015081;
	Thu, 15 Feb 2024 08:57:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yka73ts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:42 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41F8vDd3033748;
	Thu, 15 Feb 2024 08:57:41 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w5yka73cg-8;
	Thu, 15 Feb 2024 08:57:41 +0000
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
Subject: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with smp_cond_load_relaxed
Date: Thu, 15 Feb 2024 09:41:49 +0200
Message-Id: <1707982910-27680-8-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
References: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_08,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402150069
X-Proofpoint-GUID: yJ-iS1FTL20fHuvoqISXh1LxTLdGOEcN
X-Proofpoint-ORIG-GUID: yJ-iS1FTL20fHuvoqISXh1LxTLdGOEcN
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
 drivers/cpuidle/poll_state.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 9b6d90a72601..1e45be906e72 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -13,6 +13,7 @@
 static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
 {
+	unsigned long ret;
 	u64 time_start;
 
 	time_start = local_clock_noinstr();
@@ -26,12 +27,16 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
 
 		limit = cpuidle_poll_time(drv, dev);
 
-		while (!need_resched()) {
-			cpu_relax();
-			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
-				continue;
-
+		for (;;) {
 			loop_count = 0;
+
+			ret = smp_cond_load_relaxed(&current_thread_info()->flags,
+						    VAL & _TIF_NEED_RESCHED ||
+						    loop_count++ >= POLL_IDLE_RELAX_COUNT);
+
+			if (!(ret & _TIF_NEED_RESCHED))
+				break;
+
 			if (local_clock_noinstr() - time_start > limit) {
 				dev->poll_time_limit = true;
 				break;
-- 
1.8.3.1


