Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03714413DDA
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 01:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhIUXLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 19:11:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:19316 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhIUXLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 19:11:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="210561363"
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="210561363"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 16:10:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="703319370"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 21 Sep 2021 16:10:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 16:10:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 16:10:17 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 16:10:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKidkQXiPOnCv3AcWDn5rRN7vETUlWtGvfbaK7nqXW6A+iliVMs37AheU42+jpCAkRuireWHAz6YTn5bYy2NcfKftTfCieAOI+gYVHDVg5flkJGJHrIyE5OCEiB9S3F2VH2371tvphL2i+aBVowikpiLyDU9B4rTLs1a5OFCwCSOQkpjWdHd5KBDcalqNKJFf+mXqlPj38KctsgXWxoB3GOByie8suML0hEkhJym5A1rJsoYksBKleG118fLgBUsacuHElOSaiZyAWS+aaglOCyBhy7+Gx09F01OrbkKl13BMpLnj81Cl0OpW9W/4kNcJBKFNjOxB2kk5htBrF5RJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vdO4t/TxronB4j2c1O7P3L8OgX+i8LgqTN1kBy1p6zs=;
 b=YzocPXnMm0TbjaqXViTwlaABXjBzBAfEjKFifoNCmwQvZwrfN0hDYmbi05ji1rlttce3MwL/xcrALlOCmW0O9DDNEnnAhOcoJBOd1vuft0Zjdp4NqzZtCo8aFB8jqLGW3P/fEUp6uDBwdSBxvqpmdhQeGMo+DyFu6pmSZz+dGQsrwj3UFDtbTuRuRL1TmmSEoHLqgHTdw/WatbuR9ORQU6/WBdu9IJCKVUlr2EkN0W8Y1fPM+efD4BqrxZpJrfYVZp9uHNcWFkt5onsGvYqc1krMNoXPMjXwlGPiqcwj8eZh+AjUEfy3OxR/0D7UkIyaMDCfIth6aWRG8AwqdBW8Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdO4t/TxronB4j2c1O7P3L8OgX+i8LgqTN1kBy1p6zs=;
 b=rjw0svKmCyzwL/1rRqK/AT3VOOHeTAdCUoKtGulmWP3f/a3gmcASA8lZvmx6+EfquegAbpD+awNj3+3cwL/LkVtxnb4yFaMRoLVG0o9nNeLX/ghQVQkZXwpn7HXcDIn9Mzc0QabAIUwZA48h13B6haFKEGP35S+OvdT1a0nT61s=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5356.namprd11.prod.outlook.com (2603:10b6:408:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 23:10:15 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 23:10:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Topic: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Index: AQHXrSFwNP3/pIcrZ0iM9X/cSoy0lKuuqYQAgAB3MFA=
Date:   Tue, 21 Sep 2021 23:10:15 +0000
Message-ID: <BN9PR11MB5433D4590BA725C79196E0248CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
 <20210921160108.GO327412@nvidia.com>
In-Reply-To: <20210921160108.GO327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd34bf44-2a73-4bfa-b655-08d97d54f8bc
x-ms-traffictypediagnostic: BN9PR11MB5356:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB535628A7A93BBA7CE4B839318CA19@BN9PR11MB5356.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t9LhI6KEmz47tyNjew53dFQ+9AihvASH4OcGEgjgI403SNh1zcdjRGN5j/tNpCCie2GDGfSsRwnWeWSDo9io5qUIGqBztdwTOx8+T32SoDj0jG3ve+wRrTaGHwlp5BWi+GPWXtUbm4PciWEVnqKLcjGMRixBCrYt/z8ZM7PkN1S1P6pOH5cvpzNeN0utfDxe0FvowHDDa9Tasc6gDOO2C3JdOEMEAea2xqQv4SRUNZuT4avxKZzTy0tW9NkxwcwCYKutC+Kf5kFJvycrSxpPca1Awvg71hFM22Clyo5NccbA73S2KDHtsHL1rIMv/fLcw5KkO9ZPpLa4ur+ky3Uu2q5Up9403SqgVESvx7HRmUmpJD2ou+iM3gAWBEP4WvSiNSL45EzktHjrtvjTzUNZz3ggyq0c58hFRkup+pe/YHtHxKtR1F7s4Ozd0pZGpIr4yO8aGrP60FP2Ctlnq3rbAX+0RkTc41xCP0ibCviCRHeChQjzKgBuvjcYLBfnnTvNa46v5gAZ0bdnZNeNxkm4I2FWskooBDsnRgsJkDcgb3/GmtYR41rndMvMhV9cIx9amkjvgNP9hqTjyzgZYXotsONiCPAkONb7Fla3CLU/QPF/ylFu9YrorgIYHYOxrTgIOiSnL4abvd2aYeETFBZKwexzfpQEsNaY0Pg5fSNMD5k2GJogCwO/kyW7qpoE0nM6XBT5gE7F3tE6eU5glY2YKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(8936002)(4326008)(8676002)(26005)(4744005)(6636002)(2906002)(38070700005)(66946007)(6506007)(55016002)(7416002)(33656002)(9686003)(7696005)(5660300002)(66556008)(66446008)(66476007)(64756008)(316002)(76116006)(38100700002)(122000001)(186003)(71200400001)(508600001)(54906003)(86362001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HlUJiuMFeQz9Sidd4qZA8z8tY21UZXHPcsVyjPtMR7WbKbWu1KkB79wWgYDE?=
 =?us-ascii?Q?gn6WF4t3DeX6qR6Cm9iAZcE75gdtdBVqGB0y3TOVSmfzu2uPYcvDvxDGDrsO?=
 =?us-ascii?Q?kA9zWXfO1BqY/GZUMrywQO+QKukzyWLNdaSYPG35sQZX8yWpIPzxhCbXsYHL?=
 =?us-ascii?Q?u+7cg9XjIOP+pPVHR8NK3fnQ1gehJaJvlHB8CWEtwGJaqxRLS+EI6n6gJquY?=
 =?us-ascii?Q?/we6LU8H04Cp6VyMG/9+KYRyQ1exZWJQx3ERiQ5YPH94tuDp/41FS75uRAkN?=
 =?us-ascii?Q?Kt4eC3CmMBFp6EgVrVCRSwFyxJQkRpQf9P3RMKIyBLhbZeLBcRkD9RtCOYh9?=
 =?us-ascii?Q?zhMsyMrFoJlViU/3YPnYm7xVY21yNjne8fMp/qMjBVxOFzgrYgdM6xtmseoV?=
 =?us-ascii?Q?nH04Wbff+0ykfOu/c2sJeZFmopjGem8w89cDhjQk3GHbpjUMabUcnAvPSZlv?=
 =?us-ascii?Q?9X/DICMqosN+6IEjwhhsvP3wAo2OMfFbHrT+HfXIvJ9eEnYhq6WeRncwvT2A?=
 =?us-ascii?Q?xhd2KYBXNcCPbuwuvm7dmjgNuZmG6iWP+ecen4NfJKm+boR+DVC8TobhaiMe?=
 =?us-ascii?Q?UA5TH3jZu9moue+mGzPt8BLJvqQhfhLeXtM3mEklN3U8o5ZXpw0AUKWOmfEM?=
 =?us-ascii?Q?ulDoPIK8AEjG8Wzn0B2i2ROMUQvyjNcdw2e/7VhwV3dBn4h4plPX8PtMeVP0?=
 =?us-ascii?Q?WU1fy0/GIf0a3fFH1eMY+PYJZlDayeBZplqHr75rKdiq/jPkrsPOgxX1i4uY?=
 =?us-ascii?Q?WziVaRxeBevtVHFn+HmO92kDz2fmri/kBRM8Txk+YFznOvkA156s9oPyRQfH?=
 =?us-ascii?Q?hrLCxeHgGc2j3wz6noVQYzFtxPvrQ6tg1UQaYYSWK8RvnDQuY3V1Rrn2DAyL?=
 =?us-ascii?Q?Koge5Cwp8wAV/HQT2zWwL0KMYWKHgzz9vfaszqCHmKxJmcwpE2sMoh5eb7sP?=
 =?us-ascii?Q?sNciwO3CfTnK3/tv8opgXNYkT4yDGxR+gECenr3+OMn44LoVt6uAJ1SmqeTF?=
 =?us-ascii?Q?/Z9DQJGPFuDUkbGo6TlsCyQ0GkuVRnUS+ENemYTjAhlYU4ysgulmcYLZGYq8?=
 =?us-ascii?Q?l8ogLnd2vCBDS38WoUf1S+7fpM572p67Ll354F4NtfwPOo6nqcKtPxNF9Etl?=
 =?us-ascii?Q?pOO/6ZA4rhrFsmr/l3hC+b9v70/Gt1LIOQScoqNi5SrTVI4GIJxiYrfeFNMK?=
 =?us-ascii?Q?O8s2Ys568esSGJUazLKbndkDfMDk69zgOY54JnM8wz1icjtBt5OIswRS6Fkq?=
 =?us-ascii?Q?9GCuM+VoO2oMjwLRjsRSpM0MnsgILVy448xsWiSWLBvv5fqBjK1Bh8SPDylT?=
 =?us-ascii?Q?ypA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd34bf44-2a73-4bfa-b655-08d97d54f8bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2021 23:10:15.2098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LnJrThkwHq897h0JBftHYk+p41A/szMZq4pnqBdgwfJE8Sm9g0igxT6FnyYKcebK1UWbk5zlO4eBEGWPfcSpaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5356
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 12:01 AM
>=20
> On Sun, Sep 19, 2021 at 02:38:31PM +0800, Liu Yi L wrote:
> > With /dev/vfio/devices introduced, now a vfio device driver has three
> > options to expose its device to userspace:
> >
> > a)  only legacy group interface, for devices which haven't been moved t=
o
> >     iommufd (e.g. platform devices, sw mdev, etc.);
> >
> > b)  both legacy group interface and new device-centric interface, for
> >     devices which supports iommufd but also wants to keep backward
> >     compatibility (e.g. pci devices in this RFC);
> >
> > c)  only new device-centric interface, for new devices which don't carr=
y
> >     backward compatibility burden (e.g. hw mdev/subdev with pasid);
>=20
> We shouldn't have 'b'? Where does it come from?

a vfio-pci device can be opened via the existing group interface. if no b) =
it=20
means legacy vfio userspace can never use vfio-pci device any more
once the latter is moved to iommufd.

Thanks
Kevin
