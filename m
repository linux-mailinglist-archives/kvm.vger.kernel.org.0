Return-Path: <kvm+bounces-3301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F83802D92
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86C6D280E60
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 08:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97616FC1E;
	Mon,  4 Dec 2023 08:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ji6yNS0y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB6AD8;
	Mon,  4 Dec 2023 00:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701679851; x=1733215851;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GSN8tfoUUblSnq8vRBR2NNStgYDkVV3+e90Ijls6bvg=;
  b=Ji6yNS0yrwo+fQPUuA0/GdUKtZvzyZhQWQ4nBJIBzaKeB3aW18rt84zs
   c6E8nbnkS3HUGClAbpujHXx0jYUQ9x4nvsAzocj+OagLMgokJYxn+GIyS
   OBkJVSvRs4nkXaddajpEUDvNqlzaE7rSHc5gQZERKujtbi/C+S/bs1AKz
   PNPktPW1p+J95CGr7N3JCKlgGsgTNPujoDbfQ+ElCeBd07Z2wGHRAlPM7
   CUzLkbjU6aftV1g9l86KIoYYORZXtF0UWtGkjAl6WzuersVTmDTSWZxL1
   wxeOph0aLwt1iaCByOl0bEaZ08A0Vk/GowujUYU/5J3Vx4UWXewSsE40j
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="397589301"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="397589301"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 00:50:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="943813137"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="943813137"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 00:50:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 00:50:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 4 Dec 2023 00:50:50 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 00:50:50 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 00:50:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nT/sNk3GNX4gOJRLXhBMYxN20UBb8eyDXNQvIX2mpc2rRFgoOOs3S9JBJWxiewAxAtx+sGaY/fAP/cGCadRpsNWEYpb/hjaPl1J8NNbxQyZXKp1n9V0lf5JnIFycMpOg6fjd6LbFSkBb/hAG+9KqqoK0cUOw7adqFpQ29woDBbwhgS58/2amln6AVH4lx6kuLFDpt/WA88ChuFmE+C504mnuovOimQHXZo+exqMKSMgRR49hV7HAH8SeFtPLfUdvCdMz+vaPgx/k/h/97JbOGmJI2bzQWT7bS7cIbgPvEeDQ3sJpfgmYWp326RZHdx9aH4D6KQ7wbr6Z2FtXQqoENA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQ2IFuUoBvCInkLhBPxrPyJ2cUPxoa3zIpreHfUO8vY=;
 b=W9ZVAxE4qyvM0248CstYaG1hAzr9KbW/KXLEsHDGtaBOeolW+T/JuWE/k1oZu9jhN6KzHJE1/MJgciQZplnWlsNC0ZeRwiwsYEFGWCGl/0Hy1HT6eu5PgwZJtVEi5760++SMfjVBMDj9J7mfRlIwRjmfs7HluDrUAhGGFT7/cVODhn0Wf+Le25jPxGADayGp8Qw29wK/oQn2lH5PcN3kIvdQ5JruxUCZfleuNVrrmuStkLEhZof80Ul4TfiD/kGIO9bRxttKU8+8UfkgwjtrHh4n35iY3g9m5XC/jju8zOnBlmbDaw22aPMxZ5SQf9n7APsFbdJbaaVP5DB9ReKMGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 08:50:47 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 08:50:47 +0000
Message-ID: <e7d399a2-a4ff-4e27-af09-a8611985648a@intel.com>
Date: Mon, 4 Dec 2023 16:50:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 26/26] KVM: nVMX: Enable CET support for nested guest
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-27-weijiang.yang@intel.com>
 <2e280f545e8b15500fc4a2a77f6000a51f6f8bbd.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <2e280f545e8b15500fc4a2a77f6000a51f6f8bbd.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0056.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::7) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH3PR11MB8468:EE_
X-MS-Office365-Filtering-Correlation-Id: 137aaf30-80fe-46b8-f3b7-08dbf4a61b7a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7FPd501Zs3szOimJD9ncqhOFP5dcx12YOaWj+tazEFE2jTLi2Bom9+VaNKkIzdZc5wLYypE9K8Q01hWgRe7THlCsHBUZuxSKG58sClDhtPtN3zeayEaVux/5/jYLOZt1hCu2LYSntbmHYZ63fFRoAQBRmqwg7tycfrYLwdk/Uu5oO/w8/0ZOywJU1VU7ZgjMZ+XvPgH37NuQpkx7l4z+y2En87+WWcJHlkCjtvtIxCq4a9SRNPiD+lR8vcN5FNDaYmggOethDQZJizHO60vnOa65WBC7ioojrYlykbaJUhIKap7BH+KPjpmVneoKsZpVLPUIsGWjXzqqiqHATF/pH+eY+0IpGM3Zg519LdvaDjCrsGXCTRDB4eziUL3JHRZlZ1MsK2qFXwDPZNCaOmNCN1VK+CdkJtjOjVxmqlPy7oIQcrrJvaLf90jmyVWi/JI9cX0mkDeoKpLrUiZ3OO+0SZ3ttjbYevV+QF6BKvJkenUiMVJEHZ5K1S6igUT7AKYDMpCzh21prywjnQMYhfgz/VTMT9qlAkWlCLDtYZzsLLQ0v4zFHr2MIK8Gla3mloi4AnQ9WpeZb0aPixrsmh4KSg6CALFO9kG5t2hMZx0LrIzLKWHPKDXDS7tx4jRROHwni/UBaxNqF7d0FSh5qp6YGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(366004)(346002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(6506007)(53546011)(6666004)(6512007)(6486002)(478600001)(8676002)(8936002)(4326008)(83380400001)(82960400001)(66946007)(6916009)(316002)(86362001)(31696002)(66476007)(66556008)(31686004)(2616005)(26005)(5660300002)(4001150100001)(2906002)(36756003)(41300700001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkVRY203ZkI1RVluVlFsd0g3VGNkbys1STRSYWpMZVkzWUNVUy9uRDFVQmRk?=
 =?utf-8?B?aFpiQnhFRmE2MmhXRFRubjlybGxyeHpwMHhSZitBRXRXUjN6cnZ5YzhQNkF6?=
 =?utf-8?B?bkRsRWo3QmtQUDlqZ2dqckdKOUlhUENQOXpPSlI0VzVDQ1F1cTdzWEhOdVI2?=
 =?utf-8?B?NkRETVZWU3RWSVpmR205VmowNzZvWENoeVVmU3R2dGV5cXZXRGZIYllIZXNn?=
 =?utf-8?B?MmhuMUpVcFF3bW5Majd6endJQjJEUXN1MkxyTHVJc3dxWS9VdmtWelgzNnlZ?=
 =?utf-8?B?d3RUN2J6WUxsQWtKc0lJZnd1bWpob2NYZFFvamtvaktpdzRmUkVnUzdON2pZ?=
 =?utf-8?B?Z0N0Y0l1WVNUaWYzSG91bXJyejhiK1FzUGw2VFNYcnY0Qm82MFRuV3VnTFNO?=
 =?utf-8?B?L3dQK3k0b0hnampYOUUyWTNOcnZ6eXJpNUdqNVJuUUNUWkdnMGhmNmhDb3VQ?=
 =?utf-8?B?UUlLYjhzeWo0OERmYmNiTXZDNitJOEZPOGZYZTE3aUZmQy9RcGNsRTh0OW5M?=
 =?utf-8?B?S2Q0b1EwQUl3RGJLNzdLUWdnb0Q3ZnB3WFVVL2VkUHh1ZTljK2pUMHlWV3dn?=
 =?utf-8?B?RzEzTC95cDJ2aFY4dkdqeXN1YmhSeWJ6STY5OHEvRm4rSnR3aXBsczdWVk9v?=
 =?utf-8?B?c25oUVBWR3pZeTZxOVYzQlNVdUR2aHlOUmpLbWE0TWVzTi9pVGdZTmxRZ3FN?=
 =?utf-8?B?NEhQRlRrRDU4M2xaRGcybndpcGpEM0NjUGsyWlVpcldjTXgzWWp1c0Y1Sk5r?=
 =?utf-8?B?c3FuUmg2bmZ2bDQxK2tNQmZoc29UMkhacUorVTdWRmNMT2RobnUxRmJqT2dh?=
 =?utf-8?B?NCt5SFhnL1FNWjRzbFFkc3pMMk5lanJhTWVudDROVlJ3UWhtaXRqZlErOWFu?=
 =?utf-8?B?bnVUVDV4Z3lWdnhBMHQ2OTlzV1FwYWVhR3RmM2o4Y2hlNHYzaVhyMmJIZCt1?=
 =?utf-8?B?YmwvU0JGaFV3N3BVcVg5Wi9jNXMyTUpSanlsT3VEN21IM3FzTnBKZTZZQTRh?=
 =?utf-8?B?QUIvSGsyTE1xUE5TMTNiaVhtNnJPY0VISHV0MFpEeUl5eXJhU043ZnE1SGNs?=
 =?utf-8?B?dHBvN1F3bVRZdUZFVWZaejlDY1g2elF6akxuZldLWkg3a2VTWTVWM0xNUm1n?=
 =?utf-8?B?SzVLd3pmUHMzT1NJa0xObkl0UGFlQm1SVEFtcCs3TWgrZFlaZlZESlBxSHBr?=
 =?utf-8?B?K1ArQ05YTUM3SzZGcmtUZU9TUUR0N1l4WHJPbGdaRmpEK1lEZXdDeHV3S2Q1?=
 =?utf-8?B?ejJ6MndoVTRGb3RXZTlOTVlJMU5TdkJiM0locndXanVMdldKN2g2VzM5Z09M?=
 =?utf-8?B?SGxzQVFoSTRSK2NQeVRkUWx3MFpFZ1o3Z2pCM2ZHYVdONUl2VWxpa082OHMz?=
 =?utf-8?B?VzJFcHNlanVyNzlZMVF6Q0x6c2diYkhRWlAzbzdnT1FHbDVRR3Z4azVRRk9h?=
 =?utf-8?B?VTg4RlFhb1psVE5QWUc0akN4ZmVpbmZjZ3A2VU52UGc3ZnhqanRJVWVOYUp0?=
 =?utf-8?B?MFFBSE5jaCtGRHVWemhrVjM4Y0VHZU9xa2VHS2tBZ0tjM2FCVUU5WXR0Umo2?=
 =?utf-8?B?K2ZXYlZxdDFOT2c3NjRzbFNrY3ZwcFN0UkZPYjNCdDBuOWx5dmZoV095aGFI?=
 =?utf-8?B?UUFsU3I5MnpkdWhxRVVPajNVS2ROaE5VRnVZNEF4UW51OU1XNUQ4aFF2ZG5G?=
 =?utf-8?B?RXhlVHd1Q3JZdGxnTzE2SXhwV1NtMHZnUklrTXJhbkdtTlFWMFoxUm01RGVX?=
 =?utf-8?B?S29vQ2o4eWNBZTF4OHpWeW54ZmI0MWpSbDNFUlVZbjlmNlZHYTU1ejhZcnRr?=
 =?utf-8?B?YyswTXpqMTJmOFdiaXhoMTY0TlBTUURNL09jczF6N3k2d3djaExrYWhVbk5E?=
 =?utf-8?B?V2lncXN5RkROc0tlSlFQN1NGNUxmMEdsU3V1MXVXT3VYQXprTFIvdnEwUGdZ?=
 =?utf-8?B?YkZ5SUIzdHFHYy9SOGN0cjFmcGJyL2xOUjB0R2xQN3dOQkYyVHJPUDd1TFlX?=
 =?utf-8?B?bHIvNFU4aHM4UmtOdldOejNSaUVXcjM0YzlaVmF3TWgvRTVkYkdvRlhlWWJt?=
 =?utf-8?B?RDZmTS9kM1lwN0VXWnZDbll3KzY3OTc3MGVNbUc4aW0zanMxdHpNMjMzVzRG?=
 =?utf-8?B?REdSY2NwNkM1RTlhdVloNjlnRjdUWXlYQVlMWm5DdUVkWnA1K1laYVp0UTNG?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 137aaf30-80fe-46b8-f3b7-08dbf4a61b7a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 08:50:47.0019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EEC90Iu119fsddKCQd6UBaa21/Z7LSZX8Eep6/xbSIVc1GH7bYP1zkpczY5lJEKDq9jJYMPOJp84oy9TQCP4wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8468
X-OriginatorOrg: intel.com

On 12/1/2023 1:53 AM, Maxim Levitsky wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
>> to enable CET for nested VM.
>>
>> Note, generally L1 VMM only touches CET VMCS fields when live migration or
>> vmcs_{read,write}() to the fields happens, so the fields only need to be
>> synced in these "rare" cases.
> To be honest we can't assume anything about L1, but what we can assume
>
> is that if vmcs12 field is not shadowed, then L1 vmwrite/vmread will
> be always intercepted and during the interception the fields can be synced,
> however I studied this area long ago and I might be mistaken.

The changelog wording failed to express what I meant to say:
vmcs12 and vmcs02 should be synced to reflect the correct CET states L1 or L2 are expected
to see. In LM case, the nested CET states should also be synced between L1 or L2 via the
control structures.

Will reword them, thanks for pointing it out!
>>   And here only considers the case that L1 VMM
>> has set VM_ENTRY_LOAD_CET_STATE in its VMCS vm_entry_controls as it's the
>> common usage.
>>
>> Suggested-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 48 +++++++++++++++++++++++++++++++++++++--
>>   arch/x86/kvm/vmx/vmcs12.c |  6 +++++
>>   arch/x86/kvm/vmx/vmcs12.h | 14 +++++++++++-
>>   arch/x86/kvm/vmx/vmx.c    |  2 ++
>>   4 files changed, 67 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index d8c32682ca76..965173650542 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -660,6 +660,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>>   	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>   					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
>>   
>> +	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_U_CET, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_S_CET, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
>> +
>>   	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>>   
>>   	vmx->nested.force_msr_bitmap_recalc = false;
>> @@ -2469,6 +2491,18 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>>   		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
>>   		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>>   			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
>> +
>> +		if (vmx->nested.nested_run_pending &&
> I don't think that nested.nested_run_pending check is needed.
> prepare_vmcs02_rare is not going to be called unless the nested run is pending.

But there're other paths along to call prepare_vmcs02_rare(), e.g., vmx_set_nested_state()-> nested_vmx_enter_non_root_mode()-> prepare_vmcs02_rare(), especially when L1 instead of L2 was running. In this case, nested.nested_run_pending == false,
we don't need to update vmcs02's fields at the point until L2 is being resumed.

>> +		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>> +				vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
>> +				vmcs_writel(GUEST_INTR_SSP_TABLE,
>> +					    vmcs12->guest_ssp_tbl);
>> +			}
>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>> +			    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT))
>> +				vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
>> +		}
>>   	}
>>   
>>   	if (nested_cpu_has_xsaves(vmcs12))
>> @@ -4300,6 +4334,15 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>>   	vmcs12->guest_pending_dbg_exceptions =
>>   		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>>   
>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>> +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
>> +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
>> +	}
>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>> +	    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT)) {
>> +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
>> +	}
> The above code should be conditional on VM_ENTRY_LOAD_CET_STATE - if the guest (L2) state
> was loaded, then it must be updated on exit - this is usually how VMX works.

I think this is not for L2 VM_ENTRY_LOAD_CET_STATE, it happens in prepare_vmcs02_rare(). IIUC, the guest registers will be saved into VMCS fields unconditionally when vm-exit happens,
so these fields for L2 guest should be synced to L1 unconditionally.

> Also I don't see any mention of usage of VM_EXIT_LOAD_CET_STATE, which if set,
> should reset the L1 CET state to values in 'host_s_cet/host_ssp/host_ssp_tbl'
> (This is also a common theme in VMX - host state is reset to values that the hypervisor
> sets in VMCS, and the hypervisor must care to update these fields itself).

Yes, the host CET states for L1 also should be synced, I'll add the missing part, thanks!

> As a rule of thumb, if you add a field to vmcs12, you should use it somewhere,
> and you should never use it unconditionally, as almost always its use
> depends on entry or exit controls.
>
> Same is true for entry/exit/execution controls - if you add one, you almost
> always have to use it somewhere.

I'll double check if anything is lost in various cases, thanks!

> Best regards,
> 	Maxim Levitsky
>
>> +
>>   	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
>>   }
>>   
>> @@ -6798,7 +6841,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
>>   		VM_EXIT_HOST_ADDR_SPACE_SIZE |
>>   #endif
>>   		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
>> -		VM_EXIT_CLEAR_BNDCFGS;
>> +		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
>>   	msrs->exit_ctls_high |=
>>   		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
>>   		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
>> @@ -6820,7 +6863,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
>>   #ifdef CONFIG_X86_64
>>   		VM_ENTRY_IA32E_MODE |
>>   #endif
>> -		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
>> +		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
>> +		VM_ENTRY_LOAD_CET_STATE;
>>   	msrs->entry_ctls_high |=
>>   		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
>>   		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
>> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
>> index 106a72c923ca..4233b5ca9461 100644
>> --- a/arch/x86/kvm/vmx/vmcs12.c
>> +++ b/arch/x86/kvm/vmx/vmcs12.c
>> @@ -139,6 +139,9 @@ const unsigned short vmcs12_field_offsets[] = {
>>   	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
>>   	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
>>   	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
>> +	FIELD(GUEST_S_CET, guest_s_cet),
>> +	FIELD(GUEST_SSP, guest_ssp),
>> +	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
>>   	FIELD(HOST_CR0, host_cr0),
>>   	FIELD(HOST_CR3, host_cr3),
>>   	FIELD(HOST_CR4, host_cr4),
>> @@ -151,5 +154,8 @@ const unsigned short vmcs12_field_offsets[] = {
>>   	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
>>   	FIELD(HOST_RSP, host_rsp),
>>   	FIELD(HOST_RIP, host_rip),
>> +	FIELD(HOST_S_CET, host_s_cet),
>> +	FIELD(HOST_SSP, host_ssp),
>> +	FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
>>   };
>>   const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
>> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
>> index 01936013428b..3884489e7f7e 100644
>> --- a/arch/x86/kvm/vmx/vmcs12.h
>> +++ b/arch/x86/kvm/vmx/vmcs12.h
>> @@ -117,7 +117,13 @@ struct __packed vmcs12 {
>>   	natural_width host_ia32_sysenter_eip;
>>   	natural_width host_rsp;
>>   	natural_width host_rip;
>> -	natural_width paddingl[8]; /* room for future expansion */
>> +	natural_width host_s_cet;
>> +	natural_width host_ssp;
>> +	natural_width host_ssp_tbl;
>> +	natural_width guest_s_cet;
>> +	natural_width guest_ssp;
>> +	natural_width guest_ssp_tbl;
>> +	natural_width paddingl[2]; /* room for future expansion */
>>   	u32 pin_based_vm_exec_control;
>>   	u32 cpu_based_vm_exec_control;
>>   	u32 exception_bitmap;
>> @@ -292,6 +298,12 @@ static inline void vmx_check_vmcs12_offsets(void)
>>   	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
>>   	CHECK_OFFSET(host_rsp, 664);
>>   	CHECK_OFFSET(host_rip, 672);
>> +	CHECK_OFFSET(host_s_cet, 680);
>> +	CHECK_OFFSET(host_ssp, 688);
>> +	CHECK_OFFSET(host_ssp_tbl, 696);
>> +	CHECK_OFFSET(guest_s_cet, 704);
>> +	CHECK_OFFSET(guest_ssp, 712);
>> +	CHECK_OFFSET(guest_ssp_tbl, 720);
>>   	CHECK_OFFSET(pin_based_vm_exec_control, 744);
>>   	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
>>   	CHECK_OFFSET(exception_bitmap, 752);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index a1aae8709939..947028ff2e25 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7734,6 +7734,8 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
>>   	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
>>   	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
>>   	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
>> +	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
>> +	cr4_fixed1_update(X86_CR4_CET,	      edx, feature_bit(IBT));
>>   
>>   #undef cr4_fixed1_update
>>   }
>
>


