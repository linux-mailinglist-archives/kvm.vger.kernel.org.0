Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C5A72E9FE
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 19:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbjFMRfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 13:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239687AbjFMRfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 13:35:15 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F21198D;
        Tue, 13 Jun 2023 10:35:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdjCDL8Zo/8VOYmx1RQvD+q1FQq0Wy1zv+gE10D4uH9YIyVZeNVi0EOz7nmgBNpmJnVncM2yx+wmuMsvR6CFg42CWiKsQpFTe+9sbFgC9QQtZpYoy0tSG45/TFLYZfBGP8cGmTHjkhWziNqPhmQy1I/IoHCRbHyGTrXOf6Xpc+sL0eTA09Fisb4PR9S4D3iPE+r3S6apJ4RmU9UrjoMHKUb5gGjukyUhLXRZjyWvI1916zxgPKiKYe5N2hPdljGe+Kdwy+Eu3ciop8tSVP1kF2va6cYe30ifYzB03oObAwsARwDpzzCcx1tY7TC7fDznKoa5iki9O8K1WDHwkMtokQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NQ0hKq93jknkfOV0FDwHdqNhmNJgJZuCj3ErsTin0h0=;
 b=RVbiQc7Kb2CsNpqS9eL+b3cC24xdnFLML6x62p/7SOdRq6qbcPr+fACEtJUfzYu2uxbzzU/BGr6fSi2DNYveHELz5DXKjDdaTEFGf9DazJFzZORTvAsVRBfONzfx1mza5wIMKB1K7BHIMSj3sXeO0zH2PGj2/uP4N9rWZoERsAZvdvEHNOkV23/a55qZYGaDulcYt1S0v5jfegV0tE8+D448FH6uETI7cNLl0qC37ZOTDnH8wpqCv/zj572VGx9qVuPh3N6T2BaVcXl4SA4D7r5OfSXc38G5qTScKn5vziWN1H6/4RwMa2MQ05icdgULmMqwfL0BPAz7nBrkap51YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQ0hKq93jknkfOV0FDwHdqNhmNJgJZuCj3ErsTin0h0=;
 b=FQEgCBFt/HK/KPYJeQICaX+RnQRg02KI4SgUL3N+jWMyA2xLHJ2S5wACazYrDKnMu5mh+Cx5TNVjh+SVHviLR+oP0aUIkJWgrT+IaYDlSOoAmiDSDiMOm9PdxVnJOxJJ9GZ1FTS6Rkyi2N8hLvNdH8WvYFkIS6R5rNBrclaXD06Tv9Z12l+kn7QL6wB7fhTP7jNJE7HSKHQT5HwI78qA9fVzhwz9Rpg5ohM6tSWYFuYQ4YJed0vurohA1zThspPIriSer8V9l9JVKPEDCItSu8GxtQlfPkuQKZkayj9ZEqNOMha9zQ6oiOe1EuutIIlzWUoyLpsXQjhL1MTZJTqmwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW5PR12MB5684.namprd12.prod.outlook.com (2603:10b6:303:1a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Tue, 13 Jun
 2023 17:35:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 17:35:11 +0000
Date:   Tue, 13 Jun 2023 14:35:09 -0300
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
Subject: Re: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Message-ID: <ZIiozfqet185iLIs@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-22-yi.l.liu@intel.com>
 <20230612164228.65b500e0.alex.williamson@redhat.com>
 <DS0PR11MB7529AE3701E154BF4C092E57C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613081913.279dea9e.alex.williamson@redhat.com>
 <DS0PR11MB7529EB2903151B3399F636F5C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613084828.7af51055.alex.williamson@redhat.com>
 <DS0PR11MB7529E84BCB100DE620FD2468C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613091301.56986440.alex.williamson@redhat.com>
 <20230613111511.425bdeae.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613111511.425bdeae.alex.williamson@redhat.com>
X-ClientProxiedBy: BYAPR06CA0072.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::49) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW5PR12MB5684:EE_
X-MS-Office365-Filtering-Correlation-Id: 47c5286b-6088-4d43-5e03-08db6c348a24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sKV12JTRUA0F1+mvVFibGzho+0WmtYQvM9sLD2Ka4vFB5vyYSCYhnsxA0cusODvcbsApARp/QGf7H9b2B5j56CbVHeQMWKWkghnY6W82gF/IggDCcPYsYWyni6K9HJXGQKOXPJ0stxDaQ0pqB9fCugT3zQdFcKWekNTuAcgZiY/8EZ8FMTFFbo3kKMZzcMIB5X4ChNVFio2S1aHv2OCfI+9PQVzCZIrKTUlz59Z+WL3kdqYqDs9f3nnPxJcaOG5saHE3h+rEuALIaB6diJCvSygT3PIiRBjT5CasnhP+DWGJzcSGHrfPrSo7/SEvd2A6vIzyg827fu74959lbxiWUmdkKE7vMY65kbaIO/dHLBHu16+bMIGzQYYL+wK6S7kL+GnX6M4Gc98Qo5QQfHm2nxdh2bJDB+f5AOUWnXZ6QtlPktMXI6THy/vHIqMtVBjavl2sWg2wxWWO+R3/oNReX4ypseF+E2ycM+/fFRU1JPo3QZ3UPRSNdIYtz56NRFkvUry/4NDujvUeGs7mkteRciovYdRiMWiYY3w4COWlRqQ8ocWm0RlWVGIJWEPiBJ6l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199021)(186003)(26005)(6512007)(2616005)(6506007)(7416002)(83380400001)(36756003)(2906002)(6486002)(54906003)(8676002)(478600001)(8936002)(41300700001)(4326008)(66476007)(38100700002)(316002)(6916009)(5660300002)(66946007)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CXsxO2ZXlw0dCXsV71Xcq82pWEnymlLKThSolVRBVPy1b+d1wMdQNDedw/rW?=
 =?us-ascii?Q?liBJYPly6ML49q05n/CwsAPQeeknvydMY7QwZobANv6R34ERj8ebucWNzQ0b?=
 =?us-ascii?Q?s1eH98D0UfvjUqcUC1gSlInUad5hN7HZwuiJlPG/XCO8969u49sx68P/Sklv?=
 =?us-ascii?Q?aPtMwsdO9q7gd6T1dFVhAWn8CgZlv2AyDjXDhfulh/XCckvuH4D4zY65sohn?=
 =?us-ascii?Q?GKTQK96W8KrM1xFQPoEars3zn78mVdoIQ8c3n/o42JEgf0D98E1Hol4ycJC1?=
 =?us-ascii?Q?ahg20W36zb4D6D1SW2uIAW3drSML6Elg/jEHRqWJDhGEf+Bqk+af2rP5OMlk?=
 =?us-ascii?Q?/360Gash/wZb89TCzL9E0vPV7Xs01LIAzgVF2wvngQZM0JkQ6N9aFdVz4IG9?=
 =?us-ascii?Q?kYkpZ69kfSBmaM+LIjWRUBHSgZkgp5lXZCE6u9KOkehfWjl5lDM8fPrkVOmx?=
 =?us-ascii?Q?EpzDVjesPbDtPYknSMYFlDq/vq+aZilMK5zUq/ZmPtWQK/wfnDAetWUvD1kY?=
 =?us-ascii?Q?mEYs1t7XRHiMcMaLcKDQJFLeepZ6OmXAxDGzZfN/3q6Zcb2zoVsJqtVeEdVm?=
 =?us-ascii?Q?3uAK7sO7x0U4vTpIqtvAAcgVm+icNQ5HYTsOb0GPdiLWzk6SDbq2LVdUFhyG?=
 =?us-ascii?Q?iDJFEoJtqCpnAuLUwUtBZkGyQNcwym/fExkQxBFhLGZpKyzz/1mGJKV9q9oG?=
 =?us-ascii?Q?kOAAb3UfhC7FAN07B8ASq0GzNJlIdQb2CuPijD4TPDqncGjPr4PfOyZYNGPE?=
 =?us-ascii?Q?Kja+DpJLry2LMNI7pdRSrKZBWhyt/UAJB8mglPxTMHT0lfN+8RLfkR/i5/jo?=
 =?us-ascii?Q?YXQOSt1ZqlXKNiP9I/vQw4R9HlMq3hzjNyiW50RxEDRhscyV9N3CqMQKt/2V?=
 =?us-ascii?Q?7tDQRKHBAuT+60FuuqjFr07BRkQis5lvHS5Z2l82ltDviBLAIz78+FJu3dhl?=
 =?us-ascii?Q?5G2X6ccf5qzhhqehLpm8xuw5wZO4DIK03CI9mduVEAsuhfg36/vR9ew/di2q?=
 =?us-ascii?Q?aVAl6G8MCmWyb3VnDLn1DGSo/q9ctCbSodFSR91tLan8PzEXYoKMcL9bU1Gx?=
 =?us-ascii?Q?w+078bnPhTx+IxrJPoHp1/bmf2rDrcsDZmANrLnxJuiEhmUlV9hDne67k7a+?=
 =?us-ascii?Q?Ph0gqNNfyBhEpOPOUE1GWbqL5Ctl5d2CH4OPGCTy+YeuhrN7Q9rrimdnzy3O?=
 =?us-ascii?Q?q4llMiVws94lYhbaOFso7kifybj06rKngFio/4cLFC3f1pExsbZwNpgNGb8E?=
 =?us-ascii?Q?3dSXmIxrNXn7LZUucsb413QlIax6YG17R++CTtOfOdsNl92hwtqJpdAvbtNY?=
 =?us-ascii?Q?8PsdhsOAl+HoMAs52EWHrYIhKWXpLjIMeQmRhXT+onFl5v+a0NUJ06+mirZ2?=
 =?us-ascii?Q?SLIW1/ZZZ1ZCWXfc5XjG+BEIZyBO0/WwtgXLj4Jo9nKRVG366ObgnFMfNt7+?=
 =?us-ascii?Q?xvSvA2qS0yXVBV42gV8sqCnk4b3MOgjlSv3tDFFJPJn4OBcqA5OaL2ITVria?=
 =?us-ascii?Q?4e9K4zT4hG/V9jFQMyQ+A+KdKgXykDNsNYbEkkSYnEoTzp2USYgdQYAYqDYa?=
 =?us-ascii?Q?eYM9kEz2403DjpPyG0STIS56J74g/GtG7uERydi5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c5286b-6088-4d43-5e03-08db6c348a24
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 17:35:11.6165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FkEb0IGy/n7dNgsdSCNhFd1LMFZqo4J1eFyo3y/aGfkBPMktYXAJa/AG6DDysr+o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5684
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

On Tue, Jun 13, 2023 at 11:15:11AM -0600, Alex Williamson wrote:
> [Sorry for breaking threading, replying to my own message id with reply
>  content from Yi since the Cc list got broken]

Yikes it is really busted, I think I fixed it?

> If we renamed your function above to vfio_device_has_iommu_group(),
> couldn't we just wrap device_add like below instead to not have cdev
> setup for a noiommu device, generate an error for a physical device w/o
> IOMMU backing, and otherwise setup the cdev device?
> 
> static inline int vfio_device_add(struct vfio_device *device, enum vfio_group_type type)
> {
> #if IS_ENABLED(CONFIG_VFIO_GROUP)
> 	if (device->group->type == VFIO_NO_IOMMU)
> 		return device_add(&device->device);

vfio_device_is_noiommu() embeds the IS_ENABLED

> #else
> 	if (type == VFIO_IOMMU && !vfio_device_has_iommu_group(device))
> 		return -EINVAL;
> #endif

The require test is this from the group code:

 	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY)) {

We could lift it out of the group code and call it from vfio_main.c like:

if (type == VFIO_IOMMU && !vfio_device_is_noiommu(vdev) && !device_iommu_capable(dev,
     IOMMU_CAP_CACHE_COHERENCY))
   FAIL

Jason
