Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8772B5A1020
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 14:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbiHYMQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 08:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiHYMQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 08:16:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0043FAB040;
        Thu, 25 Aug 2022 05:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661429769; x=1692965769;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QNnpKlPQDgVx6rYpeEXFcnRwsMxb9SvjFlaPXYNZK/I=;
  b=H911Zg4WbyXYlPWV9WZw+iy6znsAzhm49sywvdnm6+Z13I4tQSyYHE1Z
   6s+WT+/iZ+GrdXgYRVbCSi1GT2B4XG67HrIo76quEpXbUiK6mdUXmF7XL
   F5B1AwGD7Y1Wq0FGyDbWYiJ0ZD2SqWXOoDDkhxpiPI/op4geRFXuYtoVU
   qo3xz5HjijGoJb9eJAzZA7aKvKNiz16RIXZxKpN+BQBfrXVQYf/h++27U
   tQHEAYVCMSVz1jkU2nKJy5H3dS8hGT65QQyBOJ2Dw7l6Lz5rH0aIwj+E2
   75zLWuVdgRfDMgJqDjDrGlharwGELeOnO60bGeB8KwwfBqoHbsZCzh4cD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="274611853"
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="274611853"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 05:16:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="855617637"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 25 Aug 2022 05:16:09 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 05:16:09 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 05:16:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 05:16:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 05:16:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cAwI7f+Zi5oDzm/o0LSMwLBzG5hb4sV/KMalLuiM+W/8eaYw4o08jtqRc5whk1O1qU9ueVGPYH5H7QYxnMR3ht4HXHVOapa5zIJIdKd3gvNxtGwIEx/a26PTGO5CqvKOuY0vPdoxuREfDjlFSf+KVgxjd5CFZxfJmGwbHSRfBscdX07ONOBjRJFdYlRpUrRSUgKVCm6pux5D1k4kvID56Dk8zaN7/sIyrAMsyVVxsdGYwNvtu3MbSF5xfZe7pvHlsWiPBqQBVuozkd16act4/OpeZ3PeReJSUFSLP6Jlbds2I+t7kyZoDcree2IRzZIIaunqp9tixwg4XzkQUwU5Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNnpKlPQDgVx6rYpeEXFcnRwsMxb9SvjFlaPXYNZK/I=;
 b=bJfvjpTB6vDOYYQihS4MometMhgIvyKHe7fiLRGhwyD3gksBlFywKM+zHwX4KWv27V0yWeoGSoCv8nnC+XeBn95+XfeNB9GJ1mBn6qCN2NWgWMI9RdhOR5bs1L+h+S9UlTIaGfMrrEJM9+nZALy4UyJcJV903AO+tFMKNuJJB4yIvmxdnWgnxZ+5YGUrVGrGQxvuz2i9JNyjCRYhcfVsuF/tjRCDT9rAJQfAWTyrloST0bvEsPL6RvHmv0G5kIHhVR9EAO6EJ71368ZWZLSl8yOkNRov8AD2EgRXyYQ5mQiHyH/xZ/n0LyaI7x1rxPTvpH+ZHJ0sK+RVra2pDTY0yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB4824.namprd11.prod.outlook.com (2603:10b6:510:38::13)
 by SN7PR11MB6825.namprd11.prod.outlook.com (2603:10b6:806:2a0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 12:16:06 +0000
Received: from PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::adb4:9c0e:5140:9596]) by PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::adb4:9c0e:5140:9596%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 12:16:06 +0000
From:   "Mi, Dapeng1" <dapeng1.mi@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "rafael@kernel.org" <rafael@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>
Subject: RE: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Thread-Topic: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Thread-Index: AQHYt5jfiwON7Q5LUE+jIx7HUxEKwK2+LJ2AgAAfbQCAATFrMA==
Date:   Thu, 25 Aug 2022 12:16:06 +0000
Message-ID: <PH0PR11MB48248A1C76F7F3538FD2AC30CD729@PH0PR11MB4824.namprd11.prod.outlook.com>
References: <20220824091117.767363-1-dapeng1.mi@intel.com>
 <YwZDL4yv7F2Y4JBP@google.com>
 <f1598980-92a8-267c-cade-8f62d7653017@redhat.com>
In-Reply-To: <f1598980-92a8-267c-cade-8f62d7653017@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb5cee80-2d0d-47ab-0952-08da8693961a
x-ms-traffictypediagnostic: SN7PR11MB6825:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 861qkyN5nXA7HXI5uhewLPBPd8iGGjtR13h82nCIHMyfS7poHqBp5bPJFjjINBEWYRZndieDj3stqNm2GL6YamC1V8Gd7iOOrDz/k06Eo7IUWv0wP72TcqoMI0n/z2RnE9GkZjM2w0q7eeMHlJFrfjuEfHd0Z9FcKsbqkRfz0sH5lUojiNUqejGBsmcxHlZn0cRB9pcEwsmif8d/8j6eezL3HhPYRAAvIOvbt72E3T8cLVVW2a/tpwQ63J+YMPZAwrify6rCi3E/SOnj+DMWggHgUFOt1ZEoL8gAtz42OsoDbCLAqo1o8GFVUWCmQPk61at7Jl4+zQk8AwlNfEIjjKYC3RaFWUESsKjUedv056AMhF/2PMhwsznAJ8LGBgJ/qU3/94i1zhL4RAxnGL+F02h+2vC6s0EvUzU2wLJ4d/hD00OnfnPh7rnAJPZEUO6GoyP0BvXj/noaYQ4ZyDx0miSexZLNkDVF0DkD+9wnBF9beVuFfD+HwrBQEwE2v3QtWjBlHgCozLLCIvFRnkpDbnOSQkObFrlruEnI3NSIO2mqeFq2mis6EaJQGoEOMDZB7wtSYtZSxKTBzRCeTmj1/jiD3alCca7hmPL/gYagw5ws9Y2f4qR09guYRNfDUdb3nWfwfnh7iJfmAkRwqCwKw2WPv0C5CfU1OKgxiX6i3mDjZjGKSMJoWLCSZmznAU0vdILDcbIWYPdPMe2nlULzFSH9uFHMzFk+7dxK9GLroNDt29kC6JUK99jivyG0dKUcmbYKuglISNokDJQMzo9fsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39860400002)(366004)(376002)(2906002)(82960400001)(186003)(55016003)(8676002)(66556008)(66476007)(316002)(4326008)(33656002)(52536014)(66946007)(64756008)(8936002)(5660300002)(66446008)(76116006)(6506007)(110136005)(54906003)(38070700005)(41300700001)(86362001)(9686003)(7696005)(26005)(53546011)(122000001)(38100700002)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWtBOU1QYjc4QTBnMklsSnlKNDRNMGVLMkVQV2ZzR3RHT0NsWFpJZi9NOXoz?=
 =?utf-8?B?TWNacW42ODV3dDFjKzhNZ0hRN3dwQUxlUVlZTnRvSVhPcGdTUjhsNzc5Wktm?=
 =?utf-8?B?WUhJS2VCakkyb1RHeUtyeElNN2N3QllmUmVaVkhnNzdKSHMzMlNmMXdQbVJ3?=
 =?utf-8?B?Sit4cmlSU1Q5bjl5TlovbytFRkphRTFnZXIvdTNvSmQwOHhUa3BHYlVqVGN4?=
 =?utf-8?B?eW1tZGMraFkvMU1ia1hJR3NUMTYwTjFSMmduREZwNFM3N2NSQkorY1YvSkVr?=
 =?utf-8?B?OGJobEJ2QUVUaUlWYnV3NDlMOGNOTmJLNjFhZ3pWQ0FkcE5mSTlPdWpUS0NE?=
 =?utf-8?B?WmtJYmhFNjdvOWxaU3pqR2JLZmxOMnh3Y1pHdXU4OVhzM0NKbVM5Z3RGN3Bx?=
 =?utf-8?B?R21LdVFvN1h4RW5VcDZBdkx1ajdUNlc2RmVpdDB5MDRZZFZYSkFBa0lPYmEx?=
 =?utf-8?B?UzlnMU5aWlBOZXBPMFFqRmRjUW1SWUQzdGtaelM3UEw5cmpEaFNaejhpUEZL?=
 =?utf-8?B?eHd3WmFBS2gzWFVsVkR3czg1OGFGRVg5UllOdFg3YTU2OGFPQ1krUkpxTmNm?=
 =?utf-8?B?VGJITlArZklMbzVieUR0c2xjN2p6VUhMRXBZRkJPUVpRRWtYRk5odXIvR0Vp?=
 =?utf-8?B?SldzUW1vdDZNQ1J5cVhaR1FILzBPQW9aeTdwVWJsc1hlallBSzk0dnMydys2?=
 =?utf-8?B?QlYxL3h0MHlBNlZMV0Z2ME42U0pDYXN0Wkg1Z1E0eXZKSVdkUFZDS3B5SjEx?=
 =?utf-8?B?ZU41SEQ1ZCthZmpCQlFMVXdwdmhzVkozRk92NGFoeURIZmdWd0h6SGhVNUFW?=
 =?utf-8?B?TVlOQ0QxeTZibzZGcnR4UFJKNVlUZU90eXV1SDhicG5FanF5VlBHSjZZUlNW?=
 =?utf-8?B?YURBWitZV0NrN2d2eTdJalNPTFJ1OHE4cHRvZUVxLzlCaHBFTnkwenRlaGYy?=
 =?utf-8?B?RU5OUVlJaVpVVGpGTGhpdmo1c21EUkNMVnhCOEJVb0tSSkpPYnhJSkc1K3B6?=
 =?utf-8?B?ZktWRW9YWkx1cVkvVnN3b0NEakkwM3ZTdXV0amFSV3RTak83aTlMTmMvN1h5?=
 =?utf-8?B?ZFVDR0RLTGtFbmFrckQvRHh5akM2STJlQUI3a1pQbUNLQTNpbC80UitvQTJh?=
 =?utf-8?B?UHRGaGZyYm9kaER5OW5aV1NUMEIvd3BQQ0pFWHNNZ2c4ZVdSaytoRFM0N1Fl?=
 =?utf-8?B?bFFnUjVReGRSSmowQ1Q3S0NLTEJlbjJHOEVpQ0NhNjAyMWg5a0RXc1VuSFZo?=
 =?utf-8?B?T1BNVzYvQ1dDMElIY08yVXUvTkM2TUdpYTk4d2ZVTDF2a3NyTExkNXVYSW0x?=
 =?utf-8?B?ZGJraFRJVXNYbUxVRG9yTWpUR3hQc2psbUVKVHNHRml4U0JsNmE4WFNXdUlI?=
 =?utf-8?B?aDZ2N1BQVFFiRTQxZHdNZ3NMSE5qcHpWd2dqVVB3VnlXNU9objd0dUtxVEc3?=
 =?utf-8?B?d2RIUlh6S3BnRkpzeFFJWWM1Wm9ydlkvcmxZa0xrS3lmaDVYVHhNcHFHbVlK?=
 =?utf-8?B?QkNsVitGeTZ1aXJqNjRiRzAxM3JrTXE0VUdXSWxiTm9jZXhCSW4xU1Z4TzY5?=
 =?utf-8?B?YUpRaVh3RTZ5R2ZmN3ZYbW5BZWF3ZCtXaTd3REJpdnIvNXV6UXN4TldIeVBw?=
 =?utf-8?B?dGd3WEdJcnlISS9WS1JTem5Bc2syWkNYWUFYQ3Q3MFA0dDRlM0RNS0VHWURk?=
 =?utf-8?B?eVBTbkN1Y0swTzNucmxSVG15YTBaSjAwOHNlRVhEek44T1hWdkZOM05vNWJH?=
 =?utf-8?B?UXRGV25WRnZXL0lpMGtpVjZTUWVreG1sd3NlWTBwVzZGaHY3YnpzbzNEbkRn?=
 =?utf-8?B?SEJTZmppRTFncFRQY28xTzRsYjdBcTRxSmtIZ2lwWEEwRkFpSm1Ma3NWbW5r?=
 =?utf-8?B?elhqd2FaR1VyNXZEVzJJblErOTJsaHJFV2dpMTBHTElqN0pMUUU2RjNQMC9P?=
 =?utf-8?B?SEFhc3VEL0dhdXI5WFBwSm96dzFhaEt0cW84L1ZQSkZka0dOZkxzM1NYSnRZ?=
 =?utf-8?B?V0hXNEJWMFZCZ2VScUpCM2pxQlNYblo2dWt5TVZ3RjcxZ0llZ3hxcVVFR0g1?=
 =?utf-8?B?WFlKRHFxVHg5TXgyd1hCTUhFRGFKU0ZBaDErQWt6MlFzUm41KzVDQ2ZNWll6?=
 =?utf-8?Q?69JfrDP0m4UkDzOoatZAQcYjv?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5cee80-2d0d-47ab-0952-08da8693961a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 12:16:06.2634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OxA5cZmxtcw4nn0EuoOop4I3OTXJ10zjwVoTdqGfqGYDCE1szDsbZSIggzxwsXCP/0ldRqmCF/Nj7YEcBMqSWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6825
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgQXVndXN0IDI1LCAyMDIyIDE6MTkgQU0NCj4gVG86IENocmlzdG9waGVyc29uLCwgU2Vh
biA8c2VhbmpjQGdvb2dsZS5jb20+OyBNaSwgRGFwZW5nMQ0KPiA8ZGFwZW5nMS5taUBpbnRlbC5j
b20+DQo+IENjOiByYWZhZWxAa2VybmVsLm9yZzsgZGFuaWVsLmxlemNhbm9AbGluYXJvLm9yZzsg
bGludXgtcG1Admdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
OyBrdm1Admdlci5rZXJuZWwub3JnOyB6aGVueXV3QGxpbnV4LmludGVsLmNvbQ0KPiBTdWJqZWN0
OiBSZTogW1BBVENIXSBLVk06IHg4NjogdXNlIFRQQVVTRSB0byByZXBsYWNlIFBBVVNFIGluIGhh
bHQgcG9sbGluZw0KPiANCj4gT24gOC8yNC8yMiAxNzoyNiwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3
cm90ZToNCj4gPiBJIHNheSAiaWYiLCBiZWNhdXNlIEkgdGhpbmsgdGhpcyBuZWVkcyB0byBjb21l
IHdpdGggcGVyZm9ybWFuY2UNCj4gPiBudW1iZXJzIHRvIHNob3cgdGhlIGltcGFjdCBvbiBndWVz
dCBsYXRlbmN5IHNvIHRoYXQgS1ZNIGFuZCBpdHMgdXNlcnMgY2FuDQo+IG1ha2UgYW4gaW5mb3Jt
ZWQgZGVjaXNpb24uDQo+ID4gQW5kIGlmIGl0J3MgdW5saWtlbHkgdGhhdCBhbnlvbmUgd2lsbCBl
dmVyIHdhbnQgdG8gZW5hYmxlIFRQQVVTRSBmb3INCj4gPiBoYWx0IHBvbGxpbmcsIHRoZW4gaXQn
cyBub3Qgd29ydGggdGhlIGV4dHJhIGNvbXBsZXhpdHkgaW4gS1ZNLg0KPiANCj4gWWVhaCwgaGFs
dCBwb2xsaW5nIHdvcmtzIGFyb3VuZCBwZXJoYXBzIHRoZSBiaWdnZXN0IHBlcmZvcm1hbmNlIGlz
c3VlIHdpdGggVk1zDQo+IGNvbXBhcmVkIHRvIGJhcmUgbWV0YWwgKHNvIG11Y2ggdGhhdCBpdCdz
IGV2ZW4gcG9zc2libGUgdG8gbW92ZSBoYWx0IHBvbGxpbmcNCj4gX2luc2lkZV8gdGhlIGd1ZXN0
IGZvciBleHRyYSBwZXJmb3JtYW5jZSkuDQo+IA0KPiBJIGFtIHJlYWR5IHRvIGJlIHByb3ZlbiB3
cm9uZyBidXQgSSBkb3VidCBUUEFVU0Ugd2lsbCBoYXZlIGEgc21hbGwgZWZmZWN0LCBhbmQNCj4g
aWYgb25lIHdhbnRzIHRoZSBtb3N0IHBvd2VyIHNhdmluZyB0aGV5IHNob3VsZCBkaXNhYmxlIGhh
bHQgcG9sbGluZy4gIFBlcmhhcHMNCj4gS1ZNIGNvdWxkIGRvIGl0IGF1dG9tYXRpY2FsbHkgaWYg
dGhlIHBvd2Vyc2F2aW5nIGdvdmVybm9yIGlzIGluIGVmZmVjdD8NCg0KUGFvbG8sIA0KDQpJbiBv
dXIgdGVzdHMsIHdlIHNlZSBoYWx0IHBvbGxpbmcgY29uc3VtZXMgdG9vIG11Y2ggQ1BVIHJlc291
cmNlcyBhbmQgcG93ZXIuIEZvciBleGFtcGxlLCBJbiB2aWRlbyBwbGF5YmFjayBjYXNlLA0KVGhl
IENQVSB1dGlsaXphdGlvbiBvZiBoYWx0IHBvbGxpbmcgaXMgMTclIGFuZCBicmluZ3MgNyUgZXh0
cmEgcG93ZXIgY29uc3VtcHRpb24gY29tcGFyaW5nIHdpdGggZGlzYWJsaW5nIGhhbHQgcG9sbGlu
Zy4NCg0KSGFsdCBwb2xsaW5nIHNlZW1zIHRvIGNvbnN1bWUgdG9vIG11Y2ggY3B1IHJlc291cmNl
IGFuZCBwb3dlciB0aGFuIGltYWdpbmUsIGVzcGVjaWFsbHkgZm9yIENsaWVudCBwbGF0Zm9ybSwg
aXQgbWFrZSB0aGluZ3Mgd29yc2UuDQpCYXNlIG9uIG91ciBvYnNlcnZhdGlvbiwgVFBBVVNFIGNv
dWxkIGltcHJvdmUgMSUgfiAyJSBwb3dlciBzYXZpbmcuIERpc2FibGluZyBoYWx0IHBvbGxpbmcg
aXMgYW5vdGhlciBhbHRlcm5hdGl2ZSBtZXRob2Qgd2UgYXJlIHRoaW5raW5nLg0KQmFzZSBvbiBv
dXIgdGVzdHMsIHdlIGRvbid0IHNlZSB0aGVyZSBhcmUgb2J2aW91cyBwZXJmb3JtYW5jZSBkb3du
Z3JhZGUgZXZlbiBmb3IgRklPIGFuZCBuZXRwZXJmIG9uIEludGVsIEFsZGVybGFrZSBwbGF0Zm9y
bS4gSXQgbG9va3MgDQp0aGUgY29udGV4dCBzd2l0Y2ggbGF0ZW5jeSBjb3VsZCBub3QgYmUgc28g
bGFyZ2Ugb24gdGhlIGxhdGVzdCBDUFUuIA0KDQpZZXMsIHlvdSBhcmUgcmlnaHQsIGl0IGNvdWxk
IGJlIGEgYmV0dGVyIG1ldGhvZCB0byBtYWtlIEtWTSBlbmFibGUvZGlzYWJsZSBoYWx0IHBvbGxp
bmcgYmFzZSBvbiB0aGUgQ1BVIHBlcmZvcm1hbmNlIGdvdmVybm9yLiANCg0KPiANCj4gUGFvbG8N
Cg0K
