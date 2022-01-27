Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9956C49D728
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 02:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbiA0BLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 20:11:09 -0500
Received: from mail-bn7nam10on2051.outbound.protection.outlook.com ([40.107.92.51]:41920
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234330AbiA0BLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 20:11:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9wOxQlyFrzjuJPZroKWsY274GX+pZs/3GZ5l0/XnhjVCPVke5LJ7lnccYcsEsJO72cfj25tiAXhkCed6UP3k0nYGxXeEFqy2rboXQxDUP/hQLqctlf1uY2ft70bvWegrtl6PjFOaF7m+LeJZz2GLZiDY4X9PdEUZa345KUGxympsGhusmxXQpbO/4rAP5Gh+5AIYJvI5KtTucayE/tYpLfG5jACjluN0CKdZO848oKZNsweqQ48Xdg+UAKhCI5GsrWUU7pt98p7agtxoEmlE9dvgqk5kcvcxDymqXh82L6LH7i+9xW67si3DhA8RZhwqioAMnoyPJbcwEJTa5I70g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R1VIHUfdgbg/z9Iizo/cIAib8Mx2IuDrRY5+u0xuWP8=;
 b=PQ/H8xeF+O0NtSKnN0kslE10ai0oK7BC+wge3e5/RrdNmewYd5cT2QVC5qvC4KaYPA/eSmqCm+GBWzwkuF4qgWVz+Sz5GB+CL6WM4Kg0y9PBHgffu5+QMQLeJg2dK72xtc5j2+3eQfZbUMDbiwPWIk8AixQuuRQq+39Hq+nL+SNydBkltwvRZQgValjaaT0nNBTPttnmwf1RnguKdwoSwnSlbhTYQxiCDpor1woBppNV17eZWV98Rq+58YF7RC3AIfsXCA9I5/Y+eQ36XoP4cidV4+EGTp4MgBTqZDzufEETjMdlWo4apwhnAkkk392lDKpy8IjHBxByEEovNp1qog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1VIHUfdgbg/z9Iizo/cIAib8Mx2IuDrRY5+u0xuWP8=;
 b=sZTUOq2nzqYQS+i4oDVpkSqblBITquBbhvS5U0KfEmSEczuFtwN2XLpq5PLrKbYcvhma78VUfZshWyG0YuyZs+An9yoQG1DfWpmhDTYhqVAe66T6RFDY/Sfx/vz81Ylg1DLrbDCpOGzIDCPb/xdo+LWX2HIAdHq27r8F5M74OcGQJu4FrzQXQ3GXt7tCJMbr2AA+Oy2ZW+AY+FbhZ/ZmKPe8qw4Tifx0mIrW8Vxs6u1lFCRlaZ+4diFs4EbIx6NL/3YTKBj41tom/IoW32OG443dEFKN+DyKBoPjuogq4a6dY9NcBnGVmCHLUVkTmsn8uTKpVKM+rwYiYncMaK8a8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SN1PR12MB2591.namprd12.prod.outlook.com (2603:10b6:802:30::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 01:10:59 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.015; Thu, 27 Jan 2022
 01:10:59 +0000
Date:   Wed, 26 Jan 2022 21:10:58 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220127011058.GW84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126013258.GN84788@nvidia.com>
 <BN9PR11MB5276CC27EA06D32608E118648C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126121447.GQ84788@nvidia.com>
 <BN9PR11MB5276141AC961A04A89235B428C219@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276141AC961A04A89235B428C219@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0102.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04247567-0024-42ec-aded-08d9e131e0bb
X-MS-TrafficTypeDiagnostic: SN1PR12MB2591:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB25913E0FF013FB7995F4ACA2C2219@SN1PR12MB2591.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WoLhaM9WE6q6QXUSit1ZPOZAliAn6tzito10JaK4Y+t6pxgaUdTVbuTxGBJysOUq018nkjhUH1eHjG3jh8M7o/Iny+jisFoYrZSgmEPg4TMNFk4Ue7BCYOh/ACx1ZY/QfigG8JCVZKxpSCGCXliCswjkCZEMgFPry4SJXNg35XiOKdSclEejzIUiCUnGSv68hFIu3K5zTbiZQmngAZyeu5E8jTKMjVhwYdlHbr195oSwvM3kHRIKZFLwZgore6pxZ/nYcEwSAd/B1U+S3bp+iUdpv47be1vu9QNti22VTukT+dLe4I2QCxXez6FKUVgtgd+RoRogkoq6lJ3WuZ41uc+HuvqRSWWKd3mVObgpomkhaoyiBWSpyVOqdREs79ayHs1LysZ2o2YuzL/+99MzrhfWiOS4eoRlzorN00tegLwRCRLdVMa0LLB6DPNz50BkLk7048XbOfOHbkpKQS/Fy/5j4sKF5p4Q6AGj4aH5rfR1nuqjMZXEOCFpwqPS3E/gSnJ8Xl2pXwGs0gRmhUgMDGglnKotNIHOHMcyRqxq1F7wVQ7TNkjoJpcpZMsjXg/Vt7QFDobvOY4NL/46BpGUxzmwVkw8rhcCSw+0RtqxlMsrIWikWjrqLTiHjHDXtMx2L3fsnNidwztkjZUqYbrwKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(66946007)(2616005)(6486002)(2906002)(6506007)(508600001)(36756003)(66556008)(5660300002)(66476007)(83380400001)(4326008)(26005)(107886003)(316002)(54906003)(6916009)(33656002)(8936002)(8676002)(1076003)(186003)(38100700002)(86362001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gQN8gSEp5OeAxd1neCdq0rB8SE8X8hwuBE8L6BvP0xJM3e9IRW/rTSOq2jAn?=
 =?us-ascii?Q?XVa788GRsnlBmZlfOtcjYfDP0OUbpSHxlxpv7wsHgy9jb9iolR2XCOPmRPw8?=
 =?us-ascii?Q?/R1BEhcjZOn5Yfq33Ivx8AixOVKCjoj7j46m1p2ts+JdHIT5hkjdb1heU/qB?=
 =?us-ascii?Q?KOfCkoqjuoDDC+TV3J4a76Z0n6ADwEajc4HI3cW7T5PML1IUQ4HPkK4iZbn6?=
 =?us-ascii?Q?1CTPw/H2vh3wbjToSEN0R9Ydn030h757Tcar3nVzaL4O8dU3J2d3Mw19AjkR?=
 =?us-ascii?Q?z25ykqTITY5Ieua1zVZe/Hqw4c+lHzTRW/KsIscfb+jSKMNG81lRRC+KyJfR?=
 =?us-ascii?Q?wnU2tbZOCRpVUL7sAMbbqRWJIszGweqUmXapDLz/aP1Tx1cL9MumVawLYTBC?=
 =?us-ascii?Q?k1p/6L5JSZurhF57mr2sMehzCVkS0BRwBNJJKAE8OsGp3ZYTJcJz6Rmhutl8?=
 =?us-ascii?Q?DiapPosToDojOLn0mpNUZow2+NRQvnfSHx4IxNtLtm+msgONBUCEzxwmhOCR?=
 =?us-ascii?Q?B2vSMcOan3Q2ZOF6Dmc3twfXIrQOP3PP0+AsJeLuNaYNTEKxgLrsqdxuNiGM?=
 =?us-ascii?Q?iMBzvAveBQPBkQfv3RckPV2LbXtHutMb1W4JWE0uL/cJmcQ9hHxG7MKTJoK+?=
 =?us-ascii?Q?Sz+/793OQ2MttaLTn5ESj7oBj3S7w32l/8NqAsnDvyFtfiV9U/byvdqGgTlv?=
 =?us-ascii?Q?0TYr9lZZCO0kUsvU2WmpPkJCMsmPf1b8KgkKKHs6y23Ym4B8Saga4QC4bHWP?=
 =?us-ascii?Q?HlGuRXmPmVOZy7J7ZON/PB9Azm+632bJkH9dL5bt8twqcl94qRwVFp1JmlZD?=
 =?us-ascii?Q?Iq5RY9QC9pE55jM2x5oJklDoMGoh0Bz0Mn1uQaMLU0gN4LQoPnzFf4gFuJyT?=
 =?us-ascii?Q?uxTSogVeglyVulL+e3xOhhIxXyeIK4xyr9MQxKrueioldkDZBThFXkI50Ndt?=
 =?us-ascii?Q?pZ4FS4wcJBuHSGGwe9d/ismyhVAxNMmXiWbFjiF5jTrRh+vUsXtOHrXWw1kK?=
 =?us-ascii?Q?9I946iHjZhiY0qwXOZoOjzGHSasMexFWGnklqbGCdqz3urNuxXFhsd65dkEZ?=
 =?us-ascii?Q?RRykx1xHPKoHnvp+cADfLe7PuaoixAOx/yD/BiA+qYdqt2vpijvr69vnH6o/?=
 =?us-ascii?Q?ffW30spvYG2KINh0lymZrPLkVJS/365eshcjd0L1+hRPA3YxztQ7WukRaDZl?=
 =?us-ascii?Q?H9Z04Yu7aPgBtidfD/pUvVCQIxcCF7Ik/SEXonlRQvTJtwAw7YjutiIUVv9Z?=
 =?us-ascii?Q?k8rsEYlZFKOFRshzZbS7rDCw5RAq3inaaoIhZ2KkrotsNA0Ka3btscKzO8ZA?=
 =?us-ascii?Q?ltrVojiZuXObZmQ3jn7XfJEB5nGdwGRtLPMc6TO42Ez3/PhoHE0SoeerMWga?=
 =?us-ascii?Q?rHGQiS1ICHz9gRu2fmyn5RhVc92G3+etI5vddMkv99E+BaNVA9UZqpQvEvuA?=
 =?us-ascii?Q?Hj4urWVT8BHOfSYCUWQPEUiLRCjJwCsIOjzEjTqDVvZ+oOD40oLP7m+s8aFh?=
 =?us-ascii?Q?UVy3hYO7YfsDlnwkBm45q3cSM1PpGyPqAb176Z17IbLuwYtNbIItKfJQKz2r?=
 =?us-ascii?Q?AcyaIHXeyUmtlI8Txpg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04247567-0024-42ec-aded-08d9e131e0bb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 01:10:59.0772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pn1dWvUyN/klDLO15MDzvlRrOLv7TlvaUVSCU/Ku+Jo0R1H/64rbqvFb+ASMsmx2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2591
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 27, 2022 at 12:53:54AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, January 26, 2022 8:15 PM
> > 
> > On Wed, Jan 26, 2022 at 01:49:09AM +0000, Tian, Kevin wrote:
> > 
> > > > As STOP_PRI can be defined as halting any new PRIs and always return
> > > > immediately.
> > >
> > > The problem is that on such devices PRIs are continuously triggered
> > > when the driver tries to drain the in-fly requests to enter STOP_P2P
> > > or STOP_COPY. If we simply halt any new PRIs in STOP_PRI, it
> > > essentially implies no migration support for such device.
> > 
> > So what can this HW even do? It can't immediately stop and disable its
> > queues?
> > 
> > Are you sure it can support migration?
> 
> It's a draining model thus cannot immediately stop. Instead it has to
> wait for in-fly requests to be completed (even not talking about vPRI).

So, it can't complete draining without completing an unknown number of
vPRIs?

> timeout policy is always in userspace. We just need an interface for the user
> to communicate it to the kernel. 

Can the HW tell if the draining is completed somehow? Ie can it
trigger and eventfd or something?

The v2 API has this nice feature where it can return an FD, so we
could possibly go into a 'stopping PRI' state and that can return an
eventfd for the user to poll on to know when it is OK to move onwards.

That was the sticking point before, we want completing RUNNING_P2P to
mean the device is halted, but vPRI ideally wants to do a background
halting - now we have a way to do that..

Returning to running would abort the draining.

Userspace does the timeout with poll on the event fd..

This also logically justifies why this is not backwards compatabile as
one of the rules in the FSM construction is any arc that can return a
FD must be the final arc.

So, if the FSM seqeunce is

   RUNNING -> RUNNING_STOP_PRI -> RUNNING_STOP_P2P_AND_PRI -> STOP_COPY

Then by the design rules we cannot pass through RUNNING_STOP_PRI
automatically, it must be explicit.

A cap like "running_p2p returns an event fd, doesn't finish until the
VCPU does stuff, and stops pri as well as p2p" might be all that is
required here (and not an actual new state)

It is somewhat bizzaro from a wording perspective, but does
potentially allow qemu to be almost unchanged for the two cases..

Jason
