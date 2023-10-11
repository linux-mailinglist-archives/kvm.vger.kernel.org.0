Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3917C55FA
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 15:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjJKN5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 09:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjJKN5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 09:57:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAFB90
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 06:57:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9WuJPj3mDOEBNJjJ3M+inj8BMOcsZvSEFpNNSorlen2FaU8U0GzvHHsRmlQCGVgM9BwycMF1rFhMCTRcXxq17//2AwRjj6Zm7zsqfAjYwnI8Fmb9ahWppQ5+xO1JDEX1ZUCEey6+/gU8kkj3zjYPBg94cmBO9ht88hoYq66B6PkK0xhnmSh4yMDlGzVJSxhQwfubIGPiq0ciq5kT7AWO4r0apEgLrGc5a8n6aUbAfHJMn+RbN1j4fZolVPOOdZOjKX9bfNqYwi17zGGk89rQz1TthVYGyLnV3jJuZa+mUl5XjPkd6UgTcqDyWMtB4JAM/PtNV1qrJoRjfeZBMWnEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acBkgh7LGMhkW3yTo6qeck/sLfrnZNSxOqXz2cLby1I=;
 b=G6u69E+kHjT3NDlHMLS+m3KNr9nc3SWxKBurHWkbdHijUhfMCf/FDWWs5DrbTaB2sXrKkOdaWaxLy6o/5nfn8QMHf2qwG+hFZnFmGTlc0HFvNmMw8of+DghlO3p5TLUg1wvFfCAgD8zNPneeCv63LdcvFPjf+sx6TZ6c1tE7lLOn98o9wTIqvHwKP+uBI1dBNEGf3kBZmguy4JWd5aGUVbZJw8L3jTlQNENb/L05KkYNc9nMOhksgA0oNZgTo0ewB4AhWxoI3np3bJfgUxm2bDm6HOoUT8DiFj90KB1uWrTkR8sZfC3dyh8HzT/uV0GC1l05rmCyk2NllalY1RSNfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acBkgh7LGMhkW3yTo6qeck/sLfrnZNSxOqXz2cLby1I=;
 b=ERr5Iijzfi5udCE1frp58Kt8hoFD4S7hzKq1+GWcUkSEWANLXJgrSFRP6237x2B+DXEO3k4xNQ9MpRDpKxm2Y4sTNfBrC2qBqX4EaM2zacX5y/mYr7Nt8y6ATIiRkG/R87WxJDkq8FoRdz3wq5jOYM89pQh+Jk01o9kqO9lArPE04NwAXJu9y915MtVtNCL4Q3e2V9Z1Oszz8aV+v41zRnLpWnSpARGrO9on7RuMtY59IVVB6vbFTr45r4YIQenjcENklLUaaH2BioM3IMxhmRGF49/eFkW49nuvV4L2rxX3Q4E7DHenmJCTUc+/AK1OyIreb/C7VhNfSEaKakMo8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB8294.namprd12.prod.outlook.com (2603:10b6:8:f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.42; Wed, 11 Oct
 2023 13:57:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 13:57:10 +0000
Date:   Wed, 11 Oct 2023 10:57:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011135709.GW3952@nvidia.com>
References: <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <ZSZAIl06akEvdExM@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSZAIl06akEvdExM@infradead.org>
X-ClientProxiedBy: MN2PR12CA0017.namprd12.prod.outlook.com
 (2603:10b6:208:a8::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB8294:EE_
X-MS-Office365-Filtering-Correlation-Id: 32c7109d-e3e5-42cb-e2ed-08dbca61f6d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1BprQW5OasNIMc54/YY//Hc87wYj2cqfCVJ6tBkgi8fVFgghKbEBmjcI31VJl8jP+7sXQoD8o35Pm92mq0l5xEMNM4/kJFYY8s4SrI+DUXyFprSPBOLE8b+/imCt7CbYCXX53qU2BHqpTTX2k8hiF/Bej7FLaplZRBbUCS876wTqSP+KJeS3wgmFPNJChv1Y7okqFfv0h7lGIjJ+cq1dRWLT18+i/8pCZjEUXQh2aHs+hyMDsoGSJK2JK9IWnefeO7nbkrVjeqAVyNrLbARb8eiJwsVu6/VgPJdANnKqV5TUac2qELHnqKWq6kaWy3CuTU2b6V+8UtbS/1OWFovUYeouHBqAZoVSOdssirPTIEA8f7dCbzI1z0UI70OOXmgH+E34V3t+eoSiU65AckJLwkS40/6xlQuEULsutp0J0Bs9pcTuu4rKPLFehKyJK0/2pvT92bycJQAgTLhLYvqQNo7PF9gRn0/MVy7ihTdsG1O5JPcVVy5TR7kafaL3pCRi8sQfabszYHxn2+B8HF/e4GLcqBeHMHuP3Q66lfAB8uu5+6vSg721VKLiGmcIpvZy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(396003)(376002)(366004)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(66899024)(2906002)(6512007)(6506007)(107886003)(1076003)(2616005)(26005)(66556008)(6916009)(66946007)(54906003)(33656002)(478600001)(66476007)(6486002)(38100700002)(316002)(83380400001)(41300700001)(4326008)(36756003)(8676002)(8936002)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6SUYhRV651oqT5kfuBXD/RB+jnG/3IBdYfIXrA/ErDwvGcWsRRwynRuA1DNr?=
 =?us-ascii?Q?eG2dEUHZDGJoIqRCvD+kaSGN796vMbkb2/Vn+2+TYKeclKU4Knjb1Bbko04A?=
 =?us-ascii?Q?X4PeTQtUHtl8QCoXeEdpw9MDRyoUEUpU6w/KEv9wTHx0emapAHroj/6U/wQG?=
 =?us-ascii?Q?W96GruioBAGyxbvB56W3uSP8pMYZF53t9uSPYoLwAPL6H/L8dmWFNNFwMGru?=
 =?us-ascii?Q?FfZz5Kcb0oOCXcbdauAP1ngO1lZ+eaywtFiTkbrMc/V25dC5C3DTUvPjSKlp?=
 =?us-ascii?Q?Kbb7Miz3vavkH1ljGHpoKa6qm5rmYNGQLTSIpvf1V2vfksQjpqr5oaxqWPfS?=
 =?us-ascii?Q?5e/A8R55feeP2feT0YzXwBWFd78dKgJv+GFgua8FHef+FPhk4xtSnr4JbfP4?=
 =?us-ascii?Q?ZUKekc4HWZG2rf0JI4+8lM5jlXoSr0U4LjIdK+6OJp5BL9G0yMFb7nT7m3d5?=
 =?us-ascii?Q?/uaHMgReMwCtqRWQvmPfsSTbAf7s9pq/MuF99DF7Y0n+woXTXm+Nq6vLmqpJ?=
 =?us-ascii?Q?NColCQSDNmGTs6CT7TI66iLsaCbVdq6Bne7uB1Z5sGa/SMLgseZex1bsjKqk?=
 =?us-ascii?Q?ApidThxf8EQ2pcQN+3zrQ6Ka9V+KJuPmJzV1uENLtuOZG6maS9wQ70b5dKE/?=
 =?us-ascii?Q?Ge6Q1Xlcl+rOzccWdhphagoWe5VUckGkzG0ie0eHjy4GKebv0zlpV2M7P3DD?=
 =?us-ascii?Q?ElUtZMiWyjMcpMvXCPoWSMgOGpkxKe7nlcxzcJTMOCK6NvjWSZZcaJzDDE1K?=
 =?us-ascii?Q?ENAb09QqSEOWKOQ/XeodehXZYxOoMZqdW7BGrz/8PAGeXIl25fKqJ5+aamyZ?=
 =?us-ascii?Q?ieL6z22PpkPVIFizWQSr1xGMz9NmjCzFv8ENqZaP8jq6nod9MHTEMxy1JcV/?=
 =?us-ascii?Q?DAbRN9Ouw6EOoyOI3pmcEsD70yvMD6zHHpb4bninNeYtr3uZWeupRtklFZPV?=
 =?us-ascii?Q?zLyKDfMRVXX9/2ZXKxXeLkkd5PT6DH6mhj4wVNf3Gv9mI7ZRul8p3WyaLeOA?=
 =?us-ascii?Q?cOJNsZywzC26/bFpZwVMfInLWyiWLrCQZxDzdqaglUX60Te90ekDwq3gCzB+?=
 =?us-ascii?Q?tMd9FVlKArNopSO3W/9uDWMu4ToII8r/Eo/ZJCRzwJQuecDO0oICxio3opnU?=
 =?us-ascii?Q?Hc4XDB1R6D3UOa5ObiU4bR9ahA7/euY4J52IGHZQszk7TPPwpWVLwvP+FzRY?=
 =?us-ascii?Q?l+3JgErpWdgcAvjP/VXahoCbOmwj0LSfs3Ii0DS+AOJR+J9bGXWhQNiwWV/b?=
 =?us-ascii?Q?xzu/ClKVB0/6Wm5DkG6CJ7Mn1uYrT86b7wNXfneLukR1tpctZDhp/7cgTMyH?=
 =?us-ascii?Q?PzFNPvFoaYGUq8qjgq7rmA+OUFgsgd5mqN5hprZtct0xNgaxsXjQWsM8YfIU?=
 =?us-ascii?Q?awMRhChPKgnsBPAPsfoTNZbg0CafUHu3UBpbcjd/546imGBDC6nxbpF7Zmdo?=
 =?us-ascii?Q?M4DCt8eu1bos8ibRqIw/kBXGvuN8Yp29Pgo+doEYV3q9YDIIa2+t+ZmJVa+4?=
 =?us-ascii?Q?xM5u3cHGgJlCWffgtx4Gbd0hBt5F0bdMrpvQZNk9KhvD9InM+/PXC8wDsXUC?=
 =?us-ascii?Q?TDTZRs9uAoqRWsRdhcyFNtv2lehO6OAQALALc78F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c7109d-e3e5-42cb-e2ed-08dbca61f6d6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 13:57:10.7240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLMX35zfYDuwWWWzQlbmtoe0/zwxflcuKMMONOS5WiK/xw3aRcbKe3NXJacOw4NG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8294
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 11:26:42PM -0700, Christoph Hellwig wrote:
> On Tue, Oct 10, 2023 at 10:10:31AM -0300, Jason Gunthorpe wrote:
> > We've talked around ideas like allowing the VF config space to do some
> > of the work. For simple devices we could get away with 1 VF config
> > space register. (VF config space is owned by the hypervisor, not the
> > guest)
> 
> Which assumes you're actually using VFs and not multiple PFs, which
> is a very limiting assumption.  

? It doesn't matter VF/PF, the same functions config space could do
simple migration.

> It also limits your from actually
> using DMA during the live migration process, which again is major
> limitation once you have a non-tivial amount of state.

Yes, this is a dealbreaker for big cases. But we do see several
smaller/simpler devices that don't use DMA in their migration.

> > SIOVr2 is discussing more a flexible RID mapping - there is a possible
> > route where a "VF" could actually have two RIDs, a hypervisor RID and a
> > guest RID.
> 
> Well, then you go down the SIOV route, which requires a complex driver
> actually presenting the guest visible device anyway.

Yep
 
> Independent of my above points on the doubts on VF-controlled live
> migration for PCe device I absolutely agree with your that the Linux
> abstraction and user interface should be VF based.  Which further
> reinforeces my point that the VFIO driver for the controlled function
> (PF or VF) and the Linux driver for the controlling function (better
> be a PF in practice) must be very tightly integrated.  And the best
> way to do that is to export the vfio nodes from the Linux driver
> that knowns the hardware and not split out into a separate one.

I'm not sure how we get to "very tightly integrated". We have many
examples of live migration vfio drivers now and they do not seem to
require tight integration. The PF driver only has to provide a way to
execute a small number of proxied operations.

Regardless, I'm not too fussed about what directory the implementation
lives in, though I do prefer the current arrangement where VFIO only
stuff is in drivers/vfio. I like the process we have where subsystems
are responsible for the code that implements the subsystem ops.

> > However - the Intel GPU VFIO driver is such a bad experiance I don't
> > want to encourage people to make VFIO drivers, or code that is only
> > used by VFIO drivers, that are not under drivers/vfio review.
> 
> We can and should require vfio review for users of the vfio API.
> But to be honest code placement was not the problem with i915.  The
> problem was that the mdev APIs (under drivers/vfio) were a complete
> trainwreck when it was written, and that the driver had a horrible
> hypervisor API abstraction.

E800 also made some significant security mistakes that VFIO side
caught. I think would have been missed if it went into a netdev
tree.

Even unrelated to mdev, Intel GPU is still not using the vfio side
properly, and the way it hacked into KVM to try to get page tracking
is totally logically wrong (but Works For Me (tm))

Aside from technical concerns, I do have a big process worry
here. vfio is responsible for the security side of the review of
things implementing its ops.

> > Be aware, there is a significant performance concern here. If you want
> > to create 1000 VFIO devices (this is a real thing), we *can't* probe a
> > normal driver first, it is too slow. We need a path that goes directly
> > from creating the RIDs to turning those RIDs into VFIO.
> 
> And by calling the vfio funtions from mlx5 you get this easily.

"easily" I don't know about that :)

> For mdev/SIOV like flows you must call vfio APIs from the main
> driver anyway, as there is no pci_dev to probe on anyway.  That's
> what i915 does btw.

IMHO i915 is not an good example to copy.

mlx5 is already much closer to your ideal, and I would hold up as the
right general direction for SIOV/mdev/etc, as we basically already do
a lot of SIOV ideas.

mlx5 is a multi-subsystem device. It has driver components in net,
VDPA and infiniband. It can create non-PCI "functions".

It is not feasible, process wise, for all of this to live under one
directory. We *want* the driver split up by subystem and subsystem
maintainer.

So, we created the auxiliary_device stuff to manage this. It can do
what you are imagining, I think.

The core PF/VF driver is in charge of what to carve off to a sub
system driver. IIRC mlx5 uses netlink to deliver commands to trigger
this (eg create a VDPA device). An auxilary_device is created and the
target subsystem driver probes to that and autoloads. eg see
drivers/vdpa/mlx5/net/mlx5_vnet.c

They are not 'tightly coupled', the opposite really. The
auxilary_device comes along with a mlx5 API that allows all the
subsystem to do what they need on the HW mostly independently. For
mlx5 this is mostly a way to execute FW RPC commands.

So, if you want to turn the VFIO stuff inside out, I'd still suggest
to have the VFIO driver part under drivers/vfio and probe to an
auxilary_device that represents the aspect of the HW to turn into VFIO
(or VPDA, or whatever). The 'core' driver can provide an appropriate
API between its VFIO part and its core part.

We lack a common uAPI to trigger this creation, but otherwise the
infrastructure exists and works well now. It allows subsystems to
remain together and complex devices to spread their functionality to
multiple subsystems.

The current pci_iov_get_pf_drvdata() hack in VFIO is really a short
cut to doing the auxilary_device stuff. (actually we tried to build
this with auxilary_device first, it did not work out, needs more
driver core infastructure).

I can easially imagine all the current VFIO drivers probing to an
auxilary_device and obtinaing the VF pci_device and the handle for the
core functionalitty directly without the pci_iov_get_pf_drvdata()
approach.

> For "classic" vfio that requires a pci_dev (or $otherbus_dev) we need
> to have a similar flow.  And I think the best way is to have the
> bus-level attribute on the device and/or a device-specific side band
> protocol to device how new functions are probed.  With that you
> avoid all the duplicate PCI IDs for the binding, and actually allow to
> sanely establush a communication channel between the functions.
> Because without that there is no way to know how any two functions
> related.  The driver might think they know, but there's all kinds of
> whacky PCI passthough schemes that will break such a logic.

Yes, if things are not simple PF/VF then Linux struggles at the driver
core level. auxilary_devices are a way out of that since one spot can
figure out how to assemble the multi-component device and then
delegate portions of the HW to other subsystems.

If something wants to probe its own driver to a PF/VF to assemble the
components it can do that and then bundle it up into an aux device and
trigger a VFIO/etc driver to run on that bundle of resources.

We don't *need* to put all the VFIO code someplace else to put the
control over slicing the HW into a shared core driver. mlx5 and
several other drivers now already demonstrates all of this.

Jason
