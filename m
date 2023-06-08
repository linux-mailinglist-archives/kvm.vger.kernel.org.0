Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20688727C99
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 12:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbjFHKSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 06:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbjFHKSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 06:18:37 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF541FE9;
        Thu,  8 Jun 2023 03:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686219516; x=1717755516;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aGAXmSCu+5cw7S859uwJDj0lXZ3z4GXJlh3cD70DwBs=;
  b=CW2m3Cvpa2ZcwqxgG3DmBJZjwMKKQZ0d0aXy6heEllR5f1FF3KA8KdGe
   ru3xxWtAX2D2sCIMYmwTsQRVuVMO9D8KboM4KvVt2g1xWhN6S6s63WKSm
   rTKBmn2I/Nfmb1N0HgJvZhCKtrVNAggihKP+fYTlgOOvN6UBlUYCHVyHn
   XfHLfRFaq1h3y5j03KgMcdhSUKqdS93bgeCFpELfq+1aol+D7RTOT+HYa
   xWdwZGgJLB6i6x8X+l6K0Fd2KmqbVR9Y94pjj9qn74Dfz8qIXFuamC6vM
   usea4FHbifT7bMPwHmfvr598xAhCBI48eEhg9j7sWhbr2L+l1dymrtwaJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="357276748"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="357276748"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 03:18:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="739653907"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="739653907"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 08 Jun 2023 03:18:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 03:18:35 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 03:18:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 03:18:34 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 03:18:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhJolzlzQL0U2CPbqmvu+bW4uYd48vTgo4CMec6pR+QYKNBm1ZxuEJhH5MQk7ZBs4G1RVEWqvS7J1ibDoDNgxY5WIqpeeX9WjUAihnrUixklODU4cnE833Ixt9g+eM/5ZM0JiWfvbAPPJAx207iZg13/J19SjNCBvCuS5xsQ13lFfwjkTrDQ0R49sa7dypfNWmBQZ41ZXcQvJnpQLqzGkH5yS6LMTjj6hEzkqNdf1tiafRb2l612SW/rUEF8Ri+A9QuKFfrbo3w6/pocb6w8YebmdHCmimvbUxkke4u5YkD4hWddqP1TE/6/Ri1e5YbJX9SmTJyLPtLXSxPqHMiPhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGAXmSCu+5cw7S859uwJDj0lXZ3z4GXJlh3cD70DwBs=;
 b=K8730n0eIKq9jq3jATTHWcYED8tQSzJg540rPh+JWr89berJg1EXVxloDrWnS6up0x0aLQTxSlvEP9jr+NTeqrgEm3Y66i5KfzQEgxg0CxsxphsPIOQfxY3pqpg+ZfjtulWcuE83AhM6Xf45j/9DHZ0qojyQMLkbuRcKX/O2d5fpXtM8i2YY+SMjtUZL0c4EQap1r/my+forDvnIwI+blHOTdAvjcH3ZVtcgfb41S6ofOQk4SBz5JR2dNJRMutd2LvqZ3Xc3UJyTn/2SbImH2DH7ogP9hunWh9zaQPiviZRWZM9mJegJdXBG+rlROz6fUZ+8c9ZSbBtd73kM56Vu6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 10:18:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 10:18:32 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 10/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Topic: [PATCH v11 10/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHZlu+vTSZjsOivnkuvoCjDNNbnmq9/g46AgAEztAA=
Date:   Thu, 8 Jun 2023 10:18:31 +0000
Message-ID: <127f95b84355e8c08f314a0db56e958ed8ef0636.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <f9148e67e968d7aed4707b67ea9b1aa761401255.1685887183.git.kai.huang@intel.com>
         <c1f6322a-eb27-3a3c-5d96-f0601c004a8d@intel.com>
In-Reply-To: <c1f6322a-eb27-3a3c-5d96-f0601c004a8d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB8107:EE_
x-ms-office365-filtering-correlation-id: f4344dfb-717f-419a-94c0-08db6809b5fc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XQXhf42zWWd0aVIt6CFW3K6EuRMQN7lILke3qhaY/2S1QnfyV6w2TwkRZMffPVmhTyhAVK3th829p24DFqyqhetSzaJKBvjvG9HS1ArGzXWyUsa4DAfmDkFnHI5XCs/r+097d+3lVRhLVI5uzgxn/tMHyMNDXNv+DRy2mIY0twgFQuCNJmmU66QF//Omh8SNfii2i882VBtwy/w6xkemJevo9vo0cE7OEJzvALK3qZF+vUUU029viaQKVbETDCLOwo0iDfn7iTlGS7OS52/0D/JxhBKvGcSGYglskbCkDj0vCZlvireDc+/e9NOUbd+RPWrdkSb9KeOkX39Lo4k6+CUdyr5FV1JkeXm/ZpCcqi5Xo+RewRTDm8XrUQLjoiex5AfHXMH6i34zFJreZV/qTMU1pxbOMQyV4InblEElooHOqssM3s5i4PB5ZwN8Ahxg3opOeHR2qKI+sXIm53raMjzWTms8BFZc9QrWXG0dOPVAMWWtx7dIuO1R6lVC6rsjGtlWvBOyepCrRiZSrp5ZMDDxXyORi+vGrzutlb/Q60RG3qmO5SCNzo7aSe8kmqkRhZAdHvz09pJh6Gm4A/5wZTto+7Vz4rzAuGN5n5NnLlI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199021)(76116006)(53546011)(2616005)(26005)(66446008)(6506007)(6512007)(316002)(64756008)(66556008)(4326008)(122000001)(91956017)(66476007)(66946007)(966005)(6486002)(186003)(478600001)(71200400001)(110136005)(36756003)(54906003)(38070700005)(2906002)(5660300002)(8676002)(8936002)(82960400001)(86362001)(7416002)(41300700001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wk9kenQ1MDc0NVY1UHlDY2RGZ3RoV3FKMnFXWXpkZzlCZG12YWswZ2orSVpw?=
 =?utf-8?B?L3BXMnZPY0VsVXM4TUI0VVl0bjhWWjVnVk5ZaXduVk9pcnJLK3BuSEo1MDBt?=
 =?utf-8?B?THkwa0grd2E1OFZsNUlaWGV1L2JEN1Z1cGhwSlNaYXBEK3BUZzRzbE0xb0du?=
 =?utf-8?B?US81bnllU0dnaHNORlduT2xXd0Q0M3JJRndXRGlKWDRJQXJxdnRqbHh2eGVW?=
 =?utf-8?B?SDNrT3daNTZCM1Z1WTBxNkxBQllQdmxDVzh0alVIdkVLZnRBTzZTcFMwRE9O?=
 =?utf-8?B?OEFrbDE2ZGFFQlZaSHVWZG85VkYvNW41V3o3Z2Q1cXNBT1YyeDRuWDQ5S1d0?=
 =?utf-8?B?c3U4RHNLMlFpanFqYWUzWnBpUEVGanBNaGFLVXhWZzcwOTIwNVd6bGhMc21F?=
 =?utf-8?B?M0FoK2k3YjFRc0ljSUFReGJVNEM1SExQUEtMV1AxVHF5bzdDMC80Z2UrL1ZK?=
 =?utf-8?B?NHFwWHdLT2ptK3RUZnY0aDVnaXVHQmNUT3RUQ2pSSi9tWTcrMHlvZ21YaHln?=
 =?utf-8?B?Y0YvTUJLNlVoRG44U2NUTU9Fc3NweGFDR3I0NTdBVmE3UFVjcExBYmpSYWZW?=
 =?utf-8?B?WU9Bcy9ZUG9TTlV6UTZDZHBVdXE5UlJ0R2ZubnFrUlgxV2hjTTMzd1REM1oy?=
 =?utf-8?B?Q3JUaEpPUmZQMXQ3UEgrNU5FVDFYSmJ6SlZkRDR3SFpJUkt2YmN2RmdIYS84?=
 =?utf-8?B?a2hpSXBTNm11K01RekN1alNFS2RkVzNzTUsveGxRWUovcFZ3MEJSdzNpTGVl?=
 =?utf-8?B?UmRDVEh0Zy9LT3R6cWR2bWU4ckh1a1Y5N0w3ZFBydWNOWFZ5WUFmY3ZpU1ZH?=
 =?utf-8?B?c09ocHBwSDBxRzB3b1pZaGlEdXpYem9QRFg5VGM3ZjRuNjRkOS9LOURpbTNM?=
 =?utf-8?B?dFlUbjNvT3BkaEUzUHBFaXlpbUNiaENjc2EwSDE1cEljWkE5b2EzN051V0xZ?=
 =?utf-8?B?bGZadE9VNWdZeGNoV1BKc0pSdk1tQzM0enVxWjdzU1pLdzNYZDJheFFzTU9t?=
 =?utf-8?B?dDNUR1p1TC9BbnNQUnJJeWFLeXNFWXZCcGFzWkY0dGticElackZDMUFKOHli?=
 =?utf-8?B?S2dFQmcyK2JFY1krTzI0RU5ORFZFSE1CUHhTL282OHg1aTEzS1l2eXVOOFhh?=
 =?utf-8?B?UlhCdksrZWpYN2NBL2lDNWhrR3dONUtKYjRwVnl3UUF6OWFxTWtUTHRZSmZl?=
 =?utf-8?B?N244RmFTQnZtZ3Q2NHBmSG9uVjFVUEEvTVJXUVVIMVBsTDNwbXVYWVFmNDB1?=
 =?utf-8?B?cXZ2SWdINnpHRHNaM0s5UWlDVnFyeTlyZTBHeSsyd0IwNWFiWEpHVnZPUDE3?=
 =?utf-8?B?OWNjTms4WUJORDB2aVBTc2dLWmJzS3dVMGxMRE0wRkNsOUs5Z3lNTjlFOXJu?=
 =?utf-8?B?R1Z6eW96eHhDSVZVR3VncE1pbjZjeUtwMk84dVU3RFFaTEJueU9XN2RRWjh6?=
 =?utf-8?B?RkVmL3g2MENHa2J6OUgxYUIrMXRxUFhpN2RWVnlFTTZ6WGhhTGhjZlRDUXVx?=
 =?utf-8?B?VVFLUU5ISStPeDRRUmhYbEFpdDV6WkR5SG5nYnUzenpzUmFNUEo5dkxWZjN4?=
 =?utf-8?B?WlhOTytmejdJT2pFOExuQWczalVjUHdqR3ZYang4ODFuakd0Ymg4VXk0UEhl?=
 =?utf-8?B?RFZkV2pPYXYrYmMvZzNXRTgvRWY1K0MxdGhVdEdmYmF2RmdsVEx0TnJyWmxm?=
 =?utf-8?B?RWY1eittWGNBV3FmNFEwMWljeDk3dmthcWU4ZnpvN3VxWTRWd3R1b0NMSmhw?=
 =?utf-8?B?dTRBRkhPZXlObFpiKzlqaFoxTnNDd1FWL0krRzRDSmgvUDlWM05SSGJocFFl?=
 =?utf-8?B?Tm9JQzVCb2hlVHZjRVhPQndtSWtUNlpnWThndE92QWhSUFJHOTRHdlM4NWkw?=
 =?utf-8?B?UHJ4dWtKa05ZMDNtN2xzcWl0V1RBcFZtSFl6VFBVMlJSNmZWc0tDbjRQanU5?=
 =?utf-8?B?aTEvWHdNZ0hURFliKzd0M3BZbjB1bmsyc2o2cWJRRk1GbEcwQ1EzdXlTSW1M?=
 =?utf-8?B?Snd0L0V6L2gvR0dZVm0wWUM5Q0R4cDNTbnl4eit0RGQ1YmwvTEdWeGFiM3hW?=
 =?utf-8?B?aDFxTHVCOVpvK3hJb2NwZExXSmpxRGZKRGk1V0tBK25pS2k3bFZVbzlXMVZ1?=
 =?utf-8?B?Z05aMXdMb0ZyUVoxV3FiT3d3dlFiS0QvQmdFMTRHTE1vTjAyZEVaWFhtV0hK?=
 =?utf-8?B?Rnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BE367397D55BC49B6F3139EF214FD17@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4344dfb-717f-419a-94c0-08db6809b5fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 10:18:32.0131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pxgPX+fh8JjDROFtfmlDPLEFb6uzDuNx6Y3v0Cy0yk1Ali4yq2FrbbMgy9mBejsnbg16MyvWUdMCCb5IPvxdDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8107
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

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDA4OjU3IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi80LzIzIDA3OjI3LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gK3N0cnVjdCB0ZG1yX2luZm9f
bGlzdCB7DQo+ID4gKwl2b2lkICp0ZG1yczsJLyogRmxleGlibGUgYXJyYXkgdG8gaG9sZCAndGRt
cl9pbmZvJ3MgKi8NCj4gPiArCWludCBucl9jb25zdW1lZF90ZG1yczsJLyogSG93IG1hbnkgJ3Rk
bXJfaW5mbydzIGFyZSBpbiB1c2UgKi8NCj4gDQo+IEknbSBsb29raW5nIGJhY2sgaGVyZSBhZnRl
ciBzZWVpbmcgdGhlIHdlaXJkIGNhc3QgaW4gdGhlIG5leHQgcGF0Y2guDQo+IA0KPiBXaHkgaXMg
dGhpcyBhIHZvaWQqIGluc3RlYWQgb2YgYSBfcmVhbF8gdHlwZT8NCg0KSSBmb2xsb3dlZCB5b3Vy
IHN1Z2dlc3Rpb24gaW4gdjg6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tLzcy
NWRlNmU5LWU0NjgtNDhlZi0zYmFlLTFlOGExYjdlZjBmN0BpbnRlbC5jb20vDQoNCkkgcXVvdGVk
IHRoZSByZWxldmFudCBwYXJ0IGhlcmU6DQoNCj4gKy8qIEdldCB0aGUgVERNUiBmcm9tIHRoZSBs
aXN0IGF0IHRoZSBnaXZlbiBpbmRleC4gKi8NCj4gK3N0YXRpYyBzdHJ1Y3QgdGRtcl9pbmZvICp0
ZG1yX2VudHJ5KHN0cnVjdCB0ZG1yX2luZm9fbGlzdCAqdGRtcl9saXN0LA0KPiArCQkJCSAgICBp
bnQgaWR4KQ0KPiArew0KPiArCXJldHVybiAoc3RydWN0IHRkbXJfaW5mbyAqKSgodW5zaWduZWQg
bG9uZyl0ZG1yX2xpc3QtPmZpcnN0X3RkbXIgKw0KPiArCQkJdGRtcl9saXN0LT50ZG1yX3N6ICog
aWR4KTsNCj4gK30NCg0KSSB0aGluayB0aGF0J3MgbW9yZSBjb21wbGljYXRlZCBhbmQgaGFzIG1v
cmUgY2FzdGluZyB0aGFuIG5lY2Vzc2FyeS4NClRoaXMgbG9va3MgbmljZXI6DQoNCglpbnQgdGRt
cl9pbmZvX29mZnNldCA9IHRkbXJfbGlzdC0+dGRtcl9zeiAqIGlkeDsNCg0KCXJldHVybiAodm9p
ZCAqKXRkbXJfbGlzdC0+Zmlyc3RfdGRtciArIHRkbXJfaW5mb19vZmZzZXQ7DQoNCkFsc28sIGl0
IG1pZ2h0IGV2ZW4gYmUgd29ydGgga2VlcGluZyAtPmZpcnN0X3RkbXIgYXMgYSB2b2lkKi4gIEl0
IGlzbid0DQphIHJlYWwgQyBhcnJheSBhbmQga2VlcGluZyBpdCBhcyB2b2lkKiB3b3VsZCBrZWVw
IGFueW9uZSBmcm9tIGRvaW5nOg0KDQoJdGRtcl9mb28gPSB0ZG1yX2xpc3QtPmZpcnN0X3RkbXJb
Zm9vXTsNCg==
