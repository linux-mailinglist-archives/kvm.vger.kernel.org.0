Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDDD7020D1
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 02:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237784AbjEOAhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 May 2023 20:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjEOAhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 May 2023 20:37:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A89911D;
        Sun, 14 May 2023 17:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684111056; x=1715647056;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=O3aZJcvntH9iryrNTwrsXSBG4CCIKWDidtKW02vN0hA=;
  b=WFDhufpasM+XZyu+y/IH0HonZxeNn1Qhx9SBFV828VactVP+DFq3g/2P
   Sad+oQlFHcakqRW2zrp+jXQbwSPYUf1IQMwMDVcfEGdYCEX47y4z7yIzK
   61IjJ3OeXnK1b8jsbQyUvBzjAiP/a2OigWQHqJ8N5ILDZI/DY6BnzKblI
   VL4FaDnS5/+CSVHaTIq447jVQRhvTQbht5riyKSNq9b669PQvV4JASNgV
   Kx1kCWLwrH/5NRmCDbso2iikb9eezFEyWwpE2oqFbA9DH0EH9s9EBxcRC
   88Ocwc6UpPvI5sZPwQAEA7wH79MKWw/RGgdl4h4Pd9pSlzMM+K4q/psZF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="414471390"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="414471390"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2023 17:37:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="790462168"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="790462168"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 14 May 2023 17:37:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 14 May 2023 17:37:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 14 May 2023 17:37:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 14 May 2023 17:37:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 14 May 2023 17:37:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lq2HtDnEraV9fN3kphTIrITM7OITLNj1wujj9nywKwUhRH4RC68qO/RQ8NOhHaVzwUOJzh/gWP7ZzXK5yE0z12d/FDWgKAe85yhsO8zOEqBd3R1O6xhEF7ioyzBXcvplTysPfF09iPxjrZJrL9dZYPJVuhrJN8rAATQsMgjI1parSvQ8KEqQq5BkvzOSrnk6pZJuPZJA3ipIQ3yHbs6oneAYPL1IExpWkw6p9z1eHirL7lhIMMXNS+16276Snke/xTYG/pSVK8w00QquGYV+jvYiifIk8Up/VzJUthe25bvu8EHxa90OAGVKRhjPNUzxCShKQ/lLtZiwexp45aXKrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3aZJcvntH9iryrNTwrsXSBG4CCIKWDidtKW02vN0hA=;
 b=Ux89PaKqndDA/fA+0IzIJvt/mwZGqSRYy/BEB9u1TDATuLNfkaE7N5w8OcG3Qs33oRnNIg2F1IOHCVSFTMIjy9rlh2vI3C8fXsGRp0/5Vx2L1j3myzYNryaUp7zwSrIlmmRlNpQS24kn5M2EKaFege1bJ9jjgyPDCI5Nfue52n67JMFOGYiStEXtVfU5H5XwQbmruznHG2PO1QRin66XlIh16Bv9eAyw8jCcwN3UYPo7kp27dWtRc4TAzmwYfXyWVW3MiMCqOc0vSmlowfgqHgTEAQbPHccrjqcFxkk38oUL4mwlrbqNQbHf0LzUZwAiShCa73XmKok3MkRgCzOU1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5489.namprd11.prod.outlook.com (2603:10b6:610:d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 00:37:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 00:37:28 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH v2 5/8] KVM: x86: Use MTRR macros to define possible MTRR
 MSR ranges
Thread-Topic: [PATCH v2 5/8] KVM: x86: Use MTRR macros to define possible MTRR
 MSR ranges
Thread-Index: AQHZhGEcNSDg8JA/dkmFf9j26efTAK9WchSAgABkvQCAA6tDgA==
Date:   Mon, 15 May 2023 00:37:27 +0000
Message-ID: <7972883f69abe6fe61a2e76def6a0a1f1f28228b.camel@intel.com>
References: <20230511233351.635053-1-seanjc@google.com>
         <20230511233351.635053-6-seanjc@google.com>
         <ecbcfb6ca243cf587eb6e61c6e852b4f474a36d7.camel@intel.com>
         <ZF5qnQQYa6OAI0Hy@google.com>
In-Reply-To: <ZF5qnQQYa6OAI0Hy@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5489:EE_
x-ms-office365-filtering-correlation-id: be8e3c4e-7a36-4574-9bbd-08db54dc8f82
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oNFUJsaSg145vc4pDmrP88MNKPj58dv9dgzSof08OP5hf/LULlqpS5vwNql8Let/YQx9xZRegx6a7Q2YfBpiKGf/EBwytpP3Jo5r64GQC6BeH9CvBv3vjfDz22IDwfmmdrZHxPFUQeAMXUlx4NCGhBvylskwB05Kl/XYH5H5nDgxFg6V0R0+oTi6FAZl2rtQhiWu2SUJ4VEKl0Vgku13RCwPBr8arNO6yRkceuV0RSepWt37ej5MdIpW6Rc35OknH4sWqZu0pzBpaWDUT2taxXAcbwvRRBBiT6t8w9BLbIV07TjVlWvE5ARGC4h5ZBoKUQ80ubrSlwxz7dAPLhxckvwVHByGb+v68/h4PTm3sIvoPSLEsiBHv+eB/Ti3JpODzgdMR9MUT5w3cpfW9UGS7OJ0c9DwlaLZ3RJcwNJJrRuRN2GVqdm1+Srhp6+q/0xH2zvnUkfcd87xBKxFYOT/fuOe/lDl0NmuDIBWxTWQBJhVUmVH8Txj1+oZkPW2Aj9mQ4oF9r698Y31OJCWnVuRjaSOsq4j7gybmSxww6N3AQzcBsz0u4lJ6/DsiKZ6c9QswOL+y40zIjgkalbJupD3LbuPBu0lYHfQ4jrAudwUXgM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199021)(36756003)(6486002)(86362001)(91956017)(54906003)(316002)(76116006)(66556008)(66476007)(66446008)(64756008)(6916009)(66946007)(4326008)(966005)(478600001)(71200400001)(8936002)(8676002)(5660300002)(41300700001)(2906002)(38070700005)(82960400001)(122000001)(38100700002)(2616005)(26005)(186003)(6512007)(6506007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnU4SWFEc0VENU9acS90a21wbmVGd0pqdnBUdE9MT1h0eGVrZTBwaHFDYkFl?=
 =?utf-8?B?U1N4Wk5kOGxJd0dWdW1wdjUzeWJ0VE5vY0lPUW1jZWpZQmV6K09CalFRbVR0?=
 =?utf-8?B?TUdUVFdrRzdaMm1xRlA3R1lxcDFmTHFocHJaQ1NtTXQxNktVVU50dzZITHRv?=
 =?utf-8?B?MWVkRjhvT3hENjFzbEFHcHZTZ1g3MXoxbkZxWUZSZ1d2V0pGUWRVdVRINWJz?=
 =?utf-8?B?LzZTMkh1QUVVL1RKWFJyMUdGNm1OSEF0ZEpRRHREa1RxbUQ4NTEyenZ3cWlZ?=
 =?utf-8?B?MXZwOGp3SmZRU1Q1NXAvb3hQV0orTGVZSEZDVmlDZGFVaEVMVmdycDZqb1hh?=
 =?utf-8?B?U3hBQmlGNmxXSnpFR3ZmRjgzL2NzR3BRVkhHbWcvcjZ2TXIxbzM5R24rY0Vl?=
 =?utf-8?B?Y2FLaTZOSzVYRFQ3dzdBRE5zT2F4K21mUDFvbzk1RXZLTDFLQ25IQW1SOE5y?=
 =?utf-8?B?TzFaVDdmaFo1TTlqS0pwNjJDZzk4YjhwOCt2N3VLMnBaQ0xHRUJmbDArQjMw?=
 =?utf-8?B?dldtV2lGRGlNUVBUSWtsZGRzU1IvY3ZnS0ZkUTJpWmt2MlRpL0JFempYd0JI?=
 =?utf-8?B?c1Q4eHpzQVZ2QnhuTWpXVUs1emNib29hazVma0VqcFliRlFsblQxaUNINk5K?=
 =?utf-8?B?TDBUKzBzcVJaYWtGWnRGN0xJV2xlQjYvUlh6V1EyZWRqY3hLVHB0QlpxRjg4?=
 =?utf-8?B?aTdIT3NkVUJoUlhYSHd6VDFHSXNsMDVUcGVVOVZPWXA4U1hsOVlrbSthcVhO?=
 =?utf-8?B?bHV2TTdwaHVGNGdzQnB2Ull2VkVjQVQ3MWI5UW8vZnBXWmNWNkdsZk5TelVr?=
 =?utf-8?B?NHk0NndBeG5IV3BNanN0WE9Gek9UN3AraUJTb05uTm1ZYTg5Z09KenRNVlly?=
 =?utf-8?B?VFpSSUY0SGZ0M3FWbEQ0Y1drT1dSYjNOS1ZDT3NFWnprdkpFeUx5Q0ppTkc4?=
 =?utf-8?B?d2NiK2ZZVVVJYW9qYUhkeFZPZDhMU1QrTG9QdkgxYW1EUzBnc1NPaS95MThO?=
 =?utf-8?B?azF3YmZ3UHhBeDFzSmFNRkpvWVlzQ3VRb1d6UDRYaHBEcXppRGNLOXNDUlZ0?=
 =?utf-8?B?YXlQNFQrWHJoOXdLcDFUVWRsR1FkVGNxRjlnNzlndFdveS83MHh6ajZWZk9a?=
 =?utf-8?B?T3dpM2lWSmRuK250dUlCcE53SlhmaEFyTzhYVVh2emVrSWVJY2xBbHh1L0t2?=
 =?utf-8?B?dnUyVVJJVDBCYkduemUxRldxMmxFOEZuRGQvT253eEc0N1Y3dXFMR2I4aE5o?=
 =?utf-8?B?NTZJSzVkenFtUWFKZ0RiL0VOckwwRkN3dWsyZGdWOTlMZ09uU1FNOGx6dGMv?=
 =?utf-8?B?R0JQNGlNQVc2OFIxUDFJS0o3YXloQkdiZFhWSDBBakVyY1VNdTFpZndzYWJr?=
 =?utf-8?B?R05XcFhYQ2ZTQUF6azNIcmVOdWhBQ1gzTnU5U1VwNFVmZCtMaStkeW15ZEMx?=
 =?utf-8?B?cm43aDI2RVZvMVdmZ3kzaUVrVWhYU0p0ZzZZS0hjNlpFV1BVNEJJS1VXT2dS?=
 =?utf-8?B?SnNhK1F1MnUyZVF6WFJySzNFQkQ2d242ZXltTTk1b2JQMWJtOWNqMUhENUx4?=
 =?utf-8?B?aFNYenE3NlBuTUlNYU9ESlllZEhoRjRacnNQbk9mOWZZc08xMGpKaklsTzZF?=
 =?utf-8?B?bjBSRXV5MS9KRlBVZFBUNXlFQ2RyMlpJTFJvT1NmS016emF6RjBwR3I0SFJq?=
 =?utf-8?B?UE0wN0h4U2FjRHIzMTlLbjZBd1pXOWV3aUVnbjd5cHRsWG5XVTJmVFdQR3pB?=
 =?utf-8?B?anV0TGpma1JDK2xoWVFOVnlUTzFrUlZWTW1YdmNkeDFESVViTmFCMXh0b2pu?=
 =?utf-8?B?NzJvRXZWUEZIZVNHdTBOTWU0M3BjVjduVjRaR2RmZ1dZMFF0aXVFb1FHL2tC?=
 =?utf-8?B?Y0xoQ0tQQmxLeGk5SDRiajBYRlRwVjZJNUNHaHdVNkJzcjBMQ0t6SUV0bGU2?=
 =?utf-8?B?VitkRkdENTFjRWZmYW1ucFo4RnprTHFEc0pnMGhHTmFBNUdXdWRSWEk0cDh2?=
 =?utf-8?B?VUNVczlHZTdiS3dzdjd5eXZMUzNJeTE1TDBEeXZDY01saWRqaWtQaW5NRGdx?=
 =?utf-8?B?RXZrWkcrMXIwYjRBQ0NZSFdTbTlMczhJQXQ2Nmd5R1RzS2c0dk9zM050ZURy?=
 =?utf-8?Q?HeNp7B8KwUF1/0CJSSlSp1poG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A9D0AF185CBDD4E93AFCB73C74181CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be8e3c4e-7a36-4574-9bbd-08db54dc8f82
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 00:37:28.0211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I+vsqHbiO9ARiRXtnJsO+GUEnsN/lnhI1DXwDjZ6wjvyK9jNQQOSokFc4Rsy810T5u+mVIaxOTjRIPiiUbEm0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5489
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDA5OjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIE1heSAxMiwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyMy0wNS0xMSBhdCAxNjozMyAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2
LmMNCj4gPiA+IGluZGV4IGU3Zjc4ZmU3OWIzMi4uOGIzNTZjOWQ4YTgxIDEwMDY0NA0KPiA+ID4g
LS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMN
Cj4gPiA+IEBAIC0zNzAwLDggKzM3MDAsOSBAQCBpbnQga3ZtX3NldF9tc3JfY29tbW9uKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IG1zcl9kYXRhICptc3JfaW5mbykNCj4gPiA+ICAJCQly
ZXR1cm4gMTsNCj4gPiA+ICAJCX0NCj4gPiA+ICAJCWJyZWFrOw0KPiA+ID4gLQljYXNlIDB4MjAw
IC4uLiBNU1JfSUEzMl9NQzBfQ1RMMiAtIDE6DQo+ID4gPiAtCWNhc2UgTVNSX0lBMzJfTUN4X0NU
TDIoS1ZNX01BWF9NQ0VfQkFOS1MpIC4uLiAweDJmZjoNCj4gPiA+ICsJY2FzZSBNU1JfSUEzMl9D
Ul9QQVQ6DQo+ID4gPiArCWNhc2UgTVRSUnBoeXNCYXNlX01TUigwKSAuLi4gTVNSX01UUlJmaXg0
S19GODAwMDoNCj4gPiA+ICsJY2FzZSBNU1JfTVRSUmRlZlR5cGU6DQo+ID4gPiAgCQlyZXR1cm4g
a3ZtX210cnJfc2V0X21zcih2Y3B1LCBtc3IsIGRhdGEpOw0KPiA+ID4gIAljYXNlIE1TUl9JQTMy
X0FQSUNCQVNFOg0KPiA+ID4gIAkJcmV0dXJuIGt2bV9zZXRfYXBpY19iYXNlKHZjcHUsIG1zcl9p
bmZvKTsNCj4gPiA+IEBAIC00MTA4LDkgKzQxMDksMTAgQEAgaW50IGt2bV9nZXRfbXNyX2NvbW1v
bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBtc3JfZGF0YSAqbXNyX2luZm8pDQo+ID4g
PiAgCQltc3JfaW5mby0+ZGF0YSA9IGt2bV9zY2FsZV90c2MocmR0c2MoKSwgcmF0aW8pICsgb2Zm
c2V0Ow0KPiA+ID4gIAkJYnJlYWs7DQo+ID4gPiAgCX0NCj4gPiA+ICsJY2FzZSBNU1JfSUEzMl9D
Ul9QQVQ6DQo+ID4gPiAgCWNhc2UgTVNSX01UUlJjYXA6DQo+ID4gDQo+ID4gLi4uIFNob3VsZCB3
ZSBwdXQgTVNSX0lBMzJfQ1JfUEFUIGFmdGVyIE1TUl9NVFJSY2FwIHNvIGl0IGNhbiBiZSBzeW1t
ZXRyaWMgdG8NCj4gPiBrdm1fc2V0X21zcl9jb21tb24oKT8NCj4gPiANCj4gPiBMb29rcyB0aGVy
ZSdzIG5vIHJlYXNvbiB0byBwdXQgaXQgYmVmb3JlIE1TUl9NVFJSY2FwLg0KPiANCj4gTm8sIGl0
J3MgYWJvdmUgTVRSUmNhcCBmb3IgdHdvIHJlYXNvbnM6DQo+IA0KPiAgMS4gV2hlbiBQQVQgaXMg
bW92ZWQgb3V0IG9mIG10cnIuYywgUEFUIGRvZXNuJ3QgZ2V0IGJ1bmRlZCB3aXRoIHRoZSBvdGhl
ciBNVFJScw0KPiAgICAgYW5kIHNvIHdvdWxkIGp1c3QgbmVlZCB0byBiZSBob2lzdGVkIGJhY2sg
dXAuICBUaGUgZW5kIGNvZGUgbG9va3MgbGlrZToNCj4gDQo+IAljYXNlIE1TUl9JQTMyX0NSX1BB
VDoNCj4gCQltc3JfaW5mby0+ZGF0YSA9IHZjcHUtPmFyY2gucGF0Ow0KPiAJCWJyZWFrOw0KPiAJ
Y2FzZSBNU1JfTVRSUmNhcDoNCj4gCWNhc2UgTVRSUnBoeXNCYXNlX01TUigwKSAuLi4gTVNSX01U
UlJmaXg0S19GODAwMDoNCj4gCWNhc2UgTVNSX01UUlJkZWZUeXBlOg0KPiAJCXJldHVybiBrdm1f
bXRycl9nZXRfbXNyKHZjcHUsIG1zcl9pbmZvLT5pbmRleCwgJm1zcl9pbmZvLT5kYXRhKTsNCg0K
U29ycnkgSSBtaXN0YWtlbmx5IHRob3VnaHQgTVNSX01UUlJjYXAgd2Fzbid0IGhhbmRsZWQgaW4g
a3ZtX210cnJfZ2V0X21zcigpLiANClllcyBsb29rcyBnb29kIHRvIG1lLg0KDQo+ICANCj4gIDIu
IFRoZXJlIGlzIG5vIE1TUl9NVFJSY2FwIGNhc2Ugc3RhdGVtZW50IGluIGt2bV9zZXRfbXNyX2Nv
bW1vbigpIGJlY2F1c2UgaXQncw0KPiAgICAgYSByZWFkLW9ubHkgTVNSLCBpLmUuIHRoZSB0d28g
Y2FuJ3QgYmUgc3ltbWV0cmljIDotKQ0KDQpEbyB5b3Uga25vdyB3aHkgaXQgaXMgYSByZWFkLW9u
bHkgTVNSLCB3aGljaCBlbmFibGVzIGJvdGggRklYRUQgcmFuZ2VzIGFuZA0KKGZpeGVkIG51bWJl
ciBvZikgZHluYW1pYyByYW5nZXM/DQoNCkkgYW0gYXNraW5nIGJlY2F1c2UgdGhlcmUncyBhIHg4
NiBzZXJpZXMgdG8gZmFrZSBhIHNpbXBsZSBzeW50aGV0aWMgTVRSUiB3aGljaA0KbmVpdGhlciBo
YXMgZml4ZWQgbm9yIGR5bmFtaWMgcmFuZ2VzIGJ1dCBvbmx5IGhhcyBhIGRlZmF1bHQgTVNSX01U
UlJkZWZUeXBlOg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjMwNTA5MjMzNjQx
LkdHWkZyWkNUREg3VndVTXA1UkBmYXRfY3JhdGUubG9jYWwvVC8NCg0KVGhlIG1haW4gdXNlIGNh
c2VzIGFyZSBYZW4gUFYgZ3Vlc3RzIGFuZCBTRVYtU05QIGd1ZXN0cyBydW5uaW5nIHVuZGVyDQpI
eXBlci1WLCBidXQgaXQgYXBwZWFycyBURFggZ3Vlc3QgaXMgYWxzbyBkZXNpcmVkIHRvIGhhdmUg
c2ltaWxhciBoYW5kbGluZywNCmJlY2F1c2U6wqANCg0KMSkgVERYIG1vZHVsZSBleHBvc2VzIE1U
UlIgaW4gQ1BVSUQgdG8gZ3Vlc3QsIGJ1dCBoYW5kbGVzIG5vdGhpbmcgYWJvdXQgTVRSUg0KTVNS
cyBidXQgb25seSBpbmplY3RzICNWRS4NCg0KMikgVERYIG1vZHVsZSBhbHdheXMgbWFwcyBndWVz
dCBwcml2YXRlIG1lbW9yeSBhcyBXQiAoYW5kIGlnbm9yZXMgZ3Vlc3QncyBQQVQNCklJVUMpOw0K
DQozKSBGb3Igc2hhcmVkIG1lbW9yeSwgdy9vIG5vbi1jb2hlcmVudCBETUEgZ3Vlc3QncyBNVFJS
cyBhcmUgaWdub3JlZCBieSBLVk0NCmFueXdheS4gIFREWCBkb2Vzbid0IG9mZmljaWFsbHkgc3Vw
cG9ydCBub24tdHJ1c3RlZCBkZXZpY2UgYXNzaWdubWVudCBBRkFJQ1QuDQpFdmVuIHdlIHdhbnQg
dG8gY29uc2lkZXIgbm9uLWNvaGVyZW50IERNQSwgaXQgd291bGQgb25seSBhZGQgY29uZnVzaW9u
IHRvIGhvbm9yDQpndWVzdCdzIE1UUlJzIHNpbmNlIHRoZXkgY2FuIHBvaW50IHRvIHByaXZhdGUg
bWVtb3J5LCB3aGljaCBpcyBhbHdheXMgbWFwcGVkIGFzDQpXQi4NCg0KU28gYmFzaWNhbGx5IGxv
b2tzIHRoZXJlJ3Mgbm8gdmFsdWUgdG8gZXhwb3NpbmcgRklYRUQgYW5kIGR5bmFtaWMgTVRSUiBy
YW5nZXMgdG8NClREWCBndWVzdC4NCg0K
