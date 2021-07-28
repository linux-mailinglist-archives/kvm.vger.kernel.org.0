Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31853D944A
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 19:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhG1R0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 13:26:45 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:4257
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229537AbhG1R0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 13:26:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCvfZtscXcH2ezyVyFbEW+lx5scr6OzesMlmCTa3m/QLUS3m+3Lbzo66UYRzvn0r3GTTuyKsP77Q3HPeCXwnhT/6nZU1o6cSJJT3DPpAotlMwHFIhmMoaX8wj4kYdnab6iH+mJZM8SDk/uDaqtn0zRX2MzryK6Z6dUjNJizld+zcu1BpPKd0OD0SzprOJClLiAHhCp/eorPOKO8xGuy88cyjhX83R7XaOQBKw2ba90SHoo/8AD0Y2DVZ1JgbGFGEsCVjxlk2mFtIghb2p66ZNq6X/qlN3Fu5AAAcfi0UfEwZ8JBRQVoZtYi+6hYgJ/ba1MktbQSdh3O2u01V2QFhCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nUFOQQBzRUmvGKWGBwjeaGuoU2Q6Y4pzBGisPq4o/pA=;
 b=nyROIgHPRtbBzfPOKC760U+nWosolAt00xdGQwLDRbuBiXw7dJGtOgUahetkV5O5I9zS1TuyNyWQfV9+EdSNzvqs6x6kZSayER6Zh0OmIGcfP0sSNT7raxVsbwzl4HA9mlsJboQMOa60XaAn5R4gV58dU4ICQ+hhfkTT1zQrLHuVY6Q3mStaiCYMkMCPIiqcuT06Pm21K0RZzcHL11W589CZpdmSm2dcnS6lOVoaOTEIjgVyxRPTklPzk07ho9To8lNUH8ajmueDKi9/J/TdneDuFojtBqfDNUX2IgZ2kk16gOusrJxRD2bViyjPORUD7z3oAbLMuD4O964W8CJMoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nUFOQQBzRUmvGKWGBwjeaGuoU2Q6Y4pzBGisPq4o/pA=;
 b=i9h7LXdYL6m5lx6HbYgYqlrSDYM3KaTPQokTg/XCYkRP0dnfnd1UkiYPEg3U3wwZqq1fwNkZAOb6wHouTRpvd2jkGlE15/nh8fzITZ3UNk+0BrWaB4IGysy1xsV+DrErWYGaVJtu1Owy0OkwdgIJHf2NmsTO9Z6EXyiV4BhiWHnXiqCnXYSxvmTmMgY4yBs4ylYkd1KRB+CiS4CqwsVCt0JI1A2cSK0ea9+bya6FtpcTttry0sV3vQpcbuo7biAEqDbJ7iPuYdSsrnnglTqoEXs5nqRqKhkNKOvYXxW9f46XTLOmnAIfIuZ6emCE2E/MQR945oDwiXF4u7ngQSMmQA==
Authentication-Results: arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5270.namprd12.prod.outlook.com (2603:10b6:208:31e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Wed, 28 Jul
 2021 17:26:40 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 17:26:40 +0000
Date:   Wed, 28 Jul 2021 14:26:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, diana.craciun@oss.nxp.com,
        kwankhede@nvidia.com, Eric Auger <eric.auger@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-pci <linux-pci@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <20210728172637.GT1721383@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com>
 <20210727155440.680ee22e.alex.williamson@redhat.com>
 <20210727230941.GL1721383@nvidia.com>
 <20210728054306.GA3421@lst.de>
 <20210728120326.GQ1721383@nvidia.com>
 <20210728122956.GA27111@lst.de>
 <20210728124755.GR1721383@nvidia.com>
 <CAK8P3a21ah=+x29jycWZBoTGA1RzfYz4qar9usvCa_hU85k=7g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a21ah=+x29jycWZBoTGA1RzfYz4qar9usvCa_hU85k=7g@mail.gmail.com>
X-ClientProxiedBy: YT1PR01CA0130.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::9) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0130.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Wed, 28 Jul 2021 17:26:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m8nKH-009iyn-VE; Wed, 28 Jul 2021 14:26:37 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09cf0864-57ca-4131-a3ed-08d951ecdc25
X-MS-TrafficTypeDiagnostic: BL1PR12MB5270:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5270AE89680A240722A5014AC2EA9@BL1PR12MB5270.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /1FaHFg1A+dQ4Vd4mcHuvZhB/6GZDOXFsp3+NqfexaOFhF28TEiEKhoP55kRw2sTfURb4oNb1BfmlIQGCGVthqexnYbOxzjOwlwQBOCUlsdHRihbhCa1+EewhAr3DNEpzOt7klBsKUMC42TPvHg2JkQ42Yo7PYgRyLXoVCsWPBJrFeMbSs/iYX4Ke20MD0IIJ98acHGGCU+1ZtgyKi+isM5i/16CreBPiHiwVzqHCy7bjENKgVXwS4j+7dpT6EiFuwD8H+afWbIUZblF5EYAeV3QYdCF/BVwEGnwDVUiyNOxvIx8WPThkQTELS/iqWAFcQk1cb4ws3JhwrWSYvu2cvGSD8hgXwjU00/E06zDAvuP7v0u40po6s6xZumsXU/pAhbWeUdz8V5I5BKU4/oslgnoUhWMlKM9bRORSXHv1Rp4ldnNfRzwtfTPtjrOiYqi8UuPY6RiuX1VHSyQO8390yLXYzRKLmv3nScV2qnCOIENlbQtaI5kKzk2I4xQ7XKXPChzNTrLMBUa7cI/MF7lCVZgr6F6ZAo/kx7zwyzw9E3AT1aXScj5Qc2E9FuN19Fnb6rKty4sRvqEAL5fk0fqg6uPToX8Tv/P4k1RagrrlV1V8EhANQvc66mzrc3lmeMIBFYShH3Xj0+aGntm3ofeaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(66476007)(66946007)(8936002)(8676002)(9786002)(36756003)(5660300002)(186003)(316002)(26005)(86362001)(83380400001)(4326008)(107886003)(9746002)(33656002)(66556008)(2906002)(54906003)(6916009)(478600001)(38100700002)(426003)(2616005)(1076003)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K/7UYEms//fvlaD6Pili/pstKU8lRNXmgzb6jdTUhUWezd67ApMjPAFESLgh?=
 =?us-ascii?Q?OhQLlSREiO1HE+hPUT+vg9NNFzru65RWI/adVNqwr/UvSz+BY9o4nyPxqgqV?=
 =?us-ascii?Q?Nl0oEOaqWc5NYOvHDQPMc3NPQauMrJB8EfWKM/NY5teyviL0GxGrhP0h0VqX?=
 =?us-ascii?Q?wPXmaapf6diVgkJPH10eX9YQXc+70HuiK7sT/dy0MT07LgnxseRq9Gn2/lbk?=
 =?us-ascii?Q?jG5OvgZSZwOKteCEZzeb2pxXsYxJuKntPMxagHeG9i0HfzgfV+XLLBfPFKw4?=
 =?us-ascii?Q?dnuB9lhNevjp2a+lk+4cowDz1OHHiDHvy3OlpWESBk+WjupXuY18dNTK30hi?=
 =?us-ascii?Q?wqS0ZW75q8I79ABHY1Lvd/8TXRCVQhNY5hS7W9NbGoHXHxznzQzNsqwT5jqC?=
 =?us-ascii?Q?HTbFzLoTv44LL2WQZPw+1iN+IUZknOTtagZBRjDPZWuFTb2uTK6SxD+cp4Iv?=
 =?us-ascii?Q?sypbtU1P8p1PfuqE7FnmjyDVbEqCAtx2TRiMIgB0Uu0720BK6HNLiCyFqrvq?=
 =?us-ascii?Q?sgVhbT5948Ll0eRhluLhOVroR51edyZze8RZmdvKiWh2/QSazJr6w8A/uTww?=
 =?us-ascii?Q?dPg3yVkkNZDvY5En44qGVorrpi80MlrducFQrIf/3QlXxWOhw1G2zFcgxLxc?=
 =?us-ascii?Q?QaAlizs6xlsbDVVw9DApoNAjlNc1r9grfLP2y+NKYP57P1hABm8kCpSDomx7?=
 =?us-ascii?Q?LyM48a9CnVdD/Qp6XH9NTh4LOGjl0zz/w6uCHO9bup2zqaX54T18U4doXE4V?=
 =?us-ascii?Q?48q8dVK7RViK+ohvZBXSn3pyXbcglB4o6nS/gTna7zkUjUx16vGKL+Skmawz?=
 =?us-ascii?Q?cUlzktG8zlmDrRnZosB5MYZ+PixP3xMfbMI2Ax8ZeyJluIsmXbKwjLxreKrD?=
 =?us-ascii?Q?3jdYYzqrRY/hFElPy8cbqBh1PRuTJLlfOmOrH8yCREzxgA/19gOpuP5fWfUs?=
 =?us-ascii?Q?kDrO7k9ZtTB/vFxypzUX4zdRrhA9RgPTkv6EjjKvsAjXMuYe+bUFeYUX62sI?=
 =?us-ascii?Q?gQvp0a3pMqT7cIffonKlCw3QPDMKUEb7K6nuBucOK7F4uEtMbmPiJ8W/gQZu?=
 =?us-ascii?Q?Py4zgDDYkx8CqHROL0QKRho03tWiOqOGN+afZZ5BPp0iT8PkOZNxiskFPqZm?=
 =?us-ascii?Q?sTyUuf22xZOb1+A12277efr1eGiGqlfHCiLpW7v3GU2nnzK+6ETDUqw2xGqk?=
 =?us-ascii?Q?EZxhbYtlhrajjAofqxVpVNZd4ntnBQ/DEDktuu3ensQBQR1ZRM4il7/wOVbn?=
 =?us-ascii?Q?G8wDCS2wjZvBs6WLcvHYXtdt3xk8BKLGI8FvwVmXRaen2/JZsmKxok/KBK00?=
 =?us-ascii?Q?tjnteatW8Xs+ViLwQr2c2YOE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09cf0864-57ca-4131-a3ed-08d951ecdc25
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 17:26:39.9601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEs+O5SjbCW3OvW2mltPLqtjUenQIvqEBnZEvGUdpC3FOHK6+naMjDRL2EoGfmdp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5270
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 03:08:08PM +0200, Arnd Bergmann wrote:

> > @@ -17,6 +15,7 @@ config VFIO_PCI_INTX
> >
> >  config VFIO_PCI
> >         tristate "Generic VFIO support for any PCI device"
> > +       select VFIO_PCI_CORE
> >         help
> >           Support for the generic PCI VFIO bus driver which can connect any
> >           PCI device to the VFIO framework.
> > @@ -50,6 +49,7 @@ endif
> >  config MLX5_VFIO_PCI
> >         tristate "VFIO support for MLX5 PCI devices"
> >         depends on MLX5_CORE
> > +       select VFIO_PCI_CORE
> >         help
>
> These two now have to get a 'depends on MMU' if they don't already inherit
> that from elsewhere.

Just so I understand this remark properly, I added this at the top of
the file:

if PCI && MMU

And when I check CONFIG_MLX5_VFIO_PCI I see:

 Defined at drivers/vfio/pci/Kconfig:51
   Prompt: VFIO support for MLX5 PCI devices
   Depends on: VFIO [=y] && PCI [=y] && MMU [=y] && MLX5_CORE [=y]

So this is doing what you mean, right?

I've attached the whole thing below just for clarity

Thanks,
Jason

# SPDX-License-Identifier: GPL-2.0-only
if PCI && MMU
config VFIO_PCI_CORE
	tristate
	select VFIO_VIRQFD
	select IRQ_BYPASS_MANAGER
	help
	  Support for using PCI devices with VFIO.

config VFIO_PCI_MMAP
	def_bool y if !S390

config VFIO_PCI_INTX
	def_bool y if !S390

menu "VFIO PCI Drivers"

config VFIO_PCI
	tristate "Generic VFIO support for any PCI device"
	select VFIO_PCI_CORE
	help
	  Support for the generic PCI VFIO bus driver which can connect any
	  PCI device to the VFIO framework.

	  If you don't know what to do here, say N.

if VFIO_PCI
config VFIO_PCI_VGA
	bool "Generic VFIO PCI support for VGA devices"
	depends on X86 && VGA_ARB
	help
	  Support for VGA extension to VFIO PCI.  This exposes an additional
	  region on VGA devices for accessing legacy VGA addresses used by
	  BIOS and generic video drivers.

	  If you don't know what to do here, say N.

config VFIO_PCI_IGD
	bool "Generic VFIO PCI extensions for Intel graphics (GVT-d)"
	depends on X86
	default y
	help
	  Support for Intel IGD specific extensions to enable direct
	  assignment to virtual machines.  This includes exposing an IGD
	  specific firmware table and read-only copies of the host bridge
	  and LPC bridge config space.

	  To enable Intel IGD assignment through vfio-pci, say Y.
endif

config MLX5_VFIO_PCI
	tristate "VFIO support for MLX5 PCI devices"
	depends on MLX5_CORE
	select VFIO_PCI_CORE
	help
	  This provides a PCI support for MLX5 devices using the VFIO
	  framework. The device specific driver supports suspend/resume
	  of the MLX5 device.

	  If you don't know what to do here, say N.
endmenu
endif
