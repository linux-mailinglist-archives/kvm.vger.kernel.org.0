Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BEE6479EB
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiLHX35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLHX3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:29:55 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE05F1C127;
        Thu,  8 Dec 2022 15:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542195; x=1702078195;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LCm+Srh/9s924PWn8cPwcmuLZDs+nt1TgjMxs15kI5w=;
  b=AjvBfI/uPmYTelueAngrIPtKZH/8Tw/27DoIoJ291PDBPSAvUNmwMTCm
   wrVAMAVLX11s90zqovlj+eeS/zv82FlwyNFXEipv8l5skRqq0gSm6ekMo
   DzIvzO6HnObPWtbuqQFzt1dVheycOR9RJkEbisxz9zV+J09XNq/KKhyTE
   Qhq715Nkwae9Y0BeE+K7q7B03UZgHie/2N7x570CGJMnYEbk5UrA1qgiE
   JJrXvPvr3uN7znSApMraRVvff41fsJsxdY7K6FGTn7TzUYAoIPOG9xYZu
   mehzZ+SWodz1YsdX+ZzwEIKV51blxhJX3WFur2jh+PFI/vQNuqLq7WjA8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="319194231"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="319194231"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:29:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="753796804"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="753796804"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2022 15:29:47 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 15:29:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 15:29:46 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 15:29:46 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 15:29:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvCj7uqMsml7LqPQ+ps5jpR7SG6ZPN1p24qv7H0FNQOoUOEVX4uhtbvzbVOWVQuwg5IVrWXjEo2+QUa2bfUJoCjHpw7aqu4Xtzn6f3hy0smMVtxKnHYjUNhRirIOWinjdDMwFJvVew+pmWMalPw8AQQDoj2p2wW/k9yTmETErYFGb0sfiChFlRPIPrPhNWj0J4m/3ygTBzqcea2/SdMOPVoFbv8El6QYxAeT3qtexrF4NXil0UbZST1+brVBNFX087Qx+KWZsmC/VgHta5N2bO7kGqJjL426U1k7yB6FQHonPthU0Tn16ybCWfLFQaHWkdhcqzkKMOwg1jkQnXYeVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCm+Srh/9s924PWn8cPwcmuLZDs+nt1TgjMxs15kI5w=;
 b=OHHivDMuqa0kvAFCjAYB0S5ASqWOSbnJ9GDc4vJnp4b9VPdngKq39Tg9ntihuC8nRJjykzSI1pWT7PTfpWbTcdVHnNMCAqsLeSCAAJj6LkpJ3v0q6enFnNrVc3HT5VB3qJN7aznN+1BPI8bBZeoqXuoudRQMQYRSBfhj2RW7hRlhKQ2xvF0BA89BrvSAuXQyjUNxT6LCGcub3nd5F/CeddMvAXlpjMjwKRJWo89TWBsIsOEcH2/YD5qQDtHq5ipxbVusZh39Wr3zlEttfOt3/v5auSXUcjGKFUysP01mD+mwkfbs7KigLlJNDqZZFDdHVMm7o3AJW3M9Zopq6CpVJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4912.namprd11.prod.outlook.com (2603:10b6:a03:2ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 23:29:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 23:29:37 +0000
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
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHY/T3ORWilVlKW4kyc0A5kdGk0eq5NGDiAgADmkYCABotngIAAaI+AgAAB1QCAAAiegIANa7YAgAGleYCAACIbgIAAjuYA
Date:   Thu, 8 Dec 2022 23:29:37 +0000
Message-ID: <cc195eb6499cf021b4ce2e937200571915bfe66f.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
         <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
         <35aee96c1bb56322191ae442f3928d7dff064a92.camel@intel.com>
         <9a653cd2-70df-8c55-ac7d-5ddcb3b18b0c@intel.com>
         <60deb2ffe15e71bc91727aa04298c79f21a58c83.camel@intel.com>
         <e49829fc-e488-3a65-b6fd-f02e964bdb4a@intel.com>
         <02d2a49cbd319814a7afdf57ca3cc9809123952a.camel@intel.com>
         <98935273b05feb55fc52c69a48d31018e0124e58.camel@intel.com>
         <702c11db9820a074aee31c2958a565b21299607f.camel@intel.com>
         <d04b3a83-5797-b061-f315-07f84278d961@intel.com>
In-Reply-To: <d04b3a83-5797-b061-f315-07f84278d961@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4912:EE_
x-ms-office365-filtering-correlation-id: 197edd0b-b4b8-40c5-7a87-08dad9741256
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SOY9Kr7hmcEluOU4PvrcPBHOasvKvvIfcVayWKq7f5SBm03TQE4r0CKMUIjw2Yrlk6TFTetuVuonvi6okeL+Buvmx01ufCyHUQeTFwcShPQLGBFoupHQwkmn6p0NiDlViUB7TdeMQan1kU3SpEoelc3GRA7pYmqYKwxjzDjOWrqCrLDEH212Ri/LHrxOfKyqZYvRxEm1hhFEoTT14GOd37MyxCy+zfQNtoIma6H/QMybFuk8RqJJFoX4zUr3+b05E3np4hjGw5zsAdelsUaJaZ1EEPVMoWr5/fCbuu4gEwY+dOt+iqLR+ERvCOcRXNUIn1e8ACaFbxqockY2W27UgUAy+RARHIcuy8CXR72UPDf2R7nVNjH8grOSxIR+EUob7RNAT/6XhpNEsKmVt+A+rePiBrbM1IQSZeMYs1ivSJdBMio24ieWES8nXBQkhCTlZRLRHnPryhmRUwyvhfnTuHI+RrbsnCHaFzbTa0L7xrl6IAqNPsbqxkZusoXP/fAnFiESz0JYaENV/uWJLR73aotkFBe0EldjoQRbICcsWS5WT+3/gDax6YCtxtAtOORDtf3UnLfK8WatUC0WHcFo7msnqyZGVrW+4hISu3XumSWUJiTvGsEfEXTuU2FWQjMDpwjCBWWaBfi7Ftuem1Hs/zJK7LtqICX4F2zB+LtvJUKyuSAfNftLk6LEgZO9ZrhyTpdDRQzvS1Xi3ZXMzFlt5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199015)(71200400001)(122000001)(478600001)(83380400001)(7416002)(8936002)(86362001)(2906002)(38100700002)(38070700005)(5660300002)(4326008)(41300700001)(64756008)(8676002)(53546011)(66476007)(26005)(6512007)(186003)(91956017)(6506007)(66556008)(82960400001)(110136005)(2616005)(66946007)(66446008)(316002)(76116006)(6486002)(54906003)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0UwQmYvbSs5aVp5V3VTUmNzRGlyRk5EQjBlVWxxakQzdGZKSnBqRytXN2RK?=
 =?utf-8?B?SGFjWGZoZzdQV3Bxb2NJVUxMcXlnb2R1WXA2K21YR0l4UEJNTWVOSzAzRFN6?=
 =?utf-8?B?VjVpaTdweFM5M0RaZzRmYlNCV0o2RjY4RlBrL0s1UU1SdmZmbll4dzFURFJ5?=
 =?utf-8?B?cDNhNnJ4SU1PNTlON1RhMk9KdjZFQzc2UWtvTDFBc2VneGM3K2FQN0wzZUZr?=
 =?utf-8?B?dUNCc2ZEblg4UlgvSDR2NUsrL3p2dXZoQVJsQ0lwRUYvazZTZEtBQk0vMTF6?=
 =?utf-8?B?M0JTcDU1N1ZJS2J2RTR6MS9zelFkY1IxTXhLSkhQTlRXTHMrSlR2a1gzNmFI?=
 =?utf-8?B?OVRPaHNwZlpFMXBnS3RzMHR3MnhNcHFaWWErM1NCNlZZdFdFa2M5eVBqSUdh?=
 =?utf-8?B?MVlrYnI1VnhXR0M5QlJ2RzFLdVdkejdYeW42T3h5NktFR3hRQklNRE96MWdI?=
 =?utf-8?B?UHhLRklhRmRPeld5cUJUdXE1dTFnMldFOHZVb3NTbTVsNnA1eVZMOVh1U0hN?=
 =?utf-8?B?SnlZVEpSb0lpTVAwNHN1R2VQNGlCOUk1czZoWWJKV2VMOGJtd3BkRTN1NXpI?=
 =?utf-8?B?L0lkZnhLeVI2SG52R2U3Rm94c2tvYXJSUE5tU1NjbEhCbDJiVjVicllZY3du?=
 =?utf-8?B?dmdicHk3cTlXMFJEYmxzUTFxRWFVSkZVd0JJWVF1RGRjcHhVek9HZ1ZMZWQ4?=
 =?utf-8?B?cHhxM2ZNbjJWN2d5cnkwc1JZZzRBQ3V3OEhUSDg1ZUVrTVZtNndkbTJ0ekNw?=
 =?utf-8?B?UXhURnpmY292MlF0VmpTbi9hNEJSbXVQbmg2alVnRGJzZlFkUVBnNmFzTGZo?=
 =?utf-8?B?bkNZb1p2NVcwRk5hOWx6Zk1XaDBZNG9BdlVvSzBpTmRmS3Z6a00yaGQ4c2pL?=
 =?utf-8?B?Qmw2OUVvRmV0MlJiWGtUNE9nb2RzZ3YyS01ieUN2ajZTMjNHWDNpcDgxZVdP?=
 =?utf-8?B?cCszR2gzZW1EMXJ4clNLd01ONTl4NTM4Y2dNRW9Gc3lPRjVYS3NWT0hhejh3?=
 =?utf-8?B?UFkzYzRqVkpVeS9SblM2K1F3L3BIYzRvY1cxWXN5dlplZWphVXNOOUFwYy8x?=
 =?utf-8?B?Rm8rclRvYzJwV1RNZHhJYVV1ZExjKzNuSm5ZL2svMkpINUtGUExpUFBDOFdV?=
 =?utf-8?B?b1VHMExHT05WYkt5VitEbmZNaU9jTm5SckJmWTBBb2VHaVZoTFB2NDRwYkww?=
 =?utf-8?B?bXBwRDFKaHlpbmdjelRmalBTRTZGanhxOVNDTzlEQWhJTncranA1Ry9URUE0?=
 =?utf-8?B?T1pkR0dwelZqY2tYVVlPTytPNWJXejZIanhBS2dyTDg1czZZNkZ3MDBEOHlL?=
 =?utf-8?B?Mmp3Q1lEQ3hFMlZiTVlneTRRdkcrVjQ0dGg5YkFZbDF6L1R2WUZuRWMzemtJ?=
 =?utf-8?B?VExOYUNEejlyYVliK2xneXRaUVBTQjh3YURsWWZJSkFsRGJSWVV1KzVjQ3Qz?=
 =?utf-8?B?NGh0NWppeU1KckptNDRQSkFYbVZrMkRYTUdVZStoRzRNME5IbUNlanJSSExn?=
 =?utf-8?B?MTJDMktRSWJhS0pXVlF3dXRaMm1IVUVKUzRlTjhYWjV1dE54dks5d0NIYVFV?=
 =?utf-8?B?YWswN3BLeEJ5aTRZcTd5T253QjFjaHZUZWdCWVF1UG5HOTNRZUV5UklqYmlt?=
 =?utf-8?B?d3JZSFIyZDJUK01aK2JJTWZ3TE9PQUEwTm13dUdjcVZpMC85d0dvcUYraTNp?=
 =?utf-8?B?T0Z2S0o5OTI4TGs4cVlKSXZmK1Y3d1FCNWJEMGM5Vy9hdHI5MmlSVXJ2VFVC?=
 =?utf-8?B?dnRjamZWVlUxWXlENklIOHkzUUtzSlFOWkRlVGVlOUZhdThrVnFZR3VnaDh4?=
 =?utf-8?B?aXNCcmRXUzNKdlhuZHc3cVhIQ3gvT1BXVXNERGpIcHhXQ0R1TlArRzhDWmVq?=
 =?utf-8?B?V3RISE9ORXM4SGlXS1hwODk2dE5DN2lkRXZnYWVuc21sM0NBZ0p0a2tyeDQ3?=
 =?utf-8?B?Z3E3WDZmNFFxUkR3RG9tS2NHQlcwaDM3WG94dVNaQlNpQWFOUWRVOWtLNlhp?=
 =?utf-8?B?ZTlFdmJQRmM5QnUvWFJSb0V1dXhaZWMyOWF6OEdKUWtQUVpNNWc1VlRpOTFF?=
 =?utf-8?B?MlpKZjFUUUg0V0t1ZVArdW9ZdFp6WXo0eTZLcUZSYnJFY0MzaGc2Y0ZNalNX?=
 =?utf-8?B?WVhoSEIyZHYvcXdFclBjVzVDMG5VK3ZTRmVZQ0tNN21JdTE1L2xwVjFoQk5l?=
 =?utf-8?B?K3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <525AEB815DADD34799DC9EA6FA8EEB33@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 197edd0b-b4b8-40c5-7a87-08dad9741256
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 23:29:37.2812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +kQTVzMsDPsl0by4ZL8NIBU+8gIYTjB7PHVV8LthNuSCJ/ScLszmZeIwRrKcr7xuwwN8AKa2n9yf5lTik6RV2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4912
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEyLTA4IGF0IDA2OjU4IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvOC8yMiAwNDo1NiwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBJIGhhdmVuJ3QgbG9va2Vk
IGludG8gdGhlIHJlYXNvbiB5ZXQgYnV0IEkgc3VzcGVjdCB0aGUgYWRkcmVzcyBpc24ndCBhbGln
bmVkIChJDQo+ID4gdXNlZCBfX3BhKCkgdG8gZ2V0IHRoZSBwaHlzaWNhbCBhZGRyZXNzKS4gIEkn
bGwgdGFrZSBhIGxvb2sgYW5kIHJlcG9ydCBiYWNrLg0KPiA+IA0KPiA+IEluIHRoZSBtZWFudGlt
ZSwgZG8geW91IGhhdmUgYW55IGNvbW1lbnRzPyAgU2hvdWxkIEkgc3RpbGwgcHVyc3VlIHRvIGtl
ZXAgdGhlbQ0KPiA+IGFzIGxvY2FsIHZhcmlhYmxlIG9uIHRoZSBzdGFjaz8NCj4gDQo+IFllcywg
eW91IHNob3VsZCBpbnZlc3RpZ2F0ZSB0aGUgcmVhc29uIGZvciB0aGUgZmFpbHVyZSBhbmQgdHJ5
IHRvDQo+IHVuZGVyc3RhbmQgYm90aCB0aGUgc3VjY2VzcyBhbmQgdGhlIGZhaWx1cmUgY2FzZXMu
DQoNCkhpIERhdmUsDQoNCkxlYXJuZWQgc29tZXRoaW5nIG5ldyBmcm9tIEtpcmlsbCB0b2RheS4N
Cg0KVGhlIHJlYXNvbiBpcyBub3QgdGhlIGFsaWdubWVudCwgYnV0IGl0J3Mgd3JvbmcgdG8gdXNl
IF9fcGEoKSB0byBnZXQgdGhlDQpwaHlzaWNhbCBhZGRyZXNzIG9mIGZ1bmN0aW9uIGxvY2FsIHZh
cmlhYmxlIG9uIHRoZSBzdGFjay4gIEl0IGlzIGJlY2F1c2UgS2lyaWxsDQp0b2xkIG1lIGtlcm5l
bCBzdGFjayBjYW4gbm93IGJlIGFsbG9jYXRlZCB2aWEgdm1hbGxvYygpLCBzbyB1c2UgX19wYSgp
IHdvbid0DQp3b3JrLg0KDQpJIGNoYW5nZWQgdG8gdXNlIHNsb3dfdmlydF90b19waHlzKCkgYW5k
IHRyaWVkIGluIG15IHRlc3RpbmcgYW5kIGl0IG5vdyB3b3Jrcy4NCg0KU28gSSdsbCBjaGFuZ2Ug
dG8gdXNlIHNsb3dfdmlydF90b19waHlzKCkgZm9yIHRoZSBuZXh0IHZlcnNpb24uICBXZSBjYW4g
dGFrZSBhDQpsb29rIGF0IHRoZSBuZXcgdmVyc2lvbiB0byBzZWUgaWYgdGhhdCBpcyB3aGF0IHlv
dSB3YW50ZWQuDQoNClRoYW5rcyBmb3IgeW91ciB0aW1lLg0KDQo=
