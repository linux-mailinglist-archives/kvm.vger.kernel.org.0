Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B133C3D8E38
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 14:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbhG1MsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 08:48:02 -0400
Received: from mail-dm3nam07on2079.outbound.protection.outlook.com ([40.107.95.79]:55968
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234256AbhG1MsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 08:48:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIc20QcAPEHNSJbyEeAHFoUrjB1iOxmw3TyylrcdtK5N3bj3Dhyua48GWFOP1JtD0pQfNAZYWp6wik5VVCY737CDW4Bp4ENHI9LeiSwTZL6nOIbsc+U7/Wvm1e0n920LlOO6HdptVmDoOXEPunVVe6Y9usVmCt/DnV91Bb26ZVsL5JrvXx28Pbhb+Ddocuagd31yjSWrGqxKpf2yuVbw1kZ8NwLZNGuxJPsujS1Tnxkq2YLp2BTUUOw3AySnrdrPZulL+uAP00OUvyPutsKvKFOwBcJHOye3BcciJq8TFRclpoehWUoDdbvWeJCS4UHxEyM/B+Nb/8iEPZs3GCvqqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZGxdoCTQavhc89tKVqZBO/P1jZwEpDBZULeKDhvtGA=;
 b=R7Y0lPiD3NJoWQSFr1/hN2sRvNfbuy4v3pjDPZ/FvwlmQTlvxYWc0rxEd2F3UBtmq3lMs8Vp0FY8M36Lgw77DMUzq+wsfdztKpqsaYWkljN2nEd9KZVE4Qs3JoHY6ZrIgqTnyE+4g1g/z3pu/IpvlIbFlR/Aovqg5epQ/WZ36S4myZgXJ3lnFzN0ufaUCixkUI1Yx0rGTApQRPnPewJ1GVjqDhWperB9cMpvEKvNGZDeeSe5JdI6ommafcjcabYiRXKNkd0iwQUd260HUfn90+37JiwhzjDAXJdBxa+xtiEgI97WEmu88J7lzUInrC9aoG8xFLl51/R4uUTqn+L8Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZGxdoCTQavhc89tKVqZBO/P1jZwEpDBZULeKDhvtGA=;
 b=Q7MSIH8fkPubSH/OASpLvS2ajJq8lWvgP43R8j7/5K8CBj/SCdGr+4WAuyEUJNIj5Xhy1VNcVDHHT/Xa66pEJDOmIgSn0gmvVntrwMsbc/gUO+JqDkZdW+s7xh0txmLN1IMJppCsTUaDsi1vihx5V5hLXMTAaadNQnq03HQcuDqGtjuDOiW8TyPxn3P+S4GGyNTGTDHt9WnoPQmM3LuOBsv+t9vwoxQDY95BZbAqnuLXkmlD6/kbb37U7sPsGKckYv055EGAfqojhLKKgt5cv1PP7ojUigSotEgK8qsGaUgenqejWcUwUMAKTv9vUggJHry+Hx3n8Z32w4W+WRApjA==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5143.namprd12.prod.outlook.com (2603:10b6:208:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Wed, 28 Jul
 2021 12:47:57 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 12:47:57 +0000
Date:   Wed, 28 Jul 2021 09:47:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <20210728124755.GR1721383@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com>
 <20210727155440.680ee22e.alex.williamson@redhat.com>
 <20210727230941.GL1721383@nvidia.com>
 <20210728054306.GA3421@lst.de>
 <20210728120326.GQ1721383@nvidia.com>
 <20210728122956.GA27111@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728122956.GA27111@lst.de>
X-ClientProxiedBy: YTBPR01CA0035.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::48) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTBPR01CA0035.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 12:47:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m8iyZ-009dU8-Pc; Wed, 28 Jul 2021 09:47:55 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3add81a1-32b9-4048-40e3-08d951c5ecd8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5143:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5143A722D283267BF5EEBFE8C2EA9@BL1PR12MB5143.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sLOLIrIYpxLuc2LNc9F4ls3GCzD9wetHC2ibmd1zM5OejbYJZZvJ7e2JgfPLZwAojQ9UOK0jlZ8rF/KMvheVp1lXed5EyCOZLNytOI/wMKHlqx1HfAdCmqsxvs94xp5SCVzvuLFZrx0qc8cUHbqLTGCwhFFqfNN02Yj0/vYnEEk1OrPcRp8PyxN61om3BHn9awR/TGEOBq0DcPT0KxlHVOmvTIlvGBVXDwQmSOkUS4mGSgvbOJfYb/sU/MNy/s+k6VTia8sLC8Ps5A/N6pnpQaD004Cev2+YZDCxzRR7h2CyE65gQoe/SRC3w/dzrmiT6Ayj+LG8t0pqbiiiHCaab7hdmBC0v9CnhJMUX0CBuank5ZcfmPwXuP9KSfEV27msI95ELFpqt7oFZWmEn2ln/a18N9JAqg+jivCqHdr3tcpodNwXN1ASl+YAzPwCnJE1gP7OiElHgzEtdMF/HLuirzDc//EM4s+t7KTg1/xk+R+l/5gXSf2tLTqCQWOdXrto0F0EfuNbuyNouxV332/8SJAmSU5DJ/Lv7K47bapnvAx3rJyL+RRv8rLxyFV6Dqi/gRhCkxuHeOV5oB0Py93PH7S1CE8mDTgWNdzsvlYYzYn0shS/bHw7nZ/V2XNfG43O9JKO8OzSioJJzgCqx6bc1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(426003)(1076003)(38100700002)(2616005)(2906002)(83380400001)(26005)(316002)(54906003)(86362001)(36756003)(4326008)(9786002)(186003)(478600001)(33656002)(6916009)(9746002)(8676002)(107886003)(66946007)(7416002)(66476007)(66556008)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QE4tTt5a/x//y7gnMqItelFuROB4ByrnoHGRU6KIdccQriLbXreLlE47JhOJ?=
 =?us-ascii?Q?0wDPbxMKDwc5cASnngPrVKkjcHcYcZZMWhCeAAsX1kPhJ49rN3vZzZ8uYk/h?=
 =?us-ascii?Q?cSrPmlLqZuBg3aKBWegmMhF/k6hgA2xCk3ytng1wsG7jea6jqlUKUz0gga9C?=
 =?us-ascii?Q?jWniV55hoVfWkMgDsSyPV05Nf30W/VdZasUIqD2Uz/HcKf8OAtrn2Mqa3uvy?=
 =?us-ascii?Q?/wQPVyaa0yXVtEmVufnBjkb/TBvNk58kBMnIG3s9A5tcqb6oJLQE0uvN/AY1?=
 =?us-ascii?Q?7+o+ff368Jm0CsZh81drH0XG2oxFlEiit7itEfTH616lkO+DUfRP0L/OEMTN?=
 =?us-ascii?Q?64pPnWxM/r9dhzo/JKdQSc+ZlZ1jNPgD9R6hXpBQNNlBfEWQGvHNlCc1CjGp?=
 =?us-ascii?Q?BCIkKcOCSmX9k/+YsoT2TAjsDpfsBLT0iGeWhD9Gt44trdTt+L3MWLIk08ft?=
 =?us-ascii?Q?o7kVweTZN6gZqkLYixBI6xQpnpcdAsmayqSlmtTKBT6trk7XjzhIRyiez1KF?=
 =?us-ascii?Q?0Fnbrs8ive3agzbw/cc4SugCIkQZ0S94oawcdNcbGy+SpSKx6YZTOietIx9w?=
 =?us-ascii?Q?PoFjcNTsor4o0BgAzYP3ssd+n/rsHhcpOusrvRog8U5xZopQ5IlceLQfoT8j?=
 =?us-ascii?Q?i5gmKIHkaLEwYtdoGc7XTB4/M2/kbRfLaHk9AEQDuwp8sQo86UOACI3eBj3v?=
 =?us-ascii?Q?SZARzE+bXzK4qI+fCK+t2zZk71+ox2boSPTwk4tiqa3NOA5B7XylqNi9mjp2?=
 =?us-ascii?Q?FD+sQi2HzdOEo5kptIVjbhWl4hzKG2TtFXrhDTyYa0ZupHA9wArJ8H7XFTrx?=
 =?us-ascii?Q?Jh1bF5/eBS3KCpVrl7VyKTj1ZqRjQcArpPb5/wVV4iMVZowj4OsR8v3SG2xf?=
 =?us-ascii?Q?lG1jqHCZ4BRDhP5sRWUha4bnJbgzVoR02inNp3p4fh0SAB2GYxXOjRz4SWY/?=
 =?us-ascii?Q?mst+UjxD9cNLgyoS16aXmsrclHAReZra+0rjcqNcxdWOa+OkerM6Bib7F2d2?=
 =?us-ascii?Q?20dDSfaDvlzouNLyXbNtLkoifrGQMW70VjTKpWMukMM5GArkZLxaR+f/YcvA?=
 =?us-ascii?Q?JXTiZUyAdFtvFQy1Z0RtZa2+3tWkh9/KOrYMMNJYcDwvc53/w+2NJA1Wu92s?=
 =?us-ascii?Q?NYP7ycIhA5uSUkoiRc52po3KJSV/bwncekt5tw+ok/AZUZyO0RHFRTaGHyc3?=
 =?us-ascii?Q?cM3RWjU67wyXdyGuwB5HEO0KPUDpWx0geayBa0qd9oYP9Qh3hUG3l2hihVc7?=
 =?us-ascii?Q?C06fJvw5Phk4Bw/+WSJKmIPQguZIKMxEQxhZI5NkpKXhKA5yay2TlqVn3sun?=
 =?us-ascii?Q?WXY09UxUedd0F4l9OsNli2wJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3add81a1-32b9-4048-40e3-08d951c5ecd8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 12:47:57.6236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVROk3xgRIHi2sDJ1c/xDk7lalpl2mz8UZV9NuVRuvfgjXsiIK5k8PSY5yLul73T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5143
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 02:29:56PM +0200, Christoph Hellwig wrote:

> So not really an issue here.  VFIO_PCI_CORE really is underlying
> infrastructure a user should not care about.

So then we can write it like below? Unfortunately it deletes the nice
menu structure that groups all the PCI drivers together like platform
(and mdev in future). Not sure this loss is worth the backwards compat

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 318116d03c21a4..2611d7d91ddbd5 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,14 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0-only
+if PCI || MMU
 config VFIO_PCI_CORE
-	tristate "VFIO support for PCI devices"
-	depends on PCI
-	depends on MMU
+	tristate
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
 	help
 	  Support for using PCI devices with VFIO.
 
-if VFIO_PCI_CORE
 config VFIO_PCI_MMAP
 	def_bool y if !S390
 
@@ -17,6 +15,7 @@ config VFIO_PCI_INTX
 
 config VFIO_PCI
 	tristate "Generic VFIO support for any PCI device"
+	select VFIO_PCI_CORE
 	help
 	  Support for the generic PCI VFIO bus driver which can connect any
 	  PCI device to the VFIO framework.
@@ -50,6 +49,7 @@ endif
 config MLX5_VFIO_PCI
 	tristate "VFIO support for MLX5 PCI devices"
 	depends on MLX5_CORE
+	select VFIO_PCI_CORE
 	help
 	  This provides a PCI support for MLX5 devices using the VFIO
 	  framework. The device specific driver supports suspend/resume
