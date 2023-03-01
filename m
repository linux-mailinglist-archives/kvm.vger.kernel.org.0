Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78BE6A7242
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 18:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCARrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 12:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCARrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 12:47:05 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4776948E2D;
        Wed,  1 Mar 2023 09:47:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+BYOtlAnOPHTj30Yux1+gJ7lG5AdpubhVSEXNT4Rq7MIIleckayOKdm6wRNxRwjeJfciBKPVRlqWHOx/l63RUeFFcrkQYOSZULXhMjHvr9ytcee2JtFAcVdqPZl2ljudZu6wwvwx32+3cxnJUB7K9Gz2GzJRMHRTYbFk+LimueNxxo4V0vpNS9a364feIewjHLLG6cogKk+OwO7z+Rc+XsUTrleHz+bH6NSi3W3zWN7+uAjE81GjP2qPtoVISRbmzmsewTTW0a3KBCHNuDNmhA2M/+hj7EzgvaNXtNW9HhegxygEXKUBnp46vgde1+Zpm3q7tXuRZxHD8t438xuEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6DAB8pvgpRtnVhTdv1s8bTDNnDoMELC3cKm4HlLhmU=;
 b=mjqsPHvcKvhbSO3B07FF2vkT+yVTEDtepqada8swrsRBPAbRv2uaKiFLNDxRavvhmbnTXuKn3Zr8A1NHGIBLkANpH5cSfq7LfVSFtPhBkSfTF0n9jTtqt2DwJhKfOxbI2oU7VUI+T1UZj+u2fqhj/YETjJ3t9TOhQlQW440I0yxnAkmJRNse89JeHDaWqu9uqQ/+SqJEZB0H8KlBtCbTnjoAmGNcoC+MFOFe46GPywd2IahGIv7D47yEgJcsmOPMkMwOzDNQPUlxr6zhUlPB54GzQvaefuNVRcTHxbEBhQwQ2+vFuwgrBP8E8r6M8yXmOw1z66sRPIl8DwwJhoQu5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6DAB8pvgpRtnVhTdv1s8bTDNnDoMELC3cKm4HlLhmU=;
 b=r/Zq1pMQsBMtInqEanDC0XENpT0x0Ta5HT4mfwSc2mLAhzTmxCaRJoYqH9vHUY9tTHQqCrSLlBn6MJ+Q+W2SHq2TrOVIzCSsOmuyyE/ieCeQMDkbFltZZkeJOJmQ6GcQqlX34nLBG/fcS0HZcg0DZrJ+MDBQtTQCuy6OpImXEIsqXRcI2D5NkLWS2H3LNzAq0EjSk2B4dyOKNzZh7fuHMYQjpRLYkztazFVMNrjCYgtMW1D1bxYSe+/X4IsvI/50D8j98bpxKIq7eQRIP3Z2w1mJ5qUSRlZg8sZM6/3NS/4kUc1dR3k9r7O5RkKEHXQNiFY/em9AFiRHCSXOuxcNVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4453.namprd12.prod.outlook.com (2603:10b6:208:260::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Wed, 1 Mar
 2023 17:47:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Wed, 1 Mar 2023
 17:47:00 +0000
Date:   Wed, 1 Mar 2023 13:46:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <Y/+Pkbtr8KQmUjVp@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-17-yi.l.liu@intel.com>
 <DS0PR11MB752959193D5CBA2A677B1F18C3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB752959193D5CBA2A677B1F18C3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: SJ0PR03CA0284.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4453:EE_
X-MS-Office365-Filtering-Correlation-Id: cce54c3a-2cdf-45a5-1d3d-08db1a7cf5ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XVlcaMp5QMGw2nH1aRjrQ1buK96NWEb6O+KpUb2fhoohr6pxYfdWAVI43vE2LHlSFWTQ0xNQ3XkbMQ57THhPrLCJ5E41xlyXg6C8c6Q+WsCIfQE//hSo8BWUUgX4EyeK/qtpjq+98saH63+7sjRlxkDq4upF6P2KA8TK8FKuEQmvsljeMAkTQl98UGXrZak242Yw28WPXR3UlfXCrDOgcRRm0S717Wxg+TWvCWiPSVLR7sOscZ5Xomls4PdKOoUBSvzQimLnL26yQqVDV6X29tIb7bW+iJsMueC11snUAew1ifeofHHAgXd4q0p0jxVj7i4TVKqlcb1PFReaHZ4q0/TXURWjZJvWEqcSScOI74npFBex7uj9+j/ntqeWQsesgkhAlM6sjqp3eZ80PM5RO0duuGh3/WQXILpqbBvMBmT3JPcs1sJyhYJAlvRHCf5SmUg5FK3ezHxkvrDkDDymh8nRZ1Pol1F/lyJIQTSCR5YLvKjSk6So3moWZdtlsDIQLZfRa/mrHnxDEe81MNiw8szlMMxHLYMXpsmPS4s8SevOMG9vNoJj2gQEhRZ+HdShl/haznBJHgw1EFw+PDhXBE0zG43MQ4GSOrx8rd5ZmezbGMcWBqs0W9cTCslqiWQmhYPS9a5uQJJxLCvsI2bUzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199018)(316002)(6512007)(36756003)(54906003)(7416002)(38100700002)(66556008)(6506007)(83380400001)(4326008)(6666004)(186003)(2616005)(26005)(8936002)(2906002)(6486002)(41300700001)(478600001)(86362001)(5660300002)(6916009)(66476007)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n02bDbS+gwFsSIeWZTeKtGopC2mcHFB1CczB5MqMnrGKsOQ9nFkGKRM4P9Y1?=
 =?us-ascii?Q?otfpYXTDm8cr4PwNo1OyBj9XRPBZIFmw2VVyWQgGAcxbxCTdrdoHOG/tXYX9?=
 =?us-ascii?Q?kCQljFOBka0hZXzb9LszIFFw2+wQOm12+WTuZX+P9QogfHwUqOnchDflZ7SN?=
 =?us-ascii?Q?CZRkLhSa5HYnFfYrAYxXz/2XFu/tE1KjiH7vtHiD3QfCVJ8LU/1D8oA3d7Gs?=
 =?us-ascii?Q?fUpYS/s42a2Pplb90krAHBYabBvrJ82f12YXf5D/jgC4lEavA3mkgrAWagLV?=
 =?us-ascii?Q?7JVAFbS0tWP5RhR4KzUJ4kbqcztV8juSGYGx9HAjpN+i0KFs4srz8IubvDok?=
 =?us-ascii?Q?mUTd5Xja8syGaYc3UxTaPx4l/ycZtEvbFQgCCOz5hinJinkoEnBi5GPhenUr?=
 =?us-ascii?Q?giE3o0OfUONsNNaeQyZ3ivFuWeNIZJou67/CYFewzUcEyaLPa9FAHJ1X/02M?=
 =?us-ascii?Q?Ye+y1ZczpG3pEkc1/TVwPGb8JEYa+JGhFM4v+1ouaxeNuYSsmz3yZSWitbFA?=
 =?us-ascii?Q?G1AGges1g0Qb10yVt7eSz2CK550vwClkc4phGKRx9LXht1GsuK3tEmZp1+y8?=
 =?us-ascii?Q?LnCuksZwJVnT2IX3Szos0CTJ9IEumSLwtFwvZDmh3amtj926jexUYlD68saL?=
 =?us-ascii?Q?VcK244BwKNV61YMlsKF1qNM/DXN5+qqRNYlB9vEYTykMMOEUQYHVAH432sU/?=
 =?us-ascii?Q?Ue9uc4+4sSPWVK2iXZ+xRanpFubghvlwlyM79sDmQp+/DY923/DJekuF1deI?=
 =?us-ascii?Q?53EidkvDV5p/B3Qx+uW9D6t1wgOFIqBTUIap6pPvfTioFnJQh9RvWNi5aJiJ?=
 =?us-ascii?Q?JZV1ctInhBT/xYE7QLypAtfPYzpDbQ+kB/TIxRXH2mJAzmofMbhKeiqlegjG?=
 =?us-ascii?Q?tpDu7CZiCOtoAvcJo5YskWE3dQtNVBPNoHulrvEnhQQZRTppfzZODJ/qgO8C?=
 =?us-ascii?Q?VM3Eg9hb5HDmMg+oGKUcNO2r7lz2/AEWqGtirsE1oG3xJmISSc+B3Ipb67hl?=
 =?us-ascii?Q?E9qrQwwg8XmP4KuE9bq/AmNCr8R8AM9X9qyDbW/AffxhfUwelgEHm+/dtLhF?=
 =?us-ascii?Q?hTVqdNyPbxa3bb4qJsAAEb5zK3v+0Wcbk6n1luJGnjGyisnYRvVU6kGJLbzJ?=
 =?us-ascii?Q?TZ8wLr2wkN/7LD+AYdUeTHAttuLIjbPSCHbedPaI9tHcq9fSf2+eU70/W4qG?=
 =?us-ascii?Q?ahJQ0Xi9sLZEpVyf4xvPCBQLFaGq3SJvB751NeC8hDw5dduPWB8ILpdEbUUY?=
 =?us-ascii?Q?5d47q8C7cMUk/scJz6b0y/tqEp0I0N0iXr4qQxEwO8NvkyLc2FvSasbT73jl?=
 =?us-ascii?Q?HznFCltQ6VTZThMRHzW14tQ+u2nnBEMP9wVDm/6gOcWpUNQA+OMx2peRHUDP?=
 =?us-ascii?Q?k+sAlXllKBeTeGyoywpb3Y80b3l9QeDUkcVyINqa/D4EDgqEEVWPZezGQned?=
 =?us-ascii?Q?tv5v6T4IWzBIP+Xt93IOGENODbJRlqd2FqXdlw53ZqZR6PFDb5MIcESiKVJc?=
 =?us-ascii?Q?S5OOeWDE+fcgmXiyAzSi7JbKtlw4boxuFTSgfjYscywnDrSBgUt6sbaD/cwU?=
 =?us-ascii?Q?89mbB3MpQdoNb+Q5jagqHv8Q4s38lk3sVxLMZ9E6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cce54c3a-2cdf-45a5-1d3d-08db1a7cf5ce
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 17:47:00.7905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yf0Ow1JutoFlkVgGZuOyyj+RmYLakoBDb6Cay2ndl8W0T6zoueJihdWbrGK/GzWL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4453
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 09:19:07AM +0000, Liu, Yi L wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, February 27, 2023 7:12 PM
> [...]
> > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > +				    unsigned long arg)
> > +{
> > +	struct vfio_device *device = df->device;
> > +	struct vfio_device_bind_iommufd bind;
> > +	struct iommufd_ctx *iommufd = NULL;
> > +	unsigned long minsz;
> > +	int ret;
> > +
> > +	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
> > +
> > +	if (copy_from_user(&bind, (void __user *)arg, minsz))
> > +		return -EFAULT;
> > +
> > +	if (bind.argsz < minsz || bind.flags)
> > +		return -EINVAL;
> > +
> > +	if (!device->ops->bind_iommufd)
> > +		return -ENODEV;
> 
> Hi Jason,
> 
> Per the comment in vfio_iommufd_bind(), such device driver
> won't provide .bind_iommufd(). So shall we allow this ioctl
> to go longer to call .open_device() instead of failing it here?
> I think we need to allow it to go further. E.g. leave the check
> to be in vfio_iommufd_bind(). Otherwise, user may not able
> to use such devices. Is it?

You are thinking about the crazy mdev samples?

We should probably just change them to provide a 'no dma' set of ops.

> > +struct vfio_device_bind_iommufd {
> > +	__u32		argsz;
> > +	__u32		flags;
> > +	__aligned_u64	dev_cookie;
> > +	__s32		iommufd;
> > +	__u32		out_devid;
> 
> As above, for the devices that do not do DMA, there is no .bind_iommufd
> op, hence no iommufd_device generated. This means no good value
> can be filled in this out_devid field. So this field is optional. Only
> for the devices which do DMA, should this out_devid field return a
> valid ID otherwise an invalid ID would be filled (e.g. value #0 is an
> invalid value in the iommufd object id pool). Userspace needs to
> check if the out_devid is valid or not before use. This ID can be further
> used in iommufd uAPIs like IOMMU_HWPT_ALLOC, IOMMU_DEVICE_GET_INFO
> and etc.

I would say create an access and harmonize the no-DMA devices with the
emulated devices.

What should we return here anyhow if an access was created?

Jason
