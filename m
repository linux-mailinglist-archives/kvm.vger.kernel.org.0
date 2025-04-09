Return-Path: <kvm+bounces-43014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9861A8257E
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 15:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A7063B6AE2
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 12:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40E726159A;
	Wed,  9 Apr 2025 12:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EWr+EG3x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F6C25E465
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 12:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744203478; cv=fail; b=jK10NaS+0prNYc0n3ziC1ah7mF2BIJodDz4ssWsUzrF7m8jEwGXrotg0p3uKl63OqK2o80jhQVCklfBBLxGuQmbrjq58Ahc2PsMuKjeS02+Cq4hNe2X9oNcRSQxIsfa8YPVkpsUHwJEJYvFJ1XG1K9eHQJlzTKgX30dNhG4QQzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744203478; c=relaxed/simple;
	bh=GM9s6l2praOHyVeOlos5yXAv+Jdqb2i/cM7x/PK1wLc=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I30xk/vU7gSHcF9JRbm8XoAmLUMcXi141mxJM87eSs4SAIDRB0EThyhRoD2/VyupxN8tZuOJKMSiqaFj4NGYHKueuIHDoV3szejVvvjbWAOmtIgofirvlM1HPvE2kOKl2hFv/z4s5OdMGBH/AKmBIPa8fZ47SMpzf+s+kElbt6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EWr+EG3x; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744203477; x=1775739477;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GM9s6l2praOHyVeOlos5yXAv+Jdqb2i/cM7x/PK1wLc=;
  b=EWr+EG3xu+V/yVACT8r6ez5cwYSKk9cpKjSWu5srrx6As680A6/N/gTM
   jBNkDcQGz4YHLknoOYQTpqEXlno2Ja77xqGBMqK7bkBGRqdn8ICtyut3b
   aQAp5F87cgWL8plpLiXnSdIwTlTSTW5uiVYjithaRShcA6a8PGL3CiWso
   E5ClxFrshT1xjt7ByRsxX6mTxPUYK+WP+JAdJcZXRLVEwXdahi9cbmxrL
   Vcb7vMx5QeQqKQiYSPiwqZQ6A9nGdSKPm2oCGbYAacZmYccZ7JJGnml92
   eslMSWGNqiJ6EfHThAnQhJXvXyAhDiU6sKAtPfQy/bz8tDrZ8CycjtaGc
   g==;
X-CSE-ConnectionGUID: LyWmxwrGQFCh8iTLMawlOg==
X-CSE-MsgGUID: /5WI2y6ARc2rJriUeVCtfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="45568772"
X-IronPort-AV: E=Sophos;i="6.15,200,1739865600"; 
   d="scan'208";a="45568772"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 05:57:56 -0700
X-CSE-ConnectionGUID: QDKcloIbTNKplJRcwfHc+A==
X-CSE-MsgGUID: DsfIIzCNRjOirGuhdP+nZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,200,1739865600"; 
   d="scan'208";a="151757015"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 05:57:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 05:57:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 05:57:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 05:57:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UDLN4HEQ7siMwC6HnqcgNVwJAiFrUuVJyMNrYsmN31Nn/o9IHbiJ8Am3vJitjK4wnZdL8cDm10GM+4/iKh4BaWBf97N/n8kpzfoQE57ENKsYkPod7qElTIeyhjfCDHGprvQ2K6uA7tX6m60+brEQ3eXjXyXtZvFyw9eCt2+ASvQE9naRpCig891OUNB4mindEoMOS05pElDvpAgts5+S/V7ASAF0AwMhW8IoaeL3Ax8bYgKh8RXJKE3PC8TCvf1FhCbEZCgd9zz6UkiKONXayC014+fv9MN0/E1f3HaqNbMIbyJHaOvZ+wmN4wiCo+F8IeJ9Q3tyh4mUPPaAk3bMrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXscmEiG8/JEioNibs8IfHtFQ2iOMTECYL+9gFHPwlg=;
 b=ZmWW2t1PFnbHMlvi2O0Efd+vsIJ5AYApn4qj1YbZ541YsaNBpy3oewSscKHA01A6ad1gCVYagdZMPpWHOZpYYaVd82t0dMu062pMHlBxgtQ1vgsvXRki5Mo+PAdrQZbQbWXURQmjalR8i8K//JERTmTrpNxn1Y8H20IG4fIMx00f527dxhp/KZZTA6HXAUjtfBfShUguR3x9zKloyliJuyfGK87apHwCFispDlAC9Dwn83bT2jXhEeoy5zTbqmhd0uN4eDgaEbBlVtwuQP5s/4K/08F3jnQN1A+D9ImF0b1OOPc3LHFyWnMrY91a1IKGWv/czSOH+ksFH4ZUTxExJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17)
 by DS0PR11MB6374.namprd11.prod.outlook.com (2603:10b6:8:ca::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.21; Wed, 9 Apr 2025 12:57:10 +0000
Received: from CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb]) by CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb%6]) with mapi id 15.20.8632.017; Wed, 9 Apr 2025
 12:57:10 +0000
Message-ID: <04e6ce1f-1159-4bf3-b078-fd338a669647@intel.com>
Date: Wed, 9 Apr 2025 20:57:01 +0800
User-Agent: Mozilla Thunderbird
From: Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v4 04/13] memory: Introduce generic state change parent
 class for RamDiscardManager
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-5-chenyi.qiang@intel.com>
 <402e0db2-b1af-4629-a651-79d71feffeec@amd.com>
Content-Language: en-US
In-Reply-To: <402e0db2-b1af-4629-a651-79d71feffeec@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0160.apcprd04.prod.outlook.com (2603:1096:4::22)
 To CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CYXPR11MB8729:EE_|DS0PR11MB6374:EE_
X-MS-Office365-Filtering-Correlation-Id: 27cd5d3a-1784-4709-a2c2-08dd77660a55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TldhUGduNDIwZkdiME9kZG5QalRvRjZYRHRyUnpjbDNwVHpRd2FNR3BVQWtq?=
 =?utf-8?B?SGNjd05jSU5lbGdmVHhhR054Uk5Dd0FiN2pCL2pjK1BHcWFiUkh5eExjRUxT?=
 =?utf-8?B?NTN5WGNKL05Kb05qTm11NkxtbHI1aHJScnFKSE5wd0h2b2ZsaHpGVm5icVBN?=
 =?utf-8?B?b2hpWDV1aEtkdEQvSXIvOEdZeGt6bDI0KzVhcldCVVZzYzh6cUZDKzdtbVp3?=
 =?utf-8?B?RThIU2Y4VGFCVlBPTDIyMnV2TS9YdHh1S0sxbFc2MmZhSTY2RU45cVpJQUcz?=
 =?utf-8?B?U2UxK2lYQkRRamg2ays1MWFIWC9VeGFpZko4OGt6bU0zS3pYc1lONWtqT21B?=
 =?utf-8?B?bUVoTEhRd3o3M0dTQTNoZCtMTUNXOFU2b0JhcWZjQlM3QUlsdzMvakxLSDdm?=
 =?utf-8?B?ZE9tZEE0YnZ1MGZuZllVckNyUCtOTDBUckk1UGNjc1R1Q3FaaStLb3pXZVNi?=
 =?utf-8?B?em5JcjcyU21QNENXVmxyWjZLa3BJekJTRlNOZS92RTdVMmxOb3QyMUVpOGxS?=
 =?utf-8?B?RWt1aXdMWjUyMlEzNzRZTEg0WVFXK2lOSVhiWVVKcFBNeEp5Mm85U0FnM0N3?=
 =?utf-8?B?OHVMNkQ5UWYwTnZ6ZVpiSnorR0pnR2J3N1ZqRGZnSmE3M3BsdVlTdGNTU0li?=
 =?utf-8?B?R0pGNmdVbXVsSk8xa1M3clZ0K1BEdmhqMDlURUlEL1dhUTlkNnh6V0VscG5C?=
 =?utf-8?B?b200L2VEdXdMRytYMng4Y3hUeVZyeVN0RWNVb080L3VYTzVuSjhuMGVCZVVq?=
 =?utf-8?B?MUJzN3U0T1pmcGoyL1huVVZWQVMxeTY3SVRuWmE5bzdHMlFadmpvUmtpS2c4?=
 =?utf-8?B?VnlyRndmY3RIVFBFWUt5eDZzNmtYODBzRmRkZGZ1Vzd2aXhkbjFVL25Ddzhr?=
 =?utf-8?B?aGZON3hGOVZFWUVHQlEyNjBrWXJ4WGtiYmZmbGdVNXdwcGpMT1lBcnZPRWc0?=
 =?utf-8?B?c2ZBcjd5Q2xiRjc0TTVEUnQxWG1tMElRWEZ1cnY1ZGQ2NHV2ZGg0TUZQNnli?=
 =?utf-8?B?TnFaRGFPRVdiUmNjTlkvUUFhU0tjR1NjeHE5ckJKZzdmK0xpMkVRcFZQbURh?=
 =?utf-8?B?TFp6akJ0VnhweWlxNHlLTzg4MDFjZy9nbU1ydXFwRlRBOW92NTZEa2NUTlpQ?=
 =?utf-8?B?SUtWZGNmV0RRU2xhUHVVYjFyNDhYQW5XZ1BoL0RlQ1Y1SDhZdmV2Ri9hNVNz?=
 =?utf-8?B?MjA0Q1MrdjY1a0o2VEpDTjZIdUpLcVVaalpaMk9vVWJNV2xwbzU1emtHVy9m?=
 =?utf-8?B?amdwRmFzK0ZpOVVKaXB5WTZxbWFQUjFzSjlrY0hWaTl4WHF2VldkV2NISUZn?=
 =?utf-8?B?dys3U1cxa0w0d1B6TDZJbllVNU9hUXltUTM5UUpsU0JiWmx2SjJtWFgxdXdm?=
 =?utf-8?B?VmVyUXM5cUFadGQ2Nmd1L0tlSUNEcVdodUtIS2pmZmJmdUV4U3ZrNXdoN25s?=
 =?utf-8?B?VTdIaFcrQjJNbjF2YkN3T1JUUi9jdU1PMWYxYmVnckN3OWVCR0dMRWF6RnJ5?=
 =?utf-8?B?bzVHdXhXNFJPSzNEcVVXNDFuVlZZaUs4dk1QbExLSFMvRG05UjNTOVU0SmNI?=
 =?utf-8?B?RGtaK2dLdXROWGpuTTJNeWhnSXVzVmx4VCtCYkRNMW1Hdm8rOExCN0xVUlJh?=
 =?utf-8?B?Ync5a2VzWkpTbVRlbE5BTzBTOEJoUlRnbmpyWE0rWjEraUpTZkNNRFVudFJi?=
 =?utf-8?B?ejhSQ3QwWjQ1azNuTlZYamRRMmR6UUpVSWtwREN3ZnZSQXhsQjNWVGJ2MUlR?=
 =?utf-8?B?N01ZRDZiYy83UjdhZEVKOVVIL0c4a0VhZG1wR1dDWFkvT3RrN0RlSThrVTFm?=
 =?utf-8?B?eTN5bEtkb0VnbkVDdUs3d3NoM3hXSXl2MkZOK2VubjE0WDdYaER1QmZOQmdY?=
 =?utf-8?Q?IWhsuNSMus31Z?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYXPR11MB8729.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vkx0L05ManhtaGJFeDZ3SVdvRGdrYlNJbGgyRG9NakVSVlE3UEhnYzN1anNn?=
 =?utf-8?B?Q0ZObTZHU29pOVNZRDZYRTRGZUVVZEpDK1A5d1FGVWo1SFhKR3pSMlZSa2ZR?=
 =?utf-8?B?Y2w3WFlRSHJMZ2xsSCtzK3dqSjVoTFRpZktCdENZZWczMDVyQzhVVHM3TStO?=
 =?utf-8?B?MDYwdU40T1BGb3Z0QkUvYU5vWGhYWTFFWHo3a1Nacy9PQitreGcrQys4R1Na?=
 =?utf-8?B?RnpELzZub2NaTHU4eDk3ZDZ1OEpCelVZRllxTW4xL1ZoYi9SR3o1dlZSVXV2?=
 =?utf-8?B?bzJGZFA2cW9FRXowNjd4bHBuTTRaZW9tQzdpU2hscmZvT0NKSml4akNycHls?=
 =?utf-8?B?L0ZjdHh4NnFIT28yc2l1aEtFWWcyT2ZLZzNmUS9SNUdWNVZVRUsvbzhhSjd1?=
 =?utf-8?B?MER5MWJobU53Z0tIYTYwMFhHb21iY3FySmJUUWFHK1ZHSTBPN21Nais4bGFy?=
 =?utf-8?B?ZnhPM3hmd3duODVCL29wSzF5eWVEdHlWZkUyVUk0V3BEaCtDVXluSVRybzdw?=
 =?utf-8?B?NE5lTUtKWm9sbERjRlhNMkpIMnZ6TlpIbUxUT0YyR215enM2cHFVdytlSUpn?=
 =?utf-8?B?SGtxQXdGc1gwVlN5MWZxejYrYVpzc0VITGRBSFk0TVBsNUR3WGpJQ3h0UVhw?=
 =?utf-8?B?MWZmT0VqVGxpeW9BelJ4UHNIajMxSXN3S3VtTEw0N2tML2F2emZXR2xPUWp6?=
 =?utf-8?B?NTBmVXdHcjlMV3JrM2J5RDNwVXFLYjNvTlYxZVAyd1E3TkdKM01HNS9zWHpP?=
 =?utf-8?B?SFVyb1VxKzF0YUVmZVIzWHpvcXpLQVdWb1pmWSt4Rzd4WDlGUHM5d3E1bXNS?=
 =?utf-8?B?U0d6K3IrZ25Od2ZrSmU2dTNSMU9OLzg3OTdMVUdkWVpxNVFUcUNCYUxoeW52?=
 =?utf-8?B?MXdUVlZFNjNHTFRMQ1VNM0lGM29lRTk0a1c5UkpNR2tUSWlsL3VwdWtMbXdj?=
 =?utf-8?B?SWN4YUNwWmRoTnBZUy95UnZZZG15Q01rTXJ4K1cyaXE4SmJTV1ptRFBSUlpp?=
 =?utf-8?B?ZHF0cFZ2OVo2V0F5Q0RtZVFVU0pPRXNVZTgvSGluNU5OT3BDNURwUDd5SjNY?=
 =?utf-8?B?eFhHc3pJeTl3RmdUbWJyYVpNZ3kzcVFjaDh1b0JvZVhha3BrdmY3Z1Vnekh6?=
 =?utf-8?B?cjBTK3Y5MGdMZWg5YjV0MTlidVBUQmRmNDJFRGMzUFBmQjNqbnRLN0s0RG9j?=
 =?utf-8?B?bmNtdG1DQWdsYk84Q3UyQThRMExjRFlSc1o2MG8wcSs5L2d1azIvVG5EOTNp?=
 =?utf-8?B?WGNVTVkzS0pHN2krTE1yZ0VSK2s2ZjNDdTIzMGJnY3JObjV5ZHg3OHk5SFZ5?=
 =?utf-8?B?TktUTEJyV3FtZXQvWWRIaGVHL0E5UDlCcDY3bzZvWDJZSTQxZHU5cUtKS1Q0?=
 =?utf-8?B?ZVpvVEQ2eHlvMkpqRS9ZTHIwZTBEV2hodFRzWFkyOHNoTUpxRStXendDRWhu?=
 =?utf-8?B?dXZwTGowVk9YbTdzeDVRbisrQzFPSHBERThSalJKckJCVFRBRjNaelM0SERk?=
 =?utf-8?B?UmduUXlUU0NlOEs5NWY1V0JDMGVaVDBpZDlzUzE3cEpiT05OeDhocVJrMHUz?=
 =?utf-8?B?SWlwVE0xVWZqRlRYK2xVTkR3U0doTFJBaUlaRVcwZjBoVkZFNllsZmtnYTN0?=
 =?utf-8?B?QmtsNXVVZnFSOGo0MnFQM1NmL1gyeC91ellWb0NpRzhmTUpoWTVhVnJ2Q2dX?=
 =?utf-8?B?RHpvMDR2VW96ZGpyZ0VHNStqVE81VGo5QTk1bFJ1TXdrYVF6cWpGaE9MZVQ1?=
 =?utf-8?B?UTV2Zmh2ZThjRThjYVRoYlBuVGpwdGM4enlYbmtwaGJXOGVzY3A2WFhiV2RU?=
 =?utf-8?B?TjlqN0RhV1RiUVBQQ1pHQy8rZ3B5WE0zTzU5T3N2WXB6Q2NWd1FaTXFDQVo4?=
 =?utf-8?B?QnZMcmdVK3FRc2x2UGxPQXdPMk93cVUyUnJoa2FRejBsRVZWTnk4akFiWDFp?=
 =?utf-8?B?dG4rbkF4U3JuYnAvUVRZK3N6eWhob0EzUHN5MjduVm1kbU02T1FEVnhGN2wy?=
 =?utf-8?B?TVptU3BiekF5TUgyTjJnSzcyZEs4MDJpSU1uTlRaazFxbG1QQys5cUcxRmxx?=
 =?utf-8?B?dElXS2tSZUVkRjBZVjdRUThXdTg4TGw1aGRQRzRtYmtTNXJNV3VWcldqM1cz?=
 =?utf-8?B?bU9rZWxPdlUyWXkycHZOTk5aUFhlcENiM3pTR1NIdzdmSjl6R3pEV2dpdHIr?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27cd5d3a-1784-4709-a2c2-08dd77660a55
X-MS-Exchange-CrossTenant-AuthSource: CYXPR11MB8729.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 12:57:10.3448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EE4o9ATsE5ExkEdaBlVNzYuFgfMFgd4y49vKe3i2fWE5n+pkoCCZel6k3haI39YpGcaiDfQuxr6QNkabE1revg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6374
X-OriginatorOrg: intel.com



On 4/9/2025 5:56 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 7/4/25 17:49, Chenyi Qiang wrote:
>> RamDiscardManager is an interface used by virtio-mem to adjust VFIO
>> mappings in relation to VM page assignment. It manages the state of
>> populated and discard for the RAM. To accommodate future scnarios for
>> managing RAM states, such as private and shared states in confidential
>> VMs, the existing RamDiscardManager interface needs to be generalized.
>>
>> Introduce a parent class, GenericStateManager, to manage a pair of
> 
> "GenericState" is the same as "State" really. Call it RamStateManager.

OK to me.

> 
> 
> 
>> opposite states with RamDiscardManager as its child. The changes include
>> - Define a new abstract class GenericStateChange.
>> - Extract six callbacks into GenericStateChangeClass and allow the child
>>    classes to inherit them.
>> - Modify RamDiscardManager-related helpers to use GenericStateManager
>>    ones.
>> - Define a generic StatChangeListener to extract fields from
> 
> "e" missing in StateChangeListener.

Fixed. Thanks.

> 
>>    RamDiscardManager listener which allows future listeners to embed it
>>    and avoid duplication.
>> - Change the users of RamDiscardManager (virtio-mem, migration, etc.) to
>>    switch to use GenericStateChange helpers.
>>
>> It can provide a more flexible and resuable framework for RAM state
>> management, facilitating future enhancements and use cases.
> 
> I fail to see how new interface helps with this. RamDiscardManager
> manipulates populated/discarded. It would make sense may be if the new
> class had more bits per page, say private/shared/discarded but it does
> not. And PrivateSharedManager cannot coexist with RamDiscard. imho this
> is going in a wrong direction.

I think we have two questions here:

1. whether we should define an abstract parent class and distinguish the
RamDiscardManager and PrivateSharedManager?

I vote for this. First, After making the distinction, the
PrivateSharedManager won't go into the RamDiscardManager path which
PrivateSharedManager may have not supported yet. e.g. the migration
related path. In addtional, we can extend the PrivateSharedManager for
specific handling, e.g. the priority listener, state_change() callback.

2. How we should abstract the parent class?

I think this is the problem. My current implementation extracts all the
callbacks in RamDiscardManager into the parent class and call them
state_set and state_clear, which can only manage a pair of opposite
states. As you mentioned, there could be private/shared/discarded three
states in the future, which is not compatible with current design. Maybe
we can make the parent class more generic, e.g. only extract the
register/unregister_listener() into it.

> 
> 
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v4:
>>      - Newly added.
>> ---
>>   hw/vfio/common.c        |  30 ++--
>>   hw/virtio/virtio-mem.c  |  95 ++++++------
>>   include/exec/memory.h   | 313 ++++++++++++++++++++++------------------
>>   migration/ram.c         |  16 +-
>>   system/memory.c         | 106 ++++++++------
>>   system/memory_mapping.c |   6 +-
>>   6 files changed, 310 insertions(+), 256 deletions(-)
>>
>> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
>> index f7499a9b74..3172d877cc 100644
>> --- a/hw/vfio/common.c
>> +++ b/hw/vfio/common.c
>> @@ -335,9 +335,10 @@ out:
>>       rcu_read_unlock();
>>   }
>>   -static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
>> +static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
>>                                               MemoryRegionSection
>> *section)
>>   {
>> +    RamDiscardListener *rdl = container_of(scl, RamDiscardListener,
>> scl);
>>       VFIORamDiscardListener *vrdl = container_of(rdl,
>> VFIORamDiscardListener,
>>                                                   listener);
>>       VFIOContainerBase *bcontainer = vrdl->bcontainer;
>> @@ -353,9 +354,10 @@ static void
>> vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
>>       }
>>   }
>>   -static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
>> +static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
>>                                               MemoryRegionSection
>> *section)
>>   {
>> +    RamDiscardListener *rdl = container_of(scl, RamDiscardListener,
>> scl);
>>       VFIORamDiscardListener *vrdl = container_of(rdl,
>> VFIORamDiscardListener,
>>                                                   listener);
> 
> VFIORamDiscardListener *vrdl = container_of(scl, VFIORamDiscardListener,
> listener.scl) and drop @ rdl? Thanks,

Modified. Thanks!

> 
> 

