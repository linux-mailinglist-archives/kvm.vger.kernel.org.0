Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2477358557E
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 21:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbiG2TNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 15:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiG2TNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 15:13:39 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12hn2249.outbound.protection.outlook.com [52.100.167.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2FE7644C;
        Fri, 29 Jul 2022 12:13:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a98jHygj2bkIljzKVBhOeGY6znTdRzI8PdLpYsy5+ciyixdTuTH0PzF/WzlNwzY8vs18/jCCAVaA8k7JZ8HsvrNtl7Afn+vObFVR/J8Co1/JVUhh5b39W+DlbSaUgdghDKUR2xnieXtIDRbdpUkQ/TBNpgHZp+NcCoUxxWO1vuTusNuloAMSMPXYE2HkPGwiVhuXMX8w8AOmMcS8RUkUvmI/VoHgD+L4jhy4tsv1WGU/X3aPewQ90knW+cqyf/dRoiKsPQdT9ZcG69TG+tCb8XZxHWfzCbAZvpjK67ltyEkaBiSK6dAuVrrr3yJ0/VHTaWosGX6GECuSMCp654fGUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TsylQ1XRvTuB1XDBzj4psxq1J0gqPqL8u7hg0XZ7nLM=;
 b=Yd8qb2YlWKq/TyvBjh+DbzcL76yRMmTZWTdTGbEDul4QsYeCRBxi1gmdVksZWpMLQiSgGPXcWfbsGRulbAfX5mo8VO7r+KZFWVnpUP8M2S5PdNZUHOSd4ShPI9EOHvhAIxc2xRAQKDhakRhPJHNKkUc/ZGdEAUDA425D3i4RxsuzRqhKiJVCfq76RjyhSsON6iBu+SZm+b2UnaePIvHU1PYwdSwdHf4GuZ0CId5i8ynNzbPHVPQr9bqK6HtS0wBkkF42hooDATSucDt6JtlUlJjz8X4+Axw4905jddogbwlwaIsciHizkSP4XDNHQe4sK+YABXk5ozRU4y9Le5kk0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TsylQ1XRvTuB1XDBzj4psxq1J0gqPqL8u7hg0XZ7nLM=;
 b=Cy0vvaYXv2d54f22D4hB01JTbR3kAt5RvwSGezafEIifmyTzI9jUjvwNjWq33CjAaHxJFqqQ4zTXYYeVtie1UTcSoJVkF2XWhEPGrE4n0pQw22NehNPV/zgwcdjdAzmGpq35KHiZoEoyJKvwV21s/dIeY1WAsw/FjblB4M/vCYr/onop4kIPETn0Q8BwyE+YfZf4rbvHJVt7MF7LIM6ZT/o1Avrxfk+TOIb9l/JvPEj3RG2kzFy7VGtTQ3Rr41pPKopBFf3Is/7F1pWlQckStwCfHQOaDrKybaexkl19amVTNSg/jSfSUuBK+RJe/2NXwBZtKm/ChJ7nypNuKIotww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB4900.namprd12.prod.outlook.com (2603:10b6:208:1c1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Fri, 29 Jul
 2022 19:13:35 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 19:13:35 +0000
Date:   Fri, 29 Jul 2022 16:13:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/3] vfio/ccw: Add length to DMA_UNMAP checks
Message-ID: <YuQxXEWYoY23GiCv@nvidia.com>
References: <20220728204914.2420989-1-farman@linux.ibm.com>
 <20220728204914.2420989-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728204914.2420989-2-farman@linux.ibm.com>
X-ClientProxiedBy: MW4PR04CA0356.namprd04.prod.outlook.com
 (2603:10b6:303:8a::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11de06ee-37bc-4cc9-79a1-08da71966f1d
X-MS-TrafficTypeDiagnostic: BL0PR12MB4900:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SXXsKSazTs+CBnL/dcuURXg7mO0upb2TVVZqdE9ZXofZ0/NvNJheAInCf0NN?=
 =?us-ascii?Q?LlO+n74GQAB4iPiDlLssuYX3kyEQDK/+3KghxpKKGajjqjyvQd7UoUndwhuL?=
 =?us-ascii?Q?M4kqNLmJmdtBeG7b+jePVHlyKmPz9KP9cNb6tcwT2YP6JpTAFwrGk1vNkrQL?=
 =?us-ascii?Q?qwl5iSv6WuPSz1U9txLWoM0FdmdLj6ZZiqgBPgCyATWiYK9cJ0lqTXTzNAgT?=
 =?us-ascii?Q?4LPVcteI00P37FrEn8ZGEzEj5BsikrABtSfI2nkSf2LmeAg0DN1jljgD/As/?=
 =?us-ascii?Q?2haovYkSV8+MNLSlNNvlWA3nfXsJVQCRXzSkih4MEmQyqQXxO2SfaZ3D9HUC?=
 =?us-ascii?Q?LZUNHW00VGjdFnjeWgNp9Qe5Bn4xqAj2JQSiMfSiOATBquXDcVM0oVCBtLQA?=
 =?us-ascii?Q?+ry5grLYZZz4ah9yDFlXT3V7mmWAjW/E2YttldryCXkBeB1dV6IxZaLFRb9h?=
 =?us-ascii?Q?FH2uwndpLUG58jfy7bVrcqzs36nu4WfD+St4quvncTeCkVFRrMB3zHL2HuzO?=
 =?us-ascii?Q?Q7C1TMc+m7DAHZ00npjNlsXtP0khVjft0cpGSVtEFu6j/ZRXR5Ql3O2FU8q5?=
 =?us-ascii?Q?Vkr575REp2EPrtap+fqXW7uPNzBPVQoTCFd/XNLoWIN6TmxrUmkerZ5d4OIk?=
 =?us-ascii?Q?3hSLbATZS82vNF84m9i5k0PFZpf9APmyQGznpFMncT6EUaxQVBY9qmAFwp1/?=
 =?us-ascii?Q?Z/LA0QjUB1hp4SxnDabjEfwrsRbZOrMTuzXpE94ZJMBLCr0gyiEK5dfLFNrN?=
 =?us-ascii?Q?fVn4tlA1pnaECIT1wx8XTPa2oa+SCxBri9zIVBvLm1rW3DKjWmWwssLgdQBT?=
 =?us-ascii?Q?XgT888wcMsWHtkqlnMNueQR17/CbRMi74MJQNQQIVtY9if9g3wEWnWXUgsWj?=
 =?us-ascii?Q?POYjaCxHUFHOBee+leuyPxXQYN2XeNtPTYnPfzVqj068OSrZxuYjemoGQqAA?=
 =?us-ascii?Q?mZsa0ZEg47T8WGh1UMGmT45Qd1P6+L3E0Uj6S/5XEr/Y9fbAvFSXTVElLrbu?=
 =?us-ascii?Q?oufVCOjNDu96QcPCrIDD6oWlwTAknvk7qdG7Wj9yQa1J3110AaBnVeQta0HF?=
 =?us-ascii?Q?T0HPgCIxkgt70iH21ABokge1n+SesFtouCoEzAw3t0XHadZ3yfzUvjDekxQC?=
 =?us-ascii?Q?EY71Q62QnTc7lVOZvaAGPFDOV2V9vBVps23Ayk++Qr2rk1FrCveqxI0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(13230016)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(86362001)(4744005)(66556008)(66476007)(5660300002)(8936002)(8676002)(4326008)(66946007)(38100700002)(316002)(478600001)(186003)(36756003)(2616005)(966005)(6486002)(6512007)(6666004)(41300700001)(26005)(6506007)(54906003)(6916009)(2906002)(83380400001)(59833002);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tjaq6Gg+b61gZ8IOtZJqTU+VQPeCYxEZBAnDl0ITj+PVVzHKba4/Bga+yTz1?=
 =?us-ascii?Q?kZAI5JpnjSYXNEynKJs7E8QFFwGzFOleRwVHD44lJF2vNbPG4K1r76YBuTZI?=
 =?us-ascii?Q?x240eRLRTdiIciVIFFNv/EPEzmktJarYP+hTRGymQa9yxq/kFd9z4noC5qlx?=
 =?us-ascii?Q?fTQnmT0jDLxYOZd3yxfBPGUDmx24cJ5aNadOBB/PSkXElAhPUEj87fwvrZhX?=
 =?us-ascii?Q?V5/LmJY6I4B4zfT6Na0DClamlOLe7qDW8tIJmFu/vcLtfZz8XDiXBh49lrOm?=
 =?us-ascii?Q?HXnO+KupRMmejf1HmWvwXA684J6r4tzPOj+tw0eR8aNqKWIH0/0nX9wp/BA8?=
 =?us-ascii?Q?OV3uxQZXvZTJY6ckXATArOMvauvf/xRHjsMmiLnaf2tzvVcWUQrQVPNs7gtz?=
 =?us-ascii?Q?fE13M4NXnP7mx75PK2b223QyTaSztOBYocTxY7u8BYmxH88PCqEj8jMZG6GE?=
 =?us-ascii?Q?16VtXeXvG2hb8BV7UWAh4qvXqVvf42lTMrRj/Yv31OSZEersKoDqrHq9yo7D?=
 =?us-ascii?Q?wrRv3exAhgkSlxwz7yOUDAVO/ZaX9AzPojFu8QHKFAbsFeIfq5qSgYYzO787?=
 =?us-ascii?Q?1/nRrQTYvYD+bcNnGfRiiw84hqjS7f2lKpYvrt57IhLP7Lmu1mre4+O4pQkM?=
 =?us-ascii?Q?3AqSBq/NrfMEu5ST+k5WgEgPJrNhC/oQNI1peb7zVKp7nYbjKmARCKA93TG8?=
 =?us-ascii?Q?QvDMcQ73ZK7ZNkH+v9ATyb2CW4/gx2FoXtSMSqudyN+biRcuUJIgQymGKRiw?=
 =?us-ascii?Q?pFijAxIlFZhEvl/5wmRNjwzX/Om9+TmKYajgphlQFJE/6aew2TaPDXVW62u2?=
 =?us-ascii?Q?3oGrJ0vhgpjtlZYIhG3XltoixG1o0hWsOhCUcgCRm8f0bXx2c4dVUMX78Ozx?=
 =?us-ascii?Q?A6umnGljn2CneTCnPW3fj9Sgm4u7eCJNCrHBGG9lhiHar0psPisc1tfTJPD7?=
 =?us-ascii?Q?rdHEF38c3OHRohN/jHpAT5nRkax78jTER32FxEJr8e9DNbBx67+lqWKN9j9b?=
 =?us-ascii?Q?YmN8MdryC7Pb3IZeMbtM9BDKBAYQNaQWSMkGEVYPPtbUJKDflRFoXO7iB9eI?=
 =?us-ascii?Q?5btgcLfXUPJKU5BObnoFXGzMRC9KXrDj4+gLPwIZlD00jDDDC1GbxZhPorkW?=
 =?us-ascii?Q?fdC4+ZML5RmpqJoDLYJaxeCadFqcrS+XUv9qnDT3Yi7Sh1q+dKgPgi4EETnp?=
 =?us-ascii?Q?fdJO+ISSnDsRPT7RnGeflu4titRveEKQm6YoUeTaBEW07eHUUUd4NHQCI/SL?=
 =?us-ascii?Q?rzohUkXLAMpWtqu3fgA19VZJG+p0O/MR5K+r9wRCE7bJL4dizFp1Cje8IOcr?=
 =?us-ascii?Q?oUM9z4AjGgU8G0/Ezq3BYCAy05Zk5u3F2pWxFYZEgR3FNVDgzjzXhXtKNAuj?=
 =?us-ascii?Q?YKHE34Xgrx0JmS309Q7frT0FrAxxEiUZ6uAo9BFjfAdrXR/RrkS0EIqM9qHE?=
 =?us-ascii?Q?C/cRCS5mo+yuMVvgZnNHB/3I2YIqRXV8AupbOQ8iTLr9fgF0FbM+lnQ5igFe?=
 =?us-ascii?Q?KPJW9+dd1PsnGMMKyyJmGFMFtoCNawoe0XhkzRF2LAvrRl+kF0vTHZ7S2wAu?=
 =?us-ascii?Q?jifEnqal6LluGj/0DB9quB2GYmCob8wI3PH4GaC1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11de06ee-37bc-4cc9-79a1-08da71966f1d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 19:13:35.1144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXVdNUVXbYDQRWtZPH1xrXTf0C3Nl9A8TWFdGnJHuhggBZTq+BqQfIW7KWt+rHtR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4900
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 10:49:12PM +0200, Eric Farman wrote:
> As pointed out with the simplification of the
> VFIO_IOMMU_NOTIFY_DMA_UNMAP notifier [1], the length
> parameter was never used to check against the pinned
> pages.
> 
> Let's correct that, and see if a page is within the
> affected range instead of simply the first page of
> the range.
> 
> [1] https://lore.kernel.org/kvm/20220720170457.39cda0d0.alex.williamson@redhat.com/
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c  | 16 +++++++++++-----
>  drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
>  drivers/s390/cio/vfio_ccw_ops.c |  2 +-
>  3 files changed, 13 insertions(+), 7 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
