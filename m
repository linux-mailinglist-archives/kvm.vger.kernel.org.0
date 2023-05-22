Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5834B70BF53
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 15:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjEVNMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 09:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbjEVNMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 09:12:08 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797F5ED;
        Mon, 22 May 2023 06:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684761115; x=1716297115;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TOv/qebip6IGx/qORaVpacPtAhnncwsFUJbp/MiKV9I=;
  b=Ofia6fBwC6w18yBJbLzqPeXxH5uPIu+HaEcOW3hvCrG1OzvDUSPukjjB
   JzAgW4sX0s337I44Sj3QhYqSLqcZeF3bJYy0TFBK3kgGeiz936+5DPhh5
   7Ep7UR7t4Nyznyc7pJ6adyIN3YZPRyjtdRgQR9pZRJrDUljEOuygvsvDT
   iWAE56fhIb4i0/vire05qNZlNioChGJ/wYJjt4KF3QMyeFAANggU1iaqx
   0Rw9sbkDtEkUduXMP0KnqpGN2n0w1Gh5tYkxAXHUaCh4M6iB1gLXHs0df
   zgWio1RtFuZ5y8QdsFYYNAbnli7FhabTLdIscwN1g3eqWUMmWPMx4KJVS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="350426042"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="350426042"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 06:11:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="703503567"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="703503567"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 22 May 2023 06:11:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 06:11:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 06:11:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 06:11:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 06:11:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5CFTo+aCZOP9o+pRlbGcIc+zwYQh4QsbmjC/7p0d667R53yCm6twlrRMvTN7zlm28wCuTI6PcyZzI+KsUh2VjV1aLaHMlolMcC9kkxTEzPBPOPBB0VQCtq8i6GBzPuSN5pQrejONUzgoelxwExEkTtdVyUyKGcA1JvvrRICqKZz+OZtuKfzwkKZc84l/zZJZUOIac2ajuQqVMDYbubIorWtlmUqirUNmkTWreIReVfBhGrrKEtwRip5DHnWMTGMcN90FNuaWBFsj4P2i4bTQ5Z5MHRMz1TSuX+hLMrgIDSbRB4Xc9chm79IlvIC/Bt3PBbt0iiRKl10RdK1ZtOryA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOv/qebip6IGx/qORaVpacPtAhnncwsFUJbp/MiKV9I=;
 b=b07tAjzoNEo3kU6Dulk/xdy7ZbEA6z829bDuHd8pCfGcb7viiLVkXYU+eslD63Pzg25zS5awJmZgT9OU5GHJnKgoHIKZRSKqS8NPdbl81pOmWiJX8xn+RLApAq1k+4G0qPQiD4vDEeVMw0yPMv2DuZmeXEbrs3z60ypGUFKxh4LlomhSqDkkb+vcQM34+b5CDtaKIBDKchc89gjGaLjlKq+tffHI6VIkWowN1LgKwP/fHJMUFp7c7w1HXOKIudcvjAY3ogVNVPvbFkG5PoNovpwq+rlV9ix/aLXjfE9fc2lhBEBXKyKtf4KCNUvOdKihnBAoiEYFyF8ZbRgBg2xrmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6401.namprd11.prod.outlook.com (2603:10b6:510:1fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 13:11:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 13:11:50 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 08/18] x86/reboot: Expose VMCS crash hooks if and only
 if KVM_{INTEL,AMD} is enabled
Thread-Topic: [PATCH v3 08/18] x86/reboot: Expose VMCS crash hooks if and only
 if KVM_{INTEL,AMD} is enabled
Thread-Index: AQHZhSyX3BPaFFVfYUiT7YGM9giNAq9mU46A
Date:   Mon, 22 May 2023 13:11:50 +0000
Message-ID: <fa185052f13d192aae9612634e63533fc9818d30.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-9-seanjc@google.com>
In-Reply-To: <20230512235026.808058-9-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6401:EE_
x-ms-office365-filtering-correlation-id: 1a100c8a-86d4-4658-1f46-08db5ac61ae2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MXPhzSRWWwREluLNs+YPtuo22gIXWZBFcx9wSTl3uCwcoWONWT1hKzrwh1BQA/YjaOwhxJq74z8qXwkZBkesOseXeOd7LYfWAq1B9Ytu4z3EeaiVeQLVbutNUQQZOz6PofVheCuqODD/nV86xOHgWtORmQwv/v0BZpzhHRByzxOYMny1W2CzIBTRUAss3zYPHRReDNF1evG4oza6nxENj7qHnj9HwNQ7OZxrSNNkrkCvuaRvH/4PVuRWQOv88Ox8FfZkz1mRKpNfbfVtwMb8Bck02aBgT9UcfC+1ZcMeB9HiNVqeQK+my3m16ABbBIzygMZ/TzpDGb0VAaQ+AqXkKSQyCfYLVv1p1esKiITdHQk2CxJU9/+5QU8bxU1KxrsEN28LwM5bgdUxHNi/MmQSA/yQwWINbdbW71TLkNoDr9wj34OyteRbZkfxTwTn+q3jm40/bBVfce7NG9D5J0R+8mWq+2Il7R9FoX4kz17Y1ApiSLUvNyTCUYA/MoEhnuQZYlDmOn6HxvQpOs8DIokSyvoTvcChxYWl5WxBpKw/MqTqwoG8VPAWqfqw4pM1Gb3V9XSf25dhDDm4ixW7R8mkij/BVScb0hxCvDnXmrjS4JR+eEjRBjnSru6ibw77k5g4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199021)(2906002)(5660300002)(83380400001)(8676002)(8936002)(41300700001)(66946007)(76116006)(66476007)(4326008)(91956017)(66556008)(64756008)(66446008)(54906003)(316002)(36756003)(110136005)(71200400001)(6486002)(478600001)(2616005)(6512007)(6506007)(26005)(122000001)(86362001)(82960400001)(186003)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjQ1ZlpocXlIT0c1OXN3OTBieDg2UDZ3UHl2QVpRWFFobkhHM3UxbDkvTHJW?=
 =?utf-8?B?NDRVeHI0MnQ3NUtwa0JXSk5QNGIwSVZhM0tIZndDRTNJM0xHYlVWVkphejJo?=
 =?utf-8?B?bk4zQlZDUFBWbHZYN2VkMU9ZS0J2Sm5GcEh4b1Y0S1QyQmdiamI3NGhqNVlr?=
 =?utf-8?B?M3lsMnQ5QkEzdEVranBFZzRsb0RqSWhJaWMraFRTV1ZmaXBId1BkMFRudTRF?=
 =?utf-8?B?R0dnRFlVTzladEJtWm8vcGVyQStVNUlVNGZrSHlRell2TDlKT0ZKSXdiVGpS?=
 =?utf-8?B?bFJRNWhISVZhYUNmSTVUVVpoUzB1UWZKYmNqYjRSNWpjK2xwMFpqamdrLzB1?=
 =?utf-8?B?eDBJeWtnT2Z4cUFXazdMNzFCTHFCc1BpM1JSNUY5MmhWRnZUTFd0S3h5Q1NG?=
 =?utf-8?B?aCtuYUtpdERHVk45cXNQQ2hqU2JIVmQwdkh4N0FZazZhaC9lUWVCbzE0Yng4?=
 =?utf-8?B?MXNaOEwzeW5UcHZZdE1YWWZBUUJSbkdqdFVBQVFpVm1mWVNJZmkvOFZwTnRM?=
 =?utf-8?B?RUhEZjZVRVg2TVNTZWh4clg5RmJvT2dmM2Eyc0VmS2xJU0hZcEdBNnp1NnI1?=
 =?utf-8?B?SEl4Z2RoTS9mZDFQU1U2aVM2M2wveUxxQnIxTjIyUzRna2xSa0w1UzBrVXZh?=
 =?utf-8?B?N1EySS9MOC8zZSsvb2RweWpLY25qdmNUaklBMXBIR2plL3kvcTlrVXoxN0s2?=
 =?utf-8?B?NkhLWVdSL3UxTkxSMXI0NjVtOVQxN2thaUN0VEFlVWMwNkZ3eXBpZU5meGVO?=
 =?utf-8?B?Mk5NcDIxd0wwZnozbzdiRHRmZklLV3VxYWZWTGdpQmlLbUQ2TTdyZTZ5Y1cz?=
 =?utf-8?B?OG9KSFp2OStkZVZpMVZPUlBFWlVCWWhhQkdWL2VRYm94djlGQkhtUzI3OU4z?=
 =?utf-8?B?aFljNU1ucnA3QzlSMlFmYkUyeDdIWktCSFNRV0pJSWlrY1hCZTBEL1pOZ0t6?=
 =?utf-8?B?Nzl6cjMyUTArSm5aalcremFTOW9WU3hTV2oxM3M1REJ4MkErMlhoYmtsWWNl?=
 =?utf-8?B?RjF1OWJGK3AwRGpXVmFpVjRTbW83S1dLakMrUXZ6S2YzYlcrdlgwZjZyY3pJ?=
 =?utf-8?B?TUJhbnE1UEZmUVh1N2xhT3MzeTVBN0Y3cVZyVlhrVVovazFYcGs3Vm5XK09k?=
 =?utf-8?B?L0Y2UnRUV3BTcndYdEM5VkxPMk4rTzRici9BU0h1a0V4cUNwWGdQU21lcWxw?=
 =?utf-8?B?anA4NUp0dk9EYW5BcVY5V3A2clBYakMzM1BYSVM5ODd5SjFzSXZac1k5VVpw?=
 =?utf-8?B?R2ZKdHgzYWdtaE5FUjhLVnZLZDBWbnhFZUMxYW8xQUhKNWp1d1NwSjZrUnpk?=
 =?utf-8?B?WTRxRkdRQkJMVEJkcmJrR3N3OGcwQzRVV0tGVjV2VlRiZGJCN2tLSmFYUEsy?=
 =?utf-8?B?djBNR2ZCdEVIWXZLQXNGZDdpZGRJcGRqQXVNYnBwZVRyMWx3cWQ2MXNCVlBW?=
 =?utf-8?B?S3JrMEthSnZlN2thL3pKSVB3NHQzVVpHL0plZi9mUjVReDg2NkltYVRDN2Rt?=
 =?utf-8?B?K1IvRGVYV0FSOUE4OFYwbnN6LytQbjI3ME5zU0p2NmhrZ2Z3dTYwc0FKZHNE?=
 =?utf-8?B?S05qN0VneHBtSDNaSUVFQ1FIOHlaZitvbkRwaExWU3d4VDdBS1JvMUpoVHl5?=
 =?utf-8?B?RUJ0c3ZxeWRGWDJNaHp1NG8rVGU2RDdCVzMvY0t1a1JoTDBJVWJiVjY0ZlBy?=
 =?utf-8?B?c2xWK2NNU0ZJMGI1SERraEJvWll2TzdoT2l2S1h6U0xhZFZqTk1TU0VyTE5P?=
 =?utf-8?B?SkpUcm9hY2hlTm05UGE0VS9DTkF3OXgva1lvVmIwbkYyNlY3SWlJQ2dtQ2Rv?=
 =?utf-8?B?UlhqdWlYbUZmc3p1M3ozR0xEVkI5RlhzV2ttSTEwZWRKaUlWOVMyOWJKUFpo?=
 =?utf-8?B?SGU0cGFITHpVaG9pK0N3ZVlwZGZHRmVHMlEvTG5IUWdCQ29MV1VrMWEzOHJW?=
 =?utf-8?B?cnNRR2xheE5haUpqWno4SzNnMmxCRmk2QnhsUy80Ti9KcXYwVXRvd084MXNP?=
 =?utf-8?B?SlhBL0tlN1R4c2lORGw1eFJQRngvKzZWNVpXRUgxd0ViaFpoak02NnlNdDNM?=
 =?utf-8?B?QUxmT2lGVjV5NFJIcUpJdWNnYUxBWUpXSXRjSVU3RG1hNTU4YTU1OGp4V0lY?=
 =?utf-8?B?ZFlhODIvNzNjNFRRSS9wRk9DRVlweWJ5NkFlR0Z3UjZOeVdMTnFPbEo0VEwy?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5882CAD8E5A4474CB09AA397C96278E1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a100c8a-86d4-4658-1f46-08db5ac61ae2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 13:11:50.3893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A/QngbfDXpCmM6V9Mx/muzno7eHQpLd1wp7Bkv2+uPSedvXcT6en0rwQ8qIubbr4Nmu+HaMXm+IR4Hv7JeIMaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6401
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
b3RlOg0KPiBFeHBvc2UgdGhlIGNyYXNoL3JlYm9vdCBob29rcyB1c2VkIGJ5IEtWTSB0byBkaXNh
YmxlIHZpcnR1YWxpemF0aW9uIGluDQo+IGhhcmR3YXJlIGFuZCB1bmJsb2NrIElOSVQgb25seSBp
ZiB0aGVyZSdzIGEgcG90ZW50aWFsIGluLXRyZWUgdXNlciwNCj4gaS5lLiBlaXRoZXIgS1ZNX0lO
VEVMIG9yIEtWTV9BTUQgaXMgZW5hYmxlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hy
aXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5n
IDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20v
cmVib290LmggfCA0ICsrKysNCj4gIGFyY2gveDg2L2tlcm5lbC9yZWJvb3QuYyAgICAgIHwgNSAr
KysrLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9yZWJvb3QuaCBiL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3JlYm9vdC5oDQo+IGluZGV4IGQ5YTM4ZDM3OWQxOC4uOWNmMGIyMWJm
NDk1IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9yZWJvb3QuaA0KPiArKysg
Yi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9yZWJvb3QuaA0KPiBAQCAtMjUsMTAgKzI1LDE0IEBAIHZv
aWQgX19ub3JldHVybiBtYWNoaW5lX3JlYWxfcmVzdGFydCh1bnNpZ25lZCBpbnQgdHlwZSk7DQo+
ICAjZGVmaW5lIE1SUl9CSU9TCTANCj4gICNkZWZpbmUgTVJSX0FQTQkJMQ0KPiAgDQo+ICsjaWYg
SVNfRU5BQkxFRChDT05GSUdfS1ZNX0lOVEVMKSB8fCBJU19FTkFCTEVEKENPTkZJR19LVk1fQU1E
KQ0KPiAgdHlwZWRlZiB2b2lkIChjcHVfZW1lcmdlbmN5X3ZpcnRfY2IpKHZvaWQpOw0KPiAgdm9p
ZCBjcHVfZW1lcmdlbmN5X3JlZ2lzdGVyX3ZpcnRfY2FsbGJhY2soY3B1X2VtZXJnZW5jeV92aXJ0
X2NiICpjYWxsYmFjayk7DQo+ICB2b2lkIGNwdV9lbWVyZ2VuY3lfdW5yZWdpc3Rlcl92aXJ0X2Nh
bGxiYWNrKGNwdV9lbWVyZ2VuY3lfdmlydF9jYiAqY2FsbGJhY2spOw0KPiAgdm9pZCBjcHVfZW1l
cmdlbmN5X2Rpc2FibGVfdmlydHVhbGl6YXRpb24odm9pZCk7DQo+ICsjZWxzZQ0KPiArc3RhdGlj
IGlubGluZSB2b2lkIGNwdV9lbWVyZ2VuY3lfZGlzYWJsZV92aXJ0dWFsaXphdGlvbih2b2lkKSB7
fQ0KPiArI2VuZGlmIC8qIENPTkZJR19LVk1fSU5URUwgfHwgQ09ORklHX0tWTV9BTUQgKi8NCj4g
IA0KPiAgdHlwZWRlZiB2b2lkICgqbm1pX3Nob290ZG93bl9jYikoaW50LCBzdHJ1Y3QgcHRfcmVn
cyopOw0KPiAgdm9pZCBubWlfcGFuaWNfc2VsZl9zdG9wKHN0cnVjdCBwdF9yZWdzICpyZWdzKTsN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYyBiL2FyY2gveDg2L2tlcm5l
bC9yZWJvb3QuYw0KPiBpbmRleCA0OTNkNjZlNTlhNGYuLjY4MThkOGRlODVhMSAxMDA2NDQNCj4g
LS0tIGEvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jDQo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9y
ZWJvb3QuYw0KPiBAQCAtNTI5LDYgKzUyOSw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBrYl93YWl0
KHZvaWQpDQo+ICANCj4gIHN0YXRpYyBpbmxpbmUgdm9pZCBubWlfc2hvb3Rkb3duX2NwdXNfb25f
cmVzdGFydCh2b2lkKTsNCj4gIA0KPiArI2lmIElTX0VOQUJMRUQoQ09ORklHX0tWTV9JTlRFTCkg
fHwgSVNfRU5BQkxFRChDT05GSUdfS1ZNX0FNRCkNCj4gIC8qIFJDVS1wcm90ZWN0ZWQgY2FsbGJh
Y2sgdG8gZGlzYWJsZSB2aXJ0dWFsaXphdGlvbiBwcmlvciB0byByZWJvb3QuICovDQo+ICBzdGF0
aWMgY3B1X2VtZXJnZW5jeV92aXJ0X2NiIF9fcmN1ICpjcHVfZW1lcmdlbmN5X3ZpcnRfY2FsbGJh
Y2s7DQo+ICANCj4gQEAgLTU5Niw3ICs1OTcsOSBAQCBzdGF0aWMgdm9pZCBlbWVyZ2VuY3lfcmVi
b290X2Rpc2FibGVfdmlydHVhbGl6YXRpb24odm9pZCkNCj4gIAkJbm1pX3Nob290ZG93bl9jcHVz
X29uX3Jlc3RhcnQoKTsNCj4gIAl9DQo+ICB9DQo+IC0NCj4gKyNlbHNlDQo+ICtzdGF0aWMgdm9p
ZCBlbWVyZ2VuY3lfcmVib290X2Rpc2FibGVfdmlydHVhbGl6YXRpb24odm9pZCkgeyB9DQo+ICsj
ZW5kaWYgLyogQ09ORklHX0tWTV9JTlRFTCB8fCBDT05GSUdfS1ZNX0FNRCAqLw0KPiAgDQo+ICB2
b2lkIF9fYXR0cmlidXRlX18oKHdlYWspKSBtYWNoX3JlYm9vdF9maXh1cHModm9pZCkNCj4gIHsN
Cj4gLS0gDQo+IDIuNDAuMS42MDYuZ2E0YjFiMTI4ZDYtZ29vZw0KPiANCg0K
