Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B0E72E5E1
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240862AbjFMOfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbjFMOfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:35:51 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4566310DF;
        Tue, 13 Jun 2023 07:35:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYybpMZAcJOLKvmFmqHH7T1vPEAJTHaonFVptyUk4LIcHz6A30UFr9Jm8XEbcfLVMCuQkpXU6JMXZnQ32R+oNkL9eg9vhtifm0kIoIbGxJRowYOKtC/taUV+55sOGUbOewUIP8xHMnUCQqdIFyb/+v1V17PzfKIFcr5MrLeYawZyq8OgP1YwTCJ75gpgDVIKd7xoYMiWh3fRl04G2OdDmNDP399HSLn+ZxA9XYZS0IczrXdukmg/ZjAFxJpwRCjiTW37WoB+oytXZlQatDsxdAW1bbfoZIH3oRe6U0rWHu1HqkNKrRbbypzZhto3GoCEutgBt6BCHQZw8tKpe48Opg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ujVObTeBhc4JPduEKwgYka+GvPycRA0exksN94iLMUk=;
 b=lgFcYbQlPIuxmBRM8sz2weuYUJTLOcfUr4uZwFPbcUKjASGFEPfQtly4f2rikbzgZFptDsdF2JynlrborToxPJFdQ+yXf41ItM73vOAClER5c4d85SOiayL5E2AsjtHmShTk6/8eVM5Q+PPxKOZkLF2CabLWcQbbVtcj7QnftDuDeKOEqBLuIiYalYf2ttcim1a6YfFITWojSSYjrQo4qpOCnPeaY3AorOra+iZQe+SNso5t0gJY35WeKurg5DenDCAlmrWcd7WoXdbYYYvgPDmR5xVhIXtAeBG5CxEYT4NbLd7F1mKGZ+DkpPjex46E80dS7fiocdp6JEzBszEx6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujVObTeBhc4JPduEKwgYka+GvPycRA0exksN94iLMUk=;
 b=GHZNNFb+tCn4xoDOHzYJpATgbbBpeZRYMOwpMl3qC6R2L9MRAToTDugL5oHSR8PF5psQxEkyxrW4+pPBYVaMBFS7M0ph5esR8XodDRLEb57c82zjJuNaQBUkpfKt9lcCxlBPR3/dTlrXkhO5I/XsgqoaaX2JCXjC3eNb1lJQn+1KRUBW7it5EhpbOMLcs6roLk/+SsuBYgRl5qKplKrVu4XrF5aZDJs4+sg+kAbYDbfcdGwIeqb+swLvQ11WXfaLlEzLqYofDd3b3Df3yt25R7XT747LbZU2ayzD3jYEm5E/qYb4/fICTWLzvh7no8niZUsMGE+3SWPq3vJKP6A1/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB6003.namprd12.prod.outlook.com (2603:10b6:208:37f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Tue, 13 Jun
 2023 14:35:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 14:35:47 +0000
Date:   Tue, 13 Jun 2023 11:35:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZIh+wXFrls7StWzc@nvidia.com>
References: <20230606025320.22647-1-ankita@nvidia.com>
 <20230606083238.48ea50e9.alex.williamson@redhat.com>
 <ZH9RfXhbuED2IUgJ@nvidia.com>
 <20230606110510.0f87952c.alex.williamson@redhat.com>
 <ZH9p+giEs6bCYfw8@nvidia.com>
 <20230606121348.670229ff.alex.williamson@redhat.com>
 <ZH+DdVIyZ6hHCDaK@nvidia.com>
 <20230606153057.4cbc36a0.alex.williamson@redhat.com>
 <ZH/LzyF/uttviRnQ@nvidia.com>
 <20230607122303.5d25c973.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607122303.5d25c973.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0092.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB6003:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e680d59-e792-474d-efbd-08db6c1b79d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BDVIQBz3Tw+xrR6m22N0mnmp1NQfYcNeaCbsTlz0fNvT3cUTzmrxjCau6mdHh3bx7BP1pB/P8tfu3snWGIC8E+ULBkYA/vgRMuZP+PbpdOjeRSfCY6Z3l4JirFud7h4o9a8rOHFotXQBW9kjoc8yVPehyW1RHnu6kwMYEbNjCm8d5ItTpfIMUBtIZMrejxwh6VjAvQnfohSgwuWVj+aLZf9oVVlaGDEA3t1AuBeIC2v6ddoQeWt5ym2ijGXXyjYOCRz9z3xPg07B+k6fMEcIgnMFuce/FvLRtJTWOwzk9DfK40lcmWQGuK143ml86wY5vxkitlY2O0HMw4jh8fIGvOiO/mddC6AQwpxvvpSrGL2Vm1uwpXOr+s0jZkibC2mhYCQ8woLPq0iGlYITcI6VCypmr+cbggb/aAZPspGiOhrY1nDfgfitzbDrvev47KlDDnEMulU++NAnMnoB66zvgXglOTs0yqwHbahv5z5/ld1jajfiiF1L/Zo4PUiwDDGGPodofOwa+7lx7u86TlgnIeUbUIFF7RMPJFXrBmnmqMUmqxB6ZfP8kVRCIJef4rMnn47r1MDiXhUf2RK+yV0dbXslh5xac27UL6gzxNCdfuT9felIdULWQMGuK9qVdIUfC7rOF4u35I1ZYvbYyggE8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(41300700001)(83380400001)(6486002)(4326008)(478600001)(8936002)(8676002)(86362001)(66476007)(66556008)(66946007)(6916009)(5660300002)(38100700002)(316002)(36756003)(2906002)(6512007)(26005)(6506007)(186003)(2616005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q2Zg4eSdX05LyXxbG51Bx/FP0+JXXOJ2NPtT10syedOupQ3zEnS7PWhoBlcl?=
 =?us-ascii?Q?yMhfC5MT3L76TvxgebKgC2grZPwf6tRVT8wbonzI2H89iiOOmW4ug11UXHRr?=
 =?us-ascii?Q?8CZscr08d5n+cmiFpHNpR35Gfk6uqZuv/qRr64DmyCYIlLaB2AX44ytk8if5?=
 =?us-ascii?Q?GZ4GrrEXcKQP32D8/1FYbe4QQLDvbWkqid3Nz+1sthncy9ptdR5Cx18vUh32?=
 =?us-ascii?Q?llx7vQQ4LlktutWvAnYkYCR2/QyG9bO8Nzf5WmdzEjR7vPt6I+5xqac5DhqG?=
 =?us-ascii?Q?puwhUWJKJ7VL+KsiCkIWcyTaE+VRecU12IctPBEEuXIiXKL0Afe19VZjnxSN?=
 =?us-ascii?Q?kLp3NWdQ6aoeGCfiytcKPPZhJYEXZi9xQ3rNjG0HU0hFqXLnoWxFVCyEqGYf?=
 =?us-ascii?Q?TGE+V0RR8zVn9oNsW9R6kAo/SMszjq3AagEIIm0k8DWTrCwIY5nPulmjP7cO?=
 =?us-ascii?Q?Bi1hG1uX4GkAcTQN5qZ2iQ7qIlkVy97TU4QxntOsPkLeqzu5k0e7Wmch1wBV?=
 =?us-ascii?Q?eGnihtGabsts1+EeIaQXemMsNy5NHV85CecJQp3e5QZ/SUaB0xqMtqQs+BQA?=
 =?us-ascii?Q?43Rb8/T/IZE7uQ+YxmG0YyfVPlc+GN260ReCXmyLgIWZOVgKfuH+98s3TKSJ?=
 =?us-ascii?Q?2S1nuKHti/eJ9+msF6dToiLRlkLg5i/YpIpISNcWMPmRVQCbukQvPDGp6mCb?=
 =?us-ascii?Q?7K+gQyJFcagJRwMjq/DrrrQD5fmR5K0JcwVIHyND9OeEulXx8Zea5sfucAiL?=
 =?us-ascii?Q?g+35C1V1lgK3wwejUzhYGGFtmQYwb7EI5APWBZQIucHSLVmEurA9yvQ/MFHZ?=
 =?us-ascii?Q?FrJkxXvaiG6/nNodPHcMvWyQX16DAjiHHCpCbB1rzDH9qZfUYV1JUGQ67dnU?=
 =?us-ascii?Q?4SSUXoleCP/UnwEMhk1H+BQgWLKkP6ypFbaRIUWP0GG6A2IdHEOoQb6sbCta?=
 =?us-ascii?Q?Bygfu1Nj0ylGqrWjSont/dM8U9/EoE4bHlCa6SvPQ6G5aKciGUR1XUyDnNg+?=
 =?us-ascii?Q?XCdFb/U5HVkmkLsO+2veVI+o9OnxJG4Fn5XYZxzsYsprQmYQc68ZgJeUlZdB?=
 =?us-ascii?Q?PBvBa3/PTFOl4yaNRTyeGjdyc6lY9pDSZI6CPr5ODSpEwQGyzjslUJ1PPHNv?=
 =?us-ascii?Q?7ds950wacSPge/0Eebr+0fgp3WphOrhWsFEyYzH8dNsay/b7lRe5EAHbssXx?=
 =?us-ascii?Q?55R+gY++i0Wcg5wtePu+8mwoSLNFIEetWNwqe4XjLwjyDls98uijOijOsReA?=
 =?us-ascii?Q?CZX53dm8rig/6iUmkiL7na50XiRBXA0MRCgU1ir990PAUlNLHOliY09ZVBAu?=
 =?us-ascii?Q?Hh4ACfrGRye7jtDT6Y2sxV9Br16aM5b+w1E+Fr16dX59RDGg4D0DsYzW+y0h?=
 =?us-ascii?Q?iZvNwB6uj16o6Jti1E8e4y9L/9/y3S+CUlEOH10PQdSfPvw3Wct4sjwQJsmO?=
 =?us-ascii?Q?c+3AaKk76xU83nTfw0lcccsQXmNQ692F872qyF3bO6wQ3cqDgjpr4bHMImh+?=
 =?us-ascii?Q?3gW6NXbhMKEICGhoeL4pHPAAmWm4gx4mbTkNt4cNjJr58XMCP9RfJnyDKk5K?=
 =?us-ascii?Q?XT+TyrUyYsoFnlkem+hnnHMNmRJSXJYzaH5mTSXn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e680d59-e792-474d-efbd-08db6c1b79d4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 14:35:46.9567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lVS3RH/hqX4LjxhokKzW4AHDp6fcH/Phu1uRUJtM/jg7T/KZxK9IWgwKHU+i3DzG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6003
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023 at 12:23:03PM -0600, Alex Williamson wrote:

> > The fixing is generic, a generic function does not elevate to create a
> > vendor uAPI IMHO.
> 
> Who else is trying to expose a non-power-of-2 region as a BAR right
> now? 

I see a few needs in other places internally that are not public yet,
especially in the SIOV world I alluded to below.

> We have neither a specification nor a complimentary implementation
> from which to derive generic support.  

"specification"? It is literally - the size of the bar is not a power
of two, so make the resulting hole when mapping that to a vPCI discard
writes and read 0s.

This isn't a PCI specification, it is a contract between the kernel
side and the VMM side within VFIO about how to handle VFIO devices
where the kernel driver wants to have a padding.

It makes sense that we shouldn't just do this blidly for the existing
indexes without some negotation, but that isn't a PCI "compliance"
problem, that is a incomplete VFIO uAPI design in this patch.

> GPUs seem to manage to have non-power-of-2 size VRAM while still
> providing BARs that are a power-of-2, ex. 6GB VRAM, 8GB BAR.  

Generally excess BAR is modeled in HW as discard writes return 0 (or
maybe return -1). HW can do this easially. SW is more tricky

> Why shouldn't the variant driver here extend the BAR region to a
> power-of-2 and then we can decide the error handling should accesses
> exceed the implemented range?

This sounds doable, I don't know if Ankit had a problem with using the
sparse mmap feature to do this. We'd need to have the padding be
non-mmapable space and then the kernel driver would do the discard/0
with the read/write calls.

If this works out I'm happy enough if we go this way too. I suppose it
allows better compatibility with all the VMMs.

> > I would say if the thing that is showing up on the VM side is not PCI
> > then maybe a vendor label might make sense.
> 
> Well, how do you suppose a device with a non-power-of-2 BAR is PCI
> compliant?  You're asking the VMM to assume what the driver meant by
> providing that non-standard BAR, which sounds vendor specific to me.

It shows up as a PCI compliant device in the VM, with a compliant
power of two size.

> Is your primary complaint here that you don't want
> that region to be labeled VFIO_PCI_NVGPU_BAR1?  

Yes. This modified VFIO uAPI contract is general enough it should not
be forced as unique to this device.

> We could certainly define VFIO_PCI_VENDOR_BAR0..5 where QEMU knows
> that it's supposed to relax expectations and mangle the region into
> a compliant BAR, but now you're adding complexity that may never be
> used elsewhere.

I wouldn't use a _VENDOR_ name for this since it is generic.

I would suggest using a FEATURE:

/*
 * When SET to 1 it indicates that the userspace understands non-power of two
 * region sizes on VFIO_PCI_BARx_REGION_INDEX. If the kernel driver requests a
 * non-power of two size then if userspace needs to round the size back up to a
 * power of two, eg to create a vPCI device, it should return 0 for reads and
 * discard writes for the padding that was added.
 *
 * If this flag is not set, and the VFIO driver cannot work without non-power of
 * two BARs then mmap of those BAR indexes will fail. (FIXME: maybe
 * this needs more thinking)
 */
#define VFIO_DEVICE_FEATURE_PCI_PAD_BARS 10

As adding new index types for every new functionality will become
combinatoral, and adding discovery of which vPCI BAR index the new
indexes should map too is also complicated..

Though sparse mmap is probably better.

> > It really has nothing to do with the regions, it is something that is
> > needed if this variant driver is being used at all. The vPCI device
> > will work without the ACPI, but the Linux drivers won't like it.
> 
> OTOH if the ACPI work is based on device specific regions, the list of
> device IDs in QEMU goes away and support for a new device requires no
> VMM changes.

Using the device ID seems like the better approach as we don't know
what future devices using this varient driver are going to need for
ACPI modeling.

It also seems I was too optimistic to think a simple variant driver ID
would be sufficient. IMHO you are closer below, it depends on what
bare metal FW qemu is trying to emulate, which I suppose is
technically a combination of the machine type and the installed vPCI
devices..

> > The ACPI is not related to the region. It is just creating many empty
> > NUMA nodes. They should have no CPUs and no memory. The patch is
> > trying to make the insertion of the ACPI automatic. Keying it off a
> > region is not right for the purpose.
> 
> Why aren't the different NUMA nodes a machine type option?  If we start
> having each device mangle the machine in incompatible ways it seems
> like we're going to get conflicts not only with other devices, but also
> user specified NUMA configurations.

You may be right, I think this patch is trying to make things
automatic for user, but a dedicated machine type might make more
sense.

> I'm struggling with whether I can
> set some bits in the root port devcap2 register[1] based on device
> capabilities and here this is fundamentally manipulating the VM
> topology.
> 
> [1]https://lore.kernel.org/all/20230526231558.1660396-1-alex.williamson@redhat.com/

That does seem a bit dicey - alot of this stuff, especially ACPI, is
reasonably assumed to be set at boot time by an OS. Changing it
dynamically becomes exciting..

Thanks,
Jason
