Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E9D6E6544
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 15:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbjDRNC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 09:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbjDRNCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 09:02:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F2217928;
        Tue, 18 Apr 2023 06:02:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvbCIC3I9mC4TI2WY6fHejg46Cw6RnRAuu/1XRj+M35ERL/nlD0Fqe/KHm+wLxvJhyE5yclGDzPXQ6FndxqvevRwxMHKp/mAbC2IUkhIdwLJ/sjjiDEGTLcy0HEfkpzV+neX7b65UJZFMxM7byp1+1Bs5UmxYrM7DML5H7mAzL+FhaqQOWRJE+k42/zke6ACyBXYILe1EboWl9IIyKPTbDPrks6zGA44fipiuomJcbnMZRShfU0ND/4myWp7cTJj+HXQLgZ0P2uMFyjCVTxtSTVI81iLUYyh7EU+5luRlnCw1MexwaAkxuncVWuwqRN+hq7XFjduPQ/aENlyBMHj7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHeUXxUQ4NwwzMsj/hSmXcJ3unnn0WYFya8jASJ+Ujk=;
 b=Vk0TrFaHlD6l3gzhyIhj4qJHW7dLCNHoaT65qbgm/C71iX3kgOzcTGX5H0PmF27JtBv+xg52LsZqnR66jnJlNL4Q29mnPsHw082nvhBvawBllK6F5iEbes9PgCnWqueGDLVGMRroguI/yOmdMZahJE+5l6WOnHsPd++YWnXtGhWy1skzOZC5oVg80aIIdcE6I49Z3LM9zA0Wbq3MoqioGnrGPAdkoTphE/bmj/W+GbOIt7ts33qG33ISQadt7d3rHWWVL4vDR8GnjssUVrzwqWTpzQr6GVCNWnWj9D3VLLFkRUL2+e51JOHEaB+eAp6SAumj9uAFkRpwVgD6R1CKCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHeUXxUQ4NwwzMsj/hSmXcJ3unnn0WYFya8jASJ+Ujk=;
 b=LunYbkFiGe8pTLA9Fs2DksdZDdjR9g3cJIMN4UZJyCUZhCmwgMgsE9nFu3BbISzDLyj3W952zYQNCskCzwRcNY8GFrrthspt2Pa0gcCNxcmXoT+nAm3/1liKDQwCksLkhge1hbl1bEzQHnAovrc5T+wygUGp7sv3XXZpktScVnkoxx6SwYgq2XOuDYH9kjWikjurHVpxsRDqPwoNPF45t2gm7WvO8AVVzhcfbxf83AGAEA8qm4Ilfl9tNC5MF+37wke5EuYGMqHrvZjl7tUEibITvIzjIG9Z2wqAoSB62PiEZKYXKDXEb+rZm9smo/QNWYIPAAT9vC0Tk0bCZVlk3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by SN7PR12MB6838.namprd12.prod.outlook.com (2603:10b6:806:266::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.49; Tue, 18 Apr
 2023 13:02:31 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 13:02:31 +0000
Date:   Tue, 18 Apr 2023 10:02:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <ZD6U5Tf1xseDawPE@nvidia.com>
References: <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <20230412105045.79adc83d.alex.williamson@redhat.com>
 <ZDcPTTPlni/Mi6p3@nvidia.com>
 <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZDfslVwqk6JtPpyD@nvidia.com>
 <20230413120712.3b9bf42d.alex.williamson@redhat.com>
 <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZD1MCc6fD+oisjki@nvidia.com>
 <DS0PR11MB7529F4A41783CA033365C163C39D9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529F4A41783CA033365C163C39D9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P223CA0005.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::10) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|SN7PR12MB6838:EE_
X-MS-Office365-Filtering-Correlation-Id: 324a3d01-1ef5-4bf5-c298-08db400d2b43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IuenTeZrdw6yKOC+7zgR49DGZ277moCp6AAXaVl827MqKJG/41lyewICN5Dt6fRYqlst9IYAddCPXl5tliH55wM4zgUg+Ls0z3vZ1nJXKnYHajxG2ecGxXg5/GrUo+EfYYciNg2Mn2yKf092ebnJ8xadB8VF/nMTZnu77Fxe1gjlWEdHjRtL9T//TN4gJIIVim7LJxs7Hsc0xROdN6MhBZ+8WHZecO1C8QyVm2lHTMaaz0zPKMxo54sJ56InerlUECW8wz2qxyDshC7oMAQfZp4NiD0GUuVwlrRbjCEHDPtpVIpok+tlp9RlW5o1QG50RpO7s85qPFAN82FxaMv3flHrpqZTdYh7EAyK+PU6RLCvvoYSGluKMM4BmPFGZ3JBRrtRRErFKmkTQrTAf095AffaI57JAA1xJgqNjLjSaKPu9ozpWwxabG32nCG+QCdEHqaaT4ccrHvlYo/Cx3LqPLYF42cMRTK3OILbOV5zBFYxWg/vPkmQpvP887g++iny9ge+QamJWODaAgRADpotty0H+i6HnrBI7pEjJuySNF1vhvqxavzk3949OaWW+1QW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(66476007)(66556008)(41300700001)(5660300002)(66946007)(54906003)(6486002)(7416002)(4326008)(6916009)(478600001)(316002)(8936002)(8676002)(2906002)(6512007)(6506007)(26005)(2616005)(83380400001)(186003)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VYwKZDNsW0wx3QFdBN5N7XNt1yUgXS/a+H8obxQha+2vQQbzGrusPmp3RdR/?=
 =?us-ascii?Q?XZYEJWSsWmMpUHKmYI/DhgOjXdIO81xFqODQ2XM2pP1KhRXXAOCN0rNRt8aF?=
 =?us-ascii?Q?9ChKakG6wNbgSmj5dHpLgJ/LOKZcUumoobVxuz+b/OX7fqQ6UZ8p96yVceVZ?=
 =?us-ascii?Q?dEFgSgVdB60hQuCWWgddHrSCw+SRneSMUUP2teMJCXsc9rx568QEgDU8p0Re?=
 =?us-ascii?Q?PuWOvNKM1gAZ0tH6JUlGuE5Mwbciq/ZqB32x5JeoOYuFtMPo2a/psSnuMRPv?=
 =?us-ascii?Q?r8tzcsxg/d0hzBlEpvCLx0DpVe8gK7IM38nB1lQBRoZP/RrvDkedBYmHGocV?=
 =?us-ascii?Q?HlWRzzs9LcZXl4zAJu3NNjQPI2WenQM6MKncTZ2TU4AXgDLENJ4Qffy5RuBl?=
 =?us-ascii?Q?pbrDCjdtxKnXsMqyL1pZsA5l4AYdql3JYlLnnOrtdAg6XJi1Bxu8IEE5iPfa?=
 =?us-ascii?Q?GZpkwM98YZhpgtgxUh2m/sppghs+dSGl3uj/5EVEvePR6ldmJlznQLDnwJRF?=
 =?us-ascii?Q?4W4WYTpJjUByrk81a2BtEb5iOZPEhds3p0gtxx1N5sBzHrHwP/uR7s3ecouR?=
 =?us-ascii?Q?IvzjYYtIMdAeFkmK0MEE4huUwbq43iXp6ir9xeTRvrjtn7gNjFDgQ6S+vS+1?=
 =?us-ascii?Q?pD6UcSPGUqkWegEo/GL1tKcMzJP5uJiL8y+NfkgHFPA387g5YaLdwgK7Kstr?=
 =?us-ascii?Q?oRIrsf7or5lxte+wIebF7KKoq1lYrKhnRHVM0Iy0VcsflQSS1fNzeTjEMaQx?=
 =?us-ascii?Q?O40cfuwbloQ7RZEy0rATjr1PfQLta1U+BYxuCIbRIc/uLHFGYIkLkBLmol3J?=
 =?us-ascii?Q?Z83pUNZkGm5UG1O/lOXno5te3pn6IIFzT5CbtBYqHorHgaC4DXICWZOgsEEv?=
 =?us-ascii?Q?D0bUqbjoGJFf2TtSu9AlhDke5rmF7DTCP2QAcRr9LkyT5HlMRulqjszJS2BH?=
 =?us-ascii?Q?Lfvu1BPubgTAo9T+KXT1D0PR5i415IvEzAxBQoBrTiMTf3Md285D2Re4uSij?=
 =?us-ascii?Q?3/sun2Qxycs4IFKb5yrT6EDg3F2CyrGNAwB5cAnqaJTA9a9oUv/232+KcO/c?=
 =?us-ascii?Q?BiavQLU9PT7sukGBhUqmosJki/fsVZwSH4LvLvRM76o0s33sxO3zN63Kuvc3?=
 =?us-ascii?Q?nrbl2+KWMiFW4eRLnyXzZAtBXbFC0s6GtCc9ol24VahdcdiusqCiMYdvjCJh?=
 =?us-ascii?Q?v7IEDaJmYi7DngIS4h8ZwP13clb4qYShVOI3ZSRBJ/Q2/GzxuOyqDJyh5g4V?=
 =?us-ascii?Q?R4XWS7Xc2jITz2p4o9sI5LB0REE9hp8v+Jj+aScga2kRA5WzXfUGS7Y3CfUF?=
 =?us-ascii?Q?xaRPgyuuhGnCI4cE/3PLouSojcd4IVi1msqrbo4Dppx6TLkNeXp24hDeiRRx?=
 =?us-ascii?Q?bzLOWyLD1MWTCkoVtzmJdyjBaLJTJHQ+NaQ2sIJVx01CkZsQKIriJ3mns9RV?=
 =?us-ascii?Q?qWR0h5I9bBazLuBrjs2bj6lk1R+vUveUXTgsI6FfddvkIAsZ3CWId+vLW/hF?=
 =?us-ascii?Q?ipFFo+Dfl9bQ5tQr3m94hpvjPivA84az+W0LmEBGjkcc6YooGs/Z7Ak6XMUO?=
 =?us-ascii?Q?k5oAJ2RdhDiMuXVj8Qo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 324a3d01-1ef5-4bf5-c298-08db400d2b43
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 13:02:31.0126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 03e0+9uCu+ufDRgF9cF3z9FxNAulAz3tLmVY8ogqqNGpxFSl0CKsanGlrwmEKDxS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6838
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

On Tue, Apr 18, 2023 at 10:23:55AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, April 17, 2023 9:39 PM
> > 
> > On Fri, Apr 14, 2023 at 09:11:30AM +0000, Tian, Kevin wrote:
> > 
> > > The only corner case with this option is when a user mixes group
> > > and cdev usages. iirc you mentioned it's a valid usage to be supported.
> > > In that case the kernel doesn't have sufficient knowledge to judge
> > > 'resettable' as it doesn't know which groups are opened by this user.
> > 
> > IMHO we don't need to support this combination.
> 
> Do you mean we don't support hot-reset for this combination or we don't
> support user using this combination. I guess the prior one. Right?

Yes

> Ditto. We just fail hot-reset for the multiple iommufds case. Is it?

Yes

> > I suppose we should have done that from the beginning - no-iommu is an
> > IOMMUFD access, it just uses a crazy /proc based way to learn the
> > PFNs. Making it a proper access and making a real VFIO ioctl that
> > calls iommufd_access_pin_pages() and returns the DMA mapped addresses
> > to userspace would go a long way to making no-iommu work in a logical,
> > usable, way.
> 
> This seems to be an improvement for noiommu mode. It can be done later.
> For now, generating access_id and binding noiommu devices with iommufdctx
> is enough for supporting noiommu hot-reset.

Yes, I'm not sure there is much value in improving no-iommu unless
someone also wants to go in and update dpdk.

At some point we will need to revise dpdk to use iommufd, maybe that
would be a good time to fix this too.

The point is that using an access is actually a logical and sensible
thing to do, no a hack to make hot reset work better.

Jason
