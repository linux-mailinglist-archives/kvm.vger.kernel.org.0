Return-Path: <kvm+bounces-37809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 36F56A302F4
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 06:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 697D7188B33C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 05:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7201E572F;
	Tue, 11 Feb 2025 05:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nCwgCtps"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8873175D50;
	Tue, 11 Feb 2025 05:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739252404; cv=fail; b=d+8FpXkWT2gqWNlUUDY1YJrnd5Q560MCTph6taInqaKedXUnXci3LjAId+oxrYGZQ4j8HOpKZ5SNYjjE5kwnTLOB/yKzL3U27bdpUBV0dQLHhws0XixEMWO6GylCmoZOA6Bl1PIJYW4+NaRLjF+9l+ZELZmtAe2cfMqKr7017Q8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739252404; c=relaxed/simple;
	bh=r1FI2IR4lzZ2hlCFdWlPJTdKXOy2GID7av4QYyqR34I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LeaRzWWL9gnluJdc49BVOgzUcubiQBkuXuK9jiwmcSqUQE7e/UE0zXiWrCpJ/TbTmbbPIfRNOa0SD4Eoh2WSqDBccpMSe7OVmv9DfIvU7FWe+GZw7URPjOauvElU0OmR2OtdNTaSwUEXJskN5cHB1eCkzU9gZzH8yGE9Eya+g1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nCwgCtps; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739252403; x=1770788403;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=r1FI2IR4lzZ2hlCFdWlPJTdKXOy2GID7av4QYyqR34I=;
  b=nCwgCtpswVio9dT7YcTXKWWs1QPXxrljG+CoGBN1L/r3V1pWC6Dsp165
   NrUQVnnrg1w+RH/t3WG9ghOCXqtXJar/m2MTwIzmlEKI0nNQJ0fQpjhKw
   XfUQNhVFjxAyS/LrfT70cmYEQbVIq3OucaM95D+dn05Cd7K1CcKUCjSER
   YgcVHPF3I9fHOa5LAjHoJ1QdqbiNPqFPEI2Y8F9YGyCxHIOEPXLmF1Kow
   BcN/zfNIfaJ8e/IY/0sw7S+y2bShIRVOVYfiEadi7S0PnnzXo1SJuS2we
   /5P+vq2ObkkaYnh9rx5Uutr8o1ik4G/pacoBEpOwFzyR5ENiK0oLcGpRs
   A==;
X-CSE-ConnectionGUID: B+uS2iywR1m9HrW6qXqIfQ==
X-CSE-MsgGUID: qzKvQeyMQB+ZxiiQ5C6gNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="50492865"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="50492865"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 21:40:02 -0800
X-CSE-ConnectionGUID: IQxdnFeCTBmcghZ+XHBX3Q==
X-CSE-MsgGUID: +3Y+cnW8SgS+YxxAR+QfRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117023460"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Feb 2025 21:40:01 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 10 Feb 2025 21:40:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 10 Feb 2025 21:40:01 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Feb 2025 21:40:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MTW009hCkDtKx6VuIEn6NzvGm85TQ+4dFr2tYFPgUJl8fUc+PoZSjzdSNwWONbrUOkKfsjnVzTgbN7heABC8j6zLLnMYeW93yrR2RJH4cah5MoVmzmND2YzAwFU829Aj401YvyUcGhkwJSpKcMui87PweEb0pmENJfXW6Oip7hmU/wJWsbwgGD9byTp3Rek89tjlf21XqzGTNYzoIO9p++u0+2of+Ks1fYllCpJEWnlC/icffCUIVmSUikgZP1lvvG/LzvTwbtta31hjeSSrQkXevG1xg0zThz7N5IsbCcZlM/SzX+ra+8x/Z5fUWuCMsbFT+KKIBfaImjjLDVTN9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nk2beZ8p02L9mHxAjmWgharq+Ng4vu+axodiwBPOY78=;
 b=KUkW5L+3nKv8s42g5ukp+RYmqIh7GUfShJIjYM6sN47XyEUF3ki202aXcHcHWNc+gfk3HgTk3zWX3gyoIUQmIOMzmzEVAkHM69CZsK0S41BUCLayD5nxwXCH0Kr9ucTAMNM+sadkpMw4ozdDByt6YAS2HfwQUayqgriP9tehPFLywZWlR6C0+aYqR8QF/emJ15ZXX3vTvtgilOSCLB20n3be34FqmZdI3CO4w2fVzJoyCpwKKS/Z2//x+vZ41nGKYYbXJnohipge04YyU5NcEcbAZNKgyMSd9wZTAiZZVWN7IzaG+sV+ieRITpIKWTGsplu0Hnh2T2kUk2bkOMJx0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7873.namprd11.prod.outlook.com (2603:10b6:930:79::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.18; Tue, 11 Feb 2025 05:39:18 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 05:39:17 +0000
Date: Tue, 11 Feb 2025 13:38:08 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: x86/mmu: Free obsolete roots when pre-faulting
 SPTEs
Message-ID: <Z6riQMB9zsyCER65@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250207030640.1585-1-yan.y.zhao@intel.com>
 <20250207030931.1902-1-yan.y.zhao@intel.com>
 <Z6YixPh_j517vqcP@google.com>
 <Z6bJF8uA9R0x3QGp@yzhao56-desk.sh.intel.com>
 <Z6qApByaoCs_Y0eb@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z6qApByaoCs_Y0eb@google.com>
X-ClientProxiedBy: SI2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:4:186::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7873:EE_
X-MS-Office365-Filtering-Correlation-Id: 8af05383-3a1f-4b99-f1a8-08dd4a5e6d40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6E3f3FuL5R5yEstsg1buQu2eGMDjsvN2vXeYhMGy2eTjDBBoFDYwJt/ydQxl?=
 =?us-ascii?Q?dxxf1YokqUlAaAHmHBkwTBAoPOzyqtCfu61A8lVDS6BopxG1ZltrYSooC7X8?=
 =?us-ascii?Q?D8ZRfCT7hT553LnievVu5W+vv5VxKSff+gh7tcQZw04UjWS7uoSvkLIRcS1M?=
 =?us-ascii?Q?WYCzXR84UbAus412k9UeUxfKNsnWthdOxHrMOHbjrZo2siNCNpVdLC5rRJAl?=
 =?us-ascii?Q?Rw6wwBCw11b4cRqGw7WBSrEoJUlJjq9IiDi5PBznGsMJVecNnrE66lsLXtn8?=
 =?us-ascii?Q?eRM+h5waoH4VPBLJOZLytSe+cWGGvowSj7q0IyTsQVmHwfbQBjDAebzJOXdH?=
 =?us-ascii?Q?jTi/uga3zePFTH4Lvg81Z+OlImfDmVQPcS+WZ2LB7KCmrWdUFVsk5R680y0P?=
 =?us-ascii?Q?lGN8NQSxRMPRemTbvkYPp2Gvpsf/8Zx9PLs01MnmAPx1sfm5Oam2xLJW/OKc?=
 =?us-ascii?Q?bCS+iORMaIfgrIJTd0y/I9Us9TLyH0M/2yObs0qz18swQYf3sjmdWVf1xAtG?=
 =?us-ascii?Q?2QrjwT08drGHXYekuIYvoDxpoUjIR+VUYxFFElZSIeyibTaK0/I3y47BiUPV?=
 =?us-ascii?Q?H1qV9GDWow6LJe6SzTy5eDC1W5iO5EJJM1rhnnZwSAvAf0XV/0GDhrsZ4nyT?=
 =?us-ascii?Q?9WW+rlMSLFPRJCHM2P/Du7XcFEjovL+DyrRCKIYEeZcQaq43SCE6iyx489Hy?=
 =?us-ascii?Q?jXRtasKC8Gs0xHwQ2SfHmyJHlXEEn2mKPc+XdFPaw32UHKCbdOCb9ENFvbuX?=
 =?us-ascii?Q?LcJkUaPCLUpMN4Mup9D607HctFsYabYIBqxfbS1b2OkHkll06eZ8aqScWuBT?=
 =?us-ascii?Q?Qe2R0rOCkMl0sV4hgziwN6bituwc7pPbzZX94SHsEmpvt8IWsdjSapGMNagp?=
 =?us-ascii?Q?BSQEOZRKU0GDXbsLFRLmO5/D2CehGn/6F+eWDhqnvcyriLk5yUhewJ9RsX6Z?=
 =?us-ascii?Q?pO1pxMXFU+DgcnBqcATPCex31JDzdQLFXJB64lzY0kOl+X4ROZSa1Koi08FV?=
 =?us-ascii?Q?ALfhzN6wZ0+JvSy6WI+eU6R+4Td3bvcV3LZBMRQj+8rfvr2k7PDv4+ZPYPDv?=
 =?us-ascii?Q?3JLYfoV4qTlzxXtfsdqa1mrrVSvshP/Rjux03oZcHSy13mg0QS+B2elgx8cb?=
 =?us-ascii?Q?iod9NCLywjMao6eAYM8Z89TxQdlEqOiw+f9C5Oru6I3elmoi+hpHwsTB9DMU?=
 =?us-ascii?Q?fblwQ1xu/LeOoOjU6JvwBKf069UFqYsCwR5eEoil7IEIfx0ERSfro3a9SjxU?=
 =?us-ascii?Q?3hz8Ngdw1NKgqq7AeVXnoMU6p4mTAlL71Zh0CJHWfTemtsvQy7S/UFY7lCtN?=
 =?us-ascii?Q?LybGxMft+8OmDj0lyXzrbj6cKhtYmsbZMmC98+HvVJybPHZzDV9sU/e0PzPt?=
 =?us-ascii?Q?7WerkbqGJP6Eot/oJ0Rse6zgOQXe?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eWx8CWQamuhBltNz1drWLZzoAUVZVQ4YwmQVWR64e6PaPV2iHOsDkKq39grk?=
 =?us-ascii?Q?Nm0CsTYy8IozDUIpz1pJaLWulYXvheKOIjYgFHBWcxA8MHb/sraCCNaxGtR5?=
 =?us-ascii?Q?+yDzK58HK3LblvV25o0paOGpWiD92A85fVPat2Y/Cv27rcvaBa1Vm8tB+Drx?=
 =?us-ascii?Q?VFCsAdv9LUTJLRAazJMfeZaDP/J5c2lLIxAfNRlSl32eiSL8xMDc1fjg+TW/?=
 =?us-ascii?Q?BgY11T4aI/v1gt0e33pqZ/jzbBGvKN38oJrvx2c21PN2DeII2FAUbBP1R6PJ?=
 =?us-ascii?Q?lRpQWq4M5S5JZcb5fyggx4RLigzx9L05uBt9VkAOaph9sIBE27oehj7FCB/w?=
 =?us-ascii?Q?SyWZTvUoRvdb8byIKRgyzwBIyuwYWQ04L+gFDlsGizWujdb86cgmzxGTWUs0?=
 =?us-ascii?Q?O0u7Kve6azLnMWk4o/gJVDtQoU5FZWKtqaNT0SxFKHMNGBerMsr3mLilPgmB?=
 =?us-ascii?Q?3VczMIGFZXYV6ooIcNnu27cExAsLY2atpW+EAhfD/SgSELHZoW+ovlLeiOe2?=
 =?us-ascii?Q?KdCIeGQ5pFYRC/UIusccDXcsouxwztMo644sVEqs3ch4JAxYC1hEBGjVlqop?=
 =?us-ascii?Q?TpBXHoEwzHsI2pV3qAkLDvv48AGFktoRft5CAcONnVEOWPw3wB1ngkMCc+G5?=
 =?us-ascii?Q?XBLdvnNq1UeUqyu/lDaOaaZGIxa3Zlarr/zfRM3AiLLkpsQr+O6kRB5+cq/N?=
 =?us-ascii?Q?mDLdYRMsEgyKqm1CLBnvS5TsjdyE7JJu3TPG5Dj7k+b58oQ9HpDrdbVz492K?=
 =?us-ascii?Q?tjuuOv1eENmvJrvLEP+wu7ZovBpZuqMPygPRxrDUEQBHW0H2y4v7BwmQH3HD?=
 =?us-ascii?Q?IWtjUsoi+bgckWfVThPU95WcIW0eR1Gi2C4Ez3x4HZ4gQWvgYxmp13AD7Osw?=
 =?us-ascii?Q?sSg/FN+UYjoOr//WphTk4mGteQVkPLcUkuGreEtGbY1cwTljwrhkvxEpcqCY?=
 =?us-ascii?Q?U6PkumLoHzuhh+0GP+647gzumROQ483l/G3ywO8IGWQxreYzm6+kw7A/g+wE?=
 =?us-ascii?Q?jZV9wm9MU9dyICdXjpK7DMyYJwAuTvhfTo9g677WN0o3tZfslh8A3nUSLEE5?=
 =?us-ascii?Q?1bYG60c97zoJl77mlmj/vxDzbYzjbZBflGhQTMwT2bII0mEc+7m8MDicM7ja?=
 =?us-ascii?Q?iJR4msWxXrkg8tVG9CsHnEyyroxwSk8CCUBfM+5uxqEjw7gPWKq5PAoWmpRV?=
 =?us-ascii?Q?+8+hCZSkqmPv5gtJdtR5upzV6JqHNM+i1SJFet3A67vE+iaQjeR75dCvyeOc?=
 =?us-ascii?Q?2PS2i7qNQl6P3hNeUYe9nTRr9sefaCyZgmUMTxAhXHfPFaRxPD4CKc8Q0w+A?=
 =?us-ascii?Q?wOGDOyN9ZoC6UbbX07AmVu5sOXZEcqxxqB1j0KafHY6gzuhmUuwokCCLr0HC?=
 =?us-ascii?Q?1KAz0n/3K7uZVG1fZid45Xz+PmC+Yvh5bEk70e26HofhcTfmuFAjxExxUSaR?=
 =?us-ascii?Q?l2zW+I+aC1RhDaD9Zo1S/WF2dUD5rzzBI0QAGzi/mlQVeUXMcwnMMqx0UPu7?=
 =?us-ascii?Q?hVXW6nj0k4gd6YtCcRHe1SpoOSfOz8qQgZEwxVpPIzv0rGmytZ6ZCy7BPnQb?=
 =?us-ascii?Q?lNnwuYw3Ni46jGAstEltgpjj82sWBwuM3ELZSVm2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af05383-3a1f-4b99-f1a8-08dd4a5e6d40
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 05:39:17.8974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQ509Afem37egpm2L0XEFL+eGwHedUpwOBGn1PMzc9/jZasNbRHhNRJgYTLS2Rudf4mWWgUqfrYkUpwCYVZYiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7873
X-OriginatorOrg: intel.com

On Mon, Feb 10, 2025 at 02:41:40PM -0800, Sean Christopherson wrote:
> On Sat, Feb 08, 2025, Yan Zhao wrote:
> > On Fri, Feb 07, 2025 at 07:12:04AM -0800, Sean Christopherson wrote:
> > > On Fri, Feb 07, 2025, Yan Zhao wrote:
> > > > Always free obsolete roots when pre-faulting SPTEs in case it's called
> > > > after a root is invalidated (e.g., by memslot removal) but before any
> > > > vcpu_enter_guest() processing of KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.
> > > > 
> > > > Lack of kvm_mmu_free_obsolete_roots() in this scenario can lead to
> > > > kvm_mmu_reload() failing to load a new root if the current root hpa is an
> > > > obsolete root (which is not INVALID_PAGE). Consequently,
> > > > kvm_arch_vcpu_pre_fault_memory() will retry infinitely due to the checking
> > > > of is_page_fault_stale().
> > > > 
> > > > It's safe to call kvm_mmu_free_obsolete_roots() even if there are no
> > > > obsolete roots or if it's called a second time when vcpu_enter_guest()
> > > > later processes KVM_REQ_MMU_FREE_OBSOLETE_ROOTS. This is because
> > > > kvm_mmu_free_obsolete_roots() sets an obsolete root to INVALID_PAGE and
> > > > will do nothing to an INVALID_PAGE.
> > > 
> > > Why is userspace changing memslots while prefaulting?
> > It currently only exists in the kvm selftest (written by myself...)
> > Not sure if there's any real use case like this.
> 
> It's decidedly odd.  I asked, because maybe there's a way we can disallow the
> scenario.  Doing that without making things more complex than simply handling
> obsolete roots is probably a fool's errand though.
Hmm, maybe it's not wise to do it like this.
But it also looks not desired to disallow slot changes between two prefault
ioctls.

Rather than always prefaulting after memslots are finalized, not sure if any
userspace implementation would follow a pattern like
"add a memslot, perform a prefault". Then if a memslot is removed somehow
between two "add and prefault", the second prefault ioctl would get stuck.

> 
> > > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 47fd3712afe6..72f68458049a 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -4740,7 +4740,12 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> > > >  	/*
> > > >  	 * reload is efficient when called repeatedly, so we can do it on
> > > >  	 * every iteration.
> > > > +	 * Before reload, free obsolete roots in case the prefault is called
> > > > +	 * after a root is invalidated (e.g., by memslot removal) but
> > > > +	 * before any vcpu_enter_guest() processing of
> > > > +	 * KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.
> > > >  	 */
> > > > +	kvm_mmu_free_obsolete_roots(vcpu);
> > > >  	r = kvm_mmu_reload(vcpu);
> > > >  	if (r)
> > > >  		return r;
> > > 
> > > I would prefer to do check for obsolete roots in kvm_mmu_reload() itself, but
> > Yes, it's better!
> > I previously considered doing in this way, but I was afraid to introduce
> > overhead (the extra compare) to kvm_mmu_reload(), which is called quite
> > frequently.
> > 
> > But maybe we can remove the check in vcpu_enter_guest() to reduce the overhead?
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b2d9a16fd4d3..6a1f2780a094 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10731,8 +10731,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >                                 goto out;
> >                         }
> >                 }
> > -               if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
> > -                       kvm_mmu_free_obsolete_roots(vcpu);
> >                 if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
> >                         __kvm_migrate_timers(vcpu);
> >                 if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
> > 
> > > keep the main kvm_check_request() so that the common case handles the resulting
> > > TLB flush without having to loop back around in vcpu_enter_guest().
> > Hmm, I'm a little confused.
> > What's is the resulting TLB flush?
> 
> For the common case where KVM_REQ_MMU_FREE_OBSOLETE_ROOTS is pending before
> vcpu_enter_guest, kvm_mmu_free_obsolete_roots() may trigger KVM_REQ_TLB_FLUSH
> via kvm_mmu_commit_zap_page().  Processing KVM_REQ_MMU_FREE_OBSOLETE_ROOTS before
> KVM_REQ_TLB_FLUSH means vcpu_enter_guest() doesn't have to "abort" and redo the
> whole loop (the newly pending request won't be detected until kvm_vcpu_exit_request(),
> which isn't that late in the entry sequence, but there is a decent amount of work
> that needs to be undone).
Thanks a lot for such detailed explanation!

> On the other hand, the cost of kvm_check_request(), especially a check that's
> guarded by kvm_request_pending(), is negligible.
> 
> That said, obsolete roots shouldn't actually require a TLB flush.  E.g. the TDP
> MMU hasn't flushed invalid roots since commit fcdffe97f80e ("KVM: x86/mmu: Don't
> do TLB flush when zappings SPTEs in invalid roots").  I'd have to think more about
> whether or not that's safe/correct for the shadow MMU though.
For shadow MMU, I think it's safe to skip the remote TLB flush in
kvm_mmu_commit_zap_page() for an obsolete root, because kvm_mmu_zap_all_fast()
is the only place to toggle mmu_valid_gen. kvm_mmu_zap_all_fast() makes all
active sps obsolete after this toggle and kicks off all vCPUs after that. So,
the kvm_x86_call(flush_tlb_current)() is able to carry the TLB flush in each
vCPU if kvm_mmu_load() is invoked.

> For this case, I think it makes sense to just add the check in kvm_mmu_reload().
Got it!

