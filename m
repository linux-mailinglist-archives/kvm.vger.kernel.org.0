Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD0377D7C5
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 03:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241094AbjHPBgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 21:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241003AbjHPBgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 21:36:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918121BF8;
        Tue, 15 Aug 2023 18:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692149774; x=1723685774;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rWwtbYBywr4/Q3kJdg1pZUnXXdC3IowTUoMLuQn16+8=;
  b=hWfjjmxw13y8GJ7EJwXPBkw87CgxQW5pA3zLF/6W8dFYx6G7nEdf/Rnt
   5YJsvlSrlhckNh3oLeEa850UJvqq+scoQ82dahlMqeDgrNnbUKLQ5XLF3
   FV5JHRoWH3X4PEsYR1q2vMNBfaedJKMq7l3IpXj7G31T+co0eNqWNk59Q
   vCpBj4z1hDsfchKhJfp/xS0uHQ8io97OKKXfJnajDKTPQ+Cg8hGr4Ahv0
   Dhks6wLhupF05/AhyluNEM/X6nGo7F+A2GdDryl0sQopR0Lop7YsWOpWs
   FadZFfFB56y9oTdmUpIiZcLRkvEAm23kvwQg71RN/PKzv4+3htVjWf3wH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="436316151"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="436316151"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 18:36:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="763467520"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="763467520"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 15 Aug 2023 18:36:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 18:36:12 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 18:36:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 15 Aug 2023 18:36:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 15 Aug 2023 18:36:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEFetDYm4H1giNUHDJkcKOeQ2DZH8phIfxfOTveESg1Wu62huTRHhNV9uDBPCGg0uio3adQnGiYH7suudPaDFu7ejYFu7UCjow+Y3jPLY9LPgsLX0oG9VdnjKqZ0PBnXZGyKckFzjLOCvWs4Pu6s0J6RFJDbAg387sDmgsQCKvhasK4QxprNmwHajCy+w/U19vz618IhZH8nRT8P/nP4/uKcgvnoHcIaD3hZ5+WkD7lOlBaggJp4zo9OJquckP2r/5GaTC14eXK97igfFET8j0CTegAi8T9sX5L79Qu085MEVzdagtmmpHlK82RCI8jYObxG3XonGGu7lw4LB3x1gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWwtbYBywr4/Q3kJdg1pZUnXXdC3IowTUoMLuQn16+8=;
 b=VD+VqHYmVqtFynxNsE3oIK8i0LSs66gAmFfjiLDKP9a7/fJ6YhjXX3OOBwff7ruwr3TZ79A7p6X3+hmVJIGZb5HNI3vbiaw3daxEvetbCzB1TVUuWjuwKacXk81q4oyIX00nseiC8VR3GWyO6g7kfEjYvCzrH3JHnPH/Z+0YC9AGHYOSy3BSfI1hPDIN/EBVitFScDnV1Pm0p2eXfuBLPW4DSD366n3mgfxbvihf4SKtkWzsA7DlIoveYwgHJVHBOtX27+n1ZOXNuJUCulliPFPWA+sUuRLMt9ajZNG993TvDxDqWcjOKpalylM8FUGLsej1UHsO4S4ivEKbEQzzLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7825.namprd11.prod.outlook.com (2603:10b6:930:71::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Wed, 16 Aug
 2023 01:36:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6678.025; Wed, 16 Aug 2023
 01:36:05 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yao, Yuan" <yuan.yao@intel.com>
Subject: Re: [PATCH v3 01/15] KVM: x86: Add a framework for enabling
 KVM-governed x86 features
Thread-Topic: [PATCH v3 01/15] KVM: x86: Add a framework for enabling
 KVM-governed x86 features
Thread-Index: AQHZz7iCXeBxUR9Es0ebrzzHuGyWkq/sJJYA
Date:   Wed, 16 Aug 2023 01:36:05 +0000
Message-ID: <6370c12ff6ec2c22ed5e1f1f37c1cf38a820a342.camel@intel.com>
References: <20230815203653.519297-1-seanjc@google.com>
         <20230815203653.519297-2-seanjc@google.com>
In-Reply-To: <20230815203653.519297-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7825:EE_
x-ms-office365-filtering-correlation-id: 13a1c415-a129-48bc-eaae-08db9df92892
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qorl3iGItJWHj8RKTcs3Nd5b85tYHSI3m5aCzzLBMeGEp4sf0U7+rZ07Af8VVQ3JCBWC+yArbaDuhkUDz+Lv+NtXz8BcAHV+U0RLgwRUPczAVkyb23G4zFct5hFjQ48Uz1JCe5esTqXqXN9dw6X7F/ACGeHYnNV7DQDnM7MuYhREXTMD2CFQkQCBsZk1xiEB4RJelVmNLKt7LdY9mnvr+ymNyit6qgQUdWSd32rLUPSb1qO/7JLNV1IhaYJI1OGf/CxZrk9gY2GJEYScMx1gOM20fQW96u1+ZoOSg1r/3p//+Kb5IjJboy3aUc8hBLJsvuVe7fP3VzWkNyWek+QzfBRgOhowKg6Jt+QVBWmM4k9x9YW+IDvKrIUfU8nz0eG7+wUUX4+pe6X12gyugpTL2mYLDJahAh3Ux9SHB70X5fzwkljcAyf0ibC6JhdI6TetyujvNkquTonqO6TcEVhBfm/1xByQuLye5KdAqu/aP8wow+MUyyGS2/ZEZtsRgS9Or+2UX27yVypC4j9t/IOoknqgJESxXhNNohYLdoZYiIjY1e9PRQmismuoILbj55cfvz+HNv+GOGrVm8I+9c/yQUtRioe7H84ToIqBO4H4Umc1DnfP2RlZj1ePXr6ZgOGG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(136003)(376002)(39860400002)(451199024)(186009)(1800799009)(478600001)(122000001)(86362001)(66446008)(66556008)(316002)(36756003)(110136005)(66476007)(76116006)(66946007)(4326008)(107886003)(71200400001)(2616005)(38070700005)(41300700001)(82960400001)(8936002)(8676002)(26005)(38100700002)(6512007)(6486002)(6506007)(2906002)(5660300002)(91956017)(64756008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0NLM3dXdElNOTBVaFVPNDJnejRDV3M5akNMY1V0N1FVbUhwRlNtdSsyc0Rl?=
 =?utf-8?B?SnAwVU9GTEJ1VCs3Z2JacVJqTHo1S1g4WllOS2x4KzBMbXNhVnpkMVlZdDcx?=
 =?utf-8?B?L3RUd050WnUzUU9UVEZQSmpUZkc3SG1UMWwyT1BjVlNMSFlPSm9ka2cweWlD?=
 =?utf-8?B?UEN3SFoxSlEwTk5RQXlHMVVlczZDMy9zN2owUzBDSFlqV3A0dVU2NGtMR2I5?=
 =?utf-8?B?eGZ0REVlZ0R6SmNuWjhCa3ZhdnVsd2g3YUR3dlA3U0xJOTNiM2V4Tnl5aTh3?=
 =?utf-8?B?VldsUlFlR3lLVnEvZ0ZFR3I0aWxWY0tVWkFDNkJrUU1MQTE4UlRTR2h3Sjlo?=
 =?utf-8?B?alQveGxCcTl4Znpsa2NLaHNpeEVhejRuNVZ0em52Snk1MXgyQ1hQM0g3dDEy?=
 =?utf-8?B?NlVMeWdLdm5MSzBnQzRXaVFjcU00dmpkcnNUVWNwcjhYdTUvRmJQS3paZ1Y0?=
 =?utf-8?B?a2pWN2FSSlVRTHB5eFluWURLM09DOW56RUh1TSswei9RSW9kOEd6d0Nnc2JL?=
 =?utf-8?B?blo4LzJ3QmNXNmtjVHFtU25mUzhwbkxPM0pxUkxEUCtOWWQ2c2tWSDhHQnlS?=
 =?utf-8?B?R0NUUm5lVS85T053eGh2QnJmbXhPdHNPMzkzNG1RenpLYmdOMCswa1orL2dJ?=
 =?utf-8?B?UjZaV0pXdy9nMmxqOUxsU284dzF0NUVIQ1EzTlE1NlBpOEpZUGx2Y1ovSGQr?=
 =?utf-8?B?VnlrdDUrZG8vb0xLUXErNWtHS3hDazJRbE45ZUVERW5XNmdXNGhtRndWc2Fo?=
 =?utf-8?B?dXNOaE03SUVsVnNBM0FTVEJCZDdBLzMrc21LT1JNNVlwcEJNemZJa1g3MStI?=
 =?utf-8?B?YTlFNy9VZzZDVGRKVHhwS0V1Wm1SU1FGaVRxcGVUZjJDQWRTMURFM0NLY3Ny?=
 =?utf-8?B?U05aNm5RMVVkVHhEVGdmNmdGYjVQb1hncUM5RWx2WDgvMlFaNFZhNXdpSDdK?=
 =?utf-8?B?UWxLc3JYTlAxVENaeUR4RlFUWGdjUzdJY1JzVkgrYjRLMDJTZjVCLzJLVG5r?=
 =?utf-8?B?Z0J0Smcvc1ZvUTlIMk1aOVFEZUg1b3FlSlNGSVZZTGFoY09NWmtEWU5GckJG?=
 =?utf-8?B?M28vRml0USszYjdEajlJSXBKVi9zM25EQytGWlp6bnIwNVNEMFQvVzdQck1H?=
 =?utf-8?B?SnlxMmdLV3g5SHNvUHdTRkVxc2dUSVg4T2Jhdlk2elczN1E4WkhRQXI1REZ4?=
 =?utf-8?B?VmxiSzBJeHZBaW96U1NBWEV5WjY5QkFvZFhOSHhUWnpaSGx1MUo2cTZWQjJP?=
 =?utf-8?B?UzRKdUh0cnpHNnJzSnFUQTJBMlVpQ0R1Rk9aaGVWbE1xWDlvQjVITW0xbEIw?=
 =?utf-8?B?K3ZlR3dpVjdrclVFZkgrVEpWb1VtWUR4SytjeEpCSzhWVVUvejFLQmI4MkpR?=
 =?utf-8?B?SXRvMCs3UlFuSjBVZ3BjaTFyQTB1M0w3RE1TdmU1YjY4VjZQODBkYXFKalkv?=
 =?utf-8?B?Tjd2eWwzWEtsdklZZm9lV25ZclZuR0hjTmxGQ2NmZTc1VTdmQis3cFBwV21N?=
 =?utf-8?B?WGN6V2lzODhqZUVEMVdKdExUdk1penh5OFFCRzRCYS9iejVxQ3VBL2pmQlNF?=
 =?utf-8?B?MEM1MXVySFZ3WVF1ODRITWpKQXdzVXVaQXFXU3FOZmk4blFWcThURHBGaWd3?=
 =?utf-8?B?UzFSYTdGN0xLaWJNaTJFaUxaWWZrVFFySWxtVGJPQ3FyTEs1RTdCMDhIRkZy?=
 =?utf-8?B?OFc5WUlqd2JJQnFTc1YzbnFzWWpibFBjN1Y5SkVVeHR4Z040Z2hhbys1K2hZ?=
 =?utf-8?B?d0tOQ08wZS9HdCtvanJhSXlMcHJPb1J6ZzZQWEt0VG1NV0NmMm1WY3FQRE1m?=
 =?utf-8?B?b0ZKeld0bUtBVytkN3VocklwNlhyK1g4SkJNcHFaSTdaMS82Z2Y0S0cyamlm?=
 =?utf-8?B?WXYvR3RYZXhMU0tJMUg3RnZaeHdOQ0YwdmNtZ29vMnZPNWNCdytYRWl1aHBQ?=
 =?utf-8?B?cW9MQllHOTRYT1BtRitrRWMyRWZhdnhBUzlpQzUxOCtxeDNocnQvTFVGSFIw?=
 =?utf-8?B?M2lNYjgwclducndXQW1qTVFlQXpRUWVCUk5uWDdRSGVBbVVIWTJWOUlHTUdP?=
 =?utf-8?B?Wncvd2xVTThkTWdTNENtd3o1ek4yL2Jwc0NEcDZIQ25UaUFySFkzY0J1anJx?=
 =?utf-8?Q?lpoXgIzazvBEZl4KNJbfKPQ6q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FEF3F4F1529AA249BF8A166E6F66B219@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a1c415-a129-48bc-eaae-08db9df92892
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2023 01:36:05.5891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9/0dBoeZyh/OLyqZZMq1CCmrEA/sNBulWFouF5v2sUQL/JEWk7aA7hSzCzSCsYruNvGsPYBgLcoPjFeEXoyxNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7825
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

DQo+ICANCj4gK2VudW0ga3ZtX2dvdmVybmVkX2ZlYXR1cmVzIHsNCj4gKyNkZWZpbmUgS1ZNX0dP
VkVSTkVEX0ZFQVRVUkUoeCkgS1ZNX0dPVkVSTkVEXyMjeCwNCj4gKyNpbmNsdWRlICJnb3Zlcm5l
ZF9mZWF0dXJlcy5oIg0KPiArCUtWTV9OUl9HT1ZFUk5FRF9GRUFUVVJFUw0KPiArfTsNCj4gKw0K
PiArc3RhdGljIF9fYWx3YXlzX2lubGluZSBpbnQga3ZtX2dvdmVybmVkX2ZlYXR1cmVfaW5kZXgo
dW5zaWduZWQgaW50IHg4Nl9mZWF0dXJlKQ0KPiArew0KPiArCXN3aXRjaCAoeDg2X2ZlYXR1cmUp
IHsNCj4gKyNkZWZpbmUgS1ZNX0dPVkVSTkVEX0ZFQVRVUkUoeCkgY2FzZSB4OiByZXR1cm4gS1ZN
X0dPVkVSTkVEXyMjeDsNCj4gKyNpbmNsdWRlICJnb3Zlcm5lZF9mZWF0dXJlcy5oIg0KPiArCWRl
ZmF1bHQ6DQo+ICsJCXJldHVybiAtMTsNCj4gKwl9DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBfX2Fs
d2F5c19pbmxpbmUgYm9vbCBrdm1faXNfZ292ZXJuZWRfZmVhdHVyZSh1bnNpZ25lZCBpbnQgeDg2
X2ZlYXR1cmUpDQo+ICt7DQo+ICsJcmV0dXJuIGt2bV9nb3Zlcm5lZF9mZWF0dXJlX2luZGV4KHg4
Nl9mZWF0dXJlKSA+PSAwOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgX19hbHdheXNfaW5saW5lIHZv
aWQga3ZtX2dvdmVybmVkX2ZlYXR1cmVfc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gKwkJ
CQkJCSAgICAgdW5zaWduZWQgaW50IHg4Nl9mZWF0dXJlKQ0KPiArew0KPiArCUJVSUxEX0JVR19P
Tigha3ZtX2lzX2dvdmVybmVkX2ZlYXR1cmUoeDg2X2ZlYXR1cmUpKTsNCj4gKw0KPiArCV9fc2V0
X2JpdChrdm1fZ292ZXJuZWRfZmVhdHVyZV9pbmRleCh4ODZfZmVhdHVyZSksDQo+ICsJCSAgdmNw
dS0+YXJjaC5nb3Zlcm5lZF9mZWF0dXJlcy5lbmFibGVkKTsNCj4gK30NCj4gKw0KPiArc3RhdGlj
IF9fYWx3YXlzX2lubGluZSB2b2lkIGt2bV9nb3Zlcm5lZF9mZWF0dXJlX2NoZWNrX2FuZF9zZXQo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiArCQkJCQkJCSAgICAgICB1bnNpZ25lZCBpbnQgeDg2
X2ZlYXR1cmUpDQo+ICt7DQo+ICsJaWYgKGt2bV9jcHVfY2FwX2hhcyh4ODZfZmVhdHVyZSkgJiYg
Z3Vlc3RfY3B1aWRfaGFzKHZjcHUsIHg4Nl9mZWF0dXJlKSkNCj4gKwkJa3ZtX2dvdmVybmVkX2Zl
YXR1cmVfc2V0KHZjcHUsIHg4Nl9mZWF0dXJlKTsNCj4gK30NCj4gKw0KPiArc3RhdGljIF9fYWx3
YXlzX2lubGluZSBib29sIGd1ZXN0X2Nhbl91c2Uoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiAr
CQkJCQkgIHVuc2lnbmVkIGludCB4ODZfZmVhdHVyZSkNCj4gK3sNCj4gKwlCVUlMRF9CVUdfT04o
IWt2bV9pc19nb3Zlcm5lZF9mZWF0dXJlKHg4Nl9mZWF0dXJlKSk7DQo+ICsNCj4gKwlyZXR1cm4g
dGVzdF9iaXQoa3ZtX2dvdmVybmVkX2ZlYXR1cmVfaW5kZXgoeDg2X2ZlYXR1cmUpLA0KPiArCQkJ
dmNwdS0+YXJjaC5nb3Zlcm5lZF9mZWF0dXJlcy5lbmFibGVkKTsNCj4gK30NCj4gKw0KPiAgI2Vu
ZGlmDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vZ292ZXJuZWRfZmVhdHVyZXMuaCBiL2Fy
Y2gveDg2L2t2bS9nb3Zlcm5lZF9mZWF0dXJlcy5oDQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+
IGluZGV4IDAwMDAwMDAwMDAwMC4uNDBjZThlNjYwOGNkDQo+IC0tLSAvZGV2L251bGwNCj4gKysr
IGIvYXJjaC94ODYva3ZtL2dvdmVybmVkX2ZlYXR1cmVzLmgNCj4gQEAgLTAsMCArMSw5IEBADQo+
ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCAqLw0KPiArI2lmICFkZWZpbmVk
KEtWTV9HT1ZFUk5FRF9GRUFUVVJFKSB8fCBkZWZpbmVkKEtWTV9HT1ZFUk5FRF9YODZfRkVBVFVS
RSkNCj4gK0JVSUxEX0JVRygpDQo+ICsjZW5kaWYNCj4gKw0KPiArI2RlZmluZSBLVk1fR09WRVJO
RURfWDg2X0ZFQVRVUkUoeCkgS1ZNX0dPVkVSTkVEX0ZFQVRVUkUoWDg2X0ZFQVRVUkVfIyN4KQ0K
PiArDQo+ICsjdW5kZWYgS1ZNX0dPVkVSTkVEX1g4Nl9GRUFUVVJFDQo+ICsjdW5kZWYgS1ZNX0dP
VkVSTkVEX0ZFQVRVUkUNCg0KTml0Og0KDQpEbyB5b3Ugd2FudCB0byBtb3ZlIHRoZSB2ZXJ5IGxh
c3QNCg0KCSN1bmRlZiBLVk1fR09WRVJORURfRkVBVFVSRQ0KDQpvdXQgb2YgImdvdmVybmVkX2Zl
YXR1cmVzLmgiLCBidXQgdG8gdGhlIHBsYWNlKHMpIHdoZXJlIHRoZSBtYWNybyBpcyBkZWZpbmVk
Pw0KDQpZZXMgdGhlcmUgd2lsbCBiZSBtdWx0aXBsZToNCg0KCSNkZWZpbmUgS1ZNX0dPVkVSTkVE
X0ZFQVRVUkUoeCkJLi4uDQoJI2luY2x1ZGUgImdvdmVybmVkX2ZlYXR1cmVzLmgiDQoJI3VuZGVm
IEtWTV9HT1ZFUk5FRF9GRUFUVVJFDQoNCkJ1dCB0aGlzIGxvb2tzIGNsZWFyZXIgdG8gbWUuDQo=
