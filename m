Return-Path: <kvm+bounces-39538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0DAA4755C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 06:47:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE3C73AFAF2
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 05:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5391D214A96;
	Thu, 27 Feb 2025 05:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2HR8o0K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C39423C9;
	Thu, 27 Feb 2025 05:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740635237; cv=fail; b=PNb1haTZm8Luf9+QvlPlaZ083oB8LkmXR5tx2Ste2nAOZLDAoUxdoskfNeoQGpm3RzhfNPjkIxGp1B8aZHEpwnrwYwnA/B/lIAxgiEWVlY6+JqqxxORZobT2m69699LyLxXrPYrkV6tGIN+rzgQFGJr9rjmYQrAXMtbt1DB0jD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740635237; c=relaxed/simple;
	bh=2Dk92Xq5lmtwIXlVb2oW0MUaW9qdLRicP9wlDhtNNSk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OD5RaZLU4k1AYO6lgqDqgMy0kLLImMI7wGLfsumDhgIG63dFRfrtwzRAxXhvxMw4MB3zSiU77vCJcyKm7beWEpSXeoRKQbxkSVydUefL9K5MO6WHykFRScLdYe3Rra9yenyzIzEbp5nDVeUs4IhhFHfpJbHDM2LfH+IuqwWnNjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d2HR8o0K; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740635235; x=1772171235;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2Dk92Xq5lmtwIXlVb2oW0MUaW9qdLRicP9wlDhtNNSk=;
  b=d2HR8o0KYBAliDIDhFZ46PtbPW6JEq/peM8MmpFfL5/eaTf6OgAQxDgh
   0wIs70mcqnqLBEvA802R0MIUEl2tEQA7fqJXHqR6+mwoUA+E6WeJQaK7n
   djGYWw0RgkqBN+OQk/l4KBV8zJJvZdQ6f4PG6rDXzk7sXGHbj90NVPjdT
   0EOBALNkzdiyd69WN/Jles4PCBTdMD+T2Ylu0pH7ySccSHCDqo5FdpBl6
   OOdJ5oJSEbaS2ZkoVxxVo2+AsU6sD+AUuDSaQm2uc/vu7/Ff8WuWX3uQE
   jh5rTnchET1Hlfj/OEivpdD/T/3uJ+DW2EpSVpFM00gaFUGpvcGg3g590
   w==;
X-CSE-ConnectionGUID: aB+N7RRMQkq92/iOlDohXA==
X-CSE-MsgGUID: JC5CcjdQSQ+KBKbQSGZp5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="52147871"
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="52147871"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 21:47:14 -0800
X-CSE-ConnectionGUID: R9iZeSVlScqlIQp9mEiC2A==
X-CSE-MsgGUID: vGYBwmpyTR6QolpB5HTDJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="121517697"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 21:47:13 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 26 Feb 2025 21:47:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 26 Feb 2025 21:47:13 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 26 Feb 2025 21:47:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zb+dfAW7W4MDlRv/qVQ2cNd6B1ndu0KbrIAj54E0qrsH+mj1Fd8ipbMCIPa0KOnGlV1Nnm+noCqivAVq+V7ogmCGCR2GjUfGwihqc62jcD1YyMaj653HyKbRoluJI3u9Tirk8BtaxbERz7jvU7wqvYXjTpsAQWjhXFnsG78E4Z8tvn40lqxjMQM83yawRWs2847WN1obg0eaAEWJwpIljoPwy+S2WQ9QhGZ2RCSUmtVt4N3mLQjYdTh600tuTz4+eVwU8XjnvjIYJ+rkTNmvLCQysntV1cW/1hqvP80viDvuYCJeZtWyq6ZlDz2p2nJSvfbhJFahGL4QVduLkl1uYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KAkW+l0Lza8Qsq8Rtzfn4X0Or8CEGqcC69kWnS43+Xc=;
 b=fjcjXobdrKNGXzTvzoFQP+N+BT0YiAgtrDsOlmX+Gx51kHriuumwYwJUQ6qHXU9o60yTfXi9USQ6vQU1KYIO+tc10MleMx+4Q09Pe6q+ItHIZgCWkvBqyFbu0bWXRVSSQn6Odz3XFaRv9OOthWBVlO0YyPxUt96QMQxv+Dy99ddxxvIsjun6Vu9tEFuMIgYhVWxqX/wx9+Yn0w2B9VrSagKfyhDQvkZYLUoEKMCoq664c9Cf5wU9r1JgSqbRyYqX95b0VMte0e5KRBKkvTgLZHqWaSy+0J1fwNyebGgGxq5RdwthcPx13lRsVjv7Gzj/eJ2VGXOQEIqSrGkJL509SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN6PR11MB8241.namprd11.prod.outlook.com (2603:10b6:208:473::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.20; Thu, 27 Feb 2025 05:47:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.021; Thu, 27 Feb 2025
 05:47:09 +0000
Date: Thu, 27 Feb 2025 13:45:52 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Message-ID: <Z7/8EOKH5Z1iShQB@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250208105318.16861-1-yan.y.zhao@intel.com>
 <Z75y90KM_fE6H1cJ@google.com>
 <Z76FxYfZlhDG/J3s@yzhao56-desk.sh.intel.com>
 <Z79rx0H1aByewj5X@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z79rx0H1aByewj5X@google.com>
X-ClientProxiedBy: SI2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::7)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN6PR11MB8241:EE_
X-MS-Office365-Filtering-Correlation-Id: 5759252c-af42-41ff-60a1-08dd56f22d17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?aVIy4k2UtzqYL5VUBIv6jCB7fLSBdBtn7ERThim+l/xB8Y4sBALc1K43hvlY?=
 =?us-ascii?Q?NFPFuAU6fQ4mFvX+2EJGPzwTGMaMHTnV7VbAHYyXj6ykmW0fXpSNuHnVjJbE?=
 =?us-ascii?Q?h/XiD3R9Ic3tdl4s1Yr38xu/71XDgQB4ljYgEThXiLeC7txCrW1850ucJMIJ?=
 =?us-ascii?Q?ZPQF/gks8Jq5RBzc8bx5mZPzdxMr7N2b7F80MrUwmviYqBjDYXTpe814DfHp?=
 =?us-ascii?Q?YDle/pPSH81QAaPDyWyPEb8er7zKW7w4CU2V65Qw/5/VXzqcUJAJuywL0Kw6?=
 =?us-ascii?Q?4saOfySyf1dEl/m9mqH4ebrwganTMMYXU2lRmfmmZXmT4HRBWe1Uyvc8Q2yh?=
 =?us-ascii?Q?CoapFpew24MKKeY61KbMi7ddvJxwkSRH2tVJ9uCZOc2csS6QhObD9svQ7ET9?=
 =?us-ascii?Q?t1in54lzMalHc17Ha2je10Q5Q1x11/HzdZQGJh2ORHbjKvhW1qLlUFo1mgWE?=
 =?us-ascii?Q?BkTPDgsUYypCrqyBziZBiofQTLVLAGNA7bermttc7v1VvcRMiN9K2pboCwnY?=
 =?us-ascii?Q?/KJfDvQNbUatQbY30Ze7TKIBb9WT39XFZS3yo9S/GIiOm5kT0P1pjkIrpWCo?=
 =?us-ascii?Q?ozhuFSpehttGV+QF4+1MUTcZBMAglhFAG57o2zkYJhn2DL47Z+wI3dy97oWn?=
 =?us-ascii?Q?4Yq33bLUos2lfVGV941BUdDCKDCXRse06eMj7uKVtoYTkiJWbbLOjH3K44Jg?=
 =?us-ascii?Q?EHdReWtHX/SaywC9wsBpP3aFl5ck+dFsoccrab2k3OHDzIe3OU/P/hkx6feK?=
 =?us-ascii?Q?Q7iPbMQ4PbtN9WGWathLRmH+LfPHzKSjsVsP+kHhxhsJuYAKR/3FQtHd4qpP?=
 =?us-ascii?Q?ukRMTfHc2e7JWg9UFarFgeW8OkfabiWs+LBfj2SPNC7EF6yT7/DhT40ItBqs?=
 =?us-ascii?Q?1tID3SE4rt3w7kmQLzfmBq/urJqrMT9i/kGsR+f81f19z72804KwsXbOJ4y/?=
 =?us-ascii?Q?OOLAmSBGyPFp3X4LnjFSHnihMhAWU5Mgn4Wo6VxZLNUqR2O3sOVbhF40aoZn?=
 =?us-ascii?Q?xeTEScnA4U+gDLuC5/fNeBjg5Wlt12rDXoRpiWnYewn80MjsjAyXfZIHJU8w?=
 =?us-ascii?Q?fcIxXqotq+h1U/eGSBKiKARDko1/TC0PDhceGa9N7SuOQ2R9+BkwVlp/WN/L?=
 =?us-ascii?Q?JV6MNsnUypctSQ+ddO8auUSId8NlSCbdR+QQbt1JJHOw0gBht46bDT+lFI3F?=
 =?us-ascii?Q?vC7xCGF0U9oFPWoCEj9OYIqMEMqU14fDcyLxJlLLsuSDypJiVMt9tYNomn3U?=
 =?us-ascii?Q?am9ORzyGfvZZi/fl8IEtjo2s0gNghf2DTn1c7o9AgqAgXwys8Dw0x2gCQl48?=
 =?us-ascii?Q?rrq521SGDTrymX5L4m+1OMgPOGCtMtlvrwwo9OeBP260DRd4uDLwXSVeemDg?=
 =?us-ascii?Q?nAgjOH+SdpEUjVJkGheg/ZMcy1vD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EeAxtVx9kJLZzZ81mV9PFPqqcR2lrC6mNuu7hL1hMJM7PIWUVMVBjNe/+thR?=
 =?us-ascii?Q?t3OIPEdn+VPzXe6X5D2FlWfktf6hQr2V7d8fWzTGfqI8/rzeAIGQr9pzE6kt?=
 =?us-ascii?Q?rz7tGq6b659vt2G0qYN4Z1g/3Dk6UwXpR3CXzO21g1gXLN8Sjf2kPWwdDLeJ?=
 =?us-ascii?Q?0fYaaXkrAsZRYuJlvD+wxUny8b1a+xkkURVATa76d8exrSPqY/iOpoBguTOg?=
 =?us-ascii?Q?rFwIC3Yo6Ek3Cb9JT5ewpbbSjuIcMlVY17nkzf4O1ij/FPl2OAj+veWm6mpi?=
 =?us-ascii?Q?K5vpNWaMe+uOV2W68zcDQxNkkwBrrUgeAf/1Z1NN90K3X0Ao+fi/ioELM4pE?=
 =?us-ascii?Q?suvfNvTPET7IJADneP4P+OMkqBzZ0ciMbYYBZjIF9WzsW+lUGZSPrqFD2b5Z?=
 =?us-ascii?Q?4ugQGAemqaO1CYiaezYg4+m1ZCs8+iQix9ZhXQ8kiOM8V4icV76G1tBYR5nC?=
 =?us-ascii?Q?Z7AZqS+EA9yAbi+34RxT9HqitPspXRHH5UD6Xh9CJqiRh4avtdp1CWsgUG3K?=
 =?us-ascii?Q?s3b6dkdSLbJ0GOqMTDaZLIM8Zu9mkAYnLa7Rl4WaX1YoPrfTAevTCOri5N3e?=
 =?us-ascii?Q?RqhK6haDVrsrEvr7FszrSjR+wVfv5prfybdJTKbXC6ydP0Cn3cjJK1vu61Kf?=
 =?us-ascii?Q?AC3yIguIq3mJl7/yWvX4XHUvq380I9sG3ZRGQQmevUCniXS4iS4j8yPy3rC2?=
 =?us-ascii?Q?vC6aVvQl31r0AWnAa22TXmZl6FaaikN14PGjfUJs8bladNvytbZUC8zUo9BU?=
 =?us-ascii?Q?HA3MQ4+6HE9y8ohr2sapV8rTR/2B12EOoXhNZwLqnrQh7fX+bNRnk264Xc8q?=
 =?us-ascii?Q?VHStdOFpiXNFFTqlmTlDrEJY1SQGbdXpWEsxC2GvumzSXpYLvpnygippkJfn?=
 =?us-ascii?Q?7ew2Q4Klz3hnkTVG42J2C+oXhu8J3vy6pWJhFLcTLXwogooiYxk22941wA5p?=
 =?us-ascii?Q?y6c8+Icl8ufYPh3MgI4PGUGJHCH74gOkciK7rZHihD/LT0zso9/La7TkRA3C?=
 =?us-ascii?Q?WHnElYOzPqK+Zbsn6OpnR/5/40GFixZp3H0PKSWZ6RS+g57uUJZ6cpo2ThSi?=
 =?us-ascii?Q?dpQ409TKvNXyV7Hy0SexVY5FkqCEmtr2skNZ13NnrkfapMdRWasnPSmrY2hu?=
 =?us-ascii?Q?zAZGxtDaq3nWdgtV9gDZ8Re/AjMpGxjHfx3u3ApLgO9qI5GJfLmR2W6JpuwW?=
 =?us-ascii?Q?77xiG6OVCMm58EBRVZyf6omuWiRnaZ2hiMalb80Zmh6WQ2/uHkjD36tJLaV7?=
 =?us-ascii?Q?/ldeaZJ1TGlzGU/e80EqOTfQTcty2ZiQikDSbdKd/Uatc+sJKZWS6HxPZnk4?=
 =?us-ascii?Q?w9YxpUvS0ZT0EF15uQyz7lQqGf/pQELre2uAWhfg1MwjTNyYgWSGwTNXDvX+?=
 =?us-ascii?Q?ejQRDpuWF9UQDkkUcsRqk1pRGUXuB9VVamwmOYGT4icDGz9MrhvORICpdzEy?=
 =?us-ascii?Q?azRdEDsWP3PGdmIWaqQYUmV4e6zgmAN/h+38Nb9YGQGBY6dZ3s+1rY3ydjtl?=
 =?us-ascii?Q?knMvkLfv77EUIv9RWcvMPmtRMC4YIOSyGUp/4acXh73MNBpGJNnSiZatNDPz?=
 =?us-ascii?Q?KB76SjB+eRGwBKFdo72JZMsrS/JGUE7fjo6TQ0ML?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5759252c-af42-41ff-60a1-08dd56f22d17
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 05:47:09.6630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjJEqZ4kdOLJpzG6+im7hdTn5s9AaPnCfwE2Oj7JYAFz7xIRupe/OD+mERheujpGpzQDbkreVhWsTClEoVhrQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8241
X-OriginatorOrg: intel.com

On Wed, Feb 26, 2025 at 11:30:15AM -0800, Sean Christopherson wrote:
> On Wed, Feb 26, 2025, Yan Zhao wrote:
> > On Tue, Feb 25, 2025 at 05:48:39PM -0800, Sean Christopherson wrote:
> > > On Sat, Feb 08, 2025, Yan Zhao wrote:
> > > > In the read-only mprotect() phase of mmu_stress_test, ensure that
> > > > mprotect(PROT_READ) has completed before the guest starts writing to the
> > > > read-only mprotect() memory.
> > > > 
> > > > Without waiting for mprotect_ro_done before the guest starts writing in
> > > > stage 3 (the stage for read-only mprotect()), the host's assertion of stage
> > > > 3 could fail if mprotect_ro_done is set to true in the window between the
> > > > guest finishing writes to all GPAs and executing GUEST_SYNC(3).
> > > > 
> > > > This scenario is easy to occur especially when there are hundred of vCPUs.
> > > > 
> > > > CPU 0                  CPU 1 guest     CPU 1 host
> > > >                                        enter stage 3's 1st loop
> > > >                        //in stage 3
> > > >                        write all GPAs
> > > >                        @rip 0x4025f0
> > > > 
> > > > mprotect(PROT_READ)
> > > > mprotect_ro_done=true
> > > >                        GUEST_SYNC(3)
> > > >                                        r=0, continue stage 3's 1st loop
> > > > 
> > > >                        //in stage 4
> > > >                        write GPA
> > > >                        @rip 0x402635
> > > > 
> > > >                                        -EFAULT, jump out stage 3's 1st loop
> > > >                                        enter stage 3's 2nd loop
> > > >                        write GPA
> > > >                        @rip 0x402635
> > > >                                        -EFAULT, continue stage 3's 2nd loop
> > > >                                        guest rip += 3
> > > > 
> > > > The test then fails and reports "Unhandled exception '0xe' at guest RIP
> > > > '0x402638'", since the next valid guest rip address is 0x402639, i.e. the
> > > > "(mem) = val" in vcpu_arch_put_guest() is compiled into a mov instruction
> > > > of length 4.
> > > 
> > > This shouldn't happen.  On x86, stage 3 is a hand-coded "mov %rax, (%rax)", not
> > > vcpu_arch_put_guest().  Either something else is going on, or __x86_64__ isn't
> > > defined?
> > stage 3 is hand-coded "mov %rax, (%rax)", but stage 4 is with
> > vcpu_arch_put_guest().
> > 
> > The original code expects that "mov %rax, (%rax)" in stage 3 can produce
> > -EFAULT, so that in the host thread can jump out of stage 3's 1st vcpu_run()
> > loop.
> 
> Ugh, I forgot that there are two loops in stage-3.  I tried to prevent this race,
> but violated my own rule of not using arbitrary delays to avoid races.
> 
> Completely untested, but I think this should address the problem (I'll test
> later today; you already did the hard work of debugging).  The only thing I'm
> not positive is correct is making the first _vcpu_run() a one-off instead of a
> loop.
Right, making the first _vcpu_run() a one-off could produce below error:
"Expected EFAULT on write to RO memory, got r = 0, errno = 4".

> 
> diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
> index d9c76b4c0d88..9ac1800bb770 100644
> --- a/tools/testing/selftests/kvm/mmu_stress_test.c
> +++ b/tools/testing/selftests/kvm/mmu_stress_test.c
> @@ -18,6 +18,7 @@
>  #include "ucall_common.h"
>  
>  static bool mprotect_ro_done;
> +static bool vcpu_hit_ro_fault;
>  
>  static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  {
> @@ -36,9 +37,9 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  
>         /*
>          * Write to the region while mprotect(PROT_READ) is underway.  Keep
> -        * looping until the memory is guaranteed to be read-only, otherwise
> -        * vCPUs may complete their writes and advance to the next stage
> -        * prematurely.
> +        * looping until the memory is guaranteed to be read-only and a fault
> +        * has occured, otherwise vCPUs may complete their writes and advance
> +        * to the next stage prematurely.
>          *
>          * For architectures that support skipping the faulting instruction,
>          * generate the store via inline assembly to ensure the exact length
> @@ -56,7 +57,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  #else
>                         vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
>  #endif
> -       } while (!READ_ONCE(mprotect_ro_done));
> +       } while (!READ_ONCE(mprotect_ro_done) && !READ_ONCE(vcpu_hit_ro_fault));
>  
>         /*
>          * Only architectures that write the entire range can explicitly sync,
> @@ -148,12 +149,13 @@ static void *vcpu_worker(void *data)
>          * be stuck on the faulting instruction for other architectures.  Go to
>          * stage 3 without a rendezvous
>          */
> -       do {
> -               r = _vcpu_run(vcpu);
> -       } while (!r);
> +       r = _vcpu_run(vcpu);
>         TEST_ASSERT(r == -1 && errno == EFAULT,
>                     "Expected EFAULT on write to RO memory, got r = %d, errno = %d", r, errno);
>  
> +       /* Tell the vCPU it hit a RO fault. */
> +       WRITE_ONCE(vcpu_hit_ro_fault, true);
> +
>  #if defined(__x86_64__) || defined(__aarch64__)
>         /*
>          * Verify *all* writes from the guest hit EFAULT due to the VMA now
> @@ -378,7 +380,6 @@ int main(int argc, char *argv[])
>         rendezvous_with_vcpus(&time_run2, "run 2");
>  
>         mprotect(mem, slot_size, PROT_READ);
> -       usleep(10);
>         mprotect_ro_done = true;
>         sync_global_to_guest(vm, mprotect_ro_done);
> 
> 

