Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3A74FC022
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 17:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347709AbiDKPSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 11:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347714AbiDKPS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 11:18:27 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AD13206E
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 08:16:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3JxEgUkXAS4WfHW+9ON8qOPRHgsuQlt9TwUOTDgUnZZuyO3BQP/rmIiusRPbHygYUP59kuNgIvWyDY332DdUcakX+yVRJ5YvTXV0TZFd4jFelTfGGj2jkriB3ytNiibhUk1BRYfEwDoaM7i/OK43ReZt48/yqdDRH1lTb+o2wh8S6kzMLsZCCRBjvPet0vbx0bTqHSxJKKoAaboWFE7Rwl5v536AUIzgA/SvtFTHxSaiaiCIrkSfx9wUCst58AOnhcq3TmrQjijx4lRD5SGvDPKVD5mEk4ygr3hahUgY+in8ZZB2DyZDQP1SZpwrMJKrvSmivNNDsvNdVhHohSLAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Pdw9qwMLSU9jXOVZX/4TCboLS2F2PKNd/ZBuNWSbzY=;
 b=g/Mps49G5yKLrr7Bb82dtWwIycBdVLg4if9xDequq7PYHxfMxPWECHCoBMWDCA/NWQpc8M9vJSvDu18FiJXrdPniE+fYTyt+g2c2pRNGZiTjJ7GLeth29CEYVBjf6ZMxpmjALCibB2aJ5v694Co7qjxCVgai00/IGNZR3Ne9JELoYI3LeAn3bW+UldlsRBs88hv1vGs+WYAgvJkrAe+1PpJjCQXCFjizGfUok30HH1l9dy6QYZ0cL2GtO5NZ1JAGI+uQt6oMNmJWHoQjQyxw10fFccPHAlBx7Cty+BIhZqvFmJCFTg8QYYhq9oEZ3QSLcE+kMKFuxLE1lzgZS7QE5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Pdw9qwMLSU9jXOVZX/4TCboLS2F2PKNd/ZBuNWSbzY=;
 b=SyB9OpQPqeb6JH4kIfhuxWxoOrMWcJVLXvpsAPrbewJWls0cuL+FZfFoXrBDgsyDO2d9NgSt7eVpZeZc2bCNfWg6OJvFYKFQXH4X2IQs5uHlpo7GoAwIHfFIaS8JXWKY1J3r5mmM78/+3OEvXQgqagt7z1kyFpq1leX70+KS5jNR7u2i1T6ohDfHOs2BgpGKt42d7l84gnA60jcM+2DvnIw45Etq/KXHbwO4KmEigM8FeirgWR3b8BZUk3QCM/brVAk/Rz2fkO6HGa9k49htx5eU6DAyq+Fg8IgsXLMhiXg2eNCRkz6Kb+G9SkpUqSVoxBn+w50+jlcX1byF49xadA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB5927.namprd12.prod.outlook.com (2603:10b6:510:1da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 11 Apr
 2022 15:16:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 15:16:09 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 3/4] iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the cap flag for IOMMU_CACHE
Date:   Mon, 11 Apr 2022 12:16:07 -0300
Message-Id: <3-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <0-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ea61652-4d8d-4471-fdda-08da1bce3520
X-MS-TrafficTypeDiagnostic: PH7PR12MB5927:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB59277FF54CC2FC281D6E8A00C2EA9@PH7PR12MB5927.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gfYmywl+aXKk3ZgDn3vVap6bvci6dbPM9qYKJApkYPO40tx+NG0B3o1yezBw/dsK649ojZtgDfkKygETORMgrDQYt6oN7JWU8+4XE4sOhMxiw27dgaE0sfh2Z4NVBJdwWimLXB31IcVkeYScsLWvPIx5M6xLDom4jPGfcBMYTVpEIuEUtRQPT5kAndZ9IFgTqMzPGGTU4F3fReRWiozgjkxtZ7enX3hgreflDKTfqCSXQzSTT8j5188qJZk6HHH9B+VPcNcMhCn6jFpQWOwXStIii4OVZu0YjN94LDKgqhTgaGT98mQPmZQhIfl2Xc5PCiq4NC3ot6RjoAELJpjkiqjI6FfpF7nOR1rJxdvQxLomUoN7gW+ACqw8/1qkZsS1w3UX8w56o0Mv1b0pfSHt9eWLjIZhGRgSxDUBMFDviUKNj0z92OMy5AKv7UVPpYgZNxykJ4Hv6kmpRzwmL7e2kdAgjqoOUjFHQmEa3GdTZAOwwtn/6pKfl5UD42//X4oRYT8IKpu9YtBMIT8kA89BIy9TaRsU4GqKAFm3SjrZQAPGP4Q/5DjWVAB6xnyR2xxp6w3awfhU8PW9YISbeX+laQoCoVxvea9dxnL7UPmSLicKaCVVPHnVw8K8ZtRyHPliP8UQ1fQvUur3AEzkAozLAEyEId7AqREHo19TClqpY3WA9PtvyjLYpE/Ayr0U9kQY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(54906003)(6512007)(38100700002)(8676002)(508600001)(6506007)(8936002)(5660300002)(2616005)(4326008)(110136005)(316002)(83380400001)(86362001)(66946007)(66556008)(36756003)(66476007)(7416002)(186003)(26005)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1/FfZN7B6OMEEqWNo1NEq73wsnkW7T4jNdVrhX9UJE/A4CfYq+djh25HVzdT?=
 =?us-ascii?Q?ZuQtWwEHeS/ecVm4hsL81cqwA0zDIPScjNQ+q0hR9NaJEdnhffHmuqn5maK9?=
 =?us-ascii?Q?MdE0l08H36B49CIALNWOAYcJ+t16X9TzXrVFSejIjhb+pHGkn2mCbZu4U4Fg?=
 =?us-ascii?Q?8GSgKz4pETRgRVSD5EU6pzB8jI5/qHnTlPfkr4h3x5fIGSVJEQB0zBB7yqHS?=
 =?us-ascii?Q?vzB049XUgks/zBbNrgwr0cO62snBBpaxTZLL71JpsNCXC8loRQODAHowElSp?=
 =?us-ascii?Q?OtPHmu3908gMbLzNHdEvIcemZbfcogLMvoXR+KSHcUVt7gBWYQOOQcHAYf7r?=
 =?us-ascii?Q?xVhyOf4pT6T262NBts75XhAsJZpDZL1hqBNu+ha0n4K2IgWvLxj02zPiyGAQ?=
 =?us-ascii?Q?aZU6eIASAiHv/FfFZciNFjlvPEBuO25aA23pD1SZG0Iqr8EuMKW4LvhNzZ+H?=
 =?us-ascii?Q?D4bJ8ElS3LypZCYpmMz4nuEL7uYCveJ0or0uBvcX5GBBqG1Kbc7uM3aw7y5k?=
 =?us-ascii?Q?vJnOjRBG/CQfoGiQLO9R/JulB+xs8j1mQ/bpezWNtiwgXSGE4T+SI/8ziG+G?=
 =?us-ascii?Q?1GVbdc0WJfbOq8l5nJUJOxreLSV5Eu9mAdPtOgdQ7ol/zyh58OOJfEMvWly6?=
 =?us-ascii?Q?XohF6d/EQ6+bwKfvTfsw9ApX6WpOLDYo5Io8eJEZ4fB8kk5qOdIiP1gNXufH?=
 =?us-ascii?Q?1R/8GN+MeXReskaV5L73mmMOqaFDxMZKM7nzn6Tjf54AXZCPy+faiTnKBnVj?=
 =?us-ascii?Q?cLvVPGdqky73Vfjr4T5bEx3U1CoV6vsm7N5WsJXyMnN9amKeSbxQNGKBJ9lp?=
 =?us-ascii?Q?xvsr8TBs52hv72UUkrJTcEBqcbPKv5Ckwm7TY4F2TM124ug/SWDuE+xfZY2B?=
 =?us-ascii?Q?wKYL7P0TZXqTOb5+S//w2c0Nv/uXGzyrTJynu4X0yDA14U++dQ3JO6AV6s4n?=
 =?us-ascii?Q?lFnkheryjkaVJ9zOWmTafLai1+N5Ht6CyEv9UOEDyqg5C9tnYL423M+ngpg2?=
 =?us-ascii?Q?FLwo9WGVcEFDow97yXQui2c7KV7EnkfRvgicCzpb873mrLII8b0DH/yafJNl?=
 =?us-ascii?Q?Rk0ENysISVsGJsL2cOjvqSGynked98aPiu7rHUkTp6K9bEoXiQigC9v8Q5g9?=
 =?us-ascii?Q?sPERBWueZBza+zbdn+YQ3Cs6Gtaff3S9VERTV+ZcO1XfUioyVQtHm52MPN25?=
 =?us-ascii?Q?oUoSWBgex4aph6tpSkqDryl3/eYuALdUDSfg6kWVXF9PUpMIizhRGL8WkVeO?=
 =?us-ascii?Q?5O/DNHg9fWKijH8bhH0Z9xAfQBXGptt6WSpM7c57KE+PMUcYr/FIqQhFCFez?=
 =?us-ascii?Q?NSApi8rbB/O9WBF0HsGH+DXwYB9r3jESTI6mV32E9MqbTt8hAAfWzQlLmOY+?=
 =?us-ascii?Q?jKb4Gpd281UA6kpL57tDzH4OwASMorOnxJFIhUN2FkmGaxqdveHw0cWvLKIk?=
 =?us-ascii?Q?8aE5+gYFhGR5pVse8tLw4Vl9OOuHipcVzSjjcUOgnQHGvGRNTA2rxCbvTuet?=
 =?us-ascii?Q?HPki1Y6QeEFEKcv9UL9yLjWnNqAsI55UQUeDpOwkY/nbQs7OdkSCm6eBPpV5?=
 =?us-ascii?Q?KgE1YYjoKOY2UeBwr27fGLdaKt4uAK1Vnzf7aMe0m4j0mi79KhEQwZ2XjB8m?=
 =?us-ascii?Q?qkhzzN/fU8gVh2mj8+r/GFCZycgJuDLC1qypjsEnxXzB2MRJB6Hxv0VEG6aN?=
 =?us-ascii?Q?9zkCPKhWLxFVvn2TwKGAXbFPT+83fQYllY6iMU7Sjc8ZH54k/U6ZKu0d/Uf0?=
 =?us-ascii?Q?B/bxO8iFzQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea61652-4d8d-4471-fdda-08da1bce3520
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 15:16:09.6320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tG0TzD0PAhTSIrE7NH1bkf/rsuMDxweelXbcZF+eKiPcnl0q+U18xy8oMi0u3N1v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5927
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While the comment was correct that this flag was intended to convey the
block no-snoop support in the IOMMU, it has become widely implemented and
used to mean the IOMMU supports IOMMU_CACHE as a map flag. Only the Intel
driver was different.

Now that the Intel driver is using enforce_cache_coherency() update the
comment to make it clear that IOMMU_CAP_CACHE_COHERENCY is only about
IOMMU_CACHE.  Fix the Intel driver to return true since IOMMU_CACHE always
works.

The two places that test this flag, usnic and vdpa, are both assigning
userspace pages to a driver controlled iommu_domain and require
IOMMU_CACHE behavior as they offer no way for userspace to synchronize
caches.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 2 +-
 include/linux/iommu.h       | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 2332060e059c3d..4aebf8fa6d119a 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4556,7 +4556,7 @@ static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 static bool intel_iommu_capable(enum iommu_cap cap)
 {
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
-		return domain_update_iommu_snooping(NULL);
+		return true;
 	if (cap == IOMMU_CAP_INTR_REMAP)
 		return irq_remapping_enabled == 1;
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index fe4f24c469c373..fd58f7adc52796 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -103,8 +103,7 @@ static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
 }
 
 enum iommu_cap {
-	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU can enforce cache coherent DMA
-					   transactions */
+	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU_CACHE is supported */
 	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
 	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
 };
-- 
2.35.1

