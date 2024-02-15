Return-Path: <kvm+bounces-8740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2A2855D35
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 10:03:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52259282A0E
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 09:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45B81BDC3;
	Thu, 15 Feb 2024 08:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l/9auz30"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6F7219EB;
	Thu, 15 Feb 2024 08:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987507; cv=none; b=gh5iIlZnuHOYJU/b5NxKISPbo13DhAYrFGPbHq7RI6Ot58jbnBSJg7QskIv0c9j5ejxcQw6RfqkAe2eIa7AOHuUyxam1qLPtCBvemwtID8uh7O/j/wRKh+E7K9uLqQN2Cq+yKj1tK0x0jGdKluvYZNqU5YdKqNAaJ+9AHfA7VN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987507; c=relaxed/simple;
	bh=taIMkmgjssmhEC0ZPe6RFUXMNpIm1p4svqj+IoHOQQ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=KFdBNGqUKCfUyl9VBj85pNH3eJaxlMDnb328T+AGhV+aha+cfArpTGqeQBhZ7tEqG4VpmVkCa4EYrGvGvFX5N9zSlVN5iKwi0kIANixOE34ujnkseMURWdaBy9CjEHXEXGOU1gDQdSu7D3pC0xWACkJwNh9osTfqaXn7FtRGiss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l/9auz30; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41F6icwN032668;
	Thu, 15 Feb 2024 08:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=6KDNlbJKwQaVVi8iZUM/SOJEGq248dU9EixloG0v3NY=;
 b=l/9auz3098bmaqsmPhx4befqpe7lUC7sQOXfkoPnsyctLv1Mn2GvtGrEEonNUz/PRSbK
 vkoPUnDqB5/H1Lk/xiL6Lc4SqkVXy7tfnjLgoenQFTXxoazXYiJbiBRxjYk2nnH5T4Rq
 HhbT71dBV/BV4j2Wes908/FuKQwl6HyKQh0F5RTCQRhT1RuKJgGGBHNKvfC/BScXz9JZ
 9frLvvg3KxAX9Bl1nZzTkXX4Iwpbgg80Y642hf2JK84tqnFcGXsgTYTi1rVsZuxLisB+
 jF2cGjfsiR8pT25+Oq2XdO/lPWQtElYb/JAjr1I+equ0+Pqtn/ClljB17fD/Pp9uB7oe Mw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w91w6sm14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41F75mac015097;
	Thu, 15 Feb 2024 08:57:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yka73wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:45 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41F8vDd5033748;
	Thu, 15 Feb 2024 08:57:44 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w5yka73cg-9;
	Thu, 15 Feb 2024 08:57:44 +0000
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
Subject: [PATCH v4 8/8] cpuidle: replace with HAS_CPU_RELAX with HAS_WANTS_IDLE_POLL
Date: Thu, 15 Feb 2024 09:41:50 +0200
Message-Id: <1707982910-27680-9-git-send-email-mihai.carabas@oracle.com>
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
X-Proofpoint-ORIG-GUID: dNXyji989GyJZ4dchNZTScxbHZCJTiW7
X-Proofpoint-GUID: dNXyji989GyJZ4dchNZTScxbHZCJTiW7
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Replace ARCH_HAS_CPU_RELAX with ARCH_WANTS_IDLE_POLL for clarity as it controls
the building of poll_state.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Ankur arora <ankur.a.arora@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 arch/Kconfig                  | 2 +-
 arch/arm64/Kconfig            | 2 +-
 arch/x86/Kconfig              | 2 +-
 drivers/acpi/processor_idle.c | 4 ++--
 drivers/cpuidle/Makefile      | 2 +-
 include/linux/cpuidle.h       | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 5b2e8a88853c..e7659a3a7d58 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1363,7 +1363,7 @@ config RELR
 config ARCH_HAS_MEM_ENCRYPT
 	bool
 
-config ARCH_HAS_CPU_RELAX
+config ARCH_WANTS_IDLE_POLL
 	bool
 
 config ARCH_HAS_CC_PLATFORM
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index bc628a3165eb..7c963f7c10e4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -107,7 +107,7 @@ config ARM64
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
-	select ARCH_HAS_CPU_RELAX
+	select ARCH_WANTS_IDLE_POLL
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8c4312133832..90f5d16be8c0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -73,7 +73,7 @@ config X86
 	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CPU_PASID		if IOMMU_SVA
-	select ARCH_HAS_CPU_RELAX
+	select ARCH_WANTS_IDLE_POLL
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE	if !X86_PAE
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 55437f5e0c3a..6a0a1f16a5c3 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -36,7 +36,7 @@
 #include <asm/cpu.h>
 #endif
 
-#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX) ? 1 : 0)
+#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_WANTS_IDLE_POLL) ? 1 : 0)
 
 static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
 module_param(max_cstate, uint, 0400);
@@ -787,7 +787,7 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 	if (max_cstate == 0)
 		max_cstate = 1;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX)) {
+	if (IS_ENABLED(CONFIG_ARCH_WANTS_IDLE_POLL)) {
 		cpuidle_poll_state_init(drv);
 		count = 1;
 	} else {
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index d103342b7cfc..23f48d99f0f2 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -7,7 +7,7 @@ obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
 obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
 obj-$(CONFIG_DT_IDLE_STATES)		  += dt_idle_states.o
 obj-$(CONFIG_DT_IDLE_GENPD)		  += dt_idle_genpd.o
-obj-$(CONFIG_ARCH_HAS_CPU_RELAX)	  += poll_state.o
+obj-$(CONFIG_ARCH_WANTS_IDLE_POLL)	  += poll_state.o
 obj-$(CONFIG_HALTPOLL_CPUIDLE)		  += cpuidle-haltpoll.o
 
 ##################################################################################
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 3183aeb7f5b4..53e55a91d55d 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -275,7 +275,7 @@ static inline void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev,
 }
 #endif
 
-#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_HAS_CPU_RELAX)
+#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_WANTS_IDLE_POLL)
 void cpuidle_poll_state_init(struct cpuidle_driver *drv);
 #else
 static inline void cpuidle_poll_state_init(struct cpuidle_driver *drv) {}
-- 
1.8.3.1


