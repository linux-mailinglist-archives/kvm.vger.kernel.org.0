Return-Path: <kvm+bounces-57971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8F5B82FD7
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CC6C6246DB
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC649287515;
	Thu, 18 Sep 2025 05:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="coxZVd3n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D89827FB03;
	Thu, 18 Sep 2025 05:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758172755; cv=fail; b=oL0vFzC18RsPqt37HwZeFkBCCs+WIfGcOq68yMh6q9gzmui/+8YgJss5vv2LgKC6ABWDkMjSMpF7pvSv94Xb6QSI4pWpV3V7YYKFU1ibbUBUziNwCCY1v6HgHRqj0ArKrQY4ZJJFbYIg8jw/XJfNZs6uXQ50FDHespBTCZsjrd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758172755; c=relaxed/simple;
	bh=AHiC31litasF86z9ATbLw6ou2+CWqDIwQsc0b+sfYjI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IIPUdOikPC/Pz74oQS5im4Aey6A4ad1lEzSNehuu9/mt+XNOtsC2yyI306FgGGBWnDh0c5gS6otRS6eS47FP4MwZNX2BDm19bzZQpBd6FemUfVsV3ajs1fSqZvhJT0nZHt0z8b1S8EsTNuVPcdKaC+QJjZwHpuiP5FxE4BODiTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=coxZVd3n; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758172752; x=1789708752;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AHiC31litasF86z9ATbLw6ou2+CWqDIwQsc0b+sfYjI=;
  b=coxZVd3neakDpoDzhIRuCd3EfnablUGIv3nq54FT2AFXHzVn4184L39z
   KaIHdQp35ToBwk2C7sXv2A7/yhyNv7V4201Nvth1k+kcvhj6dA7vDFb4q
   gUGgXTfjZbtw+VG1wZYMQrrycpki0+jcl4cN09dLaiilQt3yS3T61WtQ2
   XGQ0T1SyqoDAbhGDWMOSwVoH4hw6rotYUOFr7UK0YuhU1IN/KkdXk3zLD
   5hP1oUB7J/fVkSRd9gAMSdgxTfdm5sOoagxp+aE13bnrOrU552MX0ro6b
   HBc1aNJby3c99l4GUKsm4u+1OR/GuDQGiOlLAnbnz8V7NwpeeYg5kZzPI
   g==;
X-CSE-ConnectionGUID: 20A8w7Y1RgaaYWTQz87RrQ==
X-CSE-MsgGUID: Yv2Vsm+CSQeNddQG9XQFWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="85933358"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="85933358"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:19:11 -0700
X-CSE-ConnectionGUID: OHo33bxyRQKyyudAFPy2DA==
X-CSE-MsgGUID: U3EwOBR8TFaBlbzfrAwL4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="175355358"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:19:11 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:19:10 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 22:19:10 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.33) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:19:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qI9iQfj5a9CPAjK1ECY/oDwk3mMIDeSNjElQWx8we1CJh2HlXsFatlrbd+V3t8oVQBsRInRmGcvMtIQ07a05ssiksyjsvR7vNnuIXHFJUWHlvq9cLWfiFviE+8TrA+gLuzi3xeJKmVJbhOzq7HZ7z2+mGeEo76b1XABqpvEm0rzH/xJbaAl2S0yT0uix/jHloKcszsPr/wdxKTVObLS6iMbUGRk70sRcdgWuhde+yIQW3c47ItCe/pxEnilowIMyUijnaKzHuFTa1sk93LoOKqVA24bw5mBQB7HtuoNcYbJkX440R8e1Oaeogjaq9hIsFl6tq3lyJ18NmIgU//Xurw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIP6AsHH7g7kzjcBQNqe4BXxe56+5b48QZhpZFkpoTw=;
 b=IAV3LVdFoAh9F92oswU8pFeSv4sUEpYvSfFkwcTyeMz+bIXMRdKHN7V1f3QqEzB4onUd7YrnIZa2rkmaEDdrnhNHgWcRdVSm/PZtzRZvj2LO67H/ocyHzCgWQvaSSwWoTkeU6eKoYtOjJO7MDWxZW8c4xdKqLH65qYyOctjHNOQN8k2sUKJM185zA7vRHiwC4V9LxqwKMa3by+/3URNf4K86sky5hFLf0X71S4LxJHpOoJoE4NTgI8L8vByW5Ekhqzb4FFqjj+OOiOj7e/aen8IfddvaNKyBC2myvYAP6wSQGgolO5JjlGWfv5ucvZWffO6iNmUjG+YVox4fYYM9Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB8336.namprd11.prod.outlook.com (2603:10b6:208:490::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Thu, 18 Sep
 2025 05:19:08 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 05:19:08 +0000
Message-ID: <81d4fd30-9897-4322-a8af-a78064d238fb@intel.com>
Date: Wed, 17 Sep 2025 22:19:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 04/10] x86,fs/resctrl: Implement "io_alloc"
 enable/disable handlers
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <cover.1756851697.git.babu.moger@amd.com>
 <c7d90ec5ab2c96682b6eca69b260631847061a61.1756851697.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <c7d90ec5ab2c96682b6eca69b260631847061a61.1756851697.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::36) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB8336:EE_
X-MS-Office365-Filtering-Correlation-Id: 13c667b2-59d3-47d5-13a0-08ddf672e4a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R0hpb1hFd20weGtYN0lBdEh2MkxWZXNKc2FoODB3Tm5kZDdpTzNLY2w1V1R4?=
 =?utf-8?B?MnNtZDRhbWJTVEdEQ25VMGdDOWUxa0M5YVM0WEF5L0ZkZERISDFDN0x5TzR4?=
 =?utf-8?B?ejNIME9RMXlialMreU5FYStySlJib1Q5aEtoYTFJOFVoeGdHdEpiQzhyZUVk?=
 =?utf-8?B?c0diSVlIZ2l6NlBJMjdMcTd5NWhDeWQ3dFRPU2xMcUt2QVFlWmtieGF6cnlx?=
 =?utf-8?B?YXY3aFlOTVpvU2VZcDl1NWprODY3SVh6U0MwNFZYNWdiOWVlY29ya050VVFK?=
 =?utf-8?B?cXloNVplT1pVcHgvT2drK2ZUODF0RC95cm95VkVjQnB5d25iZlVuMnFkWlhO?=
 =?utf-8?B?OTEweC8yNDJDRHZlU0tDNWl3N21taDVhM3R0MnpHNWY5M3R3bHB3VVR1MFJv?=
 =?utf-8?B?aU9rYm9Ha2k2UitmVDBPSU4wUXRYdVl4OU5DOWY2V2NqaFI4Q09iL1Jha0p5?=
 =?utf-8?B?ODluVXFHSUtPTXo0bHFpbHRJREwvd3FHSTAxczN1YW9qTTIyUE12NUQ5RWxi?=
 =?utf-8?B?Ly9GQlhhdm5TcjVkYWtTK0JhUWVsei83SlRUUnE3N3YvUG1yakNHZ0dwU2hu?=
 =?utf-8?B?UlgxWS9TVGR3TmJ0YVdCc3dxU2JLUFIxbjF3MjljWXJvaUljNjR2WCtad1Rm?=
 =?utf-8?B?bEdobHZadTVyMkFqSk4vYkZzVmFiYjBhRHpJeFdqRW5JWjRobm1yTUV6b3Z2?=
 =?utf-8?B?bkFzQ1Y4RXV6L05sdjgyNzJMYnF6TlBhUWY5bWs5RUx6TGNVeUVWTkpKcHll?=
 =?utf-8?B?OGRJSzh3cjhROGYvWnFXY1FqT2lZV1NUWlh1dXhCRzNvTTRRSW9SSG0vS3hF?=
 =?utf-8?B?YUw3SUo3YzRrckcreW84cnpGdTZ3L3RleEpyMDBXQ1RnUTA0R0xYQklDc2g0?=
 =?utf-8?B?MkxCNFVBdWY0RS9ISk01Q2Y1Y1c0OWtoQzlUVCtQbjNFTElsUEIrR3gvQkZi?=
 =?utf-8?B?S2ZOeEF2emlmTG93RnRSbTl3SjlmT2ZCcU0zdm5tWmY1WGxhc0lTeS92azBY?=
 =?utf-8?B?N0I0YVZTd2NKb2wrMmIxVzVWeTZBWmc1Z0Vib0dMb2grK0NNU3VVck1hY2FO?=
 =?utf-8?B?cHBUZTJqWGppaTFKWVVwYWdhTkhMZHZsaytRODZpSHdTblZPKzkvSnpRZU9F?=
 =?utf-8?B?ZjdvcGpsaVBqZzZkeCtDYjhsT0NTd2dLUmkxc08rTTM4d3Y4UDhGTUZMYkp2?=
 =?utf-8?B?dnVJcm1tbWlJZFhsVnVYYmloN05TTFFqYnYwcVpVWVFoY2VZS0RKbTdBbnBQ?=
 =?utf-8?B?K0xxRTNORnltWENIQkQ0VitqdURXQlIxMW43LzZxR2ExUkI5NEIwUjlsS2Fq?=
 =?utf-8?B?ZnBCZnpxc3liTHl6M0V0Q0hPeVhEcUF3TTRtVkpmZ0pmdklxaXplUkY3bk9U?=
 =?utf-8?B?S2RaQ0dYYjJPaFNJYWMwei9qaldhY2tCTSsvdzczR0RrMUNsUUNFMm0zblZR?=
 =?utf-8?B?Mi9BZDVFcGU4QlRFRU5mZTJKSCsydmZEYkpOdmVaNmU4akxSZXB3QWg3MGdj?=
 =?utf-8?B?d0FraVllcWhmc0U1RlpxZkluazh3OUpaNUEvTndsQjFPa0xpRUg5UjYzQ3cx?=
 =?utf-8?B?WXRJdGhnL2c0cUY4YXZGMDI0QWhMbjA3bi9QMkZqTmVkaUNTZklaQkNHanRB?=
 =?utf-8?B?d3hQRWRSMnp5N1lqcVM5eFdqY0tTOVU2NlNsaFYzQjZkZWtXNEZPVCsrREp5?=
 =?utf-8?B?bzVJNXU0TXZJdHFZNGZGblVqZnl5OElmQU4wQ2k0aXJPNmtGb3hVUHM3ajNz?=
 =?utf-8?B?Y2c3OG1ZZjVINGNZY2hoVnltWHU5TWU2NHdDM0FBeCsvQU9XRGtYTno2NlN2?=
 =?utf-8?Q?sorgdm3uPYp5uLutg60qWqbPkWUdQ7kcX8E3g=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UW12WEU2VTFneWpiRkdreEpvelM2Q0RpMEU5MU5qaEVuU1RVZXp2ZVgzdjlY?=
 =?utf-8?B?TXFmS25rVnI0NGZrd0lTNHpYbE40elZYVGlOZ3ZYRkRHNnhUb3l2d0V0YTFi?=
 =?utf-8?B?eCtZSEVvZFVvWDk3NWpTU2w3elpUM0hhM0tCWnpSRnRNVWNRbnI2RjRFd2dK?=
 =?utf-8?B?dklTY0F5amxnL04yZ0FkUXQ3cGtudUM2aVZFYWlUL3UzdW9sTDlQLyswUmlv?=
 =?utf-8?B?S0gwQ0htQWwvWG1YU1FsL2UwV3ByNm5pam55ZTFMWThqanZTQVErUXZRVHdS?=
 =?utf-8?B?RUdPdktvQlU4UnhzWnpwdmduUStZVEtGSHFJMjZHbHY4cWtTaFI2UnZXV3Er?=
 =?utf-8?B?cWZxVHM5bk4wRlBzZG1nVzdyMFJDSVB3a1oxbHE2R1JFY1BKVlRBSnJFQmFT?=
 =?utf-8?B?S3pqeHhMWitpUVUxMFBHY0hHMUJFY1BaazB2YkZqeGRTSWZydXRPL3ZWNEVK?=
 =?utf-8?B?REg1UVY4ZEVJaWxMUTBhWTBub1FSUlVXb2QwVExDWExRcnQyTElqcXVBYURq?=
 =?utf-8?B?TTVoRTJ0NFdxS0toQmlUY1BmMVhzZzZRbHpZTURCVmNSODlzaFY1ZW9RcU4v?=
 =?utf-8?B?UDFYSWxWaVhQVzI1M1hvR2puZXl3T2pPcitheEZKZmRpc0tHeUdLclFUNnpq?=
 =?utf-8?B?TXFjc1d5cmdkNmEvRG4wc3dPWHFlbFhseUVtS0hkQ3ZKSm1FdDg1b3FDcTF3?=
 =?utf-8?B?T01SZjNOK3FHZS9TaytVWlhJMjFIdk5GTkxsQ2MxWStybStMRWJ3VU5xYnFJ?=
 =?utf-8?B?S3grUEN6MW1mTFRZc2NocFZBQlFrdWdHZ3phcjBUaklNeWVJTEhVVVIyUUlv?=
 =?utf-8?B?bUlhYTg3S0tvMmE1OTlKSE1NcDZ5cFJXa0lYTUg3TjRTVWRIcmFtK09ocE1j?=
 =?utf-8?B?SU43RHc1TldNTlE0SVQxMDdiUGs5alcveXNoTzVuUlJESnBVME1zbzhnY2Er?=
 =?utf-8?B?aSsxZSt4UEhMSm9iNXVtR2VWUHlPQmwxcWJkL1JjamNBV0FUamoxZi9zb2tK?=
 =?utf-8?B?TzVQbFFuOUVXdGpiSHBHeDdpL3M1ejd1cGllbEFEdVpIUDBBL1RWNDVTaHFq?=
 =?utf-8?B?TnppUFVQOWw3ZXlZN2NZMEU1TC82MFMrZWZNc1pVemk2cFNvQlNrNjBScDRi?=
 =?utf-8?B?ZG9OOVIzSHJnOFdDdHMwZm51K3YzVnM0S3ZMZ3YxR2VOTUJWOEN0TTVreGNB?=
 =?utf-8?B?ZG10aXR5VEVoZDRJS1c4YXRvVlRYZWZ2OXAvNnNGNjFlOFpKSTJ5MjJRRDV3?=
 =?utf-8?B?dkY3b1NYK2tXUytEM3FreldkalpxNitNZ3hwQ3ZEbzBBZ2t2eHJKTkI2NWVm?=
 =?utf-8?B?MWNvQjBsTkhabzJwZ2RXZmpRRm5PbU5COEE0QnE2MjE3YWd2dGZQQW1oSnpo?=
 =?utf-8?B?ZmxzZFpuNG1JL1psQzZSUHAzV1g0NHpGbFo3MkFFUmFISnZjWHMyOS9OWFI3?=
 =?utf-8?B?aGlTWVBkdm1HcEEvNW5PY3hNaHJVNUVMVTk0MHhnbXVkZnZqUmh0eWU5Qk1B?=
 =?utf-8?B?RnV1YkUyN0dVeUhwSWtqQ2h2bXdLeDQxaGdmVmRGNm9zUEkydCtpTTIzZUpV?=
 =?utf-8?B?blJmM29GRFA3c0FNYTdlbFBHalltVmM0Z1FwdGtrcWk4dDNXS2VpUndpVTlI?=
 =?utf-8?B?eEFSbC9pRW43bFNTS3ptWFBzZ09oUDRheG9tbFJWL01KU3l0emtsRzJ1MFdN?=
 =?utf-8?B?cW0yQmNrc2JJeFphNERLS0MwZzQraHNmTCt2MTh3NDgzOWYvaG1Yc3plRXh2?=
 =?utf-8?B?NkVObjBYMzJQK0oyNWwxS2poMjFUVGs1WFpEb1l5TnVHZDE0azl3SFd4VVBS?=
 =?utf-8?B?S0N5UG5ibk81TlVLcmlSUUxYd1FCRENORGVuOXBRZWwxZWsyL1dEak5kVEs2?=
 =?utf-8?B?VlZzVklzS3FFTFZmWWxVNjk5aVFqclFSWjQreEFxYXZlQ2dpWTJRRDlzU2pI?=
 =?utf-8?B?TjlHTzVEelhMUEMwcTNCK3A4UUlOMFJKVE9xSi9rdEF2ZUdKb1loS0p3Nitv?=
 =?utf-8?B?dlVSWU0xYjlITVZEdklFV0ROa2dDUWh4SWdUZTlibXB6QmJQQ1gwN3ZLYzBn?=
 =?utf-8?B?b0E3RkhnU2FwMEtHZVdIcVpyMFV5TlBSb2Vndm13cFB3M0thcGtrQXJreGdY?=
 =?utf-8?B?RTdCTGE1Wk5SbHhCNlUvMjJtZDJMdzFiSVZHZTF5d0c4ZVY3bnRjaWZiR2Rz?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13c667b2-59d3-47d5-13a0-08ddf672e4a7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 05:19:08.0426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MCCSP169+D9cVkhvx7cLQ+W5xDHFrEM5QvdeOtRcr74NOk3RSczt2xmMn1U3q3Lv9DPzeTCx0qV/AknH5s9GcgI5WKXYe2UyPGtSmy3fV80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8336
X-OriginatorOrg: intel.com

Hi Babu,

On 9/2/25 3:41 PM, Babu Moger wrote:
> "io_alloc" enables direct insertion of data from I/O devices into the
> cache.

(repetition)

> 
> On AMD systems, "io_alloc" feature is backed by L3 Smart Data Cache
> Injection Allocation Enforcement (SDCIAE). Change SDCIAE state by setting
> (to enable) or clearing (to disable) bit 1 of MSR L3_QOS_EXT_CFG on all

Did you notice Boris's touchup on ABMC "x86/resctrl: Add data structures and
definitions for ABMC assignment"? This should be MSR_IA32_L3_QOS_EXT_CFG
(also needed in patch self, more below)

> logical processors within the cache domain.
> 
> Introduce architecture-specific call to enable and disable the feature.
> 
> The SDCIAE feature details are documented in APM [1] available from [2].
> [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
> Publication # 24593 Revision 3.41 section 19.4.7 L3 Smart Data Cache
> Injection Allocation Enforcement (SDCIAE)

(same comment as patch #1)

Changelog that aims to address feeback received in ABMC series, please feel free
to improve:
	"io_alloc" is the generic name of the new resctrl feature that enables          
	system software to configure the portion of cache allocated for I/O             
	traffic. On AMD systems, "io_alloc" resctrl feature is backed by AMD's
	L3 Smart Data Cache Injection Allocation Enforcement (SDCIAE).                           
                                                                                
	Introduce the architecture-specific functions that resctrl fs should call
	to enable, disable, or check status of the "io_alloc" feature. Change
	SDCIAE state by setting (to enable) or clearing (to disable) bit 1 of
 	MSR_IA32_L3_QOS_EXT_CFG on all logical processors within the cache domain.                                                        
                                                                                
	The SDCIAE feature details are documented in APM [1] available from [2].        
	[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming         
	    Publication # 24593 Revision 3.41 section 19.4.7 L3 Smart Data Cache        
	    Injection Allocation Enforcement (SDCIAE)                                   

> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]

(please move to end of tags)

> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

... 

> +static void _resctrl_sdciae_enable(struct rdt_resource *r, bool enable)
> +{
> +	struct rdt_ctrl_domain *d;
> +
> +	/* Walking r->ctrl_domains, ensure it can't race with cpuhp */
> +	lockdep_assert_cpus_held();
> +
> +	/* Update L3_QOS_EXT_CFG MSR on all the CPUs in all domains */

"L3_QOS_EXT_CFG MSR" -> MSR_IA32_L3_QOS_EXT_CFG

(to match touchups needed to ABMC series)

> +	list_for_each_entry(d, &r->ctrl_domains, hdr.list)
> +		on_each_cpu_mask(&d->hdr.cpu_mask, resctrl_sdciae_set_one_amd, &enable, 1);
> +}
> +
> +int resctrl_arch_io_alloc_enable(struct rdt_resource *r, bool enable)
> +{
> +	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> +
> +	if (hw_res->r_resctrl.cache.io_alloc_capable &&
> +	    hw_res->sdciae_enabled != enable) {
> +		_resctrl_sdciae_enable(r, enable);
> +		hw_res->sdciae_enabled = enable;
> +	}
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 5e3c41b36437..70f5317f1ce4 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -37,6 +37,9 @@ struct arch_mbm_state {
>  	u64	prev_msr;
>  };
>  
> +/* Setting bit 1 in L3_QOS_EXT_CFG enables the SDCIAE feature. */

"L3_QOS_EXT_CFG" -> MSR_IA32_L3_QOS_EXT_CFG

Reinette



