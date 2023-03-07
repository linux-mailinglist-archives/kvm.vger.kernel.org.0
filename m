Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CCC6ADEE7
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 13:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCGMiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 07:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjCGMiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 07:38:16 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4386B2330A;
        Tue,  7 Mar 2023 04:38:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Itj2NMiQsWfRhkYeY7eOJSWz2+CarNEAtIPeR/OyId2HvbUK5vQ3b3rvvNGaX1HEMUwyzt1loCW/ux13anl05cUhRPKiPQz64yPkN+3Q1fnRPmBZDztOOioGkWih84/bOHUcnsF7wPJuLJfR6qoeCttASLndotwpI0biHIHfKcmd4Xg5TEqb/HGbFbqPiasFz1te++SiiFFEG2Sfc07jb/xM6bDO+4KAjmKLZcuzRrSWtghRlkuaS9CzjPkApwC4bfj6fDpvWTrUCjsNnWO3R5TsLi0uBjWUBwxIwHqbuNJJTdQQgu1yVqlcvN3b1Y9XWTii+7Ryz6RzLIsVGGLIKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MmJm9eIWp/Bp5kPtXPF/q/cq2LZ73lISFXJgXf3W9Kw=;
 b=csQp0vhkB7VQjc70GYJ2Z+YgjbVvt989B6bgDdOkbVJwIs+rH8FOMYZ1Fy91THS/OAaKTelEH0d4cpXXxtEmbUHIMM26J7m03bC/sl21srSFzfP2g1LXkeup17NPCTk3bMnbb7EhvBasyCEbwrVTknQ0j+0DPPz5x13ykw1Tccl8r1RgNMrCiL+5EFXL1JqFeVsvSskX4lm/ErCABlRohM7vylW6S1rk88mDeaEjZ0JKHx3Ijmd5X8UfNAIlJV82NbhLF/0cTg4l9S3Flj69lUdFs1lgfi9SEW02iZr9LU7bWjXgfeO2plK0uJKmF+0YaWmNAxT9Qoe9TtcIP226Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmJm9eIWp/Bp5kPtXPF/q/cq2LZ73lISFXJgXf3W9Kw=;
 b=FcclCbf5tKY45S/mvCWTI81KE7N+Cp4wb1wSniCGHYzkC0MbQrBSTYNNwdLEdHSUfWWMGlxnx8tY+VohlasNG8rTCx/yFD1X8k0Q0h2I9a5vSfg7C84mquZAbNE3gnXII0kJB0fzMlPsIlV8xposUl2bfom5HQyYN7SpVAmV0JapNth082DLc71Ad85QUdWsQ2zVuVJ4zFGkP+cd1moAT1Hm7RkogLkDb8c9oiOHTu+Y19DWVNO5kLqXXVnmm+IsL83UmHBd/5g3dzwJb5ZD2YRy5g/1jyZQIFfaynK2gAn31Vinyk0hjLaQi3RrJ3Ond0sC0w0op2oOVMefDYMMVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 12:37:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%5]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 12:37:59 +0000
Date:   Tue, 7 Mar 2023 08:37:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZAcwJSK/9UVI9LXu@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-17-yi.l.liu@intel.com>
 <DS0PR11MB752959193D5CBA2A677B1F18C3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/+Pkbtr8KQmUjVp@nvidia.com>
 <DS0PR11MB7529E16DC2B558E8476D835FC3B39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52760241BBD8D6D670BD17D98CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52760241BBD8D6D670BD17D98CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:208:2d::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4413:EE_
X-MS-Office365-Filtering-Correlation-Id: 869aa8e3-80d2-4a2f-3013-08db1f08c8be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c2fZhVQ8jDk6kaWeOBapX8ofIg6rVTfeUprBEQd3xyuwK48hRq4kANF9f2sL/g3ah1AesKYjNT5lVLwqnrWr259PUB85oxOad3YlBgt++A1ivV5I4NJV5JuppJeiVPng3xm1lkFL2dsZlkAFzcbZSmldJu8YlyNIt3KcP2TlwRjahVUeMrx2sYNfgla1zu539lU7DAXi12yy6+tKpz20XoE4sulTGNukSKUUSswhKPyeHH4RtnhIxZj4bLfoUpDCNZcX85Jz3xZyHB4oCj6+O/kXfnEFWl6suxCG1aFZjZzTAuZjCYxY8MgrqBJ5u3fcvxKAT2JQCM3yPfv64ex5Yd6blV6SpPUYEyv2F/z2xnEMKSOdYAAUIkJh9sY7ip+nVtr0P/tR+XfzKI8M2xnNZpN91qUa+oNEPX3pq8HNx/aFnpHvnoK8AjvEERTs41GOKEKR1ADdMP/DmHyvjaJzeADqENKB85LWa2NNUtnP7MVEDcofg0XTECXK+7W3SljvzhIUKn8W9ZxoeN9ehGDq1uTNBnRkWwOHvrG1QYx8a1c7/pRh5BoB+sUTNlE8DsWNHYlONiUYdrsmUyawZZ/U3XQFPr9S5Qx/f8D5d4N2IETNl8T8ce6mWodj0Qtuha05b9FqEZAu/5DvgafE5on4aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199018)(41300700001)(2906002)(186003)(26005)(6512007)(6506007)(2616005)(4326008)(66476007)(66556008)(66946007)(6916009)(8676002)(8936002)(478600001)(38100700002)(86362001)(36756003)(6486002)(83380400001)(316002)(54906003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p2PM3O2b0vmhq1P+kTBWp8dlBtHkOIUUjZ7pPeTgykil2TWqVEuJs5JkB86x?=
 =?us-ascii?Q?Y8sFhXsM++oyVfxy2Xo2CD8Wqlf4o/F5Ph9r+d1ooFCsD45gSyEFMUs9ppb7?=
 =?us-ascii?Q?QJ5KgvoQo7FsCwX4snZDlhhfw5HcE5b0+CZHEPf1YJDcfQBYE8WxVUceFU5b?=
 =?us-ascii?Q?wy/pd7GkEFzNb4tcfy7Io0SuwdcZ5aBPV4ff6Y4ijRkD8OAsYI1BpS8Cdkq8?=
 =?us-ascii?Q?EifpOCOUJ5WSIaNLzYaWeq5qhLBpB+yOg4kpOjdFAwpAVBi+dXu0JYpDvXkl?=
 =?us-ascii?Q?+XHFBMSMrybht1e0DrR0Lr6PeycZ6bcHjv68GT1CmUS+NPfwD2NvsKsa84ZD?=
 =?us-ascii?Q?mklLrnw+yTOu503eezqHgQwlVbgjt9qVv4diw7GyY3FV/Em7IjiDGTwRAHF1?=
 =?us-ascii?Q?1u1IOSPkUcclsNAhvvE/MwX/fpN0UDYGMBQZ0Nvogk3rVbd7bxQlGR2YEa6K?=
 =?us-ascii?Q?E26BG3WDSQasAnChS68g3dqCev9gsE/D6JBWmtB5clbmwZ1heD3EejODGykt?=
 =?us-ascii?Q?DpieRnAo7X3j2J7b4u5FwSxqA1hP9qlIlXdUqbXQXAnv8sKRtmMdh58sX6/s?=
 =?us-ascii?Q?YFi1aSPFlqalssGxlpC+Dg/4v9qUTNPXGAhGUK+qOj0ktSf9g9V/ZQ8TA5gY?=
 =?us-ascii?Q?ASHpnDSAW+Cmxe1dAuUzZ6pq+bAN0FkMfaxWqRHnGY3G44KfAWA4baHlHnAq?=
 =?us-ascii?Q?xxQ1cOz1BvjJ+Z/16jwcoB39PlQTw1ac/JHgkraURcB1+QM8uwlW/DtjfFn7?=
 =?us-ascii?Q?1R9UD5ZWJmj14MIc9DWiM9DJYccrMuC86qjo/vGUkYCoZXyIYR8aqPW9HXHb?=
 =?us-ascii?Q?eU7ZWK+xFg9ayLyg6lPbM5W6eJhY5vl25s4JHDsB5lFJoBtp4LyZCTE66xrZ?=
 =?us-ascii?Q?4bYiPGt6o9hYN+I0jMoQMsCRgLWYZbzwa1YUnAKntxGlEyfNz3ieXAujuhi6?=
 =?us-ascii?Q?UmaIVxIwRLfVk9KrN60jb0I2UlgIXRyaRGmHR5/6o2phq4FehOr2EmksccBZ?=
 =?us-ascii?Q?w2dgu8e26PukIfHhaXY/5BBhhGErHyUiorPlUZ+TujLsO9MxSsG+9aMq9KXs?=
 =?us-ascii?Q?w01eoxHyBwN14+j4VhD/bjfc7yXKj2+0qVj20JUAHP1s3BJj3SLD0fiQobyD?=
 =?us-ascii?Q?+pMNAnvnGFb1t0iAsl3VU3H7H/cfRKet5jY6gdQXoVyGJxtJU+eEs2a3HXEI?=
 =?us-ascii?Q?r7EcV/+TycbJ5JlaWpd1TvRsdSUsKBXoJCxHgZAu2YtK7wE7UboSQTwMGrEM?=
 =?us-ascii?Q?XC9BPvGKAEWNVv5aUlsAfRvQ3DzWtp+t9rEI9gU1bNn/XCLjik6soORbxGHO?=
 =?us-ascii?Q?MOXDaguYjlF2Iur9l0s3YGMTCdhMS2BALArcSVJjsRzO1Qz014sIvQyUoFH5?=
 =?us-ascii?Q?fREyEYqYVpKoqqt4GG5/F68+z16JFuVaY61RI7x/AEeTyjkb8rqJ1EJBzXQ2?=
 =?us-ascii?Q?mafKaV7nc36Ar3UkJAvCZIe/U/TCln9YVFYb5uE+9XceFeos1g8AEZRmIGR+?=
 =?us-ascii?Q?Ueuq6i293UBRejszQVtC/w1fayTk3h2WFszPbjD37b8eIOAMDw8wQw+/RFix?=
 =?us-ascii?Q?JWQ4HWKETa5A+6ehq9/LIfEGLJSq54w6tpwR2PQp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 869aa8e3-80d2-4a2f-3013-08db1f08c8be
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 12:37:59.2883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CenDDLScrVULRs7ScwYsvsYJ/zjVTpRnH6X3QhhSuLQwScDlw2NMbmB0yVFtBtJk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023 at 06:38:59AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Friday, March 3, 2023 2:58 PM
> > 
> > > What should we return here anyhow if an access was created?
> > 
> > iommufd_access->obj.id. should be fine. Is it?
> 
> Thinking more I'm not sure whether it's a good idea to fill the
> dev_id field with an access object id and then later confuse
> the user to get an -ENOENT error when trying to allocate a
> hwpt with an access object id.
> 
> How can user differentiate it from the real error case where
> invalid iommufd object is used?
> 
> It sounds clearer to return dev_id only when there is a true
> device object being created by the bind_iommufd cmd. Then
> the user can use it to decide whether  to further attempt
> dev_id related cmds.

It means we can never return an access_id

I don't think this is a problem, the first thing userspace should do
is a get info to the dev_id which is needed to learn which iommu
driver is running it, if that returns EOPNOTSUPP then it isn't a
physical iommu device.

Jason
