Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C0E745BFC
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 14:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjGCMQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 08:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjGCMQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 08:16:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2B310EB;
        Mon,  3 Jul 2023 05:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688386533; x=1719922533;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=h2QLb2gUmGy2PXWbDVuTDqeZctoboy5zMGhSD1MW5Aw=;
  b=NCrmS8kbDSE6nwajlGnDRj5YZgc+ZRLgz++RtlVQIMu3HfQpwb6QCcf6
   HlDbPBCxidTGhuEDc1G4zgTcqeySj9Vj04/Z2lVQ0haTsFFZQjAU1BYUO
   Q1pJCAhzAIjsqkGj9wwY782DXbifZrXmbe7Phmw4qXsH1Dr9sIa7JJtoz
   VkjtL+9Um5rLoIzF21OPrRvMH+I0J+PsjapVfOZR1zkXEItJ4LDr/gtsk
   hC6omgCu9g1qZLTN8xF7PwpYQNR3Pyn9l4GBhJCuz14KzY3IjTyVOQeCf
   NZK3bTNcTph0/8DFDRWqm9BdliS32GKlRyEIMAsdigawvFhOh4fXBXDvg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="449241373"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="449241373"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 05:15:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="718575093"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="718575093"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 03 Jul 2023 05:15:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 3 Jul 2023 05:15:23 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 3 Jul 2023 05:15:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 3 Jul 2023 05:15:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 3 Jul 2023 05:15:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gmc8l514q42YuONAKy+cOFLbdEJMOdcJb1tSPMaD4Lu93btGGhQLf8CHfAdIgBX7YdH5pTkvfT9ieF87udOrLXgftljF0BlDC07JwhF/DiXNzDUaeCL/89eghrp3mFuoaMyBlyF8jSnmuEo0BSuIaua1DzJpQ7ODdfThV124tjtf6mN+PiMza5LrdSTIu3nWwLbB53lumzpNNwdN/E6Zo0XwuaDLiXW+woK26XFRb1hNUkdJft+gU9EYbuitZFVlQXtayWqsCyFWHa3hfGCeHI8BXomZHSFdyKCRWIMCR7SBFWkLXuean7mzjMK4f88rfv5EkSgxWbvVPsoZip34fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2QLb2gUmGy2PXWbDVuTDqeZctoboy5zMGhSD1MW5Aw=;
 b=d+XKHr1QgMHdhlwSW6EFp4UfLjGAXyd05ipGooz3efY/vGUJoDIh3Z+8XOlTBmWDWuX6uDbpdbzueHz9noOEmiXFpKmlho4gJ1OHybrs9uxGkWLllx5EY2pACbL1/Kzp4aZcGy/2Waq/NbLMtncj+4g1CMA6ug1DUVRTRRwMxf9RzOWgOC2Faomp4uW/oOeQPyjiTKgqvzfWoEXeI9kultacQ8lk3fr34mx5qJmsiMynD76IXjUz22GnBWn/XmmiXtuNc+kYqnB+OsspoS5gi7Fd9fjqzNKPDU7UZb3mn9NPWhVlGxK/lfkcF3Ol6dGXohZeuDFMuSu92IYei7ggXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6755.namprd11.prod.outlook.com (2603:10b6:510:1ca::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Mon, 3 Jul
 2023 12:15:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6544.024; Mon, 3 Jul 2023
 12:15:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Topic: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Index: AQHZqDW2iSvVOZI03kGK/IB0Vnjb6a+gWhoAgABWcYCAAOlagIABiuaAgAAEHICAAB1gAIAEuVMA
Date:   Mon, 3 Jul 2023 12:15:13 +0000
Message-ID: <fdd81fbd2424d8da04f98d156668cad5e73c740b.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
         <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
         <20230628203823.GR38236@hirez.programming.kicks-ass.net>
         <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
         <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
         <20230630102141.GA2534364@hirez.programming.kicks-ass.net>
         <20230630120650.GB2534364@hirez.programming.kicks-ass.net>
In-Reply-To: <20230630120650.GB2534364@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6755:EE_
x-ms-office365-filtering-correlation-id: 0b448bd1-8e85-4d6e-d47c-08db7bbf2792
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yW9sBt7UNhbPVb1hIFNy95NSKd99hq1YLqJeTq8CHDmfepw5eixz6Vl+kc3UK2yr3Y756tY57e9jQGWhNGFgl0khZK2/HrDkA6heC7eDL+KMBlvimNuljyzwttnXWsmzYGwvZptxQVdsC9PkoNTC37x/dGAzS12vMXpEeMzq8DThp1E8i9AdxkDVvVlynudvfEV2fy3d2o3e9+vYES0Gltc5nK7A1fKPMv13NIjKsBKJ1hYxV8fKAf1a4MPCUaeGaXoq0uOfDCO4bUkYfriYIyJ0cI+AbZbzm2G1gFfo+JtIOmXO0Pa4FgbJdSMs+Gw7euLA9uyDPEdikYsPQIUBnHkbOoev/zvkh71d6fyjp1quPFshWA+6WMTfYIWgvAdKad7x216d6+oQGly3rRZHfr2GGLjAWqeO87MSzFIAZOwv+CUDO5WUf0q+pDJC17N4rq+sHE8/hyby9+23pzfFc/BvV1Jg0HkT+rG8NYPsi/bLYPyfdX97APHSTtdr0mPBUv/Jiv1EsWBvMKGoTts+u1OEu6WEurAeYz9MiFYCFvZsXaiUW7W/jpXTYRUJC7hLz7MXzc02L8r5p1fiisO7g95U/39rwm2qZF0fPjrxzTyQFIfbk3o44uMcaB0dHWnj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199021)(6506007)(66556008)(64756008)(6916009)(66446008)(91956017)(66946007)(76116006)(82960400001)(4326008)(66476007)(478600001)(41300700001)(38070700005)(122000001)(38100700002)(316002)(66899021)(2616005)(83380400001)(186003)(6512007)(26005)(54906003)(8936002)(2906002)(7416002)(5660300002)(6486002)(36756003)(86362001)(71200400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGg2d2RPdkx6dGFFNksxWDBwSWVmVWFRcnArUWFFd0RadmhtMXUzMDVBQTlN?=
 =?utf-8?B?dXVZTHYwWmNneXpMNE0xVDIxOS9BRVF1Uit5cVdHUFhxd0dLK2ltSnQyMDdV?=
 =?utf-8?B?Z01nMHdJWW5KaGc3TUR2c3k3dXNuZGxSNUFodzBtRmZLZTlLZDNuanJ3WTcy?=
 =?utf-8?B?WEFNaExyRmx3czRZaXdnVkxXYjlGMHVac09yUStOaVBhWTI5MERlWjZCM0F1?=
 =?utf-8?B?WWFRZk15dEtsSTlkRDZtS0Qza1VYeXc4Zjg3SFNOcElYcGJ6YWZSM3FhdWto?=
 =?utf-8?B?d3BYOC9mb3laK2lUL1VzSm00MS83Z0tscmJzSTZuWmEzMU0vcUxaRWkwS282?=
 =?utf-8?B?VFozU3JXSHRTRnZxSXE4SS9mZjJFTEtOS0l1MkxCaU1yYXNielZYZmVpUCtr?=
 =?utf-8?B?YlgxZG9wRlJIaTJaUTcxT1RLMmw0Q2ZaZlQ0QjJVdWxTKzBsWUdqL1BhZHBN?=
 =?utf-8?B?bVVUVHV3Tyt1RE9TbnpSQnNxck9hNnNYOEVEOGFuNk9ubXlFaDFYeWc2VVdr?=
 =?utf-8?B?MUxUYTJPUm9oMlpSY1pNdTJiYzI3MnIwc2hKd0NUTmhXUDhOV3RuL1gvZm5v?=
 =?utf-8?B?K2sxTlpURXBQMklZblRUUlI4U3NBZlgrVHlxQU9yY2QvUXJNYlhLRkFmWWZs?=
 =?utf-8?B?anZmdlBwUmZXeXA3djl1ajhsNVQ1SXlBVTlnQnFhK2dOaHpiZHhSWElTWDhS?=
 =?utf-8?B?OUFZSnBvWEc4UEhITGpPcmloeXVzOFFmL2NvR3lCVVMvbG5Ca2FEVjBQWDZL?=
 =?utf-8?B?ZE91TUw0SWxhaWpiSHJvaHRwUUxGcmtrZjJXTmxKWXFjSlQyWUF4TU1IUDN1?=
 =?utf-8?B?TElZYlkyQkhXbXhOcmozNGZFZFNNYytOZUs3QUttaXRLNldVa1JkV252b3E1?=
 =?utf-8?B?TzMvVEtWYnljd0pDaUl1MXJ6Y2c5SFBPVkJ1UE9mZmZSTjFyaG5ZSW5xZmVk?=
 =?utf-8?B?Z29QMHhLd0NXTktWNXZJb1ZhZitvYlNZb1JmS3BoRjBFdWdtZjZONmNTenB5?=
 =?utf-8?B?cGt5MDBtTXFqY3Y3SG5OWGtFN3I0R0VXSk9QOVhlUGxFT0UrYzAyQWhGejlm?=
 =?utf-8?B?SkcxUEZkQ0JMU29TRTYxTHBUbklMalA0UTRpM2NLT0hkK1orYVFrajBBcUVY?=
 =?utf-8?B?bHlIQWc2VE85bFR0dHc1VmZESEdhRmxJZkdNZEtVeWZLTGNHTEdIYnNXQWNG?=
 =?utf-8?B?dmVoUUhwNjY2WFFGb1ZOMFJnZnIxQ0JNa0g4K3hyYjY0SXo4YnNuVHV3QjVm?=
 =?utf-8?B?TFA0ZFNqdi9lUFArb085WVNDb0dZNWVwNmRxeWZmOExabzBHdXZJcGFQZEJI?=
 =?utf-8?B?SzVPaEpGY0tsV3Nrd3JmbEQzb3pqMm5iUGxuZS8rN2pYWENaSVhvbFhpWit4?=
 =?utf-8?B?UDRYSEJRU2VRRzR1aFZKWlJMeU1mUVYzbU5DN25CVzBRa054Q2pFaUZzZ1ZR?=
 =?utf-8?B?bWJZMWdVbWRNclYvazhRdXRTMGNGd3BUMFhnSnNMRldkOW5tb0NLT2JPVll1?=
 =?utf-8?B?WTJGdStQaFlUaThOVVU1SGhZQmhZZjNiZm03NTJIaldXaVcxZWFxUXJDWlE1?=
 =?utf-8?B?N0VIeGIzUVZJc2Z2MG1nWnp1aWNtTTFmZlU2Q1ZzV2N0a0pFcjBSZXd6NWZG?=
 =?utf-8?B?RVNET0RWWWJkVHR1WlMrU2tQQndtelp6Z3grLzNLMk4rMm4zWTZvUndpVnV3?=
 =?utf-8?B?ZXNTNnU2QkFhbS9UUzBpNmRUNlVDRnZ2K3ZLMWZvQTVjOUVQN3dXQUNOcmFh?=
 =?utf-8?B?TU12R2lDRGEwazlGVHppVGhxRUEzbVBOV3Z4WDhXZldlVGFXeTkvOC95c2dU?=
 =?utf-8?B?SXVMZld6bnNCUHN6b0JrZUhsMUlWWi9IdTVFUVVzV0dxc3pxR0ZnWElSd05T?=
 =?utf-8?B?MitmekFSeXhRT3d5dk9aeGFjSHpPbDZ3bndBc1hscUFPR0pvcDk5S2JMS0pF?=
 =?utf-8?B?T1NYTEJORmFlamEvSXp4ZWFhTDJUMnhTVy9zV3g3K1ZhSEZPZkt1ZkVOM0FO?=
 =?utf-8?B?Qk01QmFPaGhPLzFpYkM1MW9JQXVmWXJiN2RvMnAyeG9Xem5LM09PR0plaDFP?=
 =?utf-8?B?eDFLSVMzVHZBa0l1K0txQW5zajF1RmdXMlZnSSs1WEpSTDFVOENqZ2s2ZTlW?=
 =?utf-8?Q?56UWrwsTMRvVzygj1iFBAtObB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3E93DC9FD1611438BD38929263E415B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b448bd1-8e85-4d6e-d47c-08db7bbf2792
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2023 12:15:13.5773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u19y7WXnD/5jzA+lk30fs6B5zWoOVIWu+mGUs1wyVt2P+B4dFm3hotOyfdbZcKwyG0ohGnV0ziBknvnMO2+djQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6755
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

DQo+IA0KPiBTbyBJIHRoaW5rIHRoZSBiZWxvdyBkZWFscyB3aXRoIGV2ZXJ5dGhpbmcgYW5kIHVu
aWZpZXMgX190ZHhfaHlwZXJjYWxsKCkNCj4gYW5kIF9fdGR4X21vZHVsZV9jYWxsKCksIHNpbmNl
IGJvdGggc2lkZXMgbmVlZHMgdG8gZGVhbCB3aXRoIGV4YWN0bHkgdGhlDQo+IHNhbWUgdHJhaW53
cmVjay4NCg0KSGkgUGV0ZXIsDQoNCkp1c3Qgd2FudCB0byBtYWtlIHN1cmUgSSB1bmRlcnN0YW5k
IHlvdSBjb3JyZWN0bHk6DQoNCllvdSB3YW50IHRvIG1ha2UgX190ZHhfbW9kdWxlX2NhbGwoKSBs
b29rIGxpa2UgX190ZHhfaHlwZXJjYWxsKCksIGJ1dCBub3QgdG8NCnVuaWZ5IHRoZW0gaW50byBv
bmUgYXNzZW1ibHkgKGF0IGxlYXN0IGZvciBub3cpLCByaWdodD8NCg0KSSBhbSBjb25mdXNlZCB5
b3UgbWVudGlvbmVkIFZQLlZNQ0FMTCBiZWxvdywgd2hpY2ggaXMgaGFuZGxlZCBieQ0KX190ZHhf
aHlwZXJjYWxsKCkuDQoNCj4gDQo+IA0KPiAvKg0KPiAgKiBVc2VkIGZvciBpbnB1dC9vdXRwdXQg
cmVnaXN0ZXJzIHZhbHVlcyBvZiB0aGUgVERDQUxMIGFuZCBTRUFNQ0FMTA0KPiAgKiBpbnN0cnVj
dGlvbnMgd2hlbiByZXF1ZXN0aW5nIHNlcnZpY2VzIGZyb20gdGhlIFREWCBtb2R1bGUuDQo+ICAq
DQo+ICAqIFRoaXMgaXMgYSBzb2Z0d2FyZSBvbmx5IHN0cnVjdHVyZSBhbmQgbm90IHBhcnQgb2Yg
dGhlIFREWCBtb2R1bGUvVk1NIEFCSS4NCj4gICovDQo+IHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3Mg
ew0KPiAJLyogY2FsbGVlLWNsb2JiZXJlZCAqLw0KPiAJdTY0IHJkeDsNCj4gCXU2NCByY3g7DQo+
IAl1NjQgcjg7DQo+IAl1NjQgcjk7DQo+IAkvKiBleHRyYSBjYWxsZWUtY2xvYmJlcmVkICovDQo+
IAl1NjQgcjEwOw0KPiAJdTY0IHIxMTsNCj4gCS8qIGNhbGxlZS1zYXZlZCArIHJkaS9yc2kgKi8N
Cj4gCXU2NCByZGk7DQo+IAl1NjQgcnNpOw0KPiAJdTY0IHJieDsNCj4gCXU2NCByMTI7DQo+IAl1
NjQgcjEzOw0KPiAJdTY0IHIxNDsNCj4gCXU2NCByMTU7DQo+IH07DQo+IA0KPiANCj4gDQo+IC8q
DQo+ICAqIFREWF9NT0RVTEVfQ0FMTCAtIGNvbW1vbiBoZWxwZXIgbWFjcm8gZm9yIGJvdGgNCj4g
ICogICAgICAgICAgICAgICAgICAgVERDQUxMIGFuZCBTRUFNQ0FMTCBpbnN0cnVjdGlvbnMuDQo+
ICAqDQo+ICAqIFREQ0FMTCAgIC0gdXNlZCBieSBURFggZ3Vlc3RzIHRvIG1ha2UgcmVxdWVzdHMg
dG8gdGhlDQo+ICAqICAgICAgICAgICAgVERYIG1vZHVsZSBhbmQgaHlwZXJjYWxscyB0byB0aGUg
Vk1NLg0KPiAgKg0KPiAgKiBTRUFNQ0FMTCAtIHVzZWQgYnkgVERYIGhvc3RzIHRvIG1ha2UgcmVx
dWVzdHMgdG8gdGhlDQo+ICAqICAgICAgICAgICAgVERYIG1vZHVsZS4NCj4gICoNCj4gICotLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tDQo+ICAqIFREQ0FMTC9TRUFNQ0FMTCBBQkk6DQo+ICAqLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPiAgKiBJbnB1dCBSZWdpc3RlcnM6DQo+ICAqDQo+ICAqIFJBWCAgICAgICAgICAgICAg
ICAgLSBMZWFmIG51bWJlci4NCj4gICogUkNYLFJEWCxSOC1SMTEgICAgICAtIExlYWYgc3BlY2lm
aWMgaW5wdXQgcmVnaXN0ZXJzLg0KPiAgKiBSREksUlNJLFJCWCxSMTEtUjE1IC0gVlAuVk1DQUxM
IFZQLkVOVEVSDQo+ICAqDQo+ICAqIE91dHB1dCBSZWdpc3RlcnM6DQo+ICAqDQo+ICAqIFJBWCAg
ICAgICAgICAgICAgICAgLSBpbnN0cnVjdGlvbiBlcnJvciBjb2RlLg0KPiAgKiBSQ1gsUkRYLFI4
LVIxMSAgICAgIC0gTGVhZiBzcGVjaWZpYyBvdXRwdXQgcmVnaXN0ZXJzLg0KPiAgKiBSREksUlNJ
LFJCWCxSMTItUjE1IC0gVlAuVk1DQUxMIFZQLkVOVEVSDQoNCkFzIG1lbnRpb25lZCBhYm92ZSwg
VlAuVk1DQUxMIGlzIGhhbmRsZWQgYnkgX190ZHhfaHlwZXJjYWxsKCkuICBBbHNvLCBWUC5FTlRF
Ug0Kd2lsbCBiZSBoYW5kbGVkIGJ5IEtWTSdzIG93biBhc3NlbWJseS4gIFRoZXkgYm90aCBhcmUg
bm90IGhhbmRsZWQgaW4gdGhpcw0KVERYX01PRFVMRV9DQUxMIGFzc2VtYmx5Lg0KDQo+ICAqDQo+
ICAqLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgKg0KPiAgKiBTbyB3aGlsZSB0aGUgY29tbW9uIGNvcmUg
KFJBWCxSQ1gsUkRYLFI4LVIxMSkgZml0cyBuaWNlbHkgaW4gdGhlDQo+ICAqIGNhbGxlZS1jbG9i
YmVyZWQgcmVnaXN0ZXJzIGFuZCBldmVuIGxlYXZlcyBSREksUlNJIGZyZWUgdG8gYWN0IGFzIGEg
YmFzZQ0KPiAgKiBwb2ludGVyIHNvbWUgcmFyZSBsZWFmcyAoVlAuVk1DQUxMLCBWUC5FTlRFUikg
bWFrZSBhIGdpYW50IG1lc3Mgb2YgdGhpbmdzLg0KPiAgKg0KPiAgKiBGb3Igc2ltcGxpY2l0eSwg
YXNzdW1lIHRoYXQgYW55dGhpbmcgdGhhdCBuZWVkcyB0aGUgY2FsbGVlLXNhdmVkIHJlZ3MgYWxz
bw0KPiAgKiB0cmFtcGxlcyBvbiBSREksUlNJLiBUaGlzIGlzbid0IHN0cmljdGx5IHRydWUsIHNl
ZSBmb3IgZXhhbXBsZSBFWFBPUlQuTUVNLg0KPiAgKi8NCj4gLm1hY3JvIFREWF9NT0RVTEVfQ0FM
TCBob3N0OnJlcSByZXQ6cmVxIHNhdmVkOjANCj4gCUZSQU1FX0JFR0lODQo+IA0KPiAJbW92cQkl
cmRpLCAlcmF4DQo+IA0KPiAJbW92cQlURFhfTU9EVUxFX3JjeCglcnNpKSwgJXJjeA0KPiAJbW92
cQlURFhfTU9EVUxFX3JkeCglcnNpKSwgJXJkeA0KPiAJbW92cQlURFhfTU9EVUxFX3I4KCVyc2kp
LCAgJXI4DQo+IAltb3ZxCVREWF9NT0RVTEVfcjkoJXJzaSksICAlcjkNCj4gCW1vdnEJVERYX01P
RFVMRV9yMTAoJXJzaSksICVyMTANCj4gCW1vdnEJVERYX01PRFVMRV9yMTEoJXJzaSksICVyMTEN
Cj4gDQo+IC5pZiBcc2F2ZWQNCj4gCXB1c2hxCXJieA0KPiAJcHVzaHEJcjEyDQo+IAlwdXNocQly
MTMNCj4gCXB1c2hxCXIxNA0KPiAJcHVzaHEJcjE1DQo+IA0KPiAJbW92cQlURFhfTU9EVUxFX3Ji
eCglcnNpKSwgJXJieA0KPiAJbW92cQlURFhfTU9EVUxFX3IxMiglcnNpKSwgJXIxMg0KPiAJbW92
cQlURFhfTU9EVUxFX3IxMyglcnNpKSwgJXIxMw0KPiAJbW92cQlURFhfTU9EVUxFX3IxNCglcnNp
KSwgJXIxNA0KPiAJbW92cQlURFhfTU9EVUxFX3IxNSglcnNpKSwgJXIxNQ0KPiANCj4gCS8qIFZQ
LlZNQ0FMTCBhbmQgVlAuRU5URVIgKi8NCj4gLmlmIFxyZXQNCj4gCXB1c2hxCSVyc2kNCj4gLmVu
ZGlmDQo+IAltb3ZxCVREWF9NT0RVTEVfcmRpKCVyc2kpLCAlcmRpDQo+IAltb3ZxCVREWF9NT0RV
TEVfcnNpKCVyc2kpLCAlcnNpDQo+IC5lbmRpZg0KPiANCj4gLkxjYWxsOg0KPiAuaWYgXGhvc3QN
Cj4gCXNlYW1jYWxsDQo+IAkvKg0KPiAJICogU0VBTUNBTEwgaW5zdHJ1Y3Rpb24gaXMgZXNzZW50
aWFsbHkgYSBWTUV4aXQgZnJvbSBWTVggcm9vdA0KPiAJICogbW9kZSB0byBTRUFNIFZNWCByb290
IG1vZGUuICBWTWZhaWxJbnZhbGlkIChDRj0xKSBpbmRpY2F0ZXMNCj4gCSAqIHRoYXQgdGhlIHRh
cmdldGVkIFNFQU0gZmlybXdhcmUgaXMgbm90IGxvYWRlZCBvciBkaXNhYmxlZCwNCj4gCSAqIG9y
IFAtU0VBTUxEUiBpcyBidXN5IHdpdGggYW5vdGhlciBTRUFNQ0FMTC4gUkFYIGlzIG5vdA0KPiAJ
ICogY2hhbmdlZCBpbiB0aGlzIGNhc2UuDQo+IAkgKi8NCj4gCWpjCS5Mc2VhbWZhaWwNCj4gDQo+
IC5pZiBcc2F2ZWQgJiYgXHJldA0KPiAJLyoNCj4gCSAqIFZQLkVOVEVSIGNsZWFycyBSU0kgb24g
b3V0cHV0LCB1c2UgaXQgdG8gcmVzdG9yZSBzdGF0ZS4NCj4gCSAqLw0KPiAJcG9wcQklcnNpDQo+
IAl4b3IJJWVkaSwlZWRpDQo+IAltb3ZxCSVyZGksIFREWF9NT0RVTEVfcmRpKCVyc2kpDQo+IAlt
b3ZxCSVyZGksIFREWF9NT0RVTEVfcnNpKCVyc2kpDQo+IC5lbmRpZg0KPiAuZWxzZQ0KPiAJdGRj
YWxsDQo+IA0KPiAJLyoNCj4gCSAqIFJBWCE9MCBpbmRpY2F0ZXMgYSBmYWlsdXJlLCBhc3N1bWUg
bm8gcmV0dXJuIHZhbHVlcy4NCj4gCSAqLw0KPiAJdGVzdHEJJXJheCwgJXJheA0KPiAJam5lCS5M
ZXJyb3INCg0KRm9yIHNvbWUgU0VBTUNBTEwvVERDQUxMIHRoZSBvdXRwdXQgcmVnaXN0ZXJzIG1h
eSBjb250YWluIGFkZGl0aW9uYWwgZXJyb3INCmluZm9ybWF0aW9uLiAgV2UgbmVlZCB0byBqdW1w
IHRvIGEgbG9jYXRpb24gd2hlcmUgd2hldGhlciByZXR1cm5pbmcgdGhvc2UNCmFkZGl0aW9uYWwg
cmVncyB0byAnc3RydWN0IHRkeF9tb2R1bGVfYXJncycgZGVwZW5kcyBvbiBccmV0Lg0KDQo+IA0K
PiAuaWYgXHNhdmVkICYmIFxyZXQNCj4gCS8qDQo+IAkgKiBTaW5jZSBSQVg9PTAsIGl0IGNhbiBi
ZSB1c2VkIGFzIGEgc2NyYXRjaCByZWdpc3RlciB0byByZXN0b3JlIHN0YXRlLg0KPiAJICoNCj4g
CSAqIFsgYXNzdW1lcyBcc2F2ZWQgaW1wbGllcyBccmV0IF0NCj4gCSAqLw0KPiAJcG9wcQklcmF4
DQo+IAltb3ZxCSVyZGksIFREWF9NT0RVTEVfcmRpKCVyYXgpDQo+IAltb3ZxCSVyc2ksIFREWF9N
T0RVTEVfcnNpKCVyYXgpDQo+IAltb3ZxCSVyYXgsICVyc2kNCj4gCXhvcgklZWF4LCAlZWF4Ow0K
PiAuZW5kaWYNCj4gLmVuZGlmIC8vIFxob3N0DQo+IA0KPiAuaWYgXHJldA0KPiAJLyogUlNJIGlz
IHJlc3RvcmVkICovDQo+IAltb3ZxCSVyY3gsIFREWF9NT0RVTEVfcmN4KCVyc2kpDQo+IAltb3Zx
CSVyZHgsIFREWF9NT0RVTEVfcmR4KCVyc2kpDQo+IAltb3ZxCSVyOCwgIFREWF9NT0RVTEVfcjgo
JXJzaSkNCj4gCW1vdnEJJXI5LCAgVERYX01PRFVMRV9yOSglcnNpKQ0KPiAJbW92cQklcjEwLCBU
RFhfTU9EVUxFX3IxMCglcnNpKQ0KPiAJbW92cQklcjExLCBURFhfTU9EVUxFX3IxMSglcnNpKQ0K
PiAuaWYgXHNhdmVkDQo+IAltb3ZxCSVyYngsIFREWF9NT0RVTEVfcmJ4KCVyc2kpDQo+IAltb3Zx
CSVyMTIsIFREWF9NT0RVTEVfcjEyKCVyc2kpDQo+IAltb3ZxCSVyMTMsIFREWF9NT0RVTEVfcjEz
KCVyc2kpDQo+IAltb3ZxCSVyMTQsIFREWF9NT0RVTEVfcjE0KCVyc2kpDQo+IAltb3ZxCSVyMTUs
IFREWF9NT0RVTEVfcjE1KCVyc2kpDQo+IC5lbmRpZg0KPiAuZW5kaWYgLy8gXHJldA0KPiANCj4g
LkxvdXQ6DQo+IC5pZiBcc2F2ZWQNCj4gCXBvcHEJJXIxNQ0KPiAJcG9wcQklcjE0DQo+IAlwb3Bx
CSVyMTMNCj4gCXBvcHEJJXIxMg0KPiAJcG9wcQklcmJ4DQo+IC5lbmRpZg0KPiAJRlJBTUVfRU5E
DQo+IAlSRVQNCj4gDQo+IAkvKg0KPiAJICogRXJyb3IgYW5kIGV4Y2VwdGlvbiBoYW5kbGluZyBh
dCAuTGNhbGwuIElnbm9yZSBccmV0IG9uIGZhaWx1cmUuDQo+IAkgKi8NCj4gLkxlcnJvcjoNCj4g
LmlmIFxzYXZlZCAmJiBccmV0DQo+IAlwb3BxCSVyc2kNCj4gLmVuZGlmDQo+IAlqbXAJLkxvdXQN
Cj4gDQo+IC5pZiBcaG9zdA0KPiAuTHNlYW1mYWlsOg0KPiAJLyoNCj4gCSAqIFNldCBSQVggdG8g
VERYX1NFQU1DQUxMX1ZNRkFJTElOVkFMSUQgZm9yIFZNZmFpbEludmFsaWQuDQo+IAkgKiBUaGlz
IHZhbHVlIHdpbGwgbmV2ZXIgYmUgdXNlZCBhcyBhY3R1YWwgU0VBTUNBTEwgZXJyb3IgY29kZSBh
cw0KPiAJICogaXQgaXMgZnJvbSB0aGUgUmVzZXJ2ZWQgc3RhdHVzIGNvZGUgY2xhc3MuDQo+IAkg
Ki8NCj4gCW1vdnEJJFREWF9TRUFNQ0FMTF9WTUZBSUxJTlZBTElELCAlcmF4DQo+IAlqbXAJLkxl
cnJvcg0KPiANCj4gLkxmYXVsdDoNCj4gCS8qDQo+IAkgKiBTRUFNQ0FMTCBjYXVzZWQgI0dQIG9y
ICNVRC4gUGVyIF9BU01fRVhUQUJMRV9GQVVMVCgpIFJBWA0KPiAJICogY29udGFpbnMgdGhlIHRy
YXAgbnVtYmVyLCBjb252ZXJ0IHRvIGEgVERYIGVycm9yIGNvZGUgYnkNCj4gCSAqIHNldHRpbmcg
dGhlIGhpZ2ggd29yZCB0byBURFhfU1dfRVJST1IuDQo+IAkgKi8NCj4gCW1vdgkkVERYX1NXX0VS
Uk9SLCAlcmRpDQo+IAlvcgklcmRpLCAlcmF4DQo+IAlqbXAJLkxlcnJvcg0KPiANCj4gCV9BU01f
RVhUQUJMRV9GQVVMVCguTGNhbGwsIC5MZmF1bHQpDQo+IC5lbmRpZg0KPiAuZW5kbQ0KDQo=
