Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96783A6F4A
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbhFNTm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 15:42:57 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:54917
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234219AbhFNTm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 15:42:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgAunufiDxBZRergyRJ9dZMU1wexeVvjrqVf9WiIC3XNq/ObLB1sawZBQ2iIKgZ+Ip0tLB2GLFpsbiMbUQVxrDTbs2cMuBvcBBqVfChFxq7K1riLeobfQNq8GGZg/04Q6Zc94gZgSO/eA1a0irtP/TL18/5YQqib0ajGqV5jRss/SDyg7IwPclilG+xnA4B7nzG2v7NYof95HVJ9Zx6DO3plzZefKBcY9H0LxlkQCLNEmkbMI6jRex3MYO/WqAsTKDhEpgtrjkz4rLPcKCzzS5A3EEBmPG80HqgwfkuNz4mDhqQsJIh6QAt8z/RmTPJPFPCU7ZhdLEnWyd3EDTypuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lu+H3eb1IverdTBTEQrQkqVAlsECTu1UT+g4jofLKfk=;
 b=cGdAFG9qQR9j+aFU1B4AowkEjOiGghLeKD2XPessmDN2Wk4GYIV8Uf5l15QXraGJqgHKyHGhDBWebFLgDHU75RiS6/IYtArCip5jT3TGnlGLPrzFd9e1NjYWfmYnMEkd4ZSyjRzsT+zq1rnHdX9CFsoHWpApUOEl5uE1OmV+4uRoGxYsOu1dyU+aWWr9vMJ4FCnMMcTJljZqfFiqxNVuQBwTMnBQELjnqzR03QcIkNe2aXoOdIMzhvtHm/7vO448obl7qieImcRVWoSUDxJ9GhPhTfrnlak1xluKf/bgBmJfcbyd3a3rK8xKUXz3riaRgKsxZveoKMYXBuG7dlsFdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lu+H3eb1IverdTBTEQrQkqVAlsECTu1UT+g4jofLKfk=;
 b=p+VtW7fxPNISxLKuiuflrBJOdzpWEKpia7VLQ3IbAlVpuef616RKIaRGzv3tXsPHK3/2gHWXxFJK1/KCg8hA/KeBRcf2v/5cqpwff8dO6/anDq7lPrzzpptlfuNfaMAtjNnyhtOmAMAy9Ux+dtJ6tBV3/CHyDcrK0/Oi0+QMlehXz/eFWLs/Q4FjbXJsBgn6ixVyfI6KjBlBBsfLe6wwL2wHAupSrkSSdnjEFCl1blTvqZyqw/saAC0zBtxoloxiATESMMY9IufxkWomCqdNd0jfbopeUFz71qX6TnjQ8pGgFwdd+GjptwP8nwqWIxcRjC1YXpgN65DCQm3D5KcM0Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5508.namprd12.prod.outlook.com (2603:10b6:208:1c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Mon, 14 Jun
 2021 19:40:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 19:40:51 +0000
Date:   Mon, 14 Jun 2021 16:40:50 -0300
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
Message-ID: <20210614194050.GM1002214@nvidia.com>
References: <20210609101532.452851eb.alex.williamson@redhat.com>
 <20210609102722.5abf62e1.alex.williamson@redhat.com>
 <20210609184940.GH1002214@nvidia.com>
 <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
 <20210611164529.GR1002214@nvidia.com>
 <20210611133828.6c6e8b29.alex.williamson@redhat.com>
 <20210612012846.GC1002214@nvidia.com>
 <20210612105711.7ac68c83.alex.williamson@redhat.com>
 <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614102814.43ada8df.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:208:32e::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0130.namprd03.prod.outlook.com (2603:10b6:208:32e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Mon, 14 Jun 2021 19:40:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lssS2-006sqO-2Y; Mon, 14 Jun 2021 16:40:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e6f962e-3ea8-4c90-3b40-08d92f6c511b
X-MS-TrafficTypeDiagnostic: BL0PR12MB5508:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55083876957544603B05E85EC2319@BL0PR12MB5508.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: foOh25oDjiY1Jc3dr6u7iafOs9KbYInJW3tVL4dyPK5F2A/MfsyKsax7FfxbqmL2rufCXXb7+hBF01X24qA2t0kLM/8QVDCmxhY8OXgsVCyUAjDcDC7WITVc07C2zxPJ0yefCbekKwERlFdSwXFc+k5TgRB+oSxZC0PoDGo9DiRVsveP1H4BttjKznE2VCEQ3tFsyweCw+ZlOdhf2/b56RFUAu6R3zpGhtFvQGEiWOG0raRkCWU1YFr29Y0AZBy9wm3xJ9hzkCk7gdYqlEp1Blfb4hiW4zhDlXRKDtpUXKVgcROf9OmBjerIwWNb10pgMALS05WHUtxLYvAX4Qjno+vPgbZXmEdkQGodWkkhDx6D0O/iGW09tmHZj9Agl8b0tm5gsYAZL4JRl/lOCa65vsAzxTwH5mdVUNLWnXsBkYbMcjsS66kXgTAr7i0wQbNnU7Py09TxtyGoIrZaBc5Qif7S6Fu5j5gBee0Nwy8gdtM3xJL5OLg8CI6JLfOy+cYm+C2Lcdg+8RpUdoSgZis+baIN9mJrBwQmEQeFreNSU9c2igtlQOwvOHDvASz7dEc8yXmBwOs7nFHZjiEv0bKquztD01RB3lfzaC+04XvmxfM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(396003)(346002)(39860400002)(2906002)(86362001)(316002)(83380400001)(36756003)(54906003)(5660300002)(38100700002)(478600001)(8676002)(26005)(426003)(8936002)(66946007)(4326008)(7416002)(1076003)(186003)(9746002)(9786002)(2616005)(66476007)(6916009)(66556008)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J+7JzeCRn0ZHz1i4NiQOrL5uPa06sG9MY0BZz3o/zziXJxxa5W04xx8ReJY7?=
 =?us-ascii?Q?KzIE2dP9fm07K6i1udWY77ew+V8o7/7kMTuWg6pK9n6/aZIo80Z491y68g9r?=
 =?us-ascii?Q?qqHfdSH3DGES7Pp3k2cQLujpxjng38+O8x6AGXICCb1jC//tgIBI8/cvkTne?=
 =?us-ascii?Q?8Mqqza5sCvSlNvlFfbAnZeEh0EE+toxa6B14aAlN5AtLDqZOBLmnJlw/MpKu?=
 =?us-ascii?Q?mP2HAUebLmczVUfHLsTWKHz2GtQCMg5+XS079nokyPQMpOo/tcplRQoiSeyK?=
 =?us-ascii?Q?WtJhYdtA0PUjF5q6vM0r6ECy49Bka+/eO5ufCEmsBq6xkEX+mL01m4R7QoUt?=
 =?us-ascii?Q?NWlTdFEtXUVNpVH7mA/VVjBGRRnqFMRd64bLSwn+kunkRUcFMQfR5k6Zu7zf?=
 =?us-ascii?Q?2TYxQTf1/syvw9ngODzmqJhsbvrm56LGnM+eVmIOVo8BsCMAQVqOIE41cOXN?=
 =?us-ascii?Q?VCguRjkjwUZzsmyhPoYYItTCjytlFwIg/nHJFR2eeY2mfvWns1kM528VWvwp?=
 =?us-ascii?Q?hxXZ1qFeRSU/fesnzoSl/z5R5dI6rn2NBcKM7g+5+Q7m6MqnXNXYRSAnplYm?=
 =?us-ascii?Q?Vv6ZkKbqb69z95V3lUz3LnwEsG7nUEZiO2RybkaUdUAVO3NOq/XHVmAzjtf1?=
 =?us-ascii?Q?RdQ7p0jE5DXfh2xO6SY4iEVEGvDp4wm4GGG6Qhp3Uh7PGH+pGOAncI6Q+tQK?=
 =?us-ascii?Q?sOQCCqseunj4J+TS+rRBMaT2Rv2arwKm49h0CbgIpTuWvNwSwCEDlNjC1u1t?=
 =?us-ascii?Q?MMtmldGJQsB2t/R23wofhQ3N+cH7p19ngTt1u6FqmQ55B6bsW8ycHi9AOauI?=
 =?us-ascii?Q?6BOTj5rujcrEyDgyW1FuboDQm3BpbmcvOaBSF2GiSnirjFPWckFnDX2qtSRF?=
 =?us-ascii?Q?8YjHv/gSCiB8b55lRuN7BiqqGeUbgBeAF6wGB+SpqQ09YJI4AYJH5Ah98DMf?=
 =?us-ascii?Q?VGR4Kpr+op9k0vIq+Xp+6KLT+fdWxagM4XwiIHIo8Oghafqtrnw9uORKbwLY?=
 =?us-ascii?Q?G5qLxSqGOaa8UF/yAL8353CSS6voBFt0AgIqcPnZwSRJBg6cFr8Jo8YTGvcB?=
 =?us-ascii?Q?j2/89Lngu/3Wtu8DNKt+yByzBekikCfj0k0Ws8qDMoeP61g0o4mGdZ7kCwO1?=
 =?us-ascii?Q?ihmiDC1n+bZvn5s79pIQDfPksN01QEd6ge0Ix6ZunEdxWqSNlDZ4RLaeJXLJ?=
 =?us-ascii?Q?k7Ez4q66JH6H+l/1sDellyquiAMkyS2NX9yAD1kSAGsbMYzFijxfyvNK73Um?=
 =?us-ascii?Q?4RxfwYrBBdMaht20x5dCqm7miIr3md27zLRS6CzJ5mJNpFNFL0Pl/qQ/IPZ8?=
 =?us-ascii?Q?2SIwcAzZ13L+qEgPMeRs28n/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6f962e-3ea8-4c90-3b40-08d92f6c511b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 19:40:51.8077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTeiKrZbtU26WGsPPa9NxhjfriL5NCUbEQtD7G0XgWj7cRTP6HlvyQdRkB3jbCmc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5508
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 10:28:14AM -0600, Alex Williamson wrote:
> > To my mind it is these three things:
> > 
> >  1. The device can only do DMA to memory put into its security context
> 
> System memory or device memory, yes.
> 
> Corollary: The IOMMU group defines the minimum set of devices where the
> IOMMU can control inter-device DMA.

Inter-device DMA is #2:

> >  2. No other security context can control this device
> >  3. No other security context can do DMA to my userspace memory
> 
> Rule #1 is essentially the golden rule, the rest falls out from it.

But we can agree we can use these three principals to evaluate
any design? It is useful to split up the 'derived' ideas to make it
easier to understand.

> > Today in VFIO the security context is the group fd. I would like the
> > security context to be the iommu fd.
> 
> The vfio group is simply a representation of the IOMMU group, which is
> the minimum isolation granularity.  The group is therefore the minimum
> security context, but itself is not a security context.  The overall
> security context for vfio is the set of containers (IOMMU contexts)
> owned by a user, where each container defines the IOMMU context for a
> set of groups.  The user can map process and device memory between
> containers within the same security context.

A "security context" needs to be a concrete thing. It should be
something a process has some control over, in these models here all
security contexts are FDs.

If it isn't the group FD then all that is left is the container FD?

> As you know, we have various issues with invalidation of device
> mappings between containers, so simplifying the security context to the
> ioasidfd seems like a good plan.  The vfio notion of a container is
> already encompassed in the IOASID of the ioasidfd.

Yes
 
> The significant difference is therefore the device level IOASID versus
> vfio's group level container granularity.  This means the IOASID model
> needs to incorporate the group model not only in terms of isolation,
> but also address-ability. 

Yes, we need a definition for what groups mean in this world. Groups
no longer mean a single IOASID for every device in the group.
 
> > 1 is achieved by ensuring the device is always connected to an
> 
> s/device/group/

We have been talking about an iommu world where each device in a group
can have its own IOASIDs, so it no longer makes sense to talk about
groups as an assignable unit. Yes there is that degenerate case where
all devices in a group must have the same IOASID, but in general we
should be talkin about devices, not groups, being assigned IOASIDs.

> As you note in reply to Kevin, in a multi-device group rule #1 can be
> violated if only one device is connected to an IOASID.

I assume that all devices under VFIO control are connected to safe
IOASIDs. A safe IOASID is one that blocks all DMA, or one that is
from the same iommu_fd. A device under VFIO control should not be
pointed at some kernel-owned IOASID that is DMA capable. It is a
change from today.

Connecting two devices in the same group to IOASIDs in different
iommu_fd's would be blocked by the kernel, preventing #1.

> > IOASID. Today the group fd requires an IOASID before it hands out a
> > device_fd. With iommu_fd the device_fd will not allow IOCTLs until it
> > has a blocked DMA IOASID and is successefully joined to an iommu_fd.
> 
> Which is the root of my concern.  Who owns ioctls to the device fd?
> It's my understanding this is a vfio provided file descriptor and it's
> therefore vfio's responsibility.  

Yes, VFIO

> A device-level IOASID interface therefore requires that vfio manage
> the group aspect of device access.  

I envision it as some kernel call that vfio will do as part of the
bind ioctl:

  iommu_fd_bind_device(vfio_dev->dev, iommu_fd, ...);

If everything is secure it succeeds and VFIO can allow this FD to
operate and process the rest of the ioctls. The new iommu_fd would
make the security decision. The security decision would look at groups
internally.

Three emails ago I outlined what I thought the logic of this function
should look like

> AFAICT, that means that device access can therefore only begin when
> all devices for a given group are attached to the IOASID and must
> halt for all devices in the group if any device is ever detached
> from an IOASID, even temporarily.  

Which rule is broken if one device is attached and the other device is
left with no working device_fd?

No working device_fd means no mmap, no MMIO access, no DMA control of
the device. It is very similar to not doing the group_fd IOCTL to get
a device_fd in the first place.

Remember the IOASID for the unused devices will be pointing at
something safe.

> > 2 is achieved by ensuring that two security contexts can't open
> > devices in the same group. Today the group fd deals with this by being
> > single open. With iommu_fd the kenerl would not permit splitting
> > groups between iommu_fds.
> 
> "Who" within the kernel?  Is it the IOASID code itself or is this
> another responsibility of vfio?  

ioasid code. The iommu_fd_bind_device() would keep track of the single
iommu_fd that is allowed to use devices in this group.

> If IOASID knows about groups for this, it's not clear to me why we
> have a device-level bind interface.  A group-level bind interface
> clearly makes this more explicit.

It does make it more explicit, but at the cost of introducing another
additional userspace object to manage - we still have to make the
whole API work on a per-device basis. Basically, adding the group
introduces a complexity, I would like us to all agree we need the
group and what exactly it is doing before we do that.

> > 3 is achieved today by the group_fd enforcing a single IOASID on all
> > devices. Under iommu_fd all devices in the group can use any IOASID in
> > their iommu_fd security domain.
> 
> As above, while the group is the minimum "security context" for vfio,
> the overall security context is much more broad.  

I don't understand this comment, can you describe what scenario would
be causing a problem?

> > It is a slightly different model than VFIO uses, but I don't think it
> > provides less isolation.
> 
> I can be done correctly, but if IOASID isn't willing to take on
> responsibility of managing isolation of the group, then it implies a
> non-trivial degree of management by users like vfio to make sure
> userspace access is and remains secure.

I think it is important that the ioasid side do this - otherwise it
feels incomplete to me. VFIO handling it means that logic won't work
for other non-VFIO users, which feels wrong - even if those cases
probably have 1:1 device/group ratio.

> > > For example, is it VFIO's job to BIND every device in the group?    
> > 
> > I'm thinking no
> 
> Then who?  Userspace?  IOASID?

Userspace would bind the device it wants
  
> > > Does binding the device represent the point at which the IOASID
> > > takes responsibility for the isolation of the device?  
> > 
> > Following Kevin's language BIND is when the device_fd and iommu_fd are
> > connected. That is when I see the device as becoming usable. Whatever
> > security/isolation requirements we decide should be met here
> 
> If device access is usable after a BIND, then that suggests the IOASID
> must be managing the group.  So why then do we have a device interface
> for BIND rather than a group interface?

This would be the only place the group would be used in the iommu_fd
API - and it is conveying redundant information - so do we need it?

> For example, given a group with devices A and B, the user performs a
> BIND of deviceA_fd through vfio and now has access to device A.  The
> user then performs BIND of deviceB_fd through vfio and has access to
> device B.

Bind B would fail, iommu_fd_bind_device() will fail because a group
can only have devices in a single iommu_fd.

> So continuing the above example, releasing deviceA_fd does what at the
> group level?  What if device A and B are DMA aliases of each other?
> How does the group remain secure relative to userspace access via
> device B?

It is very similar to today, if you close deviceA_fd the only way to
re-open it is is via the existing group_fd. It remains parked while
closed.

With iommufd If you close a deviceA_fd then it cannot be operated
until it is re-bound to the same iommu_fd that the other group members
are in. It remains parked, including with an IOASID that is either
block DMA, or an IOASID from the iommu_fd that is operating the other
devices - same as today.

> > Once the device is back to blocked DMA there is no further need for
> > the iommu_fd to touch it.
> 
> Blocked by whom?  An IOMMU group assumes we cannot block DMA between
> devices within the same group.  

You asked if the iommu_fd needs to change things about the device -
the answer is no. Once the device's IOASID is set to 'block dma' there
is no further actions that can be done to it.

I'm still not seeing your objection concretely, sorry

Jason
