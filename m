Return-Path: <kvm+bounces-17146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 152068C1C71
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 04:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38C0B1C20BF7
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 02:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8351A14883B;
	Fri, 10 May 2024 02:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wpApFz8i"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DB1148FEB;
	Fri, 10 May 2024 02:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715308602; cv=fail; b=LUwTY/y7nwdBQNBDBgXvs+mjiQSTd9Db9JpGv1VQ72V9SNdIC22Q2p185xUVVYtYR4y3lnu2wFTNWJRHObfOur/RCAyrkXRPgdp4UJuXiTAHBJyGPwFKmrLyVruxGrgePFDcJbe1f+YjiCkVV2Tr+WHoz2jszcLIj5pkDgVO2/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715308602; c=relaxed/simple;
	bh=55rOGSOSrcRZM3UtM+oxDWtePaOWhJq7An03Nsz/miU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rR5wgk/lwtQHGGusljRawIYa7P3HDzZ/QQIBsunh4S8o3bAXNFZ2gynEw35ESPgNaPTgQsbv71xa0hdlGRcO9OP8gwDrvS7SxLm1YWeSH1Uz2SFq5M83vZUJVyGsEqU/OqFCy3YeS4c1EWSCL8RdZuCJAmw6apMlcPMNY7F0tW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wpApFz8i; arc=fail smtp.client-ip=40.107.237.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvUJ2uQLt5PVmBLnGtBqYs6HYo4SbN01xFxHcMlfRpMHmVlSyvlhwR5HJvfHnGLgu5PejxDGEgL6EUmdGCrn0cLF+MZbLr+HY95j3C5Xtobq9wxpC6V3eXgr23X/F7cykl2cPDfWYx5dX/RwpVrFM5Uqf+o6IpHFqbgfts1yiSSJjvtYoIjfPlW862o7AUT2mcFo7HDmpiVAZ5tp+rBgUbCnQNN/iDnP41u/wl2mK2gXDmCXL9ZLzhpkSmwlbXAZmLF+fCmhRz+ylDeXTa6dQ2T/tPFc9Eel0kMcolEmEyG6vog4BBEEu4HG8HD/69ME9WfyFwcqrr93MOoWwUJ4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvSZolCBykKdQtTZaILW7FQXukMYbhMEQkcghT+tDNw=;
 b=gqnSKT629gQzl3bOWgWoA6NQ8Kk8nNcc9QaenPmK3em5Qx1v2aEVKQqveewzcI5k24jVcyJUjGopvYAHruM5iOm83fdHdF3uw1Yl1QczLUtNWu3vPNtu1zzkqJVX3dZNUIX3wcQL0jsnuIaAoVBl91s4fkJrpoEGryUY1JGhu2YBPVqTNO1B5R+RiVwJMPwD/VVD4yWFq/YFUq49QNQBKmiktYrQscrke1esN0OXkzNfcUcLTZGverbowNPQCafD4BKKdCQOAcUWbCo8Ssu3zr6e69M23CWRG7ZYh9WWVIpkWFqj7I7RBbgSoyQlmjNQJ1zCMgkBX/WhaxwD/DbbVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvSZolCBykKdQtTZaILW7FQXukMYbhMEQkcghT+tDNw=;
 b=wpApFz8iNOpST/ptOBC9jf9MLZ3qXtQowrhszTUfU7ORQRopZHPywvNrq3R34WRFMqHD2zyB52yMBWY176+a0qsF2hCFHJF4dg+HK056ZIy64gJKsNPNVNgaGQE3dod1V6YW8MExwjf8ZvOOwwQ77qkFubmLvupGTCTDT36ir9M=
Received: from MN2PR11CA0023.namprd11.prod.outlook.com (2603:10b6:208:23b::28)
 by CH2PR12MB4149.namprd12.prod.outlook.com (2603:10b6:610:7c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48; Fri, 10 May
 2024 02:36:32 +0000
Received: from MN1PEPF0000ECD7.namprd02.prod.outlook.com
 (2603:10b6:208:23b:cafe::bd) by MN2PR11CA0023.outlook.office365.com
 (2603:10b6:208:23b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49 via Frontend
 Transport; Fri, 10 May 2024 02:36:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD7.mail.protection.outlook.com (10.167.242.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 02:36:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 9 May
 2024 21:36:30 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>
Subject: [PATCH v15 21/23] KVM: MMU: Disable fast path for private memslots
Date: Thu, 9 May 2024 20:58:20 -0500
Message-ID: <20240510015822.503071-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD7:EE_|CH2PR12MB4149:EE_
X-MS-Office365-Filtering-Correlation-Id: 097b6ffb-7c53-4761-2923-08dc709a00d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|7416005|36860700004|376005|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jcc013T/TnDlncSxcKTAre8nd9XjAKVnDK5/eAD2XzDjCUJY3vEZP4Yb+39O?=
 =?us-ascii?Q?QKek7B7rYKlQPfXOZAbBfWQieYUOIxNsxt77KDQsGQlyepMOZJzuPKvgycRn?=
 =?us-ascii?Q?8bcQvDACipdY3J+AxyXxYFyNkUUQthz8ERUW54uh/pXNxW2cB1tl8zb82Li1?=
 =?us-ascii?Q?TAuzQ6fdwF0sYFNiS03Z7cTpMNAZ+YTTYXJBYWIC1IamzR7r3/ElN0iHmK9H?=
 =?us-ascii?Q?hpP0xay7f9WbfueybKuA10IzERtAGikLYjpVhMpq6fOAJc83Z+pJLmfGD8/+?=
 =?us-ascii?Q?lFC1aZhndbzS4hVsaGAI1GHqRrLgQNG2FZ4PWsOvGb8BLRPx86yQ80F6w29I?=
 =?us-ascii?Q?7dS5+MZ8+HpoXBjf4zcqSMtJfKQF8sDyt8YB7E5GT/uxTqkPgMfGRzJceLaf?=
 =?us-ascii?Q?zFUu827Oa7P8KQ4uYtD1+csWTKgupWB5jAV2gVjbwH90YLGlmlHmW1C99Mrr?=
 =?us-ascii?Q?f81IKDLWtXFfwsWdFkV0YphLH6Tlqqf7Q4AkPJfTPdGhkJcgN7BjrIO4yOtd?=
 =?us-ascii?Q?5PMjmjZTRqAXfnXWfST5r3oDCqRVg0rQktG2XxnL8Cl+pKMaoCYbw/rdvIXe?=
 =?us-ascii?Q?q6AB9NQ29h2wndTl+RCY+FqGpcyTyFnub61ZhZlgri3uV8AaUrNEBlshvHsV?=
 =?us-ascii?Q?ZbKrZTG/KWY42rWtSrkttqwvoKNybqevOq117EbG2PkAnM/5mYChfuYTJI6a?=
 =?us-ascii?Q?6psqv7PgtVVHfPPUslNfUGNpFHwqHZRiBEz1iUHuk0I/vDnNdlzh4TkJCLbt?=
 =?us-ascii?Q?eqA+q4D7JHQenHhMr1KYbR/PNhDp6igSpw/x7EpKFQgHU7sE3ao7vel7whjO?=
 =?us-ascii?Q?UjY/ndHzg3NDDQKIShfGJ5sQwJX72nDf/jf9exh+Tyc2iGzHTVXgmbLjjdmG?=
 =?us-ascii?Q?uapnyskwWqe+Mq6vycId2gLu3PPK4yBwaT1KYzuhBh4lIUk6GZtwnNGyNLUw?=
 =?us-ascii?Q?RDvHIHCzn4hOKIpAH5Y5Qx4S2M/2y8tWdS0gfM7sPD5XYBTDHIy8lZzxmmVP?=
 =?us-ascii?Q?t0p7vcIGCNlIknxkjLYWuVqRCiMYa3UJ/rhDmv9gwFuQwybUyJR9DPHTCGZf?=
 =?us-ascii?Q?+zxtTsySV5sre8+DP6sypPjmueACiexuDLt+n7QO20XD1lF+LpdmZqTecHGy?=
 =?us-ascii?Q?ofULqIJUXeKe/lee+PnJVVoxcamdHIeJo9/vPRZEPaA6MVvaHm6FTj1aJ4Tk?=
 =?us-ascii?Q?BFEB7R80fFLmymevZFrQjmA6QjsqdVCABoFNPwkHwADQ6ZrYpcDF5R4DS0Bw?=
 =?us-ascii?Q?wPLO9J6bQfkshOmvtPD0LoPNz3y+q3yZIP7sjqMMrn0Mp7lm++fHhVnphP88?=
 =?us-ascii?Q?rysocejpT+vfRdVzXL68uL/QlTy/tLkV67n6yPXL4iUrUncUgrVWfwgwEoGN?=
 =?us-ascii?Q?olojh8t1cX3d+ZZYrQnn+Usn1mSW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(36860700004)(376005)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 02:36:32.0255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 097b6ffb-7c53-4761-2923-08dc709a00d3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4149

For hardware-protected VMs like SEV-SNP guests, certain conditions like
attempting to perform a write to a page which is not in the state that
the guest expects it to be in can result in a nested/extended #PF which
can only be satisfied by the host performing an implicit page state
change to transition the page into the expected shared/private state.
This is generally handled by generating a KVM_EXIT_MEMORY_FAULT event
that gets forwarded to userspace to handle via
KVM_SET_MEMORY_ATTRIBUTES.

However, the fast_page_fault() code might misconstrue this situation as
being the result of a write-protected access, and treat it as a spurious
case when it sees that writes are already allowed for the sPTE. This
results in the KVM MMU trying to resume the guest rather than taking any
action to satisfy the real source of the #PF such as generating a
KVM_EXIT_MEMORY_FAULT, resulting in the guest spinning on nested #PFs.

For now, just skip the fast path for hardware-protected VMs since they
don't currently utilize any of this access-tracking machinery anyway. In
the future, these considerations will need to be taken into account if
there's any need/desire to re-enable the fast path for
hardware-protected VMs.

Since software-protected VMs don't have a notion of a shared vs. private
that's separate from what KVM is tracking, the above
KVM_EXIT_MEMORY_FAULT condition wouldn't occur, so avoid the special
handling for that case for now.

Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/mmu/mmu.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 62ad38b2a8c9..cecd8360378f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3296,7 +3296,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	return RET_PF_CONTINUE;
 }
 
-static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
+static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	/*
 	 * Page faults with reserved bits set, i.e. faults on MMIO SPTEs, only
@@ -3307,6 +3307,32 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
 	if (fault->rsvd)
 		return false;
 
+	/*
+	 * For hardware-protected VMs, certain conditions like attempting to
+	 * perform a write to a page which is not in the state that the guest
+	 * expects it to be in can result in a nested/extended #PF. In this
+	 * case, the below code might misconstrue this situation as being the
+	 * result of a write-protected access, and treat it as a spurious case
+	 * rather than taking any action to satisfy the real source of the #PF
+	 * such as generating a KVM_EXIT_MEMORY_FAULT. This can lead to the
+	 * guest spinning on a #PF indefinitely.
+	 *
+	 * For now, just skip the fast path for hardware-protected VMs since
+	 * they don't currently utilize any of this machinery anyway. In the
+	 * future, these considerations will need to be taken into account if
+	 * there's any need/desire to re-enable the fast path for
+	 * hardware-protected VMs.
+	 *
+	 * Since software-protected VMs don't have a notion of a shared vs.
+	 * private that's separate from what KVM is tracking, the above
+	 * KVM_EXIT_MEMORY_FAULT condition wouldn't occur, so avoid the
+	 * special handling for that case for now.
+	 */
+	if (kvm_slot_can_be_private(fault->slot) &&
+	    !(IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) &&
+	      vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM))
+		return false;
+
 	/*
 	 * #PF can be fast if:
 	 *
@@ -3407,7 +3433,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	u64 *sptep;
 	uint retry_count = 0;
 
-	if (!page_fault_can_be_fast(fault))
+	if (!page_fault_can_be_fast(vcpu, fault))
 		return ret;
 
 	walk_shadow_page_lockless_begin(vcpu);
-- 
2.25.1


