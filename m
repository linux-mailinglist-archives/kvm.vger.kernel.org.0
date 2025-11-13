Return-Path: <kvm+bounces-63092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 924E8C5A885
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:25:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D03D3B2FC8
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BBD5328267;
	Thu, 13 Nov 2025 23:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DkAiQIvv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093B92E6127;
	Thu, 13 Nov 2025 23:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076224; cv=fail; b=tMt4iqagt8LwoHULRdPQBFuO8wDFAfAuGzdJqfFFxXlYf12XKMtJWMcAX66roBQC7cYH1DxEofAsKbMpD5x+WNsqYcPylVVymGlvBVo3rnBEjT8P+PzcLe4txhCgVvB2HIfyCsVwfQ0SoAYIUdOU8/oXI2f4MZ6eRcg4ZBPUhqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076224; c=relaxed/simple;
	bh=NpZfXlJ38LV84nM3i8R3LmWobQ4SJVMXkVd8oxlZRrQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j6TqndPWsvhNBKQQZg77OeeU2KKw9vlbrqp5NS/xh1TaL9GgBxbtG+R52NnoANDo51v3B3OrEqc+a1VuErHYRp4gfLy/gjsyDBY9ttYS3ucDXwqndJrsi4FXnKNRxoHGode/I583XS61ppJf9XQZ90qxTD54NLJQt3m40OgR/sQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DkAiQIvv; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763076223; x=1794612223;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NpZfXlJ38LV84nM3i8R3LmWobQ4SJVMXkVd8oxlZRrQ=;
  b=DkAiQIvvx7uf1u3Lqio01pqv6ZQnBEE0DrIU5Fa4g/Owh/sWBqqqi1m3
   7PtdZ9dE78he1DpGJf1cnMQJsfC1v/hKtQU7xd6o8BX29gmOAyf/G0M8Q
   2sC9Pu0mz1gC/UK30mvISMojTz2Hmqi86dg4y2yYT/bmfX9a5Z3d5NvQp
   Oqn2d9dfSJz5yDPTdZ0dKqwRZEqZdKSv4Zpnxbaj/AmySk2AFsxTA1d5D
   3NQDwMpDYITV7JWrqW2JM0A4THCzKzaSLdixPNyosbkDwjLagJAJ/udX/
   kn1kBn9Oxwwg1dZrgHct2gm3KBaerZ58rVsnZ2ea4da/l6TPoSwvEgu7Z
   w==;
X-CSE-ConnectionGUID: D28IN6+IRDiz/RL5pCud3g==
X-CSE-MsgGUID: wKDgyd4KQceHH9Qzq3nkxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="82802830"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="82802830"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:23:42 -0800
X-CSE-ConnectionGUID: rW388FhjQDq1C+rqdL6fIA==
X-CSE-MsgGUID: Fg5jhJliR2eU/oyBFn4XNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="190051125"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:23:42 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:23:42 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:23:42 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.2) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:23:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mGZAmAKD8dJlNf5nlbDAiRRnWAUIqn2vEOd1JdJf6fvMHUd+u+l30ysVsfT384+7WZvsh6nASBUpG6myvtYSmx81ZS6oRPmBvMvEpIqZ+PcOozlv0iF8UkHShcXkzr1GuO7Edk2qnEJcEhB8ptjhFoAwZqcq8sviI/Rs8uJmWvlAUalvirdHYlNyQdLBs19GLV8nDJ2/+SRRq98JuVRcQyYBFR7Q0BURkHDA6fhyA/8I9NQwPWGTykm4KKSK/juklmPBt8MADQY2Wk+TnrofbZoIN9HK1UpvMhZongvKY7q4KpRL0jw7I3NnkDFaaxsAiSsvl5zZB3Zu7TXCYcR1JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRN00tpUyArooB+ARWLc7LpHJU7ODoipoasci/EMn3E=;
 b=uguQMURI34QSxUlwXJvepMdFyrosurgZa7RBd0d0RpUmvkumX1S3ZEqeOrD5YeyX+0z0eLbF0udixsxBwR1anbu6+KyCPkdplorsMSH965qFSEXffVaUMx0DPzzMJ5VOHoLKOEH75YXRzczfhbmAoeUOrKP+N4bkNnn0AnacVksTJ0kCT87Dasjf2ICJldGq/lG43kwASfX80iDUXAV+t2QqRQ/reKIkL3dEPD4NrZLNdBImj/MaeEwX8AGSq62l4dT4Fx7LQj7yPa1QCs4sWJ1pTA2Mg2hVY+gEyjrKOVN+iQS4mGciL706vs+stY/8b12nmSSOQqyQVNzCTCRYaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CO1PR11MB4962.namprd11.prod.outlook.com (2603:10b6:303:99::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Thu, 13 Nov 2025 23:23:39 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:23:39 +0000
Message-ID: <cc45ccba-c29a-4eaa-ad62-5a5c7bb2a773@intel.com>
Date: Thu, 13 Nov 2025 15:23:37 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 10/20] KVM: x86: Refactor REX prefix handling in
 instruction emulation
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-11-chang.seok.bae@intel.com>
 <d6c3e231-fc24-434d-bb5b-7db5852043b3@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <d6c3e231-fc24-434d-bb5b-7db5852043b3@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ2PR07CA0021.namprd07.prod.outlook.com
 (2603:10b6:a03:505::23) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CO1PR11MB4962:EE_
X-MS-Office365-Filtering-Correlation-Id: a9851963-2862-43e2-9f57-08de230bad53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N2psWmRLUzFyNjU2cTByaEdqVFRzQnlNajVFWTlnT1NOS2lydkNPNXpFSUxr?=
 =?utf-8?B?em5CU3cxaS93Sk5PQWdLd0EwNEY4U0FsdXZxZThVcDd4Q3MvQnVwV0RrM0lw?=
 =?utf-8?B?eDk0anV3bHBkVjhYRml3Q2ttdEVrYmMxc1pBUTVlWCt5WmNhU3JuLytSL1dM?=
 =?utf-8?B?dmtYZ0taZUlXNk1JSVFEa0xMVzE4QzU0Qm9ycDlRalhObkFSOEpZdEczQ3o2?=
 =?utf-8?B?azdkMWNuZDlMMVFiUVNQUW5XZ1ZTbWdET3o2SWhwSkU1QVF6ckFPYTJtc1BU?=
 =?utf-8?B?VmF1VCthZEJmTVJaRWl0VWRYRmEwNGovWTZyZnhVWERVOEFac0lnVmkrWWNZ?=
 =?utf-8?B?RDlnZDRvTjN1d1RZbC9wN2FnUm5HWGlOaXZUZDgzc3N4Z3NvRUdzK1RROVVF?=
 =?utf-8?B?TS8reVQ5MVp2K2o1dFVtb2tWNkI0VlNFeHZBMjBRZm41VWd4ZnZUdnc1WUEv?=
 =?utf-8?B?WHYxRXFJeW1Qd3ZJYTJ3RWNsd1dockMxaldBS3UvSm5tRWhVVHdRLzY0allB?=
 =?utf-8?B?WnRLeHg2akVKWGtqbXU5K0s4a0FvVE15bm1XemFzSlZ4aSt5TzFPeXhQVWs5?=
 =?utf-8?B?YXhiNEl2eXpNOEtsK2pxKzBlbFd5VHhNOXdFYzg0N1lDUDRSNlhsdDhFY2du?=
 =?utf-8?B?RzN6STNGMWZRenRGMVNvZVlnS2o5dENYb1k2T3V5UVYwNjhWdEVwNEdCTTVx?=
 =?utf-8?B?SGlGbkJpaUFydHFCRlBZM1hEQVVYMDlwRm1qanhxQ3I1MWpzaDJCSm5RcXQw?=
 =?utf-8?B?NVZXVUJONkVibENJTnNwNm9MV3RDbWtQY1gwSlZCcFdzYXVHMWh1cnJ0aVV3?=
 =?utf-8?B?OEJMakorSUgrbkhjVDVvYmtXYXlXRThibWhHcHFzdlJ2dGFHUnUzVnBxaVZR?=
 =?utf-8?B?SHRqMkU4TUJTVC8xOTN5ajZaRC9SeDZPWC9aR0tNTUQ0MjRnMWZTNGtUN0Zn?=
 =?utf-8?B?cFFPNHFybEcvWHhMZmRLdWNkcGlzZkV6STJrL0VrR1h1cmFob1FFbnJFUGR4?=
 =?utf-8?B?YnhObmwzY3dKQmR3ZGcwUE5IdnVZbVJycFl2OFdISC9tcFlaQi9OYW92Qjlu?=
 =?utf-8?B?N20zK1g2VGdueDkrZk5ndDVUTnJPRnJSMW1NN050bzY4TmtyWXhKeXFtQ2ZK?=
 =?utf-8?B?RlNVK3lXdWxabVlGM2RwVjlJZzRGaFRKZlhHZlJDMDN2b0w3VXdScGh2MW9W?=
 =?utf-8?B?VEY0eU00aEZKT0ZqZ2VHZjAwZ2l5QXRFRWE5a2FZRlRBdlBmaStiSFplbnpI?=
 =?utf-8?B?WjZIU05JVWx6Q09kSndQWXBHY29XM1lxTFl3cFdKcXoyVkZYdHRUaGlEN3pW?=
 =?utf-8?B?VEpCT0hCVXRJWHVkcjE4aytqZ3JicUNLYUYzWC9kN0NtV0Rtb2FhREYxcXZK?=
 =?utf-8?B?bVh2OTE3RlppRXpyRzdWN1lZOFpIVTV6VzBLdnNGTlZsVnNUR1RUVVA4bkFr?=
 =?utf-8?B?Nm5LRUYrZklGS0R0VTBWaFJKVCt6U0VRN0lFaCtDalJHVW43bG1IbGNSR0Rj?=
 =?utf-8?B?blFUb1J1V2RkMXlNemhtaHRoOEV3d05yb2lVUWlYRW5vZkdEM0k4YXc5TmZZ?=
 =?utf-8?B?eGdaZjdVWHd4Y2ZldTBxamo5c0VucnFlTk9jNldyVEVQZ0dKbGl4bWRQQ0R1?=
 =?utf-8?B?WHdYa2l0VEg3R0ErTERzSGdXZkpSdW0rd3I2WDFrQWZOOFBHc3pkVk05bktq?=
 =?utf-8?B?YnBqYUl6RUp4ZmUweWdMcDlORzVvVHFrZlNqdEM4aVRxN0Y5Y1ZqazRKYXhm?=
 =?utf-8?B?NDZNRWFzWDIyMmNmcnlub2x5VHFSTzBBNDBkUFE0cUtlZHFJOHJlMUVyN1U0?=
 =?utf-8?B?b2ZtTEtJU2tHVkZGQTI0TFVxUE1nc3dqamIzOVkxWWNhT0xUcnlPNmFXenMy?=
 =?utf-8?B?RktaajFSNlNBUjVoazhkYm5NTVY1eS9sNklVakdEdEptN0dFczFDS2RNM0Q5?=
 =?utf-8?Q?aqemUJQg210eOgbwj85W3+33TNxJwf3R?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnY3VklEY2xaVlNGbldqMWEySnVqK08rN0NVdXNjR281VVo0alpGbXU0ZGhz?=
 =?utf-8?B?Z1FrbHluZ1BNS21nSjE5UkJIRzI2MDVPVnhrNlE3SW12eUlZQjhNVml2L1Z6?=
 =?utf-8?B?bW1wMzlpV2hhQlR0cWZHMjMyR1d1SWpZNDJTcm1ySWJxTkVJME5IaG0xUnRD?=
 =?utf-8?B?MXhvOVlQWWJtV1NkTFFPa0lUcjdtL0JibW5GKzhicDlxMThVVE56OHc5S24w?=
 =?utf-8?B?VHZnaWluaWRlM2QrWFI4Zi9uSGtFeHFERlJFV3cxNVdwdjVpYnh5ZE5DUDNV?=
 =?utf-8?B?NGhyWmNnN0NaNU9hYVpTNGZOZURWbGlDTHc2Y1I1UzZwNkE0S3dpQm1RQjNq?=
 =?utf-8?B?eFMxWWZCVWlhQ0t0NlZ6cFVxMlBKdnZMUGVwSU5vRWt5Vy9rYkw4NTNGc2Va?=
 =?utf-8?B?Y1JXNFcyZzVYby9HclRwT20wY0xnak1BLy9tSHdXQmkvWHN1ZytFY3pjcnNt?=
 =?utf-8?B?NnBoc3FXUnROSjNxSXNTcEtHYitnUEMxWDFITEVLdXdDTVpVdXQ4dDRDeHAy?=
 =?utf-8?B?KzJYM2E5UFBhYTVFNGJLRmRrcW5md3IyY25ZQzdmVDJwM3FjN09CcWxLc2NP?=
 =?utf-8?B?K1BZcG8vdnB1WEh1MWhoOSt0UG1TYUo1UzkwTldyUDFOQUpyWTlaYktpTFdt?=
 =?utf-8?B?NVFZTXM5RkJ3KzltQ2ZqV1FVNDU0QUhPWGhRRytlY3I1L2VPaDJWeitWMHBj?=
 =?utf-8?B?ZHJqZUtSREdRb1BBT0h3VTBmU3FwM3E2VEljYXlJVG1oK2dhdG02Y2dKTjQy?=
 =?utf-8?B?SVA0dC9KNkppcVJUQS8xK0FlNzl6UUwxU2hCeEdMMHpRdXlYS3hERm9haWR5?=
 =?utf-8?B?VmtBVHgyeTlSS1NsWUdFYkR2VmgrRTFQVjhubzh1U05RbEw1aXNsNXYwNkNv?=
 =?utf-8?B?bjNlcFZMNmZscmovamNMbHVhQkR1L1h4em96b1pxaE9rV0FKc1VBdStzelEw?=
 =?utf-8?B?bVFWcXg5MHV6ZFFZTTdSZzFYWFJaeHdnc040ZnIzSjlMTWdhOWExbXBhVDFz?=
 =?utf-8?B?am5mZHYrbHcxZ1V0R3g0WUpkaHVFK0d3N2FsOFl4OERWUXB5UTZJMXRrMytF?=
 =?utf-8?B?RWRNdkluVlJCaERTUHNpaFpoajJrOGtUM01DNk9Ec2tObjFVWmtPZ1BRb0R0?=
 =?utf-8?B?TU1ONXpvcWtXWElFNWphVXg4ZnEyTVJoWFNJUEZ5S3NSdTVGQUVnWllHZ2w1?=
 =?utf-8?B?ZVJyRUIzZWJQVFZJbG9hOTJTclRDTWxYT1JXMW42N0ZIVTlkd0FHR1ZFaEtK?=
 =?utf-8?B?NGtHYUxzVjlFMG9LQ3VHcjF4c2V6RU0rYjAxcGJhRnMxWDBIb2phMWJaRklm?=
 =?utf-8?B?Q0c0WDdqMzZWYmU1OFpOR2JINmZPbnppYncreVFJcTZ2UEdkaW9WYVRnS2Vq?=
 =?utf-8?B?R2NZc0hNa05uVU9JVmsvUWdrQ3ZneXZ0ZktjNnRGU2ttcTFQOW1uVHZvbWJh?=
 =?utf-8?B?ZmhoU0FkZzhTNFVLamNpSXJXYWVRbHZMV2dOVlpFODY0RnVUMS9PbEZNcTRT?=
 =?utf-8?B?bWNNV05XK3FHOEI2MEFQemNLbGY3QXNIVmY2NWR5Ly9GTng1WWZNRWxzZ09W?=
 =?utf-8?B?YnhCSVdVL09hRUZ5d294UndINGxmTXVUSi9qbDQ0Z1UxTU40TTg1YXFWK3FK?=
 =?utf-8?B?T3BXOVk3T2dYV3h1OVJlSDVpZkEyUEFwVGxXUno4VEFRdCs3Sm5rSGVwbXlz?=
 =?utf-8?B?V1UrTnJhNTNOeHZ4UmNMSjFQRFp3YU1NWHNseFFqY2E2MHNMRUxkanZieDFv?=
 =?utf-8?B?K0c1b1ZRZFlxVlFMSXo1TXRFKzdIOUs3RHJiQU91RVNONEVYSGhXa3VqYmZz?=
 =?utf-8?B?ZDd6UVBuT3lpbCtuM0pld2NQcTNTdnNhRmYwcm9MQ0YwR3FaZDdZV21TeWVE?=
 =?utf-8?B?OFMyQ1l0QmZYYldnLzBSMFR1TnVQOERpTUxwakZPdlRXbzlTRmp0NlhPN0w3?=
 =?utf-8?B?dTBuTXZ6T1hYODkycUNvL09PNmhUUnVzSUEzOUtWSUhUaHJVQjJEQ3JPYm5v?=
 =?utf-8?B?RVd3L0RyUVVUVkEreDM2ZDVGMm5nT0ZOOFlKZnZEdzNmamNUTFQ3eEdVZGVY?=
 =?utf-8?B?TGR2d1JZSzNvR3dyWVEwckl0L1AyVzVSb2ZHUDdFWDNNekZuYTd3dFUxZU0v?=
 =?utf-8?B?a01ZOGxFQ2xvT2w4aUI0M29IQ1JZZG02T05MaWFkUE5wSUg4ZU40d2dlY1h1?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9851963-2862-43e2-9f57-08de230bad53
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:23:39.4522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Ej7mtyXNwOl8e8FHZbZiaHvh+7UOgV0tWknGsAvR+ahs8qScAUk/TYuT0F3bx0zk9VLMDda0Z1QRfxz92lQGFxmrFuy8RVoA+1ldZCZb2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4962
X-OriginatorOrg: intel.com

On 11/11/2025 10:17 AM, Paolo Bonzini wrote:
> 
> commit fc8aa5c45d558393069a1c89b7a64e059b8f9418
> Author: Chang S. Bae <chang.seok.bae@intel.com>
> Date:   Mon Nov 10 18:01:21 2025 +0000
> 
>      KVM: x86: Refactor REX prefix handling in instruction emulation
>      Restructure how to represent and interpret REX fields, preparing
>      for handling of VEX and REX2.
>      REX uses the upper four bits of a single byte as a fixed identifier,
>      and the lower four bits containing the data. VEX and REX2 extend 
> this so
>      that the first byte identifies the prefix and the rest encode 
> additional
>      bits; and while VEX only has the same four data bits as REX, eight 
> zero
>      bits are a valid value for the data bits of REX2.  So, stop storing 
> the
>      REX byte as-is.  Instead, store only the low bits of the REX prefix 
> and
>      track separately whether a REX-like prefix wasused.
>      No functional changes intended.
>      Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
>      Message-ID: <20251110180131.28264-11-chang.seok.bae@intel.com>
>      [Extracted from APX series; removed bitfields and REX2-specific
>       definitions. - Paolo]
>      Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Sure, I think it's good to have consistent handling like this for these
extended prefixes across the board. Thanks!


