Return-Path: <kvm+bounces-7329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD157840472
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:58:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 894B7283433
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 11:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFDE8612C1;
	Mon, 29 Jan 2024 11:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GxdsCwcy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4636760894;
	Mon, 29 Jan 2024 11:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706529405; cv=none; b=qXumSMViWCH6sxucV6pt3LsjVjPTE4981mKiP/HA32AVl1xF6UCc8fSf5pKOI6362Swa4dN8ulei6AcOc+ayrqcuCmDiBYEA3Tu25+lnQjxjQLtZPaZc5u3chOrdavUF9AFfsMmpVZqvc4+IaLa2H8JbMHvrBCZ9gpP5KCS4oqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706529405; c=relaxed/simple;
	bh=j70rx+VQHeY0jsYZxVvue52ZMDvklrAsMHXOdmSrQVM=;
	h=From:To:Cc:Subject:Date:Message-Id; b=V4dooTEqLzc8WUGB31L+fhcBwXYgJS6uUnlfHX+0aYfWtQDuPK/4awh3kG0KtgjUbw9T9zaPhfggD6mG9EkZ5YYLxhYPxsxvMfb0smNhkY1GFr8s6dQDlW6icSUQ3milAZ223kj+G8iJmA6yaT3QYkXJ4wqungtQA8haIE263sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GxdsCwcy; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40T9htgo018239;
	Mon, 29 Jan 2024 11:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2023-11-20;
 bh=khCABu2u7h0ji9nwNiqkSsP2cO6XtkgpM/puPUnlX54=;
 b=GxdsCwcy6W7KrLSL9Q62IYajfegQuNXie2fefIwLnLJvP8UGfKQZZp+KGhoWOYg+V6q/
 +IOsIAb/ftRQt/2IBW73+uLGqP/zole4RmYYu+GVBeY+3CCb2TpVviDJW4sDO3Cyqyt9
 JEXmGEfZTqpWdq50xV9n7auf4Uh87hYFtqT0JRKj8QQkmJ1WxPSF84paH3DuYR6RMOaj
 KSLsss3KtXt+eDYU2ZBLc9OLglrkTCPCbnkwLE775GpPt3pCPyiYh61qVqkItW1mS89b
 8Qc9jOz1WsofVlpJj1QuKy/IRqanCSnUrqJ5jdkCEGoOfFULmh1h6JKrFLrBoNjW1IbA nQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8ebmnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TB1FB3035346;
	Mon, 29 Jan 2024 11:55:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9bhcup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:50 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40TBtni4038181;
	Mon, 29 Jan 2024 11:55:49 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3vvr9bhcty-1;
	Mon, 29 Jan 2024 11:55:49 +0000
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
Subject: [PATCH v3] Enable haltpoll for arm64
Date: Mon, 29 Jan 2024 12:40:27 +0200
Message-Id: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_06,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401290086
X-Proofpoint-ORIG-GUID: wmHlvaEDvTR0tZrspV1ngSlSErMsp9jW
X-Proofpoint-GUID: wmHlvaEDvTR0tZrspV1ngSlSErMsp9jW
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

This patchset enables the usage of haltpoll governer on arm64. This is
specifically interesting for KVM guests by reducing the IPC latencies.

Here are some benchmarks without/with haltpoll for a KVM guest:

a) without haltpoll:
perf bench sched pipe
# Running 'sched/pipe' benchmark:
# Executed 1000000 pipe operations between two processes

     Total time: 8.138 [sec]

            8.138094 usecs/op
             122878 ops/sec

b) with haltpoll:
perf bench sched pipe
# Running 'sched/pipe' benchmark:
# Executed 1000000 pipe operations between two processes

     Total time: 5.003 [sec]

            5.003085 usecs/op
             199876 ops/sec

v3 changes from v2:
- fix 1/7 per Petr Mladek - remove ARCH_HAS_CPU_RELAX from arch/x86/Kconfig
- add Ack-by from Rafael Wysocki on 2/7

v2 changes from v1:
- added patch 7 where we change cpu_relax with smp_cond_load_relaxed per PeterZ
  (this improves by 50% at least the CPU cycles consumed in the tests above:
  10,716,881,137 now vs 14,503,014,257 before)
- removed the ifdef from patch 1 per RafaelW

Joao Martins (6):
  x86: Move ARCH_HAS_CPU_RELAX to arch
  x86/kvm: Move haltpoll_want() to be arch defined
  governors/haltpoll: Drop kvm_para_available() check
  arm64: Select ARCH_HAS_CPU_RELAX
  arm64: Define TIF_POLLING_NRFLAG
  cpuidle-haltpoll: ARM64 support

Mihai Carabas (1):
  cpuidle/poll_state: replace cpu_relax with smp_cond_load_relaxed

 arch/Kconfig                            |  3 +++
 arch/arm64/Kconfig                      |  1 +
 arch/arm64/include/asm/thread_info.h    |  6 ++++++
 arch/x86/Kconfig                        |  4 +---
 arch/x86/include/asm/cpuidle_haltpoll.h |  1 +
 arch/x86/kernel/kvm.c                   | 10 ++++++++++
 drivers/cpuidle/Kconfig                 |  4 ++--
 drivers/cpuidle/cpuidle-haltpoll.c      |  8 ++------
 drivers/cpuidle/governors/haltpoll.c    |  5 +----
 drivers/cpuidle/poll_state.c            | 14 +++++++++-----
 include/linux/cpuidle_haltpoll.h        |  5 +++++
 11 files changed, 41 insertions(+), 20 deletions(-)

-- 
1.8.3.1


