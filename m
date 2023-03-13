Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E046A6B6CEA
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 01:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCMAyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 20:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCMAyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 20:54:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2AB1631E;
        Sun, 12 Mar 2023 17:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678668871; x=1710204871;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MhP8aLCxdYuCGAJh4uWM52ksmcCmle4Wn2lkfOHO1dc=;
  b=CbsjqyogYMUx1Ycd8iTU8V47TMdhzlBqhZ03UYQE1b1wJslapkoxOu2R
   RuPOtxNuvw60TZwZjyg9iaBTNmePpv/NEklSw+qGUP1Q48Lkv9jYaCx+R
   Znv0RJCWRqktWflJIOjxgAqyCQXKidyUiem6Pmggd2WnyEa5kXgS0nT8M
   TKiC5WXU00q0OIXdulrkJiHXwXFRAxxLx+nro+k5T6+GWYev4JdaimEN1
   vvdBYcTgjYhy+zw7g+isjA/aP6rAi8AkVJj+bQQ8WhOAt1lrQ9NokycE6
   88DpunzJBVgEqwEwYmUXcllBxuzBhSySD64TPBc+2EZaIlQtaMZ62tymL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="335732472"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="335732472"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 17:54:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="671715733"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="671715733"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 12 Mar 2023 17:54:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 17:54:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 17:54:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 17:54:30 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 12 Mar 2023 17:54:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1rS3s8sRznN/MVegFYbAhOEHKJSkN61UL1fiGc8zgwGJZ45i6RF4nqbP22NmT2hvacXKyvaSLVLMUjUtLdDOw4I0S4t3JDwI+SjyPjn/rUcTKhucJtsya/1GzZyw61LHcH9sD9SfledYCgalph/xj9cYDQmNqjojsiGopAJntRDd0Zqd3APCLjB5O+G2ESEOojOL1i78LzG+id0TY7iuf2wt08xaVPGY4puwmanMW9+/wFsQpF6eZkZLkZoD1LS3YMNokNOEqWD1iPGgbNEr3aTCS+em097OzHDQWMIhFbAjdAj4W6D7BCUH/9tzrVfL3y9ytGTKoXLzM6kBBBqdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhP8aLCxdYuCGAJh4uWM52ksmcCmle4Wn2lkfOHO1dc=;
 b=W4aYM610ffMR29pVZN6KP2ym2rgwLgQcfxuymMFhRxGMQynYh/Tykpallyb37jQUd/GfmromHFH8c+RVrx7nHul96/oU0qHF5To0gkChm2lpyZjp4Uyru/RpZ/42e9Y1iZ5nQhxyOCwur5V3SIY6TAjOt111r48O+P3phbXjzK3zHFtyVnGgiWyZUw70sVJf2UP/SHIFs4goGdbmSk/sdaG7Dg2XsBpiQc5z9Suq3GUanigkgJXyyd8ugsskFiEXCxzP3K8dGmrpliHnZKu64QAsGygWg8HNiqb+jW64MOfNA3OVSHRYarYjHrjoK85cfXv8Y2V0mrl6AiM0KykT6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4889.namprd11.prod.outlook.com (2603:10b6:806:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Mon, 13 Mar
 2023 00:54:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 00:54:27 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v2 07/18] x86/reboot: Disable virtualization during reboot
 iff callback is registered
Thread-Topic: [PATCH v2 07/18] x86/reboot: Disable virtualization during
 reboot iff callback is registered
Thread-Index: AQHZU5lLewEuXoBLxUmZ/uq2XZMwc6735YIA
Date:   Mon, 13 Mar 2023 00:54:26 +0000
Message-ID: <4ab086ad30cf5e1ddea863e1a2bcfa21ca72d37e.camel@intel.com>
References: <20230310214232.806108-1-seanjc@google.com>
         <20230310214232.806108-8-seanjc@google.com>
In-Reply-To: <20230310214232.806108-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB4889:EE_
x-ms-office365-filtering-correlation-id: e5ce2902-968f-4e99-a1e8-08db235d7edd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5fdCLlayHWO/MArpQ3FqgLo0kNcU6CYyBXRszF71/DHY7IJ45hid5U4VE28HCO4Qf02eGZCxyvUzuR6J+sPOzo2FoWQHYGjbl09jNwMnsroEqfbC66zsr69ZmX9rWxP/2W1N5cvM682hl7whghsqKkWgStqptOgG+mmNnamoY7rHGwLcFJPjkXpb3/dtNIZGHX1LZe4EdR0KKfTFkM2rrXwfc6Pp++zlmfL+zGny05+tR/Kx3aeZEl/GI5tg3xAYQ9JaoHlgP5JCqxX6aZ/3LBFa7QJn0j/1YYM27o77XVw3/qPlP0Rz1yj3+y8zVtZ3/hE7wdLjJf6eHFXyLfnkIwr5Bna9us76iLZ7BH9r/wOmaKZMQQGlvHamG4CKVY/80Ws2rMOPURrHGNCwLXG93lftI1VO2UuFGHPrCl3kdHKjculWX6koBhwXvFCL2IOJyGfEw3918gWrNVjSK2D9R7HZzxlZgMTZmWsGP72yILA1wVljyoM7eXhSIugEKU1ID4rff4mf1aTCJQCqN/wEJdvTwkjYbeqC9hx4tYOF5f5mMts3b9Kg9MjaCXg1oOzoxCglSxeBx39wko0Rwd+RnwzSZX6dn1zOZ96JoZ/PFdfH9T1F6CdecsGdLCWzYh/W4Ooj75LnE7Jizhd3J0dg1N68PVQPE6PZzanEijqSSMY37dkX7pkihuWNK0r9bttihUh0sPgrv84/JIjKoLejgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(36756003)(110136005)(54906003)(478600001)(71200400001)(5660300002)(316002)(6486002)(7416002)(2906002)(8676002)(8936002)(64756008)(91956017)(76116006)(66556008)(66946007)(66476007)(66446008)(41300700001)(4326008)(122000001)(82960400001)(38070700005)(86362001)(38100700002)(6512007)(186003)(6506007)(2616005)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmlCTVFJRUtyQVNlSk5rS1RtSE5ZQVdRMnFwU0dtOTRaaFpodzdvYTlYZjBB?=
 =?utf-8?B?Zm1wdlhzMzA0aHFVdElVaGkxWC9ic3Vpam1aeVVIL2M4bG9LWkVIMHNSd3p5?=
 =?utf-8?B?RlR4Zlo3cnBtRDY4VlcxOGtZSkVpY09Sek1BUndnazVIb2NRZkVPc1M1S3l0?=
 =?utf-8?B?TXcrQlZ4bzF3dGpBcmdNWWRBQXphSEtLQWZ4ZlgvNjNoSE10a1RhdUlocnBo?=
 =?utf-8?B?b2pvSlh0T2Z5SDd6dEQ5MVFEbnUvVTNuSkl1enNsV3I2eUFYUlNBZnFLZWVI?=
 =?utf-8?B?VGNlMGNsZFpULzZoU3NrYUl5aHBnYXhVdzZtdlUzQVNCUTFoa0RqWEJ0Y1hr?=
 =?utf-8?B?Q0dZOW9IUlBYQXdHWitMeEdRdSt1cWlOZkZCV2NDMFFLRWNqU25yOVEyWEVH?=
 =?utf-8?B?NExrOG00am85SDBZTXpwSlpQQnd5anJ3anpuWjJhR0lrdDRUT05QQmdPSnpk?=
 =?utf-8?B?c1NRejlOQ2dtYjRaQndMcHozSUZMN2QyalBqbDFMQ3hYaklTcm5aS0FmbWhq?=
 =?utf-8?B?WVl1WXBvbHhDeVh6b01sV3U2Yml1Yld6RW4xa0tLWDljdGZNMUhUYVpRdmFa?=
 =?utf-8?B?NVRrYVlYSk5MdkxuZ0tSWUJmRFBGVWJRamgyemFiT1ZqNEs0QWtra1ZNZUla?=
 =?utf-8?B?d29LOERidGZWM0FQNktNTlFwLzF1OEZqZTRiTEp3a2Y4aytPNzRnYUU5TTJw?=
 =?utf-8?B?czNwZGh1UDlZcDRRSWJhTHNxNUN3ZnBzaEplYzExc29DWWxBVDN4QlFRTlYy?=
 =?utf-8?B?dmc0VVgwRFQvWDlTaUJ5ZlNGaTAyVkxRNzMvOFFCVG9MU0pPS3pOSVU2V0hJ?=
 =?utf-8?B?cWQ5VWczcVk4di9lKzkzTTVpMWlHRUcxd2wxb2N5eGVTYzdhbGZFaWNZOVJS?=
 =?utf-8?B?aWlKVy9xNENrU3ZVd2cyQUh4SHViTExkaTJ2QzhEd2F2bHhwaXpSc3BVd1N6?=
 =?utf-8?B?SVArSlRMOWNGbFRDZ0NBa1AvNkpkTmpuald6Q1pPRzJ5MTRiVk5WdFJLWXda?=
 =?utf-8?B?U0xKMklxRTF4aXY2czRMeDFYa0RLN2VxZ0M4VG9aY3FjREZGcHd3Ti9iRTI2?=
 =?utf-8?B?YWo3OGNQaDJ1cGczYkI0cmlHSndvaXVBN2V1Q2cwWnBPMVZ4cXhLZitWVXBp?=
 =?utf-8?B?cHdldEV3OEdROW9oV0tZWHJrVG0xK1BVbE1CczFzTzh1NXBNSXJWejFsTTBL?=
 =?utf-8?B?YnJRWmtoUTZ6Qm9YYmZQUzlSRVVVaEhvVExURGJ2SUJTMC9uTngyQ1R4dTZ0?=
 =?utf-8?B?SnhJN0NYSUVSci8xd2tTMm9DNkRlWnRzQXdKNCtpZk5vSzA1c2hqTjJxbHlS?=
 =?utf-8?B?aHoyUjlNWEtYS1dTSjg1NEdHZXBGeCtiR0pZdWY5NGJ2eVdGeWQ3TW1OLzFP?=
 =?utf-8?B?NW1BejFDMkxnNkRVY2IwLzRhKzdsVGUyblpjWEduWUd4bUN3cG1yM3NZVjVL?=
 =?utf-8?B?SmNkVXAyUkVOb1ZMNDF3VmtXWmFCamw5V2dsbXluZ01nd1k5V0J0V2hSdjFl?=
 =?utf-8?B?L0M5QzVZbUExeWNDYUxIQ2E1UXdXVmZIUUFyMFJ5azVSSVRBV1NzU2N3MDVn?=
 =?utf-8?B?RlJJSHE5cVFMU21NWkNjK1AwY3dJVElJQXo5aTBqbzhPclZKRHQ2Zi9QeEJI?=
 =?utf-8?B?NjFMYnI5TmlnRkhEWjJKWUJqWDMvU2JjRlR6RkdBZU9MTGNYOHBiL0gzRUw3?=
 =?utf-8?B?encvYWhuczJOM0k3cVVwcklPbktxKzV5dUlwRFp4amFweUxOVTZyMW5kV0Q4?=
 =?utf-8?B?WmlhSFdFRXAvTEFnS09BRWp2aDdNeU4wRVMyNTdyV0hycjdhZjdxN3R6YUxs?=
 =?utf-8?B?a21YV1psVFU1Yy9lc28ydThNanBXUnMyN0NoWlp3bEdFQmVCdXpuT2oyZnJ0?=
 =?utf-8?B?Y042R0J4QjZETEdyRU4wbmtSVnVYS0ltSUdEdnJ2Z3YySnJFRkNSaGFkcTMw?=
 =?utf-8?B?Q2ZoZGgzc0ZBS05NbnYyUUhKYnlOZ2RhMlJLWEcvMS8xdWNBVmdSWTYrcVRu?=
 =?utf-8?B?c0lYNHp3YkNwSU1NRldzeFRMRVlsKzlKNkE1Si9WY2dFdnJVdVMzTDBkenRa?=
 =?utf-8?B?WWNIT253RHZocVVNMksrRU5CMjBFcnRLRjduWGZyZlRlaXdrb2YzdTVVeXNx?=
 =?utf-8?B?U0hnenlOM05nUnpnd2FaVVNEME4wTUkwd0xubXh1RWt2MDJqU2Z6TWtrYkFq?=
 =?utf-8?B?REE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25ED2779578D3B4BB64505EBD10E9BEC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ce2902-968f-4e99-a1e8-08db235d7edd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 00:54:27.0129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nv5DnymvcH0GEI/hSHu32FF5vB4iPPwE3EnIX3v71j4hxABTfNJSOqFOgbQGPguBwhe4ib8Hk/02QBqeyeyVrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4889
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAzLTEwIGF0IDEzOjQyIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBdHRlbXB0IHRvIGRpc2FibGUgdmlydHVhbGl6YXRpb24gZHVyaW5nIGFuIGVtZXJn
ZW5jeSByZWJvb3QgaWYgYW5kIG9ubHkNCj4gaWYgdGhlcmUgaXMgYSByZWdpc3RlcmVkIHZpcnQg
Y2FsbGJhY2ssIGkuZS4gaWZmIGEgaHlwZXJ2aXNvciAoS1ZNKSBpcw0KPiBhY3RpdmUuICBJZiB0
aGVyZSdzIG5vIGFjdGl2ZSBoeXBlcnZpc29yLCB0aGVuIHRoZSBDUFUgY2FuJ3QgYmUgb3BlcmF0
aW5nDQo+IHdpdGggVk1YIG9yIFNWTSBlbmFibGVkIChiYXJyaW5nIGFuIGVncmVnaW91cyBidWcp
Lg0KDQpJSVVDLCB0aGlzIHBhdGNoIGlzIHRoZSBmaW5hbCBvbmUgdGhhdCB5b3Ugd2FudCB0byBh
Y2hpZXZlIGhvdyB0aGUgImRpc2FibGUNCnZpcnR1YWxpemF0aW9uIiBjYWxsYmFjayBzaG91bGQg
d29yayBpbiB0aGUgbm9uLUtWTSBjb3JlIGtlcm5lbCAodGhlIHJlc3QNCnBhdGNoZXMgYXJlIHJl
bGF0ZWQgdG8gbW92aW5nIFZNWE9GRiBjb2RlIHRvIEtWTSBhcyB0aGUgY29yZS1rZXJuZWwgbm93
IGp1c3QNCmNhbGxzIHRoZSBjYWxsYmFjaywgZXRjKS4gwqANCg0KVGhlcmUgYXJlIG1pZGRsZSBz
dGVwIHBhdGNoZXMgKDItNykgdG8gZXZlbnR1YWxseSBoZWxwIHRvIGdldCB0byB0aGlzIHBvaW50
LiANCkJ1dCB0byBiZSBob25lc3QsIHBlcnNvbmFsbHksIEkgYW0gbm90IHN1cmUgd2hldGhlciB0
aG9zZSBwYXRjaGVzIGFyZSBuZWNlc3NhcnksDQppLmUuIHRvIG1lIHRoZXkgYWN0dWFsbHkgY29z
dCBtb3JlIHRpbWUgdG8gcmV2aWV3IHNpbmNlIEkgaGF2ZSB0byB0aGluayB3aGV0aGVyDQpzdWNo
IGludGVybWVkaWF0ZSBzdGF0dXMgaXMgcmVhc29uYWJsZSBvciBub3QuICBJIGFtIHdvbmRlcmlu
ZyB3aGV0aGVyIHdlIGNhbg0KanVzdCBtZXJnZSB0aG9zZSBwYXRjaGVzIHRvZ2V0aGVyIGFzIHNp
bmdsZSBvbmUsIHNvIGl0J3MgZWFzeSB0byBzZWUgd2hhdCBpcyB0aGUNCmZpbmFsIGdvYWwgdG8g
YWNoaWV2ZT8NCg0KSnVzdCBteSAyY2VudHMsIG9mIGNvdXJzZS4NCg0KPiANCj4gTm90ZSwgSVJR
cyBhcmUgZGlzYWJsZWQsIHdoaWNoIHByZXZlbnRzIEtWTSBmcm9tIGNvbWluZyBhbG9uZyBhbmQg
ZW5hYmxpbmcNCj4gdmlydHVhbGl6YXRpb24gYWZ0ZXIgdGhlIGZhY3QuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+
ICBhcmNoL3g4Ni9rZXJuZWwvcmVib290LmMgfCA3ICsrKystLS0NCj4gIDEgZmlsZSBjaGFuZ2Vk
LCA0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYva2VybmVsL3JlYm9vdC5jIGIvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jDQo+IGluZGV4
IGNiMjY4ZWM3Y2U4NS4uZGQ3ZGVmM2Q0MTQ0IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rZXJu
ZWwvcmVib290LmMNCj4gKysrIGIvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jDQo+IEBAIC0yMiw3
ICsyMiw2IEBADQo+ICAjaW5jbHVkZSA8YXNtL3JlYm9vdF9maXh1cHMuaD4NCj4gICNpbmNsdWRl
IDxhc20vcmVib290Lmg+DQo+ICAjaW5jbHVkZSA8YXNtL3BjaV94ODYuaD4NCj4gLSNpbmNsdWRl
IDxhc20vdmlydGV4dC5oPg0KPiAgI2luY2x1ZGUgPGFzbS9jcHUuaD4NCj4gICNpbmNsdWRlIDxh
c20vbm1pLmg+DQo+ICAjaW5jbHVkZSA8YXNtL3NtcC5oPg0KPiBAQCAtNTY4LDcgKzU2Nyw2IEBA
IHZvaWQgY3B1X2VtZXJnZW5jeV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uKHZvaWQpDQo+ICAJCWNh
bGxiYWNrKCk7DQo+ICAJcmN1X3JlYWRfdW5sb2NrKCk7DQo+ICB9DQo+IC0jZW5kaWYgLyogQ09O
RklHX0tWTV9JTlRFTCB8fCBDT05GSUdfS1ZNX0FNRCAqLw0KPiAgDQo+ICBzdGF0aWMgdm9pZCBl
bWVyZ2VuY3lfcmVib290X2Rpc2FibGVfdmlydHVhbGl6YXRpb24odm9pZCkNCj4gIHsNCj4gQEAg
LTU4NSw3ICs1ODMsNyBAQCBzdGF0aWMgdm9pZCBlbWVyZ2VuY3lfcmVib290X2Rpc2FibGVfdmly
dHVhbGl6YXRpb24odm9pZCkNCj4gIAkgKiBEbyB0aGUgTk1JIHNob290ZG93biBldmVuIGlmIHZp
cnR1YWxpemF0aW9uIGlzIG9mZiBvbiBfdGhpc18gQ1BVLCBhcw0KPiAgCSAqIG90aGVyIENQVXMg
bWF5IGhhdmUgdmlydHVhbGl6YXRpb24gZW5hYmxlZC4NCj4gIAkgKi8NCj4gLQlpZiAoY3B1X2hh
c192bXgoKSB8fCBjcHVfaGFzX3N2bShOVUxMKSkgew0KPiArCWlmIChyY3VfYWNjZXNzX3BvaW50
ZXIoY3B1X2VtZXJnZW5jeV92aXJ0X2NhbGxiYWNrKSkgew0KPiAgCQkvKiBTYWZlbHkgZm9yY2Ug
X3RoaXNfIENQVSBvdXQgb2YgVk1YL1NWTSBvcGVyYXRpb24uICovDQo+ICAJCWNwdV9lbWVyZ2Vu
Y3lfZGlzYWJsZV92aXJ0dWFsaXphdGlvbigpOw0KPiAgDQo+IEBAIC01OTMsNiArNTkxLDkgQEAg
c3RhdGljIHZvaWQgZW1lcmdlbmN5X3JlYm9vdF9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uKHZvaWQp
DQo+ICAJCW5taV9zaG9vdGRvd25fY3B1c19vbl9yZXN0YXJ0KCk7DQo+ICAJfQ0KPiAgfQ0KPiAr
I2Vsc2UNCj4gK3N0YXRpYyB2b2lkIGVtZXJnZW5jeV9yZWJvb3RfZGlzYWJsZV92aXJ0dWFsaXph
dGlvbih2b2lkKSB7IH0NCj4gKyNlbmRpZiAvKiBDT05GSUdfS1ZNX0lOVEVMIHx8IENPTkZJR19L
Vk1fQU1EICovDQo+ICANCj4gIA0KPiAgdm9pZCBfX2F0dHJpYnV0ZV9fKCh3ZWFrKSkgbWFjaF9y
ZWJvb3RfZml4dXBzKHZvaWQpDQo+IC0tIA0KPiAyLjQwLjAucmMxLjI4NC5nODgyNTRkNTFjNS1n
b29nDQo+IA0KDQo=
