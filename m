Return-Path: <kvm+bounces-2582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E29B7FB33E
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:53:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9110E1C20BCB
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4818914AA5;
	Tue, 28 Nov 2023 07:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RY++N7rC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16FFC1;
	Mon, 27 Nov 2023 23:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701157991; x=1732693991;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CA3JZHXRUSQ7IsjY2AUyYG6dQzmjZSNxtWau+f2uEbw=;
  b=RY++N7rCK4IRK/9MDdKG6rZ6bGXZRWtZn5O4/0vM8tLqnTMgdXLauoWk
   /HMSRuKBm0+OpQQoVrRC1Ko7HavPUp/pRWGQvd+c8XvZBjzo+Xa0NTe2o
   Yv4emB302WWmpDD01pNCon5AycemUZvuN5MDY1w7msw+ebporZl5ieTPC
   me3oFGrRBoVQNDfuh3y8LZKfVBmbHR+AB9rzYShXUgqlfu1Cs1ombI2+U
   UZyeVC7I0KCD0wtrOy8rm+8xhD826FXJaY1c0wvdv0TiNejotz8xJ0MT4
   MWwr4LtfFOTVxmjfC/uJk9hspGIwzNywa+Rz2I7LVzGmyw2xmLckOxPm8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="6131105"
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="6131105"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 23:53:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="797505278"
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="797505278"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 23:53:04 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 23:53:04 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 23:53:04 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 23:53:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgcIAvgxbFj3zGWVqGvYGp9t5mT5x4eHezfbt7sFpIjZpRbQkAIXbyZCsXznHfj+Av1l7Vz2K1h2xY9LE8pkz9G7AoHwMLzkfpQMJJDDgur2OLtOlujt5gr9yAO+9GhqUkEEOzltBKNUdPPOSRtCj5QOmpBQZbmazcWmXO8vvZ1QH+0urb/rZl2YhFCtowIGey2O91a4iyzIVJYbi4a6nRiyPYQrvjI/07ACNTdZKVxiUtQqhi1o4o6W/oKFAvd4JKCtdwihgpszY+UewHktVmVDFibQH6sfrV2KlKJFzGblTwzwQgExhSKaOe4k7wQXdBJRTY1lkHIlZ7Gebn3fjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LgGTavvJhGbzq/GyBTCH2MS79zeUYjl301Dh9EmkJeA=;
 b=IjvevF1cu5ySe+zpyMTT+FNqyLYgvXCzYsEceElOQnPj043lDpV77LJL8Pnf7sL9JE3270uuQVOf/UlyAjyb97WPS5lZRra+5c5Lw4T+KziXIND2LYfU9RjOdzX2o9HpzA0BaCYnnTFYSlHzOXemO0IKw9mcJ9xI2x+jiVVLzRma9U6WUOMtsaDKrfzY0JaPKD+dmG+76zh9zHrCfaGWwCUWdINmi9nhRJO6CvNwVO+r1kFvRlzsu1/e2gqcSemYr59AVsWzG2m4FjSIH6kAcmVGYdJLfTQVrvU40WCIKOop1yIgrlgXgrzPaK4dg6H0hzDtdFAaylEkdsDh7V5zoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7603.namprd11.prod.outlook.com (2603:10b6:806:32b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Tue, 28 Nov
 2023 07:53:02 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 07:53:01 +0000
Message-ID: <d47cfd3c-2b86-4ae2-b1f7-c4a567b20943@intel.com>
Date: Tue, 28 Nov 2023 15:52:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
Content-Language: en-US
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "Gao, Chao"
	<chao.gao@intel.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-3-weijiang.yang@intel.com>
 <29d7597cfccb7cab9717d973905a8285873bb92c.camel@intel.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <29d7597cfccb7cab9717d973905a8285873bb92c.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0042.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7603:EE_
X-MS-Office365-Filtering-Correlation-Id: 82700c56-ed89-4599-d273-08dbefe70b0c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gi+oyxKJ+mLpGZl6epUbwSq06VBgPHaqQ4DqtQ63npV4MuiKIco9TGnjA45ktZr/oqv0UaUZZnMBIbewODxNw69gCgV98NlhPe08FOTgZNaGKkZKOMo8Rh06oil2gCHBhf1kGGG4b4ehCnzQpbqs8Yb+3tEeG8dfJF4VHarOYOwuQX4VU9UIytRwG/qicwY8z8QwmfLymsjVB5AdbZKhYL6b0FlRFSzRpU2BnpWQ+DCaSqA/77wVBaKyCw+rWDkeCPaZkJEL96WCzYn1w0nDLG6rBulT8fTp52DkqAmcP9jV3MYCHBpAXfwz5/XDxARfHnhQ2dRZX8VpdFis3usQaHey5nTjRrjoUt6VzByJc1l5xQNLI9kBrWCCq/GgfPJP6sB4cLWh0+lxft71d3RiMtL0uch5te2Iq22nrTfv/x13vxHRKoQ+wcEStoqESrzYWjlz5hxm69p8eysGupVRbLsA8zPq5Y+kjZjv2sWFoB/vkD5xWr0TlKYb15vGGblyfFa0zobNJVJFKisO8AQC0HGns+VAfxr26yWOyI9JS56yC1GVeTaenSX3rRUAqaeQHDkcNOu/97SG/x6FZJ/v9eViDq0Idyasz7yYjc5mykxXH9Y04zG9RigrW9Mba9cqicGxugRvtp0++rA053hHaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(366004)(346002)(396003)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(6506007)(6666004)(31696002)(86362001)(31686004)(41300700001)(82960400001)(558084003)(36756003)(6486002)(53546011)(478600001)(6512007)(26005)(2616005)(5660300002)(54906003)(6636002)(316002)(37006003)(66946007)(66476007)(66556008)(6862004)(38100700002)(2906002)(4001150100001)(4326008)(8936002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmVja1V1SGJTSzJ1VDlFZXpMZHlxcGNqbHAyQTJxK3NTc3hWTWN3K3U1QVow?=
 =?utf-8?B?Y0o1RVpDdCtOYmVtK0ZrTnFvdWdLcEJKaVhKQ3FQVGxmOHplV05UaGowZWJz?=
 =?utf-8?B?Y0lEdHVMUWFJb1ZPemZiVG5uSXlYQlc4Q2pjZWRFR0hwMWpOVzY0V0lkQzRU?=
 =?utf-8?B?UDdwdGVoVEZXazZKRStUWEZqeDVWYU9ZS3NSKzZqM1VnekdrSjRUcEJYNTZC?=
 =?utf-8?B?WU4rM0ZwUzhFVU9TNzBsOHdNR1E5SXRUOVdDbVh2VGFISXFoMldPL3ZUV0gy?=
 =?utf-8?B?Z0FsK0tCZFJ1a2V0dXVnYVhxN0VxMzVxcjZ1WWVobzVkaGVzWmp6ajRYUCtQ?=
 =?utf-8?B?UWlVS0FjaysvVmJQR2dlS08vTS9oa1Iwa0xUL1F6bkozUXVQYlFBam1rUzE5?=
 =?utf-8?B?bWNXSVd0V0xuaWZKRU5BTGZRaWdOeXlSSDRnUWlLUGtkVEE0M3c3NEhjclFB?=
 =?utf-8?B?MmJYd3NPMi9zV3lCOXF0ZGlhbzJjdmd6Rmp2d3IxNlBjT2ZDR0luZGlieExO?=
 =?utf-8?B?d2xxWHdnQndvQlU0RlhGZnliMUNURWdqK3lMbkp5Nm04L1EreFI1aVNrNTIv?=
 =?utf-8?B?OVdnVVZHQ1A3eStrYzFQS0ZtTGp0ay9XUUUxRkw5THFvdWMyaTJReUNSYzFU?=
 =?utf-8?B?Yjl1NmZmVHdxRWw3RXF4M2pCYldZUnRBazBIcW1OaWNBMnFtb0RPMmZUbU1H?=
 =?utf-8?B?cU5iYm1pclNMTVFVaWVvekNVcVNHSnAvTit4QldENUhLM0FBWDhoZjZhOUIw?=
 =?utf-8?B?YXZJNXBtTlZqOWprKzZBU0tlNnRWTkZHUWg0dk1oWXV2K2syUnpkNXd6aUp1?=
 =?utf-8?B?NVI3SkxkQnJiT0RkaWhpYW1LdmJ2ZFd6SnV1am1HdVRuZGIrM25helZkUXNa?=
 =?utf-8?B?S3U2bldWZ2ZRRVJkbXF0TTdTb1lPRmVHRmpPcjBjRmcybDY4RUpzL2tMWko3?=
 =?utf-8?B?YzlHU3RkQk9jZVZGVlpBcFd2eDg5VE96MTBhMEltbkxtaU5tWUVFTkp6OWRE?=
 =?utf-8?B?eG9SNW5WRzZxeU9hVUk5aFptSjFidWdiT29TZFR5azFpQTJKa0RWbXIzaDBC?=
 =?utf-8?B?dWxoZlB1KzlpQnhnMEppUzJVRWwzd2tNWEUvYjcyMjFJVkVqTXJrWlRiNkYz?=
 =?utf-8?B?OFRybXVRV3NuU3BaRVQ0bXNScms3R3dhdzBpMTlaelVoblJkUXlhT24wUVEw?=
 =?utf-8?B?aXVYbFVCeUR3NzhxeG1FTm9lMHdIZ29zSHBTUjBpR1BkVzg3SHlDcjNaZGNt?=
 =?utf-8?B?clUybG53U3g1L01KLzU3dFNLTE5QVnN3a0NzeXkwRWJxblFKeVZFc2hLNVlk?=
 =?utf-8?B?TEVRdW0yNjBkbGpqb29lV0JGYWxOTVVRRUZpdVJDMERQZEVXUmp1elUwVDhY?=
 =?utf-8?B?b0YweW1tWmhpUzZHbGNkV3Y3cjhoWWwyOUt6TUw5RG9DNm53bnhhZXdReWVt?=
 =?utf-8?B?dHBXcWl6SU9tZHYvaVdKZEtjVnl5Y05pcjN0UWFNdnI1UjR3L3IzZGtFcndO?=
 =?utf-8?B?VHJLYm1zd2JXSjlPSi9qWTREckJpblVxK3VDNHlia3F4MHZIUjRsNGQ5cVJM?=
 =?utf-8?B?WlEya0sxNTU5cTlRNTJ1ZTNMU0lSSzVLZmtLMWE1azNEQll6dlVhSWJtOFhh?=
 =?utf-8?B?cFhzSlhuOUQyQUVzVXVuckZLYjlabHJMNDdjTlRvZTdwV3RRTHdxL2NKRS9h?=
 =?utf-8?B?SG8zUEJhWE1GVm1XVnk5ZFFzblkrUHZ0R0J3Y3JSMGxRZWNndzlodmZZaWl0?=
 =?utf-8?B?c3VIOFdmZGVUYUI4ZVQzMUpCZVREL21MUmFFWEdvTnpaS0VYcU82WEppN3Bi?=
 =?utf-8?B?OUIwcWQ2bW12THlMOGE0dmZ5RzFtRkMxYllEWlVUQU9KVFc4azY5cm9BNXpO?=
 =?utf-8?B?dG9oa0ZIYUJFbnIzWkpPdGpUaXgwSUw0NHRoUjh4MDhaRWFNT1hhOXJwUTJi?=
 =?utf-8?B?WmxOdTlTQmVoSVprMHlRWTgvaDZYeGV4TXZ4SGtXNCtUbUVtSFlFK2xYTlRW?=
 =?utf-8?B?SzhCOExzMGFRWUdUcDBvKzdsbERKRlFBTHF6aGs2S2J1K0FWaHBhVFRmSkw3?=
 =?utf-8?B?NXVTd3BQaDY5OWtVbThVRXpERjdYSm1YSm8wWTlUbkRueHNNekhERExCSkN3?=
 =?utf-8?B?dkJMSll2ZjVvc1M4Y1QxYnljcWpiTjRRSFNOQnVVQnVUKzRLWDYwUmh6dlBP?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82700c56-ed89-4599-d273-08dbefe70b0c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 07:53:00.7862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iXdepfYVp9DSfGibza41HaRogl95K3BuqyaqHnVBdMGLQXXd2YnQTz2T/hKJgWRkSyRRra9G0MN3X3tKqxN1QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7603
X-OriginatorOrg: intel.com

On 11/28/2023 9:31 AM, Edgecombe, Rick P wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> settings,in real world the case is rare. In other words, the exitings
>                                                                ^existing

Thank you! :-)



