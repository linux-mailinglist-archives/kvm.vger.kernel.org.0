Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8B2751E05
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbjGMJ7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbjGMJ7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:59:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622762700;
        Thu, 13 Jul 2023 02:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689242325; x=1720778325;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XYyiPpJEGiih4hy0WOlDlXMNFfyvWZG6KfE9bAbQmwE=;
  b=lucEpvelKBHtgxhb5V7ZYQWFsYBJDqPKSLIq2M0gELMHuoqYZk6YCF6i
   j5LwuDPt+Zgp/lucJfpIhRXsMA24DiVNORmUXsXtmg6VKqLzvxMZ88bdF
   hZs8PZtmuCfHMSHeUrZM7wPK6HGgGDzGKizW/8AI36as1BfI2YUsC9Jbd
   AvW94CE237Itu5u7tk/JLGac6RYQoCVM8nzZh8llCTYFp5sWPKzhmXgk7
   jIjS6HFbdX3tzVZ1ZwySfyYXqmiFFRTZ8FySstNtmC7NszdthXdHBPTvO
   iWVg8Tc2mDQgz8Ov/qsdz7lX6owMg3a7BTAj/Zjull2KFMctx4EpSU8Yz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="395946177"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="395946177"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 02:58:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="866491577"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="866491577"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jul 2023 02:58:44 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 02:58:43 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 02:58:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 02:58:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 02:58:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kBWa8qiMyStxmRGyGc/4nAM9An5B7lhrH9bd6ENUJuUMHZFIJLzDFcBFxtEHAe4Az0+HayipPl1YT/STioPnT0Cph+z/WbhsNw6iYuLgjT7JQQR6GzWpien4maSyMUZUIo382rpfr75UB0LuusRMXzts3cysmE21QXrrJobdIzMi6X0HD/suOoLT1kfJxxY1XQwmKyCIpk4s6Cs8QxgkQLTfpm2HWrCBKGCvqJb/s8cCD0WZP76eHX4GJUEC0ELl/GMKN1HPmqhsDSf9UhyPQbBy6lusO7vGAzOBFna8Fczjh/Y10Io1k8LDVBloYZPSjcL2dxkbVodHw95PH04huQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYyiPpJEGiih4hy0WOlDlXMNFfyvWZG6KfE9bAbQmwE=;
 b=Hg+wpiqUA5i7bcfjZ56NQUJQ2kX7YlUjntIZmKWhCiziWNIiCsM9vDP+swUZUkelrgKwjGOuY/NSEnOs4t4dtgejPTkj0D0xJdMjIwUzw9NLQ0bIrtIr0FFpRvOT5rzvMFo04sUPYn1OK0WKeJIbeIHd56x38SjF4hdrkF0LUXARsgeB2lW4UWB3wUuwrBPJ1WaPJjvHNBuUREpiWolFXbZx1aZ+6EQYNLLG+oJrAVmFZS52K+AQvaZZpL2FNw6th3oG6yViSVI2ECs9w4TipREHYwwo1HxrVU4sS+fb4lXBpwxckFYz5lH1eR11d/Yz19T54wKEq9t5lgirgYwuWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5448.namprd11.prod.outlook.com (2603:10b6:208:319::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.26; Thu, 13 Jul
 2023 09:58:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 09:58:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 10/10] x86/virt/tdx: Allow SEAMCALL to handle #UD and #GP
Thread-Topic: [PATCH 10/10] x86/virt/tdx: Allow SEAMCALL to handle #UD and #GP
Thread-Index: AQHZtJ12e5s7yrxUSku+64LoAodv6a+3WPqAgAAe+QA=
Date:   Thu, 13 Jul 2023 09:58:40 +0000
Message-ID: <00ae5246b3b4e1f812ee061b7bfa21b5ab2ec0a3.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <d08c5e27dd7377564d69648f3eb7b56d3c95b84b.1689151537.git.kai.huang@intel.com>
         <20230713080745.GB3139243@hirez.programming.kicks-ass.net>
In-Reply-To: <20230713080745.GB3139243@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5448:EE_
x-ms-office365-filtering-correlation-id: df2f5c2a-603e-4f65-bf45-08db8387bc07
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6BoImwJSOv/SXWf/JkPBONrPn2ZAoKFoSDXK5RgDGXqUpJVUv39M7dQgvvAoOx/J/aqL9x1W2QKChFprSDm2POLUgo5ACqlb9//BH3USvpXOignm7aeQU5xrh02wnnsuoRWA1lLH62BoNoAIhhOsgk8Yf7qKmLxpPNm5RCxOizKMdjcD8znI2yd2cTzVz7bJbTNvwMOiRVSJj1seQqKaopo/8ZSbupUyz1ayBjv/ZUVxlCB7Qy/I/VMSbuD13PqnGlp6WX6ajgUzI+QvENCKK/AE3HjROP0XvR+Mkh/fFHt73NEx7E8TexJ8CwFZeApeELWwMjfcakJTlOmKq3e7P6ty905dz7RR/OF8gcle/R47xpb518D2627bigd8DTU70PvmWQxN9eP6Mrd9PGS2GwwbTj8XLYJQqS9tlQaxIgjIfW+Ufdibh3PZrpZqHyAo0M07PEm14STzLexZnFAC38AAhslxyhbOYtq5yHbLcRXHsxXjLAwrDdUcu9r8vIeLSC2dr1IFbjiuxz8eOhQABpzH13sexGA/o4MBQYZ4BEPyHgZtdXwp/NKLci7J38BqZ6WgCfuhT+1HtveAlLrACuhA1+4z50HpskKRU0m4Y5840ivZcop4J9TuStOeuDWv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199021)(6512007)(6486002)(71200400001)(83380400001)(186003)(2616005)(36756003)(122000001)(38100700002)(38070700005)(86362001)(82960400001)(26005)(6506007)(66476007)(66446008)(64756008)(7416002)(76116006)(66946007)(66556008)(6916009)(4326008)(91956017)(54906003)(41300700001)(5660300002)(316002)(8936002)(8676002)(2906002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUU2TmUwU1BWQ2VnM0t4TFF2aXJFak93ZHY4YW5nNnZON3Z5ZC9ldlQ2b1Zn?=
 =?utf-8?B?d1ZWYzMxd2JUcUJaNXpQaFBuV2xBTS9tSmg4ZWdwV2FEaXY4UEkxb2Y2d3Vo?=
 =?utf-8?B?UFBnY3FlcndPaXRQeXErRVBkYyt1RjYzT0pqenB1STlxRGtMWVNJZzdLN3VD?=
 =?utf-8?B?UFZiMWN0QzdLOStYYTJncndjUFFpNFVQamc5S2p1NW1xejNQMEtDeHFHeS9W?=
 =?utf-8?B?ZmVDZEk5YUE3c2RmdlZMbFVXS1FWdkljWHByTi9nT3VjekJyR1dmS2hVRUZY?=
 =?utf-8?B?RVV4Mm1XdElxVEo4VDhOU0NUWDA0eGoyYnVjS2wyUmtneWgvdmloZml6ZEZI?=
 =?utf-8?B?WDdnWkVoRFF1TVd1L0gxckxvT2NvcFRCOXdJd24yem1vMFlEQlMxdFRuV2ky?=
 =?utf-8?B?UHJVRnF1V2VwVUxWSE1vYTJQSWJuQkN5QkFCVEIwanR4dXR5Vit2c3d2L1dV?=
 =?utf-8?B?VXBXeFVsUU96TWJjV1pHSVJ6S3FzRUZrUC9YZ2R3UXg1dHZnMnU5M3BjUmp2?=
 =?utf-8?B?cm5YRUVNNkYwR3hpZTZaVnpZQ2E3QjNDY3ZLZ200RTcyL3N4YTE2RmcwOGk3?=
 =?utf-8?B?QkVPS2IwektleTNPU0ZRZENiRk9QWnA0MW5RVFMwZzdvcEs4dmNabG9Zd3Fl?=
 =?utf-8?B?NHZ1azFoY25NSkpteGNOdzZMd0NnVDdvZGZrWk5RTUtjSDFmTEphcnZsVW9F?=
 =?utf-8?B?ZVFxZ0xCakY3WmZMMisxSEZQU0RZNzlyNStRc2Y1TlNEaG5NK1lPWVp4VFg1?=
 =?utf-8?B?aUkyVW9naG5yZ3J6QjBrQnpTTnB1c3BicjBvUGdUMnpmQWlMZVRCTmp3dzRU?=
 =?utf-8?B?TEZCdHZXVWZTMXNRbUUyWmp5eTFOWG1mRWRWUWRjRGtva2ZVZjA5Ump6akpr?=
 =?utf-8?B?NUk2Z2MvU20rZHBadFFkVUNldU0rSkd1Z3dkUlFEeTVKeUVQa0xnQ2pLMGZk?=
 =?utf-8?B?RGthT1AxMWNDTkg3WkJSUHZaa0tzd3RvQ0dValo1bzF2T05NelNmL3Q3aUN5?=
 =?utf-8?B?SkxlOE50SzZHdTZ2SXlxR041NlVnWWIzdGZVSEVpMU00TytIRDJNT1B2T3BG?=
 =?utf-8?B?cXhsRUp6amJHMWkyMmIvelRyZGhXekd1UGNXT2RodEdKYXRvY1VGcTlmZTBD?=
 =?utf-8?B?M1dWdHRDQUphREhDWERzUXRCTW9YMWhvbml3cnZSNDJ0OUhwaFZIUW04VERV?=
 =?utf-8?B?Yk9RS09TdW16QWVzL0NNMFF4Um9MdnBvd24vRlBGaUV6Y28zcXNEQjVVVEwy?=
 =?utf-8?B?Y2YrMFBQbDRwcmFFL3gzTC9vallDT1pJak00Y29vUkJxUTRvclIyaW5oY0Za?=
 =?utf-8?B?ZjEvaDMvS1VzRjRaWXNMU0RGb0srRklTNUYzTmxWSjdROGttcGJ6aWJmbDIz?=
 =?utf-8?B?NWpWcG5Tb1VXNjI4ZnJGdUlWNHRyOTFKb29ZcFJGOUlYU0JIZ1hLaEdMRHgv?=
 =?utf-8?B?aXJLRXhsdmZGd0tSRUdaWTNiZ2VtVHhhZkFqc1RvVUVScE9SM1NvS3dHMHlH?=
 =?utf-8?B?QzBTQ3ExM3FtZDJ0cGJHRFBNekhhUUgySmJDbW0rQnBjMUtwSmMycDZhcFdn?=
 =?utf-8?B?K250M1Z3NmpzeFpybzBiUnppd1dHM05mUlc5aEFTTWtiWXJpSHpiMVhRRHFs?=
 =?utf-8?B?WTh4U3MwR0lmSWdQYVp0WElyNDBET0hycndNNEF3VVFYb3hlZmNpSlRvdVhX?=
 =?utf-8?B?UExvV1A5cWl1ZzlvL1RsblVhbWM5WG4wMWd0RHAxK0pseVlVT3VkWWtjYnha?=
 =?utf-8?B?c3Jybk9mS290RXBWaFlxU3VZR2VlUjE1Q3NiZzJRQ0ovaVkzNmZpV2JaVFR3?=
 =?utf-8?B?RTY1SXd5NEZnSEt4TEJ5K0FFYlp2SzV0eEhPSzFiTlFtTDUvcVBCaElJU1JT?=
 =?utf-8?B?REhrMnZHT20yL0hFcXBWak1ETUhJWjlsQXZDM25sbkZ2eXdTbVYzUVJxcmN6?=
 =?utf-8?B?TEl6OWRjcWFmVW9GTFcvYjFpQWNPYklKV0JhNXRScFZQWlVoRlZ4emlFdk1J?=
 =?utf-8?B?b1ZCSHB4ajVMaDFCdkE0LzdSVHJHRmZVNnlHSktCQUlaMDNrN3FaQ244UjdC?=
 =?utf-8?B?SmhXV0lZaXJTYjFZMlg5NkJOdm90bS9MK3JyY080bnMvVE9qQkFISFUzd0FB?=
 =?utf-8?B?ZnNZejdINCs4NnFOZzFza0N3YU0raXpMOTRjSm5KK01ocmNWb0ZFSDhsMkI0?=
 =?utf-8?B?ZkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABD10B79D383C14A809C480DF486F788@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df2f5c2a-603e-4f65-bf45-08db8387bc07
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 09:58:40.1226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9yrWXtaUEnO5aMsXvwKvkxQ0PKtmDcqTdCpKinxrKmiTcEEe267ZyzpAgiUKPGGskQ4KuksyoRziOEz3T7meag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5448
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA3LTEzIGF0IDEwOjA3ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBKdWwgMTIsIDIwMjMgYXQgMDg6NTU6MjRQTSArMTIwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiA+IEBAIC04NSw2ICs4Niw3IEBADQo+ID4gIAkuZW5kaWYJLyogXHNhdmVkICovDQo+
ID4gIA0KPiA+ICAJLmlmIFxob3N0DQo+ID4gKzE6DQo+ID4gIAlzZWFtY2FsbA0KPiA+ICAJLyoN
Cj4gPiAgCSAqIFNFQU1DQUxMIGluc3RydWN0aW9uIGlzIGVzc2VudGlhbGx5IGEgVk1FeGl0IGZy
b20gVk1YIHJvb3QNCj4gPiBAQCAtOTksNiArMTAxLDcgQEANCj4gPiAgCSAqLw0KPiA+ICAJbW92
ICRURFhfU0VBTUNBTExfVk1GQUlMSU5WQUxJRCwgJXJkaQ0KPiA+ICAJY21vdmMgJXJkaSwgJXJh
eA0KPiA+ICsyOg0KPiA+ICAJLmVsc2UNCj4gPiAgCXRkY2FsbA0KPiA+ICAJLmVuZGlmDQo+IA0K
PiBUaGlzIGlzIGp1c3Qgd3JvbmcsIGlmIHRoZSB0aGluZyB0cmFwcyB5b3Ugc2hvdWxkIG5vdCBk
byB0aGUgcmV0dXJuDQo+IHJlZ2lzdGVycy4gQW5kIGF0IHRoaXMgcG9pbnQgdGhlIG1vdi9jbW92
YyB0aGluZyBkb2Vzbid0IG1ha2UgbXVjaCBzZW5zZQ0KPiBlaXRoZXIuDQoNCk9LIHdpbGwgZG8u
ICBZZXMgImRvIHJldHVybiByZWdpc3RlcnMiIGlzbid0IG5lY2Vzc2FyeS4gIEkgdGhvdWdodCB0
byBrZWVwIGNvZGUNCnNpbXBsZSB3ZSBjYW4ganVzdCBkbyBpdC4gIFRoZSB0cmFwL1ZNRkFJTElO
VkFMSUQgY29kZSBwYXRoIGlzbid0IGluIHBlcmZvcm1hbmNlDQpwYXRoIGFueXdheS4NCg0KVGhp
cyBpcyBhIHByb2JsZW0gaW4gdGhlIGN1cnJlbnQgdXBzdHJlYW0gY29kZSB0b28uICBJJ2xsIGZp
eCBpdCBmaXJzdCBpbiBhDQpzZXBhcmF0ZSBwYXRjaC4NCg0KPiANCj4gPiBAQCAtMTg1LDQgKzE4
OCwyMSBAQA0KPiA+ICANCj4gPiAgCUZSQU1FX0VORA0KPiA+ICAJUkVUDQo+ID4gKw0KPiA+ICsJ
LmlmIFxob3N0DQo+ID4gKzM6DQo+ID4gKwkvKg0KPiA+ICsJICogU0VBTUNBTEwgY2F1c2VkICNH
UCBvciAjVUQuICBCeSByZWFjaGluZyBoZXJlICVlYXggY29udGFpbnMNCj4gPiArCSAqIHRoZSB0
cmFwIG51bWJlci4gIENvbnZlcnQgdGhlIHRyYXAgbnVtYmVyIHRvIHRoZSBURFggZXJyb3INCj4g
PiArCSAqIGNvZGUgYnkgc2V0dGluZyBURFhfU1dfRVJST1IgdG8gdGhlIGhpZ2ggMzItYml0cyBv
ZiAlcmF4Lg0KPiA+ICsJICoNCj4gPiArCSAqIE5vdGUgY2Fubm90IE9SIFREWF9TV19FUlJPUiBk
aXJlY3RseSB0byAlcmF4IGFzIE9SIGluc3RydWN0aW9uDQo+ID4gKwkgKiBvbmx5IGFjY2VwdHMg
MzItYml0IGltbWVkaWF0ZSBhdCBtb3N0Lg0KPiA+ICsJICovDQo+ID4gKwltb3ZxICRURFhfU1df
RVJST1IsICVyMTINCj4gPiArCW9ycSAgJXIxMiwgJXJheA0KPiA+ICsJam1wICAyYg0KPiA+ICsN
Cj4gPiArCV9BU01fRVhUQUJMRV9GQVVMVCgxYiwgM2IpDQo+ID4gKwkuZW5kaWYJLyogXGhvc3Qg
Ki8NCj4gPiAgLmVuZG0NCj4gDQo+IEFsc28sIHBsZWFzZSB1c2VkIG5hbWVkIGxhYmVscyB3aGVy
ZSBwb3NzaWJsZSBhbmQgKnBsZWFzZSoga2VlcCBhc20NCj4gZGlyZWN0aXZlcyB1bmluZGVudGVk
Lg0KDQpZZXMgd2lsbCBkby4NCg0KPiANCj4gDQo+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHhjYWxsLlMNCj4gKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeGNhbGwuUw0KPiBA
QCAtNTYsNyArNTYsNyBAQA0KPiAgCW1vdnEJVERYX01PRFVMRV9yMTAoJXJzaSksICVyMTANCj4g
IAltb3ZxCVREWF9NT0RVTEVfcjExKCVyc2kpLCAlcjExDQo+ICANCj4gLQkuaWYgXHNhdmVkDQo+
ICsuaWYgXHNhdmVkDQo+ICAJLyoNCj4gIAkgKiBNb3ZlIGFkZGl0aW9uYWwgaW5wdXQgcmVncyBm
cm9tIHRoZSBzdHJ1Y3R1cmUuICBGb3Igc2ltcGxpY2l0eQ0KPiAgCSAqIGFzc3VtZSB0aGF0IGFu
eXRoaW5nIG5lZWRzIHRoZSBjYWxsZWUtc2F2ZWQgcmVncyBhbHNvIHRyYW1wbGVzDQo+IEBAIC03
NSwxOCArNzUsMTggQEANCj4gIAltb3ZxCVREWF9NT0RVTEVfcjE1KCVyc2kpLCAlcjE1DQo+ICAJ
bW92cQlURFhfTU9EVUxFX3JieCglcnNpKSwgJXJieA0KPiAgDQo+IC0JLmlmIFxyZXQNCj4gKy5p
ZiBccmV0DQo+ICAJLyogU2F2ZSB0aGUgc3RydWN0dXJlIHBvaW50ZXIgYXMgJXJzaSBpcyBhYm91
dCB0byBiZSBjbG9iYmVyZWQgKi8NCj4gIAlwdXNocQklcnNpDQo+IC0JLmVuZGlmDQo+ICsuZW5k
aWYNCj4gIA0KPiAgCW1vdnEJVERYX01PRFVMRV9yZGkoJXJzaSksICVyZGkNCj4gIAkvKiAlcnNp
IG5lZWRzIHRvIGJlIGRvbmUgYXQgbGFzdCAqLw0KPiAgCW1vdnEJVERYX01PRFVMRV9yc2koJXJz
aSksICVyc2kNCj4gLQkuZW5kaWYJLyogXHNhdmVkICovDQo+ICsuZW5kaWYJLyogXHNhdmVkICov
DQo+ICANCj4gLQkuaWYgXGhvc3QNCj4gLTE6DQo+ICsuaWYgXGhvc3QNCj4gKy5Mc2VhbWNhbGw6
DQo+ICAJc2VhbWNhbGwNCj4gIAkvKg0KPiAgCSAqIFNFQU1DQUxMIGluc3RydWN0aW9uIGlzIGVz
c2VudGlhbGx5IGEgVk1FeGl0IGZyb20gVk1YIHJvb3QNCj4gQEAgLTk5LDE1ICs5OSwxMyBAQA0K
PiAgCSAqIFRoaXMgdmFsdWUgd2lsbCBuZXZlciBiZSB1c2VkIGFzIGFjdHVhbCBTRUFNQ0FMTCBl
cnJvciBjb2RlIGFzDQo+ICAJICogaXQgaXMgZnJvbSB0aGUgUmVzZXJ2ZWQgc3RhdHVzIGNvZGUg
Y2xhc3MuDQo+ICAJICovDQo+IC0JbW92ICRURFhfU0VBTUNBTExfVk1GQUlMSU5WQUxJRCwgJXJk
aQ0KPiAtCWNtb3ZjICVyZGksICVyYXgNCj4gLTI6DQo+IC0JLmVsc2UNCj4gKwlqYwkuTHNlYW1m
YWlsDQo+ICsuZWxzZQ0KPiAgCXRkY2FsbA0KPiAtCS5lbmRpZg0KPiArLmVuZGlmDQo+ICANCj4g
LQkuaWYgXHJldA0KPiAtCS5pZiBcc2F2ZWQNCj4gKy5pZiBccmV0DQo+ICsuaWYgXHNhdmVkDQo+
ICAJLyoNCj4gIAkgKiBSZXN0b3JlIHRoZSBzdHJ1Y3R1cmUgZnJvbSBzdGFjayB0byBzYXZlZCB0
aGUgb3V0cHV0IHJlZ2lzdGVycw0KPiAgCSAqDQo+IEBAIC0xMzYsNyArMTM0LDcgQEANCj4gIAlt
b3ZxICVyMTUsIFREWF9NT0RVTEVfcjE1KCVyc2kpDQo+ICAJbW92cSAlcmJ4LCBURFhfTU9EVUxF
X3JieCglcnNpKQ0KPiAgCW1vdnEgJXJkaSwgVERYX01PRFVMRV9yZGkoJXJzaSkNCj4gLQkuZW5k
aWYJLyogXHNhdmVkICovDQo+ICsuZW5kaWYJLyogXHNhdmVkICovDQo+ICANCj4gIAkvKiBDb3B5
IG91dHB1dCByZWdzIHRvIHRoZSBzdHJ1Y3R1cmUgKi8NCj4gIAltb3ZxICVyY3gsIFREWF9NT0RV
TEVfcmN4KCVyc2kpDQo+IEBAIC0xNDUsMTAgKzE0MywxMSBAQA0KPiAgCW1vdnEgJXI5LCAgVERY
X01PRFVMRV9yOSglcnNpKQ0KPiAgCW1vdnEgJXIxMCwgVERYX01PRFVMRV9yMTAoJXJzaSkNCj4g
IAltb3ZxICVyMTEsIFREWF9NT0RVTEVfcjExKCVyc2kpDQo+IC0JLmVuZGlmCS8qIFxyZXQgKi8N
Cj4gKy5lbmRpZgkvKiBccmV0ICovDQo+ICANCj4gLQkuaWYgXHNhdmVkDQo+IC0JLmlmIFxyZXQN
Cj4gKy5Mb3V0Og0KPiArLmlmIFxzYXZlZA0KPiArLmlmIFxyZXQNCj4gIAkvKg0KPiAgCSAqIENs
ZWFyIHJlZ2lzdGVycyBzaGFyZWQgYnkgZ3Vlc3QgZm9yIFZQLkVOVEVSIGFuZCBWUC5WTUNBTEwg
dG8NCj4gIAkgKiBwcmV2ZW50IHNwZWN1bGF0aXZlIHVzZSBvZiB2YWx1ZXMgZnJvbSBndWVzdC9W
TU0sIGluY2x1ZGluZw0KPiBAQCAtMTcwLDEzICsxNjksOCBAQA0KPiAgCXhvcnEgJXI5LCAgJXI5
DQo+ICAJeG9ycSAlcjEwLCAlcjEwDQo+ICAJeG9ycSAlcjExLCAlcjExDQo+IC0JeG9ycSAlcjEy
LCAlcjEyDQo+IC0JeG9ycSAlcjEzLCAlcjEzDQo+IC0JeG9ycSAlcjE0LCAlcjE0DQo+IC0JeG9y
cSAlcjE1LCAlcjE1DQo+IC0JeG9ycSAlcmJ4LCAlcmJ4DQo+ICAJeG9ycSAlcmRpLCAlcmRpDQo+
IC0JLmVuZGlmCS8qIFxyZXQgKi8NCj4gKy5lbmRpZgkvKiBccmV0ICovDQo+ICANCj4gIAkvKiBS
ZXN0b3JlIGNhbGxlZS1zYXZlZCBHUFJzIGFzIG1hbmRhdGVkIGJ5IHRoZSB4ODZfNjQgQUJJICov
DQo+ICAJcG9wcQklcjE1DQo+IEBAIC0xODQsMTMgKzE3OCwxNyBAQA0KPiAgCXBvcHEJJXIxMw0K
PiAgCXBvcHEJJXIxMg0KPiAgCXBvcHEJJXJieA0KPiAtCS5lbmRpZgkvKiBcc2F2ZWQgKi8NCj4g
Ky5lbmRpZgkvKiBcc2F2ZWQgKi8NCj4gIA0KPiAgCUZSQU1FX0VORA0KPiAgCVJFVA0KPiAgDQo+
IC0JLmlmIFxob3N0DQo+IC0zOg0KPiArLmlmIFxob3N0DQo+ICsuTHNlYW1mYWlsOg0KPiArCW1v
dgkkVERYX1NFQU1DQUxMX1ZNRkFJTElOVkFMSUQsICVyYXgNCj4gKwlqbXAJLkxvdXQNCj4gKw0K
PiArLkxzZWFtdHJhcDoNCj4gIAkvKg0KPiAgCSAqIFNFQU1DQUxMIGNhdXNlZCAjR1Agb3IgI1VE
LiAgQnkgcmVhY2hpbmcgaGVyZSAlZWF4IGNvbnRhaW5zDQo+ICAJICogdGhlIHRyYXAgbnVtYmVy
LiAgQ29udmVydCB0aGUgdHJhcCBudW1iZXIgdG8gdGhlIFREWCBlcnJvcg0KPiBAQCAtMjAxLDgg
KzE5OSw4IEBADQo+ICAJICovDQo+ICAJbW92cSAkVERYX1NXX0VSUk9SLCAlcjEyDQo+ICAJb3Jx
ICAlcjEyLCAlcmF4DQo+IC0Jam1wICAyYg0KPiArCWptcCAuTG91dA0KDQpUaGFua3MgZm9yIHRo
ZSBjb2RlLg0KDQpUaGVyZSBtaWdodCBiZSBzdGFjayBiYWxhbmNpbmcgaXNzdWUgaGVyZS4gIEkn
bGwgZG91YmxlIGNoZWNrIHdoZW4gdXBkYXRpbmcgdGhpcw0KcGF0Y2guDQoNClRoYW5rcyENCg0K
PiAgDQo+IC0JX0FTTV9FWFRBQkxFX0ZBVUxUKDFiLCAzYikNCj4gLQkuZW5kaWYJLyogXGhvc3Qg
Ki8NCj4gKwlfQVNNX0VYVEFCTEVfRkFVTFQoLkxzZWFtY2FsbCwgLkxzZWFtdHJhcCkNCj4gKy5l
bmRpZgkvKiBcaG9zdCAqLw0KPiAgLmVuZG0NCg0K
