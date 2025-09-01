Return-Path: <kvm+bounces-56394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2B8B3D626
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 02:40:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 103F318973EE
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 00:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740051A840A;
	Mon,  1 Sep 2025 00:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BJp993Ic"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81522868B;
	Mon,  1 Sep 2025 00:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756687218; cv=fail; b=QZoV0O7IXsRZxz7yS5Kd8gpt+pBQUVNT3r9cNPX2/ZAn47rpYYLkfxm5hdgPn2OA96eW6cCSkuTakcluQWkWNlFS6ZCVQ1L0pKjir7bfL99G6vxshebDfSqplo3n+U6GPL77UMgiSwxiPgjXKjJQV+5YpECur2tTK7gYPbD22ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756687218; c=relaxed/simple;
	bh=mpqEHCDzpHEloMDhBJWQIvzNna7fGNEPjejH0pPKwpU=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gXebI323g3oC41U0tx5xNoz9HotbSP8U0sz4DWf9zxaSVhTskuyfsFq2K804uIaXwyvZQ5tJNfDX6TvHc5+mnqOTSiTpyBqptrWUVdOW+kYmZKl2PyMSTvmXviqiccy7fMF65pL5dqyEF9xEqyD5JJbvTWMcy/KtV90bgZPF8Es=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BJp993Ic; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756687217; x=1788223217;
  h=date:from:to:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=mpqEHCDzpHEloMDhBJWQIvzNna7fGNEPjejH0pPKwpU=;
  b=BJp993IcNIMJL82IwsO4YFlNh+0H+zFdIJ6dxGhSxcf3bS31oSu88YWv
   ewW7GPOooK/KVHTUkbN+RM5m3ZYkf9AmHH3NdNhuuNWqi44z64+XJYrm5
   SZ8iHgbvpnEUv79soJRl38TMJF5jCdeIvX1PGBYscXOWtQRIxf31rBBjb
   pDu9g5XByhHR22SoYOpkzcuAYWker+YXz7H00fS5gUXO4c1oJ/triFohE
   tdkjWV2dTnivGQY6Ii+vxFb+VpeGyW5KyZgeowA05eGpUNNZWZqw8CvtB
   UX6YWhhWbuCvUpmffJsrXnw/U52ObqS5dUEfOKUGWxJv0L3RlZ13GHebt
   g==;
X-CSE-ConnectionGUID: ztzfffCmQX2Bk2nMtiGKAg==
X-CSE-MsgGUID: Crj4sm8uSv+q6Ocl0wSoXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="62697673"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="62697673"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 17:40:14 -0700
X-CSE-ConnectionGUID: YuakJQ3GQ0uz0uii1FyPAA==
X-CSE-MsgGUID: srLt8a91TbW1py9iHQaIlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="170728463"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 17:40:14 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 31 Aug 2025 17:40:13 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 31 Aug 2025 17:40:13 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.69)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 31 Aug 2025 17:40:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2FQ1Y9Il+gSz3Edsv17KypgkYkURr5F9VBV85AUxuvdtI1rEyFnBBOVz1D3Exv0u356W6LIeOSCynPUkp/lIWHl80Tslq7uYNAe7fL60E4IiXw8F/+WZNGXQUgSN48xLllwKHc/PDn3x2Ev4vjkQTb/RuPgA5BGSgb2Nr6vuePbQNtZhAu77zA0KbDw3vBqcqFX7dJPmEDRADPoRRndemQPyBdCcE7QkT3Z4rPWeeNExCnsDoat7h1Mz1AoPTmS8dEGJrQhvAk3rwVzbMFZiNNrsguGIcIRCxZIPI+558PbmUotgje/MmLSERDs1FvZig+MohlXIjuog+V05UgiRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W76UdnVX1AtS5h0kpSF96BYtylhMpKwb20wJ39cECEw=;
 b=ldW6JDHgBJwQI3rb4fQTTCILgyd8wPWYoaL/yNQSZbSGG5I1nAY+vDyYsXaV1GqjaKdvKKf0If/JBqR3tTh62L8SIV92T5hMT9Bpa7nRH7hAhLe0t/2GygcIVu20y1ryvxPRK7XKkgPeZ2rbI/jtsln9dBSk9CsiCh17vO5Kcygqg8ybIQ3L5Vj4VopLrMY0NfCuj8rN9ufat+C5San+uo+iRRoWGcs5jvxABYzctSPEMbXbrF0ESsl9IIvLklQbg+7hoCDkXIbVimtbebvmuEvpixaEJYQgVeaPw1QfDyKbXafh64/nZXz0KJCaNdt3d9TeYMEDtij7iQPWXQaoOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB8272.namprd11.prod.outlook.com (2603:10b6:a03:47d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Mon, 1 Sep
 2025 00:40:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Mon, 1 Sep 2025
 00:40:10 +0000
Date: Mon, 1 Sep 2025 08:39:18 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Vishal Annapurve
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Message-ID: <aLTrNpsdN6KMXjzL@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-3-seanjc@google.com>
 <aK7BBen/EGnSY1ub@yzhao56-desk.sh.intel.com>
 <4c292519bf58d503c561063d4c139ab918ed3304.camel@intel.com>
 <6bb76ce318651fcae796be57b77e10857eb73879.camel@intel.com>
 <aK/1+Al99CoTKzKH@yzhao56-desk.sh.intel.com>
 <aLCwpNygeC64Bkra@google.com>
 <aLD/fy8RK3u+z2Lr@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLD/fy8RK3u+z2Lr@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2PR06CA0015.apcprd06.prod.outlook.com
 (2603:1096:4:186::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB8272:EE_
X-MS-Office365-Filtering-Correlation-Id: 0268a5f2-de5f-4ac0-797c-08dde8f01af2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?DgFdB+/j0DMvpgiqEMvMg9IpAZDWMySnWMQbs1EdnVqU+TiILzR3iM3yto?=
 =?iso-8859-1?Q?rs2UAGfpWd8K4cfezP6BUfy3jPzDv/NjSzflBeCzo1h2OCtFJkB+ZCFUbh?=
 =?iso-8859-1?Q?p3mtzy+9H4dUyAM413ygEjKor69lqT44jd92/j+KGj6Be6zMtHmKM5YpfV?=
 =?iso-8859-1?Q?vT2BGUBkaYxRCpwKaTkO1VdfWTOjbku8tZvhDottoK9dn2ZLDNHaoslK9E?=
 =?iso-8859-1?Q?iPy9uIuRCgNnjTXDzG543uNknPR3n3rdPif+UKatonb+dudRP9mhbo2MTP?=
 =?iso-8859-1?Q?qhw5UDR861OqwDiVm0LGhjZXtJ4D0hlSlj/QdDAfCNyjkd5Q7Qu1em3rb5?=
 =?iso-8859-1?Q?+au0K4LJxpRnmpRtPBPMWlkMqAMHIOnX7lx90q/yXKqBucRqIG+mZzLgsj?=
 =?iso-8859-1?Q?sXbvvyTmHYqZ5GoDj3ttwM+7ZU6yo1Qi5fHR+S7bYGyknrb5CoVYkLsvLO?=
 =?iso-8859-1?Q?XJ8Rfr9k2SwXIbUKCIqYgeIlTXES6/IdcIrIMRP5oP9UUAI+IAbN2m4bHM?=
 =?iso-8859-1?Q?7/MEIV0dBIUKMk0hhI5isHHhN3Tvh1ajnXVq95hAaSXFYzfUe0awqm8XaD?=
 =?iso-8859-1?Q?tL4tQorYAqPAk1NVthuWJRRB3zKSyYXx9ueA5XmBbLXTOHkcLKEkW9zCI7?=
 =?iso-8859-1?Q?zOzKG5KLePKp0FsJcgmcwPfxgaNcp55Pq7mvbvmzBURlURFkYrUNT68fIF?=
 =?iso-8859-1?Q?enwvzLjs38lfaM52FK7g1lAtBqML3UbqedIb+Xd2sP/ow9/ND3BAOtlgrm?=
 =?iso-8859-1?Q?iyWskdBzG6qNdju0BN3bf+HxspNwhlvCrXhv+042D/gI6bJ3So8/9dqYMo?=
 =?iso-8859-1?Q?seWgMiazxEzNUL7WKqXeEIz4ZzoTzHKtIne5PBQ0ukpfLDMX6a9SE4QtVk?=
 =?iso-8859-1?Q?ZMxLzAO5EViHNaJxQgTWw8PVIjNzS79sDmZOQxba3Mt/qW+nDVYTG5lMG5?=
 =?iso-8859-1?Q?u+8DOdr4xBkHHmoeMlGD9vCbnSPqGeIRJnUxFYSHsThE9ks2hkj7pjOGzF?=
 =?iso-8859-1?Q?BZnvWsVmTPSKWGcdSu6WZ7oXuaEr9TIGeV0TsCsU9fc6DAyaru7Ukemap1?=
 =?iso-8859-1?Q?ZqNXBn30nILnJR1SqTn6x/eqFlAZ5fpXqA8JBOPeeznxaKyvyPnNTWrak+?=
 =?iso-8859-1?Q?uUJhHhnYhau80CFFpXh7eaQCv32AchIPc0E+u/hrvhKY2LuE4XMREs0FAu?=
 =?iso-8859-1?Q?/dCwfeLcpmkWRIgaUAuunRK5bVS/vJ3EVGEeKHbH0RtWsGyyvrMeHvzK8+?=
 =?iso-8859-1?Q?1BlNsoYw5fDFwIlFYWs1H1HW6nQsgNdQatwoi+J3heLUxECNh3yGrGcdxc?=
 =?iso-8859-1?Q?B3iOBCuvCBJd993NxYCFjTKhubEN9oKdkPn1xw1mcjaIzbrUmbJlCFZVmV?=
 =?iso-8859-1?Q?Y+X/R1WnSFjD9/Xv4Pu18Sgs/aoFNxDtIUc0RNWrE51Id5VYFWrxMAblYA?=
 =?iso-8859-1?Q?BIZ38S/kDsZlR1WvzVlBUBp72qgOUfan5oc9ICetWpxxatqlWoNVEvHFaG?=
 =?iso-8859-1?Q?0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?NcAhrEa8y7Ps2HiVee0X1FeDGEIF6Z3JHyH+HeiLu3EcfKsTIR+r/XlpMK?=
 =?iso-8859-1?Q?tb3kKD8b7wEePWFEKBL8tnkJqdtYp0TPFMsMm1LLCOvoo815UUlccGcUH3?=
 =?iso-8859-1?Q?uR9TikQA2z/2+zKTzwlPPSQukS9iGtLFwlr27NDHTT7iSyS+cUnXwP0y9k?=
 =?iso-8859-1?Q?4uA1tixlYm2EiKQrR2d5ObiLRTBtoO9RCO+Rz6QmGZf9b2FeirIZprfk/O?=
 =?iso-8859-1?Q?+fXEad+tnfp+BUbp/bi7uxVJVW1720h4VN02763tmlCz8h46xat6IUhwLF?=
 =?iso-8859-1?Q?Dz0hvMHNBwP6GBZ7Ih2APSxNasCa270WCIaWZFDWmkygBD1mi13mz+MMn/?=
 =?iso-8859-1?Q?QJesRPem5wR5+jKhdmiryem/EnIUZtVAIVwUpjb9EmVuBhmB62E3DlC9DG?=
 =?iso-8859-1?Q?ywI1ZDCW/mktuq0+0iFabo5v4d/lR6/trEcTFafl/my5rvw3tP8wGVqTi6?=
 =?iso-8859-1?Q?m+OOHXCv5dp64Nq8R6MS0jIfkAiqkSIUqzjnVlaOVm2mG1/4axaCl62yk7?=
 =?iso-8859-1?Q?hb5/uQ3Q3fR1Gj73m28x5blWr2YaxTFFrediPlZT9ja7iqqMQPMralaa1F?=
 =?iso-8859-1?Q?p+/mWVZ6Neim2EXwBhFmExx24fkSqpZ3YnXy2SM4G9opibYTQOgetb9yfL?=
 =?iso-8859-1?Q?j9zlPt+EZKMKa01BlvcVnofL93r2pJa6DnUWvCKcGHBt4Ny6Bu/bk+PXIt?=
 =?iso-8859-1?Q?eTw/8HVKLocW1I1mbq0tbhgYivQdZCgZyfHmzJE1CatscC8mjp2kT9oSKp?=
 =?iso-8859-1?Q?yvjPk/09XFVa3z2GfW7rbyjpdkPJIN7ueFnUZRnO+MjMtjlp59YVx3CXoF?=
 =?iso-8859-1?Q?LGqplzMcAFRDdWMamK9oOmymrKaPg8yO3JYD4R+QvNLT3gj0RVFRE24K13?=
 =?iso-8859-1?Q?lms1WSv8Hsq4dVATsENuUQPmkWxsLGTdrEDYJqwoyfihCGJGxZWrvdfHhX?=
 =?iso-8859-1?Q?ChUu49jQ2xrccSUl7zQBqhHDWYiz2vkJdR4lsHF03d+V3c84RHzNln92Ja?=
 =?iso-8859-1?Q?ac1vH7fTeUIiXCf6KUk9vGM/OAbEDPL028Wbi0yyEMTuO4qMzFobAmjK7c?=
 =?iso-8859-1?Q?7ySNcgg99dTHNDo6KOz0ns6P0wFwtZjD1Ok7S1i1RRW2rmPl8mczXZfQpC?=
 =?iso-8859-1?Q?ekwuDE5/BP8oX/Sz5f/fmsG9pxX426M1gyduzk9sgXysDLWCjeFfzsWW7b?=
 =?iso-8859-1?Q?AYwfWEoCr89IZfXEme+bYsy/uoqsjKZe+gZq0AGkJ0SABzp8ACLhGYxt2W?=
 =?iso-8859-1?Q?G/pkzzGHYZRNrMS8dYHnirKTGqAsmOgfXLCacSFPFTRvt5uamXDXADzY6L?=
 =?iso-8859-1?Q?icO4tWw9HLtYe5jj5dJsHi8y3c7+l+B+MEs7VxwpL36vofEl1JwIv8tOYY?=
 =?iso-8859-1?Q?5NWSgjhYY7V/QjsI5hoIvzpZ5G4QcZ3soKBEQ/OPMj+QasRmBPTW5H32EM?=
 =?iso-8859-1?Q?6dEmyIoDE64/D8o+ykKARz0yDRr0z0xP2O9NJmyc0wimyJ8pZkLFtwgG6X?=
 =?iso-8859-1?Q?f3na2y3AocY2pxxYvoPM+bsG6YW84Dm+/mAttsvGWyC+yxWQDwEBPp4Ud6?=
 =?iso-8859-1?Q?5yAPRNg5FxuX5MnOxHZ4Lpd7cCFaqQStajjlsVHs4P/mIS5CXjZW3rVC6d?=
 =?iso-8859-1?Q?+8yIOVO7v83cJsyx+jLMq7FtzXg8y7jSaM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0268a5f2-de5f-4ac0-797c-08dde8f01af2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 00:40:10.1481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oHl09IizJdh0wBlynH94CY+wlW8mzzDqANMWg3vLn5JQBGxh/PY6uP296OXQreSj2qcW1ZnZf9Ee/eA0oGsTnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB8272
X-OriginatorOrg: intel.com

On Fri, Aug 29, 2025 at 09:16:47AM +0800, Yan Zhao wrote:
> On Thu, Aug 28, 2025 at 12:40:20PM -0700, Sean Christopherson wrote:
> > On Thu, Aug 28, 2025, Yan Zhao wrote:
> > > On Thu, Aug 28, 2025 at 09:26:50AM +0800, Edgecombe, Rick P wrote:
> > > > On Wed, 2025-08-27 at 17:54 -0700, Rick Edgecombe wrote:
> > > > > > 
> > > > > > Then, what about setting
> > > > > >                 .max_level = PG_LEVEL_4K,
> > > > > > directly?
> > > > > > 
> > > > > > Otherwise, the "(KVM_BUG_ON(level != PG_LEVEL_4K, kvm)" would be triggered
> > > > > > in
> > > > > > tdx_sept_set_private_spte().
> > > > > 
> > > > > Yes this fails to boot a TD. With max_level = PG_LEVEL_4K it passes the full
> > > > > tests. I don't think it's ideal to encode PAGE.ADD details here though.
> > > > > 
> > > > > But I'm not immediately clear what is going wrong. The old struct
> > > > > kvm_page_fault
> > > > > looks pretty similar. Did you root cause it?
> > > >
> > > > Oh, duh. Because we are passing in the PFN now so it can't know the size. So
> > > > it's not about PAGE.ADD actually.
> > > Right, it's because the previous kvm_tdp_map_page() updates fault->max_level in
> > > kvm_mmu_faultin_pfn_private() by checking the private_max_mapping_level hook.
> > > 
> > > However, private_max_mapping_level() skips the faultin step and goes straight
> > > to kvm_tdp_mmu_map().
> > > 
> > > > Sill, how about calling the function kvm_tdp_mmu_map_private_pfn_4k(), or
> > > > passing in the level?
> > > Looks [1] can also address this issue. Not sure which one Sean prefers.
> > > 
> > > [1] https://lore.kernel.org/all/20250729225455.670324-15-seanjc@google.com
> > 
> > That won't fix this issue though, becuase @fault will be valid and so max_level
> Ah, right, I missed that you composed a fault...
FWIW: after reviewing it again, I think [1] is still able update the max_level
to 4KB.

The flow with a valid @fault:

kvm_mmu_hugepage_adjust
  kvm_mmu_max_mapping_level
    kvm_max_private_mapping_level
      kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
 

> > will still be KVM_MAX_HUGEPAGE_LEVEL.  Which is by design, the intent in that
> > flow is that KVM should have gotten the level when getting the pfn from gmem.
> > 
> > IIUC, this particular flow _must_ map at 4KiB, so I think forcing PG_LEVEL_4k is
> > the right solution.
> Forcing PG_LEVEL_4k looks good to me.
> I was worried that SEV might want to use higher levels.

