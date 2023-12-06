Return-Path: <kvm+bounces-3682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1526806AAA
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 10:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9958A281802
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 09:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6523EEED4;
	Wed,  6 Dec 2023 09:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DL2I/8hR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B9B122;
	Wed,  6 Dec 2023 01:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701854564; x=1733390564;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m58+OABhMImQxmHMZHpjqE6dhmyAvQdJ8qj6gnb8R1I=;
  b=DL2I/8hRrAZyWDeLvxdAvi1q4zX3Ox/J18FdwFsrlmRcjHwJXrYEwLAS
   LL9JAZDdaSgxFfrUIIwDgTfgo4w9xhwwom64LJ7iTarxbA9KldjeP4O91
   BjG8F+SV2cuNwVZK5+/kFDaN3A05qn6Ur+pBVaqmQpJxKm4ixCbzbeq2j
   swFmMIXt3P7QbV5jzHYFBeatmUWpKR76sehKYTmMsz3C7fI3L4m0cfaAv
   B65VkR69W8ebnbF0dUCapDx0Ve5Tr8sAsgU+0AYo3ScF0vC8s31+5e9Pp
   +S4C59rl5hweHN7s9IlcF/xr0V2wDtedwcD8bmvGVG3KX/RxYX9RJeZhE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="425185680"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="425185680"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 01:22:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="889282312"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="889282312"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2023 01:22:44 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 01:22:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 01:22:43 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Dec 2023 01:22:43 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Dec 2023 01:22:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXSn2fEkME8GzpqswuksGGbrowwyaiZmFdMBhxFJvTOPOLJkS3sQNjD+x+jOyk1DuWMaXwlN3eijGUHNsmuq2Ef137l42LZu1VE2TQL/9xARspGntRze+PLPpQy/sKXbcB/AKLzGVbQXtJvg+bZ7r3acQaRecoGf0IBddl3uV4LQDt/gJb0fPi4OSaEOkz5jyoBz47ejYc8W3HpC++DeoIVyY0wvLG9aH7s2QqzQNIMDRm8lNlrzFdlb7DvY95w2jEaw0oA7zrH8kU+IqcBl8klVQlmV4l0tu/0cBA6qcr7By81oubsuq8LRtmlyS0QkrsaaziGYuiSGb8n5i3mvCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03FtxWgcW+sETWc+uZAaZ7iq8kmeiZHAGsN7Wq8VazY=;
 b=ZB+rylnHj9BrzqRVt7rrgnZWo3kW82AlCQBCH9wH9bbWBM+RUBHv+cUB0bBWUJ6Lpr50AS2pOrxeSxBZv8NWjDYtHNqDeJs3OqjbZmg+A6zuhLFTSb5VK94zLlb/i4Iy01LvCL6tfauZz5w63ggKbSUWk6h/d+gBzKvAgWL4hNnGIO+9Wk9wlcxICsl23hcVlydP+OnFlPE6rAWYL0JXxHg6teT/bOTtiveewPbSMO8MuZtmQXmIOtPwElrx0twptWbLxH4At6I0/FURx6YXOWJAnAiPmqSgYqvEP0ON13Ott+UNp+L4jx9x4IalHxloSSTG0qDmbtOJtMHXDIoj9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB7522.namprd11.prod.outlook.com (2603:10b6:510:289::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 09:22:40 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.033; Wed, 6 Dec 2023
 09:22:40 +0000
Message-ID: <73119078-7483-42e0-bb1f-b696932b6cd2@intel.com>
Date: Wed, 6 Dec 2023 17:22:29 +0800
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
 <e7d399a2-a4ff-4e27-af09-a8611985648a@intel.com>
 <8a2216b0c1a945e33a18a981cbce7737a07de52d.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <8a2216b0c1a945e33a18a981cbce7737a07de52d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0170.apcprd04.prod.outlook.com (2603:1096:4::32)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB7522:EE_
X-MS-Office365-Filtering-Correlation-Id: 63344200-ea4a-4f55-6acc-08dbf63ce4df
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZkgahDMwsmrS0eSDpH2uOpukGaYRRhpk7TBJdl0ajOQlogrPZgVEdJnKwX4Rb9bO+w9+I3BMLu67VB06OWoDLX1YeF8pqvkNpEtRWf31+mVg4dS7GEDF5XAlfad+92oRScs/O2g4l7hmCTecQwvF6u4aNyaaBSeWDdXe1PHwmaEVOUcuI0HPCWC3sfDq7wxD44VMVj2fg9u952uhWYg/Odsx4jkqofbz1WBL04bRYIJrWuuho2hUyj1dZDPAE2fBXs3P+/7p0IrOdGtBvyghukzc2C+hoIqEG5si9++NYPsAgIC1h27N3GF36g4AcVv3/mhySh0dqMTuS2oB9KDXR570l74fPovZhQ4osr8yiHyUnMQ3yRFBnuxe4Wvg9k3S35lwwrpFQ9VAGlcGESmU6J5OPW08R34HdZVX1FUCcGfq8t7us6Tq7/Tek/LLeRtaxodLr+jFSukTRLBEYZKca4X32mIbsuVvpWCd4XLMQJR/94OfElL9MsOhBBcvYRekAajuUk2IFT99dn9rsregS1exOFAqhVrvXkNW+Y7v3u3IynH3A9K9rEiMia+mg4v+h2yZ1b6jnVgFsqGNiop4kaWgbLRPCcbZW9HVV3DV63fpvbZxIpeo4Vyq7mApDKjaEXAj3NZ3iTOypQcaBptCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(396003)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(82960400001)(6512007)(83380400001)(53546011)(2616005)(26005)(36756003)(86362001)(31696002)(2906002)(4326008)(8676002)(8936002)(41300700001)(5660300002)(6916009)(66476007)(66946007)(66556008)(316002)(6506007)(6666004)(478600001)(6486002)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjR1d1c0b1dFanBPN2JuQ1FFcEdWRmF5Ym9nQ1JHc1dNaC9yS0dBaXF3Vktu?=
 =?utf-8?B?Q3JXYzMrWkc3NndldTFQc3R3VnVFNjEvQ0pncHZ4dEZ3L2p5aTJLNXRtaTM0?=
 =?utf-8?B?QTlMMjlpbmQ0OURoRFEwU1pZU2sycjZVOFRvR05EN2Y1alp1dWc5UWJ5UXNm?=
 =?utf-8?B?NERHWldnaXpTeUVHR2hkSGcxNi9ZWVlwbmlCSkhpQnpOcVdENzFJWlRaWHVW?=
 =?utf-8?B?dU40eWRmUkVVWGVCSnM4bGozR09EQ3JvNXdRZzRjMzN1U09DR1ExRE1lamJW?=
 =?utf-8?B?emZYTVl6R05WZGwrZmtOdDZsK29QU3duL3lyVDU3TFR4SFhRYUxWdDIvazVi?=
 =?utf-8?B?YUsxcEQ0RUI1NFgybEY1UzZpNC9XNFJGK2lxcnBKaTBSWFJUZ3ExdG13MGlx?=
 =?utf-8?B?TlVCajh0NXNmUkJSQkVBRE01L2kvTWhzV3VZbFZGRGpsRzVWOUV4aDF0d0Nl?=
 =?utf-8?B?TVI3Z0Ztemt6UjVCNm9PZkR2dEJldVlUNmxySXhrQk1acWRoRmp5VVQ5UzdN?=
 =?utf-8?B?aEdZaWw4SytBRmhYamRMV3poUVlqWUlHbXFMZWtodmt4OWl0bnJiQlhQN0w4?=
 =?utf-8?B?SzgzQUFzUTlTUjFFN1dJUllmRXRrRjY4ZnlsZlhVeXBGVEJoTDVLSUNLOEJ0?=
 =?utf-8?B?VURPN01Ga1V1YXJmY25UUzYwdzFpNkdMU1M0bDNXK2VrZUt3Wjk0UFc5ZGFC?=
 =?utf-8?B?VU9td2lFcTlxVzJWSXdRZGNycGlJT2tuOXdMa3dDanQ0Vk5Rd3ZhNG9yeHVK?=
 =?utf-8?B?R2JrVDhRTVBMS3NHUTlUZkdybmJlOHZncGhHZVRqWmRXQzhxYUVNamh0eUE2?=
 =?utf-8?B?Uk4rWTQxdWhuSnBIend3cDdETmV0NUJrRmhMNUw2MUJIOEVxUERManZaazI5?=
 =?utf-8?B?NVh6V2daZXUrWVo3SEpoSkZES2hhNTNPYnVINmc4dXBrZ1ZHdjJaMWxjZUhM?=
 =?utf-8?B?elQxRHE3c2R2eVJ2b2MxTzN3TTVTV1pLemsrN202TC9sQ3RDckp2aEdMSkdw?=
 =?utf-8?B?TUZxQnl6RGJzZlBQM0xsb2xyWlZLRjU5Z3d2MHFObnNiK3FMbWxOY2VncUc4?=
 =?utf-8?B?dnl2TUhBK0JLRk5Rd0pwaXVGbENtSUJ5ZS9KM1JlL1JVWmh2V0J5eVpuclll?=
 =?utf-8?B?a2VyRXpEb3RvYUt6ZE4rd2RJY0dUdkRlYzJwNnc5Z2diYVhLajVHbytyWUpv?=
 =?utf-8?B?K3J0WXp2OXYrQ1BRMjdBdmhGVEVjSVJiZ1NseTlVMTQrTGVzR3dsN051cGow?=
 =?utf-8?B?YmwzcTgvMXlGbjhQeEQ4OHZNWEtPOHpOWUg5b2M0bFB0VE5OUzVLN2VrQWtk?=
 =?utf-8?B?eXpUVEdsY3cvaFNFVk4rNzdnQ1Z0Y0tKVmNtY2tBVFRNK2Y3VnhFT2x1cVBy?=
 =?utf-8?B?MlQ4dTZxcnVNcnhPU1hQTGxhQkROYVJGZytuNS9yMUdhRGlCTWt3enFjQzdN?=
 =?utf-8?B?Qzh0SUN0SzJVSkZML0NVU0t6ZkxqbEN3VFNJcnpNUEVUQzNMYzhwZUQyUWJt?=
 =?utf-8?B?ZFVjdVlTS0RGT0VoeXVXZDdBWEgrRTdmRTVDemIvdWM1Q0xZQWE3bThNOXB2?=
 =?utf-8?B?czRsVWEyRk81dzE4QjBpNkZtVy9qaXhYNnRIVjdmelpDZVlSMllkTlZwSGFR?=
 =?utf-8?B?T2dpTzdrZTExNzBGeUhoQVdzNm5LUEdYaGY1S1N2SVJvcDZOdThxSVRwbjZU?=
 =?utf-8?B?Wmg0QS8za2E3aUxyOW9FTnFYY2U0bkJORFcrUEhSM3FuQ2xJUi9SU2EwRm5w?=
 =?utf-8?B?OVZJaU1DMUZZQ3lHTTdHWUh0eWd5K3hlMlluWU9qK0R4bGlGTFcvSXVReFJW?=
 =?utf-8?B?ZmN2MmhWUm03OXZYMFdKaEhidkljTWxYdTdBcWFQWk50YjA4UnUxNWdFUEhy?=
 =?utf-8?B?bTkzOFlLSXVWOU82K3ovT2RkbnF3bTQyOWhJc0VHbFRzbnJwY1NQK05DSjJo?=
 =?utf-8?B?WjNIZzRMK2VjeE1KL1UxTWlUaEtjOVZVRi9RbVdEdkZueWcwbFJ0bXFPT2FM?=
 =?utf-8?B?OVM3UjA2djdPUjFWKzlIL1FxTXF5YXlsOCswcnA2RkxENVdGb2JZbG12emlF?=
 =?utf-8?B?MWt2b3lWOU9vTjRyVi9TN2taR3IvYWZ5RkV2MTZQNVhKdy9oVng1RGRJRVN2?=
 =?utf-8?B?QWVjcWhOMnJYU0MrRVF0SG85dlltNTViRXZ0R1hBY3M3cEZQRHVUMENKaXNR?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63344200-ea4a-4f55-6acc-08dbf63ce4df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 09:22:40.4964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOyCTUIHfOFH693Jl1b3DGGY79NvtLTBOdvS0NYLS3bVqbDkC+0WeqCu7afTqjkiXGdLOp4Fv8ySOtGMcRs7Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7522
X-OriginatorOrg: intel.com

On 12/5/2023 6:12 PM, Maxim Levitsky wrote:
> On Mon, 2023-12-04 at 16:50 +0800, Yang, Weijiang wrote:

[...]

>>>>    	vmx->nested.force_msr_bitmap_recalc = false;
>>>> @@ -2469,6 +2491,18 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>>>>    		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
>>>>    		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>>>>    			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
>>>> +
>>>> +		if (vmx->nested.nested_run_pending &&
>>> I don't think that nested.nested_run_pending check is needed.
>>> prepare_vmcs02_rare is not going to be called unless the nested run is pending.
>> But there're other paths along to call prepare_vmcs02_rare(), e.g., vmx_set_nested_state()-> nested_vmx_enter_non_root_mode()-> prepare_vmcs02_rare(), especially when L1 instead of L2 was running. In this case, nested.nested_run_pending == false,
>> we don't need to update vmcs02's fields at the point until L2 is being resumed.
> - If we restore VM from migration stream when L2 is *not running*, then prepare_vmcs02_rare won't be called,
> because nested_vmx_enter_non_root_mode will not be called, because in turn there is no nested vmcs to load.
>
> - If we restore VM from migration stream when L2 is *about to run* (KVM emulated the VMRESUME/VMLAUNCH,
> but we didn't do the actual hardware VMLAUNCH/VMRESUME on vmcs02, then the 'nested_run_pending' will be true, it will be restored
> from the migration stream.
>
> - If we migrate while nested guest was run once but didn't VMEXIT to L1 yet, then yes, nested.nested_run_pending will be false indeed,
> but we still need to setup vmcs02, otherwise it will be left with default zero values.

Thanks a lot for recapping these cases! I overlooked some nested flags before. It makes sense to remove nested.nested_run_pending.
> Remember that prior to setting nested state the VM wasn't running even once usually, unlike when the guest enters nested state normally.
>
>>>> +		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
>>>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>>>> +				vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
>>>> +				vmcs_writel(GUEST_INTR_SSP_TABLE,
>>>> +					    vmcs12->guest_ssp_tbl);
>>>> +			}
>>>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>>>> +			    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT))
>>>> +				vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
>>>> +		}
>>>>    	}
>>>>    
>>>>    	if (nested_cpu_has_xsaves(vmcs12))
>>>> @@ -4300,6 +4334,15 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>>>>    	vmcs12->guest_pending_dbg_exceptions =
>>>>    		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>>>>    
>>>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>>>> +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
>>>> +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
>>>> +	}
>>>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>>>> +	    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT)) {
>>>> +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
>>>> +	}
>>> The above code should be conditional on VM_ENTRY_LOAD_CET_STATE - if the guest (L2) state
>>> was loaded, then it must be updated on exit - this is usually how VMX works.
>> I think this is not for L2 VM_ENTRY_LOAD_CET_STATE, it happens in prepare_vmcs02_rare(). IIUC, the guest registers will be saved into VMCS fields unconditionally when vm-exit happens,
>> so these fields for L2 guest should be synced to L1 unconditionally.
> "the guest registers will be saved into VMCS fields unconditionally"
> This is not true, unless there is a bug.

I checked the latest SDM, there's no such kind of wording regarding CET entry/exit control bits. The wording comes from
the individual CET spec.:
"10.6 VM Exit
On processors that support CET, the VM exit saves the state of IA32_S_CET, SSP and IA32_INTERRUPT_SSP_TABLE_ADDR MSR to the VMCS guest-state area unconditionally."
But since it doesn't appear in SDM, I shouldn't take it for granted.

> the vmcs12 VM_ENTRY_LOAD_CET_STATE should be passed through as is to vmcs02, so if the nested guest doesn't set this bit
> the entry/exit using vmcs02 will not touch the CET state, which is unusual but allowed by the spec I think - a nested hypervisor can opt for example to save/load
> this state manually or use msr load/store lists instead.

Right although the use case should be rare, will modify the code to check VM_ENTRY_LOAD_CET_STATE. Thanks!
> Regardless of this,
> if the guest didn't set VM_ENTRY_LOAD_CET_STATE, then vmcs12 guest fields should neither be loaded on VM entry (copied to vmcs02) nor updated on VM exit,
> (that is copied back to vmcs12) this is what is written in the VMX spec.

What's the VMX spec. your're referring to here?



