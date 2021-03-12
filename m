Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6A1339795
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 20:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhCLTmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 14:42:17 -0500
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:54942
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234362AbhCLTl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 14:41:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ul7TK75gYm2LHH24pCz0thFapkmHpQ5Fib9jkP4mMAbPAykh3INRmWWHSPvf3BZjdnlhHIXLiL0OvfDx87+99jcQDKIRBTNqLjTP98HBRZva9g/bWeB+T+8grt6GqZZtWW3hTAK8nr83AumlGyN7gKOjJR149nStWmR+4Y/mh4upBqPcUPxscTU1+9cnMWq/UQU6R5nSl/0Dl9XiRaQmxtk1Lg1jDZuHfX3bcLKRGCX7EHfiaN2flszyQgHN0TrybcMZYnQZJYXkyAstYu9uJqS9UBsSho2IdN4i9c4gXTqYkwkENgdfrJrEebtL+K9AMR5h1huz5ggOPpciJFv/qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VZqT+oJIWO3gh9Cix9HtWpdxr1ZOYqgz7ZMokEgJMI=;
 b=DWwpvW5T9O+wFZZHsJmC0y9hPZNKBp46f6cl5g7ZrkWyA3RiK9dFiTo7COe4lHJjKFwbnkNSc0dTHUzwV/rozknqMorJzZsJqT++JIIEw6pYLxLxFZ+SpXxm4Reyo3k8sp9ULeniINrQeJLveZyMWR7NcpBJliy67uEghal1r7JsdCG35rzzgcrpFqdbbfaCHJVd6vSHERd9BCR/v0I9E/zad0uPWSzFTNz5/Idce8eJ+vZc/r2hQuzNoklGSfdf4Z8UkYlK/eOghG4BkWlapMYEgtVNYuDSbFg/vMAOC6wiWikOFEG8VyN1MfRSSM5vzkQrly6h3qp8mNua2WYF8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VZqT+oJIWO3gh9Cix9HtWpdxr1ZOYqgz7ZMokEgJMI=;
 b=KVzmz22pfVvW9uXZgtePmrQTThJnbWlOsWElzdUfjNlgf4c5Ysah/jM1ELnCmx3zm2nZmrZ69YJ2Zr98wRi5wje/c0aRjMHZCTafLXwNH9lBhU+QyGNY7nlAhj4gVG3/YUt124yMm0aVcyPMBtHv+LYDBDRZjwZ2RvrBTF+kUA7uteQiqigZQiMd02PcvKbBG7nJ2ggupeBZfo32DAbJOySNmWRmtayK+VkD0Uuiv9M9UaYMKqD0/pEqLf36FZQxC2LS/hRWANVqtIfR3EN0z6UrAVpWxI1OhxgdNSJP6KW/+ZV3KDwtotlqW2TutCx7q8HxW9zsg4MOzSBxxF7vmw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4011.namprd12.prod.outlook.com (2603:10b6:5:1c5::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 19:41:49 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 19:41:49 +0000
Date:   Fri, 12 Mar 2021 15:41:47 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Handle concurrent vma faults
Message-ID: <20210312194147.GH2356281@nvidia.com>
References: <161539852724.8302.17137130175894127401.stgit@gimli.home>
 <20210310181446.GZ2356281@nvidia.com>
 <20210310113406.6f029fcf@omen.home.shazbot.org>
 <20210310184011.GA2356281@nvidia.com>
 <20210312121611.07a313e3@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312121611.07a313e3@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR01CA0055.prod.exchangelabs.com (2603:10b6:208:23f::24)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0055.prod.exchangelabs.com (2603:10b6:208:23f::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 19:41:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKnfP-00CxG3-S5; Fri, 12 Mar 2021 15:41:47 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fa2026c-f2d5-488f-e12e-08d8e58ee08d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4011:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4011E02BC3388E7A3F6B10B4C26F9@DM6PR12MB4011.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r1PjIh9tkNjo7BuzlsdSaf6j44tX4JX4xaBLLhnQhs3CFenjH9cbg96QgoSnx63M3oWSE4TGbVnsIfh1ZXvHyswCvKjXoLte8IoGFaqP/M11vz/4Obuty+b/dZ1YjSJ2mxhu3aDV5StAOQOuOuPld1e9KMs9SvdDgpJHrlBgbgoKebGhQSModWgbUbMh8hS14kbUrb3ifTuRcC5kZBCf+04byzCSW0Ldj/05Te6Hx54Amj5HMQJ4zNFrER/O+pgzOxFQXxqokHeNQvvWfSrohrl6lZXQzvMekrkjLHAO3dOL7+SnB9BFyU4nOPeklarzr0CHRR+E64rBopszRjplx4u0pu6vDumHHmNiT/0OUoxQEUEcmsskL7nGYFoq9Bb2Bs3Xd3TjCIq6+fAS/nu6SaXPXcrDj8nlDGdlIimP+QGda5FbDin0VIEn4kh8ALHjIf6Mcrp7VEedyWevmSx2iz3MI/4Pm2gCdfOGLm2I6S2wWh9F6c/JWIUf9Nv/s6ort5pMCtaYrjz45v+suIqETnnyELJoHBvmgYAHpVfsJ7lvLLDiTZpcgdUd05w9tHBE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(83380400001)(66476007)(66556008)(66946007)(1076003)(5660300002)(4326008)(426003)(2616005)(186003)(2906002)(26005)(9746002)(9786002)(36756003)(33656002)(8676002)(86362001)(478600001)(316002)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?V1IT4xicNEbJbH+/ac7CU5gPI0KgnYbV3/svPvm2i0rDKNM5krCeUuUTlCbi?=
 =?us-ascii?Q?V0EAc8A2GDYWid48ukPXqqVT2U/pfrrnGcessZ9LtI0GX16CukoclBU7rN86?=
 =?us-ascii?Q?6xuSDvPmXp4PjdT4SfXYBHM5rEdgMuhoYUc/3PMEyW36sw+KQxCaND8F8lzw?=
 =?us-ascii?Q?PdSzAju7MYVgzuvBOqn13dgPXajA3bFdJCcllYSZvX4+53ES3da1XPXDu8TE?=
 =?us-ascii?Q?4XGK5SGY/o1q5h0t7T/QC4X0uCaT2izwrP9R4I/C4Ub+nwTnfQ2NalA7FZoI?=
 =?us-ascii?Q?Repph01/6x/BvtYEs9AgkCjkBt2XyujS4kuYojhYBFJ3/DfF/aBmTRkVuEg8?=
 =?us-ascii?Q?p11Pmte5SfR3en1T+gngtfoSBnwtWHhX3aCBN2MP7wNW5b695NFrjKdZNbxL?=
 =?us-ascii?Q?HjhMDtFCIdM8eV2tTnIEExEOplFbj+5a1JLk5RY/qclPwQRoPUtpvp1ojvNq?=
 =?us-ascii?Q?dn3eSO28RD44VP/QXifB8YGamVewQGMlDB+dRJgYtO2kiDGS/bawjX+s40os?=
 =?us-ascii?Q?03oJRYzJ89Iz0qKPCDs5OVF7CIulrjy9KV1wMs3uyjs6/AnAbJyI5/RMXQyb?=
 =?us-ascii?Q?6lJ8qNu6ajPtNjUqh109el0tGIEU6hfKOpC+fz7E7XcPM9blWcFFT34ol+Gm?=
 =?us-ascii?Q?hFj3e8Ti2Ut7nAThd8t93F8+1IZtq5I8c4Uw14a9EuTJ6PZnBiGPmvrs5qYf?=
 =?us-ascii?Q?iq4JyUB9HQrywK4ks6Sp3vClaPbYOFiiecpogAy220W8A6PXQxIFIvxd/efz?=
 =?us-ascii?Q?Ap9RGp46Lb3i9lwuGCLN075HmgZ7g0fCg1LbUac0sTJOpFnqgCFNRRpQaF1P?=
 =?us-ascii?Q?AaYHhHkyGZjxO4kmrGnhMKiRwHuYCzxUI7gmEozBwZPnkqLNbVUJ70Lm4IbN?=
 =?us-ascii?Q?LCW3BDqR1AVEMjP5lgf34mK7qtRcadqVcjLjk262olraotpqLXenW5vG9sKJ?=
 =?us-ascii?Q?bCjp71KccK/lC+aKJ84uN6Bs25BBgI7STuqO1vCcC0Slruo+qHzy/5mJTAvv?=
 =?us-ascii?Q?I3bg4Ooqf8UKyyn4LPTu39qJ6/OynbKUpWkVCeR5nzxpGGhfuxcjyvquCxMt?=
 =?us-ascii?Q?2HFOVDYEAhazAq91IQmX2tkec0Fn3hTP+8BpX+sVe7Y1uhvDL94l6zhh25w4?=
 =?us-ascii?Q?SXCXJBXdssGEgZEapCBpmna2IkarD8pCL/LUxGKrmVd1kjF25d3EMkPaIxC3?=
 =?us-ascii?Q?DshTl2b4B5Sd/K+xuB+AWXalKp5hqCPjzkRkgyq4lFsCIJaVcZzqt/0ioWtX?=
 =?us-ascii?Q?LeolhL//sX8ydH4VDKM4sXex2Y/9LhcGKkCFxQUA5971lLMyalRPjFRHTeAw?=
 =?us-ascii?Q?zKZtJ1smNa4/oBc3JstVGu0QU1NLf6inTS/ZRRZeUdhpWQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa2026c-f2d5-488f-e12e-08d8e58ee08d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 19:41:48.9795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GSMdybNBZ5xXg9GB9UmdF6mycMjtx/5y2OmB6e7dLdxkshMPnR4dfo6mGJNihj+E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4011
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 12:16:11PM -0700, Alex Williamson wrote:
> On Wed, 10 Mar 2021 14:40:11 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Mar 10, 2021 at 11:34:06AM -0700, Alex Williamson wrote:
> > 
> > > > I think after the address_space changes this should try to stick with
> > > > a normal io_rmap_pfn_range() done outside the fault handler.  
> > > 
> > > I assume you're suggesting calling io_remap_pfn_range() when device
> > > memory is enabled,  
> > 
> > Yes, I think I saw Peter thinking along these lines too
> > 
> > Then fault just always causes SIGBUS if it gets called
> 
> Trying to use the address_space approach because otherwise we'd just be
> adding back vma list tracking, it looks like we can't call
> io_remap_pfn_range() while holding the address_space i_mmap_rwsem via
> i_mmap_lock_write(), like done in unmap_mapping_range().  lockdep
> identifies a circular lock order issue against fs_reclaim.  Minimally we
> also need vma_interval_tree_iter_{first,next} exported in order to use
> vma_interval_tree_foreach().  Suggestions?  Thanks,

You are asking how to put the BAR back into every VMA when it is
enabled again after it has been zap'd?

What did the lockdep splat look like? Is it a memory allocation?

Does current_gfp_context()/memalloc_nofs_save()/etc solve it?

The easiest answer is to continue to use fault and the
vmf_insert_page()..

But it feels like it wouuld be OK to export enough i_mmap machinery to
enable this. Cleaner than building your own tracking, which would
still have the same ugly mmap_sem inversion issue which was preventing
this last time.

Jason
