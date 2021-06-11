Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21C83A46EB
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 18:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhFKQse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 12:48:34 -0400
Received: from mail-dm6nam12on2055.outbound.protection.outlook.com ([40.107.243.55]:53633
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231860AbhFKQrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 12:47:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvqJ+PlrI7xQwoE5qDqazK1bD6IrUM13PvOgPXIDlaIxt87lrvsK22+8gIrJQf0FMhAsmzhd0ePuVZqKoZSBJ/UVBO/lfnKNyKAsW3p7zo5M+2yJ566lgr52THolJV0xpVRJg25P5rYo7gQ7EYIv/dFWwqLCS01MFJIy7rf8eX8ktHfD7nBnFIAUFaGYm6HOVnAYr+1A4x+SMUaW83jvWy374ZpH+l05c9cd2QZ3WDI71S9WpnrsuexVz2xyl0Lf5vK7nlRscjic++CbzbFLpmO9E+6r46jQVBc1MSMa3cMiW4X5LdEGozN7+Hni9jAwY4ZB8G37VdOFnkQjOnY7ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9B53J/hvrrshyeIyGq53SElfGuNmstjH0Ya/Tac7r0=;
 b=GRWO8L4cbJ+MWcLywWe2mCyRJXcwfQ6saGrUutsWNsz7b+KxrUO450jybBayh8+/2q79yy40QsB+iriUJuwFS9ndIfMVTzBP7T0jCmDbh2dmLOrjb8Kzjr7WxnvoV1SVEBBvG5D+kNpwye94zQrPHBR1FWyku9E6GskX300A65FLmA1ZOWxHWBi1uZJEQRnf6MCVRxz5+JD40KktrpUsUA9YxP8/zYfW7IvTqNXrdGlsRtHU9YhSVhWFMdaIsXDtyJjt1bDqS+wDWnZclRWv94DibZZiLVerzN09QokjSzzr+lDdFexDdn63R4b3NM/j/sh9Fz85bqQdpZ8eR2h0IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9B53J/hvrrshyeIyGq53SElfGuNmstjH0Ya/Tac7r0=;
 b=atlfpZCGGYodfXrgn0UlH7heja8r7DjSUZX0eZrtrPfGUqjwrHGWBu4MSbHkzDgWvv3cKnemwmdU5PW+SK/NH9oAkIeygz56qXAkiT4tSYaqG+qQzjtyAsgAyQ0zhI7JkU4UERwm0OL3PPngiRg31oEyC6SdEZX6XSPyIXAZIxZBoSX/w4pkEfrDNgXECSvFXu2KBqw7/RZc8M4AxCRu/ecFRe7/HL63/axgNn7xBkrKvdi6Q95qqP3DlHLo9NJRtvW6v2H/3U1n5J2Uvh5Qq52L7/W4vXcs+5jQ29jtA51tEvgD7u7xwb751Ng/8ZMiiMCF6TakR4GfFyRbTc8N1Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5189.namprd12.prod.outlook.com (2603:10b6:208:308::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Fri, 11 Jun
 2021 16:45:31 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Fri, 11 Jun 2021
 16:45:31 +0000
Date:   Fri, 11 Jun 2021 13:45:29 -0300
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
Message-ID: <20210611164529.GR1002214@nvidia.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
 <YMDC8tOMvw4FtSek@8bytes.org>
 <20210609150009.GE1002214@nvidia.com>
 <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
 <20210609102722.5abf62e1.alex.williamson@redhat.com>
 <20210609184940.GH1002214@nvidia.com>
 <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:208:120::37) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR10CA0024.namprd10.prod.outlook.com (2603:10b6:208:120::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 16:45:30 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lrkHh-005geW-Gw; Fri, 11 Jun 2021 13:45:29 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2430d3b0-f480-448e-1d1a-08d92cf85323
X-MS-TrafficTypeDiagnostic: BL1PR12MB5189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB518972BF6CD1BA08609F019BC2349@BL1PR12MB5189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWBOsGxa73UD6Eo8Uh9QBVI3x2SPnP+/TS/1Hj0V23Iz3w3IXrfENZnmQRmBzq7iLzlienK0+GLr9/JSMJJ191FxgMBvMp0fEAm/FiyQ+xqIes1crqB1+zXmdpLKICzGxjGewHJAJu7PoinAXeLa+QyMiX4NpC9vOqMh/RA8oGW6l6QtjZZIAT2XLKu8kst8+M831FPaEF4Ja3Hf1iyZTIVh0pxMPuX7KlIJY49Ez3IoaSClBV++3wWSC6OWxVeD5Glxfo9Y7cx4aYT4Jlybu8tfjfbaXKW+HcohUe/V/2ZQJwaNhHqRxMvrT4btrt6uAZY6gsWVsi+YYDKBchB2KxRcrPZBOY2fWWCeGg/NoIjDAxEwZAgG44WwrQZEWeWT47xVVtW1M2x/xHSnW65lE5QP3RuaynU+so6ka8ZmzqW1wxbEZ5zqfN5Ua4lI0yLOeTMECPDh0O9My3bQL+IXlISJUrbLwqF/LDEW2IJmujcQWsgpyrfvTRn3NKqtovvQDfA8idO7zVHiN3bbwMZOc4tQwRTQ7fQ4ZeFd7zUwUuuwNBG9ewPaS8qwxueyvWd64qFyw6wg48ezrzLXak+5ae3O4CUpHKtuDw2Mfo5ysuo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(83380400001)(8936002)(7416002)(1076003)(6916009)(8676002)(5660300002)(26005)(4326008)(36756003)(478600001)(38100700002)(86362001)(316002)(426003)(9746002)(9786002)(2616005)(66556008)(66946007)(2906002)(54906003)(186003)(33656002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n/5xLWjPmx0tmi+MUV4SpCetkyPOozTdNZzqCsA2zRvFTEyFiTTj8OnxWDgV?=
 =?us-ascii?Q?fpEyQiP9iOiN/4YeoblnG2nOeNXVhl1VY3Bcx0HVC5HxKtM/ETXYq3yWocDh?=
 =?us-ascii?Q?bk0W647JhiyBksCgaTVkUzceDqHxlV92lk5AryltH9gwQ+27EFODC02enWAD?=
 =?us-ascii?Q?18X1laVum9dbLD2rn2koUMHgdoKQBzFSboJt2/kkhfWaYwJIs8z3nBneCC2h?=
 =?us-ascii?Q?49Na9wiQq/h+HifZ1fr1y/BKU/Ff70pCTHE68Ypkiz2r7FgMCKi+TXv8aeh9?=
 =?us-ascii?Q?1hMtdE7YMOnwXqGdUsHvH2Bfm1panQ8EyvZLidl6PFmgJVLW2yDaYm0qCzb8?=
 =?us-ascii?Q?78AKyw2uIuJXpWFqjUE5z/70CrRMNADmvPSiOD3fNkE8NmW8YEU6wZpkAFlH?=
 =?us-ascii?Q?LsiXc+/Zc8/edd/pZBzyL4mXsXgBziWbzJ01mbpdHpYmavN2P0/5wdBkkcG+?=
 =?us-ascii?Q?8g4/u61snkZa4ZTw9+tToZ7DCICsNZzxJfTHwR3MMGsGdqzV+mYruMbK3VGT?=
 =?us-ascii?Q?3QEmd0Fn+9X0s43lx6x2PRNyHZjvJzSYLKInvAYOLLpHN2FD7p+aF0hWTlMb?=
 =?us-ascii?Q?NIymqbb465vXLYdQDt1dNqfosIKKyvFkJ1fuHuxAen93GXUpF6q4eCMIB2Xr?=
 =?us-ascii?Q?xVkenrYPsppQTpdd1BwtnMbGlMozoX0qoLxMmNkjlzpd7osp5aYXKrYooF63?=
 =?us-ascii?Q?dyKW8pTLX+fYgkYEP0Rse83ZZDVt/MF3jkJdavWff706c2Brt5k+tzSTRuDb?=
 =?us-ascii?Q?Fhd1lTN3qmqWx/Bk/AbnHzfUlNRdhJmx4tm4lEdv9mXtWbjARzVQkI1737Tf?=
 =?us-ascii?Q?1EhKZ5YG8F2zZ0svSBsDOsjmFNbQ6EQ0Cj2MSspTIXvUb67jvSbLzpuvCRia?=
 =?us-ascii?Q?figWi9E1iFEpN4pWNEA80lN05WpxthLmjl5bO502AZRZURxffjv93R8zn5wb?=
 =?us-ascii?Q?nrqgFmfoz5LKQg9Hzsf0/o8qNKpehIjs3KAEBxe4LOqZvc2wYvydghwfqBnA?=
 =?us-ascii?Q?XxyqBMP0BXT7rlsCeWo8Nvw1VjLgfLsq6A+sUMvgiqjb4KOYtUAJ6/ZDubrN?=
 =?us-ascii?Q?PwPmJoyi7Qsk8piZj7bkfNq5vcU8WyJcaYNzgJVBHU2nTwX1CDmCvVnjqmtK?=
 =?us-ascii?Q?30YMG2J8QetX4Nn4LS2dK1jNoMRZ//bWWp8rZoIgMeq9EKDWsBm5ILoWsRdh?=
 =?us-ascii?Q?yUxwoO3q1v0n9L2yb6iOQQqOPoxIpot7DlSvwl9C4jO2xl3aGrBk+YP574vK?=
 =?us-ascii?Q?CMpCeEIgXBQ9XTVot49fHNYniTPwmkhN06onmX1pG8uftiST3mCYKsGfH/zT?=
 =?us-ascii?Q?H2nfZbfOhjL5IbX1QldsiGqP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2430d3b0-f480-448e-1d1a-08d92cf85323
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 16:45:31.1472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0zuAQqqFJEVYtrovxh5EBzvoC7FiUuv+EIvGitHjCBS6w4cyGoxNoVn7jLDZr+I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5189
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021 at 09:38:42AM -0600, Alex Williamson wrote:

> Opening the group is not the extent of the security check currently
> required, the group must be added to a container and an IOMMU model
> configured for the container *before* the user can get a devicefd.
> Each devicefd creates a reference to this security context, therefore
> access to a device does not exist without such a context.

Okay, I missed that detail in the organization..

So, if we have an independent vfio device fd then it needs to be
kept disable until the user joins it to an ioasid that provides the
security proof to allow it to work?

> What happens on detach?  As we've discussed elsewhere in this thread,
> revoking access is more difficult than holding a reference to the
> secure context, but I'm under the impression that moving a device
> between IOASIDs could be standard practice in this new model.  A device
> that's detached from a secure context, even temporarily, is a
> problem.

This is why I think the single iommu FD is critical, it is the FD, not
the IOASID that has to authorize the security. You shouldn't move
devices between FDs, but you can move them between IOASIDs inside the
same FD.

> How to label a device seems like a relatively mundane issue relative to
> ownership and isolated contexts of groups and devices.  The label is
> essentially just creating an identifier to device mapping, where the
> identifier (label) will be used in the IOASID interface, right? 

It looks that way

> As I note above, that makes it difficult for vfio to maintain that a
> user only accesses a device in a secure context.  This is exactly
> why vfio has the model of getting a devicefd from a groupfd only
> when that group is in a secure context and maintaining references to
> that secure context for each device.  Split ownership of the secure
> context in IOASID vs device access in vfio and exposing devicefds
> outside the group is still a big question mark for me.  Thanks,

I think the protection model becomes different once we allow
individual devices inside a group to be attached to different
IOASID's.

Now we just want some general authorization that the user is allowed
to operate the device_fd.

To keep a fairly similar model to the way vfio does things today..

 - The device_fd is single open, so only one fd exists globally

 - Upon first joining the iommu_fd the group is obtained inside
   the iommu_fd. This is only possible if no other iommu_fd has
   obtained the group

 - If the group can not be obtained then the device_fd is left
   inoperable and cannot control the device

 - If multiple devices in the same group are joined then they all
   refcount the group

It is simple, and gives semantics similar to VFIO with the notable
difference that process can obtain a device FD, it is just inoperable
until the iommu_fd is attached.

Removal is OK as if you remove the device_fd from the iommu_fd (only
allowed by closing it) then a newly opened FD is inoperable.

Jason
