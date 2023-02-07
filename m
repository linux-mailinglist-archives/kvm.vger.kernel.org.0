Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C0668D92E
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 14:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjBGNUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 08:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBGNUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 08:20:22 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A873115
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 05:20:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=II2m44V7hAdFocVxMhvCASqv45qr/iiO3K6J8uhJFx53AXgMoe1JHE8Hku23uG+Thm/OPXD3eeANMT31ASfguUtwrdCpK9MXc4Lyy/VajkyUpYC++fkM0BsoSNnSyQg9IHAKjIdI+DxmDbKCixiRIMU8ITGf4p+wB5I5HPSJnc8AtSPQKUmlT/kB8R0ekXwa21EUFmrb+d1eHcK/s0tKirN3zsylwyz3qSRjig+OF6NpIN7yF6Eco0YrS0G2+QzXez0XAJC+y1A1w8DMA/n+tMtszz6Hdv9c2k6ZYB6YxDadCvhzGSYeZ1Nfv2MbiwhxrTTcpQktOOob5mmba4hF1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTM/HS/8EBz3Pp960Awt0zYLQ7uDCvviHDLryMAlMEI=;
 b=MHZ6TjD+HkkiPoOxBXoBUp7yHasSD1TmCZY46D3GiTXg0VndElKxHtGWQkZznSDKr9PqtDts34LNLLUnA+7BXXtQK5EMqgOebviosn3xBTUt+vPDfh7Ub3i6InWvF5CjYp975m7kb4N63qM9iPPqto2Mr1cuHinVvqNRhOXD+V86M3lracRW1CgfpjLKMk5j9eifSxsJ1bJrSmNc2SVEYgIQalYp1f28ZHpMxVPUFnQwyXeFmeCBp5jCSSr6fxOe2tDVcWyw3kK3t3qYCsxqLcugcOnXFS9r/P70glD4TQC8oALX7f1ufP0e+vMHj8De0uwqAPvNX6BnuP9wgEVVvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTM/HS/8EBz3Pp960Awt0zYLQ7uDCvviHDLryMAlMEI=;
 b=PveXZnxkVXQnyXZuQHW1ySaQ+IULJsM5CyFTBpenxdfAltsg1jc5ryb8YVIDa2tGqCxhwjHMEX17vQ6WpuvFVulaijKAqyVzjqZSRSF/P8QbScib+E4HhYyfrPZ/KNhYrFdENrX97KnJUWp5d4Rq/btqnRkT5Cx+NEuGs3WfendwbFTtkAbBNZPokFOfMN3Ih2n9S08+DSwAoboG5stJRsQWumcnLHA0C9Eyk4RTCrTCQy9yL+cq+MYv9JxpsMbPBiBW+juMZzvDkonGcgKuUaIj1RTg0yJyiPuxTj2FW0hLUQy8GCkDx2Fo61Bl2F8MQ4eYZ4YrQ7inS6UIrQRgbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6116.namprd12.prod.outlook.com (2603:10b6:208:3e8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 13:20:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Tue, 7 Feb 2023
 13:20:17 +0000
Date:   Tue, 7 Feb 2023 09:20:16 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Message-ID: <Y+JQECl0mX4pjWgt@nvidia.com>
References: <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y91HQUFrY5jbwoHF@nvidia.com>
 <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+EYaTl4+BMZvJWn@nvidia.com>
 <DS0PR11MB75298BF1A29E894EBA1852D4C3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276FA68E8CAD6394A8887848CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+JOPhSXuzukMlXR@nvidia.com>
 <DS0PR11MB752996D3E24EBE565B97AEE4C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB752996D3E24EBE565B97AEE4C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR22CA0021.namprd22.prod.outlook.com
 (2603:10b6:208:238::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c8ad3d4-e8dd-42a4-6656-08db090e0e55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: beIFr26lB3CxaZ4b0WzzEbp2+9KuoWXoTN/hUkOaJ+21Hh8Osi7EuQo7KPswWaVa2gMUOM++3qk4r8NNb3uLXSiOMvxDabKsscCwTINw209BnVuAcBut4/l3vk+Px7CmfKiyGoLZQ013l+50EBFn2BNArd6IZlqqdLyOzHNIzWTCdXQs6XbrQ6Ztd/hALzbe/VchrN3U6yzlt7vbkLLAL6+UJipy8yji5dGF0B7X65s2sz1LVtb82Hj2yMMZhSzkyyHvpVseo62W5v8sK/fuuVjmT7utxC95dg8Wn1OfUAO4dbMTn5WnqMTFV7QGSTRNJRPkHzTru0cxD3PIx31FRiqAXDl26Am10LAE7oolUDrq1gSm4M71GU1AlSVdr1R4xtsX87bng1XYLc2itv8cObnrWRpur85AmY4dwgihNUsTzdzU6ESCqCzltIfWoOhdq/lVkC+smUHMvjFXCEiTGHVU0FQzRfB4YXQMG+HfhYNHmPaWFwJSHXrsZMxBxtVRBdAmJjJVibGYYNgftfmLnNYHRmXKPIaD1nKewFJQmIJv0Y+ynp41G0BgXsF5czN+2CTIHYYRZRa5tCpZZYsn884ym6rj4/1UQ1KlqlY8uC6lonRIVBtajYFEcdrAQardg2a6eZOu8yf/id30s27NYbbeSRtH4VfpJ/+SPNgAU0bM6pyC4sfcq5MKrpjGk+wD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199018)(54906003)(316002)(8676002)(41300700001)(8936002)(66476007)(4326008)(66946007)(66556008)(6916009)(6506007)(186003)(2616005)(6512007)(26005)(6486002)(478600001)(86362001)(7416002)(5660300002)(2906002)(38100700002)(36756003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WUYWdif1wNRa5kViH8LF0gMiqWZANVQDDBgTPN8gNeS6SP0ITmfGgi9ZZxOp?=
 =?us-ascii?Q?FzVHmS/HDcr5udg3/y56A1CpP8v82Iv4At5aSoZSvTHo0B6qs9RyGE24/K/Q?=
 =?us-ascii?Q?42FDYl62KJcYgZkGQfXhGQu6yxLetFgwqLAlKeaw+IOpAqhwfqlyfpg6T/5X?=
 =?us-ascii?Q?M5BI6Dxb9n52vqhBnByXQNHyfFhl07yQluPE9zO2i/7nzDDdCy8k97/gkli/?=
 =?us-ascii?Q?7fCm9561G/IfM9C4hyf4ZtaTtXy5zGvME2e7EE//meLGMzQ63mQIBVMKo5SZ?=
 =?us-ascii?Q?9HZxD8Rv/fA7HD84+aWGiU696/TNhRORznfcztYOy/31W6fdiEeiqXDSNd6A?=
 =?us-ascii?Q?tMi2pcxs1Gb6iOY9EOJtUgZKyQMD4VSD2RTG6zi82wyHCaGxaiDY5j1Ih3R/?=
 =?us-ascii?Q?dHAuGQGdhEPmTUM4OZ19etz6XbuUrFkCpo1TuDY+HIsNp+7zl/2X7Plm841s?=
 =?us-ascii?Q?ZMOn+7dLTtUBg60J1IQC9ps5OzpdnxzK5RfES9l9Ds7/qEFejdKboBg9wyQu?=
 =?us-ascii?Q?Tkv9dQmQBtp8tnHqD0ALb4Jn9cgR8AcJsIddkCOGIP9M323CR3Pp8JJvyX1M?=
 =?us-ascii?Q?uqxRqRvxvL3ofgsyxnkACua3KLmkkWbj4taxs5lzlVeljSjhPgWXKzTv4ju4?=
 =?us-ascii?Q?unqTurQ+n2+FvS4MMjmk0hoyLj3svfILRkCnPaFB0M58bpdNpumjbIYQZt7o?=
 =?us-ascii?Q?1LduC/SfzfBb4mupqjFB6acG6T6Y7jJS8nmGWqU1h79o7jLRHqB3Co8eqUR2?=
 =?us-ascii?Q?qt3JDTRJEOlbxk08o7hI7y6z5ZJ+/IXmrZMEbIyCxQ9GCFWLbzPLbAsY+dC+?=
 =?us-ascii?Q?R/BT+7DcssVd01X/EymW73DMOWEZ0I+lmbeIry7Xod5HHV1UnlnenAL6KvJm?=
 =?us-ascii?Q?t3ag6qpjFc8KeGPgmwKxudN/jtXF6pdNC4jT1vxoEgoOSZxbUmk3NtNPvppL?=
 =?us-ascii?Q?N8JLhNGm4fLSm3/qVRhh6mLKY7iBey8u2SZdTyO22e9m5hXWWRsL2243wFXI?=
 =?us-ascii?Q?Dx+iW1UzDnuSesEZQACKuKBQcI0oiGS+0hPd1ap+a+6WhBonAhqk3XHAGxIG?=
 =?us-ascii?Q?dONwGdweBhfWbMzAtGIiO0MatSE7dDPNTT1yiro/7iYqgORo3apMmq9HMSej?=
 =?us-ascii?Q?Q0dqRBXV4cq1bAhdAGYAq0PSbFDZETNY92X93tWCgqQuFuwDtkyk785pTqjL?=
 =?us-ascii?Q?d2fdZ2El4mzmx6hnMkk5FqUyLWXnBZRcyLkj3AF8wOQWHzLy1DGyNxxZ36w4?=
 =?us-ascii?Q?MiaD6gQJ3BDq76d1qJ/m71rCfzJnUcvoZUMVAjnKZ9YSuMXe0KE6pwDIxwBp?=
 =?us-ascii?Q?ljBw0eHf2MfAMkhLNeH7X3BDb/Bn0j0x6hf2vbl8Jz3cH6BMIiZcNYy1rNut?=
 =?us-ascii?Q?evotPKYQKpAnSt6BcXzy1L7IlVx/9gr7c9LyHgsOHZevj+gkcUiZvWRobYAH?=
 =?us-ascii?Q?X4QJl6Ug88Cd5C1WYgULm/MVWOVSl98pB81iMieW3loLLGADqROIj5+LJOx6?=
 =?us-ascii?Q?066ImfCNVsgrl2Sj0q35bCX2IR5xVsJr9lOt036IUfi2bu37td2Rp14EX3Os?=
 =?us-ascii?Q?AUDknKDuD6C6QOqwWJHyS+n74fB457c26bNjMrwM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c8ad3d4-e8dd-42a4-6656-08db090e0e55
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:20:17.8820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: daUBhMewz2hY3lIgfzdh6g8KJS1+8Y0RqbuXRp/kkx0fbUZd71gl38/9dkENQUrE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6116
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023 at 01:19:10PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 7, 2023 9:13 PM
> > 
> > On Tue, Feb 07, 2023 at 12:35:48AM +0000, Tian, Kevin wrote:
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Monday, February 6, 2023 11:51 PM
> > > >
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Monday, February 6, 2023 11:11 PM
> > > > >
> > > > > On Mon, Feb 06, 2023 at 10:09:52AM +0000, Tian, Kevin wrote:
> > > > > > It's probably simpler if we always mark DMA owner with vfio_group
> > > > > > for the group path, no matter vfio type1 or iommufd compat is used.
> > > > > > This should avoid all the tricky corner cases between the two paths.
> > > > >
> > > > > Yes
> > > >
> > > > Then, we have two choices:
> > > >
> > > > 1) extend iommufd_device_bind() to allow a caller-specified DMA
> > marker
> > > > 2) claim DMA owner before calling iommufd_device_bind(), still need to
> > > >      extend iommufd_device_bind() to accept a flag to bypass DMA
> > owner
> > > > claim
> > > >
> > > > which one would be better? or do we have a third choice?
> > > >
> > >
> > > first one
> > 
> > Why can't this all be handled in vfio??
> 
> Are you preferring the second one? Surely VFIO can claim DMA owner
> by itself. But it is the vfio iommufd compat mode, so it still needs to call
> iommufd_device_bind(). And it should bypass DMA owner claim since
> it's already done.

No, I mean why can't vfio just call iommufd exactly once regardless of
what mode it is running in?

Jason
