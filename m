Return-Path: <kvm+bounces-8340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6F084E1D6
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 14:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E5661C2605F
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 13:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E7CB76C64;
	Thu,  8 Feb 2024 13:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C1FD7mM6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F94762E2;
	Thu,  8 Feb 2024 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707398315; cv=fail; b=dhYQhAywv+swQH2rd1195ymE+wF1IBYxlpWN3JDZpNiBKEdnX10paLRG+inUbq7hu7ycRsYlRMDZWkZg0A16L5+ptZLDqhFC5Fhs6X10v1ClxyEm08+meZcFJl9lnBnxZreE6HlBqmp8H8GmRV7hqc7OhtFGxS6nNAoZRGUWty4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707398315; c=relaxed/simple;
	bh=p6dWfL3+uLD9AvWL8VRkP5QpWnaiiyoII9y76hjF97Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Fo4XySq071CsHJeh0CiZD5NYJ0tZLzbJEKd1fTSPHD3h+NjYubS4XrdD0rJJ3nv36cphv768AFL80wWRyuaYYxgz1DJUU3Vwmk7ucx3tdGQM0AH0EOhjkJ9Eceqm3GXKrVp6eCsOBqMeIJe2IGdL8QPQ0jv8je8+a7nYa7UPgS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C1FD7mM6; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707398313; x=1738934313;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p6dWfL3+uLD9AvWL8VRkP5QpWnaiiyoII9y76hjF97Q=;
  b=C1FD7mM63sAMKtksM72HCsY/5dJjocRdxhdcUhF06dh2qilrfTp+rGk4
   pA7APY0cxGrZS9zzn0p8ExKrevblqaf0k1wOJOC5L/hS2sPb1TBbaOwtc
   hpqYrvyCsqxy4dq8W2Wz0MVYdoeLZd2upl2Nu4GxtzTrnR9KL5AL2EEM/
   mjTgccN1W5unXGk3sBZ8N3nI5B+fILQV11TR1gxcsXzBBIidQKn8BN73O
   hsFFOwg0BeraxUSz9xCJjolhkGOwg9oG/T/O8SVnLs+FdiPyVCjRToy1B
   /lBn88y+xSNMee8BVA1/uv+Wih//MU8QXkXOa8CtuUpf/BCWcEhGqPuAy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="11859773"
X-IronPort-AV: E=Sophos;i="6.05,253,1701158400"; 
   d="scan'208";a="11859773"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 05:18:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,253,1701158400"; 
   d="scan'208";a="6307982"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Feb 2024 05:18:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 05:18:30 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 8 Feb 2024 05:18:30 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 8 Feb 2024 05:18:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvW4gE9ZbsP4++TlnQ4wN7A3sVz4S5TGt1lXWiXGV8DwdhIbaYg4uTcGEaGr8ZmjUJKxUlT/xlOU4H3tysfSD94NEPyL83yKHkYOhZTA/4VWJzs+xiRYDgAmrK7uID88ujHBCwgOOh/k5LgY7Vz/F+WhaGFGaSzniaZ6Fge2Xzkbg6GgIT5mZcvkfYZjHchk/iFRNP0WmWxEp2mJdUBjbwePicBzVm6CV+yrus+suC7ApftAawrmo7WjXuhuettxa0m+Xh+kg3bOpgCxTU1D6ZUJ54Tpj4GNGTAfF1QGiErRhr9br33h0M+fcSCrff0ncvXrbPOAsI1IPg63Q5Eh4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qm7qcP6PI1AkmP47a45P0sigHvI+3tDsNAVxV1m5E9Q=;
 b=SxvOrMxNAA4Ydtm0gYLj06djizne1qvLuuKZrbdCSbxwMsWIVkm+9/5+FZIiWvY7daebeYla+3bhLXy0HrhM2od12BkWkDTBJe6F18UPuxRqdMhOfSqv41L9UK/WEUDQFRkFc5UsmpHb3Jq8bHPElGjrbGFqAnXe2H6oO6tV1zYd5zMiXoFVsHxpPzos0jOZD9Xm0YjZ9/Q2m0BTck2/Qn2Eq10zYDVoQBkaQRpApBbCPZBKZ0SFsRw7fiML8aTvNwoxYjZfFbXzWiU9TNPJChuThqt2wgsIqfhUTlVYuRERpOxcVBjPjLxRN2lEPyunzKEGItIukng3zZeQVbVjng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by PH0PR11MB5609.namprd11.prod.outlook.com (2603:10b6:510:e0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.38; Thu, 8 Feb
 2024 13:18:13 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::ac43:edc7:c519:73c1]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::ac43:edc7:c519:73c1%7]) with mapi id 15.20.7249.037; Thu, 8 Feb 2024
 13:18:13 +0000
Message-ID: <42d31df4-2dbf-44db-a511-a2d65324fded@intel.com>
Date: Thu, 8 Feb 2024 14:18:06 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: x86: nSVM/nVMX: Fix handling triple fault on RSM
 instruction
To: Paolo Bonzini <pbonzini@redhat.com>, Yunhong Jiang
	<yunhong.jiang@linux.intel.com>
CC: <seanjc@google.com>, <mlevitsk@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dedekind1@gmail.com>, <yuan.yao@intel.com>,
	Zheyu Ma <zheyuma97@gmail.com>
References: <20240123001555.4168188-1-michal.wilczynski@intel.com>
 <20240125005710.GA8443@yjiang5-mobl.amr.corp.intel.com>
 <CABgObfYaUHXyRmsmg8UjRomnpQ0Jnaog9-L2gMjsjkqChjDYUQ@mail.gmail.com>
Content-Language: en-US
From: "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <CABgObfYaUHXyRmsmg8UjRomnpQ0Jnaog9-L2gMjsjkqChjDYUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: WA2P291CA0016.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::12) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|PH0PR11MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 414fddfd-82a7-49e6-bbb9-08dc28a86749
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xCPyro9lFGM0xp7rCRN5uOtSXmVaIMqfHEwYTHKVOesv4VtmAJTces+669bm4StVhgWdmXIpLuWAFV33OBpl2LeSOKU9b2Jt3H0JcnFAjmixTz9ZjxTTA4jR7MFyRgzHtE9z+FdYtLMuAA3zkcaOVKeuBTQG20XlZ8lkWFdxA52scS6nw5aSYOQCjKzPh+lrwWqgEAkV/0rwijb68GiRMoxl047UB85Z6xBjDfnncAg28+ntXPugAHnNpUD/2qA3e0oZXewazoXk43Api1jxYR7q54q6CaRbJqQDe1R9v5qTVKqaYGZTF9ybb3g9YVdT7VF/l569beLFwIp9B4ytijPuUA71xLTOBDXZK2A7YO+uUx+JnTeytNr+/6bVVMF7sqjPHXdBesSBA3mLbSg9/82LqNh1qnJgVBdU1mNrY4CaYAg7c7Ys/owB2ADkYEtVOyud+E2pnI7w3vixBdbtedD2tK4ksW1H4D5qwOdELg6zhMkScpWa5Jt1X4QaEhUerBA4w6bqT7xyxmJdKrQDv1K0kCa0oUALp/1Q5MCKhlYmvOz5Qk8Fk0TDRp5XRr2k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(346002)(366004)(136003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(2906002)(7416002)(5660300002)(31686004)(41300700001)(31696002)(38100700002)(83380400001)(86362001)(26005)(2616005)(53546011)(66946007)(66476007)(6666004)(6486002)(82960400001)(478600001)(66556008)(36756003)(110136005)(6512007)(8676002)(6506007)(8936002)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1hhL3RWRTNqU1M0REF3Y0ZxOHpMSGtSOEd6b0UvUHZhTlZvY3o4ZXdkMllG?=
 =?utf-8?B?U1JIS3NXRHovekExaFlhaC91VS9TeGdKUTQ5R1NvSjk0QVh5bldQOEF1dkI1?=
 =?utf-8?B?L042SnJjNHJvNCtuN2ZSOG13YnNoaFVyYkZEZFlHUzllN2FzYzdkSmkyejNY?=
 =?utf-8?B?WFBVZGZ1NzZLcnN0NHNFSkdtcno3RXdaQ2Vob0xZU041OFRUSzg3ZkRkdnBm?=
 =?utf-8?B?aWs0UVpRV2tJT0p0SWp5dEljL1EySlV1SzBURlc4QzZQdEdCK2RIVm8rV21B?=
 =?utf-8?B?QTdtZENydkx2UkVlY2c0T1dBTzVFVzJVblhwZjhuZk1CUThEazlsL0dHV3BZ?=
 =?utf-8?B?WloxZ2pWYXJNa2RZT1dzMkhTNVlxN1krQ1NMdU9JMEdLN0g2VjhEK0JBeTkw?=
 =?utf-8?B?ZjQwc29HcVVMV21MSjM3WkJZUE11ZVhlazd3cHM0eGRicmtCeDVHZjA1SDRY?=
 =?utf-8?B?VFo1VE1iZWovc2V5RCtvaGMxa1BPZlN2WlRsNHBFbEZmZHB0b3k3RGlLRGIw?=
 =?utf-8?B?Vmp2S2RIQVY3OVpZS0VMaHhVc1pGcmFteVZWeS9Ua1U2OS9ORlFGcStSUVNN?=
 =?utf-8?B?YlNkU1BzVm1wNXR5QzBEVW45ek1IV21MbVBxTWFPb2pOL1Q2cDJ1V3lEbHlD?=
 =?utf-8?B?OXlZS1VWYkxpeDJQZld4dEtOMlZNOFhHRHhQY0ZCQk12SzkwV2RiOXVOZWFt?=
 =?utf-8?B?Y3FBRnFGMXhEbFByaW5CZDUybkJIaFdQbVBPUEMyR0tUYWVtbGQ1NEtjOHh6?=
 =?utf-8?B?eFd1eGV6eEFNaFJoOVNTYWkwMVp1UVFlY0QxM1VqZk5zNElzT2F6WVpxWm42?=
 =?utf-8?B?ZGl4bGRvYVJxWlJ5U2NUclZ4U2tRR0dHVkI2MVhQYWZ1MS9qNzhWNWtVUE5y?=
 =?utf-8?B?WFBLWlowTVptd1FoWlB2RnBvWmdnZ255WWF6ZFdOY3VSbDNBYlpyVG83Vzcv?=
 =?utf-8?B?QjdBTGdiMlRHaFB6R2c4S3JkbWhHekRRV0Y1clpwUVowZWxLam1vclpPVmJY?=
 =?utf-8?B?VGQ3bVowakVnUTZVRi9Rdk1yTEdwUktJZVRCN2tZNWtMN2x1WlYwaEZOdEU2?=
 =?utf-8?B?Rmh0dzJPRWU5MWFWd1JicUxvOGdqWHZhd2dKakJxYXJYMjFNcnZONUgydi9q?=
 =?utf-8?B?M0JWUGJMNlViUEk2MTJJVkRKcm1PYTE2OUlHY0JPVERSOG1teEdpczIyUlRN?=
 =?utf-8?B?WDhlR3NPMUNtUHhSdTVVYTQxZWdETExWRjFxT2U5RlFOM0tKR3FzZkNtaGpw?=
 =?utf-8?B?bDNsVnpyTzRoMVVHekxCbDI1K25CZHFuTzV4dUZHYW94bzRCY1BnSjhHV3Nw?=
 =?utf-8?B?V1hZcGI0MTg4SHk5S3VXc3NQVmIrRGpiTnViQ0hSd0o5S1p0RythSjduS2g4?=
 =?utf-8?B?SW1RaHVMTU5ja3BOa2s0bUNOb1VpYkpKSFZMME0wdU5ZcEwrQlhhVGtmYWlh?=
 =?utf-8?B?R29nYmNxa0ZCZTFUdVlFSzMyemVYd0NqSURtenFYL2NZOFpXRS84enM3SklS?=
 =?utf-8?B?ekRuUFo1WUFaMUxLZGxaVHovdWZkdS8xVXRmRWZiSmZjUlJpM0VscHZMWGJR?=
 =?utf-8?B?ZCt3cTJxM2tRYzRlYnVhbnJ4d0NtaGtPTnQyR1Fma2x4bDBqZXRSVnpDcWl2?=
 =?utf-8?B?ZVA0RnVOUGNnUzJTd2JzWnZFeWdZaWZ0NURYYS9VeXV6OWJhcndsNU45R05U?=
 =?utf-8?B?eGM3K2NKOFUrelA5S2t3REZvQjhteVFXR3ZJMlBxWmw4YWxiMGlSZ29WRW9N?=
 =?utf-8?B?QTRMRk1IelA1aElpZHYvRmVDYVJZbnVQSlFlaTZ2SGxkOXBTbHZaTFBJazZX?=
 =?utf-8?B?d2VSRjkrNkd5bXkxcDIycUlDWVJ1T1BwNlVFWkJZdElPSW5xWFREZVoySzdr?=
 =?utf-8?B?eEZZWUo4OWJ5bUJSK3JSbXJBM2dDMmxZVGI3RmdSQ3hmWDNuUHdxd0dEeDFG?=
 =?utf-8?B?UUN1R0Z0WlQzbjNYUGtJRER5dlN0clBDZ04wNHhvZDNXSmJHTDVuVjJEU2hD?=
 =?utf-8?B?Mkp4aStjUkt3ckU4allZTTMxZ3FNUm5JTEFMelhtODRMM2JBQ0k4a2ZhSkE5?=
 =?utf-8?B?R3oycnFrRzRQOWdhRHRDVjJWdFJpMU1pbURkZld6YThUUGI5dkYvVVVXY2s5?=
 =?utf-8?B?QWVidEZsSzZteFpLUFZDTlZBbEZYSUd5c2VOYWQ0dVNXOEhmV0lsN1lJamtR?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 414fddfd-82a7-49e6-bbb9-08dc28a86749
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 13:18:13.4975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FlXLHQ0ajV1BTmIaTqYDOBPgWGAfXupLINEJFb7aIWEK0CJb1T10CILxyqtMWR4aa0UCe+eTPb5UYK5/CdHmyef3GVMpoRO0JW5OHL5XwGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5609
X-OriginatorOrg: intel.com



On 2/8/2024 11:31 AM, Paolo Bonzini wrote:
> On Thu, Jan 25, 2024 at 1:59 AM Yunhong Jiang
> <yunhong.jiang@linux.intel.com> wrote:
>> Would it be ok to move the followed emulator_leave_smm() code into
>> vmx_leave_smm, before setting nested_run_pending bit? It avoids changing
>> the generic emulator code.
>>
>> #ifdef CONFIG_X86_64
>>         if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
>>                 return rsm_load_state_64(ctxt, &smram.smram64);
>>         else
>> #endif
>>                 return rsm_load_state_32(ctxt, &smram.smram32);
> 
> I agree with Michal that vendor code should not be in charge of
> calling rsm_load_state_*.
> 
> However, I don't understand the problem or the fix.
> 
> The possible causes are two, and in neither case the fix is to clear
> nested_run_pending:
> 
> 1) if the problem is that setting nested_run_pending was premature,
> the correct fix in my opinion is to split the leave_smm vendor
> callback in "prepare" and "commit" parts; not to clear it later.  See
> the attached, untested, patch.

Hi, I've tested the patch and it seems to work, both on Intel and AMD.
There was a problem with applying this chunk though:

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index ac8b7614e79d..3d18fa7db353 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -119,7 +119,8 @@ KVM_X86_OP(setup_mce)
 #ifdef CONFIG_KVM_SMM
 KVM_X86_OP(smi_allowed)
 KVM_X86_OP()                 // <- This shouldn't be there I guess ?
-KVM_X86_OP(leave_smm)
+KVM_X86_OP(leave_smm_prepare)
+KVM_X86_OP(leave_smm_commit)
 KVM_X86_OP(enable_smi_window)
 #endif
 KVM_X86_OP_OPTIONAL(dev_get_attr)

Anyway I was a bit averse to this approach as I noticed in the git log
that callbacks like e.g post_leave_smm() used to exist, but they were later
removed, so I though the maintainers don't like introducing extra
callbacks. 

> 
> 2) otherwise, if the problem is that we have not gone through the
> vmenter yet, then KVM needs to do that and _then_ inject the triple
> fault. The fix is to merge the .triple_fault and .check_nested_events
> callbacks, with something like the second attached patch - which
> probably has so many problems that I haven't even tried to compile it.

Well, in this case if we know that RSM will fail it doesn't seem to me
like it make sense to run vmenter just do kill the VM anyway, this would
be more confusing.

I've made the fix this way based on our discussion with Sean in v1, and
tried to mark the RSM instruction with a flag, as a one that needs
actual HW VMenter to complete succesfully, and based on that information
manipulate nested_run_pending.

> 
> The first patch should be equivalent to yours, and I guess it is
> okay-ish with a few more comments that explain what's going on.

Sure, I'm fine with this. Thanks !

> 
> Paolo

