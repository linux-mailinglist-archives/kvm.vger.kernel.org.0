Return-Path: <kvm+bounces-60654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A57D2BF5C3C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 12:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1522618C7CE3
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBD532D0C7;
	Tue, 21 Oct 2025 10:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BmHi3P+l"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012037.outbound.protection.outlook.com [40.107.209.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10C732C33C;
	Tue, 21 Oct 2025 10:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761042231; cv=fail; b=eFuoIwivRk6SupXkcoSUXdxHNWc6vViBnHiWE7yi9OeztNTzJyq4ElKTX7tyWqibr6MMjEs+5lE7AA2/CzmnFX2dNAdpE/TOK9QWwtZIGHpG6hHCJvjTC+85CjcTExgcY3w2yxjfDU8CPl97jYuXM3EYoIdspOFa/v6W4zjWhlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761042231; c=relaxed/simple;
	bh=I6eHbEUOsjWy0NUQ3iXObGoOMc0u6NqxcbABQmVBNjk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sypSEJYQSunVC0jr/K5ptWC6bKgy0JqYRuYFr9m/2XSBr0gR0J81A78LZiDH045k69KSde4qDV2F70geLWpCHhcbllOuyqQcR/q2UJxoHsPnbYcKvrTSJLziZ61OUIbHUMw+EUlBbB/nUwY3gt3WqzIhmEr/qNW3vqsVPhYqqRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BmHi3P+l; arc=fail smtp.client-ip=40.107.209.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gnVDNjCMW/pIs7cmVvtNhUlwRyKwhqMMV+LxnIMG76Aeyuw7x6LPsfK+TpAObGHdEtBT2i0sa5uCzh2uqi8TN3qIA61uzGP90wadZX0mBE64e1Wf2PT4TMZyn1ijpEZDQZruzOBpuN38LVKS+4TqiOunkKf32PTfd+NfYRGlRz2YKPESEXlTAZiNTnvGDF18HmiiMrQ1gh1hIqKRGCbF7TbOpRtI/tS4PskBOw/pkSF41/xvtqo+f9GBMp4NZUof3K+hhhu+HK4Zme/htlj85V85bya92T49jhoEo8fQj+yJRTi8RTYy96MDMw166svZiY9UVmzN0C1eM+sl6YrSHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2SxQC4Hxe45NI83ewkohGe/akTv/htK3BcU+R+0bpg=;
 b=guswvnZZqxuZzwmdFNYl2DWps5g/0WNJhUGF3nQDZMmitajdFd7FvLMUQSA64QGXZgNYgfLF01KYotgXg65YG7i8lrCLxyOBkgle3YW9LZyHkqMq/KgFfGAKgA6WG35W8ij+Mvd6UXkpmnXaj3KEYeZZZ+aQW8pOTkRC7oWLIrBvrCuNeP7egegfIA/dbZwR5HThUL2v/tNnExekG8u5Lb7TVRWmKTxe5dM63g/lABjvA50i2kUus2ezbUFRKrJY5elVYjQgcS4gCnxgkATfjes2zRMLMTYCxjy6Dpba4NiwFHuO2wT4/JGg/xDM++3NWoxkobjpFPJ2XCqrfEmpng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2SxQC4Hxe45NI83ewkohGe/akTv/htK3BcU+R+0bpg=;
 b=BmHi3P+lnA8Ui13SIL6afEw8H+dPKLN6IhSzcI3YhHWbcvP59q14qLz3x9tEIWN9kusaelfaXdhXLdGLe972blfd/CSCfU2RMfI5AwmxRzA350sWUyzqQUpt2BXJ9QlLxav5yW33UCrIZMqsSH+6rwVqgLBiSEeXPB9ApwQrPvWKhhEtSToQQlv6kjVtGh90HZqiNoQvRg9hkhyTGhu2RF25e11wgMMZba2FXuPqM3uK/NA6mytKOgeKlSzT8JG/wwWP9Q7nEmriou+u+/UIvzGL73gNmWbmCrPR86Rm8phm0gBNx21PIV6u68kPrAfbvBh2LR8W6iB+/7wy53suCg==
Received: from BY5PR04CA0023.namprd04.prod.outlook.com (2603:10b6:a03:1d0::33)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 10:23:44 +0000
Received: from SJ1PEPF000023CC.namprd02.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::dc) by BY5PR04CA0023.outlook.office365.com
 (2603:10b6:a03:1d0::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.16 via Frontend Transport; Tue,
 21 Oct 2025 10:23:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023CC.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 10:23:44 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 21 Oct
 2025 03:23:33 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 21 Oct 2025 03:23:32 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 21 Oct 2025 03:23:32 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 2/3] mm: Change ghes code to allow poison of non-struct pfn
Date: Tue, 21 Oct 2025 10:23:26 +0000
Message-ID: <20251021102327.199099-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251021102327.199099-1-ankita@nvidia.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CC:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ad25cbd-4a66-42d8-0389-08de108be9f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gi2VY4ILScew8ULc4Wg8CruOcv9G2X+fV11HxnV6GBmj5mpDyDp2+xoCqop4?=
 =?us-ascii?Q?FweSzlRjZRrNiYZKMdC7t/NOzymcUrdXAqWZG4FvtLsKM6bLB9bSjKWI8cDH?=
 =?us-ascii?Q?zwqlH0Bq0JiXoCvQt+htLF1hzvBLlaTnx9SkUYIKEr11P4f92iTMQeEZkLuO?=
 =?us-ascii?Q?Nm/k5MBt9hRzY5bdvDg2/bUaklJVZLX21fX9KpoLVk6ZCfTIG5sF10JNkx2d?=
 =?us-ascii?Q?8g2XzyWOP+1seayn/ontRx0ZxyHoZANcqK5nhEdUNawplpOTj+y0QaoBRvDs?=
 =?us-ascii?Q?NYENEjapk+QPozCjKgaTDF2UifRPHgdm0UJINTc2Ct5dLMuV89rh+N0wkjLx?=
 =?us-ascii?Q?yiDXKiIFMDlMzKECGoIg+GgH318BOHOek/zxW1cyUDLpgzQB4rNlYAqako1c?=
 =?us-ascii?Q?kaIO9oa69isWZTPQs/22GJ800H0Pw/uZVjQkbu0WMTmhm8ptJluaTqgPgXKM?=
 =?us-ascii?Q?FoaSeRd4cMAV8yq8AiNYz6Ec+OCLQgk7zam5EfFIcNE7Bfr/tcZ/ALeiQiMq?=
 =?us-ascii?Q?4fpIG3uX8hUsZMCWnuB3XlWfZMHI+xDq0G2UYnkhd6kP/YYdh99tqgOLOiY1?=
 =?us-ascii?Q?JGGrMcxghUmBA8zHLTSdq3c4Af4R1E+mw3vFW6V+bbhwhwTNLQuuD5ab5uAE?=
 =?us-ascii?Q?Mqm5eKcs0RMmrGiaqB8QHduIyl+R/PEUfsUv4MJ3o5VSmQ/Qjg8GMefq3/20?=
 =?us-ascii?Q?KWEB6Hb0cAgHkaBetGzx9w8YhZdmN37JY6TDZr6MaE5d+DE/IXyRZBeXbesx?=
 =?us-ascii?Q?dhhnXQ17s/BvMqr2h2TXnaGC8TIo9wlGdo0pamRLEQ+/Xpp3b5U7YC+L1EMh?=
 =?us-ascii?Q?etKucgDAIwrvRqSEvvKxloTV4kZt2OUL5TttBKtIEAdBowS9BlAUrmPSV7GA?=
 =?us-ascii?Q?rZYlek0s0BOkR/5rh2NFvnkbq8ICua1nc4pfufyfytvkOlbScW2adyESWyWJ?=
 =?us-ascii?Q?lKNsS8Nthn/FsjPzZ9DNr2NaSkM+NufVT+rHcsGwooaI4bbMdye8JPpMdjwG?=
 =?us-ascii?Q?nlLlV9s3N2fmCNfKHDeJU4wCk30ftEfRLpA8ZLEfkIZ7LTD5sSrrv+wKg0DF?=
 =?us-ascii?Q?nL00eMcAMW5nmgSF56l+rCy0Soiu8xZ2r1MRZI1mPNhDJtIwpfDdlntyuF+I?=
 =?us-ascii?Q?9YyEIDtYYktzyzi16gLHCf4lLWWFvEcfcNk9keLhyBk3j4kzU0P6qNZ9b2XP?=
 =?us-ascii?Q?iEL2CercUm/T14vzGlsJZ8y7e5XkV0EsjkiI3Zawc44DV86WoQ6KW7LbRFUx?=
 =?us-ascii?Q?iMWolNk6yJkn0+cQZ82uXvrUZX/gdPDmSDAOagFn5dEtl/9m4f7NUA9ndszQ?=
 =?us-ascii?Q?95JtaL7qo5Sm5zLsqNQV28GqU+qwwFuxUEKTjzlqeihFTspkyafctiPVTaI+?=
 =?us-ascii?Q?iO2vNvdwBQDsladgBeyeJI099HvH6nsGYROcpgP0gEvEU+g+o5+HDoiL6mIC?=
 =?us-ascii?Q?cT1my37gaQxzTC4rQblQ2eOomcSPqtcbdh4MhsC89VVfXWhm1WarGDjqfGH1?=
 =?us-ascii?Q?HhvWcNGvnqiEegHkKB/1AWZneobFDjsRJYX+OfOkzTrgOircj75Zw3ORHd/Y?=
 =?us-ascii?Q?6A8cPouSaCa6y6o2VlOYJawDAggvo4UMTLGTlEPj?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 10:23:44.4755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ad25cbd-4a66-42d8-0389-08de108be9f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

From: Ankit Agrawal <ankita@nvidia.com>

The GHES code allows calling of memory_failure() on the PFNs that pass the
pfn_valid() check. This contract is broken for the remapped PFNs which
fails the check and ghes_do_memory_failure() returns without triggering
memory_failure().

Update code to allow memory_failure() call on PFNs failing pfn_valid().

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/acpi/apei/ghes.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a0d54993edb3..bc4d0f2b3e9d 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -505,12 +505,6 @@ static bool ghes_do_memory_failure(u64 physical_addr, int flags)
 		return false;
 
 	pfn = PHYS_PFN(physical_addr);
-	if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
-		pr_warn_ratelimited(FW_WARN GHES_PFX
-		"Invalid address in generic error data: %#llx\n",
-		physical_addr);
-		return false;
-	}
 
 	if (flags == MF_ACTION_REQUIRED && current->mm) {
 		twcb = (void *)gen_pool_alloc(ghes_estatus_pool, sizeof(*twcb));
-- 
2.34.1


