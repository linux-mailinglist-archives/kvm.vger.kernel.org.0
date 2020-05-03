Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892CE1C301C
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 00:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgECWg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 18:36:29 -0400
Received: from mail-eopbgr10053.outbound.protection.outlook.com ([40.107.1.53]:64498
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729171AbgECWg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 18:36:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b96ZEJMXd3hNI5K44ba7FhFBanznt9kNjika8zETC9Q2XO2AqlFypOLauCYFj4GlVHqOFV0Xc377jaywSnMLHodQcrYBH+5ziqFT2mfM+Jd/uBqF5+nPIaSyRP8iwy6Oa4dtj+QgLE5iLULvOYvu7WWbFNMKWaSyTGPb2dh2cZ5HpDS9R+hfe+PQk8lJiKCD14OGLxnaUBLJBNGFa/ATh/5+O+CeXGCZwVejeojYyNzUleRkGEx8N05NIEoCTz1rVqXRoadZzOaqKh9ruXoINTrvpkw6Co5sU596YiYIcU6A7Q4oenLbdNOTtziV4+bU0fRhE3+SacO4Xz0Sir3aLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6L6Hf1yboZtWuiqOkeyPlW02QvNNsIyPt6zzTucWyk=;
 b=nJe6DywCO9z1HPxEURH50qWomoteKIBItMuH4S6d4j49g4ZJjdrWRuhbMgJ+pjZbWMMN+ajliUJdMBbm3zvUTn2ep9nHFPBAR4LrcnZjdLyNUtj4r/7DuU9sJVSPFobwPw0wZ7I7Fwwfr3MF2wm/7QP4NbDnarR1xCxdabJfRSL3KRNKOpNiO+tNxJMqpVjMG8gK2Y86aetWXRQjqmSkOVfeA6Z/xHrEPJ79HeI/k/mhx3BDG+qCJiUxqcxd1gM6NsSQ/oPGk2Fl2Y5bgyMBKTI9gJeUFrSpCE53VG3XmvAwkdpMWjLavIdUDwhSVuZd6GssXR8okZYHFItkEsPkIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6L6Hf1yboZtWuiqOkeyPlW02QvNNsIyPt6zzTucWyk=;
 b=bCC5f1egEHzr2e9cS1XXeK2yRz8JCONQFA7ux0B2qeiE6/Ere/oi1ELH3IzBTlPxdbsoYKAgkR6vFvY7MHNfhdBl40NJA3H2+Z5jgNyE9IT1PvVDOxt60Lhs0GraPx5WpFpmXhSWYLsJ5e6/rv+fYcoba/w/MXDcmwf8D3tXVVY=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none
 header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6030.eurprd05.prod.outlook.com (2603:10a6:803:dd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.21; Sun, 3 May
 2020 22:36:22 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2958.029; Sun, 3 May 2020
 22:36:22 +0000
Date:   Sun, 3 May 2020 19:36:18 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Dey, Megha" <megha.dey@linux.intel.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, maz@kernel.org,
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
Message-ID: <20200503223618.GG19158@mellanox.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <CAPcyv4gMYz1wCYjfnujyGXP0jGehpb+dEYV7hJoAAsDsj9+afQ@mail.gmail.com>
 <20200423191846.GE13640@mellanox.com>
 <098aef60-35a4-dc44-be07-ea43c1a726c7@linux.intel.com>
 <20200503222229.GE19158@mellanox.com>
 <5bc05b74-536f-f72d-c406-18644436f11b@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bc05b74-536f-f72d-c406-18644436f11b@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:208:239::14) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR08CA0009.namprd08.prod.outlook.com (2603:10b6:208:239::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Sun, 3 May 2020 22:36:22 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jVNDe-0002jt-QX; Sun, 03 May 2020 19:36:18 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fe5d6c5b-0f9c-472a-b7d2-08d7efb267ce
X-MS-TrafficTypeDiagnostic: VI1PR05MB6030:|VI1PR05MB6030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB60300933BC294EF16A5DB1FBCFA90@VI1PR05MB6030.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0392679D18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8INfRzErSvGnbXG2iGhHRKYG6BYHHRCP5E7okkUiQptJgUhd9agAbKLqhvjLQEa1R3hwdHM04PFBG6hjDLjXzjIIyilno+yZU4PdEDbWSCN6qOloJyupcom89iYaAc1x/LGhyhLcuBF5OoL8onXU4gaNa8oE7QUoGG3GnM/aHmiXHYVkZlDuARiR3kvcGEpC8gQMJEGD+/y03Z2a1mvdvewIYdW6w4y4T4Q52zeJ6sU1kIyuxf5XPue1xnTI0gMskAOMAfEzaTlZDuLoYrpke4HMEzx95tzZv8DcunXUmW/Qi+bta6YOmPKsoXogp98LIQyq6cFKaDqitHjHsPsGQiq4WfvurcKEfSC66+mP/AboKNlhJTsiygI4W+j2fvviLbjxkQ53lXhXt0IDxdTj7BeIiQqMeylJM9vW7Me4hb0sV3agtj+AbTUMKhionUtnRJfdARTFnAn7wZ28AZ52DAsuVGUWUJeLOJsC1j0RyGx5O3Afu32aLMKrszj3wEB5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(52116002)(53546011)(1076003)(5660300002)(66476007)(66946007)(6916009)(66556008)(7416002)(186003)(26005)(2616005)(86362001)(478600001)(4326008)(9746002)(9786002)(36756003)(2906002)(8676002)(33656002)(54906003)(316002)(8936002)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6X1bkSnc9awDPcBbolnCW105Oo0ueWJqrfkFhQT7fxIgBBxs+F3y4qaOy6mNsJB2xmZu3Ss7fAskV66Ogxj8hj455JapYyRLit9gXbdDKUFqkc/AOG7QxzUlQqbn8ukQCd1ZObe0XHUmrdr+WMIuCfQOCFtPhiDpMNehqjee3bKj47PP4DsOuGOaxd9IPXMPhn3GPLYq+NPc2AgUJjBZ59URJWR//4gs95xE7G1yTNkZpXjjSZQ8ECi6PdHDYn4uPmLeso8FvV4vxI8//bA4Yaaq4l7wivVXIn0IwihhxL56poW4aeKNx1Vrow024jnGvOM+6Rs9iMyWlyyrl33slqGmWkV516NC4VpbjCVSZNpzeo/Sp7Tm7+5Dee6yJnJnaqhft1SmH7BS5Y9YUhHL830BZPdWNveJaTjlHAtYp6UXB9FX+E1Z3iquJxzRygtynRkZz+yHHue1BrpVL1u8YlkZVFnBnkteQCxMcO74ac4O802BGzXwYMGxoeyX3OrfDw3kQqqdFWdtb7MjkGGy9ODHxqq9mtzs3MXvUMOLUBGflwcXSNtIJHFFTnwpPPncCkNifivBDnjYCO/r8Pq8DpC8wpjO0iHc8kYdw5cMMmupi66Wjwpwx0GUR/Itv8i6YHa6CufMV9MIgCjtG9vg7Rge+5ivelxAbVxlSyfDGhhr++Z5aA1Rs05VDk9ZVI05WRfN09rdJU+8J2bX3h4Ac1/5QoYeUzWUK7ET0AWLbRWxdp7X94/clo6SsJoJAWouuVkbjFwUf7q3UINaH3K6tMRDn19coMrJ8Ltk/5W2DIA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5d6c5b-0f9c-472a-b7d2-08d7efb267ce
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2020 22:36:22.4250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOtuxI2JS4sOK7i0wwBDKQMly1Pl9r5ND7reEl4TX5O1acwANzdVLAvJ4s57Vu3ZwYsKG04zgY0WcShYdsdx5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6030
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 03, 2020 at 03:31:39PM -0700, Dey, Megha wrote:
> 
> Hi Jason,
> 
> On 5/3/2020 3:22 PM, Jason Gunthorpe wrote:
> > On Fri, May 01, 2020 at 03:31:51PM -0700, Dey, Megha wrote:
> > > > > This has been my concern reviewing the implementation. IMS needs more
> > > > > than one in-tree user to validate degrees of freedom in the api. I had
> > > > > been missing a second "in-tree user" to validate the scope of the
> > > > > flexibility that was needed.
> > > > 
> > > > IMS is too narrowly specified.
> > > > 
> > > > All platforms that support MSI today can support IMS. It is simply a
> > > > way for the platform to give the driver an addr/data pair that triggers
> > > > an interrupt when a posted write is performed to that pair.
> > > > 
> > > 
> > > Well, yes and no. IMS requires interrupt remapping in addition to the
> > > dynamic nature of IRQ allocation.
> > 
> > You've mentioned remapping a few times, but I really can't understand
> > why it has anything to do with platform_msi or IMS..
> 
> So after some internal discussions, we have concluded that IMS has no
> linkage with Interrupt remapping, IR is just a platform concept. IMS is just
> a name Intel came up with, all it really means is device managed addr/data
> writes to generate interrupts. Technically we can call something IMS even if
> device has its own location to store interrupts in non-pci standard
> mechanism, much like platform-msi indeed. We simply need to extend
> platform-msi to its address some of its shortcomings: increase number of
> interrupts to > 2048, enable dynamic allocation of interrupts, add
> mask/unmask callbacks in addition to write_msg etc.

Sounds right to me

Persumably you still need a way for the driver, eg vfio, to ensure a
MSI is remappable, but shouldn't that be exactly the same way as done
in normal PCI MSI today?

> FWIW, even MSI can be IMS with rules on how to manage the addr/data writes
> following pci sig .. its just that.

Yep, IMHO, our whole handling of MSI is very un-general sometimes..

I thought the msi_domain stuff that some platforms are using is a way
to improve on that? You might find that updating x86 to use msi_domain
might be helpful in this project???

Jason
