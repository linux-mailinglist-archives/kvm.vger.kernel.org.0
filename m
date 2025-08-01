Return-Path: <kvm+bounces-53828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C05CAB17E4F
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 10:31:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D344B565CC6
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 08:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45DB21E097;
	Fri,  1 Aug 2025 08:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eFcZHkdc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EAB1FA859;
	Fri,  1 Aug 2025 08:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754037078; cv=fail; b=kduAjHHnV/kRY/+E0x5pJs9eZ/x7LU2uDmEg7ftvWCdsqU6lDC7tOsKVyn+pw6b5SNlMohl82jbnX596qzolu+biIrcO865F0MTThxXbpx0jkRv8dU9dKGPGT2hqgixEGcVFBaup+ZL1NaFhNFFTklutkUUChywZT88znbyRSfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754037078; c=relaxed/simple;
	bh=BrPY3SkrxtkqnlPR1CYwPTYoCShVALatcTYRWtYhbmY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Hs7PyVw2DdhtdVx9bqx2Vr4I59xwrX/ObTWfLOxb2wnvaUIunQAAD/7bwmliCa+ExgMyOvSlcCbCrWEs0BL8QiyF7zipdnsfLkgmzqDQF2phpeuB3vuMDA3Uq9aStWsNyGOBQLWhjlUeaUztca4nZccEg9hmI4jUMXzV47Xjt+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eFcZHkdc; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754037076; x=1785573076;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BrPY3SkrxtkqnlPR1CYwPTYoCShVALatcTYRWtYhbmY=;
  b=eFcZHkdcDBHppGWg2y6V2VJu53ynV4bfXwofK58dOfYPsjOd+9uFXa1Y
   JbSe+tIqrT2US1IQcgMpyxwApsM3FqizAEu1VnnfLLq59R0x8nF3VQ6Wv
   YQEAyhVuStyHAETjdp8c1FF7wpzLLe+HqtLxQi0qrN9BlMXg2u3T8Bycf
   /g2cRmPGh0IQcBDe9Sl2+dJZz7qxs/oq7KEe0V00GqP2N3D27hWNyjVFq
   aNmLk7QatmPcZZGTxAa8Szcby2BSARLIyCZX2tWUHeSPPaQXYD1iTcV8k
   xQGOdk3IHmRFYpq9mmuANRArxjdAuYBHYQfS9z3AWmENbpA8ciGv/gk1g
   Q==;
X-CSE-ConnectionGUID: KvDIeKDlQMGDZcAuIkmwLg==
X-CSE-MsgGUID: Ckav9eM5SbKdG4g+s6KsKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="66647914"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="66647914"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 01:31:16 -0700
X-CSE-ConnectionGUID: 0cxzPqDqSB+EQ+Q1pMpqHg==
X-CSE-MsgGUID: n0V0RrkhTvyxAG424wZREw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="162784282"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 01:31:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 1 Aug 2025 01:31:15 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 1 Aug 2025 01:31:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.51) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 1 Aug 2025 01:31:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N3HDIxrdwpEKxoRGRKvRycmsNnKyguFPvRNfT9QYST0vCYaiIUGmitsS8YnOQQLF6AO6lW7VtWTzbhjCC4/CynIh15CYaylp31+mVP4h0q/Qg7HA+K0RiS1pBY76tdjkSumTpOacRIsOpdwQ6Dj39iSywO11zYWoEYq1TYPoVlRsZlyPu2UMaKD0kkk9wNOVfdkZsL1GC2Kdg03Sn2CMSyG+8u9zapDXsYk8t7t6kYaQdb3W1DCbQQNTaus02dG0E789F+h1JC2pTmr/NwFNkp7n4fvYKcQTiKJK8yukG8nfFNT+xAl0lGlnj9y9PAPKggcfXq5N7SjenxBIWjBQtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FAyDYVXu22a5erLK7mfdUQKzTiTb4xUXZJYuM3RpnIQ=;
 b=mvW6qwlx21YTJ9Kts4Yj85a5XqQ9dAHroSlYTVTkBsJVLsVjfPbnzbvEmp1pLPb8aul8gF3jpDf7mOcTowzyFNwOPOCCfo2OjfgWy4e3sDnxS4+QH7kQlGdXgAug1m5xhC+NxJIIzgw7B3kuwGYMSuE7AWBqe3It3iazIzUrjmQCs0wiBtO41v3SAJIfqfO/IrwHRF/CsGQWyzgFChSd0u/X2Cef4fkwD6zMQG/y0P/B6OYMt1BUsy4f2YfAH/M5h8drUp8vp7obNI7h/+AVoksE5Ts2iFw13Ex/IM6uszA4J1Cw+F6M5XuzzAh4qPfLnqhADj3YxYaZ0eB54c3S9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Fri, 1 Aug
 2025 08:31:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8989.013; Fri, 1 Aug 2025
 08:31:12 +0000
Date: Fri, 1 Aug 2025 16:30:58 +0800
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
 Chen" <farrah.chen@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Message-ID: <aIx7Qlpi1Y/VsRVY@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
 <c29f7a3348a95f687c83ac965ebc92ff5f253e87.1753679792.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c29f7a3348a95f687c83ac965ebc92ff5f253e87.1753679792.git.kai.huang@intel.com>
X-ClientProxiedBy: SG2PR03CA0121.apcprd03.prod.outlook.com
 (2603:1096:4:91::25) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7540:EE_
X-MS-Office365-Filtering-Correlation-Id: 666905e6-a59c-4c0a-59e1-08ddd0d5c589
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ROsrew2QROa1DgV+blS035IElN/57eaK9k09DUM15UDMMrVd1SIsdW8+o42f?=
 =?us-ascii?Q?9YukVuawYS4TN0OxdfiHOQicB6QxDvvCDv8hV+C6Vd5KWHC2o9HAPw0Q2IKk?=
 =?us-ascii?Q?hQfccaBQ8/rAhkMNi2TShva+iBfgvmtX6wSU5tCLn70wQFFGxMMurbJgU2Yr?=
 =?us-ascii?Q?lCk3Dlt/kUITQmHLWEQdgyE8a3AbbFrgIskHu4cK9EX9Fru2JVyN+aQiralm?=
 =?us-ascii?Q?mNXforrJ+wDj9DDjeJwcXaxch74RK5PzF4lIA0fHQrw6VvGcezsXiaQUSImJ?=
 =?us-ascii?Q?+7tsKkEwPzWyjKOWbUy2+STGtCylfMdJtykxgoEVvJ5baibE1fbxaTOzgoZz?=
 =?us-ascii?Q?xLN/zTfThbnP7PNCWoIZAFDUt7y7vltzMWiP+AQ6WcQbnDg8O38S53vp0bYu?=
 =?us-ascii?Q?//1Ck47X8Agd77VTK0nwHPK7ONOdS1FhSHo9YeWwBglTam5xkFOAzZErGkVa?=
 =?us-ascii?Q?xWG6834XEAm+ubwx4xshOjsubWgwPBNP39ZJA9gBBpwIhNKJ2FW3uEq5jfKW?=
 =?us-ascii?Q?nzK1FMRGrups5etzEuZsLtUCIaZvP3ADAFUkZ+GyuOJ+7HPNmjEJE/tS0W8j?=
 =?us-ascii?Q?67uCmfnnDxS7iNudOP5HIHgfWhJmGcz3Bo/ohR0bDkWnXpJ0xTvp+JCylUKx?=
 =?us-ascii?Q?2ZB4aQgU2fKwQIfRRALgjjXG7yPTGLg3gNNyp4NpEDdF9j6NMI+WEi/e2NJj?=
 =?us-ascii?Q?VjT23/AYLpUgig6l1EhXLzN8qD3m/S2xbxs2Hc/zPcZMvXiGHTnTUChwrLPy?=
 =?us-ascii?Q?4RSxFtC1JoCOEehWukb8RXDi+K3XlAtobsRbKAiQf6ncH4xJo+ih+7hUmKXA?=
 =?us-ascii?Q?Sr71+663mTariVdZr4duO5/8sKoJD3ut6bqRgzpsEyTHJTWssD9Eyn+LvjKQ?=
 =?us-ascii?Q?ACf8RztNZaTF8YbOsFD2RgcqVJsQnwIop8a1VvFX6GWE5v3RKJV/5aiWeEYV?=
 =?us-ascii?Q?S4VceHWE2Vm6G41rBLZ/p0xi7OMpjDOx3Mi+AoflxOeSVe+cTNB3iW+wF+cE?=
 =?us-ascii?Q?LPw91x80tE/icp/6Q2zjT5pxnUGXmw446gKpTWdgrchnQofez/p0X2Gh4BCc?=
 =?us-ascii?Q?Wbizdtbe242q8WpgfMfsrur0/g2ADQ9/Fgkn5jEQI0Rq/U3+Xj4pLJnYYC4X?=
 =?us-ascii?Q?FgSaExVnuVVn+ZhQoDVcZhuulV9kPuCswl4wXvdzCFztFyQuxwYcXz34ak0L?=
 =?us-ascii?Q?7w4dABK/x42uDZ6t9Ek4SRfQwRZXGuOIuzfBtbSy0rXP7lSMbC0RX9tOywFg?=
 =?us-ascii?Q?coJadQ56n6JvH451oGNqPsLIBxyyqqKDRrV2p373Q9p13suFlRsWr75c9dzi?=
 =?us-ascii?Q?HB5AoFuwCaoA6VOqLgZmzQO7XiBe4cKCtVGLPzDY6j3joUfnMR41gyhLt7xR?=
 =?us-ascii?Q?iCqy/8Rg2BZDlJxSBNyED8AQmBydtRbO8vLlRef41uWTHsnb5h94DncyNVFh?=
 =?us-ascii?Q?tvcg9fe3xyo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gzLj1DQxKPF6XUWAt09hM390sFchOmk/awDWTrGmn59DTBZGnOMADRdYqrIO?=
 =?us-ascii?Q?/rkr4yfn8VznMNbhP/jd7q0xxfmUBNS+ZrkDiDPrTl3qSR0VBHdtRQgDRu7M?=
 =?us-ascii?Q?rw5lFucab5XJ4NNOk9OPm9wvXV5HyY46mXLoo7tvFfKNWee7lqqg95lSyUKF?=
 =?us-ascii?Q?UfFTlSkREmssc2BIhcymE5alQiqixkG9YJuLl58KPMITnkYTsAxNPR2S9FYN?=
 =?us-ascii?Q?lczadzLeuJZ8qJ+XzrcZ622idjjmXQ+CdedGBURDgBLMJtlKowS+yNGESIyV?=
 =?us-ascii?Q?d6C5hHTaLfbYWl4jlxz4pP9s2A+7ItPuBu7Cs/qvVNVFx8B2BUzRw4nv7J1U?=
 =?us-ascii?Q?jRtTQhxYXkACBLOM4XsgN3CtESxYV/qCQwvHmQjoBWtvl96tyOe8+JGP5pcP?=
 =?us-ascii?Q?7tCKw/OzjzCr/CIVTjBtkQTikOxqP/Kz6ue2BQbNXkfTiUALwMzjyWuDejhA?=
 =?us-ascii?Q?dgcRRy1Vjb1mAW34ZNk0/VWT/90yRq51j9/DHeQKMaCj/Zkw1dgQ9kkl/Szp?=
 =?us-ascii?Q?P3ZKl/nE6zLLUGHKdeZ6qVXF2fdro8zd4NQf079qAqpzrmu84by8+h1aXaYf?=
 =?us-ascii?Q?xyakJff2CV5FZ0+iaHIYN4nWQYm7X7J+aiKlYYTVi3DkjVlChrIiQsfV13TR?=
 =?us-ascii?Q?Q5ANA4owUgcpR+hPaXSjtn0Oz/HF/7oVF2cuj+MPOP8TorOE3MuZ41gKzspx?=
 =?us-ascii?Q?oXvFy+8EcDHUAP9gwo5j0S7eSifqMY3QiullTm+DlSPzwkFQz/Er02aCHf4B?=
 =?us-ascii?Q?MAD0QndQB2RhOaTEx3CQwrd40Ir3uGmpM86QkN6bMatSAAzqlBG2DBq5avYt?=
 =?us-ascii?Q?ul7uiGGL7umXzTFsRR2qubOpJTMqvmIBNIbeGjkIlqaj7IzAd8W73T4SeU4U?=
 =?us-ascii?Q?8WZzFWvTHYU3nF6MBNBFYrIYLXd5gAnCDxUzA2Tmd8648kjEnoQFgz3Q/pGU?=
 =?us-ascii?Q?1xSFExy6jFPwd+5dpVjadAfQAd5SWlL/t3kHOLH+vpQ4LWGchSp7ZIxZkWXj?=
 =?us-ascii?Q?mTNe+SnmASriLjq2SpSqvbrPghENJo98cNfmXW4tQ7AELfvVKgE3V7LZ466u?=
 =?us-ascii?Q?ScvyAbyKe04uIA3Ir9w9nZnvgGQtutiqfxRwAp3WYHwCklE2nSBE9+gdJHms?=
 =?us-ascii?Q?vWI1pwQTJHbdHhNpZVihzXjRF8sQQeF8BBdglgZpZfv+dwzIy4gONu7UwGmE?=
 =?us-ascii?Q?38uZS09bF2Ef75D9HFG/XvUB6bq2gFad1afK0Jw89LVnlT6z8Y6BP02gG8rg?=
 =?us-ascii?Q?wsYSCxm0KVgpKBWV8zFgLdJK8HpsyA0W7tT7+/DuHhvJhAP8+QssE8geWw0f?=
 =?us-ascii?Q?r25WeyBeO/oyaUNmlkjonmYbhD20VwzeZGxQU5Dy7/utK1rFxFGsGQWNaAhj?=
 =?us-ascii?Q?Rd5oxSJr+KT1DHTsgAaUmW7mwLKlXu+HxVA8YLskKLACxzzQqyoC9mMstY4J?=
 =?us-ascii?Q?/d1nY1gHbcLOrjTBQEO+x/RhDvzItwmpzMpBJPYCtJAhJNVabmBZWd6n7C51?=
 =?us-ascii?Q?heAYqydAKJWHbKLrQDZ1LqO/PIQqj9Xl3f8lECrIIAdEgxpgnwVbEp32/gFZ?=
 =?us-ascii?Q?kKLuUAiaG80DaL2OPCTZmKecsQ5g1gS2WlV3lAFw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 666905e6-a59c-4c0a-59e1-08ddd0d5c589
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 08:31:11.9368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T/6vkzKuKSbgG6FLbSS2IbsZ6AYZk3dzO47n+0YYO8GQOAkVE1uoyBDFvkIY2vkNsdfYpzNLwDHmO5kV1arD4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7540
X-OriginatorOrg: intel.com

On Tue, Jul 29, 2025 at 12:28:41AM +1200, Kai Huang wrote:
>On TDX platforms, during kexec, the kernel needs to make sure there are
>no dirty cachelines of TDX private memory before booting to the new
>kernel to avoid silent memory corruption to the new kernel.
>
>During kexec, the kexec-ing CPU firstly invokes native_stop_other_cpus()
>to stop all remote CPUs before booting to the new kernel.  The remote
>CPUs will then execute stop_this_cpu() to stop themselves.
>
>The kernel has a percpu boolean to indicate whether the cache of a CPU
>may be in incoherent state.  In stop_this_cpu(), the kernel does WBINVD
>if that percpu boolean is true.
>
>TDX turns on that percpu boolean on a CPU when the kernel does SEAMCALL.
>This makes sure the caches will be flushed during kexec.
>
>However, the native_stop_other_cpus() and stop_this_cpu() have a "race"
>which is extremely rare to happen but could cause the system to hang.
>
>Specifically, the native_stop_other_cpus() firstly sends normal reboot
>IPI to remote CPUs and waits one second for them to stop.  If that times
>out, native_stop_other_cpus() then sends NMIs to remote CPUs to stop
>them.
>
>The aforementioned race happens when NMIs are sent.  Doing WBINVD in
>stop_this_cpu() makes each CPU take longer time to stop and increases
>the chance of the race happening.
>
>Explicitly flush cache in tdx_disable_virtualization_cpu() after which
>no more TDX activity can happen on this cpu.  This moves the WBINVD to
>an earlier stage than stop_this_cpus(), avoiding a possibly lengthy
>operation at a time where it could cause this race.
>
>Signed-off-by: Kai Huang <kai.huang@intel.com>
>Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>Tested-by: Farrah Chen <farrah.chen@intel.com>
>Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

Flushing cache after disabling virtualization looks clean. So,

Reviewed-by: Chao Gao <chao.gao@intel.com>

