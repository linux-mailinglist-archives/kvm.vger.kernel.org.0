Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5A46DD07
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 21:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhLHUbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 15:31:14 -0500
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:4640
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232235AbhLHUbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 15:31:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ih+Iekl6i4AjIS94ZIR3sUmC4cZWiPu5Ja3yNIOhBmxnpN8cQ4Fuka7g3csHY7Jwg9x894ns8d5wOVKtMiyEW+c+6XiZ4vN4/2gg7WjhPPWSgYOMrLad/Id4vRMeDXsyRiccEGJoszuDhGRuj37Viqthkxe22a8aCSrAZgQmU1fs4yjaswg0ya4QUefcxqZbkfisc/uBCwrfU0hQkvin3FSTJ6EHSZk/GJv4modWY77bgWjtLKGIgZmY6vGBALtl3lhRktZUdzSoG+zc41ojaDVTjtKqlLvZtWWdrEyULab5Q9XsITFF7gOq3nD9PiJZVSU8B4wuw86rLKeit51Ceg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vL67Kj1+nLF4/UCv0bU+LEVeLUL0HdROH7+y6hMCas=;
 b=b7LA1+7rxMQoYC4VXSjFjDmm0KSPQTh9DGrgGcPtyZ/+SPHgsGu5n8xygW/DFsFjqGL5gJ+m0qKDDNOgcUKQ8RL4mc9OWecAuPlWoqyVseemhJyiyZTPOOtvn8WjiKLZgJLX1VmMf/u9l4b1oaNIifoLieywzwGzsKDlnepxROUPlTk0B6aICpxrwTmtWFWbMBUIhzCwgjHk9icy8hR29sAAWx92GbSXdK627D//g4nazhny6XMLDhxBPmHTLb4ZQpyfelL2CIpTUdJ7vmu6wHwAVePOc3tFseVETXarYarfpmnVxBJlDYxLSFw42aNou8XAiJGO5TIbVol/xBfXaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vL67Kj1+nLF4/UCv0bU+LEVeLUL0HdROH7+y6hMCas=;
 b=daEvxomo6gg56eb9UnzgjP50SbcNjq5BICUq6h4ZQBnVWf+IkByXUcxlqDwuBuTL68O7mT7J2xFDdNtVhuN4g6NxKDkw8iHhilrSsw5cXmUrUYm36Jcg4UDMjoZ3l0Cuie0P3VZ6KX6HWeoeyNDcLYLHrf7oKhpnaf60L1v9v8tNDwvoPNcbXRnD5tsNgzqlow6rzwP2G1XCR9m1UCN5oT56aszk4JIDbg99r90I2u3ddTgDYsohewMGIbI+OkuoAa7XHkvi2Q8xqzR/TrdUqoOprtDzAvaT+cDc4Sjh+P6fyWGAoW9SyP5MM5KTjMgGWzv1ktdf5n/felFIH5Ry6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5031.namprd12.prod.outlook.com (2603:10b6:208:31a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Wed, 8 Dec
 2021 20:27:39 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4778.013; Wed, 8 Dec 2021
 20:27:39 +0000
Date:   Wed, 8 Dec 2021 16:27:37 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211208202737.GE6385@nvidia.com>
References: <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <87zgpdu3ez.fsf@redhat.com>
 <20211206173422.GK4670@nvidia.com>
 <87tufltxp0.fsf@redhat.com>
 <20211206191933.GM4670@nvidia.com>
 <87o85su0kv.fsf@redhat.com>
 <20211207155145.GD6385@nvidia.com>
 <20211208090647.118e6aab.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208090647.118e6aab.alex.williamson@redhat.com>
X-ClientProxiedBy: YT1PR01CA0130.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::9) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b18d4be5-2736-4c5b-103a-08d9ba892d8a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5031:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5031B8ECB01FE4B65B8ECEF6C26F9@BL1PR12MB5031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qaSxMm3vPLk5qP4D3rTlDTqlWWYqxXrItYA1eUp0tHDdSPBsjwuqZPdQKUPu3uiWfQN+iCWsjoq+PnooJdP5Ojw2lGJHnR9tJIR2EHlWr1yLSeWy7pWrdq2J+VGobGe9N0opiY2nM7bey2nYVowFZH979JIN/g7JiPsPtY/bTwZAlixIyW0zJHvtQAwti/CNBHvJccClIKvgk9755+3Ua8nBUK/moFRUXshW6VllI7Cx6BV60/0F6j/s/p8IWskcZcKEaS8WGo3D/qaMtcDgGY3FuPbMOtiuPf34aB9IxT48JQNcvzlEueCKCorVIan1vnBut2vMpnwbzoknhhi9ZAZXUKwXsZ1HZEvqnRnXnzhmfJlZe8YBAY61ltpSMh+UvTFw1aYu5Jr3Sx2i18B5D+X7y/oVMB5QYYMscIRHVZQQe9ClwoV8kr1Ln+10QRfTdYom6Jg2kKfdMsDucJycMOnw0/lpZe8O4mbzQEFVxRFj5CW2xL/+CC2OBmi3Is505xXiBxe3UKmPfeWBCqj09Ld0gDLH1jytS9yz7S3DWUydRJ/X8fREAl3gkrgsMzvturB+4hd/OJHvRJIf8rzkvFp7Lk5nJTL46lEwXBC4cOnfAsz8qZQOSwnB0f3UPS6rmJ+KytcnRtF4FGAN0+baiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(66556008)(6512007)(26005)(66476007)(316002)(6506007)(8936002)(66946007)(186003)(83380400001)(30864003)(54906003)(508600001)(1076003)(4326008)(107886003)(5660300002)(38100700002)(86362001)(6916009)(36756003)(2616005)(8676002)(6486002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6aHXPsCwLhlinvDoGHCPASNa32bHmsHw7HauryhoYAgL+euCqURu8F1veXBb?=
 =?us-ascii?Q?Z1pA8hvryB2NnMXNXjcsgnKteU0w5gEk7NV8Djxa5So689WiOHspCbmGHegs?=
 =?us-ascii?Q?2B/6e6b0AWfZ5e1EEcsxJVl68m/MCKcSfwvP64oZl4eO4LPb2T61qQbgRImh?=
 =?us-ascii?Q?1fgtGUNZX+wf8WyiDpQELdIxGUfoCqXzlimF/2OFKgA8Pdffmqj7j0NVQpTZ?=
 =?us-ascii?Q?zPWn+n04lDmapZWPP2stiWvaGRnTkh1+Wxa7JS7srlB4nngtd39OUuFjCmhy?=
 =?us-ascii?Q?6JjhS2AvtOwFW4MLZJFiDkpPvD6XzEswB3oaX7OnEw+NfcJ7FNfvc+6ZVXV4?=
 =?us-ascii?Q?WFVB0drRPKhsK0CGznJZydBF4OR77K9Ktn3o0tmXM8EJgFZHDzguTAwGV33Q?=
 =?us-ascii?Q?DeGgPLokfyAt4QpY05wc5S91SCONDLlu2N8BgjOFI9qkicpuM4ZhaoIUHkTA?=
 =?us-ascii?Q?dhTmrx5IIYOfrlnTiQ7QPy3OJ0PhHgbLRsb6jG+gUfKLmD+c4LfcLoIQA0UU?=
 =?us-ascii?Q?tcC1j3P7oY1ReRcrVfZBEpapyS2jfRtEF+tB6vePAL2iQfOfeMp4Zz/BW7YN?=
 =?us-ascii?Q?JDB4YkTO2z6V+ZKB6+oKx0DQbDpJh7PXwewXnINk3QFJGVpn+UOaev2RUZym?=
 =?us-ascii?Q?26X+fI9aGmsCXql8AbLykH2V4R0HcSDR/zcwjDpf6GNHYnBSPm6Z+tdO6N8P?=
 =?us-ascii?Q?vXLmF0HOiDmXTGjqEvjfkuRsOEMfLQT/BOl0VFnc70MvOzOnZrE+iJKYeISJ?=
 =?us-ascii?Q?PVI8/8gvjC5yM79uvukquuZqt5c7OshkcWke+1qxWOml+acEVFxSr4sQcWuU?=
 =?us-ascii?Q?dZGtySBCk+BrQIQvbJBYD16x2HWvAQrrqzlnvYLIH5qhx+pNYCM9Cqd+8tzj?=
 =?us-ascii?Q?7bR/LI9PoLi5iWZZKO6TVKvqLVOvVwAhVQXV4HHjq5GLJFmqDLf5RCm+QDqu?=
 =?us-ascii?Q?Y0onfkr0ozeWGgqz1/+ST0Uvmwr703TfGEwd9oL+65nAJUaVxJzLvQMDNb88?=
 =?us-ascii?Q?MmSmTraxq+5NLEQLqHis+hj2iI6q/mc0lr+3hBSv86LMbd6ZtNcWFsFldBeJ?=
 =?us-ascii?Q?tyVtm43oywdY7p/CuCiDyLtJz5Ky1bzoydGBRquwlhRNIDFwq5iu8CuuAC7w?=
 =?us-ascii?Q?uN8HBM93vzOrdFmz8E25G2lfaBSrWUsPM1Lp7yK8BZ52k5KWbPECfpbVsrxv?=
 =?us-ascii?Q?ZI/zkgg1wpBW4IfCB+OQK9Zyj4niZHjVKGAaiQ2xISSp19Ce6lSEaYw1JHyi?=
 =?us-ascii?Q?fE6ZlUYO1WXRZHErQhBeGTsdPLRb7ZTAO2KX5eCEmhWXW50GjKubbyMr1uwB?=
 =?us-ascii?Q?Lhf1abWpVXniPiks4rwTIbquzEltq7wiuKiibUnI9ySpADxhGo6L3lSz+hFK?=
 =?us-ascii?Q?5zS1zVj12Vxk2B8OLJeZ0xbWBFnPMC7LgpyialvDsuYNtqcLKGdE4XrREK4L?=
 =?us-ascii?Q?wD/90TTp3aUPI+sIP0Ygh1OPYfSloQxB9Ff1ILMerqX5iDzvz3HfZzMBsCIq?=
 =?us-ascii?Q?zc40ikEZ06R5b1g4Re6fL9lQnsgroKi3KeJli0A+ELzhxfJXZ2pEqHYMivcA?=
 =?us-ascii?Q?Yzc890VcuHOAKU0/J2A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18d4be5-2736-4c5b-103a-08d9ba892d8a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:27:38.9444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6MfCoizB5EmYCf/ej5ioUgYGcXJlKELOf9ZJaYIZQXt/OMiU+595Y7ScyEYwtAaA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5031
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 08, 2021 at 09:06:47AM -0700, Alex Williamson wrote:
> On Tue, 7 Dec 2021 11:51:45 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Dec 07, 2021 at 12:16:32PM +0100, Cornelia Huck wrote:
> > > On Mon, Dec 06 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > On Mon, Dec 06, 2021 at 07:06:35PM +0100, Cornelia Huck wrote:
> > > >  
> > > >> We're discussing a complex topic here, and we really don't want to
> > > >> perpetuate an unclear uAPI. This is where my push for more precise
> > > >> statements is coming from.  
> > > >
> > > > I appreciate that, and I think we've made a big effort toward that
> > > > direction.
> > > >
> > > > Can we have some crisp feedback which statements need SHOULD/MUST/MUST
> > > > NOT and come to something?  
> > > 
> > > I'm not sure what I should actually comment on, some general remarks:  
> > 
> > You should comment on the paragraphs that prevent you from adding a
> > reviewed-by.
> > 
> > > - If we consider a possible vfio-ccw implementation that will quiesce
> > >   the device and not rely on tracking I/O, we need to make the parts
> > >   that talk about tracking non-mandatory.  
> > 
> > I'm not sure what you mean by 'tracking I/O'?
> > 
> > I thought we were good on ccw?
> > 
> > > - NDMA sounds like something that needs to be non-mandatory as well.  
> > 
> > I agree, Alex are we agreed now ?
> 
> No.  When last we left our thread, you seemed to be suggesting QEMU
> maintains two IOMMU domains, ie. containers, the first of which would
> include p2p mappings for all PCI devices, the second would include no
> p2p mappings.  Device supporting NDMA get attached to the former,
> non-NDMA devices the latter.

I think it is another valid solution, yes, As are the ideas you
identified

It is also OK what you said earlier, that qemu can just permit a guest
to mangle its migration and not do anything. I don't like this, but as
policy it is something userspace could reasonably choose to do.

The question here, right now, is what should the kernel do?

 - NDMA mandatory/not? Given we know Huawei cannot implement it, I vote
   for not mandatory
 - Should we expose some other flag, eg you 'fragile mmio' to help
   userspace form a policy? Might be useful, but also can be defined
   when someone creates a userspace policy that requires it.

Either way kerenl is just reflecting HW capability to userspace, I'm
not seeing how this can be the wrong thing for the kernel to do??

> So some devices can access all devices via p2p DMA, other devices can
> access none.  Are there any bare metal systems that expose such
> asymmetric p2p constraints?  I'm not inclined to invent new p2p
> scenarios that only exist in VMs.

Migration on baremetal is a bit odd, but all the rules are the same.
The baremetal must reach the P2P grace state to avoid corruption and
if it can rely on internal knowledge of how it operates the devices it
can avoid things like NDMA or multiple domains entirely.

> In addition to creating this asymmetric topology, forcing QEMU to
> maintain two containers not only increases the overhead, 

Yes, this policy choice has downsides. I outlined a few options where
qemu can avoid the overheads.

Other choices have different downsides.

I think part of the reason we keep going around this topic is I'm
offering options that a VMM could do, and I can't much help you decide
what matches qemu's policy framework. Frankly I think it is very
operator specific.

> but doubles the locked memory requirements for QEMU since our
> current locked memory accounting is unfortunately per container.

You asked for that to be fixed in iommufd and I've got that almost
done now. With iommufd we can now have two domains with only the
overhead of the actual io page table entries under the 2nd
iommu_domain.

When VDPA uses iommufd as well it should allow qemu to be single pin
for everything.

> Then we need to also consider that multi-device groups exist where a
> group can only be attached to one container 

It is a problem, yes, but again qemu could adopt a policy of not
support multi-group migration devices, if it wants.

> and also vIOMMU cases where presumably we'd only get these
> dual-containers when multiple groups are attached to a container.

Not sure where this means? vIOMMU should operate both containers in
unison, I'd think?

> Maybe also worth noting that we cannot atomically move a device
> between containers, due to both vfio and often IOMMU constraints
> afaik.

I don't think we need move, it is a permanent setup?

> So it still seems like the only QEMU policy that we could manage to
> document and support would require that non-mandatory NDMA support
> implies that migration cannot be enabled by default for any vfio device
> and that enabling migration sets in motion a binary policy regarding
> p2p mappings across the VM.  I'm still not convinced how supportable
> that is, but I can at least imagine explicit per device options that
> need to align.

If this is what qemu community wants, OK.
 
> I don't know if lack of NDMA on ccw was Connie's reasoning for making
> NDMA non-mandatory, but it seems like NDMA is only relevant to buses
> that support DMA, so AIUI it would be just as valid for ccw devices to
> report NDMA as a no-op.

ccw seems to support DMA, it calls vfio_pin_pages() after all? That is
DMA in this definition.

NDMA here was defined in terms of *any* DMA, not just DMA to certain
addresses, so I expect ccw will probably say it does not support NDMA
for many of the same reasons Huawei can't do it.

So, I think Connie is right to be worried about a direction to require
NDMA as a pre-condition for a migration driver. I suspect something
like CCW is very much migratable with a method that relies on no mmio
touches much like the Huawei driver does. 

In the S390 case I believe "no mmio touches" means 'whatever that
thing inside kvm that causes the device to work' is.

BTW, it is not just VFIO, but VDPA too.

Currently VDPA cannot participate in the P2P mappings so it acts like
the dual domain solution, but with IOMMUFD I expect VDPA to be able to
access the P2P mappings and so it must also support NDMA somehow.

Future things like the "netgpu" patches make it reasonable to combine
VDPA and P2P in a guest.

> > I honestly don't know why this is such a discussion point, beyond
> > being a big oversight of the original design.
> 
> In my case, because it's still not clearly a universal algorithm, yet
> it's being proposed as one.  We already discussed that {!}NDMA
> placement is fairly arbitrary and looking at v3 I'm wondering how a
> RESUMING -> SAVING|!RUNNING transition works.

Ok, I've been struggling since I wrote this to figure out how to
validate the precedence algorithmically, and I think I see it now.

Minimally, the precedence must be ordered so we never transit through
an invalid state.

Ie if userspace asks for

 RESUMING ->  SAVING | !RUNNING

Then the start and end states are valid.

However, we cannot transit through the invalid state 'RESUMING |
SAVING | !RUNNING' on the way to get there. It means the driver cannot
do RESUMING first, and is really the underlying reason why we found we
needed precedence in the first place.

So, my original design idea is just *completely* wrong.

Since we allow 0->ANY the better solution is to go toward 0 first,
then go away from 0:

 - !NDMA
 - !SAVING
 - !RUNNING
 - !RESUMING
 - RESUMING
 - RUNNING
 - SAVING
 - NDMA

and even this I can't tell by inspection if it is OK or not - need a
program to explore all combinations.

Basically, this is too hard. I can possbily figure it out now, but if
someone wants to add another state someday they *will* screw it up.

How do you feel about simply forbidding this corner case entirely?

Require that new_state ^ old_state is one hot.

I have to check, but I think this is incompatible with current
qemu. Maybe we can allow & document the few combinations qemu uses?

A core function can enforce this consistently for drivers. 

??

(frankly, I have decided I absolutely hate this device_state bit field
as a uAPI choice, the fact we have spent so much time on this is just
*grrrrrr*)

> accessed directly.  We can have a valid, interoperable uAPI without
> constraining ourselves to a specific implementation.  Largely I think
> that trying to impose an implementation as the specification is the
> source of our friction.

I agree, but please accept it is not easy to understand what is spec
and what is qemu. It is part of why I want to write this down.
 
> This is a bit infuriating, responding to it at all is probably ill
> advised.  We're all investing a lot of time into this.  We're all
> disappointed how the open source use case of the previous
> implementation fell apart and nobody else stepped up until now.
> Rubbing salt in that wound is not helpful or productive.

Sorry, I'm not trying to rub salt in a wound - but it is maddening we
are so far down this path and we seem to be back at square one and
debating exactly what the existing uAPI even is.

> Regardless, this implementation has highlighted gaps in the initial
> design and it's critical that those known gaps are addressed before we
> commit to the design with an in-kernel driver.  Referring to the notes
> Connie copied from etherpad, those gaps include uAPI clarification
> regarding various device states and accesses allowed in those states,
> definition of a quiescent (NDMA) device state, discussion of per-device
> dirty state, and documentation such as userspace usage and edge
> cases.

Okay, can summarize your view where we are on all these points? I
really don't know anymore. I think the document addresses all of them.

> Only the latter items were specifically requested outside of the header
> and previously provided comments questioned if we're not actually
> creating contradictory documentation to the uAPI and why clarifications
> are not applied to the existing uAPI descriptions.

As I said, it is simply too much text, there is no simple fix to make
the header file documentation completely clear. If you have some idea
how to fix it please share.

I don't think the new docs are contradictory because the header file
doesn't really say that much.. At least I haven't noticed anything.
Yishai's patch to add NDMA should add it to the header comment a
little bit, I'll check on that.

> Personally I'm a bit disappointed to see v3 posted where the diffstat
> indicates no uAPI updates, so we actually have no formal definition of
> this NDMA state, 

I didn't realize this is something you felt was important for this RFC
patch.

The purpose of the RFC patch is to get some overall mutual agreement
on the uAPI protocol as discussed on the RST text. The non-RFC version
of this RST will come with the next mlx5 driver v6 posting and the
implementation of NDMA for mlx5 and all the cap bits Yishai built for
it. This is already coded - we have only refrained from posting a v6
out of respect for everyone's time to re-look on all the mlx5 code
again if we are still debating big topcis in this text.

If you recall, I said we'd like to go ahead with mlx5 as-is and you
were very concerned about the implication of the NDMA problem. Thus
this document was prepared to explain our view of NDMA and more, plus
we went and updated mlx5 to fully implement it so we will not come
back to this topic later in the kernel.

> get there.  Isn't that how we got into this situation, approving the
> uAPI, or in this case documentation, without an in-kernel
> implementation and vetted userspace?  Thanks,

I'm certainly not proposing we do that, please don't mis-understand.

Jason
