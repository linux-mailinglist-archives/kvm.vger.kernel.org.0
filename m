Return-Path: <kvm+bounces-63737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E741C701F0
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 17:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 043A34FC1B1
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 16:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E0234106C;
	Wed, 19 Nov 2025 16:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JppzgHF7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1829327C12;
	Wed, 19 Nov 2025 16:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763569227; cv=fail; b=BEx9JsyCXMbpdO+BgJGz+MY5DayZuzwtyeNJQHaYyMd0XNC4w82/UFFFmw4xJT7OxpGQ7gkpvw3kzh4ANRaKakmIAuyqq6eebztkBC5Sr6UWjgi4IznmT8p9+j2BhMq7QT2KOGRieRDOncKu+WkfJDCjVVJV3SzLtji4tMBH1Ws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763569227; c=relaxed/simple;
	bh=72De0wkBcYU66waacOyg7wFck76U3TdM8ZD1/J3QMYM=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=ayqKWiwgKyVXJQNxSvhGeRMZQrnHE+21fXY/Tkna3rOPwzdam6esWx7voXAVDwNAPhPp9L3Yy6kFP9ZNuWjWnUeoDTZshTUxsTNEE+uLBUX76/HcGX1Qzf2vZFuLKESiw6UDgbdcBrGEt2BJ1khj/Mq9q8cHRgfzU21y9WCTNXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JppzgHF7; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763569225; x=1795105225;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=72De0wkBcYU66waacOyg7wFck76U3TdM8ZD1/J3QMYM=;
  b=JppzgHF7w9e7acG5E/1wlcxjIZ4+cMP/SHKrJIGwVFgBfzda+mx8bGeZ
   zhsjZ/KVSiPhRfSAG7zOfLXYYEX+TOWd468aQAmdzH2JXbZycZ+oJzKuN
   d9eKJ815+G02BC814VOIqSMjMTY60/sjApCgLwgkCZDu1/kaNT/pvrUDS
   FLwRs5J6GEL6iTxwcGGC0vY7X6V9nZNM5YZIi3rXZsvMQZy3eeM+0gVQh
   txF1x2UF+qmONfzZLNSMA/duxERZ8cTFYjzqgTAFctuogEtuJ+e+gL9DK
   BIcWwUAdYkVMzPIzaoCtT0WlrxB5ezNTfwlNO3kxB07kebQRMrv4ZU5GK
   Q==;
X-CSE-ConnectionGUID: ig2zKUJtTPSWrKY4H637UQ==
X-CSE-MsgGUID: DG4cxfFdTbOtOGIiGn+RQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="83240244"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="83240244"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 08:20:25 -0800
X-CSE-ConnectionGUID: JCw4TWFPSFy7/9LWwlfQCg==
X-CSE-MsgGUID: dPhJkR2XSPesbi6ZaKQxGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="191901840"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 08:20:25 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 08:20:24 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 08:20:24 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.45) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 08:20:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SEejPnA6HFudP7gRoKt7mZftRUac4L+oeTdZ2kOO5SF1uGyYpm9ZLipwYj9LdnuvGPwSHJkwPhFKqLSD2UnHenN0dHpj9RHc6F1VqDl/lCQA5AJaT/N7H40fFY+UUrN+1OP71nZ+m3Mb5Vcmb2y83BFMm6BJ9J6VouA6NJyl7ZEBFwGAPG/G5GzQGq20G7EDhIUL/LOnHxlsjZewobacvRMIiY6CEcUZ+9CtgNPBEPfVMjdc/6J838is1G5Hl7OV8Ke6eOaxMDBYy7ZNCEAghl7dhLt2WpRCq2ZRcRf8Vzx6s3A3aLZUS23XxgtXoa5srdbzgm2Q9o10oyhBlBqcug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6HMw4KDuoRHj3kSRq9ZOK0F0XdwB+aXDHXaFEsRG7nE=;
 b=r693nAIlWCxsoZTCSeUm9SCX13EJzUNOL4rlWK89zfckwLn6yA9rwNxjaOw1aGdhtmqCEIHkrPa2zlYsA/fee1yHSpGzD5DCBLGaAugGSBeMHrJmanILlTvuGZZEd/4xnjThCUvWjHQgbKuBEWTSRq/2tjoklHBJ0SgEivr0ydqNNVpz+UlJbCSefgoZs2icefwqHsVM6EU3mQHBgD3Q0w34MWApHZ8GeDjSbl/aNThAQSmu0E6NU0M8Z29kCRBiRh6oRSODQQ0UOvoEtmEgwpjoVSbei6qF2Sj4n00zVLoP3bnYNUjBeH6+1hkWrz38EZVfLRV7/2BeBMqf1PlYZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB7825.namprd11.prod.outlook.com (2603:10b6:930:71::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 16:20:16 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 16:20:16 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 19 Nov 2025 08:20:15 -0800
To: Dave Hansen <dave.hansen@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	<linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>
CC: <chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Message-ID: <691dee3f569dc_1aaf41001e@dwillia2-mobl4.notmuch>
In-Reply-To: <70056924-1702-4020-b805-014efb87afdd@intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-7-yilun.xu@linux.intel.com>
 <70056924-1702-4020-b805-014efb87afdd@intel.com>
Subject: Re: [PATCH v1 06/26] x86/virt/tdx: Add tdx_page_array helpers for new
 TDX Module objects
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:254::6) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB7825:EE_
X-MS-Office365-Filtering-Correlation-Id: 61801488-8055-4933-059d-08de278786a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?REs4UGRKR2ZCOGpCWWdCSmVPc2orVVNtYnNBOHg0RDNoczNISE9BOG42ZXl2?=
 =?utf-8?B?Vmoxdk92K2VTU3duRVZmR21pRjY1dE8zUWlTdUgrOWJ6cHhNVzlSWjN4VUM0?=
 =?utf-8?B?TS9PMHRqVlVBL0dqUmMwOU1vOEdocFl1aEY0RjBSeWZMeHU5NUZ3WExhN3JV?=
 =?utf-8?B?cTZQcmN5OExZR0ErazB2enRYZ2o4L0lrZmZ3TVBHRGJMYXpoWm5DNWd4d2lJ?=
 =?utf-8?B?bllvajdJaUxTaXVIaERJejlTYm1rR1RETlhxa25VTDZUTnBzRDh6dkg3SVhC?=
 =?utf-8?B?bHlVV2kxOGxpRnNQT2VmMzZaenVjSWg0d1p4Si9LRG9WVjZsRzQxdXk0SGEz?=
 =?utf-8?B?S0g2NkIrYTdQcEdON0NxaURXb1F3V2MzM0MwWlBnY0x1V0xta1V2dkdxRUhp?=
 =?utf-8?B?Ynhrdks5a2Vta3kwT0lZU2pXUFcydnRibnFmTndDYk8zczIyTWdTN3hGYWtr?=
 =?utf-8?B?THNPVGkyWmpiUWg5anBld1hJbklRcTZHSG1ISkRZaUoyM3AwV3hnc28xVDJG?=
 =?utf-8?B?SjA2RWthM2pLZndtcG9MNS9WMmlFSGJWbjRRRVJwVVNoaHpiaDI3YTJFaVJK?=
 =?utf-8?B?a242NENNbUJRUFBiQXhOWjlEK0tNaG1BcUhpZ0QvNTVDbUNlM2VlTFNxYkds?=
 =?utf-8?B?QzZmYXNaSTJVaGRjSlpadC9RRmt0cy9QNkpvQmxEQllCanNNWng4MmJ4dTk2?=
 =?utf-8?B?WW4wbm5sWGE2TnlJQ1lLNW9LZzZFZkFVeUVJM3FBNjM3ZWhLcTltd0JqT3RD?=
 =?utf-8?B?OHZQcEpraEg3NDI4cUEyQmhseENRWGFiaFR0dzBjNDNRYXAvSXg5OGZoSVEv?=
 =?utf-8?B?WkZ4YjB3Sy90Wk43VU1xRmtIS1RyRlluQWZVQVhVQkc3djBvK0oxb3FCcHNW?=
 =?utf-8?B?THcwejZJVVpqTTJKeTYwQWtWcm1yaFE5NWlJT2FTdm5qM0xydk13TWo5L0JG?=
 =?utf-8?B?emJ2akhvTER5MmdZWmk5VWJQZDA4TmNubldRV2kydlFFaG42WkxyeE84VG5M?=
 =?utf-8?B?MkNxYjlKNWcyT3lpejcyU3l6amg2Vm5QOVZyK0w1eTZudVJJTUFJMTRWQU1a?=
 =?utf-8?B?V1NvVDdSN0wrT1VmWU82OU5KUlQ3RUJSa2NwS0g2Um1WTnd0WWE0ODBTblkz?=
 =?utf-8?B?V3gxM3lJMjhhMDQ4SVdSa3dteS9OM1dtcWJOcWM1M0RDQVQvelFVSDVISklw?=
 =?utf-8?B?V2IxNTBBdDJVV3RnK2lzZ2Y0OG9XSjV6cFpseGNleS9CZzZrYkw0eXRqOVIy?=
 =?utf-8?B?VFlOeXgzWitpUDNVc1RnWEhYdkNBLzB5LzJzb2hVZFJMRW1KUEUwVjN0VFZL?=
 =?utf-8?B?dzBOMnlvOUZ0UGdVM1hUUDl5SVNzM3lGQUs4akJjZTJ1TXVnUFBmYnFERGlE?=
 =?utf-8?B?anZKazZOa0tiUi93eUZwRVFBNEtvdTFkNE4va3RHWkpuOGo4VjB4THpCVHR0?=
 =?utf-8?B?MGxKczByZlJ5L0pVUEpDQjhTUFVlbG1uM2JqTFA3MGZKZ2FlU014cC9wZm04?=
 =?utf-8?B?N2x2c1ZOSUJnbmJuVDFOaFF3K0hzOVpOL0NqRjRHV1g5SHJMVWZ2eXRJZ3Fy?=
 =?utf-8?B?OGI3WVdTaXVCS0dXZWZKbndLM1hpS3BHT1NJTGtxQUFpMWZ2M1ZjeUxxU3pM?=
 =?utf-8?B?bE91cGRlSjJYN1E1N2ZpR2ZLRXBTWmpBb3pwWmJnOUJFK285SWkvS2VNTTAz?=
 =?utf-8?B?T1M0KzRmVGYrRDE0alhnaXppb0QvRGlrQytPaDBlZmtCVlFMamZJN1d6WDJY?=
 =?utf-8?B?KzFuMGdOWURwb0dRejNoRnlveVdPeFMyZGUzYlF5UDl1d1BHUEc0Q0tmcFBr?=
 =?utf-8?B?V0xlaXhQZDQ4eURqaE1lak9adktydlYxVUJFaVpTVklRKytQTHlCN3drMFNw?=
 =?utf-8?B?dCtWZEhvMFhOcDBYS0pNYnVVNDVHUVc3V1U3ekNLUUxrVVlwWTBueFphd2dQ?=
 =?utf-8?Q?PQVUQO57pkP/Pfq8cNQ/0UTn07KBTV9V?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0Njd3FzejZ6aFFYeHVtTnlvNzlUdU5EOGx2OEJlU0RzejYyMEJOai9HTXg0?=
 =?utf-8?B?UllsWFlwRFphVndxd0dqSThGN202R0s3bWZ5NGpzSld0K1FiNFlObHUrc3Bw?=
 =?utf-8?B?RVV6dTVzZDF5SEpsU2dxVVAyQ0hMYVpySnk3Sk1PaGQ5aGhpbHhqN1JiRTJV?=
 =?utf-8?B?eVJvWk5KSk1jdjJvTFRKQ2tzeTZrWHhvb3FzS2VsSUpRQlUrTHJJcW5BTERG?=
 =?utf-8?B?WXlZZWZSenB2NlBFaFRFTFZac3RQcW9kZzlBc1FzRXJUZHVuYVRPN0JEZnA1?=
 =?utf-8?B?Wkd2S3NhWGZPZ1NCWTdNM2FFbUQ1UFFQMXJGTzdaZnRzb2VNdFJoTmtXSnll?=
 =?utf-8?B?Z0ZiMm40SkN3aUZiQTc4cUVGeVViU1NZVzR4bkJCQnZKcTlnaWNPSys0bGw2?=
 =?utf-8?B?UFRCSUkydVF0bGZQUDl0R3ppN2p6UytRcXB1ck1WdEdnT1pURzR3blRmcXpF?=
 =?utf-8?B?b29JbURrRlhqZDNPSlVqL2wxelZjdlMxSVFVUGY2V3Z4WURtM3c1UkZKdWU2?=
 =?utf-8?B?ZCtZZ2l0RTd4Zll1bWhiYmd5Z2hiRExaVEVIeS9jbis3QnNnZzA5Q0MvMmE1?=
 =?utf-8?B?QTFPSG1WZkRtUUlkOUMyTk9HUUtuWUx6YmZmY0hIR29URzJheGQ5RVJGWFlL?=
 =?utf-8?B?cXFDemdZYm9KVEdDN20wdU5TandOc2gwZDNLYVlVMHFoUGlDZmVvQUdjUSt2?=
 =?utf-8?B?MUdsbG5mMTloNDZoVzd2RFFRU0RXLzh2V3RFRVNiMlJpNnArVWt3WmlEeG54?=
 =?utf-8?B?QVU4Q1FMYkh5Q0V0WFpMQkk4eXAraVdGRWlmQjY1TEx5cjhab3lQcDhvb3Fz?=
 =?utf-8?B?ZkwyOW9DOW1UN3dWSlc3d2xkTEhmNkxSQlpPT3FHd254bjUzSDRXV09LNkNv?=
 =?utf-8?B?bUVRdEh5WmUyU3AyTGcrRUdpRzQrR0kyalBPbDVQZ0Exc3VLVlFvRXdXWDhI?=
 =?utf-8?B?MnREelJ5OVN3VmQ0dmNoUUNyQmlzTWhlSVlWRlZ4UXZ1TlR5blNJL0tyZ0pQ?=
 =?utf-8?B?QXprOStMYnJPYVNWUGxUQ1JDZXRURS81a3VYZDVWRVhTSWhUK0JmejJBTFJP?=
 =?utf-8?B?NDZPL0hlUi83UDhidG1odWtiZzQxOFM1MWFqcmZNNGtyQzdTZkJBMnZ6WW9R?=
 =?utf-8?B?TTJuSU9ySlhsZ3JZOEZvSG5XT2E1SElyZzJUajYxRzhxc0tqVThBZ3l2cVh3?=
 =?utf-8?B?THk0UldUTjdjY0dpcW1IUW1icXQ3T2NkSm9PQThKZnQ5Yjh5TEZhL3phemtW?=
 =?utf-8?B?OWtHVWRFYnRyeGEwdW5jQ0k3NHpVdmIzL1NXNUtoRXJ4UzhhRVV0SlNCWkZZ?=
 =?utf-8?B?MjJEVy84NmpKRit5RkRaUVpBQzBUbXJJODZSS2hzOXpvRnhDb0tES0FSWmcw?=
 =?utf-8?B?MUtQZUFtRjREK2tuSDdLOHROZnF4QXVUWFRsSldhVEhKMUpEK0ZCQUR2VTFr?=
 =?utf-8?B?ZGJrOFMwVzBrMXVMRXg5ejViMFFhYllORzc0K1A2YkZYS09sZTNuRk1EQS9m?=
 =?utf-8?B?MXVKaXBwT25VRDgzbFVWQnJ0NGhLMzZwQnlhRXF2K250S0pSQmxRMFJSaDNi?=
 =?utf-8?B?bGlnM2dJMUIweWcrMUVJMnVzeDBVeS9XTklkenR4Rlp0NHp2czZla2V5MG1V?=
 =?utf-8?B?QVFvTEZnc0RsUXFXdW9qakViektNWGFwbk16c1dXTktWaUNsWkFWK3NKVHJa?=
 =?utf-8?B?TVVRTVFxaENWQzFpOTRzSUdmdmxPdWpqdWZiSWRxaXRpc1ZYU3hYV0JzTXFn?=
 =?utf-8?B?d2Y0YVlBbUNFc3p4bXY4S0U5VE91L2tvQjBqald4VDJyUkxFTEU2aGxRaHJ1?=
 =?utf-8?B?OGpsMUp5NUNpQysvVDZCTUdDUjZMa3RVRzhubTRmM0JTNi9FdjVKQy9PdHpC?=
 =?utf-8?B?bk9pUFpDd2M5ODJjUWJySmpLL1ltNGRuejQxcDUySktNakNDSVh4SEFPa0kw?=
 =?utf-8?B?amVRMFo3dngzNE1ianhSMktOVzBsczZBaHZoYlBPK3ZrQzFkTU9ySmhzSmsx?=
 =?utf-8?B?K2pFRWRDeDZUclFJR3BCdm91RVI3dE5CWmRuRGk5Y3FWN1o3OG5tUTA5VHZW?=
 =?utf-8?B?TmVXS1JOd001WXJhWnc3YzFKTGNRU1Jod2RuR3BmTlZ3QlhqWjdEMXp0NlYy?=
 =?utf-8?B?RzdmYytBUC9zYXNzOE0yaXlXZWduZHU3Qjl1QXpGeWdEM2FnejZvZW1VcHBr?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61801488-8055-4933-059d-08de278786a2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 16:20:16.7390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WU1/2JpmEGAWWjffbByhmEIyXJLAuxYRH0ao3xF+EaIym3Zpg6oU+5z1JlabwUpRBZrAC05ji/4ANdrD8sKnOsxmzj6Jfu+n7ELMZu9wEfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7825
X-OriginatorOrg: intel.com

Dave Hansen wrote:
> On 11/16/25 18:22, Xu Yilun wrote:
> ...> +	struct tdx_page_array *array __free(kfree) = kzalloc(sizeof(*array),
> > +							     GFP_KERNEL);
> > +	if (!array)
> > +		return NULL;
> 
> I just reworked this to use normal goto's. It looks a billion times
> better. Please remove all these __free()'s unless you have specific
> evidence that they make the code better.
> 
> Maybe I'm old fashioned, but I don't see anything wrong with:
> 
> static struct tdx_pglist *tdx_pglist_alloc(unsigned int nr_pages)
> {
>         struct tdx_page_array *array = NULL;
>         struct page **pages = NULL;
>         struct page *root = NULL;
>         int ret;
> 
>         if (!nr_pages)
>                 return NULL;
> 
>         array = kzalloc(sizeof(*array), GFP_KERNEL);
>         if (!array)
>                 goto out_free;
> 
>         root = kzalloc(PAGE_SIZE, GFP_KERNEL);
>         if (!root)
>                 goto out_free;

I think this s/alloc_page/kcalloc/ is the bulk of the improvement, that
is a good change I missed. Otherwise, this version of the function is
longer, and I feel the use of gotos makes this function less
maintainable longer term. Future refactors or feature additions need to
be careful.

Please document that tip prefers that goto be used in cases where a
single goto target can be used.

