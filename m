Return-Path: <kvm+bounces-49345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 77240AD7FD5
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 196981897C8A
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05A0E1C9DC6;
	Fri, 13 Jun 2025 00:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Afzob0Rs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423851B424D;
	Fri, 13 Jun 2025 00:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749776126; cv=fail; b=Wro/Ly5UGNMwzjJFMU6OHDUp0zsJkyh8xqmeWcYK+MNggS1UioyWVH2Izm7NXgrEURTb/0weGcZ9TRS63c3WNicgm7NpvBfKzOKqojxBvN9Q2Zgy9TkZZN48T2Gq5hBl3uX6iOBka31ndfcdc5GHJMwDIrU0fJzuPEvifpA5Ff0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749776126; c=relaxed/simple;
	bh=Dhc6leFOx+V8/DmVR4k4rtQoNJWktddGScGD4q57cMI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qvWP9Jk9TI2WesgkOm/tTcfAuQSPaE6DRsKkcGe8SkMs4cEchUdPUbFOrG7d5apjDtoRhStEhb7rm9SEuUWrGgoNbR9c2e4D+t7RXzS4wbUSCwV94BNbkoATTXvZuDlKOaMnP/64L8tPeBYQYM+7dqfzCMRQpAHx2yz2kqBa078=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Afzob0Rs; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qhr/o7g7jg9uN2CKXnkfGZxdSfzSUO8Z8bcJZnSbcvdfUOC2Ywe9LwE4Z3xZ3Vv1RW4TMHZKij6JHbpYUdve24N7XiCQlOYMQQ5cpz3nw9RUJzk9LH4q9c6th52vkeTZTIMxfwWGrOYrZLscaVMXVUOmzg+8E5FlZXDeDitxR1gY2tytU1BqRHZ7r3t8RL0jeS+FpnFCoNZ885afoG3Gc+aMTFqVPuTxvoiiV+Y1kmfKGwy5CqUyl80EDljg846lXmyfKpjSNGWhLCshisHXRCJ1qOccgvIyZRHT0oavdIzgwu+MoEtIzF/4OdlNx0n4h3l9b2LcLps/b3Ieau+83w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvaRSMlwChmVkgzGHg8G55TnbIQLzhBu2Cpy4o162FU=;
 b=kNX2P3Gcj5TJEAt1B4asZqQG67fL/J3umwe/OAZdEFK/BwwUesfZ5IQjB6nknFN2jpZm3WSnyn8kt01MugyydiQO2vIC4jcvJrZ+Zrc/w5XlqfS5kpG4xB/zk0JiQVNULZy2NRvo9JsSDVySbvOl6SKSOT6fQeq64QoGZSbHQSELmYTXpuaLULM2mPs7OUAeKgqBEVlGxbC2goJNmmAiyrrXxdssBmyrBdCzd2fszWSDwDMubae7gzu8nFu01gmLb6pb+IGa5O4qQ9zfpyt+OlaIv4itq40jRXXAe1e2ssgc+Mbr7X4LVAKJhTw2//MTsEpJmKvglLttgDANrnU1AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvaRSMlwChmVkgzGHg8G55TnbIQLzhBu2Cpy4o162FU=;
 b=Afzob0RsIab4eA71tdTBc1CUFIhQnXlkUFGLanE048hH0YKXF+k3RT5h55GAGQH6ylxHNgkFm3aqNpM2Myev8RfBnc9YqwNMa6Q417UwNbvoxzzsHpXpbUCfXKIDgdfBXtPWoYFpDDp/quGDoTnSPy0dNgLMggeXwUI37CxdN4U=
Received: from SJ0PR05CA0104.namprd05.prod.outlook.com (2603:10b6:a03:334::19)
 by IA0PR12MB8748.namprd12.prod.outlook.com (2603:10b6:208:482::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 00:55:20 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:a03:334:cafe::35) by SJ0PR05CA0104.outlook.office365.com
 (2603:10b6:a03:334::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Fri,
 13 Jun 2025 00:55:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Fri, 13 Jun 2025 00:55:19 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Jun
 2025 19:55:19 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <david@redhat.com>, <tabba@google.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <ira.weiny@intel.com>,
	<thomas.lendacky@amd.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vbabka@suse.cz>, <joro@8bytes.org>, <pratikrajesh.sampat@amd.com>,
	<liam.merwick@oracle.com>, <yan.y.zhao@intel.com>, <aik@amd.com>
Subject: [PATCH RFC v1 0/5] KVM: guest_memfd: Support in-place conversion for CoCo VMs
Date: Thu, 12 Jun 2025 19:53:55 -0500
Message-ID: <20250613005400.3694904-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|IA0PR12MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: 74323c7d-0db0-464d-d804-08ddaa14f855
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P8uOmPCUGOAw7wIEAR6DsVTh9Vtoqb6lX8/emyUko815flm6DuGI3meCerxw?=
 =?us-ascii?Q?BopoduuU2BTfte2CX0kM6dhBPt8srupDhyE+pZzlCPRgjrdnpEZizCCzpCTX?=
 =?us-ascii?Q?9jicCaA9ahASbWwuIZlPQAVijLZ7zL3mxz/OXuejAdHc0zfAN9xYxObKeMok?=
 =?us-ascii?Q?FVjjX3rHidP+7cPq6HyjorGXXgfh+QHsKGbWeFVXdPLzkVwdMKZs1lkvtlIJ?=
 =?us-ascii?Q?emPSgKaP7TufakWkdOD9FJFufB9aq4e7e6bu7VaiP4Wx5duWGMjW7V5TPIJL?=
 =?us-ascii?Q?aynCXTV43nvUD36wVmw6zEgcn7Pu9x5AOz6TMD2VZaSH6huFW+dUOsXPYjeQ?=
 =?us-ascii?Q?gefsxcHG01mcdf1jy5JZeiG7lnkTtDF3fFjjKuEJQjzX0m6bkhBO9OfOc4yt?=
 =?us-ascii?Q?7KJLykkSX5XHeXIChoLwKZ0TIRVCDSej1P3pReFgJibp/BCj64HAEoRUnW9F?=
 =?us-ascii?Q?k03MRrnAps2UUFhvfhrPC0GkB2nAxDO90Zwwcfsr800y5I8LTgek07EgtGDE?=
 =?us-ascii?Q?xINbLBnt5EOGliqi4eHCUv2mWpKnzZPxBx1OceQDkIRJKjg3NhdgSNOs4cXV?=
 =?us-ascii?Q?MQ1HKrJStmb9V25+U9nrnWpiY8Fl8yaFXBlu+hSoDPK2gX4NdSTx6NZrlMLE?=
 =?us-ascii?Q?M3f4zlRTEbSxPrTOD94n1IVqVapKfhhQHzImoY4nGAwXbTiYv/CLYkHZ3o9O?=
 =?us-ascii?Q?R3Dgl3w/iMyc4HXev1oLXMuIDW830hlBtLTyFrXRW0Zzz+zsLjxEV9Zg3Tx+?=
 =?us-ascii?Q?Sy1lhPjWPPVxcn1P1LkMbdVGo5k1JsDj5wkxLUSdC6TEG6J1TRbux2Gs4ZBb?=
 =?us-ascii?Q?iyf+iEMk8G3KsFKGFRdsTVgorvSyCMS83ipdpMiBtRcudC4NkUsKb0zzXJTI?=
 =?us-ascii?Q?lruzC4iEyEvhjPabXRzkAHsyGVf1PA5ZaQhSxUgu+36ccScvvZ8LTmo2mGNY?=
 =?us-ascii?Q?kfOmLWQCUTlEhpQBfQidLqoTyUNHZDFmM2FpEK073aIYnu5jo4iBbPBN4TwS?=
 =?us-ascii?Q?BV90yPiwIAVKUkS0xZDDuD6ru9Zcl8/IA9lYwC0s6XyN6CVSEr6OuR7q68Rj?=
 =?us-ascii?Q?LK1A7Z3KCj8gGuuN/iihrdZ2gcs/W4cTtioVVbUO8jT3ajvOXdUej+LCsLEx?=
 =?us-ascii?Q?LrU42D87Zqb/Ek/804lcco41xSInpoIl9E81dtQ0ZopWIbqGIOFVGrcmdIZs?=
 =?us-ascii?Q?wyLe5FO4n837Sh0k9OI0YHLFhe5D5Me9U4JvYAjpNT7uuAzLESZnsD1zKmZk?=
 =?us-ascii?Q?8jR0L3Wmo2D/hLCnVykKkSd1wA7pBsT5QoRS+YBhkh4A2zmSfktNc3JlLApp?=
 =?us-ascii?Q?hOD90f5oXuXWYzpX1CEvdrM4sw23+TwUANIS5cnbY0RifNXcgj+tI+nXbTxM?=
 =?us-ascii?Q?KpYoP+9dy+69ZiaPOljt/hNXoHDggcLMxOsOF6WkYEZEFlWxUNwBhGq5HIFM?=
 =?us-ascii?Q?An4mtR+3TOrYCsCODL319rZj8kNRBfSsbyymkcDFcrbk9CcqINHaKuoLkykw?=
 =?us-ascii?Q?yizg62H4jc7dUhE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 00:55:19.7643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74323c7d-0db0-464d-d804-08ddaa14f855
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8748

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1

and is based on top of the following patches plucked from Ackerley's
HugeTLBFS series[1], which add support for tracking/converting guest_memfd
pages between private/shared states so the same physical pages can be used
to handle both private/shared accesses by the guest or by userspace:

  KVM: selftests: Update script to map shared memory from guest_memfd
  KVM: selftests: Update private_mem_conversions_test to mmap guest_memfd
  KVM: selftests: Add script to exercise private_mem_conversions_test
  KVM: selftests: Test conversion flows for guest_memfd
  KVM: selftests: Allow cleanup of ucall_pool from host
  KVM: selftests: Refactor vm_mem_add to be more flexible
  KVM: selftests: Test faulting with respect to GUEST_MEMFD_FLAG_INIT_PRIVATE
  KVM: selftests: Test flag validity after guest_memfd supports conversions
  KVM: guest_memfd: Add CAP KVM_CAP_GMEM_CONVERSION
  KVM: Query guest_memfd for private/shared status
  KVM: guest_memfd: Skip LRU for guest_memfd folios
  KVM: guest_memfd: Introduce KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
  KVM: selftests: Update guest_memfd_test for INIT_PRIVATE flag
  KVM: guest_memfd: Introduce and use shareability to guard faulting
  KVM: guest_memfd: Make guest mem use guest mem inodes instead of anonymous inodes
  fs: Refactor to provide function that allocates a secure anonymous inode

  "[RFC PATCH v2 00/51] 1G page support for guest_memfd"
  https://lore.kernel.org/lkml/cover.1747264138.git.ackerleytng@google.com/

which is in turn based on the following series[2] from Fuad which implements
the initial support for guest_memfd to manage shared memory and allow it to
be mmap()'d into userspace:

  "[PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the host for software protected VMs"
  https://lore.kernel.org/kvm/20250611133330.1514028-1-tabba@google.com/

(One of the main goals of posting this series in it's current form is to
identify the common set of dependencies to enable in-place conversion
support for SEV-SNP, TDX, and pKVM, which have been coined "stage 2"
according to upstreaming plans discussed during guest_memfd bi-weekly calls
and summarized by David here[3] (Fuad's series[2] being "stage 1"),
so please feel free to chime in here if there's any feedback on whether
something like the above set of dependencies is a reasonable starting point
for "stage 2" and how best to handle setting up a common tree to track this
dependency.)


Overview
--------

Currently guest_memfd is only used by CoCo VMs to handle private memory, and
relies on hole-punching to free memory from guest_memfd when it is converted
to shared and re-allocated from normal/non-gmem memory that's been associated
with the memslot. This has some major downsides:

  1) for future use-cases like 1GB HugeTLB support in gmem, the ability to
     hole-punch pages after conversion is almost completely lost since
     truncation at sub-1GB granularities won't free the page, and truncation
     at 1GB or greater granularity will likely userspace to track free ranges
     and defer truncation until the entire range has been converted, which
     will often never happen for a particular 1GB range.

  2) for things like PCI passthrough, where normal/non-gmem memory is
     pinned, this quickly leads to doubled guest memory usage once the guest
     has converted most of its pages to private, but the previous allocated
     pages can't be hole-punched until being unmapped from IOMMU. While there
     are reasonable solutions for this like the RamDiscardManager proposed[4]
     for QEMU, in-place conversion handles this memory doubling problem
     essentially for free, and makes it easier to mix PCI passthrough of
     normal devices together with PCI passthrough of trusted devices (e.g.
     for SEV-TIO) where it's actually *private* memory that needs to be
     mapped into the IOMMU, and thus there's less clarity about what pages
     can/can't be freed/unmapped from IOMMU when pages are converted between
     shared/private.

  3) interfaces like mbind() which rely on virtual addresses to set NUMA
     affinities are not available for unmappable guest_memfd pages, requiring
     additional management interfaces to handle guest_memfd separately from
     normal memory.

  4) not being able to populate pages directly from userspace due to
     guest_memfd being unmappable, requiring the user of intermediate buffers
     which the kernel then copies into corresponding guest_memfd page.

Supporting in-place conversion, and allowing shared pages to be mmap() and
accessed by userspace similarly to normal/non-CoCo guests, addresses most of
these issues fairly naturally.

With the above-mentioned dependencies in place, only a fairly small set of
additional changes are needed to allow SEV-SNP and (hopefully) other CoCo
platforms to use guest_memfd in this manner, and that "small set" of
additional changes is what this series is meant to call out to consider for
potential inclusion into the common "stage 2" tree so that pKVM/TDX in-place
conversion can be similarly enabled with minimal additional changes needed
on top and so we can start looking at getting the related userspace APIs
finalized.


Some topics for discussion
--------------------------

1) Removal of preparation tracking from guest_memfd
   
   This is the most significant change in this series, since I know in
   the past there was a strong desire to have guest_memfd be aware of
   what has/hasn't been prepared rather than off-loading the knowledge
   to platform-specific code. While it was initially planned to maintain
   this preparedness-tracking in guest_memfd, there are some complexities
   it brings along in the context of in-place conversion and hugetlb
   enablement that I think make it worthwhile to revisit.
   
   A) it has unique locking requirements[5], since "preparation" needs to
      happen lazily to gain any benefit from lazy-acceptance/lazy-faulting
      of guest memory, and that generally ends up being at fault-time, but
      data structures to track "preparation" require locks to update the
      state, and reduce guest_memfd ability to handle concurrent faults
      from multiple vCPUs efficiently. While there are proposed locking
      schemes that could potentially handle this reasonably[5], getting rid
      of this tracking in guest_memfd allows for things like shared/private
      state to be tracked via much simpler schemes like rw_semaphores (or
      just re-using the filemap invalidate lock as is done here).

   B) only SEV-SNP is actually making any meaningful use of it. Platforms
      like TDX handle preparation and preparation-tracking outside of
      guest_memfd, so operating under the general assumption that guest_memfd
      has a clear notion of what is/isn't prepared could bite us in some
      cases versus just punting to platform-specific tracking.


2) Proper point to begin generally advertising KVM_CAP_GMEM_CONVERSION?

   Currently the various dependencies these patches are based on top of
   advertise support for converting guest_memfd pages between shared/private
   via KVM_CAP_GMEM_CONVERSION. However, for SEV-SNP at least, these
   additional pages are needed. So perhaps the initial enablement for
   KVM_CAP_GMEM_CONVERSION should only be done for non-CoCo VMs to enable
   the self-tests so that userspace can reliably probe for support for a
   specific VM type?


Testing
-------

This series has only been tested with SEV-SNP guests using the following
modified QEMU branch:

  https://github.com/amdese/qemu/commits/snp-mmap-gmem0-wip4

and beyond that only via the kselftests added by Ackerley that exercise the
gmem conversion support/ioctls this series is based on.


TODO
----

 - Rebase on (or merge into?) proper "stage 2" once we work out what that is.
 - Confirm no breakages to Fuad's "stage 1" kselftests 
 - Add kselftest coverage for SNP guests using shareable gmem.


References
----------

[1] "[RFC PATCH v2 00/51] 1G page support for guest_memfd",
    https://lore.kernel.org/lkml/cover.1747264138.git.ackerleytng@google.com/
[2] "[PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the host for software protected VMs",
    https://lore.kernel.org/kvm/20250611133330.1514028-1-tabba@google.com/
[3] "[Overview] guest_memfd extensions and dependencies 2025-05-15",
    https://lore.kernel.org/kvm/c1c9591d-218a-495c-957b-ba356c8f8e09@redhat.com/
[4] "[PATCH v7 0/5] Enable shared device assignment"
    https://lore.kernel.org/kvm/20250612082747.51539-1-chenyi.qiang@intel.com/
[5] https://lore.kernel.org/kvm/20250529054227.hh2f4jmyqf6igd3i@amd.com/


Thanks!

-Mike


----------------------------------------------------------------
Michael Roth (5):
      KVM: guest_memfd: Remove preparation tracking
      KVM: guest_memfd: Only access KVM memory attributes when appropriate
      KVM: guest_memfd: Call arch invalidation hooks when converting to shared
      KVM: guest_memfd: Don't prepare shared folios
      KVM: SEV: Make SNP_LAUNCH_UPDATE ignore 'uaddr' if guest_memfd is shareable

 .../virt/kvm/x86/amd-memory-encryption.rst         |  4 +-
 arch/x86/kvm/svm/sev.c                             | 14 +++-
 virt/kvm/guest_memfd.c                             | 92 +++++++++++++---------
 3 files changed, 68 insertions(+), 42 deletions(-)



