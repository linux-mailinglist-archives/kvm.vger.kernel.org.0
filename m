Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534B97A893B
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 18:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbjITQEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 12:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbjITQEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 12:04:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C41CB9;
        Wed, 20 Sep 2023 09:04:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIARuCGABWNvxkVyGd+1ksy9c3PZc4EcSO3HPOAozDYUwjJpxHJSmzs4RswmHRLpHnSw/e5DGRBhuQD15eHaqkDE10gGk1gTkpgt2Ge88gSv9EEh6mqIee4XpWGpMIwgZ06msv6aUEo2x/nN77fsgOfOXBKdJm9dqbSvTPSaeYquvUcFRlY4jZC2mAESJF8Alh4NB8cxKn1RZaEC1oBuRjSmumRAofE1MfB4u23K1wLjsAvsP+TBgxWP8JoXWf1Xxer1MCZ0NK3hFNLqqGqikPA+oK8VqW2NMMq//+rTTpSXU0dAXvVDGFlLQAv/wdA+bnCBxKDn4SnIthPABXr5QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dbHWXoGiEvc70TXCCHmYfomlEXfG+J/7xwnBUkptj2U=;
 b=eOcU/L3raPW8B84Xt2gPdgEQd6HDijM5J24Kag7C7iFk2ZxRpTZg2c0tzJf2xXG31Ry7xbefwOpAhcMafebeOQ3XJCJbZOUnAR544cXudh7YDGkKrrzJ+17Ea1QOm2rF31Q5uT7MjRohXzq8zERAiurRejkl7GgiAJo/GkjzCqFXicakYjV500/7TU0sW0I3RGRI8iFuKSvKvHQLw4dYelbJhaXn/9fvT1rF8AEIjPErLwV7T+iwocqXtGG6bp6HH4SagOCivpJu/Twv9Wjoq/8lGMNS1+GFZDqHxyi8+9rkF3oMexjCTyqabojCG5Zm/HfgSZzQSppsvpb1lG3nlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dbHWXoGiEvc70TXCCHmYfomlEXfG+J/7xwnBUkptj2U=;
 b=bngCi2gtrxiikIrBTT521jlVVSH39LEK/1B/bNIeCJj2tXeNNBtXequHopEj0e/jGU+xBwCKyg9ntKVTxuLcrRDT5i8byG9ZE61x07rLkJYRs9KW8XSD2ZiHD7FVS3c2p7oDpG37YTKsn4Jdn6mZC4QUOiScfG/HEhJ2fCsb28Pnl5BdxH5TZCvCXvMAgqTtNaB8I+MFtyNF0xmj6g3F9Hsmab4OfAZKh+ItcxjZ4z1Vs7tsNNFyBNnVaAiGVtxxCb+hn6hk9oKhO89EQUmAR2X9c8CgYavIrV6OSQ8KdOlQ2c7OZNlxLuKtpD8+779yahUGfI62xiYJ5Zw0Y/ofkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6534.namprd12.prod.outlook.com (2603:10b6:8:c1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Wed, 20 Sep
 2023 16:04:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 16:04:25 +0000
Date:   Wed, 20 Sep 2023 13:04:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     ankita@nvidia.com, alex.williamson@redhat.com, tony.luck@intel.com,
        bp@alien8.de, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        anuaggarwal@nvidia.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-edac@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 0/4] mm: Implement ECC handling for pfn with no struct
 page
Message-ID: <20230920160424.GD13733@nvidia.com>
References: <20230920140210.12663-1-ankita@nvidia.com>
 <20230920090222.580f2b3ca43f21f752c10e0a@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920090222.580f2b3ca43f21f752c10e0a@linux-foundation.org>
X-ClientProxiedBy: YT3PR01CA0009.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 29c043b6-a8e2-4996-f407-08dbb9f342e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oxost35uNTEuHw4fR60NSN3i9CLNMcgyPfGUtqf8odI3YR2R0gJ/QS4FcvPHZquXBkqCbEwmik8/yDlktAyFtniz0DhtOIVG8P2suMh3ZwzFtNpu26FwfPiNfEAtZRtyMDy0IhGOc9pOEINpUv4MJTdzU2rmoVDTCNEypOcVPYER51aNQ966ghPMZL/t6MzYI6QEWDVRY7+xD38Bs3DAryOQLOvYG3wcEeQYesuI/dt2IcKbUnO2cdynaaWfuNDS01ngiuR3E8zNqGiTO4tFNQ/g2W2Yh5gwKEsrmdMjVucAfuS+vPZkB5TSIf7Ls8E4b0VpRbtFL6NUhnBLv/thBeGDMold5Igu4V4cTwwuKAR5wNrXHqKG2mrvr6JpHICvchkd1qh1ifdwfAmTGRhWV6yCZ1n5zvCCXfiyKvDN2w+1ahAUfky8499WREG0B7mVTJrEgORGtOcJsE+LJywMdeAzKPUYSQSR2qiQ2vF87g6k64m6Y4egPFnI/pJXut4qWlbGypJOIi7iMWcJk8u7sFMYO02d4Mqj1etcxqq7ifXhAd9eOMwVakPK7C8CB0yN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(346002)(376002)(39860400002)(186009)(1800799009)(451199024)(316002)(6916009)(66556008)(66946007)(86362001)(66476007)(33656002)(4744005)(38100700002)(2906002)(41300700001)(36756003)(7416002)(5660300002)(478600001)(6506007)(6486002)(6512007)(4326008)(8936002)(8676002)(1076003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/V1RtyOCfrl0II6mlFjL/kQc81jyuodS9JTh0RBiWNOSMfaI30qwZNM9iliH?=
 =?us-ascii?Q?uJLsWdvpBcjo4qpgb9DtfKqw0lKWLceqKPd3pubRv2ZC/Acfb1GpvdYotXBJ?=
 =?us-ascii?Q?autLCvhs+VCQ6WYYA+D5iBTe0g5Kcbjqmz5RkGNnU2ngJVQhIoRc9RFdl4Bs?=
 =?us-ascii?Q?KdFIcQKkk8OtaPcSCDrjRaI6WL6b2hA/rfqxPSC+MovAjUKCzqlp/NpfdTwM?=
 =?us-ascii?Q?CP1cky0/KqPBsQSDETwDWzQbhAats9cxAyqkHriA/shKxUAkKduo58o7Br/Y?=
 =?us-ascii?Q?99gaZKfEQZOJqIeSVMrYLxFdL6CjyT3GCRAtPbtPX6PgWBvUrI+MfrLdVwVu?=
 =?us-ascii?Q?rTwHFcln57CQTXNIe7XikObI6nlXl1+VdPaPXzlT01CSePn8SpFWujAE56w1?=
 =?us-ascii?Q?Av5bZ0q3VJpbKG39GyZyatJfDNHSaKNrV6IMrwrLsT9rNIbKoSVqkb6Y6Y+2?=
 =?us-ascii?Q?EskyVD5cR/UhAqGfWo9PVNAfuUJtGC3mnLDNYC7hPf6FeDQB6U2JV0u6BXtP?=
 =?us-ascii?Q?z8YKC7n2+XSy1RIDMPRh7y1UIFfXAA3iHUoVSZPleO5zHaxYiLNe7xFFHcCt?=
 =?us-ascii?Q?z5H2B7ezuIGMJby7B6GRQrY6zPUMF60C4hrrJ+yUwddYvwVO7bFFl4MyiEC8?=
 =?us-ascii?Q?mtT7If+MWYGdEG0Fo7K3sq34ujNEpz2gzJFy73qsI4difaFk3C3QNfer+VWP?=
 =?us-ascii?Q?7iChbh+/NWAYYcHnnAYUMWNAu0cOyCg9+FhmbmlIWR2v9TvMpx7knLoned9i?=
 =?us-ascii?Q?AlfR5GV9X1AGXvDUzbkQiQwa1hIht8JZQWQrtO0Fhj8IEiqCrmUBLAvZvlqU?=
 =?us-ascii?Q?VT5+sPa5X+B81YsXn5LhO/Gy6+OEHnCd2JzoVnuutnzmFGdYviCnGEcLQPuq?=
 =?us-ascii?Q?KnLjpZedrD4Jq1PemaQdYWpEMdiktuwNXkeOrvXLxK/MdpIvn+Xc8MekZfpE?=
 =?us-ascii?Q?l8k+B6cPzUZXSdhh6ArVgDt2kACejMTzVkyY6baWVlLu5Qi8Z5lsBr1CZ6ty?=
 =?us-ascii?Q?ttPdbP3is3hkT8kiyds7BwssdbC100OYdZnFxNFUVsHiGvkvXVHezyGwWkb2?=
 =?us-ascii?Q?AltR/VYe6Pou5UKkD0ppuioe5tH4YIkMUK5IqvHZoD6zBrtuBuKT6LlDPWom?=
 =?us-ascii?Q?7eXdqV8Q5cEvSmRsvXnckKQs2cSK74U8499d6ws9vcxElXRnyhSI4V8PU2/L?=
 =?us-ascii?Q?4iYCFPLmfB170CoBp0qGgsCxQEq/4zsy9x+sWAhExKJ+saHyYLsfL16DqAnw?=
 =?us-ascii?Q?BDsLNKgrlP/tcnoEOvK+3l4mzSGA0MgGaQpKPuMNKN+6HsRYR+V5GczzdUKS?=
 =?us-ascii?Q?YCt2+kf0Idh+VNWfWs64lgkN6w8wHUBHj++zbFNHaEJCA4mCm6/FcdJPISVd?=
 =?us-ascii?Q?uQBhtZHv1q3OphZjqy9XDLsGcY8pzCps2emghO/CwaP9Y3g0rozS19hJT1T+?=
 =?us-ascii?Q?ndkTT+aRja8TLMFraE2WjtzORf0XVDdT9pRzoiXq2tHD6psGnPUvEcurLA/q?=
 =?us-ascii?Q?S6RUk7aVryz9iGzJ5no7brhg6BomtCcon9cSaZdRhX8n6JNCU+wpy0CHiHal?=
 =?us-ascii?Q?a6td3SOwC1rWUtLz7xf4SRnxfFdhM5HQ39VLyY2O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c043b6-a8e2-4996-f407-08dbb9f342e0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 16:04:25.5152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDO0GrdqwbPOhGA8myyDqRsuPyUnpQp5B824jo41gEvUIlUx0zwOrOUOE1DpZ0N8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6534
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 20, 2023 at 09:02:22AM -0700, Andrew Morton wrote:
> On Wed, 20 Sep 2023 19:32:06 +0530 <ankita@nvidia.com> wrote:
> 
> > The kernel MM currently handles ECC errors / poison only on memory page
> > backed by struct page. As part of [1], the nvgrace-gpu-vfio-pci module
> > maps the device memory to user VA (Qemu) using remap_pfn_range without
> > being added to the kernel. These pages are not backed by struct page.
> 
> Are you able to identify any other drivers which can (or will) use
> this?  Or is it likely that this feature will only ever be for
> nvgrace-gpu-vfio-pci?

I think a future vfio-cxl will have a similar desire at least.

Jason
