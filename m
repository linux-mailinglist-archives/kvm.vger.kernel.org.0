Return-Path: <kvm+bounces-29829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6C99B2B02
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 10:09:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C313F1C21B14
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 09:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE99199247;
	Mon, 28 Oct 2024 09:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L5pplNrU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C4318FDA9;
	Mon, 28 Oct 2024 09:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730106544; cv=fail; b=roCNMAgzEJYJl+ZXggoZ2phqZglKt1vO+r+OC0jb4laqcDSU839rvWnmR9wI9a7Wq3DSAvtYJgzbfMjuuZgfxVJpsNz9y8kJlEe7hceJXOy0YIPKEvM3eTCsG2G7GfvcdxBTUeEGgaKwUSVRaCnVk5YtH3j1fLGmlHtGM4sPu7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730106544; c=relaxed/simple;
	bh=phq5Ixs/uItJFgJ+7qOfEAqqrQn6RbVxsUVfqW1bQPE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fqJi5v5KUEOU6DcjMdvEROlQIsRI3sMSj83kGaVCXIp4sTVCmkDju9mCHtGtuyEm83ubcnPyUaDOO1QTFUaDI8dY/qetUMALD/H3ZDt51+ERBvxQMC7BVUE5Z18MpAghXqmW10V1t0oPZepnREFxsBwKt9GR6YUqk4Nfq8O3WG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L5pplNrU; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730106542; x=1761642542;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=phq5Ixs/uItJFgJ+7qOfEAqqrQn6RbVxsUVfqW1bQPE=;
  b=L5pplNrUnVzB7FzCjf4YasLq1bHl/qNF6VycaqO9gmrR+VuSj54zvwOO
   1lFB3apT7XryQFshkgW329oQFdgCHH+Wt/CJoFAD8hQYQvSAS3UyN6c7z
   NLasO3LsvKUmKafKV6ZA/fE3kKoUburyGJi6PiHK68ZgDSDy7006O04dh
   fFW21ps4wOhhEQqclunEEDakrnWa12wvfx3HmXnnjBqNKOruVYi5OM0Pp
   DVB1jUOzwz7gtN2KImiak8GaNDXZdEZxRU4ncjLtn5TVZkSxyk3RGmZXF
   PodCut5sSSSIDtYdrDveQ0vh4op6w4lxbjoSz6fKR5iIEGiiH6osbi3a3
   w==;
X-CSE-ConnectionGUID: 2QnkUcDKRLWt6SdhXh+KDQ==
X-CSE-MsgGUID: dBznkCukSKuHvlnRjMYtWA==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="33606146"
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="33606146"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 02:08:42 -0700
X-CSE-ConnectionGUID: WfOx+4+ERUe8cmYr1eSvRQ==
X-CSE-MsgGUID: z2vUxu+OSsm2CgK9taRhow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="82374087"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 02:08:42 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 02:08:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 02:08:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 02:08:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pfINFK1OU+zY4Vj4vubOL1thpS4IKuYa9HdRtoUCEaflYAPntWkcCiDxx2mWNpbxOR/tW+JJFmaNwGuyni/fLnis5KTWUhG8J5p1Gm2V6Rwid9oaIeTc8ntfC6zKjnf/YSq5/lPBxIhI8aexKoYu+K1yefQOJXg/yeWGNXoz3Mnsv5B6vWZsHMCEXWVe14qlghjz6z71KMqMeqNG4uJaB0ZlkSZK9Rha9c1huJHstn0TpGTe1qSFpJTnYPr7GM4HrBHQpBCRIvp/ST5wJy3MgDecdM+/CNDCMwIISJCTY+6NOPaR8G0v1gdcFF8/jXKXpIokNEPnpnQP3fS4FBb1kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faPStH+Pa7xBXEQ9s/cBpZp6XONoYplgPKqOoapIHpw=;
 b=pqCbrBo3IiiyA3leK4R63Lx5LCnCQFJ8tC7JOpJDP0d4wapsw1xfod7ceafBm06PQ9C8IcYfMzYPIrNuXT//ttBdahrm3CGthwT2I5BtDCqobzHEvyYuJy9U4GGtOan1IU1KWk80iOpZBGVAjueyvYdPwcYgfEbBfrFJmV1YzYB4xrLFTeTBVIoIr0w6rRzqiw+ArJxykePmADSHl1ElI4z8vu4JQoVeqMn+qrNVlTxZqdkahGQnxlv9B7RB9yYmnnXwzkOEe4p+9Wj5hYMeXLJj/r6qB7pABkPHz6hVhM9uoZOp84QI3rWrbyhxfoEyErtyUslUEZGOYsjnD5nkMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BY1PR11MB8127.namprd11.prod.outlook.com (2603:10b6:a03:531::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Mon, 28 Oct
 2024 09:08:07 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8093.023; Mon, 28 Oct 2024
 09:08:07 +0000
Date: Mon, 28 Oct 2024 17:07:55 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 25/27] KVM: nVMX: Add FRED VMCS fields
Message-ID: <Zx9Ua0dTQXwC9lzS@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-26-xin@zytor.com>
 <Zxn6Vc/2vvJ3VHCb@intel.com>
 <f9bb0740-21ec-482d-92fb-7fed3fef7d36@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f9bb0740-21ec-482d-92fb-7fed3fef7d36@zytor.com>
X-ClientProxiedBy: SI2PR01CA0015.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BY1PR11MB8127:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cdb7e64-b7f8-4686-1ce0-08dcf7300969
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YLpGTwxrOBVBbnyb0w3gZofIo9D/P3V+i9V+qwJ4LRdgSITl3O5FqHu2ocY7?=
 =?us-ascii?Q?tQ8fbjTwaaJM6TKaoxTufGnTmx2w/4a1K43yVAlX9oKO4wxqSaFezrBDKI9X?=
 =?us-ascii?Q?S4XZXFrjJtIyqT5DlTXrYQkPvAgbUfBkpwN2N1oU9Z49QbGDjWBhsgZlGlLc?=
 =?us-ascii?Q?NUq3w1XeB+G6YoWGz5LTolgZcWz8K0XNlRPMJbl6znlAhX9OODl6d21EeP9E?=
 =?us-ascii?Q?aYhfZWLKzeHjG7ByW1GTjvjmOMVXq0vlo7l8BWTPrnIU7r6ZjWemn7/7YPAi?=
 =?us-ascii?Q?1s/pnsMfFR+g5PS4DpXAf+ymseSRFjO1Z1yPbTkkvnSJPSn5ts/RtXEc/khC?=
 =?us-ascii?Q?N20EEOftMPKa7t0KkzRa/hi1FlzYxJYYTBXvDJsSswAd4a1F4TTuJR8RwvcX?=
 =?us-ascii?Q?dH8Y8qVNWzst3/eXATLAr/W79YZ3ufQ6vN4HOX54UhaG9ynwm/TYvGgVCepR?=
 =?us-ascii?Q?sEHDMijy1sMdk8tw33zp55bCDeVr0LACUpLA4peBRpsT+vGxT8lqEbEurs8B?=
 =?us-ascii?Q?ls93yhdxrkBtySfVnAecReBOsPlhGtPnmwDCZR5D4HY2StD0cc1AnXzYjZnB?=
 =?us-ascii?Q?aHisKPtkeIZ1aCGjTk5gYG1UFpJuL5RKHYZV+Fz2+0yqLW514KIvGyKjRFUt?=
 =?us-ascii?Q?WeUeEq682KO22IxRgBm4SbEMea7lyPMNz4yX81LL34XXK9CFj0y1ZPGHMwlW?=
 =?us-ascii?Q?mfS6BrRVe2XrUFF4GYn0gH2qx0ejfXo5aEryRa8h9TLuNl8ERCaAfAVESlM8?=
 =?us-ascii?Q?Gy4VMbPN+hgPewG1lIpaKqqEk5L4jeQ9dlgIaJ0o+Bt3ErovzhXGZCWxR2E3?=
 =?us-ascii?Q?cBxHie+75NLYw49FRaLLFHMZSDZfMqYl0RhzP4gy8AsXIcuWrGRj+B1DrV0x?=
 =?us-ascii?Q?ALoHE4kKKbVsyagz0CWY0V3+/hqZ0wqcXtQlPlUWOAb4vO8kDsYktqf2cUtz?=
 =?us-ascii?Q?ciNgqh4Ai/2s+fCgpbikJwuLtw8mlce7bUQS+Gi7CmppIoElIy+0QIpzRmOD?=
 =?us-ascii?Q?6whu2HZCkxqaa9Q+fKzSBZesjSGqV+D1bps6EVMtxaE3lpMCGJSXLYhXV+4T?=
 =?us-ascii?Q?sfwm1/pxMBAgK5zvJA9NvDvOqVjgukIqcutAMgzCJ89UThKrOtn3g7QljFOS?=
 =?us-ascii?Q?kMFRlfi622vfhb96bUGEp1Lp5QFiKvAV5kJr2FHLRk+1gVksHLqizEQk5YCP?=
 =?us-ascii?Q?DE8ewZsu27wNgCMkTRZShzkqvB/am4d6OXdRbeeYT+SPscQ8Xk6r5QyuzVas?=
 =?us-ascii?Q?mKZ7HcMhWgF1rJiqT9KoGv7TULKlDQ+5KJ6WNNF0PKzCTmj3suaw3468rOMp?=
 =?us-ascii?Q?gyxJWmhvknl4U7AMvQBJcSlM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FjSYAXOosc1AGL4S0TSc9bFVuKNHBZLL60bEqHKO+FaeGkZbSC5NZYjPpHKO?=
 =?us-ascii?Q?GRaShteZSrqXVQo9L1+JvIWnNvYiB0U4uXDta1y5K5JkPWpC/jL5FwZPdQs2?=
 =?us-ascii?Q?Pzkuz2WyOznCzwgCs0uHbjNb0vguWREYASKP/5rK/APpGFgFAUf1VWccPTE7?=
 =?us-ascii?Q?2NDS7t7c9fsmmiQz71ulmLG4DqoPzM8yzErFlfQDR9oufWJcxM824DctTQCT?=
 =?us-ascii?Q?tQ3Y1PmcXyGdVxm1sdmeS16SsTodpvWIGml+DemB22A351EESKT2+SjgRANd?=
 =?us-ascii?Q?gt37HcjwwAwI58a9q63K/cc5iexymBwkiGL3eY5Ve4uiyp4viuV4YuVwk0ug?=
 =?us-ascii?Q?ts+mIY2ELY2iXGH4gQ0d9cIrLcWssMBji1yMfbh6GvZwIN3e0X6EDfRnxSpD?=
 =?us-ascii?Q?hGa7xghHfVdAY7SoyDdjTczNh+XvKswB25MBzJzUZGbmMo1OspE4F/70pdvq?=
 =?us-ascii?Q?SlulcLYOdA0oz9bsVi+c0AZCqDVBGfJxTdr+bHps3snn9vlm0qEpHFzuGtQf?=
 =?us-ascii?Q?yYxdmHYiWUibiYlqN5fwTidqNuUKVU2qOezO+r5BWEWL2N06n+bstn6xFBQS?=
 =?us-ascii?Q?cx0z+GOgiIlIOv3rf9pNpDFyIjH4/d8eFmDWu+noqm3cSndCggXUYBy7sqZ6?=
 =?us-ascii?Q?1vz3fb72BXqXY+iGPOltKYUkPC1TwRM0sqJ+suBhlG90iqoJKr4Qc5mSVys8?=
 =?us-ascii?Q?boXJHr/DKvSyBeYYe/S4i4ykAZm1Jhz4C7cgdfK8jCX6Dm/tTxTnJq2LlqDU?=
 =?us-ascii?Q?mmQH8w1tkOWY+9fH3VCQ5YvLMzAiqMVt2xs3Y4H7xLMHhsJcLYQG7eLXnjQ/?=
 =?us-ascii?Q?GSx5x5FdemrD+wGlvkZTWMwNafs68XWyddVvhOuecLx5yARHvX8tkeONN1F/?=
 =?us-ascii?Q?llmNe+NnaykZcR9f5vjaSvRjp0U3A1p91XKNMppJ4wk5ktIe/OhislPoQwc+?=
 =?us-ascii?Q?Fja0nQXi6+/vGvwSuMVpehsc6xBCENR6vPsX4eAveN4IgAtMAylahSi4d+uD?=
 =?us-ascii?Q?bPvf0l71cGjb7PJX9jjIZYRqqTXiunwOiLF0+MYtpJx6U/nJ+faC2MhXivMy?=
 =?us-ascii?Q?uV0C1yiNWrkVkdd4wGlKRCIOXbueoThLnx5TKuRcXr1x9zELgclCuqYlKiT+?=
 =?us-ascii?Q?SkuYLsYXfrN18Qr+MOqZCf2Wi8y3kHSAn/Ut6vhSSX5c9dg3HAGQemdqW9BK?=
 =?us-ascii?Q?kMMBI0t8bBRHYbw0DUhV+NwS+GHY4OiARiK+rrB412XO29/m0MqrnL3MIRRq?=
 =?us-ascii?Q?hjxNOF5M2ZiHCJDxv6xsuIxYxAWIuhwGi3ib7HzEbCIKCpaJWxoFtZnczC/A?=
 =?us-ascii?Q?s9ufSizcI9dBQbUkFv4pFY7ns29qTGCB9EnrkK1sJfKD2e9t2mYGc/bt7V2d?=
 =?us-ascii?Q?4EzQuTXMdzh695GgEjghptnjkjr0NaC3i7+FZ6aUkZZT71AKbyYnyK1VkszB?=
 =?us-ascii?Q?x87Bw9jKBPzsnyFtjV6fRNQZ5M6cXDkfZ1TRby2Eha77UTfVhCq1rLNZ949F?=
 =?us-ascii?Q?xCK2p5WByyZF9ICVC3Hpb/A/uPntHCtSYXRNHXHPYRducppt+/h6mCYCSjXo?=
 =?us-ascii?Q?SjfB511UvQTxUQQdXKST5fjRXO0Z5/KUTR6itfLI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cdb7e64-b7f8-4686-1ce0-08dcf7300969
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 09:08:06.9491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FA6i2ZXq84wZ6b3rV8q0NEIOVnuuHBzXkYZLwLCsMID598xDqts21XEfjasNZXMpJ+Xyi/50qDyBTrXmpbey7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8127
X-OriginatorOrg: intel.com

On Fri, Oct 25, 2024 at 12:25:45AM -0700, Xin Li wrote:
>On 10/24/2024 12:42 AM, Chao Gao wrote:
>> > @@ -7197,6 +7250,9 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
>> > 	msrs->basic |= VMX_BASIC_TRUE_CTLS;
>> > 	if (cpu_has_vmx_basic_inout())
>> > 		msrs->basic |= VMX_BASIC_INOUT;
>> > +
>> > +	if (cpu_has_vmx_fred())
>> > +		msrs->basic |= VMX_BASIC_NESTED_EXCEPTION;
>> 
>> why not advertising VMX_BASIC_NESTED_EXCEPTION if the CPU supports it? just like
>> VMX_BASIC_INOUT right above.
>
>Because VMX nested-exception support only works with FRED.
>
>We could pass host MSR_IA32_VMX_BASIC.VMX_BASIC_NESTED_EXCEPTION to
>nested, but it's meaningless w/o VMX FRED.

But it seems KVM cannot benefit from this attempt to avoid meaningless
configurations because on FRED-capable system, the userspace VMM can choose to
hide FRED and expose VMX nested exceptions alone. KVM needs to handle this case
anyway. I suggest not bothering with it.

>
>> 
>> 
>> > }
>> > 
>> > static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
>> > diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
>> > index 2c296b6abb8c..5272f617fcef 100644
>> > --- a/arch/x86/kvm/vmx/nested.h
>> > +++ b/arch/x86/kvm/vmx/nested.h
>> > @@ -251,6 +251,14 @@ static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
>> > 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
>> > }
>> > 
>> > +static inline bool nested_cpu_has_fred(struct vmcs12 *vmcs12)
>> > +{
>> > +	return vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_FRED &&
>> > +	       vmcs12->vm_exit_controls & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS &&
>> > +	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_SAVE_IA32_FRED &&
>> > +	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_LOAD_IA32_FRED;
>> 
>> Is it a requirement in the SDM that the VMM should enable all FRED controls or
>> none? If not, the VMM is allowed to enable only one or two of them. This means
>> KVM would need to emulate FRED controls for the L1 VMM as three separate
>> features.
>
>The SDM doesn't say that.  But FRED states are used during and
>immediately after VM entry and exit, I don't see a good reason for a VMM
>to enable only one or two of the 3 save/load configs.
>
>Say if VM_ENTRY_LOAD_IA32_FRED is not set, it means a VMM needs to
>switch to guest FRED states before it does a VM entry, which is
>absolutely a big mess.

If the VMM doesn't enable FRED, it's fine to load guest FRED states before VM
entry, right?

The key is to emulate hardware behavior accurately without making assumptions
about guests. If some combinations of controls cannot be emulated properly, KVM
should report internal errors at some point.

>
>TBH I'm not sure this is the question you have in mind.

