Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17545A876B
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 22:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbiHaUQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 16:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbiHaUQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 16:16:15 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2088.outbound.protection.outlook.com [40.107.101.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C2EE58A2
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:16:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oR3mgeIQB4797QqH/1JQPbxv+Qd7JC0yntCFBBFkTW90Hxb3RvIgTdi7QBk86W4Cr9eL9guxpvHO6cwbXQIEoMNwT9g26CKBlT2MTVSL0P8IPuC1ROouuBIPTx0HFvcXUJGbbANEEO4qyEMT6WTKSjSjyIFjlyxP6wo1ggNPx/h/x8mI4HOiqauv6i4X/W8eTdPhN2gfvrgiRvrwljOJCpyDrvElZxXbTNmxrhiLlvy7pu8IqL+mM4Ytlt4KavTilCm41wiMrDeDuCr/q7XgRj/g1YoA8lCI8mM5WpOMWicdq2TG1YTdsIcPXN/etH87AxjT4ObSq9B8iPbH9a5twQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rlll6OwItxvD0r89bgE202OEJkhIDpnfvA55EAac5+M=;
 b=PSF03c0FBgtEmqMptPp3GsVzc5BuTnzjxWakbk9iyAjzQFqIApqNit9JhboZefmsskDQke8aompUy83sdeK4S9qPXvkxGibEEJ08GUucBqIguMZxJ26uvCH+yppHuYs/R64UBzFErFydYzy0fRUkvIszoYt3U+781E8uZAznAs9/sz3+8wNbR51jRctF9EwK5aN68TU8pXnxoTQcLRSoWi+fx0ri3TPrhmU1f4zgy8NOSHG144rQVohoWIXkBg9+I0tD57DvDGcfwRu/kMF/17+h+S7811IzeOWUV4EZArVuN5jY55A20Q7jBLfVVaC8BERz1lCMFvshkGgS0M3sZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rlll6OwItxvD0r89bgE202OEJkhIDpnfvA55EAac5+M=;
 b=IcLeJqAFG5oETw6+Oap76+tOQNwbHnit/jEO/h6BsK8dJPNbsdy2JXoZSBDvqHDr7zDJr6/9OUHrvPrJwYTxluPjLnDWNz8PN4sgzNB1v6XdUWgTzgYwg+fk/YHP0Tg23F3rbstLLiUvQZgyQgxDD9YJxeAvZAODwoYgIGzY+W6c6tC9Ou7rNSLtJSMddat5JyLV6q0AhCCY5irL550D0TejIUjEF/4m1EfKVYNi+RYUuuPa/0sngGODYFCJY75F2Fb3TSDhMYkQdRPzuwLsjnK2akjP9sF97Dg/mSSXQnP5UDL/n/cZprczC2kRUf8JwIZXQ+YRpnz314358vXODw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 20:16:10 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:16:10 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 7/8] vfio: Follow the naming pattern for vfio_group_ioctl_unset_container()
Date:   Wed, 31 Aug 2022 17:16:02 -0300
Message-Id: <7-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:610:b3::27) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec5c1888-8d84-46d3-aad2-08da8b8da2c0
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6316:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n9f7888p1Y/ntNoNloHfGlJqNQoTCLwFZxxZmI31J85QRwheynSkiCX/y7DdKu8rNjtq0Mn3SkccbHyuiGGoXtwls1yq3UNmaNadiUAu+uYnaqFCbbf4G1MOkWGDniPV8a6dyFbf1Agn2hZjtprABYXLRUhNuhCS5fzPUvvkNtZ3BzbWJ+fny7DzJdQ3LdvJE39nVqqkLDA7b/fXa7AuYfp8KlmhX0pDjskzZOAByKpPJMZCpprEu+A8SOG8GN2XkCyWZhs+tLl4nlwcuYXTsOBNsqL2tugY06//OG6QJ0lTDfwX+90UkJZq53m+zU+S/ExEu5SKoe9eSzR2JfiwdJEyHZvnUDGwqrqfe0z6dIWQdnHXsCeI6sgtuY/fGBXxCQbFbMeR05ueRjBYuTERc97NfboLThtRJkTeTBXAaVK0xYQn26r1x4LM3g7RcnjQ9eBwTl8F4Ls/W2adJmFA4yZ3OVD6jKevh74yrW0P8y0axzEB/Pk+bHWyIXt0qKqWN6C9yyJV2JZ1bP4+sD+vI2i58pQhVqAiGVEQeSu9ALMTj5OzXDU5jxjXIiENg48sYt3YkVm3g1KToPfyCX4p3WTBEGvxEx00FvI8B1fhKjPOhgH9RJdJtToyKCFjejPYhBdkPRxOp6T5TkcRYmFajmTNQqrWtweiOJVYB/41yYb+hq6VbSUoKWacXdn/VuU3q/KGUk/7gWDfrpBu4GVFyyC+x6a0d1FBttDAWIA4QigdWdV6mP2gFd3tJAGjju6c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(186003)(5660300002)(110136005)(478600001)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(6486002)(86362001)(36756003)(8936002)(41300700001)(2616005)(6666004)(38100700002)(2906002)(6506007)(83380400001)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GUqVxpNzgy9om3QMMsdYGVGYBz8b2JapozPNKmqOYa69WHwfS2t+6RnicKpe?=
 =?us-ascii?Q?xyRSAznns8oarGMdO9t4bz8HeAGeoA+V953plC4WD8sFv3TT9ws4UXIxa7LN?=
 =?us-ascii?Q?Q0/9XuQCxkvB2Aa7eSnKQiELj4vRpEglXOggLgaDVJAsmfXRncKEjfzxL861?=
 =?us-ascii?Q?mnA+A6ZpRG6TJKwsFy1xh8ABjzBg0TXM/8j9Wfqvw0u2pOhwIcEF2dXEfOMc?=
 =?us-ascii?Q?YYQt869IImZw6W/dJTvjq4QZDBZFIpLbg5fQ6gmRTXwQ4mPRH5LdecdoZqnz?=
 =?us-ascii?Q?lvMQxDNoEIauN53JSjr1z9qm0GAaX0G9j+Kmx3HAWbqoN/5DWAhuUfZ6fQ0H?=
 =?us-ascii?Q?w50suk/h56POBcUyBRaDDQlqwI602BvxHj23/RIeDu89bUQinHgtqL0G0nsz?=
 =?us-ascii?Q?zkV0wbEfukQvk6Q6lmmzJfUKzLKUm15IwAPKOVLbD1OKRJH77jvXg5MoVqua?=
 =?us-ascii?Q?25Aebpd8rqUA4Gdjpn+rD3GhtcT6fLQdl3qDzP+YbzPbFNjLWTiQHGgbo2de?=
 =?us-ascii?Q?su+F43imlpBbNbYlVdwyJWNOApO9Z4zHMB5o0bPQdLJUazb6Oqh0J4mrxmiw?=
 =?us-ascii?Q?EJNJ46bDopjwXE+L8uDil4zztphr2DF7b32zzqhk3/OCpuYYBNXwhDOYnAJA?=
 =?us-ascii?Q?UZTcCn4OGnn6FNLp4pwwrVLReQmaXTleBCTHtALR9Vpqw/WRPIb/x2ina5Sh?=
 =?us-ascii?Q?5FQ41a6GpWsTrys1qd+L4Z4qKbM6+tQwlVGOSQAkKlLZC1l62M2n+9vbhQps?=
 =?us-ascii?Q?vVFnJZoHgDO7jk3GLHfw6KPz+JIxVqgbbVxq4VCj4N71qHStLwU+koWSGxOR?=
 =?us-ascii?Q?IshbCaBu8eHt02D3rSimhu5/L7DfT8Lx1B7lxupla9N7LfeWuQuOQj+rD4HU?=
 =?us-ascii?Q?7gSreO1Iq2dkqwsYS/rlSE5d13hg379i8HV2TMZ19xF+AIK1lH3oel4Y1ge9?=
 =?us-ascii?Q?uC2XRpsQT/Kkz+37YMQV0TAuuCr/btxxqeOEwLurtxuNbxwNIpw2ll+buJcS?=
 =?us-ascii?Q?C+oiqP/y1aUCGnjVA8tyqIrN8UPICvAR3lvzq5moM1VEOVYm5BBQ2LS1+ZjN?=
 =?us-ascii?Q?0SdpEQ4CimoFacBBVacNIVp1fsvrwRPiz+RK1lA/btzQKpejS/fR/jLSHB+2?=
 =?us-ascii?Q?JW1YCFVxS+PWYq6OdwLPPmaff1L+6iy0EpF1Rw0wElcxC6NJZZ+8EqWt1PaR?=
 =?us-ascii?Q?0vkOiYzsRunY95qpkZph1hSMAtaVj4YNVnzR22A+84Rrio+mWkCRDFtK7myb?=
 =?us-ascii?Q?PcV7I+b3baqtK3VUFK5NFZgP583O8qdFEx8hpJuEWyWqu6IMbQbcm73YYufR?=
 =?us-ascii?Q?RhdW+oLWNJAVLZkghB8Rp1AxQKKxlcVIrzuoqVM0E9Odf/Dt0DFJqgcGkJLj?=
 =?us-ascii?Q?y0ippO53NjetNbWNIxgCm38C7FJjDKanjZ+Bpk5dY8l0IDY3AFI1M6koUAUY?=
 =?us-ascii?Q?jbAsH9By3Ywl5pbWymxUMUvuxLPVVCD6t1yT/DrlLZ09EuV29ifu8VXG6wDh?=
 =?us-ascii?Q?8OOCQIUQD1hZ2NJEIWEl/Z4RBtWsK0rpBEVvPr8kF1dolwpNPiRuT5fv/1qB?=
 =?us-ascii?Q?vkJMq69tCEsEORAc5Yvle978hun2iC0hriTZEJp6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec5c1888-8d84-46d3-aad2-08da8b8da2c0
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:16:06.4625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5ILCNcU8bRcQ/bvlXscOx+D3rXFg4FhgMUFpHnh9gOQAt8/cyaVZVzcjAp8jzAM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make it clear that this is the body of the ioctl. Fold the locking into
the function so it is self contained like the other ioctls.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 17c44ee81f9fea..0bb75416acfc49 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -968,16 +968,24 @@ static void __vfio_group_unset_container(struct vfio_group *group)
  * the group, we know that still exists, therefore the only valid
  * transition here is 1->0.
  */
-static int vfio_group_unset_container(struct vfio_group *group)
+static int vfio_group_ioctl_unset_container(struct vfio_group *group)
 {
-	lockdep_assert_held_write(&group->group_rwsem);
+	int ret = 0;
 
-	if (!group->container)
-		return -EINVAL;
-	if (group->container_users != 1)
-		return -EBUSY;
+	down_write(&group->group_rwsem);
+	if (!group->container) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	if (group->container_users != 1) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
 	__vfio_group_unset_container(group);
-	return 0;
+
+out_unlock:
+	up_write(&group->group_rwsem);
+	return ret;
 }
 
 static int vfio_group_ioctl_set_container(struct vfio_group *group,
@@ -1270,10 +1278,7 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 	case VFIO_GROUP_SET_CONTAINER:
 		return vfio_group_ioctl_set_container(group, uarg);
 	case VFIO_GROUP_UNSET_CONTAINER:
-		down_write(&group->group_rwsem);
-		ret = vfio_group_unset_container(group);
-		up_write(&group->group_rwsem);
-		break;
+		return vfio_group_ioctl_unset_container(group);
 	}
 
 	return ret;
-- 
2.37.2

