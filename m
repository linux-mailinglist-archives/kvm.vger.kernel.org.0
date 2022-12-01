Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917DA63F944
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 21:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiLAUjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 15:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLAUjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 15:39:43 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339BEA1C2A
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 12:39:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSsYhcI+LqQ6J7VTEoiPCxIJlYqpq/AUyTHsdTsCP1d7rxObs6Xl+1fitodPH84JFsoPBiwSbDaYPtsaxawRq9uf5c6ko1gaofAKQkOnJqJc5H0O/zoXrhW54f5iebHaN8Qd0634Yd9kG3H0D2/mO7rIcrS2BTymdkY8U1SaOK/Pr4tF0Zyd1lV0in+8qiOyAtNY2oBKTbUhKLKFoTIdw62Nh4h/yuYNKDlG136YKHniQrhHMlPfFIXynYR/VlhOYCQUccMiLE3Et2BRsYipZhALorTPZhehssbv2ICIdMqTOsJXoF/1zcKfqXdb5ALIBUkU/JGYovdZBpgk5QCmBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRs69Y+0kPiwszI+AAAGQndrbq/ifuuJo0OWlEdzVyk=;
 b=YtZtUHGTrXYVRiqGbBW/R32ANQNZedSl1pUoQq1neOs2j7C1Dbpj3latwQd9MjNULWM3IvOjPWSVZnzKW+puyzzoCL4XUjETF14+JZufhIXG96M9i7B1rhQLBxH3Mbraw6ecqRV+mUveQjis+0sgV5y8gd7ONbRhT1QL31e3F+jbsXMMOnOkFeEjzc7VHfo1f13+rdIDC2jQBMD+cEa//RQVGFgqLkVGOyEG5XE80wrASe7j5KmJFGh9AMEd1U3HpQH7ZsVeTV5gMRWNQ2r41yQNjjOevPNWqKW2TYe/RXPNAY/25gq5PY+Aarc1vUqNj/+8rJMsPfrthnq2KnaVqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRs69Y+0kPiwszI+AAAGQndrbq/ifuuJo0OWlEdzVyk=;
 b=LUtOV/q8xQCaHGRLT82hDpR268ow3iKc1TDHfkAuAei7HQKCdKxSktgau0nRwtggS6ag4OsnkF71OGbOwElzl7rw+bLmppu90uKiDdtVtn/daLceEEYx47TB8RrPneStpC4QkWxncDIw25tA250ySdu95MDgkqSfQauXv973vOd3tUfehnERBKUKqHUcV1e2BJzjrAdtUPYe8dcow9NC3RhUqwJbG7JN7BujWWJAMOmNhGL8o6wfBv/B3nkyIpcm9OHNOlRZJ6HoZlqL8Xqk3imeBNYLFddq1BViFV3mOcWCo2qAQXSZwz9fjrB5Otr/RJswNLVdllBtZYRyARqsLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 20:39:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 20:39:40 +0000
Date:   Thu, 1 Dec 2022 16:39:39 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com
Subject: Re: [PATCH 00/10] Move group specific code into group.c
Message-ID: <Y4kRC0SRD9kpKFWS@nvidia.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201145535.589687-1-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:208:23a::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4384:EE_
X-MS-Office365-Filtering-Correlation-Id: fb7b0bb7-0003-459b-a5b2-08dad3dc2bb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DsdLtY3sP2Yme2vjU4WJ8qA9IG8yjLDczz681De8pCHzytEXoEHcHkS3PZaFUEkc/PfLPwwArWFf7mNNyFU0l6dzX2qhrVm0P+BYihTviSSnLJS97zIR11VmIxp/ZN6eu1jSLT/WXYppRRiZASI2Cv5zGS/EphXj8FCssyKwkrdSGFUNGhUOxGYdHYB9VUoYBRWF9TqxxUU8hHMZliZUl8OM9sBLEvzGMbYZXevyydW5kKbvBskCdGbG5QKDvJM5vUc4btOvt0ndYal9AT854Hch/FMe49ChjwV4RIzc6BgoE1Y8iUGBbjDnnsBjS0TWNqaPBVU6uQ33GnZ7C8AjgUars4/BLtTXI9mHZ9SNxMAfNShpRbxsVjX1sy29kL/wRYu2/nJDpAmqJ9MD/M0o2kTHs1blmhVSJxurFAccXziGHsDNszhlMEww+KqY8m/A0UEdb4tZWy3h0bLxr5JYvidYXmj0ANFwTFA4FRP72FHJVqREAqsZrRAyAIZ+kQnDtjo+lakhyK+yRJdyk5NPF5bjztfTENEd6aQtgqFI88hne6W4L5XGCnG9GA/dVQQkoAx1Oki3Re1nLhclUF/YnQH6B6khlYIkVSpquxu7SfcNp5D3LyoFSWRQLzY8VISsSA2aRRxVLONs9zGO+scDvlw6ZhfLqX9xe4oyjaOC6Bn6c011nRg0PKGPtjThb2NtHzsbFFvIfgQkEqCNY1pOESETjpKWacWsTQfgcs3yVE7VXv1O0//Rp1S5uMVEWQbI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199015)(2616005)(2906002)(83380400001)(38100700002)(66946007)(66556008)(8676002)(6512007)(26005)(66476007)(966005)(6486002)(478600001)(36756003)(6506007)(186003)(8936002)(5660300002)(41300700001)(316002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ILn7pnSauURYW1xkE5XAiLil+qrDp8UKf0kJgxAelmNGylmWWVjC3Ez7mphT?=
 =?us-ascii?Q?Jm6s8Vok7QXeJTgKudSzsGV6ucF7ajs27JeJTGjkqQKxkPNukaDyE365V+GC?=
 =?us-ascii?Q?21qgvDe1EllnOdyrdyDKBNe7gVVWj83Lk1YN9+BEGmPfkPu9HSBzGHX61TJ7?=
 =?us-ascii?Q?dS8HcxBnOHylRWtauuKqmD1nmXEBi7eJlorRo6t7UAaTjNtDfCvla1O13CiT?=
 =?us-ascii?Q?hByqka1+m3vN9YCmh/gJTHAe8x0FcWCXVNsDAVmz+9JlUqb9U4d8CrOa84CL?=
 =?us-ascii?Q?/jOn2EM00/krr5HoYqlU4aSJmAJI+ohgfzv/Tq0DM3O3nKqkFrAMMcq7TvvX?=
 =?us-ascii?Q?ot8Ubq89jS+Fw+2oUIYH8RJvZcMeHekP1m+20pIEVYG/WdQd61dofLiXx8px?=
 =?us-ascii?Q?WyCd3Yf5KOUNZrNkmrMVSTIExVTs5NOmh7Ego+dd86MexiRVBnf3Wan0YH+V?=
 =?us-ascii?Q?/JLeKotVfGI3+iq7364MmItaPoeDA/enfTnvXXxJTXDwuh54AfYRtUa7EM1k?=
 =?us-ascii?Q?JnoRecz0Y0gOjSBvigqIwENhBtnQJYsX+8qvAiGXMXC+n+rwBGAnq7J683NO?=
 =?us-ascii?Q?3XLP0xqxv6+QiBvt5qMfiB6LsYOOr173+pO26nd9wgbAP+erkVY2sW0RxBRJ?=
 =?us-ascii?Q?HXEX4t3R8wMQhi9KjpU1hIDxV4cVmocowsbZRfXLhXC1x1xCrYHWaa50Et2P?=
 =?us-ascii?Q?nTFLuWpuWdflu7/3lR8fARQeArEIgrqBm+/VFaHdbiqcidjGf3DnNlcFlTKD?=
 =?us-ascii?Q?j0yTJ20JWGyLFhGTsyGu0FZnI+fDjXhNwlFfmruSyQcVf9ysQOz/Ex6SiKkP?=
 =?us-ascii?Q?cUtUKXpsiumReNa1oGQkF93+gBgiHYcmKBoWnTcQak+qW7nU71O3E6UJwKTc?=
 =?us-ascii?Q?DyAouMnAoUxpooKjViUxIz0Y34lHeMbsB18UW3F0NTl5U6Ti2CTasNEwTFgi?=
 =?us-ascii?Q?fDk0qcPxpYLGOtFCJB9donyMS7H6/+XpuiqnP1catOKVP69n45WcuW03bFdA?=
 =?us-ascii?Q?I9HhqVJiR2ibIDGrUCV4JblqZIaQNs4DZFvcXiygnHZBCv+zKSIXZ/Jtj5F5?=
 =?us-ascii?Q?bG1JGi6J1bwjmSS7WxXuk1ZNAEE1StzkVcMeHJtDlOCBfwYbPA3OrEU6sENf?=
 =?us-ascii?Q?NgClZPRihfq3hmuIkvlL/VtCSD20fJw9T/DML33F4net8SnSbKENQBAWCyu6?=
 =?us-ascii?Q?mJEtA/7/ia+q7+eg2UC+SKfiwlw+RiRcKoCKck59EivPeUZve/m72MKpYRmm?=
 =?us-ascii?Q?jTCyZ6AGpy4CeePUFKGt68gesYLJfGR7KP0jmo79jNeEJHAqlxlihdiqh36T?=
 =?us-ascii?Q?+aM4rsvQDsT418yi2rVPH5AJ1FEi6g0hW/qyAYYZwOg5yKbH5W3jZrDqGlLR?=
 =?us-ascii?Q?iTbrHyv+r+3IZoWu4BqcaqwgzE4Pe2a9qbZycDMbb5WtA/OcIqYaJQPbywVh?=
 =?us-ascii?Q?PhAfaFxCFcddhEb/RSSvR9hP6EW8cLqB8WDOLxdd+SuXhubkmVo44bnCqUyC?=
 =?us-ascii?Q?axwTlpAI9miQB8wE+yT+lTdcyRcJs5A1GF72ZBB4+XEQmAqkNydQ15D5DvVA?=
 =?us-ascii?Q?zziOhzQakvOsrri8LMg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7b0bb7-0003-459b-a5b2-08dad3dc2bb8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 20:39:40.7539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHiMKG7hd6EVThu8nY3e6N+bnxlmZuYVPLdWpS7mYMqZ0mdmxrZWEG+rFWE0zpim
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022 at 06:55:25AM -0800, Yi Liu wrote:
> With the introduction of iommufd[1], VFIO is towarding to provide device
> centric uAPI after adapting to iommufd. With this trend, existing VFIO
> group infrastructure is optional once VFIO converted to device centric.
> 
> This series moves the group specific code out of vfio_main.c, prepares
> for compiling group infrastructure out after adding vfio device cdev[2]
> 
> Complete code in below branch:
> 
> https://github.com/yiliu1765/iommufd/commits/vfio_group_split_v1
> 
> This is based on Jason's "Connect VFIO to IOMMUFD"[3] and my "Make mdev driver
> dma_unmap callback tolerant to unmaps come before device open"[4]
> 
> [1] https://lore.kernel.org/all/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com/
> [2] https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev
> [3] https://lore.kernel.org/kvm/0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com/
> [4] https://lore.kernel.org/kvm/20221129105831.466954-1-yi.l.liu@intel.com/

This looks good to me, and it applies OK to my branch here:

https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/

Alex, if you ack this in the next few days I can include it in the
iommufd PR, otherwise it can go into the vfio tree in January

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks,
Jason
