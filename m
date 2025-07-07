Return-Path: <kvm+bounces-51670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DD86AFB578
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 15:57:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D16C3B2EB8
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 13:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60A002BE03B;
	Mon,  7 Jul 2025 13:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZXjGXlnv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FC92BD5A1;
	Mon,  7 Jul 2025 13:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751896618; cv=fail; b=RqIT9fz560Kap6Sz87zyUfxPSCmt/IxTfuGBdzLpmgLn17vcxE3S/PE+MPFBb+7eiFi7xfbOznM58dSTrZAg28quYaN56xCqdNSDuMKShe4K2qPRkABYP7T+289qO4VZm08UjxpmhOGVqNfJFnYQMFoNT0F4ww1Ea+JhOJa3BlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751896618; c=relaxed/simple;
	bh=V9Sgcujk1RAMQsksSPYI82txlYDICeuX+fpPNgiKjOU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eq11CaHdLLAgdvK8pWMD8UiAHlc2N23D5bsaUtB1Sil1xfCOeQwybrCCFyvuZysfd7rCWzIrmBTerBTCpc4pU64LY7Txi/Ke/I5CYZC4M196OvBKK5Cw1TyHBSWb+4jbCTXVqj2hfiYvuEnRefouhXAG98gXwQlSUNaYMbj6Y1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZXjGXlnv; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751896617; x=1783432617;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V9Sgcujk1RAMQsksSPYI82txlYDICeuX+fpPNgiKjOU=;
  b=ZXjGXlnv7ens29xlDwlJ9AM9exgM52wRAR6I3DWbaWiBQddHCleW03pU
   MGKV1x18tOdNy5RfAJQfbDJXeZDQO5t9oALUjj1P6nCUefE8dfgGz+TmH
   RbHDxP/NeAhQCt9kNKwekwOCu1TdmoJFGBDJ50DXXI6KQF7M5LZu1036w
   A+IMUF3wG86YLUtB/j9UfVp5faWKwpQQgOlX1RtojnpaWBbSKiAZj/SN+
   3Qd9p/uyCSLshPr1SmC/VMg1L8+YwslYqvdCqzLDwEnjhYNlH2DdGeYGf
   rrPblr9rCJtuUcGt4hlmweVsYyw2sYckd/JPp1gfQnYgXTk5jBqqYwqB9
   A==;
X-CSE-ConnectionGUID: XdHzTQcHRYC59//FQxYoiQ==
X-CSE-MsgGUID: AlW8R11wRHmHUtrW0Bt0fQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="71556530"
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="71556530"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 06:56:55 -0700
X-CSE-ConnectionGUID: 8RChP7atR9a9fo7xLpNsdQ==
X-CSE-MsgGUID: bJUQIH+mRrOlbZlJxD1YYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="186171278"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 06:56:54 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 06:56:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 06:56:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.70)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 06:56:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uPty/Qv3QvUoHtj/Y9s5/TPmm6TfYnyWnyMuiOM4/Wun48CMdkqqlpnqWctymXy4XEkQxUjLp3fzd3csqrTwylxBWRrfyXhuqUr+ogFgkhLDyB79jD6DkyDGhFfxB4yvYsHNNDMfgaOoLGGEdKhsGtNBX6jsgq3L7qV5vMre3UiW2KP+izBMsfVV6MBcMW+i/Sv0A2lDazFcr9AU4yQZkbh+Pc2Dq+TvBRzLJ5vyJ14oZFkT3DN1e1oPJf/iGc3iPSmxizIv0NYQvrFuapz6MlSKI8r1CDg2lz82Q+XM/2hdQ4ttbA2L6VrI1mKcHa4351i5hs6q+95PsmyW5GtWwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDwE3Z1IcSwzVrU/x2SpCFevWuDvRUeowp1bEIwhD5c=;
 b=td0wESg7rPYqGp6AvyRIHRt8N0eU+agrlZIN5hh6qt0x/wgTM2FwDWuD5GLjERlDF7hcmTNg4wuc+nzq9hzHyYqG5r7e6yLaUrxBDJR0xW+txItsqoRKoBvkxVEcaWzzCNZSBEIU+lUp0Y5DaYgQc3JRCrt7Q4OIRTe8gjMajt4rmysmwL5wRlMtxPzWAlkvPQqKnb83rWO7Xw6A2b872tVJWtl2LKFHiEsPxtRIIyZV2lqzVbGZa2hFJidmS8nkFTUmqddIkyyGNEbS8Nm3qy7FaxTdW3lspsZlQpf/e2nnSbO38vJ4mncfv8ANQSYl+cwtBQsXbR9ZdidJ14sfSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17)
 by DS7PR11MB7950.namprd11.prod.outlook.com (2603:10b6:8:e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.22; Mon, 7 Jul
 2025 13:56:37 +0000
Received: from CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::cd87:9086:122c:be3d]) by CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::cd87:9086:122c:be3d%7]) with mapi id 15.20.8880.027; Mon, 7 Jul 2025
 13:56:37 +0000
From: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
To: "Mehta, Sohil" <sohil.mehta@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Sean
 Christopherson" <seanjc@google.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, "Luck,
 Tony" <tony.luck@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Mehta, Sohil" <sohil.mehta@intel.com>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>, "Kirill A .
 Shutemov" <kirill.shutemov@linux.intel.com>, Jacob Pan
	<jacob.pan@linux.microsoft.com>, Andi Kleen <ak@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 00/10] x86: Add support for NMI-source reporting with
 FRED
Thread-Topic: [PATCH v7 00/10] x86: Add support for NMI-source reporting with
 FRED
Thread-Index: AQHb2+QOQuFpJBfyqEOoiprePqFUQLQm1OCg
Date: Mon, 7 Jul 2025 13:56:37 +0000
Message-ID: <CY8PR11MB71342AE041733CA1E299901F894FA@CY8PR11MB7134.namprd11.prod.outlook.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
In-Reply-To: <20250612214849.3950094-1-sohil.mehta@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR11MB7134:EE_|DS7PR11MB7950:EE_
x-ms-office365-filtering-correlation-id: 88146956-c5d4-4301-fb5c-08ddbd5e1776
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?9UwvrfLLnQ3HcazdTEBkLZoCfRZBls9bbmUCebXhOXkY1XRNg6YSDPOHnCWJ?=
 =?us-ascii?Q?B3i5jXDehjN5I0dkBUQf6zEfAo5lz+Q39hpr+fKrSbd7U467iyUA6kFK+l7o?=
 =?us-ascii?Q?FBwbptbnsnr/lVQiqTBK983hsMuyaPVT/qBFQEsDBVXPRB4FpmXpoUV8LPn9?=
 =?us-ascii?Q?xMwEl+9IcoebJZ0k8uv8NgdfzoEJTU9eIPLva3YcOHdhJYs5fu503DYk4szt?=
 =?us-ascii?Q?0s4CP2Zk9+8ly10LRmWgqwtbcaKI3TOtaHNLJpMpLdTlGMR+mBX7pGtg9GXl?=
 =?us-ascii?Q?tDHYPbLwWL4NcrFfCgHclkmt5kdo1cI1mq17B9hxgVFsG6Ea19Csj6G/H3TS?=
 =?us-ascii?Q?tBWRo6PX04BpFO+MWSdL872GqPTBYwKSIueGUIZ1EUml6x96acCMImr9Mk81?=
 =?us-ascii?Q?os0FIaE6ivO9PkTAR7JQ1dzmDokGV8n2Z7021zPGXOBj65TZWR+2dIeGyL2F?=
 =?us-ascii?Q?rIn9olKP1DyzPHZbPnpYjMwj+0N+akq7/pxJSQtN2I2EscDuHQXniIwMC8uj?=
 =?us-ascii?Q?Nz+FZ7nt5pNsH3N9lgN9MnkVctZR5ieqU0kx2Ce2OWXpV2xyshDBRnxawERq?=
 =?us-ascii?Q?kgjY6LAseNuh/UdRYGt7gst2KA6cfcHlSQ0JUfun4p6nHY3bFBKl23eCSCyN?=
 =?us-ascii?Q?84Wh8o1CkMytxZ8uP1VlpG2IdgMI70VVEtmPCji8Ll0WZSXL2ahXK5befC/1?=
 =?us-ascii?Q?WKiHp47R7/OzcwnCf1w3ApguvtlPiqBtUerMaQIPJqleabONh8t1aQE+Aaax?=
 =?us-ascii?Q?YMOklkDzLCWqZ2LPPvxbxxSRNcjcLvINus9x1SUIPXcbzie7x74MkIjm0BK3?=
 =?us-ascii?Q?Xhqy9BDyELRBR7nYFR/t8b7yi4fuwsTJwbYoKbFUzxWuvDld8fta2dcjywyX?=
 =?us-ascii?Q?GUuj5599SDvNYJsBXYUpORY23jvBWAfaI8qWyiLI807avfGJ2rPY72lVaQMe?=
 =?us-ascii?Q?PEbtqK4fUu4EXcz04E4FVxwvKvDVD2V0KllhtcjgM67MDBKjDGZcqGLj9VOn?=
 =?us-ascii?Q?pnMvwNosx/b5eCKwwJdDDRmlypEAqJ/AVgKcrArti90VDrcTlenB/zcmwZjq?=
 =?us-ascii?Q?f/7y+ixuUsrbDNLTUyfOtAit7nx8mNSHW6GIvuppzjmDvZHNOntoYC2aajbI?=
 =?us-ascii?Q?hRzbmccmWdD6EVaH0+TgeYWkQ+QaTmWbNN3XKy9SebD/tumsnsrywwvL5H19?=
 =?us-ascii?Q?+Uen0Y3DRnk4FwCBTlHKlccULXulpoQG6NFW0Q5ilFoKr9Kx5t3IwaAOm3QA?=
 =?us-ascii?Q?qmgPAAvgmogQL9CYGBA6pmRSuZkOKKntrEHfPeL+gqlnrJdDnYd+FWIWboyE?=
 =?us-ascii?Q?ZbndW6Qq1jPusmLl6xwKeGfpB2W2g4FV6lyH7B4ynGgyGDaYOsQOEplC+YYb?=
 =?us-ascii?Q?9DQwZfTr5KYwS6t+pKbK3mn/O0XJJ6u8Ho/1xTJgq9stDhzMANoBMVOj1TXv?=
 =?us-ascii?Q?41+wOJ0Eil5EjYAz1rGgQ9FMBYB39FRwbKYHF+scklsfzarIxpJ9kg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7134.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M8ti1hKn5TuSNdeXkpwsJBV00xqW0dJI9xtomJF6hbtdq3sv/oegqnwMysPw?=
 =?us-ascii?Q?0qAieXkIIZK0412aOXFT+hSdadf6Oz5ammrcY4j7yE5gEI3tFfl3Lgv7WVP9?=
 =?us-ascii?Q?C+csascmuiYv1DprgwuI6LrLEUOJFsoSg81GMPhpTrwhVNcLoESdseE722em?=
 =?us-ascii?Q?ARUX/lXLi66z0/Du5/8e5PMp0eTIhHi2xg7ja+0nyXfBFfTm5+mtL3hgTIYj?=
 =?us-ascii?Q?IQdbflKkc3JsztdLhOUBMkjcEw4QhOpjZnOYtjR+cwVAB8HQpSHlI9c+PJb5?=
 =?us-ascii?Q?uT0ARXLczShZbbl2RWqZcPxzUonocly/0m/15Ro6pa/9uw8DPUfXhllXlpxB?=
 =?us-ascii?Q?SxP17FTSdaoFTzennmreIIx85SsLUPcPajHn1hxbn24TvWkceucR95WTC761?=
 =?us-ascii?Q?+gTL2poddMEtOGGm/A3yMFQBJluYU88nIRu+M74/9FfD7swos/uj3br6UesU?=
 =?us-ascii?Q?CcDCzsNm4IaUhYTj5m9Z5FKXSsG/YH/Av27y/dFEk571Jt1czXLFjUijpLe3?=
 =?us-ascii?Q?8iSzSXIudCwRTQRzEdBDS5Mb0mfP4/xgLQL199is4EVMP2XGag29KIpT+Y1A?=
 =?us-ascii?Q?9QA0MOopx10RpWR4jL0gc7dn/0L7HHr1I+0hdXnESSAr1vFR1K7qEYjshPGK?=
 =?us-ascii?Q?xvQqRWh7UcR3uqjAT5iLG3+30XkRtQOPBESe3dFaty0ckc14H+u/G5+ZTgUD?=
 =?us-ascii?Q?JYs6DrvSuvDWsQWh89nuVqSDKoIJGUgKrqUuygNPdMzIAkhkWEz2kRYlRn83?=
 =?us-ascii?Q?2YZidPKSf7VyIFstGCLBiCyRw/VkQD5TQlbyPKNLZM0bjSSgpo3QSZEhg09H?=
 =?us-ascii?Q?eK9ZnO7hwhw1iv4e4uhNN4oiTiQP2cTB5r0NxbnBuwnR43jSf3zIy3zEtVfk?=
 =?us-ascii?Q?4X7xzVYWRgV9xb5I+U1TmxGG2RahmGaWvzfum6K+o6gv2FlMZ3d3Y8v73NKf?=
 =?us-ascii?Q?5dwMHC8ae3a7rE1RHDqjFeeBHNlarGqM1zGqMr/h+Gn0RXe+6pDQLqDdHyle?=
 =?us-ascii?Q?wJc3+zHOXlRPdh4jPe18I9NXLpSU1sxbN/Ndj58NPNHa77T7kFwj+ubwCQkR?=
 =?us-ascii?Q?iBxaQCPkJJnTtoDxMte0LfPaC6VPm+t086LzwS8m3HtUYo551vf4VJiTRHbw?=
 =?us-ascii?Q?bb1FpwUb6qZxkT5/n5VKrvHb2tMMJmkkq3G5WE165xBvGFmE8LdktO5vMiPv?=
 =?us-ascii?Q?31ItfkdZfWmoeUysODZurJ/kXFTZqZLbdlM2dZ8VjotzwhEaVPyY8EYDetH7?=
 =?us-ascii?Q?eMh33qk1P5eG8cgTs/ChwB/JQ9ovizcGSTatTFP2UiXp3FBp7+Im69VxhGXI?=
 =?us-ascii?Q?O20zgdEBO9Ia8IELnH8IWdLRUxhG0h2N8SgC6gLZX/ZJNmo4b3cVQWy4OCnz?=
 =?us-ascii?Q?Tcb5LMaizoDwxNoEbHqRbPJcAmqYl5o+gDOZT3swpwB0cKNIYXgUbIY+CooJ?=
 =?us-ascii?Q?W66ssbeAeY8NAauU+u+IwSDJ703Y5xMcNaeiRjGqcF5C5cij1o+/IjtMB2op?=
 =?us-ascii?Q?iOSkPmgg3ekmpAThCXAjUA1M/sFvp7ToTeLixAz9vuPRjwhAVph+H3QUtZ0j?=
 =?us-ascii?Q?8qpD8QEGNuxlPHKoFBtSWVDNZRFxuVxryqANUjBT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7134.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88146956-c5d4-4301-fb5c-08ddbd5e1776
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2025 13:56:37.4393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aUkoxP2tqIaEyUedSwSt2tVgBYD4Shg4WpqjdHx5S2kf7PNFqyUxY2DGSLpdoc4EeRuCpre1jnNHdXZln8K2dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7950
X-OriginatorOrg: intel.com

> From: Sohil Mehta <sohil.mehta@intel.com>
> [...]
> Subject: [PATCH v7 00/10] x86: Add support for NMI-source reporting with
> FRED

Aside from the comments for patches 5 & 6, the others LGTM.

     Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

