Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3363C96BA
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 05:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhGOD6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 23:58:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:54166 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231602AbhGOD6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 23:58:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10045"; a="274296874"
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="274296874"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 20:55:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="452285171"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 14 Jul 2021 20:55:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 20:55:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 14 Jul 2021 20:55:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 14 Jul 2021 20:55:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zy+Zd4rgqytE0L62rlRzn1fsDOx48I9P7/yxaamUsGwJDHVXi2u0g9e7QIuS9MHeWgQDJOISi5FxubDfwfAKbMFXk0B2sqK3auLcfGaeoUf/eJGHtcHXotsBRUAk+4Jn5JeBwsy7fWvu2cIAUSWot7OH3PHyRAodAM9UqPgSGVxCp+lBRF/J/tLljpuuKmUtKsgGY3e7JbwEfk7Yf0tM+1YQ3tCpw6lPGHFS3k+UCbvjC9luig5ZkbPGl1y8JpFzgus6kbe5iDoeh/CFTqdqnZIUxY2UX0NLiPsoid/mBmMLUS8sIXj+2TCsnK3DlthOrKx64O2DSnOiSInxO02yRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jouTY5vU6Yb+11f55otoc6embhUQTAyWRNBiMm1UK8=;
 b=QuDJ/G3B3Sf3ShQr4yG3U2HsnS9qHsBtW/06UDTEGcKqvFoTjJreBHn130mylq+9T72TBaGe/rVqHuMQnykrMVSug/pprXqNYEoqrAGLC9hrIDhFO3O6PNYejYvx4TwodoZDEAACGSv4V9AyxX9C7ZSazD86upAtAJvMFfd+HCCCJem0JT6O8HBWP5i42Pur9vhtJBo500FwZlfVeIsdlvnq1x2rIeSwYc/ODIriLVgtIeRVJVH6+N4EeOG8ggtL78zH/j/Ps8nyhyt82P6Oz4DltxxD/ozJvAZ69vKnV+gckQRxIRJtb3+lf9P8vRXf5b311M+gjdoKawPiBtnteQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jouTY5vU6Yb+11f55otoc6embhUQTAyWRNBiMm1UK8=;
 b=gux5PJiRMyPqejr8AD1jpNbTyrXhOgW2XF9CdNJleT4dMDWmZqSFI0Ty9lNOVCNg7J120sr2lCF4Zkv8NHz4l82E/kzkQT9VwlZ5U/NSzygqtT258sRaeR96qbpB9vk2mnCgvV5aH1Zlw6Q48J8T4QUasg2Ga7lATXOWs3vxyP8=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2291.namprd11.prod.outlook.com (2603:10b6:405:53::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 03:55:17 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%9]) with mapi id 15.20.4331.022; Thu, 15 Jul 2021
 03:55:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shenming Lu <lushenming@huawei.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
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
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQEkayMAAADgu8A=
Date:   Thu, 15 Jul 2021 03:55:17 +0000
Message-ID: <BN9PR11MB5433A9B792441CAF21A183A38C129@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <7ea349f8-8c53-e240-fe80-382954ba7f28@huawei.com>
In-Reply-To: <7ea349f8-8c53-e240-fe80-382954ba7f28@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3339a4b-41ce-4837-3dd4-08d947445c31
x-ms-traffictypediagnostic: BN6PR1101MB2291:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB229107B9BA9D1B5485B34BEE8C129@BN6PR1101MB2291.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Xw/VIC4+gI8au6MbcV4uf4DQEFq8J1kDLJTp5Mdq0bulMwI1+rzZfg/ez/uizQKSN7WaH8Q424NWoxHN/C7JBWbu7D2h0c+OXAmdzHsZqD1K7ZNBzCmtcjdkzSRrTl34n3jNvuQNFb0h770Ct+zIFGdY4BJUlIbha/JbnyTz7vaG9EAUhoTF5+Ab2ojJ4Y0pHNSsbzO494ki0gqogE77wJiI1xT5Te8D9ixxj66GnUgnumLPbXNotOZXvK8cP9y2xKCnd1txiB8Vn15y7ScwV5kPZYSVD8rrKPKduqyQR6gKilB3nR++q+OdrL/5IdOVQ5hmrv7hBdo35f3axF5RFVxhpl31z4rvAMjUk5nnNcTPFPoqQrcE5aijB7olEWwoKjjMVfLxIDyx7gR2QwA6cQB+XnXi/GqiIWc8Q2qPzE8IUrYNvXlt5qqcNqBHMPi4rVd+O4Q3HaIl6n+twRmrXY4tOPnX2MVcOMezybHW02qZCk9iBtNESd4NR4DOwRGFS9fzDsydzheOFiGRGbW00CILVA4Y2B0dGbThWZwLDGTrnCYSf+twO2/BB9Lg01IPw5iaSqmhyARwybk0SSjT1gRpnGqLAIgXA3P1TMQRE2FUQCtGSKO8Nbt5F8O2nw+b4M01NNiQGzwGrhJcKwHJVXgjAKS+O0LzHyeEdfyzWMXOngxqPlXrK1GsavNH2IA9JOB9uE+YWywCxz0YHKsFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(5660300002)(55016002)(8936002)(66946007)(86362001)(66446008)(64756008)(66556008)(66476007)(7696005)(2906002)(76116006)(9686003)(6916009)(26005)(52536014)(186003)(71200400001)(6506007)(316002)(7416002)(53546011)(122000001)(8676002)(4326008)(33656002)(478600001)(38100700002)(54906003)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2ZTQi9RZDlGZ29keE1aZVd4QzJrNG1jQ2J1NHpUMmhEOVJLb2RZaVc2RTk0?=
 =?utf-8?B?M1NpMy9xcitnMDhWbGtEVThnSC9RM1hycUJ0UXBkcDRnZTRGQ2wwYmZsNmg3?=
 =?utf-8?B?UTJ5K2lGNzZuYk1Ld1J2NGRGMHpCc25zQk1vMVhVK2lkUFJSSEtzZE16RDJp?=
 =?utf-8?B?MmtnUEZCNUxNZG1uQUVpVWIrdGdKRFpuZURhT0JZR1RpNkdhSEZ4Y0lvU1NE?=
 =?utf-8?B?U2NDMnJPMHI0dkFaUDNkT3dtek9Ccy81QklOb3lmUWNNWE9CMTNTNWwvMU1L?=
 =?utf-8?B?ZkJ5MzNXbk5pb2w1bGVSWDVKeVRtOG5kM2RnanhjNE0wV1BjUTd4cHM3bE5p?=
 =?utf-8?B?NFpLQ0tWVW5JWjFpaTJLSVVlM0ZmUktkQjRtMGF5WkdONWpWZWI5aFB4RXM0?=
 =?utf-8?B?YWJxTlZpMVFQczVoTUkwUjlWdVBxdzFiZWdOZXNPU1l6ZkpZYlVOd2kxT0NH?=
 =?utf-8?B?djhiT0VQbXdzOUZXRENMVWNON3l5QW5NNExHeHRFbWNiMnlYTDIwK215RnlY?=
 =?utf-8?B?ZTI4aTdGV0pNSTcrQWtpRktVYmlTRFFkdk44Tk5NbklORmM2RnBUQXhsbVll?=
 =?utf-8?B?MmdDQUtqYUp3Z0dKUkZhdW9Lc09YRERWalJvZU9MbS9RMlNoRkg4a3dqL2J0?=
 =?utf-8?B?eUtxVEliVEdueFJ3LytuQS9BSkdJWGd3R0hmMUVpNWUzVEFxREh5U2t3RCtO?=
 =?utf-8?B?MHQyOWJCR3hzbUhaak4vc1hTRXh4Q3YxaUxXQS9zNHBiNHJUUDN2eTkxemow?=
 =?utf-8?B?YVJsYU03WDhZVGQzcWEyVDJxcERVcEk4SEl6THRMZ005SjBLWWpGK0hZTUw3?=
 =?utf-8?B?S3oxTVRTQjcyOXFKZjhNWjZ0UXVkYnBFQllhTyszV2RYSDFaQnJLdTRjS3cw?=
 =?utf-8?B?QVoyK0xnelRxYmZHNGR0TC9NVkNReHI0R3JkNmRjNjB1aTZpazhlRDV0ZkRK?=
 =?utf-8?B?eUxzUnVxcjV1MStrSTdWWlJXNDEwdEdkTnlLSlg1TXlZMGNXZzJOZjhJbTk2?=
 =?utf-8?B?ZDViWEFMNTJBa3VCVmdLSlRka3BwMzBWb29zemdwd2xUSkpWbGh4Smh1VHY2?=
 =?utf-8?B?SG5RUmtvUzVNUFREK056M294eUhoUmRENXIzVkhCTkduZUVWVklOZ3JFSFgv?=
 =?utf-8?B?V0ZobE85UzVOZmlsVEx5Y1dLaHAvSkNuaE5VRm5DNEczVEZjaDF1T1UzNi9X?=
 =?utf-8?B?TXluVnViRk9rVHNwL2NmYUpZN2tyOGNEcHY2ZHJ2L3hYZWNlMlRYbmp5Wll1?=
 =?utf-8?B?aUtGZWxiYVZsTlJFQWU5aXJteU9qNERYUURsanliOUMvcGFxck5SQUZ3Vy9R?=
 =?utf-8?B?VkpaYWNZMEp0LyszMk1lZEs4VFJMOTVsUlRnNERpQ0V3YnZ6UEovRWtGWE5i?=
 =?utf-8?B?N2k4djgzQUVhOHNZdmt1QkN4TWVBa0dYYnJmc0xRU0NOdXMwcTMrZzM1TXRh?=
 =?utf-8?B?clFJbmU0dzBJUGlBS3lWN0VEVlJVYk9QeWFCNjFhMHpLdy84SE03U25aNmhX?=
 =?utf-8?B?a2EyNjhrMzJwRHlNRk1MdE1uZk9LZ1NTa0pMT2ZsY25SajJZK0NXNDVKNEhx?=
 =?utf-8?B?bmE1Y0R6WGcyOVU3VjM0RE43TWR6STVKZFo5eVFPdUt2TEFWV2JZZlhaS1ha?=
 =?utf-8?B?VWRzQzZ6eXgwVVpZVHVxL0luMEh3MDVzdHczbDRsYVI2THczVjd2SWx4WmRm?=
 =?utf-8?B?MENXQkpVUG12R2FhYXk4RmY3T0ZLSmRzaHJGR2VQd2Y1bUJtSFBLcGdXblRi?=
 =?utf-8?Q?2Dfyl/0WpCsZHkm0hRTtJVkE4am9SiNP0O3O8VK?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3339a4b-41ce-4837-3dd4-08d947445c31
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 03:55:17.8619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ME0FnXN8R3M0IndKnlcffxpJBm9APMipyKsO30S3bnQbzRfvMyFaXJ3KC3XB0yNW34csabG6u+Fwm3QbqZdvag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2291
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgSnVseSAxNSwgMjAyMSAxMToyMSBBTQ0KPiANCj4gT24gMjAyMS83LzkgMTU6NDgsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+IDQuNi4gSS9PIHBhZ2UgZmF1bHQNCj4gPiArKysrKysrKysr
KysrKysrKysrDQo+ID4NCj4gPiB1QVBJIGlzIFRCRC4gSGVyZSBpcyBqdXN0IGFib3V0IHRoZSBo
aWdoLWxldmVsIGZsb3cgZnJvbSBob3N0IElPTU1VIGRyaXZlcg0KPiA+IHRvIGd1ZXN0IElPTU1V
IGRyaXZlciBhbmQgYmFja3dhcmRzLiBUaGlzIGZsb3cgYXNzdW1lcyB0aGF0IEkvTyBwYWdlDQo+
IGZhdWx0cw0KPiA+IGFyZSByZXBvcnRlZCB2aWEgSU9NTVUgaW50ZXJydXB0cy4gU29tZSBkZXZp
Y2VzIHJlcG9ydCBmYXVsdHMgdmlhIGRldmljZQ0KPiA+IHNwZWNpZmljIHdheSBpbnN0ZWFkIG9m
IGdvaW5nIHRocm91Z2ggdGhlIElPTU1VLiBUaGF0IHVzYWdlIGlzIG5vdA0KPiBjb3ZlcmVkDQo+
ID4gaGVyZToNCj4gPg0KPiA+IC0gICBIb3N0IElPTU1VIGRyaXZlciByZWNlaXZlcyBhIEkvTyBw
YWdlIGZhdWx0IHdpdGggcmF3IGZhdWx0X2RhdGEge3JpZCwNCj4gPiAgICAgcGFzaWQsIGFkZHJ9
Ow0KPiA+DQo+ID4gLSAgIEhvc3QgSU9NTVUgZHJpdmVyIGlkZW50aWZpZXMgdGhlIGZhdWx0aW5n
IEkvTyBwYWdlIHRhYmxlIGFjY29yZGluZyB0bw0KPiA+ICAgICB7cmlkLCBwYXNpZH0gYW5kIGNh
bGxzIHRoZSBjb3JyZXNwb25kaW5nIGZhdWx0IGhhbmRsZXIgd2l0aCBhbiBvcGFxdWUNCj4gPiAg
ICAgb2JqZWN0IChyZWdpc3RlcmVkIGJ5IHRoZSBoYW5kbGVyKSBhbmQgcmF3IGZhdWx0X2RhdGEg
KHJpZCwgcGFzaWQsIGFkZHIpOw0KPiA+DQo+ID4gLSAgIElPQVNJRCBmYXVsdCBoYW5kbGVyIGlk
ZW50aWZpZXMgdGhlIGNvcnJlc3BvbmRpbmcgaW9hc2lkIGFuZCBkZXZpY2UNCj4gPiAgICAgY29v
a2llIGFjY29yZGluZyB0byB0aGUgb3BhcXVlIG9iamVjdCwgZ2VuZXJhdGVzIGFuIHVzZXIgZmF1
bHRfZGF0YQ0KPiA+ICAgICAoaW9hc2lkLCBjb29raWUsIGFkZHIpIGluIHRoZSBmYXVsdCByZWdp
b24sIGFuZCB0cmlnZ2VycyBldmVudGZkIHRvDQo+ID4gICAgIHVzZXJzcGFjZTsNCj4gPg0KPiAN
Cj4gSGksIEkgaGF2ZSBzb21lIGRvdWJ0cyBoZXJlOg0KPiANCj4gRm9yIG1kZXYsIGl0IHNlZW1z
IHRoYXQgdGhlIHJpZCBpbiB0aGUgcmF3IGZhdWx0X2RhdGEgaXMgdGhlIHBhcmVudCBkZXZpY2Un
cywNCj4gdGhlbiBpbiB0aGUgdlNWQSBzY2VuYXJpbywgaG93IGNhbiB3ZSBnZXQgdG8ga25vdyB0
aGUgbWRldihjb29raWUpIGZyb20NCj4gdGhlDQo+IHJpZCBhbmQgcGFzaWQ/DQo+IA0KPiBBbmQg
ZnJvbSB0aGlzIHBvaW50IG9mIHZpZXfvvIx3b3VsZCBpdCBiZSBiZXR0ZXIgdG8gcmVnaXN0ZXIg
dGhlIG1kZXYNCj4gKGlvbW11X3JlZ2lzdGVyX2RldmljZSgpKSB3aXRoIHRoZSBwYXJlbnQgZGV2
aWNlIGluZm8/DQo+IA0KDQpUaGlzIGlzIHdoYXQgaXMgcHJvcG9zZWQgaW4gdGhpcyBSRkMuIEEg
c3VjY2Vzc2Z1bCBiaW5kaW5nIGdlbmVyYXRlcyBhIG5ldw0KaW9tbXVfZGV2IG9iamVjdCBmb3Ig
ZWFjaCB2ZmlvIGRldmljZS4gRm9yIG1kZXYgdGhpcyBvYmplY3QgaW5jbHVkZXMgDQppdHMgcGFy
ZW50IGRldmljZSwgdGhlIGRlZlBBU0lEIG1hcmtpbmcgdGhpcyBtZGV2LCBhbmQgdGhlIGNvb2tp
ZSANCnJlcHJlc2VudGluZyBpdCBpbiB1c2Vyc3BhY2UuIExhdGVyIGl0IGlzIGlvbW11X2RldiBi
ZWluZyByZWNvcmRlZCBpbg0KdGhlIGF0dGFjaGluZ19kYXRhIHdoZW4gdGhlIG1kZXYgaXMgYXR0
YWNoZWQgdG8gYW4gSU9BU0lEOg0KDQoJc3RydWN0IGlvbW11X2F0dGFjaF9kYXRhICpfX2lvbW11
X2RldmljZV9hdHRhY2goDQoJCXN0cnVjdCBpb21tdV9kZXYgKmRldiwgdTMyIGlvYXNpZCwgdTMy
IHBhc2lkLCBpbnQgZmxhZ3MpOw0KDQpUaGVuIHdoZW4gYSBmYXVsdCBpcyByZXBvcnRlZCwgdGhl
IGZhdWx0IGhhbmRsZXIganVzdCBuZWVkcyB0byBmaWd1cmUgb3V0IA0KaW9tbXVfZGV2IGFjY29y
ZGluZyB0byB7cmlkLCBwYXNpZH0gaW4gdGhlIHJhdyBmYXVsdCBkYXRhLg0KDQpUaGFua3MNCktl
dmluDQo=
