Return-Path: <kvm+bounces-33295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7678C9E922E
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 12:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FFD22820DB
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 11:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4748121B1B6;
	Mon,  9 Dec 2024 11:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bZ+cYaf0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BCD21B1A8;
	Mon,  9 Dec 2024 11:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733743742; cv=fail; b=LT6VeUjZpM+7i3POc9DO3ctQMmAvtBKmd1as7RuXD557BMl1OynVjGQyS8J9bFW1u7Oc4SupF8QSxeE38GnbD8WmjeLbyCHOB4vU9RbqVUGBfJ4OKO2a1HZ52u8jBooDJX/8BcNeDMwFJaXlnyjStO3ky+YdD44Ez+912ntyrkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733743742; c=relaxed/simple;
	bh=pzguZLb7X479+imGaec1D/aYBYbJriYk0cU3gbov8tw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tJAhOxG/olrFi7ZwbjrCnOnnOl0LrxxzMJuBaMoajNC3D6BBAtCO+C0LF+9U24TbUonrvv9xt2bzc4yo0ON7rzkvATSNB8EdO6eXwXvYdKCki0ONDCkUzSDqBkOZH8iFx4iShaWlbV6GXc+/pQYDn5b+IUsvqd3+Da7pQgEIUjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bZ+cYaf0; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733743741; x=1765279741;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pzguZLb7X479+imGaec1D/aYBYbJriYk0cU3gbov8tw=;
  b=bZ+cYaf0nMJUL7SvgGqMgpqs6BD5Yrbtrwfbk87TxHF5P0xX3iE7aRFs
   i7dmJ1TjgPgaYbpiAQ1mYtmaSUlIbX8E7BGWDkEvN3cXVUnqLLPeRugg9
   lee1W7+F+BKwVjfXPBvyCMarwf5uh4arAtKSvZIV5MCb856Puvm+JgdEs
   RUk3+QAMvQB8ly7+LybrkZhokorcoheoINg85J1Wzxngsa/8SmiIzUUGj
   1k/BpHDsApvsENmQAcXC4JVhQxPS9xVENh00J0bmogu58LY906poe6Qb3
   dxwSQxHxweztFjRB/qJstYsigLVprEPMF0aN1LOIgXmreu5g/8TRPur9g
   g==;
X-CSE-ConnectionGUID: Flz5G2qbSZmkgDTLk9xwzw==
X-CSE-MsgGUID: tpaWAsC7QSmYg6mQyx9KtA==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="45411060"
X-IronPort-AV: E=Sophos;i="6.12,214,1728975600"; 
   d="scan'208";a="45411060"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 03:28:59 -0800
X-CSE-ConnectionGUID: cOCNFBb6SQOMEviFjot1+g==
X-CSE-MsgGUID: T6fK4015QpmLdgRJ2Iv6hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,219,1728975600"; 
   d="scan'208";a="99860168"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Dec 2024 03:28:58 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Dec 2024 03:28:58 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Dec 2024 03:28:58 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 03:28:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P7aIcm1mEq63b6feS1morlklTun/RnyKK7Uiu1G+aK2ZT7LBnxj6jz2C4JFNUQxlmHHC8XyZM7JC1DMS1wVfBC3wf/tAv6NjjTlpb9iNzut9rjXL6pzM/cw51wKeQAHC4WZPsiSgqcRUkNX0txOZeW1O+amsvX4kkGcEj5Wg7QhcIksMNx4o7LqG5Ez5VpirpIpnW5uVVkl9UK3AFlHcIONHcOVGrjgrWnGnhMZXlt+/0tUoWtVwO6qoM9HlWS9Z3V4L7Gdy9k8AdlwNRuovwMaPuHwzLupNh6XcZRJwRt4VZC9rQ9uzZRpwy6LsgxtQlpWgQc/B4uCLRjnygsQ4OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzjsR3nISO3jHGp2VqlMiHoznzNaiUwu+6SCLYT65Pw=;
 b=VTu7i3RzhTCbL2G5z6JzeYdyULZ/5lgllqSXRQTcCsbJ2Ss3nN0mJZrKvlyhliTqAnXqwcj6WfSwI/aPbk+VOth4n7A8GkA9nA5cCXhy3+NFtUwH7AqZNHhAaM+8Vh/qcA1gXLWZBeUurIZuZoAU2lQQJLVB+k9YmNtcVhppCM5ZkPW5Z5wM/MSzQW1WOgVaKjgQSR77pv62DjkZ+vrGuz2qk7UtxumlbXXB7elCNqHtheZfs39qY3XGc4mNAWEFmdWDSwdEtJaYD8lhl1OscLYPVUdHF02i7/9M0GQ0hVCSxnmzKYu3Ol/3i9M/j7oaKoTXmQwszfbonE8MRudvsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB6104.namprd11.prod.outlook.com (2603:10b6:8:9f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.18; Mon, 9 Dec 2024 11:28:55 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8230.016; Mon, 9 Dec 2024
 11:28:55 +0000
Date: Mon, 9 Dec 2024 19:28:45 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <michael.roth@amd.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] KVM: TDX: Add a place holder for handler of TDX
 hypercalls (TDG.VP.VMCALL)
Message-ID: <Z1bUbfl8vfVvA0zW@intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-3-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241201035358.2193078-3-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SI2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:194::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB6104:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bdf7776-dd53-42ed-e8a1-08dd1844aa5e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?liIweo+eK9yuzAX1TePhfNKykk2weZC+6bbOPvwkAZplsQXPEwzdyHB9i+Zd?=
 =?us-ascii?Q?Y1OsehSFpYbKUgy7gKzGQKns7a8XEV7QUqIkrKQbuRZx+sr/7eHbPfdc9fZU?=
 =?us-ascii?Q?PFT6ox8mPESQet6+Z/K28EgVmYi/wWNbzeUAevnH8zAb4zcwarGQrBMNGDYk?=
 =?us-ascii?Q?0tNBYBT8PIoC43SlxJdOE995lL4HZUTaqIi9cNPttx/d/116mruo2hntrxRw?=
 =?us-ascii?Q?/rHqx6WkFo/v249NuF6idQnMaeuFoJrU+rfZvJHqj38fG1GjIdiORoNVRny2?=
 =?us-ascii?Q?yFZFaiTFec3YbzOXHvIfYLwGvb64/lmeDryNRBOcFKQBWHJkg/vznLvG9Qv+?=
 =?us-ascii?Q?RujLcf1TP6AsA8cF7BfoB6e4yuc7GRHjobda0tLwMTvHzpnH9E2kIcd4Ytcb?=
 =?us-ascii?Q?Jz8MhAhVbZr7tpkFU1LrsYbL1D+kXZ+1mbc/ohQs4GG2sSKG+aItzpc4ZsJI?=
 =?us-ascii?Q?hfzurItThcsI/aKPMiy4J1pB4bGieOLkYpSGkmWSYx07xJSAkuQjlssaRzZ/?=
 =?us-ascii?Q?uZ/3n1OYZEe3TYB9KLrQQPwFRi1IOXX0rqEVKb5Zx6fkAPElIRehJUwyxi47?=
 =?us-ascii?Q?BGIXUcu9kak5Beo2ERD1fmfVvPXTQosbDRhNBwy5tsDvlVQbpxJourvVdJzf?=
 =?us-ascii?Q?/LtP4djPJVXsx9n1AMLGOFreSPpHZfIJI9/61DG8sxsBKp3h627JQZwtO7IZ?=
 =?us-ascii?Q?8gN2wWSoQcsGiXmZ1Z+JPSMG7QDFpIJY9Lf/tKR/nmufiLUxUmG+Nf1XxXEB?=
 =?us-ascii?Q?WkRxSs8yUAuyOFSckxBgcv/BhfZXrDbEDE7hjxyECrqHgIvbelEZ2mpYSk/7?=
 =?us-ascii?Q?nMfovd+njXoH4Ds7FDjESmAojUJ91lf54BjDrQbSSKg/IqbF38mYvMt6Q+R/?=
 =?us-ascii?Q?tbpKlGVHw6lJOAmwaiNwK71NLJWHZPZw0rHTDoU7bPoAlIozuIYAqHTrr6NM?=
 =?us-ascii?Q?0kL2kgNbL1Gce+zrP2yokcCYGbaWwBGpw9f8o5lSQj2xPw8bm4tIy1aTBcmV?=
 =?us-ascii?Q?c/ceH+heLIelDTMlIwkQVn+Vr7QlxDbXQDhmdKctgf9Rx5ywMhPY/ep6id7W?=
 =?us-ascii?Q?xLE3qb4a5QF2/14wd9LxpcrlmmIRc+wikXYSwQmhmhPDIXMI5a/T9JYmEKm7?=
 =?us-ascii?Q?N8DjP2CBJt/2wnHcuKnWG+zvvJ2tDXPd6zAHLI2BOLlLlpuOPANLV2yr1ObD?=
 =?us-ascii?Q?7b4zdNepQWCmKnpKCAhl2dURauYWIQBANicwD1ZZPLj8D3e5B99uGcz9Kn3B?=
 =?us-ascii?Q?wDO2sAyLXMNZvsJ7GkWcOiW/u/b1W66S40iXJ5LBTwrGZFL3k7h5vAfLJp/+?=
 =?us-ascii?Q?f/4KpeZpBUh/UA3sBHG5Lz1F9+iKIUcI2JMXMICNG1pM9Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R2kwpG3JHiMpuSrb9R4fx01p3nTH3IFf1/tMH4zmoY0LPz0eFWm3nrPxAzEy?=
 =?us-ascii?Q?9wRyGGNMJcIElusul2TY7sXZLGCxQ7jlbhs/G/YhB4X67WQkBQWjbz7anmmp?=
 =?us-ascii?Q?828Kz/1kLq0Si2VRT1frVPH5LOzi/CDiuwM5bXPW3G6Ylt3K0f0vF0J9EqSF?=
 =?us-ascii?Q?VevJ2hezX0YucuRMQ8/f27aNdOmv4ix286cNSaWI5fvuIYz6u6UWThBHm6SQ?=
 =?us-ascii?Q?QvuwSMfBYwkjYCEwx5JxYpJJQA6AD85u8mFm/OIipQr0GmyASaQ+niEOBpC4?=
 =?us-ascii?Q?NBJb1Du+rwLHEsCrqgdynzL1RrRcThxr5jwuVAXr7MhxVFlnjBkEVe6M0WsT?=
 =?us-ascii?Q?0dMefn5XP+pci1SjNbxskYb4KlSYqr+cqvh6lpy8fzrxwrNjR0xXczf+pjkV?=
 =?us-ascii?Q?SFlEIKgvJbHGMrUr+kB9Km5pNEcrYQCHCxNIsk6Emk1DLOM11/afDBaiAhfS?=
 =?us-ascii?Q?8kOwhN+9WHTCY36MS/Xw75x2hpRYs1QBkq5MvJPm0yy9TpG5SlhdxvfAvRAf?=
 =?us-ascii?Q?zk7f8huqeM1PeircNA7vpqmPyCnlltYFrcCcgD9aR8gpkQ/zRoE+GdH7h3v8?=
 =?us-ascii?Q?/DoYyjnvNwlO0ovISepAEA/fzDTLW/ecnKulyI8TOycC85Nrc8BUNp2q4uTi?=
 =?us-ascii?Q?L2cvlOrUmghrVP8KEj4epP9xPMmITZIhq4r4r2B0Qjo2pDWhn+/mNETFPeak?=
 =?us-ascii?Q?cSOzbXUfGS+YbU8H72Piw5NIvaPaBLjSqNilSZpS4frDxwLPrZi9uhO8gOcS?=
 =?us-ascii?Q?8JxGpM8UxVb9DcaKzo0uFYBzYSMaykgirus0s4q1HZlTbUcdllymv8uxakcA?=
 =?us-ascii?Q?mpruPc3h2ZVpynHHfM71Aalc7GRzkVJUEanJH79QJttrPbTrXyP/+Xhp7Jdk?=
 =?us-ascii?Q?fQCXisosmPNh8Kc6aGdXjPU/vG+hfKTku/cB2DK31h8qow4tKmoTzGQMcqlk?=
 =?us-ascii?Q?JqW5TntcvgjDX+D/F2xL2oyzlZapFQ3lVZ7lpj7nYZ2YURTEREXQ1Ev10o95?=
 =?us-ascii?Q?tk1CY/LpD7ylH5NVVl8276bRBpVPf3YPmo2hUhJuMVoE/KOyZOXYNtQn44Vi?=
 =?us-ascii?Q?cvD/HB5PNALeAx6GBZ6gtWQ5dTqu8m2+J6xcjZHsAtH1ghFCWvq7zgOuIzyb?=
 =?us-ascii?Q?ymP56gx1kzU9fBWTStsXnM9wJRsH/RIiBvTPYUgp8jEDANOIgLfA4N/PSm92?=
 =?us-ascii?Q?YGwRm4izsfB0fWaUocMCzgShU7CrtmwVGZ16oXobvYXt8e8YagL9AJVB7zQb?=
 =?us-ascii?Q?zamlLJg4me5hrPim2GYldLPY3iIHwql4zk1CaaOSmFrXfezNZuNofI0bHVlK?=
 =?us-ascii?Q?+ZjDhqYMDiQK0tgSkksULqqfn6M2ahupmcZkNcA6ND5/YAZBKqaZi9NYdYWW?=
 =?us-ascii?Q?JjWk0kNyPTcsLBHGv7kVEMfrKeJNZtElLFby0dvJUrqgqlMKLLLms/E4GPFV?=
 =?us-ascii?Q?CK4mF3c2NdQ0CmBKFeh3dssqzohNNI0hrjc6fKr5JmOBu/MmaSslov6S7PiV?=
 =?us-ascii?Q?SgPsqvt0vlDYtmjW7v6E3mnQ4SyoYJgEQxMMmNWgn3bCaSuexmS9pdPM1i7/?=
 =?us-ascii?Q?8NZw9rVZW2+qT/1KTsOSr4pGdvXiRDfa97uSe7IX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bdf7776-dd53-42ed-e8a1-08dd1844aa5e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 11:28:55.3663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kPa2lOfx7l9hrr8KICMJ+a8sJDSBA0eU6hBuWpc5BLDs4+cQ9vaUqpPqzjBlDEk9NVfAvBBGthcGT8zoRYY2Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6104
X-OriginatorOrg: intel.com

On Sun, Dec 01, 2024 at 11:53:51AM +0800, Binbin Wu wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Add a place holder and related helper functions for preparation of
>TDG.VP.VMCALL handling.
>
>The TDX module specification defines TDG.VP.VMCALL API (TDVMCALL for short)
>for the guest TD to call hypercall to VMM.  When the guest TD issues a
>TDVMCALL, the guest TD exits to VMM with a new exit reason.  The arguments
>from the guest TD and returned values from the VMM are passed in the guest
>registers.  The guest RCX register indicates which registers are used.
>Define helper functions to access those registers.
>
>A new VMX exit reason TDCALL is added to indicate the exit is due to TDVMCALL
>from the guest TD.  Define the TDCALL exit reason and add a place holder to
>handle such exit.
>
>Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

>---
>Hypercalls exit to userspace breakout:
>- Update changelog.
>- Drop the unused tdx->tdvmcall. (Chao)
>- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
>---
> arch/x86/include/uapi/asm/vmx.h |  4 ++-
> arch/x86/kvm/vmx/tdx.c          | 48 +++++++++++++++++++++++++++++++++
> 2 files changed, 51 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
>index a5faf6d88f1b..6a9f268a2d2c 100644
>--- a/arch/x86/include/uapi/asm/vmx.h
>+++ b/arch/x86/include/uapi/asm/vmx.h
>@@ -92,6 +92,7 @@
> #define EXIT_REASON_TPAUSE              68
> #define EXIT_REASON_BUS_LOCK            74
> #define EXIT_REASON_NOTIFY              75
>+#define EXIT_REASON_TDCALL              77
> 
> #define VMX_EXIT_REASONS \
> 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
>@@ -155,7 +156,8 @@
> 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
> 	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
> 	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }, \
>-	{ EXIT_REASON_NOTIFY,                "NOTIFY" }
>+	{ EXIT_REASON_NOTIFY,                "NOTIFY" }, \
>+	{ EXIT_REASON_TDCALL,                "TDCALL" }

Side topic:
Strictly speaking, TDCALL vm-exit handling can happen for normal VMs. so, KVM may
need to handle it by injecting #UD. Of course, it is not necessary for this series.

