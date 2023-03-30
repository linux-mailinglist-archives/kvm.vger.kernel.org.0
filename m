Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCB76D13AD
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjC3Xtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjC3Xt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:49:26 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDFC18FA3;
        Thu, 30 Mar 2023 16:48:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAitdBTRjLMGOS29PIxPwsdHg+o8qmx9cs63r4j3Am+VNBix8xsgpLrmzALSwbsV7G9flM1Y8YEOFD8Os7rcK4LEQeGtNM2gtpuXSXFPsvFxAteYLMWlvQ+4q1KHr0KEL05R4cHHpaDmJwWdLoYTSQsTTzLEv/4ULwYJVigQsXdZF99Av+COyU4yofKFAgrr5v+hF+GWZKEjhTegFjoDMlT91eoG+aADPgLpcg53vpQc8U1H13GcgKweoHnA2wxN+uiYEsF/QjZhUf6mB0hVobAbbjsQtLCs8XrXeJK+uE+2NFPwhrnIZwi5X8uxMusIegBPMCWBkKKvh2aI/upBig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SAMsIYuYCxJc759C9MhSiol+voHMsxBWfg6ibiFZ5aY=;
 b=DuzIoXY+jvfbJibfNii/BNiaAmrOtX8qyLyA4eob9LCmzDBXMUs0R1hEorWijvFsKeNVb2HZ+gn44PjY64ONT3ex3osfEfZxFOEpR8gPLf1XcnCza9axHWouU6ZGfVN9Id2+nmcne+FaI8pHS320NsEQTI7J26OVQxGd3GV1SY7EjmYl/8NzuygC/JDqQrH9IPwT2sYfAXt8BMRS3nPNDslADZBoQZsR0xmeh6PLlbRndqra29jZwTTqiWG8EQPfNq9hD+5yVAfQdjWoAPbdAjE45xmMD4naH7h4mcUtwL4qCPXVEbVePHadepGIZ0HMeORAy3goMZde72DARt/9wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAMsIYuYCxJc759C9MhSiol+voHMsxBWfg6ibiFZ5aY=;
 b=C2W/fBohnLxvsqW7w9OZLIzPOppJQQnHKMQj38yG8Vz7BVX+WWMuhGotiARgXgl2kW3bmouccG4V2BbMgAx8w473S2oRcRV9x5K1YKrQC6Q8h2Ixe1KkzOSvQhluam61ud+91Zj2cuwzvBVZcLFNRFVvc/YlQZJaXv3fuM9GRw3eLwE34xJ6wqo37vjArhVClhajxwuYCFrUCBTZyCkwsBvniwcI2pDPLnGIKqp+n0QkhXLB0Nuxk0kkelvpfksl56mtJ4OFm6U7vpRn0ZJhMpU/VrCw3QyAtaIYV+aJOZPX/IYegbWpBx6Z2X2ehuhwvX1bK21dfR4hwomQDwKp9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB5641.namprd12.prod.outlook.com (2603:10b6:303:186::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 23:48:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 23:48:33 +0000
Date:   Thu, 30 Mar 2023 20:48:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v2 06/10] vfio: Refine vfio file kAPIs for vfio PCI hot
 reset
Message-ID: <ZCYf0PnE5E3Ci9Pn@nvidia.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
 <20230327093458.44939-7-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327093458.44939-7-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR19CA0029.namprd19.prod.outlook.com
 (2603:10b6:208:178::42) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB5641:EE_
X-MS-Office365-Filtering-Correlation-Id: fd2d6be6-d174-4cfb-37cf-08db3179458b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfPjwWXUNadRb07OEaBPtqWiQYAQhrzzZ3KKa2PmP9z3qRICh4Dn8w0uqyfOGg4ikaiHvQ/blkEF6xFHArpDcKsEOPwNVJlIyy0aOThh5CscG9BdYI5AGIb4xy2D2Zjvn2rzYVawV8r2ByZ4DBsWrwxUkowBhA9kFrpzrRwhSz3zxLQeP/gos9XIsR7zRP5bg6Ow67vmq9RfGnGxio4+OZ//1+RMxmmsvg6Mz0HH3O3J/Gj4FyJHjf4es+ZkmSebMfbmcz1qhIDoTwBV11lJbZKQkve4uia9eKJt7TXl4FhrNYCrDOAoskQuJNFQs+oNSynlfl1CPq15HRdGMiVnIhj/fEkFWFFFfOhA6kmZJV4DVI6z0GWjD2MAKQx0+G00wlYJgMsCPbuTh7OvAdcLgGHLDlxWiohocS9cmSylyxBzJ6wxQw8nCWdqLO1A9sIeelsi0zIuYsvQ5vEbvbgHKkIKDvDCWadCuAXKaLEpJYpdH8GRVZeUuMWdAMRZSSeVdwJA9D6oTpvxMY0J3AGQTFMaUU6uGFDcZnE/+jTyz2BMRsrkr8dA1iF+bDGFI4pz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199021)(36756003)(186003)(6506007)(6512007)(26005)(41300700001)(7416002)(5660300002)(4744005)(8936002)(4326008)(38100700002)(66476007)(6486002)(316002)(478600001)(66946007)(8676002)(6916009)(66556008)(86362001)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FtyzRwwsJRZMLyVeP2TU1ntX+Mibuoxni0VDodzYsxNA2FU45LneKWc1qA5F?=
 =?us-ascii?Q?jndoi5zPdWDkrGLuIqEHfd6wZQy6WftKb9dCFrL2EJ6MxEnLxbGz4no/czn2?=
 =?us-ascii?Q?6+pYLIVouj3docDsts9B6O78kBiIi2V+PCGRO1M/lNDei2hSbbFU0djA+Ati?=
 =?us-ascii?Q?orwh+0CCU0SDHwtsu7mRmJav9D8PBAoCLvI/U8GV9BGNO+o4PbohlZojPZzY?=
 =?us-ascii?Q?wO5xIekYstLxbWElZi9tmMJWTNB3g6OpcZhn6FaFsXOYJmCktYXKKU6h9npF?=
 =?us-ascii?Q?h1DLmAwBzzXWItpjqyvxL6ndJlOPCR5gkNFnnUBr30PUmL392AEb2lwtrlxY?=
 =?us-ascii?Q?MmLoHKqa9hrRPi6BLizVcJLG+BVCpv9CikAxYbtFEYEn5OB8pHnXX6AsMYxI?=
 =?us-ascii?Q?LF24cL9vVbT3WfPOqc9XyVo7GURsrgfwm3O8cHlZLMcNr0JrPnlS7/s1+W4O?=
 =?us-ascii?Q?cKQ7+qhkP5d6X9nJeXy/55rQfI1ZylEGGTWdpibOYSpbSiEOL1/SiZIRGZii?=
 =?us-ascii?Q?v3AqRjjez5P9znBZqw4VUw6c+TP8NKD4vc0mNC7RH52YdMEmDBx8Cws7FMb3?=
 =?us-ascii?Q?ewOYCHQwAl9j5DbybQ46HMkk2USPcy+m039HHXJaOmUf6Tcf76TQQWAjNk5g?=
 =?us-ascii?Q?MB9v5KqxEAT0SmI9IVKcYLmp9bzBGNtdp4X17c8Oek61NJ3FzvvY3Of+e2/N?=
 =?us-ascii?Q?vWxIgj9tfEovUd2/c65JPVtd9HiqnHWgxYAKFlTwI+Ug41jrYcoQ0++pgnKO?=
 =?us-ascii?Q?jj1DGJ/fUQcnt2QnrATmBmBnl/CQJH3cnp1v7MgmmtnogQFUNjaurfmDmsBF?=
 =?us-ascii?Q?WhneNt4LPfSS6VJ8qjcnrLYPcg4RURqcU4NJmZ1dNzVA7MFsP7r3PiY3+KQb?=
 =?us-ascii?Q?Ti+2e4MpslQDWQbLgjZGezUekBX/J2Kn3o6pOuA4qvmFloonD5uftvKD/bCQ?=
 =?us-ascii?Q?cgU0t5u2iUIKulyDUfzQFYGMD/eeDztb6SFfcwthw12vvgaAhPFY/evRPGRK?=
 =?us-ascii?Q?+oycIV/cg1Ukq6dCYJ84WfB5G4O1R1SZ/dMRRUue6IbGhaGmIuNRjQ1EIDmR?=
 =?us-ascii?Q?H+o2SQEouRtklfwspVGY147yuhLAhhL1VahZMxZ7ShyTghcx8wtXfm3VuHwc?=
 =?us-ascii?Q?PbiziuOgQBUnQnMj7Fqx5LOBM8mZoVlAtYdGJHdzeZwyx1RF3JrKETEeFWvP?=
 =?us-ascii?Q?F7gsuMFUYO1Hx8wFobE2lQvJoQr2BZTClb2EnRR8m6cfoEpIc8RpfJ28p6jg?=
 =?us-ascii?Q?6rcFg4NbqPExiR852a+ftGXuQ0dvjScamdibwE9vEuiVZNmLQposO3hMoYNu?=
 =?us-ascii?Q?W04bCaVYik0M6BKBFJfaEZ0M5dmidnJXFrIeDuROg02xAqdVLQsCUdMnCSRZ?=
 =?us-ascii?Q?T0Ku9dt0we2mg57LPefzS1nMcf0L5UJ1N14aGYE73Exm+3/xRWqqbtVrBMum?=
 =?us-ascii?Q?z9CGTdpacncCtvPgQ0c600A7LWYO5pHP5BYH1Ywzy9d6RaoweOjQnSWx8g6Z?=
 =?us-ascii?Q?1vUxkT/HhtNuUl84tcBJ1g34s8fIjuBu9/TM8380p+nFslz8ncw5ToHb8niP?=
 =?us-ascii?Q?Eowi1uodo4y/HQNqIJSuTUkx1PoPUsYflRRZuI+h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2d6be6-d174-4cfb-37cf-08db3179458b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:48:33.1862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MUjhnajlkXzFIxmdKBk6Fcl3KZPBtmQB5QhIDMQWbJNi6GE4LVh3ovsgyZkyDocN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5641
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:34:54AM -0700, Yi Liu wrote:
> This prepares vfio core to accept vfio device file from the vfio PCI
> hot reset path. vfio_file_is_group() is still kept for KVM usage.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c             | 32 ++++++++++++++------------------
>  drivers/vfio/pci/vfio_pci_core.c |  4 ++--
>  drivers/vfio/vfio.h              |  2 ++
>  drivers/vfio/vfio_main.c         | 29 +++++++++++++++++++++++++++++
>  include/linux/vfio.h             |  1 +
>  5 files changed, 48 insertions(+), 20 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
