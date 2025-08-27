Return-Path: <kvm+bounces-55864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1137B37E7E
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 11:13:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D21D97B566A
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 09:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C98341AA9;
	Wed, 27 Aug 2025 09:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bPw7OYFO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545B22F83A5;
	Wed, 27 Aug 2025 09:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756285985; cv=fail; b=QO/TqFqw5sfY8wUy7pWkrKmJS5sBboApli4PDdCcOb8ntn6rzN9Ubt084qzfmcrEWiawy+remcBZCJcRZnBmkNpGubfUOG1x9CZKikam8w6zjAsFgPS08EM1dNZ/x3wD3I/o+DqM1Yh4DMrLA+Kk0lLtKcFE+LNvZL2+iYu0EMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756285985; c=relaxed/simple;
	bh=dRISzVKoK1Nj6JlDccLHG7VUJ1xjhfpUiJzwEldHK58=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WoFTjEuENdajoc7kIMFg50A0i6s6bzkGW38dpcSeyam3dUZPF4L494Il4RBduBkuk85DXZd5QoMSlqvrlXWoPOnM/c6yaEiudnv+d50/LD+XteerqHQcoVU1KR0EMBBysK9mzf+VveH6M+i+yCepNen3qaQG0mkZESyBIE0YvL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bPw7OYFO; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756285984; x=1787821984;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=dRISzVKoK1Nj6JlDccLHG7VUJ1xjhfpUiJzwEldHK58=;
  b=bPw7OYFOWaEpwcP/j5VEEkrV9ZsOW5wvFJr4AxrX7bz/nm8s96F0W+E7
   l8MesOHVhKwQB9qamLO03t7Mss/v8yeUTiliVk4bAMOtmd2LwjHbu++dI
   iafApg29r31Q4O9I1goVPtBx5uIcBLBWqU4F3ZkC4leL/BQrYxUn0f1UF
   x/GLSu9LSND2LNdS27tvb5j+qs526MOeIZY39egm35RmB+y4heLW/Nqre
   r7L6SNAdSVpts1yAUAUQZnDylDPeQ24yYswxAsiX3tArxTZN2cXXTbST0
   CcyZkkJfyhoonHFIS4lR5Fzt+66uJjKkVm7B1657zlbjk6RpsC8zkBdy4
   A==;
X-CSE-ConnectionGUID: nDUfH4nkQEW1pZshA4Of8A==
X-CSE-MsgGUID: XSTQnne+Spu7VXAf1JOavw==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="76134134"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="76134134"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:13:03 -0700
X-CSE-ConnectionGUID: anCpiQXpR528p1KXfNcnHQ==
X-CSE-MsgGUID: 1SaKRqRBQt+vhpvj8Tx3uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="170623779"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:13:03 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:13:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 02:13:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.68)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:13:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CXt0vYYBtHrCYlvGMp9lcULoqPqvOQoN3wA4KURl36qvcbXPITUTR8ZszAprv7GwpBtR9HBvo546E9KCanS1Mp9f7iEWXgr934RLUtmBTl1j1VCFQv4MPugtkUrRFraWSY8kwiWL2JTi5ZYTmyN95yxfMI5kVaQ8k3WtypWCu87dqbKBaPlupVdMEYCDIKigOpPqiWcHANoOJ3AXO+R/UocX6sbuzvsFXrY8jJnHLeS7sHmBhGCgFtOWrAvzF6rKxWHZaub3PVbsQf8f30ODAc5KIHtuiyyDRlwrv3bCUb3hWkVGjbSGUGaGc2ZkR/VB9FyMStvZRH+2BIB8FPVs+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQfG2ljCXkgGNA1BFAMXGPxW99ag6Fx/EGV0DxYXfb8=;
 b=BlyJYXVfBTM9oT5Oe6+4Pq7iFi/VvI3dBxvfztKdV9g/TrHeWaKXShWq4cFkMR8LEvTGIwD3IPFSzs9UmyOyTURH4WCunojkSxpcroU9ItCWOOKQ6GbYyOfO55ellL/pxc4ZypMvc2ZrNJ7k27D8OZhbL59XQkwdQlP1AjH4jgs47B7wgDxL1PkDvK7bRbV80rvSSHIjg0X+Ms5y9Yvp5BpdhAYJGC8pxuAf68Ky60FW0kj4PAXaNajtffGfa/Z/RJGsLfsuxlcCiRS9gsDZWbq1fXj1xqEGc15E2jVGdzAYJbUWLQArgskbcc9dvo5pWUB0AmzLKTELsedy0IR6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7799.namprd11.prod.outlook.com (2603:10b6:930:78::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.20; Wed, 27 Aug 2025 09:13:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Wed, 27 Aug 2025
 09:13:00 +0000
Date: Wed, 27 Aug 2025 17:12:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 11/12] KVM: TDX: Track nr_premapped as an "unsigned
 long", not an "atomic64_t"
Message-ID: <aK7L6zZDIeSObzTV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-12-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-12-seanjc@google.com>
X-ClientProxiedBy: SG2PR04CA0216.apcprd04.prod.outlook.com
 (2603:1096:4:187::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7799:EE_
X-MS-Office365-Filtering-Correlation-Id: ac9a26d5-3df1-4464-bdb3-08dde549eb39
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?A559mfcc2Jfl5vKOdfvxIdTB3+7fI5N0t3E0N9M54ujm7GGPLcIJOSnDcrLu?=
 =?us-ascii?Q?MkPISQN7T+O6nDI0rLyaPNN/AZ7mQk8kd0ZUbdOX0awR0P1FixXxSmajuAQc?=
 =?us-ascii?Q?ECptv0Ljuic8YUpKmwDpBHFg9u8KcxqK6SU2vzC2a5jyHTUU2pwEzLyftXGq?=
 =?us-ascii?Q?p4YAnFwAKUrYrwoYh6HV/mdqsMO9i+5QHWL/+4rxyHjtcw+ZGhi5obgZr7FB?=
 =?us-ascii?Q?ZtWq/Sl54INMr1XqtVAGTEhMafuJSKDj2EuUhwrHsJuCqXMBQ8RClMTEjynY?=
 =?us-ascii?Q?4OfFi5G1lkG70eU2vDvTekwNjzlYhFLtIBjxCQk8kFnMVhUrvX8VhmiOe0NH?=
 =?us-ascii?Q?JTQEnRXyGpGVD3aw2A2u27kwmb7wah7BWdGVgA7EubBG+jmCPtTyVoaYNHuu?=
 =?us-ascii?Q?3WK7FxiSG5MxAY4LAPA0/qHPJMRTIySKybeY4RUKRknUGqO1srXtAP2PmodG?=
 =?us-ascii?Q?mjOfPNCe5TguZhb2V8kJBMEIUIsrOyOrDdfN0K51oncxkhmEEy/inJAsx7a3?=
 =?us-ascii?Q?Hfwcni0fPzHrA0oijR1+OkYmNSkaXjOyNB7Te2S2X8zeh8pbBLsNV8eSvjFW?=
 =?us-ascii?Q?Dw2mwF/fOM+ztUBZ/IM9DkOVl3pLYhgRHX01UQItqHt50hfGJmy8U/dOpdpx?=
 =?us-ascii?Q?YRMuXTMXG9SzoJJwbQDHdvgW8hp3DIS3jvTRy+okC5LNazR/8QxMARrGuL6a?=
 =?us-ascii?Q?lEy9FAOAl/0LLNdICuFAc6/ZUIcGWa1oUpZ95jnO4oLpFqMyS7pQdDhPnlqu?=
 =?us-ascii?Q?FVVx+1rwuiwcBY4PSwFvjtqjJLNjdiwFIFY8dMIrik0NddvCtCWsVyJFSw2w?=
 =?us-ascii?Q?oII5iuNuoCO1KdpyWa5d6mwJProcfPR5JFZlrNYihlN0gwhDrcsL/TDCM9mK?=
 =?us-ascii?Q?6X489PpQLH6VfwHoldo+zDk7/bouNcnru8e7UkQtqkMbqXdjew+9E27xWgfV?=
 =?us-ascii?Q?kq0SRp6BOEEopJWy8CzrDz3Mb/OhKwuhvDdo4sHGwYeCDtLafh1ycnCiMG25?=
 =?us-ascii?Q?GeslU/3Hi02bfdJ9x8kaYqqghwpWOsCG+BGv9S2mj8R4YmGnNsM7h4rZDTny?=
 =?us-ascii?Q?guc3Qw87LkM8XSEI1cV70Nx4EAbc0Gvt9gkhisnxIA++iDWUDgcAKwA4UzYQ?=
 =?us-ascii?Q?ukyN5BQLEIQMSOZkgTw6cERO+lm7f1HRzCXFDRap2tMEygMPDv6zkbLh/E+j?=
 =?us-ascii?Q?rCq/oj7i0tQk58djfAb1ReEDjbUgQGO/TObUq+OvFkmJqctlaAs5V+Sjy1GN?=
 =?us-ascii?Q?xPBZ8+IDGbPOvgDaTlo+7SAZezQ+tArrTAN8LHEZiytKVLq/42O8c2MTKZ8i?=
 =?us-ascii?Q?4uWNegLmChCt/64j+Sg0iPt4rRRHiOW0xUsxomxvVyCque6P4knsR2u9PnzJ?=
 =?us-ascii?Q?4gew2RLkHQHQmu0Qop2YKhbpGizxrRwKgZXvo8hJ3OdqHdzvYE4OR0lS4WB0?=
 =?us-ascii?Q?5y8l0Pqgg6Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rOydVVwueHk0OHL4TMEdErkoiiaou96aKTHXwWvsY7SgW5koQJaYDC2RjyOX?=
 =?us-ascii?Q?QlykOkQX88E/Kaq7fQZ0TsG75UsAwG93E7Gf/wmabrQSeJyLhW6smzPiusNy?=
 =?us-ascii?Q?VFF+NK94p+z8cfLUjBRIEETzX/VMHRvy++pl6LPs3SN1op5ZYSYiTXjuKvuU?=
 =?us-ascii?Q?gJMrYy2EYtUJoN13S/G4YXS1ZNJXWp6EyKFzW0bnPeST+K9PPVZMaSSI+Qc0?=
 =?us-ascii?Q?6fwOavAXrO2C09Px4kbZvj07uBsRIBtWsJCqzZdhh9gUApiGR5jrGWx7DpHk?=
 =?us-ascii?Q?euSeLDS7LSqrjb8aErSoG5RTfcBFjim4dMILKSPdT33xzpHW77R9fo5hJrBO?=
 =?us-ascii?Q?8WpALJ/QKNdb97a0nYYsDmi+C1XOx3ZvJi8YmR8Fk410NdLQAaDU24j1yDLd?=
 =?us-ascii?Q?HOWaaMjA+fmzj0VolGl3pd6v1nwdHn7uNXAas05WSp1Urj9jGQOLXRgO6mye?=
 =?us-ascii?Q?nhBqhXjAkTIS7kxVEpRMuWvhymSPlSl/OV6jmqzbQR87b4d58bNqmiAv2iwz?=
 =?us-ascii?Q?DYiMb8zbUd5reYzeT0lqEk3JwbCCLfS+w2HkojyErmNAaHPZJ/LIH6S0G9G8?=
 =?us-ascii?Q?Ytbk2rcSMbuk3KZJYIAlO8XQPZ1ySxn4JKL0MQa09jVkDp7IGn/S7dBMJ4En?=
 =?us-ascii?Q?r8EW7tMRVzfmG1hIDRZp7vFpC0ht1eWBEqoDvLZOfiWcuTr+DryATsL+ZAMI?=
 =?us-ascii?Q?mBpu68BK6NXAxSL2fQWyhC+ysvEMQVLxsQnT9JqqIsgiR3dxWELMGQDcSL9n?=
 =?us-ascii?Q?UyM2QHKbDmBTx3+RYaj0m4PbPKBZmWKKeZadTm1VuLjoYflkTE2ZNmQDwn3c?=
 =?us-ascii?Q?wftxDlrB3UG2vAHVDefdOXa7YNWAnujpNmfOIYRfLxTN7UClfHWZeIDJUjNV?=
 =?us-ascii?Q?gOtfgwStUMN+BNBa8WpZNRnVRhBWy45o8l48IFeuWxGRf4c7MnUSOkqo4LCB?=
 =?us-ascii?Q?26Vmmk3wihNjjEhZfQelM3dsH6JlaT8f/0bpLWhOFQfU8hE23WTnVd1jYLdh?=
 =?us-ascii?Q?fW5967qw0n6jrdex69YIWWGsq1cm1EARIkbMPghjdL4HVd5ElpWYzS+AlEyY?=
 =?us-ascii?Q?lhjzMPISoG7/2JMlBfa+VGJEBFBlm/917jCSt554GbEZLSWiF5muTSUGNSWg?=
 =?us-ascii?Q?NNJJ20OYLBQAOyQRmWKnjq/ccKEStHwjO9HtD07vcv1c+XSFba8civ58bD6v?=
 =?us-ascii?Q?1A7DWfqay1XUrrGa0tNBVbxVJoBg+bb/Ote92qUlHfR8KqxZR1YjqWhvIzvg?=
 =?us-ascii?Q?KZrKG69KOaaaUKuENAIIeQ2iShWBUqMkWRY2uIqedgzO0Q/txOgFAa3tXhl+?=
 =?us-ascii?Q?9YLeh5MQrHl2lHQZryRTISjuoQhTyaRoPhyK+SXaqpynVNwIkGvSIh8Io005?=
 =?us-ascii?Q?v3ydbCRlnuIcieGtALiTiG6Ii35nlRmIeAPtEK3v4PPaVqxjnDDhhTRMz90S?=
 =?us-ascii?Q?5+Pd0xtG9RqcmEw0rEReyhDQQsJuL1HlAJ0RMJQzWSDvU3R/yVHd/NISxZ4c?=
 =?us-ascii?Q?Eq0CnEqKApst36k8GpqJgi/cqe9BVv6QARUCxMP7zJ/xEtwAIG3Qu5Axbw04?=
 =?us-ascii?Q?3/DBP8UpipgjJecXOC4cWyuzz5otQBHsefsuYZVe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9a26d5-3df1-4464-bdb3-08dde549eb39
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 09:12:59.9572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+W+/S3urjAs6ABU60h+dMtzabW1K7i9jWuFO9oK4liZtgZ6Rd1fd2JFsUAu2Mw2CIWbQ6Sh5ojEFGEDHXG2ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7799
X-OriginatorOrg: intel.com

On Tue, Aug 26, 2025 at 05:05:21PM -0700, Sean Christopherson wrote:
> Track the number of premapped pfns as a non-atomic variable as all usage
> is guarded by slots_lock, and KVM now asserts as much.  Note, slots_lock
> has always effectively guarded nr_premapped since TDX support landed, the
> use of an atomic64_t was likely a leftover from development that was
> never cleaned up.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 8 ++++----
>  arch/x86/kvm/vmx/tdx.h | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 27941defb62e..5d2bb27f22da 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1639,7 +1639,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
>  			return -EIO;
>  
> -		atomic64_inc(&kvm_tdx->nr_premapped);
> +		kvm_tdx->nr_premapped++;
>  		return 0;
>  	}
>  
> @@ -1771,7 +1771,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>  	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
>  		lockdep_assert_held(&kvm->slots_lock);
>  
> -		if (KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm))
> +		if (KVM_BUG_ON(--kvm_tdx->nr_premapped < 0, kvm))
>
>  			return -EIO;
>  
>  		return 0;
> @@ -2846,7 +2846,7 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
>  	 * TDH.MEM.PAGE.ADD().
>  	 */
> -	if (atomic64_read(&kvm_tdx->nr_premapped))
> +	if (kvm_tdx->nr_premapped)
>  		return -EINVAL;
>  
>  	cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
> @@ -3160,7 +3160,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  		goto out;
>  	}
>  
> -	KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm);
> +	KVM_BUG_ON(--kvm_tdx->nr_premapped < 0, kvm);
>  
>  	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
>  		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index ca39a9391db1..04ba9ea3e0ba 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -37,7 +37,7 @@ struct kvm_tdx {
>  	struct tdx_td td;
>  
>  	/* For KVM_TDX_INIT_MEM_REGION. */
> -	atomic64_t nr_premapped;
> +	unsigned long nr_premapped;

Due to the comparison with < 0, the type should be "s64" or "signed long"?
  
>  	/*
>  	 * Prevent vCPUs from TD entry to ensure SEPT zap related SEAMCALLs do
> -- 
> 2.51.0.268.g9569e192d0-goog
> 

