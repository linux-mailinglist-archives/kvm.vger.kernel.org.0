Return-Path: <kvm+bounces-41039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 556B6A60EC0
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D84771895417
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 10:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E469F1F417A;
	Fri, 14 Mar 2025 10:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LWnh1REJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B926C13C3F6
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741947875; cv=fail; b=TOoFOL0Fa5SyV2xxBGC+p79pzYUemIEBuAsd5NF0twy7zy4h7zK0Ke1VoRjU4z6SDxyVEU6m0TvFeYDF36q7LZl3uJn3affVzTP0U56NcfJw+kFMp6JQOXojLueyvszEd9JdnTGs9c/yAsTR4YC1nyRipwu/kzml33KCATFiRm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741947875; c=relaxed/simple;
	bh=RaXd9stPpyr5590Qm1yf4GBozGEUBZu0DcSXxkJCDKU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eN5mL0zCr77oJObfNd+9fqb9OoGr3MB8z92mUh5mtrdrA49Q4AZSjtdQW23ePG4kqmHocgqt4xKC8/3CgaAseCGWY6Ij6Fcu0/kJn9k/PXILQOTN8ycCt6xEVHWk1tGzBwaHLq1tPC5Y066Amwb6m/S6QgZp34H0/qRYtSTzB/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LWnh1REJ; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741947873; x=1773483873;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RaXd9stPpyr5590Qm1yf4GBozGEUBZu0DcSXxkJCDKU=;
  b=LWnh1REJXDNSF82RwOoeotZpUjVaJk1dkIbdVsrbiFEO1IBEc2cAoMjy
   Dtnv+0hry/6pGJao85HQjqCDvLPLpXLfOCHbe6fcAcZ17k41KM7EE39by
   EqhIPIgGBOzaWPPGvBZtHuD3GvoY+wyG6YIXrXA2s8rCiilNTmj+8lWhn
   fAk/0v9xu/kPpoIFiFO+WS+hW9/mdxeNH/jlFuOPqCBzYeKfqhPXrQoMH
   DzAjB/fZmu8teKevqvLiWIVayUjOPbqKCQJoyBRLZyFdN+uuVzhZtPVTc
   bH1aNkGKfkeJ/E2zzQxjylV9ajnA9tEaOSDkehIOWvOSm4oTU4suK4yJL
   w==;
X-CSE-ConnectionGUID: a/NcqznPQB6FmjWp35ZVWw==
X-CSE-MsgGUID: 5g4d4IchTY2wYon0KlOipQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="45861369"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="45861369"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 03:24:30 -0700
X-CSE-ConnectionGUID: vfAvuXVESqCrRI+N7Fs3Xg==
X-CSE-MsgGUID: jbTRYZuxRO6XSjz3PiFWOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="126430818"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2025 03:24:30 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 14 Mar 2025 03:24:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 14 Mar 2025 03:24:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Mar 2025 03:24:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FjZgBiXs42KBphYSXbasMkdZJTpnwrKRzpx3DEHjjwch1W+jTuiiCXDYiLgmJewO3H57C/HIN2Tv1DUNbodu8sjDhc/kSnE0k8M1I+9jbbp0dvntGzGeiaZRCkc0PoStrW0lNPvI8tskyvgYQfw4n4gYNzjrScuvCuDE7k5uAdTjueqyd/ih9ZOQZhzO1DkbOikxoIKTva5jY2Zs+kZtMhHsOAG5+pi4WbBHXCCSwxSp5whRMmjQWlaoLinXijhH6zFkDYODkaQc7NpRxAZOjGOSXj3ubhfok5yA5SPUyjBNVadyh8t4QDqwsgb0TXCKg3LyzytjqTJE9ZzzjrK6Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqP4lCFqpYFy4bLQmyyy0W8zgkfYBln8rP52HfiIbKo=;
 b=VC7jCFydVYF6x/TSqRCc5XXiOPY5O1tRBFTqfchzqpH14+rMSIZBumqji2bi0AAG9N9TDi6OGg4pHQ01oI6Ig1NE4Qt8DND5elgpKq+U1WaKVx0wQqWzB5wfB/sUibowoeFB7g/M+j4BI7X9D/Jp/8VsFmZfNv7T2kaEOQvuw1nLyhyS8ISAZ0M2bRkCx1EAqHMVvby320evTtO7gPZMUkGbvbWO00yjInSy0iepSHC6dduxy3Hl2fnlLVAQJ/Ht6ZwhpH6wFN9Y8DjD7t6oVm06o9PauwUiHuMuFMEw2g5AYhvIY0OnhjxzwI8LmLEOE3634tme+mpZ/GJDIHy7Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SN7PR11MB7065.namprd11.prod.outlook.com (2603:10b6:806:298::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Fri, 14 Mar
 2025 10:23:47 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8534.027; Fri, 14 Mar 2025
 10:23:47 +0000
Message-ID: <b9d809c0-92c3-4bf4-b49e-c97383924e06@intel.com>
Date: Fri, 14 Mar 2025 18:23:38 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] memory: Attach MemoryAttributeManager to
 guest_memfd-backed RAMBlocks
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-7-chenyi.qiang@intel.com>
 <8d9ff645-cfc2-4789-9c13-9275103fbd8c@intel.com>
 <11d40705-60d8-4ad6-8134-86b393bfae8f@redhat.com>
 <192a8ed9-fecb-4faa-b179-ed6f9ef18ac8@intel.com>
 <af80216e-7a09-48a3-97b8-5b19cc3ded28@redhat.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <af80216e-7a09-48a3-97b8-5b19cc3ded28@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0028.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::9)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SN7PR11MB7065:EE_
X-MS-Office365-Filtering-Correlation-Id: 857ebeaf-0f58-4184-a30e-08dd62e24dfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bmJiVVdVTnlPU2NSRlEzUE9hdzNsWTNtL244MmNidnViM3hiYUV6R1B1bzVj?=
 =?utf-8?B?R0gwYW1TeDlXVEZKa01XYjE1NktLcE10TXpLYU5iMnZsUXdFS3VHQUZIbzFN?=
 =?utf-8?B?cUZJS3R0eG9GMlhNQVJJcU0wbjJ4VCtjL0NQZittRGNFbWZsekZjNVVTWFVm?=
 =?utf-8?B?eUpkMFpRQlNYNGxOcEZRQ3VhNWQzdGRVeTF0WE1acWFCU01uNlF2ZGhyeFMw?=
 =?utf-8?B?dFE4bmJ0eHRFUVhCZi95Q2FIZGFuQ3JobzhFR1k3cG50eDBXR0h5K0J6QTN5?=
 =?utf-8?B?TnR1SFR0eG9Jc2lqc2hXbjFpYzlwNW5EbVhLRGVGK0M0U0Z4bWxyQVZHRm5y?=
 =?utf-8?B?QmVvVkhvUVVrZWIwQ2N0Z013M3NzZFBrSHk1ME9WUTBzcXlrQUhjZGhPUXhu?=
 =?utf-8?B?OXovcDEzRi9vTDg1di9XOG9VK0pYbTNrYmpraU5KWlFUby9pb0tkSkxIVk9E?=
 =?utf-8?B?Z05nbXNCRXI4Nkh5RmRhVCtmNnJoZmFEdmp2dnUzVjBNWDNydW1EeEhVdUVx?=
 =?utf-8?B?S3l2c0lheW1QbStxdUNGeDlZa2ZUdTFaQUM0Zm1WS2QvZFJyVVhMbytESzNo?=
 =?utf-8?B?MEQwemF0YSt6WkI0MGZQMEJ5ZTgwdWt6RVRUS2hDM1ZWU2xvc0xIK2NISVUx?=
 =?utf-8?B?N0JXL1VKOVlxcm9QQXZXQTlsaWh3cGVnWktBVXJOcXNKb3dKYy9KaThXbEUv?=
 =?utf-8?B?WC8xbjdVeFFwbGVISGR1T045Rm1uLzhSbzFIamhBMHNjRFBhK2tMZGIrbFdF?=
 =?utf-8?B?cExwZS9BR2pZeUtJbVgvUTcxZmt6QjhFclYvbitKOStaSWR3MTZWNE9hcm9a?=
 =?utf-8?B?UE1OcXJuSEwxYlJlUFRsMVFnaDZrUEhCYWJNS21VZHFrN3lOVWhZUDNEWWdu?=
 =?utf-8?B?MHFKd0piYkhhazVkMkh0WHdjS3Z4SkFVb1o1YU55T00vYWNuNnpMUlJKcXA0?=
 =?utf-8?B?YURZWGpCZ0cwSy9PbERkekVXbGQ3MHp2NlVHT3NsNEY1RjI3OUpJTURHNDA3?=
 =?utf-8?B?ZFUxekozL0JNYno5Z1B6QXlwTXVXemdMSmczdGd0Z0IrbEhsWVhZbmhEZndB?=
 =?utf-8?B?TUNSK2t6ZkdiVG9wNHFTQmRFNzlqQmYvOCtrSlUwZFh4VU5Ec3BtdDdIZFgy?=
 =?utf-8?B?T00yd3BtSGFvbG1DNXpzc2trU0tmaXRHaXdpZlYzb3pRb2ovSzVOVTI0YjRo?=
 =?utf-8?B?OWdkZEo4NmdWUXJmeklwUFVTUFFzUWFqKy9OSDN4NUFhUFNSUWtXNGlScHZH?=
 =?utf-8?B?YnZtQ1lFNmZNbkp5K0hjbjFFMXdrQ3dtdWlIYXliVnJFWitQZWs2dXpxRE5P?=
 =?utf-8?B?NTNVSit6MzJpOTdlSmdKQzVoTDhNTWxab0ZVQ0NmNFU1OEw1dmhtYzI1eDNq?=
 =?utf-8?B?WWY0RkJkRytkKzFVOTJaNlVudHN0dXZackt4Y2c5VUNNdEVkZi9HMW5JL0E0?=
 =?utf-8?B?b29LSVA5QnhkTVRIdmhUbU9hNDVJNXBnSTluZ1hubUl0OFpLcXVXVm1DK21K?=
 =?utf-8?B?dmpYeXVINDl4NTNBbjdFN0FEenhVZ25rQTdCc3dITWRIVURzaHpieWFMWks2?=
 =?utf-8?B?SSsrOWxBbmlqQmtKbS8zejhPME9FekttMmh1ajBhTXI4bm1oMk9TMkVUNFFJ?=
 =?utf-8?B?bmdHaFdMQUpnZ0FOcTR2OG5DTWEyMmNqYzFreW1XN2QzT1lrS244TjdERTNz?=
 =?utf-8?B?SWNEY0FKQlhWM3liVlh4WHdLUzU4Q0RleE42QWJDZGdRNkRhRHcxL3ZDZExW?=
 =?utf-8?B?S3NIMjd0NjU1WUpLUGVJWTVXYWdUOFYrZ3BTSnQ3OWpkekY1VW1LSk5NcUxJ?=
 =?utf-8?B?SExkV3RrTERzUXVtQTVXQ2tLb1dIYmJxY2xwMDUreGVoSlhjMUpLYVJNNFUy?=
 =?utf-8?Q?I/nLQ+jOVM5sK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0syakhlZDAzZ2VzdjR5alR0Y3djRkhtcGxNMjNzaERVYmdKMU9CZmlFdnk2?=
 =?utf-8?B?NE53OGVUTXVZcDhWT3Fjb09zbGd5dzFtbGptWno3ajBRWUVaRDcwQ3Z0dE9B?=
 =?utf-8?B?dWUwUmxaMkFLdTBZWWNVeUZubmJST1RGV2oyRWV5NGpsTlRZamNrWDI3SUxo?=
 =?utf-8?B?bjBUSXZLM0l4bmZTcVRMYTUzUGJFSTV2dUJDNTFXSWh3UURZMTFtNGg0VGZo?=
 =?utf-8?B?eHR6eVpRbXllVkxkeXd3U3kwNVYyc2NVZ1NUSmV3QW5DbmwvNDNKZVVnZjJK?=
 =?utf-8?B?TmFReWxuNGVTQ3phOE44YTRJZUcybGI4UytVMzRabUhCWjQrdjdMUUp5ejRn?=
 =?utf-8?B?Z005d0tJVWltUG9ZYW5qUVkrMVpZTkk2NmFKWmd1RjFIdTRqOTd5QUM4cnJM?=
 =?utf-8?B?ZC9jNXJ6T1Y5cENlVGVzQk9aS1Q4RFVyOXA1bTFtMlpVdFBLNE9KWERZZzVa?=
 =?utf-8?B?czUrUkMrSlFqTFRSYUZjM2lsRWpqa3laaFFQcURsY1RTMVZMaFpFVmpnUFd2?=
 =?utf-8?B?UmNIZTJnWDJrSitoZWhoUHp3bHMzZ2xrRVVlNFk0TU13djJvbTFUcWR3U0Z1?=
 =?utf-8?B?d3FvQlB4eXgybmR2dmhYTHVXM09uWmZSUkJjeGRkUXBXNFlSdk8vK3U5Skts?=
 =?utf-8?B?RndHbVZNL0tidHVjbG5uUzFtLzl1WmwrU0N5aXg3dUlXNjJqeU12ZkdPaWs4?=
 =?utf-8?B?aXpFMTF4RVhzeGdBeUNwZ0w2MGNnUHQ3d2N1bUo3cnJQZ1lhSk9UWk13WjZK?=
 =?utf-8?B?cXE4NGZRWktDWitxK09EdDdYWFZCTGE2a0ZXOFFWdzBySUxSYjRrU1Bic3RW?=
 =?utf-8?B?ejNNS3U4WWVETnVWVmdEMDY4eU1yclU5RVQ1ckdxbkhSZWx0dzd3WlhwZ2Jz?=
 =?utf-8?B?dndaOXZ0Z0M2cmxMTnRZSTJibU1DSEY1VmNsQ3ovRElJMzhVRDBScU5XQ2xC?=
 =?utf-8?B?UGdXOTcvUlVKbW1DL1lUV2gzWktrUytGMS9MazkrN2JXNjFyZlhkak1lWjFT?=
 =?utf-8?B?VDZwYnZOeDhCdldGSGl5TXQxcDRmbi82L0tPY0FlRTBpbkIzajhwUHBwcG0w?=
 =?utf-8?B?b093dlpSNmU4ZUZUazVVVkhDY0FlTnlidjYzVllxMzIrOTkvN25uTVYvSGVt?=
 =?utf-8?B?blNPSWJlMzZRdUtmSUlSZGg4UDFaODh5d0VXdmx4QytvbWZBd2VtUE91bnVB?=
 =?utf-8?B?cmJSby9NWFB1b1UzZldTRWNRdVhJbSsyT3pyS1JJNWE2REZ3UGVkVWFoeHRC?=
 =?utf-8?B?SmN1ZlRWbWtudUtHWVZtbm5XTDl3OEhKT2tza3VuUWlNdlZhbGE0MkdOd0JC?=
 =?utf-8?B?aEJ4b3dlWDN0ajRHbjBnNDEyQ3E0djR1bU1qbzQ4YUYyV3BNd0JBYzhSdHdZ?=
 =?utf-8?B?SG9qcUZrb3VCNU1ZaFZjUzB1cmpUSEp1OWRTOXZWSFdDUGtpSDhxN1VhZjJj?=
 =?utf-8?B?QTVOdER1R0xCNmFLQkRadVNoOFdwV2Rka1p0aFZPcVpQUDRaTGh6ekR1R1pq?=
 =?utf-8?B?TjF0Yjh6WEZiUk5CUkMrMlJkcDlSRU1jSjJuNnl6NDR4Tm96MG1FL1pjUTBm?=
 =?utf-8?B?SXR1TXlnQmZOVVgwZXM2VmswalVTMWZyMitmN1EyTmozS2wwQnZqVFlMMTJP?=
 =?utf-8?B?Y3I4SDdWMlFhMmIzaVhPQ2tFekVJdmRlMEpDRDJ5NDlZVkcwVDM3VGdiQStI?=
 =?utf-8?B?U0I5eTgyRXlNVEtueXp1UGMxcXorZnhkUXFyQTdIVHJLMzBEMGdaU3BTUHps?=
 =?utf-8?B?WGZhcmE3eElrbkQ3NWFVSnlPZXVHN3diSnY5UTBlUjBFK3RYN3VyL1pvT0JE?=
 =?utf-8?B?M2lVeDFPdEptMGQ1QWlCVnJwQnN4TzhFeUo5cUwvNHFqRzJ5TS9RTzRqYXdr?=
 =?utf-8?B?blBEbUV3bFRZWGpZdVhXOEEzaFk0eVNhUTBjZnVFdDArdllEOHJrbUk5ejJ4?=
 =?utf-8?B?VithV2JZSTZySllyZHliS1Y5YlNMeVdsekI0aXRqZXB1RXhkc0RuMXhETGd4?=
 =?utf-8?B?S0w3ZFF4VmIzcC95ak9zUVVXQVF4ZWNuSUZIY2pReUt2RERnTzV5bjdobm42?=
 =?utf-8?B?QXErQ1lwWnFDT2pQQkpGZW1qYXBIbWFFOWFRdVNweVZXK0dENmpPRFJjeDN2?=
 =?utf-8?B?TE44WDBQWlpCcllkc2paVVJZMzlXazNlWTJhWHdwYkN5SWZnZG9WemoxS2Mw?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 857ebeaf-0f58-4184-a30e-08dd62e24dfa
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2025 10:23:47.0189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GNQmI/SFVqCqcG5HSSqLG+hTpivyzEYbFa3jBmXw2HJD/eoZjUQRK2utdCXr+lmm0pZhzfzRFZMi6kJFWAdCgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7065
X-OriginatorOrg: intel.com



On 3/14/2025 5:50 PM, David Hildenbrand wrote:
> On 14.03.25 10:30, Chenyi Qiang wrote:
>>
>>
>> On 3/14/2025 5:00 PM, David Hildenbrand wrote:
>>> On 14.03.25 09:21, Chenyi Qiang wrote:
>>>> Hi David & Alexey,
>>>
>>> Hi,
>>>
>>>>
>>>> To keep the bitmap aligned, I add the undo operation for
>>>> set_memory_attributes() and use the bitmap + replay callback to do
>>>> set_memory_attributes(). Does this change make sense?
>>>
>>> I assume you mean this hunk:
>>>
>>> +    ret =
>>> memory_attribute_manager_state_change(MEMORY_ATTRIBUTE_MANAGER(mr->rdm),
>>> +                                                offset, size,
>>> to_private);
>>> +    if (ret) {
>>> +        warn_report("Failed to notify the listener the state change
>>> of "
>>> +                    "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
>>> +                    start, size, to_private ? "private" : "shared");
>>> +        args.to_private = !to_private;
>>> +        if (to_private) {
>>> +            ret = ram_discard_manager_replay_populated(mr->rdm,
>>> &section,
>>> +
>>> kvm_set_memory_attributes_cb,
>>> +                                                       &args);
>>> +        } else {
>>> +            ret = ram_discard_manager_replay_discarded(mr->rdm,
>>> &section,
>>> +
>>> kvm_set_memory_attributes_cb,
>>> +                                                       &args);
>>> +        }
>>> +        if (ret) {
>>> +            goto out_unref;
>>> +        }
>>>
> 
> We should probably document that memory_attribute_state_change() cannot
> fail with "to_private", so you can simplify it to only handle the "to
> shared" case.

Yes, "to_private" branch is unnecessary.

> 
>>>
>>> Why is that undo necessary? The bitmap + listeners should be held in
>>> sync inside of
>>> memory_attribute_manager_state_change(). Handling this in the caller
>>> looks wrong.
>>
>> state_change() handles the listener, i.e. VFIO/IOMMU. And the caller
>> handles the core mm side (guest_memfd set_attribute()) undo if
>> state_change() failed. Just want to keep the attribute consistent with
>> the bitmap on both side. Do we need this? If not, the bitmap can only
>> represent the status of listeners.
> 
> Ah, so you meant that you effectively want to undo the attribute change,
> because the state effectively cannot change, and we want to revert the
> attribute change.
> 
> That makes sense when we are converting private->shared.
> 
> 
> BTW, I'm thinking if the orders should be the following (with in-place
> conversion in mind where we would mmap guest_memfd for the shared memory
> parts).
> 
> On private -> shared conversion:
> 
> (1) change_attribute()
> (2) state_change(): IOMMU pins shared memory
> (3) restore_attribute() if it failed
> 
> On shared -> private conversion
> (1) state_change(): IOMMU unpins shared memory
> (2) change_attribute(): can convert in-place because there are not pins
> 
> I'm wondering if the whole attribute change could actually be a
> listener, invoked by the memory_attribute_manager_state_change() call
> itself in the right order.
> 
> We'd probably need listener priorities, and invoke them in reverse order
> on shared -> private conversion. Just an idea to get rid of the manual
> ram_discard_manager_replay_discarded() call in your code.

Good idea. I think listener priorities can make it more elegant with
in-place conversion. And the change_attribute() listener can be given a
highest or lowest priority. Maybe we can add this change in advance
before in-place conversion available.

> 


