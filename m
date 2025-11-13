Return-Path: <kvm+bounces-62967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 73FE9C55846
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 04:19:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1C9B04E313E
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 03:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E106285CAA;
	Thu, 13 Nov 2025 03:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MNIoSE1/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38AC26AEC;
	Thu, 13 Nov 2025 03:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763003908; cv=fail; b=c26egKalYJXTdkfMrMF/OQdnvbNqDYxzFkuzHg+ovdq4v5u8inxlEkOeEAOrspm1cyivgT9NhDImAe700LuV0n9Mvw4W/7MsHaIzb0LKAs+8Gw/Q+Sa1ArSEJf27VmTqn0TqLgpuexELEE7m6u/LQZk+ymfx5Ax6U4+NBeEsQzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763003908; c=relaxed/simple;
	bh=JFRvCepSGcZhBzIeyvGRduKXMx0HfE13cpAsvATkDg0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jqQZun8ZIlQZsKrdUtUam366e4GjB6V+drIeXTLfIj9CdXwJ6Z/sAmU+yHbn/eaZQDbLawAD53gwdCpprUzrAnM9pTWs7tugdVyqdg1g+BWjlW1wL8Dh+rM+fEUT78BfPFGKiObhlvpoim1kaZqL+3y5Ils+Pdi4xSkHN2CVg08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MNIoSE1/; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763003907; x=1794539907;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JFRvCepSGcZhBzIeyvGRduKXMx0HfE13cpAsvATkDg0=;
  b=MNIoSE1/WsbB/x5nPwuiHuoFDqfuorUxsSUbLomRzBHlCgVD+WvvyO95
   Xw9dLOy0hE5vAPpFRYo5sQbIy0pcP+2caL5sxwltlQaGOY0T/24ECOqPl
   0lDU5JCj/0Wqy1YEQce69qKvPW69JgCdUw3VBvKuShmbBQvNJrPY7n7RM
   HnF7VcTXvbCrodgoXcQVz5lfZKN9DkSCFTJUXPzN5KwmK4VWWfg9Ge5h+
   1bHqGF94Lg+jcSigQowxGD0/tfCp+DPAJV4wOd4Wnx2qi3TzrLW8Ao3eM
   1H7lsXln60dYrtUo/+b2Nlj5OPdWEH5NEhQfGlhJSrlrV9dQIiIxFrjli
   w==;
X-CSE-ConnectionGUID: Op6+rDvnQ4C9vUrv84RE8Q==
X-CSE-MsgGUID: g+7a09xLS3y3FdkAw6TZ3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="68942147"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="68942147"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 19:18:26 -0800
X-CSE-ConnectionGUID: 1pPF+ts/Q0SG/za8IxIwFA==
X-CSE-MsgGUID: ylSr6LzTSmqeka1gwpP2/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="188635748"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 19:18:26 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 19:18:25 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 19:18:25 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.5) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 19:18:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YKVQffLBh6bJs3/DCu8L8DtVTLS8W4I54Q3w72RHZ8gM/mxQ8JuF+mzSp4khfa8XQFAlWb6WaW9muBRaV2ceP3ERbhVBbmZ0hGARyPTwCOjD++LV0LC7fTWKdTA5W9ZHPJvh3Avd1b9qYHNTHVFNR/dgfLWCx6FRgvxqp9tWwZ7yM2O+loEnGUkk9+s29bZtqgJ3aPOW72kIEnClchd/KOcdw4bpEIVhFqyRf7jOakuMPmLDNetFYX06NkF4qC/G0uJUgMWoQ+3LoF+OXe2TgOm0rjZs0qa/+ONcb7F5XgsFZvN9HkWmhmbATb6CMexgHPZyTz359bUIXjXDKWSX0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KX5B5K/B5WkGltWQa7Jt+kTQwfapdwbY4Ebphe4ollU=;
 b=amJjKAAxZF1qpwSl6aCQeDdmbr6EFa3S9yhOxGi+2AtBHYVb3+FknY6aEb6yp4evxCZLs5hYOxD9qVQccNaB12JLlwStQ3aTh/uDE6JryFZqZNni3ysEaswcIUaBQALcrXTaJW7RNClR98fztctVyRAXulJcrfX5t32Kx26K9Ir+CZpACtwd0jN16HVz3kkSKEGHioNDHdAQ/+NNadRu65XyNi39l8QmpG3si6RmBR98CiljIE0hK2iReLZZa0vdY3zcGMKbVGp7+7KctLEOapNqJlVALHMTjrKhyFyXCO6TeRjs+D8pVBtzMTw3lXCGX+59KpzvWcQhm4lxFFuo8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8211.namprd11.prod.outlook.com (2603:10b6:610:15f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 03:18:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Thu, 13 Nov 2025
 03:18:23 +0000
Date: Thu, 13 Nov 2025 11:16:18 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
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
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 09/23] KVM: x86/tdp_mmu: Add split_external_spt
 hook called during write mmu_lock
Message-ID: <aRVNggcp4Gr078ha@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094320.4565-1-yan.y.zhao@intel.com>
 <40651a97d837bc2f2e11c3d487edb4b4e3941a97.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <40651a97d837bc2f2e11c3d487edb4b4e3941a97.camel@intel.com>
X-ClientProxiedBy: TP0P295CA0028.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:5::8)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8211:EE_
X-MS-Office365-Filtering-Correlation-Id: 0347f16f-ee35-4191-9b3e-08de22634d7b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7TD/mrRymUbtMKidOupMAcYQgTcMFcWy5wNvQpzBXIzbLBFqDf7UxQy+vPH6?=
 =?us-ascii?Q?dbPjkWOzZgN/FOtPIpuLfje6bXx5j1Mevc4tnKyylkpPeJBXE1HJBQQHpE83?=
 =?us-ascii?Q?VDLRKF3Iy4VRVXbgxyNlpHn5W7l4HKaJXZrr+xvot1n23qjCpkcM1uzfcXlL?=
 =?us-ascii?Q?5ufOmdbbHr5/vMw1g26XGnOf1lWEnz9B6YiNpav44xRxRfbiWjwTC39YUW7Y?=
 =?us-ascii?Q?vgfU1Pp+yzc67JL63h8xZBbGqsRaz92SBxj91Ma6A4JSHKgvie6eKMCoEE+O?=
 =?us-ascii?Q?dVYxpWfKbY+8BlwlPiQYIwca7/xvuA/gDgz5ecT7oXHtkNC+Ncj0nOqmoqmH?=
 =?us-ascii?Q?cKwurkVGhEUY773PdBMmCSRveZGB23R594P5Gvl/6CkqWA+XNaGtRdrMwt0K?=
 =?us-ascii?Q?G9E9R7cvCp7exUIHyt3NGFFBxEI8liAbAqmTt4vO7TGBY803KzSu5uQGI3tS?=
 =?us-ascii?Q?R5McWcrPKS/zUIdle73cAWbfTN+j/nMqtDYOqA6JGgZ+afqQguDBMK3MkZph?=
 =?us-ascii?Q?bhopEhtKHGnOVM9DpFOXnB2mwjXT9o/0EMFQ3KItZvRYAXQbYxWixfUBnDA6?=
 =?us-ascii?Q?KTxtcnyqEng1p0hVVRwQxHoSiWJ96p72M9rnds7QWdByzj7dnBdmauflJDlF?=
 =?us-ascii?Q?k7JlmiDBq9GzeEHVn5k0RyPJ+VgaJ+Mk3UyvoCzCszLC8Y49ZYGuyvq3a0f2?=
 =?us-ascii?Q?dlC3DBKcO+5lIl6l2q8BYQ0sEQBUHefBEKxYu/vl5BX4wtnyJMI7CxkzQZp0?=
 =?us-ascii?Q?VF//3dQox4Ts1EpqFLgDLZKjeqguuG0YdFJzqwi+aiNzHUSmxUkzpf9cKOPM?=
 =?us-ascii?Q?LfXzgDXY8ilOwz4py82B44/oIBOKtUUW4iCzGj3b1W/EeOPygLjQeGGSerym?=
 =?us-ascii?Q?MIc0GcmB6mId4jpxKjuZotgrXMBZOwFVfsT4WhgF5vStBRcIk9C4F7oayuYd?=
 =?us-ascii?Q?5AByTmIeTXcmCzLoGN3UMETeh5iAmbg4x7nMdXiRvdELjgjyzjLzrRMfLAWH?=
 =?us-ascii?Q?6cbVy2l7SYUkeNECsIo7fdgg4e+D165GSc5ga/6sUOTsDWP93XVMdJAkgGRv?=
 =?us-ascii?Q?TMZwUNO+T3qaeOZhxGk1ZyHYDpcnELxO5mB4fnpY78YNKbRTnPW8lO4kdr2y?=
 =?us-ascii?Q?gP0E0FW9fMxUzcNB7HBWi65nUsdswI7mXYWbqq5wvjE7MiFY5QleDQ6GTKDl?=
 =?us-ascii?Q?H5Z3Ses7MreA8o1AOMze2p9m1ZYfmjDjSgY6u0MUgb49na2i29l5AU9sM6ce?=
 =?us-ascii?Q?U/wsPfEhHG8B5L5AvFL4aikXyrGDUqi0P9Fh+6g9BMwnpCEGcMNXyY1Y0Jj9?=
 =?us-ascii?Q?MdWaZQdQ5JsrP3XhUoCmF12bDXEUJRocmhCHFkoJm5aPnHoiFU2P9MOOQJnG?=
 =?us-ascii?Q?qePERFaAeEympI2ozylNoJGNejZQLQABTESW6eKYoLxO9YWUoek1SdLqYPdS?=
 =?us-ascii?Q?rYo7/hok6Bb9+/IuuNXOXbglu0yu7Rtt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OgoZ6wk3xXOvWui7Nd26gWxXzSsSz3dNR1mMdEH/JztYKaaHkqwqozTI5a4B?=
 =?us-ascii?Q?z0wLG69WPFCDUYx6mf7D9VqKnjsuOX4rnsR4l0u5w2TIQJ+840s6qMyvAYJV?=
 =?us-ascii?Q?FSGtUxCr91Q6YOuuaKFM+FquIURYw0kFM7KMs/7QOVvIEHXsT8EVPlseHtSA?=
 =?us-ascii?Q?f9wRy1AvUg6EMT1CPNv441zN7ZGGrF6rIKcbh4f8SXPfSk/tJPQMJluom5Bm?=
 =?us-ascii?Q?7cHwlFh72+hdCyZ8FvDMXn9jeEuObCPTA5WwF2OZT8RQzDTBjSWLDTpunxGP?=
 =?us-ascii?Q?X4LVV0VJadtuoJxCotlNa6OCHtQoHw9uZN4rY+yJwKhpDu3FNiNroAq8aoZU?=
 =?us-ascii?Q?PgZCVc68I3x1D9MWAUn5qCjpNBDZ453ug9cbGRPKfWXI+z5f34Y3NFpYKLHm?=
 =?us-ascii?Q?FkmRnZlD8V0JUez1tOHU6S8aGXL67Lg1F+T3jWDVxGlViVOorcWz3I37/hb3?=
 =?us-ascii?Q?uXlkXDz7sCarA/vTTFln2ZyIuyZ9t/wr1d4n3XFHxLXXR1W52dWuir5+Sbl9?=
 =?us-ascii?Q?RxmzQ+Hl5IrqIx7CHN9RgnVNrV3kWeHhe+ajT7w9SkoLrroD6JlOgSHn0+60?=
 =?us-ascii?Q?GFk6+vVmiAv2znlu1iuQp4JWeXbXLksygV7AdcIH+fL2B9+1pGF28byqsSKy?=
 =?us-ascii?Q?s2BxheOs8LLiVVeou03q7f5kXjSlUlasfGMx+PMLgi21LggZixhvRkHQZMW7?=
 =?us-ascii?Q?oxwYVTwaOsQczdxQgBIJxKX2hyeQuHXEY4j06MMJtE8e4YxZ455zHOq5Or/+?=
 =?us-ascii?Q?RSkgxnJUoya977eyKW/JFQe7LIMIXOCfM4IG6AuscLIwNyW9AZiGt6nznRly?=
 =?us-ascii?Q?bE7oUIcAQjtvKbu7GUTlx3rzeC5wwnZnhylPp7ghA9MRzXH7p6VYRcbB8EDc?=
 =?us-ascii?Q?ub5t5i/VFOw0ecIGJZ82p0YcHDnCPn9E6foBBEdMImBjiOyl+R0frEl1rcOM?=
 =?us-ascii?Q?4x/SNkRcljIfzKg13PU0C3lMkdUbuJdBhhvSRap4swqfJlrW1pgadkk7EHVx?=
 =?us-ascii?Q?extJikHwCO5pFIJkxgMnNen+Lte0NScnii4HozWxWrXhk/n/g7IbaA8Zqlp6?=
 =?us-ascii?Q?wdgxFLdTboxSzxsGdYpXijspkHKdUfhuk8YJ3ll2Erl+JmCW06D51UKfEQYI?=
 =?us-ascii?Q?8nPTAPDNG9icDX0AoWCUE1hYMd95Y2DMT90Ch8vWCHPH0rzI2F+RPkSEbbJr?=
 =?us-ascii?Q?9rn6zk8SB9uFiSs/BlOEoBj1Y7ZmS2RSqwlwiiToQkPXk79AxLtibU4r3w/J?=
 =?us-ascii?Q?9+76WK58A8JU7Rm3Ei0LmKbTOp9rlwHogn5QR+2p2JPdvwwxQ1z1cJwfJq+X?=
 =?us-ascii?Q?u1rQdh4UyCTQ3+HFalkp/xLIu6iXbnRRkuH488cN8mo0841743fX5c+gSfDP?=
 =?us-ascii?Q?dCrJG2rW2toUK4XlZIiOty/vcSemaeWZzcAyZisPp5XLbk71e8TdiChCr4eV?=
 =?us-ascii?Q?YP0JH/GKn5dcqWBiQVnePj7KdIw/mjMEnDLL8A0X3PnI2Fbgr90pjILcw0Ho?=
 =?us-ascii?Q?KbsyWbyE7V9qiBQgjnZVh5AhDn2F6fVIE625o35pgkKPXid76Qn0JYAQSo8y?=
 =?us-ascii?Q?lJrw3L2Re9MoHVrBpZh4QN0fADKGepHLWxV3fC19?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0347f16f-ee35-4191-9b3e-08de22634d7b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 03:18:23.2597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5Z67DmwhHrcKy1xC3bl/YAdZ4yLJgxXDR7X300uMqHLkXBqZXhJPJC62m8Y9ELDbXnHUnT3e4pKBdqqNwwPEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8211
X-OriginatorOrg: intel.com

On Tue, Nov 11, 2025 at 06:06:47PM +0800, Huang, Kai wrote:
> On Thu, 2025-08-07 at 17:43 +0800, Yan Zhao wrote:
> > Introduce the split_external_spt hook and call it within tdp_mmu_set_spte()
> > for the mirror page table.
> 
> Nit: I think you need to use split_external_spt() since it's a function,
> even you already mentioned it is a hook.
Makes sense.

> > tdp_mmu_set_spte() is invoked for SPTE transitions under write mmu_lock.
> > For the mirror page table, in addition to the valid transitions from a
> > shadow-present entry to !shadow-present entry, introduce a new valid
> > transition case for splitting and propagate the transition to the external
> > page table via the hook split_external_spt.
> 
> Ditto: split_external_spt()
Will update. 

> [...]
> 
> >  static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(bool mirror);
> > +static void *get_external_spt(gfn_t gfn, u64 new_spte, int level);
> 
> Is it possible to get rid of such declarations, e.g., by ...
I think so.

Will drop this declaration by moving split_external_spt() after
get_external_spt() but before set_external_spte_present() and
tdp_mmu_set_spte().

Thanks for this suggestion.

> >  static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> >  {
> > @@ -384,6 +385,18 @@ static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
> >  	KVM_BUG_ON(ret, kvm);
> >  }
> >  
> > +static int split_external_spt(struct kvm *kvm, gfn_t gfn, u64 old_spte,
> > +			      u64 new_spte, int level)
> > +{
> > +	void *external_spt = get_external_spt(gfn, new_spte, level);
> > +	int ret;
> > +
> > +	KVM_BUG_ON(!external_spt, kvm);
> > +
> > +	ret = kvm_x86_call(split_external_spt)(kvm, gfn, level, external_spt);
> > +
> > +	return ret;
> > +}
> 
> ... moving split_external_spt() somewhere else, e.g., after
> set_external_spte_present() (which calls get_external_spt())?
> 
> Since ...
> 
> >  /**
> >   * handle_removed_pt() - handle a page table removed from the TDP structure
> >   *
> > @@ -765,12 +778,20 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> >  	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> >  
> >  	/*
> > -	 * Users that do non-atomic setting of PTEs don't operate on mirror
> > -	 * roots, so don't handle it and bug the VM if it's seen.
> > +	 * Propagate changes of SPTE to the external page table under write
> > +	 * mmu_lock.
> > +	 * Current valid transitions:
> > +	 * - present leaf to !present.
> > +	 * - present non-leaf to !present.
> > +	 * - present leaf to present non-leaf (splitting)
> >  	 */
> >  	if (is_mirror_sptep(sptep)) {
> > -		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
> > -		remove_external_spte(kvm, gfn, old_spte, level);
> > +		if (!is_shadow_present_pte(new_spte))
> > +			remove_external_spte(kvm, gfn, old_spte, level);
> > +		else if (is_last_spte(old_spte, level) && !is_last_spte(new_spte, level))
> > +			split_external_spt(kvm, gfn, old_spte, new_spte, level);
> > +		else
> > +			KVM_BUG_ON(1, kvm);
> >  	}
> > 
> 
> ... split_external_spt() is only called here in tdp_mmu_set_spte() which is
> way after set_external_spte_present() AFAICT.

