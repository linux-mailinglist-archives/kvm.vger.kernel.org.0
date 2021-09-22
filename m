Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549C5414B94
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbhIVOSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:18:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:19472 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236155AbhIVOSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:18:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="223646028"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="223646028"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 07:16:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="704036506"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga005.fm.intel.com with ESMTP; 22 Sep 2021 07:16:31 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 07:16:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 07:16:31 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 07:16:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h69oz8yACEi9CL8gh795E7+BwBeKlN/qJWYDQvCWJ3IVzE3AYhZDzXZezq1GBTWac7Q5fjuf+AOo2+RLGoii9Y/Hl7I3h6gTfZJg5R1P9/UPDoyerV0+Cf+F0EYcWFzmouUCtDixRIJoQSb/oBoqITXCD9CCg/3KQ931BV1lWys4QTnyK5jf3OUkBBXIp2qtyj46zIuk5XyWiNMvEsn/OwTxvYzguWxlTsJRdVh0nId9s6Ag50La+chPNzK5e9QCqROEX87lOUUaqYzmTPJj7emuquacHWotXcJsCl6/m7JXQXrR+WGcdXy4zzYBtVVPwLQEwJYumL+VM9tB1Qdn/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3U+Vo+crc+aVfhudtuWuYac/GNTsbn2vE0hjCv86ZC8=;
 b=hx25FfqYoZvM0US900fUwpLleaoi6ryQZSuDiS1fQvL7WQWZ7e2BTmCjdma8w8josXuhpHIWHrGGkzutVuO+WcXjY6kMq2rDJSmnNX7e6mYZX3KGH2m5WJnaXByZv32Sh70UDMnD1CcNV4phAlu/hKQn5S/o0wnjoS+lNLTyNlwt7iABb3BMrahapZN9QYBiNs3zUyJfsVHG+iVl1XVUhlWoxGWjq2TLm3pPCdPXryJsZjv90UeSzkSUN7uavo/IfHMZolRg8gpQpyAyGGXKGkV1z5YYZTfUM4IPaiwLYW5+ffSvMiSzG4ugf1EZdAk7Gn7yWwEOTenCutrIgxZtZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3U+Vo+crc+aVfhudtuWuYac/GNTsbn2vE0hjCv86ZC8=;
 b=uXST/T352uHFwBHdpRc8OdoyW/C74YQ/cN9VcJUgmMLWME9lNera+PrL7i9HJZ7rKOEfK9CzN8v5rD/CRDTs95GLMXLMQ20VCcFkica+yGat0KknxYI6VRItBBtGS+nQQXWkdEq3buqtYkUq31PTj8sNXtSnPtk0jtjcgB783VE=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1266.namprd11.prod.outlook.com (2603:10b6:404:49::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Wed, 22 Sep
 2021 14:16:28 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 14:16:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [RFC 14/20] iommu/iommufd: Add iommufd_device_[de]attach_ioasid()
Thread-Topic: [RFC 14/20] iommu/iommufd: Add
 iommufd_device_[de]attach_ioasid()
Thread-Index: AQHXrSGezXWDqkj89kuFN1ZDWKFxuauuy0yAgACiHzCAAJsAAIAAFVKw
Date:   Wed, 22 Sep 2021 14:16:27 +0000
Message-ID: <BN9PR11MB543395858CBB558356C853228CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-15-yi.l.liu@intel.com>
 <20210921180203.GY327412@nvidia.com>
 <BN9PR11MB54339FF0B126A917BF14B44E8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922125704.GN327412@nvidia.com>
In-Reply-To: <20210922125704.GN327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39adae06-1dc3-48c9-4e89-08d97dd3916e
x-ms-traffictypediagnostic: BN6PR11MB1266:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB12661A5D72675C5EBF6255438CA29@BN6PR11MB1266.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kzW2HbRYNM89dnP6QjjmJmtYkxMJNIglHc/TG8m97D9bgIwipYhF/Zi+EhWNGb2i6TI1xkXEKKg4Vm9APOYBhFsgsS/X2cVJt0hTqiEdI6UUz0OaCUJc1h+0udL1YWWZnzqof+zirDnIoPChSZPorbzb059NSUuh0LZy9LUQ7EOg1M4DWO1lEjYLj0jo1FfXdalqOAHcIORU1UrxhckFKzDlYZu0cXfR5IgVS+lgWHPduE4xi10MRacyOykQZh2CfVncdQadxPpW/bL7Xn6z/t8tjvzImW1Ee8Wl/hSm3bYyvpUBRqdQrtyFBwmy5iCR1nIiOSVRrPntbK0NGwGHh2kZ3vx17wdJEPo8a7bZHPtifBPpZIKVjZICDT2WjRYt7fCt/OXxSLD4ZXn8aj+71E3x7/4eEwMCLm023qzV/8AmeLdD76RyIS3knhlZxpnd89zVjqU7En+l8UZgU5AK84EbkBcce5C6t5Y4pbq/q1JioLYceheC8QL20A0Noa2gn2o3oGtdMJ0adMnLRFzBp8zwydGvej+fM+jZqPMAs8XEFHjtJs55lGBcpjjlaIztfN4ma6Itgz/JsxGfvmHUumVMzWIsvD9dPGI3QfqY0oS71Hux46OmVt9RwFCU/hUtEE/jNsuX6G1s5cqoZArA8Kshtn1WIxnDof7RPh32zWYFslBWjy4h7jjFS7cVvtEs7zioh8S+a94tW1zQ6GrpcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(5660300002)(52536014)(33656002)(8936002)(9686003)(122000001)(2906002)(83380400001)(55016002)(7416002)(38100700002)(64756008)(316002)(86362001)(8676002)(26005)(71200400001)(76116006)(66446008)(6506007)(66946007)(7696005)(6916009)(66556008)(38070700005)(66476007)(4326008)(508600001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a5GnNQPPwNs/CvvG40cDv7Hdq2UJvNPkl6V5jBoDVEY14zPNwsjbcJMcjyXo?=
 =?us-ascii?Q?/GTuhAvQkqZL5H/7Nw8nN6zbWCLQh7q4AzeVI+LEMJso9MPFDWiefNc5S1iw?=
 =?us-ascii?Q?corZE4KWZdCAPEPoVODaqlv2yl5CAcyonQxl5ljjPMKOAI9vHqFzYG0ZB/gn?=
 =?us-ascii?Q?a/MZo/kNy2I/ic9RaMCUz5UiydJ/jxRydtval7S9/q2g20SB7fDJRoDXjC78?=
 =?us-ascii?Q?JN7Ml3eaZ3gUSOi1AVcn/0yXGqticb34uSrsUqNRsb+mg36LTx0GUykydOH+?=
 =?us-ascii?Q?7YCvRe4yaX4FEgSbZ4TjhhX+bRArSesi3n/Zl+/MDR+Vw+AOetE/t8ADsp7u?=
 =?us-ascii?Q?8/9CIToZ95qQjNIl9bHhuPF1zoS0+hmHPs2VAaiX9at9OXa/pLfGz635EPfI?=
 =?us-ascii?Q?Vooe1FoZVlFtny32skgSYYW9EZfbRIYz+wlKC1vx9ofaDquSTcieiLqsaFNV?=
 =?us-ascii?Q?Dr8puSrQQ3t17Q2tjVNVlDYdiMCeVWNbHf3VUHcx0VdJ5NBodlpt6ixfnhCW?=
 =?us-ascii?Q?wID1Hut/sz6VY3BzOjCAMUrKSo5l4KaoZAno6+DvojfTrLLvgKXeJpbwVw7E?=
 =?us-ascii?Q?6iONKHkuZ5ge630k40P28DozA0UGQ1xaureUtDYn3xffWs9brucMa/PU6QdQ?=
 =?us-ascii?Q?EfbdSdtMxwmJfWSw1A7jdex0H8VactfBd13rhveU+5uvOhFijjaiMaDmJ3CM?=
 =?us-ascii?Q?xbJzNGJ4eS/f2T8EQpdqyPxgbxn727S0wWHHrME15iLQr1JQLwirF7xdHKZt?=
 =?us-ascii?Q?DpbeP25yVagQzTPfnS3ycadhjllviIot1NtXidCTJrfXaUNgotJ1pb89M1P7?=
 =?us-ascii?Q?vdnRvuaA2SBw53j1n9NhGYToXdc37e0hPHCuCferRu0N18a4EIfgiyN+QiZF?=
 =?us-ascii?Q?ALGRZnBGQglLygS2gUv2tyGlWxEdPHqVpN1CT10GjWSfUcWWeSEeAn0ePHVt?=
 =?us-ascii?Q?PBSwHuotd89zO7yJtZci062Q5x68HVv7GqdIPE3Yclh2gBHbf6vduOfNtCoo?=
 =?us-ascii?Q?S4uN535YR7mY4E7LFhiZLNTumO1neEUzNwiUlZfMAIKwCci06M/EyDgfaOBM?=
 =?us-ascii?Q?VWeDUKtCXrGBJXvrF7oS/2g2DSpXSnIY/H1r77Tbc10FOPLp2aZPpi9wMQ7m?=
 =?us-ascii?Q?rzwVAQqdMfqPgdOCjNpngjkrNT5TgXRYOgMq9WZJLkXbe7gdlZnGgrii2DSK?=
 =?us-ascii?Q?7MLB72sKVqU8L6GmY9JJiMWCQkuMOwoKLdsRAOeQoyK5CBkM/X6+uCgKcTiO?=
 =?us-ascii?Q?MbJTbh+jJdo7R9u3Q+HcslCZ50JrmP1zWH8a5mYDLQpGHhGdlvzKd12i/u+r?=
 =?us-ascii?Q?EKg/nv+BWDL4IPhiBrhL6Tec?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39adae06-1dc3-48c9-4e89-08d97dd3916e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 14:16:27.9430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jG/re8oWBRGmDhy3qKWi/F82GrX2NKfSr7Ki8mMo6f/apdXuaOWEUctgTjHZtXtSPFuoS/dMA/yLl7n82SmcIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1266
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 8:57 PM
>=20
> On Wed, Sep 22, 2021 at 03:53:52AM +0000, Tian, Kevin wrote:
>=20
> > Actually this was one open we closed in previous design proposal, but
> > looks you have a different thought now.
> >
> > vfio maintains one ioas per container. Devices in the container
> > can be attached to different domains (e.g. due to snoop format). Every
> > time when the ioas is updated, every attached domain is updated
> > in accordance.
> >
> > You recommended one-ioas-one-domain model instead, i.e. any device
> > with a format incompatible with the one currently used in ioas has to
> > be attached to a new ioas, even if the two ioas's have the same mapping=
.
> > This leads to compatibility check at attaching time.
> >
> > Now you want returning back to the vfio model?
>=20
> Oh, I thought we circled back again.. If we are all OK with one ioas
> one domain then great.

yes, at least I haven't seen a blocking issue with this assumption. Later
when converting vfio type1 into a shim, it could create multiple ioas's
if container would have a list of domains before the shim.

>=20
> > > If think sis taking in the iommfd_device then there isn't a logical
> > > place to signal the PCIness
> >
> > can you elaborate?
>=20
> I mean just drop it and document it.
>=20

got you
