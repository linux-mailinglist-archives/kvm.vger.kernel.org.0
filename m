Return-Path: <kvm+bounces-11610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E74878C38
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:22:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 985AB282C4E
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 01:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8CFC17FD;
	Tue, 12 Mar 2024 01:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ftjPe826"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA157E2;
	Tue, 12 Mar 2024 01:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710206518; cv=fail; b=WzZpF4GswRaCUfX4ExZVQ3trlhqAdcw8XOM4BS3jOz+6/eeH+jq3LJHMkMSpr7vID/fH7utfC5PG2EXzGrxELBK4+8cjQrY1GW+btWuXlnX38Gn8dvMQqe7d8LpHCiLwsN2MDYuWXoVYe8aHhrNh67+lDkjC42/j4kxRBu7lXEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710206518; c=relaxed/simple;
	bh=vflGG9FpXCMfjAxRVUczY0+CD+Ffevb0gbT4ykXhork=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GiFpk0dnKD+GK8CkIAq1Uz5tcn7pc96Q8A42atu7kWBSMRuHez+f1dI2ucePMaDeM6Z7Gt3NDtHvcmBkzXRdQgK/8962dIBlIhZ4zFedzjmedcE64c+3SERf87BmO/24IsPOJuy4Qh/57yPImibfeXzSCWs4anmdwRxZH1nsUhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ftjPe826; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710206516; x=1741742516;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vflGG9FpXCMfjAxRVUczY0+CD+Ffevb0gbT4ykXhork=;
  b=ftjPe82695aulVUCvYgt5jsGGrMb3+JEOrhx4HURDys8bbVU7nLKf5tG
   ZWSdPo+06n0rPWcX6eI7gN3xr2hH4JrUNtGbeUwLwYQhJtuBVv3C1VeVC
   M9juwEFDu9XxGBAOLkG7ZqyeivmwYc20pKGwmdAyT/tgyYXEULteVK/T5
   bqU6nF29TJVOcPtJrGOzbwd5BnjLTmASz2m3QaRbHJ9F7OAb+C8rZjESu
   2wn+ZrZNVZbA0NVdNj+f8qrOHYsiNEKSjxjS2pO8xFqyAg2iZ0SLaHm3Y
   JrJNy1jrfg2y1AecfSii9KhohS/b/qK5UraIROI9iKFPsEvLVfMlVyQ6v
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="15460272"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="15460272"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 18:21:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="11424986"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Mar 2024 18:21:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Mar 2024 18:21:54 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 11 Mar 2024 18:21:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 11 Mar 2024 18:21:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgXY81+i1d1AhKB4c2216RJkr94xpLXm/UbNPlks8jV9hlQOoYALVJzD2Kh3t828UY9NZq6pq7/2DmUdXP+BTeLf1Y14MsoAK33dPd7CwmKM7KeXCMYm4N6sPK/7nykAoJMxnX/RAuOMXxj2VSUmAbCRejhpPru9oKf8HI5OCV8kmBJRlROxg1G3rsX5hiSwfp2iWo7+9FiT7+RLuaBbG8qOD0zAQDCilwZFTKdCoKHX+iZIC/w0VnRSw7a6jyLFIQd1Nx2GuTjd+JKUwQx29+0sUGc0NNH1vSv3mZBRLw5UvZFLk3F91AIZ7a1406hEp/ftdXaMlTxmMPNXrcbz3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKsS0vH0DKokj3vp7Lu9/f4YyfLU6Jl8aKWjSLRTkPw=;
 b=CMmciy6DmbaF0cr/HnklNycA+eMTYm5vd6jUmWuTZPIcXcDdI5FjN6zVmgy/qq5jZxl4fO1Xb15PtA/c5GdorGKqziCTBWGqs9Yc8yOvVgKGD9ZBIGFXpzITjbzoSAAauQ3b9XUhRz4vWAEF8wNDw8o/Sqe3FveVLq5PYi4/zT4xNrSBCpDmu9YTEKDc4u+6f9mdCk0KkEAacGYjgKU8WVYXRKYi7VgbBD7/kcA/9UYrDpZ3m/VUJ6m/KHv1GrsQ+RhGUEfEM3emPEGtu7r5sXxv+i66ZMJS3aM0sGMVohI3eGx5J8FSxRvMrZIr69JwESl7NpwxLKYrksOJyeqCFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4908.namprd11.prod.outlook.com (2603:10b6:806:112::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Tue, 12 Mar
 2024 01:21:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Tue, 12 Mar 2024
 01:21:52 +0000
Message-ID: <e3953db8-b081-454e-bda1-5ad458044f43@intel.com>
Date: Tue, 12 Mar 2024 14:21:43 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/21] KVM: x86/mmu: Track shadow MMIO value on a per-VM
 basis
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <seanjc@google.com>, <michael.roth@amd.com>, <isaku.yamahata@intel.com>,
	<thomas.lendacky@amd.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-7-pbonzini@redhat.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240227232100.478238-7-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0244.namprd04.prod.outlook.com
 (2603:10b6:303:88::9) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA2PR11MB4908:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bf79df9-cf0f-45be-3fe2-08dc4232cc0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aFE42TrFdGEyF8ypdnJQ/vtGYky50kh5ssn7EZRL8R+xiZjZsBiqZpdvL/tvMSlCeJpc3YKfin1tofi+F+AQNcNm+Cel/DVtqDL7D0PeOHMihs6bEQUrp7aV/GoMD+jQa8VcLKhOKHAsfs9tkVXkMam5yM+3bqYXCL/of/t5khaQj8JZIgLEMG56WAXuNav+XlFI4G4Vp7gBw9tchg6Wje0y06NgDUgjPg/VJYrf3b2+hhxZXg/mCk8T1FDGpyrFVS2qbOKZhfStSAXWcahbHKo+ChT8k+MHGlp7Wvw8WsetvyWx5gPQg8KfvttdTor/yFfKWJFb2fGC2O5faAA+vAJJJ7pRWrF1qN4LUcykj9WmLkjQi0/fut5iD0ZHOBX6PSf4nQmCnAeEU4Wp90nu4hqYK72yRu/AD5e/ADCrxEkmTw7rqBxjeaw2dLVvKUYEDGT24SOLNvANjv+P8whgmfSM3Z4DOct8awhPKn+nGcoQVRY/WdoNe9SbELWzpiZ3JKnXEIwu1YSnZhFfErFAA3GhTSWZJ8rYfeN1/pKAgxX0+j7HyhybRsGlPOB33j4Uuiema9jpuFDbfz6bqcOJuFSGzUHKj4AviSFKAOZLx/Mt5O/B7ICttpzkAX6v14vwwBaCgLfAZWQl6NyoONrVt4I42Gflx1U33mZOYWVqu20=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnJSNFcxSk96bTh3N3IxZHdaVmxRQStka25PQzIyVU4vazNGSHRsVUtyOE1w?=
 =?utf-8?B?Q0xkZ3U2eDNURHFnK1h4a21CU3F5OXVnZ1ZnYTd0T29GN0lDVGRZcytEeW5D?=
 =?utf-8?B?SUgwOGdtV2E2aWtOYXU2UCtlQ0NZKzJ5ZlJEbGFrdk8xSkR1MzNXRFVhc2hr?=
 =?utf-8?B?NGhrREhrNzZWUVZxMTU3Z01jNGM1QkZqbGFiMzJaMEwycjFJVERaZnVqUjJ5?=
 =?utf-8?B?YTVLMmc5Q0s0RFZaSjRRenRGOWU3QjJqTUlvcWNXYjNoZG1vaG8xZnlrdERv?=
 =?utf-8?B?eXRGT3pLRnBrWFd2Y0d1eVdHNkdtSU1GWGNlZWkrS2wrRzJZbnA3U3RyOW1q?=
 =?utf-8?B?NFNFVStYV0w5SWpLa3FrSXhqZlU4NmllT2RrNGZwV0NJMWhLSmp0Q29jdUUr?=
 =?utf-8?B?ZG5xeGRjUDI3SUp6blU1a1lmVjFzNTJHeEo0UnZDVXoyVzRsQnN0RzRya2hY?=
 =?utf-8?B?UUQ3dVhFbENhZnRxNCtjd1FwTnBsRG5IVlhFdHpET3Z6OGMwMzQ5L1BvV0dG?=
 =?utf-8?B?OW9jYWQxVXRhSVF6eERMdGRoSVlBYXMxTTdFbUdRdzI2cEErUTBIWjJQNWpw?=
 =?utf-8?B?K0VIZUtZSEVLSkVueWMxQmF2aHR5K0VjczJCRUcyaW9ERFRJb1dtWDNHOURw?=
 =?utf-8?B?cjhuU1ZHbGtUbUxQTTFyd3VHVzhZSWRZOXRCSFdwMjdNT0EwY1RlcHRDSzll?=
 =?utf-8?B?ekxUU0RHV25GUSsrUzE3TzJuRHpCbVZiRXBtYndYOEQwVkhGcWJjVXo4eHM3?=
 =?utf-8?B?TXlYaDVUdnNQYlhjVkpnVElZbk54L3UvNy9FckdXSVVtaXl5L3pXaW9YZmgx?=
 =?utf-8?B?NWZmMGpNTkdYZUtkYjMyRzFrUlFRRENidFZKaHNCRjM4UFZEWTIyWXNjdlFK?=
 =?utf-8?B?SlNUa205UkhJL1BQdGdGL1dPb28wQy96ZFJpUGJnSUtZVmpuQjMrT3lwbFMx?=
 =?utf-8?B?a1Q1a1hvZGNRM1lOaWpUZkV4YlEzS1hTdlBZMDhhL2MxMUNMbE5Da3lHRjVG?=
 =?utf-8?B?NVhNekN2TW4wL1M4UVdtaVFTNFI1UVRJbDFmZkZoTU9HVTU4aFZydCs4Y2xJ?=
 =?utf-8?B?SWlMYlYwMFJySW5RZW14MTNuaWNPU1NpZFFTOFgweTQrejlMMVh2RXJUYUFH?=
 =?utf-8?B?U1M4dXE4dmtLRWJkc0JPa2pydzdCWWxFMUx3eHIxNjArUmNraFhmUm9kL3F1?=
 =?utf-8?B?S2NqR2h4MitCbHBVK0xEQ0NhUEhoTVRyc1JTSFBEQmt4V2wxWEd1aEtRTzVl?=
 =?utf-8?B?dG1ldys0NDdINFJMYkVqQ0MvUnFYNjdTbG5VL25aTmNBblpxODlBMnl6RnlY?=
 =?utf-8?B?RUtid3JyTE5SV1c2UG45OHU0Ump0VEt2aFo2NHVUOGNxZXFYMXB6YXhnSmda?=
 =?utf-8?B?ZFg0RVkvSmVUSVVCcWE5WU1oa1Q4Yzd1NGhwVCtlVjZSNzFKcWVlUk91K2xC?=
 =?utf-8?B?TlpLbW0rL1FWbmpnWEJISDlqRngwK2tGaEdTbVh3d24vdE12M1Q1YTZSTDZv?=
 =?utf-8?B?cHhpdXhQejRCdXpZZi93Vm5ibUEzTnlNOCtZUDlWYStreXB3ZU1xbXcySmhu?=
 =?utf-8?B?NlBCS1V6VHl5eVF4a3FlMEp1WUtVN1BTcEMxQ3VzeWlONC9xU3kzR05JaWpx?=
 =?utf-8?B?QVVkQmhIZ0lrTzBhR2lsemFtSVZZUXhOQnh4Y0lSMzUwTEFsaDBKV2FVNUlv?=
 =?utf-8?B?d3JveVJpS3dINXdvT05PSFdDa1pvdkRkaGtUSjdpbnNqT283aE52RlRMbHhK?=
 =?utf-8?B?NW5aVFhFYjVOZjJIZHlmVWM5WHhpeVFMM3Vmb1FzQnVHeHEreGNNNlRVc2E2?=
 =?utf-8?B?TCt2SWRxMW0wcHBSbUxIeG13TDh3ZFJlcFpTUFZ6RHFDUnZBWTQ0MkxXSENV?=
 =?utf-8?B?cVRYWUt0QUlXOWczekpqYkxURS9GK3M1dHI5RVZYUVZsS29HSytuUU1RSmxV?=
 =?utf-8?B?WGVDZ215bUJSVFRjWGp1ZUxDMlhFMDF5YXlxN256UFgxV3FMMlRFRUg0bmJU?=
 =?utf-8?B?VW5qMmZyYTVUUllFNlA4NUNqMkRuQ0NvQy81c2ZLTWU0Z05FYWI1RWR6WTNM?=
 =?utf-8?B?enpybVhDVWZmTGNiM25CNzlHZFBhdERQUGRmSVZ3ZHpta1FvL3d3bis1RjVp?=
 =?utf-8?Q?jIgjx0DI3hjgVfGm8h4QxC+lb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf79df9-cf0f-45be-3fe2-08dc4232cc0c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 01:21:52.0449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JyrrIUa0ImKEXsP+mSRkoouliCsOax8IKnlqPC558gkGTp+zpjVdaps9leFNJKHlt3k8ORzkUpHcbcwsGzTDNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4908
X-OriginatorOrg: intel.com



On 28/02/2024 12:20 pm, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> TDX will use a different shadow PTE entry value for MMIO from VMX.  Add > members to kvm_arch and track value for MMIO per-VM instead of global
"members" -> "member".

> variables.  

"variables" -> "variable".

By using the per-VM EPT entry value for MMIO, the existing VMX
> logic is kept working.  Introduce a separate setter function so that guest
> TD can override later.

"guest TD can override " -> "KVM can override for TDX guest".

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-Id: <229a18434e5d83f45b1fcd7bf1544d79db1becb6.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 ++
>   arch/x86/kvm/mmu.h              |  1 +
>   arch/x86/kvm/mmu/mmu.c          |  8 +++++---
>   arch/x86/kvm/mmu/spte.c         | 10 ++++++++--
>   arch/x86/kvm/mmu/spte.h         |  4 ++--
>   arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++---
>   6 files changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 85dc0f7d09e3..a4514c2ef0ec 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1313,6 +1313,8 @@ struct kvm_arch {
>   	 */
>   	spinlock_t mmu_unsync_pages_lock;
>   
> +	u64 shadow_mmio_value;
> +
>   	struct iommu_domain *iommu_domain;
>   	bool iommu_noncoherent;
>   #define __KVM_HAVE_ARCH_NONCOHERENT_DMA
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..2c54ba5b0a28 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -101,6 +101,7 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>   }
>   
>   void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
> +void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
>   void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>   void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
>   
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b5baf11359ad..195e46a1f00f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2515,7 +2515,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>   				return kvm_mmu_prepare_zap_page(kvm, child,
>   								invalid_list);
>   		}
> -	} else if (is_mmio_spte(pte)) {
> +	} else if (is_mmio_spte(kvm, pte)) {
>   		mmu_spte_clear_no_track(spte);
>   	}
>   	return 0;
> @@ -4197,7 +4197,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>   	if (WARN_ON_ONCE(reserved))
>   		return -EINVAL;
>   
> -	if (is_mmio_spte(spte)) {
> +	if (is_mmio_spte(vcpu->kvm, spte)) {
>   		gfn_t gfn = get_mmio_spte_gfn(spte);
>   		unsigned int access = get_mmio_spte_access(spte);
>   
> @@ -4813,7 +4813,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
>   static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
>   			   unsigned int access)
>   {
> -	if (unlikely(is_mmio_spte(*sptep))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
>   		if (gfn != get_mmio_spte_gfn(*sptep)) {
>   			mmu_spte_clear_no_track(sptep);
>   			return true;
> @@ -6320,6 +6320,8 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
>   
>   void kvm_mmu_init_vm(struct kvm *kvm)
>   {
> +
> +	kvm->arch.shadow_mmio_value = shadow_mmio_value;

Unintended blank line.

[...]

Acked-by: Kai Huang <kai.huang@intel.com>

