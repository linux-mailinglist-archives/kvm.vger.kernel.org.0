Return-Path: <kvm+bounces-8732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 442D7855D1E
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 09:59:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2538282B42
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 08:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E9D175BF;
	Thu, 15 Feb 2024 08:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cz18BKNb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC18175A7;
	Thu, 15 Feb 2024 08:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987486; cv=none; b=I41PW/xMR2KibydSb2wuWR6AQYRjW4dP1wI+bBcEekERQThEftaTmBxg/e35TUinCYLjHsU4a8TPLco/EV4JD4VsjJPPk0xLEQli3rIJ0KdBexKbd1yoR3ZRUo3kJ1ZLJg9kk2+d0PgvfPDgpywu/Y+805IUppoyb9WbUmHgGqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987486; c=relaxed/simple;
	bh=ImNrQLgIeJnqStKW95YKMd6VX4+V1wmIsSBThs5l88A=;
	h=From:To:Cc:Subject:Date:Message-Id; b=W3YuBN1ZEW7DQGMnTmgRBdwfp6wR/gaSCWvetV8hc184HJh0pcNQoI7xqiJUbNIUt5gjOpXSBldJ9u9cuBe/I5CNw/KjFKBgYg+bT/BcBXuEsT7MdSVSRPNOuzVrliKUD1lSdV4WNK9xSt771gk15Unc/kGHzR+OYbZ3mjSZ9r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cz18BKNb; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41F6iGU1028944;
	Thu, 15 Feb 2024 08:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2023-11-20;
 bh=d00ENsVVO2BUUiKiQK/NT8Am5rm3PPvRj7bhWXLIxeI=;
 b=Cz18BKNbW3mZnHIGsI0HuBAizNvyCnHWWiYcqAUDEzyOSowmLzAhXyZaE+WOa8cLJl9J
 RtAgCG2VULB+BbDlCx7QAoIv2Ur7Tz54y2L/fibEKCGPBgTf3lYSOReEPqthJcKIG3xK
 dcU3/e/CnRIBq8X6zTdj3nd9p3olh5V0z/r0IBNoYQzZdrk5mHf+JoYVcFviEV1K2Cso
 oNlb0bzj+fggO3x2UlYZ5QEhHrqThfASff0T/GQBje+XFiOSQSPst0BxDtJNS9qJC06t
 4U0mlNgQ2WAKsl9vAiCNCs5tEq2XZFjtgUC/0sxWcLT4hQk0kucuFVngbjrNkPqQ/buQ LA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92j0hfj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:15 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41F7eCkt015079;
	Thu, 15 Feb 2024 08:57:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yka73ee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:57:14 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41F8vDcn033748;
	Thu, 15 Feb 2024 08:57:13 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w5yka73cg-1;
	Thu, 15 Feb 2024 08:57:13 +0000
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
Subject: [PATCH v4] Enable haltpoll for arm64
Date: Thu, 15 Feb 2024 09:41:42 +0200
Message-Id: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_08,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402150069
X-Proofpoint-GUID: W2tqgJhCuy4PFws6pzqvzZ38a5-0OFFZ
X-Proofpoint-ORIG-GUID: W2tqgJhCuy4PFws6pzqvzZ38a5-0OFFZ
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

v4 changes from v3:
- change 7/8 per Rafael input: drop the parens and use ret for the final check
- add 8/8 which renames the guard for building poll_state

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

Mihai Carabas (2):
  cpuidle/poll_state: replace cpu_relax with smp_cond_load_relaxed
  cpuidle: replace with HAS_CPU_RELAX with HAS_WANTS_IDLE_POLL

 arch/Kconfig                            |  3 +++
 arch/arm64/Kconfig                      |  1 +
 arch/arm64/include/asm/thread_info.h    |  6 ++++++
 arch/x86/Kconfig                        |  4 +---
 arch/x86/include/asm/cpuidle_haltpoll.h |  1 +
 arch/x86/kernel/kvm.c                   | 10 ++++++++++
 drivers/acpi/processor_idle.c           |  4 ++--
 drivers/cpuidle/Kconfig                 |  4 ++--
 drivers/cpuidle/Makefile                |  2 +-
 drivers/cpuidle/cpuidle-haltpoll.c      |  8 ++------
 drivers/cpuidle/governors/haltpoll.c    |  5 +----
 drivers/cpuidle/poll_state.c            | 15 ++++++++++-----
 include/linux/cpuidle.h                 |  2 +-
 include/linux/cpuidle_haltpoll.h        |  5 +++++
 14 files changed, 46 insertions(+), 24 deletions(-)

-- 
1.8.3.1


