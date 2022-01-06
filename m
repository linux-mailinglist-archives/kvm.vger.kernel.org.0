Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D11485DB6
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344097AbiAFAzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:55:43 -0500
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:11265
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344012AbiAFAxo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 19:53:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFgqaX0RZXpGa7U/jaDYoqqemvBFk+u8YmSc33wVjbYPO/77kaZCCqSeETptso4mAx7UaYcPiyrJH07xdOttWouEMhgAK5I7la6l15MfWdsaW8nmZ+LQbBHU0XlmLn+H6wn7jG0yYr5+bPvIa4JWZBgTAuQ5wxnfpRjWUAn2TItlBkuPevCVoJWauVM7ggDvdyAd3HTYFhzqfwt21vZFTxjDGNYsEgse3dOHFAY01fCpW7MCvlH/tnn8A2QQZ5DjLi817/NfTzErYFYvO2o9B957z4e+FQyL2PGwgVvfqudbrdBZwo/6GSjEkV0VgUzDiDtFLtBpF7jQuO/Ki8EjJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSWXUANippgUQmtQF6f18RYMgiCDrMy1p+cOKs6eU8w=;
 b=FkdnmdG22IHIYo1eDi4RuYEWuvu/O6ob//LXL5Jlkcfd/nY+gpGjlSIOjDbCmMvPsd35SQuMIwoQtJloeShmxVTidEBHDCtv4Gv+xZi2UV8myn1Hfynf7rt1pXPIQbQq8npFif9j2Hg/HL6neUBY5mg+kmXT2Ypf26wnxkL9w8X4rUFy64egpYR/KB5l9QS5EQKHGP6Ogum9FQskhULXqUmP1P3pOLRIbWYDS8cTnlHnwDQo9ZuOgcXtOjjXWQ1hPgqScjAGdLXsYhrmSYcOc8E+mwDh+CJTokdJRvpqUfBZMnczSmCUBdQw3qkWO0Gp3EOlVo7kAEJ+6pEn624Blg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSWXUANippgUQmtQF6f18RYMgiCDrMy1p+cOKs6eU8w=;
 b=H5YwKP/SuL9XDnvYqWas9L9iOsA18WrbckbpAX43JKpqHX6QxbzQf6LvPf0S0XtbKrX7yvxjG6/cwK6a6zfvTUZfUhC0Ba7fQCb3xaU31qS45IxDLE5OZzpSK0Dj0121F+KHkGfEarh2LtrvvkZV/tGZl3noUYkJJ4iZtX44HX/co+44pvkB7FSgBFVAbBIKplqUn8rGdJ8HmOt6mgUfIRYriUF1FmNWnLebat+tIZshpNEaxxfuWbn0OhSgF9aYKezUpj6wo4pxnp1Xok7WF8Q1/q/pKk2ZemaGZ+KKVhHxjJF5+Oy+NLa8O/9V6uM0D0I7MfJ/2agrxx2wkKaGEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5554.namprd12.prod.outlook.com (2603:10b6:208:1cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:53:42 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:53:42 +0000
Date:   Wed, 5 Jan 2022 20:53:39 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 08/16] vfio/type1: Cache locked_vm to ease mmap_lock
 contention
Message-ID: <20220106005339.GX2328285@nvidia.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-9-daniel.m.jordan@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106004656.126790-9-daniel.m.jordan@oracle.com>
X-ClientProxiedBy: BY5PR20CA0025.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::38) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 032e89f2-67af-4dee-13cf-08d9d0aefc3e
X-MS-TrafficTypeDiagnostic: BL0PR12MB5554:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB555430A9F26DAA0A40331284C24C9@BL0PR12MB5554.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hq5kZGlaE3ldnofEQZ/lmBmfscGCyFio458mN6dHsXFdEj0FH+s8sj5Ez+WRsKiIEcZna1TocvczjgkMJvW2ZqPRaVyOP7ZRHzY7WJeQJhXr8+p9EqmoBcqdOIsiTPyEVObOijlzpdIT33fGXQ52uyBynVtS+mm+yQvrvV28h4nEL0ytnCVS5FCCeF1DubXLA/JnQcYfeF3uLGkB+zudmR5v5QOptA+79P14Q5F0qgDyZ3Qh/tZY+bt/s8BjTUeA2kqBkxy0UvY0J8DZd4/RBs2LLPeUQD54lyJn7LVkqbdAOI1F/C5cflEfspuYocJ5TJHLK3VzR8yrYE6VAbGFcPdAJVY4rg/Ta1DtncjJIh5TdcZ2cQyKdB4puOl2jxfxrcwdenE8jrb3OEOmDIX/22mK0gD5PAehM1uUHCc6Z7/P688t9jnp65rduYbmQIe/7UyKViXo1L2Ry10OIJR5EGT9Iv5u/RKBMFK0yeU/rF+Q6QTFncBOxq6q2m2M34MLHsq/S05SuhJJCoCbo7bZ1aV29uyPGQHcuIQYew7HUNl5arSbEXrRBtDQwg7GvtfrL/kfOWIXjrqGVPIsh/oeJFkbvC6vF+G0KI+2gp//HLm3fCAqSjLlHiQ5IRem6spjr2vB2m9EgSkxC+SsdI52/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(8936002)(66946007)(66556008)(6916009)(66476007)(36756003)(8676002)(4326008)(54906003)(33656002)(5660300002)(6666004)(6512007)(86362001)(7416002)(2616005)(316002)(26005)(186003)(2906002)(38100700002)(1076003)(6506007)(508600001)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?80SOxbvCaIdOxg+RDfpQiXQzS948p20jlTcZvRekAYZkD0NZxCSbUf3Lqkfy?=
 =?us-ascii?Q?mUaKhhTnfLKQDiusWMojay6JiP/n1SjC5E+nv/melOjwIdsnjtOgySu160in?=
 =?us-ascii?Q?Q6DDi9WcCO/DEyHWASDwGm+q308UXp69Tq4c/C+9WgpKZDlMWNAea1FeCVs5?=
 =?us-ascii?Q?JrP6NBs/rr4nWKP60ttnQMjsmCVvas+98Q01T7BvkPTJgStA8ujWZFdYlJpa?=
 =?us-ascii?Q?xpZ8NHHC/r1OQoP10tW6WP7ND2UIyj9NoyVBXTJTqO1uWH9EnXDb9NHrEtW2?=
 =?us-ascii?Q?UM5Tbadu7HGnDQpZ9jyWWKlQHxrgqES+m55mft2fOWzB3vV5V0Tu7avJmn05?=
 =?us-ascii?Q?RE07JdDYHspa24X7V/Ia3cYZFkP/ZsnPc47veiNlTMvfAXf4vWjZrl2jJAUB?=
 =?us-ascii?Q?scj8TapqsF3PrxmvD9U9TbRVJI2EXmW6STk6hhOjWzSdDJexfhxQnL8ng9ps?=
 =?us-ascii?Q?R9AQHut+UXYb6NoRVLMAMPUGLe4nYFqopK6qFDlujBX0uPhWdazJtvaw/yqP?=
 =?us-ascii?Q?CyQMpJwjbN7jJ18lfXtk7t6IcopYDfScsAzjuVhaFSzRPXqDoQw/zu2gvlQd?=
 =?us-ascii?Q?aF8UezJ+L7hf+PPesneUYPJ9/e7gslVpRgUD6w9DlKrodqJvwgvbJ+9ihIWX?=
 =?us-ascii?Q?mNltgJi/MuAFkS8l6nCkjHZH174rl0YvnK1412YyyFP3ekzP7+uy8DRe/CIW?=
 =?us-ascii?Q?zQ9YIebUhpelCkpfFjP6LmNkCWlqWMbPj3DUeDiARs6p29O1sg/4+GzjeMoq?=
 =?us-ascii?Q?tu+zB3Bkt59cyNKkOuFEEkdaH7Mn0NQJg1syJRnN6VCyCqRAGVAhGlthEKZ1?=
 =?us-ascii?Q?GxCx9EOVx3SF+qLc/8fu54RnNljJkPh7DYOnb0nUKmikCEgoqGvZW0sJO3yh?=
 =?us-ascii?Q?vvainEhq685wHPEnohFhZnA5eRJgDy+wcQVfXjwYuiOGMAeiqq/9bmf3OB1f?=
 =?us-ascii?Q?K0UxGxyi3i1KgQ8nIMY4PDLGOoCmPjdOs5kVB4DvI+p2/iTwOMPBnyxQrofS?=
 =?us-ascii?Q?Ky0Vesv65yhdtsxBVgHaG72kPl0QdnFsqDvToDrjBvfMC7Pw/n3RhDeTgszu?=
 =?us-ascii?Q?OtrDCJ3xoE6R+/aiI2/tP3zFScc+N6yDns7V4QOzOlj3BEumeqyZ+a4aJqI/?=
 =?us-ascii?Q?tNm4sJwufCGCXreIboI4anHSDhw49BQB18VqtvW8MpMNLKF6s6MJL4xFxPUu?=
 =?us-ascii?Q?CqgErLY0StAzNj+WLbLOsV268CLQd52pVQM/Qs06vkd1kHYS9MItWrmyUkeH?=
 =?us-ascii?Q?dw58IuF0SCAOON2lcx3a3rgvLLtuwyYwVjaGN54LJHzqNXUF1Oz9aJ7rGYsg?=
 =?us-ascii?Q?Zv7q9uSv3EfhWNcVCsImbrNOaNqkYAG30z+D+RWTcmYi9Oss7683VChsG5Qk?=
 =?us-ascii?Q?tHzJfJ4hKR69xHqwumeqTl7p15ucMXyzwcICz1JUatnZrOsD2NiZo/Ju/Exj?=
 =?us-ascii?Q?LJPgHS6hIUVMRpgVQXIr6Pgu+8YvEV4W6auqQSbTXbU7HDfxK4fFiXHRKMFW?=
 =?us-ascii?Q?KpELZQPJmOep6iNktQX5j7iC482vMMF1HZkwQw0+HQXNKU0d27bJJbLA1+89?=
 =?us-ascii?Q?kttJc5JSmuDVcZMTtWI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 032e89f2-67af-4dee-13cf-08d9d0aefc3e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:53:42.7116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFv0WdQEqmKEuhLdEGngorVroeRUprlceWjtgfVgKGk4ggK85YpfGb5s7swS/jZz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5554
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022 at 07:46:48PM -0500, Daniel Jordan wrote:
> padata threads hold mmap_lock as reader for the majority of their
> runtime in order to call pin_user_pages_remote(), but they also
> periodically take mmap_lock as writer for short periods to adjust
> mm->locked_vm, hurting parallelism.
> 
> Alleviate the write-side contention with a per-thread cache of locked_vm
> which allows taking mmap_lock as writer far less frequently.
> 
> Failure to refill the cache due to insufficient locked_vm will not cause
> the entire pinning operation to error out.  This avoids spurious failure
> in case some pinned pages aren't accounted to locked_vm.
> 
> Cache size is limited to provide some protection in the unlikely event
> of a concurrent locked_vm accounting operation in the same address space
> needlessly failing in case the cache takes more locked_vm than it needs.

Why not just do the pinned page accounting once at the start? Why does
it have to be done incrementally?

Jason
