Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BC86FDC03
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 12:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbjEJK4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 06:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbjEJKzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 06:55:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC46A243;
        Wed, 10 May 2023 03:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683716097; x=1715252097;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JaF4HjlymlIOpnzvNA0npEQGBf4eBCuFls4hHe4AaP4=;
  b=bkhXs2Af95kJQ764P8lTIQAdkuKPElbdziYwKMxbAFv6bvWbfo2Pzhu8
   NXVIVWnM9HAXLk5YrRDB3O4tZALc3JLXxcbL5vtUF1WqSDIUAi/nW1ewl
   cHIinB75rXpejKCH4MlckN/DSbfAz1PNjnr6YmACvJs72qLTLc60fAsp3
   OZTqc9HVhmKBEMR4VZqvpUf71Z0pPy95TVI+vrjP28goWN+x9YuV/vjgB
   Dc47GCGBfG8LeMCqsXD7za/fqZs/sf1gko4HyhOuBFWi6j/70+xem7MQk
   QM6weOMuDzwyFMoqpQOlYBng3aq4V9Cg7PeTCTBFYcFH2fXq+aU5reZeD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="334649656"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="334649656"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 03:54:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="843460227"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="843460227"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 10 May 2023 03:54:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 03:54:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 03:54:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 03:54:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 03:54:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PD3iv97hEUZSGAD8CGKzFbIEPDv25ukSxK6qERrXdK35pQ+3VmgMPtfqh6vDedfBNTrQkNVT6dj9jJ5kZkPuq1TMJJVHYziSQO5HiEn2pTf9GVYkaHQs0nE81hAiLgS18UgkYyeTIMIE5gufjBuJcWkKd8JefX7Up0PpgGb1pbGDJ8FOQxfNHGwmFYqU67LpxqlFTSBeN5uqI3e7llnQx3mKrkigSr5SC3OoRwBL+TvLpHyd8JHQ8SlWa8JyR6JYvBx2mFAsgBwhz7O+gCFhzxTVVWTqbwu4LmdjErYogvatR3hZOgWt8rUPLMYyT+aDQ+/E4rIvyQFlWjE1LRw6Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JaF4HjlymlIOpnzvNA0npEQGBf4eBCuFls4hHe4AaP4=;
 b=EC1vo9nBujb2zdZ/jEWr7vz/oTVUZ/uSqgngf73ZcePtyKM+TRv0xoHG+puk/JZmr9ARB+svRvwzublYoMEKZb/RVKU9HMLBUzu90z3PQInlYZJYRShw9cXWEn0hDjcsOBAxFZ3yJS9iXfcWe6nQ6N6UjXKHCBNjl+AOET4IgkqkueDXfnZ4j+0T7vJO6u/DocHR5m1PBAA3CtnBffKbS8hgfEAi/38XUBu7FkOOiDsXwjwNZJi4q6psityFEshugdh5kbxFUGERc0nIeB1mmOpzoZNZIL4wqSBMamPbbA/yACkgg5OYVfJwVHa97IKO920+NveclesgCM46+uLokg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7722.namprd11.prod.outlook.com (2603:10b6:610:122::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 10:54:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 10:54:51 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: only zap EPT when guest MTRR changes
Thread-Topic: [PATCH v2 3/6] KVM: x86/mmu: only zap EPT when guest MTRR
 changes
Thread-Index: AQHZgoDvHvtjWxAbgUSEtQq61PPuVa9S/o2AgAAndwCAADCnAA==
Date:   Wed, 10 May 2023 10:54:51 +0000
Message-ID: <99c982ed53f0dd7e0723f566b5527091b7e4e54c.camel@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
         <20230509135143.1721-1-yan.y.zhao@intel.com> <ZFsuDWwoKRA0W2/j@chao-email>
         <ZFtPKLvblLcxPvZQ@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZFtPKLvblLcxPvZQ@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7722:EE_
x-ms-office365-filtering-correlation-id: 6f14833e-8b33-4991-609c-08db5144facd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iEGr8zwb5qmPagmwNfZnv15H/gRjw5dxkMK0G+H44qGz9bpEo+/0joh6GybTNjzZ/cStlKJ3y8CIKwsBTm4wnS0ZfdqfZM/I9MpBHddt6SIUVBYuCrQxCcsLu4IdJhDSFiWh+VWg8qmG4qQx4X6ecxwo8TMSEIAk8m2lOa08/fcZmPgYF4DkKY86odHwG3azHvLeNjMInQseNaCXX6bYy2BypePPfqdzOVnh7TXNbrNnkNslzRGIFolfXYEebd97WnSWzf6V7pJdI9mEvcx0tLCVwxmmlxGJQBcv2mMvHyyvV+XKzQNM6E6hHtxc9Sw2rNZ2YXNVJDGFA4tmk5u+SxuPrrpYruLoqqzo3yTuiB+xvIWTXR432Yx2O0uf+OZJMJ4H0aEW6Xm1b18obPvD8lQ/zbIe9iDab6xHbuKssEAsnYO0UwCfCYG2beua+2rhF/kPNZci+DhG6bMTchR3KIcbhC+YwfA6X43K4CWB7X+NstwwruK68b4966hm/LpPmdwgJG9hL2lFsMq6c9UHgoz8Hp1LVLdOgh6eSYFyr9zt16ZlYKAw8RwHun74m6SYQxYDGnOcExXNzRCOXJIzTjOa7ryrawuPWtPwJiOE2kPEU43fqMsn31LdfvGaBtI6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(366004)(376002)(396003)(451199021)(71200400001)(6506007)(6512007)(64756008)(4326008)(66476007)(66446008)(66556008)(6636002)(76116006)(66946007)(91956017)(316002)(6486002)(41300700001)(110136005)(478600001)(54906003)(26005)(8676002)(8936002)(5660300002)(86362001)(186003)(83380400001)(2906002)(38070700005)(2616005)(38100700002)(82960400001)(122000001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGhCSDdVOWJ6ZGZHUUdXZG1PRzZLRzRLTnNzNUFzMVRXcnFMWXdTNzBlRWxB?=
 =?utf-8?B?K29SYVczaXZycnNtYnFYRk5UY2tlNmRiUmNaK2g3NXprdzJVNjZEZ0ZsQ3JI?=
 =?utf-8?B?Q2IyWmNhNkpNSlJrblZaOHVhNEdINzBEL1pZV3lMMWtqSzQ2MGhyNGxsUml0?=
 =?utf-8?B?bmwya2NaTTA0T2ZITTBjSUw1Qk9obTN5OG45dENudmhNUE9YVHR2cWw1WWhh?=
 =?utf-8?B?ZmxQUWFPRFlTV1VaVnNySUdlSG9qZzBwYlZSUERlc3pRYTF6Wm1qL24wNmdG?=
 =?utf-8?B?M3pCRDY1azQxL0xOOEhkd3FQaFp5c0lGeG12QWNiVStpSm1hQjg5NmVQRzlO?=
 =?utf-8?B?VU1xdDh4VzN5eU9vbkIzRWIwcDMvMUR4dWd0d0M3L3d1M2M4QitNZzgyVUZz?=
 =?utf-8?B?bEQ4OUxVd1BtQ1FTOGZBbzRLQ3VCdG0zM2huWXlINFovdlJ1YUdOMUJJeGdC?=
 =?utf-8?B?dU1jTnBONjg5cUNXNDdEL3d4MGozZ3AweHFGZVFVOVp4cnVKUVY3b3JHUHNh?=
 =?utf-8?B?RmkrUE5RSWN2YktTUmxmMDI3aFM0ZG1nYzlvN1BSbytKTnhHdlVMYy9GT3Rh?=
 =?utf-8?B?bHUxOHdjWlhwd3RIblhPMHN5QTJvMmNtc2RIc3JWTkJHcFA0RjdKS2dkd1Mr?=
 =?utf-8?B?cVY4RVRqdzgrc005QzI2NkF5L2hJY0dGcW9uTzJKa1dZeW16TzFOeEtlRGNZ?=
 =?utf-8?B?NHZBRzZiU215SzNDUHNkTGN4ZHJoejF5R2Y1L2dScW1GdnFkZHZhVSt1U0h6?=
 =?utf-8?B?blhhNU82eEwyaEdqdWErSVNNN1NTNVhpOW5KMHJjc01VWVJYdm9LSzVQamxG?=
 =?utf-8?B?ek9LaGMxaWx2Y2czY09LQm5iYVNBaU0yVU03eXpVL1FmN1FoejljYlMvVWJs?=
 =?utf-8?B?QWdtOVljb1lyQ0M5d2ZZWit5aEhud3ZrbHdmb0NUaVpsUExYSHZ1eFZJSTg3?=
 =?utf-8?B?RWllSGNSTDNHRUo3ZTBMd25PWFA5ZWhHR0J1aTRFc3BNYzBvNWp5TExQU2c4?=
 =?utf-8?B?RTJlR3hPYldIUnd1OVk1anpCamQ1T3B4RERUWkpRbzNpQ05vLzdOK2dMWnRi?=
 =?utf-8?B?UlgyM0FZRGVTYUYwck1uYkpuenVHdjN5dlBVMTlNam4vV2E0TnJCVlZQeWlB?=
 =?utf-8?B?bzF5bm9EY0g1V0U0MmxYUnZhcmZ0WUZSdXI4eWNHZ2hwZHVta3pDSHowckRQ?=
 =?utf-8?B?dWFyMVVnbTdVZy9BYlFnTlhibjZzdSsyOXFWRU13NDBwc01lTmdPa3ZHalBV?=
 =?utf-8?B?SGtVbTJDUnFlREgzL1hrWHBmQ2pkVVdCWlFJNExTQW9ZNm1ZcktrYk1sRHdn?=
 =?utf-8?B?OVZOVkhNOWtXcitQSDB0d3lpZTZzdndOeVhaS2hYSWxldW41bUQwMTczYlFF?=
 =?utf-8?B?Y2hxZVFJWEdJd1lJQ1d1NWhUZWNlR1RPL3lqbVRMSSt2YzJLb01JdG9Tekww?=
 =?utf-8?B?Qmtvd3QvRytWUy9KVyt0bmlSWWNEdURvUnVzK1FwRFFhVWZzRTdTR2k1Vm4x?=
 =?utf-8?B?dDkraWVMbU1hSXhmTjVQd1hEa2RtdGhhVHYydGVTVnhRLytyTG81ZGtLY2l2?=
 =?utf-8?B?aHVYc3ZSMTlPZndySjNhQVVTZU9FcEllQ0tBeTcrVUprUjE3WXRjK0RlUkp1?=
 =?utf-8?B?SmFKblBXbFpra0NnQXdBRlRqTnhWazJ4b1VUTzhMS2U1TERHYTVIbnBZdXRG?=
 =?utf-8?B?eFFaYlh4V2Z5Vk9xLzNDbTEyemRmODhROTNZT2g3SStTMGljbGtSU3FDZklQ?=
 =?utf-8?B?UmZCeDdSbWxjMENTdkFFb0liRDdTaGE1RzhxdkNoQXU4NHkyaW04bDU2REt5?=
 =?utf-8?B?ZkVXd29FVjNSQ3pOUEEvTHdhV3N5WWJmQ1Fab3NrZ1hTdzNYbzllMkU3blp4?=
 =?utf-8?B?S2FOZjl6RTZqeG9CeXltaVJoTUhhc29hZnBBZDM1ZXBJai9PN1dGeWJCditO?=
 =?utf-8?B?L0RwVkh5OXBNK0hFRDVNakZTaEtPSzFTUWwyK1Vhb05WYmZWK0I0OWtwN0Ns?=
 =?utf-8?B?YnZTeDgwY3dXblRHZExhalIwOTREdUdaMEphV3lXZG95NG9jVkdaS1pnS1Ju?=
 =?utf-8?B?RVhONFpXTEg2NkZPTDBQYm55NkRjV0VwNkdoaWFjSU1SamFsNHNOcnRzY0p3?=
 =?utf-8?Q?5XYwul60trTKrq596AQd4mIDp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F1D878899F1644A8D45C68998F4C803@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f14833e-8b33-4991-609c-08db5144facd
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 10:54:51.0250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YCvtxeA0z7V9sBM82Yn99NHr9wYQbhUmmK6ytiDTGW2275/Fb+2U5u6lSr0zHGq8N/xUOBSkDSVM7t7GOTO63g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7722
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTEwIGF0IDE2OjAwICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
V2VkLCBNYXkgMTAsIDIwMjMgYXQgMDE6Mzk6MjVQTSArMDgwMCwgQ2hhbyBHYW8gd3JvdGU6DQo+
ID4gT24gVHVlLCBNYXkgMDksIDIwMjMgYXQgMDk6NTE6NDNQTSArMDgwMCwgWWFuIFpoYW8gd3Jv
dGU6DQo+ID4gPiBDYWxsIG5ldyBoZWxwZXIga3ZtX3phcF9nZm5fZm9yX21lbXR5cGUoKSB0byBz
a2lwIHphcCBtbXUgaWYgRVBUIGlzIG5vdA0KPiA+ID4gZW5hYmxlZC4NCj4gPiA+IA0KPiA+ID4g
V2hlbiBndWVzdCBNVFJSIGNoYW5nZXMgYW5kIGl0J3MgZGVzaXJlZCB0byB6YXAgVERQIGVudHJp
ZXMgdG8gcmVtb3ZlDQo+ID4gPiBzdGFsZSBtYXBwaW5ncywgb25seSBkbyBpdCB3aGVuIEVQVCBp
cyBlbmFibGVkLCBiZWNhdXNlIG9ubHkgbWVtb3J5IHR5cGUNCj4gPiA+IG9mIEVQVCBsZWFmIGlz
IGFmZmVjdGVkIGJ5IGd1ZXN0IE1UUlIgd2l0aCBub25jb2hlcmVudCBETUEgcHJlc2VudC4NCj4g
PiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogWWFuIFpoYW8gPHlhbi55LnpoYW9AaW50ZWwuY29t
Pg0KPiA+ID4gLS0tDQo+ID4gPiBhcmNoL3g4Ni9rdm0vbXRyci5jIHwgMiArLQ0KPiA+ID4gMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gPiANCj4gPiA+
IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbXRyci5jIGIvYXJjaC94ODYva3ZtL210cnIuYw0K
PiA+ID4gaW5kZXggOWZhYzFlYzAzNDYzLi42MmViYjk5NzgxNTYgMTAwNjQ0DQo+ID4gPiAtLS0g
YS9hcmNoL3g4Ni9rdm0vbXRyci5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9rdm0vbXRyci5jDQo+
ID4gPiBAQCAtMzMwLDcgKzMzMCw3IEBAIHN0YXRpYyB2b2lkIHVwZGF0ZV9tdHJyKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgdTMyIG1zcikNCj4gPiA+IAkJdmFyX210cnJfcmFuZ2UoJm10cnJfc3Rh
dGUtPnZhcl9yYW5nZXNbaW5kZXhdLCAmc3RhcnQsICZlbmQpOw0KPiA+ID4gCX0NCj4gPiA+IA0K
PiA+ID4gLQlrdm1femFwX2dmbl9yYW5nZSh2Y3B1LT5rdm0sIGdwYV90b19nZm4oc3RhcnQpLCBn
cGFfdG9fZ2ZuKGVuZCkpOw0KPiA+ID4gKwlrdm1femFwX2dmbl9mb3JfbWVtdHlwZSh2Y3B1LT5r
dm0sIGdwYV90b19nZm4oc3RhcnQpLCBncGFfdG9fZ2ZuKGVuZCkpOw0KPiA+IA0KPiA+IEkgYW0g
d29uZGVyaW5nIGlmIHRoZSBjaGVjayBvZiBzaGFkb3dfbWVtdHlwZV9tYXNrIChub3cgaW5zaWRl
IHRoZQ0KPiA+IGt2bV96YXBfZ2ZuX2Zvcl9tZW10eXBlKCkpIHNob3VsZCBiZSBtb3ZlZCB0byB0
aGUgYmVnaW5uaW5nIG9mIHVwZGF0ZV9tdHJyKCkuDQo+ID4gQmVjYXVzZSBpZiBFUFQgaXNuJ3Qg
ZW5hYmxlZCwgY29tcHV0aW5nIEBzdGFydC9AZW5kIGlzIHVzZWxlc3MgYW5kIGNhbiBiZQ0KPiA+
IHNraXBwZWQuDQo+IA0KPiBObywgc2hhZG93X21lbXR5cGVfbWFzayBpcyBub3QgYWNjZXNzaWJs
ZSBpbiBtdHJyLmMuDQo+IEl0J3MgYmV0dGVyIHRvIGNvbmZpbmUgaXQgaW4gbW11IHJlbGF0ZWQg
ZmlsZXMsIGUuZy4gbW11L21tdS5jLA0KPiBtbXUvc3B0ZS5jDQo+IA0KDQpObywgSSB0aGluayBp
dCBzaG91bGQgYmUgc2hhZG93X21lbXR5cGVfbWFzay4NCg0KQ29uY2VwdHVhbGx5LCBhZnRlciBj
b21taXQgMzhiZjlkN2JmMjc3ICgiS1ZNOiB4ODYvbW11OiBBZGQgc2hhZG93IG1hc2sgZm9yDQpl
ZmZlY3RpdmUgaG9zdCBNVFJSIG1lbXR5cGUiKSwgSSBiZWxpZXZlIGluIHVwZGF0ZV9tdHJyKCkg
dGhlIGNoZWNrOg0KDQoJaWYgKG1zciA9PSBNU1JfSUEzMl9DUl9QQVQgfHwgIXRkcF9lbmFibGVk
IHx8DQogICAgICAgICAgICAgICFrdm1fYXJjaF9oYXNfbm9uY29oZXJlbnRfZG1hKHZjcHUtPmt2
bSkpDQogICAgICAgICAgICAgICAgcmV0dXJuOw0KDQpzaG91bGQgYmU6DQoNCglpZiAobXNyID09
IE1TUl9JQTMyX0NSX1BBVCB8fCAhc2hhZG93X21lbXR5cGVfbWFzayB8fA0KICAgICAgICAgICAg
ICAha3ZtX2FyY2hfaGFzX25vbmNvaGVyZW50X2RtYSh2Y3B1LT5rdm0pKQ0KICAgICAgICAgICAg
ICAgIHJldHVybjsNCg0KQmVjYXVzZSB0aGUgaW50ZW50aW9uIG9mICdzaGFkb3dfbWVtdHlwZV9t
YXNrJyBpcyB0byB1c2UgaXQgYXMgYSBkZWRpY2F0ZWQNCnZhcmlhYmxlIHRvIHJlcHJlc2VudCBo
YXJkd2FyZSBoYXMgY2FwYWJpbGl0eSB0byBvdmVycmlkZSB0aGUgaG9zdCBNVFJScyAod2hpY2gN
CmlzIHRoZSBjYXNlIGZvciBFUFQpLCBpbnN0ZWFkIG9mIHJlbHlpbmcgb24gVERQIGJlaW5nIGVu
YWJsZWQuDQoNClRoYXQgYmVpbmcgc2FpZCwgdG8gbWUgaXQncyBtb3JlIHJlYXNvbmFibGUgdG8g
aGF2ZSBhIHNlcGFyYXRlIHBhdGNoIHRvIHJlcGxhY2UNCnRoZSAnIXRkcF9lbmFibGVkJyBjaGVj
ayB3aXRoICchc2hhZG93X21lbXR5cGVfbWFzaycgaW4gdXBkYXRlX210cnIoKSwgcGVyaGFwcw0K
d2l0aCBhIEZpeGVzIHRhZyBmb3IgY29tbWl0IDM4YmY5ZDdiZjI3Ny4NCg0KVGhlIGt2bV96YXBf
Z2ZuX3JhbmdlKCkgc2hvdWxkIGJlIHJlbWFpbiB1bmNoYW5nZWQuDQoNCkZvciB0aGUgcHJvYmxl
bSB0aGF0IHNoYWRvd19tZW10eXBlX21hc2sgaXNuJ3QgYWNjZXNzaWJsZSBpbiBtdHJyLmMgSSB0
aGluayB5b3UNCmNhbiBpbmNsdWRlICJtbXUvc3B0ZS5oIj8NCg0KPiANCg==
