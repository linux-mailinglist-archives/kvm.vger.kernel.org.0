Return-Path: <kvm+bounces-53264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84A44B0F717
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:32:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AAF7580EF3
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5649E1F3B8A;
	Wed, 23 Jul 2025 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O5JBflhG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64461E8324;
	Wed, 23 Jul 2025 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753284767; cv=fail; b=KwBtux6agh3tuuMGeoulmDh5KX+nT1vT2r1VKYI+wTTOUt84kLn7BQphE7FUropoY9X1q9KBZtmhq86nxNu6Wq04wRhQluAWiHTCMXf7FFSO071/KR9+z7APm7hc9WTSXTfYrGNgkRv9Vt8h0L5tpq7cqkHB9hDuNJgtQC15YvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753284767; c=relaxed/simple;
	bh=f5WIwAveHcawyTdFarub1CLp1Rj2/M5fcv9zRjrL/ds=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kuMtdbFWmLGbsqzCMmRNKG5vaq4CYm1aBbntliRjv24P/g2ssIC+makL+6sIaBeg+NBY7gXrUdVOsoVgydhZkMMv9TEumeeVY/wYBifRoCwOamvsVtc6UPM7kyE/ga2RXoKotakXezjRSG1YVRJv/6q76TQ2bcJwczANsAc1wcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O5JBflhG; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753284766; x=1784820766;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f5WIwAveHcawyTdFarub1CLp1Rj2/M5fcv9zRjrL/ds=;
  b=O5JBflhGnqFDIIPyfAaNf2NTZmqcttadJAqOkiIVaxhohsMIyCt/T2Dr
   pRKcD0SfBQux9Lf51DZZN+O2peLoFXDRsTeq2q6TSFTZoY22uTKhPOuF1
   OoXKt5vZ1pJYLTVpXd5TbSWFjliVcUHRGaciYsaMEa3BpW1ZSH8tbArRI
   LfE+iehXoY5YwyGM9slmgiVEL19AEuCEh/6TYzTpKro5JtaaEhrHLC+Ju
   JkgVIzMjrWe8uU4qRycZVh6U+I56jAlFGsEqYK3Y1l+93VDOi57+Do7eI
   Vi6WiazpI2oI8QDOcBt3+0WF6unDOb9QoSNmw3RusPR1Hsbdvl+h8b3rm
   g==;
X-CSE-ConnectionGUID: cM7RmzxNSv6v7YrXG6Q6PA==
X-CSE-MsgGUID: yD3BCUxDQl2mpi8NKHivgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55681637"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55681637"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 08:32:46 -0700
X-CSE-ConnectionGUID: O0bGwsUbSGWRYMILvQ31DQ==
X-CSE-MsgGUID: NWf6Xs55So2spoccov69Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="165052262"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 08:32:45 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 08:32:41 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 08:32:41 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.68)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 08:31:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v2ORlO71YJoplycM8UxSXBfOta1kcuYfgo98vvEXB7AeCOBQB5w0crOHYj+8O1L9Rz/fQux+bPsxd+AsXQbWatdKvydb0denYiPAnjwL4cjd5vmuS/Mlfb76gkh+vDEtGgZnF09hLlByOt177Pm2igELPt0lW3WvtITyoH+OYvMxCKouLTPs6o3zTgqlkhKO8RKl3rYmVElnnJEZohpXl299GXBUlfP6VxBHfFDRQNuQe/EllzqAcdrpNsSl/9suJ349Hm4Yn9ztV10Qo73DODqwxksAr6olh3Wc7nlFaaUM9tJLvYYeVcMBE9Xh9kNd2a06LwEbiG4rsZWE4cKj2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSy5pBGt9aYSpJii7bE5Jwr3Nz0tOgTFNJRBr5Ld3q0=;
 b=k9gAjOET5jC8spgwKerTlQElhW/TghQoGVNbH7xvEJeDv6gdzEhQN2T9wcYr/hOm+TnDtHqbXdAp2i91kt5m8TO6dBHe/fTX4VxODBdQbOeUERZ5MlZu8k8SUUMxrgLnqh2JNq1SjlmOt4skcwfkLNLNrq74WQu/f3ZIaY04T1jGHEdGTx7tgn1nHwFGQLKdfnESWafKy2B2mMaj/lElPzGIjo36XsyUX6TyFGEx6SyM6DO2bRtJKW+3odxuXrABq6/0Q+z/5bHHR8kHkN95hAiZ2DjeOuEAKnzlGINrdF63M2dWIXE9BypI9+yMyzFM+p8gSs0VfW6mM3Q2v/ORlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by DM4PR11MB7400.namprd11.prod.outlook.com (2603:10b6:8:100::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 15:30:50 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.8922.037; Wed, 23 Jul 2025
 15:30:49 +0000
Message-ID: <7e54649c-7eb2-444f-849b-7ced20a5bb05@intel.com>
Date: Wed, 23 Jul 2025 18:30:43 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "Gao,
 Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
References: <20250723120539.122752-1-adrian.hunter@intel.com>
 <20250723120539.122752-2-adrian.hunter@intel.com>
 <f7f99ab69867a547e3d7ef4f73a9307c3874ad6f.camel@intel.com>
 <ee2f8d16-be3c-403e-8b9c-e5bec6d010ce@intel.com>
 <4b7190de91c59a5d5b3fdbb39174e4e48c69f9e7.camel@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <4b7190de91c59a5d5b3fdbb39174e4e48c69f9e7.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB8PR04CA0015.eurprd04.prod.outlook.com
 (2603:10a6:10:110::25) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|DM4PR11MB7400:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b1a7840-59bd-43f4-b799-08ddc9fde6a5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RDJUYi9WQk9nMjRvMlp4aVhxVTNieCt0eHFtcmU2ZHVFelJTc2pEakcybktE?=
 =?utf-8?B?ZzJPTFdZdVI3aG53K0ZtY2lsa1ZKYVduaXNSYkhXTmp3KzV4NkFESG41WHJF?=
 =?utf-8?B?cE4wZnZmVTRUdWhwK2dZS2JuQUxldjJ3ZFFXTGZBVEE3RHNVK3pmVnZLdzlL?=
 =?utf-8?B?YU9GUkp2cEUxN0RxZEhXTW82WUN4Mmh0MXdjS0tOZFFtMVZOUEE4enRvZW5R?=
 =?utf-8?B?RjM3TDlpRHBHQzdoYkY5M2lrU3hIbDlhbVBYOVMwSDZ3VDVrT1FjcU9zYXUz?=
 =?utf-8?B?ZEN2cmNodlpvQTNnNC94TXZtSGZOQ3BFeW1oN25ZbVF5RWc0S3NxOHZCYk5K?=
 =?utf-8?B?ekdCdHM1TTNsaEZOb2c2QWRpQlhsUDlSRjRaTHN3QTVTZXhkbVhtbVFkY29F?=
 =?utf-8?B?Q2UzKytlY010K29KZDdUN0ZSbURkeDlUSFhGdnIzamtxUzRVdkdENVRQWCs2?=
 =?utf-8?B?WWVTdzZwZU1Ga0hDZk81a1NrbE1ibEdZNXlHT3FLajQ5K3JwdVppYkV3SUlM?=
 =?utf-8?B?UitycG9KbHEzOFRRMkRDeTVYWFY4cndOVXNZTlhQY2xUNzZzUzRVRWp0Ryt4?=
 =?utf-8?B?d3MxVFNOOEJ6WmJCWkN0WEU4L29NWERQN0RUWlRoTVpiYVZMRUl0VnZnQTg3?=
 =?utf-8?B?S0FqZktvRHFBQldtQ1R0djZGd3dvR09kazZEbEh5WThic1JuUjkyc0pBQVN1?=
 =?utf-8?B?SUpiMy8wL0E2UG8wQnA5Tjg5QU1NdWNZdW9iYXNJdWlMZlBDMkxCK3hKNnVW?=
 =?utf-8?B?bXIyQnpjdHlLVStxUks2RUZCamZ3bllkMUpRYVNQTGV6Rnk0eTlrWHhuR2tR?=
 =?utf-8?B?VkEzaFNQeXVCMHpUNTQ3OUphUlBZaW0xVURCVTBvWVRxZTNMdGtXL0ViMHF2?=
 =?utf-8?B?VTdTYi9SWlhzNGtFT1VYV2RkdUxRV0ltSzBFM3IyNjAzczd4NGJialRyUHE3?=
 =?utf-8?B?Nk51Yi9NdlZISDVaU3I0QXVqMFBRdmNhZTM4cVVObXRSTy90OUY4Q3E0c0xr?=
 =?utf-8?B?S3NrK1MxaWg4SnowTnJDWWlTZHpwNDhQeU9wK25TdFlVUENLR3RUMDJSUU55?=
 =?utf-8?B?UVJwSUVyTHBxY0dQYjhCdVZFb3MyVDZCa3RFYitiOFAwVXdWYWVsS2N4ZWs0?=
 =?utf-8?B?K3FZNlpHMTI2aS9sZGQ5YVY3eG52VzFpV29VUmI1VlNBQmZjbHdJbC85bmY1?=
 =?utf-8?B?OERYYlJWMTBjMlpEV3VwTmlrV2g5U0c0TGZPbVRHbmVmNHEzUmlVeXRaTFlZ?=
 =?utf-8?B?M1JSWW5IZlEwZVRGaWZvTHljd1YxRmluN2Z4MmIxYWwxQ2dEWllERlJnYUJF?=
 =?utf-8?B?TmI5eG43L1pUS0RhNjFMNkZCL29oaks4UWxnWXdSejlZSzU1NWYrTlBySnhm?=
 =?utf-8?B?Y2djcDJQc1hjcDBKSnRxeHJNZXZJMTBLbTBYelNuS2I2QVVISmY3dzhFMWxl?=
 =?utf-8?B?WmpNdnA4MlFYbC9zWWhJNUJOT0dWUlNqOHdjMVJuS0F0TmdOMGRmaGxSbDlm?=
 =?utf-8?B?Y0k5NTFUcUxwblhiejk5bFdhWEtydWhQSmlUWWJkNzVRbVhZdWdQMVZvbVp1?=
 =?utf-8?B?Q3ZJa2tXYnl0K3pNQ1JtOXBYVDZRbTV2VVFhbkZVSFozc0VPQnhvQ2h0bnJn?=
 =?utf-8?B?WkxaeThvMC9FYUQrYnZFOFdJUWovazBhZlFZVmRpOEl2U2RCNG5XZmxrMkVa?=
 =?utf-8?B?NTdhZjllQXlINTU1Tms1c0xUMlF2anZTdWxvdDVKcEY1d29KY1NYZmtSYitM?=
 =?utf-8?B?UGdpVjh4MUpNOTl3M1VTRi9hVDBSNXZ0bHFXNFdLWGNuTUFaZ1B3a3RPbm8y?=
 =?utf-8?B?NzRHalA0aitaeXQwV3JjeWlOYzFLaCtKb0NhZVIvNVU5cW42OFJsREd1aERh?=
 =?utf-8?B?Qm1zK2hkYWk5Vm0weWdZN2FxN0tYVTJpTnhBczMxaHczRmc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHFVRkdWRTg0Ykphbmd6S05VZmw3Vmt3c1hOb1ZjU0doRWFKWW5vblcraFVY?=
 =?utf-8?B?cVZxKzRYak5salhxYVl6am5zRUdxSnZQdTk2SkU4NzRkaHlhZ1pCSUFyM1hC?=
 =?utf-8?B?UjFpOTlodWxaQkdnUmNJRVdyd2dVMFBTcW94VGxlMGQ1MFlaaDdIaFdMbmtJ?=
 =?utf-8?B?WmVRV2FDMUpTc0I2VWVLeUQxK2JONVVlb3BVZXNRQnFKWUdnSTZpNXlmWUMx?=
 =?utf-8?B?ZVIraW1jUzZYSmptTXAwcUxON2oyR1JkZEpMaG9mMjlwc0h6c0ZXQ0ZRV0lZ?=
 =?utf-8?B?NDF1TlBOVDNuUnJuYlBhakNoejBHeEFMYVJRdDRDckdTdVRiSXlRSEpWdzcr?=
 =?utf-8?B?MmNXb0xFVUhySFZHWmhuK1pHYTlXeGdLYWxxT2Nyd29uSWZMNXFvZ3duWktF?=
 =?utf-8?B?NmZGVzVCdUJCQ3gwUm1EeU5uOHRuUy80SGx2T2ZReXZCMm1TZHA3K1lCbWpT?=
 =?utf-8?B?bHI0QlY2amNxamhXN1FuV1hydXgwUTRrOGhXam0yVGhCN3pLUWc1QTZnMGVH?=
 =?utf-8?B?eUtNYVZvRHAvTkREb1VNQis0SnQ0Y050TklCUEVsb2pCbFFsdWJvNFlXczY0?=
 =?utf-8?B?a0pRYU5UMWxlYWtUNUxMeHIxcEVoRUsyQ0VEdWRlYjBUeVpBZVlCT0RKdlha?=
 =?utf-8?B?cnVITDVteUdtSmtTM2N2Q1hlMWYvQ0lMbnY4MVVaSWc2cXZiNDJUTDVCSmFs?=
 =?utf-8?B?Vy83UXlFZW1zT2swTGF2WjFLL3ErbHMwZm9YVllKTjBMakNPcEhVTXNUa1Ns?=
 =?utf-8?B?VHBrcmtPWnpFemtJSkFDL3ArSSttUUdhdzF6c2oxVUdYRkJiZXU2UWxGTkIw?=
 =?utf-8?B?ZzJPcUJ5VmRENnRqSHdIYUJiYzVIbDBnUldXWDNaQXFKc0RCOEd4R3NKN1ZB?=
 =?utf-8?B?TFFBRDZNczRiZ3J6MC9xd01zUUptcUY2UlptVGlDTU82TVRPTzRvWkVrVWd6?=
 =?utf-8?B?U3lQZ0o5SW9NcGJlQWxHK2tRdld2S0tzRzFCYlpudGdiUnQzbDRoQmZaZ05x?=
 =?utf-8?B?RHVVZGFYTm9HTUVUMFdmcHFFeEFHcFJlRURjOGhWdTBmM1d5RHdnaUlsTG5P?=
 =?utf-8?B?MHJyTzVFVUIvOTl2UmhrZWxQOVlVcEpKNmJpbWI1cVkzUmoraUNFMUcwWE4x?=
 =?utf-8?B?RU5aVUFOa3ZhR3dXN3dOcG51UURteXExSi9JbnJndDNPc2VkZXVmKzJoY1NG?=
 =?utf-8?B?NFZRZXgrZWdua0F4bTJFVHJLRG11bDZ3Uy90MSsvQitNa3FPSTNCdHpSQTRp?=
 =?utf-8?B?aTBSa2xWSEVic010T2lqa2pjck10SlRqclZBOWdWQVIwNXp1bmsvUmwrVG1r?=
 =?utf-8?B?N1A0NVhidDVQMUJFWVI2UE4xZ1RBdDlobkJwUG5hTEkxbnVtb013YkJJb1hu?=
 =?utf-8?B?VXRCbDJxSThMbXhwbUp1bzUxdlRwek8rS2NDWDlkMDVyYmpNekU3eEw4QXl4?=
 =?utf-8?B?YTNoTWVMOXlpbU80L0NoRDI2eVJBUklrYXRvWXRwZUpINlVqT003RFlTdjlO?=
 =?utf-8?B?UTB2R0wvNTlqVnN1STlvUEw0aGM5SW1Hd3cvaytCNkVKQUFNdUtUbmx3Si9W?=
 =?utf-8?B?aVF4V0ZHY21LSVhGNUZWYW5YM0xIakF3QkFGbno5bjFJQjNISjBkQklDVVN1?=
 =?utf-8?B?ZG1OWFdWWDRwejRUWlV2SHgwb2pOQUhDTlJrSk5FVkRPemdaUDVlNUdBOWFW?=
 =?utf-8?B?RFF2VVE2em5mU29vN3NMcGU4TXAxeWVQZytWanVBMzlLdHRuMUpOTUF1UmhS?=
 =?utf-8?B?ekZZZlRLblFHUnpSQXIvaVFvSE0wRG8zSHQ2WHBKR0hUeU9ydTJHbEdjSElo?=
 =?utf-8?B?R0kvVUYrdGk2UVhML3JWYVUrMG1kWGROd1pNVVZFazBXblBMNkcxNDJ2U0R4?=
 =?utf-8?B?d0s5THBKZDdnc3doSHROdENYbFFFVWljRnJrS2w3RzR5eStqYWU2UFlRSlZo?=
 =?utf-8?B?WjRyZnJiTjloMWZhdGJFWk4yRjk1MkRrSTcrWVpUSTdpdi8yRGF0SVBheE9a?=
 =?utf-8?B?bHNaTGxLekM0aHpZM2JvbWIvZ0NtRzFnbG9tVTVnenJZQ3BNZFQ1Q2JxSWtX?=
 =?utf-8?B?YkNKUXZ1UXNnUG92TzBMajQ2YTAvTmdDTjl5NHNYNFZHTGJqZmprZ1crTUdt?=
 =?utf-8?B?MTk4R0lKM09BWGoyMWVFb0ZIVm01RUg4cUZvZThjQmNxMEVodXgrdDV3cU54?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b1a7840-59bd-43f4-b799-08ddc9fde6a5
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 15:30:49.3792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cr1UVABPCdvHU/ltOAulEBXM9cSMNdt9XaYA2dd1n/NIoOfX3vDVK/g77fOrYWv2PF7GDbi/o/G35cwgCntdLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7400
X-OriginatorOrg: intel.com

On 23/07/2025 17:44, Edgecombe, Rick P wrote:
> On Wed, 2025-07-23 at 17:37 +0300, Adrian Hunter wrote:
>>> The latter seems better to me for the sake of less churn.
>>
>> Why make tdx_quirk_reset_page() and tdx_quirk_reset_paddr() follow
>> different rules.
>>
>> How about this:
>>
>> From: Adrian Hunter <adrian.hunter@intel.com>
>> Subject: [PATCH] x86/tdx: Tidy reset_pamt functions
>>
>> Rename reset_pamt functions to contain "quirk" to reflect the new
>> functionality, and remove the now misleading comment.
> 
> This looks like the "former" option. Churn is not too bad, and it has the
> benefit of clear code vs long comment. I'm ok either way. But it needs to go
> cleanup first in the patch order.
> 
> The log should explain why it's ok to change now, with respect to the reasoning
> in the comment that is being removed.

It makes more sense afterwards because then it can refer to the
functional change:

From: Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] x86/tdx: Tidy reset_pamt functions

tdx_quirk_reset_paddr() has been made to reflect that, in fact, the
clearing is necessary only for hardware with a certain quirk.  Refer
patch "x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE
is present" for details.

Rename reset_pamt functions to contain "quirk" to reflect the new
functionality, and remove the now misleading comment.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ef22fc2b9af0..823850399bb7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -664,17 +664,17 @@ void tdx_quirk_reset_page(struct page *page)
 }
 EXPORT_SYMBOL_GPL(tdx_quirk_reset_page);
 
-static void tdmr_reset_pamt(struct tdmr_info *tdmr)
+static void tdmr_quirk_reset_pamt(struct tdmr_info *tdmr)
 {
 	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
 }
 
-static void tdmrs_reset_pamt_all(struct tdmr_info_list *tdmr_list)
+static void tdmrs_quirk_reset_pamt_all(struct tdmr_info_list *tdmr_list)
 {
 	int i;
 
 	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++)
-		tdmr_reset_pamt(tdmr_entry(tdmr_list, i));
+		tdmr_quirk_reset_pamt(tdmr_entry(tdmr_list, i));
 }
 
 static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
@@ -1146,15 +1146,7 @@ static int init_tdx_module(void)
 	 * to the kernel.
 	 */
 	wbinvd_on_all_cpus();
-	/*
-	 * According to the TDX hardware spec, if the platform
-	 * doesn't have the "partial write machine check"
-	 * erratum, any kernel read/write will never cause #MC
-	 * in kernel space, thus it's OK to not convert PAMTs
-	 * back to normal.  But do the conversion anyway here
-	 * as suggested by the TDX spec.
-	 */
-	tdmrs_reset_pamt_all(&tdx_tdmr_list);
+	tdmrs_quirk_reset_pamt_all(&tdx_tdmr_list);
 err_free_pamts:
 	tdmrs_free_pamt_all(&tdx_tdmr_list);
 err_free_tdmrs:
-- 
2.48.1


