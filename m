Return-Path: <kvm+bounces-66819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5322FCE8ED0
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 08:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 94D39300FFB5
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 07:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0FCD2FD7D5;
	Tue, 30 Dec 2025 07:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IF/WjOqE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A2C255F2D
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 07:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767081318; cv=none; b=NWdhDzQbwYfKN2XMtNyIqXZEH724SiRK4ZNb6fJvdd9CDHNLQDv3CHoTDRCMFf7ZdbczBnMkZ2VvE9cIhdtFHbQJuO4yNbWmo9GgDL7VBXpARa2Pu87WwTH7qRnaJfOFa961me/UBdSYwF1hEGTEtT7PkzIWAef/haLeTFXew08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767081318; c=relaxed/simple;
	bh=xa8p+IrB7XauXeRVc9tlfhM/gwRXRqVZ8EwqQnJXqhI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PLeeGybPTwt10B7qqeSQjEtusH+1SorCOrDBDNQYEcVW7AwVsZtn0XoBww8QyfexaBwRXN6ENXpBgY9SNcgXQ6uS8QCxRa38mojgIxAg+gfObBxBWX0gNxtewk1eGk97sKKTvlG+pzn54QwVSLTkYgg2DI8zP4aKvGjCVbWgY4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IF/WjOqE; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BU4NklF3344100;
	Tue, 30 Dec 2025 07:54:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=mDJ+F4bb2t8Y0xfwErkGSiBKtTQiH
	2gr6KrWscr0NZ4=; b=IF/WjOqE3b6bEqC6bXgfB7Td/8tXi+X5Q/qckX4ICTYpN
	7l0P+a181HxxZmmevoeaIkR+R3QVe6ytKTX21LdWWJeR17xEKkjqdQKshjcrvkhu
	c0sZBFJWluyZtdtJSjlA/xbV1KCqnrZBaKk3NJu11P/LPQaJn0Hnp8lrfGyTCTdK
	TUxsI2GbbAqe1aqtZF5OMXpbYRSAiDZpFnsRVyy9SGoKDKQsk5Y+HtmHK8dJf59F
	OfVsc2BZwsR2E1hyql7xNg60CNSvSaGTKaFVKxCt7tja9h3JmNC+StIoHC9NaIdm
	sPVsuGHFZG/dkkvVt/I98T2OPKBZkMYc2iiMX4b/w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba680jbr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 07:54:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BU3LP5O018165;
	Tue, 30 Dec 2025 07:54:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wbp6ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 07:54:49 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BU7smZj005421;
	Tue, 30 Dec 2025 07:54:48 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ba5wbp6aa-1;
	Tue, 30 Dec 2025 07:54:48 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v8 0/7] target/i386/kvm/pmu: PMU Enhancement, Bugfix and Cleanup
Date: Mon, 29 Dec 2025 23:42:39 -0800
Message-ID: <20251230074354.88958-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512300070
X-Proofpoint-ORIG-GUID: VCQtyE2ObboHeeuntCUFXDUKHHQt7tSq
X-Proofpoint-GUID: VCQtyE2ObboHeeuntCUFXDUKHHQt7tSq
X-Authority-Analysis: v=2.4 cv=HPLO14tv c=1 sm=1 tr=0 ts=6953854a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=NMLfzRoFxyNNWpThmMoA:9 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDA3MCBTYWx0ZWRfXx+fRklLbwHP5
 AsaA9+cs3GbsW/UqQLSYLuW7QjHTn/x1HuoBSRABuLyAqPi84VwD3FVZpxkRawXOp+vH/xQRS2L
 d/jpOCr59RglC8PdAGYgzJzvd8vc/mrjIBPyUD9wNobgqbwseZkUhLUrUjXO6A7NZM3wOldKOge
 BurjB503LhYF3+YssdkjIhp8GKgE7uCrEZfBP3O+A+VdVpIU8ucBJ0CFVMGJCxk0qzNkMZvVxLL
 VsCsF1v0cEruRvDa+mMP3bTofoOG9vgfkEJYr+PzZbPnevi7vNyiAKxP6+mkxNk3fRbrOTaaCCb
 WeJm2tu75n+1yB9tB+s1zj0+UI8yhLTRzrAv83Zu9d40cnJzzyWYHB2ksu6WOdSbBimNBDxbq4T
 EY2wj90myhhbM+sZlsoWk5/AqmyK2XUdDnrcU2V1POsNWvp2CJT1QyHpkqRs226hrdBYU+MXoRr
 iA7K7HIWlWv+ht0k54f20yD+XRg1Q7mzRuQx+g3A=

This patchset addresses two bugs related to AMD PMU virtualization.

1. The third issue is that using "-cpu host,-pmu" does not disable AMD PMU
virtualization. When using "-cpu EPYC" or "-cpu host,-pmu", AMD PMU
virtualization remains enabled. On the VM's Linux side, you might still
see:

[    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.

instead of:

[    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
[    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled

To address this, KVM_CAP_PMU_CAPABILITY is used to set KVM_PMU_CAP_DISABLE
when "-pmu" is configured.

2. The fourth issue is that unreclaimed performance events (after a QEMU
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
Changed since v5:
  - Re-base on top of most recent mainline QEMU.
  - Remove patch "kvm: Introduce kvm_arch_pre_create_vcpu()" as it is
    already merged.
  - To resolve conflicts in new [PATCH v6 3/9] , move the PMU related code
    before the call site of is_tdx_vm().
Changed since v6:
  - Re-base on top of most recent mainline QEMU (staging branch).
  - Add more Reviewed-by from Dapeng and Sandipan.
Changed since v7:
https://lore.kernel.org/qemu-devel/20251111061532.36702-1-dongli.zhang@oracle.com/
  - Re-base on top of most recent mainline QEMU (staging branch).
  - Remove PATCH 1 & 2 from the v6 patchset. Zhao may work on them in
    another patchset.


Dongli Zhang (7):
  target/i386/kvm: set KVM_PMU_CAP_DISABLE if "-pmu" is configured
  target/i386/kvm: extract unrelated code out of kvm_x86_build_cpuid()
  target/i386/kvm: rename architectural PMU variables
  target/i386/kvm: query kvm.enable_pmu parameter
  target/i386/kvm: reset AMD PMU registers during VM reset
  target/i386/kvm: support perfmon-v2 for reset
  target/i386/kvm: don't stop Intel PMU counters

 target/i386/cpu.h     |  16 ++
 target/i386/kvm/kvm.c | 355 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 324 insertions(+), 47 deletions(-)

branch: remotes/origin/staging
base-commit: 942b0d378a1de9649085ad6db5306d5b8cef3591

Thank you very much!

Dongli Zhang


