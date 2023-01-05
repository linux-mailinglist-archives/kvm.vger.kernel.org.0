Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A816065F4AB
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbjAEThO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235766AbjAETgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:36:01 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD111A39E;
        Thu,  5 Jan 2023 11:34:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtdxJ9yIRSqtdfgB7d3yw0IWkGWL53NAU0aBDgIkYfObjYNSpmMSDOn2KDiUVKj6kdFNTlBnhO7q1BDejYaZ+TsrOCXM2iyNxkXMiagPBX5gLDjzVgnxUfsPw8aO97q+p9XIXGznSjj0wzNvVmwTwQkNC66nm+CDgmuQGFO5r6bVRXBTdxj8s+blN+C6DKWlEwMRVHa5vbGgh3gMNZAh8F2GYDqdZItzthAd6tfXGBFjzARQq/h6MLWX4VaXAGhKOCUMw+0HISgAkJiOEITbgyM5NcYutlRzzinGaq3Z9znz7YGGWo7qDvA7+p03n7guP7Baz2QzmdrG1mlGlTJAig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GrCuHObzvLnzWtfGMBKcR0aBdQFymdGSL2skEgBgidk=;
 b=S3dwKF+7/QNFgQzuQibQCqwgGlF49BbGDPpwcBiJPs4Tb2A6413UWD47KAYWN5ZuS91UA634AMMV6FwifVjUhZt2fJ0D+jT9A4b2RhCOdxVvAu+NKcsjrpGCLn05165O+DTCijtLomRyZ/eH/uviH2SGjHUJIHsmOGDTbuQe6InojP7wOjhJ0j5Cwl3cu+WUBh7btAWVjZoDcJbg6mlUNxzGAQa6+Sh0VO/fORSUGWHcPu9BcMBQ6EWd41rHKGoeWvWS4+4dBmCOdf7WQyoWrdIDE9w5teg21hfsOgcIEOvaTPIHF1sBsjKgMRNIKlnQKn5/abaAdA757sylFs/vsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrCuHObzvLnzWtfGMBKcR0aBdQFymdGSL2skEgBgidk=;
 b=YEA5jyudbJ53pPcUCrYGWNMCDP4Uq/sM5Li0Ms7Cuh7kH31Qa98esLSIuxftIAhQWbROStNrucaNIH6HZtKne3AE3Iy7kNq/gfipDQ9kusVvcezr0zQTVMNs/rbwcSsMRCW6qdwLlEjilV4zxv4fWJ1oIzdldOfaaYlzTID3e4PHtuvMEVYAp+e09VaoFEGdfr//pm455B6xf+nzeJaFxxPtVTkBKxElA6iBipCRjoMBsmGQg8otl9tDLye3Jx1wv0+py7SyxpliZl77qFd8kV/11q0F13nM4cP/xUe3OL8e8q1M2iaUgdlug1QCMQCAWDZovCdoyZsXQ2C7FT33Jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 19:34:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 19:34:00 +0000
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
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
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
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd v3 3/9] vfio/type1: Convert to iommu_group_has_isolated_msi()
Date:   Thu,  5 Jan 2023 15:33:51 -0400
Message-Id: <3-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0323.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 0309e0e2-d173-4d03-ad45-08daef53cb1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtCwkxVvBf9qARP6y/RLFDDpVgvcjb0LEJF3gv88KUV+TA3EYMXFq56PVjeLYNRw6s+vTGvv6Uf218QDEsMgohxQ5Qd8+OjBwr7Z6WiwXbkdRGH3Hn0AR6RHswKibQJnMtHmRtidGSTqG/EFPM/8OAxdvpFrILuLGevbgx1SunpcFS2spkxT+Xo1uWNIlAk0ysgHVa1aQhvkH0nl5cjV5q+V8E/ohCfyaObxoMwDAbxsF6cwFA1qfGRmcyWsaxojiM+yELA33QfAAwyglOtISaJONWtvBRRpHk2s2TtQAzmNjiVnuceN1BXECNC5vcRzJxhSDiUCKNVD/G3Esw0VEchKlucx9A0fg+iasBUreWE4W/wxT52J5nQRW3KZ1wnEIt6eZTHQY6D4JxxYcn8S6CO3CQRmaIY9V4JYHWUXLrUUwCbsseITaSajvSifG8kpJYtIDQqHWyJhviwTMw8q21gOSpiDWwyKE8rEuOT1bw/TT69bVqEAnupZ0ocu4qVFaOKhpAjSgUHgaNMLkB03nTezHh1cEmuG76p/XwBE8ipN+uGeWq1Ur406/Sz8LrMhtpGsSkhsPX2/UWhyshc9epyon6Xxy4MVyTx1WAYf5EscxtvGnGqSvlb8UmX1EPxeuoY4HSk5smVeEDsouPW4hsc7jlPjgjz1OuNP07Qp1VCjIlsiEr2PTUlpjcvE/D/AElpPAm46m5sBnavoKEaMmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(6486002)(6512007)(26005)(186003)(6506007)(7416002)(8936002)(83380400001)(478600001)(54906003)(4326008)(316002)(2616005)(66476007)(8676002)(36756003)(66556008)(6666004)(66946007)(41300700001)(38100700002)(5660300002)(2906002)(110136005)(921005)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1/y11guwduQpFjVHaXfJqdLtOrINwJOZdnxq4utOJnHvfsELP35lPbcRMJwt?=
 =?us-ascii?Q?Sd0bD8VtCyY8zUV8BhwOn1tpMy0M8hAvLtjixtxKj90+qQwnIr3Tds27JwR/?=
 =?us-ascii?Q?AB88DrvAUm+Uy6GIHFo/mEEhhqWTgJafB9ClDmK6Er4w980OGya12ze0o7Fp?=
 =?us-ascii?Q?12z5eBV5ZogsA6ThJVzcDL71oUE02ngymgBQGgzuipHxf7F8UOH8EoUl+wFP?=
 =?us-ascii?Q?NOSSZJbKZZtuVjFZ2QKM7bjU2pHBTLSQvP5GOIMLGjqrswU5Q/mK5rQzYOyQ?=
 =?us-ascii?Q?rCU71+ZlFpwqXR3itCiOtjDU0cUOF+RJcgEBVgKTDvHNhxCEVMr+VxQN/69X?=
 =?us-ascii?Q?si4gQgVzKN/Yvyy4m+/c1TPS4A73/FyFi/CNaB9NotEwCMRrFp2AlCRyK5GD?=
 =?us-ascii?Q?ooaZeWM6sEN0gsIUUoecS/FzeUu7I9pXYAxu8hRMgjBD8GqngdDpw4J6ybSB?=
 =?us-ascii?Q?giLxlY8QjnnlB2KHCfLgMce25CbmwPmbOFtVyGJW7BLuKKhe5tbgtQjjS5Ze?=
 =?us-ascii?Q?ZXdkc4Ib31S98vBPpChSKPQfI+2MkYu97l6SEK2HckublPV/9ZSo2fldyrIQ?=
 =?us-ascii?Q?GmG8SRWTRmFA1FNia5EJjR0a6KeQQ+bGTo3tDx28exPevjC7uXWbokbDyBzM?=
 =?us-ascii?Q?YedERKNtXq9O5toQbfBINUsoZa+8Fjl0duOnj/oeqy/HmAYMh4O46o5Gr7Yt?=
 =?us-ascii?Q?7gLKlEEQzJuNVHvjESwwou2JZnszU1TTI/Xg6DQr/TjB5WJcIC8F80ZFPeLn?=
 =?us-ascii?Q?WFNj954yFmTChVr+umGgHYP8Cgu+U9kSOYrSMbg0gJQFsjT8RCnu6OWIJxbQ?=
 =?us-ascii?Q?70gECitX7gKkPF3LpK8OiOYHsYzKDwLMJWbrZvlOZ7WYNoHRnbdRLNm/u8vM?=
 =?us-ascii?Q?U0oJZ3g+t/vk9FoZzx0tAUiLb/jmPAIlNKCj1fAywmsUS6FN4ThE4ud38KVd?=
 =?us-ascii?Q?AF6mTzzH+oswpDhGtQCY0n69nOrmam7dqYacRNdvep7yPnOdCbe6mnmhL3fs?=
 =?us-ascii?Q?YrRPqzI7YDlH1r1XBV8bENJ7PUFU317O8L6K/g9555hnJLLxcZ+pX0/NtOL6?=
 =?us-ascii?Q?sALxW0KfTfHRmU/5cyxQnhL4gMpq1JSOgQTZucVV/IRT2nW/28PevzLl1Wpg?=
 =?us-ascii?Q?jX+ufqmgXP4fm9j3bvKhM/TlyberZslQE0IMmbH1eMGOqWSv39/TrBMB4Vo+?=
 =?us-ascii?Q?OuB3L9zibLyqKwf/U/fY7zE9gipP1/yns1FbQeeCv3pC0J+/gAeKW9LmjlgX?=
 =?us-ascii?Q?UMoxX58UTcCgnotJB3UQ8BfJTNft+0lj3GWS6zFP/3ONHth0PuGykBDtMPeF?=
 =?us-ascii?Q?ySJFMcfaznEB6MwYo4Kb/QFZljjfEvcEYRKdJFQXkT1OqUcpJkkU6Ji7Rbmf?=
 =?us-ascii?Q?XX7Ua2ZW3fhXxvgqou/WLIktoR4ErxUooy61o2RKOhzzh2OZTsswmmHNqb8l?=
 =?us-ascii?Q?ogLeSoPaOPn5YVCPQZN3C/zrDJJJFX/0xtbLDWfa+1ld0A+9zLOZQKWpNlTz?=
 =?us-ascii?Q?H6fW7M+iG3+RmDcRXrvY3ROc6MKkpT82zg+dxQXJ2oXidWksX0Zx+Z5iUdVb?=
 =?us-ascii?Q?1KrOPJsvCwJFJAOtSJ++QE//yFPXUao4p77wNzum?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0309e0e2-d173-4d03-ad45-08daef53cb1d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:33:59.7264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8uyMZX2xOmsKx02pKGwCOLCv8vKlw4c1Qbq2iC/07na8H1rb1k1Lcb6wtMPuJ6LG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trivially use the new API.

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00d4..393b27a3bd87ee 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -37,7 +37,6 @@
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
-#include <linux/irqdomain.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -2160,12 +2159,6 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
-/* Redundantly walks non-present capabilities to simplify caller */
-static int vfio_iommu_device_capable(struct device *dev, void *data)
-{
-	return device_iommu_capable(dev, (enum iommu_cap)data);
-}
-
 static int vfio_iommu_domain_alloc(struct device *dev, void *data)
 {
 	struct iommu_domain **domain = data;
@@ -2180,7 +2173,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_iommu_group *group;
 	struct vfio_domain *domain, *d;
-	bool resv_msi, msi_remap;
+	bool resv_msi;
 	phys_addr_t resv_msi_base = 0;
 	struct iommu_domain_geometry *geo;
 	LIST_HEAD(iova_copy);
@@ -2278,11 +2271,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	INIT_LIST_HEAD(&domain->group_list);
 	list_add(&group->next, &domain->group_list);
 
-	msi_remap = irq_domain_check_msi_remap() ||
-		    iommu_group_for_each_dev(iommu_group, (void *)IOMMU_CAP_INTR_REMAP,
-					     vfio_iommu_device_capable);
-
-	if (!allow_unsafe_interrupts && !msi_remap) {
+	if (!allow_unsafe_interrupts &&
+	    !iommu_group_has_isolated_msi(iommu_group)) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
 		       __func__);
 		ret = -EPERM;
-- 
2.39.0

