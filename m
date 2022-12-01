Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608BE63E6A7
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 01:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLAAom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 19:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiLAAoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 19:44:39 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A852E26105
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 16:44:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5g9SI1y44nJBpkNN65SFS/egkg7RXXPxNSYkLSBtvt3luLM+M0a/Lg2qUITrNzQCi3fxfOTcgt/jYq6AJj4ccWs7G6eJx0cqtfaF6q9piuYKHBz1B5qEG+7T2t2sEtCxgY1j4f/SLSMB2vyyszze+lCc6OwVvBDVWCeba8FPLa7qWOtjU6Vn711EuO2B56A2hSkvj5192MXczK3Kl4gAwVeFNy6+7ZJjRW53bNMQWM/XiLhuEGiIkilDYgzphWxOdGNdNimWJ7EHQhx1aQux4Hcwmz69Gfb5VhoCjvxcPzi+7Ai476uF4glwCRvuAsdgfhZKEY3VkBhfgnJv+h7BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HReZfrhKyvfFn5oMBhDxIhti/xsxmGsV3FRltSqrLcQ=;
 b=OnZaIhRIGovyVvEt+8sAzdbVWgEzZQltvERA0oiSDfww6JGoynBD7SNH6QJblVlwe5hbbTutk1Dlw2z6D21MxlSykx5S6KU6xiWq2yOqlCWLRx1/wjBOdgxIRWrPymh1QNeKgyfSHmq6th6A01oKAuBvzBk8t7h0+HkUe9yb1bliBbPDztvDva2QJJdD3prbmiKdfIup4lTGK2/GjzqGNckJx/vGgKYTIb2Ezw1MWhZE9eKcPKlzGH16i8fO45XnVpqNfnypjew1MyEYGTpsau3L/9IGVsKxfQjHii9hYN6SH0jLXG7lJsWe8HHBI+JGvgNjRuLoB1FbmnVIbsf/uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HReZfrhKyvfFn5oMBhDxIhti/xsxmGsV3FRltSqrLcQ=;
 b=Ee8bXNO8VMVgu6seEJUGIU8BPPh2cVeU8JHyFYM2oU1XVYhQOllgglTs8bGgT7dwcOLUVEE1zjUG2h8XvsdJHm+QSr6lHW/gCvARpHOeWf6Echefh1ivvWqk05BX9cENrqgHvQNkOIfHwehP3xpHgGgoiMYVk247zstCeEQRMkg9OR7XiwzJ+s5aXmD+uYuiwVZuBAB6othod9zeN7jerAQ119191onaPDrb/JgclWl8HVjbHIJMZIWzDFSv7/dYeT4pgKLU0vUrERY2jBlcnmrol9XM1oJhRBTeUUrj27jWpikB4mCSctgtOOdHFm7qKXFX/tQjvYExYMZWcT1boA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL0PR12MB5508.namprd12.prod.outlook.com (2603:10b6:208:1c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 00:44:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 00:44:35 +0000
Date:   Wed, 30 Nov 2022 20:44:34 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v4 00/10] Connect VFIO to IOMMUFD
Message-ID: <Y4f48nvjjU0siGYg@nvidia.com>
References: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
 <20221130133455.3f8ef495.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130133455.3f8ef495.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR02CA0103.namprd02.prod.outlook.com
 (2603:10b6:208:51::44) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL0PR12MB5508:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f3e6298-0f05-44a9-c791-08dad3353804
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vcP09sPQocVLqUE1p3XRNNQ59vMiytFjw0KeRjx4C1Zo1j1Ncc/DdSZ473pzx3aLf6+g8NVyr0M9k0zzF1v6j1KDwihHheJQD3JiOvngqG3iEZ2sjldi2M3/BWa5jkEJ/RpBgthOJMQGgRbr2dthhAMKjhI0rzw6n22R6bJIGPgql7tVkapDLjb0fjMupiEQYcO0t0emYcvARXZIxnxE6Wunzr4GauCV06qXmtAkerDDjWxS9bl5+dsRLuif09OOy7OYBF7Q1P4dlqrNtK0UbWaEwkkq4suVMasvH59vhQ+fA65HFWw5OydIr7NFPzYr/1a5L55BNtshqniy60WnF2NWE9ccFod5rpfhdoTeAEgKmDqiJl0U3nXqDeM0h77BKuOsISdsJcWYaXBNlWzyMuqO8UQMj4dyl9X2Yf4nuZ85sZ7qiitf7nfGSgtHNpVtfXH5Nmchx03PFQocq/l/4su0shaULuB56RrNjTZyPPjmlKv1NCxgzvz9I3qaO9ROE/ENnrMz6SdtlXzUgKe0kPsEmHCCNrPiPi6NxfOmy1peJguEiBaKR2T8JOpRAr0AgnIt/TKDwHFcp6T69bDmQ2H7hcFW+EfVlEzR4c7CPpQIqQ2knzkjiZ1dzukf1peZN3EYda36w72rnMK3JYrg/jbvCV+92oZOAgHvJaTebaqRrgM4bglF83+f2i4WtkNo/Io0U0Tx8Z0yoNk7WgEoYmzinGZ3NYOVox5HIlX6/vwItaut/k+rLV5X+6S9vCcv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199015)(83380400001)(38100700002)(6486002)(6506007)(54906003)(26005)(966005)(36756003)(6512007)(86362001)(186003)(5660300002)(2616005)(6916009)(8936002)(478600001)(66556008)(7416002)(66476007)(41300700001)(316002)(8676002)(4326008)(2906002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s/K1bOdFXhg5we7kL94iiQ62UTfNDV1b9Pr1WP1COk+sTrpM50asfAmyfV2N?=
 =?us-ascii?Q?eg3vuFZqQKm7Ho24rrmwWhAL+W7+A5sbGv1qb6uVBANHdQ8VBa1aAYBufFef?=
 =?us-ascii?Q?RxhUdwlstrX4dYUEULlmvRluxeqB+TmmL4ncpK62rZYvbt37qLGDOBdu6G3H?=
 =?us-ascii?Q?XPSGMgeW9Q6mNpaj+yucC9Sx8dUEQg4MzAa2+0lqT2C7NKBIc7BGjs2d7u6n?=
 =?us-ascii?Q?Fl2669GWyRt2bNQ16C2ih4hM8LPDXQ3e3aMllb9woIYRj8xakfCyh7Mu3cEZ?=
 =?us-ascii?Q?HifMujaWgFMUkAvBTOW7tyn668lNSXIWUve6ytgOVV5d/zG7FBi8tBZczFbF?=
 =?us-ascii?Q?RtDwgjNCF8ttZn+WxLlWgHz9GgzUgrgjv0RFBrYG7aLjoQcUY7joQssSXWLu?=
 =?us-ascii?Q?exQX+4T/cYgOjjvSZMTRKO+54zvXX7e5YRYQOBusYUC9EYZ75Y5Kc8COQ3VG?=
 =?us-ascii?Q?EbMqF5LuCI1ZJTFY0NJwHY+DYcnA3/DSIQ+DSj3hmOwXy684rlgNFoE9Y5Iz?=
 =?us-ascii?Q?Zo42oPPVXmpYwsvG23vSRTduXETx5+xDsnmY0TeOTo47Q+GM4cDtMpmX1PFk?=
 =?us-ascii?Q?SI4CQwlK6cqv2CmqAy2411O5L/zmSCSm/AgnH0DH4d1V8Jn4f+3BMguKMQIp?=
 =?us-ascii?Q?jhbR8sPSLhW2ldyupC+V4ZXp6tT7FYTdmHGf1WihMIpW61qnzPU7ltEnAze4?=
 =?us-ascii?Q?pPa2A9ZJ5LOqhFiPVFS3UD5+vR+KdEayIZcZS8dm/81vXR0OZlbvGcHz1oWK?=
 =?us-ascii?Q?Rm1N6VCkgYL+j+pRtRf2469dGVMs7sIxeDqXBK7Bruzm2YpgTzHtc6FIPC4U?=
 =?us-ascii?Q?WSL4e6l8esh5Iy7KQTzmXqX+iaFg+Hi11tVI1tBThmwFXJxpRJmipqWmHGfX?=
 =?us-ascii?Q?bb4k2PDF+YC677eGWVUYZEMMcq6lvqttPjfCycZHs5EyT5PqL8zKQY+lR/0F?=
 =?us-ascii?Q?GhdclCaaEFppINDVpyZroI1AyKiOJJgte/K05BlA0ST80oNm9HoZ7B1zFwAp?=
 =?us-ascii?Q?WI77xeJC8mCtBtt138xadVN3XJ+lSJ7DIZzeNuZmbhCzhHkgplHx+qWe1J6T?=
 =?us-ascii?Q?luhSO//OmilOFXifkzEnvc//MO9PIcPJGw6Wq7XiRGgh3DrjYl/ALhBl19p/?=
 =?us-ascii?Q?xV/zyX8MYOfHvqXnodtl+13ZWLTpp6rNvvycOz03v2T9Z9IT2nRifBdPWi0L?=
 =?us-ascii?Q?X0fBd9e8p+ttkUDymMvlS75Dsk6aVMcAz7bkzp7Jxsr9lGhHkq1F3LwURx5G?=
 =?us-ascii?Q?R4ia/ElvRKNjq2RWbJiExx4eC+FwzV8OaaCH+B+A2niFSwqF8WEBsPpqnktb?=
 =?us-ascii?Q?KY2vtQM96h3Si6rPJyUeNEz53FsyYwB/6UB2k+cUSrX+IZeKQysccudtObYW?=
 =?us-ascii?Q?LD2bCHSCOaoxrkDA+hY3U19k5YqsMsJuUboSNThMPLAHqfohtjQQHdBsEi96?=
 =?us-ascii?Q?PyinaeIX2VKf8mX0XfCVSO1UYL+eVoIbRwON+idJEgOIYFl97fZOKEzLb2zw?=
 =?us-ascii?Q?1aP+jjNajSxKzqlL/sz0h1lMZX2A0RLSdngDb5Dw7uBoZiXYVaG3rQexLf1U?=
 =?us-ascii?Q?cTdrkMLJx7kle/K6dHM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3e6298-0f05-44a9-c791-08dad3353804
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 00:44:35.4473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RqDNYPBw5u9+S/fB8HAHJ0pijFdpRYB4N9FEn58qxfi6m3cYFFXZjdH2+8eCGKeV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5508
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 30, 2022 at 01:34:55PM -0700, Alex Williamson wrote:
> On Tue, 29 Nov 2022 16:31:45 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > [ As with the iommufd series, this will be the last posting unless
> > something major happens, futher fixes will be in new commits ]
> > 
> > This series provides an alternative container layer for VFIO implemented
> > using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
> > not be compiled in.
> > 
> > At this point iommufd can be injected by passing in a iommfd FD to
> > VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
> > to obtain the compat IOAS and then connect up all the VFIO drivers as
> > appropriate.
> > 
> > This is temporary stopping point, a following series will provide a way to
> > directly open a VFIO device FD and directly connect it to IOMMUFD using
> > native ioctls that can expose the IOMMUFD features like hwpt, future
> > vPASID and dynamic attachment.
> > 
> > This series, in compat mode, has passed all the qemu tests we have
> > available, including the test suites for the Intel GVT mdev. Aside from
> > the temporary limitation with P2P memory this is belived to be fully
> > compatible with VFIO.
> > 
> > This is on github: https://github.com/jgunthorpe/linux/commits/vfio_iommufd
> > 
> > It requires the iommufd series:
> > 
> > https://lore.kernel.org/r/0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com
> > 
> > v4:
> >  - Change the assertion in vfio_group_has_iommu to be clearer
> >  - Use vfio_group_has_iommu()
> >  - Remove allow_unsafe_interrupts stuff
> >  - Update IOMMUFD_VFIO_CONTAINER kconfig description
> >  - Use DEBUG_KERNEL insted of RUNTIME_TESTING_MENU for IOMMUFD_TEST kconfig
> 
> This looks ok to me and passes all my testing.  What's your merge plan?
> I'm guessing you'd like to send it along with the main IOMMUFD pull
> request, there are currently no conflicts with my next branch,
> therefore:

Yes, it has to go with the iommufd branch, it won't apply
otherwise.

Here is everything ready-to-go:

https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next

It has been in linux-next for about 4 weeks now

Thanks,
Jason
