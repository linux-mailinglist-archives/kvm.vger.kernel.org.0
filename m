Return-Path: <kvm+bounces-2469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E757F9822
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:06:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C9EA280E39
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5697053AF;
	Mon, 27 Nov 2023 04:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mLKTkkFE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5265318A;
	Sun, 26 Nov 2023 20:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701057996; x=1732593996;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zLVwSIHOj4u0Tshm+Ry/kQJ+YurZ1b4eoSnDsZTd2/M=;
  b=mLKTkkFEY+/4K12qkdA6+dmJwG53GpxLZOY8fjqBTa2bZerT8OZjc5gO
   VW6pBd+CVjlUVtxcIOMFWevQa4A5YRAv3Ke5giMHqRjWvp+OAEwhn0FF1
   epwjvt7L1Te8fkjZIQT/0miBoMkM5B/i6wNtkumM2r5ONZr9h6Ua+ZEHS
   HPKuVkJCbR7yQFViWdRAL+LpCpvl9xE93ngcPe/FLfJwPlH4Aq+Wbrqmn
   djFWQhvmZRob6v+xn/5x1AQvWbMh8Jzrt77SLwb+R+/Bv3nuYg1WLHyD0
   U6tbX5ptql3T2XAMuojOkXPx/9somM4ZaFG8PfTC9AGjCoB4zoFC0KQkn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10906"; a="389778028"
X-IronPort-AV: E=Sophos;i="6.04,229,1695711600"; 
   d="scan'208";a="389778028"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2023 20:06:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10906"; a="911984096"
X-IronPort-AV: E=Sophos;i="6.04,229,1695711600"; 
   d="scan'208";a="911984096"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2023 20:06:33 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Sun, 26 Nov 2023 20:06:33 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Sun, 26 Nov 2023 20:06:33 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Sun, 26 Nov 2023 20:06:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bcx+2+xKAYxv7OMvAdrzFeILJnBGDMopMFK9ylQAe4XYbXet8xRZZdOo6PqtRQ/7S4bnpUuINrNzPSqpyL3qadecALDEJMQXggncZKwb2xH+Bm967Fc5MpHqfegtufJ/3b89qqZJBMmMDk2PqU/U0Oi6r58/99Kox2lobDCaT4GCIH9n3C7g9e4epmVV542yKOo411JrtnhvWN+S0CZowE3DyOWFVsO5z4qhp12MHmnIKXaP73n35VMB+jLnkEpgWWwxRbL5Rm6AxJqf1IB6XeCRYM4RwGee9O5eYG6ojiB+eWIhF/ZaDfPaCZt7Jjcx/xw9e+B34QtG2x13heIsuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zLVwSIHOj4u0Tshm+Ry/kQJ+YurZ1b4eoSnDsZTd2/M=;
 b=dvDHQdM5Ko46d1a0G1A/UPFIzVmeefxuLaO9AsciCo40gqITM04OuOdxN84Y0Gq99Zy3ULxLRaqTpWmvSUmCRm8u4dfssofmHsQ6wcmhAgRTtLxcykoCSWytdsGrVycj9ziikNl35ci60fnNZoh10qmalyXS95jilTKMLIjgGTyLxlkDWN6hn6vaUKUeixu+l+w8a/rA0v3zCwkJ9FlcJmodE15OWfQVIwuI6YfPFs1iUbPhT1dX/LH1ZDmlQ8pXlHFMA3YZ504d7+M07CNtnOOTcKPfkZPEVTNICUpU8c9Yk0JhcChNcTOx4yl/+4qRSnpXVoFgSlKPWfqipmBczw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7602.namprd11.prod.outlook.com (2603:10b6:806:348::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Mon, 27 Nov
 2023 04:06:31 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 04:06:31 +0000
Message-ID: <c6a62843-efd7-46f5-9b25-6ec7eb70f613@intel.com>
Date: Mon, 27 Nov 2023 12:06:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/26] x86/fpu/xstate: Add CET supervisor mode state
 support
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-4-weijiang.yang@intel.com>
 <20231124094502.GL3818@noisy.programming.kicks-ass.net>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20231124094502.GL3818@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0154.apcprd04.prod.outlook.com (2603:1096:4::16)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7602:EE_
X-MS-Office365-Filtering-Correlation-Id: cc1aad9e-1699-4af5-76fb-08dbeefe3c47
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PNwKuAjhc40m6WFdlRWI9n00CYA1IkhfoWCwN44fI93dd8t7TDPPfq6j/cCUteY+FFk3Xo7eV4IbtTk6edM3i90essgeq3xoF3gfthky4V6dw0W7zWu9os3wr/zSaJ0naAOxZlMv74teEMeps0O4XvS052GakwWIOWzMFvv2XLEt++nKMCD5DdAqWoJx3yEVNzuTLq4zhrpmBDcxZ7u0MIYLSs155K9EVZi6lCAT9IjL1Sbdv4b4tozwFM35l9Y1uC+RY45vyYFlNlp+2UR+eDSUzFmDb2BGj4NMf+nxVDNI9LEE/t7tdSYXV2Glj3XeWCZVI6IECasOFycMAZGEyG75KAg91BCksI0TzPAk4vRf8BkbbSqf48kKivl9ZlQcvABrlDbYE1TOpzg+hLGr9onvUDl22jEo1LYt41eqX5NqGmn9kgwvyuPyKymVvl9uujQiJZGeEZG5VLBy3vyfxfXM8wp34x6crTRtS01ExSXezAGWbrLuoA0XoiaEDdLkJuLAd+ma2E1bn4j+peRlcoR5WyuCq2d6VHPfhxxkJCv8TIsyMH+TWUkdaZ3Lwq3psZh4n1RrLN287fU8wbD87pZ43QvW1ToPt72ecLoJvnp2kvPkI8nZNm2AQX9dNlzQ7RWBNHU5GuiGJ0kl0K0QAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(31686004)(26005)(83380400001)(53546011)(6512007)(6506007)(2616005)(41300700001)(82960400001)(38100700002)(31696002)(86362001)(36756003)(8936002)(4326008)(6486002)(2906002)(4744005)(5660300002)(316002)(8676002)(478600001)(6666004)(66556008)(66946007)(6916009)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0F2cmppbnJGR09OSk9kcTNRYWMzd1BDRWloZUxaSnpldHpETmVlQk9UV2FY?=
 =?utf-8?B?V2lqaDl1WHZ3SksweVRhOTA4TTVicCtuOGk5L3FPOEVhMUVBSFFaa28vZnB0?=
 =?utf-8?B?Wk9ZYXhvbVNPOVo0MDlnd3NhdGNZNU1QNzdvU2psa0V0c3Y4Y0RJcTF4UDls?=
 =?utf-8?B?cE9xYXh5U21ibHp2TzU3NGdVbkkyNWhSWDUwNEowakRKeXFnMTJFdytTMVNR?=
 =?utf-8?B?YW9LT2ZVZU9VTHQyMGd2S1cwQ3ZyRy9YeXdpcHhFZm5xNXpVa085dTlxc2NN?=
 =?utf-8?B?SExoNHQ0Mmpkd0ZuczBDS2U4VDJ1OEF3cVJnVDNiaVdOQXhwUXBNaWlQVDFO?=
 =?utf-8?B?b1FIVHVFR1hoc1J0clU0THMvRDNsOXNYeTRUVEhEUXBjdFYvVXgxQmNsRXIr?=
 =?utf-8?B?b1hMcWsxQWFzNjNGYWdScklHc2trTzBCUVRtOVFHRGo3bXR1Z09BelhYREFt?=
 =?utf-8?B?T3ZTcjVvcHgrbE8ycmhiZEI3RWlhdmpCM0dvSVZmTTdIaXhjUFZJNnJERnEy?=
 =?utf-8?B?aUlzdEdzVGkvbnBzU3YvZk40UVZTUndZWWtQRmJPL1BLRWJra0tlNG9keXNQ?=
 =?utf-8?B?dHZORk9OOG1STlVoRm9neVRZYloxWllLWVRmYktOTnJ3Sk9rNTdnaTJORmlU?=
 =?utf-8?B?dnQyeFZPSXQva1ZOby92RmcwSVZrUmt3QlAvR2M3NFRSM3d5VU5ybEVJcUs3?=
 =?utf-8?B?UDdrTnFZUTI1NFlXbnVBNVM5aGVkdGRhdTZPcjd5OHppUDQvVmhWTkVKcE9k?=
 =?utf-8?B?eFRWVTlFWWFQNFVMR3NydkhwRHRreUxiOEhRMTBLc0plaXZkVHY2dGtUTHFx?=
 =?utf-8?B?MzgySVlnQm9qTGtJdkhHUDBkemd1WUErbDhMcnJqTmVLWHloNFpzR3RydVFY?=
 =?utf-8?B?eGRqd1diRmJFdStaUUVCVG41UThwSnM4aXNNRjhHZzcveFhhcTdmTHhNa0pM?=
 =?utf-8?B?NjNnKzNHeE1lN0lmcm9Ec3U5emlwdDBWNURQeWFZZThYTTBlWVNIcDJTVUIz?=
 =?utf-8?B?T2ZoK1l2N2l2VmdoeTdMT1ovZ3NzMG50dnJyWTg2OFZxTDdxc1ZBUFhTM3E0?=
 =?utf-8?B?ZGsrYU1SR0lWa0ljeUl3TVU4YmxzQnUrcjJ2TE5qRitaWVkzK3QrL2JZRnR4?=
 =?utf-8?B?c3pJRlVxcnlEcEVOY1N5RFVnSUhQMTB2bFdrcW0wbjNVUFgxbmkzMnRNTFJC?=
 =?utf-8?B?WHFBR1ZXa0laUkI5TS9Pc0NZRnRld2xFOGFKMUZiN2hBTjBtMTVpVE0wVVNt?=
 =?utf-8?B?RndNY2szcm5GRkNZd1dzM05pL25OOFc2VkxSSTZla1JnRWtia3pTVTFiajlh?=
 =?utf-8?B?SGNXR3pWYmJNNTlOY3U1YTVwOStOOWt5WitmSUhYRW5SNUJveDVtODdjVUJn?=
 =?utf-8?B?bUY5bW94WTllZERwRnpyck1ISnFGWVpCMlVRampCNkJHcldUWXF4QXJMOVJi?=
 =?utf-8?B?UXl2MWp1TlBoT3EvL2J0RDdObDZ3bjhYVm1GQXd1bEthRTRoeVdXMm5GRVpO?=
 =?utf-8?B?T0VBaFVlREVKNlBmM2dRUWFibWNtNC9odFVVSUZIRy9WSWJFY2d5RFdOVnNa?=
 =?utf-8?B?NlhPUVhCcTRjSVZSdlVpc3JuLzdNN2pZcnlJNWwxU2pRUnc4azZCYzJab0dO?=
 =?utf-8?B?Qk9idFJmUU5tQW4wVW1lMGtBakRHSWZZTk1vQWZPM3FDQzIzUkZWeXdGTkRR?=
 =?utf-8?B?WDA1VEhBNVFseEFHT2JLZVM4eWY5d1p4OGp5RW4vcjVGdFhKWk44L2VqTHFO?=
 =?utf-8?B?czRlaW5GV0p0VU9Sa1Bwdmg2Z3pkdVVnYnJrUCtKY1NHcklvQzNyODEwUWJ6?=
 =?utf-8?B?TjUyZTljOHpkN1RrMG5FNWpuTHVTdVFxNXZnR0RuTnpsVGhOTEpZR2FUL2I3?=
 =?utf-8?B?ZUFLdmliRy94ZmFraUprUDhzS2E5Yys1MmU4MDN2cDQxd1c4RUtJY3VPSUpZ?=
 =?utf-8?B?NS9DdHg1YVR2QjJ2ZU1FWUdZeWd5TTA3L0lNMFA5RUxBQjYyaUtyOUhMRE55?=
 =?utf-8?B?SHFUa3UzWTJocGJGWGRISW1rQUdNZzRvdUlKSlFlOWIyQys2MStSOVZic0M0?=
 =?utf-8?B?RFVGMmRKWlRwZE1nRUt2bmtZRlNjb0Y2MjQ4eWNSRHM5amNIMm5EZnBRR21V?=
 =?utf-8?B?Mm11cm5YUkFZNTNhS2NZMis1SUFpTVFlWlFLWEpNcGpYSE5lRStNdkNiMnhZ?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1aad9e-1699-4af5-76fb-08dbeefe3c47
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 04:06:31.1426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8slxuZ3uOyvoABhSCc0QhcHco5k4vcXUAEESwZmyhrMn0J2QrLCNlIumER05no6Rb4YDcmPE5hEcNXikK5O/QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7602
X-OriginatorOrg: intel.com

On 11/24/2023 5:45 PM, Peter Zijlstra wrote:
> On Fri, Nov 24, 2023 at 12:53:07AM -0500, Yang Weijiang wrote:
>
>> Note, in KVM case, guest CET supervisor state i.e., IA32_PL{0,1,2}_MSRs,
>> are preserved after VM-Exit until host/guest fpstates are swapped, but
>> since host supervisor shadow stack is disabled, the preserved MSRs won't
>> hurt host.
> Just to be clear, with FRED all this changes, right? Then we get more
> VMCS fields for SSS state.

Yes, I think so, KVM needs to properly handle guest SSS state and host FRED states.

Thanks!



