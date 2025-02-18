Return-Path: <kvm+bounces-38416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBF49A39746
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:41:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D300118901A6
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 729E522FF22;
	Tue, 18 Feb 2025 09:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gLYGM78T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AED1FF7C0
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739871679; cv=fail; b=Ky4ylxGcRmjjnpnIEHEjWkaLasp3tE1iDYGnbanMzED4BdMw6cwX38wsCBnOvLx4ioIA8r2YxME9eOVKiwrXQ7CWwYDrnaBghcJTd6EQLsaJ3XQ8J7oEzsnAHijksLOF7oOIaJWWxoruyED0N2sqyVeQFddbexpFVjmE0eKDPHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739871679; c=relaxed/simple;
	bh=DB7fZ6SYurr5a5BM5EY1qDCS6SzJbT7pvdtA+X0O5Gc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y2b2UG25fnvk/QbWXhJs8oiKTTvDZI692uGQ1/a2MR1naQyKa4M9i0nQ0qmwNAnjaPpi+Im+sHYlqovlFvugYza3OKug6aAu9R+DunGCpmB+DrGK7wdGjip+da2IjHmesJ4WAVjLO9I78IPTQIkSv0NE/wT2VfhiK0rStl64e3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gLYGM78T; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739871677; x=1771407677;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DB7fZ6SYurr5a5BM5EY1qDCS6SzJbT7pvdtA+X0O5Gc=;
  b=gLYGM78TqwR+9GryJSAgM8/4uE1Z7fQdcBBdXxKbKRG5pTOP4g80ZuZX
   8L94qHXaWsnDVKbp6F7G3JZw/dqVCjb+VUSENsIaU+CuDnLP/oYXqDhqc
   K6xfmyQswOr4SGqXk4SpdsBMb4DZHd2Hl/mvppxbK9M60RiU41yRVZd0k
   ZkX4qr9xwME6uyAdo6T34IMNcIxjAVd/u73Ddkvxqaa43HunKsJ1zAucF
   DmOBDcMLzClPK8cbYrZVv+o2V/du3nTqaaNkzxNCxRrreCGJkc/BRiCNm
   mQ/+J3EJOEjQ+pjBRJClEhiYg0JWt4Y6Yw372vhT/TFApXoBkqoJSrpMi
   g==;
X-CSE-ConnectionGUID: z8yMek+RRyykVHfbImw/pA==
X-CSE-MsgGUID: 38LFmyiGRM6zwt9gCmg2Sg==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="40480088"
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="40480088"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:41:17 -0800
X-CSE-ConnectionGUID: GiXUEIJJTWm+rYL/BlNoVw==
X-CSE-MsgGUID: sAKcupdJSme7NSRHNok3XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="119337704"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Feb 2025 01:41:16 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 18 Feb 2025 01:41:16 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 18 Feb 2025 01:41:16 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Feb 2025 01:41:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cSzikfzcF7b2J+X9mVspbuHlF5j2grHQv9GscWGSXrTGxFRZAKteB/TR+WJtQO3mZMD1jQs2qEXbXO4qYibRuZKUspaE3KiCDvnu+fUp/zmPfh68Zvu8l4fbY52ZIG8t3xQJbIxFXezJWjsbMgihlBDEIbroBn15dl8q3+OTRsJ0+M+SHf4HBghS1m2DbGUDa1+mwc7xPtFX/Zoe2+LHCTtTY5ISJbZehRAdIIBHm7squbpw6nh/v43CgP82MINMO7rOSQ588Ra7SZ/hqndrv+ERQ9jyoLZeJBvoTciWWaGTXlTVcxo51HW0JM81NhIqhwrlyhcLB4uSGB1elaDZSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvfUh6CZo3mlrwRfvlJ5hLNiQ+qnjCGURLSbvLbyPZA=;
 b=Kgo9piq72tXEMpsY05nAKR2rwHJHbSVXgeVxKm/3hliwrLIHHkwO+p3IeW61MncmhCk9Aod5BB735wlvz01vYW4nv28hDZAr17LLcD/iQcF0Lbd2p3xtblgl+/OhJmY9UIeXPOPwf+mS+JXV+aC6TZymu8bFZWb/E/cxXUxC2sKDmZDG89u0w6OW9VSzdy6E5fdwtoZu67r7pQLU5Sh5cCn/a1+xGQ7j/Rmgxh8jLsckOdT7yCoOFmMflbPUQE2B3YvZCM+YOjWLi/yt+fxu4dVUw4q49OB70nvglmS/HOTx09S0DD/hqjgbbKDb366ZxAafYX6aOmC3H1SG155b3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SA1PR11MB6661.namprd11.prod.outlook.com (2603:10b6:806:255::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 09:41:13 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 09:41:13 +0000
Message-ID: <db018f12-2075-41ca-a3d2-d263a7785edf@intel.com>
Date: Tue, 18 Feb 2025 17:41:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] memory: Change
 memory_region_set_ram_discard_manager() to return the result
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
 <20250217081833.21568-3-chenyi.qiang@intel.com>
 <10029ca9-a239-4d3f-9999-e1059bc17d85@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <10029ca9-a239-4d3f-9999-e1059bc17d85@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0048.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::17)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SA1PR11MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: b0dc1ca7-2006-4443-bf67-08dd500061d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZnAzWCswNUlGNWNYUGd2QjlZTEwrMnpUaUN2SjVWczdudDRMeU9rc1NocTkw?=
 =?utf-8?B?VW0zUkU3c3JtaFBhNTA0Z1JjemExa3NkZkpZZWo0ODVKaXRIRHRvOGVVakdl?=
 =?utf-8?B?NzR6Z1Q4ck9RcngvZ2tkNXZWWG8yZkV6Z3c5Z2RYbFFxaEpDeGZQeERBNGNu?=
 =?utf-8?B?NFlnU09GeG5aQVZCUTFVVmNoQmg4Ny9Bc25jTnVuSm95YVNOMjRYaWFkUHg1?=
 =?utf-8?B?VXdqMzhQMWJUZmFTNCtmemsrT1ZZRGRtUHpoc0tSTGl1VnNmd2pZN29Od0RK?=
 =?utf-8?B?NEVFVXMrSmZpWnpJbUsxTlNIUmVRRCtObWZ6RUlYSUxId1hoRzFzY0VWSnVO?=
 =?utf-8?B?S0dhVjBYbkhLci8yOWNKQnNiK05VaEx5NmQreXdISXVMWlNUQVhvVERSOXBN?=
 =?utf-8?B?Q1dYMEc0TFFVUWVabzEvK1pNRlRpSzR6SlE2OXpxb2pMcXJJQVVvSlFaWDdC?=
 =?utf-8?B?REZoVXJvRFQ5cDdzTWRzYW9Bd0ZnWFJydStybFNGcjNHV2U2ekxaQ3I2N0VD?=
 =?utf-8?B?VUdiUWRoSzJyMUNENE5PNnQxSU1JQ20wWTJ0eXQyaFlmTzRnejJEVGFWN21p?=
 =?utf-8?B?ZklOVExyMUpQUExnaC9tbUtLNno2cUV0NFZXcVB1K09INXZ6UnRBZ3hnTWsw?=
 =?utf-8?B?NW04MHBlRUEzS1Q1aUdLbTNjNFpPVER1a1dOSmF3eWR1WXlRT000MmJ1dGd6?=
 =?utf-8?B?NlBoaFFJaWFSNXlpMXFEb0syVnpiM0JQS2ZjSzIwaCswSS9BUk9FWkpDZEZh?=
 =?utf-8?B?LzZBZFVkbkJ3d1hxVXpQNHJGb0RkQlpUSCs1VGhCdjRjdExJOXpQNE1RSCtv?=
 =?utf-8?B?MEFkb1g0NG8ranBkNVREcHBySkZGSEdvNUZaWDB2YUxCcExsRHNPbGFJTE9q?=
 =?utf-8?B?VERSV29jSmZjdUtGMFJza1czZVp3NzYvckVrZDArMHVaRG5ETTEweG5uSnZ3?=
 =?utf-8?B?YXJzZW1ySzV4Zks4Q2J6UUtjbDZxeWNjNjNQVC9pL0F3d3RyZEpxMDhNQWVn?=
 =?utf-8?B?NkNodVliY1dlRUoxbko0VmRXd21pckpNQUhpdythSlNNRXduT3hLQ0dLd3pB?=
 =?utf-8?B?RnZvNldTVDJPcHVKNG5XQ0x4QWJJOFowaUdMSVZHaUFnaHhVemNQRklzaUtE?=
 =?utf-8?B?VTRjOXllTFA2dktkWFc1Q0RWSVg0NTFoVks2M3dGbllJWVpUVkkxRE85eW1q?=
 =?utf-8?B?SnFySGVkcy9JN3lOU1k1ZGNtTzZFSUpyRUVIVFVac1g3amRvUkhKTlF4QlFY?=
 =?utf-8?B?MHgxZjNLTHJtNTB6YU14NTFPMVphb3pmVHFsWDdPOGVNRnB6Y2Z3MytGcnF0?=
 =?utf-8?B?dWFjMDJYUGdxVTIyWVMvdlFKSlNHNVhLUjUrN3ovMVp4c0F6Q3pSMnhJR3VE?=
 =?utf-8?B?eU55OFZXZGYrby9ZN1VFS0thYjZJekwwSWtlRzN0TVAzQlRqSHJyOFdiMXk0?=
 =?utf-8?B?YnhXQWkyM2FvNXZjZlFaUGpOTmdGSzV6RGJDL3FKZ0Qra2dkNGxNQmtOOVgw?=
 =?utf-8?B?NDB5aVUzMWpzYmVCNkkvSUpydWpVNGVGNmQvRi90VXVvNzAzQjdHSzVhdlFp?=
 =?utf-8?B?TDhmdE1QYmR2VHZRK3dkY1puaDJpUnloSnAwV2tsck40ZWN1UjdZQ3pDVVV5?=
 =?utf-8?B?VU1JUDFjYWI1M0Jzbm5wR05WVlZraS9NTjBhM1JsVkJjZ0trNjQ0MFlaeXBS?=
 =?utf-8?B?QURaRnN2NitzTHR1SzhDZWxlOXVXLzBQVktWekFNQzUrUWhGcXlzY0pMUDd5?=
 =?utf-8?B?RVl2WHB0QnFSSUx2ellHWVFoaFltTWR5QkhLR1plVkFnNDdFdW5HNlJYZU5r?=
 =?utf-8?B?NmhiQlFRM1pHbTZuUFhDODlyME1JSE16eUlKbUVRWnJibjdGNFBldkl0L2xn?=
 =?utf-8?Q?x8UgMmewwYsl0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTNRVmh1OElXaTg0TXdBRWV5UFBxdmZqeTBaMk9uS2hjaUk3RDVvaXMrZ212?=
 =?utf-8?B?L3RjVnUrbTlvcVcwSkN0czFCSkVUcDRIVDhBK2p2amptYzNqckVmYzZzbnQy?=
 =?utf-8?B?dmg3aXBoVmJYZzZ4eEdVYVZYQzhUQjJtWkRwT0x6SmVwU0FXYVZsSXl0c3Ni?=
 =?utf-8?B?V1hFNXYrZHRKbG9TTEUycVJzaXBtS3BLNC9UZlBlM2N6VlhaQlF1cFVJcEZ2?=
 =?utf-8?B?cnVqc3U5VmphQjRub3dreHZIUDgwNTFNMHZ5aDRkY2NKUlA1cjBYci90Slhu?=
 =?utf-8?B?QnB4cEIxdUduM25mZStDWHdibVowMGQvS0JpOTltdG9DVjVGYkhOZ2IxUVkx?=
 =?utf-8?B?T1g4TEpYWjBGYUc0UTZERHpFQ08rQkI3SjE5a3dvelBSMC9TZXNnNGZOUEsy?=
 =?utf-8?B?enRESDJqMU40clBmREMwUlk2MUxLUXBqY3U1QmlYMVpSdFI1TE9jR1dYYTlQ?=
 =?utf-8?B?clVvWmEwVU83NUhuRGhFek1IemdLZU13N0xua05ubWhEenZnOXBTUjRyNm1N?=
 =?utf-8?B?NFRLdzNERFBrcC8rNTFFajFRRlArYW9NOG5qTnhxcmNYclg0M1Ruak5yc05G?=
 =?utf-8?B?eTk2SHFNUnBLRTRaOE9aLzZQK1g4cVRFWVc4eWRYUlB2Q2QxNXgyei8yZ0sy?=
 =?utf-8?B?UW1LNTVWb1MrcmtQMy9HRlBjdTQxcTNzcml0VDhlMHlaNmdFeml2SE45Rkt2?=
 =?utf-8?B?QjdMRGdKWVhBOEZVc3YxbzZDNDllTWN5NXZqQ1NGZXhHMEI1QS9MMGtUdWhw?=
 =?utf-8?B?bDJseWRmcjJacFlic0hlWVdrUVY3WUJRZVpoam9vQS9heXZOd1MvcGtxbVFU?=
 =?utf-8?B?b0I2TjJpQ3NjeTBSQVBEdFRKZEYxLzMvYkVvbUxlWHNOcEpaNXJId1phRDcr?=
 =?utf-8?B?SlFpb2tqUkpnN1owcy9ya1NsaG1IdzlnbWJrZHBsYWU5dmpiVENZR01PcEky?=
 =?utf-8?B?Z0M1QmI4RnZXTnl6bkNFV29wbGZhL0hneFRQdkgzZzJDdm83WkhEMzBRY24r?=
 =?utf-8?B?VnlESE1wU0c3ZUZST3V4RzAxK3hPdjhKV2txL3M1OE5IeDRSNFUvbGNEWlNQ?=
 =?utf-8?B?U3QxZVF0UWwyRGpURGZ6eHJWVWlhclFCZWtaVmFPZUFJckE3alEyUEI5L01v?=
 =?utf-8?B?aWZYL3MrNHJJWHMvNmxXWm1aUTMySk9YLzhTTUp5RVhkcDFSbTMrdmVpQWFV?=
 =?utf-8?B?c1EvVUozT2ZEdkYzdXZrdElTWExkamF3OG0wN083Q3JsV29LRDRpMG52clIx?=
 =?utf-8?B?MjFGMmhTclcwRjYzUXpzTzVHQWhZMkRiMlZ1Sm9jU0xUUVcya3BoK3ViZ2sv?=
 =?utf-8?B?S2l6QnoxVDRrQ3NCTktOb3lEajUrM0FLM1JLME1BUmlrVWFUZ1Z2NXhBNG5o?=
 =?utf-8?B?L3VRK0wvM2x4TnlsMTVSWllnTHJqSHgwSFlST2syZkNHUUdxZVdySFJIdFJM?=
 =?utf-8?B?ZkZEai9pUWtNRU00Y2IvSjlsYzhlQXBaQW5DYWIvYmJ0MU8xL0x6ZURrSEdn?=
 =?utf-8?B?TVlXMzR3R2VPWndVN25mbXlyVmRsOTBjMG5HbjBpRUc3aENwTS9UN1JJbGVz?=
 =?utf-8?B?d1Q2NG0xRDdmdVZIczYvRjA5Q0Z3NzZjU1YrTkkzdWw0SVEvR0ZYU3NicHNp?=
 =?utf-8?B?bTI3Mm9SYkFHZ2N0eUlGVDRjRU5Qc2tLMVJUcWlVdVJOdnpSTHY3WlJsNVlR?=
 =?utf-8?B?ZTlVMmxLVTJZZ0JSdWI4NlJIcThBMVhaaGdUdGlacFFwR2Nab09ZYVhrZ243?=
 =?utf-8?B?NzNYdUZLYk9ENVlFRjhnN1VKZGJrN2FDdGdPSFloNVorOTRoS3BkTnBHVEgw?=
 =?utf-8?B?YU9zZ3lsZktkMk45M3ZGQm0yQTNYc1ptVi9KUXRpQW50Rm1FNzgrZi81dXF4?=
 =?utf-8?B?cmJmM0J4YzdWSXZmamFNdDBic1lka3ZDakNJU3RaOE9xaW9CRWlOQ0xYN1hV?=
 =?utf-8?B?MVMxNUZmUUl1N2VJN29xTVc2TXg2aTZ4eVM2U2xXYzA5dHNzRzBadzdMSUNo?=
 =?utf-8?B?UW9DUlpnditLQ1g4VzhONXkwd1NZM3E4cm1rSHZYdU5NcXJ4TktuQnZOelc3?=
 =?utf-8?B?RFN6QkhNRXRMZUdjWW9VVXVZVkpqWCtEQ1VFWjZ3YkhseHUzQkU0M25VelJy?=
 =?utf-8?B?VGNML1BvMm5lU29EeUg5LzZFdE5wY0trUVhXdG1PQk1pZ1Q4TmxJNDd4OWdI?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0dc1ca7-2006-4443-bf67-08dd500061d8
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 09:41:13.1975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hosE8xdoyFfPSe67w3CmtvkMxs9w+xqwtxir+D7UeNxqqcydwZzTLmru0ACnXKlEiXOM4/dG+hn/mVgl0ZtZwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6661
X-OriginatorOrg: intel.com



On 2/18/2025 5:19 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 17/2/25 19:18, Chenyi Qiang wrote:
>> Modify memory_region_set_ram_discard_manager() to return false if a
>> RamDiscardManager is already set in the MemoryRegion. The caller must
>> handle this failure, such as having virtio-mem undo its actions and fail
>> the realize() process. Opportunistically move the call earlier to avoid
>> complex error handling.
>>
>> This change is beneficial when introducing a new RamDiscardManager
>> instance besides virtio-mem. After
>> ram_block_coordinated_discard_require(true) unlocks all
>> RamDiscardManager instances, only one instance is allowed to be set for
>> a MemoryRegion at present.
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v2:
>>      - newly added.
>> ---
>>   hw/virtio/virtio-mem.c | 30 +++++++++++++++++-------------
>>   include/exec/memory.h  |  6 +++---
>>   system/memory.c        | 11 ++++++++---
>>   3 files changed, 28 insertions(+), 19 deletions(-)
>>
>> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
>> index 21f16e4912..ef818a2cdf 100644
>> --- a/hw/virtio/virtio-mem.c
>> +++ b/hw/virtio/virtio-mem.c
>> @@ -1074,6 +1074,18 @@ static void
>> virtio_mem_device_realize(DeviceState *dev, Error **errp)
>>                           vmem->block_size;
>>       vmem->bitmap = bitmap_new(vmem->bitmap_size);
>>   +    /*
>> +     * Set ourselves as RamDiscardManager before the plug handler
>> maps the
>> +     * memory region and exposes it via an address space.
>> +     */
>> +    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
>> +                                             
>> RAM_DISCARD_MANAGER(vmem))) {
>> +        error_setg(errp, "Failed to set RamDiscardManager");
>> +        g_free(vmem->bitmap);
>> +        ram_block_coordinated_discard_require(false);
>> +        return;
>> +    }
> 
> Looks like this can move before vmem->bitmap is allocated (or even
> before ram_block_coordinated_discard_require(true)?). Then you can drop
> g_free() and avoid having a stale pointer in vmem->bitmap (not that it
> matters here though).

I'm not sure if moving up the memory_region_set_ram_discard_manager()
will have bring any side effect (seems no requirement for the operation
order here). But Maybe it's better to put after
ram_block_coordinated_discard_require(true) as
ram_block_coordinated_discard_require(true) unlocks RDM users.

> 
>> +
>>       virtio_init(vdev, VIRTIO_ID_MEM, sizeof(struct virtio_mem_config));
>>       vmem->vq = virtio_add_queue(vdev, 128, virtio_mem_handle_request);
>>   vmem->bitmap
>> @@ -1124,13 +1136,6 @@ static void
>> virtio_mem_device_realize(DeviceState *dev, Error **errp)
>>       vmem->system_reset = VIRTIO_MEM_SYSTEM_RESET(obj);
>>       vmem->system_reset->vmem = vmem;
>>       qemu_register_resettable(obj);
>> -
>> -    /*
>> -     * Set ourselves as RamDiscardManager before the plug handler
>> maps the
>> -     * memory region and exposes it via an address space.
>> -     */
>> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr,
>> -                                          RAM_DISCARD_MANAGER(vmem));
>>   }
>>     static void virtio_mem_device_unrealize(DeviceState *dev)
>> @@ -1138,12 +1143,6 @@ static void
>> virtio_mem_device_unrealize(DeviceState *dev)
>>       VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>>       VirtIOMEM *vmem = VIRTIO_MEM(dev);
>>   -    /*
>> -     * The unplug handler unmapped the memory region, it cannot be
>> -     * found via an address space anymore. Unset ourselves.
>> -     */
>> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>> -
>>       qemu_unregister_resettable(OBJECT(vmem->system_reset));
>>       object_unref(OBJECT(vmem->system_reset));
>>   @@ -1155,6 +1154,11 @@ static void
>> virtio_mem_device_unrealize(DeviceState *dev)
>>       host_memory_backend_set_mapped(vmem->memdev, false);
>>       virtio_del_queue(vdev, 0);
>>       virtio_cleanup(vdev);
>> +    /*
>> +     * The unplug handler unmapped the memory region, it cannot be
>> +     * found via an address space anymore. Unset ourselves.
>> +     */
>> +    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>>       g_free(vmem->bitmap);
>>       ram_block_coordinated_discard_require(false);
>>   }
>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index 3bebc43d59..390477b588 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -2487,13 +2487,13 @@ static inline bool
>> memory_region_has_ram_discard_manager(MemoryRegion *mr)
>>    *
>>    * This function must not be called for a mapped #MemoryRegion, a
>> #MemoryRegion
>>    * that does not cover RAM, or a #MemoryRegion that already has a
>> - * #RamDiscardManager assigned.
>> + * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
>>    *
>>    * @mr: the #MemoryRegion
>>    * @rdm: #RamDiscardManager to set
>>    */
>> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> -                                           RamDiscardManager *rdm);
>> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> +                                          RamDiscardManager *rdm);
>>     /**
>>    * memory_region_find: translate an address/size relative to a
>> diff --git a/system/memory.c b/system/memory.c
>> index b17b5538ff..297a3dbcd4 100644
>> --- a/system/memory.c
>> +++ b/system/memory.c
>> @@ -2115,12 +2115,17 @@ RamDiscardManager
>> *memory_region_get_ram_discard_manager(MemoryRegion *mr)
>>       return mr->rdm;
>>   }
>>   -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> -                                           RamDiscardManager *rdm)
>> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> +                                          RamDiscardManager *rdm)
>>   {
>>       g_assert(memory_region_is_ram(mr));
>> -    g_assert(!rdm || !mr->rdm);
>> +    if (mr->rdm && rdm != NULL) {
> 
> Drop "!= NULL".
> 
>> +        return -1;
> 
> -EBUSY?

[..]

> 
>> +    }
>> +
>> +    /* !rdm || !mr->rdm */
> 
> See, like here - no "!= NULL" :) (and the comment is useless). Thanks,

LGTM, will change it. Thanks!

> 
> 
>>       mr->rdm = rdm;
>> +    return 0;
>>   }
>>     uint64_t ram_discard_manager_get_min_granularity(const
>> RamDiscardManager *rdm,
> 


