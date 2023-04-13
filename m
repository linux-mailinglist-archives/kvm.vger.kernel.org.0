Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDF96E0D15
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 13:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjDMLu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 07:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjDMLuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 07:50:55 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EC32D46;
        Thu, 13 Apr 2023 04:50:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZbgNxR/XlQszmVMKizAuNJAOJhiNC3Lak6wY2ChmwokcEs4J0ADsYUltc3GXX72ENjdKxn8oHR0JOrcBNIRQvyYGWkadOErmMKZUu7OtNhr5rjeJrCkTkyP3g7wp4bqd5EinWnm8h+HeHcDjAWSw0+9dbHCJVzwQaxDP9v2xGWynzTJcpBQVMZH2NGH0R9dfiDFsEKCHh1NVlOpt7eoIUa9mUjNs9BEr9KbDaiy8KXt/I/ku1SZUr5g6BsqbnZGFekQbObBOvTn/JPSm4qFPTbsn9V9ohPdjqxpp5ShijM/izHqu1iazySReOND3+CqURVYfxecWy+cfAm8MUDTnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CP87/k8x7UMZUQxVlM2tAwltEYKodH5ntBZfLxpxKQU=;
 b=gMczkbZlI3qzXgmvkznHDSOxUfmVht/8lMlCGthMRydDF2BywvFHcroUVKse85SFYdGXjw2da0fDq2tSZTOrOst1gMWqYFG7JRPGp/Z1ay7fvIa1LBqZdANEOqyMS60e7pJlYq3ggsyKua17pv1oxASd84yuwxJ4K66xDfArTsTYYjCR3sRlpnEtKUQk/lcbGwG9/LXJLsR8F5tCCJoAVJJrXLumO4CsxXybemgLO2aaepTS+d7+j9iv5NoxWG1zHTyGkHzkk5lDT04ucUWsV+XpGQGOtVrTKzXg5ujo+gcsHRX+YIspKcH6C0YGl9BEl4yXueoqUNZlXTf3GpgAcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CP87/k8x7UMZUQxVlM2tAwltEYKodH5ntBZfLxpxKQU=;
 b=Q4FRv9zcdNuPJ+SVzA9zrauD+53nt2G57v05apBLE9H7uJ6meAzGUuFlNSP8bTu8I5sHiYybW6oEQ3pl2Y8pmAItu4Rlad9xDQac9nFOouL2L1JKwwRix5ugtvPjLYIjtJPqvZWUrt2asFQIGk7fqj5AR7NYfXbRzNf+I19Pk9CRIWuRGT6T5FIaXUJCki5oX5GJ35t9a/EInkNeK+YvTkcVa0exLQMXze3CabiGHsGCoSbSVfK1tkHtwRnX2gw0fvg3S8APC3/q9Z4TXSOmIzL1qFEWzHg7pUQY6l2rt+9kGOl4FbvFAezZQybOf4+xJ3QzKzkr54DeWQLoCCrz3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB6127.namprd12.prod.outlook.com (2603:10b6:208:3c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Thu, 13 Apr
 2023 11:50:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 11:50:47 +0000
Date:   Thu, 13 Apr 2023 08:50:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
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
Message-ID: <ZDfslVwqk6JtPpyD@nvidia.com>
References: <20230406115347.7af28448.alex.williamson@redhat.com>
 <ZDVfqpOCnImKr//m@nvidia.com>
 <20230411095417.240bac39.alex.williamson@redhat.com>
 <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <20230412105045.79adc83d.alex.williamson@redhat.com>
 <ZDcPTTPlni/Mi6p3@nvidia.com>
 <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR19CA0059.namprd19.prod.outlook.com
 (2603:10b6:208:19b::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB6127:EE_
X-MS-Office365-Filtering-Correlation-Id: a4835954-bfaf-485d-1129-08db3c1551d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZMEM8qbP7q06cVVtkOSO0bvD5gPU9NaMFoapOatdC00mrtDQUap2cUeF9IirasrJL2gxf2GboTIrkVzEVchz2BjGeOjF2+1tYf/EfwmzrCOPGxnOT09VUmvxHHbeTsuabWkdzMOdsAOCtaHlFA7j+eQYYv++ph7jqIqQyceCCZNpaPK7PrVmIdW4XkBPVWm0W0gr601L1BC3u4ofMu0Uuf33S4/B6Z+p0ByeH/q3PmqFrcw7+sxVEo7T0nPqG58vOpnSm/OmybKm+/IQl2YYnFYO14GXivwXkYNzoCf+R0zPpqmq9sfot9XAFlvBdtyA/RE8FCX4Od7f2fweMhgK81TV7lQkWcKXknRhYFQ3tne7xe5nl49qC0z5s3dImLDemJNxek4LGhLVA37zWiUh/DWpBKkfhOQP2z+pVDzfFgm8FnJvLcy8ghJFxNGr2TbkYN0KKJBRKpA5f+Nvzk1bMA2uSPg17WhGzhhFKwy4CIkXny/GZb+q8eg/ZOalxcvKq4YTzmM5kYe9dDwiAqQSyoKBkGcZcy7jnpt1XiwRyaLkIAkjgPKemBBJfuNrrXs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(478600001)(83380400001)(2906002)(6512007)(6506007)(26005)(6486002)(186003)(2616005)(7416002)(66476007)(38100700002)(41300700001)(54906003)(5660300002)(6916009)(8936002)(66556008)(4326008)(86362001)(316002)(66946007)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b0XdaKtWu8ZwQj13b0BqCNg+TH8Y7P4EfU+cVf8RoNSgZDVT9OETqswLCbQO?=
 =?us-ascii?Q?56Pm05+3R1I18R1s5DylZ1sivjn27V+ceqEaY+QQK5nBlhVVVGVJJ8Ce37RH?=
 =?us-ascii?Q?TiwYuQrtxQIm2X+lALl8elCMsSkgVPR1Tkt33A/PvoyhmhoTR6Ay1U7/Q88c?=
 =?us-ascii?Q?1xCW3WM+ULz9fzDjonQAOBeFic6OwHlaAAdqF02NZVSfAFE0OYGQuhuV37fJ?=
 =?us-ascii?Q?MPifXLiz+VLNnP2Kwi8yiD3Ae+OuxUbo7JT3ZxXJvGTBMzUcdvWjLfFaTyG/?=
 =?us-ascii?Q?M9e3RnAsKlUv98sA3v/HAH++H9yXrENkzqICwpU8AIJWry+0bHnJb7ZVWgys?=
 =?us-ascii?Q?vOQfRsr8HsENIxz8lmYTWeEMl3Bb6R5ZFprnsi5eMpZldjjAJp+wU2lnPqBX?=
 =?us-ascii?Q?+kYIjEFtfCUSv9vzHJd+nN71R5U+JcnuqlJJRRwKAv+lOlg+7zYg26QsCiPn?=
 =?us-ascii?Q?wFal/6WWIHtK/qh+yZUTiknG4VTrRhvtUhvWqA13NqauG51sj9q33gsfUKin?=
 =?us-ascii?Q?2pWmgAGuS5I+EX3jh/Weh+9uGLEu2NgNqYozpiHD/IFOOT69xdVeBIvhkj2v?=
 =?us-ascii?Q?JhLXoLUM2CeSnQexGoczPKlTW+bh9QC85B5Bs5O81MUazb3AhkFtGR/859nj?=
 =?us-ascii?Q?MLQtinp7qVfeBJUV3cD+KMp22f1pk2Ul/LgU5rN5wMUfl3iOAQsmlMCHmng+?=
 =?us-ascii?Q?jln1wq1E3QnYvEzgUVSpdtNCJvg/tzyowXKhqkISqKCtTWUrP50PwHvDdnIC?=
 =?us-ascii?Q?hiZhKYjIuDmxE8w5FeQy5dxCw7ETM8BFQNSvM+ceuOG/at23Q8fotnblPwnU?=
 =?us-ascii?Q?8AhSN2jWlFsdF+oogkpIgdI5CYRKnuoSt/ikXiBGZdMNS7UjEv7YmMLrAW9v?=
 =?us-ascii?Q?LO5SCETJqAZVg2rKnJ+6w+NW1DyhSeajVdgZH8wF3/98+ECcZixtbtjg6p1h?=
 =?us-ascii?Q?7R1C/+cGe/GRm1agBbcSLy39VAThY30488KO062z2xf3y+IC5gdFCxlH4pdP?=
 =?us-ascii?Q?g+QmRLIvhG/IQIlCuQLZ3mxfbCfCnLi+KPErAt7N6P0CDuZln1lNVHOVz6mn?=
 =?us-ascii?Q?x5j7jYSI/8lCVFjYmGNtEH7xJBn+RG5QjCiCQ2rObYVAxdr1059hbBxodoSK?=
 =?us-ascii?Q?mJ9BuT5ip+Fd4LAWQLyLV/yHQ+6Bve/MsEBqU1e+ORsp1vED6EID+aJFwiwb?=
 =?us-ascii?Q?fj/mqU22rbMQu1J1SwhzT35C/g3jXzNCbTTfkOfATd8i3qXlZV5RFuOples7?=
 =?us-ascii?Q?3l47tHlOj43k8c56+loao5crEK9Hed4isHWvI5crEn+6GqZJmfJ8s00T5Njh?=
 =?us-ascii?Q?1LoXFjaH1PGalV+eTDTCDBMCzTkPqQI9JPf3HpUi2ydyVbWXrcVI8VQh1L/6?=
 =?us-ascii?Q?dbE6tor4Nbbf/x+hmQ9bwwgX7xYBgHn53cmsc7YEOVGLFj1bKxdJswpPayv7?=
 =?us-ascii?Q?5h9s1BPppD2BEOuFTGcVLg/OvtoIWvAn69XC47Hx9Ydn29AITPygZ3UCoDC+?=
 =?us-ascii?Q?G557AOjEqCzkP6JO1FYgqbEsnRJgyYijAdarhCSE+X0sMinN3YHzuu+zNchF?=
 =?us-ascii?Q?vtZxfiBNwSPtdpOrvGCK25NkFCUzTKqaEC3BDfpZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4835954-bfaf-485d-1129-08db3c1551d7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 11:50:47.0532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOEehYnTii0vKqxMT5IetcogatL0qMwOovjvgDXkljtKyZix9HWTa4n3V2CJlDgF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6127
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023 at 08:25:52AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, April 13, 2023 4:07 AM
> > 
> > 
> > > in which case we need c) a way to
> > > report the overall set of affected devices regardless of ownership in
> > > support of 4), BDF?
> > 
> > Yes, continue to use INFO unmodified.
> > 
> > > Are we back to replacing group-ids with dev-ids in the INFO structure,
> > > where an invalid dev-id either indicates an affected device with
> > > implied ownership (ok) or a gap in ownership (bad) and a flag somewhere
> > > is meant to indicate the overall disposition based on the availability
> > > of reset?
> > 
> > As you explore in the following this gets ugly. I prefer to keep INFO
> > unchanged and add INFO2.
> > 
> 
> INFO needs a change when VFIO_GROUP is disabled. Now it assumes
> a valid iommu group always exists:
> 
> vfio_pci_fill_devs()
> {
> 	...
> 	iommu_group = iommu_group_get(&pdev->dev);
> 	if (!iommu_group)
> 		return -EPERM; /* Cannot reset non-isolated devices */
> 	...
> }

This can still work in a ugly way. With a INFO2 the only purpose of
INFO would be debugging, so if someone uses no-iommu, with hotreset
and misconfigures it then the only downside is they don't get the
debugging print. But we know of nothing that uses this combination
anyhow..

> with that plus BDF cap, I'm curious what is the actual purpose of
> INFO2 or why cannot requirement#3 reuse the information collected
> via existing INFO?

It can - it is just more complicated for userspace to do it, it has to
extract and match the BDFs and then run some algorithm to determine if
the opened devices cover the right set of devices in the reset group,
and it has to have some special code for no-iommu.

VS info2 would return the dev_id's and a single yes/no if the right
set is present. Kernel runs the algorithm instead of userspace, it
seems more abstract this way.

Also, if we make iommufd return a 'ioas dev_id group' as well it
composes nicely that userspace just needs one translation from dev_id.

Jason
