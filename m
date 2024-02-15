Return-Path: <kvm+bounces-8733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D06C855D74
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 10:11:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9D31B2AD55
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 09:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1165A18038;
	Thu, 15 Feb 2024 08:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WRi9b08m"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17DE13AFB;
	Thu, 15 Feb 2024 08:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987488; cv=none; b=uU22jSrqzDwWSWJ1kdZEkdVqla9GuFsjusfD/ogOJNxNg6hKIZntlAG8Y/p1gELgeVhjn5Ntr2r6KIxe/XM0+dqJpkxLsN3XGW7RYupvpmzVkKmmlxznKbtN88qSyZhNfqrc1I2rruySBqDDgFg6duJWMINLIbmL2xTa612X1R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987488; c=relaxed/simple;
	bh=qlzyj+96ZrnytPQobnPb0r/WF8j47o3LcA2aSb8TKyA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=hQyeIoTCpTMkeGuRsDjNbKTovHJ3Wy0ecbUcTs2N5r5hv4PniiwRqaKCRAocqwx29Es5jiE0p0YW1B+iC3wbbIL4Daet5vL1V4PIQ8m1pk602R+nn0xNH/IgPK4sLErBE0py44ibCz5bXnypTzfwj90FYoaP2xoiMoRNslOAWmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WRi9b08m; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41F6hvO5031013;
	Thu, 15 Feb 2024 08:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=jvWR7NadDlFzwGkQ9GO0hvSkDG29BscyHclo7q5ReKo=;
 b=WRi9b08m9JZKxZQtqSdGDNGMJmfgsXFaXifrH7kiE2hTFz2TUI+Q6XxPldhhFkCaVw72
 waBjiKtL2PDEUVvA784P4MiIMApM7zqObVd+8dcalPugRvgieK3Qjf4zkKlpsuyPFDje
 erx5W+eTal5sFRp5m1ILpVyWF36D5O1XZUNZK5FQp75bgriOQQX7f3ejSy8DER0TqTVf
 kVQCcegr1Uq4Z7ToTUpPrYYs9PLTq+8wtE2Li4m8SmUjcZcx0GsvgngNWszLq1K8+3GO
 nZ5aLwBzZt3g5fJj1cPgFLio2aHDdRxFYsDQKZSBnEphrlMVmMqYOPkexAJLauGHGeEd /Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92db1g5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41F7Lq25015051;
	Thu, 15 Feb 2024 08:57:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yka73k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:25 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41F8vDct033748;
	Thu, 15 Feb 2024 08:57:24 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w5yka73cg-4;
	Thu, 15 Feb 2024 08:57:24 +0000
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
Subject: [PATCH v4 3/8] governors/haltpoll: Drop kvm_para_available() check
Date: Thu, 15 Feb 2024 09:41:45 +0200
Message-Id: <1707982910-27680-4-git-send-email-mihai.carabas@oracle.com>
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
X-Proofpoint-GUID: 6QwEybfJDMqlGTaCvgEBGb9IQtnd8AGQ
X-Proofpoint-ORIG-GUID: 6QwEybfJDMqlGTaCvgEBGb9IQtnd8AGQ
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


