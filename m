Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8829363A334
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiK1Iie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiK1Iic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:38:32 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DA59FED;
        Mon, 28 Nov 2022 00:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669624712; x=1701160712;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YDTrAvvVIWwg4COR1+ug6qC/4YaLDeEmQHrVWDLDme4=;
  b=ghPIyZ4UPF2JRp9iu5czumQ6CzUZdaLo+HtSg56XclmKyuYJ7Ho5kj+g
   O+5SHkqyVknxyn/M1NCSymF/P6/g1enCYIh2rWbXmEzdsZORTEz8ylcrY
   wUImAZl3po9LCGrZsbNp25+A/QOLR6bWjl8iT3zGNgG8qiEi5bxEouxuS
   5ysxXQuzGpytxe9uwVVyX1w3LGAcmXmK0Ii1MDQdy6fO1W3x8iyb2kcQT
   Ynq1Razrt+qbFyxYjY5nE/+PqPxaLdJcWVYN/tCJADtVNxa7ocxFVFwW2
   XRLGQcUbuync93vclxMSkfZa4VTlFhMFB2r0RWCMwH+wduPucCfI4phaK
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="316605707"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="316605707"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 00:38:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="593791182"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="593791182"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 28 Nov 2022 00:38:30 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:38:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:38:30 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 00:38:30 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 00:38:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+I8cgsQjO6K567n0ysQ5wevt4TA7AZRhBvGaHoXwrqjw42YdSk6s/1fmhV8rwVlmuYEjUkv9dUtQ3DdkXImfM2fJonG8aDIbcL++MD0lzeqELcU6L57YAWxlJ0HYYUczU3KLr1ufymJakJWWNhR01I9+tybiZqpriEhKnmc7yRldOTx1Of4+HPHEgAvtdLjCyk7pcNZ5OXRfw6YqL0OZKUBAJ/ZYg8DA9g30YWnhsvoucn0B0rTMMlhgKfR7A4wivDL9HO6s7wuyaV7iL/WLF5YGYOXtsu5AmCS3vPmO94csofTvHvzvvxWWrnn/XICi0rJuSR+VAf0cG5Yd8BjCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDTrAvvVIWwg4COR1+ug6qC/4YaLDeEmQHrVWDLDme4=;
 b=WpQpflqUCOS8zgKBHrjiyUewMshO36qRmCOkBEhRRaWJamJ8BCnUhzgVFPVqqKxipV9e5Ki33AhtIh/VFGqb6wqA8D8EbnwhHGe9xqmTFhPHhKjPXSm9bvlxSmsm1JsajNzDmwDso/xkY26CFg27FYvWHKH8szpM+DcGBoNwHTRZY2BxsVBZVhy0Ukkj6iEwMxYhQeA961N+fF/emTrDpXrAlDozWoyN/taEj+tHejQefZQ0Ft/ij68trYXrtiLFgodf0E60w1Rz1oBkcdvBbGRALmuQjTfC0mUlCQJW0j5hbnDRlp8BKTONUB1UpGvYz/qVDIGvWDdSin4LSlYOIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Mon, 28 Nov
 2022 08:38:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 08:38:26 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
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
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHY/T3KCI/2IUKL7kSgXbHXnV3Az65NU9CAgAB5pwCAAZiKgIAEqQwA
Date:   Mon, 28 Nov 2022 08:38:26 +0000
Message-ID: <397ebe70bf9cede731f2f8bbd05e0df518fd3a22.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
         <637ecded7b0f9_160eb329418@dwillia2-xfh.jf.intel.com.notmuch>
         <8e8f72ad5d7a3d09be32bee54e4ebb9c280610a2.camel@intel.com>
         <361875cb-e4b3-a46f-b275-6d87a98ce966@redhat.com>
In-Reply-To: <361875cb-e4b3-a46f-b275-6d87a98ce966@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7529:EE_
x-ms-office365-filtering-correlation-id: ceec3de4-94d7-46ae-8990-08dad11beb33
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OjNXIbDLvpBm96jM+CFTIctVQt+HOMsjfUYEn2troCskqvbO0OH3QPfKUbvUHXvAumP7cmsLKPOmFXHXU26+G+vEqjSEqBMZbB6t8QMkLRDROGLjVtWk4GyjdIdV+JyVEUkdU7dvXu15UFRrB2Gk2/viHaNZOL3d/uVxnlTBlGSEjojf0Zs9LFU7aYeaXHucyt3Dqi4Q2LJX0uTJas3d6jJ3kCf6N+7KgewEXvxibgaHaCVcr0Xu01L8Q5T6Y+32dv3Ne+xyU3qUopDhef8zWlCAhQGXDS3gJhb6ExnuZdl3vcJZNegDskOsmaob/NcVKXhzHJkuH9qSn7c5dVMs/UGo23vwiUvwyoCU5ux19/Bfes4+cLLqoIm5cKgmKCy7DitDE9koapPcWt2p1PiRq2r9lzp7JCCx0rAmOp0hrNfBIPF038t1wierLMeHoAbtqD7z3yCmR/DOODXzvgkBtLA+ZuQGw26xflPPm5p02wTKtSMYwwGsbOQPxKicU6qwNWtKYX3Bbcg/bey8F6j0zetvtbwHNo7mB2JbJOTFv5zgS78ZKsZIPd0IH0FthPJE8WCa45QqyHbEdIk9rDYi7wcqX2vL9O47I4tGZlMvkB25DYrEj93AAQk1kmnk79U5XQ5uhPXH/Qa+Kj62w2xHnfZey/vk2KSfnktyFH//LHhsatrXGuiIqkwq3WWddEF6XP3KgJ1s+Mb/94/OmssO7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199015)(76116006)(66946007)(4001150100001)(66556008)(66476007)(36756003)(64756008)(66446008)(41300700001)(91956017)(7416002)(8936002)(4326008)(86362001)(5660300002)(71200400001)(6512007)(110136005)(6506007)(53546011)(316002)(26005)(2616005)(83380400001)(186003)(54906003)(122000001)(38100700002)(478600001)(6486002)(38070700005)(2906002)(8676002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWVqeGhxcUJycUtjUjFlL2FtelNqUmRRcFRNRmFocXVSekRoSnN4WnZTOU04?=
 =?utf-8?B?eThTZ3JnRzJWdjZzUXQ4U1ptdUEyZklHcjk5dGhlY2lHTktGbWdzY2lQMlpX?=
 =?utf-8?B?dEdvSVBsLzgzM3pSNTFoYkZnYXJMR08vK2dPK21UbjNEczBsSkMxOWpaZEo0?=
 =?utf-8?B?NHdBcUNueCtERjBFTEkwVVd5QnhxSkh4N1BzSzRqcHIyUmo4cjlQTUozMFFo?=
 =?utf-8?B?ZkVZSUhpRHpkYnQ3NENFc1V5VHQ1R0huS3poQVpqT2k0dmt4eXp0WGl0dVNi?=
 =?utf-8?B?K2lxOW9wZnJ1NEYyM202TmtpWDN0eVpaY2QyMVFFSWI0Sk1DL1dnQy9vMzhV?=
 =?utf-8?B?NG9HcUpHYTczR25CSUR3MEYvZHNVM2h4VGt0SWlKM01QK3lHNGV4MnVTQncv?=
 =?utf-8?B?SkFSV0NSdEdzL3pDZmtLUDc5NjI1WDlzK1gvY3lWa3NNcWc1VHRsRWJvcEIr?=
 =?utf-8?B?SlUzeDBuRTBVbTI0UnYxZ0ZjTTJ0NXU0b1Nrd08rUmEwak5wN0Z3ejNpT2Vn?=
 =?utf-8?B?cFhXWm5wZWFqemdaa3dWMDcyWmZrbC9DUnQyVlRkelNFQ1NPT0w5WUc1Unho?=
 =?utf-8?B?azRBVEFOTWw5VmFXSDhyTFJOMjdEam5NVVNIcVY1SWhSaEsydjZUTGpaM3Ar?=
 =?utf-8?B?WEt6Q3JYdnJHZXVpbVpjWDB0aksxVFBMek9LT3ljMFJ5a3FrZkg2bktyREFG?=
 =?utf-8?B?dE5hL0J4Zldtc2dWWmlrS2gwL1cranlyZDdwZ1hMK1VjcngvVUZpOGdKdERZ?=
 =?utf-8?B?RkZvNmxiaW8zQkcrTGJvb2d1MFNCZ0FieEZ1QXg3NDJnQWtGRDRiK08vVUdI?=
 =?utf-8?B?OHkyeHFFOU5zZlRDMmRPY2NiZ2srNDl0T0dNdGZCdHh1Y21tSVNTOGVBUjdz?=
 =?utf-8?B?S3QrWWZMK3IwNkM1RDFLTklFNEgwazVEYVR6d3JLQnRYSTlkWTU1YmpZd0tu?=
 =?utf-8?B?N3hlaEJleVhOcHZrd3ZvcjRKdndobDN5alBGZzNPYjBXV2hNYmptTm5LZlRz?=
 =?utf-8?B?ZHFoNWtLbUN2cVljMmlqclg1N1BoSmI5OWYyRVlCb3R1NDJDOUJvUzlOaWln?=
 =?utf-8?B?ektWNlRMb2RuWklFdjBkaDBKbkl3QktZNTNRdzR2akc5WHFKcWdXY2EyMTlV?=
 =?utf-8?B?T0o0WTEzbGZQclZBd09Gb3pyNDRwVjlSalpOSGdadjRBdFJxczNvc3RlbHhl?=
 =?utf-8?B?Y1RvbmFNaHB6cmJYOHcxMzZCbnJ4R2xDMDdrVDhkbVV0NlZXbll5SXl0OTVv?=
 =?utf-8?B?ckVXY1hWZ3NWck1hM1VuRWlTeno4eU9nU3VMZ1ljaCsyK1RoanhteVdObmk5?=
 =?utf-8?B?VUNjYnZqcDk4VmtMRG00SVNiYWpYTDZFbFV2WnVEb3BPSjJHRDQ5QkVrbnpQ?=
 =?utf-8?B?QzZkVlNkOHkxTDVjckE1UUNJaVFqWFZwS3g4UXhaZGJkUkVFbTQ4N3dKbzlC?=
 =?utf-8?B?SXhySlB0ZVlSblRaMS9ZY1MrZ1MrdE1qRzhtRHJJZENVZ0QyVVBrK1lsSGFw?=
 =?utf-8?B?U2ROTnJBYmk0bVdDUWo5WDlXSnBvVmRkTkkwdGtkTGdPaXEvVks3dy9BQmd6?=
 =?utf-8?B?SXo0OXRjcVRYMGFxUVhQR2lHRkhFck1EL1l4MWJ3djVMQjR3bm83cFkwNXph?=
 =?utf-8?B?V3d4WU9XRng0am4ycTZjU3k4ZUZBUjV1MXNBRkRSRWlJWDZ1U3BnRDJ4aGZ6?=
 =?utf-8?B?VFFjeThSLzJxUkFxNlhPNEMwT1gvQVl5LzN5dG8wU3VsY2JwbHZjTXk2OGtP?=
 =?utf-8?B?YnE2NlhYS2ordk5pMlJub3R4ZjVQWHhNTXlsblJ5anhWY1VsanJPMUtFM3oy?=
 =?utf-8?B?ekw1WVhwNm1iUzUxdjNCcWN0eEpRNWFtT1AvRitlSFA2ZFlkbnp0eDJmcEVJ?=
 =?utf-8?B?dzlpVTc3NWxFK0o2eWIzS0J5b2Q3NlhJbThKL0R5MDBCc0JnbUtEdDljb3N1?=
 =?utf-8?B?d0JyODk3eHl1a0VOVE5VYUpGSUxpcm9VQ0t0b245djJlNEorSzJ5TWloNWlP?=
 =?utf-8?B?L3dwck44TDBtYkk1L1ZWU3RqcEtMZDZDdWxzb1JBcFI5TGRiZHNtTWZSYVRu?=
 =?utf-8?B?TXZrclBEeWhOdTRJNjFtbVk5emY2RkJTU2N1YzgrUTU1THBla0N4a29CVjhi?=
 =?utf-8?B?bGp3VmMrcjJpWVp0MGMxUHdPbDJVRW1ENzM5N2xlcmxNYnM2L2dXUEJncFVp?=
 =?utf-8?B?aWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6238710261AFA438FA7AF409F86A5E1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceec3de4-94d7-46ae-8990-08dad11beb33
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 08:38:26.6067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ftkw9T2gbaKozEkqvkH1YznalrMRGUp/XvwBOkHl3elkNBRwWXyUetit+p7brYd0Ic9aq+uMEnS/a12/0b9MzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7529
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIyLTExLTI1IGF0IDEwOjI4ICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMjQuMTEuMjIgMTA6MDYsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gV2VkLCAy
MDIyLTExLTIzIGF0IDE3OjUwIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+ID4gPiA+ICAg
IA0KPiA+ID4gPiBAQCAtOTY4LDYgKzk2OSwxNSBAQCBpbnQgYXJjaF9hZGRfbWVtb3J5KGludCBu
aWQsIHU2NCBzdGFydCwgdTY0IHNpemUsDQo+ID4gPiA+ICDCoMKgCXVuc2lnbmVkIGxvbmcgc3Rh
cnRfcGZuID0gc3RhcnQgPj4gUEFHRV9TSElGVDsNCj4gPiA+ID4gIMKgwqAJdW5zaWduZWQgbG9u
ZyBucl9wYWdlcyA9IHNpemUgPj4gUEFHRV9TSElGVDsNCj4gPiA+ID4gICAgDQo+ID4gPiA+ICsJ
LyoNCj4gPiA+ID4gKwkgKiBGb3Igbm93IGlmIFREWCBpcyBlbmFibGVkLCBhbGwgcGFnZXMgaW4g
dGhlIHBhZ2UgYWxsb2NhdG9yDQo+ID4gPiA+ICsJICogbXVzdCBiZSBURFggbWVtb3J5LCB3aGlj
aCBpcyBhIGZpeGVkIHNldCBvZiBtZW1vcnkgcmVnaW9ucw0KPiA+ID4gPiArCSAqIHRoYXQgYXJl
IHBhc3NlZCB0byB0aGUgVERYIG1vZHVsZS7CoCBSZWplY3QgdGhlIG5ldyByZWdpb24NCj4gPiA+
ID4gKwkgKiBpZiBpdCBpcyBub3QgVERYIG1lbW9yeSB0byBndWFyYW50ZWUgYWJvdmUgaXMgdHJ1
ZS4NCj4gPiA+ID4gKwkgKi8NCj4gPiA+ID4gKwlpZiAoIXRkeF9jY19tZW1vcnlfY29tcGF0aWJs
ZShzdGFydF9wZm4sIHN0YXJ0X3BmbiArIG5yX3BhZ2VzKSkNCj4gPiA+ID4gKwkJcmV0dXJuIC1F
SU5WQUw7DQo+ID4gPiANCj4gPiA+IGFyY2hfYWRkX21lbW9yeSgpIGRvZXMgbm90IGFkZCBtZW1v
cnkgdG8gdGhlIHBhZ2UgYWxsb2NhdG9yLsKgIEZvcg0KPiA+ID4gZXhhbXBsZSwgbWVtcmVtYXBf
cGFnZXMoKSB1c2VzIGFyY2hfYWRkX21lbW9yeSgpIGFuZCBleHBsaWNpdGx5IGRvZXMgbm90DQo+
ID4gPiByZWxlYXNlIHRoZSBtZW1vcnkgdG8gdGhlIHBhZ2UgYWxsb2NhdG9yLg0KPiA+IA0KPiA+
IEluZGVlZC4gIFNvcnJ5IEkgbWlzc2VkIHRoaXMuDQo+ID4gDQo+ID4gPiBUaGlzIGNoZWNrIGJl
bG9uZ3MgaW4NCj4gPiA+IGFkZF9tZW1vcnlfcmVzb3VyY2UoKSB0byBwcmV2ZW50IG5ldyBtZW1v
cnkgdGhhdCB2aW9sYXRlcyBURFggZnJvbSBiZWluZw0KPiA+ID4gb25saW5lZC4NCj4gPiANCj4g
PiBUaGlzIHdvdWxkIHJlcXVpcmUgYWRkaW5nIGFub3RoZXIgJ2FyY2hfY2NfbWVtb3J5X2NvbXBh
dGlibGUoKScgdG8gdGhlIGNvbW1vbg0KPiA+IGFkZF9tZW1vcnlfcmVzb3VyY2UoKSAoSSBhY3R1
YWxseSBsb25nIHRpbWUgYWdvIGhhZCBzdWNoIHBhdGNoIHRvIHdvcmsgd2l0aCB0aGUNCj4gPiBt
ZW1yZW1hcF9wYWdlcygpIHlvdSBtZW50aW9uZWQgYWJvdmUpLg0KPiA+IA0KPiA+IEhvdyBhYm91
dCBhZGRpbmcgYSBtZW1vcnlfbm90aWZpZXIgdG8gdGhlIFREWCBjb2RlLCBhbmQgcmVqZWN0IG9u
bGluZSBvZiBURFgNCj4gPiBpbmNvbXBhdGlibGUgbWVtb3J5IChzb21ldGhpbmcgbGlrZSBiZWxv
dyk/ICBUaGUgYmVuZWZpdCBpcyB0aGlzIGlzIFREWCBjb2RlDQo+ID4gc2VsZiBjb250YWluZWQg
YW5kIHdvbid0IHBvbGx1dGUgdGhlIGNvbW1vbiBtbSBjb2RlOg0KPiA+IA0KPiA+ICtzdGF0aWMg
aW50IHRkeF9tZW1vcnlfbm90aWZpZXIoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpuYiwNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBhY3Rpb24sIHZvaWQg
KnYpDQo+ID4gK3sNCj4gPiArICAgICAgIHN0cnVjdCBtZW1vcnlfbm90aWZ5ICptbiA9IHY7DQo+
ID4gKw0KPiA+ICsgICAgICAgaWYgKGFjdGlvbiAhPSBNRU1fR09JTkdfT05MSU5FKQ0KPiA+ICsg
ICAgICAgICAgICAgICByZXR1cm4gTk9USUZZX09LOw0KPiA+ICsNCj4gPiArICAgICAgIC8qDQo+
ID4gKyAgICAgICAgKiBOb3QgYWxsIG1lbW9yeSBpcyBjb21wYXRpYmxlIHdpdGggVERYLiAgUmVq
ZWN0DQo+ID4gKyAgICAgICAgKiBvbmxpbmUgb2YgYW55IGluY29tcGF0aWJsZSBtZW1vcnkuDQo+
ID4gKyAgICAgICAgKi8NCj4gPiArICAgICAgIHJldHVybiB0ZHhfY2NfbWVtb3J5X2NvbXBhdGli
bGUobW4tPnN0YXJ0X3BmbiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBtbi0+c3RhcnRf
cGZuICsgbW4tPm5yX3BhZ2VzKSA/IE5PVElGWV9PSyA6IE5PVElGWV9CQUQ7DQo+ID4gK30NCj4g
PiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgdGR4X21lbW9yeV9uYiA9IHsN
Cj4gPiArICAgICAgIC5ub3RpZmllcl9jYWxsID0gdGR4X21lbW9yeV9ub3RpZmllciwNCj4gPiAr
fTsNCj4gDQo+IFdpdGggbWhwX21lbW1hcF9vbl9tZW1vcnkoKSBzb21lIG1lbW9yeSBtaWdodCBh
bHJlYWR5IGJlIHRvdWNoZWQgZHVyaW5nIA0KPiBhZGRfbWVtb3J5KCkgKGJlY2F1c2UgcGFydCBv
ZiB0aGUgaG90cGx1ZyBtZW1vcnkgaXMgdXNlZCBmb3IgaG9sZGluZyB0aGUgDQo+IG1lbW1hcCks
IG5vdCB3aGVuIGFjdHVhbGx5IG9ubGluaW5nIG1lbW9yeS4gU28gaW4gdGhhdCBjYXNlLCB0aGlz
IHdvdWxkIA0KPiBiZSB0b28gbGF0ZS4NCg0KSGkgRGF2aWQsDQoNClRoYW5rcyBmb3IgdGhlIHJl
dmlldyENCg0KUmlnaHQuIFRoZSBtZW1tYXAgcGFnZXMgYXJlIGFkZGVkIHRvIHRoZSB6b25lIGJl
Zm9yZSBvbmxpbmVfcGFnZXMoKSwgYnV0IElJVUMNCnRob3NlIG1lbW1hcCBwYWdlcyB3aWxsIG5l
dmVyIGJlIGZyZWUgcGFnZXMgdGh1cyB3b24ndCBiZSBhbGxvY2F0ZWQgYnkgdGhlIHBhZ2UNCmFs
bG9jYXRvciwgY29ycmVjdD8gIFRoZXJlZm9yZSBpbiBwcmFjdGljZSB0aGVyZSB3b24ndCBiZSBw
cm9ibGVtIGV2ZW4gdGhleSBhcmUNCm5vdCBURFggY29tcGF0aWJsZSBtZW1vcnkuDQoNCj4gDQo+
IGFkZF9tZW1vcnlfcmVzb3VyY2UoKSBzb3VuZHMgYmV0dGVyLCBldmVuIHRob3VnaCBJIGRpc2d1
c3Qgc3VjaCBURFggDQo+IHNwZWNpYWwgaGFuZGxpbmcgaW4gY29tbW9uIGNvZGUuDQo+IA0KDQpH
aXZlbiBhYm92ZSwgZG8geW91IHN0aWxsIHByZWZlciBjaGFuZ2luZyBhZGRfbWVtb3J5X3Jlc291
cmNlKCk/ICBJZiBzbyBJJ2xsDQpjaGFuZ2UgdG8gbW9kaWZ5IGFkZF9tZW1vcnlfcmVzb3VyY2Uo
KS4NCg==
