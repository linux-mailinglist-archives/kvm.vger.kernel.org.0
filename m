Return-Path: <kvm+bounces-45098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0012AA5FE8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 16:24:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD1AF3A3C7B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 14:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0017E1F1932;
	Thu,  1 May 2025 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ONKIEk1u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E89218C930;
	Thu,  1 May 2025 14:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746109467; cv=fail; b=KMXWUq1q3sdaqbKzBFSc44LyLCfC12Yuki5dwhlqSAPCp12JTxDGhmRSAmO91ea2gDwWWSQidRzu1UPEdB1gyeTBEn9jjOEZL45ZyUqHT6T5xynN87Vfkli9YIiP9JwAnMFrIRjqJKDe110l4CKlTtUS+QcPHxxrIWV1+orYmHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746109467; c=relaxed/simple;
	bh=07HMIE5UyoDA4078EVgRUI8FmzPRvJbDjTAYpDZ9x9U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LBeDz6dqnNMv5Mb+B4uTcwzAT+Amm77NIkW6DjIv2ztuSruKWxCvH66bppV9kqd7b/EX/1RPwzJxYQFPqRZ7SkipFFDbH1FxfHDOTJG3ZqpM8lD1+7Fhj9A3h0x7zptFImiKAXdrwhK7d5bRdy51UBhbtE9LzmI33i5Qm36cqdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ONKIEk1u; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746109465; x=1777645465;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=07HMIE5UyoDA4078EVgRUI8FmzPRvJbDjTAYpDZ9x9U=;
  b=ONKIEk1u/R4KkK8hwtYY8jJ8L2E5cSrVaYiWA4RFmHydQSdVwh2hpPBa
   6xSM3fK8T++i0zM6O/jlsUQ4XNwev9DQgEoLB8HysrHHjErWMhyWEAupn
   Fe8RWTBFs3Lb2+0qybPONfUQWgyOs6XS9/+rsC3h1EsQLgU6N91InOyWl
   WWV4gVCUTUU8qUnABybuSmeZVKl+9FspqatGtQ8NBdrSaSFV3aqFM+5V9
   GU+E4FYEYjzaI2och3CJxKDUmBrewpTX9A9uwfUCmHMUOZ6R3QzJD7j7K
   VIUiiBOsncY2U92OFxLxMq4NbQray63QZDeKeyhDtvvGg49OKe/xy2GB/
   Q==;
X-CSE-ConnectionGUID: h3BLXMNpSQes/uOW+JnkfQ==
X-CSE-MsgGUID: a5KMZRxURyi/NXaAz77okA==
X-IronPort-AV: E=McAfee;i="6700,10204,11420"; a="47030445"
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="47030445"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 07:24:20 -0700
X-CSE-ConnectionGUID: BuG94oPjTQavA/I8/c5Zgw==
X-CSE-MsgGUID: Q4dbaPzhQrmwNKZqhbhuDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="165456568"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 07:24:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 1 May 2025 07:24:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 1 May 2025 07:24:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 1 May 2025 07:24:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LiAb+vrqraJV9p4JFpfh4MVGeQlPzTKy6AGjM4tNY1C9yFZrfq+rCW6jppe9HulNXFfkvDx1qDMb1t477pe/sm/YI+6VaR+Y8lkdy+yv4DweSaAn1KCrEaC/iPHC2tIWQ2+LRn/R+QdaE1O7oru07/7O6k8DrRKuDtfXVuM6i7YG/V2d7KG4IW10ZxA3wIs6snFuvEM6DEp8eb2u829DiN65YmnWvGzdnpkzO/9byTvktIxvZLXF+ezvL0ywCLPJ6aE0i/zmcPvQLiMHDn6L1GP/Ta9qmfypBXiN0EFr3SovFIaLkJ1BU/EQ8RcTlZm/VTGXpWjGMPR89HXJG9MZiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIEupmgknPEEOdejdSQPgqbZAqPdAOPL49Ud83X258w=;
 b=ARDS4thlYIwp2ffUivfgfIhtJP8AVRarlGV/h0lxjr4+Lt3a9LB1W0F8k4HwQmCo1z8z3MCuZvoFYA3nT8ZcBz8qNHDJWB6P6jFpvujt1hBFdFesuvvV8sVua2jZkzmx7/miz1nKbt/ijxIYvWtEMnHXML/G8glOeRzbZWkj4wAzmgxu/hHgSjAs8f+0HmBpMuF1tsmrGOS27WxnVILwWBoCPRo4eaXXSmegMeURnTduCQ3cRWdBY6e0fY+9fr8+oOwnJf025Zi+D3GWkJm7DmNfNtKM3liyRXn4/RCZHIQZ344eTLZBelUzg/PuUgVMpVA2lY2RVO3T3ZLTaVzEBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Thu, 1 May
 2025 14:24:12 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%5]) with mapi id 15.20.8699.021; Thu, 1 May 2025
 14:24:12 +0000
Message-ID: <b43f9043-58ce-4932-badf-e9510a7d4cd4@intel.com>
Date: Thu, 1 May 2025 07:24:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/7] x86/fpu: Initialize guest fpstate and FPU pseudo
 container from guest defaults
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "Li, Xin3"
	<xin3.li@intel.com>, "ebiggers@google.com" <ebiggers@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"john.allen@amd.com" <john.allen@amd.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "Spassov, Stanislav"
	<stanspas@amazon.de>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-6-chao.gao@intel.com>
 <9ca17e1169805f35168eb722734fbf3579187886.camel@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <9ca17e1169805f35168eb722734fbf3579187886.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0050.namprd03.prod.outlook.com
 (2603:10b6:303:8e::25) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|SJ0PR11MB4958:EE_
X-MS-Office365-Filtering-Correlation-Id: 67b3e7d6-53fc-44f3-3bcf-08dd88bbd7df
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MjlGSWloSkFaR0lKLy81MFZtUmdTdlVYRlpmZFNjT0lwNHpBZVgwRE83cytS?=
 =?utf-8?B?eWVlb1lBZlJ2RVhyQzVSMU5SY1BraGE3UDN5RnVJU1U1Wk5EaEFaSWlvR2tq?=
 =?utf-8?B?aFFvQ3ozMktFa2ZucTRYa085Y0dEVHlxQkFtTUx1ZlQ5eE5KcE56TXlXNGY2?=
 =?utf-8?B?L09NbmFybW1nZ0VuM0Vac00vNjlBdHJ2bGF1dDNhQTZqVzFEaURVdVpiN3Rw?=
 =?utf-8?B?YWFjc3Q1VXNnZ2ZEQ2VIc2Q0b0gxS29DWmg2dDR3bDBVWVNFVmk0cmtLbGJL?=
 =?utf-8?B?dmJkYXkzZGJ0MXljTmtMZVhRTVdwYTllL0wxR1hnNEVqbXVza2xRaUZ0V3lp?=
 =?utf-8?B?VFNhZEtTbWNCeXZ1KzRYZVVpT3A0MXljUjlwZElzZE4xK1lZYlNPODI3L0Nr?=
 =?utf-8?B?Qks0d25uc2cra3plbytnb2d0YlkxQnJ5djFaUjZXcEhpb3BRVG9qVS96WEx3?=
 =?utf-8?B?N0R5Z3hYcDZneGtMcmtMZEtEVG9sVlZES09nVk8vSVdkbjh5Ylpsd0FlQk1k?=
 =?utf-8?B?Zm91cDVHWWE4R1pUUFFtSlFhaW5tMFM4TGVPZjlKOW10eTJ1YWJzSjVTODdy?=
 =?utf-8?B?ajY1RUFWWnMxSjVhTUVDL01lU0hiNFEwajRrUGdLTkkrbFJXUk5LazNScWZo?=
 =?utf-8?B?RytZSE1IWFZUSTFIQWJ3Q1F0VURmRG5XTkZOdXcvZXpBMnMrWUJxcjlxNDRi?=
 =?utf-8?B?RmVqZ0htM1lBSGpQTFdNdUdlNlVVVGZBZ0pwYkQ1QytURFpCVERKNXJPeVZC?=
 =?utf-8?B?RlJyYjZ2NTZKV1MxSS9XdXdGRVR3S3BFY0ZydVlUTlNnQU5tNjZvMDZkQ0hB?=
 =?utf-8?B?b1QrOExPVGRzem9JRkcyWWVhdmxsaDhPN09pMGVDZDBodnBhRTh3aUtaaElx?=
 =?utf-8?B?OHRwR2pKVnVmREs0ZVBBRWlCUDZkMk5xVW12dDV5OVNFRkxjZDhXV0FPWTBz?=
 =?utf-8?B?K1hrUGNSSy9RcXh1aUNnaW1yaE1Nc243MDNldUhrVDNpNERnTkdLck15ZEE0?=
 =?utf-8?B?R3ZISWtMTU9TZnBkNmhrZ2ZLZlJORzBTRHlGR3lGWjBEa0FlamJVeExMbUNu?=
 =?utf-8?B?WFlnbktYMDg0WVExbGtiVjR4N2dVRnhPeXJzUklreDhqOE9tYzJHbzlLTHRM?=
 =?utf-8?B?WXM2T2VDZG1nYnpwMnpGWVVQejhyTC9BVGI1NFZ4WmRXWGVZWGRhUWt4ZGt3?=
 =?utf-8?B?SjNpRDlrSDU5UWszUE1QU1pSYmlZOGZNQ2Y1OE50bHlxNDA1dTR5dEU5bE95?=
 =?utf-8?B?TjhabVB4L1pUTXNSd21ydkhtWWRVMUtpOGZTUVdzU3VtM0tsWkpuVHp5bUNh?=
 =?utf-8?B?SWNWWmgrblpXVk5ucTFKMDY3Y3lQZUMxRlB6ZlhFc3lqYkFBeTJqcVY1WjNB?=
 =?utf-8?B?TlVqQWIwZ09IdnRhLytzbnZoV0M4KzhzNTRnaVZ1RXAyZTFNdFh0blkwNXNu?=
 =?utf-8?B?UVljMEhaeFFYTDVMRHdGM2FaeDRjUmVxYkkzZitiSXFjZDh2OVlLcjI5WGVD?=
 =?utf-8?B?NHFuRDRlbUJ1eG1kbVlBVy9WRXlFWjhnck0vZS90YWI2dVRzKzlIbXNxRE4r?=
 =?utf-8?B?VmlrOHBQblpOcVhiaW5oTUVvSFBQemJKZExQOVZGVHJDVkVrSmMxYXlWbzMv?=
 =?utf-8?B?S0FKZm55ZGZHbXZtY3JRaCtPV1VzRzhlSTJjZ29OTmgwN21idklubHcxNWFJ?=
 =?utf-8?B?ckdmRklHdld5UEsvL1BNakpmVXBNZUZNemFmQnQyK0Q3YSt1MWV0Uk5VdkJV?=
 =?utf-8?B?bVRaN1FlMUtINzBock1HdlU0K1d3WnoxcmFKUjI5RGZIb203OXNsMXVQM1FJ?=
 =?utf-8?B?WmdzZkgySmp1ZEdhUUVobzJxbEJpRjJzaVVyUm5GUHo3U0tYSUFVem01VERV?=
 =?utf-8?B?UXVpaTZHTFdYczByOUpyUUtxK0JaNENvUng1RjZCTjNML1V1Wi9GZVoxS3ox?=
 =?utf-8?B?L09kUUl6aDdGVk90Y2kyRzdJcXltUGJEdnlZblJHQ2MzU1dFWFJ2N3pWc3lJ?=
 =?utf-8?B?T1A4WVFOT3VBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q256Tnk4bWtTbmVjUm9uSmNRMDZuTllKOVR5ODdJOTBFc0dKS2V1RlNaVFVj?=
 =?utf-8?B?UWl6QVE2SExmaEgwM1ZUQkQzMHNmdDhYZWZXSHVaR2prRHFqb0NURFZCNXJ0?=
 =?utf-8?B?SkhmNFgvcHUvZ3NQMTJzMzFLd29KeGZWeFdLWVBzNUQ1NjJUOTlRZ004enNa?=
 =?utf-8?B?N0pLRm5CSnZzeUIwbUpaY0ZIVDdUdEtSaE9PQ3VIWFlVZkJHL2IrU3dIUW50?=
 =?utf-8?B?SG9BdVp2ajFKd09lWTBmSEJrVUJpQVl2QzhGM2xOVkJYU0JNL01KSXJMM3ZO?=
 =?utf-8?B?OUxnMFNFY2YwSTlRYlJrTllzTEVVQ0dhSDFyWDA2VmFQaTdOLzdSNkhVVmRi?=
 =?utf-8?B?QnNoVWVkdXFQanJZQjI0RjhoMEhhSTFFbjJPK3BRN2JCdEsvMUNXMmN5MkRK?=
 =?utf-8?B?c1VuOGNzZTM1WUQya1ZJbGhGT1J1elJsSS9WVGFhSHNPakVZcG5VMU9ERkVo?=
 =?utf-8?B?bXcyMWtiQ1lhQVpoUEU4K3JiemNSM3Rsa3hkTllaOEp6ZHREdzA4ZW16VlFa?=
 =?utf-8?B?UlFnYWpBeUlqRy85SFZlakpEb2tTUUxHUHA0TDA4QjY4LzJhcUVCMFg4dmVS?=
 =?utf-8?B?cUtFODZnYXNsdmJ5YzlmYU9xWlI4RnZxenFVNmlYNXo3SUtCUnpQOUFoOG9P?=
 =?utf-8?B?VVdRV0VhcHRmajhjK3o1Zy82SE1uWkhsWUlKWDEyRjlhOUw0Y3hVK2RkMnk0?=
 =?utf-8?B?YUZpQW5sc2xDbHp1cm85L0FWNHEwV2dlZFJaU1B5TFJ4QytFNi90aXRsUkp3?=
 =?utf-8?B?WmpJb1hnd3FJNHh4aXdPY09PVkk1MWxTYWlVWnpYQ1BhQTJ4c0ltL2hUbDBj?=
 =?utf-8?B?V2lXWWRlREU2d3RpTkN4WmVUVk01ZU5CcGtzMUNJcGhKTWVpZXFNNHNhU3hG?=
 =?utf-8?B?a256QzB3cUZOZDRUV3Y1R1NsUFFKTytTajFwTXpwL0pJOVZjajhkd1RIenhQ?=
 =?utf-8?B?NHZRMmFvMTVnTzB5b1M4RUFLWlY0YnloaVIrUU1jalhob3VsdzFrWmcvb1J6?=
 =?utf-8?B?Y1VLL3VtNGVhSUVBR1BraHpkdkFYQ3JhTHhhOEZiUDExVkY1aTVQSFdwbjc1?=
 =?utf-8?B?N0ppc0t3TzRESy9LV3lRc0tKYlpvY2d0NWdEc1prZU44T1pLTnR5bDNadGd4?=
 =?utf-8?B?dzBKdEdJNWNraFNIbXl2bFI3VDROMUxzV2NEdVFsb3pxZHhQd2ovM21vcXox?=
 =?utf-8?B?dWkrNFNnbHVLU05WWE1UVkRBbWJKVWljcDIyQ0dBMnNrdGVwMjU4QmRnaUFQ?=
 =?utf-8?B?bjkzV0dTZ3k2cC9SQ1lHL3U4TGMyTXIxNVZwVnQ3V1NKaWVrK2FBUk5yT3Iy?=
 =?utf-8?B?S0dsTThLTWdQeVFFbG1XbVFIa2t0cFRPTTZKajlKd3JRMWRneEdUcCthZkdH?=
 =?utf-8?B?VUtnY1pYQ2krOGJzekZWZTdod3lqTDJMZFMrekF3cWJsMkRHN3hTMDNKdDh3?=
 =?utf-8?B?RXIvSVBHVTR4ZkdHelFmMVZVdzh4ZWlSNXNQbktkTGE2cWxsL0ErYnJueEc2?=
 =?utf-8?B?QlRIdGFNbDIxQld1RjhrMm1iK1hPbjV2eUxBSGRBMTNKbDA1WGZzWUo3bUFL?=
 =?utf-8?B?NmlLeExDQXdFSE9Kc01MQkVTL2VSTkNPRGZYM09pZUZ1dTRTc0UzRUdjem0x?=
 =?utf-8?B?RmVmVTRPeEJ3ck5yR1dTNzdzYVZTN2FlVHdvQTgydjNlTWEyREFhTzRFSXRC?=
 =?utf-8?B?clNhTnRXTEtkZjYwRjAzVlFpZmVoQU1NRHlxRUU1REttVmFXdGY0UlV4QVJk?=
 =?utf-8?B?YWo1N3NucEJQQVU1TTR5R1VOdGFPWTJoZTJlNEZUVmdRd1FHY2FITDJsU3pk?=
 =?utf-8?B?a3RERE51Vml6WUdzMTgxT0JZKzVzUGN4cnZzclgwQzc2WXRMeGZLNWprL0Qv?=
 =?utf-8?B?SzltbmpsRG5tS2xJTWFScUpPdWRxS0RPejVHWS90cUZNbkVJTDUybW5MZmVv?=
 =?utf-8?B?NWJqdUU2aWV4c2R4T2dHN3JEeFM5WGhuYy90RTFaYzU5Wmd1WGJTYXNWTkJi?=
 =?utf-8?B?SjdrTzgvWnIwZnQwRE5ZMDlhd1lmZGhHVjVmbU9yOVNQWno0WGR5ZTV5Lzcx?=
 =?utf-8?B?eEdCR0p6bGZZbzJjcU9tQSticGVwR29XL0hNc3J0OGwyekRQMXJHT24vakVF?=
 =?utf-8?B?c01tMnd4NWRXSndEWFBnTHlYdFJmeSt4TkhzL0QybGhxclVhaUtxSTRTM1ZE?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b3e7d6-53fc-44f3-3bcf-08dd88bbd7df
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 14:24:12.0651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IMsxfaLzLNhR3P6xyQoJsoLl2DmxyhlNcKrAS6u0KceCuNi4cgX93ppvwBvX/o50tNS0l1bSGYIg1MRV+DEOpAyv2RnYBEBKwBbn22W0PHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4958
X-OriginatorOrg: intel.com

On 4/30/2025 11:29 AM, Edgecombe, Rick P wrote:
> 
> So let's drop the code but not the idea. Chang what do you think of that?
Sure, that makes sense. Thanks for bringing up this case.

Staring at the struct guest_fpu fields, some of them appear to match 
with fields in fpstate. In any case, I agree it would be helpful to 
consider a follow-up series after this.

Thanks,
Chang

