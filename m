Return-Path: <kvm+bounces-16313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B51D8B872D
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC4DB1F2424F
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712D651C36;
	Wed,  1 May 2024 09:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0Yq8QSvT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456A750A6E;
	Wed,  1 May 2024 09:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554289; cv=fail; b=rJEBGzAwakPQ8zfIhBnu9YVFylFmZMzdw9CE8TPsvbU3IfmY0dGeKuAGcBBsa0EOhUHVzI7o6gIztOEOO1MnC2DvNG4jRny2CyQFWJ4XL4z1XrbDMH5bQCQgwwk9G3UJfDIxuSN9xXuwttDqzPZKY7i+zVg1kOf1awol1ddFrQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554289; c=relaxed/simple;
	bh=R6RwPmHIuzdiwx1hWrxmaknsya2FXoxHCu8cQuC+zbI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTl5Jn8+bXf6d39FtvdR5ATeIBZccHvPijsLT6Nrl5//PGMN9D0W8RCWv8U85KEtgv4ctXMp33rarewCYuRRG5Zu+x3Nejw67/23w4rbPcMcUtEwSfwV0IwmM76EO19ZjN7j1ccc/4kvq0eN8g4qWPSI3xZFl3lfEQTfiQtbNsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0Yq8QSvT; arc=fail smtp.client-ip=40.107.223.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYYRQeMh8BruveL91eD6uUtvSZElMhrTkMtBDXWWl+bsnto0FSf5M31X+UPALT8XzgkBKm9YCQRLTSoMR1XLOiylJ8BEVv3g1SVVxQoMfrPrzMH20arWHW3XUqhrzvJ/EpIThTfdAXrUPomWuYXLKmwC7k9A2WBioABpNHlfxWCDIa6sJaVfmAnoAVia9WTiqS434KHhDrvEhHrUVC5uvd9L9NOInKB46SyvEVlzyUlgUnK+hlVg8UETKaL12gm8KA48O2zGKNPXCdC3lC4hVLA/0JB7pXzi4ilDffiJAd+qcTfN8YcZC4BckOCEHSyO6EHuJwmmHNKYlt4GrEDP0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=odLsKy2BVTXhQ/IUMjT5RUgh9M/qTLi8/RJo4yE97cs=;
 b=YSYXIZh3IP5WyH0XgJniflOIkSLI83Bhe8kWR8NSqxabcCGKw9C7E5nJIGcvUXg7uTmZYk+9HC79TV1bfSBKgDV9mJXlnJr/Fkkw28cN9qbvcvMN47c+fTAw5nQpQ4PhcEwqCgPTtP8JM3ABCJfGTgKvEmOXZxBwenx09/ta1SRPOaDyPlSA2T98lkOlcWuengA3PESjkHJ81GTEnqUWXwEzUR+fzf7HCOapRgkNT650n2BM+e3MfO6vlrLu5xQloL29LCfSvH8o3KWTHGDiuDmr0G0ONppgVQOI1i9iY/M1Jjx6Fy5Ey4IngJKKgOzn/FnMX+nAIdT+4bv7irWGEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odLsKy2BVTXhQ/IUMjT5RUgh9M/qTLi8/RJo4yE97cs=;
 b=0Yq8QSvTEfxtED6bFmyKy1glMVQu8W0+9MY6yhTjKOE4hGpn5jl3YSZscvZvFgdI3VJpqxg+79YPS7A5mRrztzfn3DzojZbTCg24QQBSleLlrhst769Q/TbSREInho4qEzvfYwcUSjl0ygKKT6KOMZHNnNn4hvGpirnORFJD8QE=
Received: from SJ0PR03CA0049.namprd03.prod.outlook.com (2603:10b6:a03:33e::24)
 by CY8PR12MB7338.namprd12.prod.outlook.com (2603:10b6:930:52::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28; Wed, 1 May
 2024 09:04:45 +0000
Received: from CO1PEPF000044F4.namprd05.prod.outlook.com
 (2603:10b6:a03:33e:cafe::6d) by SJ0PR03CA0049.outlook.office365.com
 (2603:10b6:a03:33e::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.27 via Frontend
 Transport; Wed, 1 May 2024 09:04:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F4.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:04:45 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:04:44 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v15 15/20] KVM: x86: Implement hook for determining max NPT mapping level
Date: Wed, 1 May 2024 03:52:05 -0500
Message-ID: <20240501085210.2213060-16-michael.roth@amd.com>
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
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F4:EE_|CY8PR12MB7338:EE_
X-MS-Office365-Filtering-Correlation-Id: 80eb790a-11ff-4364-035c-08dc69bdbeea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|82310400014|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K32I9VwWuvDmAbJpOGAbhyOULboQhvTw3ra379GBwIpEl77ornxOrmjh+ty+?=
 =?us-ascii?Q?3hnHFbM2lwIlJA6dHtS1FHPU8lUyrKWjIo2UyVKe/Jei9ifMppCiL594bCZI?=
 =?us-ascii?Q?MwP9K+ZL9QMsv4+6x04TDW0AMYsabcYeVwHIywawBsU7hQ5hgYDIWs6hvQV9?=
 =?us-ascii?Q?b3MHEjZau0S1KM5KuHHJkOWt2i++TYIIWAEcN1OHCsf7T1pjJCWjE06wGtAm?=
 =?us-ascii?Q?uZ1zmv0N7PdKldEWSGSGlfOO+f/8Al+sW7JoDGi2D8DQQHtR0RXmKKnFM1ti?=
 =?us-ascii?Q?8uhkkv3gT/TQJlbyHgWwXrZFpA2t2+ZEGtO6YGMyPNU2W0GjDEPOoXMMdzcx?=
 =?us-ascii?Q?NwuCBXzl8soAPIGJXzK0rL53Rbcfrahx5lfErRz878YM/RA+szhWzgsUbrKk?=
 =?us-ascii?Q?RXdsCkwqgEYaEyoO80oWFA0pjSPN4dVSDP0eDdbPesxHG3ysMtxqBFFxPyRI?=
 =?us-ascii?Q?/W2TR1e6lSTmARtfHO2g3orbAOBaQO44x+jcc1rWDtB7dS3/rcF4n5XWNULf?=
 =?us-ascii?Q?2yDqJvRUPmeRh906hiHYKnYtID9DdZlQM1Jqk5X2gHXqDQqA2H4szVk3SrYt?=
 =?us-ascii?Q?6rKWReHx0WedDvonBpOEAjho8cXMzK9QHrea9da/277TkvNwn3pj3Gh75Wv8?=
 =?us-ascii?Q?goCI5yWyrupipnWI1vnf7AhpDUxyA0etk60fiDUF7Nx1E2ui5qFEheZL3mzF?=
 =?us-ascii?Q?FS/05wA1RAWsBE3yy2ek/keNdSwDzEwwBBqsGWBdE7J83/diIh6fPWthKjhc?=
 =?us-ascii?Q?1pYUTandgESLE7PfPGSKwlR7kofBj7LFXq3h1QMBkRrRHQPawU3dp6mzgWhW?=
 =?us-ascii?Q?hvofhJ2GjV3hFRamdUqvuwpK+UO2gJT9OKXirkNxwpKsLKv9fq82xEtljP8d?=
 =?us-ascii?Q?Lkg/s1zBLex9MmJFAjX9oSfpFup5fWkGPJkuLE9QT8j16SJSFdceLRlBZ+eC?=
 =?us-ascii?Q?9tT34zlCMw9wyfARdQJv9lzytLSHL/WmAov//xXdZKxBw46xoEfbIbABguEr?=
 =?us-ascii?Q?1Jsgyb2IffetX4L4XRV5DcURyVM8vPNTrTqnIP2cKkatdsr9ewB8tnMH45L0?=
 =?us-ascii?Q?t+wl5NAyqfke/gQExWx+lmWo+cg+UC/7EyVTIANjXePB+yuwMzkPEUSnnGht?=
 =?us-ascii?Q?iAwg6mN4nhCgoDxfbwkwGC9yC1SAtQj2iydFz6YjXawoOYDcRrBCJOK/VGvm?=
 =?us-ascii?Q?7krIcGDIjvyC893q4RrBBLDuds+pnLQnqUOgGc44fgV8VkRN+Yj+FnCAaeic?=
 =?us-ascii?Q?S0fFkoEGseGpZzQLi0xlQTzFwqt9XZTr4z4k2pygWXBdR/270qC3lXWj1DES?=
 =?us-ascii?Q?khfxhsN3RFZKMin3xKlCRJDfnBRvFSwgBVt34qQkEIlBt8Frj931G7uX20Vt?=
 =?us-ascii?Q?jKqjg+DpJuKGN/9cGBXv7GZ4LIRy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(82310400014)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:04:45.0479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80eb790a-11ff-4364-035c-08dc69bdbeea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7338

In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
2MB mapping in the guest's nested page table depends on whether or not
any subpages within the range have already been initialized as private
in the RMP table. The existing mixed-attribute tracking in KVM is
insufficient here, for instance:

  - gmem allocates 2MB page
  - guest issues PVALIDATE on 2MB page
  - guest later converts a subpage to shared
  - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
  - KVM MMU splits NPT mapping to 4K
  - guest later converts that shared page back to private

At this point there are no mixed attributes, and KVM would normally
allow for 2MB NPT mappings again, but this is actually not allowed
because the RMP table mappings are 4K and cannot be promoted on the
hypervisor side, so the NPT mappings must still be limited to 4K to
match this.

Implement a kvm_x86_ops.private_max_mapping_level() hook for SEV that
checks for this condition and adjusts the mapping level accordingly.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 15 +++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  5 +++++
 3 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cb89f6eba6ea..224fdab32950 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4719,3 +4719,18 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 		cond_resched();
 	}
 }
+
+int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc || !assigned)
+		return PG_LEVEL_4K;
+
+	return level;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 29dc5fa28d97..426ad49325d7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5088,6 +5088,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
+	.private_max_mapping_level = sev_private_max_mapping_level,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f91096722e29..e325ede0f463 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -738,6 +738,7 @@ void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
+int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -759,6 +760,10 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
+static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	return 0;
+}
 
 #endif
 
-- 
2.25.1


