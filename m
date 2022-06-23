Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713865589B2
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiFWUBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiFWUBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:01:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6636396A8;
        Thu, 23 Jun 2022 13:01:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEn3xq36up9V6E08QdW1kFJoHBnAzOm6wJdSUEPaObx3Hdtc3u34kXi+CQ8TWco5GZibzYJ4LzYnST+wZz5eM+t91weB83DV036bpkQNxGEX7YiYWKWYOzDeuGTzuGjZYB48gKUG0X2hDxqubSfR/2usY3dwjALkDF1HpZnIph5ev77kMueUVuLppjx0b3bBnUfvh14UIG+cr2DW/yYGTRMwCkGJFVhzlGYS8UTixGyPRCjMg+NN8fTjM/Osu6sqOwzSmYXEtzRKEzX3CRhgRJKx3I9qeefGNvzs/4ag6aReINUctkhc1hRH/WHX4CLCnZzK3NRghKp+AWmGuoLgtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iiLl+1qlIiZ2p5XtsJlrm1t+tPCrFaHsdr1121XcM/M=;
 b=cSsFYOQufHDidw4MlQq+Y8ii74VoyK3eE13t1gwOFIhH2oSLiaY/iAOkCmU65RpZjVboajK9Ka9ey41M0CiT8Z8L2TcLKV9ynBKKRcn+cpSQ7RQfxHC53+xXR2ICGYlw/y7zPB80lZyPdSwXIkqQ3PhFibHgiEUuVnIV4wYM1JoeVmiCG4uykquGpmNsn7XlKnhwUx6uMzt1L5uPAKOgL8ZolDDUGi+Ska3TuQWKcdI1vjhxV6Vp/TJ5G2/kzaQEy2fRGHxSG9ZCw1ljyf+308bWTfUQzZF12+Zrpf+x+N4BwESbVRTrlFtZTzLsJYq1BXH8dQAS2d7CZELXxZZS6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iiLl+1qlIiZ2p5XtsJlrm1t+tPCrFaHsdr1121XcM/M=;
 b=JGW4LEKhNUZbyIo9qiAvbZXZS7j83x/X3izclI6zn572DClh36vUR49ILOeqIhvDNCRTRy2+3kLk1AjZskdSWcra2J4W2vKH/AGUoB9NHcAuCmEX2CzdLWHuOMlfcLRfqgVID5Mb9MbNARRGQBQSX0cAr4RYGv52TKkNvEEhbiIVRnKv+ZmInCwWqRYWpxvMFf4Hfx9dL+abrcwgdlSFzoU0fJjsk8b4GAtQHpShfAvKuClQG4BDRcFPjzP5mpLmockK0IVQXoJb1vH1sNS8aYMI00Snk9kG6/FmYigXL/BrzLuR8GCVpGoGd/9Oc2jL0oCZYOrNTmHWAbPFNF//2Q==
Received: from BN9PR03CA0783.namprd03.prod.outlook.com (2603:10b6:408:13f::8)
 by SN6PR12MB2751.namprd12.prod.outlook.com (2603:10b6:805:6c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 20:01:40 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::eb) by BN9PR03CA0783.outlook.office365.com
 (2603:10b6:408:13f::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Thu, 23 Jun 2022 20:01:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 20:01:39 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 20:01:39 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 13:01:38 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 23 Jun 2022 13:01:36 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <matthias.bgg@gmail.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <yong.wu@mediatek.com>,
        <mjrosato@linux.ibm.com>, <gerald.schaefer@linux.ibm.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <chenxiang66@hisilicon.com>, <christophe.jaillet@wanadoo.fr>,
        <john.garry@huawei.com>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 3/5] vfio/iommu_type1: Remove the domain->ops comparison
Date:   Thu, 23 Jun 2022 13:00:27 -0700
Message-ID: <20220623200029.26007-4-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623200029.26007-1-nicolinc@nvidia.com>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be33d66a-062a-445e-9b6a-08da55532fe8
X-MS-TrafficTypeDiagnostic: SN6PR12MB2751:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cowBanVnRs74asRIkEry4va1+JrzBKVdez/9Msww3cMrrv4yrQEY50xIGLlh?=
 =?us-ascii?Q?vMk0CpVor5zl3+aRZKKTyZv0dy7BlE/KNXar+T5Sike4FS8mD1pk/gwis8Yf?=
 =?us-ascii?Q?7SUJwKSeUzSoRcvg4KDz4NPHZ03/7aorBvmNRWL7PB/EhwDKUHU3NlwrnNNj?=
 =?us-ascii?Q?D5FTe0gHtU8kAiVBzOKigzQSHLowZWLQ1xxFfcWCm6MZtHKQUjzF7mKY9kOS?=
 =?us-ascii?Q?N8nTAbU+Uyj0xmwRhzoib+VJb6IWwF4/dKsm4i8nYnjnFtTKN+b7xdw0oai8?=
 =?us-ascii?Q?2ZxjT3ifvCbq+hnwGwzSN+pkcUH/jorv51dBVGNDPt3xlMu126MT1tC3ij2v?=
 =?us-ascii?Q?FUEr5CaAyyD6MFpDK+GRRk+U8c4s5EuvTlN/GwgMiwZBHktnpewvwiJOWDmQ?=
 =?us-ascii?Q?PrqBo/vnhgz5IcjduDrW/Y/Kmev/UBI+KcTR9Tv64bRDtC5//zfUT0+t7hAi?=
 =?us-ascii?Q?2J3IWQ78fEwofgB+YqEMjyBVu/QH8HcL6LhRHtM6vdFNB07cJPaCT/9f1Dfv?=
 =?us-ascii?Q?TdfGdMNUOTBn+yLPmta9/cKQi8eqK132k5iwi6qzYRnrkb/ja5u/TUe6zkxg?=
 =?us-ascii?Q?hqANeJkprZoNrSe+XgmFRVSMa5/v5G/IiyS+z1pT8ZW69G0KrD8eeAdISMwy?=
 =?us-ascii?Q?ntOfrbuKM2BTRLIjF4gSwOirah9B/7neysp+drV8ldW2LsTcRmaqwPKKfwa0?=
 =?us-ascii?Q?a2/0bVvf5NQyZYS8Nd5qjOZ84zHcbddq6nB0dswMC1h781bzSbO2nbci3+Ca?=
 =?us-ascii?Q?l3M8psnch5jhqyNv0btXgfRlLsApZLZbQYSQ2OCzxlplcqwvDaEQo5aesjNx?=
 =?us-ascii?Q?bR4dIlgfs6yqhqPW1HkeWE3Am3MuZtt97iOyqP+miqwfn+ZWTofqegyBsEnf?=
 =?us-ascii?Q?pYp3vqogl+RlrUYZw7T0DNfNmuwApokdQL+yTpgCk06oWO418Ib1ib5ty6CP?=
 =?us-ascii?Q?OrJOP0x+kwEMM3txjgIcJLCpiVbWR92d6KyjYCNVg/G0giAVcrGp3r8mBi2t?=
 =?us-ascii?Q?s4sMv/5nixIfz9KR/PYCUgt+KA=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(136003)(39860400002)(40470700004)(36840700001)(46966006)(40480700001)(7406005)(83380400001)(426003)(336012)(86362001)(2616005)(70206006)(6666004)(70586007)(4326008)(8676002)(186003)(8936002)(7416002)(5660300002)(36860700001)(47076005)(1076003)(81166007)(82740400003)(316002)(40460700003)(41300700001)(921005)(356005)(26005)(478600001)(7696005)(36756003)(2906002)(82310400005)(110136005)(54906003)(966005)(36900700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 20:01:39.9047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be33d66a-062a-445e-9b6a-08da55532fe8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2751
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The domain->ops validation was added, as a precaution, for mixed-driver
systems.

Per Robin's remarks,
* While bus_set_iommu() still exists, the core code prevents multiple
  drivers from registering, so we can't really run into a situation of
  having a mixed-driver system:
  https://lore.kernel.org/kvm/6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com/

* And there's plenty more significant problems than this to fix; in future
  when many can be permitted, we will rely on the IOMMU core code to check
  the domain->ops:
  https://lore.kernel.org/kvm/6575de6d-94ba-c427-5b1e-967750ddff23@arm.com/

So remove the check in VFIO for simplicity.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f4e3b423a453..11be5f95580b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2277,29 +2277,19 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			domain->domain->ops->enforce_cache_coherency(
 				domain->domain);
 
-	/*
-	 * Try to match an existing compatible domain.  We don't want to
-	 * preclude an IOMMU driver supporting multiple bus_types and being
-	 * able to include different bus_types in the same IOMMU domain, so
-	 * we test whether the domains use the same iommu_ops rather than
-	 * testing if they're on the same bus_type.
-	 */
+	/* Try to match an existing compatible domain */
 	list_for_each_entry(d, &iommu->domain_list, next) {
-		if (d->domain->ops == domain->domain->ops) {
-			iommu_detach_group(domain->domain, group->iommu_group);
-			if (!iommu_attach_group(d->domain,
-						group->iommu_group)) {
-				list_add(&group->next, &d->group_list);
-				iommu_domain_free(domain->domain);
-				kfree(domain);
-				goto done;
-			}
-
-			ret = iommu_attach_group(domain->domain,
-						 group->iommu_group);
-			if (ret)
-				goto out_domain;
+		iommu_detach_group(domain->domain, group->iommu_group);
+		if (!iommu_attach_group(d->domain, group->iommu_group)) {
+			list_add(&group->next, &d->group_list);
+			iommu_domain_free(domain->domain);
+			kfree(domain);
+			goto done;
 		}
+
+		ret = iommu_attach_group(domain->domain,  group->iommu_group);
+		if (ret)
+			goto out_domain;
 	}
 
 	vfio_test_domain_fgsp(domain);
-- 
2.17.1

