Return-Path: <kvm+bounces-39581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3E4BA48110
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:27:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C08E189EBCD
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AD77230988;
	Thu, 27 Feb 2025 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jndorv2x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D509444;
	Thu, 27 Feb 2025 14:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740665870; cv=fail; b=GlNHqZVJ3X8ByDKbCB7JSUSE7bV0zPa0azcVVb4R5TKOxZkoAdB5L+pt7OpJ0kzeeKYTorarQl2BEASvR+lqi9S63jqJTrirVjRg6uJ9HYu+ohZ0808EWDNcP4MzdMOVGKn0uuOzs/mo7j3qZ2mr/4s7BxbNRt+uQJPXeP0pjlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740665870; c=relaxed/simple;
	bh=bLFiweyRsppE6neNh0AtxKCgD58kxybynAyJxAzAfEg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qmvypfFfFlGAyn0Hl6cVP/uPbUxgHZvc9vKUk7ZihMAdJM/QJoyzjZH6yQbQFdWuW1djZSjb73Qj8z6XDxjDSnNKe0bRENBNDF8QtZY+4SrstlYkvIA4CwbKhZnex7P/v2KotSfrMldYiEj08VUpaamEtYVxjZYH2O/hACpC7y4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jndorv2x; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740665869; x=1772201869;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bLFiweyRsppE6neNh0AtxKCgD58kxybynAyJxAzAfEg=;
  b=jndorv2xarC6R4jDLlbkckilK37I9NGQ3hEp1iaH2j/uVFgg0tJZ1/op
   4wGKktNuSz8hL0Er9UZ5wUvHMg19Odm72UJyJgqFNAa+wLtHljl+M/QiQ
   O7YewAdIHU5+Nl1hV//uV4bJsBBM/+GQjvEliXyJxBu9aLAtxx5BbGroC
   dZ3xcA0K0GyC5jV/sv2FVy/AP8MYXtMJv92sByQHPFq6HCZmUoXtNvV/7
   9/jkPZoak/M0B1m7ppM+IIsGgddLXhf+abjLMsMIbK5XbgnVZJqjtgzrw
   LSGrZceZ2wdL0LMmGu5QaUWdB4x6LfiL0s7tNasenJR7aj09YAncO8+b6
   A==;
X-CSE-ConnectionGUID: MH3vmqL/RDWiyk0NL2LuzQ==
X-CSE-MsgGUID: RGMutJu7S/m63kwJGa5pww==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40731897"
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="40731897"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 06:17:48 -0800
X-CSE-ConnectionGUID: dkZPv6o0SPOHyugUmISKjQ==
X-CSE-MsgGUID: wZJCS1jTSlayl/F4ETNDOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="116905901"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 06:17:47 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 06:17:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Feb 2025 06:17:47 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Feb 2025 06:17:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ssYwONkpd/W85izz48MnOE7wEZGjM9Ko8bC/HS3amXNZkhWUCXa2Py2FDiR/F2c9Aj9AZqmoZKJnM/YjRU0f2cTx51ecV2aHTJlR6XTX1rBy8Y9089wmsO+6Ny2DcF/sGV2r0iy6w0clJWAjuHM0CGppVycqmuGIuzTaPBbS2jzOgG6cxcawQBUyfTnkBuOTTViLkLdJYQQ+Q0eImNy67dku8sDAGR5BjawPsCF/cXa9Hw7+nEF5h4sInPPeBs3WKIB7OzYKAGEqNEGwUHptlh7Ldwpw+aBeFZu65pm+UdrBx3XdtfnHd6EM5G74Gq51mlj4J70RQTv4BcV5ZUEyVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzAxRYP0qskVMwgTeoZlIVnuMxkeGaZE5v4D53YnYsY=;
 b=yh/ZTAGKbYraM4SCdcLUsZ371IAtHAkVUD6UFAExVSsAuT6j74lPrr3t38gyu+6OlyGDVaq3qZbYIWnpqWj9w1/SczVR2lTkrW+Wcnsiwf0sxxtvn7sDgcXMdSPJZbDufXBdReVb6i+9EvLRQHEMwbMFTgfrdtqBjNqCffhWNdnQ+C7CKbeTTOf7XfWVIjkvxGJTSy7VbBycf8OHMC25/sXejeT1RLSzdUWONZAfhVpA6bGj3ns1WgOoxuZQrD8Qix2XuAubLcii7n/YY7rAvcmbc4zNpPYA/Zqr7DRMDRMMEJ+HHtLBxsCaCAPGx5jJoHQz7Ugn1TKhTJKtk85W5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by MW4PR11MB6984.namprd11.prod.outlook.com (2603:10b6:303:22e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Thu, 27 Feb
 2025 14:17:44 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8489.019; Thu, 27 Feb 2025
 14:17:44 +0000
Message-ID: <df38c3d7-9a93-49e3-b9d2-0532b31c0519@intel.com>
Date: Thu, 27 Feb 2025 16:17:33 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 03/12] KVM: TDX: Set arch.has_protected_state to true
To: Xiaoyao Li <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<weijiang.yang@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-4-adrian.hunter@intel.com>
 <53e4e2f5-3769-4bbe-b68c-bd9d09a06805@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <53e4e2f5-3769-4bbe-b68c-bd9d09a06805@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0136.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::34) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|MW4PR11MB6984:EE_
X-MS-Office365-Filtering-Correlation-Id: 97c68454-5d8b-40d6-c631-08dd573980d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bnpoRkE3Snppc2JVU2Jpb3EwNGlURGsrNklGYWJlZmxzS0YrOWdiemVoYzVr?=
 =?utf-8?B?QlkyQVRPeFc0ZUZyYkIrYVZ1cXpoV0Z0NTBXR2k3UjRrZTFCV1VYVHZMNnYw?=
 =?utf-8?B?RmZIa21UUVhiZVlheVc5TFNaZG04d2MweHRZOFlvVGptWm9CNjZNekI5M3M4?=
 =?utf-8?B?R0dPSjVUMHJsczFJRFZRbmUvWDFoTSsveEhlQ1A0Tit1NzdHRGdXS1FMMkFC?=
 =?utf-8?B?bWdjWXdRNEFSeURlWjdQT1NVVXJ4ak5OK0xvYXhvQzlqZno5VWk1clZUN2NH?=
 =?utf-8?B?bE9mVGNqa1FnZ1ZGTFRGL0F1Y3lydy9VVmRTMnFTcE9HNnVHU3pvVks3blZW?=
 =?utf-8?B?M0xaUzY0Q04zS1RxZWlvSmtyaTNxMUErRkgzM0U3WXBNRlhNZlYxUVBsd3h0?=
 =?utf-8?B?cllZNk5GMXI4RWUyV0wvb1RTRUxZSkdjZHNDL01zdWNQSjc0MitRdkpLeitJ?=
 =?utf-8?B?RGdOVVQrbVpJNnI2K3czKzE1Q25iclFuazl1QnNoRC9iS0tKWWZwMmFUck54?=
 =?utf-8?B?WXBuVURmRVFlWU4rMDcrYWhESytZdW9lS01NM1hLbU5HNmhTalBCK2xVYWNw?=
 =?utf-8?B?UUJ6RVFVcjZ3ZEFyNWxaR0lWejQwYXV6ZURYa3pZSnd5STBST1JCOXhTMU9U?=
 =?utf-8?B?cjZva1BqckpVdGJFRVRGZzZCZE5PNlpiVWQ4ODRlQ1pHdUNRQS9RajIwMmgz?=
 =?utf-8?B?c01uNS9DRFNKbnVkSEJEb2phdmpELzlnWWVUdE9OZjFUTythdjdPMlY4VlZP?=
 =?utf-8?B?S3JjdUFybmlLZkUyR1F3L3Z6M2VvR0NnQmhOVkVvSlJISzJ5RXB0eWg2Ri9F?=
 =?utf-8?B?T3NMaVVsUTdWdjZ3K3BZbm1GZEhEM24yUndrYXlLSGdQYVJJWU95TVVMZnRC?=
 =?utf-8?B?R3djbjBlcWJCMkdGNVFoaG9JMFV1ditUekMvNnNxSVhsN1NtMXRtQU1wMGlZ?=
 =?utf-8?B?QVgycUVJTkFDNEZRUU1TUDVuZ0pzd2hUanlzSkhHZFZBN1lIYy9mY0ZvSkdl?=
 =?utf-8?B?VGR0V0EyQXhzamRNUWwxVzI3clVOR1krVWxLK3VNMHVHQ3FDWlprbHU0eVBu?=
 =?utf-8?B?MDJTa05KaUUvd2RPSXZKNFIwR2psOWdqd1VodURoRHRVMmhFOTdlanUxQjFu?=
 =?utf-8?B?c0JYZzQ4cHNueS9nRXptK2cyTU9sSGRzaVRBV1J3T3hjckovQmZVVldUUmtt?=
 =?utf-8?B?MTBSSU53NEY5YUt4T0xBQWJVSFFBOHYwY3NQdWRlL0VFSUtZU2g0S3RDRUtn?=
 =?utf-8?B?bHZHU0liamJsdUNIN2NKUmMwZFAwMnlVeFhrcXAxSThmK0Q3VVdlZkVVUEg3?=
 =?utf-8?B?cUgxbzVlWEdpTGk3R3JrVHF4dTBPbkttcUd1ZnJJRXVOOFJlNFJJVW8wTU8y?=
 =?utf-8?B?dWVUZFNMVUN4akU1eFFRdGNZQVZnWmxwREJPdUkvWkVvQVQ2SUtEM0JqS1ZJ?=
 =?utf-8?B?SUMvbnM4U01qeDM2NE5rRFp5QWdUa05OcHg2WnFnR1JCbTllSFpKcFFTVnVI?=
 =?utf-8?B?UmNIeFA4TTU4alNQZjNzRktIcW9CZ0Y4TDJlZEg0OHVEUUVZY0M3QjFNczlw?=
 =?utf-8?B?SzV6MUNNRkNPODM0ZXJEVVlBK1F1aU1NZEgzWG81ait3UjYzOUY0TkRkWXdG?=
 =?utf-8?B?M3N5dHRlTUJJVGRaZ0owdE02Tk4vdXNOaUQwajZRU3pCWTU4OWFkTWdLTlJ6?=
 =?utf-8?B?d0tkd3BnOEdBUXhNZnBtemNkK2xLU3dIbGtuLy83T3lpT2FSSTZTKzBDMU1m?=
 =?utf-8?B?dEU2Rms1UEtyWHpOcVV5YlpHVjNXSjlnd21IV1BCbHZPUUh4ZldYZThnSjNm?=
 =?utf-8?B?V2NJM1BWNkx6eUdwcFJaN2JlT1hMbGpOWWtvNzVzM1ZyYlRTZHdwOFZZdGJS?=
 =?utf-8?Q?6Fin8YZlPDBQL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDBHcnFPVTMrTWl0ZUF1ZktkQzRHaXl1ajErOElsc05abFZBbXNJMXYrZ255?=
 =?utf-8?B?dXpYQWpVZlphdnQ4WWFGbkZLYWxtRTNDWmdxZkF5QTZYc0pmbmdGUXdJUWU1?=
 =?utf-8?B?KzYxS1VDWS9TMTdLTCs0RFRabHlrUi9YOEE4ajlhT1ZBUHhNcm5OekZQVVhw?=
 =?utf-8?B?L3ltNEhWZE1ObnduZy9FR2xQTjRYN2ZkYmQ2eWhOZWR0dTkwem1sNnJ5OE1J?=
 =?utf-8?B?RmNCY293QVFPaW8xaDVBSFlURVRVeFl6aTZXQzJlc0JkM294WWIybGFuREM3?=
 =?utf-8?B?ZEd1bFkvOHBudnRVRlg4N1RuMDlwRDVBUUZBQjNZWE03Ukc2emdGZHN4TEg4?=
 =?utf-8?B?MSs5UnBjcjB2ZDBQbmdkamdlU3ZjbUxYb1oySUJEam5XWTJvNTFIQjdhMjdJ?=
 =?utf-8?B?YmRmekY2bXVReDYxUUxxOUp3ZG5udHFjT0dtQnpQWEpJK1AxTE53TjBBR0Va?=
 =?utf-8?B?eG9Od1IxMVYvS3BTREYvanJUQ1ZrRXl6NE9MbTJwQ0ZDRW5YVUVEZ24wYlJH?=
 =?utf-8?B?Ukl3OUpOTkRjKytJK1dKb29YU0l6V2dpSmRhQWNJU0NvbG40MVRVcWgzTmY3?=
 =?utf-8?B?alhtRXVHcm10N2x0SlNVS21OOWl0Q0lWeEMvU2dYM2pycXRSdGZoU0FDQXNl?=
 =?utf-8?B?MWlOMzFOS3JZTFJEL1hZbncyUWIwMGFGcmJOWHpORUIzNXVkQzNCNFJUczRZ?=
 =?utf-8?B?dWNkMFdjVk9uS3ZHaGlIRFFoZDVlUXFjVnhLVWR4ZUNuVHd0eXdaZmR0S0Ur?=
 =?utf-8?B?Zi8vUEJrL1J3bHdDT01BcUd2dE5DcjYrWmEzczE2Sm84R0xtMnd0ck9UUjJR?=
 =?utf-8?B?ZUNDMGNVa2lNeHNyU2ZTa1EzekVLcitTbFlWNG91MHBBYklVOS9oclhaMThM?=
 =?utf-8?B?aERnRkxQRXIzRVJVdE5FTWgwd3RtelZOemhkU0RDR2JqbmthbXluYWZHZkdm?=
 =?utf-8?B?UnhiSjd3VmdWY2JIaS9EbTB4S2gzVGJJM2lIUXdNNGIycjRxSWk1K2RrcGZo?=
 =?utf-8?B?SVRWZU1aS0pPdEcrUGhodXJxUjhyQzBVdTUwZ01meUxqdkl4cFBzaHAreG11?=
 =?utf-8?B?dTh6bWNqQ0F1VDh6ajVkYyt4SGFzWmtueGRxVEtQdVIvZUVEd0tXOHQxbkFR?=
 =?utf-8?B?S1JEa3VabERYeGpGK0VFcXF0YlhpakU4U1FvZjNJYjZwcnRxUVdFQU9NRFkv?=
 =?utf-8?B?SzEvdDJ4S0JXU3JSM1orNDdLVEpNc1AzT0toTVo3RCt5ajJoSkFLdnozUUZW?=
 =?utf-8?B?cElnbXFsbm5iSVA4a2x5NzErbjBGY3Z5VXNPT2h2aHhFbkVRWXNLVUhwL0dY?=
 =?utf-8?B?M3hmcElEaklOcXRsQmE3R20xaG5rSHZnc205ek13aFVtMUovMEZ5Vm5CelZ3?=
 =?utf-8?B?b3hyMzNFSVdSd1dhOUJvVDEreC9VZ3B5Wi9samZUaEIvUHBZQ3ZYdjhZNXVs?=
 =?utf-8?B?Mm5odEtjSW5XandVVC8wOWZsT2JuQ1U4eUt4MWFFdlFMeWg2R3EySkZiMnV2?=
 =?utf-8?B?N3hhTzBNVkZpRjdncnRIaXB0Nng3ZzBNdkcyS3NpK1ZPQVFkbU1UOUtjd0F2?=
 =?utf-8?B?bHMwNWduQVNpckZoMzRsODVDWFgwalEwQm1MdWNXbDcycmozSzFXb0grbUZx?=
 =?utf-8?B?Q25Hb2VYdW1lNFI2dGZGb0VUeDNpMTNGdnhsZ1c3T0xyNFVVRjdKQzd0K2Np?=
 =?utf-8?B?WmhicnpYSThXeDArL0NCUTVTMlo1d0FMZzlRRUc0enpDMkdVL1BrUmhHa1No?=
 =?utf-8?B?Q3YrdUxJZVpLQ3I1SWJrUFIxYk4wWW50TTdDdmpOc3RIeUNUWnVIaWp1R1pP?=
 =?utf-8?B?eUltOWFVcitIMGRCOFNMVldmVXpDSUZhbWpxNytlamkvTFY4eGxzbC9pb3dy?=
 =?utf-8?B?Yjg5dTdYOTlIc2JqTDIzL0w2VDF1TS91UGI2U2xPT0V3ZUhIeXFpaVllQVdP?=
 =?utf-8?B?clpKZG0xNzdzazBYcE82YW5uM1MvSFdNRjJaYWJoSzJpNko5NUxpSVJMRTd2?=
 =?utf-8?B?c2ZQVUpoRmlhUVdOQ0w3bTBjemJPblZDWmVnSnJlckJ0dkxOY0pyMFZZem1m?=
 =?utf-8?B?N0wyY1RYNUxlMnQ0RjNjRUtJY2xtbktPUmxGZFJYWkF3NjRWYlp3MzJTYjQ3?=
 =?utf-8?B?dGIvakRNWHF2TDdLYUtUcEw2TElIekUvem1RT2NrYWR3M3dyNHVERG1SMnI2?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c68454-5d8b-40d6-c631-08dd573980d8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 14:17:44.6256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f537G3tJ0WkO2BZs25w1w4b1mM3MiIuMMvjTAgPXRQ+EyB9Qgdp7EhHFM8zlm0WqtoFmziP/dV2m9FrxWhVR2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6984
X-OriginatorOrg: intel.com

On 20/02/25 14:35, Xiaoyao Li wrote:
> On 1/29/2025 5:58 PM, Adrian Hunter wrote:
>> TDX VMs have protected state. Accordingly, set arch.has_protected_state to
>> true.
>>
>> This will cause the following IOCTL functions to return an error:
>>
>>     kvm_arch_vcpu_ioctl()    case KVM_GET_SREGS2
>>     kvm_arch_vcpu_ioctl()    case KVM_SET_SREGS2
>>     kvm_arch_vcpu_ioctl_get_regs()
>>     kvm_arch_vcpu_ioctl_set_regs()
>>     kvm_arch_vcpu_ioctl_get_sregs()
>>     kvm_arch_vcpu_ioctl_set_sregs()
>>     kvm_vcpu_ioctl_x86_get_debugregs()
>>     kvm_vcpu_ioctl_x86_set_debugregs
>>     kvm_vcpu_ioctl_x86_get_xcrs()
>>     kvm_vcpu_ioctl_x86_set_xcrs()
>>
>> In addition, the following will error for confidential FPU state:
>>
>>     kvm_vcpu_ioctl_x86_get_xsave ()
>>     kvm_vcpu_ioctl_x86_get_xsave2()
>>     kvm_vcpu_ioctl_x86_set_xsave()
>>     kvm_arch_vcpu_ioctl_get_fpu()
>>     kvm_arch_vcpu_ioctl_set_fpu()
>>
>> And finally, in accordance with commit 66155de93bcf ("KVM: x86: Disallow
>> read-only memslots for SEV-ES and SEV-SNP (and TDX)"), read-only
>> memslots will be disallowed.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>> TD vcpu enter/exit v2:
>>   - New patch
>> ---
>>   arch/x86/kvm/vmx/tdx.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index ea9498028212..a7ebdafdfd82 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -553,6 +553,7 @@ int tdx_vm_init(struct kvm *kvm)
>>   {
>>       struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>>   +    kvm->arch.has_protected_state = true;
> 
> This can be squashed into the one that implements the tdx_vm_init();

This has been done in kvm-coco-queue.
We have re-based on kvm-coco-queue so we in-sync on this.


