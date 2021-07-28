Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468CB3D8F18
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 15:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbhG1Nbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 09:31:47 -0400
Received: from mail-bn7nam10on2066.outbound.protection.outlook.com ([40.107.92.66]:43361
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233315AbhG1Nbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 09:31:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQPHpYH3EHoobqq4cqjavnnTubrLCmrIZ0JITDbyhwqm+eDCJ525tPBIp/d9+f8B6LsVNptYXfuIMa/ars9IrjTQR3Ol1P7stIFEh4zEIQFFkkfD1ZSqiiHPmeCUEQCQkvk5N2zsnE3/0QPM1CG4QRqBU67z3f4frS/I9DGvDmRuaAqXp8rogV5lPc0R+oO8LZGyPIsUf1xuLvzcYWlk7TfI6u2QfalChpMlj6KBklr4+Gu52YO4+BYieNa/UZ+NEJEmYpvlqun7UT01Fpc6Wogefozd3znAm1kMmT7ROx1LWc5zWhBTqxAqJ238aeYr6VWK7X2sOBqtw+xyKtiWCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjGNtq3BAaWY0g0TEuq8e52MICybMDO8xlt9ly/MLm0=;
 b=XtFqYrdEWQC8fc3Xw46KV9JFX3lAM6pcnPoo4CEwlD3BGBXNZc+lBQi4ckEa1AEXCNysuySAptLdk+PnHNja9B6AZYQeSkywj5yKLIclq7Ehig+1NRSyyH3eimLWOJFrVSHKCarD4XZdrbXEJarEDZFQnSUT66v4Henbng8kggODR2KS+6pRVP7j35/vqhgKQ2sQHmbxsJGxC+sBGIEweTihuUmqW98lwc1usHK3zgV3JeoUvsLDSTKYdySqIxyMB1Q74k0dkc/u7fDPhfVT8cyOxEwkCGpas0sUGT2x0KjEMFDEviWjiP2OgHUzYT4ABBzeKVFXqY/m3mG9NBt32A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjGNtq3BAaWY0g0TEuq8e52MICybMDO8xlt9ly/MLm0=;
 b=aS7hSE9+xNtie01sKKhhPTFNNm2lWmhPQdi5VM2EZBbCjNUUusPRkTeDIyMFMZDsfp6BSOuMUHz1mZKbhK2vxm92gCIQdGzl4HfoCoeDle/Po+qxueQLt62juSM6eQhxtTp+MNoV78GSM6kTkHIvnUvqRqj/9xwd/AzQ2t38UyFqfhTfLvSdnI54zYqU4OpdppBmIkC5N8AnXVqNGw2J9pjWvHQBY4BadnqfHK3ck1f0a82qlF/fQBZf8k7gPEjB6zDPY8RerFoVqhpgcjXrV+qpntlN2oUQIydtuGrPwTtGnFv7gIabYtqDqgC0UJVm6micn3ZEvD4kgSQIlo3jXg==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5029.namprd12.prod.outlook.com (2603:10b6:208:310::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Wed, 28 Jul
 2021 13:31:42 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 13:31:42 +0000
Date:   Wed, 28 Jul 2021 10:31:38 -0300
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
Message-ID: <20210728133138.GS1721383@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com>
 <20210727155440.680ee22e.alex.williamson@redhat.com>
 <20210727230941.GL1721383@nvidia.com>
 <20210728054306.GA3421@lst.de>
 <20210728120326.GQ1721383@nvidia.com>
 <20210728122956.GA27111@lst.de>
 <20210728124755.GR1721383@nvidia.com>
 <20210728125505.GA29082@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728125505.GA29082@lst.de>
X-ClientProxiedBy: YTXPR0101CA0017.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTXPR0101CA0017.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 13:31:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m8jes-009fIr-Sh; Wed, 28 Jul 2021 10:31:38 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1aa09d8a-0165-4999-c863-08d951cc094e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5029:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5029305FE303136C2B202842C2EA9@BL1PR12MB5029.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GB/UccBMnQyZjJXVQGUb06zyFiWd1r2iiLeWsbWOtKC9L61o9a5hsYRjJq2PYSVQx0UbfDMsNlALq48ZXvPO+yH66bdoUQ4lzxG9UCV77CDjlVWa2MLbn46xEfA5c53YGjZY0FhK0o0xl6cWQRHm8YdCdIODVqRnZ5gf66l10PFA7BNFqp6xDO4v2oPf1fODkimIIsySAfANUlkQQ9/xYpgdM2mOCUqbuiX8vIhqsX0JVeck+9i5SHgAtvN5AyNkrb7ZPX3EZolQp5DGXBy/H2mw69BlU9uCLMnj23itzoZsxHPPmDLIa/fro2akCU9VdQ6IPDKYMdOGh2k+zWSVczN8hJEcIk5xkh4f/w/X8FEi8g+/iIjoirdrNQyNbT4KssBsA3nS2Czxy2CE7ThUIkDHwnFleg4/DDTofi1YCjF4tv9tOycIYUSBwVzUYM2rQWI8j3EjT5YF42r00Cvbg1P9+jblByqZICtiCeq1ZouFo4hOXkrF+Cn2egxZNJZrba7aYn91jVO9m+vbcZQ6YyorgFNdvzSAcYi6jMfJDfTi4hijqMR8WXoAeDaKwSsKG5XlR8NGHs5niqWoAv1f5XUio3E+97fs52+jPXXO7V3Q54XgDCTKyo9oBMIX3NJMnIDacdQPNI9jl2oW/Cjylw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(86362001)(426003)(36756003)(9746002)(66946007)(66556008)(9786002)(66476007)(2616005)(7416002)(8936002)(316002)(1076003)(26005)(54906003)(8676002)(83380400001)(107886003)(5660300002)(6916009)(508600001)(186003)(4326008)(2906002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UDHn9QS0KqMGwvPrvEXkAjyBRkEaoEVQCQpTE/BAa8nk7ZeMd4rbkvITiLuk?=
 =?us-ascii?Q?16nX0S4KeHr9FaZWbo8nZ9buhDhtLOWi0FVzVs7ykhZ+07oMYZtwjf1jtS57?=
 =?us-ascii?Q?38vNWJ2kZzWl4ZsHmd5X7ZV6Ku1HXDXi5LArkl7KWQwDHkZNpPULNOidXZez?=
 =?us-ascii?Q?C0HE4jMOjK4fDJWIlG22iFq98mlJxshdw2i6eUBvDjwNKSkNymwZ6VIBf5tt?=
 =?us-ascii?Q?ZPYKuVGoxYOusMxZ83JGdAOlbWOTo862+jByJPY/6QBQyRkA6PIkQWvBwiRz?=
 =?us-ascii?Q?fF+us4ItqvfJeEqlbMuLjXSh7AFS3v9XCys6Enfjo2WdjrJ8Bwkgat6ep3hX?=
 =?us-ascii?Q?qfHt5VBoL/nCVR3SkfRPpHT5JGAJ4MNJryuwTTP0qCZyieICCA9/+ayzfGJu?=
 =?us-ascii?Q?8x0SjqUv1QQy0TyDG5SPgyOOSFeB7tvR+L6G+fGuZ3LI0J/sicMO760siOlL?=
 =?us-ascii?Q?aiVyQaYNzAClALJpjMsujtCgjLWa71cSkaczTFNHKzrNay0RJB4GNakrlWBW?=
 =?us-ascii?Q?MLLTZDDCEkHBz1lMS2N50v0ZYEelUPssUncoVHmVXuci2xbBSe2D0qgjpfKG?=
 =?us-ascii?Q?1+CWQhwnFlSCzUi9v1emjeYQu53tnafYmROR+gwF/bzHNr4/5p9V7d2GEoY3?=
 =?us-ascii?Q?3bIOdSix/GJTKj1jBDIBMpBzoJE81fxrXGHIojNiFCZtMX3C9ayXyqCHTnYO?=
 =?us-ascii?Q?5uMBRrpvPFeOGECvsaxWxqDY+Spb7jL8Tx9I7bUmmwuhP06DYZa4ngZeUtlt?=
 =?us-ascii?Q?rrhdH38p2fV9ro3B/xxwWwzNNLk3AqsCQNE3qHkjxFVxQ/H3dmz+Cc7Mwr+b?=
 =?us-ascii?Q?oN1uMbL4k9LNnf2DaV2BpPthyw4zgdfVe3LmFW+rUV3mfBFUBKPLQ0ZsCBwb?=
 =?us-ascii?Q?RTg6PrFIzD5h9ROTw5IAWukqDM1Q4Djhlr2ETJX5dMkoDJEjWwRm4vN+McEx?=
 =?us-ascii?Q?Nin5sVLVFxUq9m4i4wKIU1EY5JQ5CNrGG6ZfTmkl3CmhS7ddi2o/89V13VGp?=
 =?us-ascii?Q?k9KwkqORqI6wGAIqM2SV8knV6YBqnGuFQGeoTKg0MZb4VOhBfkJcmjGMtvZ9?=
 =?us-ascii?Q?wCCSiFz+o9jhExS75zk3bFj7+VeOg0V+AJLWVUmz0boJfxWy1qX63Q6nBCGr?=
 =?us-ascii?Q?2RTwbYNoP4kWpAKgnGFyPhsgZXumz+S58MSN549wj7IFucIHfypMCa5TTdqT?=
 =?us-ascii?Q?wvnzrB6sKCIF2EvqwjR48S4wobMX/Ak5VmANhX0+Z8eUg0+U7fcw2rV/hJXx?=
 =?us-ascii?Q?a6aYM2IhFfoPhRMZEvMPyDZu750LY8xNP8czJOG2jT0mE2OZ1c2Yby/607uE?=
 =?us-ascii?Q?bhOZPtC2/SWJBFEJNKZbzx6m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa09d8a-0165-4999-c863-08d951cc094e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 13:31:42.4207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6gzgKODcKH+yKP4z5+6NBZs4wOg069Zv6DLFywyAbrQpQknQ4+RH+rIyo5Hqg12a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5029
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 02:55:05PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 28, 2021 at 09:47:55AM -0300, Jason Gunthorpe wrote:
> > So then we can write it like below?
>
> > +if PCI || MMU
>
> The || here should be &&.  But otherwise, yes.

Woops, thanks

> > Unfortunately it deletes the nice
> > menu structure that groups all the PCI drivers together like platform
> > (and mdev in future). Not sure this loss is worth the backwards compat
>
> All the ther visible options should depend on VFIO_PCI not VFIO_PCI_CORE.
> So we can still keep the same menu struture.

It is the upcoming VFIO PCI drivers I'm looking at, eg the
MLX5_VFIO_PCI

It goes from this:

  --- VFIO Non-Privileged userspace driver framework
  [*]   VFIO No-IOMMU support
  <*>   VFIO support for PCI devices
  <*>     Generic VFIO support for any PCI device
  [*]       Generic VFIO PCI support for VGA devices
  [*]       Generic VFIO PCI extensions for Intel graphics (GVT-d)
  <*>     VFIO support for MLX5 PCI devices (NEW)
  <*>   VFIO support for platform devices
  <*>     VFIO support for AMBA devices
  <*>     VFIO support for calxeda xgmac reset
  <*>     VFIO support for AMD XGBE reset
  <*>     VFIO support for Broadcom FlexRM reset
  <*>   Mediated device driver framework
  <*>   VFIO support for QorIQ DPAA2 fsl-mc bus devices

To this:

  --- VFIO Non-Privileged userspace driver framework
  [*]   VFIO No-IOMMU support
  <*>   Generic VFIO support for any PCI device
  [*]     Generic VFIO PCI support for VGA devices
  [*]     Generic VFIO PCI extensions for Intel graphics (GVT-d)
  < >   VFIO support for MLX5 PCI devices (NEW)
  <*>   VFIO support for platform devices
  <*>     VFIO support for AMBA devices
  <*>     VFIO support for calxeda xgmac reset
  <*>     VFIO support for AMD XGBE reset
  <*>     VFIO support for Broadcom FlexRM reset
  <*>   Mediated device driver framework
  <*>   VFIO support for QorIQ DPAA2 fsl-mc bus devices

Look at how "VFIO support for MLX5 PCI devices" has changed its
position.

Arnd's suggstion to add a menu seems OK, it gives another screen in
kconfig but it does group them.

My preference is the first version because it is simplest. Adding menu
seems like something to do if we get > 5 more drivers. Just hiding it
preserves back compat but hurts the UI.

Honestly, I don't care very much, if Alex values kconfig backcompat
higher than the UI then lets use the diff in my last email.

Jason
