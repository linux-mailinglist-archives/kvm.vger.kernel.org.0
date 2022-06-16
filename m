Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D7C54D5B3
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 02:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350553AbiFPADk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 20:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350338AbiFPADZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 20:03:25 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5461C55374;
        Wed, 15 Jun 2022 17:03:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsapoHp95BrwQq1++W6LKY1tSu8JaAaMy6LoT5ZkqZJcUebnABlU0kupm+xOfqJeOT8JFhtsOBAfI+ne6pzooYbv0D3u4EmnQouJuBXQv/IG2W34/36KQi6Zf8QiOQLxe8bPqhREtiowCCVqDuNxLNUNyK1WfezwKoQp0eNi+PyspAkg+K6ArJCmBLZjb1/DydlF5VgIAbGC4MCJiHdHk0h2jpSMDaSlIYGHwmUo8YlPvgHQJqkVf3vprokAhtj0vYkS+D3r/BQLM6UgdNCmuGe8iOt5nDEEyquQ3kXjxKZj9xxoEG/PX4FFzIp8yfpcCbP6lumQt+BF5jRe7hb4cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvw7R2wVvGJfgqslMD1pbelLjoj3I35diURuODKN4DY=;
 b=d6Na1fABKMZRP9zwfGv7kD497gR7IJPjGm0AOhZaUSZimlNvzg43504wU/judKktO8rFFmIWFN1dmJsGo/rK5eixOv8PUjnGEa130MrzPzAq9JboBRox4+OSeK26mKl4Fn2Pg9Cw0jr9TR/Yfw9HaUggoiwyWguyquDw+qQEem8nJ5rKVK1ZQj5VdCgRtpU7EDhY792KZFWDJeQ5kZIdmivR7ZsaqKQix5mtQ5yPcim22rkq41+wXpnh7izapKqwrNqG72QAJNcHIk7dFFL3+5MnW9iGKCIy/ZRp+R7MUstA21gZbdCbbP9BT91sEg9i3aCjJ01p3pLOc3OY4eshSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvw7R2wVvGJfgqslMD1pbelLjoj3I35diURuODKN4DY=;
 b=mL3YC3Hi9UrmL0xP6RIHyg4EpjqzDIR8pWHnPxwemNGTjtRXUMFlCESFrgZ6SjHlI9J0MpHMcefC3lnmHZsSYrv0JQoKPkyoT2fbSkzzG+f6GLeAjzyHvyFCYKD08jUGX7dZjXdiJMcUJ6/Vb88x6tGxHKR16sHvHK2Kdsmh870Sh7SioHLPFMDLlY2EaCj+erlPDXZTSPp5p+ilM9KhjVtURGbS7G610Vf4YWSOmi/1DISqueGcSqfVptGGAHZCCqMDEJsz9zTJp9qXGR80jRb7Qmzo+m0IBMo+rQg2lpn19EcZMNrfLZsjJF6Esz3/B77zLYiAuUSQHRaBGEPvuw==
Received: from MWHPR18CA0028.namprd18.prod.outlook.com (2603:10b6:320:31::14)
 by BY5PR12MB4162.namprd12.prod.outlook.com (2603:10b6:a03:201::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 00:03:20 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::7c) by MWHPR18CA0028.outlook.office365.com
 (2603:10b6:320:31::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Thu, 16 Jun 2022 00:03:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Thu, 16 Jun 2022 00:03:19 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 16 Jun 2022 00:03:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 17:03:18 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 17:03:17 -0700
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
        <christophe.jaillet@wanadoo.fr>, <john.garry@huawei.com>,
        <chenxiang66@hisilicon.com>, <saiprakash.ranjan@codeaurora.org>,
        <isaacm@codeaurora.org>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v2 4/5] vfio/iommu_type1: Clean up update_dirty_scope in detach_group()
Date:   Wed, 15 Jun 2022 17:03:03 -0700
Message-ID: <20220616000304.23890-5-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220616000304.23890-1-nicolinc@nvidia.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6969c3fa-2622-4090-8f29-08da4f2b9f10
X-MS-TrafficTypeDiagnostic: BY5PR12MB4162:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4162DC3C331967D4B3967EAEABAC9@BY5PR12MB4162.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gTqULYr9y4ewQKJ9Lv4lmMGwLVxYkPFbhRuJXZLDrIaB7dYUohGqlCchE1PtYA67QDd2y8hgpkw2I2lBCLgdReX4v6vDyDGFUGYrXL9xD6VDTRVjYwgV8fa2+Ltn87RwdT7DRhk5j0uT3icC6rzLt75nxSfKssAZBU/y71qX+Sf2Ce9bX88goG/W2Qaydlu0iWTcAzuVkLYeDDvYr9aL3wsBJte2zUXYeG1gsbpu/q65la3Kgn0QoRbd5KtEX+Kr/xJpQ3HCGbYMH4LkC4kdDNCk0aNBWHjq3zDQOlA4B3s+O0MgdSNehZIVmZUp+JXBLIh3kKYV6VHd51m3e7sY2KwXNNiyM8NSZ8bowKc/SbzHqb+dbWz2cgoJB2hULM8RrzT4vCehmO0OUkk2ZOYIR+m1R8oGjc064DfeeRC5EkKu8wUhJfkYb+rEQSpsdD1ESk13KXSk2sstB8N9zBs2wA8OOW7PsGcsDMtGjEsP7QVKBSm4H3q/R03boC1Dir1O70XTuJPbmjQf7FeGD2YDaSPAW+0j+FjXX1y2d5kdiUBsHMuwFCWivLWypFkD5OmizPd9Z7xGY5Fhn61/rupvTwqeFzDbani0hiN75UgTkJLGajBUMXpSK2D26YjwBq0c86NU3AzwJlqgGsl4gDMyXjl1EL0rIX3ON3TuT0XzXRxy69hqu9rDkgipfikJbRwedAlMXyIBPghJuDZI8dVBzbZY15zxI3Cga1fewREbiSTUSpI3owJe7xo9naqvafCF9wGdlmvm0uj5pBvm8Z70X+kQHO3LSt6onVk6u2dmWyA=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(46966006)(40470700004)(81166007)(7406005)(1076003)(7696005)(2906002)(15650500001)(82310400005)(7416002)(5660300002)(26005)(36756003)(8936002)(4326008)(40460700003)(70586007)(8676002)(2616005)(508600001)(356005)(86362001)(110136005)(70206006)(186003)(83380400001)(316002)(921005)(6666004)(54906003)(47076005)(336012)(426003)(36860700001)(14143004)(2101003)(83996005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 00:03:19.5790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6969c3fa-2622-4090-8f29-08da4f2b9f10
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4162
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All devices in emulated_iommu_groups have pinned_page_dirty_scope
set, so the update_dirty_scope in the first list_for_each_entry
is always false. Clean it up, and move the "if update_dirty_scope"
part from the detach_group_done routine to the domain_list part.

Rename the "detach_group_done" goto label accordingly.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 11be5f95580b..573caf320788 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2453,14 +2453,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_domain *domain;
 	struct vfio_iommu_group *group;
-	bool update_dirty_scope = false;
 	LIST_HEAD(iova_copy);
 
 	mutex_lock(&iommu->lock);
 	list_for_each_entry(group, &iommu->emulated_iommu_groups, next) {
 		if (group->iommu_group != iommu_group)
 			continue;
-		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
 		kfree(group);
 
@@ -2469,7 +2467,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			WARN_ON(iommu->notifier.head);
 			vfio_iommu_unmap_unpin_all(iommu);
 		}
-		goto detach_group_done;
+		goto out_unlock;
 	}
 
 	/*
@@ -2485,9 +2483,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			continue;
 
 		iommu_detach_group(domain->domain, group->iommu_group);
-		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
-		kfree(group);
 		/*
 		 * Group ownership provides privilege, if the group list is
 		 * empty, the domain goes away. If it's the last domain with
@@ -2510,6 +2506,16 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			vfio_iommu_aper_expand(iommu, &iova_copy);
 			vfio_update_pgsize_bitmap(iommu);
 		}
+		/*
+		 * Removal of a group without dirty tracking may allow
+		 * the iommu scope to be promoted.
+		 */
+		if (!group->pinned_page_dirty_scope) {
+			iommu->num_non_pinned_groups--;
+			if (iommu->dirty_page_tracking)
+				vfio_iommu_populate_bitmap_full(iommu);
+		}
+		kfree(group);
 		break;
 	}
 
@@ -2518,16 +2524,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	else
 		vfio_iommu_iova_free(&iova_copy);
 
-detach_group_done:
-	/*
-	 * Removal of a group without dirty tracking may allow the iommu scope
-	 * to be promoted.
-	 */
-	if (update_dirty_scope) {
-		iommu->num_non_pinned_groups--;
-		if (iommu->dirty_page_tracking)
-			vfio_iommu_populate_bitmap_full(iommu);
-	}
+out_unlock:
 	mutex_unlock(&iommu->lock);
 }
 
-- 
2.17.1

