Return-Path: <kvm+bounces-34291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 015089FA5E5
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 15:03:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A599161A0B
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 14:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0876A18E368;
	Sun, 22 Dec 2024 14:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kORLfiib"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6940480B;
	Sun, 22 Dec 2024 14:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734876201; cv=none; b=E2dffLeVYb5/ALnzrEzCdqx2cSCyxNJM4bdMz/Jifw+Q0E3ojMA88FQDjQBht1fs16MXgENrYTg3VU5s3k+v//8T9kc7HI3E03dB5uuvlRD+eCADETFnEwlCr2Vo45DaQueBG3JkqdHquBwqAnWcaYnMRVzLzMSXVwSw8lmCIzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734876201; c=relaxed/simple;
	bh=UjvditI5UDcF7QXw4+0Zf02smqbcxnAGWl3PBT2v0iI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jVYVbuYJNKG4VyV86+j8BwVW9yUfUkCm5NT/UlfDSSz7tEXlqDrtr9bBgn4ACqPVlm7r7ubGfm8qBnAzopbMmF0V5HsTx2B098sw0UMNimS8tsvUdOv0j603FRjPw3651JwXdaKPr5fm1NCXhFB6U4+OrLb0/d1rDo8ltnQz3Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kORLfiib; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BMAFlju022445;
	Sun, 22 Dec 2024 14:03:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=N6jKah2bMyS0IeF2KBlc1G63S0n1HhCXXQgnejpIZ
	CA=; b=kORLfiibZzJL2sIvwSh2cUE/BFcEEmxDvrplon9qoZfZeU1K9IzlEhUz0
	1FBpw/rbaLqxVWp2299WNOD6JDU4ttZfCq/NkqL/02uPZUcajRLsSWAyUWQ4DagM
	HiFZRZZDOHgmvdQspAZ1K+MhEij7UYdm+JOzzN8P0osbS54MbBm3PvxhiCczzUXg
	oOCDJSozAH5nV9wlS/Fbwb3Cqa4C0vbQGVok1BXMSIeHdxN6O4iJ5JDKT5kNseWG
	TC3XvyR87mlc3BvTbWrZi10mJnKXIjY7VJLsMiHiY1qNLy+9yAPBGYVcyeN/9Cpb
	BvU1b/NKx8MFpeaj+o2MMLrM0HNlg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ny54axa0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:04 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BME33Cg019642;
	Sun, 22 Dec 2024 14:03:03 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ny54ax9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:03 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BMC0hiW020602;
	Sun, 22 Dec 2024 14:03:03 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43p8cy229m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:02 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BME2xYo56623610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Dec 2024 14:02:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F2B820043;
	Sun, 22 Dec 2024 14:02:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 986DD20040;
	Sun, 22 Dec 2024 14:02:55 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.24.11])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Sun, 22 Dec 2024 14:02:55 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Sun, 22 Dec 2024 19:32:54 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com
Subject: [PATCH 0/6] kvm powerpc/book3s-hv: Expose Hostwide counters as perf-events
Date: Sun, 22 Dec 2024 19:32:28 +0530
Message-ID: <20241222140247.174998-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dmxOignJwv3CIoEU3ofx6XrcWyWqJ8Yv
X-Proofpoint-GUID: sPO8ItLRpLYYPaJxAV6oB8pyPNThhlId
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0 clxscore=1011
 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412220124

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

References
==========
[1] - commit 19d31c5f1157 ("KVM: PPC: Add support for nestedv2 guests")
[2] - "KVM in a PowerVM LPAR: A Power user guide Part II"
      https://ibm.biz/BdGHeY

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
 arch/powerpc/include/asm/kvm_book3s.h         |  12 +
 arch/powerpc/kvm/Makefile                     |   6 +
 arch/powerpc/kvm/book3s_hv.c                  |   7 +
 arch/powerpc/kvm/book3s_hv_nestedv2.c         |   6 +
 arch/powerpc/kvm/book3s_hv_pmu.c              | 412 ++++++++++++++++++
 arch/powerpc/kvm/guest-state-buffer.c         |  39 ++
 arch/powerpc/kvm/test-guest-state-buffer.c    | 210 +++++++++
 10 files changed, 757 insertions(+), 23 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_hv_pmu.c

-- 
2.47.1


