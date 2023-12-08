Return-Path: <kvm+bounces-3931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4371980A99E
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3CAF1F210AC
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 16:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E57374DF;
	Fri,  8 Dec 2023 16:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nph78fm3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4370F1987;
	Fri,  8 Dec 2023 08:47:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VucQ5tsVzN7tqAG2OKRU5CmTQeoS5YZ2o1ToCQPqu0zUTg2/7Z1U0dm9Ky+ZWrpnP5DPMOPshDhn3WCpKpi2nkQW6FUa+p8Tcu5AiJSGRPfnGjFgw6Zq1Av2+IuGuVtUBfxCftJGHfmBdL/WcwoLAYPuRjo4VllIHcqhkuGNaZY6uUoWCtbSm0BBy181grgPKhf5UXjh6iBMXLKZ346oja7hnq1RGv+D/HwhvbKiM2GHIG5TfMND/edwIZEhuN8fSEb8yLa3uWI+ACxZD4EABI4eabYDzL6eD4TptnIXF108D3CPauKWXvKANhIy+qm4ZWJlqvHip45/DoNkTjJ0hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aav2rTXa8CsCjyZV1i39gvzkuTJtqAHCD2LwhQac+xY=;
 b=UkEcyxaXdZgibpwxOoVqA9yp/Cqfs1zqll4TdJL2Mnz23yklIzsQ/4xiN12W4x5t6Djt3XPVUw1delCNLmCgwAV34dN+9NF7RGEe1Tg4b2/ZfrpOve6dlqaS8aCsoumO7ZabQd3NAZgkDCR2bszr4k1ad5MywdJ7u+ZsKqNvNEwlwE1HWK3vKVCggBfH/v/aUbgFx89XzaKb/NqRuqZVAq8DI09uwkkP18ivUXW5iS9bjgz5ynapl9/Sc4FJsYB4shkqEqzH2ynD0+SJRN9EF9Ovt/2Otknr8JVVrWicHj4r3wGlhI/X+4OkhC+Rx9s7cTfYEjBP9Vsfhuyp+OCyuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aav2rTXa8CsCjyZV1i39gvzkuTJtqAHCD2LwhQac+xY=;
 b=nph78fm3cdD2T6vKhfwhV+HlK0TIaNndRWnemHwruwpiLvQR+A5lWRo1DNyzpTvLBSS7DAuPIEf76AZ+wo3wM8Vhy7tF+lhfDh1l26Hwbwkkd6lJ5+b/1bwvMDA6pnB+3J0Ji4LwOv5l6BoGBza6cd5hs19h8OwbW15DMUDQIeT4mlkUpDIqNaL09slTlBwHfrAhrns0GxrsynAvTjsJyIqRwfmzLrk9jqCWLilfrXejhsyMXTMveSjzlcrgjdsz0G/ErQGBBLyy25AV61iGhV3aENZbfatyR9gpc3P3VOduYEOwP02ukAr8ZDHGeyKc+HrAD7fLUI6OLcA1WQ4BhA==
Received: from SJ0PR05CA0037.namprd05.prod.outlook.com (2603:10b6:a03:33f::12)
 by BY5PR12MB4290.namprd12.prod.outlook.com (2603:10b6:a03:20e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Fri, 8 Dec
 2023 16:47:46 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:33f:cafe::fd) by SJ0PR05CA0037.outlook.office365.com
 (2603:10b6:a03:33f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.10 via Frontend
 Transport; Fri, 8 Dec 2023 16:47:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Fri, 8 Dec 2023 16:47:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 8 Dec 2023
 08:47:27 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 8 Dec 2023
 08:47:27 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Fri, 8 Dec 2023 08:47:19 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <gshan@redhat.com>, <linux-mm@kvack.org>,
	<lpieralisi@kernel.org>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<mochs@nvidia.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 1/2] kvm: arm64: introduce new flag for non-cacheable IO memory
Date: Fri, 8 Dec 2023 22:17:08 +0530
Message-ID: <20231208164709.23101-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231208164709.23101-1-ankita@nvidia.com>
References: <20231208164709.23101-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|BY5PR12MB4290:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dce19df-0f6c-4579-6aa3-08dbf80d67a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	81aFlsgEb09PvNF37B5mSazu2R9eDJI3IlZ9AKXDRUX5AGFx+f8EAIkVWgocNhcEVzRM59Esc7hL3dvNfuhXSg8BeZZMwxjS418oTa86IBXlUJIHwNioksDAZgsCdyfizpjo58M+VSZyPHeN1ZjKCH1HRbHMo7GlUDuCb9MxEWKHn46EGY1gfVVTn/jpk1MvFIM4qX5pIWwJ38mDFPUPoej1OTtOzpXdSDVGOvul4N+ZKDsI8i2R9LRxzMv1F5a+DAVvKZoM5dX77CLvEeN52j/fnltq1sG5NNH9I0//8AHA0qut6Wq/6newcNdLWzPX+fTwNcoKIobg4RrYYGSIZdD4mRDfME/0cT9C0bFL4EjUkWpW1OHD9cqLDnvI85f0E/gJjNjlwL91NpSx2YuSHaTTJCiMJxzJo4jrXmBhwtumdgvPM1Ot5PJLxh/DE6iBop1/HP9DQDu7FBkh84afJuTFRrMhs8ummWl6eLaH0jnE/rxq1Z6NjTaDNppGkf6X2CYHIuFKfQhoCE8EezSRw96N0i+FJjq5wmPJE6sqobarnuF8VaIkwjtwuW5+pbk8umIpRVeIl/srCSNgHhIqjmJffXwcYBDhKy1/5IeWZhzO033oVYVEbNW6HAnvnxP731/cUFefqA3AtThLz0lsWGhT8EhXtQ0qOmb72i75W4vp/KOoDMm0YCKjG0YbAJcULsWv2DmnUy+yqXUQlPe+FcfPa7G3RUgabjy6n1W8ilvqwRvCdG4RWO3fg0O6QUoeOy8qnqMg5BUq8LS24EWPJIF9VF8YFWGFZ230JER8TbpvjDpalYJF5J1baRZt80+V
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(396003)(376002)(346002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(82310400011)(36840700001)(46966006)(40470700004)(47076005)(40460700003)(4326008)(110136005)(41300700001)(70586007)(478600001)(54906003)(316002)(36756003)(86362001)(8936002)(8676002)(70206006)(19627235002)(2616005)(921008)(2906002)(2876002)(5660300002)(7416002)(7636003)(356005)(1076003)(7696005)(36860700001)(82740400003)(83380400001)(6666004)(426003)(336012)(26005)(40480700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 16:47:45.8480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dce19df-0f6c-4579-6aa3-08dbf80d67a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4290

From: Ankit Agrawal <ankita@nvidia.com>

For various reasons described in the cover letter, and primarily to
allow VM get IO memory with NORMALNC properties, it is desired
to relax the KVM stage 2 device memory attributes from DEVICE_nGnRE
to NormalNC. So set S2 PTE for IO memory as NORMAL_NC.

A Normal-NC flag is not present today. So add a new kvm_pgtable_prot
(KVM_PGTABLE_PROT_NORMAL_NC) flag for it, along with its
corresponding PTE value 0x5 (0b101) determined from [1].

Lastly, adapt the stage2 PTE property setter function
(stage2_set_prot_attr) to handle the NormalNC attribute.

[1] section D8.5.5 of DDI0487J_a_a-profile_architecture_reference_manual.pdf

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 11 +++++++++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index cfdf40f734b1..19278dfe7978 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -197,6 +197,7 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
+ * @KVM_PGTABLE_PROT_NORMAL_NC:	Normal noncacheable attributes.
  * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
  * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
  * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
@@ -208,6 +209,7 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_R			= BIT(2),
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
+	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
 
 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index fde4186cc387..c247e5f29d5a 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -147,6 +147,7 @@
  * Memory types for Stage-2 translation
  */
 #define MT_S2_NORMAL		0xf
+#define MT_S2_NORMAL_NC		0x5
 #define MT_S2_DEVICE_nGnRE	0x1
 
 /*
@@ -154,6 +155,7 @@
  * Stage-2 enforces Normal-WB and Device-nGnRE
  */
 #define MT_S2_FWB_NORMAL	6
+#define MT_S2_FWB_NORMAL_NC	5
 #define MT_S2_FWB_DEVICE_nGnRE	1
 
 #ifdef CONFIG_ARM64_4K_PAGES
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c651df904fe3..d4835d553c61 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -718,10 +718,17 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 				kvm_pte_t *ptep)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
-	kvm_pte_t attr = device ? KVM_S2_MEMATTR(pgt, DEVICE_nGnRE) :
-			    KVM_S2_MEMATTR(pgt, NORMAL);
+	bool normal_nc = prot & KVM_PGTABLE_PROT_NORMAL_NC;
+	kvm_pte_t attr;
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
 
+	if (device)
+		attr = KVM_S2_MEMATTR(pgt, DEVICE_nGnRE);
+	else if (normal_nc)
+		attr = KVM_S2_MEMATTR(pgt, NORMAL_NC);
+	else
+		attr = KVM_S2_MEMATTR(pgt, NORMAL);
+
 	if (!(prot & KVM_PGTABLE_PROT_X))
 		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 	else if (device)
-- 
2.17.1


