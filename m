Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFAB674395
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjASUkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjASUkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:40:11 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF8F80178;
        Thu, 19 Jan 2023 12:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674160809; x=1705696809;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lOb1ctwrA2bNBBoIphC2uLeURzUfC19VxRjWsdVYUIM=;
  b=iGcKyLrb1JHQH4HYeZEd+cgGf46qN53aoMLQsunQeOohNUGGwAwHB3pA
   /l5rlBFo/RShvE9d0a/6f3Je/7clvn+PHEl9mUToTgwtl5TXIJVXKZuU8
   uRlFs78Yzpuz3OI5r7/MULcIgwuyplLHnH6jk703jGrGCqLf20EI79vmJ
   S4mFTwacHHNArcVnUlMCpEhCBib0To2rg44tSFP36J35mcmMPoYvBqsg5
   SxJp6TrToJhf0jXbTIyHGaKSe2ITykSS7RWEl03fggJkXj8YWRlva4yY0
   pkGeJ5eWOTE3Ffd7d0pg+wzI2hIvWLGwnGl2SBH13LLZhAcL9NE1iH83v
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305089759"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="305089759"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 12:40:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="768374353"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="768374353"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2023 12:40:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 12:40:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 12:40:04 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 12:40:04 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 12:40:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beIF9FQBINfEEYNrNw2kNQRI3/wY7yczby9A/R7sG+sCV1xHokAqoRlMUCJkko5ashzlpf9PlOqMPx3xedX/fqGxFB9EkbMrxNU9JYZ4VjfrEUrrlYDe4LQcxujduD5XA51Cg2ivs5KMbe1XQNtOiiHisy6X2AQkfmsXODaZZT4FZYkNEFhKWORSUHCN7nZOVWM3Ewy0AWVjnqR+QcOb9Un3zwvzFhVaJg0yhl7ZFu4Ol9u0NH2sJYz4hGAwCbIUNoDPIVsnyUhWJ2mynoC5Vlq9q2M9S5QsCTaG2GQX/H4cU8050q9C8JYscnKWB00uH5NfBoW+h5FthF7IvaSXyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOb1ctwrA2bNBBoIphC2uLeURzUfC19VxRjWsdVYUIM=;
 b=esDrW4NQn847GHuhb8H1dbtq2cLr3mwBJhe8OpzInd5hwiuJW/h7SO0e3FqK7QZXpPM+v5sHPXjC4y6W1Yrk9xBoYiJolIGOk2OaGmxdJwd0Un0BmvkIXTybdORwCcfownP/Ehb2sRbhvImrYn9fowlKMkKvPWfG4Oq5NRiOORcYvuKUuj2b7uEXskCkZ4ppq2XcLRtHFR7q57SZRXT8ZooMLmqEtFEjtxu3y5p0AYmJr7sb4hnD+e2TyTyvi5C+n13+tFuQ5KDOmaLzwFZ1eqfy0BzIroP/FgsR3RCbS14UI21xWh7JSxU0hTRwzTomMfvRVxLQ0JXsDR92mEPLEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5029.namprd11.prod.outlook.com (2603:10b6:510:30::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 20:40:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 20:40:00 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Index: AQHZJqOgR/AYJ+DUHUGfsmh5dZfuuq6cVDsAgAAiagCAAS3PgIAFJp+AgAA/zQCAABQhgIAAAWcAgAKFUoCAAETpAIAAVHGA
Date:   Thu, 19 Jan 2023 20:39:59 +0000
Message-ID: <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
         <20230113151258.00006a6d@gmail.com> <Y8F1uPsW56fVdhmC@google.com>
         <20230114111621.00001840@gmail.com> <Y8bFCb+rs25dKcMY@google.com>
         <20230117214414.00003229@gmail.com> <Y8cLcY12zDWqO8nd@google.com>
         <Y8cMnjHFNIFaoX27@google.com>
         <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
         <Y8ljwsrrBBdh1aYw@google.com>
In-Reply-To: <Y8ljwsrrBBdh1aYw@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5029:EE_
x-ms-office365-filtering-correlation-id: 18ed7e89-8220-4583-7770-08dafa5d55aa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jeScg4e2U7sih2scd7PwUjmvwqQ/v0LP+fmN80qM2hZiiywhbhYH006MYpMCEB47i/K09aT1cOOH3bxJyrSgYy/eJaQk46iTNEMp5XC13Vu5HPgt3wdR0fQWXrVr4aCw9j+4OrtRhFE/ihP35KrXIDZOafXLLtACOmvre77uRDJfZtMAbniClig0k3XKcl3Uhb08uBPRvgatzpWFkCpuP+apfqZLjPUC3kLKVZgS4IljmM/jrz8DGDn9jYmm+Q0pWGvTPnt83FwaqR4uz1Mv3Pel07m6fyZlIUgGuQH81R7mHNPPC8AlvI47jmqog/V3KwKyiQ5dDp8Y96FSUB/ybHdijZrZjPrgXinObAz8YwWG5YrXudqgTC1q5210P/WGK8M2bym38dTRobcwtpnul5IsPMMaTaB4lWW8qK8ttkBS2nqkh5wuYReDctZxWzdnnNWrI2Q+ylHVNflzYICJVnHtxMs1anp1Hjhfrk+nWlYslHLrWZPNUrMO3QdMBRGRCt6w+AB6P2fal8HyF18USnY41kp+bGCo8O22KDAxwLUHqg2R/oDf0OYP0Y/QiBnsLK0VYrZ+drbqDX8cOotuaD+mpftGUZnXmopbaL4AZiWl90BFfALUtuWPJEQtUOtUKtv2x8Z++Azhp2lfaauzF7nVWj7sGZKs9X4uqM5XQ2RQucksJJmn4kivIQxTFpL6MZ8/nRB6iCcxWfVslcZ/mg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199015)(6506007)(107886003)(478600001)(54906003)(71200400001)(6486002)(4326008)(6916009)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(316002)(26005)(186003)(6512007)(91956017)(5660300002)(8936002)(2616005)(36756003)(41300700001)(2906002)(83380400001)(86362001)(38100700002)(82960400001)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MC9XeGxsNWt1bEYxME1RYi83SGlNOHIyS0VKVlhlQzdWMEZEZk5OZEpxZDZt?=
 =?utf-8?B?bnhkUEJMZHZHakFLTVk1OE4wVUpSLzFWOU1zeE1EMm1NbzVOZmlaLzBOcWlp?=
 =?utf-8?B?aDczM3VzYlc3d0cvaXV4QVVCZ2dabm1NMldBekRoaVRTSCtVczljaXBzRmV4?=
 =?utf-8?B?b3grVWtTVlZEVllDWmM0Z21aTjZIYmVyRjZkTEttOGJXbzJid1JKNk4yc3dI?=
 =?utf-8?B?d2hpU0tteDBFVjFaYi9zOVdaZFcxeXcybExDRGVBNGVPbldFcUl0eHhOTW55?=
 =?utf-8?B?bGY2R0xESk5uRGJ6dHN6LytzQUR1NzY2blRSVjZBYVNsRUdlMW1nK1o0bWpa?=
 =?utf-8?B?aG9LdW4rdzhIb3Z6Wk0zLzkySHZ6RXNpaUFCdWp5VysrSmFRZ3o1R0M3em94?=
 =?utf-8?B?eGJDWGFaYlZRcnZNZVdBQ3FrcXkyM1Q0RlJMYnFJcUxONGlGdVY4dnB0SENI?=
 =?utf-8?B?VFl0RDUzNTZzWUxva0plcXFXeXA3OWVhdU9QUTJLRTRHa2tyMVc5aHFTUkMy?=
 =?utf-8?B?cEhReDVLZ28wQm8xNVZSNnRnbjR0a3B2aUtxZ2xpZUpwVVNxRUYvNDhqb3Vz?=
 =?utf-8?B?cDJUYWJhTktHNWtDWWtuUmd4K1FQZEtVQjI0S1YrOHAxSkpQVS9LWXVtTER2?=
 =?utf-8?B?ajNHcnk0RjVOeHd5aTl6dkZCMXVHVGNoODBhRzRoNU5sTUE1MXlxR0VmUkFw?=
 =?utf-8?B?MXdMSnlyZ0xseFVDL2pOMUNlc3V2QU43bVdUdkxEdityNVNEc0UzaUhzN2Z4?=
 =?utf-8?B?V1dKa1lnTWozbG0xa005QmtqbnRpR2ltNGREMmhzRjduNUpzT2JIVjJ3SWdl?=
 =?utf-8?B?MWdEaWo4dmdkaEdoR05jYWxkUEYrTFc4SWJTUFdNbUlJQjFaY09zaTBlNTJ1?=
 =?utf-8?B?SHBZMDQ3dzdqN05UOFkrUUs3c3dyTG9VeUJFbThDRm9QM0pEekZZSXhJUFlK?=
 =?utf-8?B?N0UveldqL2lJODR6d3huVUc2TWF1Q1U0UTlyNGVwNnQvS1Z1M2kzNDFWY0pt?=
 =?utf-8?B?R3F3c3FoREdTbFphRzJVM1FjaW9PVklkL1doZ2psYStXWVpXTjRzbEFFU0J2?=
 =?utf-8?B?QTU3NkF1ckdnMUg2VHR0MEZYWVMxempzQkNoenFzODJtMkFOVXY5T3d3blJV?=
 =?utf-8?B?WTFNdWZkRyt0UlJaNE5Xenkyc2JJUTI5NHJ6RzRDZEx5RUF3akgxUUxqc2hW?=
 =?utf-8?B?RWN4MjRNb2RZQytPWVBEdWxwaWFJMzF2TktRUElnQlEzTFh0SXdyUmdLbnMy?=
 =?utf-8?B?U3BORjNJUk91Z1hDYmkwbmJaRkxJWldCcUhJdUFIQlY5YTJrMi82YjQvbEtC?=
 =?utf-8?B?VURlalgwSUNiOWVjak1CMUpoeHAyWjJCZDB0QW5LSW93OXZsY1RWSkNncE0x?=
 =?utf-8?B?bkE0a3pYZzM1bDRKVnlMc25TeGlIMER3b0dMbTBFcmt1V1pRKytJNWUyUTJq?=
 =?utf-8?B?a2Y4cnNLY1hXUXZHYVRHeU9FSklacElrSTcrb0xQTUh1aGxvenNMRjR3SVFN?=
 =?utf-8?B?RnltQWJ5RW1Gei9CRGhsMkJWeVE4aHJ1T1Jra3JVYU92c2EvQVA0L0hpOU9q?=
 =?utf-8?B?WHEwdDRKU2lBUW5KaDh6NDFXbGJJaUw1ZEdvYkxsdUdCV1V4V05MUmg1dEs2?=
 =?utf-8?B?T0o5TnBDd0JwM29BejBBZFhzY3g4NXRGaGpIWldBQ0lVU0Q3NnVCVVl4eTZ1?=
 =?utf-8?B?Vm1kSWQvSlpoNFVBeE1DeU1Ba3RNTTZ0Y0k1TkdQU2RjWWxkbTl0S3doZXAv?=
 =?utf-8?B?UVR0ZXdqOG9HYk1RR1FHdWtwT0tDU2hjYmJTVWFOMEtpa2pFNWZXQlJ1QzBr?=
 =?utf-8?B?aU9OS1grL2haKzBiRU42QUFCdUNRbUZSMmxQSjMweEdReEs4MUVicGJtUzNJ?=
 =?utf-8?B?eW5JT3A0d21nK2FoejBuMzMrdEFUUG4vd0lYQ0lCVnp6KzRWT1kwTC9kbU12?=
 =?utf-8?B?RjA2dlJxTFFXSHNwaS9JTC9GZ0kyZCsvcG1KV1J2Vk1kazF6dG53MkM4M0dL?=
 =?utf-8?B?Vjh5SFl2amk5V05sYjJxQi9iZzJZaUVidThrQjRUN1EyU0ZTL0VPQVM2WEFP?=
 =?utf-8?B?alBiamZIQ3MrcTVFdEQrT2dOajhraS9rMkZFZGVDTitOWEdteWdGWk00VVBS?=
 =?utf-8?B?Ym8xMS9uMGgweHRVUVR3YmFWYnMvSVFsaE9PbWd0VlVyMGk3N3U5UnJaQVRs?=
 =?utf-8?B?U0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E711BA18F57B542BC7DC7DCF0806F0C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ed7e89-8220-4583-7770-08dafa5d55aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 20:40:00.2015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pqcGB66O82vuggPs8V23h5v1fVgtw73GpO1pWEsuM0XGddJ0I3WT9hYPHIsp2wI6rUDfJiDhmJsHJgO44Qq99A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5029
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTE5IGF0IDE1OjM3ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEphbiAxOSwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
dWUsIDIwMjMtMDEtMTcgYXQgMjE6MDEgKzAwMDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBPbiBUdWUsIEphbiAxNywgMjAyMywgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+ID4gT24gVHVlLCBKYW4gMTcsIDIwMjMsIFpoaSBXYW5nIHdyb3RlOg0KPiA+ID4gPiA+
IDIpIEFzIFREWCBtb2R1bGUgZG9lc24ndCBwcm92aWRlIGNvbnRlbnRpb24tYW5kLXdhaXQsIEkg
Z3Vlc3MgdGhlIGZvbGxvd2luZw0KPiA+ID4gPiA+IGFwcHJvYWNoIG1pZ2h0IGhhdmUgYmVlbiBk
aXNjdXNzZWQgd2hlbiBkZXNpZ25pbmcgdGhpcyAicmV0cnkiLg0KPiA+ID4gPiA+IA0KPiA+ID4g
PiA+IEtFUk5FTCAgICAgICAgICAgICAgICAgICAgICAgICAgVERYIE1PRFVMRQ0KPiA+ID4gPiA+
IA0KPiA+ID4gPiA+IFNFQU1DQUxMIEEgICAtPiAgICAgICAgICAgICAgICAgUEFUSCBBOiBUYWtp
bmcgbG9ja3MNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBTRUFNQ0FMTCBCICAgLT4gICAgICAgICAg
ICAgICAgIFBBVEggQjogQ29udGVudGlvbiBvbiBhIGxvY2sNCj4gPiA+ID4gPiANCj4gPiA+ID4g
PiAgICAgICAgICAgICAgPC0gICAgICAgICAgICAgICAgIFJldHVybiAib3BlcmFuZCBidXN5Ig0K
PiA+ID4gPiA+IA0KPiA+ID4gPiA+IFNFQU1DQUxMIEIgICAtfA0KPiA+ID4gPiA+ICAgICAgICAg
ICAgICAgfCAgPC0gV2FpdCBvbiBhIGtlcm5lbCB3YWl0cXVldWUNCj4gPiA+ID4gPiBTRUFNQ0FM
TCBCICA8LXwNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBTRUFNQ0FMTCBBICAgPC0gICAgICAgICAg
ICAgICAgIFBBVEggQTogUmV0dXJuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gU0VBTUNBTEwgQSAg
IC18DQo+ID4gPiA+ID4gICAgICAgICAgICAgICB8ICA8LSBXYWtlIHVwIHRoZSB3YWl0cXVldWUN
Cj4gPiA+ID4gPiBTRU1BQ0FMTCBBICA8LXwgDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gU0VBTUNB
TEwgQiAgLT4gICAgICAgICAgICAgICAgICBQQVRIIEI6IFRha2luZyB0aGUgbG9ja3MNCj4gPiA+
ID4gPiAuLi4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBXaHkgbm90IHRoaXMgc2NoZW1lIHdhc24n
dCBjaG9zZW4/DQo+ID4gPiA+IA0KPiA+ID4gPiBBRkFJSywgSSBkb24ndCB0aGluayBhIHdhaXRx
dWV1ZSBhcHByb2FjaCBhcyBldmVyIGJlZW4gZGlzY3Vzc2VkIHB1YmxpY2x5LiAgSW50ZWwNCj4g
PiA+ID4gbWF5IGhhdmUgY29uc2lkZXJlZCB0aGUgaWRlYSBpbnRlcm5hbGx5LCBidXQgSSBkb24n
dCByZWNhbGwgYW55dGhpbmcgYmVpbmcgcHJvcG9zZWQNCj4gPiA+ID4gcHVibGljYWxseSAodGhv
dWdoIGl0J3MgZW50aXJlbHkgcG9zc2libGUgSSBqdXN0IG1pc3NlZCB0aGUgZGlzY3Vzc2lvbiku
DQo+ID4gPiA+IA0KPiA+ID4gPiBBbndheXMsIEkgZG9uJ3QgdGhpbmsgYSB3YWl0cXVldWUgd291
bGQgYmUgYSBnb29kIGZpdCwgYXQgbGVhc3Qgbm90IGZvciBTLUVQVA0KPiA+ID4gPiBtYW5hZ2Vt
ZW50LCB3aGljaCBBRkFJQ1QgaXMgdGhlIG9ubHkgc2NlbmFyaW8gd2hlcmUgS1ZNIGRvZXMgdGhl
IGFyYml0cmFyeSAicmV0cnkNCj4gPiA+ID4gWCB0aW1lcyBhbmQgaG9wZSB0aGluZ3Mgd29yayIu
ICBJZiB0aGUgY29udGVudGlvbiBvY2N1cnMgZHVlIHRvIHRoZSBURFggTW9kdWxlDQo+ID4gPiA+
IHRha2luZyBhbiBTLUVQVCBsb2NrIGluIFZNLUVudGVyLCB0aGVuIEtWTSB3b24ndCBnZXQgYSBj
aGFuY2UgdG8gZG8gdGhlICJXYWtlIHVwDQo+ID4gPiA+IHRoZSB3YWl0cXVldWUiIGFjdGlvbiB1
bnRpbCB0aGUgbmV4dCBWTS1FeGl0LCB3aGljaCBJSVVDIGlzIHdlbGwgYWZ0ZXIgdGhlIFREWA0K
PiA+ID4gPiBNb2R1bGUgZHJvcHMgdGhlIFMtRVBUIGxvY2suICBJbiBvdGhlciB3b3JkcywgaW1t
ZWRpYXRlbHkgcmV0cnlpbmcgYW5kIHRoZW4gcHVudGluZw0KPiA+ID4gPiB0aGUgcHJvYmxlbSBm
dXJ0aGVyIHVwIHRoZSBzdGFjayBpbiBLVk0gZG9lcyBzZWVtIHRvIGJlIHRoZSBsZWFzdCBhd2Z1
bCAic29sdXRpb24iDQo+ID4gPiA+IGlmIHRoZXJlJ3MgY29udGVudGlvbi4NCj4gPiA+IA0KPiA+
ID4gT2gsIHRoZSBvdGhlciBpbXBvcnRhbnQgcGllY2UgSSBmb3Jnb3QgdG8gbWVudGlvbiBpcyB0
aGF0IGRyb3BwaW5nIG1tdV9sb2NrIGRlZXANCj4gPiA+IGluIEtWTSdzIE1NVSBpbiBvcmRlciB0
byB3YWl0IGlzbid0IGFsd2F5cyBhbiBvcHRpb24uICBNb3N0IGZsb3dzIHdvdWxkIHBsYXkgbmlj
ZQ0KPiA+ID4gd2l0aCBkcm9wcGluZyBtbXVfbG9jayBhbmQgc2xlZXBpbmcsIGJ1dCBzb21lIHBh
dGhzLCBlLmcuIGZyb20gdGhlIG1tdV9ub3RpZmllciwNCj4gPiA+IChjb25kaXRpb25hbGx5KSBk
aXNhbGxvdyBzbGVlcGluZy4NCj4gPiANCj4gPiBDb3VsZCB3ZSBkbyBzb21ldGhpbmcgc2ltaWxh
ciB0byB0ZHBfbW11X2l0ZXJfY29uZF9yZXNjaGVkKCkgYnV0IG5vdCBzaW1wbGUgYnVzeQ0KPiA+
IHJldHJ5aW5nICJYIHRpbWVzIiwgIGF0IGxlYXN0IGF0IHRob3NlIHBhdGhzIHRoYXQgY2FuIHJl
bGVhc2UgbW11X2xvY2soKT8NCj4gDQo+IFRoYXQncyBlZmZlY3RpdmVseSB3aGF0IGhhcHBlbnMg
YnkgdW53aW5kaW5nIHVwIHRoZSBzdGFrIHdpdGggYW4gZXJyb3IgY29kZS4NCj4gRXZlbnR1YWxs
eSB0aGUgcGFnZSBmYXVsdCBoYW5kbGVyIHdpbGwgZ2V0IHRoZSBlcnJvciBhbmQgcmV0cnkgdGhl
IGd1ZXN0Lg0KPiANCj4gPiBCYXNpY2FsbHkgd2UgdHJlYXQgVERYX09QRVJBTkRfQlVTWSBhcyBz
ZWFtY2FsbF9uZWVkYnJlYWsoKSwgc2ltaWxhciB0bw0KPiA+IHJ3bG9ja19uZWVkYnJlYWsoKS4g
IEkgaGF2ZW4ndCB0aG91Z2h0IGFib3V0IGRldGFpbHMgdGhvdWdoLg0KPiANCj4gSSBhbSBzdHJv
bmdseSBvcHBvc2VkIHRvIHRoYXQgYXBwcm9hY2guICBJIGRvIG5vdCB3YW50IHRvIHBvbGx1dGUg
S1ZNJ3MgTU1VIGNvZGUNCj4gd2l0aCBhIGJ1bmNoIG9mIHJldHJ5IGxvZ2ljIGFuZCBlcnJvciBo
YW5kbGluZyBqdXN0IGJlY2F1c2UgdGhlIFREWCBtb2R1bGUgaXMNCj4gdWx0cmEgcGFyYW5vaWQg
YW5kIGhvc3RpbGUgdG8gaHlwZXJ2aXNvcnMuDQoNClJpZ2h0LiAgQnV0IElJVUMgdGhlcmUncyBs
ZWdhbCBjYXNlcyB0aGF0IFNFUFQgU0VBTUNBTEwgY2FuIHJldHVybiBCVVNZIGR1ZSB0bw0KbXVs
dGlwbGUgdGhyZWFkcyB0cnlpbmcgdG8gcmVhZC9tb2RpZnkgU0VQVCBzaW11bHRhbmVvdXNseSBp
biBjYXNlIG9mIFREUCBNTVUuIA0KRm9yIGluc3RhbmNlLCBwYXJhbGxlbCBwYWdlIGZhdWx0cyBv
biBkaWZmZXJlbnQgdmNwdXMgb24gcHJpdmF0ZSBwYWdlcy4gIEkNCmJlbGlldmUgdGhpcyBpcyB0
aGUgbWFpbiByZWFzb24gdG8gcmV0cnkuICBXZSAgcHJldmlvdXNseSB1c2VkIHNwaW5sb2NrIGFy
b3VuZA0KdGhlIFNFQU1DQUxMcyB0byBhdm9pZCwgYnV0IGxvb2tzIHRoYXQgaXMgbm90IHByZWZl
cnJlZC4NCg0KPiANCj4gVGhlIHByb2JsZW1hdGljIHNjZW5hcmlvIG9mIGZhdWx0aW5nIGluZGVm
aW5pdGVseSBvbiBhIHNpbmdsZSBpbnN0cnVjdGlvbiBzaG91bGQNCj4gbmV2ZXIgaGFwcGVuIHVu
ZGVyIG5vcm1hbCBjaXJjdW1zdGFuY2VzLCBhbmQgc28gS1ZNIHNob3VsZCB0cmVhdCBzdWNoIHNj
ZW5hcmlvcw0KPiBhcyBhdHRhY2tzL2JyZWFrYWdlIGFuZCBwYXNzIHRoZSBidWNrIHRvIHVzZXJz
cGFjZS4NCg0KVG90YWxseSBhZ3JlZSB6ZXJvLXN0ZXAgYXR0YWNrIGNhbiBiZSB0cmVhdGVkIEtW
TSBidWcuDQo=
