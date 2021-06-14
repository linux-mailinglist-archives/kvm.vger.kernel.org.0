Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E153A68B3
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 16:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbhFNOJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 10:09:18 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:40288
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234235AbhFNOJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 10:09:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVijEAJnKTNemDAUOWIvKwmdodCjs63P/FtVGeMDkKd+kQPTbGmo8BH5E1FNxhfXhZZJsoH2JK0WbPUgUxZuXFxhfgMflfezR7xHXJptNTG6bxE1DrqN9DW6rPanhcK8wb7ya+/4SVRzYxhAjI436YqmIIxf+bCD+EJ34wqfo9nF8Y2bFH/AoUrMOATCqTJYdF7FbWV6w59qUR87Apowzt461eFKcrO5vV5PoVSR1ANDHOCgpwcU2mEEbYoizRxdv8BaQTZlkQKqqgpOg69tI4YXhJtmv1NAzn+NU4+LOwv+dLXKs9NUZfGX6q8FpT73MIJ3kcpVFZo4+/U2GddgyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Gymw59eIbR7qOWGS1JRv6090P3iZJQawe7yyGi5WI8=;
 b=eQfQBuricfKWXn7aC/YV5ZzGbdT0IKRhU1jzWAS/0dpyAIMQjNC50bCxPnNnO8PkJUWABqYkP2BEVz9zwYh5uOf3AymMTwkm7VeoE8apdBOlf99lBZy9uUlaRQeho6D3TGp1Q6y4gMkrrpM1T6zKOqCoeCUNfAvyOMxbJeYbahm3DyusKZKdIgH0ZrCMLJbaNbL9rFGcusK36j0YVBN9f+GlKj8D/wBd0srnBjRIafFv/xi0IyHFLDJyw3LJj6sZoqgvTI9ua59QCbtMBU0203ySMkeV0UhE1u07v60F1c+yna75kF6sgMI/aQyIRrJWMSypfXL3fmhleCFLSLGNOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Gymw59eIbR7qOWGS1JRv6090P3iZJQawe7yyGi5WI8=;
 b=NSet68nCK0717s5xwRFY4CAJJorkJHfo2efTBLurTUE8mHjM3PUYdOJChYeKmUISqcoUlmPiL019xWg9JdNVUwXUjrSLwimkow8AEVWespst0IxXR2yJqnecITqJIG5R9+00J22J7gA2zmD6jmBtO3VvfIeePb9gvuKG9VekyLlhMylYeWYboTl4C7wPPGEvF5smTxQAeWgaom4UpGFMgdh4WJKLLIp43elPXkzTXRVmiTE7SKu5jXHEFYih7ql2kI1efk/nvz23HrpyXpntJEOflcQeK4HQ1oGZKHKwsHOPkYDZVf1/wQSDWFlw0Hy/07hjuZozBzWdonUQsnXGEw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5175.namprd12.prod.outlook.com (2603:10b6:208:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Mon, 14 Jun
 2021 14:07:12 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 14:07:12 +0000
Date:   Mon, 14 Jun 2021 11:07:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210614140711.GI1002214@nvidia.com>
References: <20210609150009.GE1002214@nvidia.com>
 <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
 <20210609102722.5abf62e1.alex.williamson@redhat.com>
 <20210609184940.GH1002214@nvidia.com>
 <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
 <20210611164529.GR1002214@nvidia.com>
 <20210611133828.6c6e8b29.alex.williamson@redhat.com>
 <20210612012846.GC1002214@nvidia.com>
 <20210612105711.7ac68c83.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210612105711.7ac68c83.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0387.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0387.namprd13.prod.outlook.com (2603:10b6:208:2c0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Mon, 14 Jun 2021 14:07:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lsnF9-006dVr-NR; Mon, 14 Jun 2021 11:07:11 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 262c875e-dc4d-4856-1662-08d92f3db4ef
X-MS-TrafficTypeDiagnostic: BL1PR12MB5175:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5175C2E568C65DBD9A1DB40EC2319@BL1PR12MB5175.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Xb1bBXLdcLPiMeXWj5woWHzJAtgPKv+frH+202UnTecPJVoojgaegKN8dEKy1rEmZ3To/Y04c/IuwdvWg8aqiyN7HEx07vBq2kXKKsr2D3Xl0szLRGJ7LICFaN51mqQRheeaU6s+VptNd1su+EqbZZHCehnU+yLzSP+mnZjGT4tjEe7UD5QbITcKOPOj6A+v+cuYgbkPaceY9tEuAhN4QkHDri0YepA8QIw0NZ+A2ibH3t5IM7oFCTNQE0QoWgYzi8pc4eIo3p+xQGDSapa1Y1OmcX68jttweHYyVPaxsdsDnde9pkMAu++FgQirTvNoMz73ZlF2NMBNlm35LfiB30er9vXfuNq9hkeYajHFtQY4GDlUr90RPGvFDZEs2bmeaLA5WigZ75Jwc4xCIx1I6KBnxs5M7PJJqjciJP/Q6RFS1vqDxdluMVNUnpPrT6O8THS5alvJjbHczBCn1uyqktcrqkPgWlJb3fRLWgQNSUTI8P/bJXWKmBPHOb+Hji+U3F0tI/kzFfJS8VTdlVrZ+jwvFqxICNGFGUI/MAm9UTLDmxv/WqvVLAEkCyQUYnYE6T5/v/QYIb8N9ihNxHya2TLpdOkhiuP3i2Fc1bpPgU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(83380400001)(1076003)(2906002)(7416002)(36756003)(54906003)(66476007)(2616005)(33656002)(26005)(9786002)(498600001)(8936002)(9746002)(186003)(86362001)(8676002)(6916009)(4326008)(426003)(66946007)(66556008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?clw0fF+cUZxBAkZa8NZXg8thmHEdMcj63lfxdoTHsMoNLchzzDVyisJnVSO8?=
 =?us-ascii?Q?ngL65k/MjWJGOZHdYUnb/cp5nzzKuIROqYLbcAeDiMwvKJ5PKc8CBzKXnxhm?=
 =?us-ascii?Q?R69eJQq3LwrdoxQSJ759mxtVI//4HvtUusIlw47Wwt5XKbb4hsW02Ta0mL+Z?=
 =?us-ascii?Q?GGdTP9LRwBEXxlFhbmo6kZ6f4hfzxfhuvFXIlg6LnjlpS8/osmb9fOSa8eXp?=
 =?us-ascii?Q?Gv5aMcKmYpsGzQ5j7GLqr6N90vuVBA+WBMD04KFzd+fIQ6HwK60SHxRhGa8T?=
 =?us-ascii?Q?tbkQ8n2j7dB/Y1STZdSVDIvQN7jayZTuHH9gtAeus8fBAgxDGS0haT+CGCLs?=
 =?us-ascii?Q?CtToBdQ5iyibqTTVSbM6tSExaWwjqoxO6DAuuZ6KpMuc8eoa3JUnqU2+RN3T?=
 =?us-ascii?Q?NZORa/Ik1w7EMGNKOjKNsUYHktQBiROqWb0Ph+KTOrloRSJjIGo6dhiyQ/oZ?=
 =?us-ascii?Q?2QT2/NnaP2ZjoIS4k9h4Xagf67SaOydDt9fe4iirFekr5rxPqbi6sCqaVNck?=
 =?us-ascii?Q?S/HS3VuzQ+cXfa20Z6bmG6Nw4nM86LoJ1GhiELs0PpCv3DSpb/QrsvqacdIW?=
 =?us-ascii?Q?spypclr4unM+mu6Jtl90Ixw4St7UszBT2KhN1plgXMSElSLxUM204TwTm+fG?=
 =?us-ascii?Q?UStbqVnhGgBnK6S7vnC0+/2tzfaCCbuh9qXmU1dPn+DM5kjHOjBmxcUA7Oc+?=
 =?us-ascii?Q?tYOWPMnuAHVSNI0mBH9MXqsglGlfytkJ0k0eDsvpLKJUeE5dvmHkvKrWpTAL?=
 =?us-ascii?Q?2Lzqpt7WQq6lniUkgIJn5qXAmB6aafcymZAM1t9CkFgEVIH8Jx0XV39lRS6y?=
 =?us-ascii?Q?mznJE3KaCueaSebQjnVYJvZlTP8lTK30gOse6980GPEXBqqT/mts3u4u6h9M?=
 =?us-ascii?Q?WDzPJX9xuHSNv49eo/CN4LNaecffMkWIeuE4uFAptMR6iDCm6FGuMwyGe4pb?=
 =?us-ascii?Q?1dTMa7dx7CPHvb0YCb3eF72/OkS4TJGuz+n6MgNjzBbJzIP2zWLrgux5FuRS?=
 =?us-ascii?Q?dYFa/BSMHImGRgWgC1/GR9mE3T0dt33wpijAAA8fjYIo7LceXpvMmJxpmC8f?=
 =?us-ascii?Q?xLQGIPXl2ycIa1NSrTvxRG00Jebl4tuwhGcAGFv6mXVdUikJziHEMMGTCEon?=
 =?us-ascii?Q?NXjVNkz1MgB2MsjWi6e9ZZ306Xdm80j0o4SBlyJriD8s7idbMIQ7Vbiwbk+f?=
 =?us-ascii?Q?teJpkkIeY+tOOcVUj/9fNT7/2tk7fMOnS8R5nVi0NBUOW6UXw9lEyEjb8Sip?=
 =?us-ascii?Q?buU0F8YbYfOiiQ/HtyvuABtfpjO2KX5KfjV2zkigFdfQEvKBIerAUMdoaYJp?=
 =?us-ascii?Q?1rEc37RHOv3+XcLY6ytX7wOO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 262c875e-dc4d-4856-1662-08d92f3db4ef
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 14:07:12.6655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nngj1IcXpQG9bl9vOgpxXAXx5qq+YPSP999ct7Vvc3lEsXFJcI7No+ube/T+prt8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5175
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 12, 2021 at 10:57:11AM -0600, Alex Williamson wrote:
> On Fri, 11 Jun 2021 22:28:46 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Fri, Jun 11, 2021 at 01:38:28PM -0600, Alex Williamson wrote:
> > 
> > > That's fine for a serial port, but not a device that can do DMA.
> > > The entire point of vfio is to try to provide secure, DMA capable
> > > userspace drivers.  If we relax enforcement of that isolation we've
> > > failed.  
> > 
> > I don't understand why the IOASID matters at all in this. Can you
> > explain? What is the breach of isolation?
> 
> I think we're arguing past each other again.  VFIO does not care one
> iota how userspace configures IOASID domains for devices.  OTOH, VFIO
> must be absolutely obsessed that the devices we're providing userspace
> access to are isolated and continue to be isolated for the extent of
> that access.  Given that we define that a group is the smallest set of
> devices that can be isolated, that means that for a device to be
> isolated, the group needs to be isolated.
> 
> VFIO currently has a contract with the IOMMU backend that a group is
> attached to an IOMMU context (container) and from that point forward,
> all devices within that group are known to be isolated.

Sure - and maybe this is the source of the confusion as I've been
assuming we'd change the kernel to match what we are doing. As in the
other note a device under VFIO control should immediately have it's
IOMMU programmed to block all DMA. This is basically attaching it to a
dummy ioasid with an empty page table.

So before VFIO exposes any char device all devices/groups under VFIO
control cannot do any DMA. The only security/isolation harmful action
they can do is DMA to devices in the same group.

> I'm trying to figure out how a device based interface to the IOASID can
> provide that same contract or whether VFIO needs to be able to monitor
> the IOASID attachments of the devices in a group to control whether
> device access is secure.

Can you define what specifically secure, and isolation means?

To my mind it is these three things:

 1. The device can only do DMA to memory put into its security context
 2. No other security context can control this device
 3. No other security context can do DMA to my userspace memory

Today in VFIO the security context is the group fd. I would like the
security context to be the iommu fd.

1 is achieved by ensuring the device is always connected to an
IOASID. Today the group fd requires an IOASID before it hands out a
device_fd. With iommu_fd the device_fd will not allow IOCTLs until it
has a blocked DMA IOASID and is successefully joined to an iommu_fd.

2 is achieved by ensuring that two security contexts can't open
devices in the same group. Today the group fd deals with this by being
single open. With iommu_fd the kenerl would not permit splitting
groups between iommu_fds.

3 is achieved today by the group_fd enforcing a single IOASID on all
devices. Under iommu_fd all devices in the group can use any IOASID in
their iommu_fd security domain.

It is a slightly different model than VFIO uses, but I don't think it
provides less isolation.

> Otherwise, for a device centric VFIO/IOASID model, I need to understand
> exactly when and how VFIO can know that it's safe to provide access to
> a device and how the IOASID model guarantees the ongoing safety of that
> access, which must encompass the safety relative to the entire group.

Lets agree on what safety means then we can evaluate it.

> For example, is it VFIO's job to BIND every device in the group?  

I'm thinking no

> Does binding the device represent the point at which the IOASID
> takes responsibility for the isolation of the device?

Following Kevin's language BIND is when the device_fd and iommu_fd are
connected. That is when I see the device as becoming usable. Whatever
security/isolation requirements we decide should be met here

> If instead it's the ATTACH of a device that provides the isolation,
> how is VFIO supposed to

Not the attach

> DETACH occur through the IOASIDfd rather than the VFIOfd?  It seems
> like the IOASIDfd is going to need ways to manipulate device:IOASID
> mappings outside of VFIO, so again I wonder if we should switch to an
> IOASID uAPI at that point rather than using VFIO.  Thanks,

I don't think so... When the VFIO device_fd is closed it should
disonnect the iommu from its device, restore the blocked DMA
configuration, and then remove itself from the iommu_fd.

Once the device is back to blocked DMA there is no further need for
the iommu_fd to touch it.

Jason
