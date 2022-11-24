Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8BB6380EF
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 23:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKXWjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 17:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiKXWji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 17:39:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7740E9DBBB;
        Thu, 24 Nov 2022 14:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669329576; x=1700865576;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=O/yZD16+ow6xa2tYM2kMwgyF6dFqp5DKxYl22j0dLiE=;
  b=Y/OIHwex7dNgr4RMjkRVQOvM0MJUYi2uvxCRriGw94VO6WanKxMf3fjp
   038zO0BjDG6meuBVbAiz750JaCCUGtYlYHkVWTmxdzisT3RYzsvdsh1eX
   x4SIh6erAqs5H2hZWJDtbBMfUpYbPDQ1xqybKx0kK0QdX6gSUVQhmUQ9u
   w5OZJEK1WKcy/EuwN7HmiH0+dhUVOk/B77wyAQMJwivJfBWCYxbT3IrFt
   8tGgyq2qVzEVardbqGS8tyP/IJ/jfyEsdz4MxKRU4cjwUuV1CUGZdRqHI
   D2U+v8WkJBD7pGhHinLgv6HQAocb/MJ73N2UnYIs7+lYnpzyu2JhIEqj0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="314408552"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="314408552"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 14:39:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="675210771"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="675210771"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 24 Nov 2022 14:39:36 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 14:39:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 14:39:35 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 14:39:35 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 14:39:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cg79secgKGc8Iljt0n2kfA6wCy34zJVY5D37jEWo00WKH+Z+j+NXkZF9PV6e9snL2TcXRcg3rqfNtz1p7Ajdjt4BxEkOH2pXJzKCu3BWFQh+1Kz5ZF+Vxgrl24xVxAn07o4G+zTdKMBNibAEZ/Drdq+RoDsm1RxNGGhOF9ehSBnFES8dRWDjCUjQaN3GndCsXr4kcRg78Qr1XMrsZyuD9VsA3oE5+uLTrWvhQDD2auA2praVM6+kSG0XaOXVXjXS5Jk0bNPN8h6/tVLiU6wfPFr3xGpAaEPqzZ5J+ProOkLA/hqMIyKSsu2N4IWieDKMQyi7D/qZGpNMftte64rocQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/yZD16+ow6xa2tYM2kMwgyF6dFqp5DKxYl22j0dLiE=;
 b=lRQ0ZI6UXDMZvWcenktX3SZIRyoB1uUL2GDeLTWRDrxUec+i8f+vjR4Iu9vGCCTHpg7HUwm8Nk7xwVPQs/JIcZl1HlOwJAwXWkehNSXXf8Khrjt2WMqmZRR/4yqn287yc6FQbaBfjYK3OEorFdATLekjlUt9l9pYtot6NwCfgmRi1CDPTzVJS31/RwToqzT71991CVUNV1j1euRu4jZ2yHI4b4zzaFfkAJ2RqUo14OXCORr0bdYzEtWpPK9MemVlayTzmjKwMM2RTnPpBZGfeDhDusJeCrtUaB7aKZFJLC9MGUI8x1lXkiDgxD2j7NASjJITGCG+fbRgsQ3dFSOtsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5133.namprd11.prod.outlook.com (2603:10b6:a03:2ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 22:39:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 22:39:30 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 15/20] x86/virt/tdx: Reserve TDX module global KeyID
Thread-Topic: [PATCH v7 15/20] x86/virt/tdx: Reserve TDX module global KeyID
Thread-Index: AQHY/T3MNBi/d00vWkGyDsvL+6pjqq5NL36AgAGBQIA=
Date:   Thu, 24 Nov 2022 22:39:30 +0000
Message-ID: <529a22d05e21b9218dc3f29c17ac5a176334cac1.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <fec007c0193e5f0509450de78052346da1045b23.1668988357.git.kai.huang@intel.com>
         <9c36d878-db83-5c0e-90f3-8f19dd25801c@intel.com>
In-Reply-To: <9c36d878-db83-5c0e-90f3-8f19dd25801c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5133:EE_
x-ms-office365-filtering-correlation-id: 576633ef-d0b9-4f8d-b738-08dace6cc022
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ndPyu6n3pnOivKMn34YjTJgAn0znCPb4KycTY2loppwlTFhhZyZUmiutHKe/rWSULgufSiqX/Wt/hAp0R/NHGRdBhfCO8AE/XQTNJFanIiz9udub/i0PBOA63LaDiwEN5fOV+InFSsqdhxGsgtV8UCX3WycV9OPp+sM6t0aVFgC7QiS8YOB9G0pneZSxDV8gub/Q0q3kQfhWMwpsCG55Ee0o4stRRWRu/yHFpRgGqp+s5OyOUAoykpAivCjXlUjhWhq03z1FhnpQQOH6+2hZhu7sUw0mAVa0hl5px0V367k7XRD13ZCcAzsh+bXU8/IoSNSmGCllkdJF6dCcT30BZWpaMpYLKb7QlYCT9JmuN8OOZXtCgg2Nnb83wDzWWzQvG+cWf96g6P5GAANoAVmvEaaIBP6ut7uc3Eum+YlTt3i+KfkyZXjP5+C+wPC8bUvK4u0D9dd31xbgMw08jYqEKYSK4I68AHa3oved2fA6EozMXXFYkeQf9wOm2FEuaU+qcBAIP/9asRos2biUZiSVi7jRMs2F1mlN9V1f56y20tRIF/xYLADlb5F0fStO7zfm5E/ooeMQaNKcK5m+EWNdtjPyUskRIWwQIMbCeozsZLaZOXpbtInHJ5HuML4Tq4G4ZxuyT4/zaFkaR+BTaJoKlL9T5SUjAyCa3fs4iSGIJKuHqj+TF3m9fEvRKpRQAstDQqVPgGYdKTFr2p9wrAP1PA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(36756003)(4001150100001)(2906002)(2616005)(41300700001)(4744005)(5660300002)(7416002)(186003)(8936002)(38100700002)(86362001)(122000001)(38070700005)(82960400001)(53546011)(6506007)(6512007)(26005)(110136005)(6486002)(316002)(54906003)(71200400001)(91956017)(4326008)(66476007)(66446008)(66556008)(64756008)(478600001)(66946007)(76116006)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qk03YmF1N0h2VDlFckNueTRFYkJSa2VxZXV2cmd3VlV0UmlDTi9YOXVtaFFY?=
 =?utf-8?B?aGYrTWQ5OS8rejFqNmVRL2tUSm0yZ2lGV3VYT2kzanZaZnFzTkdjcFVqbEhH?=
 =?utf-8?B?UVhXd3djcnlwYXRrellZKzlGQkRFaG5OQ0QrbHpXeWsxY2h6SW1FUnNKZ0JH?=
 =?utf-8?B?TDlBRjdLY2dwVld3YThQRmpyV1pWVDlva01WSUxvRmFwRVBrSkdaNmJWMnB6?=
 =?utf-8?B?eGk3WWJDV1ZYMCs5clgwMlcycE03bis1V1czS1RuRDVvR2lMZTZIamZNOXJa?=
 =?utf-8?B?YmlnenZ4Skp6ODRNbnl5WFMxOHB5Y0FBOEZBcmdmZHVNOHdOOG9qTmpQVWF1?=
 =?utf-8?B?OHNyMlJNNVZEMExlUXJNWUtkNktyaHpUVFo1YW1YcGlFdXh1d2U0SVhCL0k1?=
 =?utf-8?B?VzhQSDBLVHBVS25lT0UyVjY4cTJ0ajVIUlZiTmNob3R5ZlZKUStLUEYzL2ky?=
 =?utf-8?B?OUVpTGkxdkVJUjc1d1JSeWxtazlTTEV5YVZvVWp2WEtJblFkbzUrenVqbFVJ?=
 =?utf-8?B?YmZxOENudVl3NnEzZ09nM0V1RlJzSllvQ1BWMVNCeU5INnJYcHBIT2RKL2d5?=
 =?utf-8?B?VzFaVGd3VkQ3U1hyS0dyVnU4RkRtNkNPanN2UFRNRnVRaklmWklZTTl4L3RG?=
 =?utf-8?B?S21ZbS9LMEtpQ0FLZVgwcXdXOUNzalhldVpRcUJVQWFWNE5nNVNnS05FNWQ3?=
 =?utf-8?B?Y0g5QkRGamRVZVNFejQreGJKUlBaSDgxTGRvVXF5cmM0Sm9WVUdXc3BxUURm?=
 =?utf-8?B?YkRod3UwcnhHRkNLVkpUT2dTVmVxK1BMRzlWRjVpMFBhZ3EySm45d1FKalNk?=
 =?utf-8?B?S0hCWUQ4OHdIeHFpSmJQU09MT05OWjlxVURjSUpXV0Zwdmk5dEs1Q2NRbnVh?=
 =?utf-8?B?S1RxTlZQT3ZUUkJJQ1JDeXZZZXRSY0E2cm1xbHRhQndxeUx2djc2SCsyU09L?=
 =?utf-8?B?VUVWSkJMWUJWKzRTODRENEhhVW41RU5PTkdQUkZXMmlOazVnQ0kvYzNSRXhL?=
 =?utf-8?B?MDJJa0ZNdWRRdjkxMmNpYytudEtHRWJIb3JkcXd3bkpFdlNjNTluS2t3bHQy?=
 =?utf-8?B?WWQxRnNOcng2a09wSitwbERldnZRWCs2MFVpblU3NHhKMWxUTlBmN3AyVGpk?=
 =?utf-8?B?bUw3OE9zSEFjeThtY2tlcVlnWlF6V3dWQ243TFVyVkU5VHNPS3lSM1pUM2Nq?=
 =?utf-8?B?NnFQSjUwRmFPMHJYNWRvVUdKRFhQODM1UFEyUXJDWmpKZ1FDNVIrTXN4V1Ji?=
 =?utf-8?B?OENGZWFrTWpVMTR1WjcvLzZwcDJodXBCSm9RRUUyaU4zN01rMlhMajVycmt5?=
 =?utf-8?B?cTIvR0ZnUEdQb3dwcmJRRC9zNVErTm5mK21MTzJTSnZpMStNbVlwUU0xT05L?=
 =?utf-8?B?TWJ2aTVmRnQxVHBuS0llYmVLVlFyNzc4YUlRYk1oc0xPMDNzYTFiUEVhRTVN?=
 =?utf-8?B?VHYrVDF2V1B6SmpPYmpFRkpHVVV3eURFOHl5eGpyT3o5dFB3ZUNuWXBpWVVM?=
 =?utf-8?B?WW4xNWYraHNUSVQwQzZhQVFKSzU1N2lCMzc3bGNWUDBMZDhrNjhRUDhzUEVT?=
 =?utf-8?B?cHZWOFdzN0dtYm02d0x6SHBxNHdMaFByN3Q1ZzFSNFZVNHFUWlcxVmlkMTN3?=
 =?utf-8?B?VnlSTEc1NEVjWTNPdEF2TzFBb3l3SkhwYjdIcmJub0ZqKzhVdTBzNVNLbkN6?=
 =?utf-8?B?MXp2QVYvVHRhOElhMDVxSEZOOWw3aG5NbGVFOVZNNWRSWitXbSs0Z2RJZ3Q0?=
 =?utf-8?B?OUJNMHM4TUQ3bHFEdnFoVDlPUEFOVU1IamN6UU5nUDh2OXUrNHljQlhvUXJv?=
 =?utf-8?B?ZWRRWThhY3poT3Vtc3hrK3IvNTB0NVFyazQrVUxZeHFybUxoZmNtRnJrWHky?=
 =?utf-8?B?QjladGVyb1hBWi9TMHdDZVEwbHBsSHc1alA3dyszMFF1dnN6UzcvWnF1N054?=
 =?utf-8?B?YzhucE0yb1ZRdThPVEsrZzV3REtmNFlmV3RaN1o0OXpiU3NTemcySUI5N3pl?=
 =?utf-8?B?M29BMnViL2U5Q215dExBbjhNeWVnYWpCbmpkUFpJRDBlSEhZOTFHeTBjRE5t?=
 =?utf-8?B?K214R1dFVEQwdmJob3o0S1lodzIrb1l5bXAvMXpMTEoyTUVFd0hIZTdrY0Vz?=
 =?utf-8?B?OERJVGFUN2tDTGxWT3RCSFpOZlFOU09LY3hQbTQzUEpCRlczMURuMXVtdktu?=
 =?utf-8?B?eFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A026EC67F6BC045BD64D6871255A7A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 576633ef-d0b9-4f8d-b738-08dace6cc022
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 22:39:30.1324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tACgSFjH+26u5nBnl5/TKGw4mutDaBAZJULHYcMgvCAB6lvuCaZoP4KxTmjQIVhMWfuSDW9DFfq+pJ/od9HoHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5133
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDE1OjQwIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjAvMjIgMTY6MjYsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBAQCAtMTA1Myw2ICsxMDU2
LDEyIEBAIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ID4gIAlpZiAocmV0KQ0K
PiA+ICAJCWdvdG8gb3V0X2ZyZWVfdGRtcnM7DQo+ID4gIA0KPiA+ICsJLyoNCj4gPiArCSAqIFJl
c2VydmUgdGhlIGZpcnN0IFREWCBLZXlJRCBhcyBnbG9iYWwgS2V5SUQgdG8gcHJvdGVjdA0KPiA+
ICsJICogVERYIG1vZHVsZSBtZXRhZGF0YS4NCj4gPiArCSAqLw0KPiA+ICsJdGR4X2dsb2JhbF9r
ZXlpZCA9IHRkeF9rZXlpZF9zdGFydDsNCj4gDQo+IFRoaXMgZG9lc24ndCAicmVzZXJ2ZSIgc3F1
YXQuDQo+IA0KPiBZb3UgY291bGQgYXJndWUgdGhhdCBpdCAicGlja3MiLCAiY2hvb3NlcyIsIG9y
ICJkZXNpZ25hdGVzIiB0aGUNCj4gJ3RkeF9nbG9iYWxfa2V5aWQnLCBidXQgd2hlcmUgaXMgdGhl
ICJyZXNlcnZhdGlvbiI/DQoNClJpZ2h0LiAgSSdsbCBjaGFuZ2UgdG8gdXNlICJjaG9vc2UiLg0K
