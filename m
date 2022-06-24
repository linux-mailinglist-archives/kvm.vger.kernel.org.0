Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380485599B2
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 14:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiFXMdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 08:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiFXMds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 08:33:48 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2089.outbound.protection.outlook.com [40.107.96.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B2049B4B;
        Fri, 24 Jun 2022 05:33:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNzlYopgwcEfyoZ6a/5WU+Aqr1ZISoqDoAMZciuMyccak1VJ/oAMSGuM3pH3ysvj7qwYKcPNXq05LXZ/pCJGjmZfJXd09n87E0dAOHejRYkY824pBtjwPUk1c7+ftRZlI1FGRcvrZ1FNZ1KTJLnurznNGwfR5rN6QgKMomGHOTAsP58Gg6odmCPp7z05Ms8s+G1V6Osz9V5Y8XSDhd/1wYoJOaCvCO2T5DxBIHrZUy0ILS/LgGhnL+6ASmZzqkcOP9x7MLhDpDAlOCMHFaRGYRziyMTjxm0KXK+UYZp83HXNaetuwd9dvDPFh6nJtqnPzD6uMV63zyU7lbaWt79dLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBezwfm5scueO/rm0kQHoL3Wae6Hh60/1RXcuzwe29Y=;
 b=GJsTF7w1Y5LAThvoDUiVIHjEgGuFZAE9ALjXd9Evr3oBxSVCqgPH3T+Sl+VrxiBqtFzLjlhvAt7IOcB1j6G78JC7efe+bDt2I/e3TfqTBdyZyYaDwgh0DtE+LnJW4IJ4nyeZ3cpnKVFiYOz6Sva7DcoSkGlLguig5CKvbX//1uCkkuGSSPW8CO2ZVtVKh/xeBkzkCxi/aNar3tBH1f06i4/APRwa9Ly7QjuWBv8OU18YleltwY1XYVomn/glmnhCvnetg6GvHHQjrj2kOdY/zK2iqSnQWncoipq+H09G/82WzXfIGLstWsoQDy9qUSbqFIrgX/kcMnETLxRCpRGEFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBezwfm5scueO/rm0kQHoL3Wae6Hh60/1RXcuzwe29Y=;
 b=rK2iWbnkjIzVY85aCgdPwwYJ7jF9lxMGqbMDBhLCB7zE2xRMWn2aXHMiBR/ICpoehJurfx2tXAgXaaMApHGQiXEI1/jdoCoPp3KnK3duEoDngaqpqGxbTZhdwfIbQFz6KsjcdbaR4WdRgxcxqq0W4ctSgkxioST7qZZMiRZQUONmzb0ensOyQKRW5a8SyzX4VtaLU5mMjHCzlMMqUakyj/XsAgG1GrTGe9YEJhl5UoEa57UD61OMSPk3HOhNgZVrgTumOqeE3C2GydlmTqi3ZMuPLX2kBf6Se09bG0GZpb9WRBrcW6OH/Mk6FqtM3+Nlxnj0zciPC7NoF4B5V5BT/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB2418.namprd12.prod.outlook.com (2603:10b6:207:4d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 12:33:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 12:33:45 +0000
Date:   Fri, 24 Jun 2022 09:33:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 02/13] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Message-ID: <20220624123344.GL4147@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-3-hch@lst.de>
 <ab47e216-f027-2083-308b-89c6aaa2e806@nvidia.com>
 <20220623201844.GA48313@nvidia.com>
 <f152e97f-0d07-e7a5-baea-3ae7de5662cb@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f152e97f-0d07-e7a5-baea-3ae7de5662cb@nvidia.com>
X-ClientProxiedBy: BL0PR01CA0016.prod.exchangelabs.com (2603:10b6:208:71::29)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc7843d1-bf19-41b6-98c8-08da55ddc792
X-MS-TrafficTypeDiagnostic: BL0PR12MB2418:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sCuv3DvzosvF77QHw9p4dXEYyuwwnQpNBjg9yBORYeRG3dSEGmTlFgSVjDrm4dC5T0sXlO4R23KY9TAnqd78ZFJ6HQneIm43WItMbQfxlReMx0Fmg6RvbRna4hILUCk5OQe9u2K7LxtXCDcl4h/wHxpmI6BJOcvnqq41gMDOUBkUBfpQR6/zPHAIusQKIHqsjqZke/avQkyJWw7gUXurXxS+L0scVrK4FkSufXrOWxg9liE4mPX/F+A/OIYOVbZ66wj4OfWmmBHJN4XX4UUhmfiHhzxEZ4CmZoxOZUri1Hhck/2MJcoQM+eDgwDIUg9dtjenQokddVNqp0m+vsPicjobfJkWbbmB0B6kN+fEwpaUmNEhKA98oSDFCguJaS1u6XMTpspERoe0CmAU70/Fi8bImtZoafhVDXDxc/tfIAk3RkVJBEZS4rKotlQYwwNy4MuOIZvOpXfalnlFCFRMnNYgpMQ0TUGPBcRhrbttSkwBKXgdm239BWTEtRwjkBYvE1gh0gYhfNfnJgnSZr3Q3FhCDX/5OQL+/x1zIaY/BN8UQfnCr9ZHx3IeQLhDYfgO6JAQDx+gyaSMUbnfYcfq32RtUXD9Pj1OQgd6DFq8VKjA8zLTpJQ+2FmNOk9BEG3Rq8oxqIs+9xGKHrrtCmwbRolKrLbJets9NP2+8PVyrGNaMv4rpO1IlFqbmngUTFkiuCWkWZ0L17Vl8WugLtGIeGh2frEkori7sjGfK9bviag=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(107886003)(1076003)(33656002)(2616005)(186003)(38100700002)(41300700001)(5660300002)(6862004)(8936002)(7416002)(4326008)(66476007)(2906002)(26005)(66556008)(6486002)(478600001)(6506007)(6512007)(86362001)(316002)(66946007)(36756003)(37006003)(54906003)(6636002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yR469PYv8sFUEgHE9h4U6hBRPNOgANthdYoZmMP2mXEfLzMZaDrTzSL4xZe5?=
 =?us-ascii?Q?JxeDb0ljy7Ko8ABvrg9iv46fw1hV8FCe9fXgpFV07p0QkOarldCzLYxJ61PY?=
 =?us-ascii?Q?mL+M8h2XFXpwCgm6f2x5EjQNK43K105Z9crs0olFlrhBqFgpDtnZaZGmOnhx?=
 =?us-ascii?Q?DtHZT5DF+aLN2BMXvzFXG81j2/6LMUzuGEVdgEmGkWpz0wRsoIxqEmtlxkCa?=
 =?us-ascii?Q?qiga4plBHe5fD285jqnCQu0SmbVHD6fgBsJ5GgHJJAye273ETj8ZTbqx6S18?=
 =?us-ascii?Q?vPvGM1T1m+A+6/OOhPmZ/qo/wOBtdGTrL35q+VncK7DQ0vOUg4b/nDHFEFbI?=
 =?us-ascii?Q?AecpnijOnWouIQGuSnfbMEm9MhqK4K0lxOkSJ8klo527cFFGsw9xSwd123oI?=
 =?us-ascii?Q?j6HpQ+MBj7vYBpluBMVz7k0o82zX7Qg7QXwTaGvi+9yJvkrO122A9CBlm7ZQ?=
 =?us-ascii?Q?JyfppbyRF6+tITKG/xDwRvDpxTPC9uhCrjmTjloGeGdh770V957uw6iplgY7?=
 =?us-ascii?Q?wmBtRFqBfv5l9RydrVgeYlB/NKDemWiAFrVuwQcJpf94jxtOaF/Jc2H6gfKT?=
 =?us-ascii?Q?9gRxgAk4niTwp8nYhkQ/WTtl5GAZHDVsutmpSNsAX+bji1D2ydonYLWCBb4P?=
 =?us-ascii?Q?z9HNW7vZz48VDGIDaHm3mAlq98iPkLEGRIHS0wkVPtHaThDzujs3zTDhGdf9?=
 =?us-ascii?Q?58IG+DF/+0CSP/MlWQZLtPcZammdYaQGTcXTF3melVHX3+7U2Y+qYRrr7AqZ?=
 =?us-ascii?Q?noGa79dJoCgHw3zIjpFJ7rgZJr334E3K2wqj100HBHVs7VJJlYO4oMa9obB1?=
 =?us-ascii?Q?E9cxT2nLKuzzWpDzslSMKRSCcsTnRweKQVv0M+CMyW4tkSvb2fmPVUlolaH9?=
 =?us-ascii?Q?dQy0h0ZenwSs/TkQJ70mmdQNd/6zJdGLLNd7w/+MUGMoytYBnfyChZVvm6K5?=
 =?us-ascii?Q?HHP7c/esHajQUVTyCxEFFWK3GVfa1CqQXWdGcLk41MAZSP7h+/1kBg1okmh9?=
 =?us-ascii?Q?9fpUaIwriNXgBpMHUktMv0TEr6xQgAIYLsI2MEoB0m8WwZixzYn4IG5ZoKCW?=
 =?us-ascii?Q?wZlikTPYGeEMyOQiBPn3GtW1pTKhMIhYLgY84NDvsDosyBqvUrDQX/HFkcKz?=
 =?us-ascii?Q?pQ6GZ91IwOQinfZn6JYcRAblfGPC4XDzxVEBfIcgEA+bTRAsBDxUmQ/RCNjL?=
 =?us-ascii?Q?cDzHWDExSULjswBR2+ET6jWwrf8QINcF5AP71lK3K4+7kRcbP9FJFVfNn4iC?=
 =?us-ascii?Q?fA2OyqD/ZpbXFLP4bU5p3N2FCf8CarYW17fyxakmyu/B1R9a25Lw8kMrPRc6?=
 =?us-ascii?Q?QdJ+V+Wq3PXQ9NCZLLzNN9Qfhv9trZ3uebm7C/VjroitgA+SRlIHq6VqlMke?=
 =?us-ascii?Q?hzD5d7Vvms+5WWYwr2zmY4BoCrORfaETGQfulrlNes1Ib0rC4BIPd29tWTsA?=
 =?us-ascii?Q?VxbHvvtUpPRQ6ILwzNaQZxqgDA90jH3bvEFmWC79McTXVyBIHEyz0wKG3sQW?=
 =?us-ascii?Q?7xkiEjQSc0eMP3HT9EwXYRj3CS7yn2xZD4LyQ8+jwnCrWPu5mK6W1Ym7pOdJ?=
 =?us-ascii?Q?TSGWIaPNHuTmGEGnFqQVN3I5KmrXd1cSkWueUOey?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7843d1-bf19-41b6-98c8-08da55ddc792
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 12:33:45.2483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bf79inGrWc7iyaawpzNeMBPlDFAyoN/wAnyjG8wa7JOOqUMTUWtRrDGgbmNRlfKt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2418
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 05:59:58PM +0530, Kirti Wankhede wrote:

> > The reason this is here is because the type->parent is used in a few
> > places and is put back in release:
> > 
> > @@ -81,7 +81,7 @@ static void mdev_type_release(struct kobject *kobj)
> > 
> >          pr_debug("Releasing group %s\n", kobj->name);
> >          /* Pairs with the get in add_mdev_supported_type() */
> > -       mdev_put_parent(type->parent);
> > +       put_device(type->parent->dev);
> >          kfree(type);
> >   }
> > 
> > If this was a simple sysfs kobj with only a show/store we wouldn't
> > need to do anything as the natural kobj parentage holds a ref up to
> > the struct device - but this kobj is used internally, ie dependent
> > from mdev_device_create(), independently of the normal sysfs
> > life-cycle so that doesn't protect enough either.
> > 
> 
> 
> Life span of 'type' is from mdev_register_device to mdev_unregister_device.
> If device/parent is being unregistered then only types are removed, so
> referencing 'type' from mdev_device_create() is still safe. Therefore,
> parent device's reference should be held and release from
> register-unregister call.

No, I've already explained this.

Jason
