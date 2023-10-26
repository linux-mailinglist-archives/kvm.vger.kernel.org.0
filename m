Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6827D8B65
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 00:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344904AbjJZWHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 18:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjJZWHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 18:07:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A66AB;
        Thu, 26 Oct 2023 15:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698358021; x=1729894021;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aynL1iuw/2e9IEyDgaZ14nU9B7a3i39aIFX0qCEaBeA=;
  b=D7nFJ7KOSsV7mvguo+yrqcu/+yGij+IBJ+xdjguHtU//lEUWTbnM5spP
   vbSqLJDwPMSAQ2iJ+Fmomk92Q9NRn6qgsewBU9gc7X5Rv9lWnYG1ccdfp
   GzsKWV5l2Y6gafYdDnWt/Gy1OP4ZtS4kswq7SiVGNfxJyyXLoEaWZmEh4
   TAkhfjSE8N+5yy79K1vdRdm3+x4MlD4i+GWM9uYj+8EwNcpuodMpwZEyW
   rdGUieyEFa4M0513mKAax+jU0oMwmsYizA5NXXGT4k+o+M6WUBbyF7GQg
   a1kwj2zLpXChlFBqvNts3Y6lbyB3Yd1J5qKfvOMfI3unjrnGE4BPTcwqS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="6282274"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="6282274"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 15:07:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="7439371"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Oct 2023 15:06:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 26 Oct 2023 15:06:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 26 Oct 2023 15:06:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 26 Oct 2023 15:06:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 26 Oct 2023 15:06:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2CNjokHJWgrLxVXgSEnEA5dTaNxqpSfZ4Afy34JHscaFYFY2GrdZD4U4oIBuf9ejyjVQSk0Z+FVT6mKDKT5XwhWrHk/TqPSNaP5xABQaoFYoab2ogzv0Sz8wXLAIK5dTUAf4yW4olaXghza3YrJZe7onSlSePHvF2h4ouRnf9qygUqSK50NeU0OlJuGAz1YMyKy1WRdW68APFiz5ySibmGzhmfwibctwe6OG5qJJQ1pjNylpFHNHwK1FP9fNgWs4pW6fcqg+WFXfpVH3EwJJHn7N9T1/oBrJqbDe721om+GqQ5bbCVj3wb7E/wdnAJEMKdyrCejKfQzYNjSqgG15Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aynL1iuw/2e9IEyDgaZ14nU9B7a3i39aIFX0qCEaBeA=;
 b=MXW0gHv61FKWXR4Fg36UQjYFGYuew2NV0dfgor4AJouCD0ucrAwPoOtBke9iX0JDw7n2r6moS//5jw0p/rbMHfrV1G2YQk+/r+TPPFjW3upYaORuIAhrTjtZRyMUgJOfxtSKgQR6gHAZyTKw6E8wlrquIk1lzMepzrQiFmwHXOFH9zDUTqTOXm4/gpjqXR6Pku9moa3VhSgWDcycQHGlCzyDXpv5laCbgbZMebaDjoDGGBXH22Zt7zUwnZ6VLw0XpTQlp7ZaGhmlxJ4gw+RXnHGsROM+OVwmRWlrvwRi2nF0eujZZygrHVStTPszowVt8QKiDBMsvVLGVBTqMvjJsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7457.namprd11.prod.outlook.com (2603:10b6:8:140::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Thu, 26 Oct
 2023 22:06:56 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::4d44:dbfa:a7b4:b7c1]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::4d44:dbfa:a7b4:b7c1%4]) with mapi id 15.20.6907.028; Thu, 26 Oct 2023
 22:06:56 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when
 calculate guest xstate size
Thread-Topic: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when
 calculate guest xstate size
Thread-Index: AQHZ5u85uV/FvZJ6oEmFfx1Me9nXObAal1uAgACRyQCAPkIMAIABa8iAgAG9toCAAE7pgA==
Date:   Thu, 26 Oct 2023 22:06:56 +0000
Message-ID: <96d1bdd71386b91ff80b5458666bf81f544539d0.camel@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
         <20230914063325.85503-7-weijiang.yang@intel.com>
         <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
         <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com>
         <ZTf5wPKXuHBQk0AN@google.com>
         <de1b148c-45c6-6517-0926-53d1aad8978e@intel.com>
         <ZTqgzZl-reO1m01I@google.com>
In-Reply-To: <ZTqgzZl-reO1m01I@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7457:EE_
x-ms-office365-filtering-correlation-id: 62420635-d963-45e4-bd54-08dbd66fde3b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eviyJlaTl4AWNp/TyA0/zoCPhLVUER4Tya6eoUOKw62Y74F3pzUGzSK2qBAPB923hgFWrqc659WwdopfwIm2/SHvumyMPd76/WhvQly2U5xYe16OXhJqZ/TMahcHphKWvn3/3zcGLi3w5IAnI9BwyAurdOutltMJOiSK770YdqMho115ODoAZezv2iegRnkZLrc3qqIF/HaldfiIhpeMRdyDE79nsMz3l6o5GdF0wUeiVoS6eU8P5iG6Ev6pQA6A2WFeauBov0uqK7AE+YUPKoXB3B+9KDwvY5LoO1D0ZH3KVuEsg6RsUOjtPqzxt60lCjDDPfbxQDg5k2bAhSm++AyWGIrMcz5SZNK1jjAhz9y+1voPZDY45whysIXDpUmpeW5Q2DNW5DMcyNJp0mMVndz4EriJII1bke/OPwIMo09FxbIJIGlOTldPm/HMW7PFUit5Dx9EcSX2sslYAUaqcz4n4tATz8heq6+XP8lghQmQD8/N90kDrCm30KsYB7tb1pMIECaA7JkZJ06jk5V2E+AwnpswB0lVyHktmJccjNB1jhq/n/48ebll2hSEOzPCpeXzu6PsoXBgikoLLgggEit4taM9sztHIchdjwt0Gvrc+4mnCV4f180L5X3QH+xj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(376002)(39860400002)(136003)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(316002)(2906002)(4744005)(4001150100001)(5660300002)(26005)(82960400001)(38100700002)(66556008)(4326008)(41300700001)(38070700009)(8676002)(8936002)(76116006)(91956017)(54906003)(66946007)(2616005)(64756008)(66476007)(122000001)(6512007)(36756003)(110136005)(6506007)(71200400001)(478600001)(66446008)(86362001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akNlREhaNnRWK0w4KythdENGbXh5TkVoUFZxSWZBOE5hL0FSOHlPWWZEcS9O?=
 =?utf-8?B?Q3k4bHZNVFd6Y1NMT2c5TGFZVm5qTUp3VHBzbk5zS05rWk13OGREUVBqR0tH?=
 =?utf-8?B?bzlHVVBiaWllQTBsM3M3aS9SUE9GTmJSalQzdityVjVVZGJLYUN2QlQyUTNk?=
 =?utf-8?B?a1NvbTE0amhrOCt6TEVkMUpvMjloRmxYcDI5cFh6UHNIS2FlRU45eVBzUkMx?=
 =?utf-8?B?ei9PZUZoREJrTTUraXJBYXNBbk5WekZOVnM0S1RvSTN0eWdqenZLUHpteUhm?=
 =?utf-8?B?MWgxU1FOc1lOdzMwVVdCOEtiVlU0OTVKZlFBbzRhQ2dqTkEwRU1YL1kwaGVZ?=
 =?utf-8?B?bGNTTGlwaEFEOU9UUzNiZmpSbElmTTJ3Zjk1RkpWMXRDck9ERTNKQ3psbHlo?=
 =?utf-8?B?RDlmdmxidU5CMzgrZUZ3eXhJRnJvZXJ3WE5TNHB0c2pHbmY5M0dLeHV4a203?=
 =?utf-8?B?MkM5NU9xSGFrN3dnVVdtell1MUp3bDZKSEwyNCt4ZWx2d3lQTWl3MVhyZStP?=
 =?utf-8?B?Nkp4YVRxRzVqWmxTWW5wUXdRT3NHNjBzZ2d6dmlvT09GTTlTUnhXeTJDYVRx?=
 =?utf-8?B?dEl4S1FiQlFpak1oczduSDFEaEd1K3M2QzljRmhXUVB3aXpaTU9QamJ6Mllr?=
 =?utf-8?B?c2l4VWxGVXpQL3VySW5TK3VxMXFvNEFNbE91SFFIdWFHZmF1aXJNRVN2emNR?=
 =?utf-8?B?Y2d4VDU2YXhuTDlrVlhQNlk1YUlpRVROL0VVNFRwT0MwN3BQTWUxTEI1eFpy?=
 =?utf-8?B?QTJxaThreVA3S0thRDc0dmRtSWNJZnlFZnJmK25PNzBxcWU0S040UTczUzFa?=
 =?utf-8?B?aG9DaHdmZTk4TFVTSnZDTjZHakMzai85RFQrSVBDYXM2MkhVeW1HUDZFZVVz?=
 =?utf-8?B?UkR4ak1UTVRMNklZazl6RTZ2SCsxU2xML1FUSE5ST1A1R29uN0V5aGozZll5?=
 =?utf-8?B?dHFrNG9XYTVrWWx4bE5aRjhYazV1cmpZTjlyVnRINHBXYVpWSzZWdE1WT1B6?=
 =?utf-8?B?NloyOG1jVDF2R3dIT1pKaTVpb1F3MTdSVFhoMEFBa0FnYVNOSVBnZkhwbnNj?=
 =?utf-8?B?aXVwS25ySWVEUzYyaXY3anhyRlBtLzIxT3ZLdXo5TWdlNENSc1V2NEtGOUNw?=
 =?utf-8?B?RGRaeVVUSVBvVmN4cm9ZY2hnMXhOWGRVREJ1TDU3cHhEV0twNUgySm8wQXVu?=
 =?utf-8?B?akx1eGdwZ1Q5a2J2M0orMVFTc3hlZHRnclNjczllZ1MwNTFFaVZBUzh5ODNk?=
 =?utf-8?B?MHZwQUp3U3JhRVkyN3FDNFZYYnlpVDJEU3luMFFpL1lGelZ0S3prQnQyR09l?=
 =?utf-8?B?dVJRczRXY3Q3K0VFakx5K2w4OWxFamV3ZVVNSDY3YVdaV2R2c3VyYUo2WGZ2?=
 =?utf-8?B?Y0dieXhJUHhFbG1BSGR4YkVIT3RuVDZ0VlBLVStQMFFXUTY0Sy9malJ3RmZP?=
 =?utf-8?B?Uy9tak5VK09qaU83QVdsVGxOWk44VmJRWjY5dHB6amJHTHcwL3dlMnJ6NVpl?=
 =?utf-8?B?TDJKcUtsZ0dWcUdMQXYzeFA2RXJ2UDBBRTBxbkhUNktJZWNrL1lXZ0ZaYm1o?=
 =?utf-8?B?WFQ1cHFScFlHNFcxcDI4YXd2OEthVjhsK055dTlVNk82SlduejM0MERxQUdM?=
 =?utf-8?B?SGhsRnVYLzAyUzN6akxHR0RqZjBGYmNEdzlaNTl0RmRPR0Y4eVBYWXhLamFZ?=
 =?utf-8?B?QU5FNEdHVDJSaE5xNVhXbjJCOEZRTllQSjdIWUltamJQRHRzeFNmRjJkaVgz?=
 =?utf-8?B?Q1NvdWZFaGh3ZFJxUVZBOXo1SnhwYWJtcm1RM1hiZkMwMldDOEhzc0pxYTMw?=
 =?utf-8?B?YWVYa3hPNFJJVlVyQVp0UVo1bXM1Rkc1dDUwdnVEblZBR080OGQvTnBjUExX?=
 =?utf-8?B?dWQ5RDgzLzNNOEdyUWFZZXErT2xoOUQvT3VMazErdk9TL1dxMVUwYU13SmdE?=
 =?utf-8?B?TDVRaTB0NC9NWjNhVFZmOHl6MlJrTGVmOU9TOFRZajRSNTdlaDdpaklKTS9k?=
 =?utf-8?B?M2RFQ3BqclhVaTdOK2tDSWdiR0ZmckNzQmNGam5GeUpjdFZMeEJRUTZHbEZl?=
 =?utf-8?B?dTRZT1I0Tmp3NGNacnpIbDV5VXQyVVA5T212bjd6OVpIc1R4MitRSGtuWHAy?=
 =?utf-8?B?Z2NISXhNY3dHNGtISlFteGVmZm9sQVY5TGhKSytQUU9WQzZlUEp5ZkVvRjYw?=
 =?utf-8?B?N0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6284558EEB34394DA18BBB3899205143@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62420635-d963-45e4-bd54-08dbd66fde3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2023 22:06:56.0989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skfXMk2mTP8prOf5qVUXlJ3M97LPDCKEO9o5aN8n86xUEAmZ5TBMALMe+oaQ7SeQx7MVVfzqFoGeG/q+lAd3hYTRDLilz4wz34bBXVdGTX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7457
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTEwLTI2IGF0IDEwOjI0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiArwqDCoMKgwqDCoMKgwqAvKg0KPiArwqDCoMKgwqDCoMKgwqAgKiBDYWxjdWxhdGUg
dGhlIHJlc3VsdGluZyBrZXJuZWwgc3RhdGUgc2l6ZS7CoCBOb3RlLA0KPiBAcGVybWl0dGVkIGFs
c28NCj4gK8KgwqDCoMKgwqDCoMKgICogY29udGFpbnMgc3VwZXJ2aXNvciB4ZmVhdHVyZXMgZXZl
biB0aG91Z2ggc3VwZXJ2aXNvciBhcmUNCj4gYWx3YXlzDQo+ICvCoMKgwqDCoMKgwqDCoCAqIHBl
cm1pdHRlZCBmb3Iga2VybmVsIGFuZCBndWVzdCBGUFVzLCBhbmQgbmV2ZXIgcGVybWl0dGVkDQo+
IGZvciB1c2VyDQo+ICvCoMKgwqDCoMKgwqDCoCAqIEZQVXMuDQoNCldoYXQgaXMgYSB1c2VyIEZQ
VSB2cyBrZXJuZWwgRlBVIGluIHRoaXMgY29udGV4dD8gQnkgdXNlciBGUFUgZG8geW91DQptZWFu
LCBsaWtlIHVzZXIgRlBVIHN0YXRlIGluIGEgc2lnZnJhbWUgb3Igc29tZXRoaW5nPyBPciBhIGtl
cm5lbA0KdGFzaydzIEZQVT8gSWYgdGhlIGZvcm1lciBJIHRoaW5rIHRoaXMgY29tbWVudCBjb3Vs
ZCBiZSBtYWRlIG1vcmUNCmNsZWFyLiBNYXliZSBqdXN0IGRyb3AgdGhlIGJpdCBhYm91dCB1c2Vy
IEZQVXMuIEF0IGxlYXN0IHRoZSBjb21tZW50DQptYWtlcyBtb3JlIHNlbnNlIHRvIG1lIHdpdGhv
dXQgaXQuDQoNCg==
