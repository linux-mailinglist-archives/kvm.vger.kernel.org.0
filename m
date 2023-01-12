Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00011667124
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 12:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbjALLmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 06:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236736AbjALLli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 06:41:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D983476D;
        Thu, 12 Jan 2023 03:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673523192; x=1705059192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HeGHWWCnNdLtRHpOoInPFOqDPTWFR8FT57bAPZqtU68=;
  b=I5mGQAbTYAKu8MSauiJuGAt1GFkw46ewb6RLajsom4ET348eTmKQ+WTn
   9wrNbqpswr/rxQLL5BDQre2sj77zXA0BPi2ZAVuXsOi/63iIfwxe6jI7G
   Uc/AAcJNH86V6tIFLratjfP9XC4vtIf1PSudmL8Bi7V94qS5o31a0eK+u
   ABOEkLTbIhapg++mGE4kJgRy7kd/w4tc78od/Ihv59QXt0rsHHzyA0eBo
   tBo2j9RYtAp5QZkS4EvNEKk+WOLMKsZ0WmSAb7ZmuLEsIiVYvzn251mo1
   4UlAbTBGnPPJjuD0S8EdLLWFk8rIzUC01EWnfvmTlHXBcSU7F1IrxPSof
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="323741980"
X-IronPort-AV: E=Sophos;i="5.96,319,1665471600"; 
   d="scan'208";a="323741980"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 03:33:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="765579933"
X-IronPort-AV: E=Sophos;i="5.96,319,1665471600"; 
   d="scan'208";a="765579933"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jan 2023 03:33:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 03:33:11 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 03:33:10 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 03:33:10 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 12 Jan 2023 03:33:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNcp+g+IW+YaxCLBZj4svAVa9bv+DkbSYaOuX4OjVzGtPDAjExOEOmKzxJlGduD85+Ma77eFrwzwRPDMK7ZZ0DlvAsfV1YbppWteZ51mp1ynwf/j/nHyCOCujPGrrui9dEdLVNctGXysBGDPHGL6iLqek3OlE10jN9jIHksUaA352ZYIH2uQVCWvfIrTxno+2q8lv32BYbsuYx/W8bCPIXdxxnhHtTGfTnW2zCY7VsWWNFEx6JXUsfGHQf5yXp7PnAYy0xiWSWwnVNqNfipLGevcUA6nZR50kk7HNVv/wH7ItVid/W6XAdLMUdrShZQ8O0jRut3H928/t2Aqjwzang==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HeGHWWCnNdLtRHpOoInPFOqDPTWFR8FT57bAPZqtU68=;
 b=CPnzpX8uoIuoB15DTuxx5RHOQnwU5QcRDFX4gnfUQhqjbdMPetxa01qVmWfnEjjxAGu9/s0MwOOwTM7LNqx36mWDQVMGFXHrKxdzhebkbuHEsX06g5OwVeeggswhAG4cKFqdwXxkxfTwLuBncV++HOuO7OEm8PXu0FiuNhaXLpP4/JOw9/5/acNX6fCIWKApQAiljet+WM1bvVq59LQJ1YPJgmEwXx0yPpXGSCmaEgCEVi95wCqTEivRL2WAGYVbqun1+XjDdY5dEmRG7mQQAIC86k3PRzQTc4NRLMP9CY9PaW/CaNyAd7ecbQzRCi6SXCFn13VgWENc1TKswMFWGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by PH7PR11MB7595.namprd11.prod.outlook.com (2603:10b6:510:27a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 12 Jan
 2023 11:33:06 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076%9]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 11:33:06 +0000
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
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHZC5gLiOnJQQKFB0CM7X30zcZDS66R31QAgARKC4CAAFSjAIAEXhIA
Date:   Thu, 12 Jan 2023 11:33:06 +0000
Message-ID: <be85aa450b221bb730013d3b6ec0d4e71b51c228.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
         <e7b682a1-abdf-ce73-f262-8b7ce946e78e@intel.com>
         <bc11552572428c3b29b67852b062c387ecd7be45.camel@intel.com>
         <e02fd75d-e9d4-15f1-eb9c-31cf3cc9ddc1@intel.com>
In-Reply-To: <e02fd75d-e9d4-15f1-eb9c-31cf3cc9ddc1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|PH7PR11MB7595:EE_
x-ms-office365-filtering-correlation-id: 5c64af5e-7314-4466-c00e-08daf490c63f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4blpctGeFENsT76bLLEtdzd4CFCEzELaR9gGvIHk6kygeItzOdlfVk6bvRpbGvUF+33IaFfjp801RE6VNX3wHR6/gPiB1zkKVqxBhlGuoI3EJ8XhTAWriv6kcUshmsq1EX5GnBMjStJhC9CS4QCXZJNH6HtemZaCjc6K8RDpmGFLzw68+lHx0SaYSsVy7a23QjRMiMl2wjl857aWYuvgOZ+yuNe1BORXw9+x7LtR1V+SHbhZRIO6uZ3f0iF+3WkjC9+KgOyoVZOxsMj1C+yIlADsgjUVX7HLy88YVshnmF/JlWslHlc4+DnPMAcZkcES0Qe2zcW/Wb533RH02S7JNqpT/4B4sH5qevkRORo8s+xAIUYGJ4SxMnFHQlgnv+U4XSSO1jyY8FbYBILfNBtVNuujr2LK4YhCnbf3qf57CIbdj2/4A+M6SLMCz6zYUllouibkK3h/w/IvKCnmDiYkJVkP8HFCrLZ8vKqrzPbGjO1knqK8lJdxJU9kAd+coKqnOA6ZGyjaVbHeV4+oZ0xWcptAZaC2P2BblfNolXcgcKGQnNOMY33wIDzCuqAq9BEsgnu8cHo3PEWXokNPFOOzpjkmYfJUoywDSZ6pUbUabOAR3ofbkVVLTQv4vz0W6Mr7rzbUx2WhhJA+3fDwfgJyNaATSeVFcvAX5skAIbHcIyRdtZN2K2Q/D4iXByldHH/zPI+o+zo32CCYcja+U3smUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199015)(6506007)(7416002)(2906002)(36756003)(4326008)(5660300002)(83380400001)(8936002)(122000001)(8676002)(64756008)(66446008)(38100700002)(6512007)(82960400001)(41300700001)(6486002)(478600001)(38070700005)(66556008)(26005)(66946007)(76116006)(66476007)(186003)(86362001)(71200400001)(2616005)(316002)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3FkUitpeWpTcWRMSmtjK0Z4QkRGa2VlVENGQ29OUE9nNUxQeHEyWVdKdkU3?=
 =?utf-8?B?YXVvVUVMQmFGZmVJVDhUV0hSNmFvRWtzUGEzb3BlOHZybUhaTWNhbEMyYW5F?=
 =?utf-8?B?ZW9zZHdoNVFsN0d4N2EwRlZEdWRVTUYrZmJ2blJPdEtESHNFMHhvd056dXBn?=
 =?utf-8?B?MzNjMWZ4bnJRMlNMbGowbVBpd3orL3dJR2R5T2pPTEh0UEtzY2IxditjOTYy?=
 =?utf-8?B?UFBmT3lqQ2VGUjdkem1xMXFnZG1DcGpCQmFXbGNmK1FGenE5WHhjQ1NTOFZC?=
 =?utf-8?B?bllMQTV0VlltcDhOMk1zMVRkcEJZbVEwQUpxcTZPcGtvZHNRT3JTT0tRQWxu?=
 =?utf-8?B?WDIxUkZ2eGdFdkZhMUNyMDdxSk5nQXp6b1ZTZGNUVlhWV1lFZmhMc3BhYkpy?=
 =?utf-8?B?S095dlBlWHpESnY5ejF2ZWx3dS9FbFR5MGoxdWxjRkFFb1gxRFZNTW5mQkF4?=
 =?utf-8?B?ZDdLTFFFOWppdEhxaVU1Z2ZCUkpaYVNQMnVjSFlnZDRGNDVnbzJsN08zQmRm?=
 =?utf-8?B?L1dGTFRwbWY0Tm9QTnF2M1lyVElVMEd3ajlaOHpKUlZLUEhhekg0NWZuZ0JQ?=
 =?utf-8?B?dU5zdmtjL2hubEdoVmJiTjlPTWc2R3RMb2NLUjBTbjBzV0NGcWpJVHcvT3Fm?=
 =?utf-8?B?alBENldDb2lYQmxjeUptMHpXekhiTFU0OHpnODZpU3NlSXkzZDRMUTkzMVZF?=
 =?utf-8?B?Ui9WUndlbmQ2TW9DczN0SUUxY3ZmalhRQk5jNlRpVTRPclFKdEtxQVBxb3pU?=
 =?utf-8?B?ZlJOU085Wk9rQXd5Und2dmRCRTc1MzFWSjJKb2p1anJkTFpUalNlc1N4d2VK?=
 =?utf-8?B?ZFIyK0xvcnpyR3ZGdjQxTm4yeWNkaVFYQlpreDlQZy9jSFVtMGV2RnE1WldN?=
 =?utf-8?B?QjVwZHZEUmpLdnltaHlCY2lKd0MvWW1pTTdpZ0w5QlBuVGVJUEFHWVZIL1la?=
 =?utf-8?B?RlN6YUQzbmNrL2NxWSsySngydi9TeWpVRHUyOHBKOEo3aS81M3BkN3IvUnVR?=
 =?utf-8?B?Z1d1V0hBaVU3eS9Ea3FLeDdxTTI1Q0Q1RmZXQm5aNHdzVXV0WnA2aXN3ZzZy?=
 =?utf-8?B?Tkc5Q0JMNnNzLzRFdzR3WkpIejFDSlRCbG03ZWRIbStKL2UzUW1PM0E1alo1?=
 =?utf-8?B?eWdSSkp4eWIvMWxjVjA0L3lENWh2bE1jbG56Y2swVExNWnRYaW1YQ3hBZ2Vl?=
 =?utf-8?B?WnR3VGFiaW9GR3dLdkpkeDdvU3A5V0NjQ3VvdGdrSVVpTXQ1N3Jsbml4VHlL?=
 =?utf-8?B?TXI5R2dEMGdDdjl0OVl0VmxOM3Y2R3ZKVE9ERzhpcmlmTm83N2ZnWTZpcVFM?=
 =?utf-8?B?RWFSbFlwazhQOG52WXJ0bUVWck44bkJaMENwYURmaFVJOFlhQWp4NXQyMWY4?=
 =?utf-8?B?dzNtbTdza3ZEMFVZYUJjRDJOV2wycHJGVm1oQ24zUjJ4QVJJQXY0b0c5SzE4?=
 =?utf-8?B?L2JoVjA3TVZaa09ObWZZeVRhQ3UwMk1DQ2hrM2RSb3A0bUJNM0dia3RzNGRT?=
 =?utf-8?B?UjFKem5vZmhyRElDTGZZc0UrVlhtcTZISXRCTXhGWGFjNHhmWUJ2bGpoaFhz?=
 =?utf-8?B?djF2cUMvcVhWaHh4TzVZRjg5UE1CYjdnM1RIcFNjQ2ZXZ2xlQ2o2U2VWMGlL?=
 =?utf-8?B?WEJPYnhxQW5yazh3VWVyelNZZlkxWG9HUFJlVTZqSHlaTEFadEp2V0FrZ2JQ?=
 =?utf-8?B?czRXZ3RBS3U4TW9mMFVOS1ZvbFFNZDVOdHBPckNBZmxGakNEVXpaWFlzNUhT?=
 =?utf-8?B?NDE2L2FYOElGSjZ1ZTNTM094OUJuYllScmZEcEFHaDlnbEdKSlFZTnpqdnUw?=
 =?utf-8?B?UHF5MzZEMnUzSCtyaVlTVHBvcnU3SHV6aHZrTXVFcWNLaklYRlExQkpLb3Az?=
 =?utf-8?B?cEJNMm1UUkZnYk0zWGttMVJ0MDdaUjdVc0FNMzBnVmdub3NvRzJ6TFJMU0pu?=
 =?utf-8?B?MThQbnpLT3U4L0xhWDFmVkhCdTh2Y3JXVHM4NjdSamNxUWtkKzVkQnlOWS9z?=
 =?utf-8?B?elVHa1BDNEJaYWFHT1dhMkp2QTd0TTdkamlTMS9CNTlxUEFzdnpzcmNnMk0r?=
 =?utf-8?B?RE9MR1JkbHBZeWpid2RxSWVFZWxZUTE5NkdVb3JMb0l1T2paVTRXSWhXN092?=
 =?utf-8?B?bFdrZVBXc0g2bWIvNlp3Z3RYaXBOREpxUVMwT20rY2RWNDZJVWJuRUJHZjM4?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7324EC48380C104DA8358FB9C602C71A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c64af5e-7314-4466-c00e-08daf490c63f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 11:33:06.4256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fL9Z7qfLOjJVcWJi+RhPvcZRVbFlWpDUtiQ+P6u9TpYTdAlOSuqJx9Aj5oVBG0OF9Q5eF71WGpY3VPRXrub1qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7595
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAxLTA5IGF0IDA4OjUxIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiA+ID4gPiA+ICvCoMKgwqDCoMKgwqAgbGlzdF9mb3JfZWFjaF9lbnRyeSh0bWIsICZ0ZHhfbWVt
bGlzdCwgbGlzdCkgew0KPiA+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
LyoNCj4gPiA+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBUaGUgbmV3
IHJhbmdlIGlzIFREWCBtZW1vcnkgaWYgaXQgaXMgZnVsbHkNCj4gPiA+ID4gPiA+IGNvdmVyZWQg
YnkNCj4gPiA+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBhbnkgVERY
IG1lbW9yeSBibG9jay4NCj4gPiA+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgKg0KPiA+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIE5vdGUg
VERYIG1lbW9yeSBibG9ja3MgYXJlIG9yaWdpbmF0ZWQgZnJvbQ0KPiA+ID4gPiA+ID4gbWVtYmxv
Y2sNCj4gPiA+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBtZW1vcnkg
cmVnaW9ucywgd2hpY2ggY2FuIG9ubHkgYmUgY29udGlndW91cyB3aGVuDQo+ID4gPiA+ID4gPiB0
d28NCj4gPiA+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiByZWdpb25z
IGhhdmUgZGlmZmVyZW50IE5VTUEgbm9kZXMgb3IgZmxhZ3MuwqANCj4gPiA+ID4gPiA+IFRoZXJl
Zm9yZQ0KPiA+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHRoZSBu
ZXcgcmFuZ2UgY2Fubm90IGNyb3NzIG11bHRpcGxlIFREWCBtZW1vcnkNCj4gPiA+ID4gPiA+IGJs
b2Nrcy4NCj4gPiA+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8NCj4g
PiA+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChzdGFydF9wZm4gPj0g
dG1iLT5zdGFydF9wZm4gJiYgZW5kX3BmbiA8PSB0bWItDQo+ID4gPiA+ID4gPiA+ZW5kX3BmbikN
Cj4gPiA+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCByZXR1cm4gdHJ1ZTsNCj4gPiA+ID4gPiA+ICvCoMKgwqDCoMKgwqAgfQ0KPiA+ID4gPiA+ID4g
K8KgwqDCoMKgwqDCoCByZXR1cm4gZmFsc2U7DQo+ID4gPiA+ID4gPiArfQ0KPiA+ID4gPiANCj4g
PiA+ID4gSSBkb24ndCByZWFsbHkgbGlrZSB0aGF0IGNvbW1lbnQuwqAgSXQgc2hvdWxkIGZpcnN0
IHN0YXRlIGl0cyBiZWhhdmlvcg0KPiA+ID4gPiBhbmQgYXNzdW1wdGlvbnMsIGxpa2U6DQo+ID4g
PiA+IA0KPiA+ID4gPiDCoMKgwqDCoCBUaGlzIGNoZWNrIGFzc3VtZXMgdGhhdCB0aGUgc3RhcnRf
cGZuPC0+ZW5kX3BmbiByYW5nZSBkb2VzIG5vdA0KPiA+ID4gPiDCoMKgwqDCoCBjcm9zcyBtdWx0
aXBsZSB0ZHhfbWVtbGlzdCBlbnRyaWVzLg0KPiA+ID4gPiANCj4gPiA+ID4gT25seSB0aGVuIHNo
b3VsZCBpdCBkZXNjcmliZSB3aHkgdGhhdCBpcyBPSzoNCj4gPiA+ID4gDQo+ID4gPiA+IMKgwqDC
oMKgIEEgc2luZ2xlIG1lbW9yeSBob3RwbHVnIGV2ZW4gYWNyb3NzIG11dGxpcGxlIG1lbWJsb2Nr
cyAoZnJvbQ0KPiA+ID4gPiDCoMKgwqDCoCB3aGljaCB0ZHhfbWVtbGlzdCBlbnRyaWVzIGFyZSBk
ZXJpdmVkKSBpcyBpbXBvc3NpYmxlLsKgIC4uLiB0aGVuDQo+ID4gPiA+IMKgwqDCoMKgIGFjdHVh
bGx5IGV4cGxhaW4NCj4gPiA+ID4gDQo+ID4gDQo+ID4gSG93IGFib3V0IGJlbG93Pw0KPiA+IA0K
PiA+IMKgwqDCoMKgwqDCoMKgwqAgLyoNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqAgKiBUaGlzIGNo
ZWNrIGFzc3VtZXMgdGhhdCB0aGUgc3RhcnRfcGZuPC0+ZW5kX3BmbiByYW5nZSBkb2VzIG5vdA0K
PiA+IGNyb3NzDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgICogbXVsdGlwbGUgdGR4X21lbWxpc3Qg
ZW50cmllcy4gQSBzaW5nbGUgbWVtb3J5IGhvdHBsdWcgZXZlbnQNCj4gPiBhY3Jvc3MNCj4gPiDC
oMKgwqDCoMKgwqDCoMKgwqAgKiBtdWx0aXBsZSBtZW1ibG9ja3MgKGZyb20gd2hpY2ggdGR4X21l
bWxpc3QgZW50cmllcyBhcmUgZGVyaXZlZCkNCj4gPiBpcw0KPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oCAqIGltcG9zc2libGUuIFRoYXQgbWVhbnMgc3RhcnRfcGZuPC0+ZW5kX3BmbiByYW5nZSBjYW5u
b3QgZXhjZWVkIGENCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqAgKiB0ZHhfbWVtbGlzdCBlbnRyeSwg
YW5kIHRoZSBuZXcgcmFuZ2UgaXMgVERYIG1lbW9yeSBpZiBpdCBpcw0KPiA+IGZ1bGx5DQo+ID4g
wqDCoMKgwqDCoMKgwqDCoMKgICogY292ZXJlZCBieSBhbnkgdGR4X21lbWxpc3QgZW50cnkuDQo+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgICovDQo+IA0KPiBJIHdhcyBob3BpbmcgeW91IHdvdWxkIGFj
dHVhbGx5IGV4cGxhaW4gd2h5IGl0IGlzIGltcG9zc2libGUuDQo+IA0KPiBJcyB0aGVyZSBzb21l
dGhpbmcgZnVuZGFtZW50YWwgdGhhdCBrZWVwcyBhIG1lbW9yeSBhcmVhIHRoYXQgc3BhbnMgdHdv
DQo+IG5vZGVzIGZyb20gYmVpbmcgcmVtb3ZlZCBhbmQgdGhlbiBhIG5ldyBhcmVhIGFkZGVkIHRo
YXQgaXMgY29tcHJpc2VkIG9mDQo+IGEgc2luZ2xlIG5vZGU/DQo+IA0KPiBCb290IHRpbWU6DQo+
IA0KPiAJfCBtZW1ibG9ja8KgIHzCoCBtZW1ibG9jayB8DQo+IAk8LS1Ob2RlPTAtLT4gPC0tTm9k
ZT0xLS0+DQo+IA0KPiBGdW5reSBob3RwbHVnLi4uIG5vdGhpbmcgdG8gc2VlIGhlcmUsIHRoZW46
DQo+IA0KPiAJPC0tLS0tLS0tTm9kZT0yLS0tLS0tLS0+DQo+IA0KPiBJIHdvdWxkIGJlbGlldmUg
dGhhdCB0aGVyZSBpcyBubyBjdXJyZW50IGJhcmUtbWV0YWwgVERYIHN5c3RlbSB0aGF0IGhhcw0K
PiBhbiBpbXBsZW1lbnRhdGlvbiBsaWtlIHRoaXMuwqAgQnV0LCB0aGUgY29tbWVudHMgYWJvdmUg
c3BlYWsgbGlrZSBpdCdzDQo+IGZ1bmRhbWVudGFsbHkgaW1wb3NzaWJsZS7CoCBUaGF0IHNob3Vs
ZCBiZSBjbGFyaWZpZWQuDQo+IA0KPiBJbiBvdGhlciB3b3JkcywgdGhhdCBjb21tZW50IHRhbGtz
IGFib3V0IG1lbWJsb2NrIGF0dHJpYnV0ZXMgYXMgYmVpbmcNCj4gdGhlIGNvcmUgdW5kZXJseWlu
ZyByZWFzb24gdGhhdCB0aGF0IHNpbXBsaWZpZWQgY2hlY2sgaXMgT0suwqAgSXMgdGhhdA0KPiBp
dCwgb3IgaXMgaXQgcmVhbGx5IHRoZSByZWR1Y2VkIGhvdHBsdWcgZmVhdHVyZSBzZXQgb24gVERY
IHN5c3RlbXM/DQoNCkhpIERhdmUsDQoNCkkgdGhpbmsgSSBoYXZlIGJlZW4gZm9yZ2V0dGluZyB0
aGF0IHdlIGhhdmUgc3dpdGNoZWQgdG8gcmVqZWN0IG5vbi1URFggbWVtb3J5IGluDQptZW1vcnkg
b25saW5lLCBidXQgbm90IGluIG1lbW9yeSBob3QtYWRkLiDCoA0KDQpNZW1vcnkgb2ZmbGluZS9v
bmxpbmUgaXMgZG9uZSBvbiBncmFudWxhcml0eSBvZiAnc3RydWN0IG1lbW9yeV9ibG9jaycsIGJ1
dCBub3QNCm1lbWJsb2NrLiAgSW4gZmFjdCwgdGhlIGhvdHBsdWdnYWJsZSBtZW1vcnkgcmVnaW9u
IChvbmUgbWVtYmxvY2spIG11c3QgYmUNCm11bHRpcGxlIG9mIG1lbW9yeV9ibG9jaywgYW5kIGEg
InRvLWJlLW9ubGluZSIgbWVtb3J5X2Jsb2NrIG11c3QgYmUgZnVsbCByYW5nZQ0KbWVtb3J5IChu
byBtZW1vcnkgaG9sZSkuDQoNClNvIGlmIEkgYW0gbm90IG1pc3Npbmcgc29tZXRoaW5nLCBJSVVD
IHRoYXQgbWVhbnMgaWYgdGhlIHN0YXJ0X3BmbjwtPmVuZF9wZm4gaXMNClREWCBtZW1vcnksIGl0
IG11c3QgYmUgZnVsbHkgd2l0aGluIHNvbWUgQHRkeF9tZW1saXN0IGVudHJ5LCBidXQgY2Fubm90
IGNyb3NzDQptdWx0aXBsZSBzbWFsbCBlbnRyaWVzLiAgQW5kIHRoZSBtZW1vcnkgaG90cGx1ZyBj
YXNlIGluIHlvdXIgYWJvdmUgZGlhZ3JhbQ0KYWN0dWFsbHkgc2hvdWxkbid0IG1hdHRlci4NCg0K
SWYgYWJvdmUgc3RhbmRzLCBob3cgYWJvdXQgYmVsb3c/DQoNCiAgICAgICAgLyoNCiAgICAgICAg
ICogVGhpcyBjaGVjayBhc3N1bWVzIHRoYXQgdGhlIHN0YXJ0X3BmbjwtPmVuZF9wZm4gcmFuZ2Ug
ZG9lcyBub3QgDQogICAgICAgICAqIGNyb3NzIG11bHRpcGxlIEB0ZHhfbWVtbGlzdCBlbnRyaWVz
LiAgQSBzaW5nbGUgbWVtb3J5IG9ubGluZSAgIA0KICAgICAgICAgKiBldmVudCBhY3Jvc3MgbXVs
dGlwbGUgQHRkeF9tZW1saXN0IGVudHJpZXMgKHdoaWNoIGFyZSBkZXJpdmVkICANCiAgICAgICAg
ICogZnJvbSBtZW1ibG9ja3MgYXQgdGhlIHRpbWUgb2YgbW9kdWxlIGluaXRpYWxpemF0aW9uKSBp
cyBub3QgICAgDQogICAgICAgICAqIHBvc3NpYmxlLg0KICAgICAgICAgKg0KICAgICAgICAgKiBU
aGlzIGlzIGJlY2F1c2UgbWVtb3J5IG9mZmxpbmUvb25saW5lIGlzIGRvbmUgb24gZ3JhbnVsYXJp
dHkgICANCiAgICAgICAgICogb2YgJ3N0cnVjdCBtZW1vcnlfYmxvY2snLCBhbmQgdGhlIGhvdHBs
dWdnYWJsZSBtZW1vcnkgcmVnaW9uICAgDQogICAgICAgICAqIChvbmUgbWVtYmxvY2spIG11c3Qg
YmUgbXVsdGlwbGUgb2YgbWVtb3J5X2Jsb2NrLiAgQWxzbywgdGhlICAgIA0KICAgICAgICAgKiAi
dG8tYmUtb25saW5lIiBtZW1vcnlfYmxvY2sgbXVzdCBiZSBmdWxsIG1lbW9yeSAobm8gbWVtb3J5
ICAgICANCiAgICAgICAgICogaG9sZSwgaS5lLiBjb250YWluaW5nIG11bHRpcGxlIHNtYWxsIG1l
bWJsb2NrcykuDQogICAgICAgICAqDQogICAgICAgICAqIFRoaXMgbWVhbnMgaWYgdGhlIHN0YXJ0
X3BmbjwtPmVuZF9wZm4gcmFuZ2UgaXMgVERYIG1lbW9yeSwgaXQgIA0KICAgICAgICAgKiBtdXN0
IGJlIGZ1bGx5IHdpdGhpbiBvbmUgQHRkeF9tZW1saXN0IGVudHJ5LCBidXQgY2Fubm90IGNyb3Nz
ICANCiAgICAgICAgICogbXVsdGlwbGUgc21hbGwgZW50cmllcy4NCiAgICAgICAgICovDQogICAg
ICAgIGxpc3RfZm9yX2VhY2hfZW50cnkodG1iLCAmdGR4X21lbWxpc3QsIGxpc3QpIHsNCiAgICAg
ICAgICAgICAgICBpZiAoc3RhcnRfcGZuID49IHRtYi0+c3RhcnRfcGZuICYmIGVuZF9wZm4gPD0g
dG1iLT5lbmRfcGZuKQ0KICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7DQogICAg
ICAgIH0NCg0K
