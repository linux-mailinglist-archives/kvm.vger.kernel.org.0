Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672BD6A359F
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 00:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjBZXk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 18:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBZXk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 18:40:28 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E59E15CBB;
        Sun, 26 Feb 2023 15:40:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnAg3L8AhgwjWEKXfrLNNU9ZWdpA/cCT56xdHoS0S6ORwz+WdNONJytOxNhRD9g0XIHjLW3Kc7SpKPzz3woU7N01psrS3WjTzpEamg8201FNMacKZsdZLMabSwNtahBMP0WVUy9abHOxJQTxn3/GupxW0UpmRPyF5DowJ0XmqbUgFZvQsiCKmh+4vWpB7hdKBSRz1aJUoAHrM0ovY0vN0+HyseYxAeVLbcX62DaWgfRfXN2VuvYpOZ3jEW1Hf0almIJ2grOyZi6o0STJbtZxTGdyn7bUZIHSwln3PT2d/E9LoI8I3qQdcU9Gce8B/nowwoHukA6JY5Sp8W1Lp0mKOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhDqupnyi7a1kJwzqPeSPIOA6uGPrifgqaFWJ8rslXw=;
 b=Jm/nV4mUaLOD+hkX5Cax18lDGWPqdDBP5eyoh029AMYIWkq6jvJ6l4wRafyoRJhP5H7AR3SJ6C+9wcjqYOFQizzRWnWO6rXu9PhSnpX/Vrv1ldyqf/y0NwmE8s3GJ7EX8xZ7v4AjDinDGDUUvLssuBaBzssN3//hRZ7CEcwb96l2mbPYQH+750LqECNCsSDtP5fPiHKG60n8wBndxZoPbkfRby7GtyO2texgwA6tbZPqrmUg+vNsGS1I5z/SmZ7H1JqwCnHspQAY2x5r4HRD1YkpA2C+aM87uoN1TNsUbl0MHZxtObkNydHTfQ/sFcQ55RD9/cQ8k5DcssiIfxhKdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhDqupnyi7a1kJwzqPeSPIOA6uGPrifgqaFWJ8rslXw=;
 b=V88ljB+xIsDTYExkESd2YA78HDb5QidVQ50TqsAQGb51yg7ug7YxMDKKZET0wrX6L9ZilvOeg9tNWJvzKT3bY0GqBLm/IGpuQFR8kCAcQ4rKA1C54D3PBY8ayEz3xkFABiP+jGDjJvffLKFW/j0boqT0ANQXSeCu1rdNRr5tKQX+r0rHB9MlAVkE0cn9Ljc+V0n7k3nfxnCj1Z12ctjQGGXHsqgMc82z0AeZxe96xwcDgjpMraz26/R8EYlr0G4IO95tgCHViEUvFkU/3nzjKELtspTghe0dmrGc2sGaYrg/KPS8NhAfHEsQyPnimkPRGqm9CxogE3XJpASOLEenKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB8737.namprd12.prod.outlook.com (2603:10b6:a03:545::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28; Sun, 26 Feb
 2023 23:40:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%5]) with mapi id 15.20.6134.025; Sun, 26 Feb 2023
 23:40:21 +0000
Date:   Sun, 26 Feb 2023 19:40:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Message-ID: <Y/vt4yjNhXUlFwlL@nvidia.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/ZOOClu8nXy2toX@nvidia.com>
 <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/dobS6gdSkxnPH7@nvidia.com>
 <BN9PR11MB5276C959AA31F8515002B6B48CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/gilafqe4Xm45jY@nvidia.com>
 <DS0PR11MB75292B46BE9CAC31EF4AF833C3AE9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75292B46BE9CAC31EF4AF833C3AE9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB8737:EE_
X-MS-Office365-Filtering-Correlation-Id: b87d794c-99bc-48b7-6eff-08db1852d317
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vu8H6YTa+8dMeNz/+GHr82QpNFewZ60h67EiradvxItlVi+hBm7nhntwezQZ5XbfUQSj2vHwlN33urYNT2otEY7eBhdlhYbeEYElkTQDxs6S+CQpbVGeuWbncwjHTIFIeSqAmPypia/TszPiTsUWsTBz1mXE3YGzGO3no5tYljyS8nW8lVY17kN8gMcpytlD15j2ftOiiE99KSRh5ZRCacHsKJ8YWtJcmJiY80pUwVU1MXr3kO2SNuHFAaDdjdPBf97ftAvfOTZyzpq8n0FuuAjB/uVtnuhrCrp9j/xaEuUUGijgznEkjVyv5MaU/Sd1E4zbXcZ/kFPbb8OQdfwYIdeLbXQy2Yn2hwuRZEWP8vCR+KEdsSRYfRlgpAQqL1sotlu8wz/UBDp6Ia9xMQwVFL7lvxBtFowNRnJFyuiY/3nvKeBeVszVcpC2Ys7csqj/X9hEKNSYLdnEv0Ka/UmDYWG6lGNId+AZV9RFMsJbn+4g4r39buXP/ybspO78OJUYvR4RmyNBRlcEVgFsmznBIH4qbwcwkNIFmL0uCgNfzxf+z9lVxRTTWBb8pwxRtorm8IQJOK2HznQ7MSBu1aPd0sotOQgizR5745STuoofHbfVWFFD5jyOvxTqQ2pTOARiOr1TF189yMPvoClc8DGCYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(451199018)(186003)(38100700002)(83380400001)(8936002)(6916009)(66946007)(66556008)(66476007)(4326008)(41300700001)(8676002)(2906002)(5660300002)(7416002)(478600001)(6512007)(6506007)(26005)(6486002)(2616005)(316002)(36756003)(86362001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KKJ4rZxLyxruW88dEdjLgSaExhV9WrjXDnN0MBuHbSt5PYHx0Ig1Ewgvxe7P?=
 =?us-ascii?Q?yE0q7jGDOZSa0pyapiSYneZXn+Ey4ep6Pv9N1PjIRliVcZkVlmJ9im4TTaWd?=
 =?us-ascii?Q?o0mEVOhl5X+akgniBY32gEgZ0qrNH+NYj5xyl10DH5Ts1U8oXu2UBre6swt/?=
 =?us-ascii?Q?uQ3LQJHCeChaxVMX24r60q7UqYwAshA9NqU/Hkkk+k0PVpLlxwbD8OEHjUWp?=
 =?us-ascii?Q?KK/HxmiTvOZaTRV/GnIMP8+iBcp3WNE4l2c85uhMeTqLS2gTsvxtpu3gMvoZ?=
 =?us-ascii?Q?Cwnk5SKyuonFECr5I+EQKhDQMlab/3uSviCph+68vIS56ScSOKZxwQtMRhgo?=
 =?us-ascii?Q?p1G9WyNqDo4Yi+uDwVSAlxvxH/9vEohzcGebqo0vp0iOa0zZeq3097Jx9FA1?=
 =?us-ascii?Q?WmSjHkRvzFYCw2acXV+fvfknyjsGUZZ5ID5DrXicDqw1lDYFd9o1hUS7hZdC?=
 =?us-ascii?Q?7sXxesIBoesNeCPazZtWpPlIOG5Co4zBR2Wp57Zh8X1tHhttLnDfd8Qua6EH?=
 =?us-ascii?Q?fg7UWMXAzcgnlj47ESqTs44rrhdBUbp818NYskvYdltNjCF6hDL1cdRiqcFf?=
 =?us-ascii?Q?TzWGkt7yiRvGT5OoS7TLGOyJsvl0l6cduCPa/PfpDq1qsSXnYeqDOKgXPkd1?=
 =?us-ascii?Q?6B9CcHs5ciD8iyh5HjKpphBiSqbj62Jpk+gknzHWkSfFPgilAPvkmqwRF7g0?=
 =?us-ascii?Q?Q91a/i2MiLp8onLUJiKlGOBENcLu74IlRhvVtFAW2mzMr5AZ/lkdzHUEecEJ?=
 =?us-ascii?Q?cWVTglRroyOqFV/F63y/zwrrZ0HXuM1LISl8bqvdb3Vi2sE+6cgH8jbxwV1s?=
 =?us-ascii?Q?N20/KY+uzBvSEmc7Aa70ZNOEhSFIzdIKWudX2Di3zJfNgZfsaR700QDimQ+k?=
 =?us-ascii?Q?z4KBuJS8V61znGKAhicKCZX6WBisFj0Q+pJ3p1qjDdb4TWbJLbqkAke1lNhC?=
 =?us-ascii?Q?3Moqh4UlluktLcqNN8PtQHiZgOoWlgCvMVBxeyta/Ll6sJsIPP/e4XJABYMx?=
 =?us-ascii?Q?Ao04HsS3eD6waVmStDi1AQqmAxXA1Fii/gKG9AK7OpDj/9sQtPjxzB+zU5rC?=
 =?us-ascii?Q?jXfVOEVqO+nHhGzuftYqRdL30rzIqu0HQn4BJkCdHZxEW8tfXabgDrt1kTYa?=
 =?us-ascii?Q?jdRtORgx9MeanS/1h8KPnlsB7rxwj0+4f6ktSiA9OpjxofSfA/+Fb+b6m/yk?=
 =?us-ascii?Q?jLiRWKvFuQVUPCak2PExkaaUt2oMysxIQgrxOcwjmNTxYVL5uORiIq85KrF5?=
 =?us-ascii?Q?4s8nHmI8tDe2NwQ/bBSL1jF8uDcN5LXg80K52lgGWjGg+VqQEiTHbFcIV3iM?=
 =?us-ascii?Q?71uFv05S+wP7auz1c2QCjLPhviRKEKvzyK+5KzHJGeLPkm6Slu+fsCPrl7Bf?=
 =?us-ascii?Q?KxcWzMUfeQxvUZwHcwZrhqBE04zYRaMJKTuj7Cx+HbPcB/qC4FN8OR6EvHgr?=
 =?us-ascii?Q?sEsmlAI+SzrwG07jVZtCIx+jBqx8Pq2w5oDXPyJZLi0r8787jSw+ZcK1Gjf6?=
 =?us-ascii?Q?ZGhcRDClhWoQqch1j+JOxdQYyidhx+N6rkLbHtcP4JuZWUjkViF5lL5e3JYl?=
 =?us-ascii?Q?mQZJhs0ru7odHwzGhCNv/kQq6hogFs991QgSmLmn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87d794c-99bc-48b7-6eff-08db1852d317
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 23:40:21.3135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XMXsYEUE4so9QuZcrTQCnT2g0NJeeStuPn3/nzTA8Y6jdIt8hXmLNavDKYjiw0Ec
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8737
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 26, 2023 at 08:59:01AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, February 24, 2023 10:36 AM
> > 
> > On Fri, Feb 24, 2023 at 02:21:33AM +0000, Tian, Kevin wrote:
> > 
> > > Yi, while you are incorporating this change please also update the
> > > uapi header. Rename 'group_fds[]' to 'fds[]' and add comment to
> > > explain that it could be an array of group fds or a single iommufd.
> > 
> > Upon reflection we can probably make it even simpler and just have a 0
> > length fd array mean to use the iommufd the vfio_device is already
> > associated with
> > 
> > And the check for correctness can be simplified to simply see if each
> > vfio_device in the dev_set is attached to the same iommufd ctx
> > pointer instead of searching the xarray.
> 
> Sorry, it appears to me the below concern is not solved as above logic
> still requires userspace to open and bind devices to the same iommufd.
> 
> "
>   > Say a scenario where group happens to overlap with devset. Let's say
>   > two devices in the group/devset.
>   > 
>   > An existing deployment assigns only dev1 to Qemu. In this case dev1
>   > is resettable via group fd given dev2 cannot be opened by another
>   > user.
> "

You solve this by checking for a 0 open count as already discussed.

Jason
