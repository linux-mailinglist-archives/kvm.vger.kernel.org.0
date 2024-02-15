Return-Path: <kvm+bounces-8736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73EFB855D2B
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 10:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C66528BEB0
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 09:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3119F1BC5A;
	Thu, 15 Feb 2024 08:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YC+l+PUr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F941B957;
	Thu, 15 Feb 2024 08:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987495; cv=none; b=PG7M/xGq1siRpui23DY+TcPrcK3HeyX4n9QUpW/L9q3bqZGGPx74uyO7XYRscJ5OJYKUQbk1u8nlPQ2l+eaNJOQ/WJUpZ3C31x3KJncYguPSXFAZBQudKR/Ws+/jb/7i087WY4WwXAMJK84QLmE9Kmd+8SFt3YdpzvDRitAG6hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987495; c=relaxed/simple;
	bh=k7bPu+gk7Cd3HeftqicW+V1b6QVdrKTlCbgVbfhaERo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=SZqv+GMel7eJLC6dU7XhMRS5sj/v8ctPSIpzZcyECawjb47cz13EGrER/MZiKwEtQKl4mS/DqrZDx6/PY2lpAQiqpdLoxOKxe66TB0zcyigjTMavgH8Gx5nWxcx/1pqrL4ZZWsWiz0+wXD1omIdGoE8NI5WcPWPpjQ2MO5L2c1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YC+l+PUr; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41F6iQ1A013781;
	Thu, 15 Feb 2024 08:57:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=hlNIjt1lJtZP47W7eO4KvEIII2+KWpAFpv+PlhUsURU=;
 b=YC+l+PUrMU5xBqA3hq5Ym58t6zY7CWPc4uYSBWvHEueWoJE5dL/FHQon3qwvOhNsOmVT
 TGHG20yQgpgfYShmuseYEPcpslkrzpYmaPFXw6fEpA0mRShnQpodYDoWOyA/nxGpSGnE
 OS+4xtCJEQWlgPqNu3YZyTNf5gPWQp2BuVgHuc1zrb18f/coAUr7eBIQ1gqqUux0AdT3
 o6854UF23FxKthuiawWppPdx874M4D0pWvqPLflguM1Rqza6RiQtY5BvoimwKgiihRDQ
 z+tUYV5TXsSEBVyfZueWGf+2AIBxMI1Qg+xCGGXmnFGWj/tDWkInOAifBDTxfb1rsbSJ RA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92s71e5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41F7oN7n015119;
	Thu, 15 Feb 2024 08:57:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yka73re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:38 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41F8vDd1033748;
	Thu, 15 Feb 2024 08:57:37 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w5yka73cg-7;
	Thu, 15 Feb 2024 08:57:37 +0000
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
Subject: [PATCH v4 6/8] cpuidle-haltpoll: ARM64 support
Date: Thu, 15 Feb 2024 09:41:48 +0200
Message-Id: <1707982910-27680-7-git-send-email-mihai.carabas@oracle.com>
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
X-Proofpoint-GUID: DKEm_88vuEAgYfwqE-BtVNjQU26GaIam
X-Proofpoint-ORIG-GUID: DKEm_88vuEAgYfwqE-BtVNjQU26GaIam
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Joao Martins <joao.m.martins@oracle.com>

To test whether it's a guest or not for the default cases, the haltpoll
driver uses the kvm_para* helpers to find out if it's a guest or not.

ARM64 doesn't have or defined any of these, so it remains disabled on
the default. Although it allows to be force-loaded.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 drivers/cpuidle/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index cac5997dca50..067927eda466 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -35,7 +35,7 @@ config CPU_IDLE_GOV_TEO
 
 config CPU_IDLE_GOV_HALTPOLL
 	bool "Haltpoll governor (for virtualized systems)"
-	depends on KVM_GUEST
+	depends on (X86 && KVM_GUEST) || ARM64
 	help
 	  This governor implements haltpoll idle state selection, to be
 	  used in conjunction with the haltpoll cpuidle driver, allowing
@@ -73,7 +73,7 @@ endmenu
 
 config HALTPOLL_CPUIDLE
 	tristate "Halt poll cpuidle driver"
-	depends on X86 && KVM_GUEST
+	depends on (X86 && KVM_GUEST) || ARM64
 	select CPU_IDLE_GOV_HALTPOLL
 	default y
 	help
-- 
1.8.3.1


