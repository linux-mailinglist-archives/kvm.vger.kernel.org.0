Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF88410A73
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhISGr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:47:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:37196 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229810AbhISGr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:47:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="210232880"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="210232880"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:46:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="555477783"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 18 Sep 2021 23:46:31 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sat, 18 Sep 2021 23:46:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Sat, 18 Sep 2021 23:46:31 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sat, 18 Sep 2021 23:46:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrWZlBZKpRnMnb5UQLAkxIC9Eys/nbUuAZMSK9FxBK3cx3Er+Csd6hiN5wUW3O9B3Wt5NT6j4xeslIMhsYjgL7d0fYxjikTgAyR7lxovSlF1FnGl0bZYGZaWciAX/o3XaYP6p+HJWmd2i8p2XaTAMScIa14n8jb/8zCDChUSBgQTD/YuHG7k7B/0JEU25l5ay5KM2Gr5mvxa5dq/Mbw7eYrUvLQa0vQw2dIQJNc1HBMqMNcx3ptiK993OUAhqUK0Gfkxo6nCj14IhlKVbo8Obj8PWIovdoMDX/HDngJQpGGrjsQIXAi44GRNn58q/sZcROeJgIlQ1X5HzyrdZHv81A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VQLumwyQXMag9hmkhiPTvPhKRVWtSiQ9WLjWCEGrZIg=;
 b=Y/YatGIRJyU/2OWC6s+KGhV/GW/U6WdhT8kTRGvY2GyP6JEn5QSCH04mKfX1tUNF8dInBnyXdmrvfhUCJnsUuEQcWCb+4k9Ii7NpdO8FNIggibFnoa/l/7H0W8VnZ6NGdaE5HBslOqXYinbk7oQjaCQwKjJ5sieoWd/uGV/ZTmFzIRMlE5zTiTKhMK82zDQX1cZBo0exjqOZ+lnoqQSdHuD2+neLVo7OytRz8Xxwr9p74bBAgI2AbnPbpUDHP5T18dmeA95hUroiBkcbuqc44dqdcNzhfs42g++8o8dAYRGjJLKST9NBWTMrwn+l4/56BnmRM7RUrhf38A0htzkxTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQLumwyQXMag9hmkhiPTvPhKRVWtSiQ9WLjWCEGrZIg=;
 b=Yc8JDCx2UqJ7jKz9kRJKcKhtYwsdgvlK2w6hq7Ski0QhwCpRjNLlUJHjxDoGNcfWGfbZhzpkgIQ7IIulmVW90vNgQFMEov7V/vnXtY95N6nRYI5gZP60z26QrlwjZOjiR3WeWmPVsQukovPBmLP+mpKrgEeJ5YdZhILD0nNKhYU=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5593.namprd11.prod.outlook.com (2603:10b6:510:e0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Sun, 19 Sep
 2021 06:45:53 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4523.018; Sun, 19 Sep 2021
 06:45:53 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [RFC 00/20] Introduce /dev/iommu for userspace I/O address space
 management
Thread-Topic: [RFC 00/20] Introduce /dev/iommu for userspace I/O address space
 management
Thread-Index: AQHXrSFkVs244O/dIkas8ZrIoCf5Fauq6OJg
Date:   Sun, 19 Sep 2021 06:45:53 +0000
Message-ID: <PH0PR11MB5658D4970692ACFC04A248FAC3DF9@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6cd04f6-2030-4a4c-7d9a-08d97b392039
x-ms-traffictypediagnostic: PH0PR11MB5593:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5593AAEEF37E0B4142EE6749C3DF9@PH0PR11MB5593.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gH/TxNEtUVQPAUFg2cd3b3DazyHsbJJoXsTFwf2vKl3dYYjlF7i0btr2cKn0PH6W++sjZLI8Un9MeFy9eXpGVDUDpG6I51u1kWvyBQSRPLjVsQm/++TjYDjTxtZOH4F/NlOFKWvY3dTJIzGZ+wD5Qzn3nZOiBrLwiqI+kcg/HgLtxXjlqhG15uk3XtaGncoTw0zdgGO+1Y4QySUNwlA7A1CcrvFndV1MByqAAVzA+aj5RnwBpSLFQOwRYZnmANBk3gexcqkQeoqshhqABPayRRp/qSRRXMk6gMyqFPv0pVJm6o1mIDw0JALO+PHLX6JWx/OP6a0H4zGB5zgjwhvRrQxw7vKKMRuXGxjjJ8pbeB2qpjtlHAFvfILQthAS0ChugL5Wurv1y59oca+wWogDyD/Qj35ES9pzZ3T6AxfZG6/mKd8hndsrPcUfRMWPkg+74JrHmURXWL0cLfokXchrPHmEM8KMI7VeFDO+zgBsAsOoDgJ8C0fN4Jec6DwdwgZQve/7upLwP7QjmbnSLuZBp4v70t/jgaOVfUz2jhN0Vtdsn570TkiJWHC9t8grhWnK55+gxAYOeYFBLV73DX+Vz2arGGnZVtgtC219cxFKFlar3T8RkjvuWNJmyzUdH5W4gkOj53lK/+nzk6gPysRjelEkH5NqxB28HaXVIl+gf4X1DtfbdWv4erGyFXufmMIpdnTTKO3+FiT61r+0DKgY5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(4326008)(19627235002)(478600001)(66556008)(71200400001)(86362001)(38070700005)(52536014)(9686003)(110136005)(316002)(66476007)(7696005)(55016002)(66946007)(6506007)(186003)(5660300002)(38100700002)(66446008)(64756008)(76116006)(54906003)(33656002)(2906002)(122000001)(8676002)(7416002)(26005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3fL6RQEW+bdIf9lDV2b+QzCDV6Yg3ULWWTaDgITx11tSOs/0ELbPw8o9XgIJ?=
 =?us-ascii?Q?O2zc+tGGzRx/fkq31dnlNAu3JwhjpuvpVwLBNWNhN/TmqNSWiTxWd+N0yWKE?=
 =?us-ascii?Q?HMpcYYQNh1HtUbQDj42Ax58M3e7ZZFG5aSnLW3fTkgsmRuGYEaFS4teouDKQ?=
 =?us-ascii?Q?NJqydZZ2i6lc4hK7n1kTKtt+jzWfB6ikt2liBYsYat2uT2+mn7QPp+SozlPa?=
 =?us-ascii?Q?Myz8GBFhUgZEUtnXJVd7nu/FzAo98q2Uk5wgDOLubqlGr6TM23l1rVnXYu+N?=
 =?us-ascii?Q?Y46Ughjdpb2raeb+8SHzw8OUWif1c42odlugO6FroBciG4GbKwFVO/E/+gci?=
 =?us-ascii?Q?4sVnoyK1YcnmKI8zdeNi7s9SL3YnEcIQGszWQ3ReQ427z7xQ0dfZZhgeqdP7?=
 =?us-ascii?Q?aAZTf60f9PZtuZlIEKj6Zwe4TBDa/gUBEkoMDOZ11HnQ6A7ImU3OZdTCf775?=
 =?us-ascii?Q?mWyubLVsl0HCAHILJzWri679ZmivlI0uYTokWWWp4Ly/wUHk7d453urlVnvf?=
 =?us-ascii?Q?iDi0Em71OIsWqo6mHnIrhFOGzJ84nMfSnIJtIeiFGSEHKvbT1XXWtyt1PnSU?=
 =?us-ascii?Q?caG4Yz8f4gXPB48CWDMJ5iNqSr+YAej6s43mhL4RcrLIiakl+84Q6dMEJoTe?=
 =?us-ascii?Q?vv/tpLasVH9atD6w1seBYGA15cl99beTKJdTnwc97g7Yo0FXDJx9AZG3y4n2?=
 =?us-ascii?Q?FIspddPRfkHz6VJ0QLXpGg7UUcJUxw4+ukncFZs9d/3BQc2rbdKVEoVgjvQK?=
 =?us-ascii?Q?ZN8lPNIUnHNSQvA1KIMkGKGeFl86D75dRULey9FQGsv4oPHP7AxOEd3q5Ic2?=
 =?us-ascii?Q?DxCEOsShayK1aXwDso9awAzkHgW07e2QPZpKJBOUUSHrxsVu9rDhbO/bgpDp?=
 =?us-ascii?Q?QMAUzAhdsSWNNv4UnYtbHdYjJEu3LRmkTmJZyqMRxAMwpl/R8Fhb0N489Fqi?=
 =?us-ascii?Q?X5RkqgSaBJavOTwPPkpG6ZfxsGqzy0gKwmKFMGXFTKvjO507vSVDecNCzgi7?=
 =?us-ascii?Q?6+RiJ4bk/Pmb0uOR29BM1n2QvUbMcGSGfkmW7Pgsi3edEOFTYNaPtISqW91d?=
 =?us-ascii?Q?46E3VJ2YTIA4cwf3dvA7OK1fUk63PmlOXWe58nkMSPt9JMUIhyAS8CQZo55E?=
 =?us-ascii?Q?crfiRuVOuCieh5p2hjb56vg/R5aHAi8UgUnNIAsUM66W/gkMSZ8uHIYyiaMR?=
 =?us-ascii?Q?3I0agu2pOXF0vbpMisp7bB/4AeR0j8GgWsQWqkmfl3vLMz6hdimWQy4x7DA/?=
 =?us-ascii?Q?UJ/4HiWstXyKaomv98GkETbBaBdrVp46r95KZPV3SDcku1LS4xH6CuM7KnsS?=
 =?us-ascii?Q?J7/S18++2i0fKgLQD+NR4rMC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6cd04f6-2030-4a4c-7d9a-08d97b392039
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2021 06:45:53.1635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o9pefL89b4L9UvLiO9IGEeeFmEyfDBzME7WYM8RBXviCrhhVn0QT57wo/gj6JXJ+u791Fg8kICGQlEGyJx6ifg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5593
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Sunday, September 19, 2021 2:38 PM
[...]
> [Series Overview]
>
> * Basic skeleton:
>   0001-iommu-iommufd-Add-dev-iommu-core.patch
>=20
> * VFIO PCI creates device-centric interface:
>   0002-vfio-Add-device-class-for-dev-vfio-devices.patch
>   0003-vfio-Add-vfio_-un-register_device.patch
>   0004-iommu-Add-iommu_device_get_info-interface.patch
>   0005-vfio-pci-Register-device-to-dev-vfio-devices.patch
>=20
> * Bind device fd with iommufd:
>   0006-iommu-Add-iommu_device_init-exit-_user_dma-interface.patch
>   0007-iommu-iommufd-Add-iommufd_-un-bind_device.patch
>   0008-vfio-pci-Add-VFIO_DEVICE_BIND_IOMMUFD.patch
>=20
> * IOASID allocation:
>   0009-iommu-Add-page-size-and-address-width-attributes.patch
>   0010-iommu-iommufd-Add-IOMMU_DEVICE_GET_INFO.patch
>   0011-iommu-iommufd-Add-IOMMU_IOASID_ALLOC-FREE.patch
>   0012-iommu-iommufd-Add-IOMMU_CHECK_EXTENSION.patch
>=20
> * IOASID [de]attach:
>   0013-iommu-Extend-iommu_at-de-tach_device-for-multiple-de.patch
>   0014-iommu-iommufd-Add-iommufd_device_-de-attach_ioasid.patch
>   0015-vfio-pci-Add-VFIO_DEVICE_-DE-ATTACH_IOASID.patch
>=20
> * DMA (un)map:
>   0016-vfio-type1-Export-symbols-for-dma-un-map-code-sharin.patch
>   0017-iommu-iommufd-Report-iova-range-to-userspace.patch
>   0018-iommu-iommufd-Add-IOMMU_-UN-MAP_DMA-on-IOASID.patch
>=20
> * Report the device info in vt-d driver to enable whole series:
>   0019-iommu-vt-d-Implement-device_info-iommu_ops-callback.patch
>=20
> * Add doc:
>   0020-Doc-Add-documentation-for-dev-iommu.patch

Please refer to the above patch overview. sorry for the duplicated contents=
.

thanks,
Yi Liu
