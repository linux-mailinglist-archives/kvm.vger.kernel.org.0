Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D693B6BD0
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 02:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhF2AqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 20:46:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:17485 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhF2AqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 20:46:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="208099280"
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="208099280"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 17:43:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="475767021"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jun 2021 17:43:18 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 17:43:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 28 Jun 2021 17:43:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 28 Jun 2021 17:43:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELdp3pzTkzVMJ2t8v6HK6PbeC6ekk5v/8+kcMtllWTzNenNGj4RKqYtnz01dDJVt0Ul1POMWWRqBFUjKH7ajen4saVWH8fNbW8ZgljzrhcuQ13jLueU1LDnR+yJvI5ra0U9ehtviuK6YvZtcKqd3pd0xBiiTkYPAdwJ6NijxiovhpQ8EFf18QMjEMltaj1X1OHCSdzclO1UoYe9qaYM3cov96xjb1Ul2Z8sopoCASErGXkCkL3GgHwr3SEEUDvoRcxNsd4dh5hZ3zcWLJ9MDqmSh6nt5Zi6fQXloRdItSV5KBuPL8EDTzipm7yQFobKnJgqeb0KhK1Ku3iqAp39V0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WiZCcMOrEbnk7qYQh2bgYBtm1AcotFrXseAf92YsLgI=;
 b=Zw2ZjopQR7knXyB6ES/A/QUZXZkHOLf1qNGNyfFAGsuGmRIWJMwlrSGNtY33Orox2i0fkw78K3ESOnaijZg+c05XU0IYj29vcs9UrZSIVQJAHfUoLCVDYAiA6RsQTK5Mc7pvycr/ikNJ/AFG8jiXIBH2dtkdZ0rl9kgf8xOmKJaNbI/1r2jjhXiRRXxas21zK9MTvWEbv7MDnqtgv6NgmIwGZUEDnbSbfMXk39FYEK7WByuaNH7IWWBTOjswHlUgB6ebeb7K43cTnGhV2SSai5gHroqEeqVjyKO1zjAMcyvoH6cH+G2QuAjO53UK+4jXNehF04HuCZmYJr8iE25v+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WiZCcMOrEbnk7qYQh2bgYBtm1AcotFrXseAf92YsLgI=;
 b=oKo36s8a5/wh242gbtok5W5WkvDkbCDhGP/9VhPKhkh7LLSLHLLSSRRDlsHBVXHZxbNEapITBqDvQwCYKuVXkvuszbizE0BskU1pWsihEfVYElod8YESXurWYoitlGrMaxO9UNBVGQZ49aANehfaEbdRmUpfT2OOYuw1jhGCEdE=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2148.namprd11.prod.outlook.com (2603:10b6:405:52::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Tue, 29 Jun
 2021 00:43:08 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a%5]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 00:43:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAA0n7GAAAYKlwAADDvuAAAgbLGAAF6lSYAABO0WAAATSRtQAB5ymYAAEyKHQAAmZhSAAAo/ocAAK16TAAAGdqAAACJdiVAAA3a7AAEa314AAD0+zwAAeWnuUAAuEQiAAAQVJyA=
Date:   Tue, 29 Jun 2021 00:43:08 +0000
Message-ID: <BN9PR11MB54338D6126FE1D241F76E1948C029@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210615101215.4ba67c86.alex.williamson@redhat.com>
        <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210616133937.59050e1a.alex.williamson@redhat.com>
        <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210617151452.08beadae.alex.williamson@redhat.com>
        <20210618001956.GA1987166@nvidia.com>
        <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210618182306.GI1002214@nvidia.com>
        <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210625143616.GT2371267@nvidia.com>
        <BN9PR11MB5433D40116BC1939B6B297EA8C039@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210628163145.1a21cca9.alex.williamson@redhat.com>
In-Reply-To: <20210628163145.1a21cca9.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.71.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f70bc13a-552e-4028-305b-08d93a96dda9
x-ms-traffictypediagnostic: BN6PR1101MB2148:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2148DB8890C082398B8339CB8C029@BN6PR1101MB2148.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GJ8dd5ArxL7RhXx3qx4Fur+wGAbFRZy4EYZUmj755TDtRl7AaA6Q+zNlUdsoEihd1XanZhWiZlKp6AJcVb+sxXdy2s2RpkFe7Oy3lGvfe0u+OYps6bDa+RKLyyJZzJPxDhnItEpsimjBluEDm3RPdFWeknaf4TN2CuSLVbQsj/TAYfirk076ITfyEMrxpsq09cSDv7zO4YpRSS6D0N9mqjNDFR0cvdThD3PMOSJEINWuWmmvkiCDMTiWV0c1qPuWyp15xQga9eEKYbFQPW+ZEJd/qNFSGq4R3g7mGcyf/hl4cG1XSrVbYjvUDjmsSNss67Jh5jQMUrMGJKavKXykUZ05DIzImDDG05YM2VIyJ0RK1hiDruJ0c8xBCZ5Cdl6XIuufZJj43BcUla0PAPeZaxVyNot6/l7cTjC+hp2YqJkdCOjDfsikuSDPxIbjzOSDxeclBffRVWv0z+0b4RGjO1qWqtMExVkotks/DNGi7gVdrwkoHRXOmiXvfRE0h1wnmYJLGmDwhJSRULJ8nbmYg/SHwUEw86caR8VaeTTtTY+og7BDDr+JQzvycAUu0ABvDcgb/WJMxYvjxz7WV4NKoEjOLKoumno0H2zJvIMHjQ96OT6AZRUns/dY8YRxa7/I7AXg0coIzoTNmC2NPmOVGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(366004)(39860400002)(346002)(6506007)(6916009)(33656002)(5660300002)(8936002)(86362001)(478600001)(71200400001)(52536014)(8676002)(7416002)(83380400001)(66476007)(38100700002)(7696005)(66946007)(316002)(9686003)(76116006)(54906003)(64756008)(55016002)(122000001)(2906002)(26005)(4326008)(186003)(66556008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1UyWER6TWZGcGZBeUcxcjlES2JWNkx2WC9PQ3ZQM0JIVnJuZWFhR0Nld1I2?=
 =?utf-8?B?ek9NeUxmL2pyemNPSlhHMDdlTmVqckovTlJyL1FmbUJPVDlpTDBHNmJnVGRD?=
 =?utf-8?B?ejdIM2g5Y2lFRXp5QnpOSVBLd2VydTcxWkNRY08yRVAyd05tRW9KaFFSWURo?=
 =?utf-8?B?eHppc2s5bm5PSk1abmIvN2FlSmY1Q0p3K1Zsc1p2dkpBdzh4ZFZySGtlNWZo?=
 =?utf-8?B?NVNTQ2M4NFA1M3N5Si9sa0s2SFQydFlaUWRMeDRIbHdweWs4bmxaOWZja0hw?=
 =?utf-8?B?MHdMTUpxanZBRjhCNnlEOVJHNjZyYlpvZlNHNHVoV0pVUFpkRkQvNWREbDRL?=
 =?utf-8?B?MUFWS0xXYXYwME1PLzQ3Sk1sUjJVaVJWdS9pVzEvYkZVemtPUXBmY016Nndr?=
 =?utf-8?B?ZEEwYWpCaGc4TTlwTlp2YS9JS1NoblhDSzZiK3RVK3QvTWRqVUpsblZ5bWR6?=
 =?utf-8?B?Uyt2RENJR0RDT2UrQnpyaGFFOEpadWJFWU85d1Z0QVc4L3I3UWFuUnN4WnBU?=
 =?utf-8?B?QmdWQkJITzlIVDhzQzhYTXpoYVY4Nm9VVGtoSGplV0lFT0U3RG5YdGVMcmtU?=
 =?utf-8?B?RFpseS94TC83WmZpUm1SYXNveHV2bXNKRVRSZzFoQVBGbzcvd1hIVjVsUFl6?=
 =?utf-8?B?R1pHV3hxVVJhRGNXNHNocU50ZWdBanZUcUhqTEdpbG5iSFB3SjNlRkdFYjdv?=
 =?utf-8?B?MVh3SnpVRmk2czFkcXoyaUk2YWs3ZElNaWlNU1lFTkN6ZzRyMkR4M0hYcFo2?=
 =?utf-8?B?UmZ3SGV2ZXA0OWJLNFZFaWhQTjlWSzc0dWszVmFmNm5jQzZyVHFGMnVKMXQx?=
 =?utf-8?B?WlN3ZXVmTlUvMng0U1NscUdEUTZzWXR2NzlKZTF4b1l3aVo0SnJLOEoveTdH?=
 =?utf-8?B?V1BQMjRTQ2ZiQ0J2UDZBaU1WZWswbGlLcUxURDVGcGcyUDdiYVV2T0ZFSkZh?=
 =?utf-8?B?STl0ckQ0WVUxYmNoRUZWMDUxc2N4TUhPMTFOekgzdGJ4RXk5UzR6QlVJY3JV?=
 =?utf-8?B?bW55ME1GYjVIdktyU1dpcE1lM1BHcE9NbXQ4aThidWpYaGdHVjVYRDBmQk9x?=
 =?utf-8?B?UUVnaHZOSjJhNmpKbDlhODFNU1JmRnZuZytEUXFVN3ZxdFIwekU0TFB5ZnUr?=
 =?utf-8?B?L2tZY0xLdGxMMG53WHNWRTJRNWNsY2FIM3pjeEJSR3lnanNWZWJBWW1EZUMy?=
 =?utf-8?B?R2E0d2o2WERrc3ZRakcrcjZ0S1I2Z2ExVmo2cVkyM29rYkVYWU9HZGFsZXRJ?=
 =?utf-8?B?NGZUK1MwdTNWeUw3Z3ZzNFlEUVZkSG5LRWlsSmhYTVdLN0RqZXlPNnRsdlVV?=
 =?utf-8?B?QjBjc1FRS3Z4ZjU0ZFJEZWdCamkxaDM2RU1lSEdxMDQ4V3VXNTV2MDhrdDFY?=
 =?utf-8?B?YVdwdmdNWDBFSmdiVkFNelZtaW5NZ0pUc3JwQTFpc0ZiR2wzZW80K1RiWSt4?=
 =?utf-8?B?UkNvMk9HbkpTWHhmY1NjTkJpNUVBbm41V25lQWlsNHQ5SXh4QU40dStscXJ6?=
 =?utf-8?B?dU84bnlFNUgwT3FzV3k1d29BdHhaMVFOOVgzaTlZZkRneEVXb0JpZGYzUWVH?=
 =?utf-8?B?VG1ubUJGQ1ZmZ2VRZjlsS2luc2kwU0Y4ME1RNFZDZ0wxa1ZNTGNGT2phcS9o?=
 =?utf-8?B?KzVWOFl5U0h5T0c1V0kyOVZWYmdFZEgvMkdJWHB1ZEdPQktiWFRwWElSZms3?=
 =?utf-8?B?Ri8wbTdhbWNSOG1nVUcyaS9FMGtQa20ydkprY1VQc1A3eGtxWUhFTWF5SDVi?=
 =?utf-8?Q?Jq0qOKBUFG/f7ZbTY761JWUq6Rs08nS9TiVhpu5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f70bc13a-552e-4028-305b-08d93a96dda9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2021 00:43:08.7197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ctvDHQtXdKROaTZmZclqXF6HBHz/Cpr0OxM+gUwP/2eA8NZXFWZzy06QfuYW76AIr9Vgw0WmFRpGV9bgwxWaog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2148
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBKdW5lIDI5LCAyMDIxIDY6MzIgQU0NCj4gDQo+IE9uIE1vbiwgMjggSnVu
IDIwMjEgMDE6MDk6MTggKzAwMDANCj4gIlRpYW4sIEtldmluIiA8a2V2aW4udGlhbkBpbnRlbC5j
b20+IHdyb3RlOg0KPiANCj4gPiA+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5j
b20+DQo+ID4gPiBTZW50OiBGcmlkYXksIEp1bmUgMjUsIDIwMjEgMTA6MzYgUE0NCj4gPiA+DQo+
ID4gPiBPbiBGcmksIEp1biAyNSwgMjAyMSBhdCAxMDoyNzoxOEFNICswMDAwLCBUaWFuLCBLZXZp
biB3cm90ZToNCj4gPiA+DQo+ID4gPiA+IC0gICBXaGVuIHJlY2VpdmluZyB0aGUgYmluZGluZyBj
YWxsIGZvciB0aGUgMXN0IGRldmljZSBpbiBhIGdyb3VwLA0KPiBpb21tdV9mZA0KPiA+ID4gPiAg
ICAgY2FsbHMgaW9tbXVfZ3JvdXBfc2V0X2Jsb2NrX2RtYShncm91cCwgZGV2LT5kcml2ZXIpIHdo
aWNoIGRvZXMNCj4gPiA+ID4gICAgIHNldmVyYWwgdGhpbmdzOg0KPiA+ID4NCj4gPiA+IFRoZSB3
aG9sZSBwcm9ibGVtIGhlcmUgaXMgdHJ5aW5nIHRvIG1hdGNoIHRoaXMgbmV3IHdvcmxkIHdoZXJl
IHdlIHdhbnQNCj4gPiA+IGRldmljZXMgdG8gYmUgaW4gY2hhcmdlIG9mIHRoZWlyIG93biBJT01N
VSBjb25maWd1cmF0aW9uIGFuZCB0aGUgb2xkDQo+ID4gPiB3b3JsZCB3aGVyZSBncm91cHMgYXJl
IGluIGNoYXJnZS4NCj4gPiA+DQo+ID4gPiBJbnNlcnRpbmcgdGhlIGdyb3VwIGZkIGFuZCB0aGVu
IGNhbGxpbmcgYSBkZXZpY2UtY2VudHJpYw0KPiA+ID4gVkZJT19HUk9VUF9HRVRfREVWSUNFX0ZE
X05FVyBkb2Vzbid0IHNvbHZlIHRoaXMgY29uZmxpY3QsIGFuZCBpc24ndA0KPiA+ID4gbmVjZXNz
YXJ5Lg0KPiA+DQo+ID4gTm8sIHRoaXMgd2FzIG5vdCB3aGF0IEkgbWVhbnQuIFRoZXJlIGlzIG5v
IGdyb3VwIGZkIHJlcXVpcmVkIHdoZW4NCj4gPiBjYWxsaW5nIHRoaXMgZGV2aWNlLWNlbnRyaWMg
aW50ZXJmYWNlLiBJIHdhcyBhY3R1YWxseSB0YWxraW5nIGFib3V0Og0KPiA+DQo+ID4gCWlvbW11
X2dyb3VwX3NldF9ibG9ja19kbWEoZGV2LT5ncm91cCwgZGV2LT5kcml2ZXIpDQo+ID4NCj4gPiBq
dXN0IGJlY2F1c2UgY3VycmVudCBpb21tdSBsYXllciBBUEkgaXMgZ3JvdXAtY2VudHJpYy4gV2hl
dGhlciB0aGlzDQo+ID4gc2hvdWxkIGJlIGltcHJvdmVkIGNvdWxkIGJlIG5leHQtbGV2ZWwgdGhp
bmcuIFNvcnJ5IGZvciBub3QgbWFraW5nDQo+ID4gaXQgY2xlYXIgaW4gdGhlIGZpcnN0IHBsYWNl
Lg0KPiA+DQo+ID4gPiBXZSBjYW4gYWx3YXlzIGdldCB0aGUgZ3JvdXAgYmFjayBmcm9tIHRoZSBk
ZXZpY2UgYXQgYW55DQo+ID4gPiBwb2ludCBpbiB0aGUgc2VxdWVuY2UgZG8gdG8gYSBncm91cCB3
aWRlIG9wZXJhdGlvbi4NCj4gPg0KPiA+IHllcy4NCj4gPg0KPiA+ID4NCj4gPiA+IFdoYXQgSSBz
YXcgYXMgdGhlIGFwcGVhbCBvZiB0aGUgc29ydCBvZiBpZGVhIHdhcyB0byBqdXN0IGNvbXBsZXRl
bHkNCj4gPiA+IGxlYXZlIGFsbCB0aGUgZGlmZmljdWx0IG11bHRpLWRldmljZS1ncm91cCBzY2Vu
YXJpb3MgYmVoaW5kIG9uIHRoZSBvbGQNCj4gPiA+IGdyb3VwIGNlbnRyaWMgQVBJIGFuZCB0aGVu
IHdlIGRvbid0IGhhdmUgdG8gZGVhbCB3aXRoIHRoZW0gYXQgYWxsLCBvcg0KPiA+ID4gbGVhc3Qg
bm90IHJpZ2h0IGF3YXkuDQo+ID4NCj4gPiB5ZXMsIHRoaXMgaXMgdGhlIHN0YWdlZCBhcHByb2Fj
aCB0aGF0IHdlIGRpc2N1c3NlZCBlYXJsaWVyLiBhbmQNCj4gPiB0aGUgcmVhc29uIHdoeSBJIHJl
ZmluZWQgdGhpcyBwcm9wb3NhbCBhYm91dCBtdWx0aS1kZXZpY2VzIGdyb3VwDQo+ID4gaGVyZSBp
cyBiZWNhdXNlIHlvdSB3YW50IHRvIHNlZSBzb21lIGNvbmZpZGVuY2UgYWxvbmcgdGhpcw0KPiA+
IGRpcmVjdGlvbi4gVGh1cyBJIGV4cGFuZGVkIHlvdXIgaWRlYSBhbmQgaG9wZSB0byBhY2hpZXZl
IGNvbnNlbnN1cw0KPiA+IHdpdGggQWxleC9Kb2VyZyB3aG8gb2J2aW91c2x5IGhhdmUgbm90IGJl
ZW4gY29udmluY2VkIHlldC4NCj4gPg0KPiA+ID4NCj4gPiA+IEknZCBzZWUgc29tZSBwcm9ncmVz
c2lvbiB3aGVyZSBpb21tdV9mZCBvbmx5IHdvcmtzIHdpdGggMToxIGdyb3VwcyBhdA0KPiA+ID4g
dGhlIHN0YXJ0LiBPdGhlciBzY2VuYXJpb3MgY29udGludWUgd2l0aCB0aGUgb2xkIEFQSS4NCj4g
Pg0KPiA+IE9uZSB1QVBJIG9wZW4gYWZ0ZXIgY29tcGxldGluZyB0aGlzIG5ldyBza2V0Y2guIHYx
IHByb3Bvc2VkIHRvDQo+ID4gY29uZHVjdCBiaW5kaW5nIChWRklPX0JJTkRfSU9NTVVfRkQpIGFm
dGVyIGRldmljZV9mZCBpcyBhY3F1aXJlZC4NCj4gPiBXaXRoIHRoaXMgc2tldGNoIHdlIG5lZWQg
YSBuZXcgVkZJT19HUk9VUF9HRVRfREVWSUNFX0ZEX05FVw0KPiA+IHRvIGNvbXBsZXRlIGJvdGgg
aW4gb25lIHN0ZXAuIEkgd2FudCB0byBnZXQgQWxleCdzIGNvbmZpcm1hdGlvbiB3aGV0aGVyDQo+
ID4gaXQgc291bmRzIGdvb2QgdG8gaGltLCBzaW5jZSBpdCdzIGJldHRlciB0byB1bmlmeSB0aGUg
dUFQSSBiZXR3ZWVuIDE6MQ0KPiA+IGdyb3VwIGFuZCAxOk4gZ3JvdXAgZXZlbiBpZiB3ZSBkb24n
dCBzdXBwb3J0IDE6TiBpbiB0aGUgc3RhcnQuDQo+IA0KPiBJIGRvbid0IGxpa2UgaXQuICBJdCBk
b2Vzbid0IG1ha2Ugc2Vuc2UgdG8gbWUuICBZb3UgaGF2ZSB0aGUNCj4gZ3JvdXAtY2VudHJpYyB3
b3JsZCwgd2hpY2ggbXVzdCBjb250aW51ZSB0byBleGlzdCBhbmQgY2Fubm90IGNoYW5nZQ0KPiBi
ZWNhdXNlIHdlIGNhbm5vdCBicmVhayB0aGUgdmZpbyB1YXBpLiAgV2UgY2FuIG1ha2UgZXh0ZW5z
aW9ucywgd2UgY2FuDQo+IGRlZmluZSBhIG5ldyBwYXJhbGxlbCB1YXBpLCB3ZSBjYW4gZGVwcmVj
YXRlIHRoZSB1YXBpLCBidXQgaW4gdGhlIHNob3J0DQo+IHRlcm0sIGl0IGNhbid0IGNoYW5nZS4N
Cj4gDQo+IEFJVUksIHRoZSBuZXcgZGV2aWNlLWNlbnRyaWMgbW9kZWwgc3RhcnRzIHdpdGggdmZp
byBkZXZpY2UgZmlsZXMgdGhhdA0KPiBjYW4gYmUgb3BlbmVkIGRpcmVjdGx5LiAgU28gd2hhdCB0
aGVuIGlzIHRoZSBwdXJwb3NlIG9mIGEgKkdST1VQKiBnZXQNCj4gZGV2aWNlIGZkPyAgV2h5IGlz
IGEgdmZpbyB1YXBpIGludm9sdmVkIGluIHNldHRpbmcgYSBkZXZpY2UgY29va2llIGZvcg0KPiBh
bm90aGVyIHN1YnN5c3RlbT8NCj4gDQo+IEknZCBleHBlY3QgdGhhdCAvZGV2L2lvbW11IHdpbGwg
YmUgdXNlZCBieSBtdWx0aXBsZSBzdWJzeXN0ZW1zLiAgQWxsDQo+IHdpbGwgd2FudCB0byBiaW5k
IGRldmljZXMgdG8gYWRkcmVzcyBzcGFjZXMsIHNvIHNob3VsZG4ndCBiaW5kaW5nIGENCj4gZGV2
aWNlIHRvIGFuIGlvbW11ZmQgYmUgYW4gaW9jdGwgb24gdGhlIGlvbW11ZmQsIGllLg0KPiBJT01N
VV9CSU5EX1ZGSU9fREVWSUNFX0ZELiAgTWF5YmUgd2UgZG9uJ3QgZXZlbiBuZWVkICJWRklPIiBp
biB0aGVyZQ0KPiBhbmQNCj4gdGhlIGlvbW11ZmQgY29kZSBjYW4gZmlndXJlIGl0IG91dCBpbnRl
cm5hbGx5Lg0KPiANCj4gWW91J3JlIGVzc2VudGlhbGx5IHRyeWluZyB0byByZWR1Y2UgdmZpbyB0
byB0aGUgZGV2aWNlIGludGVyZmFjZS4gIFRoYXQNCj4gbmVjZXNzYXJpbHkgaW1wbGllcyB0aGF0
IGlvY3RscyBvbiB0aGUgY29udGFpbmVyLCBncm91cCwgb3IgcGFzc2VkDQo+IHRocm91Z2ggdGhl
IGNvbnRhaW5lciB0byB0aGUgaW9tbXUgbm8gbG9uZ2VyIGV4aXN0LiAgRnJvbSBteQ0KPiBwZXJz
cGVjdGl2ZSwgdGhlcmUgc2hvdWxkIGlkZWFsbHkgYmUgbm8gbmV3IHZmaW8gaW9jdGxzLiAgVGhl
IHVzZXIgZ2V0cw0KPiBhIGxpbWl0ZWQgYWNjZXNzIHZmaW8gZGV2aWNlIGZkIGFuZCBlbmFibGVz
IGZ1bGwgYWNjZXNzIHRvIHRoZSBkZXZpY2UNCj4gYnkgcmVnaXN0ZXJpbmcgaXQgdG8gdGhlIGlv
bW11ZmQgc3Vic3lzdGVtICgxMDAlIHRoaXMgbmVlZHMgdG8gYmUNCj4gZW5mb3JjZWQgdW50aWwg
Y2xvc2UoKSB0byBhdm9pZCByZXZva2UgaXNzdWVzKS4gIFRoZSB1c2VyIGludGVyYWN0cw0KPiBl
eGNsdXNpdmVseSB3aXRoIHZmaW8gdmlhIHRoZSBkZXZpY2UgZmQgYW5kIHBlcmZvcm1zIGFsbCBE
TUEgYWRkcmVzcw0KPiBzcGFjZSByZWxhdGVkIG9wZXJhdGlvbnMgdGhyb3VnaCB0aGUgaW9tbXVm
ZC4NCj4gDQo+ID4gPiBUaGVuIG1heWJlIGdyb3VwcyB3aGVyZSBhbGwgZGV2aWNlcyB1c2UgdGhl
IHNhbWUgSU9BU0lELg0KPiA+ID4NCj4gPiA+IFRoZW4gMTpOIGdyb3VwcyBpZiB0aGUgc291cmNl
IGRldmljZSBpcyByZWxpYWJseSBpZGVudGlmaWFibGUsIHRoaXMNCj4gPiA+IHJlcXVpcmVzIGlv
bW11IHN1YnlzdGVtIHdvcmsgdG8gYXR0YWNoIGRvbWFpbnMgdG8gc3ViLWdyb3VwIG9iamVjdHMg
LQ0KPiA+ID4gbm90IHN1cmUgaXQgaXMgd29ydGh3aGlsZS4NCj4gPiA+DQo+ID4gPiBCdXQgYXQg
bGVhc3Qgd2UgY2FuIHRhbGsgYWJvdXQgZWFjaCBzdGVwIHdpdGggd2VsbCB0aG91Z2h0IG91dCBw
YXRjaGVzDQo+ID4gPg0KPiA+ID4gVGhlIG9ubHkgdGhpbmcgdGhhdCBuZWVkcyB0byBiZSBkb25l
IHRvIGdldCB0aGUgMToxIHN0ZXAgaXMgdG8gYnJvYWRseQ0KPiA+ID4gZGVmaW5lIGhvdyB0aGUg
b3RoZXIgdHdvIGNhc2VzIHdpbGwgd29yayBzbyB3ZSBkb24ndCBnZXQgaW50byB0cm91YmxlDQo+
ID4gPiBhbmQgc2V0IHNvbWUgd2F5IHRvIGV4Y2x1ZGUgdGhlIHByb2JsZW1hdGljIGNhc2VzIGZy
b20gZXZlbiBnZXR0aW5nIHRvDQo+ID4gPiBpb21tdV9mZCBpbiB0aGUgZmlyc3QgcGxhY2UuDQo+
ID4gPg0KPiA+ID4gRm9yIGluc3RhbmNlIGlmIHdlIGdvIGFoZWFkIGFuZCBjcmVhdGUgL2Rldi92
ZmlvL2RldmljZSBub2RlcyB3ZSBjb3VsZA0KPiA+ID4gZG8gdGhpcyBvbmx5IGlmIHRoZSBncm91
cCB3YXMgMToxLCBvdGhlcndpc2UgdGhlIGdyb3VwIGNkZXYgaGFzIHRvIGJlDQo+ID4gPiB1c2Vk
LCBhbG9uZyB3aXRoIGl0cyBBUEkuDQo+ID4NCj4gPiBJIGZlZWwgZm9yIFZGSU8gcG9zc2libHkg
d2UgZG9uJ3QgbmVlZCBzaWduaWZpY2FudCBjaGFuZ2UgdG8gaXRzIHVBUEkNCj4gPiBzZXF1ZW5j
ZSwgc2luY2UgaXQgYW55d2F5IG5lZWRzIHRvIHN1cHBvcnQgZXhpc3Rpbmcgc2VtYW50aWNzIGZv
cg0KPiA+IGJhY2t3YXJkIGNvbXBhdGliaWxpdHkuIFdpdGggdGhpcyBza2V0Y2ggd2UgY2FuIGtl
ZXAgdmZpbyBjb250YWluZXIvDQo+ID4gZ3JvdXAgYnkgaW50cm9kdWNpbmcgYW4gZXh0ZXJuYWwg
aW9tbXUgdHlwZSB3aGljaCBpbXBsaWVzIGEgZGlmZmVyZW50DQo+ID4gR0VUX0RFVklDRV9GRCBz
ZW1hbnRpY3MuIC9kZXYvaW9tbXUgY2FuIHJlcG9ydCBhIGZkLXdpZGUgY2FwYWJpbGl0eQ0KPiA+
IGZvciB3aGV0aGVyIDE6TiBncm91cCBpcyBzdXBwb3J0ZWQgdG8gdmZpbyB1c2VyLg0KPiANCj4g
SWRlYWxseSB2ZmlvIHdvdWxkIGFsc28gYXQgbGVhc3QgYmUgYWJsZSB0byByZWdpc3RlciBhIHR5
cGUxIElPTU1VDQo+IGJhY2tlbmQgdGhyb3VnaCB0aGUgZXhpc3RpbmcgdWFwaSwgYmFja2VkIGJ5
IHRoaXMgaW9tbXUgY29kZSwgaWUuIHdlJ2QNCj4gY3JlYXRlIGEgbmV3ICJpb21tdWZkIiAoYnV0
IHdpdGhvdXQgdGhlIHVzZXIgdmlzaWJsZSBmZCksIGJpbmQgYWxsIHRoZQ0KPiBncm91cCBkZXZp
Y2VzIHRvIGl0LCBnZW5lcmF0aW5nIG91ciBvd24gZGV2aWNlIGNvb2tpZXMsIGNyZWF0ZSBhIHNp
bmdsZQ0KPiBpb2FzaWQgYW5kIGF0dGFjaCBhbGwgdGhlIGRldmljZXMgdG8gaXQgKGFsbCBpbnRl
cm5hbCkuICBXaGVuIHVzaW5nIHRoZQ0KPiBjb21wYXRpYmlsaXR5IG1vZGUsIHVzZXJzcGFjZSBk
b2Vzbid0IGdldCBkZXZpY2UgY29va2llcywgZG9lc24ndCBnZXQNCj4gYW4gaW9tbXVmZCwgdGhl
eSBkbyBtYXBwaW5ncyB0aHJvdWdoIHRoZSBjb250YWluZXIsIHdoZXJlIHZmaW8gb3ducyB0aGUN
Cj4gY29va2llcyBhbmQgaW9hc2lkLg0KPiANCj4gPiBGb3IgbmV3IHN1YnN5c3RlbXMgdGhleSBj
YW4gZGlyZWN0bHkgY3JlYXRlIGRldmljZSBub2RlcyBhbmQgcmVseSBvbg0KPiA+IGlvbW11IGZk
IHRvIG1hbmFnZSBncm91cCBpc29sYXRpb24sIHdpdGhvdXQgaW50cm9kdWNpbmcgYW55IGdyb3Vw
DQo+ID4gc2VtYW50aWNzIGluIGl0cyB1QVBJLg0KPiANCj4gQ3JlYXRlIGRldmljZSBub2Rlcywg
YmluZCB0aGVtIHRvIGlvbW11ZmQsIGFzc29jaWF0ZSBjb29raWVzLCBhdHRhY2gNCj4gaW9hc2lk
cywgZXRjLiAgVGhhdCBzaG91bGQgYmUgdGhlIHNhbWUgZm9yIGFsbCBzdWJzeXN0ZW1zLCBpbmNs
dWRpbmcNCj4gdmZpbywgaXQncyBqdXN0IHRoZSBtYWdpYyBpbnRlcm5hbCBoYW5kc2hha2UgYmV0
d2VlbiB0aGUgZGV2aWNlDQo+IHN1YnN5c3RlbSBhbmQgdGhlIGlvbW11ZmQgc3Vic3lzdGVtIHRo
YXQgY2hhbmdlcy4NCj4gDQo+ID4gPiA+ICAgICAgICAgYSkgQ2hlY2sgZ3JvdXAgdmlhYmlsaXR5
LiBBIGdyb3VwIGlzIHZpYWJsZSBvbmx5IHdoZW4gYWxsIGRldmljZXMgaW4NCj4gPiA+ID4gICAg
ICAgICAgICAgdGhlIGdyb3VwIGFyZSBpbiBvbmUgb2YgYmVsb3cgc3RhdGVzOg0KPiA+ID4gPg0K
PiA+ID4gPiAgICAgICAgICAgICAgICAgKiBkcml2ZXItbGVzcw0KPiA+ID4gPiAgICAgICAgICAg
ICAgICAgKiBib3VuZCB0byBhIGRyaXZlciB3aGljaCBpcyBzYW1lIGFzIGRldi0+ZHJpdmVyICh2
ZmlvIGluIHRoaXMNCj4gY2FzZSkNCj4gPiA+ID4gICAgICAgICAgICAgICAgICogYm91bmQgdG8g
YW4gb3RoZXJ3aXNlIGFsbG93ZWQgZHJpdmVyIChzYW1lIGxpc3QgYXMgaW4gdmZpbykNCj4gPiA+
DQo+ID4gPiBUaGlzIHJlYWxseSBzaG91bGRuJ3QgdXNlIGhhcmR3aXJlZCBkcml2ZXIgY2hlY2tz
LiBBdHRhY2hlZCBkcml2ZXJzDQo+ID4gPiBzaG91bGQgZ2VuZXJpY2FsbHkgaW5kaWNhdGUgdG8g
dGhlIGlvbW11IGxheWVyIHRoYXQgdGhleSBhcmUgc2FmZSBmb3INCj4gPiA+IGlvbW11X2ZkIHVz
YWdlIGJ5IGNhbGxpbmcgc29tZSBmdW5jdGlvbiBhcm91bmQgcHJvYmUoKQ0KPiA+DQo+ID4gZ29v
ZCBpZGVhLg0KPiA+DQo+ID4gPg0KPiA+ID4gVGh1cyBhIGdyb3VwIG11c3QgY29udGFpbiBvbmx5
IGlvbW11X2ZkIHNhZmUgZHJpdmVycywgb3IgZHJpdmVycy1sZXNzDQo+ID4gPiBkZXZpY2VzIGJl
Zm9yZSBhbnkgb2YgaXQgY2FuIGJlIHVzZWQuIEl0IGlzIHRoZSBtb3JlIGdlbmVyYWwNCj4gPiA+
IHJlZmFjdG9yaW5nIG9mIHdoYXQgVkZJTyBpcyBkb2luZy4NCj4gPiA+DQo+ID4gPiA+ICAgICAg
ICAgYykgVGhlIGlvbW11IGxheWVyIGFsc28gdmVyaWZpZXMgZ3JvdXAgdmlhYmlsaXR5IG9uIEJV
U19OT1RJRllfDQo+ID4gPiA+ICAgICAgICAgICAgIEJPVU5EX0RSSVZFUiBldmVudC4gQlVHX09O
IGlmIHZpYWJpbGl0eSBpcyBicm9rZW4gd2hpbGUNCj4gPiA+IGJsb2NrX2RtYQ0KPiA+ID4gPiAg
ICAgICAgICAgICBpcyBzZXQuDQo+ID4gPg0KPiA+ID4gQW5kIHdpdGggdGhpcyBjb25jZXB0IG9m
IGlvbW11X2ZkIHNhZmV0eSBiZWluZyBmaXJzdC1jbGFzcyBtYXliZSB3ZQ0KPiA+ID4gY2FuIHNv
bWVob3cgZWxpbWluYXRlIHRoaXMgZ3Jvc3MgQlVHX09OIChhbmQgdGhlIDEwMCdzIG9mIGxpbmVz
IG9mDQo+ID4gPiBjb2RlIHRoYXQgYXJlIHVzZWQgdG8gY3JlYXRlIGl0KSBieSBkZW55aW5nIHBy
b2JlIHRvIG5vbi1pb21tdS1zYWZlDQo+ID4gPiBkcml2ZXJzLCBzb21laG93Lg0KPiA+DQo+ID4g
eWVzLg0KPiA+DQo+ID4gPg0KPiA+ID4gPiAtICAgQmluZGluZyBvdGhlciBkZXZpY2VzIGluIHRo
ZSBncm91cCB0byBpb21tdV9mZCBqdXN0IHN1Y2NlZWRzIHNpbmNlDQo+ID4gPiA+ICAgICB0aGUg
Z3JvdXAgaXMgYWxyZWFkeSBpbiBibG9ja19kbWEuDQo+ID4gPg0KPiA+ID4gSSB0aGluayB0aGUg
cmVzdCBvZiB0aGlzIG1vcmUgb3IgbGVzcyBkZXNjcmliZXMgdGhlIGRldmljZSBjZW50cmljDQo+
ID4gPiBsb2dpYyBmb3IgbXVsdGktZGV2aWNlIGdyb3VwcyB3ZSd2ZSBhbHJlYWR5IHRhbGtlZCBh
Ym91dC4gSSBkb24ndA0KPiA+ID4gdGhpbmsgaXQgYmVuaWZpdHMgZnJvbSBoYXZpbmcgdGhlIGdy
b3VwIGZkDQo+ID4gPg0KPiA+DQo+ID4gc3VyZS4gQWxsIG9mIHRoaXMgbmV3IHNrZXRjaCBkb2Vz
bid0IGhhdmUgZ3JvdXAgZmQgaW4gYW55IGlvbW11IGZkDQo+ID4gQVBJLiBKdXN0IHRyeSB0byBl
bGFib3JhdGUgYSBmdWxsIHNrZXRjaCB0byBzeW5jIHRoZSBiYXNlLg0KPiA+DQo+ID4gQWxleC9K
b2VyZywgbG9vayBmb3J3YXJkIHRvIHlvdXIgdGhvdWdodHMgbm93LiDwn5iKDQo+IA0KPiBTb21l
IHByb3ZpZGVkLiAgVGhhbmtzLA0KPiANCg0KVGhhbmtzIGEgbG90IEFsZXghIFdlJ2xsIHRyeSB0
byBmb2N1cyBvbiB0aGUgbmV3IGRldmljZS1jZW50cmljIGZsb3cgDQp3L28gdG91Y2hpbmcgZXhp
c3RpbmcgY29udGFpbmVyL2dyb3VwIHVBUEkuIEFzIHlvdSBzYWlkLCB3ZSBuZWVkDQphIGJyYW5k
LW5ldyBtZWNoYW5pc20gZm9yIGFsbCBzdWJzeXN0ZW1zIGFueXdheS4NCg0KV2l0aCB0aGF0IEkg
d2lsbCByZXN1bWUgdjIgcHJvZ3Jlc3MgYmFzZWQgb24gZGV2aWNlLWNlbnRyaWMgY29uY2VwdC4N
Ckl0IHdpbGwgYmUgc3RpbGwgYmFzZWQgb24gYSBmZXcgbmV3IFZGSU8gdUFQSXMgdG8gaGFuZGxl
IGRldmljZSBiaW5kaW5nLw0KYXR0YWNoaW5nLCB0aG91Z2ggeW91IHByZWZlciB0byBub3QgYWRk
aW5nIGFueSBuZXcgVkZJTyB1QVBJLiAgVGhpcyBpcyANCnJlbGF0aXZlbHkgYSBzbWFsbGVyIG9w
ZW4gY29tcGFyZWQgdG8gZGV2aWNlLWNlbnRyaWMgdnMuIGdyb3VwLWNlbnRyaWMgDQppc3N1ZS4g
V2UgY2FuIGhhdmUgaXQgY29udGludW91c2x5IGRpc2N1c3NlZCBpbiBwYXJhbGxlbCB3aXRoIHYy
IHJldmlldy4gDQphbmQgSSBob3BlIHYyIGNhbiBiZSBoZWxwZnVsIGZvciBjbG9zaW5nIHRoaXMg
b3BlbiB3aXRoIGEgY2xlYXJlciANCmV4cGxhbmF0aW9uIGFib3V0IFBBU0lEIHZpcnR1YWxpemF0
aW9uLiDwn5iKDQoNClRoYW5rcw0KS2V2aW4NCg==
