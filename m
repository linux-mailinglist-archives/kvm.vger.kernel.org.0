Return-Path: <kvm+bounces-43477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A141EA908D1
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 18:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 326FD3B501F
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 16:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5580A211A20;
	Wed, 16 Apr 2025 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oCB9zbLq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DCC20D4E0;
	Wed, 16 Apr 2025 16:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744820889; cv=none; b=OyfhBZlPRnAP59Dq88Ie2/DEH6d44X/7TtqjFJm3WhojD/4QfD2aS4aoas0nkd3J6mlckUlRRlVTODyxTTldYLt6+Yav8PbdwtLz1zaJfp0olFGrCSLo2tA5luAYP4yZ+4U/HIuOlEpAVkOYCoJMCObIZlYb5zAdCX4ZRCRamGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744820889; c=relaxed/simple;
	bh=rdTFXpZH2w/UzqthGLob8svtIMZDZOMuWAeyBLJAWLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A4cj5zoXaMNWoVvVjTmwWxlMgf9RyLNehg6jkIs2eZMKh71cgDZ8/pZ12wvf9jSbF5pBACHr/C0CBXl8DxwtOKVuX68TsH0h37Zt6VHFLyYMsiKHp6vuqEsk2pKzFrDQWpX5sK1qAKXhXAkkqcZpLBtyvk7rAUXofzYPSCKZyAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oCB9zbLq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53G96anP026707;
	Wed, 16 Apr 2025 16:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=da+OObykIRHK9oWWv8WzsinrJHuw6A0Ye/px6ESlW
	Us=; b=oCB9zbLqTXQYN5bPDMoafQ+zBvdlnoD8F9fcpFCW023D0Jd0GBLNdGZ3f
	mKXHMwlcFrFEEDHhBcnmQ4FJzQZ2whd2eW5jD4uWMtqbyQ7JFtrkK5f19BxFoYSK
	Ch02LL27G2jhTOQ7C2lMRBB9lQ4lj3S/gesPULC1zYcD914YvDI6gsD39jsQOCEV
	6ZzPohXdmDqCORkN5g9ou6lIgty156uzzEA3auiPLWfI4X3zKe//JdJTDyENUvrI
	5v+3XS5eRMwqixWKA1DLGcAbV2zUZ95GhVEQAXa9lNhw8USB+y1Lp/unq2C0QXc3
	vFohOPJC2HlIN8Wb5i9NK8frCT3ig==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 461ykt4nfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Apr 2025 16:27:54 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53GGGGEX029032;
	Wed, 16 Apr 2025 16:27:53 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 461ykt4nfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Apr 2025 16:27:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53GCoYHw024914;
	Wed, 16 Apr 2025 16:27:52 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4602gthhgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Apr 2025 16:27:52 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53GGRnKi17498490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 16:27:49 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B09220043;
	Wed, 16 Apr 2025 16:27:49 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64E1920040;
	Wed, 16 Apr 2025 16:27:45 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.124.210.156])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 16 Apr 2025 16:27:45 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Wed, 16 Apr 2025 21:57:44 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com, Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Subject: [RESEND PATCH v5 0/6] kvm powerpc/book3s-hv: Expose Hostwide counters as perf-events
Date: Wed, 16 Apr 2025 21:57:30 +0530
Message-ID: <20250416162740.93143-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: alXhQANi_bM_SHsW6YuK_YOJlAj8cw-R
X-Proofpoint-ORIG-GUID: j1295QK7O4EJCvHOLWgF_Pdml6f5eYYO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_04,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504160127

Changes from v5
Link: https://lore.kernel.org/all/20250317100834.451452-1-vaibhav@linux.ibm.com/
* Rebased to latest upstream kernel tree
* Added review-by from Athira to a patch.
============

Cover Letter
============

This patch-series adds support for reporting Hostwide(L1-Lpar) counters via
perf-events in a new kernel module named 'kvm-hv-pmu'. With the support for
running KVM Guest in a PSeries-Lpar using nested-APIv2 via [1], the
underlying L0-PowerVM hypervisor holds some state information pertaining to
all running L2-KVM Guests in an L1-Lpar. This state information is held in
a pre-allocated memory thats owned by L0-PowerVM and is termed as
Guest-Management-Area(GMA). The GMA is allocated per L1-LPAR and is only
allocated if the lpar is KVM enabled. The size of this area is a fixed
percentage of the memory assigned to the KVM enabled L1-lpar and is
composed of two major components, Guest Management Space(Host-Heap) and
Guest Page Table Management Space(Host-Pagetable).

The Host-Heap holds various data-structures allocated by L0-PowerVM for
L2-KVM Guests running in the L1-Lpar. The Host-Pagetable holds the Radix
pagetable[2] for the L2-KVM Guest which is used by L0-PowerVM to handle
page faults. Since the size of both of these areas is limited and fixed via
partition boot profile, it puts an upper bound on the number of L2-KVM
Guests that can be run in an LPAR. Also due limited size of Host-Pagetable
area, L0-PowerVM is at times forced to perform reclaim operation on
it. This reclaim operation is usually performed when running large number
of L2-KVM Guests which are memory bound and increases Host-Pagetable
utilization.

In light of the above its recommended to track usage of these areas to
ensure consistent L2-KVM Guest performance. Hence this patch-series
attempts to expose the max-size and current-usage of these areas as well as
cumulative amount of bytes reclaimed from Host-Pagetable as perf-events
that can be queried via perf-stat.

The patch series introduces a new 'kvm-hv' PMU that hosted in a new kernel
module named 'kvm-hv-pmu' which exports the perf-events mentioned
below. Since perf-events exported represents the state of the whole L1-Lpar
and not that of a specific L2-KVM guest hence the 'kvm-hv' PMU's scope is
set as PERF_PMU_SCOPE_SYS_WIDE(System-Wide).

New perf-events introduced
==========================

* kvm-hv/host_heap/		: The currently used bytes in the
				  Hypervisor's Guest Management Space
				  associated with the Host Partition.
* kvm-hv/host_heap_max/		: The maximum bytes available in the
				  Hypervisor's Guest Management Space
				  associated with the Host Partition.
* kvm-hv/host_pagetable/	: The currently used bytes in the
				  Hypervisor's Guest Page Table Management
				  Space associated with the Host Partition.
* kvm-hv/host_pagetable_max/	: The maximum bytes available in the
				  Hypervisor's Guest Page Table Management
				  Space associated with the Host Partition.
* kvm-hv/host_pagetable_reclaim/: The amount of space in bytes that has
				  been reclaimed due to overcommit in the
				  Hypervisor's Guest Page Table Management
				  Space associated with the Host Partition.

Structure of this patch series
==============================
Start with documenting and updating the KVM nested-APIv2 hcall
specifications for H_GUEST_GET_STATE hcall and Hostwide guest-state-buffer
elements.

Subsequent patches add support for adding and parsing Hostwide
guest-state-buffer elements in existing kvm-hv apiv2 infrastructure. Also
add a kunit test case to verify correctness of the changes introduced.

Next set of patches in the patch-set introduces a new PMU (kvm-hv) and
kernel module (kvm-hv-pmu), implements plumbing in the kvm-hv-pmu module to
create populate and parse a guest-state-buffer holding the Hostwide
counters returned from L0-PowerVM.

The final patch in the series creates the five new perf-events which then
leverage the kernel's perf-event infrastructure to report the Hostwide
counters returned from L0-PowerVM to perf tool.

Output
======
Once the patch-set is integrated, perf-stat should report the Hostwide
counters for a kvm-enabled pseries lpar with kvm-hv-pmu module loaded as
below:

$ sudo perf stat -e 'kvm-hv/host_heap/'  -e 'kvm-hv/host_heap_max/' \
  -e 'kvm-hv/host_pagetable/' -e 'kvm-hv/host_pagetable_max/' \
  -e 'kvm-hv/host_pagetable_reclaim/' -- sleep 0

Performance counter stats for 'system wide':

                 0      kvm-hv/host_heap/
    10,995,367,936      kvm-hv/host_heap_max/
         2,178,304      kvm-hv/host_pagetable/
     2,147,483,648      kvm-hv/host_pagetable_max/
                 0      kvm-hv/host_pagetable_reclaim/

The patch can be tested with Qemu-TCG emulation support for Book3s-HV APIv2
proposed at [3]. Currently with Qemu-TCG the values for all the Hostwide
counters is reported as '0'.

References
==========
[1] - commit 19d31c5f1157 ("KVM: PPC: Add support for nestedv2 guests")
[2] - "KVM in a PowerVM LPAR: A Power user guide Part II"
      https://ibm.biz/BdGHeY
[3] - https://lore.kernel.org/all/20250221155449.530645-1-vaibhav@linux.ibm.com

Vaibhav Jain (6):
  powerpc: Document APIv2 KVM hcall spec for Hostwide counters
  kvm powerpc/book3s-apiv2: Add support for Hostwide GSB elements
  kvm powerpc/book3s-apiv2: Add kunit tests for Hostwide GSB elements
  kvm powerpc/book3s-apiv2: Introduce kvm-hv specific PMU
  powerpc/kvm-hv-pmu: Implement GSB message-ops for hostwide counters
  powerpc/kvm-hv-pmu: Add perf-events for Hostwide counters

 Documentation/arch/powerpc/kvm-nested.rst     |  40 +-
 arch/powerpc/include/asm/guest-state-buffer.h |  35 +-
 arch/powerpc/include/asm/hvcall.h             |  13 +-
 arch/powerpc/kvm/Kconfig                      |  13 +
 arch/powerpc/kvm/book3s_hv_nestedv2.c         |   6 +
 arch/powerpc/kvm/guest-state-buffer.c         |  39 ++
 arch/powerpc/kvm/test-guest-state-buffer.c    | 214 +++++++++
 arch/powerpc/perf/Makefile                    |   2 +
 arch/powerpc/perf/kvm-hv-pmu.c                | 435 ++++++++++++++++++
 9 files changed, 775 insertions(+), 22 deletions(-)
 create mode 100644 arch/powerpc/perf/kvm-hv-pmu.c

-- 
2.49.0


