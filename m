Return-Path: <kvm+bounces-1804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A147EBEF6
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 10:00:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AAC11C20A8C
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 09:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C360E5248;
	Wed, 15 Nov 2023 09:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nkcnb4rl"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250927E
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 09:00:16 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186F0114;
	Wed, 15 Nov 2023 01:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700038815; x=1731574815;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mZB7SIi8V32x7+u2APAW1ncuNJ7EVHmfD2mbC+xFFP4=;
  b=nkcnb4rl0oXKWL5qSmARFqMOQ3Yi+KUgX/J1hBHI3EMLeBOhhBjDKhlW
   NsSfNGSVKJwaQBEYdm8RlntaSG1IFVMuOVNAXmTepLPByOVKGhTzHE7SU
   S4jn+CjaA4V4cYKmD1cTcSKRk/RJMwitLF2lJidhae+UjeR+NR6+XHeAW
   HpbCmOGC7FcG4IFuk50WR8oak1t2+RNpefSu6up8nyDf2vdsLvb/rxCCd
   p4WwOqBnINzYG07GPsyFNA9nr3O2429VVZyYPwxGVPP1wMVBQrmTWgxSW
   +DvgLaFXh4h8Gd/dHzVAHzAjmjzt9uoAGpA3n9jStZvnvMi/RKWmy+OwE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="389693434"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="389693434"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 01:00:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="758428340"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="758428340"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2023 01:00:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 01:00:13 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 01:00:12 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 15 Nov 2023 01:00:12 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 15 Nov 2023 01:00:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc5T1UgvtvbLPP1+2ebIvMYK4gG0M0oxWpUQ3vm/6IpNKxQblGE5IwITc4LhcxpHtp/LE6OPwPTF4fH1IOR19ZQFggf10nSbBUsn2EB2u7laZoIGj/6nw+/jT+vD+0B36stCsj4NRMwuspntMm02LfAX2SVtvacYUJMxPeTx0/vmwW+aRrNfgHlw3RXMzExsL+Wg/klnqr8ZqNK4UvdXp4NSHXGQqJwGupCCqopYhD7YwaWS0nNPq4rmp1wbNEsb6gP/IcTYctitTZB2Ru9SWqbs1vFs2Zj65KkvIiKf8axWbZbCVzP46OKF7swsmlvg864PgmWVru3QxFGYrPkKPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ss3KfZsva2bKqaqqaFz5tSQYMhw+iGBwRrXStzAaMZA=;
 b=D6h6bdmFBNgtxYZ3ddkoXq237F8V0CSlSi0rkIFpk6qSIhrZTiLBY9jC5F01kRMDNQNLj5DpZyLxBYEKaBGh8TorYOaCXQVsmGuv9c8+ByOIcQjzLtpS1zwdBUdeYnKsqgolSkGhk/bl63mG+GUyI+6d9jcqbiPGitUTHhgCU4lRCGHmLQ/0lx4VzCuaDKiYiIru/Xm9Wh13HiceIKQDk8c2+qdnqH72+MtPy5VpaXPiZbwYuDwypYbdnFkpekXX5S9SjqChoNgiKCsF1G48M5hqpR/lYXHZpY+M50NzrQAjsVlR/GrSm99uKLzDRZ4FAWXTUfA/CRkDcsaZ6VClvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA3PR11MB7528.namprd11.prod.outlook.com (2603:10b6:806:317::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Wed, 15 Nov
 2023 09:00:10 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7002.015; Wed, 15 Nov 2023
 09:00:09 +0000
Message-ID: <1d56efce-8417-4026-80b6-bd03ccd26862@intel.com>
Date: Wed, 15 Nov 2023 17:00:00 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/25] KVM: x86: Add kvm_msr_{read,write}() helpers
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson
	<seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-11-weijiang.yang@intel.com>
 <92faa0085d1450537a111ed7d90faa8074201bed.camel@redhat.com>
 <ZUKnyfbRqTFhMABI@google.com>
 <1e9921f687abe09d8797e6fb83760acf970f344e.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <1e9921f687abe09d8797e6fb83760acf970f344e.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0026.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA3PR11MB7528:EE_
X-MS-Office365-Filtering-Correlation-Id: d04abe68-cdcf-4d23-cb95-08dbe5b944f1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fipM1AwUKFTU2+ZYRE2UTiiIa2esBH6543OOfgrK1lj1tRZOogU2HpvydDCMnHaq4A85MrOQ7Ra1/nyA4HPCcI8rIkktyar77k2m/F+BflTLvsI5pq7auyFxotBRTnIe/hPQkxod+kCgH7TkOlRcXVGNC7jp0/z8O9JHx54+yb3j9/zSHNN5PRVxe2Cu69FKh9pgAQTL3h0s1wvUiwocAE9z2jG0iaBbFOFdyqk+Lpz169CiV7GP7mRBhs721VkJS+NDy62EzGc24luKlD3SrlsGqWZJcKEcM2S+e7Y5Q3DdxMSjV8SGoyqtUHVLmsYkcaKkyojM1rlarC+629SM5jQnl4DpAupDI8sEWejdREfeAhXvZSNJaoYQm3lSolPGS5FE0WGGRh1IdcMFuk30PbwFxufqwbfp9s7PkEaG9ZGaHyTPHlgIVZv9ywlfHWZ6JhfloS5xOvPNLoI88Nwz+1mh2DMk9swhmJWMKz5tfxGC2TUzYUMQQOvOCzUcdyesWE5eNy2aOAy1aV2O9JUsBeLU+jK8YeAEsSEn/feYvpQTtErMk/wSGxlKfCjMJlm78sjvVTurZKVIfhMPx2mTUAUj6hWs/nK/o4uXpylt62NS8Aaf4JXM+oYn68D2emEZmgOxRr/+E/eRATCGWyHmtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(2906002)(66476007)(5660300002)(38100700002)(41300700001)(53546011)(316002)(86362001)(66556008)(66946007)(31696002)(82960400001)(36756003)(110136005)(478600001)(2616005)(26005)(6512007)(6666004)(6506007)(6486002)(966005)(8936002)(83380400001)(8676002)(4326008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmpIcVc3S3ZvM1pmcUE4NEVXUmx2a2pac2lmMEZONXJreHl5MzVpazd2dDdw?=
 =?utf-8?B?NGQrSkViRHBJVFIrUWtDdzFVNDVFUTRuTVI5RjNab3hhQzRPS1Y0dytqemhv?=
 =?utf-8?B?R0ZCQXJ5dVc3Q3JteTM2ZnFoY2lkcHpBckQ3dU5wWi9GbzhrQ0N6LzEvcENL?=
 =?utf-8?B?SVR0bXZXcEhpb08yOWxZcEVaUFBENUVGbzhPWU5Yd29ucWUxL3YxaEJDVkNl?=
 =?utf-8?B?REk4Y1hHcGpGcEdpMVpvcytnTFNlRnovTmVQaUpLTkhvcnBLMG84MHhxK3k2?=
 =?utf-8?B?c0Zqczk4MFFEeU9PNXMwNHZJRUI3TU8ySTRuTEo0SEcxckF4WjN4YVM5SmxO?=
 =?utf-8?B?MDFra2FzaFB2QzhWZnJFSjRkYnhJUE9XWlk3eU9YS0VOSXJmQnREQ2hndjM4?=
 =?utf-8?B?dW5HVk9RMk5NNlpuK01vT2tJdm92YkxidDdXUnl2K2JhYmo0NlJyZDBaUkpx?=
 =?utf-8?B?QzR6OTVCMFd4NXVPbFRTb0ZMZEx2TDJJNUl1ekg5WVVxL1FHVlMwT3M0RzJp?=
 =?utf-8?B?RlhnYk8vQWl2UnBxWVYwbS9XYzg1bkpMVUlJZm1HcTkvUE12cHlGYlJ4c0xQ?=
 =?utf-8?B?eFR6Q0xGTVJsNFFZMGhrbXMxSGI5WnVrWTgrVjBla3VId091SnZITWJHdXdk?=
 =?utf-8?B?b1JVaFlONjJZVjZ5cThCWitnOCtHUm56REFkUm81NUhXZGVYSlJYd2djK3A2?=
 =?utf-8?B?Z1cyazhITS9ML0EwS3g0S3RaNEJXSDF4bWlYWjhPandBOCtBSFpmSXQwS3JD?=
 =?utf-8?B?eCtkRGNNb0FYSWUwSlR6Qi80MWZvdk15NmFxaE0xWGt5ZjFWWVNPQ1NsaXdG?=
 =?utf-8?B?NFdhTktXbm9abFdtVklabktPbFE4eHcvMDAzSnU4dmlPdDR6M2VNRWdFb1hh?=
 =?utf-8?B?aUpWSkhxbHkrZk1WZkMzWURGOFNzZHh6NWFNblB4MmttQkV4ZzRSVUZqUTkr?=
 =?utf-8?B?aWZicXdYNUJDRVdEejRMaFpwaEZzQjdYUDQ4MUpMSVB4aFVuVzJrTXh0KzdL?=
 =?utf-8?B?dUUwRlhEQzN3THdBNUh3NEtWWlg1YjJaaHAzWGM3SHh0Y2w4YkRCRzBZOTR1?=
 =?utf-8?B?bEV5UDZqVVBQQlh4KzZBbURYUnppdXF6QnZ0U0pKQ3VLdVRzQk81UkJSWEFp?=
 =?utf-8?B?dTMwT0RMZnNWZUM5S2hNMFg4R0VaL3B1YkJtYlljenpsYlpSZVVqdHNuQlp3?=
 =?utf-8?B?VUxtY2gxQ0hwK2JaakxpOTdBeVFiNWtGVG9xejFDdEkzWk9jOFUzS29yVDVr?=
 =?utf-8?B?SXpjNVdJNVVDSEdxdVdRUnEyWExZbHNrMVVHMnRGUmlWeWFmQ2dJQisrNnpN?=
 =?utf-8?B?cC8yVk5ud1pOK1d3bDNMeUw3bG1MeE9GZncwV3htakJURi9QSmNBU3NseVB1?=
 =?utf-8?B?Zzd5dkJqbzhiNTdVVmY3Q1FiYXhFb2d3MTR1T210amlmUFA3M1hmSXdEb1Ju?=
 =?utf-8?B?cW1oeklWR0pqbmltMXVobTBTL0o4YW1UR2Frb2F6QnVrTllTa3FpeEVHM0V3?=
 =?utf-8?B?TEF6bTA5c1QrSjN0WC9QcEZzeFZZb09yeUVoeFpGaW1DR1pnajVodnlWcEFY?=
 =?utf-8?B?a29ONHpobFhwR2Z3WmNicFZVbmpncjdTMlp0TmN6NllISlNMS05RbFFBd3g3?=
 =?utf-8?B?YjNnbWJYWVRXOE8wRC8xTWRpNllHaHFMTjVpUU4va0hjU3JobGRyMGUyaTZ2?=
 =?utf-8?B?Y0dXeStwTTZ3ZVJ4NEkxYVozV3ZnOG9PTG9vckJzRUwzYU90cEdMQmNiNUJE?=
 =?utf-8?B?S0hRMFJjU05UaTVyVTlhUGg4MnRLLzJuQ094OStSSHBsMDB2MWl3N0I4MVgw?=
 =?utf-8?B?S0N6QkRFb3hJRkxJeGxOeDlPNmQxVVp4NHN3YjJ4L29SS2RSUlo2VWN2RTQx?=
 =?utf-8?B?bVllYmZPdS9mbjVWbVo3ZGFZazBlOWxmd0ZyYVNsRUZqelRnV2ZCaHo1TXV5?=
 =?utf-8?B?bWNLcVZyL0M1Tmw0REUxWUdJczNsZzdUaVErTk05d1lVMGZqclZEdnVtQngy?=
 =?utf-8?B?aW42M0F5c3oxeHYxaVAraGt5L3RyYmlMNXZUdnJYelhsanFZQ3Y5R0MzQU1r?=
 =?utf-8?B?bGw0NGFML1RTSmExc2V1R2JSSnZHTzcraXk0aEFqMFRZa0xuZ1I1YnpReWlk?=
 =?utf-8?B?STB0eVRSbENwV1Fnc0pSSVBkdnhtd3hOTGpBSGFyWjQxY0taYUZCdnFpaDlp?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d04abe68-cdcf-4d23-cb95-08dbe5b944f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2023 09:00:09.5160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V0RYcBcwJ9P0Wlzts/8u/iW0ZTgc3z4X1444Blz+n8bfnz5rGsa76nnaWznSmziAEDhsW2DP0HscTLy6BktbCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7528
X-OriginatorOrg: intel.com

On 11/3/2023 2:26 AM, Maxim Levitsky wrote:
> On Wed, 2023-11-01 at 12:32 -0700, Sean Christopherson wrote:
>> On Tue, Oct 31, 2023, Maxim Levitsky wrote:
>>> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
>>>> Wrap __kvm_{get,set}_msr() into two new helpers for KVM usage and use the
>>>> helpers to replace existing usage of the raw functions.
>>>> kvm_msr_{read,write}() are KVM-internal helpers, i.e. used when KVM needs
>>>> to get/set a MSR value for emulating CPU behavior.
>>> I am not sure if I like this patch or not. On one hand the code is cleaner
>>> this way, but on the other hand now it is easier to call kvm_msr_write() on
>>> behalf of the guest.
>>>
>>> For example we also have the 'kvm_set_msr()' which does actually set the msr
>>> on behalf of the guest.
>>>
>>> How about we call the new function kvm_msr_set_host() and rename
>>> kvm_set_msr() to kvm_msr_set_guest(), together with good comments explaning
>>> what they do?
>> LOL, just call me Nostradamus[*] ;-)
>>
>>   : > SSP save/load should go to enter_smm_save_state_64() and rsm_load_state_64(),
>>   : > where other fields of SMRAM are handled.
>>   :
>>   : +1.  The right way to get/set MSRs like this is to use __kvm_get_msr() and pass
>>   : %true for @host_initiated.  Though I would add a prep patch to provide wrappers
>>   : for __kvm_get_msr() and __kvm_set_msr().  Naming will be hard, but I think we
>>                                               ^^^^^^^^^^^^^^^^^^^
>>   : can use kvm_{read,write}_msr() to go along with the KVM-initiated register
>>   : accessors/mutators, e.g. kvm_register_read(), kvm_pdptr_write(), etc.
>>
>> [*] https://lore.kernel.org/all/ZM0YZgFsYWuBFOze@google.com
>>
>>> Also functions like kvm_set_msr_ignored_check(), kvm_set_msr_with_filter() and such,
>>> IMHO have names that are not very user friendly.
>> I don't like the host/guest split because KVM always operates on guest values,
>> e.g. kvm_msr_set_host() in particular could get confusing.
> That makes sense.
>
>> IMO kvm_get_msr() and kvm_set_msr(), and to some extent the helpers you note below,
>> are the real problem.
>>
>> What if we rename kvm_{g,s}et_msr() to kvm_emulate_msr_{read,write}() to make it
>> more obvious that those are the "guest" helpers?  And do that as a prep patch in
>> this series (there aren't _that_ many users).
> Makes sense.

Then I'll modify related code and add the pre-patch in next version, thanks!

>> I'm also in favor of renaming the "inner" helpers, but I think we should tackle
>> those separately.separately
> OK.
>
> Best regards,
> 	Maxim Levitsky
>
>


