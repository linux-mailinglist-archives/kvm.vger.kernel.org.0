Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B229A6C76D8
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 06:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjCXFMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 01:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCXFMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 01:12:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7215328E5C;
        Thu, 23 Mar 2023 22:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679634742; x=1711170742;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xcIqOwKVJpVbEsyX/aoY7JyzQR1pXuwDYLvnfoJV2rM=;
  b=bOdrqcn9tg4M3eKqvLV5CiCLgy6YnR9JkrKek7NJYY5KlwAvlIbDN0Ul
   yh4KSFcql4zuB9sJaa+ZRevZKmt/dhRcnwBh5jkKVJVksGS8+oBE/eh/N
   ADA4SFgKWHVERsZWuA5xtDxt7z3IbAe+z1SvmmLFt7moHr6cd2J8xp7xd
   88fEduF7qTPz0zVSyAjbCDDe8lDP9irsDAXYqbj/DJ/9FuOHaCAJNq0CP
   +bfbDxO+eA2nvgf1KAgJmdjadi742XIaVUzleNOBoyaO39E0p3Tt9LUGR
   35OL1bpOWi14epvzBolvtVsQLdktePDZDfGUFsvafrkKwo1e4l+423OQC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="341261174"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="341261174"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 22:12:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="806520776"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="806520776"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 23 Mar 2023 22:12:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 22:12:21 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 22:12:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 22:12:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 22:12:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZJ22ioJyPwQIDmf7AozTjwZX04cEswWuKvz1ySjCMXMsEpsCR0lJq+11Z8tXPePysNnleNMDR38lI7oDLeg6IKy8ZkXRn33PCVN6JpuWMbP4GfcIcyYfceYnh1xVU+IVUeJ8bVcEJaDMJrWIjNZNbl8vLq4i2fO4aOGSROdTplvO43S9oSN+El2hFj88vKGdWtHUv0Yr1Po7qBQSdLTQvOYSq+e6UNalc39uurlbs5xHjXZXDkXTxVnHc3hdRVMjhVdT/KoYriYKmWTBLLcvhvGZmm0niI5ToDyDnuA7//E0g6348bYlyIPoR1MWnOT/lqThtfGYENChX3c2wxftQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcIqOwKVJpVbEsyX/aoY7JyzQR1pXuwDYLvnfoJV2rM=;
 b=ihMYXZpRd3adQ0SQpPyPk9Dd3cA8FOUu45llT5NZe/1Hqj/radpViBYWZV8vwGibDpHrzNCjAAuXsgSO9oC3snZGGzL6Xv4187ehnDMPCk6CssFfWs6IUZUvhJWMBY1OPoHnU/cOGpLFjK4PdTPn5aRmESi5biSPtRYBpq7y9zAlPTHtEkfsumDhLhFXT3bU1DOTWoLyYQxu1Mtpn+ZcLVpuDa+2/HEmcjhDol7uWInAsQAMQsEk0GB8lm29anvWN7VpUqz1M2g/XIqQHESG7KLuvmWNUG8ooJCkeX6mmF5x2V//qF8fQ5bdAJyOQhIB+YEJkQzCP1ISWrUqswrB9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH7PR11MB6980.namprd11.prod.outlook.com (2603:10b6:510:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 05:12:17 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%8]) with mapi id 15.20.6178.037; Fri, 24 Mar 2023
 05:12:17 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Wang, Lei4" <lei4.wang@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>
Subject: RE: [PATCH v13 019/113] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v13 019/113] KVM: TDX: create/destroy VM structure
Thread-Index: AQHZVQx9jCpObLPvOUuj99FckQrCRK8JRlcAgAAroHA=
Date:   Fri, 24 Mar 2023 05:12:17 +0000
Message-ID: <DS0PR11MB63737EE10F2A42B1497DE325DC849@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <7c011a5c9dd92cfb9074297af22d132a4e57fd11.1678643052.git.isaku.yamahata@intel.com>
 <a3c1de55-0d8c-239e-5cbb-ce57b065d625@intel.com>
In-Reply-To: <a3c1de55-0d8c-239e-5cbb-ce57b065d625@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH7PR11MB6980:EE_
x-ms-office365-filtering-correlation-id: 60e12e0f-2139-4579-3e1c-08db2c26567b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mx8ud7riA3NuR9nqwkFAz2Um+qHa5yWM+z1/Z+wUS20VOPsb+No4D8BH5F81GQlMFvHoPKq/V2Y89e1OCMvoqDd9Feeajy0rCfMoF/1wwmpt0vuXy3IIyrUr8WxZpXvkGQ4x6rpY9o8kyHI/yDe/PS3nXje6a94bjoZ82ZAeiClqrubQmumQ0Z0OVkE3nAk2HwptnYjNK5WqaixtFImzXfT70h35nQ7OrJASOAb74C/5CYvnZxtoJJJdDBo/H43LfA9T6DIeGbTw7jLUthq4uvx1UaILT5kPlDfWcZTbGyfmNoCW5lf5KfHUQSUS0e70pFcUKrTaVUSYQCFFiE+LW34WRQvPtu9an7YbJgTqxO87ocOHnk0pItkD4A0ZLAPz9y00hVPt+Q+Wr1vK/OYB5ifns3mA79cKBStjtqYhOhEAuWFK0GnIrsoRs1477YhPwFm4teFCXd/+BO3fg+zWEhaKoKjrGYM6fm732jVXJ5mwdySF5bjqwDmTVr7bzdftds4MZ8k6ujdVybmvLqSAcnOIaM+auQlhz6IXzJI8EpHJ8Y9nUlR2mYTbfRsc3Sf73wxTHALsR76T32yGbzLI5ti9F9xxEF41aLjBd5hdHo2QitLb51OaV3MRn4qDF8jEblXegcV5rzyZohPyDkkky9ZUihtfRbjNUfAQ8v1mMfBK+d1nexGuv642q/+vNZjlgQeQ5546WMJ1q+PSfCRqGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(55016003)(38070700005)(38100700002)(2906002)(478600001)(71200400001)(186003)(9686003)(316002)(33656002)(83380400001)(86362001)(7696005)(110136005)(8676002)(54906003)(76116006)(66446008)(52536014)(66556008)(64756008)(66476007)(66946007)(53546011)(4326008)(107886003)(6506007)(8936002)(26005)(5660300002)(41300700001)(82960400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3ZGQTdNS0VyT2NUSXZwS0dISXkxc1U5c2o3MDI4dFcrTHB3eUpBTXFSbFdR?=
 =?utf-8?B?RWtvbDdZQlZaWWFLaGN0RElndzRJbGpMUVl2L0x0a05KcWE2dm8vbnNsR2dC?=
 =?utf-8?B?aEJrZXZCSjIvQTU0QVg4S3BrY1BvK1ZpT0NodWFXN205b0g3MkxEdXlaSVpT?=
 =?utf-8?B?UzVNNGVzeU03WHhRcURJdWVmbHpkL0hpMy9zREQ2ZEZlTjF5cGQ5TUxpdzlL?=
 =?utf-8?B?anpPMVg2RzdpaS9Md0ZmUko4RklFVzYyUWVrQXNXaWVpOVc1QTJYdGN5ZjBa?=
 =?utf-8?B?OEt5N0Jmc2tMcXhhN0Y0aGY0eTAvaEFUOWt5N1BrRnJVVERrMk9JS2dVVDNV?=
 =?utf-8?B?VzNlK01uL3pUKzkyN2pBZlljZ2FyZEhyVmtISDBtYUhneDRTS2F1emQxVlI3?=
 =?utf-8?B?alhrUjh0STd5Q2Z2cml6OUVZRVk2cm1CSHNHeTI5bHhqcVArWTYxVXJzYldB?=
 =?utf-8?B?RkNYVUlpSVRTMnRkQjVnak1ibHNHS1lWYjQyMENDN0QxMVJFNVJySUs5SjV2?=
 =?utf-8?B?NjdpNzI2VGFpb3ZGTEc4M1pXWmRLZ3J3SG83RldMeHhFTldER2hpNlVCUzlm?=
 =?utf-8?B?d2tMN3JPa1hyYTl6NU1rWFdLNDVUWEtaSkg2OEtZcEl1ekpmWjJZUWZLR1Zx?=
 =?utf-8?B?UTNaQWxnMHFPc0VpZHdjSExrcmt3Yy9xUUpYR0d3dFVTaWJkODZKNy9XdWMz?=
 =?utf-8?B?NTdEYWpRaWRPaGc1NlM3Uys2azFBNVpOOGlZT3lOVVhGajJXcnFkNnlVSUxJ?=
 =?utf-8?B?NDBkOFk3SUU5RTF1WWVMMFdpc1MyR1I0VFJ0K01jdFJLU2RlZ0N2NjluRTY2?=
 =?utf-8?B?YWJsbVg0ZUtIdS9aSU9VdExpVFVLcnlvNHk4VXZCd3pIUGl5WG5aSHNFT2JE?=
 =?utf-8?B?aUF5dXJrTHlQMHpoQ3ptTFNRSCttL3VWamZGRFdEdU1aSE1UZXlqT0o4L2RI?=
 =?utf-8?B?Unp5aERkQU1wRFU5V05kaWoxSDhibFpCeEIyd010OTJXcUNJTWV1UThpN0Ni?=
 =?utf-8?B?KzI5TnIwL0lzVVF0SmxOTG14eDNYNEpsdVdhaC9iYXdsRUtpdzg2b0RURWpY?=
 =?utf-8?B?aHBKS280bU15VFFOSGVvQmwvUWlhTXVkQnZ2ZVBNaDJwekl4Q1Y2OS95R2lr?=
 =?utf-8?B?MjVIVHNJYTdsWlg5RG1BR1grZ3dQL1pIWHZkelJrUmlEMGRsTU1PclNvVzZQ?=
 =?utf-8?B?eCtZUTdTcjdzYUFsalZZT0U5ektFVnFzams4cUU3M2lrNE93dVQrUjhHa2FU?=
 =?utf-8?B?aDQyUGJKRjdyQ282QWR6LzBqQ2U0bCs0aWtiMDc5eUNxSnFYbVpMbExta2Yy?=
 =?utf-8?B?dklLR0F0U3RnQ2VseEs2aS9iMThCZWRXbnk5ME1UcjQ2Tnd1UlkvWUsyaWEy?=
 =?utf-8?B?Y2hEUVpjME8yLzZUOFBZblpDVzJpakZHK2w4RlhZVXMyZTZybzczUENlL0U0?=
 =?utf-8?B?R1pWenZrRXZ1TEVkZVY0RlMvL010TURtK1plN3o3WXA0d25sNVZ5RWl0Tng4?=
 =?utf-8?B?OUVRYmlzVTRVOUE0OUlFTFJCMzE1Nmg4Yjd0RnBGdk1OaGE0ZEdpUTRWcU1I?=
 =?utf-8?B?ZU82YTgvNnN3Y1Z5RWVUWHN1SHVvRkVEOWhRdDRnaTY0VURtelRRRXdVTzF4?=
 =?utf-8?B?c2grdXlGdC9wQVVWZEtjYThzU0hHOGVsdUw0TmNlLzNDdTBnQldVNTJUbm5l?=
 =?utf-8?B?b283Q0VOQW5HcVhkUjgydTc2dlZSckI4TjVFUXQ0ZVkySWdVYVpMczlqcGU2?=
 =?utf-8?B?MndBb0hzRnJxczdkOHhoRVdybVBRZVRqQkNnV1BCNTJ6cXZYNGdCSUg1c3Nx?=
 =?utf-8?B?QkNnb1JLT3VmUjRGalNVWHpMN0t0ZFFuREl2MEE5WjJnNTMvTktzeUV0ZlMw?=
 =?utf-8?B?UW1YYnBXekYvOHI2T0F0OFkxQU8za2tmWSt1bWhVZmRVNjh5VUhqRzd6b0pS?=
 =?utf-8?B?cDFyRjB5U0N0cFlsakJ3TjdmTERhdVVKMlpzSGJ6a08vaHIvNUFtanN6ZVN1?=
 =?utf-8?B?ZUtJOGZaODZtOHNmZjh3d2FvNFJSQy9OcFFvcVNYeGJtVkM5Nlg3aWxtL2R5?=
 =?utf-8?B?Q0Qwc0Z2U1VxS080bGdrSXBLZWpVNjlFTVpTN0tLTnQ4eVppZ053aDE2ZmZ0?=
 =?utf-8?Q?svDTCzunE6huKHIpB8XXIkpe/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e12e0f-2139-4579-3e1c-08db2c26567b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 05:12:17.4197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HkNHu9DEbo28QziXliA9xJYnNdpGuW2upFpwxgT8+1wdtQWk6E2sAjvMuCzytG278/I9avX54+ESbxrwzPlhrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6980
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpZGF5LCBNYXJjaCAyNCwgMjAyMyAxMDoyOCBBTSwgV2FuZywgTGVpIHdyb3RlOg0KPiA+
ICtzdGF0aWMgaW50IF9fdGR4X3RkX2luaXQoc3RydWN0IGt2bSAqa3ZtKSB7DQo+ID4gKwlzdHJ1
Y3Qga3ZtX3RkeCAqa3ZtX3RkeCA9IHRvX2t2bV90ZHgoa3ZtKTsNCj4gPiArCWNwdW1hc2tfdmFy
X3QgcGFja2FnZXM7DQo+ID4gKwl1bnNpZ25lZCBsb25nICp0ZGNzX3BhID0gTlVMTDsNCj4gPiAr
CXVuc2lnbmVkIGxvbmcgdGRyX3BhID0gMDsNCj4gPiArCXVuc2lnbmVkIGxvbmcgdmE7DQo+ID4g
KwlpbnQgcmV0LCBpOw0KPiA+ICsJdTY0IGVycjsNCj4gPiArDQo+ID4gKwlyZXQgPSB0ZHhfZ3Vl
c3Rfa2V5aWRfYWxsb2MoKTsNCj4gPiArCWlmIChyZXQgPCAwKQ0KPiA+ICsJCXJldHVybiByZXQ7
DQo+ID4gKwlrdm1fdGR4LT5oa2lkID0gcmV0Ow0KPiA+ICsNCj4gPiArCXZhID0gX19nZXRfZnJl
ZV9wYWdlKEdGUF9LRVJORUxfQUNDT1VOVCk7DQo+ID4gKwlpZiAoIXZhKQ0KPiA+ICsJCWdvdG8g
ZnJlZV9oa2lkOw0KPiA+ICsJdGRyX3BhID0gX19wYSh2YSk7DQo+ID4gKw0KPiA+ICsJdGRjc19w
YSA9IGtjYWxsb2ModGR4X2luZm8ubnJfdGRjc19wYWdlcywgc2l6ZW9mKCprdm1fdGR4LT50ZGNz
X3BhKSwNCj4gPiArCQkJICBHRlBfS0VSTkVMX0FDQ09VTlQgfCBfX0dGUF9aRVJPKTsNCj4gPiAr
CWlmICghdGRjc19wYSkNCj4gPiArCQlnb3RvIGZyZWVfdGRyOw0KPiA+ICsJZm9yIChpID0gMDsg
aSA8IHRkeF9pbmZvLm5yX3RkY3NfcGFnZXM7IGkrKykgew0KPiA+ICsJCXZhID0gX19nZXRfZnJl
ZV9wYWdlKEdGUF9LRVJORUxfQUNDT1VOVCk7DQo+ID4gKwkJaWYgKCF2YSkNCj4gPiArCQkJZ290
byBmcmVlX3RkY3M7DQo+ID4gKwkJdGRjc19wYVtpXSA9IF9fcGEodmEpOw0KPiA+ICsJfQ0KPiA+
ICsNCj4gPiArCWlmICghemFsbG9jX2NwdW1hc2tfdmFyKCZwYWNrYWdlcywgR0ZQX0tFUk5FTCkp
IHsNCj4gPiArCQlyZXQgPSAtRU5PTUVNOw0KPiA+ICsJCWdvdG8gZnJlZV90ZGNzOw0KPiA+ICsJ
fQ0KPiA+ICsJY3B1c19yZWFkX2xvY2soKTsNCj4gPiArCS8qDQo+ID4gKwkgKiBOZWVkIGF0IGxl
YXN0IG9uZSBDUFUgb2YgdGhlIHBhY2thZ2UgdG8gYmUgb25saW5lIGluIG9yZGVyIHRvDQo+ID4g
KwkgKiBwcm9ncmFtIGFsbCBwYWNrYWdlcyBmb3IgaG9zdCBrZXkgaWQuICBDaGVjayBpdC4NCj4g
PiArCSAqLw0KPiA+ICsJZm9yX2VhY2hfcHJlc2VudF9jcHUoaSkNCj4gPiArCQljcHVtYXNrX3Nl
dF9jcHUodG9wb2xvZ3lfcGh5c2ljYWxfcGFja2FnZV9pZChpKSwgcGFja2FnZXMpOw0KPiA+ICsJ
Zm9yX2VhY2hfb25saW5lX2NwdShpKQ0KPiA+ICsJCWNwdW1hc2tfY2xlYXJfY3B1KHRvcG9sb2d5
X3BoeXNpY2FsX3BhY2thZ2VfaWQoaSksDQo+IHBhY2thZ2VzKTsNCj4gPiArCWlmICghY3B1bWFz
a19lbXB0eShwYWNrYWdlcykpIHsNCj4gPiArCQlyZXQgPSAtRUlPOw0KPiA+ICsJCS8qDQo+ID4g
KwkJICogQmVjYXVzZSBpdCdzIGhhcmQgZm9yIGh1bWFuIG9wZXJhdG9yIHRvIGZpZ3VyZSBvdXQg
dGhlDQo+ID4gKwkJICogcmVhc29uLCB3YXJuIGl0Lg0KPiA+ICsJCSAqLw0KPiA+ICsJCXByX3dh
cm4oIkFsbCBwYWNrYWdlcyBuZWVkIHRvIGhhdmUgb25saW5lIENQVSB0byBjcmVhdGUgVEQuDQo+
IE9ubGluZSBDUFUgYW5kIHJldHJ5LlxuIik7DQo+ID4gKwkJZ290byBmcmVlX3BhY2thZ2VzOw0K
PiA+ICsJfQ0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBBY3F1aXJlIGdsb2JhbCBsb2NrIHRv
IGF2b2lkIFREWF9PUEVSQU5EX0JVU1k6DQo+ID4gKwkgKiBUREguTU5HLkNSRUFURSBhbmQgb3Ro
ZXIgQVBJcyB0cnkgdG8gbG9jayB0aGUgZ2xvYmFsIEtleSBPd25lcg0KPiA+ICsJICogVGFibGUg
KEtPVCkgdG8gdHJhY2sgdGhlIGFzc2lnbmVkIFREWCBwcml2YXRlIEhLSUQuICBJdCBkb2Vzbid0
IHNwaW4NCj4gPiArCSAqIHRvIGFjcXVpcmUgdGhlIGxvY2ssIHJldHVybnMgVERYX09QRVJBTkRf
QlVTWSBpbnN0ZWFkLCBhbmQgbGV0IHRoZQ0KPiA+ICsJICogY2FsbGVyIHRvIGhhbmRsZSB0aGUg
Y29udGVudGlvbi4gIFRoaXMgaXMgYmVjYXVzZSBvZiB0aW1lIGxpbWl0YXRpb24NCj4gPiArCSAq
IHVzYWJsZSBpbnNpZGUgdGhlIFREWCBtb2R1bGUgYW5kIE9TL1ZNTSBrbm93cyBiZXR0ZXIgYWJv
dXQNCj4gcHJvY2Vzcw0KPiA+ICsJICogc2NoZWR1bGluZy4NCj4gPiArCSAqDQo+ID4gKwkgKiBB
UElzIHRvIGFjcXVpcmUgdGhlIGxvY2sgb2YgS09UOg0KPiA+ICsJICogVERILk1ORy5DUkVBVEUs
IFRESC5NTkcuS0VZLkZSRUVJRCwgVERILk1ORy5WUEZMVVNIRE9ORSwNCj4gYW5kDQo+ID4gKwkg
KiBUREguUEhZTUVNLkNBQ0hFLldCLg0KPiA+ICsJICovDQo+ID4gKwltdXRleF9sb2NrKCZ0ZHhf
bG9jayk7DQo+ID4gKwllcnIgPSB0ZGhfbW5nX2NyZWF0ZSh0ZHJfcGEsIGt2bV90ZHgtPmhraWQp
Ow0KPiANCj4gSW4gdGhlIGxhdGVzdCAoTWFyY2ggMjAyMyB2ZXIuKSBJbnRlbMKuIFREWCBNb2R1
bGUgdjEuNSBBQkkgU3BlY2lmaWNhdGlvbiwgZXJyb3INCj4gY29kZSAweDgwMDAwMjAzIHJlcHJl
c2VudHMgVERYX1JORF9OT19FTlRST1BZOg0KDQpUaGlzIHBhdGNoc2V0IGlzIHdyaXR0ZW4gZm9y
IHdoYXQncyBkb2N1bWVudGVkIGluIHRoZSBURFggMS4wIHNwZWMuDQpXZSdsbCB1cGRhdGUgaXQg
Zm9yIDEuNSBsYXRlci4NCg==
