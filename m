Return-Path: <kvm+bounces-7326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82102840468
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B522C1C2281C
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 11:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9456E605AF;
	Mon, 29 Jan 2024 11:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mIHfky7E"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A8960860;
	Mon, 29 Jan 2024 11:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706529401; cv=none; b=q5A4BxGVSGZzraXDCa8wmj3pyjsb5qpvqz9LItbSnvA8X5bQ/OAphnrIZ1wYcd5v2YdpbypbuyDze2hIV0FZpMPi/hOGloWHrGapVEn1N7FXEtY01Xqm3Og/D6LXK5PwGWYBwWF4hMnwTT2Iyfp2p7nWtSk2RWfmTXvT8oVCMZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706529401; c=relaxed/simple;
	bh=qlzyj+96ZrnytPQobnPb0r/WF8j47o3LcA2aSb8TKyA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=raJIsq2TPNjINF1hZDeYYN651PkSb68gJtvUzDdfrBtspdES28Gk0TXPghON3p6KUaRGCQuF5BIT9LbV3Z7TomzJI651aOGKKWl/nMb2V6unhXKKIBXGtqg4k4W7MSF0YDsY2usNhnXc04PGyM5QobcErKi/USHyh13UOr/9YDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mIHfky7E; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40T9i5pp003211;
	Mon, 29 Jan 2024 11:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=jvWR7NadDlFzwGkQ9GO0hvSkDG29BscyHclo7q5ReKo=;
 b=mIHfky7E3ZVq89y+h++cazzdxYOZhpRh06Ua50nwE+I9dOSa5F/Rh7fnAaJg0c5fwtsO
 Or9jdrivbDDg1ac5LC0Dx7r0AmpdziQeSOjWBi6FBWb3m6oAQQosLX7CQWZTOz43zPPg
 otclHA/xfDrqqj2tuRj/3njnceR0ttIRwPNRLJwHO0d3fABq6ly9BtEq/Qv6TWL7ltsz
 i2fjohb9k46XyN7jfRceN/YGihaY8EVLjPIW36Cx/XepNY5PnoGnhTVlu2LbcdDz4rob
 vb1Tt7j5/cNMfbmJdT0wi2hk+Hipz9gf7RjDjcI0580B3bC8VZOXeJ88mZSWXIClpZzC AA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvre2bpy7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TBL2qK035600;
	Mon, 29 Jan 2024 11:55:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9bhcwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:54 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40TBtniA038181;
	Mon, 29 Jan 2024 11:55:53 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3vvr9bhcty-4;
	Mon, 29 Jan 2024 11:55:53 +0000
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
Subject: [PATCH v3 3/7] governors/haltpoll: Drop kvm_para_available() check
Date: Mon, 29 Jan 2024 12:40:30 +0200
Message-Id: <1706524834-11275-4-git-send-email-mihai.carabas@oracle.com>
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
X-Proofpoint-GUID: sMWD6riPKGFyMhV-2WyYkmbDKSMPpW5R
X-Proofpoint-ORIG-GUID: sMWD6riPKGFyMhV-2WyYkmbDKSMPpW5R
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Joao Martins <joao.m.martins@oracle.com>

This is duplicated already in the haltpoll idle driver,
and there's no need to re-check KVM guest availability in
the governor.

Either guests uses the module which explicitly selects this
governor, and given that it has the lowest rating of all governors
(menu=20,teo=19,ladder=10/25,haltpoll=9) means that unless it's
the only one compiled in, it won't be selected.

Dropping such check also allows to test haltpoll in baremetal.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
---
 drivers/cpuidle/governors/haltpoll.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
index 1dff3a52917d..c9b69651d377 100644
--- a/drivers/cpuidle/governors/haltpoll.c
+++ b/drivers/cpuidle/governors/haltpoll.c
@@ -143,10 +143,7 @@ static int haltpoll_enable_device(struct cpuidle_driver *drv,
 
 static int __init init_haltpoll(void)
 {
-	if (kvm_para_available())
-		return cpuidle_register_governor(&haltpoll_governor);
-
-	return 0;
+	return cpuidle_register_governor(&haltpoll_governor);
 }
 
 postcore_initcall(init_haltpoll);
-- 
1.8.3.1


