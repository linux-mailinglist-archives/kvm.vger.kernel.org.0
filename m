Return-Path: <kvm+bounces-25427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D7496552C
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 055D1B20C71
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 02:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEEE27D07D;
	Fri, 30 Aug 2024 02:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cNKveWlE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABD13FF1;
	Fri, 30 Aug 2024 02:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724984168; cv=fail; b=h21sN/cSCz+oYL4Th3U/CWgtbwY3DUdLX/xRcVHuqElXjtYQP9b1azGPCacSneS4D4LGy0LBjkriORds5rE2d7y4YeN7T18nnk/QzOJbyAcwcWSuA9lGDuucjbjW9dJo/hv9YYHnJ3H6E59BHlTtN4L6MfmAAfGDI70rksEQI28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724984168; c=relaxed/simple;
	bh=0B70tihWuhbgedb24Dru8hm+6sHbDQcjyMVCNSh23Ks=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JlAvdabx/HIo67OkCS06zcbiUsRUJ5SPXaZrZ9VHCr2YDecrIAWVLHXIVjSrgiLuYQh5ZLhJ9ClrG0bnxcWXDO0YSTG4HSx3plitrP3HiNumrQd+c9gNSW6R7zfm/vNleFaXmDFch6HOSJa0fABkDErb0pWBltQZiDRsqVfqSEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cNKveWlE; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724984163; x=1756520163;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0B70tihWuhbgedb24Dru8hm+6sHbDQcjyMVCNSh23Ks=;
  b=cNKveWlEG5PAM69l4kW+TwF26ElQhjafzRcdtZZ0HoqOOuje2hdnUDUZ
   GMpTcPBHL38XhA1xa2kJuZVd7q4vO3jSDj+Z68R2l30Id2Vv9jEhXJyyn
   HB2Anf3Ua4W8XJ9HOrwFhFQF7V1K/Vfbo/ygvnHWXp/as9BEcjbF/5WSS
   6zHnPKZpQsrgt2LN4sXrWfKQmUjBrsdx8gyzJ//l7HXenQheRvB0BL4cH
   MBl5Kij9hqs+NUgG+WVfX5tlvnHfuPIjXT6aHxeoHwaBd6zq6z1L+PeBP
   SR4dEDj1Tw7oZVB79jFJs2nKKq70+eOM+Y+xV4VT6SDtAMb+zrTGoZBIj
   g==;
X-CSE-ConnectionGUID: NsK35VABRby2U1D3QiLpZQ==
X-CSE-MsgGUID: MDUvjAHuReKefWGSA6qG2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23799548"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="23799548"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 19:16:02 -0700
X-CSE-ConnectionGUID: 7rCFmEt8SxaG2LErid1Rlg==
X-CSE-MsgGUID: qs2bR5JTTSi701i82Q8VAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="63744586"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 19:16:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 19:16:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 19:16:01 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 19:16:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+/763/b15qercMFQvcIHHbF1hiGE0+nmT7XsEA5YFnJwEJzN4q6b9Bnzs2+Fjejxk1XzRSj4NSlFzAIhRcXtIV1byzMgcp6FNYhGi20XZoW1FJofPl/FKLz/h52IAejWl4V8lSGJMU3/b5vcGHqrX1HVaNCdXMhe1PTgYHy0GtPStKfh9OVvYAPy5viTDOx5hsnfO5QXNJqkjFJ7/RMSUcZVbUg1qRU2AtV6nqFAPXpToPpY1YnAO9cItnX4WJL/50E3RZDUyLbxFvONqgRZ5UVoPqGNhjaQNc40tYAcI8h7q04t7Nj0gV6WxtsoNHHyN5IIMvmJmkDXfXre7Q7fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7oad36WWjAaYqTzn/ODIR90TeNzaX7hkBwrTIE1qBA=;
 b=bjHI5YhDrZJD2ZYsCie4z/fCNT5v6BmdWlCxZcaGURwehz703zLCAq7jyCZLYqVK0wIyQgWfYH1KvfnyxhL7/bN6JOFVNEC7Kj0O/iR/gNzJ9i+OIot0hRglJnnUPlGuCNRs3gHRGvQ5/V1ZAZtKUX7vSxfpKwGjf37HMTVpiWmbq1MvimI0Lx+2y+wNyau9wJ0nlDrxB4xM7BV87KraretvOOAerrOy1Hb6BXlPPTAmDtACUtFCJYiAPbRqQoA4HGaL9weYdBwXSxPC8GpAJCJn9ebQL0iX+JSp+5ZWIp1xms9PGjAyMX8VOqVZaRhqoml5vNVIv8adtUDIA8gLCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CO1PR11MB4897.namprd11.prod.outlook.com (2603:10b6:303:97::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 02:15:54 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 02:15:53 +0000
Date: Thu, 29 Aug 2024 19:15:49 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: Re: [RFC PATCH 02/21] pci/doe: Define protocol types and make those
 public
Message-ID: <66d12b55bf5c8_31daf29419@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-3-aik@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-3-aik@amd.com>
X-ClientProxiedBy: MW2PR16CA0037.namprd16.prod.outlook.com
 (2603:10b6:907:1::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CO1PR11MB4897:EE_
X-MS-Office365-Filtering-Correlation-Id: 3699ffd6-bbac-409b-1fd7-08dcc899aceb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?69jxr/bXuuS/sDAlbkQVN2xCwLpbwIraQC85X2FNkinXqHJcOG1aOx3S//Ml?=
 =?us-ascii?Q?tjWbk6oausQtxv50irQ02q5dXc5ghJhtOsnJGDe/EcZz5NE/5b3Istt2C+M0?=
 =?us-ascii?Q?PlvjBy8glt9uLJzcBi8HzRgWPwS0/cky8QPv5nZOis7XG230uW2cKWQZjbfa?=
 =?us-ascii?Q?1xYdf4VuXMsqSsQ9xcu/WT54OXWBeY1fYo/2uxguBBCtP/ILKVPq0gL6UK8c?=
 =?us-ascii?Q?4get2ggvhtcg4tZXPPw5YBIiDxJ8uhrYU+JOPNsyTPBnuLXJa28yzt5qdAeS?=
 =?us-ascii?Q?x3HZ6KyFCL6x5/BZx23K1YcSMOu/o2l0Kn9ESAx8n7it9MaeWVHkaARp7BEI?=
 =?us-ascii?Q?he1jrTSqTqUMFGHlE77RuE9Qy7OGa8kmitTskOFbP2i52mTEVa7aP7DHJdMa?=
 =?us-ascii?Q?Fnb4edU9GuDRlbodMsYv0w4OyM/aa1kdQVPg9VzxtByWWo5ZLPutft/I1uBU?=
 =?us-ascii?Q?6Mst4fui/b/eXwNhhyAvqnGMVyyrVqWLc5mUoQHqPqiEqy7R0kVnt0uZnJyl?=
 =?us-ascii?Q?cu6Si7qpZ/wOWfWcOMzDAn+437SHQuCPjRenbXgx0giPN2i9LFxDRzioeBKR?=
 =?us-ascii?Q?6pjvlT59mu+O51YBqkaI4fUH4YTS7iV/UOZFemHgGZs1w38eYkoL7s4v0na4?=
 =?us-ascii?Q?JjZSnn1oKsQUA1CavW1YOLGfLPBC7f2/sOLOWg67L6EPm2q6YGOw3Bop3uqB?=
 =?us-ascii?Q?DCuPJamnw8u7yAn+oXPlQ52kBboF2SLmKMw2Ygq/4SRd9DuqaBYxz8esD8tZ?=
 =?us-ascii?Q?Tb+ZUzZBFbxfABB7dHnmOM1chEps1i9xxBVrNV85cH5RyTxxtfl1d6uTa9oo?=
 =?us-ascii?Q?+MsXbuBDwjf5SnyuepOLUL56UKS4A+gKVfN46q258mEzHaovSUf/9BjU+k2X?=
 =?us-ascii?Q?V9EuNt+qbt7GDfikTw3Zg3CCr3/fD4v6hWLmVa5WgL1oGTTwMeoCPGVaJ6/t?=
 =?us-ascii?Q?Rf70Z+ioHRbDofCV0yfyduWMTw+C6jvKOA2Wwp7MPCmLPjOmPOo0eDJigS9N?=
 =?us-ascii?Q?HAxG6k613w1K5/r+5X1tJBsxT4YKC6ewvxUkpBP3HY1KF4T3ahau5OVdDrC7?=
 =?us-ascii?Q?6djtRAkSX++VppLrwj3q2kLxhKU/yEUjfl2nBXROAXrBkDMQHf21QOOZ/WDa?=
 =?us-ascii?Q?HYm8viRxDLF5/GvQzuDfj2febX8JapJrlqDHQAPGt9kqIyHDJ4SWUH9P5IYm?=
 =?us-ascii?Q?Wfjq87AgQHbvDvrfJ9DskB7NG7DotTgi4MRac8fN2sviYH1K2AzmAntMFkGC?=
 =?us-ascii?Q?MsIYIzTM/Gi+tdvfIQK1SvZStgDp6UwAVTzLl4vnxmeNF0tDvGBHwrebMTQn?=
 =?us-ascii?Q?FfkW6YHlOfOcI6UTfJWDt9Y3D81FulzeiKzqcaCeXCBJ9w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+GpWjtUJnT5fWcQuK+aWGqmvjEmULXc1gDNo7ssSIy8QBkiu3TcGHixEqkYj?=
 =?us-ascii?Q?vHkr/O+no5BX4DLv2TTDzyeEHPwfC44WWcecIMwsbwCv7h0Sb/sqFi5a1zJZ?=
 =?us-ascii?Q?VAy4/Yyp/94mtp+mqUnqWlCXFO4oc3NRCdj9z78mLEgdwTn2kM1l8XPSi9D+?=
 =?us-ascii?Q?tXe2kUYPivOYaf1ItAnZwQIAE2nn2gJ2f/Ttk5k+Y2r+UZxVeCGKF5CcNgtT?=
 =?us-ascii?Q?ofMgKxY8njJ+10GL7mn3va+kP4W9LtyqYo9igWILG7b59rtDely5LECiGpiF?=
 =?us-ascii?Q?tfdxz7KtOC4JVaZiCMWhglMPCBWacJtIeftjkpeDmzrQ6UzDmlkSiYwqIK0Z?=
 =?us-ascii?Q?UszBd6Ql1zR8jPcfTnChCKB3f0Kfz2lRcP4ARAsnjMRxOIn4O7MOZutDEQZ/?=
 =?us-ascii?Q?djiM7rWZURRci7nrvHQ0yRbAEC2Iv0FeIa8nA9HN1s73NP+vy7YEPQt5FtRt?=
 =?us-ascii?Q?CbdhY8RLPIqD2OZA8n8dAXoC2JldjBRwrn+Td2zEVBk0APnbs2rgjvjv/dro?=
 =?us-ascii?Q?TORHM92DWnCdStNyqvza/Pi4NqmrSYxBgKY2Cqss4Otcs+IUDt1IxJ0ZXmds?=
 =?us-ascii?Q?Ht4FeqaTFLG3hymC7hNCS0Pz66xYGyb3HdY/6leTSXNzSgRc3Que1uEJmoGX?=
 =?us-ascii?Q?UC4JvbXI9THO/qK4+j+pyO+0F6PCmUkrcABSFVh+aa9umlMtHh3uLUbSck00?=
 =?us-ascii?Q?ZvufZgg+fEdYP0y1YKAk+IMuKmLHGkLzSKZsqJKmZRV/Qw92zLCLf361elUB?=
 =?us-ascii?Q?NR6HA5NvSWu/Rt6n2tn7NBrP+5cJ6BBzRqYX41FQy/61nwrv73LGLDfg/9yw?=
 =?us-ascii?Q?au3TkDVK9ZHvQxYSYoVssq6ASbthzKOKJi6b7BXclhqp1V7Uq3hMSYtfB4zj?=
 =?us-ascii?Q?jdIH82hyrgxR78jyYaZ4ljI7pONRQgT/tNVJQj356Suyxci6hHNBWcZ/rmc+?=
 =?us-ascii?Q?rA0TfqyqFxCrKQx66YvvRB9O6L1cLbYGYLP9KA4/pdvE2EfMRDvvjmn0Vscy?=
 =?us-ascii?Q?Y/gdleFOOa+NGlXYgq5PUfVB+nsz4UIzvYtCws0zOckZOTlbg9o0Ja0FPv3+?=
 =?us-ascii?Q?dXA8TyK1N7PcslZc7bL0WxXBOjxbrMc6PtkoitCVOG7dsiXBYWJtk7o77AhN?=
 =?us-ascii?Q?Ib5dWuVXkR1s1gmXY31TNOElUchEvpydtUU6maFpZrgxXejBXyXTAv/SSlOy?=
 =?us-ascii?Q?zRLJWA3AFC/JPxr4/ZZzOJmKagqpuLW3D+8HNT9q5N6IE1H52FXtkpYSvyW7?=
 =?us-ascii?Q?D7cQLV8kmEmAgTA7kSlgEx/EUY81KSr9UoZsR3hcpPvHByE88JYUcpQ1ekdj?=
 =?us-ascii?Q?y99tpmUgZ64UfNQDdETs86Nw3UAQf0xgFxh+0MuipHTSqZutDyHjdy2UYjIz?=
 =?us-ascii?Q?xO5bL1bpNI8UYSb03e3Thi+QmgC9qZ8oP4ZXpxBSpmRgBaB8te0US7orDgMf?=
 =?us-ascii?Q?atK+KmxYV5+dkaC088nrLZKMEPBJTEyACogo19jCVT1yGztjQ+NhqDNxZw+0?=
 =?us-ascii?Q?BasLUsBntoD5Y66wJfsD9HrygUAR+i6XPy3UwvdAicYvmdtbWqG70w8fo55I?=
 =?us-ascii?Q?Rz/1eHTQuvnS9U2efl5oWgpKKULr7SS43pRIC77aILO3hWQYmFLtjNcmcCSO?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3699ffd6-bbac-409b-1fd7-08dcc899aceb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 02:15:53.7485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WBG+le6nRDmuF5WRe/WjzGxqbiNrXnYaLrCwvBOTePNX6ztarlmsc4T8GtmVn6xmqpAkrnIdXnekW+PX/rnckkm58saiq+aUsESTzyJuMMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4897
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> Already public pci_doe() takes a protocol type argument.
> PCIe 6.0 defines three, define them in a header for use with pci_doe().
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  include/linux/pci-doe.h | 4 ++++
>  drivers/pci/doe.c       | 2 --
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/pci-doe.h b/include/linux/pci-doe.h
> index 0d3d7656c456..82e393ba5465 100644
> --- a/include/linux/pci-doe.h
> +++ b/include/linux/pci-doe.h
> @@ -13,6 +13,10 @@
>  #ifndef LINUX_PCI_DOE_H
>  #define LINUX_PCI_DOE_H
>  
> +#define PCI_DOE_PROTOCOL_DISCOVERY		0

Why does discovery need to be global?

> +#define PCI_DOE_PROTOCOL_CMA_SPDM		1
> +#define PCI_DOE_PROTOCOL_SECURED_CMA_SPDM	2

Would be useful to have a brief idea of the consumer of these new global
definitions in the changelog.

Also you said this is based on Lukas's patches which already define
PCI_DOE_FEATURE_CMA, so lets unify that.

