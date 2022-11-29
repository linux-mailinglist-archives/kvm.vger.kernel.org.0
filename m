Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553F063C9D9
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbiK2Uta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbiK2UtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:49:15 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4B270440
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:48:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIl5taLUFNvJ+TZ4rlIDwMFkvVveHVjW6g40Be1mCkAIowzKHDCpDLmakvivFTaMB3utt5X4iaqpyySkJXEgUqjEVGKdv6hwceCOVf8C1IL0b07Y5FK0/NuFBeBH2pGQ8Krz+BEANs97dn24bqd/V7Xzv0MHz+9x2JcEd3Mj87/nez0nyVbmBNkFZX0S6yX9/27WHN0rQd8LRdVBhId9xXDE1equkf5uxQfFBt06I0SPmahHj/i3+K3fibFAyn3O15PBR1fbG83l1+8bVJ5+9fZOROvfGwS9k2qXXsguLmoUiypd0eOyH+EQPJbceslaeuHbb6FVKcQg+dazlwYpww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qX5VtOHFzjB+jkdCsLrzsOWFzCgXV38URwGljqVtPbg=;
 b=fuEieWZnBnd3+CSmkVZea9kY3bW8k7Jp/A52zk0Z91IndlrOVRneSOUQcVmT/x2ZgYUljW2cGgb70PfCAPuzhBXsmZr4g6cZXA15HzUFGFRVN4EiNdhe/mNvXpg6xDG34t91wQiaqmdYjFkMyU8+/pGOa3kUpYK3dNNprxH5PcIWXiZ0EKPWopNzQhm3LC7SBi7bFCWbs7KsURau46+ggFapCV2e9qJrXRNix+6kKeBGLgvjipL3sJLTmFLVp6JSIXWhtge6E1kuwpSQXdfUB4DETTgJClJmKTlqNZZlnAWqVr9z2DLOgLabOh92/DNruae7IQUV80vTaDjY6HqWfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qX5VtOHFzjB+jkdCsLrzsOWFzCgXV38URwGljqVtPbg=;
 b=NmQOeCluQYSvWGpIq8aYiGc1R5wNnph4cxFW0RBKUOCwc1OoqLgY4BeXP/ZK+fMlrSdYothHWaP2iqzy1lu1LKf1gfp7wMv3XT+fYHbjEWhhgJmEOpVAqy8fuokVvdOhGIfAmotCz1uqnHLPCPfGgx9ASWuacvKtdwDoCLTfO8ql9GwPEnae8sagQexA3PQe+XruliBMStfNBaholetHjk9N8aX4ZHkYU7tUQbJn1cb0kaHB0CDlRkcZFBuxWINdIXHfKOUnIIA6ne0ujfnDbQkShZmTDrdAagLm2oRk9dk/vyPC6aO5Wx+mlUk631NAXbW4aEC7iBQwa/RUzL7XMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7456.namprd12.prod.outlook.com (2603:10b6:510:20f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:48:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:48:17 +0000
Date:   Tue, 29 Nov 2022 16:48:16 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v6 07/19] kernel/user: Allow user::locked_vm to be usable
 for iommufd
Message-ID: <Y4ZwEJotH0U0Qzt7@nvidia.com>
References: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <7-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <20221129154048-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129154048-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BL1PR13CA0331.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7456:EE_
X-MS-Office365-Filtering-Correlation-Id: d3346380-c415-4ea6-8044-08dad24b0b0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: itbDKuUnPD6YPNchxARv5R++pDlCHeVuNLdFzr/zTTnUDYo8wpC82ZAepy9c2N6agAiW7D3U2iFWC9Y0a8ndgep6ZT34BaQwVrMOR3shu66Sq3KAGvcR5DJfnCR1FgomkaEFw2stO7ArVSYkq9nqnuCAJNyrmvbbQoMFATsrzH1nf2PxdqK34fGXqSWsG/m/7r1nLXcf7NlD6Reu3lP8Xq/nwdgjAG5deEh7LnFEiggkyMeGgxijeZOQjOZ9iUX9YaHD8//EZUaFSugAx4xeBRvAWYIIrpNPfOjzhkvhDHiwbUTgHx6Zhi8KxTR1OE3Y0UPl3cNQsxNsbxBm2muAnqqvj/8xwKV/3Ayaf9m+0nOHPqLqgy0FvgHvJFQoeD5IJiEtngGanI+GLYsDWSDojYQPRxX07FaGVXEe3f9lUFS/WXK3Efp9esbr2yVx0QT+19Nza9FeTLiQuNLGMn2K5d4HVJE/y16p938wKn4e92G2ELUGx08a8/hX+3BTidXyE4BTzYmNrIK9ltXtfWu4v3r4i8HfGk3/4yYw/CjVPDtqN1+YDFXUNUZJI53JQeo0ZS/rnE9MmJ6ilR8H9qbU7pxFY/R8Kuf/HhtaudWpVKh/oojBQMCM1fvAO7MPgDIs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199015)(36756003)(8936002)(6512007)(26005)(4326008)(66556008)(66476007)(6506007)(478600001)(8676002)(6486002)(2616005)(186003)(86362001)(2906002)(83380400001)(7416002)(41300700001)(66946007)(54906003)(316002)(6916009)(38100700002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BmIk9Cu5lgqdt0JmT6iW4OOulaU1RAvSoqbsl3Q4Q9T6T2uQ+y/Uvo1G1emU?=
 =?us-ascii?Q?eVdC3sUz+fJfLZE+/15iSj8Xf8pIqqq7VSHHbYBABr8axr4Fo/0MURER2FNI?=
 =?us-ascii?Q?HyNVIuEg/Cz1W3cpvOCPBZ8l6UkbGBVd2nnxRes82+ueCPF9vKemaM+fu7hp?=
 =?us-ascii?Q?jqsfzpvD3Dtg8NEUdcMVqe1aQXowV5gPmn678dD+Whqw16VS0F+mtUmDPdnb?=
 =?us-ascii?Q?Y7M++w8pX+VBGPEcprYCNQMzaLmXOjw4GcqLBi2YbiE/5doTA1ZMJk3MsWMY?=
 =?us-ascii?Q?XzzY6JpQdApVfaicqdyK7HnmNoA6mNyPZwDiDfXBPhEYfoKMsbbkrNRCXD7H?=
 =?us-ascii?Q?28cAYDZiwgzvIPratJa1DTr6E9cQt0TuS+LnoQuZDrwy0Ww9tsjhDjfOt5fM?=
 =?us-ascii?Q?feMz+yeqttI9jPLBr09n6JdaDLd2y0P2ESpKH/e9dxT2pBUaHhchCtXzqEn9?=
 =?us-ascii?Q?VRx+yNl6BRLugp9xy5I+SmCWak2GlVjxjOd+pdbjhLKZM9+FYkAqk9atMeg0?=
 =?us-ascii?Q?pjJPyqTofo1imqDQnsQAL6JcGm6DSWRxcCdFH5CdOaUhoz+44YPM+CPTwUsG?=
 =?us-ascii?Q?ILziYmFaF8wBtStEiFMw9OF+TI0wBeMfYsv7aDSokCVcknM9B/0vE+Ke7sVn?=
 =?us-ascii?Q?0yHm08skqFbbPWiftvIxuyRB4vbonqYOMA8xOBiMFoYpPBndt99TFLDKjDTR?=
 =?us-ascii?Q?B+z14A6POq8timzSgZy2MzKiiVnrFrgFQAmSGcwzYksiyjePPdiKt4L+TN84?=
 =?us-ascii?Q?gesK8rgxBqfyiYQM9MNZHmLtBeqTeWwaixLXhmxgp7C5+a+CwHNDr5XJq0/i?=
 =?us-ascii?Q?mmPd+A9Tq0W7b8c9GBBHCsq/p9nE1JxsQks1QhnMH3AynTYYOhO8kaofzPma?=
 =?us-ascii?Q?PQxdMY33RmAyK3yDy9r+jAC4XN7pq/VpQygH1mE/Y2RR/dK3o+trfiRimgls?=
 =?us-ascii?Q?xdCR4glhQW+pg8m2e+fVaMSFNfo48ly181k21nvqZuSyKhEpfaWJP34XjloE?=
 =?us-ascii?Q?9zpbR0BMdh8pGYA18Wti8kG1OGCSj5QhmawznRyt8Ge8yzWsqTRBPjyiWwvA?=
 =?us-ascii?Q?DPqdbKzDBsdsU9XLXhwkkvGqhOoUCTGPML9Hzz+a8lepPZsRx9k/gZi49R8p?=
 =?us-ascii?Q?tWSYGAIQBrzS3XNDSUuIbpc966/kAUOYRBh8dBygbA/KqM4Bn/KeLBRUJ3E5?=
 =?us-ascii?Q?VCwzp4ZBIz5RBhtQfHs9BvLu9KpBJl3uN9LlsIJoa/1x0Uo3oLBVd3k9wqsq?=
 =?us-ascii?Q?CCrgqE+cfoIcnaUpUHQalifVBzz9zG/LnZlJWpEZ2kM+8PLNcHzavGZGIRaT?=
 =?us-ascii?Q?DJqJdUMaytpn3VQEineFvGNaJv1Nr9liextI8IAJjsmb9YeYf9CBTzVBQNku?=
 =?us-ascii?Q?Aisr+5j+M7t/NrJ2VuwjIy++lcqmHLUnPjc12+aBIkc2Th01fGH1zbycXYNj?=
 =?us-ascii?Q?MDqUD4Wgfud+laelLQVDH/j/LgQstrfNCKzq14g+hKgGIGAQSyLsDRa0v2DB?=
 =?us-ascii?Q?Veyibmud+m5GYoB03KogpBQIaj7qljfrsUA6vGC/TJZbLnqDGuwFsheDCA29?=
 =?us-ascii?Q?SI71P5/RDI5IYsmsDfg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3346380-c415-4ea6-8044-08dad24b0b0f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:48:17.8635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: non1Av2nWCQlCMIrd316Dl+4G6pwFSLaOZwmuSscfx5oBmMg+wpBG0L3o6KG35ta
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7456
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022 at 03:42:23PM -0500, Michael S. Tsirkin wrote:
> On Tue, Nov 29, 2022 at 04:29:30PM -0400, Jason Gunthorpe wrote:
> > Following the pattern of io_uring, perf, skb, and bpf, iommfd will use
> > user->locked_vm for accounting pinned pages. Ensure the value is included
> > in the struct and export free_uid() as iommufd is modular.
> > 
> > user->locked_vm is the good accounting to use for ulimit because it is
> > per-user, and the security sandboxing of locked pages is not supposed to
> > be per-process. Other places (vfio, vdpa and infiniband) have used
> > mm->pinned_vm and/or mm->locked_vm for accounting pinned pages, but this
> > is only per-process and inconsistent with the new FOLL_LONGTERM users in
> > the kernel.
> > 
> > Concurrent work is underway to try to put this in a cgroup, so everything
> > can be consistent and the kernel can provide a FOLL_LONGTERM limit that
> > actually provides security.
> > 
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Yi Liu <yi.l.liu@intel.com>
> > Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Just curious: why does the subject say "user::locked_vm"? As opposed to
> user->locked_vm? Made me think it's somehow related to rust in kernel or
> whatever.

:: is the C++ way to say "member of a type", I suppose it is a typo
and should be user_struct::locked_vm

The use of -> otherwise was to have some clarity about mm vs user
structs.

Jason
