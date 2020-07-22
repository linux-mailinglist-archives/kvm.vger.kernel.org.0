Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A1022A062
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 21:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732480AbgGVT7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 15:59:41 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:20215
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726525AbgGVT7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 15:59:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCe1iNUWcLy8vnQKdTuUqBZvnbvLjh4qkDR4hSMx1bD69PsL7mY6axtzqEkIpoBhJXIkvqelDkOsNiVroSCV3EpNKb4/zQ7b3aeRPhTo0apE6qxsngBZOI/WfcBrcGzVSV44GJbXAOS37hpAfLcT1EQEN1T1j6YsOR2EkB6cM2kwcvmuej9sG9+TWapC0Y/iwtyGyXAnyOrGonJ8uy9oyuhgMheQXe8OGoYuE2pP2zO5EhRq5cbT+7axew4mPW6yLkmKfJuBKLOsCp99ZRS6WqWezJw0z3jQbZHWzCl/oGns5I8+OBp8iP0/eervcqrNf8rbAEFaxnBDqocxf81Pkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGnDCXd5ioezBdVspcwdN8R6jyAldhQV7kTz7vVKUPo=;
 b=bK9BSD8Kx/3UfwfrTo/6eboa/EMXuCtGl+UXEw6f1+Dm4LiWvNNyTu704pAu9KLIbzCak7YjMHpSIyaYyBPpKIizNqWTmLGxaN2Cmcgr8ISHdGTQk46sPSI5k5a7gsjxInBf8sdSpyp29ZbfIq3iyeXe5TOyhq/n2bJYOAxBaedFb/ESdmK0rRizjtpd+pkJt/V+gKSsXB7sydEiszNRL8jpqGe9dqcvacTUuLe0Yg9pBZqVuo51Oji5UDgLCMVkWhuV5bJop8kdjMjOHR8GAWh+alkp3rHmtDyJrCRFPhKn3gw0tPCjmNqOTwGQ4QTi54zWL+SqZV32n0Tta6kUcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGnDCXd5ioezBdVspcwdN8R6jyAldhQV7kTz7vVKUPo=;
 b=QpR1PRHNvYFNgMQK6cfFhLcQX/TWdgVseOG6fcMziI2fWl9jJAm1K8WBLRkSzrPlgaM9Lstjgg+1CXTGNYqq61k0m3ITAKxU2xr+44CM8YnqwzMAvrD9xI6b/0oweZC8Xw8RxJVv73CJr+WbNUVKwwFI56LYciRhS1fcP99Uc8I=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4927.eurprd05.prod.outlook.com (2603:10a6:803:56::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Wed, 22 Jul
 2020 19:59:34 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d%5]) with mapi id 15.20.3195.028; Wed, 22 Jul 2020
 19:59:34 +0000
Date:   Wed, 22 Jul 2020 16:59:28 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, bhelgaas@google.com, rafael@kernel.org,
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
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Message-ID: <20200722195928.GN2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <878sfbxtzi.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878sfbxtzi.wl-maz@kernel.org>
X-ClientProxiedBy: YT1PR01CA0042.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::11) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by YT1PR01CA0042.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22 via Frontend Transport; Wed, 22 Jul 2020 19:59:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1jyKtk-00E3bq-St; Wed, 22 Jul 2020 16:59:28 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 74a53c8d-c10d-42cd-55c0-08d82e79c122
X-MS-TrafficTypeDiagnostic: VI1PR05MB4927:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB492769BD90DA2B21586A0AFFCF790@VI1PR05MB4927.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KZO/s5SjgDuTOpq6Ob71zmkgmx+++dbgADhS/sFB/Gf7gMMqheBCOZtNZhPGTK2n6zu2bbQe4+/kOB4obFihg/wV1I2V8+cPojH93sOomuCxswLWOimrSB6eWoynIybN4NarETaQUodSY8ON7XQ0QzUD3dJezzQ8aMFVjz/qUHwGe9fpiSZVDRs+BQjdVwMAWacYyZ7h1/cayoxO+U1XJP+QbmH2Cj4iIsCf9mMMzdiAFZnUSwaGMK4tDsOctksMuG+3P0FfU5ggpksZq/UZTPo6I7pctZ9cbeLwhcj9YWZNm/nrhgeq06SJAxcG1HKt2ev6Y/ysb9Y4DllLZzkBdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(4326008)(2906002)(9786002)(9746002)(186003)(66556008)(33656002)(6916009)(26005)(316002)(36756003)(7416002)(7406005)(8676002)(66476007)(478600001)(1076003)(426003)(2616005)(8936002)(86362001)(83380400001)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: p5G0tpn4DYJ2hk8XGZlkDMkPkNM0Lk5BF3802CEMXlozv2UvFVB4+8siuJjyGdHmxvgnfEv5d6uijNshBkGoQKiNTrfFFNWhcaq3YhSJOs+ATjU0LpF5mURSclBW8wd9ahapb4lPfH42OXt4ltCfiaQWi0/a/PT5LwN4fN/BDeJjWd/tgCW5FcEHx3m641H0lTo4NURMR2M8khL/lUqvRR3obZdKab9z/TU7MrAlcEcpA5Mm6OTOU140tP58DWml1BDDxQBwRGMJ6NCGQwrHUmIhMIfEOHdtKxcJ6+/NwRVIYLSlPU3pHm5Av3OuDxxYoJHBO+C9s8VeJsy1CZQJD7Slu77Kdjdzo/7y5J6jgd4ECrgkz6tuUAYiG8JHdj24SjPonS6viA5wN3h5ZrwHNyhNZdiEOcZdJFmbNSv8mLzCJTYGIalkBVlhyss4/fNAVNq+PMs103MejpxqEhP+jTrYx8OwzWxvtDHPPZd0GII=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74a53c8d-c10d-42cd-55c0-08d82e79c122
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 19:59:34.6744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xD151n8rjK2bbI66Wj7FTCm0tg27V0dudWfZfQmYmxpwXfRgyRTHzmYoSMzHo4Y3DgPEu5oGt6mSwFU4Y+JLNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4927
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 07:52:33PM +0100, Marc Zyngier wrote:

> Which is exactly what platform-MSI already does. Why do we need
> something else?

It looks to me like all the code is around managing the
dev->msi_domain of the devices.

The intended use would have PCI drivers create children devices using
mdev or virtbus and those devices wouldn't have a msi_domain from the
platform. Looks like platform_msi_alloc_priv_data() fails immediately
because dev->msi_domain will be NULL for these kinds of devices.

Maybe that issue should be handled directly instead of wrappering
platform_msi_*?

For instance a trivial addition to the platform_msi API:

  platform_msi_assign_domain(struct_device *newly_created_virtual_device,
                             struct device *physical_device);

Which could set the msi_domain of new device using the topology of
physical_device to deduce the correct domain?

Then the question is how to properly create a domain within the
hardware topology of physical_device with the correct parameters for
the platform. 

Why do we need a dummy msi_domain anyhow? Can this just use
physical_device->msi_domain directly? (I'm at my limit here of how
much of this I remember, sorry)

If you solve that it should solve the remapping problem too, as the
physical_device is already assigned by the platform to a remapping irq
domain if that is what the platform wants.

>> +	parent = irq_get_default_host();
> Really? How is it going to work once you have devices sending their
> MSIs to two different downstream blocks? This looks rather
> short-sighted.

.. and fix this too, the parent domain should be derived from the
topology of the physical_device which is originating the interrupt
messages.

> On the other hand, masking an interrupt is an irqchip operation, and
> only concerns the irqchip level. Here, you seem to be making it an
> end-point operation, which doesn't really make sense to me. Or is this
> device its own interrupt controller as well? That would be extremely
> surprising, and I'd expect some block downstream of the device to be
> able to control the masking of the interrupt.

These are message interrupts so they originate directly from the
device and generally travel directly to the CPU APIC. On the wire
there is no difference between a MSI, MSI-X and a device using the
dev-msi approach. 

IIRC on Intel/AMD at least once a MSI is launched it is not maskable.

So the model for MSI is always "mask at source". The closest mapping
to the Linux IRQ model is to say the end device has a irqchip that
encapsulates the ability of the device to generate the MSI in the
first place.

It looks like existing platform_msi drivers deal with "masking"
implicitly by halting the device interrupt generation before releasing
the interrupt and have no way for the generic irqchip layer to mask
the interrupt.

I suppose the motivation to make it explicit is related to vfio using
the generic mask/unmask functionality?

Explicit seems better, IMHO.

Jason
