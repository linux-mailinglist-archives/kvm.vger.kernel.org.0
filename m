Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5476F8187
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 13:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjEELUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 07:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjEELUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 07:20:46 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022299EC5;
        Fri,  5 May 2023 04:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683285645; x=1714821645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AIXLqKDsnH1rSIptngKoBTBXnitBjrJUn8F8fCX9iSw=;
  b=HlhbZNP6lJ+4tv6zgPIl+f1RDdpEY0Oe794aFzzFuIKzoOWHRxu1BtjM
   JnQExqLye5IygvsZgmFJuVW9hyl7Mkq5nZ2PnbFYAPRk3fMW3sEZyr5P/
   XUT7Dmo65ynW7NsWsLj2o+G/eM3z7h0v/6EOowDxVRhtxz/2Td4tYeiRV
   r63159B7Lyz8YOWZeAuPahjsf3gRY+MRIP9RK0fsPTDo+Z1nQm/kdWbsn
   F6sAt+CFeflbGloEHEfJqaDE7k9fT2gIR/x1Tda5iIIm0cbRrL7mBKNsU
   KeHrt+/aWZn7K7MZTkdQVlPDgI6nkvVQdZo2D2PI5MeOoacU3E+VaJXJt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="412416876"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="412416876"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 04:20:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="691632917"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="691632917"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 05 May 2023 04:20:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 5 May 2023 04:20:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 5 May 2023 04:20:43 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 5 May 2023 04:20:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 5 May 2023 04:20:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ce1ig7XNkkH0f2Q21RGCF6qq3F89+j7CJucdtDySGyC6swu8scgZtnRtjlcKdbMNPwOCQ3G89JGrlz53d7ytAUYnjeFxax1V35BeczwHA0HbDxoDJcZAwnhaNjFng/y2QoKgkVN+C4Zed2c9DYmK0dMCYfoQr8XF9KSiEfb5vfntT2clJneFcpNSK7HBndumYVmrjtuAMZVVeY4KMrDcmhYCoQpkMoDtwciTzwLI5YnVEEfdzWuwUBZQpeclglhc7hHa9Yn2Y7nAT6XCjPMZOyVqVf5wPjIYr30G/Fg/t4347mjT4EtGsyEdC8XBsxzCcB84ZDL5BL96T/0EL6LhTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIXLqKDsnH1rSIptngKoBTBXnitBjrJUn8F8fCX9iSw=;
 b=C1ma5ULNmG97IZP0iNp7LJ2/x3xOu8mgoDUqyiBeziq//TIO/+aOTfthsYJ1UXJ7n6zxh2nivyDr/H/DCR4jeBPxrbNDxoZctO6B982/DJoXaj+3CaF0pDYcRb7JjgLYj3Who1PKLMcjG2Cxr87DKGgfhBSxIT1f6k/pTs6TWNNTEPI+qNh9bcK0AIlW1UKVYXR+JYLcoYzZ+m2mKyKZxZukW+Nes96DeX50Jf3D51UzJwY8Bn4cVv2HnXWGz7FF9ivgHL30hgwpQAOVek2dKpIFqW/UzqAaBhSAVGj+SraRWFQkEUvclZBUF2ZeGxQ5INd3vKMuvxbXnjO3vywOCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7659.namprd11.prod.outlook.com (2603:10b6:510:28e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Fri, 5 May
 2023 11:20:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 11:20:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH 2/5] KVM: SVM: Use kvm_pat_valid() directly instead of
 kvm_mtrr_valid()
Thread-Topic: [PATCH 2/5] KVM: SVM: Use kvm_pat_valid() directly instead of
 kvm_mtrr_valid()
Thread-Index: AQHZfe1f0rO3GrjwtE6wZCgIpENwna9JK0yAgAEUz4CAAUtFgA==
Date:   Fri, 5 May 2023 11:20:39 +0000
Message-ID: <fa16b58fb9a8a0a3ad192963a66e327e74b387e5.camel@intel.com>
References: <20230503182852.3431281-1-seanjc@google.com>
         <20230503182852.3431281-3-seanjc@google.com>
         <06715227566b520d4a445466f091dc28a0b8cd95.camel@intel.com>
         <ZFPQodNs0Cn9YDXT@google.com>
In-Reply-To: <ZFPQodNs0Cn9YDXT@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB7659:EE_
x-ms-office365-filtering-correlation-id: ae55e0b4-c703-4ecc-67d2-08db4d5ac1f5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VDfGSmLGrjydCgAak4V/mLMA0/sBunISWd8aDB0e9U79Iku5lwELQm01jyJqDZ0B6932LVhRsjcWMOpJjUTha1uf7fDLcayTeMLYEKb5bcmYEOU6FMOkU4nTcC8iue1TAIvx8L79siaxWWv9EBmjb77+RypnApP5BmVAlWiLr+Bxk3+PkIxl2Fe9U+1n450+pU5HB1xp9rIS+z8dCPGlY3S6pkc4RI2wDriekMf3XmbmX6JVsl5sTgPuslQcOmzBF0rdjGBgOB283e2YXnbKmqCYtnj1iM6KA22aqIBghmVUBWJ3N96Pp4vYLb/89AT2pvEmOyye8Px6V/gjjHFz+xcci2KGi+fFEL8KRrlgeb5EPTR2BefP6pVQ6RO7SjRa7DK5Bka2jsNMgElf0Esc7lVZHmNTeP6PqMZwHj3n/pT3s0KelLlJktatYg/Tdjxa6ixQsQiI1bW/77uffTG+KOhff9J7l59zg6UzFBiTAVjan9X+F2YlArodsrA4k4R1/l394UK3WUcSe0qDbV6k8D7ajJa9gGsuqTCJdYpYNEqfRKiDTdt9kgyh1fq2qra0aQYiuynL1qHGohiv1/vznPyl/j0kFTm8DTqnZO305dR4YEiZE7t6qhdsvUzdjGj7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199021)(38100700002)(8676002)(8936002)(5660300002)(83380400001)(2906002)(82960400001)(36756003)(316002)(38070700005)(6916009)(66556008)(66946007)(4326008)(6506007)(91956017)(76116006)(26005)(66446008)(64756008)(66476007)(6512007)(2616005)(71200400001)(54906003)(41300700001)(6486002)(122000001)(186003)(86362001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWJ3UFQzMnJmYzRya2Z2aWtTT1JscHVuOGVkUVJUSldBcHdUeGoyWTNWTUtu?=
 =?utf-8?B?Wm83bVJjclAwZUpQdHFEOCtEL3JKTlZLMDIxQmZtaHlMMldNM0xUeGFkd0ZW?=
 =?utf-8?B?VmVYVG80UWU2emFoazN0ZUxXdTdxcGIrM0VNckU2ZGQ1RVVGZFVwOGpxZzFh?=
 =?utf-8?B?T3JaQkRCOEpWYUh3YlhSaDNCSGtFQkI4a1B4Mk8vOUFLeW0yMHBNV0J5QkZu?=
 =?utf-8?B?OXJpb0YrdDBMREd5WkdvKzA4bWRMSlprWnk3dmk1QjJqZ2NQTGM4N3JRSWMz?=
 =?utf-8?B?azdNZmdXbjdrVGtNdDV2ektaOHNKM1RtWklsa20zR1J5S29nQnBuNzFpNnho?=
 =?utf-8?B?VUJRSlBGNFdZL3FoRjNid3JMUFJsaCtoVnhQcU8xRWM1WWZERC9DRW9MNGM1?=
 =?utf-8?B?R291VStkNVA1TkdsUWMwTmRaQlpxVlVPSjZNOXJXenBqWk9GQ3hwZnhteHd5?=
 =?utf-8?B?b29pMUNPM3dJVUI4R2cyVjNxZ0kzZllzcGQyWEJkU28xTmxDMThhNXdHQ3ZR?=
 =?utf-8?B?SDEzbDZXcW5lRWJEUDdxQmhFWnQwRzRySWZzOUV3UnYxUEY1U1Bocm1GenRu?=
 =?utf-8?B?UldjM3UwN2FTSmk3RHVIMXRyOE1XSGhoTkpxMU5MNk94ZDJFaHZaSWZKZits?=
 =?utf-8?B?bS9DYTEzR1VqUVZRZWk5Mno0VE5zWEkvbFliaUF6bTZWMU1ZQVJRMWo4bXA3?=
 =?utf-8?B?a0lzRVd1aExERCtyNEpBVGFpVkdNWWg1Y3dyRFlheFVncDY0WUR0TjMwWXhQ?=
 =?utf-8?B?bEM1N2l0b3cyRTh0S0V2NUJMSEtjanZUaU51bXVvbFAxZEN2Y3hTZ05kbHhI?=
 =?utf-8?B?YjJoRENZVmY3WFVGUGhuRUJxbmsrZk40QXJxcS8vUVNKcTBFSkJQc1lRVG9I?=
 =?utf-8?B?bFk5M3FTaHNDVXpBcGJ5Vnp3M25tWFRzZndjTUo4SUU0YkFZUUVYTFFjZXkz?=
 =?utf-8?B?aVVCMU5lRzlwVVlrZ1lZUFJYdDBxaHdCa0tobGE3RlU5UFJEOVVOZ0ZuU1Vm?=
 =?utf-8?B?Z2h0RFVKbmdtZWt4NklBdHYxWm5aQStnZ1RDaHA0VnF0YUtLMk5oUzdjdHFt?=
 =?utf-8?B?S056alZvL29NSXdndjI1aU1pYkFUaTFUdHpMRDBHUG0raEJ2WjBRQXNSVkdU?=
 =?utf-8?B?ZElMbUd0UE9IWlNiY3U1TTZKdzBmdkF5SHVhRklTb0RhdTYyS3VJalJOTnQr?=
 =?utf-8?B?QUtsbjdmSVVSMVBqSFpKTEQxL2RSOTg5d3ZhelFSbmgwR3hSV294TnNEMjVy?=
 =?utf-8?B?SlJVYU8xdHErVU4xbW5ueTFlTzFSeWd3Y3NtdjVTTUx3NXVabFpzMnZvNEVZ?=
 =?utf-8?B?ZjlhTWJOYlIwTURrTWVVWHBPTGhFL3kxcXJsbzZEL1JDVFlGTUpycDNQT0FU?=
 =?utf-8?B?ajM3Qmw0STd4L0VPZG9KbVJ3c3ZxeVJLZHhQYVFiNVQ2a0hFbC9zc0JpdlBz?=
 =?utf-8?B?Sk1xa0ZhTnZFVDFIaHd2bUkvaU83MnlwK0pkbGRPTnpNbUVSU21zYzFKSTBj?=
 =?utf-8?B?V3g2WGZwbm10a2tNcWV3ZzZpQ2lyeGVBOHhvQmtYOGJnREtTZlJST1lWSG1w?=
 =?utf-8?B?QzJraDZEMFlIUG1WV3dqT1pFRGJhZEQ4MjZjV0V0ZUVoOTVxV3NVZjhFUjhY?=
 =?utf-8?B?QlIvYUN2alYwVk95NnozSXNYZFZUdHZGYTY4cGs0Y2NtYjRDSUhvTUhZdWZI?=
 =?utf-8?B?eGVPMmxQM3pYVXc1alVRTEZqYWpScFdEWUtIQUxnS0tLM2xxK2dxVEcrQTN3?=
 =?utf-8?B?MW4xWk93eUk3NXhzODMvclFzMHRiLzZaVGZSbWEvSlpyb0Z2bHpNZ1c2M3Ev?=
 =?utf-8?B?ZmU5V0p1OVVTM3R5QS80WFRmdXNyYkExUnh2eVNweUZUV3FBRXBCK2lNTUVB?=
 =?utf-8?B?QlN4M3pWcG5PZUd2eVYwSVBrYlpVMXpTRy95UjhSZnJXOWR1eERVTkRyMDU0?=
 =?utf-8?B?aWp3UzVYemxPK1hLRCs1UFFkc2ZmTmFuWEVtLy9SeXd4RW05SkpmUjYrL0My?=
 =?utf-8?B?Zmw1MXlYRVpEMnBURlhTMysxTXU2QjFMNndZRGs0dERPNTFLRlJhODNOQklP?=
 =?utf-8?B?R01rYVJDK2JyaG1iR2V6VTBTSUdPU3Vzcm91QTgvZXR2YWYzZzBRaDQ2TXR2?=
 =?utf-8?Q?/JhX9w0ykGgODZc1heYvxS9hi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F45425143E1D745B7522C78CAA61FE4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae55e0b4-c703-4ecc-67d2-08db4d5ac1f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2023 11:20:39.9285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JDQ+JzLaGWQtihFw+2mM2BZa8xWepIQAEh9Sd9UR8cg08hIExC4Hmtv2Vks1sKhVWruMSLR/yh9c92vir/plSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7659
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA1LTA0IGF0IDA4OjM0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1heSAwMywgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gZm9y
IGJldHRlciBvciB3b3JzZSwgS1ZNIGRvZXNuJ3QgYXBwbHkgdGhlICJ6YXANCj4gPiA+IFNQVEVz
IiBsb2dpYyB0byBndWVzdCBQQVQgY2hhbmdlcyB3aGVuIHRoZSBWTSBoYXMgYSBwYXNzdGhyb3Vn
aCBkZXZpY2UNCj4gPiA+IHdpdGggbm9uLWNvaGVyZW50IERNQS4NCj4gPiANCj4gPiBJcyBpdCBh
IGJ1Zz8NCj4gDQo+IE5vLiAgS1ZNJ3MgTVRSUiBiZWhhdmlvciBpcyB1c2luZyBhIGhldXJpc3Rp
YyB0byB0cnkgbm90IHRvIGJyZWFrIHRoZSBWTTogaWYgdGhlDQo+IFZNIGhhcyBub24tY29oZXJl
bnQgRE1BLCB0aGVuIGhvbm9yIFVDIG1hcHBpbmcgaW4gdGhlIE1UUlJzIGFzIHN1Y2ggbWFwcGlu
Z3MgbWF5DQo+IGJlIGNvdmVyYWdlIHRoZSBub24tY29oZXJlbnQgRE1BLg0KPiANCj4gRnJvbSB2
bXhfZ2V0X210X21hc2soKToNCj4gDQo+IAkvKiBXZSB3YW50ZWQgdG8gaG9ub3IgZ3Vlc3QgQ0Qv
TVRSUi9QQVQsIGJ1dCBkb2luZyBzbyBjb3VsZCByZXN1bHQgaW4NCj4gCSAqIG1lbW9yeSBhbGlh
c2VzIHdpdGggY29uZmxpY3RpbmcgbWVtb3J5IHR5cGVzIGFuZCBzb21ldGltZXMgTUNFcy4NCj4g
CSAqIFdlIGhhdmUgdG8gYmUgY2FyZWZ1bCBhcyB0byB3aGF0IGFyZSBob25vcmVkIGFuZCB3aGVu
Lg0KPiANCj4gVGhlIFBBVCBpcyBwcm9ibGVtYXRpYyBiZWNhdXNlIGl0IGlzIHJlZmVyZW5jZWQg
dmlhIHRoZSBndWVzdCBQVEVzLCB2ZXJzdXMgdGhlDQo+IE1UUlJzIGJlaW5nIHRpZWQgdG8gdGhl
IGd1ZXN0IHBoeXNpY2FsIGFkZHJlc3MsIGUuZy4gZGlmZmVyZW50IHZpcnR1YWwgbWFwcGluZ3MN
Cj4gZm9yIHRoZSBzYW1lIHBoeXNpY2FsIGFkZHJlc3MgY2FuIHlpZWxkIGRpZmZlcmVudCBtZW10
eXBlcyB2aWEgdGhlIFBBVC4gIE15IGhlYWQNCj4gaHVydHMganVzdCB0aGlua2luZyBhYm91dCBo
b3cgdGhhdCBtaWdodCBpbnRlcmFjdCB3aXRoIHNoYWRvdyBwYWdpbmcgOi0pDQo+IA0KPiBFdmVu
IHRoZSBNVFJScyBhcmUgc29tZXdoYXQgc2tldGNoeSBiZWNhdXNlIHRoZXkgYXJlIHRlY2huaWNh
bGx5IHBlci1DUFUsIGkuZS4NCj4gdHdvIHZDUFVzIGNvdWxkIGhhdmUgZGlmZmVyZW50IG1lbXR5
cGVzIGZvciB0aGUgc2FtZSBwaHlzaWNhbCBhZGRyZXNzLiAgQnV0IGluDQo+IHByYWN0aWNlLCBz
YW5lIHNvZnR3YXJlL2Zpcm13YXJlIHVzZXMgY29uc2lzdGVudCBNVFJScyBhY3Jvc3MgYWxsIENQ
VXMuDQoNCkFncmVlZCBvbiBhbGwgYWJvdmUgb2Rkcy4NCg0KQnV0IEkgdGhpbmsgdGhlIGFuc3dl
ciB0byBteSBxdWVzdGlvbiBpcyBhY3R1YWxseSB3ZSBzaW1wbHkgZG9uJ3QgX25lZWRfIHRvIHph
cA0KU1BURXMgKHdpdGggbm9uLWNvaGVyZW50IERNQSkgd2hlbiBndWVzdCdzIElBMzJfUEFUIGlz
IGNoYW5nZWQ6DQoNCjEpIElmIEVQVCBpcyBlbmFibGVkLCBJSVVDIGd1ZXN0J3MgUEFUIGlzIGFs
cmVhZHkgaG9ybmVkLiAgVk1DUydzIEdVRVNUX0lBMzJfUEFUDQphbHdheXMgcmVmbGVjdHMgdGhl
IElBMzJfUEFUIHRoYXQgZ3Vlc3Qgd2FudHMgdG8gc2V0LiAgRVBUJ3MgbWVtdHlwZSBiaXRzIGFy
ZQ0Kc2V0IGFjY29yZGluZyB0byBndWVzdCdzIE1UUlIuICBUaGF0IG1lYW5zIGd1ZXN0IGNoYW5n
aW5nIElBMzJfUEFUIGRvZXNuJ3QgbmVlZA0KdG8gemFwIEVQVCBQVEVzIGFzICJFUFQgUFRFcyBl
c3NlbnRpYWxseSBvbmx5IHJlcGxhY2VzIGd1ZXN0J3MgTVRSUnMiLg0KDQoyKSBJZiBFUFQgaXMg
ZGlzYWJsZWQsIGxvb2tpbmcgYXQgdGhlIGNvZGUsIGlmIEkgcmVhZCBjb3JyZWN0bHksIHRoZQ0K
J3NoYWRvd19tZW10eXBlX21hc2snIGlzIDAgZm9yIEludGVsLCBpbiB3aGljaCBjYXNlIEtWTSB3
b24ndCB0cnkgdG8gc2V0IGFueSBQQVQNCm1lbXR5cGUgYml0IGluIHNoYWRvdyBNTVUgUFRFLCB3
aGljaCBtZWFucyB0aGUgdHJ1ZSBQQVQgbWVtdHlwZSBpcyBhbHdheXMgV0IgYW5kDQpndWVzdCdz
IG1lbXR5cGUgaXMgbmV2ZXIgaG9ybmVkIChndWVzdCdzIE1UUlJzIGFyZSBhbHNvIG5ldmVyIGFj
dHVhbGx5IHVzZWQgYnkNCkhXKSwgd2hpY2ggc2hvdWxkIGJlIGZpbmUgSSBndWVzcz8/ICBNeSBi
cmFpbiByZWZ1c2VkIHRvIGdvIGZ1cnRoZXIgOikNCg0KQnV0IGFueXdheSBiYWNrIHRvIG15IHF1
ZXN0aW9uLCBJIHRoaW5rICJjaGFuZ2luZyBndWVzdCdzIElBMzJfUEFUIiBzaG91bGRuJ3QNCnJl
c3VsdCBpbiBuZWVkaW5nIHRvICJ6YXAgU1BURXMiLg0K
