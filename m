Return-Path: <kvm+bounces-13508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E7F897CCA
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 02:00:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A344B1C26AE9
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 00:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798EB156C59;
	Thu,  4 Apr 2024 00:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dp3pc70N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBED156662;
	Thu,  4 Apr 2024 00:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712188803; cv=fail; b=Gt+rQGHy0TAdzbh4XZOi8QV4IEkE3bO8JSb6bzuoLfhkdc9tjkOwXs7wNeZ7qtwXad9qbYxmCytGq6aJPG9M+eMXwfDlAV3PQImuZbVwaxAgWFGpvkFZEIS2Dkr81UNkwHTA3h1VJ765j6boRaXVZU1OvhIB17oIt+HBsZqG5F8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712188803; c=relaxed/simple;
	bh=/L1sX+bF5SFJt3tyyhGiZerP+JmnvG/3BJ8xPCgmWOc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=obe39D6zzzEAluta8FllmZaQl/YC1WPGKKaCLrwMF/PXhsdB6YAuZyB/fEQqF5tWz2zfi6dzfHbd5QAsoEZWnOdv8L2w/G5yoUNyQhV/zwWKcaYVzn9NF3VO5pLSLs8I3Ry12ZP5EMrrz1BKoUgFmcLLftA2cd5hSNy30VLRi2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dp3pc70N; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712188802; x=1743724802;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/L1sX+bF5SFJt3tyyhGiZerP+JmnvG/3BJ8xPCgmWOc=;
  b=Dp3pc70Nckh/U79TeeRm9zg3dkfxJ2vbQ/84b07n8t1QARRywWqmIa7L
   6bZwFRKJsj4zpChCbu9Ra2mbPMCPnRcOkBOTYbwFJxeZSfTHWkvIJkrYw
   Gu1UgzUJsfiyQj4jrYtFeAhFUbG/ISO5+S/E6vB+GAem5nhls/YVueXmf
   QV/zmax4If1uInMTR5Jb3JnAgjzZ/CtgtlqQVDhObgXLeMHPEbvx6IxTb
   s58c6G+tPg1th1qaKGYDQ93tsFrx+mP1pJewXfoHh73ineG+VadJiluuz
   /jlvl2QSAHCX/26wyv9lPY+qBUWDQcUwnX1Q10yB1yo89nWDHdKELOjuW
   g==;
X-CSE-ConnectionGUID: 3//q8Au3TlSype9Eq17XpA==
X-CSE-MsgGUID: LsIA53k4RNKCZD4UKypLhQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="8030080"
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="8030080"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 17:00:01 -0700
X-CSE-ConnectionGUID: JpjYRBE2THCiDWliNnkQ1A==
X-CSE-MsgGUID: xtb0mJHbTk+WjDfFwaqWJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="56056464"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Apr 2024 17:00:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Apr 2024 16:59:59 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Apr 2024 16:59:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Apr 2024 16:59:59 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Apr 2024 16:59:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdSDt0A9WkAWLuCQV2WCiFGpozcUXRcBY0pIkTIh+qiSCcoKeyG87I29Ma/3hDEeudjrmOGSwb7uTSW3Ehi9/ExEOyQOV24lRP5tszfRPpSHOYUvXpdmVQAL1GQr0Qlxpsx8KNaCyACUBwEpD3EllWAN4+KyqMN02P2856kM8aVGn+2HDvZEuNWpuiFlxK5gKFnDan2H7v50Mx1oMG9utcaI3z7F8hBKWg6TC+p81JXgJOGzA0IPQO607MjiVEGvtr6qqvUY6MqkAcmy6uodKSUTlevsaQYoa40AX1qQ5Dzxbi+UuIhCDKvczo7rsUnAvj9THPw/ADHwJCk3xSvlHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osr676LEKBAVIIc+vjKPL7Xo70v+W/rSm7JSgCcojG4=;
 b=Iogt8UjrEIgVScz1celPYDSmtoEKwdkLknokcn5KO38EEquYF+RHPaz3g1j36CUlYO+tdp8zPFfzZ1ZJKygrkUMEdk+Nl3FWvSOH3uiT9F4PudQ0sjjcTxX5HwP3FUAaS90oiYDQxvb5VkKlpiC6LBKbBnMYjFW4AqXrwVdv6eXaBCScURX1QkBL1+Nfm8e7+viupruYQQisp0/3ze23CPfKXvt75vJOenjNujnuQxpVZKe7cFGQxpXGtmfjikvE0pEADcC/8E1rxMKY2W4rAXWkp46xWtzPBqKdbITAO+guPpe/7X515MYTrH7t6cdOFsTVZfhoAwcdFJwOQEyiUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7269.namprd11.prod.outlook.com (2603:10b6:208:42b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 3 Apr
 2024 23:59:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Wed, 3 Apr 2024
 23:59:55 +0000
Message-ID: <4c64bdac-f1fb-4f29-b753-46ee82a68dc0@intel.com>
Date: Thu, 4 Apr 2024 12:59:45 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:303:8f::7) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB7269:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V7DaTPq1ViM1gyQqYpwyQ1Rml1kAZY8AbFLbJk5fxxCaOw6r+9cNuDW3p7dh6AXqZT7KHSsErPHYFQiKkstjwu5+GgYCAQxfFQzlkv5ocffv2QW1w+fwG4MH9xU5Bqw2VYr0dwBVT0F+di2l1qkQvC09qLKlldxWOynTGqTyZsaQKM1Mlv6SR7HFXqDfS/rPfWS7EGKp9fg8iK26laX2bVnEA0NSxfNZrVndH4371a2ZztDSd852Mo5mInM54IChFaeRc6Joe9V6+uhpAuJJ1Wc497W5JFmv/fTqLkbkNUB267FqRGjBsqOo645W1ntWSIVw8ekqN10Tvpe7tbfObnJFyKU74KbL9xxvBwNMTTkpCoZeFlNc4+Wzwpzhu73u89ICsIAlU3XqZzFPvSQV5M1G86OOwAR/bEWR6b+2zLmc9xfFH0/hHzNbeu8Tx80c0YSRm0WvEZ9C9dUWQdk3loECTlja1Or30rc0RmC5YxUkXfN5k/hrB8a6EydIxPJSz4TsbJ6rlICg5R4X9z5QzJYp2uFBs98IAFsWDYytIFP2xkmhGTt5IMX28P++RbssTrROMJsQScVz2D3V/SSlx1X1nss6oq+6U5lyX2mW/qICZEo6ZgRIXW7Ezc8ORJn/lgZUgCoeni34XFOzfDG7dPx7kdlIPAxK30W3wXSE2ms=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3dQdnRXaUc1QnZjQXNnVmFiaUJlOUxuRmF2dm5yYmhmVzhsem5QbVJQVWVK?=
 =?utf-8?B?TlJyQm15VElpL2RhLzVUT0dzdUZuVWVCOFdjT1E1WUdxbUFMTEhzMEFrS25n?=
 =?utf-8?B?RWFvUStKSUNXMkxlRTBVbGZuaTV1aDRuNnBZWTZvUjN1bzR4WHNSRmpEcWl6?=
 =?utf-8?B?Y2ZaOGJNeTdCVk1nQ2xBUmdsemVGM1Z6emtlL3I3d0FqaFp2SldWMlIyY3Vx?=
 =?utf-8?B?OGJneW94QTN6dHcrWktrOVczZEJlWnp4dy9SaEk5bjVTbUd3WGRHc2FuY1ZV?=
 =?utf-8?B?WmVlcEg3WUhpYmNVWXlmNjdnMXMrbTBiODIxb3dLREhGZzM2ZlNlb3NJdzBi?=
 =?utf-8?B?TkFRSi9HWDdOSkRraStLOUFPQU5IV05Gd09UQkdYNzFpKzVkeVRQRXFRQVpY?=
 =?utf-8?B?Q3pOOVl6NG5GSjlmZFovNWRnMG5pcUJxYWFyTUhaM2ZiL1BWV1lEbndQSWF6?=
 =?utf-8?B?UzhteVJKRERXRzdJeUdiUTRUZ3Aybk81emlOMlpMR2VrcGkxVmpwN2t0a3VZ?=
 =?utf-8?B?dC8vRlZNaVkxQ2pXNVNWUFgwRzRsRHpJSGZMUjl2SDlBLytCUE9vcE9ENmZl?=
 =?utf-8?B?RS96ZUlaUzN0L2tINnBlVWcrMTE0RnBRcElIM3BOcFdhRzdFMmNzamlxRGVa?=
 =?utf-8?B?RCtkNHZ2NFBibDRyQVNtVGVJM2NHYWoxVFpKT29uV3Y4ZWVJaXZ0c1pSODIw?=
 =?utf-8?B?TTVzckZpb3d2SWx4bW53MnBXM2hFdUpPMzdPVnljMW1MTjRFS3RoaHlZL2Q4?=
 =?utf-8?B?ZnBHV1ByMFo3Z0VTaGZHQUhBQWRHakVINVhPeDA4dkFMZHdtSmI4RkVkNlhj?=
 =?utf-8?B?aG9aeS92K3hYcVlQUk0xVXFXNWcza25BY1pwbi9wRFllQzU5N2Rycm9BRTNj?=
 =?utf-8?B?RzRZaUxvRGtGYmhSVnIvbWVnR1RURnBaNWY1Kzh3SHAwaFYwQ1plV3JVcWFR?=
 =?utf-8?B?V0F0N1VXWkhodVNYNjFHM04zWWhYQ2I5d21vRWpWUzNtdTVDeEZpNVQwQk1a?=
 =?utf-8?B?Q1ZuMTJneUJ1VTlqYmtpN0ZxRE5lVGN3djBRTmIyT0ZmOC8yM29hOFYrY1NM?=
 =?utf-8?B?RU8xYkVWUXNOa2NCeGJpUEdPU2FwVFpwU1ZXOWVxWm9sY1M2TjdvNlIxNFBu?=
 =?utf-8?B?UU1YOWpaOG9jakRVWnh2c3A1dU1tMFJ0Z1ZKVUJJSmd2bVpjNDRGZVkzY2JR?=
 =?utf-8?B?SnFnNlM3SzFYblQzeHlncDNqUllIUGlzVnFzdHVsSnplWk0vYWVyQU8yaXAr?=
 =?utf-8?B?bllhc2dldmVraDlnRmhBTkNVMXlJRXdTZmhZcmk1cyt6RExlRG9reXdlODRy?=
 =?utf-8?B?R3dQZGN0UHF3N2lWTUE3V3FNVzk0Y1paUUpTWHRjemdKbW1yYi9IVzRidW9S?=
 =?utf-8?B?eDJ2anA5WWJnVElNWFpDRHpyOEdtVjFXQ0RYeGRlTnJPQ0ZMY2NHSzZOUzFm?=
 =?utf-8?B?L2VXQUZEZExPTElhdjVzSExiZ0xScHo4bTJxN0o3UjVCcEFKY2QyNXZnWXJK?=
 =?utf-8?B?STlYRnJYUVdlZGJkTGZJeXZRWHBrVm1PSWhjNk9PY3dIbWw0UDF6Wlg4V29t?=
 =?utf-8?B?VmVjcjRXNFBQQ3hRV2g4MlplY3ZDL3RYdEVkNGJ4SDNLWjVWa0ZlUXA3L2cy?=
 =?utf-8?B?N3lJYmthNXVqUkk0a0F5bEJvYjBtSkYwSC9tblBJLzN0YVdPWTdyaTl2YmJS?=
 =?utf-8?B?UmptTGVlSmNxZTg3aU5YWmRPcWZ0OWhjaXV6b3VKc1M3YllySXhabzcwc2Fw?=
 =?utf-8?B?ZnYwLzJSL3QyaWdKbjcwR0l0M1FvelB5aGcydDM1VXU4ZXpvZnQ3TzNsckV5?=
 =?utf-8?B?NEM1aFVKa2h3SUVodlduK1FTSEl1U0VPODhWMi9YL3pSb3o5ZXVTNzR6dXor?=
 =?utf-8?B?c29Kd0RpeVN1OUFzc05KME03RFhQSzlZdmFJMzVlcUhObVpGZy9iZGg0R28x?=
 =?utf-8?B?dUdya2E5MVd6dTMyYlBKajM5ZC91eE1LTE0zUWVGWTNCcVUyTWVTTFg2ejFD?=
 =?utf-8?B?YjduNnU4eUZDVFlSM2VReS9wSVlHRElvRHovL05qN0dBU2lpN3NtUTFpankr?=
 =?utf-8?B?cWEzeEg3SnhzUXFEdXJZSXJycjcveFhrWVVCdGZhanBJMWkvaXFPVm5wQU90?=
 =?utf-8?Q?xxsbykYpm/NiZiUcQWiYXv320?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89c17d4c-fbc3-4586-a6cf-08dc543a2919
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 23:59:55.6160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1/XvOgV3ul6GHtsnnjwwYPXniAq7Hd579e6yfV6GmAzKw6/mB4jc7AbjnRCE/bHII8KrE4zuyU39keshuZ7pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7269
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX requires additional parameters for TDX VM for confidential execution to
> protect the confidentiality of its memory contents and CPU state from any
> other software, including VMM.  

Hmm.. not only "confidentiality" but also "integrity".  And the "per-VM" 
TDX initializaiton here actually has nothing to do with 
"crypto-protection", because the establishment of the key has already 
been done before reaching here.

I would just say:

After the crypto-protection key has been configured, TDX requires a 
VM-scope initialization as a step of creating the TDX guest.  This 
"per-VM" TDX initialization does the global configurations/features that 
the TDX guest can support, such as guest's CPUIDs (emulated by the TDX 
module), the maximum number of vcpus etc.




When creating a guest TD VM before creating
> vcpu, the number of vcpu, TSC frequency (the values are the same among
> vcpus, and it can't change.)  CPUIDs which the TDX module emulates.  

I cannot parse this sentence.  It doesn't look like a sentence to me.

Guest
> TDs can trust those CPUIDs and sha384 values for measurement.

Trustness is not about the "guest can trust", but the "people using the 
guest can trust".

Just remove it.

If you want to emphasize the attestation, you can add something like:

"
It also passes the VM's measurement and hash of the signer etc and the 
hardware only allows to initialize the TDX guest when that match.
"

> 
> Add a new subcommand, KVM_TDX_INIT_VM, to pass parameters for the TDX
> guest.  

[...]

It assigns an encryption key to the TDX guest for memory
> encryption.  TDX encrypts memory per guest basis.  

No it doesn't.  The key has been programmed already in your previous patch.

The device model, say
> qemu, passes per-VM parameters for the TDX guest.  

This is implied by your first sentence of this paragraph.

The maximum number of
> vcpus, TSC frequency (TDX guest has fixed VM-wide TSC frequency, not per
> vcpu.  The TDX guest can not change it.), attributes (production or debug),
> available extended features (which configure guest XCR0, IA32_XSS MSR),
> CPUIDs, sha384 measurements, etc.

This is not a sentence.

> 
> Call this subcommand before creating vcpu and KVM_SET_CPUID2, i.e.  CPUID
> configurations aren't available yet.  

"
This "per-VM" TDX initialization must be done before any "vcpu-scope" 
TDX initialization.  To match this better, require the KVM_TDX_INIT_VM 
IOCTL() to be done before KVM creates any vcpus.

Note KVM configures the VM's CPUIDs in KVM_SET_CPUID2 via vcpu.  The 
downside of this approach is KVM will need to do some enforcement later 
to make sure the consisntency between the CPUIDs passed here and the 
CPUIDs done in KVM_SET_CPUID2.
"

So CPUIDs configuration values need
> to be passed in struct kvm_tdx_init_vm.  The device model's responsibility
> to make this CPUID config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.

And I would leave how to handle KVM_SET_CPUID2 to the patch that 
actually enforces the consisntency.

> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Missing Co-developed-by tag for Xiaoyao.

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

[...]

>   
> +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(
> +	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
> +{
> +	return cpuid_entry2_find(entries, nent, function, index);
> +}
> +EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry2);

Not sure whether we can export cpuid_entry2_find() directly?

No strong opinion of course.

But if we want to expose the wrapper, looks ...

> +
>   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>   						    u32 function, u32 index)
>   {
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 856e3037e74f..215d1c68c6d1 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -13,6 +13,8 @@ void kvm_set_cpu_caps(void);
>   
>   void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
>   void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
> +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
> +					       int nent, u32 function, u64 index);
>   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>   						    u32 function, u32 index); >   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,

... __kvm_find_cpuid_entry() would fit better?

> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 1cf2b15da257..b11f105db3cd 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -8,7 +8,6 @@
>   #include "mmu.h"
>   #include "tdx_arch.h"
>   #include "tdx.h"
> -#include "tdx_ops.h"

??

If it isn't needed, then it shouldn't be included in some previous patch.

>   #include "x86.h"
>   
>   #undef pr_fmt
> @@ -350,18 +349,21 @@ static int tdx_do_tdh_mng_key_config(void *param)
>   	return 0;
>   }
>   
> -static int __tdx_td_init(struct kvm *kvm);
> -
>   int tdx_vm_init(struct kvm *kvm)
>   {
> +	/*
> +	 * This function initializes only KVM software construct.  It doesn't
> +	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
> +	 * It is handled by KVM_TDX_INIT_VM, __tdx_td_init().
> +	 */
> +
>   	/*
>   	 * TDX has its own limit of the number of vcpus in addition to
>   	 * KVM_MAX_VCPUS.
>   	 */
>   	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
>   
> -	/* Place holder for TDX specific logic. */
> -	return __tdx_td_init(kvm);
> +	return 0;

??

I don't quite understand.  What's wrong of still calling __tdx_td_init() 
in tdx_vm_init()?

If there's anything preventing doing __tdx_td_init() from tdx_vm_init(), 
then it's wrong to implement that in your previous patch.

[...]

