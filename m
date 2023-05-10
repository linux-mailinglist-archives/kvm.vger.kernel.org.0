Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BED6FDDFA
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 14:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbjEJMlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 08:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbjEJMlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 08:41:22 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F633114;
        Wed, 10 May 2023 05:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683722481; x=1715258481;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gsffkJL/cDEIYqhVQHYySTL3ZCsy/97AC1ww8l80hdo=;
  b=hygBmB9NcORVl/Td9RY41PjHrgFKtPAunNr7k4/vPkRHeX3pBdcZpaHG
   KPekZKctbg0A6SBKYBgjytK2tuVLLqAGTq/H0YFHCCI5LGVLy+tSPn9vC
   6secpf7DhjTzHDzyyA6N28Sv4BmItiMt31PluHRLgAR/WXclKta5fSUfz
   WyQRx1wyJMxTVNU6jYW6Fevhqdqg7mM0tjI/C71SvTD46wA6aaXJYa/9e
   qxL46Tf1k2wiVUAk0TGjaMuSaHx8DB2qJoPbkuKPs/kfOpy0Vn04CqroR
   qXxST32Y7+IBTlCiMSvbuz8jMkfklY+oLKm0OE1ZDnBFE0FkZWy6smKJh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="334669287"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="334669287"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 05:41:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="873562298"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="873562298"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 10 May 2023 05:41:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 05:41:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 05:41:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 05:41:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 05:41:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HISQZ17gqXzcYE0dU1ck4rSqmpaG+j3IIZoQ/0jc37+M61w0kmHagavsTBBLthGMcMmsNupvYU/f26GD2M4a1Com62UpHMybDLmxpURwe+w1P47+pKsRfaYSx3oWklb7zkmQiMxRo3PnHpKFI0MaZhro/fegKK0ELEcu1v5PoqAreSino9aqWkAT7Yu0Hqw5HE94apSZd98N9qHySaEGHQvOVsRkFN/MRfvys6D0Ix7NJmnzqQtL0FmnMfxY9mPyycaXFMgzR073DYwIq80H5nV2gUvN4F5AYxU/TCJm7RR+Abr/KW7EiOCx9c/j/MAGkPyM9tPmDrXeEYg7d7+xUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsffkJL/cDEIYqhVQHYySTL3ZCsy/97AC1ww8l80hdo=;
 b=GyW2+1P8ye9ss0GY3YAybIV50q/XMGHK0yeRJsHK8bXyXz/fyIwX0SL0CoJ6YY5RA/1MJsKUMO07J9Qsug9pwYFRWK973FGEJEYNMmIW9hcd9chZwMHwmOTYctz38na7mB9czomqBXowqMy2Qc0jKtQqA7YCSyudSHv/P8KmtzHp4YYqoQ9fgRfgRvZraaecXyCK6o4PQT7m6CXyEeqVuUsO74mJu2pcWPOdfhAcrbwUqjO4tt9kTq75lado7b9JhTh1j9yH1pnvWw7v3/ODjd0qz+FM8XTgE50WCU9hvbPf1ZGAPZl+HVU39eDisDwjNhmYf0LXqHSmze9Hj9k2YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB5799.namprd11.prod.outlook.com (2603:10b6:303:181::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Wed, 10 May
 2023 12:41:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 12:41:16 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v8 1/6] KVM: x86: Consolidate flags for __linearize()
Thread-Topic: [PATCH v8 1/6] KVM: x86: Consolidate flags for __linearize()
Thread-Index: AQHZgwWbZiqILEByZkOUDczmkb+9ma9Tc1wA
Date:   Wed, 10 May 2023 12:41:16 +0000
Message-ID: <c9cbb52001c7229a6d6d140262adb327233f75fb.camel@intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
         <20230510060611.12950-2-binbin.wu@linux.intel.com>
In-Reply-To: <20230510060611.12950-2-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB5799:EE_
x-ms-office365-filtering-correlation-id: 2407997f-bc09-4de2-6b88-08db5153d8d2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wN7ddwU/H0ZxKoEdC+tTKWF9VEGbh3hn4rq43/vKnIXJInJpcFpfPLi5UExcZAxAIyRwCwgQE0opA+eHDDH9ASLWQIKAtp/QPWoKF72MFPhZIGPKA3bH/m2ZE+ezcn+KzbOEoPjkQswASfA+H+Syg3BvoSn0i/FJ6RI8LyUfPOX/5Q+Zf+MJAHHxI5i4EqBoCSqX+STroY7uaNI2PmzTI54pmDywDWQovvXRajSkieCMCBL0+0/sIY++08tfijAADXLQGu4pZfa11vQKJxBcLVFOwi0izIjMbuS/l266B1Fk5qKiHZj6TBVab1+35xlspaATIh/fJEMkzbswJisCsdQNT30v48shEn4CZ/c56/PJkJp8sB7iJmyceoyVc/wUwr/y7FXUlhI6wRYqjjk4wIlazvmiSGedZzTlyOhUyX+tIgcNMBrZeZH5jsmv+YuoXtxlPPl/A2yHdUs+Sr52E0jKL3KFNmCMhpXAqC5fTVNyYv8Z/qd0uzlT9Inpe7J03LAweQTbDGaOXgvakM5wj5PxROgeZhz4oVo+S/cH07JoIn6lPhirUWmff8aAHAB4yG2/bdXaU2IVq1NvBYQmWgut/kAsVaQ1oNI/xWx8go9w0fS12xt7kCuOsWZyil8P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199021)(2616005)(186003)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(41300700001)(122000001)(5660300002)(91956017)(8676002)(8936002)(4326008)(316002)(6512007)(82960400001)(6506007)(2906002)(26005)(36756003)(478600001)(54906003)(86362001)(110136005)(38100700002)(71200400001)(38070700005)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1NwUVNNQWpMalJiekVlUW42MlI2cWlWblIrY3Y0SUhVcXM3WXhjZkxmWnM1?=
 =?utf-8?B?UWZJN0pHSnRSVHNkQ1JGZUlPdThKSnM4TkREUWw5SC9UclRXb09Ua1lwUVRL?=
 =?utf-8?B?c29zcUxQaDRjZUcxb0VsOWI2QnhkTFVNV0ZhWXkvWmw5U01CcmRGWTFFem05?=
 =?utf-8?B?ZjZPYm1jM0oxOHpUWThCOEh3RTIwaXVTSlRWWTVmWTR0aTdrbUhvdDJFeU52?=
 =?utf-8?B?OUpvK0hyaW5lMTlVR1hzUDd1bEEzYTZXMHJTWVZTYlBNeUFaTXR2Y3dKTlEr?=
 =?utf-8?B?K2FCQThnNEl6ZWMyNXV6b09kb040MDlrOHJOWlV6SmwvcDJVMUVlSlkyY0d0?=
 =?utf-8?B?dnNXMjNrZjdDOHpzMmw1OUdGNEpqV3pyWEhScmYwYkFSY3FYdmxHY29UdFc1?=
 =?utf-8?B?UUFrYkdMTkRlKy80UGtENlRQeEJ4eVc4SDMwbU93MFhBU3FaejFqMmVlaTR6?=
 =?utf-8?B?T2tFYndkNEpJQmxPOGZCTEZvU3JqVnNDU0RLcTVWRThqbUFKTHlLOFBPUG9n?=
 =?utf-8?B?bmN3SGtMSW5Rb0R2L3hVa0gwMGVJZkd1V0labW5HZG9lRHJMUkltRk4zV1Ju?=
 =?utf-8?B?MDV1MTRkc296SGs5QWNyS1dEYnpablJHOFF2UkFQUHQrRGNUZHdJVkFiVTZL?=
 =?utf-8?B?Rm5UNmZvVnhEcVdEL3RRQmpOTWpYQm5RVkRReHBBZko3QnIrMlhvMXpVeEth?=
 =?utf-8?B?V3pobFdJY3EzeXQ1RTJtWks0MWN5ek0rcHRuMzZHR0I3YSthNTVKS2N5Nkcw?=
 =?utf-8?B?SlE0R2phcU1rbVUxazN6cUtsT2Y5VStUS1U0ZDExb1pLbkxPbWpyeTBMbTcx?=
 =?utf-8?B?WTlPcEpqR3JPM2ZsejBZb0diL0hieUI2dXNQK3RJMWFoaVBobDBzUUhKdG1q?=
 =?utf-8?B?d1BHNWJ1MnBOc3VZQlVEZUVQSEFDbmZ6Y1VGVE84NElLdGNvN1NhcnFPREJQ?=
 =?utf-8?B?cm5UZ0FZd3lhK1ZHb1NuSENxWDBQbEQwQVcwVjhBek93Z09vcUI4ZG04MHBV?=
 =?utf-8?B?YVdJbFhUTXd3aTJPTTBMNnQvOFZXZDNrVjF1SzZwOW1kMWZPTHJvbGExN04x?=
 =?utf-8?B?VnZva0tYSmFVQW1yMVJwalNoWEVDQ2lCWnVqc2dkcUo1UmltcXdnWEdjMTd3?=
 =?utf-8?B?bVNaRmIrZ0lpenNmbXNrMnprTUNEdGhxZ0hNbEJ3cWxqbkdlV1YyVm5qRWdR?=
 =?utf-8?B?bWdQYkdYM0x6WGpRMWtHdklkUEk0QW1tTHJHRmQ3WjVKSHY2VmFNNG5sZm80?=
 =?utf-8?B?OTlkMU5CbDREYWhkMG9hZ2g1dTRFbmZldzUrRTNTSXpNQUhlZjIrYWxUQUY3?=
 =?utf-8?B?QS9XUmszR09Lc0tycXBTY0cvWkxsc1hMVENkUm9ycHMxK3JBUnpFd2FjY0FJ?=
 =?utf-8?B?NlF4MkxrZFhlTFhPZEx6bUhCREZ5V2lFakxvWndHMEtFTzdHNkVSRTBUczB4?=
 =?utf-8?B?YThvNWFQWjZJcXNBTHg1bm9Mb3Z5RktIMUU5WnEvbTZNRmlRb1pDeitaQUps?=
 =?utf-8?B?d2l4UFJvakJzVFh2aGppM0FaYWJVRFFkMjRabVByUUVodGh1YWtJUTFXVkh6?=
 =?utf-8?B?WlBrRUJWQmRsSG5XL2lJcGxpSm9KRlh0YVY4NHZUbDFvbURHVEN0dzVXeUYy?=
 =?utf-8?B?SUs5bFgvSTFKamd6ZUNGaS85MFE2bkhGRGFadktwWEJFcUNlaW9oTDBqSkFV?=
 =?utf-8?B?UjVPd3grVFVoOVVZOS9FNkVNcElheE1wZktDVlUrRE01SFNhSmlCVG1Wb29i?=
 =?utf-8?B?bmgxVlBmdDdlRVFURmcrYmxKRHNWTDczd1RBVkZMbjlQc1FGTmVwb2RCVGxn?=
 =?utf-8?B?Y1d6WWNuVDVVT2FTS09xeCt6Z0hpZUFKYjF5MkcwRzFsQTlOaGVQMEtYeVp2?=
 =?utf-8?B?MUlNbURXVnpXSjArajF5QmIyZWRwQ3RmTFdEczdtNWlSbnM0SHUreWpwbWp3?=
 =?utf-8?B?KzhHM0lLYmVqZDlkWVZudTROSTc0cmY2bjBWTTBTcWJQOXVSdFJQbU9YZTdI?=
 =?utf-8?B?TUVYcTc0NFE3ZFk3ZjdqczhNU1ptWjJ0dk1vNzVoRGJ0YTNZNXFvTGhGS25u?=
 =?utf-8?B?V1pQQ2NUMTRFcnM1dlZqWjAwTFhreHJodU5IRXBpRG1MVm9ONjMyMmtZTllj?=
 =?utf-8?Q?M5AEOuEjPrOZ0xrQagX5jXtNT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CF6E975E5915E4EB2DDDB81B75A2BC3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2407997f-bc09-4de2-6b88-08db5153d8d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 12:41:16.4256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DtF4kMXQkr53Iw5G8WvD3O6s/XOifNJJRQ6bM5ixoOlfV8WwgePkLOF6vKIgFlu3KEBpG4uGvbVdoWHzGCAdwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5799
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTEwIGF0IDE0OjA2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IERl
ZmluZSBhIDMyLWJpdCBwYXJhbWV0ZXIgYW5kIGNvbnNvbGlkYXRlIHRoZSB0d28gYm9vbHMgaW50
byBpdC4NCg0KVGVjaG5pY2FsbHksIHBlciBDIHN0YW5kYXJkIEkgZG9uJ3QgdGhpbmsgeW91IGNh
biAiZGVmaW5lIiBhIHBhcmFtZXRlciBvZiBhDQpmdW5jdGlvbiwgYnV0IGNhbiBvbmx5ICJkZWNs
YXJlIi4NCg0KPiANCj4gX19saW5lYXJpemUoKSBoYXMgdHdvIGJvb2wgcGFyYW1ldGVycyB3cml0
ZSBhbmQgZmV0Y2guIEFuZCBuZXcgZmxhZw0KPiB3aWxsIGJlIG5lZWRlZCB0byBzdXBwb3J0IG5l
dyBmZWF0dXJlIChlLmcuIExBTSBuZWVkcyBhIGZsYWcgdG8gc2tpcA0KPiBhZGRyZXNzIHVudGFn
IHVuZGVyIHNvbWUgY29uZGl0aW9ucykuDQoNClNpbmNlIHRoaXMgaXMgdGhlIGZpcnN0IHBhdGNo
IHRvIG1lbnRpb24gTEFNIGluIHRoaXMgc2VyaWVzLCBpdCB3b3VsZCBiZSBiZXR0ZXINCnRvIHVz
ZSB0aGUgZnVsbCBuYW1lIEludGVsIExpbmVhciBBZGRyZXNzIE1hc2tpbmcgKExBTSkuDQogIA0K
PiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQo+IA0KPiBJbiB0aGUgZm9sbG93
LXVwIHBhdGNoZXMsIHRoZSBuZXcgcGFyYW1ldGVyIHdpbGwgYmUgZXh0ZW5kZWQgZm9yIExBTS4N
Cg0KQSBkdXBsaWNhdGVkIHNlbnRlbmNlIHRvIG1lLiAgUGVyaGFwcyB5b3UgY2FuIGp1c3QgcmVt
b3ZlIGl0Lg0KDQpTb21lIGNoYW5nZWxvZyBtYXRlcmlhbCBGWUk6DQoNCglDb25zb2xpZGF0ZSB0
d28gYm9vbCBwYXJhbWV0ZXJzICh3cml0ZS9mZXRjaCkgb2YgX19saW5lYXJpemUoKSBpbnRvIGHC
oA0KCSd1MzIgZmxhZycgcGFyYW1ldGVyIHRvIG1ha2UgdGhlIGZ1bmN0aW9uIGJlIG1vcmUgY29u
Y2lzZSBhbmQgZnV0dXJlDQoJZXh0ZW5kYWJsZSwgaS5lLiB0byBzdXBwb3J0IEludGVsIExpbmVh
ciBBZGRyZXNzIE1hc2tpbmcgKExBTSksIHdoaWNowqANCglhbGxvd3MgaGlnaCBub24tYWRkcmVz
cyBiaXRzIG9mwqBsaW5lYXIgYWRkcmVzcyB0byBiZSB1c2VkIGFzIG1ldGFkYXRhLg0KDQoJRGVm
aW5lIHR3byBmbGFncyB0byByZXBsYWNlIHRoZSB0d28gYm9vbHMuICBBIG5ldyBmbGFnIHdpbGwg
YmUgYWRkZWQgdG8NCgl0byBzdXBwb3J0IExBTSB0byBza2lwIG1hc2tpbmcgb2ZmIG1ldGFkYXRh
IGJpdHMgb2YgbGluZWFyIGFkZHJlc3MNCnVuZGVyDQoJc29tZSBjb25kaXRpb25zLg0KDQoJTm8g
ZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJpbmJp
biBXdSA8YmluYmluLnd1QGxpbnV4LmludGVsLmNvbT4NCg0KQW55d2F5Og0KDQpBY2tlZC1ieTog
S2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K
