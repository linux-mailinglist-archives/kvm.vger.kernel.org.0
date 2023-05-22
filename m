Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD71170CEFA
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbjEWAKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbjEVXaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 19:30:07 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21399138;
        Mon, 22 May 2023 16:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684797983; x=1716333983;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tYOY4i2ti9Td7R0B50ytIYcfm61ey/K3F0sVwbacHoI=;
  b=R6ceqrWm2YyioMZj2CU2KOo0A1leV8vUe6oMC3BaClDQwTL0Ra9lXnOh
   0RszJlFAo4aTG73gyLPSuF8MPTKlJSV0TfA5amp+/1/f7yzC63hVVxSC+
   DVFOTOij330Bbs7uo/umz4vi1EfeXE2Et/mCqGiMhrNe+qK7p/la42zbh
   aeROSozT5s/sQNIt4LWAEqgZmNb/2ht1T2S1a2c+EeBar8Cf40q4FZSI6
   L4GAci6WDiD3+77tu3IRxeQqqbBcoXZWP9hd6V4tI1jx3XaXxzg7eyKyf
   7JJci9so3ixYDTsDn06ke/3ssd8zDkaMTJeaPKlYO/vhuKsnpXntSSz5G
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="353097155"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="353097155"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 16:26:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="773547592"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="773547592"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2023 16:26:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:26:22 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:26:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 16:26:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 16:26:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flzyIK84fUdCEzZlV+v35YDDm+tNiE7WpkxJCLP2QYws0+3LkvfbE/kr0i5uMndYwBJ184t5tQLmPNQ+mN5NkMejyXqLwU+YtfBIHYlboud4MFo/oK+VcMWuv43Cgvv4X8Z9UUZPGZFOeqbhWl827WWhHf184oca1rAEeuEu1h8t5UkrDns7dWkWu4SdqtdwlgK5W0p1+OQ2j3CYBTFU11L0meiCxPCSGaAye64rC106e/xmrHb5gF51ZmdMw9lgDXGHEZ42QoOgiGwFi0PjCfy3r60lNXDMGn094v+kRxAzUlzoXgKtkXfL/jzdVg2++V5Us9iTiZIgtLOrbmg62A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tYOY4i2ti9Td7R0B50ytIYcfm61ey/K3F0sVwbacHoI=;
 b=aT8G4C4r3WZiO5Om33ol3fGwtE9YvmIiFkGKYOZ5I6vKxWURgNnUFf1TPMxpEUgwFMeBmKmiHnbFdpxpBJ6hcLhIQLr1aAqTaiD6NwnVaBQDyQGPAH8I5torXkAb5OJchNMxfJoBDdbnoukodzoNzVXGbmdCK0HKwIYDqmpaP9gbvbcedJSD8bUwbf6U9qwxfMvgTRmyruUJ33Ac2ej9JxS9xXsK1x8yzPN62QOMXN8uIAwvS2szqNNDCguxcGMWrsmUOwx16Z3XaBrhHNpsY5hQMwJmpCq9a0vaLkovKw0lyVUxD+Os3MFy9ejCqbfQrypojbDSOAZRPheCTjWpuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5367.namprd11.prod.outlook.com (2603:10b6:208:318::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 23:26:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 23:26:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 16/18] x86/virt: KVM: Move "disable SVM" helper into
 KVM SVM
Thread-Topic: [PATCH v3 16/18] x86/virt: KVM: Move "disable SVM" helper into
 KVM SVM
Thread-Index: AQHZhSyeEH78Bz59FEaM9GhLuyG85a9m/zyA
Date:   Mon, 22 May 2023 23:26:13 +0000
Message-ID: <b68a28170c774a51ea108c15dd124b6754d6128e.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-17-seanjc@google.com>
In-Reply-To: <20230512235026.808058-17-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5367:EE_
x-ms-office365-filtering-correlation-id: cf9295db-0527-4ace-510a-08db5b1bef1f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qpE6wPSqiKefwwnpruwchhIfwIrq0vqluDoK57ce+TwB6z+bZw1LZBZ1p2LgQHqrf+71OtereHbyOlHDWoOlFcd83G7A4103XL9QDj4lV3JxqyFF3n6OV/B6wuypLpEKDtT5G6GjLSYkhde3Ceez/Zm7Dq7FS0Z0Q4LXVhXfdJebiN5gFOwY/k9OMIE1cDNzwwEM0JJE2TTo3uNRJeGpPzBX+X/Ut+DmG9mAwNRu4IVHeXSrIssIqPKme2vAiqx9vFSWQE5yMf2p3VOLBHt5BTlLvm2/njkTKFSuahO07EjjJLwisn7pIpdW5nqYheQEMPS0RCKpji7gTvOX2nyeedwkaB5Wl7d29na2RqhlVRqizoThhNRyzRrYgDOQ/yHYNZFiHU0SB6lhaRZUKh1gsQlusDzdIaR060WVakBdcYHPeqewZNVGAZyVuKiLzlWHDLMO3YI9k6jlACTfWSLhZXstDhE4H4NHgscgA0idX6S2zUizEZ+oDH0r0d72HolTZ9hN9iKCME73cQqhlEAfytU5vFo7RL0Md2k/xcX/zrgb0hqbz1B5yy68rpF2F6dQ0aYjAjXEAy2V1x1GpcoFeWBMOUy52exT5go6/3qDHTS7qYsKgWFspHTkGTFC0H45
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199021)(2906002)(5660300002)(83380400001)(8676002)(8936002)(91956017)(76116006)(66946007)(64756008)(66556008)(36756003)(66476007)(4326008)(54906003)(110136005)(316002)(478600001)(41300700001)(71200400001)(66446008)(86362001)(2616005)(122000001)(82960400001)(26005)(6506007)(6512007)(186003)(6486002)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnprUXJIeXRZNCtncVAxTUFkUnltTjRYVEpGSDFzeGhSOTRockY5akdSYzdC?=
 =?utf-8?B?WDJ6aXFnenE1UldnRHZMVkF2cFNrT0NRemxFQ3N6SDNjKzJjWFc2ZlY0T1N6?=
 =?utf-8?B?aWVEcmRmUFFoRVlrUHFIWGptVHhTZmJMQ1M0N0Z4VDYxY0c0VmZNdlJ4NVNU?=
 =?utf-8?B?MXZkSENSL1pzYkRRUjlvRWxvM0JSdCtFbVdLYjFJeldrZFBERENtS3hpNkph?=
 =?utf-8?B?NkZZa2hJSGQxc0ZWOTdmMzRkL2FpK2p1dXZVTEkvUkZvbi9EbjVWbTJnOGk0?=
 =?utf-8?B?UFNnVHNVeWk0VHN5RCs0eG4zTE9ib0duQUFKMVhNVEZ4Si82dG9oa0FQQ1o2?=
 =?utf-8?B?WFh5UkxOWFpyakk5VHgwVnVKWTM2M05lV0dweVJZQnJuYTA4QjYyaGlzZ3Fy?=
 =?utf-8?B?MDBvWU1rbW9kT0ptd1lURytYMExFWno1Q0JQbjlTNkhBU2kyQ1Nod2ZzWXAz?=
 =?utf-8?B?eVdMWThiUWJFYjdhbkVhS1lkdnFtWjhnRDVEdnJxM3lEUUNHNU5kRUp2V1dk?=
 =?utf-8?B?OHNmMjNEZEk0elZ0Zk1HWW5mUGtYa0h1U21TR0czN1Z4Z3Z3azdKZnBrOWJx?=
 =?utf-8?B?OUlrYS82N3pybVBoSEprMlhVTzZtM0hkd3BjN0dQam0xdnpvYW1qM3dRS3o0?=
 =?utf-8?B?RDlyTDlYa01OMkVMNExzNjBLRCtjaEsrV0RnSHlmeGs1VEdYMFRvS1FCVkE0?=
 =?utf-8?B?a1p4ZlRzb2wzYm1weWlRLzRibitEMFI2cG5jdExqbjZCejBidnQ4QTQ2UWll?=
 =?utf-8?B?b1hVU2JRZ0V4NWQyNkNEdEtBbG1icE92bWx4QyswOVAwYW1ZVzVFMFJRMjZO?=
 =?utf-8?B?eGp2b3MycGpIditqNkg3c2RiOWphWUdHVXlqbExvbXlsNDEwZ05JYVRQd3kr?=
 =?utf-8?B?OUNlaExyMXczYytTbi83VVN1VDRyQWhsSWJ4QjJBYllGTGhkczBkNmlGUUNp?=
 =?utf-8?B?R3kxREt0TlgzTGtEcDc4OStCTk1JYlVWSnc0YnhKVFdxN2wyZ2RYLzZLSlBy?=
 =?utf-8?B?N2lpNlJ2YWdmdmxsSkxwdlpKQ2JKUnU5UUFzaTJHZjdwQy9lbER2UVZiUjBT?=
 =?utf-8?B?YTF5M0Z6bHgrb3Vpc2FWK29BRVlVN2tISU4xNDJwZXQybWUybGFNbEtDcUZh?=
 =?utf-8?B?aUowOWZzeHRnQWNCVXFoQzNCYzBCWXltUlNCekt4Y3VabUxoeTVGUVI1TVY4?=
 =?utf-8?B?ZjVPZ2ZVM1dPRHhIMjNtWHZRck03b3pvTGVNMW1EOWh0a2JFT0JBU0k4M0Jl?=
 =?utf-8?B?aGJ1bDQyNlEyTTU5UVZ6MWFibUNSWnVNdU90UHRnZTBvRFNDZ0tFY2l6T0xz?=
 =?utf-8?B?dCtyTlFnOXgza2NCenRkcUFKUmRLVDk5MDVKckhTY1psTFhXUjlzZ3pWbThO?=
 =?utf-8?B?RUc4aXhUV1JlWnFVcFVJNlFBQmkzSlM3YzN6N0ZXVkUwcHFpMHdVbUVkcklv?=
 =?utf-8?B?MG1acDlWNzNpYWk1aWxvUE9SZEhEN2gzQmJqQW5jaHhOQWFGMlFZamRndjQ5?=
 =?utf-8?B?UVQ2cVJOY3cyUWpqSmVVVEp3U05DQXFqTFg3OHRyQTBQclJENTRFblBKZWFs?=
 =?utf-8?B?MmpsUVZ5a2s2VVFTdkxoM3ZwTEs4dER6c3Q3Ri9EL1hpV0JhMjdLc2FTK2Zn?=
 =?utf-8?B?M2I4RHRhTFdJMCtKZ01KQ0hOK0F5S05LM1Jpa2toR0M3M21LcVJtb0h4M3BY?=
 =?utf-8?B?VkVmd1JCeVZhUFpFTE5vUld6WTZodUVuL0FhRElna2ZmTFpLSG8xQW1XQ2th?=
 =?utf-8?B?bFF1SFV6NFZHVHFnSDVmZTVjV3JVNXMyWVVhT09nbTFiNHR3SzBFSmZENG9x?=
 =?utf-8?B?WU1lZU5nSUJEVEtWNkNScit5SlZFMkQwaXJwNElveTFvbGxyRUdyWnRWdm5a?=
 =?utf-8?B?cVc4N0JBNkRvVXdwQkIrV2ZIN0JVR25vRUpabnY5cmJpZFNlV1RtTEZvN2gv?=
 =?utf-8?B?UHQ4WlYzYWtKTUswNWRZZVRiQVlXY0kwcnpKbHdsQ0VsalplbTcxZFZKT3JH?=
 =?utf-8?B?akdwTXM2WTByeXZBRFA1d0w2dkJxY3U1cHd1VUIrRDIzMUlsQjZGTm9wbnhu?=
 =?utf-8?B?SEZ0ZjFPbGdKU1dCaENmN2R6WFFGazEwRUN3U2F5UDQzS0VUZzJhc0RoczYv?=
 =?utf-8?B?dGd0QS9YTWRxUmZEWTBZcFZNUlJ2RUtzQWhLNG1IZTBHVXZhdEV3V3ppUnRi?=
 =?utf-8?B?Z2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DC5C7741911334B83F75320DB917284@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf9295db-0527-4ace-510a-08db5b1bef1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 23:26:13.6755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rr6L/fRmMlz+cc+q2KmuNGHByY+COlp1ab1wOgXg/qq+2zt7nFZmOGl4nCoOuIyUttQ75Anv62h0qvOyMfahMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5367
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

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNb3ZlIGNwdV9zdm1fZGlzYWJsZSgpIGludG8gS1ZNIHByb3BlciBub3cgdGhhdCBh
bGwgaGFyZHdhcmUNCj4gdmlydHVhbGl6YXRpb24gbWFuYWdlbWVudCBpcyByb3V0ZWQgdGhyb3Vn
aCBLVk0uICBSZW1vdmUgdGhlIG5vdy1lbXB0eQ0KPiB2aXJ0ZXh0LmguDQo+IA0KPiBObyBmdW5j
dGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0
b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxr
YWkuaHVhbmdAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vdmly
dGV4dC5oIHwgNTAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgYXJjaC94
ODYva3ZtL3N2bS9zdm0uYyAgICAgICAgIHwgMjggKysrKysrKysrKysrKysrKystLQ0KPiAgMiBm
aWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCA1MyBkZWxldGlvbnMoLSkNCj4gIGRlbGV0
ZSBtb2RlIDEwMDY0NCBhcmNoL3g4Ni9pbmNsdWRlL2FzbS92aXJ0ZXh0LmgNCj4gDQo+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS92aXJ0ZXh0LmggYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS92aXJ0ZXh0LmgNCj4gZGVsZXRlZCBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDYzMjU3
NWUyNTdkOC4uMDAwMDAwMDAwMDAwDQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3ZpcnRl
eHQuaA0KPiArKysgL2Rldi9udWxsDQo+IEBAIC0xLDUwICswLDAgQEANCj4gLS8qIFNQRFgtTGlj
ZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkgKi8NCj4gLS8qIENQVSB2aXJ0dWFsaXphdGlv
biBleHRlbnNpb25zIGhhbmRsaW5nDQo+IC0gKg0KPiAtICogVGhpcyBzaG91bGQgY2FycnkgdGhl
IGNvZGUgZm9yIGhhbmRsaW5nIENQVSB2aXJ0dWFsaXphdGlvbiBleHRlbnNpb25zDQo+IC0gKiB0
aGF0IG5lZWRzIHRvIGxpdmUgaW4gdGhlIGtlcm5lbCBjb3JlLg0KPiAtICoNCj4gLSAqIEF1dGhv
cjogRWR1YXJkbyBIYWJrb3N0IDxlaGFia29zdEByZWRoYXQuY29tPg0KPiAtICoNCj4gLSAqIENv
cHlyaWdodCAoQykgMjAwOCwgUmVkIEhhdCBJbmMuDQo+IC0gKg0KPiAtICogQ29udGFpbnMgY29k
ZSBmcm9tIEtWTSwgQ29weXJpZ2h0IChDKSAyMDA2IFF1bXJhbmV0LCBJbmMuDQo+IC0gKi8NCj4g
LSNpZm5kZWYgX0FTTV9YODZfVklSVEVYX0gNCj4gLSNkZWZpbmUgX0FTTV9YODZfVklSVEVYX0gN
Cj4gLQ0KPiAtI2luY2x1ZGUgPGFzbS9wcm9jZXNzb3IuaD4NCj4gLQ0KPiAtI2luY2x1ZGUgPGFz
bS92bXguaD4NCj4gLSNpbmNsdWRlIDxhc20vc3ZtLmg+DQo+IC0jaW5jbHVkZSA8YXNtL3RsYmZs
dXNoLmg+DQo+IC0NCj4gLS8qDQo+IC0gKiBTVk0gZnVuY3Rpb25zOg0KPiAtICovDQo+IC0vKiog
RGlzYWJsZSBTVk0gb24gdGhlIGN1cnJlbnQgQ1BVDQo+IC0gKi8NCj4gLXN0YXRpYyBpbmxpbmUg
dm9pZCBjcHVfc3ZtX2Rpc2FibGUodm9pZCkNCj4gLXsNCj4gLQl1aW50NjRfdCBlZmVyOw0KPiAt
DQo+IC0Jd3Jtc3JsKE1TUl9WTV9IU0FWRV9QQSwgMCk7DQo+IC0JcmRtc3JsKE1TUl9FRkVSLCBl
ZmVyKTsNCj4gLQlpZiAoZWZlciAmIEVGRVJfU1ZNRSkgew0KPiAtCQkvKg0KPiAtCQkgKiBGb3Jj
ZSBHSUY9MSBwcmlvciB0byBkaXNhYmxpbmcgU1ZNIHRvIGVuc3VyZSBJTklUIGFuZCBOTUkNCj4g
LQkJICogYXJlbid0IGJsb2NrZWQsIGUuZy4gaWYgYSBmYXRhbCBlcnJvciBvY2N1cnJlZCBiZXR3
ZWVuIENMR0kNCj4gLQkJICogYW5kIFNUR0kuICBOb3RlLCBTVEdJIG1heSAjVUQgaWYgU1ZNIGlz
IGRpc2FibGVkIGZyb20gTk1JDQo+IC0JCSAqIGNvbnRleHQgYmV0d2VlbiByZWFkaW5nIEVGRVIg
YW5kIGV4ZWN1dGluZyBTVEdJLiAgSW4gdGhhdA0KPiAtCQkgKiBjYXNlLCBHSUYgbXVzdCBhbHJl
YWR5IGJlIHNldCwgb3RoZXJ3aXNlIHRoZSBOTUkgd291bGQgaGF2ZQ0KPiAtCQkgKiBiZWVuIGJs
b2NrZWQsIHNvIGp1c3QgZWF0IHRoZSBmYXVsdC4NCj4gLQkJICovDQo+IC0JCWFzbV92b2xhdGls
ZV9nb3RvKCIxOiBzdGdpXG5cdCINCj4gLQkJCQkgIF9BU01fRVhUQUJMRSgxYiwgJWxbZmF1bHRd
KQ0KPiAtCQkJCSAgOjo6ICJtZW1vcnkiIDogZmF1bHQpOw0KPiAtZmF1bHQ6DQo+IC0JCXdybXNy
bChNU1JfRUZFUiwgZWZlciAmIH5FRkVSX1NWTUUpOw0KPiAtCX0NCj4gLX0NCj4gLQ0KPiAtI2Vu
ZGlmIC8qIF9BU01fWDg2X1ZJUlRFWF9IICovDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0v
c3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiBpbmRleCBjZjVmMzg4MDc1MWIu
LjJjYzE5NWQ5NWQzMiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiAr
KysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+IEBAIC00MSw3ICs0MSw2IEBADQo+ICAjaW5j
bHVkZSA8YXNtL3JlYm9vdC5oPg0KPiAgI2luY2x1ZGUgPGFzbS9mcHUvYXBpLmg+DQo+ICANCj4g
LSNpbmNsdWRlIDxhc20vdmlydGV4dC5oPg0KPiAgI2luY2x1ZGUgInRyYWNlLmgiDQo+ICANCj4g
ICNpbmNsdWRlICJzdm0uaCINCj4gQEAgLTU4Nyw5ICs1ODYsMzIgQEAgdm9pZCBfX3N2bV93cml0
ZV90c2NfbXVsdGlwbGllcih1NjQgbXVsdGlwbGllcikNCj4gIAlwcmVlbXB0X2VuYWJsZSgpOw0K
PiAgfQ0KPiAgDQo+ICtzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2NwdV9zdm1fZGlzYWJsZSh2b2lk
KQ0KPiArew0KPiArCXVpbnQ2NF90IGVmZXI7DQo+ICsNCj4gKwl3cm1zcmwoTVNSX1ZNX0hTQVZF
X1BBLCAwKTsNCj4gKwlyZG1zcmwoTVNSX0VGRVIsIGVmZXIpOw0KPiArCWlmIChlZmVyICYgRUZF
Ul9TVk1FKSB7DQo+ICsJCS8qDQo+ICsJCSAqIEZvcmNlIEdJRj0xIHByaW9yIHRvIGRpc2FibGlu
ZyBTVk0gdG8gZW5zdXJlIElOSVQgYW5kIE5NSQ0KPiArCQkgKiBhcmVuJ3QgYmxvY2tlZCwgZS5n
LiBpZiBhIGZhdGFsIGVycm9yIG9jY3VycmVkIGJldHdlZW4gQ0xHSQ0KPiArCQkgKiBhbmQgU1RH
SS4gIE5vdGUsIFNUR0kgbWF5ICNVRCBpZiBTVk0gaXMgZGlzYWJsZWQgZnJvbSBOTUkNCj4gKwkJ
ICogY29udGV4dCBiZXR3ZWVuIHJlYWRpbmcgRUZFUiBhbmQgZXhlY3V0aW5nIFNUR0kuICBJbiB0
aGF0DQo+ICsJCSAqIGNhc2UsIEdJRiBtdXN0IGFscmVhZHkgYmUgc2V0LCBvdGhlcndpc2UgdGhl
IE5NSSB3b3VsZCBoYXZlDQo+ICsJCSAqIGJlZW4gYmxvY2tlZCwgc28ganVzdCBlYXQgdGhlIGZh
dWx0Lg0KPiArCQkgKi8NCj4gKwkJYXNtX3ZvbGF0aWxlX2dvdG8oIjE6IHN0Z2lcblx0Ig0KPiAr
CQkJCSAgX0FTTV9FWFRBQkxFKDFiLCAlbFtmYXVsdF0pDQo+ICsJCQkJICA6OjogIm1lbW9yeSIg
OiBmYXVsdCk7DQo+ICtmYXVsdDoNCj4gKwkJd3Jtc3JsKE1TUl9FRkVSLCBlZmVyICYgfkVGRVJf
U1ZNRSk7DQo+ICsJfQ0KPiArfQ0KPiArDQo+ICBzdGF0aWMgdm9pZCBzdm1fZW1lcmdlbmN5X2Rp
c2FibGUodm9pZCkNCj4gIHsNCj4gLQljcHVfc3ZtX2Rpc2FibGUoKTsNCj4gKwlrdm1fY3B1X3N2
bV9kaXNhYmxlKCk7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyB2b2lkIHN2bV9oYXJkd2FyZV9kaXNh
YmxlKHZvaWQpDQo+IEBAIC01OTgsNyArNjIwLDcgQEAgc3RhdGljIHZvaWQgc3ZtX2hhcmR3YXJl
X2Rpc2FibGUodm9pZCkNCj4gIAlpZiAodHNjX3NjYWxpbmcpDQo+ICAJCV9fc3ZtX3dyaXRlX3Rz
Y19tdWx0aXBsaWVyKFNWTV9UU0NfUkFUSU9fREVGQVVMVCk7DQo+ICANCj4gLQljcHVfc3ZtX2Rp
c2FibGUoKTsNCj4gKwlrdm1fY3B1X3N2bV9kaXNhYmxlKCk7DQo+ICANCj4gIAlhbWRfcG11X2Rp
c2FibGVfdmlydCgpOw0KPiAgfQ0KPiAtLSANCj4gMi40MC4xLjYwNi5nYTRiMWIxMjhkNi1nb29n
DQo+IA0KDQo=
