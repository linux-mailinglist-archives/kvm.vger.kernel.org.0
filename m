Return-Path: <kvm+bounces-17988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E619D8CC90A
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 00:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4753CB213A6
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 22:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7278148316;
	Wed, 22 May 2024 22:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FFLmzmEG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B1E148303;
	Wed, 22 May 2024 22:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716416888; cv=fail; b=Hj0S+AJHG3UnL6etGGh/5Nt9DBUFx9Fp8j1eI9dg7zHWY1tALwElRkbuNpH4LrLjtrl9omj9P5+x5QhiTfksg/w4pnh/WxhnhCV6uFLSeIWubwbcGjze3plhANyrKxeC3KU/kyZkdXarB634QpROItWbwrhpo59SHYQsH0ZgDwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716416888; c=relaxed/simple;
	bh=4Z31vLTjN/S12BkII/URMJQnGrboNI6b6WQsSo+Ibjc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SQhrl1Nawv7dZcNWHLLSTKXWA8ZWQcMtQy+fhvEKhU7LyICbBw8e9HiTtAS+pc8xnby0cQ/7CWFumzfCgnPEYxSPfnYjj0EesQxetDxXdaCa4zhTqzPggVq0VfZUCtjrxl6effHpg1M9rjmjsgUYsIFXJSkSCkxR8ZxQb+oRTTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FFLmzmEG; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716416886; x=1747952886;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4Z31vLTjN/S12BkII/URMJQnGrboNI6b6WQsSo+Ibjc=;
  b=FFLmzmEGj9lU2bjgOitUQypASPd7E1A5IB3k9bFa60VvKVhUKJcfsmRw
   86X80G5V/z2k0K+U+W219yi+LRUeCtpHqzzRGn+8M5buXydWlvZ385JJm
   Z31CNPhLxUzwIX4xsUckYc/v8iS/LLsnx71EHTcSW7hwrzo6E03Pq+Q37
   6GCTeNq7CROrQobxKEzMr11sGKbQhmS1sPN/C8y4FvIxEGsnouYAgD1Ij
   d9zFQiHfPBvK65j/Dn/vbZc0SZDj6vAc4cdxFf6AviKknAF6IIEpCYhTW
   KeZgQv/nmgPPXH/bDFgDyo4SePiSuZvKQ67EWgsQ2tiJywKDpL57WLzbb
   Q==;
X-CSE-ConnectionGUID: mG62dZoxTJ2wKn+DNwnygA==
X-CSE-MsgGUID: yOp19mmoSE+Ge41/iHpA9A==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12481933"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12481933"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 15:28:05 -0700
X-CSE-ConnectionGUID: p3UBkDgKQQeG4aT1oKthPw==
X-CSE-MsgGUID: Zb+icH01Rb2I394tUeS/gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="64678086"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 15:28:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 15:28:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 15:28:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 15:28:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 15:28:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWcyCf4Uj95lTeFx6vLN0ffLyDZIS9BEZ0Ng6NGJSg7yC9O9pHxkIQCBgQu9Xs7L7v8XPBMb6dJOvxpF4grKsEWPL5TbX03H69r6i+6c2hBug4TpfSw4F4WOWT84xssbY7Bo/UlHPYDcIyPGoKaqWuUca+Zmo/W4DgK0GYa0wWwON2DDKZa+79a/umz4fWqAI8lkxrKLaHPDhCkLxwW96TCMNopKcF37JiCqeIko2tsDwfjJhAvVdDAcK412umqKc/5YDZCbw7Yjeg+Q/OqMzr3aSPm+ATSSfxHlSAyqb7ajbgH9bhrg2VKY6ORTIPzDphLtXqi0Nlle78Rk7qiQ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+NFPFa+kr2zCEiO7kmGuo4pMHe0siwiygJ3CD0PRFTU=;
 b=hRqCpdgyHQUQJ9hV84fWlY0Y+8dT8m65d11FcdgttEoPxSoNsaww/+pfmQQP5ZKA04UJBJfA91LP+Xct7SzMRQHu7Pm1AYL1fHLMVWQZNgWDyuTSafVkfTi+aG2dCpQ82CLQ3qZmx4TZsxQpebBM/cC5FFSDn3lOxD6EFRdg9cmpAKsdS7W9QCa9aRuBtmBriLBrCwKkEJQttBtLBeZgee7HIOxCNyphXB2rGAUxNlZ0yVOx65tGIjmNk6bRIMEwhYoocACQz54C9i7AcbtklDhG7kiuhPaZ7AjCp9J/Z38N2YcoQmfQdwUoG/SjH8RDY2Dk4rodnxOXzglqMgfp9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7122.namprd11.prod.outlook.com (2603:10b6:510:20d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Wed, 22 May
 2024 22:28:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 22:28:01 +0000
Message-ID: <8b344a16-b28a-4f75-9c1a-a4edf2aa4a11@intel.com>
Date: Thu, 23 May 2024 10:27:53 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-4-seanjc@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240522022827.1690416-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::21) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB7122:EE_
X-MS-Office365-Filtering-Correlation-Id: e973f8e4-b771-40b1-9046-08dc7aae70b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S05kSlVqMDR4YXJyV1FVV3FXNG9YSGlNVGlpRzYxdzNFMXVWeVdWbjQvRmtH?=
 =?utf-8?B?cG1uTFVyWmVBMTRyendFei9QQVNPSFJJQUNDUy9JSVh2V3R6SWhPUmczVHkw?=
 =?utf-8?B?VW5Vem9KWUVnckdKbG9BUXRPMlBQRkhvNnkrQ0FHWnQ0MTBLZ1REZlZlY0Nx?=
 =?utf-8?B?SVh1ak5RTnZ2QW1paHFvcm5MSmlmTTdmVUtXdE0xc0FISENyNnRSVVlqVlFs?=
 =?utf-8?B?N3F2UnllV1hGZ1ltQWlNT2hXQ2NwMXlwZDFtNVpwVUhMQUUyMG5VemVpMGVT?=
 =?utf-8?B?Z052MGFvRWtRM3o1NWVaWUtENDhlQjViSG1UcGpkVmFtN2N1RURzVW1YYm5x?=
 =?utf-8?B?VFU0RzBDOEwxYmFqZ2F2anRxa1Z1UGFCYW9LdHBCc2Frdi9ic0RnYzBMYllj?=
 =?utf-8?B?SFBsdzJrek5rT0o2QnFoVjdSQlRRNnI3RHUxbG1sdHV6V1hqVDBFcCtBTFpP?=
 =?utf-8?B?cnhYcjgyR0JoU0NnU2kxdVlIc0p4UC9Mc212aUZ0R0ltTFE1Wisxd1pKVmla?=
 =?utf-8?B?VkZTUTI4eHllL2YwZjBaR1BRMlpaeEw4c056bWtnRWlvVjNyREdFSTdNQUo3?=
 =?utf-8?B?MksvREJjQUxiYWdUbngwbTFqanYxeVRza1VRYVBCcVlaa3Z2eGxJSzFLUm9o?=
 =?utf-8?B?dWRuME0rWEVVWFBoOENwR3ZlNDNuaFNDajA5cThJRXJjcUlKdjJvQW1mS2ts?=
 =?utf-8?B?QVVPU2gyUTVZQktpU3g4dzIxb1BDZ2FyekU3UUJHVGExekRNSk9pQ2JpYXRN?=
 =?utf-8?B?WW9wVDdRejd6dlpzMVlOT0pzTjFYaCtsWDVUV3hUQXVzUWdLU3Q5Z016RGtE?=
 =?utf-8?B?S09UMmplTlduYlhJRlZObmNvT1BmUVdjbVNoWUppZTF5dGEyRW1NRnoycU5s?=
 =?utf-8?B?cFoyWm8xWWhvSElqUmFDT2ltVXZsTi9CYy84T3hJMFJsUjk1UnI4OE5NS1BU?=
 =?utf-8?B?UHZkeHRtR0EyK1hLVG1JbnJvRFJBMk9XOU9GRnBWdFVneE9mNnlhS3k4QnY1?=
 =?utf-8?B?MlFTVFJMRHJhUnMyWkVYTUVQTnpRM3g2T3dXVmN2QnZNa3QwQU9PYVFhOGR1?=
 =?utf-8?B?bkROZW9MREhBSXhIU2szbU9yaWh2OHNXRXZ5S2xVMnJQaUxjdnpqczVqdndx?=
 =?utf-8?B?Z0VHblhmN21xWjNKc21CVDAvY05DWVhZaDIyS2picC9YVzFoVEFpcFhCTSto?=
 =?utf-8?B?UGdrSW9RR3FrQUlJZGRYVUhrYW5kaVVHNURtNXhtOVUwTUNrd3VReFB0SFRz?=
 =?utf-8?B?R2tyY25VVVUvYnZtTW5oU1FtbUcrd21ZWjg2ZzNERllpVm4yZXprSStlYXY2?=
 =?utf-8?B?WkpNc2diRGJhZCtzOUpsOGZVRmtmeW4wMWU0cHZpVkp4aWFMZjhPOEZlc2d2?=
 =?utf-8?B?R0xmNkYyS0ZoZ042WjI1Z1JtVEJ1WER6d0pHNEg3OGtFdW5XUGpzazE5Uko2?=
 =?utf-8?B?czRjQTJ5eS9jSkMzbnB6MmlHZWhGWWVLTEM0RUM0b25lbmxZaGNYVytQd1dD?=
 =?utf-8?B?TkNMdEt6QVA3ZWNUWGZ5VFAyZVJZZHY3cnduWmpTQTNaRnFrM3I3WGZCUllI?=
 =?utf-8?B?bkl5eEg5dlpCUWlBaStxbnZnLzJHdk9zTjV3R0ZtUWZ2Z1FMcEZCYzRGNy9s?=
 =?utf-8?B?TEI3VjVQUktqdzU0L3ltNmZCSnlDYWZxajByRzZDZUV2MHBkcElpSlY2eVRo?=
 =?utf-8?B?QUNYTmw1S2NGY29JVFdzdThCQ1UzaWpGQzFiZ3pvaXFaaElqVHRWR1JnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2NreThUYVc3NVJWMGM4TEpNZHp0UXVuelMwS2JTOWtkKzhpUVQ5b0RYQzZi?=
 =?utf-8?B?dXppeTg0RUI4clk5bGFLZE5TMkxqeGkzcHpVSFFLM1J0M2w5VWRrTW5oaXg3?=
 =?utf-8?B?NUh1cTI2RjhxTmNackJtOXUzdGhLRzZSb2ZsNFBnb0k1RUozWG11bjFlLys5?=
 =?utf-8?B?Qm9iQ09SYXZVTEFhUndoYVRoRFJidW05K28vd1lYV2ZaS2hGaHJZMm91b3RH?=
 =?utf-8?B?TXJEcWVqWlh2ZHV2aTRyTWtOeHh4blgrcmtUUlE3Z00vOHh2V201dzZSSzZv?=
 =?utf-8?B?eEMwOVBKdHV3WGFWdnRBVCtpM2U4OEJFd2ZZQVp0bVlaN2N3c05kWnpOK21r?=
 =?utf-8?B?ZTJjazZZS0VFSGlEeGFKUWF4M0FOTVNuOUcvVFYwWHlKRmhFMlNkMkIzbFVK?=
 =?utf-8?B?bjBSL3N0cjJzT1VsZlRqL05HcWRqSHlCcXVaWWF4VWlPb2xLNnNTZHlEc0Z3?=
 =?utf-8?B?SXZhOFpETjN4WVpwUUJiMHQ3cjBvUHJsTHdxeVVaaXlVMW4zNjNCY3JNbUsv?=
 =?utf-8?B?ZGRidUZsWHdQcWZKZjliYXc4ajczZGF3UHFIREJmOURDRDlLZzRSMEtCdnVY?=
 =?utf-8?B?NHlZV29FU2lGMkEybHNpT1JLMno5RTNNSWg2MU5GMVloZ0pRQVBpRnQ5Z2dl?=
 =?utf-8?B?eUZTbit1ZTgxOS84U1ZOK2tEbVJNaDZsQWUxclluT1E3WHdRYk9OL1NPdzlk?=
 =?utf-8?B?ZC9sWm4xN3pOYXY3UmtSZmR3K0d4TVg5SjUrOU01czg3UzZMRVJqQzhtbGxO?=
 =?utf-8?B?ZGUveXlGWEcyb2p6cnJ6Qk0zaUhmdlBNeHE0WEtKMUptM1dUV2p0WlVEVzVM?=
 =?utf-8?B?ZXlIWDZMNDlpQ0xnTkJEWXlEZ3pTMnp6M3ZOV3BIa3FiSFZkaHE3MnFlaUxM?=
 =?utf-8?B?ekVoNHpEbDFwOXNnRTZ4b0lEdTIwc1dvdWNUWUNjcjVwa2xoMVZNRlpqZXhv?=
 =?utf-8?B?R3YvZTJpV24zaFRPY3FNdUVOOWpiRmVGNG91R3pwZGp6R1NWSWs1aVdpQzla?=
 =?utf-8?B?d2syY1Zpd3JsWjlGTHNXNUNFK1E2RXlnWEtMeWVOTk9wNGJOVGgwdlpmZWor?=
 =?utf-8?B?L1pod3JNNE40ZlMyWTBUUHIwMEN1WUJDMHc0VkdISzhudG5DZjZGRDRLejBu?=
 =?utf-8?B?TjVKbTA1WWlnR3AxMWwzbnVLWEtmc0hyYUxwcFZvejZXa0lPUEM3NTJCbjV5?=
 =?utf-8?B?dGlDMU1KbmQwa1RXdlhaY3hwNjcwNWxRZDY0bmJHUXBCZmpMTks3elJFakp5?=
 =?utf-8?B?L2FEOE9nNHc5b2pFQ1BVOTJuemwrRTJSZzM5d2pXbXd5dGcvYlkvcE0wUGhq?=
 =?utf-8?B?UzBFMUtuUnVuaFRTNXJybGZjaUl4ZEtkdG5GemRWcjFhWXdYVm1EbllkdlJQ?=
 =?utf-8?B?aVRhdDBCTDZ4cmNiZFFrTmtuS1kxRWhBM0Z5T3graDBNaitlWVFPZjhaY2pM?=
 =?utf-8?B?QWFDdGg1MUVsczdldU1lc2F0dGhYYmJ6S0NDenBjSHFTV1VWMzVPVVBBaGFO?=
 =?utf-8?B?aisxdlR5ZTk1MisyUDRFMER6M2laakVDQXpNVWNlQUNRRGhQa2VtNTNMQ2VC?=
 =?utf-8?B?cHMvZHlKMG0zSDUwY2thcmhZbGJMZlpUVG5CS3B6V0szemU3c2RuQ2pBaWxC?=
 =?utf-8?B?dTdUeERQRHB3RENYUGVvRFN0Q1ZIK1dPUkMyNG9nSlgzYms1cEEzNEowaVd6?=
 =?utf-8?B?cWx0T3I3UlFMREhneGEzdXI3UXFyRXRnK09uVWticWtvQnBuL2h5TTlWdlp4?=
 =?utf-8?B?NVFCcHlZdXdlOVk4RGdxMGdwQURpN0U4NmhhVU42c0ZLdCtiWEEvN2QxU1du?=
 =?utf-8?B?dlI4a2YzK0htNEsxOWIxNXBQajZtQmwyell1WTFubUw2KzlLb0hPdVZ1QkVH?=
 =?utf-8?B?R2d3ckw5RTBYRVFMbUwwdXUwZWJ3U3QreUZkc3VsU1FSVkF6WnlOQllpbDg2?=
 =?utf-8?B?SmVjbnFSbXVYNndxeDZuS0FqNnN6RnlobmxmM29rdXhSZkdQSUNNVGRET1BV?=
 =?utf-8?B?SU1wbDk3V2Z5WHFWL2dhY0dFeGVKRnoxUzFnbTA5WnRmc21wZ1AxK1FTQVhY?=
 =?utf-8?B?UG5VK3VmQVFGLzdXbVpvMW1qdGc0bkdLVVIrS01lRTNwa0txRHIzY2swcXlk?=
 =?utf-8?Q?FeR89zcNJf0/BHtb/nBkWk9eB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e973f8e4-b771-40b1-9046-08dc7aae70b8
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 22:28:01.5867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vs7uA3XcvORExQtNZbOeVa0psFntvhu3tuw9ohMm6trcrh9rrEuAFv7okc4S6YLe8HOWTnZR64SrsrwfpbYTYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7122
X-OriginatorOrg: intel.com



On 22/05/2024 2:28 pm, Sean Christopherson wrote:
> Add an off-by-default module param, enable_virt_at_load, to let userspace
> force virtualization to be enabled in hardware when KVM is initialized,
> i.e. just before /dev/kvm is exposed to userspace.  Enabling virtualization
> during KVM initialization allows userspace to avoid the additional latency
> when creating/destroying the first/last VM.  Now that KVM uses the cpuhp
> framework to do per-CPU enabling, the latency could be non-trivial as the
> cpuhup bringup/teardown is serialized across CPUs, e.g. the latency could
> be problematic for use case that need to spin up VMs quickly.

How about we defer this until there's a real complain that this isn't 
acceptable?  To me it doesn't sound "latency of creating the first VM" 
matters a lot in the real CSP deployments.

The concern of adding a new module param is once we add it, we need to 
maintain it even it is no longer needed in the future for backward 
compatibility.  Especially this param is in kvm.ko, and for all ARCHs.

E.g., I think _IF_ the core cpuhp code is enhanced to call those 
callbacks in parallel in cpuhp_setup_state(), then this issue could be 
mitigated to an unnoticeable level.

Or we just still do:

	cpus_read_lock();
	on_each_cpu(hardware_enable_nolock, ...);
	cpuhp_setup_state_nocalls_cpuslocked(...);
	cpus_read_unlock();

I think the main benefit of series is to put all virtualization enabling 
related things into one single function.  Whether using 
cpuhp_setup_state() or using on_each_cpu() shouldn't be the main point.


