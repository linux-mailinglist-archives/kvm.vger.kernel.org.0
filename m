Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92369B013
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjBQQA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjBQQAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:00:22 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2049.outbound.protection.outlook.com [40.107.102.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F2C71189;
        Fri, 17 Feb 2023 08:00:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCvcHx0h/iqcQ3nWYJ76UQQ2dZHMEqw7ctlnyPgtlXh+shsvrSa68jFFlawRrIcL9YYjKylzqjhY+2WOM1aaD4j5/wN+PGN3XFuEBVx6oNEhXuCShsFITKrCNd+QhJVhw01ZpVSXtxQ1OYZqvjqxn8Tp5+cNqiBiLasOSdxxyXcZw16pLe2YmjQtFmol38ibdYy0zSLjcd6q+AGb6IzmXwgju6CAX5zjzF0dLZpcSbz4oVilih7vuXzSn1A+O1tam+UEhG+RdpZqyV6gJyHHvETZ8i685HWwQbgm4F18t1PizAseg+DZ6KgoyfKxAKd3sJwhPmdDtlN+OyVwdaWerw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDTH35pF5Qz4pOdYyNxXJArA5ARXeZ/iigdjwrnHL/w=;
 b=buS1r4PZwoHXPMbcMkqmLtcEyxGXLh2NpjJyl2NGnrt1MTB4yDwNQHGLm0KiYRdukB2iBmZbXyIAPlr0vLYHyUFypcpssx1eHNkcrt8AhHCi/e4+726dr1qZcHPChu+B+j4jPdhAk17EZCH5VubVW9Sc9MAkUHdGDB3lKoXAoZglDqiXOfuCSeTZ9F50HJ7ubJxfmwFr1iNmtdAvp1N5yLmrzkFi1pWqiMO/gklXnfSB1BiyV01yqMCkeV++vYSEzdTeRARZs1yFNy7pl+4LoEpzACIiB2Sn5M1w7xvk/topduIaT4i5sqGShaXml1vkFgTuRB+bU1f1OmlXiXWgKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDTH35pF5Qz4pOdYyNxXJArA5ARXeZ/iigdjwrnHL/w=;
 b=OPshPD70BT+yXDji9StoexjbxZzjLHyU4xL7ysHXlUdJvwdNILq5Yvr9ZKgSZcbaPBOyLOaLhsjY6AqBVdo/xoJRB6QmYdeFnUWBgp2B9xqz9MntsuU7twTk9IHKBwrdeaUCcJ2kaZGrNPfAxb2pbvt5nns+y7tzCHKVZhYwiWVH9XfcWNCdsWI5+RtAIcxGnWFBrvcIL1QP3ImEjUGn3M7UuDH4bXQZXJD2irDvnpWR6h5HAdlQmMoEgXpkqBwk7SkFiU0m/XYzYjljh2Azobkg5AyZNMJwT4HhVCA50o5Ni8mF43rVQkKmkvkvaBUz5PJtAblUhhqlli+Cmhui1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7492.namprd12.prod.outlook.com (2603:10b6:930:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 16:00:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 16:00:14 +0000
Date:   Fri, 17 Feb 2023 12:00:12 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        Timothy Pearson <tpearson@raptorengineering.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v3 05/15] kvm/vfio: Accept vfio device file from userspace
Message-ID: <Y++kjA8eZHeD5JwT@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-6-yi.l.liu@intel.com>
 <20230214152627.3a399523.alex.williamson@redhat.com>
 <Y+wYX34sPvPQmGSr@nvidia.com>
 <20230214164235.64e2dccb.alex.williamson@redhat.com>
 <Y+wkqnCAe42Ogcof@nvidia.com>
 <DS0PR11MB752967E3A3A8B8693A523D54C3A19@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB7529ECA0D4D0E1FB8B4B1A0DC3A19@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529ECA0D4D0E1FB8B4B1A0DC3A19@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAP220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: bf766da2-f0be-492d-4d9a-08db11000e5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w+mpsw3fWCcRH/7fQUTftTPjKItBJGcrDshfe8FnvEpkLYG81VGJLo9B/NybIHpLKrk3sHqc7qEii+toZ4Ot67C8R5VLzNHmmzObf4zMWtEmyIUgaCJo1qADXhyihpkqg9BzmbKTYCJoVXkgxMSzwvoBqcBJPDnSKURoGm2Ar2ATTwDABXGxLY6VU33BD90ur6QdKIW79TrsJLKopUz4oAAWZqZ/vdABJmyAFvLVzEyEYRnFwsNENG99qco2BRLQaL8pIUNO5SwekkIGPAjP2P+jM5cRHGee5QCd7Q6UQb8G51tA6Xkce88LvNzi61D+5hTNm1ra4Dh1LRhBmKBUC6AXP3h+/fXEaBeGVnSLTftuMi/VYbhBL/jP6Z4u7Z6tAQbTl//js9Q+FQEv0coW27ZIlAy/eUga2aFys+ze3ek8GCNxexB1gWgRVxN1S+ioHm/01yPjCnVbux00h7Zc66B4PLWpVNo+6jzp0g6SNMKs1B8k6O29YTOMHsXsApOvzIYm8lPwjMG0Ol5aXRbNin8oNWgeJgHLHHFddQcrNOhozLpVMrd7KUBXkTuu5JgDMVlLnXehW2yvlj+L7TUw1fpBCCDsjhkeKZ0YYEACM72qrbZqWxlPSi+6Omo8AkHhVQMB3mNzdm22C9FsV5HaVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199018)(36756003)(6506007)(6512007)(6486002)(2616005)(26005)(186003)(8676002)(8936002)(41300700001)(316002)(66476007)(66556008)(66946007)(4326008)(6916009)(478600001)(2906002)(54906003)(38100700002)(7416002)(5660300002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h9m59Bmz24IZsvC9PQ46UgmB7eVAH9ZdsNNIrxEqwstLCFDwXEnO5caxtGns?=
 =?us-ascii?Q?xFYoMfRRQK8xmksLlZt1kHTNXKkqvg14HJCvFZsXD2bLHGF6wJK7rSbGVEbq?=
 =?us-ascii?Q?cWNSMhH6bVq92XMjVuqCjSe7m7z4iVi83ISmYpqeX/BRUV1hzidLg3WH+Lvj?=
 =?us-ascii?Q?6myJiFKDSmKXKK91UEadSS9jijIzYaMrBkpep2pUE8l/ZUhhKYggyVPwhohx?=
 =?us-ascii?Q?XkGpXeegaJMKokexJp+VYSG2D4yeNRZvGwE3fPg2j6vk3cPjVbZxLskqps0l?=
 =?us-ascii?Q?CCjUWCXOkhI9TscOTOr/3IP0Xp5MCWLV8M2RbxSF+XjicHKr5LVN9jQCRc32?=
 =?us-ascii?Q?9XtJb8hROLTcoZj4I0HtlfON+k6Ijpu++piDqMcnizTI63IcTX4YMaR7yGMD?=
 =?us-ascii?Q?cCnJsuql7KNWuiqNbQ3EBzDDSe3xFKB6dV3GW7sI+p+zjNP9SY0IF2c0jTZV?=
 =?us-ascii?Q?Tm532CANF32g9GwSr2VtjgvJjhb6bd7dSWdbftdgMC91vdEdl0cxlyArgvDT?=
 =?us-ascii?Q?8gJ8j6l4DySr4o+JVmYtyh1tNCAoCz9VFXPTDPgcY0zjtWIjCL2GIM6OkE9M?=
 =?us-ascii?Q?Hz4gM8iUgsaDBLDSgEH34xxpb5PJR8uFa/koKJ2c6PmMvB+x+IGJkhsvDzRF?=
 =?us-ascii?Q?MaAwXHqB2PRfU8xHFu/HJmoym6cLly9R7D9ahtIbJ3KPH7rI32QGJ714z7wR?=
 =?us-ascii?Q?PotcaYnU/bPeuKVtkyiJuieefA8E3h1IQxNnoeibY0w/GFLYCS1vHkSgq8xN?=
 =?us-ascii?Q?7drUu8QKyZLt9GqoqZr/bDUhtoPlxZvyCT2S9Kj7m5RzaR2sZ8988e8SOj6a?=
 =?us-ascii?Q?Zsj6dAJPqJ+04P/Lh2RK0emZTBRR7kQTc81xVnSIi2Axf+QTMos3WPlSKPoM?=
 =?us-ascii?Q?2YuinixSuP+rKYgcpugEE3zcs17KHXmMNhvFDJiohX7sCauO9dKKBR0bQVhM?=
 =?us-ascii?Q?5yLRHxI4nLYLXEoldJUIcTxM+3pt2muWbKv3NZiWx7OJyCc9bqjn/8R6v/av?=
 =?us-ascii?Q?8q4zV9QTqcrWhBQ2B2CUcX+IowiYVti2FA/FiKh7M+hoimMdV+bfJQ+KVu2e?=
 =?us-ascii?Q?PJu2h6zo1Gk0WRqNuZDG9lhuDHvkCDx8D1L5XX9s1WuxV1ykdmuQpS+rHDWZ?=
 =?us-ascii?Q?sRgLRV8yK+KpR+4gnsH+1W3HIHVPNbZ/UPXrVuuWsk0ZkGDfCQim0CwaQPBW?=
 =?us-ascii?Q?cCMXAnbJrSLN5zkoyHKO9V6yJHCjgCFUZyVD1nt6zEJ7XsjmSvtzJYMh/xJ5?=
 =?us-ascii?Q?Kk2n8kNqf58yfUOXzf/GAm8YlWCUxdw0QGvwvXn4ms3mmdYt2h31Ego1Nmn5?=
 =?us-ascii?Q?O3T8ZTjV3qLgsGMILqhyrEhvghRQ8pUP+/MFDjafHwhtDmRl6YsAZIAmAKrK?=
 =?us-ascii?Q?pHbaRKaDUdmAOa0z21N9wX8Xk7XoFGUZUQ2Yy837IwlVWW1sGz1W6P4cyUKE?=
 =?us-ascii?Q?CyA2NMAq3hcYsEAmScbU2MIhYbu7LIuVBCa4TKnN5c5jhbvjd7UPIt9T1Z6C?=
 =?us-ascii?Q?yypaQNrOHgAy8YFNZ4YNSoFO8Z7He1x95RShmLXq5HRLevRE9DCwzyc73fz1?=
 =?us-ascii?Q?rpcplpCw0+FGam+kX+xnMfqMkDB9R76dWBYwxQIN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf766da2-f0be-492d-4d9a-08db11000e5b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 16:00:14.3637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hR3hKHSM/jtPJrcE58xabxqXxdeIAL1RD5SVp9Fmuj47TxhvPcoJOxIAg29Ce5N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7492
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023 at 05:48:57AM +0000, Liu, Yi L wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Friday, February 17, 2023 1:34 PM
> > 
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, February 15, 2023 8:18 AM
> > >
> > > On Tue, Feb 14, 2023 at 04:42:35PM -0700, Alex Williamson wrote:
> > >
> > > > A device file opened through a group could be passed through this
> > > > interface though, right?
> > >
> > > Yes, I think so
> > >
> > > > Do we just chalk that up to user error?  Maybe the SPAPR extension
> > > > at least needs to be documented as relying on registering groups
> > > > rather than devices.
> > >
> > > The way these APIs work is you have to pass the same FD to all of
> > > them. The SPAPR stuff is no different, if you used a cdev with
> > > KVM_DEV_VFIO_GROUP_ADD then you have to use the same cdev fd
> > with
> > > the
> > > SPAPR group_fd. Yi just didn't rename it.
> > 
> > This is because SPAPR cannot accept cdev fd yet. It explicitly requires
> > group fd and get iommu_group during the handling.
> 
> Sorry I misunderstood it. I think this can be renamed to be fds if
> no objection. Maybe as below, so that old userspace that uses
> group_fds can still compile. I doubt if a new flag is needed to
> identify the provided fds are group or device fds. I guess no since
> the pci hot reset code does not really care about it. It cares more
> the fd is held by the application.

I wouldn't change it, even though it does work like this

spapr requires the group fd because it doesn't work with
iommufd. No sense in confusing things.

Jason
