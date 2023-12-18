Return-Path: <kvm+bounces-4698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B77F0816963
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBFFA1C218EA
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 09:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00DE211706;
	Mon, 18 Dec 2023 09:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a+jMdB4z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A968A11197;
	Mon, 18 Dec 2023 09:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ap3lA2dKh9Gstrfm9m5Mr0w6PPzafbsLzKhnPCjjIzdbIr1gcMjj5GI+OBYF6rNe10vkFfoNjutdJ310s3aADVG96Pmhp1bM0a0p1zrYtgt4TrXWhDzD7Lkqn3pZVEnsUA6Fpf+1K2rGg/3DGC0beyVi34tFCn+upZVPgxPT2reo6k1APSplzL8qQp0bJaugRFieXLzWukXIEf82D5PX7jhBKavG7vTVnzhbcrk9gsDYcguXGd13AZ8KwKZmd8UWgKkNQVOMuJ3q9ZGMU0v97DQdwkFHB7n456PWYjaj0EqFYe4FBpSz0+dvGZhGeQhqu04c1EdPd4XiAuPTdMxKUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Q6+cppTzXQ6+dca78fLTIGwICeCojPHJ5xk8VX6mVg=;
 b=JsAgiWQuVJrI6aKPTjKxdGg5/ULbUSJvdkR3mNCan3dmdgrSerjl++/vsqbZzh8ro1r77M9A+e0dJWHggfSg1Zo0rY4iTv8V14cRTNTzjpWRosrHpoHhz8OHEtIAUBpMFq6ZyDW723GMxGnL5x9y2n3HKcKSewwqUDymy9zSwfC7BfcqWFtlCrb9uDbxlEyEDmOPDGQ4HC/5C+/+mOd1l38Zt/F/9aFrIhTJpb7EQpC0Y5QWvyv2h8Ft+u7P59etOmaIEjRDp/7RRusjL7WGquOFAlfuWShEiGfqp7Mzytujhfu99t1OdJPSjWb6ZPHYGjwryL5LSsceiu39mdN7hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Q6+cppTzXQ6+dca78fLTIGwICeCojPHJ5xk8VX6mVg=;
 b=a+jMdB4zsdaHs9QPkhK147SxRh1NlSSkqngXpvWjHX9ZMzE+ERQQMT5bBVNmIMmhu+Ycea2xGOErMOthnixRioJAT9Vlcg7A/LItqS+xOdKRAMjVW/cX9uhn/p/uVIm4alCuUVOFsoEEOGMT48munnfV+cHo6cbe/qmCNMVTHSIfdYfhi90fvQK5aP/odkkjDjmpp4EoBIaIjef7CzBDjCgz78wsPDpZP60eUaYcRKkFe/l9UxHxDG1LlpsjEqyT69YTe/kaUDx4yLNocEsJCtRCSJ5GDbwI5viZAP9xLsAMH7prUgCnil6mwRaigipCuJCKIL9yVO91LPac8wBkdw==
Received: from SN1PR12CA0097.namprd12.prod.outlook.com (2603:10b6:802:21::32)
 by MW3PR12MB4410.namprd12.prod.outlook.com (2603:10b6:303:5b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Mon, 18 Dec
 2023 09:07:54 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:802:21:cafe::31) by SN1PR12CA0097.outlook.office365.com
 (2603:10b6:802:21::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Mon, 18 Dec 2023 09:07:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Mon, 18 Dec 2023 09:07:54 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 01:07:41 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 01:07:39 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 18 Dec 2023 01:07:30 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <gshan@redhat.com>, <mochs@nvidia.com>,
	<lpieralisi@kernel.org>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<linux-mm@kvack.org>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 1/3] kvm: arm64: introduce new flag for non-cacheable IO memory
Date: Mon, 18 Dec 2023 14:37:17 +0530
Message-ID: <20231218090719.22250-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231218090719.22250-1-ankita@nvidia.com>
References: <20231218090719.22250-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|MW3PR12MB4410:EE_
X-MS-Office365-Filtering-Correlation-Id: 2426bba0-971e-46d6-1851-08dbffa8d1ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yuoZ6c0t4VOS62FPu8+vbtDD9HoBy5nPdB82kr0WVHCWEI1JysWAFhcJ1Hl+CTfxk7Qtnxq6cqBy4Li7qlQVomGKAC4zzM/zpuXJlxM22jSQE8U5BtJmycebFxBF9oMXAtq00rLoCD8ff+f1vsn4xm5yZb74BhSBvdn/thZQW9TfC8X63av7DppXGr6uTbqJ3HmsDNaLNW+ZUUSDsQQ5HnkJvt1l4uNOsRZJ3HQDCslJd8TGN736c1yEUL+s+IAdIyN/4+Wphnuc9G132PVIJhLXpwWJW/C45XxvWHDKum3x1IpuaZYsM7cEjMpgkQE70cc2vmIM6T5FBBB60zanWQ6nRyjp6v8j0RrnlxpzRc081kBp3F+dDcfuSzELyVtJoY1vn+B/5WFsvNSEwksmP6eVslhFWbc6sNEjihfljPMHLJRWdL1HUwLHF+DUbp9F8aBajU47C+etQVXWMo32s50RYrrMOmSk2Od7DSREbvJntPUqUPOyk1x6mfGdpI0SjZPmyww62J9syMR7z8jLhas2v/9htcA1PYKG1o28AKnD3K5/0AXie+0A/SPlxmwcFPsu1suSHusHofYzGQIuzBOufTfzp+BjiDVRU58zqfq6aMlQV2LDNRU74DFY2ZIccObtjssDKbGKI18+l0rzcaQVE0CGN7qcZcLM5YxmorB5Gy02/IOxhRr91tyoTnXuSsDBb0PYbyh5ccyDLt/ZxPK1nFsqHQI9UgI+lUilWI6z7NCeSdLH+uZyFlp/JNewjz+EnxooLm51qaksxumOsSjtDsjBeK9f8WLgStiTkUMyYlwtaxkLioCml19+gAm8
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(136003)(396003)(230922051799003)(451199024)(1800799012)(82310400011)(64100799003)(186009)(40470700004)(46966006)(36840700001)(336012)(1076003)(2616005)(26005)(19627235002)(6666004)(426003)(7696005)(36860700001)(83380400001)(47076005)(5660300002)(478600001)(2876002)(2906002)(7416002)(8676002)(8936002)(4326008)(110136005)(41300700001)(316002)(70206006)(54906003)(70586007)(7636003)(356005)(82740400003)(921008)(86362001)(36756003)(40480700001)(40460700003)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2023 09:07:54.3346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2426bba0-971e-46d6-1851-08dbffa8d1ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4410

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
 arch/arm64/kvm/hyp/pgtable.c         | 13 +++++++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

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
index c651df904fe3..0fff079a0ef3 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -718,10 +718,19 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 				kvm_pte_t *ptep)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
-	kvm_pte_t attr = device ? KVM_S2_MEMATTR(pgt, DEVICE_nGnRE) :
-			    KVM_S2_MEMATTR(pgt, NORMAL);
+	bool normal_nc = prot & KVM_PGTABLE_PROT_NORMAL_NC;
+	kvm_pte_t attr;
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
 
+	WARN_ON_ONCE(device && normal_nc);
+
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


