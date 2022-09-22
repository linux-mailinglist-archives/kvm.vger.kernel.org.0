Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04295E6BA3
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiIVTUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiIVTUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:20:35 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2066.outbound.protection.outlook.com [40.107.212.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA7FAC252
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:20:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xu6hYbII4FF/NEDbmyiB1cAEunLbgbLvLpTV6BNeETwJAJfHewouL6t4R6xy8WsE0Q3vqH/+qbNBfnmyCN5C7/tX0J5zte06IGRB/XosFlqWrM2R0l0xabhpXHQpJhGs44WkgFAUbNcvNiySsRU3ANVIShpbYeUrW4OIDc79eYtXoup22VsRrmwIQYjRZsT1KRKQHqxkNYBBTfYGqQL0ZoR670fUSZj5OivCLBtSgncd7nVyrzyuxCpj+Xi8hdd2avN+wTm9iJKHAF8ySY02o+mc+WJdh9pKy19HHv6E7ujCAPN9NTfgaMbbg5tMvDU/VqYdxZcuQ49KbJ7rGYvXLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6VmmnIBPENhAw4RHsFNSWftwoWz50/sreox818WPic=;
 b=TbgcMmT7wZF3bzwNRXw/cF/2NpgJSZh5gNTDWXb+ksqWG/qHMQxnjJ9SZRBSxDQiuyNtDDyTC4pGJlYM6QeSE0ZGD86QF2IAXx07aHYq8GDAPw+br1+NIC3HHBcvgDLR6A7oeaT7CFyhV9C5rBN2auroKpKD8rkmhEnAQKyp2jNLX1vQ3YMjCYpWOC2o0/clRZiIXEt3DUbaJCRgVuXg5Cwi4g+Ld3Mo+oj21fpLnYidPwxtYiXCEgU+hZqmN8aatHwFOkgMPFrD5qeUA/Qqm1G4iiNyFgKHdDSRIziaXYeSZmeYhgQzahT3ZMFfhowE59IoUx5968S72LhGD47LUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6VmmnIBPENhAw4RHsFNSWftwoWz50/sreox818WPic=;
 b=mGfk8uy32/pw4il5T3brN6hBQMWVPat7Fq2oo1p0HbcP4Od5iBeXNdLxuOLW7dYXaam0jVMAh6L7dnUE8jv2xmo6nHgJlCl8HRl77jFL49TM7wlyUpxp1QkZnDXuJJy0ef846spXkbWHhY0BDv36vUXY8DlPwbJwELt/4n/Z9dgIIgHh3PwY+V3c4L7IuvD175FKmZuOFN9f2E/pejuUTp9oyT2r7ZP4tW6w599XV6xazg91vNKDucx1wW8YRIH4byR4sXCJYwXrwBpVbcEZfiNatw1T/Sb/NIBE19hVFZm/22pafuWTIT4KvwEfg88nxDnJKmgtttocd52TQ3zyLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5486.namprd12.prod.outlook.com (2603:10b6:a03:3bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 19:20:30 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 19:20:30 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v3 2/8] vfio: Rename __vfio_group_unset_container()
Date:   Thu, 22 Sep 2022 16:20:20 -0300
Message-Id: <2-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0115.namprd03.prod.outlook.com
 (2603:10b6:208:32a::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5486:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c781f30-ea3f-4cb5-fbbf-08da9ccf8191
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BkIP9uCBw7pbBcTo4CFHmXdemxI+Go6Qi+HQl8+2ANOQTSeNLwkLwNGO2kzW7RlftjdFR275WbO7HrNVVKGXuO3nzszLDZ2aPoC+SrnpHq4NvGu+Raz+I9fCEnMTGMTMeMxQ2Z1Dmj3r7gqMPbm1xu2+ydeIdF7IyOmz3Fk0mR5UXfRHVQRb6Hya+A+KZwNE7wrwjgyAy/5MFXxsGOgfbriTB164P6l52uhwSXGxFlepO+YO89TKoBjLr6/aaIQTWzqbnwNo5C/rrTqjYRt1D5y/z7XpsYJu+A8QOkHQooP/gySuLW0WdovfmXVT1Wt1hqKO/+q85UUaQbS+xz8XfoIlota6AW6mUcQQWebfITYjzCm7IBrmM5WCn+yDjLtq81pmS6nF0uWTOJAPxkkA6NHz0AXQpzDRh4J8Zipd5s/T2kvb7v1Yk9UBa5Dvc1qgXCk8g28PmBOWfgk1rQty+Y/l1+2dqNxJ6+2GYLVhYHBAzSd3xZJhq1D4kX14J5bT6dmPc2Qz+YGJtxaWXRw0jlWHtlvk20iRFFc/C7yywKs+0jczkJmGQ4dsRV5Vd6MNqUwxUJ2XgNPBqE8OmGo0SOfFLBKcUl0IiLjBlIpHkgR3hDy4/xecC3LpZLmbVzigvIzHPdK7Q0A7cdugRqr8Rd3H2MEBYDFx0d1tLsHIfYfGaaSA00w3iKbrKdNDN+pZJmwDay1DkWyGmcASopL6JojZzuXSvzNRFA6CfzvDJFbix2unxWCTaJgU7AUe8w6h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199015)(2616005)(36756003)(83380400001)(41300700001)(6506007)(6666004)(2906002)(8936002)(5660300002)(26005)(38100700002)(6512007)(186003)(316002)(86362001)(110136005)(6486002)(66556008)(478600001)(66476007)(66946007)(4326008)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3dyvEHdhetU/7WoNhaGliBVUB81AuSoKnhkVB66oIdJ3HYG6F4CYtlkVx3aK?=
 =?us-ascii?Q?HON0x6fcZdVREFGRkR1JIktWng6IKqXJdjNmzMhoVIF4mghZaJIKLY22U9YP?=
 =?us-ascii?Q?4gjbYwsfMeam45Hayy29+QgJHOYiSVWr6pqhIrf1TSqFmdwehYZfjThh0AJ/?=
 =?us-ascii?Q?ukuYiPotlD74lK1LXQLqmKxtLhfz99fDdx+MFA2VO7PeFHIIqz7kFV/anMoT?=
 =?us-ascii?Q?A1qlWieANfvTNjJHw8H/SsA+Sr23cPI2NqY1E2PPHLb6TGfsZNpPI2u2nCuh?=
 =?us-ascii?Q?7ifOVeAuuPrvQVTwoXzRVwCOLnmJxB6sxVdmNPi0srVPFHw1in4kcNrBLA+1?=
 =?us-ascii?Q?lH3EL0JShbGJL0jRJOux65fYmlP2SHzai9XIWvD8TOccNG/C3fUbJEGPzcJv?=
 =?us-ascii?Q?KJEjUg3UQcHKE5KYZHB0nznh7viGd5D4yE69V28d2lv/3fNCYsMbmPuMZXSA?=
 =?us-ascii?Q?iTEDSk4rxfqs1ViMxVhEFfWkYhEoT/ciapfeDkBvqOc3GZgzMCAXGEZYrxbF?=
 =?us-ascii?Q?tKzUs3J9O7bKZbEQVgw07ijiVGWoZAmgzKgGZ1JwACZ+wc9Qtm0R/N7w2C8g?=
 =?us-ascii?Q?xqWuTPBszVNpSqdZ85L/4jUwSe61K76LlNJQtb2RuHXFIcr2PXoP3sPhhLKz?=
 =?us-ascii?Q?jrooXNZsS2Fuhgn4xxMcrOE1rnO6MZ2VPVpGQY4j7AD/cSygbSxQletv/2gH?=
 =?us-ascii?Q?GsRiqPSfkmJOHhKYyxh3vfT9ukAYNwzQS77I4gMo4XTtgSyEeNKnLKHUYO1k?=
 =?us-ascii?Q?saDtFnWwcmHiU64zfRHAYMW05tyK9I+fWaF29ll0IaAByRwF2o7+1P4S/K/V?=
 =?us-ascii?Q?RYqWuHbHlsZKT0AqI0VdCUanFmUaHcg4ZjCPMh2fSMffsfL5vSzpvlIvRqYQ?=
 =?us-ascii?Q?V4aJ+4I796zVBib0+a562cGijxWUrvPmmtzbSfiWjmykZiloj5GbxYj7/lRH?=
 =?us-ascii?Q?xLwsb4Njf6OYe7VgLZk1pbO3O3obLgSfUoPTiEilqh2uoVWiUUXP1W/ckeGI?=
 =?us-ascii?Q?+ZADrHsbo6Gxy1Cdpzmfb/ogCM4WBIkasEOESTlJJH4osotEF8vGQKVx7RIe?=
 =?us-ascii?Q?kxAI20XaDqCoZwd+C3WqhlAI/RB3v/1e13oGgfncF+QdeXetiuDAxzyljgmR?=
 =?us-ascii?Q?7Zdj2KkYgm5E4SH98mmZZD85e9eKrvmbrW/JB5qIulZcA/GQd60BEcx7SLhs?=
 =?us-ascii?Q?OpPrXEEbB98e/swW8cJWg+vq6Hu4p5P1Myi7MAaWVkayTfYcKanTp7r/bchW?=
 =?us-ascii?Q?14Xkb2/VM9qevi+bjUKPx9zU+W5o5Nkc+/XHrRtiYlVkqRV9+I5vr7QLdSS2?=
 =?us-ascii?Q?k0cJRxQXWzzKUkUbMARYIYlEu4eC4izLoaEU2Y5tFFmSLP1An6e/DqEsaNzn?=
 =?us-ascii?Q?weudWxPFpeKi9zXB2RE0kHA2k53odbhOfW7cU8ZkETMWnbf2XB+M7xUYozlK?=
 =?us-ascii?Q?uDi9SXW4w4ewAFbCyGgffHChcDudNKG7GjtTe4PlVQZ/CI6YJJuuufOBAc8q?=
 =?us-ascii?Q?dypRc/FLr8CvzqfFG9Z1IxgSam9WHVijUWiR3tZJUjyxppTJa3+oM9RNVRcF?=
 =?us-ascii?Q?aA6Gp2dadMK9nz1WX1urfkg8QJc1VlSjY89qkjvb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c781f30-ea3f-4cb5-fbbf-08da9ccf8191
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 19:20:27.3587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nnvjwfDlGMs1gB6Izt9lG3nSltIWBw0r0pLq0wmAT2hmiEzanOATEzfLAofvOCLQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5486
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To vfio_group_detach_container(). This function is really a container
function.

Fold the WARN_ON() into it as a precondition assertion.

A following patch will move the vfio_container functions to their own .c
file.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f9d10dbcf3e616..3d8813125358a4 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1036,12 +1036,13 @@ static const struct file_operations vfio_fops = {
 /*
  * VFIO Group fd, /dev/vfio/$GROUP
  */
-static void __vfio_group_unset_container(struct vfio_group *group)
+static void vfio_group_detach_container(struct vfio_group *group)
 {
 	struct vfio_container *container = group->container;
 	struct vfio_iommu_driver *driver;
 
 	lockdep_assert_held_write(&group->group_rwsem);
+	WARN_ON(group->container_users != 1);
 
 	down_write(&container->group_lock);
 
@@ -1089,7 +1090,7 @@ static int vfio_group_ioctl_unset_container(struct vfio_group *group)
 		ret = -EBUSY;
 		goto out_unlock;
 	}
-	__vfio_group_unset_container(group);
+	vfio_group_detach_container(group);
 
 out_unlock:
 	up_write(&group->group_rwsem);
@@ -1441,10 +1442,8 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 	 * is only called when there are no open devices.
 	 */
 	WARN_ON(group->notifier.head);
-	if (group->container) {
-		WARN_ON(group->container_users != 1);
-		__vfio_group_unset_container(group);
-	}
+	if (group->container)
+		vfio_group_detach_container(group);
 	group->opened_file = NULL;
 	up_write(&group->group_rwsem);
 
-- 
2.37.3

