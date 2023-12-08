Return-Path: <kvm+bounces-3921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5578C80A7FF
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 16:57:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BFF37B20AE4
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 15:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFB735268;
	Fri,  8 Dec 2023 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MrG6iW2y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A55BD;
	Fri,  8 Dec 2023 07:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702051043; x=1733587043;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dVDBT+o33c91Q9aSwhZHPRjLdk54VVWpojo8sREIyd4=;
  b=MrG6iW2y2zlkatUxAt/qgd9UE14QnYNMJumNoKM5a25l9ULPk8OPQ50M
   Mw/RYh83dBJCdJj6V5OMYUi9XuGEhDrQq4FVO58ZRPEpRQEZbGESMEoN2
   sOly/c6NN49Z6g4w1IO86T0CCexz2Q6GU+tKS80i2OTY6aBtwzoPj5YxX
   zQzJKefdlPxu91qSKVRbPx1X5AVersqYJK9mX5Px8/K7yDqk15zmki2V4
   DyQwdJXJoIEo7c6MhK+2q6gaZTgPOey2JWGgfTcm2jTT86TgJLWM1mZE3
   lM2vIskBbePd8F/NqcxSo6rO2/iyypzp7iIQ7PN5XEAWOhD/8lu4yDa1J
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="1503223"
X-IronPort-AV: E=Sophos;i="6.04,261,1695711600"; 
   d="scan'208";a="1503223"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2023 07:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="775833280"
X-IronPort-AV: E=Sophos;i="6.04,261,1695711600"; 
   d="scan'208";a="775833280"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Dec 2023 07:57:21 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 8 Dec 2023 07:57:21 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 8 Dec 2023 07:57:20 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 8 Dec 2023 07:57:20 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 8 Dec 2023 07:57:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmrlrHqyJBOchtWlZvmqV4EZawGvoOaHu+ln++/xqpvidgwkjicXbSRqOBEVxGr43e9HLH5316EFbUroWHTXh7pfDyINfxmqPEwVYgEYhnJGty/TFnijFVkfciI2p3RiRNftrplFE8EK+3y2HvwrtlcYsM1SfrZJPnSB+Un96vSq5JrW3iyaWhYLudEfjmgG9eJpXP/6rbxMrb0HaHQwq4Ft0oktt5Lu4b83zthAqLJSde3MY+rPxfyo+ZmbknqzPBqMSyBmL+9F2beC4K3BfBmGx9pOPzmd6knZPFBy30Eo+irwRVq1vhzg0mvDGXwQd3h6SBE0YgE/IgSZdklCkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jM1vrbtzntpf2yY2OQY06fZI+3cPoXJSsQqyLFoXy/0=;
 b=ETJeWiEAD1dJSzRyk/Zw4IcqDIxHDjRxTfMn/ZknKM2mZWuNMDxT1PVDGyqn/VI62HARXbqnhrhT44MmHlS/vFczzfjPwMQneyCGDiaxHXJCHwN/8ax1Z9+Xp6PgJIJCsfTp8BEw59sNxvhUBYP4s31E76qAUgI95c8hce8dxVAJYdni5d2TJz0ClUeQglIkSJKRKTDopuT1qk1zninRqsHTtB+uUVjqolzJNSKrC2pFushC1sEyZyd/h4/lhGg3dQObYdlAGdbF0JnmNethgDOFY9fbg53hT97nZgsZmBKchS0cxjE09mrc2ZPpFAap5C8r/G+ym4kTmjEq/1JtyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB7643.namprd11.prod.outlook.com (2603:10b6:510:27c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Fri, 8 Dec
 2023 15:57:12 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7068.028; Fri, 8 Dec 2023
 15:57:12 +0000
Message-ID: <c1ee3d5b-5c54-4eea-b3d7-7385d39bae45@intel.com>
Date: Fri, 8 Dec 2023 23:57:00 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-5-weijiang.yang@intel.com>
 <3c16bb90532fbd2ec95b5a3d42a93bbbf77c4d37.camel@redhat.com>
 <9a7052ca-9c67-45b5-ba23-dbd23e69722c@intel.com>
 <5a8c870875acc5c7e72eb3e885c12d6362f45243.camel@redhat.com>
 <888fc0db-a8de-4d42-bcd5-84479c3a8f5e@intel.com>
 <8e7b64f06fe2a8132a8f9f76d673ac663ecfd854.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <8e7b64f06fe2a8132a8f9f76d673ac663ecfd854.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0126.apcprd02.prod.outlook.com
 (2603:1096:4:188::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB7643:EE_
X-MS-Office365-Filtering-Correlation-Id: e92b10c2-32a5-4ffd-a7b9-08dbf8065719
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A7qazZ7L6Qg92IWuxb+SWO6WmQPcnNAg+OeTAgSDr6VDUCNwmZcK12ZaWTX22UWwLXgx9Dy+KC0iOTcoUCgqZ2xxs2a8S9RmwH2/YytaEV7JerpuwmFsTAlciXjulNxBZ0vvZuoezDkQZ2tPrygN2RQcGdg5fHCRf4w10jsV5dSBVy5m1amUcBRYCvd2Wfx0dckCbB04m/uMZV2uDakk/y5HhGrXNx8JO4H3i0pfllh2l13FbP9r+qnJ2zhTdYBGB6jflOfBAEQTxGRYOH8GRYkCV381VVpWGDlRChUTisb61fHO/UfWVVDu2k/ZQF43Dtwyw3s4VG1CKNup64ll3NqZIUV8WHY7brgu0KR0a0Sojlcwg+R7xX5kbzN1SwSgpALMhYdzQh1Rt0i8HasqOpcluppw0LbplVg7JACOUFxg9QU0HV+oSF1MfgG//cDWEqt4db02pbrHKQ4tn+ktxtBkXcezA1u6KDwVhVkYFSFf2Ju7fG8Id8BDa6aY1o+JXeu7QHs6zQ8MuvWvRq9j++9wzoVxGasXXig4QYNJlIP1lYntHNOWRH0WbefW15GTO4ecuroaZQZHdI4mdCdPpY1KKQUSvPixio5j/Bkr/oFjDkYTlfXgAdsOgCCWVkYQm6WQwSi3ZUXTDQmlUlleBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(366004)(376002)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(83380400001)(6666004)(6512007)(2616005)(53546011)(6506007)(26005)(66476007)(316002)(66946007)(6916009)(66556008)(41300700001)(4001150100001)(5660300002)(2906002)(86362001)(8936002)(31686004)(8676002)(36756003)(4326008)(38100700002)(82960400001)(6486002)(966005)(478600001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWk0OHc4WWNndk1wUUpocUVMd0dzS1VjRTlTSjZUL1FsVzUxMmV6OThRS0x1?=
 =?utf-8?B?ZkhGQWorVlF5WC8wYlRKSGV1Q1F6MFl2OVNPbzlTdzFKTXNldVIrelMybnhG?=
 =?utf-8?B?NldWU2tQVzM1cTlTcTVaaTBhUW4wdmkwN1pxTUJDcDdrcTFxQm5Wc0Rqczd6?=
 =?utf-8?B?cFVmY1NOZkZBNU9HQmNpQXM4bEdCczhiMUU0QWJwdTNEbHpkbEJLdWcwRUlh?=
 =?utf-8?B?RUR1Q25KU0g3bkgyMHFUSUMyK01yTDZNODJUN1NwcUpaMU0vTVFLS1dOalk2?=
 =?utf-8?B?Q1pqWDFtVjVFWWIrV0JIZ1lnZWM5WU5nVXV3aTF1cnFsbG54WnVsU2F6SVJ2?=
 =?utf-8?B?VDlPeDNtcmZhQnltQnRSQW53NEJYM25EejNBbjRjalQ2b204UFdLR3Nhbnp3?=
 =?utf-8?B?YUJGbnEwN1FKTzdPTW1wbG5XRERmZElBWFc1VHE5enAvcFg2eCtNd0V5Tjln?=
 =?utf-8?B?NmVTKy9odmRZbWpmVExtZ3ZrdVhEM0hJVldhK2s3Ym9Kb3NsY3hhZnVZYUI5?=
 =?utf-8?B?NHQySE5TVmo1NnJ3ejBDaWMrZ1MvR1pYOWtrMEJ2eE1zTmFYcndOZ0Q2Nkd5?=
 =?utf-8?B?eWtZbmZudUIzTWxHU29xMDR3ZGdvS2QwZkZkMmhpZE1QOUVjbk5Ea0xwemVE?=
 =?utf-8?B?TU5xVGcreTdKV25BNVM0WE1yemRHTUk1WVJlWm9uY0lrOTBuR2dGaGNleTlB?=
 =?utf-8?B?UmNhaU5FaGRtWVk5SWYrSjAreTMzbEt0dEhpb1hWTkJhaEgzLzdzYlI5SUV0?=
 =?utf-8?B?YURRQU9DQTJENEpGUnk2M0xraTNtWS80TllNQmJtS2dwUG1rOTVHSk45RHp4?=
 =?utf-8?B?dFFtTmxVaUJSdG1yL093SW1qdFI4YkIxRHNHV0Y3ejRGLy90MmVsNkZJanMy?=
 =?utf-8?B?RlJ1dFgxQ0tVWS9pRzh5QnExMG5JcjdiaVpCSTRkQTZReVd1ZkRsSEorNEJ0?=
 =?utf-8?B?Y2FnYkNuYXBDSkRVbDc4cjZTSnNLUkN0T3dUM1JCQy9sendQYXZaSXZZUWJU?=
 =?utf-8?B?cCt0VElUL0VBaUtrU3lFL3pBVmtCS2JjbmN0R2F5Z1czMG81STFRRGZvQjdz?=
 =?utf-8?B?T1BkVG1WU3IvZFZaTFlrSzR5a0d2TUVacTVPVGlwQXZ5M1ZiTzFiZkJnSjUz?=
 =?utf-8?B?V1JwTUdYUmt3bFZVdkZtK0tRTmtEZ2d1ckdEem82TUpzMHBQU2ZNd1hCamF2?=
 =?utf-8?B?ZGV3dndVaXlYSkt5NS95b0cyRDBwanBETjlwSEVNYzAxRU42NEpENFVVZnlR?=
 =?utf-8?B?V1BvUGF3citPTUR5ejJKeCtqblNXUlc5dmFJTnNxK3pUcmUra0ZLZWdkbFBq?=
 =?utf-8?B?M0Z6aFZKYmFmUTFpZmcrLzhzNjhrR2tlZTY1a0pOZVJNTDhWMUMzMnNlZXdE?=
 =?utf-8?B?QkFtTytjbkVQYmhLdDNEYnZkdThmeGxtV0RkbWdiM2VNd2lubkE2NmpNSlJ5?=
 =?utf-8?B?Z1lsK25MT0Z5U1A3N0pha1ZXZlNpSXJKMGZKV2xmRjZqRXBURVd4NWNmWmtG?=
 =?utf-8?B?Q242SEFmZGVZbnMzcWsyZkRFQjNRUXNDbjhsN0JYdWxqYjFjczNaSW4zeVhz?=
 =?utf-8?B?M3ZkUE5vcm9mUWZZSFRCa21OYVhUcDBsaXdRYVdvTzY1eWlNKzRYUDBMQjQ3?=
 =?utf-8?B?d21oTWEwaEFkckJJby9mRTJId2wyOGxSMTN6a3NCWXJKcDEyUXoyblNOZ044?=
 =?utf-8?B?Wm5MNVNTR3cvc2Z5MEgvUGVZZkJoZEo3T0JLeFVncnpPSHpUeUtNL2xkODd0?=
 =?utf-8?B?WXZhUW4zZm1lbkF3UGRVNk5uOGpZcVdZY3ZIaFhJOXdUK05pS29pTEh3c3Bx?=
 =?utf-8?B?ZVVST1ZwS2NsVERoQ0xEQlZ6SjNhRDhIQzREb3FLTkZKQ1I5OUNWaFgxR0JZ?=
 =?utf-8?B?TlpwdnRubEdONlNJVEIzNmNGekxxWml2VFVMbUVpREF4QmtQNHJGMjhVZG0w?=
 =?utf-8?B?citsekE4Q1ZSdU94a2ZSK0lacEtaSHpuNndoU2x0MDN1RWorRnhUY2h1ZFNo?=
 =?utf-8?B?dVY0cW5sdHI2bUNML3hRZVNaSi9YeldKM0JtZmRQOXplY1pFS3VhZkt2TThk?=
 =?utf-8?B?NnlzWmZ0WkxTNFE0NUJ3NTJYSFpoZHdDSGhaSThyQy9la3NzQk5XelltTTVj?=
 =?utf-8?B?cmd1MzNLdU9va1lLWGtQSGlBQks5bGc2M1AzV2RKTjI4VkZoZFY0d1pGYnZW?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e92b10c2-32a5-4ffd-a7b9-08dbf8065719
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 15:57:12.6647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lQZ8vq4ZAKcI0G2JpVI11mdc77xvPkPOu90/zKz+OPb0dhhr8ZydE9aEogEZ+Bt8bVKgDuITbRLzTHdyglrtIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7643
X-OriginatorOrg: intel.com

On 12/7/2023 12:11 AM, Maxim Levitsky wrote:
> On Wed, 2023-12-06 at 11:00 +0800, Yang, Weijiang wrote:
>> On 12/5/2023 5:55 PM, Maxim Levitsky wrote:
>>> On Fri, 2023-12-01 at 15:49 +0800, Yang, Weijiang wrote:
>>>> On 12/1/2023 1:33 AM, Maxim Levitsky wrote:
>>>>> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>>>>>> Define new XFEATURE_MASK_KERNEL_DYNAMIC set including the features can be
>>>>> I am not sure though that this name is correct, but I don't know if I can
>>>>> suggest a better name.
>>>> It's a symmetry of XFEATURE_MASK_USER_DYNAMIC ;-)
>>>>>> optionally enabled by kernel components, i.e., the features are required by
>>>>>> specific kernel components. Currently it's used by KVM to configure guest
>>>>>> dedicated fpstate for calculating the xfeature and fpstate storage size etc.
>>>>>>
>>>>>> The kernel dynamic xfeatures now only contain XFEATURE_CET_KERNEL, which is
>>>>>> supported by host as they're enabled in xsaves/xrstors operating xfeature set
>>>>>> (XCR0 | XSS), but the relevant CPU feature, i.e., supervisor shadow stack, is
>>>>>> not enabled in host kernel so it can be omitted for normal fpstate by default.
>>>>>>
>>>>>> Remove the kernel dynamic feature from fpu_kernel_cfg.default_features so that
>>>>>> the bits in xstate_bv and xcomp_bv are cleared and xsaves/xrstors can be
>>>>>> optimized by HW for normal fpstate.
>>>>>>
>>>>>> Suggested-by: Dave Hansen <dave.hansen@intel.com>
>>>>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>>>>> ---
>>>>>>     arch/x86/include/asm/fpu/xstate.h | 5 ++++-
>>>>>>     arch/x86/kernel/fpu/xstate.c      | 1 +
>>>>>>     2 files changed, 5 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
>>>>>> index 3b4a038d3c57..a212d3851429 100644
>>>>>> --- a/arch/x86/include/asm/fpu/xstate.h
>>>>>> +++ b/arch/x86/include/asm/fpu/xstate.h
>>>>>> @@ -46,9 +46,12 @@
>>>>>>     #define XFEATURE_MASK_USER_RESTORE	\
>>>>>>     	(XFEATURE_MASK_USER_SUPPORTED & ~XFEATURE_MASK_PKRU)
>>>>>>     
>>>>>> -/* Features which are dynamically enabled for a process on request */
>>>>>> +/* Features which are dynamically enabled per userspace request */
>>>>>>     #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
>>>>>>     
>>>>>> +/* Features which are dynamically enabled per kernel side request */
>>>>> I suggest to explain this a bit better. How about something like that:
>>>>>
>>>>> "Kernel features that are not enabled by default for all processes, but can
>>>>> be still used by some processes, for example to support guest virtualization"
>>>> It looks good to me, will apply it in next version, thanks!
>>>>
>>>>> But feel free to keep it as is or propose something else. IMHO this will
>>>>> be confusing this way or another.
>>>>>
>>>>>
>>>>> Another question: kernel already has a notion of 'independent features'
>>>>> which are currently kernel features that are enabled in IA32_XSS but not present in 'fpu_kernel_cfg.max_features'
>>>>>
>>>>> Currently only 'XFEATURE_LBR' is in this set. These features are saved/restored manually
>>>>> from independent buffer (in case of LBRs, perf code cares for this).
>>>>>
>>>>> Does it make sense to add CET_S to there as well instead of having XFEATURE_MASK_KERNEL_DYNAMIC,
>>>> CET_S here refers to PL{0,1,2}_SSP, right?
>>>>
>>>> IMHO, perf relies on dedicated code to switch LBR MSRs for various reason, e.g., overhead, the feature
>>>> owns dozens of MSRs, remove xfeature bit will offload the burden of common FPU/xsave framework.
>>> This is true, but the question that begs to be asked, is what is the true purpose of the 'independent features' is
>>> from the POV of the kernel FPU framework. IMHO these are features that the framework is not aware of, except
>>> that it enables it in IA32_XSS (and in XCR0 in the future).
>> This is the origin intention for introducing independent features(firstly called dynamic feature, renamed later), from the
>> changelog the major concern is overhead:
> Yes, and to some extent the reason why we want to have CET supervisor state not saved on normal thread's FPU state is also overhead,
> because in theory if the kernel did save it, the MSRs will be in INIT state and thus XSAVES shouldn't have any functional impact,
> even if it saves/restores them for nothing.

CET supervisor state in normal thread's FPU state won't always be in INIT state. Per SDM, it's INIT state is defined only if 3 MSRs are 0,
but if guest is using supervisor CET,  then with vCPU migration between pCPUs, more and more MSRs would hold non-zero contents.
This doesn't impact host kernel behavior because host CET_S is still disabled, but it does impact host XSAVES/XRSTORS behavior.

> In other words, as I said, independent features = features that FPU state doesn't manage, and are just optionally enabled,
> so that a custom code can do a custom xsave(s)/xrstor(s), likely from/to a custom area to save/load these features.
>
> It might make sense to rename independent features again to something like 'unmanaged features' or 'manual features' or something
> like that.
>
>
> Another interesting question that arises here, is once KVM supports arch LBRs, it will likely need to expose the XFEATURE_LBR
> to the guest and will need to context switch it similar to CET_S state, which strengthens the argument that CET_S should
> be in the same group as the 'independent features'.
>
> Depending on the performance impact, XFEATURE_LBR might even need to be dynamically allocated.

This is most likely true for fpu_guest_cfg instead of fpu_kernel_cfg, let me think it over, thanks for bring up this brilliant idea :-)

> For the reference this is the patch series that introduced the arch LBRs to KVM:
> https://www.spinics.net/lists/kvm/msg296507.html
>
>
> Best regards,
> 	Maxim Levitsky
>
>> commit f0dccc9da4c0fda049e99326f85db8c242fd781f
>> Author: Kan Liang <kan.liang@linux.intel.com>
>> Date:   Fri Jul 3 05:49:26 2020 -0700
>>
>>       x86/fpu/xstate: Support dynamic supervisor feature for LBR
>>
>> "However, the kernel should not save/restore the LBR state component at
>> each context switch, like other state components, because of the
>> following unique features of LBR:
>> - The LBR state component only contains valuable information when LBR
>>     is enabled in the perf subsystem, but for most of the time, LBR is
>>     disabled.
>> - The size of the LBR state component is huge. For the current
>>     platform, it's 808 bytes.
>> If the kernel saves/restores the LBR state at each context switch, for
>> most of the time, it is just a waste of space and cycles."
>>
>>> For the guest only features, like CET_S, it is also kind of the same thing (xsave but to guest state area only).
>>> I don't insist that we add CET_S to independent features, but I just gave an idea that maybe that is better
>>> from complexity point of view to add CET there. It's up to you to decide.
>>>
>>> Sean what do you think?
>>>
>>> Best regards,
>>> 	Maxim Levitsky
>>>
>>>
>>>> But CET only has 3 supervisor MSRs and they need to be managed together with user mode MSRs.
>>>> Enabling it in common FPU framework would make the switch/swap much easier without additional
>>>> support code.
>>>>
>>>>>     and maybe rename the
>>>>> 'XFEATURE_MASK_INDEPENDENT' to something like 'XFEATURES_THE_KERNEL_DOESNT_CARE_ABOUT'
>>>>> (terrible name, but you might think of a better name)
>>>>>
>>>>>
>>>>>> +#define XFEATURE_MASK_KERNEL_DYNAMIC	XFEATURE_MASK_CET_KERNEL
>>>>>> +
>>>>>>     /* All currently supported supervisor features */
>>>>>>     #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
>>>>>>     					    XFEATURE_MASK_CET_USER | \
>>>>>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>>>>>> index b57d909facca..ba4172172afd 100644
>>>>>> --- a/arch/x86/kernel/fpu/xstate.c
>>>>>> +++ b/arch/x86/kernel/fpu/xstate.c
>>>>>> @@ -824,6 +824,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>>>>>     	/* Clean out dynamic features from default */
>>>>>>     	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>>>>>>     	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>>>>>> +	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_KERNEL_DYNAMIC;
>>>>>>     
>>>>>>     	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
>>>>>>     	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>>>>> Best regards,
>>>>> 	Maxim Levitsky
>>>>>
>>>>>
>>>>>
>>>>>
>>>
>


