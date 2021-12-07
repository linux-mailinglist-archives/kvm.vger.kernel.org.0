Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B632546BF9B
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhLGPlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:41:18 -0500
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:32481
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233950AbhLGPlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:41:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+pYxyl+HcN4oJzIuRv8vuikM1pJ6ALWA0xpNEwxtOtX5Grmr8nvanUORedd7J1Lyedw7gAzozAmME67SuolR7jCoZVSyaqwwM/xW2Y8iR7ZK/Dd2znebEi2i0HhesEFIP53KxWOg2UbGJ+uUS78jjxK55eR7D0URWo0J6ndVUG1RDw4emAQAJuT2UasgLJQk1sfgdKzBbaMEWBM40z7BD/VPIREfKd70uja4pU2oDiMiwHVd0dTgQ+ed/rmrYGZfNZoxQt/jcdNRusjH8hFu32GtiG7acV5XVHwRnG9NfaIzU1jloP/1Mvl3RFWuCtIrSEmB522oLSfdV0CNOpBRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrPlhAXjwU4Dv/QL7bbLgO+xcMM51avC/ipjF+YQI8k=;
 b=Tz21fr+ZTxXqJVvEPPIWtgR0tiNV8pbpIjzIjgfih9kl+ncRmX7lx7EUvBhvHPRf5kMtP3dqMHYMO7N4C0qt/lvewVyTRTUpM0P3u1aV3rrDjvGun0aYofWe5a+HROZ2Ge+0JjodyA+MjbXGcTrHh32xokXGsokb0AchOMZLWU/gn/nj/iqIohmDJN20bxp8hsZGzeMOQ9N+SwdO9zzLSoeFH8msZwnNadMh3ElMxZDytYmzDo9SwdqOK3tLpKbWe6L+7E01Ps4KmBdf6G6GbiFVTGurllziGEzEapZLeg/atdFvPgoi1A39EZQMrC1fchIZ9O/1jeVINQY4fTgN3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrPlhAXjwU4Dv/QL7bbLgO+xcMM51avC/ipjF+YQI8k=;
 b=OsFFmxlZDLvgHZx1Mbszlk8o4Soxcg/Lc+FH0R/gVaQvhNw8cEWoMarmcgDgG4dzR4R+R1XI5vnULJ0JGaABfc8de3GLL7L2HiWCpbJJuARBqDi3Zy8Os77XAl4sPo0L99jk0S7fpILk1Wb8fPRafmenr9UySnOUkhdel0+80UL9sxWoOcjQ5zvayC7bW/LmxX2bSzt3MHhBGnjblAz+2eboLzt2ECzC0tcuh8L2yxVVBu6TR5HkQSemKlyPtJKUa4kST50NcijvrveTbLYAhIkcR3oPGvZvKxhmq9f8SfIZDmmHtz5NPf0Zy2+LgEJHlvVDEDJaUCXgaf1qgUVpgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5240.namprd12.prod.outlook.com (2603:10b6:208:319::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 15:37:44 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 15:37:44 +0000
Date:   Tue, 7 Dec 2021 11:37:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211207153743.GC6385@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
 <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <20211206191500.GL4670@nvidia.com>
 <87r1aou1rs.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1aou1rs.fsf@redhat.com>
X-ClientProxiedBy: BL1PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:208:256::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0005.namprd13.prod.outlook.com (2603:10b6:208:256::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Tue, 7 Dec 2021 15:37:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mucXH-0004Gl-4c; Tue, 07 Dec 2021 11:37:43 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e67be2a-f122-4396-079c-08d9b997832b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5240:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5240AE4BE9EF6F359601A8C0C26E9@BL1PR12MB5240.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LY+YdFC05agaDIckUzkoH2Bmf6eLV4cmsPnNpDdPBwZfQLQmbzXnPKuG/ovVdL7yJIusckY4NjNIGtu/wni0MQn7ED2RnABedEWLklDt2AVmrNgbPYIj6+FaJqZm+FHnFeL22qFQkJOfOqQ29bn44IRlOD7mm2sslYBWXaO9t/44UC7QXHhyHyhNpoWHilyu2y3Ngh3J42YUz0ls82ls5NWdbRGlM9Jz9kEeGrsusgEqnEKWOjHwMZxCxxBjv/ZkEw18v2STF591QRa+cp7pvGcl0nVvKTVnlG83PPda3Illqy7vRIx91prPp7eErZi2FnHUxp4dOXI6BpTADViRsOATpFKpjMk6yKy2pmG+gDXPocQoYBKV5PVsZA0PUxavcvLV2/IM30Qci4jHjqndGJqBQUnISQ8ui/pKGfLDnDHIOTBfpLKNyQy5/rY/HbdpkXqOF6iT9shY+BjgWVSTDa2z/+ZGNdHwzSY/UNBXhULfVldx5U/evSXH+1VzQMz+c5HD5ZspmqWdyn5Q4pqiahMjowgHMHVd8o3FB0Xi9owGJSwyx+2ijCaG/tbW6hqhtJ+Fr5s8ry4WMA1pLNRZAtrj3zv6rYateww3UuTEH7ZtSLy/KEipGxmqWQk5+5b38M+TZlEcL8maiP5gpnnUZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(66946007)(26005)(66556008)(5660300002)(66476007)(36756003)(508600001)(86362001)(1076003)(2906002)(54906003)(9746002)(33656002)(107886003)(316002)(2616005)(426003)(9786002)(83380400001)(8936002)(38100700002)(8676002)(4326008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ST6PcKxQ8nKBKreEx0HonsOMnzo2GaacBzke+WwKh4HSwipWYEowgDYCWMkj?=
 =?us-ascii?Q?EpyW9HcgugAhAcTBfsr+2AC2h9x1Q4i55pNHeQzIkyJ5/5zbjW8mpiN01UH7?=
 =?us-ascii?Q?wfEyd0vqdAteKNH3NCBU/Ir5j6ZzsOSS9c33Ew4WuhaIXmgTL3IiiFLiUa7B?=
 =?us-ascii?Q?OTww5sFlwheWUJoQLDCXgwa7xsn5NIu5+lLZtrvcvnes3k8WDdc5lUXVPdDM?=
 =?us-ascii?Q?rKtm0OCP16JX0lngPkLJ5Z8rKtF59RXtc37u0vekhtQWgL5arVWCicoL0qdX?=
 =?us-ascii?Q?frCeDgZWv53Yf44GNqbr0Yk2GZ+9rHVrsuf7rJ88SQUvVbNWB01RLmbbJxdS?=
 =?us-ascii?Q?6Jr1XgnFTAwhSpRMQ1y3dKRtE9SJPXK2N7r+/pxyJsKuh+rOh71tgyBWCR/x?=
 =?us-ascii?Q?KC0OAt83lKVMAKvH5lUhqQHC8q6ZJYgdJs+UKxh9eMebO0p/Y6tzqSoQdr4t?=
 =?us-ascii?Q?Udnql3EbVY4gu+ZKzGxHqtNftl2AzO3ZpfRhdGjfhfACyX8nKIbh/nNBhloU?=
 =?us-ascii?Q?U94rpZCnZ5o4+282Czfz0J+bWMxrYLGqFMS9QcHx+PZLI9WA0LjvHS9egt/Z?=
 =?us-ascii?Q?aPNp/eOld4Ee5u+DJh3RH2ISm2l51NbU7XHKf3KKZEew1JXLZNxyQAQCuxTD?=
 =?us-ascii?Q?l7liJSr/yVnTrSpPM6cG9Y5LU8pnTbQpz+HHGJnSVJibeBGMZoffd0EojK2R?=
 =?us-ascii?Q?eoJcLm87/Av3y2w4T0KQlgKsQBD0MbgdvusmYe4oSIPbQPEUn8ivVS+OX3bD?=
 =?us-ascii?Q?KRNBNcKRbF6ncPzuU+/Idt/tWwQwaPJEgnucbip+zL0r9G9wHzzQmOOsXN99?=
 =?us-ascii?Q?HlMV9bgUYk9ihTmRioM8xJn08+S3lDHIEOTFC9g6eqTSHDIV6H4+HJNsPUTh?=
 =?us-ascii?Q?FbTNyh+NT3Z6NhtR+AcMOm4dd13duGkPJ6NSVUq4ke4DSV9uJR9EVsigl9M8?=
 =?us-ascii?Q?BsswTcrQIokGEliHXDllEbOHVj//nAh9lp9aIzQ1Kip73jzkp7qhES+v+1Ex?=
 =?us-ascii?Q?9EJJGpi79qRevPyVj736UnE/pGMVbhf5DAMlQPt2SxGgTGswMVCZkRMorfG4?=
 =?us-ascii?Q?CVhO6HKfmdKGhdjYDE0cPHDepOQlhMQodvu/siAUDshK0vNJfWyCYtJRpML/?=
 =?us-ascii?Q?FthzBwqcYyDgVrTtWmn7ADV5OGiavAJVZJAl8MKU7xnbskDpnLellDirLGNK?=
 =?us-ascii?Q?AHqLbI6btDDwevkBOa2QcAxuNJoYWzpzi4q+o7MKP69LuarB5o65akcEIw2q?=
 =?us-ascii?Q?1cPT9g5ru+fxN7F/wWJbvLR+Xr0z3x1vPT9GZgPFFKuSVT3ToFg+X3ArjDAy?=
 =?us-ascii?Q?z3GVOwgTjLM5ym4+1GdVgJBjd2YffSnRltzh/MR9JLVJUXEyugq2t6/4Mm6H?=
 =?us-ascii?Q?Nh6FqM/vI/oRI66LjavshXRm3l0msSUjOy5DuHuUH4lTkuLJhjgxjbalwyW4?=
 =?us-ascii?Q?V6zX3rNy52PTC7ECdzHz0C923OWZ9t5LFwhEc7cWhGEcyUp4RwcDgl6CP4D9?=
 =?us-ascii?Q?sjTEqgnjoENNiKKuI7Z+8UwAWl/Bhi1YjIANuQeEWGdMiXChrdLSKMzXt8Ky?=
 =?us-ascii?Q?oaNYz1bsTm4kY//r554=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e67be2a-f122-4396-079c-08d9b997832b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 15:37:44.3502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4aUAiaY4xDoPmEkcn72zrG3aDFoiUA0MQqiJPE/qL9vKeQM4rzopcUVEcd/+EVvy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5240
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07, 2021 at 11:50:47AM +0100, Cornelia Huck wrote:
> On Mon, Dec 06 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Fri, Dec 03, 2021 at 11:06:19AM -0700, Alex Williamson wrote:
> 
> >> This is exactly the sort of "designed for QEMU implementation"
> >> inter-operability that I want to avoid.  It doesn't take much of a
> >> crystal ball to guess that gratuitous and redundant device resets
> >> slow VM instantiation and are a likely target for optimization.
> >
> > Sorry, but Linus's "don't break userspace" forces us to this world.
> >
> > It does not matter what is written in text files, only what userspace
> > actually does and the kernel must accommodate existing userspace going
> > forward. So once released qemu forms some definitive spec and the
> > guardrails that limit what we can do going forward.
> 
> But QEMU support is *experimental*, i.e. if it breaks, you get to keep
> the pieces, things may change in incompatible ways. And it is
> experimental for good reason!

And we can probably make an breakage exception for this existing
experimental qemu.

My point was going forward, once we userspace starts to become
deployed, it doesn't matter what we write in these text files and
comments. It only matters what deployed userspace actually does.

> It would mean that we must never introduce experimental interfaces
> in QEMU that may need some rework of the kernel interface, but need
> to keep those out of the tree -- and that can't be in the best
> interest of implementing things requiring interaction between the
> kernel and QEMU.

In general we should not be merging uAPI to the kernel that is so
incomplete as to be unusable. 

I'm sorry, this whole thing from the day the migration stuff was first
merged to include/uapi is a textbook example how not to do things in
the kernel community.

Jason
