Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C1667D886
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 23:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbjAZWgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 17:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbjAZWge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 17:36:34 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7092BC671;
        Thu, 26 Jan 2023 14:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674772585; x=1706308585;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pINYfThcYoS/0gIEPggfJhILRf0jI2NtDQn7PPlr2L4=;
  b=kpJbhARJPTJg4ok6wkw/6BqBlX3d/AW+FF1pCqg8Pq31xK4JCwIdBTSU
   yuFO1d/MevHeNFtPimk4O1wjWcGCFoVkYd/TLzVyl8VyTqjtIDdDkDI77
   wNgN4lc0HrZauJATFrO8kS0j2jV6vBf31oWegQbiyu5d/8E8IS4eiU7Ne
   oGSVvAEVgsVFunQ6JZxeTvy3qhV5eUXleJpK475d1tj9nvSag15gBVMwb
   Eb76fdbrnurIX3Z7pNzvCEl1bCVaUBWgW6e+cVVywxBxBlzCcf+bUPb+i
   bFXodUULV5o3+QpMus9FE8cXwnmM04pLbRChlhAEB1UkLH0/OPx/8cGQx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="329098375"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="329098375"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 14:27:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="612985836"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="612985836"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 26 Jan 2023 14:27:57 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 26 Jan 2023 14:27:57 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 26 Jan 2023 14:27:57 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 26 Jan 2023 14:27:57 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 26 Jan 2023 14:27:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6lHDUnZ4JE2zRdOiMs0JEuHNNK0BKSn/VrFJkIkpJbwRrIFVjeCdc7OoqpRxRiw8Dm9MMnXorJcdvOIe3ThEt/9idpGZ5X8PpSFzaIVfZs/nd0m6Nk9aFWxn/sKZsjDJD8+iipbqM+S2Q1QXbVduxykhrPPGURFacvH3wicCDWcXvLzS5QVUqjrJF/wqMGKz/E3hUTFThB/tk9yKFEu8sg/S04yk7JyjtZ8xcfNerXYAQSIhO9Tr6kK32cUAipektiJs6PDONY86zsesPIEkexS6h9E1WZAYV945obwrxdVuyvWcMvpeW1QQJPeMHiE5rJMSqPo0vy6XQslItjT7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pINYfThcYoS/0gIEPggfJhILRf0jI2NtDQn7PPlr2L4=;
 b=B/zHYuyftlwSKXMTiAM4RrN/TJI6TQCLVGxQahkUgQIdDmlyelC7HO6qd+06eSqVs+RyWz2bRIuMZbGFuYu2VI3z69AKlkcLLDEVqpQErPqcWpXd8X9fX+PUoLKPNGieQCfKxespoE2RqbuDSI0ZQ7N6SsfbtHPi5QtUf522a4u3rE/8PeSxts+bvp5aNejui11yMg5X+K+l5a6fy3uheRFSy8Z27HMJlnl4G88E3aqdmeBKb27e2JfDYbuz+ol4bI6EMilHhXwNLezn83+fwzexswMviJbzNEXk+uATdB7uqJwGulP5elfgYBYUnq/ADJ0NyPmog1FzvxRF3KhUTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5348.namprd11.prod.outlook.com (2603:10b6:610:bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 22:27:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 22:27:53 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Index: AQHZJqOgR/AYJ+DUHUGfsmh5dZfuuq6cVDsAgAAiagCAAS3PgIAFJp+AgAA/zQCAABQhgIAAAWcAgAKFUoCAAETpAIAAVHGAgAAP1gCAACa5AIAABg4AgAFyH4CAAB7oAIADQFwAgAEJgQCABEVHAIAAbgUAgABAawCAAAtxgIAAB9IA
Date:   Thu, 26 Jan 2023 22:27:53 +0000
Message-ID: <d335eaba5b8235cfc4f8105352bc7fe916b5b309.camel@intel.com>
References: <Y8m34OEVBfL7Q4Ns@google.com>
         <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
         <Y8ndcGHUHQjHfbF9@google.com>
         <CALzav=d4vwHTnXP8wetA_Hqd3Tzc_NLp=3M-akwNSN1-ToL+Eg@mail.gmail.com>
         <Y8st2PjGDQ+Q0LlW@google.com>
         <3951e178bc38191074f5cccadc442212ff15c737.camel@intel.com>
         <Y87GzHrx8vxZLBEJ@google.com>
         <e5912f7d04ce7a27a68ce4328fc50ce594295c6c.camel@intel.com>
         <Y9K4Mnx/Je4j+RsD@google.com>
         <144de0bf7cc86dd7807f1b559c3269bccbb56317.camel@intel.com>
         <Y9L31cqsKvr4boGU@google.com>
In-Reply-To: <Y9L31cqsKvr4boGU@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5348:EE_
x-ms-office365-filtering-correlation-id: b3028c9e-4512-43bc-e2c6-08daffec90eb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PX1I9HapLTZ6ruaNQHRY7aYlAn+iZDKi+2HbMeV2wesCeJCLNiN7x1GnFq/YXjhzD4EbYm4JRNOJiuqk1o5sAZ2rQm68LVqmvGFwzNfHjwxwPK3Gb2QopAacOfVGimRjne35a44F2yFrnHG+xN4UPuYkQJyR7a1Vt9QS5SUgxg8gB9eM3xPMeSTPEhX4D9XBgFNb7Rh4hioO8L96OJB82UphJNmddJE0773IMNh2kofuTOfQ/MuMyYhxQU0AuQs+LErJH1oAZOCtGMS92JoCFnHBtUoppe7c/Tyvdj2Gs38fYPxFyh+oSJtk472MJEqbGB7VLO/jtsycbiKfqJlXjkVvYut+mW87tFh/EqWPDpkIba2HAPExjOFzZ8nq966s4n4ZQDjsqLKzqObO7cr1qur+OpkajLA+SV2HfbYt9VZNIDRvtbAc6FKg85OhDIwkD9gjpbsWaUHDDo19a3BcGfwF9GThTAqdmos2uQZQZ62k9zehAHWuJOFCu2ENSoVMfMjXamTNAH0CBvGnbzDh+h0SNzInJMxnhxfWFF3YFwJiy07ciXM4nSkNmJFOGGFIaU42J90xYg4D/YADSZzA0b3wFM1npJ7Kd0ki5VYHajA8OLlyUrX1l8bsNsP9qHKIKiBY9I/ZXurc0xQe5ZgLSZXBD/KVIh86cicDXsLJJiszfrSYzX0cLb7DcfuKRhIYM1zg+D7kDbccPeSpZUPTAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199018)(6486002)(186003)(26005)(6512007)(478600001)(71200400001)(2616005)(83380400001)(107886003)(316002)(54906003)(41300700001)(8676002)(38100700002)(122000001)(64756008)(82960400001)(6506007)(66446008)(86362001)(36756003)(5660300002)(91956017)(8936002)(4326008)(66946007)(38070700005)(6916009)(66556008)(76116006)(66476007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SExaeTdEaW9tOEJjYWgySVovcXFLWU9qU251bG9kVmVtakhGV0JyblBhbzZ1?=
 =?utf-8?B?dXZkNWJ2alJSR0xxTFY3dGtrMUN4TjJFcUIzdkpkSlNDZEloWFRkZUFOVFZD?=
 =?utf-8?B?NUhkR2FmVHF1d04vZ0xNSHo2MFZUWkxybElnT3NGSGlPdVJNNHRzVzAxTnJK?=
 =?utf-8?B?V0xCWVV3Z3NQeFdRQ0F6RXVzbkN6c09rR2FNTWhaYlI4NnZaUGVwSktGS1JY?=
 =?utf-8?B?cHNLcHo5TDA1RGxqK0MxWE9CRCsveEpsbTdxemRXTldRTnBIMEt2MTdOMjZW?=
 =?utf-8?B?cmFFUlJEdDNhVjBDZ1JmK25hZXNKc25pSlltdG1LZ2NNRVBEMExxMm5yRDd6?=
 =?utf-8?B?UGExT2ZNeGFFcEVzekVURU4xZ1ZVdUt0eWNKdXN2Uk1uVFBEanlja0VDTm1r?=
 =?utf-8?B?OGdYb2RBdlVHS1FQUmoySVZkdldSaWtkMDZzbHpUQzRyRi9mVHRiN1RSQjlR?=
 =?utf-8?B?cnpqT1c1WU5Gd0o1NEdtU0pabzB4cWR1azcrbTNMY2ladEhQVUw2cmpndGRl?=
 =?utf-8?B?VU1HdFphOXJqMGdhOWhQS0EvUHIrbUV4UDZhbjFhQXpGQ2FhTy90UmpFbGR1?=
 =?utf-8?B?WnFUTE5IUWduR0FTTjRRWS9ndEcxU3lvRFdDUlV1VWYyNit3L3NVV3B5MXBY?=
 =?utf-8?B?TDhkL2lJekVUNFpXN0N0ZW5pdVJ6UUpZc29YcXNTS29pL3gxTHViNmZ3Zkgx?=
 =?utf-8?B?Um80Z2tZaGlDcjkyTFFsVlJKejlzTzEra0grbGFXNUUzZENEa0RTdnFoVTQ0?=
 =?utf-8?B?blB2OXN4ek8rZkxkb3NTY1MrOStkZlJCUzVXQ3MwUlJnSE1WUnlOMFR1WFZ1?=
 =?utf-8?B?d2FmdkF3L251ZUd2cklua09naG5odlpGOGZuejBCTEg3VVFXOUpHaDA4eTc1?=
 =?utf-8?B?Mnh0cWlya1dHVnc2U09zYTdoRjcyY0d2T3l2TlhQczBmKzFZaHV5UFAzMWxn?=
 =?utf-8?B?ZitGMjF6RXFWQmk1WHFzTCt3anFXRlhGaktrWnI0VzhUN1VTellOdUFyamlm?=
 =?utf-8?B?Qk9zcXZjMU80bHN6ZzJEeFJqdmRnRlEzcDhnNnZJRWx1QWdIckpnUDNNdGho?=
 =?utf-8?B?NXQ1b3lCK01uUEc3T1BSRkswNjZMZFdhNlN2T0h0cldSK1ZUTngrZ0hUZ2M5?=
 =?utf-8?B?SWtPemhBNUU5Qm51STNxYjVKYitlbHFTa21kT1FzQktFWEZhOE5QK0R3cU8y?=
 =?utf-8?B?TUwydXVNTE1ISjVjWHRFbGhkK3RnOCtwMGQ1WnhiOW5CZ1Q5UkVGNXpBUG5K?=
 =?utf-8?B?M2UySW42YUpEN25qbjNDYlNHaTZHK3JsUjRPb0xUbDRjSVY1dWhJUWpCcVhr?=
 =?utf-8?B?ZmFETDM0ZzhONVY3NlczUkpITjFCQXRqN1dvelNORklmMGtFTU9RQUFFOTRH?=
 =?utf-8?B?M0RhUFZSVjdnem5wNlE1emVLaDYrRzF1Q2J6dU1mcWM2NkxzM3VCSkZlOEY4?=
 =?utf-8?B?SzNDYld4cFlCTzk3OEpIRHQrRGt6eVhhY0RoNmxmWVpQSnBNUGFsM1djbE1j?=
 =?utf-8?B?OUt6QXFMeHZmR1R6Wlk0UXFqdUcvM0EvVWhZdHZCT1JiMnowU0pTbUtmbzgx?=
 =?utf-8?B?RmRxUUw5c01pKzE0Nk9sZUwrU1RwMWszelYrcnZMRm9lVHFybUxzZmN5dDJs?=
 =?utf-8?B?UHZFSFNkQ1dVZW5OYzJYaHVwSFREUTBjRHM2TU1sQnVpRGVML0NlZ3ZlOENP?=
 =?utf-8?B?SFZqWW1BbnlHYloxRWJ1NGY5UDdZSytnOWdsVU5JQ3oxazVrSHk5aTd3ZzBl?=
 =?utf-8?B?d3RaZUkvV0pBb05qOE5mbHpQMGhoK0FYbk8yaWlTV1U1MTFDa1JoUzhYSURh?=
 =?utf-8?B?aS8vUXhLV2U2MjhWUDR5LzJhRktSZ2dqdTFyKy85NTczeGtVUFIwZFNYRGxh?=
 =?utf-8?B?c3VGeVFQb2FzQWl6Y2x1ZXZRVFYzOCtqNFlQNk5DWUc0Z2FYdFl6Z1hZN0J3?=
 =?utf-8?B?dVYvTDliMGxkV2gwZ1NTNmVpWDJGS0RVT2gyZFgzTzFsbjkzZ0x0RTltREZm?=
 =?utf-8?B?eGN2bWtoWWpUMlJkeE53c05yWGdWT1JZdk1IVDNucndXZ0JFZDVFa3o4T01m?=
 =?utf-8?B?OFNJazhVSjYrQ0xNS0NJcEFFUk9PT0lsakgra0J4WlVHaEt6WUxCaDU3YkJp?=
 =?utf-8?B?Yk1BT1VUVnl1MEt5RjNHMXd5dGpyQzZxS0JBWlRqLy9uVXNBRzY5SUFydjhp?=
 =?utf-8?B?Rmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95D17A180494BC498820F8F1B4C45D55@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3028c9e-4512-43bc-e2c6-08daffec90eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 22:27:53.4933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /ccxKlxG+1ElHNxlQprxGFOwe+fNWK3RjRXxIeMugQDhXGSCXzCVKi0Gk32qYRB080bMUj+iv8OneG0DeZr1kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5348
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTI2IGF0IDIxOjU5ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEphbiAyNiwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
aHUsIDIwMjMtMDEtMjYgYXQgMTc6MjggKzAwMDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBJbiBvdGhlciB3b3Jkcywgb25jZSB0aGUgUFRFIGlzIHphcHBlZC9ibG9ja2VkIChi
cmFuY2ggaXMgcHJ1bmVkKSwgaXQncyBjb21wbGV0ZWx5DQo+ID4gPiByZW1vdmVkIGZyb20gdGhl
IHBhZ2luZyB0cmVlIGFuZCBubyBvdGhlciB0YXNrcyBjYW4gYWNjZXNzIHRoZSBicmFuY2ggKHBh
Z2UgdGFibGUNCj4gPiA+IGFuZCBpdHMgY2hpbGRyZW4pLiAgSS5lLiB0aGUgb25seSByZW1haW5p
bmcgcmVmZXJlbmNlIHRvIHRoZSBicmFuY2ggaXMgdGhlIHBvaW50ZXINCj4gPiA+IGhhbmRlZCB0
byB0aGUgUkNVIGNhbGxiYWNrLiAgVGhhdCBtZWFucyB0aGUgUkNVIGNhbGxiYWNrIGhhcyBleGNs
dXNpdmUgYWNjZXNzIHRvIHRoZQ0KPiA+ID4gYnJhbmNoLCBpLmUuIGNhbiBvcGVyYXRlIGFzIGlm
IGl0IHdlcmUgaG9sZGluZyBtbXVfbG9jayBmb3Igd3JpdGUuICBGdXJ0aGVybW9yZSwgdGhlDQo+
ID4gPiBSQ1UgY2FsbGJhY2sgYWxzbyBkb2Vzbid0IG5lZWQgdG8gZmx1c2ggVExCcyBiZWNhdXNl
IHRoYXQgd2FzIGFnYWluIGRvbmUgd2hlbg0KPiA+ID4gcHJ1bmluZyB0aGUgYnJhbmNoLg0KPiA+
ID4gDQo+ID4gPiBJdCdzIHRoZSBzYW1lIGlkZWEgdGhhdCBLVk0gYWxyZWFkeSB1c2VzIGZvciBy
b290IFNQcywgdGhlIG9ubHkgZGlmZmVyZW5jZSBpcyBob3cNCj4gPiA+IEtWTSBkZXRlcm1pbmVz
IHRoYXQgdGhlcmUgaXMgZXhhY3RseSBvbmUgZW50aXR5IHRoYXQgaG9sZHMgYSByZWZlcmVuY2Ug
dG8gdGhlIFNQLg0KPiA+IA0KPiA+IFJpZ2h0LiAgVGhpcyB3b3JrcyBmaW5lIGZvciBub3JtYWwg
bm9uLVREWCBjYXNlLiAgSG93ZXZlciBmb3IgVERYIHVuZm9ydHVuYXRlbHkNCj4gPiB0aGUgYWNj
ZXNzIHRvIHRoZSByZW1vdmVkIGJyYW5jaCAob3IgdGhlIHJlbW92ZWQgc3ViLXBhZ2UtdGFibGUp
IGlzbid0IHRoYXQNCj4gPiAiZXhjbHVzaXZlIiBhcyB0aGUgU0VBTUNBTEwgdG8gdHJ1bHkgemFw
IHRoYXQgYnJhbmNoIHN0aWxsIG5lZWRzIHRvIGhvbGQgdGhlDQo+ID4gd3JpdGUgbG9jayBvZiB0
aGUgZW50aXJlIFNlY3VyZSBFUFQgdHJlZSwgc28gaXQgY2FuIHN0aWxsIGNvbmZsaWN0IHdpdGgg
b3RoZXINCj4gPiB0aHJlYWRzIGhhbmRsaW5nIG5ldyBmYXVsdHMuDQo+IA0KPiBJIHRob3VnaHQg
VERYIHdhcyBzbWFydCBlbm91Z2ggdG8gcmVhZC1sb2NrIG9ubHkgdGhlIHBhcnQgb2YgdGhlIHRy
ZWUgdGhhdCBpdCdzDQo+IGFjdHVhbGx5IGNvbnN1bWluZywgYW5kIHdyaXRlLWxvY2sgb25seSB0
aGUgcGFydCBvZiB0aGUgdHJlZSB0aGF0IGl0J3MgYWN0dWFsbHkNCj4gbW9kaWZ5aW5nPw0KDQpU
aGUgc3BlYyBzYXlzIHRoZXJlJ3Mgb25seSBleGNsdXNpdmUvc2hhcmVkIGFjY2VzcyB0byB0aGUg
Indob2xlIFNlY3VyZSBFUFQNCnRyZWUiOg0KDQo4LjYuIFNlY3VyZSBFUFQgQ29uY3VycmVuY3kN
Cg0KU2VjdXJlIEVQVCBjb25jdXJyZW5jeSBydWxlcyBhcmUgZGVzaWduZWQgdG8gc3VwcG9ydCB0
aGUgZXhwZWN0ZWQgdXNhZ2UgYW5kIHlldA0KYmUgYXMgc2ltcGxlIGFzIHBvc3NpYmxlLg0KDQpI
b3N0LVNpZGUgKFNFQU1DQUxMKSBGdW5jdGlvbnM6DQrigKIgRnVuY3Rpb25zIHRoYXQgbWFuYWdl
IFNlY3VyZSBFUFQgYWNxdWlyZSBleGNsdXNpdmUgYWNjZXNzIHRvIHRoZSB3aG9sZSBTZWN1cmUN
CkVQVCB0cmVlIG9mIHRoZSB0YXJnZXQgVEQuDQrigKIgSW4gc3BlY2lmaWMgY2FzZXMgd2hlcmUg
YSBTZWN1cmUgRVBUIGVudHJ5IHVwZGF0ZSBtYXkgY29sbGlkZSB3aXRoIGENCmNvbmN1cnJlbnQg
dXBkYXRlIGRvbmUgYnkgdGhlIGd1ZXN0IFRELCBzdWNoIGhvc3Qtc2lkZSBmdW5jdGlvbnMgdXBk
YXRlIHRoZQ0KU2VjdXJlIEVQVCBlbnRyeSBhcyBhIHRyYW5zYWN0aW9uLCB1c2luZyBhdG9taWMg
Y29tcGFyZSBhbmQgZXhjaGFuZ2Ugb3BlcmF0aW9ucy4NCuKAoiBUREguTUVNLlNFUFQuUkQgYWNx
dWlyZSBzaGFyZWQgYWNjZXNzIHRvIHRoZSB3aG9sZSBTZWN1cmUgRVBUIHRyZWUgb2YgdGhlDQp0
YXJnZXQgVEQgdG8gaGVscCBwcmV2ZW50IGNoYW5nZXMgdG8gdGhlIHRyZWUgd2hpbGUgdGhleSBl
eGVjdXRlLg0K4oCiIE90aGVyIGZ1bmN0aW9ucyB0aGF0IG9ubHkgcmVhZCBTZWN1cmUgRVBUIGZv
ciBHUEEtdG8tSFBBIHRyYW5zbGF0aW9uIChlLmcuLA0KVERILk1SLkVYVEVORCkgYWNxdWlyZSBz
aGFyZWQgYWNjZXNzIHRvIHRoZSB3aG9sZSBTZWN1cmUgRVBUIHRyZWUgb2YgdGhlIHRhcmdldA0K
VEQgdG8gaGVscCBwcmV2ZW50IGNoYW5nZXMgdG8gdGhlIHRyZWUgd2hpbGUgdGhleSBleGVjdXRl
Lg0KDQo+IA0KPiBIcm0sIGJ1dCBldmVuIGlmIFREWCB0YWtlcyBhIHJlYWQtbG9jaywgdGhlcmUn
cyBzdGlsbCB0aGUgcHJvYmxlbSBvZiBpdCBuZWVkaW5nDQo+IHRvIHdhbGsgdGhlIHVwcGVyIGxl
dmVscywgaS5lLiBLVk0gbmVlZHMgdG8ga2VlcCBtaWQtbGV2ZWwgcGFnZSB0YWJsZXMgcmVhY2hh
YmxlDQo+IHVudGlsIHRoZXkncmUgZnVsbHkgcmVtb3ZlZC4gIEJsZWNoLiAgVGhhdCBzaG91bGQg
YmUgYSBub24taXNzdWUgYXQgdGhpcyB0aW1lDQo+IHRob3VnaCwgYXMgSSBkb24ndCB0aGluayBL
Vk0gd2lsbCBldmVyIFJFTU9WRSBhIHBhZ2UgdGFibGUgb2YgYSBsaXZlIGd1ZXN0LiAgSQ0KPiBu
ZWVkIHRvIGxvb2sgYXQgdGhlIFBST01PVEUvREVNT1RFIGZsb3dzLi4uDQoNCkluIHRoaXMgc2Vy
aWVzLCBpZiBJIHJlYWQgY29ycmVjdGx5LCB3aGVuIHNsb3QgaXMgcmVtb3ZlZC9tb3ZlZCwgcHJp
dmF0ZQ0KbWFwcGluZ3MgYXJlIHphcHBlZCB0b28uICBJdCdzIGtpbmRhIGJ1cmllZCBpbjoNCg0K
W1BBVENIIHYxMSAwNDMvMTEzXSBLVk06IHg4Ni90ZHBfbW11OiBEb24ndCB6YXAgcHJpdmF0ZSBw
YWdlcyBmb3IgdW5zdXBwb3J0ZWQNCmNhc2VzDQoNCihpdCdzIG5vdCBlYXN5IHRvIGZpbmQgLS0g
SSBoYWQgdG8gdXNlICdnaXQgYmxhbWUnIGluIHRoZSBhY3R1YWwgcmVwbyB0byBmaW5kDQp0aGUg
Y29tbWl0LCBzaWdoLikNCg0KDQo=
