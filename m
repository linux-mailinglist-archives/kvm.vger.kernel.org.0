Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89376F5CBE
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 19:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjECRKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 13:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjECRK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 13:10:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87DB7687;
        Wed,  3 May 2023 10:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683133805; x=1714669805;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=/XZkCjkEb0WYFvCNik+y2ND85CfdBZSeeBFp4sj0rNs=;
  b=GRr4Y16dbStvKndpB9HPMrUZMQyXU2RCIy2zeqadz5xAGEMg2Mroco0a
   tg6qF6jQ2qCTKe+lvKba2/bXGLVwYtJUpod3VLED6fx9pBf327dQdjanr
   HPgQmd9CDTdWlV43L0ZbMY31mlL2OI1MhIG658FG0OCK/gE/5ZFu87iA+
   mBaUxdXFUSIXvbfW/W15a+bE4ZVploGl2H8t9uVK5mP3uf0oZT6IZaXCe
   KR6NvKzbIe8F0jrrt+fEs41ep8Pc1IwHsSoK3wdAaxp+aq4QEMw69z7i7
   sSQ6V8bWED8107D8vvTpDmzdwihSMeT/2SLTZcDi5bfInD3IDHdHeYDXH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="376775733"
X-IronPort-AV: E=Sophos;i="5.99,247,1677571200"; 
   d="scan'208";a="376775733"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 10:07:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="699465889"
X-IronPort-AV: E=Sophos;i="5.99,247,1677571200"; 
   d="scan'208";a="699465889"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 03 May 2023 10:07:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 10:07:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 10:07:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 10:07:01 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 10:07:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFOu7HZ+5ohNIg2s4aFGp7MMDoFx44+XQMqqaaBj3mccGTkx/dZq+OCE3gTBz6Y3abzcwT4Sxv0aN7OAXsO8FYI7V2LRtMcb2uJ77m9QuGscqvLbrKDQAQuMAkcDctu9p+evc90iBEawCCqQV9x/Up9IcPajnUPH3zi3irB8yW/uroAUCRWonsmJJ4jowAvLC8waoUY7bHJi2NK5JHMSk9o1DeU+U/IDXn5VchHIhwqxLhsB7ojBP+mVqyT2SWBiCcSotChJ6qftNfYzgkvDthIG2R7D9/+LGY55SF5XxFG0KsKhgoKnM29RFmTwX+z1B6bWaO8IWM7OtBhNi4U+nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/XZkCjkEb0WYFvCNik+y2ND85CfdBZSeeBFp4sj0rNs=;
 b=BZNtp44TS3X4yw4NEkY+XOpWzfNcVSpfIlXB0iylA+Y86fRkykfm7uqhUly1hZU3mT2bEKWIUlf5x6krZ8eFvdzkp4D0umpODyP37ZVcyRxnUifLllbAfISRC2a5SJshnKoNsFcaIESYSJedC/uJEPvyRRUzs6xqIcPhdgcxJ9nvvVGy9SuS4CyzgG2WR8285yURHovTkEMfi107Zb6pADlPATSet3UmEqrduF5Y3q//yj4/zVtCXR71D21PmIE8552SWu9tdv0D1HjZt75+/2c+qqbmmxtkNwHqcKQltfZu33247MjSWdR3B9WWDBB09TkhpnsDvkQKD5MFEeykzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB6754.namprd11.prod.outlook.com (2603:10b6:510:1c9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 17:06:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::33bf:d30c:12fd:b7e3]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::33bf:d30c:12fd:b7e3%6]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 17:06:57 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 21/21] KVM:x86: Support CET supervisor shadow stack MSR
 access
Thread-Topic: [PATCH v2 21/21] KVM:x86: Support CET supervisor shadow stack
 MSR access
Thread-Index: AQHZdHFyi6vR/qt18UeCPYYHW6Q6nK9I2nEA
Date:   Wed, 3 May 2023 17:06:57 +0000
Message-ID: <918166a78f5306210b1877107609cbd340f79a67.camel@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
         <20230421134615.62539-22-weijiang.yang@intel.com>
In-Reply-To: <20230421134615.62539-22-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB6754:EE_
x-ms-office365-filtering-correlation-id: 02a15bb1-ff92-4869-e4d7-08db4bf8cdab
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UVaKG2vpjy9wLQAchcyIXjtOaN6DSNcxUOhHNSIPVYytcjk2g2/ZRt35T7Psrd3x6mxSHOYMh4CmioO3Bj86Is6lfAT/jrC/ADOsO2yMQccQ/E3N5ZoYx9qysndzPkT8nQ9ZaqeRy2wWu/zkMbSqIKff/NCro4RR55IB4Xh9OmI9od7yMju8EEW00NQG81JdPsa3okUbnkWnCq8mqU8NmW9mLMiagWAJRgl9RdMT2Ttw6hXkUygi7W96GRehyRnaSRXfNopXSMJp6DSIQ5PFDj/nm1mQbWEwfie4nsWgFIdbviA4lj0w4aK2MzTrSMOHBIkS9FwnsucXALomrEQN0PkcqvTrFnTNb/4vQZ1obsFc8nWUQFm4IyCpxbN3njD9XSlvoEIdmDTX/yTj3Cglxl6yHTICQhSne4kmR+eCBZbFNBd9Rt2MawdnNksJF/tImSLRy/Q5rmDrHl/jW0WQBTS4ZRvh0OXWiOhwMN3zbvrn7hyQNI5OdF3mdQnjggrvWq/Hm3b3hvocj+yir2n4J6Cs5uvaPuANKjc09TQz86m80AoeyDqC6OZ0xF/974McKu8XiTlNxfXKxqyueJFASe86FYTloqybdYgeY5bcM2BnM07iaE4NqPt6ngsdy8f5bLaYD9x1Q/m/wVe6OcCSHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199021)(2906002)(4744005)(122000001)(38070700005)(921005)(38100700002)(82960400001)(83380400001)(2616005)(26005)(6512007)(6506007)(186003)(36756003)(8676002)(8936002)(5660300002)(316002)(478600001)(71200400001)(110136005)(86362001)(6486002)(64756008)(66446008)(41300700001)(66476007)(76116006)(91956017)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0ZNUFdJcjJETDdNTElWaG94MHVlUWZydGJENFp2SjZhRWRzS3FDRWN3LzUw?=
 =?utf-8?B?Mlh6eVhNaWljVUlBai9sZnBJZ0ZJUG1jN3JwSkgvWVNiSWpmb1MvMmI3Uk9r?=
 =?utf-8?B?TjYxczc0Q3JYcGtSM29OSVpYQnVKT2E3c3hPb3FCT3JsSStuVlNZTmFyWVlL?=
 =?utf-8?B?S0hWam1IcVF0ZmNxTnhZTmMyY09yU1JWUHJrRzRnNWF3aHkrTmlJb21EaUNR?=
 =?utf-8?B?dENUeEk0RHhwa0F4NCtQYTUzTUw4MGE4R2NYMWtkVzZaNVV0TUxVaTVGbmwy?=
 =?utf-8?B?bHAwSGdmR3BWY0RSN29XT0JkNEwzSkhsTkUwalRFYi93TGcrZEJXZXBJYk93?=
 =?utf-8?B?U2crZ21idWJNTysxUFZpZHZjWjR2NGErOUtPdTltd3QwdWcrMGJ0QzZER1Mv?=
 =?utf-8?B?K2hYL0h3UTNuYkZCWDU4Umd2SGZNUi9MZW8yU3NUcStCY2hPNmhSaWkyODhK?=
 =?utf-8?B?UWVVNHJVVTJ1dVVqQlpBVG1rQ2Z3Qy9tNWl5WTdiVm1rNXgxZWhIUm82Qmc0?=
 =?utf-8?B?RTI2a3JNcXBMS2ZjWlVTZG91NmplS2xMd1Z4TjFzMWY0Sk04VC9sQ2V2N0Ex?=
 =?utf-8?B?VFQ5MEJBR2JCUC9VNTlhMUgzMDFoS2Q0RXhLdlJhaEJHYmVsc011N1JyN3pS?=
 =?utf-8?B?YkZNQitobXdTUkNKbzB0cWdVYXJ2UjVjeFowRHNHZy9IRENYRCticHpMMXRI?=
 =?utf-8?B?dzBncitVak53ZUZEWkVxeEJtTXJvbTN5V2R4a0g3eVJHenozWjVHR3B5bThK?=
 =?utf-8?B?TU5zWlhIbnQ2M0F2RE5UK3pnaUxXVTNqV09UMzFnc2hqYjJnajU2TUIrcFll?=
 =?utf-8?B?TzBjbVplaFlIcHROSWRUb3h2YitxRnFqckVtVUZMWXFSbFRPS3h4UmpwZ2Nn?=
 =?utf-8?B?SWowMDJ1aHlOQ2Vic25EcDJ0QTBzQndCOG1ycWt5WFdsdVI0SXlWS1pvSWsy?=
 =?utf-8?B?bllTTmNCYTlPZEs0emJrdENrOEllc1k5TGpOWUVhUU1UQUp2OThjSmJvajZo?=
 =?utf-8?B?TEdTcCt0Q2JaMjNaSjZENEpqampmUzRQZDRNN2hRb1k4K0RLMEQ0djc5QTBM?=
 =?utf-8?B?T05qQTNtQXl6cW1RVnA0cnUzbDdKWmlvRElWTjFUR2dTdjAzYzE3b3ZtOGxV?=
 =?utf-8?B?Vm5QVmgzVmhHQStraGN3WXdJZW9pdVo2YUFZckhWbGZaNmNIQlVXTEsxa1ps?=
 =?utf-8?B?Q25PbWF0QkRsc3E2VEdtOVdqSUUvVWZQeGZPR1FCdXlYakR4enFDOE9lZU5M?=
 =?utf-8?B?UC9TajRMRzJjbE10YTRGSW9FeHpiUlpoa0tlbUZvM2Vza0llaWtjTERJWnNL?=
 =?utf-8?B?QUlzaGJQSm0rc2pJVmkxdzExNVBTdDNVem12NWlrU2s2dEFVZ1pKK29KQWs3?=
 =?utf-8?B?S2hmaWhFOVoveGZzblBPRFQyU1pTdTJIUXRQT3NaSytjVWZRb2Zudk1ER0lZ?=
 =?utf-8?B?N2NtYUVaZWJXTjQ4NTc0c1hiL2VYaVdsSWpDOGlEMGJOOC9CMTk5aVptT09V?=
 =?utf-8?B?RWJtT0pHTVI2ekNNMkdJNFAwdjN1NHExeHlJSVlZeWE0S3l5N01Qb3M1eDhD?=
 =?utf-8?B?bUF2djRhcUdoZEE2VzB4bXd6YW9MTm5OMjV0UDFsM1FpcWc0ZlFhbmVYVTQ2?=
 =?utf-8?B?Zm14WWZlRVpobmNnRXpLL0RrNElFdFBSdklIclhId1RLV0ttTzF6Zk5vZkxK?=
 =?utf-8?B?bG8wRWVVaWJlakthSHV4M1p6cUoyV2lRbng3RjFSMEJ2Z3Vza0piWTR4RmJi?=
 =?utf-8?B?Qk96VnNXTlZQUG1PZUNYZEowZFV2aDBvYkFqWlBBQVkvVUtQWFFLSk9YNVNM?=
 =?utf-8?B?ODQ1cjIyZTRhYlpYY0puUElFVGhuNnF2TTYzeXRPLzlvMHNSVVdVSnBhQU02?=
 =?utf-8?B?eWt1aGpzVzkwSUs0SGdnSktHcjFtRkZHYWozQXI3NVc0TlBzblRhUVdVZ3JD?=
 =?utf-8?B?NEgyMThwYTBGWDJFNURXendTZUgreGRNeW1WeGZWRkVyWGI1RElnVkpWMDVk?=
 =?utf-8?B?QWVKek0rSlpnTUc0K0J3ak4vY1ozUk1aUWdtV3o3WUtYdzhZUm5tMmcyVlA5?=
 =?utf-8?B?VjlCU21UMitrYXc2dmltQkVEem1yUXlhUVdmaFNGRm9vUlZaOENYOU1wWllO?=
 =?utf-8?B?bE8ycFZ0T2dJM3BKakZwVmdxcC9XeXZ1QlR4YnhUSUhsSmZwTFIrU2tJbFEr?=
 =?utf-8?B?QXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1E2E2C810A00345BDBF0779A4B10511@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a15bb1-ff92-4869-e4d7-08db4bf8cdab
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 17:06:57.7299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WJYjQXT6XfjfAfGRFKT0JU3m/2n5P7WexbmSCccfN6X//0ZFGzzkfEHl6gPAl7RooQjL3y+Zpol8IlAHKLkwF7ohtkakqs+EXxsAeC2UYBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6754
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA0LTIxIGF0IDA5OjQ2IC0wNDAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOgo+
IEBAIC0yNDcxLDYgKzI0OTUsMTIgQEAgc3RhdGljIGludCB2bXhfc2V0X21zcihzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsCj4gc3RydWN0IG1zcl9kYXRhICptc3JfaW5mbykKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGVsc2UKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBrdm1fc2V0X3hzYXZlX21zcihtc3JfaW5mbyk7Cj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBicmVhazsKPiArwqDCoMKgwqDCoMKgwqBjYXNlIE1TUl9J
QTMyX1BMMF9TU1AgLi4uIE1TUl9JQTMyX1BMMl9TU1A6Cj4gK8KgwqDCoMKgwqDCoMKgY2FzZSBN
U1JfSUEzMl9JTlRfU1NQX1RBQjoKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYg
KCFjZXRfaXNfbXNyX2FjY2Vzc2libGUodmNwdSwgbXNyX2luZm8pKQo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDE7Cj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGt2bV9zZXRfeHNhdmVfbXNyKG1zcl9pbmZvKTsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYnJlYWs7CgpUaGVzZSBhcmUgc3VwcG9zZWQgdG8gYmUg
Y2Fub25pY2FsIHRvbywgcmlnaHQ/Cg==
