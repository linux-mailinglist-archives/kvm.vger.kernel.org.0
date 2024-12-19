Return-Path: <kvm+bounces-34112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25B9B9F7367
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 04:39:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51E92168D6F
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9757315530F;
	Thu, 19 Dec 2024 03:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CwZ06Oss"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7894113B58C;
	Thu, 19 Dec 2024 03:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734579531; cv=fail; b=RG0ytwjz0889LivqKsfnVFmOS77C2UJkADmdHwqO+VGIfjnaUSJM74SG2RyarkAvnkm+LYEjXyvLVSt5CaU54kaip+9zwd9l13tZzNbj2s5e4Y9PrIsnpYAmxxyvKA/5vqkrzLx19QIiPmydURXJF3iF/8euxqpx2frWaMRQ6m4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734579531; c=relaxed/simple;
	bh=L/2nUxBe4yXR2ISkHI8QIc6BEbcv0iHMsm8YvcX4MVI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GDPKkOwVnSrWxhiMQ/4jzgKtHldiuWP/X4qIpggCIfIgFzRKm1rtFxa6XH51kUOo+jDAa+BVtG37kAVLo4ZgdT3XfjDKMCQrsxUnnTISzxNrBjuhe9khYOWghrx/oUi61eOTAk83SrMVctA/6uhBdkX/6CEnSauIPv/jbFaLg5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CwZ06Oss; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734579527; x=1766115527;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=L/2nUxBe4yXR2ISkHI8QIc6BEbcv0iHMsm8YvcX4MVI=;
  b=CwZ06OssZwSI3eRk44z0ZAvkEFYBpQnQjQYnTPSRTux+EHgmle9NBzIh
   AQRksAI1bL7SjnsKcpTX/rjurWOaBmeHcqWNo8ilLsHrM5/55cxOLYEVX
   zZU0xxjl/rToyPX8VcBsNaoIXu3knNbLLw21yg03l6EtQLnLCiz4c35C4
   fKoyapGKF+1VVKnBsQ/KRNUwJJmS8nRARaMptTDDzZC9kb798Mz6R3FSi
   hgMjAEdb3qb/1K/62yGFXda5BzkNJszAWPPv5nhRETbLPwkIn2aGjGV2D
   owweCG6cpSQehCb1MhCjBUpunRYHrxwFxUif427/Y9jObsp7xtTkBoK5t
   w==;
X-CSE-ConnectionGUID: tycnqGjaTwabxzp6yxYi6w==
X-CSE-MsgGUID: g/4cFmqCRviLk++fhGDD2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="46465929"
X-IronPort-AV: E=Sophos;i="6.12,246,1728975600"; 
   d="scan'208";a="46465929"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2024 19:38:46 -0800
X-CSE-ConnectionGUID: xKkaunDRRIe6FKaRTLxdNQ==
X-CSE-MsgGUID: uozzpqzwRzyUd4M/ZGoaYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="98547601"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Dec 2024 19:38:46 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 18 Dec 2024 19:38:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 18 Dec 2024 19:38:45 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 18 Dec 2024 19:38:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jSWCmGhzEYh3T+6eiAGgfGCWoLvGlvlKVP3NxddCSBvYxrVm6cqBC9wIA0dEkbXDfISPNTyPMM3w0MpFXwlUruz04FLElue+NZYwtnusBaZsrhr90kWeQmMUoRZf131ZVrteEXcDMDbijY8c7tHMBgg5aUQ5QFIwCLXE6waQUtVOkOk3ee3FPyUXZb8MOmJqTMrNB1EvXbkN8AqpKDQ1wKTMcwthCqYkY2g3tnnhSz8dNQ7ylAwV2wqfw6j/zdbnLOAdnGYBMDeNVLvv04wqmG6klICKBhcaKsbi7sLYf8KGNz65R/P0FRKslWNcMXYLqfQXTlhACFCsZke5jKpInw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ZH6AQfup3dKQTeZIezoLWFgKuxN5SQatG1u2Iha7e0=;
 b=EF5wLw4zEe9GzcmBJJNN0dL7PwKe+Xe8T7aHN46hNWbyfJbMkEJnQ1KoR+uoqJu2Tw6hiI3cFGWVfpbkw8JsVigEqLJ1lNj8cEvWgSBDfB6ztpKZBmtW5Bsxu9YKyBDfFDmnM+9eroXQWBAeXAsUmfFZn8eVLssA+WbAF21bEdSPbgvXQY25bgSe/jgEvGi0mkTzOsQR1UJKzQTDHXuCebZs+dIkw7olmfQgGlPZSrFMXTewhNB87ciNdBnMlc4ZsXsaSNci+JPP5hY3D8ixzOKAnbfv3dkElEwXqEskRDKZgY8NKrJ5WdtvyEMSQy1kgq/MIda8ORpWurPI0jE6+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7004.namprd11.prod.outlook.com (2603:10b6:510:20b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8272.12; Thu, 19 Dec 2024 03:38:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8272.005; Thu, 19 Dec 2024
 03:38:15 +0000
Date: Thu, 19 Dec 2024 11:03:52 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>,
	<isaku.yamahata@gmail.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [RFC PATCH 2/2] KVM: TDX: Kick off vCPUs when SEAMCALL is busy
 during TD page removal
Message-ID: <Z2ONGJ/Q1IEWkL8T@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241121115139.26338-1-yan.y.zhao@intel.com>
 <20241121115703.26381-1-yan.y.zhao@intel.com>
 <Z2IJP-T8NVsanjNd@google.com>
 <Z2JhXfA14UjC1/fs@yzhao56-desk.sh.intel.com>
 <Z2L0CPLKg9dh6imZ@google.com>
 <Z2N8bl6ofE2ocQsW@yzhao56-desk.sh.intel.com>
 <Z2OHYWZeHeKMHfDy@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z2OHYWZeHeKMHfDy@google.com>
X-ClientProxiedBy: SG2P153CA0053.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::22)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7004:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ace2a69-9940-43db-97ce-08dd1fde9213
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SBkcT44SErtG8L+6FNpVDRKZ9hJdcBIXVjanXMPQEb0fOMtYMiKjpeMCrG3j?=
 =?us-ascii?Q?7AvfDjyVXlASvpi8Dbm3X1JaLmf25mws3m6aagL9zh8GK75P1l26MCDevqPO?=
 =?us-ascii?Q?JH9RWSMFsZYrHIuHn1Hc+hS3WVOfll4Rz6OTCZW4I06zaaMiOEbz/F4iB/Ch?=
 =?us-ascii?Q?mxc34le5F/WGDhjqreW8OzdeH3+kI4UQSS/XPTzIwy3mA1yRXBOI8J0MyZ0w?=
 =?us-ascii?Q?botssUlN54izhmKXj7xy0RybJjGb+bOj5ZWPyQf8biBynB9naheiqGnb8YCh?=
 =?us-ascii?Q?BUHWGlhlihPgxPb0aTp4jshs3CpbG0XveO3qZS1bfOuoG/rpNpcMKBaQcoka?=
 =?us-ascii?Q?xjNehSrK7zUAtZ9brg2zPhQd86Gwui5ZPtXwMyz+tdWpCBKMMSPccJ8VOQbn?=
 =?us-ascii?Q?caivK1oHJ1/QQD+ANzHJ/1Akq9J6SuxRgY/zfPIqlqmts/NgQ5+kcHhpcayf?=
 =?us-ascii?Q?R6FfibDCDvzx1eq710AiTFI/vJihKV5F6JrumCDguUajjowqNF8HpscfEYCg?=
 =?us-ascii?Q?6XfeXaFwcNfb7z3DArXxkSB6/URXK5SuIkHx2YPNspU3I8DjG7u7UPl7FKkO?=
 =?us-ascii?Q?oTHASCY4NYtChMr48Zkgf68YbIvacioIzYOHP3W+j9y4JJCZw5ZL+xLfFYqz?=
 =?us-ascii?Q?PjzspJTj3XDGoJe01H1+CpWHcBCb7r5gwTlTIj5PC0gTw205ENGxrwu0ducv?=
 =?us-ascii?Q?kClG1dYteYOwVT4XvLTRipAO8QHWvSEkVSUY/NVXgRqt/S4KirJa1XOliENl?=
 =?us-ascii?Q?NAA7PNt4ZWTlH8mTw7i3FZZQAZuJzcLaMTm4UzlbfSpW+Qg4hYaU/ssaBNBC?=
 =?us-ascii?Q?6X4O7XY8VPGmhbAZ4qxdF918Ja24RWCUnl4zJ7GyfNzBS50kDwX8fXYCzIDJ?=
 =?us-ascii?Q?+2Mmid7CPZ7eb2Rg65HWJ+JU2bW0NgrXrcZwho5kCqQg0Gj4nMS4VA4aP0ag?=
 =?us-ascii?Q?LbK8nq+AXQQ3R+o7j0/BZV5CEXQbWHXpANLf1jBL33ULZsM3mJklZuYTA72I?=
 =?us-ascii?Q?+B+b923pwqKLcasJCk8Ac4eiSwH+f7+sv2cjBDp24O7mwex2iRKICucBXELc?=
 =?us-ascii?Q?sJKiDgiptcyEFuos94/DQWWMx2dSek6dzSEbfbQXob302pX43dmHt6crz+2C?=
 =?us-ascii?Q?SwpjNaERh/aL53wsKzT5fxOMkTQ3fRMRfKV9/ihHR5OU9J0Sga/6UeDkalLl?=
 =?us-ascii?Q?xo32fZ+abWkuVlGNLV7byb9hdzvc+22klihjkuu+rBPQCTsjxXmnFCAdzr4K?=
 =?us-ascii?Q?jSfV/AdEFt/qNk1mnV0PVeMUuPYkRPDkLMOjHRZM8vLOQFjVE4vOs5F59E8/?=
 =?us-ascii?Q?Hyyt0ys8y8KQJHbD+bPSHrnhZ/GMmjP39TRy/dd5iwUbv7pw239fsB2EW3sb?=
 =?us-ascii?Q?TCGeydWCqyuOdxJiXFDVy7KEW1bq?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QI576xF3iDEb96JYa4tkavBcWUlI7MwHI+eAkRItSd2G5sS19u5RXqi44SPy?=
 =?us-ascii?Q?yq1iNymLGequtvE4Xw809AA9Y1Qs+NFqMj1zAVYxc3CEVcOsbZLK78h6Gnmq?=
 =?us-ascii?Q?Jb2JwhtCrdZB0D4xeYZjbAa9HHMf9vXedClekKogxkbpxe183uGvRGU5cuUJ?=
 =?us-ascii?Q?0DYhRlDSLEorv+Gv7aq6fdE3XHtHkTXM8XLeuDukrIqIpVLN1+8ixcS2Al61?=
 =?us-ascii?Q?pDWm+d4xjhgBrHH8hqmZa+6AIzqZPIuhfEx29CivX+8P5EBR08tfiy1kT0mD?=
 =?us-ascii?Q?Hhq8gJaBhUU6OYsMBudymW/V6+y8BQTCXnRoUip1swTF6s6YQSj5I6XnXSQ6?=
 =?us-ascii?Q?oJ0IOHL8cuhAQqYx+FCw8cifNMpyAAuEBVgqsfLte6GkFrKmSPipzEr07LcX?=
 =?us-ascii?Q?kM6kq1LZz2XgR3LVn5xcYrZG+ecf812C/nodhlkmYGd2KtKKc5BfeGRjAhfw?=
 =?us-ascii?Q?hvJWwDeAg9hzKPZp3F3mz0cWJu10XylwF1nhYN3bvf9x0nSFUmhqybYNX9aO?=
 =?us-ascii?Q?O8hYKXzCZ4PC1XbQGJHWew5PgZNepVv6GvqlBWc6/Cp5IR78H5yLJ/Hy4g8G?=
 =?us-ascii?Q?FyQ8UnYh/AjOFQDgyCeoawJRsKA0UHUFbU3jlx7aaQv4ZfEOZB8pNjYiQRCH?=
 =?us-ascii?Q?krtK12/4eUU9JmELkDfchgQqYDFGo0ppzMZC0p9pEsPqkFXGH7wOfsZotjQo?=
 =?us-ascii?Q?Rsx4rdpKVpi9zVn/KqFKHvzLBp7D+ysyh94TRzC+ngJfvVi5K4AExVlL9mfz?=
 =?us-ascii?Q?RhJiE60EFQSoXKz5K7HeJYAReDoHnFBrLHX8+klHxRpYZ/9KBFVM7QZTv0h5?=
 =?us-ascii?Q?z3kcPs4JvInCXGyuGFdpTVexGbecHqrwgQe5YELvZ4ZOZY6tAeM5y8PH5vtM?=
 =?us-ascii?Q?N2MNKO2IjztcqWq8t6EOJVQCKHhoLCisKbYtDELvIzMScLjY6fxm8s+XaEhT?=
 =?us-ascii?Q?VcgvzHb77U23GxcwPGldZvpJVcQLp4Thbs/dj5PB9TpdMRyV/dYh/mqJnai4?=
 =?us-ascii?Q?4wRa0eDBt9LOtcEBFwJb6ncLEZGJHGB4jPv1qlyrBePg/WqbNpAoViyWauIK?=
 =?us-ascii?Q?qsTa843lNM1EvY70JdIdM4Gs7/m/H2cNHxZqgV4fKNqrkatFPKhBiWHZ8HVl?=
 =?us-ascii?Q?s6PWwub4N4PFmr0Y85lcGRJxpQrDPXUIrS9pFPQl0swJCN6XHWojyVpezfY6?=
 =?us-ascii?Q?de7NRKFAUDUOrRiIKQhbVOXB5hOOkzSztxXq5ehHY3pKN7Whpmdq9c6mosBo?=
 =?us-ascii?Q?JnSukpPzSdqdwDqUS9SPQhlX7WfkE1cJhRXZ670cD34R6wStbhwh3ArengKo?=
 =?us-ascii?Q?zI/p4gjvnQlnlyQ+RVHv4waSJM5meKeawk0RLxV6vPJCnxjQX2CgYv6JfFiy?=
 =?us-ascii?Q?l4zMjcNymDIBXbrep1KmU9QmfPHJADYZmDCTlkthEzjj+hsc0wPkxZ4DBz5O?=
 =?us-ascii?Q?OaqgXPccZWS3uaTlLm+XdlD+PgoVHtspkyyJeZ+yGFQKtxVg/DbPMafUt4in?=
 =?us-ascii?Q?zECpH9oB/L95aH2LjtroVdl2cMgCkoO7nFEg0eXtIlBhIOlfh9mIog4Bgse3?=
 =?us-ascii?Q?dpusNnlyB/lBVf+RVsa27cZOeiWtF2fVF4FoXNCN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ace2a69-9940-43db-97ce-08dd1fde9213
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2024 03:38:15.2015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kRUNW8GRYuGk2PZ4H/4MGtoBgB3csKDg8CFD/l+QK2OOR7hv6czcz2uBIMb4eU3HLdb+jxcL8nqBYCJIPbFY9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7004
X-OriginatorOrg: intel.com

On Wed, Dec 18, 2024 at 06:39:29PM -0800, Sean Christopherson wrote:
> On Thu, Dec 19, 2024, Yan Zhao wrote:
> > On Wed, Dec 18, 2024 at 08:10:48AM -0800, Sean Christopherson wrote:
> > > On Wed, Dec 18, 2024, Yan Zhao wrote:
> > > > > Anyways, I don't see any reason to make this an arch specific request.
> > > > After making it non-arch specific, probably we need an atomic counter for the
> > > > start/stop requests in the common helpers. So I just made it TDX-specific to
> > > > keep it simple in the RFC.
> > > 
> > > Oh, right.  I didn't consider the complications with multiple users.  Hrm.
> > > 
> > > Actually, this doesn't need to be a request.  KVM_REQ_OUTSIDE_GUEST_MODE will
> > > forces vCPUs to exit, at which point tdx_vcpu_run() can return immediately with
> > > EXIT_FASTPATH_EXIT_HANDLED, which is all that kvm_vcpu_exit_request() does.  E.g.
> > > have the zap side set wait_for_sept_zap before blasting the request to all vCPU,
> > Hmm, the wait_for_sept_zap also needs to be set and unset in all vCPUs except
> > the current one.
> 
> Why can't it be a VM-wide flag?  The current vCPU isn't going to do VP.ENTER, is
> it?  If it is, I've definitely missed something :-)
Ah, right. You are not missing anything. I just forgot it can be a VM-wide flag....
Sorry.

> 
> > >         /* TDX exit handle takes care of this error case. */
> > >         if (unlikely(tdx->state != VCPU_TD_STATE_INITIALIZED)) {
> > >                 tdx->vp_enter_ret = TDX_SW_ERROR;
> > > @@ -921,6 +924,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> > >                 return EXIT_FASTPATH_NONE;
> > >         }
> > >  
> > > +       if (unlikely(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap))
> > > +               return EXIT_FASTPATH_EXIT_HANDLED;
> > > +
> > >         trace_kvm_entry(vcpu, force_immediate_exit);
> > >  
> > >         if (pi_test_on(&tdx->pi_desc)) {
> > Thanks for this suggestion.
> > But what's the advantage of this checking wait_for_sept_zap approach?
> > Is it to avoid introducing an arch specific request?
> 
> Yes, and unless I've missed something, "releasing" vCPUs can be done by clearing
> a single variable.
Right. Will do in this way in the next version.


