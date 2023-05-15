Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C200702B65
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 13:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241155AbjEOLY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 07:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241273AbjEOLY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 07:24:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB86813A;
        Mon, 15 May 2023 04:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684149895; x=1715685895;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=awKSqmCq/eio3xsw1c2qSv7W4u3/D2cuHmzS9LAvCSw=;
  b=QCtzpjrtegTdHVcfArW7LX/15O3IpeRwkC/36O4C2Z0WIOpJUtQ8NJqK
   inpUb6dK7G5/wW6IZ9oGva9Z/KQuXLRSYPwHPdZExG8EM/jVZud4bc51r
   FrIToVpkslINixDi/+c0NwiSDXaKSG9MVHVe1IeoW3sJdAlQ0krwxpj2F
   PbsD4jZTQlJd89b1IjA0GuvEdrDVGETvmo0xUjBYR+7Uhr4KqHabYo9+6
   tQ6bCqJ7QjYU+eWDAY436BwziRfcE1C3sNWN+7GXS8bhHPWPyPZQGV7Be
   7d8p87l7KciXxNSP/aWPwv+53+DPUh2JAMyKamWoiFwBomOuHVuX+ZSDe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="350014157"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="350014157"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 04:24:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="678413611"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="678413611"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 15 May 2023 04:24:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 04:24:54 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 04:24:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 04:24:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 04:24:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHOSqIYqBOsDhszLe5srRMlnRCo11GEe84bezoBOqeYTpORI3yOwIl4/MC7QL9Gvp8hJs0BCK8nDE0xp/RIPn/rYGt8cNsoNhRrq2Pu95He746ew4eYmKb7mTL9INX6ejrNwHPOZ9Lp8WpENSn2BlNerzGnglQY/ObJFRaJOxeNf3XJB56QQPDpRQ5pbsyGbCYUvtfHiI4lmFYGBu+osaOvAOdjRwKtI06ux/YxR7ox2Ljko4iZ+JRWOnzWhm8hHnBVTR4w5TZLXwlG59gWwSFhCXdUIiFwJxnnTmCUoZbK26k3bv12QZK0oPnSY8Grs7b5vaf+TH+L5Bpkj3mj5rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awKSqmCq/eio3xsw1c2qSv7W4u3/D2cuHmzS9LAvCSw=;
 b=jiR9ms8aSauJBIotgLNCPpb0CPoUVSlclrfUHrw5AgxSQeIQKT9zKpkRqgUAkansLTfVemHbo0kOPig2xx46S1vWFNIW+kUCd0xsi1fpCYV9en864gjOqqgwVSooGdGLn43IXvbPXfwb1jJsh2XoJCgJ16rv04QAFLH1I+gsJ67vb9bo97jgU42idSIeRb6fEf5A5k5myHX/I80e8oj7v2xx6NlWuajtszLbi/4jjIIG72Sl2Gob0lgg7E0tHbcUVeiQ2iyPsUlqJna8K8LB7fxrf/kADxYh5ZIyiE4KBRTiVqmRzZZCsoTy3XUstUIxa7YPW99I0NLhO/vkkKymGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 PH7PR11MB8454.namprd11.prod.outlook.com (2603:10b6:510:30c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.30; Mon, 15 May 2023 11:24:51 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::f381:7ce8:7d26:503d]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::f381:7ce8:7d26:503d%4]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 11:24:51 +0000
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 05/28] drm/i915/gvt: Explicitly check that vGPU is
 attached before shadowing
Thread-Topic: [PATCH v3 05/28] drm/i915/gvt: Explicitly check that vGPU is
 attached before shadowing
Thread-Index: AQHZhTLzfkzLabBKA0W5kyu3rajiS69bNVMA
Date:   Mon, 15 May 2023 11:24:51 +0000
Message-ID: <66685365-86f9-9ddf-d63b-f87621b05b88@intel.com>
References: <20230513003600.818142-1-seanjc@google.com>
 <20230513003600.818142-6-seanjc@google.com>
In-Reply-To: <20230513003600.818142-6-seanjc@google.com>
Accept-Language: en-FI, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5549:EE_|PH7PR11MB8454:EE_
x-ms-office365-filtering-correlation-id: be33a23f-3a08-4258-0fd9-08db5536fffc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sk/Saf/sa5+E4MqYOGaa47NExrIwIESRDlv0T7V0IEwa480NZejxY5RKcrwBiwKvC+Ow3tIB0VJxJlPflOiTNIpVGjfuKrDtdzdsFFDLwI9IkOrwF+dsZMqDVtWLFGh7esgYcJsftHdT1KCmdTs1Vjai4uWt+qrzFFU7bpaTMrfaElfO8/tePgCl4EDcyUa+guqGl4qxpMj4MaqSsBdy6N+YotqxqdFPrlwUBwSWc8p/GGwD7Dgnsx8tgb2Q/AIGQ13OlLNbX7DrQGaxHeAIBH12wAy98KtvA4c9Pa6jzXe6aytXKtsbMPmmVdqq4lzAreW6QVvKreBBMgL8XZCWfsW0ckjiSXjpsRG6NtGDXuYy3q/GTG/R20pCa/FEMcODuajy8jYKKKyTn3Xsf9W/JUPu4R/uUFX3w22xN1DX0V5BcnPl5XXgQpd7x0TqaAwOZjvmrmbw4AtWQ26afSyCtqxSX73WlJ+tWz/pISh7euTmj9PHAok7arBKNjLCjzFRsA65BuwFoKWm610JI3OeR0Lzo4zRADbpWFNeL3PTt8JwnC4Cdj5g2OStwwgNA8OpHm/g6eJ5il/m5pW32rKsvLw12LZv93hMitXqbHcFvVR6iPlXIOEdqZBgSLhDE+yVk1sr3lAlqdfV8WuudXYEQzXNRtwdtfh5Uxr65TxlGErXKR+ReDFMYmflCLkNhHX0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199021)(36756003)(91956017)(86362001)(54906003)(110136005)(316002)(66556008)(66446008)(64756008)(66946007)(66476007)(4326008)(478600001)(6486002)(76116006)(5660300002)(8676002)(8936002)(2906002)(38070700005)(38100700002)(31696002)(82960400001)(122000001)(41300700001)(6512007)(2616005)(186003)(53546011)(26005)(6506007)(83380400001)(71200400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWlXSmhjUnkzQWt6QXFubnp6T2ExQ2RkUXM2UnN1QVFQbldyeHl1MHpiRXNp?=
 =?utf-8?B?d0ROZGZPS1lkK24xcHFmU3JualdkNlNlNmJtYlI2UUxoV2V3WWxDNmhBQTdG?=
 =?utf-8?B?Sm5pK3A5eXJ3TDY0S1BpYW0rYVV1cEV0OUo3eXdRMVcwWk1ubmpjbmk1MlVG?=
 =?utf-8?B?SG1URnpuZ1JlSktMelpWdk9GN3hUWEMrWUtJc25LUmFHT0JTaDJGaDZJYnpj?=
 =?utf-8?B?N2xoc2NteGdTSlFZVXBZaTRXSzRhWjYxbDRNRVI5RlBMTU5hbnFVUjlyaStq?=
 =?utf-8?B?SGpYUDk3TkkyQVlDY3ZkS3JEN09Ua1NNcEhrSWtVNnVTTTQzaW5tOXFxTndV?=
 =?utf-8?B?b2hLOGJjMDdtRjZZSGpTc1ZTY0hoUUM3QnJ6MnJmbHpXYVRiUGl4T0NUbWRU?=
 =?utf-8?B?eGxrdjA4SlRqM0hhK2o5eVE2d05WcmNiU0dpZGxXOU1HeWFIYzNybHdXY1Yw?=
 =?utf-8?B?RitEZElHUWwvb0pMOUpWbUdlRTB0Zkk4OFYyNmVWaVZhS002cFhtRzNVNzhi?=
 =?utf-8?B?SEVoamNmei9kZm9jbDJ0Y1M1SWhXODBuLzhBWExYSkswMWlxTWdPa0dSWkJs?=
 =?utf-8?B?RDdjaXFFRXR3RXBhYjFYazgwcUhoa0NOdXFmaXMwb2ljbi8xQWJZd2hPSThw?=
 =?utf-8?B?L1RrZUxRYUNZTVdyQ2xFa2hIVUVFOUVVYkVheGJxWE1Xa2VXM2xmRk14ek5k?=
 =?utf-8?B?ek95QkIxR3ZETHAvajJDbjlYVEhOUHE2U3BiTnRLWEpWNkFrSXcvUmdWYnd5?=
 =?utf-8?B?R09zZGNXL0pUdCtzWS85STI5UTc4NjBDeFpYZVRZVXNTVHo2STNuZ1ViMnZ1?=
 =?utf-8?B?dzZPWmNuWFNrSHkyT3plLzF0eVhuekpwUFZtUlY4Z2dPd0xNODdUVFpqWWxk?=
 =?utf-8?B?TjJOT0JFcFlMbm5vekJBL0NqRXFUV0ZJWkNXY2dGSlh4aVE4d3FodzdhTW5j?=
 =?utf-8?B?TGZmWExWdURiZ0VwQ0xoZGtjbjgwcU40dHAxbFg1d215WWtyQllTaFMxM05H?=
 =?utf-8?B?Wmx1ZUNEYkwySTllcWJCYzdTelBrTWp4L1d4OUlRK0s0aGZacGkzNnRrck5I?=
 =?utf-8?B?VmVnR2N4N2lQZHdXNzYvdzZZZk5hS0s5T01CK1cxRGE0b3RFWlRpYmxaQktT?=
 =?utf-8?B?UzAyTnFpd2FQQklaUHZnSHpJdHh4NkFHOUVYaEV2UzM5c2U4anplZWl3eW5a?=
 =?utf-8?B?V2hnQTdBb0lIb0c1bVhmWTQxR2JuRHR5RDJVSFJqN09Tck9wRFBkS0FVTy84?=
 =?utf-8?B?UUZlT0dFbnN4Y3JuckN3bnZCOGs0SFkzNUZwS3hJVFhrN2gvcFUxekFKUVMy?=
 =?utf-8?B?ZEFVQWhHdFFqc0tRdzZRWnZEazFONjdFUzNSWlRCVWd0UWdkbHE1RjREME1w?=
 =?utf-8?B?ZDdIUVdoOXpjMmRFNTl6dVMwUFc5QWdFSFcxOG5KZW8zSkFETEJHbFhZSkJS?=
 =?utf-8?B?NkhpSnBDMkhpTUFhcWhEZmFuT3l6WCtQZzdlbjNhNEtNQVE2VHlJcnZDMEN1?=
 =?utf-8?B?L1VJVzIrcmxEUXI1TDJMcE9mUGk5N3EvYkNib0w3ZTY2QWNITU04WEU1dkhW?=
 =?utf-8?B?Sk5BcDhSQkhCNEpwT2p2Y3lJWSsvTmUydENyYnVCQVpMOHBmMXhvcHY2c3l5?=
 =?utf-8?B?MVJRVzVYOHdxYUJMbElvK21kRmttQkFXWEpNMExFT2Jsblh3U3pjT3o4ZWZQ?=
 =?utf-8?B?cE0vdEJJUTdRbEZnbDJPVjIxc1I4dTFKeTBTMVZKZ3FNODVUMFUxRXNGanJW?=
 =?utf-8?B?NzFRMlh0L3loVVpxZWZyODQzVXJPaEIwUG9wcFNENU41TUxlb3kySGRkMnlJ?=
 =?utf-8?B?L3daVkZqT09FN2JVVnhmelFSU21Rd3VtSUdUSG51dFp5aCtOYTVDZE45L3VM?=
 =?utf-8?B?N0tVdkhxdHJ1SHh3ckR3ZU9OWEtzUnRQdVA2eHBFb0RUbzMvalQ3ckttQ0pz?=
 =?utf-8?B?cWNkWGtpd2NZZ091U1FXM2pvMWJrTnVmK1FieTEwVGp4QXB5RmdtOE9sdGZ4?=
 =?utf-8?B?SFc4eTlUTXhTSHovSUgzbVJ6NU9tSFFPS2lOakRqM09IQXRmTjJWTjMxeC93?=
 =?utf-8?B?ZW1qV0dqclBoN2JCdFd0cTRWLzNhQnlTZjVmNXNsUm1DZExVbjFMdTlsL1pu?=
 =?utf-8?Q?W3nLesnJSU/Hyk2cPRSkaqZcp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBEEB13E37E95849A109AE7AFBCEA2E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be33a23f-3a08-4258-0fd9-08db5536fffc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 11:24:51.3956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AxAn2bR2lbwtUCFNQzNmjMOY+2DI9nEQNdKE8prSGZFr4yrRpJHd5QPJpVdbp5Rw579il1fhJDxt3JQBmLWyXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8454
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNS8xMy8yMDIzIDg6MzUgQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IE1vdmUg
dGhlIGNoZWNrIHRoYXQgYSB2R1BVIGlzIGF0dGFja2VkIGZyb20gaXNfMk1CX2d0dF9wb3NzaWJs
ZSgpIHRvIGl0cw0KPiBzb2xlIGNhbGxlciwgcHBndHRfcG9wdWxhdGVfc2hhZG93X2VudHJ5KCku
ICBBbGwgb2YgdGhlIHBhdGhzIGluDQo+IHBwZ3R0X3BvcHVsYXRlX3NoYWRvd19lbnRyeSgpIGV2
ZW50dWFsbHkgY2hlY2sgZm9yIGF0dGFjaG1lbnQgYnkgd2F5IG9mDQo+IGludGVsX2d2dF9kbWFf
bWFwX2d1ZXN0X3BhZ2UoKSwgYnV0IGV4cGxpY2l0bHkgY2hlY2tpbmcgY2FuIGF2b2lkDQo+IHVu
bmVjZXNzYXJ5IHdvcmsgYW5kIHdpbGwgbWFrZSBpdCBtb3JlIG9idmlvdXMgdGhhdCBhIGZ1dHVy
ZSBjbGVhbnVwIG9mDQo+IGlzXzJNQl9ndHRfcG9zc2libGUoKSBpc24ndCBpbnRyb2R1Y2luZyBh
IGJ1Zy4NCj4gDQoNCkl0IG1pZ2h0IGJlIGJldHRlciBtb3ZlIHRoaXMgY2hlY2sgdG8gc2hhZG93
X3BwZ3R0X21tKCkgd2hpY2ggaXMgdXNlZA0KaW4gYm90aCBzaGFkb3cgcGFnZSB0YWJsZSBjcmVh
dGlvbiBhbmQgcGlubmluZyBwYXRoIHNvIHRoYXQgdGhlIHBhdGgNCmNhbiBiYWlsIG91dCBldmVu
IGVhcmxpZXIgd2hlbiBjcmVhdGluZyBhIHNoYWRvdyBwYWdlIHRhYmxlIGJ1dCBhIHZHUFUNCmhh
cyBub3QgYmVlbiBhdHRhY2hlZCB0byBLVk0geWV0Lg0KDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4g
Q2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gICBkcml2ZXJzL2dw
dS9kcm0vaTkxNS9ndnQvZ3R0LmMgfCA1ICsrKy0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9ndnQvZ3R0LmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9ndnQvZ3R0LmMNCj4g
aW5kZXggNTQyNmEyN2MxYjcxLi4yYWVkMzFiNDk3YzkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
Z3B1L2RybS9pOTE1L2d2dC9ndHQuYw0KPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9ndnQv
Z3R0LmMNCj4gQEAgLTExNjMsOCArMTE2Myw2IEBAIHN0YXRpYyBpbnQgaXNfMk1CX2d0dF9wb3Nz
aWJsZShzdHJ1Y3QgaW50ZWxfdmdwdSAqdmdwdSwNCj4gICAJaWYgKCFIQVNfUEFHRV9TSVpFUyh2
Z3B1LT5ndnQtPmd0LT5pOTE1LCBJOTE1X0dUVF9QQUdFX1NJWkVfMk0pKQ0KPiAgIAkJcmV0dXJu
IDA7DQo+ICAgDQo+IC0JaWYgKCF0ZXN0X2JpdChJTlRFTF9WR1BVX1NUQVRVU19BVFRBQ0hFRCwg
dmdwdS0+c3RhdHVzKSkNCj4gLQkJcmV0dXJuIC1FSU5WQUw7DQo+ICAgCXBmbiA9IGdmbl90b19w
Zm4odmdwdS0+dmZpb19kZXZpY2Uua3ZtLCBvcHMtPmdldF9wZm4oZW50cnkpKTsNCj4gICAJaWYg
KGlzX2Vycm9yX25vc2xvdF9wZm4ocGZuKSkNCj4gICAJCXJldHVybiAtRUlOVkFMOw0KPiBAQCAt
MTI3Nyw2ICsxMjc1LDkgQEAgc3RhdGljIGludCBwcGd0dF9wb3B1bGF0ZV9zaGFkb3dfZW50cnko
c3RydWN0IGludGVsX3ZncHUgKnZncHUsDQo+ICAgCWlmICghcHRlX29wcy0+dGVzdF9wcmVzZW50
KGdlKSkNCj4gICAJCXJldHVybiAwOw0KPiAgIA0KPiArCWlmICghdGVzdF9iaXQoSU5URUxfVkdQ
VV9TVEFUVVNfQVRUQUNIRUQsIHZncHUtPnN0YXR1cykpDQo+ICsJCXJldHVybiAtRUlOVkFMOw0K
PiArDQo+ICAgCWdmbiA9IHB0ZV9vcHMtPmdldF9wZm4oZ2UpOw0KPiAgIA0KPiAgIAlzd2l0Y2gg
KGdlLT50eXBlKSB7DQoNCg==
