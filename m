Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC7B65193F
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 04:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiLTDFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 22:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiLTDFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 22:05:04 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D2B13D4A;
        Mon, 19 Dec 2022 19:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671505503; x=1703041503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9fh3t50WviA8oE0W3NCOfmRNQsm3IOEDZhVPWn3M4Jk=;
  b=AOPktMYWEKf/jcudt6ZAztQ68aHhWO2f6v4CTwjwU7pqshi3umGy+DF4
   G89OuxuwcIO+8HMqgLsnQBTQVjOCK6xxBVE/5lix1Kd0+x2NGiZSlIICx
   ITDtJqC6vv3WMWSx10LgB6FPaGgEs4ST1etIZJJnJlXoduRjaVIax7jo8
   6euqz7KwN88XzmTUWX58yr+I6GLsWLRARK76t6beAd2UYAqtzUid7G9+2
   m/+CDKCgDxCMCxRPT8A3AxOs9C/izo4eOFIwhOpQvq5rLyLg+TT0DSKr9
   bWKRSA1UxuaQvLZzDHdiQnrCpieqhndhg9HZQIyyqo+GUz3tCFgvKfnVH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302938033"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302938033"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 19:05:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="714254511"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="714254511"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 19 Dec 2022 19:05:02 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 19:05:01 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 19:05:01 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 19:05:01 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 19:04:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oek/J14gf2VzJA874AIy+d8h4zgwETPlWXhPInOd7Ftf9VF9IDYXhaYEPSGz0LMo9Wrz8B/V3Y3JvtqlKzMz7kjLQiTRqZ8s+33eQUnf+0EBmjAbv/r+E/8cNkyque/CDM6p2+CXgLvL0j0lcltUQfilpjZDbXl0npXtioR+oqoyCz7Q/9NBxszKJx18zw/aArMQab+gKvZTBC/gLlGmdxekrtPDzJjfpsecALcJ7wdcj6ovlBoOx+lz7snVjpuVaD5Jg7AeWIcw3/ors1qCA70LcNExZgyglN3sHZnoazmuSTWka81sgEBbRaqti986DHCl7/GBxqxioI22U1sVPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9fh3t50WviA8oE0W3NCOfmRNQsm3IOEDZhVPWn3M4Jk=;
 b=ASAOLQZTx0UrlOq3ddFNZbEiUH0bS+/2GooJlKwYtfzercr1MwTzzg8Tc/hdcbS9zxUWkkhoYMbuYpfYlLo7lkm3+nleARIMTf1YT8MnRilylLKuzgHwFysxN3kG3qaFRA46EdeRv9Lccj96GfNucZqT1gnLoOGvKfNba1wK7JKCBqRyz0+EkWZyd/cefmyUMWyBz5/N44aLBTmhd6hJEWlRE5SggFr3DRpesYrznhMz5CT2PdGWX5KZSISS71yXEmxtlKqcS+keJdHjx5b6oJyWO3KVxvBH0Zi8fCpTE2dumkTjPfLw0Sj8+L1T9Lbh+V6IPb7b3bglT7ygnmNCAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SN7PR11MB6677.namprd11.prod.outlook.com (2603:10b6:806:26b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.16; Tue, 20 Dec 2022 03:04:56 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::97ed:f538:dc6a:a9c4]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::97ed:f538:dc6a:a9c4%5]) with mapi id 15.20.5924.012; Tue, 20 Dec 2022
 03:04:55 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?5p+z6I+B5bOw?= <liujingfeng@qianxin.com>
Subject: RE: [PATCH] KVM: Destroy target device if coalesced MMIO
 unregistration fails
Thread-Topic: [PATCH] KVM: Destroy target device if coalesced MMIO
 unregistration fails
Thread-Index: AQHZE8418VzPZWSUokiiYWnmvIEhgq52BguA
Date:   Tue, 20 Dec 2022 03:04:55 +0000
Message-ID: <DS0PR11MB637301E9103F92EE5617D5B2DCEA9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221219171924.67989-1-seanjc@google.com>
In-Reply-To: <20221219171924.67989-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SN7PR11MB6677:EE_
x-ms-office365-filtering-correlation-id: 866faa82-ce97-465c-5d14-08dae236f8ec
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MJ67LRihDqAGGlUXbXc24AAcTsFeZg1zY4tgvaDZry7HcHdsO5sfNfqjp8msAx36SiJyIPPce2t43PEwhKiAFY2gX77xSH46MZ5mycONOiHMXXStUz8gl63okPfBw/1kZ2fGdaqVURJrwnaC+FePmgSoIr4OvTn4xpvDwiCmaVJy71fiUr5jZKHw6yxbh2QZIfw0at142QD6KZuZkUoxScv/6y1h/0AnepZMfYQ/KZcgZdzzsjU9Pmb12m1Ud8ydcZv2rsR8SKTYLzIrXWiKec/imjuRWcUTtlrl3FYQyfh7ADPublep6FG9d4WvCyWkf4Ti7GgHvrKsyk0EjRe11hJzbSwhzyy+of8Gh1wOFLL/ue7IioAa66j3+Wjw/ySIvoiykHYTVsOapUGCEtxeMqILEFBjNVEhUGFt6JqvasXOHTRIAR04Mt9jO81LCOnNngs7GvNJDo8iXHbesqR+9mguTU4eJQDJNKWuW1VrtA7cRUPtGdsqK4mmSzV3yDC0BteB/gz1Pc3DBBaXHCanVaHQq8L9CT2YoSWn/z46YAP6Mv2AKg3HQE20MJtTvDMI+8Z8RJofEUAsk9JgmrFsAw9hLBcewG0Itgj972m4KVwYcvnct5iztklZNN7P/g6IQWnQowJKEv1CKoaRjGleONzrlL3pTw5MJr0vcl+9Hof/5sKNixI3YfbcvAq+i3peHzK6Emf+jxsHtY6d0cS6MA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199015)(54906003)(38070700005)(6506007)(53546011)(7696005)(316002)(478600001)(82960400001)(38100700002)(110136005)(8676002)(4326008)(76116006)(66476007)(86362001)(122000001)(71200400001)(66446008)(66946007)(64756008)(66556008)(33656002)(52536014)(83380400001)(5660300002)(8936002)(9686003)(2906002)(41300700001)(186003)(26005)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1pCbVVwUnZNOVdXMmQ5TE9ndUlOM0VJcVBEYXlZbTRGa3JNUGxNUzMxdGhH?=
 =?utf-8?B?ZkVORHJJd3VrNzNFRThsRGg1RzZVVElsMktRQkRwbC96MnlucEY1K3MvS253?=
 =?utf-8?B?NVFwcjdrbW9MTG1mcDZhUWVuWVlWbDNyNEJxTWdnT0kvcHJueVZPS0c1RDZx?=
 =?utf-8?B?VlBnRTNHNEJ2U2xDakQyWUZBZ2VUQktWMllXSlhlUTNoWmNXMjZyQWxGUERO?=
 =?utf-8?B?WUJPb1doMzMvU0N5VGU5UTAwaXBzWTJYU3ZyaXVWMjd5WFZJN1QwWVQzazU3?=
 =?utf-8?B?RFo4bStxV0VOOFJlZUx0dzBqQkJHZ0RKU2JOK2NYOUZBQnZUZitqSURPNmhv?=
 =?utf-8?B?QnpkNjYrMUxNQ3pUMHhqeTloOHpZREFMQTlOaWJIV24wcXFSRHhwM0w5Q21C?=
 =?utf-8?B?dkU5aFJMeWZrTEEzUXJlclJkdnYyUEZHU2ZMcytKVW5DWnlRelA5eWV2SEpR?=
 =?utf-8?B?T25kYXRMbElWL09YWklUNTZkSlBpZVpiSlFkaExvMTgxbXAvNzNSU2NRY084?=
 =?utf-8?B?RG9kUFhab0ZyLzcvYTZWR2FwckZBbDlKWmUxam9UYmlNamxoOHV3dkRiK25x?=
 =?utf-8?B?WWVqOXFab1JmM052NHRTZW56ME1LaW5xTE5aaitZMFlpRzZIYUsxWlJzQ2hC?=
 =?utf-8?B?UkJzUk0rTm91QitLQ0w1RDMxMUdpMUZGSUdNN3hLYkJYY1dCUmNsMkxHa0xP?=
 =?utf-8?B?QVR5OGJyQ3pjOWdTTS9MdjRRZUwzSWZRYzk1UjJJNFNJVzNqNHRHVGhXYVcw?=
 =?utf-8?B?TkZVcWdoS2diSmZ3b1dTWEM2RHpxczd0MWRLRjY4a1dlVG54VlpyanlwdE9Y?=
 =?utf-8?B?cVFKMHdCd2tPMk5rSWNWSmlaQWFmOEZHUWtRYXU4Yzl3bU5DOTBPeHdMZkRT?=
 =?utf-8?B?ajhMSEZBZFF0WXJGQ3c0SUdmemk2d2pEZXFkY0d1TkJHSU9pUm9sMnN2Znly?=
 =?utf-8?B?bDN1TEpNNDI1dlNuTjVFbTRWM25lK0NjNnJKSExKU3I4SGs4d2UvMEh3Zk9Y?=
 =?utf-8?B?cktlTTM1eFNIL3ZjUW85eitGSmIzYk8yU1hUaXloRTV4RDFvaExyM1E4TXFj?=
 =?utf-8?B?QllVMFltaDhlYTZLUjdwazl0b25jYTQ0U2pFaExkUTY0aUZTbkY5R2ZxdzZE?=
 =?utf-8?B?WkxSTXpaaTlNUmYxdmVXRnVhN2gwZG5zN1o4THM0VG12WFUweWc4b2lrTkZ4?=
 =?utf-8?B?Rnl2SVZTWXZtQlovSnBUQll1YjB6dU9INTBCelk3WVArY1pwck83VmxDSHVB?=
 =?utf-8?B?SDdmVUFyZkJtTnNUSldTSUluelZZc3NsK2dGVFFjbEhqSjhoM1NGZlhtL29H?=
 =?utf-8?B?bnRTV1BSRWdrZlFOdFdFUDRkcFYzbG9xaFdVU0luZzFSVExKa3AyZTVuVkI4?=
 =?utf-8?B?QnhYWWkyUzJGRzJsV3NpbFE3YnpJN3lLVEN0dmQyV3RFd0dFUVc3aXgwcWU1?=
 =?utf-8?B?Ry85TUc3bndNTmowbUc4Ykd3RUF2a2NnSTUzNUg2L0ZNQWpFc0JnV2dsRFdo?=
 =?utf-8?B?aGpiM0xWaHhUU1hMTjZxMUZwb3JTOU4zdmpHZVdldmQ3WWdaWUQ1VGJoRUl6?=
 =?utf-8?B?Rmd0NHNaamp1ekNtZlA4WkFMN3BDaGNKSWNaVHJwOUVwdDNFZTh5OG00amsz?=
 =?utf-8?B?R2Y5ejh2MDVjSHRQSkI4K0gyVUdicWloM1FvUDd2LzRwbkVxOUptSWpvQTV4?=
 =?utf-8?B?a1ZSaDV2VkNLNXJpVnZtd3JqMTdNV2tReGcrWmpWK2tySGgzT3VkbFFyam1B?=
 =?utf-8?B?WEFjY3FDcE1rUytoZGRBWWIyUG4wSldpbk9QdG9MZXl0ZzYwcHFURk9ja2xo?=
 =?utf-8?B?MGcyN3lCNElja3F4MmptQUJ1T1NHRy9yMUtEVngxZ05NMThYMlRkU2RmOWZj?=
 =?utf-8?B?b1VvTHVwK2toK2cyY1hlRGpnM1BheGFaaDVvTlQvbnBPRTRxZDZZeTFxbHJh?=
 =?utf-8?B?V2lMNGZRL1NGUFA5ZlIzYWIzM0Q2b0tJazVDNTZRTDFjbDI3dFp5cDk4bDM2?=
 =?utf-8?B?Vm42am9PY2xkUy9kcVlrYS9mNXRpcFVTaHZHNXJvbVBwWjlZS0V0YTVveDh6?=
 =?utf-8?B?ZU1LUVlkNC9SQzI2dUVnWEMxcXJtZGl4RG8vRndTTE5Cb1ZnVWQzcGZpYmVy?=
 =?utf-8?Q?L0uDrneqDDYFVu82byq0VSjOn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 866faa82-ce97-465c-5d14-08dae236f8ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2022 03:04:55.8541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FAVZiDPhQQ1X86ibDnP5ImxYdOwgcgI4jt4ktl2zW6t+OOe6GCyVoEf3UvYJkRsFuEw2XIFdXlfx+ZXdqyMNUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6677
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlc2RheSwgRGVjZW1iZXIgMjAsIDIwMjIgMToxOSBBTSwgU2VhbiBDaHJpc3RvcGhlcnNv
biB3cm90ZToNCj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2NvYWxlc2NlZF9tbWlvLmMgYi92aXJ0
L2t2bS9jb2FsZXNjZWRfbW1pby5jIGluZGV4DQo+IDBiZTgwYzIxM2Y3Zi4uNWVmODhmNWEwODY0
IDEwMDY0NA0KPiAtLS0gYS92aXJ0L2t2bS9jb2FsZXNjZWRfbW1pby5jDQo+ICsrKyBiL3ZpcnQv
a3ZtL2NvYWxlc2NlZF9tbWlvLmMNCj4gQEAgLTE4NywxNSArMTg3LDE3IEBAIGludA0KPiBrdm1f
dm1faW9jdGxfdW5yZWdpc3Rlcl9jb2FsZXNjZWRfbW1pbyhzdHJ1Y3Qga3ZtICprdm0sDQo+ICAJ
CQlyID0ga3ZtX2lvX2J1c191bnJlZ2lzdGVyX2Rldihrdm0sDQo+ICAJCQkJem9uZS0+cGlvID8g
S1ZNX1BJT19CVVMgOiBLVk1fTU1JT19CVVMsICZkZXYtPmRldik7DQo+IA0KPiArCQkJa3ZtX2lv
ZGV2aWNlX2Rlc3RydWN0b3IoJmRldi0+ZGV2KTsNCj4gKw0KPiAgCQkJLyoNCj4gIAkJCSAqIE9u
IGZhaWx1cmUsIHVucmVnaXN0ZXIgZGVzdHJveXMgYWxsIGRldmljZXMgb24gdGhlDQo+ICAJCQkg
KiBidXMgX2V4Y2VwdF8gdGhlIHRhcmdldCBkZXZpY2UsIGkuZS4gY29hbGVzY2VkX3pvbmVzDQo+
IC0JCQkgKiBoYXMgYmVlbiBtb2RpZmllZC4gIE5vIG5lZWQgdG8gcmVzdGFydCB0aGUgd2FsayBh
cw0KPiAtCQkJICogdGhlcmUgYXJlbid0IGFueSB6b25lcyBsZWZ0Lg0KPiArCQkJICogaGFzIGJl
ZW4gbW9kaWZpZWQuICBCYWlsIGFmdGVyIGRlc3Ryb3lpbmcgdGhlIHRhcmdldA0KPiArCQkJICog
ZGV2aWNlLCB0aGVyZSdzIG5vIG5lZWQgdG8gcmVzdGFydCB0aGUgd2FsayBhcyB0aGVyZQ0KPiAr
CQkJICogYXJlbid0IGFueSB6b25lcyBsZWZ0Lg0KPiAgCQkJICovDQo+ICAJCQlpZiAocikNCj4g
IAkJCQlicmVhazsNCj4gLQkJCWt2bV9pb2RldmljZV9kZXN0cnVjdG9yKCZkZXYtPmRldik7DQo+
ICAJCX0NCj4gIAl9DQoNCkFub3RoZXIgb3B0aW9uIGlzIHRvIGxldCBrdm1faW9fYnVzX3VucmVn
aXN0ZXJfZGV2IGhhbmRsZSB0aGlzLCBhbmQgbm8gbmVlZCBmb3IgY2FsbGVycw0KdG8gbWFrZSB0
aGUgZXh0cmEga3ZtX2lvZGV2aWNlX2Rlc3RydWN0b3IoKSBjYWxsLiBUaGlzIHNpbXBsaWZpZXMg
dGhlIHVzYWdlIGZvciBjYWxsZXJzDQooZS5nLiByZWR1Y2luZyBMT0NzIGFuZCBubyBsZWFrYWdl
cyBsaWtlIHRoaXMpOg0KDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9rdm0vaW9kZXYuaCBiL2luY2x1
ZGUva3ZtL2lvZGV2LmgNCmluZGV4IGQ3NWZjNDM2NTc0Ni4uNTY2MTllMzMyNTFlIDEwMDY0NA0K
LS0tIGEvaW5jbHVkZS9rdm0vaW9kZXYuaA0KKysrIGIvaW5jbHVkZS9rdm0vaW9kZXYuaA0KQEAg
LTU1LDEwICs1NSw0IEBAIHN0YXRpYyBpbmxpbmUgaW50IGt2bV9pb2RldmljZV93cml0ZShzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA6IC1F
T1BOT1RTVVBQOw0KIH0NCg0KLXN0YXRpYyBpbmxpbmUgdm9pZCBrdm1faW9kZXZpY2VfZGVzdHJ1
Y3RvcihzdHJ1Y3Qga3ZtX2lvX2RldmljZSAqZGV2KQ0KLXsNCi0gICAgICAgaWYgKGRldi0+b3Bz
LT5kZXN0cnVjdG9yKQ0KLSAgICAgICAgICAgICAgIGRldi0+b3BzLT5kZXN0cnVjdG9yKGRldik7
DQotfQ0KLQ0KICNlbmRpZiAvKiBfX0tWTV9JT0RFVl9IX18gKi8NCmRpZmYgLS1naXQgYS92aXJ0
L2t2bS9jb2FsZXNjZWRfbW1pby5jIGIvdmlydC9rdm0vY29hbGVzY2VkX21taW8uYw0KaW5kZXgg
MGJlODBjMjEzZjdmLi5kNzEzNWE1ZTc2ZjggMTAwNjQ0DQotLS0gYS92aXJ0L2t2bS9jb2FsZXNj
ZWRfbW1pby5jDQorKysgYi92aXJ0L2t2bS9jb2FsZXNjZWRfbW1pby5jDQpAQCAtMTk1LDcgKzE5
NSw2IEBAIGludCBrdm1fdm1faW9jdGxfdW5yZWdpc3Rlcl9jb2FsZXNjZWRfbW1pbyhzdHJ1Y3Qg
a3ZtICprdm0sDQogICAgICAgICAgICAgICAgICAgICAgICAgKi8NCiAgICAgICAgICAgICAgICAg
ICAgICAgIGlmIChyKQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCi0g
ICAgICAgICAgICAgICAgICAgICAgIGt2bV9pb2RldmljZV9kZXN0cnVjdG9yKCZkZXYtPmRldik7
DQogICAgICAgICAgICAgICAgfQ0KICAgICAgICB9DQoNCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9l
dmVudGZkLmMgYi92aXJ0L2t2bS9ldmVudGZkLmMNCmluZGV4IDJhM2VkNDAxY2U0Ni4uMWIyNzdh
ZmI1NDViIDEwMDY0NA0KLS0tIGEvdmlydC9rdm0vZXZlbnRmZC5jDQorKysgYi92aXJ0L2t2bS9l
dmVudGZkLmMNCkBAIC04OTgsNyArODk4LDYgQEAga3ZtX2RlYXNzaWduX2lvZXZlbnRmZF9pZHgo
c3RydWN0IGt2bSAqa3ZtLCBlbnVtIGt2bV9idXMgYnVzX2lkeCwNCiAgICAgICAgICAgICAgICBi
dXMgPSBrdm1fZ2V0X2J1cyhrdm0sIGJ1c19pZHgpOw0KICAgICAgICAgICAgICAgIGlmIChidXMp
DQogICAgICAgICAgICAgICAgICAgICAgICBidXMtPmlvZXZlbnRmZF9jb3VudC0tOw0KLSAgICAg
ICAgICAgICAgIGlvZXZlbnRmZF9yZWxlYXNlKHApOw0KICAgICAgICAgICAgICAgIHJldCA9IDA7
DQogICAgICAgICAgICAgICAgYnJlYWs7DQogICAgICAgIH0NCmRpZmYgLS1naXQgYS92aXJ0L2t2
bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4uYw0KaW5kZXggMTNlODgyOTdmOTk5Li41
ODI3NTdlYmRjZTYgMTAwNjQ0DQotLS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5jDQorKysgYi92aXJ0
L2t2bS9rdm1fbWFpbi5jDQpAQCAtNTIwMCw2ICs1MjAwLDEyIEBAIHN0YXRpYyBzdHJ1Y3Qgbm90
aWZpZXJfYmxvY2sga3ZtX3JlYm9vdF9ub3RpZmllciA9IHsNCiAgICAgICAgLnByaW9yaXR5ID0g
MCwNCiB9Ow0KDQorc3RhdGljIHZvaWQga3ZtX2lvZGV2aWNlX2Rlc3RydWN0b3Ioc3RydWN0IGt2
bV9pb19kZXZpY2UgKmRldikNCit7DQorICAgICAgIGlmIChkZXYtPm9wcy0+ZGVzdHJ1Y3RvcikN
CisgICAgICAgICAgICAgICBkZXYtPm9wcy0+ZGVzdHJ1Y3RvcihkZXYpOw0KK30NCisNCiBzdGF0
aWMgdm9pZCBrdm1faW9fYnVzX2Rlc3Ryb3koc3RydWN0IGt2bV9pb19idXMgKmJ1cykNCiB7DQog
ICAgICAgIGludCBpOw0KQEAgLTU0MjMsNyArNTQyOSw3IEBAIGludCBrdm1faW9fYnVzX3JlZ2lz
dGVyX2RldihzdHJ1Y3Qga3ZtICprdm0sIGVudW0ga3ZtX2J1cyBidXNfaWR4LCBncGFfdCBhZGRy
LA0KIGludCBrdm1faW9fYnVzX3VucmVnaXN0ZXJfZGV2KHN0cnVjdCBrdm0gKmt2bSwgZW51bSBr
dm1fYnVzIGJ1c19pZHgsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3Qga3Zt
X2lvX2RldmljZSAqZGV2KQ0KIHsNCi0gICAgICAgaW50IGksIGo7DQorICAgICAgIGludCBpOw0K
ICAgICAgICBzdHJ1Y3Qga3ZtX2lvX2J1cyAqbmV3X2J1cywgKmJ1czsNCg0KICAgICAgICBsb2Nr
ZGVwX2Fzc2VydF9oZWxkKCZrdm0tPnNsb3RzX2xvY2spOw0KQEAgLTU0NTMsMTggKzU0NTksMTgg
QEAgaW50IGt2bV9pb19idXNfdW5yZWdpc3Rlcl9kZXYoc3RydWN0IGt2bSAqa3ZtLCBlbnVtIGt2
bV9idXMgYnVzX2lkeCwNCiAgICAgICAgcmN1X2Fzc2lnbl9wb2ludGVyKGt2bS0+YnVzZXNbYnVz
X2lkeF0sIG5ld19idXMpOw0KICAgICAgICBzeW5jaHJvbml6ZV9zcmN1X2V4cGVkaXRlZCgma3Zt
LT5zcmN1KTsNCg0KLSAgICAgICAvKiBEZXN0cm95IHRoZSBvbGQgYnVzIF9hZnRlcl8gaW5zdGFs
bGluZyB0aGUgKG51bGwpIGJ1cy4gKi8NCisgICAgICAgLyoNCisgICAgICAgICogSWYgKG51bGwp
IGJ1cyBpcyBpbnN0YWxsZWQsIGRlc3Ryb3kgdGhlIG9sZCBidXMsIGluY2x1ZGluZyBhbGwgdGhl
DQorICAgICAgICAqIGF0dGFjaGVkIGRldmljZXMuIE90aGVyd2lzZSwgZGVzdHJveSB0aGUgY2Fs
bGVyJ3MgZGV2aWNlIG9ubHkuDQorICAgICAgICAqLw0KICAgICAgICBpZiAoIW5ld19idXMpIHsN
CiAgICAgICAgICAgICAgICBwcl9lcnIoImt2bTogZmFpbGVkIHRvIHNocmluayBidXMsIHJlbW92
aW5nIGl0IGNvbXBsZXRlbHlcbiIpOw0KLSAgICAgICAgICAgICAgIGZvciAoaiA9IDA7IGogPCBi
dXMtPmRldl9jb3VudDsgaisrKSB7DQotICAgICAgICAgICAgICAgICAgICAgICBpZiAoaiA9PSBp
KQ0KLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsNCi0gICAgICAgICAg
ICAgICAgICAgICAgIGt2bV9pb2RldmljZV9kZXN0cnVjdG9yKGJ1cy0+cmFuZ2Vbal0uZGV2KTsN
Ci0gICAgICAgICAgICAgICB9DQorICAgICAgICAgICAgICAga3ZtX2lvX2J1c19kZXN0cm95KGJ1
cyk7DQorICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07DQogICAgICAgIH0NCg0KLSAgICAg
ICBrZnJlZShidXMpOw0KLSAgICAgICByZXR1cm4gbmV3X2J1cyA/IDAgOiAtRU5PTUVNOw0KKyAg
ICAgICBrdm1faW9kZXZpY2VfZGVzdHJ1Y3RvcihkZXYpOw0KKyAgICAgICByZXR1cm4gMDsNCiB9
DQoNCiBzdHJ1Y3Qga3ZtX2lvX2RldmljZSAqa3ZtX2lvX2J1c19nZXRfZGV2KHN0cnVjdCBrdm0g
Kmt2bSwgZW51bSBrdm1fYnVzIGJ1c19pZHgsDQo=
