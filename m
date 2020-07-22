Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C7A229EA2
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 19:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgGVRfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 13:35:24 -0400
Received: from mail-eopbgr30069.outbound.protection.outlook.com ([40.107.3.69]:59814
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbgGVRfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 13:35:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMwdmU9N+B3F7UUgTWzE6yWEbaJ1/ZyWiKNDrP4ll2AhSIzT+i39KbYGgB5xMjN4jVnWijfwT4NVjEbKjlr7c16coGr4/WfHbMxDSOnnUwCZUWiL+Jj0NcwAdSfV+nZ8iH3Ddr+d4+grjGyQCtPZU/Hu+r6ZAdWlSB7AL7Pn+bRSkv0RnZICy/hbRbnvwtRwGku3MudTBo9XyLeROuek/utBstU2Q0SYPWcJKyeXMriWpiLNn+jW0Nxg9PD6mOhjesM03JELLnT8uYhadw+3HglX54n0qDQIFzXk8JBFROTPPJe7QKw5doNLtnpFcjvRccY8cXk5Llu4OB4jV8hr3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SoAVyxFqDMRufcTeNWG2XVhYkBvXsxuYl6pZk28B0EY=;
 b=mM2QZy5hmv62GoaJMVno6no57EMe1E/vYM+dFYb+reBDGugZjTq1qrM6D0EGcymLaMBQKKolBFrJA4ttQBbVfnHTxKOKn9LK2a3vDHshryBnhkMGKCsvXUnjktAs30vcvJk0Pkog3/Jav1gXFBm2XSmlZ4yzETr/5xpN5U1tgX3Kn5yNO7X+kEXdg7zE/O51sUX/2+hi9WqA4nKPyJNCy7Q1YWujZEXPv3ZKV/Y/ZcfRmhnFaFJy4n6BmqS5XZ/IUq08HlFzR7ARUQKLsAwxfzte9LK51czHmpWU54U3k+HRSw0xT00rmFCHRetgksv6uY78mj6JNPCRdPZ+ljlmPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SoAVyxFqDMRufcTeNWG2XVhYkBvXsxuYl6pZk28B0EY=;
 b=mnNokyoMeEcNpoXPx35FAeEgJh97e0XGHaVdf6bD+UjcKrRh7qAv0iEd61t4237OolE+1p1bSTAWm9zPzzbF64psCxPmsvMY8IxCWiEU6l9VNgmhk4Sm83jaxA5ivRY6qkiU9M2PG17k0VCEsU1RA2epKOZIWaX5u3F9/XuRxYo=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com (2603:10a6:5:23::16) by
 DB7PR05MB5541.eurprd05.prod.outlook.com (2603:10a6:10:53::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.20; Wed, 22 Jul 2020 17:35:19 +0000
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::4025:1579:1d10:fd4d]) by DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::4025:1579:1d10:fd4d%7]) with mapi id 15.20.3216.022; Wed, 22 Jul 2020
 17:35:19 +0000
Date:   Wed, 22 Jul 2020 14:35:15 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Dey, Megha" <megha.dey@intel.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 04/18] irq/dev-msi: Introduce APIs to
 allocate/free dev-msi interrupts
Message-ID: <20200722173515.GL2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534736176.28840.5547007059232964457.stgit@djiang5-desk3.ch.intel.com>
 <20200721162501.GC2021248@mellanox.com>
 <b3bc68b3-937e-4b64-e1c7-84942d7ba60c@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3bc68b3-937e-4b64-e1c7-84942d7ba60c@intel.com>
X-ClientProxiedBy: CH2PR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:610:20::37) To DB7PR05MB4138.eurprd05.prod.outlook.com
 (2603:10a6:5:23::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by CH2PR07CA0024.namprd07.prod.outlook.com (2603:10b6:610:20::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Wed, 22 Jul 2020 17:35:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1jyIeB-00E0fv-Pz; Wed, 22 Jul 2020 14:35:15 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5322ad24-c8dd-4867-219a-08d82e659a56
X-MS-TrafficTypeDiagnostic: DB7PR05MB5541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB55418ADBA05B2CC8199B2F3BCF790@DB7PR05MB5541.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eo3HUO8OujRmfSBoNb5qORgarqJKD5KnI2DDW5hndAC8bIM7I1QzneLSnNKRwQXxYt4/iVcN9/CzMtNwggGBBaz1L7QuaLjUJl1PNU3/+q9X0u5D2SUJ0PyeUGIlqttNRickCE9upPs2dwoELxXbs+8vX+hZRrUMWrfFDSFUVNTiILrEfrc+emfxmueGJ9Pfj+oMAaZ/4FlSmZ2Bi92uzI/xsX15c+Ke/ASa1f+arY5mYcSQXFndsKyyIN4XEyDoFQatdmJdURqsD8zM0o/E2CIdsbnq+DbwtGCCaYYJ/HL8diBCPTPc6IjQDhvLIsraKd1rf21ds6E1KKHMfiYLTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4138.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(66556008)(66476007)(66946007)(7416002)(7406005)(478600001)(53546011)(1076003)(4326008)(186003)(2616005)(26005)(9746002)(9786002)(316002)(5660300002)(6916009)(426003)(33656002)(36756003)(2906002)(86362001)(8676002)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: q2ncw1MuyJDZVY1pO/6wpRN1HVg4mwJxI/R2FS2D/Q9pOXnRCtD+0QMl4+LU1We7HEBxbQt9hB7gRiZ2+OUo8Q7FUbGuxw71aCmcNUejUkqF7p4u1y5kWAyUpTzS9wbPnOiUPQtrcdQO9aveuUFUmiUT8qgyxf9cI9psby/nYz9Zwbmx5ts4ino8cRbpNyRIhS+A4rbjUPA1T70+4+PHYCOzBY+rSoghxY3YUPA1kE6bc/YKfKNTiddQhb0LvDtP0N8eGc+FFMBz+ZVlyD8KDNDSv+SozmHwAnGcSYxmbgHdqrZ67KfK3eK4kgEaee7s9WhhhpJaTyu56m2e2koEDSIok5+M5K0Ss10jO5W7QAKas5W6iiet+UmlJtutA53Gz8ZUWH3pZM6SMmm+87Xpky5cKnRmVDmFJ4Chh7up7r/uRFYq0PTIlnldMllL8N4wyw+lAAUuB9E3NyCEdTiTaiMJHAZQqC7TRuA48zR9d+0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5322ad24-c8dd-4867-219a-08d82e659a56
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4138.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 17:35:19.0095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SIUZNednWQo/IsRVUzX5AmogpjSsByjH12lSiQ1Q9k1sLBK39jkWBRN+wR+RVJjrCaZuYlv59LzSsTD6et1l+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5541
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 10:05:52AM -0700, Dey, Megha wrote:
> 
> 
> On 7/21/2020 9:25 AM, Jason Gunthorpe wrote:
> > On Tue, Jul 21, 2020 at 09:02:41AM -0700, Dave Jiang wrote:
> > > From: Megha Dey <megha.dey@intel.com>
> > > 
> > > The dev-msi interrupts are to be allocated/freed only for custom devices,
> > > not standard PCI-MSIX devices.
> > > 
> > > These interrupts are device-defined and they are distinct from the already
> > > existing msi interrupts:
> > > pci-msi: Standard PCI MSI/MSI-X setup format
> > > platform-msi: Platform custom, but device-driver opaque MSI setup/control
> > > arch-msi: fallback for devices not assigned to the generic PCI domain
> > > dev-msi: device defined IRQ domain for ancillary devices. For e.g. DSA
> > > portal devices use device specific IMS(Interrupt message store) interrupts.
> > > 
> > > dev-msi interrupts are represented by their own device-type. That means
> > > dev->msi_list is never contended for different interrupt types. It
> > > will either be all PCI-MSI or all device-defined.
> > 
> > Not sure I follow this, where is the enforcement that only dev-msi or
> > normal MSI is being used at one time on a single struct device?
> > 
> 
> So, in the dev_msi_alloc_irqs, I first check if the dev_is_pci..
> If it is a pci device, it is forbidden to use dev-msi and must use the pci
> subsystem calls. dev-msi is to be used for all other custom devices, mdev or
> otherwise.

What prevents creating a dev-msi directly on the struct pci_device ?

Jason
