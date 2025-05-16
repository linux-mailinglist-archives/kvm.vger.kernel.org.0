Return-Path: <kvm+bounces-46758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F00AB9488
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 05:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA91E3A55DA
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 03:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFC022F74D;
	Fri, 16 May 2025 03:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aAnAT+ph"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6AD15530C;
	Fri, 16 May 2025 03:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747365170; cv=fail; b=mQRlkWV5+aol696gom8s4nrzXkjRQ/Dq8p9w81Q71DQ/EiN0Z+EfpaiqCuPmQVyXymADfAHArJZEkYAeFKfup+tf2Dx2nWyOvIw7KXw0JoROaNFsEgpLQDr0W0AA0+8Z5wkWuJS9pXftTINvFWJNqj/ND3fBZCeHUFOqA1Qo2uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747365170; c=relaxed/simple;
	bh=3xbxn38QKd6FliMTZyOdRoFC4f07gUdGU+UAD1gYRW4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PvhjMyimy2K5YU6qocMjEf8iASwnUA2+PvmO/yciBJ0bhVWapkqpi72Ie0eMNQJ7VviCfbA2UJ4E55JgnqbqlyQgdn3CUKhfh8tSOuYwhYu1Ck7ZfNAp4/1ujIOXotYULo/T0cR7YsAn01xqGVUdAPAMa/n4/rH+cI7VhZUnKxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aAnAT+ph; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747365168; x=1778901168;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=3xbxn38QKd6FliMTZyOdRoFC4f07gUdGU+UAD1gYRW4=;
  b=aAnAT+phdr9bcvupFjEIQMEXAUa15HLRmaNf1RuQptlTgC7GLF7WO7vX
   1Hk0sh04n/9u6cGMLtBjO/tPe2JT2v1SujHF3J1rS8py0BJCIzM3Ko7Ug
   DuMOhk68nrSdOReimhMCk2IXOFP9r8DXzs3Xd6sAf728PBX1+uird0rKB
   X7DlNzXoizq5yGClVMi88Nygiw3UnFayz9XbSnFcoK5wcmYLJTMdMGzII
   1gKbp4pE7SzS6AH0um8vfaVdM45/yQlIYacwDxQti2OMgR113NjMSkmP3
   /sxtohLOW37TnnoutxBw88Coc0Caqhtyn9g0pREFHkgvKh55ZdfkvoERQ
   g==;
X-CSE-ConnectionGUID: 5Ev/YQD8RtGCxL9vIaYE/w==
X-CSE-MsgGUID: 2U08ccvjRYCiXKBAZ4rPLA==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="53142570"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="53142570"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 20:12:47 -0700
X-CSE-ConnectionGUID: gKEMl83RSRmhj/uKd7jhxQ==
X-CSE-MsgGUID: EA9GGX19SPefDv+lpJKamQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="138447329"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 20:12:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 20:12:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 20:12:47 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 20:12:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BVmpept+op8adXdAOtVkmdlv2cX8nmuVnm07dbdM7AcOrjKddEC3wAFpFk/nCWTibXOUfRMBbfk+iBzT+FhWEDHpajMPFrpg1hwqYj/RYxe415fILJODfrJFXbQaIWRq6RZQqtgj7kZkSvJtefO4IcY1DLQIZtAjABkusId7p4adS2koFdar4A9jNhIoBK9Lk7ure5WxLvhYdN0wwpq66AvKom+yFss4S7IYyjSMisEuzLOyEOaxS5qt753sxATP23V+SeYkhyNVz2hPjpg5FtVlRcnJy5wwUjDqCjfcKifeuYDLTHTuC8Cta3oLeVmo8fkX1La3e0OoGYjfetgaJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grPsOlj2d0NxC07qPXTJjBBExQ44/YeLO+xjWT+LIWU=;
 b=SOpkl/WNWOgsse/GbjuofqBwsL3olrC0biEKGcbrLjefdq6SQFV1XX8wfbHFJ8FOaEUG5RpCYgT8pJgBYypEF5ggJ1MXc1vwrPLL3y/1hjubVduSMMYrzzPxRDsViKBYKDIHxxdCOEX1h10StoYWRX6BgMGWzIcUNGz4HfX1oEBOtC9xZFdRHjxweRHGlAlRmCNs0Vhmhq6EYDgdyv5HPHcJIaY8Rj7BnotZ/J9RlrdNwrOFKn4TYbJ4qP5dKfIgggTP84PslcqvI5O8LzlAxNYDRQFBsACNDu5SlP1+P6cRFZr0v8rOU+QuBEQyJJ0rLBv4hgKKeH/nRjj0uk5G9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB8399.namprd11.prod.outlook.com (2603:10b6:208:48d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.29; Fri, 16 May 2025 03:12:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 03:12:44 +0000
Date: Fri, 16 May 2025 11:10:35 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 07/21] KVM: TDX: Add a helper for WBINVD on huge
 pages with TD's keyID
Message-ID: <aCasq5TD8n47A4mK@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030549.305-1-yan.y.zhao@intel.com>
 <a3858c57-5de0-45ae-ab33-30e4c233337d@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a3858c57-5de0-45ae-ab33-30e4c233337d@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0135.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB8399:EE_
X-MS-Office365-Filtering-Correlation-Id: dffc5923-0a43-4213-8268-08dd942786a3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?96TaTmshLFFCz67sYNLs2QhXqO/jZPSyRMriOy6ecaD10rDSKWKjo/UGq7?=
 =?iso-8859-1?Q?Sc7t4A23s79iXpAUDPrtCu3DwE9pSMJTA7XZSz27c3Jsoxz9+rTijQTDVC?=
 =?iso-8859-1?Q?+OlyxnZ32BSzuKBG8F875n/cP4tBF8+kCWKhl+lNbe8prIr56iMh9gEHBT?=
 =?iso-8859-1?Q?bur62srxTCcL2u+suo97HZNC4DrfAuMixEYGDLPRgus3M19oEndoQxZAgm?=
 =?iso-8859-1?Q?vQ5q/oyAB2rTTFs1Pb8/fpB8F9NP8GcBnlz5Uuj1Vo0smV1Nh/GRTQDULQ?=
 =?iso-8859-1?Q?2ujAyukR6E1CU9/6urotOhrNOG6GxsgkSmm0z42nTRds+TZ3M4w1JHEhqh?=
 =?iso-8859-1?Q?njSmZvGkk+6ABNzUhR5x5FV4/QIxIyArhKOq5vHHzyDvSXlmSLXhFW8Y3K?=
 =?iso-8859-1?Q?sF4R6ikwWBTQOHJV3Ahyg9hnEvicTWiNgVV8RkSVeWiZMXv8uu1qtT59MW?=
 =?iso-8859-1?Q?38TwTctMZ+7M87fm0SEgWqb7BfseAnjnzHmm24JEuivhEyn2a/m0MWIuYH?=
 =?iso-8859-1?Q?lb/Ep7KX5NtLOADuf3i8UaEG+hZzdo82G1qP2T9uWz8CwynVXKj7hLxR5d?=
 =?iso-8859-1?Q?3p3ZEAzUhFWA/9lgXRtXd5jzaWmqHiKL7cE1PcFHCbx6SqNNIb3GQ6i5cP?=
 =?iso-8859-1?Q?PIWeGF3Ki67rx7SynZDSp5BuJClG4OjH90ZKh+emUqQyDwxm6CWHQN/WSD?=
 =?iso-8859-1?Q?9mOw0atQQ/K3ndDeDV8hJPtW/FXpNfGBxoRiX/KUc41eYRT1IutjAoGdYi?=
 =?iso-8859-1?Q?pjMitGZm3n9zuOc49hUtN+H+cEE9IxNRB9xv6Xy6grGLU6ygIDwSDCKC+4?=
 =?iso-8859-1?Q?ck+qngQe0hmdDo2t+lTt3FxXPQd/as1+5UFriXidOJT7zWcIDMnjAjD3hF?=
 =?iso-8859-1?Q?/uAhmSaMq+t+8MUiZxE121GNANZ5xDlIatx/1J/BLWW2gW78gy1o6+N0Xy?=
 =?iso-8859-1?Q?hcT0vFBlmN5CKzaUtyOeZX5935SoAGMMq89utsBnuLjGOQZx2JluXXfVW5?=
 =?iso-8859-1?Q?QZU6QUZcn/kSJh8OuKmTaoLohrzTIf0gj63/IuRXlZxsUXGx5OYq55fFhd?=
 =?iso-8859-1?Q?ZFurlPyDLWy6kUmqyQg/hAoQ5U/6LckinjGvPzxXHa2AQ9DcBlNmrDelLn?=
 =?iso-8859-1?Q?mGFOuc0CKdRnAc60n+99TjUajQnYolfBlelFY0mjnkMvMcnnxygfZ8b7/+?=
 =?iso-8859-1?Q?NTDZkdB/nQ9mtfOJ0CujPhxSQwhD3fAH0s0cF0onhyrwCgcCZ1/mmNlCKM?=
 =?iso-8859-1?Q?aPWQ7mf9zc++Yr0M5nuEqOEldaiQUQaxoSVefOeUf9zYU1uei6QT3ccffE?=
 =?iso-8859-1?Q?4SD/rx5CUMh6tgU5khgFZ5o4Y/l9bvHWqOFvQCP2KZ2Lfly1iExrfoK+Ba?=
 =?iso-8859-1?Q?eguCnkbwPSmukj56nz02s11g+HcaWLX6Tt+nvnajHt3JKSaA3WgicQ57ft?=
 =?iso-8859-1?Q?XrRiU0NWy+vnDrAooDHULxZZyTwSzQTgnnwooiQxYv0UMCeJ/obebMl/55?=
 =?iso-8859-1?Q?o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?HjLzGZctE7zInzrIF7FOlOVrdMC0zmlZcN9JJF4zNM1ZPQ1Wfb+e9aCJDM?=
 =?iso-8859-1?Q?aZHUCKRqvu5i722eZFyGI3I7nBNIGS0C7eabdf7tc/VUXGiXKbngrf6udB?=
 =?iso-8859-1?Q?+bBS0c9Azp82FG/aukbnhKVPp80q7YeoDAzNKzJNCwW9/8/NZpd1wiEzoD?=
 =?iso-8859-1?Q?37hReU58kqp8jYSBtKqRB/BBOL1CNE48qlOuF0E7+V2zz6RRieYstyIX0v?=
 =?iso-8859-1?Q?NuljjiMgEng5tM0Flr/V5lGweTQT7xEJ4MD0LlMgK7LVU7BXoe/LzMH1+p?=
 =?iso-8859-1?Q?wr+sohWkiV11olTew087fKHWyAr6L/q5za07R+pAzjckQEHa/JNwZV8Du/?=
 =?iso-8859-1?Q?PjTpWzmJS0MhyfiQKvFEve0CDjOSM7XrEabymOukYvk8PoiWy6v50lmfv0?=
 =?iso-8859-1?Q?rNjg9tqxLX08QBAReLHB1enwqIBLtuMT0SwI98rPB+XMsD4IdepFOnCejm?=
 =?iso-8859-1?Q?LeNKc7MfHRT2kwuQe4Fp8RyN6eLbavqwSCkLAO6yZ25SmccI6RpI2a1Ovj?=
 =?iso-8859-1?Q?UNTSGxvK4OswDN7a4JeodClhDJrIn4xJXGnkEFOmTmJp+ZDgevSGZJuFV9?=
 =?iso-8859-1?Q?PUTTtBxHLD6XR2BsnqM7Ag14H2DNRTGC+2nJSdXS2AP0d9Y6g9MBI+1hOi?=
 =?iso-8859-1?Q?gHid6+2is2BxdjehEuQcoFgbCvQNoYXiTUW93emKtEWCDu6NhamQbFLg16?=
 =?iso-8859-1?Q?mrnUztgGEZNpNWRKftRdvRMFjoPkAXEc5MIDPfzLy1nt5PVqI5xOjxAU/f?=
 =?iso-8859-1?Q?qi+HOz2XlNYyLtneBybkpLPR7b66MaFQVS6VqHm4umX4ptUwqa8EEl+4IC?=
 =?iso-8859-1?Q?oAs9snVaq4ENGrcmAC0+JpHZvMmcPIvTp6ZMTusaEGO695/meZICEadDkF?=
 =?iso-8859-1?Q?7FUxFvb/T9poeoREaRnleQxCpU070wA6Ke0aOLmzuzpqwpqv6MzN2Lc427?=
 =?iso-8859-1?Q?hUSc6E3zp+AEOGzdBcnqR8cr3E8LuBFMzz9y68J5GcV8Nr+CF3BBTX3ijU?=
 =?iso-8859-1?Q?SegzxnsBv5vKxmO0dSdpxtLX9XZE0NmcPOmuRvlnd2CG/E/ztjQmIjKs5v?=
 =?iso-8859-1?Q?UfMwrnvSLCDiU5WnXwSYsM39cPdZp5/qoPHZ6x2fV1hM91IbAjSf8e0KMw?=
 =?iso-8859-1?Q?I0Ak1fEFvHi8dJHSe0yvW9Gl7ZZqL4mdZJlUbt348m6Mh6r/kXHF5adTmZ?=
 =?iso-8859-1?Q?iblpuitH+BhnNYhn1c4SrJd5H8P03I9Sy2yE5FZhti7AdahHQTSth8Ul/M?=
 =?iso-8859-1?Q?Yg4ro1kP7pGILRrRPiKGhDEFbUtJGg8sjKJeFJnX+XkmmRGk6Y88Np0Wya?=
 =?iso-8859-1?Q?F/LgGJxIi5B6P9HBJl5jWglAzw/KoWreROt3CPo5iqoJ58RJNbfAa+8K07?=
 =?iso-8859-1?Q?+bPxuWYTIU/Df5gzpMiGmn/glchul2epJp6UwV1/lFkisTFjVcRLu4s1w8?=
 =?iso-8859-1?Q?Krj80tGIxp8Z4ZdQEc3+U9apIw4oXN6nj8Ztwt+vJqr9MvSg+HKfnnUBiG?=
 =?iso-8859-1?Q?DAzZ16me1wgKFrTS2C26D6mYepCI6OjnkWi1fpxbqaa9m0ICeGuq+G7bDB?=
 =?iso-8859-1?Q?PspGTBAg+sRJDBqeOc8qC4rRKJsXUQmhjnv6H1riXa9deHx+3do68k84q8?=
 =?iso-8859-1?Q?uA1L6Rbt8cM1qjzmWHlZMRJxizqm6SPwQR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dffc5923-0a43-4213-8268-08dd942786a3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 03:12:44.1380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gaHzFIrjqb3+4K7/T4O7AYYZUvj59FZLfCrvRyFeuyRzJgR0XwJ2xHKsW98JZjZKl8EhZRKFXTSfs/hcszimQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8399
X-OriginatorOrg: intel.com

On Tue, May 06, 2025 at 04:37:22PM +0800, Binbin Wu wrote:
> 
> 
> On 4/24/2025 11:05 AM, Yan Zhao wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > After a guest page is removed from the S-EPT, KVM calls
> > tdh_phymem_page_wbinvd_hkid() to execute WBINVD on the page using the TD's
> > keyID.
> > 
> > Add a helper function that takes level information to perform WBINVD on a
> > huge page.
> > 
> > [Yan: split patch, added a helper, rebased to use struct page]
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >   arch/x86/kvm/vmx/tdx.c | 24 +++++++++++++++++++-----
> >   1 file changed, 19 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 69f3140928b5..355b21fc169f 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1586,6 +1586,23 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >   	return tdx_mem_page_record_premap_cnt(kvm, level);
> >   }
> > +static inline u64 tdx_wbinvd_page(struct kvm *kvm, u64 hkid, struct page *page, int level)
> > +{
> > +	unsigned long nr = KVM_PAGES_PER_HPAGE(level);
> > +	unsigned long idx = 0;
> > +	u64 err;
> > +
> > +	while (nr--) {
> > +		err = tdh_phymem_page_wbinvd_hkid(hkid, nth_page(page, idx++));
> > +
> > +		if (KVM_BUG_ON(err, kvm)) {
> > +			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> > +			return err;
> > +		}
> > +	}
> > +	return err;
> > +}
> > +
> >   static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> >   				      enum pg_level level, struct page *page)
> >   {
> > @@ -1625,12 +1642,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> >   		return -EIO;
> >   	}
> > -	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
> > -
> > -	if (KVM_BUG_ON(err, kvm)) {
> > -		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> > +	err = tdx_wbinvd_page(kvm, kvm_tdx->hkid, page, level);
> > +	if (err)
> 
> It can add unlikely() here.
> Also the err is not used after check, maybe it can be combined as:
> 
> if (unlikely(tdx_wbinvd_page(kvm, kvm_tdx->hkid, page, level)))
>         return -EIO;
That's better. Thanks!

> >   		return -EIO;
> > -	}
> >   	tdx_clear_page(page, level);
> >   	tdx_unpin(kvm, page);
> 

