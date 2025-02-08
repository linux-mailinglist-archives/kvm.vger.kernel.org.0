Return-Path: <kvm+bounces-37652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10267A2D321
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 03:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D45483AC665
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 02:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1278714A4F9;
	Sat,  8 Feb 2025 02:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HMhS5gzg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B3EA41;
	Sat,  8 Feb 2025 02:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738982320; cv=fail; b=RsqcZaM0LxYN5MK7TuswXVZFCsm+2KPX6BbbjBq8jRNORVREbC3PWVNUhQ1JNjBtlz6dE/FG6C019srlWI9pMDvJWmLPzkkSaWh1L75JkC6pL20ZrWePax3Bd+Vt6ZOe6DDesnmvvXrYkcrCjIgvEQzMN+RMZOreR/fGFcdtqcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738982320; c=relaxed/simple;
	bh=UbNm0wNTy+8rZdXO4ItuphsXACkkNTvK4By01F7UdmA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FyKthPz/5Gmo+ijKCsruEFf0+/J1zFVYZeuDQQ3HHk9yL8ZWTsFclYTufMVTNkua3kBRqigUw7W1eUhbVw4hI32hcNVyCDAeOd153ji9qEFiWPCuHQBoSK+xAJkVTxsHh5Vx/KDCmyPwkDfzg4VyEMIdrISMx0KJ3DluP8UTCOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HMhS5gzg; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738982318; x=1770518318;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=UbNm0wNTy+8rZdXO4ItuphsXACkkNTvK4By01F7UdmA=;
  b=HMhS5gzgy8AIpVunK91mY/jeEPqkc5gor2OVnXEMWU2T+bobTSsZWG77
   wFLhLKuJjqDhtLq4G0mJlUDJ/Rmy0dFLz82IKArApHLLAzIq9qThQuvku
   wcg2wULoKAytwsnNBQZbsz72TNX43zPFx06+5v81PTaOcRTxmL2HWWmEh
   4glQ/cGEQyHujUbIf+gvXIJQ0W0VgNXc1E/MOA3usZ7qcclTFLNVlqUC/
   7E36j2RpI7G+NjCnj5PK3o1G/9robL0R6nhxxdPZw/zVMEV5dj+kdbvYV
   IkQMMyTTqlpPLdX9Zew6HpA5uZmWz8q0eu1TNVe8heFixqxQBwHYiTD8K
   w==;
X-CSE-ConnectionGUID: wdDr8fZbSmCr6vKPEi1ZTg==
X-CSE-MsgGUID: 2Wmf+gqKQ7qhDo7VwW2Lgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11338"; a="42477565"
X-IronPort-AV: E=Sophos;i="6.13,268,1732608000"; 
   d="scan'208";a="42477565"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2025 18:38:37 -0800
X-CSE-ConnectionGUID: fYOQYn6ATgqNXph3Ja0xrQ==
X-CSE-MsgGUID: alacfa/cQ/SDAldrmdpa4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,268,1732608000"; 
   d="scan'208";a="111460250"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Feb 2025 18:38:38 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 7 Feb 2025 18:38:36 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 7 Feb 2025 18:38:36 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Feb 2025 18:38:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ABJ3ccipGDixyAHQU+BGUlJxx5H+pj0ILYiGWa/6L2PLtOTtYJizGJBCTha8G35m5cKH7Hlg0gzw/ctay21hEuRm4CldZmWOMKoFI+GmGm5D38+fEJnTOpeauKkuDLQ86QEXnpnVze5ee2k/GJ694rCrLt5wuc7nRxd4NMweMgr5QFHg7X9JVcrp1cv3K7MtkcbWea/ReFnRDLpkG+ibq//nYPW2xvTpFbYieEUZnxvn8wFaDLzPeJOp2DAk5Cqjhs96AFBpBRezPRoFLSlih6b6SCz1RVKos3RUEymS/ELWO8PiFCv1yng/immAvM3rKq+Daq81N6d1GKNCHek2ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D41iw30BJVA0Zd5xA+LohXKv7dvfz7wImG8nnyajwwA=;
 b=OCdWbRfMfkL/Sk9/yz6SqfN6gnAHoiM1nwtJ92oZsxrEtbOZNwMBmEnO4x9xKTF+ohkAnHSRgUeKu4bI2QQr6aCOb/bn4f7TlGnT0SGVS9sV0hBj4mQjgtibCyg/09i6c0B1mc/Q3pVFhmoBmBun4NCCcB33J+Sq2DyOLlh2vHnvrzrAeB1vvZbYwhGyilSCXBNnPs7kDyOZMMuipOXX1KY+1UrjxWm0d9KrSNR4HWmIKeCZGcdjKB0hE9M2+f3H9PwOz8UAIOw2bSvXY4yX3KttD6qMEtbEocoTM1LAb9NHVeZOM5YwDW5DZI4hYnaxPiRwmFnPXTWklRDgNany0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7337.namprd11.prod.outlook.com (2603:10b6:930:9d::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.11; Sat, 8 Feb 2025 02:38:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8422.010; Sat, 8 Feb 2025
 02:38:33 +0000
Date: Sat, 8 Feb 2025 10:37:25 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Make sure pfn is not changed for
 spurious fault
Message-ID: <Z6bDZWzePT6CAreU@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250207030640.1585-1-yan.y.zhao@intel.com>
 <20250207030900.1808-1-yan.y.zhao@intel.com>
 <Z6Yhmg2nmUAtp4yn@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z6Yhmg2nmUAtp4yn@google.com>
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ddee527-f19e-4fad-5700-08dd47e9ae2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lh6PEyx6K8ABor9WtLYxi4bj4wXVTPVbaqBkweWeneN5U58foRJ/IUW6NwL6?=
 =?us-ascii?Q?O1E00JcnFyX507pxbjFXdv7v3S9foXobCuTqS+K+xb4H/kLvDgLdWMTW5FFm?=
 =?us-ascii?Q?hPjY+hx7lOhuimdG/elrWWWTexEZGqpntygQg4seG2YykKphAi+sVso8WeAT?=
 =?us-ascii?Q?bJzbMjIx0osKHccdrxetNKq7jmqOXWXOROKdluLTx1wcQhRrd8ri9SCXeLbv?=
 =?us-ascii?Q?Li1muj40t6JccAxP39Cb+lLye6PcmCzD03RHupu3jadkulf6MZ4itDCJqALP?=
 =?us-ascii?Q?vnuz1TWJ9YEbps/bRrtB4aIiDhXkcEVi+GbeGWYZvtcOoKioINqp573dgVNQ?=
 =?us-ascii?Q?KApHC3/lGgtGJsGl/6iwseoLha2JNz0RulMKT1l+mkKqqnKstJPWq/+ZuxIc?=
 =?us-ascii?Q?mDj65dQ/xRBWzAWhFZqg7tsA0cs/EJQgVUpy+hZh9w2IIfpczw5WQ0fP7lUW?=
 =?us-ascii?Q?ebdNpiMY0xllcoku9HglFX8iJwOpSUfvGcCgrXZvGtjEZO1QzHo78t2wybW7?=
 =?us-ascii?Q?N3qTQIhwbQimFfNH3b092mPTL8QMEDPzeYmzgDinCxMN1cYwsZZvUVjZLdWZ?=
 =?us-ascii?Q?UO5rJXwfVaG9qk1I6zRd0wDP3rywTfsrDxW9aKaBfO1fHat4HZ1Y2NHpyz37?=
 =?us-ascii?Q?Q3pYPcxBNWWIeVT0I+L0uXnP6udjFld+1O+Mut6Cwszr7ItJxL8QDOe2WNqN?=
 =?us-ascii?Q?SnPArg8f+8Oc8mnwOsd3UfB0tm6NRpeSdH02mYuNmUTMhewujptOWW+OqkQ0?=
 =?us-ascii?Q?HhTUcF/tARJyy4BkESbFlLQAY2VUP87mYKIjTTWUsD9H1pGQrCRTP2e49XRW?=
 =?us-ascii?Q?LesrgE7VE9pA5/bRcSOmHDS5XHMqVO3LWGEnVbXcjcmf0QAh7z+2t5aAPpNK?=
 =?us-ascii?Q?Ox1t+OJUik+H9CV+jeRlXceK056rXm5ryu9BB9daiYYcs+aa5hWuj9G1hfqV?=
 =?us-ascii?Q?6niTMwsXv/mSDsFWFSXWasYjzJL0xpoXJRZI6q0pCwnsWqs/z8ybV567Wfv2?=
 =?us-ascii?Q?F0dwYbTTG19XIxFUaVl25UBGOUvMM6lMpeb8XHL+VnJU86wljuQt+RB4Q1LN?=
 =?us-ascii?Q?0kjCUI+faSsxFC8omm5bnVPsCndrPX+43f7u2kFyTfFCZluK7d3g/KqxnpWy?=
 =?us-ascii?Q?gXpVSeeQocbFqRF73yeVhsSYZgcv5AI6ObIo0JtnoWZwopVI+6X6v5Rf+/3B?=
 =?us-ascii?Q?9NVZWp+oU73838YLPXEut13ZOqnDr4GfSLffl1FGiKXqP6p2KG4MWPZIcKDD?=
 =?us-ascii?Q?mRNEuB9OHUBQWr4KjK5KK+4qxYW+H08xYZHBcFEprxqiQo0YKB9RKDBZLM6/?=
 =?us-ascii?Q?SN5d1gRdlzdX9JGBDkgrFqhWtfGhY78AyT2C5aYg6dxqyyk8XPfYOeGiShkM?=
 =?us-ascii?Q?p6amyUjC39B9Ym1M2Wb0OTuuOhi+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0UvamwhWvmMykxx+8cSQv3Hn9CDJZpW2NoWO8GbxA7I/57iPriDuLuLq3xgS?=
 =?us-ascii?Q?qQFWihMKZk0VaiEq8zJPlbJy/dlBCj8QXGiVGX84IXCccO55tukY1b/q51HP?=
 =?us-ascii?Q?dl8SbmAYObE6xmtOA3wMprvnJoyL1fEnOYwfAH6BmFSNUlm1mklgtNzWT92l?=
 =?us-ascii?Q?j9YJIDd6uzqCqzDLYJtB/pGSCVNLP3V6Q4PLNU6gLWPylWIyVClHwI2uT94s?=
 =?us-ascii?Q?BlXO3ehUCBS40rN7NwQprYJgY+cG1rcLtlFFas33lI0N3Y9vwddS7xRZk6Sx?=
 =?us-ascii?Q?/r6cziuyvzb4ZY7lt+5e/PxrD0Lv9+i1JJVqHVm62OVx3g7TIVwEszNVZPPl?=
 =?us-ascii?Q?Iiz6+kv1Tiy5Za4/vIQe7WfW1jo4flhgwlp5+dtAKdjL4w9cxVaLMj0GdgoH?=
 =?us-ascii?Q?NGHVKSSCgENf3zvvTnd2wd5wHoXbSIJciyzRjD+nbn/ng2su7c1oZnqekAVQ?=
 =?us-ascii?Q?M1Tn6WJU/4WwGnD0nr3NukjbcOZDaGdLGFS3qub6LctLBgOrPfwlf1pgT2Yi?=
 =?us-ascii?Q?iwbMl3tqEdEPxZHYscWNg3kc370KjFMCUsQNlR/hWlOLsrHeYnG1IKbYdOem?=
 =?us-ascii?Q?mlQwkvdAle+gtLt4zt1pgGEbOZmGIRiMXsQwv5ixAlArP6AK80bQj+0bhedb?=
 =?us-ascii?Q?4RZyDRNqkRlTNXu0HljGFbSVkG6DDkEW3KNNdLGIsi0PZ287Get/t4LyyHgn?=
 =?us-ascii?Q?Bt9tG1s4sfC/L85Z+6yxpUtB/NY6l6aJSxpDEsyKLoRn48tKE9Oo/SMnEFXC?=
 =?us-ascii?Q?pegJCvHzeuNZ9d+RE7KfwW2RXtJOTzPQwb2k8nh9bdCSvgMs4SKbVM/vAdIv?=
 =?us-ascii?Q?/JeMKqtuK4zdQyfuEdesNMGAU9ES6xSoZ1PkHDGIqwTLn8mxI0vvm1Hwp9PG?=
 =?us-ascii?Q?vHKvajVkkTAA/J2wFlDAsC1B7qMt6EwmxwGkb3cHsYyft6Cu6oR8j4Hd0ag6?=
 =?us-ascii?Q?A1adR6uk1c1SYP/AAO/OcswxOWNA7sFkGc1pnH7C1v3l+GRROvCYx5dIGIvk?=
 =?us-ascii?Q?++Ksd0u4ed4eJpSS+EO5y7HlpuB+PQ06EuCy7c4rjRdDzdLW6+v9midbi+j9?=
 =?us-ascii?Q?T6Y0ZR6gDuvsF9Zu1ZQCJ3+El8qHVogUMYMVjL+zg2Ta1OcyB7dM5AloGg47?=
 =?us-ascii?Q?NrUIbdWuOtcJ1kzgsFkK80gytYDMe7h6PAJ8SDiQvx1emvnLEjXdcMG+S3UM?=
 =?us-ascii?Q?QwkFDtZ5d0hnHf5s9I52BlwylJkY2f6UEtEb8QHUvipsfrxoBhOIW5Id0RAa?=
 =?us-ascii?Q?I9FeN9TgGARaqZIbvGmwOVw0tDW5KMv3ncilvzoninLl7h6AOLhWipoin2so?=
 =?us-ascii?Q?cHAJhYropSF6HVWG5Hs1UhtUVJtO/EsbKmD1a4g/qcOq1GzG2njTBUF6Dd7n?=
 =?us-ascii?Q?OcS0n6Uw+uquwNtm+6vAx3Pskiwg+9u9K5+NoabGGXHNYKSQnTafizGfV5im?=
 =?us-ascii?Q?yZ5uNJd9YS8tcAi7gdEdwytDO/yoeImQ882V8xHdCDzWwmGSx/qG/mWVPjRu?=
 =?us-ascii?Q?9lS2A+cqe0opBff9AFs4SuuNtGvRMadw9ZcWmK3NVO0BT4zoC0fAp/ZPRxhZ?=
 =?us-ascii?Q?XMnX5FQc4WbOSYuG/V10Zet5gW1ZuGoXLIo7pjB2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ddee527-f19e-4fad-5700-08dd47e9ae2b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2025 02:38:33.2756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XrrTcAq855TaVBdXlr7X7xQhhpJgzGoxJ+9Y2OXWE4F1UiWxhRjFNhktbjYGQ1mE2nkMxacKASqidA7XWlGx9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7337
X-OriginatorOrg: intel.com

On Fri, Feb 07, 2025 at 07:07:06AM -0800, Sean Christopherson wrote:
> On Fri, Feb 07, 2025, Yan Zhao wrote:
> > Make sure pfn is not changed for a spurious fault by warning in the TDP
> > MMU. For shadow path, only treat a prefetch fault as spurious when pfn is
> > not changed, since the rmap removal and add are required when pfn is
> > changed.
> 
> I like sanity checks, but I don't like special casing "prefetch" faults like this.
> KVM should _never_ change the PFN of a shadow-present SPTE.  The TDP MMU already
> BUG()s on this, and mmu_spte_update() WARNs on the transition.
However, both TDP MMU and mmu_set_spte() return RET_PF_SPURIOUS directly before
the BUG() in TDP MMU or mmu_spte_update() could be hit.



