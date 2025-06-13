Return-Path: <kvm+bounces-49362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 630CDAD8150
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 05:03:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FD8D3B67B1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 03:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD1D242D64;
	Fri, 13 Jun 2025 03:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G+triBVP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3B018DB1A;
	Fri, 13 Jun 2025 03:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749783773; cv=fail; b=qS9sqkV3q3roSHR0w0ca5mGGOseMhqvE+7mwtjdHANzj4lUZnXsQLp5LZDBu3NEtdk+AcS5lStLhpgqipYWIDCETxQJpMRT/Ww9I0YOWVrvxqlMAQqvTs364kkQMU+9kbgCAsfygx8zTCkr9eDNTqnv1Fn30zw3TNl8TvU5R2m4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749783773; c=relaxed/simple;
	bh=3OYqMJQvXBVPoGn4mCJg5QLF/hJ5bBa5BTXao2ZkuDA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kiOh7EKwT+OMX6AOg+G/tWY9dl2a6eIpzIaiI+zAXJlHvaieg69UrdAv48PEzzqJr2+5iMpPsc9JqoWEtpT6/ba+lF5Cjh8lvHv7zzDAt1iS9h66R65+p4WTMEneZxYgFiMgt2m6WM5F8qRP2lEv0uy7I5okRb26u2nNLKWGnKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G+triBVP; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749783772; x=1781319772;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=3OYqMJQvXBVPoGn4mCJg5QLF/hJ5bBa5BTXao2ZkuDA=;
  b=G+triBVPlMBkH9AbyU4Prm8u3VOa3kVNt7ACUOLFcig0y+zx2oUALt/N
   upFtsgfk+aVRPqdEtmgrRg7Oelt0v9ApB9bGUUrRTXiIp8/TY4swL1gk2
   cFc262kWUCX+cOVPLRpuD9TzeIrRECVg18CmIcxh1JvFKt5QEFvuOOLG/
   uKU4umY5QNfcWYjIdJqOiJs56rHE/31Kf2pApjhPgBqcuviWeWqZvRkRz
   C0RzG9kPig9EChioVzhMompc73zjJi7QED/dZPAKro2ZAROKpee0PKoU+
   XHFhgHsGPPg5RG70J6G30WwZcARZRkqJ/yvFAPd3jpoLDE7IpkpoBKSSg
   Q==;
X-CSE-ConnectionGUID: rkbzt7YwSEyIhlfqYVkLZg==
X-CSE-MsgGUID: 13oF2Tp6TbKPeXYg8UCeUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52083029"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="52083029"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 20:02:51 -0700
X-CSE-ConnectionGUID: Z3nhe96dQfSC0esMiza7Sg==
X-CSE-MsgGUID: lYsOaGebQn+JWdNiZ0p1WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="152859373"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 20:02:51 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 20:02:49 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 20:02:49 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.41) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 20:02:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iv+286qW1iD4HI3FyjClO39Qln2ISw0Nm52ze5U6Q8BVcxlFIHZYhtcmCywC8n991l3qJ/muXY0o79OEZ6fvCOUYDUDANXcCZu5qBbk4ZuhNYwLRhhaHjU0CpnstX/EVXi3g5EVbRKXeVR2TEh7l2lf5pDCHXFoCsREZG05GZwybkp99e4yDDNo3kE7BQAcrPeeLaf4MFWIT4FAqAj1lfkSfKEXomcUaHorNpZoVUPfUKalaK7UeGwvv5Fihku7QWR3Vji/osVpxDfV/lkjDDlfJ3oo6/NQxzkqvLxWx8X+EVyQZXLx6xhmiLpC3bv04b0vHHLM8dR8M9JX+smAqdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DfzJipnWxkipBw0abLLBlO7WljcXy4yEyOLlLuxqyTc=;
 b=qxkBHyGRuhZ0jyCT3ISafggpOBBEkR8cAsM+a/3uORxrf8idg6rZL4dw1m9PodrNKTSadpLSCaFrRnCbBPSkqiULLcFnKyb4CDvO0Gr12jQ8hHkdQ/K5/WjJLI11iAAbnPBK97V/e8zU75xhqTf5be87BGCCQxefXueqk3j+MLfHFQVNvsOs4ZuVc00zkLQR8kFR3EaEYqvIwV2/Zj7DDcpbd9xqVAbFTei7k19fy46zYRDvLnY4UkIgASHHmwcugzIqJ/bzFxhzF5KBuSiAQWpoiPBgJWyiAAdxCfMKZZ3y0gHpvS1MHmcMHgdwPMLSFjucwZ+jkeSMeZCXlOZzbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB7949.namprd11.prod.outlook.com (2603:10b6:8:eb::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.30; Fri, 13 Jun 2025 03:02:43 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 03:02:43 +0000
Date: Fri, 13 Jun 2025 11:00:21 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <xiaoyao.li@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Reject direct bits in gpa passed to
 KVM_PRE_FAULT_MEMORY
Message-ID: <aEuURZ1sBmSYtX9P@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250612044943.151258-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250612044943.151258-1-pbonzini@redhat.com>
X-ClientProxiedBy: SI2P153CA0007.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::8)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB7949:EE_
X-MS-Office365-Filtering-Correlation-Id: 60244f76-7d68-4ed3-6ff7-08ddaa26c437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4zI/aN6c/AmP63FVedkzeHESb5fn494QcimZNgrZawjSrS3EvqAklnRniSdi?=
 =?us-ascii?Q?Ij/hQuCXA8NIoz5Y6TUHmCmJg4FCjIBvVmng6XV5+qalZSN4g43jYi7GIrRq?=
 =?us-ascii?Q?DiID66iVRhOnCJCZDMEawzvC5Q24JOxp7ZwYKzFczQ7zIWmaLBVrNacq/ouY?=
 =?us-ascii?Q?7xJbgY8kBT9Yh6G/74ah7N/VLQTTx29e2TKqqzcepwsn5OPstGCBogp3OEnk?=
 =?us-ascii?Q?v+TlM2/3kE50HOLtYVoa5qiXA2B+hTuRfbT2S+/D3RJSAxfdkYYLqQ9WEwv/?=
 =?us-ascii?Q?vmazdHhOi9d0jxD1XufE0sqDXSNtIgUwxfGzxzXi85tQF+FA9KOXXLSCj0fI?=
 =?us-ascii?Q?eOHYavUSl5ORqitXLLYdqEqOrIOJjKQ2L/OsrZBfySjTPG17b2ooXzLe29yG?=
 =?us-ascii?Q?qCZIRwn76C6SzB2M8lR9DRXx+XMlrZKFaPaBVkZmX2vpT2311xCEIzlKO8Xd?=
 =?us-ascii?Q?vBcqWK7fYd5fjYFbh7Y0WaGOyZL1a9zGnWkpQnyaqmZIonIp86rUU6+ESC/T?=
 =?us-ascii?Q?VSpjdWlL2/sK/aU4u468sE3n7+tKG/4i1/OGRwtTSHIg/yPI5DtWHhxBgGub?=
 =?us-ascii?Q?rDJPtLY8HDdK1UE2FaJIuyFMbnnkC+saexCwFzAYNEBiS9ds+Sqc2giGVnNe?=
 =?us-ascii?Q?2VcdUwgm16CBwWaIzhr0m3ls+nvJ76uxjLKv329FTXErgvRd0pbR2HbeEFjK?=
 =?us-ascii?Q?pfOpcz/Eab04VEQmGsIOFX4/csNYFUCRy3HcLJ8HUmtsNI9KdT8cDP/r1WgM?=
 =?us-ascii?Q?SZhFVQ7US6jAf1OnLlj6ko0obocynLuuSbFTuR3dx8p36nYqjnfDHSOadjHF?=
 =?us-ascii?Q?zg95b06z2vmIbPNsNz9LE1RTlka0SjajfMnRoVZ3P5EeAAqJorPv+tq2QxQO?=
 =?us-ascii?Q?2Jd0sqg+topPVIopBv9BuKoKVNF9sIMTMuOqzUH+1hVyIFTM4iO4JYUI3Ij5?=
 =?us-ascii?Q?CcyFTWpf/kSA6rfEoZFNirNRvbDsRYeML6kNnq46dvh492oB+SUtCsbP6qHl?=
 =?us-ascii?Q?xmOJRJuPMslZsSIu1DAYqnSK/vSFGeqI2X+4FWWCc0te9qK3NZ6fs0FC+TzK?=
 =?us-ascii?Q?Y1a+1XS6kBCZmjIZ6xjAHV3uqAIcFvmlKhnVX/HTEXwrqbAn6F0/r1PwPpNk?=
 =?us-ascii?Q?+c+4/xDHa7II89H9wy4ltSIjpmKHaz3K+PBjLqKxFe9lctEgQ/xPaWyo7ypE?=
 =?us-ascii?Q?XVDt6c7GMxhcNINYdNOVjqFc8hyJY23c8eYiotuEQO3SEGkEBBAY/8fkGZye?=
 =?us-ascii?Q?PA7/9FmivGAa5v/SmeRU8XFY5nDIUYbvpUp8+OXhXXEnRmVachBjvasBha23?=
 =?us-ascii?Q?Ln1Z7A9D2/CJI2YmRfGbj1W+vQtcPxAR2pGdshAKPrijmxudmkhJHHXDKreN?=
 =?us-ascii?Q?9miFl0rY60MaJomIo7PrEeIQrHd5L0nAY7Rqjy0lu4LrRzib0T+MVQmSEKWn?=
 =?us-ascii?Q?jutv1rkVzSY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mm5yXiglBQD+ESUFTbWJT41kX3z+003SXyQ3FTb0KDoB28EqWn1hioxdLaSs?=
 =?us-ascii?Q?MZ04ExoisnjPZG3bLHvxhPFkLUQR4bBQ3DNJSc92Duj491v4Hv5DZmUxxpS1?=
 =?us-ascii?Q?5yp7oM1m+pBBy0xR6JvGQThx8VkGy6OIfitsBtq6RYBX85byzizv2fAD91Z5?=
 =?us-ascii?Q?ubjdzaJlkIC7AKpi8KZ1feZ0NXikX305WYNCB7pzxZTdeFN2qcVK3I7rQMYj?=
 =?us-ascii?Q?ONkYHq+K/QB/ywvyiE6tE8C8zsuUkXRCcdAbLfDFqGhaqWTjkxt9ePwU6zht?=
 =?us-ascii?Q?g+Od7UeyEHh5r8tIXbX9RQYT0U2rekO7Zov6riy7GduWNEp+G3pWeC+ovgiq?=
 =?us-ascii?Q?vj5i7gOr4ceoEZSG+sZNWcQr26lMRiP6fptapF266FuiHNTH00jtI7fOtrnh?=
 =?us-ascii?Q?SoSj11GVkxp9zqh9PKFUej9u8LlyCndpZH9KalUEs/VkEtnatCgFFSfjEG+m?=
 =?us-ascii?Q?6DE7BxqSPx/sWeMlBRFrLC3bphfLs8ScbrF7PdcJlTpgNwBmOESUfXH/abQ3?=
 =?us-ascii?Q?Sl6TENL/j7fO8Wm2iTfTIGsVCywjI/NAFo8883J6ukW/rKO9qNl2MccXpji4?=
 =?us-ascii?Q?ba+z4+8kmo2TnfDflWazbRGe6IKxNRiRxX5m/5sHyGjCcq6vVSpAS//JiMA1?=
 =?us-ascii?Q?0FAjlfWZZI6II5xE2vNx3TFGX35M5e6jawBYeBdLotSVdf1/nn1HIxoYMiI4?=
 =?us-ascii?Q?sfn1QKU0x49qeoCkZnzutOz98OXsaZ+57iatKuF8zx/zDBRoElyV1Lx7Wgem?=
 =?us-ascii?Q?FEAan+BzEHXV2ocUxe3DWV9uqZPH6vEYpujVlSh+z+JObr6iJCAn+DQ1J/qE?=
 =?us-ascii?Q?SwnV0F2knCHIEbR4HUtfSZRP51EPAC9oD37bIMvOgJuWyGQocD9OYAxzx5o7?=
 =?us-ascii?Q?zebRNyHrYapdcST1jSwScO4t99Hs2eqk+BDxLowLA5c98zLL3efkHPuEk+Vm?=
 =?us-ascii?Q?dC6kKilN+yvreuberJK9x6IgIkjXXN+ExFYmGK3yMUWuZJB1DnhaQ0aEb57s?=
 =?us-ascii?Q?U4U9lD3IrhyyaQNn4y92gMjLrr2/Qk3a2wuuOVXa/qMp8uMvEC7U3qeOfM+O?=
 =?us-ascii?Q?djo2l1Jg30TspI2V835HNRNcAjsKWFGilAn094EyzL3X3Nowd5kiEpXcw8Ix?=
 =?us-ascii?Q?R71KgruN2mu+zsqQw8LqTduvwpcUXMLvbmZ0xsZcDC/rdEPZoSi3ZL6UNZZa?=
 =?us-ascii?Q?hoWgTpmiSmlREAAJltjk2xeQ0A/U/8YrOHntv2NyZRU7aS0XwfUdRBjbRqn3?=
 =?us-ascii?Q?B8j4JIZ+mI3Pq6OITIzqgJdqCt7+n8U2ZMY4EAmNV85stg4xnd5eovBmc6fF?=
 =?us-ascii?Q?HrP4uL3YWCeUiZKdVXN9SAOCZLB7q9Dc7m0LJJBvyC/iOA4cGDl5tsNoQaxa?=
 =?us-ascii?Q?7T3YCj+poY0+g97CgF9WoXbTpD7dbK6AZQ5o4NB4jtpSba/tooAzdgpoJnj+?=
 =?us-ascii?Q?wBJFSDq/zJYuKq87YWaXIOBill+Yj76R9UyJRcK3V3UaehwLsaAnqtkSId0v?=
 =?us-ascii?Q?LXhDWTlNDlv3fktjXa7PbPSuQQgdrT+BMg/43Ofx7BaGlQ5nA/i7BmsASILv?=
 =?us-ascii?Q?kC6do1pLlRx0mUgPOQVgOTbOFwKdwAtwDTNjJnSS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60244f76-7d68-4ed3-6ff7-08ddaa26c437
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 03:02:43.5104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z6Kw2gkCON1Bm9i1+5vKGS28syJMui/BDHgGUxFFHwQzXSN1NGvNi5zA5kfU/kELqaWrG1KT/RcUBc3u+yPYIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7949
X-OriginatorOrg: intel.com

On Thu, Jun 12, 2025 at 12:49:43AM -0400, Paolo Bonzini wrote:
> Only let userspace pass the same addresses that were used in KVM_SET_USER_MEMORY_REGION
> (or KVM_SET_USER_MEMORY_REGION2); gpas in the the upper half of the address space
> are an implementation detail of TDX and KVM.
> 
> Extracted from a patch by Sean Christopherson <seanjc@google.com>.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a4040578b537..4e06e2e89a8f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4903,6 +4903,9 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	if (!vcpu->kvm->arch.pre_fault_allowed)
>  		return -EOPNOTSUPP;
>  
> +	if (kvm_is_gfn_alias(vcpu->kvm, gpa_to_gfn(range->gpa)))
> +		return -EINVAL;
> +
Do we need the same check in kvm_vm_ioctl_set_mem_attributes()?

>  	/*
>  	 * reload is efficient when called repeatedly, so we can do it on
>  	 * every iteration.
> -- 
> 2.43.5
> 

