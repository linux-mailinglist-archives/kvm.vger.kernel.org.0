Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E243BC145
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 17:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhGEP6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 11:58:23 -0400
Received: from mail-dm6nam12on2076.outbound.protection.outlook.com ([40.107.243.76]:4931
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230440AbhGEP6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 11:58:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBR7J5qV6qi7/ar+/EByfpEfi1Xi3xJW7PhXfLU07DmxErdnA2uXvMRI6vnB8CZ/vVRzxOS+h7jkOEObWGO4AjjzcI2KP5JTkF7IIqClp04ZzPGOFkfzgpf2aZeTmIr0IYa2GH9KpzfAB1Su31m6pBLpaF7MSdU5u6+lUtZvrYr4gjVaIMlljQXohEOvbuYE4Mslw3au9QwUZCsWzS61YXsWGo9NixfCRnbM0M5uyD+wpq86/UiRU7bTb9nl7BSFvbHOJicq8Y1aTLsdgv8NUmzOibNvS5IrhSm4bSBheCKvwnrnEfOU07Tvgkxbg7E5aCSxl0HXvyhFCrm2GAoUeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LncCPB2o0vt1ECFxJ4wDdgYCaS7KVtUnWxMfZhH9X4=;
 b=d+OlnYSd6D8hUK1cyiRJd5gOp+YGmt0aPj2RViyjh7BCtjCwJq4SdRBdo3Hx11VKNDmbeIEo7J3ZuHq6gXgo4yK2Os/3AjgkuytCkeJkNWHISeSkmHMYHuOaYQ9aYcHe8TIUiqhGrhPbOhY1MkX1yAU74DRj1cYnEtkJlZ72S7GeNAtq3yz/1V9eVh+MsJZ0Z6P8IVVoN9LtMJOiP5ozfTMwazqtY1L+WHjiFlvJUu1NdxZtXBDBn486K4Ire/GgaSEWj++K48HAFDk8huiezdbpqETR5ybtPdsZ/jWk3zC7mzI3CoxaN6kUODdF/jKAUOR9ZKTIrN4QpaFunVpKSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LncCPB2o0vt1ECFxJ4wDdgYCaS7KVtUnWxMfZhH9X4=;
 b=JLiOYON0KKRi1hrNK5B5AeLDwggq+UBwJepGHFDGzi+Tdv0Ginae+XF4MdRIdyJyWgqwn3aj1qEVEC9sLluaqUwZznWicDumi7hIED0MoRMlETXeUrsrR5ncOAT4I2lUhuI7Z0xSYoZJ/8vqlpjdf33XvaFqCwWD5C8Rqbs3mWc9t3h8AJOmIyjbR3BixDfhO3JXkdjkNGAnkQ+9GuMwvgqJ42ZToXAqZKueJhRBlH4Bi4rNWjFlPnRPWZeKt50noL8u0+82JXh3MnUpW9iPyyMTkDJDPMLU/vFDICVKaIlfsiXup/umxmi1MKnVuEBdl3fLFYGhrGRNusfT7x0VAQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Mon, 5 Jul
 2021 15:55:44 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 15:55:44 +0000
Date:   Mon, 5 Jul 2021 12:55:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH v3] vfio/pci: Handle concurrent vma faults
Message-ID: <20210705155543.GP4459@nvidia.com>
References: <162497742783.3883260.3282953006487785034.stgit@omen>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162497742783.3883260.3282953006487785034.stgit@omen>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:208:32a::12) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0097.namprd03.prod.outlook.com (2603:10b6:208:32a::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Mon, 5 Jul 2021 15:55:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m0Qwh-003qp9-IL; Mon, 05 Jul 2021 12:55:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58f31b80-0fac-4c71-9175-08d93fcd58f4
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:
X-Microsoft-Antispam-PRVS: <BL0PR12MB5539734CB111C9A82A32D5D8C21C9@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OPHQENIXgebpITIzAXJRc8eqhCsixOES504Mng+MnODvzny3BWKriYCrLEzsnKO+Rbo8RD3Kpcr0xxpfztAduOx9/aJd7OjurYXUU+i8C8KeanFfR+QsMyevRBacxmHW+7xK1CTlJRJ2dk/04jgpjK1g8px//XQgb/E0+sPvpy7wbgJAu3wJs7KzZVtniPN8va8S+dkklfXnu8RowCofKgyyS8A+bzil9gGEs1zj4kCfkw06m1AQqIuLqkSEf5oDKmyhVQAAW4CceEOGqjgQeNQJnU6obO7kfo6/gpM0wy11Yh7LGQX+UdWkaCBTlWs1oAiBr0ypRXvz5vRXVF6ZnanKfmob0w/013ctypmIAYmx2fNT7MQXPkybXgB5KK+iC/youbQp3vSJ34twJuEOnHv+6wU08mYqAhoSTMBeVJAj601WCpZWKO+XWZUvMVfiCsay1CKoCjGC1XOkj4pTmtJ6eBMtZjheK+xUx2A3pgAF29hl6U0LDE0yF0xrIHFwhVQLuIHWwHYDAMqIrNyrx97DzdfoRIJbVJUmDnJpo6qi9nQJrdseioYUapl0id+B/t3tjXGPRH24qFXFC3Rdz+jYawU2h5JVUrmpiH9KNfpRyY8SQ61J/x/8pOfXFnOzPg62sFxu1blWbFphJHajfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(186003)(8936002)(26005)(478600001)(83380400001)(38100700002)(2616005)(66946007)(66476007)(9746002)(6916009)(9786002)(426003)(33656002)(8676002)(45080400002)(66556008)(2906002)(4326008)(5660300002)(86362001)(1076003)(36756003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Agl2Z6xpR2BIRoyTpNmjOtZddPzMUt6v9wFWnSF42JX5YzOVTTcE02VZ0o0+?=
 =?us-ascii?Q?zCKwxXFTg0jVQJMkCjxueqV3nONWhRoeljPK+Tdlisc5xuEy3KJv5wdA+Wpa?=
 =?us-ascii?Q?piXuXEFLRYN8G1SUNsPoeVKNafubrOj6Vv8Msubgl4aGqFK1dfwL375AAwN3?=
 =?us-ascii?Q?Ul1c1xHrYyrn2fYXjZeM3/m93KHZDtwHSV4vV4GhGLZ0s4E12sjKnQmhxbcW?=
 =?us-ascii?Q?pPgf5+Ojr0VfUzU7OSTPM7ShVYUIdBKFj174A9nnVsYqzHKKovY5pLMq3oPX?=
 =?us-ascii?Q?+XYl6rmiQGwmZ9GwNJN4nrhKsWirUtRc2JIL6yVsizJnVtZIbbD19eMwA5UH?=
 =?us-ascii?Q?KF7Kkm7FfJ/scql+CVefveCSYKCDjVabcafZ8b8Vdee0YHLX5P4v1MmtL6oT?=
 =?us-ascii?Q?sjOglInbdOPy93zrUjJh1dduRdh03lFset2trZs+xu2UNEuMoUbDvjJhrgvC?=
 =?us-ascii?Q?bJ+rhlc4E/6uJu6TvNJonk9wxZYRd9HRW4WlU0SFNea8FJM1RitrNAmZhfAU?=
 =?us-ascii?Q?uWPbIjgLQoidUyRNvBn7w0N5ZfQloFpBlCxr9TGUBROMinag2iskq3Hv9sCa?=
 =?us-ascii?Q?kl4O1kpCF4UPk82X0c/vXRSE0TJ5iF3Y5xJYFO6kwqRnH727OHS8KeAQVpEX?=
 =?us-ascii?Q?XrMcpZgjjaf40DOHcaqvA7Nti2iUaFFETn3r5t3UhaoKn+iMta5A8jDMOn/S?=
 =?us-ascii?Q?f2SHe4SoY7e3+u3DFKGMKo0R7rWwd5llezu2liyEKIDAHbdGRIEUk1i5LGtb?=
 =?us-ascii?Q?eGV3d0l6YPnLr6zGHhqhwY2VVotO++pMQapkwxOi9Mu3c6SEPb9uYjb9pS3x?=
 =?us-ascii?Q?MU9ue+8M6mYg9PXZTTMX71wHHvQ2BSYjA9i+S06ZLLHyxoE3yfpqWJISPovN?=
 =?us-ascii?Q?CsF03OsD8ApWf06mvMQdsLdOCt8mUuf8/aQE47RNCVpizrm877VKlSbg09Q+?=
 =?us-ascii?Q?YDYSsuFpgzwynEU65A+BRqbVkR5btKUM2y3Y1IRA0S9mmsqd1xvx5Y/KwL/m?=
 =?us-ascii?Q?KffUmOf15T+ez2TxDC9ZNaK+U3sTHgbxU7+dgbqZYAmaAybocc9TQlqjuKYM?=
 =?us-ascii?Q?EM2Yc94jFi9HV0ysdUkLC4AS6WQHFae2cQ2ffiwqh4vU13mlJuifFQwgXKV8?=
 =?us-ascii?Q?GFL/vwJ9q63DpT7T/fcdoMIJZusftwfxieI5G5ZshBtgvr9TTTeoFdGIZH2D?=
 =?us-ascii?Q?L038yEzbzxaTysRsvGrVWqMkGk1SbJ2Z55BRAFENG8WjhGQKs8QqwfdHTRRJ?=
 =?us-ascii?Q?cDrBnNJR9WwxGfE4HA8MobnJdRrK8lws6PkZQjXVDgu4NpJNgO510TlpH9DP?=
 =?us-ascii?Q?MWZxnLnN6MWsMb9u+qkhPD4v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f31b80-0fac-4c71-9175-08d93fcd58f4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2021 15:55:44.4168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5uaOOySpcG59iYoTjpX1k8E75yWo7Zpb6CdNEUCVdxZpVBiq+FDR2dC6XsHK89uF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 29, 2021 at 08:37:46AM -0600, Alex Williamson wrote:
> io_remap_pfn_range() will trigger a BUG_ON if it encounters a
> populated pte within the mapping range.  This can occur because we map
> the entire vma on fault and multiple faults can be blocked behind the
> vma_lock.  This leads to traces like the one reported below.
> 
> We can use our vma_list to test whether a given vma is mapped to avoid
> this issue.
> 
> [ 1591.733256] kernel BUG at mm/memory.c:2177!
> [ 1591.739515] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> [ 1591.747381] Modules linked in: vfio_iommu_type1 vfio_pci vfio_virqfd vfio pv680_mii(O)
> [ 1591.760536] CPU: 2 PID: 227 Comm: lcore-worker-2 Tainted: G O 5.11.0-rc3+ #1
> [ 1591.770735] Hardware name:  , BIOS HixxxxFPGA 1P B600 V121-1
> [ 1591.778872] pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
> [ 1591.786134] pc : remap_pfn_range+0x214/0x340
> [ 1591.793564] lr : remap_pfn_range+0x1b8/0x340
> [ 1591.799117] sp : ffff80001068bbd0
> [ 1591.803476] x29: ffff80001068bbd0 x28: 0000042eff6f0000
> [ 1591.810404] x27: 0000001100910000 x26: 0000001300910000
> [ 1591.817457] x25: 0068000000000fd3 x24: ffffa92f1338e358
> [ 1591.825144] x23: 0000001140000000 x22: 0000000000000041
> [ 1591.832506] x21: 0000001300910000 x20: ffffa92f141a4000
> [ 1591.839520] x19: 0000001100a00000 x18: 0000000000000000
> [ 1591.846108] x17: 0000000000000000 x16: ffffa92f11844540
> [ 1591.853570] x15: 0000000000000000 x14: 0000000000000000
> [ 1591.860768] x13: fffffc0000000000 x12: 0000000000000880
> [ 1591.868053] x11: ffff0821bf3d01d0 x10: ffff5ef2abd89000
> [ 1591.875932] x9 : ffffa92f12ab0064 x8 : ffffa92f136471c0
> [ 1591.883208] x7 : 0000001140910000 x6 : 0000000200000000
> [ 1591.890177] x5 : 0000000000000001 x4 : 0000000000000001
> [ 1591.896656] x3 : 0000000000000000 x2 : 0168044000000fd3
> [ 1591.903215] x1 : ffff082126261880 x0 : fffffc2084989868
> [ 1591.910234] Call trace:
> [ 1591.914837]  remap_pfn_range+0x214/0x340
> [ 1591.921765]  vfio_pci_mmap_fault+0xac/0x130 [vfio_pci]
> [ 1591.931200]  __do_fault+0x44/0x12c
> [ 1591.937031]  handle_mm_fault+0xcc8/0x1230
> [ 1591.942475]  do_page_fault+0x16c/0x484
> [ 1591.948635]  do_translation_fault+0xbc/0xd8
> [ 1591.954171]  do_mem_abort+0x4c/0xc0
> [ 1591.960316]  el0_da+0x40/0x80
> [ 1591.965585]  el0_sync_handler+0x168/0x1b0
> [ 1591.971608]  el0_sync+0x174/0x180
> [ 1591.978312] Code: eb1b027f 540000c0 f9400022 b4fffe02 (d4210000)
> 
> Fixes: 11c4cd07ba11 ("vfio-pci: Fault mmaps to enable vma tracking")
> Reported-by: Zeng Tao <prime.zeng@hisilicon.com>
> Suggested-by: Zeng Tao <prime.zeng@hisilicon.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>  drivers/vfio/pci/vfio_pci.c |   29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)

It seems like a reasonable stop gap to me

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
