Return-Path: <kvm+bounces-34762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17EC2A058D6
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 11:57:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F19E916571D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 10:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64BB61F8900;
	Wed,  8 Jan 2025 10:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nr7jYyRN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFFB19D06A
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 10:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736333841; cv=fail; b=i+iPtCL+LDTj1DKXBxVH4Vv9eDr6JFXaKRsEiV7g5z0pkZJad7pwo+1e0157QYnXpqq7tCXuqX4h/7dZcrisZgZjaNJYyxQjbb5Z+KzMOV581K2V8krCr8YB+43P1mu/tL3baCCEYo4TNTvIqLcOVB7mz4zp6Xi7rtSpK9bT1aE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736333841; c=relaxed/simple;
	bh=0JBCSrGOVXfAqWzHeBmLsPY8q2dDyG+RUD7Lyac+bEA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n8iH0hQvhe1p3q5HqV5e/xzFpYndSkF6YqB8ss9o4eN7R2M2Ir50OeeWA0JvSQ+X2OSq1X8XlE/65RnECUQ7K7oZt69FPY+ng6or07+eR4P3GTiZxL0PT0Onb1tOpoPTF20w0tDYxHBdwhwLcpwjZCQXc1qAE26mg5fiHCaoCp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nr7jYyRN; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736333839; x=1767869839;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0JBCSrGOVXfAqWzHeBmLsPY8q2dDyG+RUD7Lyac+bEA=;
  b=nr7jYyRNv0vVybmuH5uLPcNWVJQKtIRjod+HS1K9BNpuil6XMIIqdKKm
   HVYf2UrCQXMgUXHJ8HmlGPEqo+Hpmh3PTTunmautoNPovz6uusQhV582q
   3/dVKow2x/ZL0eJy9ZQ07AS/SyZuJfAfwqaRHncF2tcS0kmHVoFg+rxTq
   YXKWpHb54HhSphc1ZNaCkbetoH/bvJgovK+zL+tovZgD/eSPlTy+KJ+RV
   2Lk6HtcktD7oa0RVXVIbsbPUhGg+waGhL2dKLA+GiuvIFNYDFSWr0P3UP
   4IFQRav9+BE019gn7rywHcaNTfmvzPIV58n9eHembvHp30XWBgsxjSrZO
   Q==;
X-CSE-ConnectionGUID: ThtjgnjVTLa6Yr+E4LZykg==
X-CSE-MsgGUID: vnzGMpdlQvC1KuCAtoaV3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="36436083"
X-IronPort-AV: E=Sophos;i="6.12,298,1728975600"; 
   d="scan'208";a="36436083"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 02:57:18 -0800
X-CSE-ConnectionGUID: dHn7YfdFSke2WJR/oHJRDw==
X-CSE-MsgGUID: Z/eRjISdSnCSFNmEPhKN1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,298,1728975600"; 
   d="scan'208";a="108041938"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jan 2025 02:57:18 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 8 Jan 2025 02:57:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 8 Jan 2025 02:57:17 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 8 Jan 2025 02:57:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+3OmuljU7pE0pbkI5cfMdCZawkSYEeka9E4VPHMRFVggyKqpp6O7zK8/dzRCCWn30Ofi4QSLRfK3tcwXyyH+xs+2AGOGaO7AOC5VuGetVgbFek1xy8gpwu3kmMU1iJBY6Sbb4uPgreDC4WhE9aWJiZ790SV2RX0kashZkzxop7zG6zXplF2HOuTFrv3eDEXCF2Wds12fPH5ayF5GWnxb+ZUYDLBNHqI1Ey0JRdOXV3dCFmXi2KiQx4+KsPQ0YKhgO3dyFQp/SGjRLTsD+ztWJ+ERaD2Cf4/0w+dpBh+ky1eL/yHilvignAYP8dye5duP0TPsaiv0wZaw9/rbW7qlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixeKK5wiJovE+5x6HcY2rqGTd7nOMrNGLNPujRaRex8=;
 b=lZnQA6iPaqc9HH3Y6A6eFsv3AG7HdMPblG1Cx3zb4eNPccoa6QY+YE5DECU9gVEsOnnyt39P0Y4O8lksf+Ll0Z+kU55RT3lxnVOypRJtSQy0O92hTgdz6/NkGBZRgLSUi5OXTkHVNSoDALly374FZrJDh3wbssl5901t7fNXcWv6dn0Es7+xO1tCiM33bDnWFwNCd/8BEwEYu2vaXXvK8ySGpSxvoLpNVheXji8jsJnSE78GHEmRh4Sl/VLV2GHljqQ6JKNDo2hBJSXyMrASKVesPpKRS3mnfUAUVMyXnTxKqJyDgywg2cXXYLI/YeygviR6RtSdFD3ZBuqC3RHIxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS7PR11MB6104.namprd11.prod.outlook.com (2603:10b6:8:9f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Wed, 8 Jan 2025 10:56:44 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8314.018; Wed, 8 Jan 2025
 10:56:44 +0000
Message-ID: <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
Date: Wed, 8 Jan 2025 18:56:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0154.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::34) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS7PR11MB6104:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b619573-d763-49d7-12cc-08dd2fd323c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TVZUMzVOeGhWcW5aeEMxc1VHL3JNelEycUoyUkxvbmN1WGhYaGoxUWxjRWt0?=
 =?utf-8?B?S0t0NFB5OGJOLzVLbEVQZUcyWkdxTEo4R05oVm83MkNFczYyUW1FeGM4bHR2?=
 =?utf-8?B?QXJrSE5XOGp6MFp6MVh4VGpsK0dROEQwRS9ZVHBFc0ZQMS9jKzRtMnY0Z3VO?=
 =?utf-8?B?Tnk4dWE3N01xOUFwWjZRSjRidllZOEFqYWF1a3RnYkt1bWhmR25yZUticHVi?=
 =?utf-8?B?TnFZRk8yMWxVakNVNUwrblAyY2M5ZkpWMmliZWhpNUltU3NES3ZkWmswZTVI?=
 =?utf-8?B?eFVRSWpXTWFRWUNEeWlHR3M3dWM5dTk2TWlHRU4zbElNdkRWMDZ6VEdDQzRG?=
 =?utf-8?B?SUpvamZ6aFhpN1dqdzA4KzYxMVNwY1VsbHRldmthOHdFT1ZVQ3pLWTVPdmd5?=
 =?utf-8?B?K0RBSzJJSUY0S04yVjcvbml0alZib0ZXN0h3aEpRSWxoM0o1NndJWEtMVWMy?=
 =?utf-8?B?WitjWFlxNlpvV0pBMmNJVmJpVmgzQzBWNnEveDQzVkZKazVzNzJQM2pEMGJR?=
 =?utf-8?B?eVQxb2tYcmhVbzkxbC9vOFFQK0JNYkNVNFYxaXdnVVNuQnZnRm9YZGpqSWxE?=
 =?utf-8?B?aFFmV01wY0R1SVlrakRneUxHQm9qNXhJaGx2L3dsWjVqU0poenRHRUF0UHl3?=
 =?utf-8?B?VDFZejB6endFWE9Sd0EwVFN0Ylp6RGtJSi9jTURMb05rcFR0eFFqL1g5L05t?=
 =?utf-8?B?NHFCQlVsamVRcXpMTzU5U3VlK1UvK0Nnc0x2dmYyeWdsRmJKeGt0MFI3V3o3?=
 =?utf-8?B?M2NYWjFsZlFYMEJ4dUZCc04zaHF4L3o3cDZSa1d4cGdHbFhTcVpBT0J2WGtF?=
 =?utf-8?B?dkxyeXhXb2N2M1NKeFBNejd4Sk1WQnJFQ1A3NTJDTlc5NWZ6QUxYbmYxdHFB?=
 =?utf-8?B?enM4Y3lQajJ3SkFZcFRMbkV0MFBKRlA2bTNkQ21BUWw2TXIyWGFMZVZpYUVZ?=
 =?utf-8?B?ODc0ZVEra0NXdEhFbWtYMWdnM0JEZ210UWZTRC9uenBmM3o0TzRJdmwzTlVD?=
 =?utf-8?B?YS9lbUFOSEpWR2JCbVVweUtsVlA4S2FOSTZYczFvS1pRcmhZNG1JaE5SVGx5?=
 =?utf-8?B?UzZmcTNCenJUemNXbDZjc0pXRmFrSFFJbGZERmtBS2tsdlJtNWpMZ0ZvTHJF?=
 =?utf-8?B?bGVENzlQbGZxV0hnZ2RXMkRVSElwY3ZCSy9qVC9ScWdsYjFJdjR1YlZjZEx0?=
 =?utf-8?B?RXJQVExzbHpDSFBVWVk1MXNNTSs2VDdUZU5aMVZUaFdwaWpVaDhRUnhHdzJP?=
 =?utf-8?B?WUdvMEhmMFpMK3BPTnNFZENKUUthanRuV2sxbU1KQTZCemo5ZmVRVlQvdE5H?=
 =?utf-8?B?ckVSUUl5VGY4K05WeSsxeStINzliWi9JSFp2MEZoK3Y4Ym1OUGd3SXZzVndG?=
 =?utf-8?B?eldpZjFIZ2VBd3lLbVk1RDhCdGRmdWNCWGxZL01NRzFFOU4wN0FCRVdQQ2ZV?=
 =?utf-8?B?ZlJKSmxVRzE5bFY1SUJyWVZLZVhod3lmZUE2TzlaMXIvRUxodVFNZG15OEti?=
 =?utf-8?B?YXlzU1Z4Wi9hZzhGUnNjQVNjcEZxdFpWV3pZZDZSUWcyVE5SQmF4UUtGS2x4?=
 =?utf-8?B?SHg5T0lSZE5kbWZqdEZHRjY2Y3FLNnFjSmxpNXo1eUVKTklLU1RwQlNOTzNq?=
 =?utf-8?B?eDZpenphSDVSdnVDNGhxZjFUTnE4eEJVZDVvamxXeFdZc0ZwWmgySENiVm1L?=
 =?utf-8?B?cW9VU2JRcitiZ0hacnJtM0FDVEtBSTdQNWdQb0lsRzNuNDE0MkQ3cTdibGRq?=
 =?utf-8?B?Qml2d25Eb1B2eXJ3WUI2blNhRHlUZnVPbEZTYTQvVHdBellHRm1qanNrcDQr?=
 =?utf-8?B?WFJlaEhhYW9FclJ6b3JBcUI3NzJnb2VXN2FyU0NWem91K3pvNFBNNEh6R2hW?=
 =?utf-8?Q?i2/t06UXZYcXt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnE1RkFkSFdsR1JWS21idk5pTWdLYk5LQXlqTnAzUVBGUldlNHkvVkpBU0NP?=
 =?utf-8?B?VEd5S0RmbUVoZHo0SHZxTS9kQ0ZWOC84ZkhEV2xFVFUxV1cxY0Q1T1RqakU4?=
 =?utf-8?B?Q0xld0VaOTFVdlNjVHlJSVRVdDFJd3pMVXRKSFRFUitUem5FN2xTb25QaklG?=
 =?utf-8?B?eDBVb0hMNUh2WGY5alRhSC9pR0JEVzV4amFnWnl3NkZhcUdQcER3bEVsTUhB?=
 =?utf-8?B?bCtqS3JqeDRiVmxrTGIrR3BJVHpIcVRKTkoyQUxNbmUvRERuVVczeENXQVJD?=
 =?utf-8?B?OWFCaEdtUFVlaENkalg5NmcwTEFxT2ljazdiSnlpRkVQbng0UFNBdyt1empJ?=
 =?utf-8?B?U01pTzY5MUx1RjRVenRKSGc1RG0zaFY3a09zSFZNWS94ZnAyNFROZ05LQWUw?=
 =?utf-8?B?MGxoSVM0MHZQU2wvV2lndFZyNkgxcnBFR1l5RHcrUFRnZTZSa0poL2dnRFBC?=
 =?utf-8?B?Tm1ieFRkRFZ3OWg0K09vNktTQ0VoUGdGMWhnelpwUXhEMWIyNHUvb2llMW5l?=
 =?utf-8?B?OEMydmNlZjU5WE1Sb05EWkVHcFNXeUo4ZFcvVGd4ckhSb3lnVGxPVnlNVWlQ?=
 =?utf-8?B?Znd1TUZWWVB4MnN2TTV0alVmK05JaGhNTDd4WkRaVVZnd1NwbHZIZ2ZJdjJO?=
 =?utf-8?B?L1ZNajJ4T0ZpNGcydUJ0TzdCN2hnSjN4cVJLRklnRlNseUZYSTIxVUxHQXRo?=
 =?utf-8?B?eHBMWXJNQkJwSy9TRnAxb1kzVlVrRlRPQlpVSkdLODB3NG5FVzVwM3NSNmh1?=
 =?utf-8?B?d2hBZmVDeEhuazNtaG9XTDEvNnZLNzJ4WWdqS2oxZ3VERG1wOUxkY3Q5RjJN?=
 =?utf-8?B?UThZeVk2WUYzV2VmMXdqNjFBMEpHNEFEczRTOHhqQ1RRMHVKTE1hbThYZHJF?=
 =?utf-8?B?c3dlL25acGdua2pSNngrTzV3UUN0a3NwZDdZU2piL3c3VSs5YUpYNVBaZjlK?=
 =?utf-8?B?TUdmUFZON1IzL2Rhc2t5SUJpY1hKalgzeXBHSVliS21KVkU4SG9NN3dKUzVU?=
 =?utf-8?B?dWJaSVFuV3FieGpEaVdrWGllL0t5R2NCMHlOWk9naXl5MXVmSmdBMXY2NktR?=
 =?utf-8?B?YjYrU0VYTWdWcHRUT2pldkpQOEFsa2kxODRvWlRSeGJVbDNQd05aSzBDVi9X?=
 =?utf-8?B?Rk41bURscTJKK1FHSDlQeVp2czBJK2ZCU1RyWUhFOWtOL2Z1Sktra2JIc1R6?=
 =?utf-8?B?YzRRTW8yS0duMis1bUlBdEtmYmlKN2pKRllDTElrbWxRL3FqTkpQYksvczFG?=
 =?utf-8?B?U0FFeVcvbkpxU09xMDBnQVVMQ25XS2VxeFRCd3N0K1VPamk1RTQ2MWFvWmdl?=
 =?utf-8?B?SWZ1Q296K2x4SGFrOEJOck1TdEEwaDAwNHpxRjhNUUZ5cTFXcWRJajJXV0c1?=
 =?utf-8?B?YWorS2tTK2NJcHlzTHFYNzB3QjhReDJ1U3lsMFN6eVpneVg3Y1RyTUtDZHVp?=
 =?utf-8?B?QU9GakZYU05ZWTRucEVaZGJ3ZllkVWNUWko0b05sUHI1YXlhM0NpV25UUUNS?=
 =?utf-8?B?OGd2Y2ZWNXRXU2xYWDVzTjdRM2R6NWNhVGZ2aEZMbVlmR0Z6REg1R3hvUzlx?=
 =?utf-8?B?ZzhxS01pUjZ1ZkE2N3YzZldYcFpsM2QrUjdvTFIwZDgvMHpNRFpVU2tGUUlR?=
 =?utf-8?B?QlNCZkFzTjhzK1U4aTVndkcwU0wva3hKbmtXZUNQcERVMkRPR3BieUwrNnpl?=
 =?utf-8?B?WmNxelUyS05QamJlWlRISTJja1FVRUpaeEtiYjUxMlVrZXdVa000N0w0UFVT?=
 =?utf-8?B?VThnbUZ0MVo0cXVVYVV0VGx6NTF0QnltWHh2TEROZ2dtWDN2V1FjNURvVzJk?=
 =?utf-8?B?MmJnaytvNFFrUWZrdVE1N3JCS0dncGNxRDhWdXBJSmRlR2tQUGw1OUIybFpj?=
 =?utf-8?B?QXg1YU50YjNKOXduNDJ6QUgzd2l1Q1p6TEdXNUNRelJJTW1adWRaemRtU0Ra?=
 =?utf-8?B?WUtvRW41bk9rNHdEWGpEYkQ0bHVIZDRzQVJncjBDSGVYbGRydG9xbk5ieG5i?=
 =?utf-8?B?cTNFRTdGSlFPMlh0UW1ERTc5ZjhLZVBiTUNaZCtwRm1WTG5UWTBTWjQyK3lr?=
 =?utf-8?B?OER4Z2t1bEI4WFozUTFqZUJKblh0YVRDNHVjakJTN2E4eThUWWdKaEJIbGM5?=
 =?utf-8?B?VzZ3Ui9QeXRxRnRUV3YwSlZydnBhdnJWNlp5aGxoOWJ4QlM4WWtzYitneWc4?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b619573-d763-49d7-12cc-08dd2fd323c1
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 10:56:44.3900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bU0MTdCYFRkSZ81Fz8vc+qg/JmmhGe6B0fhaZRtdbrW3eqm0mPbhHNg1t6VNwLymZuA46hPdHeByQKAiSSh+VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6104
X-OriginatorOrg: intel.com



On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
> On 13/12/24 18:08, Chenyi Qiang wrote:
>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>> uncoordinated discard") highlighted, some subsystems like VFIO might
>> disable ram block discard. However, guest_memfd relies on the discard
>> operation to perform page conversion between private and shared memory.
>> This can lead to stale IOMMU mapping issue when assigning a hardware
>> device to a confidential VM via shared memory (unprotected memory
>> pages). Blocking shared page discard can solve this problem, but it
>> could cause guests to consume twice the memory with VFIO, which is not
>> acceptable in some cases. An alternative solution is to convey other
>> systems like VFIO to refresh its outdated IOMMU mappings.
>>
>> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
>> VFIO mappings in relation to VM page assignment. Effectively page
>> conversion is similar to hot-removing a page in one mode and adding it
>> back in the other, so the similar work that needs to happen in response
>> to virtio-mem changes needs to happen for page conversion events.
>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>
>> However, guest_memfd is not an object so it cannot directly implement
>> the RamDiscardManager interface.
>>
>> One solution is to implement the interface in HostMemoryBackend. Any
> 
> This sounds about right.
> 
>> guest_memfd-backed host memory backend can register itself in the target
>> MemoryRegion. However, this solution doesn't cover the scenario where a
>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend, e.g.
>> the virtual BIOS MemoryRegion.
> 
> What is this virtual BIOS MemoryRegion exactly? What does it look like
> in "info mtree -f"? Do we really want this memory to be DMAable?

virtual BIOS shows in a separate region:

 Root memory region: system
  0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
  ...
  00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
  0000000100000000-000000017fffffff (prio 0, ram): pc.ram
@0000000080000000 KVM

We also consider to implement the interface in HostMemoryBackend, but
maybe implement with guest_memfd region is more general. We don't know
if any DMAable memory would belong to HostMemoryBackend although at
present it is.

If it is more appropriate to implement it with HostMemoryBackend, I can
change to this way.

> 
> 
>> Thus, choose the second option, i.e. define an object type named
>> guest_memfd_manager with RamDiscardManager interface. Upon creation of
>> guest_memfd, a new guest_memfd_manager object can be instantiated and
>> registered to the managed guest_memfd MemoryRegion to handle the page
>> conversion events.
>>
>> In the context of guest_memfd, the discarded state signifies that the
>> page is private, while the populated state indicated that the page is
>> shared. The state of the memory is tracked at the granularity of the
>> host page size (i.e. block_size), as the minimum conversion size can be
>> one page per request.
>>
>> In addition, VFIO expects the DMA mapping for a specific iova to be
>> mapped and unmapped with the same granularity. However, the confidential
>> VMs may do partial conversion, e.g. conversion happens on a small region
>> within a large region. To prevent such invalid cases and before any
>> potential optimization comes out, all operations are performed with 4K
>> granularity.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   include/sysemu/guest-memfd-manager.h |  46 +++++
>>   system/guest-memfd-manager.c         | 250 +++++++++++++++++++++++++++
>>   system/meson.build                   |   1 +
>>   3 files changed, 297 insertions(+)
>>   create mode 100644 include/sysemu/guest-memfd-manager.h
>>   create mode 100644 system/guest-memfd-manager.c
>>
>> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/
>> guest-memfd-manager.h
>> new file mode 100644
>> index 0000000000..ba4a99b614
>> --- /dev/null
>> +++ b/include/sysemu/guest-memfd-manager.h
>> @@ -0,0 +1,46 @@
>> +/*
>> + * QEMU guest memfd manager
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
>> +#ifndef SYSEMU_GUEST_MEMFD_MANAGER_H
>> +#define SYSEMU_GUEST_MEMFD_MANAGER_H
>> +
>> +#include "sysemu/hostmem.h"
>> +
>> +#define TYPE_GUEST_MEMFD_MANAGER "guest-memfd-manager"
>> +
>> +OBJECT_DECLARE_TYPE(GuestMemfdManager, GuestMemfdManagerClass,
>> GUEST_MEMFD_MANAGER)
>> +
>> +struct GuestMemfdManager {
>> +    Object parent;
>> +
>> +    /* Managed memory region. */
> 
> Do not need this comment. And the period.

[...]

> 
>> +    MemoryRegion *mr;
>> +
>> +    /*
>> +     * 1-setting of the bit represents the memory is populated (shared).
>> +     */

Will fix it.

> 
> Could be 1 line comment.
> 
>> +    int32_t bitmap_size;
> 
> int or unsigned
> 
>> +    unsigned long *bitmap;
>> +
>> +    /* block size and alignment */
>> +    uint64_t block_size;
> 
> unsigned?
> 
> (u)int(32|64)_t make sense for migrations which is not the case (yet?).
> Thanks,

I think these fields would be helpful for future migration support.
Maybe defining as this way is more straightforward.

> 
>> +
>> +    /* listeners to notify on populate/discard activity. */
> 
> Do not really need this comment either imho.
> 

I prefer to provide the comment for each field as virtio-mem do. If it
is not necessary, I would remove those obvious ones.

>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>> +};
>> +
>> +struct GuestMemfdManagerClass {
>> +    ObjectClass parent_class;
>> +};
>> +
>> +#endif

[...]

           void *arg,
>> +                                                 
>> guest_memfd_section_cb cb)
>> +{
>> +    unsigned long first_one_bit, last_one_bit;
>> +    uint64_t offset, size;
>> +    int ret = 0;
>> +
>> +    first_one_bit = section->offset_within_region / gmm->block_size;
>> +    first_one_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>> first_one_bit);
>> +
>> +    while (first_one_bit < gmm->bitmap_size) {
>> +        MemoryRegionSection tmp = *section;
>> +
>> +        offset = first_one_bit * gmm->block_size;
>> +        last_one_bit = find_next_zero_bit(gmm->bitmap, gmm->bitmap_size,
>> +                                          first_one_bit + 1) - 1;
>> +        size = (last_one_bit - first_one_bit + 1) * gmm->block_size;
> 
> This tries calling cb() on bigger chunks even though we say from the
> beginning that only page size is supported?
> 
> May be simplify this for now and extend if/when VFIO learns to split
> mappings,  or  just drop it when we get in-place page state convertion
> (which will make this all irrelevant)?

The cb() will call with big chunks but actually it do the split with the
granularity of block_size in the cb(). See the
vfio_ram_discard_notify_populate(), which do the DMA_MAP with
granularity size.

> 
> 
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            break;
>> +        }
>> +
>> +        ret = cb(&tmp, arg);
>> +        if (ret) {
>> +            break;
>> +        }
>> +
>> +        first_one_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>> +                                      last_one_bit + 2);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int guest_memfd_for_each_discarded_section(const
>> GuestMemfdManager *gmm,
>> +                                                  MemoryRegionSection
>> *section,
>> +                                                  void *arg,
>> +                                                 
>> guest_memfd_section_cb cb)
>> +{
>> +    unsigned long first_zero_bit, last_zero_bit;
>> +    uint64_t offset, size;
>> +    int ret = 0;
>> +
>> +    first_zero_bit = section->offset_within_region / gmm->block_size;
>> +    first_zero_bit = find_next_zero_bit(gmm->bitmap, gmm->bitmap_size,
>> +                                        first_zero_bit);
>> +
>> +    while (first_zero_bit < gmm->bitmap_size) {
>> +        MemoryRegionSection tmp = *section;
>> +
>> +        offset = first_zero_bit * gmm->block_size;
>> +        last_zero_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>> +                                      first_zero_bit + 1) - 1;
>> +        size = (last_zero_bit - first_zero_bit + 1) * gmm->block_size;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            break;
>> +        }
>> +
>> +        ret = cb(&tmp, arg);
>> +        if (ret) {
>> +            break;
>> +        }
>> +
>> +        first_zero_bit = find_next_zero_bit(gmm->bitmap, gmm-
>> >bitmap_size,
>> +                                            last_zero_bit + 2);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static uint64_t guest_memfd_rdm_get_min_granularity(const
>> RamDiscardManager *rdm,
>> +                                                    const
>> MemoryRegion *mr)
>> +{
>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>> +
>> +    g_assert(mr == gmm->mr);
>> +    return gmm->block_size;
>> +}
>> +
>> +static void guest_memfd_rdm_register_listener(RamDiscardManager *rdm,
>> +                                              RamDiscardListener *rdl,
>> +                                              MemoryRegionSection
>> *section)
>> +{
>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>> +    int ret;
>> +
>> +    g_assert(section->mr == gmm->mr);
>> +    rdl->section = memory_region_section_new_copy(section);
>> +
>> +    QLIST_INSERT_HEAD(&gmm->rdl_list, rdl, next);
>> +
>> +    ret = guest_memfd_for_each_populated_section(gmm, section, rdl,
>> +                                                
>> guest_memfd_notify_populate_cb);
>> +    if (ret) {
>> +        error_report("%s: Failed to register RAM discard listener:
>> %s", __func__,
>> +                     strerror(-ret));
>> +    }
>> +}
>> +
>> +static void guest_memfd_rdm_unregister_listener(RamDiscardManager *rdm,
>> +                                                RamDiscardListener *rdl)
>> +{
>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>> +    int ret;
>> +
>> +    g_assert(rdl->section);
>> +    g_assert(rdl->section->mr == gmm->mr);
>> +
>> +    ret = guest_memfd_for_each_populated_section(gmm, rdl->section, rdl,
>> +                                                
>> guest_memfd_notify_discard_cb);
>> +    if (ret) {
>> +        error_report("%s: Failed to unregister RAM discard listener:
>> %s", __func__,
>> +                     strerror(-ret));
>> +    }
>> +
>> +    memory_region_section_free_copy(rdl->section);
>> +    rdl->section = NULL;
>> +    QLIST_REMOVE(rdl, next);
>> +
>> +}
>> +
>> +typedef struct GuestMemfdReplayData {
>> +    void *fn;
> 
> s/void */ReplayRamPopulate/

[...]

> 
>> +    void *opaque;
>> +} GuestMemfdReplayData;
>> +
>> +static int guest_memfd_rdm_replay_populated_cb(MemoryRegionSection
>> *section, void *arg)
>> +{
>> +    struct GuestMemfdReplayData *data = arg;
> 
> Drop "struct" here and below.

Fixed. Thanks!

> 
>> +    ReplayRamPopulate replay_fn = data->fn;
>> +
>> +    return replay_fn(section, data->opaque);
>> +}
>> +
>> +static int guest_memfd_rdm_replay_populated(const RamDiscardManager
>> *rdm,
>> +                                            MemoryRegionSection
>> *section,
>> +                                            ReplayRamPopulate replay_fn,
>> +                                            void *opaque)
>> +{
>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>> opaque };
>> +
>> +    g_assert(section->mr == gmm->mr);
>> +    return guest_memfd_for_each_populated_section(gmm, section, &data,
>> +                                                 
>> guest_memfd_rdm_replay_populated_cb);
>> +}
>> +
>> +static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection
>> *section, void *arg)
>> +{
>> +    struct GuestMemfdReplayData *data = arg;
>> +    ReplayRamDiscard replay_fn = data->fn;
>> +
>> +    replay_fn(section, data->opaque);
> 
> 
> guest_memfd_rdm_replay_populated_cb() checks for errors though.

It follows current definiton of ReplayRamDiscard() and
ReplayRamPopulate() where replay_discard() doesn't return errors and
replay_populate() returns errors.

> 
>> +
>> +    return 0;
>> +}
>> +
>> +static void guest_memfd_rdm_replay_discarded(const RamDiscardManager
>> *rdm,
>> +                                             MemoryRegionSection
>> *section,
>> +                                             ReplayRamDiscard replay_fn,
>> +                                             void *opaque)
>> +{
>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>> opaque };
>> +
>> +    g_assert(section->mr == gmm->mr);
>> +    guest_memfd_for_each_discarded_section(gmm, section, &data,
>> +                                          
>> guest_memfd_rdm_replay_discarded_cb);
>> +}
>> +
>> +static void guest_memfd_manager_init(Object *obj)
>> +{
>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>> +
>> +    QLIST_INIT(&gmm->rdl_list);
>> +}
>> +
>> +static void guest_memfd_manager_finalize(Object *obj)
>> +{
>> +    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
> 
> 
> bitmap is not allocated though. And 5/7 removes this anyway. Thanks,

Will remove it. Thanks.

> 
> 
>> +}
>> +
>> +static void guest_memfd_manager_class_init(ObjectClass *oc, void *data)
>> +{
>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>> +
>> +    rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
>> +    rdmc->register_listener = guest_memfd_rdm_register_listener;
>> +    rdmc->unregister_listener = guest_memfd_rdm_unregister_listener;
>> +    rdmc->is_populated = guest_memfd_rdm_is_populated;
>> +    rdmc->replay_populated = guest_memfd_rdm_replay_populated;
>> +    rdmc->replay_discarded = guest_memfd_rdm_replay_discarded;
>> +}
>> diff --git a/system/meson.build b/system/meson.build
>> index 4952f4b2c7..ed4e1137bd 100644
>> --- a/system/meson.build
>> +++ b/system/meson.build
>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>     'dirtylimit.c',
>>     'dma-helpers.c',
>>     'globals.c',
>> +  'guest-memfd-manager.c',
>>     'memory_mapping.c',
>>     'qdev-monitor.c',
>>     'qtest.c',
> 


