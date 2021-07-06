Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B382D3BD48A
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbhGFMOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:14:07 -0400
Received: from mail-mw2nam08on2074.outbound.protection.outlook.com ([40.107.101.74]:41150
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237333AbhGFLyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 07:54:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQ/zPaEdyy+v1OwZ2n7XggyG/m4P7zxrUTeeYE7em/XdrdzhyDCL54bBfxcuokhB6qCLvEgD+SqohzfgQFQMzOOMBOoRz3LiuwSnhGBzSO6e5S/cC8k2VHwool9dxD7Ljy6o1WtN+Snk4T4SDJmpps9AV6vgA1+hktj0ahA55+pmpGWNX2VhAfnERwccfevi3vYrLS8GiLZe7xH9rDf7Y7pq/+gtQBsJbaCpSUNaPOwuSN9mvR/VGow/4SkWuZHOYq17Z62wmafWXfOsW5BCg83cnMR5/BMBCigZ9U5EYMTL5KTZuux8AZBnfVOB3A2BNP74gHOAXkBXAEKZJpu+Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WaW9K6/IbiNW2wlEE0O7yjuGQANpswIWyH9Urp9H+Gg=;
 b=ZJCRCEB6htq6Q3oO+9iehqo33ZUhVsIBSACXBQcTz/pr76jOZpFMisQnx8oMljJQ/GsqVDFlJ3TXL/JUqGwqSZVhch0/n2Siqs4sIDZVW0NDLQz9B8A+b9m3gX9sDW5+iXDofK5uJbTLhvnPMV6Vsq0Xpf7YlFpvjr8nLJJy/DtdL+ac27CJQQp25dVUCVEc8VXNdphMRdoIYtdIFnvYTvU6FDd8CpDhJgPd71Nr42kwtttP/+Mv9wjCHdar/MsD61jV1E9Ryv09mBQh5N0+xXtOZdlGR1SBJj/nY3EgJ+Ncu3gxq8T4ZAbdkSQO6gO4YH25xZJyEid0D0beXKZSng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WaW9K6/IbiNW2wlEE0O7yjuGQANpswIWyH9Urp9H+Gg=;
 b=KNyNjQHYl687SV3Q5Ue+7pUZV7Z987bm46raLqLAdWve65ZT0W7rT/71XZil+tpGLUSiAo2dfsNJFlhzkX+W+ORZtC2wuwwjyLgTvIURAFQs/o/jyRiRDh6IR+ETwgSLLlfNb2tpBu+fhmO46ENKDcxZrYQ20T9rGAEfLWLAu/c0LL4dSgAnPtepsO9/PwlVsfCLdwdla9v3a+4FMphqlr2BOT50L4isyMowF+xOjyqYoZWV5gzFyGLCY4WIS6tIwfeQWX0jqWECRZ+UqrcRcpZ/pqOUg4uazAg31lzcZ/BuhEfNpQ2s/eQ4NltOeHatrYXXS/3RU9aTVb4YePUYwQ==
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23; Tue, 6 Jul 2021 11:51:33 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::81bc:3e01:d9e0:6c52]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::81bc:3e01:d9e0:6c52%9]) with mapi id 15.20.4308.020; Tue, 6 Jul 2021
 11:51:33 +0000
Date:   Tue, 6 Jul 2021 08:51:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Message-ID: <20210706115131.GW4459@nvidia.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
 <YOFdTnlkcDZzw4b/@unreal>
 <fc9d6b0b82254fbdb1cc96365b5bdef3@huawei.com>
 <d02dff3a-8035-ced1-7fc3-fcff791f9203@nvidia.com>
 <834a009bba0d4db1b7a1c32e8f20611d@huawei.com>
 <YONPGcwjGH+gImDj@unreal>
 <20210705183247.GU4459@nvidia.com>
 <YOPefSD9x+mv5jO6@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOPefSD9x+mv5jO6@infradead.org>
X-ClientProxiedBy: CH2PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:610:38::17) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR05CA0040.namprd05.prod.outlook.com (2603:10b6:610:38::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Tue, 6 Jul 2021 11:51:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m0jbv-004OKa-Pi; Tue, 06 Jul 2021 08:51:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8c2ac37-132a-4cea-a31c-08d9407466b5
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB53989B6CCD4171CB69EEF00CC21B9@DM8PR12MB5398.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZuwAtutQKtUDcsjFUDLjM8VrK8twL8GnfnYE07/aJnCW0KvOZ2LR3XLEJftJ5AQ5mnaFkRniBEfUi1UppcIAvQToI2wHf905eC2PnvLLMJsEwVxrzhgitygVsaZdwDMU8BdeJyoMXZ+/q+QHQOgPQu2XsIa+ZgjkKc0dH3d2sYFZzme5WSm1/dq4MsMLT1Rd7hj5KscqMhG1bIwfKyfeAkr2jAjrLvUh2TIv8EpcQYlmuIYQ/b41sR5k3ASP+hsgI002itjz7ABROXAxte+6Xsj0BZrtT0qzqBke4oWQpY67AGD1FJ3XK38XGctsX4berqqiGGeycVA78JBsfY5Ej0uKkg0TCb2K6It7FZUGXySaBqQR5LwmMuI1uObflQX4CHL7odkOggeiY/78iXgN23lVJSW8bAhkETahKgQ/rl5Hw44BU3wDGNJ3uC2SXQn948YHI6AJFunklx0R6unC9Sie4xM5BTbWt99HSwu9BRHkWD9Y3zsoQDwNUpWAyh991DqNKC+ARxCb2qg5UTcHMy6UqFvUST+yfTWAhG8FM8jaEGhmEUFZp2OZoaULueGTqeDRnYY7qy4g3OqMl+4TKaO6UcO0iXB8Nun0I7lzCbe/uent3p/atD+bzSMMji2WDSzVK963kpxZjxb5feWBgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(9746002)(8676002)(66556008)(66946007)(38100700002)(9786002)(186003)(36756003)(66476007)(2616005)(1076003)(2906002)(33656002)(8936002)(7416002)(54906003)(478600001)(5660300002)(6916009)(316002)(426003)(4326008)(26005)(83380400001)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?noYiuSYZYjaF+s2GxjrAOsWTkeOBXu2iJ42n8S9bPRaCOGeFKZvx8cx1qANA?=
 =?us-ascii?Q?3fXfjtELCoSGsJdL5BHy8kGD8rp293XMJgpDgq0fE+MCdFuQ/2u6S7BBNjlA?=
 =?us-ascii?Q?2uUrbiE0KOHQJ0CYaikoVqLOG+Y9EbHiFnkxxLet5Ijwh34Zu1FsBQFM2Fbp?=
 =?us-ascii?Q?Nk0VflSnH+dDQmhXWX9Yuop46KIPJcHJNCknYCBKp0Wid9WNK7XjUOWeJKb5?=
 =?us-ascii?Q?6CgyVthjuUZSwm0aujAaz+fB/l2KWIdX1joQG0cuyChTiYdBlFKCKWUYokHq?=
 =?us-ascii?Q?BIaR3IS5j+bIo+jMlkK1gXRTs4cHCQEOEJaDXpvcjXDprh4ZPfMdKbyQoffM?=
 =?us-ascii?Q?Du8mYfQCx3xKGebv5q975jNFA0gs7GHtpKN8/f2MvmMWWKa8aLf81pzolmZ8?=
 =?us-ascii?Q?jfyA4eyjW3+m0Iwf9tvKMZBl+5Ee1W+Xxj5BUDV0WMsXKWsMS+Em/lT8HRH+?=
 =?us-ascii?Q?TmcUcTzki5vYTcTClAgJs0b8mFmO/sTZzq+YxSGEjoFPLBAUglegGTvvul/l?=
 =?us-ascii?Q?qDHUHUNL4b0u6FwA2R2ozOq75NopRiaW1aVQbdN87Fmp9N6YTzyIeEzTQbXF?=
 =?us-ascii?Q?4tfMqhqfrv0O9WEGC5rXHt1b+ne9XLBprC0NjM0mT4Vl1++4uzY4vOhFOZVB?=
 =?us-ascii?Q?KNjgSfv7BBDnQkAaXlCN01gzusiQUHev7dVoB+9zO0VzgOFbR0a6SRehy2yI?=
 =?us-ascii?Q?e+MxfYoqF58F4MmWkSQV9U8hzT5NPbwHI27sX7LmNb/Ijw3H3DSdkpBMVoA6?=
 =?us-ascii?Q?l22DGgwV63ej2z9bzaYkIe/cm9d2MNQ34PBXNvhyyXQZSOJqCb6euiaidMMy?=
 =?us-ascii?Q?Up0ZypVicO4FBnYVWnKm3eqP4DCsXrbPtxvUvUoqqOUV+krJOet03IVjOPG5?=
 =?us-ascii?Q?qTdyvxWJgBJgrOfii204xr5RBxt2qiS9lu3+E2Uf+PiLa5FrckiRqdGGaYcu?=
 =?us-ascii?Q?W5hG0pBG6Htfbb+nT7149WvamNZ2h+HwwGgLZxJIyyLHKa6oBpVAt1+xwOtY?=
 =?us-ascii?Q?yWxo01gH762RBMKn2dzlx1N4MtHOWHlczUsPJBbtqAFuldqIeOExv7HhEzrj?=
 =?us-ascii?Q?zvGJj5b6/AdtAQub7w8U+0Q7j1VCQ2AEaRMSQpo38AGI4ep0W5gW05dxf8+N?=
 =?us-ascii?Q?NccPA6z0yuw4jmy1POM7EX3s+x2VxPG8EQ47Q+DvjbnpCcTcxVa98EqJTJ4o?=
 =?us-ascii?Q?9/cBEnJJ5eazQBZzwpzyTDMw91kNebzSmO/ilI1O1DqUFRFZsUJBk3g+Qmtu?=
 =?us-ascii?Q?lspEXeRnqGKBsciSX6Usrn83ECcKgWMiXeOCwPKBw/4icvP0l3WrDTPGj81m?=
 =?us-ascii?Q?aDfjxsUi2BWNNVnQSA6YsD19?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c2ac37-132a-4cea-a31c-08d9407466b5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 11:51:33.5061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TotVEmwWgWuwQZemmSP72NPEYbDAcqtQOFFcpcu8iYSbcRSTzsfzDhrSn6Cxi9m2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5398
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021 at 05:39:25AM +0100, Christoph Hellwig wrote:
> On Mon, Jul 05, 2021 at 03:32:47PM -0300, Jason Gunthorpe wrote:
> > It would be improved a bit by making the ops struct mutable and
> > populating it at runtime like we do in RDMA. Then the PCI ops and
> > driver ops could be merged together without the repetition.
> 
> No, that would be everything but an improvement.

Do you have an alternative? It has worked reasonably with the similar
RDMA problems.

Jason
