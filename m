Return-Path: <kvm+bounces-38993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C7A3A41EEB
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 13:28:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DBAB7A50BD
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 12:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9A123372A;
	Mon, 24 Feb 2025 12:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c3Iq98w+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6EF221F31;
	Mon, 24 Feb 2025 12:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400079; cv=fail; b=NzlcYSQxwrXGDAoh+w6p9qBfDwXY7qiiNc1p6GqCfmiHPOjKxAdnp5ONpdlWj5AUEnum+67Am95avrzwflDXeK2K/4ItmdaQIHoctScqUSKwfQdsuCqt7dUtCeurhZ8lEZHA639bgSZvXTgm06wIuQk1JXvgofU4dUAXwBiRouo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400079; c=relaxed/simple;
	bh=T/hjJRqVpYwwGH8JY1vuyIBkW3JMf1nwuwX9hErcVV8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I5n8PRIrrWpKPkHj3aTzcE6d9fkE6+sv76zpF8C2TbiaUQ4L22QScHYYff6ebL1JYhj7stsAfkrd8wZPebDfEXytyX5QXLFtqkJmSHhk2gC59KT/aJTimwB9F03FaQfjIXeEiJV7nGDL/l+/OdQpRv5gurxKMOsBzdrvRtJXF4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c3Iq98w+; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740400078; x=1771936078;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T/hjJRqVpYwwGH8JY1vuyIBkW3JMf1nwuwX9hErcVV8=;
  b=c3Iq98w+RoHExEYPUtpZN0ktwSzyiRR3cuS90r3ZHqEHI+1rovHuNbsQ
   JcMB6wjtXfpD612t9r1DcmDs/jtePjCu1OcltXwu332KN/28mBVMy/746
   UH7//v/oFahdIkMt1/dZVmcnWMbmnLLb9XQFrPRfwf8GuXIJtKMhmH/2a
   L+p9UrmXnv0NHlvDSaWMqNu5lLkNcWALTtcNOAEAJy2cntverCDkaaWvf
   PAYp1cooSU8p4GyamXj1dq+BkyQDeIO7OQTiR5pm116/waDqnlaGoCjrB
   JfWoi81OMBONzhpfpxDqnjDD+ekUbCO+SxwwZn12uMbhbC/4cFaNFNH88
   A==;
X-CSE-ConnectionGUID: 952EeyEoQjaWaSJCZimnZA==
X-CSE-MsgGUID: nnicH803QQqaWIhoPe3SEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11355"; a="41063847"
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="41063847"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 04:27:56 -0800
X-CSE-ConnectionGUID: OUh90yvlSUKLhPJLIj/zRw==
X-CSE-MsgGUID: W2+kOY++Q7yJiht7JIBUdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="146927439"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 04:27:56 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 04:27:55 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 24 Feb 2025 04:27:55 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Feb 2025 04:27:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VIT0zZOg3w+PeO/BmOPnLElsuQ13b3V0uopRtHaXnkUzAEN4VspMnlggHEy/ZRsDqTadIMflNVejz/zuGv0a+yRqVJ1qareVeUM5xuN+/jPZyZm/8LYctpJ2dySl42uStYoSiEcslc1aMs5wL+9T8ctd4waPUjaAgvXvP+0Y0ABqMp4RW1OExiw70Q80Gqnu2g8vjhXReN3M5SBo2KUvLqGtmID4tDA/qeBTkQBPbA7OZWQfDqLbqKNH+q7FPx4ByQtwR9u18oxH93bLPewaEraLkLp3q/HcBbRjEyA5Oe6lLsNkkjq0SvHhvIrzvj16m+3aA/KGMYImU9F3Co8jaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q64HwqYG2tR9KV7QRmQnCrOJW3AQRfYnDHnySge81eQ=;
 b=b191b83Jn/hevW0OUvcoh4t6LZpTg8u0TDBaX/+s8Pe+3P1goz6hTaH4yUn7FI+1wFaEXuCLHV9ywVlS3WVEasqEqwA/uXG5d93KpggdH8gNPYB0qhSCib4M89r4tccM2vlyZ0ALveftXAer8eLXXv+A4YY2aSNQBlqEKFkSatigl9Gv86q+FWw7luWjRE07Zy3Ij0H+CsmHXO1vQYy4m8IQ5FESkcZajfXzuN0dh3FFOIMcKBjrQli3XPXYIkm8DXYfphVdRR4swhBfKuzoc+sOnn1QmR8g4WCBblinuOJuSNPbEU9gCZ9bvDT2qzfJGAYHIku4zYs2AhIIjUdcrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by SA1PR11MB6661.namprd11.prod.outlook.com (2603:10b6:806:255::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 12:27:35 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%5]) with mapi id 15.20.8466.016; Mon, 24 Feb 2025
 12:27:35 +0000
Message-ID: <632ea548-0e64-4a62-8126-120e42f4cd64@intel.com>
Date: Mon, 24 Feb 2025 14:27:25 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 05/12] KVM: TDX: Implement TDX vcpu enter/exit path
To: Xiaoyao Li <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<weijiang.yang@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-6-adrian.hunter@intel.com>
 <06c73413-d751-45bf-bde9-cdb4f56f95b0@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <06c73413-d751-45bf-bde9-cdb4f56f95b0@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MI1P293CA0022.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:3::19) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|SA1PR11MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: 34457a6c-dead-4649-b9fa-08dd54ce9def
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MzJiZHB3MWpUL0tkcTlxbzA4bkduL3hxNEpiY041dXIzUktFeGwxV1oxaFlZ?=
 =?utf-8?B?YnZDenM2VXlDN3Y4QnA0SmdSQjcvYm53bURRMUJmd2RNVjNqZjNteXNVcmg1?=
 =?utf-8?B?aUFFU0dDbDZMeFBSbHlpWWJpM0ExUWN2YmtpMkFsMGJ3VnN5ZWVvMjl0OWIv?=
 =?utf-8?B?MHVUQ3prY3B2QlZmMzV5Q0kxS0RpTzNQR3NneVpSL3JHczlTRkx0Rll0dzVV?=
 =?utf-8?B?djJJekpQSWhnZmlVMXZITXRBbkZCcWRVK09ONE05Mm1VMW5PK1hITWRYU2pJ?=
 =?utf-8?B?QXVkbG9WMVJkREJ2eGdqRm92QlQrWExvbnpmYWVnZlFBMFg5R0ZyVUlUMmY0?=
 =?utf-8?B?eDhoOHJNMlJWL3M5M1NuSWRsUVVEVXcySVBMSWFmQzVLQUdNYVVxQ2ZOR2JX?=
 =?utf-8?B?ZkIrZXk2SDhhRUJ5YnFERVRNeDh0NUQxNjZBRlQrNVlPSnppUlVBYW9pNkJh?=
 =?utf-8?B?WUFyV3cwcmd0UzVGTUQwWEFib21SeFJPek5XR041bDVCby9RdHRDWjlYVC9j?=
 =?utf-8?B?bldEOUJUejh2ZW5HTUlpRmpkQU96QVlrU1l2YTFYamtDemxnRHFJRG42V0RM?=
 =?utf-8?B?QVJGVnZnUk5tZmJsNGU2RnJrNXIwU0NRT0RHR3BZMXBSQnQxdmZPaHFORmNX?=
 =?utf-8?B?OFk3Q1ZvSjArNjNMdmVxL1ZheWRyTjcyNFh0aWpWalRZd2FCU2tzbnoxREJB?=
 =?utf-8?B?UUNzbThHZ2tFSE44UnViVmhjSXdzYWhLSWVGOUZWdkpPQnpIbGlIcHhxUUlh?=
 =?utf-8?B?djlCTWpIV3Bwc09teHpURnhGQ0Q3TnNyOWV2V0FXbFo5WnB1TjRzbEU4Q2FN?=
 =?utf-8?B?RERJbDdYT0F6R3dUTVZwZFRmaTdrckZwVVh1eDlzaXgzTHNNT21uUy9RYUdR?=
 =?utf-8?B?VkxGMFJPcDN1UXRXaFN3RDl4UUFjcVcrUTJ6ZHI4eDZrMEZqR1RQVDdTQlZW?=
 =?utf-8?B?ZEFPY1cvK2VaVmJLYVNsWEtPTnBwUFpJenVQOUl4MElTMG84cGlVTHBBaVZn?=
 =?utf-8?B?RnJ4ZVYraGhEUVNEaERNNmsvZjBJN0xnUDFhak8zWmRiS01rbUkzR3ZQRFB2?=
 =?utf-8?B?TnNncVdDWVQzSklEZGRWTDVCcjBGMU9ENERyNGo5eXJMZ0gvZEx3dUlxOVg0?=
 =?utf-8?B?cVN3d3VzSytrM1BGZytLOW1XREtWVy84aW56eUF2VE9SNDdPRnV4cnptNXVN?=
 =?utf-8?B?YWlmNzN6MGRuVWluN1FhK1drcTZaRUJXRHJOS1pDb2ZkYjNiZ21UWTJ4Smtp?=
 =?utf-8?B?MnVqR21yRlV2ZXJtQWxUZUlaKzZJMk9Qa1VhMkFhbkl5NXVKRDU5RStUWFJG?=
 =?utf-8?B?dFVva21nYndUdFB2RlhyNTZzRWhTeng5UTNoK2JJTmFycWNvb1ZHMDZvdWRT?=
 =?utf-8?B?L2YzMkZnZEdrWVFRWU9NVmpLRXpFQUZRLzU1RGdLdmkrU2pZSTlsMlQvcXhL?=
 =?utf-8?B?L3ZTRjdtb25IdEw5S3BhUEpvc1RqM3F5U0pmcktoQTJGc2JEallBYWc3REVr?=
 =?utf-8?B?aEdDazNjU1NUc214d2Q2N0laUE5OSTlsRTkvczRxeVJiZG5tZ3piWWQrRnls?=
 =?utf-8?B?UTkyYTlSdG9QMUhSWnNoU3ROQitxT214QkhaYUxrYnY0NzFxQ3VWSVZxQ0hm?=
 =?utf-8?B?S2NyTGovdWRjbThUejE5SE5NQWtzei9jMldlcDRoRHVmby9OaTh5ZXFsSHFN?=
 =?utf-8?B?S1h4L2JxT0xYaGdvMmY5bWVGRldvaHlkTFBFM0tiVlNpL21qYlVybHRGL1Fj?=
 =?utf-8?B?TUNXTmxEekYyVWVzYjdzOEhQSHF5cHJpTWNaWXM2Z0NiUWoyNW93akZDWnJX?=
 =?utf-8?B?MlE1V1dDU21Wb01YSEZXeVYzVWI0RnJKNVpCbTlQNnJnVjBzeEFNV0hscUho?=
 =?utf-8?Q?Ss2uE9zlWRD0r?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmhYVGlWMGVQTmc4eFhGUmdEK2JpUUFucEpYOE1KbS9wZFRKbGp2OGw0VHVn?=
 =?utf-8?B?Y1lReHA3Q293Wjh2UHdRT2dmd2FreGorRWxDbmttdjA0UDBSbER6UEdtNDEv?=
 =?utf-8?B?bThCaDBhRFNmMmhRM2J4VnlOUHNkN1p4VS9pYnlYZUp4bG5ZbDhGWnNvdG9o?=
 =?utf-8?B?K1JtY2xrMUNjOVJ1M0N6M2ZqZnM0WHJXZlhjN0s4dzAxdEIwdk9nbVNoa2xY?=
 =?utf-8?B?TjF1d2FKVjcwMG54dmhISVZTdGx1b3lsbnUrdFc4N1JobU5ReWd5R2VnaTZM?=
 =?utf-8?B?V3FyVWxrV2NhcXFqcmhrSHZVUHFjdVk3TXdrZFhHdFJ5VDdCOU96WHZTUXNt?=
 =?utf-8?B?bTBRTTg0WUlEUFFIRmZydjZUM0tVRWdUOC9kS0NtdUZDOU1JMm9PUk9ST3Fv?=
 =?utf-8?B?TFA3VnpVVkJ2N1p0VVUwYVZ5SnpFeHBZVzRRRFd5eW13WWNRZERJRlhieFRO?=
 =?utf-8?B?VTJhWTRvaTFvbVpteXd2cmdjMHNNbWtxb0VjZVJ5K1FEcDJjVlJGUUU5UjNj?=
 =?utf-8?B?U1lXOUlNSU8rUHpkVWR0bGU4cGJVVFlNRW8zWVBLUVVYRVpnMWFMSy9oOE93?=
 =?utf-8?B?NEo5MjllUFZLbFNBc29IUkY5VzY1aFhtbDZEYlVFQ3RtT3BreFJMU2ZqN0ll?=
 =?utf-8?B?YW1aSDMzejRNODRRaXFHZm5PSVl5OUhuSVJYdG9Yb1YxMDZzd2tocnc2dnFK?=
 =?utf-8?B?cTdtTTVNdDNETDZ6R2VjcUdZbXVWU0tCWnBEOWxnR3U2NUJHVEY1c0o4YXFC?=
 =?utf-8?B?V3VvMXNuVFpsRHdEMlhXNTRyckFBY2RlZGprQWkrK2NLT0RvN2M4Y1JUaExq?=
 =?utf-8?B?WTVHNmxrR1ZLV3FmSEsvT3M5YVhGdUthQWN6RHFIOE5BSnVuKzhHbTdxTXh0?=
 =?utf-8?B?c01SaWtpOXB1M1pTZWphbVVUT2RLQmNWeURpb3NLUnJDcGR3ZXZzRGRtL2dD?=
 =?utf-8?B?dEh5a2J0dGVleEtiMGVJZ0E0NXI0YnJBWUpQeHNJMVlibDB2TXR4NDcrekl5?=
 =?utf-8?B?cUdnN3F0Uk5EdFhBVGtnWTNoMDlnWWRvRzBTbFdYRGVJbzN6bWkvL0JHWlNs?=
 =?utf-8?B?TzRROVhVakFzNE0zTTI5YTc0Y2NiSnVCc21GNGJVNEdnTzYxcUVVcGlOL24r?=
 =?utf-8?B?eDZ4dlE2T3VmdDU1OFBOUitrTENkK0RrRytCYmNGVFZWWW9xaVlnNW5vTjk3?=
 =?utf-8?B?OFBhQ3Z5K1FvRmppdkhXOVpaYzNFZnRkT0hCZFRrZVRNNHBsVXplZUxMMXQy?=
 =?utf-8?B?SWlhZ3pla3F2c3pJanMyRGRvMXlZRzRabUxJKzU4TWN2dUZvSWZTL1l6bXdY?=
 =?utf-8?B?RTh5dnl0ODJwM3ZxQnNCS1Z2YWkzUnBPVGpLUlJHUkFrOHJUNm9yTCtCZVFW?=
 =?utf-8?B?K1ZUbVUvOGwzY3ppZzM4UkpMd01aRDJMem5UUmtVYmlsejVlWTdEbDRFbWtX?=
 =?utf-8?B?Z25UTXhkMkN3Z3ZINDNrVXBUK25ZRThlSFRndEQrcVpNWW9HL1EwaUxaRGFh?=
 =?utf-8?B?SUNOWHZ3OUpqR2M0UzIvVkhUMTdDWGZBVUt3VytqRVZGSUNIdSt0c2ZtMG0y?=
 =?utf-8?B?T2wrOVB1dDM3bjFqSEVOMzN0eFp0eXFZNld4K2huU0VOaDNLaVlRWWs5UWZ5?=
 =?utf-8?B?SkN4MWpZQW44TmtwekczN2RIT2EwdDNaR294b3YxMUpCeGRXbXVuZy9PcjFS?=
 =?utf-8?B?cmJJa2d0Wi9wU08zbUpxdm5BbktQVjYyUXFhRFdaai9lRkc3RVpmMDN2Y0Jv?=
 =?utf-8?B?ekhsWHdaT0xpd3BadEFVWHM4dHpUOWl6L1JRczh3WmJrc3dFN095RXF1VWM2?=
 =?utf-8?B?a3V4ZW9VSnkzb0VYaldpQWpKODVYTFcyVno2elg0clo3M0E1MXN5N2U3aEhI?=
 =?utf-8?B?dFQxbmh1NjZRUlI3RHRzSGx0OXNpMmI0VU1ab0Z2WHpCT2h0VVZTcVNhYkFM?=
 =?utf-8?B?Qnc4elFWT2lXamh6VDFYQVFqRXVGd3V6VFNNSlkwSjMrNjVlUlNtaTlZZTNt?=
 =?utf-8?B?em1QVlhUYnQrajdURHUvYkRJNUhYdFpuemFndEtGZWNreEdBTVVJeXBla3l6?=
 =?utf-8?B?a1ROODhHdnhlZUpJaUxGaUl0V3hXWWw0MW91ZWNFbWFUcm51NjRoaXR5Zklx?=
 =?utf-8?B?dGFqR210NFFmRTZQQ2l4V1ZKYUcwemRxWGlqNkhvZW0xSHduK01kSjhrNm9E?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34457a6c-dead-4649-b9fa-08dd54ce9def
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 12:27:34.9344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8Fx7S5jUqJ/XzaXo2fptSgyyZ8U2xV+9d2iJvLa7vzoWzPlbldbFWJKxiP0wBJlMuNEFqsiorRjTcoclO20xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6661
X-OriginatorOrg: intel.com

On 20/02/25 15:16, Xiaoyao Li wrote:
> On 1/29/2025 5:58 PM, Adrian Hunter wrote:
>> +#define TDX_REGS_UNSUPPORTED_SET    (BIT(VCPU_EXREG_RFLAGS) |    \
>> +                     BIT(VCPU_EXREG_SEGMENTS))
>> +
>> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>> +{
>> +    /*
>> +     * force_immediate_exit requires vCPU entering for events injection with
>> +     * an immediately exit followed. But The TDX module doesn't guarantee
>> +     * entry, it's already possible for KVM to_think_ it completely entry
>> +     * to the guest without actually having done so.
>> +     * Since KVM never needs to force an immediate exit for TDX, and can't
>> +     * do direct injection, just warn on force_immediate_exit.
>> +     */
>> +    WARN_ON_ONCE(force_immediate_exit);
>> +
>> +    trace_kvm_entry(vcpu, force_immediate_exit);
>> +
>> +    tdx_vcpu_enter_exit(vcpu);
>> +
>> +    vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
> 
> I don't understand this. Why only clear RFLAGS and SEGMENTS?
> 
> When creating the vcpu, vcpu->arch.regs_avail = ~0 in kvm_arch_vcpu_create().
> 
> now it only clears RFLAGS and SEGMENTS for TDX vcpu, which leaves other bits set. But I don't see any code that syncs the guest value of into vcpu->arch.regs[reg].

TDX guest registers are generally not known but
values are placed into vcpu->arch.regs when needed
to work with common code.

We used to use ~VMX_REGS_LAZY_LOAD_SET and tdx_cache_reg()
which has since been removed.

tdx_cache_reg() did not support RFLAGS, SEGMENTS,
EXIT_INFO_1/EXIT_INFO_2 but EXIT_INFO_1/EXIT_INFO_2 became
needed, so that just left RFLAGS, SEGMENTS.

> 
>> +    trace_kvm_exit(vcpu, KVM_ISA_VMX);
>> +
>> +    return EXIT_FASTPATH_NONE;
>> +}
> 


