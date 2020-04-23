Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFFF1B6465
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgDWTS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:18:56 -0400
Received: from mail-am6eur05on2070.outbound.protection.outlook.com ([40.107.22.70]:17286
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728283AbgDWTS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:18:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnjzxrsH0eTkSQf53TXhZj0NLAlDR1o9/m9i7RYuVaqDWpgphx/okiZGHYdCRTEAz8ztRO1pR4MuMNapFUcywW4WqEd1clr3940o1EtDieSWZt08ZsgARMwLiUr4C3uCy1MZZpNlTycBHVEjtwWOaDydHtkyVxM5gB1cSlFnGaOXQJ4eac5dSWaEQ4XSfOA6to7y8kD7XMHLKt5A+ybHzaAf6kg1ixfBzM9rCC95m7lYRcJWwJV/wWzx4R+AQ1SY6eGKfLbi5SeluiD4LOBoGn3j5mJGalYhCzgZQTYUUFIB8fnDa9ibIgAm7HApw0IkbEouhlIp2qwPaTJR45qx2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaBKJHoHBMehdMyQkscBsvT0z6PpnqLQ8mp8jMTRnQo=;
 b=NLhpetxYjSsVhUT3SsD1033JRaEB6ZCnoHaEnXv1yBgzmrhCOCc6Sk1746CnFQW7+WEBBss0D7rw96zyju7CMrffmm/G2D94sWzlf4Sxu+xnnmMKbtycNHZ3+vfWCyMvyUT/wBTRoLzxBIYIrZB88T3PFpL0WquThLMAW8MvafTLSZ253wajjJktWQFct/S2eli53HUEVTI7WD9T6YEDfrSZbJuJL2AkV3Ja6/361x/tEro7K938XB4AMCeSlEV6XiiVIWNSyk+XFBgTi+WHSFBVkS9NcbnohmFY/MIO9OteuHg9pSsnnMsRcwOM5YOKVwjdgms+svtcSkhOotuUbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaBKJHoHBMehdMyQkscBsvT0z6PpnqLQ8mp8jMTRnQo=;
 b=mIsO+EWbhOs1G9JMNbafBvTcKVh4TW+PMNYJZif1STmxWCUN5EbTXMfJhZRIZi7/oqXAnIi41m0c3Ngl/bTEjbavLiK0bDqhX/iwUwfSZIXFy75LZqB3Mj04l6uyUHPc2vvpYX8U6rzziTFWhEcrMx7d+r9v3JPpkPLEK/m8SWE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB3309.eurprd05.prod.outlook.com (2603:10a6:802:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Thu, 23 Apr
 2020 19:18:50 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2921.030; Thu, 23 Apr 2020
 19:18:50 +0000
Date:   Thu, 23 Apr 2020 16:18:46 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>,
        Megha Dey <megha.dey@linux.intel.com>, maz@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Yi L Liu <yi.l.liu@intel.com>,
        baolu.lu@intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jing Lin <jing.lin@intel.com>,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, linux-pci@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200423191846.GE13640@mellanox.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <CAPcyv4gMYz1wCYjfnujyGXP0jGehpb+dEYV7hJoAAsDsj9+afQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gMYz1wCYjfnujyGXP0jGehpb+dEYV7hJoAAsDsj9+afQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR15CA0055.namprd15.prod.outlook.com
 (2603:10b6:208:237::24) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR15CA0055.namprd15.prod.outlook.com (2603:10b6:208:237::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Thu, 23 Apr 2020 19:18:50 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jRhN0-00071R-DZ; Thu, 23 Apr 2020 16:18:46 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eee5c3b7-e83a-46fd-be2c-08d7e7bb277b
X-MS-TrafficTypeDiagnostic: VI1PR05MB3309:|VI1PR05MB3309:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB330934170AEF3540CEE1168BCFD30@VI1PR05MB3309.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03827AF76E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(86362001)(8676002)(6916009)(7416002)(33656002)(26005)(66476007)(66556008)(66946007)(4326008)(52116002)(2616005)(53546011)(8936002)(2906002)(36756003)(9786002)(186003)(9746002)(1076003)(5660300002)(54906003)(498600001)(81156014)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DRJUcoFuCBFgCfrCO5q2Ki2ZTUxMPISz74taY4W741o8ROnEK0pvP03W/TnU/zh+s4AIjcobz6VakrGvjFiyCmguXrRHUzjIwOaAyW8zMXHe6nKywQX1uZQRdZq6XOVhwMJWF4SpIqaM/7i5A4jbQgCeRUZ3TVny9wAK4yepaWUOJkhVTzUU8pQI4keBPNAxWD2AMrEa8t/BsmGxDHp9/lzNTW9FdDHFM9UH79BAAuU8Rg7qqg47K3gH9W1x3GOLdMYEaCgcGC9CD2YeEqiDdWo4ZH72bFQfqmScFxSdl2QUsCjQWDNeEAvEGLiHxqldtqewaELozyci/TmTFJcfi05ASjZQFnX4fOevRHxYiRJLErFT3RoGGcvwzb7BWOnJrpobDOJgOqcdv7comHd1+y+kXLocVO/cPa1Z8SJjfAD1C8KJ15nZpUtoddIwwaNhlqK7ychNwHzE9XYr1kqtQ2LULoOvyDOb7+kJHxJkD22DVZMKRioFqRnLdVPsOk+N
X-MS-Exchange-AntiSpam-MessageData: H8CyWhVAln0AcS9SXPO9hLTRQf1w0CjBJAOcHz2bXaCR7bBEpmox+q14Xu/FsZkycZg0Zc8WzqbFrmSpdGeiDa3hm318fW/iABjzXWa388kEoGCqRjc6hHwMifmlnXaXc9iOP85Qb1Kuovc7lRgPXQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eee5c3b7-e83a-46fd-be2c-08d7e7bb277b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2020 19:18:50.4605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0joJvFidrLPR0qraskthoRviuoFQt5NJreUlHFvlzGUfv5SJX0+kwg7k7JW0xKlJdgPmvQ2muhT5eIaDnGPeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3309
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 02:24:11PM -0700, Dan Williams wrote:
> On Tue, Apr 21, 2020 at 4:55 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
> >
> > On Tue, Apr 21, 2020 at 04:33:46PM -0700, Dave Jiang wrote:
> > > The actual code is independent of the stage 2 driver code submission that adds
> > > support for SVM, ENQCMD(S), PASID, and shared workqueues. This code series will
> > > support dedicated workqueue on a guest with no vIOMMU.
> > >
> > > A new device type "mdev" is introduced for the idxd driver. This allows the wq
> > > to be dedicated to the usage of a VFIO mediated device (mdev). Once the work
> > > queue (wq) is enabled, an uuid generated by the user can be added to the wq
> > > through the uuid sysfs attribute for the wq.  After the association, a mdev can
> > > be created using this UUID. The mdev driver code will associate the uuid and
> > > setup the mdev on the driver side. When the create operation is successful, the
> > > uuid can be passed to qemu. When the guest boots up, it should discover a DSA
> > > device when doing PCI discovery.
> >
> > I'm feeling really skeptical that adding all this PCI config space and
> > MMIO BAR emulation to the kernel just to cram this into a VFIO
> > interface is a good idea, that kind of stuff is much safer in
> > userspace.
> >
> > Particularly since vfio is not really needed once a driver is using
> > the PASID stuff. We already have general code for drivers to use to
> > attach a PASID to a mm_struct - and using vfio while disabling all the
> > DMA/iommu config really seems like an abuse.
> >
> > A /dev/idxd char dev that mmaps a bar page and links it to a PASID
> > seems a lot simpler and saner kernel wise.
> >
> > > The mdev utilizes Interrupt Message Store or IMS[3] instead of MSIX for
> > > interrupts for the guest. This preserves MSIX for host usages and also allows a
> > > significantly larger number of interrupt vectors for guest usage.
> >
> > I never did get a reply to my earlier remarks on the IMS patches.
> >
> > The concept of a device specific addr/data table format for MSI is not
> > Intel specific. This should be general code. We have a device that can
> > use this kind of kernel capability today.
> 
> This has been my concern reviewing the implementation. IMS needs more
> than one in-tree user to validate degrees of freedom in the api. I had
> been missing a second "in-tree user" to validate the scope of the
> flexibility that was needed.

IMS is too narrowly specified.

All platforms that support MSI today can support IMS. It is simply a
way for the platform to give the driver an addr/data pair that triggers
an interrupt when a posted write is performed to that pair.

This is different from the other interrupt setup flows which are
tightly tied to the PCI layer. Here the driver should simply ask for
interrupts.

Ie the entire IMS API to the driver should be something very simple
like:

 struct message_irq
 {
   uint64_t addr;
   uint32_t data;
 };

 struct message_irq *request_message_irq(
    struct device *, irq_handler_t handler, unsigned long flags,
    const char *name, void *dev);

And the plumbing underneath should setup the irq chips and so forth as
required.

Jason
