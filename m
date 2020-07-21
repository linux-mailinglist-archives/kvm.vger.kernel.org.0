Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A769F22865E
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbgGUQpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:45:42 -0400
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:31221
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728732AbgGUQpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:45:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWu5oN83QKpKkFj6C2fdTz1ueCuO+fWnbU6ACWF7tRRqrm5x6t6PIQxIC61ybrZ0Jlk9AOC/u1kZ5rXgz5QJBjwQUiF1QaXXnHaCqwqucoo1E+NKhpA4f0CZU1TeDBb9jFWROAqB7OPdz9g5/mHCdaFNOF2yXQSuj7LhtsXnbPWKCYkA8Z7H5F4hWeXTSOP0m1AIYtOqn9j6LmEkw0sb6Xiw5g2fhfsbkZXbW2VAT2M+ZwjR/kRuJMUYDFkiEzhcGeLAA9nQTqZEmLAKbIDoai1Si0lZlAXC9uEpt+fyffaO3i4ZVe47c16GVgF1OfJfKsXa6BFkLUezjr3qmDpyqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KB1+xW1JOVkQ9k5s+GzNaQdle4TosuvO9MSxQ1oXU8=;
 b=jLy+TI34xoUgmfWUnh8kRxuWNgrKIyTTQ5enbNahBe0dwUrMuCp6IltQsLN65g5SSGEJ0y2QHnz6X1yLXZPndk5GkimqRMb4z+3o739j7OUY9clwxKjfAohzIcokhMQC10iAkKsGh3rHWTYjV9bfP+duRKkoOch9qeTR/iMtpRHylOsPN2g1RWDX58/a1EsyIHBbX//e20A7OA4E/jfeiG7QIfzZEJW92amnZuNvcchD1SkL1SkbRFbmifpiUthRcfPg5UoNeF6XVpXHIrIxB7VZ+vN7nP1XR+WOb45NCKg14xK/rYK08org5gGp4ETz6+XLFk2MSwrEqAt9WqZLZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KB1+xW1JOVkQ9k5s+GzNaQdle4TosuvO9MSxQ1oXU8=;
 b=FR9eCJbqzJGEBMIW6uQTg32o8/O4KYS76xxFFYQj5BvU1+uTNow9GWbRySwzmjV0cH8UjG9Rn+p+U7gZyWWqge5KU6repNtLTHOXHqEO3bBcB1BoNt+/cO1wOtptYUomSLelyzEdcFZqnvJ8ikEiSVJS+a9mP3FOF7c1Yaptgck=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB5183.eurprd05.prod.outlook.com (2603:10a6:803:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Tue, 21 Jul
 2020 16:45:31 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d%5]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 16:45:31 +0000
Date:   Tue, 21 Jul 2020 13:45:27 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Message-ID: <20200721164527.GD2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: BL0PR0102CA0057.prod.exchangelabs.com
 (2603:10b6:208:25::34) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0057.prod.exchangelabs.com (2603:10b6:208:25::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Tue, 21 Jul 2020 16:45:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1jxvOR-00DH1l-Mx; Tue, 21 Jul 2020 13:45:27 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60e0d88b-08a8-4486-b930-08d82d957b19
X-MS-TrafficTypeDiagnostic: VI1PR05MB5183:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5183A6AD1584BA02BF288933CF780@VI1PR05MB5183.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxi4rtN97Bo4zxbh1rZGJ3gU08j/+mMjLx1j289AZ7sryIrhO7XYN49IO5PpQ+iOYbICTrxsNGPpK5nN9o52lBErI4osfYM+bOAjat5vntK1lULLPoZmF7GuV2zaPAOpID2uHN+63C1YEixYvnSzuoFuF3Uh3QHLoT8slv/tiCAxxx19XXBJfdIgroxoS1ywTHh31nMIaMNRblhO6sulvjiF2rd98pzeuHGMF/UeOssnOTD07oDwnzmP+q3PAR43TNxApxZoJYGtd/btzz8R6Y0bvzgcsBbnZ3rqynd6gTG3eqkqgb4Luy+w92GdrZKpp+RLmhiUrsPBJT7KcwnJkJQDWx3fJGpp6T8J8tC1G3mOhFvr2j0fdmcFTPvCiUOMQKnR/yu0yDaDCi7t341wiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39840400004)(376002)(136003)(346002)(396003)(2906002)(66476007)(426003)(478600001)(4326008)(9746002)(8936002)(966005)(9786002)(2616005)(8676002)(66946007)(186003)(316002)(33656002)(86362001)(7406005)(6916009)(83380400001)(5660300002)(36756003)(7416002)(26005)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oqqVlI3nfj8oPGCaJat5P1nS+2a5c+CFBnoVBy6QNViEZ1Xe6652tRe03W7EhDvUEcP/m3yQ+HpyoIvjactRVyPcMwrQYvWVGW1d748cQ8J9TNW4TYvCS1MRl1DbhLZfHaetneBrItHtbrbcl5P95PxJpEtHaK+fit6h7X2ei3fZxhtwn/sDPtX+H9Re2CXlNAmoIXXzU6SNNH7gBuWW9V8qMUZlsWWxbuqkV5n3pxoqyVcJcAy1lzb6ROaC2tSmzvbUf1ZXSCV+T2psRcozSNa4EDWp9ZPEGvwYzbu7Uyv6swjsq+u4m+zAzYmYrj+wsEj/6GLkiudN3RlDYkwctXCgIZpLB2YdN2NdArJm1HhCCYbMhHt82jaPTjow8/69JAWxk+QSFNSz62Dvy7komBS5x+1OZLefY0cvaOw57h6TKsBo8IaxBLLvJGtOQMIWi2LQVTNHycDqYA4DA5e3CXANhlIo9ZtNZKoL/DXMmr4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e0d88b-08a8-4486-b930-08d82d957b19
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 16:45:31.4963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hwbn8s9k1hr7+FBAFfuHQHhMhQXXZ3nlon3/N/XXBHNKbAnZhzJK+QtVg5oNtfMUKkMKIOZyJzszeCef9KgSOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5183
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 09:02:15AM -0700, Dave Jiang wrote:
> v2:
> IMS (now dev-msi):
> With recommendations from Jason/Thomas/Dan on making IMS more generic:
> Pass a non-pci generic device(struct device) for IMS management instead of mdev
> Remove all references to mdev and symbol_get/put
> Remove all references to IMS in common code and replace with dev-msi
> remove dynamic allocation of platform-msi interrupts: no groups,no new msi list or list helpers
> Create a generic dev-msi domain with and without interrupt remapping enabled.
> Introduce dev_msi_domain_alloc_irqs and dev_msi_domain_free_irqs apis

I didn't dig into the details of irq handling to really check this,
but the big picture of this is much more in line with what I would
expect for this kind of ability.

> Link to previous discussions with Jason:
> https://lore.kernel.org/lkml/57296ad1-20fe-caf2-b83f-46d823ca0b5f@intel.com/
> The emulation part that can be moved to user space is very small due to the majority of the
> emulations being control bits and need to reside in the kernel. We can revisit the necessity of
> moving the small emulation part to userspace and required architectural changes at a later time.

The point here is that you already have a user space interface for
these queues that already has kernel support to twiddle the control
bits. Generally I'd expect extending that existing kernel code to do
the small bit more needed for mapping the queue through to PCI
emulation to be smaller than the 2kloc of new code here to put all the
emulation and support framework in the kernel, and exposes a lower
attack surface of kernel code to the guest.

> The kernel can specify the requirements for these callback functions
> (e.g., the driver is not expected to block, or not expected to take
> a lock in the callback function).

I didn't notice any of this in the patch series? What is the calling
context for the platform_msi_ops ? I think I already mentioned that
ideally we'd need blocking/sleeping. The big selling point is that IMS
allows this data to move off-chip, which means accessing it is no
longer just an atomic write to some on-chip memory.

These details should be documented in the comment on top of
platform_msi_ops

I'm actually a little confused how idxd_ims_irq_mask() manages this -
I thought IRQ masking should be synchronous, shouldn't there at least be a
flushing read to ensure that new MSI's are stopped and any in flight
are flushed to the APIC?

Jason
