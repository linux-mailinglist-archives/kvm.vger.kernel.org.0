Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487CE64A767
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiLLSrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiLLSqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:46:24 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EF697;
        Mon, 12 Dec 2022 10:46:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHCULsJTAbulNy3tTzkLfqFUnAtR8vEINrUugEN1aRUrh0JDzBhLuQuArRO0qK4Ci4YepS5xBCxenGMH5CAmKynJhsKQUlCSo14k7FTPpNUfpXIozuJca+fT36udLtiUL14O9aelVhHVlvSIIWJJ5L4OHQIW5Nx3EFkAyKXGYN7nhDOkhqRFBE2LBBI3kms5tlh8raUJ6KITIWqZ1x6UGUAHnC8curEKa7r5WLhlpCrGJUN1CB+bN8BR586rGLSBb5nVh6JebZ2hAkgBRhJ8278+o4Y4I0CSdab83z39bdaJykQmRxvkXbAIbGtkx2VPnAon/vexinhwQJPYTUZYTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4F3Y4GlXxKueC0BHnPpfwVwKXm1d05Sq3ONRWfN155k=;
 b=DRwFHgmx23NXjdoo5oz/Km89xJOi40HGt/5S8x0nSy5iAjd1CxsDheyq/ZoCoX5kJW9SAuA/wPNGYz+1LXe9TKcnNLE2bsZke3IhIZQ3FItmJDVcWfAPGoEDxi/8RjIUJ8kkbE0HF1nBn6/HKl+4KQfKbPISiT5OfEn322GO9sQIe7+SKZlEgOxd3jB9ItH+juvXi6oUDnx1gcIxPHR43i+GOsklKrX7wxBjyaoCPzVBBlJQqvzUR4rApcqnkrcxa0bcESQ1aWKCUAVRn3qDDQ7iHLIPQh9iM/KNo9lPGHlnvgRC8ZPhIFopacQbb3GJDQfJmhqvFM+QSlivb24yPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4F3Y4GlXxKueC0BHnPpfwVwKXm1d05Sq3ONRWfN155k=;
 b=gE3qNJVj0Cz+RRiWfUgASKFA2F2wa2Duou8ImiNq75ldBrKAUxXvXhHmrrrmM1wnDcVE/V7tby+A1d0IeBBg/boMcFoG0Vg65JZTktE6DJ1PoXmWMEbLQuGW+sCrh+WXd/AILmN+MofkpqHIuzQ+2sFKuYpOg1s3nVEFE+lwIbSsIgaMfCQKYo0osT8YWtlvWvBPTIYQ1eRcoL3J0DeMXmFy3IO1WKO8BmuYbsyIKB5mYj5OBJurZV8NmuXldTLch/ju4nLin1TPapn8/tsaKzsiVn0xCDQIudUMhQS6lzoHPd295HFd6l2Vzv0N056m8xPbcyxT75SF2I5myG0Wlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:46:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:46:06 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd v2 9/9] iommu: Remove IOMMU_CAP_INTR_REMAP
Date:   Mon, 12 Dec 2022 14:46:03 -0400
Message-Id: <9-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0372.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: 74b35fb6-39e5-42f5-24e5-08dadc711ff0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zGQ2hgTvctKdXiySYgHGH89032o3Yv82uPK4hp+AxYC8u/YwP+O5rDsior0CxxjBtlM4571k2yyCTyC/F281b5JqiJhLao5c6WBEMqF21bqtorPKdTw7tOHI9m+2066co0TGhzCFCdJYndmXhSyUp154l8f16czNmp2W7/KBKcMgSdqCzcShabsCHYE1kVCaelkZW8L7nzPPwKA6hBR12/LqTTRYwjhpSdXHmYLlYVZ83t9ffquDQ6Zj0rHxpcEJLRiZ2NhujR7mY86FnXIWhMVPm7e8oqyaZmKCFHBixP35cQUb/Stnfl0HBCfDKonpMb+WrGU5vbSZ9JBDcUZe8B5oochuc1oMfLfRJM/py/67gofpzcmdLUyra9ZZzo6kc0QlNGYWEmaUEs8jttjNTuSKEQfo81K8IJNSaN05clY477kU8Ggugu1zLBuL56ogBOebIaeODHiwTLochl7LseWg550hMja2ZIYtEqxZ+ouiII7SOKoD3D5N2xj2V8YEgeHzsXZnmURRigobV2fbqGTQDswjNcToLUM3vS6PLB1AEtkmkDZQ2MySR3lFKcu9vAnGCo9v0s+Qmd6yMFzV3Ww5CNqcfxV/FiPVBYIeE6OHJGrt2toHRYWeWUmB0eq5f5Hou9QHjxoow64ikkiSbKcS8/U/KjYERwDafY8QlWWR5v9BPmgK3IcwSS34zyJlnxHD7WKLl8R0OjjQumG1Mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199015)(921005)(2906002)(38100700002)(41300700001)(4326008)(26005)(36756003)(86362001)(6506007)(6666004)(66946007)(54906003)(8936002)(7416002)(316002)(110136005)(5660300002)(66556008)(66476007)(478600001)(6486002)(6512007)(186003)(8676002)(83380400001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aJKht19LqeQBC1VahagGCxwJ40Xr5BznVq6091rztCzdbWbnIwkwCPaD/wJz?=
 =?us-ascii?Q?7aN1miZr7Gp6KxHBHASi0XuPIu5D/p8J1YEapDniETxWrTxfVj8g7iNN65oG?=
 =?us-ascii?Q?pqOIWRaepI8VDsGNnLL5vPqIl/SPTXcC0DDVNJuL1CxT4n3jHx9pUOqnKka4?=
 =?us-ascii?Q?zjAM+SS7DlbbcQCuKK7pxJ+YwWsgYfR2Q3B7K3qCl6Q9a13/oquaaFYEbozt?=
 =?us-ascii?Q?6ayctPNKnaHp7dFR+cqSy55dS0OJ0TX53oa+o3UJ98BEdoRsWNSZhBt1n0Qt?=
 =?us-ascii?Q?9xdtRe+Euydk6OnPakRT/kmS7JneEYiqG3rwAVjjuFp79vx+ggQ6A2REAwa9?=
 =?us-ascii?Q?yzm5yi+86VHtVcDB6wr4iP6qAODDnuTrcil9ZDON+Skh0UFXZ/0x6w8vrKRW?=
 =?us-ascii?Q?r0QQ+BVqZO2ttYNzR9L/Cj90oHzmyto/wpZJfEHMimSeV44D4x55RxvGKC37?=
 =?us-ascii?Q?xbHshmW0vNzjQBRVUnxIaoyJ28HzS5fak08ZwlB8rkX/LKWrisdfR35pYzJm?=
 =?us-ascii?Q?0jG1EnXCG/DuWoEZfR2ztiH8WEf8jrQlbEysiVnA/XTcJNniIQG4RowLzv2y?=
 =?us-ascii?Q?Wt7mKNPoLUn5ADCTOp30Lw+JzGRqbtJ2xGp9haZad+IV86oAwwFcUy9YUh/+?=
 =?us-ascii?Q?QAVgADTV5SgTkivxLKKZPAIbxWs+x1a/32xtrJMIrN+DewfiEaMdCjTrPE7n?=
 =?us-ascii?Q?OyCwL+feu8IrhNpbmIvq5VA+tMIJLW0xkXOGPulM6jgC2kzZl97eZCyuGz03?=
 =?us-ascii?Q?HMmZQv4Dv9NTHi7Wt5yu06vp/s5euouKMhL80yRCkMJWczRJbRSMg065szGw?=
 =?us-ascii?Q?z/CyAg4hIjBsYXjOTDAP1/zd70G8cg9h2qBAsoXbQ2pParDoB3LqU6aCGZ0l?=
 =?us-ascii?Q?gxF4YfH7XOAIT96IYxPw/2EarpBtZc+HSQ3ZfglwJt2NvCfCkDqBApB2unpz?=
 =?us-ascii?Q?zO6cqC29iUIPjpj8N6fMuP5bao5OT/xrz/3wSW11SJ0wTTVrCzOo5wwl51q9?=
 =?us-ascii?Q?kb9qBbSNp8O0/O0xmK+vbMNlBF23QTcRXfMdHSIozhqLdpmxssM5d7iZTygA?=
 =?us-ascii?Q?zrrREfxAL0yWLFVaZhBDGvzxiW22uJzSSrSBRRB45G30D0pUSof6I/IbUqcV?=
 =?us-ascii?Q?XbBzJtnmmlmAioBgn18jpbSCPhEPq5mmnT4wR7eXbrjPVWMESutgTUHQl8MJ?=
 =?us-ascii?Q?VZeJeaPDH7vAdpDe2fjgY/an2mg3ntuxkYc6q1ZxjOCp+dL7ncIOfuRRGlYZ?=
 =?us-ascii?Q?O2pqmGilpCegd5BdVhunbnrkiW4cdheMyO19zQrbPMOmls5jznWEzHxY1oQW?=
 =?us-ascii?Q?wdocO3DNV2+VZRYNWLfTKf8IEbcZC0tk/ehF1H7U8lvBb4JIOLV7PQunXoPl?=
 =?us-ascii?Q?1z+vnQfeEjAIr42ZGoJG+QdPeGAHNufp6ePOFav9LsnagtR8k2csHSVSQ5ZC?=
 =?us-ascii?Q?pMUnmQp3DsDvsfn9ANKobIMxJO7CKOQ8vogUmfnNX1/skSf6tb1k9F+sujyA?=
 =?us-ascii?Q?mOx4FkjEJhUiBGEFEJxe0pnMp9Vx/rWoPieDa7avy18Gcz0iHamKC+RZvqVH?=
 =?us-ascii?Q?8EoMuqzfbrmauV+LLhIq/cAEn58VugtIRkxHq1A6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b35fb6-39e5-42f5-24e5-08dadc711ff0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:46:05.3155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Lfy2VKhsOxaio/WaRNHS2TLFk3u46oFwR81MnNDjSDIDwqApP+mqTzINKBbIFju
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5748
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No iommu driver implements this any more, get rid of it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 4 +---
 include/linux/iommu.h | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index adb3f655bf5709..b856bb3ae43fd8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1898,9 +1898,7 @@ bool iommu_group_has_isolated_msi(struct iommu_group *group)
 
 	mutex_lock(&group->mutex);
 	list_for_each_entry(group_dev, &group->devices, list)
-		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
-		       device_iommu_capable(group_dev->dev,
-					    IOMMU_CAP_INTR_REMAP);
+		ret &= msi_device_has_isolated_msi(group_dev->dev);
 	mutex_unlock(&group->mutex);
 	return ret;
 }
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1753e819a63250..623ee6f8fdaa3b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -120,7 +120,6 @@ static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
 
 enum iommu_cap {
 	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU_CACHE is supported */
-	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
 	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
 	IOMMU_CAP_PRE_BOOT_PROTECTION,	/* Firmware says it used the IOMMU for
 					   DMA protection and we should too */
-- 
2.38.1

