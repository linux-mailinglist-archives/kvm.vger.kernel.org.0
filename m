Return-Path: <kvm+bounces-23610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5362694BB0F
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 12:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA02A1F2668C
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 10:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C85618B497;
	Thu,  8 Aug 2024 10:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YvJWLg5Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C34518A6DF;
	Thu,  8 Aug 2024 10:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723113110; cv=fail; b=TytU+Q5NegCf5aPET8L5EoatJXQJxnkkqOlnD+oVEiRCSdIPqWOQxACvEUwJWPnEgklNtWq6I/3LubXbHF0nBzqiwDrR2YTPIdvDxguXGABJHdqNZny/QdTSoURKglKotPwL8T38gIMcflpPt0uk8V8m2eknk5P1AtyqsLVOiO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723113110; c=relaxed/simple;
	bh=0sMgWYla97uZdS8PY7oXH6zeGlKN7UCJ6fkij4hEngk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JMtgIL6DIMmvEZLfLFdretlQnjBm5dwLOqUaBSVLocAZKxgANgT1FwLDT78bHxPCU5X1VZ5+VNvQCWC8kuunovrrOr5sjbDix2H8B05Yr2ewrvWzqKqwGhlIK1GbqVJBlEwrsfGKTPCAFUd350tCrSm5NbSCyNlmtPzE+NvhKCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YvJWLg5Z; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723113108; x=1754649108;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0sMgWYla97uZdS8PY7oXH6zeGlKN7UCJ6fkij4hEngk=;
  b=YvJWLg5ZnsrYAPa3tTFbBstIwMDBhHMRWKjmW1UG+2I7LF3JT0BqFHMR
   sS5QzQW/Wd2f7ftzCuf1nqE2V+5BicQOXvQVEkpaNts3rh0IwMIZHvlma
   AmJMyv+z1u5r9ZpPJ/UL0w4cbvshT1izPtXMNGmYg4gfU8YwVCJv1aBc5
   BWWnki0ZhX+1xB6M37yiTDMiTLLRNdh3S+vSQpYumgXBQ0Cb2LALkWl4y
   0X0zpKjUixDBJ0LmMiQkc0ZcnnlxcRyNp1WEEeOzVSBiKk94LZb++/T8F
   Zf/lcN8+zxQKI6GdPzmdcU4DmitmPFPYttl299IetYheIJwp2GB44QlH3
   A==;
X-CSE-ConnectionGUID: TsvdJqo+SJ29ywPiaUHBDQ==
X-CSE-MsgGUID: Ac7I9OO0S2u4qvAPi4ZwjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="32635284"
X-IronPort-AV: E=Sophos;i="6.09,272,1716274800"; 
   d="scan'208";a="32635284"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 03:31:47 -0700
X-CSE-ConnectionGUID: am1Im+wJR8Kwz1QH2YsRug==
X-CSE-MsgGUID: iLJr4Q98QOqBayGTxFK/KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,272,1716274800"; 
   d="scan'208";a="61276395"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Aug 2024 03:31:47 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 8 Aug 2024 03:31:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 8 Aug 2024 03:31:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 8 Aug 2024 03:31:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GLHV3RnvuWji1nsXUF2PE9POWtaRJLwgWVtTd+p5nBl5fNyc5AGcoI0/kwzR9AhQ4sSw07nSAuc7uClyP8LVNt365AjrOzJPeJMQPTJzhauA7x0Sxxp8anKiBbgcwYy/Ph+t0Ha1yI5lvlIfXqsi66R3psyg52Zh9tOv8RkJfC5gmriLXZABHxbyZnlGYsp/jMmDtP366oCW0Go0zkEifOVNeqsuhMoo8u0lu4c0ykTZlzBG+/W+gmP3NeIVI7SzaO+vShveAqnRBlxW8OE4Gujt565o4qlbfOVHRLYL4hni9UOeg89/Eh2Gx3PR+bSvXIjEnE2vkBEaG6XsYodIAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gys8SJ+LY/liAp28GIom4YktPm9pXK4ZwUnKenqO8g=;
 b=umxjwFwN/WgN7imZsaIhhboRXTFjzdJI3AViAYZo6SFZzNRnMuoMLsv6liU1SPgbmd7bLGqpdG5FtoIxUE1prkNELCjo0p2PrJEeNDfyhEFY7hvhmd97fHG+qvwI95U1Un/BwUJpy/COruD7uNqMHv5v+L8FWrPAKZ+1MACoF1wDlYirivI5hz66LU0LfpYHR4GYYiyCUn12KVuHFLtRUHs87Tyz9d+ZOhTnVeKLSkgMjBRrv335q84i2nFWtU+H0/iqb9bP8C52j4kT+smvpI8Cvh+fDB39pYqdTOa6d/a8yqkqxPdvPPrmadwpaGd/Tt68KBZm3ZDzlcMNRcT0kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SJ0PR11MB5213.namprd11.prod.outlook.com (2603:10b6:a03:2da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Thu, 8 Aug
 2024 10:31:44 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%3]) with mapi id 15.20.7828.023; Thu, 8 Aug 2024
 10:31:44 +0000
Message-ID: <0e36f025-9a8f-4f75-af4b-bc6252c29abe@intel.com>
Date: Thu, 8 Aug 2024 18:31:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] x86/virt/tdx: Print TDX module basic information
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dan.j.williams@intel.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
 <1e71406eec47ae7f6a47f8be3beab18c766ff5a7.1721186590.git.kai.huang@intel.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <1e71406eec47ae7f6a47f8be3beab18c766ff5a7.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:4:186::8) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SJ0PR11MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: e98f660a-983a-4f95-2d6e-08dcb7954c3f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?clRJdVdXcDVDcnRWbTZWR0hBRlJiZnNXY0pNdEVYdWZiOTNpQjFRczRkN1ZP?=
 =?utf-8?B?b21Ca3k4MmJNdDZyM3V6eGZVQWM2aVJiSnJsN3F5R2xoNnFnRWRkZlAzZC84?=
 =?utf-8?B?U25MajF3UW9rbGp0NGZMd0NxZ3RYYzQ1eVBRcS9VZ1BVZUpwK0dYUE11RWFa?=
 =?utf-8?B?dk1JTG1uSGZzckJvWHFzc2gxbDZmZHlwaFpiMTdQZzBUa2ZqWDhsRy9qTERy?=
 =?utf-8?B?cjlyZ2c1cUpkaHY2RE81RnlvS0hNUFpvNnJsSGZHcmRwTmRIemdkMHFEamJm?=
 =?utf-8?B?U3RySnZIMkpJM3ovOFJqUFRxVStwQzdzK09rMXN6bkpLbEVqWC9UM0p1UEUz?=
 =?utf-8?B?eGNwK2ErZHVGL0xCcmhsNWx6VCtiSzUydVpiRVZHNjhraEE1REFWZCt5Ynll?=
 =?utf-8?B?QmpKZXhlaXJsemlLRHhxRXJGYVBna0NvYWVPNmpGaHByNjZEOWwrcjlDRC9Q?=
 =?utf-8?B?U1Y2Rm1ETGtsTExLT29hQkQrZDJUaWVta1BBQjhvSEdDV3Y5VG92alByVjM0?=
 =?utf-8?B?YVQxREpZazF0RFNiTjNwZzBGNjh0RmRRT3RGaXVROEFFQTFFZ2tSSklZZTc0?=
 =?utf-8?B?R1RyU2l3dW8wdTZ6bEhBU0ppYkdPQStYaWxJdkQ1NlZYK1czc3J2QjdXT1Jz?=
 =?utf-8?B?STJsNmJMdSs1aDd4NW1COXEzUmwxRVB1WklGZkxPV2R2c3huRUtWQWU4YmU4?=
 =?utf-8?B?dFhkRWhtUlE3ODBYLzJQNFZFaXZoai91K2F0YUNUK01DRlIwWXAwQnphZjdV?=
 =?utf-8?B?U3ozWitZeW5WaEEva3AxUUZkcjlWM0srRWk2SllVK0dZV254RXJLU2xHWGF0?=
 =?utf-8?B?a3NkL3BnalM2RlhyRzJzNG1wUkVPWGlCbjdQclBYZzFrVGtydWJJdEY1ZGFK?=
 =?utf-8?B?bGxXUHpUNHVjRXdyVVJaenI0RnNSbUIyNnhZMmgreFkyUFFuNU5tb1JhYnJO?=
 =?utf-8?B?UU1kcDBraHVDSWxYK241aXB5c2kreG9saEVFZk1ld2RhWVZ5SW5kRlpyVHpG?=
 =?utf-8?B?QTZBTXBxRW5zNnVOZXhsL09MaWw5QTIzZVR6bWtCQlVyd3hnQjUweVpjREhn?=
 =?utf-8?B?S2hRcGtzVVo2V1NkR21zbGlUK2l2YkVDV0doa2VFQmd5V0w5MTFYeks5ZXlx?=
 =?utf-8?B?RWg4L1BrWWw5UUhUZHVYbzhrZ1A2YVp4TTdTQUt5V1MxS3hZMGhMcHpKbmZC?=
 =?utf-8?B?TWhLdWEzeStxcmlVeTQrT3F4VXExTDkrRmxVZnpoMUZrMERhKzhtejBOUHJk?=
 =?utf-8?B?bzNiMjVncWdVUU9jSDl6Vk42K1NzdnJMaDRLZWNRQjRkaVFXYUpJTUtQTUw5?=
 =?utf-8?B?aiticXB0OSs0cEtrbFJrSkc5OFRkWXhucTU3SGI3RG0vN2xmZXpWN0t4ZW9N?=
 =?utf-8?B?MkY5dXdLNldXbmlBT05JZVNTZ1hPaTFhTmFPWGtIVnVLNVhVYkw4cjNnbXJ0?=
 =?utf-8?B?bWZwaDZHTnFTMHpxYTRYcDZzL25aWklYVEptWWJJR3daMFJEM3RiNFUvTzJ4?=
 =?utf-8?B?VGZESWtCVVpSTEV4K1NwcFBhakluS0JJWVAraWRZd3Y3aHJvZ1pYWjF4azNB?=
 =?utf-8?B?NjcrekpPenRBaytsWlRsWFhmN3ZPZkJITHVwWHlIWnFHNC9WQStqbTl0bURD?=
 =?utf-8?B?Uk1teFFuK0FpOEdIMEk3RFRhb0hYQVdiYXJXb05JL2VacHFzcEdyQ3RMb3hJ?=
 =?utf-8?B?elo5d1lXUXBxU1o3WExCN0VIcHZxRjdrUk9NcXF1VnYyT1BkamlCZVFyNUpE?=
 =?utf-8?B?LzNLblZ6L0FQcFo5Nk95MVNQMGNULzZ1M3Yyc3crMDR1c1p0OERtMXFYTkdv?=
 =?utf-8?Q?Ohld4Pz3RfAg4lDilXlsbLkcPyRLqjA22Y4AU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NU91ODh6M1ZsWW1iNzN5NzQydEI3cFplMTZtYUt0b1c3VGQvTGZHSDBzeHY3?=
 =?utf-8?B?VmxMbUwyZ2U2dUxwUS96T1hENWlnaFhPM3l2QXAyblVsRmVxVnpNOENvc3kz?=
 =?utf-8?B?WE95M0o1QitxNHA3QmRwZWxQb1lxMHlQM2NFK0txNXl1d2Jjd1BTeGNxMnE5?=
 =?utf-8?B?Q1J4bGxsUVFxNVh6TFRUOC9ZcmdtMkExNHk3azh3UGpzbU5vNnphOFhEVVdD?=
 =?utf-8?B?ZmllYU1hVkJZbytBZlorQld1aVVndThCOUtrT2tuM3I2VmZRand3Z041UFBR?=
 =?utf-8?B?NWF0YzA0ZWxuL29WUDhLSEs2SGE3RlFTdlBnQnF4YmFjUjRyZGYrdlQ2QkNm?=
 =?utf-8?B?Z1hrM090VTBiZTFNRkhFWGdtTHgvVmlLM0NTWm9aSzZ4VU5jaFVSbks0SU9s?=
 =?utf-8?B?bVl6RkNpQ3Z0VDBBVkhHa0hZMFFqdGRWcEh3WGRTT05YQTRVOUJtZGZ0bG0x?=
 =?utf-8?B?SUl4blEveGFwbHplVHNIemtENElaa1psQzNoaE11dWhob0ZQalV5VGk4SjAy?=
 =?utf-8?B?bXp2MzBCU1FQTURUTXZvWWlOR3JuQzk3V2xyVEpob2FxaDk0eW5BdmdPRlA5?=
 =?utf-8?B?WlFYcXRkdy9YK2FhNVYvblBPS1RjMDJMQUhaK3B1MnFZTmFOWkhLMTgxdHNU?=
 =?utf-8?B?UkVZN3hLTURYUllVSm1qOEFFUkl0eTFSYzRkM2pwdk1iYll3Ty9Jc0JpVEQ5?=
 =?utf-8?B?MHU3RllkWWlOeWx2QWJSYUo5Zy9sWFRhZmF4blNMRHdvcjg4aUZ0ckdKeFdX?=
 =?utf-8?B?WFJNZmRKOU1DSVV0dzlscGEvU2pPaiszdE9lSGQyWnZYRVhwRWZCUlJuM0VM?=
 =?utf-8?B?UGtYQ2Z5dGhKUGJ2bDNYT1JyUlhBaElyOVlMbnZLaFNETm5GTENucUxRdWda?=
 =?utf-8?B?MWxKaFIyYkR3UmtMZTRrVUFVZ01DWmJINnZ1Sy9jUE5xZkI5YXpQQWdtWHlr?=
 =?utf-8?B?TlhKMW4waENoTDVhMENERkNKZUZTTnRxM2M1RWJYa1NmRlh5U3Q0TXBxdHRu?=
 =?utf-8?B?Q3VvZjA5OW02QTZKYUR1bTJKMUxjdTVod2tFeVM2SmJPZmYzRnN0UGZhTUdv?=
 =?utf-8?B?NENySUJoQTkzd1hTQXZCK0tWa1VkdHFTVVdlZnQzR3VCbDZuTzIwd3l5V2Vq?=
 =?utf-8?B?d014TGlUZllvR1NEaU9XQ1d0UVkwWE0zb05lRUlFcjhHMjdtcTdsc0Flc3Jj?=
 =?utf-8?B?R3pEZHA3RGd2ZWVOQUw0ZmxBbW9HekY2cFBySmNkOCtNRUd6cGV3bE9qSTU4?=
 =?utf-8?B?dEZGNlpySXkwQUxnWi8vMGpJc0NENG9GOHlzak8veDhFazB6KzU1SXBDM0F6?=
 =?utf-8?B?b0pvbTREdnkxM29LaVJwQ0N6cHRySFkyRGxEcjZlakZhUjBlcFIreFhSbi9Q?=
 =?utf-8?B?MTJBN0xxMUgvaXhWK3MrMk4wR1A4NGhuOXQzOWhGK1c4M0dEamxsbU1CYk1v?=
 =?utf-8?B?VWhzZUl3MXpsNEVKaGYwZ1JlTVpqRmtvdWtDS1FPU2oxVVpxOVdMelJQems5?=
 =?utf-8?B?eEljeGxQb004dzZaZDVsKzRTc2ZKckJhVjkxNHU1Sm8ySDlkZGFVQUlQUWNr?=
 =?utf-8?B?TXJjNlRzN0VjTzZzRngxdXJRM2NIM1hjS0ROQnBUK3k2VG0wL3J0VlZqMUJr?=
 =?utf-8?B?NGRDOXdBaGhDRmdHZ1BsWDVNbVpsS2ZRTWJkRTdSZUZuU3YrK1BJZTg5Ynhi?=
 =?utf-8?B?M2toYW5mZFc5aFJMdTdWalJFQVpTbHRhVXQwRWxIWjZxMnV4Vk02SzNlRld4?=
 =?utf-8?B?NGFyWTRaL0Fsa0pFQVZ4aUQ0Nk9tai9DYXBQbHFrc1hTSkg1bmVNV1J1N1Ny?=
 =?utf-8?B?RzZwNzBlOUsvQzdIWEtYRHRXdWswbjNvczJYN1FhMXNTWGFKR3JaOGs2S0FF?=
 =?utf-8?B?cU50SE5kOEFCYWtIQ2MyR2hoazhLMXVDUytJdGRudDlESWZzS0dwSTMxQ0ZI?=
 =?utf-8?B?eWsyZXRkZXhwMGVsQmRTNWlrUlBKMkQ1VllrY09idGRsME9xbjNvSTBRZ3Qw?=
 =?utf-8?B?NFhGbE9JVVV1VnFXU1JSWHYvQjdjWlYyYUR2UXRYaE5ZOEFuQndGM1FmN21H?=
 =?utf-8?B?U253Vld5U3hyakZjMXhZQU9YUmllTFUxUnJONlRtNXcwZnRMS0VnWWtSU2VO?=
 =?utf-8?Q?gakASjGKqusAsM6SZy3atEvfv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e98f660a-983a-4f95-2d6e-08dcb7954c3f
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2024 10:31:44.0314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WfDlvCIKeUHBRC2Z9BEK+eJe13NbJWoc2qXWab43hb27wqKipWmvAlOvYEfcWRRpHUks4w1PmAz8KNLzNIXT4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5213
X-OriginatorOrg: intel.com



On 7/17/2024 11:40 AM, Kai Huang wrote:
> Currently the kernel doesn't print any information regarding the TDX
> module itself, e.g. module version.  In practice such information is
> useful, especially to the developers.
> 
> For instance, there are a couple of use cases for dumping module basic
> information:
> 
> 1) When something goes wrong around using TDX, the information like TDX
>    module version, supported features etc could be helpful [1][2].
> 
> 2) For Linux, when the user wants to update the TDX module, one needs to
>    replace the old module in a specific location in the EFI partition
>    with the new one so that after reboot the BIOS can load it.  However,
>    after kernel boots, currently the user has no way to verify it is
>    indeed the new module that gets loaded and initialized (e.g., error
>    could happen when replacing the old module).  With the module version
>    dumped the user can verify this easily.
> 
> So dump the basic TDX module information:
> 
>  - TDX module version, and the build date.
>  - TDX module type: Debug or Production.
>  - TDX_FEATURES0: Supported TDX features.
> 
> And dump the information right after reading global metadata, so that
> this information is printed no matter whether module initialization
> fails or not.
> 
> The actual dmesg will look like:
> 
>   virt/tdx: Initializing TDX module: 1.5.00.00.0481 (build_date 20230323, Production module), TDX_FEATURES0 0xfbf
> 
> Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m352829aedf6680d4628c7e40dc40b332eda93355 [1]
> Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m351ebcbc006d2e5bc3e7650206a087cb2708d451 [2]
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v1 -> v2 (Nikolay):
>  - Change the format to dump TDX basic info.
>  - Slightly improve changelog.
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 64 +++++++++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h | 33 ++++++++++++++++++-
>  2 files changed, 96 insertions(+), 1 deletion(-)
> 

[...]

> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index b5eb7c35f1dc..861ddf2c2e88 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -31,6 +31,15 @@
>   *
>   * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
>   */
> +#define MD_FIELD_ID_SYS_ATTRIBUTES		0x0A00000200000000ULL
> +#define MD_FIELD_ID_TDX_FEATURES0		0x0A00000300000008ULL
> +#define MD_FIELD_ID_BUILD_DATE			0x8800000200000001ULL
> +#define MD_FIELD_ID_BUILD_NUM			0x8800000100000002ULL
> +#define MD_FIELD_ID_MINOR_VERSION		0x0800000100000003ULL
> +#define MD_FIELD_ID_MAJOR_VERSION		0x0800000100000004ULL
> +#define MD_FIELD_ID_UPDATE_VERSION		0x0800000100000005ULL
> +#define MD_FIELD_ID_INTERNAL_VERSION		0x0800000100000006ULL
> +
>  #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
>  #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
>  #define MD_FIELD_ID_PAMT_4K_ENTRY_SIZE		0x9100000100000010ULL
> @@ -124,8 +133,28 @@ struct tdmr_info_list {
>   *
>   * Note not all metadata fields in each class are defined, only those
>   * used by the kernel are.
> + *
> + * Also note the "bit definitions" are architectural.
>   */
>  
> +/* Class "TDX Module Info" */
> +struct tdx_sysinfo_module_info {
> +	u32 sys_attributes;
> +	u64 tdx_features0;
> +};
> +
> +#define TDX_SYS_ATTR_DEBUG_MODULE	0x1

One minor issue, TDX_SYS_ATTR_DEBUG_MODULE is indicated by bit 31 of
sys_attributes.

> +
> +/* Class "TDX Module Version" */
> +struct tdx_sysinfo_module_version {
> +	u16 major;
> +	u16 minor;
> +	u16 update;
> +	u16 internal;
> +	u16 build_num;
> +	u32 build_date;
> +};
> +
>  /* Class "TDMR Info" */
>  struct tdx_sysinfo_tdmr_info {
>  	u16 max_tdmrs;
> @@ -134,7 +163,9 @@ struct tdx_sysinfo_tdmr_info {
>  };
>  
>  struct tdx_sysinfo {
> -	struct tdx_sysinfo_tdmr_info tdmr_info;
> +	struct tdx_sysinfo_module_info		module_info;
> +	struct tdx_sysinfo_module_version	module_version;
> +	struct tdx_sysinfo_tdmr_info		tdmr_info;
>  };
>  
>  #endif

