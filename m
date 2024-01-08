Return-Path: <kvm+bounces-5830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42EAD8270D9
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 15:18:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBA0A1F22F2B
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18E54652A;
	Mon,  8 Jan 2024 14:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kjTFNaUd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D8C46420;
	Mon,  8 Jan 2024 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704723488; x=1736259488;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3BkzMKSJjG6fK/tw78FclCBA4OPjvgWssNo/CJStsqs=;
  b=kjTFNaUdaFg6uzNndsV0/ya3NXVGPcAJ3CZYTZfjHO+Ft/0iUU2nFeLw
   ysN1L0wsbMPd7NXp3Y/tePMPQ8Obdo82/H85Qj2a6n6vtT7APlz2RPKtt
   B6JBBAE19M24lv0gVICdlAcfUTHu0iReefXwN/hgxIAnIIi0X98L6q0Wd
   mIsKp4RpSxHGahZkjE9Oow93PFaR3NxXq5jNzjGovC/j2itGXI3A2Jm3h
   +VW4VAZLpc8Wd1in3mt5zi68ZPMg88Vqj8J+gRLPQNoobxGoTggyBk1ee
   WjVHWq7vPLtzDjd0A/qaUDEScQvT2PgdM5TzOnruIRJVXePD0PJPFbRoN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="395058639"
X-IronPort-AV: E=Sophos;i="6.04,341,1695711600"; 
   d="scan'208";a="395058639"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 06:18:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="954645696"
X-IronPort-AV: E=Sophos;i="6.04,341,1695711600"; 
   d="scan'208";a="954645696"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jan 2024 06:18:06 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Jan 2024 06:18:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Jan 2024 06:18:05 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 8 Jan 2024 06:18:05 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Jan 2024 06:18:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiXduttv+iLbGNi/mh30cakD+900rNDX6PHD5+qCFo2Yf6CMBrN/kj38DvQaRRb8jeQpitRX8MY8MAQwe+4f/kTr/2rxfgaLOZolQvm945tzm+HdILC1D1VGLdHXeBr/hh8txwzf8BM5YCGSUtQUzbiNm/WmnHXng33h2F2HZwYswvWsL+TNP97MX/uPEYfKIlNghpMtbq6qWmm6GtXJOgRVEpy4UhGV2O3ddoRfieXg+NEHHPnNh6TK1/859CipeSIUbxycPyxn8qIfj/zgFpzGRD4rbiFpEBqrcuVKhAq1tlAlHQOuAwYwJbBXq9nuTbi0UNSI726v9RxFx5JLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9x33aq0kcH5mNNHzSF7aZEe/36rieYTxH3TE9tE24k=;
 b=ne5ndAi4LVhm3pgz77qC4bftWd3Yehsg+qOHRtvMBaYejGpWJB+GvGZnaNB0lRcdD2EPNnOj3talPI4NyWzX62mEFc0hyTDmYr3WAA5ff2fHsTIbgEC9VctJ1igTtuzQDy/1l2bmCddj2MkVR4N2XEGYWnTCydsIUj9oumvhoQJHAZR5FN6bQ5xPzb1jfuBBvT1s8yBR2ZxGONk6noUMXgi9RzTLf0ysOjzAzKRfb3A0l91kxAzk8uGPSSAAPlAtl3Lb619IQqZ3OvZcKnZSC1n0i8kRfZ3cr3reCfRbKLukObKX5PVnLi/pgOYKcmNu0KE+SSKN1is0peRTgIbCKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7511.namprd11.prod.outlook.com (2603:10b6:806:347::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Mon, 8 Jan
 2024 14:18:03 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7159.020; Mon, 8 Jan 2024
 14:18:02 +0000
Message-ID: <06fdd362-cb7f-47df-9d1a-9b85d2ed05b5@intel.com>
Date: Mon, 8 Jan 2024 22:17:51 +0800
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
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZZgsipXoXTKyvCZT@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::7) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7511:EE_
X-MS-Office365-Filtering-Correlation-Id: e479c59b-65f8-4a52-c78b-08dc10549fdf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WTQPFpg6vs9Xlk3EKoi4/zRWCLTGwxjs9zOzoDn4lOYHd2bekEIAAPbpLqGg8P+q6pMWwJefYfOdaeUAnogYbAq7ImOB4hs9TYMCaBCr5TNIhpk3M6H1yi3Kwaj4JQJUhklqOYIgVelD26ZoXw/BE7vOmDr2IWBhVWoNHbzczz3ev0kZ2jaK6XLuc/xRbSi1byhLGSfqF/qNaUlTQqR4GCf6mjd8mkr0W/z8YsMpQZgwz9FDPtZ0OHzGI9evqmZgnIwhnwRCvLOVFJ6tlBUWtQlnBziZSLE/sQwr49tg3HO6eTgtJODHO8BpeDyEAyr4luqNmJhZZDrsrG6M+VRY+JYunrn1G+tX9f+0aefL+rS/zjvL6PAbfVbiaYdVyIrEE8pDqOKpwxZCIDMGL0oGK0vjrPlWQpykOPCapahfraMZPLtHKBYdOFJc7F7HtMDM2nNqnmCdNUybtPdp/8F8bF6w112m3ILzgZR+6Hz74ZtCPmJLWFjcVPIxwuqBNACBIZI7YjY10w5bPl89YzbsRRvx5FhqjnwRfNQ4HqcedaCIZ9a7Txl11bbTxpzEjQ2ngyC6FsEIY/qjxqVFvwHMDFp6h9nSTNy7uo159x7o15nKgBryAwC3gMVkMPsbVvtCmm2qh+4juRg3ycI/GnB/VA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(376002)(39860400002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(26005)(5660300002)(4326008)(6512007)(6506007)(38100700002)(53546011)(31686004)(2616005)(82960400001)(6486002)(31696002)(478600001)(6666004)(66556008)(6916009)(66946007)(66476007)(54906003)(316002)(8676002)(8936002)(36756003)(41300700001)(86362001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0t3ZW9oMjlZTmhKVGRmaFhEaTA1OXhNTUg0amdVUnpzNVFKdjdxREthTEZQ?=
 =?utf-8?B?QVV1cEJDNjJCYmJjMklNbVAwUW1jWGZJeTZxc0dBYm5yTUdyeTc2Q0dpM0Zu?=
 =?utf-8?B?YzFqcHptcDVYNDJRQTVNd3ZlRWp4NXNZaktJK1c3OVpjWXBXQVQvNXZ6NFM0?=
 =?utf-8?B?UnQrdGRhSEFCK2hYdnJuY0dkU3VsT2JwYlBVWUs4Y1lOb2swSTVnZGV6T3dv?=
 =?utf-8?B?MEQyTHF5S0lpQkRyRHdYOVFycDcwWEhuUzNvMklSUmZtbTA3ZC9KdW0vK1lZ?=
 =?utf-8?B?UHBEYXFPM0pyZldjb1RUdXpyTTE2YkhxMExUY3Q5UHdLTWFsUHZrang4aTY5?=
 =?utf-8?B?QjhnVzZ2MU13bGo2UkRwN3RySGtQYTZ2YmJlQUU1VWs1aHozQjlONkRrRUln?=
 =?utf-8?B?OSt6S3IwNXgxei9ZajNGU1dyMElLdkllQzlZQlV4ai9LWGJQcW5IczhBaDhM?=
 =?utf-8?B?amwxSGwxWllvbGJMeFlQK0RHdUdYU012Sms1VTI5VGZhNXlFL3ZWbENWNmhP?=
 =?utf-8?B?amtmRDk1Um12SUMwcmh5SkRVY3R2dGg5azBOVVc5VlFZSEJ1aHlPU29yT1Ru?=
 =?utf-8?B?dFhCUzJ6KzlxMlFBL2loWTZMZnB5bFpJUkEzTWt2eU1GaHVpVC8xK0cxYzFr?=
 =?utf-8?B?ZjRmZlVQaDJLQThYcm1ZaHQrYUU0Y3I3V0lzRHBpN2VOOFU3VUlwajhQNTFC?=
 =?utf-8?B?TTNlQTBNYzBIL08xVHllQ29aSy8vRVYxMXpJQzkrT2NQeGptRGpLN0pDdHly?=
 =?utf-8?B?MnlTSVVVMHZ0T1NyME9pc1NJcGpYcHpQZ2o1MnRvcjhLOEFjd1VrSTUvUFB4?=
 =?utf-8?B?RWhOZkhWSFRMbGhibURWZnVqNDgzOFFtYmxRY0U2ZEpINWZBbjBwTElVWWE0?=
 =?utf-8?B?dWpKWmJDQjl5MVlSSEs2Wll4UlhIdFNYZDhNaFFYZktqT1A2L0FQcjQ4VjVj?=
 =?utf-8?B?aTdxT3UrZ3pkUnlVZm1idHJLVHpDM1l0YTFpZFI5MlRaUlBmRDlwNVg4SmJi?=
 =?utf-8?B?TG4rbUdxUm13YkZxOEdVZFJWdkRicExLWWtPYmZ6OWs5Q01HcFp0dkFZbThN?=
 =?utf-8?B?c0FEaGQwa1VQUmJLSW1oUHQxT3pSWEcrcmVzSmxkenQ3TE5hOVZncFZHYm4x?=
 =?utf-8?B?V0xWS3Uzay9RenRRL3pWbDRUZnVqN00wcjF6UWZFK1NLdTcwbGdLbEU5bXlJ?=
 =?utf-8?B?WWsveWRGbFpURTZyamNTbWNNcXNkVWRmZjJkUzhVZjhkWHJ3NXU3bUczeFhW?=
 =?utf-8?B?dGMyUEZkZ2J0VEVKdTRwdVovbmNoVm1nTktRS1VIWWU4OXpCSDduVDNXeDdB?=
 =?utf-8?B?UzJXTTZKcXd0MHBXeHoxRTBWMW1ad0JoOW9ET1Uwa2piMXJqWFY2aTE5ZGRF?=
 =?utf-8?B?aHhxZmVTOWFYWnVlU1NPM3ZZcWloY1dkUmdRY09FaXV6aGJQcFducFVxQzBk?=
 =?utf-8?B?SmFES1pwamZuSWhra2ROemNFb0lwMnMvWk9RaVduUGJ3Zk1pTmVXTWkwSFRJ?=
 =?utf-8?B?eHdyaU9BTTMreW1EVXNkaVFaYWhNWmsxSyt1S3hGVHFSZ0E0QTRscFUzRVpx?=
 =?utf-8?B?S2VpZ0l0QVB3d2k5N3FORzlmM2FWUUYvdi9yTW44c0FtTzFmM3pyUXNxcDN0?=
 =?utf-8?B?dkVyS3FMT3lhblRpZUV4SGloTFBkU0Z5cHMweW9rcVR6RThCcmFjVW9ieVdx?=
 =?utf-8?B?Q0tEN3hUVVdBOFNjRFZibHI3OWtuYk1FcXZqRGxzbFh3aldReUowVnBnVkVi?=
 =?utf-8?B?ZHFFMDlEc0d3aWlYdFNWTHp2RVlJSlhUSXQ3Vk1kNTBxSVhPRlZ4cjZmT2hS?=
 =?utf-8?B?NERqdmJEU0ZJOWY3ZExSZ3UzdHFFOUl4NW1xUnN1MmtDdFR6aVdUTUcxcUs0?=
 =?utf-8?B?NFk3SmcwMnMzNXVDQWNpUkRBR254cnNZWHVYc0xDYkRacTNRQXlJZVdpbDNt?=
 =?utf-8?B?Um9pYmNlV01hZjZJRWVTcEt0ekNpSklvNjBPcXpaSUR2WE9GdUlWZnFBLzJt?=
 =?utf-8?B?YzF2VEMrRDNBdmJqR0doQmk5Wjk4UXFjdGpRVm80eUZRb1dPZW9adDVMeTVu?=
 =?utf-8?B?NGJqQTJWNmNNVmRMazNMdUtndXJjS1BPVWwraG1adXVtNVBVWmsxU2x3eWM3?=
 =?utf-8?B?M3ZZQVpLMFZlQVJSK0o1a2ZPRjM5N0htRXVZb0JuVGFUd1M4RnB2bWFuUnJR?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e479c59b-65f8-4a52-c78b-08dc10549fdf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2024 14:18:02.8723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrpRKMCtZDyigFk1vIXV1k1wXctBpoqnqYFjtDv1sFznk4M+cwNXutxTwvyzN8tHb3OG0xIBk5qRs2US2i70cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7511
X-OriginatorOrg: intel.com

On 1/6/2024 12:21 AM, Sean Christopherson wrote:
> On Fri, Jan 05, 2024, Weijiang Yang wrote:
>> On 1/5/2024 8:54 AM, Sean Christopherson wrote:
>>> On Fri, Jan 05, 2024, Rick P Edgecombe wrote:
>>>>> For CALL/RET (and presumably any branch instructions with IBT?) other
>>>>> instructions that are directly affected by CET, the simplest thing would
>>>>> probably be to disable those in KVM's emulator if shadow stacks and/or IBT
>>>>> are enabled, and let KVM's failure paths take it from there.
>>>> Right, that is what I was wondering might be the normal solution for
>>>> situations like this.
>>> If KVM can't emulate something, it either retries the instruction (with some
>>> decent logic to guard against infinite retries) or punts to userspace.
>> What kind of error is proper if KVM has to punt to userspace?
> KVM_INTERNAL_ERROR_EMULATION.  See prepare_emulation_failure_exit().
>
>> Or just inject #UD into guest on detecting this case?
> No, do not inject #UD or do anything else that deviates from architecturally
> defined behavior.

Thanks!
But based on current KVM implementation and patch 24, seems that if CET is exposed
to guest, the emulation code or shadow paging mode couldn't be activated at the same time:

In vmx.c,
hardware_setup(void):
if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
         enable_unrestricted_guest = 0;

in vmx_set_cr0():
[...]
         if (enable_unrestricted_guest)
                 hw_cr0 |= KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
         else {
                 hw_cr0 |= KVM_VM_CR0_ALWAYS_ON;
                 if (!enable_ept)
                         hw_cr0 |= X86_CR0_WP;

                 if (vmx->rmode.vm86_active && (cr0 & X86_CR0_PE))
                         enter_pmode(vcpu);

                 if (!vmx->rmode.vm86_active && !(cr0 & X86_CR0_PE))
                         enter_rmode(vcpu);
         }
[...]

And in patch 24:

+   if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
+       !cpu_has_vmx_basic_no_hw_errcode()) {
+       kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+       kvm_cpu_cap_clear(X86_FEATURE_IBT);
+   }

Not sure if I missed anything.



