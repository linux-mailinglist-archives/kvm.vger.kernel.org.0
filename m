Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52F26C4B04
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 13:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCVMrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 08:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjCVMri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 08:47:38 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20D75B433;
        Wed, 22 Mar 2023 05:47:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1ri4J4YkcKAw3KCacmzujh4eR4io+qSuXCzFHA6A/gR1CTzsAD/eBS+FvJu+oGD5dUwIJxPzQF1eC3/bWxPizokOb2VTMxmS+iC9vt1QK28f7ZA1DwaXy8dNVMk9Fkv+1zbUQBgDo6GEkdjf2QhA9PXubAqow9Xwg1n7xtUBJJMdqt0xox7wu/dFA7PrG9hIgXiKrGKhoIQSrUiPZdwaBNzkrL89SwRsVIJ4bP3+skj25pRmQg7BgYJi3pYAb/r0rYIAXbDFyLt8sXdQTzsVCGkGLyrdCR1f3gOgYSc6lgT6KAXV6aXMBqnBpGIXbpXmMstoBsuaG/wZVqZZ8JGfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aaxb0kaLHdh1HUU3HDRgeFnBxmge99/pnTRpk2NpodI=;
 b=BK0MU2H5jbw1xT6am1X8r4bcRD9s5Tl3JprNAPXJJp2oXJJQ1hGIYDOnmOmj/Hkf1TYSlCAIR4fWg/YZQOTvoNMsxHa04ZDS4kwGMtCxE8Vk/R3SoflHH7C2FbEZIbovMkqG9KZPBUvjmVgr7yDxyM2ApH56cqogzN/njXhl7rxWt+JFTjO06g/q2+LwOpOfbidt+NIBsX8F88KC+X/B4s4wOs7zf9g3k90oO5XSJWdKYqPL+VGvrZZRVhzfjhZ1ebCytz7L+cKlEzbA3bK/SCxgYgvzmf9mCRof496SWMPYCtuQoAZl4IONx5HGhsPLM4TT5RK7Z/dnklrQjQ4OYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aaxb0kaLHdh1HUU3HDRgeFnBxmge99/pnTRpk2NpodI=;
 b=uETwkdmyaLoE+JeloYGaSXHka6yW4mFIyj0ZM5LDS8KVgL+CEscHoBskB9ajSGwh0bSAR8wWlmozPcLH/qqI2duEdaThL0+W0S5SnwvSXOzWXwJnR4oxqPdQJ02iFto0aH4noBx2d7DjcfVmnZKRNIU7zrShr10idfFQ4e8RBxErGBWXkkWUdaTOYd42Huqp7vLy23O4E2dT/XLFYsdxuJ0DbZ8JWPEl7jNdP/Cf3zdEQyiWo/uF0d5OV7hkkPFF9s1ifPLRxw1wuBgoCBzQaXq2Yyu0JalpRzIzrwgIcyEnQ668dHAAUcL6tuq5+wn1vK+nuxooeVE4rbH7ulhs0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7629.namprd12.prod.outlook.com (2603:10b6:8:13e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 12:47:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 12:47:35 +0000
Date:   Wed, 22 Mar 2023 09:47:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZBr45rxvjeArXbya@nvidia.com>
References: <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
 <ZBoYgNq60eDpV9Un@nvidia.com>
 <20230321150112.1c482380.alex.williamson@redhat.com>
 <ZBottXxBlOsXmnmX@nvidia.com>
 <20230321164737.62b45132.alex.williamson@redhat.com>
 <ZBr0JD7nPBM6Zr1z@nvidia.com>
 <20230322063614.571699e4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322063614.571699e4.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:36e::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7629:EE_
X-MS-Office365-Filtering-Correlation-Id: 426c7b1a-d9cb-4e78-9271-08db2ad39c74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 85gII5AjUJJ5sbwiZPiy9Qb8Vfflwx4dOY45NpTLanySZuAci1+2VpuE3dnvVaScl6dgmrCi2DpJH2vzw52LJehVUMJrJjcrgd+vFBYhqizIO8HN6gx9xmj+/PLoguXD/iISXSgLUjLipHZJVfX0TMLicr65wBnO2IWDJ6RA9kzayrGLCHdtOlDKGRWxI2gXKfX/a6vSF5mHERuKt5QfczAjqvhCu2tVpKMGVnE6l023CHKGp8y21sQECsu4GnihXQIs6s+MPi95p3xuJyof3DtE/20YUIGIXwg6M64AsKyNLufHUx91OeV1O/k75S5ASaCDMziUnsYe383j1oRGbQmNiICCeHLXgKXKxXqVgUWdBq9VEGeFhhjq9Fuc7ubOcyAEBOBbqtZ0Sa1pswEETmS6hGhiscGQ6Z5LUKzCHBDYmsiB6P5i+pOzvvMgPRhl4E3VsNEPn41nch40x+lgYIlgr7WsDihHVWNl+6MSqYe075QfzUbfvU/mTnN7rhcSk48MfjMdHZv0VurtKDQhoz7T9wRjGk0m9lrvaR37N3AnBWrcFBA0DeLcMnrRN3kTM3fRQ0I0keWSO33mNJctk+p0FaP4xqpTJrgD9RU+vEhQL4GxBwkWr525UEftWPzRuY9tbzjQus+cHU4ZOATwSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199018)(83380400001)(38100700002)(6512007)(478600001)(6506007)(2616005)(54906003)(2906002)(316002)(7416002)(5660300002)(186003)(36756003)(26005)(8936002)(6486002)(86362001)(8676002)(6916009)(66946007)(4326008)(41300700001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?35NZM/jQrgaFGzzk3RcBjMjbvTpgNofFvkejwa5ZR5aZK15BUog82Xm6eTFM?=
 =?us-ascii?Q?U5VRaEo5cif2Svl6697jndkG3XE8dDFsrb5Zf5uFjUsNZfrf8t8GzaLKw4ef?=
 =?us-ascii?Q?XB4DR852USkuHoaSDkI/k0QgKhgA8g1WFWyf/ggteGjAE9sJK7DQkcBtGT0N?=
 =?us-ascii?Q?Ae8iSgEL55R1gpCvJt3AwDIKLT2LU2hmojnaLM82FEVeX/kBic2oEyYqVWtA?=
 =?us-ascii?Q?XU/KgCurTveX6+WwbK2o8UurL1KRkqtQGagYv9RWHgiBIcwTNlbxLTeGqadG?=
 =?us-ascii?Q?mITjGH8vM644CG8De6pjggWXXPkjh96IsAjoiDtwVwcyVD/ln4emXf4wXlDx?=
 =?us-ascii?Q?J23Ur2zhWz34PIIYWF1nQLP+9YNhEWF8Au1m+t1v0FogQHbpF6E//UZ84mc0?=
 =?us-ascii?Q?xO4/DILAKiwiZcGCF4CDPKg/heR4Paoq43h0e88c4+W/XL+26eDA4GFM9V15?=
 =?us-ascii?Q?pIrfvfOc5+p5+6nvTLpPoZkRUbqoQUXQ1SukpAKAZU7StOPDVnmE1ngOayIp?=
 =?us-ascii?Q?NZkbOnSJtwJfYjHx7pjPyNffG4AF03jlOJb+130lbWcjZhOtrWFPbFlM5/FA?=
 =?us-ascii?Q?BAhJER4gfWYUAet9JgZOmnj7skaYXajONe3uTGZnQQ6Mudw2UfmBHwdcz/+j?=
 =?us-ascii?Q?ve6SwKeURMny3X64J7xF3lGhLgOOIgrnrIpQELI7KR4YEbw2GOM14k4cvRKd?=
 =?us-ascii?Q?PpkyO35/3L6oBQ1qtVTNoYimdzLLg7ajOF446wvKT9ydOLl4rHMzb2IXGRf9?=
 =?us-ascii?Q?fzBgANQrP6PpUlBqftEfy2lR5xGBUkqoxEAs+0vv5nQPyv6WX9btSo9lSuys?=
 =?us-ascii?Q?KYZg06DyRU7FKROdfk8Mf24uLPL+bS2PXuMR5HAzvG24aDKasjXiQnbhbm9M?=
 =?us-ascii?Q?7TnEMJ7OOykXpFPTwTL3dclpX0fgdJpcGHmfXIbEvCSjkxkRIkzh3ECC6ldV?=
 =?us-ascii?Q?6aCiVSEqZvKA4iE7t22Xl5yNt4E9c8L5tXoYSsf1Bk9kXg+Br8ROkjnPawKk?=
 =?us-ascii?Q?Bgd6MRhrEPbNnSU5hyyhMoflAZVWR1PLL5Plt1ndW2eCyRWDV9OJ+AW4uk+R?=
 =?us-ascii?Q?ba5aP22T28JZfiXTvCUaJnafSLLryrJKmrx6J3c0f5bcS1aXGsm2J+XVf9yx?=
 =?us-ascii?Q?qXcFmppky/mBZwxGPlBBaAHBSbXgl7hS6sp0gXkNdoKW6cAUDGiCS5pXjoya?=
 =?us-ascii?Q?EALNR/cOa4OLGb457N+1VmGlvqWKewrRDjPOzpFWYGunY8GHl8nOAYQMt5L9?=
 =?us-ascii?Q?7p+OH/ZoEZ2AnwCQ2k+I6OMcFj0q9EUA4N9RtN9bDkDA8ZwRhlVZB2fm/2Md?=
 =?us-ascii?Q?LE9q/OSKwdg+1SgHKxgA/lHSuqdgOXm69NWtLyH6bnTTOY+xoUv2DSLRHcCD?=
 =?us-ascii?Q?wAUGb/Yj/fL5pbQg4FhHZjmlggq2zdRHcTyobiKN7ms7gbh7PSAaHiemqqeF?=
 =?us-ascii?Q?RCR4+T1JCzz/UeSsl0iK/On2oLzAdRWOTfwEQTiwWnO8DMJBLBrIOozqoTTz?=
 =?us-ascii?Q?ej3Cif12W0/JZ8rc1dBT8UvB3qWF5l0DmrU709u97cYNmTXxDmXl+MGZZPDx?=
 =?us-ascii?Q?GXfRzOdK2O70fw+IinLlzoz4cag8bVigyPDK+pAz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426c7b1a-d9cb-4e78-9271-08db2ad39c74
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 12:47:35.6127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eygnLD/WuKmXGAixERXH+Zg7omD5FROzYZZVWizh/+AocbWO+sj4oG1KHh0EyZ3H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7629
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023 at 06:36:14AM -0600, Alex Williamson wrote:
> On Wed, 22 Mar 2023 09:27:16 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Mar 21, 2023 at 04:47:37PM -0600, Alex Williamson wrote:
> > > On Tue, 21 Mar 2023 19:20:37 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > On Tue, Mar 21, 2023 at 03:01:12PM -0600, Alex Williamson wrote:
> > > >   
> > > > > > Though it would be nice if qemu didn't need two implementations so Yi
> > > > > > I'd rather see a new info in this series as well and qemu can just
> > > > > > consistently use dev_id and never bdf in iommufd mode.    
> > > > > 
> > > > > We also need to consider how libvirt determines if QEMU has the kernel
> > > > > support it needs to pass file descriptors.  It'd be a lot cleaner if
> > > > > this aligned with the introduction of vfio cdevs.    
> > > > 
> > > > Yes, that would be much better if it was one package.
> > > > 
> > > > But this is starting to grow and we have so many threads that need to
> > > > progress blocked on this cdev enablement :(
> > > > 
> > > > Could we go forward with the cdev main patches and kconfig it to
> > > > experimental or something while the rest of the parts are completed
> > > > and tested through qemu? ie move the vfio-pci reset enablment to after
> > > > the cdev patches?  
> > > 
> > > We need to be able to guarantee that there cannot be any significant
> > > builds of the kernel with vfio cdev support if our intention is to stage
> > > it for libvirt.  We don't have a global EXPERIMENTAL config option any
> > > more.  Adding new code under BROKEN seems wrong.  Fedora ships with
> > > STAGING enabled.  A sternly worded Kconfig entry is toothless.  What is
> > > the proposed mechanism to make this not look like a big uncompiled code
> > > dump?  Thanks,  
> > 
> > I would suggest a sternly worded kconfig and STAGING.
> > 
> > This isn't such a big issue, we are trying to say that a future
> > released qemu is not required to work on older kernels with a STAGING
> > kconfig mark.
> > 
> > IOW we are saying that qemu release X.0 with production iommufd
> > requires kernel version > x.y and just lightly reflecting this into
> > the kconfig.
> > 
> > qemu should simply not support iommufd if it finds itself on a old
> > kernel.
> 
> Inferring features based on kernel versions doesn't work in a world
> where downstreams backport features to older kernels. 

I don't mean actual kernel versions as a compatability test. I mean it
as documention and an expected "support" window.

ie we are disclaiming support for STAGING kernel as a matter of
documentation, not code.

Jason
