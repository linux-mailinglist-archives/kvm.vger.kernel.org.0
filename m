Return-Path: <kvm+bounces-69186-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ABy/EF00eGlRowEAu9opvQ
	(envelope-from <kvm+bounces-69186-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 04:43:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D015E8FB2C
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 04:43:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6C22C3037C0E
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 03:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2871930DD27;
	Tue, 27 Jan 2026 03:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mz6defjm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E4123C505;
	Tue, 27 Jan 2026 03:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769485389; cv=fail; b=jWna5ixcgjf292huKWelnYKZpuiCabxzze4hNrCkA9Q9Bs5zwSjHtVuSq3abp9eIRvCRf/92VcDhz7pi067EqmkDlD/M8k2QZds/C0qrpNVI+EO8WgsiVO0xjCJPRZ/ARWYtillN3SANPEF9xu067N+zLZ/zPyo90uHFzn57CAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769485389; c=relaxed/simple;
	bh=zeXaF34cwlsaicd5vRgceAcAMcTk6wzGA63vo1K7LK4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mCbW9yVLwQHIh6kCRuCzwXNMxPEps/0Ynj7QFsGZbTGjXxnxlPazvbjx8Ds/cqrbLHNTzfFVi42XTxTVjgvUBKfbIL8izvuMSZnCc4m2YP8M0O0seZzwa/7NiQ1Yrel7tqNcp5JeHwnt/X5vBd4h0Lzf8Wx3WLgX4C/YIUNxxio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mz6defjm; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769485388; x=1801021388;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zeXaF34cwlsaicd5vRgceAcAMcTk6wzGA63vo1K7LK4=;
  b=mz6defjm8coqj92zQLZz0u0V8Ih1UVOoJogoUzXsVBAN9SdwLNOKJ9iR
   3rUjpytx5Kr6MApicuQKDrsUW68VbqELAZ5ASdvyjEb+MMCCQ89Vk4UCm
   PhAjGkrdrBhEcXu69sSwyIOE0zU1uvUl0Ah0LY5BrwmKqYDmNSwZupyfi
   ICOmyvMjyVSqKoqsezqGtqrHHNgNlnF2PKJu4QYzeJ9WgawYw4mlhPn9U
   J6o0r6Kaw/CcWixBx7Ds9Wjd+nmvnkpik7/anpCjRm68uurp5RlIQjVFp
   QjPSdlVXg0OQhob3ki6rzkJyQJ/rRka2Gh6vYfm43ikFg/w0ovB/VRrSo
   g==;
X-CSE-ConnectionGUID: PoN3CWM0QYSp1KQsTRTSGg==
X-CSE-MsgGUID: X1EzOLL0SxCtvIRGjuUlCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="88248606"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="88248606"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 19:43:06 -0800
X-CSE-ConnectionGUID: yhWgmSAxT32OmDjiGFKErg==
X-CSE-MsgGUID: keW+M5x+QPyd8AnosEA5pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="212316349"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 19:43:04 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 19:43:03 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 19:43:03 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.69) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 19:43:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eziOLmZndwlCRemQ+o8Zcug1uJTZOF1uH+vdTFbq6ZSSbmjNAY6p4Ii6ap68E1OBtmMoa8VHVb+JVI11wmyLmiZdPVhtlJGKwX6dg1HKBv4qd/9J02WCgujnTdU9OSM5CSTBILQtuoMfYMRVtwIuJW7Jt9hVawG3lBp/t9yxNLzEGBoe4dTDp1/jeeaJveIja7rZ1wBuU6wlv21WeG4VKgWx33S9Nf8v5c9VdtlAOHfCSREYVm4kOiA30aXc/hfZNC+yjbBS4UOdzN0/9s4xwlLn6+V4uAcRDd8Lt+pl9dxVd7ifDw9xjvOOf9qlOLBwU83uYXjO3izGFDfvi4WL4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sGPbxvSJVsW3CIkMXJdFxuD1g+uHjKtVacYFJRKp0y4=;
 b=rBqVLZ6k8cMtfAHa57tI7WA3sq/0xoHZS4todS5+MBp5AAdOrXUW8bwbXTRYgBtBF822ofD8RhAg3t9wFOOvdecAkvX5Ottlq0FHw6Zt7QnCCg8AzMeqgxqDlKTZl39SlLeY3Ei/npZDSFv5TEoK3Fwi4VYtQG6x/XGkRb84dsSXLdyvsdRJQbPbsZn9BQuY6sFgcRKaiCIui8PXfbPMOoa0+88BHMY+pX4Uq+x2nnAwXcX1F1mw215NAPDmdYWAcXlG0wLiKRWKDre6Zcfxb8oLoOFNrcYEddmEEyTu3dECgU/zGZO8Z6DrrLP2sGUmWm30VVrCSKOnQCQzmRO4IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB5036.namprd11.prod.outlook.com (2603:10b6:806:114::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Tue, 27 Jan
 2026 03:42:55 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 03:42:55 +0000
Date: Tue, 27 Jan 2026 11:40:06 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <rick.p.edgecombe@intel.com>,
	<dave.hansen@intel.com>, <kas@kernel.org>, <tabba@google.com>,
	<ackerleytng@google.com>, <michael.roth@amd.com>, <david@kernel.org>,
	<vannapurve@google.com>, <sagis@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <nik.borisov@suse.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <francescolavra.fl@gmail.com>,
	<jgross@suse.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <kai.huang@intel.com>, <binbin.wu@linux.intel.com>,
	<chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 06/24] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
Message-ID: <aXgzlo1BsTjUIVzc@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102024.25023-1-yan.y.zhao@intel.com>
 <aWlvF2rld0Nz3nRz@google.com>
 <aWnuwb/2TrPAOrbu@yzhao56-desk.sh.intel.com>
 <aXeRf4Jw6-Sl1JCe@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aXeRf4Jw6-Sl1JCe@google.com>
X-ClientProxiedBy: SI1PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB5036:EE_
X-MS-Office365-Filtering-Correlation-Id: 65cc0f6c-03d5-455f-36d2-08de5d5627bb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7/gf/uxWsGz3E8E+hmi40l1g5onegfvUE5TMTT4eGcV7TCbYL4Cy0wlQ3B9B?=
 =?us-ascii?Q?cXAcG3Y2Jn7gliuXu14ij0c6ywy2wBgc0JQg3i2JvIUn9HMRHb7py1dMv6Ja?=
 =?us-ascii?Q?9kvljaue+IfFpkEJFizh7D3mOwEFSCgp8QfFQVUdrnuzqegsVkzh0fHNA2rc?=
 =?us-ascii?Q?us5iJ+42XDtda/T/AAt+wcm3W2GPKn+hfltc7VCbJO7lfS/J8Boeh0QEFQd7?=
 =?us-ascii?Q?/Bwfcn/sUL8qODiJlKAKTw9oCb7dLU1+r0jJB4K7GXvdZT+MjwMbRB6/Zpoo?=
 =?us-ascii?Q?svJPdQMA0MMvmTrtJvuJS2uAYE4syESFJCImGGQgps1ZZ6o5BgUPbPrMAYiW?=
 =?us-ascii?Q?uGjb1UV/8hGE9dv8zn0FzTJH/ePhItOPrDRH+/QAzt4263Y/MQgsEgx/QOD4?=
 =?us-ascii?Q?YF8V7rGaqjh9zsR6Ik8fk7HVv/QvLZ0V/VipxOVHwC0SbxiKcBcCo1PnNyyq?=
 =?us-ascii?Q?nPKzU6GgpuPtsGtqxr3rhxTgJiXCywD5zUmj1tjgl5yztxG2X743apeRhLRH?=
 =?us-ascii?Q?UIHrV8XkyrLGLauylTqI8erGFk0mWdFs16KfL5AI91qYRsXYc19lb5E9csg8?=
 =?us-ascii?Q?No8Sx6FjVh/eAPeFz2+2PaWeyv/zx4wIPs7DNJyg7Ujh0h0klF5G5SjDVm5N?=
 =?us-ascii?Q?ov6BdMsPJWX6jcrxRbVLAeew3BzcoUtk6lNsclxRqusqF8ULTna4W/ujvUuj?=
 =?us-ascii?Q?2iqZzhuGW6lRd3+22s6/nPQEaKNiXKZoP7PJO6lCIGFE1OTUc4F5edHyA9lH?=
 =?us-ascii?Q?TEtvnMTADTBDeP1QA+kF64ObhsCDs2L6ApD5Vqv9OxeZViROHs1sYlxma6uq?=
 =?us-ascii?Q?3+e+cHeA3g48OTjwGMuBXZCWHedN9+fKJrwsagCOPGMYONlKp3Ala2MLV5FZ?=
 =?us-ascii?Q?1s9sG99OrGzGkRR0Awh3/H85CXDWlcMK9FwY/cPnUVuMn2JFmFCm/0RyIlpu?=
 =?us-ascii?Q?Tpp1JhVt72M9T5nXoSCIMaSIS9FNuh/k3jnId4leRClh1lVTv9R8SFgK5Fgb?=
 =?us-ascii?Q?d4RW2h7dpSh2yMYb+q8TeKjoazEkX0WzZc4kz0m1369ZtBZedTCCzcOWrmaG?=
 =?us-ascii?Q?ZIKOAh3S+PNNv2je8/uY3xw+1nt4FrVsXU8yxxhSOvUjbOK9X+QkMnGC/bu1?=
 =?us-ascii?Q?42/Rcjk8NjFMTFd5RAYb8XJp59OjzjlYlCTuIQWRg3TYop2rpxleUkbdy+C/?=
 =?us-ascii?Q?blD3DH9VdR4hgBjqiSm2132T/r523d63JWJkyCYuWlpiToMrmg8TNW46UJyY?=
 =?us-ascii?Q?kA4p4JZmVtJ3ecOrdBgAnnMzUvAKEgRTY2ZsNlkIjizyOHNVp+V0goQnruZ3?=
 =?us-ascii?Q?/pY27lQRLtLzaBB2J7tLsxEhW0doTmuhE9TuwWm9k05WcOIxrCRb9HI5aKAQ?=
 =?us-ascii?Q?zWJCcYmn4Kjl5xSNLvrTrY3x/0cig3JzTwVXl1+sTG7qbsDNnB1ciXjy9D1G?=
 =?us-ascii?Q?diVe7Rfa8FELkrrYQqG7UFG5SQsReetjr0+kyrogelKMzheDTMWjjmrWKN9g?=
 =?us-ascii?Q?D8jv+XJ2JSV8kHmjfYLT40ffhfxlFV5qOAcHouRdS55kajBdZ5WlulTy3ids?=
 =?us-ascii?Q?C4YIcF4mulzp/p7N6gu8lD3BZXsAzOrDiLhuap4O?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cDEVX+2ExjuaTKoYFWYyNn2H9IkTL8ZzwoMAzH9XvEYu/QUPnD+3klLDKjdq?=
 =?us-ascii?Q?lcJc4VZMyoh7GbdEcr/Y3oWUw3pXIIxTOREqAMIX2qvOZrulZquBj2CRBNms?=
 =?us-ascii?Q?VyCIP9mK9Pv1sTN7i6YVudj1qUxvK6q5jhG48lR0jDNdxIa+QIUAwizzRThr?=
 =?us-ascii?Q?DdQGieydU93ZyL5erUdhWsMaiHnSb07sYjqJ+r2OOnSGGY3IVLhE0Ie+H4qm?=
 =?us-ascii?Q?XpkJ2B5fDmm2diqDktyQ3XZ/HRzrjWYfsCbeW6iOsPhnM2sPP4DJgx0khrtn?=
 =?us-ascii?Q?oTHpS/ywSCwvFkpKls54E2OIQcbXV8npESeW7p6HgVriXyDctnUpUqsfMobQ?=
 =?us-ascii?Q?VSQW9y8oYAzcZqbw/ZExZqkuWwVPHH7Sr2FqhCxAkTn84GQgH7yx2fcqHbJS?=
 =?us-ascii?Q?oj82GUVjKnHi1PIDRYu9ypn6VYlkBlyoDpmDXwI/NBtLRMvxphP4z/Vgn8iI?=
 =?us-ascii?Q?qDUwY02eoxY4iqTHPsF/YnCZSJ7XoVHaclwFVpT9pbGGnfWfZ+c9N/zrF204?=
 =?us-ascii?Q?vqbxx9IjPa4v1l1ihbo5xlmusD60yeEnxvB1MOU26zj2HlfFnnzBXCjdsAxz?=
 =?us-ascii?Q?PGgVd/szXUx1DykfKnZpEL7niTpXOPQjAEBiOniCjBmQe6sat4ESv2jMj1gP?=
 =?us-ascii?Q?8Ar0/9XTy30uyvjSWwmJu1l41bFjW9nLXSHrAQeVMwwKvWtTOUQMq7Cx1ymO?=
 =?us-ascii?Q?xgN53c/+uzF1QRt+GkpEBAR1E3rmNmY5yW2SIhvF67g+oT92I9vaI+/jdIOa?=
 =?us-ascii?Q?CXBh8ENxQoIzlE9zqNyScxc06kxVXOjWi09qG44UfDTQpzoK8J9Ikxi1ak9m?=
 =?us-ascii?Q?EG7k7FdxNC1Qi9fpmdCxkDSFK+iurLqgI65cuy9zYbYfzy+hxa/t76Ux+d1q?=
 =?us-ascii?Q?oChdrNTtIx1+Ug50XVtPPrmScTZWbvXv9sOB8IPwqOOKLjv9Q3Vy+ik1Xqe5?=
 =?us-ascii?Q?Xy4+351skRakCs8P18Sk+Ymi5cOlSlCvCEfVbxQ5grucfb52OUR+MOj+VjUk?=
 =?us-ascii?Q?8h+HcrVE4W7dwmGA5rH9rks8Jy5rqYOzAnEQ4puB0+3KgAwmwLyaq7f6RZLz?=
 =?us-ascii?Q?lgFvOY+9caG2Sx59frVyqHVyaMFE3uQCWhsPIjTYDcKJAPBkb0thUP5//HAJ?=
 =?us-ascii?Q?YC2ZrrJCnijyyu2vbDYZ9cS4NK+n726pPssex8f0DFCcEbsvbQ8/ReQM71Y2?=
 =?us-ascii?Q?2E9HrGjpziAmze7hYSnIWAnhCumdOhxejr1TIDsEjhlMIahRYUs0RM6pILm0?=
 =?us-ascii?Q?vW2Tx1SSMjq5geDc9HnaEmgExDpRyJqqoKhBOBjPEv7T7aV8iwz+iPURdA+X?=
 =?us-ascii?Q?JS4vyNwyV8nD78x5IkyzQgFI2PIbEwhrsNqF/ahKH1R08aAzKzCp+vS60G+f?=
 =?us-ascii?Q?T6qnaOeeo6eIVi2RGOSPmWFWDNfjGVDKJerX6gHLuRbNzygsGL0KlL011NZ9?=
 =?us-ascii?Q?RqnWqGk8vbA3JzUFcwaRTHmvOtC7E3a6tazQGFeVoiMr7uaXKpFV+9lmg+MT?=
 =?us-ascii?Q?f2wTdMf3n6ssgkAf9Tc2tqr7rajohx0Ie5TCwlJ1YPpkW7kbDORlrGVf18Xm?=
 =?us-ascii?Q?FkDqILhlpi/8Kt7WLNAEEfrtIVvIqO7UMhARVzBQId3SLqlf9ks34tmG8LDo?=
 =?us-ascii?Q?RwGgZDcatRN+RQROWhI7KX5GFMAn/fee3tV4WvC9numUjfnTXc9PJsyKV938?=
 =?us-ascii?Q?ef5Su6cWxO0W5msDhWx5xHDhc+QOjjhG01OMr3T+iFWctjsM4WZoA9VY0FJq?=
 =?us-ascii?Q?O0eml8cHxA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 65cc0f6c-03d5-455f-36d2-08de5d5627bb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 03:42:54.9580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PF2Y52UsTbCoNH64XDfGBsdWkpPrpS31fAAwFpv9zrxNNDrHN0GQy2tRmwbcEWD5wDFvpAhcmrJ+gsqeI82xUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5036
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	TAGGED_FROM(0.00)[bounces-69186-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,vger.kernel.org,kernel.org,intel.com,google.com,amd.com,suse.cz,suse.com,gmail.com,linux.intel.com];
	RCVD_COUNT_SEVEN(0.00)[10];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:replyto,intel.com:dkim,yzhao56-desk.sh.intel.com:mid];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: D015E8FB2C
X-Rspamd-Action: no action

On Mon, Jan 26, 2026 at 08:08:31AM -0800, Sean Christopherson wrote:
> On Fri, Jan 16, 2026, Yan Zhao wrote:
> > Hi Sean,
> > Thanks for the review!
> > 
> > On Thu, Jan 15, 2026 at 02:49:59PM -0800, Sean Christopherson wrote:
> > > On Tue, Jan 06, 2026, Yan Zhao wrote:
> > > > From: Rick P Edgecombe <rick.p.edgecombe@intel.com>
> > > > 
> > > > Disallow page merging (huge page adjustment) for the mirror root by
> > > > utilizing disallowed_hugepage_adjust().
> > > 
> > > Why?  What is this actually doing?  The below explains "how" but I'm baffled as
> > > to the purpose.  I'm guessing there are hints in the surrounding patches, but I
> > > haven't read them in depth, and shouldn't need to in order to understand the
> > > primary reason behind a change.
> > Sorry for missing the background. I will explain the "why" in the patch log in
> > the next version.
> > 
> > The reason for introducing this patch is to disallow page merging for TDX. I
> > explained the reasons to disallow page merging in the cover letter:
> > 
> > "
> > 7. Page merging (page promotion)
> > 
> >    Promotion is disallowed, because:
> > 
> >    - The current TDX module requires all 4KB leafs to be either all PENDING
> >      or all ACCEPTED before a successful promotion to 2MB. This requirement
> >      prevents successful page merging after partially converting a 2MB
> >      range from private to shared and then back to private, which is the
> >      primary scenario necessitating page promotion.
> > 
> >    - tdh_mem_page_promote() depends on tdh_mem_range_block() in the current
> >      TDX module. Consequently, handling BUSY errors is complex, as page
> >      merging typically occurs in the fault path under shared mmu_lock.
> > 
> >    - Limited amount of initial private memory (typically ~4MB) means the
> >      need for page merging during TD build time is minimal.
> > "
> 
> > However, we currently don't support page merging yet. Specifically for the above
> > scenariol, the purpose is to avoid handling the error from
> > tdh_mem_page_promote(), which SEAMCALL currently needs to be preceded by
> > tdh_mem_range_block(). To handle the promotion error (e.g., due to busy) under
> > read mmu_lock, we may need to introduce several spinlocks and guarantees from
> > the guest to ensure the success of tdh_mem_range_unblock() to restore the S-EPT
> > status. 
> > 
> > Therefore, we introduced this patch for simplicity, and because the promotion
> > scenario is not common.
> 
> Say that in the changelog!  Describing the "how" in detail is completely unnecessary,
I'll keep it in mind in the future!

> or at least it should be.  Because I strongly disagree with Rick's opinion from
> the RFC that kvm_tdp_mmu_map() should check kvm_has_mirrored_tdp()[*].
> 
>  : I think part of the thing that is bugging me is that
>  : nx_huge_page_workaround_enabled is not conceptually about whether the specific
>  : fault/level needs to disallow huge page adjustments, it's whether it needs to
>  : check if it does. Then disallowed_hugepage_adjust() does the actual specific
>  : checking. But for the mirror logic the check is the same for both. It's
>  : asymmetric with NX huge pages, and just sort of jammed in. It would be easier to
>  : follow if the kvm_tdp_mmu_map() conditional checked wither mirror TDP was
>  : "active", rather than the mirror role.
> 
> [*] http://lore.kernel.org/all/eea0bf7925c3b9c16573be8e144ddcc77b54cc92.camel@intel.com
> 
> If the changelog explains _why_, and the code is actually commented, then calling
> into disallowed_hugepage_adjust() for all faults in a VM with mirrored roots is
> nonsensical, because the code won't match the comment.

Thanks a lot! It looks good to me. 

> From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
> Date: Tue, 22 Apr 2025 10:21:12 +0800
> Subject: [PATCH] KVM: x86/mmu: Prevent hugepage promotion for mirror roots in
>  fault path
> 
> Disallow hugepage promotion in the TDP MMU for mirror roots as KVM doesn't
> currently support promoting S-EPT entries due to the complexity incurred
> by the TDX-Module's rules for hugepage promotion.
> 
>  - The current TDX-Module requires all 4KB leafs to be either all PENDING
>    or all ACCEPTED before a successful promotion to 2MB. This requirement
>    prevents successful page merging after partially converting a 2MB
>    range from private to shared and then back to private, which is the
>    primary scenario necessitating page promotion.
> 
>  - The TDX-Module effectively requires a break-before-make sequence (to
>    satisfy its TLB flushing rules), i.e. creates a window of time where a
>    different vCPU can encounter faults on a SPTE that KVM is trying to
>    promote to a hugepage.  To avoid unexpected BUSY errors, KVM would need
>    to FREEZE the non-leaf SPTE before replacing it with a huge SPTE.
> 
> Disable hugepage promotion for all map() operations, as supporting page
> promotion when building the initial image is still non-trivial, and the
> vast majority of images are ~4MB or less, i.e. the benefit of creating
> hugepages during TD build time is minimal.
> 
> Signed-off-by: Edgecombe, Rick P <rick.p.edgecombe@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> [sean: check root, add comment, rewrite changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  3 ++-
>  arch/x86/kvm/mmu/tdp_mmu.c | 12 +++++++++++-
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4ecbf216d96f..45650f70eeab 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3419,7 +3419,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  	    cur_level == fault->goal_level &&
>  	    is_shadow_present_pte(spte) &&
>  	    !is_large_pte(spte) &&
> -	    spte_to_child_sp(spte)->nx_huge_page_disallowed) {
> +	    ((spte_to_child_sp(spte)->nx_huge_page_disallowed) ||
> +	     is_mirror_sp(spte_to_child_sp(spte)))) {
>  		/*
>  		 * A small SPTE exists for this pfn, but FNAME(fetch),
>  		 * direct_map(), or kvm_tdp_mmu_map() would like to create a
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 321dbde77d3f..0fe3be41594f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1232,7 +1232,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
>  		int r;
>  
> -		if (fault->nx_huge_page_workaround_enabled)
> +		/*
> +		 * Don't replace a page table (non-leaf) SPTE with a huge SPTE
> +		 * (a.k.a. hugepage promotion) if the NX hugepage workaround is
> +		 * enabled, as doing so will cause significant thrashing if one
> +		 * or more leaf SPTEs needs to be executable.
> +		 *
> +		 * Disallow hugepage promotion for mirror roots as KVM doesn't
> +		 * (yet) support promoting S-EPT entries while holding mmu_lock
> +		 * for read (due to complexity induced by the TDX-Module APIs).
> +		 */
> +		if (fault->nx_huge_page_workaround_enabled || is_mirror_sp(root))
A small nit:
Here, we check is_mirror_sp(root).
However, not far from here,  in kvm_tdp_mmu_map(), we have another check of
is_mirror_sp(), which should get the same result since sp->role.is_mirror is
inherited from its parent.

               if (is_mirror_sp(sp))
                       kvm_mmu_alloc_external_spt(vcpu, sp);

So, do you think we can save the is_mirror status in a local variable?
Like this:

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b524b44733b8..c54befec3042 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1300,6 +1300,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
        struct kvm_mmu_page *root = tdp_mmu_get_root_for_fault(vcpu, fault);
+       bool is_mirror = root && is_mirror_sp(root);
        struct kvm *kvm = vcpu->kvm;
        struct tdp_iter iter;
        struct kvm_mmu_page *sp;
@@ -1316,7 +1317,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
        for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
                int r;

-               if (fault->nx_huge_page_workaround_enabled)
+               /*
+                * Don't replace a page table (non-leaf) SPTE with a huge SPTE
+                * (a.k.a. hugepage promotion) if the NX hugepage workaround is
+                * enabled, as doing so will cause significant thrashing if one
+                * or more leaf SPTEs needs to be executable.
+                *
+                * Disallow hugepage promotion for mirror roots as KVM doesn't
+                * (yet) support promoting S-EPT entries while holding mmu_lock
+                * for read (due to complexity induced by the TDX-Module APIs).
+                */
+               if (fault->nx_huge_page_workaround_enabled || is_mirror)
                        disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);

                /*
@@ -1340,7 +1351,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
                 */
                sp = tdp_mmu_alloc_sp(vcpu);
                tdp_mmu_init_child_sp(sp, &iter);
-               if (is_mirror_sp(sp))
+               if (is_mirror)
                        kvm_mmu_alloc_external_spt(vcpu, sp);


