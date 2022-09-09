Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C985B3EFA
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 20:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiIISq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 14:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIISq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 14:46:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DBD12F732
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 11:46:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lV30jvcaH21Pah/IWOz/E9alQhVlt3PHPVhRt0mdm14QZfC8D+X9xD4FfeFZR2TDhaucsr7TkeSqMsitOiqkwS8cUGh3T7vypXGbw3n1oKeR3qXAVgeucX4BiO7Aeap6ZcE5cl/BgWGxJWs47OYTtixxYQLfDXj30mqmFhNFy6jVWkGzgAkSbQzN2bHdN2GhYcjgqoah54mVLEj/8J4ia8PkUuLWnPQggiQBX5bz2mva7AVvoTgLUYViMogSNaKYE5C0bNRGDtPlIaSKjqoo5gpuCDgb30XRyBjbHUEbamXSyulWw/9I5Cxa2mneVSb0L4lmmGZDFL4Z1T11vUAr9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06CzjvrfK5EMRoNpkKrznfizdArFW+uJvSm0NuBlGZA=;
 b=gqqqb9jX1cFEncyVO8cwLll/vOefYBxgtwEYU2ewMw4ShxuwXoVgLMTle4BGB0Z4H7mRpQyqKlww+DlepVf+Dgcc7PzGvKf+pzRIaewXzRRtysDGn3HnTKCXoJbGjoTEPe6CONwv+CfBew1c0+OE6ROWuWQWdlGu846IKlCczU/od9kVvcy4ZYFpYEcSCxTpphLxuT0ougyFy2jdxWPgnulHk+0/7TrJke4rIFvT+8SxfibJyE1IV99CczoaW7WuG4MBVmrbk38obHPV1u4EG+zZPXDwRPK908QjBsaifCYw4IZGqGTAKsbgMsQmD99yGFzBfulY1YyFIgSuxinY8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06CzjvrfK5EMRoNpkKrznfizdArFW+uJvSm0NuBlGZA=;
 b=a4HWx4DtzodTPu17TpZgcG81QMpZ12obfwoxLCH8J3CXZg8gBUuUvCUicBs4fJuk9pwWp+qk39/Z9Qm/FAqFtAEJ4AbbTtToKrTWmTfRBPeN5tdTnbJvc4pj5AaATMhJuQe0wLQ/g7TtOliTbYCRQzty4pAPile692nSp0afqDxmKZcWYO4urLU7LNxnHf2Fio5L1Y8ECgJZov27dkHj9sKayPqn220HzechYjRo0so46HDWpF3Ic1lXQYB57oJGAtGFov9dyBS+ADtNhunvLe8W+vBWWZAigwTAt17L0aQ+0+ZZ7CCfXNvBp1r+CtQt8GHQ0am9CkIelCxywlzWRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 9 Sep
 2022 18:46:55 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 18:46:54 +0000
Date:   Fri, 9 Sep 2022 15:46:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC v2 03/13] iommufd: File descriptor, context, kconfig
 and makefiles
Message-ID: <YxuKHDEMBZs+ZFdw@nvidia.com>
References: <3-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <fa14cc8b-6038-1f4f-e1ac-1e28f913529a@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa14cc8b-6038-1f4f-e1ac-1e28f913529a@linux.intel.com>
X-ClientProxiedBy: MN2PR16CA0001.namprd16.prod.outlook.com
 (2603:10b6:208:134::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ1PR12MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 2561257b-52c0-4f06-ae3b-08da9293aaa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y19WCGkfsi/NB3PIbqIwkMw5Tx1OdbGGjKPT9rMHjmbVcaogjxsri5D6AEa/aELVYEJYgusgJw4pnxvAuSbtD4xbERdA5e6EfnO0SBKmTD5rzQNLNpY4jQhsj0BQzCDn3TuwmthKFgu8ikOsPqbRLGdQnSoOUXZL7bqJ2BVdwR16N1PkwztaYeguZ9Zc+gKZ/hknUltIpbwRYidyt89JrdHh7S8AIFRl92nqQNN9erl5QjIE8Suu5ps06Xv9y6Ll2PiZQhox9tQazj5DnYe92blZwHqGhnJtmAyzRp+wECK1aODQ92qFEW5JP2C6Sywrc/1p9x4kUOOaPdKJ1k8Z2+IYcso/XGjgooTkWrR+51dOkUS0ovUQV/sRYgbNfTvYzFUip/EZeVPZqDKwydXlaaErlmjGUcaglNjFsGh863anXBI/Uabxoi5Ob34zsuW+i1gygbnmU2mqOw7jRSWQu77BdIL9mQSBP26hSoTSLcDZcfXKbTD65R6Vbyfj5EB1W9m39GTg/OvKrFtx4tY28KdUr46DceQKeDXSNrqjNxHVWYIrF7DP+nPlEPrAN2vbAk235McCGYjiMVKoc3XBhD68AYmuZEwpM+owsqsdwLDt8i2EuDf4c1H7zr7AD4eYAv1dRlbxE5UP2zHozW5CFW8HW3JNf5YdRd5oj5z52xjPNrPw72X8UQ4DScXEJ2LLsQXkGhXP+jUH9yv/fHx5iDhmkBayJgLAO1JvtWPtLy0YIkerdNq8zaGqLg9LlxHW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(5660300002)(8936002)(7416002)(186003)(83380400001)(36756003)(2616005)(8676002)(2906002)(4326008)(66476007)(66946007)(66556008)(478600001)(41300700001)(6486002)(316002)(6916009)(54906003)(6506007)(6512007)(86362001)(38100700002)(26005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZtA8LQrmfLogJxX6vf2FAnmX+YRYVofUc49Ow7Uwqpw4WFTsEbGvANKxj4c+?=
 =?us-ascii?Q?18ArIupgONQhkue7e4QgZhn8LXYjZ6s3Ydar389EdkLj0qNPgBed52wslbAm?=
 =?us-ascii?Q?tLBEhvA8cgQUsOGzPsw4A84ixnenwGEaWBqlenHzI8w+h+TMjH28EAjmzwCp?=
 =?us-ascii?Q?XjSh0s0G43jdBZ146BuJJvBHVDNnkrXnQBLqb0ok3joXPsVSNk5hZLMqBcwi?=
 =?us-ascii?Q?OMIQF2gjNYXC7IIU8rLTqF+TKyunmquwP0FMxvfaLRhq6sUDlUloGo0x4Xjz?=
 =?us-ascii?Q?5skYk1yfaGxq1B2zhih9EyAPRYFrv8rYY0oare5074DoJVsfXp1StgkarCFO?=
 =?us-ascii?Q?iv+Mf2dR+lE8ieeTD8loL+BePzz9vc46qaJCcGY2/IkhmOYxkxv0u1hJptw0?=
 =?us-ascii?Q?DxkTXjNuv45EaBwLjkurxBcrqVVPEWtC0mmK5HI7tL5xQWD6zPb5svWtJtlf?=
 =?us-ascii?Q?y2Ls+M8oqGBoaC3OgNmux5Es1+5ZqIUVFJtqvI3nUxhXSUdkCEviXVHSLQrz?=
 =?us-ascii?Q?p/rCf3XdecXIznvDN3VPHSdXjq3BDN+iQNy3QG9MfwGza6RuCD1k2s45XSdT?=
 =?us-ascii?Q?EjGJfpJFvCKp1WP/n3/GhmI8wsw9Ylsszd5Ibkiva5EncUiZCCnijR5GWF3b?=
 =?us-ascii?Q?IplhNgrerIj1I0ag7p4I1+PQt4r4JBCmY+j9nRarA3wlUE0RfXh2COAw4WI1?=
 =?us-ascii?Q?kX3VoDnU77j/+v0XTBKmAeB3Q37T8Ic2YPePYkTB+UUy4ABEKzy0/JSa3muu?=
 =?us-ascii?Q?Y1uT/oVuKxSn7Pm00ysZMXHGNQoi0CvNGvLqaiOQqA4mWuoLhOep8ATBXO43?=
 =?us-ascii?Q?eXIuEWJkVbLXMCEufB5CktfQ6qD3rXHNj8scErJA/gnrU5W2vID9WVLuy7FJ?=
 =?us-ascii?Q?PM7MXtWT3yrUhrBaQFlwUxaw0uCfCyoAs0i6ghWfAoeP1niIrYxlsMe0Q2Dr?=
 =?us-ascii?Q?hs9iNzOTF7XvBUxtQU3mPWWIyfoohKK3qsZcmN/zWH4mWLL8GPIwayg7Ip9y?=
 =?us-ascii?Q?2aXlZCt16oMjMT5kOdwBQKJv1Gdm2A4jK55eEjJ3mhiWw/q8leM/X5rAMrfA?=
 =?us-ascii?Q?kSyA9YSynbZtlxD26734dLLFdLUL8bUc9WApQXlGjPUVWolozprzo3hYEycB?=
 =?us-ascii?Q?s3QzZhddH53ObBK1nOw7CKhUAjLXWRQgGQoPb2q6AMYTZYK/0XNTbgOifoGL?=
 =?us-ascii?Q?yzgU7ZPcjwuHY9NbycGswxi28XYeeZq7qTPwP5g79JoSQhUMWlkDzSvs2dVQ?=
 =?us-ascii?Q?rb9nG2psfF9+qUpNGTUKVfh4RKF6m/aG+V+XoW4ChBEC6HsYI/h+V3854328?=
 =?us-ascii?Q?nT0y+sNe4ko3YWGiKchUQ7FXUomCAkSs5wBwZkR7gXVN6vbGXiyE+CB8f0I+?=
 =?us-ascii?Q?vIIaemkTl3Wg8dJRQ64M7AcMfuxcK5Nvr82n1h4beIcpy7+CVMhfVmDVdxrj?=
 =?us-ascii?Q?33aeQPz3w1WvYO1eYI+GaRoctTqnCt4xw1AOvLZUF+hRpAfXrNcpEmLHp9e4?=
 =?us-ascii?Q?CMb/7IDNfkTVBxRWe5de8nZTptvwSZe/pj2gvj8rMM1v0fqEEb4fIUj/kbOb?=
 =?us-ascii?Q?8I0NWOvH2B2ZM3m1/UME4p1BAy8ZWVnP8SnhVkYE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2561257b-52c0-4f06-ae3b-08da9293aaa0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 18:46:54.8413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wkjq2jNgbHHavk4GwbZ0gEJa1i6XywkO78KAgae7oO4MofJOqIMr2zT2MyvzYE3U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 04, 2022 at 04:19:04PM +0800, Baolu Lu wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 589517372408ca..abd041f5e00f4c 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -10609,6 +10609,16 @@ L:	linux-mips@vger.kernel.org
> >   S:	Maintained
> >   F:	drivers/net/ethernet/sgi/ioc3-eth.c
> > +IOMMU FD
> > +M:	Jason Gunthorpe <jgg@nvidia.com>
> > +M:	Kevin Tian <kevin.tian@intel.com>
> > +L:	iommu@lists.linux-foundation.org
> 
> This mailing list has already been replaced with iommu@lists.linux.dev.

It is also not sorted.. I fixed both

> > +/**
> > + * iommufd_put_object_keep_user() - Release part of the refcount on obj
> > + * @obj - Object to release
> > + *
> > + * Objects have two protections to ensure that userspace has a consistent
> > + * experience with destruction. Normally objects are locked so that destroy will
> > + * block while there are concurrent users, and wait for the object to be
> > + * unlocked.
> > + *
> > + * However, destroy can also be blocked by holding users reference counts on the
> > + * objects, in that case destroy will immediately return EBUSY and will not wait
> > + * for reference counts to go to zero.
> > + *
> > + * This function releases the destroy lock and destroy will return EBUSY.
> 
> This reads odd. Does it release or acquire a destroy lock.

I changed this line to
  This function switches from blocking userspace to returning EBUSY.

And the rest too, thanks

Jason
