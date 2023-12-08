Return-Path: <kvm+bounces-3916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 134FC80A65A
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 15:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 057F21C20D87
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 14:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0327720327;
	Fri,  8 Dec 2023 14:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hzCNUyWQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B121FE6;
	Fri,  8 Dec 2023 06:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702047483; x=1733583483;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GHxkpirSUXhRDE15HXVEibBCiDDqipY/UTLRGf853BA=;
  b=hzCNUyWQlmn3reJK92PSBWCoB5+piP5R5Fa+96U6eg1ZORabpuEfNxGN
   AC1ZxOZAngNluyDTxue26nwB7zK/Bk7fF6BkUGaC+MfdwB7NMSQE3l93Z
   KlbThwOfR/xUVriijp59EtaY8Fn3EbPjjNWFKpBlA8S9IF/Miileft0nC
   gVQYOAyxcIxPffSYEAgh72S8Re1Vdw4Mu9VtD6mnLMkA9NU2uP1cZ23sN
   dEE1LrIbTQKK2G0e441sRYit/1ggm/AOjlfpIFlTXNXvxTY6HQwqmo8SV
   6dhCWMZ/TA2sgHZDqXG1btpdnpfezrOfvY0Y3r8zQiyJP+peQItZhbZz3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="374576344"
X-IronPort-AV: E=Sophos;i="6.04,261,1695711600"; 
   d="scan'208";a="374576344"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2023 06:58:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="945443559"
X-IronPort-AV: E=Sophos;i="6.04,261,1695711600"; 
   d="scan'208";a="945443559"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Dec 2023 06:58:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 8 Dec 2023 06:58:02 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 8 Dec 2023 06:58:02 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 8 Dec 2023 06:58:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCh2XrEeggTzxlgeiuUBjwm/z3+CXr9ZArgBnNxyMS8DY9Y0SMypviZ2Ic/7EdwMd+Zyd9sqGkbwiNanHjPo3YKdstzapWXbW8ibPA3znA+8xh0ZBU+IayqGmzcwb1ZYJ5KwNIvgj9NGOtaE0mydMf9tmw8GW5UVuD2qQty9omYckQF3/K0AvallNmyrN0DDDz7aZE7ZhaTQv3N1wG7reJY+gkdaR3wU1AuzmVkZZsNVrBSxzGEBssJ4nHsE5d5x+geC3iRcivmrx8veK0OIQoT5LMkOJ6jYnEYMasQylO3DehfZEu4K/0uojJoxRBdc/M6uhieweGrBaVcKhGVtHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+IR7TSIdnBPVaPXPGr26RfSHFwI5RrhtM+kUV+vAK8=;
 b=GMQAkwSVP2TvPhdUPxbrVrJw8CJYvtlmFd/riGt0USDqYQ7Yec4kiRBNgvU4JZ+FigNyYzJp4dz0ez2YdlcGgBot43G5LhYbsb+ojWdaF2PoZ8lS8TZu1Le80gUc0+xe2MrLtt0+e8AN1300k/Hib4sWqqeNte+c8yMLkhibIUeUCndBzt7mbsWKr2Vb55u4HkNLUxgzX6E6Pttk45FO7ZTKBlCu+oIlhtsh4spyuAAXN6BJM6IaHm5VNHA0dnhtNLCRpSlXdqhAl0mTMpPzbaKAreSaNdBXaP8bBYJUnFM2I7dNfLsxS9/WfwOM4C5K+/vQiJJxF/C1NT2g8MKm1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BL3PR11MB6340.namprd11.prod.outlook.com (2603:10b6:208:3b4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Fri, 8 Dec
 2023 14:57:53 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7068.028; Fri, 8 Dec 2023
 14:57:53 +0000
Message-ID: <eb30c3e0-8e13-402c-b23d-48b21e0a1498@intel.com>
Date: Fri, 8 Dec 2023 22:57:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-3-weijiang.yang@intel.com>
 <c22d17ab04bf5f27409518e3e79477d579b55071.camel@redhat.com>
 <cdf53e44-62d0-452d-9c06-5c2d2ce3ce66@intel.com>
 <20d45cb6adaa4a8203822535e069cdbbf3b8ba2d.camel@redhat.com>
 <a3a14562-db72-4c19-9f40-7778f14fc516@intel.com>
 <039eaa7c35020774b74dc5e2d03bb0ecfa7c6d60.camel@redhat.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <039eaa7c35020774b74dc5e2d03bb0ecfa7c6d60.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0009.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::18) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BL3PR11MB6340:EE_
X-MS-Office365-Filtering-Correlation-Id: 543a12ad-33a0-40f9-0ddd-08dbf7fe0dd9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xx0MaiVjTy5743VmknFsfiua/kfLux0ubTL0fg54+B1HEWTliI2MH9ZJ35scmiEZ5Rng1Wb4J8YEhda9ZB+TbYVRIRpVC/t0EgmglKBdehhzMsG8HCqI7l/8JjNW9smB6aCDTePvm/5SKt4U4nA2/RH8xaOiqePLaZFNdD4HdxkvElJeoRbbOoy8TMul6nXp8QhYEyzU55MbP7+FqWlwV7M647gS2cRCufUc7kGo1+jpblz37lI7Ic5gQ5k7BoM39ibIjxmD+Cnn0DLKMvlXJE5bxYl1HZM0u4LlwpHskVynr87cxyOYI1KpCsyszOB2CYOZ//GtWaAW6hPVsDYnCZWc+CHFLii/j0jutGyLz9BgHHXERmBUf+r1sd+wqR0F2IRmU5qvItAtxz6j6yPJBC90CE3m54Idyh0ec64rBd8GAeNkZQr4991NU2I5BWGFmgPFrldLKt8RqTzJnwtvyhj7993g8PHxtjMWuMTldsd6lruxozN/CXE2e69zEmHVEZ4YFx9gODjWgELJeELzzGRr99nWAndgndX0LSptrCPjtMbAvGMwdQRs2N8GBcB9f9PhvgFR8pkh+5fPeWz0ngFKqHIh33Kpt2Tr/tIo/WdzgH+l3l/jtMsTbKXO6Ohf6EKEQZrrsj6r/aarAa1+ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(376002)(346002)(136003)(39860400002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(83380400001)(6486002)(478600001)(6506007)(53546011)(2616005)(6512007)(26005)(6666004)(316002)(6916009)(66476007)(66556008)(8936002)(86362001)(41300700001)(36756003)(66946007)(8676002)(4326008)(31696002)(2906002)(4001150100001)(31686004)(38100700002)(5660300002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blRaRmFDRWpTN21lUVErVXZmNERJdUVxdkV1ZEhobVhhaEl3bmRDUDR1bEps?=
 =?utf-8?B?RThvMU1tMXkxbWJkNlUwTnNRQWFaNlRhY0luS2RYMjdmUzdVUjBWV1VKTGhR?=
 =?utf-8?B?dHJtcjBRem5XNEgvYytOWEcwblhrdDYrNXFtNEF5ZDBjc1lYYkRrdlpiaUNl?=
 =?utf-8?B?cDVDSlFjbmNSSncwMGpCQnlKZzN5MEwrVE9TUkRmMXR4ZHRSNEFWUzBjNHlk?=
 =?utf-8?B?a0xsTDEwY21LU0p3RU0wTU1TMVpwOFhIM0hYR1lxQUZpaVRodjFWZWJEK2d4?=
 =?utf-8?B?VGxVbXFmY3ZYVy9LdTVKNndTdW9FU0plK1FhbzVJV21PRHpCSXFnS1J5T3cx?=
 =?utf-8?B?b3ZWVUFnbUcxckZGVDBoUGZzYVh3RzBFWE5iUSs3UTlZWDVFeXZBZ1djWUQ4?=
 =?utf-8?B?M0tUY3ZzaHQ5M3o3b0hFT29pNGo3OVpYdUZIazIyKzVhY3hqa1pkWFkxV2N5?=
 =?utf-8?B?K2RnL0NRWUFqRlMwRVVkTUhLK3lkcm54Ykc1cnFIaGo4ZGttaVRVaWVqT0la?=
 =?utf-8?B?VXRYUGpnUU13Y292Q3p1Wi9ON1dZRXBGZG5sMWNCcXZlbWIyYXh0d0JJcWU5?=
 =?utf-8?B?bkhVaTVTWDA4eVAxRmVsdHdvTTdpRFFXUGI4SzIyM292U2FYK1FPVmFLSHEw?=
 =?utf-8?B?TmFzV0JsMlhMeG1wem9kM0ZmM3QyaGY0Y2ZWWjM3VGI0eWRXT2QwMFR6b28y?=
 =?utf-8?B?WEpaUVBSWTVxdWJIQ1FPS2xZSXE0REZ6dGoyS0JYNGU2bWtBMXRpT2VOMmdK?=
 =?utf-8?B?L2xscSt5ZTdsaGVJNVlMVS9JVnVRc1lvQ2JzbXRFZW9MQVVURzNaYkRLc2dj?=
 =?utf-8?B?d2MrTE9RWjFDZy9ObjErb3lEY3dEVklYakV6QytrUU05Ri9GZ25JVkJBbFI2?=
 =?utf-8?B?VkRaNlZHcTc3OTF3NklmNnQ3KytGcjBMenJ1NFZSWWpwSFZacklLbHRxemJn?=
 =?utf-8?B?bjBya2tNSWc3R2djdVY3dUF3OU8xYk0vK1R0L0hrY0dPcVp4dThpaEw0UXpq?=
 =?utf-8?B?RkFoQXVXRDFCc0pVMUdWZXU2ZnBmQ1c2aSs3dUhvenRUaHUveC9QVG50TWdX?=
 =?utf-8?B?emZBaXNTdDI4eVlyaUwrdFlIUzFnOVBqRmVqWlZEM2RlVTlNZ0dwSERzVlpQ?=
 =?utf-8?B?UFh0ZXFKR0JhU0FQM2NOcVd2MzdxeDF2VElsQWpZVnFGNFhlTll2Qjh1dDRy?=
 =?utf-8?B?Z3dBeVVXZTU2VTNXQTNIbHdEelRsaCtwV1lxcUFzdWZXNE40Z25LZVFGVEcx?=
 =?utf-8?B?dWp2eTFaRnJ5TEs3Y3lTT0tFVnBEWjhrM1lYYUVRbEtJQlZhZ1l4SVlLZUxl?=
 =?utf-8?B?QW9RU202R3ZBUTRva1lJVUtjWkMyeXRBdXIzWGN4MVBhTGE4REhHUldKdnFM?=
 =?utf-8?B?WTdjeDhvR0J1NHE2MkRkelgydlQrNVVXb2JqZWFMMVdFd3o3WnBBd29DWktS?=
 =?utf-8?B?OWdCcE9oeUlXQ2Q4NkpEeHpTeWlaS0N3c2RVL0w5VTZ0RWVoMXpIWDBFZHVS?=
 =?utf-8?B?emg1aE00dVFLaXQ5bDFYWlh6QnozZ3V2WnU0MkVVc1BSSjgvd1J6ejRGS24r?=
 =?utf-8?B?d0o0Skg1MWxudUU2ZS90VUtFY0hSeXA3L0Y2Qmk4cm9aeDFIOEx2Tk1WRFM5?=
 =?utf-8?B?SVVmQ1RUc0g2Tld5UXlpUGMvalBTaHh5c0F4UlVvakFVaHNacHd1bkY0YzJF?=
 =?utf-8?B?SjZYb09NbldVSEhlc21lQ3B6a01oZDB5TC96c2ttQ3JManhFK3N2clp6M3Zj?=
 =?utf-8?B?b3BTc0Z2YlFrMWd2OWhjRVJpMUtTTm1pb0xUZ0JkZXZwdzlhTXIxNjlYOTF6?=
 =?utf-8?B?cUZkL0FKcFFBRld5ZWp6ZTlXVE51ZVFNcHc0RWUrbVpOS29BMWhURTZGL0JT?=
 =?utf-8?B?UDluWDMzaXBNMVJ5L0JYdW4rMHFhR2p6S1NtbHJmNitqRnB0b1pJVDRkVXR5?=
 =?utf-8?B?aVhxWnBZMGphaVFYcVgyUjcvdE5mUmZZTEkvNXFGNHIvM21iVmxMaTVEZGxm?=
 =?utf-8?B?aldTblBVQlZSTzlPN2JxWjZBYnFrSi9iR3B5OUlCYTFxZDRkUkpDR2JxQmU1?=
 =?utf-8?B?SWRNM3NoT3RURlVRWWUySEtjU29jNTI3NDJicms2dzBuT2FScDNjT255MVJt?=
 =?utf-8?B?VzdtMll3QThNcExzMWdyWHFaeVVTME5VTi92YU1ta2xhY3NHamdNYUc1ODFh?=
 =?utf-8?B?NXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 543a12ad-33a0-40f9-0ddd-08dbf7fe0dd9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 14:57:53.3576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AsJ+DWJHmsNQILF5QnFUnAdeJ6MYrJLjXjst2R+OEdI8sGcRcfWNYg12o6FB0ccG9LXESKikift1zsYcD94DVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6340
X-OriginatorOrg: intel.com

On 12/6/2023 11:57 PM, Maxim Levitsky wrote:
> On Wed, 2023-12-06 at 09:03 +0800, Yang, Weijiang wrote:
>> On 12/5/2023 5:53 PM, Maxim Levitsky wrote:
>>> On Fri, 2023-12-01 at 14:51 +0800, Yang, Weijiang wrote:
>>>> On 12/1/2023 1:26 AM, Maxim Levitsky wrote:
>>>>> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>>>>>> Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
>>>>>> reflect true dependency between CET features and the user xstate bit.
>>>>>> Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
>>>>>> available.
>>>>>>
>>>>>> Both user mode shadow stack and indirect branch tracking features depend
>>>>>> on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
>>>>>> xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
>>>>>>
>>>>>> Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
>>>>>> from CET KVM series which synthesizes guest CPUIDs based on userspace
>>>>>> settings,in real world the case is rare. In other words, the exitings
>>>>>> dependency check is correct when only user mode SHSTK is available.
>>>>>>
>>>>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>>>>> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>>>>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>>>>> ---
>>>>>>     arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
>>>>>>     1 file changed, 8 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>>>>>> index 73f6bc00d178..6e50a4251e2b 100644
>>>>>> --- a/arch/x86/kernel/fpu/xstate.c
>>>>>> +++ b/arch/x86/kernel/fpu/xstate.c
>>>>>> @@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
>>>>>>     	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
>>>>>>     	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
>>>>>>     	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
>>>>>> -	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
>>>>>>     	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
>>>>>>     	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
>>>>>>     };
>>>>>> @@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>>>>>     			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>>>>>>     	}
>>>>>>     
>>>>>> +	/*
>>>>>> +	 * CET user mode xstate bit has been cleared by above sanity check.
>>>>>> +	 * Now pick it up if either SHSTK or IBT is available. Either feature
>>>>>> +	 * depends on the xstate bit to save/restore user mode states.
>>>>>> +	 */
>>>>>> +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
>>>>>> +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
>>>>>> +
>>>>>>     	if (!cpu_feature_enabled(X86_FEATURE_XFD))
>>>>>>     		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>>>>>>     
>>>>> I am curious:
>>>>>
>>>>> Any reason why my review feedback was not applied even though you did agree
>>>>> that it is reasonable?
>>>> My apology! I changed the patch per you feedback but found XFEATURE_CET_USER didn't
>>>> work before sending out v7 version, after a close look at the existing code:
>>>>
>>>>            for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
>>>>                    unsigned short cid = xsave_cpuid_features[i];
>>>>
>>>>                    /* Careful: X86_FEATURE_FPU is 0! */
>>>>                    if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
>>>>                            fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>>>>            }
>>>>
>>>> With removal of XFEATURE_CET_USER entry from xsave_cpuid_features, actually
>>>> above check will clear the bit from fpu_kernel_cfg.max_features.
>>> Are you sure about this? If we remove the XFEATURE_CET_USER from the xsave_cpuid_features,
>>> then the above loop will not touch it - it loops only over the items in the xsave_cpuid_features
>>> array.
>> No,  the code is a bit tricky, the actual array size is XFEATURE_XTILE_DATA( ie, 18) + 1, those xfeature bits not listed in init code leave a blank entry with xsave_cpuid_features[i] == 0, so for the blank elements, the loop hits (i != XFEATURE_FP && !cid) then the relevant xfeature bit for i is cleared in fpu_kernel_cfg.max_features. I had the same illusion at first when I replied your comments in v6, and modified the code as you suggested but found the issue during tests. Please double check it.
> Oh I see now. IMHO the current code is broken, or at least it violates the
> 'Clear XSAVE features that are disabled in the normal CPUID' comment, because
> it also clears all xfeatures which have no CPUID bit in the table (except FPU,
> for which we have a workaround).
>
>
> How about we do this instead:
>
> 	for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
> 		unsigned short cid = xsave_cpuid_features[i];
>
> 		if (cid && !boot_cpu_has(cid))
> 			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
> 	}

I think existing code is more reasonable,  the side-effect of current code, i.e., masking out
the unclaimed xfeature bits, sanitizes the bits in max_features at the first place, then following calculations derived from it become reasonable too. It also forces developers add explicit dependency claim between xfeature bit and its CPUID so that make it clear why one bit is needed in max_features. Regarding CET_USER bit handling, it could be a singular case, hope it can be tolerated :-)
> The only side effect is that this code will not clear features bits for which kernel knows
> no CPUID bit but kernel anyway clears _all_ features that it knows nothing about so there
> is no net change in behavior.
>
> (That is kernel only allows XFEATURE_MASK_USER_SUPPORTED | XFEATURE_MASK_SUPERVISOR_SUPPORTED)

IMHO, the bits in the macros are just xfeature candidate bits, the relevant CPUID features could be disabled
for any reason, in this case, the bits should not be appear in fpu_kernel_cfg.max_features.

