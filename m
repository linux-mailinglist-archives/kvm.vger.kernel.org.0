Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD11245CC4A
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 19:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350856AbhKXSnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 13:43:37 -0500
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:53088
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243850AbhKXSnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 13:43:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkiysFjmXo7Mq67UF65IhqWReC7fP3SW+wtGUWjIwiJoGz4OKYNV3PaCieKhcIht78OIl8WFKGlH606xo0U0tqZ/ZJtZpkCa5c8/ZbTeyV2pyvcTXZmM0X93drsdcXqNKEkJVh/skxI66dVEoJhHCqPLqik1fBzD4ykgtpUZynD0eqVSH7AsKeQyOx7uMlaxGiPdqQqI7QYjbm61khVw9BopMtZkbNldH0x+gIMU8GFeJoI3fcW0Gc+KwG8FW/WlVjKP681cVpoF3j+HDYG00xXPsM4qqGt+IR1viAcBpCqnsBnU+nv2rQbHDRSksZ1M4cLZ/dtX2+fBGvs/2tn6Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UeDb+olG5Mm8/Zhr8lpsQLCZWYxtIT0Pqh2S1m2NRhY=;
 b=GPAdsGn/an42guBxVlOvLnXc71A1G9Wjk2lhO1GETHWH/c6e7t5wFGvQzHs0qX8Ec2NZKJFAUWESyanUwzRRBFBAisxFnBVdwikpCYNjmV5uKganSehyn3/sr8N1SensHnpIszDX/kqHGLvsTtqyM3XsVS4bCoH5repcStl/bXrYguPNrae3v0m2MUrB5p7jQBDSh3GTeb+Z9hWPldzRPBESV9sfSNgtFh+reytOv4szIn48seUfzEVofgCURZjrji9MojWOG++qQwd54peq00PIaTycq0oVx1j75fq8+FZRix57Y8kX3mS99klqfSXVRDp5qRsMWlNgWU1WVqAvew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeDb+olG5Mm8/Zhr8lpsQLCZWYxtIT0Pqh2S1m2NRhY=;
 b=ClzFQbjeNRqEoEEqOyxdnl8EjZmaidtXNCL3J3HG9CkAgHrGvCkZ/AHeS8tGHEN+sAiJna/sJbU7KuLDEZKiWvUIpMXf6f+/MqTDHyrKlSUFOJUyz1oo5pIH2rl2jNUrK+HHdRqwm+QKF7baZXsvleW3IwA/sJLNKACQZVAj7YppAKAdWNvWp+dueZSjlOrBMN1hZ846G038coSxDHKfDJn5cj8It22F7b2Zl8PpfaXgafTiFta7N2zWgEHdCvcfW+xEDxeQmQwkwk/V8x76VXsLhj8T1vmjnIVnWCzHa9U8aG1T7+R2BU/wdN6rcXH5emlTkNetaOaXuP65Z8kBEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5554.namprd12.prod.outlook.com (2603:10b6:208:1cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Wed, 24 Nov
 2021 18:40:21 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%8]) with mapi id 15.20.4734.022; Wed, 24 Nov 2021
 18:40:21 +0000
Date:   Wed, 24 Nov 2021 14:40:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
Message-ID: <20211124184020.GM4670@nvidia.com>
References: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
 <87zgpvj6lp.fsf@redhat.com>
 <20211123165352.GA4670@nvidia.com>
 <87fsrljxwq.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsrljxwq.fsf@redhat.com>
X-ClientProxiedBy: BL1PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0144.namprd13.prod.outlook.com (2603:10b6:208:2bb::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.6 via Frontend Transport; Wed, 24 Nov 2021 18:40:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mpxBs-0016Vb-7D; Wed, 24 Nov 2021 14:40:20 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d791e90-e35a-4d62-b3d2-08d9af79deaa
X-MS-TrafficTypeDiagnostic: BL0PR12MB5554:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55549059E36EB3D5F3E5A17EC2619@BL0PR12MB5554.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HbI77sy4IXkTNsgDYpMXfJi5MKh775mjM0I+mXm1HBSPtt5mQhZyyqKFJc9QTEk+WIgkCKSROmiVbQfsaqbvUVANK+THCNdLI9VdbjZUfx2uZ+HWPxbzoFPbzSjpJyTWNyTVm/WSc7DeKo/JTIt68JS6RWkpJxnwPL/uWAHcZUxlWWsTxanK3hIiXulHF1DW/bzzcSePLF9K38Ah/+pZt/nVX3441gzCGuQI1xuP65fxqYVfLcJmLYF9uW6WEwbdk5TiGboFUS8VS7KdphGoi0eKi01ATlv6TKz3j2Fr+CcywJgaKEtfxd8LwsxHqZjgpn76fhcj5GgWW3YsOemMW3O3VRzchO0/h0MEdG/vPiclBA4fP6NiZXYACYNtweDuna0gtMvNVgqT/Ze1XChnIt+sI9EW73CPWrgrVCwLkBCIeG/16g5kgOxWfpcZzuvJ8pQBtebKLgn6ehtykc0B/HlSab7zykP1SIbwjIpAVmxiOhe1Z+lvZFgRWjzxp70sSmaGvXwhTjHRFD8tH1HH4bX+YjTIY8FoFM+gdrtyPfAngS5uZ168yfkCn2dkMLL2fswcZYPmzlG36X0KJ802ITkbCVfosJ2LUiWli9F/geC2yjxjRbdaU+1a8rjd/gpsWSSa/4AEPxMD6x67y/s1Og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(8936002)(186003)(33656002)(86362001)(5660300002)(66556008)(2616005)(38100700002)(30864003)(508600001)(316002)(4326008)(6916009)(36756003)(1076003)(8676002)(426003)(66946007)(54906003)(83380400001)(9786002)(9746002)(2906002)(26005)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TxExbav/gT26B+5frGpXlehcQV0n7ME6BdAm4ShkmbnFP1ExaFQU4pD0SJo8?=
 =?us-ascii?Q?yCkfgMSM5GIYxYnU5K6Oa6k19Dq5m5hFAqbJeOcjdzaHnbTkeshGDQ0AesQX?=
 =?us-ascii?Q?ulAj/uIip5f23yr062bTKoji9MWQcWjxrlU5b6pqtf+MhhYwF8t/uO1C+kTP?=
 =?us-ascii?Q?emIO5YVBK/jadcGgOnWTtQtwNbtUMo6Qnww5+8NwffdgfMTBfBBJ0DKBHH+D?=
 =?us-ascii?Q?fjLgwxCTOOZptg7FdxnXiyHZrKRFm21i0y1j/jZDqUtvQumWWb87R7L9gZJX?=
 =?us-ascii?Q?ICEvjAiB84/8VmeAZTeo45sjldl0FbJmFdbsJnZVEnLODnH+rfN01nNowltt?=
 =?us-ascii?Q?rGMrrcaJgzuWknlBjwOT2AGNb04ZGoQHFKjqNu+ulPxlOgQWtk/7Bcf6FDsm?=
 =?us-ascii?Q?ff7kJO1VjZ+IB1cvHgY9GpFx0yz7Z7NtadVo4E0yj3kigqegrftJSAvb3Osj?=
 =?us-ascii?Q?IP7xyGAwm8UMWXoZIaght9UxocZZ+JQL8IC8H4z9gVRFV/Lhu1WOWAd7TC6v?=
 =?us-ascii?Q?mFlS6U4fO5T29hGh9rcvd3Qef4CUJcDMA0gCbpfUfyB3lHq1K7MQkwANpCNe?=
 =?us-ascii?Q?YpZxOjO0qoZYZSQWXPiBhZnJBcGh4QHseMwCH/bIc4X/QST39tF7WT4ClASK?=
 =?us-ascii?Q?e+dOB3NS8uEawglli0tizuC08mLVD6NaQ/4nCLwI4ypXAKxaPVKT1epMAP8x?=
 =?us-ascii?Q?0Of4WAStYywKzKPctJZKYCLLEpebvlSgYLgjQcGd4KWrXShd3rlAQ/6q01gg?=
 =?us-ascii?Q?xvwhbO7qXwJMYByunslLAN1BdOTo8LX1/kfuZsxV25dIu55n9lCaMz7THWdG?=
 =?us-ascii?Q?Kg9Y/UlsRVgE94d6yVatlczaxYjX5k749ajdsZ49AxMZlmj/khZp5T12OuC+?=
 =?us-ascii?Q?guGbFo1nIPLFsKgGFySCvkPVCqqhU9jjkqhmAcAj9rkFDj1oyWEGsxLc5yWm?=
 =?us-ascii?Q?Rye4M3PawcP4KDj17CVgKUjBQtcOhE7Pl741DYtWNmWbbhIiyph1quMBDznr?=
 =?us-ascii?Q?pDRn9vaJil2FGcW+jYg88eptQq1UJ2iHlFvjcyx2Zva6Dd/q7cNbds7k54Gn?=
 =?us-ascii?Q?8AIWv0ceORtPk2TEIkmr+k5zdbImJJgL2DKSfvh1n6tovGEm5d/XFDWq2Rbd?=
 =?us-ascii?Q?CXVvPTzz0OsXMU1sHD12L/2K9ipUOjWyGy+XXo3df2IKARQwQuLFNbGWW56H?=
 =?us-ascii?Q?CowX9N2oUQe6tJMrRApIjeLy1BJvT7oodgQpJyVJVdFSC5nxxgHMzFi1Fi2x?=
 =?us-ascii?Q?NDS5KeEhoq3wYJqKe0OL1Syxsak1vcYwFbbPM7AxmPwacftJEoYNDVobLEdy?=
 =?us-ascii?Q?C24o6X2m5VCoy58JXBRhsY/crmnUZ+bJBS7YWiU0s04MViVHuP5aphUxbbaG?=
 =?us-ascii?Q?gRxeSrrU5tQBRqd1hME2KGAx2FuoyAXTPP87SM0yC8ApSZX0u/I1V6y32VEQ?=
 =?us-ascii?Q?vQwqA0gOzJwVvxZRszFGFR81Gk3c0+RI9mZO3sDspNLPLIs4PaX/WsoFHaGm?=
 =?us-ascii?Q?ocTAtrr37VUe6ofTq4GVwXgXsUkSC9ldD4Gwz+me3XZuJIAR7UKRTaLegShG?=
 =?us-ascii?Q?uUYp6ycg8Gqe2UDS1g0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d791e90-e35a-4d62-b3d2-08d9af79deaa
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 18:40:21.3050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/LzJnVLGSkeiBgswR5hKNy/R8Aklk0Pl/eslnuJ2vbJvURU/lMWSAsaZDTcVzrK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5554
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24, 2021 at 05:55:49PM +0100, Cornelia Huck wrote:

> Yes, defining what we mean by "VCPU RUNNING" and "DIRTY TRACKING" first
> makes the most sense.
> 
> (It also imposes some rules on userspace, doesn't it? Whatever it does,
> the interaction with vfio needs to be at least somewhat similar to what
> QEMU or another VMM would do. I wonder if we need to be more concrete
> here; but let's talk about the basic interface first.)

I don't think we need to have excessive precision here. The main
thrust of this as a spec is to define behaviors which starts at the
'Actions on Set/Clear' section.

This part is informative so everyone has the same picture in their
mind about what it is we are trying to accomplish. This can be a bit
imprecise.

> > I don't think I like this statement - why/where would the overall flow
> > differ?
> 
> What I meant to say: If we give userspace the flexibility to operate
> this, we also must give different device types some flexibility. While
> subchannels will follow the general flow, they'll probably condense/omit
> some steps, as I/O is quite different to PCI there.

I would say no - migration is general, no device type should get to
violate this spec.  Did you have something specific in mind? There is
very little PCI specific here already

> >> > +     Normal operating state
> >> > +  RUNNING, DIRTY TRACKING, VCPU RUNNING
> >> > +     Log DMAs
> >> > +     Stream all memory
> >> 
> >> all memory accessed by the device?
> >
> > In this reference flow this is all VCPU memory. Ie you start global
> > dirty tracking both in VFIO and in the VCPU and start copying all VM
> > memory.
> 
> So, general migration, not just the vfio specific parts?

Sure, as above precision isn't important here, the userspace doing
migration should start streaming whatever state it has covered by
dirty logging here.

> "subtly complicated" captures this well :(

Indeed. Frankly, my observation is the team here has invested a lot of
person hours trying to make sense of this and our well-researched take
'this is a FSM' was substantially different from Alex's version 'this
is control bits'. For the 'control bit' model few seem to understand
it at all, and the driver code is short but deceptively complicated.

> For example, if I interpret your list correctly, the driver should
> prioritize clearing RUNNING over setting SAVING | !RUNNING. What does
> that mean? If RUNNING is cleared, first deal with whatever action that
> triggers, then later check if it is actually a case of setting SAVING |
> !RUNNING, and perform the required actions for that?

Yes.

Since this is not a FSM a change from any two valid device_state
values is completely legal. Many of these involve multiple driver
steps. So all drivers must do the actions in the same order to have a
real ABI.

> Also, does e.g. SAVING | RUNNING mean that both SAVING and RUNNING are
> getting set, or only one of them, if the other was already set?

It always refers to the requested migration_state

> >   SAVING|0 -> SAVING|RUNNING
> >   0|RUNNING -> SAVING|RUNNING
> >   0 -> SAVING|RUNNING

Are all described as userspace requesting a migration_state 
of SAVING | RUNNING

> > For clarity I didn't split things like that. All the continuous
> > behaviors start when the given bits begins and stop when the bits
> > end.
> >
> > Most of the actions talk about changes in the data window
> 
> This might need some better terminology, I did not understand the split
> like that...
> 
> "action trigger" is basically that the driver sets certain bits and a
> certain device action happens. "continuous" means that a certain device
> action is done as long as certain bits are set. Sounds a bit like edge
> triggered vs level triggered to me. What about:

Yes

> - event-triggered actions: bits get set/unset, an action needs to be
>   done

"""Event-triggered actions happen when userspace requests a new
migration_state that differs from the current migration_state. Actions
happen on a bit group basis:"""

> - condition-triggered actions: as long as bits are set/unset, an action
>   needs to be done

"""Continuous actions are in effect so long as the below migration_state bit
   group is active:"""
 

> >> What does that mean? That the operation setting NDMA in device_state
> >> returns? 
> >
> > Yes, it must be a synchronous behavior.
> 
> To be extra clear: the _setting_ action (e.g. a write), not the
> condition (NDMA set)? Sorry if that sounds nitpicky, but I think we
> should eliminate possible points of confusion early on.

""Whenever the kernel returns with a migration_state of NDMA there can be no
   in progress DMAs.""
 
> I'm trying to understand this document without looking at the mlx5
> implementation: Somebody using it as a guide needs to be able to
> implement a driver without looking at another driver (unless they prefer
> to work with examples.) Using the mlx5 driver as the basis for
> _writing_ this document makes sense, but it needs to stand on its own.

That may be an ideal that is too hard to reach :(

Thanks,
Jason

Below is where I have things now:

VFIO migration driver API
-------------------------------------------------------------------------------

VFIO drivers that support migration implement a migration control register
called device_state in the struct vfio_device_migration_info which is in its
VFIO_REGION_TYPE_MIGRATION region.

The device_state controls both device action and continuous behaviour.
Setting/clearing bit groups triggers device action, and each bit controls a
continuous device behaviour.

Along with the device_state the migration driver provides a data window which
allows streaming migration data into or out of the device.

A lot of flexibility is provided to userspace in how it operates these
bits. What follows is a reference flow for saving device state in a live
migration, with all features, and an illustration how other external non-VFIO
entities (VCPU_RUNNING and DIRTY_TRACKING) the VMM controls fit in.

  RUNNING, VCPU_RUNNING
     Normal operating state
  RUNNING, DIRTY_TRACKING, VCPU_RUNNING
     Log DMAs

     Stream all memory
  SAVING | RUNNING, DIRTY_TRACKING, VCPU_RUNNING
     Log internal device changes (pre-copy)

     Stream device state through the migration window

     While in this state repeat as desired:

	Atomic Read and Clear DMA Dirty log

	Stream dirty memory
  SAVING | NDMA | RUNNING, VCPU_RUNNING
     vIOMMU grace state

     Complete all in progress IO page faults, idle the vIOMMU
  SAVING | NDMA | RUNNING
     Peer to Peer DMA grace state

     Final snapshot of DMA dirty log (atomic not required)
  SAVING
     Stream final device state through the migration window

     Copy final dirty data
  0
     Device is halted

and the reference flow for resuming:

  RUNNING
     Issue VFIO_DEVICE_RESET to clear the internal device state
  0
     Device is halted
  RESUMING
     Push in migration data. Data captured during pre-copy should be
     prepended to data captured during SAVING.
  NDMA | RUNNING
     Peer to Peer DMA grace state
  RUNNING, VCPU_RUNNING
     Normal operating state

If the VMM has multiple VFIO devices undergoing migration then the grace
states act as cross device synchronization points. The VMM must bring all
devices to the grace state before advancing past it.

The above reference flows are built around specific requirements on the
migration driver for its implementation of the migration_state input.

Event triggered actions happen when userspace requests a new migration_state
that differs from the current migration_state. Actions happen on a bit group
basis:

 - SAVING | RUNNING
   The device clears the data window and begins streaming 'pre copy' migration
   data through the window. Devices that cannot log internal state changes
   return a 0 length migration stream.

 - SAVING | !RUNNING
   The device captures its internal state that is not covered by internal
   logging, as well as any logged changes.

   The device clears the data window and begins streaming the captured
   migration data through the window. Devices that cannot log internal state
   changes stream all of their device state here.

 - RESUMING
   The data window is cleared, opened and can receive the migration data
   stream.

 - !RESUMING
   All the data transferred into the data window is loaded into the device's
   internal state. The migration driver can rely on userspace issuing a
   VFIO_DEVICE_RESET prior to starting RESUMING.

   To abort a RESUMING issue a VFIO_DEVICE_RESET.

   If the migration data is invalid then the ERROR state must be set.

Continuous actions are in effect when migration_state bit groups are active:

 - RUNNING | NDMA
   The device is not allowed to issue new DMA operations.

   Whenever the kernel returns with a migration_state of NDMA there can be no
   in progress DMAs.

 - !RUNNING
   The device should not change its internal state. Further implies the NDMA
   behavior above.

 - SAVING | !RUNNING
   RESUMING | !RUNNING
   The device may assume there are no incoming MMIO operations.

   Internal state logging can stop.

 - RUNNING
   The device can alter its internal state and must respond to incoming MMIO.

 - SAVING | RUNNING
   The device is logging changes to the internal state.

 - ERROR
   The behavior of the device is largely undefined. The device must be
   recovered by issuing VFIO_DEVICE_RESET or closing the device file
   descriptor.

   However, devices supporting NDMA must behave as though NDMA is asserted
   during ERROR to avoid corrupting other devices or a VM during a failed
   migration.

When multiple bits change in the migration_state they may describe multiple
event triggered actions, and multiple changes to continuous actions.  The
migration driver must process them in a priority order:

 - SAVING | RUNNING
 - NDMA
 - !RUNNING
 - SAVING | !RUNNING
 - RESUMING
 - !RESUMING
 - RUNNING
 - !NDMA

In general, userspace can issue a VFIO_DEVICE_RESET ioctl and recover the
device back to device_state RUNNING. When a migration driver executes this
ioctl it should discard the data window and set migration_state to RUNNING as
part of resetting the device to a clean state. This must happen even if the
migration_state has errored. A freshly opened device FD should always be in
the RUNNING state.

The migration driver has limitations on what device state it can affect. Any
device state controlled by general kernel subsystems must not be changed
during RESUME, and SAVING must tolerate mutation of this state. Change to
externally controlled device state can happen at any time, asynchronously, to
the migration (ie interrupt rebalancing).

Some examples of externally controlled state:
 - MSI-X interrupt page
 - MSI/legacy interrupt configuration
 - Large parts of the PCI configuration space, ie common control bits
 - PCI power management
 - Changes via VFIO_DEVICE_SET_IRQS

During !RUNNING, especially during SAVING and RESUMING, the device may have
limitations on what it can tolerate. An ideal device will discard/return all
ones to all incoming MMIO/PIO operations (exclusive of the external state
above) in !RUNNING. However, devices are free to have undefined behavior if
they receive MMIOs. This includes corrupting/aborting the migration, dirtying
pages, and segfaulting userspace.

However, a device may not compromise system integrity if it is subjected to a
MMIO. It can not trigger an error TLP, it can not trigger a Machine Check, and
it can not compromise device isolation.

There are several edge cases that userspace should keep in mind when
implementing migration:

- Device Peer to Peer DMA. In this case devices are able issue DMAs to each
  other's MMIO regions. The VMM can permit this if it maps the MMIO memory into
  the IOMMU.

  As Peer to Peer DMA is a MMIO touch like any other, it is important that
  userspace suspend these accesses before entering any device_state where MMIO
  is not permitted, such as !RUNNING. This can be accomplished with the NDMA
  state. Userspace may also choose to remove MMIO mappings from the IOMMU if the
  device does not support NDMA, and rely on that to guarantee quiet MMIO.

  The Peer to Peer Grace States exist so that all devices may reach RUNNING
  before any device is subjected to a MMIO access.

  Failure to guarentee quiet MMIO may allow a hostile VM to use P2P to violate
  the no-MMIO restriction during SAVING or RESUMING and corrupt the migration on
  devices that cannot protect themselves.

- IOMMU Page faults handled in userspace can occur at any time. A migration
  driver is not required to serialize in-progress page faults. It can assume
  that all page faults are completed before entering SAVING | !RUNNING. Since
  the guest VCPU is required to complete page faults the VMM can accomplish this
  by asserting NDMA | VCPU_RUNNING and clearing all pending page faults before
  clearing VCPU_RUNNING.

  Device that do not support NDMA cannot be configured to generate page faults
  that require the VCPU to complete.

- pre-copy allows the device to implement a dirty log for its internal state.
  During the SAVING | RUNNING state the data window should present the device
  state being logged and during SAVING | !RUNNING the data window should present
  the unlogged device state as well as the changes from the internal dirty log.

  On RESUME these two data streams are concatenated together.

  pre-copy is only concerned with internal device state. External DMAs are
  covered by the seperate DIRTY_TRACKING function.

- Atomic Read and Clear of the DMA log is a HW feature. If the tracker
  cannot support this, then NDMA could be used to synthesize it less
  efficiently.

- NDMA is optional, if the device does not support this then the NDMA States
  are pushed down to the next step in the sequence and various behaviors that
  rely on NDMA cannot be used.

- Migration control registers inside the same iommu_group as the VFIO device.
  This immediately raises a security concern as userspace can use Peer to Peer
  DMA to manipulate these migration control registers concurrently with
  any kernel actions.

  A device driver operating such a device must ensure that kernel integrity
  can not be broken by hostile user space operating the migration MMIO
  registers via peer to peer, at any point in the sequence. Notably the kernel
  cannot use DMA to transfer any migration data.

  However, as discussed above in the "Device Peer to Peer DMA" section, it can
  assume quiet MMIO as a condition to have a successful and uncorrupted
  migration.

To elaborate details on the reference flows, they assume the following details
about the external behaviors:

 - !VCPU_RUNNING
   Userspace must not generate dirty pages or issue MMIO operations to devices.
   For a VMM this would typically be a control toward KVM.

 - DIRTY_TRACKING
   Clear the DMA log and start DMA logging

   DMA logs should be readable with an "atomic test and clear" to allow
   continuous non-disruptive sampling of the log.

   This is controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the container
   fd.

 - !DIRTY_TRACKING
   Freeze the DMA log, stop tracking and allow userspace to read it.

   If userspace is going to have any use of the dirty log it must ensure ensure
   that all DMA is suspended before clearing DIRTY_TRACKING, for instance by
   using NDMA or !RUNNING on all VFIO devices.


