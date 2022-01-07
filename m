Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E91E486E94
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 01:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343928AbiAGATv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 19:19:51 -0500
Received: from mail-bn7nam10on2058.outbound.protection.outlook.com ([40.107.92.58]:48833
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343531AbiAGATu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 19:19:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4xcWwc7Rf6lHSBVj1igRfLeZ5dgMuV35TU3QhxFKZy1PAUffH5OfgYOBp+C6X9AOS+9aJXreGYcGek8xShvxTCAnjn7Pa9eooXwBaCBP6QC+AkUCuf3wd7oDfkh7habB6VOJ2yyrBKb3ZhA7RNQW9gNE+VrffTRfnmsoDMhsnMMqnGsTpV3HmQRaDT393Uah+THpvRhQ0O8qJ3aqpz1rBu8gBRZdp0mYr0nAx6gWzpw5Af6t2tqCIIjESpKUqqPqzrYBG6REYYGnTTBKfsmeYNfnucvwrbu//kXkEnnZsImPE/4kcnraZTS21zXRckMKb0bw3D76211QANbEg+rMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QfzH5c807geQ2tRH0qnURQnxPFLXit/pfq3ANqQn5Wg=;
 b=AkdXgI/B+ADFRxHyu5qQLIX8cQDGjVR3n7oH/XdZglzWOZh1A8tD57K5Ur6hwCPKE87aVhexaNqqA6Je00tiu3F09Kci8CjwlDq157qxUgrQkXFgXM7/8lMupQM3aLsSgqQk1Z4E/0SmQv11HaA7HduC/OEUz5GXOLe3Oe9B3+m+NulGjGrs8VVplkQZc3fMrtYhi45sIFVb+/7dyxRQOK9vEPBzkfMvxPeFZokzALRQ5wbCly4vFuyc0oGbJsyAiyzu1ry1gH4P15e5SzQY43hvrolSwIFQHGzUabnniLN8T7xT7WAiPsOoqWxgDIMwgQDSnnAFANve6vuBiG7hvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QfzH5c807geQ2tRH0qnURQnxPFLXit/pfq3ANqQn5Wg=;
 b=LCkw+TN++PjB61AbhuUiISxScp3IrTpGcFMdaYYKD/ksP3MiQHkOkyzDVbtSkRycr/bDuGR/lh9fY/KD+YZv1D6YnQJD71fV8UeOvCMXlM6USxPJPe8MGW+MG75VnnfkavercV0zDJMXJRib8and6d9GKvhW5nGRCmx6hupsRvlr/A0LCGRbxqpPkPV+pDMD6XgM0jFawRGzyqHFgIUHZEuVmy+st4asMGV/znI/SsmQ2fVT3NynVvksV3oBeSpa0Hsr9OpT7dFE/qPTspbhmKGIckZ2Xrdw/aFpRQ8vF9kYP8PUIcp+faxP5l0OEm2Rk4bt6pepUl0+J0FS/dgBqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5378.namprd12.prod.outlook.com (2603:10b6:208:31d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 00:19:48 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 00:19:48 +0000
Date:   Thu, 6 Jan 2022 20:19:45 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
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
Message-ID: <20220107001945.GN2328285@nvidia.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-9-daniel.m.jordan@oracle.com>
 <20220106005339.GX2328285@nvidia.com>
 <20220106011708.6ajbhzgreevu62gl@oracle.com>
 <20220106123456.GZ2328285@nvidia.com>
 <20220106140527.5c292d34.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106140527.5c292d34.alex.williamson@redhat.com>
X-ClientProxiedBy: YT3PR01CA0102.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88785956-3994-4f2e-d4c0-08d9d1736a21
X-MS-TrafficTypeDiagnostic: BL1PR12MB5378:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5378D84D45C6013929A7CB61C24D9@BL1PR12MB5378.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mg0cBB8rADGOSeTzZHvPOlydnIsxuzyIXnr+XPmUaE0RGUgvBQbIAx/tL7KP3xgGaCjmJdZ5mmHoKQ0Nqi09rfe8p+pHfRcsqD+m+Nw6kSfYUjj4G2OFOmNgvyyTfj/D0hlYKaSNzi5ApmRd4kUkQ6AGpHEUagNcnu6UzRmzw5AvNhc8bNqiC5jKvjLJVQQrpDFIe+JSdd0a/43OaFTRtfYEcNNGhRRySKv4BCTERyr1EVyCzxLR+FBzhkLo1FEb7uu+EyvlQ4FBfeXpddkDQ+KjUzajSJ4UA8ef2jWRM/+rxiB2ZmTgyKYCePDZ7BLgNXFpCjbcgPsVWhWv2BST2i0TcTQ70BTu//hH5u0qv7hvdjTr/FgCCeFe7u7st84/sIuFBmTW+flX30QJcWFqt7nKZ4pOxzzpp222mOYa5C8aJZG6I44U/kUhMORtE1S+wEGWZ09qvqCoBCpjY/eCvBUsGLGMSgdzXvaky/JCsdePHtD3h15hrau40r/yf4t0NBEZcdrNzTFHP3AggGtBYX4tvGaZId6qKZ62/F8AZsCkrDB1NOtteFQH63mVPvMzx1LIdXZDxKXwDSp/THuy9V6PXb689wkpSA9z7MqufeaFMYVnZ51BFOPJglaw9F/5cgL17tO3PaMElt+8smjcGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(83380400001)(2616005)(8676002)(6666004)(38100700002)(316002)(4326008)(6512007)(86362001)(33656002)(26005)(36756003)(186003)(1076003)(2906002)(6916009)(54906003)(508600001)(6486002)(66556008)(8936002)(6506007)(66476007)(66946007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zX9rpdTIlEZcmo5enejYD9zDml4cVHNe6uCjfLzCIbQ0RpkU2XeKU2XLyPge?=
 =?us-ascii?Q?9B82PsqHFNwi2lW9pgoNZ3AM5vnZxbLSsmDQ2HHLyMXaP4lfpBFN/Vbf49tM?=
 =?us-ascii?Q?KU0Ee0XS2RK+CSohND7bkeIEIe8riEn3DZ3PXhAxYrRSlDjpAzgxsQsAWLWN?=
 =?us-ascii?Q?EnfboKephntbX40osEhk6YY16WKCzjtEhfF7CTrvic0k3/z3Csbjck4qPOGT?=
 =?us-ascii?Q?3t/l0ZiC136klyGeXwvv/7Zlncgk+5KR8XfVyqabyoHbker984CIytGNLao3?=
 =?us-ascii?Q?uJ3LAaW0CEepF7owTtZtwzyVVAmPhieRolJ7eP5TkseYGm+cffvmsGDSsRud?=
 =?us-ascii?Q?tdwa2MB5RqM0bV9RHpkhJKc+jZfa8XlxPPdr078pCD7c/OTG/bvXAO2/H0B4?=
 =?us-ascii?Q?mh1+c4HuZObQF5PwWHcHDCGMd2pV3lavDK3ZRTvjwX4bCaG37iitDwNAcWd8?=
 =?us-ascii?Q?bcoLB0MdMMi74hOdaU9DiO03K6Oklh68vL6+R3aGcaN5FwRIADSrupTuGxQY?=
 =?us-ascii?Q?KbrALYsUmC8CKvOPfo1as0hbaFzUyPsQfAvWSvfbDqfKgx0j9xZ/rzs4YyLi?=
 =?us-ascii?Q?/IU8pbNXCPORRbiKkpTmMaIr31+FuLMxE5NwCilps2th30f2vgax0kiJThtY?=
 =?us-ascii?Q?KYvHO8BeDotKv1UwmlJNyJx9nn/ia68pMfmwra/wPzLaeHCQQbN3DLkGVqoX?=
 =?us-ascii?Q?NdBXcAYtUr5d6BBg5q8oylIFoA4/Lz29gcZHhmwzMDchoN2DhnFI7o3fpHK6?=
 =?us-ascii?Q?8plxkTj1Efriy50sPdhz8ZjcNOMgsXldXHE5/pPGhORWwpDhaGt87McXmgHr?=
 =?us-ascii?Q?yzTs1vMYhz9D3FFAGm36EOagKB2K5gyJ6wfjUAekbJtQWDO4mTvvkrU9IMJb?=
 =?us-ascii?Q?mQu5nsyu8UiCCD+cenDqd0QAOTaXzzcxZj/RNE5kkmdp+885hMlO8Kcyvfki?=
 =?us-ascii?Q?2xPLpu2wvUF8nqjIH6aInNJWpqQ4vh+f62dL+tepcS+NrR46H6LDBjbAZJ/I?=
 =?us-ascii?Q?qgOqyD2W0bI7BRk+7+sYorFC8jcZV/GxGr1nlAM29H90PYYRJj2O1jvlE8N5?=
 =?us-ascii?Q?5p+e+qM0wsBNr+GVyQnSF48u7SOF/pykCPnJ4DoTQmTDrUH2vQwut7OvgH9X?=
 =?us-ascii?Q?KGiLe4+EHuJrt9cUa/qduGu2uYbbxTBQiTmnFxBDlsvjM5f9SKuFAsfE3Qeb?=
 =?us-ascii?Q?pSZxCQ8l34wTZpbAD0mf3QDJYvcPc0BGqxeOfzxPPNku3hwpCCEaC7ziCx8Q?=
 =?us-ascii?Q?tPBhIeVEVZ1Db6TueChohzY10vUDuELF5yBYy0rHoz99DxIf9C1fSW5xiQus?=
 =?us-ascii?Q?ebnVqh+dy8MkmSgEBBBTrsC5Lze6C7hdnYebvgqUwOSKxRhGhZJb6f3X83cj?=
 =?us-ascii?Q?+S4IgA20k6YGa5qbFp4FtQKa1oS9+bHbKwmq9ooIvde8D7mpZ1wmLgarcubu?=
 =?us-ascii?Q?YpEr6vB7ajSMrDvza9keat7+S/Z0GohvqnVB4xoi74B+SDNtANsZUvjjbM+a?=
 =?us-ascii?Q?eIRDBQ2tT0p+vj3/QZqtaG3m5xUhTLp/BZV0voS3kAz2IItmE22LtUX9HNJb?=
 =?us-ascii?Q?dP3N/pHCe1OjkEshjv8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88785956-3994-4f2e-d4c0-08d9d1736a21
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 00:19:48.5132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5bLsXlVBGox73VGUMi2tt8syOAImiuNUsFuPRSUzzF87LyJYySCEUl0Lw0NDtWkm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5378
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022 at 02:05:27PM -0700, Alex Williamson wrote:
> > > Yeah, good question.  I tried doing it that way recently and it did
> > > improve performance a bit, but I thought it wasn't enough of a gain to
> > > justify how it overaccounted by the size of the entire pin.  
> > 
> > Why would it over account?
> 
> We'd be guessing that the entire virtual address mapping counts against
> locked memory limits, but it might include PFNMAP pages or pages that
> are already account via the page pinning interface that mdev devices
> use.  At that point we're risking that the user isn't concurrently
> doing something else that could fail as a result of pre-accounting and
> fixup later schemes like this.  Thanks,

At least in iommufd I'm planning to keep the P2P ranges seperated from
the normal page ranges. For user space compat we'd have to scan over
the VA range looking for special VMAs. I expect in most cases there
are few VMAs..

Computing the # pages pinned by mdevs requires a interval tree scan,
in Daniel's target scenario the intervals will be empty so this costs
nothing.

At least it seems like it is not an insurmountable problem if it makes
an appreciable difference..

After seeing Daniels's patches I've been wondering if the pin step in
iommufd's draft could be parallized on a per-map basis without too
much trouble. It might give Daniel a way to do a quick approach
comparison..

Jason
