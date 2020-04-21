Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9B61B33A8
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgDUXyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:54:54 -0400
Received: from mail-eopbgr20077.outbound.protection.outlook.com ([40.107.2.77]:9958
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726024AbgDUXyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:54:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbjGSJ+8wMbR/j3l8b8zsJqA5x6FH4m6s5d34nWE1jddhXqRSQsuoVHSl1JMoGHWfmvlnDpvMj2vZghrYHIG/swqYyBGi/fMGDGZBLOD93jTpMOz5va+hdYtJB8BXmABIrW6uXUMY3U7i2AlTp7T7biC5KgdYXfH1WIsNRw3btSFSup5JS5frkrg7Y6BBsnNWELKitRUA8aVuT9R8WDBcezaKkXNN/3D3gQ9kN3qQn/40RGuQAutSHP6Xl+DBBh9wZlrPejzjybkA6zzYqx12BZRwmL3z7bAemxXuR0qMtlGxslP4YSTJMfZQK+5vPZlHDu30BwpQkvpHWoTqFW2Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DI9TeCUlk6cr5ju3k7eo3+sB68Jb2gjnkbV1klVWn9Y=;
 b=UtwysLo57q2tC2w1u8JfOftmbENCyGR+aWV1ri1eSoqFRq1gUO8UUZPLItY7uJz0qHbnSGZ8/Dje3U4A+XrkwzBdg6ylNgAspW3j4r28vJkRwpDOHPpKIbJnSN5bRbcMruiWaM9JrkKiaKnf+pcMNfYQRG0JiquEc+umYMtq5qSAYiuBkDFd5ZCuCanhaOktBcL8ylYKNsIqQ2kunnQSWTMyOoBzSKm7UG5/ffs6cAojoSfM1hyO+9K0W5MLc40x9/AyC9dJulreL456zdheSe43ErVbvFdIHebMUnxUHqHAOaEnYoWKCzbmbWFIZpuoubmUPCYG2mUym4D8Tz6buw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DI9TeCUlk6cr5ju3k7eo3+sB68Jb2gjnkbV1klVWn9Y=;
 b=DSFm5szqqmnS4/XpckF0juzwpqk734aZJ+nGfZUCFrtsYL7ac5jTiEg9OkMZom3n6rT+g0lIK4H9B2Q+C9CK9LkLW+KiLoll58G4SKNTYAIIceRRA6+IOoTJmQebpTKHh21XjjeMtiddlws/bymFlPq+zP4ITyCwOrfVK/ItNBg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6863.eurprd05.prod.outlook.com (2603:10a6:800:183::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 21 Apr
 2020 23:54:49 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 23:54:49 +0000
Date:   Tue, 21 Apr 2020 20:54:42 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200421235442.GO11945@mellanox.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR22CA0029.namprd22.prod.outlook.com
 (2603:10b6:208:238::34) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR22CA0029.namprd22.prod.outlook.com (2603:10b6:208:238::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Tue, 21 Apr 2020 23:54:49 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jR2iw-0007oP-Pw; Tue, 21 Apr 2020 20:54:42 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 309a3179-a52b-477a-3a21-08d7e64f6080
X-MS-TrafficTypeDiagnostic: VI1PR05MB6863:|VI1PR05MB6863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6863CA4B83A973F0581F605ECFD50@VI1PR05MB6863.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(376002)(346002)(136003)(396003)(366004)(8676002)(81156014)(5660300002)(36756003)(8936002)(2906002)(9786002)(9746002)(478600001)(1076003)(316002)(7416002)(6916009)(33656002)(86362001)(186003)(66946007)(66556008)(66476007)(52116002)(4326008)(2616005)(26005)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F4MNDwIOzI+h0VJSfivbVuOQVuwZspASOC+Ot9w4JnW8gNFyJvWO3Kz3pCaktnJGjG4bfhy2FumyfdLsYAKSaZeJZq3yjk+5udGd6Y2srOTq6ZupsnV0Ojv3bRy3APIMyLGGhgXfDx9fLcK9Sgs6hXxfo2n4fTmbyiwATHlVGiFFHtmWIdILB1OGUzgFa3yLv3ky95LnIgodfOk4Agg2KisU7WXmbFlRUlafyRTpHtumujJNRABMyU16A4ic3vLqtboUHlekU/HGJkvNHfntjc0s7IQLf+Y00rW1+fNPEZR0zW+82BIoX5ZlcKCUKLabSCCfa9+793J8Ky3PHCQiIp93AHRJvMMxJbvCWzL22uggPclN/SmuK8Pv7MNQ+v/N3/oQ+NoYFANVpiiqvOqM/01HxtKqXKkjG09gJkx95/R25+zjjvDMzWZz7Pcoah0q8J/vCA606ezHX9A3qK6UoVTP5YmDfDX2bjdo95k2IFRFve8tHWZ2FOgb0zAxMRAn
X-MS-Exchange-AntiSpam-MessageData: cRXwN6dlLtb/HnXl15bJS0YEJDnAXCvTb3/1r1PoUxXJWjF+rD6L0tV5CaigP0VFyYrdhW2lvJkIs6fvlbPkV8qs9BTeGjMdKqPu98TFpjirSz5vBQYKe8T0OJ0Zlt4mhZVXwIFpYr2/N8hIghCDCA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 309a3179-a52b-477a-3a21-08d7e64f6080
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 23:54:49.4713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zdofpYbLtc4zdD45B9tHWq2/iFU6GmjsJzirzlH8oCYN7CF28v2UlFk1HCS3RHLsHj+Pkk3pfzA/iBxkGft7UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6863
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 04:33:46PM -0700, Dave Jiang wrote:
> The actual code is independent of the stage 2 driver code submission that adds
> support for SVM, ENQCMD(S), PASID, and shared workqueues. This code series will
> support dedicated workqueue on a guest with no vIOMMU.
>   
> A new device type "mdev" is introduced for the idxd driver. This allows the wq
> to be dedicated to the usage of a VFIO mediated device (mdev). Once the work
> queue (wq) is enabled, an uuid generated by the user can be added to the wq
> through the uuid sysfs attribute for the wq.  After the association, a mdev can
> be created using this UUID. The mdev driver code will associate the uuid and
> setup the mdev on the driver side. When the create operation is successful, the
> uuid can be passed to qemu. When the guest boots up, it should discover a DSA
> device when doing PCI discovery.

I'm feeling really skeptical that adding all this PCI config space and
MMIO BAR emulation to the kernel just to cram this into a VFIO
interface is a good idea, that kind of stuff is much safer in
userspace.

Particularly since vfio is not really needed once a driver is using
the PASID stuff. We already have general code for drivers to use to
attach a PASID to a mm_struct - and using vfio while disabling all the
DMA/iommu config really seems like an abuse.

A /dev/idxd char dev that mmaps a bar page and links it to a PASID
seems a lot simpler and saner kernel wise.

> The mdev utilizes Interrupt Message Store or IMS[3] instead of MSIX for
> interrupts for the guest. This preserves MSIX for host usages and also allows a
> significantly larger number of interrupt vectors for guest usage.

I never did get a reply to my earlier remarks on the IMS patches.

The concept of a device specific addr/data table format for MSI is not
Intel specific. This should be general code. We have a device that can
use this kind of kernel capability today.

Jason
