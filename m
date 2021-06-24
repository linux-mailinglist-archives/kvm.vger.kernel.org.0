Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDE63B2523
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 04:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFXCnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 22:43:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:49104 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhFXCnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 22:43:50 -0400
IronPort-SDR: D1QxNmejTXu9oWiRYyXdYA/fm5AHtJVb0bBA+/8whTgtk6mOwrZY8VEoEOJGVFwnkVhKVKYc+8
 LGlZCqV4g6dQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="204375150"
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="204375150"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 19:41:31 -0700
IronPort-SDR: qy7yVus8AIThtCkZM5phx5ggljg2iRLY86LWd4uhE9F2im8p5PLzvl6HaEfntVBA+lj8SwkHp6
 umBHKKG7v7wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="423914838"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 23 Jun 2021 19:41:31 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 19:41:30 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 19:41:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 23 Jun 2021 19:41:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 23 Jun 2021 19:41:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvzzbYtulWxCRAbWQQOjArDFHmgKWUBCT4LJtbA0YRFG9xGfKAAnLDEOOVJ9UO+ehUuRFPGpvzq5Q7TPc4NvF2GCzdsbmR+r2upw4Y6MFbR+cQpcSllMyrOAtBwUO4RlYG7soI3lboLgytNtTG8HTHuzPUxTPNpD6yWzCVxZwr5ip5xfKZti+dkVwIE0LPnjL99ClKQq5g1MCog+E2ejVcNPPvW5YkwxiEmXQqiklNOe4sASc0bqhiv5Zut0x811SPKTNmKWYY8DRdbmF+aowlhj8cXUPTaFhdi5s1hcrTKaahtqdGUn0tMGvDkjjvBE7s5lO4iiV2wJMkK0P8XYEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSb07XmQdlJYGJ8EJEkGojYLXT8fQfniEBMm+IzxT2M=;
 b=OvlnSdxvo+2/Jkzga9ejY2a4c8JU9AZ8uP/ccNxMPw73U8qmCH6LS9gGC/bg8gAtsowJH6jteiqEF6sB/JVt29M94obn9BMI/L5DN8Fnlu1nozEWR9QylgjYSa20FB99ak9Pe6HWugRiyUgsa1UNG8Ae7iPo+kyGBd60bakckW0OCVvH7qZni40szPvWfwNo/sChAjsaLkTEvc7AJSPGEg26WX7FdNHoppxcqfhid8nqE+ukpp8Kck0PlmHVHP5+oxDG+dS66QcCqLkG+bNAkY+JL7yC58mn3K/Cc+/8S35Q7L6Qlk/NHvh3S0GgFqi4bZ4YVJvdix/rGgy+zWV3pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSb07XmQdlJYGJ8EJEkGojYLXT8fQfniEBMm+IzxT2M=;
 b=lkkbmgq42Z9X4yOLf+R4tJW6l517GaosoAghLPD6YRs6hvqKYvBWxVfqxCk4K6gx8HdH9mGx0O+UeOXtKN7JLWSTX5UqjB/cmYPnDMaCUAgKDDaBtc7V55oGkDzNnWVdRt8y/VJebPVyXYq9y7n59/1NVUasNvf4lXzBVQu26io=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB2061.namprd11.prod.outlook.com (2603:10b6:300:28::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Thu, 24 Jun
 2021 02:41:24 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4242.024; Thu, 24 Jun
 2021 02:41:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        "Bjorn Helgaas" <helgaas@kernel.org>
Subject: RE: Virtualizing MSI-X on IMS via VFIO
Thread-Topic: Virtualizing MSI-X on IMS via VFIO
Thread-Index: AddnMs7+4GfLhTceT8q8tdV8716lmQAZ7UiAAAoHBgAACsXtAAAX4LwAAA2wIPAABLctgAAACLXQ
Date:   Thu, 24 Jun 2021 02:41:24 +0000
Message-ID: <MWHPR11MB1886E14C57689A253D9B40C08C079@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com>
 <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
 <MWHPR11MB1886811339F7873A8E34549A8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
 <87bl7wczkp.ffs@nanos.tec.linutronix.de>
 <MWHPR11MB1886BB017C6C53A8061DDEE28C089@MWHPR11MB1886.namprd11.prod.outlook.com>
 <87tuloawm0.ffs@nanos.tec.linutronix.de>
In-Reply-To: <87tuloawm0.ffs@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b54e734-73b2-477b-be50-08d936b98f1e
x-ms-traffictypediagnostic: MWHPR11MB2061:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB2061B3B56D1D423038723B228C079@MWHPR11MB2061.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tMZ0dGs5b18duess0vpPg7YU8v3Ig1o3tnRmme7N6En1XmxIFUrrAbmoV3S/Mq9J9c1X6xhi8lugLr/e1Hy82JmP8P5B/wT9SZ2WLmmahYBwy5EEFizP1PCm+AUl05ou6gI1YnoqcbP2sXSI6BjFf8IwkJMB/akhVMNNGRS2tp/QAHqPPKPbyD25hFKjPPyVmIYdh8CDNtbmQFgHuUwkTuSVHuWNhXQ1PDDK1rhnegE88hzPzOcMWx5oHiL8Z9uyyqaX6B+J9tI+NTOUltaM3H2wxRUmIuJcCO9r9Le9UETajfPjm+TvU6JUhNQ/g2lynjJ6ToCzWObb5LMZ8CctWjIU4VIPYhQl8qaciH2BTDUO3DZjfZjRG0UDu2uvTWY+touXZ2Yh0jT720pQq9HQQ0MYnyZ2arhsMgcIk51qaFKt6YqUCSVFTiYqVKQgS9MgGQ+s3WMLMpzsNVF6I9kp7PuyT1peEVlS2KJ0zDNhQyJI8/s+McWFX2vLMOaoLrlHosvbUAB6WP9Kb1lSmb6X2IMnf2n0w1rDR8q9UwPvoRD+Zpt7ghfz27+7tULbx8q9vI+11zX4Ipx7QVmaH+4LYNBt04PeEeEjyiSJwKrUGfc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(2906002)(186003)(26005)(76116006)(4326008)(52536014)(86362001)(38100700002)(7696005)(66476007)(122000001)(5660300002)(8936002)(66946007)(7416002)(9686003)(33656002)(110136005)(6506007)(71200400001)(478600001)(66556008)(55016002)(8676002)(64756008)(316002)(54906003)(83380400001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGdIdks4UnhTRlpTdDh4NEdraUswV0tPOTNWK2NzdGhtYnBJRWFIRm15ZHJN?=
 =?utf-8?B?cHJhUjh3alhLWWpSTURndjdVWlRGOEdjL2lVRkpxb3NEZHErSEt5emxRY2s3?=
 =?utf-8?B?cWZpVXZtYVZvbktqck5qdkFKV1JZcGJTdFJCdkJ1WmNuNWFxdUExaFZLWEU1?=
 =?utf-8?B?QTZSUndZR1hKb0NydjM4MDJIU1pSbC9CcEhCN3dtTmljZ21LYzgzQzhuQmJO?=
 =?utf-8?B?Z29jQy92RnVRWHg1dzRmVmJMdXRPL2c1LytTcC9qS1A0akx3RklnMTdmL1A4?=
 =?utf-8?B?WUdoVkhzR2tYNmVWclhTbW10VlRtL2tUalIwb1lrVmFET3I0aXFVaUVvSVM1?=
 =?utf-8?B?RG5EOVpNNXcxWXdqYTJRM2xFMFNVWS92MWdnamR6b05LUHkxY1BHRmEzNGUv?=
 =?utf-8?B?RzEwUWQrWk8vTEFCYUVmSzUwMDZtbE02Y09MM0R4ZTZKT3dvRVRIRkxHMTg3?=
 =?utf-8?B?Y0xGM0xiUmxucFp3N0lsenJXZ1UrU0RFeUJVbWZWdWtPcWE3cmVMUDcyd0JG?=
 =?utf-8?B?NlVWeFNPeVAya1UvTElTNVdSekloODNINjJMVTZIcHRoeWpSQkVDaDByQm1S?=
 =?utf-8?B?UWs1NFZZaStuczlqdjhYZytGWjVqVXRML0RtUkpVakpGdGNTeUl3QWw3WlIx?=
 =?utf-8?B?akZteTVmdWVDT2w1RjZkUkZVY003YzI1T21jVnNRZ0tFbFZzY1FlcXErWUgv?=
 =?utf-8?B?UHJ2dm1Qc3M5ZFdzcmdXVWZZS0h2VS9QMWl3S01oaXI5UFhDK1VPQlJOTE1l?=
 =?utf-8?B?dk5nWUQxS0dJZ2xjY2tua1NkRGpXYThDRFdYdlUyeDNnME1ZM1haK3gwR3Zu?=
 =?utf-8?B?cTczWXFRUVA1NlpaaG8xZG1QNWNDdnZNUzRyYmxkUEEvampBVTVKUzhPYytj?=
 =?utf-8?B?RkFDdEIzOFBsVVcwMjJ6amZhQW85S3dBeGo3RHc3L3I4cnNQM0pVVkxGRllL?=
 =?utf-8?B?eVlKWU1jSW5RNzBYdU5TUm03dXRkQVJJcjdHbTdNRW44UUQrSjhTWXhXQWpa?=
 =?utf-8?B?NUxDcVZuRGxJOHVYQWlCN3FScUFwN2ZiUUhnc2I4YlBNREFkYTU2UEwzdU40?=
 =?utf-8?B?RFpIUXMyZldiUmpXK2V3YlRtRjN0TWpnVUlYS0pFbUZVUllRbkZMa0c3UmJG?=
 =?utf-8?B?MWpyemVzRkZ3NGF0K3IxelRYZW1kdjhtdXU4N0s1b293bHJUcmxxQS9WWTdm?=
 =?utf-8?B?RlFOUy9iV25zQTJSN0NnWmpIcGt5emRhZXhWV25HS3lkdUMzcDIyRTdiZkE1?=
 =?utf-8?B?NzYzQVdLSlBucnZUVUFsYm12bHRvWkdvM1BNVDNuWnRoZEZrdG5wK0RVZkEr?=
 =?utf-8?B?RUdhTWl2TXh2djVueGZnQVJIdmRldklQNGhocm5MdkpQczRGV3BOZ3JXenYw?=
 =?utf-8?B?UG9OKzZhWm1aVkYvVEhuSlNTUnc5bWMySzlyQUZCUEhtWVpNT2xHc2p3d0hR?=
 =?utf-8?B?TzdJL0cxYnNXdmdpTnpRMThPU2xLUFd6MFdheFNwZDJmL0tyUTJLdUdISE1v?=
 =?utf-8?B?RFVWTE95MlZOZWNSL1NIQlIxTTk2ejVXM0Q0Y3htVFNiREJQeEtZeEgwamg3?=
 =?utf-8?B?M3lwR2NvOWY4RDF1OEhjZmJPZXZIWnNFUnRIbVQrM0V5OVF2TVZtY0cwRG12?=
 =?utf-8?B?OE5kK2k4WnRUZWt2NDV5MkZQcnh1SFVyZWg5eFpWdnhMRHQ4ZlBOMHZJdk45?=
 =?utf-8?B?UlRicndwak5vZTBteWtsZlJMek1vVUJKSkQ5Q1VwQllnRVhHaWlYRUJ0dGlO?=
 =?utf-8?Q?kl5Rwddoy5AehH+cHN/zLd1D/1fYHigZ5TTgE5t?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b54e734-73b2-477b-be50-08d936b98f1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 02:41:24.1634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AvV7CrLgw3yNDthAVw1/hbiLawV9ZcHd+7/oT7W+HQu3P3T2Q7Ki2ZAUw0GLsQNM0DZWAb/SZa2f2Bb8Bvu0GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2061
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCj4gU2VudDogVGh1
cnNkYXksIEp1bmUgMjQsIDIwMjEgOToxOSBBTQ0KPiANCj4gS2V2aW4hDQo+IA0KPiBPbiBXZWQs
IEp1biAyMyAyMDIxIGF0IDIzOjM3LCBLZXZpbiBUaWFuIHdyb3RlOg0KPiA+PiBGcm9tOiBUaG9t
YXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCj4gPj4gPiBDdXJpb3VzIGFib3V0IGly
dGUgZW50cnkgd2hlbiBJUlEgcmVtYXBwaW5nIGlzIGVuYWJsZWQuIElzIGl0IGFsc28NCj4gPj4g
PiBhbGxvY2F0ZWQgYXQgcmVxdWVzdF9pcnEoKT8NCj4gPj4NCj4gPj4gR29vZCBxdWVzdGlvbi4g
Tm8sIGl0IGhhcyB0byBiZSBhbGxvY2F0ZWQgcmlnaHQgYXdheS4gV2Ugc3RpY2sgdGhlDQo+ID4+
IHNodXRkb3duIHZlY3RvciBpbnRvIHRoZSBJUlRFIGFuZCB0aGVuIHJlcXVlc3RfaXJxKCkgd2ls
bCB1cGRhdGUgaXQgd2l0aA0KPiA+PiB0aGUgcmVhbCBvbmUuDQo+ID4NCj4gPiBUaGVyZSBhcmUg
bWF4IDY0SyBpcnRlIGVudHJpZXMgcGVyIEludGVsIFZULWQuIERvIHdlIGNvbnNpZGVyIGl0IGFz
DQo+ID4gYSBsaW1pdGVkIHJlc291cmNlIGluIHRoaXMgbmV3IG1vZGVsLCB0aG91Z2ggaXQncyBt
dWNoIG1vcmUgdGhhbg0KPiA+IENQVSB2ZWN0b3JzPw0KPiANCj4gSXQncyBzdXJlbHkgYSBsaW1p
dGVkIHJlc291cmNlLiBGb3IgbWUgNjRrIGVudHJpZXMgc2VlbXMgdG8gYmUgcGxlbnR5LA0KPiBi
dXQgd2hhdCBkbyBJIGtub3cuIEknbSBub3QgYSB2aXJ0dWFsaXphdGlvbiB3aXphcmQuDQo+IA0K
PiA+IEJhY2sgdG8gZWFybGllciBkaXNjdXNzaW9uIGFib3V0IGd1ZXN0IGltcyBzdXBwb3J0LCB5
b3UgZXhwbGFpbmVkIGEgbGF5ZXJlZA0KPiA+IG1vZGVsIHdoZXJlIHRoZSBwYXJhdmlydCBpbnRl
cmZhY2Ugc2l0cyBiZXR3ZWVuIG1zaSBkb21haW4gYW5kIHZlY3Rvcg0KPiA+IGRvbWFpbiB0byBn
ZXQgYWRkci9kYXRhIHBhaXIgZnJvbSB0aGUgaG9zdC4gSW4gdGhpcyB3YXkgaXQgY291bGQgcHJv
dmlkZQ0KPiA+IGEgZmVlZGJhY2sgbWVjaGFuaXNtIGZvciBib3RoIG1zaSBhbmQgaW1zIGRldmlj
ZXMsIHRodXMgbm90IHNwZWNpZmljDQo+ID4gdG8gaW1zIG9ubHkuIFRoZW4gY29uc2lkZXJpbmcg
dGhlIHRyYW5zaXRpb24gd2luZG93IHdoZXJlIG5vdCBhbGwgZ3Vlc3QNCj4gPiBPU2VzIG1heSBz
dXBwb3J0IHBhcmF2aXJ0IGludGVyZmFjZSBhdCB0aGUgc2FtZSB0aW1lIChvciB0aGVyZSBhcmUN
Cj4gPiBtdWx0aXBsZSBwYXJhdmlydCBpbnRlcmZhY2VzIHdoaWNoIHRha2VzIHRpbWUgZm9yIGhv
c3QgdG8gc3VwcG9ydCBhbGwpLA0KPiA+IHdvdWxkIGJlbG93IHN0YWdpbmcgYXBwcm9hY2ggc3Rp
bGwgbWFrZXMgc2Vuc2U/DQo+ID4NCj4gPiAxKSAgRml4IHRoZSBsb3N0IGludGVycnVwdCBpc3N1
ZSBpbiBleGlzdGluZyBNU0kgdmlydHVhbGl6YXRpb24gZmxvdzsNCj4gDQo+IFRoYXQgX2Nhbm5v
dF8gYmUgZml4ZWQgd2l0aG91dCBhIGh5cGVyY2FsbC4gU2VlIG15IHJlcGx5IHRvIEFsZXguDQoN
ClRoZSBsb3N0IGludGVycnVwdCBpc3N1ZSB3YXMgY2F1c2VkIGR1ZSB0byByZXNpemluZyBiYXNl
ZCBvbiBzdGFsZSANCmltcHJlc3Npb24gb2YgdmVjdG9yIGV4aGF1c3Rpb24uDQoNCldpdGggeW91
ciBleHBsYW5hdGlvbiB0aGlzIGlzc3VlIGNhbiBiZSBwYXJ0aWFsbHkgZml4ZWQgYnkgaGF2aW5n
IFFlbXUgDQphbGxvY2F0ZSBhbGwgcG9zc2libGUgaXJxcyB3aGVuIGd1ZXN0IGVuYWJsZXMgbXNp
LXggYW5kIG5ldmVyIHJlc2l6ZXMgDQppdCBiZWZvcmUgZ3Vlc3QgZGlzYWJsZXMgbXNpLXguIA0K
DQpUaGUgcmVtYWluaW5nIHByb2JsZW0gaXMgbm8gZmVlZGJhY2sgdG8gYmxvY2sgZ3Vlc3QgcmVx
dWVzdF9pcnEoKQ0KaW4gY2FzZSBvZiB2ZWN0b3Igc2hvcnRhZ2UuIFRoaXMgaGFzIHRvIGJlIHNv
bHZlZCB2aWEgcGFyYXZpcnQgaW50ZXJmYWNlDQpidXQgZml4aW5nIGxvc3QgaW50ZXJydXB0IGFs
b25lIGlzIHN0aWxsIGEgc3RlcCBmb3J3YXJkIGZvciBndWVzdCB3aGljaA0KZG9lc24ndCBpbXBs
ZW1lbnQgdGhlIHBhcmF2aXJ0IGludGVyZmFjZS4NCg0KPiANCj4gPiAyKSAgVmlydHVhbGl6ZSBN
U0ktWCBvbiBJTVMsIGJlYXJpbmcgdGhlIHNhbWUgcmVxdWVzdF9pcnEoKSBwcm9ibGVtOw0KPiAN
Cj4gVGhhdCBzb2x2ZXMgd2hhdD8gTWF5YmUgeW91ciBwZXJjZWl2ZWQgcm9hZG1hcCBwcm9ibGVt
LCBidXQgY2VydGFpbmx5DQo+IG5vdCBhbnkgdGVjaG5pY2FsIHByb2JsZW0gaW4gdGhlIHJpZ2h0
IHdheS4gQWdhaW46IFNlZSBteSByZXBseSB0byBBbGV4Lg0KDQpOb3QgYWJvdXQgcm9hZG1hcC4g
U2VlIGV4cGxhbmF0aW9uIGJlbG93Lg0KDQo+IA0KPiA+IDMpICBEZXZlbG9wIGEgcGFyYXZpcnQg
aW50ZXJmYWNlIHRvIHNvbHZlIHJlcXVlc3RfaXJxKCkgcHJvYmxlbSBmb3INCj4gPiAgICAgYm90
aCBtc2kgYW5kIGltcyBkZXZpY2VzOw0KPiANCj4gRmlyc3Qgb2YgYWxsIGl0J3Mgbm90IGEgcmVx
dWVzdF9pcnEoKSBwcm9ibGVtOiBJdCdzIGEgcGxhaW4gcmVzb3VyY2UNCj4gbWFuYWdlbWVudCBw
cm9ibGVtIHdoaWNoIHJlcXVpcmVzIHByb3BlciBpbnRlcmFjdGlvbiBiZXR3ZWVuIGhvc3QgYW5k
DQo+IGd1ZXN0Lg0KDQpzdXJlLg0KDQo+IA0KPiBBbmQgeWVzLCBpdCBfaXNfIHRoZSBjb3JyZWN0
IGFuc3dlciB0byB0aGUgcHJvYmxlbSBhbmQgYXMgSSBvdXRsaW5lZCBpbg0KPiBteSByZXBseSB0
byBBbGV4IGFscmVhZHkgaXQgaXMgX25vdF8gcm9ja2V0IHNjaWVuY2UgYW5kIGl0IHdvbid0IG1h
a2UgYQ0KPiBzaWduaWZpY2FudCBkaWZmZXJlbmNlIG9uIHlvdXIgdGltZWxpbmUgYmVjYXVzZSBp
dCdzIHN0cmFpZ2h0IGZvcndhcmQNCj4gYW5kIHNvbHZlcyB0aGUgcHJvYmxlbSBwcm9wZXJseSB3
aXRoIHRoZSBhZGRlZCBiZW5lZml0IHRvIHNvbHZlIGV4aXN0aW5nDQo+IHByb2JsZW1zIHdoaWNo
IHNob3VsZCBhbmQgY291bGQgaGF2ZSBiZWVuIHNvbHZlZCBsb25nIGFnby4NCj4gDQo+IEkgZG9u
J3QgY2FyZSBhdCBhbGwgYWJvdXQgdGhlIHRpbWUgeW91IGFyZSB3YXN0aW5nIHdpdGggaGFsZiBi
YWtlbg0KPiB0aG91Z2h0cyBhYm91dCBhdm9pZGluZyB0byBkbyB0aGUgcmlnaHQgdGhpbmcsIGJ1
dCBJIHZlcnkgbXVjaCBjYXJlDQo+IGFib3V0IG15IHRpbWUgd2FzdGVkIHRvIGRlYnVuayB0aGVt
Lg0KPiANCg0KSSdtIHJlYWxseSBub3QgdGhpbmtpbmcgZnJvbSBhbnkgYW5nbGUgb2Ygcm9hZG1h
cCB0aGluZywgYW5kIEkgYWN0dWFsbHkgDQp2ZXJ5IG11Y2ggYXBwcmVjaWF0ZSBhbGwgb2YgeW91
ciBjb21tZW50cyBvbiB0aGUgcmlnaHQgZGlyZWN0aW9uLg0KDQpBbGwgbXkgY29tbWVudHMgYXJl
IHB1cmVseSBiYXNlZCBvbiBwb3NzaWJsZSB1c2Ugc2NlbmFyaW9zLiBJIHdpbGwgZ2l2ZQ0KbW9y
ZSBleHBsYW5hdGlvbiBiZWxvdyBhbmQgaG9wZSB5b3UgY2FuIGNvbnNpZGVyIGl0IGFzIGEgdGhv
dWdodCANCnByYWN0aWNlIHRvIGNvbXBvc2UgdGhlIGZ1bGwgcGljdHVyZSBiYXNlZCBvbiB5b3Vy
IGd1aWRhbmNlLCBpbnN0ZWFkIG9mDQpzZWVraW5nIGhhbGYgYmFrZW4gaWRlYSB0byB3YXN0ZSB5
b3VyIHRpbWUuIPCfmIoNCg0KQXQgYW55IHRpbWUgZ3Vlc3QgT1NlcyBjYW4gYmUgY2F0ZWdvcml6
ZWQgaW50byB0aHJlZSBjbGFzc2VzOg0KDQphKSAgIGRvZXNuJ3QgaW1wbGVtZW50IGFueSBwYXJh
dmlydCBpbnRlcmZhY2UgZm9yIHZlY3RvciBhbGxvY2F0aW9uOw0KDQpiKSAgIGltcGxlbWVudCBv
bmUgcGFyYXZpcnQgaW50ZXJmYWNlIHRoYXQgaGFzIGJlZW4gc3VwcG9ydGVkIGJ5IEtWTTsNCg0K
YykgICBpbXBsZW1lbnQgb25lIHBhcmF2aXJ0IGludGVyZmFjZSB3aGljaCBoYXMgbm90IGJlZW4g
c3VwcG9ydGVkIGJ5IEtWTTsNCg0KVGhlIHRyYW5zaXRpb24gcGhhc2UgZnJvbSBjKSB0byBiKSBp
cyB1bmRlZmluZWQsIGJ1dCBpdCBkb2VzIGV4aXN0IG1vcmUNCm9yIGxlc3MuIEZvciBleGFtcGxl
IGEgd2luZG93cyBndWVzdCB3aWxsIG5ldmVyIGltcGxlbWVudCB0aGUgaW50ZXJmYWNlDQpkZWZp
bmVkIGJldHdlZW4gTGludXggZ3Vlc3QgYW5kIExpbnV4IGhvc3QuIEl0IHdpbGwgaGF2ZSBpdHMg
b3duIGh5cGVydg0KdmFyaWF0aW9uIHdoaWNoIGxpa2VseSB0YWtlcyB0aW1lIGZvciBLVk0gdG8g
ZW11bGF0ZSBhbmQgY2xhaW0gc3VwcG9ydC4NCg0KVHJhbnNpdGlvbiBmcm9tIGEpIHRvIGIpIG9y
IGEpIHRvIGMpIGlzIGEgZ3Vlc3Qtc2lkZSBjaG9pY2UuIEl0J3Mgbm90IGNvbnRyb2xsZWQNCmJ5
IHRoZSBob3N0IHdvcmxkLg0KDQpIZXJlIEkgZGlkbid0IGZ1cnRoZXIgZGlmZmVyZW50aWF0ZSB3
aGV0aGVyIGEgZ3Vlc3QgT1Mgc3VwcG9ydCBpbXMsIHNpbmNlDQpvbmNlIGEgc3VwcG9ydGVkIHBh
cmF2aXJ0IGludGVyZmFjZSBpcyBpbiBwbGFjZSBib3RoIG1zaSBhbmQgaW1zIGNhbiBnZXQNCm5l
Y2Vzc2FyeSBmZWVkYmFjayBpbmZvIGZyb20gdGhlIGhvc3Qgc2lkZS4gDQoNClRoZW4gbGV0J3Mg
bG9vayBhdCB0aGUgaG9zdCBzaWRlOg0KDQoxKSBrZXJuZWwgdmVyc2lvbnMgYmVmb3JlIHdlIGNv
bmR1Y3QgYW55IGRpc2N1c3NlZCBjaGFuZ2U6DQoNCiAgICAgICAgIFRoaXMgaXMgYSBrbm93biBi
cm9rZW4gd29ybGQgYXMgeW91IGV4cGxhaW5lZC4gaXJxIHJlc2l6aW5nIGNvdWxkDQogICAgICAg
ICBsZWFkIHRvIGxvc3QgaW50ZXJydXB0cyBpbiBhbGwgdGhyZWUgZ3Vlc3QgY2xhc3Nlcy4gVGhl
IG9ubHkgbWl0aWdhdGlvbiANCiAgICAgICAgIGlzIHRvIGRvY3VtZW50IHRoaXMgbGltaXRhdGlv
biBzb21ld2hlcmUuDQoNCiAgICAgICAgIFdlJ2xsIG5vdCBlbmFibGUgaW1zIGJhc2VkIG9uIHRo
aXMgYnJva2VuIGZyYW1ld29yay4NCg0KMikga2VybmVsIHZlcnNpb25zIGFmdGVyIHdlIG1ha2Ug
YSBjbGVhbiByZWZhY3RvcmluZzoNCg0KICAgICAgICAgYSkgRm9yIGd1ZXN0IE9TIHdoaWNoIGRv
ZXNuJ3QgaW1wbGVtZW50IHBhcmF2aXJ0IGludGVyZmFjZToNCiAgICAgICAgIGMpIEZvciBndWVz
dCBPUyB3aGljaCBpbXBsZW1lbnQgYSBwYXJhdmlydCBpbnRlcmZhY2Ugbm90IA0KICAgICAgICAg
ICAgIHN1cHBvcnRlZCBieSBLVk06DQoNCiAgICAgICAgICAgICBZb3UgY29uZmlybWVkIHRoYXQg
cmVjZW50IGtlcm5lbHMgKHNpbmNlIDQuMTUrKSBhbGwgdXNlcw0KICAgICAgICAgICAgIHJlc2Vy
dmF0aW9uIG1vZGUgdG8gYXZvaWQgdmVjdG9yIGV4aGF1c3Rpb24uIFNvIFZGSU8gY2FuDQogICAg
ICAgICAgICAgZGVmaW5lIGEgbmV3IHByb3RvY29sIGFza2luZyBpdHMgdXNlcnNwYWNlIHRvIGRp
c2FibGUgcmVzaXppbmcNCiAgICAgICAgICAgICBieSBhbGxvY2F0aW5nIGFsbCBwb3NzaWJsZSBp
cnFzIHdoZW4gZ3Vlc3QgbXNpeCBpcyBlbmFibGVkLiBUaGlzDQogICAgICAgICAgICAgaXMgb25l
IHN0ZXAgZm9yd2FyZCBieSBmaXhpbmcgdGhlIGxvc3QgaW50ZXJydXB0IGlzc3VlIGFuZCBpcyB3
aGF0DQogICAgICAgICAgICAgdGhlIHN0ZXAtMSkgaW4gbXkgcHJvcG9zYWwgdHJpZXMgdG8gYWNo
aWV2ZS4NCg0KICAgICAgICAgICAgIEJ1dCB0aGVyZSByZW1haW5zIGEgbGltaXRhdGlvbiBhcyBu
byBmZWVkYmFjayBpcyBwcm92aWRlZCBpbnRvIA0KICAgICAgICAgICAgIHRoZSBndWVzdCB0byBi
bG9jayBpdCB3aGVuIGhvc3QgdmVjdG9ycyBhcmUgaW4gc2hvcnRhZ2UuIEJ1dA0KICAgICAgICAg
ICAgIHRoYXQncyB0aGUgcmVhbGl0eSB0aGF0IHdlIGhhdmUgdG8gYmVhciBmb3Igc3VjaCBndWVz
dC4gVkZJTw0KICAgICAgICAgICAgIHJldHVybnMgc3VjaCBlcnJvciBpbmZvIHRvIGFuZCBsZXQg
dXNlcnNwYWNlIGRlY2lkZSBob3cgdG8NCiAgICAgICAgICAgICByZWFjdC4NCg0KICAgICAgICAg
ICAgIEl0J3Mgbm90IGVsZWdhbnQgYnV0IGltcHJvdmVkIG92ZXIgdGhlIHN0YXR1cyBxdW8uIGFu
ZCB3ZSBkbw0KICAgICAgICAgICAgIHNlZSB2YWx1ZSBvZiBlbmFibGluZyBpbXMtY2FwYWJsZSBk
ZXZpY2Uvc3ViZGV2aWNlIHdpdGhpbg0KICAgICAgICAgICAgIHN1Y2ggZ3Vlc3QsIHRob3VnaCB0
aGUgZ3Vlc3Qgd2lsbCBqdXN0IGZhbGwgYmFjayB0byB1c2UgbXNpeC4gDQogICAgICAgICAgICAg
VGhpcyBpcyBhYm91dCBzdGVwLTIpIGluIG15IHByb3Bvc2FsOw0KDQogICAgICAgICBiKSBGb3Ig
Z3Vlc3QgT1Mgd2hpY2ggaW1wbGVtZW50IGEgcGFyYXZpcnQgaW50ZXJmYWNlIHN1cHBvcnRlZCAN
CiAgICAgICAgICAgICAgYnkgS1ZNOg0KDQogICAgICAgICAgICAgIFRoaXMgaXMgdGhlIHJpZ2h0
IGZyYW1ld29yayB0aGF0IHlvdSBqdXN0IGRlc2NyaWJlZC4gV2l0aCBzdWNoDQogICAgICAgICAg
ICAgIGludGVyZmFjZSBpbiBwbGFjZSwgdGhlIGd1ZXN0IG5lZWRzIHRvIHByb2FjdGl2ZWx5IGNs
YWltIHJlc291cmNlDQogICAgICAgICAgICAgIGZyb20gdGhlIGhvc3Qgc2lkZSBiZWZvcmUgaXQg
Y2FuIGFjdHVhbGx5IGVuYWJsZSBhIHNwZWNpZmljIG1zaS9pbXMNCiAgICAgICAgICAgICAgZW50
cnkuIEV2ZXJ5dGhpbmcgaXMgd2VsbCBzZXQgd2l0aCBjb29wZXJhdGlvbiBiZXR3ZWVuIGhvc3Qv
Z3Vlc3QuDQoNCklmIHlvdSBhZ3JlZSB3aXRoIGFib3ZlLCB0aGVuIGl0J3Mgbm90IHNvbWV0aGlu
ZyB0aGF0IHdlIHdhbnQgdG8gbWFrZQ0KaGFsZi1iYWtlZCBzdHVmZiB3aXRoIG15IHByb3Bvc2Fs
LiBJdCdzIHJlYWxseSBhYm91dCBzcGxpdHRpbmcgdGFza3MgYnkgZG9pbmcNCmNvbnNlcnZhdGl2
ZSBzdHVmZiBmaXJzdCB3aGljaCB3b3JrcyBmb3IgbW9zdCBndWVzdHMgYW5kIHRoZW4gb3B0aW1p
emluZw0KdGhpbmdzIGZvciBuZXcgZ3Vlc3RzLiBBbmQgc3RyaWN0bHkgc3BlYWtpbmcgd2UgZG9u
J3Qgd2FudCB0byBkbyBwYXJhdmlydA0Kc3R1ZmYgdmVyeSBsYXRlIHNpbmNlIGl0J3MgdGhlIG11
Y2ggY2xlYW5lciBhcHByb2FjaCBpbiBjb25jZXB0LiBXZSBkbyBwbGFuDQp0byBmaW5kIHNvbWUg
cmVzb3VyY2UgdG8gaW5pdGlhdGUgYSBzZXBhcmF0ZSBkZXNpZ24gZGlzY3Vzc2lvbiBpbiBwYXJh
bGxlbA0Kd2l0aCBmaXhpbmcgaW50ZXJydXB0IGxvc3QgaXNzdWUgZm9yIGEpIGFuZCBjKS4NCg0K
RG9lcyB0aGlzIHJhdGlvbmFsZSBzb3VuZCBnb29kIHRvIHlvdT8NCg0KVGhhbmtzDQpLZXZpbg0K
