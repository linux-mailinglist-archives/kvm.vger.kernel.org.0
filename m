Return-Path: <kvm+bounces-34746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C01FAA0535A
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 07:42:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 585C87A2440
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 06:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9C51A83E4;
	Wed,  8 Jan 2025 06:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MqkUqoAt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7597515852E
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 06:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736318529; cv=fail; b=JYYbqIkoXLvgJuW1iQOAXmxZNnAbhi/rIvOENNfAVqa86rFgmURnu1n6W5aLn0QeZK/tVB564s2LlfSZ5829KjKEkNpn+bydIXAITlAWHbaWEl3QeCjqXq7nojncqf0qvEoZ4iR601+qQolS0B7MpycVxwXgUDDxePiw2umknX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736318529; c=relaxed/simple;
	bh=cFQGQjmjqXVsX6DYbpULfMjQAVjzOtqVCPpT0TCg9Jg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nH4dvDHCy3BXrC2rPXi8t2shP456UOwgIuGqpA7r9hfaIGoW+Q2u2UkniduqvDzY001QK1xlSFU+45MKovUBBI39MqpERMZ5+GzlNPdQZWQoHbDjVZ8zgzoseu7nqxztOI/VVnGDZIdzNd1thCupEfDOGfu2LXbtXY6n7JmVoCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MqkUqoAt; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736318528; x=1767854528;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cFQGQjmjqXVsX6DYbpULfMjQAVjzOtqVCPpT0TCg9Jg=;
  b=MqkUqoAtUwPIdKgz90T8z6vYWey+HjygM7tw6exUNqEjZgkJthwBzgvx
   N4bSzxnzhFSAJgONXHo5AlYBjRWx1MFUwq4TSF3MBgS9VFKdgGhrXbYNO
   HCwmBq41cyDRHiyjyu7rmrEWo+Q0NIdNFUqlUF1wEyjDb5b2WIkAUx6iL
   P8KaRhwk/Pa+RpdiP274LxSXF32jN66316kUZ5eQev4azGAdl86SyxtqE
   Hg+yXgHPlT/6asHhguHmutZa905L5GFHHQq/dT7rHkNQEGldbeRktQblW
   2EBUn7UzqZvYQkG29fE6XPDeYI1KON/NJAm8PXr8G2Cgrp7hafrfBWg1+
   w==;
X-CSE-ConnectionGUID: EwrEchbHQ4Cr5vcJU0tuKg==
X-CSE-MsgGUID: oe6s/hM4RAu8pU22gm5/5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="36690976"
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="36690976"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 22:42:07 -0800
X-CSE-ConnectionGUID: yZk3AzCmTeCariFHKtHs8Q==
X-CSE-MsgGUID: A0bnGgexRaaxvKKgEW0pkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="107868851"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2025 22:42:00 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 7 Jan 2025 22:41:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 7 Jan 2025 22:41:59 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 7 Jan 2025 22:41:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kf6fWRVTQcDeFq2bmxPRtUMnWjliKs6eS3izLjajyZFyY97AfY/YcHy1CGElTFR6KtgogkVjmor+kr7R5Hf2wWZ4e4i6HgwdfE06I6FuuAcgszIYsA0csW5Fa4zScIAs5MQx0WvRhIPfunMVxBfNAsXJ6vk6l5ynyk2b+KcP8netDK6b7Dagq9mDYDQw7IKBS4l+KXT0+o33TPtASoL41cyFjyQtOyXwQ1oceplH0nU0FCsMLb8cUa7f/100KSpYu/9kqAb2Pnh4KR0SiVjiBlx+5fLF3gIMNAi/5+O3vsF2Cx5Zxqw7/V+N1M/7+llX0MjaActhFPmPNrABiIHASw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6n9SghpOuTCYUuPIO51iwqex+eTpU7mBcbee8DOz/M=;
 b=qV+ihHdbQxhfDbIKX2JlDwgTh8AlGPauhWuiYF5NJIINi/uLzaUmJeDvUcj8SWhBULt0JTJWgrCPrVLFQUpKWmWAC5Liq5F8UrK/nclV8Qglj9Tp3PBIwBbwPEaDUj4gKdcxmiQ8wiy5Gbcvg+PbbDN9FZhxcYbrY5XGs3HQXjMRSH6I80QDqxX6inMca8YxXgR+QKxPF5NosuOWIx+9ncKC4FXIwnYcSYrzHsKgVTLYSXRoKzhaSNVqlyJL7fSdzXg+x9YxYkFRtLqc5U1roBbw1fVmM9zqtQU31bOvgoeDjA9OG+3whxA44JRZ7k0c1InZFfHD2Qkz2tk4QpzX3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SN7PR11MB6922.namprd11.prod.outlook.com (2603:10b6:806:2a9::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Wed, 8 Jan 2025 06:41:45 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8314.018; Wed, 8 Jan 2025
 06:41:45 +0000
Message-ID: <5465ec6c-aee2-4ee3-a812-830fb069a184@intel.com>
Date: Wed, 8 Jan 2025 14:41:37 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] memory: Export a helper to get intersection of a
 MemoryRegionSection with a given range
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-2-chenyi.qiang@intel.com>
 <30624aca-a718-4a7d-b14f-25ab26e6bded@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <30624aca-a718-4a7d-b14f-25ab26e6bded@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0004.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::23) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SN7PR11MB6922:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf0e3d5-1394-418c-51ac-08dd2faf84c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TFdIQmp2SGdxUWFPNStmbDVaWkdpazRoaVZQSjVBTEQ5T3ZmL2pkR29iUGtM?=
 =?utf-8?B?ZE13SlZtTmliZ1FXWFh0ZjVGMU8xTHJTa29wcS9Zcy9IcFcrSlV1VDJ4bjBE?=
 =?utf-8?B?WGVmWW5xRGdyN0RXc215d1dzYjNxYlA2OU53VE13UHh0eEJPTnA3M0lwQUti?=
 =?utf-8?B?eHpEOVZDbkhlb0o4bkoyY1BkUDk2S2NJUmJYNnowZFBESHZkdVkyd1pYTWJR?=
 =?utf-8?B?N0RqZWpnK0RaVEdvbmxCUVdyamZTbVEvQzVrY2xkdkRiZjNhb3poV0tNQUZU?=
 =?utf-8?B?N1VUbTViNXRQdXFpcjJlQXc4Y3hnemVHNjA4SzA1Z0NoanJSckViekZJUHdv?=
 =?utf-8?B?YStFQ1hGV0ZoK2JBUXpxUkNLVTV2T3FEanRjbEFZRzlsd3gwaUREYm5xRjUr?=
 =?utf-8?B?M1ByUllwQlg4ckZYRkoyNmZoNklrS0FNc1R3ZEpMMkF1a01Ua0FqU3lqR3J2?=
 =?utf-8?B?ZjZOZEQ3c2pxV3FPVHJ1Y3BZa3JrSjNIVlBhd3MwSEdUY0hhSXNLQVlOUEFF?=
 =?utf-8?B?MkNaQys2RDVLa2FYTm1jV3FoZFpKdkRVb0NqRit3RUt1SW1uR2taWmxRV0Fm?=
 =?utf-8?B?UzFRMXUyU1BqWW5GWC91NU15dDBjckVYYVV1c2xxaEVjQjRnMU1mNEp1aTFm?=
 =?utf-8?B?dkQ4OUNZa2VhaUJXWjZQbFhoc2NiS0VXQVFmN254L0M5aVY5WmkwRTdUalJP?=
 =?utf-8?B?c0pack5vQitSVUt3L1NSOFpQZlN0WXZlWkxHK3ZwWkFRK0UrcGJPaUJOSlhT?=
 =?utf-8?B?a2puQmJ1YjNMM1ZuR0NqVVFHa2N4MDM0M0NrTE55L0s2eXNpcG51cWdhN1U2?=
 =?utf-8?B?R0N6VE56YkpKQ28zdzZqRGJpVlFrZU4veTk0dmZ3YlNFdXhpdlhScW1lWXZj?=
 =?utf-8?B?WDVORXdIZVRMbjhPM2lxN1A1STQxd1R0M2xHSnBXUE51UVRleVgxMUJtKzFU?=
 =?utf-8?B?ZE1BLzB2ZmJwa2U1MUpMOEs1MC9yN3lUUTh3Snk1RFlYeml5N1RTV3FlQm1U?=
 =?utf-8?B?aTNkVEwrMFBZV3RTN08rMHlwcDVYVWcyVWNCUXVrV0JnUzVISE1LeCtGRWVU?=
 =?utf-8?B?VVc5RzFzenFIQlYyZnNBTXEzT1dWWlVuQlZ2L3cvdUZhVkc3NE1hSTg2RWc5?=
 =?utf-8?B?Z0NHa3NEYVlMdjRjWXA0aVlzUmUrdnRBYTdra0RUNE5Xc1FNZnVJMCtyQU9w?=
 =?utf-8?B?UjhJVE5SKzl0cGRZZFNqNUQxeks2N2FQb3RrdzNsTHZDVWdQR1dHWm5TYjEy?=
 =?utf-8?B?ejJWNWxYTlpwNlU5OXF1cjJCNVYyS2IraFJYTEc5akh3cGhWMkZCZXErQVJP?=
 =?utf-8?B?UHFsSEREMWlyU0crWVZnRmpvM2JUR0FlcU1vL0Mvdll6OHJGdmxYK3k5TGRo?=
 =?utf-8?B?aUZsYSs3K0ZHL2N1OXJ3U1czZGpzZ3VFRFkrVk9NTS9lamErTjcySzg3RlBl?=
 =?utf-8?B?Rnp3Szdvb0NrZnFUQXd2Z2dsS25WZDBsUTZOc3dSRlJjV2pxbmQxNFdzQklw?=
 =?utf-8?B?U2lUK0szMlViM0ZkVkJycVFzQzg5OVh4SlRIcVhWenQvdW55OTExWlRkUm1X?=
 =?utf-8?B?ejhZRUpDZERKQWdaeWpoWm02Tk13Z0FoRVNVb1lKUkljMG1zbzRSc2xrQUp6?=
 =?utf-8?B?YVV6QWo2cUFTdjQwNmtLOExJSHE4VWNhRmFhd1R2eGhLdWNOQWw3N0pQY2d2?=
 =?utf-8?B?Qk8zV3R5d1hVRmQxdFdZQ2Y1WmtsbzFRckJIelB4MUZiN0JWSnpFRCt5b1o4?=
 =?utf-8?B?VFY5Vk9PUWVHQTZnR1l5QTJHM2xweUs5NnhuNXYrTUhQR2FhbElCMjJzNFpl?=
 =?utf-8?B?RHVIU1BZdjRkaDFyRHlmMmRxZHNUTUtpQ2g1SElSNUlQYXB3Yk43emJCN2ds?=
 =?utf-8?Q?zSBpNqwe1jxoI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b00zZ2RGMkVFc05GVHB0RGI2aUFpMWdFK3FhcWRialZobjROR055TVBYQU9u?=
 =?utf-8?B?MTZIdXNvc1lPeHZWWHFldG4za1lQM3lzM2hMU2JDa1FadkthVlppNTU3QUI0?=
 =?utf-8?B?SXA1WDdHRmt1VVlYbXpKeWhZRFBjMUhCUGNJTS91a0ErK0NUaGh5TzEwUCsx?=
 =?utf-8?B?SnFSUjZJSUFrdlB0WjV4ZXdDM3NTMmR4RFhZVXNVcGpZVlFnQVZkQUxqOTg4?=
 =?utf-8?B?WVZkcGdqMDFJQTVzWlAwdmtUUUVMZWhNR1R3c1JnTmg0SkdVeUhpb2d1QXMr?=
 =?utf-8?B?Q2N6VjJuYmEwWjB5MUpFdzd3RnpMM1Q2WlYrMmZJdERvZU5NRXR1Sm5EOXpC?=
 =?utf-8?B?bnRVV2M4UTQ2WlVKaGgxUS82dWc5N0pldktmQmNEWG5BcGRyM1lpSDBvY0Zv?=
 =?utf-8?B?OFVNYmdLa1labWNsUTFOWUNlYnYxeWdXMHRMdkt6dlJMclhnQld2aitPRENx?=
 =?utf-8?B?WjdOZk1qbFVaa3lZY1l3YW96QzRtb0lhbmpEQ3hGWHV3Tmp4U1hLSnNkMkly?=
 =?utf-8?B?bkRvSk9HSEpSTFNGWkJqaGgvU1MvSkJ3U29VVTJraHc5aFFlalIxcm1sQVJN?=
 =?utf-8?B?UWpkTlZiZm1QQUFCdFRicHNRUkpHL1hvWEdYdTNPYkNGSEFINFBlS3JYL09z?=
 =?utf-8?B?eWpKNkNERVlzVDFoeW5ta3FtWU1vQlVITFd0V0pnTEl6ak81aE4rYlJpVUNX?=
 =?utf-8?B?b3h1NVVnbWJjcjBZaDA0RnJtd2pxVS83VXN4SEVaMXY2VHZRcy9INkFRcjYw?=
 =?utf-8?B?VVBnUXJvZFRkTGZOZmkrSGlNbnlsTHZYODdEbGs1TDJwZkc3UE5heFloUFhh?=
 =?utf-8?B?S3p0NXI1U2hYbWhEYU9DcXJ6YUhLWVV2NFlRc0ZIWjZob3dxWFNtUWEwVEVz?=
 =?utf-8?B?RDcwZUF1c1pYMWJaQWxtSm1lQTBybTVMVXF0MHcvd0JZY2RLYkZ3TURTZnZp?=
 =?utf-8?B?SWVMQ1pLR2REdGR2QUt5U1lPeStteVBnOUlITjg1eXZKVUZTbVhBZzFjSy9K?=
 =?utf-8?B?TUdUUVNwRVBtN3IzT0gwMTVzb1Y4aHNQYzkzTFJhazdoZSttZ2V4RzBWZjg4?=
 =?utf-8?B?SDhsTXZzb3EyYmpkUFVUWCtNYkFjdHB0SEExNi96WG1yNDlBM0hiRXN5U1I5?=
 =?utf-8?B?SHFFMEQweWxvOGJJV2puaDUrMTRKN29mWlc0RUp2Z0JtcGtkUTN0WjhKdlVE?=
 =?utf-8?B?UzRmQ1owcm5yYnJkSHp3K1A1ZUhuN044TEE4c0Zzekd5KzE3NGM0cFh4TVRQ?=
 =?utf-8?B?YVc2RlBVR1htbnRuanVoQVRabXEzZG5UM2hIb1FCODFRZ3R3WUxuQmFpYWox?=
 =?utf-8?B?WUhtcjFCRlFXRmJNUC9relJvY1BMdnJzT040eWtObEtteEJjdlR2NHZTaDFD?=
 =?utf-8?B?dE9zRGw1V0JRdW14SG9QdnQ2cjNSZ3FCNzF4K2srakdiRlBGV0ZDbGszYnp5?=
 =?utf-8?B?eGVhZlEyWFRCU24wem1pZ05mbXFaWXRndGZHSnpOekUrSkpidWFiL2grZ0Yw?=
 =?utf-8?B?UnJLMjZHTUd2aUxFUG1oRlFtRTIzWFVwOWtScXdsdEZzTkhTWXgzaitSYi9w?=
 =?utf-8?B?eTRjWWJQekVNTzRFWGd3Uk42ZmdBMTE1VSt2bXdXUVJoUmk4N1hFblIyenZF?=
 =?utf-8?B?WGt6NmdjcjNLZnU1UFROblN3UHVrRFlzWnBHNHliT1RVeGxJTXplRmYxWStx?=
 =?utf-8?B?OCsxZXZqWGJjR2pzV1lZK0p5TU9PTzU5cEtBcHp6RThockxrOWw2ZXJYVUZ5?=
 =?utf-8?B?WlhaaFV3Z2o2WXpOZWdiSFV1aXNmbVE2TFR1Q3JGbG95d1hMMHlya2J3V1F6?=
 =?utf-8?B?dnhsd1FqVHVMUWc4eDR4Rmt4bDNsMk9seGtYaG9kNFZBTzQvWjMyWTZYbHls?=
 =?utf-8?B?U0ZJOWhmbkVWcWZMWHFHRXN5SFZuS0t4cVZ0cDNpM1k3dDVDcTZNeGVnM0tF?=
 =?utf-8?B?VVdQMzBzaUl6TU4wcS9nNzE5dndFS3BjYTMrZWZRVFRhdXVkN2UwQk1ncHNt?=
 =?utf-8?B?MkwzQXFNMHNBS2RqT3F5VVlvWFhPNDRLK2xLZUxXdGtjRG9QTWo1eEprSUVq?=
 =?utf-8?B?amJMYVYrTzdxbTlOdEtzQzJPNVVKem9sSml5ZnVHcGRZSk5uNlJTR2Zxc0l3?=
 =?utf-8?B?QWs0VHVpOWZCbE5WL1lZckowSEtKU1Zhd1A1R2RJOFVTdVd6WFByVjBVUy9q?=
 =?utf-8?B?V0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf0e3d5-1394-418c-51ac-08dd2faf84c5
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 06:41:45.2637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z5+n8FLlAE02tLPsJ9ILlaitNiI5rB6qSU8UFSHR9oihurrhex1DxBmoWEEUrzeq9Xzv6qkP9TP3zvl5VHQgZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6922
X-OriginatorOrg: intel.com



On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
> On 13/12/24 18:08, Chenyi Qiang wrote:
>> Rename the helper to memory_region_section_intersect_range() to make it
>> more generic.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   hw/virtio/virtio-mem.c | 32 +++++---------------------------
>>   include/exec/memory.h  | 13 +++++++++++++
>>   system/memory.c        | 17 +++++++++++++++++
>>   3 files changed, 35 insertions(+), 27 deletions(-)
>>
>> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
>> index 80ada89551..e3d1ccaeeb 100644
>> --- a/hw/virtio/virtio-mem.c
>> +++ b/hw/virtio/virtio-mem.c
>> @@ -242,28 +242,6 @@ static int
>> virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
>>       return ret;
>>   }
>>   -/*
>> - * Adjust the memory section to cover the intersection with the given
>> range.
>> - *
>> - * Returns false if the intersection is empty, otherwise returns true.
>> - */
>> -static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
>> -                                                uint64_t offset,
>> uint64_t size)
>> -{
>> -    uint64_t start = MAX(s->offset_within_region, offset);
>> -    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
>> -                       offset + size);
>> -
>> -    if (end <= start) {
>> -        return false;
>> -    }
>> -
>> -    s->offset_within_address_space += start - s->offset_within_region;
>> -    s->offset_within_region = start;
>> -    s->size = int128_make64(end - start);
>> -    return true;
>> -}
>> -
>>   typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void
>> *arg);
>>     static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>> @@ -285,7 +263,7 @@ static int
>> virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>>                                         first_bit + 1) - 1;
>>           size = (last_bit - first_bit + 1) * vmem->block_size;
>>   -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>> size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>>               break;
>>           }
>>           ret = cb(&tmp, arg);
>> @@ -317,7 +295,7 @@ static int
>> virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
>>                                    first_bit + 1) - 1;
>>           size = (last_bit - first_bit + 1) * vmem->block_size;
>>   -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>> size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>>               break;
>>           }
>>           ret = cb(&tmp, arg);
>> @@ -353,7 +331,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM
>> *vmem, uint64_t offset,
>>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>>           MemoryRegionSection tmp = *rdl->section;
>>   -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>> size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>>               continue;
>>           }
>>           rdl->notify_discard(rdl, &tmp);
>> @@ -369,7 +347,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem,
>> uint64_t offset,
>>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>>           MemoryRegionSection tmp = *rdl->section;
>>   -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>> size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>>               continue;
>>           }
>>           ret = rdl->notify_populate(rdl, &tmp);
>> @@ -386,7 +364,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem,
>> uint64_t offset,
>>               if (rdl2 == rdl) {
>>                   break;
>>               }
>> -            if (!virtio_mem_intersect_memory_section(&tmp, offset,
>> size)) {
>> +            if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>>                   continue;
>>               }
>>               rdl2->notify_discard(rdl2, &tmp);
>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index e5e865d1a9..ec7bc641e8 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -1196,6 +1196,19 @@ MemoryRegionSection
>> *memory_region_section_new_copy(MemoryRegionSection *s);
>>    */
>>   void memory_region_section_free_copy(MemoryRegionSection *s);
>>   +/**
>> + * memory_region_section_intersect_range: Adjust the memory section
>> to cover
>> + * the intersection with the given range.
>> + *
>> + * @s: the #MemoryRegionSection to be adjusted
>> + * @offset: the offset of the given range in the memory region
>> + * @size: the size of the given range
>> + *
>> + * Returns false if the intersection is empty, otherwise returns true.
>> + */
>> +bool memory_region_section_intersect_range(MemoryRegionSection *s,
>> +                                           uint64_t offset, uint64_t
>> size);
>> +
>>   /**
>>    * memory_region_init: Initialize a memory region
>>    *
>> diff --git a/system/memory.c b/system/memory.c
>> index 85f6834cb3..ddcec90f5e 100644
>> --- a/system/memory.c
>> +++ b/system/memory.c
>> @@ -2898,6 +2898,23 @@ void
>> memory_region_section_free_copy(MemoryRegionSection *s)
>>       g_free(s);
>>   }
>>   +bool memory_region_section_intersect_range(MemoryRegionSection *s,
>> +                                           uint64_t offset, uint64_t
>> size)
>> +{
>> +    uint64_t start = MAX(s->offset_within_region, offset);
>> +    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
>> +                       offset + size);
> 
> imho @end needs to be Int128 and s/MIN/int128_min/, etc to be totally
> correct (although it is going to look horrendous). May be it was alright
> when it was just virtio but now it is a wider API. I understand this is
> cut-n-paste and unlikely scenario of offset+size crossing 1<<64 but
> still. Thanks,

Make sense. I'll change it in next version.

> 
> 
>> +
>> +    if (end <= start) {
>> +        return false;
>> +    }
>> +
>> +    s->offset_within_address_space += start - s->offset_within_region;
>> +    s->offset_within_region = start;
>> +    s->size = int128_make64(end - start);
>> +    return true;
>> +}
>> +
>>   bool memory_region_present(MemoryRegion *container, hwaddr addr)
>>   {
>>       MemoryRegion *mr;
> 


