Return-Path: <kvm+bounces-45695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDFB4AAD860
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 09:40:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 024A94E140A
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 07:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E43022069A;
	Wed,  7 May 2025 07:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jw466dVm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D84220681;
	Wed,  7 May 2025 07:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746603601; cv=fail; b=WLvZlW+s/e8Ulb24l+6hKEeDl04Nf1v+c3OjeD4A9j5tqH43U3S/NxtkBxsdHm5IKDaCGT2ad8c4mV5X2o3N6e4PWdzmOs0Vngi4SEnVywebp/NoVziSo1xRRFcWuZsA8LWeSFTIeSlAmqcDscvQcW7hqmMe0umWFoIbFk+LpUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746603601; c=relaxed/simple;
	bh=It0x7u9+efKDaxgPTs9KxtHWJq9ToT8g5UPkZIoh4qM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IcUgB0u2Q+L5lnSgiMOaiWGbsyd7yTfGvfUK2unkwauzEMi0CrtC4GWaIDraoa2gEvzqkhBiNAi+4sRKi1YDww/sAd7Qu3sZE179TavKY9RGaiqsnlj7+XJZVhMXox6YIZFxYQOPWvWlaRa9fKb9nz5iNVd9DG1H0erOcrOn+5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jw466dVm; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746603600; x=1778139600;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=It0x7u9+efKDaxgPTs9KxtHWJq9ToT8g5UPkZIoh4qM=;
  b=Jw466dVmKZoGvDKyH+I5RX2wtKrsl36w4i1MXouaN/ajbJGfZlyZyL12
   PvDosHDj2IvEKLfDw2veerI9O51+gMGcDhJLOHe7BrU/Du9nYUXtSAa/7
   /bhn0CCPrN2oThP8S4t5EqDhmGsNDdmlphGW+2jUXpR0oGY2yfp3ccp1d
   AFP+C5J+z4vZlCGe0uAKVYV3iX2DpFW+l0EXE6D2UJ+ERRxg4LD9jevPH
   6sU6aCRfzUR1zof9vryfeRypkeOYWbwAvt1noTbTx0vUmFtc/RCTHZSmD
   ydAZYCUfwanjoRymJo42dqO2jkGcbSzxtSMDnHLNv8YwkVsPV3eoyw2YB
   g==;
X-CSE-ConnectionGUID: P4cswsywSKaGq7EeMMQEYQ==
X-CSE-MsgGUID: qllOASdgQhGoZ9ERSLJUCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="52132360"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="52132360"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 00:39:43 -0700
X-CSE-ConnectionGUID: Hit6QMZdRRSrDlf5M/srTg==
X-CSE-MsgGUID: tgXQdkx2S3aTrbxfJX636Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="135872636"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 00:39:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 00:39:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 00:39:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 00:39:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kguZHqMiibsVOQaNMEualsAl1sVuGXjM/c/m2QAXf4oQ7AzAv8KKB93r02Iyb+8VgkMpN6SMBHUm/ZqBcSVJfPLKfYFrNYIv0ljw52hHJEkub3n1i9MrH1ZUfjHN/5c+kc8FxHexhfeNX901TwopqrTDWWJ+e6kMsj7ZNjLLP1aP99p4ZnI4yqEfiZOOGCmkRnABytWt30dtCSQwmeYTl/7B3Kkxl5fEu3x5eAGzBCsOFCacxTTBlWXm9xwljrQz+u28wkDgk3H9bUL1BwzAiE8+Y4sFeh/FGjBLjTkRrWH20hw+2WWQmphIoISeAiLqQkB5O5d5XRRlVQe1y6pvbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sTJnGqdzyPh1eOrgEXX7Y+7f5ATiKoQYd0YublkTCCI=;
 b=RhZ8gkOHcQgNt9eNRlHgNYuNKcCVST+1fO51pUGySDoUZ7OrdAh398paEQcwoU/F76z98hDAVZ+D1netSTDkziLzlGwL81EVk+PPufhCPuBIFDpX7WKSkNkG36fuS6VfCH1jSnE+K93JHnOckfTTWQcCXuFFOhdv9Pqij3zwzaqJrJBxhmCid5Y9JkF6v3Qzws+ik7UBJJtUR7aIlnc0tb0rxZA2h6zGYNPJpJqMhJ3QwdHDrPdvBK1V6dlddkHWTZxoiGxTg66dm5BdXlbBHXClpATxwx0xBvo09inkieDh6lGaIi9K8QPxRSoItP0ZPpCMG/+9lFBALH675DDntA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8237.namprd11.prod.outlook.com (2603:10b6:610:154::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 7 May
 2025 07:39:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8699.024; Wed, 7 May 2025
 07:39:25 +0000
Date: Wed, 7 May 2025 15:37:21 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vbabka@suse.cz>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pgonda@google.com>, <zhiquan1.li@intel.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aBsNsZsWuVl4uo0j@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030603.329-1-yan.y.zhao@intel.com>
 <CAGtprH9_McMDepbuvWMLRvHooPdtE4RHog=Dgr_zFXT5s49nXA@mail.gmail.com>
 <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com>
 <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
 <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com>
 <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
 <aBmmirBzOZfmMOJj@yzhao56-desk.sh.intel.com>
 <CAGtprH9fDMiuk3JGSS12M-wFoqRj+sjdtEHJFS_5QfKX7aGkRQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9fDMiuk3JGSS12M-wFoqRj+sjdtEHJFS_5QfKX7aGkRQ@mail.gmail.com>
X-ClientProxiedBy: SG2PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:3:18::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8237:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f4eb7c8-f8e3-4940-3e89-08dd8d3a4ab6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WS8vM3JUUFlaRU1rOHVMbmNZMnp4ZU5PK2Y4RnFYWGkrV3JMRFJvUHB1ZG1S?=
 =?utf-8?B?dUltQVdBbGtXTGlKL0xjZHFiamxkQWJ0cXNVS1R3UE00ZUlnZE01OWhpSG5i?=
 =?utf-8?B?UXRHOVo5UGJkbWg1QlhhK2IzVFJFMkYvc1BaZHNtR092cWwzWVZNVmZlejJu?=
 =?utf-8?B?YmY0aHE2bExxT2JhZi9Qa1J6ZExqeFJoTjRKSGgyN2pTL29WN1JnalVpUDFq?=
 =?utf-8?B?UVFNRUJuN3l1L1BRb09zRk9ZclMxQXhESTNjVHBXc01NdVBtRUVOR1BmNGNP?=
 =?utf-8?B?NXBkdUVKV2wxYUROQW1UM042ZFhtOUJJMWlRQXRKZUl5WS9jbmVkSCtBdlhF?=
 =?utf-8?B?RDdWVXN0TzJLV2UwZWJsVzljU2sxTWdHZkE3ekNUQTB2alFJcm54ZjZERWZn?=
 =?utf-8?B?WkxlbVljNFhiaytiN1cwNnpPU1MyWm01TFVHRDF4MVZMck5mVm5xcTBqdjhJ?=
 =?utf-8?B?OWhmRWdIWGY0WFJZT3JXU3NKeHhNcnZFSTh6bGVpeHlzbEpqdG0wYW9qdGY0?=
 =?utf-8?B?a0tZNzVwUVpwYlRYUmpkaWIzRVFrWi9VZzdpNFRwWSs2RXdlUm5zTDlTMjZE?=
 =?utf-8?B?QmtsS3BTaDBXTmgrSk9DNjlUaU1WZDV3cU9QTGtuK1E4RlAzTXcycEpsdUlT?=
 =?utf-8?B?V1JoOWJDS3FaOWcxeVMwdHBuQUcxVno0bDJoVWRXR2lYU1FNb3BRVEtCV3gy?=
 =?utf-8?B?dHpROStJK1d2VTBiZTdiV3AyRU1ubnBOaGdybjc0emRSSWUzQ2lmd0F2b0k0?=
 =?utf-8?B?cmo0akpwT3gxMFhCRTRZZHV1OGo4N1U0bXRFZ2k2L2t0c1BsYnViWWJMbDhD?=
 =?utf-8?B?ZVczd1U1SkQwNXNiUW80STFsMnR4ZURzb29DSHJaOXg3V1M2NmxzWUdTcll4?=
 =?utf-8?B?cGdSL25MV2tXL0sxZkpOeWpXQ280V3Zpay9YeHFTTXc0K0JlMWtGR1hlMGJV?=
 =?utf-8?B?ZlQvdmdkS2VFUWY2M1N2NDNVZS9UOVhDMDdRZFQvRkE5bU0zaGFJdkNHR3Ja?=
 =?utf-8?B?eGVpSEhOcWtWUG16MVFFcjhRNGxtdW45NjZ4b3ZFVkpMRm4xbXVoazFpSlYy?=
 =?utf-8?B?UmpyeGJpZmpUbDA5djI4d0loUWFZa2tKYk11MDFFU1B4MTBSTU5DZ0JsU2Zo?=
 =?utf-8?B?RURCZUJaaHJHN1RzUE9JRHlVQXk5UE02K1Zxd2t1NVc3SlZrZUhSSEFZek9E?=
 =?utf-8?B?VU50ckM2M1I0T09vVmczME44RmFSSFVOd1RYSU02OTBsVGRlN2RWcFZMVFh3?=
 =?utf-8?B?RDV2bVREZ0h0M3NpRHFYeFlHa1d5QU81MUVhNmdIemREd2M5T0h2Q2lNVk9V?=
 =?utf-8?B?Z3hUYUlUeHl4Rk9FV1V2UUw2WUJTaTgvWm52RGM1ZTNVSG1RZjg2OG5zMllQ?=
 =?utf-8?B?YnI3RWtraHhvNVNYelhNUkJlUnZIV2V3ZVp0bE56T3VjOENWZ0V5MWdjdFkw?=
 =?utf-8?B?bHE1QVFLLzVqK0Y5VmZOZUdYSk12elNLd3FiTUpFaWkyaUh1OEVZY1JiSFg5?=
 =?utf-8?B?eVU2dEdwRisrTUg0VVBuV2dLRGNqMURHZkNuaUFnWm5IRjNzWHhKRmhNUFUv?=
 =?utf-8?B?ZGYwUElWVHJvclNtUmQyMEIrcGovRkM2cTNLSTFkRGRlUWcvNVcwRGIzcEJK?=
 =?utf-8?B?Q3lRZ3VYR2Q5WUY1Tk0rZkNOdWZna2J4TG1OalJ2WUxjMDNlK1FEallvQkJ3?=
 =?utf-8?B?RlFHZ3ZHaFFwWjBWd2R4WmxvZzRISzllSHhhcEVCOHQ5TktWQ3hDVkNOYUpm?=
 =?utf-8?B?R2hYcnRFc3JYT3RKYnNrbnh6SEFMTVl0STFER3FGL2NJdllOWnJzczBHZm9i?=
 =?utf-8?B?RkIvczBzV3AwSTBNVDBhNER6Z1d3SWFrRTVqaW9WcHAxdXhhd2ZLNGdTZ0VB?=
 =?utf-8?Q?EzJYl2GoIG3x2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlYzaHFuam1BS0NSTHJrYmRmWnRGcWJCWEVIVE1LVkFmSjRkT1RUakZUQkdL?=
 =?utf-8?B?anZjQTBEaWdxenhqZytWWmtlR2Rrancra0pNNDJYOWczVkdBeG8rY2J2YnpE?=
 =?utf-8?B?QXUwcWdDNTU1RlY2Zmx0WUh1cHpWNmZ5L1JtdGJyTWRmQzYwbDF3UHl0Sm5v?=
 =?utf-8?B?UjkrUnh3NGthZ0RWUEIvQVpsN01Wb0MzR1l6S25rd1JlZnZmVWwxMldBc0tB?=
 =?utf-8?B?eVpKWi9UbTNMWU1LWEpmOWEzZXNFbzdzTE9Ec3ZMOGxSbkZLM09GL3paNXBL?=
 =?utf-8?B?VXJ2OFVGN0IyeERXRnVISXRhbGhzUm9RbW1TMXRuenBpUDlmL0ZaTnRvbVhu?=
 =?utf-8?B?TnRFN2w5ZnhRdjlRbXVRYmFsdUR3WHdRMUhDODBrd01qV2hReFRqWHhUbUp1?=
 =?utf-8?B?V0RqeGpMYkVaMGY2MlE0diszak9NVDA4TkprREhPV2RKUW1uV1NTQnJUejlY?=
 =?utf-8?B?N3JZdHp3VGZqMCt2bzM3bmkvM2lxcUxCUVM3UGR6QWR3alBobEQ3UjZzWVdV?=
 =?utf-8?B?RFl3SVRuR083QmdkRGJ1WVU1MTA1MGkweXRFbWJLUS93WWR3eFRJZURlQ1dD?=
 =?utf-8?B?b0VOSDFvb0NyM0x1MG84YU55aFoxZHNiZm8rWHE0OXgzdmpsZm1laGN2QWxq?=
 =?utf-8?B?YWlLWmlGUktjY0xIMmNMcnJwbFAxSVZSZzlpYWUyR2JxcWxoM3FBOXNzTzQy?=
 =?utf-8?B?bHh2UHBBUU1NOHlBTXBaaXNZU2E2eTlUS1hkRXU5NXNON0NPMXdVMVVwWisr?=
 =?utf-8?B?c2Y3bFN1OGMzN3hqVWpnQU41bzZwTVRjbjU0cFlJRGovaC9JdUlpdjFhaW03?=
 =?utf-8?B?Y2dxeHcxMVRLNkNNKzJ0WGxVNWJXOXc2eENJSFZDY3pRWVdKOWVLVnBRdjVF?=
 =?utf-8?B?eHozOE8wajVXS2g4dlZZRmo4b0RlZUh0RzNSanBIcFBRSmNxWDdOTUg0V0k4?=
 =?utf-8?B?dmJiN2J6ZzlKSUszQWRwcTJaenZpMUdNejExczI0OGwzdGpVeWgyTHZtZHhP?=
 =?utf-8?B?cGFPNEEyYVBXeU0wNGRBNTRwdXN2ZU43WXZueVF1REVCWVdZQitWUkgrL0NB?=
 =?utf-8?B?bmpyWCt1aGtyempNb2NLY0VGOWlDSXBGMWw3aTczZHl1TWE2QzZkNHVnditV?=
 =?utf-8?B?MWJaU0tveExWTU8yRnNFQkpabHlFUXZEcEZPQ3NzT05UU1lFb2lSalpkVm1j?=
 =?utf-8?B?cXZOY0tCTlRYOHArZHdnWkhrL2tQaW80Z2ZDRmxHNXNQSmxBQ1pFdUJkdVNT?=
 =?utf-8?B?cmhOdHVzd09IN0sxZVdTdnVnbWZtc2I3Kzd0OS9iK3lMOWxCSjcyeDBpSzZQ?=
 =?utf-8?B?Njl4ZnZnMG0yUno5cGlOOHllL1l1MmovUGdEeTRjVFRVczYzbTE1dEVzUXZN?=
 =?utf-8?B?WWs4V3Arb1BRZlVaUmZjQXE1bG9NQ002b24xSXNOQkdDbGl1VnRSUm44YU54?=
 =?utf-8?B?Q3lST2FuUStlZ1dOK0szQzJ3bnlGa3JjSWZxSklpTGZxaVZ4YURFZkZHSlgv?=
 =?utf-8?B?YUVqdTh1ckJIdDN5eHByc1hLR0oyaG5tNXMxK0J6VXAzUXBWclBQejNMOE5Z?=
 =?utf-8?B?c2lZRHZVVTJvVFJSUWhiVUsxZHk5M2NaMG02WEM0S1I1UW5IRW04b1RpQU9F?=
 =?utf-8?B?bU9SUDhZZWFCNWVEbUp4em5NQ1ROc3ZLRUJUaVhQWW5NMzVheTdKakVaamtz?=
 =?utf-8?B?WHdvYjhiaTNURGVuSmNIQUtEaEp0NkJwVTBLMkswc0NRQ0ZSWUlLdWtHK1VK?=
 =?utf-8?B?RHRjazd2V3dDblA4RGh1Z3lCVTlCSFBXNDcxcWtJWUZyNnpWUVovK3NCcFkv?=
 =?utf-8?B?RytuMUNHbmNaMXdPSkh0K0ZMd0kwMEtHa2d2VVdGVlBqcDhVSnFSNGZXci9K?=
 =?utf-8?B?VnNueWoxSHVXQVNNNHRhaGtjeVRzcVNURDZpaTBFak0vSjYrdlVyQkxlblYx?=
 =?utf-8?B?R3MxNUMwWW1COHJTR2tNNVg5eXVkZnRXOEVObG9oanVoUUJ1SkZ5a0ZqRXJI?=
 =?utf-8?B?RWRQNmV5K2NNQXF6NXdrRWVoWkdia01TUUQwUGd3SXFJN3FYdzRDcVRlcEVa?=
 =?utf-8?B?dDhhbVpVcS9yS25UVDN6ME9mNkNqL3VYUlhBckx4djN5QWxjL3RTeTQ0RmFX?=
 =?utf-8?Q?MYf9rCxcAG11jAOBcE2JnrXJu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4eb7c8-f8e3-4940-3e89-08dd8d3a4ab6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 07:39:25.9065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MBzhQtOzoEOo+fy8822EnTzWXV1NGW1uWJDlangalDypTEkBG1XNw2CwlK0r2G6NiLmvhzzUQwbkLxjjI2bYbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8237
X-OriginatorOrg: intel.com

On Tue, May 06, 2025 at 06:18:55AM -0700, Vishal Annapurve wrote:
> On Mon, May 5, 2025 at 11:07 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Mon, May 05, 2025 at 10:08:24PM -0700, Vishal Annapurve wrote:
> > > On Mon, May 5, 2025 at 5:56 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > Sorry for the late reply, I was on leave last week.
> > > >
> > > > On Tue, Apr 29, 2025 at 06:46:59AM -0700, Vishal Annapurve wrote:
> > > > > On Mon, Apr 28, 2025 at 5:52 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > So, we plan to remove folio_ref_add()/folio_put_refs() in future, only invoking
> > > > > > folio_ref_add() in the event of a removal failure.
> > > > >
> > > > > In my opinion, the above scheme can be deployed with this series
> > > > > itself. guest_memfd will not take away memory from TDX VMs without an
> > > > I initially intended to add a separate patch at the end of this series to
> > > > implement invoking folio_ref_add() only upon a removal failure. However, I
> > > > decided against it since it's not a must before guest_memfd supports in-place
> > > > conversion.
> > > >
> > > > We can include it in the next version If you think it's better.
> > >
> > > Ackerley is planning to send out a series for 1G Hugetlb support with
> > > guest memfd soon, hopefully this week. Plus I don't see any reason to
> > > hold extra refcounts in TDX stack so it would be good to clean up this
> > > logic.
> > >
> > > >
> > > > > invalidation. folio_ref_add() will not work for memory not backed by
> > > > > page structs, but that problem can be solved in future possibly by
> > > > With current TDX code, all memory must be backed by a page struct.
> > > > Both tdh_mem_page_add() and tdh_mem_page_aug() require a "struct page *" rather
> > > > than a pfn.
> > > >
> > > > > notifying guest_memfd of certain ranges being in use even after
> > > > > invalidation completes.
> > > > A curious question:
> > > > To support memory not backed by page structs in future, is there any counterpart
> > > > to the page struct to hold ref count and map count?
> > > >
> > >
> > > I imagine the needed support will match similar semantics as VM_PFNMAP
> > > [1] memory. No need to maintain refcounts/map counts for such physical
> > > memory ranges as all users will be notified when mappings are
> > > changed/removed.
> > So, it's possible to map such memory in both shared and private EPT
> > simultaneously?
> 
> No, guest_memfd will still ensure that userspace can only fault in
> shared memory regions in order to support CoCo VM usecases.
Before guest_memfd converts a PFN from shared to private, how does it ensure
there are no shared mappings? e.g., in [1], it uses the folio reference count
to ensure that.

Or do you believe that by eliminating the struct page, there would be no
GUP, thereby ensuring no shared mappings by requiring all mappers to unmap in
response to a guest_memfd invalidation notification?

As in Documentation/core-api/pin_user_pages.rst, long-term pinning users have
no need to register mmu notifier. So why users like VFIO must register
guest_memfd invalidation notification?

Besides, how would guest_memfd handle potential unmap failures? e.g. what
happens to prevent converting a private PFN to shared if there are errors when
TDX unmaps a private PFN or if a device refuses to stop DMAing to a PFN.

Currently, guest_memfd can rely on page ref count to avoid re-assigning a PFN
that fails to be unmapped.


[1] https://lore.kernel.org/all/20250328153133.3504118-5-tabba@google.com/


> >
> >
> > > Any guest_memfd range updates will result in invalidations/updates of
> > > userspace, guest, IOMMU or any other page tables referring to
> > > guest_memfd backed pfns. This story will become clearer once the
> > > support for PFN range allocator for backing guest_memfd starts getting
> > > discussed.
> > Ok. It is indeed unclear right now to support such kind of memory.
> >
> > Up to now, we don't anticipate TDX will allow any mapping of VM_PFNMAP memory
> > into private EPT until TDX connect.
> 
> There is a plan to use VM_PFNMAP memory for all of guest_memfd
> shared/private ranges orthogonal to TDX connect usecase. With TDX
> connect/Sev TIO, major difference would be that guest_memfd private
> ranges will be mapped into IOMMU page tables.
> 
> Irrespective of whether/when VM_PFNMAP memory support lands, there
> have been discussions on not using page structs for private memory
> ranges altogether [1] even with hugetlb allocator, which will simplify
> seamless merge/split story for private hugepages to support memory
> conversion. So I think the general direction we should head towards is
> not relying on refcounts for guest_memfd private ranges and/or page
> structs altogether.
It's fine to use PFN, but I wonder if there're counterparts of struct page to
keep all necessary info.

 
> I think the series [2] to work better with PFNMAP'd physical memory in
> KVM is in the very right direction of not assuming page struct backed
> memory ranges for guest_memfd as well.
Note: Currently, VM_PFNMAP is usually used together with flag VM_IO. in KVM
hva_to_pfn_remapped() only applies to "vma->vm_flags & (VM_IO | VM_PFNMAP)".


> [1] https://lore.kernel.org/all/CAGtprH8akKUF=8+RkX_QMjp35C0bU1zxGi4v1Zm5AWCw=8V8AQ@mail.gmail.com/
> [2] https://lore.kernel.org/linux-arm-kernel/20241010182427.1434605-1-seanjc@google.com/
> 
> > And even in that scenario, the memory is only for private MMIO, so the backend
> > driver is VFIO pci driver rather than guest_memfd.
> 
> Not necessary. As I mentioned above guest_memfd ranges will be backed
> by VM_PFNMAP memory.
> 
> >
> >
> > > [1] https://elixir.bootlin.com/linux/v6.14.5/source/mm/memory.c#L6543

