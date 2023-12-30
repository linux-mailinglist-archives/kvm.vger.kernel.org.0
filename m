Return-Path: <kvm+bounces-5403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1609D820807
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98A361F21DB6
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FD6E555;
	Sat, 30 Dec 2023 17:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rykVirUe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEE514278;
	Sat, 30 Dec 2023 17:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzc17ZNF88cUQimcGJZou7TIMykZzvB5+Vr73sONw1bI40CsYDmwQUHgGA/I1CLYFdHM0LOmOzoVebgQ+vQt168OluvFfJTZxbxpdO/w0tFpJGnqzezD7eIl/EWDCrvEFnxoUh/leUOLWR6Pt2YGqJH6u66mHEG9H+NNLBGZ/dUwGPE7MhDtC6pp5SWgKe/jRTsrnkzfwAHUK3oSPZ0/AzjGOXQFMhGn1EzR4jXrdo/H9hHjntKXSeCOa7TRTYF6QUkZdyPw3IcvMwjmCvLcIEubVSvg8TmqovnnJRFf/a/4FvzTIUIGULakJDZK5c57nOD8l5f/9FmZZz1UknXe2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJdffYq+pgkM0AT83BPuzz07jf/OvU1Z3DbZaRfVCxM=;
 b=leYrJCh4K/J+z86v7poQOHeIDV5RNPONTIDJwSz0GoKgN1A3SMYOyot+wK6CfNt4FBgs/DJE7u+2VoxbJJgMy2F4Cz62dEC0EttskySQ1SZHSIlqo7ZCNGeA1/spDIaz8tARQjGBkqNk032Ap7gZQDcp1+mKJRB57Lcaeey/Ad1fAseO5sXoIewbt5WtMQCoS2dFG7SeZQ9awo89Wr3+hkSNB+s1MKKkNxQatTVKnictKtTwgacaVITjlJ6+H6nPKZ31iVzXCmrp+9VFBFlNsQaXRdpV85F0uHSdqrm3xkdTwP0qzvCevq0u3sxtMrjodEiPrDmzCvjirDSZfgBj+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJdffYq+pgkM0AT83BPuzz07jf/OvU1Z3DbZaRfVCxM=;
 b=rykVirUe0XxwEK9DATUEe0PLyeJb0tnhmFYTa+uN5xvC2jV10YmQCkRLh9PWTnD1bHSDIUDXmtHJSyRwr7ZYhfbogtmGDfYRH1giGJCB11Ss8C7ZyTy6JVOr7LQEKE/aLnPbn/puFDnsOfv90Av5Q/K7YA62qN+rHQi1FrNy2nc=
Received: from CY8PR12CA0067.namprd12.prod.outlook.com (2603:10b6:930:4c::7)
 by LV3PR12MB9215.namprd12.prod.outlook.com (2603:10b6:408:1a0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:35:49 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:930:4c:cafe::96) by CY8PR12CA0067.outlook.office365.com
 (2603:10b6:930:4c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22 via Frontend
 Transport; Sat, 30 Dec 2023 17:35:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:35:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:35:48 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v11 06/35] KVM: x86/mmu: Pass around full 64-bit error code for KVM page faults
Date: Sat, 30 Dec 2023 11:23:22 -0600
Message-ID: <20231230172351.574091-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|LV3PR12MB9215:EE_
X-MS-Office365-Filtering-Correlation-Id: 334e9a43-fa1b-4baa-4780-08dc095dc323
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wxN6fm/apkWgzkNJEpjEh2wJCpelHsl54VwsPr37kt0nNVURu9wENsqfVSqiM3llhBKfkksRgGHxGdD4C7t4y8204meDswl6m8jiDqRMV/neU76kvtAfMhchWNu491as/aBHVxeZzwGMa7UL84NWZ0kON+NrGKytoGrz+WLwiDp0arPlgKUZ8FMipnNWNBQEYrGkWfU/KKthFASs+oq8tOPAKi6OcenX/tVYutTBBMp18BRrNRJk4+r5qwpH6C9jBlOckqroXsMi3234lMD3jZK25rdGh0bye0qjtl8QwbIQtxPa/kB1hNgPwbAZryDo6+GHrklIStdqCxIcii5elRjN5ajBOES5wx8CeL7jQ4G+axzZQTyUWloc/099BJmz7pJz5A6qzyCH5C+Sh27RfVjvJyvXOULd9BLAqS5lqSqDWmc82FbGOLsLYeom2K9RAx2HTaWHcIBPUTtVYr1DIwiO0ZVpsKLccn5teOH5AX9ZbfSiT4Bf92QqDlRPdRaszyQzhtzjjU0Hk3pYsqEvLQWNRNHeVxZzwx3q4abwN0CcgQMsASguo6dBVo/TLdnngZPX28o9hSjhsGGQcJNx6+NiTk+Gm7x3kWm5BRPR6ZKV1Q0E6AVGjoS24cm6/bOV7Bm2kL7f0dEdSFZttinZJi7GIEJeSA4wM7TjsC7okUmL9gp1K5v6SRijeIhIIXzZrykb75RZUNGy59Dqa1jpn99BB9LlgHFC3M2VTAcMaSNYqgLNiVu7t8BF0+pyhD1m
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(136003)(396003)(376002)(230922051799003)(1800799012)(186009)(82310400011)(64100799003)(451199024)(46966006)(36840700001)(40470700004)(81166007)(356005)(82740400003)(36756003)(40460700003)(40480700001)(86362001)(426003)(336012)(16526019)(26005)(2616005)(1076003)(6666004)(4326008)(316002)(54906003)(966005)(8936002)(8676002)(478600001)(83380400001)(36860700001)(70206006)(70586007)(6916009)(47076005)(41300700001)(5660300002)(7416002)(2906002)(44832011)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:35:48.9308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 334e9a43-fa1b-4baa-4780-08dc095dc323
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9215

In some cases the full 64-bit error code for the KVM page fault will be
needed to determine things like whether or not a fault was for a private
or shared guest page, so update related code to accept the full 64-bit
value so it can be plumbed all the way through to where it is needed.

The accessors of fault->error_code are changed as follows:

- FNAME(page_fault): change to explicitly use lower_32_bits() since that
                     is no longer done in kvm_mmu_page_fault()
- kvm_mmu_page_fault(): explicit mask with PFERR_RSVD_MASK,
                        PFERR_NESTED_GUEST_PAGE
- mmutrace: changed u32 -> u64

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Link: https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#mbd0b20c9a2cf50319d5d2a27b63f73c772112076
[mdr: drop references/changes to code not in current gmem tree, update
      commit message]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/mmu/mmu.c          | 3 +--
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 arch/x86/kvm/mmu/mmutrace.h     | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c844e428684..d3fbfe0686a0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5813,8 +5813,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false,
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
 					  &emulation_type);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 0669a8a668ca..21f55e8b4dc6 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -190,7 +190,7 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 struct kvm_page_fault {
 	/* arguments to kvm_mmu_do_page_fault.  */
 	const gpa_t addr;
-	const u32 error_code;
+	const u64 error_code;
 	const bool prefetch;
 
 	/* Derived from error_code.  */
@@ -280,7 +280,7 @@ enum {
 };
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch, int *emulation_type)
+					u64 err, bool prefetch, int *emulation_type)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index ae86820cef69..195d98bc8de8 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -260,7 +260,7 @@ TRACE_EVENT(
 	TP_STRUCT__entry(
 		__field(int, vcpu_id)
 		__field(gpa_t, cr2_or_gpa)
-		__field(u32, error_code)
+		__field(u64, error_code)
 		__field(u64 *, sptep)
 		__field(u64, old_spte)
 		__field(u64, new_spte)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4d4e98fe4f35..c418f3b1cfca 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -787,7 +787,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * The bit needs to be cleared before walking guest page tables.
 	 */
 	r = FNAME(walk_addr)(&walker, vcpu, fault->addr,
-			     fault->error_code & ~PFERR_RSVD_MASK);
+			     lower_32_bits(fault->error_code) & ~PFERR_RSVD_MASK);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
-- 
2.25.1


