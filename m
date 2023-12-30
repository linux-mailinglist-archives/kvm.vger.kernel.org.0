Return-Path: <kvm+bounces-5386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 997A78207D4
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD9971C21A1C
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D96CC2E3;
	Sat, 30 Dec 2023 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BeB4lGRK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF2614A8A;
	Sat, 30 Dec 2023 17:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TebiAlwJsVDdqbKTktBOCYYfWFL5uo/W3TjUVbi1IH/FekrTupKkhInBcYLbAcG2JVRrRxekOflFlLNKmJxygAbzWPTS+CPqTTGs2hqUdjNrCGGPwU58ukBB44da8V98B1UqYXByszBxELMa9H0CHfWs4Iq77m8jkjM7ugNMpG7TBDdFrDrmlwJo9oN5NHVHyuZWX4QuoruZHpUG8BhqwpOKj1u0/qPw225XGK5HX+KgaFfPG2uKneB9deHf+x7AmwIsdPBJmwA2NE1rVp6IB5tyFc6Zm3zpoHFW8DX7pvBU0hZnEI5SLZ//B16jJr8wMWm9qh2DRxRnpl/HqQrVVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTyI3sNoMDHNrgGrZG7JKocHTvFM31hLve+xo3xbn24=;
 b=HL0vt2SWayR8n1hppMXWWnXCljnx5ognMJhRPbSqW6/4cPMF9oPDOtnXYrSVUixOkwi0vygXPNkF00lJt/K0PT1GWlRlGFfgWAlGeFF6MT69vaRQYhwsbeCyDLfTo3lP5iIDqYXd/9CQzItYzw3W1PpcZGcg1eEZrteLK9oSmUlXT6/RIroraqrl23xdME0tY90G285GKhuwdnqbktBxN0iXZ8d65lpIRYMMXFwVflhvEGk3KrqRmf3rAMv2gIUG+oIfaScR4DsaGdietEf2MKevP8XwsP6d/K5ZdOUyMfJe1+KdN82uooAUprEY3Ca2zsAcDKORZsF+uzeJoI70xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTyI3sNoMDHNrgGrZG7JKocHTvFM31hLve+xo3xbn24=;
 b=BeB4lGRKEY4q6gCrDLk7pHGXLKkR57cRhjfBfe3Y2OJej8b4cU6kw10W4lc5+cE5lxgu+y3MKHdftk0dkl4Z7am4V0Dmo3DM6pfzx8h1IPWhiDyujT9pMzydhgu8Tya/iGYLMPa8uStDo7pP/wGAkcuU5j5GPxSkUUMmQ+26780=
Received: from SJ0PR13CA0129.namprd13.prod.outlook.com (2603:10b6:a03:2c6::14)
 by PH7PR12MB7185.namprd12.prod.outlook.com (2603:10b6:510:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:29:57 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::9e) by SJ0PR13CA0129.outlook.office365.com
 (2603:10b6:a03:2c6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.7 via Frontend
 Transport; Sat, 30 Dec 2023 17:29:56 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:29:55 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:29:54 -0600
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
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v11 23/35] KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
Date: Sat, 30 Dec 2023 11:23:39 -0600
Message-ID: <20231230172351.574091-24-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|PH7PR12MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: e1897acd-5567-4597-7990-08dc095cf064
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	n/J6/O3prvEtA8BdqoU7sruh3+mKNS32jNtrIMxxmDrBmi6iPm3mHoKvFO1PaJTF+lRLcWnuKDCw3IaQ0a4SyPXr456R36SqbUYyRxWfpo3Xs8N39gTeF0TCubLZ0GVwUMIpOiNX7/4WKL07w+PKCuiXUk1pxCsaO70K5JfkzMakdrafii9E47aeW0y5kAMK5Y4IiPl5FT3i8OzG3qg4rNDFA5YEQxCpSctVVlQiQLnwEAb7cgN0gpdF3STXd7nJv1hkgaXXXBlWlUpwMxYAaXPCiUMPp2Ax/50S7mw/GLPTEXcc3Mf2crSCdahCJKTgDsrBv19mlLD1nTUx3peu/O5rQ+/CqarllVaHJ5ySMcRG9ae5MSwaP5uXOnWOwP57rwpHIXfz6BZNZa4/59s4b+a8l2LQnIDYQgoL++W600S8YWlox6opUxkHQPzp9Q7cGU10rmSS3etbSdfwD8JcMio6XdXerMsN8aiH4A4U10VmNPuecb1GOcnc8bgLyTmJv6TS9O3ixUTh3j+mKuFI/yb0VCT5i1oFyYoT+rKddLjmulL9nknu8gRbNFSo9jR+DXjqiXRo+rfF4KOeFGT/bFT+WBFU85EY3h+H0NU0NHAX0sgXoaltU8p1uE8LrAU4SBasp6K0xMqGQjP8div2XDsfALRYT/JyKPHNgntiZtaQ3t7x40z2psgcRFhdkLi5C/ig9M0CXQ8xg5IaYa/O0c5JSLTRqzgsjLtHKUjp4oYNEm7xp0mtPrYYfNU3+scNuQhJzljDCxnP0UKpdxJH3w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(64100799003)(186009)(82310400011)(451199024)(1800799012)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(336012)(63370400001)(2616005)(63350400001)(16526019)(83380400001)(1076003)(26005)(426003)(86362001)(81166007)(36756003)(82740400003)(356005)(47076005)(4326008)(44832011)(7406005)(5660300002)(7416002)(6666004)(36860700001)(54906003)(8936002)(8676002)(70206006)(70586007)(316002)(6916009)(2906002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:29:55.3119
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1897acd-5567-4597-7990-08dc095cf064
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7185

From: Brijesh Singh <brijesh.singh@amd.com>

While resolving the RMP page fault, there may be cases where the page
level between the RMP entry and TDP does not match and the 2M RMP entry
must be split into 4K RMP entries. Or a 2M TDP page need to be broken
into multiple of 4K pages.

To keep the RMP and TDP page level in sync, zap the gfn range after
splitting the pages in the RMP entry. The zap should force the TDP to
gets rebuilt with the new page level.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu.h              | 2 --
 arch/x86/kvm/mmu/mmu.c          | 1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 843695217b4b..3fdcbb1da856 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1923,6 +1923,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 60f21bb4c27b..df4d2c137a67 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -252,8 +252,6 @@ static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
 	return __kvm_mmu_honors_guest_mtrrs(kvm_arch_has_noncoherent_dma(kvm));
 }
 
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 61213f6648a1..1882096fba3e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6702,6 +6702,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 					   const struct kvm_memory_slot *slot)
-- 
2.25.1


