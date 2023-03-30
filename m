Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28256D1365
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjC3XkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjC3Xj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:39:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87516A27A;
        Thu, 30 Mar 2023 16:39:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=As/gbSaESQi2J5kl3wXWwqmXl3JxP4KrOem3mq9A6oEiGTeyvlbAsydjRc0XLLjBOhfbgdqYUOrkUZQID4Gz3soGXOazWME6BTqs4hf92xsLe/QPASxYGCikJp+9Bf1RLE6QcGdE7YIYw/VMiR6rQvNYL6mFFKig2HRMUhpSk+C4Gri7RfAJbVJTgaT6spcCzpiQRXWFZ8ZwnSY5JuWfBvxnc1FtpMbm494j8euA6PJAcpBrBrpn5e0Rx/zHBhdkFbQBxx9wdjydRNXbTSxQ/HosqA+twUTheg0x9FTqg7bUmDKroLlRI07SH0pqP2J7108B5hRcyRxi0j/SI+qg0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkjlRSFKX4ZyAH+8rSaSjf+tejwSaZJ7YTy4VB5DNP4=;
 b=iJbWtUG1DgPWUSCHYCACnR2XUPkStUoI1FWOuV5GZ6zqJmIfjeqBrRFKhepi89/Mi/X3ItWM/Pei0eCeOVOfzk1uaJVSA52QnkA4ZQ64bOcecjyiaTz77KJu0Gq9b+qTV5Mj1Cd3hWEthpFAKJcxVHZ8s5/w9YYaoHGG0fpmobd9nk03LLJALD957/R4FnsQAjIVCKKV8mbvfYdQrEARbNVh0tBf8tWe+qzpS1srJAsLR90FB8DzlUjVdFVe6y6i6IS96uZbyuQZYVJPaOwY/0/eyW3fxZnd8hHHjMOtd5bdndQv5QKLHVyZxq0PfLOLLycsQUpE1Ij4MyQ9cmbVyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkjlRSFKX4ZyAH+8rSaSjf+tejwSaZJ7YTy4VB5DNP4=;
 b=UyssNEuiTt9C95WpQggCWSmrQ7Bc+UBswHLekGX1dBIh6YionqB+cZN5VxnCHIcoD1TGzvXzwH/8f6uVSYMPfQ3NgISpUwPb72nfzABWzxPcRuQowkBmvu6IML4Yzwy3MU4B2WTP9P77mb5AnBGKNbS/ZNLxHXf0CC0kM0DRh29QhwMoIQqALYh+0JO9DWJZROoXqqaMzpL5TYyML0W/7yW+irDj430mqCNQS5QdhPPrW/W4diNezkgp5am/3G+W3STNfD5RL9KwYH5izHX7+8CuFhHkjVfwvz3UlSj0AFKFlXiZOxNn3V/6bmpBDsvuvtglEK9E2Vk3EMqBiNwogQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Thu, 30 Mar
 2023 23:39:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 23:39:54 +0000
Date:   Thu, 30 Mar 2023 20:39:52 -0300
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
Subject: Re: [PATCH v2 03/10] vfio/pci: Move the existing hot reset logic to
 be a helper
Message-ID: <ZCYdyM92cO/61LXU@nvidia.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
 <20230327093458.44939-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327093458.44939-4-yi.l.liu@intel.com>
X-ClientProxiedBy: BLAPR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:208:32d::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 990a937c-fa9c-486f-3b77-08db31781019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AgJ9bYsTb2S8RE49oG12HFb8z50h0RSYNCHTmN2yRALqT56TqjV3LMa54v/vpFNOLrcMHXIefhXczR29Yd+vFwgmABnEfRMAU4plXf2SepozaTTh/RJm6FP15EAFjS3wj8v9iZx4jCmlgKx0oobwk6JjLLfW8bYXSX0csbFc+uejHb6z2s1Nk1w41Q0MDpqd8hUQFtQ2KdP0mVkMn+KAHrEM3J7WyMWwQXE5BrI8ox0uJgU6B8K0NHQ/0mAIZeocGoDztYU3rbXOE/R77gNJmZB7v94pDa21O189LOYiQ16OsPiyFbpKNidb7Uo1kg8y5z6cacRbf8rBBLS2DZNLgi9pkB7dnCur9wUSQpW4ABDVAQRibBYlI5ObA9GGu/bDgaRv2al+i9sV9tmINvR087QWdSiz5k7GQ1W3FTqn7hCM8/0W0jpSVe5D9HYMs2bYd7QE7u6K3zxTEqq5ZP7WjugZ7wHsF1tuy6pwvBvuVOFUUirpvXbGh8J5UT2gtGaZY1tR6Dsauj8JlXtbhboehnsRYEMSxeTDuWDmBcoDSpQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199021)(8676002)(6512007)(26005)(6916009)(4326008)(66556008)(66946007)(66476007)(41300700001)(316002)(186003)(6506007)(2616005)(83380400001)(6486002)(478600001)(86362001)(36756003)(4744005)(38100700002)(8936002)(5660300002)(2906002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aDnMAnrxspoBgZMbax0Y/BOmQKjh+ArRzwCcYDVCVLwnHxurKw2J0DPuPldV?=
 =?us-ascii?Q?iBWPfVIq8vUnXUyN54aVYhKvO5RdRU+lkO1mKkH5IRcvOtdq3EczHNqdZb9g?=
 =?us-ascii?Q?aOlmc4ljDGY5QPdBsh/a8i7oA6U0hPWSefZbU4ttq3Di3ULa4C66G1oYakn4?=
 =?us-ascii?Q?qQX3jAAtieJmdRF54dJEP6rVHGU/IZmmxGwGfp6plvrHwXugWL7B0zXPgesb?=
 =?us-ascii?Q?UCl4VZ4Qjaz0mSl1jl28bvyZ3UUPIYu3GaXOcYAwEeNAO97b4+apDjonhoti?=
 =?us-ascii?Q?pKfSiFhwjYuQYQ62uwThrSnMEzqdSD3VJ49gIW+HQQj5TFLXgAUME6jW5K7V?=
 =?us-ascii?Q?gS2ogBOVRqMHxagpLiknlqhOFgq0b1qMkEn/16zlI5Olajw7lYp0qMdaD2+G?=
 =?us-ascii?Q?sISxrOLniadXDv8X+5S2+olJ+xAAf3K1+l+8wN1Ne/iVZ+xmTTUNvPK1iQVT?=
 =?us-ascii?Q?dNw4dpoMJIpao6NWJthjpSd8qMLNhe4D9WiGckeZW6Lj6bI1FDrBGggBJztX?=
 =?us-ascii?Q?C4dNf5HO4ZG30Lo1TIrAz19Eb0ofXk6mXh/vJyDYUPQRRbiaWPED38/UlFcB?=
 =?us-ascii?Q?VJuagba2IE0OJOIbXPUwWLlpEfyd+Ywv9lrr3PuvgcDEmTWHYbWuwUwKS4r+?=
 =?us-ascii?Q?buBi8TRqzKuIFVRDhctYK1fTJRXgfWIbUwXo4TM6EWzSRzA0aV0qVlv/6IXC?=
 =?us-ascii?Q?81hDOBA/JKAxkRL57S9QVSvU/6vIeq0u0Mv/e84aiZ8Zr4U3XaYgA1WCWS1i?=
 =?us-ascii?Q?WAjfNN4AqCAx5hXurVfHQKUIY8m1pCl18wcbWpV/Z32qpwk9/LYxYK4kx+aH?=
 =?us-ascii?Q?A7gUsYYaOXxgrTIgkzIj57S+vljAjne2Ph0FjXUnYxD74rm8Kh7fewj9D/IZ?=
 =?us-ascii?Q?1NbX1nCkLtsHVsUaXltqmlJ9mctmTnRzfbPCx+ndo7xxmsPBP+ZBoEnyJTi1?=
 =?us-ascii?Q?gK71W6o1hVh6txO5FPhu9/TVikPdLAvgwo6nQVMGGQ80vF6oyaYmGLMGf7vY?=
 =?us-ascii?Q?3uTgO/CfI92aWwZQ7XK4ZMYmmymtTg54btrZroetdxcd9CWnCGq4s7K/VlYy?=
 =?us-ascii?Q?00+37WW+VCcU7xJS9kSGx9YvoydhElckmzdSaIPucMYMhESAzoWVGeIv5QYu?=
 =?us-ascii?Q?Hdt5RcnOawg60Bl6UqgcFdecL0XxZqZZQ5S+9m1CIrmxNzPu2puhCvP5kk6j?=
 =?us-ascii?Q?sFnN64QHHt9hVn4OPy0pFPMy31+isyxwTmqpYU2rCsxacnLuJ3ZUDhxBasga?=
 =?us-ascii?Q?X8uSCZawODqBRAuL26g9jTdAr03PPo7jZrwo16rKbLYBbtAxq+Z+r4+sPGET?=
 =?us-ascii?Q?2uvi1lC5KalIdvNUVhQPKiyd/94+Fbytdav0wzB90uPcBolvSw+GGnTW7L2W?=
 =?us-ascii?Q?w0FIsGp33VT88NEXCBYzDoLIAWAFyeHvjzOtsIpjkMQfkaaXE+oZDVkEfaz5?=
 =?us-ascii?Q?mqLJcCwoxCxB3S2m6icLixqn4FxmD3O4GYyo6rcW+K9/XVn79cNmsNWPJJex?=
 =?us-ascii?Q?s8DzTB8XlAIMDSICelfjU61wHEf3vJ+OERV6hon+ATGVttijAmGsMy2P9WhS?=
 =?us-ascii?Q?q4rB6Lrhr76y8gTP5b5Nr0fwi8SAvIb32+JbkNdU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 990a937c-fa9c-486f-3b77-08db31781019
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:39:54.0544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZfIFr7znVQ1jiDNYPYBC4rpUJP7JZsOvwg0KNgjQiQnX7LMr1ovz/uCNeq6v5M5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7458
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:34:51AM -0700, Yi Liu wrote:
> This prepares to add another method for hot reset. The major hot reset logic
> are moved to vfio_pci_ioctl_pci_hot_reset_groups().
> 
> No functional change is intended.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 56 +++++++++++++++++++-------------
>  1 file changed, 33 insertions(+), 23 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
