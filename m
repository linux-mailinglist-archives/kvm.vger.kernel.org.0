Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A747646A572
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348334AbhLFTSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 14:18:32 -0500
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:17376
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243127AbhLFTSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 14:18:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRZkyV5USnSqg87Z9sc82bjV5TjXAmCtI84Xd8iIu4V67GOkIPtfODjPB0HqLWHbJT/y4TcnxPT3ACVR/p9IXFm897QvNOanWXwP4v+exzTgsRoB2fzWEIkPF+k4vxo5Lh+vjhuH2oA81ynRI43tOnLh8Hc/idLBFh1uXVnSV3NRm8CpDZui7P0pNFZY84OK8QY4ME1NPnVljeNoTlgjjlve6xvT1Get5sgcIsYBI26nIv1pnEVeyxOnNHqdRxvhITZPSz28IH0UwT6LyoBLLMpTku/8V1rRcIrDUD2qqlyGsAxzTNY94ELgEEsNnKIeMwp/NDI8traWOkDSfFZj8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9//kZqCmQjULHRcgltsWmH7edX1E7drMAdwvohYCMg=;
 b=LIpDcrDbehW7/S1zOpxJX3aM+COutqGRZ/SRcHf0qGBVMSp9Gtku2YaEnF+WhadebhkkxvAe4XAj5p50KiUGK5TdFgMcwbrsb5Fb15VclWfykj2lTy07CrluR5qrRjsxOMLmkmQWsgQ/mq7eBlG9LcA9aASYopIkHPGvfaOCJhNfJVbLtGcppFf+8gma6vmlnaNu959Iwajem31VZmwsZadnHpUofMjEqIVMa/P6e7GhLf0YDiLXUy1W2puqVAhaK5cP5j4W5sR1+CFfqnvAnCfhExDJpTGCCcJx0cRaKJRHHfs92PISWBXFJqWS0L01VKc6SwgDN/pe7TRUVKU9ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9//kZqCmQjULHRcgltsWmH7edX1E7drMAdwvohYCMg=;
 b=dRBhdwsjzwmJXkpqQOF1W2oEcomKXWQ+G2PiTUTEm+BgvIcRcy97g2aObPHAFAixrkQS7IrHaCy9usoHMxGQbwghmixgeCSgAza6zCx6CFJphe24vKIcvSlHSeRS0YWgB1hGqejyXMntEXd7vdbM1jKQ551efHNgTeQn3XXn/5aswDYGSTvNjauZ6oWfhTnHKKOOfGmUvIW2oPgb784SJeck3E/T0VEm+ZMAnufc72vvpW+qZZRJW02pQ6keu9tKLHdy8T6Z7j1qQxDNsGDEiUDL9TyFLr1aW5WMqQlQN584oS6KgGujTY5+85oO8U35eLk96dB3vRpX7SJEWJc0fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 19:15:01 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 19:15:01 +0000
Date:   Mon, 6 Dec 2021 15:15:00 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211206191500.GL4670@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
 <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203110619.1835e584.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:208:d4::43) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR04CA0030.namprd04.prod.outlook.com (2603:10b6:208:d4::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 19:15:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1muJS0-0091Uc-5H; Mon, 06 Dec 2021 15:15:00 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89a31748-a242-45a9-ee87-08d9b8ecb35f
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB5539839401625FA1680F9FEDC26D9@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OFuEZXdAG28sk6HUHjwlxV5zMcXENSmdHEmiOnN/mIy8ua4MQkr++FY9Nmzg8k+D4ICJL/8cRdw0GvzdERY/PfX4qNwXqolvr6D4Mnceu6fNkbXr+eDsO39hYRlODsOYUG5HxSZxmxPZqj3F7geHWIxdyybiqEBwyd4/33hgzTZ01CVaokj5S0hgdq22x0o/rpXomos/gl9r2JfYCrOeCByTdyLdoxcO1PwOgvXL60KrbniK4FzvhyyXVsSPYw3JlwRosPggghxmfRM7VTiMYnxqK5GEU3Im3qS3sDIycJctMwWtisI82mJADOXToBYxhkq6SmVxSxu2hURABKmDEqCvZ3HnZDIaqIohMw68Q+92kCHLkdDBa611yvDnBSC55WTXIFyf9pcYTwA4Byn+0MgstH92LkeQXDJp+vnYGrt55oT/J/E1rXNx5XvxonMcVUGSCKcI/x3dTXMrgt6Fam+rXV9pcGr9mZEMkfpPsoOKpvT+P/V7gO6921ooBU4dvhamL6CcDnNBDvwuDwVK0xx7BjjFyCj5YIvnLEAsVqXyxHJXZyhXApCIwUcF5CHZcYrlcRfFoupUXUQJd03XuAqep4L/X4XZpHKQbgrQW+OTz0XEDUszvEdBiw3Vvb9IE2CMR9bLeCbzrdtx3in+0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9746002)(83380400001)(8936002)(4326008)(54906003)(316002)(26005)(9786002)(30864003)(1076003)(6916009)(66476007)(86362001)(66556008)(508600001)(107886003)(2906002)(36756003)(38100700002)(426003)(33656002)(186003)(2616005)(66946007)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1HYXwT/Stw0tNFKiG7l2d2ojfbPb01yMQJAyJBnhVDEyPk88itMRCDLAcY+w?=
 =?us-ascii?Q?8FmWhOFWwD2UJj05J7cw+8Y12mP7jus6rx29ku/4IepWRRO6luPxom0/G/QI?=
 =?us-ascii?Q?vzKn7xwZuX7P+VEVwu0nkPz2FHFX35fUfDmmr/jJXeQfmuL8sdlJIQxV0Lk2?=
 =?us-ascii?Q?NmoB4MhEwZu9ccvpYyLZPnPR4zBjq/F2jcjS9nVx2+kqLMBR2S+hQ8k7NZYs?=
 =?us-ascii?Q?xO3+OdoyGtfRRrP20NY4EIHeg+KuAKWyZWDuEtOE8bMtKcWefDubkVbGPtDN?=
 =?us-ascii?Q?pT4JdYbTN7dVfz1b+MDAu2qJs5z3C7xjCgQ+LvN1MADpv8B7wCq7XmeYHRzp?=
 =?us-ascii?Q?FjMQs+U3rjODPj7t7g/mxGqjF4aNWD9Zog4ha+9ddm9AlzTWNBhKPOwZpb2v?=
 =?us-ascii?Q?jDkpsj9QvWXoVYIjW1gGEXa0Ic6wSDfjhylvvhWKJg5/zdNiQu3bLzwqQbKH?=
 =?us-ascii?Q?JRJKDr6w/xwIGF9J2pYsRNYD4c4WDOtn+VS/kpQwP+OaFGJLl6CS988vffQ+?=
 =?us-ascii?Q?vPSFFRCm5Gh50BU3Dt3Ift9i3aPdexskI/yQ81OzaTHH9YJ8FmLCnIY/iP76?=
 =?us-ascii?Q?8skPdVDoaXd5LIozFMBng5ELYLI8F4+LtMkRPqSzOzadtAVeHteZwRaNgng8?=
 =?us-ascii?Q?mt/434rh736mUdpAk5TvGfZpQl6k2jBJIcHSk9KbaUNG0NG2Y4mjFSclwhxU?=
 =?us-ascii?Q?ol6xLpL5gotZ2R2/FKipNDCWU7tp++E++M91L8R0afV6g+B7DWRuua/AB+gA?=
 =?us-ascii?Q?zf3n+q7HTYrSlS6V4QI6J9K5vdcQgFe9WnIEwApF2XfZyi3cKLix2oCJgS+U?=
 =?us-ascii?Q?1vD4rzssANnexv+CEoijKB+/nj6pF16mAsbUS/dDl7gDG4vt9k05ZBcvopUR?=
 =?us-ascii?Q?ry7B85VEJ+2VPWbiTLnx+8PJQjwfiDP5uqBVdZwwtxba7HWnuzf9O5P9IE0w?=
 =?us-ascii?Q?021+pLwbM2knJnO2ZlCi2w3sTJbnrmwQQf9DhZ1medFo0yQZcJynTb/sZXzv?=
 =?us-ascii?Q?79lRGUe+UYMp2gFs50t7erkoFFxOMRF5nxDljcrkotrzgsWajla3ymsV1ejX?=
 =?us-ascii?Q?4cP/RprvET+UJLpJCUEaFxhWVytkrfOkuNzwhA79FBmKf493bYrIAEOkBHAl?=
 =?us-ascii?Q?7nUJsCTXzO+VnCXqssG4d0VoyYIkrB7OlmDJzNuJkbMm1OIgfU3QrgfpAWOf?=
 =?us-ascii?Q?h/tcNNivNkN6AGyJtcHz3a9p+FoJHCQ2WtmxRxVu/P4uDGMI1kyFWLnz2bwp?=
 =?us-ascii?Q?skNgQszOcB+xf7wwgTux+jBLzi5dnKyGmnx5SyLFpLFCi/Yf8TxU1VSe/KsY?=
 =?us-ascii?Q?qWOf1+9WjAofj3xADNz9Txc3DPnDRXjDuUM2u4JPC5GaxVlTdNaJeA5wgIpL?=
 =?us-ascii?Q?trkhXWpUK1zuPE+WhtZvFPG4sO/0zdDIIe/AStuylaCNm5gR8UdnUvRhOsq8?=
 =?us-ascii?Q?43FH2M925/EdmVpqLFB73fJHEOeHgJkA5eahbpA1/cyL8D7N/1Z6RkGT7usF?=
 =?us-ascii?Q?54NFxrF30WxG2RJeERSumlleS3VM/RtNUFlcaKAmMY7TpA7aE3ygNGM9BY0X?=
 =?us-ascii?Q?YknOuCEZPDoQC4lfsTw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a31748-a242-45a9-ee87-08d9b8ecb35f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 19:15:01.3805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ssAzXgGAiEpiv9BFlfjwA++8UVX3sWFX3HW6EGiiDLsj3O1GP4C0PjUb7pW4PH+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 03, 2021 at 11:06:19AM -0700, Alex Williamson wrote:

> > Yes, not sure how you get to a non-issue though? If the IOMMU map is
> > present the huawei device can be attacked by a hostile VM and forced
> > to exit NDMA. All this takes is any two DMA capable devices to be
> > plugged in?
> 
> I'm confused by your idea of a "hostile VM".  Devices within a VM can
> only DMA to memory owned by the VM.  So the only hostile VM that can
> attack this device is the VM that owns the device in the first place.
> Meanwhile the VMM is transitioning all devices to the NDMA state, so
> the opportunity to poke one device from another device within the same
> VM is pretty limited.  And for what gain?  Is this a DoS opportunity
> that the guest might trigger the migration to abort or fail?

I'm quite worried about what could be possible if the VM is able to
impact the hypervisor. Something like migration is a hypervisor
activity and it should be fully isolated.

If we are certain that the only consequence is that the VM corrupts
itself, then I agree that is OK, but I've seen enough crazy security
stuff to be skeptical we are smart enough to know that :(

> I suggest this might be a non-issue for hns because I understand it to
> not support any sort of p2p, therefore this DMA write to the device
> while it's under mediation would never happen in practice. 

It has nothing to do with the huawei device, any DMA capable device
could be instructed to generate a P2P write to the huawei device.

> > This is a good idea, if we want to make huawei support NDMA then
> > flagging it to never be in the iommu map in the first place is a great
> > solution. Then they can use CPU mmio trapping get the rest of the way.
> 
> NB, this flag would only be a hint to the VMM, the vfio IOMMU backend
> would need to be involved if we intended to prevent such mappings, but
> that seems like overkill if we're expecting userspace to follow the
> rules to get working migration and migration drivers have sufficient
> robustness to maintain device isolation.

I'm fine with hint. Secure userspace needs to follow the security
rules, the kernel doesn't need to nanny a VMM, AFAIK?

> > OK, I don't read it like that. It seems OK to have a performance hit
> > in NDMA since it is only a short grace state.
> 
> Is it the length of time we're in the NDMA state or the utility of the
> NDMA state itself?  If we're telling the device "no more outbound DMA,
> no more interrupts", then it doesn't seem super relevant for the
> majority of use cases what happens to the MMIO latency.

Actually, I wrote down that the P2P grace state should have
!VCPU_RUNNING, so we don't even need to worry about anything else
here. Just remove it from the IOMMU map.

PRI is the only wrinkle, but I think we have to insist on NDMA to do
vPRI, and the huawei device doesn't support PRI anyhow.

> > OTOH "supportable" qemu could certainly make the default choice to
> > require devices for simplicity.
> 
> I get a bit lost every time I try to sketch out how QEMU would
> implement it.  Forgive the stream of consciousness and rhetorical
> discussion below...

IMHO the simple solution without ugly edges:

qemu maintains two IOMMU domains on demand:

1) has all the MMIO maps for all PCI devices.
2) has no MMIO maps for any PCI devices.

A device supporting NDMA gets assigned to #1

A device without NDMA gets assigned to #2

Some qemu flag 'enable_p2p=off' causes all devices to use #2 and
optimizes away the 2nd iommu domain.

Thus all combinations of devices can be hotplugged in/out in any order
and nothing breaks.

>  - Does it make sense that a device itself can opt-out of p2p mappings?

Bit strange, but yes it kind of does make sense. It is more of a
'device strictly requires quiet MMIO when !RUNNING' flag. Which means
the user space process must guarentee not to touch the MMIO through
any means, including CPU, VCPU or IOMMU.

Combined with the above, the special flag would allow such devices to
join the #2 IOMMU domain and reduces cases where #1 != #2

>  - Can a user know which devices will require enable_p2p=off in order
>    to set migration=on?  "Read the error log" is a poor user experience
>    and difficult hurdle for libvirt.

I'm sure we can add something in sysfs. There is a patch series adding
a cdev for the vfio_device and that comes along with a full sysfs
directory that can hold per-vfio-device information for userspace to
access.

> > Can we go the other way and move more of the uAPI header text here?
> 
> Currently our Documentation/ file describes an overview of vfio, the
> high level theory of groups, devices, and iommus, provides a detailed
> userspace usage example, an overview of device registration and ops,
> and a bunch of random spapr implementation notes largely around
> userspace considerations on power platforms.

Currently, but it doesn't have to stay that way.
 
> So I would generalize that our Documentation/ is currently focused on
> userspace access and interaction with the uAPI.  The uAPI itself
> therefore generally provides the detail regarding how a given interface
> is intended to work from an implementation perspective.  I'd say the
> proposed document here is mixing both of those in Documentation/, some
> aspects relevant to implementation of the uAPI, others to userspace.
> 
> Currently I would clearly say that the uAPI header is the canonical
> source of truth and I think it should continue to be so for describing
> the implementation of the uAPI.

Well, I don't want to have a > 1000 line comment in the uAPI
header.

> > Unfortunately more than half of that describes how the data window
> > works, and half of the rest is kind of obvious statements.
> 
> How does that rationalize forking implementation details to userspace
> Documentation/ rather than resolving the issues you see with the uAPI
> description?

I object to putting a enormous comment in a header file and using poor
tools to write documentation. If there are small things to update and
correct then please point to them and we can fix it. Otherwise lets
keep them split and try to work to improve the discussion in the rst
in general for all the uapi.

> > In your mind you see generality, in our mind we want to know how to
> > write an inter operable driver and there is no documention saying how
> > to do that.
> 
> I didn't know there was a hive mind over there, maybe that explains
> your quick replies ;)

No :) It is just been a long topic here. You recall the first version
of the series had a very different interpritation of the header file
comment regarding the device_state. It was rather surprising your
remark that the device_state is not a FSM when the header file
document has FSM-like discussions.
 
> This is exactly the sort of "designed for QEMU implementation"
> inter-operability that I want to avoid.  It doesn't take much of a
> crystal ball to guess that gratuitous and redundant device resets
> slow VM instantiation and are a likely target for optimization.

Sorry, but Linus's "don't break userspace" forces us to this world.

It does not matter what is written in text files, only what userspace
actually does and the kernel must accommodate existing userspace going
forward. So once released qemu forms some definitive spec and the
guardrails that limit what we can do going forward.

In part this document is also an effort to describe to kernel devs
what these guardrails are.

> I think though that your reference flow priority depends a lot on your
> implementation that resuming state is stored somewhere and only
> processed on the transition of the RESUMING bit.  You're sharing a
> buffer between SAVING and RESUMING.  That's implementation, not
> specification.  A device may choose to validate and incorporate data
> written to the migration region as it's written.  A device may choose
> to expose actual portions of on device memory through the migration
> region during either SAVING or RESTORING.  Therefore setting or
> clearing of these bits may not have the data dependencies that drive
> the priority scheme of mlx5.

I've said this before, it doesn't matter what other devices might
do. mlx5 needs to work this way, so least-common-denominator.

The only other option is to declare multi-bit changes as undefined
behavior - that seems dangerous in general.

The reason this is a good ordering is because it matches the ordering
userspace would do normally if it does one bit change at a time.

Therefore, *any* device must be able to implement this order if it
simply decomposes multi-bit changes to single actions, it must already
support, using the priority listed here.

Ideally we'd put this logic in the core code and drivers would just
have callbacks, but I'm not quite sure we see this probelm well enough
yet to make the callbacks. Maybe once we have three drivers..

> So why is this the one true implementation?

Because it is what we are going to write down?

> I think implementation and clarification of the actual definition of
> the uAPI should exist in the uAPI header, userspace clarification and
> examples for the consumption of the uAPI should stay here in
> Documentation/, and we should not assume either the QEMU or mlx5
> implementations as the canonical reference for either.

I'm not even sure anymore what you are looking for in order to
advance.

Can you please out line exactly what things you want from us? Like, as
a task list?

> > It is informative for the device driver author to understand what
> > device functionality to map to this.
> 
> Sounds like we're in agreement, so why does this belong in userspace
> Documentation/?

Because this is where documentation should live, not in a header file.

> The uAPI might need some clarification here, but the only viable
> scenario would seem to be that yes, userspace should continue to poll
> the device so long as it remains in SAVING|RUNNING as internal state
> can continue to change asynchronously from userspace polling.  It's
> only when pending_bytes returns zero while !RUNNING that the data
> stream is complete and the device is precluded from deciding any new
> state is available.  Thanks,

I updated around these lines, thanks

Jason
