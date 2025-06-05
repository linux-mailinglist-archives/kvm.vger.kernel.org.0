Return-Path: <kvm+bounces-48493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A35D8ACEB76
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 10:09:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BFCB174FF2
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA2820298C;
	Thu,  5 Jun 2025 08:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="deYHZbMt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530781C27;
	Thu,  5 Jun 2025 08:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749110932; cv=fail; b=DNm+cLgkkjEBjjjSP4kipQmsYEhK0LdYYXIR95NB3MTEohJ1b2pH0TuJkz24/yhvCVaDk+oO4nQZcQRLyT1+VnHX+wF8CvHvf/P7XmM6a2hDLufcdnJdfboSBtq7tmQFoCZuVUektz03F7zJW3OW5F/y9KMkfgZw009x8IckFU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749110932; c=relaxed/simple;
	bh=se6fLA24L7yCG3H6kQhQQmDz2kulYtCPh/nuNGvmVHI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fjD61wfV9iK7l8ViOrGCcc6mK9J1QxNJbHErNaq0YmdLqTG7CVVV4RyBRIdjhHm1LknYl0Gb45Z/iYlDzyofmiCKaoIqBLEE/AYWe/dYapmW1yUnjn442FapYkVem10KnC2QnThaQkfaKUMxBYPppzO1Ucm/RwIdQvhrfC/O9HI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=deYHZbMt; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749110930; x=1780646930;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=se6fLA24L7yCG3H6kQhQQmDz2kulYtCPh/nuNGvmVHI=;
  b=deYHZbMtudf6hcvMOk+1LWCwky/VKi4IysNVqrB6SWAPmAPTchv0iTKi
   zPwni+r4F1k0ogMZnrDrG9L6SleN3nS30Ox+hexdJovftpbmkJJNQeryf
   tBFSwPnS9+bMaEG4ML3B/aQcUYltjvDVXniYx+YkKVvpQwJx1GgNmdSfq
   dzMPDuPyF2h7rF6C+N5vKds0wefPtk1Dr6g48LP1J+6HNBS7NY9uhvhlH
   bGhJ2R3eZeP9ncWKjc7yVfeSCs7FuE0SwaMYTr2zpbCQmcObxhalpAWa1
   N+HgK4BmtKev/5Asynva2CD9jgvSVguebqN4QYrZ2SN/EfW3bWr65OXy0
   A==;
X-CSE-ConnectionGUID: E5x6l6uvSeKKhOjN7c49xw==
X-CSE-MsgGUID: ofevMRaEQKiGilk6hgKbYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51364633"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="51364633"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 01:08:50 -0700
X-CSE-ConnectionGUID: rqfGRQfIQqG8fuMlhme4ug==
X-CSE-MsgGUID: Yf2i7pThTRq6pG+ROCAGrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="176388915"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 01:08:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 5 Jun 2025 01:08:49 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 5 Jun 2025 01:08:49 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.47)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 5 Jun 2025 01:08:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qdJDopNvsVAZcPeoOnpQYmqDKFqkclwQKwE6YY/vCjMnGLi5fBnUpwEqNH97iSvt4NpbgvhQZdR29mLP+dB7VHuJ/bxyL7ttDM5KL3b4tsYHnKZ+paJ4uIczE43qv9EXW8o+4e7Ju3i93++qOfT3Je6U2nxWADV8SL56Iv6e95UO7c4QLecn7UDQ4LQeiBEKGOUhwXWGNSuM/s/23Um4Zr/cU6es/hDw/gh1spAYkvHFoKSirbobuOiw6WxK7hjNnqxQbd83bLdmxzKCtijxrTpqsgXrOxctnNCQjIo6mVWX/nyyFL5aAw7FP3Dw0igLeLlEL2xodVlKKk7MUyhQ4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtQPRvfUD75nuWktZqxb1K/75w6DxOZ11wlLzqEbtgQ=;
 b=jlrATe5G2XPBwJnGB6C59m9wa9JzTs6Aq7jbrhiBqtJsLXk1qMDJX5sVEh3KesJrx1RVdd8qdShzuH3YEmKGgZ+OZsEmFqgLk46a5+4DMc5HT5jY5oclOr9NlyJJSEuEatKYXqwGbcDtt5Tg4/+Q1rxtkgK17PvjAkqU6p2KXrzBt1YiAp3kBG4/p9BOYL+80opCxNdCw4ZiMHzusZjnd+wbXKJ/mvkYYXDmGv+o4ykdxZZT8lIxFys4roN7y7kpCEwxdcFOm0QS/5LiFA1zZDbobmZvO7IFTlmVKG9D+2Uv5ZrIj6IYDOx9u0QEMIUIiWOo+fBzwIdzsPJCxTyC+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB8227.namprd11.prod.outlook.com (2603:10b6:8:184::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 08:08:33 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Thu, 5 Jun 2025
 08:08:33 +0000
Date: Thu, 5 Jun 2025 16:08:23 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Xin Li
	<xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 08/28] KVM: nSVM: Use dedicated array of MSRPM offsets to
 merge L0 and L1 bitmaps
Message-ID: <aEFQd8E4RDvLR5tj@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-9-seanjc@google.com>
 <aD/c6RZvE7a1KSqk@intel.com>
 <aEBQchT0cpCKkmQ6@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aEBQchT0cpCKkmQ6@google.com>
X-ClientProxiedBy: SI2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:4:196::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB8227:EE_
X-MS-Office365-Filtering-Correlation-Id: ca531a0a-4b1f-4f97-4dbb-08dda4082a3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Zce/mLDxk14w3l8e5P4KAfLuekRys8sdFLELq0KwDg27nwbTQfpWToAQt1IH?=
 =?us-ascii?Q?rQn9oDzZ38lYPMZQbVZoSktNErevzl/+lDmuBg6eFn4NNRyl3wlHX3boUjuH?=
 =?us-ascii?Q?kutui2810GShbQx1mEqs0fqlRj3FdFp9FL5670GQbOnff7yRDZ7155I5+JBd?=
 =?us-ascii?Q?ae6ZMNLuMxyK/YJanp1T+iyMDOXmoTkEKu4H3jJjcLHjoxT2iKchHkcaqDm2?=
 =?us-ascii?Q?6aGuZzosM0Ka4rZo0Tt0w7NTDM9su/9YC/CAaZfz/5PxFEX/GlsVn6Rgd9OB?=
 =?us-ascii?Q?NjaPMNj3W2455HRpkSOzt/MjErP8jvn4u5x7VnlFi0W5m2+CaikDhQHNW4j6?=
 =?us-ascii?Q?8TKGQnZzu2rpy0TUwtyU+MDJF0WCzDhN70wp8ghawIAcx7oxNVdDQ8j5kn7B?=
 =?us-ascii?Q?/QU7pHbqYvp1jMa2T4yhmc9OOQEprVGsIqWhd/cQWfCSBaXGmBjxMcKSOd40?=
 =?us-ascii?Q?h4U40HzARvaNP24m3NhAlHNJ3bg9rYEIO507VBr5K3YOwSNmmZ73Y0FzE4ek?=
 =?us-ascii?Q?C0he9gTXj19qjXtzBZaSCWbVSSKeB/Wzu8RNK6FBjyODM4P8pxnDRN7Xznt1?=
 =?us-ascii?Q?mI05cwVeN2qYJJS3UcvsnwfsNrqKMQOQiipxr6W2xo0lSndBBYWkTmBWQADJ?=
 =?us-ascii?Q?6EVX6niPG84zX1sx7Z8BNHoZRbaTCbKsSONRBhUpeOvBwylfp8zRIS0DKU9a?=
 =?us-ascii?Q?XXJidAqup+PisZuQ3xQ5z0XOqE1yLZrggsyutcD6VnAWCEpbyemIV7RQDzZd?=
 =?us-ascii?Q?eU1ntC9RuIokL+aBzoeIgw8tAZ6Q4Scvwgy/SJoUjuCYMALYoGD3ihX6he5n?=
 =?us-ascii?Q?CzMc+Bb/ks1mWdmljG9cR4NStVhJyZwrKhPXvr+gTGImoRYdjLJijLRD9Fdp?=
 =?us-ascii?Q?YjDyFcGg/WsO0NeIHY/7zeB9AXSSNjd7ZVkY0YsoQm9n5Lj4jgbsBsCiYfiz?=
 =?us-ascii?Q?ORppQKiMtvPQvTbPIXSFNogs6sMhNDX75BM1/J+LVkNTDY5wdookcBgKdvmI?=
 =?us-ascii?Q?ynQaqehOlsTCM5RnYWoXQTq8cBV57g2Ihi31uAclU8veRndWMSUFPCYTo59c?=
 =?us-ascii?Q?Rl+Lp+0n0sShfPEu29fIlpyov+uauP9lubZcQpc4Wc2GyR8kp+3Qr35lTcwj?=
 =?us-ascii?Q?wsGr4WSTgkxkj/XC77ZKU35Y0jJqJdXDu+66vsUH7T2e5kvYAtCeVsPYjxbS?=
 =?us-ascii?Q?tfOWUV7g2Ga0ul57bxFERc1nBTMlD9KL88cVyS5oWYN31WdDg8wsX/m9oWnz?=
 =?us-ascii?Q?1lR/XXC9PNY2d1I5JXn0XnIFc8UvIR993tHsfMmDdSkCGNysrCvhFHHo4qr2?=
 =?us-ascii?Q?ILkXL7AhcoAIIpbT5c9FIlVpbAujIz2SG/9yrhZF7MtE/lwnF/jJc38/4nvb?=
 =?us-ascii?Q?ELgWUBGu5Nxlan6FcwU4xLSVDkQB4YjUXqjFQrPXfeUxkJLxIkrEv5roCx0W?=
 =?us-ascii?Q?Cup+Xecbluw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BIQCnKUVyfNJPqvtfMFy6esnSjYzhIoRj6/PPtJHlmO4+tV1odYMH6hA0WC2?=
 =?us-ascii?Q?IP8vu0CGP4NfeAWBaVwC09uAE5RUkmIana3nqidmzr080WGK6NMXLCCGPsgN?=
 =?us-ascii?Q?aQCNiO8vYBMRBL+4fzLJV3lCt6bg9VA8gj7fnnW5NftfcaJCayK78v1F3uf7?=
 =?us-ascii?Q?yBMXwmLNHL1/UhMIfdVLWHcy3pymN6i//CtKCH8fI6A4abFLRhnMQ6oT+XvH?=
 =?us-ascii?Q?Dui7kl9Gy8tbQz6iCGN3oBpV8bWWgNO44VhNsCtvECvhZUTVQtk+zWr6tZSQ?=
 =?us-ascii?Q?XRdbY1WhE4eDJiTpRs8P+n3KdorGy+tN6okN2mtYsefbs4EiRoaBJ9lPCTbg?=
 =?us-ascii?Q?TpHm07tey5EJ2Gl/O/5mlseLMsZ0423FZ6dHi5fuevtSDMjG7V3mmoOmlFJB?=
 =?us-ascii?Q?HMITgTOHYM67AYdRFxEj+NjXYmQ8WvoTHMwe8jnX0DjwZWVVk7eFu4emxvIg?=
 =?us-ascii?Q?U6qDHhFCkC7hrl7xV2jCpvxYhAxRpIdTrKlM0micCJxuE7VUqdbcuW9qVgS/?=
 =?us-ascii?Q?6oIub2gx+CZBRaAYGbFrF/fq7dk02gjgTClGW1hiz673jlSHMVwSE9hc1TYA?=
 =?us-ascii?Q?YMkXWaeIGwju7FMP8So3itrpSx25S2hklv8EJjekHMezyiZciE9LyOiNfgnC?=
 =?us-ascii?Q?izRR7ftnnluLQ05BfEJ/ODmXMJZr8eKD4kzDTmq2Wm3LSuJBRm8wIeWOxKjg?=
 =?us-ascii?Q?Z1UMfc8/KqlTRzba205HleKNN0GUowABBuUv9hK8k1shJagcnAdVicp3hJJb?=
 =?us-ascii?Q?GuupfwGM97IhXgtfxWG7amP6HKmXCb8c29ZKJ3WuYL9g4liIyku1tsVe7f2g?=
 =?us-ascii?Q?CqOzqwE+h9DPnh0d806dPrqtcafzf2lAjorQIWhAn52QFqZiw0e9lPJRPPmx?=
 =?us-ascii?Q?rp6ntPirDG5fv1o6er54XjHgGdjMf6jLfuW0bN+v81vYtsTSMtd1fdAlJHab?=
 =?us-ascii?Q?0HgwhLHzaR3ydZ8HwlKDi76VuVsTQrRI16uAan1Mcw5SJO7qx0OFvkfavfY1?=
 =?us-ascii?Q?NzHjM/OZ+IpCtKMa55fPTMZmIoSn/euBCHhPyl0IbKzmEM5uuhAseiznd/QR?=
 =?us-ascii?Q?WACWs8s/zyqmw37A1haWjFOryUvBdbMU3qZvYL/PXOXHa3k7T4oCjp4WCqmT?=
 =?us-ascii?Q?Gif+L2MH+mZO3z1rJdvhb0fAMxAPNXemOThzuVSBKI1pUmIDzVikEKhrB7RN?=
 =?us-ascii?Q?oCMI/YPm/m0qyFOGd53DUsxm7fQIPG7I0t4SkzX/DejTRp9OFvvRcC0DdhSp?=
 =?us-ascii?Q?xXm5Wp47T/b309SVqRXUqKtMUCXbxmwp++VepEfQrciBpSq358rirE5CYX/V?=
 =?us-ascii?Q?dNWM2RYbj4lCJpaql0LUz8LmebqxzxwLicdJGu+zeOzwUhOvYr3kd7rFooWe?=
 =?us-ascii?Q?khyGhmTZDPEdf+jqOcfnxBZanwqzWRh2iQor90o/UbcDzApSIfEeuWC1P42J?=
 =?us-ascii?Q?2DNEzU+JzrVM59Tr7GinJ9WRIAdfbP6GzToH6uyczH6AI/BS56Qkvt0O6g1J?=
 =?us-ascii?Q?6gah780a+PQgIRd3mdeuOvOXbaiWoAFSoR5fU9NEoBiH5DRYZJxwrTrdBx38?=
 =?us-ascii?Q?+WB7jiopRiGpnArxPXgDgyeoHlI72OmftBZ4Dcs6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca531a0a-4b1f-4f97-4dbb-08dda4082a3d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 08:08:33.5283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4GlCOa2kdtDs5JboLitin4macXtGmXX8xAhjyDkMuZlE8EsylF78154K4JhkSwZGlcOl+1ZIz+SI90jMuWkOhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8227
X-OriginatorOrg: intel.com

>Me either.  One option would be to use wrapper macros for the interception helpers
>to fill an array at compile time (similar to how kernel exception fixup works),
>but (a) it requires modifications to the linker scripts to generate the arrays,
>(b) is quite confusing/complex, and (c) it doesn't actually solve the problem,
>it just inverts the problem.  Because as above, there are MSRs we *don't* want
>to expose to L2, and so we'd need to add yet more code to filter those out.
>
>And the failure mode for the inverted case would be worse, because if we missed
>an MSR, KVM would incorrectly give L2 access to an MSR.  Whereas with the current
>approach, a missed MSR simply means L2 gets a slower path; but functionally, it's
>fine (and it has to be fine, because KVM can't force L1 to disable interception).

I agree. The risk of breaking functionality should be very low.

>
>> Removing this array and iterating over direct_access_msrs[] directly is an
>> option but it contradicts this series as one of its purposes is to remove
>> direct_access_msrs[].
>
>Using direct_access_msrs[] wouldn't solve the problem either, because nothing
>ensures _that_ array is up-to-date either.
>
>The best idea I have is to add a test that verifies the MSRs that are supposed
>to be passed through actually are passed through.  It's still effectively manual
>checking, but it would require us to screw up twice, i.e. forget to update both
>the array and the test.  The problem is that there's no easy and foolproof way to
>verify that an MSR is passed through in a selftest.
>
>E.g. it would be possible to precisely detect L2 => L0 MSR exits via a BPF program,
>but incorporating a BPF program into a KVM selftest just to detect exits isn't
>something I'm keen on doing (or maintaining).
>
>Using the "exits" stat isn't foolproof due to NMIs (IRQs can be accounted for via
>"irq_exits", and to a lesser extent page faults (especially if shadow paging is
>in use).
>
>If KVM provided an "msr_exits" stats, it would be trivial to verify interception
>via a selftest, but I can't quite convince myself that MSR exits are interesting
>enough to warrant their own stat.

Yes, there doesn't seem to be an easy solution to this problem. Given its low
risk, I think we can live with it for now and revisit the issue if it truely
becomes a recurring problem (i.e., people keep forgetting to update the array).

