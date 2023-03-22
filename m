Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37AA6C5975
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 23:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjCVWd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 18:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCVWdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 18:33:25 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF2D4C0D
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 15:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679524403; x=1711060403;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=61cYbeHBT5AvGSqDWXc0relNGYDytQoH55Xfvc13oq0=;
  b=G17ZEOKD9YDe7szBKrdt20mPYRZ1Yu17fzJXwDDAtzJLFU7dRHvMHnh7
   Q8fVzuqrsfN4wAIHxtGM4lHDGAPQ8ObGzepdtWLFAoANVvoziiykgTcmA
   et8cWT101Rl0VEkyJXa07vcsZLKnpR7XWDGrqwre1X1HwH95Io6jqgwPu
   lVwxnMjHJ7BVPdE5Tf8FmwUdlT0JtQliSh/LW27X2kJzPHGudWUhGI11R
   RJJpkTs7rs5zRcIfmxVsBdGYyEury0zsH+wCQNHAiI1jaqV+Fy8s6KnpY
   gL3QnBoqatNpf7hu+Y7QDOjp0kCWpFfr2KpMrH+1cbLFk/N9aVcAadpLV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="401914967"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="401914967"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 15:33:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="806026461"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="806026461"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 22 Mar 2023 15:33:23 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 15:33:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 15:33:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 15:33:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 15:33:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVgfs8npxHb8xwAZgMHXUIaUsvClKn9SmgxYYqdpfFujmbNzvDH4TmB88Fek6N5B79reIpzRCz5Bwq3BkJfU0NmhHQOeko1qMjouir8F21XPcdn+aRjeA8/rqwj+wLRwm5/+X3SpcUyTRvewfLb6eI6NFcz9Vl5FIIKBF8y+h1No/hoWZQoMbyarq8CYbF4awD3YdEpGYAgBSn7qjQzBILH89otvU/CrLrpJgqPSyh0d3wEUxEcI5qHmvoj4xO/gCOfqkJUMe6qSQVXgzPFSNNExL2+fNE39fVk//uPBMrSUiz1vuLmbWsXMcn0UJnlUMlWl1ZN065IJS20xDsCErA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61cYbeHBT5AvGSqDWXc0relNGYDytQoH55Xfvc13oq0=;
 b=XMczG8C/PWDIDAlHzUFQSLNaZNS5G6/NK8aUFQuscZsVbAUD6LiJFDqbIpN7Vg9ig23MuO2zpaICCbMh0rbO+HIpHKHUgzORE0tzfcYu9ZZP2xzriLexgVatC1prLEmhuRRpHYBtKgzRj90uSZHAaXueduJjNKhq+CaNkTz7NYe9UK2+7oExwd0+duNJ5AOhsKY2y/fR1fhwCjYgs/AsgKhNezEUDsFB+kNePgKQ5ZThiOeUMO3KwDcUVe3f22cRpIxFb2SHT/btEc6psZP0Y+0u5Wg/E7yrMeBZdxGmkD07fD0xQg7AWwpOlkEqhEDXFhBT53eGrZApZkoPGNUmqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4876.namprd11.prod.outlook.com (2603:10b6:806:119::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 22:33:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 22:33:20 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
Subject: Re: [PATCH 4/4] KVM: x86: Change return type of is_long_mode() to
 bool
Thread-Topic: [PATCH 4/4] KVM: x86: Change return type of is_long_mode() to
 bool
Thread-Index: AQHZXHsAcHyiCOV+90eRxZpWsFZMWq8HY6AA
Date:   Wed, 22 Mar 2023 22:33:20 +0000
Message-ID: <67693930aa5321766afa54fe468544288b535bc7.camel@intel.com>
References: <20230322045824.22970-1-binbin.wu@linux.intel.com>
         <20230322045824.22970-5-binbin.wu@linux.intel.com>
In-Reply-To: <20230322045824.22970-5-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB4876:EE_
x-ms-office365-filtering-correlation-id: 85bf8ca1-6420-4e65-30c4-08db2b257050
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 386k3nYJinADw+KtbE9W08hqbrJb2P3W/U4+pm8XpLclZLNF+33Z+U5kNlA4F5dV+vPeAW1Qxy071kn1x4ZPTQL3XvnQMFIJyvYxSRSfgTkOflX6EsFwdvR8umU1yo8hcM7eU+SUAMzp7Qop8YPPLrc1pAp7dtPLzoy1FB6L9cmydbn8p5BFxgtRUGl8t7GQcKv8/ZqWVOaugPArdHED04AG/mbM6zlJpGeSjqocqJF3pJOb7RE4niQk/Qe98EXot9kr8T1PCDLAzqETWeEnfBj1ZcTgy9xB25g4I8Khaw3nxK4M6KKDmT3XdvlIu4l+rK/v5rG0ArHJQyBDZiyeFAzSO5Bh0EPWq6LU2+6zBwGaaMWW47o5ANLs8kGXKG3g4iIQcZL68rtglbsOdDv5V2XTq6bm3gyBg8022JnnNDxODFZoG4MuIVM82dzHOn9kzY2JUTcSEOdKea5JHU2iFJU8Bp1VwSDpWNQ2dm+e74jtNUoExJAXq87jLmfccbCYp6c+6ADm/TLOlu8HOu6UwwdCV815v6OVmyi5a0gKk9KBoCGpe4gOS8r7bvF8XgoQSttvuXf46Yr4+QBJh6FLkrywTvBwp+74QK6zsMtdLTbcIqKHhsjih2y1lOZ9avbWiBzAF55LaT9m2uYMvX80002kHLsyX3osoAZaqiD0eHklqWNesA15oI80lEthXQ/hde8glvjY7GUSDJK8oMjzaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199018)(38100700002)(122000001)(6506007)(38070700005)(4326008)(66476007)(4744005)(82960400001)(66556008)(91956017)(6512007)(8936002)(5660300002)(64756008)(76116006)(36756003)(66446008)(86362001)(66946007)(2906002)(41300700001)(26005)(186003)(2616005)(110136005)(71200400001)(478600001)(316002)(6486002)(83380400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXQrSUJGdkZodER3OHJERUJUSWY2Y01XLzltbi9yVTQ3VGxUMFhQb1ZqQ20w?=
 =?utf-8?B?d0l4bkZGSnhDRjlTTzR1eWJnTGxTd3VDNk1JOVk3TUZzY0UwdWVDRHd5Y2Z5?=
 =?utf-8?B?c0tUVkN3clVVWE1DN2svQlJYTFMyeENkVmVCbUwzZzdyQmdOc1c2MjRZYmhF?=
 =?utf-8?B?R0VMMXdVSk9hQnlURXFhelJ2d2NHQTArdFowODJOYmVqZDJ4QXJET3RzaENl?=
 =?utf-8?B?MDRSQkx3Skw2MXc2Y292ZUtpQTF3S2dIODQyUXE4RlpZUHFZaVFScVF5SXY4?=
 =?utf-8?B?bC9rM2lwQU9RdjRHaUNWOWFLOC9CZ3ZEN1hpcmU2aWRCQ0hHRi9QV2tEeXdF?=
 =?utf-8?B?eDlJRTFYVFlHbkRCZ3VxL011d1hEblBZWU9MbE9jRnR5VTJHMXNiZmt6a3hh?=
 =?utf-8?B?VVVZcXBLSDlGNGZDVlJMUGdCaTY2MlBuS2ZpMHRoYXZuek53QmUyM2gzOFZ3?=
 =?utf-8?B?ejNrMU1TcVQzQm9wRG56ZkE3dzVnNmdyZE5YRTNXQ1dHaFMzU0trNjVWUnR6?=
 =?utf-8?B?UnZpQ2FZbER4THNvUk5aczM0TnpDZ0FhYWtNS2VCTU1FYnQvYzVoajFCcjEv?=
 =?utf-8?B?V21aaTNqT3pESHVmMEtYdnFwaXY2VEJ1dVVWT05RaG5zaGpwNmVRdHVRVyt2?=
 =?utf-8?B?NDIxZ3FQZDl6NUwxMCt5Ty9CT0RuWm0xaElFMHRyR2toVEEwVmkvMGZZN050?=
 =?utf-8?B?M3RubmRMekRQTkdnbGFsVUladjA3bEordmZsRmZaSDRBZTZyaTBFWVdBNE5H?=
 =?utf-8?B?TVNMRjcvTm4wS1lyZUFHeWRYamw5QTVCdlBZTmRENHNCY2E0MThTamkrMTIv?=
 =?utf-8?B?NEpRVnB5L204ZDEzZmx2N015bHVrcDNsSUhCQ1pwcG05VWlSSHJmd3RhRjdL?=
 =?utf-8?B?ZFpieWgvSHpKWktuVjRxUnVmb3IxMEFGZmxnTFd1NkRTMENwczltS1RCQlJ1?=
 =?utf-8?B?WERla2lmaWFNZURld1Uwam45NGEzU1Q1cEdsWTY0T3p0L2JSVlpPWitzWjM4?=
 =?utf-8?B?b2oyY1V4cUZYbW9QY0FuTUdRd3dlUDZ4eTdET2xJM2dlcXIweEY2SFliRU92?=
 =?utf-8?B?TmI3cEVwdFBBMDZwY0QxdVJTVXhrMHNueU5pN0duMDFWbEd1SmxBcU1DOW5R?=
 =?utf-8?B?WTlsbTdWTlRkbnVnZVdIWVp3ZnRNZEpFZ00yYzdpaERRR0tqZ2UwU1ZYalE3?=
 =?utf-8?B?aENaeC9CdjQwRFZ4SmtJeU03Y2dzaTQxV05Wb0x4TXltamttbDBGYU5GT2hO?=
 =?utf-8?B?aCtYN25rS0hGMUV1UVBjbkpuaUVxMVlISmZLL2tYWlJSWlhvd3Yrd0NQRU43?=
 =?utf-8?B?OVRpdC9FOU5UR29mM3FsbEt6QmxDMGlTWWFaMVZhRTR2R1F0RHJXYnRteTBV?=
 =?utf-8?B?NXRqa3cyWE5KN2wwM0x0YXZFNlJtb0hJWDFMVVRjM3QzcElsYUJMMXdHR1Yv?=
 =?utf-8?B?NHZLVy9DbVVrRGVuOFBGY0hyZ05qRnVpRUd5a3J6ZSs2Q1dqMjJGNVJEOGs5?=
 =?utf-8?B?aS9oVGtVQUlPY1JMeHRaTlV0VVAveEE4MUVPWlRJbk1QSmNKbktzdnBJa1RZ?=
 =?utf-8?B?QXQzODUxWVNYWmw5THBmOEx4U2l1c3IwdUc1QlIrS2h1M3RscldhK0JKQ01y?=
 =?utf-8?B?anl1Tmlvd09lNkJlSi9OZnNXR0JzL29kdG9qNm9HWjJPdmFNOGpiRnJUMkVX?=
 =?utf-8?B?NnJvSjY5bGVwMVNvRzJsZDdnaU1NNWZoc3laVEpobWVSa0dFWVNiWWhZV2Vi?=
 =?utf-8?B?MG9ha1dFbml3MUxrSVhQMXJWZi9WaURjdE5QY21RaUtLVmt5TmtvNmpPV2Np?=
 =?utf-8?B?VVdwK2JjcS9aSGUvRW9kaG56TFVzTWN3eGdrRFVxSG5FKzA2Szk1NHI4anlm?=
 =?utf-8?B?R3lKNGQ0YnFBNndWeUlNUDdOOXBOR0JxUWFZNjhTQlIzbjk0UFZxeXZCcnJh?=
 =?utf-8?B?aVZCUkh6UXBDczE2Y25PQVBsbXFjQlJRdlNYZjJEU0VQamRYMGNRdk56d0hF?=
 =?utf-8?B?OXBWWmFwZnc3N2JLMktlYitDZlpFUmxNTURpRFIxWGFONmxSOFJOVTZsR2ln?=
 =?utf-8?B?ejMwVGlRaUkrUURDbXVVdDVqVENwTU5nUzFlQjZrMmlwZDlFVVlSU0dUT2s0?=
 =?utf-8?B?cjRsSlhhVityQmNMc29sYVNNM25nNWRPamZ1YjZ0WUt5d3lOamx3bGZEbWVu?=
 =?utf-8?B?TXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61D940BD064BCE42BFAF01B11A2D0535@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85bf8ca1-6420-4e65-30c4-08db2b257050
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 22:33:20.0832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q6YtDGTJE9ZZbXXo+ZHhqM/+25+6kIxo1wMxEhhpJYWd1CRlRhz3CH2f0PLtdV4LGP/Rvc6IfpFJfvSzMgBS8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4876
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAzLTIyIGF0IDEyOjU4ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IENo
YW5nZSByZXR1cm4gdHlwZSBvZiBpc19sb25nX21vZGUoKSB0byBib29sIHRvIGF2b2lkIGltcGxp
Y2l0IGNhc3QuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCaW5iaW4gV3UgPGJpbmJpbi53dUBsaW51
eC5pbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL3g4Ni5oIHwgNiArKystLS0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5oIGIvYXJjaC94ODYva3ZtL3g4Ni5oDQo+IGlu
ZGV4IDU3N2I4MjM1ODUyOS4uMjAzZmI2NjQwYjViIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9r
dm0veDg2LmgNCj4gKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5oDQo+IEBAIC0xMjYsMTIgKzEyNiwx
MiBAQCBzdGF0aWMgaW5saW5lIGJvb2wgaXNfcHJvdG1vZGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
KQ0KPiAgCXJldHVybiBrdm1faXNfY3IwX2JpdF9zZXQodmNwdSwgWDg2X0NSMF9QRSk7DQo+ICB9
DQo+ICANCj4gLXN0YXRpYyBpbmxpbmUgaW50IGlzX2xvbmdfbW9kZShzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUpDQo+ICtzdGF0aWMgaW5saW5lIGJvb2wgaXNfbG9uZ19tb2RlKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkNCj4gIHsNCj4gICNpZmRlZiBDT05GSUdfWDg2XzY0DQo+IC0JcmV0dXJuIHZjcHUt
PmFyY2guZWZlciAmIEVGRVJfTE1BOw0KPiArCXJldHVybiAhISh2Y3B1LT5hcmNoLmVmZXIgJiBF
RkVSX0xNQSk7DQo+ICAjZWxzZQ0KPiAtCXJldHVybiAwOw0KPiArCXJldHVybiBmYWxzZTsNCj4g
ICNlbmRpZg0KPiAgfQ0KPiAgDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0Bp
bnRlbC5jb20+DQo=
