Return-Path: <kvm+bounces-62862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B41ADC510E5
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 09:09:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 388ED34BCD0
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 08:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5678E2F39B9;
	Wed, 12 Nov 2025 08:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jjL40FMV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129222405E7;
	Wed, 12 Nov 2025 08:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762934940; cv=fail; b=ClIdqC3QHQrrbYU0i3UZoYObmwwxChW35tebojKuuxWa3Cv3IA47ky7uzopYtpa7pGsHiL5cD/+9bUMs/K/yTORV2jEG8aZhpaCtln5SUa9b17UCD9isJdqfW3adkH6TUMeGW+LohN0xVIUDEpWAMrRsl25z6i526MJJyRQpKZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762934940; c=relaxed/simple;
	bh=01rqSqSqXGXwo3vXH0uythXNHhCjLY4KRWm64B+RARU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FwtRSAWLbFpf2R9TNmEfHP9qDcocgrAkeh+DcpYyrcTlqG6ZDuO7CU0mQ7lbnWICZZcWDVW8nTEKlxOYy8GVhWqpitcebXz27Uxn1u4cqIKUt43I2zhI9ImI11kF0o8RKh7+9/jtYcKfdtg2Csh/30WuzxLG4vevoVJgZI55Oog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jjL40FMV; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762934939; x=1794470939;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=01rqSqSqXGXwo3vXH0uythXNHhCjLY4KRWm64B+RARU=;
  b=jjL40FMV5JKPbwCBByVqJH4PNfWz/XJtB7o/9+l1BM77kOtLwjeMRDKT
   5XvAU8qsY/eTGaVUIlbotG7bMhyLxkJNPkYQeit9cQD2MV1s0ZHDa976J
   l72Stc4A8vVrCzE09FF9Djv6ekfyW0l2xuj4zNeRHQedcKmyCMrPT9yyS
   pK+AsnVkRfjZRYKPs/bzI7rpp9p9ldiOZHEHanIFoizxD2+fgMKsOIkeK
   1pvwu3+xRAPWpTq+2GeQxKwNgq18S4k2QG7iCL9FqTafzXoiMVYKi4A/j
   K3ccFscD+PieF8de5HrLFxq+o6rGlt2qTwCBmkFhHSbfoFwbpph8X6HTO
   A==;
X-CSE-ConnectionGUID: OsTn9D0nR0mScEPtQTShow==
X-CSE-MsgGUID: OIkYN87PQFmpPbwn2VoPlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="64874016"
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="64874016"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 00:08:59 -0800
X-CSE-ConnectionGUID: fRzh2CsoTeOEcmIaqyXJuA==
X-CSE-MsgGUID: jrRsu60pT6C9Ix6j7Xk4xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="219812630"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 00:08:59 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 00:08:58 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 00:08:58 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 00:08:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3RGjJkLD+r9kSmqrT19I3T2rNz7ul4T2uvqMPzM3eaKTTP1X0KD1ezWEZqG8SAWzXbVF3f/GbidIrqkKXsy6/m/Po8/VsM75itBoNJGKBRiXleXvU9bDSc/LFf1+1vUb3TTwYXAV01Iw+/eTKNKcFmvvVJgm/ywTeo414v549lCovqVrPLQVn2v5guD9QZM71bBHe2WaqL0NnnY4VrlS9dIcaISlDCLPuWi/7Y6nqOZdFdGoV57U0Tz8/JiW76LyBtEX2TH1NAUFJrjvKaPIZ7nZ+/6TM39J5sTNwGJyZ5jAdQh1ShxJcjek3jhIcS03vCPu3goGWBPJ/Io6JE60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YgBfD0nBLuKJlsPwBOOhwf9tL7l6GTlI3ss9mW9BaBE=;
 b=AZpVJiNBSzM7W0TjvbISLYTB5hVyC3Jz7dxv7aqFddVB+Sa3CiqRDmoi0Lza1SQ7UDzRzu2G4lLr+Ohtp9gdftY2uH13eYKEBXhgGE4ezRftZ9FYGEuK3mMsxC8dKW0ymUSYzr9oi4oYZkB+XOeryzmRzObRDQ+aCHxGCHMO1l5MkR0T6vJ1B5d2KFL2vf+nea8UXcZIfi4Lxz2DU8TRQFc/Q5yhjqYEpRmzOkLGRcHw/CzYs4Vj+QSyC3u6TkrCXQbG5HWTTKUuB1+qM5fWDXuVfFTmJYXb3rU684DuqcPPLpkNGWDkhglV55eSW+ih4CWoY7doyese27oqHAT8Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB8162.namprd11.prod.outlook.com (2603:10b6:8:166::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Wed, 12 Nov 2025 08:08:55 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Wed, 12 Nov 2025
 08:08:55 +0000
Date: Wed, 12 Nov 2025 16:06:46 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kas@kernel.org" <kas@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "zhiquan1.li@intel.com" <zhiquan1.li@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aRRAFhw11Dwcw7RG@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094149.4467-1-yan.y.zhao@intel.com>
 <281ae89b-9fc3-4a9b-87f6-26d2a96cde49@linux.intel.com>
 <aLVih+zi8gW5zrJY@yzhao56-desk.sh.intel.com>
 <fbf04b09f13bc2ce004ac97ee9c1f2c965f44fdf.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fbf04b09f13bc2ce004ac97ee9c1f2c965f44fdf.camel@intel.com>
X-ClientProxiedBy: KU0P306CA0010.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:17::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b7df677-8547-480e-07e3-08de21c2b95e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?UL0fGHNt7afmbHQYsVWarh2hFausTknT8GQIcXZ1Bg7AbGYhWpsvU1Horv?=
 =?iso-8859-1?Q?1H4r0Qtk5kZ0Vh40CIjO4zF4C4AE5HDeX+iTdNfBmKe9pmGvGZmHaGkepn?=
 =?iso-8859-1?Q?EwoXOEYFCNu71cpXXITQk2LCz8WvtBLaA3HGtaSy/ShSGf13hET8mMumKb?=
 =?iso-8859-1?Q?XmPDM7vhmUp+xd1jvttOq+W0igJxUJpkz8GOd+GxFna2U20AQqhFlWfzsT?=
 =?iso-8859-1?Q?3Qt02+itSPgt73Qow6N8tHOAYXKygCoirrsY/tyy8PCrkVoZ5Cl9MLSQMc?=
 =?iso-8859-1?Q?6q7/TPpDckZuUD+2PDKlU0Z9r9wf5yXAYAUIksSkR8RHMERD7DN6WA9ggB?=
 =?iso-8859-1?Q?oju/QThmloAkpM03x3UKR7l8P71d+Ge+pCHbEskTlcPHm+gcfdhmipKFOj?=
 =?iso-8859-1?Q?yerjN2fTOdoKmPrqDPQQ2KhHx/v9DNDZUCPoxTvVPDCBsThzNMzNogkz4y?=
 =?iso-8859-1?Q?AMgmZl3nWZoUlA5h9JhGA5F4MeGi9V2FbrudVLqA0M/V1jJK8xfjn7V+uh?=
 =?iso-8859-1?Q?gNx1HfQ1q97zIwedu0ISr/WRZic2ifNxHQCdh2Kcux7fUruoCtMdZ7zHiT?=
 =?iso-8859-1?Q?P5tCOSWRMXCl6e+J2O64esj0Ash1lE7VR5hKWTBcbOLyecD9X+A9feFN9e?=
 =?iso-8859-1?Q?XcAe0gs6VUMNB2DfiFmZmGe2tnu+QDBqf0FWZsTS5m4UD00ArP+We7PQyY?=
 =?iso-8859-1?Q?OtPmQpAWT/LNqkLOI0lFRIPX+/XX8bdi+tN/qQPexBK9SG8EdgOzpnwl0T?=
 =?iso-8859-1?Q?j8QHfdoDfvwtmArJ+0Bn2Ai1fk38AfIL1T9aBkbgjQtfPuf4VsKfzGuBnW?=
 =?iso-8859-1?Q?qcP/YIjLmdKyNVcYpM9JDOv4UlW+8w//yKijIpQFx3WvCAs0yq1E+UChvZ?=
 =?iso-8859-1?Q?ezlbmg8duNvliJ9ss/v8z/jAwKe7BYgyKrxysjOaTp+sPivPA4vx62KU9Y?=
 =?iso-8859-1?Q?lLml8CgIG1MWkMeBqFk8vfQO0HaXVQNx+moTeAlNE8l1mDsPo6nuCKRnGR?=
 =?iso-8859-1?Q?lNCp/0IjGs6VNa++gzneENOTlyTsjWIZmEIt9oJmcURacAdXaLoVZ1crPC?=
 =?iso-8859-1?Q?4+hkBXj47hENQAlhZNhLK+HkfV+zMrntanpb16PzPttTK+blqY4TAnw4hr?=
 =?iso-8859-1?Q?BHboNVrCddy8EnSzziukDnhXZZ4C4sCFUPA8G/Fk53AZeFlxdamgOOfITo?=
 =?iso-8859-1?Q?dc/Uy1KAZM4Iu7ACZQE0RnaKjSjujNHabDA6GOBYLZ7G9OO6ISguXnXsAf?=
 =?iso-8859-1?Q?VOCNZJHAR7YZB3sdAIvtOcUhhRwgvhvCsrwaG3rOzj/b74ZytKy5WgM+gt?=
 =?iso-8859-1?Q?qdqJFoQGmzTvwlRYc6Hf2535/nLWof87FwgYcj6Rg+vbdP35nyqFBb+Ffb?=
 =?iso-8859-1?Q?QXL2nidd8KI357F27a/GpsePtLB0izjzoY2Nh79F3VZHD78NFhZK8mZFTU?=
 =?iso-8859-1?Q?InF523Fum+qRg583l6eMEgXAIjbcFwY9oJF9v0t82DKyKhwLbQC9jyMYHs?=
 =?iso-8859-1?Q?eEffx35m0zUfEJ46ssYHp8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?krieqpyiSmVLM00b0Xlr4ko2oe+iuqUYnHQb/+8BY4wujFXzaePn8lbiM8?=
 =?iso-8859-1?Q?lJydHDsj/fxg27QYT9hjYDSxtCRzwVJuEOTd6ZGVvL5jj3blqadW5VoOpe?=
 =?iso-8859-1?Q?xarxVpLMztIjPy8Z79EOPy9F8Wn0Eabesazn/HyWm4E6Lz7iOyNS6UMq08?=
 =?iso-8859-1?Q?3yW/j3feQoTQEOFtUcar/nYFtaFjJ+KpvYIMwvvsFnOmz7v5gh+QXVCFbD?=
 =?iso-8859-1?Q?FLoe/7wGqiEc6MsD1b/D2/KbnZBm4cGawZky6gHb4uaOYtsFp99MmzvFqd?=
 =?iso-8859-1?Q?6m6DXHpavIfJVet/CMFBU0iq7isx06cM2eLxtRg5fr781XfN5SBtozHixW?=
 =?iso-8859-1?Q?HMLOG4OKjrtxLvcuGWW+ErbOPI07uprwZ6ukmeFwmysnPx3t7vTSrRltQ/?=
 =?iso-8859-1?Q?zkciO3cp4KUnfxjSUxfvR+dBCgRWHbQpIrEtYixE1yT+UEm7YqSpf2WxJm?=
 =?iso-8859-1?Q?2+Wd4CYWoTxcGDhHfOZhd9+vBi1d6ing9XleXttSU4QgvZKtm8XyI7uLzy?=
 =?iso-8859-1?Q?dw75jjNp0SMkafm3vrCY/c6itoTO5+Fu0wYZH0yPcCu8jrjzW4EpQFszKL?=
 =?iso-8859-1?Q?rE6sOU2utnzZN/XijD3pPYnFHBJpBZqVzDyH/9MZ38RECXT8W4UYJjDC5G?=
 =?iso-8859-1?Q?CmEeXnhymAcpu0NtcptqwxM4jQf1B+avjNz1hnWWI/PIeiuTAGkWUVR71P?=
 =?iso-8859-1?Q?3Qf9rfUYxEwLwz5AqDcrBijoUIv1ZmXmCEvnhXmTuYcAOxnwoVWonTqfny?=
 =?iso-8859-1?Q?eeLOjK3xisOYk7qwwdJdFdxcCosk+Qi8b8XhiYZpK0ovSkK7NyFprCXzm9?=
 =?iso-8859-1?Q?wJORhzRMlHijg9zZ/OivnYzGmNPi0CogJXhmti7yuT55Q0Yn9n4gtq0T2x?=
 =?iso-8859-1?Q?4hWOMHMrpFtSC1lDZglhwf+xINwGfMPCDx8z5Wml5xZ/IvK0m5PbvcD+jY?=
 =?iso-8859-1?Q?JqcGV0eaU0QphxZzGjEK2fizYy/80GrZrj6CYaBnT63BVf12aMQodGW/xU?=
 =?iso-8859-1?Q?h6gx0gAYgdM9nsR5lbmFTzOhbjDyQg4x+Q2JpM7/LKLH5MZZmbad7z66oo?=
 =?iso-8859-1?Q?+nB+3J2psq8v34m2tC0GwFH7VdKbMiIDHgmMJ2ziCzoJKj10kKdoEkqijB?=
 =?iso-8859-1?Q?DZOV9bjquKGSC3cvshVyl46KV4u5lM2kVIQTgQV7aVcRaAsMfHg430ZSiV?=
 =?iso-8859-1?Q?hfpa9QXcFdk6rpN31UIGELboPl89xfxA/jdA1rYirIL3audeC+sBnpQe/t?=
 =?iso-8859-1?Q?wWKjqwges7QAhbg7xEHSuLMb7O0slgkQILMKkrwbm0uRb1ATc2W5bywSzP?=
 =?iso-8859-1?Q?9KvoakSVLN8dRrcPIgzuDGmdI4a24fpVXvuGw97WrFl3hjyzX46zsuVOFZ?=
 =?iso-8859-1?Q?NPsx8fCb1mhrYTexZGIFVGr0XtbfcopzmMEFXWl72+wTOm2X4hSEXdaMT/?=
 =?iso-8859-1?Q?iVF3wlLvO1oY9d5Yx0l6/uiRGAylCN3VLwgL+Kc0w8aMO3A4MsHMF6FUNg?=
 =?iso-8859-1?Q?THqOz8bC3mSOchQJTdjFWWnrK6rKXtSKxCPDu16ECztpnOO30d9VYPy/3o?=
 =?iso-8859-1?Q?nizHfFAHvNnUpJ0ocaodSECcOSoHI2ooUDTT6nfxCMmJiiWYX1FYdDgy7S?=
 =?iso-8859-1?Q?ULsaRRGqNqBFYMnZEuSfvtcnDH37cBCxBy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b7df677-8547-480e-07e3-08de21c2b95e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 08:08:55.3296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cgcLQp1uyKKaZ2cW+d3bW7f5Attfbkfwd8w6aW20bHP4TzhgXnDM4NHIDmEM0AtfVdkQqoNQ7Y6JQVJcNrAIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8162
X-OriginatorOrg: intel.com

On Tue, Nov 11, 2025 at 05:15:22PM +0800, Huang, Kai wrote:
> On Mon, 2025-09-01 at 17:08 +0800, Yan Zhao wrote:
> > > > Do not handle TDX_INTERRUPTED_RESTARTABLE because SEAMCALL
> > > > TDH_MEM_PAGE_DEMOTE does not check interrupts (including NMIs) for basic
> > > > TDX (with or without Dynamic PAMT).
> > > 
> > > The cover letter mentions that there is a new TDX module in planning, which
> > > disables the interrupt checking. I guess TDX module would need to have a
> > > interface to report the change, KVM then decides to enable huge page support or
> > > not for TDs?
> > Yes. But I guess detecting TDX module version or if it supports certain feature
> > is a generic problem. e.g., certain versions of TDX module have bugs in
> > zero-step mitigation and may block vCPU entering.
> > 
> > So, maybe it deserves a separate series?
> 
> Looking at the spec (TDX module ABI spec 348551-007US), is it enumerated via
> TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY?
Yes. I checked the unreleased TDX module code that enumerates this bit (starting
from version TDX_1.5.28.00.972). TDH.MEM.PAGE.DEMOTE will not return
TDX_INTERRUPTED_RESTARTABLE for L1 VMs.

>   5.4.25.3.9.
> 
>   Interruptibility
> 
>   If the TD is not partitioned (i.e., it has been configured with no L2 
>   VMs), and the TDX Module enumerates 
>   TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY as 1, TDH.MEM.PAGE.DEMOTE 
>   is not interruptible.
> 
> So if the decision is to not use 2M page when TDH_MEM_PAGE_DEMOTE can return
> TDX_INTERRUPTED_RESTARTABLE, maybe we can just check this enumeration in
> fault handler and always make mapping level as 4K?
Thanks for this info! I think this is a very good idea and the right direction.
If no objection, I'll update the code in this way.



