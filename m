Return-Path: <kvm+bounces-39981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F03AAA4D3C7
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96F693A7F59
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEAC1F4E49;
	Tue,  4 Mar 2025 06:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="afnTi06G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5B81F4611;
	Tue,  4 Mar 2025 06:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741069361; cv=fail; b=McBjXGsHIQ4fuEnsxFAbEw0SyJcwnSFL8r3ewZVJY36yEGkubheKpTZY0aUuyeDHH5svsbL0bheIEf8Apika/EF+O3ZY/KXokecJxgDjiS1/oxpafCHzOrxyJT0NzOJNwTO7/5+uRy1UwcGn+eIpt7vWADXvZ04KS5kRpORm+Uc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741069361; c=relaxed/simple;
	bh=d7zODudGDtM06QgPeP4TUjhcwzyRSa7Tm/BFXyLry/U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tXQV4LPeOM9U8BOE/NEra/6Gg0uLCQHf7yyoE2ckvzDoObaHaU+K6OcABGKc4kxijgW4Ev5wASRxTVVQPNKsCkBcRlASs5ihQjbzVvu6cDJNIKJwWHhao/lnMeCzKYke8VGTQTVRfK8kb4o7JoVLCuKjOvvp+7JDiUmDSVlECAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=afnTi06G; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741069360; x=1772605360;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=d7zODudGDtM06QgPeP4TUjhcwzyRSa7Tm/BFXyLry/U=;
  b=afnTi06GYO5kMSCxvv35ivDHVbdRx/zbYvIwmkxHRQFmcOIEaTv4IhOk
   qgw3Y57ZsYzU5nCKH+aPowc9K+5QW1C30vCYUPGBm5pA+VOvS24Vn+rC1
   EftZsd0RoCuo5MtsM4NaK6D8Ppq40PJxAfPo6cHxkMr0GOqpNrePvl7Xc
   2I/L3yPWsluuqqnhsGFF8pKPG+mF5OW9fb+jEXw72VpQMls2wdUiuxhlK
   uWbJKRniPckA2E30FMCUb5bUxmgq80TogdlU8xt7NlpTRRHvkit4snmFS
   DdfZLNLsuWxcDU+c2El5gav0EzIHwlXwp7N+1d5vjiNjidKP4lxMnzrWx
   Q==;
X-CSE-ConnectionGUID: u7bljd1aR56lHRUv99Ks8Q==
X-CSE-MsgGUID: bFdCYVWOS2yJAx0gDLZIfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="52952107"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="52952107"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 22:22:40 -0800
X-CSE-ConnectionGUID: j1+kI5n3Qg63xXUhpd/3PQ==
X-CSE-MsgGUID: 74Rlkv92T+aX9c07fhSFmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="123220391"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 22:22:37 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 3 Mar 2025 22:22:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 3 Mar 2025 22:22:37 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 3 Mar 2025 22:22:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZZ12+fNcHBXw+OmVj13HDakVUOTBDuDdKI1GhbuDRX8VlQTKdHy4rFZC3c2QEEKnEGYdY81I3ITNBVn/txA82CzLRtoFswCzlF3XRG13Lh+gDBWS4WdTNKtR1E38go6geKyfbLwD6yA8h4NZdRLiGv5zd4FRfkChbITICE2knO4serSHSKSmEIS4uUZypPnPdS+LAr2iLN3jRsDlQHbBVAtMkywm0w3y34GdQPUZeqGe2TlmOh5Pum49ROz5d8i66w1OMDU09p3Q5bkgsqE/pFQ9tR05f3IBSN4OhG2CoLlfM119uva4Z7nSJYSMYjFPugu2lviB+msp7G39SmbJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0a0D3jSE/rGmud6P3H/vhYgdpZl8ybipk9Vbrv/Gj4c=;
 b=hzWq7CBN7chKovQ8n1NnN6U2vJ1TZX4W3SSeXHs3nM6bj2kNO4gWn4ZBeHNW4xS0BVRSdc7SgpFgAGeKU8CWR8e3sjfW2kCq3gDFWRG36JtZX+fwHvJsA1UfhhZY6BlFEtPYlZlQsTXG9oJPtCI1YZ47YV5Un7O3GAYprnTQxld55E3OW/hTR8JSz7VdTbh+vu99MtQ70M3h3VPZsiTnN8TCXNVV3koR2mTbvvvkeDMVzoGJ70fPPB3VyM7qiw/plcNfAN7Cy/yeKupOGL14v32pP51drO6c/AHEJCQeKzTvx3f4ouqepwirTWvKnODTEJIlF/1ZgW4gthaG/kfkHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by PH0PR11MB5784.namprd11.prod.outlook.com (2603:10b6:510:129::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Tue, 4 Mar
 2025 06:21:51 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%4]) with mapi id 15.20.8511.015; Tue, 4 Mar 2025
 06:21:51 +0000
Date: Tue, 4 Mar 2025 14:20:29 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 4/4] KVM: TDX: Always honor guest PAT on TDX enabled
 platforms
Message-ID: <Z8abrYiSJAX6mCTi@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-5-pbonzini@redhat.com>
 <Z8UGIryFjJ+msO6i@yzhao56-desk.sh.intel.com>
 <530fd31f-923b-4337-a9fb-76715eadc338@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <530fd31f-923b-4337-a9fb-76715eadc338@redhat.com>
X-ClientProxiedBy: SG2PR01CA0189.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|PH0PR11MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: 635d9c8b-dd13-4636-f876-08dd5ae4d99d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ywAKOYkinu3Bg5tjHdzK/LPjHoHMYykdHaXMsNeBLAMgToer3RouGcAjBxhK?=
 =?us-ascii?Q?qOcXyO2KPs7moBJk3hhQivanZ+7X1PYp59uQfTN8QyWsLpoOgCWAZBuN9ftQ?=
 =?us-ascii?Q?RjZeXixey1nhvy7lQUNPVTmS5vUprS7qzK+oOMbAZ6G9Ne06uz0WwX2/w1mj?=
 =?us-ascii?Q?iEaa4gQQPfuTfR2SImRSHQJr9Djukn2+v9Vh4met+e7DQgeT+RAypvNQPBXh?=
 =?us-ascii?Q?ud4QwgqGzVLogCoDGUxg7Cqz0Xyeb5pKKVcTH0SuCIRywp3KUzVy1L5rli8T?=
 =?us-ascii?Q?wH0IlR1nmRjPZWXc8m9aOH6tLsGniJqHC7Z1de01JfazKSfoD/UWTYAJPiqD?=
 =?us-ascii?Q?3o6pT9AGRaZ+zdG7XQi173R3bXMFi37hrqJYvQe8Z1JExdXQtzbEVgG1zksT?=
 =?us-ascii?Q?CINdPfIv8H3LPk5ikY2zBPDADA6DJ3KUpaoqwivP/EeBUkDbv8bLaaCnNl6N?=
 =?us-ascii?Q?EtRYTuc/EDYatJVXw9UT5PRTbzylRk6ZlQPf1qo1HXPGd86qwbX5P0s7kSg7?=
 =?us-ascii?Q?PbB+S3uU3B/5dd6T2GfgIyN2NV5Vg6pwk342idO/Ksrfu0+z0dxj0JOByLMJ?=
 =?us-ascii?Q?KYWmGbINCrHMRxRYFW9CRuqFnQccz0bxFWeGUrUny1un0aqPR4ZiFPzWqjql?=
 =?us-ascii?Q?h9CmgZNBEfeTwh6UHQPEAGF6KErjrmGfo94qXL7d4zQ23BrSenqN5x/Esdpm?=
 =?us-ascii?Q?HxBJH0fruvoDiEr76NIQ7IwyOYoL3C8FThtzSsTk6uzN8Jabkqp7PdqcvVb/?=
 =?us-ascii?Q?eB3U4kdgGXDJBgb9R6kaNBQuiy3x2izZTkCUZefvljhCvo+iEJMaqF/eMUZc?=
 =?us-ascii?Q?j+pRVvbNBKfKRx6l+k8b8+cKB26nPROYx2CELoK9/+rurgO7cZwGM3Omweq3?=
 =?us-ascii?Q?gk4TcDNCfYJyljK0NAsmBXcfqapVkxHtmUQIvpY7v2PzYt3T6Ykz7jsfw4Lv?=
 =?us-ascii?Q?ceLbwUN9d6QxlHmeoaktska/52wVT4+3vH3zG+Hn/Z8KSTVl3dqmB4i2FfRV?=
 =?us-ascii?Q?RkLzkUR+Dd8FVTyZsUfu6Wch6AEzKg/ijVBwPTHvix98joI/peCSjVv7GobM?=
 =?us-ascii?Q?3bbi1X5JK4wSkGhcgHu5dSCu8LR+9dRvj51r/xKbdJtkZU1RLqKdIh9GQi0A?=
 =?us-ascii?Q?XTshQiIatRWS5V7V/3Ud+nQTq5P2VUGMhW6h2r/HvL+8j8p3aUA01kKfPbCK?=
 =?us-ascii?Q?iRLIQIqzflp0rDoAhjJakhfUL0PEIb+gc7NJRS+xTDDNDdnkyOCFHMyDFJpJ?=
 =?us-ascii?Q?comn7Zc/oSykSQkp/zs5EdbYRjjLIDQevAdUFLmUMHF2NvoIcpmLobsrQ995?=
 =?us-ascii?Q?EQbu4QBE7TUeHkZFvJlQKWcVdB3Vy2+ecTJPn4ui/0EFAheHzgjm2/FWNTML?=
 =?us-ascii?Q?7o33bEmDBp1oOP+U6OyaqoMZsvwv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?usRNNtBTg+HvB8NIPxN4Xln/8rDJXfmTxZg9DTXr7yJtYmzqmpjeEeXKlTJG?=
 =?us-ascii?Q?z1/9Igb4Ks6J4w7ABhtRk7MIEQNsIye8/wWgGa1e1KqTL14LADVc2RjDqjLc?=
 =?us-ascii?Q?t1An+PJ7WOKsVHjyHV9Expi1kjNKxOPPUXHdO1NPaXjX/8EgNaaGEC017Ipq?=
 =?us-ascii?Q?p3VO609VIo3xBEWVWttQGwnk7WqfW2n80p7X1mt29MNKB5IhkjoZjcQKN46H?=
 =?us-ascii?Q?vFiy1yqaxtdq4q3MYgXojevduEoJd4D5+eummPOuK6+I7zEAlKZ6r/TdcbDi?=
 =?us-ascii?Q?bt4VN/6h5Uv4Af24LozNKJiBdkkslOc0Zlmx0iVj38DNgGFrf8bkDeDSRY9K?=
 =?us-ascii?Q?GRnCvXxTb6Z3tegQA/P0qvPe2jaIOS8zpU+U34VzXyipLv0DX1ArPLwLWVIC?=
 =?us-ascii?Q?AnPuwPOAjCO1CWOnuYP22p7A6afrfxX3WoCchO+rP0N+8eIEJvJwqelMTkHg?=
 =?us-ascii?Q?Ozb2kCncXral/R3nkYe1hwH91A8svfnh4QwYd8yLPiIJwXd5g8xC91LMFlZW?=
 =?us-ascii?Q?ipVldWunWsqCI38XENUWKJcItTdFEYxI/HW/VTNkhs5f6wJJj9jttCJba/F1?=
 =?us-ascii?Q?SWEaX2RNzNPvKm0k25zpTzYzImrL/cBmoe5iaXDGtBgWljP5r5RGbq2JJKV8?=
 =?us-ascii?Q?7yNTLM8eVLUpE7gVh7WeztiW3wLjR4qv8Fe9aTSzIS907QYcePQYpM2ZX4px?=
 =?us-ascii?Q?86icDGwDQH7j7UIEgO8ByGdhQjfEzRmPFIHC07b7ZRjiLDwDrdku8QmmhTTo?=
 =?us-ascii?Q?8HJfW7n+gFvB/jFU2zPHsq6qofCPpuV0/tAOEFPyrfh6nA3Mwjb8URq72yaC?=
 =?us-ascii?Q?Gw4e3LyqshxYfCWm9ZJ+/5eOc0ciCdNDCktCA9sUwO9h1unutMid01lM8mdL?=
 =?us-ascii?Q?Swx8BaIrqjCuQh9zwChcGQ3ZJ81zu9/6k1OWMSOSugRlNRgmskVigmuH9y2R?=
 =?us-ascii?Q?DtiwmdqRJhGLhJJWSoMaOIuNgNTm00QQ6kKVuFX4X/IS1G+EyP+EPFsgG1ZU?=
 =?us-ascii?Q?Tj6JQ/I4vWmlMTm6ZqL8xsRGviGCmZfqfJag8F3SmQb3mzbzBQoWhlWW2qkz?=
 =?us-ascii?Q?yBrg8Ba3tWboOI4oCSj9R8GqOBkyWPPqFjtmfSQ1Su4yPR2Vo8XOPOe0A8PL?=
 =?us-ascii?Q?Zm2zuObTe9s76M/NL3HzJqCNvAi/cYohjoEhaOGgQMwj6TF/kSveQLcWuxl9?=
 =?us-ascii?Q?oqjC4XUhOOxAQfnuqFREs7hgNs6aooMBJzZJETym5lPAdQ/J5spmzNHBwNtw?=
 =?us-ascii?Q?4nf1eVI3KDEqtXU05Pfjg9ayGnx8a8HPYfz41EiUIseHoDGfIY20AOdDGmjC?=
 =?us-ascii?Q?L3WGi1jIYSanApUojxsXMdlAGhY3261TVvWvAKc2Owp3r/dL4BB6Z8oN0CPT?=
 =?us-ascii?Q?fQWDzE37VlqulV3G43WptiHm1O67cjIdjFjHupElS8ZlBIV5Et0Gh1JMvqcC?=
 =?us-ascii?Q?VMFLzGwQRYo92RdVDAMFkZsgX5I3g6iqCcgJrhF6p0g2/c/yO1N9sMglmaWJ?=
 =?us-ascii?Q?cVSU5H/h1U+Xu6vWkok8j5qQjdFVhkmKeL7Zn55lQcsSrzMZJkuRviV4AlWM?=
 =?us-ascii?Q?kO/22kwD54rTqqMLvwGOIi6Y7klhZMVLJBumeDeR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 635d9c8b-dd13-4636-f876-08dd5ae4d99d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 06:21:51.5022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RiLmo5Rf3uOnZFlPuang4RKCXJi/TS0xPRqoa5Jd8iOBw731zJMs4h9nkq7OuMZ7zgbXJ0NijJMomv0ynXTISg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5784
X-OriginatorOrg: intel.com

On Mon, Mar 03, 2025 at 05:14:55PM +0100, Paolo Bonzini wrote:
> On 3/3/25 02:30, Yan Zhao wrote:
> > >   	kvm->arch.has_protected_state = true;
> > >   	kvm->arch.has_private_mem = true;
> > > +	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
> > Though the quirk is disabled by default in KVM in tdx_vm_init() for TDs, the
> > kvm->arch.disabled_quirks can be overwritten by a userspace specified value in
> > kvm_vm_ioctl_enable_cap().
> > "kvm->arch.disabled_quirks = cap->args[0] & kvm_caps.supported_quirks;"
> > 
> > So, when an old userspace tries to disable other quirks on this new KVM, it may
> > accidentally turn KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT into enabled for TDs, which
> > would cause SEPT being zapped when (de)attaching non-coherent devices.
> 
> Yeah, sorry about that - Xiaoyao also pointed it out and I should have
> noticed it---or marked the patches as RFC which they were.
> 
> > Could we force KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT to be disabled for TDs?
> > 
> > e.g.
> > 
> > tdx_vm_init
> >     kvm->arch.always_disabled_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
> > 
> > static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
> > {
> >          WARN_ON_ONCE(kvm->arch.always_disabled_quirk & kvm_caps.force_enabled_quirks);
> > 
> >          u64 disabled_quirks = kvm->arch.always_disabled_quirk | kvm->arch.disabled_quirks;
> >          return !(disabled_quirks & quirk) |
> >                 (kvm_caps.force_enabled_quirks & quirk);
> > }
> 
> We can change KVM_ENABLE_CAP(KVM_X86_DISABLE_QUIRKS), as well as QUIRKS2, to
> use "|=" instead of "=".
> 
> While this is technically a change in the API, the current implementation is
> just awful and I hope that no one is relying on it! This way, the
I think QEMU is not relying on it.

I considered making this change while writing the quirk SLOT_ZAP_ALL but gave it
up, thinking it might allow users to re-enable a quirk later on.

I'm glad you also see it as a bug:)

> "always_disabled_quirks" are not needed.
> 
> If the "|=" idea doesn't work out I agree that
> kvm->arch.always_disabled_quirk is needed.
> 
> Sending v3 shortly...
Thanks!

