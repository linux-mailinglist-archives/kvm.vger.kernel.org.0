Return-Path: <kvm+bounces-5088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CF481BB27
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 16:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56AFD1F22889
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 15:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B666558207;
	Thu, 21 Dec 2023 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t7hky1AU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846FA55E6F;
	Thu, 21 Dec 2023 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NglnIY/uhT4MgIrW/82SRHbDtvo2O6Z2Ssb1OMf3kJWTecPTBkhbyDtKbQx6tWiArkWH227f/jzg+q1zeIeWPOzB/8c7XFpCBIz0oUxbAL1jgtfexFxt4rIFnCrZs75ix/tpyC6YToYdLrzKiV4AM60mDSBVGURhEAam3mnEwaDqNj1u0vr0goxjWBaW9rbuMiig5QbAaf+WgsLlhPNyW3I97LoXuBD4sQQqrnhynC4u6kYKY+0qUFbalNvvjlO11RHZcufuGyprk4Rg6rxaSdEvIyodw1DYd4S36jznibWwc54pwyl3H+gZA3pWhteXPeV9IWunl8Fr5uNkJN9n0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=98NcKXWiESUpXBqxBe7E+UCrgHbpvfJcYL9onUUx6HE=;
 b=mrzAn0i64CCa4rlpxR60WL6oboGcttVnpq/Jp2HQZxaHEw3xqp5hZqrUeVZY7yRSXjzhB7DZwAj96ww02Y9NUzEyajTN9CNqdop5LnEXg/myciot+dfl1+fF70fuua0cDfgRy0V/LjcEf68jpi4nNNS+b2ibrkNXnKL16C0XqWHX3lDmn3YQrkYW+MrzhewfxBWaJG70ag1gg4O5ZyHY6ICfbWIFwKiNrwRX4nj+PZAZ98rcFx+rrFkCDvb1jfqxj7vY2tt6SKQ9XEXFApme8d4EW6Tge2wjPh6e1wCtz3pllr4nSVXKsBW/LhwfqpXdZX1oaVYx0kDY8OPdu+Kdhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98NcKXWiESUpXBqxBe7E+UCrgHbpvfJcYL9onUUx6HE=;
 b=t7hky1AUYxa2+XVH8qH86yEs4euYsQfbAAzVEcFnnQyOw1Hk655p86yQfkk2sG3ew4a/G0DsjPgs+Kj4NpjXbGdacGQNR62OLOXcv9sb/hWgdxu18yqwRkbnIAtIKgSxcJsosoI7sFGb0StH0/mV6wVKbfFez6fNzFNyw94yllrwocinJxQYWkLUUtxiRztLVryMbvNSvJIoSBCLS1XGTk6ktqmNB8NSJyyTleC4hv51dK6JuUsP4MFrOjFOkGkXqGy+H3Ew4tYVw0X6LeE5Mu1DLf+1VVtfvArjyAIqPdhBrDAOWJZ9WOW1a30kSvZmaJttisUoQ+Sh7/QvoUtcWg==
Received: from SA9PR03CA0026.namprd03.prod.outlook.com (2603:10b6:806:20::31)
 by DS0PR12MB7770.namprd12.prod.outlook.com (2603:10b6:8:138::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.21; Thu, 21 Dec
 2023 15:40:47 +0000
Received: from SN1PEPF00026367.namprd02.prod.outlook.com
 (2603:10b6:806:20:cafe::a7) by SA9PR03CA0026.outlook.office365.com
 (2603:10b6:806:20::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.21 via Frontend
 Transport; Thu, 21 Dec 2023 15:40:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00026367.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Thu, 21 Dec 2023 15:40:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Dec
 2023 07:40:32 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Dec
 2023 07:40:31 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Thu, 21 Dec 2023 07:40:23 -0800
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
Subject: [PATCH v5 2/4] mm: introduce new flag to indicate wc safe
Date: Thu, 21 Dec 2023 21:10:00 +0530
Message-ID: <20231221154002.32622-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231221154002.32622-1-ankita@nvidia.com>
References: <20231221154002.32622-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026367:EE_|DS0PR12MB7770:EE_
X-MS-Office365-Filtering-Correlation-Id: 97e4db02-b274-461b-048c-08dc023b3360
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yBXR3VJxgIwu0ZLrHcsoPmGsdTjM11BpuiekZWYzvrf4jPuIas4jgcfKO1niuz4jAXvRD+hoc+fdbp4Hb+GFp453afnIJroAzbMbCZnD/ovVxZBLY37GFxQYDr61cgRTfiB5loLizn+dZE5WWo/qgdWdtokAhAxW+sYrZMdvExc17lzD+i0oGzp/RgYrTBKztJRLWvTC27HKlEBI7om2cFlWjzw06rIw3vzhzC+PHBgQtYQURwkGATX40JbtyTha94wEFvCO7kRTtDfexsMOKN4uczGlxSedqrvZeey7rZKuXuT3faKNyLtBo/ATyC4Y8hCRJd2Rdr9WKnXfxaPC8R/cT6TM3UhHJYyf6EbXk3Ld3m6x7y1Fvzt8K/ocj51oJ2zH+84wqegF6lpLvzQ5NwbV8+ESd1igGGy98Y4qeZ4zAZ5XG4zOrzPcl5w5ZFGe3tmRH+I23JkRa285oE/pMFa4CkE6AvylYL6rJvX6+6S+maA5HSbJR893e4sQJKXjFKPTsTK/zbHkH+3NflIL3HrVpHMbqBNiKxTGSA9/v7bjpexU/xA2ylOz6IHh50zAafFXCCTOCu8RPhVat9WzIS5rrZhdvSN02bUZ/N9V2dU+t0w+RqUvJhuMcrwOSoichL1ahM/eTIi3B5K6OMdQVSP2BUJnmwtON7+427kBQ7bvoWcGKS+cB+DCmIRhsfuZ/1Yeg7WZ8YxV8YqXF5zs7QgBQ3CBD80rrnQ2kBvyTV+9gJbN1ybxwLkdSErlAM6aytIdhZ1Lp+XfYFMykF9E9NCrS43Ym1mGw/vIWvxqKFtkAj4dfQ+STvpcz0LQ3izy
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(376002)(346002)(136003)(230922051799003)(64100799003)(451199024)(1800799012)(82310400011)(186009)(40470700004)(46966006)(36840700001)(356005)(7636003)(82740400003)(41300700001)(86362001)(8676002)(8936002)(83380400001)(4326008)(70206006)(70586007)(54906003)(110136005)(426003)(336012)(7416002)(316002)(40480700001)(5660300002)(2876002)(2906002)(47076005)(478600001)(36756003)(6666004)(7696005)(26005)(1076003)(2616005)(921008)(40460700003)(36860700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2023 15:40:46.6774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e4db02-b274-461b-048c-08dc023b3360
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7770

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
Tested-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/mm.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 418d26608ece..49277e845b21 100644
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
2.17.1


