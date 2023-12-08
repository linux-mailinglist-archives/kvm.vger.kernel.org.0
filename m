Return-Path: <kvm+bounces-3918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8547D80A72D
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 16:17:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D636AB20D1E
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 15:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB4730329;
	Fri,  8 Dec 2023 15:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bvdM8bnq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70297199C;
	Fri,  8 Dec 2023 07:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702048665; x=1733584665;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1Or5tHb5fHzhjHflqJfvDkPgXU5gzbQofA88HOaBkuM=;
  b=bvdM8bnqHkjP5fxc5wP/yS4OZlQD6ugkbOYMsGx3QBpzEe1Ty02CN5HM
   LbCaHbZrIC4EbBVSTcayvC5Bp2AVlXG/FWfexVGVUeOv7MVEQOgqRnYeo
   ECU1BWtqDZHH43oOvne9wi7+4Ht+39M80wRUcCZfe811/1PfSq6uTRoBJ
   TpyNk92Rj6YOpSrOSCi6PHnkDfHhSnwew3PqR5qoGmN2ATrdRxtlpOZo3
   qHUKgvnTFVMmbB3MhcY3a/msmnyWLe8mXr5+sjx6THhZ5cuzyK3/tfd3L
   CD/SPhIOWAvXp6JM09ASyfW4SNT416m6Oo7ysRTLcnU3wysPdfiI8IlXl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="379414288"
X-IronPort-AV: E=Sophos;i="6.04,261,1695711600"; 
   d="scan'208";a="379414288"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2023 07:16:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="895564637"
X-IronPort-AV: E=Sophos;i="6.04,261,1695711600"; 
   d="scan'208";a="895564637"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Dec 2023 07:15:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 8 Dec 2023 07:15:54 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 8 Dec 2023 07:15:54 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 8 Dec 2023 07:15:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/1sLHukEd3zp0EwfqobGN1Y48rptIqbcl3MkAEWNHrw5tugmDolwb99UU7Rw2aBNFJLn4iPfCGfg2Rg3fVfkKMutF8b59+n7MtnW/PZiy6F/PaM3FRXB/j/xa/DA3xI73cHTLJGgLbKDQqJsAVc8tvCeeHy0nY4mQCAGvm7y1X3YSlk7PCCB8y7Ikd0GbWo26F+qKtYPXcR5sWmkTSfV4P5sH/caijHkFcmRJ5riTBWhLuYqPZzhgTiwVEnARiW0hSAJkzu+xkdlgSeOTwjT3CC62j2nlrWmdj4FtoYJPL5ebxZa70OcFPejNN3XUmDRD/GwNncfVE1wi/mVYD+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAM4qoOGfd1ulQMIBShJu91UrSY4h+x6SIsFPEllZmk=;
 b=DUcbE3cY/2vh8VOobtZ5EkmMyGufPUVl6BjCQ934Nxk55U7sWg+O1MTpZpg6gU/Tgmg5x4dBVmGGEI1acGUlDcZWKeh6CpBs4fXXqOz2q8wdvLRi0E5Tm9cDguEig47iHU4HEIEkdEQMWFhwDz5dtBWtnBBvkvSAOm/nKySM3sCvTND3ZWU0UVIP96An5N3pV4PeuORI92IWf1SLpehsB2XFxPKd9EjN4zu/sITy2rX7aSE4JGK85lrN8V7FH/lipbBwRxl9n73HoTX1ZZj5mcMdSU9jaWY0WFJEcPnovBT3+LFos11Cc7y8rsFz4q84ksE/gVTVbNQhDTIQqApGtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7631.namprd11.prod.outlook.com (2603:10b6:8:14e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.27; Fri, 8 Dec
 2023 15:15:51 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7068.028; Fri, 8 Dec 2023
 15:15:50 +0000
Message-ID: <26313af3-3a75-4a3c-9935-526b07a6277d@intel.com>
Date: Fri, 8 Dec 2023 23:15:39 +0800
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
 <73119078-7483-42e0-bb1f-b696932b6cd2@intel.com>
 <53a25a11927f0c4b3f689d532af2a0ee67826fa8.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <53a25a11927f0c4b3f689d532af2a0ee67826fa8.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0049.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::18)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7631:EE_
X-MS-Office365-Filtering-Correlation-Id: 70412189-88cc-4126-d636-08dbf8008ff4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlCr7uLhdEgiPzv8fiQ5X3SVaFSXPWR0RbsVrP0PiKVMOMex6Zs/H2cVMsGjVX8MvwNS2Rez2KR94NE6LF5n8CQEGzP1bYjq7RlcnzpZdt9dAuZgm5X0Gdb8SmepJU8+UhIxY1AOgwrKp2OwLJOwvpVdolLRIIy7IP5RmPwd8qFWWMco6IZKlhzD98ApxmE8cFtX/Diiq0eTkMkmo1ezcw+0vD+xXbb3/2oD9m3KWfTnL3wiB7UE4z6STBSobC+aWv7woJKqVslgn/gK1ok34aGCQLKjtNy6QYR23NWOGQ/bC/2eq6Ri0fWKrR2BzZz62kdXqIINcih3EBopBxV1XCDwEotifp5dqP/La0zZsbvqpRWBK+WccWGNoGC7NSYFlH0kxq5fG8DuC8jUYRJ749EOX1xFR5RznttDxmauKH3ILCTt9/3Dx/mH+asgw1DIacDq8W3OfAV++iTkxZHl77ntSWvAI22TC/dnsdQs1x4a7sa9MJfFFmkjRMJH5fLeEyuwjAKcTvK+41N9FKaSsmFqDuq20CMMzQMhiGkJCXIiFG1CCTBCalvt8sAxK47NexfGTi3NyAreQU0FDhi8j9rET7GeEWvrCRKS75mC8GjGKLR3w+QV1jkNi6fXKOWGNvzzNHeRG3knVNxuoqRONg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(366004)(136003)(396003)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(31686004)(53546011)(83380400001)(478600001)(2906002)(6512007)(26005)(2616005)(6666004)(6486002)(6506007)(4326008)(82960400001)(8936002)(86362001)(66556008)(5660300002)(41300700001)(36756003)(6916009)(31696002)(316002)(38100700002)(66476007)(66946007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlVURlpjNWdNejVxOFJVMXRWdVNzRUlGVGNLb3lKOVZ3Rko3NGJnYkJLSHhw?=
 =?utf-8?B?UWhlS1hKRFdobXFHTjlta3BoeFZBVGlKN3g2Q1E0Q0VqUlVIQmJFNUh3Q0Uw?=
 =?utf-8?B?OXI0V2U4UVQwMDVZZlBWclpENFJkWkcyQVNKTHVIODN4amVuUE44L0tiNk14?=
 =?utf-8?B?VjF6TGFMNys1bU4xTmFxemh4Z0pDZExWdnRPRE1KdlBpejdSeERhL0RqQnlt?=
 =?utf-8?B?eUxkWmduOENKWi9kYnVnN3ltR2RYV0MxKytqUnIyMDA2RHJrSDkxeHVVVWRW?=
 =?utf-8?B?clhZNDF2WVlrVFBEdDdvREwremJSMkVOU3RJUG9BN2hyME9TOU0yZmxSSklN?=
 =?utf-8?B?ekNGYzVOZDViSkJCeVJjVWkwQk5nUWh2ZVlmRWJUeXpIc25XK1VxQWpDUS94?=
 =?utf-8?B?YjMrTWNuMlNhTjMzNllqWXM5K05ZR0EvZnRkaXpGMC9jNkxKNmk4YVBybC9W?=
 =?utf-8?B?NmI2eVVFRTU1WG55Um1zQ0ZOWnlFQTh6eVlHTWhLMWFTUWxLL3VnK0ZGUmNT?=
 =?utf-8?B?NUJTa0lEVlgxTmNEeUwya09idmlZbEtRL0dZVytVTWRTcWlrbWloMmRDdWJr?=
 =?utf-8?B?MGNXenhWdjlsbHZMc0tRRkxxNU1mMmxPS0pWd0krN1JQT0hzU3M3RFlJSlN5?=
 =?utf-8?B?R2RRSS9JVXNDWWN0UWhzemE3ZllxbWlPZ2Znd1ppM2ZrMTVrdFVnZGdNcTNj?=
 =?utf-8?B?Sjl5MjdiL0tMSi81TnBEYStFenBhODN3TFYvRHB0cTd2VlFjUGd2K2tkRmNR?=
 =?utf-8?B?TkF4NnZxMzNvUjI1N0tzSVFZK0M5eUlPOTlUOGkxZENFaEttblhLOHozSW92?=
 =?utf-8?B?NTBDcmVQSW5xcUhmSDlkbVFYTEtBdVQ3SHdXWmJHUktEeTJjVTh3ZHhVTXlY?=
 =?utf-8?B?eE1wY3c5bGp5MXRna1V5R1p2MTVWNXNlTC94N2U4ck5lQ1NaQU40QWdyQitJ?=
 =?utf-8?B?LzluVUI2K3pOdkhaMkg5bnh5ekdWclZEbytZbmFEWEhBM0U3NXg3MDQvMFVx?=
 =?utf-8?B?TC9HWXFrSGk2aGJEK2xQZ3RFMEExcnFGNFNaNnMzRUY2dzVHSUVobmorWVFT?=
 =?utf-8?B?dzZiN3pxTm80aTFMTlp0NVkwZGI4Y0RNNEMxc3RyOFJNT3RWZUxuZFNwV0pM?=
 =?utf-8?B?UEp1TlF4OGszUEFNWHlPb0pMTzlEMDNlVmF0OUk0dHJiTkJnT2pGUENaRmZZ?=
 =?utf-8?B?QWZ3cksvVEhQNDJocHpJcEFxdjM0UXNRMnRHWklERHp3SGY0S2FKWVRmZFd6?=
 =?utf-8?B?M0ZSa0FLaGQ1U2kvQXpZZ2xTaFcvQk1YQjdjMUdEdWxHd053dk16YmdQMzhn?=
 =?utf-8?B?b0cvRCtRcm5kbmJaRjRCeVdLa1RaR3dxOWRncHRROEM0ZVE3MkNSeVV3OWEr?=
 =?utf-8?B?a1AxVUV3Q2dzdmFyd203aTZXT3FkeVBLTjloUk5LenU1SkxZc1QrUWdOZkxO?=
 =?utf-8?B?OVJXOEdUd2hXUE15b1puY2t3bzJFL1l3OUNIWC9BVzQ4ekJIVVc3amh2OUZE?=
 =?utf-8?B?bEVtOFhpMktVcFlOcjFpcXpyMHpKbkZ0cGIwTkZCL0gxd3dGUHRiTE5SdXVn?=
 =?utf-8?B?RFlURzVKUGJnZUE2VExjTWwvZGJIeHNqVjkrSTFjRmpBTjZwNVg3YVlHckJP?=
 =?utf-8?B?WjZPbUp0UGFmWU5FMlVncDl5UEhGU2hkWDQ1MW5lUElTaFRpa1hsWFJDQnBG?=
 =?utf-8?B?Y21SV2UrYlhNK2QvUytzYnY5c0dvUUtjdVRuTFhMaWZkYmloMENlYmlzWi9C?=
 =?utf-8?B?SUlYWUppdFRmdTl1YVFTY21pU1NnSUJiVHd1T1VOSDZYc1A5ZTB6M2UvaDRS?=
 =?utf-8?B?K3JCUDJVdWFHZzRRV0pYUVFuTDQzN21KS29KR2J1ems5d212dk9BR1pkRWJT?=
 =?utf-8?B?c2wwLzJ5WmhOV3RzZ3lyU0ZXb2ZjSDVYSWlKT0ppSG1nTUtlSlRubE54TExx?=
 =?utf-8?B?WmpESi82MGwxODJvNVdJZkw3RGhEdnIxRUkvMXJoTENQNFFBN3NaZG0xbGhY?=
 =?utf-8?B?K2dpZ1h1TVZsbWM5cmtEOFlqbjgzVkNGOWRDY1JTUFZScTZpVm9ZUFd5bXVC?=
 =?utf-8?B?bWtZeS8zRUx4NmxabVpFYkwwSnhhV3JaaUxlb0Q5T0ZEOW5XR2llMXVRdlhx?=
 =?utf-8?B?Ynlxb2NTVnRQWS95eFVWWTNObEdmNDJlYTI3dndmTWphWU5uQUtrUHRNQmN0?=
 =?utf-8?B?M3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 70412189-88cc-4126-d636-08dbf8008ff4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 15:15:50.6504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YDSUp9d2WkILAVimJZbfwTcpPvqwoKJK6rU8vnEK//167ItxwoLAs8Mie7P+g8WRu87Yuvoli9xevoIgu2IHFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7631
X-OriginatorOrg: intel.com

On 12/7/2023 1:24 AM, Maxim Levitsky wrote:
> On Wed, 2023-12-06 at 17:22 +0800, Yang, Weijiang wrote:
>> On 12/5/2023 6:12 PM, Maxim Levitsky wrote:
>>> On Mon, 2023-12-04 at 16:50 +0800, Yang, Weijiang wrote:
>> [...]
>>
>>>>>>     	vmx->nested.force_msr_bitmap_recalc = false;
>>>>>> @@ -2469,6 +2491,18 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>>>>>>     		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
>>>>>>     		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>>>>>>     			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
>>>>>> +
>>>>>> +		if (vmx->nested.nested_run_pending &&
>>>>> I don't think that nested.nested_run_pending check is needed.
>>>>> prepare_vmcs02_rare is not going to be called unless the nested run is pending.
>>>> But there're other paths along to call prepare_vmcs02_rare(), e.g., vmx_set_nested_state()-> nested_vmx_enter_non_root_mode()-> prepare_vmcs02_rare(), especially when L1 instead of L2 was running. In this case, nested.nested_run_pending == false,
>>>> we don't need to update vmcs02's fields at the point until L2 is being resumed.
>>> - If we restore VM from migration stream when L2 is *not running*, then prepare_vmcs02_rare won't be called,
>>> because nested_vmx_enter_non_root_mode will not be called, because in turn there is no nested vmcs to load.
>>>
>>> - If we restore VM from migration stream when L2 is *about to run* (KVM emulated the VMRESUME/VMLAUNCH,
>>> but we didn't do the actual hardware VMLAUNCH/VMRESUME on vmcs02, then the 'nested_run_pending' will be true, it will be restored
>>> from the migration stream.
>>>
>>> - If we migrate while nested guest was run once but didn't VMEXIT to L1 yet, then yes, nested.nested_run_pending will be false indeed,
>>> but we still need to setup vmcs02, otherwise it will be left with default zero values.
>> Thanks a lot for recapping these cases! I overlooked some nested flags before. It makes sense to remove nested.nested_run_pending.
>>> Remember that prior to setting nested state the VM wasn't running even once usually, unlike when the guest enters nested state normally.
>>>
>>>>>> +		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
>>>>>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>>>>>> +				vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
>>>>>> +				vmcs_writel(GUEST_INTR_SSP_TABLE,
>>>>>> +					    vmcs12->guest_ssp_tbl);
>>>>>> +			}
>>>>>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>>>>>> +			    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT))
>>>>>> +				vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
>>>>>> +		}
>>>>>>     	}
>>>>>>     
>>>>>>     	if (nested_cpu_has_xsaves(vmcs12))
>>>>>> @@ -4300,6 +4334,15 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>>>>>>     	vmcs12->guest_pending_dbg_exceptions =
>>>>>>     		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>>>>>>     
>>>>>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>>>>>> +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
>>>>>> +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
>>>>>> +	}
>>>>>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>>>>>> +	    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT)) {
>>>>>> +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
>>>>>> +	}
>>>>> The above code should be conditional on VM_ENTRY_LOAD_CET_STATE - if the guest (L2) state
>>>>> was loaded, then it must be updated on exit - this is usually how VMX works.
>>>> I think this is not for L2 VM_ENTRY_LOAD_CET_STATE, it happens in prepare_vmcs02_rare(). IIUC, the guest registers will be saved into VMCS fields unconditionally when vm-exit happens,
>>>> so these fields for L2 guest should be synced to L1 unconditionally.
>>> "the guest registers will be saved into VMCS fields unconditionally"
>>> This is not true, unless there is a bug.
>> I checked the latest SDM, there's no such kind of wording regarding CET entry/exit control bits. The wording comes from
>> the individual CET spec.:
>> "10.6 VM Exit
>> On processors that support CET, the VM exit saves the state of IA32_S_CET, SSP and IA32_INTERRUPT_SSP_TABLE_ADDR MSR to the VMCS guest-state area unconditionally."
>> But since it doesn't appear in SDM, I shouldn't take it for granted.
> SDM spec from September 2023:
>
> 28.3.1 Saving Control Registers, Debug Registers, and MSRs
>
> "If the processor supports the 1-setting of the “load CET” VM-entry control, the contents of the IA32_S_CET and
> IA32_INTERRUPT_SSP_TABLE_ADDR MSRs are saved into the corresponding fields. On processors that do not
> support Intel 64 architecture, bits 63:32 of these MSRs are not saved."
>
> Honestly it's not 100% clear if the “load CET” should be set to 1 to trigger the restore, or that this control just needs to be
> supported on the CPU.
> It does feel like you are right here, that CPU always saves the guest state, but allows to not load it on VM entry via
> “load CET” VM entry control.
>
> IMHO its best to check what the bare metal does by rigging a test by patching the host kernel to not set the 'load CET' control,
> and see if the CPU still updates the guest CET fields on the VM exit.

OK, I'll do some tests to see what's happening, thanks!
>>> the vmcs12 VM_ENTRY_LOAD_CET_STATE should be passed through as is to vmcs02, so if the nested guest doesn't set this bit
>>> the entry/exit using vmcs02 will not touch the CET state, which is unusual but allowed by the spec I think - a nested hypervisor can opt for example to save/load
>>> this state manually or use msr load/store lists instead.
>> Right although the use case should be rare, will modify the code to check VM_ENTRY_LOAD_CET_STATE. Thanks!
>
>>> Regardless of this,
>>> if the guest didn't set VM_ENTRY_LOAD_CET_STATE, then vmcs12 guest fields should neither be loaded on VM entry (copied to vmcs02) nor updated on VM exit,
>>> (that is copied back to vmcs12) this is what is written in the VMX spec.
>> What's the VMX spec. your're referring to here?
> SDM.
>
> In fact, now that I am thinking about this again, it should be OK to unconditionally copy the CET fields from vmcs12 to vmcs02, because as long as the
> VM_ENTRY_LOAD_CET_STATE is not set, the CPU should care about their values in the vmcs02.
>
> And about the other way around, assuming that I made a mistake as I said above, then the other way around is indeed unconditional.
>
>
> Sorry for a bit of a confusion.

NP, I also double check it with HW Arch and get it back.
Thanks for raising these questions!

> Best regards,
> 	Maxim Levitsky
>
>
>>
>


