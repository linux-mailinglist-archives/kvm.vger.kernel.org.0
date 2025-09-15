Return-Path: <kvm+bounces-57510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB6AB5700A
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D427E7A9916
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 06:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC42277011;
	Mon, 15 Sep 2025 06:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MA5Vpfgk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4863A1DE3CA;
	Mon, 15 Sep 2025 06:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757916376; cv=fail; b=qFF5Y057CjPwGZqNX/nUaA1NAuQ9lKcVooWeGMQop97RNwrDa7/dyHd1uOiuauRJVeqjd+fgyt+SfL2R1d3ON+x6BqLuBFG69yI0B2gejF31jlW6yfLKwGcmiMwOH8oDy6kx4pFM3xDzuuvfR43el8YzsH+v+m6sgDOCuNMLnQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757916376; c=relaxed/simple;
	bh=LvMI3XgH1a80PEo/wfl2NbjEoxEfeAJyT+KkJhACMxk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mW7wW0w5YJjZ45Y+m5cHY1kqyAFRaWRZ/HdaYOny8z9XkK7rTEYDGPJKISyFZ/7aNO85tTGeGzjB+jj5fxMTY++632McXojQrFSxNqXzAZtfh8WPTA4V15WTyvyJDG0c1diPlZBMEcZlzlnuGKgtmNAO8yPp+YjMFce4BvHhGIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MA5Vpfgk; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757916375; x=1789452375;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=LvMI3XgH1a80PEo/wfl2NbjEoxEfeAJyT+KkJhACMxk=;
  b=MA5VpfgkG/Ya3RZ42EaT/t4MDKyaqnS8i/FHoGn9TjyGTQ7naqKK+r9B
   aWF2Wh+QpN9AbkA+8grv8ITqgXE5QqsplTHQv0bYAEy9uM5RJNssOCk9M
   8nSqv8eQG46mBZZUi/WvFxI22JxbmBBAVqQzSDBLZ/2gsemMUJHmEv3Mi
   cm2koi67OKMX0YXxwcJdzOqQIJAgtlrK/hUDLQIEi0IJnBlfRm3k19JCS
   GNghbFOBjtspQoAS/kjHm+CZCvzSI3JYFho1OcXOijK0BZ71O/Gocupy3
   6mIDl203NuOaHuieDY7tYXn3W4CfSUFvys1u4OYvgyT4IKI8oKfBNJP6A
   g==;
X-CSE-ConnectionGUID: ef0Mud3eSyuyHLVnkqMcyA==
X-CSE-MsgGUID: MInpwEvtT0G1pn9YPeBsrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11553"; a="59202592"
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="59202592"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 23:06:14 -0700
X-CSE-ConnectionGUID: dv/HbiE0QmKfxs8Vb7oJ+g==
X-CSE-MsgGUID: Z9bclMO8Tt+zWFzwxqkHlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="174074289"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 23:06:15 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 14 Sep 2025 23:06:13 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 14 Sep 2025 23:06:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.64)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 14 Sep 2025 23:06:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moUZodsFmdeziJzNRrRpyJpKyjX9aEYvr0AxlbdyOJBPYScTtzZvU53h/iVcJ8V+E9MMgh1OCEM73l/+41i6cvNwI0ZJOmjMtaul/I+AIKym4WPdKQaVAPZF+gTctWogV/YYZEZL51MA6BuWlE0YkbF8rtjwYD5+NoCK8LaiOUfxS/cn3/D2fUXhvqlIC6A9t9a2NGRxZFpI6u+RzUvqT4AtQ5mzvKqoGX1Lzgad0J1QyIXKNyf7zx6kZ7nGFQIcA7JZnxuIeevxoXKbQGMOt8DOOt4WBtWbcMc6vQ8sslR5mWC95qCGg/1joTAFgKVDd3fBW9b3yIPhUO1FrH4vmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIi04tZQhFY2/U15D7PF+saeqMCI+/30GjI3X/1wB6A=;
 b=wXEFG4n+V/Jm6+wdSpmwkn9MH64GoaY7Ht3n9o7VKCLMUTxS/7a8+Zi3Oh6G8mCwJY7qkOSSIYPyOoNCWTzlcfgdPlybRcr2UnRP/h9LwwohiMHpyFJtX5BywdNkSaz2Y3WQ0lcrQ2eR97Cmvo6y2C9zPvDsIrt69OSe6Ww96z4k7oDw3M1W0XmXeeES+wFYReJWQaSV2mCDrDkS2nbPL1Cl0R9AMsrJCJZsIbYtZJ9uaGxY7MEyYGr1ssM6yA9zKJakSr1dKYRbBIS7wUCIbB5k2N/GbxXwOSRxp1LII/R3AiuKe2qY1oyfkC3QoMmAbV1ooC0M1H+n4oS7lXnfJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA3PR11MB9013.namprd11.prod.outlook.com (2603:10b6:208:57c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.19; Mon, 15 Sep 2025 06:06:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 06:06:08 +0000
Date: Mon, 15 Sep 2025 14:05:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v2 18/23] x86/virt/tdx: Do not perform cache flushes
 unless CLFLUSH_BEFORE_ALLOC is set
Message-ID: <aMeskOdstg01cvMP@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094516.4705-1-yan.y.zhao@intel.com>
 <b247407ec52d96a7fdec656c5e690297d4facde6.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b247407ec52d96a7fdec656c5e690297d4facde6.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:195::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA3PR11MB9013:EE_
X-MS-Office365-Filtering-Correlation-Id: 53cef804-14ae-4d9c-099d-08ddf41df68c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sCtgvJG2QwoFCj9mfKpjjq09k7auCJBe1e/2irCq++4EBTJ5kYsd7YuB7J3Z?=
 =?us-ascii?Q?kKgaTaMg61+e8g8ncbj7fyTN4/YiuyY89krhU0CbxKthQ5kxKFtgtjHOPVyx?=
 =?us-ascii?Q?GwAq+WVk4pAeeozlzZHtcieMNhdj8mMVACvoiqGxN2jGDe35OzamGIl4m5Av?=
 =?us-ascii?Q?g8nTW3FNgSUxrCojqJ8ujvZN0mop1Rx2ElBCVc5kwldSqXcyB/z7kAauzJkl?=
 =?us-ascii?Q?vLOAIGraimQOaFuERQk2gQPh790opwN0oy9zisMuXMu57ndTeMBLyBclD5Wf?=
 =?us-ascii?Q?EfsbsN26oLaabLpDED/ljx+vyzc6WUoc8LEiBPq1sjtyn6VqQPpX8KczRJOE?=
 =?us-ascii?Q?Lw71ZHgXpmjKpZglymoYx04pPbY7yRuoclTbxYFsK+yaUDPda5uYx6N3G81A?=
 =?us-ascii?Q?U89dN4zEJXddB6t3sAm00x7WfnIxeQPtv9lJX9+GrpCmmqzhxpzyfDN1Kyy1?=
 =?us-ascii?Q?vUAiBhEyraHjnknidgOK+HTId1hbGx9ES0hu3l/pLTdnj6NSklE2Mvn7J67W?=
 =?us-ascii?Q?WEIXj+UsPe6qm5hr+fYZdWkcg5CTfc2I5nNI5pmBpw1fT9nUFbqUnyw8gGUp?=
 =?us-ascii?Q?3qA5V79kqdDa87OpePWVBwc5XcJqJkuJLaoH8HdwV6ZM8brZ5rtPdlc0NAh3?=
 =?us-ascii?Q?gMufma9Vo9iQSWYP1gK/lN+Dhibpq4J7Q0hD9Ov+o9AQFTtsg+rN0tDnt9D5?=
 =?us-ascii?Q?z2KUHvEZj0n2n9feAfuXKjbZNQj10sZWKtQ37Gnr8efcru2pZ7rKncT+GZxL?=
 =?us-ascii?Q?5iYkwfN5ry37uxUhE4uhvCsdqWtcmpT6GiwWbpeb53JFmgoLDvvycdmPoFHA?=
 =?us-ascii?Q?1TgKdxn/xnsDmaPYdjYMWH2rM9bQC4zTuThsZUZhSvRnckqB7vQLLB3+LMRw?=
 =?us-ascii?Q?ELPpV19tY0jPKoMfbsQDo5dDK+rqIqCv7FuqvlK3zyPCebYAXIOaCViZnEHS?=
 =?us-ascii?Q?lZx+H2wyrybjrzKPYCAnaj0NBsfLXATkKL5FU0tGnJTetPzqY7xr7rO6C4dA?=
 =?us-ascii?Q?1uEEuvUnhAdbarQApeHthyayBCSEihQG18Wr0cSNDaXgvQK60YJTVlsNaByH?=
 =?us-ascii?Q?8vSBPUkRQXoOBbKdO1PxPKZ3rT5CiGAMX6HoHKckDnP6xNavZ7V0cc0NnRKF?=
 =?us-ascii?Q?0lGH3IgMHFxDFDz/ssfh4I8AEK3lg/pZAyzczPN+apBqi+ptq+vntBs/QLwL?=
 =?us-ascii?Q?MvHbp7QszUHIb416AMkoKyYjNVRtmR13AOXOzsdfVpsecEYkp6edbvLoqXMv?=
 =?us-ascii?Q?CgokyYPMD5K3nIg2Ied1A6ROvUiA7zIe77Syrtfq9cJwY5yPOrHPOz/BfBHO?=
 =?us-ascii?Q?+XYgEj5F/jFKnQFl5j2+Agsemfkmu7HkeIqE7Qosk+kogRWR7uZi2OszQ7q3?=
 =?us-ascii?Q?+/jShuwJfBqjPmZ1uD21w0rPPZ9uHD4qCZQK5rZ6G0L/8sQtkVfZTpn+z4pv?=
 =?us-ascii?Q?jtRxgiaNLu0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MYBuwWiTfTUy4vsavMO1RQ2rLCLfqCm2SmFe3rcSLI0SOfdEx9rhuYaQaNXM?=
 =?us-ascii?Q?7PHN7v8SYT6Kr7QINBciT6dAQS2f0sPj7ykqIHj7Xi3Hjb//u7qoj6p2sXYl?=
 =?us-ascii?Q?H1PZUUBKApFDcbuVFpR3TocJBmdlwPnn04FbIGScH0JH8BS5Y8wwGAwNVE4j?=
 =?us-ascii?Q?7yT3yFa+fY2wlSuxJ3a/IDT6LgB+TBK8LGvlXBEdSt8cbvlcHmQAHXyrcZaY?=
 =?us-ascii?Q?h/lk+L7pPD3qgmgMYFfAF75/uJ/M9HJB/viDnXpgyS3yqgFOsV3EmV76EoH9?=
 =?us-ascii?Q?UjmuGryI3gSzZiPykNeLdOtyNfL88grjawj9mLiCF4LtouztxfsXUOZDHMiK?=
 =?us-ascii?Q?L1aJYdMiGDGwquDvhYc8BonwRi7KKWIKOgY/9THP5SdnmXSFFCb+ukm8zkGo?=
 =?us-ascii?Q?cXv9/ypw4pfpAIGx/+MyU1zgpP/7V2QzJdXup3Y7EoaTlKi8rLFer+QaiDWM?=
 =?us-ascii?Q?N4qg8sGe0XRNFynZ2YhwYy34Ngsfluoay7R6A3Dtg4C2lcRhWQLmG/GR6hri?=
 =?us-ascii?Q?g0gCFhURU1A7AnYYl0gGjc7cYLSF4hDHVNR2yNZ156EgAZb1JHAm/++Q249Y?=
 =?us-ascii?Q?bqd6ocj/oGtG/grHK/hAQU9Yr+GCUEqhCOW/cAMPINLEK+pX/DQj2zXkFKeH?=
 =?us-ascii?Q?XpUqTkOm9Qi9ocjMXf6ffwy5UnaE36bsZYfbXOb0o+esUB6G5FGWBI0vN/ec?=
 =?us-ascii?Q?L9sWvWavW5K4DOMh/yU72540jHIcpnrJnMfSQHg2M2DSR9wIhGS5EfpK9xv/?=
 =?us-ascii?Q?mB+Sr6/Mq+9TMAoWSrhYLoJ1P2pC9RDie+cYb+Uai9GsT8357gfLJNYHzeGk?=
 =?us-ascii?Q?dcV3puezqOiEo49wmGQcmWlumLlYiPz+HmXWdUWzUux04+ie++v+PEyi8eVx?=
 =?us-ascii?Q?mBWFkGt3xUClxMnysIyxzgYLFjAeoSjWkqXICyjAbx0NBB5cyUFMp+/9qJtV?=
 =?us-ascii?Q?GNN68kF8UzH3zXBWlU/RisnibAn0GiD24f1WGU9VmGTRMzsrAoRYFTb8SBpm?=
 =?us-ascii?Q?eA0TkAApWxk7KP2FbPCUOHkFJjcDeNsVDgCx/laQZYi3UrDPdhouts0bIp11?=
 =?us-ascii?Q?OSliFr9L6FEG55CWx32AI2r+fMcY2s8JsHzHQnRjbtq6C948tfW1Bp40HoBx?=
 =?us-ascii?Q?D+u/CdGXhIkwYqWcfgXZt3xUs/qtXv61jxYgEmlrh3KLYEG71Vb2gqZkXJqh?=
 =?us-ascii?Q?6AxI/IfpsM9KFaHAqEkhPFb2+NkNNM9U6v99u0tD+e1C9Hn+toIS5x3/Cehk?=
 =?us-ascii?Q?l9kKvJDFXOMXFzc3+y6b7bawZst/NEDjTgnZorwrJSbPXsUCYeOOKB8H6pWS?=
 =?us-ascii?Q?CCcg/t3nGoZ7liH5lCigOYSu4BQmNYgzYKMmaoHdxiwV1Vddq4nxoE/K3djZ?=
 =?us-ascii?Q?UZsN0HdwHpxCz6nucN35GG7BdLE42120VUCs3Aewqnb62uK8RkSEQ1x0dfus?=
 =?us-ascii?Q?zFwYTpgFHXOkJ2UCzHVmzHBR8Y/NXvg1tYKY7LDC872s28v9GZAlAkjUdN2v?=
 =?us-ascii?Q?hjdK5q0OKgSF3G0LQykd66Z/3jg2Ihs698/LgyaUuvitguUR737qY66Ww7RQ?=
 =?us-ascii?Q?yn+9hyuwI561R/RNXS8FXSjbHqzQPZWZG7N8skyO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53cef804-14ae-4d9c-099d-08ddf41df68c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 06:06:08.5972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMGmaPiuBP5RTrYbS1gA9IW48DQHFsVaGorlJe4i0KnOVr/EzayW5l3rI+KenKb2NFgleIPdKf8bv5PH0nRuEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9013
X-OriginatorOrg: intel.com

On Fri, Sep 05, 2025 at 11:41:41PM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-08-07 at 17:45 +0800, Yan Zhao wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > 
> > The TDX module enumerates with a TDX_FEATURES0 bit if an explicit cache
> > flush is necessary when switching KeyID for a page, like before
> > handing the page over to a TD.
> > 
> > Currently, none of the TDX-capable platforms have this bit enabled.
> > 
> > Moreover, cache flushing with TDH.PHYMEM.PAGE.WBINVD fails if
> > Dynamic PAMT is active and the target page is not 4k. The SEAMCALL only
> > supports 4k pages and will fail if there is no PAMT_4K for the HPA.
Back to when Kirill was enabling DPAMT for huge pages, TDH.PHYMEM.PAGE.WBINVD
did fail in this scenario.
However, this has been fixed in TDX_1.5.20, which is why I didn't encounter
this issue when posting this series.

> > Avoid performing these cache flushes unless the CLFLUSH_BEFORE_ALLOC bit
> > of TDX_FEATURES0 is set.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> 
> I think I mentioned this on some version of this patch already, but during the
> base series we decided to assume CLFLUSH_BEFORE_ALLOC was always set for
> simplicity. Let's try to be consistent.
Right, though CLFLUSH_BEFORE_ALLOC is always false in all current TDX modules,
linux conservatively assumes it's always true.

> Why prepare for some future TDX module that sets CLFLUSH_BEFORE_ALLOC *and* adds
> new support for at larger page sizes TDH.PHYMEM.PAGE.WBINVD? It almost seems
> like this is working around a bug.
As the TDX module bug is gone, let's drop this patch to be consistent with the
policy of assuming CLFLUSH_BEFORE_ALLOC is always true.

