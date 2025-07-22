Return-Path: <kvm+bounces-53142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3274CB0DF9C
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E95ED7B5D10
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBC3230D0E;
	Tue, 22 Jul 2025 14:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eSk1GV5m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330682E9EAF;
	Tue, 22 Jul 2025 14:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753196057; cv=fail; b=U78ROf3+gbMHSUJogP3S4+nd0S8NDUVIO93wSm4Op7267nlR/59pMZldo1C/prg85dM0YO10LynowO35ghbJza9sInpqkLdov4P+srbto/j29IRnAYUrgAHDI1FOpQosKpoZA3ccfOOb/tZ1YJCD/rNf0Z/o89vp0PoBEJdxouk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753196057; c=relaxed/simple;
	bh=9htdI0/uEIq1isB49YVyPfYv/D2KSrbUSiwDnQCw4sM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kXXkDBY/JTO4u9/LConf4Mt13BUvcDJOxczdwkYlD735SQdfJkGPTfc1zYIWdErvLP21IjHVvIxFZI5tbaRckhBGGN5Hm6EDJKvG2P0oZhYxY9uCjNck9gRusODrRKP4mlLKcUGNWDxbSMLmSl5e6V7VvSgFxFExX5unMzLeTao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eSk1GV5m; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753196055; x=1784732055;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9htdI0/uEIq1isB49YVyPfYv/D2KSrbUSiwDnQCw4sM=;
  b=eSk1GV5mtO9SXHMWjEa3MYzxmIu3cE0dOyU2VBgNf1quaBD1SEjWe5QH
   AaA1XbKIbDJXh/gv3iaPIJkvIMmYBnSW++CXFQQSNQD0CMUW/xwsbdkgJ
   h3WSrukjzxchvfY1j45CmdPLMID+J2ra2AF00scnhHyG3NpffTmxFbxHG
   aNQRtrCSDnwPDlMiSbDGOwqtx34dOPlkGtbf9AAMH0gPqIldwZ7paNUKH
   GYQnewTkv5/qS3Msj1TC8lJ7tXeC6KHSU4DAlgjpqSB2O40ohBh7H7gw+
   GD6LLOYxsJZeKDFSlRJ2LCbqORUIusngfPJUoU7mPKmjRcfDlQTBjith3
   Q==;
X-CSE-ConnectionGUID: +g9jtW5BQAmfGM9bLoaTfw==
X-CSE-MsgGUID: SLXQeYASSdmFGkSECqq49w==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55565028"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="55565028"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 07:53:57 -0700
X-CSE-ConnectionGUID: P52qnOrLTgaFEfq0L6+GUg==
X-CSE-MsgGUID: dl3CEDI5Q8GFAmAzdAr27A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="182869183"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 07:53:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 07:53:54 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 07:53:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 07:53:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cm56osYGPiQJKtCOujprcsj0xMfBJfx9p2+6C6cIxmslN/Vhc2olZMSIX4T4gxtY2lGXRkHx5neAKzZJE3lg1VMLqjQtVwb4dAgj69BxIRO0DczqhkGBA0TgM99HtVB6tCmIkGXs1//NXF2A8K876U3Y6rXjI3cJy3Pylf1z5b88K5ORB1KB2LW3pZBazY0o9dFISFavKFtSMe4/VVc+59t466pjov/USr3ekhcSqHWJ8YdSkGqHvvLSJFjNVlXSc0p7qBZqcsZyRnhkJt0z5BTWj2Yv9g/mNqhK/yzlqrvblbmJD8ppAB8uUdg1zpZkq5ktQoSytWgFWmVFHUlzzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThF2IkdJWOcTKlBOlhDsip0EwaahSuHS0e5/PZTLDxY=;
 b=d1N9XOG7L526yzG4nW1BTLHrD9aeFNssF6ztghIeQhpVeV3EdHtIM+LUrf1av2eZAofD6174agAixIhxthxvPWaRWxNufkkA0qLAcHVfedngQSsCt/pfUjjfulaUCb9ivM+1wyNw19vDQUWrni//ACDYXacM4/lvvNVRwsIlwYImYx5cIDQEvpYbtF90a0t0iY1UUxosehqzHW7WjdqX+LH/gJ6mZ0D99EbX4CJLLeunQ6p246TntJc9A6s382hXf+kiwa92Sx27GkvvU9K21n2Dm5z486kFMsi9WPLNqyeJWFcxBUmVbWJ9r7iuim47lum/Yot29+gXTWUFZhXoZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 DM3PPF529E923C8.namprd11.prod.outlook.com (2603:10b6:f:fc00::f22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.25; Tue, 22 Jul
 2025 14:53:08 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 14:53:08 +0000
Date: Tue, 22 Jul 2025 22:52:55 +0800
From: Chao Gao <chao.gao@intel.com>
To: Kai Huang <kai.huang@intel.com>
CC: <dave.hansen@intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <x86@kernel.org>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dwmw@amazon.co.uk>,
	<linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<kvm@vger.kernel.org>, <reinette.chatre@intel.com>,
	<isaku.yamahata@intel.com>, <dan.j.williams@intel.com>,
	<ashish.kalra@amd.com>, <nik.borisov@suse.com>, <sagis@google.com>, "Farrah
 Chen" <farrah.chen@intel.com>
Subject: Re: [PATCH v4 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Message-ID: <aH+lx0vJE5KA7ifd@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
 <ac704fa28a814b8ef5cca14296045c14b1fdd5d5.1752730040.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ac704fa28a814b8ef5cca14296045c14b1fdd5d5.1752730040.git.kai.huang@intel.com>
X-ClientProxiedBy: SG2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:3:18::22) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|DM3PPF529E923C8:EE_
X-MS-Office365-Filtering-Correlation-Id: 2db1240c-7c6b-4228-ec2e-08ddc92f78b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ONdtjfKX2/91YfLKNMMJSSilduyvM41/L+6tFdHZWJQE+5sHJbgSjWmx7HT3?=
 =?us-ascii?Q?UWsH1FmK5TrwFaORFZaXpBnyNKuSknMUSdJIn3XJZUCc/DTH6j0jX9bRI8ZZ?=
 =?us-ascii?Q?917x5mmDAgO0g1jszFTlfB1xhAkbTFm9s0I5pYM86+wpTgUnl09u0wvuS35K?=
 =?us-ascii?Q?Bk8jWpWLvl1K+v+TYHsA7iQPxT9gtSaDKmQ5QO/1TGVO4E4tTCe2HgM5DFhP?=
 =?us-ascii?Q?P0EmU3o3wmtRA0TVxvHaztbn2bqLDY98RVCvTrgstLmw1pkyJCcQLVr/Ke87?=
 =?us-ascii?Q?UobR6BdGyRJ5Gs6R0uX92cEvBnL2okFseA2WiLMWV/v59uWqGNsOrIgutEjG?=
 =?us-ascii?Q?OWbGqq16FsAs+IyLlAfJPbGUFk2qLDgy1uSZEnWgF/zcivAjoJdweiX2l+TO?=
 =?us-ascii?Q?P3MR075TNq2aoYobicfdgHyJyBhcj/hwkdnRpv2YhbnnvJIEVxlx1EbA1+Jx?=
 =?us-ascii?Q?/wk1dRLXm8UuJjqMsD4LyOJwVIcqDBuQeexfUvmKY247IDI24hU8w8/2pCLQ?=
 =?us-ascii?Q?lEF8l6AVjwpG3knMSGKISSnRidjmee4eed2W/uStf+i8oPT/QsSRlB2DJMQG?=
 =?us-ascii?Q?2cIC3rNpU3ISER1fFRxuHmIqqOhruVMUxjGNhwFX7Zn7m85BqhjXWzi8k3hi?=
 =?us-ascii?Q?FgPKa5iC+qslTFN+7bZ5ISToo2eI7Of5qKPUHLLUrZAlf3EaXpEGLAZa4wyK?=
 =?us-ascii?Q?Yp1OLGL/w/OkymTPINALsJ2Jdm9KSUGPnFSBKyajWO8VMKCoxbB+G1M9ioq6?=
 =?us-ascii?Q?U+pd2Hj4B7NovUezF7SyQyLCc/d+K6i91Cpzluk3OhJPCr95ChtEb6/CSwgy?=
 =?us-ascii?Q?E9UcAzUEhjAOAc20ziczOzTyPGmcCAK+m6qcs/GYCFEMp/sdy0n3Xlso5Rg9?=
 =?us-ascii?Q?YPKps6vT/Gc4h5fEwHfHpJ+03IT6f2+eQjzjmJ8j0Ql4vZa4djs899lYL6wy?=
 =?us-ascii?Q?wubns0c7ZNB41spj3KV6GS3VQ6Cc+r3jNNrME6NZjYezypem9yH3ErNva2Cy?=
 =?us-ascii?Q?iu+88g1tq+C/cKyGljgucnE68hZ2CF7w2mBZ9frap8QFUotKtnSNB7zpAiFc?=
 =?us-ascii?Q?yjY7QTlJDhpyf1assxeO8JzHS2HPHQ7MUiMlRcGQAqIHlxsBYm18dKpkPaxc?=
 =?us-ascii?Q?YwDLr5+x//DhiOX2lWUbTsGyz462EnnOScr6CPc+PBUyQ+zRTTLSI086P8wV?=
 =?us-ascii?Q?laj+77EmwjS8l8lCJi7DklqqrlVK44P6U1t97heMfVS+PEtIqCvQfJAplrwY?=
 =?us-ascii?Q?oSbJCjjyG+qwdpvmKqzT02ZeV1pZAdGlflLPNF3FOWWKtq/fBiHSMHA1Pbnr?=
 =?us-ascii?Q?83fojtn8kCkNVirSZzEH7fk2tD4LR8O+RY62OTWoNnMYPS4EMmqiDEbrr7Xe?=
 =?us-ascii?Q?6jhSG4xCwdU943N3jqumNUz1AFsXF/LgJuL30GCqdNcBbiRn3Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g+orw7o2OGUxb5kKkzULVps9NH3DQDtrqXVHIAfWbaa4+VZVsWu8RDQTM9e9?=
 =?us-ascii?Q?geDNAHnzwrchg2h3Ss7KZrcW+2RuO0Jg0CVD13sJj/Y3xOE80egaCSzCs5Yy?=
 =?us-ascii?Q?M+AZ5s2pIHjnCDdyszVnQDwcx1OynxXA/ra2kmtGXTmHEzru0mf92Bmm1YhR?=
 =?us-ascii?Q?CfmlxLz7JrHrnPx8MgqwyaeEIvAIDclxk8Qbon0F/9qep220ZpMnQUgqeTK/?=
 =?us-ascii?Q?/0+I56x0kv1KZ3yuV27xybXXE4YT+LZ7V0aWUSE6uW4VYH+miSmaSW3XWZv4?=
 =?us-ascii?Q?Y75kni4MApX7wXWkQV4K5IA7toJBVTcz+3FXxKzwVSR7AivawRSf8QWf3BJ7?=
 =?us-ascii?Q?yimxtm0IfkJnhqN6vBuNE2CXC6RSIAlt5dcEI2nAp70nfNJRvxTTqlvJNEri?=
 =?us-ascii?Q?OgINldJfX5M0Y+URBLm/fu8CnW4Ol3+RxBlpWagNgB3efaMb21DOTKZpRQms?=
 =?us-ascii?Q?zfMdxljHrj0rfhA+7mjv4IXVqUHbrO96ZRW4TLbEYALvO0MiaSDGMYBJF1pN?=
 =?us-ascii?Q?WtN+AUodTB6nDnVLrLJxnj/KdtByRfYmJwLmn2RfTYFZsGmcGPgGSS1dsI7L?=
 =?us-ascii?Q?q9XwMT/5qffVQ2Fb4g8X9tKL3+pik4FQX5AlXXmH+bm7VOxW0wfkMGfNACMx?=
 =?us-ascii?Q?IFjKmQ7N8MRhiamfO+WztNS1dzufTdln4a2Q4pwEi7nlQ+4Lz0MtsfNbvCRx?=
 =?us-ascii?Q?YdPqb99W7+cQfmic/6rXZmKvS7OFh58uxlppBZRxX5iXDIp/2HTBybZg/P57?=
 =?us-ascii?Q?SpTTds31QtgjXCmExo4fwO4AjUJropbTEavIPIV4MM0Vw55f8RhTDtIhgK8Y?=
 =?us-ascii?Q?6hLHEclmEvVn71vb24ZQNVcBMxNPdDpmHEKZrgpDQlXe05dr6V6/5+U7lIi7?=
 =?us-ascii?Q?lg2v889LjKxP9eHMb6yU9P9P5+Km7svuLW/NsardRTMt8EiQ6vJ28ma2uGKa?=
 =?us-ascii?Q?KJWLNA3TztaDy1kq4TIbO3TTmlCgGiBujizf7tBnw6IPxuoAoUKnfnvHHTIa?=
 =?us-ascii?Q?myPiAnLU06DFLqCn5dba32kYL5uijTK0bV0kKEVG9u5muVuvIuzbLEPSZQMu?=
 =?us-ascii?Q?csxWcsUgaMoJNrvq2LLHE3mEFo0mROWyzc6MUhO8Xc+6PEGdvqMD4efkeY2C?=
 =?us-ascii?Q?HpgpMb/4sjbjQSgTw0cfBgDgLXbfZ8vgg9lg8btI5OVbYx1pMwKooxUNFVdZ?=
 =?us-ascii?Q?tmlEm1JPWjwtGetbecuKgffXmGHmcFzhUZadQxsxdoZ/23ckPIroLQr/xZkL?=
 =?us-ascii?Q?laVJYTqXoasnBbGltLKvg6BRd/7MIC3qD1F/EVC4WpysEnvsE1PyZaD6Bryv?=
 =?us-ascii?Q?ewf0/om1OWirsAcbMU9I9hTsD5vh0vHwpAeIjWrMm5b5OSlode8Id7UCafa/?=
 =?us-ascii?Q?lf9AF7gxAB9839qT6S1i9TRrYYC3/oSvGMJ/nIW8sW3QgBkoPfxbhF42AfQh?=
 =?us-ascii?Q?Flw2K8rybDKC7fYplvTcQxF427Dzs6VPL6r03mNzbO2OlVVE2yK1z2h3/dxX?=
 =?us-ascii?Q?m9yIASPAENRZ6lAFGT/9pDbqvOhbQBNa7kShCwKwOXGLfeAXlYYVDphBoVqk?=
 =?us-ascii?Q?+lSA3FC3pxyH7oiDkOvQaWAXffvXXh9gw1M/jp8I?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db1240c-7c6b-4228-ec2e-08ddc92f78b2
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 14:53:08.4609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hCIEaNI5yKuczmTdhUtFcR73Jv2ttCRE9rwtSxF2t/ydFoWdJjmQiZSD93JpTyJBNSjIWYjLtymeKVbHykuDrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF529E923C8
X-OriginatorOrg: intel.com

>+static __always_inline u64 do_seamcall(sc_func_t func, u64 fn,
>+				       struct tdx_module_args *args)
>+{
>+	u64 ret;
>+
>+	lockdep_assert_preemption_disabled();
>+
>+	/*
>+	 * SEAMCALLs are made to the TDX module and can generate dirty
>+	 * cachelines of TDX private memory.  Mark cache state incoherent
>+	 * so that the cache can be flushed during kexec.
>+	 *
>+	 * This needs to be done before actually making the SEAMCALL,
>+	 * because kexec-ing CPU could send NMI to stop remote CPUs,
>+	 * in which case even disabling IRQ won't help here.
>+	 */
>+	this_cpu_write(cache_state_incoherent, true);
>+
>+	ret = func(fn, args);
>+
>+	return ret;

@ret can be dropped here. Just

	return func(fn, args);

should work.

And tracking cache incoherent state at the per-CPU level seems to add
unnecessary complexity. It requires a new do_seamcall() wrapper, setting the
flag on every seamcall rather than just the first one (I'm not concerned about
performance; it just feels silly), and using preempt_disable()/enable(). In my
view, per-CPU tracking at most saves a WBINVD on a CPU that never runs
SEAMCALLs during KEXEC, which is quite marginal. Did I miss any other benefits?

>+}
>+
> static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
> 			   struct tdx_module_args *args)
> {
>@@ -113,7 +138,9 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
> 	u64 ret;
> 
> 	do {
>-		ret = func(fn, args);
>+		preempt_disable();
>+		ret = do_seamcall(func, fn, args);
>+		preempt_enable();
> 	} while (ret == TDX_RND_NO_ENTROPY && --retry);
> 
> 	return ret;
>diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>index c7a9a087ccaf..d6ee4e5a75d2 100644
>--- a/arch/x86/virt/vmx/tdx/tdx.c
>+++ b/arch/x86/virt/vmx/tdx/tdx.c
>@@ -1266,7 +1266,7 @@ static bool paddr_is_tdx_private(unsigned long phys)
> 		return false;
> 
> 	/* Get page type from the TDX module */
>-	sret = __seamcall_ret(TDH_PHYMEM_PAGE_RDMD, &args);
>+	sret = do_seamcall(__seamcall_ret, TDH_PHYMEM_PAGE_RDMD, &args);
> 
> 	/*
> 	 * The SEAMCALL will not return success unless there is a
>@@ -1522,7 +1522,7 @@ noinstr __flatten u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *ar
> {
> 	args->rcx = tdx_tdvpr_pa(td);
> 
>-	return __seamcall_saved_ret(TDH_VP_ENTER, args);
>+	return do_seamcall(__seamcall_saved_ret, TDH_VP_ENTER, args);
> }
> EXPORT_SYMBOL_GPL(tdh_vp_enter);
> 
>-- 
>2.50.0
>

