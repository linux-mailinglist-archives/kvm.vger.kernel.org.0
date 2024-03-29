Return-Path: <kvm+bounces-13108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A37CE892616
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 22:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3087F1F2299F
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 21:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B571913B5AE;
	Fri, 29 Mar 2024 21:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YaejfdVx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FAB13C3D3
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 21:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747798; cv=fail; b=sUq4TDWAeVqR4bmNMBSA8tozQ25gva53JChyDj2NLG2LdaB5nK8wGqbZXZqekg+cDpaVHlSjaBxNqLXtMX7LUa/re4g4eKZ+WoP+cLw1yaRzxFaW7Xn7h5ZvrUbqVta3zxMova3hmPCnWQmWUGnGCy0lkvObuc6CHNDgT7IyaJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747798; c=relaxed/simple;
	bh=pxJWsUH0LYl+HBVjpNCC1IBh/lredb2muB4U900OwK0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a9yAf1fnLjdStkK58n3DpnV+J3lMUekMaWQ6fYE2hsgISJBvHTBmWM8bDE4vl5UWRb912mudM0jEl4I9QQFkub8eC7xkIgOmo5yLotyMau+9xVvazXvljP2BGPivLfsgm9yasP2Q4BA3aK2yQIVgy3xVqX6adPIWekKOabUHTTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YaejfdVx; arc=fail smtp.client-ip=40.107.243.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqmCYWU4/RlXJ8RYU2eaV2JyNbSLqQhLSUSNcqPzXvhmKgLKaTaYsONsp8sQOd3S0m852q/oj7/09WVD/VIshPed7taEZ1hDweJcCpSN8dqPTIgl2BRrApL6Fp46FC2lpjiPrXfnXoxioxPWADxOtwTOUogr/5Ldzti3KpXxIbMV4ahK02j+2NqHViVwsGy6rzns/QucCiPtf/hJ3mO86s6nEssItXKebmMIRKubHNp4EQgavoc9sHYne/M8/e9zgMY9P5BZOLY7mCFR4vgsScQe+FtKXlke3tZbxMwrgcdJoQmFROvKSAsrW5ojVuZM6MNp5WaNM/r/vRGllApCiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugJ9I0m9t7jZi5D7ZCKz+s5HBr61uhs2MgrhZhxvsMk=;
 b=oAqdDUm9R/2tRsNmyGbPpPT6N5JaaQNY/RAFc/8UJNCJ3trlX4NvP7JEAQ5d5dnXitaqsNtE77DAA5LTrqQMLmOKPPOaToz9q5pcgdoV09eV0eP6xug0Mqztnx4GGjujVuHISpOdIRwsMoKc2QJYG3B6LzRuzl1i8KP0xMEsedMRUVMDQj+/4kfM4tnnkFr4tB0tannJHlgbw26fMuHJDMv9v+r3As4R3ffDaHLS0i1EePHwSQ4/flxUBAJSSuMexXNbDPKwbhgw4LJL1nMLudICRmlmjE7+0CrPCJKHShZ3uhiFIJVrxhxzDAd/jP1kESwUicM9vxCsaTOhaddH1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugJ9I0m9t7jZi5D7ZCKz+s5HBr61uhs2MgrhZhxvsMk=;
 b=YaejfdVxDpCZKRZKcPstCocOnPuWu13gJvC9R6CP1LpjZd4FygrTYjPdIn893XSzVD3FRq79AOJcfhVisLWzco7OR8PrSpylfLJkzU6ozXjHbf2VL4nRSx2Icrw4IEiKtS/jRoBBj5pUfT7hsHBESPjaihbLNMr4paeVwAUQEWI=
Received: from SJ0PR05CA0028.namprd05.prod.outlook.com (2603:10b6:a03:33b::33)
 by CH2PR12MB4117.namprd12.prod.outlook.com (2603:10b6:610:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 21:29:55 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::1c) by SJ0PR05CA0028.outlook.office365.com
 (2603:10b6:a03:33b::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.16 via Frontend
 Transport; Fri, 29 Mar 2024 21:29:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 21:29:54 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 16:29:53 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, Sean
 Christopherson <seanjc@google.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, Binbin
 Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH gmem 3/6] KVM: x86: Pass private/shared fault indicator to gmem_validate_fault
Date: Fri, 29 Mar 2024 16:24:41 -0500
Message-ID: <20240329212444.395559-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329212444.395559-1-michael.roth@amd.com>
References: <20240329212444.395559-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|CH2PR12MB4117:EE_
X-MS-Office365-Filtering-Correlation-Id: 1856f6a1-b056-423f-dcb4-08dc50376021
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	te47BAQwhc1soyCg0Hoh00aBleZuLAv9dbZGyFvPjcnnsH/rTLjWom5OPMxCyIpXReEl9MTr7dc76qpMsuIZBvRqEDM+xoYjGphZ09BCRg/iqtaXOJIRqTvI/LXCHUvPnQU8B6oPeSOIBu1dNpcgi9nrI/J3Q3lR14HnvavpKnUqTfwvA6seajAYzzbXqOf0GahOI5ik4QGXN7asIJV9yOjHfZpN80rFshgrzp6ooqOimc9NFutfUdzjmfSyQw17DotcMI++6rbmpNSqRiafDcsfo4KL7zaPjR5AAJhnyiSrJkDUsBhz7I+Ptq2Awhn1jUKUUQyBWoPE/8Cmy3ungIRVKc4wjjlJlmBvRV9HIJ2TXcVpZQ0wFl2gtIlQ8NLCA4equ37Ct4RQkUvktOl+msZ7hBONw5y/iRO3ZJQUDWZbUQSQQgWp27nWw9s9Wh0bCstFxLfx2FVIY5M6y7WpVrimJ+jsLvkzTGGEdONp5TnQKAby3n3CyKQIEqrdJzFBoLVaU44/dBXDtbvGWBmksfaCQ/B/EcSxggmlM3n3VTlIQhOp9jqVpuq4obFz8gifQLPQF0s5OXANY0pFKNeKmJdd55YDWfFNDOCdSTAWotlZ8hHs+WKU8QAlU5lEd0a6UYPkoNqsCxS8y8goXixMOftD8jDOhxyc4L3EW7eYEqZTf3H9GyEzbV7eZ6TcOpmwC8Ecd2nJotHKcepFExamZw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 21:29:54.4773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1856f6a1-b056-423f-dcb4-08dc50376021
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4117

TDX has use for a similar interface, but in that case it needs an
indication of whether or not the fault was private. Go ahead and plumb
that information through.

Link: https://lore.kernel.org/lkml/35bc4582-8a03-413b-be0e-4cc419715772@linux.intel.com/
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/mmu/mmu.c          | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16fff18ef2e5..90dc0ae9311a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1815,7 +1815,8 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*gmem_validate_fault)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
+	int (*gmem_validate_fault)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
+				   u8 *max_level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8d7ee18fe524..0049d49aa913 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4340,7 +4340,8 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
 
 	r = static_call(kvm_x86_gmem_validate_fault)(vcpu->kvm, fault->pfn,
-						     fault->gfn, &fault->max_level);
+						     fault->gfn, fault->is_private,
+						     &fault->max_level);
 	if (r) {
 		kvm_release_pfn_clean(fault->pfn);
 		return r;
-- 
2.25.1


