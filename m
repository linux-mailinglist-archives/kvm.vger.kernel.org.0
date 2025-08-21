Return-Path: <kvm+bounces-55274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F186B2FA42
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4A201C84C9B
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6335232BF3B;
	Thu, 21 Aug 2025 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bfIbYIee"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C31C2F49E8;
	Thu, 21 Aug 2025 13:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755782431; cv=fail; b=WzythG978cxxkfUqXDkQen3cYW5BJxDvRXUZsh2SRBzME3alt2rrSclv++RBrYJooR3UECvZGHhHyLcz9Jo+qQkbbVq1tSXWa8wQst0R4WY0984v3wQhBSlzOkJ0GqGiEyBB3IAGvoZAXoZZ5j1Ui/tzyd2+amfrm+VMq8mwJYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755782431; c=relaxed/simple;
	bh=M2U3VBOezgjKR3KQkVBN4x7VZNCMivjLj31u8QgMtO0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DnfUjzn9h9jlfAXfBoGJaGz9HFH1uPvUMM2jUzXGdMGSVtojoMzqr0Iqo2CZvEKst8aZRaP3RtoSz4okuHRPKJUR8zK8iajn9kMMKx/JX3NnzRPbc1a0dSJ+rXlfATNLuhO7Z+aCBzy4SdxFu1Yb/cYqosXsebOGDKwJq8jJCPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bfIbYIee; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755782430; x=1787318430;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=M2U3VBOezgjKR3KQkVBN4x7VZNCMivjLj31u8QgMtO0=;
  b=bfIbYIee9Ddu0RR4GxaJTGKk/o+2I7ndsuJeCR6GVLqoOZ+VqUm1Czjz
   1ce/kKbfW9Mnp7tlv02FmCR+7Zw2IuIMwQjqDU6VEcBj59DZCO6NxG4Lq
   YwBJ6ba/cXpnGpqwT3J8yhJ0sv3/kbne4GwD6QNhLHAC/Zg5J4kWiMANg
   iEWsKeWq0e3tnaZW/eLr/F85+9z4WsMEluKGrEaxNaLBZt//u0bTp5/07
   D7PxEk+cFbcz7AjSOgGJuaqt+KCSPM1qZDAGXaFzjniL9Y0jHeK3uqnEb
   BXpuSL/nIUNcGwsXbVrPlUC1fRvZszPLVN+aJabEqrgQixXrCTDzPKwiy
   w==;
X-CSE-ConnectionGUID: 7JbVnEIGTwSW+VJwJI3LSg==
X-CSE-MsgGUID: +A+y49rpQ9OfcdtYLvT+Rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="83489289"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="83489289"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:20:29 -0700
X-CSE-ConnectionGUID: ZkojNB4gQnmAMM4oCMxNTw==
X-CSE-MsgGUID: jls9Un/gQyeUS4zqLX0/WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199391988"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:20:29 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 06:20:28 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 21 Aug 2025 06:20:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.51) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 06:20:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s4cUZwkc9cFhBjnTxYb8fyDNCO/Fq3ARgDIeeTRvRWzq1W8rL1PVIIj53Mr9i1Km1yUaUFcpI3pHVlHFPAlgSFZUsUKEJt8SWY2kH7ZKlF88Er1wqWDIrjuUNwjrjAW/pqjo55GUlueO+OZBpwj4ohkGesO6lrp8jTZZdBatdxgLdru4N8FDQkVUVRdWHpGyoqXiImLzM6WzhQI/HUQPCoNd+7LYpeZS+nEY9JX5LsiXtTH0YJBo79PEe6YIeET1hpIwNLlA7iOQA/Xt8N7YusAXDsaxKBwMse2qLUt+q8BW3/TJEVsRT+tmahIfVlainQNWlQXPUEjVP0F1G03yow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zPnoXt7/TPGRfgXiYdbBkIMO8fwpBJC67fLOPwpp0dg=;
 b=U1C3lXnEpWevBkDyTs6prCcNrmNcSEF8wbjchy4a5W05Gm40deawkyV4z51wgKnsvVbOuNCtUt6Bl3t0iSfoMFjkDETZqClNqo7xxdkn7mWj2O/oU4n72qdbyMj9l3JC2P3frbQqsnSVuACpdLWcImW8/eaYvOk31ZIFt8ZubkC/bqUo4jRu/phwI0I0MlXRfYuCpjl04uQ0wy+J2iVyATUrme5dhNFUb/lRy6hGVyFBbryytwwh541YG3gtOzc30T8VG87K0D1sdb0PtzG9qlEtSDZWsBcMuLYaSWa7vQQBP+xLfIP/3hrL66xT3WZ7kv9xmsBjspQ7RgATNcl3uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB5960.namprd11.prod.outlook.com (2603:10b6:510:1e3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 21 Aug
 2025 13:20:26 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 13:20:25 +0000
Date: Thu, 21 Aug 2025 21:20:13 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mlevitsk@redhat.com>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <xin@zytor.com>, Mathias Krause
	<minipli@grsecurity.net>, John Allen <john.allen@amd.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v12 06/24] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs
 support
Message-ID: <aKcdDQD8GWoYipbe@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
 <20250812025606.74625-7-chao.gao@intel.com>
 <aKS2WKBbZn6U1uqx@google.com>
 <aKWHRe4qli+GkqHh@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aKWHRe4qli+GkqHh@intel.com>
X-ClientProxiedBy: SG2PR02CA0119.apcprd02.prod.outlook.com
 (2603:1096:4:92::35) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: cfda0528-2f7d-4ad6-e092-08dde0b57d7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jegWJBMk8ncl0nPR7jOnDPQx2tu8ToSU0nCBIsLFWJk+n4IeiMra8GqYySSb?=
 =?us-ascii?Q?5zlPHz7KQkJt6XKgyx2qwNQeTGJf3uArjiJprCb2SkOkpMY7VhDIfX7tM6Vj?=
 =?us-ascii?Q?FwGDIbQXjGiQ5ULtxN9apRumQJmkXpZDskFEIJYGjMZp1pQslEu1/VONCuDT?=
 =?us-ascii?Q?oU5vk10W8mPsFe+NC45Y3ToouhLwbz3h7bubc++K0NRiU4/svu7znVGwNxzw?=
 =?us-ascii?Q?i3K89BdNe3rU+TKi0tnloSleUfYmQvzkHLdmUDE2imMwgYv7VWoBjpE1UQfI?=
 =?us-ascii?Q?1XXU7nqxNUgHOxAauf6n80EA08QB7p8f1T2RYv9Wn2zS03rfwcwfp09ZHT8F?=
 =?us-ascii?Q?vTovIgg9awmpFg3nuUQAT21v6D9rphYggrH6qaxmVkAp1uCChR1iMl7o/G/B?=
 =?us-ascii?Q?5C1XYTrMjOn3cFlL3tbUJM5MBM45ozVy/sPA7fLcGBVcVOT8NG0Tk4lSwtCp?=
 =?us-ascii?Q?0T82CzwZz/ZmCGjj8vhbAuSRA1m6cYfO32+JzJdDhGr8wn6uHXu+5PV9rYIK?=
 =?us-ascii?Q?rbnSlT3h8LlNwmm8315O/WsvdvWWaUGLWeomDFwZD3IUPtvYZM2yTiZhGWzi?=
 =?us-ascii?Q?nszM4+GA62KypEf8xc/yIdEA0DeNdcnUfd0vKepv9/yDtHoVzbX2pRw87R/Z?=
 =?us-ascii?Q?yjoIKO13j7Ll8YkcMuZu16wzHqFsnbRg7XPSBKWWVVLLJTH2bbHTCblJImQq?=
 =?us-ascii?Q?PnRx8qDJjxcz2f0iOEb9ZqM4v0600EnM8BaFU+nPyBZKh2zZPVF4HCdE4BZS?=
 =?us-ascii?Q?Hdcq3WiefTFbfNWa+FRbb+lepLPfzsUw1xrTpGIYy4+hzHQ485GpJiAl/i+Y?=
 =?us-ascii?Q?94a44OR5ex/76c8/biczSRu9rPcJVEshuUnY8iAWQEu9okfQ2g5xrQdyX7xl?=
 =?us-ascii?Q?Sq4hwcAW1CuFbuoUT7V2MOleije8Nixe5vNs5qSQ3kntUEzwvJdr3PDD40G6?=
 =?us-ascii?Q?7JdZBeCoLu0d2I3d3L5svZbZoS+WB57MJZwH4+0IqdrlYTx7QfnGfNWxa1v/?=
 =?us-ascii?Q?fK1DEzQiNGhoQg3TmkJmXNt2UGQcD5qGK1AKm/pzM6MN7SIXUJ9TNzBpPXzs?=
 =?us-ascii?Q?JTV20i8SzdA3xIs/cIIQwT5ZmMSCRqSfDsuBHLcaaNBLaDwoPCTkI0HzXyXR?=
 =?us-ascii?Q?tNfmVqiN+VUyf2JSYrlTaDKeu7fQGj+zLzjpQ7YdneRY7VZ4oKljA6lMl4qx?=
 =?us-ascii?Q?TWv6IDtxSjphIXVHwaU4aLo4Ew/RCb66APm+tLCBvZYkii2VJ5dMGGUXuDVF?=
 =?us-ascii?Q?grEd6KpofO3wb3uBE0PGrkRPhcp9vgW3ns0j/sKsVX3nX1MiHenl/nfCALjv?=
 =?us-ascii?Q?9jtonDjcfnUOIfrgGHEgYcMVoOqi0mq2p/wxwj+JVFha7eOTRTSR+Sodl8Fj?=
 =?us-ascii?Q?lt0KKUsE67YsPIzTMSxhmDVMrYM7a3KMmdvrVlJ9puS4Xk7J8g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F5EH2nVHibGb0XmHUwZVqvlYi2fzrqlvkQcOphxFBRobPQMgCc7SkRWtunsi?=
 =?us-ascii?Q?elU8fpwvLKFDef4Hsxs4OlwSF5A8bFRonsnxpzPdrWwq0NC1WwQs49GhEhcl?=
 =?us-ascii?Q?075AnDZ2GFceNTC1+ZK60TFs++2VsFvCROYcqFPyfwIbkNYb8rSa7tqZ5f0S?=
 =?us-ascii?Q?IFYCTcGJAjz3rZ9PoxYy5GzyBrOhiA/8PAkNsGf8+HB/snEx6zlWcXLTqO5u?=
 =?us-ascii?Q?oeTuA9QuNWR/IxsLK+vzd0U9zsvFv6mu6e6/rpa6RCm4AR7tfHk4rQt0z2u6?=
 =?us-ascii?Q?XNpFMyc6bDOTElAo7yLLvfpLI2T3UUAtfQPaDLICklSiOvFs17lQlgbSlG1m?=
 =?us-ascii?Q?fPaQwiHT5NtpuJb87jFEeW6oziSg+iq/Db/gh2TDWDUric7te9K4NOGWzNoa?=
 =?us-ascii?Q?egeIjudtbm4RAwiBM82v7PK+VEopjA0h+9Ek7f0xx5ynXqM87CxbWpzQbrtu?=
 =?us-ascii?Q?dryXKNIxdk5FgP/gZwnY9FfMzD2nAhf87kEtTREnUigtg6A1grtYf7hqw0K1?=
 =?us-ascii?Q?W2L0CEZzlj3Rw8RZ2W4L5Ih93MGInL+oVVk/QcglF0vpxTFF5m6Ncf+WaZjg?=
 =?us-ascii?Q?EVv9YD9xiiPEb46RL8j75t5PF04atlgvLNwGZwv1bSdcgVZbCsI5v6UeejQ5?=
 =?us-ascii?Q?P4mbWDvZXX9L8+LZriHjgSpFohEOuqzsGEh1KJbNdrLLBRMyrMgD1/wEDM/B?=
 =?us-ascii?Q?VwHAX+flRGjS04ddg294kb9nUCEq31efrqASxAorEAsirl1wHuB1ubRBBiDx?=
 =?us-ascii?Q?HbmpJxVjRkgew2hxcvhhbizl8wspOW08/BanRAbrG6HB0LZwJa0zvjRHq9Uu?=
 =?us-ascii?Q?FsgEAWqUSj0qXhpLPk9zo+5LFu3BTOychIsiOXPTHlSEQPLCYNiMvubjptIb?=
 =?us-ascii?Q?kNoxRKq/bJL+j0Y0iBYC/GPenmZKesAlkO4rPHnquZS+UC6u8Txd2gDzZVHH?=
 =?us-ascii?Q?/tHTp1jDmzu3jtTV83SPdS4+Rzh/0kLF+XLH6zn/4mFme1XgobDiXl1LH6hP?=
 =?us-ascii?Q?gXJ2iwdW1X2C9TZ6NftlinN+YcixHVyNq1ndDdoPaxrJOEygOMa66QPC5t7d?=
 =?us-ascii?Q?i4t4QVu/KIcAgRdl40H8P+EzUcB543gc/WsFKnRIx/8riWnJySTiRB+OW0lE?=
 =?us-ascii?Q?Moh57HPPQ1JuvzZsCLCY/9HwSd01MBkIyV/32lER8Ml7C2XBTYhYMqydWgBD?=
 =?us-ascii?Q?FlSvglAh0DPvFb2x77GPBdtWKiykuE3v7mGuuoq078pbXfVUt1ieeTMhRNCb?=
 =?us-ascii?Q?qpSZcnclT8h7wuwyb3tr8WjGSHmX5mMQq7iJMTsT8yxT2DP3+NHghljuI+Se?=
 =?us-ascii?Q?mWG8QsEMi7/Iu3F8meCZUSwDKk/3HTwVdIc6dEsACaZJLH1tguLpxI0hlu9u?=
 =?us-ascii?Q?Py1W5CTaxkTjjz3PRfPHN0GQ/cAwpZwLMnzv51QxgKbJmken+jrl5yjii95j?=
 =?us-ascii?Q?DHpiFKzw1zin18Z1PSz8oKJGv/Oe8jInxA32vRNRWwBHxRfb9CFREqaBKOPK?=
 =?us-ascii?Q?3AnCfSQw8Lpma60+VCYGj8I+dNdLAGGVWM77MPAqTFVxhXs6LwWN8RAsnHJA?=
 =?us-ascii?Q?qFTSDaMrPqK4u822DPLbvW5OnjX+j+FQmECVG5jy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cfda0528-2f7d-4ad6-e092-08dde0b57d7f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 13:20:25.7545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIhVkTXBVNk2Zi0w6l9AHstuzQ338zUkMtYHyBMzVHaNl9zkIV0vDFYXzssLwC0J770gA5MKumKWDMiNGmhbbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5960
X-OriginatorOrg: intel.com

On Wed, Aug 20, 2025 at 04:29:04PM +0800, Chao Gao wrote:
>>> +#define KVM_X86_REG_MSR			(1 << 2)
>>> +#define KVM_X86_REG_SYNTHETIC		(1 << 3)
>>> +
>>> +struct kvm_x86_reg_id {
>>> +	__u32 index;
>>> +	__u8 type;
>>> +	__u8 rsvd;
>>> +	__u16 rsvd16;
>>> +};
>>
>>Some feedback from a while back never got addressed[*].  That feedback still
>>looks sane/good, so this for the uAPI:
>
>I missed that comment. Below is the diff I end up with. I moved struct
>kvm_x86_reg_id to x86.c and added checks for ARCH (i.e., x86) and size.
>
>diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>index e72d9e6c1739..bb17b7a85159 100644
>--- a/arch/x86/include/uapi/asm/kvm.h
>+++ b/arch/x86/include/uapi/asm/kvm.h
>@@ -411,15 +411,23 @@ struct kvm_xcrs {
>	__u64 padding[16];
> };
> 
>-#define KVM_X86_REG_MSR			(1 << 2)
>-#define KVM_X86_REG_SYNTHETIC		(1 << 3)
>-
>-struct kvm_x86_reg_id {
>-	__u32 index;
>-	__u8 type;
>-	__u8 rsvd;
>-	__u16 rsvd16;
>-};
>+#define KVM_X86_REG_TYPE_MSR		2
>+#define KVM_X86_REG_TYPE_SYNTHETIC_MSR	3
>+
>+#define KVM_x86_REG_TYPE_SIZE(type)						\
>+{(										\

There are two typos here. s/x86/X86 and s/{(/({

>+	__u64 type_size = type;							\

and this should be __u64 type_size = (__u64)type << 32; 

When I tried to add a kselftest for the new ioctls, I found this patch didn't
advertise KVM_CAP_ONE_REG support for x86.

