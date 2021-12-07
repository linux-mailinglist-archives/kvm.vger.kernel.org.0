Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F14446C07E
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbhLGQQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:16:53 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:42368
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239530AbhLGQQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 11:16:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iE9RQS/23K0r6oq+Sn9qq5RDGyNjphBPkb0s34GP4NggaVSZ7X0ECFGfPvNl1W8hIWFvl1h1H8R05AP7+Uii5WcETHNTCtNFEREkqzjvpbNGPFoNWW9TuF4DvMcFK94uYElIQEjxYNDqyCCdNk3TAY8DFBYFu+ZAT4ov3bHCQtnSKPzV6bNEHT4a+0jemtKF5AwvS5NWogBJ/iW/uQVuBTUGJUb+uALMUOJjjjqHcJfcGVwvMu32pVeIwk4qjQXoA9e1i8aZlmEZnRkRsP0vjYS65jODracv7snpfQk56CVE6ApMziZ57mjg9zWEu9z9OEKnHRzKRecguOwVgDkbcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GyC/HoVNNW1NPC5eqnoI3Bdt4OLBlQWUoWm2rM+Pfqo=;
 b=mwVEuZA20kvEIY1ftxJaIKvCGldKmUBfisUthwMCsdVl9jz4r2bNdmMi2PMzG+uMlSBBvQmYnZ1hbsvWBbM79ITXVc72CRN4wzz4/MFWsZwA0yCFwrEJKTin/aMQmWCLP0gLF6WPCt0zmudpGJ+6YfOCMAD8CcGvgKHj+ueA22qbcUa3SXnUvYqcFhADTwMkZX5cqmZ8Go4w9kokKreGFpVAfKMfhBFrOS2J2/DK09v9OU0rojAIO1b3wOPJqY4Cz4rQGARF0SVg895gOKPsGLQSPlevp9OAqsksLH3QTKP/rlvP2S2wc+YR7eXAuOyI3O3NKzu4JLfazpBuAHjpRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GyC/HoVNNW1NPC5eqnoI3Bdt4OLBlQWUoWm2rM+Pfqo=;
 b=Mj2+oNyEKvxM+Mgl6wCiZY6q/M4+P53vfkQ9xTJBkTzzXy7WJJWBBdhJCjUiCyHge9/TnlC3mDK22sGEnIgK4+wDS7G3vnVjiWvLJoWEWjq/Bipye/77azHnNHajUujSaVxfwUEHeeSvWB4T/95LWAVF7Cp48dR3C19CyUQNfWnGjzTfjBXKZ3Za5XCJSeREmIbEJ5bZ1lVaPXPSmG/Zq+m4H5TrnVkaFY87+nM4GF4TyqJjlGLczbrWkEQDH6i4jfqLuIqAbt2X+JigNKzA7fSgMWK3Q/VTeuAxMM2F+yvZwF5okLuJ7IQ7iw4tpcsgZEKd7IoCbiGXzxL3q374YA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 16:13:20 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 16:13:20 +0000
Date:   Tue, 7 Dec 2021 12:13:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211207161319.GE6385@nvidia.com>
References: <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
 <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <20211206191500.GL4670@nvidia.com>
 <87r1aou1rs.fsf@redhat.com>
 <20211207153743.GC6385@nvidia.com>
 <87lf0wtnmm.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lf0wtnmm.fsf@redhat.com>
X-ClientProxiedBy: MN2PR20CA0024.namprd20.prod.outlook.com
 (2603:10b6:208:e8::37) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR20CA0024.namprd20.prod.outlook.com (2603:10b6:208:e8::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Tue, 7 Dec 2021 16:13:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mud5j-0004iq-5T; Tue, 07 Dec 2021 12:13:19 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce78e939-d736-44a3-3a31-08d9b99c7c54
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5176FA7D863F872C9601572BC26E9@BL1PR12MB5176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ktzmxj+EFvotQBajEx4mE1MOzhUt6L5fBpUKqj0dmg8uhioT7NH3t5BSSfd4gtpbDPc4ZFdkLZfrJ+AhWLuNAuIGKFezTzPTUh5m0wC/fxnGN1pCoOrzqQ/ihsqav+C2OzG2m7qP1XQGxznKIEAol8RChtwcz0ILPCsgaM+DsnKgXGjkzJwD5wseeFKJE5AzIFphipPVKt1dKagqVC462sRmfh+WpqAzBzBnsjw0NiqFsoRvN5RIMUiPcmtGmy9c3pQEaU8hzSbIDKMKEdHl3adEsaJQwuy+QMdpHbnht238+BQC1qFR5277nu0NtOCIdvSiDCjZl8g/XdIXkbA7JN8EjYKyk2q76A6atbsWDovxkgXbE4fdut65Axi6L7bc60vFi+B9F3zuR1J6le42kq0zVIL5oqdcIQfwja/kdMAEqW6C995CMtxW3cXlMRf4LC01CAGgSGGpEvLnLvSTYDMgWqepUNasefrN+2VVpzI4v0H+6b88B7ZQHHMcOp4pTLNHnfwopHw5cJ7vr8T01Vuto9JvNLVfNcRIza1pAIZ92kPTgYynoNRebgFbVnwxPDCCO3z0pCenPhIPegVmZH/V1A3gMhVXFPSq4r4zbH5dHbWpEZMvQBsLPK7BEaGpLgSxfp08MVZuUW4Eg5jqrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(8936002)(2906002)(9786002)(36756003)(8676002)(4326008)(9746002)(1076003)(316002)(66556008)(33656002)(107886003)(558084003)(66946007)(186003)(66476007)(2616005)(426003)(26005)(5660300002)(6916009)(54906003)(38100700002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tbahYIaUkJdaV7GC+3irDiQJEJHOd05HqVu/F5XOjo1slgPRG4Nncc/O3y5v?=
 =?us-ascii?Q?5DzUyO5UtV1jOf0cxarbCc0xH+Rse/tqIicxyeHD1VlV4PMbZAMtoX2tAnjO?=
 =?us-ascii?Q?iaYU2p69DRcgpSZCD+ONfGcuZ5n3+7rvs8mM1nK4Z5JBLRZYCRPeXIHE4oNv?=
 =?us-ascii?Q?S3SYwQ6Bd08/v9j0sttV290SovhaA3c66JVIE/Sh3YwitWfa0710j8W8ry/F?=
 =?us-ascii?Q?JeMLD2MIK3ioHIjtxFO9rspxQfG1YWOw6LTatIeltmuB6ZstTPsTeoCVqSuT?=
 =?us-ascii?Q?yQh0mdi+XqpWG2lglryGEG5zCVuKTt7bGKHVp6I/JlXw+10pgwokYezLjOX8?=
 =?us-ascii?Q?xFqdvqf2Wx5hJJcJFFcLCcJcE7ZWiYZ2jd1/keptOFPHVH0TXLlWKxf0Lvp+?=
 =?us-ascii?Q?sZAH/lIrEbkvlHL1/Lit/BAJ73T+Sz3TJTCRT/3VK7hUvOVDIcbs6uJ41J0Z?=
 =?us-ascii?Q?kjdJJ6/WpcIilEaKuF+8LRyJZ9DX9NAiNpBvD4JfK9G9xbY5D2mtU1iuBeC9?=
 =?us-ascii?Q?6PbqgiQQ65kpqZxtCodGe8oY84mjJKmwSzgiELUGcGBcSDL6Qn77++kuUxRw?=
 =?us-ascii?Q?0F/z8TbuuAC/pr/vqFlsnpuLmL90dwtKedzQ4pDMM3uyqk9NLDgTXDqDEKp8?=
 =?us-ascii?Q?gdFVAf+apFaON3MUT76zqXxUQJSiwTh2bKVtSCsDXmvKpsofJdCcX+6q4iYk?=
 =?us-ascii?Q?jVRltSFu/j4nzpVpB2SYWxYIpy1jT6yZLR7CUqS9+RDxAjh74f+rsjAYvFnn?=
 =?us-ascii?Q?fDsvKXmAmsb6vM51VJ40Hq2kFPAb0Qe6d8bsnwKduucgzQFvI/Wuvmeyc1uB?=
 =?us-ascii?Q?+CRa1cYt7E0PyVLM7xn0Q/ZC73tOEzPDzZehcyf10oONGpUA2UUUidoKnwji?=
 =?us-ascii?Q?Uz2gpEcWx2cIGVS7xjGCHTj3D+nX95hQhiFbg3lSdiHIuuoq5KdIbVF6QETc?=
 =?us-ascii?Q?SqcOwxRYEhoN+8o6aTo9n6RIF+0ePNrKxAdK7Z/5ylDa+YzuuErs2GQu1fcC?=
 =?us-ascii?Q?o2nO1l5Kwx4aMfgTOX/0LXJg0h9Pez67e7WLQghhWb8EpzIxxhv9tP1kgQts?=
 =?us-ascii?Q?XMv2B6yGjIuSNEs24Q6czs0XC9r6bKnEhH/qt/IVR+pWM71TzQS9Aq0ku/Ye?=
 =?us-ascii?Q?cTwVtjDjUcmgXJFhjvC1p463hO3TJmDSXpksGeDjNcOldSApYhMfDLDQtzVW?=
 =?us-ascii?Q?hfncC4Jnp0QIWJ611HGMpgPkLv7XL3t4f+MnOSoQIx8kRsmUJVrQdqx7iEN1?=
 =?us-ascii?Q?CEpMf2FX6z+mGkCWrv6Rq7j9y0pztYKnlHpiCSYvSmwrnh9vi/ue64b+sMZK?=
 =?us-ascii?Q?6DqYF6wAbhzoiAYzArr/qNCGHAkAwzJ/vdxI0tpmiNFMeM2qUh+0FP00vnzR?=
 =?us-ascii?Q?b6GC0oZROWU8JlMikfRDFObOgRboC0C8zoqstFEBrKM9ShIxXn2zhnrkEyCh?=
 =?us-ascii?Q?jsxiMx6Q2axaRzBKA4ROK7gMSBRE+Qh2CRStjoitPpK0HVvHWQV49V2BUsAc?=
 =?us-ascii?Q?Be7AS7RFRdU50z7O7qUPDYi6p7ffvAYbukK607293RHaYKlLzobkzMeMjAdl?=
 =?us-ascii?Q?gqlaZUgfzVhD5IYwuEg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce78e939-d736-44a3-3a31-08d9b99c7c54
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 16:13:20.3598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lyeic2iAQOZSr9uINtMtfo+qytGTRuDtdRRGoiyb6y313Byn82YK3rWeqE3GzBmg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5176
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07, 2021 at 04:56:17PM +0100, Cornelia Huck wrote:

> Honestly, I regret ever acking this and the QEMU part. Maybe the history
> of this and the archived discussions are instructive to others so that
> they don't repeat this :/

The good news is we can fix it :)

Jason
 
