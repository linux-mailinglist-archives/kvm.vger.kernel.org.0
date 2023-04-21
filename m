Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A896EB507
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 00:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjDUWhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 18:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbjDUWhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 18:37:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96FB2720;
        Fri, 21 Apr 2023 15:36:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mV2GB7MulvR67cPSmch8gbnBdKNWLleKMVYDWnBv4v5npMA59onUp9/rD3dsHPLJJwuQpNwdl50GaB6lVXoOapMtGOdD8GK0Fbn8U/Jq6Ri/ql2Gy5krWxu1mhgFJRjAfhWNUyaRdGLchn8QPy1osmIJ0Gc2Aalq7NCj/T8/f0seS39xTEqorXxTXOkaez1orjNifX8cQ+gbeXglar/uPj+hgVVlMcnmALawapJDZdcMIqWD9fwoDK9Li7oI8IzTY37HD2GQ0ajHyPzeJHmHym8ZN3LCsDHEUYEnlxoRdvmuQMiKYEX5sbr9fia6O9iHefZag5SxH5jLNkEpFiZ7UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YoVZqTsw/n2ata4wPSFCj9p3SqPB+8ecisXGVyq5uU=;
 b=KezA2D/AN8BXLnMxlEVBtLzO4Q2YPG7KQLDLsVz+SptjfAv0RoHoCyqkmhKRIrHDB1Fq2pExTGsfl3UIuWKaS7mpGGy2L1s+XCuh4mb6lWOBZRleFZMsloX2g4TwzuFrfxRNcO1WBbi97GUP71D4ylUX/8pIwoC7tJRGj+2VLrLXoGDuPsoOCB0OmV7VlPZmBKw3ZV3AQ3zHKunS612A5Mv33k9Z32hG+tA85CIKd3SEjlSiBse9dD67EDa8gMizpSdano6H2n3cjqBWifkiyVrdOrMaVcNCQR4gzXZ7LuZBUrSP9cMzXtAp7ks8gCXUYTdBQMUPnNLOhO21hWgD5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YoVZqTsw/n2ata4wPSFCj9p3SqPB+8ecisXGVyq5uU=;
 b=kBYvfr0w51Owb8jKFvrFBfQYMod/XjRNLJmx0kXLbZMv0fjQCEJ80l3Ukktf4gk5fcDPglQ+iydJiGANEvAvq+wIKvLdmQaR90Aww7ZJ+Sfeyh8M3TD3+i5qcGpo9Kc5NZTgcap1fjnPWOSQwJVD9URPb6TBeVeoenPej4zzoSEHCOMsqlXn+TsVXfzVpIER85AX7Dax8rtXtLcEC/55dBQi70+6EWm0PBs7S4NKurjn9VKuWDAgqlGdIwl/BkshIHmf+WTqeUJV3h69lOmlLyFuajR3X1tg5gZ64AWQ+BjsMaJIeFvVx+Kk5U4tDrtHWTUJVzS5COMZ80dyj/KIPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB8979.namprd12.prod.outlook.com (2603:10b6:a03:548::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 22:35:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Fri, 21 Apr 2023
 22:35:52 +0000
Date:   Fri, 21 Apr 2023 19:35:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZEMPxoT+fSBh23Nj@nvidia.com>
References: <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230414111043.40c15dde.alex.williamson@redhat.com>
 <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230417130140.1b68082e.alex.williamson@redhat.com>
 <ZD2erN3nKbnyqei9@nvidia.com>
 <20230417140642.650fc165.alex.williamson@redhat.com>
 <ZD6TvA+9oI0v4vC2@nvidia.com>
 <20230418123920.5d92f402.alex.williamson@redhat.com>
 <DS0PR11MB7529C11E11F187D7BD88C18AC3639@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230420080839.652732dc.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420080839.652732dc.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:208:23a::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB8979:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ffd3be6-a624-4daa-6f4f-08db42b8c2f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1nnFW8BW1IOKbSXkwvgzf31x0b4Mm9A4TcQlWfkYIkeCDJKNGXvzzhbcw7tiDiSdyJw9DhuvUP5IKYRE4JMXK1feXZCEq0Xullo0YSINOohlyTvBbP29lq1rIKx8lBH1uKp9GgnRoapFO7JPAK856X7xjDnIVhMneaVvwlbkEwJMFwbprms5y+xsk1Pnel/9LUOw0NciOAAeZq2akXVdtcijtwZva7s70r8mv0EkBWtsgjtWFHn1TlpcrUpf/l42/ro4AlDEdKvTV6ou+3gNmSDEFfzT8+N4xyNE+nev5DRBwt+GkJX1/3oaZZORjOvyC2qhDJwH2DQkuolEyft6ro1ulN8R9FngrDu2eQ83AwqEl9UBAMJTdZ06Oib5/Jb5H5FL4qeTyCTbS/1Mbir9O1JaWdg+DeTC7h6XT+N+hGWIizdleF/+rbSCafAcU0cnDBd9uHmqS+U1CRts/LTrpF1hnm6IJ0h4Scu5zueYYEIlHxtpHCIQMmwLzzow4TwwU5BH0aNInfHCRyANktl8PbrBSGfXtEN3r2YSOczvmwoknT3iRCRhoo78NXp1xF6wZCl8i7z4qr9U+Wbq3BGTO+koGqJuGAvLi8K4cMPJRow=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199021)(36756003)(54906003)(478600001)(6486002)(66476007)(41300700001)(8676002)(38100700002)(8936002)(6916009)(316002)(4326008)(2616005)(83380400001)(66556008)(66946007)(186003)(6506007)(6512007)(26005)(86362001)(2906002)(7416002)(5660300002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8IiACcA4auhUddEJ4Khi4aIbR5n32kFFeYZy2xptzvokihecAUviIylp4Mkg?=
 =?us-ascii?Q?2cEaNqtfGLDoXt48oqavn8qrF9ssZresATIu4h06YWX5xt29PMDID0JFD/lK?=
 =?us-ascii?Q?IHi6+DDHBWiTW7cP5Ie03beoupwF3qNi6xz4rxncFFBsvRgQKVFR8dpvpL9z?=
 =?us-ascii?Q?kAad3zAvSxxd0GczRB0DkZriSZFVZ6yysCNkgSQfeadBJHRJOJRFDVNXUVMM?=
 =?us-ascii?Q?rCcfdUkgEkJugjlV8ebT02L1/RNE++foZJnHLGsXllEJM/VRZHxIBXQsf7lM?=
 =?us-ascii?Q?A9/P5oXJgD/ydkWnD6K47JV6fXC4arXe8rMQXnISSUeyEgeYIHKEumXWG+tq?=
 =?us-ascii?Q?MMX+P7bG/pPB6ReiXK49wkJsPcK+VQ6x9uUuFuiaTCsDgPTKn0Rd63j4eB1N?=
 =?us-ascii?Q?C1WN62y6xT4XuHXO+hXCzt60yTGu7b4HpxY2UC4Jm9XbbEJYtL6DSFhQCPFq?=
 =?us-ascii?Q?IFNqD3vkfEuPDk7kqBtjqJ+kuMRor1LzA4K3LuszXCEWRJDSwlmRmt1RvR+M?=
 =?us-ascii?Q?7si2KHHqVvSD5e6MTCwtXMyE5Ytm8FLSIhRb/zKc2HAlYn3s1LyV9vCASXIe?=
 =?us-ascii?Q?nL/vjQy7IrH/1OianRlRYzoc2cu4DrcEL2d+Ue5KI7uk/pQWlrkERKGeXQad?=
 =?us-ascii?Q?4AoWiNKxzE4ydjVjRD571THX9n54HGekVao2smiCFTi2Z3EshusWYfaLRj8R?=
 =?us-ascii?Q?oIieSYByzNm79NfNqZR/Lkb5coW0BLHwmxC7nEpdc1wYzjpPcU7wCmc/pTfQ?=
 =?us-ascii?Q?bgVVjpHiNMBP3r9pKywrD2A3f6ocnbd5ofE/42txdgbwJzJCotZ+DXUV+TOK?=
 =?us-ascii?Q?5vli6aiDtuUIgaFvVS67re+01L5DSWOmI0efJwSlepH6o0nIwP3DldrmoQwO?=
 =?us-ascii?Q?Lol6UsIOCX7AJ7jafpc3qUo5V/G5mWoKYrWFt4mgfHz/FIjYuYzj0fCsgf9S?=
 =?us-ascii?Q?MoGf/VK4BVeyrC7GFNLqlP6nrs1DJIlE3lXWPiBo/HUa5N1SnqXR9dl7MyR9?=
 =?us-ascii?Q?uYf6Ev1YDjzY/TSsy1zzwJ3Py+rresz4yH3R8NKt+u3VBMyG4j9l2B5NIpGW?=
 =?us-ascii?Q?zkMQV5l7daqXX8mJz+pYdiTfSjigBArNj7Bk5MoZv8xNNVORwE12cJYKQEc2?=
 =?us-ascii?Q?2pe0aHOl1Sy0cwhWhyirYo5+9glxZO0pq5cmbdxSOc8YFp2weU+B1qVCX034?=
 =?us-ascii?Q?siOy2QhPJWVcS2nQNLmcBswXFsX18Oy38cUJRdgpaL6lBQCTfouWnMsIRrBH?=
 =?us-ascii?Q?4c09nKTubNWivLkOxlXIiOSJ1xHhexuaPqzPfO3vkTF/sSFT91evaZIJ6gbo?=
 =?us-ascii?Q?Dxh7poxLvAtqPt8/46WmpaFcAqWSXOSffMweFwso8EBC8YIIZHhun0N45pED?=
 =?us-ascii?Q?BcAL2+7YNPjYvFWTdtQ62fvGGK/twTfEEwgD3Ko6LjaqyXxYfBZ5U/oP5khR?=
 =?us-ascii?Q?Or84dZaATn+j9UMulwcVSGsAywvv5rY3EIAAxqf1wKue6pmEl7VQgi6NDY5G?=
 =?us-ascii?Q?2fTRINxpsclJTJ2Jt0/qLO9MAvaQ+HvCWRD4Wn2V1slmsp3CDgrRilWQuIRQ?=
 =?us-ascii?Q?pIoBl3jyOFuV0ZFxAZpkCMa8ENANHzIBtl2e8N8r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ffd3be6-a624-4daa-6f4f-08db42b8c2f0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 22:35:51.8015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eiCkwMFxJFO6RlhFu+8+mFKHvXKaMD9eD/GhsL+1pcGgl8h6SpWxs7PUfV4v5v49
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8979
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 08:08:39AM -0600, Alex Williamson wrote:

> > Hide this device in the list looks fine to me. But the calling user should
> > not do any new device open before finishing hot-reset. Otherwise, user may
> > miss a device that needs to do pre/post reset. I think this requirement is
> > acceptable. Is it? 
> 
> I think Kevin and Jason are leaning towards reporting the entire
> dev-set.  The INFO ioctl has always been a point-in-time reading, no
> guarantees are made if the host or user configuration is changed.
> Nothing changes in that respect.

Yeah, I think your point about qemu community formus suggest we should
err toward having qemu provide some fully detailed debug report.
 
> > > Whereas dev-id < 0
> > > (== -1) is an affected device which prevents hot-reset, ex. an un-owned
> > > device, device configured within a different iommufd_ctx, or device
> > > opened outside of the vfio cdev API."  Is that about right?  Thanks,  
> > 
> > Do you mean to have separate err-code for the three possibilities? As
> > the devid is generated by iommufd and it is u32. I'm not sure if we can
> > have such err-code definition without reserving some ids in iommufd. 
> 
> Yes, if we're going to report the full dev-set, I think we need at
> least two unique error codes or else the user has no way to determine
> the subset of invalid dev-ids which block the reset.

If you think this is important to report we should report 0 and -1,
and adjust the iommufd xarray allocator to reserve -1

It depends what you want to show for the debugging.

eg if we have debugging where qemu dumps this table:

   BDF   In VM   iommu_group   Has VFIO driver   Has Kernel Driver

By also doing various sysfs probes based on the BDF, then the admin
action to remedy the situation is:

Make "Has VFIO driver = y" or "Has Kernel Driver = n" for every row in
the table to make the reset work.

And we don't need the distinction. Adding the 0/-1 lets you make a
useful table without doing any sysfs work.

> I think Jason is proposing the set of valid dev-ids are >0, a dev-id
> of zero indicates some form of non-blocking, while <0 (or maybe
> specifically -1) indicates a blocking device.

Yes, 0 and -1 would be fine with those definitions. The only use of
the data is to add a 'blocking use of reset' colum to the table
above..

Thanks,
Jason
