Return-Path: <kvm+bounces-2123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 141EC7F1716
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 16:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2CAC28264E
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 15:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D7D1DA50;
	Mon, 20 Nov 2023 15:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PXGctP8k"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59193E3;
	Mon, 20 Nov 2023 07:16:26 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AKF2Xiu027684;
	Mon, 20 Nov 2023 15:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-03-30;
 bh=jvWR7NadDlFzwGkQ9GO0hvSkDG29BscyHclo7q5ReKo=;
 b=PXGctP8kK83qZQr/QrngTQAKyslavPV3OWnRsNgdjoPQ5ai8UlBuI/aqLW78o7K1eGeY
 CkVUrRns3obYl/Ezm7d3zf/jsP3rVb5DPNdBvvcqdP98+7yPsKbIhRHjjbKqB9xourkE
 o378uCFOMfhgCLNcUArVhL8KbKFH4ZYzWSaU28gK02VdHpg0ud+46DBuXw/Pe5WyWl7J
 zSYt0ngm2DICsgCzsuaWD2pnehrVn4/T23MNFQ5biRTIDO8BnmyXZnlqtzgodLDz6rl+
 KfsX303umfKEyokorNWmBfrJIGEf/xS3iaNGIVipLj247f+XS+Z/kb7alcx3ORspJCGH XA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uekpejweq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Nov 2023 15:15:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AKFEBi1023458;
	Mon, 20 Nov 2023 15:15:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekq5gr1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Nov 2023 15:15:20 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AKFFF8V037000;
	Mon, 20 Nov 2023 15:15:19 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uekq5gqwc-4;
	Mon, 20 Nov 2023 15:15:19 +0000
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
Subject: [PATCH 3/7] governors/haltpoll: Drop kvm_para_available() check
Date: Mon, 20 Nov 2023 16:01:34 +0200
Message-Id: <1700488898-12431-4-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-20_15,2023-11-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311200106
X-Proofpoint-GUID: ycvbtnCkoaZmONsfMaKmlECRuVQg_4Ux
X-Proofpoint-ORIG-GUID: ycvbtnCkoaZmONsfMaKmlECRuVQg_4Ux
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


