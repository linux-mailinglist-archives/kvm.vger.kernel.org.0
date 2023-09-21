Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E43E7A95FF
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjIUQ7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 12:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjIUQ7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 12:59:36 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E031709
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 09:56:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsmL6NVFd4s1qfCifxCDVpH5OXv5SBJldK5bSTMjoKdzKjdIp9MprQRH1LG+LgJU/HhkEWoeodp8JKO5GY/DT/KsYgpbHqHq4xHVvkFH6VLrJ7IuQV4BgUgTOhY2BjlhkV5pLF2AmzXCxdlNfHCrLOklZPrM98YU9EJf1mDJVo+4m2jfE8aiyHrCKkA7wGyqZC+FWbdCx5hQxK1exrTwRFzbf0MPIe4ZqLbWEFCFXcODi1MMWyGXtfadoLpDKsNIQBq9SyfIkiwpI4ZjENPQo7Y7zKU/EClR1JIF6QnplNEW4ph7hBP/4y03iLN+V2CZ9crmh6gmYawH3KXLqo+q5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZW6qtnkNYg5wwF6qIsFWcz9lVXzVRtMm8fRrmfB0/k=;
 b=gFHQzuNkO/Yw9CHmszZkW8lg+i/6GP81v5uh+EkTxaDkLbjSZnHWz4UBlLO9lu0IVpaOftz1UmahdQx2YHqqrA1M56R0/j8kBTfBVU14bOcUwZdhy/OHffcivxbG4gGCnexuaEsWRAJHFKSON/Ed8T10j2QRHjUgPntIzAD+QIRhYx4KoLkMqlWGRMPcO7qwa4Oj1n93jBc8fApzWLZ7h/NwoV9Lacgr7Dqmp5u0MS8oWOzS7k+Im/2Cko8a9aSwEXOzdLbYPE9yzRp/hmvj/7QOryBati1eYlyX56OvjuKjbi7ON/1Qo9szJkt0zFU28sNol1BJ2o+bheejtfiH1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZW6qtnkNYg5wwF6qIsFWcz9lVXzVRtMm8fRrmfB0/k=;
 b=lRlV5PVx1+MklG1SSBJl5QIH6AgZnobc6oUxSonla+POnbFvhJUme8SP/XCX0zic89+FmJuNNX/Ya9e/Nb75nw726Zcgbdl7m35iT4gdmhf1Aii2VfmJmr8fZTzCmoAXzpMaJG/QRrhexaVQRWjfILEagtEeYrvf3eX6USCYCb8h1ayWJ4Zc9ucOtOcs2mb2WU1lm5MlTbNFWKKHrXrYu4iAt/Mfvj5h2WTpOT4RZ9qmXRiECswGlgXmV7dEfwpTBBqhqXyfXVXrkTOa+2W9OYSz4ikNdOVkYlW0YBZjcLJcj+FWHkQm+J9oT/KNe40ydVUXspqH5E8puh9WI9f5WA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB8302.namprd12.prod.outlook.com (2603:10b6:208:40f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 21 Sep
 2023 16:52:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 16:52:27 +0000
Date:   Thu, 21 Sep 2023 13:52:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921165224.GR13733@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921104350.6bb003ff.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921104350.6bb003ff.alex.williamson@redhat.com>
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB8302:EE_
X-MS-Office365-Filtering-Correlation-Id: 378f08f2-d989-400e-b963-08dbbac322d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VfhTskvO2saZOYNGmLXsH+qNrQbu7TC2yPHc9TS0AufbWgO4L0wqIYtAfj0kPORXKsNoHLySBtE7paKSyMsaz5Y3R1Y+GuRMbX7q9420KE/FgSohp7Nx5G9OzDqjXL9ZMEycQi7Ri05fejhl/Og3/4dPtAyLwU6PxIlzKc05RkecAV/NIkq/iNbZo2g38eCffHM1ZkH5gTt9iCG31IXiE7+UZvexCP2/wNn4DK4goC4LClF3QqAr4YyGOQTPaihzfStCgXTdhaPYngFmGjXiNQYpg3l4ZtHLdOCWVF0+TzGVGOLd5rJ6lnWu7Tx+R9AlGlZVPv4jy8sWbK6nX2yMerJgK23F5zVtuqNqKuYDYZNZAM1uXj8fT2kli9OGtb2Y8sueZhok37DOQRBLg0gQu31PxGDVODTIU4IcEbT3WJNySxFt1oL8VoABWEJirYIbwxg4ZjaFwXaHciF3sTyTeNKlo3rl8Dxwy+uzpcBYf7drCx+enzJ0XwG1dqQFdAt+Oi3JGfczztgmsKWXO/AxVOUooHu6s8j2Xq821DwViSi+kdCKbMC96DGdAzzbSuEh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(376002)(366004)(136003)(39860400002)(1800799009)(186009)(451199024)(8676002)(8936002)(4326008)(1076003)(83380400001)(36756003)(86362001)(41300700001)(33656002)(107886003)(2616005)(26005)(6666004)(6506007)(6486002)(6916009)(316002)(66556008)(66946007)(66476007)(2906002)(4744005)(5660300002)(38100700002)(6512007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?31UWMvHSpfQlxvSESav7zKr0IW54X/gBIjzorW9MwD6MxJwUODWvXYLFwWjh?=
 =?us-ascii?Q?2f1weLP3+Qw86UvJGNIGmVJWPO8aMxO+/8YhcANLp+cLvSlZOOzDOm4go3r4?=
 =?us-ascii?Q?zr+Ibrt55QBbUYtn8gEq4yV2dF8nemKh7PaZJmx48iW7KBjTlExK1uhIq4RD?=
 =?us-ascii?Q?UmgT3fdgifZUDqyz0wGrPhlJueugO/MhCnTIB2zjROy8ZfuRsJ3O8ijb5iUy?=
 =?us-ascii?Q?tAzDPXRSwLeFL0izEg5CKOCVIgq4LhybEG3QLH82lBuRlpDNvlCaXqtq79NK?=
 =?us-ascii?Q?D4EcdmgrSaNnUGsSaOewnZU3SLlGPPbG/TwfQxrGK0Jp1p2AQPSPu0JMCVKV?=
 =?us-ascii?Q?7UbBuiu8I3MfSsxU0MVeNcmOhsWZBB8qz+EoNoD/upfX3uO5hE4I+nQcjBy1?=
 =?us-ascii?Q?wYREmBHaVa5zRDobacplc6WQy/p8GIzXuj5VJOteVa4aqTU8pmg9AfSZ6W7m?=
 =?us-ascii?Q?IqIyfPn2NRAINE7MTyrCXJmd9cxOmcDd3DvZYzR2ftq3H1tT3FO9fnM+YglX?=
 =?us-ascii?Q?0OjRD80+VaCFn86VBAfzt2niiOf9IBO62Dvky4EioMEaFUYh+EwHprQZIX2b?=
 =?us-ascii?Q?OGkPX3ttbP1hC9Fm7kutp8Jerk9HYsCcO+YXdcAOMEkZMC5fNV1RRMjybnQY?=
 =?us-ascii?Q?89JEn82qk592nc1sqC6sZliNhxyv2Vuk9YWhD/cJPQ1x7iBM5eZ8hRp4OkVG?=
 =?us-ascii?Q?4lDXq6c1SQ7MiJ46cGHv6zjW33n2dVGIN5HDfIvDwJMTPOsNXYIeAfvZKWth?=
 =?us-ascii?Q?ZF2UsVs2OYgK9kcbNvFCLM3sjbYKI9288W4/IdkP3e7tATk5ypGa73R9Z5c9?=
 =?us-ascii?Q?jj0q6sKPFbfsUoiJpWsunDyj+G+Go15NFf5RYM/Vfa9wm9QVrX69aYtxBB/N?=
 =?us-ascii?Q?lIlthRKZ36MnROmkeMbTREm+Hp2bXxZxPCBGu3t8xg87OlKpVfCVvsgqN6gj?=
 =?us-ascii?Q?OfbhtikX7RZ6oE9YLfcJ19lHJ4Yn4pSDAJ8/79PWxHEkKSnOO55AxweBTQeH?=
 =?us-ascii?Q?+g72/CFJdE7/jD1lpnS0T2Hhk/8xTiKOoOg7wj69y7RhOyBZcTAr20wW/4zB?=
 =?us-ascii?Q?xnyBCntojCmHEQBkgMMm61ojFCceXpBh2I/gvLtqrDtmc5ITAFHXTp1jq0Ve?=
 =?us-ascii?Q?uEGWKWetagozgK4yn29H1wIkOBMKTgOO7aKcY3a91iDit0apOd7SL7M/H5AQ?=
 =?us-ascii?Q?xZI+MXoy/az3EmBANGl/6MtNS71W+feKMApNPH35bXdaITJUc0n9SJnAeO3j?=
 =?us-ascii?Q?/TdkAGxvu4+c1bVpHuOb6YMnp8yzKkD2t8IgnKNEeg0/4R6gCHXUPZg31NUX?=
 =?us-ascii?Q?ILbbqwcDAyQOAJ4jz7l7Zw1kTOR5kc4rVEHXNkJSECZZHwItWz3JQfZgwt3I?=
 =?us-ascii?Q?eP7/jJZRZOp2uL9R0OaoapJ8eZpSss8SvOWoKDtLwsguWuhbJzHe2GieI8EB?=
 =?us-ascii?Q?GapzCKoZALgaWQAWOTUoFq1xOC0PweLs9rY4Icl5qUnrEBpZeNv+XcmaEMCz?=
 =?us-ascii?Q?aop2RaiyN5fVyxe1SLxXYu01a7GOx+8/jalBtDubHtQ6utc5fOXtbhf2xDog?=
 =?us-ascii?Q?X5gQFebCgT0ydJgEchv4rjLWF4ohE/2RvBp1orgh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 378f08f2-d989-400e-b963-08dbbac322d6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 16:52:27.0929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qtFjSwRKPgkJCeH5/N3jveim/1qU0jmKdlny9rsvhK4296N1papTQH7u5Jafaky+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8302
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 10:43:50AM -0600, Alex Williamson wrote:

> > With that code in place a legacy driver in the guest has the look and
> > feel as if having a transitional device with legacy support for both its
> > control and data path flows.
> 
> Why do we need to enable a "legacy" driver in the guest?  The very name
> suggests there's an alternative driver that perhaps doesn't require
> this I/O BAR.  Why don't we just require the non-legacy driver in the
> guest rather than increase our maintenance burden?  Thanks,

It was my reaction also.

Apparently there is a big deployed base of people using old guest VMs
with old drivers and they do not want to update their VMs. It is the
same basic reason why qemu supports all those weird old machine types
and HW emulations. The desire is to support these old devices so that
old VMs can work unchanged.

Jason
