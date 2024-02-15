Return-Path: <kvm+bounces-8734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA478855D24
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 10:00:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07ED91C21C2D
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 09:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B36741AAB1;
	Thu, 15 Feb 2024 08:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HudTR39M"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A99317741;
	Thu, 15 Feb 2024 08:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987488; cv=none; b=ootuvejP4gazCPAQ/gbwdzHNVNybTkqHPF9EMGW009U0GmGzXcagm2eR3qId12IyFDtDMuzroHv9+QyvENJlXWT+3I3Ow0I96IIdQrLv3D7rX9ikonKMahLWBP62jUwIpM+grvIH/B5PQielDslEmNUp55yqNUe7gPlzQo6mdeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987488; c=relaxed/simple;
	bh=+gcsxoQvX6QlykVu3RVGSqy/SWH5P0NH92lt2Z/NHLc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=VP7tOtG1J8y5DVXdGfokTQusf7sB4dE4+rwTa/w+sZRwcgdjycnp0KzBxexqNdEVhF38vx5cNOGzgLJ068/7nZr28IkYLrqVEf7jE5+xxFJmEv5t/2C4yKRqUG6LW4p7QNodLER1PTdNwPLPU0dq/r/LaoQrgBW1yu9fUXJk1Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HudTR39M; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41F6iPAw031358;
	Thu, 15 Feb 2024 08:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=Ntu4DcQjGQsU8Mtl03jq//04K+iPyGzeMZZQoek0Cmc=;
 b=HudTR39MlWO+GCb9oPGIv7Vb5AP7LG/gaWZq1GcVqFpVuF2A6FoU8ZSGcHaGAE/xVS9c
 TM1MZXMV5azt7ExHep4cSzZSO3Uu68aOB2v39wufRG9kXQUKpTiZZI0O+dxovARO9PAn
 yVdSdkedWupjGH6TExOadvmV9R8s31tvj2ubUFDJvY0WNe5Jo6VlyG2OpRqjujX6CIE/
 9YapsA+M2ZLwjyH+IoHwLDscIgzpaE8WT31t1Zxn1xjqFZ08cD/Wad8EHimvrL+1ssyv
 v3iTUETtYegByXsT9NRtsRvDpievHAPJP6Df9sWPw00jp/0azr8viu8fKDvMzEi7rXj6 Fw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92pphew7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41F85PoG015098;
	Thu, 15 Feb 2024 08:57:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yka73fv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:18 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41F8vDcp033748;
	Thu, 15 Feb 2024 08:57:17 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w5yka73cg-2;
	Thu, 15 Feb 2024 08:57:17 +0000
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
Subject: [PATCH v4 1/8] x86: Move ARCH_HAS_CPU_RELAX to arch
Date: Thu, 15 Feb 2024 09:41:43 +0200
Message-Id: <1707982910-27680-2-git-send-email-mihai.carabas@oracle.com>
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
X-Proofpoint-ORIG-GUID: Wy8QVjZ3Eode5e8NCy2g6PmIrvXOPHbD
X-Proofpoint-GUID: Wy8QVjZ3Eode5e8NCy2g6PmIrvXOPHbD
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Joao Martins <joao.m.martins@oracle.com>

ARM64 is going to use it for haltpoll support (for poll-state)
so move the definition to be arch-agnostic and allow architectures
to override it.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 arch/Kconfig     | 3 +++
 arch/x86/Kconfig | 4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index a5af0edd3eb8..5b2e8a88853c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1363,6 +1363,9 @@ config RELR
 config ARCH_HAS_MEM_ENCRYPT
 	bool
 
+config ARCH_HAS_CPU_RELAX
+	bool
+
 config ARCH_HAS_CC_PLATFORM
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5edec175b9bf..8c4312133832 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -73,6 +73,7 @@ config X86
 	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CPU_PASID		if IOMMU_SVA
+	select ARCH_HAS_CPU_RELAX
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE	if !X86_PAE
@@ -367,9 +368,6 @@ config ARCH_MAY_HAVE_PC_FDC
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ARCH_HAS_CPU_RELAX
-	def_bool y
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
-- 
1.8.3.1


