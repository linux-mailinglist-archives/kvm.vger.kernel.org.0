Return-Path: <kvm+bounces-23286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9329494861F
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:34:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD290B22C5B
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDDF0173345;
	Mon,  5 Aug 2024 23:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Etq2cwg7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537A9172BDC;
	Mon,  5 Aug 2024 23:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900780; cv=fail; b=Cd8gZmXGagTHBc15l+336Utsuq/oFCIGgSzDcHBSXXTLvHZYClR79ee1NUsz0159nZjT7iWBRWWQpPLHGFNe0bzrK4/PddH7BIZ5SK/Az+yK/u8WjfYORmRQ4tQvKBl7/ikArKgK4Ueg+GP0p1UlTuF3g3DznNpl4Xg2tdO6vSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900780; c=relaxed/simple;
	bh=5cObyG3Dbt7cPRpNxAbnMgqMLYSTYFbpwOKs2f89MYA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mN6LzGIwRuUrHdH/XTKDSdi2cntwUJiI8x/chz+KYUkb1j7FEODieV4AwnfJkDu7O+4yZmb7tO0cRm0G8ZLTvHdnb7S5dCtskJF4O383MDq3767T8AiAYzYTlyeSIN4Hi+Qbvt6jP7qWKf22HLPU1R4Z8D8rge6AkjSw8wr39ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Etq2cwg7; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722900778; x=1754436778;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5cObyG3Dbt7cPRpNxAbnMgqMLYSTYFbpwOKs2f89MYA=;
  b=Etq2cwg7Bu711hQsRrhRYJsovryL3nCGjdHXukuqxevhuFqHtCl8tBYV
   YeI5nc/7SIouootBeoYcTGG66c1JbdYeJZfDY94GOZcQzpT/YHNQRjGwo
   8OI6Yvszpb5gsWAW2sodX6s5tFlvgTIIk9EpCt+QYFB/2SzyQG260Afxw
   jtSHlFr1zgEG/kFq9muLCj233GKGViZYWP8ZyPxeQonzH3TDDxO/2ztNg
   8ibv8+UqlN+MLPOuGBUA7dcLG8wK+clWT+6JhkYvphs8po62euXig1drX
   uS83sanRdZXprk70XGCskbFSip7A0CinjeD4tUrbUfhIoUwkAJaHCN446
   Q==;
X-CSE-ConnectionGUID: HB7YAcBMTQ64YokgfMDnDA==
X-CSE-MsgGUID: 6+Lr2TGAR6GpR4iNgjNskQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="46293810"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="46293810"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 16:32:58 -0700
X-CSE-ConnectionGUID: fonvee6rTreGOuM/qcS2hQ==
X-CSE-MsgGUID: nQrC4dhpSSGaGpuheGiyzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="56530343"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 16:32:57 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 16:32:55 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 16:32:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 16:32:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 16:32:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vKwAXhw2ishgbMpP2nKotqEGFrH1As0+/qLhuBNuFOB2+xAbT50+kZXGulCtQkDqOuxXmw3U7xrPLkhYKYwq2bPzhpHvgls94ATdk5+RhnKvLI5Yd0DAQHsC9VJn7zA9alh7HFkAPfzsClbg5cU7GWt3DRWfzwhQdcplXwqjYIh/n4x58z8usD3I30xJa/t4nqt/ho9dTCKCFOk9HehAay+vlxfnuYTyhjDy0mtToQNi00UrXYOWO/evU1fM0CPEtHR1yoMZ8Q7x7E2HyUezSyZcWSvqbWVD+H4sILUKHPuWkqddV1ZeT/+0mCKth9eyy7sDmvSFvxg7eet8uzzoQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Bd3bjbtsO5b4EDBvGvXIfM5ZFpDUr772su9EX42vD8=;
 b=gwynQfnDSKT3J6cF8RXh/zxQO+LqaQolGWhXm9ZZ3Nihz3MdefIFbvEJlBmrevEnyeebhwQaZKC4cdqYaUwCZy2UNJc0kpXWZlvTMum5BePI32++x4ZikE9YC2glAHfJH2OWGSAnph6ygcCWHt/dpUiz8YIIh15gWB18yxBirRvCQisKqgPEYYB88KyFomwOHFTJ6vDmKKDEI8G30Ln+v0QyCAUwSkn9xeONo0zTpt92/QvptKwIKtmw+W/8wFGi8gcSsKDbbMsh1Ul5fySD5KjIl02GF6pAiWMECab2EHjUAP3FirS9Sgyqx1w4HdonoehXEOrIl4eeeq193T/tkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW4PR11MB5934.namprd11.prod.outlook.com (2603:10b6:303:189::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.24; Mon, 5 Aug
 2024 23:32:53 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Mon, 5 Aug 2024
 23:32:53 +0000
Date: Mon, 5 Aug 2024 16:32:49 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dan.j.williams@intel.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Message-ID: <66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <7af2b06ec26e2964d8d5da21e2e9fa412e4ed6f8.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7af2b06ec26e2964d8d5da21e2e9fa412e4ed6f8.1721186590.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:303:8d::26) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW4PR11MB5934:EE_
X-MS-Office365-Filtering-Correlation-Id: 55494bdb-78ed-43b7-5270-08dcb5a6ed56
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Tm/Gji6GT10sfUkIJU38vnkuPJhOF0am7ZMzfacKWD6UZikAp3vSfjE0EAot?=
 =?us-ascii?Q?mQmKa5HeohSzTaCEe7SNhupypsnVtCmxRhCryh8Yud6aovqPj0VVM82tWwNS?=
 =?us-ascii?Q?fXf1JBJOAuHVJAcQdFStjjix+XuT7CCjSQtqk4tVECY/R8uq9YH5eA6ayy9g?=
 =?us-ascii?Q?AgPCgKOXaCOg12uhFT4rLjkQVoqUE4StirIt7Zu6EWFAuSZS8r0RG521azhk?=
 =?us-ascii?Q?ww+VjrVj4KFebkAc/gEBYUarqevscMa+pAm6Nt+RXObySfgajS3xQL6IY9bE?=
 =?us-ascii?Q?IvgjyXpDVOX7VNKrAHqAwWKFcGFuodlk56iAmwXaVa+Qd1DTI6r6hpuBw9f4?=
 =?us-ascii?Q?aINkm9/q6WNRE5eRgNtbqgj0Zec5AKWppUaAOrHD28G1BLOWEhqGHvK7DZbe?=
 =?us-ascii?Q?HyxIHqSb2vjlasdI1gKIfxKQ7y8xnAAPWChmfNMdput0U2lu/A5yPXiPVOXe?=
 =?us-ascii?Q?DKNk/h5gEjcJxFkoA+cKmLKjyuVhN4D4hopmnJ9oLxYA0aLEcZW34oJDfIws?=
 =?us-ascii?Q?7NoqPiEt3U0F8FoePwgpSul1LtM8mU/XRBSeERjNVokJzds9OCBVGp4ZLavd?=
 =?us-ascii?Q?vy2bOZvOXlVj4IQ/0ZCOqFIdjN7Otq9JNLk3f174Fm2Jt75YRNJ5x3D7trPh?=
 =?us-ascii?Q?WmT9wbb55S9k0KfGVE4YDp5xLEMjtEQyQN5w+We6s4xH5SQChBJlNDrIphgL?=
 =?us-ascii?Q?/ZW/yCGKD9/XOqkxiPWRBJUTbQsGWGStUn57+N3Tuw3KNS5K1s1GPAiQCwH1?=
 =?us-ascii?Q?V3lwVxQJXK8dNw+i7+mG9LKG/Os6UJyOUIWm1Db2VITZOUxOlqyBp14300xP?=
 =?us-ascii?Q?wQjMbYczKEtOE9q3jrtz9Lfq6pwfCeBGbYarWLAII8dF2Zq0FrStDlnmrXJp?=
 =?us-ascii?Q?+r43gL4UNNNUbIq3QySHZwTP5Rbe2SFC+9nco2SQ3cH5cXzW95YyRb8MgJGv?=
 =?us-ascii?Q?Lk7Al8ifD35GIoOj694RhM7V0i186h7LLVzcM9Yxr+nV8F4AYzXetLN2ktve?=
 =?us-ascii?Q?uUVkKFJctHG/bv7d5APyaKc100vQUbOB3RKwnx8ZETfk5n5SFKRa2yiJUpu5?=
 =?us-ascii?Q?3YEJJf4JYTRVfY4zaEVYszuK5sCQHk0S/ylnYenXlh17T3+248xu03uD50nD?=
 =?us-ascii?Q?Ny37ddRn8e5tCK3iiukWZPbQ/lR5c2rJPNXpyh2Dq44U8IrLUYoW3ft0cLhi?=
 =?us-ascii?Q?yzLgj5DE5I9kZj9NfnbLEOKD0//47AS9YhvPYI8FFDrYuCF/haXAhCNZIIWl?=
 =?us-ascii?Q?iDxRkx+IxbInwI0+lDIDyFaf9ILWb6l2NlOzg6ZP5Anz0vf31AtkkbtH5yJt?=
 =?us-ascii?Q?BbE2fNuSDN0yAWyw8RZ8AliwEhSefCmJ4+tN8uBv8ZM42eTu1RmqOlqwBE2B?=
 =?us-ascii?Q?Ucu625pQKWof9UN8k3XAs7Q7EXLM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BTC90nna2cdkfur3bwKC5Te/iPw7bx+0vtEDA0D/dyFg9m5RYjS7skDZdC9K?=
 =?us-ascii?Q?uK2qx/+o27yKS4NU3AzWqrZ8iV1m6sBSh9fVCqr6F/saxx48+U6E8UUKXjaR?=
 =?us-ascii?Q?gzCRSKem2+0mDKSH74vxfzbaxSLqOCIIlu9AqqPWh7scyHfkRI9+MMlYWwWe?=
 =?us-ascii?Q?TKs6zrCS5KMBvHAmowNTd4YxoAghyvMS7Lo3/kt/L7dk/B8k/187733Ce9Sm?=
 =?us-ascii?Q?+9t1a5354sOKgpHfXtx04hIfiS44UT1lPCLI+CjFwXn8ZQISHEMaBhqgXaN+?=
 =?us-ascii?Q?SXi8LTFB4Fopy6/o6lw+qUGv0aAODHycYGYhNtzAvbuTQ0xRr2qXXWKlcfRR?=
 =?us-ascii?Q?Sc1rpGxY3M7G/OPRg1s05XFZG28BxTr9osyZXUfapxsHT3J/Y8k99GE0BDP/?=
 =?us-ascii?Q?VpH9Zw8bNccIXSYw0tgRbmCwSTos32dREJvkUoqAKbHw4H1CiL7bUX1SDvcX?=
 =?us-ascii?Q?7xg0KdQCYdPGy7BfkJnifzl7S+bm/NvsztO/qn2ibAkOHbuNYxGZ4s78I0RU?=
 =?us-ascii?Q?ToTSlZicRxyRX8U6hhoQaEiJSKI69aH6Ggb6APqlC8lGQttDehVeZ77BF5RT?=
 =?us-ascii?Q?TTIaeFC6fOTyESlNWkWmtNExSiFyx6DTkges/EWA+1Hi2N2yMyUP2sK1o7NA?=
 =?us-ascii?Q?JWUo7PISejHBe//TkkRKWG8ZE71tyg0gyjf5UPKGyTFH9znyU9oTMAE1QwkR?=
 =?us-ascii?Q?P6NZ3WwzyuYAyFJpOefAs60huSWtJ1dTjCqR7XqsiG933wsDn9R/y7cvbcd7?=
 =?us-ascii?Q?b9eAjbQwRH/45eqZpCeP5YUyr9Nv/Quu3b0VCzhw/oWDloK8j/Jd+e9MXvIt?=
 =?us-ascii?Q?kk0QIRZOs6J/j6/ScXzXrKCpz+ztmXlQ/41y/97ba1KCTt0XBY6X1NRALsU0?=
 =?us-ascii?Q?6iiNiGq1+494jMduUve3ho2yvY88mAhwkP87gpDKuKhBqBC67+s5OMJVuy0L?=
 =?us-ascii?Q?DdUihpZMOHIt2DsKz5DgE/tZ0utKxp6zL97lzyucyeESpI4cf/J2fWz6h7zU?=
 =?us-ascii?Q?bZi13LYGQA336Ht76OkCsK+xldzHpmBhbxY+7NRA598PWx+iv33zs6iIIMKV?=
 =?us-ascii?Q?aYARPW0j3Dpin/L+A8bGjZak5czn1Wi5wESmRXt5lbcXSnFmDK571ZcRKGOW?=
 =?us-ascii?Q?3ODq1MTM71Ty+pe1FaKQyifpx6pNaKTNh+A/KG4L2E01Z15bU2x6AET1Vq8k?=
 =?us-ascii?Q?ywllNJwx+DNo282SKins+Mti/FDxxu62R/YKG4z3i0rsotH/iqFFhVyjeuW/?=
 =?us-ascii?Q?mVzktRQtr7JGh/aarFuNGf0qxutylAa8dHqc8VAniOHaj0RCyjhidlljRZZw?=
 =?us-ascii?Q?LuJWgeK1r2ixaALhu/2OUB+EJOilShkabN/dOPGGEoJ4c0w62VcHdb09Jg4d?=
 =?us-ascii?Q?ziL9TW3gDa/lopvWsKpGgIMMkTPvkiTjh8O7Nbonf/Whd8Ky3jiAzB54Ej+D?=
 =?us-ascii?Q?LcERJcYy9KTNkT4DD2qMu47xHRgjKps+GnqPvJYd7cb7HlXtRjzaVfgYsoUg?=
 =?us-ascii?Q?b71xXewWT11q8jR1F3xnsr2aXlNiS6Wa/N8Mq5xf8OL4C2tNcilZ+rusakDK?=
 =?us-ascii?Q?KSsKK00lpRdIvrNYdB/26dw6QLdMAxttFUirs0tdV7SY175/Pf8Sn5oVjzin?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55494bdb-78ed-43b7-5270-08dcb5a6ed56
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 23:32:53.2046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bg2Vqv67+I2CFik+DWw2C7D+R5VskZduIGVlvPPkcjDIxeyx5hSyHXQ6W1rEoeQxxY2iadQUQZVXzEg8+6Fbya5JUfcZ+d5sBKvlLAf13L8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5934
X-OriginatorOrg: intel.com

Kai Huang wrote:
> The TDX module provides a set of "global metadata fields".  They report
> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> For now the kernel only reads "TD Memory Region" (TDMR) related global
> metadata fields to a 'struct tdx_tdmr_sysinfo' for initializing the TDX
> module, and the metadata reading code can only work with that structure.
> 
> Future changes will need to read other metadata fields that don't make
> sense to populate to the "struct tdx_tdmr_sysinfo".  It's essential to
> provide a generic metadata read infrastructure which is not bound to any
> specific structure.
> 
> To start providing such infrastructure, unbind the metadata reading code
> with the 'struct tdx_tdmr_sysinfo'.
> 
> Note the kernel has a helper macro, TD_SYSINFO_MAP(), for marshaling the
> metadata into the 'struct tdx_tdmr_sysinfo', and currently the macro
> hardcodes the structure name.  As part of unbinding the metadata reading
> code with 'struct tdx_tdmr_sysinfo', it is extended to accept different
> structures.
> 
> Unfortunately, this will result in the usage of TD_SYSINFO_MAP() for
> populating 'struct tdx_tdmr_sysinfo' to be changed to use the structure
> name explicitly for each structure member and make the code longer.  Add
> a wrapper macro which hides the 'struct tdx_tdmr_sysinfo' internally to
> make the code shorter thus better readability.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> 
> v1 -> v2:
>  - 'st_member' -> 'member'. (Nikolay)
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index d8fa9325bf5e..2ce03c3ea017 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -272,9 +272,9 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>  
>  static int read_sys_metadata_field16(u64 field_id,
>  				     int offset,
> -				     struct tdx_tdmr_sysinfo *ts)
> +				     void *stbuf)

The loss of all type-safety sticks out, and points to the fact that
@offset was awkward to pass in from the beginning. I would have expected
a calling convention like:

static int read_sys_metadata_field16(u64 field_id, u16 *val)

...and make the caller calculate the buffer in a type-safe way.

The problem with the current code is that it feels like it is planning
ahead for a dynamic metdata reading future, that is not coming, Instead
it could be leaning further into initializing all metadata once.

In other words what is the point of defining:

static const struct field_mapping fields[]

...only to throw away all type-safety and run it in a loop. Why not
unroll the loop, skip the array, and the runtime warning with something
like?

read_sys_metadata_field16(MD_FIELD_ID_MAX_TDMRS, &ts->max_tdmrs);
read_sys_metadata_field16(MD_FIELD_ID_MAX_RESERVED_PER_TDMR, &ts->max_reserved_per_tdmr);
...etc

The unrolled loop is the same amount of work as maintaining @fields.

