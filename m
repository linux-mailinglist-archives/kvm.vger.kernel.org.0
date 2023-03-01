Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02116A647B
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 01:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCAAy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 19:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCAAyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 19:54:24 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A49F38016;
        Tue, 28 Feb 2023 16:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677632059; x=1709168059;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=B62h0xjADTup3yCrWF08rEOrNiDmc9g5zRl9buuZkvQ=;
  b=XrS+FVfC9DCPMve3RKwFGhx3g9zgBQd2wFHKec6AFfnoa1FmVTFWBOxj
   h48ASZWL2+A99aADYC18yBm1KMYXIkthyx0Hob6V3GQag6s7eHbMyGSbR
   BLX+UgbdXceXSI4j4543i7+M92klKd1PzZJ2IbOpVxHNe2+uVPyG+nbq5
   5LPn1luCnjae7lp6xShIAQ2kc/esaZafq0/47feDrGXjI4fbrGOlmhr99
   qh05zrp3zDX7NrlDc+ht8qaL8dXpztz7+YrjR+Kv+PcOBTT3ug6J3vGFX
   6ZuxK1AY4Xto7vOC/KQLiTT7K/z09PPEwvz6NMNHfhcuavUdRIKtu4HyJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="322549840"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="322549840"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 16:54:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="674359256"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="674359256"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 28 Feb 2023 16:54:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 16:54:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Feb 2023 16:54:18 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 16:54:18 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 16:54:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOeInixKHJpLA4VKsLcO22meYY2hbFVRJn7iDITttNSsnxo+bzwG5/b4IJDUEQuu5MujsAOdDG5tUbxSctANEBCaL3i4IyYV6b07sK+cQSDw7rFwIEn07KdksFORPQ5yY6tGPeTrbnxHQsCHKn6pr7a+GN2ntarA5NTqw9bpNryazBSKVz3EzspxZRQFEm7OEuxOVpKX7zuOknSglqZj/4Z1gG0b6gaux67jSMtTmBoPeDmMDn1RlHFmrSQfg5kV/51U+ndoutj2rhrOtztlgrFWCuxXaFNoocArUlTHXrioiBKywJLoInh3A5g9fhBbyMZll7lXLr8sha32TyJkaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B62h0xjADTup3yCrWF08rEOrNiDmc9g5zRl9buuZkvQ=;
 b=PE0b3x/rUeun7e0TZ+O6jz94XvWVZCrm5mR23i7trLBtxp0HcHFFCQ2iuq4UPNI1Q3SpnHMB7qqLrqDyL9mThn/87YQBnwzpPsjGQcK94CS2dxOOTiJau4LO+zP7uN6xo483tBDy0LUGGjgadGa096PUH5tw8blDi53OSvNEi6EqQ21XL+bcSi8PRR5Sk/f6V5WrvcnybI93jdr9QFfE1dUjxhVnBeWKeX4/53OYuv1mJX23idJHTlCFS4aHQLIstICaRf698WkR+tcreo3CZIqJfOdWfscKU4BDJhfcsXiHYur8/HNgbT8jAagxNSCHfM4cecp170vNWxBBgQ8oSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB8092.namprd11.prod.outlook.com (2603:10b6:8:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Wed, 1 Mar
 2023 00:54:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6134.029; Wed, 1 Mar 2023
 00:54:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v11 017/113] KVM: Support KVM_CAP_MAX_VCPUS for
 KVM_ENABLE_CAP
Thread-Topic: [PATCH v11 017/113] KVM: Support KVM_CAP_MAX_VCPUS for
 KVM_ENABLE_CAP
Thread-Index: AQHZJqToZY0zv6U9WUWWlCjhFfl4aa6gfRqAgEMZzoCAAZsyAIAALX4AgAADyAA=
Date:   Wed, 1 Mar 2023 00:54:13 +0000
Message-ID: <93b21870e2b3218b0fd5cfcafda5908ee15bd447.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <01e061779b88ce4d32bbe483ed2bd3224cd8e330.1673539699.git.isaku.yamahata@intel.com>
         <5f9870acec07c47de5bab460c8c0d4a2c0db08fc.camel@intel.com>
         <20230227212605.GF4175971@ls.amr.corp.intel.com>
         <bdf8b2e1aa52ae8f4d5e2a6c92e0f8e426b97234.camel@intel.com>
         <20230301004038.GB3852341@ls.amr.corp.intel.com>
In-Reply-To: <20230301004038.GB3852341@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB8092:EE_
x-ms-office365-filtering-correlation-id: 57b27228-5993-40bf-cc9c-08db19ef79d5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YKOxaSrcuLf6db8fyyqvoWjIkShCKjA3dPajuzCvfT7qZx3k+JsVbn5+8bnJkKwOSC7GowB6I7jDy7Mcu4trh/iiFJjxdzFza3kO9dTOeuPjuEF8MJsoyRCUsxaXR2sD4WPHi5JSMBgn442f4VVqzkRsbw4t7fM5yfKEC+tsxxQDsBRSfGz7Diqyex4rnjJ8wGssgxyD0PvozQo0zGqMEfHnEtpeUEPWGPzVRdDvn3cl9qlTwj2mm1DLzzg37V3RIGL5uwyQPfDLGiriTtZvgCJLUtjt5NNKg6XCk7kFmoRj8CX6WTCpXTnGhM28WN2kwokOZYrXb9iCHUKQC6MXilXayF4qS177t1mOFOt7OUXI4TKRE4Yf+vOTlT4R4hmgAov8f17k8QHI8Qqx8uKeDVHLZRY/Rbqi0pYhzgide61pSUUpfvbNCDh8OuTOEgOf7hmwNv9C8/yE0XOyLikHBuGte2y3VHz3EgkNi8WLddMBERjmYkS9AtOB2AKoCPAgIjwXLi+dtcRoMZ+JwnnjwBs9My10+fuHZ6Ft6ll4a1Ta5I4R3msnysxSw46iYGb6aA7fVWEWO9MGWeH5TjxoZYYGD6nEFDLPRDK39ABKNbdZt+jEgx1wMy079SqCmbi7+l3qbObOk0bJNZkBQ03ph45lQ5aGKFJ0mp5PVdv2AyZaDyMoJPQHonPDZcSZIT0/zaeJJOxdYm8O/HTc1SJLCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(39860400002)(346002)(136003)(396003)(451199018)(36756003)(38070700005)(86362001)(66946007)(91956017)(8936002)(478600001)(41300700001)(6916009)(66446008)(64756008)(66556008)(4326008)(71200400001)(66476007)(2616005)(76116006)(8676002)(316002)(2906002)(54906003)(5660300002)(186003)(122000001)(26005)(82960400001)(6506007)(6512007)(38100700002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXlZRTNsaitodlpaRGdkR3dwL3Q3VSttUDBsVnBLVDRacGZHM0F3blFFK3Nv?=
 =?utf-8?B?MVoxeEloNWdWR09CcVAyMmN2Z0xXMVJvWWUvSDQzTWl2REhFODE5ckZ1S3lz?=
 =?utf-8?B?RnM4aDh1NXFwUWowOWRRUW9kQnIzNk9XQWJVdHNxK0FzLzJ1NHNkcytsWVNa?=
 =?utf-8?B?QUgzZlhJbnBUM1FGYVkvbHFaRlVxTGJ6K1BsVGRMUUoxLzM5VU1EUlQwU0Fq?=
 =?utf-8?B?TFdhNFh1U3pvcGU3aVh5UmdFUTdZWWc5LzdGN05Sa3V2SjkrMXc0L3g4dkl1?=
 =?utf-8?B?a29obkhQajhNQ3FNMGQ0VFhTaDg0cU1KWmEyMW5mMlg0MVkyTjFaY3hmTDV3?=
 =?utf-8?B?MHQyQlQzUm9FdENaUUZkZXljNGhVK3hyRWluV3ZaWElqZE44TjV3SHlaa1Ni?=
 =?utf-8?B?enNaV1cvZTZlZGxZOTM5VDJRbnJCcEZZS1VpbTlPUXBBanJOR0xvN2IwcUJh?=
 =?utf-8?B?eVRoaGJSY3lGVHVrWStoQUZzeGdZUitCVE0zb0RNWjJhYzNTOEZUQ3dvWi9n?=
 =?utf-8?B?amNTNUdaaDZ5dFhDNXA1TFFDbmhpeFlGL0FFL200aXFUdkkzQ0NQWXBRZ0Yy?=
 =?utf-8?B?VStibzdFSEE0czdSRkVSRUp4MmhFODk4cnZzTnRVbVJjRGtPMmlmb2dLcDl2?=
 =?utf-8?B?c0krNDhBT2x3c2w1Q0dhc0t5VTFjTmk3VE1OVVdBOE1jbmxFYUNvWi9LL3k0?=
 =?utf-8?B?YjVUWlRMR0tFK2pMYlBlaG4rS3VsTEFKUHgwUkZPUTFpazVyd0praTdRdHpD?=
 =?utf-8?B?bzhhV2hrY0NodlRvcmhaM3B0Ukk3NFZubjRJWUNyQngvQ0xvL3RPaTBQcTdu?=
 =?utf-8?B?eGE1MU5nRVpXMXZaRncyRGNtc3JRWlllWnFYQSt5LzVYbllidjg2bVB0a0Ro?=
 =?utf-8?B?K0UzOER1WjVmSGZHR3dWaytaVmFxYytWNWpaQTlKdzZiL20zb0plWWR4ZWc4?=
 =?utf-8?B?a2hHWktSL2RmZmQvL1RIMFdKOUVSdHBldXNKUDFaeE9LbW1wajlrY3l4TFdT?=
 =?utf-8?B?QnNBbm0xdWpjdzRoZTRsUWxaNExCTC9NZEp4ZVkybEl4MHN5OGRmcE1Id1lr?=
 =?utf-8?B?VVBEalU4bThrM3lOWGg3V2VDUGRONkJ1MFdmUUhkeXlISEtZblpQWnU2elB0?=
 =?utf-8?B?ekxiRGxic2puME56VmhVakMveDJNNlBIRS9uTG5Ca25LSllLQWdRUjZEZ1Zx?=
 =?utf-8?B?OUpDYkE2QXprTkEwckdIVTdadmd3UEZZa1UxSEJrbDgxZE12eEg1UGlxendJ?=
 =?utf-8?B?THhOVFNzMERxVEIzWU94bUpOVVE1RHZFNEIwNk1yRzRSeHFqcGZZL0tXZGh5?=
 =?utf-8?B?b3dtVmxDVmYwd29BUnZrSmdrdnB6NFR0OFU2ZDJJaS9EVk1iVXdqenA2SFRR?=
 =?utf-8?B?MlVJU3hZVVU0M2lpZXBjczUxOVFGYUp0Mit0S1oxc0hSa25GT1dOQlpxMlFF?=
 =?utf-8?B?N0IzdE5CNVRnS01jL1Q5SW0zWUd2WGZXNVVOVzdQaEh2VHNVV2RobXJnaWxq?=
 =?utf-8?B?TGlvTi9pRkxBak9CNVdlcVN2S253M2huY1NLc1RaSzBteHprUVgrRkZZQU9U?=
 =?utf-8?B?bXpleHlUdHJ4dmdDZWhucUwxcytTVEp3dzFCekMreU5qRklSVlFLMzB4Nmpq?=
 =?utf-8?B?T0RwZ2I3ZzMxTGREM20vOTR1MTBrMUk2clB1cXpVdXEvd3ljaWttOTIweVFH?=
 =?utf-8?B?NGYvRWpBT2ZyNERwYnpmaVZqY0t3NHdGY1FoOWgvS2tzVXZQdTZRaVNkd3RM?=
 =?utf-8?B?Z3AzTWxBL2lCaVlYNXhRZCtySE05U1FidmFLME80b1NxSzlwYW0rSkdiR1RS?=
 =?utf-8?B?RjBHaHlUMnFDQmhZWjhnc08vZlR3SUxvNHV1VGRkTEgvdkkvVmJLOXVBcnMy?=
 =?utf-8?B?QmJtdVhMV1d4YlRDNTJMeXBOc240MDJsaWVSMkZ4UndvZDdreWRHWjBCQmtR?=
 =?utf-8?B?MjNydFhKSEJCZDRaSjEzSVVSY3RhUmFWNHIrRTJwNmcxaGRMWmtZU0thU2R6?=
 =?utf-8?B?Q2RzaEZndlZLWVlGWU5KYUViSjJkaHRvMWZERTF2bW9zVXVzZkZlM2tSUS94?=
 =?utf-8?B?UGZHTXdvMmJBazVvUEh1aTZvVituZ0lnNzhCRjl0TWRrTzh3WGNzUmtQS0Jt?=
 =?utf-8?B?Y1V0TVNmU3VEYitobXBWVTFGYjJxQXhtRk54WUIramRDRXg0T2djRXJ1TlE0?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F6D5499F74D8C438099AEDC19763EF0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b27228-5993-40bf-cc9c-08db19ef79d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 00:54:13.4833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IXbBZ87+loXHcuK7NuPCp6OyT17GKRdwvnKvasKaDX/FnTVaPWGgI4SNqGTZh3w3o4e7OyimU17DCj91wDf6aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8092
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTI4IGF0IDE2OjQwIC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gVHVlLCBGZWIgMjgsIDIwMjMgYXQgMDk6NTc6NTBQTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gTW9uLCAyMDIzLTAy
LTI3IGF0IDEzOjI2IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToNCj4gPiA+ID4gPiBURFgg
YXR0ZXN0YXRpb24gaW5jbHVkZXMgdGhlIG1heGltdW0gbnVtYmVyIG9mIHZjcHUgdGhhdCB0aGUg
Z3Vlc3QgY2FuDQo+ID4gPiA+ID4gYWNjb21tb2RhdGUuIMKgDQo+ID4gPiA+ID4gDQo+ID4gPiA+
IA0KPiA+ID4gPiBJIGRvbid0IHVuZGVyc3RhbmQgd2h5ICJhdHRlc3RhdGlvbiIgaXMgdGhlIHJl
YXNvbiBoZXJlLsKgIExldCdzIHNheSBURFggaXMNCj4gPiA+ID4gdXNlZA0KPiA+ID4gPiB3L28g
YXR0ZXN0YXRpb24sIEkgZG9uJ3QgdGhpbmsgdGhpcyBwYXRjaCBjYW4gYmUgZGlzY2FyZGVkPw0K
PiA+ID4gPiANCj4gPiA+ID4gSU1ITyB0aGUgdHJ1ZSByZWFzb24gaXMgVERYIGhhcyBpdCdzIG93
biBjb250cm9sIG9mIG1heGltdW0gbnVtYmVyIG9mIHZjcHVzLA0KPiA+ID4gPiBpLmUuIGFza2lu
ZyB5b3UgdG8gc3BlY2lmeSB0aGUgdmFsdWUgd2hlbiBjcmVhdGluZyB0aGUgVEQuwqAgVGhlcmVm
b3JlLCB0aGUNCj4gPiA+ID4gY29uc3RhbnQgS1ZNX01BWF9WQ1BVUyBkb2Vzbid0IHdvcmsgZm9y
IFREWCBndWVzdCBhbnltb3JlLg0KPiA+ID4gDQo+ID4gPiBXaXRob3V0IFREWCBhdHRlc3RhdGlv
biwgdGhpcyBjYW4gYmUgZGlzY2FyZGVkLsKgIFRoZSBURCBpcyBjcmVhdGVkIHdpdGgNCj4gPiA+
IG1heF92Y3B1cz1LVk1fTUFYX1ZDUFVTIGJ5IGRlZmF1bHQuDQo+ID4gDQo+ID4gVGhpcyBwYXJz
ZXMgbGlrZTrCoA0KPiA+IA0KPiA+IElmIHdlIGhhdmUgYXR0ZXN0YXRpb24sIHRoZSBURCBjYW4g
YmUgY3JlYXRlZCB3aXRoIGEgdXNlci1zcGVjaWZpZWQgbm9uLWRlZmF1bHQNCj4gPiB2YWx1ZS4g
IE90aGVyd2lzZSwgdGhlIFREIGlzIGFsd2F5cyBjcmVhdGVkIHdpdGggZGVmYXVsdCB2YWx1ZS4N
Cj4gPiANCj4gPiBJdCBkb2Vzbid0IG1ha2Ugc2Vuc2UsIHJpZ2h0Pw0KPiA+IA0KPiA+IEJlY2F1
c2UgYXJjaGl0ZWN0dXJhbGx5IHdoZXRoZXIgVEQgY2FuIGJlIGNyZWF0ZWQgd2l0aCBhIHVzZXIg
c3BlY2lmaWVkIHZhbHVlDQo+ID4gZG9lc24ndCBkZXBlbmQgb24gYXR0ZXN0YXRpb24gYXQgYWxs
Lg0KPiANCj4gSSdtIG5vdCBzdXJlIGlmIEkgZ290IHlvdXIgcG9pbnQuDQo+IEV2ZW4gd2l0aG91
dCBhdHRlc3RhdGlvbiwgaXQncyBhbGxvd2VkIHRvIHNwZWNpZnkgbWF4IHZjcHVzLiAgIE5vdCAi
YWx3YXlzIi4NCj4gDQoNCkV4YWN0bHkuDQoNClNvICJhbGxvdyB0byBzcGVjaWZ5IG1heCB2Y3B1
cyIgaXNuJ3QgZHVlIHRvIGF0dGVzdGF0aW9uLCBhcyB5b3UgYWxzbyBzYWlkLiDCoA0KDQpUaGVu
IHdoeSB0aGlzIHBhdGNoIGlzIGR1ZSB0byAiVERYIGF0dGVzdGF0aW9uIGluY2x1ZGVzIHRoZSBt
YXhpbXVtIG51bWJlciBvZg0KdmNwdSB0aGF0IHRoZSBndWVzdCBjYW4gYWNjb21tb2RhdGUiPyAg
U2hvdWxkbid0IHRoZSByZWFzb24gYmUgIlREWA0KYXJjaGl0ZWN0dXJhbGx5IGhhcyBpdCdzIG93
biBjb250cm9sIG9mIG1heGltdW0gbnVtYmVyIG9mIHZjcHVzIiBhcyBJIG1lbnRpb25lZA0KaW4g
bXkgZmlyc3QgcmVwbHk/DQo=
