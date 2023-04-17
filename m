Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352F56E4958
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 15:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjDQNGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 09:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjDQNG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 09:06:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DAAD323;
        Mon, 17 Apr 2023 06:03:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyUmeSY44fxZbHkqbpsv/Ybt1xZlTmF6MfW4Ff7vlz44bTKkG+ZuU0pFhodNn9cxGg72tpEYaNGvITmw6pygH0GC96xsXMxfQOl4tUf8GFxqQ1pGac6KCEB/ymSN3qUBocdc5+pG/eqxKIXhTA1bF3k+VuY7nC7exghWat0+4wLzeOgJYc/6zp94mXC5DzH/PSDpRpIlq0C/Z1CtqeErKrQ9MuVBZH2XZdV6qpTJtl2A9dp4o3kASQNHJ/6/VyL+VT8njEt8PsQliGymTpS5RrLqVBZW/25XIq03IkIgp938rdc34f7rFaQBlUtpKj8wtx0Jo1vFQA9RsZMXkYY+1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lWwwU/3x8enH6ahSkGWEZg6IWwVQZIct382vE1T1SSs=;
 b=JPt8tUuCFFsKS4I/3mv2nG5WioHVfpv+6EePi0eu4UshjEtQYCH4JcuJ6JGKCs6Y+pVF6tvZLSzw/CPpDtObrdmCcEw799bmNpMQTUegyOC+egqlzJIcKlaJERUxeh6FjNNolb9GPeRnQrPPkRhXnf3o2MjfwBYbeZMyrwjSBjBGQi1wkzt1hn6EP2qzC2DBXoXOJu/+YET2fmWWld77YVyS/13C3CEb60WHYb9fjnV8KAcFXbg2UrlEOzQsbVV0/aJDDh5ZBFdRQNts+uqYNajbK73MaXfElaLs+9XyPbRoDSh+Fbd4+Lu+nC7pWsmsSqrrtRgFltpn/niZtoStdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWwwU/3x8enH6ahSkGWEZg6IWwVQZIct382vE1T1SSs=;
 b=AJ/4Fjb70etdc6snlRsz3qdodfbg2ltpTDt0TTy8iJLKusGqY1H9wxLF4g7JEUrbQ2Hn/vDvwi8trzGSGiWZETNnEuy+TIYEUIEzQGYYJ4OiDdstVOYzJALSKvO7saKhstxvv19f+IgS5Tyf/lf29kkjCU33MDkwhcSdmgndgRfCKUHUYpnz+HwFMCmH4khhzt+Q/wuSrPXyUlgrE1fKrdsvYPhWkH81d9ZDTihj7juWC2CqF3XlOY2eZHseEsD5X/mJhy6FCVvF5tAupWqxtbKaBOHaQFOJoIx/atTjxuyXDSyP1jXqOCWxN6RWVyOpKLMqqjkfrMT6d/RKJKc9Jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB8008.namprd12.prod.outlook.com (2603:10b6:510:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 13:02:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 13:02:28 +0000
Date:   Mon, 17 Apr 2023 10:02:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        iommu@lists.linux.dev, Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 2/7] mm/gup: remove unused vmas parameter from
 pin_user_pages_remote()
Message-ID: <ZD1DYVHIHxkN98PL@nvidia.com>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <c75291e4afe968824b89831cbd341f8b54ce28a4.1681508038.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c75291e4afe968824b89831cbd341f8b54ce28a4.1681508038.git.lstoakes@gmail.com>
X-ClientProxiedBy: YT1PR01CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB8008:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e611d54-5b6d-46ed-7fc7-08db3f43ff58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u5xpN7f/DcO9mqJ52f9PGAWKZ3nirleXhaLPUmYQ9PIlik/la29/T/CRw5hsnUVeXViOHIc0XnfK8CEKXshc92/rfAIIbXikV+15xC69pCbHhSsG8pL8oHQglp68MDDKvh+XDhpmv5YGcs247pQQ1qd/IXY+ADggUHsyeUtxQV6IWTxYJRqp1zDBKdWwQPJgqmM3D8JFdSw6MXNPWBTQz49zPiI3YWLI/9zvONjDbZb+dZTrolceEzYiWhNTI/vutGiFrb6A2WZ2/Inf4zWaBfFGz36eeH492WdvjDDYxiAM11g2bkCZBUPwEEb4zEneUONMl4kHNgOELynSL42IXQqMda/ZWXV6zl6lFteoZTUTRn9Y0WTSWNTs2zc6ZO3H4nQvTFD7gsf9TidieUAzY8Uist9Q4q4KSqKtmbsmfY/fudakajszuOp3CEhu9LK64O3KJ+fZmnAATfNRHChsEnaMiZjUTvkeYnYHKiPR5sySHgtQvvWTSw6g1OCrD4JiB8ZB6eoLFI+6AkVmU1JFcv/ap/4UBacsMGnWTmdX757q2+MglX9Ewx8CoXfd/Tcy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(451199021)(6486002)(6666004)(54906003)(2906002)(4744005)(38100700002)(478600001)(83380400001)(186003)(2616005)(6506007)(26005)(6512007)(4326008)(5660300002)(316002)(7416002)(66556008)(66476007)(6916009)(66946007)(86362001)(41300700001)(36756003)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wtNRhI17rrT3KMyd25Y+ZN340LzmOaKRz6sgbFY1nrsjoiibr4za9gj6tu0O?=
 =?us-ascii?Q?T9rLhdmD68x5l7rW8ks2kRfk26CK0nCI8LT/1SM3HjaAvdtKKVnBf/sNeyh7?=
 =?us-ascii?Q?Scsz0BrCOD5oDh1LneKSi+wu5myXLv8ge3hpiT6Lp7lVxBt3B48wkwd/Puvf?=
 =?us-ascii?Q?fGCuTsIuYC3NQnAtjDVkzBmXsyQbxRTLJVnMaapu1okGks/khRTzJP1HI+iF?=
 =?us-ascii?Q?x2rS26R/3sMotCDR7gqkSUSTHezif+X5tHG4qaPsi5aMxj6x+s/wTzAo8MLw?=
 =?us-ascii?Q?BTH0MbRW3BYLQA7ZUfoxETP4nUfvtAwMSUaBi0bpWNdVtoO8H2P2tlbK885Y?=
 =?us-ascii?Q?kshxfolpa99LiDretiC0i1PlgQomCSHDcr7uuuHwXuL8rTjohn7e5eNbHuSx?=
 =?us-ascii?Q?F5FJGIHf2sMLL4VkFBptxXOrfSQ7Q7Fvi5paQyD7wfwCTKeHqiyczU/pRAsT?=
 =?us-ascii?Q?q3IQDI8D2rimAs6XYO+LT7vO70yVYWDtxjcl9Mo4ZR//pIOyph7kv7engMvt?=
 =?us-ascii?Q?9T1+NVAA2fyIHlsHhz80Tc5UnftIIZsgn6StVg8neUBY8QHueNfMCue1VV1W?=
 =?us-ascii?Q?fQUeAUAjG1ztNXs7ApGVSl72ctr5B4miOVEvsLmnmWHDW48WLsWxoUVMSyoQ?=
 =?us-ascii?Q?jVdaw8DBie3VYkCXQe+9h+QQ+BTXnEjrJir2N4O6uVUWyuJ6F7bW5k9vSqpM?=
 =?us-ascii?Q?BZm6J5DI8D9esCmBfBKAjWiSPkx6qf7mZJu5HAq/raRCDLYZWBmlqgbXsfN8?=
 =?us-ascii?Q?dMsuRNWGIn6dzKz77/oSxyg2XGPyhoKLM6W17UZfu76qUAS1jWc+JQ49TzVo?=
 =?us-ascii?Q?I1r0Guj+hYhB8JuWhzIZzMeFPXS5aQnuYrw63TunjXqkJ3q0K5x0c0Oiq03X?=
 =?us-ascii?Q?KVEd2Yxf3N7etSoUkOSvPJa9cxo2HKTuXCwbvNC96upw9AjwbA9KYH/8Ruy7?=
 =?us-ascii?Q?EtZ6VRkkFhX/1aXUd6uZvLtjASS3/dfBLZb8wRFuyu00Rj3r56P4JILv6Udk?=
 =?us-ascii?Q?s/jMS6eBDR56uuHJhBRnTQqpy4+PkvJI3xqFODRICy2nLG1XFILXLImMioB2?=
 =?us-ascii?Q?XK2v3RhGKmGB/dwKGNOZW5UwiepFDrc2EWUmriJGRr1+Ie/aeYBgA7rg/jT5?=
 =?us-ascii?Q?OD1VDZmBYQcApaTOIHIBOLCvhIS7F1dudsR8aKIcP6wPoho8qTVVJFM2lAVb?=
 =?us-ascii?Q?ro/6YwZxrpx6RclMZFhSb0EKnt5rQc7QqHxJFtoZwbvB2wqHDXWeoWQLm/K3?=
 =?us-ascii?Q?ZvQoZRgwLcVi3pvl8TwX9fO41sYulLbZHlw4nRoc3nyzsmcls60yomPvm3+Z?=
 =?us-ascii?Q?f57nSplwkal+ReUAK+oFQ6/SJGvbRkDmD7OJ0Qg91vzTh1jcGhER0pf69I1R?=
 =?us-ascii?Q?8ROtyshmlaYRH4GvoWqLKsB3J+rcesIRgyfJITvCl/jdzjjeIsDCgujWARf8?=
 =?us-ascii?Q?eFI9Y6JLjDwwvL8OHz/VzD/v/OytgR9WQW7RinkBD2+yGQWemHbAfcMg7tKr?=
 =?us-ascii?Q?LivRP2DLxRZjRBSVzDOAYqdoWJbG9asLT9PUntSsBleBIhHG5t8VzuawOPYw?=
 =?us-ascii?Q?vOVB3b6TtXlP0ylX5joW2oquA3WvxdPC20N+MUMf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e611d54-5b6d-46ed-7fc7-08db3f43ff58
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:02:28.3840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PGITn9l+8+6FmNzcHLUf+e5R1pwmTsoQ2wXL4KndyhffqAgvSD1HOzFncPKjSWOe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 15, 2023 at 12:27:23AM +0100, Lorenzo Stoakes wrote:
> No invocation of pin_user_pages_remote() uses the vmas parameter, so remove
> it. This forms part of a larger patch set eliminating the use of the vmas
> parameters altogether.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  drivers/iommu/iommufd/pages.c   | 4 ++--
>  drivers/vfio/vfio_iommu_type1.c | 2 +-
>  include/linux/mm.h              | 2 +-
>  mm/gup.c                        | 8 +++-----
>  mm/process_vm_access.c          | 2 +-
>  5 files changed, 8 insertions(+), 10 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
