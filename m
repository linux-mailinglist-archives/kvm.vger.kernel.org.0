Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E8F42D2FC
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 08:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhJNGzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 02:55:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:55956 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhJNGzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 02:55:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="227571021"
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="227571021"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 23:53:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="571136520"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 13 Oct 2021 23:53:08 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 23:53:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 13 Oct 2021 23:53:06 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 13 Oct 2021 23:53:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaHDvFWs1ycLgptUG/KDf3fUyHVUSsttJCDRyTAh18qNoB6F29wtRSoPKCELNdmktnvblIu2rPjd8fT5FDFDR0KxjWQdoPko4n1V6M2tQ+pnA/dqrdRhod604lftoJsyyldx2W8lDkikY1mNJcFWIx5Qps4Y4Q4o/0Ahj+RuKWT3oFaO3rlfVS7H/4VFKpuOgo0lJfvZw1LxcZk5CY88htjnaVXd+UGFsRebxNcatW2JbgZEnlffE4Pj6K0+X4w49Oi639KsRn1HtaAuh2XvuHvrFg+oMJHJnuiBnq1miEgfF3d9cbTehesFCPQ+ZkR/kDAByw1a+0cFs1REz5K4bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40vVPmHqz3Hx73otkRxZ2jmkz86zR/QKosYy0qr92Hg=;
 b=SJbPvVB7A4Ld9OGzUJbkYqOOaeaIhMUduAbF1eiOxbHs8Rnqpzk/9lnG4bVFj0J3haMlMfvyqOAIqGn9DyhwmVMae4esgy5M8SrQk2ZOxj3ThUTNXCTtrIEmN5WZsp79kR1s7FjsVG977mn+NmAA8ubCsHUniRHOk8JOILeVkmbkqIzwgzDHk0dhnGZtOyTHpbvIyJlvYQHKvPjHE5ILLAovjKp6G/t0fWCFpFP7ufl+jLjjVH5sy79QiNHiNvVKQA6zLCpMDTIJFnhagGMluyv0LOAcrr5nrxm3c2Ngj068T5DstNU1WZclK8aEwGdAF2S8Tqi9GRWG8ARp4WtaFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40vVPmHqz3Hx73otkRxZ2jmkz86zR/QKosYy0qr92Hg=;
 b=dbLEoxPrDcsXug/1NB2t2ctgfjkKXmUHZhcpbjZbBUTyq64kXEgXlGDdZ1zSoV9Qenq/7rwWipdxUkkBhxky+2eVJ8ntO4rpEgz2NzWMBwD8KmtwVHvY3QDIxBVlwtwgs8XhRkbhdZlq9XO6fOeRA8OF40TaHbn5ox/eN/w7AMM=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Thu, 14 Oct
 2021 06:53:01 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 06:53:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Topic: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Index: AQHXrSGPLoYXtOF3o0iA7Cse+/LM66u9vAMAgBLi5DCAAXeHgIAAGqnw
Date:   Thu, 14 Oct 2021 06:53:01 +0000
Message-ID: <BN9PR11MB54331C7936675EEE27C209948CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com> <YVamgnMzuv3TCQiX@yekko>
 <BN9PR11MB5433E3BE7550BBF176636F8A8CB79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YWe5U0fL3t+ldXC2@yekko>
In-Reply-To: <YWe5U0fL3t+ldXC2@yekko>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73da7979-66f4-4785-1421-08d98edf4393
x-ms-traffictypediagnostic: BN8PR11MB3762:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB37622CEDB9DC2EAF7229E0DE8CB89@BN8PR11MB3762.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: edQZyzX2ryBHkEKIXKPvb058jCg6MoqzLuoZSzJB8JGSK73ujVrx6K6AfrCCdJnaDuJNEnXzqOITA2MCYnl+BnSy3Dz0nD8R5U+OaBTOfb6lbKQyk9dbNUIDgsBe0y5Yvn9mjH/X7ZcW64ZP40oWisC9hCxSlVE79ctkWTxvmDH2M7E4qj3iHGWgWgTB/bmMg870lFYQWCfEi1U5jIQOwalsbmwfoyEqXkOnDYBB/DzOT8EEGEN+UZXJJnSvGz3g3SUt7bSHlNz+Uk3K9JCg/HG/yK8xaWS139aMvTy4Vk2az5zT2pX9hXDhMD5/0SlBERtDrDwkWz6qcZnwdlrwDkgT/G+sJT+MLyY8kLz1thHYIO2DnM7HZkyTnvlbm9/v/vbRUPCnzhJM6tA+xpYXSrtdDR6iJFN/m9z5QRIh5/8v23lRPua5Oy0Gxk2k2lRMC0PJyoMmecQcAiBwW8o/PR654AHvWLJpgjrG3VRk98glVmK0ZM5H/lcTfMUAB9GpG92Br4vDpJgD/70jAXqWSWGBIzqdblVH8+CEsAiIaMDZjVGw2j7EWC77WdYCj3FMn5WKFzzpboNtsF4vaRhhDTwC1BrGA4wkrVJe7Iz3N6vPfQr3h8CrvFdisHt5y/GSdmOUdJqxhOeup28vUDaeoPnqfICGBzqF88ySk9h/GkG8LRH4l5epARdHc0htSsJpjg2Y5Ix3GLMk/6HkxSkypIv5qQ1kVlD2dSwNXiGkIPA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(84040400005)(8676002)(66556008)(66476007)(5660300002)(66446008)(7696005)(6506007)(8936002)(4326008)(71200400001)(54906003)(30864003)(316002)(86362001)(66946007)(122000001)(64756008)(76116006)(38100700002)(7416002)(55016002)(83380400001)(52536014)(38070700005)(26005)(9686003)(6916009)(508600001)(33656002)(186003)(82960400001)(2906002)(84603001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N5Y6W7gEOAwns7LnXlmYPy/pcDaKQS+Tv90wlG4TEV2nwD33esoqz5x4DHoe?=
 =?us-ascii?Q?T8dvGpDYD7Lyp9WbAORScdwxGDeMzj5sXZl8E2vD5yRS+/OLFKRS2pR9y7WN?=
 =?us-ascii?Q?sCkW39MX2XZv88ArVlN2IoZYiBAGMyK2UO4U2DooTeZWuo3OQ+ev50qRvQmq?=
 =?us-ascii?Q?g2sAyJ0s0Gg8U+RpKG9mOap2RvkPqmcpKlIYh6J/tOhaprs3gYjvJtcV2rEA?=
 =?us-ascii?Q?1wVtSq+qxqAjlOReCNVwqwIVk1XKzB5te8nZ0ALyIyn5kZGXN09pCJyx3g1x?=
 =?us-ascii?Q?b75H2NDYtL2f/wMzhEIS9DgaJanSBAJOCzgK5J2HumEEdce5e4nRwvTPZVpW?=
 =?us-ascii?Q?YBp20v5mnZWySg/S/GshjYsbd/2Anztsb/XunPgthP/Ctnqn9/wO7PGYv2RO?=
 =?us-ascii?Q?hTtCWSHpSdPZDMCnWNY1604eMZIdKxDeBDIVUnu+CeIBl9rKxxeC1NwDzh53?=
 =?us-ascii?Q?4dNs3kz8rtYHO1UwseKulgUqckG0OV/834rRRF5YjuAILJLBJGt4B70qPLXJ?=
 =?us-ascii?Q?UVc9VaeIrXoU6DghA1K8oTswlZOw7k2ubLtfEsGti+TQgLAlNsolVBpn1C10?=
 =?us-ascii?Q?zq3pXJjTbOlB4X5Sv0O0D7rZTYkGlgrkikIrdk8UwKr6nMtM0ls5ISqWxEVG?=
 =?us-ascii?Q?Kr4WySsYXFwUD0PZsdoZ8on9I59snCyy7HJgb7m5aK53FLNb3Wol62rVNTaq?=
 =?us-ascii?Q?G3uxQxD1V7Kw5XHCWEggPE7oa4hnjzxQ5knJAeZva2H9DdZ0fFJF8VE89t6g?=
 =?us-ascii?Q?PRu7XnxemUa6KapNDA8nvdmi4hrIWDBE9pylj810TBSByzpeLcJVVW1M7Rxt?=
 =?us-ascii?Q?/rsrxNbgVttOGBNT6gHoj5yjayRWEej3LoqzmULuyxwLZZPRpw8Em8uZpbqW?=
 =?us-ascii?Q?eURZ85IClkKd3sjM8IegsYE7+EdIXgPyBKseLT+5Fb5QxzuDeNMDM/VfqWW7?=
 =?us-ascii?Q?3kKVJXZMrRbxrUPT8fioOCmW+FuzK/HZ7Oh/pWMGU/qvKYWjCF5f6/Kaxv/F?=
 =?us-ascii?Q?fTaGsQF66rcuZVVdHf3nvQpH2DVaG+1OriW/j+REkgCMZe31AiAoWjuCd0/9?=
 =?us-ascii?Q?y77A1JlQp4rE5A8Pr8s4efP0osCtj8EDaKCUrSj/d5/G358vKHymYhnWBnKi?=
 =?us-ascii?Q?Zuo8AfAar8eG5W4o6nRvmRRHjCsO+9g8kCMLrHBumTlRnDeEMcB2tHYO9rAv?=
 =?us-ascii?Q?ZNT+S5iTLHydgFiozhQptcIUNy7fe+B6GwbBhSpwD24ET4ngwQGTJPsCJGD1?=
 =?us-ascii?Q?UHuuaWBlmXPsHRlZhcMxEW0Fx6aHIuyHmzx9H3lF6260mObCZmkY6J2Pnv5X?=
 =?us-ascii?Q?0Or7KJaGM7a29rhlOoXddrUI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73da7979-66f4-4785-1421-08d98edf4393
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 06:53:01.0327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zoqfuL1ELekaS/bIhnhMbdDDcUs823SvoYoPd/oczsG87e8/OxgDOvFG9n/DN6/SMX6jSL78TzNRkkM4zCGbhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3762
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson <david@gibson.dropbear.id.au>
> Sent: Thursday, October 14, 2021 1:00 PM
>=20
> On Wed, Oct 13, 2021 at 07:00:58AM +0000, Tian, Kevin wrote:
> > > From: David Gibson
> > > Sent: Friday, October 1, 2021 2:11 PM
> > >
> > > On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > > > This patch adds IOASID allocation/free interface per iommufd. When
> > > > allocating an IOASID, userspace is expected to specify the type and
> > > > format information for the target I/O page table.
> > > >
> > > > This RFC supports only one type
> (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> > > > implying a kernel-managed I/O page table with vfio type1v2 mapping
> > > > semantics. For this type the user should specify the addr_width of
> > > > the I/O address space and whether the I/O page table is created in
> > > > an iommu enfore_snoop format. enforce_snoop must be true at this
> point,
> > > > as the false setting requires additional contract with KVM on handl=
ing
> > > > WBINVD emulation, which can be added later.
> > > >
> > > > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next
> patch)
> > > > for what formats can be specified when allocating an IOASID.
> > > >
> > > > Open:
> > > > - Devices on PPC platform currently use a different iommu driver in=
 vfio.
> > > >   Per previous discussion they can also use vfio type1v2 as long as=
 there
> > > >   is a way to claim a specific iova range from a system-wide addres=
s
> space.
> > > >   This requirement doesn't sound PPC specific, as addr_width for pc=
i
> > > devices
> > > >   can be also represented by a range [0, 2^addr_width-1]. This RFC
> hasn't
> > > >   adopted this design yet. We hope to have formal alignment in v1
> > > discussion
> > > >   and then decide how to incorporate it in v2.
> > >
> > > Ok, there are several things we need for ppc.  None of which are
> > > inherently ppc specific and some of which will I think be useful for
> > > most platforms.  So, starting from most general to most specific
> > > here's basically what's needed:
> > >
> > > 1. We need to represent the fact that the IOMMU can only translate
> > >    *some* IOVAs, not a full 64-bit range.  You have the addr_width
> > >    already, but I'm entirely sure if the translatable range on ppc
> > >    (or other platforms) is always a power-of-2 size.  It usually will
> > >    be, of course, but I'm not sure that's a hard requirement.  So
> > >    using a size/max rather than just a number of bits might be safer.
> > >
> > >    I think basically every platform will need this.  Most platforms
> > >    don't actually implement full 64-bit translation in any case, but
> > >    rather some smaller number of bits that fits their page table
> > >    format.
> > >
> > > 2. The translatable range of IOVAs may not begin at 0.  So we need to
> > >    advertise to userspace what the base address is, as well as the
> > >    size.  POWER's main IOVA range begins at 2^59 (at least on the
> > >    models I know about).
> > >
> > >    I think a number of platforms are likely to want this, though I
> > >    couldn't name them apart from POWER.  Putting the translated IOVA
> > >    window at some huge address is a pretty obvious approach to making
> > >    an IOMMU which can translate a wide address range without collidin=
g
> > >    with any legacy PCI addresses down low (the IOMMU can check if thi=
s
> > >    transaction is for it by just looking at some high bits in the
> > >    address).
> > >
> > > 3. There might be multiple translatable ranges.  So, on POWER the
> > >    IOMMU can typically translate IOVAs from 0..2GiB, and also from
> > >    2^59..2^59+<RAM size>.  The two ranges have completely separate IO
> > >    page tables, with (usually) different layouts.  (The low range wil=
l
> > >    nearly always be a single-level page table with 4kiB or 64kiB
> > >    entries, the high one will be multiple levels depending on the siz=
e
> > >    of the range and pagesize).
> > >
> > >    This may be less common, but I suspect POWER won't be the only
> > >    platform to do something like this.  As above, using a high range
> > >    is a pretty obvious approach, but clearly won't handle older
> > >    devices which can't do 64-bit DMA.  So adding a smaller range for
> > >    those devices is again a pretty obvious solution.  Any platform
> > >    with an "IO hole" can be treated as having two ranges, one below
> > >    the hole and one above it (although in that case they may well not
> > >    have separate page tables
> >
> > 1-3 are common on all platforms with fixed reserved ranges. Current
> > vfio already reports permitted iova ranges to user via VFIO_IOMMU_
> > TYPE1_INFO_CAP_IOVA_RANGE and the user is expected to construct
> > maps only in those ranges. iommufd can follow the same logic for the
> > baseline uAPI.
> >
> > For above cases a [base, max] hint can be provided by the user per
> > Jason's recommendation.
>=20
> Provided at which stage?

IOMMU_IOASID_ALLOC

>=20
> > It is a hint as no additional restriction is
> > imposed,
>=20
> For the qemu type use case, that's not true.  In that case we
> *require* the available mapping ranges to match what the guest
> platform expects.

I didn't get the 'match' part. Here we are talking about your case 3
where the available ranges are fixed. There is nothing that the
guest can change in this case, as long as it allocates iova always in
the reported ranges.

>=20
> > since the kernel only cares about no violation on permitted
> > ranges that it reports to the user. Underlying iommu driver may use
> > this hint to optimize e.g. deciding how many levels are used for
> > the kernel-managed page table according to max addr.
> >
> > >
> > > 4. The translatable ranges might not be fixed.  On ppc that 0..2GiB
> > >    and 2^59..whatever ranges are kernel conventions, not specified by
> > >    the hardware or firmware.  When running as a guest (which is the
> > >    normal case on POWER), there are explicit hypercalls for
> > >    configuring the allowed IOVA windows (along with pagesize, number
> > >    of levels etc.).  At the moment it is fixed in hardware that there
> > >    are only 2 windows, one starting at 0 and one at 2^59 but there's
> > >    no inherent reason those couldn't also be configurable.
> >
> > If ppc iommu driver needs to configure hardware according to the
> > specified ranges, then it requires more than a hint thus better be
> > conveyed via ppc specific cmd as Jason suggested.
>=20
> Again, a hint at what stage of the setup process are you thinking?
>=20
> > >    This will probably be rarer, but I wouldn't be surprised if it
> > >    appears on another platform.  If you were designing an IOMMU ASIC
> > >    for use in a variety of platforms, making the base address and siz=
e
> > >    of the translatable range(s) configurable in registers would make
> > >    sense.
> > >
> > >
> > > Now, for (3) and (4), representing lists of windows explicitly in
> > > ioctl()s is likely to be pretty ugly.  We might be able to avoid that=
,
> > > for at least some of the interfaces, by using the nested IOAS stuff.
> > > One way or another, though, the IOASes which are actually attached to
> > > devices need to represent both windows.
> > >
> > > e.g.
> > > Create a "top-level" IOAS <A> representing the device's view.  This
> > > would be either TYPE_KERNEL or maybe a special type.  Into that you'd
> > > make just two iomappings one for each of the translation windows,
> > > pointing to IOASes <B> and <C>.  IOAS <B> and <C> would have a single
> > > window, and would represent the IO page tables for each of the
> > > translation windows.  These could be either TYPE_KERNEL or (say)
> > > TYPE_POWER_TCE for a user managed table.  Well.. in theory, anyway.
> > > The way paravirtualization on POWER is done might mean user managed
> > > tables aren't really possible for other reasons, but that's not
> > > relevant here.
> > >
> > > The next problem here is that we don't want userspace to have to do
> > > different things for POWER, at least not for the easy case of a
> > > userspace driver that just wants a chunk of IOVA space and doesn't
> > > really care where it is.
> > >
> > > In general I think the right approach to handle that is to
> > > de-emphasize "info" or "query" interfaces.  We'll probably still need
> > > some for debugging and edge cases, but in the normal case userspace
> > > should just specify what it *needs* and (ideally) no more with
> > > optional hints, and the kernel will either supply that or fail.
> > >
> > > e.g. A simple userspace driver would simply say "I need an IOAS with
> > > at least 1GiB of IOVA space" and the kernel says "Ok, you can use
> > > 2^59..2^59+2GiB".  qemu, emulating the POWER vIOMMU might say "I
> need
> > > an IOAS with translatable addresses from 0..2GiB with 4kiB page size
> > > and from 2^59..2^59+1TiB with 64kiB page size" and the kernel would
> > > either say "ok", or "I can't do that".
> > >
> >
> > This doesn't work for other platforms, which don't have vIOMMU
> > mandatory as on ppc. For those platforms, the initial address space
> > is GPA (for vm case) and Qemu needs to mark those GPA holes as
> > reserved in firmware structure. I don't think anyone wants a tedious
> > try-and-fail process to figure out how many holes exists in a 64bit
> > address space...
>=20
> Ok, I'm not quite sure how this works.  The holes are guest visible,
> which generally means they have to be fixed by the guest *platform*
> and can't depend on host information.  Otherwise, migration is totally
> broken.  I'm wondering if this only works by accident now, because the
> holes are usually in the same place on all x86 machines.
>=20

I haven't checked how qemu handle it today after vfio introduces the
capability of reporting valid iova ranges (Alex, can you help confirm?).=20
But there is no elegant answer. if qemu doesn't put the holes in=20
GPA space it means guest driver might be broken if dma buffer happens=20
to sit in the hole. this is even more severe than missing live migration.
for x86 the situation is simpler as the only hole is 0xfeexxxxx on all
platforms (with gpu as an exception). other arch may have more holes
though.

regarding live migration with vfio devices, it's still in early stage. ther=
e
are tons of compatibility check opens to be addressed before it can
be widely deployed. this might just add another annoying open to that
long list...

Thanks
Kevin
