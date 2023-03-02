Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A716A793D
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 03:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjCBCBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 21:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCBCBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 21:01:06 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C7F149BA;
        Wed,  1 Mar 2023 18:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677722465; x=1709258465;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fOvImeuMNgoe+ux+CoOobv09mzyYhemm3SQ01C6R8Pw=;
  b=IZWNkEtbaZ+qLaet6GqUhCYyd9TmukMbBKkUyMts6XaDBkbTcefeAmvL
   RDVifwNIRouhrmPQJ8jFafbAMt4PJ1V6oB+rT/iQKtCG91GzP4cobCUyW
   oIiuj2R32ewvIlLWqDjKjyeqg/rLPK89I8Ir3DlehkncLiGBFnxDjjQgp
   9kYp5MEIjPPELKPWWTJPZHniBXPFIBTiF38To51mEkt2cqsPogOlnhAnM
   iyzDVdfMYTcdV9aYrdGmhFpISM4nTHIv640lzOgi3l9XDA6ZPA658YFTa
   n8U7fZXiKYwFRFugvkDkpUs4YLk3kCBWdoO0sMwd4H6Jnvptum4+W+N/p
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="336085691"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="336085691"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 18:01:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="624731441"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="624731441"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 01 Mar 2023 18:00:46 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 18:00:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 18:00:45 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 18:00:45 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 18:00:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HO9J2NmepiX7AevEzn02ERXSn8Kob1wlyA3SqA2bpR7vAdjJ5b8cv1NmjV6CzBx46dJYCaQPlrxtDS9mJcWeZlpwbOPugKB42AsTb+BHjOLeSnAuApsqiLPvAjZDblyhXtzh5YMo4l2F/cbv6M5skR3E25PrdzomM97pSkwl6Aqz3KW+F+hCI7RyPmUxHCPnFeCn/G/6NYR5bf9aGxZU3CoCrdKc6Usk16fCtb1br1tZONIaKwj2vfI/zaiYJGh51NTmwykec7F3J3pnfPsY6FYu84G/WgWdZHRPJkzpGN2qKaaISwPN9mCcwhNO6elfeU+0NKuwFxreJc7a+byylA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOvImeuMNgoe+ux+CoOobv09mzyYhemm3SQ01C6R8Pw=;
 b=PPCB5Vroimm+nHZDtHecQi7qc63yC3PF6ASHJB1UVk0JAuQ2TS58WZuLrneu3SAZCn3K7ISPrUsFmiP7jgEfLo12mcztT8kCDyvIBTpSjRvlxKKf9Gx763sU3A7g29gaV7QjhgVv30KhytOr7SkKSo8YVRbPa9UPWLPc6zXrPFqpg38mQMlFB8BF5++Mb20+RHHJ59o307zv9kKEEzwlCWk6xXx7tsZNMbkztZYBT6B6oM7sf9U+WNM8FcsGw8Gss7gcBfG2p4YsiWNtWqyWztq+O7wqruUmYoeSOuXiMzL5sO1foquNyy4M66iCtsK1r8ipPFAi9DLmlfopIr6Tgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DM4PR11MB6310.namprd11.prod.outlook.com (2603:10b6:8:a7::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.29; Thu, 2 Mar 2023 02:00:42 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%8]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:00:42 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     David Matlack <dmatlack@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Topic: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Index: AQHZTEMoO+JAZhQRUE2mrtrpaO2QJ67mVMSAgABZTgA=
Date:   Thu, 2 Mar 2023 02:00:41 +0000
Message-ID: <DS0PR11MB637348F1351260F8B7E97A15DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20230301133841.18007-1-wei.w.wang@intel.com>
 <CALzav=eRYpnfg7bVQpVawAMraFdHu3OzqWr55Pg1SJC_Uh8t=Q@mail.gmail.com>
In-Reply-To: <CALzav=eRYpnfg7bVQpVawAMraFdHu3OzqWr55Pg1SJC_Uh8t=Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DM4PR11MB6310:EE_
x-ms-office365-filtering-correlation-id: 56699063-a91b-4136-5781-08db1ac1ed6f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UmOXn1/yF1vvuwKI+pafJFH2UI8o8kb4lMu0uBKzNQt4O6M9EsU8LHl+ber9EpWfZJO+Tn+MHdCZlXFqZRRaVyNHoQBVOtExfNAXZNYyXCcHY9rP4vtoFp7D85Doq5ZITuaSIgvXHISZPiZbg1SO9wdWyyFdmXzCvlqMtlbgVPKHIaTaWyQxOy27s6d4sOIzzCYybyz4E/cUjLF02HVIfUJ0fNMdgjcOvYw6tvaIFp1pTymH+7dCpfpFKQKf8ElBd+K7w9jd95LV5uUMDozH3JwSiOFk5gF6dm8H270EfOriHkzGI5WDBVnmvxEgDEo4PlU59VgNXn8xsBtLxcjXHVl//DvlFc5eDYWW4NSLvEtpzBbPsSdwl/0+w3mmgOhQX6Aaigf1QU1JhsZOBkelKLjVdpV1cgn9oftoHcj+KRIY/e9Z13V8SqZ0wbpl9Z+08rh6HIMprM0Si3oq/E3n0Z1vd+UUmifGO5UiMI5DejV6YdgvDXzo8CT/mF9/hmeL4614uheQeeWeTzmmn2udf7ejfYMvPGTb43qyEQjl6x9CcetPU8mMel/eKnOTe2rGjRdFbW1Yfe8akgWHvCvztiNQlrJf0FTDCZPvMgKWKa9mN8fuhf5v+C21BaPpDr7F70ZPmtrDRAmCm9ktIqTuZZibUMSXTzqf+iUtabE57orEZQ8NtK2VxGDePhcZ+9X8I9KWyCkbCJjx7PhbmdV6Vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(136003)(366004)(346002)(39860400002)(451199018)(52536014)(8936002)(5660300002)(478600001)(4744005)(38100700002)(9686003)(6506007)(53546011)(82960400001)(186003)(26005)(122000001)(8676002)(64756008)(33656002)(6916009)(76116006)(55016003)(86362001)(316002)(66946007)(71200400001)(66446008)(7696005)(4326008)(41300700001)(66556008)(38070700005)(2906002)(66476007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTVmSCsxTWZrV29lS3hkR1JzaVRQZVBLd0ZsTTZNd0FnRDR4eDBHNWw1eXB6?=
 =?utf-8?B?dVRRYmtmQkplQVNYTXJhNks2bHBXR1Z5NW85VkhYOUN1T3pLQlpUWkRZeHJC?=
 =?utf-8?B?WkFoTEpBenA1aklhL2I0bVpXKzcyZGN2ZFp3Q0FlaTkveU9kcENjWHlyNmxN?=
 =?utf-8?B?aUtNd2xYSVVwTEE3V2NPaE1kV25lWGFPZzVqZlpFQjZad2w3RitzNmdCY0pT?=
 =?utf-8?B?djlJNDFwVmo3azJUbFdHUCtKUStYMXMwcmkwMzFkaC9KUGU0M2pFVCsrcGhr?=
 =?utf-8?B?eFdoUE41M1VxdG83M1ZITHllL2IxMHJhL3N5bDAwTUJoM0JsaWhMNnVrYkhs?=
 =?utf-8?B?NGhSVjhteEFWQWFNZGJzRzJqYnJKT2g2Q0ZLTDhPcnE2SEhrczNZdThESHBE?=
 =?utf-8?B?dVF3NTVVUzc4dE04OUJvOWVJR1hycVZGckNmYnA3LzBGOTkxblNnTWZoRTNE?=
 =?utf-8?B?SzVJc1UzQWk1QjNDQkNlekp3MGZFeGwzRVViZEh2cTJsS3pZOHdZYldVeGFO?=
 =?utf-8?B?Qm5kYVJsZStreHkzUzh3QnZwclAxQzlEOE91Y0s5ZUJoVTB6L2t2K2FPVllR?=
 =?utf-8?B?c0JHSmpqVEU3bThUMmhHWkh6eFZzVURPdThwRUNreVE2R3JIYlB5cFBTQ3Rq?=
 =?utf-8?B?bXkwWWV6YUUzVEcxakZEaVhqeWxyWmgwWHJlc2JyTmhFd0FHK2FQR0wvaGRD?=
 =?utf-8?B?VU40TGlLZStvQ0Z1SmdLUkhKd3BPeDVQSGxiODRrZDNSdWl5QkNlS1plbVVH?=
 =?utf-8?B?aUVPQlBGcEJPd3RZck5tZUw0WlZtTlBtMnc3SHZWdzZJKzlRVGc1Zm1DZGVm?=
 =?utf-8?B?RmJ3RXljRGNyUFJ6M3pZemxjcjcrZ2ttNFRTZmZkNzVQSnBMUGtoRDFla3Ey?=
 =?utf-8?B?V0hyaE1udVV1cmdnMHRPU3pQaUtLTVc1MmwrSjNUM1pOcnY1U015ZDVJR3Fh?=
 =?utf-8?B?ZVEyU29YNWcxeDVuWDRUNWdRU09PSXZCVmZoSW82ZnNaSmd3dFJwWnRWWCtG?=
 =?utf-8?B?V2FmWUhLV3Z2WjBWbmZ1OS9VL21jdlRINktSeDVrQXpRQk4rVk1CaHkxUXNT?=
 =?utf-8?B?UCs2K1JBRU1HVG9ZVmdxbHhuYytJS2x4UGYxekc5WEdnNldZbElBeUgycUtm?=
 =?utf-8?B?VHZCbzVRcmRiRVZmMkFwMDY1aVB3QzVlMHUzaGhhVVRvSElvajZTSjlDK3M2?=
 =?utf-8?B?cmhiOWZ4VHFsc3FjZlBucUpWQklzVDJITTZhK1RjOWMyR1N6cHYyVGlndTJU?=
 =?utf-8?B?bmxHRUN2R3lmZ3ZqMGxOZ2pXdEdMWEVFem8zVWRGL0lnMTNjeXRhdzlSdThI?=
 =?utf-8?B?eUxid044MFhlbWdUeHFEa3Y5ZVg2dGo0STdTTWxpdTlUaW5ldEQ5TXVXQnpF?=
 =?utf-8?B?UFpWTGU2MmVEN3VkbGNCTk9hak53R1pZazFLWDdwcHhJR1dVZXczbGoxQmRB?=
 =?utf-8?B?bTlvaitNbHhjQ2ZydHNUSkx5ZTRxS2t2WHJLQjZtcEhhZG9GRUxIVURoajk5?=
 =?utf-8?B?UTRyb2FsdVQzRjYrYnp1VU8xbmY1aml0ZFh4b3VDdmRRT3o1OHZZOVk4NUlV?=
 =?utf-8?B?YmxqZTREMlh0b0ZiTjFVQVJTYnRKVXk2MHNEMmo3ZE00djQwS0pMS1FLNkhh?=
 =?utf-8?B?V2lpMk5HWE9NbWpaaXJxRVFLaHMwT1pQYkw2djQ5ZENWMFBsSUVrT3AvTEx2?=
 =?utf-8?B?ckhCZUVrUFptNUE3ZityUnVPdENNb3d4YTYvbFZ3WjZJTERQR1dLSlhNU2c2?=
 =?utf-8?B?WE91TkpYMktuU2dPdDNUdll0Zk9LUkFQUkl4UVl1WWZ2SHpEUEs4S0lpZDNI?=
 =?utf-8?B?US9pUk5RYzJVcnFqdmtyRjl3dHRZNFVDS3grWXE3SzlieFNvWExlanNTdnM4?=
 =?utf-8?B?K000enVYQWdZbHNSZGxtSHh3b1RJdEkyLzJLUTQ0TUNuYTAxN0YyRWd3RDNM?=
 =?utf-8?B?dktESTVnbXFFSDRtQzUwK1ZiaWdXN1pTT1RsL1VqRjN3TlJvM2ZmQTZ1OXpC?=
 =?utf-8?B?aW1kRVB0OXlvb0ZodklsckNRKzNXQ3BWK1pRTE1GTWh1OEM0dVhsQ0VhY3Zz?=
 =?utf-8?B?cnduYUVielNmZk5qY0VyVXpBbGJKQWVJWjdkY1ZGVzY2YitnNlFMeTE4VmZK?=
 =?utf-8?Q?8tUz1EDa7RzaJhhqpDTwC77yc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56699063-a91b-4136-5781-08db1ac1ed6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 02:00:41.6648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CilBylhgMD5tBhNuAjybxgigmob1bUE2wD976afNv+TdD0v+EygwZq1djD9LgpoSklwWfoG58j706PIScqmoXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6310
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

T24gVGh1cnNkYXksIE1hcmNoIDIsIDIwMjMgMzo0NyBBTSwgRGF2aWQgTWF0bGFjayB3cm90ZToN
Cj4gT24gV2VkLCBNYXIgMSwgMjAyMyBhdCA1OjM44oCvQU0gV2VpIFdhbmcgPHdlaS53LndhbmdA
aW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IEN1cnJlbnQgS1ZNX0JVRyBhbmQgS1ZNX0JVR19P
TiBhc3N1bWVzIHRoYXQgJ2NvbmQnIHBhc3NlZCBmcm9tDQo+IGNhbGxlcnMNCj4gPiBpcyAzMi1i
aXQgYXMgaXQgY2FzdHMgJ2NvbmQnIHRvIHRoZSB0eXBlIG9mIGludC4gVGhpcyB3aWxsIGJlIHdy
b25nIGlmICdjb25kJw0KPiA+IHByb3ZpZGVkIGJ5IGEgY2FsbGVyIGlzIDY0LWJpdCwgZS5nLiBh
biBlcnJvciBjb2RlIG9mDQo+ID4gMHhjMDAwMGQwMzAwMDAwMDAwIHdpbGwgYmUgY29udmVydGVk
IHRvIDAsIHdoaWNoIGlzIG5vdCBleHBlY3RlZC4NCj4gPiBJbXByb3ZlcyB0aGUgaW1wbGVtZW50
YXRpb24gYnkgdXNpbmcgISEoY29uZCkgaW4gS1ZNX0JVRyBhbmQNCj4gPiBLVk1fQlVHX09OLiBD
b21wYXJlZCB0byBjaGFuZ2luZyAnaW50JyB0byAnaW50NjRfdCcsIHRoaXMgaGFzIGxlc3MgTE9D
cy4NCj4gDQo+IExlc3MgTE9DIGlzIG5pY2UgdG8gaGF2ZSwgYnV0IHBsZWFzZSBwcmVzZXJ2ZSB0
aGUgYmVoYXZpb3IgdGhhdCAiY29uZCINCj4gaXMgZXZhbHVhdGVkIG9ubHkgb25jZSBieSBLVk1f
QlVHKCkgYW5kIEtWTV9CVUdfT04oKS4gaS5lLg0KPiBLVk1fQlVHX09OKGRvX3NvbWV0aGluZygp
LCBrdm0pIHNob3VsZCBvbmx5IHJlc3VsdCBpbiBhIHNpbmdsZSBjYWxsIHRvDQo+IGRvX3NvbWV0
aGluZygpLg0KDQpHb29kIHBvaW50LCB0aGFua3MhIFVzaW5nICd0eXBlb2YoY29uZCknIGxvb2tz
IGxpa2UgYSBiZXR0ZXIgY2hvaWNlLg0K
