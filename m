Return-Path: <kvm+bounces-2124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A737F1717
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 16:16:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10A7B1C2184A
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 15:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F272F1DA59;
	Mon, 20 Nov 2023 15:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dpVGXuCU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C4CA4;
	Mon, 20 Nov 2023 07:16:26 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AKF2YMD031903;
	Mon, 20 Nov 2023 15:15:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2023-03-30;
 bh=gSfReHhfKOi6/nRYNpZrtc3XRA7XmQU426wYqdxf/X8=;
 b=dpVGXuCUTHX+qNDv/wPfLD0K6OEo23YTEUoTsWnljXC/a3KOsp062CrA2C9bxlmRSnN3
 yLxA5Yc9aBNYKwB+ldqAS9JxeQ6ixkzbI59ZVs0y7NMUookO+bSzikTYoT+zE5RwO2Kc
 Iot9xVbsAZ+PZSihd1v6oTTgUk2lldrBpD/i/Ng0Rq8eTqHtaws1st3ToRol/PoVtOdJ
 FPvIPE2hTAhucig96DhSLH/ydTFd0Eka8TXX7pT443C5R1k/FvOdkVWtu2JaM5raJUyw
 3pCVufb3E2ba0NOLqoOc5fauO4griykCUDM29APirCaLKV2P/5I4XLm6pc775y0IvakC Lg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uenadjw5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Nov 2023 15:15:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AKEASto023577;
	Mon, 20 Nov 2023 15:15:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekq5gqxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Nov 2023 15:15:16 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AKFFF8P037000;
	Mon, 20 Nov 2023 15:15:15 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uekq5gqwc-1;
	Mon, 20 Nov 2023 15:15:15 +0000
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
Subject: [PATCH v2] Enable haltpoll for arm64
Date: Mon, 20 Nov 2023 16:01:31 +0200
Message-Id: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-20_15,2023-11-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311200106
X-Proofpoint-GUID: PPjnYgJir-pqH-RF75ua-riMF-bK6vqM
X-Proofpoint-ORIG-GUID: PPjnYgJir-pqH-RF75ua-riMF-bK6vqM
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
 arch/x86/Kconfig                        |  1 +
 arch/x86/include/asm/cpuidle_haltpoll.h |  1 +
 arch/x86/kernel/kvm.c                   | 10 ++++++++++
 drivers/cpuidle/Kconfig                 |  4 ++--
 drivers/cpuidle/cpuidle-haltpoll.c      |  8 ++------
 drivers/cpuidle/governors/haltpoll.c    |  5 +----
 drivers/cpuidle/poll_state.c            | 14 +++++++++-----
 include/linux/cpuidle_haltpoll.h        |  5 +++++
 11 files changed, 41 insertions(+), 17 deletions(-)

-- 
1.8.3.1


