Return-Path: <kvm+bounces-26178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 180C797267A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 03:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B2AB1F25640
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 01:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E36770FE;
	Tue, 10 Sep 2024 01:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZWsGy+om"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE21320F;
	Tue, 10 Sep 2024 01:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725930441; cv=fail; b=GY5GbRxjyveKkCs4BCR0RJTsWALGpNmNClBqyFGdherJPbI3f/d7asatdw9brs8myviM4Q49qZrgDG/7EVGP26x/6w8ipu0Ry/h2JPs15MTq3xrhdwLI7vNrONKD0jhNB7jRmUpl6MxCnG8R1qOORYH+8rOh7lVYxcQlDDNNyw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725930441; c=relaxed/simple;
	bh=2fvT+vHRNxVM4RQKWrAayaCnsD/LgCvx0aRRuXOoboI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K36cQbPCOaa7GQw0cDReoeA9v5KqpToiZSULnYzuHhGRUOs02ztf8SjzVFGo7FzNQ/D0BbHlWK7XoygxM6l1EK5dFC18CaiDZ4O6767QC51Kv405OIME7nFETaqaEbL8P6rvSUGXyOQYw4wh+EpcgXNAyxDQYJJjZ1JqBqr2T2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZWsGy+om; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725930440; x=1757466440;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2fvT+vHRNxVM4RQKWrAayaCnsD/LgCvx0aRRuXOoboI=;
  b=ZWsGy+omPYaySot1BL0LOTSjfyhilkZ+O2NdbxG02XgWTfjGImfMRDvo
   jawVJ7qtFWUxA42XyHVyd1XdaSosql0kVZYSn4v4rQ7sGdHXcORE+Nf38
   eGGS+CfdmRngGWl9C5J7f2MfYYXkA12caUlEyoCI0rIewLJTd8AHBNHfb
   sFJ0qJx+wC0QrTWJSxNxVs3GoNrwdlvwa0qYQp2lJrucUce7EfjtJbokZ
   y1Rf0BvoCEYIODRJSZp2/j4vSQv/wnbCoe3wMYP5gz/z8JkhZU6Gs4zYA
   TJKtDddSQyG+ospXO4xo9CtG5ni9NaOeegBHo/PYmrBfNtZrDLrK6iUmk
   A==;
X-CSE-ConnectionGUID: 1SPXkQatS9qowmfdMLAJlQ==
X-CSE-MsgGUID: jPlEJWGvTM+J/NX4gvFxZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24157664"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="24157664"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 18:07:19 -0700
X-CSE-ConnectionGUID: nEWJdgDhRnGlvUlAJdxxjw==
X-CSE-MsgGUID: cyEAyMSVSc6HFOW4BubbPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="67108142"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 18:07:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 18:07:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 18:07:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 18:07:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HARW9OquoyGhX5XjBf8MdEwYaGXZzP0b5/CtFm03bjlObtzFO6AjHLkBr4Bps/7W6Eg2sndzKjaHdLPwMAV2fiUF7z/h8UKkpj8zvqD+O75+RDDQ3x5zSpQmxzaCTJfm+x1WWw0PsDcL6SD60grEm7dNmc9eoSw74N1zFjM1AB5ygdw0h2sDZkpsNR/VWYMJwRNzg3U1en5ZWcbj8k0m/RztEpBHqbo9wMe3mVb60RNQTDRvnJ/TXhXoe+2Wq/IGXMNR8u6zOsn7md+M3Z4n1ONo6cPlwV+T9lb42habjc6QjssxbEhvfQt09NEMEf4YY3JhASnGjTm/vqQMFBxCjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2fvT+vHRNxVM4RQKWrAayaCnsD/LgCvx0aRRuXOoboI=;
 b=jYjWGVRYqnRKh6Js5JCrkUpPUArwi2hNXxNP2S4HPgydZ+/AM6V+DD1FZDVL6c3mYXG000CEs6Qsmq8EINIW0/QtD+zVm+LjSAbndeES0UZEdDFyD8Nd8ZhQ9ZRA9Fpj+vlHPHWfJZif59L20kAhWshNKtkGZ7anWlyLw/CIeojPn4YtM4y6CZ1WVqy3ElnLG/W7oy8aW8nYqogO9lgGnLgO3TxDFeMu9V3pOOZWb9PlRf31RKlhIYaRQBpiQz9Vvzf8K4WWJrGA/5lPw/yU0GwSoi92fdryv4aV6a9+S/BCvTmvF+yuGiPDi2V/XnOYavot64XGE8k6XJzHqFDgIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV8PR11MB8771.namprd11.prod.outlook.com (2603:10b6:408:206::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Tue, 10 Sep
 2024 01:07:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.7939.017; Tue, 10 Sep 2024
 01:07:13 +0000
Date: Tue, 10 Sep 2024 09:05:16 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
	<kvm@vger.kernel.org>, <rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Kevin Tian <kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>, "Lai
 Jiangshan" <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <Zt+bTJvNgkG4JeD8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ZtUYZE6t3COCwvg0@yzhao56-desk.sh.intel.com>
 <87jzfutmfc.fsf@redhat.com>
 <Ztcrs2U8RrI3PCzM@google.com>
 <87frqgu2t0.fsf@redhat.com>
 <ZtfFss2OAGHcNrrV@yzhao56-desk.sh.intel.com>
 <ZthPzFnEsjvwDcH+@yzhao56-desk.sh.intel.com>
 <Ztj-IiEwL3hlRug2@google.com>
 <Ztl9NWCOupNfVaCA@yzhao56-desk.sh.intel.com>
 <Zt6H21nzCjr6wipM@yzhao56-desk.sh.intel.com>
 <c1d420ba-13de-48dd-abee-473988172d07@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c1d420ba-13de-48dd-abee-473988172d07@redhat.com>
X-ClientProxiedBy: SI2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:194::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV8PR11MB8771:EE_
X-MS-Office365-Filtering-Correlation-Id: 47eb56a7-30da-4675-2f6a-08dcd134e796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?KR4Icu2uWajf8aMHr7sS3CVbxbwQQpVCr93wEHiCFKiyWyX4UPzJc9uPLlLs?=
 =?us-ascii?Q?5FvrWUWwm0TSqPXp6ikMj3aQIGeIEuBwgMTDbDTpw8baffD1E1z1fSImmuoU?=
 =?us-ascii?Q?RojspEiLF5ki6WdetBjXOkvOk1xFdNtgulGwbW/OBu6VRze5dMUD+mOx9vRn?=
 =?us-ascii?Q?0anpO8Ls9ctIiT4IsFwJZpRPzMpR+K+Hb7VsbvC2BxbUJPeEI9NvWlaFEMf/?=
 =?us-ascii?Q?fG2ucrX6RlHRhlRlxAAuFiJTpACdaPe/yAdcrDq7Z0dWLBh87fyCmIO6JmJV?=
 =?us-ascii?Q?o/CpnI3izeNXicpRPdl57IhFzHubEdeOcLYJqETTUf+NcKndy1N/CbgUUqT/?=
 =?us-ascii?Q?On+QpB2I88ZTnWtEIab7leAbTpjSUYbBC8Z/+yPN7LDLlo9lKUF3nntd/Qf7?=
 =?us-ascii?Q?AoZ83VHQMpHIfdfBsLidLd0pez5pkx03uQWb/+ar+nGMpMOyf3qV9k9AUTna?=
 =?us-ascii?Q?DLmsJ0Zi6Wm+BUMrlqQ2ITvLlhSMN4JDX5t1raE8uNepYio1N+sRw09Jeoke?=
 =?us-ascii?Q?PxlbADsQE1kZHIL2rlf2OHN2EL/9g4GsQ1OSgxHv/bdCteB6nMkM8HnsGC7F?=
 =?us-ascii?Q?zKPTlHKgcp2iFrQiIMiPDu/0SV0oY/wop+xe0WC1pBBc04Oepf3r2mbTlAgA?=
 =?us-ascii?Q?H+k9tLOcAAYfDGuiJ+Fe4MAqwLX3ax3+e+RHxMnmyZuUYPSfc48V/mWHRmru?=
 =?us-ascii?Q?TNY+GbD4jWT+wbzj9BhLpXbEc/+h1RHS53H/ogiThV9Kn1JcROkIFf3YsJ5D?=
 =?us-ascii?Q?l0vxMRJv7zQl+iXnwg8VRpICx90hX35J2cOwlsj4I3mRwwZpwVECzukGZzyJ?=
 =?us-ascii?Q?Tx0EbY6soWZSjB3mznajH/53MqFv+T+H/z7fdOs+Mq4Zp9fmtvNhY/MS/IaM?=
 =?us-ascii?Q?1SUIKWmz2m/rOF8D8ZMDGB6JGngp/ERKxD8iHAv6BZ0xUjQ3Lw62Wh30zT9j?=
 =?us-ascii?Q?0HI+Af9ystgF4K2yymuHKAntuhL1MQSS253vMXGVFDCEzWOmUXY3Pnt+aPSN?=
 =?us-ascii?Q?S4xk47gx5/iJsMuHaiUqUlpv3/WglYgmhT+wHhUiRWmBUipD3NQ9Wnv2evEs?=
 =?us-ascii?Q?jFPW3P49FMURRgMMmXa3MknBHrfOoIWArtdz4Q0qBTB8fGnTjzxjw5AfKBHz?=
 =?us-ascii?Q?6vK+E4JXCDpT8Qm7o7N35SJgwh9HHnLcJBYGRyPvPK6NQyMFvivYmjRtdU3Q?=
 =?us-ascii?Q?v/Vnm6TQl35YGPJmVjg1DTH1gXh6ObP/kUFsuCm0P5pjMRBq5DcjHTWDzoO+?=
 =?us-ascii?Q?qsBJe6NhFv4NEvAFBLw1NGf7rf9tQ+RvmAsFUkm5qqr7x2WEtVouMHi/UpCg?=
 =?us-ascii?Q?rThW+lkV99LaqermPgNVXMvnf2VSBg42lAu9IMV5VqDEig=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y14Htp47rgtEF7VOthd3ncWdZRKmstRfi3SDdnRsguLrfRShlR15RG1e+9cV?=
 =?us-ascii?Q?c9G4PzEHFLxRHEAnOTySLxjdfUQk0bnk5L9USVR1aMXbsadUqmEA/V9uehuP?=
 =?us-ascii?Q?Eocg69b2DI8n6hmCenJikSAAnSOlz/vMofvMnzrDru9506b9lhzfFP8SFk1+?=
 =?us-ascii?Q?I6lOQ+PCFzuuooINheZfxzjOm07u6TeNpB1aj/Iq8OEPwJA9vzdV3srjPu42?=
 =?us-ascii?Q?oYR5TU/KYGHQYTdypLtsxHeJELxBIRuG3n4cGDXzRryeHG8/CkRTXRrx8E8/?=
 =?us-ascii?Q?Ko918fPZK3pQATgsD20SG9aH1hYr9J704KeCP6Rixj6VqVWmLZDcXm4sx+7U?=
 =?us-ascii?Q?6qnNOmLUy/xq9eNVyVF/SVkuX/XFaWRsB4FCSKyMDtXXDroK3j/ehmtfLTAx?=
 =?us-ascii?Q?yjqWwad8nCnBKFAmDKpmTdoaRF2pWmbRbNdfc5xknHJrQtfa9yM2snTPQcD1?=
 =?us-ascii?Q?BPdEa+MaR+PiecFFIl8T7LrQFBSH4rRAUZDoqINPRZ/77UVYkzkIQQzmd+hz?=
 =?us-ascii?Q?yGf6wFca05RMgmKhCaNUVZuUUJeE3lknUp+MdTUVu6IgqN28fhzgkpGQO1lV?=
 =?us-ascii?Q?DBzZmORJv4KGzN1a6e2z201Np7EVSL7ALSoiUrk8Cd6M6eGqyr1l4/Ydm5iw?=
 =?us-ascii?Q?mhJ+KvssQZOtzMGFH4SNt+9EqEdiTuBAgA3OHjhomafKhbEEEu4ERP8a1tFs?=
 =?us-ascii?Q?7tFqc9VRqI4Dv6UHGGkmhAZz8xVyU4t5HGne/Lrvu8IyN6aGeOKxL6W7Due/?=
 =?us-ascii?Q?OSgsX0uPkjLj10PJINS385+Vb+MOrxBj2zB20N09d+7nRT6G+jR9lsWsf5Nh?=
 =?us-ascii?Q?l9L1dDHTqZweFNcG+8MmKWrnOu+oNKvnXmetO3ELPPTjjoX1Vvu3licuRpMV?=
 =?us-ascii?Q?VBSMTbVaOhJRF+QdozvUm0IjZ4VS5HAZtvsUux8qgGGACIDs5N4NoGs5HRM8?=
 =?us-ascii?Q?07vtd9ruE/jzbqd6LN0SCcbuVkh1llY9ut7vpxeRTfpCCpVtolFBeJIeOYJi?=
 =?us-ascii?Q?m8TB6jreExI0vMs348d0Zhb9PAcmfCePCB0Xi2AWJoDo2uBmk0rQBjUwBNqe?=
 =?us-ascii?Q?6oLPFsDzWnxbQgPKpwdBkfzShCtSot75V2uxdQlhEOI7CZcuzMcjaTcwHdYL?=
 =?us-ascii?Q?9SbPtoKdyctYgAcwWcAERvkzUHVcw9sPU25DfXr7Cwpfjzy9F9F5zezzh1eG?=
 =?us-ascii?Q?jZ5RIPYpmymjl3Sd5wze8dDV1Nk5vGaAmbk1thXSISeJj+6FTbtjFa7DiaUQ?=
 =?us-ascii?Q?9ofFff7ErzFfT9sfcGyP7XNYyhbyG1Nwxrrncv1rOV3rR/Zi95sQ06ED9v4b?=
 =?us-ascii?Q?7ahEB+/hUr7C+wQyvVd4tNRvb528yPb4kbeleglm0FsH147X7mZx/kzzac72?=
 =?us-ascii?Q?3RWAUVf+k2HCpwUdVPab8hnl3TZ+QNNbuYcZFuVNLFgMVDPWGvze+gd7Dbmd?=
 =?us-ascii?Q?i3rGbS009SwuZYZJw162K6VvPqRmmC50Qe85chCTP9ln+5hGR3r+mCIYJA/s?=
 =?us-ascii?Q?KDrejk9tbe4w4QshFxVibaqpr1CSJBQyzrt0toQl+1LNfxn6kT8EIoZVD4mS?=
 =?us-ascii?Q?qPmvSKFS1+5cxsZZRkoByny1r0C9wGCA9VgDklIS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47eb56a7-30da-4675-2f6a-08dcd134e796
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 01:07:13.4741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lhytkZQmCNEA1HxTFLHWWSrVIB0MoSdXVeyiwTWNr5rwlQ5LdJ2Jn6MaAjyDRvQlK22uoXv/cAnhZf4rR2ifQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8771
X-OriginatorOrg: intel.com

On Mon, Sep 09, 2024 at 03:24:40PM +0200, Paolo Bonzini wrote:
> While this is a fix for future kernels, it doesn't change the result for VMs
> already in existence.
Though this is the truth, I have concerns that there may be other guest drivers
with improper PAT configurations that were previously masked by KVM's force-WB
setting. Now that we respect the guest's PAT settings, these misconfigurations
could lead to degraded performance, potentially perceived as errors, as was
observed in the previous VMX unit test and the current Bochs scenario.

> I don't think there's an alternative to putting this behind a quirk.


