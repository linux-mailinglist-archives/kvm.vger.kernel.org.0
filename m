Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD735FA364
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 20:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJJSch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 14:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiJJSce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 14:32:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A29E7675E
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 11:32:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKJfYBUEy5G3QNgn/lbsD9F7EboM4j+6Yt4KxrDTZuyHPn3qylBf8gxiKbeokGTsRKnPeLWmAH3QjH8AiEBnpBhRppmz77g9JicS6/qPTKtpLnoTCv3vEUiV+VQ4Ve029AowHplrv3G96K0rNYUPU7ADcj0POVtlxE49okxFUtLQOLwEFVf2YjhWx64HI33mczt9+8DSKStBjr6vrgcsyRJIlqkQNKC6jQnRdYFcHLZ+drYMSItk+6/kdOVrVIeBVCgp2jjpPCVVZo0Db9km9pPoO8VmEzgaQFIjjns/zhGqdc+UwDSshPS63sIfrctnTURjQDuxRMkH3HLBmf2dig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdSvloMInp2kCFtO7C37yCjBkgIBulLKU0PWOCQO/Ks=;
 b=c9j4zGg1zWZBijU2DUshbFBUfxx5CTldGfL+3CNeZU2L9e8wws4imQEYSjQ/FcwI+e97U/8AROD3x7DesHxANZT2WAvH6qLQEks2cpQhXelwPFUSlOHG2aFIRtIMQTB0yKrvI9RKQoH7DZQAhmJfGpatVZrkmbELtJqGs+By21VnMyucMwL9SZ3IhJwMXX5Dfta+NM0ddzU5wDid2zOYI9os2bxMXkePL/KPEtpVDPhfMguRSO367jS6AXjI3CoXVGAB0VISpAQeeJ4Ng3HKZ7tpWMx7U7WcBRpmnMJDdLz5Fa5+fdH2J/0Zf83R0oyORm+yhcUR+lS9bcgOJJ9NGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdSvloMInp2kCFtO7C37yCjBkgIBulLKU0PWOCQO/Ks=;
 b=JyPTU5Wza6YYo6dKHFwwWsEj+gh39zRkOvtHCr7MFi2Mb928gB5iOePghD8bmkWQ7bYepFAwoJO0XFrV3kjmCa2dchFqVYg16uQQ7BT0C2E/rt9bO4taAWMUzVmlqks+LoP9IpzoIAQGA02Ic1IWqWHghM7ubGXof9hUGA+eB0fOmwtYyPt2hF8W5A8Drl2gRQe1HbTQ+gcpQrQHHwPtPCKbUKoViTK5lLGD+i79hQy049bV4fNjNrUaP9vdrahdxJUbIARBfgfEInYGfrzGZ4JhFw1KqwmX7qP8HdazzjDJBpiVq3UlSSEoj8xQd4psRglmbyW0uk4FhrF3zpEzbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4905.namprd12.prod.outlook.com (2603:10b6:610:64::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 10 Oct
 2022 18:32:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Mon, 10 Oct 2022
 18:32:31 +0000
Date:   Mon, 10 Oct 2022 15:32:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/4] vfio/pci: Move all the SPAPR PCI specific logic
 to vfio_pci_core.ko
Message-ID: <Y0RlPnLAoZgPd8u9@nvidia.com>
References: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <1-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <Y0PEo+K+Q7fkcMcB@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0PEo+K+Q7fkcMcB@infradead.org>
X-ClientProxiedBy: BLAPR03CA0132.namprd03.prod.outlook.com
 (2603:10b6:208:32e::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4905:EE_
X-MS-Office365-Filtering-Correlation-Id: b4dc7b51-0385-4f9d-2095-08daaaedca8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xNtcSfl2AgPmT9ZOiKImWeFyUdLMW+k1UntPe10BWWY8nxa1Ik4HNftav7RUbpZ8SIJ4TQDXzWh/fwan01ooVw1oaTjckbQSDpjKkeNb1WotH4dzc6YTIvnPOU13EXlKcEmJQh+0ph75K78IIUlZajgqFCYsUOfdQ74LlAbgafs10TH7gGEXbitGS2ftrxjNQxuo1EjLJHVzpF9aEW+go3tKkPHekVb9ReRW+IxnrjTCJI6Vz8UHh6ZM5dD8g6cNSJYhP9QW239WpT/OIc9fC/NzrhH07R8x6ASrOKilcz8KS0G8k6VWBNew9dvY0cCDKxCyKRScls4DdZL73RyBIvOBm8qLTHLcHeY9pDF+82ZhdldBJuWQGjXmIUJig5FdnmtLkW4ohz62ckFnvszXHiPbNF2beXDuActosgDabs0ABAKt0OcmZqQku+/5L0E4mcBs8eL4s8/Jsrig7YElxXCTwE07NPdXcUkLKTW2HLQGlpsxYAVctI7qSFoVX6fr7pYAyqCeI5+DKHFNLqrhegs/MzD1RmNyoL+fdEfhSq9XjNe11Rmk9nFUkpMsuSwkqg0TySp1fcR4hhsuGOK/ZxXjVke2D2/af/UuVjcpJqEjkzqOJq+1+Jzgct8sEKl/2acN4OB3v/5Pk2JFmw0PhwwE5zNwJZdQW+HkY3VhKlYTOT5xmM54juiloF3XGIy6+KIjIGj7rbGnXGo3t/nIgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(451199015)(36756003)(6512007)(186003)(86362001)(41300700001)(2906002)(66556008)(4326008)(8676002)(2616005)(66476007)(5660300002)(66946007)(6506007)(478600001)(38100700002)(54906003)(6916009)(4744005)(26005)(316002)(8936002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AKvARMV5WI/HCsQybePB4o96csAG6WMhM0TFaHnar/HseC+fnVHyeU/m95wT?=
 =?us-ascii?Q?JZuWfdDWFV8jn3nm0R4jWk8jjMIw+VSQzFF7PQH+fd573IZBVYgIIhMwvFnQ?=
 =?us-ascii?Q?NLlUNifvC+YEjFwBN0rTUJhyDUVkTIZAlfnoyaIoEJGy/3ZBtaPXBGjdNWj6?=
 =?us-ascii?Q?lyyw9nPWfV8NvMgbnkGiT958XMZ35rPzzejSBt7ORMzlNyXmCNgedHco9QDP?=
 =?us-ascii?Q?aQU1EtaR2G2TyClJjZcL4oPcBkpPa7bJB44LThpfbZROq4j2ulraiqPRobJu?=
 =?us-ascii?Q?koZF8aC4vUX76FJBTfELMRjQxgYEi7CIyxnPPUkA0Bsrn43Xtb1DFkUvnN4R?=
 =?us-ascii?Q?uG6pNmvdz732jBhRAeBXqfiOvadCUMP3SGYbYfq1tizDXPNlvTJ+xJs7I7S8?=
 =?us-ascii?Q?/HdbF0g8gH/C/PB3ZHQmRotcxz1zlmSDzFvOrODGxk4TbWBtuyd9tUwC4Xbw?=
 =?us-ascii?Q?gug69q3L5vdtBUvF5JwaW5GT65jRHU17N20iDuBQiblTax3AIXZB93LmHz73?=
 =?us-ascii?Q?0vxeekMnAW0OsjUfoZErN5FAP4xY2s8gEYcXHJ1YfwEzub1txH7RGcT0YPnV?=
 =?us-ascii?Q?vnGn1jtpW63AoVqMo0kmnUV5iIk4Z2WhG9MtzgA8ASwsEQIfNVHZteHUQIz0?=
 =?us-ascii?Q?Cs4v9EaC9QDXKBiNAR2sMMsGvUKhpzTWKATA5QfxPcH/Fw5q/kcDaPdqhqrT?=
 =?us-ascii?Q?sO4t7/sXI9AsU+l/+3K6tmNJl8au/h13M3MY3mYCIMNyBYbnR6UM2phqKWw4?=
 =?us-ascii?Q?Q5KO09TTq2gjYDp+2i/EXP+2hxChdp5344KCaCx5NEQfEMFrmjFsnRjc6bJU?=
 =?us-ascii?Q?QVrNSjd6CGUJOsUCdlB7soKt9kffhVGf54mPQaC60LC+lnWq8s+wH40OjkkE?=
 =?us-ascii?Q?e28lCgff6VI4zPZ8yTPYVCtHX8jUeiqI0AMaOkyNYbhM46Aai2wXBCaZHI0K?=
 =?us-ascii?Q?CLREBRe71ZX3Z+mkvdx5fUXQHfVJd0zzlYXtr42n18iR1UXGHJQElSDveH45?=
 =?us-ascii?Q?NNt8Tkq1FFuoSvBoEx8f0/gIJHyvkzzTd8lLAr+DvVQy4Alk+DzHMjzK2HQa?=
 =?us-ascii?Q?fZtMDGg2zyG6IQLPbmdpfARvm8HDjAe5kaU4uleO7b7O7umgbZzimYizrmpo?=
 =?us-ascii?Q?OcJ85alDEHLaP2OQS4xv1N2KRS7yMCInzC3UbHa5ljGckaUKgmbWNqbYsw8H?=
 =?us-ascii?Q?5TECQXjEXmHyxXh6NwxghCND/NK4gY544DUTvoQOVxjQJ6IeQ0P6ZmAnj+WR?=
 =?us-ascii?Q?uY9vE2IrW9K88n5i+bcZSdVPKayFDipD8h0CCkzB1o+DKreewL9GRL9oDMbH?=
 =?us-ascii?Q?oKqa433cRPww243P7WU0F25F1QukrT8KhGpPwAxxfKVQem/sdVvF+rLsQ48V?=
 =?us-ascii?Q?cnUeWOA8ps+TpqPazrzuSR/QEfI3+1gbVBrifswfoQGa8UrkUQHUz59nE9li?=
 =?us-ascii?Q?fDHwx84SSuWXsQwMgA++Nmrmy6L+irjVoB/cjkBzTKfIGKDwmAcTuNTWgUVp?=
 =?us-ascii?Q?2q/bWjPJAN8r4QbTvXgH962P0VhbqcvUhQX7FQEr3AVAmACSeUuOuHTUYQ1l?=
 =?us-ascii?Q?9dYB00PQSHiHRr+e/7E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4dc7b51-0385-4f9d-2095-08daaaedca8b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 18:32:30.9995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7iF8VR2PVWIWZhqTg43DcJAmqEu02D/TZb0nnreNWj8IKutlqQHOq7HDcufar8H9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4905
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 12:07:15AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 03, 2022 at 12:39:30PM -0300, Jason Gunthorpe wrote:
> > The vfio_spapr_pci_eeh_open/release() functions are one line wrappers
> > around an arch function. Just make them static inline and move them into
> > vfio_pci_priv.h.
> 
> Please just kill them entirely - the vfio spapr code depends on EEH
> anyway.  In fact I have an old patch to do that floating around
> somewhere, but it's probably less work to just recreate it.

How do you mean? You want to put the #ifdef in the vfio_pci_core.c at
the only call site?

Jason
