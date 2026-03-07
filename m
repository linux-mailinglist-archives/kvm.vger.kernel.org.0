Return-Path: <kvm+bounces-73205-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cGVQLziAq2mwdgEAu9opvQ
	(envelope-from <kvm+bounces-73205-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:32:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 33DE62295F9
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:32:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A93253029633
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E9F2EC54A;
	Sat,  7 Mar 2026 01:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aeZLYrWl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADC02F0C79;
	Sat,  7 Mar 2026 01:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772847151; cv=fail; b=n3Su/7baMxnup0CmPOHjB2bfqO0YuNHHUOduLZNIHGXewYFX7hzVbBb4UdfmEzvDHrmvjJs2SEn2qhWlrKJ6Re0ygKY19oyNs6grqg27ODf2EaSI3A28HdkaqgxSZnP249jrW7SAxrs/nTbuDQMttw2CV6jvms2To7HTjMy5Rn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772847151; c=relaxed/simple;
	bh=fQuda5q2mzy3iBGDS/gkOhPru5836YedGfKaCI5vHvM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L2gwh9oriOmYJBhn1HhH6lPzs7MB270jYdYjBg0QvJD9u6i/nTYukBsVwyfvT5Gg76luOUYThpDVMeIeGCRTWMFqKYisWxFMfmMLMvzXzy84QHihu9UB6VEv200nLuqpA19a4Qm/96mBo1u6jdo/ee1z9CtK08g0CTPTX2LjQs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aeZLYrWl; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772847150; x=1804383150;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fQuda5q2mzy3iBGDS/gkOhPru5836YedGfKaCI5vHvM=;
  b=aeZLYrWlcG6oEQyE4fJQBnQyjSWtAIYxb3qSzuGNCCBZSmGHFK2w/zLr
   C66ecWTc3yDZqaTWzZZX5bP17HkMyu/+n/bUK9Cfp/PXeM0kgU5ZwVbaa
   oCBZC6UmvxJON501XPT+OKhu77BEt8Ft8rm4Faga/K8PU/SRRQH/2k+yA
   iEVMy2lUSI4szAf5+zUQyhkF32YazH2j/rOCEwPQXSZlrhyFpBVLzkX1M
   wh7SX3zUy9Fd0gpfDq5okGr5/1uxP24THledb9ttgwRyGDB5qKqClx/QR
   lk0NMk7h8n9BeND7KWlmM7zKnX7ZYkWb6SD0OqTz0TKbYbedgoATbodmL
   w==;
X-CSE-ConnectionGUID: WC/MwQbgSiO+QyTJWKYU1g==
X-CSE-MsgGUID: DbgY4vWFRoqN833gDAvR6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="74035976"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="74035976"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:32:30 -0800
X-CSE-ConnectionGUID: 1rFyKUyBTReaV793JsZOGg==
X-CSE-MsgGUID: 7besZCKSTxSdPaXHplOaZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="245371092"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:32:30 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 17:32:29 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 17:32:29 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.41) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 17:32:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=guNqtZt51MTmKJzbIRisgj88APWDxp0AnHz+c15xHKT5zq3vmpyE54WCKVG1zhOdqYP2JWv1Kwbm4VwIvcXU2w0Poh9ut0IZjGP9QYLS28F6IDBm5Si6Lwvxh5lLfrMTktfhTgsds3Amjeqy4DQ0G9jwkNenE1Ng8D4OsWRwxePMS7siSY78VFgG/SGqeYTZrV02TqA8APmaLSGBf1n/7rK2YMEUqXNNllb2+zK6UPabPoxiwQs2amp07CJY+eW0UHC2jyEkCLeQV3m9F1QduD8xi5RW73wsM18tGr4gt6oweIB43UW3no+2LltK1ghGJ9kBgLDFvJpoJ0IMfElzOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o15oLXY5U+1dCxSVfgZekPW3+1NZw4hn30vTcmOpq3I=;
 b=nEQvr1lVFNwabVeOC5naULFBZlbjj803KToiYEdtNxz6pbQKNOpi65MeL7ezDY5VEmBGsQyl5EInGL6sj5ZAxI5qLW7fIWW0NAmWUap+nwGfZ9Twtpwot/TQNgB8Uo1ZmYs7W3iMrISW8DW/YbuP517an+tu9fZWPLWg4/A1zWDPf2jIrKQV296gGj777fhpRec327LhF5LklX/qsN6CL3PrVoSyrVlLRrWZoE3XPZac8fMOM+ByBJmeM+KI/DR4HxmctiGKTGRkW6eYymhz5OaVfoT/Xq5pLJpYDeWurw2f1czQSosa4vhl8MzXjXug7ozOkUHv1v5JON/LhjOU6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS7PR11MB6040.namprd11.prod.outlook.com (2603:10b6:8:77::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.5; Sat, 7 Mar 2026 01:32:27 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84%3]) with mapi id 15.20.9700.003; Sat, 7 Mar 2026
 01:32:27 +0000
Message-ID: <476210a8-b1fa-4b97-a42b-78a5ddba851d@intel.com>
Date: Fri, 6 Mar 2026 17:32:26 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/16] KVM: x86: Refactor GPR accessors to
 differentiate register access types
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <chao.gao@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
 <20260112235408.168200-3-chang.seok.bae@intel.com>
 <aajhJBRS4FPL7nwj@google.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <aajhJBRS4FPL7nwj@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0111.namprd05.prod.outlook.com
 (2603:10b6:a03:334::26) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS7PR11MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: a2fbfb1a-bfdd-4fa7-78ab-08de7be9640b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: +GPSHv+BKDNzCYTzHJgGOa4nEudTX0niQHefUPKHqC5WvTaa/mUWIGh/yvORJFkmqMjh1vmg6ar4Lhyi2LX1p6kQ1OIkfkYZRx8NPNxraOzFMk+NKwlQVBkWBeggmil0RW7vx24oMrshJs/6vbGpjUjZcYuqiqoPgHebVPdYUzsL9rw0JWj+aonifCBd2X3WQB286cY4uV4bdEyb+2JAgRWU5ubxTEl8nizHE11G+UbWyDpWnOTeNJgtG6wK3Gjbpw2yEkbBsuo6yfAu+UkM7lttWX9+SC1TEOR94JBoOqmRfy5/Yr0UAzJ4gxo4noDChCz5ZJlFa65j6dxHlUHmnk2sZox0PtdxrUKy6uMl1WwAqkxOJ8G/xMQGKtV77bbdriDR8/GErWctNO290YVSbkd2oQtts8/PH7Wvbh1ucIr3LxhBjbT7JafdTlpPoZ94NSDnM5xrxRCJp50gocxQ32+qi7wZ/UtJq2vxtEnhHHF86rdJwt13LsRT6az7O4m2cHfDraaH5AiL5r2FsYWPUAHygOC9HgDAoVL+WsvK4r83mByUWUZImVym570bTbpTCmfS7O+gCS9neu846Jt0J2f4ArsulYxOQ9GLyPN6w6dX7gxu+Y/IcbDoL9pdmCPCb0GSPrH62pOagI1Ld0zz5Zrz9OKjBc07BQsLaub0tACFbFneLqhrrb7GThnYIphT3RqRu7Jdoh5gWofCLejM++JMkD4Uuokl8srj/BZTocs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjY1VjAyRHZuR2ROTEJWUE4vaDlZMVFUeGhXakVRM1ZFTDhhQkFPb1ZyV0x4?=
 =?utf-8?B?WlU0MjBFanRRUzdtT3NoMHlHWXJHT295bytXNFF1NVFFSDltLytwN0svb01j?=
 =?utf-8?B?UWZMM1RZaHp4WW5YVkdaeURCSTdFZ1N1LzlPMEc3ZS9Jb0J3NC9Wb3JBVUxV?=
 =?utf-8?B?M2hlTG54dnNYNVRBNEVjT1JWZnZ3bDdSeFY2WDVTUnlLWHFtSkt2SmNFMTI5?=
 =?utf-8?B?QUlaaHVtaERReVVCRStuT3l6eFcvY0hKMFM5elhXelVwM0p3QkxqSVBVdUgr?=
 =?utf-8?B?TXdJczlkUEZaY0ZOOGlxUWY2NFVwUnlWL29mZWFvVGp6MVJSbkd1RzI3a251?=
 =?utf-8?B?S3VVMDNPaExxcy8vZWhSNGliYnNiajkwTDAxbjc3MzZJbkFKOHNlbnNpU2dH?=
 =?utf-8?B?Z3JDc1lDcTEzcEgwdGxrcmN1Rkc3a2oyRW9HTUpOZGxib1ExUHhSb2haOHNx?=
 =?utf-8?B?ZzY1QnFjNUVCZVJGQ0RJOG9pTlhmRVl2WDU5Y0ovaWJEN1YyTXZENGlqK3ZH?=
 =?utf-8?B?U3doOUhiT1Y0UE5XNnd1ajRwb0I2SXd3VTZKRUdybkZZNzFSVmdNUEp0c1RC?=
 =?utf-8?B?NDFvbk9lY1JCTlk2bFlIN2lNSTdLSVFYRnRJN3RJUGR3ZVpEb2JPUnA3MTFB?=
 =?utf-8?B?bjdhak03WkQrUS9ocFRRbDVBU1BnVHlqcG9FMjFuUlhybWpuUjBpbTdCdGxJ?=
 =?utf-8?B?aVcrWGdoVlhwM2xzS1BIek9mRFZBZ28rdVMxSDNReHdsTmpSdkZxT3ZEQlJS?=
 =?utf-8?B?RHV1VUlZaE5QaWNmWUlySkdWWVduM0dSQUZSbzlxQ00rZXVZbkV0UGpCMTRP?=
 =?utf-8?B?N3BEUDN1eEk2azF0TDhxMlpoZ0VUK2FCWEtIaG1aa1dQc3Y5Yzk5UmZYRjB0?=
 =?utf-8?B?Sm1QNkg4R25nZ3JrcWdMdjBuM0VhZGhIckxQWmxtRDBGdHVXVHFLQnc2dVgz?=
 =?utf-8?B?UGYwUmRycTRyejJnc0x0Sk5ZRUZjcXBTdTZHcHUwSEhiUE52V2NjdUdDV2x6?=
 =?utf-8?B?bGFneEcxZ3c2RUp2L2l4ZWNGVlhzaWxrakJBTTRzNVQ5ajZRdFh6MEZqR25M?=
 =?utf-8?B?WjUzNm9qRDZYMHhsZTcxNEsxNUd5UFhqWkhXdFJIZGpoS0F0WTIwNlE4eTZl?=
 =?utf-8?B?SVRPejdMQUQzT1gwSUFUQlM5Wk1uZGsvYk1jMXJEbzJNZWNCRmhJZGNwRXZI?=
 =?utf-8?B?VVlZQVUrcEtrQkJPU1NrQk03R0kraldIclJjMUFYdGRnWGwyLy85cVduRWJO?=
 =?utf-8?B?SUMxbGtRQ1N0eUN4Q0xSZDNLU0h2MW5Qa1dqWU5pdEdWTEQ0SUFFRm1LSjlx?=
 =?utf-8?B?U1NKWEJsK0FGL3c2VTJZMnk0NHpBWEN2cFcySzNCMXp5aWRMeWRxZ2NicUxZ?=
 =?utf-8?B?cUZDUHN5OXNoWld2NlVxSTJicHpOQ0NKZTVPV08zTmwycTdnYk9uQUduWkl1?=
 =?utf-8?B?UHo3a0ttbktzd0tLN3BtRHEvL0N0RzRKNlpOeWY5d3NhakFLM2tLQm45TTBq?=
 =?utf-8?B?SEFPYzhQTVlGL1NpamVBUmN5QnZndUNZZUJqWXptTEYvdHIrQlhaYVhxMWR3?=
 =?utf-8?B?SVVOR2dqeE1uK0JidWMwLzlaSlRvSTFQaFVrZ3hwT01WRktXSEJKZWdpVmpI?=
 =?utf-8?B?bldscUg0VjYyTG5QdEs5YnhuNExXYkl6REdYNHRuTVRDNnNxRVJSZDFQUEZl?=
 =?utf-8?B?NGszQjQxYVpOTUlxQ0dHRXpWQnF3cjFYVVFOTTJTMkZnanQ4QUQvUnhJa1oz?=
 =?utf-8?B?SzkyTHQrTVNjVk0zY0ZQYWlNNDZ3azVOWmdaNU1sL3JQcm1DbzdMcm9DbExs?=
 =?utf-8?B?b2MrVHZMcjFiK05MZW5yWi83Q3Z5UlhHZGtrMWJvckpGY29KcW5XTzNZc1dZ?=
 =?utf-8?B?NGlXODN5MXVKelhFYVZEbmo1OHFveEFCUHJmTlQ4dng5U2Z0b0k5YzBSdEpr?=
 =?utf-8?B?dUFVMGhEcVl3VXVGWjJYY0tvQVdXWlRrL2hLbEZEeXJGMnFrYW1VczdHL043?=
 =?utf-8?B?ZUhqSW43dVYyaEFSelNuSUtLVnJ0V2dxUkdlVHExbXdYTzVjbklpWGdDVVFB?=
 =?utf-8?B?RXpGQzl2bk5MYXNoditYNWh2UUJSTWsrNjlPd3kxZUJzU3dMY1BWWTRvWEYy?=
 =?utf-8?B?N2xhemphWGVZanFiU1dOMUVKUmZ5VTVENDFKNHdHVkpMa2NtNXNDemNFV0Y1?=
 =?utf-8?B?UDdBa0lKZkNvenBsU3E0SjhoYXRZTTdIQitvblJ2dnBvOU9VRU43NndCdHNw?=
 =?utf-8?B?YVcxbE5Yam0vSTduci9VdDJFL3Uyb1RxNVZhR0NyTHhNWGI4c3NhRlZtRVRR?=
 =?utf-8?B?WThwc0tmQjB5OVhKcndzNDdMcXNuaWNpWFl4Sit0eUJpcEVmWVkwdz09?=
X-Exchange-RoutingPolicyChecked: TwuOYVJnTIoa/1WdG6a9pIL2lR6JhqHKPMcr/+iWM5kn4G6ifuIhVrK43VNOefEJYJuWP6qXeW3qt/TYCNzBGoD2WbNc09QQWWlWe27T2Fne4Wk8zTQKUEezWaxNOmmQCjHWzQYV9wmtPNqQS1Stycyke115VgEkEqp3NQTAYPCvKS4zndOk2/Lon5ozWFzz+Cw/0m5auLfzTcmOGqqYOOdLmbTVlBYW2E6p23/lfBUjFOIgGnF5/pU1mS3QXtosgtxjm0nfiZ8hTejFmLkRMJ3K2TCKmlYvKoXrikaarjouBK8HY8CbmiS4ORpLpm0ZvGNhLS86WJA3Ow4ViMxPnw==
X-MS-Exchange-CrossTenant-Network-Message-Id: a2fbfb1a-bfdd-4fa7-78ab-08de7be9640b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 01:32:27.0819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/RM0piiSgPdQ5yWLtFx0R59c+jSFSKLw90FMud80tQpoyJ0ILzyhuP3+OnZ3jazua5K+aBC4ztMTFqQigKn7eA7SiT62Pt6iM9raDomPWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6040
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 33DE62295F9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73205-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[chang.seok.bae@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.972];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

On 3/4/2026 5:49 PM, Sean Christopherson wrote:
> On Mon, Jan 12, 2026, Chang S. Bae wrote:
>> Refactor the GPR accessors to introduce internal helpers to distinguish
>> between legacy and extended GPRs. Add CONFIG_KVM_APX to selectively
>> enable EGPR support.
> 
> Why?  If we really want to make this code efficient, use static calls to wire
> things up if and only if APX is fully supported.

I think the idea was just build out APX-specific code behind the option. 
Ah...sorry, the last sentence was wrong to say.

Yes, I agree on static calls for switching.

> Has anyone done analysis to determine if KVM's currently inlining of
> kvm_register_read() and kvm_register_write() is actually a net positive?  I.e.
> can we just cut over to non-inline functions with static calls?

A quick measurment between inline vs non-inline: When invoked 
repeatedly, the non-inline takes about 5-7% cycles. But, when VM exits 
are involved, the diff goes into a noise level -- e.g. invoking 
accessors 1000 times accounts for about 1% on the exit/entry route.

