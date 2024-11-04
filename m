Return-Path: <kvm+bounces-30472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA0C9BAFF5
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C057E281074
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58B01AE018;
	Mon,  4 Nov 2024 09:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hLdiW093"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292E21AC426
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 09:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713348; cv=none; b=Kg5xL6Y4TC703p8jQtfh8aqBWqykhZcSOBfPXe4K0Dn5i0jztrG9FnD40VhqZhdF94GFLKRzC3e8PvXEejA6721UjRjJHSOaTVR15QLlRxqxqpuS/uzlHXliuQEoJx9uzvxXXcydGzabQbKUQR0K8PWhBe7xDvkwBB65bzLu4Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713348; c=relaxed/simple;
	bh=ZSYmqfoz7t+BUzI5agte4B32oF51dtz5KgzbgtZdds4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PzqavT4IQ2pXMzkDuQin+5jgLv5NzRsHEKYMpHvRzQJ7HOHw2KzbneCUm1wCvceCMbQaG6KIcVr2AJxOY1DFkBnJM7WN1clx7VOcIZAERUYgH2iWHvqnu0E2gUClSznQpv+3qOIZhZ5R6cn6Zx3ZLgpV+X8d+ojWG7h3sdXRL0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hLdiW093; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A48fdat008888;
	Mon, 4 Nov 2024 09:41:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=efxZ+pER+q4v74XJIjjsu0KmwnruS
	Bhe+A90aSlQdbo=; b=hLdiW093K/QE38G1v1sC5r12yPvRtmd5+FDKAw+mrqNVD
	6JiT4wVq6trvsw7yGzONcCUX++YlrHeekSb6KUWTHOv/uNMNsdTv1sklTCzzPwYl
	JSJTTS784rijrhgm0DhcEtFYdjmLiXgY5F5gh9sYSisqx2oF8wuNwP8x/aOb/XHF
	edQlYB7cIOmszSSNdo6h6yMRdjdNnty0gWwLt7spqzFcgkUvY5UoAkDZL267PCzX
	oCRaLzR4aeKevgk7eBRfax+rP6cI+Kyzzvq+mI5HduAsYoYPq5iGBIctdA0x0kTy
	VPwFrjjEhEnadc/z2D6eMMnfFGG+fWnLxsZOGgUWw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nbpsj984-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:41:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A49fL0h009833;
	Mon, 4 Nov 2024 09:41:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahbt084-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:41:52 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A49fqfc018519;
	Mon, 4 Nov 2024 09:41:52 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nahbt06k-1;
	Mon, 04 Nov 2024 09:41:52 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, zhao1.liu@intel.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        davydov-max@yandex-team.ru
Subject: [PATCH 0/7] target/i386/kvm/pmu: Enhancement, Bugfix and Cleanup
Date: Mon,  4 Nov 2024 01:40:15 -0800
Message-ID: <20241104094119.4131-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_07,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411040085
X-Proofpoint-ORIG-GUID: DxPDOSl2QbZlB_mlYH2bG4qAi-qYaU3s
X-Proofpoint-GUID: DxPDOSl2QbZlB_mlYH2bG4qAi-qYaU3s

This patchset addresses three bugs related to AMD PMU virtualization.

1. The PerfMonV2 is still available if PERCORE if disabled via
"-cpu host,-perfctr-core".

2. The second issue is that using "-cpu host,-pmu" does not disable AMD PMU
virtualization. When using "-cpu EPYC" or "-cpu host,-pmu", AMD PMU
virtualization remains enabled. On the VM's Linux side, you might still
see:

[    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.

instead of:

[    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
[    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled

To address this, we have introduced a new x86-specific accel/kvm property,
"pmu-cap-disabled=true", which disables PMU virtualization via
KVM_PMU_CAP_DISABLE.

Another previous solution to re-use '-cpu host,-pmu':
https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/


3. The third issue is that unreclaimed performance events (after a QEMU
system_reset) in KVM may cause random, unwanted, or unknown NMIs to be
injected into the VM.

The AMD PMU registers are not reset during QEMU system_reset.

(1) If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
running "perf top", the PMU registers are not disabled properly.

(2) Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
does not handle AMD PMU registers, causing some PMU events to remain
enabled in KVM.

(3) The KVM kvm_pmc_speculative_in_use() function consistently returns true,
preventing the reclamation of these events. Consequently, the
kvm_pmc->perf_event remains active.

(4) After a reboot, the VM kernel may report the following error:

[    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
[    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)

(5) In the worst case, the active kvm_pmc->perf_event may inject unknown
NMIs randomly into the VM kernel:

[...] Uhhuh. NMI received for unknown reason 30 on CPU 0.

To resolve these issues, we propose resetting AMD PMU registers during the
VM reset process


Dongli Zhang (7):
  target/i386: disable PerfMonV2 when PERFCORE unavailable
  target/i386/kvm: introduce 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
  target/i386/kvm: init PMU information only once
  target/i386/kvm: rename architectural PMU variables
  target/i386/kvm: reset AMD PMU registers during VM reset
  target/i386/kvm: support perfmon-v2 for reset
  target/i386/kvm: don't stop Intel PMU counters

 accel/kvm/kvm-all.c        |   1 +
 include/sysemu/kvm_int.h   |   1 +
 qemu-options.hx            |   9 +-
 target/i386/cpu.c          |   3 +-
 target/i386/cpu.h          |  12 ++
 target/i386/kvm/kvm.c      | 340 ++++++++++++++++++++++++++++++++++------
 target/i386/kvm/kvm_i386.h |   2 +
 7 files changed, 319 insertions(+), 49 deletions(-)

base-commit: c94bee4cd6693c1c65ba43bb8970cf909dec378b

Thank you very much!

Dongli Zhang


