Return-Path: <kvm+bounces-43071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F18BA83B87
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:43:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1F873AE4BD
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5361E32C3;
	Thu, 10 Apr 2025 07:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OYm3gyW4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D0F42A89
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 07:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744270635; cv=fail; b=G8kClrkuyIapUKAJI8JlxidBYlPl/4I7P3b9hnUu0+7UUjAlPsnZXbNWNrEyLhdQ3ft/l6Xi9el7m6x3jlJYDkZFTsRSVAk9vgu5nMC7b4GCCX4T7ANeUJ88UOCos5xrXtf0XHsXgmqq+07UHujln9DAAAFBPbWERh2Ck02+3+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744270635; c=relaxed/simple;
	bh=QZQVYMmQSe9665jQKZZdaGKI9TUwLxGTxFZ1IJIyXdU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MzV57C3E0UG+djVWV7NzGKMLnsL0XT7wJugXytN6MO2yO9qG3FxZVmGZR+WQnxPtAFBBvJ2OKewjN5yQ98Pqx47fiALS+W5P7JJadmxbAEHEWGJy/CafRAG6M/sbnbWFMlAtQHwMV/lST7hVvf7Mgk15wo7aREVOeqr2rewU0b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OYm3gyW4; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744270634; x=1775806634;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QZQVYMmQSe9665jQKZZdaGKI9TUwLxGTxFZ1IJIyXdU=;
  b=OYm3gyW4vtpzniAQSYTo9aXWI8+/TiR50KMKr7/7eJhqWwlV0uDURHQt
   S32IubtEYVHR6w3qpm/dBj7ZWAQpuZuZl5SaXsSl1m+YOGKOLCPr+5gBH
   s497PZoaXFUo1RG8FGQN+Pw2JL4RZF9hjfhJc8/AnYtaOnnywZM+UqCSW
   4fCWBiQmUU8pvvIoqkAuWT5W9toCy5F8J8657JNoeEjm2EswFiaWfqW/6
   5iTJs50WEsi/Qu9oJj27m1MBiAGIUBJUycXzxLpQV2gzOLfRqjPq//OiS
   Ii9OI3fJ49zpI6z7jRg7D8Lx6LWETQDf74+zvgcurb9jENcebWk/rtnls
   A==;
X-CSE-ConnectionGUID: H1QCQGKcRQesaaPT9FzrZw==
X-CSE-MsgGUID: qDu4l7OeR3an0/KCSW52Kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="49615485"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="49615485"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:37:13 -0700
X-CSE-ConnectionGUID: rrzvwg5FQumo+1Zv1ovObg==
X-CSE-MsgGUID: cv8Jx4jiTEu6ByCifRcMEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="159805678"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:37:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 00:37:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 10 Apr 2025 00:37:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 10 Apr 2025 00:37:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DpBdnJ5WQuW3HnHbJhgWJe8EEyfVj4u5s0PF1dfiOXQ8pD2Sf6KO2/ggyxAIFqYTLSNPJv/mPaMofeAH7HRJ6qc7xrnRLx3WZMe4ygJkqpQXdcgRibCl1wAp8E+5T63F7YislbTKxmtY2Ma3OAo/WmUAejQ5wc4et/f/lUVrcMR1t/m/OTSOhUcGH9URJpS2cBj/S8agzPLZSFYPA09QfqjUPBdVudKavuXFMs0BBrnrkx3q0cI/02c6Tx7/rGL+JQ1+BgPa43Hi1Ax5rMpPC+hdDdKnBowcGBOb67/SINW3cJ7eLYZgbITALBbiohYtPqY8XN2NbvJEwYurDp3iwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZMw5ICrfJDUw0zvvuni1IeA95nzq7mTbt25MT9RtTE=;
 b=mSZ5ToyKN4FEisaUEkpmGpJgeqUpHMUPay1TrtGoEaz7COfm1mRsCwxYl0mi0BAmfLNwQFYok8sO2ZAmdy9G4Rj+KGypMNcBEB2Oasn2pFCGb8SwUy1IFrwn+IOXdd7feHE3EgpbiMAVpbSIo8GxFfiigYNCwn/cG7baxRFzHbo0oM4FZXCnnsTV3KLjJq0rLm0xWTUeZcUP2RmDDzf+WUAJgf8SqCvkrazTWvxhspd6GW86TRWKTG9Ke6vLu6SzCg5J5sb5RvPF/dh4mwjMUJvEPwx+x2imsxdMFF/XnOfXd/VB9F+uk5i3viJXG0VRH16BpKanhIyDhD++RF0wGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS0PR11MB7192.namprd11.prod.outlook.com (2603:10b6:8:13a::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.22; Thu, 10 Apr 2025 07:37:09 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8632.021; Thu, 10 Apr 2025
 07:37:09 +0000
Message-ID: <2016d78b-79f9-4dec-9234-1bfcf378494a@intel.com>
Date: Thu, 10 Apr 2025 15:37:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/13] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBLock with guest_memfd
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-8-chenyi.qiang@intel.com>
 <9e20e8b0-20f9-4e6a-ac98-0e126b79b202@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <9e20e8b0-20f9-4e6a-ac98-0e126b79b202@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::6) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS0PR11MB7192:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ee69902-6f27-4351-4e3b-08dd78028059
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SENGbmNEZDFocFJVaFErNDUrUE40Z0FHQVZqZjZCL2YzUWxrNzJhcUpkUjhZ?=
 =?utf-8?B?SzI5MnY0UHJkSGRLbjBLbGVqZnducXlyQXBjU3N2SzczTmRKMUsyT0ZxM1RG?=
 =?utf-8?B?c0k3UDAvdk5FSmVpOW1QZ0FwQmhOMXhUNFFKUVVUL2dEcjFxaTNaeW9kVU9p?=
 =?utf-8?B?ckI5S2xBakdITHNKOFVaLzBpUmFQN2VkT2pXWmpmenJTMjZGdDZRK3BJUkxo?=
 =?utf-8?B?aVJLUmdhNGRpMWNicDRPOGoxUXA5Z1pSY2lxRmFsYjh0M251bnBNL3ppTzUx?=
 =?utf-8?B?SHR6Z3pKMFQ3MGZsTlh4V3BKNzBCeDNxV0V6YVVxMitVWFV0dFZ0dzZML1Mr?=
 =?utf-8?B?UmRNWE55R0hrcWxyblU1UzBrS3JRU3RrL2VBYWtyeG5mOTVHaFVyMHpGV1NN?=
 =?utf-8?B?Skl5Yit1YUN2QXBQdlpsK1R1cUhmejVRWXhGay85SGdQZGpuV0tRVFEzci9o?=
 =?utf-8?B?ZzlReE4xSE1iSzc4UFNzQmtqSlhRaGRYczZHZmRDWUtuRjNrY0EybG1NUHdw?=
 =?utf-8?B?bXJ0cEQwTUZEeUttbGdjS05KakJpNCtDWmhLYnd1ditzZlU5QklLbktJSnVZ?=
 =?utf-8?B?NUNJMExjdkgvLzZaUXAvaDlKMkhyMWJTNjQyRkV2cEJ2Mzg2MXYyTlRNdUtn?=
 =?utf-8?B?dDE3NnJiY2RkMTRVQ1BQNHhjNDBtcGJLWjZVd2IrUGYzNXg1eXdkQjhZSlAx?=
 =?utf-8?B?MjI4d1dlUURib3l2My9MNUkvYW9LdmV5R09YMURzS2hUblZlNjFXQ096dTBD?=
 =?utf-8?B?K25iekw3aENFMlU1L3BoaGtKVHJxN0NHcmdkTFhuRFUzZzZqd2JLeWhJNjlW?=
 =?utf-8?B?NElxZFlRUFpGcHJUMXVyUlBrajNoU3NDWjl2MEtWSC9ZaTNCUWxFeXRSQ2NM?=
 =?utf-8?B?eXJqMWVwL1JGSjdzVXAwSzhaOVZkbnAxRnYwN3RQOGpRcVdXTGZtNUtJWlkr?=
 =?utf-8?B?bEpUUGZIbm85QTYxbzl5cU1lcHpCWkdIVXptS0IxQXRmQ0htL3dUWXl6dlpk?=
 =?utf-8?B?M3luQ2h0MzVwMXZCM0VDV0ZidS90VnZ2TnRINmJqalFYc2dxZ0J6bUhneWl1?=
 =?utf-8?B?OHNuUkdZYlhWUlBEZnRrNnNWczRKR3RhalIzbmFKcEFvQTlFTTBoUFNJWFhQ?=
 =?utf-8?B?SEhQblVXdzNXRWluSXRXWXlPOWFiMkdqOXRnWGdScUNrc1ROUzZLUFhMWEp6?=
 =?utf-8?B?S3ZjcWJ1RGlVenF0aDg1SWN6K3ZHaTc0SXRZa3FNOHA3WkdxOGoyWms2SDdO?=
 =?utf-8?B?dHdEYkN3K2JpU01NRng4OXl5bnF2V1ljMURMVCtsODg2VHdpaTJqamcyUUpI?=
 =?utf-8?B?dUVna1hLSU40Y2lGTGU0RnZVS3IrZzlrQzVNUUgxajJ5S0xZWHRubnE4YURM?=
 =?utf-8?B?OVh3RlBPQkJURDBmaUl6RWFFWmd3SC80MDlxM3pXWFdaWHpPeUk1cEovbUZ1?=
 =?utf-8?B?bnFSekVqbVdyTWdaaUlDRlFIU1RCQ1NneWxjSUhjTkFqYjZldnEvWkRveWIz?=
 =?utf-8?B?NFlJWitOZWVVMEhabElIcjYwVWR6M0lLVytmWWtEeDY2YkNxVm1sUXpmcjJG?=
 =?utf-8?B?RGgwdm1ySFF5UWhINWg2enJ1S0dROGdwMDQ4YTN3bkxqM0tNQ041aUJ6L1Nu?=
 =?utf-8?B?VHFvUS8wcDFnZ3FrZVNucGNlZGNvc1MxSVR6UWUwWVd5dGxVRnpaYVVVdnNz?=
 =?utf-8?B?YnA0SGFzQVFMV1VRcTVoeWJQTGdQNitpZlRzZVVVSTg2emgzL2hMR1lUQXFN?=
 =?utf-8?B?YVAzSFk4azFuNXliVE1wU1FndGZuNVQ0M1ZaR3o1Z3c5KzY0UDZDZitranhB?=
 =?utf-8?B?WDEzOWVWakw0VmdoY0FPbFppNHc2dVJGOEw4OHJoMjlPQ1ZRQVcvZ1UzcWhr?=
 =?utf-8?Q?96GHHCmO9vvy/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzRHUmRkay85Q2ozTFU2Q3NHZGorVEtINHNFL2plY2t5UGxIZXFJUzF1ZEMr?=
 =?utf-8?B?RXI4NnlxUG5FVW84RFhEbnh0bnp0ekNuYnZQL2x6SjBJb2hmNkYzSjk3R0dr?=
 =?utf-8?B?TkZXNHlxMmR4bC81V2R4eUp1NVhpTWVjWmJXSzdOUEExZ3RLRVo3R0NxV0Y2?=
 =?utf-8?B?YzlFNGxIZGl0dVMyRzdiOFhvV042aDVpcHRXblNVcFZVRnhBZ1ZMaFdoMnlG?=
 =?utf-8?B?dGxURmt5eVdaT0ZuamxSRmNEN3RhbldwdDdmR2IvRjhyMk42aDJvR1gxQ2JN?=
 =?utf-8?B?SzdxZmlXQlZSUzFHS1ppcUt5cWlGUzBYaGFQZ2M0VmFTT0V0NTd2VThJVjVm?=
 =?utf-8?B?a0N2a0g0ZmVudTBoSjdMbHNYd2p1LzhBeVpJY004bFMvRlBzeW84aEZ5eVBq?=
 =?utf-8?B?b09HSWVwUjliTkwvRnVtZkgvSi9NMlBUQW53cm9VUE5CU0g4emt2TmtsL2RI?=
 =?utf-8?B?anhzcWlsYkliazdmOHRGdThtbmI4dWhkZWd2b1E0OGRHdmwvdFNGRjNhdlR6?=
 =?utf-8?B?bnpuUkw0WXdtMWl5dWlrbkFaYUVtak1Hb1h1OGVUWkdUVlZIYkRVaFN0bmNi?=
 =?utf-8?B?cFpBemNNaDEzMUhxQ1RLempjY3RTMHF5YWxsMmYwV0VGZWVaeGdZMHpzSDVt?=
 =?utf-8?B?RGl2RHg0bkhwclhkQWlFMTBZQ0V3ZThKa0JnUTVqdHNjdlo3dVZhcE5ZWkFl?=
 =?utf-8?B?VU5Ed2FERklSekg5Q2VXSlRDeUZYSTcrREc3WFNmejVXWWFFNTVESmh5WVA4?=
 =?utf-8?B?dHdnOXRVMTUxU1h6Y3NES2NaSmRtdllXRmZWUTF1M1BxTlVaN054UFltTHI5?=
 =?utf-8?B?MDc0L0dPTzU4Z3NhWDdiU1lOVG1EZCtnNm54YnVjSEdVemE1ZHdJMnhTZDIv?=
 =?utf-8?B?UXU5VkxKVzJvTXRPOFBqUUdyeUtxS2RuZG9iOUQwU1JJUGgzdHBMMDFVYUkz?=
 =?utf-8?B?T3FoSkp0NmNUaW1sTlhRM0ozcEtMNTF3OGFpcnJHdFJLTzBNWG1ZVmh5Tnow?=
 =?utf-8?B?VGxRZXB2ZWt3V1dEWXhENkFWdTZETFNCL1ZPdXNBZWE2RVB4cGRLRnkvZWNY?=
 =?utf-8?B?MDJqQ2J1QmxmSGlmTnl4UEtiMDFqWml2N3d3RGZFdG5hUDZwVVNFSHkvNnU2?=
 =?utf-8?B?MEQ1WFU2WVNSN3k5WHljVHppMnNxeGhteWhIYTNFajdYSjJ1OGdUeW9YaFk4?=
 =?utf-8?B?RHE3M3ZMOGxoa2dFaU9CaFFnVEk2c09ySjMzRnpQSWdOM3FuL014TlgwSTB6?=
 =?utf-8?B?YUx0WUJsalZ6Nk8vZDFnQk1QUGxFM2Y0LzBDTmUyaHJLTWhMS29vM2k3R080?=
 =?utf-8?B?MGpOazZTNEIvekdxbWFUVS9aMHJZUTVCbVVuV3k1Q283U3AyZVd5ZE9QNzJU?=
 =?utf-8?B?K01vdnFmMFpjeGNYOUtlWHp2UnJ1eXdFci84REp0cjVWdDBIUzk5ZGJ6eC81?=
 =?utf-8?B?TC93M2NQd08wV2tEbmN3NHNZcWprV1hNUHBUU0Z5cm9XZnFXTHhVdDZOU1c2?=
 =?utf-8?B?NWJINnlkSEhWbTlxeDhJYkdDUFdDdSsza0RmU0I3SWNhOGhoMmNiRmhmZklx?=
 =?utf-8?B?VUZ4TTM1NXdMSHdiYzlTRVJkWlpxbGU3ZTRoZXRJRzE4M1hiVDFINjJwTWkz?=
 =?utf-8?B?UmV4eXFFT3YwL3BSYS9PekZoSzV0YVkvKzhQNjl4TFd4aENmM0RmdU1Hemoz?=
 =?utf-8?B?cXFmOGtPOFZqSWhiTkdYTjkyTGVaSURZTWgzczAzOTlodllyM0h0ampjZEI5?=
 =?utf-8?B?YzVUTU1oaVNWK052aHdLZnhYMHB2bnQzcG00eTQzdUROYWNqM3l2YXoraHlR?=
 =?utf-8?B?YW1MejBscHlJdGhSeHJGakVvbDRpR2c0ZjFlYjlhayt0VVUzK01RQTZuWGtS?=
 =?utf-8?B?MVhWQkppK1RmOXdmeVMzVFNkNHBCVWIwN25VRkhPY1c4QVg4U1BDOUd6bjg5?=
 =?utf-8?B?anJDd2JUZ3ducWVxVXBGd0xnaE5RTWVVSlo3VlZzbDJnSWVKUWk0THhoWXlP?=
 =?utf-8?B?a2lsT0JVaFNWT3FHcUl0azZWY3FHbk0rMVFMY0tHVjJKdjZrbUEveGtJYUhY?=
 =?utf-8?B?THRGSFBNcHhzNDJlVkNLczFKVjE0b1phSDFmYllFMjV2VTFtNUFuaHNmOU0z?=
 =?utf-8?B?UUd3QVUrRXRJaEtPc1FmZ1QwQ0lkMlJwRUYyeVFrQ2VaVW5rU1Q1K3BWTWUx?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee69902-6f27-4351-4e3b-08dd78028059
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 07:37:09.7129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pk6MfOsxR6vmvRexRnhVyW8xFNUDFGM70UxdXCPf3z9pxLHCCR/jTMN01TtorGwqh+71XGbfRAJe204iZkE8MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7192
X-OriginatorOrg: intel.com



On 4/9/2025 5:57 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 7/4/25 17:49, Chenyi Qiang wrote:
>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>> discard") highlighted that subsystems like VFIO may disable RAM block
>> discard. However, guest_memfd relies on discard operations for page
>> conversion between private and shared memory, potentially leading to
>> stale IOMMU mapping issue when assigning hardware devices to
>> confidential VMs via shared memory. To address this, it is crucial to
>> ensure systems like VFIO refresh its IOMMU mappings.
>>
>> PrivateSharedManager is introduced to manage private and shared states in
>> confidential VMs, similar to RamDiscardManager, which supports
>> coordinated RAM discard in VFIO. Integrating PrivateSharedManager with
>> guest_memfd can facilitate the adjustment of VFIO mappings in response
>> to page conversion events.
>>
>> Since guest_memfd is not an object, it cannot directly implement the
>> PrivateSharedManager interface. Implementing it in HostMemoryBackend is
>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>> have a memory backend while others do not. 
> 
> HostMemoryBackend::mr::ram_block::guest_memfd?
> And there is HostMemoryBackendMemfd too.

HostMemoryBackend is the parent of HostMemoryBackendMemfd. It is also
possible to use HostMemoryBackendFile or HostMemoryBackendRAM.

> 
>> Notably, virtual BIOS
>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>> backend.
> 
> I thought private memory can be allocated from guest_memfd only. And it
> is still not clear if this BIOS memory can be discarded or not, does it
> change state during the VM lifetime?
> (sorry I keep asking but I do not remember definitive answer).

The BIOS region supports conversion as it is backed by guest_memfd. It
can change the state but it never does during VM lifetime.

> 
>> To manage RAMBlocks with guest_memfd, define a new object named
>> RamBlockAttribute to implement the RamDiscardManager interface. This
>> object stores guest_memfd information such as shared_bitmap, and handles
>> page conversion notification. The memory state is tracked at the host
>> page size granularity, as the minimum memory conversion size can be one
>> page per request. Additionally, VFIO expects the DMA mapping for a
>> specific iova to be mapped and unmapped with the same granularity.
>> Confidential VMs may perform partial conversions, such as conversions on
>> small regions within larger regions. To prevent invalid cases and until
>> cut_mapping operation support is available, all operations are performed
>> with 4K granularity.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v4:
>>      - Change the name from memory-attribute-manager to
>>        ram-block-attribute.
>>      - Implement the newly-introduced PrivateSharedManager instead of
>>        RamDiscardManager and change related commit message.
>>      - Define the new object in ramblock.h instead of adding a new file.
>>
>> Changes in v3:
>>      - Some rename (bitmap_size->shared_bitmap_size,
>>        first_one/zero_bit->first_bit, etc.)
>>      - Change shared_bitmap_size from uint32_t to unsigned
>>      - Return mgr->mr->ram_block->page_size in get_block_size()
>>      - Move set_ram_discard_manager() up to avoid a g_free() in failure
>>        case.
>>      - Add const for the memory_attribute_manager_get_block_size()
>>      - Unify the ReplayRamPopulate and ReplayRamDiscard and related
>>        callback.
>>
>> Changes in v2:
>>      - Rename the object name to MemoryAttributeManager
>>      - Rename the bitmap to shared_bitmap to make it more clear.
>>      - Remove block_size field and get it from a helper. In future, we
>>        can get the page_size from RAMBlock if necessary.
>>      - Remove the unncessary "struct" before GuestMemfdReplayData
>>      - Remove the unncessary g_free() for the bitmap
>>      - Add some error report when the callback failure for
>>        populated/discarded section.
>>      - Move the realize()/unrealize() definition to this patch.
>> ---
>>   include/exec/ramblock.h      |  24 +++
>>   system/meson.build           |   1 +
>>   system/ram-block-attribute.c | 282 +++++++++++++++++++++++++++++++++++
>>   3 files changed, 307 insertions(+)
>>   create mode 100644 system/ram-block-attribute.c
>>
>> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
>> index 0babd105c0..b8b5469db9 100644
>> --- a/include/exec/ramblock.h
>> +++ b/include/exec/ramblock.h
>> @@ -23,6 +23,10 @@
>>   #include "cpu-common.h"
>>   #include "qemu/rcu.h"
>>   #include "exec/ramlist.h"
>> +#include "system/hostmem.h"
>> +
>> +#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
>> +OBJECT_DECLARE_TYPE(RamBlockAttribute, RamBlockAttributeClass,
>> RAM_BLOCK_ATTRIBUTE)
>>     struct RAMBlock {
>>       struct rcu_head rcu;
>> @@ -90,5 +94,25 @@ struct RAMBlock {
>>        */
>>       ram_addr_t postcopy_length;
>>   };
>> +
>> +struct RamBlockAttribute {
>> +    Object parent;
>> +
>> +    MemoryRegion *mr;
>> +
>> +    /* 1-setting of the bit represents the memory is populated
>> (shared) */
> 
> It is either RamBlockShared, or it is a "generic" RamBlockAttribute
> implementing a bitmap with a bit per page and no special meaning
> (shared/private or discarded/populated). And if it is a generic
> RamBlockAttribute, then this hunk from 09/13 (which should be in this
> patch) should look like:
> 
> 
> --- a/include/exec/ramblock.h
> +++ b/include/exec/ramblock.h
> @@ -46,6 +46,7 @@ struct RAMBlock {
>      int fd;
>      uint64_t fd_offset;
>      int guest_memfd;
> +    RamBlockAttribute *ram_shared; // and not "ram_block_attribute"
> 
> Thanks,

I prefer generic RamBlockAttribute as we can extend to manage
private/shared/discarded states in the future if necessary. With the
same reason, I hope to keep the variable name of ram_block_attribute.

> 
> 
>> +    unsigned shared_bitmap_size;
>> +    unsigned long *shared_bitmap;
>> +
>> +    QLIST_HEAD(, PrivateSharedListener) psl_list;
>> +};
>> +
>> +struct RamBlockAttributeClass {
>> +    ObjectClass parent_class;
>> +};
>> +
>> +int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion
>> *mr);
>> +void ram_block_attribute_unrealize(RamBlockAttribute *attr);
>> +
>>   #endif
>>   #endif
>> diff --git a/system/meson.build b/system/meson.build
>> index 4952f4b2c7..50a5a64f1c 100644
>> --- a/system/meson.build
>> +++ b/system/meson.build
>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>     'dirtylimit.c',
>>     'dma-helpers.c',
>>     'globals.c',
>> +  'ram-block-attribute.c',
>>     'memory_mapping.c',
>>     'qdev-monitor.c',
>>     'qtest.c',
>> diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
>> new file mode 100644
>> index 0000000000..283c03b354
>> --- /dev/null
>> +++ b/system/ram-block-attribute.c
>> @@ -0,0 +1,282 @@
>> +/*
>> + * QEMU ram block attribute
>> + *
>> + * Copyright Intel
>> + *
>> + * Author:
>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>> later.
>> + * See the COPYING file in the top-level directory
>> + *
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "exec/ramblock.h"
>> +
>> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(RamBlockAttribute,
>> +                                   ram_block_attribute,
>> +                                   RAM_BLOCK_ATTRIBUTE,
>> +                                   OBJECT,
>> +                                   { TYPE_PRIVATE_SHARED_MANAGER },
>> +                                   { })
>> +
>> +static size_t ram_block_attribute_get_block_size(const
>> RamBlockAttribute *attr)
>> +{
>> +    /*
>> +     * Because page conversion could be manipulated in the size of at
>> least 4K or 4K aligned,
>> +     * Use the host page size as the granularity to track the memory
>> attribute.
>> +     */
>> +    g_assert(attr && attr->mr && attr->mr->ram_block);
>> +    g_assert(attr->mr->ram_block->page_size ==
>> qemu_real_host_page_size());
>> +    return attr->mr->ram_block->page_size;
>> +}
>> +
>> +
>> +static bool ram_block_attribute_psm_is_shared(const
>> GenericStateManager *gsm,
>> +                                              const
>> MemoryRegionSection *section)
>> +{
>> +    const RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
>> +    const int block_size = ram_block_attribute_get_block_size(attr);
>> +    uint64_t first_bit = section->offset_within_region / block_size;
>> +    uint64_t last_bit = first_bit + int128_get64(section->size) /
>> block_size - 1;
>> +    unsigned long first_discard_bit;
>> +
>> +    first_discard_bit = find_next_zero_bit(attr->shared_bitmap,
>> last_bit + 1, first_bit);
>> +    return first_discard_bit > last_bit;
>> +}
>> +
>> +typedef int (*ram_block_attribute_section_cb)(MemoryRegionSection *s,
>> void *arg);
>> +
>> +static int ram_block_attribute_notify_shared_cb(MemoryRegionSection
>> *section, void *arg)
>> +{
>> +    StateChangeListener *scl = arg;
>> +
>> +    return scl->notify_to_state_set(scl, section);
>> +}
>> +
>> +static int ram_block_attribute_notify_private_cb(MemoryRegionSection
>> *section, void *arg)
>> +{
>> +    StateChangeListener *scl = arg;
>> +
>> +    scl->notify_to_state_clear(scl, section);
>> +    return 0;
>> +}
>> +
>> +static int ram_block_attribute_for_each_shared_section(const
>> RamBlockAttribute *attr,
>> +                                                      
>> MemoryRegionSection *section,
>> +                                                       void *arg,
>> +                                                      
>> ram_block_attribute_section_cb cb)
>> +{
>> +    unsigned long first_bit, last_bit;
>> +    uint64_t offset, size;
>> +    const int block_size = ram_block_attribute_get_block_size(attr);
>> +    int ret = 0;
>> +
>> +    first_bit = section->offset_within_region / block_size;
>> +    first_bit = find_next_bit(attr->shared_bitmap, attr-
>> >shared_bitmap_size, first_bit);
>> +
>> +    while (first_bit < attr->shared_bitmap_size) {
>> +        MemoryRegionSection tmp = *section;
>> +
>> +        offset = first_bit * block_size;
>> +        last_bit = find_next_zero_bit(attr->shared_bitmap, attr-
>> >shared_bitmap_size,
>> +                                      first_bit + 1) - 1;
>> +        size = (last_bit - first_bit + 1) * block_size;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            break;
>> +        }
>> +
>> +        ret = cb(&tmp, arg);
>> +        if (ret) {
>> +            error_report("%s: Failed to notify RAM discard listener:
>> %s", __func__,
>> +                         strerror(-ret));
>> +            break;
>> +        }
>> +
>> +        first_bit = find_next_bit(attr->shared_bitmap, attr-
>> >shared_bitmap_size,
>> +                                  last_bit + 2);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int ram_block_attribute_for_each_private_section(const
>> RamBlockAttribute *attr,
>> +                                                       
>> MemoryRegionSection *section,
>> +                                                        void *arg,
>> +                                                       
>> ram_block_attribute_section_cb cb)
>> +{
>> +    unsigned long first_bit, last_bit;
>> +    uint64_t offset, size;
>> +    const int block_size = ram_block_attribute_get_block_size(attr);
>> +    int ret = 0;
>> +
>> +    first_bit = section->offset_within_region / block_size;
>> +    first_bit = find_next_zero_bit(attr->shared_bitmap, attr-
>> >shared_bitmap_size,
>> +                                   first_bit);
>> +
>> +    while (first_bit < attr->shared_bitmap_size) {
>> +        MemoryRegionSection tmp = *section;
>> +
>> +        offset = first_bit * block_size;
>> +        last_bit = find_next_bit(attr->shared_bitmap, attr-
>> >shared_bitmap_size,
>> +                                      first_bit + 1) - 1;
>> +        size = (last_bit - first_bit + 1) * block_size;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            break;
>> +        }
>> +
>> +        ret = cb(&tmp, arg);
>> +        if (ret) {
>> +            error_report("%s: Failed to notify RAM discard listener:
>> %s", __func__,
>> +                         strerror(-ret));
>> +            break;
>> +        }
>> +
>> +        first_bit = find_next_zero_bit(attr->shared_bitmap, attr-
>> >shared_bitmap_size,
>> +                                       last_bit + 2);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static uint64_t ram_block_attribute_psm_get_min_granularity(const
>> GenericStateManager *gsm,
>> +                                                            const
>> MemoryRegion *mr)
>> +{
>> +    const RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
>> +
>> +    g_assert(mr == attr->mr);
>> +    return ram_block_attribute_get_block_size(attr);
>> +}
>> +
>> +static void
>> ram_block_attribute_psm_register_listener(GenericStateManager *gsm,
>> +                                                     
>> StateChangeListener *scl,
>> +                                                     
>> MemoryRegionSection *section)
>> +{
>> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
>> +    PrivateSharedListener *psl = container_of(scl,
>> PrivateSharedListener, scl);
>> +    int ret;
>> +
>> +    g_assert(section->mr == attr->mr);
>> +    scl->section = memory_region_section_new_copy(section);
>> +
>> +    QLIST_INSERT_HEAD(&attr->psl_list, psl, next);
>> +
>> +    ret = ram_block_attribute_for_each_shared_section(attr, section,
>> scl,
>> +                                                     
>> ram_block_attribute_notify_shared_cb);
>> +    if (ret) {
>> +        error_report("%s: Failed to register RAM discard listener:
>> %s", __func__,
>> +                     strerror(-ret));
>> +    }
>> +}
>> +
>> +static void
>> ram_block_attribute_psm_unregister_listener(GenericStateManager *gsm,
>> +                                                       
>> StateChangeListener *scl)
>> +{
>> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
>> +    PrivateSharedListener *psl = container_of(scl,
>> PrivateSharedListener, scl);
>> +    int ret;
>> +
>> +    g_assert(scl->section);
>> +    g_assert(scl->section->mr == attr->mr);
>> +
>> +    ret = ram_block_attribute_for_each_shared_section(attr, scl-
>> >section, scl,
>> +                                                     
>> ram_block_attribute_notify_private_cb);
>> +    if (ret) {
>> +        error_report("%s: Failed to unregister RAM discard listener:
>> %s", __func__,
>> +                     strerror(-ret));
>> +    }
>> +
>> +    memory_region_section_free_copy(scl->section);
>> +    scl->section = NULL;
>> +    QLIST_REMOVE(psl, next);
>> +}
>> +
>> +typedef struct RamBlockAttributeReplayData {
>> +    ReplayStateChange fn;
>> +    void *opaque;
>> +} RamBlockAttributeReplayData;
>> +
>> +static int ram_block_attribute_psm_replay_cb(MemoryRegionSection
>> *section, void *arg)
>> +{
>> +    RamBlockAttributeReplayData *data = arg;
>> +
>> +    return data->fn(section, data->opaque);
>> +}
>> +
>> +static int ram_block_attribute_psm_replay_on_shared(const
>> GenericStateManager *gsm,
>> +                                                   
>> MemoryRegionSection *section,
>> +                                                    ReplayStateChange
>> replay_fn,
>> +                                                    void *opaque)
>> +{
>> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
>> +    RamBlockAttributeReplayData data = { .fn = replay_fn, .opaque =
>> opaque };
>> +
>> +    g_assert(section->mr == attr->mr);
>> +    return ram_block_attribute_for_each_shared_section(attr, section,
>> &data,
>> +                                                      
>> ram_block_attribute_psm_replay_cb);
>> +}
>> +
>> +static int ram_block_attribute_psm_replay_on_private(const
>> GenericStateManager *gsm,
>> +                                                    
>> MemoryRegionSection *section,
>> +                                                    
>> ReplayStateChange replay_fn,
>> +                                                     void *opaque)
>> +{
>> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
>> +    RamBlockAttributeReplayData data = { .fn = replay_fn, .opaque =
>> opaque };
>> +
>> +    g_assert(section->mr == attr->mr);
>> +    return ram_block_attribute_for_each_private_section(attr,
>> section, &data,
>> +                                                       
>> ram_block_attribute_psm_replay_cb);
>> +}
>> +
>> +int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion
>> *mr)
>> +{
>> +    uint64_t shared_bitmap_size;
>> +    const int block_size  = qemu_real_host_page_size();
>> +    int ret;
>> +
>> +    shared_bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
>> +
>> +    attr->mr = mr;
>> +    ret = memory_region_set_generic_state_manager(mr,
>> GENERIC_STATE_MANAGER(attr));
>> +    if (ret) {
>> +        return ret;
>> +    }
>> +    attr->shared_bitmap_size = shared_bitmap_size;
>> +    attr->shared_bitmap = bitmap_new(shared_bitmap_size);
>> +
>> +    return ret;
>> +}
>> +
>> +void ram_block_attribute_unrealize(RamBlockAttribute *attr)
>> +{
>> +    g_free(attr->shared_bitmap);
>> +    memory_region_set_generic_state_manager(attr->mr, NULL);
>> +}
>> +
>> +static void ram_block_attribute_init(Object *obj)
>> +{
>> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(obj);
>> +
>> +    QLIST_INIT(&attr->psl_list);
>> +}
>> +
>> +static void ram_block_attribute_finalize(Object *obj)
>> +{
>> +}
>> +
>> +static void ram_block_attribute_class_init(ObjectClass *oc, void *data)
>> +{
>> +    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_CLASS(oc);
>> +
>> +    gsmc->get_min_granularity =
>> ram_block_attribute_psm_get_min_granularity;
>> +    gsmc->register_listener = ram_block_attribute_psm_register_listener;
>> +    gsmc->unregister_listener =
>> ram_block_attribute_psm_unregister_listener;
>> +    gsmc->is_state_set = ram_block_attribute_psm_is_shared;
>> +    gsmc->replay_on_state_set =
>> ram_block_attribute_psm_replay_on_shared;
>> +    gsmc->replay_on_state_clear =
>> ram_block_attribute_psm_replay_on_private;
>> +}
> 


