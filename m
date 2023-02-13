Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37EF06952F0
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 22:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjBMVTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 16:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjBMVTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 16:19:31 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56869222EF;
        Mon, 13 Feb 2023 13:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676323152; x=1707859152;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rA62mrVhrBAvH7O3mdkwzRdOFLEGBcoArDTDnNSKv1M=;
  b=Xvorxd2rN0IqHToWXsckEDrqMMtkbBwtVq/xjxp3jIIHOJjXsLkGs6u6
   vq7+CH6GgiRBVV2onc3cEPDaKKLYHh/z7ZSeXnnpbADY6d+68yCe+cBHz
   yl0BnkpKT08Dd3POhsiX40CpOx8XKEx5JdSv8tEJmlfrkJ5KWJhWzCtmW
   5+LTRPIDUPKdNPKE5xNSEIiODc6aKnzyKnUnmLRZ/fYeIAbW/ROsAmNmg
   Ts9P3g4oNi73/eVAkGSOFREpKZgj3XoGl6NDE7sWEp9J3X+BkIpJEMyAK
   vIwAQUnBfbKHlx3k4dsO5JCyZagdmg9rQyOkh7CEmrdJLDLea5XI/f1o5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314648010"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="314648010"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 13:19:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="646525764"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="646525764"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 13 Feb 2023 13:19:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 13:19:10 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 13:19:10 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 13:19:10 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 13:19:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J381MXWhW+RuDxTnXSS9bdFRYWCVaiAtC1EXRUGsRxvWNAOXuvdc8hInHA0zw6HOpl1fCHAE0dkqzoUeczGibmqHpjE4qKesR2bzmpvwMJtp9NhvlirbbchqJn8iR2sRM/ejjCJwz6ajYuB7W9d9AWOKjm3lHeaAOWMUwVATcKpsZ4l74NLNFqIc4sOoXWjZLgEzWz9mveypIcz7LmNsN9NIDUR1WF896HMDtbnsQpOtEvZclca0TRaTOYQTOJOMfzT1H1DM2bwzrO9qYhetN6C+wmbOEEAI1YC2g7y9Cjy7zdW1zHGmh/OnRGxNsv77hNZoRXMUQqoPF63xSr6eYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rA62mrVhrBAvH7O3mdkwzRdOFLEGBcoArDTDnNSKv1M=;
 b=RoP/odFK8vV1P6EOHVSFGI1JSBrEJE0u5SJGzPKy5Q++t1Wo36/5dSsehtsHTUQ+++IVQVHCSvLGXYfqBbL6554pIEkQsekQuEj5mob+wSPV/BjwcnlBCXbhrvoBJ7ryjczKlsaPWOXhbZJ/RUaKG2wPWzQ3TaRp3qIigj2344vx1SZr2sFBKqwZ0g+zEr940nCJow/2HIbqm0Iv77fr556cHy1XEgK5Cdmr9RxN3MWTa4o+dC/a5xzqE7luSaKGurwitQoOGa8BX1uABuv4hfjNvhfdRP0lcKWxI/M6Nswv5Lb9InCRYs+hok0inqtFoGgYVq66cAotlFvcY9o78g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7756.namprd11.prod.outlook.com (2603:10b6:208:420::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 21:19:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 21:19:07 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>
Subject: RE: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Topic: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Index: AQHZP5uucDbGOLsVDEixmYuAvdZDZ67NKpCAgAA2qfA=
Date:   Mon, 13 Feb 2023 21:19:07 +0000
Message-ID: <BL1PR11MB59789A024CFA9E9DE715C2F1F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <cover.1676286526.git.kai.huang@intel.com>
 <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
 <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
In-Reply-To: <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7756:EE_
x-ms-office365-filtering-correlation-id: 2e05cbe0-1e20-41d7-e08b-08db0e07f0e0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nLSwk0DR4fC79FtMS29kA99mFRvEOySRuxU42RJVYwQzC9d0xwShh67ap0B+81LKOJ63y2Ui13zTiQsrdM/pxriwIBDA9cNiDIB7dROWujDWXAeEVrKNIxT7ChP/dHErJjbgkxC+7U3rJugijuqcFp17nYOd4tYvq2H7Q9ibR2I42j2npkQu5irKNGjAG8ZeNGXttL04vR2tu0At69Khz9PApOFMCv90gtBQm12+34VXeQICC8zP4lWfVl2BF7RyH6NNLmI4tzbbU1nLuWh4WZLocC7uXF1IWLoknsn3TvJRovAzaI5W0FnJq4yKSDvU9L41poh1nV3gXBMcUTtPrQkfvsA3w179j/k63bXjhYcbpUh+uAip10xxaKX/+ou23V4ulfihPkI5X008wq0ErhyZO2OoRX+BnAuYqcvZOIq9TiXNKqYxPtgHN3LrRa2cKmYwpxszj3JFHbCM4E7OxMRziZGCeHRvVyf443oDVvds7SoEZFU3SRb1iVrB8b0YWKMVAs0L5C7fVYHzSWL43/mU9bRoZmW/DPWLU5fkP7/0BkTw62NxEQMn6gfatP8ac4h1e01nD2J9N+hlcnmqHxTJX9hb7Krw6+F1GGxTMM0X+FtAFziSg3gIYLAX53k0ZpskGeTmutPdrGGM/dm/M4Zdb/b6KJ97Kn6KVjssu6Xb3EaUc1Ouw4hK9gK+JWn4PgwtmK5GmR0+rnLUmsXuIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199018)(33656002)(83380400001)(82960400001)(122000001)(55016003)(38100700002)(38070700005)(52536014)(71200400001)(41300700001)(4326008)(5660300002)(53546011)(7416002)(8936002)(2906002)(9686003)(26005)(186003)(6506007)(54906003)(86362001)(7696005)(8676002)(316002)(76116006)(64756008)(66446008)(110136005)(66556008)(66476007)(66946007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmpLMjN4Y0swMFlZTWpQTkZNTmdXU202UytsQnFvQnZQK1lQajNHd0E0cEdj?=
 =?utf-8?B?T05QOGd4Uno1M0pZZHprdVJWZFZNU2kwR2JUVW5MSlkyMFYrZnk2a0lwdTlM?=
 =?utf-8?B?TEVjL2dqemF3OXRlWGV5Y0VWb2JuWW0xRVJyb1VYZTdmU3MwQ2ZSb3dvTnBK?=
 =?utf-8?B?aE1ES1B1THB5UGg2NlFITzMreGNsTWdSNUcwZnZSV0RWeDVoZG1VYVE4TlhI?=
 =?utf-8?B?Q3BYUko4VFFGY3BRY1N1VkIwb2U1L3ZxZmt5dmpvM2Mvd3kwNTl2N0dIVjdL?=
 =?utf-8?B?VnpVazF0V1p3R1RYYmlKbk93NVVDdjZvbWN4VU9iUjBodXllaFN6blZoVHll?=
 =?utf-8?B?R0QyRWd4K3RuOVBFYU1sY0pCelZHSzdEbkRXNkN5Mm54OTM0SkMwM1VDMjVm?=
 =?utf-8?B?VXFOa1I1RFZNUktYK0xnc2hoeHlqbE43dzFsMjg0Z0ViS0xYWlZpd3pFdVZQ?=
 =?utf-8?B?RDMvd3ZEeXNDTVJtZXRSdkNldjFvL201bjdzc1oyYW5RQXEyRWR3VTJxZzBR?=
 =?utf-8?B?c1g0RXpSR2tiSEdsMUJmUGhMcFcyc2Y5ZXhsWUxaUXd4U2w3ZFRrTEc1RDg0?=
 =?utf-8?B?ejNNMWEzSkdGMEc3VzRLUEoyclFUTGVmMVMvclV2dEV5TFZmQWVkVG4ySmxP?=
 =?utf-8?B?NS84TU12UFg4blBuUld1aFFnYUplSWNubWdONFVEWWNYd0xmOWIwQW5seXFJ?=
 =?utf-8?B?UHJhMDdiWlAwbEd3T0VvWm83OFRxWVhJLzZJWEhHUjgzMTBJTHJLbjRMR1NM?=
 =?utf-8?B?VXMxUTVsSmRuMENoY3VXczAxbkd1MFYvbWtXQUt2OENseFNISXJqVm4rN3A5?=
 =?utf-8?B?RTJBQmx0a1AwWmNMZVdna1dDWlp2ckZCQ3hKV2xnOXdhT3RDZUtIcW1jTFF2?=
 =?utf-8?B?dG04Z2ZFRFhoR3hSZ01VS0JwNE4yT1VRR0RQZXUzSEJmLzhHd0d2MUpjQktx?=
 =?utf-8?B?TTd5ejcxdjV1MTlEaVhyKzFxcVJjVXI2M05ObkZjaGowa1NMVnBNcEh2YUpI?=
 =?utf-8?B?WkJDcWcrbStJMkNEd01HY1A0SG5iV0kzLzJOdXZYRDA1a1pnQmJ5c1F0cjIr?=
 =?utf-8?B?OG1oZG93c3IyeGVqZkR6U21UV2V2YVcxTEc1M0FmM2s1a3VYbVpuVVNZaUZP?=
 =?utf-8?B?NmhidEVGWHdaV0liZHdWMCtFeEFIb09EZ0FJRk5DcG9aM1Z3eFRKZ1d1MEpT?=
 =?utf-8?B?amwvY0dYREtiMXdkVkpsbDJrUXhGNkRkV3Q5d3p3R2xMQ0xXcGlLTUtlMUl4?=
 =?utf-8?B?aTdEdWdFd05ZVmZhcSs0WUtjaFhBcFlCNVZWQkYvdHBIY0Q5dXQ5Tm9aaVpu?=
 =?utf-8?B?RkZvd2N3VXdTWTkxZVdxK2c2UXVmdUV6Q1RseXlZOHkwQlRjOGlZL3AvZE5E?=
 =?utf-8?B?ME1sRXpYVzJVY0FGRE84eWVhaHdrKzIzUkZKaWltTGdjYXViUDJyTkp3dXZE?=
 =?utf-8?B?REdSSGgrdkRseU9WS2NPSXB1dFA5L0tnR0xKYkJOMFBIQUlMelR3ZHhsZXdO?=
 =?utf-8?B?ZGwwMHRnd0xKZ2o5NVVuVzZMNDJRVlRWK205ZWc3ai9jZFFOdFBEd3dJZFc1?=
 =?utf-8?B?SDNOVjRwd2Q2QWV0QXAxbktRTUkzYWpwemQwRnJTTFhaRmMxb3F6MkZvem9r?=
 =?utf-8?B?bnBhSlpockU1OUF0ODM0V0dKNWJoVXZNbUhTOFJ2MU82OG1mN1FaRldPOFA1?=
 =?utf-8?B?OVo1VHYzUlpNSkdHNWZyQSttaHhFUkI4aTNGMkY1c293amdDajBZanR1Q09x?=
 =?utf-8?B?UmNJa002S1BFM1N1bS9KbGYrRWlSak1FKytNSDB4VEJEQ0FVR3RZQlZRZnFU?=
 =?utf-8?B?Y2xhWjBTRHJEZzVpUE1rUFV4am95T0RaYVhTVmFXcU95YUxHY3A5VHduV3FP?=
 =?utf-8?B?SlhRSC92L0ZyRlRkaDNxMTF4VWtvVmxBRHVyUnNwcTRDV0FHUlBxSWFvOVNZ?=
 =?utf-8?B?ZzJxR2FhYzFzRnBiWis3eEZZMjh2NTJPbGpnMlNQaDlueENZYTZwWUUrTm9Z?=
 =?utf-8?B?OFcrSGZuS21wc2VPTWE3OVIvNVp3ZGhTN0tObitiaHJNNU1oQzByZmQ2VmJB?=
 =?utf-8?B?ZnRFWUttck1pajF5TUpTWU1HRVR0TEdCSkVoOUVteFF3OXQxa1pWSnNPRUpv?=
 =?utf-8?Q?hnrG5M+OPY4XuHnHmZ4lobJ17?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e05cbe0-1e20-41d7-e08b-08db0e07f0e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 21:19:07.1417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vyBnABvGaZJU7P/2NCC63hS/+J7ZPULPKEK/Hjs6ftWQrC0Q4B8NzEbtVXiteQH1ohU89eZo+pNwcE4SKBEJ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7756
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAyLzEzLzIzIDAzOjU5LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gVG8gYXZvaWQgZHVwbGlj
YXRlZCBjb2RlLCBhZGQgYQ0KPiA+IGhlbHBlciB0byBjYWxsIFNFQU1DQUxMIG9uIGFsbCBvbmxp
bmUgY3B1cyBvbmUgYnkgb25lIGJ1dCB3aXRoIGEgc2tpcA0KPiA+IGZ1bmN0aW9uIHRvIGNoZWNr
IHdoZXRoZXIgdG8gc2tpcCBjZXJ0YWluIGNwdXMsIGFuZCB1c2UgdGhhdCBoZWxwZXIgdG8NCj4g
PiBkbyB0aGUgcGVyLWNwdSBpbml0aWFsaXphdGlvbi4NCj4gLi4uDQo+ID4gKy8qDQo+ID4gKyAq
IENhbGwgQGZ1bmMgb24gYWxsIG9ubGluZSBjcHVzIG9uZSBieSBvbmUgYnV0IHNraXAgdGhvc2Ug
Y3B1cw0KPiA+ICsgKiB3aGVuIEBza2lwX2Z1bmMgaXMgdmFsaWQgYW5kIHJldHVybnMgdHJ1ZSBm
b3IgdGhlbS4NCj4gPiArICovDQo+ID4gK3N0YXRpYyBpbnQgdGR4X29uX2VhY2hfY3B1X2NvbmQo
aW50ICgqZnVuYykodm9pZCAqKSwgdm9pZCAqZnVuY19kYXRhLA0KPiA+ICsJCQkJYm9vbCAoKnNr
aXBfZnVuYykoaW50IGNwdSwgdm9pZCAqKSwNCj4gPiArCQkJCXZvaWQgKnNraXBfZGF0YSkNCj4g
DQo+IEkgb25seSBzZWUgb25lIGNhbGxlciBvZiB0aGlzLiAgV2hlcmUgaXMgdGhlIGR1cGxpY2F0
ZWQgY29kZT8NCg0KVGhlIG90aGVyIGNhbGxlciBpcyBpbiBwYXRjaCAxNSAoeDg2L3ZpcnQvdGR4
OiBDb25maWd1cmUgZ2xvYmFsIEtleUlEIG9uIGFsbCBwYWNrYWdlcykuDQoNCkkga2luZGEgbWVu
dGlvbmVkIHRoaXMgaW4gdGhlIGNoYW5nZWxvZzoNCg0KCSIgU2ltaWxhciB0byB0aGUgcGVyLWNw
dSBtb2R1bGUgaW5pdGlhbGl6YXRpb24sIGEgbGF0ZXIgc3RlcCB0byBjb25maWcgdGhlIGtleSBm
b3IgdGhlIGdsb2JhbCBLZXlJRC4uLiINCg0KSWYgd2UgZG9uJ3QgaGF2ZSB0aGlzIGhlbHBlciwg
dGhlbiB3ZSBjYW4gZW5kIHVwIHdpdGggaGF2aW5nIGJlbG93IGxvb3AgaW4gdHdvIGZ1bmN0aW9u
czoNCg0KCWZvcl9lYWNoX29ubGluZShjcHUpIHsNCgkJaWYgKHNob3VsZF9za2lwKGNwdSkpDQoJ
CQljb250aW51ZTsNCg0KCQkvLyBjYWxsIEBmdW5jIG9uIEBjcHUuDQoJfQ0K
