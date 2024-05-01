Return-Path: <kvm+bounces-16320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B7FD8B8743
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:07:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23E061C23022
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E1B502AE;
	Wed,  1 May 2024 09:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iYoQL1dk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1702C853;
	Wed,  1 May 2024 09:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554439; cv=fail; b=NoBGoCK4LZ/b+mCgMt3m2Jx3rUtHiczHMKmTPjEuhX6HrrNTTnRil5NAQGxqRNdbTX8drQWwC8rskFh2HhVbHNl6x0oQIlUQy0FR4HKou++1jxEaIBi8brmgQUsnMR/QKjDwl06MQ9DNVrGrn8u+7q0t9Yh0fKNBgyOBD5zjK68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554439; c=relaxed/simple;
	bh=KLaNgRFrzo2Pm9t7NGXZe5L0zu2jf5hHRtAFOk/iNWE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIHUaQU7cYWK0lvi64tKoD0YPOYAdAXsUR0I3B4wC+awyYyt+o95y8noI+BnMuTwHqV1WyedWKVrxEtPTne0QLfJjOgE4ZuHaJUhxwvc7+necfHLi5DlL8PaDkdoNWCoJONIY5PHygy3D5+1/BhWRGdN+P4Rl/aDWi3zphaaxYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iYoQL1dk; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ek/qvCRv1fC573m7DQMXBBoCxj6a2ILYX8R9eviL+VCoUeFOCAkr0ui2iUkdUzq0IQK+yE5YwLFkamHzkuzSPlx30rGZIK5pPclP56ymuqD9dNmbU7BkNIvn12hEJWV/ZjYeQjt0jr3LDaAdR4augLz0swJTZKRXoLOczi292YT43B5njMYkvCX07ydh10YyQqCchr1hzWCepZwgAAgGZJ0izNKEbDk7uyKkpW6uXrWrzl31Lt+xGHqMuvsdAiirg9AVWgQSfaJlFnyuW9DgIIz7cif38IPQMwK1QNsfgFPMC4PM+enZn3J27yfeAA1Fqc3sQFLN1EcFwP4lf3zsyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BWH3GNLeL9sQ4PkWWThCO7b5Qbxt9LKELlPiXbR6D4=;
 b=JdwSyBEDoZRWiJzDekPxnP4FkNiNf8Sot4SB2gNgPakjrzf6zxdf3X1kUQ9JMBAVoZ41Dq4adnIi2vYwT/TQxvxIXAo19gV9lAr7SVgyfTIvpSA960fZtHTOHT0MyqSs1LhmG7qsWgqeGgHtBSW7W/VmaKWyVDno3k1rxIa8Ob3Pa8xmj/oBvXSUlGH5PB+7DnYmjNBUmLwBlBp6OO2q78CBUUjUo/qyPxmF34InimErxaMW8h6TMYvoigd8hZPW9YkroJ9pkQTQuVFgRNlh8SzhGtPi3DIkFF6nyWVW32xbmlYjBmwClP/8hBbCEblWRs+kw6JT7cvvlJfYbIfb2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BWH3GNLeL9sQ4PkWWThCO7b5Qbxt9LKELlPiXbR6D4=;
 b=iYoQL1dkcc5O3ws0NWLc2Mgo2uquc86L5ZTMuhklXEdC98op5JkTW1SGWHjMxQ7BESrVWlLJNHdd2trBWOnffetbsHIXAM5jVX99Ika/9Upf8/euubeXrf2X9DwidrZSiStXP88wcCfba0sqHrfHOqESATN18Jwk6gJ7Vben46s=
Received: from BN9PR03CA0636.namprd03.prod.outlook.com (2603:10b6:408:13b::11)
 by MN0PR12MB6176.namprd12.prod.outlook.com (2603:10b6:208:3c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28; Wed, 1 May
 2024 09:07:15 +0000
Received: from BN2PEPF000044A0.namprd02.prod.outlook.com
 (2603:10b6:408:13b:cafe::98) by BN9PR03CA0636.outlook.office365.com
 (2603:10b6:408:13b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28 via Frontend
 Transport; Wed, 1 May 2024 09:07:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A0.mail.protection.outlook.com (10.167.243.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:07:14 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:07:13 -0500
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
Subject: [PATCH v15 02/20] KVM: x86: Add hook for determining max NPT mapping level
Date: Wed, 1 May 2024 03:51:52 -0500
Message-ID: <20240501085210.2213060-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A0:EE_|MN0PR12MB6176:EE_
X-MS-Office365-Filtering-Correlation-Id: da130d67-db94-405a-4e2d-08dc69be17ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|82310400014|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ePWBXUnH8RlTULBIIfF1iE8Zn2Nl0L9mv7qB9E/fJlpnI+JZncU0Vn2TKYF5?=
 =?us-ascii?Q?AOpZDJ1V04l918NGkfmaUpIAMNiaIhKQtbnyFkgGJilaOP1O0a3Gg78GckYv?=
 =?us-ascii?Q?0RzADUz2QlOyS5zfyYxOTSO2EouCllZ4w7SLmh7sK6ZPkpdJ71/PgGhSoGbf?=
 =?us-ascii?Q?zp8DbuzUGJGDlBBvKvwz0Tb2/e26sp2HvRAXdPDAd+mLPSbmu0MlhfUQ/eIJ?=
 =?us-ascii?Q?8U0htJEWvMjacdKXkalaM9B+1QBpcwRm+Qb0ahokD8CjKgkIq4ghqQYhEKh9?=
 =?us-ascii?Q?uyOYFPEd8ESq79n5Yi72PTqYeFseyBJJz62l8/rN1VrEtY0EEsqq1cFE21PO?=
 =?us-ascii?Q?xvMQ4G0mKeRm65E8XmYSqINQYksRqpWWJks24M848fJOQIA9fOfD/wnHlqay?=
 =?us-ascii?Q?IhZHpm67o7tsqQIerQTgBNZbA7UnxpAT5dsYbu5HfwdUOeKp2fV/XnEd60Bc?=
 =?us-ascii?Q?tPCUJ5nkbS06Fd5Vo45Dk+V1JAiKBaHrpsG5tDK/K9M28CuWm+8tdv7eGIZb?=
 =?us-ascii?Q?syHHBIzCWZmizqNMG2xqK1wc2BQswRwI/gKmtsE6IZF6IjJ0oT91kORxxoB0?=
 =?us-ascii?Q?PSlHVvCciBTRKntofDg/6oYp+tt+6foYEamBFZKjd2YMe9utiaDYv048M3QX?=
 =?us-ascii?Q?7vCXsN/TnqZl4zse/aaBfNWrB57cgKZLaZiwfDXxCamx3xEhhNYOdK72b9+G?=
 =?us-ascii?Q?7Al7KEyqwARU9LYra0BKBT0boOVq+vKDtmfTo1j5V/XK0Mt2vzxd/qpq65JB?=
 =?us-ascii?Q?7tXRBfUZEE4Mf3hNC5hDFdQ5SHA69P9AwOuSa1TEEktdyM/CVO/oPkr3rFP+?=
 =?us-ascii?Q?S0o3H2OpKNJ+JvMev6GlIC5DcKe4Q7VS+Bo4W9YgEdU/1g7sK6+uXyaDli9x?=
 =?us-ascii?Q?Ur5KokC4Fp5i02rdMErBPIhCNqvjL/gz3Q4rLln0J0vG2Q5uyE7HD8vYxmKA?=
 =?us-ascii?Q?F8q1hEFWXJS4xd6eNHFH6R9pkUpFORW3qIG7aboLbFMIWEHkiL67UoHb840h?=
 =?us-ascii?Q?a+qOzKoOiXWYv2H2htuthRlA0YmahbPBe9AclBIZWdvxvyocy2bow4FTF35T?=
 =?us-ascii?Q?+YAqua0O6SgUhd6aIgzqJ66/1N0jCBSwqfflZGXXGfd2zCXsuAJsdW+PGQJZ?=
 =?us-ascii?Q?S/3cOKctTb6mIawbJYDcq0xgTos3c9eGBpbtVPoboBzi889joA5Awkk20TuC?=
 =?us-ascii?Q?QorqYkPhJKh7taL8VJcVYtyLGcNrq2PvQjDLj+WzDp4YYJ25m0R/ga6ALRSE?=
 =?us-ascii?Q?kOuzF+itD6nfEtzqCyPzQDzqXYSZfRuVuAGIQ5x2kj8aDDHijqXs65YFGIRD?=
 =?us-ascii?Q?ejzpXfOXQk5tM4ERo1pu/fqTKcvKFLHf8JflBNgo574IpwZDKDuPp1K+UubE?=
 =?us-ascii?Q?1g9DqfY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(82310400014)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:07:14.4920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da130d67-db94-405a-4e2d-08dc69be17ea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6176

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

Add a hook to determine the max NPT mapping size in situations like
this.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/mmu/mmu.c             | 18 ++++++++++++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index c81990937ab4..566d19b02483 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -140,6 +140,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
+KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c6c5018376be..87265b73906a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1816,6 +1816,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
+	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 510eb1117012..0d556da052f6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4271,6 +4271,20 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
+static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
+					u8 max_level, int gmem_order)
+{
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	return min(max_level,
+		   static_call(kvm_x86_private_max_mapping_level)(kvm, pfn));
+}
+
 static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				   struct kvm_page_fault *fault)
 {
@@ -4288,9 +4302,9 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 		return r;
 	}
 
-	fault->max_level = min(kvm_max_level_for_order(max_order),
-			       fault->max_level);
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
+	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
+							 fault->max_level, max_order);
 
 	return RET_PF_CONTINUE;
 }
-- 
2.25.1


