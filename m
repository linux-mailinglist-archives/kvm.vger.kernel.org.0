Return-Path: <kvm+bounces-44352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C160EA9D422
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 23:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBAB14E2C5E
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 21:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E82225414;
	Fri, 25 Apr 2025 21:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AeszN19u"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF9D21B91F
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 21:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745616783; cv=none; b=NOOFdE68+eEaFlcN+WfCxoDy+ADaf3ZeW/DfPoMh5M2CgYxIQhLDEKcbBvJmtsJ4Lw9akCXmwfsw4WW4ospeQFJs7c9oKOdgBPmBgXaAs6ehMZhGaQKLsGcbGTe3fUulCkShd8Qapal8KTZwx3JulYMndRi3IdhiQqYo1SQmJis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745616783; c=relaxed/simple;
	bh=dMmgmG0qePgyRiHiwsw4SM8DF3A0zLtr2r5+6wrruLk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g4Dt+ssNDC4RU/tnHzw7uwLnJ+rzYHXv8BFY3UHehXOr//R9Adz/Ez7HdWn0eLnwFLRJtiGGSCCeQZsasT3Fq6CqbpcKMStjQzIAlI1aNgcp4JO3pHMcsXOEJ85ZMqM7s0ZUnZQPfDHz0IWOHoWdQ+P6C/K9zBrB4BInpblXwjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AeszN19u; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53PL21RE005102;
	Fri, 25 Apr 2025 21:32:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=WDO3NaUFvql5R5Q8LdPImmvxOUc2S
	vbyQZAQGVdP+j4=; b=AeszN19ucTHVzlA/NQhPKtUJuzD1L7wjFd3C1cgvvnmPZ
	7Mtp6TSC1zXkyrApcOPZKp8rv87hCX7TOlZZfMweKfHzuDbL3lbbVK8iX++SinIV
	qBiPJ2v5+UWMBQu1BTKWQ4+dKCq8+g9X5BSANUwIZn/Jv+MfPq9khb9VvJxGeAti
	QCSeG+puofuwdCk2f5v3J3eBhv+QxVGdwerSLRLqntZVWKc2fmff7PSC4iTq+jUW
	NhVerPKNbgQxfFYfDIIZuZahJkfO8ITlInidZ0B5nd+me/t/jwV1xTRS9Ek/UJzT
	ICsjuWs/h+yGk8Q6UkTDEiKU6hZWkGhFzsaTDBAmw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 468hxvg8wf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 21:32:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53PL0WVp031074;
	Fri, 25 Apr 2025 21:31:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 466k095v3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 21:31:41 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53PLVdAV039597;
	Fri, 25 Apr 2025 21:31:39 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 466k095v2d-1;
	Fri, 25 Apr 2025 21:31:39 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
        peter.maydell@linaro.org, gaosong@loongson.cn, chenhuacai@kernel.org,
        philmd@linaro.org, aurelien@aurel32.net, jiaxun.yang@flygoat.com,
        arikalo@gmail.com, npiggin@gmail.com, danielhb413@gmail.com,
        palmer@dabbelt.com, alistair.francis@wdc.com, liwei1518@gmail.com,
        zhiwei_liu@linux.alibaba.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        flavra@baylibre.com, ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com,
        cobechen@zhaoxin.com, louisqi@zhaoxin.com, liamni@zhaoxin.com,
        frankzhu@zhaoxin.com, silviazhao@zhaoxin.com, kraxel@redhat.com,
        berrange@redhat.com
Subject: [PATCH v5 00/10] target/i386/kvm/pmu: PMU Enhancement, Bugfix and Cleanup
Date: Fri, 25 Apr 2025 14:29:57 -0700
Message-ID: <20250425213037.8137-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-25_07,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504250154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI1MDE1NSBTYWx0ZWRfX/JGrdm4b1gKF b2NcXX1//fLXAZCsBhQB7pf9sdZ5I1Im197QXgCFDEMuq4GSp2r2qMgS5JP66Fr2njMis+6O+Ie mQN1uDFkRiEv2XkCtUZtkLtvnV1ImpfbvgStSi5RT895koAcXg0IC3Kz7zTo3GzPybFUPunMkYV
 k7z9EM0ryoOPJc1BgJ1fmmLF6Yk9d7zjzYm6l2ElqhROdEuSkuyQ6qVtVh/CCDMMd59lk1RaS22 MuHCrK/xBAYlfNtDiomdBN70kDIukCP0C9YrStNvjU12kmk0FdP8TyXcTO6vCFTygm7I+K0WH0E JHBp8z8s4ifyjKNRQedSwNUTK9BlO8Od/B1DftmhzKABQghRz9I7YQdU/sR0kx0U6wTrDpYXqyN dFQLEoTU
X-Proofpoint-GUID: LRKEPpbRnUEiyTV8M7RN8lJZZS_iQOlB
X-Proofpoint-ORIG-GUID: LRKEPpbRnUEiyTV8M7RN8lJZZS_iQOlB

This patchset addresses four bugs related to AMD PMU virtualization.

1. The PerfMonV2 is still available if PERCORE if disabled via
"-cpu host,-perfctr-core".

2. The VM 'cpuid' command still returns PERFCORE although "-pmu" is
configured.

3. The third issue is that using "-cpu host,-pmu" does not disable AMD PMU
virtualization. When using "-cpu EPYC" or "-cpu host,-pmu", AMD PMU
virtualization remains enabled. On the VM's Linux side, you might still
see:

[    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.

instead of:

[    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
[    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled

To address this, KVM_CAP_PMU_CAPABILITY is used to set KVM_PMU_CAP_DISABLE
when "-pmu" is configured.

4. The fourth issue is that unreclaimed performance events (after a QEMU
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


Changed since v1:
  - Use feature_dependencies for CPUID_EXT3_PERFCORE and
    CPUID_8000_0022_EAX_PERFMON_V2.
  - Remove CPUID_EXT3_PERFCORE when !cpu->enable_pmu.
  - Pick kvm_arch_pre_create_vcpu() patch from Xiaoyao Li.
  - Use "-pmu" but not a global "pmu-cap-disabled" for KVM_PMU_CAP_DISABLE.
  - Also use sysfs kvm.enable_pmu=N to determine if PMU is supported.
  - Some changes to PMU register limit calculation.
Changed since v2:
  - Change has_pmu_cap to pmu_cap.
  - Use cpuid_find_entry() instead of cpu_x86_cpuid().
  - Rework the code flow of PATCH 07 related to kvm.enable_pmu=N following
    Zhao's suggestion.
  - Use object_property_get_int() to get CPU family.
  - Add support to Zhaoxin.
Changed since v3:
  - Re-base on top of Zhao's queued patch.
  - Use host_cpu_vendor_fms() from Zhao's patch.
  - Pick new version of kvm_arch_pre_create_vcpu() patch from Xiaoyao.
  - Re-split the cases into enable_pmu and !enable_pmu, following Zhao's
    suggestion.
  - Check AMD directly makes the "compat" rule clear.
  - Some changes on commit message and comment.
  - Bring back global static variable 'kvm_pmu_disabled' read from
    /sys/module/kvm/parameters/enable_pmu.
Changed since v4:
  - Re-base on top of most recent mainline QEMU.
  - Add more Reviewed-by.
  - All patches are reviewed.


Xiaoyao Li (1):
  kvm: Introduce kvm_arch_pre_create_vcpu()

Dongli Zhang (9):
  target/i386: disable PerfMonV2 when PERFCORE unavailable
  target/i386: disable PERFCORE when "-pmu" is configured
  target/i386/kvm: set KVM_PMU_CAP_DISABLE if "-pmu" is configured
  target/i386/kvm: extract unrelated code out of kvm_x86_build_cpuid()
  target/i386/kvm: rename architectural PMU variables
  target/i386/kvm: query kvm.enable_pmu parameter
  target/i386/kvm: reset AMD PMU registers during VM reset
  target/i386/kvm: support perfmon-v2 for reset
  target/i386/kvm: don't stop Intel PMU counters

 accel/kvm/kvm-all.c        |   5 +
 include/system/kvm.h       |   1 +
 target/arm/kvm.c           |   5 +
 target/i386/cpu.c          |   8 +
 target/i386/cpu.h          |  16 ++
 target/i386/kvm/kvm.c      | 360 ++++++++++++++++++++++++++++++++++------
 target/loongarch/kvm/kvm.c |   4 +
 target/mips/kvm.c          |   5 +
 target/ppc/kvm.c           |   5 +
 target/riscv/kvm/kvm-cpu.c |   5 +
 target/s390x/kvm/kvm.c     |   5 +
 11 files changed, 372 insertions(+), 47 deletions(-)

base-commit: 019fbfa4bcd2d3a835c241295e22ab2b5b56129b

Thank you very much!

Dongli Zhang


