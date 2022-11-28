Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5351763B325
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 21:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbiK1U2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 15:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbiK1U2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 15:28:32 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2052.outbound.protection.outlook.com [40.107.212.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62032BB14
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 12:28:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9Rvue25r1sJHW5Xnaqha+/pk11HNSWKUfQqdiBUdXwh423I1bOWpjAJz9vvirPH/ktUk3ovyGMk+XQc/Z+WJTb9lY3zKJY7qORAFkrI2izIYKGiDfvvrNk9+D54jNj5cgg0rLsnbo2+hagqL6/iwZ+ICcKRkLgiVTvTJts1E2IVQg3kpdRJKJ9vsk1qVkmC9qAis44ZlbF3Ni4o5B+FbhbOxc3+l+CFf6FShzXmylc+pPim6ETxIPuRxPrvuR3O8uFx8v6X6O3GQZauSBd5pamJJVKkOXJJtzkOCthWmWtj1gtO15es92k+6JhoOdm65OTgq7J0HlgHNPNdQLCOUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tFst2IVHgPJXCqj2RFnEjp5ZMxXLENvvBK0mDulqBk=;
 b=dd1w+r4G/bx9rQHp7o+HlLtYagklYWkUWXLfBRD/hCWFtrFT+zHRs0owg3IJb9kLhfUdmWI4RddYb0Pkyw3wHpDGnG1ysKi+NkNCCPRGv8Qm1ecSzLzm22Ivn4jsY0vyRUh8b4AYS72VFctJqOPownOIDMEPrHOPNz7dP9M3KZzoivVf3G8SFZNWxN2r5O+qiZo9DbdZJv65/ncbhqbDDFOrBmN5ZxFLBpm7aOyYgCtiABqKH+8P4zlTGNFpdd7AM91QvfszOerVD39RIVN4EkEL4EIG8ehI05gS87GuWzsg2EFSekzhF5IW0a/PDqFk9ZFGKBOnviEtwG3GqG9t/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tFst2IVHgPJXCqj2RFnEjp5ZMxXLENvvBK0mDulqBk=;
 b=upL3fwLp2yiN8RBO/Onc+I/wJBCN9MLNSHG5iWkDlM3GdyFxgm14fGrnjzQVuShkzUqkLEAtXqY0+9eIH8iuWmRjjRw2IOj+1nDl/k5S8A6JpUuvIOP5KTifP6dDYA5oCAPZcDGHn2s118DZQK/TkgLpm+ulZf2thnErQfQ3AkY7SvKexL71EXI8M6Lq8PFrH/ZHEFBKRB5Vj7f11RqP8iesRPbj9HvDPTQ0HuPWk5QDwbDuay7nn4eIvn0w68OrbQty/ArKZ5DyFDXTNDWDW/7LAGWG4CVqkNsqsCdGPFo9Vx9PoXVbitpaj0ZQiIP0KrAu78B2KKjdZpWj9GLGMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6462.namprd12.prod.outlook.com (2603:10b6:8:c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 20:28:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 20:28:28 +0000
Date:   Mon, 28 Nov 2022 16:28:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Subject: Re: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and
 trigger irq disable
Message-ID: <Y4UZ6rlEIHGzP6pB@nvidia.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-3-yi.l.liu@intel.com>
 <BN9PR11MB5276E07F9CB1A006FAC9E4098C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y39qrCtw0d0dfbLt@nvidia.com>
 <eb75c2bc-8142-116d-6b03-7a79bf7aef77@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb75c2bc-8142-116d-6b03-7a79bf7aef77@linux.ibm.com>
X-ClientProxiedBy: MN2PR18CA0019.namprd18.prod.outlook.com
 (2603:10b6:208:23c::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6462:EE_
X-MS-Office365-Filtering-Correlation-Id: f3eb87c7-a66a-4462-35d6-08dad17f1ba7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wTO43gmEvwXwTun+etjrg1UI4Ix+AxKpSFTBGWcALoQainRIOmJFGkYovPNAEh/3P5q/LGmi0ddwC7ein8zGqJltdoessd91Y0ZFT6rnJoiTnFVyLgiWR5LLyobK0UjmPRSQl6WNAfUg8mjWBA9nKEaawjO0bRqiwzgU6zuKB/GQXEjKAe/ktzBW3prdR69ck2HMUcUSyR1mYUiJs7AbFPtXpETGqqNLMUxnVNyPOGkqHV1aCFNvq6QLCMUvwnavbxZ0Dk8vWIchR+CRatk71a5bQ7Zo0ZQ6SVf5XCzoRKOOMgVPcg5XFJtdiEYw7elGVdpaSwALilnXwqZwUvINctKRwCmuLpgnjHtQcAK3lUgqyF+E5n7fEiRKICgksfP5vJtiBzh0uCrKsWMZysQ7YaW8wMCriTXd0yF/M+dBJrIydOnpFn5ehHhMkmUkit05LYRFzqUi+tQCww8z3ZscEraD5i8vVqZOtQo+co2SwkJ7rQ2SwwOxJ7E6blQEvN16rn84DHJhBOsaPVJqzX4QQ2ry+yNZPytcU/qAlul/K1jyuJQn8ae4BdNKeWao1/ceksUa0HGhLYPgs/LAb8HMlPQrZ/5vGjjy4FuSUrBw2M0HZH+5di2jW+XPr2S6y04vOouAQqEgQJg57xtIvqNW7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(15650500001)(38100700002)(6486002)(66476007)(66946007)(66556008)(41300700001)(478600001)(36756003)(8676002)(4326008)(6916009)(54906003)(316002)(2906002)(7416002)(5660300002)(4744005)(86362001)(8936002)(2616005)(83380400001)(186003)(6512007)(26005)(6506007)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tFDca6gH/NrrideR7J91V4Dff0NicweoQ7WyKfQAztf5TiE7Hm3lq0IoLwaf?=
 =?us-ascii?Q?EBW30N4XLCeAiD0QrEylrY6bBMAtYSdErN327OvZqwioNA3tBLUvFsOnvDcm?=
 =?us-ascii?Q?QjgmDEmTbmXfE4KIAmLvv2HpYvKt6DGZ4nTDgBdPVQ5EiQtQqXn0bwr2FmxM?=
 =?us-ascii?Q?umdxCQCseYKdGXDuVCP+ku6aCSb2uWkdKtwnTrjDLUdtLxrZEbc9Wlf/LiWx?=
 =?us-ascii?Q?QWSON7HX9J9zJI7IgLgcIR8sQDghxruETj5HDZ7a2QTzEZzWwyfB3kzjPl9Y?=
 =?us-ascii?Q?Gj04pil+djZ341O4OxIp4HuFKXkFs4U1/+HFW4akT15TbRI7Qfc6ARCglVAM?=
 =?us-ascii?Q?Kz20NW5tOqDfKFfxz0WrISPAYFMt1gNxsuNj8tbRJxtBzR2IjE4NdxBm94Ie?=
 =?us-ascii?Q?xHumQ9M+zYvK2Gao77aykhyy1VRWsy/x8QjHyLUb1wXizOfSMYEZoTuKWBEu?=
 =?us-ascii?Q?ePnvELwQt5uNx5/RITSd5A6KGPffSqaQ/fOZ8Yl1WxkTlyg25BagG4zOHx7U?=
 =?us-ascii?Q?ueQeVQste5JmhHculYxu9R+KC4o4UK6ve5BLIRJqfDlpzo0bc5lSnyMmdzv1?=
 =?us-ascii?Q?shZzpk+fqLwDgHwPJsUyjqZsFH1Sz+huJpJEcxprQFwDYr7G1JZ0zHsVevUp?=
 =?us-ascii?Q?gZG+3z6sSQaHdJimTLyFO4dMbq6mjEVjroiCW0PkxcognVhltZCG5cEINCo+?=
 =?us-ascii?Q?hdLP0IYAtWOJhVfxQIQXhvjamQQy5qg1jokVd/+0aNss52+yknTRJcvM7wpq?=
 =?us-ascii?Q?aehXbbftfNG8qii0gdpJjvgJ/ZR4zrqFZSt4HLSG+1smMtuR+9o+lbkCG3d6?=
 =?us-ascii?Q?/X7bBBLUn4sJ3/inYxGJ0QPI851IY6BkR6AlhTBly7tWmRfd3X23KJv5Yl/R?=
 =?us-ascii?Q?ZrHhqFNFSxvZT3gbU3K4QdH8f0eHL0ewM0+CdxNePNNMZLfh4KftlsrH/JGw?=
 =?us-ascii?Q?MWCIuWKgg3dBOBrCEP1zz8EACTsXgguYgk3d5wcO7ns4Zkt/xzGwOWMuNzN7?=
 =?us-ascii?Q?djgfGFKs1a1AfKpbZYgW0h1p+xqMZEueRjP3qaNDXMYUf0JK3z0nJ9/aCZwe?=
 =?us-ascii?Q?v1JKWombWxeRS3uHdEt6qiMF7jWtz0azIPS0YzFlSYfijF8QzGbu5hQyUV7Q?=
 =?us-ascii?Q?/H9UvXeSiWkx5jrzJd2kpQ6+16hiN8KDv/g4XG4M/CIrsSeaVuUvg8smuRNc?=
 =?us-ascii?Q?1meK0ArZ+naNzpG2x402F7BH2xWRshwdQyDKnWzUD33xVovV3N1e8NdijZVP?=
 =?us-ascii?Q?G+chZvUwsAIYYOt5iaUTFOMn6ycDNo10wcjL6w+lCnX+YgXOO/xC9RyJ/DIL?=
 =?us-ascii?Q?3c/3ut9b9tYS7upjRUPqJQQ3o4M2jjN1b0/xQ0u/Kma2mt0mXd+nQzA1UnOu?=
 =?us-ascii?Q?n1zkmJHDnFn+Y/uby2FrktT0bx7dRXNiKXsfrzeHEkHYCfpCKfX2bEdEPIfR?=
 =?us-ascii?Q?CtFOwKC91RrZ1mMRe8GLLhlNed278jG3lDey4NrOkzmd5rDTdBTJz2iFBGT8?=
 =?us-ascii?Q?heqto4kMS3gwGIo7wp3/eCa169hoaRL8xmI121BIBBPDoNB8fGnpDHNtJq7B?=
 =?us-ascii?Q?L20W+7iCVWeFZAeWpd0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3eb87c7-a66a-4462-35d6-08dad17f1ba7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 20:28:28.3541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M37uDNdZhCAd2K1cZULKkb8AuRjRGR6QeJ63d3jWwcxWvNrS9VmNo7jhZaSNo9/h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6462
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 10:40:48AM -0500, Matthew Rosato wrote:
> On 11/24/22 7:59 AM, Jason Gunthorpe wrote:
> > The iova and length are the range being invalidated, the driver has no
> > control over them and length is probably multiple pages.
> > 
> > But this test doesn't look right?
> > 
> >    if (iova > q->saved_iova && q->saved_iova < iova + length)> 
> > Since the page was pinned we can assume iova and length are already
> > PAGE_SIZE aligned.
> 
> Yeah, I think that would be fine with a minor tweak to pick up q->saved_iova at the very start of the iova range:
> 
>    if (iova >= q->saved_iova && q->saved_iova < iova + length)
> 

Yi can you update and repost this please?

I don't know if we will get a rc8, but we must be prepared with a
final branch by Friday in case not.

Thanks,
Jason
