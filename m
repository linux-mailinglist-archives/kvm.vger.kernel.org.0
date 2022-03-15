Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDB84D927C
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 03:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344414AbiCOCPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 22:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiCOCPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 22:15:41 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6795F38D90;
        Mon, 14 Mar 2022 19:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647310470; x=1678846470;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nYwSxJ8BgCu1VJeQVxDvYXUNOySkQAfs25BCic1iG5I=;
  b=iS0HGTIzicvMxaf4HzFvSDXWVCY6bupX3FsP/s4TIb7HZULCKdSqHDfU
   OOFZr3PIPGZZGd2Z31PiCBCqE55KIqK6Q4wo1/uRz/Idel+ewqf6jMwOQ
   C3Vr7Z6ARoY4MrBMEqZ1PsU6J+58A1btz+PFEs7rMjovT/h37JKFxvqzJ
   slWyK/6hZsHGq8NRgcckF+DJEIFGgAjz+c6fmHk7E3YT1iDL1C3WGDG9P
   RVVt4Z7G43h2C3DPIW24VQIGJUnnJ9diEMZEf+JZZE7cOJ6TIJ5EoD8k2
   Dyi84x4w6dPI5QR6eTrKoY3PkAn0teDvKCQcdLWKX+7Bk0g4yx0894tf6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255920998"
X-IronPort-AV: E=Sophos;i="5.90,182,1643702400"; 
   d="scan'208";a="255920998"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 19:14:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,182,1643702400"; 
   d="scan'208";a="713979649"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2022 19:14:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 19:14:29 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 19:14:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 14 Mar 2022 19:14:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 14 Mar 2022 19:14:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gt3kwOW2RZ8Z2w3JxNDbnAcYS6gzSOUYXGD7ZIuDdk916jGbu9+cwDm1ha/zfQTSefcjsKVIFphKl3ySonHsw4pSHqXdCY3W4paNNqgM+RMyGRs/0+ZcKCOVb8Ro6AzwYQH7uBdmDsZVeAN734QBhu0JtTGG7hgtE8c31M6LwkyYZGm8wycmAwrEv2V/+VXaBKRPwWWuDKZ3gevgbduSeSND/7mbKXSsGL2Q/1FjUlGDONi6DeOtGyg6RNVKmwSTbX9D2frxq2rq3YDuTFl7eR/FHgeYFpd0UPGK7es4Es9C4eTQtljRAJf5OVDGspI3VSU+Nt0Q3+r58IjrmvYD2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYwSxJ8BgCu1VJeQVxDvYXUNOySkQAfs25BCic1iG5I=;
 b=Ym7MJSVVWJwzvgFOhGtKgIRtRGfLtBO5rjoaciV132NtUcm8dc8XCjxPUgNEoqfYgmQt1ZY1PIoIIht+o9OS8Q6B0299QMKOZpvLpC5wBByofFqcZeXx4r4s329YYgEYnj+Fd7aJJZSzdznlsT+6PbRNR4ZQfMH3QsTfHvD83pkVkC+by5jfs3jq2iA2H9T2s+6P/rXEh7aRwxaBGixG+dvLzkB+GdudY8zsKFHoYx+N8Qy7CCFd/WPdfK4YVpBwFppRFoWJQ2WzacKd7buHTVBpXYfzwCKtRdqInxeNeqgBcDoV+p4WgQeXrOwfuJNa+OyjQT2zwPi6Y94wyGQINA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4011.namprd11.prod.outlook.com (2603:10b6:5:19d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Tue, 15 Mar
 2022 02:14:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%8]) with mapi id 15.20.5061.028; Tue, 15 Mar 2022
 02:14:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: RE: [PATCH v3] vfio-pci: Provide reviewers and acceptance criteria
 for vendor drivers
Thread-Topic: [PATCH v3] vfio-pci: Provide reviewers and acceptance criteria
 for vendor drivers
Thread-Index: AQHYN+GbvQdaDLZ60UyP7OY8BJbzPKy/tOrA
Date:   Tue, 15 Mar 2022 02:14:26 +0000
Message-ID: <BN9PR11MB527643ED0E9A01432A6FAF438C109@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <164728932975.54581.1235687116658126625.stgit@omen>
In-Reply-To: <164728932975.54581.1235687116658126625.stgit@omen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: badd006b-672e-4426-52f7-08da062987de
x-ms-traffictypediagnostic: DM6PR11MB4011:EE_
x-microsoft-antispam-prvs: <DM6PR11MB401128CA6A248549ED9A94218C109@DM6PR11MB4011.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BsgCy/60ZJPGgOPj0U2kbAOq9cDPWXZzeq4i4MwbDiWCBXW2IbFYcT+Jdc+M22b1Lj4GejmcW1G34p5nXSe+izTdzHoXf3SzdaoRcswK56NQvi6IaMiIIXZWKDO2YHG6/c/9CBaef0++DOt5+50SWVv9RZz6NBqFgwdpVbbdpd/gpQCJ8Pf2SaaZTBFOc5TKcXHhGX1xzDFftnja1SUWxg8zqwteNhvBXZsoTaok86NUvl1wSOvkM5LclGAe0Z3PcZPJOR7Xpmy3w2xoLM0tfjHrxwJ/i755v00ZFuFq+T4NiTlmdTsvt1hcDhlK0JmnC42wgXmPwwEiLSoSzzew9Hg/kzti1DUh7YvQOkANA3CySBCVTiQ4Pdaff0WOKZRaJkIq5u8ETs7gAkdGJVyEPKsx6OXiEWFmQOtwcHDPp9mRu87eLB5dzYKClCtYRwqppehlM7GS5tXpvYKxfB3IZ+C9sWhQN8THD4TcsMQttqMtdOn8X6Kl7+6ZR+bbxD8oE86DXHuiEEwyvKYzsuubTqCCQQNjvvjIMOH9wHvZ9D4YhJSgg/S6IzA3zJgf9G8c4vI+FWxLWf7+Nhppj/GhCwbIaxrYJCLPNZlhBqYToAlbj2LqWZY4cqnnWNyJteMoBErQ+CbpUA1RcCgQOeqC1qi7wjHSeIzTlZNdGBfd+8uQw4ZvMf5XMvk/OGE69yDn87SCaLPYDHhSIog9KEuJ+sxmj+53WcpFEJ1g7D/KbOhzYgGegOBNK86oAdlgMsrtMA96L25drQ/WbisGQXGzTcmrccAFfE2kdYOxh0UIVlA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(6506007)(66946007)(38070700005)(2906002)(5660300002)(52536014)(508600001)(76116006)(8936002)(66446008)(64756008)(66476007)(66556008)(7696005)(38100700002)(316002)(26005)(83380400001)(186003)(122000001)(8676002)(82960400001)(86362001)(54906003)(33656002)(4326008)(71200400001)(9686003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0ZYTW1UKzZWTzVvTW4wRHhHcloyc2lQRmZUajFQNzI0WTJiKzhjTWdXZkN3?=
 =?utf-8?B?V1h1V2lzVU5UVGNZNkdFTHEwZXpiYjZ5dDIvWmVGR1hya1Nzbm9kbVd3ZEQ4?=
 =?utf-8?B?emtKdkV0Zm1yRWh2azJFcFI1QlJTaEkzN3REditkOTdZY3RMbWVJTUJnZlVT?=
 =?utf-8?B?Rm52OTV4S1BCKzRqQWdLdHVGTVQrckIwMUJBOVpSZURVZVFIdmZ0YWVyek91?=
 =?utf-8?B?a0J2ODI4c1BZYU52ekFaOG5SWFBIYlRiTUdFTGZzVVFTWGpEQlJ0L0xFdk1Q?=
 =?utf-8?B?MFFiWUdpQXdwaGdCeXYxK1R3NXl1NElhVlc5Y3dFMzYvV21hSTlFOHR2d0dt?=
 =?utf-8?B?eWtaTTVoTzc0Mjl1VzRpZnR5aG9jd05vQ0tuRmRJcHI5RjVaby9WQ1A1a2Rq?=
 =?utf-8?B?VmtZOU0rb1Z4RGZaTnBWZktQdXk3cFdjWU5XVDRYazhETjVNalAvOXRnTWNG?=
 =?utf-8?B?OCtoOWd2a21jRmU1bHV0V2hnZ2hzTzZNOEFMWXBQejVNc1AwdjUrbDd6OTRV?=
 =?utf-8?B?Y0dFRFo3OHdBQytWZGVkd3U3VUtscWxOWURFQkR1K3pwWGV5Qkc2Y0ZLSGJz?=
 =?utf-8?B?YVZWMHpzMXZLc2F2WXJxU0RCM0o3MzhVdERwL3BJUDVUWk93emJjWmlRTUl0?=
 =?utf-8?B?bEp1STFwaHJGRmtmUms3MUx3ZEl4cGFPcDd2UlRoQk43bllKK0N5S1l0cndq?=
 =?utf-8?B?UjBXVjFlYXhSZ2x0ZVlBSDF1VEhDZEF5cDlLWEk2WW9sSGRIMXJ5amRFb0ll?=
 =?utf-8?B?eFhwWnpvVXdWY0lxSzBGalRxcDIyUUFoanRwVWtJRE5ZRk1YSUNad1NCVnJq?=
 =?utf-8?B?dVcxWUpQUmc1UG5aWU4zdi9DcEZldnRNR0JPayt4VFJOZXd2akl0UkZJSis4?=
 =?utf-8?B?ZEZjZzFkYTNKMFA1RnFlMDc2SllKb2Rmdy9nOWdTdUp0UG5UVHNyRk9tZVg2?=
 =?utf-8?B?dEZKa1g1aWw3eWVZc2FlenZ3OVIvUElqNGY0SjhrcnB2N0hVRUdtdzZqeEI0?=
 =?utf-8?B?RTFzWlVZVEhicUlNR3VyRFZQSnlCb0JqU0JqVnVhSjMxQUJOYTVFQjhlS21s?=
 =?utf-8?B?R2Y5Z25ORkJETUd2aEdqb3ZvcWQvMWpXM0RrTTkxZ3NuOExoTFNQZ01hWVU2?=
 =?utf-8?B?Z2JOdG9wRzAwKzhselVseVJpNDYyUDFRWFVtSkkzblFRVjB6UVhWTGdxb1FW?=
 =?utf-8?B?TmJxdVZ5Wml2cEJMRnFhVFUyZVhnTUdaekJFYjlQL1lNeU96ZDg0bHRoV1Qv?=
 =?utf-8?B?NnY0Q0owRER3VlpIeHdVRmVucEZoUVo4N3RkRmlwc2hvTXFQOGRhNWpoU1pR?=
 =?utf-8?B?R0R0c2dvelJQY3VPREJwSFlLbkFPSSsxY1grb0p0OG16U0VielY4ZnNpTFpH?=
 =?utf-8?B?aFBJbHlMK0FCaUtJNmp2clAySUhyUTc2TVk2UWxDWHdjeWZxMDdhRytVSGNs?=
 =?utf-8?B?N0p2WnZyTGExUzJIOExBUmVIenppN1NGNXNBNkVPVmVoa3JFYXY0Nit5bysr?=
 =?utf-8?B?RWNaQ1VFUGNPcWZDdXJ0VXkvVHo3NDljMTRHUzYxcXRwVkJ1Tm9XMUVmMzZG?=
 =?utf-8?B?S201d2ZqOVZiUC9LUmlmMlBieU9xQkNwT1ZsYkFwcVMwU2tyM2laSDNJWjBW?=
 =?utf-8?B?dGFOVTBsOUJFY1lCN2ZGcEY4RGNFMkhCNVpoYXBNYWVXUm9VQzhLSEJJMGZK?=
 =?utf-8?B?RlJYaVIyZWIwSnAvOWFqNDNxNStSMUhVc0dKK0RVdFBMK3k2K2tubW9mSEFw?=
 =?utf-8?B?cjhRcHd2ZEhqNm5zVFJWRGZJcHNMTWFhZzR0dkwxaGxoeGtJdzV1bkI2MkdY?=
 =?utf-8?B?TVdvQmZJditLZFZxNVFJb0h1dUVZOHdRV0dqWUcxTldMOUEzczdjZlh6MTFj?=
 =?utf-8?B?UDRON2F6QlRSN2JXbVhYcVVsSTZrUjcvem5TU1hFc1ZLZW1YTldwZnp1S3po?=
 =?utf-8?Q?xLsG5WQvsPfYeC+7WicBXzmAZv2/KvDu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: badd006b-672e-4426-52f7-08da062987de
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2022 02:14:26.8329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N18uV8zQFOD5f2LuJTNP30vWggtW/6+I8iQr7w+9RfLk2jJYj8MoWm4Je2N7MIljn6bt/P6VvTEtq8J+G6xalQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4011
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBNYXJjaCAxNSwgMjAyMiA0OjI1IEFNDQo+IA0KPiBWZW5kb3Igb3IgZGV2
aWNlIHNwZWNpZmljIGV4dGVuc2lvbnMgZm9yIGRldmljZXMgZXhwb3NlZCB0byB1c2Vyc3BhY2UN
Cj4gdGhyb3VnaCB0aGUgdmZpby1wY2ktY29yZSBsaWJyYXJ5IG9wZW4gYm90aCBuZXcgZnVuY3Rp
b25hbGl0eSBhbmQgbmV3DQo+IHJpc2tzLiAgSGVyZSB3ZSBhdHRlbXB0IHRvIHByb3ZpZGVkIGZv
cm1hbGl6ZWQgcmVxdWlyZW1lbnRzIGFuZA0KPiBleHBlY3RhdGlvbnMgdG8gZW5zdXJlIHRoYXQg
ZnV0dXJlIGRyaXZlcnMgYm90aCBjb2xsYWJvcmF0ZSBpbiB0aGVpcg0KPiBpbnRlcmFjdGlvbiB3
aXRoIGV4aXN0aW5nIGhvc3QgZHJpdmVycywgYXMgd2VsbCBhcyByZWNlaXZlIGFkZGl0aW9uYWwN
Cj4gcmV2aWV3cyBmcm9tIGNvbW11bml0eSBtZW1iZXJzIHdpdGggZXhwZXJpZW5jZSBpbiB0aGlz
IGFyZWEuDQo+IA0KPiBDYzogSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gQ2M6
IFlpc2hhaSBIYWRhcyA8eWlzaGFpaEBudmlkaWEuY29tPg0KPiBDYzogS2V2aW4gVGlhbiA8a2V2
aW4udGlhbkBpbnRlbC5jb20+DQo+IEFja2VkLWJ5OiBTaGFtZWVyIEtvbG90aHVtIDxzaGFtZWVy
YWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFsZXggV2ls
bGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQoNCkFja2VkLWJ5OiBLZXZpbiBU
aWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCg0KPiAtLS0NCj4gDQo+IHYzOg0KPiANCj4gUmVs
b2NhdGUgdG8gRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpLw0KPiBJbmNsdWRlIGluZGV4LnJzdCBy
ZWZlcmVuY2UNCj4gQ3Jvc3MgbGluayBmcm9tIG1haW50YWluZXItZW50cnktcHJvZmlsZQ0KPiBB
ZGQgU2hhbWVlcidzIEFjaw0KPiANCj4gdjI6DQo+IA0KPiBBZGRlZCBZaXNoYWkNCj4gDQo+IHYx
Og0KPiANCj4gUGVyIHRoZSBwcm9wb3NhbCBoZXJlWzFdLCBJJ3ZlIGNvbGxlY3RlZCB0aG9zZSB0
aGF0IHZvbHVudGVlcmVkIGFuZA0KPiB0aG9zZSB0aGF0IEkgaW50ZXJwcmV0ZWQgYXMgc2hvd2lu
ZyBpbnRlcmVzdCAoYWxwaGEgYnkgbGFzdCBuYW1lKS4gIEZvcg0KPiB0aG9zZSBvbiB0aGUgcmV2
aWV3ZXJzIGxpc3QgYmVsb3csIHBsZWFzZSBSLWIvQS1iIHRvIGtlZXAgeW91ciBuYW1lIGFzIGEN
Cj4gcmV2aWV3ZXIuICBNb3JlIHZvbHVudGVlcnMgYXJlIHN0aWxsIHdlbGNvbWUsIHBsZWFzZSBs
ZXQgbWUga25vdw0KPiBleHBsaWNpdGx5OyBSLWIvQS1iIHdpbGwgbm90IGJlIHVzZWQgdG8gYXV0
b21hdGljYWxseSBhZGQgcmV2aWV3ZXJzIGJ1dA0KPiBhcmUgb2YgY291cnNlIHdlbGNvbWUuICBU
aGFua3MsDQo+IA0KPiBBbGV4DQo+IA0KPiBbMV1odHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwv
MjAyMjAzMTAxMzQ5NTQuMGRmNGJiMTIuYWxleC53aWxsaWFtc29uQHJlDQo+IGRoYXQuY29tLw0K
PiANCj4gIERvY3VtZW50YXRpb24vZHJpdmVyLWFwaS9pbmRleC5yc3QgICAgICAgICAgICAgICAg
IHwgICAgMSArDQo+ICAuLi4vdmZpby1wY2ktdmVuZG9yLWRyaXZlci1hY2NlcHRhbmNlLnJzdCAg
ICAgICAgICB8ICAgMzUgKysrKysrKysrKysrKysrKysrKysNCj4gIC4uLi9tYWludGFpbmVyL21h
aW50YWluZXItZW50cnktcHJvZmlsZS5yc3QgICAgICAgIHwgICAgMSArDQo+ICBNQUlOVEFJTkVS
UyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMTAgKysrKysrDQo+
ICA0IGZpbGVzIGNoYW5nZWQsIDQ3IGluc2VydGlvbnMoKykNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0
NCBEb2N1bWVudGF0aW9uL2RyaXZlci1hcGkvdmZpby1wY2ktdmVuZG9yLWRyaXZlci0NCj4gYWNj
ZXB0YW5jZS5yc3QNCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RyaXZlci1hcGkv
aW5kZXgucnN0IGIvRG9jdW1lbnRhdGlvbi9kcml2ZXItDQo+IGFwaS9pbmRleC5yc3QNCj4gaW5k
ZXggYzU3YzYwOWFkMmViLi5kYTEzNzJjOGVjM2QgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRp
b24vZHJpdmVyLWFwaS9pbmRleC5yc3QNCj4gKysrIGIvRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBp
L2luZGV4LnJzdA0KPiBAQCAtMTAzLDYgKzEwMyw3IEBAIGF2YWlsYWJsZSBzdWJzZWN0aW9ucyBj
YW4gYmUgc2VlbiBiZWxvdy4NCj4gICAgIHN5bmNfZmlsZQ0KPiAgICAgdmZpby1tZWRpYXRlZC1k
ZXZpY2UNCj4gICAgIHZmaW8NCj4gKyAgIHZmaW8tcGNpLXZlbmRvci1kcml2ZXItYWNjZXB0YW5j
ZQ0KPiAgICAgeGlsaW54L2luZGV4DQo+ICAgICB4aWxseWJ1cw0KPiAgICAgem9ycm8NCj4gZGlm
ZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZHJpdmVyLWFwaS92ZmlvLXBjaS12ZW5kb3ItZHJpdmVy
LWFjY2VwdGFuY2UucnN0DQo+IGIvRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8tcGNpLXZl
bmRvci1kcml2ZXItYWNjZXB0YW5jZS5yc3QNCj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gaW5k
ZXggMDAwMDAwMDAwMDAwLi4zYTEwOGQ3NDg2ODENCj4gLS0tIC9kZXYvbnVsbA0KPiArKysgYi9E
b2N1bWVudGF0aW9uL2RyaXZlci1hcGkvdmZpby1wY2ktdmVuZG9yLWRyaXZlci1hY2NlcHRhbmNl
LnJzdA0KPiBAQCAtMCwwICsxLDM1IEBADQo+ICsuLiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjog
R1BMLTIuMA0KPiArDQo+ICtBY2NlcHRhbmNlIGNyaXRlcmlhIGZvciB2ZmlvLXBjaSBkZXZpY2Ug
c3BlY2lmaWMgZHJpdmVyIHZhcmlhbnRzDQo+ICs9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gPQ0KPiArDQo+ICtPdmVydmll
dw0KPiArLS0tLS0tLS0NCj4gK1RoZSB2ZmlvLXBjaSBkcml2ZXIgZXhpc3RzIGFzIGEgZGV2aWNl
IGFnbm9zdGljIGRyaXZlciB1c2luZyB0aGUNCj4gK3N5c3RlbSBJT01NVSBhbmQgcmVseWluZyBv
biB0aGUgcm9idXN0bmVzcyBvZiBwbGF0Zm9ybSBmYXVsdA0KPiAraGFuZGxpbmcgdG8gcHJvdmlk
ZSBpc29sYXRlZCBkZXZpY2UgYWNjZXNzIHRvIHVzZXJzcGFjZS4gIFdoaWxlIHRoZQ0KPiArdmZp
by1wY2kgZHJpdmVyIGRvZXMgaW5jbHVkZSBzb21lIGRldmljZSBzcGVjaWZpYyBzdXBwb3J0LCBm
dXJ0aGVyDQo+ICtleHRlbnNpb25zIGZvciB5ZXQgbW9yZSBhZHZhbmNlZCBkZXZpY2Ugc3BlY2lm
aWMgZmVhdHVyZXMgYXJlIG5vdA0KPiArc3VzdGFpbmFibGUuICBUaGUgdmZpby1wY2kgZHJpdmVy
IGhhcyB0aGVyZWZvcmUgc3BsaXQgb3V0DQo+ICt2ZmlvLXBjaS1jb3JlIGFzIGEgbGlicmFyeSB0
aGF0IG1heSBiZSByZXVzZWQgdG8gaW1wbGVtZW50IGZlYXR1cmVzDQo+ICtyZXF1aXJpbmcgZGV2
aWNlIHNwZWNpZmljIGtub3dsZWRnZSwgZXguIHNhdmluZyBhbmQgbG9hZGluZyBkZXZpY2UNCj4g
K3N0YXRlIGZvciB0aGUgcHVycG9zZXMgb2Ygc3VwcG9ydGluZyBtaWdyYXRpb24uDQo+ICsNCj4g
K0luIHN1cHBvcnQgb2Ygc3VjaCBmZWF0dXJlcywgaXQncyBleHBlY3RlZCB0aGF0IHNvbWUgZGV2
aWNlIHNwZWNpZmljDQo+ICt2YXJpYW50cyBtYXkgaW50ZXJhY3Qgd2l0aCBwYXJlbnQgZGV2aWNl
cyAoZXguIFNSLUlPViBQRiBpbiBzdXBwb3J0IG9mDQo+ICthIHVzZXIgYXNzaWduZWQgVkYpIG9y
IG90aGVyIGV4dGVuc2lvbnMgdGhhdCBtYXkgbm90IGJlIG90aGVyd2lzZQ0KPiArYWNjZXNzaWJs
ZSB2aWEgdGhlIHZmaW8tcGNpIGJhc2UgZHJpdmVyLiAgQXV0aG9ycyBvZiBzdWNoIGRyaXZlcnMN
Cj4gK3Nob3VsZCBiZSBkaWxpZ2VudCBub3QgdG8gY3JlYXRlIGV4cGxvaXRhYmxlIGludGVyZmFj
ZXMgdmlhIHN1Y2gNCj4gK2ludGVyYWN0aW9ucyBvciBhbGxvdyB1bmNoZWNrZWQgdXNlcnNwYWNl
IGRhdGEgdG8gaGF2ZSBhbiBlZmZlY3QNCj4gK2JleW9uZCB0aGUgc2NvcGUgb2YgdGhlIGFzc2ln
bmVkIGRldmljZS4NCj4gKw0KPiArTmV3IGRyaXZlciBzdWJtaXNzaW9ucyBhcmUgdGhlcmVmb3Jl
IHJlcXVlc3RlZCB0byBoYXZlIGFwcHJvdmFsIHZpYQ0KPiArU2lnbi1vZmYvQWNrZWQtYnkvZXRj
IGZvciBhbnkgaW50ZXJhY3Rpb25zIHdpdGggcGFyZW50IGRyaXZlcnMuDQo+ICtBZGRpdGlvbmFs
bHksIGRyaXZlcnMgc2hvdWxkIG1ha2UgYW4gYXR0ZW1wdCB0byBwcm92aWRlIHN1ZmZpY2llbnQN
Cj4gK2RvY3VtZW50YXRpb24gZm9yIHJldmlld2VycyB0byB1bmRlcnN0YW5kIHRoZSBkZXZpY2Ug
c3BlY2lmaWMNCj4gK2V4dGVuc2lvbnMsIGZvciBleGFtcGxlIGluIHRoZSBjYXNlIG9mIG1pZ3Jh
dGlvbiBkYXRhLCBob3cgaXMgdGhlDQo+ICtkZXZpY2Ugc3RhdGUgY29tcG9zZWQgYW5kIGNvbnN1
bWVkLCB3aGljaCBwb3J0aW9ucyBhcmUgbm90IG90aGVyd2lzZQ0KPiArYXZhaWxhYmxlIHRvIHRo
ZSB1c2VyIHZpYSB2ZmlvLXBjaSwgd2hhdCBzYWZlZ3VhcmRzIGV4aXN0IHRvIHZhbGlkYXRlDQo+
ICt0aGUgZGF0YSwgZXRjLiAgVG8gdGhhdCBleHRlbnQsIGF1dGhvcnMgc2hvdWxkIGFkZGl0aW9u
YWxseSBleHBlY3QgdG8NCj4gK3JlcXVpcmUgcmV2aWV3cyBmcm9tIGF0IGxlYXN0IG9uZSBvZiB0
aGUgbGlzdGVkIHJldmlld2VycywgaW4gYWRkaXRpb24NCj4gK3RvIHRoZSBvdmVyYWxsIHZmaW8g
bWFpbnRhaW5lci4NCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vbWFpbnRhaW5lci9tYWlu
dGFpbmVyLWVudHJ5LXByb2ZpbGUucnN0DQo+IGIvRG9jdW1lbnRhdGlvbi9tYWludGFpbmVyL21h
aW50YWluZXItZW50cnktcHJvZmlsZS5yc3QNCj4gaW5kZXggNWQ1Y2MzYWNkZjg1Li44YjQ5NzFj
N2UzZmEgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vbWFpbnRhaW5lci9tYWludGFpbmVy
LWVudHJ5LXByb2ZpbGUucnN0DQo+ICsrKyBiL0RvY3VtZW50YXRpb24vbWFpbnRhaW5lci9tYWlu
dGFpbmVyLWVudHJ5LXByb2ZpbGUucnN0DQo+IEBAIC0xMDMsMyArMTAzLDQgQEAgdG8gZG8gc29t
ZXRoaW5nIGRpZmZlcmVudCBpbiB0aGUgbmVhciBmdXR1cmUuDQo+ICAgICAuLi9udmRpbW0vbWFp
bnRhaW5lci1lbnRyeS1wcm9maWxlDQo+ICAgICAuLi9yaXNjdi9wYXRjaC1hY2NlcHRhbmNlDQo+
ICAgICAuLi9kcml2ZXItYXBpL21lZGlhL21haW50YWluZXItZW50cnktcHJvZmlsZQ0KPiArICAg
Li4vZHJpdmVyLWFwaS92ZmlvLXBjaS12ZW5kb3ItZHJpdmVyLWFjY2VwdGFuY2UNCj4gZGlmZiAt
LWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMNCj4gaW5kZXggNDMyMmI1MzIxODkxLi5m
ZDE3ZDE4OTEyMTYgMTAwNjQ0DQo+IC0tLSBhL01BSU5UQUlORVJTDQo+ICsrKyBiL01BSU5UQUlO
RVJTDQo+IEBAIC0yMDMxNCw2ICsyMDMxNCwxNiBAQCBGOglkcml2ZXJzL3ZmaW8vbWRldi8NCj4g
IEY6CWluY2x1ZGUvbGludXgvbWRldi5oDQo+ICBGOglzYW1wbGVzL3ZmaW8tbWRldi8NCj4gDQo+
ICtWRklPIFBDSSBWRU5ET1IgRFJJVkVSUw0KPiArUjoJSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZp
ZGlhLmNvbT4NCj4gK1I6CVlpc2hhaSBIYWRhcyA8eWlzaGFpaEBudmlkaWEuY29tPg0KPiArUjoJ
U2hhbWVlciBLb2xvdGh1bSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPg0K
PiArUjoJS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ICtMOglrdm1Admdlci5r
ZXJuZWwub3JnDQo+ICtTOglNYWludGFpbmVkDQo+ICtQOglEb2N1bWVudGF0aW9uL2RyaXZlci1h
cGkvdmZpby1wY2ktdmVuZG9yLWRyaXZlci1hY2NlcHRhbmNlLnJzdA0KPiArRjoJZHJpdmVycy92
ZmlvL3BjaS8qLw0KPiArDQo+ICBWRklPIFBMQVRGT1JNIERSSVZFUg0KPiAgTToJRXJpYyBBdWdl
ciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiAgTDoJa3ZtQHZnZXIua2VybmVsLm9yZw0KPiAN
Cg0K
