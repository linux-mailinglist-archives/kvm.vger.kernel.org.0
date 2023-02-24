Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14DEC6A1D73
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 15:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjBXOao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 09:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjBXOal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 09:30:41 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2070.outbound.protection.outlook.com [40.107.212.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A555658E9;
        Fri, 24 Feb 2023 06:30:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZIZqcDf6tj65fL3NWlvYSHAiEMSv5Hi7l/TGFpcav+/TfnG1mS65Ka56Q3PrXW8XjfDeCMh5EmJdjHXc+TIpj0683xqLCSc7xI5niBmuJSIhM8XoxiFvgm91oIJQluLTGqzBu+gvEw45PEMV66rKUGpPzfjmgTQV4TKMwz9k0jd/6G5Ix69HDgK9X9Vksy+ZHZXvDeyOSZPcM5lWNSNe7EEqJoYkZojMzw43bbwuduY1S05VLSQzD48L7x/UOir6ZRxTR2JBl7hE0xrx2a8YmzwUtP75bIATJLurugKJ3OnS23MNQ0yHhNcSUIS7pGVU06dn9k7LFmXx89F7bHwbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nAvuU7h29wB/ASbhCYRGE+hh4QTLW/s3UJG3b3JDM5w=;
 b=T9K4tgkp9AYwHv6AB39AVWAaTNSNIcCVtJVfBygOtnzdiLxo67PZ6lallAnyHJvSXYscgczF+AsF59OtkkkGZcN96fHrmr6KKxWeyLgGbLXFTwtJkja2K/IG82eLgpzK1w819OxFlHUH/pqUJVxp8itLxnt6X9ehALhMstrR/5BsFGD5QxMj6njVStSG35CnSJjO6oJq7/PvPFQRxGW+Zc/OgmOX2peNX3JP6EC8ghM6tKULyD7Vi1cxDhb62r5dA78/qe7ULhbtzqmukyy5E4SdGMVzWVDaOj8Zva4qDCxCRmWIPIsVK4NP2+6CDt8E8H4xybvWt5MZB1dnviRvow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAvuU7h29wB/ASbhCYRGE+hh4QTLW/s3UJG3b3JDM5w=;
 b=D64oKF3YM9SayWp4holza4VknTxIvn4H/pinyaZH3EPVpFE4xIbO6t5fVAcNs7wz7sJRpqe80YlZxvUTSWIx1WA2M4VLGOZAFLQdYH9Har3kC2r24ORHyD0E+w6xe4JGGf4zU0OQ3PIpXxkS6ZQC+Ak1x1H86f4xizol0Uz0baThrQSwcIOclgk/v0g6dwwRAbzj5QBJ8nXoVzu9rmhZ62rRNPyvuxbopsO5u6gTYUlJcTa1Bfzr6WxV11yX//p9h/68lcQYHBnJhL2l0xH4DQLtudSTvdZdOKv2BrFct5PX6V8BSHrB2Tf1il016M+qwoUQXUMshGbYaeG8I7UXNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4469.namprd12.prod.outlook.com (2603:10b6:208:268::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 14:30:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.021; Fri, 24 Feb 2023
 14:30:38 +0000
Date:   Fri, 24 Feb 2023 10:30:37 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Message-ID: <Y/jKDTWlFcKy2BQz@nvidia.com>
References: <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/ZOOClu8nXy2toX@nvidia.com>
 <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/dobS6gdSkxnPH7@nvidia.com>
 <BN9PR11MB5276C959AA31F8515002B6B48CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/gilafqe4Xm45jY@nvidia.com>
 <BN9PR11MB52767479FDC6F1CE16275B8D8CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529EC1C6A54BC57C1251154C3A89@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529EC1C6A54BC57C1251154C3A89@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::49) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4469:EE_
X-MS-Office365-Filtering-Correlation-Id: f402eac4-8f6a-4fb4-90f3-08db1673b31b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9eNXWqOhsfL6ymfucltzYtEse4Beo/p7AKwPPVywLpKU2RwVKrVFA+A6uigiE8UA+a0rfJ0RNa8ctmeAKshBeMyv6ajx+EwsAIktF0PTmZaKyAFfNKg8fHM36QR5inPI0WrBOM/b0BgYnVHP3f4s6JA6Uh4hS5IuRiIXOF2O1E4HrHJfmKJkliZjH/0RGPeNOxf35JrjkDa0H8p5c60+pYgULvg/aYg6BTVH+fi4ioedyu30EYqs0pciliDb6+mPHrG6fT5ExKEUQ5mRPODKnwRIBDh/IdrG7rn+HG8KSPXtMBZadmfM68J+N5PiMWfy0Cjr9FotxrwnieTxMkT1NcmgHwR62LzqMMvDt2/pmJM/o3GRYi/g66OlHkvnwnDzn2Hyu4p8rxl7FIpmx4REI78gztDsarQW7ZRYAMdHdHRjjsioykpI9MzfVCluPTPUeMgBkcojhFS0bJan5VFyFjCih7RiFlsY4EZe7HVflvIll0n553MEuoCtVRUcGeLNcL1LVUatztwIBnTzfSd3zrbx4sBQPxfjoX6H/ZFsEXwtIHFeDTdqFlBH3rjzy4UmzexPRWLxXdcTqqP4F1jrLWXldtXQu2zSJNLtqvhKgU/itugvBfH5OhAok87K+qojNIaIiG9OA2MgzMRjM2ESyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199018)(2906002)(7416002)(8936002)(41300700001)(5660300002)(66556008)(83380400001)(66946007)(4326008)(6916009)(66476007)(26005)(316002)(478600001)(36756003)(8676002)(6486002)(186003)(6506007)(2616005)(38100700002)(86362001)(54906003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ETZEujsoHyF1P3uAoOOarfPbpc2yZ1a2KtwjSrhMwGD5imKYttcDXP275EOB?=
 =?us-ascii?Q?kyYIfC7tg0I6N6L0i9RgSMTENZePBWhuFZnvwiTfIm85boHLEDU12RaRWmb0?=
 =?us-ascii?Q?qz+D+gqnnwj2EohMEW17bwBUMYDDLDTKPmo2yNy7Ov9T+DJhSFPcp5CMy6pC?=
 =?us-ascii?Q?DU77amnIKCEBqrAyFDL3705Kl69osTMmqBiLsapcP8dF4NjYMB/0Je38W118?=
 =?us-ascii?Q?EYgbl+w3mum4f9O4skzsOw9fnYsgt/WEk+mN7xgSRKgra1HSG4l0X9/q84Cs?=
 =?us-ascii?Q?u0rTymkClC2ehBXmH5Po1X0IOR4QqmugCHkTAR/OrkfbvQwW99KuZSkfEqTz?=
 =?us-ascii?Q?tcIVvUqKuhix+Po5d1dlxVfQNHIFGeZp4Xm2zUZOVD1b1Fhs5XF3ib1V1VZC?=
 =?us-ascii?Q?6tMT+qnkVxDrydDzQEQUtQdQUP9F5XGBIKLmyMZmgMktl+CeIvWOyEJCUDPE?=
 =?us-ascii?Q?SxjmuzfH8/Xwb9qd9f/kPCyKIBwI0zXC6WOUkl+vNh1CGqOAu3P34afQi1iQ?=
 =?us-ascii?Q?+DKrVUl6WLQAcFUD+LEu8nASKgKneF2k9WCxmyMsSdmzXy7XL0VLXca4oAT8?=
 =?us-ascii?Q?7RvPxnvP0Zinlmqd719if2PFSxhZmtqbM+P1tZZ6UPeiO8ClNPqFjvA03MPq?=
 =?us-ascii?Q?kENQyH5hWlTj9uV0kbq4CuryJEHBMy4GV/9HWbt4YJEDBKC0F1oqTNHtRMdh?=
 =?us-ascii?Q?7I2gCPNGM3id7IrQAAKBZNK/aK//LLmU/f9BCcWg0o8Z07rdd9tT1ZvWJwv9?=
 =?us-ascii?Q?ZkIYQoy0UCY8udwLEmLeTftrnRf/7zyq02rymWwasQ0bpomWUY2I9MyAX1Hs?=
 =?us-ascii?Q?A1vVhuahUB0gHIb7UsO6UfuxvdciF0uNEPYBAsKOsFATerXu+pwRBwpzLpj7?=
 =?us-ascii?Q?kGQzmResYjPsx9JZg8t3W6UifuljE8/gn593HjAbHOMsUoXdS8GVnCBJ1Zh8?=
 =?us-ascii?Q?rzh7KU2OyMn/ijxfgwaywQbwkwvfwyhJvmKJwVeHJSFT5v/e7YN5/iF4+wWe?=
 =?us-ascii?Q?2aDMDXfFGBUsDrhc44hKIu8ejZje8uSf7TyTa32m6PDdjz/cdIuUXd61NwXU?=
 =?us-ascii?Q?HGiIg4Ky4z5dx40PUl2KCugq8RgWUGUem4JtKv4Yi71ZTKDKSgRLFlqsmUYJ?=
 =?us-ascii?Q?sGfuMwllnosOatTnYGvflRAA7lNU2n+N+cdGPvKqn8CxpLu4ZWe6Rq0gtYmf?=
 =?us-ascii?Q?KO/1LldpZgCVEm+gIcIEKVQ9dCDiHYHnXjs8OwNYTvktioR5xdR7dvoVLdIO?=
 =?us-ascii?Q?fdFpLJqKvsSM1XYtg+6ETLbqLXZGP5AEkMXA8FVkJTJWtpvlWVJ1VPRmkCTH?=
 =?us-ascii?Q?FJSpc9DkDnD46BLZ/lbUmIbgxIQH+Welc1w7tMshEYcR2A3YxjxDCCfO+g2u?=
 =?us-ascii?Q?ak9qXidgDLe9uq/3UAhm/gcsw58C8eSRd1yLJ70M5T793ROkOnWc1/F4K0dI?=
 =?us-ascii?Q?cTnhE9dN1TXewK5onRSDztjYgzKAfKmm3jU+cfTkRZ+fcPT4BeWEfBZKYThN?=
 =?us-ascii?Q?3zUF7PscVSLu9MZtU76eD1p5rFTmWdcbhySGqygLywXiTLfyRcNW0LVlrF7t?=
 =?us-ascii?Q?3BFO/9hNuodVDrfQow/ATZqIUtCPdPzyIVDxc4jh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f402eac4-8f6a-4fb4-90f3-08db1673b31b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 14:30:38.7847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qeem+a888+iBxr6OELOL0ukyW+dLTGPxirQ0llHp5Wq8rfjVp/pSDRDgEzHoE+bV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4469
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 03:43:37AM +0000, Liu, Yi L wrote:
> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Friday, February 24, 2023 10:48 AM
> > 
> > > From: Jason Gunthorpe
> > > Sent: Friday, February 24, 2023 10:36 AM
> > >
> > > On Fri, Feb 24, 2023 at 02:21:33AM +0000, Tian, Kevin wrote:
> > >
> > > > Yi, while you are incorporating this change please also update the
> > > > uapi header. Rename 'group_fds[]' to 'fds[]' and add comment to
> > > > explain that it could be an array of group fds or a single iommufd.
> > >
> > > Upon reflection we can probably make it even simpler and just have a 0
> > > length fd array mean to use the iommufd the vfio_device is already
> > > associated with
> > >
> > > And the check for correctness can be simplified to simply see if each
> > > vfio_device in the dev_set is attached to the same iommufd ctx
> > > pointer instead of searching the xarray.
> 
> How about the hot reset info path? We can still keep reporting the
> current information to userspace. Isn't it?

Yeah, but I wonder if it is useful
 
> another tricky question. If user passess iommufd down for reset
> in the vfio iommufd compatible mode, should we support it as
> well?

I would say if the 0 fds mode is used and the current vfio_Device does
not have an iommufd ctx then fail.

That is the only requirement, however it got that ctx doesn't matter.

> > Locking is fine since dev_set->lock is already held in the reset path.
> 
> dev_set->lock is held prior to call bind_iommufd, so I agree locking
> is ok.

As long as the vdev's iommufd ctx and opencount cannot change under
the devset lock, which I think is the case. It should be documented
though in the vfio core code, as it is a bit subtle what the devset
lock actually covers.

Jason
