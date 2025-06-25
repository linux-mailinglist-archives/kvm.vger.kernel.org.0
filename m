Return-Path: <kvm+bounces-50643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C7CAE7DB7
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 11:45:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 206957ABC68
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848F82C2ACE;
	Wed, 25 Jun 2025 09:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="noRnaoNl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B058E28850D;
	Wed, 25 Jun 2025 09:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750844367; cv=fail; b=tQ9pjsQJVQAqwby6ebilUaZBfQPj1lHJ9Q9+/vwQ/lcOK9pMi4AJHA9buCcvCtL0wV3+Cu8xCP0dIHmVw1GjN/BZDQGqhOrqFRXq8rEDGXsNMTSJzZKmTVITJO5gWkZorABktboj9n7j/CD5/id09j46oYZ6EsMatKEdWGMbbyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750844367; c=relaxed/simple;
	bh=suPnbE4o6GSt8ZmhKUJZa7ocxxuHo4tneQid1Ndbvic=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nbdmbiKsR4HFB794ZU346lgrvEFQneUod6ea+9j5G0cnoSOWZd6slkMvzMIr4iH7pP84+s9TcHf04Tf+1iLNM3Xv7cO37329MWNM2lfu3DU6jMcu42as8P9SKbL8ZVoM98IoffHZpI7IO34ls8YcVQz+gXSRpIm17vMTaIc+LMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=noRnaoNl; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750844366; x=1782380366;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=suPnbE4o6GSt8ZmhKUJZa7ocxxuHo4tneQid1Ndbvic=;
  b=noRnaoNlYdrozvyTxtAlKKZZNYo7Itm52i00VxVNWLDUAL5vep27jH+r
   12q7dFpiI5f5+gWWoeeg7M4k0TqyZ9JrCzYVSiFccNGWKjBWLfUyYTaBj
   /MHsO1JYW4nhEBdoDyZvkKcNgkFDTKAAEEvpFYP0lFcKGgz0Fqr63EKEa
   ZoyHKpmcMkTEhZGkX76jp8QQgukhXwO0QEu+LzqcihJFwymf7e0ApZ5gQ
   y97rGP0UlHshLQThqNOLGFjO88H9I9JhpcTx+GqtAQaYYs3a/T1QFx1+x
   C+Eq20b3VYlFhREx+WYXWg8t1yxfYrAzBRe06QRocmfNOlcVoFDiBwRUo
   A==;
X-CSE-ConnectionGUID: XG0afBvXT2KQX6pwGDjEzg==
X-CSE-MsgGUID: 6sUqsIO9RmiXDcaa0aopBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="52222202"
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="52222202"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 02:39:25 -0700
X-CSE-ConnectionGUID: sfnYTzDiRJyG6dsr2FuWnw==
X-CSE-MsgGUID: mectynxgTeOCGD+GsQ/2Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="152870068"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 02:39:24 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 02:39:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 02:39:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.83)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 02:39:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HdMUY7H9xb81/XW15VSjpkwknCKVrRlHlFo6tD+tmz9YZsDmZHTkAvxIhuZZ+ZsPlth5MyydJWkLx3CBj4lPV1P5hc4eN4RgFaAmZV3Cy9iDywdmK3h0dROhMkpPxV+LcYi+XBp+kIwTG6MO5xtz6lNsgGzXEn8i0qhWqH6AmO5YvytINykEfsw6w5H9AYfhfDOFgRYMqNEouRLXCllJfB9XPxCJwnIsnv8hSiRCBM/udgvUvTAmyQmyvfx1htZjKy0+9TfIVOENHCPJFVe5H+IoOETF/HhqqE0X7X6dvZYXITQyU/MB/SRI6CxtSKqL0vpZkS3lNS/H5X1n2PPgHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KDurKuph1hlkz8ea4TxjinjxgBVnTYFMVuaK4n1Hbho=;
 b=pRt4UoMNxPxXIAaVUZ5mdOxEDOvOekzsUNvn1NA/qM8J/QrHBlmtrctFMaCZ2tVtsUh8UvOBbcTw67CEcQR6SBvdKZZMK0ALNsn5JgE0On+Z/Y9zg6GyZMVriwh+sS9kOh1g41R4zvtqpz5t1b9pTZ9fj4npTFmcSGllSQ/41993wKUNP969SdGnsceFYhiyxtkB41smmwJ7xHMikffTpYJzQ1uWgAAfTlYqSCGyO1bnXU7NThsGjQqKJ9XRHPNsc4pC91dWjZQB1K2sjwwI2uZd7laYiSBTuSajIUR28b/5XiSbirMlQi7rENnwSX7L2q8cXhd2W0DTGHiD7Q8SkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA4PR11MB9394.namprd11.prod.outlook.com (2603:10b6:208:563::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Wed, 25 Jun
 2025 09:39:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 09:39:06 +0000
Date: Wed, 25 Jun 2025 17:36:32 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aFvDIDZ+Y3ny/WuF@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com>
 <aFWM5P03NtP1FWsD@google.com>
 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA4PR11MB9394:EE_
X-MS-Office365-Filtering-Correlation-Id: 7999d012-e02d-4548-ad02-08ddb3cc2098
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4VVsY7KBsDpNXeBF4OTjqAYq1oRM4XWdlua/Gg4fMIXoHdqt/9TkPEzhvwZy?=
 =?us-ascii?Q?hHZqsiYaVqicKanIzAiYnOjPAkDRdFoAuBkOF1LOLYE3bVvAFovihG9sT8pq?=
 =?us-ascii?Q?tnra3lGRWg/eJzNnpvX+rrMXxv4JwFvQ7Uhc+YyiWOFEKEafssFb0YRYDORi?=
 =?us-ascii?Q?xO/mad/5j+tgxemergytOh/oKgzMgOCb9h4jjOZOamAX+vaP1RY8a4U564Fi?=
 =?us-ascii?Q?igiakIB+NhuTn8i3bT13/hI3jic8WYB9wkCVjQA0pjhQappYH+HfcleK4SDS?=
 =?us-ascii?Q?HrVRDl7ut7k2wZNQYhnJWIxCkoWtx05hnDWRs7van7EtCzWQUNS+mAsl2w0w?=
 =?us-ascii?Q?qQfyVwCh7BYNAdOf/8f1Bl3BnWyzKWeT58c+lNRe7jOQlt+8aJni/HcliW+T?=
 =?us-ascii?Q?6NNgvdC5QBPLemBTmCrfgRmly0hdUfN940qXtP5Sge07/XyNZZr4E/xMex94?=
 =?us-ascii?Q?Mf7wyz3cR0s0k3q7otr0QfvvU06JPbM85tWiREc64hY4LBa7tvwisV5ge9eC?=
 =?us-ascii?Q?Wl2T2/DAYYm8Qh1lCYPszJZM+f+gO55DykuyVcZCF9eC5HbJY/xByTsBQSLK?=
 =?us-ascii?Q?Pwu8PovSsM2cOQitHE/qHtPWzzQrz8Ccg5oZB0P6KRlJyTuMVsEz0dp8n4NZ?=
 =?us-ascii?Q?fGWsrnLRXF+0emKmlhN/wpvJF4TuGo05VXoOBqHGy49SZ6fE5aZ2AJpo4FDF?=
 =?us-ascii?Q?QumWlSRI3vrKo0hU4pYLcWwb8z7KxX/TehD0xB843yYEEJ5E0E67x24QN06K?=
 =?us-ascii?Q?K1oI+2MbY/IajntR2NZnTiLPYbtk65gdtyqv1OBACwHrg6MqBFsvi0E2aYSh?=
 =?us-ascii?Q?O6fy6wbFTzrgLQrUj62mkudDChbtMse2wWwTssqcrJTgyxP8gjbr+mvP/ymI?=
 =?us-ascii?Q?BN7DJggIz9Oq2kVjedYVUv9tXIFDhGK3Ar7BHrctKFpyLfPO7mberXF0S8Op?=
 =?us-ascii?Q?rXZiwpkxPA50RpBXDRuUhxbM/Ku0sZqeu8of+c+FRTkoFu2wAYnCu3QXM5tP?=
 =?us-ascii?Q?TONpNYicC3eJpwUIJ25MEnFKknaSOc3PBhf487ExWqli28rJzWFy1X7+BjTb?=
 =?us-ascii?Q?EtP8vwL5aYR8lJmi49vND52RkmboNfg8+IC7nBQsYrrurvREuC16y5vV94x5?=
 =?us-ascii?Q?TlvfYuRu4bHAl5qM+X3cXHOsRLF7Fx1zbCXADKVWKajcGos5GNuBhh6htog7?=
 =?us-ascii?Q?1FZa2l6sdojBEhcOkGrwE1H35tLJv5GHAAYsVDtK2ICMjP3ue1fI7JVI5UXn?=
 =?us-ascii?Q?oeywHveMftAFjAt0dbyiENe1YMyRg+U+S1hvsyX4AndvzpTNewbBWD+qH1LT?=
 =?us-ascii?Q?qtjKikbRWOKI9c9E7OEvaTg4NcJ6tVTY8mpZcA8pimEzPNlNDBQZqi0Pm24X?=
 =?us-ascii?Q?tvO4p0vJgLBvzmoZN8bnDOZj2JoYYrwCgLNahR78zNGww8e0ST9mI1YwlTUg?=
 =?us-ascii?Q?XiNvg9cdxzCr5/xBM2pJyTKe/IqxH96RQHtUre3qlldLtRbZ8e5oiQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W+J/SNo0hafEV62HYBsdh04Q+B5E7V3CN8kAjiwqQLJ2Sez6OmCEC498Z0/q?=
 =?us-ascii?Q?QQ5Qp6lqALdDhZB6Q+F936gcqGRfLFutFZBRjdLi/b0S/zeC3L3flVwOd0QG?=
 =?us-ascii?Q?pFCrDltT2/zL8XtbyN9jH5xkcPJ2wdQJlsgLwGNstq1flWsF1nBR5wXcff2T?=
 =?us-ascii?Q?lBuLTD52QTrYf2tU3/haC2AP/AsUYd9nD37b2ET6nbdfheS+mZ/tZCAz8OFH?=
 =?us-ascii?Q?hbALzxKUe/aWA3qe+axnN6cIYALWDbOGctdrylCu1M6c+73Gvil1Rl6UdwSW?=
 =?us-ascii?Q?tHxqwEtqA9xKfpH2j+KFmKkSXsQTr+RwvXiYorcFDvhB8LeeG54jCMtVqTxc?=
 =?us-ascii?Q?6sBIdE/sJ8njZZNaxl31TpIZhXeO/xnH3nGJP3d5X1SgujYshOYUoClN/NAe?=
 =?us-ascii?Q?+SllNm6UTU38AdkM2apJiSISjARCk0W4SfnLm3QQA2+MDT+F24/PIMpo76Nd?=
 =?us-ascii?Q?U4LnqYxWW90lrw3lljy4nLdnslzhQG1+sfI7UWy8iobuIVywr+H2OubtezAs?=
 =?us-ascii?Q?QII+Oc5ZWdTRkq/mHFjNh4u90aFU269TMev5qUIUHhL5sg9iWCaIX0GFO6pU?=
 =?us-ascii?Q?ac0jWRZNVDFXQl/qGzczPd6tbG7LjqcW+s11mEV3JclmNWmu/vsRSocjbP8/?=
 =?us-ascii?Q?XCZPzRYt9GG1avTFJRv9uaWKplgknZtNICpzBqnuFSHQwYIuB7/eJsf2L/WG?=
 =?us-ascii?Q?RisByGTLpzOnK7FJppb8/4IXbagIQkQh5lq8YTEjsrZmVBm/Q0v8AAfkqeg8?=
 =?us-ascii?Q?z4l9b2kFXbed4bcJOFb2OcCKL6DUXqhKgKmQO+mR08y24mlHmWGPP5w0wHye?=
 =?us-ascii?Q?koyu31EQYD2yK8wtbpIzfWoRLxeq937P7Y6VYiCSSJyx4hmO3uGsZR/sby1G?=
 =?us-ascii?Q?n9kzgzzsvvLnFLCS0jvwPv4+CrC8OJsVODHlTLv2qc079yFsz/WjCeSFYGwt?=
 =?us-ascii?Q?rOcxsK7EPp1VEWJ4H7EbdjjHOU+Uh0uiAd8iAwGGZlwbbV4eSfmKcDG11zGa?=
 =?us-ascii?Q?3ZoUiq6sqRSpstzRXMI0nQ/Fuho1vPHrw57OjgK9o14IUH6l4HhCZ1QCci2t?=
 =?us-ascii?Q?1JW6pncJno2mxd5o5OiOSH09aTF3EN6ivIXw2jkNm+Ra4OLu8Gy+hktPM59a?=
 =?us-ascii?Q?p9rsJOaketqOSSbm8Mx85uVPsDnclnQveCFhlge9fbfeFGupzI+uIDYcSEnL?=
 =?us-ascii?Q?Jx6fBmi+8qBvZKysS2PAPg9BJK91CisUrTVfG30bydk3sb1FJk16eesfIWv0?=
 =?us-ascii?Q?CTymCERrGI1w9f4wGSQLmjhCRjiZV+EB3O361IcGDune0eG3/blThmkNgzPt?=
 =?us-ascii?Q?UIDq8bbvcwgmw+sJzgLI2XWwjQQhB6aiOBQNN9dZJK5qEfq6PvsQCpcRWOM2?=
 =?us-ascii?Q?Ygm7uF5+8CXrn3WyNgi3lrbbwlzuPMzZaY1hkYhDndvL3q4bMXxzEOlFlzYo?=
 =?us-ascii?Q?wh3PGmYOmigMciqGjwnxeGZ6rsEstW3ckutYJUohwBwy6w+lgGiDmbW4jR5m?=
 =?us-ascii?Q?8mT7nB0FJSvHI712lB3JbbPllYzSSGEWpjk7IjGXCwbfN6QdLrPElKuxLqtW?=
 =?us-ascii?Q?CG3KpuQgps+LoxfnYgZsA7v1WMGo9VRiRaWyxofv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7999d012-e02d-4548-ad02-08ddb3cc2098
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 09:39:05.9981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VfjJM1ctkT1WhXwnc84jTspicZpdQWne+i949S8kHW8q5hVuPXHkt+TPGXev+OEbruGkK5Y9xTQn1QVnaacmlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9394
X-OriginatorOrg: intel.com

On Wed, Jun 25, 2025 at 05:28:22PM +0800, Yan Zhao wrote:
> Write down my understanding to check if it's correct:
> 
> - when a TD is NOT configured to support KVM_LPAGE_GUEST_INHIBIT TDVMCALL, KVM
>   always maps at 4KB
> 
> - When a TD is configured to support KVM_LPAGE_GUEST_INHIBIT TDVMCALL,
Sorry, the two conditions are stale ones. No need any more.
So it's always
 
 (a)
 1. guest accepts at 4KB
 2. TDX sets KVM_LPAGE_GUEST_INHIBIT and try splitting.(with write mmu_lock)
 3. KVM maps at 4KB (with read mmu_lock)
 4. guest's 4KB accept succeeds.
 
 (b)
 1. guest accepts at 2MB.
 2. KVM maps at 4KB due to a certain reason.
 3. guest's accept 2MB fails with TDACCEPT_SIZE_MISMATCH.
 4. guest accepts at 4KB
 5. guest's 4KB accept succeeds.
 

