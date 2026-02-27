Return-Path: <kvm+bounces-72142-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2HfjA0OAoWkUtgQAu9opvQ
	(envelope-from <kvm+bounces-72142-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 12:30:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8061B6921
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 12:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C0E2C30D45F0
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 11:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527993EF0B6;
	Fri, 27 Feb 2026 11:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kNjmFaKa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C503EF0DF;
	Fri, 27 Feb 2026 11:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772191625; cv=fail; b=Exsy7I+/pxkBYFJ+Eio+bJYtSTr0fevhKpgmz0o8uMjWQiq6NHU9Xs5xxwtSVrZfbR9yGhwXyIHX6n2+M6Gg72WxJRtu8O9FJgsv21kdvbyPL5lf//+vc3Y21lFH0UFuI6S3OBNgrdfBo2go/SFKKkqmH2fMhUoYRLgr1OursYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772191625; c=relaxed/simple;
	bh=oLVPjgw6jkPhrQushm11zz2X589zdvY7cADjzjTulMg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ObcTC+8ig5KGsKB+uQDfB3B5t2R93dPHC07gjwb1AzSc53Hy5BUV/TdM4lhsQHZflFbhDVzzPttKz/rBt/Y44Nm4SAzQLkJoWlTLI6NbZjsM1lXTGHizh5wKsIBgCepyFfOYWYVOhEJvX15iX3P6Ozu151cZbHmQpXgU97uLmtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kNjmFaKa; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772191622; x=1803727622;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oLVPjgw6jkPhrQushm11zz2X589zdvY7cADjzjTulMg=;
  b=kNjmFaKahnU/muOfdxak+xZpqydXldYgWQmk35iIefl29T7sZNueREj+
   hfA74Uu4RZhYXWwlWkza5ii79f2LuRqF8UIjuaccy2HwKS5Gq0ZgYsRXV
   KAw/QbY6rjH8zTeZPvz5a10iZikEPeGn8wYggCsAZCXb/j1gWXu98+J5h
   Jubk3CyJ77BqqOZ9FQEeUW+pP26le5HnXWzpxCQWr5nvoeHUAx1f/F8rK
   kgiWsn4JtFPjwiVdYJp7KUph1ouZRwKiW5o5JTRPAfNB7vqpusEofhjpM
   yHS817hTGJ5jS/7LgCiZAgNBJF7qhDXjmHmeQoimQnJTjWhJA6AXa6S8B
   w==;
X-CSE-ConnectionGUID: RvBLp9YGQbeyPBYI1zXS9g==
X-CSE-MsgGUID: KpUgoa1fTh2CRXKRj2PN2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="72975610"
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="72975610"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 03:27:01 -0800
X-CSE-ConnectionGUID: pbWLn1PsRpa4KM/gYWC4lQ==
X-CSE-MsgGUID: GJW1qLltRoyC5zUlHzt5NQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="220136235"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 03:27:00 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Feb 2026 03:26:59 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Feb 2026 03:26:59 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.60) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Feb 2026 03:26:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wQ9NhbsviPHGDBadXf6U/etvXvuSK7eRDTq1u0CCH1U8uzUT0t69nS6d7+pL6UwWqPnHkj9e3QDeLTx925xnfAta1hkcJZBd/S1xQltwoffEKypBQls8TgL/NTD/g2lZci118/BhPRkmqq/IvEG38yZPEp+U+lrTbZo5nB0WAxDlFaSMrcqrAcp24fQlvdb6bVAJW2jlipJLbXnYjUV5UB2PJUv5DLNl+6ozN+iUU4XzY9m90K4y7ZiXIq2ePY43couTCDBL9V6GwOLEHTDYlMw4Y/WTXksEPOd2W/mpua/MXy/h/YMwtbXlpkS354HnXNqLHGgb+DQrhYuXtsSqlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QuxA0Oz7YbpbzhL8CdLOyilZPVC+HoRR1UYHmkWIArk=;
 b=J+WjzdNfQFAtFJ9EGJXTWBdROuENCMJSiy5qx4mu9mHmSH4n66/3XOH1dqc6gnlqngIV16ajln3d6bz4KscVAlnW0zCN0KcQmLl65XxpRvjHnUmGyC8UjYm1O7IqqZ5Id3UNCVIB6Uv5ohmPheK4Kj88uhSl7V8YeNDV9/WcQU2yDwl5QAYvZCAFrUK8hbeEvMcOWcGivYvBdwVTggdnc5D4C+QtengKyq7OrqADTTA3qrKeVqVXMMByuP7pbJBJPb4g0P+2o2F+KXqevnrIHAywk/hpZpj3yeGrzmFldTcavUM0f5c9nt1gkYUkwcXvHi2aI8Yoy1jlfKfPArB+0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB7739.namprd11.prod.outlook.com (2603:10b6:8:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 11:26:58 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 11:26:58 +0000
Date: Fri, 27 Feb 2026 19:26:45 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, "Namhyung
 Kim" <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>, Xu Yilun
	<yilun.xu@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 09/16] x86/virt: Add refcounting of VMX/SVM usage to
 support multiple in-kernel users
Message-ID: <aaF/dc6uml24Tnbc@intel.com>
References: <20260214012702.2368778-1-seanjc@google.com>
 <20260214012702.2368778-10-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260214012702.2368778-10-seanjc@google.com>
X-ClientProxiedBy: SG2PR01CA0148.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::28) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: ae8afc3d-a102-4758-9b25-08de75f31e1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: 8r2RJCKrsGmJDVmqeZsF1b5nExNs5cQTZpxOAr4IO0WZBuwTAYvUaAhBlMu7DhusS5Auisjq0TA7HDlGDOB3PlAlIkp1IU2UjohOjKjIYs30SoiME57dBDhU/IrW9ENFvsT56WgK6G7S5jeonN+souwOl0+kYtiTsVGuILomGd6mazEjrjbjsjpLnjKqV/vxu0YsuT+SdF7pORlHpBZGOVgl++F4IaD6cJTXDAgf50UcdRLhHaRQlAg4AJODQiP66RqSqMS3rTrv3Hru9mOK0cKWOLrOozI86U+469wNbSvHpJHodzPoznOsCKHABwrCznwSIXmmqBMjwYGZ6cQTSjb8v3I8c4NNz6H7MGrNhvifmRSVcDa6LmPBUtcutdyn5youWgZSx+sUx7GJMTyjfB+ZfHhQHPK6skeaUi5ulOkvVpGi4P7wbWhbW8B3VD0ZO+mSd11SXYZKB4sBmoNFlkW2OBEANjzhEfB1SnPbdu32bpib6reALpp9dR97pFGAlj/8amvWuC7cMs79sHK6cEihRSS0G2qKJ0VFivmHRfwb85OqG25myMbdbQee192fm6aaHHMn9NAod+DWvqasROhXsN9uK1Ds/wcIsX3IRM1UQL9RTUMpns7QOd7zchFa83jLXazPzHObwKIjcs77zslunIiKiRwpJWHaQhkwCQrnzl2fEu++hSkhGNgJqu8jd7a4FdnJ1S9TYOcx8eXODqQ6Tlj/68YUPpKe3ydEIGA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YrPUo+lnuOs9mWKDOxwgh+LHFZoP8G52/qnUwaGTzrj3Cp2tmFH1cXbn7pp5?=
 =?us-ascii?Q?yzkhUN+04RDPmW2sXqG5mFRqPKaS2YZoEoHR8NNk1y40mABzAApgGXEtHXXi?=
 =?us-ascii?Q?hvY7OOpF5+tGONwtdy+gla19UimuaxFmz+CM9mt04oLQ6SmwF5aFYajoSxXF?=
 =?us-ascii?Q?eSV1/Ve7FoPepCAxiMf4kL/mgxEiCF2cRp6hvHY9oYwVQgHN0eANBIdTdaHO?=
 =?us-ascii?Q?HPD+D96bYe262XxPvl+gHJjUhRjSUJ9fNdGYSp9p2pKYARz35VT6YSZtM88d?=
 =?us-ascii?Q?dO2CoAIHwRCxM5SXM6mtkJEXfEIQouGoMjClOR6CAtAaRNBO2cBHyGtOK7xV?=
 =?us-ascii?Q?cA9LBiB5AvpYlKAsMKicNPa5sV3Ky52a1zZzQ8zoHszCH0l6TMMTf+8zrK7q?=
 =?us-ascii?Q?dd0jLekZ8H/mCLbQuWVEQiXX2Y3vC//Z1ZxvHp/reQJjFGNHEZx8yjJiFXHh?=
 =?us-ascii?Q?4d7vetRpWez3zT6BIwFyoUnqAdp5a4csLDY5DwTHC135MEbnFfjiBGunSlRy?=
 =?us-ascii?Q?ZZyxI9hrOasRXnZC2Jz6QUtF6RsWZvwZ1NQl/NSd4Jx3swQ8W72KMJADV/5f?=
 =?us-ascii?Q?hh27RtpaddoV4qg0qOjNZzCIr0Wt0X5rw29oNTic+nraMz7BcqrCB6qAx6NU?=
 =?us-ascii?Q?fSfed+fzpYreMvQ/t45Qg5Qolkc3hwQbBSkXuLwzQs7T+ohaDYv9pJFwZGYw?=
 =?us-ascii?Q?x/KfS2jqySmybDvMnGFAJSXEHieYI91QjZz/gMwQ0H5AGIrPUXp5TU/e03O1?=
 =?us-ascii?Q?99WTuPRghMvdfrxRbrJpwCEk1xCEbqWZ5ETMFHdojrvXPwLtr0MxTOTgl4y7?=
 =?us-ascii?Q?jh9UAFRtFySnG3uWXOZz07hizwS2OmjDWJtnGeXBQjayABWSL5eZ1IrbcJMl?=
 =?us-ascii?Q?JKwMN9wNfVLgYwv/ol52vmCKvMOKVloswdvX81AdHILBHrhgF4xtiflVotO7?=
 =?us-ascii?Q?O9ggLbn6LnMw2Xf+1NnHKA5pq4298M3fHLFO0Vzv0woZZHD7fgluSluqiPR7?=
 =?us-ascii?Q?D7HxHQvLpVpEqwbToIp/U3AkIXBTaSBs0GW/APH6dslhWlmH3VwJggVFrmjD?=
 =?us-ascii?Q?DxlduC3Dl1EGGNxc/rtB7MgQ1/o9QIpnXgbGuNIKD9iaYYbpcic6QybiHE0/?=
 =?us-ascii?Q?4+tfWy11ZTAomfv5G/Yj20HzyWUmbh0i++TuEeGSqb6PJK5HNEk3clWf+Eoo?=
 =?us-ascii?Q?Rld4LeFI6L8j7tivt2mF7Q5r7lSwReKfpxRzeFeYJEQFRfLeWXSIzW9lkvwH?=
 =?us-ascii?Q?gKzbVpPmvtOxiDYXnp3UN6KW/jg+P8XdN+MDc3AfowTYMv6DzfihdB0qeTxl?=
 =?us-ascii?Q?wETvOKgJWdOHXLYltdB+WZ8PfqKa6z8hc8WlO3mLbmbe0IFVpGUHoowQnrwn?=
 =?us-ascii?Q?lhoO+sJrTgo1NTGvBWbmLCNMlwweI06sJDRs5kdMuPcnWEFxiTFN2NIk1D5a?=
 =?us-ascii?Q?YhJt/tnhzH9epDi1msdU4ctYuZCxuvRNFgNEFE/3Ww72O2S++vnDFBQqXyyd?=
 =?us-ascii?Q?7SddedCQkirX3U6umjAKdIyMAY/0WXAqKDHTq7+CWpTBLDiRy8ONqXCwFsUk?=
 =?us-ascii?Q?2MG+caqbEMvPnUhSTGpK6iKYfgiSlWzQzyER2f53M9zhNqMHoSQpH9kbWyNS?=
 =?us-ascii?Q?e65wMwefes0/Y3WVXYpJSzDMIOMgm0ol6bKp6wS+DzhVWwm+C2Uo5FzDXUB8?=
 =?us-ascii?Q?WyHvp4YQudNLWf+HB3TCCGJNG8mNpoMebaWNM3Onb1CxloFCjD7W5HrgayQc?=
 =?us-ascii?Q?jCLynKKlUw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae8afc3d-a102-4758-9b25-08de75f31e1e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 11:26:57.9614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fIQ9C5CjYk18PDeelgbHa0ijqQcQ7PfFgfCw3y8R8HaOsYQ1IYb199sAhHvlTnI7Fp+30WXjcBI+e0cc/NinFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7739
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72142-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 9B8061B6921
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 05:26:55PM -0800, Sean Christopherson wrote:
>Implement a per-CPU refcounting scheme so that "users" of hardware
>virtualization, e.g. KVM and the future TDX code, can co-exist without
>pulling the rug out from under each other.  E.g. if KVM were to disable
>VMX on module unload or when the last KVM VM was destroyed, SEAMCALLs from
>the TDX subsystem would #UD and panic the kernel.
>
>Disable preemption in the get/put APIs to ensure virtualization is fully
>enabled/disabled before returning to the caller.  E.g. if the task were
>preempted after a 0=>1 transition, the new task would see a 1=>2 and thus
>return without enabling virtualization.  Explicitly disable preemption
>instead of requiring the caller to do so, because the need to disable
>preemption is an artifact of the implementation.  E.g. from KVM's
>perspective there is no _need_ to disable preemption as KVM guarantees the
>pCPU on which it is running is stable (but preemption is enabled).
>
>Opportunistically abstract away SVM vs. VMX in the public APIs by using
>X86_FEATURE_{SVM,VMX} to communicate what technology the caller wants to
>enable and use.
>
>Cc: Xu Yilun <yilun.xu@linux.intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

