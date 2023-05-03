Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0D26F5F4F
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 21:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjECTmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 15:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjECTl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 15:41:59 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A6D7AB7;
        Wed,  3 May 2023 12:41:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6Xb8z6wb2w+E+eaZNXns8L2m/HKbCRyTQo4HOHgR/K6Kwgx+hbHitm50Fz1e4d7EdazHXrstlpnDaBT4oOIwTLnihgnTqhUMnGwu1y8NCkgdjmNuVqiROxipeIxl/a21FLXwzA/Sf4ZQGjB3LKHjClCh9i51Wh/SS/sJs8GuQItpdhdYBQCzZyJmB/I8DmG7e+r5TymNnXtcs89yRE2KTePcmVznmg+5M08liomk/erUF59ichaG+oPa1bTQqX+llBIsKqAkKYd9KWXaVuIsagZ187NdefBNdx9RTmUDC7bNQjCbSJYyYHnXzGXd6DCtqbuCk460//PPwaw2FNt9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5UI7mcCaLq3NzNJsZxRg79gxVTKW8DlvCYsFvgc1lOs=;
 b=n5VA1r0LMts0ZNok6EM7DXKGRPSQ3MGPC04UfdbukkD7hH89iXX7AcoPvAxSGmFbTUzHInJ7GSzKnz9XpsHbapzye8CwLFOu14iTeLZ0Ssf60gbmjFILHct6jsW9uoqmD0odZhZHaI8zh4ZCXI1rKyc7jJNIQjvhQGwdJh9C8mMkCKRnlQAZrJbFbTAsgPVjVYqBfv6l1pAVJr2RRQYCizOxD9YvJCHxhBsUuqC4mp16k34Gm4TwTpNIcn1f7Rmz++hxmscd+7R874xpaLuVZs3ESHI22Df/SO9rHLaX7hUM04fO7eCBu28yq0ATeMdlPdYaEB/y0WnFIsvi0/aLiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UI7mcCaLq3NzNJsZxRg79gxVTKW8DlvCYsFvgc1lOs=;
 b=HG08y/FBsxJqmUyp1Zt1H1U5elp+pzIy/BkwvGCKoehntPN40zjD+rEduDkjv2KPPF/vegHm/MBjSWwt4PCajl/+bFgj4hMX+eogsL5wEzQ4Ip2nwmfWcGjCkwYO6Uar+p54R+6a0rpQEaZURSDbd0+YkdBtkKxWO5PWtLrr41NSAsjmqVvajKotqBYDYlV42USCKCg8szWRIidLLxAIFxnJHakKEe07tV736ixwh7xIlEfms/IEQmNTKQyhojSSlV45xR/jDBgyirqzFXLQdVvZ0KJAtzQXV91IsNfosbhoCLMFFE47mcHFTdcBBa/wpL97EluCfRUm3j8V9VUcKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6370.namprd12.prod.outlook.com (2603:10b6:930:20::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Wed, 3 May
 2023 19:41:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 19:41:53 +0000
Date:   Wed, 3 May 2023 16:41:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Message-ID: <ZFK5AJxhMBGKqWaH@nvidia.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
 <c203f11f-4d9f-cf43-03ab-e41a858bdd92@intel.com>
 <ZFFUyhqID+LtUB/D@nvidia.com>
 <DS0PR11MB7529B4E4513B1A56A90F111DC36C9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529B4E4513B1A56A90F111DC36C9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:208:2d::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6370:EE_
X-MS-Office365-Filtering-Correlation-Id: 1548e7ef-c8a1-4ce0-fe85-08db4c0e723e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tTF8zVATlwlhNeCBbd3/V3K7nxWBCxohZv4GuBwO0bVzJnYx44LC4Beo8TNIIjc/Sza8xPSc3TGcn7MUKbGh8fjIgfC1sfbGYGGDdRSj+5w7NS2JNGlWjatS2QJKhKCJouhdtlN6qgkI7xTKPLjiTh+14TnkLU2PjSoBH0VMBrEL35geKROXvJz+aE044uB0jycMzYRQWb27tICkx5Vjuz1AKuhFtE/fnBeIyaWdKu7U0LIYHsQMfXJEUPZ32uVdDZstlmOg5+TDELbgiRUBrw7OTR6ixFzSbjAZssU73g/sOqD/77jXv5MFqOpSt/oAkzjqHhfw/qJGVK2r5KACGhgG4BbqL4gj1+Kh4BffLM9pvM6uMptTYVAO1kz8a4i6I9znM2eTIrMlH0NkjSAn7gI+ZHPoVF4u88diEc19TbqiKkMxYR9gnClY4uiOkBwnWz/7TN9P4hUEbtxdkmeZcKa0XxbE6Rjg3Nepoq4dxwJ7sunJO8VTAmiozgj1C/nRTILtDZjMnT2X1YXT+Uc3sxfTMfBB/bahotnwPlaIOIIb268SlTVOGEFFzvLNGSBr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(86362001)(5660300002)(7416002)(8936002)(8676002)(4326008)(66476007)(66556008)(66946007)(41300700001)(316002)(38100700002)(4744005)(6916009)(2906002)(186003)(6512007)(6506007)(26005)(6486002)(83380400001)(36756003)(54906003)(2616005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vCfHZ4th54Wm5sfTgGaIuFOG+f5yfMX8SWISrJ4PXQTILd0N87UErOa1JFKq?=
 =?us-ascii?Q?2UW+Y7zCdBmnFtWYCr4q31esLT9W2cE6IxIUcEDSiiSE5YHkLrhTkghm6AY+?=
 =?us-ascii?Q?L9CCSFXrCsw31ats1Y/Wiw7rwZqLA2mOKvt6OX6YABRLqR4RuzELDrdTjxzU?=
 =?us-ascii?Q?Vx3c2IecXKMzKd/e3xY1cKO5waeoDFNOm9mD+PMzgsuOGgSHBWcz4Cg4+Q6K?=
 =?us-ascii?Q?ikrncNiiulCCN8I1+rV0j5oEY58gG9JnsaI4oCoyOV1D8YpBqe6J7SyERryt?=
 =?us-ascii?Q?jpW6f/t/fsC59dxBWDt2Pt9ysTLTlFH+wTTaPuuhyRKSzga2bAAxcjkoz9K+?=
 =?us-ascii?Q?kVLcBdDU6KFjoG+FoxHaM+iIg2M7U/ntDQLqdGp6gI0rGMi8Mj04M1SNQgzb?=
 =?us-ascii?Q?Or31Rkv0NsRvPfeZ+tA7LrxbhwDW5fCnX+dg4VYgyaGy9GTQkagEcTWo0sen?=
 =?us-ascii?Q?MTSzCOuNPFCMXPKoeSi+aG5hFt2ynizA5FaPsR0qOmBg8BWejpYP2luGYxuw?=
 =?us-ascii?Q?rz/5I2pcgSJh6QyNGLLhZdVQshmJBK57gtCfnjKe/LStsu35zj9ucdebK8/z?=
 =?us-ascii?Q?0QVQqUmTMOJniC9gdOu8TNC1AwQi2GfI7y+AtWCUcNAg/0snXk38rUHRHG4D?=
 =?us-ascii?Q?mOEQGdEiUSlg/JfIcFyiLkQ6X3QfdCeZGxSLK/5bpg/m3lKWNPBzpN9xLDpA?=
 =?us-ascii?Q?A/A9cGVdOuDVYJWeadBmml50ojH/PNj3/fc7Zt87gr16cX4ExPZtPpLkmnj3?=
 =?us-ascii?Q?DlP+QXrAt9UyOiZuW/XL2UNX/uj3Wc3gS1a4mVdtZBYoZ29xVzN3sij68uAd?=
 =?us-ascii?Q?l2SzL/A67lMA5VLK0hlyGLmbHjAhpx8rPt6IDMonQK3EoXi9YPPYteRjN5Ns?=
 =?us-ascii?Q?wfT84tiG6RbLGDt4wodpwiFj1k20Px2W3CJhYctbveMj8J+htV470M9hKJN+?=
 =?us-ascii?Q?syfM9MLMlRo1BHg50nh39hMGrqanlHPjl6CCO8tbK+LtOwrqiDHMhnHXODCF?=
 =?us-ascii?Q?Cq8WSNBYv1QJuKyvUP2CsFYOxXJdOa+t+m5op+ETISqxD1A9Uga5dtU3t97s?=
 =?us-ascii?Q?FGseH4lrpPwkOpN9I9xtFIFL3QY63Hmnw6Yh0UdNMWpZYbVwvRJFLOe6ER+J?=
 =?us-ascii?Q?77m8YqDnsXbRqQJPPjk3Vbf2UgX09YI/VnEqVLFwDJidD8sblkllLYRX9wiG?=
 =?us-ascii?Q?yy97N/p2HFIgKTmbyYP2vK05TpaH0AEF8PO2aj2xGfYAZvS9Wm0MZhKH/dyi?=
 =?us-ascii?Q?g/sraYVd3VyIPX+WmyzJMBIHrd4xpD6j40BmnJz0cD5FU51GU/tmtk+bokaL?=
 =?us-ascii?Q?eSO8mN+pXJhW5qcQxbirCpsB9NZHerNXBcbPAW9nl7ol+cQkm5TceOhXLkdH?=
 =?us-ascii?Q?+o3DTkO3JpL1Vh3NQulF5hjV4kH9UxiYV1EGwGH22RhposqBiOT2JGMZYwtE?=
 =?us-ascii?Q?pxYA4PNHdMYFtqsuVL0i83uTr6Sgy1oVJMzvoOUyYXmjOwMRE1ZnF+QiS4bo?=
 =?us-ascii?Q?/ey5aSccHq7qzEpKCRY1MnqDs5RPQnzKfHkTPXj4oqNxxMl3dDyQeJohjXDW?=
 =?us-ascii?Q?J3++f0ox5wIMrFczQycF2TI+faE04lgwiwVR1d+Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1548e7ef-c8a1-4ce0-fe85-08db4c0e723e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 19:41:53.5019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: azlmjAvmJS/EHtYje9eH+w0ftZ4EwMoVFUNRQ/8COjq6q1fnCL5+Qct+3ZWUpy+b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6370
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > My general idea to complete the no-iommu feature is to add a new IOCTL
> > to VFIO that is 'pin iova and return dma addr' that no-iommu userspace
> > would call instead of trying to abuse mlock and /proc/ to do it. That
> > ioctl would use the IOAS attached to the access just like a mdev would
> > do, so it has a real IOVA, but it is not a mdev.
> 
> This new ioctl may be IOMMUFD ioctl since its input is the IOAS and
> addr, nothing related to the device. Is it?

No, definately a VFIO special ioctl for VFIO no-iommu mode.

> Sure. That's also why I added a noiommu test to avoid calling
> unmap callback although it seems not possible to have unmap
> callback as mdev drivers would implement it.

Just have a special noiommu ops and use an empty unmap function and
pass that to the special noiommu access creation.

Jason
