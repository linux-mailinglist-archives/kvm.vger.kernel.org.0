Return-Path: <kvm+bounces-24860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B20495C1D9
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 02:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0799D1F24364
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 00:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9628BEA4;
	Fri, 23 Aug 2024 00:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lzqE+sO0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776F7620;
	Fri, 23 Aug 2024 00:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371427; cv=fail; b=g/ojr7ujZYKmRua69rgFnOrIxP/iHdC8igjcvC6iBG+rmxdbLjwmyrOsA9taJoPYPQCGtl5Vo6mgwNs4JNFVsgyEUT55PIg0vJAjCuCPhmhMtjCquf1Y+OGUe8l2XqTp6hR+hNBiAK1fB2t8beLPL5z7tR2rOXEHjYms8GNo0gU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371427; c=relaxed/simple;
	bh=CeL5PuzgKqXXwdlCuDb1mV0qbmng8/fcGic1BRhBNjk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UbrUkQ0svLJVa4U0Igeea93cloMxgHVU8QaFj5mHR5hEGTjcTDScvLm0/kwUTeBXr1nf8LzbSYw8aS4DykeRBIxX6v7LBIH71OJfoxUueHslXLpo9dqcbGviVc13JOrbni29DPS1PDExPf7KIdIA+aqp7mEM84uRiKbFfr4mFaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lzqE+sO0; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724371426; x=1755907426;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CeL5PuzgKqXXwdlCuDb1mV0qbmng8/fcGic1BRhBNjk=;
  b=lzqE+sO0BP4jLqequ08SseET2oqRMLa6kYEQG88J1FI2ke8KvbSZ4k9+
   3ZCim4wXlGwK6ZaAH+34D3UaUO1zNtsLYSxt6qhjif7kHmWpfWopwBUam
   KgswGAaAXBGhXyTa3X+WQJ3CfMdXfcowKkEh1j0KQFC+IRrtIgG2vABR3
   Cfp8Nw2dv2cgC2K3VoFSbGbkC/aqIf0dAZ4BoMfL3SiHbOzEgq0MWQdZT
   7T5MXNUzGDhBjthmgUCFjQ/YAfjz4tmh/5G5RHXDBBWx3K1muntcN2bio
   D3sD2Dm2OlTzZvHvdtC+GS23P5FlNMYU7Z1hnA746DP67Pc2eSRCoHrEA
   w==;
X-CSE-ConnectionGUID: 5Abw5Rv6QvSDSNc3kGM9zw==
X-CSE-MsgGUID: 9Ug2TCqhRuW/HkHD2bGtOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11172"; a="22699289"
X-IronPort-AV: E=Sophos;i="6.10,168,1719903600"; 
   d="scan'208";a="22699289"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 17:03:45 -0700
X-CSE-ConnectionGUID: VL18ZFI+RfqtaUI9Mha3VA==
X-CSE-MsgGUID: Dit8q3BEQk6jVEHKrrqJyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,168,1719903600"; 
   d="scan'208";a="62346735"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Aug 2024 17:03:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 22 Aug 2024 17:03:43 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 22 Aug 2024 17:03:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 22 Aug 2024 17:03:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XfXRGLJtvBLI7PreN1tPy6NiXWkW/zmJJB/lFtY346WB+Z1tqi2YhLtRWdFUwi+8VysK/PXz2Z4QNUhdECLkqu4dljoe3xDd8idlouhtmio+TomghMIFDOYakhK9vP9Y6tL7Qjrf9WF27TOdqZGj8dPEK0B+weZIDnU7EavKgUDVKRicaDBvzmBRAJ0xcBEykHzd15EJB7T3UYaRdsR8YpM67fQZYm5KVIN2YVy0aPd0rASlCUI5z7Crx2qHSB9jbkRBvlAiWe39ehTbEZFjPTqyu9dlkJO1Nd9zGYzL+Z0So4Mdq1xiREkd1Ad7pgM4et95/9Pog4jHyqfnYSvBlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nSJnL/DtP7iosF+rKfdS+fQfmo6cgx4N2e0xt8l78YY=;
 b=I8+ryq7ZwKhlG4LHI67mPcNXuPsFP0R54mjjuGl4y/nugvkGE/4pM/cKwRdiNqJnFLXScVyXWdtGYylixkzw34K61p2rojpqxl6YsAnXWSBIB+5dvx15igLI1CTE8WXvWStQP+ZZL3iak4TNn1Xd9HLzapjEGQxshRTkuVjQHWUigMMqtBCCzyd13eu315Ugaq58LZ/dFzYlZAEO1nxfjOl2m5mjc+skfTDaCJ6bRZA2QHuEBxKTyoRplrJCCI1Cj57qQHjqStixHt3SYQPruWFE67SuX/VleIf6sacTuJ721pUkEmLjgANYBlsoKLqHOKQ2Yaav2YUoI5u6ousQIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB7426.namprd11.prod.outlook.com (2603:10b6:a03:4c4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Fri, 23 Aug
 2024 00:03:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7875.023; Fri, 23 Aug 2024
 00:03:38 +0000
Message-ID: <b3c27ca7-a409-4df5-bb55-3c3314347d7d@intel.com>
Date: Fri, 23 Aug 2024 12:03:28 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] KVM: SVM: Remove unnecessary GFP_KERNEL_ACCOUNT in
 svm_set_nested_state()
To: Yongqiang Liu <liuyongqiang13@huawei.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
	<hpa@zytor.com>, <x86@kernel.org>, <dave.hansen@linux.intel.com>,
	<bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<pbonzini@redhat.com>, <seanjc@google.com>
References: <20240821112737.3649937-1-liuyongqiang13@huawei.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240821112737.3649937-1-liuyongqiang13@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::34) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ2PR11MB7426:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dc14ef1-d908-4a12-172b-08dcc3070a52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUx5L2tMcG5GWllGdjl5Sjdsd1NnYkM5VFBhQVZBTlBjNnhON1BCTXNVdlkr?=
 =?utf-8?B?UEZQVmRGUHJ2RlQ2WDV4UW5xRTBHVi9yWWJ0UXpkTzcwcTluYmtuNVhWRloy?=
 =?utf-8?B?SXZ4cEsvVCsrdHNYMm9CakFMTnNKTzQxQ0JKSjk5c2g0d1dIQ2NkRmM4M2c3?=
 =?utf-8?B?SkNPVDQ2VnZBTFpyWndSc3NrRTB6bXNKK2UvdFpOUGtRbGtGRjdjc1pBbkl3?=
 =?utf-8?B?WmxXdktxVStOMGFYTVcvaE5Xc0psc3hLUloyVmR3azRqVkF5SS90OVB0TEdX?=
 =?utf-8?B?NE1VNmFNc2FGdkxSNTJVQnZRTmdRWEtYUk4xdEJ0dXRxS3Qvc285emVyMGRG?=
 =?utf-8?B?ZWZlbFdUQnhCaHp1ODhEbE8rbmx6Vkp4U3k5ci9wbWdxV0tkbW5ocWI2cmhu?=
 =?utf-8?B?SXJnNHZTWWFPOHIzNXpISUpGekFsUDFrMFhRV2lqMUtrWFo0ajA4UWlqOHpX?=
 =?utf-8?B?L2xNU2tvZGR3bWM4akcwQ0YrVGltTzdqOXk1S2VVVm5qTEl2SU91VWEvREJ4?=
 =?utf-8?B?a1VVYjBWeHBOajBUMXR5UXJ3Y0d0dWlzZzkwQy9IYnlDSm1BUEhuNThacWMv?=
 =?utf-8?B?UUdVcnVnRjhEb1RGZzczNTRpdExSUDRpN2Y0TEI5VnVCUXZSQ2RiVGVHVnNL?=
 =?utf-8?B?VHhOOXlFWmljNUxPYXBqdU9xTEVPTVRFSVE1SElXV3YyMURhOWtaWVAwQm03?=
 =?utf-8?B?TW5qWFRGWlNIaExvcUpVbThPSVc4ZkIva0xGSEhlRHYwS1pGR1UxZW9kMCtM?=
 =?utf-8?B?ejcvV1dhbW43Z0hMSnlSckViSkZOUFRLNFpUR1RRZXlKek81ZEF5ZnRBbGhR?=
 =?utf-8?B?MEM3VVV5TlI1emViTGYwWkZYbUlEaUgzS251YnZmamMxZithYnNMR21hSDlT?=
 =?utf-8?B?YWF5cTRqaHpwMW9wSThLMzFZNW5TNmxiaWE0K3hZYW9TdXIyK3hzdGE2YlVX?=
 =?utf-8?B?cVhRSWcybm0rVTRqd09SNFEyVFZIcFhubUZoV3ZyNjJIK2tEbkc1enpmK3R4?=
 =?utf-8?B?a2t3TVd5RHlYcmk1dFFlWkFvTHJjYlpWQUcyZkxpSmdLRmxVVyt2OXdRWnhM?=
 =?utf-8?B?NExsdnE0U08yZGhobnJIWDMyUGxvQWczeWhhZHlITG5zZ3RTVWhIbmM1R3Fk?=
 =?utf-8?B?SC9ZNVMzWUVHNEJzRnV6ZTNiY3ovQ3h2ODh3bWIvM3pKd3BNL0FVRTBLbDV2?=
 =?utf-8?B?bUJ6WHNaUzQrQUZsWDJSUHY2SGpqdXF1OXVHOThrQ3FZNE0rZkVWK0FxUTBD?=
 =?utf-8?B?WGlmSDJ1dDQ3UlprOVErWGRaR0w3VlA4YmtBMVBtL1lzL0I1RUNIWDRrUjR6?=
 =?utf-8?B?ZDlNVlZacGpUTnk0bnhxcnovUTR2MU9kS3p2R0duRmRGcFBxSmsvdmlsVUd3?=
 =?utf-8?B?RVYwZnJJOGdzSDdsRzQvWEcrRGIxNlZ5Z1RqdEdieGRKK0ZNOXVYRVFGZlZt?=
 =?utf-8?B?VE9WWEZGMlZDZlhrKzE3ZlltN1hSZS9yWEdsbXA1a0prd3pwaWY2ZytLRDJp?=
 =?utf-8?B?b05CeEQyMnJMTWFqSnVtd0VGb0JvTk5OeTdGWFhxTW5ibTZwZlNzNG9GeVl0?=
 =?utf-8?B?UkZ1cGZNNGJKY0NpNWhXNmhOdDVOZFJBN2REN251cjhrUnF0L2pkaG1DUThE?=
 =?utf-8?B?aHNJWkVvVDlpVmltZkxoK2o4eU5XOGlqUCtuSEl4ZEhsU2loQ0dWalFVUG15?=
 =?utf-8?B?Y3JDSUlBYVplZXBLeE1ONDdMZEZQQUhWR2pjVU9BRnNNUzdGM2NsQ0dNNDU2?=
 =?utf-8?Q?OvzF02J1mGv2j88ymY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGJSSnIwSjhtWXVMMy9GbWpCWW9qcG1Nd3VyU1p5d1JYa3ZiSk51ZW9OVzZq?=
 =?utf-8?B?WGRYTVJPazdrbEpsM2pjd3F0Q1hCSVM3SFRIVmxVUEhrZTFIMWpLTTRYVWVV?=
 =?utf-8?B?NW4wUUlFUFdHZDVuek5XTmFSM1FVK1Y4V25FaWliUE5GZUxLNWVoeE9rejJk?=
 =?utf-8?B?QXlGaDlUOERkQVhLeDhmdmx6RzlhUkt6OWNtMjM1NFV5Y1l0WTVqZ0owK05G?=
 =?utf-8?B?NnBwWkEyYmpmcFF2b01oT0s0d3RHbnhCS3lJWWJtcjVxaUNOUE9qYlN1QmQ0?=
 =?utf-8?B?S3ByVjROUERuV0d6Uk8zZHJZMnNnL25KVkRvdHo1VnB3ZjFha2JUbjlmV3ZS?=
 =?utf-8?B?VFF0Q1Z5Q0U5SWdJM0dqWUJwK2JBeEY0ZmQvYVNMVzJvdVhsR1gyRk5iSHRm?=
 =?utf-8?B?QWZNUjVmQzRIRTdFWVoxRkhtczgzMTRMSUptTGUwaC82UExiSk5aUzZWbWFn?=
 =?utf-8?B?c3NpUmdkZ2RpQkJ4Vkh1bDd2V0dLK2pJTTg0enNLWEw0dktBVUFMNjVmaUNP?=
 =?utf-8?B?WEZUQ3FyVU1CSnprSFk0K3VEL2luK1JUOFQyYnVPUHRQeXdHeGFDdG1wMWF5?=
 =?utf-8?B?aEZvK1YydUJ2Q1hBcWxZZllaVTJibFpvVFhZSG8yclRaZ3c1RGFTNHAwMlR4?=
 =?utf-8?B?bS9oaEp6ZEY4aW93c3V4NHR0MHl5dmM0ejBTNXJFMEdCcVlGUjFWSVpGRGdn?=
 =?utf-8?B?OUdkRGlZc0VGRnZOdDBnMExmWHJDUXVXaXNBOFcvb3RTQ01mVE40R3lPL1RE?=
 =?utf-8?B?LzV6UDNsd1VVYXhSWFNEdE1aSTJnZ1JwVnhnTnZQdm9JRkpVdkdqcTMzUUdC?=
 =?utf-8?B?SDc1NTBqbGlEdmpCSytqRmx2SDlac2UwNkpWby9nZU9nRWs4NkY4MjhpMnJu?=
 =?utf-8?B?QkxPSDdReTY3MU1QL1JyVUxMbVpFRDJ3OUhHWUd6NEJSS0lpVkxSa1NsWE94?=
 =?utf-8?B?NHR3K1VacTc5dWJ2c2ZWeGtkQlRJREw1VHUycmpGWHkwSDNvdHVHU3I2L2s3?=
 =?utf-8?B?MG56STh6YXJ1azFHdUg4VjQvQkZkWGRZUE5yS3o1MzJ6Mm5CNklFSVdlNjJ3?=
 =?utf-8?B?Y1VMYUpTQ25PM2RrQW9FTkpuNmlGeVlDVDdVVnFIY1ZONFc3REZ6VFNNdVJB?=
 =?utf-8?B?dWZnV01GL0xPRXoyVmZJM0V6dDdLR3RIUXNuMXJXSXFMQ2krYXVjNFEyWEMv?=
 =?utf-8?B?SFViV3oyT3RZRi9IaGhyUDhubEwvV1Q1d0JVOGRUMU1hN1I0NnlhL043cklW?=
 =?utf-8?B?SU54bmMvWjQvdHRrMVpkbVdOdm1vRzE4c0NRM2xSU200MENQNDNwL3RxSmM3?=
 =?utf-8?B?Rnp2cVduZDJhZkFPQXpYcDJadzJ5enRNeUFGZU4xNmtqRnpUZUZGNERZQ3Zk?=
 =?utf-8?B?UUJDcktMRU5oQWs4U0xRZVl5U1k3V3Z0cmt6NTJzdXFBZGNOQWpPYk1zL1l3?=
 =?utf-8?B?dEVJRy9xa3NlZU9IcFJQZzM5MDNiV3A4WmhUdWQwRjlSNFNzSkVEcVl3eUI3?=
 =?utf-8?B?ODVWK1ZxbXREa2c1di9JekV4T0VOWlBDcUIyNUtSK0RxdmtHSEVBUEg3dEw0?=
 =?utf-8?B?N09TRHZMMEM3SFdlb2JLM3lVMjR4WVpWdkFTRlpYQnVPcWp1dmVYa1pXckls?=
 =?utf-8?B?aVdRMDNUSkIxMEJ6SXZDaXJDWlpaOC8wN2JKUk9tYkFpRDdjT3JmMkp0VUZV?=
 =?utf-8?B?UEorSk9uMmphM0Z4QVJzRWlKYUZVNjlDNG1NM29KTU9WdWNUdDA0cGdabkh6?=
 =?utf-8?B?Wm1yMUhrVjdyZWphMzFWSHVQRFZnVlg2NmloUXBJem1QeFBJVWxyMVNEY3Z3?=
 =?utf-8?B?THRmdVJCZDZPSEExRVBMVjdaL2dzMnRlN09FSVhtL1IwT0psL2doUTFlYzBp?=
 =?utf-8?B?c0x5dHR2dDU5UG5HVFMyd1JFSjI5bkx5TEhSZzJ5M0I0bFRLY1RsZmJ2STFl?=
 =?utf-8?B?OUZLV1lSaklNaFM1RUR0dFR4bVlLa3Q1U0F4WGM2YThYbTY5enUzUHF1cTJq?=
 =?utf-8?B?THlBVkxMQnExRHZWczlvbTNRNjRpNk0vZDhEbXEyM2NIeEJhTjI0NVJlTFpl?=
 =?utf-8?B?S0dwNVQ1aHZON0RicmxaZGhDOVBpTDJNaVkySDl2UTIrSDhDRHN3c0RlTzMv?=
 =?utf-8?Q?E/2FrVBnrqhSab7iBB9VfHzFM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc14ef1-d908-4a12-172b-08dcc3070a52
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 00:03:38.6470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XXwnr4nfnSz4S2L1XO+hFHjkUmJWVazlEGHRfCLU/NdARECh9YD2/pxWYmGGumDZ/kypbITl4EZhzLrgkha0+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7426
X-OriginatorOrg: intel.com



On 21/08/2024 11:27 pm, Yongqiang Liu wrote:
> The fixed size temporary variables vmcb_control_area and vmcb_save_area
> allocated in svm_set_nested_state() are released when the function exits.
> Meanwhile, svm_set_nested_state() also have vcpu mutex held to avoid
> massive concurrency allocation, so we don't need to set GFP_KERNEL_ACCOUNT.

Hi Sean/Paolo,

Seems more patches are popping up regarding to whether to use _ACCOUNT 
for temporary memory allocation.  Could we have a definitive guide on this?

As you know, one similar patch was merged and now is in upstream:

   dd103407ca315 ("KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for 
temporary variables")

Also see:

https://lore.kernel.org/kvm/20240715101224.90958-1-kai.huang@intel.com/T/

> 
> Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
> ---
>   arch/x86/kvm/svm/nested.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 6f704c1037e5..d5314cb7dff4 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1693,8 +1693,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   		return -EINVAL;
>   
>   	ret  = -ENOMEM;
> -	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL_ACCOUNT);
> -	save = kzalloc(sizeof(*save), GFP_KERNEL_ACCOUNT);
> +	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL);
> +	save = kzalloc(sizeof(*save), GFP_KERNEL);
>   	if (!ctl || !save)
>   		goto out_free;
>   

