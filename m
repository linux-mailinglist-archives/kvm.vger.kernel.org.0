Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366767A55A5
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 00:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjIRWOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 18:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjIRWOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 18:14:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDFB8F;
        Mon, 18 Sep 2023 15:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695075273; x=1726611273;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q63HIbQGtke8p41+nNAcBgLU6B5C+wYrxHmQjm+A22E=;
  b=KF2ZYQDumT4jnP2PIm3aFDkbJ/LBJa8sx1LC1hz3jPujVqIx44kQbC7M
   NblvaJrAKjt8J0cRu+oBi9hddzmQX8WeD7E07iDuUQHoMSNQqm+dHi4m7
   M0p7jCHR4hGsxgG4wYCKEkVneKheUd26Y8MUjBYnNWoX0V5jfsXShYe+S
   E5O7D9vc8QgiJQOpzSTCpDmx7UCRcTM5YkfNTHQa2YYs+IFYw+n71KCrC
   wlzARGW2E3MEzilNRY6+E9lL2d32n3aICU2sQmDL+WTjxjZfZ7DaniG3P
   GGaun7Ds8NOV9kI159qCTmiFlmJs3Bi1+nZjkLjC1iDu79QiU2XVwu7Z0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="378691042"
X-IronPort-AV: E=Sophos;i="6.02,157,1688454000"; 
   d="scan'208";a="378691042"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 15:14:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="695668620"
X-IronPort-AV: E=Sophos;i="6.02,157,1688454000"; 
   d="scan'208";a="695668620"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Sep 2023 15:14:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 18 Sep 2023 15:14:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 18 Sep 2023 15:14:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 18 Sep 2023 15:14:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 18 Sep 2023 15:14:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RU5QDwKnHZyfkQmb5dgLu7hqwlgNtSuEjRiVbfL4KKZGAxp4ujEDOfvg0VwHcLuJAG3ZLIGtMsp8NlPPxthJNekvbdboNGgXuSQs/FJmYVT6KYup0AYqRuQHdoVYXWlNO24mlpaBJcnSsiQhidaWzmF4zEL17zJqDFW7KYQrOMgoPAILFUJpu6vl0mdciWEu+UShKtBPfsGQANEdtlM6YA29LVO17I9nCKcDIf6gLB9fhlkkd6TwrT8szju/IaJIRgLjf9j8FumMXDUCpEpF+RpS2i4dgskwG50uTGA7YTdQmkj7Hasy7TaN+q6uVIegE+g6XHKRrMQfT5Oq59XPDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q63HIbQGtke8p41+nNAcBgLU6B5C+wYrxHmQjm+A22E=;
 b=GjUd+NJ3sHyNtWKNuVcj+um6lcK6sJY8XBKMEWne3DUF4Vd+3DkpgQKRnaotoj7sZDCzYkSgSm+KvSZgIXtMMAYaBYtMadaEDtLXZsghbevBuSB65bRoMA1bor5ANfd4oiJb3Td9bhdITtd57q6O4d60jKNkCcnmuca2ojs0Cu5t/L6UzPO+BUXGHEvJ70gt1h80+NuC2RxVuw6t1EpdDGNsTK2fiPkxT1cxQBbZn5IV9VLzGYKsuYZ098pIby8vmMhzdtPEsRdkfCck9rIUwQzKa9pwkezMDtN7Ue3G54A3IKBW3YdIqtalzWUd41U0h5TzF7wrOA19BrtBB1FgVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5894.namprd11.prod.outlook.com (2603:10b6:a03:42a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.26; Mon, 18 Sep
 2023 22:14:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::31a9:b803:fe81:5236]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::31a9:b803:fe81:5236%4]) with mapi id 15.20.6792.026; Mon, 18 Sep 2023
 22:14:27 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v13 17/22] x86/kexec: Flush cache of TDX private memory
Thread-Topic: [PATCH v13 17/22] x86/kexec: Flush cache of TDX private memory
Thread-Index: AQHZ101KAStwdrBYX0OEVR8WxQ4LtLAcSamAgAAB1ACABFeigIAAPGWAgABs1oA=
Date:   Mon, 18 Sep 2023 22:14:27 +0000
Message-ID: <34b156034d1f5c85418ea03adbbc856fabd84572.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <1fa1eb80238dc19b4c732706b40604169316eb34.1692962263.git.kai.huang@intel.com>
         <fb70d8c29ebc91dc63e524a5d5cdf1f64cdbec73.camel@intel.com>
         <52e9ae7e-2e08-5341-99f7-b68eb62974df@intel.com>
         <b6b5f6f06ccdbbef900cfe7db87f490aac3e77a4.camel@intel.com>
         <ad1a55eb-0476-401a-9839-eae51e1fd426@intel.com>
In-Reply-To: <ad1a55eb-0476-401a-9839-eae51e1fd426@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5894:EE_
x-ms-office365-filtering-correlation-id: 62382536-4618-48d7-7e79-08dbb8949fcd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LEGEVzwAF1lDYSSicXY4LYOE8iOdXsppjvXedU1eNEB5/JlbJs7LwTcgRP/R4yOLtAa6jHvALIh5GuPlKKWZ+dCYp4Hf+ZgrARRyV6n0Y8fH1dmJmj4zLW+5pkVGkxp1X/7F3YhbsJOiFDHA2GAqeFcVRnkZ76/l0AYu1lgbkmHKgRifVs2eZTO2DeawRzCIvC/knh4Y5gsD2rp3ti48KDZ417IZxRSkST93kAsy7Nc9K5XiT+vuaT/xxyclXBtbla5kzRrdWnR6ivIo/lp6ArTY9TP6ac2qMpdtr/s7B1VLFAuoN0XTXUfhdVKc8hH/fnlPpwuzJuSU5Ra2I6xHxCt9Nzm78CDIJyYaHiKLonrPnKeSmFk7hwKaoscl5AhPo7lAfWMNHoNGh1qCIE580tL0jFhHOzTXxO2f8FNMporxtb37HtKJtggGwfte5orOOFXBxzPeM+Sr0ZCuUAASPzk+5ZJTDm9xxfv8swXBw2g3dJl+xiU6ILNV8iFLG0Ss3sNV0PlsvEy+eg4lGxHfntd0stDazt7dHvgYWUsttRNE2pJx2hsqdFX252Qhp1fXs+L43gMfhyUHbL7OPt/lsNgM/7j9f55vi6RPfGAFjF+WFDGi9aQyC6oCoFkW5/fY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(346002)(396003)(39860400002)(1800799009)(451199024)(186009)(54906003)(76116006)(66946007)(66476007)(64756008)(6636002)(316002)(4326008)(8676002)(8936002)(41300700001)(122000001)(6486002)(53546011)(6506007)(6512007)(71200400001)(478600001)(91956017)(83380400001)(110136005)(2616005)(66899024)(26005)(7416002)(86362001)(38100700002)(82960400001)(2906002)(38070700005)(5660300002)(66446008)(36756003)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXVtZUlBQ1diRytXOFBORlRNRmVlTDRJSHBjV1E0Znh5anhZN01kQXVIRlJF?=
 =?utf-8?B?VEQzTlBlUS80ektrM2ZwV2JFZ0VmZG5oUG1qQzBVQnRjaFJoRlVSUXhMZDQv?=
 =?utf-8?B?cFdQazJLQnZ2U3RjZWxCMTNyREM2UnpPZDF2ODYybWlLaWxET0lMcDdKbkFv?=
 =?utf-8?B?WSt0MDNRenRSRER0dStoMEd1ck5kUDhJdGdxUXk3RkNxOWhzS2xqRW5CZ1h4?=
 =?utf-8?B?QS9QaW9VMzR2YlRMMVBxYW1QK09EVkVCQVVkcjBqWitQSFc3MERYNjBQU1VV?=
 =?utf-8?B?dXhvcVIyTUl2dy9qT1pkNGZVaUF0WElDL09sL0NoM29wbTFhS0lUdHVqT1pB?=
 =?utf-8?B?cmRxUXlVTm4xTWVoWExkd0NzVGhRbUUxWXBsaEdVR0VuNmZpbDJuUXVtanNm?=
 =?utf-8?B?ejhmVjAvV1VTekVTanYxc0toaW1MamNVRnFyT0pHT24zSjlMaVJyS1F4Vkp5?=
 =?utf-8?B?ZmlZZmdPVHFPbk9qVVBYbTlCZVVmYnpQa09DZGoyU0daQlFxendZRUZFWDU4?=
 =?utf-8?B?dkNWUXhUNEpVeUZMTEVKcXBuaXJoSXB2VnRPejBockppVmtOQk5sV1I4cVA2?=
 =?utf-8?B?TFNDbnp4RUdZNURVa1FxclI5MWd3THRpQUxRTm1jaHhKMzRUdXdBYjBPWWxx?=
 =?utf-8?B?TUMxM3J3WFY1QTBjNExvYnFYa3RVRElxRkRoS1EzZ0owOEUyNlF2Y1pZWExt?=
 =?utf-8?B?RitrMWwxU1NGd2U2dTFCZGNXQ3dGYkQwMTRXUEs0RFhCRFBocERMUjhTWmVO?=
 =?utf-8?B?d3A4Tm5NZG9vdGdvNnd1QVJIR0w4eE44QkVhb3dmdXErMnkxNkRQczRWQ29l?=
 =?utf-8?B?WmhHMnVrdHFEVE4xSjlLUW9zb29jbWVkWVBnczNvV3Z5M0gyN0dxMU1OcGNY?=
 =?utf-8?B?bTQxRk5MWEI2anVYZVZzWUxFMmF0WFd3WUswZXkxYjk4bEl4aGQwd0FMOWQ1?=
 =?utf-8?B?cVcveHBLSVB4eUkwSm54NzBNWVltOTVBbllXWDkxZ1NTNWVHK3daaS9sbkFi?=
 =?utf-8?B?K3Y4SEQ0bG8xQkxCZTZpVEpLUjRJdzlHRGp1WTR1enNjTUpGbEZ0NXVFQmta?=
 =?utf-8?B?aFFrUGNRUzVvL081dTc0V3h0QlJHNmRFWnF6clc1UnhxMWRKd1Q5MDdWNkVV?=
 =?utf-8?B?WHc0LzFMQjRTY0NndXpDREtOSXhPb3FwYzRWNDRiSDhvWWNMcy9mdzFYVE4r?=
 =?utf-8?B?OW14ZFY3QnpvdXpDUmFjT0NCeVJ3ZlNLbGNkL2JHSmZwK2plQlQ4OGhmakVw?=
 =?utf-8?B?NjVXZHowVjhYeHo4ekRhM3FERHhqcFdtMlhtZzFvQkRLSi9teGdkUkNTcFla?=
 =?utf-8?B?c2V4Z1NMSUNtYWhrejBUZEo5K3hJd1dDZEhqOG1MeTVMVHFVV28xQU5nQmZ5?=
 =?utf-8?B?Nm9mS0JpOVA1aWZJTGtkY0s4R0FMQ3pBZmlyYUJYeG96eThUY2xZaldMSmpL?=
 =?utf-8?B?NlRsMWhiM0F2WTN2aHp6ZXROeXFWNWs5ZEREOVJxKzVUeGFKY0taVWplc1hM?=
 =?utf-8?B?UFBVVkZ3alBWeGo5V1dnMWZUaXNuYTh1REg5c3NoVjNFUmxzU21YMFQzMmQy?=
 =?utf-8?B?ekNuMHVrd2RUY29RN3JIMjJ0TFc4U1N4aHBheUJOZHp3YlVMMm9nMUNibDAw?=
 =?utf-8?B?bDVPRHdJUHcySHY4a0wvclIvMk1sZEE3WVNDdG5UWW1iNkxWT1Y5YkNqalRZ?=
 =?utf-8?B?QVpnS0l3UVV5L0NOOXVGYmtVSWFoRmNGbmpVNEFWNjd4S1AzdC9OYTdkVkhX?=
 =?utf-8?B?Qzd6bGhTTS9RYUJhakdTK0lRaHBMV3RvbEg2Z092d3J2OHNVV2h3cE11ZEdt?=
 =?utf-8?B?M3NsOC8yMG1qc0tnUlNoVG84NjhuS0daSE1BL1ZKdFZKTnY4dnNSS0Z1YmZE?=
 =?utf-8?B?WklDSHpXK08wUU1tZ3NueUk5QUVoUnE0RnI0ZExhak4wSmY2V0IrQms5MkEr?=
 =?utf-8?B?VHVIZm9Sd3J0ZGlvK2tkWnF6eGFhcHk3Tno2c01VWmZmOERvS1ZVajFHL1Fu?=
 =?utf-8?B?VCt2RHBOSTJSUFhLQWx5WEo1R3p4TnIxRHJSQmdDU3NnZ2svby9OQnc4M1Zi?=
 =?utf-8?B?S0hiaHNXU1Fkd3ZVTWFweDdrYTFtZTZUYWhkTDBibVdnTFBnNXJkOVJ6clN6?=
 =?utf-8?B?RW81eDRldUlqQXlDZEM3bDF5dEJVVFkzbXlRVU1WVUtpQ0ZPVVZ5bGM1ZDhw?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49E2AB48DEADA549B945C39F3B6FEAE8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62382536-4618-48d7-7e79-08dbb8949fcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2023 22:14:27.8432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5YBjMNgfJ6Hwc7ySQuhLGt/aynSif26Q9+z0KWeRQtDt5yyvdAveyEebjfox4kvHIyB8bmGkl/4pUOgd5/MdUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5894
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA5LTE4IGF0IDA4OjQ0IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOS8xOC8yMyAwNTowOCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBGcmksIDIwMjMtMDkt
MTUgYXQgMTA6NTAgLTA3MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+ID4gT24gOS8xNS8yMyAx
MDo0MywgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+ID4gPiA+IE9uIFNhdCwgMjAyMy0wOC0y
NiBhdCAwMDoxNCArMTIwMCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gPiA+IFRoZXJlIGFyZSB0
d28gcHJvYmxlbXMgaW4gdGVybXMgb2YgdXNpbmcga2V4ZWMoKSB0byBib290IHRvIGEgbmV3DQo+
ID4gPiA+ID4ga2VybmVsIHdoZW4gdGhlIG9sZCBrZXJuZWwgaGFzIGVuYWJsZWQgVERYOiAxKSBQ
YXJ0IG9mIHRoZSBtZW1vcnkNCj4gPiA+ID4gPiBwYWdlcyBhcmUgc3RpbGwgVERYIHByaXZhdGUg
cGFnZXM7IDIpIFRoZXJlIG1pZ2h0IGJlIGRpcnR5DQo+ID4gPiA+ID4gY2FjaGVsaW5lcyBhc3Nv
Y2lhdGVkIHdpdGggVERYIHByaXZhdGUgcGFnZXMuDQo+ID4gPiA+IERvZXMgVERYIHN1cHBvcnQg
aGliZXJuYXRlPw0KPiA+ID4gTm8uDQo+ID4gPiANCj4gPiA+IFRoZXJlJ3MgYSB3aG9sZSBidW5j
aCBvZiB2b2xhdGlsZSBzdGF0ZSB0aGF0J3MgZ2VuZXJhdGVkIGluc2lkZSB0aGUgQ1BVDQo+ID4g
PiBhbmQgbmV2ZXIgbGVhdmVzIHRoZSBDUFUsIGxpa2UgdGhlIGVwaGVtZXJhbCBrZXkgdGhhdCBw
cm90ZWN0cyBURFgNCj4gPiA+IG1vZHVsZSBtZW1vcnkuDQo+ID4gPiANCj4gPiA+IFNHWCwgZm9y
IGluc3RhbmNlLCBuZXZlciBldmVuIHN1cHBvcnRlZCBzdXNwZW5kLCBJSVJDLiAgRW5jbGF2ZXMg
anVzdA0KPiA+ID4gZGllIGFuZCBoYXZlIHRvIGJlIHJlYnVpbHQuDQo+ID4gDQo+ID4gUmlnaHQu
ICBBRkFJQ1QgVERYIGNhbm5vdCBzdXJ2aXZlIGZyb20gUzMgZWl0aGVyLiAgQWxsIFREWCBrZXlz
IGdldCBsb3N0IHdoZW4NCj4gPiBzeXN0ZW0gZW50ZXJzIFMzLiAgSG93ZXZlciBJIGRvbid0IHRo
aW5rIFREWCBjYW4gYmUgcmVidWlsdCBhZnRlciByZXN1bWUgbGlrZQ0KPiA+IFNHWC4gIExldCBt
ZSBjb25maXJtIHdpdGggVERYIGd1eXMgb24gdGhpcy4NCj4gDQo+IEJ5ICJyZWJ1aWx0IiBJIG1l
YW4gYWxsIHByaXZhdGUgZGF0YSBpcyB0b3RhbGx5IGRlc3Ryb3llZCBhbmQgcmVidWlsdA0KPiBm
cm9tIHNjcmF0Y2guICBUaGUgU0dYIGFyY2hpdGVjdHVyZSBwcm92aWRlcyB6ZXJvIGhlbHAgb3Ro
ZXIgdGhhbg0KPiBkZWxpdmVyaW5nIGEgZmF1bHQgYW5kIHNheWluZzogIndob29wcyBhbGwgeW91
ciBkYXRhIGlzIGdvbmUiLg0KDQpSaWdodC4gIEZvciBURFggSSBhbSB3b3JyeWluZyBhYm91dCBT
RUFNQ0FMTCBjb3VsZCBwb2lzb24gbWVtb3J5IHRodXMgY291bGQNCnRyaWdnZXIgI01DIGluc2lk
ZSBrZXJuZWwsIG9yIGV2ZW4gY291bGQgdHJpZ2dlciAjTUMgaW5zaWRlIFNFQU0sIGluc3RlYWQg
b2YNCmRlbGl2ZXJpbmcgYSBmYXVsdCB0aGF0IFNHWCBhcHAva2VybmVsIGNhbiBoYW5kbGUuICBJ
IGFtIGNvbmZpcm1pbmcgd2l0aCBURFgNCnRlYW0uIA0KDQo+IA0KPiA+IEkgdGhpbmsgd2UgY2Fu
IHJlZ2lzdGVyIHN5c2NvcmVfb3BzLT5zdXNwZW5kIGZvciBURFgsIGFuZCByZWZ1c2UgdG8gc3Vz
cGVuZCB3aGVuDQo+ID4gVERYIGlzIGVuYWJsZWQuICBUaGlzIGNvdmVycyBoaWJlcm5hdGUgY2Fz
ZSB0b28uDQo+ID4gDQo+ID4gSW4gdGVybXMgb2YgaG93IHRvIGNoZWNrICJURFggaXMgZW5hYmxl
ZCIsIGlkZWFsbHkgaXQncyBiZXR0ZXIgdG8gY2hlY2sgd2hldGhlcg0KPiA+IFREWCBtb2R1bGUg
aXMgYWN0dWFsbHkgaW5pdGlhbGl6ZWQsIGJ1dCB0aGUgd29yc3QgY2FzZSBpcyB3ZSBjYW4gdXNl
DQo+ID4gcGxhdGZvcm1fdGR4X2VuYWJsZWQoKS4gKEkgbmVlZCB0byB0aGluayBtb3JlIG9uIHRo
aXMpDQo+IA0KPiAqSWRlYWxseSogdGhlIGZpcm13YXJlIHdvdWxkIGhhdmUgYSBjaG9rZSBwb2lu
dCB3aGVyZSBpdCBjb3VsZCBqdXN0IHRlbGwNCj4gdGhlIE9TIHRoYXQgaXQgY2FuJ3Qgc3VzcGVu
ZCByYXRoZXIgdGhhbiB0aGUgT1MgaGF2aW5nIHRvIGZpZ3VyZSBpdCBvdXQuDQoNCkFncmVlZC4g
IExldCBtZSBhc2sgVERYIHRlYW0gYWJvdXQgdGhpcyB0b28uDQoNCg==
