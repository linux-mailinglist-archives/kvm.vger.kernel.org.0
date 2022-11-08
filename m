Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F99620BF2
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 10:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiKHJRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 04:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbiKHJRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 04:17:08 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF842A279;
        Tue,  8 Nov 2022 01:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667899028; x=1699435028;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rucRydToUNb3KHYP2B8qd4bTLGheRQ+bbziIppbSW5s=;
  b=f6DDVcvGCHzdcAqLVcL2GLs0ZUL1WxCZKHGXmuglrXJqUlv89nR85b9x
   xdxx8XPUef3+KfVVHG83c6XYN020RR17D7VKitlWJOY7SnoYR6pefejX6
   jiOEcDjneh2brIeffVJyGQCcOFA3FYgQhSWIlnWUMSv1FhSlTRADRmOZS
   Yjg89LeHoFhISB/I14O7tGEcohZHZQrGHBvrVc0tbn1rvWWTusEszYacD
   uBj5Z0YOr3hbIcvv1Qx5QJo4S8vd7AIvUbgtU60JY0X/bcT3ZOc5J5GjU
   vPwfjJf7KmfxuHZRNzxIIgpyrW+Aq98DUX94Ktj3PGEZESCEK0FOlB0mt
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="291036339"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="291036339"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 01:17:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="965517299"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="965517299"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 08 Nov 2022 01:17:07 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 01:17:07 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 01:17:06 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 01:17:06 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 01:17:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqL85WlenNYE+X8m5oRU3p/awqJ5vIdSHn3hLWUXT1Smq1XRra2BxDcMQVxoNe+kvUMJVEWulCx70lWN5Kj7HhfBg39ZDk6iopCmRPUUpgLp6Y4/a9TBx7ZWyHMbAT9pLjgfdjCc/cO/en/MAteTHGbdcZjMWK7o3DcBdfHA23nCQBh6ZcbZRd6Bu05DYEx7wvAwaFrhOPqwRc7FrUipWaCJ64lIZi3pdp5QRS6dTNLLZa/dUrrAaxfjdTIDFo+7pkIT89J4BooKIndpUymsNGCHeAl/biEVz0XCQLtoAlCQEnlvJcDLPiEGovWqETeTF0U/MwBJF+iMGmPQlafQ4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rucRydToUNb3KHYP2B8qd4bTLGheRQ+bbziIppbSW5s=;
 b=XduSax8PBOW889yKhJgqZWnoWuCO6NesX6T6eKrHJRCq2AU2tpJ3OMtOGSEaNqScocXMoBUTDZiM/uuGTAin9CBPCrHLxGC/9ozjayCjJDaxL9hPGakyg7WVdHp28aJMf7GtK30YulmXWdjJh/IBnbjcYtNaNkgRNNvY1SLk7EeoaTckcmoPb6wZHEScnzgitm14eWouOt6rGSb+63B2BxIBc9k/GHmCjz3Q4knz6gGWtawAhnHFsq4iDvvCi4/J3YFD5GUKpFhg1Tf4kJifa17fDAW905L3j7OFijFhxxQG+r4xs/ydJqA+WZt2R3g/ALgv8NEkRJKaBrOl0dVZEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7273.namprd11.prod.outlook.com (2603:10b6:610:141::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 09:16:57 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 09:16:57 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 015/108] x86/cpu: Add helper functions to
 allocate/free TDX private host key id
Thread-Topic: [PATCH v10 015/108] x86/cpu: Add helper functions to
 allocate/free TDX private host key id
Thread-Index: AQHY7ChqeaySYrU8nUOPtGT5ELdyAq40zWEA
Date:   Tue, 8 Nov 2022 09:16:57 +0000
Message-ID: <b145dc3fcf5b2fd29241f4c8b5286b71402c7d7e.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <5ee7c6dc4ba03b5d5166e015c148ef534ee53f8e.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <5ee7c6dc4ba03b5d5166e015c148ef534ee53f8e.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7273:EE_
x-ms-office365-filtering-correlation-id: 903a099a-755b-48b9-3fab-08dac169fc29
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hklfwVIDCQiFFNp/DFZf5vMa4gyhjxidzcNHHhQS3UG6t9t1t6zNt+YVocZF3K8BAgmfySsr2xsGGn6l0Zdw0nXQN4Iv8VDyq531454RNFlFxM+KhNSp7CtNb9EZyX/mt0dSz8WhKrrl/VZxbtmEgEs5C+ApoeTo7E5tfq6p4PeREct1i4jjpW/0yDpuLzW0CEiGrkm6T+ZqezciRI6yqS1bt6NQ3iEHr5Bh9vNnHnDRrO5xSPJZqowHltwTJcGK84T11TdaVCa7uEcws4cR3Y7pLA4A9eXvBpY+EM3PGkVZvmhgmYWD9g7om6jCufCpFLVA4jrfWM3KXB9CrPHfx6R6bZnCPE+167le487bvicJfHo3B8FMSlC8TLQ2Rh1YCcnqeyW5cYVfoQj7fX6hSbWfVDShYVcsV/+bvP8kwk/LucilA7jzVKq/jz5JC+1g0xx+C5sjJ3d9fH//vJk2hvW2pyS3xPSyFthNcBOeBzouWyI+Ta2/6uHEUdt8dKiSIH07HJduCYWPG2JmDFjptt9X3p1j4NDa/02wHIBsgw4/SPXKGLfZRZseflUpo9kzAwTrRGCYXvJgH3na5QUg73IsZaMNwZAckza789QwDlS5ci8Ep5rUGDCENF6B3JIzu6F63DPWzaHQX9YkHlhmt57I0CeyGz/pkayJv6f28hY/rsBqKB6Li0x79CjMVNu4vdxnYHPY1FrdGstnSIaLmuOr5KQ+Wae2yk12QSHvXtt7RytQVCfMApYyHppMVbFiXIsJ7QoyDMc7bX/wXNcnFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(8936002)(82960400001)(41300700001)(38100700002)(8676002)(64756008)(91956017)(66476007)(66446008)(66556008)(66946007)(4326008)(4001150100001)(2906002)(36756003)(6636002)(316002)(54906003)(86362001)(110136005)(76116006)(6486002)(478600001)(71200400001)(6512007)(38070700005)(6506007)(122000001)(26005)(186003)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWxKMHNtM2gvRDZpWStnY0lVTWkzbnREL241eXB0SStreG5nTS8vWkxhM3BC?=
 =?utf-8?B?RUlmNFEyTVdQd2oxSEQ3WUxOSWltck5adytFd0lXZEVLMTUzMjRXSW5iam5R?=
 =?utf-8?B?MW4yUThkQ1B0aUlHRjFnTlpRMnVWM2xFU0h0VnVEYVVmQTIrQkpoMUtHVUho?=
 =?utf-8?B?cGlMVkdybkhma2liT3ZZYklLS3JOZG1TYmRJS25tTHVBSmdQa2NqRHpMcHFX?=
 =?utf-8?B?VDZxNmVHNDMzRGtSRFpKS2FZY1ZCLzFVNGVEYVdEMGZwOTIrRFlTcWRJSlVI?=
 =?utf-8?B?ckVqaGZVdVo4ZnpaVWpVMTc1UUg5dzNHMDFLelZFYVhuUWpybUhFemhUdmFT?=
 =?utf-8?B?dDQyemtGdW1kU0lSTGs1dTJvLzJXd1VaVEw2WHR6NnFvQWs2aVY1YjhtS0xO?=
 =?utf-8?B?UzM0cXlSV2dxbFNtejNQTW91Vk1XR3kvRzFXN3ZJak1oT0huSlhubGNSSlcv?=
 =?utf-8?B?Z0JEQ09jaXpweGF3OFJmdzI2RXlHeUg0YWJmeURFdi8rUXlISVg1R3NmOGdo?=
 =?utf-8?B?ZkZlYlRHN1BxV0JkYVEwL0JTQ1F4YjNkV1pEUExIZEpRWFVnTkJEa1U1Ymhq?=
 =?utf-8?B?U0VOTnJxd05XaVFscEFZSE1iaWIxZE0yZklERk0rVWw3RUl3QWIzN2VaSjha?=
 =?utf-8?B?WmlsMFBteEx6aGFwRHFTTEhtWHVwWTZMZmplOEdtWlBEZjFRamZ2Wk9vM3Bj?=
 =?utf-8?B?OHcyRmhqVXRWU3MrclZxWFpGa2pIWFhDbzc4eWZmK29yU2Q2Q0VPZDVMTUh1?=
 =?utf-8?B?UFZ1OUV5N0l0RldJcW05czdsbHlrYlJLUXBWMHd3UjFYUTRoUkxWT0FkM3l5?=
 =?utf-8?B?dzM3d1dDbG9TU0h3UDhRMXhla0JTRUxpOXVhR0I4UmV3Y3VQOVFlOWdNaU1t?=
 =?utf-8?B?TGdoQWxkRU80U2NKQTgyNVNQbEZFd0luU2ErTzljLzFEVXBnUXBqdjhLc0hi?=
 =?utf-8?B?ZlRBelduWHdtMFJKL09CWkUxRzRORGllNmNUS0JjVExZOUxhbkdKQ0tIekZ0?=
 =?utf-8?B?dGdIOVdnQWNxSFp0U3NFUHRsTllaT1JSRVpsM1NvWE1kMStlYXZhYUk0QldE?=
 =?utf-8?B?Nlprd3NnTGFmSWdmWUpjNXRMNUJXVWdmTVE3a3RGU1NsVm5qQjFuVGVQTEh6?=
 =?utf-8?B?OGZLM0RoQktJK0Nyd3ptU0dDQ1dxNEhJLzU5L1dtaFNVNnRyYktLck95a2ow?=
 =?utf-8?B?SFVGTW5CYWlxSExMblB4UXd5aytyVUt6dDRUMlkvcDVkR2tYUXNWMVhWU0VC?=
 =?utf-8?B?RVlHQ1R5ZEd2Nm85MnlyendXdy9UeUR2bXZTYzlwYTNhWlJNVWEzcFlITTd5?=
 =?utf-8?B?T01NdnM4c2ovVXNDQ0tBRENwRkdJUzUzZ3JCTUIzVk5HYzhGTDZEenVKVzZV?=
 =?utf-8?B?Ti9EMDM2OXJFRkl5SnZab1h1NGF2RmZBQ0RGNWNSelpxODlaU0VYVFVyWEpI?=
 =?utf-8?B?NWJlK3ZvMlQwcjRvNzFMUW56cWpmQ0ppME5mbTRoQ0d4VmM5d1JlQkUzSllz?=
 =?utf-8?B?cXlFdCtlRDhNcDRqTVhlOVBjWUtnTzVPT2RKSXpWUG5lNUJ1ci9EV2JDYlA3?=
 =?utf-8?B?Mm1LTFpGUFdDelhyYU9BeTRqWCtKVE5EcFExaWQxNFdTQWJyRWtTaFRVR3NO?=
 =?utf-8?B?bk1wY3pjL2w1SkIzWjZsYnpiKzllSzNzNnd0TlUxdHRqTW9maDZUdENKVjQ4?=
 =?utf-8?B?VHV2OGljTEU4TThzcTRYY0hVWTM4K3NvVjRIakdBZlkvdmw0VlIvOFhNeGlu?=
 =?utf-8?B?dXVoN2xlV0tsZHB5SnplKzloY1pSbWN1aWhhVEFLSkJ6M0N2MitNVkQ3T0pj?=
 =?utf-8?B?UUViaCtMQisrbGJGQjBNTk10SVFrNlpZcXUvWm1lTytWTHdwcVBNUzZLM0JK?=
 =?utf-8?B?ck9RUnNIdTlsVTJZbDJTSzVzRmpIZGplc3Z1b3NQalJHV1JxM3JZbWFma3Q5?=
 =?utf-8?B?dExFbGY5anV2c2lNeSs0dHhRRmtodTZkVUVha2FhbW8wTndUOEh6UkFCanNo?=
 =?utf-8?B?WFUyTDZRVDhod2h0Y2FKMGlNK1VGSTNVTTZtbllBanBEa3RxN1ZDNWl3cU1E?=
 =?utf-8?B?QkVoejdud1lkQUd5YUk0ZXhCdjdUcXgrdk03TTg2MWhYL2MxL1YyaXdlMmlM?=
 =?utf-8?B?d2JBTkhsNHV2QVRvTkZaa1V3STBuU0IvSFo0enZtVWFhR2pPOFBIcnIzdnFl?=
 =?utf-8?B?RUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE4F6195A1BAD54B882519DC3233BE7E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 903a099a-755b-48b9-3fab-08dac169fc29
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 09:16:57.2322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b6JOQ3pPC8YOmGbElBh3orzyyUlLnmIiJhDD0itx9ENyeRoIxapKVlWSzXaKu0cBiU9RvenVdw7TlVYmQpGhlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7273
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBURFggcHJpdmF0ZSBob3N0IGtleSBpZCBpcyBhc3NpZ25lZCB0byBndWVzdCBU
RC4gIFRoZSBtZW1vcnkgY29udHJvbGxlcg0KPiBlbmNyeXB0cyBndWVzdCBURCBtZW1vcnkgd2l0
aCB0aGUgYXNzaWduZWQgVERYIHByaXZhdGUgaG9zdCBrZXkgaWQgKEhJS0QpLg0KCQkJCQkJCQkg
ICAgIF4NCgkJCQkJCQkJICAgICBIS0lELg0KDQpBbmQgc2luY2UgeW91IGFscmVhZHkgbWVudGlv
bmVkIGluIHRoZSBmaXJzdCBzZW50ZW5jZSwgeW91IGNhbiBwdXQgKEhLSUQpIHBhcnQNCnRoZXJl
LiAgQW5kIEkgdGhpbmsgeW91IGNhbiBqdXN0IHVzZSBIS0lEIGluIHRoZSByZXN0IHBsYWNlcyB0
byBzYXZlIHNvbWUgdHlwaW5nDQphcyB0aGlzIGlzIHRoZSBwdXJwb3NlIG9mIHVzaW5nIChIS0lE
KSBJIHN1cHBvc2UuDQoNClsuLi5dDQoNCj4gIA0KPiArLyogVERYIEtleUlEIHBvb2wgKi8NCj4g
K3N0YXRpYyBERUZJTkVfSURBKHRkeF9rZXlpZF9wb29sKTsNCj4gKw0KPiAraW50IHRkeF9rZXlp
ZF9hbGxvYyh2b2lkKQ0KPiArew0KPiArCWlmIChXQVJOX09OX09OQ0UoIXRkeF9rZXlpZF9zdGFy
dCB8fCAhdGR4X2tleWlkX251bSkpDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArDQo+ICsJLyog
VGhlIGZpcnN0IGtleUlEIGlzIHJlc2VydmVkIGZvciB0aGUgZ2xvYmFsIGtleS4gKi8NCj4gKwly
ZXR1cm4gaWRhX2FsbG9jX3JhbmdlKCZ0ZHhfa2V5aWRfcG9vbCwgdGR4X2tleWlkX3N0YXJ0ICsg
MSwNCj4gKwkJCSAgICAgICB0ZHhfa2V5aWRfc3RhcnQgKyB0ZHhfa2V5aWRfbnVtIC0gMSwNCj4g
KwkJCSAgICAgICBHRlBfS0VSTkVMKTsNCj4gK30NCj4gK0VYUE9SVF9TWU1CT0xfR1BMKHRkeF9r
ZXlpZF9hbGxvYyk7DQo+ICsNCj4gK3ZvaWQgdGR4X2tleWlkX2ZyZWUoaW50IGtleWlkKQ0KPiAr
ew0KPiArCS8qIGtleWlkID0gMCBpcyByZXNlcnZlZC4gKi8NCj4gKwlpZiAoIWtleWlkIHx8IGtl
eWlkIDw9IDApDQo+ICsJCXJldHVybjsNCg0KRG91YmxlIGNoZWNrIG9mIGtleWlkID09IDAuDQoN
CkkgdGhpbmsgeW91IGNhbiBqdXN0IHVzZToNCg0KCWlmIChrZXlpZCA8PSB0ZHhfa2V5aWRfc3Rh
cnQpDQoJCXJldHVybjsNCg0KQW5kL29yIGFkZCBhIFdBUk4oKSBhcyBpdCdzIGEgYnVnIGlmIGFi
b3ZlIGhhcHBlbnMuDQoNCj4gKw0KPiArCWlkYV9mcmVlKCZ0ZHhfa2V5aWRfcG9vbCwga2V5aWQp
Ow0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwodGR4X2tleWlkX2ZyZWUpOw0KPiArDQo+ICBz
dGF0aWMgdm9pZCBfX2luaXQgdGR4X21lbW9yeV9kZXN0cm95KHZvaWQpDQo+ICB7DQo+ICAJd2hp
bGUgKCFsaXN0X2VtcHR5KCZ0ZHhfbWVtbGlzdCkpIHsNCg0K
