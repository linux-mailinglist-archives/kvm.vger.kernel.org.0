Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3A3346920
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 20:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhCWTcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 15:32:45 -0400
Received: from mail-bn8nam12on2042.outbound.protection.outlook.com ([40.107.237.42]:17825
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229984AbhCWTcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 15:32:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksIP5Klz8XH6lRV2SAr8BmAq8sXW2zhBQ9O212lP2A8sBgY+9USzaH5hwGIYrnv8kzNO/FNV5a7O6Gp4MAbksU0lA3MYrIfesazxIOZF1DwinlQGyDOfMlLITxO6Iog7/zk1P1nSDq5Nk0a0rybxjISBobswYuL7phJCIO08Fjt7RxBOn2oFfRloPRtX6Pbx2Kk9wqeZaS8LGA3M3e2pFWgyfmwuKgm87AsrAWuMPBqYQvMOsKTa0emMBka2xs+KXL9OM6/jH9TFHLKgV6ZdW1yq3NnJnjcn7nc56x0gugvXhoPBnUHbrnOq8ThZ1c5UtVcAmeDRYoPYe5/4LfZmSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQlU16KGEBJ3O5gbMWmj7xivDSNmcbYiNM8oZpQ1pbM=;
 b=GsNVwiWRgo74iX3YQSVP8uon3QXlr4z0vIXjQs2aI2vBnOC//Qc3/myFh52ntz+gnYpiM06r7cBmZ6CBp6efiDPYWSLUSTUTjU9i5HUtqcjbMIZvOWsCddRTAqPwUmvGx6alRJ+jYdKhPVdOrsziitrZjThJkKYY/ZYXZqy4bSTgsIBkaxXoANbGvJkMmjlya+8dzcW2PyhZF3o74Lr8GsFcjgU61+SLFbfoD9HsuIB8cez9mBM/tP9WpKUEKXqQuPwq59CzvFzNFdJ3o0XRuiDU/KuxELuV63e/YqotY/UR1XOfWkzBwN5qrgjdo9im137vBKpFMR8pVu6wZxkt2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQlU16KGEBJ3O5gbMWmj7xivDSNmcbYiNM8oZpQ1pbM=;
 b=rrTBGCajO+aYKTOD3DxNpKWbiqpJbXaSsoJTAj7eYuLcMHkM2778Z2e59D7TT3DpWcpyJ/jsGCivGJJN9teKWZ25HoyfALOXnkwlKs01WrI6NJOaQnXe7ZmUyKXpGE49O+HJ3BcnR+ItxfXax6jy0uXDdOYVy1YoNMTSsc4XQY+gIvOVdfNHrnPbxeIjg75bLahw7bko+ihbFqsOiRTH7wDCsPpjF9nrtRADlt1I9Wupt856KRwi8Ah5paexU+1tNUvQaWD3zntKkEdvT1iLUjyk8XCLyOz2muaRqemzJUF8Vhgv4I95jbyiXa22W/4W4uXaO/iNKCkbBCtZK7D+jw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3515.namprd12.prod.outlook.com (2603:10b6:5:15f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 19:32:15 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 19:32:15 +0000
Date:   Tue, 23 Mar 2021 16:32:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210323193213.GM2356281@nvidia.com>
References: <20210319162033.GA18218@lst.de>
 <20210319162848.GZ2356281@nvidia.com>
 <20210319163449.GA19186@lst.de>
 <20210319113642.4a9b0be1@omen.home.shazbot.org>
 <20210319200749.GB2356281@nvidia.com>
 <20210319150809.31bcd292@omen.home.shazbot.org>
 <20210319225943.GH2356281@nvidia.com>
 <20210319224028.51b01435@x1.home.shazbot.org>
 <20210321125818.GM2356281@nvidia.com>
 <20210322104016.36eb3c1f@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322104016.36eb3c1f@omen.home.shazbot.org>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YT1PR01CA0005.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::18)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0005.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend Transport; Tue, 23 Mar 2021 19:32:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOmlB-001f2k-CM; Tue, 23 Mar 2021 16:32:13 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f528cc8f-e351-498f-a84b-08d8ee325d02
X-MS-TrafficTypeDiagnostic: DM6PR12MB3515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB351569AE05460EDF8D0A920EC2649@DM6PR12MB3515.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xuJCDgsq+Vtwn7FUoo5sqFbj9vBDzh6PxvXu/yJL/F87sa8RtdQgLsdoGJGOC/4imRZOqyVFVS5P5afBYra95jvo1urVUUAlzYeXa/msfTPDHsB9dI2ZRKKYFwgUroXvUlRfHaYO0d8fSldc7w8D3+J+7XqPU1qkunlRKiFYkRVU28TwT5eogfqN+klDkizCZ0hdn18w+Jbh0NZFTLfQSgo25rI27E7Z5BR7QoV6A91Wrzof/ps46j3tGeiQ066OOKK0qmeyA31DtiCp+wu4LJHEIFYKLVqDzAqVUG2Vcm9kDAtJD4k2QMKvI+oeAa1YvsUXJneJgixut9b4dZrrhE+VPuEXMrWAOb58IgBPekOOy+A9L1fdtdm8c+/L4h3uzoAi9kiBEafTtZZW3w6t6Ey1IuL17m55JAe1Mijy3cOrEhmUICmfl6bzTbXT4drtyU1Yhe25w3h0TvhLwO56PcGh9aMoFdGahwMpfIx9LpMcHui06/+1FkZyRLZzm3kkmhpfPfSth+DOXEOyGP155YiZ19vwfhWIxbzFz4fqrpq0CQJpAxhAbps0Te0AlBC7NIbdnU4QmbIPfFieqkIxJLNOHjk4Va98DpdaJcrJ0IoVOVXSkaJX2ec2JOc8uG/Bjy0mc1a19xxxjKwWx7QDamxguY34kZk+iTqeDcX7crk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(2616005)(5660300002)(83380400001)(8676002)(8936002)(478600001)(33656002)(1076003)(36756003)(66946007)(2906002)(66476007)(66556008)(426003)(316002)(86362001)(54906003)(38100700001)(9786002)(9746002)(6916009)(26005)(4326008)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sg95DO7iByEd9DV7phdNXO0PP9pnhco+jT8uLryRucD43q/kwqqN/UuX3cP7?=
 =?us-ascii?Q?tz6AM1slNuK4QijkQzWTrji03jE3nnkr+2Ol8mQSMebBs8C2N0JJ+xdPu/eY?=
 =?us-ascii?Q?zcHtiRwsJbgyu5TZl6x1XRqM125kJ6os+V79dUe4pNi90Jn0ix7Jn33pPfNx?=
 =?us-ascii?Q?uL746MoLkzCfFGz1574x0TbG0QY5KG3aDLZ1HHSsMuYnwxbT3KBDHMntZe8E?=
 =?us-ascii?Q?Zfm+NblpkfWg0p+g7QF5JhGm8h62B5KjOT5VO0JVKaoor7dCUJknvpaNgkmJ?=
 =?us-ascii?Q?zUDbfbxnkEKU78CFyKlqiwfb2LQdbtA7Zs8rozoBydPPiK5mHZkthU+cCC8S?=
 =?us-ascii?Q?QOuDG2jo3kLfqooKtc9kLjDizxus0zTwfSMw2izzTnoIog6ZJ+aD34DE82yV?=
 =?us-ascii?Q?WCPyF0vqjvaqhybeA32BWFPHoypqhobgm7Ll2M77VlLnIdWdDDcpujWhZxBU?=
 =?us-ascii?Q?0+VYNtydL5D6P8Cfd/yX0cgFPI9SjJb5bMz+V2VAn/FfFzP5nP5o+eA98ytv?=
 =?us-ascii?Q?HsZqSwjV1GuWySg3bgdajuKjx2wEJDmz1Co9bY1HLa1sTPPCmWFiuwQqlXAU?=
 =?us-ascii?Q?u4asv5TW2TJ4bGlzJPEGHb2yvKnuAvdgybQaQ1cEOG8Fnz9bI2E7GJHv6SpF?=
 =?us-ascii?Q?eakn/0MrBdfXrVA+f5KhuAo22rZSvWfulgsqsD/wyCxntrzywOos2k2sQxBu?=
 =?us-ascii?Q?sBm4TJfzVde72jFAKY8w65P2l2vf1lfxiVZ60bvgtivjzYGFGCJ1DZx4JxAP?=
 =?us-ascii?Q?zLqf9eqgVAw2kmIb5YHGNRCwbLjZosUvYfThoYCnrx/w6xdCAJHLWawA15Hi?=
 =?us-ascii?Q?DoIFLW4mJkcebpH8xbqQf0M2dxydyQvSzHhUjMbYr1qe+yS+ATNuIJ0Muhdh?=
 =?us-ascii?Q?mCYMSaCPFOXEg1WpHj8IlWtgR4M1YFJCJhx3A9qpHAZObbhR9XnVMsmMQuko?=
 =?us-ascii?Q?bqgQKjs2wnVsc9pyvodlLhB7HGdt34ewJTlV6xsOkIIaAXWIIHh0s/9WXrC4?=
 =?us-ascii?Q?J+QJDXcZVHKtsqYa7qtneC0g+IbZ9mjwFNOo69KHlb2AVpGgEnj/KGx+ifMz?=
 =?us-ascii?Q?0/GqIJBh7dioRy5fO+/tvz/KQdf4/K1P66pcfWv2tntepZb/Gf8EWF+PRMhj?=
 =?us-ascii?Q?c61haSHOcU2oNyuWNaH3Ye7+2H5ROLwlOd8ZD5cKRJXSzDVWHFQ2ziM/LuYL?=
 =?us-ascii?Q?HRmEOYS/lXprSMAHaeB1HYvS1q2YGe3k6MkqtZq6yZIVjFwWfFBQrh9X6I1O?=
 =?us-ascii?Q?8wqK4OzPjPXg1mkHbpC0D7smnSR+rNYgr+LnXsyLG1AvDf8G3vkg+DWeOt55?=
 =?us-ascii?Q?mZFu0QB9nKdWY9E0Uq1GJbnR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f528cc8f-e351-498f-a84b-08d8ee325d02
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 19:32:15.2983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9et1hMVwhFuPfnT22hGdnzS/jtHrTuwIhkYI5wdnFpOesVdo/VwXd309+gCDAeL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3515
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 10:40:16AM -0600, Alex Williamson wrote:

> Of course if you start looking at features like migration support,
> that's more than likely not simply an additional region with optional
> information, it would need to interact with the actual state of the
> device.  For those, I would very much support use of a specific
> id_table.  That's not these.

What I don't understand is why do we need two different ways of
inserting vendor code?

> > new_id and driver_override should probably be in that disable list
> > too..
> 
> We don't have this other world yet, nor is it clear that we will have
> it.

We do today, it is obscure, but there is a whole set of config options
designed to disable the unsafe kernel features. Kernels booted with
secure boot and signed modules tend to enable a lot of them, for
instance. The people working on the IMA stuff tend to enable a lot
more as you can defeat the purpose of IMA if you can hijack the
kernel.

> What sort of id_table is the base vfio-pci driver expected to use?

If it has a match table it would be all match, this is why I called it
a "universal driver"

If we have a flavour then the flavour controls the activation of
VFIO, not new_id or driver_override, and in vfio flavour mode we can
have an all match table, if we can resolve how to choose between two
drivers with overlapping matches.

> > > > This is why I want to try for fine grained autoloading first. It
> > > > really is the elegant solution if we can work it out.  
> > > 
> > > I just don't see how we create a manageable change to userspace.  
> > 
> > I'm not sure I understand. Even if we add a new sysfs to set some
> > flavour then that is a pretty trivial change for userspace to move
> > from driver_override?
> 
> Perhaps for some definition of trivial that I'm not familiar with.
> We're talking about changing libvirt and driverctl and every distro and
> user that's created a custom script outside of those.  Even changing
> from "vfio-pci" to "vfio-pci*" is a hurdle.

Sure, but it isn't like a major architectural shift, nor is it
mandatory unless you start using this new hardware class.

Userspace changes when we add kernel functionality.. The kernel just
has to keep working the way it used to for old functionality.

> > Well, I read through the Intel GPU driver and this is how I felt it
> > works. It doesn't even check the firmware bit unless certain PCI IDs
> > are matched first.
> 
> The IDs being only the PCI vendor ID and class code.  

I don't mean how vfio works, I mean how the Intel GPU driver works.

eg:

psb_pci_probe()
 psb_driver_load()
  psb_intel_opregion_setup()
           if (memcmp(base, OPREGION_SIGNATURE, 16)) {

i915_pci_probe()
 i915_driver_probe()
  i915_driver_hw_probe()
   intel_opregion_setup()
	if (memcmp(buf, OPREGION_SIGNATURE, 16)) {

All of these memcmp's are protected by exact id_tables hung off the
pci_driver's id_table.

VFIO is the different case. In this case the ID match confirms that
the config space has the ASLS dword at the fixed offset. If the ID
doesn't match nothing should read the ASLS offset.

> > For NVIDIA GPU Max checked internally and we saw it looks very much
> > like how Intel GPU works. Only some PCI IDs trigger checking on the
> > feature the firmware thing is linked to.
> 
> And as Alexey noted, the table came up incomplete.  But also those same
> devices exist on platforms where this extension is completely
> irrelevant.

I understood he ment that NVIDI GPUs *without* NVLINK can exist, but
the ID table we have here is supposed to be the NVLINK compatible
ID's.

> So because we don't check for an Intel specific graphics firmware table
> when binding to Realtek NIC, we can leap to the conclusion that there
> must be a concise id_table we can create for IGD support?

Concise? No, but we can see *today* what the ID table is supposed to
be by just loooking and the three probe functions that touch
OPREGION_SIGNATURE.

> There's a giant assumption above that I'm missing.  Are you expecting
> that vendors are actually going to keep up with submitting device IDs
> that they claim to have tested and support with vfio-pci and all other
> devices won't be allowed to bind?  That would single handedly destroy
> any non-enterprise use cases of vfio-pci.

Why not? They do it for the in-tree GPU drivers today! The ID table
for Intel GPU is even in a *header file* and we can just #include it
into vfio igd as well.

> So unless you want to do some bitkeeper archaeology, we've always
> allowed driver probes to fail and fall through to the next one, not
> even complaining with -ENODEV.  In practice it hasn't been an issue
> because how many drivers do you expect to have that would even try to
> claim a device.  

Do you know of anything using this ability? It might be helpful

> Ordering is only important when there's a catch-all so we need to
> figure out how to make that last among a class of drivers that will
> attempt to claim a device.  The softdep is a bit of a hack to do
> that, I'll admit, but I don't see how the alternate driver flavor
> universe solves having a catch-all either.

Haven't entirely got there yet, but I think the catch all probably has
to be handled by userspace udev/kmod in some way, as it is the only
thing that knows if there is a more specific module to load. This is
the biggest problem..

And again, I feel this is all a big tangent, especially now that HCH
wants to delete the nvlink stuff we should just leave igd alone.

Jason
