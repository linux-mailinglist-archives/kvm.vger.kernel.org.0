Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E4F6DCB6A
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 21:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDJTOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 15:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDJTOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 15:14:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB251980;
        Mon, 10 Apr 2023 12:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681154074; x=1712690074;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bgxs1+MO+WaHSDIomKIZImPtvHyBRuk/ia/Y7PElOk8=;
  b=UmLYu6F5KluQ3WU1FtSxxTNMVi8hIv4teDf0OguwVJrk6Jr7RSl7RPce
   QMqdr3yyqbCxinY456nP1rzfnNnbZbQvVlIh0Vbv0C5sBwIhk66OVyN7X
   sZmU+gxAMf2sn8fKceef362tB/m1XD89W7nx8F9nosjWhtemhU/pY7NT9
   enOcUo3kaZqOXuDQhOwH63dkJcOSpDR4oEnqQwqmGO3QZsMJGeBEICZYX
   TT3naurnH5cXqE1YPvf25QW+aEfCcOXrYdqAgOywrfgsvidCyUVuUNFAh
   uHBIm+0YNK2KQfIkWuOtWB1bO5U7sUXBOEyhxAP5EjFJ8zmMKMusL03a+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="323069133"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="323069133"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 12:14:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="690886701"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="690886701"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 10 Apr 2023 12:14:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 12:14:33 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 12:14:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 12:14:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 10 Apr 2023 12:14:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axu+pHeKiZGvlsn4S8NmCY88rSaRYuzYBIbegdn10uFwgo2lHhXjy6ieWgqFhviDztn/y/RXnGvwFIvlKOUiUdG5xkUlcY+JGRZXlgSBTp09m8ZzTzdv4aIkLCpIrZAoRej7tnCjvL1MRVaSvWUv3lWa0o9/skaQRwOzK1rtxKO1NBZavk0NPGEeF8vXdtUChtXiB+OwYkWh+TR9MfeRF3s5t00wRzRawcvNCcNQ0tJp66m+m17u6ftiC0R+nXkWfzvmehttRCy19qggFGAoYHnE5+dP1q2WAIS+SF4VviuW37cLt3PmdkrAKMJyPMFXQ1Q8DFpcJHagbQP7wVZHZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgxs1+MO+WaHSDIomKIZImPtvHyBRuk/ia/Y7PElOk8=;
 b=Z4Iw/w2XZHjb5OkklUQyOl+Ds16Q0gTj5qbMaNh6GG9lY4XfBFq/Wg/HPKOgMTVLKdT/dagE8rCMIT/DU6fm5txbtuPq3GFXYpu8QR50m8DB1ULF2LSNSSj32TotDD9p7yVcGS6Hco6aG4mA+PP4tAKZ94IuucHX3po7aYVhnBbqUMKm+oKewwYV8HB31JkyJ+TQ0DE7snT0wXXg8ZRx/mP/YD3iDgSG6lvqU0+qYreY15vjiufHTpzcOt4bbZuXjkqM0q3yTkvJNlMb5iQqH9WrFqE22uC4afgE6wSP+yCFAjvCUrNdzNcWzUdYbnGwosrGuk7VJX2IGdRYSfoZXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH7PR11MB6006.namprd11.prod.outlook.com (2603:10b6:510:1e1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 19:14:23 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%5]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 19:14:21 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>,
        "Lutomirski, Andy" <luto@kernel.org>
Subject: RE: [PATCH v8 00/33] x86: enable FRED for x86-64
Thread-Topic: [PATCH v8 00/33] x86: enable FRED for x86-64
Thread-Index: AQHZa4g5E/QemdFnfket3mQeyiRQG68k3+WAgAACSoA=
Date:   Mon, 10 Apr 2023 19:14:21 +0000
Message-ID: <SA1PR11MB6734C0AE97E8B5ACF70CA32AA8959@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <f3b12e7a-3536-c0af-2c67-d94c56b6fcc5@intel.com>
In-Reply-To: <f3b12e7a-3536-c0af-2c67-d94c56b6fcc5@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH7PR11MB6006:EE_
x-ms-office365-filtering-correlation-id: e6683354-80d2-419a-e7a6-08db39f7ca2b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QGnVrcV4SI24wFIQ0Jo0Q7fbUVeiNAqwo9+uWKKqa0NysAiZrt37Nmy3FAVPAKHLxdk8dHzLx0XgLt4QOBDNKxEvdOWRXu7D9JXWYS8c/H50TQEO/8eELB9jDDLIYU0nKibnm6cfbCK3fAfrthM5rL6gsObVGb3zoyt8yw0TTSBBgdD4x04xjWBsQmbAHcq47Xk3sFudSD7hvdrIoi0rCoYyXF3dLZWTdKvauVmpKPr98DGbhEnL1VsjFw+pB4GNVsmzmHHjn64utR2YcaGxQPXvUOQSiYI6AJFmANjnYJf6BxqzOpGTE5RuMBeC0BW248Rl+ApPhQRdykDIbc5a7YXP8ELlWHnQ6dGzrK+4SxYiBZM+X9aikuNH9Rh9tyGLSaKGc0JfHo5Q2ZUFOc5vPVyknE8SgB+7TT56DdqFMAnWDhBRO+khbItaaNZ8sCpV0hWkVNAYgmDOdf7Fo6YFCcRfuFhbWc7gnzpp8/fRSeUpOdYulMTY+hcpRtWiSuduPaS4dkFG25gLU5kriqyizj+1ttqmVw3wHRXqnhc9iRaMU3SDZiy3CM+9vkvnj2NHASz77ABukLOXkw2oww5/aYDY/Lr6iIkUBhq6mAe+k9wYdDdwqH9KtKNZQ37a8O0S
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199021)(7696005)(66446008)(8676002)(66476007)(4326008)(54906003)(478600001)(71200400001)(66556008)(64756008)(66946007)(41300700001)(316002)(110136005)(76116006)(86362001)(33656002)(83380400001)(26005)(9686003)(6506007)(2906002)(7416002)(52536014)(8936002)(5660300002)(82960400001)(55016003)(38100700002)(38070700005)(122000001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eExacEVlQktWRlRYY01NbE52RDlNRTk1VG5QYXBJeEh0d2x6cmt1SzcwZ2l2?=
 =?utf-8?B?VGw3WFVZVUx4SjRrVGRFYmVXSFUwRzhwVHFwVmZRYmJDaE5GZy9pRlhPVm5z?=
 =?utf-8?B?UXdNMTlsaFJYcUtkeS9ZODFRSlRUVU5DeU5JcEVTMGV1TFZsTDZFU2NDWmpU?=
 =?utf-8?B?dHlnbHFURWgxTVhqUzI3QW4zL1gvN3VEaUJWa2RHNnZlYTByYy9lQkxEeUtV?=
 =?utf-8?B?RFFtUWs1SThFd0xrajBhT0RxUXRIMVp1VEhER284aitwQVA1Tll2SXZCYWtO?=
 =?utf-8?B?dEkvY3BiMmhpTjB6c3VWbjgzalllVmc4SG9Ed0lZTjRxNWdKVmZodTh4MXoy?=
 =?utf-8?B?NUoxZmYzSEZKMWhxV05xMEIvdlJWbm1qb21PZCszTWhieldjeGhhZk13UnFn?=
 =?utf-8?B?M3FBeW8wWXJDSjg3d09MYzJWM3VtVTdKTXdBWkhmV0VHVDJnV0lTRFFRTDZl?=
 =?utf-8?B?WG5pc3FlUVJYV2orYTk5Q2pQQXB1elE3L0xQY25YeUkvQm1aV1VXTGlYTDMx?=
 =?utf-8?B?cE5zQXNDY08yWlNTWmdnWDBmMWVsVlpHbVRGL2lZcU0rRUQ0U0FZWWEweUo1?=
 =?utf-8?B?U1JjTzFsQkpyaS9xMzR4c1loMTA3OEt6WmpJNElla3pmVk9TdDRLeEszUHJY?=
 =?utf-8?B?RWlwMGF3UExZN09BQ2xSS0lFQmkrWVRjcityVUJkZGxiMzhNMW0zN1dFUDdC?=
 =?utf-8?B?VHNZbEVRMGxSbTEzVXhzWFJ1bzk3Qy9TT3RLV2JObDU2UUFtUlluWE9jU3Rj?=
 =?utf-8?B?ZlpWOE45KzUrWGh5UHVIYkRBTFZjVW9zcXJzMmpFNUhId1QrYlFBZDZHcmow?=
 =?utf-8?B?WUxyVStLUHJmSFNsTDdsZExvNmpGR1dxbUNGeitucFl1N0RFbzJhOW5BbDdY?=
 =?utf-8?B?SHBPYjh3NWxUenBPdHFBa3R0eFBaaEo4RzlRY1l2ZnpLM2lQUGY5WnZyTC9v?=
 =?utf-8?B?RmFlaS9XQUNuV2JOVjNFRktlcEErUnVLNTIrbXZIbVpFUGdWMkhSOU1EQTd5?=
 =?utf-8?B?Zzl1WDk2S1I3SGkzb2dOYnM3UUdNODZ3RzJUdGN4SmJlZ1RVYS9vRGh6dGgv?=
 =?utf-8?B?dVdEeFVpRjlGU0NvU1UvYXRaOTZWa2IyZDFQakxqeFdtczc4Y1FhS0RzMCtq?=
 =?utf-8?B?bitqbFRuTjF3SkFOV1FUbklnU1hlaDRQaDdwN0pyRkV1MHU1bjF3ZzZISHdL?=
 =?utf-8?B?SWNnbS91ZjdjR3ZZRkpHUFhxUG9jdDZ6Mjg5MitlVGdlVDdWemgrY20vUzJT?=
 =?utf-8?B?OFdUQW4xb0poYjVOclZwdlBDUmpUcFlkMXdrS093cTZXcXNpdmFMWk5QTXVi?=
 =?utf-8?B?RE03a2tkbW9QUmV1N0FaM040RjlVZzFnZFVjZW9YRjhKakVaMmtYQnNlaWpZ?=
 =?utf-8?B?OFZGSUwwbTVyRGwxUmdmb3ZxMHY2ZDVGYnE5a1UwUFRxelpjemp6Z2RQdkx4?=
 =?utf-8?B?eW1QUk02cUVzR3c2MU5zSjhtMWpXbE10MDlqT1A4dGZtVDVTOVhJUW9IQnJY?=
 =?utf-8?B?NHl5THdseUZCeHJUYzdVcXUxS3hZL2dzY3JiRXRPSEhwZzVpL2VJL25iQXcy?=
 =?utf-8?B?czJZaVJhakc1bmdISm1PTDRqNFZuTlJDUXB0MnMxbG9wUEVxMWFqYW1nNnB5?=
 =?utf-8?B?QmNIa05RTDdXZk9sR29IVkNmLzQwVnFkTTZnc2VDMjRyMkc5UThHK2xncnlp?=
 =?utf-8?B?ZCszbHY4VEVDSUU0UjBEN29qQlpyajVkN21GOCtqS25JNk9OMDluS3RvRVZs?=
 =?utf-8?B?blBpTXBrcHljTjJneDRES0EyMlRwZEIzblFRZWNFbW54YVozZTN0bm83QVl2?=
 =?utf-8?B?K1F4UEJJQ0c0RVRWbEdMY2hzdUNzYVRURGh6WVJVVzRZMzRTL1c4aElkZnZ5?=
 =?utf-8?B?NlpHanZRK05jNjFHRmgycXR3Y1Y3eGRXU25kQnp6WVJ3NjV1OFp6VnNxTHcv?=
 =?utf-8?B?OEVLOVdyN0ZLbC8xdUZhUWJxWlFTMkdQdmVYVkpHd1JMempGZzI3SnEvQklP?=
 =?utf-8?B?TVpXU1BVcjY5Q1pZdUFqMUl1cTN1OHB6eW8rV3gzSEJyOGlDT1d6eGZuZngv?=
 =?utf-8?B?a3VwUU5XOGpLQUhJZkJNenF4bnZrUVVUemJsV2VsaXVQYWhMaWFoZm5GYUpx?=
 =?utf-8?Q?G4gA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6683354-80d2-419a-e7a6-08db39f7ca2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 19:14:21.4393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hUYL3bglBH9FJm/ZLLIQBbstzJl9vUjJNc+I+YGkENEdzYVX6+DyvMWTkus0/eqc6O8hdLUd5xJ6kY0gTSjDmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6006
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBJIGRvIHRoaW5rIGl0J3MgbWlzc2luZyBzb21lIERvY3VtZW50YXRpb24sIGFuZCB0aGUgY292
ZXIgbGV0dGVyIGlzIGJpdCBzcGFyc2UuICBJdA0KPiB3b3VsZCBiZSBuaWNlIHRvIHNlZSBzb21l
IGhpZ2gtbGV2ZWwgaW5mb3JtYXRpb24gYWJvdXQgdGhpbmdzIGxpa2UsIGZvciBpbnN0YW5jZSwN
Cj4gd2h5IHRoZXJlIG5lZWRzIHRvIGJlIEZSRUQgcmVmYWN0b3JpbmcgZm9yIE5NSS8jUEYvI0RC
LyNNQyBzcGVjaWZpY2FsbHksIGJ1dA0KPiBub3Qgb3RoZXIgZXhjZXB0aW9ucy4NCg0KV2UgZG8g
aGF2ZSBzb21lIGNvbW1lbnRzIGluIHRoZSBjb21taXQgbWVzc2FnZXMgb3IgYXJvdW5kIHRoZSBj
b2RlIGNoYW5nZXMuDQoNCkhvd2V2ZXIgYSBoaWdoIGxldmVsIGRvY3VtZW50IGluIHRoZSBEb2N1
bWVudGF0aW9uL3g4Ni8gZGlyZWN0b3J5IHByb2JhYmx5DQp3b3JrcyBiZXR0ZXIsICBJIGNhbiBk
byB0aGF0Lg0KDQo+IA0KPiBUaGVyZSBhbHNvIGFyZW4ndCBhbnkgbmV3IHNlbGZ0ZXN0cy4gIEkg
ZmFpbnRseSByZWNhbGwgc29tZSB0d2VhayB0byB0aGUgc2VsZnRlc3RzDQo+IHJlY2VudGx5IHRo
YXQgd2FzIEZSRUQtb3JpZW50ZWQsIGJ1dCBJJ2Qgc3RpbGwgZXhwZWN0IGFsbCB0aGUgc2VsZnRl
c3RzIHRoYXQgcG9rZSBhdA0KPiB0aGUgZW50cnkgY29kZSB0byBiZSBwZXJ0dXJiZWQgYnkgdGhp
cyBhIGJpdC4NCg0KQmVjYXVzZSBGUkVEIGNvZGUgbWFqb3JseSByZXBsYWNlcyB0aGUgSURUIGVu
dHJ5L2Rpc3BhdGNoL3JldHVybiBjb2RlLCBhbmQNCm1ha2VzIGZldyBjaGFuZ2VzIHRvIHRoZSBl
dmVudCBoYW5kbGVycywgb3VyIGZvY3VzIHdhcyBtb3JlIG9mIHRvIGNoZWNrIGlmDQphbGwgdGhl
IGV2ZW50IGhhbmRsZXJzIGFyZSBwcm9wZXJseSBjYWxsZWQgYW5kIHJldHVybmVkLCB3aGljaCBp
cyB2ZXJ5IHdlbGwNCmNvdmVyZWQgYnkgdGhlIGV4aXN0aW5nIElEVCBzZWxmdGVzdHMuDQoNCk9u
ZSBhcmVhIHdlIG5lZWQgdG8gYWRkIHNlbGZ0ZXN0cyB0byBpcyB0aGUgRlJFRCBldmVudCBkaXNw
YXRjaCBmcmFtZXdvcmssIHRvDQptYWtlIHN1cmUgd2UgY292ZXIgYWxsIHRoZSBwb3NzaWJsZSBk
aXNwYXRjaCBwYXRocy4NCg0KPiBCYXNpY2FsbHksIGlmIGFueW9uZSBlbHNlIGhhcyBiZWVuIHBy
b2NyYXN0aW5hdGluZyBvbiByZXZpZXdpbmcgdGhpcyBzZXQsIG5vdyBpcw0KPiBwcm9iYWJseSB0
aGUgdGltZSB0byBkaWcgaW4uICAoSSdsbCBpbmNsdWRlIG15c2VsZiBpbiB0aGF0IGNhdGVnb3J5
LCBidHcpDQoNCkkgcmVhbGx5IGFwcHJlY2lhdGUgaXQhDQoNClRoYW5rcyENCiAgWGluDQo=
