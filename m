Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E85323D4DD
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgHFAqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 20:46:25 -0400
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:23524
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbgHFAqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 20:46:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gU3jKzOapUa2EP9Z1bZcKYFrxljklgPZXMErl83g5Lfr+IclgWHrJRrvODN3rXIR7RbLVR5HAai59AXkI8ZiOaZVgKkTWL5H+yZyFsM9eX8r/nfTn7EbIoylFaMC9TfdMCxYNNjFp4ofg0+B0w/S7u39MnuNsRAqSQirq2neao4DHhMEcqGxiNsQZutQHTPSN8ZWfDh2ZxcqDy42bBiyx7CbRfpdLGwddPqXF1qxXfOiblnojE2Iutczsbw3pMJuoZ/743gfdeiMtRJ3h9+LvCdFz7RNZIQ248ThF5E7X3GnoJmXy+PerS0MfN4gjNMfyFj5WgkdNPIeb6Khtp58dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJVQBcW4hT256/PgomfUcWtiFllxl/LoBaMm6CzjBHI=;
 b=OOBMI2xmNnZxJ2NfUqssc6Pju/rQJff7mL1lVazqcCG2Ii4bGkrA0WDMAEedDwtDIq65J43SNYWP2/xSRgIiRfIGMlXGU2gyFyLHKEgurc3j8OCsR3i93Z/gRKr6GB+Te/Fm+KQhKQ33JvI3VNt2cBgCUJh1f/sFvgmjb1UmKvPWQgSRYgYTJfa+j66cK8KVy6u71QS99i5yH9RammC+GaqnsKcNoS/ChaWeZ24htUNbLnBrY9bHhMr/kznxwUJJgcYwDjTI8IHxrY3wYNaywXRngSWG3rVG9W0Ip+tCcWenm2LlyfmWVeG5Ohv3Eoznwj1WOHOTnouPmiu3eoIVFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJVQBcW4hT256/PgomfUcWtiFllxl/LoBaMm6CzjBHI=;
 b=sFsK+4VIHDqgaCmzqhJif4T2jOrAM321UmOVn/QPYgVzMBtTfGZG8wpWe18ytDnw8mJWOCEHKWOVJWSdZXyphH5V9Yj9/KfjeJoSknp1lAty9Bm+McKDIJ0iWfOqiAUcjS3GGqnJk4E9yTEb4yZUjJJptR5lpfmEE8G+yz4nPsk=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4493.eurprd05.prod.outlook.com (2603:10a6:803:45::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.16; Thu, 6 Aug
 2020 00:46:18 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::10b0:e5f1:adab:799a]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::10b0:e5f1:adab:799a%4]) with mapi id 15.20.3261.016; Thu, 6 Aug 2020
 00:46:18 +0000
Date:   Wed, 5 Aug 2020 21:46:14 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Dey, Megha" <megha.dey@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Message-ID: <20200806004614.GN19097@mellanox.com>
References: <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <878sfbxtzi.wl-maz@kernel.org>
 <20200722195928.GN2021248@mellanox.com>
 <96a1eb5ccc724790b5404a642583919d@intel.com>
 <20200805221548.GK19097@mellanox.com>
 <70465fd3a7ae428a82e19f98daa779e8@intel.com>
 <20200805225330.GL19097@mellanox.com>
 <630e6a4dc17b49aba32675377f5a50e0@intel.com>
 <20200806001927.GM19097@mellanox.com>
 <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
X-ClientProxiedBy: MN2PR19CA0026.namprd19.prod.outlook.com
 (2603:10b6:208:178::39) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR19CA0026.namprd19.prod.outlook.com (2603:10b6:208:178::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 00:46:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1k3U2w-0041x8-JR; Wed, 05 Aug 2020 21:46:14 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3d4d3e80-06bb-4a2b-8f3a-08d839a22186
X-MS-TrafficTypeDiagnostic: VI1PR05MB4493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4493762000332FAEAC859519CF480@VI1PR05MB4493.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JffkrB6OM3UAs62K6bgfuq825jMtU4VGZe+aWplJBQvPQZMcG1Z48VWJFUigDE1SA6tgigBdCrNGwu4X0WVMbKpWMOIY2ttO650BIv7b8WY0oIjr0bPr90vCYOy1v3wJnRHI1EIU4hIDV5dXdgpgjyUx52eDa8Bm2M9YN6vypFOhZv7aOy9XjusONXRp/rDhebdWloIRpI5CJF/96stNA/iBNfefscev7DC6EtOvwl1z2RgKKldQi4C80SK0jPSA+Qp/gPBmgVxVhA2bH4aTWNHFzpjIa2+6jIhxt6USMtctYpoH4MBFI6yA/pJ7A7PNV4cqy7QY0HBIR3us+t1yQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(6916009)(2616005)(36756003)(86362001)(2906002)(5660300002)(54906003)(7416002)(66946007)(8676002)(316002)(66556008)(66476007)(7406005)(4326008)(1076003)(33656002)(8936002)(9746002)(9786002)(186003)(426003)(26005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zEmWJwMljiMzHl9+XMBCAkjGE8oPdvQo21+ny3BFALNp6ou0iot2xrLISXMgAdbuhzxlqDBKoUPSHwBWvSrFM5nKNN1WTF1vqLRmgjzjbMW++wzyB6ctSaQQK5Kdo55pDBaDkP6XxfzL815sUaQb00gAVDHc2cBzqaYUueneSa7vHu6gzNJ32NTF4cZe9L/pZcbH3OxDFZGEHKHIDSXMCDrZq5CDp5uNqQYIKccarKf9DJupsO57vfc8+GVqAFYlr3UkASchMZjIsrgaWzNFI8HeHEn0dtGr38WIzHsX9Gt+Oqk47piM0mL4wp13khmDBWCJ+S7QjyQrOFpRCrMcshhxpEl5lpcGpwB9JCE6Bl3pgaS1iaFruJwMxmESmUNyOcpMpru578xCDBllsm431qN3kkpMLR9nTDnC7UWYxNFaApG1Y9MvOPIInD6oYZgea53HN6ZpwjJTbjUfbhdyP79+Wuk9ShOlL1HxgN2RUP48fJaMiJ8pbzih01Ko/3Aqfa94yA0zyNSRRmb3fs1KYTQQIuoaf9DZDJPOoR86QSCuOygCVnnq0GoZ8yWhP/wnfIea6T6NUIsnnRy5+NGPQTXqBjlbKB5ewciE+zEmatw9l4zO/mVF7JqX3B7bbqOQxxhEW4lXUBUhvDb2ZTS3iQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d4d3e80-06bb-4a2b-8f3a-08d839a22186
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 00:46:18.5275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q7vYwNhVu3UGT+zk/7Vfmxg9IGrIQp+MN7E32Gd0BI97oLLxOUKAZF9PxiZmDDToXAvv6qR59q4Q0nCp9Xlcuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4493
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 06, 2020 at 12:32:31AM +0000, Dey, Megha wrote:
> > Oops, I was thinking of platform_msi_domain_alloc_irqs() not
> > create_device_domain()
> > 
> > ie call it in the device driver that wishes to consume the extra MSIs.
> > 
> > Is there a harm if each device driver creates a new irq_domain for its use?
> 
> Well, the only harm is if we want to reuse the irq domain.
> 
> As of today, we only have DSA mdev which uses the dev-msi domain. In the IRQ domain hierarchy,
> We will have this:
> 
> Vector-> intel-ir->dev-msi 
> 
> So tmrw if we have a new device, which would also want to have the
> intel-ir as the parent and use the same domain ops, we will simply
> be creating a copy of this IRQ domain, which may not be very
> fruitful.
>
> But apart from that, I don't think there are any issues..
> 
> What do you think is the best approach here?

I've surely forgotten these details, I can't advise if duplicate
irq_domains are very bad.

A single domain per parent irq_domain does seem more elegant, but I'm
not sure it is worth the extra work to do it?

In any event the API seems cleaner if it is all contained in the
platform_msi and strongly connected to the driver, not spread to the
iommu as well. If it had to create single dev-msi domain per parent
irq_domain then it certainly could be done in a few ways.

Jason
