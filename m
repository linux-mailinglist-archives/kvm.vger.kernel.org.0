Return-Path: <kvm+bounces-72975-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +BPQGWo8qmlLNwEAu9opvQ
	(envelope-from <kvm+bounces-72975-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 03:31:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C63A921A9EC
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 03:31:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1BFA30530EB
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 02:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3CA351C3B;
	Fri,  6 Mar 2026 02:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FxES70ZW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0110241690;
	Fri,  6 Mar 2026 02:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772764253; cv=fail; b=C7ygkt+ilfmNA9Ru+IJrccgG45sjsK3Q7TObGEC8LrJ7sXSyfHNMw0Ya9px6TLhvjPuSYUh1K0whn4vdoz7542OfsNz3hDiPoiPbswX6JSYYwNYSy3XrQWXdaid8w9xUE3ZnrIeFw7Ug9wNk/KboaAVXz+e8G8dq2XjdGYExpIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772764253; c=relaxed/simple;
	bh=om4s7w3FeB3INhcJmUDlkmdAtEPsGASAlIJ7VCA4nWo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PqkZl94T8AiR7akDyvMvr7VE9pY9oo+qtoUuSiYnLlLfh09pAqMKq+7JXH0it+qKuhH15iwjMHgItPUwaXPquW6mWXTdnCxH2cKgBgtIK/iSwxXxNdU80Y23X/EuLQ+jGsj8dVyjDE4nrxDSJo1g5HYWO1Xal6r5kye0q+WaZvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FxES70ZW; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772764251; x=1804300251;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=om4s7w3FeB3INhcJmUDlkmdAtEPsGASAlIJ7VCA4nWo=;
  b=FxES70ZWTlY/WVtZAplTHOb8eDzgEaDxvrwjtNonFassHRIanC7EEjAv
   aNBMaO6cD6bBrk3tDcek6WSqWF6Kq2MpJieCjRr0SLhl2NV8/JCae+zV4
   msI/H4GCsFoE/VXlUjt2oGgK7G/jhpoIuL4ks4rq8y7BcL06gG9R/XVEs
   p+/KWo1iObA/q7i+K4qt/suH8tfojw+EaZXO6NFHIyF5Y7cK4l5aBR4+9
   20b918lmD6/P02EZtIVNTCP1yEnBGbTDQF1AHuvqm0rYdnU8P3Z6C2HTZ
   cw42QEbk4coE5t2TcgWRxcgY1S5itiFHAx0giDwEeL8GeNlJt1xmjeqHE
   A==;
X-CSE-ConnectionGUID: QoeGKGjmTTC8KdKZY24K9Q==
X-CSE-MsgGUID: +1X37s1rRcigVR6L9cEwDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="72894692"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="72894692"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 18:30:50 -0800
X-CSE-ConnectionGUID: SpWRz2+USEaHCH+CnvuhhQ==
X-CSE-MsgGUID: BjVoc5lRT6KpPj9zeOWEBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="221701729"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 18:30:50 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 18:30:49 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 5 Mar 2026 18:30:49 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.2) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 18:30:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=szTv7v5KfkD/TAR/qTsCUHtaByQ6bwFPYK8ZzLnBlyPdvIAe4KhPZrgZ5+ALI9eYHfBQX22LaVw7nhQ9ZAtqgibc0vOsOYUnTirW9zWW3JT2CgpQ8Ubllmi1lNwljgkdm5GmGUVeByJdO0znJGhMqw39CYPr0eCKCO+SrI6W0rVGInwYsCci2jWOwL6goDsaCbLA7tgt8aK54FyT2xmtfwFW3ONZvD+AAW3mKTWGSTPAYsxK2iyM95tCpaWZnjKZQ72Pxi8H9F1KCO3gdc5ff5MQ6xUy8YdGOyd5vb7pXm5dcAmlNAWXlBY1plD7MCLwg6EtM59sAIoNwpLlwZXuZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+61UDwGVIMk0uWxtyRn1JkS1iPKfmzzZt1lEz65CACE=;
 b=Fhig+Aegpd7bCS1bNlOhMft7pmcy53/3rPZoUeBNHRdiqjmCXqN/MzOC3B8BKnGC2dT38Pw5pKmCDsAwanaTRerDs1FfY4ypbs82QbZh8J91IJ1dpBhACqxGaAVaRGyQuNzcfCFTEG9UnIpqYKD7FTf98zxMQ/Dgh3I9Kz+bVSlNWJ6W/88BlSmKDsP9F4LfXaDpzCTFKFEWxPQjUzqFFYzuXTjBwFsD9Vh+o5R9HqOThN8x4zPzS8u55/1XOs/4dL28ImBt3qOnBnlllWSgokrod6fcZB+nbn1LNEFCrz+6rHSVygtKcEqsenGxFZg1auBKW1LuXhGTdyhbCKX1VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB6750.namprd11.prod.outlook.com (2603:10b6:806:266::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Fri, 6 Mar
 2026 02:30:46 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9678.016; Fri, 6 Mar 2026
 02:30:45 +0000
Date: Fri, 6 Mar 2026 10:30:33 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "Xin Li (Intel)" <xin@zytor.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 08/22] KVM: VMX: Set FRED MSR intercepts
Message-ID: <aao8SbZMHT302dDS@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-9-xin@zytor.com>
 <aRQf1sQZ9Z3CTB8i@intel.com>
 <aajS9HFx5HabmCTq@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aajS9HFx5HabmCTq@google.com>
X-ClientProxiedBy: KUZPR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:d10:32::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: 011e6a6d-7d7a-48f0-d472-08de7b285ee5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: S1sIdwGDjBnMYMXFAp6uh+WHW7ybt9j3M271o8ATDNjo8nWblp2b1byaArHgvUMg85SC5whzolOrLGDk9rkqimKCpdcnoGjvVBnJNP034SCUw1BetD62mL+hlI4X2/AQ9hmPNfqRV8f04pJriXdZRezDs4+4KPdTZ0hnGCbhfa7NHHR5pr6+m+a2MhDXAou4Q5SCoiQQgHvAKW4gthxDIy94/beNfkO4w2myo+sF/+YhOSL1qkmJgvI2OyITsL7sygkQiBbetKaAaSCIS3dl7wa/x2YIVGSY3raKEr+Fo4oUZQEY3Bz+yegMpBtgRXxYTITIW06G28+WT1NcixmavttGtwyTthNNu75upu/7MKqxcxvZcYwb1w713yuSpw5NK4fwZfRbCS/rC4HQlRLSIVkTeWmMBJTijFz6D1JiHtkqEOJ8NKRK56IctKf5tAZi5zXycjFc3YmXJOAAORQBFwVsWFSWJx2RTptfHVHe5hxkMurMY05tqj0NGH6pWvgnioHP+x2pJdS2VAfsCrso84mWeLT7ZntQUxkvGhGj0VVnwpOD0W8a5FJrHgL+KwTAKEPIbttaDjucrKErSjVR+5/9zxinQjBthDRfApbj+VHgoaiRvLtVasFSA0D9idpbG+HqOqZw12plrTP+jMvek7OmQaEbReenx8LAOMCA0NyAq1Gt7Vhoqo+YELY6INlJyLppFCx0eT2D1k5xOSiIVuyfR2+Cnr51LvLZAJ5TtMI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WciQQ+4w3AwwMru5jptF4HoQq8YhmR0pk2sPaitrZ5RHMAw1nAaRbPhVT7ZY?=
 =?us-ascii?Q?30bIb2j0C/Levmi3RnAMxVJJDCvUNm1tR5ooW4dPBh+2DmF1W4xZJtaWe1rW?=
 =?us-ascii?Q?oHzFBFUSU5b/ZkPqvmGj2UVVBGKy1XCY3qb1ZOy1BvALidC8SfT06wQqD+rr?=
 =?us-ascii?Q?JJMIM3+4gWQ+ZUbYH2W9iUCkGD7qdtDjeuxhZ6aqSYmYvthCAQLjyBnO6hr2?=
 =?us-ascii?Q?h08pdavhtpZQSRBOgs0myTFz/B2r06KlsVMp5vTFwgd4cCZ8PNinRX8cOWgu?=
 =?us-ascii?Q?261pqS2Cb3wZrkAFPtM0j5NRhGR9xC81WpKPawaj+rnVzX7N/hEiBbYuX9tp?=
 =?us-ascii?Q?Kvh2qSs0+OkIKDO+CDr0nA6LPH/pgllkdaujSGB58iGLje3VP5wFVYU4iodj?=
 =?us-ascii?Q?Mv7Lf4XvdSJDqjoxAR2QEUx3jMg+Rd2UKkoqyhcXk1k5wzyA/7bnwgvQ3eWu?=
 =?us-ascii?Q?OjeSa6PydWj/6DtPMRhYPJzFlJaG9eHh8YOwxyt8H8V7wXae/Q+NYVYOBaDS?=
 =?us-ascii?Q?rutx5T9eiTw830TvRgmzM+ZvOMw8VSLHV8tmitXmf2kEpe7wDhy22HZ0g8xy?=
 =?us-ascii?Q?jzkjSu9eKzZMh0O6fyXaCaQjOmTyEaIW9L7qwFslcyDxqVnZ3jwWRGpuktKE?=
 =?us-ascii?Q?jHr7FX3no89Oc8f3MBMDT2uNa1xDXZ9CXYaXlUVzedulS0h5jJFJkU/+gguc?=
 =?us-ascii?Q?sfZuzhzU1R64jntbLIQhL1UPA9UWS6PvZt/BngwWEt4eK2akMcu86CpMUt/x?=
 =?us-ascii?Q?eqGrXX24IZ6qz2XEgOh0mJ4zrYitmyAhLkKVFbibOEEWLzntouPbEZ66bYwS?=
 =?us-ascii?Q?VwS0jQzZjWQ3W8p63+FP2Zxz1Yqfl4LLn66Kn3xoSHTg/SdU2BQCzOwxL0lf?=
 =?us-ascii?Q?8bJo1LfiBwdEuGn7zokPK2PiMciv/vGecoCJyBGzuJwrT8gGFNCiF8wKwbMF?=
 =?us-ascii?Q?im4wEqlbyDWbruviPjQnX3ilItn1YSgIb45VJjbO7hYFcu4Ckfuz31olmyUt?=
 =?us-ascii?Q?ILqUQiwCcFSoX4HBgm6FWg6BaB4emetHqJyjR/aYYU6nU0G/oN7qXsFmrzx2?=
 =?us-ascii?Q?vY5BNmRGFptawTdflDfYQlszPpi5DQeGoyw78AUF9gG6sOIE/tODmkbiXiCj?=
 =?us-ascii?Q?ZjrH+2yiddEdq32Xva+zk+XuSy20KikrFyoRZb9lURQ+ZXWluNTU8sz6X5Ho?=
 =?us-ascii?Q?m9vkYOhefys+2BgVlUx50L+i85CEgONLYuih28tx3PzQBE63tb1bhu+8zt+e?=
 =?us-ascii?Q?tILk2GfdNQt84KWoaugiN9Am8XPQic3a2f5tytQj3PljW8WlCMd3ZnO2J4qH?=
 =?us-ascii?Q?o8eWo1EfucO9mZdIkYMocRENkY5bPIdEbrlheCPqlWbog3MM4MmUR/SErWk/?=
 =?us-ascii?Q?kbQ1iLL+8YOggqKHhyAqQF6W07b/Ib8VOY23zno9XYhUzL1CNFAH6Ar5dd1z?=
 =?us-ascii?Q?adBkHnjauLzvIWmYcB06gqlClZOrGpslfgPBFxEF0GVKZIZe+jSYeLC6nYeY?=
 =?us-ascii?Q?0cuExfUjvUE76rUZ3zoEeTUs4n1K7RCQfKLqmBfArPU/WX4KGBw4Rf62KEuZ?=
 =?us-ascii?Q?HK0JTurnjK7hDfB5KmfMutjw+od0RmUvZM4yaanFAzQ/2Q6LRdtgfzVPpYHc?=
 =?us-ascii?Q?5EE8CU0d9Y7hU8Xjgwzmu+yvbr5Zcp8yp36bp9T5tTAY8uUbmSh72gDwxM+S?=
 =?us-ascii?Q?CxVY3krWz+wWoAqwxfct8Zixxli9KRE6NGddaVyt3B0YJcgopFvE+UlUftUe?=
 =?us-ascii?Q?eD1nx+Ly2g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 011e6a6d-7d7a-48f0-d472-08de7b285ee5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 02:30:45.7931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uKqVynijYd8kltYTQWHv8PbbVgy5AGLvtzww3h9dIttuqx9ypB4Z5mqMal5dbSBSde6VMtIKiqksantbHROJpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6750
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: C63A921A9EC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72975-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 04:48:52PM -0800, Sean Christopherson wrote:
>On Wed, Nov 12, 2025, Chao Gao wrote:
>> On Sun, Oct 26, 2025 at 01:18:56PM -0700, Xin Li (Intel) wrote:
>> >From: Xin Li <xin3.li@intel.com>
>> >
>> >On a userspace MSR filter change, set FRED MSR intercepts.
>> >
>> >The eight FRED MSRs, MSR_IA32_FRED_RSP[123], MSR_IA32_FRED_STKLVLS,
>> >MSR_IA32_FRED_SSP[123] and MSR_IA32_FRED_CONFIG, are all safe to
>> >passthrough, because each has a corresponding host and guest field
>> >in VMCS.
>> 
>> Sean prefers to pass through MSRs only when there is a reason to do that rather
>> than just because it is free. My thinking is that RSPs and SSPs are per-task
>> and are context-switched frequently, so we need to pass through them. But I am
>> not sure if there is a reason for STKLVLS and CONFIG.
>
>There are VMCS fields, at which point intercepting and emulating is probably
>more work than just letting the guest access directly. :-/

Just drop the MSR intercepting code and everything should work, right? KVM
needs to handle userspace writes anyway. so, there is no "more work" to me.

>
>Ah, and there needs to be VMCS fields because presumably everything needs to be
>switch atomically, e.g. an NMI that arrives shortly after VM-Exit presumbably
>consumes STKLVLS and CONFIG.

I assume CET's MSR_IA32_INT_SSP_TAB is in the same situation: it has a VMCS
field and needs to be switched atomically.

Either way, it's up to you.

