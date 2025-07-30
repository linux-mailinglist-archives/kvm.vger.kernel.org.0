Return-Path: <kvm+bounces-53710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF4B1B156EF
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 03:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2EB34E29B4
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 01:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE41A18859B;
	Wed, 30 Jul 2025 01:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BZv0OhEf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823F22AE66;
	Wed, 30 Jul 2025 01:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753838480; cv=fail; b=aLMAjPUoH5GSoR/j5qgyuS3JEu+t3y4sL8I0VnQOaZz2GhGd+xAB7zyLHFKez82ZggTZbIrn4EjbAexy/dk4EwxXiDteQkzAzIT+CnBC//5ftFUvmKDFHdC0ebc1lDI4ERrmJ8Qd/p4Jq4Bw8aUkzriwXyWPwAN8MOkBi2zFcwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753838480; c=relaxed/simple;
	bh=Ite4oTr+fC4wY8qlxqwedIpruxtI5rXkuwiwj4FS8bg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XIg/zQuzlZjDxFc6z4u4WYsHveiruWlI3pFQRyokwi7Y76Ld0VEep7Cue5QEz7X+9RgQzSDogNeiakDE61OROF/akgUMlJG7OY8XAiGzs3XrNMwmktKWkelFn4zsfJU1MzQMaVDw1R1hDk4xeV03RNclZ7jgTjoK4knkFpkrr/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BZv0OhEf; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753838479; x=1785374479;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Ite4oTr+fC4wY8qlxqwedIpruxtI5rXkuwiwj4FS8bg=;
  b=BZv0OhEfHfTSWEAcAjP0TWGbmKXTwEg4f8RPE02WUGOEn497XcfGt+jd
   eTa7bL3toYV/yEwRdt/S0tWPubjuCcUqcKnqEEISzGNFAhXwbOnsa0YuA
   C6Filwd5GmCj8IGcYtqoo3z7SioSg/38IKugd4Pl/Te4igF6XFYUNXoem
   WG0M+pPuIavwn/KA+EfWiiB+sIfgl43S7sWdxjV1x3AgHKnfCQ5I6rXtS
   LG0wLCKlTaTawITCvL3JsJ2gPz2gCJH3ryLuzWdOOMfopk143UTXnNVFn
   HEcgaXsv2wnPvig+K6Nzr4WAXp/Q5gACziX5zOncw4LE2b05rjqiDenlI
   Q==;
X-CSE-ConnectionGUID: COjiYkwfRHOmWAvgIk9DVA==
X-CSE-MsgGUID: L8A6GnuKS7iawVFb961PJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56278592"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56278592"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 18:21:17 -0700
X-CSE-ConnectionGUID: 1JGBRA9nRcyMx9wxqCfCsg==
X-CSE-MsgGUID: 5oX8o34OTNuDJbZjTvQmFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="167031156"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 18:21:14 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 18:21:12 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 29 Jul 2025 18:21:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.79) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 29 Jul 2025 18:21:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qUs5vrkyHx1Y7kt1yXHzeMYXs2RkhMfRX7bzapDwCavAU+9tcAH53lbLQZGTX0YVlP86T/opV2bkFdHT7ZqzsDYIfoef83OYgeo0LPs1/HpyauDu/M3Dkr5B7H8TGdkbbfKz1dWGtU5t1dP+ozczrnMXqOyiTIlOQFYdpDskeTxrRl7irX0Y8bwY3GertzmG2rscZH6KmfQ5LNmQqhCVkL254F4hqA4SkGCC09AEhJC3XisUyfCLXUGXePMCmQas6Y2iEZ69tCzCcZ9yIwMyFrFkTC9hf4NTyIsB7t4h9HPxMUacGeNxvXBsq1fWfN01imlaOe/rXHbxtQuA+ATxnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90fehQy5Z8AqQRqWp+91DuACeGP3sq3xvVNS9opXIV8=;
 b=dOO7gDTWV5G4DQ8Pywk/WRtedqFUqUbShfBCCNfE6WScNIXwWfT8FCq2pF/pD/+erxt9e9U0osucAc0XcDfiaHdN0mkWXZOtP7kxhOLxyz3UDxGXi48qi7LjLJiF14QJkgi9jydMAdYOqiTcUg1+2cyLrtuLFYBblrMtrC/LbDswhQPpQ2KwQdJ3qAWASCsZdPhnQOKdzhYYF2HPHUowu5HNaElABYoE/Rncy4owOG8Y+5bMeFHKMhZ6Mx8FixhwRFSunNhC7MV3Bj7rGEKuBmuBNsVQCFeoMkWiBqw3MPj+DeOnq6s8suJiyQsKv0rTDSPHl3IWprdavLYIV19iZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB7680.namprd11.prod.outlook.com (2603:10b6:208:3fb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Wed, 30 Jul
 2025 01:21:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8964.026; Wed, 30 Jul 2025
 01:21:09 +0000
Date: Wed, 30 Jul 2025 09:20:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
	Vishal Annapurve <vannapurve@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Nikolay Borisov
	<nik.borisov@suse.com>
Subject: Re: [PATCH 3/5] KVM: Reject ioctls only if the VM is bugged, not
 simply marked dead
Message-ID: <aIlzeT+yFG2Tvb3/@intel.com>
References: <20250729193341.621487-1-seanjc@google.com>
 <20250729193341.621487-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250729193341.621487-4-seanjc@google.com>
X-ClientProxiedBy: SI2P153CA0018.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::9)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB7680:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f82b91e-f751-471b-9570-08ddcf075cdc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kHYVRsM8J2aWmWsZX1p5zKLDqREMGY1WezjknFDqpHcvGZpG42JQOcM59O08?=
 =?us-ascii?Q?MmS7Mj0no24VgQ4G0hzbJqko+u+teZqF8qpBiAi/X5YYsRNF4pjNIYQbR406?=
 =?us-ascii?Q?vIUmbLdtFSk9RfRF7dUWG+jL5zTtbJd0irpde1Rfe8bRZn7ajOBMUtRd02tB?=
 =?us-ascii?Q?2jHtcogLrzFf32y/fkcxmCIH8oM7Q6LaUBgOe7lzoKW7L8UMlyNYmKtgl7MW?=
 =?us-ascii?Q?Dq2+it7jGpDvitBslM9HJ3a5NN0/lNbLOJ7BH+kzKAE7vULBHTp/cz4hoMl+?=
 =?us-ascii?Q?w6IOoJJsHviUUZ47o2oBdEqoBMmIVr5B7WjOhSp1PbN2QT3NKDE4oAQzgT1Q?=
 =?us-ascii?Q?nKbMyifoowE3ALnv90otaC1J4aQf7OOvfiOz4WhUMmMkzk8ZC6SssIAePcM3?=
 =?us-ascii?Q?u91KjzClg7ZdisyV93o6hWzFKaaJHQc41tlKWAtqKkS5mhVxu2Zoo5runEtk?=
 =?us-ascii?Q?PE/0Oz/rfoBlR21bl+qxf/GbmgzNJBmVE4Gj6Lpprk5ujTi75Tup9IWF1K+i?=
 =?us-ascii?Q?y92piQ6x0fGMykKGUdfuDHPy96qhGX5wBCTz6e9AOhMT78OuFWuziYJcTr7/?=
 =?us-ascii?Q?iBSrIFb0abphUbWjeSjwIEcG8CuiQeUKV0UF+uA7BsnT2hOXA7DcpeGktbBu?=
 =?us-ascii?Q?g8Ur40nczDcsNjXIdI+YASYoGnzs66N3i8e0yzK3k6+Ikh2L66acpL+1NUF9?=
 =?us-ascii?Q?hwH8IXYviIEVNblXdBZrGE3M5dCtfcgaSdPRcmLUhN8RIXcq2JSRKg99xhtP?=
 =?us-ascii?Q?YZvPPzYCQk3sowkAQgGbM1dkD47X5iCbfwvsZdkUFHV8OJ4IsheRvKasB5dJ?=
 =?us-ascii?Q?YrSAmRIGfb3cS6/+qWsY76cERvvMl4mGOKaff0GZi0lokJIKR6akS5oDDBKm?=
 =?us-ascii?Q?FsDjj7UtM6AGH3DxX/l1synqHt/gfUUp7r+2+vzwUzDTxWy+kwL2hzwJdjm9?=
 =?us-ascii?Q?CO9T91f1qq/J2XWV/UaqPpsOHdtn6L9RaG1k8XQZ1xiY3zLtYJ9d/h7+jP2h?=
 =?us-ascii?Q?tmV8UsqzVzpf8sLFpclott3ZLsKV7d8mWk39dQbtw2DW04ZsIQFImS8pUNNs?=
 =?us-ascii?Q?GuE8uOgVxeUqfFzF5iOUNE+6pDaneRwYYtZAE2aTH140vZpMWXiLb0U5Nbp2?=
 =?us-ascii?Q?1477JTPbwUGmr0TM1d66foFJ5an0ZsNdWu64MeLq3wJDPFSxaJC6D8pdlBOt?=
 =?us-ascii?Q?L4SNKlxtyjQsltPlVducOm1VehtW4pA39ksmqBzyA5EchFQgIbzwiM0nKZDr?=
 =?us-ascii?Q?XkBbcfYXe9KX9fe5f+D7hih247Y7u8FzupteQDWLEzw3V9zHAI2agoYBR23C?=
 =?us-ascii?Q?TTTeleoZ2jweuIZE+DauaCyRfjOjGgP0uRqDqpTWNcRnGphatzDdfBrJ/G7v?=
 =?us-ascii?Q?/t+7mqPbIRncc7jDd6XlkRnXRBr7Luo05/v958/Q4gZjHJo34Ed02S9nxDoI?=
 =?us-ascii?Q?yC3nP9aEodI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NVx0tgdGkhHltf6LUDunFbvMPwtXeN0KsjfgjHcT/7KDhXGecZ9xKOzV113M?=
 =?us-ascii?Q?7QuXmoFP3YHeuSHBUoR4IIYVdr+nZYYpcMiXvGpvZ2h0ueF3IBYaHJDj94Rq?=
 =?us-ascii?Q?OLdk+4O64m9LgHLx2otwc3VJLso03fhmJ7gEk65UVmb5qokuaC87F/377MFa?=
 =?us-ascii?Q?kKf+Aq3Pgx8/m5Z0NSPk3BxkSSUAJ3fxs9qmw7WLCwxqhQ+tGxt530li2J2C?=
 =?us-ascii?Q?Ky3DAyYMBO2qXtfxlRXyb56Wtiv3SV9rU78UvcIqebEqRcjGPKDjn7rHeLt4?=
 =?us-ascii?Q?1ypaM3I+OCHyZIawecXFDF2nc/R+yeK5YGBUMeHRz9SdTTSeCHVp047IF7vC?=
 =?us-ascii?Q?FAXnU5HNs8hf0MDMae56xERaoV6t5Djv6clWnQnJD6U58NVP91KJkKSymOko?=
 =?us-ascii?Q?sKDYQb+qeOncY1rlgtXODS74IiMlYO2gA4tlpC96KAZmJwzChc/rDgemehmK?=
 =?us-ascii?Q?D3+4qkUNeFZJI6FRno4B7CakpRRL2dtCIS5ajtO2jQSgL9UA72gWRUyzgk+9?=
 =?us-ascii?Q?sQwiT4erYpmW5ThCvha5/tLH9DNmqXhm7KvIyp4zZbhp1o40IJAmnaysj/7x?=
 =?us-ascii?Q?RoLiDnGmnve1FXjTngSwxUa62CuUbbFW2rchLw3iFM/RDTWREP3EQ/ISbJoZ?=
 =?us-ascii?Q?Bd6ofTdGe8RmF5pt/g+n1odHHsFQ/AQFVhArh9+fdSd50lH5yiClWfeWsktF?=
 =?us-ascii?Q?t6CilFoSU4342m1dP6XAeDcRA+UWXm3x2YeF/wClIGZEkxy6y2Zt0bFQRg+L?=
 =?us-ascii?Q?NvSPGV1qv8P4AB1xBlenRzaJ/jH2yuh16rWGwXIgHS599BsnqUS/JMQFnrLL?=
 =?us-ascii?Q?ejaXAGk+znaYZwo3BhhG75/fgZksemd0w9BlzwpaeOXocAd/dO1YX7dBhcQT?=
 =?us-ascii?Q?nCFo+CPpyJ/PPXaV1zFyC/rteaoO+qSHl9JT88WdpoFT5PUxiZvCJd6Yumlb?=
 =?us-ascii?Q?JVQtRHU5IOunlGesmR8paW/BoCOZtEq5w8NP3tTV9y5h3jtBNTMm07Glkynr?=
 =?us-ascii?Q?B8W78ydBO3JNMQTDFKgEYwByQPSpZk0n4yQYAk5qN0pE13NI6Zl66skWHrWf?=
 =?us-ascii?Q?uljJE9acDTjUEVLU+Ri7bVkM3knGX/kvQoxa+2FEVrowh8Yq3nxk3QRFgO1I?=
 =?us-ascii?Q?6Jka9I8xH2GsefbmVpc9r6IntlKf088U9STlGuj1mW2oajxy3ku/vW12S2AI?=
 =?us-ascii?Q?p8agpdbqxtCoLbcBiG0An5sPnhz0nQNnlMgAUPUAb9cHu2D6PCA4pgHupHaZ?=
 =?us-ascii?Q?QIh7LxFre74ywzHCTIpQCLqoX8ORSlGRU7NUa6MJp3m0BvazmCEq+qxL79NY?=
 =?us-ascii?Q?RnpCFWRWxvRBjRUinp3Q6LC6TF11LSU+BcC/sm47pEEMfvGf8TMYdkY9zDtJ?=
 =?us-ascii?Q?2TWJJjqO2ytXOYpgcZ+NzR3vuZP8D2H0gXhbtJzuueGd3doskrWETHAiligM?=
 =?us-ascii?Q?xmTWJjok8zSSn+fbaQ8x3gnD4Dsf8VIli3bengz2l6UUyUbbGbFGb13Sf2c6?=
 =?us-ascii?Q?OIqsYyXXM5DZHOfW5olvz3kMsCLPpTH+nK+SQzLHDEriKceVAE1OmxUOufdG?=
 =?us-ascii?Q?yRd34lP47A+4S5kbQRQHQlR4c1g5Ln9iQtqVfHaj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f82b91e-f751-471b-9570-08ddcf075cdc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 01:21:09.0017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Ak8iO49AxWOZFakD6b5kdQtfr01kRHSrkTiBZhNO8DKaCkVQLpkxB/gDB/VS4wkXiw0uX+adA4XaujMuDnVgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7680
X-OriginatorOrg: intel.com

On Tue, Jul 29, 2025 at 12:33:38PM -0700, Sean Christopherson wrote:
>Relax the protection against interacting with a buggy KVM to only reject
>ioctls if the VM is bugged, i.e. allow userspace to invoke ioctls if KVM
>deliberately terminated the VM.  Drop kvm.vm_dead as there are no longer
>any readers, and KVM shouldn't rely on vm_dead for functional correctness.
>The only functional guarantees provided by kvm_vm_dead() come by way of
>KVM_REQ_VM_DEAD, which ensures that vCPU won't re-enter the guest.

If ioctls are allowed for dead VMs, would it be possible for userspace to
create a new vCPU and attempt to enter a dead VM? is this something KVM
should prevent?

>
>Practically speaking, this only affects x86, which uses kvm_vm_dead() to
>prevent running a VM whose resources have been partially freed or has run
>one or more of its vCPUs into an architecturally defined state.  In these
						  ^^^ undefined?

>cases, there is no (known) danger to KVM, the goal is purely to prevent
>entering the guest.
>
>As evidenced by commit ecf371f8b02d ("KVM: SVM: Reject SEV{-ES} intra host
>migration if vCPU creation is in-flight"), the restriction on invoking
>ioctls only blocks _new_ ioctls.  I.e. KVM mustn't rely on blocking ioctls
>for functional safety (whereas KVM_REQ_VM_DEAD is guaranteed to prevent
>vCPUs from entering the guest).

