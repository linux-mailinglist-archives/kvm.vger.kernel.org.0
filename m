Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEC541BCBD
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 04:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243735AbhI2CbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 22:31:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:55537 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242877AbhI2CbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 22:31:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224501845"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="224501845"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 19:29:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="456852609"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 28 Sep 2021 19:29:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 19:29:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 28 Sep 2021 19:29:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 28 Sep 2021 19:29:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvX6HKEHcHyByyvPNJf8SBONr4sT4YAFyl03H7+oVffNZn+efWuW1dhFnO3TDHwi591lBFdiaAvGd6qI/SyO4qjGpaYbZiAihiBGdKzDNWMjzReTmv41A7rI1KYdDf+uKDdwhrNxnEkJ/i9Qi8HcZDpg3zYTND+xnFHG9p0KuUvVgE+vyCUtYNILu8ifkP6os80H2PalkgtagfEDS6G/TpzfzhK31BicHisqgprw2/W8Y/at4fjUfqLGpXXjkiNcJdHc2cGo2p5cugut6b4R8Ou80cJG5AbJXBGKyELtE5ZS7wKs9ghKElwpAr63mzhF23C1uVtJbNeef01P56GXsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ckcHQpvTNlEgl5V2dP2OoIHAUwxRSJmOiQnN2HZiOxU=;
 b=OdE1RYk+Z57oatqhB4vsEau607gkg2OrnDPqL4GzIzrY3VhHD/HbGRGQe2UEZnoFeNpl2n9L4kCctQMpk5bvjXKBQBMuLS7HeIqixv2oI/fCqlufVTvU2MIfzHAZKzeNRxUdPzFlU93bO1nCZl2BqxC/V1NOFhVQFl0Si3Pnwap7TGvtlV3VCDRvnFv5LOYpX2IzoeiJhW3MgZ7AOALfrm6/6xA0iybdAY5M0CPrtmxEEG1U2gvA5NKiNxxcuVx/IjRBo2ji5I49PzWq79jnz6aV+lAc6QB7ACouqVSDRvgLgH6JiaMRLNoiGwJ9M887ssFeY7/qklKcQNW1YFwNPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckcHQpvTNlEgl5V2dP2OoIHAUwxRSJmOiQnN2HZiOxU=;
 b=ENA23bwSxtAJK9dXATPIqc97yTOyzD6TeXXbtNvYSkq9LbKxj/6cQUsJ3UfuIvVAa+yoDUCNDS471RKqjpR2+xdeuu91DRn9B79WGPrr+Je8gD4UfrXVb5hjkrlVYvjh0ym2BbDnUil5DiaPdkjS6dvH34H8cCITACEF2e0xUJI=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1796.namprd11.prod.outlook.com (2603:10b6:404:103::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Wed, 29 Sep
 2021 02:29:18 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 02:29:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
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
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Topic: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Index: AQHXrSF9WDj+Z+DU+UqMJ7tQK2EdmauuvK2AgACKnbCAALw6gIAHYVYAgACkNwCAAQ1OQIAAT36AgAAbKoCAAAj5AIAAzVwAgAABm9A=
Date:   Wed, 29 Sep 2021 02:29:18 +0000
Message-ID: <BN9PR11MB54338527F3D400A559EE0B058CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927150928.GA1517957@nvidia.com>
 <BN9PR11MB54337B7F65B98C2335B806938CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210928115751.GK964074@nvidia.com>
 <9a314095-3db9-30fc-2ed9-4e46d385036d@linux.intel.com>
 <20210928140712.GL964074@nvidia.com>
 <4ba3294b-1628-0522-17ff-8aa38ed5a615@linux.intel.com>
In-Reply-To: <4ba3294b-1628-0522-17ff-8aa38ed5a615@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64f1f41b-19a2-4189-01bf-08d982f0f07e
x-ms-traffictypediagnostic: BN6PR11MB1796:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB17967A875A8A29D1CB1E96C78CA99@BN6PR11MB1796.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hFd/7VjvnVzy7gye8MYZb7uCvTWXNtSunuwbttbf4yc+yiDSiIYhpdYgSG8fMYhE+703aenZSquM6YOJHh8XIDX3ClHHyrK1dtVzvUux71jmtXd7vmU46wU6ynxBzuDaDoQ2dPpCvPIqIVgqgKTI7h6ucdKitoQ7+AimmVpbtjI2eigHJO1jWF/nSrl0RZxnufvp51timnHLvKSNbwoHTKDOZYAiD29KGfS4LbOZny86UytzL0YJ0N6PaIiGVzIkl8VjliJh4Uoa/KTjUbthi7uA1hEzmtVDP7KRMZWuVJDCk37RNgVnpsDSOEXlRzBHuwEU+eiG5yQX/nBvbJWWKF6QKAHCLCPXVnWacD2Ql2o//FPH9NgdOUEu5oCjWyGCDmgSKG7tOAl4rkMLSDzd/DxErgVv6b0ZsrJ1Mx9WWk1uLKwVe4ldnD1Plu2mWzLjKBAsGU60yjIqoM6+p+paS6xzYNPl8bV+/mwXJpPiOgdzRhmYhM2a+U0xa84TyDtAAHFGSFz1wNCgam0U/7H+SvqxmkzR1S8VxCN3f/xD6pcpRFAgjCSnbPxXdIAXUOD9FJO7y3xwzSTqhGOB7Pi0naKb05GgM00fm3QuKOXGUy0DwYtVuI2PcLdr2IJG3YwVSPK1lvUaGQM5ydm+2v6NwPVaJ7aqIwza6rfCuvZrZcaUg0g+7HEtkdp/5hTB6ZxCVFFC3jFVnpKN01wVaqtXIPciki1BpUuG+4vVagk948W55fDqIbCTHfP4kH07PXCGFih4c1KyKP06gATYVT6U6adeGJcPvsRB6tUCZo9vVBQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(8936002)(122000001)(38100700002)(26005)(186003)(2906002)(83380400001)(86362001)(966005)(38070700005)(508600001)(64756008)(66476007)(71200400001)(6506007)(52536014)(55016002)(66446008)(54906003)(4326008)(76116006)(316002)(7696005)(110136005)(66556008)(66946007)(33656002)(9686003)(7416002)(53546011)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RktSNTdReWlBbzcrMnR4SXovWGtsYWhvblRnRjkrNUZ6bzd4S1YwaWhxYVFr?=
 =?utf-8?B?b2VydE1CT1Bkejh5azlocVBRcWpLd2hHZnFBRkhOZHd4Um1IMk9kZFZlWHZY?=
 =?utf-8?B?bnh2NWQwdlN1TzVRdVB6NkpXMEgxdWdndjF0OVJYWTl3YzJxMTRyWmxuTEhB?=
 =?utf-8?B?M1JvS3hGeDhMZ2Vudk9DQ3VOdG43Y3FRbVh0WkhkeXdBaVZ6NFYwN0dNZ0c1?=
 =?utf-8?B?V2tELyt0NnFkMlZWRzFtZGdoWE9mSU1rZWsxaW9hUFJ3eE9qM2loTlpMYWp0?=
 =?utf-8?B?MHVoQ3QySlRucEJFdVRJQjhEUjVFK0JCOWgwdFJmSTY3Zm45UElYU3Y3ajdX?=
 =?utf-8?B?YkNDa21Vd0Y1eFdXN3NIT3lndWYzTTVjTkQzNi9TM3gxVzliL201WGhrdlVS?=
 =?utf-8?B?V296WXRYcHJKUERMU1JMTXNqREFpWm9PNXZJSmJkMWNxY05lZzkzSEsycG5h?=
 =?utf-8?B?QWNacDZ3RkQ2T0NrNTE2SFI3RDhqaUlqbThzVTk4RE5HdnVFVVlLL0ZiQUpF?=
 =?utf-8?B?dEZCc0VKbnZucjlMeWdyWEtMelZ4OHo0V1AvMTU3ajN5Z0NDb2tSdTZ1U2ZI?=
 =?utf-8?B?Wk83US94U2NBY3FQTW9qTlJ5T2V5dEdicnBOSmlab3l5WDJpcW9SVGYrWS9U?=
 =?utf-8?B?WkJJM25Pb2Z4dHdTUGhhbUxQQ0NFaFoxN3RWVDVWemxNdmpnMmR5NWxJZTB0?=
 =?utf-8?B?NWh3UStBcFgrUUNOL2h0bmVuMXA2VEJoaTJzb1FQaUZDVEJKRTcvTkY2OFhp?=
 =?utf-8?B?aElObUVHUjFNcUd4Z3pyZ0hMZDZKNmNlQUFkU0V3RFhTOUJVM3ZPMDIyUXEx?=
 =?utf-8?B?aUp1bjJEeHkwRHowQ2xtblAxbkNac050bjQ2TXZubks2R2t2enNkWWJOUHZY?=
 =?utf-8?B?L1JmTVpQWExhT0N6d1hFdGkzcDRkazhFZkRpUVF5VG4xSThENVY1ZWpac2dv?=
 =?utf-8?B?YlhiWm9rZ2R6dFd2blhTVzdNM2hWbWdKRFhXN0RMTDVLeW13RGNqVjdibGF5?=
 =?utf-8?B?bFpNeno2R1EremhmVndOTEphMXVJZUVXNUs1ZE54QjZHRnMzREhjVW9mcEZ2?=
 =?utf-8?B?TVpJaXVzaXBLUVJJaU50R1QrUHZzSGlRbTVqOThXcFJLZytmcGl2U3pRMFJE?=
 =?utf-8?B?YkNTN0I5b2ZyTGhrcmZ0djlaOExjTWtlcGFqU1pueklmbzZ6L09yU2ZvYmVz?=
 =?utf-8?B?dXEyS1pqeGZUckpsZXdSTTVjSzkwc3EycEtRdkpZa1huWEZmQ2c4MEltNEJy?=
 =?utf-8?B?QUwzSEhHZ3NmbFh3WHBEWTV6clNPalkzajZqbVBxSWNpOWl2RkZuSjBETEVD?=
 =?utf-8?B?UTJZK0pMb2dEQWVkbmEzTFo5ZTlORG5KU0U3eXltQmpndGtGWlRSUndzUDE0?=
 =?utf-8?B?b1BiYUNnMVQ3N1Frdk5pdU4wSXZzRHZuWlYwTll6RUJneHhYbjUyRlNGTTV6?=
 =?utf-8?B?d3JMdyt0bUJZeWxtZUtMcFF3TklZWkducDBRcnpKdlNXV3N6czVUeEU4d3Z3?=
 =?utf-8?B?Q1lITW5KajdpdGE0Kzg1bmUzcFphdHBOMGNzckJqT0pyWTlEa25QNnpLZG1i?=
 =?utf-8?B?aDFhRWMrODNNdEZzZUNMMDlMWVdvTTFLRWtHT0xXdDV1R01Lay9rLzZKbllN?=
 =?utf-8?B?WVNsOVl1dmM1S2MxOUdXYm5pOXBpdW1NeG5FSTdrMWh5MUNtSldxclpEbm8z?=
 =?utf-8?B?S1l2bkR0SjJteTZZdEdpT2tLWFZGRTZ5UkkwcVY5K1JLQmtmaDkvckxVazRD?=
 =?utf-8?Q?FAUOTXl9FJhwzom7Kxx48vkUxjZuuXPqdCIbd/S?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f1f41b-19a2-4189-01bf-08d982f0f07e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 02:29:18.5330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Fx33jgAfGGA4fq6MWfwjgVBkdqC9XMVIeK2d8A/6FyjpnYoc8SSYNOdm4A3J8Az91kmK/bhLUk6CqOM/6Bo+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1796
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIFNlcHRlbWJlciAyOSwgMjAyMSAxMDoyMiBBTQ0KPiANCj4gT24gOS8yOC8yMSAxMDow
NyBQTSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+IE9uIFR1ZSwgU2VwIDI4LCAyMDIxIGF0
IDA5OjM1OjA1UE0gKzA4MDAsIEx1IEJhb2x1IHdyb3RlOg0KPiA+PiBBbm90aGVyIGlzc3VlIGlz
LCB3aGVuIHB1dHRpbmcgYSBkZXZpY2UgaW50byB1c2VyLWRtYSBtb2RlLCBhbGwgZGV2aWNlcw0K
PiA+PiBiZWxvbmdpbmcgdG8gdGhlIHNhbWUgaW9tbXUgZ3JvdXAgc2hvdWxkbid0IGJlIGJvdW5k
IHdpdGggYSBrZXJuZWwtDQo+IGRtYQ0KPiA+PiBkcml2ZXIuIEtldmluJ3MgcHJvdG90eXBlIGNo
ZWNrcyB0aGlzIGJ5IFJFQURfT05DRShkZXYtPmRyaXZlcikuIFRoaXMgaXMNCj4gPj4gbm90IGxv
Y2sgc2FmZSBhcyBkaXNjdXNzZWQgYmVsb3csDQo+ID4+DQo+ID4+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xpbnV4LQ0KPiBpb21tdS8yMDIxMDkyNzEzMDkzNS5HWjk2NDA3NEBudmlkaWEuY29t
Lw0KPiA+Pg0KPiA+PiBBbnkgZ3VpZGFuY2Ugb24gdGhpcz8NCj4gPg0KPiA+IFNvbWV0aGluZyBs
aWtlIHRoaXM/DQo+ID4NCj4gPg0KPiA+IGludCBpb21tdV9zZXRfZGV2aWNlX2RtYV9vd25lcihz
dHJ1Y3QgZGV2aWNlICpkZXYsIGVudW0NCj4gZGV2aWNlX2RtYV9vd25lciBtb2RlLA0KPiA+IAkJ
CSAgICAgICBzdHJ1Y3QgZmlsZSAqdXNlcl9vd25lcikNCj4gPiB7DQo+ID4gCXN0cnVjdCBpb21t
dV9ncm91cCAqZ3JvdXAgPSBncm91cF9mcm9tX2RldihkZXYpOw0KPiA+DQo+ID4gCXNwaW5fbG9j
aygmaW9tbXVfZ3JvdXAtPmRtYV9vd25lcl9sb2NrKTsNCj4gPiAJc3dpdGNoIChtb2RlKSB7DQo+
ID4gCQljYXNlIERNQV9PV05FUl9LRVJORUw6DQo+ID4gCQkJaWYgKGlvbW11X2dyb3VwLQ0KPiA+
ZG1hX3VzZXJzW0RNQV9PV05FUl9VU0VSU1BBQ0VdKQ0KPiA+IAkJCQlyZXR1cm4gLUVCVVNZOw0K
PiA+IAkJCWJyZWFrOw0KPiA+IAkJY2FzZSBETUFfT1dORVJfU0hBUkVEOg0KPiA+IAkJCWJyZWFr
Ow0KPiA+IAkJY2FzZSBETUFfT1dORVJfVVNFUlNQQUNFOg0KPiA+IAkJCWlmIChpb21tdV9ncm91
cC0NCj4gPmRtYV91c2Vyc1tETUFfT1dORVJfS0VSTkVMXSkNCj4gPiAJCQkJcmV0dXJuIC1FQlVT
WTsNCj4gPiAJCQlpZiAoaW9tbXVfZ3JvdXAtPmRtYV9vd25lcl9maWxlICE9IHVzZXJfb3duZXIp
IHsNCj4gPiAJCQkJaWYgKGlvbW11X2dyb3VwLQ0KPiA+ZG1hX3VzZXJzW0RNQV9PV05FUl9VU0VS
U1BBQ0VdKQ0KPiA+IAkJCQkJcmV0dXJuIC1FUEVSTTsNCj4gPiAJCQkJZ2V0X2ZpbGUodXNlcl9v
d25lcik7DQo+ID4gCQkJCWlvbW11X2dyb3VwLT5kbWFfb3duZXJfZmlsZSA9DQo+IHVzZXJfb3du
ZXI7DQo+ID4gCQkJfQ0KPiA+IAkJCWJyZWFrOw0KPiA+IAkJZGVmYXVsdDoNCj4gPiAJCQlzcGlu
X3VubG9jaygmaW9tbXVfZ3JvdXAtPmRtYV9vd25lcl9sb2NrKTsNCj4gPiAJCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gPiAJfQ0KPiA+IAlpb21tdV9ncm91cC0+ZG1hX3VzZXJzW21vZGVdKys7DQo+ID4g
CXNwaW5fdW5sb2NrKCZpb21tdV9ncm91cC0+ZG1hX293bmVyX2xvY2spOw0KPiA+IAlyZXR1cm4g
MDsNCj4gPiB9DQo+ID4NCj4gPiBpbnQgaW9tbXVfcmVsZWFzZV9kZXZpY2VfZG1hX293bmVyKHN0
cnVjdCBkZXZpY2UgKmRldiwNCj4gPiAJCQkJICAgZW51bSBkZXZpY2VfZG1hX293bmVyIG1vZGUp
DQo+ID4gew0KPiA+IAlzdHJ1Y3QgaW9tbXVfZ3JvdXAgKmdyb3VwID0gZ3JvdXBfZnJvbV9kZXYo
ZGV2KTsNCj4gPg0KPiA+IAlzcGluX2xvY2soJmlvbW11X2dyb3VwLT5kbWFfb3duZXJfbG9jayk7
DQo+ID4gCWlmIChXQVJOX09OKCFpb21tdV9ncm91cC0+ZG1hX3VzZXJzW21vZGVdKSkNCj4gPiAJ
CWdvdG8gZXJyX3VubG9jazsNCj4gPiAJaWYgKCFpb21tdV9ncm91cC0+ZG1hX3VzZXJzW21vZGVd
LS0pIHsNCj4gPiAJCWlmIChtb2RlID09IERNQV9PV05FUl9VU0VSU1BBQ0UpIHsNCj4gPiAJCQlm
cHV0KGlvbW11X2dyb3VwLT5kbWFfb3duZXJfZmlsZSk7DQo+ID4gCQkJaW9tbXVfZ3JvdXAtPmRt
YV9vd25lcl9maWxlID0gTlVMTDsNCj4gPiAJCX0NCj4gPiAJfQ0KPiA+IGVycl91bmxvY2s6DQo+
ID4gCXNwaW5fdW5sb2NrKCZpb21tdV9ncm91cC0+ZG1hX293bmVyX2xvY2spOw0KPiA+IH0NCj4g
Pg0KPiA+DQo+ID4gV2hlcmUsIHRoZSBkcml2ZXIgY29yZSBkb2VzIGJlZm9yZSBwcm9iZToNCj4g
Pg0KPiA+ICAgICBpb21tdV9zZXRfZGV2aWNlX2RtYV9vd25lcihkZXYsIERNQV9PV05FUl9LRVJO
RUwsIE5VTEwpDQo+ID4NCj4gPiBwY2lfc3R1Yi9ldGMgZG9lcyBpbiB0aGVpciBwcm9iZSBmdW5j
Og0KPiA+DQo+ID4gICAgIGlvbW11X3NldF9kZXZpY2VfZG1hX293bmVyKGRldiwgRE1BX09XTkVS
X1NIQVJFRCwgTlVMTCkNCj4gPg0KPiA+IEFuZCB2ZmlvL2lvbW1mZCBkb2VzIHdoZW4gYSBzdHJ1
Y3QgdmZpb19kZXZpY2UgRkQgaXMgYXR0YWNoZWQ6DQo+ID4NCj4gPiAgICAgaW9tbXVfc2V0X2Rl
dmljZV9kbWFfb3duZXIoZGV2LCBETUFfT1dORVJfVVNFUlNQQUNFLA0KPiBncm91cF9maWxlL2lv
bW11X2ZpbGUpDQo+IA0KPiBSZWFsbHkgZ29vZCBkZXNpZ24uIEl0IGFsc28gaGVscHMgYWxsZXZp
YXRpbmcgc29tZSBwYWlucyBlbHNld2hlcmUgaW4NCj4gdGhlIGlvbW11IGNvcmUuDQo+IA0KPiBK
dXN0IGEgbml0IGNvbW1lbnQsIHdlIGFsc28gbmVlZCBETUFfT1dORVJfTk9ORSB3aGljaCB3aWxs
IGJlIHNldA0KPiB3aGVuDQo+IHRoZSBkcml2ZXIgY29yZSB1bmJpbmRzIHRoZSBkcml2ZXIgZnJv
bSB0aGUgZGV2aWNlLg0KPiANCg0KTm90IG5lY2Vzc2FyaWx5LiBOT05FIGlzIHJlcHJlc2VudGVk
IGJ5IG5vbmUgb2YgZG1hX3VzZXJbbW9kZV0NCmlzIHZhbGlkLg0K
