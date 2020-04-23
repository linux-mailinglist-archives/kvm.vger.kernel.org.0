Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFB91B64B4
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgDWTo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:44:58 -0400
Received: from mail-eopbgr30079.outbound.protection.outlook.com ([40.107.3.79]:15757
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726060AbgDWTo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:44:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4ZM3i5j0KTs/SJnr4NyHuFwqnSnSwbXN/kvvSlA+fRNXZGMcqbUHKRsipEy+gOVu8Uy2nJttVUzQ3aqp11pOctkQkTyciMZXxUcV3xpwqfhqXIKZ5Vofsn5GuV/2p4SrOLbBVTHxA7X67NVFlaTvl+xnhmueakvOgvaUydD3LyVPgn261CNfBF3AjaqjJeEQN7uCRXvDfVXratKci5q8yFmYXianqQhlc2UeVHCRgeDONGbYsHK5RxownqqbCjWP3b9D1BvnxuVLE6dPUvqjsrOUpY/gAHrKoEESnQ93i2S+MWQGBswz6ht9RYcBdrvIfrdlr5SxAMqC4IXE3bXeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bb8MHrPnz7ro9tAT91kKIX0+HAVCqvHVd2q5BdVU1YE=;
 b=iQqZsMD/atGmb8tInsrMrSm5coVpVKUMvDN2T6oVZlU3gGjbAcuj0iZTQOGlOMuL5Imd6TZIwjrbd0McO3pxJ8Qh5ZvFb0GifFvI7jpprMzVcBruTf6zK3Plo7/SsBbHl88dxFL992n+AytoH2jfPaC+rM5CukLwTw/FET8uDwkf1T5JFiHiGiXUKImTr7xnhWlwpJ20eLV18bjgonZELzdJorKCDyLiMl+YnumCrA+F99LO4OeORCjlsnkOJXNUlIEyb+HUkS/FX+YMldp2cTknFopfUvdbRivLXPZOcw/0T1Uw8sN3bYMjR4+64ee4oJ4buLOqkcMlySJvuRIPYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bb8MHrPnz7ro9tAT91kKIX0+HAVCqvHVd2q5BdVU1YE=;
 b=fUl7Rnsc2J1seniLStP9/05Fkqu2/C1sHIJGUFiYD6funX5a72lyt9s8slTlhtbL4hESJD9C1ulMKmZYpeaz0CTY3oL1uq6dxOYN4TMEtkzR+HUcfeej11BeC/9U/4k3c4wny8dfF1opEmeLIwMZJWjMgoGFd7R7ptaGHD6BRO8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6864.eurprd05.prod.outlook.com (2603:10a6:800:18d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Thu, 23 Apr
 2020 19:44:51 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2921.030; Thu, 23 Apr 2020
 19:44:51 +0000
Date:   Thu, 23 Apr 2020 16:44:47 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Dey, Megha" <megha.dey@linux.intel.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200423194447.GF13640@mellanox.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <d6b3c133-ac19-21af-b7a7-b9e7166b8166@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6b3c133-ac19-21af-b7a7-b9e7166b8166@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:207:3c::19) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0006.namprd02.prod.outlook.com (2603:10b6:207:3c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Thu, 23 Apr 2020 19:44:51 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jRhmB-0007Nj-QB; Thu, 23 Apr 2020 16:44:47 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b638f078-0179-4ff9-ef58-08d7e7bec9ce
X-MS-TrafficTypeDiagnostic: VI1PR05MB6864:|VI1PR05MB6864:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6864D7E39C188F62907AEB33CFD30@VI1PR05MB6864.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03827AF76E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(9746002)(9786002)(86362001)(6916009)(33656002)(966005)(5660300002)(8936002)(81156014)(7416002)(478600001)(316002)(26005)(52116002)(36756003)(2906002)(2616005)(186003)(66556008)(4326008)(8676002)(66946007)(66476007)(1076003)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zIov0yGLtszge3FwMpb0PHRZoBOp3ez5Rldeh1h28cuczRS9yjwO4eFUfGuj2uM9I1zsnpszknCRfJgkKtwHnsgWbA3luJXNimG6FLe/w1aTiojdZjRBjjEG4AfAOHGcwFSICR3pxGyQdeo0g0l3lzCFeqR25J4aOZDgUgKuvOAYZ8YfjKM8WziVjaAdFbfBx29p150BKv8a9HCKn9X1fNNVoZT3+zJHaOq7dLgFjF5V0FwIXsj8Jh810m4wjqVPZkMySqw8Bpz0A0MdTQAIWdlDj4Lm87lqlmbpzN7Jobgs7u7DmGWYDMo8WTwegYBcgYunG4k4E4g2wqjZOw1aEPzzMNB8U0sglqNdWqa/ufh9zV3wuGMvNEoNPNx9evwooytwDIiLsOs6lkVDwUKePh5hXAQbiGwHMMZOnBpkqMwcGWrbaORTAp947HQA9pafY30JOM6BGUMx58DWxp84YOkuN57d02oVS9Ny9XwVna1PBz6RtNuw94jOWvTtTIp9amtSPPWt6BlnyNM5sTCHYNsHIq6yxk/e+3Xqe4AQofaPY0wgIghRxs1ImNtlAZ/u25M9SS84lvM05mm8vcDuDg==
X-MS-Exchange-AntiSpam-MessageData: Piq+HwZAKA6FSqiGfzzJJyvYm9L1rVHl6LrJvhiPRpk80xEKsvuxYYwOQgFY/l6SwPACb3x6p13J6CXHMIix1MFXfl4k8mR8kAfJqCrllWd0LRmA7HaQNAFitYOdxi2161bTi4UosgIB5jnRhB52RQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b638f078-0179-4ff9-ef58-08d7e7bec9ce
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2020 19:44:51.3188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0gdmxLUVTleRKVey1pBiR3kMhazutDo4wERH66kOZclaOoWyxoIduT5HLXv5UUkjQg+9AMq3aB+9JBvNH8HhRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6864
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
> I am sorry if I did not address your comments earlier.

It appears noboy from Intel bothered to answer anyone else on that RFC
thread:

https://lore.kernel.org/lkml/1568338328-22458-1-git-send-email-megha.dey@linux.intel.com/

However, it seems kind of moot as I see now that this verion of IMS
bears almost no resemblance to the original RFC.

That said, the similiarity to platform-msi was striking, does this new
version harmonize with that?

> The present IMS code is quite generic, most of the code is in the drivers/
> folder. We basically introduce 2 APIS: allocate and free IMS interrupts and
> a IMS IRQ domain to allocate these interrupts from. These APIs are
> architecture agnostic.
>
> We also introduce a new IMS IRQ domain which is architecture specific. This
> is because IMS generates interrupts only in the remappable format, hence
> interrupt remapping should be enabled for IMS. Currently, the interrupt
> remapping code is only available for Intel and AMD and I don’t see anything
> for ARM.

I don't understand these remarks though - IMS is simply the mapping of
a MemWr addr/data pair to a Linux IRQ number? Why does this intersect
with remapping?

AFAIK, any platform that supports MSI today should have the inherent
HW capability to support IMS.

> Also, could you give more details on the device that could use IMS? Do you
> have some driver code already? We could then see if and how the current IMS
> code could be made more generic.

We have several devices of interest, our NICs have very flexible PCI,
so it is no problem to take the MemWR addr/data from someplace other
than the MSI tables.

For this we want to have some way to allocate Linux IRQs dynamically
and get a addr/data pair to trigger them.

Our NIC devices are also linked to our ARM SOC family, so I'd expect
our ARM's to also be able to provide these APIs as the platform.

Jason
