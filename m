Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6731C58B315
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 02:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241525AbiHFAt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 20:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiHFAt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 20:49:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996286E8B4;
        Fri,  5 Aug 2022 17:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659746997; x=1691282997;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U+LbnPMVVAcIbqzFOacbskZL5gdc7FxL40ma63ETbfQ=;
  b=GXADo9RP9HNK59RbsEUJZhqk/7JaaMzaG5ch9ZeCFqcmWMEZS/qTLTZG
   5ZuzvrjVZrPKMeOA0CfDozkAkCowytYcwWTNn8QQGXiPq0h3GccGMeTir
   7xLdYjZiuPNX5MBcNtP9UkViyHTRDk6AE2Ut/4TVyeOQtalpY88SJK6rz
   VyPAraF39gsxW1X4dC6TiYjUN5s7jTZjhtJR8HVtOns109MAVaxW1eAxz
   n5MHwPm5jaNw2aGNyt+7yAIbWpDVCiSzOh9NBwgSwu3q3Y9kpRoFUAUjc
   R+mi1ivj6kGrcvYaSFLrIgeChT2O7Qh6nFKfFuzQZBUNMEl9rjK9KsPhv
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="287886139"
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="287886139"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 17:49:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="931418214"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 05 Aug 2022 17:49:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 17:49:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 17:49:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 5 Aug 2022 17:49:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 5 Aug 2022 17:49:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTFEFem/mwteDkoSgCqgEyxXNGW2Ee5XaD3CLFq2vJc2Lk01zHOSOJ89iY5JC0s99oYn5E40wLJ/ZSIfG1uvN5w+OjeLXCM0N9fh1c82H57yMrr3XFbF6NwVf+PTHoJMjB2Lj/lPLUiqZ4SxNrqQSx7eFHCdtTp6HH2cb+E1ebvALmvpV7S7H1o6Wi2UWBeQUcc6Km7JRDMn9qUz8RIafQpZIXQu0+EqRIP8FA17JBpxztrHmheY1KYupFxt7X0FaJOBLzy9npld/GRTufDKbTcKFG6MmYGftp3gNTkt0jd5bM8AxE5L4Sk5HaNL+f+rb5kYbbthTtUiBFMvW8ro7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+LbnPMVVAcIbqzFOacbskZL5gdc7FxL40ma63ETbfQ=;
 b=KB8DcwhQUo4NatTTaPP6waKWSPANF5b1ixbGE9A6rOUbeAXSUy53lyCoKgWRlSIUgCuAsH2LPoWuukdg/a97+ztCTPW56jzNqMHzqQlVQ2qy+jNPbmYxQcsMud+PJgljx2pa2XMTLwE/X6H4szlcaV3tD6HFwvh0d4b7J/tEKbu33mtWPsaUyP9pccZXKB1C9MMRCHwuQ2A5P7UG1Rcc32IdjKsh2o0uP2BXtnMzIlsSNkIdPFBdsrgv/P9PIdEuzt7AwtILXF9f+g2SyedXJJ9OOlGMAU3Tv4O9JD7+l8EbcYbxHD9Oq/yYNr5ipACaL+I1LqgMiRcU8Pko1DWgtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN6PR11MB3954.namprd11.prod.outlook.com (2603:10b6:405:79::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Sat, 6 Aug
 2022 00:49:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fd67:814c:7bf7:7ddb]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fd67:814c:7bf7:7ddb%9]) with mapi id 15.20.5504.014; Sat, 6 Aug 2022
 00:49:54 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86/mmu: Add sanity check that MMIO SPTE mask
 doesn't overlap gen
Thread-Topic: [PATCH v2] KVM: x86/mmu: Add sanity check that MMIO SPTE mask
 doesn't overlap gen
Thread-Index: AQHYqQNtWfoePbfoskSluhR1c2wprq2hCtqA
Date:   Sat, 6 Aug 2022 00:49:54 +0000
Message-ID: <dda1d136be3d5b86e42fd08fee133124a80805df.camel@intel.com>
References: <20220805194133.86299-1-seanjc@google.com>
In-Reply-To: <20220805194133.86299-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c66dc6eb-e8be-4608-aaac-08da774593e7
x-ms-traffictypediagnostic: BN6PR11MB3954:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ou1wb2BZOUZvqBqA5m51+noN444JLLZdujVckR2yG05DP7ruLD3PUQ6+A0b8UGqMw7DQ9D48LylOhp0Qe6+DjpFZ6jzcbxPSzg22bbWpMhDgweCq7BJ5eASIA4X/WVRYNFa6z6KqFkfo+n8mk37AB3xPpgiDbnya0q14ArMGxIX3C+jrmlidmfpVZun45GE5eni8HBfmk1qi33GHov+HhNQVebOBcgXmLV3DmVD9kDeVQm+V+1HZEYdnlnQOTN92lf+RiYOXUHz5XydWfvaAcT9ZeHeLlMCDnsLSJhMy0RSp8dMr+g8g2ZkIx0heNLpBe8tsKO7MDysBRRlUBAbagd5Y6se64l8+PpoxKcbwbQdwyzNy7bx4KMUhCp1cR1PJOogbMUNTlWq8ATQTY0BiBI74Mn7xWih09zpsAEuDrThw4lDU+eBR6Oboi0y+Txw1CFqew73oTVXoSmMx96e64MkLrmkH8aJMps9xlWZ3yFjdWBrV+LzBq4LrXLjQB9yz3oKikQdRdHCBxZiTCZWkyuufs/gKzfBjOU41gpXJoEQLzVgCsFj9WkJcPKrUcWcQobJcByU6Q57u09qgKC8I6WH46h6/7uOj7j1gLcASea3rRHTl8CCghfxqehMe9FnBum/gleuQ9iEvRSOuvDWLzV7mEwqIhORo+GzT2oaFGABSPO4DzGDgG0CDgCFLpuirpxaObtWsiTQm719n2THBQWaMKcuVk/1qhL3r2CfN8i85S+OscF+yGOl53Vn3lrjAY5C+T6era8yJ/4eUz7qlSqvJpq+eqNuqLnseutNNNc4RnSZfwdKgWhh30WIR6uda
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(376002)(346002)(39860400002)(136003)(110136005)(71200400001)(82960400001)(6512007)(38070700005)(8676002)(4326008)(66946007)(76116006)(66476007)(86362001)(66556008)(5660300002)(64756008)(91956017)(38100700002)(122000001)(66446008)(4744005)(186003)(478600001)(2906002)(8936002)(6506007)(6486002)(2616005)(36756003)(966005)(26005)(316002)(54906003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXp1VjdpTWZLMEZvdGROTnoycm11a1pmVnZTWGhFdGowT2VvMzZ1cTB6MVFH?=
 =?utf-8?B?dVVpT2YwcmxIajNzbi9ad2lEUzQ4UlFPbmQxNjNYcVNZellYNUFVL29saW01?=
 =?utf-8?B?V3hwbHQxSldQTUlmdE9tYWV0b1I2cDJmTGdxVDdZaXFLcHg1Mi83NUdtQzJM?=
 =?utf-8?B?Rk42M0pkZEppNHJ4MHluR1F6UDJ2OXlIMEV6QWZoSDFOaTFqS0hCZVhEdnBH?=
 =?utf-8?B?UGJoQStrTXZFNjR2Y3hsV1A5QUtOMUpzNk1FdHpxdUZnSzVTckxtR29lOElR?=
 =?utf-8?B?bWQrRDRFSWlCaWVISUUvTkxwZW5EVW5zdldxZmVxODVZUm15dDVkR2hjcUU2?=
 =?utf-8?B?QnRRY3JJN2VRYjVQcm1VaEdRSno3a3FVQ0JyNi9jQ01zLzNsWEFhbm85aHNp?=
 =?utf-8?B?bXFMOGNua1JadStsanM4cWZKblA2bU1KTUpWbmZjbGFUK1I4ZGpTRTExUjJT?=
 =?utf-8?B?cXAxMGx5dmh4aFUzWVpKcm1obmx3WHY3dTlvUUtxQ2p6NmNSRlA1Y2wxU1Rh?=
 =?utf-8?B?YTMxQkkwdDNZd3cxUFhZbEs3b2ZCNnJtODdqQ0hHbmxkS3NmcFNWWWlBY2Ix?=
 =?utf-8?B?RzZrOFNzTGxEYksrbGc5dXpURWZlSnY5YVVha0JYL3p5OFZtWlRwYzdlRFZ2?=
 =?utf-8?B?cnR5aTF5bmVwNmMzSVpvSTU2SmwvTkJyWnpucXZiYlRIWkpIWXVSTnFNWk1D?=
 =?utf-8?B?ZG8zZ3h4ZGc4U0E4cDdSMnBTUVdCNVFLYmlHYVdlQjNMcFAwK0hDUGlZZDNY?=
 =?utf-8?B?bXBqeXdDeDN2VTZEb0pScHR6Vk55SmNnMkNPU1RPRFh5djUrNjFkTTlMVWRK?=
 =?utf-8?B?QW1RT3J4KzdFMzhSaUVYc2JNcGRaamJPbFdpUmNLNWNnVzN0dTNvbzVNZ3NR?=
 =?utf-8?B?aExvQktpSTJkTStWVjZyL1M4VUtnTjFGbXhrWWZBb3drM21BVkpXYStBOFNl?=
 =?utf-8?B?TGxPQnJGT00yL3FRUk8xKzR4MlZ5bDNoUGF5aHB5NUtOUzFnaTFGQjUyQkVo?=
 =?utf-8?B?V3pUdmlDcnhXWmhzSVZkT0Y1SjdsOXlwcXhmbFdPNmVhc2ZTY1pjMnk5R0Z4?=
 =?utf-8?B?ODBUVVpVQ3d3VmkrUkIxbk5SV1hWRWxTMHRQbzZWeWdlaDY1L2tJM0FuZWwy?=
 =?utf-8?B?VWlwY3RvOHNROUdMNU1acHFuNGY5SFFOczNWSVI5T29kN2tCZFp4V0xqaXN4?=
 =?utf-8?B?Z1VzalNhMlhMeXE1ang5ZCtBdFYxMEFLVFF1V0phN3JNaExwaWZFd3N4QVlD?=
 =?utf-8?B?L1pvM3hvTFBTMmEyZjZ4YnNDVDRjQU5DWVhoYlNWbjQ1ejY3T0ozM3FvSG5o?=
 =?utf-8?B?U2gvQ0pCUlZlNzZLQ3ozT01BVS9aWjdoR1dQcEczYmM3REhxSy93SVRlbFkz?=
 =?utf-8?B?SkExQ3NwNWtIWGM3c01UMm1pbTdhcGtUanBBRlN4amhxR1JhQ3ErTERiazBi?=
 =?utf-8?B?clVMeXBIczhKWnVCR1FNOWZxTlVBczlJSk16aFc5bTNRRVRpUDlrbW5weTBw?=
 =?utf-8?B?VlVBUU1xZHpZaGd1NTM5eDVJLzlhMnBoYzE4VjVISmhadWowbEJ3SGg4ekls?=
 =?utf-8?B?R2g1ejBEWFI2OWVFNWR1VTI4Y1RROW5RN3h3MnRVNWsvZUp5akFWQlBLMW1V?=
 =?utf-8?B?MFN1ajVhSmdPZC9JNk4rSW9mc04xWnFOSjJjOWd3UVhWbzVhUm9ZNHRhVWl6?=
 =?utf-8?B?eHdmM3ltK3BTMDF6NXQ2WklVb2x4a21xalhOeStWbEg3Z3FBaksvZWFmVHla?=
 =?utf-8?B?aWFkejl5UlpEVlRpOVM1OExhWEdQWHpxTnp5bXZjZjB0V2xCb3NzOW42NnhN?=
 =?utf-8?B?d0RmMHZta3hsdGJSWWttQlVaQXF0c2ZUZWtlMis2Wms0RS9VUFpIbjd6azNM?=
 =?utf-8?B?MHVPOW1KRnh2MWtYc3B3WjJDUFlFWkZSdlA3Z25TN2thSEM5czNHU1Fpb21V?=
 =?utf-8?B?Ty9FcFdybkRHQTRDQ3JpMjJJMEppVW1hM1pYbmMvdnFPT1dYY0QyMGdwWk5a?=
 =?utf-8?B?TjZPak83eXBFVkVlMDdTQ1c5eG9acnkwM2xQbTQya2J1aFBUemNka2gwTkhG?=
 =?utf-8?B?REd5MzE2S0o1bUQ3MWdMNnl5QWhPa3FhNU41S2Jab2RRL1k1aXFTTXhHeGgw?=
 =?utf-8?Q?BIICXBIizIscw+ZApWYuFpQLh?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36F0E783465FD84B9680AE667A75A228@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c66dc6eb-e8be-4608-aaac-08da774593e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2022 00:49:54.3603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SzZncNEN/egyDq0oF3RXFxZ65bdgTZjMYNBd4lCsgtYolifenIMnlsjHs08GloWyBEArORzlbqMXdPvc5zo6kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3954
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIyLTA4LTA1IGF0IDE5OjQxICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQgY29tcGlsZS10aW1lIGFuZCBpbml0LXRpbWUgc2FuaXR5IGNoZWNrcyB0byBl
bnN1cmUgdGhhdCB0aGUgTU1JTyBTUFRFDQo+IG1hc2sgZG9lc24ndCBvdmVybGFwIHRoZSBNTUlP
IFNQVEUgZ2VuZXJhdGlvbiBvciB0aGUgTU1VLXByZXNlbnQgYml0Lg0KPiBUaGUgZ2VuZXJhdGlv
biBjdXJyZW50bHkgYXZvaWRzIHVzaW5nIGJpdCA2MywgYnV0IHRoYXQncyBhcyBtdWNoDQo+IGNv
aW5jaWRlbmNlIGFzIGl0IGlzIHN0cmljdGx5IG5lY2Vzc2FybHkuICBUaGF0IHdpbGwgY2hhbmdl
IGluIHRoZSBmdXR1cmUsDQo+IGFzIFREWCBzdXBwb3J0IHdpbGwgcmVxdWlyZSBzZXR0aW5nIGJp
dCA2MyAoU1VQUFJFU1NfVkUpIGluIHRoZSBtYXNrLg0KPiANCj4gRXhwbGljaXRseSBjYXJ2ZSBv
dXQgdGhlIGJpdHMgdGhhdCBhcmUgYWxsb3dlZCBpbiB0aGUgbWFzayBzbyB0aGF0IGFueQ0KPiBm
dXR1cmUgc2h1ZmZsaW5nIG9mIFNQVEUgYml0cyBkb2Vzbid0IHNpbGVudGx5IGJyZWFrIE1NSU8g
Y2FjaGluZyAoS1ZNDQo+IGhhcyBicm9rZW4gTU1JTyBjYWNoaW5nIG1vcmUgdGhhbiBvbmNlIGR1
ZSB0byBvdmVybGFwcGluZyB0aGUgZ2VuZXJhdGlvbg0KPiB3aXRoIG90aGVyIHRoaW5ncykuDQo+
IA0KPiBTdWdnZXN0ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IC0t
LQ0KPiANCj4gS2FpLCBJIGRpZG4ndCBpbmNsdWRlZCB5b3VyIHJldmlldyBzaW5jZSBJIHByZXR0
eSBtdWNoIHJld3JvdGUgdGhlIGVudGlyZQ0KPiBjb21tZW50Lg0KPiANCj4gdjI6IFByZXZlbnQg
b3ZlcmxhcCB3aXRoIFNQVEVfTU1VX1BSRVNFTlRfTUFTSw0KPiB2MTogaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsLzIwMjIwODAzMjEzMzU0Ljk1MTM3Ni0xLXNlYW5qY0Bnb29nbGUuY29tDQoN
ClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCg0KLS0gDQpU
aGFua3MsDQotS2FpDQoNCg0K
