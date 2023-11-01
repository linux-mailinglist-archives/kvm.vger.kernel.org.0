Return-Path: <kvm+bounces-289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF2C07DDE57
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 10:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 824E2281324
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 09:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30C947480;
	Wed,  1 Nov 2023 09:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d6/X6emU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0E5746B
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 09:20:42 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E437B129;
	Wed,  1 Nov 2023 02:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698830372; x=1730366372;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kxeyAPVgTmesz41nuKx2QKq5Om3tf0Ai+ZW8suTpMlk=;
  b=d6/X6emUgtSv2DArML3XEeHcU5gJaOtbko2yF6lwiN7X8u3lXI1PZQpv
   Fm43oT3V3LYNNOgbzLxVw5797XrDtlatcaV/6g7e6ADgAm7wTWChuehW9
   RMiQiSor6cQkVb971w6YFcV0fSV7joZZpSX9Ebro++BvFOQZBgnAUdtDK
   stWG4IP9WTWkRCFcXjHqWcD9jiUC04LQK6HWbjT4XkcZ+5wh4UtNcFU/y
   y+opWYPYB/Rx1DLv2VWPYF9J+akIVbRq2nh8sRH+zXlu8bX1eSt9p7B52
   DQHpg/tNBAoanpmSLmrTIWZWWf8aYqci7db/Qrw8rDixIlEGErC3ZMq1E
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="367810058"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="367810058"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 02:19:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="737356852"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="737356852"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2023 02:19:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 1 Nov 2023 02:19:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 1 Nov 2023 02:19:31 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 1 Nov 2023 02:19:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUzLTqoIFHGGHdLOj/zdcXoZbMC9JZcxFC37RyrBcAUKsCWzm1vGkn8Akqb4VJAA5vGzNkhGc7IzXVWD8iwQd8SXfieBD/nk04euUOF/CIleTuvT8dh+Tbyc7dPprpHM2H0thCBrHaCE3Ky04weQJ/z+1wFJ4ge+sgQ28VsFasWxbYJCHx366D6Oa6Xwftla4x/q9YoCq7scPbiJJ8ZLNm18Hr0ZyvCoGDt+H9lcdH9EZUQvrnQjaZu1Ng8FwZDI2Ho/D+Vbh9XxCUnpnTJR/CC/jqNT7k3DqK/9uLzwJ7dVVkMJsJ7Gr3DicUFAETNCdHaK+KDFhvY3a/m/jLdrPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25rgqx7XbkdZGWGykEAbzr+l1Hpmg6o8bd9EgYKdA54=;
 b=AXow7986JC4wN56OKnXtM/rQufziSj4CUFm87UgIDkrN8YnFBNNjEaAdkZgA7tV6grRfJkvlV3yXfvYmgpkwgCpQ8xbb2rnADMyCQ3HIYyk2RokYy7fxlwBvfTvksa6gJGhQsJbhpF4r4ayr4pYrM8+ImCNePuKHiZTLI9iXT0cL/JfL3G9g3w+9eR6GubVffG8AbYG6KaWXELXt5swzx0EQl232OlQWlL0Fe8lXiTRjL3nynzvMt3CtdkanZv8J468u4zuIwW10F2AO8yHeK2zd9HKKilcuQbHi3PkmX9N3Z33IWnGTPystFpU1KaqBdjunDGyqCt7Z/MR00p6ucA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM6PR11MB4612.namprd11.prod.outlook.com (2603:10b6:5:2a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Wed, 1 Nov
 2023 09:19:27 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.6933.029; Wed, 1 Nov 2023
 09:19:27 +0000
Message-ID: <c72dfaac-1622-94cf-a81d-9d7ed81b2f55@intel.com>
Date: Wed, 1 Nov 2023 17:19:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 01/25] x86/fpu/xstate: Manually check and add
 XFEATURE_CET_USER xstate bit
To: Maxim Levitsky <mlevitsk@redhat.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <dave.hansen@intel.com>, <peterz@infradead.org>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-2-weijiang.yang@intel.com>
 <0ad2b2b4d394ca4c8b805535444f97db4e9cc690.camel@redhat.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <0ad2b2b4d394ca4c8b805535444f97db4e9cc690.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0107.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM6PR11MB4612:EE_
X-MS-Office365-Filtering-Correlation-Id: 2935c64a-84ec-460e-cff9-08dbdabba53c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWeUB1OA6r7BtGoGpoxpoXd+ZqT7D2qUfEX1En+EGQfMoK0ES+WXMorDu9Kei39zxlQWJ7boW8EbOxD4PBp7gOqYYosTctwa6Hai5ULDSaPRQQBaXeil7Rwu+76UaTvAch04doQo22YXRyW2DaAO0hdOVt/bMKTdK7z/WcPlSb8CisE0vSuv5xJvA9jOGmjrHcSlw7cQAXF+mdSjC92vVavQWfcnn0upnaTdtp+7QeF+sg5uDROrJKUxtXtppkcsIBqnONVCbTaNV/L3hdIbJo2nAx46hfjxaaPRsazPtJf92sRQPtuIGpkMm4bdOxQQ8k3Leaqm8+8Gtqz9TlvDB/oBSbzKMScaL7ZoA1ah8gCtbtOQVJX6O4nRgEI/gtRtHKnAd9SJ4lPy/xESDOku7s52nsIBTSH0XoXiALFD9KWKmObclhhCAq7ZOYA6izES4p4iP8B40rhjiusVbTkgVsQ9dC0V707LP86+jo3cHtpOpuR2UDKI5Cjn2uVooBTcpsrsMXkM+u2AejMhupfCsaQjVlsE68PHIFemwbaBNIsNZcVEdELVJGUPtvoonsA30zHT9YdIr10GenNAYyW48aiHwJ2kyrRCdEIBMNpQPJQu1qUTS7I1q4Q55KalLOKZae5xoxQNA/ePO8P57Kd+og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(136003)(376002)(39860400002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(86362001)(36756003)(41300700001)(53546011)(478600001)(6506007)(6512007)(38100700002)(66556008)(66946007)(5660300002)(6486002)(82960400001)(8676002)(8936002)(4326008)(6666004)(31686004)(2616005)(316002)(31696002)(26005)(83380400001)(2906002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFQ5UC9weEZWQ2lmSENYSnJ2NlFoZkxZblBFVHVxeVRFVHRiaWlQTHV1a0VL?=
 =?utf-8?B?S3hNVnF6VjloUldja2huSVdlUWFxWGpoRmNLM3NMRS8vY1BsTGhQWVhEY3R5?=
 =?utf-8?B?TzJ5d2dBNEVJdWFGdXZGUjNwcmZjWlNFOCtLcEFka2p0UWRTVW52em9ENlFo?=
 =?utf-8?B?VmlGUVZmU2l1NGo4M1ZMMXhVVDFqVVNsdnB0ZUt4QldXVG1OcnQ4MUQyNEtk?=
 =?utf-8?B?dEhhWFQ3dldYVXFzdTFSS1ZUeDByZkZBMENsRElXRGxycWx0QlpyTzBZdWlL?=
 =?utf-8?B?eUdUL0N6MGxoOE9nTjA5QkdQc1Z5Rlhhb1VLQ0R3WFMvOHA0dzBkWFVucUNH?=
 =?utf-8?B?VUhobmFseitkVjJ2cS9PYzlLaWRIVHNyWjRVUy9saUlRYm1ZSTZIbjljbTJO?=
 =?utf-8?B?b2crejdxcmpEeUIxYnlNZFZDa2lzd2VUdm9SRWdRY0FGNHRZYjB5bWppcVZu?=
 =?utf-8?B?ODdiRzlTSXR0VHhDbk9KV09JSHJoOEdPanRJbmJlTnpWWjB6K0h4amlqSE9Z?=
 =?utf-8?B?SG9pM2NtVlFtNE1LN2RDYlFLU2Vja3RiR1lhbWZZV1RwQU5Wc1NMM0YrcHhq?=
 =?utf-8?B?M2c5QWJXRUJ3cVlUd3BIMHhhWGgweUlpbUVUa2FKNTVWMVU5K0pNNHVyLy9N?=
 =?utf-8?B?b240NTh5VVAvRlU5UlZxODQ3ZEJiZXY1blJxZ0lmQkJmblFrcXBRU1dCTE9F?=
 =?utf-8?B?NnF0aDd2MWh0VDFnZlZmZzF3TjU4eXpPOTRGZWRLQUpOaGt3bE1HWGdaZCtY?=
 =?utf-8?B?SVNVcDZ6STAzVFJVTDA0ZUhZd3cwUDU1Yk9tWTlrUWRPOVJnNDdqKzhRbVZC?=
 =?utf-8?B?LzVWU3VtLytkVzVaQndsRS82SUVGRDhpSHFwd1MrdUdCd2lGbmdFT0FPMUFz?=
 =?utf-8?B?Mm9zWmtESDJzTUZXVzVKOE9QYklmN3hsaTRMcitVczZ4b2pwb0JTRC9Menox?=
 =?utf-8?B?bFFrUzNCcnhGY2c4bWVvb0RmdG80d1llczZpYUdVK1k0V2VybHN4V21tQzJ4?=
 =?utf-8?B?VTNBWVdnREtkVmttVG5oY3JHRUNkMDlBbEkvdzZsLzJtQ1l6WWlhc3gzVGFu?=
 =?utf-8?B?Y1E4bzV3OE5uR3I0K3BPdEljUzh1WTUvUDhwbEV6cUVZck5CMnVTS3FDRlMv?=
 =?utf-8?B?TkJsTnpYSDE0Z3Y3NTFLcnc3SFF3ZHNYTkVIU1RYSG9hK1c4QUpLMDVseUFt?=
 =?utf-8?B?cmxITnA1VG5FTmkxbzJic21BSFdVd0o1dFJTU3dOMU1rSkZlaGltMnh5NXJJ?=
 =?utf-8?B?TnZnbG43R0tUeXVsMEs4SFcyRUVXd21VKy9Wc3h6UzlFN0ovVC8rTi9oSVBC?=
 =?utf-8?B?bTQ4bStaTjRzU2p6T08relppOTZldVAwWlRVRVEwS1JVVEovWlBwci9mMjNO?=
 =?utf-8?B?S21tVmZPOEltODh0c29xQVhCNTN1QmkxbUFMbmtyRU1JRkYxSTNCWkgyS3Rk?=
 =?utf-8?B?Zjg3d200L2c5b2VPbWtnL2lpSkpiL0t2bUJhQTRQdWVhOWVPSUdROGUxSDJZ?=
 =?utf-8?B?MVlhMGhCQlZxeGtUSVBFcTFjc2lSSFNQQitlVjFvelMreEhyQVBvOWZOTkln?=
 =?utf-8?B?cStuZVF5N2ZuQUdFNjM1b3RuRHJLV0w3azVzZTcrKzBKdTFLZG9qNHlZcHp0?=
 =?utf-8?B?emQyWlBxNWlhMmhlaUZuYnViQ2xZbFFYRFcycEhMM1hHdUpQUFlBSUZkazgr?=
 =?utf-8?B?ZmRKa201WmtTVnVTeXNCT2hNWU5zbllhaU9WUGIrWXJPUkpZL0dvcWh3SVdT?=
 =?utf-8?B?MnMxcUg0dmxvUXIwOVN6eDU5VGNWbXdOODBCUCt3UjlXSU8xd0FURFRTYkxS?=
 =?utf-8?B?Z2hRM1dRdnFJajlUbW5RM2k4ZG9CM2dWL0g3WEYrYzRhdGs0a3BhTG9LdEF0?=
 =?utf-8?B?YjJuc1dMNFI1dThhSC9xU09HeFg5ZGVXYmg5RldJeEc5YXd2OUt1QW4rQXdh?=
 =?utf-8?B?M29NS3lFMEJjRTBiRVFJeDNCVmoxeGM2ZzBWRHNRQU9JT3gyemVXR0JCSnM2?=
 =?utf-8?B?cjVudk9zV2xueWNKbmpVVXBFaWJxTFZlSUFISjJXL3JmOEpKZXhHRHRwVUxw?=
 =?utf-8?B?enc5SlZtSXhJZEZUazVTazk2clJGOER4WUw2NFdWUHhNb0VBeU1vR1Q2NU9s?=
 =?utf-8?B?U0k4Uk1sbzU5OGxJbmU2KzVMV2ZkK0E2ZmVseWdUcFRNUDlPVnVpRU1uOEkr?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2935c64a-84ec-460e-cff9-08dbdabba53c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2023 09:19:27.2377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JKzno2se+LCK94FWCOXXH9rBwVcExS/tgEQrSS5Vg9pba1/q/b6btzL4R9qP0VarEOdhWI5anRCm0vLSltCsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4612
X-OriginatorOrg: intel.com

On 11/1/2023 1:43 AM, Maxim Levitsky wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
>> Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
>> reflect true dependency between CET features and the xstate bit, instead
>> manually check and add the bit back if either SHSTK or IBT is supported.
>>
>> Both user mode shadow stack and indirect branch tracking features depend
>> on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
>> xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
>>
>> Although in real world a platform with IBT but no SHSTK is rare, but in
>> virtualization world it's common, guest SHSTK and IBT can be controlled
>> independently via userspace app.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>> index cadf68737e6b..12c8cb278346 100644
>> --- a/arch/x86/kernel/fpu/xstate.c
>> +++ b/arch/x86/kernel/fpu/xstate.c
>> @@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
>>   	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
>>   	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
>>   	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
>> -	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
>>   	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
>>   	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
>>   };
>> @@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>   			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>>   	}
>>   
>> +	/*
>> +	 * Manually add CET user mode xstate bit if either SHSTK or IBT is
>> +	 * available. Both features depend on the xstate bit to save/restore
>> +	 * CET user mode state.
>> +	 */
>> +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
>> +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
>> +
>>   	if (!cpu_feature_enabled(X86_FEATURE_XFD))
>>   		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>>   
>
> The goal of the xsave_cpuid_features is to disable xfeature state bits which are enabled
> in CPUID, but their parent feature bit (e.g X86_FEATURE_AVX512) is disabled in CPUID,
> something that should not happen on real CPU, but can happen if the user explicitly
> disables the feature on the kernel command line and/or due to virtualization.
>
> However the above code does the opposite, it will enable XFEATURE_CET_USER xsaves component,
> when in fact, it might be disabled in the CPUID (and one can say that in theory such
> configuration is even useful, since the kernel can still context switch CET msrs manually).
>
>
> So I think that the code should do this instead:
>
> if (!boot_cpu_has(X86_FEATURE_SHSTK) && !boot_cpu_has(X86_FEATURE_IBT))
>   	fpu_kernel_cfg.max_features &= ~BIT_ULL(XFEATURE_CET_USER);

Hi, Maxim,
Thanks a lot for the comments on the series!
I'll will check and reply them after finish an urgent task at hand.

Yeah, it looks good to me and makes the handling logic more consistent!

> Best regards,
> 	Maxim Levitsky
>
>
>
>


