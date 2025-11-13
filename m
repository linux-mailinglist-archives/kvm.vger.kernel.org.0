Return-Path: <kvm+bounces-63096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A8543C5A8DF
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:29:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 164B34E8AB8
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555FC328B49;
	Thu, 13 Nov 2025 23:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mN7roIIq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC71A3164C2;
	Thu, 13 Nov 2025 23:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076448; cv=fail; b=YlzH00U2SPvqiGeQl4Z2Bj9EdJqUQJ5tRi2KbpRHH8xi6edLRbYw0Vi/jceAijCqr4m2fpggq20WgjMiKM+Lg1Aov1wJb8Df8IHqdPZyuZmvdiY/udpFd2ekLlri/28rvhzXaPFmVhKSEaNJMBYr+ZRl6x6MBGIF85uZHqvGCjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076448; c=relaxed/simple;
	bh=tWlI4HcpTmnzVKaP0VsHjfpzk2daRvb1ADdBfYBG9bE=;
	h=Content-Type:Message-ID:Date:Subject:To:CC:References:From:
	 In-Reply-To:MIME-Version; b=S8QzsY5cbpKXxEJbCZ/9IziLgGeCxYOciO/4uFIEPYinUU1bx4rsSIvxy8wQZn6OAPuXA527g8aXlLiAfIFjAwjiGIy1N90jI1DYIw40EyArHmbM9K14gIuaJJTjO4Sjd9m7fqLOvEihDoSzrccI+wmTd5n7WmzNRqPC8bx0Mwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mN7roIIq; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763076447; x=1794612447;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:mime-version;
  bh=tWlI4HcpTmnzVKaP0VsHjfpzk2daRvb1ADdBfYBG9bE=;
  b=mN7roIIq/qX80kepJHV+Lf5lLUDBolBWRu6h0m8Bpj9m+np7IxB01bhs
   STE/q8sFa7VKVEgATDPXhqPQjurBICEwFfRtaBogK8hI3EZpojl3brKmf
   x44nnbr67W1vF3BaJfxI1VgSgwlLuopcClb96vVd3NncwrOmPvQPlnOSk
   Dx1qyYeCV7mtLZ/11prEPpJIHdJiZNkrikmHSuqw1okY1GXbWigBiU1Gz
   xisJo2GgeIIcRuxghkCxEDgF95C6crB0aIjQ08xoNTwWaE9xQAlyMYyTQ
   BMqoy8zg0hKOxCuo3k2EAi9nR5GBvf1MyclJHcj93VGL3E/CCuhyBN6Qb
   Q==;
X-CSE-ConnectionGUID: Ar5DG1/eTSumRezHnm65Hw==
X-CSE-MsgGUID: DJxdCqAYQ+iz6FL6mbThHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="82803166"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="diff'?scan'208";a="82803166"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:27:23 -0800
X-CSE-ConnectionGUID: oDpRUsi0SUyLvhSFfQ6nxA==
X-CSE-MsgGUID: po6+QD3RRCGf9TEMADiYoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="diff'?scan'208";a="190051590"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:27:23 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:27:22 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:27:22 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.38) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:27:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WjbzVuvRHlmf4lg7g+JBfi9QZb0QRmEE7ClF6OedCncfhyaXQVaHicF2WMOTVt752IDtyPkLBqy5Lwnd5+zsG0tNaT/htqd/EaAV2wdGZFyZJ4g2SwDIoJ31vGIz/FMfnTJIRVuJhBdA2uY76F1qWCNcerctQl0EdqtNEmKsD2pWkT9GE1lBbajGgEJgUM7g9gJsdGgFb9GXaufveJosVUxS0ppLZUdtblV+h7MoIRg68++BeWs/hZfpnKpLK8QzfO5Fqc4eelb1aPnrLVGXHxFPq31bSQTXYwdNh31Nk8Vf2uWYNaFPllRwh7YNmtLx/8+db6D+QWHjPNc7G7UJHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0sPpux+hzsg7pKxwjxFip9FyDtPyvS7ky4i/kezz8U4=;
 b=MZHchEPve4gltMwrsRso7vzm+cHP8A6g3EXXLY8MhKvjMaVdwZKSvTXCaf44vxDBpukW3HfEuTqY2a8+6K2GRTD5Mh2hhGimbDIMT/VPBNeg0wUqwuyBW23WdTxMcuha1DcdJbp12sMDsNAjq48mSQhe5bc6KsMZKlgPZSNpeCQkLozK79lV9lMFzVI6yzzt8BKx9UpKwybGu160p0etuoDkyd8KyDmfg6ST1GkvsVTnho8Kge7TtKN+qY6b/um28BeoMlXplcUVDFicZN0O9JkFLVUgf+8kzE9wWZXEBBaZxuYWGXoyIy2MkFKxDC8cP3P5i+I3A9xBipW6F9wxjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CO1PR11MB4962.namprd11.prod.outlook.com (2603:10b6:303:99::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Thu, 13 Nov 2025 23:27:20 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:27:20 +0000
Content-Type: multipart/mixed;
	boundary="------------DXJY2KjthW8WSKTeHfvThfa4"
Message-ID: <93377c7f-38ee-4458-8a6d-50a70c8cc5cb@intel.com>
Date: Thu, 13 Nov 2025 15:27:16 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 14/20] KVM: x86: Emulate REX2-prefixed 64-bit
 absolute jump
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-15-chang.seok.bae@intel.com>
 <eb61475f-e5be-4f39-ac62-908453895ad9@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <eb61475f-e5be-4f39-ac62-908453895ad9@redhat.com>
X-ClientProxiedBy: BYAPR05CA0092.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::33) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CO1PR11MB4962:EE_
X-MS-Office365-Filtering-Correlation-Id: fdbb9c96-2ee3-4b6b-5a2b-08de230c30ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|4053099003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eW5zRi9tUlhGUWU1UHJLVTdaTGpLeXV4VUVkMVMwNEx2OFIrVTJyZjBWL3NJ?=
 =?utf-8?B?cGZDbFcxL0d0SW5vOXN5SHNMQ1hzQ2tjOUsxd3FMZzhWUE1RbUllRXpBUjFr?=
 =?utf-8?B?N1cyRFVRekMrL3lPalp5NHRKOGFzODVwUmdUVnBEemdUT2NiNGlHTUdMWEQv?=
 =?utf-8?B?WUZBUm5YVG1XeGJiejRkYko0R09OYmtTODlpMTUweG5vdkFWdis3SVIzaUdm?=
 =?utf-8?B?WjkrY1hIQXgwRzFjbUU1MlU0NkJscWN0eXVrMHFUZHl0SzRCWngvQ3k5dnJ2?=
 =?utf-8?B?ZHQ0VlFraGVNanFDK3pMaGhucG1hY2RZVmZTVzdLVS8vNytRS1lhY3B3Z3I1?=
 =?utf-8?B?cDZTNkY4cEkrQ1FxdFhudlcyVU1wckxzS0gvL1hKbkhCcDBHeU1iMVA1TkZ5?=
 =?utf-8?B?RUpWSkhUK0N5MWVtcGd2Y0JCWUdZdGNPa1pKd3ZtZ3M5dkFTSXBhV2ZrQU9V?=
 =?utf-8?B?bFljTENlcmcwSmJtcWU5S1M5S1huamxpVUlMQVZhdVNNdjByMjk2NmdocUQy?=
 =?utf-8?B?czdNMzBmRllZYmVXc0F0VzFmNnBLd1IrdjU5NWsyTHRqb1BGVElZVjBhM29I?=
 =?utf-8?B?WWt3ekJDbklTbjUxVVpVNU1hSnNxVmxmckkwdmZ5YldRTTdPK2FmOGp6dTQ0?=
 =?utf-8?B?QTVVTi9FTUJyR0ZiaXFCMkVyNVhzZlV5eG92dHBNRUpjVGlkd3JWSWRTeTNX?=
 =?utf-8?B?R1VaQmwycmI4aC80QXArc2EybHo0K05MeW5yUVNlQVlOb1BFcHdDeGlKZkFI?=
 =?utf-8?B?K1g0LzMzeGVTK0RmaUtDKzd0UHpHbzJEVUNvbDU5aTlsNzBxUVViV2wvbVlB?=
 =?utf-8?B?NkpWaHhsMmRFWXJYNHJzTENGU2FjYVJvQ1l4RjZmR0swU1Q3ckd5UTdxTi9P?=
 =?utf-8?B?Qm8vUm9sQnRTQmtYV3FEKzZmRUVTRExqd3RPeG15T3RTQ3BIc0h5U3phNkZl?=
 =?utf-8?B?bnEwMnNWU3M4REI0MkdwL0pTZWNRczVXWmE5SmM0OEE0SVVuRUJTU3RIa2xI?=
 =?utf-8?B?Q0RuM0I4TEExNmhOdzZLS3RzaVRjQnB6U3JoZzgrVWgycWZScS83NFVGL0N3?=
 =?utf-8?B?NDgyd0ZQTVJ0WStTZDQ5UTA0ZlJlOG1UWkVJMjdDajNBQzdJdForRUZuZkUy?=
 =?utf-8?B?dTNPUU5oRFdrdXVXa1U3UDdKVjVxak9IUDJzdWFYbk95VVdwYnlPVHNBdGJa?=
 =?utf-8?B?UTRHVlJXdS9MZFlGR1hOSFdiNWtUSzZKTDZUWEc2NEZ3VjBsUmpTeVlqL1hx?=
 =?utf-8?B?TTY2U0hVNFV2WTVKcWtHMmdyazJvZlk4K2pmOTlRQk5HbEFSWUJDK096RXU5?=
 =?utf-8?B?eDJ1Uzcwa3YyZzRKMFdlMXp2bk53WTB3WVRWZzBWQXB6eGpETzNESkZ6T0NB?=
 =?utf-8?B?SWx1QWJqMWNqOGl3OWU2NEhNQ3pIT0hMRTBqdzNzSVVWbXAwWVJsZ1l6SmJV?=
 =?utf-8?B?cDF1WmJQOERTQmwrNVp4ajdSNUIvMHppUEVnVUk2TW1lZlhMVmFGT2NtYnJr?=
 =?utf-8?B?UXdQV1drQUk2UjdrelMrTGpXbVl5dXl2dnUvRHRBSGhHcjZLR1lLSjNxbXNl?=
 =?utf-8?B?ci9aME9oREZIeXZJNkJFeU9XbWIwZkFSWkNUc3pBeUw5YlJUWDA0VE9nK21k?=
 =?utf-8?B?UXljdE1VMFRsTGRYVXBTbTNUeUlna1hpMjJSSzQ1V3J0NEpCTGJBL2xPMTY1?=
 =?utf-8?B?VktmRmg5MzBqdmxuM05QTXFlUnl0YWxGcVZHUnRORVZCOVZIYWttWXAyY3dI?=
 =?utf-8?B?TzduckhIQitsdFBrTW5RaWllVTZWR21JZFlZbjF6a1NOQXV6QThLc04rYU5N?=
 =?utf-8?B?UnpCRkxUYXlSR2pvcERiTzJnSTE0b08xM053bWowbEF1Ym1IRU02OFQxNHpI?=
 =?utf-8?B?RXRpTnJ1Y1AvNWthRlZmeWZHZzFCc3RvdmpkMWFEOUxzVVhhNkR1K2VCWVc5?=
 =?utf-8?Q?dPgBc92RHSbsmhCanIpX4/gA72bYxWQO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3pPL2ZDNlpHQkwrQW9XcGVzWHpLQUtLVHVZMFVBRDV5dE4wZE5XanQwcW9x?=
 =?utf-8?B?amdYOXBibnYwSEJhMW1ONE9wcy9yd3ZRWVllaFBSeWZtWHhkbnlGeFhqR1du?=
 =?utf-8?B?aDYwZmppRXdhZUV1L1RkUFoxSUNMVjAxb2RzRXJ1R0l2UnBzUWp3dUt4S0JY?=
 =?utf-8?B?MG1SdDlaTDZVaUlTd0hzeXBLOXM1QTM2dFpvaGwvMUxSZlpYSzA3Nk9wYlhB?=
 =?utf-8?B?UzVaNmVyZWFEMHRFN0M4c0d3dThPSWNPWmJpOGR4NjNXYjlpQjVrMDdsMXZ0?=
 =?utf-8?B?ellFb0xwODhSNE42VkFBVmVsWDQvbXZJOTgyOUlsYVZNVmVjNHVrVWxPQU50?=
 =?utf-8?B?SjZrZEhqcDRHSklVKzk1NS9iTWNMNktoYzRSWFlLVGdYc1hmYUpYNEhMUHR3?=
 =?utf-8?B?My9ESFZMYW1MQmlxeDVqRHQxY3hIbW1tRU9LWlNhaGF3dmhGY1VSemVGR2RS?=
 =?utf-8?B?YlA4ZGFMYnFoYzUwRDlGdkJNV2lzS1g1bDFhSlVHNXZ6KzlkVEcyNEorQUNN?=
 =?utf-8?B?a25saFhvWVRLa3RtYm9lUXE2RGhrUDlCT0NQeWRVNDZhSExMSDBEZEx5dDRK?=
 =?utf-8?B?RlYwNUtmNVBQdDdWWmY3Z1ppbTZab1oyOEpWUExlUGZvZVp3RmJXKy8xd3BM?=
 =?utf-8?B?aEEvdzVEWkNQcXJxblcvQ3NXbHFGNk9CTEp5a2dZRGx6QVlJdDdZYXRWcnVi?=
 =?utf-8?B?MFBkMnJMd3NEZTFUejhJb0R2UnlNeUhhTjdpdHZzVDFOR1ZHK2Ezc3U4U2FM?=
 =?utf-8?B?bFVuZEh3VVY4OWpnc25zYjF3WGJPU0t1Zm0vTi9SRmpOT2hkV1owWlg3UFBJ?=
 =?utf-8?B?NjZSdGROcTlTaHptc0dreFF2VXd5bzV6YmU2K2ZxOEx1UWhOK3V5N3JCdEV4?=
 =?utf-8?B?cTJvUXVBa0d4WE92QW1WSjNlL0xDWEsvV3BHUzVNU3g2Mi83dG1XM0hhaVVt?=
 =?utf-8?B?dHRWcmxvdzJ6N3Qza0lIaXloYWJ3cHJlS0V3VlZWVXp4TWdRNGNiOEVvKzBV?=
 =?utf-8?B?RmRKV05Vb1Y5U0Fra1htRUlDSjRjZ2V1NkkxRTVmbTltTzQzc2JnbWdHdlRY?=
 =?utf-8?B?dW82KzI5dWpJeWJEbmVoUnE1UW5FazM0SzFZNlQ2ZGNOVHNwMjBpeGdzUWRz?=
 =?utf-8?B?SGRuQjlaUmVFMjg2U0F1ellHVnVUVkgxTXluVFRENStoU1RSYlZPdHhCZndp?=
 =?utf-8?B?V1JaSkRBdllhemM1L2pUNWJXMGwyeEhpZFlVeVArMWJiYXdkc21kYW80ZlVE?=
 =?utf-8?B?d1VQTkY5RWEwa3o4VGlkVUMwTlpXRUxTS1RhZ1NYY2xuMExzSjVPbG1Mc3FQ?=
 =?utf-8?B?Q0pwYUh3ZHlzRFoyUXpSbDhYWmhYRjRzUVE4NW5xamwzT09ubnBBaVlyd2c2?=
 =?utf-8?B?UTBBTnFxa25tVHZWNnp2Z1RZTlpSeDI4WndPZFFIUjgyZm1sRk5jeTdwODZK?=
 =?utf-8?B?TlFzR3YyOVRoc0hiNkUrV3dMa3ltMm1BZ2V3MzlIRU1pVTJUZUVlSnlraU5C?=
 =?utf-8?B?MWlJbk9VYmFkVDF4UDZKSUtIN3B3cVd3cHlTK1J5L3F2Vlh5ZWx0MFo4Q0o1?=
 =?utf-8?B?NndONnJGcGZMOUhtaExUTzdQMzZ5ODRuNkZjT0xaTnIyUDZ3d25yQ1dWWVhI?=
 =?utf-8?B?Q0hBL2ovRldlYUFRdUpCM1hnTEdyNVFPTlJpNDZXN3pZbFZHVkdvOEtZV3N2?=
 =?utf-8?B?cEtlc0taVHJQaEtoWUxMK1pkK2VZb0RrMVk3OWYxYStBRmltMXRvNk5vazA4?=
 =?utf-8?B?aHk5Y0xXNGxRMFdtOGtMbzQwT0dQNnZHWk85OVNsVDRSWHluUnRrK3N2blNa?=
 =?utf-8?B?QzZta3AzUm1OaUdYQlBidEducnU0eDJlTlNLSVVZeWNERTZiVnlMaDdtUUd4?=
 =?utf-8?B?RkhjdlM0TFVDdzIzUit3MURYSy81VXVtUTVkV2hHOG1qWWtWKzl5NU80UGNs?=
 =?utf-8?B?cHlkZTlUTUVyMHZtcDVObzZlQWptVk11cTM3UEE4WEVVTld2aGdkYk9uL1A5?=
 =?utf-8?B?T0VqNVFXVEZRNVdlMjdvL0UvME9WTS9zVjZ4TmlEenZab3BEeUhSZHdzRVk0?=
 =?utf-8?B?QnlBQ09BYWlyNGU1R0toU0dnZ0g0bW9DWmlCQkxiSGw3WU5pelNVQ1FrY0dK?=
 =?utf-8?B?eitpM1BKVUtuM1EzMmtkYWxpR09zWXJXdUxhUE9RVjNLTDdyUGoxbHRWM0U0?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdbb9c96-2ee3-4b6b-5a2b-08de230c30ca
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:27:20.0576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kAo2a9UPavvO3Ip4X8iRiq6PyMKtlQ01isZ0qSAk/iabh0aHoiW8QGzx0vkQuGmzMAvn9457ISgD6+WL5piFMCYsEm6g7o1fnoaaM61kWeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4962
X-OriginatorOrg: intel.com

--------------DXJY2KjthW8WSKTeHfvThfa4
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/2025 8:39 AM, Paolo Bonzini wrote:
> 
> We can just add a NoRex bit and apply it to the six reows you touch in 
> patch 13.

Yeah, I think that is much simple and better. Attached is the diff for
this:

--------------DXJY2KjthW8WSKTeHfvThfa4
Content-Type: text/plain; charset="UTF-8"; name="PATCH14.diff"
Content-Disposition: attachment; filename="PATCH14.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9lbXVsYXRlLmMgYi9hcmNoL3g4Ni9rdm0vZW11bGF0
ZS5jCmluZGV4IGIyNDkwZTU2Y2I3MS4uNWYzNmRiY2VjNDg0IDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9rdm0vZW11bGF0ZS5jCisrKyBiL2FyY2gveDg2L2t2bS9lbXVsYXRlLmMKQEAgLTE3OSw2ICsx
NzksNyBAQAogI2RlZmluZSBUd29NZW1PcCAgICAoKHU2NCkxIDw8IDU1KSAgLyogSW5zdHJ1Y3Rp
b24gaGFzIHR3byBtZW1vcnkgb3BlcmFuZCAqLwogI2RlZmluZSBJc0JyYW5jaCAgICAoKHU2NCkx
IDw8IDU2KSAgLyogSW5zdHJ1Y3Rpb24gaXMgY29uc2lkZXJlZCBhIGJyYW5jaC4gKi8KICNkZWZp
bmUgU2hhZG93U3RhY2sgKCh1NjQpMSA8PCA1NykgIC8qIEluc3RydWN0aW9uIGFmZmVjdHMgU2hh
ZG93IFN0YWNrcy4gKi8KKyNkZWZpbmUgTm9SZXgyICAgICAgKCh1NjQpMSA8PCA1OCkgIC8qIElu
c3RydWN0aW9uIGhhcyBubyB1c2Ugb2YgUkVYMiBwcmVmaXggKi8KIAogI2RlZmluZSBEc3RYYWNj
ICAgICAoRHN0QWNjTG8gfCBTcmNBY2NIaSB8IFNyY1dyaXRlKQogCkBAIC00MjQ3LDcgKzQyNDgs
NyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG9wY29kZSBvcGNvZGVfdGFibGVbMjU2XSA9IHsKIAkv
KiAweDM4IC0gMHgzRiAqLwogCUk2QUxVKE5vV3JpdGUsIGVtX2NtcCksIE4sIE4sCiAJLyogMHg0
MCAtIDB4NEYgKi8KLQlYOChJKERzdFJlZywgZW1faW5jKSksIFg4KEkoRHN0UmVnLCBlbV9kZWMp
KSwKKwlYOChJKERzdFJlZyB8IE5vUmV4MiwgZW1faW5jKSksIFg4KEkoRHN0UmVnIHwgTm9SZXgy
LCBlbV9kZWMpKSwKIAkvKiAweDUwIC0gMHg1NyAqLwogCVg4KEkoU3JjUmVnIHwgU3RhY2ssIGVt
X3B1c2gpKSwKIAkvKiAweDU4IC0gMHg1RiAqLwpAQCAtNDI2NSw3ICs0MjY2LDcgQEAgc3RhdGlj
IGNvbnN0IHN0cnVjdCBvcGNvZGUgb3Bjb2RlX3RhYmxlWzI1Nl0gPSB7CiAJSTJidklQKERzdERJ
IHwgU3JjRFggfCBNb3YgfCBTdHJpbmcgfCBVbmFsaWduZWQsIGVtX2luLCBpbnMsIGNoZWNrX3Bl
cm1faW4pLCAvKiBpbnNiLCBpbnN3L2luc2QgKi8KIAlJMmJ2SVAoU3JjU0kgfCBEc3REWCB8IFN0
cmluZywgZW1fb3V0LCBvdXRzLCBjaGVja19wZXJtX291dCksIC8qIG91dHNiLCBvdXRzdy9vdXRz
ZCAqLwogCS8qIDB4NzAgLSAweDdGICovCi0JWDE2KEQoU3JjSW1tQnl0ZSB8IE5lYXJCcmFuY2gg
fCBJc0JyYW5jaCkpLAorCVgxNihEKFNyY0ltbUJ5dGUgfCBOZWFyQnJhbmNoIHwgSXNCcmFuY2gg
fCBOb1JleDIpKSwKIAkvKiAweDgwIC0gMHg4NyAqLwogCUcoQnl0ZU9wIHwgRHN0TWVtIHwgU3Jj
SW1tLCBncm91cDEpLAogCUcoRHN0TWVtIHwgU3JjSW1tLCBncm91cDEpLApAQCAtNDI4OSwxNSAr
NDI5MCwxNSBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG9wY29kZSBvcGNvZGVfdGFibGVbMjU2XSA9
IHsKIAlJSShJbXBsaWNpdE9wcyB8IFN0YWNrLCBlbV9wb3BmLCBwb3BmKSwKIAlJKEltcGxpY2l0
T3BzLCBlbV9zYWhmKSwgSShJbXBsaWNpdE9wcywgZW1fbGFoZiksCiAJLyogMHhBMCAtIDB4QTcg
Ki8KLQlJMmJ2KERzdEFjYyB8IFNyY01lbSB8IE1vdiB8IE1lbUFicywgZW1fbW92KSwKLQlJMmJ2
KERzdE1lbSB8IFNyY0FjYyB8IE1vdiB8IE1lbUFicyB8IFBhZ2VUYWJsZSwgZW1fbW92KSwKLQlJ
MmJ2KFNyY1NJIHwgRHN0REkgfCBNb3YgfCBTdHJpbmcgfCBUd29NZW1PcCwgZW1fbW92KSwKLQlJ
MmJ2KFNyY1NJIHwgRHN0REkgfCBTdHJpbmcgfCBOb1dyaXRlIHwgVHdvTWVtT3AsIGVtX2NtcF9y
KSwKKwlJMmJ2KERzdEFjYyB8IFNyY01lbSB8IE1vdiB8IE1lbUFicyB8IE5vUmV4MiwgZW1fbW92
KSwKKwlJMmJ2KERzdE1lbSB8IFNyY0FjYyB8IE1vdiB8IE1lbUFicyB8IFBhZ2VUYWJsZSB8IE5v
UmV4MiwgZW1fbW92KSwKKwlJMmJ2KFNyY1NJIHwgRHN0REkgfCBNb3YgfCBTdHJpbmcgfCBUd29N
ZW1PcCB8IE5vUmV4MiwgZW1fbW92KSwKKwlJMmJ2KFNyY1NJIHwgRHN0REkgfCBTdHJpbmcgfCBO
b1dyaXRlIHwgVHdvTWVtT3AgfCBOb1JleDIsIGVtX2NtcF9yKSwKIAkvKiAweEE4IC0gMHhBRiAq
LwotCUkyYnYoRHN0QWNjIHwgU3JjSW1tIHwgTm9Xcml0ZSwgZW1fdGVzdCksCi0JSTJidihTcmNB
Y2MgfCBEc3RESSB8IE1vdiB8IFN0cmluZywgZW1fbW92KSwKLQlJMmJ2KFNyY1NJIHwgRHN0QWNj
IHwgTW92IHwgU3RyaW5nLCBlbV9tb3YpLAotCUkyYnYoU3JjQWNjIHwgRHN0REkgfCBTdHJpbmcg
fCBOb1dyaXRlLCBlbV9jbXBfciksCisJSTJidihEc3RBY2MgfCBTcmNJbW0gfCBOb1dyaXRlIHwg
Tm9SZXgyLCBlbV90ZXN0KSwKKwlJMmJ2KFNyY0FjYyB8IERzdERJIHwgTW92IHwgU3RyaW5nIHwg
Tm9SZXgyLCBlbV9tb3YpLAorCUkyYnYoU3JjU0kgfCBEc3RBY2MgfCBNb3YgfCBTdHJpbmcgfCBO
b1JleDIsIGVtX21vdiksCisJSTJidihTcmNBY2MgfCBEc3RESSB8IFN0cmluZyB8IE5vV3JpdGUg
fCBOb1JleDIsIGVtX2NtcF9yKSwKIAkvKiAweEIwIC0gMHhCNyAqLwogCVg4KEkoQnl0ZU9wIHwg
RHN0UmVnIHwgU3JjSW1tIHwgTW92LCBlbV9tb3YpKSwKIAkvKiAweEI4IC0gMHhCRiAqLwpAQCAt
NDMyNywxNyArNDMyOCwxNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG9wY29kZSBvcGNvZGVfdGFi
bGVbMjU2XSA9IHsKIAkvKiAweEQ4IC0gMHhERiAqLwogCU4sIEUoMCwgJmVzY2FwZV9kOSksIE4s
IEUoMCwgJmVzY2FwZV9kYiksIE4sIEUoMCwgJmVzY2FwZV9kZCksIE4sIE4sCiAJLyogMHhFMCAt
IDB4RTcgKi8KLQlYMyhJKFNyY0ltbUJ5dGUgfCBOZWFyQnJhbmNoIHwgSXNCcmFuY2gsIGVtX2xv
b3ApKSwKLQlJKFNyY0ltbUJ5dGUgfCBOZWFyQnJhbmNoIHwgSXNCcmFuY2gsIGVtX2pjeHopLAot
CUkyYnZJUChTcmNJbW1VQnl0ZSB8IERzdEFjYywgZW1faW4sICBpbiwgIGNoZWNrX3Blcm1faW4p
LAotCUkyYnZJUChTcmNBY2MgfCBEc3RJbW1VQnl0ZSwgZW1fb3V0LCBvdXQsIGNoZWNrX3Blcm1f
b3V0KSwKKwlYMyhJKFNyY0ltbUJ5dGUgfCBOZWFyQnJhbmNoIHwgSXNCcmFuY2ggfCBOb1JleDIs
IGVtX2xvb3ApKSwKKwlJKFNyY0ltbUJ5dGUgfCBOZWFyQnJhbmNoIHwgSXNCcmFuY2ggfCBOb1Jl
eDIsIGVtX2pjeHopLAorCUkyYnZJUChTcmNJbW1VQnl0ZSB8IERzdEFjYyB8IE5vUmV4MiwgZW1f
aW4sICBpbiwgIGNoZWNrX3Blcm1faW4pLAorCUkyYnZJUChTcmNBY2MgfCBEc3RJbW1VQnl0ZSB8
IE5vUmV4MiwgZW1fb3V0LCBvdXQsIGNoZWNrX3Blcm1fb3V0KSwKIAkvKiAweEU4IC0gMHhFRiAq
LwotCUkoU3JjSW1tIHwgTmVhckJyYW5jaCB8IElzQnJhbmNoIHwgU2hhZG93U3RhY2ssIGVtX2Nh
bGwpLAotCUQoU3JjSW1tIHwgSW1wbGljaXRPcHMgfCBOZWFyQnJhbmNoIHwgSXNCcmFuY2gpLAot
CUkoU3JjSW1tRkFkZHIgfCBObzY0IHwgSXNCcmFuY2gsIGVtX2ptcF9mYXIpLAotCUQoU3JjSW1t
Qnl0ZSB8IEltcGxpY2l0T3BzIHwgTmVhckJyYW5jaCB8IElzQnJhbmNoKSwKLQlJMmJ2SVAoU3Jj
RFggfCBEc3RBY2MsIGVtX2luLCAgaW4sICBjaGVja19wZXJtX2luKSwKLQlJMmJ2SVAoU3JjQWNj
IHwgRHN0RFgsIGVtX291dCwgb3V0LCBjaGVja19wZXJtX291dCksCisJSShTcmNJbW0gfCBOZWFy
QnJhbmNoIHwgSXNCcmFuY2ggfCBTaGFkb3dTdGFjayB8IE5vUmV4MiwgZW1fY2FsbCksCisJRChT
cmNJbW0gfCBJbXBsaWNpdE9wcyB8IE5lYXJCcmFuY2ggfCBJc0JyYW5jaCB8IE5vUmV4MiksCisJ
SShTcmNJbW1GQWRkciB8IE5vNjQgfCBJc0JyYW5jaCB8IE5vUmV4MiwgZW1fam1wX2ZhciksCisJ
RChTcmNJbW1CeXRlIHwgSW1wbGljaXRPcHMgfCBOZWFyQnJhbmNoIHwgSXNCcmFuY2ggfCBOb1Jl
eDIpLAorCUkyYnZJUChTcmNEWCB8IERzdEFjYyB8IE5vUmV4MiwgZW1faW4sICBpbiwgIGNoZWNr
X3Blcm1faW4pLAorCUkyYnZJUChTcmNBY2MgfCBEc3REWCB8IE5vUmV4MiwgZW1fb3V0LCBvdXQs
IGNoZWNrX3Blcm1fb3V0KSwKIAkvKiAweEYwIC0gMHhGNyAqLwogCU4sIERJKEltcGxpY2l0T3Bz
LCBpY2VicCksIE4sIE4sCiAJREkoSW1wbGljaXRPcHMgfCBQcml2LCBobHQpLCBEKEltcGxpY2l0
T3BzKSwKQEAgLTQzNzgsMTIgKzQzNzksMTIgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBvcGNvZGUg
dHdvYnl0ZV90YWJsZVsyNTZdID0gewogCU4sIEdQKE1vZFJNIHwgRHN0TWVtIHwgU3JjUmVnIHwg
TW92IHwgU3NlLCAmcGZ4XzBmXzJiKSwKIAlOLCBOLCBOLCBOLAogCS8qIDB4MzAgLSAweDNGICov
Ci0JSUkoSW1wbGljaXRPcHMgfCBQcml2LCBlbV93cm1zciwgd3Jtc3IpLAotCUlJUChJbXBsaWNp
dE9wcywgZW1fcmR0c2MsIHJkdHNjLCBjaGVja19yZHRzYyksCi0JSUkoSW1wbGljaXRPcHMgfCBQ
cml2LCBlbV9yZG1zciwgcmRtc3IpLAotCUlJUChJbXBsaWNpdE9wcywgZW1fcmRwbWMsIHJkcG1j
LCBjaGVja19yZHBtYyksCi0JSShJbXBsaWNpdE9wcyB8IEVtdWxhdGVPblVEIHwgSXNCcmFuY2gg
fCBTaGFkb3dTdGFjaywgZW1fc3lzZW50ZXIpLAotCUkoSW1wbGljaXRPcHMgfCBQcml2IHwgRW11
bGF0ZU9uVUQgfCBJc0JyYW5jaCB8IFNoYWRvd1N0YWNrLCBlbV9zeXNleGl0KSwKKwlJSShJbXBs
aWNpdE9wcyB8IFByaXYgfCBOb1JleDIsIGVtX3dybXNyLCB3cm1zciksCisJSUlQKEltcGxpY2l0
T3BzIHwgTm9SZXgyLCBlbV9yZHRzYywgcmR0c2MsIGNoZWNrX3JkdHNjKSwKKwlJSShJbXBsaWNp
dE9wcyB8IFByaXYgfCBOb1JleDIsIGVtX3JkbXNyLCByZG1zciksCisJSUlQKEltcGxpY2l0T3Bz
IHwgTm9SZXgyLCBlbV9yZHBtYywgcmRwbWMsIGNoZWNrX3JkcG1jKSwKKwlJKEltcGxpY2l0T3Bz
IHwgRW11bGF0ZU9uVUQgfCBJc0JyYW5jaCB8IFNoYWRvd1N0YWNrIHwgTm9SZXgyLCBlbV9zeXNl
bnRlciksCisJSShJbXBsaWNpdE9wcyB8IFByaXYgfCBFbXVsYXRlT25VRCB8IElzQnJhbmNoIHwg
U2hhZG93U3RhY2sgfCBOb1JleDIsIGVtX3N5c2V4aXQpLAogCU4sIE4sCiAJTiwgTiwgTiwgTiwg
TiwgTiwgTiwgTiwKIAkvKiAweDQwIC0gMHg0RiAqLwpAQCAtNDQwMSw3ICs0NDAyLDcgQEAgc3Rh
dGljIGNvbnN0IHN0cnVjdCBvcGNvZGUgdHdvYnl0ZV90YWJsZVsyNTZdID0gewogCU4sIE4sIE4s
IE4sCiAJTiwgTiwgTiwgR1AoU3JjUmVnIHwgRHN0TWVtIHwgTW9kUk0gfCBNb3YsICZwZnhfMGZf
NmZfMGZfN2YpLAogCS8qIDB4ODAgLSAweDhGICovCi0JWDE2KEQoU3JjSW1tIHwgTmVhckJyYW5j
aCB8IElzQnJhbmNoKSksCisJWDE2KEQoU3JjSW1tIHwgTmVhckJyYW5jaCB8IElzQnJhbmNoIHwg
Tm9SZXgyKSksCiAJLyogMHg5MCAtIDB4OUYgKi8KIAlYMTYoRChCeXRlT3AgfCBEc3RNZW0gfCBT
cmNOb25lIHwgTW9kUk18IE1vdikpLAogCS8qIDB4QTAgLSAweEE3ICovCkBAIC00ODg4LDcgKzQ4
ODksNyBAQCBpbnQgeDg2X2RlY29kZV9pbnNuKHN0cnVjdCB4ODZfZW11bGF0ZV9jdHh0ICpjdHh0
LCB2b2lkICppbnNuLCBpbnQgaW5zbl9sZW4sIGludAogCWlmIChjdHh0LT5iID09IDB4MGYpIHsK
IAkJLyogRXNjYXBlIGJ5dGU6IHN0YXJ0IHR3by1ieXRlIG9wY29kZSBzZXF1ZW5jZSAqLwogCQlj
dHh0LT5iID0gaW5zbl9mZXRjaCh1OCwgY3R4dCk7Ci0JCWlmIChjdHh0LT5iID09IDB4MzgpIHsK
KwkJaWYgKGN0eHQtPmIgPT0gMHgzOCAmJiBjdHh0LT5yZXhfcHJlZml4ICE9IFJFWDJfUFJFRklY
KSB7CiAJCQkvKiBUaHJlZS1ieXRlIG9wY29kZSAqLwogCQkJY3R4dC0+b3Bjb2RlX2xlbiA9IDM7
CiAJCQljdHh0LT5iID0gaW5zbl9mZXRjaCh1OCwgY3R4dCk7CkBAIC00OTA1LDYgKzQ5MDYsOSBA
QCBpbnQgeDg2X2RlY29kZV9pbnNuKHN0cnVjdCB4ODZfZW11bGF0ZV9jdHh0ICpjdHh0LCB2b2lk
ICppbnNuLCBpbnQgaW5zbl9sZW4sIGludAogCX0KIAljdHh0LT5kID0gb3Bjb2RlLmZsYWdzOwog
CisJaWYgKGN0eHQtPmQgJiBOb1JleDIgJiYgY3R4dC0+cmV4X3ByZWZpeCA9PSBSRVgyX1BSRUZJ
WCkKKwkJY3R4dC0+ZCA9IFVuZGVmaW5lZDsKKwogCWlmIChjdHh0LT5kICYgTW9kUk0pCiAJCWN0
eHQtPm1vZHJtID0gaW5zbl9mZXRjaCh1OCwgY3R4dCk7CiAKCg==

--------------DXJY2KjthW8WSKTeHfvThfa4--

