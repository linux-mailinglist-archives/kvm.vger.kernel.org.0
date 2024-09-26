Return-Path: <kvm+bounces-27584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B49987B1D
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:23:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74A9A1C224FE
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 22:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB69F18E764;
	Thu, 26 Sep 2024 22:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NV01RE/E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6AE18E749;
	Thu, 26 Sep 2024 22:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727389375; cv=fail; b=ZTT20UTb2ULWDklg+otEX+QBMaESSPEv5pkRxdpOhTzGt23Rjk3+O3oyvqB4qrNiLgz6292yRreZfJYEHybfJB2njtiUwTSjp/R/lMmbqtKBSmbI90n28Ij1xSsusBsRXj5llL7uK33m4c2XOD8qifHN3R5sPkcbHhWvYNNv0Yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727389375; c=relaxed/simple;
	bh=AszswHHbSTDkaKM5YIsnnLQXm0xUuA053Sv3Zk9XRak=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mr6C7nNwRMh/CKw9rukIWxPoFtET/u2H5Rlirto3ksRlUtPCmNltHSQL8+XwZVoLutJ3BBxTdtRemAvxsYOPJb2tCyzIxp3FaVvTmzpiP3jNATFYeWSud+a8rNE5mIZDgRD8UbGztlHw04t0XoLCFOB3XqsDNscwILsZCkalriY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NV01RE/E; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727389373; x=1758925373;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AszswHHbSTDkaKM5YIsnnLQXm0xUuA053Sv3Zk9XRak=;
  b=NV01RE/EbWPVwvqFE6meHnhL5SkZNPsvMRhgkUQ0speZQvDd/4ax61cg
   C1gNAU2IGDk/95NuaLXnkQroScuNiabw00lpxPTY3aoDYhbHmpW5H5hIV
   LzLS9Qevn4/Av7xoOg38UgOPsYTzpmFhc2/hQmKeDa3KswtsHQznWzPy2
   VFFByOhqwLckgOi+PlruFkX68EQlpnyaqOUOwuUBozaz3z9Autme2/cLW
   0ZyyWlhHyhpQsXshw9SYPLmEsMht0ku5K4cSArOopEVES9d/3MZFYp/+H
   YmQEghVkMu3X2MtmqgPJKLKYIBC9DkoyVzQKVhQLEj5FNVt067fuPb/ic
   g==;
X-CSE-ConnectionGUID: VoYpBRyXSqWZh2yRFncWVA==
X-CSE-MsgGUID: OJacrokqRoavg91O7WYf0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11207"; a="26686975"
X-IronPort-AV: E=Sophos;i="6.11,156,1725346800"; 
   d="scan'208";a="26686975"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2024 15:22:52 -0700
X-CSE-ConnectionGUID: TUj9yYkoSGqTfYIB4OcRbg==
X-CSE-MsgGUID: eJ9IoquvQ8uezNeprBpHWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,156,1725346800"; 
   d="scan'208";a="72312671"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Sep 2024 15:22:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 26 Sep 2024 15:22:51 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 26 Sep 2024 15:22:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 26 Sep 2024 15:22:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 26 Sep 2024 15:22:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qQdikEJkGHCS6PoHauvY9VziF4do9czdgHJ8XKMEmSKG+KwhzoElPqujMeeIYkZsnW1R95l3QOkuR7IEz/gLVPviS0yhcct5vKPQLRwpbnNGLqrRAON40V+i7+d5o+wOUTL0yhuxxH6qYaisnLgtdARDFYu63nTJer2IRnj+lVkJ3GcqXPlFQCdyaAWkWzcHAoHzho6FRInydb6hbYFcZBq0/4/0QsuDH+alQdtVmE9kjHGkTszwdV2RIVW7W+xNZvwmMHytcCd2nSiqI7Ydb+arATNWfJZHLOGwGIFlgXFsnDjFXfzP9e8TWmmOViWiSzT9hWcapbnrFO9CIA+6yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VopegB+SOomcasEMZoI9bqOQBY43NKHSZm1+z+Ah9tw=;
 b=vEQgXAlCSdEtZWM3M+dE7wzv1gpb9EeT/gpjm6kE4RzAOpWbz8XlkW8Nv1D11AZ/qZoNjQtVaFYa3h1jORTk22k8MCjUkrNy2/aPF4jAEwppMLDkFlzRoREIYMcbbMXptdmn2A+E9kXSXmxyZzR7q+y+3QY9Yda16AsXfzT+yoR4KRgACGkTcImR68mHAE/vByD7NZWtetxHwGHcddQz/s1z8oifBkYwslcy2UfYM5+G8hvFCZgQXCymn89sn9AxUcpWHCi0jzhq7L/u4qK0JQSBdBbau4RqG+0SwjusBedNnLCebKZHzhkXJNk2gCdbdvAKIsvtAnhiF1ftw/a//Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6053.namprd11.prod.outlook.com (2603:10b6:510:1d1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Thu, 26 Sep
 2024 22:22:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 22:22:47 +0000
Message-ID: <62ca1338-2d10-4299-ab7e-361a811bd667@intel.com>
Date: Fri, 27 Sep 2024 10:22:40 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
To: "Hansen, Dave" <dave.hansen@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org" <peterz@infradead.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
References: <cover.1727173372.git.kai.huang@intel.com>
 <101f6f252db860ad7a7433596006da0d210dd5cb.1727173372.git.kai.huang@intel.com>
 <408dee3f-a466-4746-92d3-adf54d35ec7c@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <408dee3f-a466-4746-92d3-adf54d35ec7c@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::12) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB6053:EE_
X-MS-Office365-Filtering-Correlation-Id: c395590c-021b-4044-3cb7-08dcde79c03a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MkdmRFFLc3VFcG9tMlVtWWNuZC90U3ZLWFhmb3ByZ3JSRU41VzZ4QzJBZDIw?=
 =?utf-8?B?VU05QlNSVkRTMmRZcis4a0R2bXl3TFNCTTVGSTdXMnpUcTJOdXVtVGxnTmxW?=
 =?utf-8?B?aFlid0d3R2tSZDdFdENKU1lZWjVINlNVT1VIOXdiQmQ0WnJUU09CUTNnbFBQ?=
 =?utf-8?B?R3gzaEd6YytvWnNFOFh0UmxMTDFUdTdzeW1GMm8zckNaY3U4TXdvT2RlMW9l?=
 =?utf-8?B?NmphOHR2K1l0NjZqNzQxZTZ3bndFd05JU2VTODJ3b1FWRm84YTV3NTdzQ2JY?=
 =?utf-8?B?YldXRDB1SkkxWi9UMkJ4R1NqTkRXdTd5RDZvcytZdjd0dTBRWmtoR3NMamlh?=
 =?utf-8?B?R0lXM1VwZzJwcGFCdWVaVXNPSHBqQ211UEE0TkJhOTVaUGI0dTk3SW9uZHlH?=
 =?utf-8?B?bS9RODZISGkzMnNuRGYvNlZ4ZUVJR0pPZE13ZGdseVNOMXNCanJJVVppeU9Q?=
 =?utf-8?B?ZExjY3lucEF5S01XSkxCT1htcWxPbE44VVJiMlQ5NW95WTVIdkxYSnIyTE01?=
 =?utf-8?B?ZngwTVc0eE5qV0tIU0VXYnFLM3daNjhLK3liZGtQcDJSdkkzOGh0eXprMGE5?=
 =?utf-8?B?SzNRRmdmVkJnOHdXUExweEFSSFJ4SFFQUEpndkU4TDBkdjdQRGFoSFBPT0d3?=
 =?utf-8?B?emdTcFhLbGlXTldKSmtCQUlPSVdsNlZNYk1TM1JVTWdmbGtrY3dnWXdGMklZ?=
 =?utf-8?B?WHRDcDBnZWhQczRzdjJkci8vaW1MUWZpSU1TeTRuTEdFWnZvc1U4K2EwMFYr?=
 =?utf-8?B?dGV2azNLTnFGZE9UZTAwTzBUaU9Hei83WFdvK0hiZEtVd0FzcXJ5Z1VkQ0Fa?=
 =?utf-8?B?MDU5cEN2blE4c2lFRUVyZ3ZyRUpqOFc1NGk1ZFY1NzR1VXV1eFFlcEdtTlFG?=
 =?utf-8?B?SEZ5UHFsYmJGdFdTU28zTjFrSEc2dDduVDdNTzFIZ2hnQ0QrK1BSUXhwc3Br?=
 =?utf-8?B?VE4ySWRVaGVmWWFFemRuSnkxNXdGRjhtaDQxMldkektYL0t5Rlc0Zm9BT0Vs?=
 =?utf-8?B?LzYvRXZNaUlrUUVXOFNtNnVxOGQzdWNDNVRMRTgrVmhqRlJad0xCTkNvazhx?=
 =?utf-8?B?emdUYVBKU0piNnhtMTAvdUJiWnZEQSsxajZaK3Njc0ZMOVBTcVI2Szg0SXdr?=
 =?utf-8?B?V0lkNlFLcWluMmdUdE5nT3IzVWUzSkFueTFMRS8wclpydnVOS2hwMTNqZi9V?=
 =?utf-8?B?RXhyNUp4VXdscFowOEtCcEdjUVhDM1RBRDRNUzJiaktGZFlIbGtYdmVlOW5z?=
 =?utf-8?B?dmVSRTVoWkd5dVNLaFdlczQ0WmxGZE4vM0xjL1Z5WElJRktNQlcvbmZGQUFr?=
 =?utf-8?B?VVE3YnpDZVYrN3ZndWlVMjh3NkR6SDVkSURXQzN1ZWdOWHk4ODZYLytmeElp?=
 =?utf-8?B?RW9rOFA2eXM4WlZoRnpLY1ZaMENuTW1NWEJGclliNUl3Z203d3V0WmJteWhz?=
 =?utf-8?B?WFpoZVI2ZmdTWkFRalFtS3dleUtPdjZMK011QnFuTU9SWURzRHc2ZG9wV00v?=
 =?utf-8?B?MFpVYjRXdFhiVGozbnBndW14U3dnSzVFZUdJNUJ3Mk16aFpGU2FibHVodzQr?=
 =?utf-8?B?KzFEbmd1dFBLYkpjWFVVMlBlbng0MmgwbDRFZ1p4TEJrcVF6TkxUNUF2MkE2?=
 =?utf-8?B?eVV6TFM5SlluSEN6MlQwanpzQ09TRUZNTG84U1pOa3BKbkJ4TmtJcTBOby9G?=
 =?utf-8?B?TklVeHBPNzBwQUhIM3VqMkQ2Y3FtZ0IvaFZzWmFta1E5KzJSKzlxcE1HOXcw?=
 =?utf-8?B?WjBwVStLSmNYKzhuRWNUNU15Q25RZ040ckJjL3RCMmlvL1BwMFNBdU9Jb3FU?=
 =?utf-8?B?cytTb2tKd2FMYm9ocC93TWsyQ0ladmV6Sm03M0wrdFNoNUlzSDJFRmVBNmhv?=
 =?utf-8?B?T0tHSWU1VUxhdEE3U09VY295dE5rd1FDWHlYeE9RVDh0SkE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V013Zmg3Q3cvc0lKZStHL3piMnpvb1k3NkpjWWMrcDd1aXJEQmxqZDg5OUlI?=
 =?utf-8?B?aXFUR2NUejgxVGhkQUtCMVA4SmpLdCsxV0RhaktUMm9TZEg1TTcvdlNpMjZQ?=
 =?utf-8?B?cFRnWDljbkZXN1FtdFhpL2pQMWNwVmZZUk9vTnhEZnN6ZitSYkl6SjArN1pq?=
 =?utf-8?B?dUVnTVJJb3prU1hCK21aaGpYSjZtYWs4RTh3OS84SDRPM2diZjhnZUtLMFg2?=
 =?utf-8?B?aWoxMjg3d1FGZ2UvYjVaQjlqaVp5UmhUekw3d2hqNFR3WjRHTzdVTjRrMDBt?=
 =?utf-8?B?aVROM2E2enVPOU1hTG5Sc2x5Wld1T2FKeE5LWWh4Q0pjRXNEaXJNQ0ZVSkVL?=
 =?utf-8?B?YTdrRkxDN2MzNHNjeDdOQlgrbElkbUR2cHhoT2swT2ZRaStQZER0RUMyeFN3?=
 =?utf-8?B?aStMV3ZSaVNHSTdSOW9XTmp0NjZMSkZjc21FWjBTTlV4Rnc2WTY4dURqMEdJ?=
 =?utf-8?B?STQyK01lTDQ0U3Y2NHNVaVUzcG9sdzFEQ2RGdWhURmJKRkZRTFhKTmVMK09E?=
 =?utf-8?B?MGpCMS9aOHBLTTlwc0hHbU9kUFRCYURZWklFVnJzYjhMNWp4ZDhRV0lpemFC?=
 =?utf-8?B?S2gxd2YxWDQvaVRXZjRVRDBSKzdWZysybmdPL01HWCtNd0QzK3lyQUpYYWhF?=
 =?utf-8?B?NFR0T3JwbnU4dytZckdFMlNZaEVwTDN3V2dPa3JQeDF2VjZJSVY2NWZ4Snla?=
 =?utf-8?B?WUU5SC85VjJGWmJ5ZndWZEhrR3M1MDRZRWNxeDF4NkVEbCsvcFpVdi8vajUz?=
 =?utf-8?B?eEpTY1cxdmZaZWMxdFJvTXNRdCs5WU0zYnl1MXkxWURnWE4zUGNkZFNmQUg4?=
 =?utf-8?B?REpidHlIa2RJdHJ1ckQ2ZUwzaHVFMUxwQ2x5UU9tUnU5YW5ycjdvK0pjMWpO?=
 =?utf-8?B?Z3FGSUluNmN5OXFVRVNXcE5JTFFBMFpnUVp3ZytlekUrOENDU1F4alNkNm8r?=
 =?utf-8?B?ZVJJNDR0NjdubVAwekRCcHFVQlB6MEJ2L1kwbGtoV0ZCSE9nV2p3L0paZHo4?=
 =?utf-8?B?cXBBeUJvUGprTFlHRDY1SGFWaURIdHplUmlOOEJlQ01VT3kxZlhsYXdQYUcv?=
 =?utf-8?B?djZhcHZaZkZReHdqME90UkZqc3lZN3R5RWNuYXV5a2E0cUxqeDJ3eDFlRVBC?=
 =?utf-8?B?QjQwbnVidmN0V2dHWDhiMWdndFRMdytRdkd0eDlHT1JtNHNIc2toZmtvWmQ4?=
 =?utf-8?B?ZUxhNSswYXV3VGh0K0Y5UlNrdnErSGpubGVOcFQ4QlJNYlpPMTNOUlk2c3J3?=
 =?utf-8?B?R1ZQZjE0WndrV05hVkhNSk5JRFl4cVFPMTJVKzZCeG9ieXlJMFNyYjk4V2lP?=
 =?utf-8?B?aFNtYXdFSXNjYVdLYTdQUmE3ZUxNWkhsTFpWOXI2czFsWXpvekRnZjZzWXF2?=
 =?utf-8?B?d3RIUjVpS0tIK29PS1pTMVVBdlBFR29HR3FLYlhIYm1mNzhuT0JGdHlLNEtR?=
 =?utf-8?B?eHlZMDBWVmdvai9INnI1TzBYZXFFaThiYm9vOVp0WUppaWhKYTNDQXVBS25m?=
 =?utf-8?B?RHdNaE41NEJMSXF4UjY4QmVVTmg1UlRSb0tqTDVDSnV0bU9FWVoyY0V0VUo4?=
 =?utf-8?B?eVhXdWYrTm4vR3h0RW85eWNGVUtISzBkTWJLZ0I5bHRRSnMraEQzN0hwVXJv?=
 =?utf-8?B?RWpsZXZXcmIxbzdJc3lGaW85K3IvUDFjRmVWMGkzbkd4L1l0bTRibmJYdXJw?=
 =?utf-8?B?ZWk5SXc2c0U5VUpUV0swbGxUaTlVbVRRWG81cW0yaTg0Y0NtQXRGaVR2MjEy?=
 =?utf-8?B?TG1ZWjFZblFvRVJYVzh1b0IvR0g0aEdwTVVHaUlVSi9kaU0vYy9GWlUrYXkx?=
 =?utf-8?B?RkRWMjBLN2xiczhFR0ViU3p3czlCT0huaGFPVzNXT1J0Wlo2WW9HdDBDMGd3?=
 =?utf-8?B?Q093MUlsYWNhR1AyZkI0R3VzRUFMblJYV2Z5bGp5YmtIczkwRXdDWUh6L21K?=
 =?utf-8?B?Q01HQkxHZld1Ujd3S3cvSzRkaElZdkdWWk8ySGJHcSthdy93dGl5T1drZkVN?=
 =?utf-8?B?U2ZqWmdFSURXVVV3YUFKOHBqMzJvNmwrUm5tUnZxRVZUTU0vMXV6NGMyZjdr?=
 =?utf-8?B?OTNnaHlKWjJLWCtZQ1d3UmxmcGg2NGdzdHJ1eWZueHExajI3eWhOS2pWRDRy?=
 =?utf-8?Q?B0GStqi9rDbkD33gH2EnK2oRI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c395590c-021b-4044-3cb7-08dcde79c03a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 22:22:47.8908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fhb8CrCvKFZRq+IF5Z8N79a5DTFjO6lWZZL7r18HQwYnoCykUsGzVWA/23tF5WQo3osEttT5xlJM1ks45f905A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6053
X-OriginatorOrg: intel.com



On 27/09/2024 3:47 am, Hansen, Dave wrote:
> On 9/24/24 04:28, Kai Huang wrote:
>> +#define build_sysmd_read(_size)							\
>> +static int __read_sys_metadata_field##_size(u64 field_id, u##_size *val)	\
>> +{										\
>> +	u64 tmp;								\
>> +	int ret;								\
>> +										\
>> +	ret = tdh_sys_rd(field_id, &tmp);					\
>> +	if (ret)								\
>> +		return ret;							\
>> +										\
>> +	*val = tmp;								\
>> +										\
>> +	return 0;								\
>>   }
> 
> Why?  What's so important about having the compiler do the copy?
> 
> 
> #define read_sys_metadata_field(id, val) 	\
> 	__read_sys_metadata_field(id, val, sizeof (*(val)))
> 
> static int __read_sys_metadata_field(u64 field_id, void *ptr, int size)
> {
> 	...
> 	memcpy(ptr, &tmp, size);
> 
> 	return 0;
> }
> 
> There's one simple #define there so that users don't have to do the
> sizeof and can't screw it up.

Yes we can do this.  This is basically what I did in the previous version:

https://lore.kernel.org/kvm/0403cdb142b40b9838feeb222eb75a4831f6b46d.1724741926.git.kai.huang@intel.com/

But Dan commented using typeless 'void *' and 'size' is kinda a step 
backwards and we should do something similar to build_mmio_read():

https://lore.kernel.org/kvm/66db75497a213_22a2294b@dwillia2-xfh.jf.intel.com.notmuch/

Hi Dan,

I think what Dave suggested makes sense.  If the concern is using 
__read_sys_metadata_field() directly isn't typesafe, we can add a 
comment to it saying callers should not use it directly and use 
read_sys_metadata_field() instead.

Dave's approach also makes the LoC slightly shorter, and cleaner from 
the perspective that we don't need to explicitly specify the '16/32/64' 
in the READ_SYS_INFO() macro anymore as shown in here:

https://lore.kernel.org/kvm/79c256b8978310803bb4de48cd81dd373330cbc2.1727173372.git.kai.huang@intel.com/

Please let me know your comment?




