Return-Path: <kvm+bounces-5379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD24D8207BD
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E09741C20EA7
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B91F505;
	Sat, 30 Dec 2023 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qu4wu6/h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91231FBFC;
	Sat, 30 Dec 2023 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHsB2kVokE22gXLa6/8Op4TJth3o8lXXY61hkyQpcShmEoL4ZwsTBG1AfpyW9QOpN64s5OZDK3gGPJB7S74OUpIodehFBHBXdTHgvJeTjpQOgBzeD5Sa/PiXJRQyQNVWqpvIrdgQFfdExE0T43RpNhjbEFStAT760kaFxkkw0I/h8Tbj09wBmklKGQ7ltzztRUFYm9ariGAReIB9kUvgxJ19V4t0CnIJ+ZKuIACcUvupkmgNZmJpV0l8HVWEL2363gA1UyBFoQcPBD8bpv4VLed522zdBYgs+zMC3qQqnEc1Q2fjCKdBm+6caSdqTmdOV9gXECjlQzVebXRRlMgQWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9z8vHHZKEWNfdYLlNVTWn/ZpwAECgJWqPcY/Sqgd8hQ=;
 b=XA1B5HYacBd+jb/KrQ+hCHX2tFZndDWrvnJtW2rvPqFhPSFHduk+ZU9Qn2s45Tx69TnWNt/KKOE+5e0KmS9qAQviOdwU9y1kGHXdwHilIXhXOac/JdwhBjXwLeg/qsaxPU95RylcicoA5nXAFgbOoDQGav5AEmYVJLhDOCfJMwZfDtuM3LFqkiPCkgiCAanrVM1qJ6EziKOveLSo4ZVXaS5uQ96uaDSqoYpZ+NvlLKL63Din1+W6pMcPqE+EVjpK9d6v+QjCdH9oDwg+kro53UaU4o2H/j5uWfBKU7Jo4WGQXwGFrD1GlokPX5l3eUhgOIkib63oDJRYvXwut10oNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9z8vHHZKEWNfdYLlNVTWn/ZpwAECgJWqPcY/Sqgd8hQ=;
 b=qu4wu6/hiQ+GgxNEsN6P3xInF9XMpt2FyRffJZxK9wLfeqwulYBa0al/J6uM8PJArwKrt8ZD2k1tKI+9f4Pf3AGIMSuDVCQPZL6/FP4eYYyOtaZRBot78k5g0jBFXE45AdA4GUQJIBp1IXRuqYfAOus11UvUAMoMsYiw2y4HsLI=
Received: from BL1PR13CA0004.namprd13.prod.outlook.com (2603:10b6:208:256::9)
 by CH3PR12MB9344.namprd12.prod.outlook.com (2603:10b6:610:1c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:27:29 +0000
Received: from MN1PEPF0000ECD5.namprd02.prod.outlook.com
 (2603:10b6:208:256:cafe::67) by BL1PR13CA0004.outlook.office365.com
 (2603:10b6:208:256::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.7 via Frontend
 Transport; Sat, 30 Dec 2023 17:27:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD5.mail.protection.outlook.com (10.167.242.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:27:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:27:28 -0600
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
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v11 17/35] KVM: Add HVA range operator
Date: Sat, 30 Dec 2023 11:23:33 -0600
Message-ID: <20231230172351.574091-18-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD5:EE_|CH3PR12MB9344:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f667561-f9e0-407e-84c9-08dc095c98fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Il1fX66Igd7UQV2zi0OBctrTz3fi2IzeaROdZc+E83pnZGzR/PGg+KGK9iNNuxYNSRFph5Kq9u07WLT2izCHSpbV9ImoTHH2Grb3Y9flxZf/xUGJnf95Bb+alJHnpCI/SIeWI8nTHNQZiZWPO4DpBpmV+lTJakWEVYlS/hj9GT1C5zjlgZ/2YN4Kw+ap1DdzUplQCAVP801Dp1M0cmmRbBiech0sGEg9kQD1Kfxt8XU1OjjmCfcMcxMnGji0PifIg3bIAoSv4B3JKy1xg0Pbwb8k695JCuSC7IAb5hQEggvkG4DQcY7a9Y0qNDOS/DBmEonVZvQP1Sxmj8UpYfX4PC0bKFonuQuCOhrP+fBrc4K/9dEy2w4Bg+vJl+R49/o15xBeidPfsk++kDR4VQyniOTxrGygVozKcGX24Ph8kKiN1Na0BXn4m//pprh0Tbz5oGvvF5abfLn6VGO0b4gpxFc2MSNYNYkZmNucEd+gaVDTctqPE2q5opMal6FnS+S4gd7UhBDBjsob/8ClR9EcpdUMkaQNmn1fX+OOIkbCZ6s5Lqc6QxIOCW5zFxLvtRdbPZ6Kko9md9mJdIPr7KQ5W+8jZ+IGT73bCQw9vx1bjYikPuDE0zFGQqMTWRe69s0SfhOXqRcRh5Zztbq2KylwIn/tGUwYDOIk5zDMKZ4m42RAjF9p0DPrDxYHRoGOg8eKGEiKfmPXFLlBt9wS1WwEc1Lpz03Jok5GqfhgQ9RMLWyPTYwQw/iwi5jFs/5Ku0vWOWq/P3YnD74FZ+BW9Cex0g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(396003)(346002)(230922051799003)(82310400011)(451199024)(186009)(1800799012)(64100799003)(46966006)(36840700001)(40470700004)(336012)(426003)(83380400001)(26005)(16526019)(1076003)(2616005)(47076005)(36860700001)(5660300002)(44832011)(8676002)(4326008)(41300700001)(8936002)(7406005)(7416002)(2906002)(478600001)(6666004)(316002)(6916009)(54906003)(70206006)(70586007)(36756003)(82740400003)(81166007)(86362001)(356005)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:27:28.7757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f667561-f9e0-407e-84c9-08dc095c98fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9344

From: Vishal Annapurve <vannapurve@google.com>

Introduce HVA range operator so that other KVM subsystems can operate on
HVA ranges.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
[mdr: minor checkpatch alignment fixups]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/kvm_host.h |  6 +++++
 virt/kvm/kvm_main.c      | 49 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a2a8331fbb94..bc3a468e97e3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1429,6 +1429,12 @@ void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_mmu_invalidate_end(struct kvm *kvm);
 bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 
+typedef int (*kvm_hva_range_op_t)(struct kvm *kvm,
+				struct kvm_gfn_range *range, void *data);
+
+int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
+			   unsigned long hva_end, kvm_hva_range_op_t handler, void *data);
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4fd0fb0044f5..03243a7ece08 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -667,6 +667,55 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	return r;
 }
 
+int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
+			   unsigned long hva_end, kvm_hva_range_op_t handler, void *data)
+{
+	int ret = 0;
+	struct kvm_gfn_range gfn_range;
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	int i, idx;
+
+	if (WARN_ON_ONCE(hva_end <= hva_start))
+		return -EINVAL;
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
+		struct interval_tree_node *node;
+
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot_in_hva_range(node, slots,
+						  hva_start, hva_end - 1) {
+			unsigned long start, end;
+
+			slot = container_of(node, struct kvm_memory_slot,
+					    hva_node[slots->node_idx]);
+			start = max(hva_start, slot->userspace_addr);
+			end = min(hva_end, slot->userspace_addr +
+						  (slot->npages << PAGE_SHIFT));
+
+			/*
+			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
+			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
+			 */
+			gfn_range.start = hva_to_gfn_memslot(start, slot);
+			gfn_range.end = hva_to_gfn_memslot(end + PAGE_SIZE - 1, slot);
+			gfn_range.slot = slot;
+
+			ret = handler(kvm, &gfn_range, data);
+			if (ret)
+				goto e_ret;
+		}
+	}
+
+e_ret:
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_do_hva_range_op);
+
 static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end,
-- 
2.25.1


