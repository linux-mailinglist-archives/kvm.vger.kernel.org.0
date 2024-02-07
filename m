Return-Path: <kvm+bounces-8281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3134884D327
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 21:48:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AA681F2413E
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 20:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5ED41292EE;
	Wed,  7 Feb 2024 20:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BEn+yU8K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583C41272D1;
	Wed,  7 Feb 2024 20:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707338866; cv=fail; b=Mkejk9GbgLe6MjP3jR/RxiUlPmdShSZoFc+KtaG1kGMOAYRjWqd4dzKoH0/jgSpu9li5t6AOUhtueX5RVwCIMiL9io6Hhs53MQwVfI/KYf8sgCStXAYqpXVgDpolIMEgWLaSwQPpVj0GxuOshu5u9r5Ltl9/FQf3oV+Rba9DbOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707338866; c=relaxed/simple;
	bh=55dy2c83+xt9o0osYiWHWAEAxUVquFPROrpeSYiURns=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ft6XYEqjj4VuP4mFMkB7jatHFdaCPVdZtUPL5i/wA8rAFUXX+95vBZC3xAHwAg2RhXQvzthYKK57nKn1GBgMgIUqNcdS3ufqcWUReb98R0UAO+B9t9pF15xXI3FvfvgT26iXOlmL6ic/w6bKbuD4PvLLAMnW5OR/TtEV9B5ZyK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BEn+yU8K; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zg/O1plNx+1jDbssV4eB2ATb8xv6FrfgkU7DFeDJDnkGlpNjqqhkOuU9mqcmsbTmeiIp4WtuRJZqmNdvKTd1veIC5Ugv6CJW0u6UxNZ+RN5GNbdG+EaxQ4bb2zq7ayGUtRszf4OpLZPw7Net1lkVQC8D+Dd2muG03JYmBRrofH9lUP02QV4pcM6pW2dZ6icuGBJjrbXP98wB+EMS0LeWzcl7842i+5U8AWbNi2ZD3abGhUaEBwWO+9hukPPU08lJpj7egrCy2GOmBOelUTjPKba6N2egHipBnEZFSlKrwZ6ZTR1x4fiVyCzNEv+oj8P1GAFdCtDTadAoxiHsgQK5cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=28Xjs9uGoAVt2aRPXuKZdlyHgD7xMK0Dkez1A+cNEUY=;
 b=kpKkbQ7CusT9YhE4e0/18yXv0CCV7cdRzBFhehgsgprXvAaYcxui0aFbdmMicZcbJjqwC0/mgOAj45r3r3TpyNTnMYDPduTRHXH/w7DvWyHG7mTLutPVE31EUze9aCea+PAsXnDsiqIiTxD5sKHO8vemZGnSX1WYSeb4D12ADPC6Epr9NXJW7yBCdR4/9XxK5EkYxObQIDrfB7Yw14agcKnqd3Nc1fhqrOMHkKDWdW0mxnz/HHEqOFDRctlliiXijCTAuVs71ly3SPQv8Sd3pefCjfvm18ST/Xx2DtEjZGk1Zie8ki9DVo7r3lYULC5eKL4prQ4igVFZm307Ns7E9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28Xjs9uGoAVt2aRPXuKZdlyHgD7xMK0Dkez1A+cNEUY=;
 b=BEn+yU8KSWGQLlp7Nf+7OZ5CByukEKGHMvRnixaiWzXEyLrnjqlRIeJ40zHlPUbyDeljm5QsT9qm2sCHUuRZPUsDGRV4rYN/QqB/rvLRk9EA2KeaaySTawx1Ba2W+a2FjYI+XTOc29N7dLwpLIgeQJpGw9wzQYq1V0kFyRl9K00/cjVesyKA7d1AZ0xxNmJ8Ujegw9wACg4dxqxFuyD3YOd4lozJhqFkWsGQ/kvx//XFUUsOvQ47vumoZ3iH6+cClRKgmIUbQFhw3rDmfRAvtWUbeu89Xo/P72S8UZAY6X7roX0o7kXyO1EC9eXkxu4+RhIq7Z2+0ZgttTvqSut7ew==
Received: from BLAPR03CA0045.namprd03.prod.outlook.com (2603:10b6:208:32d::20)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14; Wed, 7 Feb
 2024 20:47:42 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:32d:cafe::b2) by BLAPR03CA0045.outlook.office365.com
 (2603:10b6:208:32d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36 via Frontend
 Transport; Wed, 7 Feb 2024 20:47:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Wed, 7 Feb 2024 20:47:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 7 Feb 2024
 12:47:27 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 7 Feb
 2024 12:47:27 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Wed, 7 Feb 2024 12:47:16 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <reinette.chatre@intel.com>, <surenb@google.com>,
	<stefanha@redhat.com>, <brauner@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
	<wangjinchao@xfusion.com>, <gshan@redhat.com>, <ricarkol@google.com>,
	<linux-mm@kvack.org>, <lpieralisi@kernel.org>, <rananta@google.com>,
	<ryan.roberts@arm.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kvmarm@lists.linux.dev>, <mochs@nvidia.com>, <zhiw@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v6 2/4] mm: introduce new flag to indicate wc safe
Date: Thu, 8 Feb 2024 02:16:50 +0530
Message-ID: <20240207204652.22954-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240207204652.22954-1-ankita@nvidia.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 71894c6b-5a4a-4de8-8ae5-08dc281e076d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	W/uKY5tCQfJw4z1VnqkVrnmwWczkASRakpxzIg3T77JDeLCruP0KHy3HM2N+aDy0sAmdNSv3yhRKDkEVy0lP+vS2LNo9xVrxO01x8VUeYrwl/C+/n6+/LyJXFmCcX0EbPbAvTvjRoO77QvnrIND0Z2kBt3xNPU9jtqLrDcj9xA6lcGoQrzir5y513/gBz6hUWhUWhpL25kFGZr0gwb0JN2k03tCqHqUBKPhaecwYG1eXTOa4d/D/e0EO6UzFNN17+G5OV0pwdVUXs3K0g+mthatfzW7EPIMnIrCS8AJZBKADMWJ0C68uQxAleaaWsl5DjrxXadYNDpoIEBoPhq8sfSilf3U9kejUQ8rbz/t6wxl8qB6jgKWGtxM/CZUfS2xqndQb25JAG6vwDZzNkTCrBTY0jWzY0VKroOtoqm9Ig2SsFAh5PBTDmwMZOVkVAtLmfJUsIpMUCdSpBcLbjYDEVteCPl9DP80sR4GP5JrA5Pep4/LFfkKi8p4tsqkhywFEj8fdWg8IEPLix5csdWxd5kLVKOpcUYGAvMcKoHFWwFLkuX533Tg1hu0I1Oux4bkfOlHiPWxryyRZqJIAjdwevhXOnz27laDdYFiyyETWxL/qILQiPeDjKxjjHAk7zPc7wA0BNuz1XGa8NWVqRshcWw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(1800799012)(451199024)(82310400011)(64100799003)(186009)(40470700004)(36840700001)(46966006)(356005)(1076003)(26005)(83380400001)(82740400003)(426003)(336012)(7636003)(36756003)(5660300002)(2616005)(2876002)(316002)(7416002)(4326008)(70586007)(6666004)(478600001)(2906002)(8676002)(54906003)(7696005)(8936002)(70206006)(921011)(110136005)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2024 20:47:41.6485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71894c6b-5a4a-4de8-8ae5-08dc281e076d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

From: Ankit Agrawal <ankita@nvidia.com>

Generalizing S2 setting from DEVICE_nGnRE to NormalNc for non PCI
devices may be problematic. E.g. GICv2 vCPU interface, which is
effectively a shared peripheral, can allow a guest to affect another
guest's interrupt distribution. The issue may be solved by limiting
the relaxation to mappings that have a user VMA. Still there is
insufficient information and uncertainity in the behavior of
non PCI drivers.

Add a new flag VM_VFIO_ALLOW_WC to indicate KVM that the device is
WC capable and these S2 changes can be extended to it. KVM can use
this flag to activate the code.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mm.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f5a97dec5169..884c068a79eb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -391,6 +391,20 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_UFFD_MINOR		VM_NONE
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
 
+/*
+ * This flag is used to connect VFIO to arch specific KVM code. It
+ * indicates that the memory under this VMA is safe for use with any
+ * non-cachable memory type inside KVM. Some VFIO devices, on some
+ * platforms, are thought to be unsafe and can cause machine crashes if
+ * KVM does not lock down the memory type.
+ */
+#ifdef CONFIG_64BIT
+#define VM_VFIO_ALLOW_WC_BIT	39
+#define VM_VFIO_ALLOW_WC	BIT(VM_VFIO_ALLOW_WC_BIT)
+#else
+#define VM_VFIO_ALLOW_WC	VM_NONE
+#endif
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
 
-- 
2.34.1


