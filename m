Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C4A6ADED9
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 13:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjCGMgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 07:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjCGMgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 07:36:39 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AC2457C2;
        Tue,  7 Mar 2023 04:36:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djoD1B/jOPcDLiBbTe22+ctl3u+2nOD3YKy/fLY2r3UgpKysfLv9lP2ywjLLP+eERyZFNjZfdPTskkp2JH/23UjBCZKan9TXivFwUbia7UCh/OiK0B8dHesft3xMa67VisYK8VNS9b5FwAU5mrNarRuymI4sFBJJNkuGRDgWWCSqZp9+owvEAsm4fR3h2nsDkVIB36NtofhBgB+KbiZohaix2WJcybvMcohE+LiPZ/WbzHiR6vNJZ4Sfey3hHPeghJdEGrzEfl9+n1X+NFm6LKhjA/WpC3i4b8x8pXjCrn80F6hrrcM5/hwiJCHd1Rd//sfZ/wECIdUNLhSPPqzRyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJ6UFtaFeSm1Dt7Evl+pdSh0QSIJxGBoBmrjkWx5Ltg=;
 b=TP/4Zk2wrIuMGtQUbBm/hyu9dVATYHQPiOkUyfH88JvAlggVilvchN9blkDLGfsUvLNd1NlGHnsO7MJM44ZN7AtA9dsgnKV1o579cWXECz3RAAB4aJaAoeHXl4pHai1q7g+VBpQGWGTVV7D6XGZe+kiBxfZxsYuXYT6K9nj05E1A7uMURzch3SAPFHrLeEDPijf8kCFePNhm+Wo4h05ijoP7l8R+1pFS1JuOdL3lfbvwsN0JnXiKZkt54SFRovIvBUBKkSZYQFf8WhKgGriIgFJ0KlZF5hRbkn7AQExKWz1uy9rfEu7tHV/7ZVuH8IMRna7EbfekAIp/QeSzvVRRxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJ6UFtaFeSm1Dt7Evl+pdSh0QSIJxGBoBmrjkWx5Ltg=;
 b=K6Au0SDSf7j01Gm3CKcvx69SNydHd6pkTDd2S2wr1IoEaHdH5I+DD7XRrzw/AyJoYU75qRH1RbzeHvOh75Q+9HYW5dUvT6DUzFQfYUsq4JL0+45ny1+HMLVrJx6unJaADOBduDAZn2oeApBAR5LFlewVCg9jTaPtGzZUloUrHdpsHu30Kya7Th/0wwysivKvgMhgxlDGOrNtWaonZl7IgXCfFj1cOyuODge1GdP+FPMdKbCO3pdutpO2zkMgO6/ffrvM2H/BbZ2cCPhh2qKFskVl+uPVsn3t4fKDA4G+AxcFgfDoq9kKnC03fFWL1qtNnB6KH6ocrofYaNDKM/mqZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7153.namprd12.prod.outlook.com (2603:10b6:806:2a4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 12:36:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%5]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 12:36:32 +0000
Date:   Tue, 7 Mar 2023 08:36:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
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
Subject: Re: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZAcvzvhkt9QhCmdi@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <ZAXny4NDDq42NUxE@nvidia.com>
 <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:208:e8::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7153:EE_
X-MS-Office365-Filtering-Correlation-Id: e2ee592b-6b3e-4949-2bfb-08db1f08949c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BljbNDnb/ueS8w4chxtwtARNRX0Z6vWBLDGT4ZTsw1TH1VG3UWMSz1VXesHc4jjACVgD0JBsai5etVVRvXmbpcE7dyuGo1oYEUzaTaLD194EtyMIsgF+ufrMH+0BM4mOjivn5LVC2in6as6TZY8ZtqmaICdDnz0VkAxtJC77USCt+Jg2N0N4jKlob31a/Hc/Dmx/CSt6POHFMZSC8XYlDpWVhKrb3b3L8HnXkf+gjAhYgTJMNgL4vqjKey52v8+l4toUmoySNB3dderEwIwRkIc+eUrj2Zpr/k8Ps0OELiMtkDArN8aWeV7OD6lcAnnk/vDmboffeAicDaYgd3oR5xqUkzhFRrMyRrvwKURD5azBI9rnrgKbJuk/eYELu9EN+iu+WNTI4F1uij7VVIOZeP1RDNKIMLNIoz6JUTx8jMYq1XKN8qevmIvVEhQYDWZOg3rCzB3FA8ydL6r2HtlAVhgRkQ7lEYc+7uWs8NEjC5BD5WLp2RupU57bTot6fJT5g8NuMWkGmWku8UcpCB2Wq23TUszy9K4LgKUlAkoE3NS+o8LzAr+vaFLMiBcmzRcr5OR/sI3NSXc5cT/KeRvCUhRAYsiA5P4/5FTbIeJ8mYROlKpZTccS1v03LN7Um7If8nYC3+gG0H0qZUPNl+eBfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199018)(478600001)(5660300002)(7416002)(186003)(26005)(83380400001)(6506007)(6512007)(86362001)(2616005)(36756003)(2906002)(6486002)(38100700002)(316002)(41300700001)(66946007)(66476007)(66556008)(8676002)(6916009)(4326008)(8936002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cBMfK1+dm2PHm2v7DuKkBXw9YelArM3xaO7dGKTa/9wZdKMDepTJ7TefIDES?=
 =?us-ascii?Q?O6fF1W1EI6FQ7ewPlky1yhNNgrGoJE/kZGzPU9NZg1laDtCRYy20jBs0Fm+e?=
 =?us-ascii?Q?dRv2N+KuimPZSbVn00bwDyUhAVz1eLOJ363VLg6ckGWt9PvP02rMbC4Q0SAD?=
 =?us-ascii?Q?WR85CmisqF2iZDPzAzV6obYE1Sj8L33gvMGULiZ5lgDOKxafaVDJ0K7G0RSJ?=
 =?us-ascii?Q?bAg3MQ1Jq2vSd6e+0Fmlucn61U7eUA69IBJ8ct9Dzsk28Q09xg6eJDvvbGE0?=
 =?us-ascii?Q?zgEXdy9kHeudDbhGhA8FNc2e3J6zDyyxIvoNC0ckzgUxeLbwBnTazDRhrYPx?=
 =?us-ascii?Q?XMa7AI+VgA5qpZks1jxzctyb/dRcXOauKlzUUkmkivww8IkqKb+4EF6Q+qZZ?=
 =?us-ascii?Q?0FMB9y3FXUDM3dv2MhCr2TpYz/tbFLGczhl+ACjsgii2DIFNnQrh6VZXG1my?=
 =?us-ascii?Q?XK9L6u5DMSHE0ksVXbCO7qqV3gzTor6OjwOCGNOrf6puf2K2jdbNraDOtnLg?=
 =?us-ascii?Q?/xFaSs1aR5okRbLFvdl4ASsVmH1x6UDsdlDUfqvscjyJWljoiLabz0XKevwb?=
 =?us-ascii?Q?HPqs4idO8RQePzY75svqzXdwse6BbzWC9fiFkDZAH57jbvtj2TRZ3n2ObTaH?=
 =?us-ascii?Q?b5yQqSxbPBrSavrU3F7qEf67AaXNJdsmbpTL7Lz80t8bV+NOaQ74JJBWmM54?=
 =?us-ascii?Q?yEFFSxfCblEYeUGKDjnY0YQTVX2Jwa06SeYpPz9Lde0UJxnYFwRvxypf9CHP?=
 =?us-ascii?Q?McfAqzVaCLCGo94cCjwTvGfu4GSPbzwhNfO7IVhElpDNHvZsKKi7UHtiAk/0?=
 =?us-ascii?Q?fACssV4nv5JkYLbrKpNQ0GHcJTqIBpG3cfn2nSdkOaTjqWw7y3BvxM5RA7+y?=
 =?us-ascii?Q?FhIz4g6md9kqNPLZfrhzsftUUtVFsB4kG8PiMH5oopYEFCHt6uykIYwRSk4l?=
 =?us-ascii?Q?br+thOFEQ/fF5TuPhCR1BtscjZn+iSUzUBVUaf52201nskS4RkzomF/mSHOH?=
 =?us-ascii?Q?Z97UA3IyVlnqpHG2sHDQvc/zN2G7pRvezJ+bTn1VCli2O7mdYxY7oO+HC0t7?=
 =?us-ascii?Q?c6By0+mbnI7FD0IEXBc6VJxr2UNaTT/sbYH6B0Jvk09yBUnCHofnxsww12W8?=
 =?us-ascii?Q?VlieQ/7Sh73+tPyN0GFO8dxCF2FFMQqFvysmEH7RqXzfsxcr1T+tLEJ5yo0j?=
 =?us-ascii?Q?LKT3hnIscHoJgolsywazQOoa9svPFSeuCM94/k8Fe/H2bE+xTz+7vBsxjVv9?=
 =?us-ascii?Q?O+N4O+niMIiGTj5nLQHRm1qEqNu3QckoUszK7zocrDEgnv/VsH/OagqkgxUp?=
 =?us-ascii?Q?ckZbH3+kJPdpMQk04IU7afwk/CBxDhf9Xup4cqoDmEd4CtEgK0bBQh68WbUr?=
 =?us-ascii?Q?OzHDkshbEPMat3nVdsm9xAfXk3vRgPcpD5vTWhqpCz/zFdfe800609vAr+NZ?=
 =?us-ascii?Q?TKTVeKwIpNC6jeZ1XTznRNeMNMnsbCkYgzgrJa//Q54uVqUaiZvoVOuAejJX?=
 =?us-ascii?Q?ipQvAb9/nwdBH6EMJ+C5ZkC6Z49Xl/AHGDHLiMhrb1tYq3wuIekH8vmncbOC?=
 =?us-ascii?Q?nvpCGb0BnEgvyc20UnOZJ7g4cLLuwqjXUDpXt1Y4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ee592b-6b3e-4949-2bfb-08db1f08949c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 12:36:31.9487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oqzXGlHvCr6UHGLQJiwJ3wQp8i4HG4Y1imp9OcVsOpHlQjP4gsij7Fxib3Ku3Ppv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7153
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023 at 02:31:11AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, March 6, 2023 9:17 PM
> > 
> > On Fri, Mar 03, 2023 at 09:55:42AM -0700, Alex Williamson wrote:
> > 
> > > I can't think of a reason DPDK couldn't use hot-reset.  If we want to
> > > make it a policy, it should be enforced by code, but creating that
> > > policy based on a difficulty in supporting that mode with iommufd isn't
> > > great.
> > 
> > On the other hand adding code to allow device FDs in the hot reset
> > path that is never used and never tested isn't great either..
> > 
> > hot-reset does work for DPDK, it just doesn't work in the case where
> > DPDK would have many VFIO devices open and they have overlapping
> > device sets. Which, again, is something it doesn't do.
> > 
> > IMHO we should leave it out of the kernel and wait for a no-iommu user
> > to come forward that wants hot-reset of many devices. Then we can add
> > and test the device FD part. Most likely such a thing will never come
> > at this point.
> > 
> 
> I think we don't need to have this tradeoff if following Yi's last proposal
> which requires every opened device in the set to be covered by the
> device fd array. with dev_set->lock held in the reset/open path this is
> a safe measure and fully contained in vfio-pci w/o need of further
> checking noiommu or iommufd.

I really prefer the 'use the iommufd option' still exist, it is so
much cleaner and easier for the actual users of this API. We've lost
the point by worrying about no iommu.

Jason
