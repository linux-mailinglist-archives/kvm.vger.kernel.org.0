Return-Path: <kvm+bounces-35276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA240A0B331
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 10:39:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA0E4167B0A
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 09:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1BC4235C1E;
	Mon, 13 Jan 2025 09:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZWFqVOV0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037E0235C15;
	Mon, 13 Jan 2025 09:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736760746; cv=fail; b=C5Y8AMwQowtcabDjJze9bqUHvs5DKodW/op9zc0BhOVpKKFQ/6wclArK9d7pv0YrTEsHuwfBU76s0tCggqArJKXzfxyqUzYra6awUay5xPkJhQmnBaSULJHgLXD4qWWftL1JGa4SK0CVhhJWTwWKghqA80sdT27wQ6qV4CsyLbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736760746; c=relaxed/simple;
	bh=uGfV2esi5BDY8MAMkO5TgqP8Uj4YedwnC0Jff4CrkvQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=B2AkodHkT1xMKnFoauSEzCaA20WY2itCJGzulNnTLlS4YZW+rBTet3VASkS4aBI9PB+CNxLPQAzqYw1GI+30j8CoMRxIBlyDCZ7p5RNQwWNBq09B3FFkU7EAr01dvPyHmW5hK4ajtz87LIfhX4Z0moK4e+xF6dRisGJOF+1Qs40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZWFqVOV0; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736760745; x=1768296745;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uGfV2esi5BDY8MAMkO5TgqP8Uj4YedwnC0Jff4CrkvQ=;
  b=ZWFqVOV0l0E0y/jXcne3Ej1nK2ck0o6nqE0EHay9ON6TQSsAeplKnlOn
   mVloUuIAVKSJiml0X4xoDAqe+XhxPuRlojVK4Zoti+5KUIwoOrQpqB+FY
   M66JYaeBYa4FRLnlf2jJPqLppeA+lt7cYCWv3+eAQpiUApzF9ebvtIEo7
   bhJBuRKgBclh3d7sv9+nYLztQd/9jItAS55dHcSVuSG0Y5VjVrwjGjhe9
   vspIY09Ctuk4T2tGaQJVTY3uUvCgHTMYM3EwF0c9FmXpcFX9TPRIfHm6V
   wLeZCOTxDAHfQC1YT4B5Vx5Fwr98TIo5lmLwBXKYlpKiwl2xKneLwNe/v
   g==;
X-CSE-ConnectionGUID: 4yUDz0v3SEmis69IRwRA7A==
X-CSE-MsgGUID: 8xBwZDGIQeaEZJFOKw0dOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="36894048"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="36894048"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 01:32:23 -0800
X-CSE-ConnectionGUID: iXtLlpExT1Kl+ZPLfMJZwA==
X-CSE-MsgGUID: b8K8wbjAQ8C0XTQMaJ44TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104213438"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jan 2025 01:32:24 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 13 Jan 2025 01:32:23 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 13 Jan 2025 01:32:23 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 13 Jan 2025 01:32:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vWGn+t1OjJF/hwTSXOqmXYX2X/oijpZElGvQi9WIrlr5cKrRhug1KS1r6w9BGqb4xYY5zsl0M2UZEtNCLYv8r6KYkVc9+3VyW4jxQ9I085NU6OZF2OJptjau8/iaox+jPxqHF2EA2cAGeCXFiLeXSjLWZSFkbFnBGNscpN0CIvYf8+02RiY6X1xL5c2ukqGZxg43UMxDZ1rO3HH/iOuRnVZp27EyhIbm4CTxYjmOHdk+rWRhZ0f8BtvBqVH/v/KuFE68AuvNP/pnpw83Qg/lznDjeXm+lJ28AAKpq+F3PEd4iqwHUEs6Wv0s5NdXBs+wMWW3ula2h7ITmHfdsEDzng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7X/Pw0DwQde8E3bqy2Rwg4uU2GUFtXH1KtBQ/02SRk=;
 b=YTNuTTV1prD2X/b7h0xmsj7/O82lNCztQj3Hb/ue7CwQPwDKa7d8b7U9o71MNtp6ud1gL8bK+F99UKcWEiVnM+7Y8Gbj3+PAUUF7Xr/6zfm+4BrekMLpJD2nSNNko7hIlJqZAAorbPus6BdeBWynUH6d3d3CRR+H3Y2GFva5RFBeN2J4Djd3XpuTK9Sj5taJiDUQY98qk78DzlISy6SSs9aHkCh/PgrZGcXCNTY6tAaggC9dLzIcs2KzKLFsUsly8LfRMEs8cyV9JJcPFqgizujZG8Ww+XE9ZcJhNwTVafTx6DuMFpnH6dc3If524Nyul6rlK53QelZkfQOSt7BnXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6981.namprd11.prod.outlook.com (2603:10b6:303:229::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 09:32:16 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 09:32:16 +0000
Date: Mon, 13 Jan 2025 17:31:23 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
Subject: Re: [PATCH 2/5] KVM: Bail from the dirty ring reset flow if a signal
 is pending
Message-ID: <Z4TdaxQwMuA7NM5g@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250111010409.1252942-1-seanjc@google.com>
 <20250111010409.1252942-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250111010409.1252942-3-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: e846f38e-2f47-4ad4-f1de-08dd33b52b25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ia5c6x60HJaB/O1cqo9qkCIBRbyCVq4u78tFOrDwhhZRb6S6qru/FnHUHXNV?=
 =?us-ascii?Q?HR1kH53hERgszADp2t3vv9GA1oh1sY6f7Pmaj1/NKmnYMr1zdMQ8ZYOxtzAD?=
 =?us-ascii?Q?krP63BjDdcNAQXSz8+Ay5iGDznO269Q7GR6VZ+t1E/RNpYjwY8ojUXgFxCbH?=
 =?us-ascii?Q?XBC49GMPDD8u9rsdrHHiv7iuOltHw3ivMYvzfJ3FPQ1Dv87w3eg0lZwVeEia?=
 =?us-ascii?Q?EpnyHw6v3Qm5G11ay+qB4/NPgG3Pz+DTzFN062/MLA6Nml969KKc/eZWxS6f?=
 =?us-ascii?Q?jdVUzQGOgkI7r+1XIN9ROooZHbvZyDdFDc3JQA8fra9X+Lf77QfQRca28jIZ?=
 =?us-ascii?Q?JMQZRCLG+cQtQpxtLyUMtN1NrDmz7b5O0eQKpVh9XtT1flwecJUeMWgnvfat?=
 =?us-ascii?Q?fEDOrswxHN6ya3uV9jSCrhzQBWJ+DaA0cQKu4W6xSvFE+9IRZWceunWYlf4g?=
 =?us-ascii?Q?howVCwb9qnOokdPK+sIg9QvedxTPbEQCQ14BQqbAduwTI2BlZAqeIKmF1mrc?=
 =?us-ascii?Q?KoiJelKbZhmzt3KQqooeH9pnFAGzS41+zKgpnE5Vd+smIZX9177fyujU8B8q?=
 =?us-ascii?Q?HcRLkBDWfBswP6i32MOv3QKFAXe1PhdvCU/JbsH888EW3Z0XJM0UnG1wINob?=
 =?us-ascii?Q?J7UpPOKI49c9oGtsOI8EzM9sj0LF+2nrjuJxOwkLO7S8TR4a5R4gDyogWDpq?=
 =?us-ascii?Q?oRJfdi+H/DqON0ey4N8BaroFp8EmAZFeixYoI/KXF7hsVWkV6Q7DqYvNCXS7?=
 =?us-ascii?Q?W5z10oMNli1TA3ISl47w6glriowh3Vz/ZN7ACeYD4fu0EwacGc7ODmce8hqD?=
 =?us-ascii?Q?RYz4xBfVXR8PqC/k8Wvx4XDbcU2VKWe72gtHXPGgLmnVVHMiFk7eRTjfOOeS?=
 =?us-ascii?Q?POHuMVOp2jBfTENzau7MRQgt6Jxx7Ofc12I6yRYFmuIhDwXr+qkJNWIecU0q?=
 =?us-ascii?Q?QfyN311Jmy772YmmoEVEXcBY6csRnRg69xL7hwWRzBvjHVADjAe4N2W9/Jrc?=
 =?us-ascii?Q?djSTn9RXm1rZdO2KRnawOWaDH3zuOaWuh2Gexb+WhDc1u4DadFZVoHFB6CFp?=
 =?us-ascii?Q?UjZ8rECJvVL0xZYJT4PHadu//v6DgTdMMJH5zGvxiy7UBiv/VuSOiyFcazQQ?=
 =?us-ascii?Q?wGvmXLBmoqNGBH114QDQSs+wSoXoRjWPZUHOGmDdP0xra//mARQVuLmmwI/5?=
 =?us-ascii?Q?mTiPYtDBR36eSyM0T5AXqGuAMIKWhoWaMhXDOC+Igd48Nb6hSO26Vy/1xI15?=
 =?us-ascii?Q?V16d3fm92UhGZYnjzqK6sziIEzYYwkl0UsXZBKPugFz/RgUPxUrO4jaFGnO0?=
 =?us-ascii?Q?1CvesCO9Uc5oHj23PrlP+BK4TjPVrfs13k+rUVQuQJcdKQkmnfT0vvFCHZWz?=
 =?us-ascii?Q?mFmZviV/9Ycx6Ui28tckciXJCKw+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wROQFnp5lE9kk7GOxoer0hp0hEJdIyXHqsuNGrxJc3It4MjKC6+tJD77ebUu?=
 =?us-ascii?Q?OW1nhxA63VNIitHRoTvYzzyILvsC68jvlsfQq580DaybQkxVdwKaJWFgXJN2?=
 =?us-ascii?Q?KaQkZR921OnUUJljEI4EQ2gF65y1kkZU1LCB6ypHqVy9E8g8YAKSf97ywNO0?=
 =?us-ascii?Q?El2Vxn31a6fSlFNCOXGeWuJACDU/MTOZ2fEVx2KgQMZp29s6d9M900cCGzCy?=
 =?us-ascii?Q?0lwY96rZGvUXTXrHwc0OmaeSkmf1uCIUlPrnAXO3H2X5pb8JfGu8bUHi8PFC?=
 =?us-ascii?Q?nIUAH+gR5WWGsMtHi9BOCM17xA9HKkS/jL28b5ByVl0Lnrf0FkTncY1+J5bP?=
 =?us-ascii?Q?glXIS2bCoIRMTWL6Q/lixmgPjnZ1AmI1txiEryCRtBDD0XH7ul+WNnpf2CXV?=
 =?us-ascii?Q?AraJ8+hAmvxK56VLbMsldXRHts8IoUvGYC9zJmBTt7acw5OlfX+3tZ+pIndK?=
 =?us-ascii?Q?GfQQ5Ft+wxqXfb6KYLsAammFhA3oP1mqZn0GdbNq2TkAbrc3QV1DOFqBfS9c?=
 =?us-ascii?Q?xK/kh8eLblurHFaSLxR6dXUfaAi8dyaFk3GEkPDm6PuOiyIqrDQlWh8tIxYj?=
 =?us-ascii?Q?PO4xJVwpVAOX+TXx2916VrK5B0RsLtpr2L7l+KAMx9lJShqtJY/ikadDf1rs?=
 =?us-ascii?Q?zIOJbaMRaOApAuZE9AsdkaEgKUqHKg9KVQju1llHCTkfncU6dkqHRkyCmgFI?=
 =?us-ascii?Q?5UeQYwJgFSP66KMUrYmMbJ7FCkhvrvBoquK0NGwT4NH6dZ32pAaG7eIH9gbZ?=
 =?us-ascii?Q?rse/RTJvZEnaV+yewTkz7D4X5Gz5nsqNetWwYUYzNWByepv1QDDnZ6hnRLQG?=
 =?us-ascii?Q?cu69wHWh5wE5IYO/TlZ1O12nV9wkEcXhT7VBFz2wei60M2XD7+xXh9GPwYJ3?=
 =?us-ascii?Q?js8BIqvNm1c0wkrdNDI94CB7wtSEqiBq0Km6e0N3Asktz+uYnzIMzEfhz36z?=
 =?us-ascii?Q?K2K2nWX6W4knAWFLqEr41Sl5vpOLgRb9rVE65GoysEmiEg+SnaFs+jm+0yvP?=
 =?us-ascii?Q?yp336s/lBVw2zAEB0clvmb37r+W22Hyy7fPMjBq/bZLsnLSLB/atpSwqIGxa?=
 =?us-ascii?Q?+z20umAKL2XtMQbF4ryBZGxRxog/7Wrza8NSkAeioDEJ3HgcjrVtC5fCzyCD?=
 =?us-ascii?Q?fCEenP+0i7tTeTo16UzpzP8E9KYy+CQXluJofHVkEGqWVmIvA5tJJIn8t4Tl?=
 =?us-ascii?Q?hOssRtC91CubWO4/nJVO6UbUKAJMWtqSSgawqmp/0QFAuo6zhMMpmmBuLRpD?=
 =?us-ascii?Q?vrK87NfRsY/PSSld0nVJAegvQc4drJp59X8UOSsJ7dEIxywz5Dlp8WcStJjR?=
 =?us-ascii?Q?hDRGAu+laZxbC169EPi9bAVq2OiHP6bG21R3UIVH26FKlYlYGa84wPPK8rOr?=
 =?us-ascii?Q?RFASEALdkOpRLKXU0ps+t/vT4966lTqEeAyeZjcUY2jV4Whvnf2kY9o79xa7?=
 =?us-ascii?Q?tjeNOrdfZjbWQeli3NOHVl6V1XCiczlP8D+bfB5teFCUwL/h+r14tYAF2V5X?=
 =?us-ascii?Q?dqm0G3EPAWU5RdKh4lnbCXrQpUtRvgWzpdsusoTy0dHsPu2CE2bpUiZ66Z4D?=
 =?us-ascii?Q?MI7Zkky8eB9Ci4HNud6umpH5GXICIAnToOem7cTn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e846f38e-2f47-4ad4-f1de-08dd33b52b25
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 09:32:16.3495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 84t721wRKxb0K9aZ+nWL2xumSbAU/0fe4agvx9qQK30xya580wXoDb5YtW52cDXnc8SqlIunQcrssiaE9gvZTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6981
X-OriginatorOrg: intel.com

On Fri, Jan 10, 2025 at 05:04:06PM -0800, Sean Christopherson wrote:
> Abort a dirty ring reset if the current task has a pending signal, as the
> hard limit of INT_MAX entries doesn't ensure KVM will respond to a signal
> in a timely fashion.
> 
> Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/dirty_ring.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 2faf894dec5a..a81ad17d5eef 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -117,6 +117,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>  	cur_slot = cur_offset = mask = 0;
>  
>  	while (likely((*nr_entries_reset) < INT_MAX)) {
> +		if (signal_pending(current))
> +			return -EINTR;
Will it break the userspace when a signal is pending? e.g. QEMU might report an
error like
"kvm_dirty_ring_reap_locked: Assertion `ret == total' failed".

>  		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
>  
>  		if (!kvm_dirty_gfn_harvested(entry))
> -- 
> 2.47.1.613.gc27f4b7a9f-goog
> 

