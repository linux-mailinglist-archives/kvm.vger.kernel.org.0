Return-Path: <kvm+bounces-5600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC07C8238E3
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 00:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCA5B1C24735
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 23:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CAE21F926;
	Wed,  3 Jan 2024 23:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YQpi/qLi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7551F601;
	Wed,  3 Jan 2024 23:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704323002; x=1735859002;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OI3oP23gKhkxgFwgttAPPE03C4OVyzj9NddHvT3jGuM=;
  b=YQpi/qLiZ9OVppCr9XEyoufREeDxs+Mn1doDhtOD9jVV5IJDxymCJoUQ
   e070IpSNPZ6IDOrW6InSxFz//I23cG8OG8qblSMHXay90+79N/Ft8dfcl
   Ods6S5KS/mocjEEA5s3tHls8q9COZQH17WPkjE1SqpbOyIknuwkDl3VN6
   0N/4DMotRA4Xmq83dvQoI22xtsTVTqYLqfV10u14pyd2nl0kiJO4ecWKl
   7LsAoIoo3ji51kXgst/40Ko6uNaV9q+KPHVuLKSMYO5G8TgGNnIpAPcjy
   QVrDquL8mmomZhEegpAoQ+FBTQ6ThHHSa9htZZulQ9YbAZ1PAXzsLCEmP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="10671857"
X-IronPort-AV: E=Sophos;i="6.04,328,1695711600"; 
   d="scan'208";a="10671857"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2024 15:03:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,328,1695711600"; 
   d="scan'208";a="22253136"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2024 15:03:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 15:03:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 15:03:16 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Jan 2024 15:03:16 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Jan 2024 15:03:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjfVHVLo6QmVkpAJicpM403ADeehMFu/y3Nnzsz01aDEKRiYkKDHgCb+oMuWvNZ1cYrfX0DsmPUHrlIT7Wiz1TLtTrGoa2qJNDHxuxUCVZZmx7ZDTFhVhTIUqmIxjL32xgeAhbM8DKPMq4JcwM2Syd8kb9V6Og2RiO4TGbwNY1M5YH9n7WW/8obbIgzOJtB+vDmlIH8ZeTnHNXicDk6JYaFQnqGeoA5Xk5pyQLiCQge49X0PiQ67m0rDTxkl8oQ6YC2WhQUpk2jGIVa4U+mBKQsK37tIO3tVlJmxLMhn4N7xa5JmZcx69oWxgJv4J/y3on0B+QS7vqYWH7dc1+ikjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTwOgmFmF9onub3x3Xawsl6aKwTzUUBkjsUl0Z1OKNA=;
 b=H6Q7DjA5fAofxp/6J3seWokwub/7GyrQxGnY7jhlIpx4Otm3grHnvATlSU0JAqMfxkCWXntlHVOoedFHJcTBXTj+P8AyXle6ONXVzMgfbBijS0WINN1JdtRC/J6S6qd5Gpaqw/fh8xmulFRpD+fpcUOCUo8V4vCp6PygJgZn60lHKSTt3K92eQ06+rzflgfrY2/jW6dJB24TT2hZNHZYtKtLPOdZYMiWGVcjowXB+5TW18NOnO2hCnxeZLF6UpviCWaCATLj76Js+RzlFjbV0YDO89VRsbkPOmvnBoDfmO2v4dO/swgBup4wprykPOb+QFwBBR98P6AC1KL/40goCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by CH3PR11MB8776.namprd11.prod.outlook.com (2603:10b6:610:1c1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.13; Wed, 3 Jan
 2024 23:03:08 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::ac43:edc7:c519:73c1]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::ac43:edc7:c519:73c1%7]) with mapi id 15.20.7159.013; Wed, 3 Jan 2024
 23:03:08 +0000
Message-ID: <ae83fa1b-99f2-40aa-ad2c-d31ff0d72e47@intel.com>
Date: Thu, 4 Jan 2024 00:03:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] KVM: nVMX: Fix handling triple fault on RSM
 instruction
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<zhi.a.wang@intel.com>, <artem.bityutskiy@linux.intel.com>,
	<yuan.yao@intel.com>, Zheyu Ma <zheyuma97@gmail.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
References: <20231222164543.918037-1-michal.wilczynski@intel.com>
 <ZZRqptOaukCb7rO_@google.com>
From: "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <ZZRqptOaukCb7rO_@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0239.eurprd07.prod.outlook.com
 (2603:10a6:802:58::42) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|CH3PR11MB8776:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c476d45-fda5-427b-0722-08dc0cb026cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PzllrEop+QT9rMaImSQUL2J4C5zXHVI48XghAqjBF+MjMjjSgIgly9TzBAFb8Ri+nVx/uDCmEQHR0axwjNtb0ZpXFQGhl4X6jgq2EyTuKCxTOsUWQJq7bGiqDM816SCYyyfxH6WPqJ7IbwZWOlNcEpLtXFR+OO8ploFtdaGftQHyP4/4bzH13ttXrrdIQgJP6vpzmqyfn5OwUr7PuDJoa4Y7iJ0l9Yba7dwSDPpBIChR4RYw+3ffe4al7OP5gQEgxJZ/L0jEBmftvQn0Ut1lqgeCMfogocfFgHbio3yB0HOAP47AjNWWMQ7mBJh8QDSVG10RD0tdZSU2wwMFmhMJu9dZnolceB/6lUuzUbAdDs8CuLGLQM7QrvtXSBG0xtijY3nnZORoYl3dxLsH6lCjwrIg7afphqELSF8RuhxsbE+Iuoscyx0FmWCHRGvQ/0FR9OtXI3L3gSY0buta9zljXKoOxtC3CW5GqstZHjHKz65Itj2VV36mgYQqqwT9poaqpH/bW8BVpEyGhMMRMhhHXuPAEsegK2ANYZ53z++6u3F3HFm1TxVIdsOzHoGkkteZhI6hLWCT/h7nVN+yNBCjXzanienwY2doHZtqCAceTUSFXABsuxB+2IU6ejwHkPUSzqW2Jw47GcJXhQNL9UdC/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(39860400002)(346002)(136003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(82960400001)(36756003)(31696002)(86362001)(41300700001)(38100700002)(26005)(2616005)(31686004)(83380400001)(66946007)(54906003)(6486002)(66476007)(6916009)(66556008)(966005)(8676002)(478600001)(8936002)(6666004)(4326008)(7416002)(6506007)(53546011)(5660300002)(6512007)(2906002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amhpcUtEdWVOVjVHYmN5cXhvV3FBdWN2d2ZZek5yVytrdWtBNVROR1RtOVJj?=
 =?utf-8?B?ZXR6UThuWU5mK0lBNUNiOHR1Y2FZakVMd0x6aUZyYTdoeDlEUER6TmQyK1RN?=
 =?utf-8?B?OTA5cnpOUTlmWFlqeTcySTMyeEFadHA2d0dNcC9qNURGWjY2TExRY2tPdW51?=
 =?utf-8?B?ZUJrYUlGVWRFcTRLTW5pZlFKOG9iQW9PK1pYUGl2bkwxUXJZdUtkNkRkeXoz?=
 =?utf-8?B?K2JhVlB1YlQxRlYrRFlMeGtlcmlIYmhIT3kzOTB6WjRzV2NxUzRIdmYvK00y?=
 =?utf-8?B?VHZGeGZGM2w2aDB0YmpEeEdLQ2E4NDlFMEI3Mk0vMytSUmpXd1N6akNtQ3hC?=
 =?utf-8?B?cVIxUjhTL2ZDZzAzckV0TmtiN0hnNHJxUXRjRGFCWmh6MmNtV1hSQmJWdm8w?=
 =?utf-8?B?cmNYcFFlb05IRlltd0JDcGZMMTBSdVk4dWp2UXJUZ3Z5bVRldEx6RkFKNDFP?=
 =?utf-8?B?YW9BQXAwalpUdEYxMU5kYVZVbkRadVB4RGdLVkU2eERLb2VRamlFVjB0VWN6?=
 =?utf-8?B?Rk1GWXBCN1dGa3FFUnJ2VjduSmY2SlFoeHpPMzhlM1NUd3NZQ002T0VERzd2?=
 =?utf-8?B?MnRnOGE1M2JGdWdEQ3FFczhDaFI2dElBQldHZEZBOFdFdG5YaDRkcENYUGRk?=
 =?utf-8?B?QmJWM2NOVW0vS21aSjA1QWVxb01QMUx2L3ZUQVVwWmlGbE9pNFo1MU4waGNv?=
 =?utf-8?B?Q01GR0NJSE1SWFpMMU83eC9xOENGTS9qVy9mU1NqUHpmR01rUW02VW9rQzdz?=
 =?utf-8?B?amlkNkU2WWZkeE9CWjIxRldwQlUvbzhCVGtGcFBTRTB3RmFkcEtRamtObE95?=
 =?utf-8?B?Wjc5ZmJoYmJVSGZScnFCR2lnV1M5RkZDSUZSemJsM3FMVEhRUUpGb2Jnc0l6?=
 =?utf-8?B?Y2lFT2tqdFhjM3ZBMDg3czJ6RVFUeDV4c3BGUTBXSnRVZnl5Ykc5VCtMNExq?=
 =?utf-8?B?R29sOWlMNW1aQkF4M3Q0dzdQcnFaZWpEbjlmNHRSQkwyK01TclI1Ujl1ZUFU?=
 =?utf-8?B?T0FQUVM1TXlZM3o2dVlUNUlYM0hVUUM1dGEyYnB4T3RyRXRraXVNSlpXN0lC?=
 =?utf-8?B?QnJFL1hORnFENGtoSVV0RG1QYkg1NTdPdFRaQmxXMUJ2TktpcjVJaUJOQk5k?=
 =?utf-8?B?Mm5mMXVCK3Y3UjFPV0Y1cTBQTWpuMm5VM0hmY0xlMHkxVnh0V0JHV3FTYVF1?=
 =?utf-8?B?a3J5ME9ETGN6Nlp4UWZrMGNJRFNzM2g1QUxieWl5WHZKSFdUUTdNVU9wYnRV?=
 =?utf-8?B?RmVwK3dzV2lzbzhsVGR2d0VPQ0lySmxXSzVlVWl6b2dRMkt3a1pFZW12OS9N?=
 =?utf-8?B?OEVlQ2g2bkc5R0htOG53UzFFODJLMGFXWnYydGtLbk16RGREWXM4cHVxSXc2?=
 =?utf-8?B?NjhVNWI1eDdIQVEza0VrM00zc1RXdk5YQzBuOVRHK2EzRGVJTitpVk1SN25q?=
 =?utf-8?B?WEJ5Z1BWR0o3eldKaDBTQXJXWlUveXZNam02WXU2cWlxZW1QZlNxUmVtVlJ3?=
 =?utf-8?B?YkRvNGZKT2RoNXdLazBrUURiYVdvOVY4NDRNT2xVczNBQjZhMDQwdFhYcS9o?=
 =?utf-8?B?R0hnRUFyRkFqajQrUGhuc2g0U1lDbUtxeWpCaTZSeHZQelZmNDVjNXB3K3pw?=
 =?utf-8?B?Rk5mYjhYUUJwSjhnUEtDWEJHcVdNcUZmN01SbU0zMWZvR2lzQTR0b0ErcHFJ?=
 =?utf-8?B?aE5nSm5wdGwyeUF1bCtHVUVqbjlkbEdJWlBBMXprSjE4VkQ3NllHeE90bk5t?=
 =?utf-8?B?WUhMalhNR1FCSG9xdSt2YnhqNHhyTkJmdGZ5VTZGb2xkRVZ0Qm9ZREZOZHNr?=
 =?utf-8?B?T0hBSGx5ZHMzN3V4ajQxQzlLdCtJTkpYL0pEZUk3Q29sbFBVSnIxc2xoT3lo?=
 =?utf-8?B?Y1NTcnQvemVjNTByUU43RDB6L2NKRTlYZG85RFExcllrY2FLVXFMUDZ6UTVB?=
 =?utf-8?B?amFPSWViOTJpZXc5NFlEdjNoUTNjbE5FQ3RKVVJ0UkVrOXhnbk5zYWZLdUE0?=
 =?utf-8?B?OXQxaFFZS0NYT012QklwZ1RYMVhJYVJEMG9XL0hac2d2MzVrcVY3c0FhT3RQ?=
 =?utf-8?B?c3FkNjRZTlg3cUQxWDFPQUY5T0dNZ3FwT2hia3FUVzZndDVNUXRnRjB6WE5t?=
 =?utf-8?B?RHpjT21ZYzA3S2dGSEdMNjh2T3cwN3pRVFFTcktaY3AyaWV5Z09HbFlIcGg3?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c476d45-fda5-427b-0722-08dc0cb026cf
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2024 23:03:08.7195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGGV7S+mgDA0bD9hZ9kZRNKwHpog4NdkYr5q8wmhPN3Bsu6D24o+qrEceD4cj/ICK0ZMtpVddnoHB9FI4r1YIKrkZlSFzvZMeA6Wgq8ST+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8776
X-OriginatorOrg: intel.com



On 1/2/2024 8:57 PM, Sean Christopherson wrote:
>>
>> Additionally, while the proposed code fixes VMX specific issue, SVM also
>> might suffer from similar problem as it also uses it's own
>> nested_run_pending variable.
>>
>> Reported-by: Zheyu Ma <zheyuma97@gmail.com>
>> Closes: https://lore.kernel.org/all/CAMhUBjmXMYsEoVYw_M8hSZjBMHh24i88QYm-RY6HDta5YZ7Wgw@mail.gmail.com
> 
> Fixes: 759cbd59674a ("KVM: x86: nSVM/nVMX: set nested_run_pending on VM entry which is a result of RSM")

Thanks !

> 
>> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
>> ---
>>  arch/x86/kvm/vmx/nested.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index c5ec0ef51ff7..44432e19eea6 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -4904,7 +4904,16 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>>  
>>  static void nested_vmx_triple_fault(struct kvm_vcpu *vcpu)
>>  {
>> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> +
>>  	kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>> +
>> +	/* In case of a triple fault, cancel the nested reentry. This may occur
> 
> 	/*
> 	 * Multi-line comments should look like this.  Blah blah blab blah blah
> 	 * blah blah blah blah.
> 	 */

Sorry, didn't notice, and checkpatch didn't complain. In other
subsystems e.g. networking this is not enforced. I will make sure to
remember about this next time.

> 
>> +	 * when the RSM instruction fails while attempting to restore the state
>> +	 * from SMRAM.
>> +	 */
>> +	vmx->nested.nested_run_pending = 0;
> 
> Argh.  KVM's handling of SMIs while L2 is active is complete garbage.  As explained
> by the comment in vmx_enter_smm(), the L2<->SMM transitions should have a completely
> custom flow and not piggyback/usurp nested VM-Exit/VM-Entry.
> 
> 	/*
> 	 * TODO: Implement custom flows for forcing the vCPU out/in of L2 on
> 	 * SMI and RSM.  Using the common VM-Exit + VM-Enter routines is wrong
> 	 * SMI and RSM only modify state that is saved and restored via SMRAM.
> 	 * E.g. most MSRs are left untouched, but many are modified by VM-Exit
> 	 * and VM-Enter, and thus L2's values may be corrupted on SMI+RSM.
> 	 */

I noticed this while working on the issue, and I would be very
interested to take this task and implement custom flows mentioned. Hope
you're fine with this.


> As a stop gap, something like this patch is not awful, though I would strongly
> prefer to be more precise and not clear it on all triple faults.  We've had KVM
> bugs where KVM prematurely synthesizes triple fault on an actual nested VM-Enter,
> and those would be covered up by this fix.
> 
> But due to nested_run_pending being (unnecessarily) buried in vendor structs, it
> might actually be easier to do a cleaner fix.  E.g. add yet another flag to track
> that a hardware VM-Enter needs to be completed in order to complete instruction
> emulation.

Sounds like a good idea. I will experiment with that approach.

> 
> And as alluded to above, there's another bug lurking.  Events that are *emulated*
> by KVM must not be emulated until KVM knows the vCPU is at an instruction boundary.
> Specifically, enter_smm() shouldn't be invoked while KVM is in the middle of
> instruction emulation (even if "emulation" is just setting registers and skipping
> the instruction).  Theoretically, that could be fixed by honoring the existing
> at_instruction_boundary flag for SMIs, but that'd be a rather large change and
> at_instruction_boundary is nowhere near accurate enough to use right now.
> 
> Anyways, before we do anything, I'd like to get Maxim's input on what exactly was
> addressed by 759cbd59674a.

Thank you very much for such a comprehensive review! I've learned a lot.
Will try to help with the mentioned problems.

Michał

