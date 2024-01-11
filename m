Return-Path: <kvm+bounces-6095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B48882B125
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 15:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B99AFB271B6
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 14:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A695F4C3C4;
	Thu, 11 Jan 2024 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eOfom6RK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C0B4B5A7;
	Thu, 11 Jan 2024 14:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704985032; x=1736521032;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V8BOLBayBn6d36sm1wVVfVcP6q5WrpyPAXHaTbt/Xh8=;
  b=eOfom6RKVtgE44ACoz1j1+5B/zFm/hDEGzvqn8VsjXLXN5YpEGDI6u0L
   eZb7mD31+Ni/iRab8Y0o2YNzSJLyPsCnJx7C5E25dKbT9EvtFYXin46ho
   /FNP09+YvJXFbHu6zacyVoulBcidjVsKJQvLFjObeh59o87XRVoe9B03y
   GCnQBWFWMcHqvRQoFF5DeNyPHgLoQxlSZ4vehAaNwcYc5sB5aXaEYI3ah
   CsDq/cvOl6F3iWTC8o2t30QebwD6gcNHK+8laznkJMvwoV5DUZNKzyJVD
   CsmtMc/RVOApBqQQpMeVTcy3egI6CxBtYDf36dyLL4yE3/fpRq8n2jQaK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="6232111"
X-IronPort-AV: E=Sophos;i="6.04,186,1695711600"; 
   d="scan'208";a="6232111"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 06:57:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="852972428"
X-IronPort-AV: E=Sophos;i="6.04,186,1695711600"; 
   d="scan'208";a="852972428"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jan 2024 06:57:11 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jan 2024 06:57:10 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jan 2024 06:57:10 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Jan 2024 06:57:10 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Jan 2024 06:57:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWyCAbOr9cFwttSgc9PusZQx14JuSm2/qcLzWd/D1xFtmre27IG5nb2USYMTGbAmLuYMlHvBZZ1hlYSiWZT2N/uJnYWbKijehkFxOaRaUPBGZkYPsJXiz8ueYGTSNx3IqnzrVUzzpLGfRR6rRdxtXXG0FGlacMwhwEU1oRnLqVxjGzD2KUFhTxFWF/SOQkIOT8YzX4dorePc634IDflgWBPKEwGB29qb9Ik6lJh7BeAZLiTg+zVpyVxKrIICTBDHdXBVKS4Q6KvotSCqcJD7fScLKcdyYvj45BfBsPLUOXHvN2rit8Cc4yvsbzdjqPg0N2wjYZlnwTl+LQoePyaE1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vccGwbih76cJjcklRCb/p4g1IQdSnWkWKbyZeCAbldo=;
 b=jqnw8wiCiVtYMqdSLet8UudMbky74nAWJKvLi0zQYNSwr7j3jUZ2TbQTfeNBu8tC40J1ic/P4lGCXoLEbh/uSjVA+cQNIglciumxN3ryLGcjEj2+Jbk/F2ak4r/mEFS4KE6r+i3FAWTx2Uvi7J1LQm2crY20O5fgzk4WChtmZl/o39qe3o7iAlqIQeAm9NQ/Q37QTnUu3sfQesCh/Y61b4NTD406FqwtgbyBAcGg5JQvnjAIbxRzuh/SAYaevMiLKAnMbgUpHKp7kOQ43bTwS7go1PC+y4QUaJeiefBdLm1QU48G9KHzK3W6kMKUNajxUnYPBAUytf/lFamNRPYd+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CO1PR11MB5186.namprd11.prod.outlook.com (2603:10b6:303:9b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.19; Thu, 11 Jan
 2024 14:57:08 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7181.018; Thu, 11 Jan 2024
 14:57:07 +0000
Message-ID: <cf043809-430a-4072-b0fd-201cd469b602@intel.com>
Date: Thu, 11 Jan 2024 22:56:55 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao
	<chao.gao@intel.com>, Dave Hansen <dave.hansen@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com"
	<john.allen@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
 <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com>
 <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
 <ZZdLG5W5u19PsnTo@google.com>
 <a2344e2143ef2b9eca0d153c86091e58e596709d.camel@intel.com>
 <ZZdSSzCqvd-3sdBL@google.com>
 <8f070910-2b2e-425d-995e-dfa03a7695de@intel.com>
 <ZZgsipXoXTKyvCZT@google.com>
 <06fdd362-cb7f-47df-9d1a-9b85d2ed05b5@intel.com>
 <ZZ1h9GW93ckc3FlE@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZZ1h9GW93ckc3FlE@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0044.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::8) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CO1PR11MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: f048a5aa-51d8-4b5f-0158-08dc12b594d2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WIv2I4MbnSMyrrqlBIowAETyi0AJyL5y+hZNs49jGGqSZUCixTYWXVG6KXx0Z0uxyDrVzRjV0NlEUJ+7Q9YoQQxScnXN0E3FH5ft0+/qPV8Y0uiWTs25etjFV0RlG1mTMv38Fvs6bx9OrMJwrFIqPtKmzztKEjVxHD1lAA0DseBgLcYd73ZysFcCBYiNxt4HmVfW9Al6RDHMl8bcuHM7y4aS7TbcXFLIdBjR/WXCQyrdiPy0r5yAcfrDo6M1o5KfYHofNrN7TKckVBmQLmp5Vxayl5jEN3jzb5AS6nbB8ROSDVjHndpU3+COR5P29ivFtjAUq7nSlfVEVWRXjI9NJVD/CdSN/cIfAoio+MHKNGDxrquHNFJFxiGsp0OHo2SykXzS5vZMqs77QKN3bmulKx8wePSn9dwet2TaEUAQ+ponPU6b/E4kOLN2VkttWSxj9lwUWbeRzE1a8ukLb3LacX3+4J84CwVJ8Z+rpbrUUU24D7GqNJsLEE4fxrwi5w/x8xGXa97mStJEgjM7BYQDGKOomTl+AOded4yTVZPwBA2UfKaQyFj+/pHC3zw9BH8E/rG6hVlJaqR+jujfJhT/7AA8cX7oEBWxNBCGROc0i6SP+62DOm128BFZnFIHYTsrjzJ+GinMhX3St3YGNNrJag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(366004)(376002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(82960400001)(86362001)(31696002)(41300700001)(36756003)(38100700002)(478600001)(8676002)(66476007)(66556008)(316002)(4326008)(8936002)(54906003)(6916009)(66946007)(26005)(6666004)(2906002)(2616005)(6506007)(53546011)(6512007)(5660300002)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3VPSE5Hd3pFQ1BWZjNNZlorS2hFUUx2cTNrMGxQRHdpdCtUWmppWFgxUlk5?=
 =?utf-8?B?QU9xVFFTdGpFSVdYZERKeXhXemM4VE9Ub1d3WWhYNnovUkhPeDJ4T0U5djRj?=
 =?utf-8?B?SThKTVNEWTdOclc0WmQ3cG12YXkwWVJuU2t0eFg0RjJHK1FhaVo4OHBHNi9T?=
 =?utf-8?B?QXJaTkkzM1lKN2JYbWdJVnRDZW84dWNzTDhUeU9xYUNScXF2ZTlMQndJd1NY?=
 =?utf-8?B?MHVvUWlDaFJRRWhmWVZISFcxSnJCbXZHMTV5K1hjUVUxNXFhcytSWGwwclM3?=
 =?utf-8?B?TTNEQTRHdlpYd3NQWFBVNmhrd0hLa3ovS0tSUWxwRDJmZGhab0VkOS9INWZa?=
 =?utf-8?B?cVJQRmNIMTlSclpTcVhUT0xiT1Jjb1hvT0JoWGVRa05FWk8vK08xU1I1NFVL?=
 =?utf-8?B?VkhOK0FtOTFVaWRCeGtuQzdBYnpUODhvRjRLTmtpdzJFVUJJV1h5eUFMYzlK?=
 =?utf-8?B?RnIwTjlVK1pTN2pPWW5zcFY0VEgwUkdKWndCeHZ3M09pTmtKeTZPTi9qM1RE?=
 =?utf-8?B?MU9WK1dscG9OVy9FMTZwYms4N3lWbWQ5bXoyRG9wdnh6VTVMQ3daWkx0VHZr?=
 =?utf-8?B?cTFwT2lDN2xYT1E2VVRET0U4T0RMY2ZIZU13U3prT2ZwN0Eyd2kydWlwUHZn?=
 =?utf-8?B?UHdyQi9QRVNCVmJXaFFUZU9lUVJ2MlorNm9IZ0dDdWJCNDY5SGk1b1FvMVRT?=
 =?utf-8?B?eG9JcSszNTYxMytyaWVxYnRKTlRtL3NTMGhlUGRJMFMreUhTU3hoUlg1NFYy?=
 =?utf-8?B?c1dSYm1vYzU2UlBxQzdQdkhQWkIzVElsay9VQTlhSUNsNzQ2VFk2TURBUDd5?=
 =?utf-8?B?KzRucStJem93WVByL2hnaWJ6dTNzVi9QRmJHdjdOYnRQNXhaYUc0ZG8xc055?=
 =?utf-8?B?d3Z5NEpMRVlUSHNjUGZFc3FiRGhoQ2d4ZlFjQnM1Wm9WbzZqZXRaMDFvQm8x?=
 =?utf-8?B?bjJKU2JLcEtZR1BXVGRHc1UxNlFqV25qVnp5b1AvZWNreXk2eWJuUlVsdVNm?=
 =?utf-8?B?QXNBVkhTSFVla0ZscWtJK3dvNmtTUFl0RTV2bHNkR1NnRHc2N012R21zOTc1?=
 =?utf-8?B?MmJobjR0NzQyeDFoN2Zzell2T2kvV3pQbW5HcDJoWTAvc0k3OEIrUTZoZ0p1?=
 =?utf-8?B?cTNrYm9lVkp5VUVwek11c3krZ1dBUlQ4YkFMMUFud21DMGF1Q3hMSW1EbU5z?=
 =?utf-8?B?dEM3Q1Zld2k3RXJsTmlBK0NCT28xY3Z2NHFQZlR5UE9NemtqMThRekFtZDBk?=
 =?utf-8?B?ZzZiU2YxaXJLdHIvTUY1ZTl3VCt3MUFwQkVQNmpGcWx4cGpwazUzSWtpbEx6?=
 =?utf-8?B?cVNmT3pqcEpXbTZCNVdZY2ZIK09TU1ozRG9sbm1CMVd1WmR2OHRYL1JrM3hT?=
 =?utf-8?B?UTVNNktLSVBaNUxDMWQzSlhaT2xaSXVIREFwQlBvZ2wvUHQrWDRKNURFaFpL?=
 =?utf-8?B?SU84NnBmMk9KUjNUdFQyOVRudEFNV2RzKzI3TEx4R2lIWnVPbkduWWlFU3Qv?=
 =?utf-8?B?RnhoWlFpRXJIeHNNT2RPVWhPcHlVSklVeFpjTE10UFBZZzBNUS8xUGh3eHE0?=
 =?utf-8?B?ekx3ZHF0TjVZdDhEckF5TnM2a0JFOVdwTXhXaXd3eENTTXg5NGVyWmlHcTdz?=
 =?utf-8?B?Q2VxQ0NNdS9WZXh0SlZEdjJpV2g0RkFmd2pxblhmR2FPbnVXWVlrelNjUWVl?=
 =?utf-8?B?eWxLbUV3dE1NYnlTeEJ6Ynl1RlQxcW5LRk9CaEI3bmRtcWZRQXByVnF1S3h4?=
 =?utf-8?B?TXN6V0p5TWlJdURGdkNRSDQzTVpTKzNZT2REeEZucXJVc3k3TzdiRW42bHJJ?=
 =?utf-8?B?MjYxUHRhQmFHdXZHeDdSb2FKSStKTE9wWlhhQ3VkdG5qakJpNjIxbCtISWd5?=
 =?utf-8?B?N2VkeVA2TXdRQ0phVC8wTlp0dzNHR25Ddkd0WXNQRW1vWFBrTEFtRXBveHVS?=
 =?utf-8?B?NUxIaDQ4dWRMWFRRRzJvL0pGQzQyeEN3RTNVcjFmenBmTkRIaWtFOGM3MGly?=
 =?utf-8?B?TkdGMlZML2NrY1RON0Jhbk43RFNVS1hYT0tPVXR3WmNDWFBieC8yRmxzT25Q?=
 =?utf-8?B?aDVZdGc1M0VlMko2OHE3aXVZZmNzVlZzcHpDVkszNDB5ZFhOZDRvU3dsYVdh?=
 =?utf-8?B?c1ZVSlBZRkFVK1A0MG0zZkJTck16WnVJWHBTeWd3bFh0ekxkR1dJeTZKaHpu?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f048a5aa-51d8-4b5f-0158-08dc12b594d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2024 14:57:07.8849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t17Vx6N3hp2xx9cJHwV7hP2kauZSX7o5QYpKZPMtT2H4RECC67wfxTUWElcmysWfEj0buUa94HAPsw6ESfyRcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5186
X-OriginatorOrg: intel.com

On 1/9/2024 11:10 PM, Sean Christopherson wrote:
> On Mon, Jan 08, 2024, Weijiang Yang wrote:
>> On 1/6/2024 12:21 AM, Sean Christopherson wrote:
>>> On Fri, Jan 05, 2024, Weijiang Yang wrote:
>>>> On 1/5/2024 8:54 AM, Sean Christopherson wrote:
>>>>> On Fri, Jan 05, 2024, Rick P Edgecombe wrote:
>>>>>>> For CALL/RET (and presumably any branch instructions with IBT?) other
>>>>>>> instructions that are directly affected by CET, the simplest thing would
>>>>>>> probably be to disable those in KVM's emulator if shadow stacks and/or IBT
>>>>>>> are enabled, and let KVM's failure paths take it from there.
>>>>>> Right, that is what I was wondering might be the normal solution for
>>>>>> situations like this.
>>>>> If KVM can't emulate something, it either retries the instruction (with some
>>>>> decent logic to guard against infinite retries) or punts to userspace.
>>>> What kind of error is proper if KVM has to punt to userspace?
>>> KVM_INTERNAL_ERROR_EMULATION.  See prepare_emulation_failure_exit().
>>>
>>>> Or just inject #UD into guest on detecting this case?
>>> No, do not inject #UD or do anything else that deviates from architecturally
>>> defined behavior.
>> Thanks!
>> But based on current KVM implementation and patch 24, seems that if CET is exposed
>> to guest, the emulation code or shadow paging mode couldn't be activated at the same time:
> No, requiring unrestricted guest only disables the paths where KVM *delibeately*
> emulates the entire guest code stream.  In no way, shape, or form does it prevent
> KVM from attempting to emulate arbitrary instructions.

Yes, also need to prevent sporadic emulation, how about adding below patch in emulator?


diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e223043ef5b2..e817d8560ceb 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -178,6 +178,7 @@
  #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
  #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
  #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
+#define IsProtected ((u64)1 << 57)  /* Instruction is protected by CET. */

  #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)

@@ -4098,9 +4099,9 @@ static const struct opcode group4[] = {
  static const struct opcode group5[] = {
         F(DstMem | SrcNone | Lock,              em_inc),
         F(DstMem | SrcNone | Lock,              em_dec),
-       I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
-       I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
-       I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
+       I(SrcMem | NearBranch | IsBranch | IsProtected, em_call_near_abs),
+       I(SrcMemFAddr | ImplicitOps | IsBranch | IsProtected, em_call_far),
+       I(SrcMem | NearBranch | IsBranch | IsProtected, em_jmp_abs),
         I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
         I(SrcMem | Stack | TwoMemOp,            em_push), D(Undefined),
  };
@@ -4362,11 +4363,11 @@ static const struct opcode opcode_table[256] = {
         /* 0xC8 - 0xCF */
         I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
         I(Stack | IsBranch, em_leave),
-       I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
-       I(ImplicitOps | IsBranch, em_ret_far),
-       D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
+       I(ImplicitOps | SrcImmU16 | IsBranch | IsProtected, em_ret_far_imm),
+       I(ImplicitOps | IsBranch | IsProtected, em_ret_far),
+       D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch | IsProtected, intn),
         D(ImplicitOps | No64 | IsBranch),
-       II(ImplicitOps | IsBranch, em_iret, iret),
+       II(ImplicitOps | IsBranch | IsProtected, em_iret, iret),
         /* 0xD0 - 0xD7 */
         G(Src2One | ByteOp, group2), G(Src2One, group2),
         G(Src2CL | ByteOp, group2), G(Src2CL, group2),
@@ -4382,7 +4383,7 @@ static const struct opcode opcode_table[256] = {
         I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
         I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
         /* 0xE8 - 0xEF */
-       I(SrcImm | NearBranch | IsBranch, em_call),
+       I(SrcImm | NearBranch | IsBranch | IsProtected, em_call),
         D(SrcImm | ImplicitOps | NearBranch | IsBranch),
         I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
         D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
@@ -4401,7 +4402,7 @@ static const struct opcode opcode_table[256] = {
  static const struct opcode twobyte_table[256] = {
         /* 0x00 - 0x0F */
         G(0, group6), GD(0, &group7), N, N,
-       N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
+       N, I(ImplicitOps | EmulateOnUD | IsBranch | IsProtected, em_syscall),
         II(ImplicitOps | Priv, em_clts, clts), N,
         DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
         N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
@@ -4432,8 +4433,8 @@ static const struct opcode twobyte_table[256] = {
         IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
         II(ImplicitOps | Priv, em_rdmsr, rdmsr),
         IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
-       I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
-       I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
+       I(ImplicitOps | EmulateOnUD | IsBranch | IsProtected, em_sysenter),
+       I(ImplicitOps | Priv | EmulateOnUD | IsBranch | IsProtected, em_sysexit),
         N, N,
         N, N, N, N, N, N, N, N,
         /* 0x40 - 0x4F */
@@ -4971,6 +4972,12 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
         if (ctxt->d == 0)
                 return EMULATION_FAILED;
+       if ((opcode.flags & IsProtected) &&
+           (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET)) {
+               WARN_ONCE(1, "CET is active, emulation aborted.\n");
+               return EMULATION_FAILED;
+       }
+
         ctxt->execute = opcode.u.execute;

         if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&


