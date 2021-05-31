Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FB739663C
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 19:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbhEaRBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 13:01:42 -0400
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:1185
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234635AbhEaQ7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 12:59:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmbFciKmdrENms6rkwPQCiN2ocPfCoRDEp98PAM/NvLEerUjQh4Jhhm7NwvREkMLT03DL1QNC4XxnTALYyixTcvakRI1D5PEDOQkRbY3N6SOlA05t5dVZ+Z7RuDrJdxiivo6lBh3iYv1kQk2CmXZrImZwCmNmZqSRPHln5nPuWm55+gi6yfz5sKlqZ8WsZD5nKN4obC4hgiBdU5zUb7Y7yf86P6hiQnfvZpj/T8ERqvlD6TU2EsjRZ4O63T4YISd2qB1Qo7ST7hw9aadsVM6+iZLSfoxyzbYCb1R/aX+UX1jgm6fdckmsaJY3vGebMhiJlKNmXEBKwNlNrrNCnkefQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vdceh7UZSrS/y/TPW49NJPmZJoDUgOh+57d7lOieIs8=;
 b=kJIU6aJ69d4rMnAPNq7yDcVszVTHIADLEVDYyAYVWgPy/i2orjisYU6Mi1TzXxYAGRF9j7NBN3GVKuY2YAkh/+3glB1D3uklLl8dDLP0IXwTa6dw4oyo5xawuOhnin3AZnkM7gBEdAMoKGEBmE+XFNf3l4ZKeUpNyePNQFJUKR7eoYHO/c34pkgdZwa8YcXOthxbZ3FQ1DAk+mnA523kGCK01ekq4lU4cNVHAzYWdBUojMo95VltMZKwCjdZC9VEgDWIjTkaMCSS0TFxZd1JBsgqJH0HLbWwg5R4iix7vxO9f0OwpJ1bhSW+Z90RGyYpDSV8iA0Gd7CrBbqH+1Knmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vdceh7UZSrS/y/TPW49NJPmZJoDUgOh+57d7lOieIs8=;
 b=YsbNy+iCt212dPsnPXqJ99dHs9WtoPlfJ0YvRBDbs2Heg+Zp0/FCQk2IRVh7LslBSp+DHhBc8i2MBq+E7+qFn/ti6SElr3VVoCbHI33Knpv+o+4lS4EbrtVoJdyhR5gVwRVylP1UboOk+xmFNALyLvRy1Njupxp04G64Wb0+QMLwgrvgdDjiE2kgK+Ia0NzBxDgDSoWfCmaPQM/kanCBw8mkn33EmyBXYAtBrxSkz+ad2h7c6Z8r0zY27FhsuRsHARHHvd47L0Z/TpVLTKujlrMRBz7IxCLWtkEIW+zuBkaUSsQ7XZJcPtmmjJMu9Ix2U6j4Ybh78UmrVe3S2dqW4Q==
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5556.namprd12.prod.outlook.com (2603:10b6:208:1cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Mon, 31 May
 2021 16:57:55 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 16:57:55 +0000
Date:   Mon, 31 May 2021 13:57:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Dave Jiang <dave.jiang@intel.com>, alex.williamson@redhat.com,
        kwankhede@nvidia.com, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 15/20] vfio/mdev: idxd: ims domain setup for the vdcm
Message-ID: <20210531165754.GV1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164283796.261970.11020270418798826121.stgit@djiang5-desk3.ch.intel.com>
 <20210523235023.GL1002214@nvidia.com>
 <87mtsb3sth.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtsb3sth.ffs@nanos.tec.linutronix.de>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0104.namprd03.prod.outlook.com
 (2603:10b6:208:32a::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0104.namprd03.prod.outlook.com (2603:10b6:208:32a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 16:57:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lnlEg-00HBI6-Ku; Mon, 31 May 2021 13:57:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 566c6f06-dea0-4393-d160-08d924553c5e
X-MS-TrafficTypeDiagnostic: BL0PR12MB5556:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5556790FC80C749F9B55320FC23F9@BL0PR12MB5556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2qlkSqDHcNJTGmJxZXcJQK2G2kUq4MuvN7Yloalx9q/oV9V5VR2bh+ZrSVNAte5B+scGREUqPeN8qwodDrcxLzIA+NZqRk8/zu2OtT21ecLRWsI4yqZJWJ81yF6IGWq72EWXTPBp3Vp5jO22aNY8wp3nFmkO6xaKTrLlQVKLFTvj/CUcZoUigdREcnXllh7pfj+d3s0O4u1eVkFGzBuMCnc/39iYMQ6Qk3DwB8u5sxHKFMyOW6AI/3pHv8Yc96cRp8MiS1E3fUMwNJ0J6w1GrBVXQzDz2ZHiOipNaf9ns02RQeP2nWFc6fSU6QFflYAQsZIRzwnpu++59pKXT9FQxzw/Iw1sSbRczOyK8KIa0e43SqxBKoYudN+yzJbTxtj+wZbLjsbdWkFeYMXi6Cb/51cmtvOaEU118GlSVOxHcozCYyDauY2uj1jZs31DryUSq036CkPaIEHVQKjR1o81oIcAc/bCUP8ksJewNZbNGMoiAj6LoxmUnxFOi8g1YuJ6ytz2qnoclRAoyAMLRNLI3RsRXkfMEVPFdCNKN02LwTUVkFXjyQ13Q6LKyUovR0SSrpugFHIhkbDz+QTThkQdmaSrajc9tw8n++bYEtvF4NA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(36756003)(26005)(2616005)(1076003)(5660300002)(8936002)(2906002)(426003)(4326008)(83380400001)(86362001)(7416002)(66556008)(66476007)(316002)(45080400002)(38100700002)(478600001)(8676002)(66946007)(9746002)(9786002)(186003)(6916009)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SkeNKRI90ku/2cTtSUnPt8+pOWlkXz7T27P1tuVWaaTFtSqm8SzhwqAyv9Kl?=
 =?us-ascii?Q?TbviXlZyCQgLiuYowrJPhNZjYmgn2C0iXq9FdSvu2z6JUelmgWPE88dlJUhb?=
 =?us-ascii?Q?yIX9TkkcU9cpxAcjw5KtNpNmUcGxIqXj3DqrSaohE6mYXn5iC0MRgzozrtWO?=
 =?us-ascii?Q?Xh83j+pO3HiawuJE+ly9GonhSaJdaVi2p8+9e8nVpYXVEFFihTzdKrOho0+m?=
 =?us-ascii?Q?r1pny4pOVHbd0Qf9wiS03oiFh/wyDOCroJRiO2s4ClGr0HVoMp/p4ACSidNt?=
 =?us-ascii?Q?9vkYKGUEOmXkJP96KNiyOScp4uhDJkPj/aScdcdaSeiL0jOfcGZ8Dl0fKnZ5?=
 =?us-ascii?Q?gKxa9GVe+RmEhavJYL1MSuETx+w5kPbEjieRm5jkcTprhEQCceSq6Ko77FlZ?=
 =?us-ascii?Q?9ozKWRP1eGkXzCYvrd7dgb5UtLSETEhHdgtcSbCMpEhs1vVoZCF0YbdndJae?=
 =?us-ascii?Q?0zuxzZtr641pqTLdT97LAhsFW0QyaXf0teyuBpDl4waOu6pVPSTz7m5g5y9O?=
 =?us-ascii?Q?dVuym7H9Q3ydHvLMf7v3rW3VBwBjquOqengQ7eM5KsJvpuFiPptn8U6q5HSR?=
 =?us-ascii?Q?TKZ+uAihC3Cvcfi/TKXb1nQNC4qNYDINWuc3QPf+GAKxSXlfYAts4JkyEIWn?=
 =?us-ascii?Q?mwdF96M6Llho/BSEA8762ArrZmf177ykBsyCrZPl/0iW1gzRauBEH7yb69mg?=
 =?us-ascii?Q?2aVhKcA7xF1m05IQ2WORaEonagSzY0kkaO8b1F5o18L97MtFzkbDeKCL5l3/?=
 =?us-ascii?Q?Qki5Ih9ouS4p+D26tIEokQZcj2y82X2Z0zm06DbNaFqbahAIWFuunxdZ/tsk?=
 =?us-ascii?Q?B2uc6V7u3+riLcl/Y33w8OKc0Nr4BYWlCvhHdvTlnbZHhKFi4muN6QyHlcr9?=
 =?us-ascii?Q?Q02KNmE4LNXfBVC+JmJzPN4lqs3q3wHCXMcNmo9e/Lr+e5Nc33z1ZB/lt47y?=
 =?us-ascii?Q?8368Mkmy3y+Y0MWzp3DTZ5hE5bo6fDbeRyfIkISbwvn5oPnK1J27/iunkiU2?=
 =?us-ascii?Q?IgmRdrHpAtCefB+jhex32iINvZNkfN3H2dyyr1Hi9pMVgBcjSSE0G4CkENON?=
 =?us-ascii?Q?Bdnk3Qn2PuPjHr3LNd6WJV3ebRTsuBBKWgDzB7bPsWDeHGrnxH6CxmDdbeLq?=
 =?us-ascii?Q?9K8x5OoHzg4KXzGmRquAc4D4D3shSnxVk7ihv8i9dRCNMfjNhaDThwgjJg2L?=
 =?us-ascii?Q?b1NQ6fN87AamzzKJclhMYEZADdq5yZ/sEbzP8GjuNA9A1cmn1EWdUnqmq566?=
 =?us-ascii?Q?SK0rB15UsJhhbh/S/NNgMlBJw7/gkl5WeDfe1LetInnLTCzSXcAnjeDrvFDb?=
 =?us-ascii?Q?Hy5rtRKsy9SfyjzZiqPwwH3I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 566c6f06-dea0-4393-d160-08d924553c5e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 16:57:55.5065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3250S3pyDYYq4BFAYT96T9Y3u4ctGOPvibV0vbA2/Abs5CZQe1WnaJP8g6KKGV7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5556
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31, 2021 at 04:02:02PM +0200, Thomas Gleixner wrote:
> On Sun, May 23 2021 at 20:50, Jason Gunthorpe wrote:
> > On Fri, May 21, 2021 at 05:20:37PM -0700, Dave Jiang wrote:
> >> @@ -77,8 +80,18 @@ int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv)
> >>  		return rc;
> >>  	}
> >>  
> >> +	ims_info.max_slots = idxd->ims_size;
> >> +	ims_info.slots = idxd->reg_base + idxd->ims_offset;
> >> +	idxd->ims_domain = pci_ims_array_create_msi_irq_domain(idxd->pdev, &ims_info);
> >> +	if (!idxd->ims_domain) {
> >> +		dev_warn(dev, "Fail to acquire IMS domain\n");
> >> +		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
> >> +		return -ENODEV;
> >> +	}
> >
> > I'm quite surprised that every mdev doesn't create its own ims_domain
> > in its probe function.
> 
> What for?

IDXD wouldn't need it, but proper IMS HW with no bound of number of
vectors can't provide a ims_info.max_slots value here.
 
Instead each use use site, like VFIO, would want to specify the number
of vectors to allocate for its own usage, then parcel them out one by
one in the normal way. Basically VFIO is emulating a normal MSI-X
table.

> > This places a global total limit on the # of vectors which makes me
> > ask what was the point of using IMS in the first place ?
>
> That depends on how IMS is implemented. The IDXD variant has a fixed
> sized message store which is shared between all subdevices, so yet
> another domain would not provide any value.

Right, IDXD would have been perfectly happy to use the normal MSI-X
table from what I can see.

> For the case where the IMS store is seperate, you still have one central
> irqdomain per physical device. The domain allocation function can then
> create storage on demand or reuse existing storage and just fill in the
> pointers.

I think it is philosophically backwards, and it is in part what is
motivating pretending this weird auxdomain and PASID stuff is generic.

The VFIO model is the IRQ table is associated with a VM. When the
vfio_device is created it decides how big the MSI-X table will be and
it needs to allocate a block of interrupts to emulate it. For security
those interrupts need to be linked in the HW to the vfio_device and
the VM. ie VM A cannot trigger an interrupt that would deliver to VM
B.

IDXD choose to use the PASID, but other HW might use a generic VM_ID.

Further, IDXD choose to use a VM_ID per IMS entry, but other HW is
likely to use a VM_ID per block of IMS entries. Ie the HW tree starts
a VM object, then locates the IMS table for that object, then triggers
the interrupt.

If we think about the later sort of HW I don't think the whole aux
data and domain per pci function makes alot of sense. You'd want a
domain per VM_ID and all the IMS entires in that domain share the same
VM_ID. In this regard the irq domain will correspond to the security
boundary.

While IDXD is probably fine to organize its domains like this, I am
surprised to learn there is basically no reason for it to be using
IMS.

Jason
