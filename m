Return-Path: <kvm+bounces-36343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E997BA1A3CE
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 13:08:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B61243A286F
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 12:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5442A20E715;
	Thu, 23 Jan 2025 12:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YvLI/Dxj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B454120E307;
	Thu, 23 Jan 2025 12:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737634093; cv=none; b=RXYlwIx/DSyKnxW/u8to4Q5ISCeF9VYcgBYv6n/LHT9ONsxkDE2xmB5le6BiuUN/Ht857gLrBPBkEIrMFHsRrXV27CA8pBQKX1pu4MNPt/wX8LlDO9B7CeAI4XL3IaAKKBFgjrCf4QGIrhEVu8aqRUq4KUk59Dhobnjo+N530yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737634093; c=relaxed/simple;
	bh=ZYZXC2MNzNzz+MQI6etCpQX9FwAr/03N4zAL+UTsX3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K0/AAOgLCKiLxanp+Qx/iczKXwEbIZsXQSsRBUuMlvJxLL8ObgjTBFhFHWdG4YzKb0Q+q7zv/hobNK5KQ0umH1GkU83bZVhx4fjpz3fcfVwJpzKT4lDkS1ivwp8xwQZoXSaPFc9zstYU9R3VzeEAHOuJCX8jJVWPr4Fx8so2Nmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YvLI/Dxj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50N20miY014245;
	Thu, 23 Jan 2025 12:07:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=k9TF4LdNoTfux9z59A4nZezKZsPHoLTSOLGWHHnHd
	18=; b=YvLI/DxjoMwyvJPtIDiCZWPmHdFAxpsjvBGHe1WSjhjUP4Yqz+zarPkxB
	MeD5UycDFk0oqYuga9hPrCJ8e1yJg7uAwWBJVOSR4x7mgwk+r+UftyKYEwKlZ65M
	Dw7F/MQTG5eok/CrZHKjarXnYFvNWWRFYY6Lao2+67dphIK2u5WtFNChB5AGhtq0
	tCTSxErB7jdvm1fA9y4YBm/SMW0eHFyS526e6HUgxwoZOBOkBd89mQ2+txWrsBbn
	t3JznydWIF+J22/cmMB0gTioHyCP1pU3T1xQvghzfrRb4urfR9qkFxfPs85Uyy4U
	ydXD9pFco0iVjOYS3Bcyns0i5Higw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bckyte8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 12:07:59 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NC029N017314;
	Thu, 23 Jan 2025 12:07:59 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bckyte8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 12:07:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NAAAuk024240;
	Thu, 23 Jan 2025 12:07:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448q0ydj6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 12:07:58 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NC7sGP33292682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 12:07:54 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7DC442004B;
	Thu, 23 Jan 2025 12:07:54 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 03C6920043;
	Thu, 23 Jan 2025 12:07:51 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.124.210.34])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 23 Jan 2025 12:07:50 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Thu, 23 Jan 2025 17:37:50 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, gautam@linux.ibm.com
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, kconsul@linux.ibm.com, amachhiw@linux.ibm.com
Subject: [PATCH v3 0/6] kvm powerpc/book3s-hv: Expose Hostwide counters as perf-events
Date: Thu, 23 Jan 2025 17:37:42 +0530
Message-ID: <20250123120749.90505-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RBV3z6SesUUJmfH8PZnqUW3wtcNFwnLK
X-Proofpoint-ORIG-GUID: G8xwnBqnBpg2Pv2xurdYZiJBs69R3zxP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_05,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230091

Changes from v2
Link: https://lore.kernel.org/all/20250115143948.369379-1-vaibhav@linux.ibm.com/
* Fixed a build warning reported by kernel test robot at [4]
* Fixed minor nit in documentation patch [Gautam]
* Fixed a redundant branch in kvmppc_init_hostwide()  [Gautam]
* Proposed v2 of Qemu-TCG emulation for Hostwide counters [3]
=======

This patch-series adds support for reporting Hostwide(L1-Lpar) counters via
perf-events. With the support for running KVM Guest in a PSeries-Lpar using
nested-APIv2 via [1], the underlying L0-PowerVM hypervisor holds some state
information pertaining to all running L2-KVM Guests in an L1-Lpar. This
state information is held in a pre-allocated memory thats owned by
L0-PowerVM and is termed as Guest-Management-Area(GMA). The GMA is
allocated per L1-LPAR and is only allocated if the lpar is KVM enabled. The
size of this area is a fixed percentage of the memory assigned to the KVM
enabled L1-lpar and is composed of two major components, Guest Management
Space(Host-Heap) and Guest Page Table Management Space(Host-Pagetable).

The Host-Heap holds the various data-structures allocated by L0-PowerVM for
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

The patch series introduces a new 'kvm-hv' PMU which exports the
perf-events mentioned below. Since perf-events exported represents the
state of the whole L1-Lpar and not that of a specific L2-KVM guest hence
the 'kvm-hv' PMU's scope is set as PERF_PMU_SCOPE_SYS_WIDE(System-Wide).

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

Next set of patches in the patch-set introduces a new PMU for kvm-hv on
pseries named as 'kvm-hv', implement plumbing between kvm-hv module and
initialization of this new PMU, necessary setup code in kvm-hv pmu to
create populate and parse a guest-state-buffer holding the Hostwide
counters returned from L0-PowerVM.

The final patch in the series creates the five new perf-events which then
leverage the kernel's perf-event infrastructure to report the Hostwide
counters returned from L0-PowerVM to perf tool.

Output
======
Once the patch-set is integrated, perf-stat should report the Hostwide
counters for a kvm-enabled pseries lpar as below:

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
[3] - https://lore.kernel.org/all/20250123115538.86821-1-vaibhav@linux.ibm.com
[4] - https://lore.kernel.org/all/202501171030.3x0gqW8G-lkp@intel.com

Vaibhav Jain (6):
  powerpc: Document APIv2 KVM hcall spec for Hostwide counters
  kvm powerpc/book3s-apiv2: Add support for Hostwide GSB elements
  kvm powerpc/book3s-apiv2: Add kunit tests for Hostwide GSB elements
  kvm powerpc/book3s-apiv2: Introduce kvm-hv specific PMU
  powerpc/book3s-hv-pmu: Implement GSB message-ops for hostwide counters
  kvm powerpc/book3s-hv-pmu: Add perf-events for Hostwide counters

 Documentation/arch/powerpc/kvm-nested.rst     |  40 +-
 arch/powerpc/include/asm/guest-state-buffer.h |  35 +-
 arch/powerpc/include/asm/hvcall.h             |  13 +-
 arch/powerpc/include/asm/kvm_book3s.h         |  20 +
 arch/powerpc/kvm/Makefile                     |   6 +
 arch/powerpc/kvm/book3s_hv.c                  |   9 +
 arch/powerpc/kvm/book3s_hv_nestedv2.c         |   6 +
 arch/powerpc/kvm/book3s_hv_pmu.c              | 421 ++++++++++++++++++
 arch/powerpc/kvm/guest-state-buffer.c         |  39 ++
 arch/powerpc/kvm/test-guest-state-buffer.c    | 210 +++++++++
 10 files changed, 777 insertions(+), 22 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_hv_pmu.c

-- 
2.48.1


