Return-Path: <kvm+bounces-1801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47CD27EBE85
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 09:24:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E9851C20AFD
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581D65249;
	Wed, 15 Nov 2023 08:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lai+BLV9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7864E4419
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 08:24:06 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ECCDF;
	Wed, 15 Nov 2023 00:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700036645; x=1731572645;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PgygN/KTsYVrp4YsOmXt+qsGvxlvwfzMxoDu3Y0F5Wk=;
  b=lai+BLV9dt/fs1etCGP8aISrXQ/I0IX9rX8vNM0w6Jo2EtKGvWOpHPFk
   nndeQjfnEAPxJor3cMZuoEdoaJLnmQ++7PHp8ZNs9YOyYFgtA4KI3LuCV
   VmnxcctZeCpkbekTBEeDV5XhYAIYGETr1b6AYSUAnqWHYQFr7BVpbg5tJ
   vozqI4xRWVnnp0KQ13rqgU4oqn8wWIwhBcN9yCOcvneS09vDPJvhuCSTm
   a5imizZBpH3/UVHhnxGM+8D1RQ5FCD+gvCTFQzHcaX6UNt2dOWlNrFAQo
   k59ME+7npt4cPstxCkBhk7BqE/7wpbQ5VWs8yD0wLfhYT8Yf1BjqlSApA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="375872849"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="375872849"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 00:24:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="6334745"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2023 00:24:04 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 00:24:03 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 15 Nov 2023 00:24:03 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 15 Nov 2023 00:24:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTtV9XqKL8ZI3+X9U0mReomfSB8FX2HgjVF1XVCa4O1hQbCzXS4wLUDeB59MPeXdsrv+OPl/DBiStf+wCZFtuPnz1FGqSKbvFgmlLDICurYtCat8aelLroL9zfFe3kIdUR8zkEBWESKD+XPGrME8/z8qa9xfRaJDanK5ZDeaa504ez6cbWOMJAhsSzsuue7NyNgFSEGMu8HpGCN+1LsT9z2Cp8hl/tKLugtuZVEjkRG1+2jqq7OWfvPOCyS7zYg0Na+UuKbEYQRBXAelekdp/pJIzwPULtTGL34DLD7ts07Ks2ghG4C1xd6sUI+boFlI+821fg3sWoxKeywhlXhIgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJeVucC5zztoGKTOqdtrxoxQ0H3JeQjpf8JHEULn6rU=;
 b=Zd9++3SFDJKEjR+Y2+Izm/dLvTAwge2c6rK9+X3tTpVjI2T/1xB+DA2t/enTGWfyMPk6fZd0jsS8kUOc3P1MRx90h1/Aeuci8yvXe3+9YCFCgYPMVk199YCOi4H4rJLohrhF+heYmzMkuyxnZlFEVrDCHijrwoL3UMoQG+sARqBqMlmRl6Hw0fKB7L+KSHxE1WZG/jPsXVkDZfc7yKw7AFikS5b/IGLMhdTbpFtsBc8BuXnKm3pajjnh72lEi8U9lrUHso4dwdPICTxua/2A8TQcFUhngIogJGEZNuA0FRoJYb5kh2YzINGBjd5BRNLk+VDo91DrOyxKM8HGwa9jRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH3PR11MB7771.namprd11.prod.outlook.com (2603:10b6:610:125::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Wed, 15 Nov
 2023 08:23:59 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7002.015; Wed, 15 Nov 2023
 08:23:59 +0000
Message-ID: <33b452ec-c377-481f-b621-e1410ed28ff5@intel.com>
Date: Wed, 15 Nov 2023 16:23:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 25/25] KVM: nVMX: Enable CET support for nested guest
To: Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-26-weijiang.yang@intel.com>
 <ZUGzZiF0Jn8GVcr+@chao-email>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZUGzZiF0Jn8GVcr+@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:196::20) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH3PR11MB7771:EE_
X-MS-Office365-Filtering-Correlation-Id: e69965ac-d78a-4fa6-adb1-08dbe5b4365e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RoCG8EezIPqq6liH6eweqGCcQNGfZcSy81E+58MzWq2CffxpYog27tQk1WaTBB8OHjb03LDxRRAHVvp8inpBAMghAkXWCuzPqICfIJ6NUJkmP7VB1Id8uI9oRqq+qdMjDdwSiX4SwFfQM/7a9DOSqR1P8mY6Zht4DS/DKhEkPri1qnp0AMJlWIyZ2+4nzzBk0MB1VJW43ll26qiRYHwk9HyJ+6hbmZIAcafl4epKaGZkVb03BcdznqXuCpHkMrSxpdp0GfXOU78Yf29aSf6DkesLyAcEy0Lo+e01cztp6TMndL7+40Ap+FjwGdbJuPrIIiH1k+7wY2A3z71+QUcc94dN2eHS8pM7ittHkhktiXrt7ntG4EN44/A5/Kzl4bjEbx/Z2boYmblJEz2yrstTvCEKrirXVFDRyDPWA+XUVRyiL2XGBdRocEx1r2UfXqZSPvF7zBG3mTz21sZ73WfatnfglB3UNcb/gOjQuW/P1WI/yZ4otEX1LEdQNj+KXzg4K53kVz0Vei6k9/k+3jus3NhEoLTdaj6o22BWp5l7gK0yOhNiSTGgdolVIVd4McrGpCByAPWECRQ0IhPYNdQCSIzvfvgsk7RrfyoaVx8F08KPIjJztSzutVPl50+LE0J1jRLXL0jcZoWr0y7WKtzjsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(136003)(376002)(396003)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(31686004)(36756003)(86362001)(31696002)(82960400001)(83380400001)(38100700002)(37006003)(26005)(6512007)(2616005)(478600001)(6666004)(6506007)(6486002)(53546011)(6636002)(8936002)(6862004)(66946007)(5660300002)(66476007)(4326008)(66556008)(316002)(41300700001)(8676002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djRUSmN5R0lMZkVhWDhBRnMrZWF1UE5WQ2MySEJhMC9wRVZWUlU0NUYwQzlp?=
 =?utf-8?B?Q2RlWTVseVg0bDBUWnF4S21IaERqR3NEOEtQczhqNElTV0JaemJCRVNmZ28r?=
 =?utf-8?B?Ris2WUJrM3c0N01MOTFRSG5XWVN2UmthT2gzTktCRmpUWE5sN0xwQXdaWmh5?=
 =?utf-8?B?amsvNUhaamFDSEdRT05TbkRieHNnRzJNbnNxd3o1bmp0VFd2RFBpMUYvYjhw?=
 =?utf-8?B?bDVTVTZjWUE5YndoYlJEbHhSbDBlbHBIT1VieVNra2pNVlFHL2JYbGxqK1hX?=
 =?utf-8?B?eklzOXViYnJzajVUWFBQeUM4elFiTmVKV1RQM2w1eVhvcXdQbm9RWTRMVWUw?=
 =?utf-8?B?U0c3SURUbU4ybXdoOVk3VFZZNWZLdm12MkNlUzF6c2dlUkhxV2JMQzJHeUph?=
 =?utf-8?B?ZXdIejIyMGFxMVZsaE9adjloS3kxdUtydjBpbG1ZUzdKMVVSanNrenZDSFBH?=
 =?utf-8?B?SHd1OFdSRUN6bytwaEpQSFBsVml3c3VqNE5pYXV5WFo4SUVHNHdqZ0ZRRzd0?=
 =?utf-8?B?VDBaaHVJSTBsbGF2UXdiRHBLOVEwMHNSaWRjUlhEM0RHbFJDWU84TWU4dnl3?=
 =?utf-8?B?WmYyWmYxdjhjNDV2a3kxb1hwMGJQak1ldFYyZmNORkxLSXEzWEt1a1pmUkRa?=
 =?utf-8?B?TXFiN0wzVE16bTJpSngyblpQTkx2QnJJQUJEVWs3clV5allPdWZHUElyRndC?=
 =?utf-8?B?SnRyZXNMUzJwMWV1YVJrOXZ4QW5zSVFHQTgxbTVqMWl0Q0E1UjhGMEx4YXBY?=
 =?utf-8?B?elpQWUNkZXZubXZ5ODZxT2FmS2RrVUc5QXhZQWYzNzdUUVI1ZXlybmExV3NU?=
 =?utf-8?B?TS9QNE5SUG9TRGN5ais5aFppenM4VEZGMGdkOWdwMGxubVprdVRBVEtvdHFN?=
 =?utf-8?B?T3NwRDU1Y2dleGxONHQ1c1ZzbDkyQkNPVDlMMnJ0UXI2MVNZa0xLQ0Z3aStW?=
 =?utf-8?B?c3YzM3haQkQ0dmdmYWVBWEFyaThjQXI1Q0FaQVFodzE5aDR0THcreTZnNXBl?=
 =?utf-8?B?b1JTRmZpZENTWWxNRFZ3VjJKZzNQK2JZeW5rZ2JnS2JqY291elZ6TVVWSHFh?=
 =?utf-8?B?WWZMV2lQeVhpSmRzZE5hdjN6bGwxZGJXWmpQRGg2dGZyRytjYlF4MG5vU0ZX?=
 =?utf-8?B?cGoweFI2YWtYeHJLcHJzMmt4UXNBY01zbnU3YmczelFqR2tmbEhlVW9BTnhE?=
 =?utf-8?B?Ly9uOG9mUVc5RkR1RTdjeUFxcHZRM082ejYzbVdGNThVRlg0QTNXcjQ1dzdj?=
 =?utf-8?B?R0hyamlLeVFKMm44cC9KeHJEQWZIdk9tSENyUXpHZUwyTUxKS0l4S1hXTVNv?=
 =?utf-8?B?S3ZodmJVVndTVkpBMzhQclRiaGJtb3MwMU9Ra3lVU1dFN09SR1NmRHc5MGxW?=
 =?utf-8?B?cXY1QkgzOFdIYjFmdmRseGcrcE1OdmhJTXE2aFg2RGJGcGhYald1R210Snhz?=
 =?utf-8?B?TjBiTld6cjhVWE5GdGljV0NFa2tuVEJzYmZVb3dKcGRvZU12TEY3a2ptWjFF?=
 =?utf-8?B?Z2JoNW5vOG1FQ054SmtEOU5XUHNxYlJEdWY4bXBqSnJKQmZFTE0raEswcFor?=
 =?utf-8?B?azdEcVZiOE43d09uSVpINk05K2wrVXBFclZmMnVUUVBvU3FVMkh0NjNTZ01B?=
 =?utf-8?B?aTVObTJVdllxUHRVdjVZVzV6QkRhN3dPa25xOFRQQTdnbjFvMFJBbU5ES0U3?=
 =?utf-8?B?V1hzMjFzZ0lLR0IwYzhQWU1FbWljaEg1WVBVNWRQQTduajF2QUpLT2hSZ0pW?=
 =?utf-8?B?WEVhR2xMNUlYSGVJUG1vMTZMNzN0TDNTWC9mWDkvc2JlN0VselhNWUJobllE?=
 =?utf-8?B?cnpNZEdveFBoSmE5R0Q5ZkNlQlp3Nmd0UnZvS0VXZURFVHZDdkpHVGU0d1dy?=
 =?utf-8?B?QS9uSGM3QUdEUlpaNFBkZDNBbG9idXZ5YmJ6R2FTNnF2RURYQjVLZE40TGc4?=
 =?utf-8?B?NEJ6WTl6ei9xSUJLWEVKejQ1UUJhY0V0TVl1ZVRIVnRtY1p0NnlkNVZDR1E1?=
 =?utf-8?B?bklCUDRZK1lMZ1I3K29aN0NHajFhRnF3OEFBZjZ1cDgvMXE4Uk1WUHl5Q205?=
 =?utf-8?B?MitCVVJOUXk5Q1RmRWtuQ1NXNllhdEpObUUwbGZMU051aHhZbExveEVscU1Z?=
 =?utf-8?B?dUlWQ3BLZ0UwalN4UXRxbi8wSnM0ZGJUZTRkM2lXMHFrOTAwcnVYU3FoNkIx?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e69965ac-d78a-4fa6-adb1-08dbe5b4365e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2023 08:23:57.7070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G2FC7S5VrvLnlCDIRJxtkEhMHrdNI+8D7m/4q/Lc46njdiT6H9WFw9ty8Pz8pSYHjOnNN/hbmOX0x1PEFFLYlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7771
X-OriginatorOrg: intel.com

On 11/1/2023 10:09 AM, Chao Gao wrote:
> On Thu, Sep 14, 2023 at 02:33:25AM -0400, Yang Weijiang wrote:
>> Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
>> to enable CET for nested VM.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/vmx/nested.c | 27 +++++++++++++++++++++++++--
>> arch/x86/kvm/vmx/vmcs12.c |  6 ++++++
>> arch/x86/kvm/vmx/vmcs12.h | 14 +++++++++++++-
>> arch/x86/kvm/vmx/vmx.c    |  2 ++
>> 4 files changed, 46 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 78a3be394d00..2c4ff13fddb0 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -660,6 +660,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>> 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
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
>> 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>>
>> 	vmx->nested.force_msr_bitmap_recalc = false;
>> @@ -6794,7 +6816,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
>> 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
>> #endif
>> 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
>> -		VM_EXIT_CLEAR_BNDCFGS;
>> +		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
>> 	msrs->exit_ctls_high |=
>> 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
>> 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
>> @@ -6816,7 +6838,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
>> #ifdef CONFIG_X86_64
>> 		VM_ENTRY_IA32E_MODE |
>> #endif
>> -		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
>> +		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
>> +		VM_ENTRY_LOAD_CET_STATE;
>> 	msrs->entry_ctls_high |=
>> 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
>> 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
>> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
>> index 106a72c923ca..4233b5ca9461 100644
>> --- a/arch/x86/kvm/vmx/vmcs12.c
>> +++ b/arch/x86/kvm/vmx/vmcs12.c
>> @@ -139,6 +139,9 @@ const unsigned short vmcs12_field_offsets[] = {
>> 	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
>> 	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
>> 	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
>> +	FIELD(GUEST_S_CET, guest_s_cet),
>> +	FIELD(GUEST_SSP, guest_ssp),
>> +	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
> I think we need to sync guest states, e.g., guest_s_cet/guest_ssp/guest_ssp_tbl,
> between vmcs02 and vmcs12 on nested VM entry/exit, probably in
> sync_vmcs02_to_vmcs12() and prepare_vmcs12() or "_rare" variants of them.

After checked around the code, it's necessary to sync related fields from vmcs02 to vmcs12
at nested VM exit so that L1 or userspace can access correct values.
I'll add this part, thanks!

