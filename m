Return-Path: <kvm+bounces-467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E4E7DFFAC
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 09:18:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 559F61C21019
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 08:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45B5847C;
	Fri,  3 Nov 2023 08:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WJBOcKZp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F6D79FD
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 08:18:44 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D0A123;
	Fri,  3 Nov 2023 01:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698999520; x=1730535520;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ASIKtwNvUoP7c+YQ5YGE8OhWPODStCFhIfDD3tZxoIw=;
  b=WJBOcKZpmfH6z5geA4wJYKAZnFpsIhSZs8YAuCoUbUMwrZcdh8fQAxN0
   nYrk5uIcJ2DLLxvAB6Eo2yKK1ABNWFWCNav0+bNElez3ueRxtMKAiiOHb
   Yp+iii2tEmUqPM1yDjQ/RPaHFt3XYNmtaEL5RrWiU9E4K9+XAEPaep8qf
   E5emcigxVPguW+/xYfuEHxqAT8I+L9etAE4ryVhZbzQvyIartbgEEVYpF
   qM5uGNaYqDvWJufnVgpxsD/P2w1EBGZNXaSN+SJNqVCkNCqSbXA7mn/p3
   dJweOaE/PaESwbP6OKfABiFCudgssEMwrhbtxNpbYqdjDFB+DO1huNJcF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="455393150"
X-IronPort-AV: E=Sophos;i="6.03,273,1694761200"; 
   d="scan'208";a="455393150"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2023 01:18:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="852200460"
X-IronPort-AV: E=Sophos;i="6.03,273,1694761200"; 
   d="scan'208";a="852200460"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Nov 2023 01:18:39 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 3 Nov 2023 01:18:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 3 Nov 2023 01:18:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 3 Nov 2023 01:18:38 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 3 Nov 2023 01:18:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPijRy+GHeRvqxXBZmvKflvGaMnSDWSjdEAH91n3UFKhR2sRy71r/oIfcH5QmMj+RgGNqPaGT0ygwuB5NBrukZtV9GZtaFc9BFTAmn3EY0nAD8gb77ra3IcgbyAClwY06cYsWP/JSiOQwnx0GDfvFUV96uzeMTBrxi63Hg/He+P/bSwtWfRJ1GMGMIbs9dQ/M4yWMTBQHpKhXULwBN95cgub1W1IDKm6tT30YE2K9ksqDUqxDZXg7Yx2PjpMrQ9EUwaTTuVy0xdI6x3PVsWf2lcaZ9KPWOJ/8YrMpbQ5xwLk4gdfQRUSwywp3cqcEDZ9IA0/KRfU9sWCGkvm8vHMiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkjZ2DxEA9tTgT01lW2eJGR9hpMnE9TrFEtL4TL5YzA=;
 b=PCHNG9MJ2zYOATvXRpRmpobneDzn3x/QE4w3qa+ZLW+ncq26XnQjbi5WIqvMbCi0cUAbYv7ckoo4/hHR1D98vhzO5jfJS66bovh/J2BPAJ/jT2qoRq1GW0GN0wVC+CTxbOOdGBex1tHEoNaArjVY/Xn0F41e3pPLBgasHTvPQJkwPwqINQQ0RRn62EtF/n3x+hMOE0jYODyUQdmYnPAvli3oNlPD4d1/rWyPvEJREezHHGi1u3RLdMpdkKbTAW5gDK/dXgejEXSeRwLKnr3JusOatkLp/bN8P1Ah4AxvnJBO8tB6ZCofe5gKKPoXGK8EOs/ThTwJo2n4hebz4OBLOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB6546.namprd11.prod.outlook.com (2603:10b6:510:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.21; Fri, 3 Nov
 2023 08:18:34 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.6954.021; Fri, 3 Nov 2023
 08:18:34 +0000
Message-ID: <d1166177-c0ab-a8a5-94a6-e4e7ebdeb1c0@intel.com>
Date: Fri, 3 Nov 2023 16:18:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 19/25] KVM: VMX: Emulate read and write to CET MSRs
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-20-weijiang.yang@intel.com>
 <d67fe0ca19f7aef855aa376ada0fc96a66ca0d4f.camel@redhat.com>
 <ZUJ9fDuQUNe9BLUA@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZUJ9fDuQUNe9BLUA@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::33)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB6546:EE_
X-MS-Office365-Filtering-Correlation-Id: 0faa447d-ab4b-4358-d905-08dbdc457907
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WjWVdNB33yFsd3yLjts83brzXBMUssv1gEQgssmaZCEn03Pq7vAwe/TMPlBLBqciMhVZUF5xX4LLDkcFtyoZPmfs681msIrlAAwEz70Zo9ia4G9nVL2L+XtRsKifC/zNi7gosAWJL67n7A88WnknaUCMV7oeyw8p0HumJZfE6veBKztz2joKG98lF1MZe7pq/6AI4IrRLeldOyHHUgqXFPhCzmFXU3O35InwIU3NJ2v8r+VB8K9MZapro2vZrXC231Toyz6tNViiH8Y/h3vuYkybr0CU4oQZX52reAIliCWOUpISasJnaanFcLB8+Jq5kLTM8lTMYhBn7Z7s5HislI6315avlX0T+LijjsLuMqtHF0Mug+k+3uDJjsQYx4CFT1JqFyiwQiUt1Fo5JmwmMghcKYtzjfduJe14FUIYDq/lVAx/yDmZ7Ps3XEAR7rwFtWksk7E7Q54id5xS2C3TcEtkiowrMrc1I96Cf25CoC1lrjON3kyr1r48Z9LSIHAoRT/WA/96aDEZiRK3msUi+l2fhaCBRYwu4mHBuivzYscWTK5vDpcEHJY48hldbHWLPhNDvPWYGnGGUENk9IuSyyoHqHykbjd+GjXaAfRI19b9V4EPGxqdwDzSHZgEN6MjVN0RaXy32JP+zvo8EKNa4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(366004)(346002)(136003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(2616005)(82960400001)(6512007)(8676002)(26005)(478600001)(6486002)(5660300002)(36756003)(4326008)(41300700001)(86362001)(31696002)(2906002)(8936002)(66556008)(6916009)(66476007)(316002)(66946007)(53546011)(6666004)(6506007)(31686004)(38100700002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RU9aY3k1NjZBS1RYYjJjaHhJZmtZVGhBQ0RrNlVBbStyUjJzT2FSZXBxNDU1?=
 =?utf-8?B?MlZQbVg4M0FYWEJ0Y2VHRjVuMnphc0dVQVBrVFhUSnVlRVJjekFDOHFvbVVl?=
 =?utf-8?B?TXJCUGtCVHNCaHN1R1ptQkk3YU5PcGNvRXg0dWZzbXYvZkRxN3hKV1BUTmlP?=
 =?utf-8?B?eTdkTGRiNjJtd0M0RkdTRkNNTVJ1MUFWTy9MdURpSGpvOWlzRlFxQ1JabWth?=
 =?utf-8?B?OE1yZUVpYS9hbGtVaVFmOUNaNnFjRENiQjA3Q01KZStsN0VhcW1GOFdmMEs4?=
 =?utf-8?B?RGRyUFIrbURWbSs3SCs0N21UQ3RZU0Y0UG1Fd21vN3UySUQwNEo5UG94RkJU?=
 =?utf-8?B?Q0x0NDIzSTFwdUNNaTdPOFFlTTgzUkpVczFHSEZ4RUxHWU8ybnoxcnVycjI1?=
 =?utf-8?B?bWxlaldqekk5WEpHUzNnOU41enNvV0h0Z1JrVGZJaFpDaHNxY3l5TG1qZmlW?=
 =?utf-8?B?TGtxWnhFZ1FGVDRsNGVhRG1oSXRzV3U0eGNsVVdiV2lmeisxOUFPMDd1UFVz?=
 =?utf-8?B?Z294QXdKZDh1cDNzZGlROUY0bVBkQmZUMGpMRDlZR0NrZ2h6bkxDSEZLNXRY?=
 =?utf-8?B?VmZxdC93MElOd3V6ck85T1NBMmVzbjArU2RSdmhnSTdyVXJVdGFGRHpwbEVo?=
 =?utf-8?B?b1BueUNVUGlUUHplaWJadDgyM2Ixc1FldVNFUmRPZDhGdm56dERENWtjR0JC?=
 =?utf-8?B?K241ZUtpMGNJUkUyNTliMlFMalRwdUduYTJ1dHVVRkZQM0llRWNtYmswU0ZQ?=
 =?utf-8?B?SFBWeWlmV09tdHdwN25LOGlWQWhEUHRyL0djT3dhV0xCRFRJZy9od0x2TW0r?=
 =?utf-8?B?Ujk5NlM1VlVaM2J0THExUmQ4Y0NUNzdOSmZIc0xONGhYNFFVSFNHVTN6czcx?=
 =?utf-8?B?YnVPVTZMdFFlaWxFbFRWQkE0dVVVcWVsYXFQcm1kYWwyQVFWbVcrL0JHek5I?=
 =?utf-8?B?MU1DblQxNDQ3ZGU0WW9XUHQyaDdISGpneEFMd2tHNno0UXVYM3h0NWxvQlBZ?=
 =?utf-8?B?bXRMV1N3TGRjYWNVZXRuSmcwT0tEQU54cWlyMUJMSzNiTzFoamxDTlpmOGdX?=
 =?utf-8?B?SVUxRS9FOU9OYmdDcHRaQm54MytjQmRSRUhrYmhrVTNvU2xYUHMxVjBWVGRB?=
 =?utf-8?B?YlBGdnl6TTdXK2U1TXQweVRoU3JDVDBPM2VWNVp2VGpJaVZ2bzl2SmppRHpl?=
 =?utf-8?B?ZDNselJrbUxNYmtNalArTldPTjRNYkp6TDlua2xXR3NwMHR5MXJJTHJybito?=
 =?utf-8?B?Z2J6MElmbFZEZ1ZDSWdueVZ2U1lBaUdHSG82SDZ0aW9FdUJyNVlhZGtTbnpJ?=
 =?utf-8?B?NE1wbHZ6U2QrWFhvR2IxWUVodnlJRS9sa0JMTHVKZHIwb1ZwTWlRMzFQcnE3?=
 =?utf-8?B?cHE1akI4VklmRU1NSWFoMWtvMHRKendFbDhjZGcyTUtSZEhYejFlMlBrdmhG?=
 =?utf-8?B?RExUZWFiZHVZa29leHREaFhvRGZMdktRcy95RHhaUzgwcFQxZHk3Yk9vNWlR?=
 =?utf-8?B?aGtYZkRVeHY4bW9rb3FTays3b0FVbkFIRG9lbjFybnJVaXFHU3BQWGNNVnVj?=
 =?utf-8?B?alpjakhVV2o4VHk4aVJTYS93VnFQak85ZSsyc1lHZTQ1Z3ZJSTdjSmVnRmVP?=
 =?utf-8?B?bnNOTVIybys1OUgwTEc0Q0g5T2dwUy9ETmFlTHdMVDhXNnNvTWpTYVVOOFJv?=
 =?utf-8?B?bmQvblFaak9mZmRvZmJKOTZZQWVGdlZJd3BaaWlpQmRnUENQaENqRmlzT1o4?=
 =?utf-8?B?Zk1ReFl1OXpjMDA1MUducWpkbDc2UjR6T3g5czQzcUorMmx2N3p3NlNsUm1T?=
 =?utf-8?B?dGo2WlQ3Y29ZRlBGWXZJeUkxQTdBZVBkRjNqM2lBZmdjeDhsNFl0VDBUd21T?=
 =?utf-8?B?cU9nYU5pTGJ4Z3hHTkxpMWx1bXZZdmoxK3o3dHBWSmJ5TlMrNDdLRzJjYkRZ?=
 =?utf-8?B?eUkyZWZEM3N4UDdSeUZ1cEU2MUlrdkxCWFNGSW9LVElKQmp6ZkpwS1VQZnJS?=
 =?utf-8?B?WDM4dmxNWDE0bE5xdER6aTVsbFlzT3hJUElGamp0QUwzb1dxT24vREZ2M09D?=
 =?utf-8?B?Y04yWGJvU25HMGJ6WW1ZY2dDRlkvWFJseGtESU5qTnB5VFNoUUpTNklETWIr?=
 =?utf-8?B?ZkNLYVNhNUd3VENsRng3ak8xODhwUGV0Ym1ORHpYUjhYNitvdXFqN2dVNmNB?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0faa447d-ab4b-4358-d905-08dbdc457907
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2023 08:18:34.6285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xtPbpZcZQznjpg52B3M5wrXUrRKzzP1+DHSzemILS6a9u7DM4UL6wOqqS371J3QckZQPQ2/7CpO50f5B/XDEzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6546
X-OriginatorOrg: intel.com

On 11/2/2023 12:31 AM, Sean Christopherson wrote:
> On Tue, Oct 31, 2023, Maxim Levitsky wrote:
>> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
>>> Add emulation interface for CET MSR access. The emulation code is split
>>> into common part and vendor specific part. The former does common check
>>> for MSRs and reads/writes directly from/to XSAVE-managed MSRs via the
>>> helpers while the latter accesses the MSRs linked to VMCS fields.
>>>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> ---
> ...
>
>>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>>> +	case MSR_KVM_SSP:
>>> +		if (host_msr_reset && kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>>> +			break;
>>> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
>>> +			return 1;
>>> +		if (index == MSR_KVM_SSP && !host_initiated)
>>> +			return 1;
>>> +		if (is_noncanonical_address(data, vcpu))
>>> +			return 1;
>>> +		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
>>> +			return 1;
>>> +		break;
>> Once again I'll prefer to have an ioctl for setting/getting SSP, this will
>> make the above code simpler (e.g there will be no need to check that write
>> comes from the host/etc).
> I don't think an ioctl() would be simpler overall, especially when factoring in
> userspace.  With a synthetic MSR, we get the following quite cheaply:
>
>   1. Enumerating support to userspace.
>   2. Save/restore of the value, e.g. for live migration.
>   3. Vendor hooks for propagating values to/from the VMCS/VMCB.
>
> For an ioctl(), #1 would require a capability, #2 (and #1 to some extent) would
> require new userspace flows, and #3 would require new kvm_x86_ops hooks.
>
> The synthetic MSR adds a small amount of messiness, as does bundling
> MSR_IA32_INT_SSP_TAB with the other shadow stack MSRs.  The bulk of the mess comes
> from the need to allow userspace to write '0' when KVM enumerated supported to
> userspace.
>
> If we isolate MSR_IA32_INT_SSP_TAB, that'll help with the synthetic MSR and with
> MSR_IA32_INT_SSP_TAB.  For the unfortunate "host reset" behavior, the best idea I
> came up with is to add a helper.  It's still a bit ugly, but the ugliness is
> contained in a helper and IMO makes it much easier to follow the case statements.

Frankly speaking, existing code is not hard to understand to me :-), the handling for MSR_KVM_SSP
and MSR_IA32_INT_SSP_TAB is straightforward if audiences read the related spec.
But I'll take your advice and enclose below changes. Thanks!
> get:
>
> 	case MSR_IA32_INT_SSP_TAB:
> 		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) ||
> 		    !guest_cpuid_has(vcpu, X86_FEATURE_LM))
> 			return 1;
> 		break;
> 	case MSR_KVM_SSP:
> 		if (!host_initiated)
> 			return 1;
> 		fallthrough;
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> 		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> 			return 1;
> 		break;
>
> static bool is_set_cet_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u64 data,
> 				   bool host_initiated)
> {
> 	bool any_cet = index == MSR_IA32_S_CET || index == MSR_IA32_U_CET;
>
> 	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
> 		return true;
>
> 	if (any_cet && guest_can_use(vcpu, X86_FEATURE_IBT))
> 		return true;
>
> 	/*
> 	 * If KVM supports the MSR, i.e. has enumerated the MSR existence to
> 	 * userspace, then userspace is allowed to write '0' irrespective of
> 	 * whether or not the MSR is exposed to the guest.
> 	 */
> 	if (!host_initiated || data)
> 		return false;
> 	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> 		return true;
>
> 	return any_cet && kvm_cpu_cap_has(X86_FEATURE_IBT);
> }
>
> set:
> 	case MSR_IA32_U_CET:
> 	case MSR_IA32_S_CET:
> 		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
> 			return 1;
> 		if (data & CET_US_RESERVED_BITS)
> 			return 1;
> 		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> 		    (data & CET_US_SHSTK_MASK_BITS))
> 			return 1;
> 		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
> 		    (data & CET_US_IBT_MASK_BITS))
> 			return 1;
> 		if (!IS_ALIGNED(CET_US_LEGACY_BITMAP_BASE(data), 4))
> 			return 1;
>
> 		/* IBT can be suppressed iff the TRACKER isn't WAIT_ENDBR. */
> 		if ((data & CET_SUPPRESS) && (data & CET_WAIT_ENDBR))
> 			return 1;
> 		break;
> 	case MSR_IA32_INT_SSP_TAB:
> 		if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
> 			return 1;
>
> 		if (is_noncanonical_address(data, vcpu))
> 			return 1;
> 		break;
> 	case MSR_KVM_SSP:
> 		if (!host_initiated)
> 			return 1;
> 		fallthrough;
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> 		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
> 			return 1;
> 		if (is_noncanonical_address(data, vcpu))
> 			return 1;
> 		if (!IS_ALIGNED(data, 4))
> 			return 1;
> 		break;
> 	}


