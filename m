Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D05F48B599
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 19:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344628AbiAKSTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 13:19:46 -0500
Received: from mail-bn8nam11on2080.outbound.protection.outlook.com ([40.107.236.80]:4889
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344961AbiAKSTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 13:19:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmUQbWzUDUbBtCJmEENu99yV5HOFM58pHlovO1+1oGHwqq49wRumrJCyExfkZgOwcl0y3r6M0yIxKLdKgfT7CDib2DnvIwvyqnUIsHcQLkKWdb3CNTWDqmgTv3wsn3B/iOd87P2jyXk2mHZ1XKNxy9+L9YRZiVBaGoUGhCzIqFBiZlQYwbATsheThaOCVOM6GK5Fq3bpT+S85C8nu8fiCHn3MFbkZqds3VQeyWWnLhil0wwI03HT+P8vF/qJ0GiI4bA1hm+GVo49hhgODR1v0B4aykTsMdWOjjTSzO3TZXS+whswyYrMxIOu5f4LQ77APXYXqnK70kclCYIAxqJ/5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wnAutoPfVH/7sWf6utItOM6PKF2bZ14C9r4KXbPNPIQ=;
 b=cNGlCBhsoOnIfK6T9+Da1u3dgh8C8KPHO/PAqfxrsUmXdjV3rbQx9qx+d/fJrf956a6vTkYHRA+oztuyq2YcgkjTQXu3WOjgLRAfc0HUifsjvjcia6jvuvWgUNXB1039/GhS2RiOph0hB/xTUyTC8KcTBbv/Qxjc00pjo1aYkiEnFQLu4Nw9PH9yQHU7TxIH4IjUqQJMlfaMQMQdTzvZcLLQvyAsJCn2LOZUyKtFom21rMXLdH9oZizSKOVtU31VPW4xIyk+LfcpD7UgtunWnJOBsgk6S147E3IaCR/lZB1ooOR0tZLQArrFamqSTWpO/sw3SicXXtOVWamCZeiM3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnAutoPfVH/7sWf6utItOM6PKF2bZ14C9r4KXbPNPIQ=;
 b=q8q2dVCoF26K1/o142/0R3EKZxtiLDzqoV7zpGMl+OIcKnCebS9DSuuLwdcxIFA9tp9lS3MtbvLZP4p4eLn9ShcZxLvv/3mltrEvrptaFpXLd0Q4xMnTApVkqrtBrio7hfXT22EHRS1onROZ7A8H2wSmB525lwx+g95gB0cg+wxhVl+vCHSbFoYqErrCp2VWjxWHg2uwA44UXppOv11gBvMwDJD4KctkQw1dPGgHZqM8evdiepF2C0/b/39k6GEZn8v34RMsHrMiRoFUS/0cKh75Ydsi+349hYAT6z09osfNXnyLnZzOJoWSi1SyOITTB+VRgGtDvXuyoNPwEDmfag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5556.namprd12.prod.outlook.com (2603:10b6:208:1cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 18:19:39 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 18:19:39 +0000
Date:   Tue, 11 Jan 2022 14:19:38 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20220111181938.GN2328285@nvidia.com>
References: <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <20211220152623.50d753ec.alex.williamson@redhat.com>
 <20220104202834.GM2328285@nvidia.com>
 <20220106111718.0e5f5ed6.alex.williamson@redhat.com>
 <20220106212057.GM2328285@nvidia.com>
 <BN9PR11MB52767CB9E4C30143065549C98C509@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220110181140.GH2328285@nvidia.com>
 <BN9PR11MB5276CD4004B789D004C8A1488C519@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276CD4004B789D004C8A1488C519@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR08CA0005.namprd08.prod.outlook.com
 (2603:10b6:208:239::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31f57129-417c-4f43-5472-08d9d52eee69
X-MS-TrafficTypeDiagnostic: BL0PR12MB5556:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB55564218B4B9BF1A8F587F3BC2519@BL0PR12MB5556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 11cxq85q6vByYTqYX1Da6WJ3meMh649K4uvnjD5/iCeNjfxNDHL2a5717lVXcCRw0imVY+C4zflhJuvPjbP4clsavP4m9urPWhk5Pzbqu+GLgcl8y3ZQXVBLWfUn79vgWmUiqt7cjiSycaWtMGYkVWz7mtWV/PMKaDpiHHNkLftvUFy+NnbFdLoxm/jx4B/9cvEwIPvfNAZJWHiEYftzJVbKheW6X3Q+VplILriekfMXvAHLs3azHYDAdsbfQ8VikDlErrxqGkHbGgV+2HfbtddICqgADHngGEDPHMCnhzFOXSEccp6xLtKVVkngE23gpbzoB7iteazgif1cHEqAiE82EcVgRslvEptXImfsVPu6iRiC60xotz1b3mA19xraqvNpS830efxrPyRCf3QVWritihVBNWqGIZFaPz6vDd7WZMRx68tYbp+Cwr2AG2uD40SGsV+6zTsKhKZLjtLWEvUjSTDSix6od490YrrJJBsYkotLtEsxndbmYLEGvunXr1mrsTG31M6+ZemNVw4cUdInd/pL1OrASoP1Ex/836x35TaF3J4gx8JZI5JrtW9E4pR5cGnop8TD7ELscNz8/VRtRL17Mne5O/90YeSwE0wXOMbXQyh573N34TVRVYUmRtGurrg9/aN4+MjaKNBZ8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(1076003)(6486002)(6506007)(6916009)(33656002)(8936002)(6512007)(508600001)(38100700002)(2906002)(66946007)(66476007)(66556008)(8676002)(36756003)(54906003)(186003)(4326008)(86362001)(5660300002)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PeJ/wTuyVC1G+/bDNoPuAvLh8axOj/wzdQRIWBXLt31afNUSeuja/IiMI31b?=
 =?us-ascii?Q?GNAOpF4ayS28fjFGLRXPnl9MeeaZ4ZOfZ+X8vEEmWIzBJU31//cT6+X7sO2b?=
 =?us-ascii?Q?r8dmI0CJSNAyPShRqOw3wK5+mgj2UG9cOuXxliZemxa+3y6gXPOKkzQK3Nk5?=
 =?us-ascii?Q?bpZmitQRSmpuU5vBqmsRrzi9P9df3wNZkEO60x0AyOs2snXJHRK+QvtaeeLp?=
 =?us-ascii?Q?NtC6O4SVUHyu/pmOUo39NnI4peXCiho0JNcncAK5T9YkkukXrh0MRk+fnamc?=
 =?us-ascii?Q?3sdwwBHjptVWvft0gNFVJYq+L3GpAo2F3ldjvIN29eRJV6rWUYgFfVglc6C6?=
 =?us-ascii?Q?kmzbE0LbAh5sklcfX+cgeckQxT2YUEgYToVYeyIbBA5lLYVKXfAKrGj7/QOS?=
 =?us-ascii?Q?hDXnFr5CfHt0MOO+gxOJ241ioHTOdeoqT0hqDamSi4bkz/Izmteaixgx92UG?=
 =?us-ascii?Q?2txjIbmFYfel8OhbatnyB4gEALqAXYdBV21jo1rkGYS+BeBS1nN4mTP81uXK?=
 =?us-ascii?Q?ysfBEe90+a7Fi6NAOCc/wwYpKtycbtGgVFFWJTidyMjPusAjVP4u7RjlGaBw?=
 =?us-ascii?Q?PqP8GaG3YD5W1+B8dcHEEgfkUNyUDQwwfWR2WCBn++ptGHzkBBgLQ1GpiHps?=
 =?us-ascii?Q?FrRw4u82IJo7IpvAmsqvhukCKZfUlhCBGwrFDBfj4h34060lptw2ESojnU8x?=
 =?us-ascii?Q?Xj6OMr80dEAF6h+14guIBNhZTYJ103cr8P0OeL5I3ZHM9nzj1qkIN+33F+QG?=
 =?us-ascii?Q?ESp4p56nH07dbrqkYJaCYaPgr9y1BpFmtrvaYuuF/Tvlx7ZojcfpMeeZnl4b?=
 =?us-ascii?Q?dTNqr/vv/FczJbcfe+ZTL6BT6jLVnIRxjyFwegaSb28fC+uchrpH8FezfhBs?=
 =?us-ascii?Q?IFiguGJqyFnkkh9En0NsDYqjIM9oZJr3Qmz6U0C+u9tQ8swA+wvq+U6E/a5h?=
 =?us-ascii?Q?eDJekooKfljpFgctCNKYrAgC+tRkrlpF6+hLFF+OPCeMf4enlaivWC+CfU/8?=
 =?us-ascii?Q?hRpo9XM04BFCV+MvdPYrDnh2/7EQawHuq46U1/WXrRetp9Jo90efnEMCVr/q?=
 =?us-ascii?Q?+wRmD/KWXyc2jUH0oPPfo0naiiDUA7/x8Yi3/3Fjckgk+ZCM9nN2g8oyY+UD?=
 =?us-ascii?Q?D4pSyKVtVq2m2RnXbqZnj7YEqF1RyKXsaAKXp8H1VNmavrjgb3V4n5r5O2BO?=
 =?us-ascii?Q?g+QQPYzWSNtXgXhiHfrqn0suiBm9AXGr/vDrKpzea3j0V5UmfSewHkShMoIK?=
 =?us-ascii?Q?TRgYRtp1w+BYFmqFRMPLcuhhoO3/BMyY7AJXDMdgF1rJt71z7PCgvahOIjY7?=
 =?us-ascii?Q?m2tE+ekcW619VnYeQKDI5CUuIKcEVSxN9bRjN9P/6dvK42ZshUuMKNNGUfUW?=
 =?us-ascii?Q?+eiVF1ryEOYDkK24qVITznvZQFfvI3zQ0+4F/I7/b3RmJvxJEHI5azi57mwh?=
 =?us-ascii?Q?3cy21byS6wmH/l53NG+QYSNobNkeM9b+cF6wHEBhTqbUU1KbAD84mazOCc5Z?=
 =?us-ascii?Q?dTP167q/Ic0mSKBw4NYAJSOcNe0Lwk6wKjWCoAi9Vb7KeV4vwapYoDRI6TOu?=
 =?us-ascii?Q?m2tH37S0UmHj82+EGXE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f57129-417c-4f43-5472-08d9d52eee69
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 18:19:39.7083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCHBrJQ5art/rpwm+rq9zNV6NcnwXvL5WipR6QwYY2nxGTI4X+RXID+4SkPmsVow
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5556
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 03:14:04AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, January 11, 2022 2:12 AM
> > 
> > On Mon, Jan 10, 2022 at 07:55:16AM +0000, Tian, Kevin wrote:
> > 
> > > > > {SAVING} -> {RESUMING}
> > > > > 	If not supported, user can achieve this via:
> > > > > 		{SAVING}->{RUNNING}->{RESUMING}
> > > > > 		{SAVING}-RESET->{RUNNING}->{RESUMING}
> > > >
> > > > This can be:
> > > >
> > > > SAVING -> STOP -> RESUMING
> > >
> > > From Alex's original description the default device state is RUNNING.
> > > This supposed to be the initial state on the dest machine for the
> > > device assigned to Qemu before Qemu resumes the device state.
> > > Then how do we eliminate the RUNNING state in above flow? Who
> > > makes STOP as the initial state on the dest node?
> > 
> > All of this notation should be read with the idea that the
> > device_state is already somehow moved away from RESET. Ie the above
> > notation is about what is possible once qemu has already moved the
> > device to SAVING.
> 
> Qemu moves the device to SAVING on the src node.
> 
> On the dest the device is in RUNNING (after reset) which can be directly
> transitioned to RESUMING. I didn't see the point of adding a STOP here.

Alex is talking about the same node case where qemu has put the device
into SAVING and then, for whatever reason, decides it now wants the
device to be in RESUMING.

We are talking about the state space of commands the driver has to
process here. If we can break down things like SAVING -> RESUMING into
two commands:

 SAVING -> STOP
 STOP -> RESUMING

Then the driver has to implement fewer arcs, and the arcs it does
implement are much simpler.

It also resolves the precedence question nicely as we have a core FSM
that is built on the arcs the drivers implement and that in turn gives
a natural answer to the question of how do you transit between any two
states.

Eg using the state names I gave earlier we can look at going from
RESUMING -> PRE_COPY_NDMA and decomposing it into these four steps:

  RESUMING -> STOP -> RUNNING -> PRE_COPY -> PRE_COPY_P2P

In the end the driver needs to implement only about half of the total
arcs and the ones it does need to implement are simpler and have a
more obvious implementation.

> Later when supporting hw mdev (with pasid granular isolation in
> iommu), this restriction can be uplifted as it doesn't use dma api
> and is pretty much like a pdev regarding to ioas management.

When I say 'mdev' I really mean things that use the vfio pinning
interface - which we don't quite have a proper name for yet (though
emulated iommu perhaps is sticking)

Things that use iommu_domain would not be a problem

Jason
