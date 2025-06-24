Return-Path: <kvm+bounces-50463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83CBFAE5E5E
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:50:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18F273A3A84
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 07:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFA22586EF;
	Tue, 24 Jun 2025 07:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BvbCpUm5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28944246BCD
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 07:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750751378; cv=none; b=iJdvmPU8xyQOdfPpUafhFbIARhl5kCnEH9uMR83wO9VPGfbIdoqdZp7VTVF43HwJghkPZLPhT1BPQMrcuTsiFF6OZkVCQJ8mtWd5CfRjDTNefqorE0woFWvczkKhQ8H6IW5LrIPzE+2mAq/TlouMzvKvTMPIBQAq97y1r865dJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750751378; c=relaxed/simple;
	bh=UohwtgHOxH0yXuhRMphses8SaiQseg0ke0g8fKjFygc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DfdHagzy+3LE/VtG0S3eJ0qtc6sHzj2Y+2QK0a0cIy8PNp4Bov3C+XXMfF6VllgEvwyPR+2ae4eHdJlP0qCy9uYq+/X9QK0ngwlY/EswfuINpntQACZ8Q4YW0ZyNX2Pnt5vEHNkNVxcrrKdONUfvEGtK1mKoOCcMf5gzEwPWwxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BvbCpUm5; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55O7fcC5004449;
	Tue, 24 Jun 2025 07:49:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=S7Y4Y7QwwEtPGhQ1qP1HYcOK4wPf+
	b0BqE47i5KwRoM=; b=BvbCpUm50VeeglHZqnre6bELCwnPjJT/u4K0xpUZhB1uF
	R0O4/HYKk5K84acWjwyhwmQbEKTmlh7eX7V+uhDir4Oj5kgzeVQE+LPvS2uIpkZk
	015ouTb/QUbZOgUiGnoDt9nfLoD2lviTVesAgDQpgHtab2ULkvs04oNhltZgXckv
	drvDFeT1qKkLvS1hrwb3Gd+vRj8mbJswfIiEHsJsPXc/nIQIync1t0x+XgglufP2
	0qdhHVp8/srPfE6aG4B+OoVOkeCmOtpD6/GEjRq7FZEogf6+EvdALhvPp3z+y8tu
	ZoJ4gpV5FNSVjKWiSGs1F9hd9TeWuYc2YnXPziLqw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds87vh69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 07:49:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55O61ju6006903;
	Tue, 24 Jun 2025 07:49:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq3ar21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 07:49:06 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55O7n5Xg006279;
	Tue, 24 Jun 2025 07:49:05 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ehq3ar1g-1;
	Tue, 24 Jun 2025 07:49:05 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v6 0/9] target/i386/kvm/pmu: PMU Enhancement, Bugfix and Cleanup
Date: Tue, 24 Jun 2025 00:43:19 -0700
Message-ID: <20250624074421.40429-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_02,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506240066
X-Authority-Analysis: v=2.4 cv=a8gw9VSF c=1 sm=1 tr=0 ts=685a5873 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=NMLfzRoFxyNNWpThmMoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDA2NiBTYWx0ZWRfXwpoWEKNgMOMA 7xd/beEobb0j6gSjTXMzXh+FINFKr21EtiSvlzOT9OX1NG/hz6lRaCbEdlcGUXENiL7CDFipAvV FC9f+nwCT/eCPS7z/kzsVrcfmKOfl0RozOms3Cw1Dv+wNpqSyfCOolC6GwXUFIS2zNaCQ0ofd0x
 oqSaahQpjw6oJougwPxIu0m3XVXPKLeyNsYuaI+853lvlcQkWGB4NaNu6k2kIy4QPbJrBEU6bKd CSx11UtQjSrBtgGzUbQ5WsIJoQsV3Epwgq5vv6YSI5sg5UsYWYPFMivTwoMQxU7UhJ69JSJ4nXy mq56NAkwGLOjR4D1YAi+QMp0F5fM902MpFwpRyOWUZ/8MYhtQH2aszsG0SchGUKslK2S8F9nSCn
 IrhuJfGCa/kX4dRSOOd0A/KVrVXtn/oI1qdRGXvws2e7AeNR6NNKNh6f6Fl+DfySHI0API4x
X-Proofpoint-GUID: worRoaCAl4saazWi9G0Tb24k3A2AI21c
X-Proofpoint-ORIG-GUID: worRoaCAl4saazWi9G0Tb24k3A2AI21c

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
Changed since v5:
  - Re-base on top of most recent mainline QEMU.
  - Remove patch "kvm: Introduce kvm_arch_pre_create_vcpu()" as it is
    already merged.
  - To resolve conflicts in new [PATCH v6 3/9] , move the PMU related code
    before the call site of is_tdx_vm().


There is regression in mainline QEMU when "vendor=" is involved in QEMU
command line. I have reverted it when testing with "vendor=".

https://lore.kernel.org/all/d429b6f5-b59c-4884-b18f-8db71cb8dc7b@oracle.com/


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

 target/i386/cpu.c     |   8 +
 target/i386/cpu.h     |  16 ++
 target/i386/kvm/kvm.c | 355 +++++++++++++++++++++++++++++++++++++++------
 3 files changed, 332 insertions(+), 47 deletions(-)

base-commit: 43ba160cb4bbb193560eb0d2d7decc4b5fc599fe

Thank you very much!

Dongli Zhang


