Return-Path: <kvm+bounces-33552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C12509EDF87
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 07:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9364A1679F0
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 06:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69CF9204C29;
	Thu, 12 Dec 2024 06:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jr46Ni3q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE9954723;
	Thu, 12 Dec 2024 06:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733985444; cv=fail; b=KlgwEnQUy7qgjH8axFEOZWbiUBGGI/xJe4Y9klIqYqiSLMZLxm5X5qDw8/bBnNJsv6hjLfFHpr1/rnEfq3MzI0NHCvvqYDUU/cmd4o2B0XNc8B3AzXVMFduJmU7X5yhsQ+RdpBpTj2jkysTzFEpFvWpcqxlk8uqSlZOgRlGgkMs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733985444; c=relaxed/simple;
	bh=fymQH/nn7TE9VjrRkId8QaDYe721FUROTuVGbstLQTg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rvMArGr/1aOoynU2f8E7WZCpWeSf+D9k0tL1G2V4qu9CQ7dREzF6g/TKtVTdTqYSZt9bUbJhO28kqzGoh9/Eguk7KLJfhSmpAG864d2go2QQCxCXajD1bu+rgMU7TjnEwC4F4sc0K6z6Bks6OH0Aa1qOK2Nl0rZpLNc9hY/5PKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jr46Ni3q; arc=fail smtp.client-ip=40.107.237.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t+ro+gUn87qn6XIOuBsa+q+KQ73P3biGHh65/CF0IiA8xcUN56ctIGKowqBKEBgUfu4YL5PbGducoC98rMaMToPYZZekoZ8kd3OknCFmXCvRoCZcjqdy26vKzwtar/YfgA5rMCIQogbS3Pvax9uKpL1C1pcXuTv2ZzbhhXnCywxmddFBs4tZPHQbZcgLRbM0weTiEQ5INkSg+1NAwRCTH5iG0/KsJx0C89Rhp5Fvs82vPBcB3QZMJnuLmm+EB4cD0n0QKR6X7/sXtYoDcJMu2vsT1HUtqBn8JF8CE21qqRh50rxSieRmLlyO3eXKpv6wd/HN4SockNNxXQGgG0KeQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XavV+GJTNnCd4r5clnnF87A+w66Y3anOR8aX8ksq4fk=;
 b=mm3vn+TXnsCFzWRpFUHvG7+Y9difOD7rd+UmcMYHOyfgalMq9b9dGvwds6qvNjATAA6v1sNyjneZLBNrTzNSR5gVNGls1x7o0PRDfoMUDyxaxqTESrGTxOqTa0GJmSYNk14sKF+G6HsRZS/MXklf1WzyU9TjIR73VFxF3aKCYwOo6S1gmAhwthbKIP/gUKG7C66theqVYRB+iOTuO5KL/nmEOs382BHKqMiVzmkkSWtLkls550HCaNLWw4Trt5ULiGf3jAuZSKIm16OmP4mNH1y8Lk5/R7dRP2V2RwDPscebeEkU7DL8SbX8hIPovTOjicotdguzlDZX2qOubfJxdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XavV+GJTNnCd4r5clnnF87A+w66Y3anOR8aX8ksq4fk=;
 b=jr46Ni3qqWHULxUX7z4YD58XuB2SUs3U+yJQWBJx//bmagHbCiHYusX4Id0xYu1TCB0qlUdRJL7jsvk4s4mPH7MMclyW5fpTq4KPPIKE1ndFp0YSE5SlyasY8RCywgrjGE8evPs0awJms4VrKxJ/gIW8EA+hhf+EfiZEQiM0PeM=
Received: from CH2PR19CA0004.namprd19.prod.outlook.com (2603:10b6:610:4d::14)
 by BL3PR12MB6545.namprd12.prod.outlook.com (2603:10b6:208:38c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Thu, 12 Dec
 2024 06:37:18 +0000
Received: from CH1PEPF0000AD7C.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::cd) by CH2PR19CA0004.outlook.office365.com
 (2603:10b6:610:4d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.23 via Frontend Transport; Thu,
 12 Dec 2024 06:37:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7C.mail.protection.outlook.com (10.167.244.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Thu, 12 Dec 2024 06:37:18 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Dec
 2024 00:37:17 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <quic_eberman@quicinc.com>
Subject: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness tracking changes
Date: Thu, 12 Dec 2024 00:36:30 -0600
Message-ID: <20241212063635.712877-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7C:EE_|BL3PR12MB6545:EE_
X-MS-Office365-Filtering-Correlation-Id: a65610ff-84ff-452a-418f-08dd1a776ca5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vs59m1KOEjlBas8MTOe0s9BtQEUnr8/I9w4gUdX90iusdhBc3jrr+R09iQaM?=
 =?us-ascii?Q?q6TlvCTa/ciln8wxe6z5W8d8z5Zyug1vg8dag/hpcfUwjMR/GDUtpjg1B07M?=
 =?us-ascii?Q?aDy1VfslTBeVAUKMlBRh8HnPGrqfKh9OKhfrgqmhS8ZzKIlKcc+tp3WE8giD?=
 =?us-ascii?Q?UHX79jhWqnLmId0XjeFQJj3nbzV1ARbSHEiNANGeyFRVOXypK7GhOjyEgKhK?=
 =?us-ascii?Q?H8Zyi/I7FyI5z9qHWZOSh9qt8geGnQwy63CdIN/wv/eTQsyXgC4sAi2NrBUP?=
 =?us-ascii?Q?4HZjWSez6CmwWMkYPhgQDH8UmrNHWmBVxOmq5k1CsxN0qTgLwleFuGHOL99c?=
 =?us-ascii?Q?zI5GvXm2b09J/PBYQUh+H/vdqziTYmXPXSZtmIwVKTSo2HPI7ZxKuSABfpvl?=
 =?us-ascii?Q?m1Kcw+GKc1CnAw7usz3WGgiVPGDV18gClWqa8Vtwk7E/4LMUcXH64jVWAn1s?=
 =?us-ascii?Q?vyxsO0NYzC5/U8SJcM+veBq8yX2TbAcaSzbZTwlaARmb5JwUA9SX6ti3F9UV?=
 =?us-ascii?Q?nI/q1E25fP/Hdbqv6HYPtO/WNPEZih6oazGGIkRE+CLPC6tELA3JIwNUq2RU?=
 =?us-ascii?Q?qQq2vZlDGV1btIW5aASrpl3LQMNW9d3fF/V+B+XlDWe2jk3XjpVUe85U68dL?=
 =?us-ascii?Q?tSBUS+ris35uRKgc8vdxL1Z1tJNPhtbdF0G5lfLiMYl1aPqzZqej3EAy7koi?=
 =?us-ascii?Q?hTPkRER7NALflJ+AsLqGhJG8ic8bJ603x0CXnzUNGlSMQUcO8CQE/N02xNmX?=
 =?us-ascii?Q?mg5FE9n7d6SVIX4icyMj+J7PZH8lfG8XBB3YQqf6gvbmhYM9WlmPaAU2Eu6l?=
 =?us-ascii?Q?70b1QPu/a76EmrekWeoxACOyIjk/egU632tHFKl0MWKh9QtvNMVmjmBAN827?=
 =?us-ascii?Q?c2RWCSqd3ek9bMpz7010gGjSikMqmhAV75P9aImOb3gNC0lRuyQuPn+/VEfg?=
 =?us-ascii?Q?MIy9bz2TfFSSJFu6G3ydKR0SalsX2QctoRF2m13FSfMsweJDSWupw97KyoyZ?=
 =?us-ascii?Q?y30Q13Y7Vr/iC4APxLlqY6l+hp563ElXr3pbFkfZeL84PmApij9Tp8VL+QzS?=
 =?us-ascii?Q?8Zi52u8TsVeD/YKjcZPD6OZIFz+zMzF0gE4KvdlTPSJUQ9M6Bmzd8YrQw+Q1?=
 =?us-ascii?Q?8+pDYomDrHKF+jtUcZw1D4ZSHzwr2sbw3xNxYlpOY1hNQ/4OFKwRYoz/5Rem?=
 =?us-ascii?Q?OKGRpDQZd6Rdi6KjtLjE58VvYY7TZQIHTa+4c1hbBW+fPkNy/6RTpoupBanY?=
 =?us-ascii?Q?+LXkZIYI7wWaXvAFBZ8Rs7WN1wCijRpbJuQaZ6RPpBDYtPwmzvPs6h93tZBs?=
 =?us-ascii?Q?oMYzk2a8XAEPsjHwgfX+H6/lHi9Sp2R+YeiNaPQySvGc5NbN0A2TcjS3AuJF?=
 =?us-ascii?Q?uXuyyuSuJf+qUIZh3AGNyNDVeXj1amZ8nbElhaqwJU7ZNpQYksVZSvchWqf6?=
 =?us-ascii?Q?FC78CdttQtXZ+YkXuYaoPCWZLjZVLE0kBWK8g7rNJ1MO51MdonIxxw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 06:37:18.1740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a65610ff-84ff-452a-418f-08dd1a776ca5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6545

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-prepare-thp-rfc1

and is based on top of Paolo's kvm-coco-queue-2024-11 tag which includes
a snapshot of his patches[1] to provide tracking of whether or not
sub-pages of a huge folio need to have kvm_arch_gmem_prepare() hooks issued
before guest access:

  d55475f23cea KVM: gmem: track preparedness a page at a time
  64b46ca6cd6d KVM: gmem: limit hole-punching to ranges within the file
  17df70a5ea65 KVM: gmem: add a complete set of functions to query page preparedness
  e3449f6841ef KVM: gmem: allocate private data for the gmem inode 

  [1] https://lore.kernel.org/lkml/20241108155056.332412-1-pbonzini@redhat.com/

This series addresses some of the pending review comments for those patches
(feel free to squash/rework as-needed), and implements a first real user in
the form of a reworked version of Sean's original 2MB THP support for gmem.

It is still a bit up in the air as to whether or not gmem should support
THP at all rather than moving straight to 2MB/1GB hugepages in the form of
something like HugeTLB folios[2] or the lower-level PFN range allocator
presented by Yu Zhao during the guest_memfd call last week. The main
arguments against THP, as I understand it, is that THPs will become
split over time due to hole-punching and rarely have an opportunity to get 
rebuilt due to lack of memory migration support for current CoCo hypervisor
implementations like SNP (and adding the migration support to resolve that
not necessarily resulting in a net-gain performance-wise). The current
plan for SNP, as discussed during the first guest_memfd call, is to
implement something similar to 2MB HugeTLB, and disallow hole-punching
at sub-2MB granularity.

However, there have also been some discussions during recent PUCK calls
where the KVM maintainers have some still expressed some interest in pulling
in gmem THP support in a more official capacity. The thinking there is that
hole-punching is a userspace policy, and that it could in theory avoid
holepunching for sub-2MB GFN ranges to avoid degradation over time.
And if there's a desire to enforce this from the kernel-side by blocking
sub-2MB hole-punching from the host-side, this would provide similar
semantics/behavior to the 2MB HugeTLB-like approach above.

So maybe there is still some room for discussion about these approaches.

Outside that, there are a number of other development areas where it would
be useful to at least have some experimental 2MB support in place so that
those efforts can be pursued in parallel, such as the preparedness
tracking touched on here, and exploring how that will intersect with other
development areas like using gmem for both shared and private memory, mmap
support, guest_memfd library, etc., so my hopes are that this approach
could be useful for that purpose at least, even if only as an out-of-tree
stop-gap.

Thoughts/comments welcome!

[2] https://lore.kernel.org/all/cover.1728684491.git.ackerleytng@google.com/


Testing
-------

Currently, this series does not default to enabling 2M support, but it
can instead be switched on/off dynamically via a module parameter:

  echo 1 >/sys/module/kvm/parameters/gmem_2m_enabled
  echo 0 >/sys/module/kvm/parameters/gmem_2m_enabled

This can be useful for simulating things like host pressure where we start
getting a mix of 4K/2MB allocations. I've used this to help test that the
preparedness-tracking still handles things properly in these situations.

But if we do decide to pull in THP support upstream it would make more
sense to drop the parameter completely.


----------------------------------------------------------------
Michael Roth (4):
      KVM: gmem: Don't rely on __kvm_gmem_get_pfn() for preparedness
      KVM: gmem: Don't clear pages that have already been prepared
      KVM: gmem: Hold filemap invalidate lock while allocating/preparing folios
      KVM: SEV: Improve handling of large ranges in gmem prepare callback

Sean Christopherson (1):
      KVM: Add hugepage support for dedicated guest memory

 arch/x86/kvm/svm/sev.c   | 163 ++++++++++++++++++++++++++------------------
 include/linux/kvm_host.h |   2 +
 virt/kvm/guest_memfd.c   | 173 ++++++++++++++++++++++++++++++++++-------------
 virt/kvm/kvm_main.c      |   4 ++
 4 files changed, 228 insertions(+), 114 deletions(-)




