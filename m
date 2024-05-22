Return-Path: <kvm+bounces-17928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 912218CBB52
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13BB31F230D3
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 06:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6AC79B96;
	Wed, 22 May 2024 06:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P2+o7fpO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E4877113;
	Wed, 22 May 2024 06:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716359416; cv=fail; b=Oc3c/UmEIN89+o4LFOrbMkWTsjnXGCmDcUNA7p3mmJQlj398Rm4yQkaNpnidJGxk4WBcBbjV9TuVDGRG5HLTTyaR87YI/bp0xSvg0oa5hJEZvMqM+PxgQHKdqOVrBMhDAXvMlSvcVaSkpOFKqbBlMyDprS5yi2xrP5t6FSeq3bI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716359416; c=relaxed/simple;
	bh=/zfHt9sDVycOfZBCdSRB87jcG7LBHZ9MlR/tKyepWA4=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o3sc1RxjR3dPbpFB4jZYsmxorLPik4jNmSFbL6wsZxhePUjcwkXjse7qdDbP/LmWoRbFTImoaARudOkNjxMyaJ3SPkpAmBo7A6W2YSTXmEiu9L6l8jTPQPUjYPBtfffMopnGbWja9npjDFrS+ReiGDWXPR/OoOAfI4FEra7XGHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P2+o7fpO; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716359415; x=1747895415;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=/zfHt9sDVycOfZBCdSRB87jcG7LBHZ9MlR/tKyepWA4=;
  b=P2+o7fpOddrrOx6QDPQeFKOM1s0aEaicIyR0XIzZ7dYrVwq+mGazP4mc
   c7JveImD5vs/2js/ShdVtZQGmThH/rETtIR3t9wmOLo+qwdqpOcdMTxdR
   yRIl6mPl4wOS6Ia/xv6dfgvcZ5Te+LEIOEW79FLscYuNpN3GIRslrpUOn
   kBHEr3j2yzUkc6vR4dgcRP4lexcdFz4n/Ai6jpJk0k0HFtl6FC9+YCjfs
   gKJ6x0ZK29ZmM3joSJBSwbEE43PRJ0lil0oFJIp1dwGpIaASe+kBf8MF4
   gevgy2x9vgxGj8FI/UpvsZ0bm3pTWa9IIe/H4Y354ujngLngY809tmw1h
   Q==;
X-CSE-ConnectionGUID: ye56AAm4RimMgTvMpPKcIA==
X-CSE-MsgGUID: ZDbAPH1LRbqND9qMbYTe2A==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="15539347"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="15539347"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 23:30:14 -0700
X-CSE-ConnectionGUID: f0JC9LPVSZSzNmZNAQpOLA==
X-CSE-MsgGUID: M52XKNo+Sva24C1bjQiN0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33233485"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 23:30:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 23:30:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 23:30:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 23:30:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 23:30:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDyn9SP7jE8WeXzihCFdiCWHXGIKKu7k+uIIax+Ue1JAo5wLReywCRT7O/zYjkLeqCARFnVBdDC4qctYkV8vQiPvBBylNuTw+SdW6zoMJ6LRIgixx16xTYwxIAZuhQRAfOIH02I6xmvG0cjjdjSt5Wm5ryBh048PL7sXm0pPd8Camy8WgcArz3mtsaRw6k42BfI0TnKMcl538xxPJz3rIE7W6fIA9YIdHGOe1J56aqEzleaos9LB6MX+NaRUdfC4ODd5UiRgL4qotQWri8q7pvhkPRHYUCow/HiaFDXIuM0T3w6Tt5IfuRnUJ0E1AWMaIX/37i+ldb8rZxYJw3zBNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ILuVXmUPq7w5eqHgaSJszU29dxrp73qDOondufFPKw=;
 b=K9OD0SfR6yJvrMiR9fv+X8dvg+5AosEVD2NUgob+pRmlScjSx+1xhp/o0ogUeKG9rcxhzmMBl71tMSE594DBMp7kKRaMZ6v3wTqZCFGbivYfAJgWtRwxZz09Nn21wtyYael+umHGMWxrU8DCRT1icxWVNuaCzKbel+3UiXiOQtT77Z7tuuTTknoQaxGiEpEx3VHbiuEQWw8OETL7anYjj5xyNoD39iFVbs2e8eLmQ+9vS7PbNM+3DuF138fC1SpwpLcg2RGF7TOuIx4OtCwHdnTKcvlLyFgMxZbXalJkrfQqLtJm6gcsy9EOuMXZObm16Cd1YP79XZOJ68SD0JAnsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB8089.namprd11.prod.outlook.com (2603:10b6:8:17f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.36; Wed, 22 May 2024 06:30:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.030; Wed, 22 May 2024
 06:30:11 +0000
Date: Wed, 22 May 2024 14:29:19 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<iommu@lists.linux.dev>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
	<corbet@lwn.net>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <Zk2Qv4pnSKZBsLYv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240510132928.GS4650@nvidia.com>
 <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
 <ZkN/F3dGKfGSdf/6@nvidia.com>
 <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
 <ZkUeWAjHuvIhLcFH@nvidia.com>
 <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
 <20240517170418.GA20229@nvidia.com>
 <Zkq5ZL+saJbEkfBQ@yzhao56-desk.sh.intel.com>
 <20240521160442.GI20229@nvidia.com>
 <Zk1jrI8bOR5vYKlc@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zk1jrI8bOR5vYKlc@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: KL1PR01CA0070.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::34) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB8089:EE_
X-MS-Office365-Filtering-Correlation-Id: ccb60d34-e300-46d5-d705-08dc7a28a1fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005|921011;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mWgLkmbqvDa6Ztvnz5gXvmWiOntglJNzkRNJfqLtXNIaWXSvW19CW1zRTkSn?=
 =?us-ascii?Q?jDjsXA3nlgvTE9oL22e09Ah94UxiwJ64zxeybdIk0mF/drXuB4Z8C4XsZvru?=
 =?us-ascii?Q?zWcBCQSoZHLAOdBvg+Yu+U2InNFGj6oHg3xc0eS+ARNbPhrFXjBOM/blteXY?=
 =?us-ascii?Q?aNtgiG5ypOcv2hp0q+5SJ6x6eqWYQeEwaWppgWbOclQF3ECgs7+hDXA6Bu9c?=
 =?us-ascii?Q?F9ExcyEF0fzdb/D42w3s8ARlPlgqgL4fOuRxcDfjamWXN1qOAwZgZAzvBAhq?=
 =?us-ascii?Q?bYHQpju4mEqNKnvl2O0FsPGQIYzkMiz0HeGNgxPcz3MWoelv2h7c4Fw/756F?=
 =?us-ascii?Q?0bvyZ+oFxUhVCbT3oVEmzrlk+Pm4uESFkhbXqMzRIGcKnI7P0DIDGeuAlqgv?=
 =?us-ascii?Q?FOO/K1S98ZqeoCjyENp8Drqz/Jhj4+XXYbIVT7a71j3A2Fu4zUkFCZjajoPb?=
 =?us-ascii?Q?4YERcsLCv13bmo8Y9b+NjPdmYf3LFnngunwbSNMPeq4OhIxMDtCCLXc2b59B?=
 =?us-ascii?Q?7EXAAeRq8FxAsK8+Kkn/Kl5fTrcLzpmLh/OYZQcIhqZb2gW2WQYEWZ75lLyT?=
 =?us-ascii?Q?IXOOTMZFid4v+E5aGwk7uNV6Q41cee3bybvmk0FLitJdDlyQmqnvR4ecYIpW?=
 =?us-ascii?Q?PXEYaX/i/NDzcCwuRiFNWsV045tm9TMjQSB5quFOuofdJO2sVAmGvBFpjhuP?=
 =?us-ascii?Q?xduxVO0OXP05HONlPYHS8aHp64jMvQ4LJmdzdGJLTjvZM3QkqpyuuDbsKmnF?=
 =?us-ascii?Q?lgzirgRxQicVc4W1ArpWnY9P73odlEKIgIuK/BEkG372zUHSjoqXgTxj80Pt?=
 =?us-ascii?Q?3GSpS5ckpGsXRuAv1sigkxpz3R2mYvzBNwq8UuJfoOdRQx3ZaEsS+EJc3grR?=
 =?us-ascii?Q?IHR1BniBogStlJH3zBfkk4BR6NkecY5mW5mck2j1A1j5FENQmVRmpOIXGZF+?=
 =?us-ascii?Q?EEJ8J+Hh4+taN5MS7BJ47Rc44Bbo/OepAyAc5sHVmgK/UAU5rZYJmg1y1rnf?=
 =?us-ascii?Q?iFFIQAUsKnd4ckAsdmYyQv97FG4kSBmRnNgdY+ceQ/koqjB8LRQ4c0aK+xv0?=
 =?us-ascii?Q?LXDkK+4WbnEM/j4CI9DNJ25ZYVzG2t0ewTTZ1EFbY8Q3FDfilK2DmCgeV8ao?=
 =?us-ascii?Q?LFh+OVK4fee1Y11a7fvZCp6Ul+koxzTA92fiXRrfTOrb0Au0/PZ6VlMVqCxW?=
 =?us-ascii?Q?gaAGz0/m8/GoELaAQBDpxTWA5l831kbOmQ0RW7P6H5YHSTcEYQEBLCnrxh1h?=
 =?us-ascii?Q?loy3SqQDO16oP3gGnaxpTg8nVbs/6NeWYbRpZShkY+fj75UPnuGGgfvlIqrG?=
 =?us-ascii?Q?oKGJSifQjFY2kE9TBCCGqXb0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?if19Y8x2Uj8iSAi85ylC8988Z8iVuKt7ssSeyI1OhKMl6RkbiU1Nthp1CcHU?=
 =?us-ascii?Q?OOSZHANOkpB+7EGgY1ZAhJw6IcxXP4BfImrviUmquTKE9SPSx2SJC8HOYXjy?=
 =?us-ascii?Q?9ZVGBhRvq6GDHSZLjhGjyQxrVzTNU5fW3oYKYaM5H0gNkWuk1n13ElVJFKxw?=
 =?us-ascii?Q?LzNOwg46F6Si+byzD5qbhZJv99JxfoidvR7Qj0PWu83ur4qdqxMUuu8YiHJy?=
 =?us-ascii?Q?NQRtoUjAyYMa+8VH5XSkWkS6Gc+GGR1+Ud8gzeQooysodbJRTQ64df8D3UV5?=
 =?us-ascii?Q?ozRRQOmFBrNdSlqhU+uMBu1lX0ylGa9BPaCFl9FGg0ptDD2oCMxTi5wUfiO0?=
 =?us-ascii?Q?6V1eOKPhlLq81RP3PsaQ48zQ+5/jsq78T7b7amVXTJte5QpARS65B7Kqiqqf?=
 =?us-ascii?Q?Hx8tR/gxU3K2Tgm3beKsbU9vRMgXoM0Or3UJjTQhyJxEAjLZFud6Iqc4eMhK?=
 =?us-ascii?Q?iQh6FSXPqi04C5MWwu5rxKH5E/Ek3FXpEzEj54JRcG7U5hb07qeTIOTVwh9W?=
 =?us-ascii?Q?oZ3A5s0HUmIqVdCs9Ox/EX7/cjYM3krsRv4/mSUJV6GcWsdt3zwGuC8Iqs3n?=
 =?us-ascii?Q?3OrdsX0rir5C8UOKrzIrmqi326tz3UTIJ5PH7d37He0n81RsO6+Pl/Fr15gF?=
 =?us-ascii?Q?KDN69N707okf4sN1O0WETinn7sSQWVat42T25N+zvtVKrxPFIwognp79gMGp?=
 =?us-ascii?Q?5YNa6KluQ1VjCH9unwbi3/BYs7jlGLuWwDysN4FmIy+zylSStNerKdRSnVsa?=
 =?us-ascii?Q?Pg8ajCjHyUFfdu+Bfbe5T79bLCHrXuy47FWBQZ6r6kKU4/q4Ix4E2YZG2bHt?=
 =?us-ascii?Q?ErHKlCytkzf/gXNkRTvgZEvLS8Piqwo6BhQMlrZP5RwM7UYoaOKU4/XIGVfF?=
 =?us-ascii?Q?qhxbFPtRs//wspPhd67zplr15YcE8gOeIe9fKLwASHE0c0CgRzaw9djkX6cy?=
 =?us-ascii?Q?7ZerEXBL5u/liv3LaBvhdTII9YoAwYq20UcjDCytMzxYJIlss5HgUDug1LNV?=
 =?us-ascii?Q?hO6dQDM6pCAKbeWlV+slX/P8gqukItUogTJnL8hcLWkWS2N/JFujO99a2oV0?=
 =?us-ascii?Q?ox6v9ZFO7BZoP0dtYYgCeLk/ZQbdqd2sPOdcEty7MusQX3k0Zny3Sxnm0bOe?=
 =?us-ascii?Q?1FqLOva0P37iLUQohD4GjTlwnCGp7lswuNK77dhjjF79HjfEPvEBsyfkoMbG?=
 =?us-ascii?Q?i0SbIWeqVh4+feeo3Anl12s6ZmMeDEJdrBR9iWsmo4aKpJUlBFGRBJX4QguA?=
 =?us-ascii?Q?d6/EoySxMcgVyS/Pr162qryEQntzP9BcOaajpOwuQ41+GRdiUReWPA/dsO72?=
 =?us-ascii?Q?Nz0ZsAPxse25IpvM02RHdYxJE77DzGkaDoi3KVlDJrrvZeZbGQ7Ful/uw2gQ?=
 =?us-ascii?Q?fwN1zg9AJ7RQsyeMZWN6FzdCMWG1V2Fkr/nqWn4bn5DgW9v6MsjkdHquD0Ev?=
 =?us-ascii?Q?Uuq1kM2FwIBYFXUFT6MgYYz3WIc/Gllv7GDI9E+9/lf3mPPJ41fwOrfMYs4B?=
 =?us-ascii?Q?7tDTmUjEad5RzLjSyQnh+R0yUMA6QWZPXxcV5qIUyoRKox8Kcu1id+C5iMFw?=
 =?us-ascii?Q?YWeC2pfvYfn4dxY970Z4ncQ/6b76utcd1Uhqiiim?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb60d34-e300-46d5-d705-08dc7a28a1fd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 06:30:11.5884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TF2EgO8QcathqSzDuMsZBx31kiFo2IY8Av3hYt/BPqaV27cDf4bfGIp90yoh23KuUqqu1UhzdD0TVpSAJc8Tag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8089
X-OriginatorOrg: intel.com

> > If you want to minimize flushes then you can't store flush
> > minimization information in the pages because it isn't global to the
> > pages and will not be accurate enough.
> > 
> > > > If pfn_reader_fill_span() does batch_from_domain() and
> > > > the source domain's storage_domain is non-coherent then you can skip
> > > > the flush. This is not pedantically perfect in skipping all flushes, but
> > > > in practice it is probably good enough.
> > 
> > > We don't know whether the source storage_domain is non-coherent since
> > > area->storage_domain is of "struct iommu_domain".
> >  
> > > Do you want to add a flag in "area", e.g. area->storage_domain_is_noncoherent,
> > > and set this flag along side setting storage_domain?
> > 
> > Sure, that could work.
> When the storage_domain is set in iopt_area_fill_domains(),
>     "area->storage_domain = xa_load(&area->iopt->domains, 0);"
> is there a convenient way to know the storage_domain is non-coherent?
Also asking for when storage_domain is switching to an arbitrary remaining domain
in iopt_unfill_domain().

And in iopt_area_unfill_domains(), after iopt_area_unmap_domain_range()
of a non-coherent domain which is not the storage domain, how can we know that
the domain is non-coherent?

