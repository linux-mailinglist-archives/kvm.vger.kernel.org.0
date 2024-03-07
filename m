Return-Path: <kvm+bounces-11222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE2508744F3
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:04:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F10471C22A80
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2F101C2D;
	Thu,  7 Mar 2024 00:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X1x2a+dy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4471AA21;
	Thu,  7 Mar 2024 00:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709769848; cv=fail; b=I7KW8tsYHLkWOyNHQrU4KdS8IXPi2XUpIanbhWaBHkO2+JZfTjd0QNziYhk5mB4BlTYJ+qxUOdnaLb8Be2sEFxLq7tB6vJHnYNS5l/o2fHnXwvnjov6hLfLnJHrNd3l4Sz+93V+rAEjpDy+r6B63ZQBv4ZbdD4+8bq88gBwtQn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709769848; c=relaxed/simple;
	bh=nbDK7ygeEWXYF07JRkaPB3wMoJcMX415601vIaFePRo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KaMU/qTLJMnzvnn10RHZwMfBYbpOI+KcrCSKwQUjEyx32IUWESUNXuOTIC+BbhOxH0HnYdQrbleQDRQsEbi5S2XFsP00rsmtcGFthO+AJIIdDXp3ZtD+pdmhOAguTdV7ybaLdt/ICVhXVSzmMZto0BI7+3xn6G2MkDzA8noVSV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X1x2a+dy; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709769846; x=1741305846;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nbDK7ygeEWXYF07JRkaPB3wMoJcMX415601vIaFePRo=;
  b=X1x2a+dygb1EHdMjPqRxw0H9fCmXU1WHQnBNcyrHClTZIpfASOnwVqdg
   djl52t9Hvc48UPFAi4tlnWNxT7VTek1sXDfF1gFy3a+/Lx8q5Pf1qlCiC
   pvOnxEqPvgqLk64+CVWgciXqaPUciat9dheY3chywW/gY00bq6o85N/w8
   HLPsgpNf6SIElo6SDKxcOMbgI/44Xmz6t8Lww5cOFnblWhzjGiftJVf0i
   ZGirAfYl2OX2d/ApjDuj4rWAEOCL2Lkh7h6VWHW5bTMDxeOb4pkrRRGgk
   CzUMUko1c5k4edoSxVgX/OHQEP0XuEdkMo0xHiLzhLSDls/FS8wjKTFaL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4348971"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="4348971"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 16:04:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9821382"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 16:04:05 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:04:05 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:04:04 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 16:04:04 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 16:04:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5BWeeC2adcAfJWQkll0cExz/JoQP+eGx80WD5MnfsmhcekLbsXdCKtMKTHThqbvR7WJof5apgAXckXEwvi0x4IfZcv2Ed/JSfkOroTkfXCfESjt4/ClCLJgHMYe5HMFiG+nedduXK57R3KZC+wB56sKXz1ACfmQGUfMns5qkH9SwtLbco/6fXPLisi3qNOI06jK4ZfniMt1anhZaYNvO5tnvTvc07t3yrDVPsBtC0Zzd3XIsUvnPqScpaSKmNazXJyZGT5pdYEKVGpqjSkErRTLTHPOhwKd9/KfarC3OtQIMdyJ3odFlTBlRBN+wIMWTBJgEGo5xClCYuRhE0u5vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJnD50abvotzZo/qb2pz4c0KDF1cDkM9WCYuEc36NAw=;
 b=RR/PmGxzCVgazUh5j2BvDenUpSTaK7X9Et6Y7RvLsM9uOW/au/FdY/iWzHmSvxk3qeIbPoYLrlZjUIyGFjqZzlgY0h4SLdpaIGWZixAQw8CDCZ6uvPxpmlzyeqn7OtjloEGhrAOnFvIN4UMLjeFUzCQlyzUnnsgCtK8M+Z/I2ZF71ihBjuB/P/YWP2NY+RuSGAqxHrV8XEKX76wuaUuk106aS+aZftJsIKhbCLv67SvgjMXrTBHgA1cGlMdG5bhJ+Tl1iy0rmRecgo4I8Ty1cPmL34haLkKs+aNUaE9D3mab9GoLfmQI2gBsJgvgsRuh3v+LX2vn6fQTzgGTmxpsEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8591.namprd11.prod.outlook.com (2603:10b6:610:1af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.22; Thu, 7 Mar
 2024 00:04:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 00:04:00 +0000
Message-ID: <9c781386-e359-42fb-b3db-4b781508c7da@intel.com>
Date: Thu, 7 Mar 2024 13:03:51 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/16] KVM: x86/mmu: Don't force emulation of L2 accesses
 to non-APIC internal slots
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, "Chao
 Peng" <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, "David
 Matlack" <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-11-seanjc@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240228024147.41573-11-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0190.namprd03.prod.outlook.com
 (2603:10b6:303:b8::15) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH3PR11MB8591:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d057d02-202e-455c-2419-08dc3e3a177e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZimGotooM5mWmGnWAsvJBEvj2fgPHDrofTsn0NhE17yMmGkUe2zj4t1V92QM7txXSwuOKdalrhP6fY5JIlM+ra4GQuWNvGpG0u7f7b4ss0yWBU2umL2GAX86Y4xdiKICDSKldauXECh3aqQqjAejYUnvx/oQlwTmincSOMtYlYh8lyxA4SHXRMjIiC8gJzvt2KCk3W1rVmfX7It0aIqkEF1eDdbo9UADq8n2rKiuV29W/PgeYMrwqpxo57l3whrGUc+Xmu43GhmAXxFGKJFOVWZNbgOKO8bBxpfNYowNqpLbg+gZqAzsiq9EVCiekGIZpPFXLqEGFpOBV1DLXbUwKJptvPMLjb9byuHMdDV/cn3AmzTMJn/s/9zvl5267MaxsJJ5ug5FG7wRk2Irr8muSrPsnI4W3WaePxH+kNgkqCxdaRRmblo+JWcp5K5os8rf5YquxC8LniVsyyouWFE4codcA7iCL/d/72Lbc0Xk3ftdjO+IXLqpiVCEMfzttSTp6xUYbYQNQ4ENu3CXHHS3AqwIi5TIjdpPhcy9iCMs5+4E0eCnXiLZuEA52THf1cOsMh9ZAxjFqAdUi0y6AKi9ppljaambpTQIwG/HG1LQn6CMDqbDKsz/6Xdf5ULMRkjDvwG0Ve804ZWaK+OQMF/iaaFwmlDdkeqBZWLfQV+sOyA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWpJUUp4SUVPUjlSNjZzbzFaZ2JaLzkwUE5GdGt6bTlsQ0FEblpWRUZSVFNh?=
 =?utf-8?B?QnZEaitBRkF4bVVUb2c2WjNyV2xrRjZucW5zd0hIOE9hNkNmTjZ4c0RSZnhz?=
 =?utf-8?B?L3E4bU9JeUxmU2U2Y3FDR2VMaWdwMkNEWEFDTWlsVkhISDdVWXA3ZVNoNGNh?=
 =?utf-8?B?WmQxaEM5dENKQTBZNE5NOG1keHZodEpwTUpUU1lqdDB0cWpWeWp1elhmTHVz?=
 =?utf-8?B?REtzSDZwVE45N2FyM1BveFFhZDdlVmFFeVIrZ2I0YnIvL0d5U2t2cDZFazFm?=
 =?utf-8?B?QWk1akUzbHRpbUVwaGFldVlXMVA4MnJXN2liTVF5ZmMwS0ZxK29qanZuV0xO?=
 =?utf-8?B?NE45N0dPbEZ1MzNxaGQ0MFJlMG9XWHZuTXYvWjYxekxweUNsTGVqenVMWW5V?=
 =?utf-8?B?NEpENjg1RUYwNHQrenI5cHo1SE5HZkdnWmFlTzBtRUpPWFJEZ2JDT2pTRjJi?=
 =?utf-8?B?ZVVCOWlUU28wWklvVnkyS2FwL1h4TFZSWVp5aGFFMWxXMWVCZ1d2T285enU5?=
 =?utf-8?B?OHkxWGZKMTUvK1dVNEhzWkxUVmRkaG5ReDFmQTV4OVZseWx1Mkl1RXA5dFNC?=
 =?utf-8?B?cnFWV3g0ekFoNldkSzJBem84U0d6NWJYWDZURDRBekZBZXkrN1lUSW5GR0pN?=
 =?utf-8?B?aEtzVVRjV1Y5NmRVMEt3T3VuMHNjMWNSaWJCR0RaMW1BbkpKbjlkdU9KTXpp?=
 =?utf-8?B?d1NPV1Z3VzNveTJmc2FLRTFVcFdnamxSdUh1OXFkNHlPVGIxOWd5QlZUOEJw?=
 =?utf-8?B?OVpjQlhCK1lqSmwzREF1bnMwNTdkYmxkMW95V3Q2VzRQdzN3U1l2eUJPSFZG?=
 =?utf-8?B?dU8xMnBQdFpjV3daYUdJMkJkaVlnOUFRY1V1bEo0dUJMNXF0dG9ibGF6TFg0?=
 =?utf-8?B?YjBLcGNmU2lHM0ZwN3cyYUNleHJIYmdDN3ZQSHBuUUE1ZzJDSXo2c3hHL2ti?=
 =?utf-8?B?ZnhkN1RvMzJkSk5FRXlaTjFJeTFody8rdWVSdldWdVlJUlpqei9BREJQYnh2?=
 =?utf-8?B?RE52SE1aTkV0Z0V3TXlVc2wxZXIrejdWY1BoV0U0di9GVHVZZW9vdDMxTmhu?=
 =?utf-8?B?VmZVS0xPUHBMUkYzTEdsVU90MXRMNmtmRHdWN2V5RWVzdTdDSG5neStqUTJB?=
 =?utf-8?B?cHFHUzJDZCs5Yk44Um5ER1hTZEhQZmZuRWdJNGlBQnF3b2tvSk0xSnFoTDZk?=
 =?utf-8?B?VUJwTFJ6NU1uMlZvdDFjSTNWR0pwSDM2RTVCNFdScGZ0UTBaak56NnE4ZzVG?=
 =?utf-8?B?Sm12NUp4dUV6NFEwVmFCRUJYV1Z1S2ZDQlZROFA1eDNFYVpPSFhiQjA2NWF1?=
 =?utf-8?B?dmdGb1hJYjN4MmRPRlhYaHZGK0s4a3V5bmR5U2R3aW1pQXB2YkNMNXNIQVJO?=
 =?utf-8?B?aEpGMUQrU3o3VnVGOFVvTWJPWllITHpmN0JFUXJyYlgzSmY3VjhqQUZaaXBK?=
 =?utf-8?B?Ly9YQUhrQjRhaTBEdXJKZjNuK3RuMkw3N1BzUkVGRHhPdGQrQU9DeEdrc2Er?=
 =?utf-8?B?MCs0T1JULzNlSGVjSWp2MDNXQW9OTmZIdDc2Zm54WDljM0UydnhqRGFmSUV0?=
 =?utf-8?B?b3RvaFNzT0s3RXM0ZzJObjdVYVZZQ25ubytMdVNPQ1lTUWZzKzluNUwxYStz?=
 =?utf-8?B?UUdVS1VwUStOa0psTEg2djBscVRURlhRL3RyenEzbmJPbXVsQnFvdkVUeWFj?=
 =?utf-8?B?VFBDcnIwYnQrYkwwcXZlUWNwb2NVemxraHY0R2FJb0ZydDJaM0tHUDcxSDgy?=
 =?utf-8?B?RHljZERRbkJWWnlpazNkeHFKT1ZKRjB2YkNZZnp3VkV5UE1vYnVRdlErVEIz?=
 =?utf-8?B?MWt5OUJ6SGIvOW5XRWIycTE2aTNEdkc3RzE2Y2dqaVpIVFpjS2N4RW1sUUl1?=
 =?utf-8?B?S29qSWpiSy9HcEJhaTRQTHFRNy9EQVFyVE0wdFRnSUtjQmJYeS95a1hkdWVW?=
 =?utf-8?B?WFBJWnRrNzBneElTL2dsbDhmMWF3N3ZBTllHODdGZ2xxTWxLYXBSSDZOTDN4?=
 =?utf-8?B?VFpOVEtSODkrNGZUMkVzUHc1WHh4emV3dG1wdFkxZmlLUWp2UkdHV0w0R0Fs?=
 =?utf-8?B?cGxuaUZjdHdnY0w2Umx4enNyQ1I3b25XSnhVNkVBYVVPcWFvUllLT1lDQWta?=
 =?utf-8?Q?dw2i0RCODHH0KFmno702YUhrY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d057d02-202e-455c-2419-08dc3e3a177e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 00:04:00.4855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fMrNWJuZbpVvHtU5vULHra5nlOohMFppbMXMMbsrdGjiXjbcI2BNP38/AyPK2D3E4tINDNnsuGoV5bMHF0hfkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8591
X-OriginatorOrg: intel.com



On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> Allow mapping KVM's internal memslots used for EPT without unrestricted
> guest into L2, i.e. allow mapping the hidden TSS and the identity mapped
> page tables into L2.  Unlike the APIC access page, there is no correctness
> issue with letting L2 access the "hidden" memory.  Allowing these memslots
> to be mapped into L2 fixes a largely theoretical bug where KVM could
> incorrectly emulate subsequent _L1_ accesses as MMIO, and also ensures
> consistent KVM behavior for L2.
> 
> If KVM is using TDP, but L1 is using shadow paging for L2, then routing
> through kvm_handle_noslot_fault() will incorrectly cache the gfn as MMIO,
> and create an MMIO SPTE.  Creating an MMIO SPTE is ok, but only because
> kvm_mmu_page_role.guest_mode ensure KVM uses different roots for L1 vs.
> L2.  But vcpu->arch.mmio_gfn will remain valid, and could cause KVM to
> incorrectly treat an L1 access to the hidden TSS or identity mapped page
> tables as MMIO.
> 
> Furthermore, forcing L2 accesses to be treated as "no slot" faults doesn't
> actually prevent exposing KVM's internal memslots to L2, it simply forces
> KVM to emulate the access.  In most cases, that will trigger MMIO,
> amusingly due to filling vcpu->arch.mmio_gfn, but also because
> vcpu_is_mmio_gpa() unconditionally treats APIC accesses as MMIO, i.e. APIC
> accesses are ok.  But the hidden TSS and identity mapped page tables could
> go either way (MMIO or access the private memslot's backing memory).
> 
> Alternatively, the inconsistent emulator behavior could be addressed by
> forcing MMIO emulation for L2 access to all internal memslots, not just to
> the APIC.  But that's arguably less correct than letting L2 access the
> hidden TSS and identity mapped page tables, not to mention that it's
> *extremely* unlikely anyone cares what KVM does in this case.  From L1's
> perspective there is R/W memory at those memslots, the memory just happens
> to be initialized with non-zero data.  Making the memory disappear when it
> is accessed by L2 is far more magical and arbitrary than the memory
> existing in the first place.
> 
> The APIC access page is special because KVM _must_ emulate the access to
> do the right thing (emulate an APIC access instead of reading/writing the
> APIC access page).  And despite what commit 3a2936dedd20 ("kvm: mmu: Don't
> expose private memslots to L2") said, it's not just necessary when L1 is
> accelerating L2's virtual APIC, it's just as important (likely *more*
> imporant for correctness when L1 is passing through its own APIC to L
Reviewed-by: Kai Huang <kai.huang@intel.com>

