Return-Path: <kvm+bounces-50768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C637AE9129
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E87EC4A3AD1
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D559E26D4C7;
	Wed, 25 Jun 2025 22:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YR9iaXq9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CB81B0F23;
	Wed, 25 Jun 2025 22:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891155; cv=fail; b=TOOqwNTq0evBHnGFw/bFQSUS8SuRN3vSLlwhhiCXCdY/2+4hPxZBLNYUh0aeU/UTGaxmZzWvK0xSkOY12tMTtBBaPTLWDh/+MdkUKVk55eSW/porC9ij8LtW1gH1is8/n56oRLGmK2yQwYGHcAlOv2TmLr2GiPFvmNbuPzpdgWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891155; c=relaxed/simple;
	bh=2Kvvlv0OnAqND8x8Bn0rEMatFFOoYMeaAA6otgcJjfE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sjaz9o32ORbcly2cBtIUXDPOETPjteYFS4BBtBX6uzZPW+sjYi/fHpc0AP7P3awDjSfb+feGJqDi2OSB8IIRTZvWyGcdykoRa1L0cEaig39pELtMWDxwQHYNv8oFw84o0mtf66kyZ1gSm/BT8XGWLHpP0PoTmlnwn5lZAniTxHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YR9iaXq9; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750891153; x=1782427153;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2Kvvlv0OnAqND8x8Bn0rEMatFFOoYMeaAA6otgcJjfE=;
  b=YR9iaXq9XfJbW0Jc/k1nlqh5Fh7lmrN+dmbxwSWGMIGhxJVjtDWOm3ZT
   B5zokaUcghEhrnKgPqmf4iYamBPoS3is68Agv2QdYxRPvhTTufO0pT7R+
   ZAUMQI+ocXj6wmgPx4T3YiyVTHpxH8EWmlzFYGW7VyWx1yJbux5f/qUg7
   kyvRUPRWswuTWM24GMdqKhnTwdZ9/l8qXrbN7Cgc+W138seSv5Vfo2iPT
   qfEudPtoIu1JpWnl6guZiu1V6wD5JgMRhW6mBCvYdFavmM/TxBmmo6lJ3
   gB/9vQmdHHHsV8ch1p8rSPGT00yozb4JpisfC1m7GvQAn29lhMd/rJ2cs
   A==;
X-CSE-ConnectionGUID: 0UN5cDH3TOqlE9mY/7Cp9A==
X-CSE-MsgGUID: lAhqP1uQRGS0HDlNvk9uYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="63866131"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="63866131"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 15:39:13 -0700
X-CSE-ConnectionGUID: vdmSRpCQSlyrq5AwF2sPyA==
X-CSE-MsgGUID: ormSoM+7QTSMsbqfiU9pJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="152465126"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 15:39:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 15:39:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 15:39:11 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.77)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 15:39:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TG/CJ5U0KHTAjXeSycw1qXv8xA9t/eAI0ogeWZhGMjpgZlUChj5hoN0BYEM2SVMdHd0X++csQejWUeKx1IE5Ebmdpn3r3UWAcYeQfxdqUL48V2/md+sq2a9O88dsolvfQQY4DP7yj7M2UKH7AoP8bhb38ua8e/3gbhMo70oCdeiYuGtdRWaL/HhVUBi+GqvoHsZDE9DfyjgRjDd+eT1EkkyqmITpYHjEGU3aYHnzV+2vmcA0t0h2I0YKriIveL0GmR1aqITS/wBiSymS7kX4V/7MrfeuBFgfy1t1a8I0l7YCzV+dqZr5Bm3f8tvaK5skur2EPblwfs0wl3CJUzTK9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Kvvlv0OnAqND8x8Bn0rEMatFFOoYMeaAA6otgcJjfE=;
 b=EopNLxXK8N7Bttj/f9A5oN+XODrvGvkK49Pm/zKWgYkal2TaYgBRK/7mbhgFSYlMKICCC7qF7rvcOLZP463CBeTmvg/Sh10W0OCNWhhtdctvpGMMhmR1d7ZwycbhiTrj6MtjPfynN0rpfrJUazBXru2GhaZ9UIwRyDsQqvk0PT1nvYTXORVgtYTy5Dzvlj/kvFKUm46TypDEckTxjuB1H5il06dC5av8copuiRxGC0dBU4Z+NN9kXaG0TOiInGpZi71FHWOgnAcYon0L+u8/Om5VuHkbQuu7b82UzYO3DKjwal+vJQG85DWna4DtPcRyka2liFS/NzRmhG4FGdWdBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA3PR11MB9448.namprd11.prod.outlook.com (2603:10b6:208:572::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.26; Wed, 25 Jun
 2025 22:38:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 22:38:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Huang,
 Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 08/12] KVM: TDX: Handle PAMT allocation in fault path
Thread-Topic: [PATCHv2 08/12] KVM: TDX: Handle PAMT allocation in fault path
Thread-Index: AQHb2XKum6lt6z+w7k2vHggT003XBrQUkOeA
Date: Wed, 25 Jun 2025 22:38:42 +0000
Message-ID: <aba17e84f56f2a51e7d3cf0e286a898adf66dc46.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA3PR11MB9448:EE_
x-ms-office365-filtering-correlation-id: ddae3dbd-74f5-46aa-a8fa-08ddb43909bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UXU3eC9MNVQ2TUVkbW5Jd3YvSlVxYkNOdmViN3grRFlnOGY1MTlCOCtSTzJM?=
 =?utf-8?B?K0U5S2FyMlVuME1jek9vZ1lhLzJaa2pDYTE0dWtJVm54ckR3NDZld25Bakpv?=
 =?utf-8?B?U292MXEwRk90TkVUSFBqdzZXeTl6TjYrRk91MklMMitrZjlEU1NUVkYxQXg3?=
 =?utf-8?B?N2hYbVdZbnk3cTVQaXVDeVdkRVQreU16YTJwVXRjazhhY2hpTlIxQWdOQWpK?=
 =?utf-8?B?ZTR1ekZyM1JpaytKT0QyZ1lpR3N1TVdRd1BLYlNBcENsUWdoNWZ2RUNhTkJC?=
 =?utf-8?B?b2owenYzeU1TckxQSVJvNGU0MGJQQ3BjTXBFOGkyT1YxRFVVNG1UOHl0cGk1?=
 =?utf-8?B?aHdvbWxtZFZJSzlOc0tUQUo5MjJuZlJmTlYyT0RtZk1UNW5oZ3VUbDN5dmpy?=
 =?utf-8?B?blJwTytXL1V3Q1lIRnFoZW1BOEhVRiswUDAyMnJpMldoTjhSVWZ1c3g5K3M3?=
 =?utf-8?B?YVNqOW91U3hQb2l0eldHUnFrOS85c3NlNlRIQjBiZk4yUG1iRVh2ajR5ekpJ?=
 =?utf-8?B?OTZQMm1VcERPRkZKb0RRUE9EdVFvcEREYWFqQ21EM3p4Ry9ZS2dLSGg5bGc5?=
 =?utf-8?B?dWhFL2xXM01PZnZxMnlMVkJsVWlTSkFDc1RPcmhWc3R4VlRZRktLK1Rkcmc4?=
 =?utf-8?B?OEtLK3RnT3lQRnhlUTI4cmMzdmF5YVdhaUo5RjNCN1VTc3FhWTkzUHVYOU1C?=
 =?utf-8?B?eENkbk1JSGZwUzVhUVZiYndEaUkvcG1JZ1RFMjB6WEg2Qmg1MnhnelNqcTNM?=
 =?utf-8?B?Q2NHeHVrUFRUditlM2xOckZSNmdSd1pPKzlkLzZnL0tpc0xPVm4zU3orWXVU?=
 =?utf-8?B?ZE4zN1V2NWk2NlZSbld1dHVoQXpCeFkxbVNiYnMvTDQwYWNsbERhSmF2WGhG?=
 =?utf-8?B?ZlNPUUFFWG9mMXRPTi9IZVdJS2plZ0hHa1kxREdzV2xXYWNtcHdzbTcrVTln?=
 =?utf-8?B?dUlJVmx0SG50aUVrQ0F1VDNncmI1Njlud0d4VHNVK3p0aHd4bllncHlnNGNs?=
 =?utf-8?B?V2xYelZ4czNIMC83cEVOV2Fjd3dRd0o3S3hHL2c1SEhNNHFJczRCd3piRkQ5?=
 =?utf-8?B?a0hIeWpqOWxuVWttVEpITktYdFZOb2ptckVaUDBHNGZDdG1aRXNFWENGWHM5?=
 =?utf-8?B?bVg0UDBJSkVFM1VSbXlFN3M4TE14ZjE4RDVzSHVUL2pxcE0zRTJpSk9OT0lI?=
 =?utf-8?B?ZzBLczJiVHJUc3drSVB6VDZ0YUgvcTJjR0hDWE55Y3FXeWc2bElHOWs2S3A4?=
 =?utf-8?B?a05sWEFXS1crNWptMWh2cVBRbW45MWxSMXZnN3lhVU9SZ3pJRU9IWVB4ZXBk?=
 =?utf-8?B?SXRQWFQ3SElRK1ZJbGNYdnJCTVRSSmhaZ1JiNHpBRU5GT0RkNWlpbkJJUUdE?=
 =?utf-8?B?WEVDVXQ4L3NDdmxmSUFZblhacmVlSmp6NjVvUkFlMVNLeWNFYnpUaTNyQzdM?=
 =?utf-8?B?V1pQdjBuVDFmcW1pY0VQc3NtMHRTUXNXSkpnNmc0VGx5M2ljSkhjM1BEV0o3?=
 =?utf-8?B?TTFkdnh2aHlwd2htTnVSSEFWVzBvWjR6b1dVcjJYNmZsQjRLN3RqbzZqcko4?=
 =?utf-8?B?TmZXRytBbkdleWMxL0tNaFkzNFhVTGNzKzk5bVAwZ1JQR2hLNHpDSVBQNGpq?=
 =?utf-8?B?aHlNMHR3NEhNcXVBRXhQZGl3SWZhOG5hMGEyY1FpWE1SUjB3UWhMaXNnMmlB?=
 =?utf-8?B?bHhkVUFmSUUxTkxCcEtCbVlYVmV1Z2VpMENnaWQxay9XR3pWOXQvK3A1SU54?=
 =?utf-8?B?ekZHZkN3cDQwQXVBV0dIaFJpN1dnR0UrZXhCMTRNVVRkVFN5aGg5enZpSXBr?=
 =?utf-8?B?am1qWk1vZFlkQXg0Ny9WSCtRWnhoTWc5VUVUNWJZZS8vZFBEQnB2QjVKK3Zs?=
 =?utf-8?B?ZHBBRWxyYnFIdW4vWDZVQm14STBrem9OKzJGVzJsRkJYZ0ZjMmMzamhYTWtN?=
 =?utf-8?B?eVNqajJxaGtvT0hYSVhMSXdhSlRETWlabHM0bUY4NFFnWXdyd1NlOUowRm1r?=
 =?utf-8?Q?9fXYTD8apn7pSH7ntHz4dFk7pQh77Y=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alhZaE15dllXVGRsQmRnblRGUTMrU2ZVWDFKWmhadzhQU3dhaVM1cjhKZGFY?=
 =?utf-8?B?enhzYjc1ZkpCYUV5ckYvckR0Z3RGR2ZVeEgrNFM0eDQxT2hmenBsL0VCTnc4?=
 =?utf-8?B?M3V0cStLT0tIM3QvaVB6Q0NlWWdSVjIvOEVLdk44KytIK21FRDRZZFMzVHc0?=
 =?utf-8?B?emZCZTlPTDJ1dlBZQTNSZzRrbEowSkpMSzlCcXcyQURuOENvVFJLWFVtRlJB?=
 =?utf-8?B?RnJXbk04c2lrdXF6d0NxTDY0R0ZUcnFpN1NRTXA4Ti9QRlVkSVJSKzA4WXM3?=
 =?utf-8?B?dWM2SWtGcGxIaUkwU3pBOWY4QWJXaC9kRkxISVFtdGlwb0xZcnhZQy9BMEFC?=
 =?utf-8?B?OXdHVlV5OTE4dWhZYjBBMEp6WmlxMTRVOFVYdWkxWnlRWnZZYzBPOVNUcGEv?=
 =?utf-8?B?SUdITkZwVGFtWGVnVlhQSjNWSkZSOUxwUHBZdGUraVo3MVhKVTRiYzBxUjBp?=
 =?utf-8?B?THNGWnFWa1EycWVMcnlVQjQwQkRVR3ZWaTFPNFdtclZDUHUxTC9LNnpoWitM?=
 =?utf-8?B?ZmFvandnV3o2QUZHWkpBbFRJV3V1Rkk0cVVTQkFlYjU5QWY4MmtvUENXNjE5?=
 =?utf-8?B?ZDRrM3Uzb3R5UEErTW40QjlqeStQaCtSL2lQZkJGb0M0K1ZhNThKZWVIMzVr?=
 =?utf-8?B?cnA4UTRhRGRFZ0UyZ1RGcm1uZ3pLRE9RRnZxYURSR2w1TFI1azJBa0JiSFQ3?=
 =?utf-8?B?WThoakE3aDZCUFphNXl3U3g1ZGlKb3NWMlc0VEpFWitWVXZZN2xsMXg3Q2dr?=
 =?utf-8?B?WnhlZzRFNzdXZVV1aTdUeHB4ODVhcHhFSy94MUFja2RsYTJjdm1vdklmVUxm?=
 =?utf-8?B?cGZBUTZISUJyUEVlcUU4aTFCOVdMYktVWUdocDJCUGJGbGx0aElZTW50Zk85?=
 =?utf-8?B?U0VnWHpURy9oZmtmYlZEVk5oaHJqWkorbSswRWVBVTdDYlBxcDhHYzFFd0Ri?=
 =?utf-8?B?ODJFV3QxZzNZZ1VvMHB6aWZXSk8vQkE1YnEvdWFxSXk5N29aUnduUnlKWHZw?=
 =?utf-8?B?TmpIcnVDbkpWbVdVczlzeG5jOUx4cHE4RjI0RDNFLzA0NkFLZTBpNUtzQTNp?=
 =?utf-8?B?MXBTUnJpNGM5c0R5b1M0ZTFBNi96RXFRRGFHTEFDK0NqUEdQR04yaDlMWDRG?=
 =?utf-8?B?UDRpaE02WjErYmJXVEhPUDNFSHVVRE9IdVFPWVg3Q0U5Z3ozcEE4V0RPeVhT?=
 =?utf-8?B?TFRJcGJOc2U0UU9aUThHVlpGWnJrMUFRZjJuT2Z6N1I0cnRYTUIxYTBCZVpa?=
 =?utf-8?B?VTJjQk5uSnp4NE5xbTloNmVoUVg2NzlTbXFwN0wrSW5HZStOVkZnQ0NjRGFu?=
 =?utf-8?B?MjNjZzMxT0xqQm1JOGZOcjJZWFpUSXF0Yzkzek9FWHNKaHk2VmEvWGFiU3ZW?=
 =?utf-8?B?alJVTi95WjlzdjdkcSs3SC96NEdjNzZaTGJZQnFQQm5BOW1UVUliVWkxYThZ?=
 =?utf-8?B?cW1CWXU3UE1PZGlRaDlBbVV2RVd2L1JkNit3Nm1Ib095Um9aNmIrMDNvZlR4?=
 =?utf-8?B?cExSWGhmMmFnUUllQ1NubVM2c1pLR0JjUTF2OVhJNUhxRE1FTWNQUnJqZHVr?=
 =?utf-8?B?L1dMY3ZoM0JLekFKeTFER0ZIbS9XK0RpNnFnZDNKd0RhK0dDZW1OdW82MjJO?=
 =?utf-8?B?UkxCb3lkbzQ1UmdkRkplUEtYVWZXbDQrQUNZcmpBOXVtaUJ2Zm9CYUFqa3k1?=
 =?utf-8?B?ZktiZHhjZXNuZTdLMTYvZTBnZXJ0OTlnYVJ2YmthM2VaRFhnYjlWYmhyRjkx?=
 =?utf-8?B?OEc4U0lSVFpuU0xmemxhU0lnSGE0cVNzdGFVSHdiSjdrK3grVmg0dTN1L0h4?=
 =?utf-8?B?cFFhWE5SajEyd0pGMzN0Smt4RFNiWUZiTDZjckhoOW1NMUdBdnRpOTJXclBV?=
 =?utf-8?B?NHl6RGtOYjlSeXhjL0h2UlVSOGJYY2F6MUhGY210WGhjWmFad3RLSWt4UlBQ?=
 =?utf-8?B?RXN6Zm5qQ0pmREIvZjFSdGhNYUJSdmtVK0NoS01aYTFlcTlBdDgwYS9hQ2Jv?=
 =?utf-8?B?MndFTE1pSWN1YVlHRUp6cm41NHdxa3FuVEZubmtSV2lkVVZnVFdNRmFCZVIz?=
 =?utf-8?B?ZkFJYnA2QkYwNUdxMDU4VmdRc3BtdjVEQU5teTU3MGdJc3hSQThsNS9senFZ?=
 =?utf-8?B?MlErOWNtcDNxZVB2WkhhMDNwdmR4RzhneTI2cWgvZFpBY2hRLzlWRVBZSUFi?=
 =?utf-8?Q?P9bdATAwxHaXhuBUyE99sus=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7AE0C5184731BB45874E0018D9800964@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddae3dbd-74f5-46aa-a8fa-08ddb43909bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 22:38:42.5727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /2bSD+e36DZhniVXFS+SCsM7VK+rts+EAw9GbLbe2M0DJJ/zRVe1bJP1lHVoWsu3NJChyaZ3yp3pEk3rNQ+8HpfW6eFnoKqRiUPM2kZiaRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9448
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTA5IGF0IDIyOjEzICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IFRoZXJlIGFyZSB0d28gZGlzdGluY3QgY2FzZXMgd2hlbiB0aGUga2VybmVsIG5lZWRz
IHRvIGFsbG9jYXRlIFBBTVQNCj4gbWVtb3J5IGluIHRoZSBmYXVsdCBwYXRoOiBmb3IgU0VQVCBw
YWdlIHRhYmxlcyBpbiB0ZHhfc2VwdF9saW5rX3ByaXZhdGVfc3B0KCkNCj4gYW5kIGZvciBsZWFm
IHBhZ2VzIGluIHRkeF9zZXB0X3NldF9wcml2YXRlX3NwdGUoKS4NCj4gDQo+IFRoZXNlIGNvZGUg
cGF0aHMgcnVuIGluIGF0b21pYyBjb250ZXh0LiBVc2UgYSBwcmUtYWxsb2NhdGVkIHBlci1WQ1BV
DQo+IHBvb2wgZm9yIG1lbW9yeSBhbGxvY2F0aW9ucy4NCg0KVGhpcyBsb2cgaXMgd2F5IHRvIHRo
aW4uIEl0IHNob3VsZCBleHBsYWluIHRoZSBkZXNpZ24sIGp1c3RpZnkgdGhlIGZ1bmN0aW9uDQpw
b2ludGVyLCBleGN1c2UgdGhlIGV4cG9ydCwgZXRjLg0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBL
aXJpbGwgQS4gU2h1dGVtb3YgPGtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRlbC5jb20+DQo+IC0t
LQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggIHwgIDQgKysrKw0KPiAgYXJjaC94ODYv
a3ZtL3ZteC90ZHguYyAgICAgIHwgNDAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKyst
LS0tLQ0KPiAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIHwgMjEgKysrKysrKysrKysrKy0t
LS0tLQ0KPiAgdmlydC9rdm0va3ZtX21haW4uYyAgICAgICAgIHwgIDEgKw0KPiAgNCBmaWxlcyBj
aGFuZ2VkLCA1NSBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Rk
eC5oDQo+IGluZGV4IDQ3MDkyZWIxM2ViMy4uMzlmOGRkN2UwZjA2IDEwMDY0NA0KPiAtLS0gYS9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90
ZHguaA0KPiBAQCAtMTE2LDYgKzExNiwxMCBAQCB1MzIgdGR4X2dldF9ucl9ndWVzdF9rZXlpZHMo
dm9pZCk7DQo+ICB2b2lkIHRkeF9ndWVzdF9rZXlpZF9mcmVlKHVuc2lnbmVkIGludCBrZXlpZCk7
DQo+ICANCj4gIGludCB0ZHhfbnJfcGFtdF9wYWdlcyh2b2lkKTsNCj4gK2ludCB0ZHhfcGFtdF9n
ZXQoc3RydWN0IHBhZ2UgKnBhZ2UsIGVudW0gcGdfbGV2ZWwgbGV2ZWwsDQo+ICsJCSBzdHJ1Y3Qg
cGFnZSAqKGFsbG9jKSh2b2lkICpkYXRhKSwgdm9pZCAqZGF0YSk7DQo+ICt2b2lkIHRkeF9wYW10
X3B1dChzdHJ1Y3QgcGFnZSAqcGFnZSwgZW51bSBwZ19sZXZlbCBsZXZlbCk7DQo+ICsNCj4gIHN0
cnVjdCBwYWdlICp0ZHhfYWxsb2NfcGFnZSh2b2lkKTsNCj4gIHZvaWQgdGR4X2ZyZWVfcGFnZShz
dHJ1Y3QgcGFnZSAqcGFnZSk7DQo+ICANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgv
dGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IGluZGV4IDM2YzNjOWY4YTYyYy4uYmM5
YmMzOTNmODY2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ICsrKyBi
L2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gQEAgLTE1MzcsMTEgKzE1MzcsMjYgQEAgc3RhdGlj
IGludCB0ZHhfbWVtX3BhZ2VfcmVjb3JkX3ByZW1hcF9jbnQoc3RydWN0IGt2bSAqa3ZtLCBnZm5f
dCBnZm4sDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBzdHJ1Y3QgcGFnZSAq
dGR4X2FsbG9jX3BhbXRfcGFnZV9hdG9taWModm9pZCAqZGF0YSkNCj4gK3sNCj4gKwlzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUgPSBkYXRhOw0KPiArCXZvaWQgKnA7DQo+ICsNCj4gKwlwID0ga3ZtX21t
dV9tZW1vcnlfY2FjaGVfYWxsb2MoJnZjcHUtPmFyY2gucGFtdF9wYWdlX2NhY2hlKTsNCj4gKwly
ZXR1cm4gdmlydF90b19wYWdlKHApOw0KPiArfQ0KPiArDQo+ICBpbnQgdGR4X3NlcHRfc2V0X3By
aXZhdGVfc3B0ZShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwNCj4gIAkJCSAgICAgIGVudW0g
cGdfbGV2ZWwgbGV2ZWwsIGt2bV9wZm5fdCBwZm4pDQo+ICB7DQo+ICsJc3RydWN0IGt2bV92Y3B1
ICp2Y3B1ID0ga3ZtX2dldF9ydW5uaW5nX3ZjcHUoKTsNCj4gIAlzdHJ1Y3Qga3ZtX3RkeCAqa3Zt
X3RkeCA9IHRvX2t2bV90ZHgoa3ZtKTsNCj4gIAlzdHJ1Y3QgcGFnZSAqcGFnZSA9IHBmbl90b19w
YWdlKHBmbik7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCXJldCA9IHRkeF9wYW10X2dldChwYWdl
LCBsZXZlbCwgdGR4X2FsbG9jX3BhbXRfcGFnZV9hdG9taWMsIHZjcHUpOw0KPiArCWlmIChyZXQp
DQo+ICsJCXJldHVybiByZXQ7DQo+ICANCj4gIAkvKiBUT0RPOiBoYW5kbGUgbGFyZ2UgcGFnZXMu
ICovDQo+ICAJaWYgKEtWTV9CVUdfT04obGV2ZWwgIT0gUEdfTEVWRUxfNEssIGt2bSkpDQoNCmxl
dmVsIGlzIGtub3duIHRvIGJlIFBHX0xFVkVMXzRLIGlmIHlvdSBzd2FwIHRoZSBvcmRlciBvZiB0
aGVzZS4gSSdtIGd1ZXNzaW5nDQpsZWZ0IG92ZXIgZnJvbSBvcmRlciBzd2FwLg0KDQo+IEBAIC0x
NTYyLDEwICsxNTc3LDE2IEBAIGludCB0ZHhfc2VwdF9zZXRfcHJpdmF0ZV9zcHRlKHN0cnVjdCBr
dm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAgCSAqIGJhcnJpZXIgaW4gdGR4X3RkX2ZpbmFsaXplKCku
DQo+ICAJICovDQo+ICAJc21wX3JtYigpOw0KPiAtCWlmIChsaWtlbHkoa3ZtX3RkeC0+c3RhdGUg
PT0gVERfU1RBVEVfUlVOTkFCTEUpKQ0KPiAtCQlyZXR1cm4gdGR4X21lbV9wYWdlX2F1Zyhrdm0s
IGdmbiwgbGV2ZWwsIHBhZ2UpOw0KPiAgDQo+IC0JcmV0dXJuIHRkeF9tZW1fcGFnZV9yZWNvcmRf
cHJlbWFwX2NudChrdm0sIGdmbiwgbGV2ZWwsIHBmbik7DQo+ICsJaWYgKGxpa2VseShrdm1fdGR4
LT5zdGF0ZSA9PSBURF9TVEFURV9SVU5OQUJMRSkpDQo+ICsJCXJldCA9IHRkeF9tZW1fcGFnZV9h
dWcoa3ZtLCBnZm4sIGxldmVsLCBwYWdlKTsNCj4gKwllbHNlDQo+ICsJCXJldCA9IHRkeF9tZW1f
cGFnZV9yZWNvcmRfcHJlbWFwX2NudChrdm0sIGdmbiwgbGV2ZWwsIHBmbik7DQoNCnRkeF9tZW1f
cGFnZV9yZWNvcmRfcHJlbWFwX2NudCgpIGRvZXNuJ3QgbmVlZCB0ZHhfcGFtdF9nZXQoKS4gSSB0
aGluayBpdCBjb3VsZA0KYmUgc2tpcHBlZCBpZiB0aGUgb3JkZXIgaXMgcmUtYXJyYW5nZWQuDQoN
Cj4gKw0KPiArCWlmIChyZXQpDQo+ICsJCXRkeF9wYW10X3B1dChwYWdlLCBsZXZlbCk7DQo+ICsN
Cj4gKwlyZXR1cm4gcmV0Ow0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgaW50IHRkeF9zZXB0X2Ryb3Bf
cHJpdmF0ZV9zcHRlKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiBAQCAtMTYyMiwxNyAr
MTY0MywyNiBAQCBpbnQgdGR4X3NlcHRfbGlua19wcml2YXRlX3NwdChzdHJ1Y3Qga3ZtICprdm0s
IGdmbl90IGdmbiwNCj4gIAkJCSAgICAgIGVudW0gcGdfbGV2ZWwgbGV2ZWwsIHZvaWQgKnByaXZh
dGVfc3B0KQ0KPiAgew0KPiAgCWludCB0ZHhfbGV2ZWwgPSBwZ19sZXZlbF90b190ZHhfc2VwdF9s
ZXZlbChsZXZlbCk7DQo+IC0JZ3BhX3QgZ3BhID0gZ2ZuX3RvX2dwYShnZm4pOw0KPiArCXN0cnVj
dCBrdm1fdmNwdSAqdmNwdSA9IGt2bV9nZXRfcnVubmluZ192Y3B1KCk7DQo+ICAJc3RydWN0IHBh
Z2UgKnBhZ2UgPSB2aXJ0X3RvX3BhZ2UocHJpdmF0ZV9zcHQpOw0KPiArCWdwYV90IGdwYSA9IGdm
bl90b19ncGEoZ2ZuKTsNCj4gIAl1NjQgZXJyLCBlbnRyeSwgbGV2ZWxfc3RhdGU7DQo+ICsJaW50
IHJldDsNCj4gKw0KPiArCXJldCA9IHRkeF9wYW10X2dldChwYWdlLCBQR19MRVZFTF80SywgdGR4
X2FsbG9jX3BhbXRfcGFnZV9hdG9taWMsIHZjcHUpOw0KPiArCWlmIChyZXQpDQo+ICsJCXJldHVy
biByZXQ7DQo+ICANCj4gIAllcnIgPSB0ZGhfbWVtX3NlcHRfYWRkKCZ0b19rdm1fdGR4KGt2bSkt
PnRkLCBncGEsIHRkeF9sZXZlbCwgcGFnZSwgJmVudHJ5LA0KPiAgCQkJICAgICAgICZsZXZlbF9z
dGF0ZSk7DQo+IC0JaWYgKHVubGlrZWx5KHRkeF9vcGVyYW5kX2J1c3koZXJyKSkpDQo+ICsJaWYg
KHVubGlrZWx5KHRkeF9vcGVyYW5kX2J1c3koZXJyKSkpIHsNCj4gKwkJdGR4X3BhbXRfcHV0KHBh
Z2UsIFBHX0xFVkVMXzRLKTsNCj4gIAkJcmV0dXJuIC1FQlVTWTsNCj4gKwl9DQo+ICANCj4gIAlp
ZiAoS1ZNX0JVR19PTihlcnIsIGt2bSkpIHsNCj4gIAkJcHJfdGR4X2Vycm9yXzIoVERIX01FTV9T
RVBUX0FERCwgZXJyLCBlbnRyeSwgbGV2ZWxfc3RhdGUpOw0KPiArCQl0ZHhfcGFtdF9wdXQocGFn
ZSwgUEdfTEVWRUxfNEspOw0KPiAgCQlyZXR1cm4gLUVJTzsNCj4gIAl9DQo+ICANCj4gZGlmZiAt
LWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHguYw0KPiBpbmRleCA0ZjllYWJhNGFmNGEuLmQ0YjUwYjY0MjhmYSAxMDA2NDQNCj4gLS0t
IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYw0KPiBAQCAtMjA2NywxMCArMjA2NywxNiBAQCBzdGF0aWMgdm9pZCB0ZHhfZnJl
ZV9wYW10X3BhZ2VzKHN0cnVjdCBsaXN0X2hlYWQgKnBhbXRfcGFnZXMpDQo+ICAJfQ0KPiAgfQ0K
PiAgDQo+IC1zdGF0aWMgaW50IHRkeF9hbGxvY19wYW10X3BhZ2VzKHN0cnVjdCBsaXN0X2hlYWQg
KnBhbXRfcGFnZXMpDQo+ICtzdGF0aWMgaW50IHRkeF9hbGxvY19wYW10X3BhZ2VzKHN0cnVjdCBs
aXN0X2hlYWQgKnBhbXRfcGFnZXMsDQo+ICsJCQkJIHN0cnVjdCBwYWdlICooYWxsb2MpKHZvaWQg
KmRhdGEpLCB2b2lkICpkYXRhKQ0KPiAgew0KPiAgCWZvciAoaW50IGkgPSAwOyBpIDwgdGR4X25y
X3BhbXRfcGFnZXMoKTsgaSsrKSB7DQo+IC0JCXN0cnVjdCBwYWdlICpwYWdlID0gYWxsb2NfcGFn
ZShHRlBfS0VSTkVMKTsNCj4gKwkJc3RydWN0IHBhZ2UgKnBhZ2U7DQo+ICsNCj4gKwkJaWYgKGFs
bG9jKQ0KPiArCQkJcGFnZSA9IGFsbG9jKGRhdGEpOw0KPiArCQllbHNlDQo+ICsJCQlwYWdlID0g
YWxsb2NfcGFnZShHRlBfS0VSTkVMKTsNCg0KSXQncyBub3QgZ3JlYXQgSSB0aGluay4gQSBicmFu
Y2ggYmV0d2VlbiBhIGZ1bmN0aW9uIHBvaW50ZXIgYW5kIGFsbG9jX3BhZ2UsDQp3aGVyZSB0aGVy
ZSBpcyBvbmx5IGV2ZXIgb25lIHZhbHVlIGZvciB0aGUgZnVuY3Rpb24gcG9pbnRlci4gVGhlcmUg
aGFzIHRvIGJlIGENCmJldHRlciB3YXk/DQoNCj4gIAkJaWYgKCFwYWdlKQ0KPiAgCQkJZ290byBm
YWlsOw0KPiAgCQlsaXN0X2FkZCgmcGFnZS0+bHJ1LCBwYW10X3BhZ2VzKTsNCj4gQEAgLTIxMTUs
NyArMjEyMSw4IEBAIHN0YXRpYyBpbnQgdGR4X3BhbXRfYWRkKGF0b21pY190ICpwYW10X3JlZmNv
dW50LCB1bnNpZ25lZCBsb25nIGhwYSwNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0KPiAtc3Rh
dGljIGludCB0ZHhfcGFtdF9nZXQoc3RydWN0IHBhZ2UgKnBhZ2UsIGVudW0gcGdfbGV2ZWwgbGV2
ZWwpDQo+ICtpbnQgdGR4X3BhbXRfZ2V0KHN0cnVjdCBwYWdlICpwYWdlLCBlbnVtIHBnX2xldmVs
IGxldmVsLA0KPiArCQkgc3RydWN0IHBhZ2UgKihhbGxvYykodm9pZCAqZGF0YSksIHZvaWQgKmRh
dGEpDQo+ICB7DQo+ICAJdW5zaWduZWQgbG9uZyBocGEgPSBwYWdlX3RvX3BoeXMocGFnZSk7DQo+
ICAJYXRvbWljX3QgKnBhbXRfcmVmY291bnQ7DQo+IEBAIC0yMTM0LDcgKzIxNDEsNyBAQCBzdGF0
aWMgaW50IHRkeF9wYW10X2dldChzdHJ1Y3QgcGFnZSAqcGFnZSwgZW51bSBwZ19sZXZlbCBsZXZl
bCkNCj4gIAlpZiAoYXRvbWljX2luY19ub3RfemVybyhwYW10X3JlZmNvdW50KSkNCj4gIAkJcmV0
dXJuIDA7DQo+ICANCj4gLQlpZiAodGR4X2FsbG9jX3BhbXRfcGFnZXMoJnBhbXRfcGFnZXMpKQ0K
PiArCWlmICh0ZHhfYWxsb2NfcGFtdF9wYWdlcygmcGFtdF9wYWdlcywgYWxsb2MsIGRhdGEpKQ0K
PiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gIA0KPiAgCXJldCA9IHRkeF9wYW10X2FkZChwYW10X3Jl
ZmNvdW50LCBocGEsICZwYW10X3BhZ2VzKTsNCj4gQEAgLTIxNDMsOCArMjE1MCw5IEBAIHN0YXRp
YyBpbnQgdGR4X3BhbXRfZ2V0KHN0cnVjdCBwYWdlICpwYWdlLCBlbnVtIHBnX2xldmVsIGxldmVs
KQ0KPiAgDQo+ICAJcmV0dXJuIHJldCA+PSAwID8gMCA6IHJldDsNCj4gIH0NCj4gK0VYUE9SVF9T
WU1CT0xfR1BMKHRkeF9wYW10X2dldCk7DQo+ICANCj4gLXN0YXRpYyB2b2lkIHRkeF9wYW10X3B1
dChzdHJ1Y3QgcGFnZSAqcGFnZSwgZW51bSBwZ19sZXZlbCBsZXZlbCkNCj4gK3ZvaWQgdGR4X3Bh
bXRfcHV0KHN0cnVjdCBwYWdlICpwYWdlLCBlbnVtIHBnX2xldmVsIGxldmVsKQ0KPiAgew0KPiAg
CXVuc2lnbmVkIGxvbmcgaHBhID0gcGFnZV90b19waHlzKHBhZ2UpOw0KPiAgCWF0b21pY190ICpw
YW10X3JlZmNvdW50Ow0KPiBAQCAtMjE3OSw2ICsyMTg3LDcgQEAgc3RhdGljIHZvaWQgdGR4X3Bh
bXRfcHV0KHN0cnVjdCBwYWdlICpwYWdlLCBlbnVtIHBnX2xldmVsIGxldmVsKQ0KPiAgDQo+ICAJ
dGR4X2ZyZWVfcGFtdF9wYWdlcygmcGFtdF9wYWdlcyk7DQo+ICB9DQo+ICtFWFBPUlRfU1lNQk9M
X0dQTCh0ZHhfcGFtdF9wdXQpOw0KPiAgDQo+ICBzdHJ1Y3QgcGFnZSAqdGR4X2FsbG9jX3BhZ2Uo
dm9pZCkNCj4gIHsNCj4gQEAgLTIxODgsNyArMjE5Nyw3IEBAIHN0cnVjdCBwYWdlICp0ZHhfYWxs
b2NfcGFnZSh2b2lkKQ0KPiAgCWlmICghcGFnZSkNCj4gIAkJcmV0dXJuIE5VTEw7DQo+ICANCj4g
LQlpZiAodGR4X3BhbXRfZ2V0KHBhZ2UsIFBHX0xFVkVMXzRLKSkgew0KPiArCWlmICh0ZHhfcGFt
dF9nZXQocGFnZSwgUEdfTEVWRUxfNEssIE5VTEwsIE5VTEwpKSB7DQo+ICAJCV9fZnJlZV9wYWdl
KHBhZ2UpOw0KPiAgCQlyZXR1cm4gTlVMTDsNCj4gIAl9DQo+IGRpZmYgLS1naXQgYS92aXJ0L2t2
bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4uYw0KPiBpbmRleCBlZWM4Mjc3NWM1YmYu
LjZhZGQwMTI1MzJhMCAxMDA2NDQNCj4gLS0tIGEvdmlydC9rdm0va3ZtX21haW4uYw0KPiArKysg
Yi92aXJ0L2t2bS9rdm1fbWFpbi5jDQo+IEBAIC00MzYsNiArNDM2LDcgQEAgdm9pZCAqa3ZtX21t
dV9tZW1vcnlfY2FjaGVfYWxsb2Moc3RydWN0IGt2bV9tbXVfbWVtb3J5X2NhY2hlICptYykNCj4g
IAlCVUdfT04oIXApOw0KPiAgCXJldHVybiBwOw0KPiAgfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwo
a3ZtX21tdV9tZW1vcnlfY2FjaGVfYWxsb2MpOw0KDQpEaWQgeW91IGNvbnNpZGVyIHByZS1hbGxv
Y2F0aW5nIGEgcGFnZSBhbmQgcmV0dXJuaW5nIGl0IHRvIHRoZSBjYWNoZSBpZiBpdCdzIG5vdA0K
bmVlZGVkLiBPciBtb3Zpbmcga3ZtX21tdV9tZW1vcnlfY2FjaGVfYWxsb2MoKSB0byBhIHN0YXRp
YyBpbmxpbmUgaW4gYSBoZWFkZXINCnRoYXQgY29yZSB4ODYgY2FuIHVzZS4NCg0KVGhleSBhbGwg
c2VlbSBiYWQgaW4gZGlmZmVyZW50IHdheXMuDQoNCj4gICNlbmRpZg0KPiAgDQo+ICBzdGF0aWMg
dm9pZCBrdm1fdmNwdV9pbml0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bSAqa3Zt
LCB1bnNpZ25lZCBpZCkNCg0K

