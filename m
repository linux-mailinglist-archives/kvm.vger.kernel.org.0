Return-Path: <kvm+bounces-5370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC0382079F
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:25:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DA821F21471
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310B3BA45;
	Sat, 30 Dec 2023 17:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pzyvgROu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90126B673;
	Sat, 30 Dec 2023 17:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCyBccf7yA/Tn0knRAIYoj9mXr1vnGmqI6bJw4I3wXw1lISNpxMU3yQ0a6t/ikSlgUS39t7CkPcoxX/1I0zkVCcGT4jbFgAcleHk8BTd17AO7SJxf5XPHzIyPSxzyVhtsjn4gk971l5/3I23130a99PlNoYUSRTK/9m1lIsMj1qbenao2VlX7Mqg5+4nEiLhcACh0FdDX7rJ66NYIqTMq4hPhe2cpnPXnMICVa9kKcALVYoWv3dFtGKsbpUePXSEUsRFew2v/upEcpAvX4oDkTcHu0mFO169wZE1xnk49kJTAnZwFfnLIuj2ypzcr0tMxXO65jZnMGIxTH9GoMAf0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOrL2GCdiqsjOSgYqzvzawEoVVUjVLYplsdIT5bGT64=;
 b=O9wqcqf28HpYRekh5gctYD0ScWnlxawpQi3Y8rF2eyitQo64D37BG9TuBDpVxAHwozSD8eXYSB9+jo3KuMsZSmzH4qE74YDhkTWJVWneOVp4B+m3pjN6AkWfh5FheLPGSQjyhjNZuexfUKo3hD1/6HfKLO9Czd0yc1JZuFxQzPHNOvPdBklAJ1DMCvzQqbIvHv85SV1WSJjikU3cXr2EFtQ8B3db6dqNWP1pTtU5QiC7x7cUi6+8LaUx0g2QyJEz3QcA/VWSzkGf5Y/Oz+srjkBZFH87fPfiPqvDQ++Sw8tBlnL9xOgrQ0QNhWpodcyjZoJirv3bO2TUpRkGKQsncg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOrL2GCdiqsjOSgYqzvzawEoVVUjVLYplsdIT5bGT64=;
 b=pzyvgROu0+0vgEo8MiBZBSB1sPiKoBRLC51fX7zvFNaFtWO7cZ43mfKrUTRP4vUf/guQoTTLMOuOXDnCndOuqelsZX3XhtaOdtiY7mrW+8jok3nOtKLI3I+zdmE3coXmD9d2dv6hCjgGVMcFIrDgjk7rlQDrNVQ79Pg/2tkqurw=
Received: from CYXPR03CA0022.namprd03.prod.outlook.com (2603:10b6:930:d0::20)
 by DS0PR12MB8574.namprd12.prod.outlook.com (2603:10b6:8:166::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:24:22 +0000
Received: from CY4PEPF0000E9D5.namprd05.prod.outlook.com
 (2603:10b6:930:d0:cafe::5a) by CYXPR03CA0022.outlook.office365.com
 (2603:10b6:930:d0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22 via Frontend
 Transport; Sat, 30 Dec 2023 17:24:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D5.mail.protection.outlook.com (10.167.241.76) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:24:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:24:21 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 09/35] KVM: x86: Determine shared/private faults based on vm_type
Date: Sat, 30 Dec 2023 11:23:25 -0600
Message-ID: <20231230172351.574091-10-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D5:EE_|DS0PR12MB8574:EE_
X-MS-Office365-Filtering-Correlation-Id: 069531c0-836f-4876-78b4-08dc095c2991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HHZkHJtWy9eftiChidWJoCGbpFV31Q0tDY/Wq93XA32+E451z/HHgCB596/Q0B3qllGjqkc+4n+PLYgFAphGEDXN4gGrtR32bJlubQ9QjZa2MT7sEePdXHXGQLgkSYpDI58jBkwrI/QMjOEP/tRFygSXC4vzbrtm9jB3OhfvHHR+04lQqSZ6b6vc/tlLNIsZif9x+7PR4qhxx4qEyOlRVkeKxUpCAdH9a8JSonWpZsOOchfTyrDzjPIE1VCzMkEWycBNLOGm19bpXAtDaNT86WWSMLjMtZfH3dF+MfqdKHgMJpICIaDZwpAEv79sCzTV2gaERL9zW8bGIdQFNW2//TBwJomogiG6ULzDHzlLqDqvUurHXXA3SP1pQzbS/gb9pkLFgErn8/dtQEnGu+z/yL/P24lNBKme/mn1xLjbNuw/e4m/Lqfc+xB0Xgvj5LVqarkPeLXlJGvo0t2glRrr6XSDxw5q8DbplH/Z4utOHjl64ziF2E2yNMdy9yB6pe+ldA7DwAVx6Mp1H+PFp57/PORml/o7/iw5aR8MnApY1i/bnz1RyR08y463mfZ4C2FieblaNVtsydOXmL5gEpWZ4Pl3BvSW8G0DjDiCY/jv6Zoy4TGCZVD+AaEphe6X4ml2OrtF4CTg2GM2yvNEPizCnmxRsJFbiAHniMHyfeZ4HdSQuR7mf3rpaCdifFXJxxkGIOSObx642pLwn4jEm/PtGK3Z82LL7A9KBg4MDok/PleASJeiKhwSc2PvPQxRMemjnXv05WOuNE9a8JAnvMoL0A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(230922051799003)(64100799003)(82310400011)(186009)(1800799012)(451199024)(40470700004)(46966006)(36840700001)(40460700003)(40480700001)(66899024)(16526019)(426003)(336012)(26005)(83380400001)(1076003)(86362001)(81166007)(36756003)(356005)(82740400003)(47076005)(4326008)(7406005)(44832011)(7416002)(5660300002)(2616005)(36860700001)(54906003)(70206006)(70586007)(8936002)(8676002)(316002)(6916009)(2906002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:24:21.7714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 069531c0-836f-4876-78b4-08dc095c2991
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8574

For KVM_X86_SNP_VM, only the PFERR_GUEST_ENC_MASK flag is needed to
determine with an #NPF is due to a private/shared access by the guest.
Implement that handling here. Also add handling needed to deal with
SNP guests which in some cases will make MMIO accesses with the
encryption bit.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/mmu/mmu.c          | 12 ++++++++++--
 arch/x86/kvm/mmu/mmu_internal.h | 20 +++++++++++++++++++-
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d3fbfe0686a0..61213f6648a1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4331,6 +4331,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
+	bool private_fault = fault->is_private;
 	bool async;
 
 	/*
@@ -4360,12 +4361,19 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+	/*
+	 * In some cases SNP guests will make MMIO accesses with the encryption
+	 * bit set. Handle these via the normal MMIO fault path.
+	 */
+	if (!slot && private_fault && kvm_is_vm_type(vcpu->kvm, KVM_X86_SNP_VM))
+		private_fault = false;
+
+	if (private_fault != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
 
-	if (fault->is_private)
+	if (private_fault)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
 	async = false;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 21f55e8b4dc6..e519dd363c28 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -251,6 +251,24 @@ struct kvm_page_fault {
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
+static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err)
+{
+	bool private_fault = false;
+
+	if (kvm_is_vm_type(kvm, KVM_X86_SNP_VM)) {
+		private_fault = !!(err & PFERR_GUEST_ENC_MASK);
+	} else if (kvm_is_vm_type(kvm, KVM_X86_SW_PROTECTED_VM)) {
+		/*
+		 * This handling is for gmem self-tests and guests that treat
+		 * userspace as the authority on whether a fault should be
+		 * private or not.
+		 */
+		private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
+	}
+
+	return private_fault;
+}
+
 /*
  * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
  * and of course kvm_mmu_do_page_fault().
@@ -298,7 +316,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
+		.is_private = kvm_mmu_fault_is_private(vcpu->kvm, cr2_or_gpa, err),
 	};
 	int r;
 
-- 
2.25.1


