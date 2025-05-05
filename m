Return-Path: <kvm+bounces-45466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 500EEAA9DC6
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 23:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B8183BA1C0
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028D92701D5;
	Mon,  5 May 2025 21:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDoI/s56"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F300C450F2;
	Mon,  5 May 2025 21:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746479147; cv=fail; b=T1Qvj5Ggaa1UVrQzuVF1pkUP+HveNSXsnL4uaRyV0Jq/aCGS996IFXzwO8fC0SzHdgkzBu98eFMcqt/uv/3lYA6SlzyzjKTax76OV5UDGf2Rv+2DViQq88RtLfaR7PI5PSsDE115Eh1jKObnrgLSYyvYSdjzXaa1XxeKEA0zxfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746479147; c=relaxed/simple;
	bh=grjHBYDPwUXvcn7n3flvisYPhelV5xlsMRFbFajWI68=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dp4INL/4XMIYdybUhelj73fgFzIqNQBZNlAKVX7pR5p+9AT+3tIUZcZvFrK6Kv9pBNHWFWnO8cwLMbSzhXkD9OCCMj46rLIzFlIaWafOiJcP2rBUgKZU97xMC23XLN0DlbasG1RgFTIgVKqo/c1q738QeIKpjMrfdsyJ//PDg3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mDoI/s56; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746479145; x=1778015145;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=grjHBYDPwUXvcn7n3flvisYPhelV5xlsMRFbFajWI68=;
  b=mDoI/s56edMvvB5m/7jMiM64/Au0GUIBffhDD05DJgQKKLBEYpHiXm0M
   Cnc67idBibj1XS+N9KjkI902gHrbGXMKAijkp83SKiS6E43zBiXKpCz6+
   UPeP7DRRc9l0+3L9yvs8lmV/bq74LS2LlocQCnlI4B7wYD3g8KPHOg9HL
   4dda/PcEzrXTMvv9ggREIpAZANVknG6tGZyLEgPa+TZu3ZR6H7SD81kf4
   K7mQDA0gnyXu93SYVit3filxDzAoLN3k33w+BA3DXeYwK8sWL1AIjM+li
   Ryk9GaVNLOpdEAFQ2oYbkYkxal38ANqljr0GtW8oHs+7KnL3Y+0hxgKGV
   A==;
X-CSE-ConnectionGUID: 5hNUH9sGQL2HYEKDQUQliA==
X-CSE-MsgGUID: Yyt5qnX7Q9ah/79+TSt61A==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="50760500"
X-IronPort-AV: E=Sophos;i="6.15,264,1739865600"; 
   d="scan'208";a="50760500"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 14:05:43 -0700
X-CSE-ConnectionGUID: SzoxT1YyQ3SVa4a9zWP1CA==
X-CSE-MsgGUID: Z9nS512GSIi43a3vobF1EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,264,1739865600"; 
   d="scan'208";a="158604958"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 14:05:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 5 May 2025 14:05:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 5 May 2025 14:05:37 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 5 May 2025 14:05:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FS1H2lG/DVzng/0dK8Q5+1qnqHW5aPXJuFu5EUL+ZFz0XumUegaJcff4ZwvLInoxN12MZt+beI2phI4m17d6EUER25Vbl6LtV85eTjnDkxIRPFIvxzRdQKVUsOV7UD/ezFws3BGwJQuH1ScAnybdRxtb8+k95hnDPcgYFX4fTAvfHSQJFAYGLOs6yz1xXy3eNXy3I9r0eioGzlQ5sFBemxZ7BPO13tnOybjlEBG+IWZJti1a0BezKXw7yYlDo4ESbcfjm82cWHTDvI7gx6HzlLwISmJdzy+5+WeGcBm+aAqj6m4WO//InhQ+gPt8ggOHE8pa68/NIfkVWc56hfX6Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C4XcwwsBLdyvmO6/Y9ON5vfCPH6jFg1tdLZN3fWpFTs=;
 b=fKsn6Vp+QRIbAy47xQGnikyUlUyb6D9a4iOpAcpfGgsKj6gkG43UNGUza1PZ4hynj/v4kvBf50rT2EtR3tmw9VaSV9WqZx22kFDVyLlf4uHCdVkt6eADHdAs2PeM/iQ3ZrvryA+KAg5odth3KKUDwG2IhYbaNYZmXdi44P8xUACb92hL+Pd50mDpWq2IvhOpk7vkpTuOOk0uG6GVlfb5HMnKEyaCG6wyQ6yOpg9nIGBSXnT6jTc0vqHMOKaY1tfjfhAFQGHqyBWovK96pAoqBXyfLSOJxOeDvNWZJTQXb254uMlCpWnce9huUL/1VfDQ9A18Y+GEnJHEyzrGJc5gYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DS0PR11MB8763.namprd11.prod.outlook.com (2603:10b6:8:1bb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Mon, 5 May
 2025 21:05:31 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8699.026; Mon, 5 May 2025
 21:05:31 +0000
Date: Mon, 5 May 2025 16:06:04 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
	<shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
	<rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
	<hughd@google.com>, <jthoughton@google.com>, <peterx@redhat.com>,
	<pankaj.gupta@amd.com>, <tabba@google.com>
Subject: Re: [PATCH v8 08/13] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
Message-ID: <6819283cc31f0_28880f2944f@iweiny-mobl.notmuch>
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-9-tabba@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250430165655.605595-9-tabba@google.com>
X-ClientProxiedBy: MW4PR04CA0386.namprd04.prod.outlook.com
 (2603:10b6:303:81::31) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DS0PR11MB8763:EE_
X-MS-Office365-Filtering-Correlation-Id: f02482db-12d6-4d68-758e-08dd8c1891c4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cU9ocWQ5TFFtWkE3WS9iNm1XTklYQ1duS1YzZEtLN1dCcXM1UEt0b0VpQ1RP?=
 =?utf-8?B?WlpFUEZ2MzVqa0xHVjBGbFZOMXIwdGEwVGovdHdBbTRFSk9MeTFwS3REckt1?=
 =?utf-8?B?djNZNFNJMGpKM2xZQm0rUUN6YTNqU1JTVEdsT0tabEZUT1l3cnJsMXR4V3pC?=
 =?utf-8?B?a2NteE1DQkp1ZWpqS1lIOFNvckRMNlBVTGlSUUliN0VIa1hBdXRhQS9tWVlU?=
 =?utf-8?B?d2hIMHFoK2dsS0JLRUxZUHYvY1NwSlRYSGxCTUVxR1hLZlJGMG0zdHg4dVpL?=
 =?utf-8?B?MnRBUk9TSUVjdGI4SzNGQnliZEFRdGpCbDJja1NRR2RJZXVXMVJvaDdja3p0?=
 =?utf-8?B?NTFmS0ZHWGxoKzdBOG5OY1FrL3dCVFlEMTFPTnorSXVmblhxQnRYcWgwY3pK?=
 =?utf-8?B?c3dqWndFZ2lyT2RxcGRpNldjTFVZZVljdHJQakxmSHA5dUJIOUFXK0FTMStH?=
 =?utf-8?B?SGFCQWdiVkY5aTM2Znh6OHJqUGtRbzkwTUd2ZlNOY1JRSlZVZDl3UVhhcmZC?=
 =?utf-8?B?dDZyb2VLQWl3THFKV1RlVzIrTVE1Z1I3OVVDOGYxbklyd1AzdzlIZzkwWVNF?=
 =?utf-8?B?WlpaRFNnUmo1MDRKNnNBa1hUMHVrbkhHUEhCa0lpTFJIdExMYjlvR3RucVVG?=
 =?utf-8?B?ZEtMR1dQbHNwTDRmZ3lLOURxU1dVY1RHNHBwYVNVV2lKOVJ4TGtSMStLMll4?=
 =?utf-8?B?L3hidk9XSFM4cUdmU0pTWWU5Vnc5ck5UbEFWVHlQd2JuSUVhK0dLNWpKak9S?=
 =?utf-8?B?aFNFOVpGZnd3ektyek1ELzB6aFpoME5lQUtvVDhPSDNoRS92UVQ2Rk1VcW8z?=
 =?utf-8?B?NngzRTh0T2dZckZZUkxIRUxkSkZrcWZnOTkrT2dCMEdVbWVUVGVSNTBNTWZ4?=
 =?utf-8?B?aE5qV3Bla1d1SVM4QjhFT1pRQ3hIL1J5ODRIWjVwVnkxQ0pBZE81MERWUkhV?=
 =?utf-8?B?dXBPZU5leEZSYVFpYldmL3BCUDIveUR0NDNYTXNvTm0xUWdIVXk3UVRiWlhR?=
 =?utf-8?B?a0wvWGRVWnhKT3BGQ0pDdW9KSUlXeDBOeW1BTkdZOS9Md3dPNEU0NTQ3V1Mr?=
 =?utf-8?B?QTZ5UlVJOVNlQndiZXhlODZab3BTZTZxbkx0OGRnZTFhVWkzVEJ2UEhHbkF2?=
 =?utf-8?B?YlZTckVTYm5ONC9mTWVzV20rSUhCWllOQjVBeUczVzJpSHlUWisraHZIdlhq?=
 =?utf-8?B?ZEc4S0RNclFjYlVqRnh2SWI0SFFxSzJtWVl6aUI1bFNGNzdrekdnTmZBTWl1?=
 =?utf-8?B?TXZ5RDlqL1dtVzFPd0JVcVpWT1VENHBDdVBYNDRXNHR0S2FGVnFTMFczWmJE?=
 =?utf-8?B?ZVNLM3hJaURQYjdnZEpWSmozTnFDT0tjREVwVURlMjI2QTBRYlpLbEFlOVZa?=
 =?utf-8?B?dzdSenp6ZExlRWx6QWlqUkg3L1JFVE9UcFJHSnQ5R3Z1WEZOTGR6bWVXZUJ0?=
 =?utf-8?B?dHZBY3E2cld2V0plODYxT3Fjbis5WDNSRXV2UFI0RnpZd1pKVEJjdnp2UUJU?=
 =?utf-8?B?VkZpekJpUk1leTdGWWlOdk94Um1UbVJJMFJ0K1REa1NBOWxqd214akZRdksz?=
 =?utf-8?B?S1VWMm54VEFwZm9KWlY4djFxdHl1enF6MUxhR3MybjNtRW5Bdi9VcVBSNWJ2?=
 =?utf-8?B?TkRoSkR4V1RlOS94bmY2SXNpMXp3TnVJZjRFVnI0bWovN0xuaVUrNnZISW4z?=
 =?utf-8?B?OVYvU2hmbmFMb25YK2wxMHhVUUcyT0pibnlpdVNyTXJBb3ovYkJXRFBRY1U4?=
 =?utf-8?B?Ky9rL3pXYVlwbjA4OXZmcG5RYzdIN3JCajJEbWFxNEY5ak1aZzJMdEZCSVVu?=
 =?utf-8?B?MnNqNThzeStCNjJ1S3JzcjBQd0FKeTNUWnl0citJYldUbnc1djJrZXRCMHZY?=
 =?utf-8?B?c1VDQTUrbTBqYWdWdHc0ZW1yK0RSYXhQUmlIOFZ1UklLZlQ1dDNWZ3FFZ1NP?=
 =?utf-8?Q?ft3kW2XFKfA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXRRbmJKbkxFWnZKWURoZ25lT3BYYzhRWUk0MFlCNXpmcGUzR0JIVVRvUVFu?=
 =?utf-8?B?YmJwWFY2aEU4cStnN0JEWkgreHhJYmoyS1JsTTQ0RE5oN1ZsU1YvaEluV0RQ?=
 =?utf-8?B?ZXIrYmhkcDY2Y1dWR0NGTCs2ZUpkQ21Ydjd4cENNcWZKU08yY094ZFNDOUdB?=
 =?utf-8?B?KzBrWjJudVpSWHNJTTg1cW5odG5CUEFLV3JBcTJMV3F4WE9mSUxoZHZkWnEr?=
 =?utf-8?B?UkdySldOQmp5SklPNExhNWh4SVdETWF5akVSZDFVVDhMZks5THRRVFluOGtQ?=
 =?utf-8?B?ZlFvMFgwbEJuaDFySk9Gak9MWWlIeFZWZ3I4V2prVkJ6UVBmVTdhcXRhN25j?=
 =?utf-8?B?NHN6aGNuVUxZMFZqM2xNQWdFUnlaRHp2OW5KZFpIZGJrZ29PcncyLzJDbXRP?=
 =?utf-8?B?ZitMdWRZbFA1UHlYby8wWFRzVE9wakdpdE5tRkppZUxIOHJzQUhkR2JyeXlu?=
 =?utf-8?B?OGxkcnVlbkdlQ2p5bGpsbWlmSVN5enlzdkJNVUxYdGs4Z2RTZjV1VUlHb3dz?=
 =?utf-8?B?YW51bUQ4VzhKckExckpQaXBBeEZaa0doSlBXS25OQTRQSjR2S1hBTWpnRGN2?=
 =?utf-8?B?ck85dVlERUJFUUZTRHR0Rm9xMWRDNUdOMno5VloyMkFRMFpPeng3YjdUN3ho?=
 =?utf-8?B?R3NUditaUkkzWmoyeVFHWjhHY1E4Q3ZaajV4akFOeG04UFUzd3JuU3VtZHJS?=
 =?utf-8?B?WjZqeDJiVXlDVVVHRGl1djBsUEo0K0oxbE5YcGMvOFNRYTNsS1p0MVNGYmFz?=
 =?utf-8?B?V284aVNqMlpOY3dyVW5YUkM0T3cwRG5WYmFLaDZiZk1CZXU0TytLSjJoa2Uw?=
 =?utf-8?B?bFI4OXNhMHVtdXdLOXNMVzk3MVlaOXRwOENibWl4S2pNYVhld0tIaUFydHVn?=
 =?utf-8?B?dUhwZVlVb2pNQ29NZnVvUUJTZUVSNzRXaUxlUE5HWXJpUXhTRW51eGdhOEUy?=
 =?utf-8?B?VGh4dnBxZ3NUVmIrK01ycnFTU2haR21MWllKanRydDB0MFg3UngycDdmK1Z1?=
 =?utf-8?B?QldWUDhVTkljblVORmNVZ1h5a3I1WG9oNDY2QjBKL2VEN3hVUkJnTlRtTDBL?=
 =?utf-8?B?QmcrRy9WNmNKcldOY2RxYldLRWxCM2ovRXdQWlUwWVdaQnMzSnR5M0RiVTAy?=
 =?utf-8?B?WVE5UVVvS0tNQTM3ZlljV0FKRHFycU5wb0JrN0QzK2lWMVZ6bVVzL25MN0Nz?=
 =?utf-8?B?UmlGeitpWU9XM1pHaUpOeE15UVRKcDJXMk9td2J2eWVxSGo3SGMzZmZVbDNR?=
 =?utf-8?B?eHVKMmg4bmNXSVkxYW5XOGUvc0l5OE1BczJHaHlOOHBRUlc5UktSaW5YbXhZ?=
 =?utf-8?B?c3lJcEw2ZmVFbHA3bVVLVW8vRHM3U2VIb0xaREhqNGlrK05vUnhKVko5QjJ6?=
 =?utf-8?B?SSsveDNHbnBxRElwWmxiSG5KSWIrME1JWVJiN0dZUDZlb3dtanQ1dldRRVFT?=
 =?utf-8?B?dTJDeUh2SVZYOE43eWVVMXVmTDNZWWw5ZXdjakl0Y29kRURpbXgrTGRaZUd1?=
 =?utf-8?B?cndITVhicEFFbm5sREV3RnBtRCtDcTIyOHMwZGFxMjZ2N3ZyQXpkYThGWmsz?=
 =?utf-8?B?amtaU3dEMkZtOHZUVjlPcE1DR2hFKzBNVVk2MCtMaFIxN2pEaVVocWlSUGVS?=
 =?utf-8?B?ekJyNk5sb0h4YUowckFKbnMzakNsTko1Y0JmMTVHd2h2LzdYMGlYVHFwQllG?=
 =?utf-8?B?Z3JaUWFPd2xtYWM5elJFRFkwdUdYNjE0ZklFbEUycW9maHp0akpuWkVDRTl3?=
 =?utf-8?B?UVdhei9IaHhReHdwV3V6amlKOGVIWlNDcC9aaDlseFRQdXpYNGdhQjhyM2Zh?=
 =?utf-8?B?SDM1N0tkakJEb0U2b204Z1paUWtoVHQ5cHRHTWRnQVJ1cDJtelFWVVpkN2gx?=
 =?utf-8?B?SUcxeUZVcG9CbGU1S0ZmbEUvanBTZjBmdnBWUk8zWHpkSTN1ZGREL3R6ZDNK?=
 =?utf-8?B?UUNIQXR5L3JjeVZGSmI4WDl6SG1ubkVYOWVMeWIrODR5WkRpN213MjZWRWlP?=
 =?utf-8?B?NjJDRTM4WmVkV1ZIRW4rcHhrQkp2eFNEZXA5QUtGVGp2Q2pJSVU1SjlWYUR1?=
 =?utf-8?B?YTBsUEJiWGMzN2ljeUo2OFlkaUdUdTh6LzFJSk01SFdCYXlpbVpqZmMzUlNo?=
 =?utf-8?Q?9LQFE8rVdEH2p2KumdZ4eBBO5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f02482db-12d6-4d68-758e-08dd8c1891c4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 21:05:31.1029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AWNy8F1/vOUoxyijVx6vc/ltogjeB3K+LiS2TcIylH7HRoo0STrON4MLgZHq4+oFwlFXw7xWTUoossHBTkr6uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8763
X-OriginatorOrg: intel.com

Fuad Tabba wrote:
> Add support for mmap() and fault() for guest_memfd backed memory
> in the host for VMs that support in-place conversion between
> shared and private. To that end, this patch adds the ability to
> check whether the VM type supports in-place conversion, and only
> allows mapping its memory if that's the case.
> 
> This patch introduces the configuration option KVM_GMEM_SHARED_MEM,
> which enables support for in-place shared memory.
> 
> It also introduces the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> indicates that the host can create VMs that support shared memory.
> Supporting shared memory implies that memory can be mapped when shared
> with the host.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h | 15 ++++++-
>  include/uapi/linux/kvm.h |  1 +
>  virt/kvm/Kconfig         |  5 +++
>  virt/kvm/guest_memfd.c   | 92 ++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      |  4 ++
>  5 files changed, 116 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9419fb99f7c2..f3af6bff3232 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -729,6 +729,17 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>  }
>  #endif
>  
> +/*
> + * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
> + * private memory is enabled and it supports in-place shared/private conversion.
> + */
> +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)

Perhaps the bots already caught this?

I just tried enabling KVM_GMEM_SHARED_MEM on x86 with this patch and it fails with:

|| In file included from arch/x86/kvm/../../../virt/kvm/binary_stats.c:8:
|| ./include/linux/kvm_host.h: In function ‘kvm_mem_from_gmem’:
include/linux/kvm_host.h|2530 col 13| error: implicit declaration of function ‘kvm_arch_gmem_supports_shared_mem’ [-Wimplicit-function-declaration]
||  2530 |         if (kvm_arch_gmem_supports_shared_mem(kvm))
||       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|| make[4]: *** Waiting for unfinished jobs....


I think the predicate on !CONFIG_KVM_GMEM_SHARED_MEM is wrong.

Shouldn't this always default off?  I __think__ this then gets enabled in
11/13?

IOW

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3af6bff3232..577674e95c09 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -733,7 +733,7 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
  * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
  * private memory is enabled and it supports in-place shared/private conversion.
  */
-#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)
+#if !defined(kvm_arch_gmem_supports_shared_mem)
 static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
 {
        return false;

