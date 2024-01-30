Return-Path: <kvm+bounces-7479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32DBE84276B
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 16:01:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE4BA2860B3
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 15:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4E0823AA;
	Tue, 30 Jan 2024 15:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AfD3zule"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67637CF1B;
	Tue, 30 Jan 2024 15:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706626850; cv=fail; b=XTWfrHnMgo1uCAVPLZuKSCc4tDZKqECFLor1H30GOkhcigYffMdZMkRDhUtvqUMDU/RukRlAfZUql+Ypq9pJSSzPJLTmOj4oP3ZcHHLSW2Za7cAAk+oxycThHVs6e3qM31lLDUradMG6Lxl0obaW8cPU67AaKrudXYpZ0ml5ATg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706626850; c=relaxed/simple;
	bh=EGRWv9x0FpRqIKd9H46FZBkPHDQUBBBaKBApjMDPMHQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RpmUC0rL0ozxnIOJc9cRLXqn+IuUfjKsdaycfBzkgLn2MUFyJtg848+6i21DsW1Mo8Otgzy4FKZ1ogbeFMQz5rAT/HvP/icV8shaSE57U82+TXazKB2BzhEIJ9G4yGshgw6kIFC3GhUXoIWUf0Ua7gwZzD+XfPdoOwWulgtkB2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AfD3zule; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706626849; x=1738162849;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EGRWv9x0FpRqIKd9H46FZBkPHDQUBBBaKBApjMDPMHQ=;
  b=AfD3zuleOApQP/T9RDiCR5AsIChO7m+yVwK3j2hYNiq+6en3qrcrLrLS
   rvGc22If//rubfU4hPHI5xtAaNDLaLIQEjFe7qKdGR3wOkEtJueidDipp
   xR7ZF7pE4MaFJNNumqtDAYewzvS/0reYFxqjPTZz3Dmnc4Ft+lBHRVZa7
   Q6Wiy/CNLFGW1q+8RxNTRlQNuz54QIMhGs3GQ/xo6HMrfiLn/3wibRuhj
   sm/2Pp1YvyT2O4/tuwxFn+YiS7KHSVlK8ZFCqf/9IzdN46Zswjs8GVMxy
   s3iPtjnUWwDsKezOhERNLNVFMUfYnWrjxzyxfjZnvuctQI43XtD7SbHRK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="24773960"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="24773960"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 07:00:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="29933386"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jan 2024 07:00:47 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 07:00:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 07:00:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 30 Jan 2024 07:00:47 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Jan 2024 07:00:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fw5ynTvGBmqf67Tn0FQbSRFshb1AO3LfIKbkQYsxPPKozF2slG/tTnES8RglcVvIBdwpUaBQe36dbS7xxTKoCb6AK7/ihNePGWGnXhCFMPJutE8l00xwG/NKuzhE+/KnI46Fph7tZ6onrqWt1/CgSPqjgdyAcwbhMRJgLHXzfUtAQBIbXR6KLomZVxlO910Bt2I6hmf84D4ZG7QlDJ5F7KDznO3a7fG8Vwvo+nytXz+BkWiQPSgQXBR4Rc4zxyXW5AcxcGxIuZdXQzz+GUWhrjp3PR3IRjE4hyFs7tyBid7j0oWr5dlkA8pUkLZAoDHkYx48rVgr2MEZIkuFOdIPPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGRWv9x0FpRqIKd9H46FZBkPHDQUBBBaKBApjMDPMHQ=;
 b=EOdM+CdpmbUv8amAu9svdYvb136BG2sUybozSNowGRKKiB2w2+zkOQksC4T4p+iSTx1M3GoNIwc7OeJh+T6D2oHZNdR116bVFYPPOV6Daqc2Kv+lcz4K3YsUm2U9q8n7vXnhAoZcbsFbwFPtEn99wmwsh/PQlE3nVPkSqp3SwZvnmZvbJv9DXOMv9Ypw/YXecMJ+mkk9+k7T36fn8lu+d3N9OYH+iuP+gqQsH3JOW/fZ6sM86NwYSM540wjd1iD9DBByzu971gHL2dhtZojaKKMzzthvbXuysp0WcVU6G7g4IndcW2uei2zp1sNGcVpIo50EhnFd4ENTdxv6HWYjFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM8PR11MB5623.namprd11.prod.outlook.com (2603:10b6:8:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Tue, 30 Jan
 2024 15:00:44 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 15:00:44 +0000
Message-ID: <c41143ae-4e1f-4190-bbb4-5cf0d9ebdcef@intel.com>
Date: Tue, 30 Jan 2024 23:00:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/27] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Content-Language: en-US
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>,
	"john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-6-weijiang.yang@intel.com>
 <0221fdbd07cd35f954faa466a851cb063db57d03.camel@intel.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <0221fdbd07cd35f954faa466a851cb063db57d03.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM8PR11MB5623:EE_
X-MS-Office365-Filtering-Correlation-Id: b5c23a9d-cec9-4af4-3669-08dc21a43bd5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FmsmSMk2pYUVs2yde/V4sFQgX7S6Gnd7YRqKlUA3WOjYgDFHiN/TLB+k5KuM/+xUdZnKSDUQuN857z9KR6J7LEyzJeCJLXKiG0skeO3QnTI2+ng2lUInRVLbKPZhu4404Sew4VNjDWEHhsFqziVJ4/4qFwXMoLUdXWELqrABY97y2C05oE7155hacQG4NM5qNWon39J8CFq7f0p0aGXt3j2sFSH13SPDIlCSp9FOFIDdenOVK37dppQLYNShs4NtpGOzcvgWGiCPjihu400YEwj1pXBRDDXphN6fw7llS5A9MqqBbUGgOdhmUn6NE8AACNiacU/tdILomzYPnPd/j7F8bHrvNivaMx2BI/lLahXUfkZmTjrgqGOkbPIk8yWQ2V0rNN/S6nOfTZtSMzWkYWuL1fPpTCQhh57/hSdILhMujcSraIv2/QVMYbcupnVcspg2CxtEsC8zllWdYHuAVezZ+umdL6Hy6/c3kRtoT5FKfaMUmnc4g+w7g3FedgNj4haWSPNlK8j2Yp9BNxTr2607M4j1Z/Boqwz7Rev1DWTe49Emf7AR8UirECkVBwzUFn57RhFqPFGopp5JXAvMtR34I9BBzegrp880C8fTsZArKLvjPQgNcia7TEbAmoUCcBbEdXLZcaB+y8u4kHVWsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(366004)(376002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(26005)(31686004)(6512007)(6506007)(6666004)(53546011)(2616005)(82960400001)(38100700002)(86362001)(36756003)(31696002)(4744005)(6486002)(4326008)(478600001)(2906002)(83380400001)(5660300002)(54906003)(6862004)(66476007)(66556008)(6636002)(316002)(41300700001)(8936002)(66946007)(8676002)(37006003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXNNWUZMSC9tRTJsZ2MyQzJkTUV0SG9HVmprWHFBK2E2VjZucm9lcmdITEIw?=
 =?utf-8?B?SDhmdkE2bUFHUDJDeGs1V3BmcjV6WFJtS001U2hOOE9aYmJnWGVyek1JTkxE?=
 =?utf-8?B?bmVzMUdaYmhhNE0rSDVtcWQraGZKb3pFMjV5c2lTT3YxbERwQ2hEdHRtbGhW?=
 =?utf-8?B?TUhOK0pZb2RRNStzdC9YK2ZWalRFOHQ4N1lyblQvQTFoVFVjTmN0c1Y3emw1?=
 =?utf-8?B?VGZ5THM1Q1RVbjNCK0xQamY1SGlxcmRZckdjODMzNXgzTkZEdjMrVWRuRXJq?=
 =?utf-8?B?SW05Uld5eER2Vk9ISEV6c2l1cWljamYzSEdxWjBCSnhBS1hXWll3VnJrR1d2?=
 =?utf-8?B?UU9HYVlyS1ozNkRVOXN4WmlVY1cwRXBRaGNqWTErY2k3ZmxRZ2VXc3hodDVy?=
 =?utf-8?B?RUJxQzRmTzNtK2sxQWRaTHgvTWo4UnRLOFd1QXY5VUlxcU5tRmp3a0EzQ0tj?=
 =?utf-8?B?dSswT0JRemN5eURBUkZtRnVvNDR1VVdDdGJSVFlMQUtJMlNiT2hVVm9McUtG?=
 =?utf-8?B?VmhZbHM0dUxnYUFjb0RXUVRjdERDcUN2WDJ6NjY0Zkd5MkdNSEY4QmpsV3NC?=
 =?utf-8?B?SGczUlhCcVdnWkNCVERqM3RhRjNLN2huMngvYWRLSlJBM3V2dEFuNC9TdFFZ?=
 =?utf-8?B?aTU3MXVyZ2hySzYyK2F0emo4enZRV0h1ZGpFdGdOYWxxWXVGcXZmbmsrOWV2?=
 =?utf-8?B?Q0N6QUwvRUpENVZoeGR2VjNwdnl4bWNXTXkyYXJ3RDZ1bUZJWGpCajE3QjFF?=
 =?utf-8?B?T1R4VW4zY2FleXVYU21taGdKUzgramtXMEZJbnNuM2RQK24xclRULyt5bWJz?=
 =?utf-8?B?bFVLT2VwbWdxMlZlK05wTDhOUi8vakViNkFiY1VoekdnTENoNW1rS1JmcWJp?=
 =?utf-8?B?ZFJlU0grcmx6THpweHJZZVhUSFp6aEw2TlQ0R204Z2F0TDlWcTkzUEYyc0xo?=
 =?utf-8?B?NkI1VzM0K2NDQytsRnA2SHZWNWxaQTdtaXo0d1R5N0p0N3dRdXhFOFZja2wx?=
 =?utf-8?B?NGsvRE4zVlJmSlRaVk0ydjcyYWlDNUNFakdkRHdmOVlQUnJDazdTSXlFUUgx?=
 =?utf-8?B?ZjYyaGIvOE45dTVraEZSV0g5Unk2OTBQS0I4VXFya1g3eHFtQ2VIZm1XbWZ6?=
 =?utf-8?B?Z2pmeWQ4dFg0LzRIVWN6NnFwUE04T091S3F1YkdjVHIzbkppZWgwQ01paWl0?=
 =?utf-8?B?amY0dGVENHVOdGg4NVpPYVAzbmNFakZqYXlrT0VVY3hkVU1PVGdBZ256NUdu?=
 =?utf-8?B?R0p3MVE3OXo0bEoxczJTZUV5SkxSYXJtbUJVK0JwblZPR0c3bEMyNWphbjlL?=
 =?utf-8?B?dkMwemdkQ2hVaUNFVHBjeTVyblgzOUtWMTh3S28xSlhMaUpGRmtaVG1reGxq?=
 =?utf-8?B?OERMdmJBbFJ2Z3FSdTNSelhHdURBZDJVdnJKYU0wdG1COFlPNTArK1ZXYXlr?=
 =?utf-8?B?VHZtVGpLU3BGN0VDdFRGUFJhYktCczVNNCthSGZnZ3Fxdjg4VTQ0bVJvOW1P?=
 =?utf-8?B?YUJENllEWG5OVEVoS0doK0F0VG9XR05rZjEzRnp1OTdmMmlpY25QWVBZUW9B?=
 =?utf-8?B?SHg5M1FOZmVFQ1pKMmp6OVJRR21vbzhiVnpqMUt1bi9zYWhOSGE5Q21RS3Zs?=
 =?utf-8?B?TVByQm5xUHJENElDL2xmR2RmQ2E3RGdpMnczV084elFvWnZuRnVGbFA2Zzg3?=
 =?utf-8?B?NmU0UHE4c09ZeUhRNytpUEg3ZStBdGYxVFpPY051eXRIdXBlMjVyQ3VMR3Aw?=
 =?utf-8?B?STVMZUl5LzNvdGtjRTkxWWwveE8yQXowU2N5NXFQYkJmRkJKMElEbU1nakJL?=
 =?utf-8?B?ODh1SVBHT3JGcUJWUlRlRE1HM01qeFVkWi9SbFRqbmRhbDhMUlNyOWFxbURP?=
 =?utf-8?B?eElGYnpDdERXS3VnNjZwNElBNTFVN09jV0JjUW5kcDJsYUQ0OHpjcEl2K0JW?=
 =?utf-8?B?RVhsMGcvOE9WZFJjMnIvVTV2andLUW5hZjJSY0hwUUg5dkdaTkhNV3dJdG05?=
 =?utf-8?B?TUNwYlFTb21vRlQxeVduU3hRQXdMelhFclJiR3FwMG1hbnZ3Q0pHYWxmQXpT?=
 =?utf-8?B?anFWaGhxNFRQeXJ4a21sc1g5OUtJOUJOUkFSak42SVhVaitXRnZmdktTMHdK?=
 =?utf-8?B?RVc1UnRiMDNEcUdkTmJMSXYwZmZaZjNETWt0U1FpOThrR1o4djFmRTlWQjUr?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c23a9d-cec9-4af4-3669-08dc21a43bd5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 15:00:44.4879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5jaj/WEAlGcofVjwq657KXp5Euu1cl2SQmz92wFkibBzmES1fjYxosv02O5beT8Wl1808xTAQ/bjdMqK9346aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5623
X-OriginatorOrg: intel.com

On 1/30/2024 9:29 AM, Edgecombe, Rick P wrote:
> On Tue, 2024-01-23 at 18:41 -0800, Yang Weijiang wrote:
>> Define new fpu_guest_cfg to hold all guest FPU settings so that it
>> can
>> differ from generic kernel FPU settings, e.g., enabling CET
>> supervisor
>> xstate by default for guest fpstate while it's remained disabled in
>> kernel FPU config.
>>
>> The kernel dynamic xfeatures are specifically used by guest fpstate
>> now,
>> add the mask for guest fpstate so that guest_perm.__state_permit ==
> I think you mean 'guest_perm.__state_perm'.

Yes, will change it, thanks!

>
> Otherwise:
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>
>


