Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7176FD311
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 01:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbjEIXlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 19:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjEIXls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 19:41:48 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008F8172D;
        Tue,  9 May 2023 16:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683675707; x=1715211707;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gGKUc0cPmMHinrMYY1CoXRRzDiCzbTmAHgu82AmcfsY=;
  b=SCbTDdaYcJGctSGNtcqfqpXS9Pv3puCiLfexNVP9DDMj4PzZ8rfN9ACl
   JYdGnO7M/qShGDURVyKuKge0MRau3xNA7vLOvLU5neBTXnmKBW/EPtaGK
   MXVQ/91PGno9BD28koMYcVGFBcDWDkilfx2QzIic3BNC4DUeffwb7/X1/
   RCf0SU7czlapjoL3N1VzT6BBUD3OqMqkH6G9oox+3S6/2DKPWae0OvKY7
   SjtLsIAty0pn7yLvM/cdlS8ojdk9RxAxqyYXzKcobFWYg7Y764yoFKQlR
   1VJzKXX5CjJzp5zI3g7Fi3XWyw7WzuXV/6YEv5PJ8FqY12S8W4AOPTS9x
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="348918259"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="348918259"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 16:41:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="843301864"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="843301864"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2023 16:41:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 16:41:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 16:41:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 16:41:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 16:41:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqRuaJKGuCkZVa8s8y9mmYSmuSjKIOJ71fWb0HDoTCSdvJYZO93R7GgJPiui5soQ4e8kafH93Dp7SN8DxwIORzYT/4tS/nmcQkyR+m4DJ5WKrc26D27GxTiprIAgwYpFNAxgbZt8Rb9lDSt23jSf00Cb7C0vUG9o+tByWeqU+woqrZp6iV2Mo4LG1r1VCyLMOZ0lDs9daM3mVuIWjJdIueozLRq3ElRa/0VadUItJM0aZaLvTWxvb72pVyGJpbBTPxlHiDQgW1rSWf0XISImUSBdyuXKhKmuDgXxvSswXe/+AQll1M7i6WpjvodRv6YBTn5ZEWTI0Ml85suMRIQvkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAeSHXMvqnfFc5JF/F3Q5AB2Edx2vjl+cLEM7YJTjqg=;
 b=lC2p/8gB/Q7EqHX7Jfo9B4kw9AL4OfUPrrNdhdkvR9FuysqXJk4n+m44WAZgUxqlGAA9rROZjwUd5zPYZMu57GhxZM6voyA75JGkTk568ekzCOmOR93y9XfEnpUwY9HQikx53u2ZAXSJBU5dJtGDWOgKVT/WhPIBWFgdzlwInzqae9BCfiFuQxRC9ecgj9/rGPQMfssHfZm60QNytpEuI6zkY5dTfqqU3C/U7K/0lCbhF36cWHGfiNdmy3z4SeaejNu3dCbV98MsT6tVUXTiUyb0wAleGlEQq4hcOZ+juhQPHql8jCKEv1WlkapuDlN8wxHtuU2jSG+V4xsP/0TvzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB5864.namprd11.prod.outlook.com (2603:10b6:510:136::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 23:41:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 23:41:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: vPASID capability for VF
Thread-Topic: vPASID capability for VF
Thread-Index: AdmCTgezzTkHY+EMTOCoyMjynB/f5AAeawOAAABU4SAAALJtAAAAuuow
Date:   Tue, 9 May 2023 23:41:44 +0000
Message-ID: <BN9PR11MB52760816DC23D5322A4318228C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrMneCMKuCtu7JF@nvidia.com>
 <BN9PR11MB527627F407BB2942ADFF800E8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrThMhUnsYOE3WP@nvidia.com>
In-Reply-To: <ZFrThMhUnsYOE3WP@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB5864:EE_
x-ms-office365-filtering-correlation-id: 9401d7f8-da2b-42c8-aea5-08db50e6f2af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a/GSW8dda/ShCUxRpF+j/pSyOuFU+Z7qlpfk80TxhkRYgmqy3wx0vOFH8XN7Agtngx8n8fjuKDe6TGSxO24eBJEwbROani3d1OtazcSF+lxYaUeRDUTj0RPDZ4nUD0uD+gmEyEkOFKyYn7klfXmVydAU/bKyFPPXVUwnSJWYkzZTNisE2S2+ZQNp7KwZKnKsLUFDUWtQFEtHeb2oa4qQ5bA3ZtNS7J03LAbomFfWA45lWyZQ1H4t7hHWK7MhiYwEd6Sar5xhzvPIgtBHthgROoGZ7mWcPrq3JppqEDz6p+ApVwyz+RbNZ0bVSXw0Jk0VRcQRzvdW179qCjBNo1tZ+Klqru9kFDLj9REd5O2YJtu8vGgUb4TwW1p3RMnf8XKwIqGVz5+n/eouhuN8aRGOvEBjs1LbkbU00igj+8DTg/1W63XtOh208DVh9hcBcuFgny19an622i8qP8ac0AJYFuoYvTcEgMCAcE8A8CmgwqphL4yJj93snH4cje68VVeo0AC5yxaomvc1aEXG2JGKf7nY2MU5+eYGEo7uNLa6RmWYjvEOb/m/StSjd9e+36TitmUOXcVBq4VCRykvANORXiLuNiIRPc3dAC+E5Mu+wEjybCesIBqQM1o7o0m9e7Q7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199021)(8676002)(52536014)(8936002)(5660300002)(41300700001)(316002)(6916009)(4326008)(64756008)(66446008)(83380400001)(3480700007)(107886003)(9686003)(2906002)(76116006)(33656002)(86362001)(66946007)(66556008)(66476007)(26005)(71200400001)(186003)(7696005)(478600001)(82960400001)(38070700005)(55016003)(38100700002)(122000001)(6506007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VUrOXfkiVnwxct0HKlBGHRlEnil3CY/8tXZqmLppDtVco8LxoE5UENuCHP9M?=
 =?us-ascii?Q?gg9NR/WL5lH3JYo67YWdls0tv+w090MbfrpbFhIN7MFsMa7hbrjwrez96SPD?=
 =?us-ascii?Q?yfkr4GXSwGq+t1PHScDyb7tIdoGqBQ0eO6T15D/oM9cpFUgFr9WfunMpvlwk?=
 =?us-ascii?Q?AluEwXowtYAHD8ddZRNJYshDzi4hzTrbe8TCsQclZsdYYAN6cZ5iac578WVb?=
 =?us-ascii?Q?AmYxDvinH7u6ktlN09EBr6rdZcS65KH1LpOLyWCe8zI2yf+rxsxvzM+JRAki?=
 =?us-ascii?Q?9vTofbj+ICTwOEsKfJ77r4b/8ElQzbGVBgFaX6S8yPN9SZV9AQIShpPaNXk0?=
 =?us-ascii?Q?MHDF7lN47mHB/HO6Ax8aW1++Q01vBlJDAz6wsTnLssqYHoMbL5Y0NRlXO/P/?=
 =?us-ascii?Q?26/3uMAginy+0SgUDOuJa8YHx0aLFCnKFIDxh0MLZJJlrJQT1/BU2E7swV4t?=
 =?us-ascii?Q?hZb3DjuwIh68WHvIrzUsCq3MAd4a+X5GzuSuidlnEVIrVyEtW7t3Zibr07Hh?=
 =?us-ascii?Q?Dj4oQc0Fe9XxeRIWEgO/a6nCTfTxkdRQCAIsdlNo2j8uKwXInuyU/uQDbGGo?=
 =?us-ascii?Q?yzZmMjWKP2IcraLwrSZZ97+dSAzprt6OvjQ9QlZx95atHLFKiL9sfmNXPSeM?=
 =?us-ascii?Q?1WebTO1sT5sR3QA9Cii3R8bJeBJcprPDJB+bY5OZN3Lscm/aXpXKzn0qoJUx?=
 =?us-ascii?Q?Ypm0cyfIWo9dIGZZKb78cmhrqW958NS6IdfmlEsSD3lErEPNopPXT3le/Qk/?=
 =?us-ascii?Q?d12BdVijNWgbGFGocsrLEHD7rlqjj60gTBJrcdhQYGs6p7iIP4xeMBLW1jn2?=
 =?us-ascii?Q?irhUphhdVlpISEheKo5K0EmzHrXRnCfIPO76Yxn49c9e7L+XodvmQVwAtF2b?=
 =?us-ascii?Q?Mw9dNXkc9ZIdGmZKciwal3GnzBC2kMt8KYXZV9QM3wI8lnk2/9AcZDVe66z6?=
 =?us-ascii?Q?5iNykSe4Ik4NAsJyzoQShNUcgoaVOSqaVICf/Z6bn+wLlipIF6a9orEaQu6D?=
 =?us-ascii?Q?9TyqhRmw8RQya0NtyYW3MJyPG9kFdZFl4ydHLOfXFSZQDzwmAiWhURg1lJK2?=
 =?us-ascii?Q?96jqpCIF/uh86g/i4Tjt3Mil97FRH367hw2NKs5FuCIIEQNceiDFPO6tKa1n?=
 =?us-ascii?Q?gXN6+k/llwtj3jFGRGECXevlztCavj35QuCcwDMyyfd7rOqOqKap1d/wrF8R?=
 =?us-ascii?Q?fGIjwbJRlGx+Ff89fjB6HTv8HQAxVkVQEYLwl9a7NedyMZEh0CQV8aSPWw2e?=
 =?us-ascii?Q?jaJ2XDHySE2ALLg+CIie0OVQN8UvNBWcNkZTEwawkoKxVynO20PQ/uv5d6Vt?=
 =?us-ascii?Q?rvIgTLSCw7gkx7kgAaCPcLrDJdctwz/8ua/TwSoL0dlFJ6NhwZjvvUi7tspf?=
 =?us-ascii?Q?xp43lCsHrOUkWkLqY6Tf6cAgu5giZ6pbmKcRMdtV3823ji7B7NL3oFemdhCe?=
 =?us-ascii?Q?nRZyMlfn9J2srJZljLYa4bY6v+9Rwrk7lvGFu4VaN4q6XGNXW+Ay4iAd9y9f?=
 =?us-ascii?Q?kN39F7y7j5P4TKJIWZ5nHBsSsJWGNBApzdEYyqC3J3MU0c9EPXbXB06qxVRo?=
 =?us-ascii?Q?FUmi4zvC7MOSlgLlYc0Iszo3IXyuh8lfZN2yNAuM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9401d7f8-da2b-42c8-aea5-08db50e6f2af
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 23:41:44.7345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WB7GbA0It4W0/nlHN5v7HzcoH2+L4YmMMpavZLqCIRhUZa4RBgsYCX09FoxgGgh6WgRa+aHEEow0RYA95D8jpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5864
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, May 10, 2023 7:13 AM
>=20
> On Tue, May 09, 2023 at 10:57:04PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, May 10, 2023 6:44 AM
> > >
> > > On Tue, May 09, 2023 at 08:34:53AM +0000, Tian, Kevin wrote:
> > > > According to PCIe spec (7.8.9 PASID Extended Capability Structure):
> > > >
> > > >   The PASID configuration of the single non-VF Function representin=
g
> > > >   the device is also used by all VFs in the device. A PF is permitt=
ed
> > > >   to implement the PASID capability, but VFs must not implement it.
> > > >
> > > > To enable PASID on VF then one open is where to locate the PASID
> > > > capability in VF's vconfig space. vfio-pci doesn't know which offse=
t
> > > > may contain VF specific config registers. Finding such offset must
> > > > come from a device specific knowledge.
> > >
> > > Why? Can't vfio probe the cap tree and just find a gap to insert a ne=
w
> > > cap? We already mangle the cap list, I'm not sure I see what
> > > the problem is?
> > >
> >
> > PCI config space includes not only caps, but also device specific
> > defined fields. e.g. Intel IGD defines offset 0xfc as a pointer to
> > OpRegion. I'm sure Alex can give many other examples.
>=20
> Do we even expose those over VIFO? I thought in general we blocked of

Yes. I did a quick check:

/*
 * Default unassigned regions to raw read-write access.  Some devices
 * require this to function as they hide registers between the gaps in
 * config space (be2net).  Like MMIO and I/O port registers, we have
 * to trust the hardware isolation.
 */
static struct perm_bits unassigned_perms =3D {
	.readfn =3D vfio_raw_config_read,
	.writefn =3D vfio_raw_config_write
};

vfio_config_do_rw()
{
	...
	if (cap_id =3D=3D PCI_CAP_ID_INVALID) {
		perm =3D &unassigned_perms;
		cap_start =3D *ppos;
	} ...
}

vfio_config_init()
{
	...
	memset(map, PCI_CAP_ID_BASIC, PCI_STD_HEADER_SIZEOF);
	memset(map + PCI_STD_HEADER_SIZEOF, PCI_CAP_ID_INVALID,
              		 pdev->cfg_size - PCI_STD_HEADER_SIZEOF);
	...
}

> various parts of the config space. I keep seeing patches to unblock
> parts of config space?
>=20
> I'd do the reverse and say devices that want to pass parts of their
> config space should have a special hook to do it and otherwise we
> should sanitize and block?

This then may break backward compatibility. We don't know how
many devices have such hidden registers so if anyone misses a hook
immediately it cannot be assigned after we start blocking as default.

>=20
> eg we already have a hook to pass the opregion
>=20
> > So it's easy to find the gap between caps, but not easy to know
> > whether that gap is actually free to use.
>=20
> Because, let's face it, this is a horrible thing to do, and the
> opregion stuff is just ugly as s sin.
>=20

It's ugly, but that is the reality. :/
