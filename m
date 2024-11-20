Return-Path: <kvm+bounces-32221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35BA29D4496
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 00:38:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72947B21B19
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 23:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44DD71C4A24;
	Wed, 20 Nov 2024 23:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JoXALXOC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199EE13BAF1;
	Wed, 20 Nov 2024 23:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145905; cv=fail; b=rjkmleAYHrdpjUsJ0q530oNmdFkuk0pT8uYGzIvHkOxyfgR9V+tytDfmWI9Zc/R3CsL923UpO/MzDE4fjtRQM44bhE0Yv5gF1wc/UTlUTLWmjnV+Heo9J6LvPGVB77/AMPo++EXf86JhSRvHBgcmNbaunpP3fO6yfNyqRD4ODYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145905; c=relaxed/simple;
	bh=kt7PG5/5BHrrLVYMXbUwzflChuVo538o4oOAHz4vw4c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Sjk/c+Wqt2UU9YhOFJwtKPUTVtQQ1FU//ZBvZT22BrCzNQpD6K9FzQ0SQDguCkCzGhursPF7mNSzWOJu1ty+PTR68YHI1u5V1ucEWm00ZOKdXjEszOdn5eYStF1N+lb21RSOTTHbIUByZeZGdOUySuP7LVzl7VkcFi8mXTpTano=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JoXALXOC; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732145904; x=1763681904;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kt7PG5/5BHrrLVYMXbUwzflChuVo538o4oOAHz4vw4c=;
  b=JoXALXOCqBZIf9u8aPnZS+nO0mIJpLXKN7iwvhlqOC+rGQOn7iSOUgee
   nN1wKpOHtCuw5StJGsTZ+Cyon2rLkKeMwvymS15c5OHKMtM2osX2AeHoB
   CAQGxXk/0nRiA2E6YIYajUX854tqDNUHO+4qDxQcf47wNanmLADUd8PHw
   VyewYtah8qz9JhiTqXqaSmsAN49YZGC/a+c4jrEzjwHpl27Jy8BYMJ62W
   CyaCxYKpP21LK2eTsy7rKh2ZvgCEBpvg26Kaa6NDHfZAZhdqUIzjtv3Pu
   3b7gsXIwQ9UHEkQ84J25N+RW06FjKGBI/0qNJnuVKrbm48B4XTVt/MTKr
   g==;
X-CSE-ConnectionGUID: 0/84146eTVCp9d7jVYcuMg==
X-CSE-MsgGUID: +fXSiP8sSjSGOB3RFZE4pA==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="42741505"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="42741505"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 15:38:23 -0800
X-CSE-ConnectionGUID: mSiWIOokRheedr1FEboAxw==
X-CSE-MsgGUID: gc66q0BDS4CROPhaHto5gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="90469204"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Nov 2024 15:38:23 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 20 Nov 2024 15:38:22 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 20 Nov 2024 15:38:22 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 20 Nov 2024 15:38:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JqtWsbDbxm0RXFZzj0M1U75v5Wvzj1MPaYeuA3z19HKD6Q2vIpKyFTulBUMLRHbadspxKlsQDbpGvxIMxCC92B+UxaYvMl1oCUHsNygkBiXJEzGeWUd4/TY6ecPf5ope+/4wijUJlBpRBj8P8Fll8ADBk1cKZFSUdbacKKzemOpLW2XUXbqv3JmoRvii2E1C3pKEwxwr2lDylEsJqhXLCbQ3PxW5nl5bRLsjxOjphKiVByXZQIW2okU6FZByJkcTR1IA6HJvCNi2EsZZBzcsDBtlpEBvshtXG17ncOymI0RlAtjok6/LE0AI6U50W5wiRsRsK/+LwPJu5e1HjuaAtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ym4iZjkjQpn77na9+tby3E6p5k9c1HKBMuiHYZ7/W3c=;
 b=bWyNaPCmQq113deqYUexVjcehChhquCoJdW/KVNqvJ6jOxXvYdrZBW+dsAmNFl2goITG2hUT+EpqqUPqBCeUwnat+ezIZh8MBTYIcmSzQYP0i0XNLu+QwYIzeC0c4TOdkNKmcbkH0sIYyu7TNdDs9hgpTPqPfzgPxcVxo5lAFrXEB6ZJswtshi9tRNX7Zfg86q5j+/N1/HP8XYUmEt0svgVnV5ULIvaMnhY+Vge8xnfcihNXtfCcGZjLaf7M2+wPARkytAtyqLxrm7E8G7bC9EsKO9vuMICEe4FkR5IW9Rda3XKq4WYsxNJEaS7vhFrmcsJsAbizgWj2Y/xD6QNgIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Wed, 20 Nov
 2024 23:38:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8182.014; Wed, 20 Nov 2024
 23:38:19 +0000
Message-ID: <eb37d3fc-7d19-4dc2-bac4-6e0cb5c8aa1e@intel.com>
Date: Thu, 21 Nov 2024 07:38:06 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] KVM: VMX: Initialize TDX during KVM module load
To: Chao Gao <chao.gao@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<reinette.chatre@intel.com>, <binbin.wu@linux.intel.com>,
	<xiaoyao.li@intel.com>, <yan.y.zhao@intel.com>, <adrian.hunter@intel.com>,
	<tony.lindgren@intel.com>, <kristen@linux.intel.com>,
	<linux-kernel@vger.kernel.org>
References: <cover.1731664295.git.kai.huang@intel.com>
 <162f9dee05c729203b9ad6688db1ca2960b4b502.1731664295.git.kai.huang@intel.com>
 <ZzrdL5iSu7/DNoBG@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZzrdL5iSu7/DNoBG@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::10) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA3PR11MB8118:EE_
X-MS-Office365-Filtering-Correlation-Id: bb88f082-b9d7-4fbf-c9dc-08dd09bc6993
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cys0TzFWME5CQ0gzb2lIZXluU2ROdmRvVEZnMkNqYVJHbEZpZCs5blF3bmRH?=
 =?utf-8?B?aGhPcVdJZzdCcFEvaVI3My9hMFVoZmNFZGxVRTZlZ0hhTWZCb3RuZlBaRGFi?=
 =?utf-8?B?QjM2KzRpVHo5ZGNxNmJyeEwxWVh5RWVwYXMyREltRHQrVk5nVWRpb1k4dmwr?=
 =?utf-8?B?cXVXVHJNTkxROFZSbHNUcmlybVlFc01YK2tSTFc3dWVNQUNxR1JqeEZMcERP?=
 =?utf-8?B?VzUxMlpuSUlPSUhidG1pSVlWZXZEOU5OeGNKV2tDcUdoclhvS00zYzlOenlp?=
 =?utf-8?B?cWtRcnVRRU9RU2ZacDlGS1hvRW51L3ZMRVFFalNVelVtZFBOWHdwNklWQ1dK?=
 =?utf-8?B?VkQrWG1xMC9YZDJjYkg3TkxiNmt1V3ZMenEvVThYL1cvRFdBV1BhU0xpYStv?=
 =?utf-8?B?WEd6NHlzdmZFekl4d2o3cllNbGE5SzN2dWNFM1FLUDRnTXcrWDRMOWpTRUR4?=
 =?utf-8?B?K29JZFl0ZXFJelhFdUc5TU15OEROeFI5YkR6U3U0VGpYOUdCUjd3S1d6clNE?=
 =?utf-8?B?OWdBWnJYTzhiT0NoTk1oOG9XZDYxTHpzWVFuVE12b3kzVEJYZEVnL0pOeDZM?=
 =?utf-8?B?MGRYNkxXZ1BuY3Mva0V5b0FzU0NZRG5YeHdET0V1WjUwNnpaVzdFVXN5bGRG?=
 =?utf-8?B?MTVQcVRoVDFRR2hOZWE0anhXQ2pCc2VaekhDQTZ2S056VEkrS0tSY0dkazVi?=
 =?utf-8?B?VXFsVHhWSEVkUnFBMGYxTERWUC92MEtIbXpSamJQZlUyNjNNY1lVR3BtQlpH?=
 =?utf-8?B?WllIcHpadGp6c2I3SVBUTHFZYWplT2d6TlRaVnNsRzRRNXFtSGFuTjVTOTlq?=
 =?utf-8?B?QjZZSTJlcVY0Q3BSM3Ric0s4QXcwM0JMRzF4VGQ5WHlpYU1CQTliMXludWNn?=
 =?utf-8?B?OHNKMTVrTWtCWitQSDNnT3lpRmhLY0ZUWTVBWThKRHZHL2xtRlZIdWpnS1E4?=
 =?utf-8?B?UTFaaU0vdDFDd0RiUmJVbVpCZmxOUVhDWWt1L1dOTUMrRkVhcVcxWDd5VEhj?=
 =?utf-8?B?RzlZMk9vQUUwRFd2R0h5bnMyaEN3WWNRNW1qZVJISnpvWkwwSzVNMjFBRFJC?=
 =?utf-8?B?dGFHTCtYN3g1eHUrWXhqeDg1NkEvZjMvZFRHN0dpWlhZRmZvSklhNWpnenN5?=
 =?utf-8?B?TmJOUkJnQ1p1R2NJdWFObkR3V2c0elFNNGN0V3pJMUlYZjVKWS9sV2pVZWFX?=
 =?utf-8?B?RnVGcERsd0ZicjNiZFNpNU1nUWZsOTV4TldiVkxoeFhZaThjMlNuQmx2ckgv?=
 =?utf-8?B?SnB6Qi9iL0xFZlVJc0JDV2drZTZRdERtVEEza1JJOHVnd2dYbXBwUFIrRWQy?=
 =?utf-8?B?dlZYMjhSQzdJSXQ5SE9US3FXM0tmNGxwM1luM2o1alZsdXJMOE5XUkpWQ09V?=
 =?utf-8?B?SUtkcDFSOUVETWZVbnRha21VODhMVlAzYjE0NDJUWjNONU5VY2dYU1FuT1d0?=
 =?utf-8?B?cWlYZXpuMjFrTEFkeUVOSTJldWZ6cFZMNVFrMjJ2SUw0cU9hcmZONmhGUFgv?=
 =?utf-8?B?ZVp4ZndBRzJMZVF1d1hYVDkwaFdWbHhndU1SaGxVQ0VCcGExbnJNTHJ2MmxZ?=
 =?utf-8?B?TTM4Qk9yVk5jMlJkUWFoZTZ4bWNReUJLaTJHT2ZSZFprQnJEVXlsWFRtRnBD?=
 =?utf-8?B?SWpTL013cnhCMHBhMnJHRkNma3JwU3dkQmZvK3c0RkhnMk5JS2xtYXRlZm9t?=
 =?utf-8?B?UE1iaW92eFdEblBMZjFXWHBMREptTExBWldpelBVWWUyY2lHbGZGQmZBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDRVWFltYm1XVm1zSER4TnRKMFFESlhpdnYvL215N3FpcHNnVGpTQUdjS01y?=
 =?utf-8?B?OEFMU3B4VFZKd1FGQVE0Q2JVUHIrakl2eVE2Uk9pSmlMQTlLYmU1N2dWZXEz?=
 =?utf-8?B?cXBJbkFmN1J3R2E3SHVhKzdvYmgrRitUTUhPWWhRTmdsRXJmZGtXVUU4cktL?=
 =?utf-8?B?Q3Z2RnJXbFRuOG9jVHE3cWU5U2hNU09sWmJMVGFmMnA1a1lZR2ZTTEMrN0NB?=
 =?utf-8?B?SC9FYmhzeWFoZ1B5ajdrWFNaYWlyaHB1a3UvYXZBaVJXWitITENtZzkzK0Fo?=
 =?utf-8?B?RGVWYStvQk9nYWlYbG1TOVdtVHVCaDZTTGJhU1BLbm9WL3hJR1JHMWJLb0l5?=
 =?utf-8?B?UW04VzArd0VBckl2UkNHTk1uNStmNXI2d2ZDVHVkVkx4NHJXSVpKQmJKNmFC?=
 =?utf-8?B?RVVWYmNnL3pEN1d3dlFEN0EyZStDWGg1czAyYzRld1g2YXBrd2NEM3J5RGRq?=
 =?utf-8?B?SmxWNjlHZE5hUnNVNEs2MXVKRWxlUDEraGcrdGtSc3h4ZzJvN3N0S3VMYUtn?=
 =?utf-8?B?TC9IbzVlKysvZE0rd1JCZFJyVmZHcG9DZkhpSUhQWkREQTFQM3RHQWYxTWRT?=
 =?utf-8?B?Q3MvNi9OazhFR1dBY25MVVFkRU1scDEvMm5tb2FkanVFejdiTlRHOWplTVNF?=
 =?utf-8?B?MnZ3TUJUSjQrT1h0MXlpRXZBZlVjSnRCeHB6MXhUN21ER0hYSVU1Q25hQlhL?=
 =?utf-8?B?TG1TbTNmYmlROWVqaTJncHF6bHVWdG1XSmZINm5WeEJ2SWMxUzcwTWJ0eTV6?=
 =?utf-8?B?L0IvZzBZUWJJdGw2alFVUEY0OGVYTmwvWEo5R3FDcEk3eTc4NWhnNm5UaDEx?=
 =?utf-8?B?OXNKOWkvaUFOUDhWek9TeU9uNDN5QlhWc081a2cxR3dSaGxjM3p4S3hOMUZQ?=
 =?utf-8?B?L2xXS0NuejMrMUY1UEpJU1VPQ3pkMk1VU0h5L1o4amM4TENXeWFiWElnZWNK?=
 =?utf-8?B?Y3NNZk54eXRVT3AzOW9meHd3YnVDT0RFWkxtYXo1LzJSRlVManRaZlJQcGNO?=
 =?utf-8?B?M3pYYXlhdi9OSGRCcmR4Sll0VDF5NkRHSGJtLzBXODRiamk1akM4Mllkbldy?=
 =?utf-8?B?cHJQYlJFTEM1YTFNS2hOWCtoYmtzZTZhYVRVbVFCTmRVNkVTcldhdjNPWHFE?=
 =?utf-8?B?OXBZZ0RXM1BtSlpnUjhsbzRQNDZKczdSMS9tOHd1dC9ZOUdyUENUTloyd091?=
 =?utf-8?B?c25BMjBMSUg5bGJYdkhITmg3U1gxMlF0N201SkxiemhaVGg4bUNmUlllOHFl?=
 =?utf-8?B?TjJPckUrSHFiOEcvYTF0dGVmRythSlBjR0NGRWlQZ2xaamt0b3VETmtvaTRj?=
 =?utf-8?B?MXBhZThxNUdabVVoQ0VVQ1pmbUlXZTJOcmlTN2ZqcWU4TW5QTC9hMjYwREtm?=
 =?utf-8?B?YmJIYm54VmJqeVFhVWM1aWEyRExqeThtekczOFhDZitibjdSS3ZNa3pnM0Zw?=
 =?utf-8?B?Y1BFOGNQb0Z2N0ovNTQxcEk5blBNV2diTHJKd0NCdUl0dWJHVEM2dWhZWkV5?=
 =?utf-8?B?Uk1ITVBwbnBYWjhwTnU3a3dZaGhUVHFMVEFJZUt3M2k0OUtzaHNBTlBmOGFa?=
 =?utf-8?B?c1RSNW11aDh1TGJ4aGlRaUhXSU9IbFd5em9RSlBrU25KeUdhQ1R0WDNrQ1RP?=
 =?utf-8?B?OHNjbG1ERmpjeG53VytrbWtPcHFTajVGSTJRUGZCUW94UDArTHZ0cnRHTktB?=
 =?utf-8?B?SWZDVjZvbUMwR1N6eXhGN1M3NENMOUVWRjVFRGE2WFNyUFllS2M5OWQyQkJi?=
 =?utf-8?B?dFJkWXRkeUdMbm5TY0xwY20zS1E0dTk1Y2dSN0g1eitJb0ZGY003YXpISlR4?=
 =?utf-8?B?ekRmdHhQSWU0N3ZHR01NMFlYalRLUmRORUxuZmNUOFRyVHdaQW5GMWVRMXZ6?=
 =?utf-8?B?YWdCemtNK2o1UWpUaUVqZ1d1eUdFaG1Fc3lQS2JhMWpQQkwrdVdtN1daNE1V?=
 =?utf-8?B?bjVYMkpZOWZSVWVrYlhNZG5nUytaRXQ4QkJuUVBoeG9xVDNQNDRtMXBETERs?=
 =?utf-8?B?L1Avd2VCalN1MTlWbjRsMFA3Ny9BU3EweE1tY2VGNVIyMWt3cEZWd2taaTJX?=
 =?utf-8?B?YWpvcGlDK3kwRmwreDduU0cyRytDTFlRQ0FZVXBGRGZjUkE4RjZEZFRtaWVN?=
 =?utf-8?Q?NDfls+EZtFnhAmwRlmUV8ozt6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb88f082-b9d7-4fbf-c9dc-08dd09bc6993
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 23:38:19.0161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lzanJiv5aI3pNH8stPx3N0pEYzCketUYGA9aSBMoChZmOZ5A5SaJPWwLYr6nT9SnNz00Odb359b8TawTENfLJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8118
X-OriginatorOrg: intel.com



On 18/11/2024 2:22 pm, Chao Gao wrote:
>> +static int tdx_online_cpu(unsigned int cpu)
>> +{
>> +	unsigned long flags;
>> +	int r;
>> +
>> +	/* Sanity check CPU is already in post-VMXON */
>> +	WARN_ON_ONCE(!(cr4_read_shadow() & X86_CR4_VMXE));
>> +
>> +	local_irq_save(flags);
>> +	r = tdx_cpu_enable();
>> +	local_irq_restore(flags);
> 
> The comment above tdx_cpu_enable() is outdated because now it may be called
> from CPU hotplug rather than IPI function calls only.
> 
> Can we relax the assertion lockdep_assert_irqs_disabled() in tdx_cpu_enable()?
> looks the requirement is just the enabling work won't be migrated and done to
> another CPU.

We can but I don't want to do it now.  We will need to revist both 
tdx_cpu_enable() and tdx_enable() when we move VMXON out of KVM anyway. 
I would like to focus on bringing KVM TDX support first and then to 
revisit them together at that timeframe.

> 
>> +
>> +	return r;
>> +}
>> +
>> +static void __do_tdx_cleanup(void)
>> +{
>> +	/*
>> +	 * Once TDX module is initialized, it cannot be disabled and
>> +	 * re-initialized again w/o runtime update (which isn't
>> +	 * supported by kernel).  Only need to remove the cpuhp here.
>> +	 * The TDX host core code tracks TDX status and can handle
>> +	 * 'multiple enabling' scenario.
>> +	 */
>> +	WARN_ON_ONCE(!tdx_cpuhp_state);
>> +	cpuhp_remove_state_nocalls(tdx_cpuhp_state);
> 
> ...
> 
>> +	tdx_cpuhp_state = 0;
>> +}
>> +
>> +static int __init __do_tdx_bringup(void)
>> +{
>> +	int r;
>> +
>> +	/*
>> +	 * TDX-specific cpuhp callback to call tdx_cpu_enable() on all
>> +	 * online CPUs before calling tdx_enable(), and on any new
>> +	 * going-online CPU to make sure it is ready for TDX guest.
>> +	 */
>> +	r = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
>> +					 "kvm/cpu/tdx:online",
>> +					 tdx_online_cpu, NULL);
>> +	if (r < 0)
>> +		return r;
>> +
>> +	tdx_cpuhp_state = r;
>> +
>> +	r = tdx_enable();
>> +	if (r)
>> +		__do_tdx_cleanup();
> 
> this calls cpuhp_remove_state_nocalls(), which acquires cpu locks again,
> causing a potential deadlock IIUC.

Dam.. I'll fix. Thanks for catching.

> 
>> +
>> +	return r;
>> +}
>> +
>> +static bool __init kvm_can_support_tdx(void)
> 
> I think "static __init bool" is the preferred order. see
> 
> https://www.kernel.org/doc/html/latest/process/coding-style.html#function-prototypes

I think you are right, but IIUC we'd better to change all the existing 
'static <ret_type> __init' to 'static __init <ret_type>' in KVM code. 
I'd rather to keep the current way to make them aligned and we can 
change them at once if needed in the future.

> 
>> +{
>> +	return cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM);
>> +}
>> +
>> +static int __init __tdx_bringup(void)
>> +{
>> +	int r;
>> +
>> +	/*
>> +	 * Enabling TDX requires enabling hardware virtualization first,
>> +	 * as making SEAMCALLs requires CPU being in post-VMXON state.
>> +	 */
>> +	r = kvm_enable_virtualization();
>> +	if (r)
>> +		return r;
>> +
>> +	cpus_read_lock();
>> +	r = __do_tdx_bringup();
>> +	cpus_read_unlock();
>> +
>> +	if (r)
>> +		goto tdx_bringup_err;
>> +
>> +	/*
>> +	 * Leave hardware virtualization enabled after TDX is enabled
>> +	 * successfully.  TDX CPU hotplug depends on this.
>> +	 */
> 
> Shouldn't we make enable_tdx dependent on enable_virt_at_load? Otherwise, if
> someone sets enable_tdx=1 and enable_virt_at_load=0, they will get hardware
> virtualization enabled at load time while enable_virt_at_load still shows 0.
> This behavior is a bit confusing to me.
> 
> I think a check against enable_virt_at_load in kvm_can_support_tdx() will work.
> 
> The call of kvm_enable_virtualization() here effectively moves
> kvm_init_virtualization() out of kvm_init() when enable_tdx=1. I wonder if it
> makes more sense to refactor out kvm_init_virtualization() for non-TDX cases
> as well, i.e.,
> 
>    vmx_init();
>    kvm_init_virtualization();
>    tdx_init();
>    kvm_init();
> 
> I'm not sure if this was ever discussed. To me, this approach is better because
> TDX code needn't handle virtualization enabling stuff. It can simply check that
> enable_virt_at_load=1, assume virtualization is enabled and needn't disable
> virtualization on errors.

I think this was briefly discussed here:

https://lore.kernel.org/all/ZrrFgBmoywk7eZYC@google.com/

The disadvantage of splitting out kvm_init_virtualization() is all other 
ARCHs (all non-TDX cases actually) will need to explicitly call 
kvm_init_virtualization() separately.

> 
> A bonus is that on non-TDX-capable systems, hardware virtualization won't be
> toggled twice at KVM load time for no good reason.

I am fine with either way.

Sean, do you have any comments?

