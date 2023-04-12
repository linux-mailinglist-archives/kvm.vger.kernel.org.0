Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1E86DF1A7
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 12:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjDLKIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 06:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjDLKIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 06:08:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308C1F1
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 03:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681294131; x=1712830131;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CUfzw7IXEFOUUDgjzRNtYJ3LxyOeHhGuDVq8CJks87o=;
  b=OtTLnFClu3APUZPXfqwloVoMoffAa2OZCmYKlZzQveK/y1d69X0g6ECM
   dyyMDCmQ0FOv3hdwxlIEXk9tZol/flsQ5e1PSKsd2eFMvhDYk3ZiJ5OuA
   KRrlqwCenUEN8Dcfi5iBfpPbHbDwvYL+VN76+ysAkhm1YvoZwdibtoMqv
   tu3MvMteYJ01c/FbNGHxnEZqn8061aIP7+cCxWKy8nWeuRrUjvqxUnd1M
   JEF67T1Rqu6Sa6eS2M35uH5g7vt5v76CAm7GwzQRuh/vfu8RUO/D9OWuo
   udyW5RZ8SIGmYzGatNq+l4qC14N8bV0A2lwPut8WAj6Zdqs0V+KfrgXhR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="343858505"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="343858505"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 03:08:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="753476006"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="753476006"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 12 Apr 2023 03:08:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 03:08:50 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 03:08:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 03:08:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 03:08:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B83AiaUktqo3c7P/LTJajB3MlFazmzDSHOrj29EocA18DXA+/WGgE/jis3zHMCW5bZXwszSLDG8vhQnSLy0Uj4y+/KEXrjttM8yKCDP7/W7A26lD2TOR9rMdZwPLffIt8MTVYzHUbhxWGX+luI8IdOPxp9TGM18c8PxJehbomnLHtZwUzYeQCLkUbaaFxzIJdXueWcYXbewqprPsFmfmrdcP/4tW2hToYNqp3kUzzpOhmO06G8XwVrttZN1aSxsFvp7CLubE2OWEW6VAvaRF2B0tmZO6CpjEBr4uAaaMHE9laggJj9wG5F19KjbKG9/I66kA3eL/4OBI7HuXI42TBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUfzw7IXEFOUUDgjzRNtYJ3LxyOeHhGuDVq8CJks87o=;
 b=TYAkd5u5GzQH9iM5o2jc3aFvclZ21Wa5LLN9J2uJ8/lPEoGXouXWReFXmUbK7sK3R74N48QBauPAae+7h8uEN3CeQUEGRAwwyLkSTDRjompo3B1D27EPYpy8Ybca9OKx2HgxMY8xQWnq6wZRWFSkIYC0sqxESnWa/DwGrQKIWQuNHZes3CJQ/nNaPT/KIb2hLHAsdHQ8ifcyHxaHUkdlyg5HQ5Pd/ckkYG2Uy6/dZyW32eJhplVeTOx0NfvcBFC9dpopLwWeDWVcKp/C8OygUoz1aaqPz2cln4W8yU0QHw7vbNH826BZU3aLNSOrsRLKvMRSNYUziE2RLAQd0mTfAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6851.namprd11.prod.outlook.com (2603:10b6:806:2a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Wed, 12 Apr
 2023 10:08:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Wed, 12 Apr 2023
 10:08:47 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v2 0/4] x86: Add test cases for LAM
Thread-Topic: [PATCH v2 0/4] x86: Add test cases for LAM
Thread-Index: AQHZWjwDnb8S+br+10efEcD0ZHwVAq8eRI0AgABLbQCACQkTgA==
Date:   Wed, 12 Apr 2023 10:08:47 +0000
Message-ID: <85afe10257eef98a705b2d430ec3af9c670c5d8d.camel@intel.com>
References: <20230319082225.14302-1-binbin.wu@linux.intel.com>
         <9896a0bf26e48dab853049f40733df5bb0e287a1.camel@intel.com>
         <ZC7sQLdYpweORB6o@google.com>
In-Reply-To: <ZC7sQLdYpweORB6o@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6851:EE_
x-ms-office365-filtering-correlation-id: 5b5f3468-5796-487f-6896-08db3b3de7d5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rc9rEzC06Nl0OfcX22sX9rjixhPO8ZKD8Kqf8BR6+asPEmqgmmgW94kxn8wZNkos48GV2q7RTZdMYTEStGG6GlIpSuVTEK/Uz2xmD7AEp+ii2p695gJQTIyTKtpNVGyOLFMqFMIN1npg7Ye77zbyMfnXeMZe/J+vLYew6hQXVPQeigkJ9jIyu2njdA02hm0UkDzgASFB9HCCbB82dlQc7WPmF9LR2hL3ZrXWxS6C8oN37brrFpqdVXu6Jj+rwxVae9X75B/1zTVkkbnwYZqfP2Bkk8n2OKlwl7p/gupGKoMG3K9Kx5cJrF9aRaJbeqadVEnHFxBi4XGxE9uAWFSzrIsDb8E+Li0RLRbRwfeFaWyP3nyNz+xQU5Pr71rkWPgUwdbIwod2qHSpy4+315tcjkD+7fuBsQqcYeE9RYhNxHeoSxwNuq616AEm44fR6TPM4UIjVkoIkb717tcBz+Tg9i2h3vYt2KbGU+7cYVzA/OjHam/kZ/qNTgpsFq8TxK5scVrzC4FOYgV1qUQFPv5alPW3xHMgNk9JWHesRsT85pvsxH2MFI0phx4OPvgTNbe4rNbsy9lkRnqfJI1wj86k/VIewPd/g9o0WmBNoR452u4QVidjIEEkyTZjaZaBAGoB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199021)(36756003)(54906003)(86362001)(316002)(41300700001)(76116006)(91956017)(4326008)(478600001)(6486002)(66556008)(8676002)(71200400001)(66446008)(64756008)(66476007)(66946007)(6916009)(5660300002)(82960400001)(8936002)(4744005)(38100700002)(186003)(2906002)(122000001)(38070700005)(6512007)(6506007)(26005)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UW5tR1lGeDcyUWFhSTFFbnhnQUpJeHlkU1hQV0lFNGVHa0tCUDYrUDFmQ09U?=
 =?utf-8?B?NFRwblVjd1FlYUhtNlIwT0NrbWtubkZLZzhrQnVydU5lQWdsakx2b1I3Z29l?=
 =?utf-8?B?MGUzRlBnNWx0K0tGT2pKNmhVbjNGUGxIa1E2Q0VPK1JVeWZjTkROSnZTVmVW?=
 =?utf-8?B?c3lRT3JpNVl4a3lLNUdCOTdpMkZRaFpjVTlFYVZLNklvcXo4N3VEVW4yeS9X?=
 =?utf-8?B?WitDeVFGcDd2SVpFckNZc0NVK29yWU5zRGtGWUI2T2hXd1hHb3hrY25Oait6?=
 =?utf-8?B?d3pxSEZvUjBhNDdNNUdaNmJzaHdjdEJrSjdvM2dqMlhwalhXeUt3a3gxUDFD?=
 =?utf-8?B?WDdPVzZUV2RjK2Z5VVpqeHdQOVd0cTcvR0dEN0c1MktKTXJBRjdNc1J3d0lT?=
 =?utf-8?B?MTMwcVczd0VtSUJ5em1lZE5OZUtNeFZDTEpaNXRIanRRck5icnJiRmp5dTlE?=
 =?utf-8?B?NUQzaDJ5dnZTdjlXMWN4R0JzekZjdG1aZm9JVDkyTmVPMCtHQUlVN1V1T1Mr?=
 =?utf-8?B?a0F5NURPbkY1VExJc1p6T3ZSNE5mOFpHcnZwa2ZOU1dwZTdjTmM5ejV1Y0Mx?=
 =?utf-8?B?elpBZzhyRnFqV1ZIbm9PMS83L3RGTTA2dnQ3Y2hBZFo5Y3loaVRta0UvNFcz?=
 =?utf-8?B?VTJRUlJaR3JPNlg2SElYVFdxcDQvSy81QnZOMVNkQVJiMzVnWFFVWVNFaWlx?=
 =?utf-8?B?cTFCaWZaSEhZT2UyVmtEekxUUisvVG5WOW1rZE1hRlVnbzBpekxaVktFUS9E?=
 =?utf-8?B?TkNOKzdOT3EvM3I3dW5XSHI3SWhURGFoanJTemlMSEhWN3hVeXVaWG1GQ0hJ?=
 =?utf-8?B?Z0NHaDY0bVYyTVhGTUFEL2JSTnBudTJ3aFoyUFdLTThLajF4NmtrSzRDUW1O?=
 =?utf-8?B?d091S2E0eGNjTndQRmx3OHMvbDEwRkFCNXR5UmNoRG5WYW8vYjQ0WmJ3Qmcx?=
 =?utf-8?B?Q0xPQ0NMcEVKbXkrOStxdGoyakFRY2FHbG44Znp6dDN1OUpDVkxFZ0dPa0Vl?=
 =?utf-8?B?a0kwNXRTQXNxRXN6VXB5K2F1NTFaZnUxV3k4ZnY0ZW9iU1liVURDVFoyQXFo?=
 =?utf-8?B?NldOdTBlQ1dMdUV0amhMNm1CNTI0Tkx5MnZSbmU0UENvMEhOQ3U1dWo4ZC84?=
 =?utf-8?B?WWVKTXVxS013R016OHVYNnJOdXdma3FEUmZFUkFtczVTQTEvNU1tR0ZVVUxx?=
 =?utf-8?B?R0s4dmFxZnF4b0xYN080T1NLeVlhVVFjbGprTzR1dDVJZFVMQ1hMV2hBTXZa?=
 =?utf-8?B?K3VPWklxSkpvWUxMMythb2VUR2JNeTczdkxsZDNZaG5tTGtLR2hNcHdFeE5h?=
 =?utf-8?B?V29RSlcydlVkU2dzMGoySjNBYUZZaWJmOXhKdGVyOFBiazFoVC9UZWxTam5N?=
 =?utf-8?B?ZTFGS1pzeGlMa0tVRU56NkJRSlNSKzV1dVJZU1pQaUhzOHJhOFlnaFVUM1lq?=
 =?utf-8?B?ZE5QdURORk9vQ2JpNXpMeHh5QzlZQkpnSHZiUFkyaTZlTTdKZmxBOVlORmV2?=
 =?utf-8?B?MVlzRURTNjhtUkh3S3ZsVkpFUVlId1FyKzdrOW4rbUl1LzZJdFl5UmxRR1Jo?=
 =?utf-8?B?Wm9ZbW1FWkNYOTVXa2RJVHgrTFpHcC9idkJXSUk4YkNvMWUrdGlzekdqTmFk?=
 =?utf-8?B?bHJqN1ZqZkFMNDM5TWZNVjh4eUVTUnJUUzhqNWdJQU0yZXFhaC9IZ2p5ekQ4?=
 =?utf-8?B?TkRtdVRLUUZQN1o4MnRQSmF2NHlYdWJ6Zk9FU1dlUjlHbTBvWlNFL1h5V3Ux?=
 =?utf-8?B?UlFtTS96YnYvbHBTMXdycjdzOGdDL3lIVU0vcjErcURuTnB5Z0IyNlY0QXRR?=
 =?utf-8?B?VUdxLzUyb3BBbmZBOENpc3pxMnJPYXVSTi8ySVZyUEZ5UFQrd3U3Q0dZWDRp?=
 =?utf-8?B?N0dDbHY3MVdqeGNVWHBrWUxtUnpLZWc4dThDVUlwZFNsaG1Pb2tmUC8yK2Vh?=
 =?utf-8?B?YTN5dlBkWWlaUWlvQTdxTzRPZFd6SzJYeEdUR3RQN2VmR1kwRHBlOGtSL1dY?=
 =?utf-8?B?bkVSdzVjTHBFUStQMk9NUnlUVlIyZjVvRGkzTUpNSUNzcU9JbmNMZ1BPZElF?=
 =?utf-8?B?YmpJdlJ1b0Zpbit0MWREQ1o5K3E2MS9xRlJjTW1TM0pOaW8yT3d6b0kvMVhm?=
 =?utf-8?Q?Bv2V4Dcj5CCnTDmAfk4WM3Gb8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E155F0BFBF02DD47AADC9C63A9817441@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5f3468-5796-487f-6896-08db3b3de7d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 10:08:47.1315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tW3rJR8EfrDXNe2UtpPIOQqJnyOcyCCGdGDaOCMK5uXQYS9wKQnsUPxbd7R2cJuxr38351J5aQlQh3O/QqPv8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6851
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA0LTA2IGF0IDA5OjA5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAwNiwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBT
dW4sIDIwMjMtMDMtMTkgYXQgMTY6MjIgKzA4MDAsIEJpbmJpbiBXdSB3cm90ZToNCj4gPiA+IElu
dGVsIExpbmVhci1hZGRyZXNzIG1hc2tpbmcgKExBTSkgWzFdLCBtb2RpZmllcyB0aGUgY2hlY2tp
bmcgdGhhdCBpcyBhcHBsaWVkIHRvDQo+ID4gPiAqNjQtYml0KiBsaW5lYXIgYWRkcmVzc2VzLCBh
bGxvd2luZyBzb2Z0d2FyZSB0byB1c2Ugb2YgdGhlIHVudHJhbnNsYXRlZCBhZGRyZXNzDQo+ID4g
PiBiaXRzIGZvciBtZXRhZGF0YS4NCj4gPiA+IA0KPiA+ID4gVGhlIHBhdGNoIHNlcmllcyBhZGQg
dGVzdCBjYXNlcyBmb3IgTEFNOg0KPiA+ID4gDQo+ID4gDQo+ID4gSSB0aGluayB5b3Ugc2hvdWxk
IGp1c3QgbWVyZ2UgdGhpcyBzZXJpZXMgdG8gdGhlIHBhdGNoc2V0IHdoaWNoIGVuYWJsZXMgTEFN
DQo+ID4gZmVhdHVyZT8NCj4gDQo+IE5vLCBwbGVhc2Uga2VlcCB0aGVtIHNlcGFyYXRlLiAgQSBs
b3JlIGxpbmsgaW4gdGhlIEtVVCBzZXJpZXMgaXMgbW9yZSB0aGFuDQo+IHN1ZmZpY2llbnQsIGFu
ZCBldmVuIHRoYXQgaXNuJ3QgcmVhbGx5IG5lY2VzYXJ5LiAgYjQgYW5kIG90aGVyIHRvb2xpbmcg
Z2V0DQo+IGNvbmZ1c2VkIGJ5IHNlcmllcyB0aGF0IGNvbnRhaW4gcGF0Y2hlcyBmb3IgdHdvIChv
ciBtb3JlKSBkaWZmZXJlbnQgcmVwb3NpdG9yaWVzLA0KPiBpLmUuIHBvc3RpbmcgZXZlcnl0aGlu
ZyBpbiBvbmUgYnVuZGxlIG1ha2VzIG15IGxpZmUgaGFyZGVyLCBub3QgZWFzaWVyLg0KDQpTb3Jy
eSBJIG1pc3NlZCB0aGlzIGlzIGZvciBLVVQuDQo=
