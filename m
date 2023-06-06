Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E8672469F
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 16:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbjFFOqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 10:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbjFFOo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 10:44:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8AE30FC;
        Tue,  6 Jun 2023 07:43:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPHmqoD2exwHDHC/HgGlTp+hlBaNAXNFwI413t6f1udXcCTYVg/TLjCu1kUmlAsEBhWJJrMwN6GmBKhRT5gZ9XeeG4DEW4fZ3GMgngRltCRA4se61fPVx80xLLE5kc7j4u4iV3my7btu+E4xU75mByR4wu8bBDx2p/9H7FoCP+/Fpr1FHV+1yvcJlVzRXqDmSKNftVe6m+9FAQPKc93aWP3YHBdiwjTWoziTH682+iyz8PmxciY56tarrtFqOI3+TUUgW8ti1e4b39hsyE5f4On6n7e4CjuJAqDx10a5EgZeEASMhfmIxmU+UuTPK5hCf7g+q4ZhkM7rXlfqaPVoRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjPI7xpe6WCT5wwN7nyo/FuBotYT7JWBh5IOeS+2ShU=;
 b=TfiMX+PDNNg5Noz/EcYLD8moi2/UwaM/mBhNbkJDoJrB/aR9Ht7QMqTK2AOJDR0NV5fOPAnA0yHwqIMfvy42x2mnY6r353k0YalB5jhUL3Yeds08lj5uqqFPBdwXsjL7csYhbJwSboPT0BdoSLvdUQZVuFawwLRZcGB8x6XSzaB5m6nyqfhAsYLKJYLyOMPS7/yL+h4X2usVOJ80kz3azCZeuQpqzKD841yfxoIBXfMnOZeLsN+6xmYUlX+z0PBC+G57hklqwJ3ihJOO2zkNCzNiaxELJTcz27QLY+rSpC26EYjrjgSCqgvs2IqIT9Wop/ok1f7vo4ptcCwyqIFNoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjPI7xpe6WCT5wwN7nyo/FuBotYT7JWBh5IOeS+2ShU=;
 b=M4y2HByHtfU2KU03Ox31Wiest8eRkpWLLyYCrq4Z6GBnSXAH7sl5SUPpVpkpNkyZZszMS5QBBh5AAFJtKT57MYECreEB1Mywif+7UAFWbppesvgmmFe895sMCt4MGZLkZA3SMvuh4+g0qo5D6gJCnoKrBtQmemnoGid1AjMWIMnrC++Qp77U//8+AGhWz4vYXzzsJuvmzMrdAkMsiq09HpFb9QZAJqjV+OuKaIKj0+9BQVopN2XgD5zxWkfFyhkbSSn310/pqhRWYfUQs1zfoafdvbm7tKK//9djfLtXQJ63dpUXSIv4DsmEq17scV8zV0mzKHdzJxJcJI86oBVpXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7810.namprd12.prod.outlook.com (2603:10b6:806:34c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Tue, 6 Jun
 2023 14:40:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 14:40:54 +0000
Date:   Tue, 6 Jun 2023 11:40:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Message-ID: <ZH9Fddz1ZUAsZvWL@nvidia.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
 <20230513132827.39066-21-yi.l.liu@intel.com>
 <20230522161534.32f3bf8e.alex.williamson@redhat.com>
 <DS0PR11MB7529096D1BE1D337BA50884BC3409@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230523095025.1898297c.alex.williamson@redhat.com>
 <DS0PR11MB75292161F081F27C0650EFB3C3419@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230524093142.3cac798e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524093142.3cac798e.alex.williamson@redhat.com>
X-ClientProxiedBy: CH0PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:610:cd::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f0929a6-b5a2-4b15-fe79-08db669c0870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cmpO5rPcAyjfM2/58/lNCQ6bocXx65d2PkMIMjki1NC2Fn5vldTyzabqeSUmarZDMsS/92rsRLPFJLZ7bWQy8NhmZSebDVewuYKKKHB1OIIRGLPxoz9WakZuhT8UApArtFR6kA/67J0fTmrf94pcxGRjpTns6qLNhVtV3AJYDDy4Lcg4o6TFh5PuF1AjDFUqzd0g6FEvYr1xGfxhduyVjQ2W91MQWnKzjL35KYqieJa1LDqVMRv86kVx/BKX5R70NxY+eyM0glw7YQ5qvF7UOR4XiMPWO1Oh1PbsIZZcaze2GIgNkkoIOXkKzSaUfZmiGIuIoK3qr38Dlz+2vV898PSbfYwdOS1QDK9sKrMnBTQe1lAE79FcBAz8X3qH6ZIRKa/eUfAVL0Sklt9HFb3CWcMt+GnEmppLeBSXxpUOMWCcb9C5gNHyseXPbSIF8W1Xdl0iHE1AsZ9+RMqXalSbgGQAQm9bkMkeFjmjdF9ZH5LD8yQAT0tDLqPgkdSlHi6EsOIK28JY7KSJ40WTwYUmM2qZu2Co/RBiB9G9I+0KPpvqfKtJXTLlHoyNI/TDaJn8Zb/nXJWJvZuEIo3eSkKfE+otIZC50/JaMIh8AglYZiE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199021)(7416002)(86362001)(6916009)(2906002)(5660300002)(41300700001)(4326008)(66556008)(66476007)(66946007)(38100700002)(8936002)(66899021)(8676002)(54906003)(316002)(478600001)(6486002)(186003)(6512007)(6506007)(83380400001)(36756003)(2616005)(26005)(83133001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KZqeIJC2F1zUnNmwM4+1l4EHRfMZfnXEJeSOR8N7BJK7BnPiQZtMjnhnAl7d?=
 =?us-ascii?Q?57Ry0K+WBTtlULUaJbX25dKYboIhcbhrNBR24ukZ2GM3npljxRmgB6N6bwkB?=
 =?us-ascii?Q?tPmzFozDS8exP9pP2VzzZsoapLVwHt/5T6nxIbSdmuxMo2PZEIzzUNJuhZFq?=
 =?us-ascii?Q?sUvOWlymVwErzyjCgmsFhHlsohbLuu3Bn6d7IupGOlIZCy6lNYlVwdBIFzn0?=
 =?us-ascii?Q?Dcv/6u1aIvJLRxAFJk+3DaFAKc5YrF76LplvbKFMADmL4Vklwn859eWUXEkX?=
 =?us-ascii?Q?403uk+jFX1nmhGwy/IwhNQ7V8N36x0+DF2HGx9v7rm038SNAbctfKrrUP2IP?=
 =?us-ascii?Q?Ssy6d1tOp32vT6ovfp7p7brHD10Ep2yTtnfagF+l7NnrkUpHVz3TPa8I16PK?=
 =?us-ascii?Q?cnS8bm9Ii6Eg+C3VWqO/NfPfvQxr9b2Js4aFD585j4rAk3KpqKYp5L45nXfq?=
 =?us-ascii?Q?56g4wnVDIzP52rip5dVOP4EdbP4kE2gjnN5lztfH8yHY8evMGpLJTMSF+2V8?=
 =?us-ascii?Q?SASzLCgiUeI+BuiNLjWIcUaoaKFhEbwJxih2Gb5fsdHAW0EugVBBCZ6Jiumm?=
 =?us-ascii?Q?zX4FF7GpJybc/SuDWxt+cjF2LJn9GxOQkeD83YPIV1GFR5Qyh3ZQKXQebTmC?=
 =?us-ascii?Q?PUb5wzIEkB2troFE6wRnfwMbgSpWpCOrrluVambTox2fupUSq7p84lX72l39?=
 =?us-ascii?Q?YFE6YckdJg92IJp43YUNxwF2EHzD6zW1zF/TbdO5E4INsNvL3ncDgOhy92hx?=
 =?us-ascii?Q?dqaFzbyC+HLOb15EfiH0IHLeGzChrpRkJIfWe4GSAF9NxhFuEm0Y+lstN0rS?=
 =?us-ascii?Q?mZnxUVtIMFM55pVJiyQ4jYp0qCGhzntEL7m40rM+jiR7PDIzsRBX+DO08aE+?=
 =?us-ascii?Q?Tt49PZehVvwYIlphcfFLW02c9lOhIGAiQ/tc2TdfW6B9ezbMqvgDfw/dNFqL?=
 =?us-ascii?Q?x2dqdyjsePxiyDNVap8Tl9aHgMQeHJwA4ofySBPsL/3lPVyFkjE/K8N7xGPU?=
 =?us-ascii?Q?VRl7nU6DOX65ooDgYexnnd15ua7HV2Fbp1NoYr1sp+WKp1tfIds924q/iXXl?=
 =?us-ascii?Q?7GP9zYq4GWpBVj7ywQk7pxaiw4dGSzySc3pHcOT+QOIRw5dT6nuXUU0ErKXu?=
 =?us-ascii?Q?+DVIm8V8CGYaU+ZCjuOHf/C/dRn6WT0+MlSYI/W40ShVcc7umlZwqGSXoP5c?=
 =?us-ascii?Q?NwOV+VQdrxuoDI/9+gywzu/h7RGAxAqnQQotHQJstqmRBpJOFWPZaDUSpPbD?=
 =?us-ascii?Q?DHr8aphqAiH0G9ZYWwRMHDEOK/lKfn/QPHpfbfIUa0XltztDk2QIE/H2mrKC?=
 =?us-ascii?Q?R1M60YLVxzPqauiH6ed1A8eI4zDjm10am6EGIDw1AStsB93m6sHJ3Q0zqk4v?=
 =?us-ascii?Q?L6IJiHP4ZoaN791aQQTrPEJBTyeOBXOfpMz5wKKLKRthl0ysEXSHG9E8EQZs?=
 =?us-ascii?Q?JIeUQ9RR/UwJNWgZRqNQxQaRvgzo33ZVZDzgKKPHWH0vudh+zSxWDz+eW5iE?=
 =?us-ascii?Q?AQWPsYVKX51pf34WV/8x2lV5ePCv4vfSQzy5PExRBwCWCyN/F1Wjde4PpzZG?=
 =?us-ascii?Q?QITSF0JFi6cRYSKmI5+qa3WdBOzYIa8LyB4fyyOq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f0929a6-b5a2-4b15-fe79-08db669c0870
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 14:40:54.7240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XS3l24dsjdDbWmije6MwXFo9Tafgb/uDgBnQyM1Hodmpz/q7ZRVm/Grv8l1WUEGB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7810
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

On Wed, May 24, 2023 at 09:31:42AM -0600, Alex Williamson wrote:

> If a user creates an ioas within an iommufd, attaches a device to that
> ioas and populates it with mappings, wouldn't the user expect the
> device to have access to and honor those mappings?  I think that's the
> path we're headed down if we report a successful attach of a noiommu
> device to an ioas.

I understand we are going to drop no-iommu from this series, so this
below is not relavent.

But to clarify my general design idea here again

The IOAS contains the mappings that userspace would like to use with
no-iommu. Userspace would use a new IOCTL to pin and return the DMA
addr's of those exact mappings.

So attaching a noiommu to an IOAS is a necessary operation that should
succeed. It doesn't make full API sense until we also get an ioctl to
return the dma_addr_t lists.

What is special about no-iommu is that the mapppings have to go
through the special ioctl API to pin and translate, the IOVA cannot be
used natively as a dma_addr. The IOAS is still used and still related
to the device, it just for pinning and dma_addr generation not HW
isolation.
 
> We need to keep in mind that noiommu was meant to be a minimally
> intrusive mechanism to provide a dummy vfio IOMMU backend and satisfy
> the group requirements, solely for the purpose of making use of the
> vfio device interface and without providing any DMA mapping services or
> expectations.  

Well, no-iommu turned into a total hack job as soon as it wrongly
relied on mlock() and /proc/ files to function. Even within its
defined limitations this is an incorrect way to use the mm and DMA
APIs. Memory under DMA must be locked using pin_user_pages(), mlock is
not a substitution.

I expect this is functionally broken these days, under some workloads,
on certain kernel configurations.

Even if we don't fully implement it, I prefer to imagine a design
where no-iommu is implemented correctly and orient things toward that.

> beyond the minimal code trickery of the legacy implementation.  I hate
> to ask, but could we reiterate our requirements for noiommu as a part of
> the native iommufd interface for vfio?  The nested userspace requirement
> is gone now that hypervisors have vIOMMU support, so my assumption is
> that this is only for bare metal systems without an IOMMU, which
> ideally are less and less prevalent.  

I understood there was some desire for DPDK users to do this for
higher performance on some systems.

> that are actually going to adopt the noiommu cdev interface?  What
> terrible things happen if noiommu only exists in the vfio group compat
> interface to iommufd and at some distant point in the future dies when
> that gets disabled?

I think it is fine, it is only for DPDK and if DPDK people really
really care about this then they can implement it properly someday.

I'm quite happy if we say we will not put no-iommu into the device
cdev until it is put in fully correctly without relying on mlock/etc.

Then the API construction would make alot more sense.

Jason
