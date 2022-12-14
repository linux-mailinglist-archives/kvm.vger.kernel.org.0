Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8714964C76D
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 11:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbiLNKvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 05:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLNKvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 05:51:36 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD3410FD3;
        Wed, 14 Dec 2022 02:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671015094; x=1702551094;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VDCWyiFQo1P1ur3sUY9SSKsEDEIb0RcLg3Zv5vyN5ZQ=;
  b=VBI0g5OffA1E/bv4OSLLTSch1jOG/+r6/fi1oiLtD79m17tkeE6SQU8K
   vKQZFla7NHaL9jk5HV8og2p9SEBovjZ/2IJ/+rp/lupldyVYCbJ7NX2PK
   8bJd+/qN9Cr8CmkTWu2Kmh4cCcF0uX84TbFpprCrihDJBVfY888/ViZ99
   gy0J1HyOF9kchGP1AI/H5jiKHfICtw93EMkH9N9PQmarsvmI54Iaq023S
   CvPZoyyMOsT1voYOGIi/9mmEZMCHkMPUgPWhR0FkwU0R5hRiAAiYUi0el
   xOylMshSy32v46+1yqWKp66GlK3LCw4iLS33R+CM6iOWIefIwsfOsTjOT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="382672412"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="382672412"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 02:51:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="642457439"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="642457439"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 14 Dec 2022 02:51:34 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 02:51:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 02:51:33 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 02:51:33 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 02:51:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPBeZtV93E0OKry0Pr6IMHV3L9hRD5OjP5Qf+B8AFt1UOqqXGEQXD9Hcey9fPeXso4R5LkFbxp+XHHUYFOAUg9nPFr2oXUnymcgvilEKa1USB2OduMNHHW+THFvpNBd6AQ7yK0E9pLG+/pszh3AwourmxbF0N/gwaZh+kPW2RsuAyHuJZCVHrFrn75TFnT1YrjifLc9dlcUmkxR2rzVVA15TmthoJ3/dEV49y3WywovVCjDwFKtGaogBy1ppqHT/7H22bziVc10kuuNw0A1NdymgI2fmokuslRCmf+kOOEt992QohZ+zek6ajpZ2igSA9lbaO9mWj7GjvHq/T/vecQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDCWyiFQo1P1ur3sUY9SSKsEDEIb0RcLg3Zv5vyN5ZQ=;
 b=nL1zuIQnxaSYk8da70WkCowP14tq0z01ofg66R3Jt9xodwSk0FrREwIW9S0VRXRRPAmtGBItVHrm3SED+hgNPU7/uedBJYUnbnW9Keqp9ksVFGAcVtBuKv9JlEjqJUySERaAWtxNMKsSgDB45qAkp5nI/+OSUM3g4yVl9NVVfjLXv8OsWXfvlftGZV3ABc+Rq7mOahRFZ3fn4YKF+s00f+WQmyr6hflALv6XK3LlF1D7Nj4Q1Tl2i3pIjhTOZ71pmRUhyb67T5L4yY+ck27fUmIV7bb79abcWl+NbrRCn2PDFLYFuTAIz73WKOFvup2zo77gZAM4BH1Dmc+IkrYt6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4873.namprd11.prod.outlook.com (2603:10b6:806:113::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 10:51:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 10:51:31 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 046/108] KVM: Add flags to struct kvm_gfn_range
Thread-Topic: [PATCH v10 046/108] KVM: Add flags to struct kvm_gfn_range
Thread-Index: AQHY7CiJA0kfvmpBe0OC8BeNSC0dtq5te7mA
Date:   Wed, 14 Dec 2022 10:51:31 +0000
Message-ID: <ce1b2bc760daf9cc07591bdc4d3e83e40391f468.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <880c1016c29624964baee580985b6a736fc7d656.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <880c1016c29624964baee580985b6a736fc7d656.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB4873:EE_
x-ms-office365-filtering-correlation-id: 2e8bb4f2-0399-4343-f38c-08daddc128f4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /kOmTF+RAos8TC2PlSYgcuBgITEnImz3BL1fJfWuoBys41vbvKS5kWwVWJuwjXNv/YO4pJkTNqJ7bqUQP8jZaXw3wrLPDgM/dd2eQYoTLoGxBwPRytBnNREGIe9sRNhKeAlFo3t8xJBpELM0nN6IixkgfhiKNmq3vso1D/7UI5ElR8LEy3SPiOOXGWiYr4aQCD7jrkGEx8aAi3XIgYrD/q1lOcXRjbNmK7l8qr6XzpGTYvUoLZCygjLdtYGCLf6rSZt5s/BIa+IyMkutUeLoajS1s+Lbpg2GL9sUxa0OnRBBI0AE1xTtAQeIXSfTTS1yTn5ocE5gVnpJXOe7XzwUE3SzSB3jMtPZZsCjxAoiif+SIGrwtHcnogDRKLihyk3gyZagk66jy3JCM14TQHQaFKYwdLsrAz4DE56BvhuWah8/CAgSgwAssFJ+c8mTsjVLLF0qHWW5QUirBKaSRTtzr8eN6LDMDXo7VR0jWl/9h4oCvYsei3Ru+YhJ8r5feEVEYM546TjyXQ95MJSvkKLRDtUdbSWFYy9c8okoD/V2tA17k72CxAPT5p9GnHwR+Fl53I+IyK8BiUnuy7xfqqdfGiQTobcROo/CXa2YqEgDfszrBlYitFnWbsURUOWGmKPNUMCjEkNEmNqUt/eXgBSkGIKpeU5yvCMUQsb58+n2fH39Gk32jfzmrX6gIX3CLWom
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199015)(316002)(54906003)(26005)(122000001)(4001150100001)(2906002)(6636002)(110136005)(186003)(36756003)(71200400001)(478600001)(76116006)(66946007)(6512007)(8936002)(2616005)(91956017)(6486002)(38100700002)(82960400001)(5660300002)(83380400001)(66446008)(38070700005)(64756008)(86362001)(4326008)(8676002)(66556008)(41300700001)(66476007)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2hwREJkcEwxbG9QdzA0WXBoUWVKdGRHQkNQbHZ2ZVZjUjhNR3ZhMjBMNFNy?=
 =?utf-8?B?UlRJbU9BYzlNMVlLaDltTEtQbDhTdTVIVmRYTTN2Q0huOHNqMnY5ZS9zeUd2?=
 =?utf-8?B?UGs1ZlcrTms2QStRcE1HRXQ4ZWV4SHdHTERNOENmK1hHMFNKQ2oza0dpWVFJ?=
 =?utf-8?B?bnpYQjdWbTV0aHJKNzVlR2RybDcySjNmbEtkamlRd1RWNG9STVlrUDN6empk?=
 =?utf-8?B?VEsrQlkrSHdCeHg3eGM5VTUydUxtUnkyUVF0UHdZTHF6UGpzVlMxV2RoVUF2?=
 =?utf-8?B?RGdQMXFZcjFqRnRKeU1NcUkybmZJN0wyT2tlYUJjZ1NVaDdSV1NXMXZhbFlO?=
 =?utf-8?B?azU4clhlc0VEYnBadlYyUmlqOGQxdUNsMG5UUDlVZWpGUlFEUkZBT3BZUWdi?=
 =?utf-8?B?OS9OYnltcWVUeGxPN3EyUnp0MVhhNThlSTRqcnhsVXFIS240OWZzUlY0dWcx?=
 =?utf-8?B?MnNib3FXYmtRSTkxZnVmVmJac0pvR3FhVDBYNWNZN1FZN0p2ejkvV0JSUTh6?=
 =?utf-8?B?QTRXMitCSm42ZW1scTFMZkRqc0ZkZVNPeFNPVE45Q3BDUDc0MmlaTldWS3Zr?=
 =?utf-8?B?RGtjMm1oNXNkTEZHVDJmTjlNMXVGWkFSa08vdTVIMThhMkZvR281S3Z1RFhu?=
 =?utf-8?B?aVcwZ3BicEFZakdqSHZHZTVieUZSM2RBZU1sMDRERGE5UjlCcXVjanpIdThT?=
 =?utf-8?B?QUZiTXNXOVhkQWt1aE14V0lPRXFacXBxZDNydHZ2RzRxZnJBSER1OUNra2dt?=
 =?utf-8?B?eGhrVkdPdjhGT2JEZFBGUXR2WERSbWVZN05LbVhxZm85bDA4elMwMmI2Y0VC?=
 =?utf-8?B?cm5MdCtHUm1wTTN1MHd1bDNlei83blBWTDFCR09QZGE1RjFxTldSaG12Z2lD?=
 =?utf-8?B?THhPekMrbFpEODRXTElvUWRYVndSUjZWZ3NXYUgxMTBBcnhnZWxTWXUxanlx?=
 =?utf-8?B?MXJmc0pkaU9ydXBZNENiR2tOZWhIVGFYRVljMmdSVy9zZW14L2xJeGNNTjRs?=
 =?utf-8?B?bzFtc1VBeUV3OFJ0WmZyNmFIM0tnL08zSEgvZWZ4UWZwSXZBcEpHYjllT1RU?=
 =?utf-8?B?VDAvcEVsWHp6OCtJS1ZEckdseDhzNExBZGNaTkUxbldkbmN6RUpXdXUvV1Az?=
 =?utf-8?B?WTVjUTE3TStjOGRnSllVOXZqT1ZoMW90MFBQZjhYVXNBTFE0cHl5eURGaUww?=
 =?utf-8?B?Z2lEQWNreFpPNjFwZmJQQlF4YzFoV0JsQUdJbHV1QXFlTnloRWoxblQzTVg5?=
 =?utf-8?B?RzMvUTJpYk5mR1R0aitsclA2VHNtSVlUc2lCNlgyc1hxdlVJMklMYjd5YTJO?=
 =?utf-8?B?amNPbnhJRTcxdS96KzJZZzlXcGlXTXc5MmpEaFl0VkhyT0k5TEtOUDB0RnhJ?=
 =?utf-8?B?ODZHT3IvcWwzWGdWWk5lSWhNUWUrVnZ4MG9INHRWR0k1REwxeGpOUG05aDh4?=
 =?utf-8?B?eHBuMEdrdFJoZWhOOTkzM3V5ZUtyZU1IQXJNMjFISWtubWZWMFhHSnFsWkpq?=
 =?utf-8?B?eUdRSFR3RkRoVkVoKzAyYlFZOHhMc3BaWDlURmFGekpnKzhMeE5BM1c0bGhm?=
 =?utf-8?B?eTJtOVM2SnorSCtEWjNiY2QrWGx3WDJ2V2xqa3F6MnVtaXc5bElvWVBMQzV5?=
 =?utf-8?B?bnhYaTBZWS9rUWFqRDN4eFdsMHJhUzhqRVhLZzhSTThrZGQramgvWmNHUXE3?=
 =?utf-8?B?ZUtCVFgwRGc0NFFzVHkyUXM5a2JJUjBSNlBrVWdkWllTT08wREt2NWRkcVE4?=
 =?utf-8?B?VGNLRE5CUVNYblRzNXJEbGY1eEV2T25aWnJoYjczUEVkSnQ1WXhCT2RuNlRt?=
 =?utf-8?B?andFZ0N0SVZ5WHR0UENjTWRtQWhQSlNWYzQ2S2V0SlhoV2lDV3ZCcWFONjJP?=
 =?utf-8?B?TzlBU2hNSU9sN0NIaVdXSTRZQzdyZ2I0dEZydkFwL2lJdm5ZK2Mrell4NFRx?=
 =?utf-8?B?QW54aTFhT2xvZ2pRRGlzTzhYaXhjOUF2ZmhHL1hrNWMxNzd0UEZvdWZEL1Zw?=
 =?utf-8?B?QnlIVDk1bFJRYUhJNER0QzlzRG5abFBPYnF1MEFScktPaVRyYVpWNFF6LzJZ?=
 =?utf-8?B?U2hGbWV3aXhhNTJIMGx5ai83UTdBbjIvckdxbzhxS3VudzRXRWZFaUV4Ujlj?=
 =?utf-8?B?UFFvek9BOXNzODMxN1ZNdng4VUxsWUJXaW5KUWkvMXA5bmtBRDZucDAxTXNs?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FA851B95115FA45ABB5EBC48E604FD7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e8bb4f2-0399-4343-f38c-08daddc128f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 10:51:31.1602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eaYu/UGA+KVczHBtyC1g/fwMqkojxfiIdT2UdTZN/14YQnlPkIIkr6eDTvmzihmlaaC3j/AiC+YSTrIL9PLUbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4873
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBrdm1fdW5tYXBfZ2ZuX3JhbmdlKCkgbmVlZHMgdG8ga25vdyB0aGUgcmVhc29u
IG9mIHRoZSBjYWxsYmFjayBmb3IgVERYLg0KPiBtbXUgbm90aWZpZXIsIHNldCBtZW1hdHRyIGlv
Y3RsIG9yIHJlc3RyaWN0ZWRtZW0gbm90aWZpZXIuICBCYXNlZCBvbiB0aGUNCj4gcmVhc29uLCBU
RFggY2hhbmdlcyB0aGUgYmVoYXZpb3IuICBGb3IgbW11IG5vdGlmaWVyLCBpdCdzIHRoZSBvcGVy
YXRpb24gb24NCj4gc2hhcmVkIG1lbW9yeSBzbG90IHRvIHphcCBzaGFyZWQgUFRFLiAgRm9yIHNl
dCBtZW1hdHRyLCBwcml2YXRlPC0+c2hhcmVkDQo+IGNvbnZlcnNpb24sIHphcCB0aGUgb3JpZ2lu
YWwgUFRFLiAgRm9yIHJlc3RyaWN0ZWRtZW0sIGl0J3MgYSBoaW50IHRoYXQgVERYDQo+IGNhbiBp
Z25vcmUuDQoNCkNvdWxkIHlvdSBlbGFib3JhdGUgd2h5IHJlc3RyaWN0ZWQgbWVtZmQgbm90aWZp
ZXIgY2FuIGJlIGlnbm9yZWQ/IElJVUMgaWYNCnVzZXJzcGFjZSBwdW5jaCBhIGhvbGUsIHRoZSBw
YWdlcyB3aXRoaW4gdGhlIGhvbGUgd2lsbCBiZSBkZS1hbGxvY2F0ZWQuICBTbyB3aHkNCmNhbiBz
dWNoIG5vdGlmaWVyIGJlIGlnbm9yZWQ/DQoNCkJ0dywgSSB0aGluayB0aGlzIHBhdGNoIHNob3Vs
ZCBiZSBqdXN0IG1lcmdlZCB0byB0aGUgcGF0Y2ggd2hpY2ggY29uc3VtZXMgdGhvc2UNCmZsYWdz
IChjaGVja2VkIGl0IGlzIG5leHQgcGF0Y2gpLiAgSXQncyBlYXNpZXIgdG8gcmV2aWV3IHdoZW4g
cHV0dGluZyB0aGVtDQp0b2dldGhlci4NCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSXNha3UgWWFt
YWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbT4NCj4gLS0tDQo+ICBpbmNsdWRlL2xpbnV4
L2t2bV9ob3N0LmggfCA4ICsrKysrKystDQo+ICB2aXJ0L2t2bS9rdm1fbWFpbi5jICAgICAgfCA1
ICsrKystDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oIGIvaW5jbHVk
ZS9saW51eC9rdm1faG9zdC5oDQo+IGluZGV4IDgzOWQ5OGQ1NjYzMi4uYjY1ODgwM2VhMmM3IDEw
MDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgNCj4gKysrIGIvaW5jbHVkZS9s
aW51eC9rdm1faG9zdC5oDQo+IEBAIC0yNDcsMTIgKzI0NywxOCBAQCBpbnQga3ZtX2FzeW5jX3Bm
X3dha2V1cF9hbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4gIA0KPiAgDQo+ICAjaWYgZGVm
aW5lZChLVk1fQVJDSF9XQU5UX01NVV9OT1RJRklFUikgfHwgZGVmaW5lZChDT05GSUdfSEFWRV9L
Vk1fUkVTVFJJQ1RFRF9NRU0pDQo+ICsjZGVmaW5lIEtWTV9HRk5fUkFOR0VfRkxBR1NfUkVTVFJJ
Q1RFRF9NRU0JQklUKDApDQo+ICsjZGVmaW5lIEtWTV9HRk5fUkFOR0VfRkxBR1NfU0VUX01FTV9B
VFRSCUJJVCgxKQ0KPiAgc3RydWN0IGt2bV9nZm5fcmFuZ2Ugew0KPiAgCXN0cnVjdCBrdm1fbWVt
b3J5X3Nsb3QgKnNsb3Q7DQo+ICAJZ2ZuX3Qgc3RhcnQ7DQo+ICAJZ2ZuX3QgZW5kOw0KPiAtCXB0
ZV90IHB0ZTsNCj4gKwl1bmlvbiB7DQo+ICsJCXB0ZV90IHB0ZTsNCj4gKwkJaW50IGF0dHI7DQo+
ICsJfTsNCg0KYXR0cmlidXRlIGlzIHU2NCBpbiBDaGFvJ3Mgc2VyaWVzLg0KDQo+ICAJYm9vbCBt
YXlfYmxvY2s7DQo+ICsJdW5zaWduZWQgaW50IGZsYWdzOw0KPiAgfTsNCg0K
