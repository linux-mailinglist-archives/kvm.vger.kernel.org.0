Return-Path: <kvm+bounces-65973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E2ACBEB3E
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 16:40:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4CA283056786
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B2563370E5;
	Mon, 15 Dec 2025 15:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PCP1mbQf"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013012.outbound.protection.outlook.com [40.93.201.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2D5331A59;
	Mon, 15 Dec 2025 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765812893; cv=fail; b=ATvWOrbQAxn/7DCk4BkWgPcTuIlA2LUkql0W48c0bvB9A8XyL/S9CySEdTxoPYeRIMuaPrFz6u1JeGhr6k+945GudcqYiqv/sVbyP87sA5sjzq7i0qZ2ca/7/iI+dl0zhAesXrvb2zMGRVtxPIN4EJMIbUCbfzV4qB7ybB3yo5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765812893; c=relaxed/simple;
	bh=xwLBGh/w8bePRUOHrYD3hB43hP85D8rU1Md/lhCOJLc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ptU/I07u3m/v3pQXbT91HGca4jxI6Q16NnOziv4B9/dcliw2C0MlUaCI35XooRCVuPNari9qqK6g8yWgPtpmFpMGEqurbdZoYu3PSjk6SS7dMnsexHkqQO0o13xPS60f/rqH6jodPBc8/HlW0YcHOHPi+XOSJIJjMzaOQUsilI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PCP1mbQf; arc=fail smtp.client-ip=40.93.201.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SyecjlYE9Rvct9b+3bIEhg5GHGQ+/06+rsuZvWakhpRPWYcnK+fFcxhqyEXQX7e/TQ3ENj8AP3RiDkB5fkI6LtK+TQn3ethbR5tzy1cR1s7HVY4A+O2AUHB8XclIK6mDzF6Ii18KcyOTUbH6K/1VtCqi7WLEJ+f4J05L++fzRd85m1OfqmUuohNcOieoy0Q5/TszN0xaW1vAoJRQUCTMT8o6eSiyVIDvWPxW7dR4UEn8odRhvjsp8sFzTUIX1mstLWFmbDu9EMrowdt6O+uJ0y3uM/AgylHlhOjIELotkKdwEBvzu40GrmCCTiPP1WueQdl4fR2PXdUZQya5zOSefw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9eDew4lppE44U06LqUF8BvucWFWI4BiiRST6yDcKqzQ=;
 b=ltuXJTzQ3htIzrrLorlPk6RQcNQW1kbbCuYbYplr85bxA82xTD0FLob2CQWEsbSVqUsPff0rMbwXdLekClc59ZmhEnstwXMn98m8pHCNaoKnCIZQjvHeQyLrcyLRqOtZVeJc5+X79OLjEHguAYMiwz0mcYjKuxgf9NBnOcD7ygCO3zrbFIcVzsjGr+nZ1yYYV9ukgfTEY/2BpmKg/zaitAo0gi6TwkWJlRPPM9KRIw4nomsIUA9k4Nc/dGcdMvM6yHhX8gZu+lK7YEd1BjOm4nzuIL9cM69YPc8Xs5n1KDnBHVfuWLd0Bb9YoVjIh37fFxK9xC+mP35Ac7iAWEC/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eDew4lppE44U06LqUF8BvucWFWI4BiiRST6yDcKqzQ=;
 b=PCP1mbQfHXfdcnsyAx5SPtlSxdXCo2AHbnP5V1Q4AWQYk4CnQ4GaLr6K+qkjIiZK5+YUP9C++Tj3hZ72cYiWWwAslUIxS0DoBc7FnVwqAeA1f1n5qpgTPNm5GMwrujEgEFmgw+8q9rFS70gNYS08LuEyfkQLy3asTJnu9FAhLuc=
Received: from PH8P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:345::13)
 by DS7PR12MB8274.namprd12.prod.outlook.com (2603:10b6:8:da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 15:34:40 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com
 (2603:10b6:510:345:cafe::63) by PH8P220CA0021.outlook.office365.com
 (2603:10b6:510:345::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 15:34:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 15:34:38 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 09:34:38 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH v2 0/5] KVM: guest_memfd: Rework preparation/population flows in prep for in-place conversion
Date: Mon, 15 Dec 2025 09:34:06 -0600
Message-ID: <20251215153411.3613928-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|DS7PR12MB8274:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f020ba1-0f38-4ca9-8c18-08de3bef75a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VeVxmTTrWueZ4Q7FAWWFdw/gYLkuH4NVIOCPfyhwsqlW4pysCwt1yuTBXLXA?=
 =?us-ascii?Q?WNmqWO/46TyK77ABT4DM5aIzifSmVz2XWphnGR2iVF2x34T5h9pwULV8Y9+k?=
 =?us-ascii?Q?rQDofNXWXh/lle88+gM+CpCGXGPjZXKCQE/NkRIMxCwIuQJG0PGH0ImBmPVh?=
 =?us-ascii?Q?iV3Pb9Doeies+q1E/zzbJ5Za1UtApSiyD1Ia7h9b4LuFMqFEmUFQRxnfNKdO?=
 =?us-ascii?Q?WFEKreuTMDM16Y1RH1IqmwWzRyKm3oj2EtWLhZ0tpEZuQ1rAgQggc7spn4WJ?=
 =?us-ascii?Q?P/EljAtEwSCfhzJNnnXimxbYbn5MM42coV8SbBAToJ3SOhhThfMPxFU3SSDN?=
 =?us-ascii?Q?o5oYdG3018b3anFK1FWGdijySQ4V8+xhT+MtypRSda/4r5iKVWpijhsMlhT0?=
 =?us-ascii?Q?VnCtZVMMKMHvUPk2l6LaeVgfzb6QXywOr850U+UMuw7ARxCt7Q9/EbBNV1cN?=
 =?us-ascii?Q?bvgtmNALVykzrFJDpv4QE2cRft7kaLht5VwO7HDFAnM9cWrPKASAe22hiZ6E?=
 =?us-ascii?Q?ha7leGnJ8ks7OiwJkzlxNiR1gfY0jxCiVLU7R7y6P7iM6oOQHcJvbtRduEUq?=
 =?us-ascii?Q?GoWUWSl0/DUUjplt3ItPz4LHJyPznMvILRvScpOV7+Ld/Z1svsm0BTO2dXLt?=
 =?us-ascii?Q?gK975pDaBQyDPQt5CknSSzac4web1KR4RV4I4p3iFOArYtuVIjRyPYjB0r78?=
 =?us-ascii?Q?ufBcGDumjRfGWljMUlR6EIUvljUqAy0LO2dXoDTrvDXrU0MMb7vpNv0wYC+G?=
 =?us-ascii?Q?gJKDmKKO6o1JmRVReqr7xELSqpAMxxqZp5MG8ziFCtNvdFAmS3ioxfnBovCO?=
 =?us-ascii?Q?IQwhmvi7W8yW7wC2X0sGVy9zERPKhU4EHbQb5rX6hen5vSWfsklynqPpAxNW?=
 =?us-ascii?Q?d9RaCKXA3PnY28Babwlqm7tEtsXxt4aDOIsmMgIdEgaCkmc7bHQIo6MQUy2c?=
 =?us-ascii?Q?1pYXyLnzdIhLg5fSAqx6FbxWLuiyOgq4ADF26ft0PKnUyetP9bAT53NrMu92?=
 =?us-ascii?Q?tcsNR6QpBaQvHlxVCXjGhf/W0JKRj1XVieIwQHcKDSAZD21mBFGheOqLYUQU?=
 =?us-ascii?Q?kYiMXzwGvrNfcpsekLJeTTODjdMEPP9IUR8NPEB9EjBszG2CLbMDLKHvuBcI?=
 =?us-ascii?Q?a+kYR6G1ssVWjla3yNd1BEe+Qdhvk6a9XHCPQdz/dNZPWxQwuI2VwFXJxKAo?=
 =?us-ascii?Q?GuvPW/fkwxcOZM+000syuJiRc8rCtUduHRDh5/30KtZz3TIEh1IymCYIkpmv?=
 =?us-ascii?Q?wTNgP9Ah8xTOy1pQj5r8ROcGQM45zXPK7MUsScNyyuYomKTiLDHjsA6tmFlX?=
 =?us-ascii?Q?lsZMAgKVGqEOqh2aLSgy/YfVVvKyYd3tLt0p3Mn3YeJu4+RHnSUKzXNvQEF6?=
 =?us-ascii?Q?3gBGrcYPkxwPOeHI4RtK9DunYia/4y8QRFPWfKdvwzF6Xzaslj3GCdhWH80F?=
 =?us-ascii?Q?d2vXqakx4fQpdo3zBX5t6YhQ1kb8Bqom+Ay276O/ACpdUJfJK/jgiNXjfKe9?=
 =?us-ascii?Q?8yQwlFoNG9u53cxzeYhKUjqGkq/h4BALWV+VqH3WNkdwT95dGZiEDcUgIyfR?=
 =?us-ascii?Q?foyjK7Ev+brlXpOJoxtajyHi+B2FinT3gOuLoUSE?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 15:34:38.9540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f020ba1-0f38-4ca9-8c18-08de3bef75a5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8274

This patchset is also available at:

  https://github.com/AMDESE/linux/tree/gmem-populate-rework-v2

and is based on top of kvm/next (e0c26d47def7)


Overview
--------

Yan previously posted a series[1] that reworked kvm_gmem_populate() to deal
with potential locking issues that might arise once in-place conversion
support[2] is added for guest_memfd. To quote Yan's original summary of the
issues:

  (1)
  In Michael's series "KVM: gmem: 2MB THP support and preparedness tracking
  changes" [4], kvm_gmem_get_pfn() was modified to rely on the filemap
  invalidation lock for protecting its preparedness tracking. Similarly, the
  in-place conversion version of guest_memfd series by Ackerly also requires
  kvm_gmem_get_pfn() to acquire filemap invalidation lock [5].
  
  kvm_gmem_get_pfn
      filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
  
  However, since kvm_gmem_get_pfn() is called by kvm_tdp_map_page(), which is
  in turn invoked within kvm_gmem_populate() in TDX, a deadlock occurs on the
  filemap invalidation lock.
  
  (2)
  Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
  resulting in the following lock sequence in tdx_vcpu_init_mem_region():
  - filemap invalidation lock --> mm->mmap_lock
  
  However, in future code, the shared filemap invalidation lock will be held
  in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
  - mm->mmap_lock --> filemap invalidation lock
  
  This creates an AB-BA deadlock issue.

Sean has since then addressed (1) with his series[3] that avoids relying on
calling kvm_gmem_get_pfn() within the TDX post-populate callback to re-fetch
the PFN that was passed to it.

This series aims to address (2), which is still outstanding, and does so based
heavily on Sean's suggested approach[4] of hoisting the get_user_pages_fast()
out of the TDX post-populate callback so that it can be called prior to taking
the filemap invalidate lock so that the ABBA deadlock is no longer possible.
As preperation for this change, all the partial enablement for hugepages in
the kvm_gmem_populate() path is stripped out so that it can be better
considered once hugepage support is actually in place and code/design can be
kept simpler in the meantime.

It additionally removes 'preparation' tracking from guest_memfd, which would
similarly complicate locking considerations in the context of in-place
conversion (and even moreso in the context of hugepage support). This has
been discussed during both the guest_memfd calls and PUCK calls, and so far
no strong objections have been given, so hopefully that particular change
isn't too controversial.


Some items worth noting/discussing
----------------------------------

(A) While one of the aims of this rework is to implement things such that
    a separate source address can still be passed to kvm_gmem_populate()
    even though the gmem pages can be populated in-place from userspace
    beforehand, issues still arise if the source address itself has the
    KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set, e.g. if source/target
    addresses are the same page. One line of reasoning would be to
    conclude that KVM_MEMORY_ATTRIBUTE_PRIVATE implies that it cannot
    be used as the source of a GUP/copy_from_user(), and thus cases like
    source==target are naturally disallowed. Thus userspace has no choice
    but to populate pages in-place *prior* to setting the
    KVM_MEMORY_ATTRIBUTE_PRIVATE attribute (as kvm_gmem_populate()
    requires), and passing in NULL for the source such that the GUP can
    be skipped (otherwise, it will trigger the shared memory fault path,
    which will then SIGBUS because it will see that it is faulting in
    pages for which KVM_MEMORY_ATTRIBUTE_PRIVATE is set).

    While workable, this would at the very least involve documentation
    updates to KVM_TDX_INIT_MEM_REGION/KVM_SEV_SNP_LAUNCH_UPDATE to cover
    these soon-to-be-possible scenarios. Ira posted a patch separately
    that demonstrates how a NULL source could be safely handled within
    the TDX post-populate callback[5].

    
Known issues / TODO
-------------------

- Compile-tested only for the TDX bits (testing/feedback welcome!)


Changes since RFC v1
--------------------

- and a prep patch to remove partial hugepage enablement in
  kvm_gmem_populate() to simplify things until a hugepage implementation
  can actually make use of it (Yan, Ira, Vishal, Sean)
- begin retroactively enforcing that source pages must be page-aligned
  so that kvm_gmem_populate() callbacks can be simplified. add a patch
  to update SNP user-facing documentation to mention this.
- drop handling for GUP'ing multiple pages before issuing callbacks.
  This will only be needed for potentially for hugepages, and it must
  simpler to handle per-page in the meantime. (Yan, Vishal)
- make sure TDX actually builds (Ira, Yan)


Thanks,

Mike


[1] https://lore.kernel.org/kvm/20250703062641.3247-1-yan.y.zhao@intel.com/
[2] https://lore.kernel.org/kvm/cover.1760731772.git.ackerleytng@google.com/
[3] https://lore.kernel.org/kvm/20251030200951.3402865-1-seanjc@google.com/
[4] https://lore.kernel.org/kvm/aHEwT4X0RcfZzHlt@google.com/
[5] https://lore.kernel.org/kvm/20251105-tdx-init-in-place-v1-1-1196b67d0423@intel.com/


----------------------------------------------------------------
Michael Roth (5):
      KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
      KVM: guest_memfd: Remove preparation tracking
      KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
      KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
      KVM: guest_memfd: GUP source pages prior to populating guest memory

 .../virt/kvm/x86/amd-memory-encryption.rst         |   2 +-
 Documentation/virt/kvm/x86/intel-tdx.rst           |   2 +-
 arch/x86/kvm/svm/sev.c                             | 108 +++++++---------
 arch/x86/kvm/vmx/tdx.c                             |  15 +--
 include/linux/kvm_host.h                           |   4 +-
 virt/kvm/guest_memfd.c                             | 140 +++++++++++----------
 6 files changed, 129 insertions(+), 142 deletions(-)



